# TASK HUDDEF1 (S222) - three defects seen on the gym-floor still (capacity plate overlap, stray fighter, non-boxing kit in the list)

Model: cloud Cursor (label `cursor`). Repo ICOON-Studio/FightCamp, branch `cursor/issue-<n>` from master. Open a PR, never merge.
No Git LFS on the cloud box: tests must not load models. Do not delete or shorten any existing test.
Seen by Claude on `previews/stationwear1f/01_pinned_worn_bag.jpg` (1920x1080, `tools/station_pin_stills.gd -- as_game gym3d_main
gym4_club gym_floor_view hud2 station_info station_wear`). A seen defect is fixed now (house rule).

## The three defects
1. OVERLAP: the left "TIER T1 - CAPACITY" plate (`Godot/scripts/club_capacity/ClubCapacityPlate.gd`) and the day-goal lines
   ("Stamina above 30 at the bell", "Jab usable by Friday" - `Godot/scripts/DayGoals.gd` 49/67, drawn by `Godot/scripts/DayGoalsHud.gd`
   294 lines) draw on top of each other at x 30-220, y 780-830. Fix: the goals HUD and the plate never share pixels - the plate's
   bottom stops above the goals block (or the goals move above / beside the plate) at 1920x1080 AND 1280x720.
2. STRAY FIGHTER: a fighter model lies at the very bottom-left of the screen (x 60-160, y 1010-1080), outside the gym, in a fallen
   pose. Find which node it is (GymClub3D / GymHall3D spawns: grep `fighters`, `spawn`, `pose`) and why it sits outside the hall
   (a fighter without a place? a spar/walk target at (0,0,0)?). Fix the cause; a fighter is always inside the hall on a place or route.
3. WRONG KIT: the capacity plate of a BOXING gym lists "Judo Tatami & Crash-Mat Area" and "Capoeira Roda & Music Kit" under RING.
   Find whether the plate lists the catalogue instead of the gym's own floor, or the still's fixture floor has them. A plate lists the
   gym's OWN installed items only; a boxing starter floor (`GameState.generate_starter_boxing_floor`) has no judo/capoeira kit.

## Owned files
ClubCapacityPlate.gd, DayGoalsHud.gd, the spawn site you find for (2), the plate's data source for (3). `GameState.gd` is 20,000+ lines -
NEVER read whole; grep and read +-40 lines.

## Acceptance - NEW `Godot/tests/hud_defects_s222_test.gd`
(a) build the gym floor HUD at 1920x1080 and 1280x720 with the capacity plate open and two day goals: their global rects do not
intersect; (b) every fighter node the floor spawns has a global position inside the hall rect (room w 30 x hall_d 18, gym_club.json);
(c) the plate for a boxing starter floor lists only items present in that floor, none with "judo" / "capoeira" in the id.
Each check must go RED on master first - say in the PR which ones did. Parse gate `python Godot/tools/check_scripts.py <touched .gd>`.
Claude re-takes the still on the PC after it lands.

## The one trap
Do not hide the plate or the goals to pass (a) - both stay visible; only their placement changes.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form - added S223 at collect)
1. The defect must first read RED on master's shipped screen (a still of the screen as the game shows it, `-- as_game`).
2. Stills of the changed screen at 1920x1080 and 1280x720 from the game's own flow (no isolated widget renders).
3. For every still report: overlaps, clipped text, the changed element's position, what the player reads.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
