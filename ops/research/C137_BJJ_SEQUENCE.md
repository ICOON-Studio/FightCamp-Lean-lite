# C137 second run — demonstration delivered, visual result UNFINISHED

2026-09-20. Worktree verified first: `C:/Users/user/AppData/Local/Temp/FightCamp-C134`.
Branch: `codex/c134-bjj-presentation`. Task specifies GPT-6-astra / medium.

**Both f05/f06 fighters perform the sequence together inside FightCamp, and an actual
in-game recording is delivered. The result is NOT visually acceptable. C137 is unfinished.**
The movie is evidence of the remaining defects, not a claim that the four completion
requirements have all passed.

## Play it

Double-click `Godot/tools/c137_demo.cmd`, or run from this worktree:

```powershell
Godot\tools\c137_demo.cmd view=0
```

Views: 0 three-quarter, 1 overhead, 2 opposite side, 3 low side. The launcher uses
`C:\ProgramData\chocolatey\bin\godot.exe`; set `GODOT_EXE` if installed elsewhere.
Requires Godot 4.7.2 and this branch's existing imported assets. The demonstration
exits after one sequence. No Cascadeur, Blender, purchase, or subscription change is needed.

**Recording:** [C137_RECORDING.mp4](C137_RECORDING.mp4), 1920x1080, 30 fps,
167 frames / 5.567 seconds, four simultaneous camera views. Top left: three-quarter;
top right: overhead; bottom left: opposite side; bottom right: low side.
Godot Movie Maker rendered all four inputs from actual `FightWorldLive.tscn` playback.
FFmpeg only scales, tiles and encodes those frames. No AI video, interpolated frames,
cut-away edits, or Blender render is used. Each camera plays the identical deterministic
sequence. The final exit frame repeats the final pose (166 telemetry rows, 167 movie frames).

## What plays

| In-game time | Existing pair | Roles / window |
|---|---|---|
| 0.000–1.667 s | `Paired_FullMount_Takedown_BodyLock_Loop` | f05 Att/top; f06 Vic/bottom; source 0–1.667 s |
| 1.700–3.500 s | `Paired_FullMount_Reversal` | f05 Att; f06 Vic; source 0–1.833 s; the one transition |
| 3.533–5.500 s | `Paired_FullMount_Takedown_BodyLock_End` | f06 Att/top; f05 Vic/bottom; source **0–2 s only** |

The End filename is misleading for this purpose: its existing production binding starts
at 2.333 s and plays a **stand-up**, not a stable ground ending. The demonstration instead
uses its initial stationary ground portion. It adds no second sporting transition.
The start has small motion; the final ground portion is a static hold, not a new idle animation.

The new harness calls the live room's `_play_grapple_film`, consumes existing six-field
`PAIRED_BINDINGS` via `paired_metadata_for`, and seeks both registered clips from ONE
phase clock. It does not put a hold into `FightMoveScript.PAIR_KEYS` and does not change
production bindings. It preserves the existing f05/f06 mount correction and restores
horizontal source hip travel on the transition/ending.

Each film starts from the same pair frame. One common rigid yaw/translation aligns the
next pair against the preceding frame; both bodies receive the same transform. A finite
0.2 s pose blend handles the residual. This removed the original obvious orientation
cuts, but it is not a contact solve. The demonstration is scripted in the actual game
room; it is **not an engine-selected BJJ match**, and it is not enabled in ordinary bouts.

## Recording inspection — rejected

I inspected the delivered MP4 frame by frame across all 167 frames in its three-quarter
view, plus the four-angle views around the joins and reversal. These are frames decoded
from the recording, not separately posed screenshots.

1. **Contact/clipping:** the reversal has visible interpenetration/implausible overlap
   around the hips, thighs and torso during approximately **2.50–2.90 s**, especially
   frames **76–86**. The side views expose the bodies crossing instead of maintaining
   believable connected rolling contact. This is a visual finding; no mesh penetration
   depth is claimed. The mount's close thigh/hip contacts are also not collision-certified.
