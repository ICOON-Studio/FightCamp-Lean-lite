# TASK METERS1 - the GAINS and ATTRITION meters + the CHANGE THE PLAN signal, as one pure module (S238, LOOP1 slice 1)

Seat: Arena (pure module + test, cloud). Branch `arena/<chat-id>-fightcamp`, PR to master; Claude reviews and merges by diff - never the
Merge button. Model: Arena default. Discipline: BOXING (the demo's gym floor). No kicks, knees, clinch, MMA anywhere in fixtures.

Operator ruling (board Q-S237-1, approving research/LOOP1_VERDICT_S238.md): "build it, the equipment wear is not what matters on
this , the loop , animations,workout,feeling of progrsession and improvement from training these are what matters for now".
His S237 words on the meters: "this needs to be nicely handled with visuals on gains and atrittion meters so the player can understand
when he need to change the training plan , so big emphasis on this part".
This round is a PURE module + test only. Claude wires it into the floor HUD (GymHall3D) next, behind switch `training_meters` (GAME_ON).

## What is on master already (read, do not edit)
- `research/LOOP1_VERDICT_S238.md` - the loop and the meters (section 3).
- `research/ludo_rx/LUDO_R102_LOOP1_raw.txt` section B - the lead designer's meter layout (bars, three zones, the pill text).
  Use its SHAPE (zones, pill wording, coach-early warning); NOT its thresholds (unsourced) - the thresholds are below.
- `Godot/scripts/rules/LoadLedger.gd` (211 lines) - weekly session-RPE load: WEEKLY_BUDGET 100, FRESH_THRESHOLD 70, OVERLOAD_THRESHOLD 100,
  `daily_spend` [7], `status()` bands FRESH / LOADED / OVER. Calibrated in J62 (Foster session-RPE; McCabe 2023 elite amateur camp).
- `research/J_STRESS_S206.md` - the functional overreaching -> non-functional overreaching -> overtraining ladder.
- `research/J62_TRAINING_DAY_REPLY.md` - load sources (Gabbett16 ACWR is DISPUTED - Impellizzeri20, Lolli19: do not use ACWR alone).
- The floor already produces per day: stat gains (`_result["gains"]` {stat: float}), strain 0..100 (`GymHall3D.strain()`), stamina 0..100,
  form state CLEAN / SLOPPY / IGNORED (FormBreakdown), niggle risk, coached or not. You only receive these as plain dictionaries.

## Do - new `Godot/scripts/rules/TrainingMeters.gd`
extends RefCounted, static funcs only, no class_name, no autoload, NO preload, NO randomness. Never modify an argument; return fresh
dictionaries. Every threshold is a named `const` with a one-line source comment.

1. `day_input` shape (document it at the top): `{"gains": {stat: float}, "strain": float 0..100, "stamina": float 0..100,
   "load_today": float, "form_state": "CLEAN"|"SLOPPY"|"IGNORED", "niggle_risk": float 0..1, "coached": bool}`.
2. `gains_read(history: Array) -> Dictionary` - history = the last up-to-7 day_inputs (oldest first, today last). Returns
   `{"today": float (sum of today's gains), "avg7": float, "spark": Array[float] (per-day totals, oldest first), "trend": "RISING"|"FLAT"|"FALLING",
   "top": Array of up to 2 [stat, delta] for today, "line": String}`. FLAT = today < FLAT_SHARE (0.6) of the average of the previous days
   while load stayed the same or rose (gains flattening under the same work). `line` examples: "+2.4 today - building", "+0.6 today - gains flattening".
3. `attrition_read(history: Array, week_ledger: Dictionary) -> Dictionary` - returns `{"value": float 0..100, "zone": "COOL"|"AMBER"|"RED",
   "fatigue": float 0..100, "wear": float 0..100, "monotony": float, "line": String}`:
   - fatigue = today's strain blended with (100 - stamina) - say the weights in a const and why.
   - wear = from week load: LoadLedger spent vs budget (FRESH < 70, LOADED 70-100, OVER > 100) plus niggle risk.
   - monotony = Foster 1998: mean daily load / standard deviation of daily load over the week (`daily_spend`); MONOTONY_HIGH = 2.0
     (Foster 1998, "Monitoring training in athletes with reference to overtraining syndrome", MSSE 30(7)) raises wear.
   - zone: COOL below AMBER_AT, AMBER from AMBER_AT, RED from RED_AT. Map AMBER_AT / RED_AT to the LoadLedger bands (LOADED / OVER) so
     the meter and the ledger never disagree. Comment: "J63 (John) retunes these from boxing-camp sources".
4. `change_plan(history: Array, week_ledger: Dictionary, coached: bool) -> Dictionary` -> `{"on": bool, "level": "NONE"|"WATCH"|"CHANGE",
   "reason": String, "pill": String, "fix": String}`:
   - CHANGE when gains trend is FLAT or FALLING AND attrition zone is RED; or form_state IGNORED two days running; or niggle_risk >= NIGGLE_STOP.
   - WATCH when attrition is AMBER and gains are FLAT.
   - Coached: the coach warns EARLY - the WATCH/CHANGE lines trigger one zone sooner (Ludo r102 "the coach acts as the early warning"),
     and the pill is spoken by the coach: "Coach: his jab is dragging - pull him off the bags".
   - `pill` text (player-facing, short): "GAINS FLATTENED - SWAP TO RECOVERY". `fix` = the one-click fix id: "recovery_block".
5. `week_card(history: Array, week_ledger: Dictionary) -> Dictionary` - the end-of-week read: gains total, best stat, attrition value
   and zone, the change-plan verdict for the week, and two lines of plain text.

## Tests (red on master first - paste the red lines in the PR body)
New `Godot/tests/training_meters_test.gd` (SceneTree script, `extends SceneTree`, `_init`, print `TRAINING_METERS failures=N`, quit(1) on any
failure). Population printed at the top: three DIFFERENT boxers (never identical fighters): a fresh welterweight prospect (rising gains,
light week), a veteran middleweight in a heavy monotonous week (flat gains, LOADED/OVER ledger, monotony > 2), a female featherweight
with a niggle (risk high). Assert at least:
- prospect: trend RISING, zone COOL, change_plan NONE.
- veteran: trend FLAT, zone RED, change_plan CHANGE with pill and fix "recovery_block"; monotony > 2.0.
- the same veteran history but coached: the warning fires one step earlier (WATCH or CHANGE on an earlier day than uncoached).
- niggle boxer: CHANGE by niggle risk even with rising gains.
- the meter zone and LoadLedger.status band agree for spent 50 / 85 / 110 (COOL/FRESH, AMBER/LOADED, RED/OVER).
- arguments unchanged after every call; same input -> same output.
- bounds: value 0..100 for random-looking but deterministic inputs over 50 cases.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/training_meters_test.gd` (tier: new test file only).
Parse gate first: `python Godot/tools/check_scripts.py Godot/scripts/rules/TrainingMeters.gd Godot/tests/training_meters_test.gd`.

## Rules
GDSCRIPT_TRAPS.md (typed reads, no `:=` on a Variant, no `%%`, no reused names). Do not edit LoadLedger.gd or any other file.
New features ship ON (CLAUDE.md s10) - the switch is Claude's wiring round, not yours. THE ONE TRAP: do not delete or weaken a test to go green.

## Prior research
LOOP1_SCOPE_S237.md, LOOP1_VERDICT_S238.md, LUDO_R102_LOOP1_raw.txt (meter shape), J62_TRAINING_DAY_REPLY.md (session-RPE, ACWR critique),
J_STRESS_S206.md (FOR/NFOR/OTS), LoadLedger.gd (K9, J62 calibration). J63 (John, running) will retune the thresholds.

## What would a human do?
A coach looks at the week on the whiteboard: the fighter's numbers stopped moving while he looks flat and heavy, every day was the same
hard session - he swaps tomorrow for a recovery day and tells the fighter why.

## Prefab check
None - the meters read our own systems; no library models boxing load.
