# TASK EQUIPSLOTS1B (S215) - bought equipment stands in its slot on the 3D floor; build mode shows the slots; zone full / replace in the shop

Model: Cursor (composer). Worktree E:/FightCamp/wt/EQUIPSLOTS1B (seed: Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\EQUIPSLOTS1B),
branch cursor/equipslots1b from current master. Never master.

## The defect this fixes
EQUIPSLOTS1A (merged c7ab1ea1) gave every equipment instance a `slot_id` (data in `assets/data/club_layouts/s206.json` `slots` +
`slots_by_tier`, rules in `scripts/club_capacity/EquipSlots.gd`). But the 3D floor (`scripts/GymClub3D.gd`, 2,242 lines - `_prop_for`
~L178, `_place_model` ~L591) never reads `slot_id`: a bought machine still lands on the old invisible grid, and the shop
(`scripts/GymHubPanel.gd`, 1,021 lines - `_on_buy` ~L907, `_apply` ~L915) never says ZONE FULL or offers REPLACE.

## Spec (operator-approved Ludo r45 verdict, LUDO_ROUND45_VERDICT_S212.md TAKEN 3, 4, 8 - read it)
1. 3D: an equipment instance with a `slot_id` stands at that slot's `pos` / `yaw_deg` / `mount` (beam = hung from the beam line, wall,
   floor, ring). Instances without one (old saves) keep today's placement.
2. Build mode (only while the equipment panel is open): empty valid slots = pulsing cyan footprint (`footprint` w x d on the floor),
   occupied = muted outline. Closing the panel removes the overlay. The pulse animates (operator S212: animated meters/feedback).
3. Shop: a zone-full buy is greyed with "ZONE FULL (CARDIO 4/4) - replace a station or move to the bigger gym (T2)" (numbers from
   `EquipSlots.zone_usage`); REPLACE calls `replace_equipment(instance_id, catalog_id)`. Hidden catalog rows (store_available false /
   `requires`) never appear.
4. Shop layout: catalog drawer on the left, the 3D floor stays live on the right (no separate store page); header shows tier and
   stations used/total.
5. No new prices, gains or queue numbers (verdict CHANGED/REFUSED). The peak-hour queue mechanic is part C, not this task.

## Test (write first; red on master)
`tests/equip_slots_floor_test.gd`: buy 3 items into a T1 club (two different categories, one into a nearly full zone) -> each 3D
prop's global position is within 0.05 m of its slot `pos` and yaw within 2 deg; a full zone's buy returns ok=false with the ZONE FULL
reason and its shop row is disabled; replace swaps the prop in the same slot; build mode on -> one overlay node per empty slot, off -> zero.

## Stills (LUDO GATE - the plan is approved; the RESULT goes to Ludo then the operator)
Windowed via Tools\godot_hidden.ps1 on the game camera (`as_game`): (a) floor before/after buying 3 items, (b) build mode open with
the cyan footprints, (c) a ZONE FULL row. Save to `previews/equipslots1b/`. You cannot see images: report pixel facts
(prop positions vs slots, overlay node counts), Claude opens the stills.

## Run
Parse gate on every touched .gd, the new test, then `python Godot/tools/run_tests.py --jobs 2 --only equip,club_fill,equipment,purchase,market,club_capacity,gym_club,gym_hub`
(`--jobs 1` when the watchdog is not GREEN) - nothing green goes red. EQUIPSLOTS1B_DIGEST.md; commit; push cursor/equipslots1b.

## Owned files
- Godot/scripts/GymClub3D.gd (placement only; grep + sed -n windows)
- Godot/scripts/GymHubPanel.gd
- Godot/scripts/club_capacity/ (new helper scripts allowed, e.g. EquipSlotOverlay.gd)
- Godot/tests/equip_slots_floor_test.gd (NEW), previews/equipslots1b/, research/EQUIPSLOTS1B_DIGEST.md (NEW)
- NOT GameState.gd (19,876 lines - call its existing purchase_equipment / replace_equipment; if a getter is missing, say so in the digest)

## Prior research
LUDO_ROUND45_VERDICT_S212.md, TASK_EQUIPSLOTS1A.md, EQUIPMOTION1A (machines in use), GYMLAYOUT1 (S201 authored layouts - operator:
author layouts, do not pack).

## What would a human do?
A gym owner buying a treadmill sees on the floor plan where it will stand before paying, and is told plainly when the cardio corner is full.

## Prefab check
None - our club scene; the overlay is a flat mesh/decal per slot.

## Rules
Watchdog before every Godot run (RED = wait); windowed only via Tools\godot_hidden.ps1; headless Godot_v4.7.2-stable_win64.exe only
(never _console.exe); no image viewers/start/explorer. `git add -- <files>`.

## The one trap
GymClub3D rebuilds the floor on every gym change: place by slot in the SAME builder path, or a bought item jumps back to the grid on
the next rebuild.
