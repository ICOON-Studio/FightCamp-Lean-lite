# S355 - next session (written S354, 2026-11-02, after update 56)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S354 shipped updates 55-56: the corner card in numbers, cuts on the face, no his/her in any text (all-caps too), and CORE3
STEP 1 - THE WEEK RUNS THE GAME: the Training tab is the week planner (WeekBoard.gd), Sim.step_day trains that week
(WeekPlan.full_day: gains, weight from diet + mornings, fatigue in f["week_fatigue"]), Injuries reads WeekPlan.hours.
Digest: Game/Godot/research/S354_DIGEST.md. Design: CORE3_DESIGN_S354.md. Miro loop board frames "Core loop - Early
Access" and "Reception - signing as an RPG recruit" (post seat answers + previews there with the connector - no token).
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; every probe at `--fixed-fps 30`.

1. Q-S294-81 (reception as an RPG recruit, mockup docs/mockups/S354_reception_rpg.png, Kalli KALLI_RECEPTION_RPG_S354.md).
   On his yes: class badge (style + one strength/weakness), potential stars (a range until scouted), two visible traits from
   f["personality"] with effects + one habit (fight_habits.json) + a signature move (a weapon) + an ambition; attributes against
   their ceiling; ONE starting focus (sharpen the signature / fix the habit / raise the ceiling) replacing Data.CARDS picks
   (keep f["cards"] working for old saves); the perk road (perks at attribute thresholds, a pure module + test, shown on the
   profile and the Training tab). Playtest the perk numbers.
2. CORE3 step 2: planned vs actual at the week review (the week's projected gains/kg vs what happened) + week templates with
   ONE twist card a week (Kalli). Then the combo lab hit rates, then the fight plan Test it (a range, 3 a camp).
3. Playtest a 4-week camp in the .exe yourself (computer-use) and get reviews (Kalli on design, Ziva in the editor) - operator
   "build playtest get other testers too ... review etc"; ask him about outside human testers.
4. CLINCH2 (Ziva, wt/ZIVA_LEAN ziva/clinch2): collect when it lands, run tools/clinch_check.gd on main + the branch, open the
   stills; then the Ziva Pro verdict to the operator.
5. Cleanup: TrainingBoard.gd is no longer shown (fold its body picture into the perk road or delete); wrestling reaction ids
   still say "her" (saved plan ids - add a display map).
