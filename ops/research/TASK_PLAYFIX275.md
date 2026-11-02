# ROUND 2 (S275, Claude) - ONLY item 1 (the stat cards); read this first
Round 1 (0b91d260) is collected on master EXCEPT the card files: items 2-5 (top bar always on with the page icons, dock hidden on the
floor, countdown in the bar, one right-side drawer, plan needs a bout, camp setup centred) are on master now - do not redo them.
NOT taken (they broke 5 tests in the plain arm): CandidateCard.gd, rules/FighterReadout.gd, rules/OpponentCompare.gd, rules/QuickLook.gd,
ui/FighterReadoutPanel.gd, tests/roster_card_attributes_test.gd. Plain-arm FAIL lines with your round 1:
- fighter_readout_panel_test: "scout 0 card chin prints the readout's grade word" (+ footwork, composure, range)
- opponent_compare_test: "rows returns exactly 9 rows", "level 2 ... key=stamina ... expected=even got=unknown"
- quick_look_card_uicards1_test: "bare_still_has_nine_attrs"; quick_look_card_test: HANG (timeout)
- your roster_card_attributes_test plain arm: "readout grid count 6 want 11"
Do: merge origin/master; redo item 1 so the 11 attributes show ONLY when `GameSwitches.on("attributes")` is true (the game arm) and the
plain --script arm keeps today's cards byte for byte (those five tests are its control). Your new test's OFF arm asserts today's cards,
its ON arm (-- as_game) the 11. Gate: those 5 tests green plain AND as_game, plus roster_card_attributes_test both arms. RESULT lines in the PR body.

# TASK PLAYFIX275 - five screen defects from the operator's S274 playtest (roster stats, right-side overlap, plan without a fight, camp setup off-screen, top bar on the floor)

Model: Cursor (cloud). Discipline: BOXING (demo). One PR, five fixes, each with its own test red on master first.
Owner split: the gym floor CAMERA, rooms, people and build mode belong to Codex (TASK_FLOORTPM1, branch codex/floortpm1) - do not touch
camera/zoom/room-entry/walker code. You own the HUD/screens below. `GymHall3D.gd` (5,4xx lines) and `GymClub3D.gd` (3,3xx) are shared:
small hunks only, never read them whole (grep, then `sed -n` windows).
New behaviour goes in `GameSwitches.GAME_ON` read with `GameSwitches.on()` (operator S221); plain `--script` tests = OFF arm, `-- as_game` = ON.

## 1. Roster card shows the OLD six stats (operator S274: card "MARA SOLANO" shows power/technique/speed/defence/stamina/ring IQ)
The 11 attributes are the game's stats since S260 (operator-approved; `scripts/rules/Attributes.gd`, switch `attributes` ON; the profile
uses them - `ProfileRevampPanel.gd`). The roster/fighter card still draws the old six. Find which card draws them (leads:
`scripts/ui/FighterReadoutPanel.gd`, `scripts/rules/FighterReadout.gd`, `scripts/CandidateCard.gd`, `scripts/ui/ProfileTabsLayout.gd`,
`scripts/rules/OpponentCompare.gd` all name "DEFENCE"); every card that shows a fighter's stats in the career (roster, fighter strip card,
candidate/applicant card, opponent compare) shows the 11 attributes with switch `attributes` ON, the six only when it is OFF.
TEST: `tests/roster_card_attributes_test.gd` - ON: each of those cards for a seeded fighter lists exactly the 11 attribute names from
Attributes.gd and none of the six legacy labels; OFF: today's six.

## 2. Right side overlap (operator S274: "too many things overlap here")
On the gym floor the Day Plan drawer, the calendar drawer, the "BOUT LOCKED" tag (`scripts/ui/FightCountdownPill.gd`) and the news ticker
(`GymHallPanel.gd` / `ClubSpeedControls.gd` / `ui/TrainingMetersHud.gd` - grep "ticker") all sit on the right edge at once. Rule (HUD S268,
"weird panels everywhere"): top bar + modals. Fix: one right-side slot - at most ONE drawer open (opening one closes the other), the
BOUT LOCKED pill moves INTO the top bar (beside the date), the ticker runs along the bottom edge under nothing else.
TEST: `tests/floor_hud_overlap_test.gd` at 1920x1080 AND 1280x720 - with a booked bout and both drawers requested, the visible Control
rects of drawer/pill/ticker/top bar do not intersect (> 2 px), and every one is fully on screen.

