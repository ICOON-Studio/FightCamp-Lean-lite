# OFFBAKE1 - wrist gates green, visual route REOPENED

Branch: `codex/offbake1`, isolated worktree `E:/FightCamp/wt/ANIMFIX2`.
Task: `research/TASK_OFFBAKE1.md`. Candidate only: DO NOT INTEGRATE.
The task's reopen-if-worse condition is met by the native hook facing away
and the uppercut contact reading as a crouched guard. No visual acceptance.

## Game-camera A/B

Six matched moments, OFF/ON, seed 930093, as_game, broadcast, fixed 30 fps,
MH09 Vance (red, left) / MH08 Miller (purple, right). All twelve PNGs passed
`still_framing.save_if_framed` and were opened with the file-image tool.
Per-still wrist/face-box numbers: `OFFBAKE1_AB_READBACK.md`; raw JSON and
six-line captions: `previews/offbake1/{before,after}/readback.json`
and `captions.json`. Full framing receipt: `OFFBAKE1_CAPTURE_RECEIPT.txt`.

| Miller moment | OFF wrist L/R deg | ON wrist L/R deg | Visible finding |
|---|---:|---:|---|
| guard .600 | 17.53 / 21.16 | 0.19 / 0.32 | Higher, closer guard; foot roll remains |
| jab between | 16.68 / 16.33 | 0.19 / 0.32 | Native frame 6: partial extension with rear glove high; foot tilt remains |
| jab contact | 16.60 / 15.97 | 0.19 / 0.32 | Glove front still appears drooped despite straight bone segments |
| cross contact | 25.03 / 12.18 | 0.19 / 0.32 | Guard hand higher; tilted feet remain |
| hook contact | 21.57 / 5.14 | 0.19 / 0.32 | Native head turns away from Vance: worse than OFF |
| uppercut contact | 135.25 / 59.41 | 0.19 / 0.32 | Native contact reads as crouched guard, not a clear rising strike |

The fixture freezes both live players and seeks the source contact clock;
it does not prove a landed hit or live hand-contact solve. Bodies remain
a step apart. Face-box numbers are wrist-minus-head skeleton coordinates,
not a new acceptance threshold. The measured wrist improvement is real;
it is insufficient for player-facing approval. Source-loader guard sole
pitches near 1-2 / 7-9 deg become about 20 / 23 deg with roll on MH08 in the
production capture. No mirror or foot-bake code was changed to hide this.

