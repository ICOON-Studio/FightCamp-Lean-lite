# C237 — receiver reactions and moving guard

Review candidate, **not certified**. The authored clips are bound and the live-room film is delivered for operator review. `certified_moves.json` and `HANDOFF.md` are unchanged. C223 still rejects reaction entry joins and its receiver-spacing overlap rows; this is not an acceptance claim.

## Delivered

- `docs/previews/c237/live.mp4`: 30 seconds, 900 frames, 1280×720, 30 fps, silent (`imageio-ffmpeg`, `-an`), live room `as_game`, seed 92012, game camera. `video_receipt.json` records the hash and dimensions.
- Blender-authored `assets/anim/c223/c237/`: back/left/right head snaps (0.70 s), body fold (0.767 s), hurt stumble (0.80 s), standalone guard-recovery study (0.60 s), active guard loop (2.40 s). Every GLB is below 40 KB. `SOURCE.json` records source hash, licence provenance, authoring and output hashes.
- `FightClipBinding.gd`: only `react_*` entries. The original owned Pipeline-A boxing guard supplies the base and rest reference. New reaction rotations, pelvis recoil and planted-foot IK are keyed in Blender. This is local authoring; no paid generation or new external asset purchase.
- `FightStagePlayer.gd`: receiver selection and recovery, plus the waiting receiver's boxing idle source. Head direction uses the existing handedness/stance-derived `reaction_dir`; presented `shocked` selects the stronger stumble. Queue pricing, impact entry and playback share the same selection. An ordinary hit never selects a hurt take through round-robin.
- Each reaction retains its early impact and blends only its last 0.18 s to moving guard. Every variant and mirror gets that recovery. The standalone recovery study is supplied as an authoring asset; gameplay uses the recovery already included in each reaction plus this guard join.
- Active guard keys lateral weight shift and alternating small step-and-settle motions. Existing floor handling, locomotion and game placement remain in charge of the feet/root.

## Census and why the old clips were not certified

The receiver path is `_present` → `_queue_decide` → `play_role` / `_play_single_role`. `react_head` chooses with `FightReactionSide`, body used its region pool, and leg used `_leg_reaction_take`. Whole-reaction game playback enters at first keyed motion and queues idle after completion.

| Original role | Owned source / windows | Findings |
|---|---|---|
| head | RamsterZ `H2H_HitReaction01/02/03.FBX`; 2.47–3.03, 3.07–4.00, 4.03–4.87 s | Back-dominant pool; latter takes 0.93/0.83 s; no authored pure left/right snap. |
| body | RamsterZ `H2H_StaggerSmall01/02/03.FBX`; 0–1.00, 1.03–2.43, 5.83–7.03 s | 1.00/1.40/1.20 s, with S134b torso correction layers on takes 1/2. |
| leg | RamsterZ `H2H_StaggerSmall01.FBX` 0.40–1.00; severe-leg `H2H_StaggerLarge04_LowHit.FBX` 8.83–11.53 | 0.60 s ordinary / 2.70 s severe; no certificate entry. |

The exact requested baseline command **was run** with `plant phase live_contact bound`. It stopped at `c223_production_gate.gd:315`: `Invalid access ... 'entry_s'` because the old bound reaction had no `matched_guard` metadata. The stalled process was stopped, not counted as a pass. `c237_before_without_phase.json` is a separately labelled one-rig diagnostic retry with `plant live_contact bound`, never a substitute phase acceptance result.

That diagnostic rejected all three base reactions for entry joins and overlap. Body/leg additionally slid **23.20 / 18.72 cm** during planted runs. The recorder's “not certified” caption is only a hard-coded whitelist and is not a certificate authority. No `react_*` entry existed in `certified_moves.json`.

## Production measurements

`c237_after.json` is the unchanged production gate with **plant phase live_contact bound**, all four generated rigs, three bound reaction roles. New planted-foot slip is **0.134–0.221 cm** across the 12 rows. All return to idle. None of the 12 is accepted: all retain `join_discontinuity` and `body_overlap`; body fold also triggers G147 clipping, and the heavy-C body row triggers a pin-pop. The heavy-C reference jab also reports a pin-pop. Raw rows and thresholds are preserved.

For the sampled welter-A head row, **exit** excess acceleration is zero for both hands and hips; the remaining join failure is at **entry**. Recovery is improved, but this does not excuse the entry failure.

