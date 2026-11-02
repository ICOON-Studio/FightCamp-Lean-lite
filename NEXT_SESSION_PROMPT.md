# S354 - next session (written S353, 2026-11-02)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S353 shipped update 54: the MUSCLE HOLO on every body view (bought ecorche, operator "holo looks fine"), Ziva's 112 training
cards on the training board, BeltRoad (the BJJ road to black belt, IBJJF floor). Digest: Game\Godot\research\S353_DIGEST.md.
OPERATOR S353: no-gi BJJ ships beside boxing ("a simple road to black belt in bjj for start"); a GYM Training week with every
fighter Mon-Sun (mornings body, evenings moves with progress bars). OPERATOR RULE S338: agents do animations, Claude
mechanics + UI. EVERY PROBE AT `--fixed-fps 30`. New PNGs: `godot --headless --path . --import` before stills.

1. Board Q-S294-77 (mockups docs/mockups/S353_week.png + S353_beltroad.png). On his yes:
   a. WeekPlan.gd (TRAINPLAN2 step 1, pure + test): 7 days x {type HARD/SKILL/ENGINE/REST, am: body session, pm: move |
      live | rest}; red on two hard days in a row; the days -> TrainingPlan blocks (keep its gain curve and TOTAL_CAP);
      PM move nights -> MoveMastery drilling. Then Gym > Training week (Gym area tab) as the mockup.
   b. BJJ fighters: belt, stripes, belt_day, mat_classes on the fighter; BJJ AM/PM sessions; the Belt road tab
      (BeltRoad.readiness / promote); a no-gi BJJ fighter in the quick start's roster for the playtest.
2. SMOOTH3: see the S353 digest's verdict (Goose r3, measured in E:\FightCamp\wt\SMOOTH3_LEAN - remove that worktree when
   done: `git worktree remove`).
3. CLINCH2 -> Ziva (one Ziva chat at a time; TRAINCLIPS1 landed). Brief from Game TASK_CLINCH2.md: the probe must FAIL with
   0 holds and read main.
4. The holo replays the move that tired a muscle (operator S353 asked; Claude: yes as step 2) - rig the female ecorche
   (E:\FightCamp\licensed\ecorche_aaaxis, never in a repo) to the MetaHuman skeleton in Blender, decimate, bake per move.
5. Not done S352/S353: the Miro production map card moves (P0) and the loop-board re-upload (S352 layout shots).
