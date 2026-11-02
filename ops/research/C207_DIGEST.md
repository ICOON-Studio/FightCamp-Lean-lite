# C207 — Live walkout in the owned arena

The long fight-night intro now plays a five-second live SubViewport shot before
the tape and bell. The booked fighter comes from the same `career_mesh` selector
and stature as the live fight, in his or her existing fight kit. No walkout still
is loaded. Name, record line, stakes plate and skip controls retain their previous
layout. Short form, headless, missing input/assets and unsupported surfaces omit
the walkout. The shot owns its world and never advances fight simulation or RNG.

The camera starts in front at a three-quarter angle and tracks across the floor,
then arcs toward profile to reveal the lit ring and fitted steps. The fighter
remains unhooded with the face visible. This is an authored camera in the Marpa
arena, not a recreation of the rejected back-facing tunnel composition.

## Clip and physical placement

The RamsterZ `H2H_WalkForward.FBX` audition visibly retained raised gloves and a
guarded shuffle. Used ONE Kimodo / ardy-core relaxed walk instead: seed 207,
seven-second source, job `00642fb4-41f7-4240-abea-0a9e90cf7f47`, **0.1 credit**
actual, booked in `Tools/higgsfield/spend.json`. Exact prompt and receipt live
under `Godot/assets/anim/c207/`. No other generation ran.

The add-on's cskel27 rest and motion export as GLB and use the existing
`FightClipRetarget` silhouette correction and hip-carry pipeline. Exploratory
FBX output exposed the wrong skeleton-local units/axis and was rejected.

Measured scene facts: west `SeatEntrance` spans X -13.956 to -12.214 m before
the hall floor lift; the west barricade is at X -11.76 to -11.66 m. The shot
splits that barricade into two instances to open a two-metre gate. The owned
stairs are fitted independently to the actual ring/cage deck and apron edge.
These changes are local to the shot; the arena source is unchanged.

The final boxing sample traverses 6.835 m from the floor-side entrance mouth,
ending 0.55 m before the first stair's mesh bound. An earlier endpoint brought
the forward toe too close to the riser; visual review caught it and it was moved
back before the final recording. The source window is 0.2–6.591667 s, sampled
over five screen seconds. Shorter bodies use a nearer start at the same gate
when their available planted strides cannot cover the full aisle.

Root travel is integrated from the supporting foot at 120 Hz, rather than a
constant-speed translation applied independently of the walk. At 30 Hz, 151
poses, the final sample measures:

| Metric | Result |
| --- | ---: |
| Mean horizontal root speed | 1.383014 m/s |
| Sustained authored foot/toe contact samples | 251 |
| Mean horizontal speed over all those contacts | 0.013012 m/s |
| Contact p95 | 0.043939 m/s |
| Contact maximum | 0.500203 m/s |
| Mean tracked support-point speed | 0.000368 m/s |
| Tracked support p95 | 0.000422 m/s |
| Endpoint X error | 3.93 mm |

The maximum is a 16.67 mm displacement over one video frame during a support
transition. Do not quote the almost-zero tracked-support number as zero slip
across every authored contact: foot roll and double-support residuals remain.
These are the retargeted rig's foot/toe landmarks, not a skinned-sole collision
certificate. Raw results: `previews/c207/measurement.json`.

## Recording and review

- [Full intro MP4](../docs/previews/c207/walkout.mp4): 1920×1080, H.264/AAC,
  30 fps, 435 frames, 14.5 seconds including tape, bell and dissolves.
- [Entrance, 0.6 s](../docs/previews/c207/entrance.png)
- [Aisle, 2.5 s](../docs/previews/c207/aisle.png)
- [Steps, 4.9 s](../docs/previews/c207/steps.png)

Decoded the final MP4, opened all three final stills and a 20-frame sheet at
4 fps across the walkout, and checked the bell frame. This is sampled-frame
visual review. The face and kit remain legible; the camera travels with the
fighter and reveals the steps; the overlays keep their original placements.
No hooded back silhouette or tunnel-to-light composition appears.

Limits visible in the recording: the owned hall's seats are empty; this task
adds no animated crowd geometry. The existing crowd audio call is retained.
The recorded body is Tripo. The live room's optional `skin=cc` switch is also
honoured when its local export exists, but that export is absent in this
worktree, so CC skin appearance was not visually verified. No packaged release
was made; distribution still needs the existing raw-asset packaging path.

## Validation and delivery

- Parse gate: **3 scripts, 0 failures**.
- Required gate: `python Godot/tools/run_tests.py --only fight_night,setpiece,smoke,venue_art --jobs 1`
  → **SUITE total=6 fails=0** on the final functional revision.
- Graphical capture-harness checks: **6 cases, 0 failures**: short form,
  missing input, Space, Enter, Escape, click; completion emits once and frees
  the intro/viewport. Headless: **5 cases, 0 failures**; mouse hit-testing is
  tested in the graphical run, where a surface exists.
- Initial suite result was 6/1 because this worktree lacked imported title/home
  textures; the first recording also lacked the bell texture cache. Restored
  those three exact `.ctex` cache files from the main checkout. No source or
  tests were weakened. Final recording has no script/resource errors.
- No full suite: task's tiered focused gate applies. No HANDOFF/CURRENT_STATUS/
  archive read or edit: C207's explicit prohibition overrides the general
  AGENTS handoff rule. User's explicit C207 branch/task selection replaces the
  generic automatic task discovery/rebase startup.

Reproduce visual capture with the task's `Tools/godot_hidden.ps1` command and
`--quit-after 540`. Harness modes after `--`: `measure`, `verify`, `audition`,
`probe`. The source-generation helper preserves its terminal receipt and will
not submit another take when rerun. The initial automatic approval rejection
was resolved by supplying the task's explicit one-take/five-credit authorization.