`c237_left.json`, `c237_right.json`, `c237_hurt.json` add one generated-welter witness for every directional head take. `Tools/cascadeur/c237_gate.py` generates the existing gate verbatim except for passing the requested direction into `play_role`; it changes no binding, threshold or measurement. These rows also reject entry/overlap. They are measurements, not four-rig variant certificates.

**Fixture limit:** C223's `anim_react_*` entries identify `Head` as a striking effector. With `live_contact`, the striking-effector spacing solver collapses the fixture to 0.50 m and applies attacker contact handling to a receiver clip. That is not a two-man landed-punch reaction test. The raw gate's `source` label also remains the legacy `TAKES` source although `bound` loads the new runtime binding. Actual source paths are the binding and `SOURCE.json`. No gate code or pass criteria were weakened to hide this mismatch; actual live-room overlap still needs operator/integration review.

The production-player probe asserts occurrence, signed head direction, duration, guard return, body flexion, stumble step, and idle motion. On the generated man it measures approximately **10.0 cm back, 8.2 cm left, 7.0 cm right**, **20.1° body flexion**, **9.6 cm stumble foot travel**, **2.0 cm idle head motion / 2.6 cm idle foot motion**. Angles/timings are authored judgement informed by K51, not claimed biomechanical measurements. Exact final values are in `player_probe.json`.

## Visual review

Opened full-size live frames, the nine-frame live contact sheet, and the impact/recovery sheet. Both men change guard, weight and foot position while the opponent works. The head shot around 4.2 s gives a brief backward recoil and returns to guard; around 18.3 s the receiver folds at the waist and recovers. The ring, game camera, gloves and both fighters are visible. Close exchanges still have crowded silhouettes, and the existing attack/placement motion can crouch or cross the men; this task does not claim those wider fight-presentation issues are solved.

Opened separate generated-body frames for left/right/back, hurt, body and leg takes. These are plain white authoring witnesses, not the game-camera deliverable. The initial f01-only witness used an unsuitable visual rig pose; it was replaced with the generated rig family used by the gate/live room. A body-fold check was corrected to measure trunk angle relative to the hips, because absolute chest travel confounds flexion with pelvis recoil. The angle gate remains an occurrence requirement (>6°), not an assertion that a setter ran.

## Verification and reproduction

- Parse gate before every test/probe revision; final **CHECK total=3 fails=0**, recorded in `verification.json`.
- Required focused suite: `python Godot/tools/run_tests.py --jobs 2 --only fight_clip,fight_stage_presenter,certified,clip_binding`. The first run was `SUITE total=11 fails=1` because new GLBs lacked importer sidecars. After a Godot import, that failed test passed `SUITE total=1 fails=0`. Final full requested subset: **SUITE total=11 fails=0**, recorded in `verification.json` and `focused_tests.txt`.
- `Tools/cascadeur/c237_probe.gd -- render` through `Tools/godot_hidden.ps1`: **33 checks pass, C237_PROBE fails=0**, including queue/playback agreement for all four head directions; final occurrence and visual witness results in `player_probe.json`.
- Author: Blender 5.2.1 headless, `--python Tools/cascadeur/c237_author.py`. The exporter merges empty-node actions into one animation per GLB; the first attempt exposed split actions and was rejected by the motion probe.
- Record: `Tools/godot_hidden.ps1 --path Godot --script tools/s119_live_record.gd -- as_game out=E:/FightCamp/wt/C237/previews/c237/frames seconds=30 seed=92012`; encode with `python Tools/cascadeur/c237_encode.py`.
- Watchdog before heavy runs. One import-time AMBER reading (86% RAM / 85% CPU) was reported; later runs were GREEN. No other agent's process was terminated.

## Scope / handoff

C237's explicit branch/task supersedes unrelated mailbox assignments and the generic HANDOFF update. No HANDOFF read or edit. The optional game-asset-production CLI was unavailable; C237 explicitly authorized the installed Blender route, and its named runtime asset destinations take precedence over a separate package workflow.

The import rewrote 359 tracked sidecars in the worktree. Automatic review rejected restoring them; a read-only byte comparison then proved **359/359 identical to HEAD**. Their contents were left intact and they are excluded from staging. Newly generated untracked importer metadata outside the task was removed. Only explicit C237 paths are committed. Operator approval of `live.mp4` is still required before any certification entry.
