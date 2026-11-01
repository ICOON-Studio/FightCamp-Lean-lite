# S345 - next session (written S344, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S344 shipped the flow in the tape room's look (Lean 9257b55) and acted on the operator's still comments. Digest:
Game\Godot\research\S344_DIGEST.md. OPERATOR RULE S338: agents do animations, Claude does mechanics + UI.

1. Q-S294-69 (board): his answer on FIGHTHUD2 - the fight HUD that beats UFC 6 (Godot/research/FIGHTHUD_S344.md: six bars a
   boxer - head, body, legs, stamina, guard, heart - icons, no numbers, a round-edge meter top centre, her guard and heart
   "?" until scouted). On a yes, build it in scripts/fight3d/FightHud.gd (data: BodyMap head/ribs, energy, BodyTrack legs,
   TELLS guard, Heart attribute) and send stills.
2. COLLECT with the visual gate ON THE REAL GPU (hidden desktop), re-measuring every agent probe yourself:
   - FIGHTCARD1 r5 (Cursor, wt E:\FightCamp\wt\LEAN_FIGHTCARD1, out E:\FightCamp\tmp\FIGHTCARD1_r5_out.txt): render
     tools/fight3d_play.gd card=own_ropes / card=corner; the referee never in the lens, both women head to feet.
   - TELLS1 r2 (Goose #17): tools/tell_probe.gd windowed TELL OK 4/4 (check it AWAITS its measurements), then
     tools/taperoom_still.gd opp=0,2,megan.
   - PADWORK1 r3 (Goose #13, 5633c78) and CLINCH2 (Goose #14, 31ccc38): stills on the GPU before any merge.
3. MOVEPLAYER1: verify the hand merge (E:\FightCamp\tmp\MovePlayer_merged_s344.gd + moveplayer_probe_r2_s344.patch) -
   probe + moveplayer_still on the GPU; then wire it in the move map's bottom-left (bottom card row SPOT y 0.74 -> 0.64,
   key behind a "?", a click on a move or a plan row's TV icon plays it; DisplayServer headless = no player).
4. TAPEFIGHT1 once TELLS1 is in; then the scout trip + OPPPLAN1.
5. Tie-up flow cards have no stills yet (words only) - bake them when wrestling returns.
