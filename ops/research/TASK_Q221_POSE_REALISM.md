# TASK Q221 - pose realism sweep of every palette move and reaction (animation, Qwen, long run)
Model: medium. Owner: Qwen (qwen3-coder --yolo). Branch: qwen/q221-pose-realism.

## Why
The operator watched the live boxing recording and saw poses no boxer makes (S133_DIGEST.md lines 32-35: a near-flat
lean, a near-horizontal lunge, a deep crouch). S134b found the first cause with a new instrument:
`Godot/tools/s134_pose_probe.gd` (trunk tilt Hips->Head vs vertical + hip height, per body per frame, with the
clip-alone tilt beside it). `boxing_slip` was authored at 68-70 deg; an additive pose layer (Spine -20, Chest -20)
brought it to 37 deg and it re-certified 4/4 (commit 1e91b02; certificates
`previews/c223/s134b_slip_*.json`). The same probe still flags (seed 92012, 30 s):
react_head#3 58 deg, boxing_cross_body 53, boxing_jab_body 43, boxing_cross 42. Your job: do this for EVERY clip.

## Prior research (read first)
- `python Tools/prior_research.py trunk tilt pose realism lean crouch`; `research/topics/retarget_rig.md`.
- `research/C223_DIGEST.md` section "S120 ... variants by ADDITIVE POSE LAYER" (how pose_layer works, axes).
- `Godot/scripts/FightClipPoseLayer.gd` lines 1-60 (spec format: bone, deg [x,y,z] LOCAL, from_s/peak_s/hold_s/to_s;
  weight 0 at from_s and to_s so certified joins are untouched). MEASURED AXIS: on "Spine"/"Chest", +x bends the
  trunk FORWARD, -x back (S134b: +20 made the slip worse).
- `research/S131_DIGEST.md` section 2 (how the palette was re-certified; gate flags).

## What would a human do?
A game animator with a mocap library: measure every clip against real boxing ranges (trunk lean in guard 10-25 deg,
slips/rolls up to ~35-40, body punches bend the trunk ~30-45; hit reactions snap the head, the TRUNK rarely past ~40;
hips drop at most ~15-25% in a duck), fix the outliers with the smallest additive layer, re-check the joins, then
re-certify. Never re-author a clip that already reads right.

## Prefab check
Already decided: the RamsterZ + Mixamo clips in the palette stay (C223). Do not import new clips in this task.

## Owned files
- `Godot/tools/s134_pose_probe.gd` - extend it (seeds and bouts are args; add a `table` mode that prints per clip:
  frames, p50/p95/max tilt, min hip fraction, clip-alone max). Run it over 5 DIFFERENT seeds (92012 plus four you name)
  so every palette clip and every reaction take appears; say which clips never appeared.
- `Godot/scripts/FightClipBinding.gd` - ONLY `pose_layer` entries on the clips you fix (react_* variants included; a
  variant's layer goes in its own variant dict if the binding supports it - read FightStagePlayer's variant handling
  first, `grep -n "variants" Godot/scripts/FightStagePlayer.gd`). Nothing else in that file.
- NEW certificates under `previews/c223/q221_*.json`; NEW digest `research/Q221_DIGEST.md`.
- NOT yours: FightRealtime.gd, FightDefenceModel.gd, FightIntent.gd (Codex C228 owns engine files), tools/c223_*.gd.

## Work loop (one clip at a time, commit + push after EACH clip; never stop at "written")
1. Table: run the probe on 5 seeds, rank clips by p95 tilt and min hip. Criteria (AUTHORED, from the ranges above):
   p95 tilt <= 40 deg for punches and slips, <= 45 for body punches, reactions <= 45; min hip >= 0.72 of standing.
2. For the worst clip: find the lean DIRECTION (the probe's `axes` flag prints head-from-hips in the fighter's local
   frame; -z is toward the foe), add the smallest pose_layer that brings it inside the criterion, re-run the probe
   (clip-alone column must move; every OTHER clip's numbers must stay identical - that proves the engine did not move).
3. Re-certify that clip on the 4 legal generated rigs, bound production path, one rig per process:
   `python Tools/c223_parallel.py production --jobs 2 -- plant phase live_contact bound clips=<gate id> report=q221_<clip>.json`
   Gate ids are the TAKES keys in `Godot/tools/c223_production_gate.gd` (the slip is `q215_slip`, not `boxing_slip` - a
   wrong id silently runs only reference_jab). Pass = every row of that clip: mechanical_failures [], g147_pass true.
   If the clip is part of a certified chain (`Godot/tools/c223_sequence_gate.gd` SEQUENCES lines 4-19), run the chain:
   `python Tools/c223_parallel.py sequence --jobs 2 -- bound live_contact certificates=s131_offset_bound.json,q221_<clip>.json clips=<chain ids> report=q221_<clip>_chains.json`
4. A clip that will not pass with a layer: revert its layer, record the numbers, move on. Never loosen a gate.
5. Reactions (react_head variants, react_body...) are not in the C223 production gate: for them the pass is the probe
   plus `python Godot/tools/run_tests.py --jobs 2 --only reaction,fight_strike_whole,room_no_teleport`.
6. Digest: before/after table per clip (p95/max tilt, min hip), the layer added, the certificate, what failed.

## Tests
Parse gate before any test: `python Godot/tools/check_scripts.py <touched .gd>`.
After each binding edit: `python Godot/tools/run_tests.py --jobs 2 --only certified_palette,clip_binding`.
Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.
Windowed runs (stills) only via `Tools\godot_hidden.ps1`; never kill Godot by image name.

## The one trap
The probe's frame numbers do NOT match the recorded mp4 frame for frame (the recording was windowed) - judge clips by
the probe's per-clip table, not by the video frame index. And the exit code alone is not a pass: read the report rows.
