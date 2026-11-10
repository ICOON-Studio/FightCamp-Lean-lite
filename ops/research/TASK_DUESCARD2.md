# TASK DUESCARD2 - CURSOR (Grok 4.7 High) - the dues boards are unreadable: give them their own tab at full size

Status: OPEN (S425, Claude main). Discipline: boxing. Model: Grok 4.7 High. Start your branch FROM cursor/duescard1.
Source: DUESCARD1 (branch cursor/duescard1, PR 172, NOT merged) passes its ten tests, but Claude rendered the real
screen (E:\FightCamp\tmp\s425_dues\26_money_real.png, 1920x1080): the three boards sit as a strip about 310 px wide and
100 px high at the bottom of the Money page, each board about 100 px wide; every line is cut off ("Cheap $25 a",
"$1,625 a m", "65 club me", "needs a .."). The operator approved three big painted price boards
(docs/mockups/s424/dues_painted_v4.png, his Q-177: "Yes, build it"). You cannot see images: build to the sizes below and
let the test measure.

## Contract
OWNS: scripts/ui/DuesBoards.gd, scripts/ui/MoneyPanels.gd, tests/dues_card_test.gd
RED_TEST: tests/dues_card_test.gd -> DUES_CARD failures=0
REGRESSION: money_slate_test, menu_money_test, money_close_test, gym_spend_test, words_on_screens_test, file_limits_test, golden_path_test
BASE: cursor/duescard1
VISUAL: Claude renders Club > Money > Dues on the hidden desktop after you push. Do not render.

## The job
1. The Money page has a row of two buttons, "The books" and "Cashbook, 4 lines". Add a third, "Dues". It shows the three
   boards ALONE in the page's whole board area (the area "The books" fills); the strip at the bottom of "The books" goes.
2. Sizes at 1920x1080: each board at least 400 px wide and 600 px high, side by side with at least 24 px between them;
   the painting on top at its own proportions (never squeezed); under it, in this order, big and few: the fee a month
   (at least 44 px type), then three rows of icon + number + ONE or TWO words: members it would hold, money a month,
   home-grown boxers in five years. No sentence on a board. The board in force keeps its gold frame and "IN FORCE" plate;
   a waiting change shows "from <month>" on the chosen board. No type under 24 px. Everything else as DUESCARD1 built it
   (true numbers from the live career, one confirm, the change from next month, a click on the band in force clears it).
3. tests/dues_card_test.gd, new checks, each red on cursor/duescard1 first (say so in the PR): the Dues button exists and
   opens the boards; each board's rect is at least 400 x 600 at 1920x1080; for every Label on a board the text's
   measured width (get_minimum_size / font string size) is no wider than the label's rect and no label is clipped or
   ends in an ellipsis; no font size under 24; the boards do not overlap each other or leave the page's board area.

## Prior research
ops/research/TASK_DUESCARD1.md (the numbers and the click rules), docs/mockups/s424/dues_painted_v4.png (proportions
only), ops/research/GDSCRIPT_TRAPS.md (Label sizing).

## What would a human do?
Three price boards on a wall are read from across the room. A strip of stamps is not a choice.

## Prefab check
The paintings exist (assets/ui/dues). No new asset.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tests/<name>.gd`. Only the tests named here.
RESULT lines for the PR body: one per test with its printed pass line.
