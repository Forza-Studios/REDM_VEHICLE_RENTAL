-- COI Rental | NPC vehicle rentals with custom duration + auto-expiry
Config = {}

-- Rental clerk NPC
Config.NPC = {
    model = "MP_FM_BOUNTYTARGET_FEMALES_DLC008_01",
    coords = vector4(2907.3015, -1166.8540, 46.1329, 97.8817),
    scenario = "WORLD_HUMAN_SMOKE_INTERACTION",
}

-- Vehicle appears here
Config.VehicleSpawn = vector4(2902.3000, -1151.7689, 46.1766, 75.2453)

-- Prompt radius to open the rental board
Config.PromptRadius = 3.0

-- Map blip
Config.Blip = {
    name = "Vehicle Rental",
    sprite = 1012165077,
    scale = 0.6,
}

-- Duration limits (minutes). Player picks any value in this range.
Config.MinMinutes = 1
Config.MaxMinutes = 120
Config.DefaultMinutes = 15

-- Price formula: total = base + (perMin * minutes). Currency 0 = cash.
Config.Vehicles = {
    -- Coaches & stagecoaches
    { model = "coach2",          label = "Coach",            category = "Coaches",  base = 20, perMin = 1.5 },
    { model = "coach4",          label = "Coach 4",          category = "Coaches",  base = 20, perMin = 1.5 },
    { model = "coach5",          label = "Coach 5",          category = "Coaches",  base = 22, perMin = 1.5 },
    { model = "coach6",          label = "Coach 6",          category = "Coaches",  base = 22, perMin = 1.5 },
    { model = "stagecoach001x",  label = "Stagecoach I",     category = "Coaches",  base = 25, perMin = 2.0 },
    { model = "stagecoach002x",  label = "Stagecoach II",    category = "Coaches",  base = 25, perMin = 2.0 },
    { model = "stagecoach003x",  label = "Stagecoach III",   category = "Coaches",  base = 25, perMin = 2.0 },
    { model = "stagecoach004x",  label = "Stagecoach IV",    category = "Coaches",  base = 28, perMin = 2.0 },
    { model = "stagecoach005x",  label = "Stagecoach V",     category = "Coaches",  base = 28, perMin = 2.0 },
    { model = "stagecoach006x",  label = "Stagecoach VI",    category = "Coaches",  base = 30, perMin = 2.0 },
    { model = "buggy01",         label = "Buggy",            category = "Coaches",  base = 12, perMin = 1.0 },
    { model = "buggy02",         label = "Buggy II",         category = "Coaches",  base = 12, perMin = 1.0 },
    { model = "buggy03",         label = "Buggy III",        category = "Coaches",  base = 12, perMin = 1.0 },

    -- Wagons
    { model = "wagon02x",        label = "Wagon",            category = "Wagons",   base = 15, perMin = 1.0 },
    { model = "wagon03x",        label = "Wagon III",        category = "Wagons",   base = 15, perMin = 1.0 },
    { model = "wagon04x",        label = "Wagon IV",         category = "Wagons",   base = 15, perMin = 1.0 },
    { model = "wagon05x",        label = "Wagon V",          category = "Wagons",   base = 16, perMin = 1.0 },
    { model = "wagon06x",        label = "Wagon VI",         category = "Wagons",   base = 16, perMin = 1.0 },
    { model = "ArmySupplyWagon", label = "Supply Wagon",     category = "Wagons",   base = 18, perMin = 1.0 },
    { model = "supplywagon",     label = "Supply Wagon II",  category = "Wagons",   base = 18, perMin = 1.0 },
    { model = "chuckwagon000x",  label = "Chuckwagon",       category = "Wagons",   base = 18, perMin = 1.0 },
    { model = "utilliwag",       label = "Utility Wagon",    category = "Wagons",   base = 14, perMin = 1.0 },
    { model = "huntercart01",    label = "Hunter Cart",      category = "Wagons",   base = 14, perMin = 1.0 },
    { model = "wagonarmoured01x",label = "Armoured Wagon",   category = "Wagons",   base = 40, perMin = 3.0 },
    { model = "bountywagon01x",  label = "Bounty Wagon",     category = "Wagons",   base = 30, perMin = 2.0 },

    -- Carts
    { model = "cart01",          label = "Cart",             category = "Carts",    base = 8,  perMin = 0.5 },
    { model = "cart02",          label = "Cart II",          category = "Carts",    base = 8,  perMin = 0.5 },
    { model = "cart03",          label = "Cart III",         category = "Carts",    base = 8,  perMin = 0.5 },
    { model = "cart04",          label = "Cart IV",          category = "Carts",    base = 8,  perMin = 0.5 },
    { model = "cart05",          label = "Cart V",           category = "Carts",    base = 8,  perMin = 0.5 },
    { model = "cart06",          label = "Cart VI",          category = "Carts",    base = 8,  perMin = 0.5 },

    -- Boats
    { model = "canoe",           label = "Canoe",            category = "Boats",    base = 10, perMin = 0.8 },
    { model = "pirogue",         label = "Pirogue",          category = "Boats",    base = 10, perMin = 0.8 },
    { model = "rowboat",         label = "Rowboat",          category = "Boats",    base = 12, perMin = 0.8 },
    { model = "skiff",           label = "Skiff",            category = "Boats",    base = 12, perMin = 0.8 },
    { model = "keelboat",        label = "Keelboat",         category = "Boats",    base = 20, perMin = 1.2 },
}

Config.Notify = {
    title = "Vehicle Rental",
    dict = "generic_textures",
    icon = "tick",
    duration = 4000,
    color = "COLOR_WHITE",
}

Config.Debug = false
