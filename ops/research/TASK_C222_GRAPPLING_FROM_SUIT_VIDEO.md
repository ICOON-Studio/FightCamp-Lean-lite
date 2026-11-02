# TASK C222 - CODEX - GRAPPLING HOLDS BY THE PROVEN C199 METHOD: LIVE BLENDER VIA THE HIGGSFIELD MCP -> GAME (S114)
Owner: codex. Model: gpt-6-astra, medium (3D animation). `CODEX_WEB=live`. Assigned 2026-09-27 (S114, rewritten the same
session). Branch `codex/c222-suit-grappling` from `origin/master`, own worktree. Claude merges. Step 2 needs the operator's
Blender open and CONNECTED in the Higgsfield panel (Claude opens Blender; the Connect click is the operator's).

## Why
The operator: "we have already done these steps and produced clips that fixed the grip ... why we are moving backwards?".
He is right. In S72-S75 Codex drove the operator's live Blender through the Higgsfield plugin's MCP (`bl_execute` et al.) and
built `C199_Hold`: an MMA closed guard, crossed ankles behind the top man's back, collar tie, wrist control, contacts fixed and
audited, exported as `C199_MMA_ClosedGuard_Att.glb` / `_Vic.glb` with a six-field `PAIRED_BINDINGS` entry "for integration".
**It was never registered in the game.** The Cascadeur holds' grips were fixed too (C168-C175, `HOLD_GRIPS`). This task uses
THAT method - author in Blender by script, the Higgsfield suit video as REFERENCE - for every hold still missing. The
video-to-3D solve (C199 row 2) is NOT on this path; it stays an optional research line.

## What would a human do?
An animator with good reference: watch the reference clip, pose the key frames on the house rig, fix hand/leg contacts, check it
from the game camera, export, bind, play it in the game. Then the next hold, reusing the same seat poses so clips chain.

## Prior research (primary sources - open them, not their summaries)
`C199_DIGEST.md` from the tag (`git show retired/c199-suit-clips-to-3d:research/C199_DIGEST.md`) - READ THE WHOLE
DIGEST: the method, scripts `Tools/footage/c199_author_hold.py`, `c199_pose_audit.py`, `c199_surface_audit.py`,
`c199_export_pair.py`, the `bl_execute` + `runpy.run_path` pattern, checkpoint `_captures/ground_video/c199_pass2_review_checkpoint.blend`.
`topics/paired_holds.md` (C168-C175 contact gates, HOLD_GRIPS), `SHOT_LIST_GROUND.md` (15 ground-graph edges x start / ready /
success / deny / cancel), `_captures/ground_video/README.md` (accepted reference clips per hold), `G84_WHERE_THE_HANDS_ARE.md`.

## Prefab check
Our own proven pipeline: Blender 5.2.1 + Higgsfield plugin MCP, the C199 scripts, `FightClipRetarget`, `PairedStagePlayer`.
C199 files missing on master come from tag `retired/c199-suit-clips-to-3d` (git show / checkout of those paths only).

## Build
1. **Integrate C199's closed guard NOW** (no Blender needed): bring the two GLBs + scripts from the tag, register the six-field
   `PAIRED_BINDINGS` entry in `FightClipBinding.gd` for the MMA closed-guard seat, play it in the fight room from the GAME
   camera (pitch ~65 deg) on two different fighter rigs; MP4 into `previews/c222/`. Contact gate: worst declared
   contact <= 30% (the C168-C175 gate). Step 1 is its own commit.
2. With Blender connected: for each hold in `SHOT_LIST_GROUND.md` without a bound clip, in the order mount -> side -> back ->
   half -> turtle, author START (the seat's loop) with `c199_author_hold.py` using the accepted reference video, audit, export,
   bind, play, record. Then the edges' READY / SUCCESS / DENY / CANCEL where the seat pair exists.
3. Stop and report the failing step if a hold cannot pass the contact gate after two correction passes (C169's rule).
Credits: this method spends NONE unless a missing reference clip must be generated (image first, then video; up to 40 credits,
ledgered). Never pass a RamsterZ clip to any generator.

## Gate (tier: script edited)
PC watchdog first. Parse gate; `python Godot/tools/run_tests.py --jobs 1 --only hold_binding,paired_anchor,retarget,fight_stage`
no worse than master. Renders via `Tools\godot_hidden.ps1`. Raw `.blend` checkpoints to `D:/FightCamp_originals/c222_source`.

## Owned files
`FightClipBinding.gd` (PAIRED_BINDINGS rows), `PairedStagePlayer.gd` (HOLD_GRIPS rows), `Tools/footage/c199_*` / `c222_*`,
`Godot/tools/c222_*.gd`, clips under `Godot/assets/anim/`, `previews/c222/`, `research/C222_DIGEST.md`.

## Deliver
Commit and push AS YOU GO. Digest: per hold, contact numbers and the game-camera MP4. One `agent_comms.py send` line. Do NOT
edit HANDOFF.md. **Trap:** C199's binding JSON was "supplied for integration" - do not assume anything downstream consumed it;
prove the clip PLAYS in a bout (the seat must actually select it) before calling it done.
