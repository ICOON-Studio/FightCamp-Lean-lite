# TASK LEDGERREAL1 - benchmark Ludo's Load Ledger against John's real-world camp numbers (S235)

Seat: QWEN. Worktree given in the launch prompt. Commit on your branch; Claude merges by diff. Model: qwen3-coder.
Operator rule (memory "benchmark real-world numbers"): a game number is checked against real-world data before it ships.

## Inputs (both on master)
- `Godot/scripts/rules/LoadLedger.gd` (Ludo r99): WEEKLY_BUDGET 100, `station_hourly_rate(kind)`, `cue_multiplier(cue)`,
  `block_cost(kind, minutes, cue)`, `spend`, `status`, `week_end`, `forecast`. Green test: `tests/load_ledger_test.gd`.
- `research/J62_TRAINING_DAY_REPLY.md` (John, sourced) - read "## Game-tuning table" and sections 1-5. Key facts:
  6 training days + 1 rest; 2 sessions a day (AM skills, PM conditioning), Saturday 1; AM = bag 6-12 / pads 6-12 / shadow 4-6 rounds of 3 min;
  sparring 2-3 sessions a week, 6 building to 12-15 rounds, peak 2 weeks out; session load = RPE x minutes (Foster); hard / moderate / easy
  RPE 6 / 3 / 1.5 (Uchida14); taper: last 14 days volume -40..60%, final week 15-50% of peak, intensity kept.

## Do
1. New test `Godot/tests/load_ledger_realworld_test.gd` (`extends SceneTree`, `_initialize`, `load("res://scripts/rules/LoadLedger.gd")`,
   print `LOAD_LEDGER_REAL failures=N`, `quit(0 if failures == 0 else 1)`). Build these weeks from J62 as lists of (station_kind, minutes, cue)
   blocks and cost them with `block_cost` (station kinds: heavy_bag, speed_bag, double_end_bag, pads, ring_spar, shadow, slip_rope,
   footwork_ladder, strength, cardio, stretch, rest, physio; cues normal / power_through / crisp_form; a 3-min round + 1 min rest = 4 min):
   - PEAK CAMP WEEK (week 6 of 8): 6 days, AM bag 10 + pads 10 + shadow 5 rounds, PM cardio 45 min + strength 45 min on 3 days, sparring 3
     sessions of 12 rounds. Assert it lands 80..100 of the budget (fully loaded, not over).
   - EARLY CAMP WEEK (week 1): bag 6, pads 6, shadow 4, sparring 2 x 6 rounds, PM cardio 30 min. Assert 45..75.
   - TAPER WEEK (fight week): 40-60% less than PEAK. Assert TAPER/PEAK in 0.40..0.60.
   - RECOVERY WEEK: stretch + light shadow + cardio 20 min, no sparring. Assert < 40.
   - RELATIVE EFFORT: per hour, ring_spar (hard, RPE 6) : pads/heavy_bag (moderate-hard) : shadow (moderate, 3) : stretch (easy, 1.5) must keep
     the order spar > bag/pads > shadow > stretch, and spar/stretch between 3 and 5 (6 / 1.5 = 4).
   - The over-budget penalty only bites on a week heavier than PEAK x 1.15 (status band OVER).
2. Run it. If any assertion fails, change ONLY the constants in LoadLedger.gd (`station_hourly_rate` table, `cue_multiplier` values) until
   every real-world band passes, with a `## J62:` comment on each changed number naming the source row. Never change WEEKLY_BUDGET, never
   change the bands in your test to fit the code, never weaken `tests/load_ledger_test.gd` - if your numbers break it, report which of its
   assertions is in conflict instead of editing it.
3. Print the cost of each week (a small table) at the end of the test so the numbers are visible.

## Gate
Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/LoadLedger.gd Godot/tests/load_ledger_realworld_test.gd`
Tests: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd` for
load_ledger_realworld_test AND load_ledger_test (exactly that exe; no window).

## Rules
Touch ONLY LoadLedger.gd (constants) and the new test. Typed reads, no `%%` (research/GDSCRIPT_TRAPS.md). Nothing opens on screen.

## Prior research
J62_TRAINING_DAY_REPLY.md (John), LUDO_R99_part2.txt (Ludo's own Foster note), memory: benchmark real-world numbers before design.

## What would a human do?
A strength coach checks the app's weekly load against the session-RPE numbers he logs for real fighters.

## Prefab check
None - tests and constants.

## The one trap
Fitting the test to the code. The bands come from J62; the code moves, the bands do not.
