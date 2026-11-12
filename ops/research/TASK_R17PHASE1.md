# TASK R17PHASE1 - GOOSE (cloud) - ROUNDS ON LINES: early, middle and late lines, and the last round split IF AHEAD / IF BEHIND (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing. Model: Goose's own model (the goose workflow; nothing to pick).
Mechanic: R17 "Game plan on a board" (critics 8/9 and 7/7, average 7.75, ops/research/MECHANICS_BUILD_STATE_S440.md). Source:
ops/research/PLAYBOOK_MAP_S432.md section 4.5 ROUNDS ON LINES (lines 160-175: READ IT FIRST, it is the spec), with 4.7 (the lines
brought) and section 7 row PHASE1. The Playbook map passed two critics at 7 and 7. Today every line lives in every round and the last
round cannot be planned for a lead or a deficit. THIS task is only the pure rule module: no screen, no wiring into LiveRound or the
corner minute (Claude, later; the corner's card of FIGHT_LINK_MAP M7 replaces the simple ahead/behind count here once it exists).

## Contract
OWNS: scripts/rules/PlanPhase.gd, tests/plan_phase_test.gd
RED_TEST: tests/plan_phase_test.gd -> PLAN_PHASE failures=0
REGRESSION: plan_lines_test, plan_fight_test, plan_board_test, pace_aim_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too). Read, never edit: scripts/rules/PlanLines.gd (177 lines: an arrow is
{move, when}, lines() 36), scripts/rules/StrikeMap.gd (123: MOVES 18-50, each with `combo`), scripts/rules/Exchanges.gd (372: EXCHANGES
line 10, BODY_COST 38, round_of 317-330), scripts/rules/PaceAim.gd (190: PACES line 5), scripts/rules/PlanFile.gd (152: round pace
pace_for 136, set_pace 145).

## The plan shape (decided; old plans load unchanged)
An arrow gains one optional key `rounds`: "all" (the default when missing), "early", "middle" or "late". The plan gains one optional
Dictionary `late` = {ahead: {pace, arrows: [<= 2 arrows>]}, behind: {pace, arrows: [<= 2 arrows>]}}; pace is one of PaceAim.PACES.

## The job: scripts/rules/PlanPhase.gd (pure, static, under 240 lines; preloads StrikeMap, Exchanges, PaceAim)
1. `split(rounds) -> Dictionary` {early: [round numbers], middle: [...], late: [...]}: early and late are each floor(rounds / 3) rounds
   (at least 1), middle the rest. That gives the map's three cases exactly: 3 rounds R1 / R2 / R3; the four-round debut R1 / R2-3 / R4;
   six rounds R1-2 / R3-4 / R5-6. Two rounds: R1 / none / R2. Rounds are 2 to 12; outside that, clamp.
2. `phase_of(round, rounds) -> String`.
3. `pips(arrow, rounds) -> Array[bool]`: one per round, true where the line lives (the screen's round pips).
4. `late_state(won, lost) -> String`: "ahead" when won > lost, else "behind" (map: level counts as behind, ESTIMATE). And
   `late_state_of(rounds_exs: Array) -> String`: the same from each round's exchange records through Exchanges.round_of (read it).
5. `live(arrows, late, round, rounds, state) -> Array`: the arrows whose phase holds this round; in the late phase add
   late[state]["arrows"] (state "ahead"/"behind"). A late-only arrow ("late") lives in both states.
6. `pace(late, round, rounds, state) -> String`: late[state]["pace"] in a late round; "" otherwise (the caller keeps today's round pace).
7. `validate(arrows, late, rounds, brought) -> Array` of plain-word problems (empty = fine): a round (and, in late rounds, each state)
   where more lines live than `brought` (map 4.5: a line counts against the lines brought ONLY in its own rounds, so a boxer who
   brings 4 can plan 6); more than 2 arrows in a late state; a pace not in PaceAim.PACES; an unknown `rounds` word; a late arrow whose
   move is not in StrikeMap.MOVES.
8. `body_pays(arrow, rounds) -> int`: for a body line (its StrikeMap combo holds a body punch, "3b") that lives in the early phase,
   the last round number ("pays in R3": Exchanges.BODY_COST makes every body shot cost the opponent for the rest of the bout); 0
   otherwise.
9. `words(arrow, rounds) -> String`: "R1", "R2-3", "R3, if behind" style labels for a line's rounds; "All rounds" for "all".

## The test FIRST: tests/plan_phase_test.gd (extends SceneTree, prints `PLAN_PHASE failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing PlanPhase.gd fails to load. Say so in the PR body. Assert at least:
- split(3), split(4), split(6) equal the map's three cases written in the test; every round 1..n sits in exactly one phase for n in
  2..12; split(2) has an empty middle;
- an old plan (no `rounds` keys, no `late`) lives whole in every round: live() returns every arrow for every round and state;
- THE HAND: six lines (two "early", two "late", two "all") with brought 4 validate clean; the same six all "all" are refused, and the
  problem names the round; three arrows in late.ahead are refused;
- late_state(1, 1) is "behind", (2, 1) "ahead", (0, 2) "behind"; late_state_of on hand-built rounds agrees with Exchanges.round_of's
  "won" for each round (build the records with the keys round_of reads: won, margin, landed);
- live() in the last round adds late.ahead's arrows when ahead and late.behind's when behind, never both; pace() returns the state's
  pace in the last round and "" in round 1;
- body_pays: an early "3b-3" line on 3 rounds reads 3; an "all" body line reads 0; an early "1-2" reads 0 (a combo read from StrikeMap
  in the test);
- validate refuses a pace "fast" and a rounds word "late_ahead";
- MUTANTS inside the test: a copy of split that gives middle the remainder of a ceil, and a copy of late_state where level counts as
  ahead, must each FAIL the same asserts; print `MUTANT caught` for each.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%` in format strings).
- The one trap: old saves. A plan with no `rounds` and no `late` must play exactly as today, or every plan test moves. Missing keys
  read "all" and {}.
- Do not touch PlanLines, PlanBoard, LiveRound or any plan file: a pure module only.
- No pronoun in a built string. Do NOT delete or weaken any existing test.
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py phase late round` -> PLAYBOOK_MAP_S432.md 4.5 (the spec), topics/plans_corner.md (real phased plans:
bank the early rounds, invest in the body, take over late), topics/pace_calibration.md (round pace), FIGHT_LINK_MAP_S432.md M7 (the
corner's card that will later replace the simple count).

## What would a human do?
A trainer's plan is phased: "box behind the jab in one, go to the body in two, and if you need the last round, let your hands go;
if you are ahead, stay on the outside". Amateur corners score the rounds themselves and say "you need this round".

## Prefab check
None: a few rules over the plan's own arrays. PlanFile.pace_for / set_pace show the house style for per-round data.

Test command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/plan_phase_test.gd`.
Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/plan_phase_test.gd -> PLAN_PHASE failures=0`.
