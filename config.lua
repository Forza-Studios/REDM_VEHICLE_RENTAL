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
}

-- Addon rides from coi_vehicles (land + air only, water skipped).
-- Spawned via coi_vehicles "/get <key>", removed via "delete_balboni".
-- NOTE: addon stream files (.ytyp) must be present or the model won't load.
Config.AddonSpawnCommand = "get"
Config.AddonDeleteCommand = "delete_balboni"

Config.Addons = {
    -- Cars (land)
    { addon = "truck",        label = "Truck",          category = "Cars",     base = 30, perMin = 2.0 },
    { addon = "truckLifted",  label = "Truck Lifted",   category = "Cars",     base = 35, perMin = 2.0 },
    { addon = "atv",          label = "ATV",            category = "Cars",     base = 25, perMin = 1.5 },
    { addon = "delorean",     label = "Delorean",       category = "Cars",     base = 60, perMin = 4.0 },
    { addon = "roadster",     label = "Roadster",       category = "Cars",     base = 55, perMin = 4.0 },
    { addon = "franklin",     label = "Franklin",       category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "michael",      label = "Michael",        category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "trevor",       label = "Trevor",         category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "bat",          label = "Batmobile",      category = "Cars",     base = 60, perMin = 4.0 },
    { addon = "batclassic",   label = "Batmobile Classic", category = "Cars", base = 55, perMin = 4.0 },
    { addon = "lancer",       label = "Lancer",         category = "Cars",     base = 40, perMin = 3.0 },
    { addon = "ironsport",    label = "Iron Sport",     category = "Cars",     base = 50, perMin = 3.5 },
    { addon = "ironcharger",  label = "Iron Charger",   category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "ironimpala",   label = "Iron Impala",    category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "ironstang",    label = "Iron Stang",     category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "iron65stang",  label = "Iron 65 Stang",  category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "irontruck",    label = "Iron Truck",     category = "Cars",     base = 35, perMin = 2.5 },
    { addon = "ironbigtruck", label = "Iron Big Truck", category = "Cars",     base = 40, perMin = 2.5 },
    { addon = "policesuv",    label = "Police SUV",     category = "Cars",     base = 40, perMin = 3.0 },
    { addon = "muscle",       label = "Muscle",         category = "Cars",     base = 45, perMin = 3.0 },
    { addon = "hellcat",      label = "Hellcat",        category = "Cars",     base = 55, perMin = 4.0 },
    { addon = "cyberhorse",   label = "Cyber Horse",    category = "Cars",     base = 50, perMin = 3.5 },
    { addon = "ironhorse",    label = "Iron Horse",     category = "Cars",     base = 40, perMin = 3.0 },
    { addon = "ironprime",    label = "Iron Prime",     category = "Cars",     base = 40, perMin = 3.0 },
    { addon = "ironrancher",  label = "Iron Rancher",   category = "Cars",     base = 40, perMin = 3.0 },
    { addon = "ironsuv",      label = "Iron SUV",       category = "Cars",     base = 40, perMin = 3.0 },
    { addon = "vapidfordor",  label = "Vapid 4-Door",   category = "Cars",     base = 35, perMin = 2.5 },
    { addon = "vapidtudor",   label = "Vapid 2-Door",   category = "Cars",     base = 35, perMin = 2.5 },
    { addon = "gtr",          label = "GTR",            category = "Cars",     base = 55, perMin = 4.0 },
    { addon = "malibu",       label = "Malibu",         category = "Cars",     base = 40, perMin = 3.0 },
    { addon = "lambo",        label = "Lambo",          category = "Cars",     base = 60, perMin = 4.5 },
    { addon = "classic",      label = "Classic",        category = "Cars",     base = 35, perMin = 2.5 },
    { addon = "classic2",     label = "Classic II",     category = "Cars",     base = 35, perMin = 2.5 },
    { addon = "sandrail",     label = "Sand Rail",      category = "Cars",     base = 30, perMin = 2.0 },

    -- Bikes (land)
    { addon = "dirtbike",     label = "Dirt Bike",      category = "Bikes",    base = 15, perMin = 1.0 },
    { addon = "policebike",   label = "Police Bike",    category = "Bikes",    base = 18, perMin = 1.2 },
    { addon = "micahcycle",   label = "Micah Cycle",    category = "Bikes",    base = 12, perMin = 1.0 },

    -- Tank (land)
    { addon = "irontank",     label = "Iron Tank",      category = "Tanks",    base = 100, perMin = 6.0 },

    -- Aircraft (air)
    { addon = "biplane",      label = "Biplane",        category = "Aircraft", base = 80, perMin = 5.0 },
    { addon = "biplane2",     label = "Biplane II",     category = "Aircraft", base = 80, perMin = 5.0 },
    { addon = "triplane",     label = "Triplane",       category = "Aircraft", base = 90, perMin = 5.0 },
    { addon = "heli",         label = "Heli",           category = "Aircraft", base = 100, perMin = 6.0 },
    { addon = "heli2",        label = "Heli II",        category = "Aircraft", base = 100, perMin = 6.0 },
    { addon = "xwing",        label = "X-Wing",         category = "Aircraft", base = 150, perMin = 8.0 },
    { addon = "a10",          label = "A-10",           category = "Aircraft", base = 150, perMin = 8.0 },
    { addon = "osprey",       label = "Osprey",         category = "Aircraft", base = 140, perMin = 7.0 },
    { addon = "cargobob",     label = "Cargobob",       category = "Aircraft", base = 140, perMin = 7.0 },
}

Config.Notify = {
    title = "Vehicle Rental",
    dict = "generic_textures",
    icon = "tick",
    duration = 4000,
    color = "COLOR_WHITE",
}

Config.Debug = false
