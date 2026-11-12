# TASK R24GRADE1 - ARENA - how THIS boxer does each plan line (Good / OK / Poor): one pure module + its test

Status: OPEN (S440, Claude main). Discipline: boxing. Model: Arena, the strongest code model offered in a NEW chat for this task.
Mechanic: R24 "Fighters who fight differently" (critics 9/8 and 8/7, average 8.0, the top of ops/research/MECHANICS_BUILD_STATE_S440.md).
Source: ops/research/PLAYBOOK_MAP_S432.md section 4.1 (lines 70-97: READ IT FIRST, it is the spec) and section 7, row LINEGRADE1.
The Playbook map passed two fresh critics at 7 and 7. Today the body never changes which plan answer is right: a boxer with slow feet
is rated on "Step back" exactly like a fast one. THIS task is only the pure rule module: no screen, no wiring into PlanFight or the
bout (PLANTUNE1 must re-tune PlanFight.EDGE first; that wiring is Claude's, later).

## Contract
OWNS: scripts/rules/LineGrade.gd, tests/line_grade_test.gd
RED_TEST: tests/line_grade_test.gd -> LINE_GRADE failures=0
REGRESSION: plan_fight_test, plan_lines_test, exchanges_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too: Claude adds the test there at collect). Read, never edit:
scripts/rules/Exchanges.gd (372 lines: GOOD_AT / OK_AT / GRADE / COMMIT at lines 18-30, grade() at 188-198, call_edge at 207-215),
scripts/rules/PlanFight.gd (244: EDGE line 19, ANSWERS 40-61, fit 83, can_do 93, rate 114, value 122, card_mean 130, edge 142),
scripts/rules/StrikeMap.gd (123: MOVES 18-50, move(), outs()), scripts/rules/Attrs.gd (408: ABILITIES line 11, LABEL 19, LO/HI 34-35, of() 57-84).

## The job: scripts/rules/LineGrade.gd (pure, static, under 250 lines; preloads only Exchanges, PlanFight, StrikeMap, Attrs)
Each function gets one doc line saying what a boxing coach would call it. Attribute keys are Attrs.ABILITIES keys (the dictionary
Attrs.of(f) returns), never the corner calls' aliases.
1. `const DONE_WITH`: each move's two attributes, keyed by PlanFight.base_id (so "3b-3@corner" reads "3b-3"). The map's table, in
   StrikeMap ids: "1-1", "1-2": accuracy, speed / "1-1-2": footwork, accuracy / "2-3", "1-2-3": timing, speed / "1-2-3-2": speed,
   stamina / "1-2-3b", "3b-3": strength, inside / "1-6-3": inside, explosiveness / "slip 2-3": defence, timing / "step_in": footwork,
   explosiveness / "step_out", "step_back": footwork, speed / "cut_off", "herd": footwork, fight_iq / "feint": fight_iq, timing /
   "pivot_out": footwork, composure / "roll_out": defence, flexibility / "tie_up": inside, strength / "push_off": strength,
   durability. Forced moves ("backed_up", "break", "spins_out") have no pair: nobody chooses them.
2. `grade(move_id, attrs) -> Dictionary` {word, mean, pair: [[key, value], [key, value]]}: the mean of the two; "Good" from
   Exchanges.GOOD_AT, "OK" from Exchanges.OK_AT, else "Poor" (READ the two constants, never type 62 or 50). A missing attribute
   reads 55.0 (as Exchanges.grade does). A forced or unknown move returns {}.
