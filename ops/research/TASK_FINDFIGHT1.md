# TASK FINDFIGHT1 - the FIND A FIGHT button, the opponent panel and the fight countdown pill on the floor HUD (S239, LOOP1 slice 4)

Seat: cloud Cursor (Godot UI). Branch `cursor/issue-<n>`; Claude merges by diff. Model: Cursor default. Discipline: BOXING (demo).

Operator (board Q-S237-1, verbatim): "build it, the equipment wear is not what matters on this , the loop , animations,workout,feeling
of progrsession and improvement from training these are what matters for now". Verdict: research/LOOP1_VERDICT_S238.md step 6.
Design: lead designer Ludo r105, `research/ludo_rx/LUDO_R105_raw.txt` PART B (B1, B2, B3). Follow its sizes, colours, labels.

## Do - three new files, pure UI (no GameState, no autoload reads; data comes in through the functions below)
1. `Godot/scripts/ui/FindFightPanel.gd` (extends Control, built in code like `scripts/ui/GoalCard.gd` - read it first and match its
   style: dark panels, fonts, tween-in).
   - `func show_rows(rows: Array) -> void` - rows are FightBoard rows (the pure module built in parallel by Arena, TASK_FIGHTBOARD1.md):
     `{offer_id, name, record_text, rating, style_word, stance, scout_line, purse, fight_day, days_out, fits_goal, tag}`.
   - Layout (Ludo B1/B2): full-screen backdrop #000000 @ 0.75 that eats clicks; panel at (360, 140), 1200x800, #0F172A, 2 px border
     #334155, corner radius 0; header "AVAILABLE BOUTS" 20 px bold #F8FAFC; close [X] top-right (emits `closed`). Up to 4 rows,
     1152x140, 12 px apart. Columns: name 18 px bold #FFFFFF + record badge in gold #F59E0B (w 260); style_word + "SOUTHPAW"/"ORTHODOX"
     tag (w 220); scout_line italic 13 px #CBD5E1 (w 320, wraps, never cut); purse "$4,500" #22C55E + "DAY 14 - 14 DAYS OUT" #E2E8F0
     (w 180); tag badge (w 140): fits_goal green "FITS YOUR GOAL", else grey "STANDARD BOUT".
   - Click a row -> 2 px #EAB308 border on it + an "ACCEPT CONTRACT" button (#16A34A, 160x44) at its right. Click it -> a small
     centred confirm: "Sign contract vs <NAME> for day <N>?" with CONFIRM / CANCEL. CONFIRM emits `book_requested(offer_id)` and
     closes. Empty rows -> one centred line "NO BOUTS IN YOUR CLASS THIS WEEK".
   - Every label sized to its text (GDSCRIPT_TRAPS "Label sizing"); nothing clipped at 1920x1080.
2. `Godot/scripts/ui/FindFightButton.gd` (extends Button or Control): "FIND A FIGHT" at (1664, 24), 224x48, #181E24, 1 px #334155,
   gold text #F59E0B, bold 14 px uppercase; emits `pressed_find`. `set_locked(locked: bool, why: String)` greys it with a tooltip
   (a booked bout locks it until the result: "BOUT BOOKED").
3. `Godot/scripts/ui/FightCountdownPill.gd` (extends Control): at (1520, 96), 368x64, dark grey, red #DC2626 border; `show_bout(name:
   String, days_left: int)` -> "BOUT LOCKED - <NAME> - <N> DAYS" ("FIGHT DAY" at 0); `clear()` hides it. Animated: the number tweens.

## Tests
New `Godot/tests/find_fight_panel_test.gd` (extends SceneTree, `_initialize`, prints `FIND_FIGHT_PANEL failures=N`, quit(1) on fail).
Build each control under a 1920x1080 root Control. Fixture rows printed (3 different opponents: an out-boxer orthodox that fits the
goal, a southpaw pressure fighter, a counter-puncher; plus a 0-row case). Assert: 3 rows drawn, the FITS YOUR GOAL badge only on the
first; row click shows ACCEPT CONTRACT; confirm emits book_requested with that offer_id and the panel closes; CANCEL emits nothing;
[X] emits closed; the panel, button and pill rects match the positions above (+-1 px) and do not overlap the GoalCard band
(x 640..1280, y 8..130 - it sits top centre) or each other; no Label's text is wider than its rect. Run:
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/find_fight_panel_test.gd`.
Parse gate first: `python Godot/tools/check_scripts.py <the 4 files>`.

## Rules
GDSCRIPT_TRAPS.md. Create only those four files - do NOT edit GymHall3D.gd (Claude wires it: it is 4,000+ lines and owned).
New features ship ON. THE ONE TRAP: never delete or weaken a test to go green. A still of the panel at 1920x1080 is welcome
(SubViewport capture into the PR) - Claude judges it on the game camera.

## Prior research
LUDO_R105_raw.txt PART B; scripts/ui/GoalCard.gd and scripts/ui/TrainingMetersHud.gd (the floor HUD's own look); LOOP1_VERDICT_S238.md.

## What would a human do?
A promoter's sheet with four names on the office desk: record, style, the purse, the date; the manager points at one, signs, and
the date goes on the whiteboard with a countdown.

## Prefab check
Godot built-in Controls only; no asset needed.
