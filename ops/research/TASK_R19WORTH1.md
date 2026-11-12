# TASK R19WORTH1 - ARENA - what the next film buys: a hidden tell shown as a RANGE of worth, exact once found (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing. Model: Arena, the strongest code model offered in a NEW chat for this task.
Seat note (decided S440): the delegation plan named a Grok bot; this module must read OppFile's answer tables and PlanLines' ratings,
and a zero-preload version would be bare arithmetic with every number typed by the caller, so it goes to a seat with the code (Arena).
Mechanic: R19 "Scout the opponent: file and tape room" (critics 7/7 and 6/6, average 6.5, ops/research/MECHANICS_BUILD_STATE_S440.md):
what is missing is "a hidden tell shown as a range of worth". Source: ops/research/PLAYBOOK_MAP_S432.md section 5 and 6 (worth a use;
"Fight prep > What your plan should answer") and ops/research/CORE_LOOP_MAP_S432.md line 116 ("worth in exchanges a bout, a range while
a tell is hidden"). The Playbook map passed two critics at 7 and 7. Today a hidden tell shows "?" and the player cannot tell whether
the next tape session is worth a pad place. THIS task is only the pure rule module: no screen, no wiring (the tape room and the Fight
plan read it later, Claude). The unit is the plan's own worth (PlanFight power points, the unit of PlanLines' `edge`); turning it into
exchanges waits for LEVERS1's table and is NOT done here.

## Contract
OWNS: scripts/rules/TellWorth.gd, tests/tell_worth_test.gd
RED_TEST: tests/tell_worth_test.gd -> TELL_WORTH failures=0
REGRESSION: opp_file_test, plan_lines_test, tape_room_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too). Read, never edit: scripts/rules/OppFile.gd (184 lines: WEAPON_ANSWERS 30-43 and
WEAKNESS_ANSWERS 44-57 (column 3 is the plan situation), tells() 66, known 97, hidden 102, tape 112 (it OPENS a tell: never call it),
has_tape 166), scripts/rules/PlanLines.gd (177: HABIT_SITS 31, tell_sit 143, place_for 88, options 94-111 with `edge`),
scripts/rules/Exchanges.gd (372: EXCHANGES line 10, STYLE_MODES 132-143), scripts/rules/PlanFight.gd (244), tests/opp_file_test.gd (128:
how real opponents are built from Data.OPPONENTS).

## The job: scripts/rules/TellWorth.gd (pure, static, under 220 lines; preloads OppFile, PlanLines, Exchanges)
1. `candidates(kind) -> Array` of situations a HIDDEN tell of that kind could name, from the tables themselves (never typed): "weapon"
   -> the distinct column-3 values of OppFile.WEAPON_ANSWERS, "" included when a row has none; "weakness" -> the same over
   WEAKNESS_ANSWERS; "habit" -> the distinct values of PlanLines.HABIT_SITS. `kind_of(tell_id)`: "weapon", "weakness", "habit"
   (ids starting "habit:"), else "".
2. `worth_a_use(sit, mastery, combos) -> float`: the best usable answer's `edge` from PlanLines.options(PlanLines.place_for(sit), sit,
   mastery, combos), floored at 0 (an answer the boxer cannot throw yet is worth 0 now); 0 for sit "".
3. `uses_a_bout(sit, opp, rounds) -> float`: for the four games (Exchanges.STYLE_MODES keys) the opponent's style share x
   Exchanges.EXCHANGES x rounds; for any other situation (tiring, hurt, ...) `const OTHER_USES := Exchanges.EXCHANGES` (one round's
   exchanges; an ESTIMATE, a comment names LEVERS1 as the job that replaces it).
4. `range_of(opp, tell_id, mastery, combos, rounds) -> Dictionary` {lo, hi, known: bool, sits: Array}: a KNOWN tell (OppFile.known)
   gives lo == hi for its real situation (PlanLines.tell_sit of the real tell from OppFile.tells); a hidden one gives the min and max of
   worth_a_use x uses_a_bout over candidates(kind_of(tell_id)).
5. `next_film(opp, mastery, combos, rounds) -> Dictionary` {id, what, lo, hi}: the tell the next tape session would open (the FIRST of
   OppFile.hidden(opp), the order tape study uses) with its range; {} when nothing is hidden or OppFile.has_tape(opp) is false.
6. `file(opp, mastery, combos, rounds) -> Array`: range_of for every tell that is "tape" (OppFile.tells' `how`), in the file's order.

## The test FIRST: tests/tell_worth_test.gd (extends SceneTree, prints `TELL_WORTH failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing TellWorth.gd fails to load. Say so in the PR body. Use two DIFFERENT real
opponents (deep copies of Data.OPPONENTS[0] and [1], as tests/opp_file_test.gd does) and two DIFFERENT boxers' mastery / combos (the
shapes tests/plan_lines_test.gd builds). Assert at least:
- candidates("weapon") equals the set built IN THE TEST from OppFile.WEAPON_ANSWERS column 3; the same for weakness and habit;
- for a hidden weapon, lo <= the exact worth of the real situation <= hi (open the tell on a COPY with OppFile.open and recompute);
  once open, lo == hi == that exact worth;
- worth_a_use equals the best usable PlanLines.options edge recomputed in the test, and is 0 when the boxer can throw no answer;
- uses_a_bout for "press" on a Pressure fighter equals STYLE_MODES share x EXCHANGES x rounds read in the test; "tiring" equals
  OTHER_USES x 1;
- next_film names the first hidden id; after opening it on a copy, next_film names the next one; an opponent with no tape gives {};
- range_of and next_film never change the opponent (its file_found is the same before and after; deep compare);
- the better-drilled boxer's hi is at least the other's hi on the same tell;
- MUTANTS inside the test: a copy of range_of that returns only the real situation's worth while hidden (leaks the hidden tell), and a
  copy of worth_a_use that does not floor at 0, must each FAIL the same asserts; print `MUTANT caught` for each.

## Traps
- GDScript 4: type every Dictionary read; `:=` on a Variant is an error here; `%%` for a literal percent.
- The one trap: a hidden tell must not leak. While hidden, nothing in the result may depend on WHICH tell it really is (only on its
  kind); the mutant above checks it. And never call OppFile.tape: it opens the tell on the real opponent.
- A test that only your own function can pass is not a test: every expected number is recomputed in the test from OppFile, PlanLines
  and Exchanges.
- Do NOT delete, skip or weaken any existing test. No .res/.glb/scene loads. Do not touch CI. Write the PR body last.

## Prior research
`python ops/Tools/prior_research.py tell worth film` -> topics/scouting_film.md (what film study finds and in which order), SCOUTING_S340.md
(the file in stages), PLAYBOOK_MAP_S432.md (worth a use, section 5), CORE_LOOP_MAP_S432.md (ranges while a tell is hidden).

## What would a human do?
A trainer deciding whether to spend another evening on tape asks: what could it show, and what would we do with it? "If it is the
counter over the jab, the feint answers it and that wins rounds; if it is nothing, we lose an evening." The range is that question.

## Prefab check
None: arithmetic over the scouting tables and the plan ratings the game already has.

Test command: `godot --headless --audio-driver Dummy --path . --script res://tests/tell_worth_test.gd` (on the PC: the plain
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe`). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/tell_worth_test.gd -> TELL_WORTH failures=0`.