3. `const PLUS := {"Good": 1.2, "OK": 0.85, "Poor": 0.35}` (the map's ESTIMATE; a comment says LINEGRADE1 sets them). The minus side
   is Exchanges.COMMIT (read it): a wrong move done well costs more.
4. `graded_value(move_id, sit, rate_mult, attrs) -> float`: PlanFight.value(move_id, sit, rate_mult) times PLUS[word] when it is
   positive, times Exchanges.COMMIT[word] when it is negative, 0 stays 0.
5. `worth(move_id, at, sit, mastery, combos, attrs, fire_share := 1.0) -> float`: fire_share x (graded_value - PlanFight.card_mean(at,
   sit, mastery, combos)), with rate_mult = PlanFight.rate(move_id, combos). (The map's "worth a use"; the no-plan baseline stays
   today's ungraded card_mean, as section 5's example numbers say.)
6. `chain_grade(move_ids: Array, attrs) -> Dictionary`: an own chain is graded on the mean of its moves' pair means (map row "Own
   chain"); same return shape, `pair` empty.
7. `next_line(move_id, attrs) -> Array` of {key, ok_at, good_at}: for each of the two attributes, the value it must reach for OK and
   for Good with the other held (the map's hover "Footwork 48 makes it OK, 72 makes it Good"); -1 when already there; -1 also when
   the needed value is above Attrs.HI.
8. `coach_ok(move_id, attrs) -> bool`: OK or Good (the coach's own plan writes only these, map 4.1 LINKS).
9. `swap_hint(move_id, sit, mastery, combos, attrs) -> Dictionary`: the best OTHER move out of the same card that this boxer can do
   (PlanFight.can_do) and whose worth is higher; {} when none. Returns {move, worth, was_worth, word, was_word}.
10. `words(move_id, attrs, name) -> String`: "<name> does it: Poor (Footwork 47, Speed 52)" with Attrs.LABEL names; "" for a forced
    move. No pronoun anywhere.

## The test FIRST: tests/line_grade_test.gd (extends SceneTree, prints `LINE_GRADE failures=N`, quits with N)
RED ON MAIN: run the test command on main before writing the module: the preload of the missing LineGrade.gd fails to load (a
SCRIPT ERROR, non-zero exit). Say so in the PR body with the line it printed. Assert at least:
- every non-forced row of StrikeMap.MOVES has a pair, both keys are in Attrs.ABILITIES, and the pair is the map's (loop the table);
  every forced row returns {} from grade;
- the bands sit exactly on the code's lines: means of OK_AT - 0.5 / OK_AT / GOOD_AT - 0.5 / GOOD_AT read Poor / OK / OK / Good
  (built from the constants in the test, not typed);
- the map's example: footwork 47, speed 52 on "step_back" reads Poor; next_line says footwork 48 for OK and 72 for Good (computed in
  the test as 2 x OK_AT - 52 and 2 x GOOD_AT - 52);
- graded_value equals PlanFight.value x PLUS on a plus and x Exchanges.COMMIT on a minus (one best, one ok, one wrong move);
- THE SWAP IS REAL: find, from PlanFight.ANSWERS, a card and a situation with a "best" move and an "ok" move whose pairs differ;
  build attrs that make the best one Poor and the ok one Good; assert worth(ok) > worth(best), and swap_hint on the best returns the
  ok move (or a move worth even more, asserted by worth);
- two DIFFERENT real boxers from the game's own makers (Attrs.of on deep copies of two Data.PROSPECTS rows, e.g. Kira and Samira):
  at least one move grades differently between them, and every grade reads the numbers Attrs.of gave;
- chain_grade of two moves equals the grade of the mean of their two means; coach_ok is false only on Poor;
- words() names both attributes with their values and holds no "she", "he", "her", "his";
- MUTANTS inside the test: a copy of grade with `>` in place of `>=` at OK_AT, and a copy of graded_value with PLUS and COMMIT
  swapped, must each FAIL the same asserts; print `MUTANT caught` for each; an uncaught mutant is a failure.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first: type every Dictionary read (`var v: float = float(a.get(k, 55.0))`), no `:=` on a Variant.
- A test that only your own function can pass is not a test: every expected number is built from Exchanges, PlanFight and Attrs in
  the test, never copied from your function's output.
- Do not edit PlanFight, Exchanges or any caller to "use" the grade. The one trap of this task: the grade must not change any number
  the bout plays today, or plan_fight_test and plan_bots_test move. Pure module only.
- Do NOT delete, skip or weaken any existing test. No .res/.glb/scene loads (the public mirror has no LFS assets).
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py line grade` -> PLAYBOOK_MAP_S432.md (the spec, 4.1 and 7) first; topics/plans_corner.md. The corner
calls already grade a call this way (Exchanges.grade, GOOD_AT 62 / OK_AT 50, GRADE / COMMIT): this module is that rule applied to plan
lines, as the map says.

## What would a human do?
A corner builds the plan on what the boxer does well: a boxer with slow feet is not told to box on the back foot, and a coach says
"your feet are not there yet: two shadow mornings and it is yours". The module is that judgement, with the line to cross.

## Prefab check
None applies: arithmetic on the game's own tables. Exchanges.grade is the house pattern to copy.

Test command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/line_grade_test.gd`
(the plain win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/line_grade_test.gd -> LINE_GRADE failures=0`.
