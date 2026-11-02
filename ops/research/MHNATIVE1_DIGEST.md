# MHNATIVE1 - native playback delivered; verification in progress

Branch `codex/mhnative1`, dedicated worktree `E:/FightCamp/wt/MHNATIVE1`.
WIP checkpoint `76c405cf` preserved the initial implementation; resume checkpoint
`b89e84a0` preserved the remaining playback fixes and video, and was pushed before
merging master. Merge `3b2e581d` includes master `f0745988`. Native GLBs are the
unchanged ANIMSOURCE1B assets currently on master; no clip authoring was touched.

## Implementation

- All 12 MH4 bodies are available. Selection uses nearest audited kg within sex,
  a stable athlete-id tie break, and excludes the other corner's model. Women
  use 10/11/12 (51/60/70 kg); identity stays MetaHuman for every selected body.
- `mh_native_clips` is GAME_ON and remains OFF in script tests unless enabled.
- FightClipBinding resolves native roles separately from legacy metadata: strip
  `boxing_`, apply director aliases, and use guard_idle -> guard_pose fallback.
  A newly available `mh_<move>.glb` needs no additional registration. Validate
  raw GLB bytes; read phases from animation extras or a JSON sidecar when supplied.
  1B's manifest has no phases, so its documented frame 8 contact / frame 20
  recovery at 30 fps is the fallback (0.266667 / 0.666667 seconds).
- MetaHumanRig maps source tracks to receiver bone names without retargeting,
  preserves local source transforms and helper-joint weights, and restores
  constant source channels omitted by Godot's importer. All 341 joints receive
  position/rotation/scale tracks (1023 total). No rest folding or floor rebake.
- FightStagePlayer binds these animations directly before the retarget branch,
  plays at speed 1 with zero crossfade, uses authored contact/recovery in the
  scheduler, skips tempo/retime/S-curve, and resamples queued native guards at
  their actual clock to prevent the engine's implicit blend from changing hands.
  Legacy roles restore the receiver skeleton basis and existing modifiers.

Native-role bypasses: the procedural advance pose pass (AliveStance, breathing,
fatigue, response, guard and continuity layers), lower-body overlay/front-foot
writer, pose-matched joins, S-curve/retime, spacing flare, reach/pelvis/torso/core/
leg contact corrections, arm IK, glove/contact and head holds (including stale
holds carried from a legacy role), deferred pushes, late reseating, hand-offset
smoothing, strike effector continuity, hand frame/glove spring, aim_strike, hit
physics and every late SkeletonModifier3D (including finger fold/ragdoll).
The room's `_pose_limb_cue` also skips native roles. Missing native roles retain
legacy playback; switch-OFF exercises that control.

Call-site edits: FightWorldLiveScreen.gd 5846-5850 (one predicate); no edits to
FightClipRetarget.gd. Authorized FightStagePlayer windows: 204-206, 854,
1382-1436, 1509-1525, 1587-1589, 1709-1731, 1907-1909, 1993, 2167,
3167-3171, 3564-3566, 3832-3849, 3872-3886, 4145-4147, 4967,
5102-5104, 5157-5159, 5198-5200, 5226-5228, 5325-5327, 5343-5348,
5379-5383, 5396-5398, 5412-5414, 5443-5445, 5482-5484, 5502-5504,
5878-5880, 5930-5932, 6021-6023, 6537, 6617-6619.

## Tests and measurements

- Baseline c4fc4601 (same task implementation as master at intake): new test
  checks=5 failures=3, SUITE total=1 fails=1. Women were not MetaHuman and native
  binding was absent. This red witness was recorded before implementation.
- Current parse gate: CHECK total=8 fails=0 autoload_refs=0 autoload_warnings=0.
- Prepared loader jab extension: 0.940111 of arm length.
- Fresh production test passed after the merge: checks=51 failures=0 (also
  previously SUITE total=1 fails=0). `native_checks.txt` preserves every check.
  It exercises
  actual mounted FightWorldLive ON/OFF, direct native binding / OFF retarget,
  authored clock despite tempo=0.85 and S-curve enabled, three independent raw
  GLB contact comparisons, every late hand entry point, stale hold cleanup,
  modifier disabling, and both legacy/native queue transitions.
- Fresh affected-system gate after merging master is running with jobs=2 and
  one selection: mh_,fight_world,fight_clip,switch_gate,game_switches.
  Watchdog runs before every engine process and waits on RED. The explicit
  resume request for jobs=2 takes precedence over the generic AMBER jobs=1 rule.

## Broadcast-camera evidence

`docs/previews/mhnative1/`: idle.png, boxing_jab.png, boxing_cross.png,
boxing_lead_hook.png. All four used still_framing.save_if_framed with the game's
broadcast camera / pair fit (STILL_FRAMING OK, err=0), not a custom camera.
Both men are framed head to feet; the foreground foot overlaps the game's action
buttons. Opened every PNG with the file image tool on this resume.

What I see: guard gloves flank the face and elbows bend toward the torso. The
jab lead arm extends high toward the opponent's face/guard; the cross rear glove
reaches the face-side guard, with the other glove near the attacker's cheek. The
lead hook keeps a bent raised elbow and brings its glove to the defender's
near-side guard. These are the existing source shapes, not a claim that the
punch trajectories are approved; ANIMSOURCE1 owns their re-authoring. Contact
wrist errors from raw GLB vs stage: jab 0.000000565 m, cross 0.000000075 m,
lead hook 0.000000292 m (all far below 3 cm).

`live_round.mp4` is the encoded hidden-desktop AVI: 20.0 seconds, 1920x1080,
30 fps, 600 frames. `encode.py` verified the encoded duration/frame count before
removing only the task-owned AVI intermediate. `verification.json` records the
MP4 SHA256, 866 native fighter/frame samples and worst native wrist error
0.000000611 m. Raw-source observer reads the final drawn skeleton after the
room's writers; it injects no beats. `live_wrist.csv` is the per-frame evidence.
Opened all 24 numbered frame_review sheets with the file image tool, covering
every frame 1-600, in addition to all four stills. No image/video viewer opened.

Visual limitation: live fallback poses are visibly bad. At frames 98/233/529/
588 (`boxing_jab_body`) and 349/394 (`boxing_slip`) a fighter briefly becomes
nearly horizontal before recovering. CSV confirms those are non-native roles;
they are not source-fidelity passes. Camera ropes also obscure parts of the
fighters near the edge later in the round. Native guard/jab/cross/hook remain
source-faithful throughout, but the whole round is not visually acceptable yet.
The toolkit's supplied C209 reference sheet was opened for comparison: it is
explicitly labelled REJECTED SOURCE, so it cannot serve as accepted real-motion
proof. The toolkit's heavy-bag path does not exist on this host. The supplied
S116 paired clip was sampled at 1.0 s into `reference_pair.png` and inspected:
both performers are in an arms-out calibration pose, not a guard or punch.
These available references do not establish accepted real-motion punch shape.
No reference generation credits were used.

## Remaining

Finish the affected-system gate, compare any red result against unchanged
master, record its final summary, and commit/push this digest and verification.
Whole-round visual acceptance remains with the native clip authoring owner and
legacy fallback fixes; do not conceal the horizontal poses with native warps.

Task precedence: explicit MHNATIVE1 dedicated branch and minimal player-edit
authorization override the generic master/rebase and owned-file exclusion.
Historical assignments from intake brief were not started. No subagents,
GameState/FightRealtime edits, clip edits, Cascadeur runs or .import churn.
The isolated .mhnative1_baseline control is untracked and not required by the
production test; it is excluded from commits. No full suite was run.
