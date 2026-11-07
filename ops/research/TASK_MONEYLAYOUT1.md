# TASK MONEYLAYOUT1 - AGY (Argon High) - Club > Money: decisions first, history folded (layout only)

Status: OPEN (S399, Claude main - Claude designed the layout below). Discipline: gym money. Source: MONEY_BITES_S397.md
"Left (1)": blind stills 5.5 - "honest and readable, but a flat wall of equal cards with the decisions buried".
Operator rule (S398): nothing on screen unless the player can do something with it; one word per concept.

## Contract
OWNS: scripts/ui/areas/Money.gd, scripts/ui/areas/ClubSpend.gd, scripts/ui/UI.gd:100-125, scripts/ui/UI.gd:283-297, tests/money_layout_test.gd
RED_TEST: tests/money_layout_test.gd -> MONEY_LAYOUT failures=0
REGRESSION: game_money_test, money_close_test, plain_words_test, tip_notes_test, golden_path_test
VISUAL: yes

## The layout (top to bottom) - build exactly this
1. AreaHead (unchanged).
2. CASH STRIP: one row - cash now, this week's net (+/-), "N weeks of costs" (today's overview numbers, the bars kept but
   one card high, max 160 px tall at 1920x1080).
3. DECIDE (new section head): the ONE card that needs the player now, chosen by rule, in this order: a pro's contract talks
   open -> the gym in the red (the close clock) -> the cheapest upgrade the gym can afford with >= 4 weeks of costs left ->
   none (then the section is not shown). It is ClubSpend's existing card for that thing, moved here, with its primary button.
4. SPEND: the rest of ClubSpend's cards (premises, upgrades, kit budget, club show, stipends), each with exactly ONE primary
   action button.
5. DEALS: today's card.
6. HISTORY (folded by default, one "Show history" Btn): one-offs in, paid out, facilities/repairs. Folded = only the head and
   the button are built (no hidden walls of nodes).

## Buttons (three kinds only on this page)
- primary = `BtnSolid` (the card's act: buy, book, sign, set);
- destructive = a new `BtnDanger` variation in UI.gd's theme block (clear fill, a red line and red text: Color(0.86, 0.3, 0.27)),
  for sell / cancel / let go / end a deal;
- locked = the primary button disabled AND a visible one-line reason Label under it ("Needs $2,400 - you have $1,900"); the
  tooltip alone is not enough (UI.button gets an optional visible-reason path; keep its old behaviour for other callers).
Any other variation on this page is a fail.

## Do
1. tests/money_layout_test.gd FIRST (headless, builds the Money area for a career set like tools/money_still.gd's week-31
   state): checks section order CASH < DECIDE < SPEND < DEALS < HISTORY by child index; DECIDE holds exactly 1 card and its
   pick follows the rule for 3 scripted careers (talks open / in the red / plain); every Button on the page is BtnSolid,
   BtnDanger or Btn (the history toggle); every disabled button has a visible Label sibling with text; history folded = no
   ledger rows built until the toggle. It must FAIL on main. Start every Godot run through
   `python ops/Tools/godot_slot.py run --who agy -- <godot cmd>`.
2. Build it in the OWNS files; no new numbers or words beyond the section heads (CASH, DECIDE, SPEND, DEALS, HISTORY),
   the toggle and the locked reasons. Rules (GymSpend, GymBills) untouched.
3. Stills for Claude: `python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080
   --audio-driver Dummy --script res://tools/money_still.gd -- E:/FightCamp/tmp/moneylayout1` - list the files in the PR body.
   Claude judges them with blind critics (8/10 bar); you do not score your own work.

## Result lines (PR body)
RESULT: MONEY_LAYOUT main <n> failures -> after failures=0
RESULT: DECIDE picks <talks/red/upgrade/none> for the three careers
RESULT: stills <paths>
RESULT: regression <pass/fail per test>

## What would a human do?
Open the money page and see first the one thing to decide, then what can be bought, with the past folded away.
