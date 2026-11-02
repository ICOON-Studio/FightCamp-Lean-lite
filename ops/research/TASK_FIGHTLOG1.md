# TASK FIGHTLOG1 - the live fight writes technique usage back (r46 SLICE 2)

Model: Codex sol (gpt-6.1-sol, reasoning high). Branch `codex/fightlog1` cut from master AFTER TECHSTAGE1 merges (it needs
`scripts/rules/TechniqueStage.gd` and the `technique_stage` ledger). Spec: `LUDO_ROUND46_VERDICT_S213.md` TAKEN 3 + SLICE 2
(operator approved Q-S212-1: "Yes - build it as in the verdict").

## Prior research
`LUDO_ROUND46_VERDICT_S213.md`, `TECHSTAGE1_DIGEST.md`, `TECHSTAGE1_VALIDATION.md`, `topics/attributes_skill.md`.
## What would a human do?
A coach tallies what his fighter threw and landed, what landed when he was tired or hurt, and which punch the other man kept
landing on him - then sets next week's work from it.
## Prefab check
None - engine bookkeeping inside our own FightRealtime.

## The defect this fixes
Real-time boxing writes NO technique usage: `FightNightScreen.gd` ~1527-1540 passes `technique_usage` only when `not _uses_realtime`
(the old FightSimulation path). Boxing is real-time, so `AthleteDevelopment.apply_fight_usage` and `ComboMastery.record_use`
(GameState.gd ~15560-15580, inside `record_live_fight_result` at ~15449) receive nothing after a boxing bout.

## Build
1. `FightRealtime.gd` (9,541 lines - never read whole; grep `events.append` ~2626 and the strike resolve around it):
   keep a per-side, per-technique tally in the fight state, `state["_usage"][side][technique_id] = {attempts, lands, pressure_lands,
   counters_taken}`; add `static func technique_usage(state, side) -> Array` returning rows shaped EXACTLY like
   `FightSimulation.get_technique_analytics` (FightSimulation.gd:943: technique_id, technique_name, role, attempts, lands, ...) plus
   `pressure_lands`. A PRESSURE LAND (DESIGN, name it in a const): the lander's stamina fraction < 0.50 OR he took a clean hit in the
   previous 60 ticks. `counters_taken` = clean lands the opponent scored with that technique on this side.
   Also `static func exposed_hole(state, side) -> Dictionary`: the opponent technique with the most clean lands on `side`
   ({technique_id, technique_name, lands}), empty when under 3 lands (DESIGN).
   No new RNG draw; the tally must not change any fight outcome (byte-identical result with the tally on vs a build without it).
2. `FightNightScreen.gd`: in BOTH the offer branch and the watched-bout branch, the real-time path passes
   `technique_usage = FightRealtime.technique_usage(state, side)` and `exposed_hole` in the payload.
3. `TechniqueStage.gd`: `static func after_fight(athlete, usage: Array) -> Dictionary` - for each row whose technique already has a
   `technique_stage` record (moves the boxer trains - verdict: "only for moves the boxer trains"), add `pressure_lands` to
   `fight_lands` and recompute `stage`; returns {technique_id: {from, to}} for stage changes. Never creates a record.
4. `GameState.record_live_fight_result` (~15449): call `TechniqueStage.after_fight`, store the result and `exposed_hole` on the
   athlete's pending fight result (`pending_fight_result["technique_stage_changes"]`, `["exposed_hole"]`) for DEBRIEF1 to show.
   Behind switch `technique_stages` (GameSwitches; OFF = nothing written).

## Owned files (+ line counts)
`Godot/scripts/FightRealtime.gd` (9,541), `Godot/scripts/FightNightScreen.gd` (1,876), `Godot/scripts/rules/TechniqueStage.gd`,
`Godot/scripts/GameState.gd` (19,876 - edit only inside `record_live_fight_result`), `Godot/tests/fight_log_test.gd` (new),
`research/FIGHTLOG1_DIGEST.md` (new).

## Acceptance
- `tests/fight_log_test.gd` (two DIFFERENT boxers: different stats, techniques and plan - never identical fighters; name the
  population in the output): a seeded real-time boxing bout; the tally's attempts/lands per technique equal a count you take from
  the fight's own event log independently; pressure_lands <= lands; exposed_hole names a technique the opponent actually landed;
  `after_fight` adds only to existing records and moves a record across the SIGNATURE gate when fed enough pressure lands;
  switch OFF writes nothing (control arm). Each assertion must go RED on a mutant (state the mutants and that they went red).
- Outcome invariance: 20 seeds, result dict identical with and without the tally code path.
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- Tests: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/fight_log_test.gd` (exe in
  %LOCALAPPDATA%\Programs\Godot\), then `python Godot/tools/run_tests.py --only fight_log,technique_stage,fight_realtime,fight_night,record_live --jobs 2`
  (`--jobs 1` when the watchdog is not GREEN). Check `Tools\pc_watchdog.ps1 -Once` before each Godot run; RED = wait.
- Commit + push `codex/fightlog1`; digest with the numbers. Do not edit HANDOFF.md or AgentComms/blockers.

## The one trap
Headless tests run with switches OFF; your test must turn `technique_stages` ON for the ON arm explicitly and keep an OFF arm.
