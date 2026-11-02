# TASK NEWCAREER2 (S219) - finish the New Career screen, step 3 "THE GYM" (operator C58 + Ludo round 53, approved)

Model: cloud Cursor (label `cursor`). Branch `cursor/issue-<n>` from master. Never master. Open a PR.

## Operator, verbatim
- C58 on the current screen: "Ask forludo approval , this doesnt look like finished , askludo for ideas on ingame menu presentation".
- Board Q-S212-16: "Approve all" (Ludo round 53 verdict). Board Q-S219-1 palette: "Warm brown" - KEEP the creation screens' warm
  dark brown + yellow theme (UIKit `T.*` colours as they are). Do NOT use Ludo's navy hex values.

## Read first
`research/LUDO_ROUND53_VERDICT_S219.md` section A (what is TAKEN and the 6 corrections) and `LUDO_ROUND53_REPLY_S219.txt`
Part A (layout, tile card, copy, motion, checklist). The current screen: `previews/s219/palette_compare.png` (left half).

## Files (line counts, anchors)
- `Godot/scripts/CreationFlowPanel.gd` (815 lines): `_build_gym()` line 296 builds step 3; `_draw_take()` 482; `_on_start_preset()` 416;
  `_action("OPEN GYM", ...)` 395; test hooks from line 735 (`contract_for_test`, `start_preset_for_test`, ...) - keep every hook.
- `Godot/scripts/UIKit.gd` (8,775 lines - never read whole; `sed -n 7950,8120p`): `starter_take()` 7959, `_creation_floor_view()`
  8049, `_creation_silhouette()` 8074.
- `Godot/scripts/GameState.gd` (~27k lines - never read whole): `generate_starter_boxing_roster()` line 4967 hard-codes
  `primary_disciplines := ["boxing", "mma", "wrestling"]` (window `sed -n 4967,5030p`); `get_creation_gym_take()` 19458.

## Do
1. BOXING ONLY (defect): the boxing demo's starter roster has no MMA or wrestling fighter. Make `generate_starter_boxing_roster` all
   boxing (keep its seeding so the same gym name gives the same fighters; ages/records/stats as today). Then any test or fixture that
   counted disciplines must still pass - run the dependent tests below.
2. ROSTER PER START: story (The House That Holds) = Mara Solano only, from the story cast data (StoryCast / first_hour.json - her real
   name, age, record, stats; never invented numbers); Guided Sandbox = ONE generated boxer; Open Sandbox = TWO generated boxers. The
   roster block updates when the START chip changes. What OPEN GYM saves must equal what the screen shows (the existing contract).
3. LAYOUT (1920x1080, warm brown theme): left = name fields + START chips + ADVANCED (Story/Guidance switches only - no new options);
   a 4-tile strip: STARTING CASH, WEEKLY UPKEEP, RUNWAY (weeks = cash / (upkeep + the starter roster's weekly wages), the same sum the
   game's runway uses - see GymHallPanel `_with_runway`; never cash/upkeep alone), FLOOR SPACE; then FLOOR (left) beside ROSTER.
   RIGHT COLUMN (no empty space): top = the club floor preview (reuse `_creation_floor_view` drawing, larger); middle = the selected
   START's pitch card (title, badge, 2 pitch lines, what is on/off - copy from the verdict/Ludo Part A.2, corrected: kg, no dev text);
   bottom = OPEN GYM (yellow primary) + "Open Gym saves the career" note.
4. EQUIPMENT TILES as cards: name + size + a 10-step condition bar (green 80-100, amber 50-79, red < 50 with a wear warning on hover),
   weekly upkeep, what it trains; EMPTY space = ONE hatched dashed block "+ INSTALL EQUIPMENT: n m2 AVAILABLE" (never grey voids).
   Hover = highlighted border + tooltip.
5. MOTION (UIKit tween helpers, every bar tweens): entry slide/fade (~450 ms, tiles staggered 30 ms), START switch cross-fade 200 ms.
6. NO dev text on the screen; units kg.

## Test - new `Godot/tests/new_career_finished_test.gd` (+ keep the existing ones green)
Prints `NEW_CAREER_FINISHED_TEST PASS (<n> checks)`. Checks (Ludo's list, corrected): every starter fighter's discipline == boxing for
10 different gym names; story start -> roster is exactly Mara Solano and she is female; guided -> 1 fighter, open -> 2; no tile without
a condition bar; exactly one install block when free space > 0, none when 0; cash = 25,000 and upkeep = the floor's upkeep sum;
runway weeks = floor(cash / (upkeep + wages)); right column has the preview, the pitch card and OPEN GYM (no empty column); OPEN GYM
saves the same roster the screen showed. Mutant check inside: re-adding "mma" to the roster disciplines must turn check 1 red.
Commands: parse gate `python Godot/tools/check_scripts.py <touched .gd>`; then
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/new_career_finished_test.gd`; then the dependents:
creation_api_test, creation_root_test, new_career_player_name_test, new_career_story_mode_test, first_hour tests, any test that
calls generate_starter_boxing_roster (grep for it).

## VISUAL GATE
UI screen, not a body/animation: Claude renders the screen locally (`tools/render_creation.gd`) and opens it; the operator closes it.
Report the layout you built per block (x, y, w, h).

## Prior research
LUDO_ROUND53_VERDICT_S219.md; LUDO_ROUND52_VERDICT_S217.md (story/sandbox starts); STORYTUT1B (Mara's cast data).

## What would a human do?
A UI designer fills the screen with what the player is choosing and getting: the gym as a picture, the start explained, every
inherited item legible - and never ships a blank column or blank tiles.

## Prefab check
UIKit already has the creation cards, floor view and tween helpers - extend them, do not add a new UI library.

## The one trap
GameState.gd and UIKit.gd are huge shared files: read windows only, change only the named functions, and do not reformat anything.