## 3. A fight plan can be started without a fight (operator S274: "how can i start a fight plan with out a fight wtf")
Find the button/route that opens the fight plan (`FightPlanSetup.gd`, `FightPlanSetupPanel.gd`, `FightCampPanel.gd`, `FightPlans.gd`;
the top bar FIGHTS / OFFICE routes from S273 4415cd54). With no booked bout the entry is hidden or disabled with the tooltip
"Book a fight first" and the route refuses (returns to the previous screen). With a booked bout it works as today.
TEST: `tests/fight_plan_needs_bout_test.gd` - no bout: entry disabled/hidden + direct route call refused; bout booked: opens.

## 4. Camp setup screen out of bounds (operator S274: screen shifted left, right side empty)
The camp setup screen (`FightCampPanel.gd`; also grep "camp setup" in `ProfileRevampPanel.gd`) is drawn off-centre. Lay it out from
the viewport (anchors/containers, never a fixed x), centred, inside the safe area at 1920x1080 and 1280x720.
TEST: `tests/camp_setup_bounds_test.gd` - both sizes: the panel's rect is inside the viewport, its centre within 2% of the viewport
centre horizontally, no child Control outside the panel.

## 5. Top bar always on, on the gym floor (operator S274: "these icons are on the top at some other pictures i saw wtf happened" +
the "1 NEW APPLICANT" chip over them)
CAUSE (read in code, S274): the top bar `scripts/ui/GymTopBar.gd` only shows with a fighter on the floor (`GymHall3D._topbar_on` at
GymHall3D.gd:5350 needs `not _fighter_row.is_empty()`); in the career shell the HUD V3 dock (`ShellChrome.gd:23 BAR_ITEMS`, a vertical
column at x 16) is drawn over the floor, and the hire chip sits at `HIRE_CHIP_POS (18, 296)` (GymHall3D.gd:4951) right on that column.
FIX: on the gym floor the top bar is ALWAYS on (no fighter = gym name + "No boxer yet"); the dock's pages (Home, Fighters, Scouting,
Staff, Rankings, Finance, Settings - the BAR_ITEMS routes) become icon buttons (IconKit / Lucide, tooltip = page name) in the top bar;
the ShellChrome dock hides while the floor is the page; the hire chip hides while the top bar's APPLICANT button carries the badge
(count). Off the floor the dock is unchanged.
TEST: `tests/floor_topbar_always_test.gd` - real CareerRoot on the training_floor route (see `Godot/tools/s274_realfloor_stills.gd` for
how it builds the real route): with 0 fighters and with 1 the top bar is visible; it has one button per BAR_ITEMS page and each routes
to that page; the ShellChrome dock is hidden; the hire chip is hidden and the APPLICANT badge shows the applicant count.

## Gates
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.
- Run each new test + `focus_popup_test, focus_card_test, gym_topbar_test` (if it exists) and every test that names a script you touched
  (`grep -l <ScriptName> Godot/tests/*.gd`), never more than 40 in one `--only`.
- PR body: one line per test, `RESULT: tests/<x>_test.gd -> <exact pass line>`.
- Claude takes the game-camera stills (you cannot see images); make every check above geometric so the test proves it.

## Contract
OWNS: Godot/scripts/ui/GymTopBar.gd, Godot/scripts/ShellChrome.gd, Godot/scripts/ui/FightCountdownPill.gd, Godot/scripts/FightCampPanel.gd, Godot/scripts/ui/FighterReadoutPanel.gd, Godot/scripts/CandidateCard.gd, Godot/tests/roster_card_attributes_test.gd, Godot/tests/floor_hud_overlap_test.gd, Godot/tests/fight_plan_needs_bout_test.gd, Godot/tests/camp_setup_bounds_test.gd, Godot/tests/floor_topbar_always_test.gd
RED_TEST: Godot/tests/floor_topbar_always_test.gd -> FLOOR_TOPBAR failures=0
REGRESSION: focus_popup_test, focus_card_test
VISUAL: yes

## Prior research
TWOPOINT_ALIGNMENT.md "HUD (S268)" section; S274_DIGEST.md items 1-10 (the playtest list, verbatim, and the item 9 diagnosis);
memory rule HUD = top bar + modals (S268: "weird panels everywhere"); GDSCRIPT_TRAPS.md (Label sizing, autoload order).

## What would a human do?
Two Point Museum: one top bar that is always there with every page as an icon, one drawer on the right at a time, alerts as badges on
the top bar's icons - nothing stacks on the edges.

## Prefab check
None - layout of existing Controls; icons from the Lucide set already in assets/icons/lucide (MIT/ISC).

## The one trap
The top bar's visibility today hangs on `_fighter_row`; other code may read `_topbar_on()` to decide where the goal card or ring UI
goes (GymHall3D.gd:2164, 4645, 5334, 5405) - check each caller still places its panel correctly when the bar is on with no fighter.
