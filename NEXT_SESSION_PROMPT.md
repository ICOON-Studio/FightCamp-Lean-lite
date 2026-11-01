# S343 - next session (written S342, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S342 shipped update 44: text walls trimmed (icons + tooltips on her file, record chips, one-line plans, WHEN pills), the
move map's key (C161), attributes as bars against her potential (C158), the fight rules follow real fight plans
(Q-S294-67, 5 edits), six punch takes back (Q-S294-66). Digest: Game\Godot\research\S342_DIGEST.md.

OPERATOR RULE S338: "keep all agents working on animations and you work on the mechanics and ui".

0. GRAPPLEFLOWS is DONE (S342): it maps a coach's spoken words, never the motion (silent and generic-voice clips were
   refused); with a voice naming each move it built our 6-move chain as a flow with thumbnails cut from our footage
   (docs/playtest/S342/grappleflows_flow_*.jpg). Remind the operator to cancel his Pro trial before day 7 if unwanted.
1. WHIMSICAL is connected for this session (connector; operator signed in S342): draw the flow view ("See the flow") and
   the plan board as Whimsical flowcharts (rounded nodes, short labels, colour not words; from GrappleFlows: each node a
   STILL of that position from our 3D + a short title + one line, each edge a short pill, a click plays the move in the
   MOVEPLAYER1 player) - the reference for FlowView's look; put the board on the ops board for his OK, then build. Do NOT use Whimsical's own AI agent (credits; operator:
   "Nothing yet") - draw through the connector's tools. Free plan: 50 board objects a month - keep boards small.
2. COLLECT with the visual gate (render on the hidden desktop, open the stills): FIGHTCARD1 round 4 (Cursor,
   wt E:\FightCamp\wt\LEAN_FIGHTCARD1, out E:\FightCamp\tmp\FIGHTCARD1_r4_out.txt; CARD STAGED + CARD VIEW >= 80 % of
   >= 6 samples, then YOUR stills: no see-through boxer, referee beside the pair, no shoulder over the trapped boxer),
   MOVEPLAYER1 (Goose #16: then put the player in the move map's bottom-left and move the key behind a "?" icon; a click
   on a move or a plan row plays it), PADWORK1 r2 (Goose #13, 646db61), CLINCH2 r2 (Goose #14), SMOOTH2 (Goose #10).
   Goose cannot open PRs here: fetch the branch, review, apply the DIFF (never Goose's .uid leftovers).
3. Scouting step 3 - the scout trip (Godot/research/SCOUTING_S340.md): a scout at her club show ($, one evening) opens a
   habit with its trigger and how her corner talks; then OPPPLAN1 (her corner's plan by her style, punishing what we
   have not answered); step 5 the sparring partner test; PLANPADS1.
4. The operator plays update 44 (WHAT_TO_TRY.txt top).
