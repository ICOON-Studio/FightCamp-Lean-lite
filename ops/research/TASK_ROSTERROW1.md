# TASK ROSTERROW1 - QWEN (qwen3-coder) - what one fighter's row on the Fighters page says: one pure module + its test

Status: OPEN (S438, Claude main). Discipline: boxing (the no-gi athlete gets a row with her own words). Model: qwen3-coder.
Source: the operator approved painting 1 of the Fighters page; its contents are fixed in
ops/research/CORE_LOOP_MAP_S432.md section 3, "FIGHTERS PAGE, approved" (lines 74-88: read them first). Cursor builds
the page (ops/research/TASK_PAGES2.md); THIS task is only the data behind one row: values and words, no nodes, no
scene, no drawing.

## Contract
OWNS: scripts/rules/RosterRow.gd, tests/roster_row_test.gd
RED_TEST: tests/roster_row_test.gd -> ROSTER_ROW failures=0
REGRESSION: roster_cards_test, roster_flag_test, roster_summary_test, fighter_profile_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Never change a rule or a screen to fill a cell: read what the game already computes.

## The row (1920 x 1080 page; a row is 1826 wide x 198 high, rows 200 apart, the first at y 190)
Columns, left edge x and width, in the painting's order. Header words in gold small caps above the first row.
| col | x | w | what it shows (top to bottom) | from |
|---|---|---|---|---|
| FIGHTER | 46 | 370 | round face pin 120 (Halo.cutout look, never a square); a red badge on the pin when she needs you; name on a navy label; weight class + age; style word + stance; record + the road line in gold | Roster, Faces, FighterProfile, BeltRoad / the rank a fight earned |
| OVERALL | 430 | 300 | a ring 0-100 with the number inside; five thin upright bars with their numbers: Head, Hands, Guard, Cardio, Legs (the five groups of FighterProfile); a gold dot under the group where she is the best of the roster; "Best move: <move> <mastery> <word>" | FighterProfile groups, MoveMastery |
| TIREDNESS | 744 | 120 | the number large, a bar with a tick at 80, one word (Fresh / Tired / "3 rest days") | the same read the fighter page uses |
| WEIGHT | 872 | 120 | kg large, a bar with the limit tick, "limit 65.0", or amber "0.9 kg over" ONLY when a weigh-in is coming | weight rules as the fighter page reads them |
| MOOD | 1002 | 120 | number, bar, word | mood as the fighter page reads it |
| COACH SAYS, THIS WEEK | 1132 | 310 | Coach's one change with its tag (FIX / REST / DRILL) and its weekly gain; under it the goal ring: goal, days left, status | CoachCheck / NextStep, FighterGoal |
| NEXT FIGHT | 1452 | 230 | days large + a tag (OFFER / BOOKED / OPEN), opponent name and record, date and answer-by; or "No bout" + when the next offers come | BoutRules / the offer the Fights page shows |
| DO NEXT | 1690 | 180 | ONE pin with its words: the single most urgent thing (a gold filled button when it stops the clock: Answer offer; else a round icon pin: Set a goal, Rest 3 days, Enter the open) | Needs (state/Needs.gd) in its own order |
A row that needs the player has the warm red-brown plate behind it (the first row in the painting); the others sit on
the slate with a thin line between rows. Click anywhere on a row = her page (as the table did); the DO NEXT pin does
its own action through `main.act` exactly as the same need does on Home.
Numbers are large (36 px or more), captions 18 px or more, nothing under 16 px (the operator: "fonts are small").
Every bar tweens to its value (MenuFx; the house rule "every bar tweens"). Words a player cannot act on go to the
hover, not the row.


(The x / w numbers are Cursor's; you need the "what it shows" and "from" columns.)

## The job
1. `scripts/rules/RosterRow.gd` (pure, static): `row(c: Career, fighter_id) -> Dictionary` with one key a column,
   each holding plain values and words (no nodes), and `best_of(c) -> Dictionary` (group -> fighter id, the gold
   dot). It READS the same functions the fighter page and Home read today; where two screens could disagree, call the
   one function both use. `tests/roster_row_test.gd` FIRST, red on main: on the quick-start career and on a career
   with a booked bout, an open offer, a tired fighter (80+), an overweight fighter with a weigh-in in 3 days and one
   without, a met goal, and the no-gi athlete: each column's values equal what the fighter page's own read gives for
   the same fighter (assert against those functions, not against typed numbers); DO NEXT equals the first need
   `Needs` lists for her; "kg over" appears only with a weigh-in coming.

Where to look first: scripts/ui/RosterTable.gd `rows` / `_boxer_cells` / `_grappler_cells` (most cells are gathered
there already: lift the reads, not the nodes), scripts/ui/areas/FighterPage.gd (tiredness, weight, mood, goal),
scripts/state/Needs.gd (DO NEXT), scripts/rules/FighterProfile.gd (the five groups), MoveMastery.gd (best move),
CoachCheck.gd and NextStep.gd (Coach says), BoutRules.gd and scripts/ui/areas/Fights.gd (the offer and the bout).
`row()` returns, per column key (fighter, overall, tiredness, weight, mood, coach, next_fight, do_next), a Dictionary
of plain values: numbers as numbers, words as Strings, a `tone` ("ok" / "good" / "watch" / "bad") where the painting
colours a value, and `needs_you: bool` on the row. Under 300 lines.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (Variant `:=` on Dictionary reads: type the variable; `%%`).
- Words: "Cardio" never "Engine"; staff by role ("Coach"); no pronoun for a fighter in a built string.
- A test that only your own function can pass is not a test (S420): assert each cell against the function the
  fighter page or Home already calls for the same fighter, never against a number you typed.
- Never test identical fighters: the careers in the test hold fighters that differ.
- A value the game does not have today is left out of the Dictionary (and listed in a comment at the top of the
  module): never a placeholder word.

## Prior research
ops/research/CORE_LOOP_MAP_S432.md section 3; docs/mockups/s431/final/squad.html (the words); ops/research/TASK_PAGES2.md.

## What would a human do?
A manager reads a squad row left to right: who, how good, how she is today, what Coach wants, what is coming, the one
thing to press. Each cell must say the same thing her own page says.

## Prefab check
RosterTable.rows already gathers most of it. No outside asset applies.

Test command: `<godot.exe> --headless --audio-driver Dummy --path . --script res://tests/roster_row_test.gd` (the
plain win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/roster_row_test.gd -> ROSTER_ROW failures=0`.
