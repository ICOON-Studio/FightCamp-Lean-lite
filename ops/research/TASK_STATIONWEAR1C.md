# TASK STATIONWEAR1C (S219) - worn stations can hurt a fighter or break; the station card shows wear with SERVICE / REPLACE

Model: Grok Dev (Grok Bot app chat "Grok Dev"; own Linux box, Godot 4.7.2, clones without LFS). Branch grok/stationwear1c from
master (STATIONWEAR1B is merged: 6527de9e). Open a PR, never merge. Switch `station_wear` stays OFF (GameSwitches.DEFAULT_OFF):
everything below happens only when it is ON; OFF stays byte-identical (prove it like 1B did).

## Why
Operator S200/S202: equipment wears and the player maintains it (EQUIPMOTION/ATTRITION line); 1B made a worn station train less.
1C finishes the loop the player sees: risk (injury / breakdown) and the buttons to fix it.

## Files
- `Godot/scripts/StationIntegrity.gd` (pure, read whole - ~200 lines): `band()` already carries injury_chance, injury_kind,
  breakdown_chance per band (good .0005 minor / worn .0035 minor_strain / damaged .02 wrist_sprain / failing .02 + breakdown .05).
  NO RNG in it - rolls arrive as arguments.
- `Godot/scripts/GameState.gd` (~20k lines, NEVER whole): the 1B block (grep `STATIONWEAR1B`, `apply_station_wear`, the TODO naming
  STATIONWEAR1C) and how injuries are written today (grep `add_injury` / `injuries` / `apply_injury`).
- `Godot/scripts/StationInfoCard.gd` (266 lines): `equipment_condition_line()` line 147 reads the OLD `condition` key - switch ON must
  read `get_equipment_integrity()` instead.

## Do
1. Session outcome (ON only): after `apply_station_wear` for a station, roll once per training session on that station with the
   band of the integrity BEFORE the session: injury with injury_chance -> the athlete gets that injury_kind through the game's existing
   injury path (severity = the smallest the path allows for minor/minor_strain; a wrist_sprain = the path's light sprain); breakdown
   with breakdown_chance -> the station is "broken" (integrity 0, flag `broken: true`): DayLap must skip a broken station (0 gain) and
   the day feed gets one line ("The treadmill broke down - service or replace it"). Rolls come from the game's seeded RNG for the day
   (determinism: same seed, same outcome). A pure helper `StationIntegrity.session_outcome(integrity, item, injury_roll,
   breakdown_roll) -> {injury_kind or "", broke: bool}` keeps the maths testable.
2. Station card (ON only): an animated integrity bar (tween + band-colour change pulse - house rule "every bar tweens"), the band name,
   "about N training hours before it is worn", and two buttons SERVICE ($maintenance_cost -> 95) / REPLACE ($purchase_cost -> 100)
   calling 1B's `service_equipment` / `replace_equipment_worn`; disabled with the reason when cash is short; a broken station shows
   "BROKEN" in red and only these two actions. OFF: the card is exactly today's.
3. Test `Godot/tests/station_wear_risk_test.gd`: session_outcome per band at roll edges (just below / at the chance); a seeded day with
   a failing bag breaks it and the next day's gain on it is 0; an injury lands on the athlete through the real path; OFF arm byte-
   identical (day results + card text); SERVICE/REPLACE through the card's handlers move cash and integrity like 1B's test; a mutant
   (breakdown ignored) reads red.
4. Parse gate `python Godot/tools/check_scripts.py <touched .gd>`; `python Godot/tools/run_tests.py --jobs 2 --only station,day_lap,
   daylap,equip,injur,game_switches`. Paste every PASS line in the PR.

## VISUAL GATE
UI card only (no body/animation): Claude renders the station card on the PC and opens it; the operator closes it.

## Prior research
TASK_STATIONWEAR1A.md / 1B.md, StationIntegrity.gd header (the real-gym wear rates), ATTRITION1 notes.

## Prefab check
None - our own systems.

## The one trap
Never let a roll happen with the switch OFF (that would change every existing seeded day and break the byte-identical OFF arm).
