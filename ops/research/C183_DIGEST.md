# C183 - closed guard, overhook and head control

2026-09-24. Branch `codex/c183-closed-guard`. Worked alone; gpt-6-astra,
medium. Authored one candidate in Cascadeur and accepted it against C183's
seven-row <=30% ceiling and direct review of the rendered sheet.

## Scope and declaration

The user's startup/branch instructions supersede AGENTS.md brief/inbox and
C171's old no-fetch/standing-queue instructions. C183 explicitly permits the
ONE ClosedGuard HOLD_GRIPS entry, superseding C171's stage-player prohibition.
No HANDOFF, CURRENT_STATUS, HANDOFF_ARCHIVE or other digest was opened; read
own C170/C182 digests. The G84 read inadvertently included adjacent sections
as well as requested section 2. No solver/retarget/live-screen/binding changes.

Declared bjj_guard contacts BEFORE applying or exporting any animation:
A is bottom, owner of closed guard; crossed ankles behind B's lumbar, knees
around waist, left arm over B's right mid upper arm, right hand behind the
head/neck. B kneels and contests posture with both hands on A's hip region.
The probe measures joint-centre preservation; it cannot establish skin contact.

## Authoring and reproducibility

`python Tools/cascadeur/build_closed_guard_c183.py <scratch> --apply`
loads the existing paired native scene, derives original controllers from
c172_closed_guard/RIG.json, keys 121 frames at 30 fps, exports separate animated
GLBs and strips only the Vic namespace. Does not write joints or mesh vertices.
The clip is a four-second loop with a five-degree posture contest, no punches.
Initial local reach assertions caught impossible arm targets before any apply;
raised the bottom shoulder/crunch and hip-post target, then applied once.
Cascadeur returned true for timeline/write and exported both GLBs successfully.

Overhook target is authored at 0.45 along shoulder-to-elbow with a surface
offset and an outside/above elbow pole. This is artistic judgement, not measured
biomechanics. The head-control wrist is offset 5 cm sideways/up/back from neck.
Feet cross laterally behind the top hips, opposite foot rolls forming the lock.

Only ClosedGuard HOLD_GRIPS changed: retained same-body LeftFoot->RightFoot;
A LeftHand->B RightUpperArm; A RightHand->B Neck; both B hands->A Hips.
No thresholds or other hold rows changed.

## Fresh live-key ON / OFF evidence

Both probes use `bjj_guard --live-key`; OFF adds `--grip-solve-off`.
241 samples each, exact admitted files, four-second span.

| Contact | Source mean m | OFF target mean m | OFF worst % | ON target mean m | ON worst % |
|---|---:|---:|---:|---:|---:|
| Ankle lock | 0.072339958 | 0.134711090 | 86.226113 | 0.072339953 | 0.000450 |
| Left knee wrap | 0.372215789 | 0.365417206 | 1.827571 | 0.411916020 | 10.667435 |
| Right knee wrap | 0.365902638 | 0.356653061 | 2.528856 | 0.356653061 | 2.528856 |
| Left overhook | 0.105995679 | 0.118504992 | 13.038964 | 0.105995644 | 0.000354 |
| Right head/neck cup | 0.083609722 | 0.095209741 | 16.302939 | 0.083610044 | 0.038333 |
| Top left hip post | 0.176830946 | 0.182772001 | 5.116685 | 0.176830962 | 0.000189 |
| Top right hip post | 0.176790927 | 0.182613753 | 5.042209 | 0.176790931 | 0.000158 |

ON failures=0, worst 10.667435%; OFF failures=1, worst 86.226113%.
The near-zero solved rows are BY CONSTRUCTION, not independent pose evidence.
OFF still exposes substantial ankle loss; admission relies on the live solve.
Solver report: 5 grips, 13 unreachable frame/grip reports, maximum residual
0.00010855163418 m. These reports are disclosed despite the passing sampled
ceiling; they are not zero. Head-cup peak is 0.038333%, not exactly zero.

## Opened visual evidence

Ran every windowed render through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1`.
`RENDER total=1 fails=0`; `SHEET total=1 fails=0`, all 24 tiles populated.
Opened the assembled sheet AND full-size side/low frames directly.

The pose reads as closed guard: bottom knees flank the waist, ankles visibly
cross BEHIND the top man's lumbar, bottom left arm wraps over his upper arm,
and the other hand reaches behind his neck while top posts at the hips.
The bottom maintains an elevated crunch and top a forward-inclined kneeling
posture, with modest motion. Preview fighters wear boxing gloves: a finger-level
occiput cup cannot be verified from this mesh. Joint-centre preservation and
these views do not establish collision-free skin or floor support throughout.

![Opened four-angle sheet](../docs/previews/c183_closed_guard_sheet.png)
![Crossed ankles behind lumbar and head control](../docs/previews/c183_closed_guard_side.png)
![Overhook view](../docs/previews/c183_closed_guard_overhook.png)

## Gates and controls

- Parse before execution: CHECK total=2 fails=0, both changed .gd files.
- Exact requested focused gate: SUITE total=7 fails=0.
- No full suite; no TitleHonours error, so no import retry required.
- Unchanged clinch control: printed worst 11%, below 15%.
- Side-control chest row: 14.781754%, below historical 14.8173%; current probe
  also includes a head row at 28.968852%, all current rows pass. Its maximum is
  a different contact than the historical chest number, not an authored change.
- Historical RamsterZ 0.302639 / 0.304671 was not independently remeasured;
  its assets, bindings, solver and all other HOLD_GRIPS rows remain unchanged.
  Focused paired regression gates passed; no claim of a fresh exact reading.
- Git has pre-existing untracked evidence/import metadata. Left it untouched;
  only explicit C183 files and C183 comms messages are committed.
- Logs and Cascadeur readback retained locally under `.c183-evidence/attempt1/`.

Admitted SHA256:
- Att: `07400e2adf6a9b0b06786e29da2b01437787fe29114ebf7269a53735ae1f5c78`
- Vic: `52ac4628a3d56e4e6ebbf1ae7b3c9abe741698129e5ad0a5c5777d101f4573d7`
