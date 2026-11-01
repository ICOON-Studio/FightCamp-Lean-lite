# S348 - next session (written S347, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S347 shipped update 48: every fight camera inside the ropes (no see-through rope), a lighter HUD in our colours (rings in
her corner colour, ivory body ring, clay body view, key + stats in tooltips), TELLS1 (her tells on her body). Digest:
Game\Godot\research\S347_DIGEST.md. OPERATOR S347: BJJ in parallel with boxing, AND training mechanics, menus, fighter
profile. OPERATOR RULE S338: agents do animations, Claude does mechanics + UI. hidden_desktop drops stdout: Godot
`--log-file <path>`. A SceneTree still tool must set `stage.camera.close = true` or the ring's director moves the lens.

1. Board: answers to Q-S294-71 (Playbook) and comments on the S347 stills (camera, HUD, tells). Act on each.
2. Flow view (scripts/ui/FlowView.gd) in the whiteboard menu colours: C191/C192 "not in par with other menu colours"
   (paper background, white cards, marker-blue titles, the menus' UI.gd palette, not TV.gd).
3. Collect on the GPU with the visual gate: PADWORK1 r3 (Goose #13, 5633c78) and CLINCH2 (Goose #14, 31ccc38). Probes
   read the pose AS SHOWN (skeleton_updated), never get_bone_global_pose from outside the modifiers.
4. Delegate (first hour): GROUND3 - the BJJ paper rules (positions, moves, odds from research/topics/ground.md + G75) to
   Qwen or Arena; SMOOTH3 - which fight layer kinks the motion (tools/smooth_probe.gd control arms; SMOOTH2 measured 344
   kinks/min, 168 at clip changes) - code audit of the clip-change joins first (two red rounds).
5. Training mechanics, menus, fighter profile; the Playbook page once Q-S294-71 is yes (PLAYBOOK_S347.md build order).
6. Corner cards under the new lens: FIGHTCARD1's CARD probe (branch cursor/fightcard1, tools/fight3d_play.gd card=corner)
   on main's camera.
