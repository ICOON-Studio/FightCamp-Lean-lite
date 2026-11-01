# S346 - next session (written S345, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S345 shipped FIGHTHUD2 (six bars a boxer + round edge + '?' until scouted) and verified the MOVEPLAYER1 merge on the GPU
(probe 5/5, contact stills). Digest: Game\Godot\research\S345_DIGEST.md. OPERATOR RULE S338: agents do animations, Claude
does mechanics + UI. hidden_desktop.py drops stdout: pass Godot `--log-file <path>` and grep that.

1. Board review: the operator's comments on the S345 stills (HUD scouted/unscouted, move player contacts) - act on each.
2. COLLECT with the visual gate ON THE REAL GPU, re-measuring every agent probe yourself (read the probe code first):
   - FIGHTCARD1 r5 (Cursor, wt E:\FightCamp\wt\LEAN_FIGHTCARD1, out E:\FightCamp\tmp\FIGHTCARD1_r5_out.txt; it was alive
     rendering card=own_ropes at 13:35 - the reconcile's "dead" was a wrong worktree name): render tools/fight3d_play.gd
     card=own_ropes / card=corner; the referee never in the lens, both women head to feet.
   - TELLS1 r2 (Goose #17, run 41301350509): tools/tell_probe.gd windowed TELL OK 4/4 (check it AWAITS its measurements),
     then tools/taperoom_still.gd opp=0,2,megan.
   - PADWORK1 r3 (Goose #13, 5633c78) and CLINCH2 (Goose #14, 31ccc38): stills on the GPU before any merge.
3. MOVEPLAYER1 wiring: put the player (scripts/fight3d/MovePlayer.gd, verified S345) in the move map's bottom-left -
   bottom card row SPOT y 0.74 -> 0.64, the key behind a "?", a click on a move or a plan row's TV icon plays it;
   DisplayServer headless = no player. Then close Goose #16.
4. TAPEFIGHT1 once TELLS1 is in; then the scout trip + OPPPLAN1.
5. Tie-up flow cards have no stills yet (words only) - bake them when wrestling returns.
