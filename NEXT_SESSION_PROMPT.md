# S355 - next session (written S354, 2026-11-02, after update 56)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S354 shipped updates 55-57 (57 = signing as an RPG recruit + the perk road): the corner card in numbers, cuts on the face, no his/her in any text (all-caps too), and CORE3
STEP 1 - THE WEEK RUNS THE GAME: the Training tab is the week planner (WeekBoard.gd), Sim.step_day trains that week
(WeekPlan.full_day: gains, weight from diet + mornings, fatigue in f["week_fatigue"]), Injuries reads WeekPlan.hours.
Digest: Game/Godot/research/S354_DIGEST.md. Design: CORE3_DESIGN_S354.md. Miro loop board frames "Core loop - Early
Access" and "Reception - signing as an RPG recruit" (post seat answers + previews there with the connector - no token).
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; every probe at `--fixed-fps 30`.

1. THE PERKS' FIGHT EFFECTS (update 57 shipped the RPG recruit and the perk road - Recruit.gd, PerkRoad.gd, RecruitPanel.gd -
   but the 8 perks only show and open): give each its hook in the fight model with a test - Iron chin (Knockdowns: the first
   count each fight becomes a stagger), Stiff jab, Second wind (energy at round 3), Ring general (Exchanges.uptake / call edge),
   Counter sense, Body snatcher (body-shot stamina drain), Finisher (stoppage odds when hurt), Fast hands (combos land whole).
   Read f["perks"]. Then playtest the numbers.
2. CORE3 step 2: planned vs actual at the week review (the week's projected gains/kg vs what happened) + week templates with
   ONE twist card a week (Kalli). Then the combo lab hit rates, then the fight plan Test it (a range, 3 a camp).
3. Playtest a 4-week camp in the .exe yourself (computer-use) and get reviews (Kalli on design, Ziva in the editor) - operator
   "build playtest get other testers too ... review etc"; ask him about outside human testers.
4. CLINCH2 (Ziva, wt/ZIVA_LEAN ziva/clinch2): collect when it lands, run tools/clinch_check.gd on main + the branch, open the
   stills; then the Ziva Pro verdict to the operator.
5. Cleanup: TrainingBoard.gd is no longer shown (fold its body picture into the perk road or delete); wrestling reaction ids
   still say "her" (saved plan ids - add a display map).
