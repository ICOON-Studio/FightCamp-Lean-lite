# S342 - next session (written S341, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S341 shipped update 43: scouting in stages (her file, tape study opens one tell every 2 camp days), every opponent's record
kept bout by bout (RivalPast + WORLD > Rankings opens any rival's file), plan branches (WHEN picker), real fight plans as
templates (REALPLANS_S341.md). Digest: Game\Godot\research\S341_DIGEST.md.

OPERATOR RULE S338: "keep all agents working on animations and you work on the mechanics and ui".

0. UI DEFECT FIRST (operator S341: "you need to trim the text walls, use modals/tooltips and smarter use of space (icons)
   and refer to research on what UIs player like"): rework S341's screens - scripts/ui/OppFileCard.gd (tells: one icon row
   each, the answer in a tooltip; HER RECORD as W/L chips, the bout in a tooltip; WITH US one line), the Real fight plans
   list and WHEN picker in scripts/ui/StrikeBrowser.gd, PlanPanel rows. Read first: Godot/research/topics/ui_screens.md,
   J52_TOOLTIPS_AND_TUTORIAL.md, K_HUD2_KALLI.md, M_HUD2_MARIA.md; memory "HUD = top bar + modals (S268)". Stills before and
   after (tools/layout_snapshot.gd 12_bout + 30b_rival_file, tools/plan_still.gd branch), opened by you, sent to him.
   Operator S341: "maybe this can help to improve visuals : https://whimsical.com/" - WIREFRAME FIRST: draw the compact cards
   (and the flow view's look) in Whimsical if he connected its connector (Whimsical MCP: create / generate_diagram), else in
   Figma (connected), put the wireframe on the board for his OK, then build. Whimsical's clean flowchart style (rounded nodes,
   short labels, colour not words) is also the reference for FlowView.
1. COLLECT with the visual gate (render on the hidden desktop, open the stills, check the probe's numbers VARY):
   CLINCH2 round 2 (Goose #14; brief TASK_CLINCH2 "ROUND 2"), PADWORK1 round 2 (Goose #13), FIGHTCARD1 round 2 (Cursor
   1f48154, wt E:\FightCamp\wt\LEAN_FIGHTCARD1); SMOOTH2 + TAKEFIX1 (older Goose) on the board. Goose cannot open PRs here:
   fetch the branch, review, merge. Then wire PadWork into the Training page.
2. Board answers: Q-S294-67 (5 fight-rule edits from real plans). The GrappleFlows video test needs his OK first.
3. Scouting step 3 (scout trip: a habit + trigger, how her corner talks), OPPPLAN1 (her corner's plan by her style and
   file), step 5 (a sparring partner of her style), PLANPADS1.
4. The operator plays update 43 (WHAT_TO_TRY.txt top).
