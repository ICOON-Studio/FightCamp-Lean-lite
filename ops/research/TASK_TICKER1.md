# TASK TICKER1 - the morning card becomes a ticker in the top time bar; the calendar tab shows a countdown (S197)
Model: Cursor (default) - Godot UI. Worktree E:/FightCamp/wt/TICKER1, branch cursor/ticker1 (from master).
Operator S197 approved (board Q-S196-1, verbatim: "approve all") Ludo round 31 Part 2 - research/LUDO_ROUND31_S197.txt
lines 209-270 and the verdict research/LUDO_ROUND31_VERDICT_S197.md section 1. He asked first: "remove those fromall stills"
(the card and the tab cover the gym).

## Goal (game, not only stills)
1. The floating morning card (`GymHall3D.show_morning`, node "Morning", GymHall3D.gd ~1372, called from GymHallPanel.gd:326) is
   no longer a card over the floor. Its content goes into ONE line inside the existing top time bar (`ClubSpeedControls.gd`,
   62 lines - keep its play/pause/fast buttons): `MON, WEEK 1 | <speed buttons> | <headline. line> | [STEP IN]`.
   Ludo's rects at 1920x1080: bar Rect2(360,12,1200,52); date Rect2(372,20,180,36); speed Rect2(560,20,140,36);
   line Rect2(710,20,560,36) single line, ellipsis + full text in a UIKit.tip tooltip; action Rect2(1390,18,150,40) gold #D69E2E
   fill, text #0C0E12, label STEP IN (or CONTINUE). SKIP THE DAY stays reachable: a small second button or right-click menu
   on the action, with the same lock + why_not tooltip as today. Bar bg #12161F at 95%, 1 px border #2D3748.
2. Fight week / forced mornings: the line reads like "[!] DEBUT IN 5 DAYS: <line>" in amber #DD6B20 and the action is STEP IN.
3. The calendar edge tab (`FightWeekRail.gd`, node "FightWeekRail") becomes a 36 x 180 px tab at Rect2(1884,380,36,180):
   calendar icon + the countdown to the next event ("5d", "TODAY"); click opens the rail as today.
4. Behind a switch `morning_ticker` (career key or user arg), default ON for the game (`as_game`) and OFF headless (tests are the
   control arm) - follow how other switches are read (grep `is_hud2_on`).
Tooltips: UIKit.tip, never tooltip_text (it is cleared). Icons over text.

## Owned files
Godot/scripts/GymHall3D.gd (1,787 - read windows only, ~1372 show_morning), Godot/scripts/ClubSpeedControls.gd, 
Godot/scripts/FightWeekRail.gd (165), Godot/scripts/GymHallPanel.gd (663, ~300-330), new test Godot/tests/morning_ticker_test.gd.

## Gates
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`
- Test (new, red on master first): with the switch ON, after the morning is shown: no visible node "Morning" in the HUD; the time
  bar holds the date, the line text (== GymHallPanel.morning_card's headline + line) and an action button whose press does what
  STEP IN does today; SKIP reachable and locked when forced; the rail tab is <= 40 px wide and shows a countdown. With it OFF the
  old card still appears (control arm).
- Related: `python Godot/tools/run_tests.py --only morning --jobs 2`, `--only gym_hall --jobs 2`, `--only club_ --jobs 2`: no new red.
- Stills: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 1920x1080 --script tools/gym_club_stills.gd -- as_game gym3d_main gym4_club out=docs/previews/ticker1`
  (you cannot see images: Claude opens them).

## Prior research
LUDO_ROUND31_S197.txt Part 2; BUYER1 (the morning card), HUD2 / M34 time bar notes in S186-S191 digests; feedback "Icons over text".
## What would a human do?
Football Manager / Two Point: the day's news is a line in the top bar, decisions pop only when needed.
## Prefab check
n/a - our own HUD.
## The one trap
The card is also read by tests and the playtest walk (PLAYABLE1 presses STEP IN): keep the same signal/callable for STEP IN and SKIP,
only the presentation moves. Commit on cursor/ticker1, push; never master; never open windows or image viewers.
