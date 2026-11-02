# JUDOPROOF1 — authored osoto-gari feasibility measurement

**Verdict: NO, this prototype does not establish a throw that would pass as real osoto-gari to a judoka.** Contact and skeletal geometry pass; the motion fails the jerk threshold by about 125 times. No stills were rendered or inspected. Do not authorize the remaining 13 throws from this experiment's contact tests or extrapolate a production price from it.

Branch: `codex/judoproof1`. Baseline: `3a02dba25511ca88c3cc680e64b888a47f5967fc` (unchanged master implementation when the missing-module test was run). Source: authored keys, R27 timeline; no paid generation, clip purchase, source video or image viewer. No external visual reference was watched under the operator's no-viewer instruction.

## Delivered implementation and evidence

- `scripts/rules/JudoThrowKeys.gd`: seven paired keys, 22 humanoid rotations per fighter, pair-space pelvis positions, quintic interpolation, canonical-profile sleeve/collar world sockets. The 610 ms key makes the ukemi hand contact precede the 650 ms back landing by 40 ms.
- `scripts/JudoThrowPlayer.gd`: loads the actual f01 welter and f02 heavy GLBs directly using GLTFDocument, mounts through PairedClipMount, plays one shared clock, and samples final Skeleton3D world transforms. Actual rig sockets replace canonical-profile sockets before solving. These house meshes are boxing bodies; the gi points are virtual garment locations, not measured cloth surfaces.
- Analytic two-bone limb IK resolves reach using FightPoseSolver's actor-space grip target API. `FightPoseSolver.refine_hands` then scores/refines 12 actual local arm rotation parameters with roots excluded from the parameter vector. Zero-radius hand/socket capsules score point distance only; this is **not a body collision, cloth or penetration audit**.
- `tools/judo_throw_stills.gd`: exports the exact R27 s5.1 CSV prefix, then measured head position, all 22 bone positions/rotations, sockets, active grip windows and pre-solve errors. The capture path instantiates the real FightWorldLive scene with record_room's configure-before-add/setup lifecycle and `as_game`, freezes simulation, replaces the stock pair with this player, and uses the live broadcast camera and actual deck. It saves only through `still_framing.save_if_framed`, with posed bone/head/toe coverage instead of a standing-height surrogate. **The capture path is parse-checked but has not run.**
- `tools/judo_throw_metrics.py`: standard-library CSV measurement. Differentiation is grouped by fighter; planted sliding uses only adjacent frames in a contiguous planted interval, never a filtered sequence across airborne gaps. COM uses normalized coarse segment-mass proxies; the one-foot kake support is an 8 cm ankle disc. This is descriptive geometry, not force-plate biomechanics.
- `tests/judo_throw_keys_test.gd`: real-rig bone-length witnesses, independent garment-target reconstruction, grip limits through 420 ms, sleeve retention through landing, airborne-phase checks on each foot, actual airborne occurrence, back-facing-up landing, mat slap at 610 ms and a dropped-sleeve mutant that fails the independent geometry check. It also checks the contact solver's root movement is zero. A green test does not certify realism.

Evidence: `docs/previews/judoproof1/joints_60hz.csv` (60 Hz, 0–650 ms, both fighters), `metrics.json`, `keys_test_green.log`, `csv_run.log`, and `engine.log`. Positions are measured from the posed rigs, not copied from expected values. Exact bone lengths are preserved by rotations; no bone scaling or endpoint teleporting is used.

## Gates and tuning

The initial RED gate produced **one missing-module failure**, `SUITE total=1 fails=1`, before adding the implementation. The first implemented geometry run produced **12 grip failures** and unrelated missing-import/autoload errors. Three animation tuning rounds followed:

1. Move the initial pair into arm reach, add an actual support-foot entry step, lower/advance tori through the fall so the two grip targets become reachable. The initial collar error was 6.8 cm; at late kake both grips reached about 20 cm error. Those failures required body keys, not extra solver iterations.
2. Cache solved local limb rotations at the 180/280/420 ms contact releases, blend them toward authored keys, and retain the sleeve through landing. This reduced one intermediate jerk result from 108,329 to 22,107 m/s³ but did not resolve realism.
3. Lower uke's entry pelvis from 1.00 to 0.94 m, eliminating unreachable planted-leg extension; bring the free ukemi hand onto the mat at 610 ms. The rapid slap raised the final maximum head/wrist jerk to 56,294 m/s³.

There were **six successful focused green runs** during implementation, including the final strengthened witness test and shared-clock play/stop check. A solver API integration attempt failed on incorrect DOF dictionary names (`min/max` instead of `lo/hi`); that was corrected, not counted as animation tuning. Final parse: `CHECK total=4 fails=0`; final focused/affected-system runner: `SUITE total=1 fails=0`, timeout 300 seconds, jobs 1. The final test prints `JUDOPROOF1: 0 failure(s); mutant_rejected=true`. No full suite was run.

