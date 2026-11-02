# S83 DIGEST - training made legible (training floor, step 1)
Claude, 2026-09-26. Operator's choice from S82: "training floor first, start with step 1".

## Shipped (master)
- **`TrainingPreview.gd` - the one gain rule.** `preview_gain(stats, potential, station, coach_rating, crowd_factor,
  fraction)` and `progress_to_next(value)`, exactly the Q185 contract. `GameState._apply_focus_stat_gains` now calls it
  (the cap at potential+10 stays in GameState), so the planner's forecast and the day's result cannot disagree.
  `preview_training_gain(athlete_id, station_id, fraction)` is the public read.
- **Per-stat history in the save.** `athlete.stat_history`: one snapshot per career day (29 kept), a baseline written
  before the first day runs, recorded in `advance_day` and `advance_week`. Getters: `get_stat_trends`, `get_day_card`,
  `get_weekly_report`, `get_camp_card`; `start_fight_camp` records `start_stats`.
- **Profile:** a thin progress bar under every stat (to the next point, tooltip "62% of the way to 45") and a 7-day
  arrow - green up / amber flat / red down (+-0.05), tooltip with the week's change.
- **HOME:** "Yesterday on the floor" (per fighter: up to 3 gains to two decimals + tired/injured flag) on Tuesday-Sunday;
  the **Monday report** (sparkline of the overall over four weeks, OVR then -> now, one line from the corner coach) on
  Monday.
- **Planner drawer:** `EXPECTED +0.05 POWER · ...` for the chosen day (the same rule, fraction 1/7) and
  `INJURY RISK · LOW / RISING / HIGH (15%) · FATIGUE n` from the week's fatigue.
- **Fight week:** a `CAMP BUILT  OVR x -> y` tile and "This camp built: ... · missed: ..." line.
- **Defect fixed on the way:** the fight-week plan board crashed (`int()` of the `slots` Dictionary) whenever a camp
  was actually possible - no test booked a real camp before.
- Renders: `previews/s83/` (monday_report, day_card, profile, planner) via `tools/s83_render_training.gd`.

## Tests (subsets; full suite is the nightly)
- `training_legibility_test` 84/0 - preview == applied on a real station; a real day moved each stat by the forecast
  (within 0.002) and the day card reported it; arrows agree with their numbers; Monday/other-day HOME cards; a real camp
  (event 4-6 weeks out, the options' own track) records its start and fight week draws the card. **Two mutants caught:**
  applied gain x1.1 (6 fails), arrows always up (7 fails).
- **Q185 (Qwen) blind contract test 25/0** against the module neither side saw.
- Subset (training, athlete_development, profile, day_feed, home_pin, setpiece, fight_camp, camp_board, career_loop,
  menu_clarity, shell, smoke, weight_cut, fight_week, gym_hub): 31 tests, 1 red - `athlete_development` (2 failures:
  proficiency seed, boxing_jab learning), **identical on the pre-S83 GameState** (control run) and red in the nightly.
- Last nightly: 2026-09-26 at 9847dd13, SUITE total=416 fails=13 (AgentComms/nightly/latest.txt).

## Collected
- **Q184 (Qwen)** merged: KB finish funnel + a KB-only corner stoppage that never fires at threshold 75 (KB 6.7% vs
  Glory 33%, unchanged). Follow-up **Q186** assigned (per-minute, per-head-strike cause; decide the corner stoppage).
- **U178 (Cursor)** merged, then **REVERTED** (354cf4f9): MMA leg share 6.3 -> 13.5% but `fight_footwork_economy` MMA
  fell 14.6 -> 11.2 m/min (floor 12); control run on the pre-merge engine files = 14.6. Rework **U178B** launched.
- **C212 (Codex)** merged: four Mixamo clips all "usable with edit", heavy bag best. **D27 (Dola)**: warm-up and heavy
  bag read real; the speed bag's fists pass BEHIND the bag (C212 fitted the prop to the hands - disagreement noted).
- **U179 (Cursor)** merged: the Polyronin pack is a strength room only - FITS 1 (ring), RESCALE 1 (weights), NO MATCH
  23. Its CC0 links were not opened -> **G114** (Grok) verifies sources.
- **G111 (Grok)**: hub growth - one back-rooms plate with a door strip; agrees with the training-floor doors.
- **G113 (Grok)**: real gym dimensions - our catalogue footprints are DEVICE sizes, not use zones (heavy bag 1x2 vs a
  real 3x3; ring 4x4 vs 8x8). Tier presets in metres for S84.

## Found, not fixed
- `fight_realtime_test` has six JUDO reds (throw_points_round, yuko, pinned ippon seeds) on master BEFORE today's merges
  (control run); green in the 2026-09-26 nightly at 9847dd13, so something between 9847dd13 and 524af0b4 (S82) did it.
  Named in U178B/Q186's ceilings; needs an owner.
- HOME's picture renders black in the offscreen render tool (the live game draws it) - render-only.
