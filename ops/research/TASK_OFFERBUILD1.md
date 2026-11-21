# TASK OFFERBUILD1 - build the bout offer as a letter (owner Q-S294-296 "Yes, build it")

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535: C448 "this looks too much like the tale of tape, maybe change it ?" -> mockup -> "yes build it".

## Spec = the approved mockup
`ops/previews/s535_offer_mockup/offer.html` / `offer.png` (read docs/OFFERTAPE1_RESULT.md part 2). Build it into the real offer
screen, `scripts/ui/areas/BoutPage.gd` (the "Accept the bout" page), same words, layout and look:
- centre: the host club's letter (crest, "Bout offer", the matchmaker's line, the night, time to prepare, money to the club and
  purse, sanction, IF YOUR BOXER WINS / LOSES boxes, the answer-by stamp);
- left: our boxer (painted body, record, Last 5, streak, shape and mood, on the scale, what a pass costs);
- right: the coach's read (win chance bar with the range, gain, risk, how sure) and the opponent (painted body, Last 5, streak,
  style, best punch or "not on tape"), WHAT DECIDES IT (record, reach, experience), scouting line;
- the buttons: Pass (its cost), Full report, Accept the bout (date and money).
Every number from the game (BoutRead, TapeRows / TapeForm, CoachRead, the offer's own data) - nothing typed in; a fact not known
shows "not on tape". Names only in headers (owner S448). Tooltips explain, never repeat the label (owner S532). No file over 500
lines (split the page into parts if needed).

## Tests
Red first: a screen test that the offer page builds the letter's sections from a quick-start offer and that the old stat table is
gone (find the existing bout-offer tests, e.g. grep "Accept the bout" tests/). Regression: tape_rows_test, tape_form_test,
golden_path_test, and any bout-offer / BoutPage test.
Still: `tools/layout_snapshot.gd` on the hidden desktop (the screen in the real flow, clean_view rules), next to the mockup;
open it yourself; review board: `python ops/Tools/review_add.py --stage S535 --rating "<your score>" --title "Bout offer as a letter: built vs mockup" <files>`.

## Prior research
docs/OFFERTAPE1_RESULT.md, memory feedback_names_only_in_headers_s448, feedback_only_actionable_info_s398,
feedback_screen_logic_of_the_moment_s439, feedback_tooltips_explain_s532.

## What would a human do?
Build exactly what he approved, wired to real numbers, and show him the built screen beside the mockup.

## Prefab check
None: the mockup, the painted bodies and the UI kit exist.

## Contract
OWNS: scripts/ui/areas/BoutPage.gd, tests/bout_offer_letter_test.gd, docs/OFFERBUILD1_RESULT.md
RED_TEST: tests/bout_offer_letter_test.gd
REGRESSION: tests/golden_path_test.gd, tests/tape_rows_test.gd, tests/tape_form_test.gd
VISUAL: yes (the built screen beside the mockup)

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who offerbuild1 -- <command>`; screens on the hidden desktop. Never stage
LineGrade.gd, LiveRound.gd, StepWire.gd. Stage explicit paths, commit to main with the Co-Authored-By line, push, report in two lines, stop.
