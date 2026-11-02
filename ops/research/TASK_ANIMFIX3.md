# TASK ANIMFIX3 (S226) - play the 5 native MetaHuman clips for real, A/B against the retargeted ones

Model: Codex gpt-6-astra, reasoning high. PC seat. Worktree E:/FightCamp/wt/ANIMFIX2 (seeded), NEW branch codex/animfix3 from
master (92192ff5 or later). Never master. Step 3 of the decided fix order (ANIM_AUDIT_VERDICT_S224.md s4).
New features ship ON (CLAUDE.md s10): the native path goes in `GameSwitches.GAME_ON` as `native_mh_clips`, read with
`GameSwitches.on()`. Plain --script tests stay the OFF arm (retargeted = the control); as_game turns it on.

## Why now (measured, S226)
ANIMFIX2B_DIGEST.md (branch codex/animfix2b bd473fb0): the guard glove is bent because the SOURCE guard clip is bent -
`assets/anim/c223/c237/active_guard.glb` wrist lines L 19.06 / R 19.32 deg on its own rig; MH08 plays it at 21.16 deg. No code fix
can straighten a bent source. The audit found the native MetaHuman clips are NOT played at all (MHNATIVE1 claimed they were; the
code has no native path; the idle is still the retargeted active_guard, the hook a RamsterZ FBX).
Native clips (same 341-joint skeleton as every MH body, no retarget needed): `assets/anim/metahuman/mh_guard_pose.glb`,
`mh_jab.glb`, `mh_cross.glb`, `mh_lead_hook.glb`, `mh_inside_uppercut.glb`.

## Do (one change per commit, push every commit)
1. MEASURE THE SOURCES FIRST: take `tests/guard_wrist_line_test.gd` from codex/animfix2b (diff, not whole branch) and extend it to
   the 5 native clips on their own rig: wrist line both hands at the guard hold and at each punch's contact frame. If the native guard
   is ALSO bent (> 10 deg), stop and report - Claude routes it to the offline Cascadeur bake (OFFBAKE1).
2. RED: a test that proves today's MetaHuman fighter plays the RETARGETED active_guard / RamsterZ hook for these 5 roles (binding
   + resolved clip path at FightStagePlayer `_graft_retargeted`), not the native file. Paste the red line.
3. WIRE: for a MetaHuman body and these 5 roles, play the native clip directly (no FightClipRetarget pass - same skeleton), keep
   the existing downstream stages that every clip gets (timing/strike warp, contact, foot plant) and nothing new. Switch
   `native_mh_clips` ON in GAME_ON. Non-MH bodies and other roles unchanged.
4. A/B: game-camera stills via `tools/animfix2_pose_room.gd` (as_game, broadcast) for guard .600, jab contact, cross contact,
   lead hook contact, uppercut contact - retargeted (switch off) vs native (on), same seed 930093, MH09 Vance / MH08 Miller.
   Wrist line + face-box numbers per still. Sole gate (`tools/animfix1_sole_gate.gd`, same 2 seeds x 2 pairs) once, table vs
   the ANIMFIX2 after numbers.

## Gate
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- Focused: the source/wrist test + the new red->green native-path test (`Godot_v4.7.2-stable_win64.exe --headless --path Godot
  --script tests/<name>.gd`, NEVER _console.exe).
- `python Godot/tools/run_tests.py --jobs 2 --only anatomical_pose_layer,fight_clip,retarget,stage_player,guard_wrist,native`
  (`--jobs 1` unless GREEN). Known nightly reds (fight_clip_slice rear hook, staff_pose) are not yours.
- Bound: native guard wrist <= 10 deg on all four MH bodies (MH02/05/08/09) with the switch ON.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED (21.16 deg guard wrist, retargeted path); paste it.
2. Stills only via the pose room (as_game) + still_framing.gd save_if_framed: guard, each contact frame, one between.
3. For every still: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it. Post with review_add.py --stage S226.

## Rules
godot_hidden.ps1 only, watchdog (`Tools\pc_watchdog.ps1 -Once`) before every Godot run, explicit `git add -- <files>`, no *.import
churn, no mirror / foot-bake change. Never open an image or window on screen. End: `research/ANIMFIX3_DIGEST.md` + AgentComms note.

## Prior research
ANIM_AUDIT_VERDICT_S224.md, ANIMFIX2_DIGEST.md, ANIMFIX2B_DIGEST.md (codex/animfix2b), MHNATIVE1 digest (its claim was false - read
the code, not the digest), MetaHumanRig.gd header.

## What would a human do?
Play the clip that was authored for this exact skeleton before trying to correct one that was not.

## Prefab check
The 5 native clips are the prefab (already in the repo). Godot plays a same-skeleton Animation directly; no retarget node needed.

## The one trap
A digest said this was already done and it was not (MHNATIVE1). Prove the native path by the RESOLVED clip path at runtime, not by a
flag or a log line.
