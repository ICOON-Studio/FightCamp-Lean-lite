# TASK UICARDS2 (S227) - the TRAINING planner rebuilt from Ludo round 69, ONE STEP AT A TIME (UI owner, after UICARDS1)

Seat: cloud Cursor - the UI OWNER (same seat/rules as TASK_UICARDS1.md). Starts ONLY after UICARDS1 step 7 is done (operator: "one at a
time"). Branch cursor/issue-<n>, PR to master; never master. Ships ON.
Operator verbatim on today's screen (`previews/operator_training_planner_s227.png`): "this is so bad did ludo approved it ?"
- it never went through Ludo (built S133-S139, before Ludo's role). And: "all screens must be checked by ludo keeping a smooth look across
all game and menus modals tooltips etc".

## THE SPEC (binding): Ludo round 69
`research/LUDO_ROUND69_REPLY_S227_part1.txt` - A (16 defects), B (layout grid, states incl. ONE fighter / eight fighters / no coach /
injured / in camp, drag-drop feedback, session drawer, FIGHT CAMP tab, timings), C (references), D (6-step build + gates), E (GDScript;
the rest in `..._part2.txt` when present).

## Claude's corrections (win over Ludo)
1. DATA IS REAL: everything from `GameState.get_training_hub()` / `get_training_day()` (+ WeightCut.gd, the sparring market only if the
   read exposes it). A Ludo block with no data source (sparring slots, weight-cut taper, coach portraits) HIDES when absent - list them.
2. No sound requirement in the gates (Ludo's "audible latch" is optional polish, not a gate).
3. Keep the drag-to-plan behaviour and the refusal reasons the panel has today (TRAIN2, the no-coach refusal) - restyle, do not lose them.
   Split TrainingHubPanel.gd (1,787 lines) into Ludo's components; no file past ~1,500 lines.
4. The ONE-fighter week-1 state is the one the operator sees first - Ludo's GymCapacityPanel fills the void with REAL station/coach data.

## Do - Ludo PART D order, one step per commit, push each, "STEP n DONE" comment on the issue, digest UICARDS2_DIGEST.md
1 TrainingLayoutHost -> 2 TrainingDayCell -> 3 TrainingWeekRow -> 4 TrainingSessionDrawer -> 5 GymCapacityPanel -> 6 FightCampTimeline.

## Gate (each step)
Parse; RED first on master (a test per Ludo gate of the step: no overlap/clipping at 1920x1080 and 1280x720 measured from label
minimum sizes; the drop changes the day through the real get_training_day path; drawer tween 160 ms; one-fighter state has no empty
region taller than 120 px; refusal locks the commit button with its reason). `run_tests.py --jobs 2 --only training,train,week_plan,ui_kit`
green; existing training tests not weakened.

## VISUAL GATE
Claude renders `tools/ui_census_stills.gd -- as_game` (training) on the PC after each step and shows Ludo; the operator closes it.

## Prior research
LUDO_ROUND69_*, TRAINING_K9_* boards, TRAIN2 (drag palette), K9 (week + camp = one act at two intensities), Q190 sparring market.

## The one trap
The planner is the game's core loop screen: a restyle that breaks a drop or a refusal is worse than the old look - every step re-runs
the existing training tests before its commit.
