# TASK_U167 - the SCHEDULE tells the truth (Cursor, GUI build)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S70, 2026-09-24. Management lane (S71 carries the
GUI leftovers; this is the offers/booking half of them).

## Why
The S64/S65 career walks (a button-pressing walker that boots the real title, `tools/s64_career_walk.gd`) saw a player's
booking screens contradict each other. Still open after S69 (S65_DIGEST.md:25-27, S64_DIGEST.md:39):
1. SCHEDULE says **"0 OFFERS"** while the fighter's PROFILE lists 3 (U4 D2 hides pro-tier offers from amateurs on SCHEDULE
   only - so the two screens count different things and neither says so).
2. **"NOT KNOWN: SEX, HELD UNTIL WEEK"** prints on each amateur offer row - an internal gap list leaking to the player
   (`ScheduleHubPanel.gd:1094`, `UIKit.caps("NOT KNOWN: %s" ...)`).
3. The starter BOXER gets **no amateur bouts** (Cyprus has no boxing federation card, so only the MMA federation offers).
4. The **weight flag + CUT** show on a fighter who is NOT booked (a cut has no target weight without a bout).

## Build
1. ONE count. SCHEDULE and PROFILE show the same number for the same fighter on the same week, or the smaller one says
   what it hides in one line (e.g. "3 OFFERS - 3 PRO, HIDDEN WHILE AMATEUR"). Decide which by what U4 D2 intended (grep
   `U4 D2` in `ScheduleHubPanel.gd` / `ProfileRevampPanel.gd`) and say which in the digest.
2. The gap list never reaches the player. A field the offer does not know is either left off the row or worded as a player
   would read it ("OPPONENT TBC"). `SEX` must never print: booking already guarantees same-sex bouts.
3. A boxer in a country with no boxing federation card gets a regional amateur boxing source (the nearest federation that
   runs boxing, or the country's open circuit) - never only another sport's federation. Find where the amateur source is
   picked (grep `federation` in `GameState.gd`, windows only) and fix the pick, not the display.
4. No weight flag and no CUT action on an unbooked fighter; both return when he is booked.

## Owned files
`Godot/scripts/ScheduleHubPanel.gd`, `Godot/scripts/ProfileRevampPanel.gd` (only the offer count), the amateur-source pick
wherever it lives (`GameState.gd` is ~15,000 lines - NEVER open it whole; `grep -n` then `sed -n 'A,Bp'` windows), the weight
flag's owner (grep `CUT` / `weight_flag` in the profile and schedule panels), a NEW `Godot/tests/schedule_truth_test.gd`,
`research/U167_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. The new test asserts the QUANTITY THE PLAYER SEES: the offer
count label text on both screens for one real career (`begin_new_career` / `generate_starter_boxing_floor` /
`finalize_new_career`, Cyprus), no row text containing "NOT KNOWN" or "SEX", the boxer's amateur offers all boxing, no CUT
button on an unbooked fighter. Prove it with 3 mutants (revert each). Then `python Godot/tools/run_tests.py --only schedule`,
`--only profile`, `--only career_loop`, `--only weight` (ONE `--only` per run; read `total=` each time). Ceiling: no new red
vs master. Then ONE walk to see it: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot
--script tools/s64_career_walk.gd -- plan=<your plan> out=<scratch dir>` and put two screenshots' paths in the digest. Any
WINDOWED Godot run goes through `Tools\godot_hidden.ps1`. No full suite.
Branch `cursor/u167-schedule-truth` off `origin/master`, commit with explicit paths ON the commit line, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U167 --body "<the four items: fixed/how, test checks, mutants>"`.
Do NOT edit HANDOFF.md, and do not read HANDOFF.md, CURRENT_STATUS.md or any digest but S64/S65's.

## The one trap
Fix the SOURCE, not the label. Hiding "0 OFFERS" by printing the profile's number would make the two screens agree and still
leave an amateur able to see offers he cannot take. And the gap list is a data fact: the offer genuinely does not know those
fields - say what the player needs, do not invent a value.