Posted 12 originals via `review_add.py --stage S226`:
`E:/FightCamp/review/2026-10-15_2155_offbake1_final_a_b_hook_facing_regressio`
([operator review board](http://127.0.0.1:8787/review)). SendUserFile is not
available in this tool session; the originals are linked in the repository
and posted on the board. Final frame-6 intermediate sample replaces the initial
half-contact sample inside the native hold. All twelve final originals were
opened again and board copies hash-verified. The supersedes request found no
older active post; no other review files were changed. Claude must open them;
operator closure remains OPEN.

Ruling: preserve this measured candidate and reopen the route as the task
explicitly requires. Do not invent another runtime pose/mirror/foot repair
or claim that passing bone-line tests overrides the visible regression.

## Sole comparison

All four requested seed/pair runs completed once: 94301 and 930093, each
with MH09/08 and MH05/02. Each foot has 1,802 samples / 60.033333 seconds.
The unchanged bands remain RED on all sixteen feet/runs. Aggregate outside
samples are 28,582 -> 28,529 of 28,832, with individual regressions: seed
94301 MH08 lead maximum pitch is 50.305 -> 81.783 deg; seed 930093 MH02 rear
is 60.870 -> 81.022 deg. Full side-by-side counts, peaks and longest runs:
`OFFBAKE1_SOLE_COMPARISON.md`. Baseline is pinned to ANIMFIX2 commit
`2f6ecc8127d7ce196bd69ad3fac5bae818e63730` in `OFFBAKE1_SOLE_BASELINE.json`.
Raw CSV/JSON and launch receipts are retained. Watchdog refusals happened
before launch and are not additional sole runs. No script/body/run-length
error occurred; both capture arms and sole runs retain exit cleanup errors
(ObjectDB leaks, resources in use, PagedAllocator), not clean engine exits.

## Saved native scenes and reproduction

Original inputs: `E:/FightCamp/wt/ANIMSOURCE1/Tools/cascadeur/animsource1/mh_<move>.casc`.
Working inputs and corrected outputs:
`E:/FightCamp/wt/ANIMFIX2/Tools/cascadeur/offbake1/{mh_,baked_mh_}<move>.casc`.
The five moves are guard_pose, jab, cross, lead_hook and inside_uppercut.
As the existing Cascadeur README requires, these scenes and raw mesh exports
remain local/ignored. They are NOT retrievable from Git alone.

Independent local archive outside either worktree:
`E:/FightCamp/archives/OFFBAKE1/2026-10-15-native-scenes.zip` (76,367,003 bytes),
SHA256 `653c84857d2a685d00f8de879357735b0c31a7464d7e5fe499406281dc494f4b`.
All ten entries were read back and hash-verified; per-entry hashes and restore
directory are in `Tools/cascadeur/offbake1/scene_archive.json`.
For a fresh checkout, extract that archive into `Tools/cascadeur/offbake1/`,
then run `python Tools/cascadeur/offbake1/produce.py guard_pose` followed by
each punch name. The helper enforces watchdog and verified hidden desktop,
saves the corrected scene, exports and packages the light GLB. Run
`python Tools/cascadeur/offbake1/validate_bakes.py` and the named Godot gates.
Cascadeur access ends 2026-10-27; all authoring/saved scenes here precede it.

## Independent review

The fresh reviewer found the branch a sound reviewable failed candidate,
unsafe to integrate, and independently confirmed the hook/uppercut regression
and all fifteen asset/scene receipt hashes. Additional Important integration
defect: `FightStagePlayer.vendor_world_peak_mps()` still derives limits from
the legacy binding path/span. Those limits feed live hand IK and root/turn
caps while using native warp metadata. This is NOT a retarget pass on the
native animation, but is a mismatched downstream reference. Distortion and
its magnitude were not established; do not attribute the paused visual
defects to it. Before integration, follow the resolved source/span or make
an explicit measured policy decision. No repair is required to preserve the
failed candidate, and the no-integration ruling remains binding.

Deferred minor: the production proportion assertion covers guard segment
lengths and hip-offset magnitude, not vector offsets/contact-pose proportions.
Keep that claim narrow. Live hit solving, motion continuity and sliding are
not established by the paused stills. Stale remaining-step text and local
source retrieval documentation are corrected in this handoff.

## Execution ledger

- Intake: clean named branch; fetched and rebased origin/master. Shared Git
  metadata required sandbox elevation. Read required toolkit, safety, visual
  gate, traps and Cascadeur pipeline. Brief and inbox checked; old unrelated
  assignments do not replace this explicit task.
- Sources: copied the five saved `mh_*.casc` scenes from the ANIMSOURCE1
  worktree into `Tools/cascadeur/offbake1/`; originals remain untouched.
- Measurement: brought only `guard_wrist_line_test.gd` from codex/animfix3
  using its file content; no production implementation collected.
- First parse launch refused at watchdog RED (84 C). A later AMBER launch
  was denied hidden-desktop access by the sandbox; elevated parse passed:
  `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- Red witness: `GUARD_WRIST_LINE failures=18`, `SUITE total=1 fails=1`.
  Native guard L/R = 19.274476/27.376961 deg; shipped MH08 right =
  21.160148 deg, all against 10 deg. Full raw output:
  `OFFBAKE1_BASELINE_WRIST.txt`. No production change precedes this witness.
- Baseline committed/pushed as `3fcdbabb`.
- Guard first candidate exported and independently measured in Godot:
  0.000055/0.000238 deg. Jab/cross controller witnesses also straight.
- Hook exposed a transition failure in the box-controller input: guard/contact
  passed but frames 5-7/9-10 flipped to 109-159 deg. Export refused. Preserving
  arm controls alongside the box restored the original wrist, so was rejected.
- Found and read the existing ANIMSOURCE1 local `fix2_points_native.py` and
  `fix2_hook_control_probe.json`: this exact IK branch issue was previously
  measured; point-only orientation is authoritative. Reused that method with
  minimal rotation, without its unrelated head/palm-style changes.
- Hook point-only candidate passes all 21 frames; elbow drift 0.000070 cm.
  Regenerated all five clips with this method and explicit elbow/wrist drift
  checks before the asset commit. No physics re-solve or scene swap while a
  worker is active; only the verified task PID is recycled between scenes.
- Runtime red witness committed/pushed as `c7aff4d0`: five requested native
  roles still resolve legacy files with the switch requested; MH08 guard
  remains 17.525862/21.160146 deg. `NATIVE_MH_CLIPS failures=8`.
- Shared guard snapshot now drives punch frame 0/20. Jab endpoint error is
  below 0.0001 deg across all native rotation tracks; the original uppercut
  differed by 0.53 deg, so its endpoints also use the shared snapshot.
- First six baseline captures passed framing but numerical readback failed:
  paused AnimationPlayer clears `current_animation`; use `assigned_animation`.
  Excluded that run and replaced it before review. No visual claim from it.
- Native loader/player/switch parse passed; subsequent capture parse and
  authoring launches repeatedly refused watchdog RED at 84-86 C. No engine
  run or controller edit starts after those refusals.

## Task-specific rulings

- Offline stage complete: all five corrected `.casc` scenes are saved locally
  in `Tools/cascadeur/offbake1/baked_mh_*.casc`, with hashes in the receipts.
  Their lightweight GLBs are under `Godot/assets/anim/metahuman/baked/`.
  All 21 frames pass the Cascadeur wrist and elbow/wrist displacement checks;
  maximum elbow displacement is 0.000442 cm. Independent final GLB audit
  verifies 341 joints, no mesh, 30 fps, frame-8 contact, frame-20 end and
  shared endpoint rotation error below 0.0001 deg. Baked Godot wrist gate:
  `GUARD_WRIST_LINE failures=0`; raw output `OFFBAKE1_BAKED_WRIST_GREEN.txt`.
- Native loader stage readback (`OFFBAKE1_NATIVE_RAW.json`): 20 body/role
  samples, all wrists below 6.751 deg. Guard actual-mesh lead sole pitches
  1.05-1.77 deg, rear 6.94-8.77 deg. This is before production foot planting,
  not the final game-camera or sole-gate verdict.
- Runtime proportion witness: all 20 native paths and guard wrists passed,
  but copying the master's hip translations changed the other bodies' hip
  offsets by 7.64-9.96 mm (`OFFBAKE1_NATIVE_PROPORTION_RED.txt`). Native loading
  now applies authored position displacement relative to each body's rest;
  rotation keys remain native, apart from the single packaging carrier axis.
  The fast readback reduces guard hip-offset change to 0.041-0.487 mm and
  leaves arm/leg segment lengths unchanged. Ruling: hip socket offsets allow
  the source's sub-mm motion (1 mm gate); actual limb lengths retain the
  0.1 mm gate. The original 8-10 mm witness fails either threshold.
- Production native gate is GREEN (`NATIVE_MH_CLIPS failures=0`, runner
  `SUITE total=1 fails=0`): OFF MH08, ON MH02/05/08/09 and ON generator control;
  all five resolved paths, all four frame-8 contacts and both wrists at every
  contact/guard, limb lengths, hip offsets and unrelated rear-hook source.
  Full output: `OFFBAKE1_NATIVE_PATH_GREEN.txt`. Parse: touched five scripts
  passed, then revised native loader/test/probe each passed separately.

- Use this approved task as the execution plan and this digest as its ledger;
  no new design or redundant plan is needed. Source cleanup precedes wiring.
- Task overrides generic rules: branch pushes only (never master), focused
  subset with jobs=1 unless GREEN, watchdog and hidden launcher for every run.
- Preserve the established Cascadeur normalization/animation-only packaging
  and receipts rather than introduce a separate asset-package format.

## Handoff checks still running

Final A/B frame-6 sample, twelve inspections and S226 post are complete.
The requested 17-test regression subset is running; three initial tests were
refused by watchdog RED before engine launch. Record final results, retry only
blocked tests when the watchdog permits, then send Claude the no-integration
handoff with the final pushed digest.
