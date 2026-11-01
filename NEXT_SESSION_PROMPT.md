# S341 - next session (written S340, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S340 shipped update 42: the attributes board (C157: radar vs potential + footwork and her mind traits, AT A GLANCE), the
clinch's price (ClinchRest: +1.5 energy, the opponent digs in ~44 % of a presser's tie-ups), fight flows for boxing and
wrestling (See the flow / Her plan, lit up), TIECLIPS1 merged. Digest: Game\Godot\research\S340_DIGEST.md.

OPERATOR RULE S338: "keep all agents working on animations and you work on the mechanics and ui".

1. COLLECT FIRST (visual gate before any merge - render on the hidden desktop and open the stills yourself):
   - FIGHTCARD1 round 2 (Cursor, wt E:\FightCamp\wt\LEAN_FIGHTCARD1, branch cursor/fightcard1): needs `CARD STAGED` >= 80 %
     for own_ropes and corner AND fight3d_play stills with her back on the ropes / the opponent in a corner.
   - CLINCH2 (Goose issue #14, branch goose/issue-14): clinch_check CLINCH OK 6/6 + tools/clinch_still.gd stills.
   - PADWORK1 round 2 (Goose issue #13, branch goose/issue-13): PADSTILL bodies 2 in frame + real-glove gaps that differ.
   Goose cannot open PRs on FightCamp-Lean: fetch the branch, review the diff, merge it yourself.
   Then wire PadWork into the Training page (a "Watch the pad work" button by the combo picker) - UI is Claude's.
2. CLAUDE MECHANICS: fight flows step 2 - branches by the opponent's game (arrow `when`; PlanFight.choose prefers the arrow
   whose when == the situation; PlanBoard.validate places = from + when; a WHEN picker on the plan board; measure with
   plan_bout_test). Then OPPPLAN1 (the opponent's corner plans by her style), PLANPADS1 (camp weeks drill plan arrows).
3. Q-S294-65 scouting in stages (SCOUTING_S340.md): build in its order once he answers.
4. The operator plays update 42 (Lucy's page Overview; a bout with a tie-up plan - read the clinch line; result > Her plan, lit up).
