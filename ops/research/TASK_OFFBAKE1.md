# TASK OFFBAKE1 (S226) - the demo's guard + 4 punches, cleaned OFFLINE in Cascadeur on the MetaHuman skeleton, played natively

Model: Codex gpt-6-astra, reasoning high. PC seat (Cascadeur + Godot, GPU). Worktree E:/FightCamp/wt/ANIMFIX2 (seeded), NEW branch
codex/offbake1 from master. Never master. Cascadeur access ends 2026-10-27: everything Cascadeur in this task lands before then.
Route APPROVED (route_decisions.json ANIM_OFFLINE_BAKE, operator Q-S221-7 "Approve the direction"): clips are cleaned OFFLINE once
on one MetaHuman master skeleton, baked, played natively; runtime = blend + one foot-lock / hand-contact solve.
New features ship ON: the native path goes in `GameSwitches.GAME_ON` as `native_mh_clips` (read with `GameSwitches.on()`); plain
--script tests stay the OFF (retargeted) control arm; as_game turns it on.

## Why (measured)
- ANIMFIX2B (codex/animfix2b): `active_guard.glb` is bent on its own rig - wrist L 19.06 / R 19.32 deg.
- ANIMFIX3 (codex/animfix3 0cb3ff76): the native MH clips are bent too - `mh_guard_pose.glb` L 19.27 / R 27.38 deg; all four
  punches share that guard at their ends. No source we own has a straight guard -> author it.

## Do (one change per commit, push every commit)
1. CASCADEUR (hidden: `python Tools/cascadeur/ensure_server.py --hidden`; the pipeline in `Tools/cascadeur/animsource1/` +
   ANIMSOURCE1A_DIGEST.md): load the 5 native clips on the MetaHuman master skeleton (`mh_guard_pose`, `mh_jab`, `mh_cross`,
   `mh_lead_hook`, `mh_inside_uppercut`). Correct the hands so the glove continues the forearm: wrist line (LowerArm->Hand vs
   Hand->MiddleProximal, posed SEGMENT directions) <= 10 deg at the guard hold and at each contact frame, both hands. Keep the
   punch timing/contact frames; rear heel up a little, lead foot flat, both soles on the floor (the sole-plane gate, not the bone
   line). Physics Assistant only as the README says (it can deadlock a scene swap). Save each .casc + export GLB to
   `Godot/assets/anim/metahuman/baked/<name>.glb` (light, no mesh).
2. MEASURE on the baked files with `tests/guard_wrist_line_test.gd` (from codex/animfix3, by diff) extended to `baked/`: red on the
   current files (paste), green on baked.
3. WIRE (ANIMFIX3 step 2-3, now with clean sources): a MetaHuman fighter plays these 5 baked clips natively for their roles (guard,
   jab, cross, lead hook, inside uppercut) - no FightClipRetarget pass, same downstream timing/contact/foot plant. Prove it by the
   RESOLVED clip path at runtime (a test red on master, green after). Non-MH bodies and other roles unchanged.
4. A/B on the game camera via `tools/animfix2_pose_room.gd` (as_game, broadcast; seed 930093, MH09 Vance / MH08 Miller): guard .600,
   each contact frame, one between - switch OFF vs ON. Wrist + face-box numbers per still. Sole gate (`tools/animfix1_sole_gate.gd`,
   2 seeds x 2 pairs) once, table vs the ANIMFIX2 after numbers.

## Gate
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- Focused: the wrist test (baked) + the native-path test, `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd`.
- `python Godot/tools/run_tests.py --jobs 2 --only anatomical_pose_layer,fight_clip,retarget,stage_player,guard_wrist,native,contact_stop`
  (`--jobs 1` unless GREEN). Known nightly reds (fight_clip_slice rear hook, staff_pose) are not yours.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. Red first on master's shipped clip (21.16 deg guard wrist on MH08; paste it).
2. Stills only via the pose room (as_game) + still_framing.gd save_if_framed: guard, each contact, one between.
3. Every still: gap / noses / wrists in line / feet / the defect / which bodies.
4. Not "accepted": Claude opens every still, the operator closes it. Post with review_add.py --stage S226.
The route reopens (reopen_if) if the baked clips look WORSE than the retargeted ones on this A/B - report it plainly if so.

## Rules
godot_hidden.ps1 / cascadeur hidden desktop only, watchdog (`Tools\pc_watchdog.ps1 -Once`) before every Godot or Cascadeur run, explicit
`git add -- <files>`, no *.import churn, no mirror / foot-bake code change. Never open an image or window on screen. A second Codex run
(ROOMS3A) works in E:/FightCamp/wt/ROOMS3 - do not touch it. End: `research/OFFBAKE1_DIGEST.md` + AgentComms note to Claude.

## Prior research
ANIM_AUDIT_VERDICT_S224.md s4-5, ANIMFIX2/2B/3 digests, ANIMSOURCE1A_DIGEST.md (Cascadeur MH pipeline), Tools/cascadeur/README.md,
C231_DIGEST.md, route_decisions.json ANIM_OFFLINE_BAKE.

## What would a human do?
An animator opens the clip on the game's own skeleton, straightens the wrists by hand in the guard and at contact, bakes, and drops it
into the game - instead of correcting a bent clip at runtime.

## Prefab check
The 5 native MH clips are the starting point (in the repo); Cascadeur Pro is paid for until 10-27.

## The one trap
All four punches end in the shared guard: fix the guard pose ONCE and carry it into every punch's first/last frames, or the boxer
snaps between a straight guard and a bent punch end.
