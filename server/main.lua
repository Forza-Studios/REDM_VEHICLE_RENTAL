-- COI Rental | server: price validation + VORP cash handling
local Core = nil
TriggerEvent("getCore", function(core)
    Core = core
end)
if not Core and exports.vorp_core then
    pcall(function() Core = exports.vorp_core:GetCore() end)
end

local function FindVehicle(model)
    for _, v in ipairs(Config.Vehicles) do
        if v.model == model then
            return v
        end
    end
    return nil
end

local function CalcTotal(entry, minutes)
    minutes = math.floor(tonumber(minutes) or 0)
    minutes = math.max(Config.MinMinutes, math.min(Config.MaxMinutes, minutes))
    return (entry.base or 0) + (entry.perMin or 0) * minutes, minutes
end

-- Client asks to rent: validate, charge, approve spawn
RegisterNetEvent("coi_rental:server:requestRent", function(model, minutes)
    local src = source
    local entry = FindVehicle(model)
    if not entry then
        TriggerClientEvent("coi_rental:client:notify", src, "Unknown vehicle.")
        return
    end

    local total, cleanMinutes = CalcTotal(entry, minutes)

    if not Core then
        TriggerClientEvent("coi_rental:client:notify", src, "Rental service unavailable.")
        return
    end

    local user = Core.getUser(src)
    if not user then
        TriggerClientEvent("coi_rental:client:notify", src, "Rental service unavailable.")
        return
    end
    local character = user.getUsedCharacter
    if not character then
        TriggerClientEvent("coi_rental:client:notify", src, "Rental service unavailable.")
        return
    end

    local cash = character.money or 0
    if cash < total then
        TriggerClientEvent("coi_rental:client:notify", src, ("Not enough cash (need $%.2f)."):format(total))
        TriggerClientEvent("coi_rental:client:rentDenied", src)
        return
    end

    character.removeCurrency(0, total)
    TriggerClientEvent("coi_rental:client:rentApproved", src, entry.model, cleanMinutes, total)
end)
