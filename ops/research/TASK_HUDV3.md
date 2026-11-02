# TASK HUDV3 - Ludo's V3 screen layout, assembled whole (behind switch `hud_v3`, OFF by default)

Model: gpt-6-luna (Codex, medium effort)
Operator S205 (verbatim): "i thouthght ludo proposed money on top left and some other changes" / "i want to see it with ludo
recommendation". The layout was APPROVED in S200 (LUDO_ROUND35_VERDICT_S200.md section V3) and never assembled.

## Spec - where every item sits at 1920x1080 (Ludo r35 table, LUDO_ROUND35_S200.txt lines 340-360)
Add `GameState.is_hud_v3_on()` exactly like `is_hud2_on()` (GameState.gd:17891, key "hud_v3", cmdline arg "hud_v3").
hud_v3 implies hud2 (call apply_hud2 first, then re-place). With hud_v3 ON:
1. MONEY top-left (16,16 320x64): the `Pills` node (ShellChrome.gd:552, today at 1360,14) becomes a plate at that rect: cash
   big (JetBrains-like mono look via UIKit mono font if present, else existing font), under it "run rate $X/wk" from the same
   data the Office screen shows (OfficeHubPanel "THE WEEK NETS"). Click = open the office route (same as Nav_office).
2. TIME BAR top-centre (540,12 840x48): club crest+name, DatePlate, speed controls, CONTINUE inside it on its right end.
   The bell (mail) sits at the bar's right end, left of CONTINUE.
3. FIGHT COUNTDOWN top-right (1600,12 304x80): "FIGHT IN 9 DAYS" + opponent name + date, from the booked bout
   (GameFightWeek / the schedule's next bout); no booking = "NO FIGHT BOOKED" + a FIND A FIGHT button to the schedule offers tab.
4. ICON DOCK left (16,120 56x420): the NavIcons column (apply_hud2 already builds it at 16,76) moved to y=120.
   Options (gear) / Handbook / Back move under the dock's last icon (no longer in the money corner).
5. GOALS left (16,560 240x160): DayGoalsHud on the club screen.
6. FIGHTER HAND bottom-left (16,960 380x104) - FighterHand, already there; check the rect.
7. DAY FEED bottom-centre (410,960 480x104): the last 3 lines of the day feed (DayFeedPanel's data source), newest on top,
   click = the day feed route.
8. RIGHT DRAWER (1190,0 730x1080): DrawerHost already; when it is open the time bar shifts left to x=180 and the feed narrows to 380.
The inner pages (schedule, office, rankings...) are now full-screen (S205: HOSTED_SHIFT -312, WIDTH 1794): they start right of the
dock (x>=88) and below the time bar - nothing of the V3 chrome may overlap a page's controls.

## Owned files
- Godot/scripts/ShellChrome.gd (971 lines; apply_hud2 at ~633-700: add `apply_hud_v3(bar)` beside it)
- Godot/scripts/CareerRoot.gd (506 lines; _rebuild_shell ~270-295 calls apply_hud_v3 when on)
- Godot/scripts/GameState.gd (NEVER read whole: `sed -n 17880,17900p`; add is_hud_v3_on beside is_hud2_on)
- Godot/scripts/GymHallPanel.gd (941; goals + feed on the club screen, ~60-200)
- new Godot/scripts/ui/HudV3Widgets.gd (countdown + feed strip builders, static funcs)
- new Godot/tests/hud_v3_layout_test.gd

## Acceptance test (tier: script edited)
`hud_v3_layout_test.gd`: with hud_v3 ON builds CareerRoot on a career with a booked bout and one without; asserts each item's
global rect equals Ludo's rect (+-4 px), no two V3 items overlap, every item inside 1920x1080, the countdown reads the real
days-to-bout (and NO FIGHT BOOKED without one), the feed shows the newest line first; with hud_v3 OFF the bar is byte-identical
to today (positions of Pills/NavIcons/Options unchanged). Make it RED first on the shipped tree (no is_hud_v3_on -> fail), then green.
Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/hud_v3_layout_test.gd` (exe in
%LOCALAPPDATA%\Programs\Godot\; never the _console exe), then
`python Godot/tools/run_tests.py --jobs 2 --only hud2,shell,career_root,gym_hall,office_nav,fighter_hand`.
Commit on your branch with a clear message. Do NOT take stills, do NOT open any window or image viewer (no start/Invoke-Item/
explorer); Claude shoots the stills on the game camera.

## Prior research
`python Tools/prior_research.py hud layout money top-left dock countdown`: LUDO_ROUND35_S200.txt (the pixel table),
LUDO_ROUND35_VERDICT_S200.md V3 (adopted, 3 items parked: climate readout, heatmaps, sparring overlay - do NOT build them),
HUD2_OPERATOR_PICK_S186.md (why the corner clusters exist), K_HUD2_KALLI.md / M_HUD2_MARIA.md (number formats: "$24,180").

## What would a human do?
A UI programmer handed a designer's pixel sheet re-anchors the existing widgets to the sheet first, adds only the two missing
widgets (countdown, feed strip), and keeps the old layout one switch away so the producer can flip and compare.

## Prefab check
Nothing to fetch - every widget exists in the repo (Pills, NavIcons, DatePlate, ClubSpeedControls, DayGoalsHud, FighterHand,
DrawerHost, DayFeedPanel data); Godot built-in Controls only.

## The one trap
apply_hud2 puts ContinueUnit at (0,0) screen-sized with mouse_filter IGNORE so its halves can sit in different corners - if you
move Continue into the time bar, keep the unit IGNORE or it eats every click on the hall. Walk tools find nodes BY NAME
(ContinueUnit/DatePlate/Continue/Nav_<id>/Pills): never rename them.