The fresh worktree initially lacked font/audio import caches. A headless editor import made the focused gate runnable, but the import process itself ended with a nonzero code; it is not claimed as a successful whole-project import. All generated tracked import changes and untracked UID/import metadata outside the owned outputs were restored/removed. The final headless CSV run exits zero and reports the known Windows certificate-store error; no GDScript error is present in its final log. The test runner classifies that host certificate error as noise.

## Achieved versus wanted

| Metric | Achieved | Wanted | Result |
|---|---:|---:|---|
| Contiguous planted horizontal foot speed | 0.000014 m/s | ≤0.025 m/s (R27 s5) | PASS |
| Maximum active hand/socket distance | 0.000000187 m | ≤0.030 m (task) | PASS |
| Same active hand/socket distance | 0.000000187 m | ≤0.012 m (R14 reference) | PASS |
| Maximum head/wrist linear jerk, 60 Hz differences | 56,293.993 m/s³ | ≤450 m/s³ (R27 s5) | FAIL |
| Peak linear joint speed, all 22 bones | 18.121 m/s | No sourced maximum in R27 s5 | Descriptive |
| Peak global bone angular speed | 1,831.219 deg/s | No sourced maximum in R27 s5 | Descriptive |
| Largest uke COM projection distance outside tori's kake support disc | 0.543402 m | No numerical acceptance threshold supplied | Descriptive |
| Maximum unsolved active hand/socket distance | 0.474863 m | Not an acceptance threshold | Control |

The peak joint speed is tori's reaping right toes around 333–367 ms. The requested 140 ms kake interval and the large authored reap generate excessive speed. The quantitative failure must be corrected before claiming human-like movement. The 420 deg/s pelvis number in Ludo is a draft target, not a cap on every other joint; the implementation does not claim to reproduce measured human angular velocity. Likewise, 90% weight on uke's target leg cannot be inferred from bone positions, and no such load measurement is claimed.

The solver fixed up to 47.5 cm of authored hand error after reachable body placement, without root motion or bone-length changes. Analytic IK did the substantial hand placement; the existing hands-only descent started close to the solution and did not create the kuzushi, entry, reap, airborne path, torso fall, support-foot schedule or slap. Those required authored keys. Final tori crouches deeply to retain the sleeve; this is another reason to withhold a judoka verdict. Back contact is inferred from low pelvis/chest centres and upward chest normal, not verified mesh-to-mat contact.

## Time and cost

Work occurred on 2026-10-10, approximately 21:57–22:13 Asia/Nicosia: **about 0.27 wall-clock hours**, including intake, authoring, gates, import recovery, measurement and delivery preparation. There was no independent stopwatch per activity; the following are approximate allocations reconstructed from tool/file timestamps, not fabricated precision or an animator timesheet:

| Step | Approximate wall-clock hours |
|---|---:|
| Intake, read-only research, RED witness | 0.05 |
| Pure keys | 0.025 |
| Player / real-rig mounting | 0.025 |
| Grips / solver integration | 0.035 |
| Three tuning rounds and gates | 0.075 |
| CSV, metrics, report and scoped cleanup/delivery | 0.06 |
| Total | 0.27 |

Honest reproducibility number: **0.27 h for this failed proof**, not 0.27 h for an acceptable production throw. A simple 13× extrapolation is 3.51 h for 13 equally unfinished proofs; reuse may change that, and it excludes visual review, acceptable dynamics, revision, cloth and runtime admission. **Hours per acceptable throw remain unmeasured.** Ludo's 8.5 h / $312 per clip and $4,368 total remain an estimate; this run neither validates nor replaces them. Paid source/generation cost here: $0. Human cleanup labor was not purchased or timed.

## Stills and remaining proof

The current operator request says never open images/windows/viewers. That takes precedence over the task's permission to use a hidden windowed Godot render, so **zero PNGs were rendered**, and no pixel description is made. Expected destinations, currently absent: `docs/previews/judoproof1/osoto_000ms.png`, `osoto_180ms.png`, `osoto_280ms.png`, `osoto_420ms.png`, `osoto_550ms.png`, `osoto_650ms.png`.

The capture tool is ready for a later authorized hidden-GPU run via `Tools/godot_hidden.ps1 --path Godot --script tools/judo_throw_stills.gd --resolution 1920x1080 -- as_game`; Claude must inspect any framing-approved outputs. Until that run and the dynamics correction, **the requested end-to-end visual proof is incomplete**. No game binding or simulation script was changed. Task ownership overrides the general HANDOFF/mailbox delivery rule: neither HANDOFF.md nor AgentComms was written.
