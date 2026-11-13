# TASK CORNERFIX5 - the 3D corner card: four of his marks (S443, C320-C323)

Status: DONE - S443: the corner card's four marks (C320-C323) built and reviewed (bd97214c).
Model: Opus. Discipline: boxing (demo). His marked still: ops/Feedback/2026-11-12-10/marked.png (open it with the Read
tool; the original is the board's corner_3d_real.png). His words, verbatim:
1. Coach line (box over "Priya was waiting to counter at the end of that round..."): "are these random preset lines with no
   base on the fight ?" - the same still shows 0 of 0 punches for both, so the line cannot have come from that round.
2. Plan cards' "When Priya presses": "how many times i need to tell you do not make the text about one fighter , write
   instead : when pressed and skip names and long descriptions".
3. "Good at it, saves energy" under each plan: "remove the good at it etc , shot the costs of energy instead".
4. The Recover row (Water and breathing / Ice on the ribs, dots, + / -): "this doesnt seemlike an option for the player
   needs improvement tso player understands what is the difference on each , real time changes should be shown with
   graphics or somehow".

## What to build
1. TRACE the coach line to its source (scripts/rules/CornerJobs.gd, scripts/fight3d/CornerOverlay.gd and what they read).
   It must be built from the round just fought (the round's exchanges / FightStats), and say nothing it cannot point to.
   With no punches in the round (a skipped or empty round) it says so plainly or stays empty. Also find out why the still
   shows 0 of 0 for every punch line with energy spent: a real defect or a still taken before the round ran? Fix it if it is
   a defect; say which in the report.
2. Every "when" phrase on the corner card and the plan cards: no fighter names, short: "When pressed", "At range",
   "When they wait to counter", "When tired", "When hurt" (CornerJobs.GAP_WORDS {opp} forms, Exchanges.gd "Use when
   {opp} presses", FightFlow.WHEN_WORDS: grep for {opp} and the name substitutions used by the corner card).
3. Remove "Good at it / Fair at it" from the plan cards; in its place DRAW the energy cost: a small energy bar or pips
   (one colour; e.g. saves = green up-arrow pips, costs = amber/red down pips, "a lot" = more pips), read from the same
   numbers the words came from. No new number typed by hand.
4. Recover row as a choice the player understands: each option a small card with an icon, what it changes in plain words
   ("+3 energy", "-3 body hits"), and a live preview: as points are put in, the energy bar at the top ("Energy at the bell")
   and the body figure show the change before the bell (ghost segment or arrow on the bar). Points left shown as pips.
Keep the screen within 1920x1080 (the card was 924 px tall and reached the bottom bar: fix that too).

## Rules
Game words, never he/she/him/her. No script over 500 lines. Shared checkout: other sessions work here (AskBout, ask_probe,
POWER1 in its own worktree, the Money/HoverLabel and Stamina helpers): stage explicit paths, commit to main, do not push,
never stash/reset/checkout ./clean/add -A. Godot only through `python ops/Tools/godot_slot.py run --who cornerfix -- ...`.
Tests: the ones that grep the files and words you change (corner_card_test, corner_jobs_test, corner_swap_cards_test,
round_board_test, ... find them with grep), each red first if you add a check. A real still of the corner card after a
real round through tools/hidden_desktop.py + the game's fight flow (tools/fight3d_play.gd), opened by you, saved under
docs/mockups/s443/corner/. Report: files, pass lines verbatim, still paths, the coach-line source, commit hash.
