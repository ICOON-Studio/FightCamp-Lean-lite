# S339 - next session (written S338, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S338 shipped update 40: the hair fix (card groups lost in the GLB join - braids, fringes, Holly's crown back), Holly/Ellie/Jade
built (board Q-S294-63 with the lineup), the Tie-ups tab and the coach's plan board on the boxing map.
Digest: Game\Godot\research\S338_DIGEST.md.

OPERATOR RULE S338: "keep all agents working on animations and you work on the mechanics and ui". Agent seats get ONLY
animation work; Claude writes the mechanics and the screens himself.

1. Nothing in flight: PLANSCREEN2 (plan board on the tie-ups) and MOVECLIPS1 (StrikeMap move -> clips, scripts/fight3d/
   MoveClips.gd) were merged in S338; update 40 exported 71/71.
2. Q-S294-63: if yes, Holly (21) / Ellie (22) / Jade (23) into Faces.CM (heights from Game Tools/metahuman configs) + CAST.
3. MECHANICS (Claude): the plan in the bout - she follows the coach's arrows (PlanBoard.pick per card; the opponent's
   reaction picks the branch; undrilled moves at 0.8), the corner changes one arrow between rounds (change_one), the 3D
   fight shows the planned move's clips (MoveClips); then the plan saved on Career and opened from her page.
4. AGENTS ON ANIMATION (all seats busy): Cursor -> pad work on the Training page (coach with mitts + boxer combos,
   Q-S294-61 step 3 - ask the fight-stills session, owner of ANIMCLOUD1, first); Qwen/Grok -> clips for the 3 tie-up answers
   with none (Go-behind x2, Shuck); never brief a clip the fight-stills session's Goose runs (SMOOTH2, TAKEFIX1) own.
