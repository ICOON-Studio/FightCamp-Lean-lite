# TASK STATIONWEAR1E (S220) - Ludo round 56 fixes: new wear numbers, 5 bands, SERVICE +50, a short boxing-only card

Model: Grok Dev (Grok Bot app chat "Grok Dev"). Branch grok/stationwear1e from master (STATIONWEAR1D merged 7f7942d6). PR, never merge.
Switch `station_wear` stays OFF by default; every change below is behind it (OFF = today's behaviour, byte-identical card text).
Approved: operator board Q-S219-2 "Approve (recommended)" on research/LUDO_ROUND56_VERDICT_S220.md (read it - items 1-7).

## Owned files (line counts at master 7f7942d6)
- Godot/scripts/StationIntegrity.gd (261) - consts at lines 61-78, band() 136, service() 190, session_outcome_for_item() 228.
- Godot/scripts/StationInfoCard.gd (510) - build() ~line 80-115, _add_integrity_section ~221, pinned card ~295-410.
- Godot/scripts/GameState.gd - NEVER read whole (9k+ lines): only `sed -n '4320,4500p'` (station wear block: day loop 4361-4400,
  service/replace 4425-4466, get_equipment_integrity 4467).
- Tests: station_integrity_test.gd (326), station_wear_day_test.gd (135), station_wear_risk_test.gd (220), station_card_pin_test.gd (235).

## Do
1. Wear %/athlete-hour (StationIntegrity consts): speed_bag 0.45, treadmill 0.35, power rack 0.04, grappling mats 0.10, bags 0.20,
   other cardio 0.40, strength 0.08, ring 0.15, recovery/analysis/unknown 0.06 (was 0.0 - WEAR_NONE goes away for those).
2. Bands (edges belong to the higher band): good >=75 (x1.00, injury 0.0005 `minor`), worn >=45 (x0.85, 0.004 `minor_strain`),
   damaged >=20 (x0.65, 0.0125 `wrist_sprain`), failing >0 (x0.40, 0.035 `wrist_sprain`, breakdown 0.05), out_of_use = 0 or broken
   (x0.0, cannot train - DayLap already reads BROKEN_INTEGRITY as gain x0). A breakdown sets integrity 0 + broken, ends that session,
   and injures through the EXISTING injury path with severity from the injury roll: < 0.60 minor (7 days), < 0.95 moderate (21 days),
   else severe (45 days) - use the path's own severity names/days if they exist, report what you mapped.
3. SERVICE: integrity = min(95, current + 50) for maintenance_cost (signature becomes service(item, current_integrity)). A BROKEN
   station: SERVICE becomes OVERHAUL at 1.5x maintenance_cost (round down), same +50 from 0. REPLACE unchanged (100, purchase_cost).
4. Card (switch ON only), max 360 x 390 px, order: header row (name, footprint "1x2 M", band pill, the close X INSIDE the header at
   the top-right, 32 px, only on a pinned card) -> integrity bar (10-step, tweened) + "ABOUT N TRAINING HOURS BEFORE IT IS WORN" ->
   impact line "GAINS x0.65 - INJURY 1.25% / SESSION" -> attributes trained as chips -> "UPKEEP $x / WK" + SERVICE / REPLACE.
   CUT for the boxing demo: BEST FOR (kickboxing / muay thai / karate) and the long YOUR FIT text; one grey chip "FIT: BOXING x1.0"
   (#9E9284). The band shows in ONE place (the pill) from the table in item 2.
5. SERVICE disabled at the cap (>= 95): tooltip "Already at the service limit - REPLACE for 100%". Label shows the gain:
   "SERVICE $220 (+50%)", "OVERHAUL $330" when broken.
6. Tests: these four tests pin the OLD numbers by contract - update them to THIS contract (it was re-approved), keep every mutant check
   (rule order, edge >=), add: 75 is good / 74.99 worn / 45 worn / 44.99 damaged / 0.01 failing / 0 out_of_use; service(…, 60) = 95,
   service(…, 22) = 72; broken -> OVERHAUL 1.5x; SERVICE disabled at 95; card height <= 390 at 1920x1080; no "KICKBOXING" text on the
   card. OFF arm: card text byte-identical to master.
7. Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`; then
   `python Godot/tools/run_tests.py --jobs 2 --only station,day_lap,daylap,equip,injur,game_switches,club,gym_hall`. Paste PASS lines.

## VISUAL GATE
UI only: Claude renders `tools/station_pin_stills.gd` (worn bag pinned, then after SERVICE) on the PC and opens both; the operator closes it.

## Prior research
LUDO_ROUND25_S195.md (original numbers), LUDO_ROUND56_REPLY_S220.txt (24k, the recalibration and card spec), LUDO_ROUND56_VERDICT_S220.md
(what was taken / not taken - PRISTINE band NOT taken), TASK_STATIONWEAR1A-1D.

## What would a human do?
Change the numbers in one place (StationIntegrity consts), let every caller read them, then rebuild the card from the top down and
measure it.

## Prefab check
None needed - our own module and card.

## The one trap
Ludo's own mockup labels 46% as both WORN and DAMAGED. The band comes from item 2 only (46 = worn); never print a second band word.
