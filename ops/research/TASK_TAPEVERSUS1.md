# TASK TAPEVERSUS1 - CURSOR (Grok 4.7 High) - fight night's Tale of the tape drawn as the bout offer screen

Status: OPEN (S419, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator, 2026-11-10, looking at the bout offer screen: "the offer screen can be uses also as a tale of the tape screen". Fight night's first step (FightNight.gd `_tape`) is today a pop-up with two framed tables of label and value rows over a dimmed gym. He has called such panels "excel board". The bout offer (VersusPanel) is the screen he likes: red half and blue half, each boxer standing full height on their side with the club crest behind, the names in brush lettering, one framed card in the middle.

## Contract
OWNS: scripts/ui/VersusPanel.gd, scripts/ui/TapeVersus.gd (new), scripts/rules/TapeRows.gd (new), scripts/ui/modals/FightNight.gd, scripts/ui/BoutCompare.gd, scripts/ui/FightPrep.gd, scripts/fight3d/TapeCard.gd, tests/tape_versus_test.gd (new), tests/tape_rows_test.gd (new), tests/tale_of_tape_test.gd
RED_TEST: tests/tape_versus_test.gd -> TAPE_VERSUS failures=0
REGRESSION: versus_test, tale_of_tape_test, golden_path_test, camp_slate_test, wood_kit_test, no_pronoun_test, words_on_screens_test
VISUAL: yes

## Prior research
- scripts/ui/VersusPanel.gd whole (255 lines): `build()` makes the two sides (`_side`, `_crest`, `_tag`) and the centre card (`_card`, `_rows`, `_read`, `_answer`). S419 fixed `_tag` to chalk ink; keep that.
- scripts/ui/modals/FightNight.gd lines 30 to 80: the `"tape"` step, the rows it shows (record, weight, camp, film tells answered, style, threat, weakness, the unknown-until-on-tape rule from OppFile.known) and its two buttons (Sim to result, Begin fight). The other steps (round, result) are NOT this task.
- tests/versus_test.gd and tests/camp_slate_test.gd: how a page is built headless at 1920x1080 and its edges checked; tests/slate_walk.gd `SlateWalk.faults(page)` after `WoodKit.ink(page)`.
- ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A boxing broadcast's tale of the tape: the two boxers face to face, and between them one column of paired numbers (record, age, weight, height, stance), read across. Nothing else until the bell.

## Prefab check
None: our own VersusPanel is the prefab.

## The job
1. Split what both screens share out of VersusPanel into functions both can call (the two sides and the paired rows). Do not copy the code. VersusPanel.gd and the new TapeVersus.gd each stay under 500 lines; FightNight.gd (385) must not grow.
2. Fight night's tape step shows the full-screen versus picture in place of the pop-up with tables:
   - the two halves and standing boxers exactly as the offer shows them (same kit colours, crests, poses), fight day and "3 x 3 min" (the bout's real rounds) at the top of the centre card;
   - the paired rows: Record, Age, On the scales (both weights as weighed), Height, Stance: the same row drawing as the offer, the better value tinted as the offer does;
   - under the rows, two short lines in the centre card: the camp (its focus and protocol) for the club's boxer, and the opponent's threat and weakness, each "unknown: not on tape" unless OppFile.known says otherwise; film tells answered as "2 of 3" beside a small film icon (KitIcon), not as a sentence;
   - the corner tags (bottom left and right) carry Shape and Mood for the club's boxer and Style for the opponent, as on the offer;
   - the long note about shouting calls is cut from the picture and becomes the tooltip of Begin fight;
   - two buttons only, where the offer has three: "Sim to result" (quiet) and "Begin fight" (red). Same actions as today.
3. Nothing under 20 px. No sentence over 8 words on the picture. No "he" or "she".
4. tests/tape_versus_test.gd: the tape step builds at 1920x1080 with both sides and both buttons; every row is inside the centre card and the card inside the screen; no label under 20 px; `SlateWalk.faults` is empty; Begin fight and Sim to result still start the round and the sim (the same `main.act` calls as before); an unknown threat reads "unknown: not on tape". Update tale_of_tape_test.gd only where it reads the old pop-up's nodes; keep every fact it checks.

## 5. ONE tale of the tape (added S419, the operator the same hour: "how many tale of tape screens you are using , i saw at least 2")
There are four today, each with its own rows and order: the fight night pop-up (FightNight._tape), the card on Fight prep (FightPrep.gd, "THE TALE OF THE TAPE"), the card in the bout comparison (BoutCompare.gd, "TALE OF THE TAPE") and the in-ring broadcast card (scripts/fight3d/TapeCard.gd: age, height, reach, weight, record, stance, style, club). The bout offer is a fifth set of the same facts.
- scripts/rules/TapeRows.gd (pure, with tests/tape_rows_test.gd): ONE function returns the paired rows for two boxers, in ONE order (Record, Age, Weight, Height, Reach when both are known, Stance, Style), each row {label, left, right, better}. A fact the club does not know about the opponent is "?" with the reason for the tooltip. Every screen below takes its rows from it; no screen builds its own list.
- The offer and fight night: the versus picture (sections 1 to 4).
- Fight prep and the bout comparison: their tape cards are REMOVED where the versus picture is one click away, or drawn from TapeRows with the same row drawing as the centre card if the page needs the numbers in place. Say in the PR body which you did for each and why.
- The in-ring card (TapeCard.gd) stays a dark broadcast strip, but its rows, labels and order come from TapeRows.
tests/tape_rows_test.gd: the order, the "?" rule, `better` on record, height and reach, and that all four callers get the same labels for the same two boxers.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/tape_versus_test.gd` (never the console build). You cannot see pictures: Claude renders `18_tape` with tools/layout_snapshot.gd and opens it at collect, so make the geometric checks in the test real (edges, sizes, overlap of the two buttons, the corner tags not over a boxer's feet: keep each tag at least 12 px clear of the figure's rectangle).

## The one trap
Do not invert or loosen a check to pass (S418: a ">= 1080" was written for "fits the screen"). Claude reads every comparison in the new test.

## Result lines (PR body)
RESULT: tests/tape_versus_test.gd -> TAPE_VERSUS failures=0
RESULT: tests/versus_test.gd -> PASS versus_test
RESULT: tests/tale_of_tape_test.gd -> (its pass line)
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
