# S355 - next session (written S354, 2026-11-02)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S354 shipped update 55: the corner card in numbers (CornerStats + each option's effect), cuts and swelling on the face
close-up (FaceMarks), the training board as the Training tab on the fighter's page, no his/her anywhere in the text.
Digest: Game\Godot\research\S354_DIGEST.md. OPERATOR RULES: no his/her in game text (names, or no pronoun); agents do
animations, Claude mechanics + UI (S338); every probe at `--fixed-fps 30`.

THE DIRECTION (operator S354): Early Access = three fun mechanics beside the corner - (1) mornings summed against the camp
goal, intensity as the dial (e.g. to burn weight); (2) the evening move/combo lab (move progress, combo effectiveness);
(3) the fight plan you design and test. BJJ and boxing polish are background. Design: Game Godot/research/CORE3_DESIGN_S354.md,
mockup docs/mockups/S354_core_loop.png, board Q-S294-79.

1. Q-S294-79 answer. On his yes, CORE3 step 1:
   a. Training tab (FighterPage TRAINING_TAB): the camp goal card (weight limit, one stat, one move) with live lines from
      WeekPlan.goal_lines; the week row: 7 mornings, session picker + Light/Normal/Hard, each card's numbers; fatigue line.
      Keep the TrainingBoard body picture below or fold it in - one screen, no his/her.
   b. WeekPlan into Sim.step_day: the day's morning from the saved week (f["week_days"], default WeekPlan.COACH_WEEK) drives
      the stat gain, the weight (replaces the flat -0.11 kg/day cut) and a fatigue value on the fighter. Run golden_path +
      every weight/camp test: the weigh-in must still be makeable on the coach's week + cut.
   c. Export + WHAT_TO_TRY, stills of the Training tab on the board.
2. Planned vs actual at the week review; 3. evening drills + combo lab effectiveness; 4. fight plan "Test it" (20 sims).
3. CLINCH2 (Ziva, wt/ZIVA_LEAN branch ziva/clinch2; chat "Implementing Clinch Hold Mechanics"; baseline on main measured
   CLINCH holds 3, OK 0/6): collect when it lands - run tools/clinch_check.gd yourself on main and the branch, open the
   stills. Then the Ziva Pro verdict to the operator (S354 digest "Decided").
4. If update 55 was not exported (AMBER beside Ziva at S354's end): `sh tools/export.sh` on a GREEN PC first.
5. Background: wrestling reaction ids still say "her" (saved plan ids - add a display map), SMOOTH audit, holo replays,
   Miro map.