2. **Abrupt motion:** f05's left-hand landmark travels **0.50051 m in one 1/30 s interval**
   ending at **2.7667 s / frame 83** (equivalent average 15.02 m/s for that interval).
   Its left foot also travels **0.40555 m** in the interval ending at 2.7333 s.
   The corresponding recording visibly whips/flips through the roll. These are measured
   bone displacements, not a fabricated penetration metric or a claim that all fast motion
   is inherently wrong. The motion is not accepted.
3. **Sliding into the ending:** between 3.533 and approximately 3.733 s the join moves the
   f05 and f06 hips **0.13170 m / 0.12820 m** into the new hold. The visible repositioning
   is still wrong even though it is blended rather than a one-frame teleport.
   The unblended landmark RMS mismatch after common rigid alignment is **0.12942 m**;
   the first join's mismatch is only **0.00167 m**.
4. **Stable periods and sync:** measured hip net displacement is **0 m** during the
   first hold and **0 m** after the ending join settles. Both animation clocks differ
   by **0.000 s** across all sampled frames. These facts establish synchronized playback
   and resting poses, **not acceptable contact**.

[C137_MEASUREMENTS.json](C137_MEASUREMENTS.json) contains the clock/landmark measurements
and the delivered MP4 SHA-256. The harness writes reproducible per-frame world landmarks
to `.c134/c137-telemetry-<view>.json`. That scratch directory is not committed.

The C136 native GLBs are present (30 files). A bounded alternative direct-graft trial
rendered badly in this harness (folded/inverted poses and a 1.20 m first-join mismatch).
That trial was discarded; it does not establish that the GLBs themselves are corrupt.
The delivered harness and movie use the existing FBX route throughout.

## Reproduce the recording

From the worktree, run this once per view, sequentially, replacing `view=0` and the AVI
filename with 1, 2 and 3. The harness creates `.c134` for telemetry.

```powershell
& 'C:/ProgramData/chocolatey/bin/godot.exe' --path Godot --script tools/c137_sequence_review.gd --rendering-method gl_compatibility --rendering-driver opengl3 --write-movie ../.c134/c137-view-0.avi --fixed-fps 30 -- view=0
python Godot/tools/c137_review_recording.py
```

The packaging helper requires Python's `imageio_ffmpeg` (already available on this host).
It does not download a tool or use an external service. Source AVIs remain in `.c134/`.
Recordings completed with exit 0. Host certificate/cache warnings and ObjectDB exit leaks
were emitted; there were no script errors in the final captures.

## Gates and scope

- Parse: `CHECK total=1 fails=0`, for the only touched `.gd`, `tools/c137_sequence_review.gd`.
- `--only c134`: **SUITE total=5 fails=0**.
- `--only clip`: **SUITE total=9 fails=0**.
- `--only pair`: **SUITE total=7 fails=1**, solely `fight_pair_live_test.gd`, the operator-parked case.
- Full suite was not run. No existing tests were edited or weakened.

Task-specific no-rebase/no-branch-switch and no-HANDOFF rules superseded the general
startup rebase/HANDOFF instructions. `FightRealtime.gd`, production player/binding files,
and other agents' work are untouched. Only the new demonstration, packaging helper,
launcher, report, measurements and actual recording are delivered.

The task's recorded Step 0 GUI limitation was accepted without re-probing: the prior
Codex harness could not target the Cascadeur GUI. It did not block the asset route.
The Cascadeur trial billing EUR 37.66 on 2026-09-27 was not touched.

**Remaining work:** repair/author paired contact through the roll and a matching ending
on the actual f05/f06 bodies, then record and visually inspect again. Passing gates does
not resolve that. Any choice to adopt a new authoring pipeline, spend money or change a
subscription remains an operator decision; none was made here.
