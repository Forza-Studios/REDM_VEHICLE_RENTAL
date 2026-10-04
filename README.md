# COI Rental — Vehicle Rental Shop

NPC vehicle rentals with custom duration, live countdown HUD, VORP cash payment,
and auto-expiry. Supports native RDR3 wagons/coaches **and** addon rides from
`coi_vehicles` (land + air, water skipped).

## Location

- NPC: `2907.3015, -1166.8540, 46.1329, 97.8817` (`MP_FM_BOUNTYTARGET_FEMALES_DLC008_01`)
- Vehicle spawn: `2902.3000, -1151.7689, 46.1766, 75.2453`
- Blip sprite: `1012165077` ("Vehicle Rental")

## How it works

1. Hold **E** near the NPC to open the ledger NUI.
2. Pick a vehicle, set minutes (1–120, quick buttons 5/15/30/60).
3. Price = `base + perMin × minutes`, charged in VORP cash (currency 0).
4. Timer starts at purchase. Live countdown shows in the HUD + ledger.
5. On expiry the vehicle is deleted (native) or removed via the addon
   delete command. Hold **SPACE** near the NPC or use `/rental_return`
   to end early (no refund). One rental at a time.

## Dependencies

```
ensure vorp_core
ensure coi_vehicles   # required for addon entries
ensure coi_rental
```

`coi_vehicles` must start **before** `coi_rental` for addon spawns.

## Adding addon vehicles (dependency)

Addon rides come from:

**https://github.com/Forza-Studios/REDM_ADDON_VEHICLES**

That repo is the upstream vehicle pack backing `coi_vehicles`. To expose one
of its rides in the rental shop, add an entry to `Config.Addons` in
`coi_rental/config.lua`:

```lua
{ addon = "<coi_vehicles key>", label = "Display Name", category = "Cars", base = 40, perMin = 3.0 },
```

Rules:

- `addon` must exactly match a key in `coi_vehicles/config.lua`
  (`Config.Vehicles`), e.g. `hellcat`, `delorean`, `heli`, `biplane`.
  The rental uses that key with the addon's own spawn command, so any
  typo = "Unknown vehicle."
- `category` must match a ledger filter: `Cars`, `Bikes`, `Tanks`,
  `Aircraft` (plus native `Coaches`, `Wagons`, `Carts`).
- Water types are intentionally skipped (`boat` → `bigboat`, `lamboboat`,
  `biggerboat`, `speedboat`, `jetski`). Don't add them.
- Pricing is rental-side only (`base` + `perMin × minutes`); handling stays
  in the addon pack.
- Stream files (`.ytyp`/`.ydr` from the upstream repo's LML stream folder)
  must be present in `coi_vehicles/stream`, or the model won't load and the
  rent fails with "Failed to load vehicle."

How the wiring works:

- Rent: `coi_rental` charges VORP cash server-side, then runs
  `ExecuteCommand("<AddonSpawnCommand> <key> <x> <y> <z> <heading>")`
  (default `get`, see `Config.AddonSpawnCommand`) with
  `Config.VehicleSpawn`, so **every** rental — native or addon — lands on
  the same pad. The addon pack accepts the optional coords (player-relative
  when omitted, so plain `/get <name>` still works as before).
- Expiry/return: runs `ExecuteCommand("<AddonDeleteCommand>")` (default
  `delete_balboni`, see `Config.AddonDeleteCommand`).
- If `coi_vehicles` isn't started you get "Addon garage offline."

## Commands / prompts

- Hold **E** near NPC: open ledger
- Hold **SPACE** near NPC (rental active): end rental
- `/rental_return`: end rental anywhere (no refund)
- Addon pack keeps its own `/get <name>` spawns; rental just wraps them
  with payment + timer.
