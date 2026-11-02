# TASK REFEREE1A - referee personalities change the fight (engine half, switch `ludo_referee`, default OFF)

Model: cloud Codex (issue label `codex`, gpt-6-luna). Branch: the workflow names it. Never master, never HANDOFF.md, never AgentComms/.
Operator S188 ("yes all picks", REFEREE1): "Referee personalities (fast stopper / lets it go / hometown lean), shown before the fight;
NO dirty fighting in boxing EA". This is the ENGINE half; showing the referee before the fight is REFEREE1B (later, UI).

## Owned files
- `Godot/scripts/FightRealtime.gd` (~8,950 lines - NEVER read whole; grep + `sed -n` windows). Anchors:
  - switch pattern: `DEMO_SWITCHES` ~1170 (do NOT add the new switch there) and the option read near ~1703 (`ludo_composure` - copy it).
  - state build: grep `"clinch_break_tick": 0` (~1571) - store `state["referee"] = <profile dict>` there when the switch is on.
  - clinch break draw: ~8510 `var break_s: float = CLINCH_BREAK_MIN_S + rng.randf() * (...)`.
  - doctor: `doctor_inspect` ~3630, the line `var odds: float = CutsDoctor.stoppage_chance(pips, actions)`.
- `Godot/tests/referee_live_test.gd` (NEW).

## Prior research
- Pure rules merged S194 (1a0e8a73): `Godot/scripts/rules/RefereeStyle.gd` + `Godot/assets/data/referee_styles.json` - REUSE; never copy
  numbers into the engine. Design: `research/LUDO_ROUND17_S193.md` (referee section).
- D42 (`research/DECISION_LEDGER.md`): the doctor table of record (call 3p 15% / 4p 50% + mandatory at the break / 5p instant;
  stoppage 35/70/100% minus cutman). The referee MODIFIES the stoppage odds; it never replaces D42's pip thresholds.
- Clinch break realism (J38: 4.06 +- 2.27 s) - the drawn window stays inside [CLINCH_BREAK_MIN_S, CLINCH_BREAK_MAX_S].
- Boxing EA has no dirty fighting: `evaluate_point_deduction` is NOT wired (leave it data-only).

## What would a human do?
Pick a referee per bout, then let his two habits show: how fast he breaks a clinch and how quickly he lets the doctor stop a cut.

## Spec
1. Option `ludo_referee` (boxing only): `state["referee"]` = the profile from referee_styles.json chosen by option `referee_id`, or - when
   absent - drawn deterministically from the bout seed (never `randi()` unseeded). Log one `{type: "referee", id, name}` entry at the bell.
2. Clinch: with a referee, scale the drawn `break_s` by `clinch_break_time_seconds / 2.5` (2.5 = the table's neutral) and clamp to
   [CLINCH_BREAK_MIN_S, CLINCH_BREAK_MAX_S]. Name the 2.5 as a const with a comment.
3. Doctor: with a referee, `odds = RefereeStyle.evaluate_stoppage_risk(profile, int(pips), odds, is_away)` AFTER CutsDoctor - but if that
   returns 0.0 only because pips < the referee's threshold, keep D42's odds (the referee cannot cancel D42's mandatory 5-pip stop).
   `is_away` = the side whose `home` flag is false when the bout carries one; no home data -> false for both (no bias).
4. OFF: byte-identical - same seed, switch off -> the log hash equals master's.

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/referee_live_test.gd`.
- `referee_live_test.gd`: two DIFFERENT boxers (name them in the output), 8 seeds. HAIR_TRIGGER vs OLD_SCHOOL (use the ids in the json):
  mean clinch break shorter for HAIR_TRIGGER; on a forced 4-pip cut the stoppage odds HAIR_TRIGGER > OLD_SCHOOL; a 5-pip cut stops under
  both; OFF -> no referee entry and log hash = master (print both). RED first on master (paste the count), then green.
- `python Godot/tools/run_tests.py --only doctor --jobs 2`, `--only clinch --jobs 2`, `--only fight_realtime --jobs 2` -> 0 fails (say if a
  test cannot run on CI for lack of LFS models).
Final message: red count, green results, the hash proof.

## The one trap
The clinch draw and the doctor roll share RNG streams with the rest of the fight: consume EXACTLY the same number of rng calls with the
switch on as off (scale the drawn value; never draw again), or every later tick of the ON fight changes and the test measures noise.
