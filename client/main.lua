-- COI Rental | client: NPC, blip, prompt, NUI board, spawn + expiry timer
local npc = nil
local npcBlip = nil
local rentPrompt = nil
local returnPrompt = nil
local rental = nil -- { entity|nil, expiresAt, label, model|addonKey, minutes, total, kind }

local function HasActiveRental()
    if not rental then return false end
    if rental.kind == "addon" then return true end
    return rental.entity and DoesEntityExist(rental.entity)
end

local function Dbg(msg)
    if Config.Debug then print("[coi_rental] " .. msg) end
end

RegisterNetEvent("coi_rental:client:notify", function(msg)
    if GetResourceState("vorp_core") == "started" then
        pcall(function()
            TriggerEvent("vorp:NotifyLeft",
                Config.Notify.title, msg,
                Config.Notify.dict, Config.Notify.icon,
                Config.Notify.duration, Config.Notify.color)
        end)
    end
    Dbg(msg)
end)

local function BlipForCoords(style, x, y, z)
    if BlipAddForCoords then
        return BlipAddForCoords(style, x, y, z)
    end
    return Citizen.InvokeNative(0x554D9D53F696D002, style, x, y, z)
end

local function SpawnNPC()
    local n = Config.NPC
    local hash = joaat(n.model)
    if not IsModelValid(hash) then
        print("[coi_rental] invalid NPC model: " .. n.model)
        return
    end
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 10000 do
        Wait(50)
        timeout = timeout + 50
    end
    if not HasModelLoaded(hash) then
        print("[coi_rental] NPC model failed to load")
        return
    end
    local ped = CreatePed(hash, n.coords.x, n.coords.y, n.coords.z - 1.0, n.coords.w, false, false, false, false)
    timeout = 0
    while (not DoesEntityExist(ped) or ped == 0) and timeout < 5000 do
        Wait(100)
        timeout = timeout + 100
    end
    if not DoesEntityExist(ped) then return end
    npc = ped
    SetRandomOutfitVariation(ped, true)
    TaskStartScenarioInPlace(ped, joaat(n.scenario or "WORLD_HUMAN_SMOKE_INTERACTION"), -1, true, false, false, false)
    Wait(1000)
    FreezeEntityPosition(ped, true)
    SetEntityCanBeDamaged(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(hash)
    Dbg("NPC spawned")
end

local function AddNpcBlip()
    local c = Config.NPC.coords
    if npcBlip and DoesBlipExist(npcBlip) then RemoveBlip(npcBlip) end
    npcBlip = BlipForCoords(1664425300, c.x, c.y, c.z)
    if npcBlip then
        if SetBlipSprite then SetBlipSprite(npcBlip, Config.Blip.sprite, true)
        else Citizen.InvokeNative(0x74F74D3207ED525C, npcBlip, Config.Blip.sprite, true) end
        if SetBlipName then SetBlipName(npcBlip, Config.Blip.name)
        else Citizen.InvokeNative(0x9CB1A1623062F402, npcBlip, Config.Blip.name) end
        if SetBlipScale then SetBlipScale(npcBlip, Config.Blip.scale or 0.6)
        else Citizen.InvokeNative(0xD387445136465429, npcBlip, Config.Blip.scale or 0.6) end
    end
end

local function OpenBoard()
    SetNuiFocus(true, true)
    local active = nil
    if HasActiveRental() then
        active = {
            label = rental.label,
            model = rental.model,
            remainingSec = math.max(0, math.floor((rental.expiresAt - GetGameTimer()) / 1000)),
        }
    end
    -- Merge native (land) + addon (land/air, water skipped) into one NUI list
    local list = {}
    for _, v in ipairs(Config.Vehicles) do
        list[#list + 1] = { model = v.model, label = v.label, category = v.category, base = v.base, perMin = v.perMin, kind = "native" }
    end
    for _, a in ipairs(Config.Addons or {}) do
        list[#list + 1] = { model = a.addon, label = a.label, category = a.category, base = a.base, perMin = a.perMin, kind = "addon", addon = a.addon }
    end
    SendNUIMessage({
        action = "open",
        vehicles = list,
        minMinutes = Config.MinMinutes,
        maxMinutes = Config.MaxMinutes,
        defaultMinutes = Config.DefaultMinutes,
        activeRental = active,
    })
end

local function CloseBoard()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
end

local function DeleteRental(silent)
    if rental then
        if rental.kind == "addon" then
            pcall(ExecuteCommand, Config.AddonDeleteCommand or "delete_balboni")
        elseif rental.entity and DoesEntityExist(rental.entity) then
            SetEntityAsMissionEntity(rental.entity, true, true)
            DeleteVehicle(rental.entity)
        end
    end
    rental = nil
    SendNUIMessage({ action = "hideHud" })
    if not silent then
        TriggerEvent("coi_rental:client:notify", "Rental returned.")
    end
end

local function SpawnRental(model, minutes, total, kind, addon)
    DeleteRental(true)
    local label = model
    if kind == "addon" then
        for _, a in ipairs(Config.Addons or {}) do
            if a.addon == addon then label = a.label break end
        end
        if GetResourceState("coi_vehicles") ~= "started" then
            TriggerEvent("coi_rental:client:notify", "Addon garage offline (start coi_vehicles).")
            return
        end
        -- Fixed pad spawn: everything lands on Config.VehicleSpawn
        local s = Config.VehicleSpawn
        ExecuteCommand(("%s %s %.4f %.4f %.4f %.4f"):format(
            Config.AddonSpawnCommand or "get", tostring(addon), s.x, s.y, s.z, s.w))
        rental = { entity = nil, expiresAt = GetGameTimer() + (minutes * 60000), label = label, model = addon, minutes = minutes, total = total, kind = "addon" }
        SendNUIMessage({ action = "tick", label = label, remainingSec = minutes * 60 })
        TriggerEvent("coi_rental:client:notify",
            ("Rented %s for %d min ($%.2f). It vanishes when time runs out."):format(label, minutes, total))
        Dbg(("spawned addon %s for %d min"):format(tostring(addon), minutes))
        return
    end
    local s = Config.VehicleSpawn
    local hash = joaat(model)
    if not IsModelValid(hash) then
        TriggerEvent("coi_rental:client:notify", "Invalid vehicle model.")
        return
    end
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 15000 do
        Wait(50)
        timeout = timeout + 50
    end
    if not HasModelLoaded(hash) then
        TriggerEvent("coi_rental:client:notify", "Failed to load vehicle.")
        return
    end
    local veh = CreateVehicle(hash, s.x, s.y, s.z, s.w, true, true, false, false)
    timeout = 0
    while (not DoesEntityExist(veh) or veh == 0) and timeout < 5000 do
        Wait(100)
        timeout = timeout + 100
    end
    SetModelAsNoLongerNeeded(hash)
    if not DoesEntityExist(veh) then
        TriggerEvent("coi_rental:client:notify", "Failed to spawn vehicle.")
        return
    end
    SetEntityAsMissionEntity(veh, true, true)
    if Citizen.InvokeNative(0x8CA2D9D0C290AC50, veh) then -- _SET_VEHICLE_ON_GROUND_PROPERLY (guarded)
    end
    pcall(SetVehicleOnGroundProperly, veh)
    local label = model
    for _, v in ipairs(Config.Vehicles) do
        if v.model == model then label = v.label break end
    end
    rental = { entity = veh, expiresAt = GetGameTimer() + (minutes * 60000), label = label, model = model, minutes = minutes, total = total, kind = "native" }
    SendNUIMessage({ action = "tick", label = label, remainingSec = minutes * 60 })
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    TriggerEvent("coi_rental:client:notify",
        ("Rented for %d min ($%.2f). It vanishes when time runs out."):format(minutes, total))
    Dbg(("spawned %s for %d min"):format(model, minutes))
end

-- Expiry watchdog: destroy when the timer runs out (timer starts at purchase)
-- Also pushes live countdown ticks to the HUD every tick.
CreateThread(function()
    local warned = false
    while true do
        Wait(5000)
        if rental then
            local gone = false
            if rental.kind ~= "addon" then
                gone = not (rental.entity and DoesEntityExist(rental.entity))
            end
            if gone then
                rental = nil
                warned = false
                SendNUIMessage({ action = "hideHud" })
            else
                local left = rental.expiresAt - GetGameTimer()
                if left <= 0 then
                    DeleteRental(true)
                    warned = false
                    TriggerEvent("coi_rental:client:notify", "Rental time expired. Vehicle collected.")
                    SendNUIMessage({ action = "expired" })
                else
                    SendNUIMessage({ action = "tick", label = rental.label, remainingSec = math.floor(left / 1000) })
                    if left < 60000 and not warned then
                        warned = true
                        TriggerEvent("coi_rental:client:notify", "Rental expires in 1 minute.")
                    end
                end
            end
        else
            Wait(5000)
        end
    end
end)

-- Smooth 1s HUD countdown (board can stay closed, HUD always shows it)
CreateThread(function()
    while true do
        Wait(1000)
        if HasActiveRental() then
            local left = rental.expiresAt - GetGameTimer()
            if left > 0 then
                SendNUIMessage({ action = "tick", label = rental.label, remainingSec = math.floor(left / 1000) })
            end
        else
            Wait(2000)
        end
    end
end)

-- Prompts near the NPC: rent board always, plus END RENTAL when one is active
CreateThread(function()
    rentPrompt = PromptRegisterBegin()
    PromptSetControlAction(rentPrompt, 0xCEFD9220) -- E / INPUT_CONTEXT_A
    PromptSetText(rentPrompt, CreateVarString(10, "LITERAL_STRING", "Rent vehicle"))
    PromptSetVisible(rentPrompt, false)
    PromptSetEnabled(rentPrompt, false)
    PromptSetHoldMode(rentPrompt, 800)
    PromptRegisterEnd(rentPrompt)

    returnPrompt = PromptRegisterBegin()
    PromptSetControlAction(returnPrompt, 0xD9D0E1C0) -- SPACE / INPUT_VEH_DIVE (separate key so both show)
    PromptSetText(returnPrompt, CreateVarString(10, "LITERAL_STRING", "End rental"))
    PromptSetVisible(returnPrompt, false)
    PromptSetEnabled(returnPrompt, false)
    PromptSetHoldMode(returnPrompt, 800)
    PromptRegisterEnd(returnPrompt)

    while true do
        Wait(0)
        local nearNpc = false
        if npc and DoesEntityExist(npc) then
            local d = #(GetEntityCoords(PlayerPedId()) - vector3(Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z))
            if d < Config.PromptRadius then
                nearNpc = true
            end
        end
        local hasRental = HasActiveRental()
        local showRent = nearNpc
        local showReturn = nearNpc and hasRental

        PromptSetVisible(rentPrompt, showRent)
        PromptSetEnabled(rentPrompt, showRent)
        PromptSetVisible(returnPrompt, showReturn)
        PromptSetEnabled(returnPrompt, showReturn)

        if showRent and PromptHasHoldModeCompleted(rentPrompt) then
            OpenBoard()
            Wait(1000)
        elseif showReturn and PromptHasHoldModeCompleted(returnPrompt) then
            DeleteRental(false)
            SendNUIMessage({ action = "hideHud" })
            Wait(1000)
        end
    end
end)

RegisterNetEvent("coi_rental:client:rentApproved", function(model, minutes, total, kind, addon)
    CloseBoard()
    SpawnRental(model, minutes, total, kind, addon)
end)

RegisterNetEvent("coi_rental:client:rentDenied", function()
    SendNUIMessage({ action = "denied" })
end)

RegisterNUICallback("rent", function(data, cb)
    if data and data.model then
        TriggerServerEvent("coi_rental:server:requestRent", data.model, tonumber(data.minutes) or Config.DefaultMinutes, data.kind, data.addon)
    end
    cb({ ok = true })
end)

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNUICallback("endRental", function(_, cb)
    DeleteRental(false)
    SendNUIMessage({ action = "hideHud" })
    CloseBoard()
    cb({ ok = true })
end)

-- Early return (no refund)
RegisterCommand("rental_return", function()
    if rental then
        DeleteRental(false)
    else
        TriggerEvent("coi_rental:client:notify", "No active rental.")
    end
end, false)

RegisterNetEvent("vorp:SelectedCharacter", function()
    if not npc or not DoesEntityExist(npc) then SpawnNPC() end
    AddNpcBlip()
end)

CreateThread(function()
    Wait(5000)
    if not npc or not DoesEntityExist(npc) then SpawnNPC() end
    AddNpcBlip()
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    SetNuiFocus(false, false)
    DeleteRental(true)
    if npc and DoesEntityExist(npc) then DeletePed(npc) end
    npc = nil
    if npcBlip and DoesBlipExist(npcBlip) then RemoveBlip(npcBlip) end
    npcBlip = nil
    if rentPrompt then PromptDelete(rentPrompt) rentPrompt = nil end
    if returnPrompt then PromptDelete(returnPrompt) returnPrompt = nil end
end)
