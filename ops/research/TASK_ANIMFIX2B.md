# TASK ANIMFIX2B (S226) - the guard wrist bend that exists before any pose layer

Model: Codex gpt-6-astra, reasoning high. PC seat (Godot + GPU for stills). Worktree E:/FightCamp/wt/ANIMFIX2 (already seeded),
NEW branch codex/animfix2b cut from master 63997f79 or later (master holds ANIMFIX2 r2: 20a21082). Never master.
New features ship ON (CLAUDE.md s10): no new switch. Plain --script tests stay the OFF arm; as_game turns the game on.

## The defect (measured, ANIMFIX2_DIGEST.md "Round 1" + "Round 2")
Wrist line = angle between LowerArm->Hand and Hand->MiddleProximal (posed segment directions, NOT quaternion parts).
Active guard at t=0.600, retarget OUTPUT (before any pose layer, before foot bake):
- MH08 rear wrist **21.1602 deg**, MH05 **16.8222 deg**. Lead uppercut .600 MH08 rear wrist **41.7267 deg**.
The operator sees bent gloves in every guard still (S225 review stills, "lead glove line bent").
First measured boundary: `Godot/scripts/FightClipRetarget.gd:486` -> `RestFixer.pose_frame` (`Godot/scripts/BoneRestFixer.gd:102`).
NOT YET ISOLATED: is the bend in the SOURCE clip on its own rig, or introduced by the retarget? That is step 1.

## Do (one change per commit, push every commit)
1. RED + ISOLATE. A test `Godot/tests/guard_wrist_line_test.gd` that, for the active guard binding (.600) and the lead uppercut
   (.600), prints the wrist line for BOTH wrists at three stages: (a) the source clip on its own source skeleton (FK readback of
   the source file), (b) retarget output on MH02/MH05/MH08/MH09, (c) after the production pose layer. It must go RED on today's
   master for MH08 guard (21.16). Paste the red lines in the digest.
2. CAUSE. If (a) already shows the bend: it is the source take - stop, report the numbers and the file; Claude routes it to
   ANIMSOURCE (no fix in this branch). If (a) is straight and (b) bends: find which correction in BoneRestFixer / the rest
   alignment for Hand (or LowerArm twist) produces it - likely the hand rest frame differs between the source rig and the MH rig
   (palm axis / twist roll) and the fixer carries the source's local rotation into a differently-rolled MH hand rest. Fix the
   CAUSE in the retarget (the hand's rest alignment), for every MH body at once. NO clamp, no per-clip hand offset, no recipe edit.
3. GATE (green after): retarget-output guard wrist line <= max(10 deg, source value + 3 deg) on all four MH bodies, both wrists;
   the uppercut rear wrist <= source + 3 deg. Existing gates must stay green: `anatomical_pose_layer_test`, generator key parity.

## Gate commands
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- Focused: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/guard_wrist_line_test.gd` (NEVER _console.exe).
- Then `python Godot/tools/run_tests.py --jobs 2 --only anatomical_pose_layer,fight_clip,retarget,rest_fix,stage_player`
  (`--jobs 1` if the watchdog is not GREEN). The known nightly reds (fight_clip_slice rear hook 1.724 s, staff_pose) are not yours.
- Sole gate: re-run `tools/animfix1_sole_gate.gd` ONCE for the same 2 seeds x 2 pairs as ANIMFIX2 (command in ANIMFIX2_DIGEST.md),
  table baseline (ANIMFIX2 after) -> after. Arm-only change: report, do not tune feet.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on the bent guard wrist; paste that number in your report.
2. Stills only via `tools/animfix2_pose_room.gd` (-- as_game, broadcast camera) + still_framing.gd save_if_framed: guard .600,
   catch .275, uppercut dip .600 - before (master) and after. Post with `python Tools/review_add.py --stage S226 ...`.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Rules
godot_hidden.ps1 only for windowed runs, watchdog (`Tools\pc_watchdog.ps1 -Once`) before every Godot run, explicit `git add -- <files>`,
no *.import churn, no mirror / native-clip / foot-bake change. Never open an image or window on screen - read files.
End: `research/ANIMFIX2B_DIGEST.md` + an AgentComms/messages note to Claude.

## Prior research
ANIMFIX2_DIGEST.md (wrist table, stage readbacks), ANIM_AUDIT_VERDICT_S224.md s4 (the fix order), TASK_ANIMFIX2.md rulings,
BoneRestFixer.gd header, GDSCRIPT_TRAPS.md.

## What would a human do?
A technical animator puts the source rig and the target rig side by side in the same frame, compares the hand's rest axes, and fixes
the retarget's hand alignment once - never keys a correction into every clip.

## Prefab check
Godot's own SkeletonProfile/BoneMap retarget handles rest-roll differences; compare its hand handling with BoneRestFixer before writing new maths.

## The one trap
A wrist "line" measured from quaternion components or Euler angles reads differently per rig rest. Measure posed SEGMENT directions,
exactly as ANIMFIX2 did, or the gate goes green while the glove stays bent.
