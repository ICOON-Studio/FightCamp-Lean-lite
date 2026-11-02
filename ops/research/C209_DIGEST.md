# C209 — stopped at the drill gate; one skipping candidate, no finished station clips

**The requested three finished clips were not achieved.** Six generated takes
cost **0.6 credits**: exactly two per drill. Heavy bag and shadowboxing are
rejected. One short skipping cycle is preserved as a **candidate needing
cleanup**, not certified training. No fight clip has been dressed up as a bag
drill, and no source has been wired into the gym floor.

![Reviewed outcomes](../docs/previews/c209/contact_sheet.jpg)

## Observed result

- **Bag take 1:** advances through and past the fixed bag while punching. Later
  punches target empty space. A moving bag or root cancellation would conceal
  the failure rather than establish a bag drill.
- **Bag take 2:** a short four-punch sequence, then hands drop, the body walks
  around/away and turns its back. No repeatable burst/reset/circle drill. Stopped
  after the second take; no loop was authored from the punching fragment.
- **Shadowboxing take 1:** a brief punching sequence followed by a long idle
  tail; insufficient slips and steps for the requested continuous drill.
- **Shadowboxing take 2:** recognizable defensive slips and steps, but no clear
  punching combinations and substantial wandering. Stopped after two takes.
- **Skipping take 1:** recognizable repeated two-foot hops in the active source
  section. A 14-frame cycle is reproducible, but the right toe still moves
  during authored planted samples. No rope was rendered, so rope clearance and
  wrist/rope synchronization remain unverified. The real fighter retains its
  baked boxing gloves and bare feet; this is not finished exercise clothing.
- **Skipping take 2:** greater arm flare and no contact improvement. No third
  try. The first take remains the better candidate.

The reference input was the task's coach-written drill descriptions. No filmed
or purchased reference was acquired. The requested reference-first authoring
step therefore remains unmet, as does final acceptance of the three drills.

## Reproducible measurements

Printed by `Godot/tools/c209_training_audition.gd`, on the real f01 welterweight
rig at 1.78 m. Raw takes are evaluated over 0–7.9 s (the four-second skipping
take over 0–4 s). Their seam figures show why they cannot simply be looped.

| Source/candidate | Max pose seam, degrees | Max world landmark seam, m | Root velocity difference at 30 Hz, m/s | Planted-foot slip p95, m/s |
| --- | ---: | ---: | ---: | ---: |
| Bag 1 raw | 51.562832 | 1.864467 | 0.107721 | 0.274832 |
| Bag 2 raw | 176.029141 | 1.526729 | 0.060738 | 0.248767 |
| Shadowboxing 1 raw | 15.886048 | 0.130546 | 0.012714 | 0.157060 |
| Shadowboxing 2 raw | 96.427071 | 1.456928 | 0.531086 | 0.401123 |
| Skipping 1 raw | 10.903650 | 0.078213 | 0.015101 | 0.128181 |
| Skipping 2 raw | 24.250427 | 0.093454 | 0.018553 | 0.280195 |
| Skipping candidate, reloaded `.res` | 0 | 0 | 0.573998 | 0.184514 |

The candidate's 30 Hz velocity comparison includes hop acceleration over the
two neighboring video intervals. Finer one-sided endpoint measurements print
**0.019163 m/s at 0.5 ms** and **0.004779 m/s at 0.1 ms**. Endpoint poses match;
neighboring 120 Hz keys have explicitly matched cubic tangents. Do not present
the small-step result as a zero measured velocity discontinuity, or omit the
30 Hz result. Source times: 0.966667–1.566667 s, 0.133333 s overlap; playback
starts at source 1.1 s and lasts 0.466667 s. Frames 0–13 repeat, closing key 14;
the baked resource has 120 Hz keys 0–56.

Slip follows C207's measurement definition: horizontal speed of each foot/toe
landmark whose source contact flag persists across both samples. Blended
samples require both contributing flags. This is not a skinned-sole collision
measurement. The candidate has only **10 sustained contact samples**: five
left-toe and five right-toe samples; no sustained heel/foot samples. Left-toe
p95 is **0.000001788 m/s**, right-toe p95 **0.184514 m/s**, also the overall
maximum. That is approximately **6.15 mm per video frame**, explaining the
candidate status. Long idle tails make the raw whole-take percentiles look
better; they are not proof of good active-phase contact.

Root correction integrates a supporting contact at 120 Hz, as C207 did, but
preserves authored jump height. Accumulated horizontal drift is closed during
airborne spans. No automatic lowest-foot grounding is applied to a jump.

### Bag surface distances

The tool prints every automatically detected extension maximum in each bag
take's `measurement.json`. Detection means a local maximum of hand-to-chest
reach above 0.38 m, separated by at least six frames; it is a **candidate peak
detector**, and later walking arm swings can produce false positives. The four
visually identifiable punches in take 2 are:

| Time, s | Hand | Signed glove-proxy to bag gap, m |
| ---: | --- | ---: |
| 1.000000 | Left | +0.071568 |
| 1.566667 | Right | -0.007580 |
| 2.200000 | Left | -0.038659 |
| 2.800000 | Right | +0.020295 |

Positive is separation; negative is penetration. These are tool-measured
distances between a **65 mm sphere at the hand joint** and the rendered
**190 mm radius, 1.2 m high capsule**, centred at (0, 1.35, 0.8) m. The sphere is
an authored proxy, not a measured glove surface. Actual skinned-glove contact
is **UNKNOWN**, not an invented precise value. Take 1's late detected strike
peaks at 3.166667, 3.833333, 4.5 and 5.5 s miss this same fixed surface by
0.808555, 0.603015, 0.913255 and 0.992218 m respectively. Neither take qualifies.

## Assets, video and review

Exact prompts, seeds, source GLBs/NPZs, rest GLBs and completed receipts live in
`assets/anim/c209/<drill>/take<1|2>/`. Seeds are bag 2091/2092, skipping 2093/2094,
shadowboxing 2095/2096. Every job cost 0.1 credit, booked through
`Tools/higgsfield/budget.py`; task ceiling 3 credits. `manifest.json` records
jobs, hashes and finite-accessor/static checks for all **13 GLBs**. Those checks
are not a visual or licensing acceptance claim. The installed game-dev CLI was
not available; the task's explicit C207 Blender/Higgsfield route was used.

Seven MP4s were encoded at 1280×720, 30 fps, decoded, and their contact sheets
opened for sampled-frame visual review: full raw takes at 5 fps, the candidate
at 15 fps across more than two loop boundaries. Every delivered MP4 was decoded
successfully. This is sampled-frame review, not a claim to continuous playback.
The tool renders the saved/reloaded `.res`; the skeleton-only GLB export passed
static inspection but was not independently replayed on the fighter.

| Recording | Decoded review |
| --- | --- |
| [Bag 1, 7.9 s](../docs/previews/c209/heavy_bag_take1_raw.mp4) | [sheet](../docs/previews/c209/heavy_bag_take1_raw/sheet.jpg) |
| [Bag 2, 7.9 s](../docs/previews/c209/heavy_bag_take2_raw.mp4) | [sheet](../docs/previews/c209/heavy_bag_take2_raw/sheet.jpg) |
| [Shadowboxing 1, 7.9 s](../docs/previews/c209/shadowboxing_take1_raw.mp4) | [sheet](../docs/previews/c209/shadowboxing_take1_raw/sheet.jpg) |
| [Shadowboxing 2, 7.9 s](../docs/previews/c209/shadowboxing_take2_raw.mp4) | [sheet](../docs/previews/c209/shadowboxing_take2_raw/sheet.jpg) |
| [Skipping 1 raw, 7.9 s](../docs/previews/c209/skipping_take1_raw.mp4) | [sheet](../docs/previews/c209/skipping_take1_raw/sheet.jpg) |
| [Skipping 2 raw, 4 s](../docs/previews/c209/skipping_take2_raw.mp4) | [sheet](../docs/previews/c209/skipping_take2_raw/sheet.jpg) |
| [Skipping candidate, 13 repeats / 6.067 s](../docs/previews/c209/skipping_take1_loop.mp4) | [sheet](../docs/previews/c209/skipping_take1_loop/sheet.jpg) |

The elevated orthographic camera is fixed at (3.6, 5.2, 6), size 4 m, looking
at (0, 0.85, 0), using C208's elevation direction at a single-station distance.
Greybox lighting and floor are audition fixtures, not final gym art. Only one
fighter body was checked. No bag response, rope, station transitions or room
integration was made. Missing numerical measurements remain UNKNOWN; none is
silently filled from a visual estimate.

## Reproduction and gate

```powershell
python Godot/tools/check_scripts.py Godot/tools/c209_training_audition.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c209_training_audition.gd -- drill=skipping take=1 render
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c209_training_audition.gd -- drill=heavy_bag take=2 raw render
python Godot/assets/anim/c209/package_review.py <ffmpeg-executable>
```

**Parse gate: CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0.** No
suite and no shipped `.gd` edits. Every windowed Godot run used the required
hidden launcher; runs finished well before 03:40 local. C209's explicit branch,
read and delivery rules superseded the general startup rebase/brief and HANDOFF
rules. No HANDOFF, CURRENT_STATUS or archive read/edit. No branch merge.

**Remaining work:** acquire real drill reference; author or capture a fixed-bag
burst/reset/circle cycle and a complete continuous shadowboxing cycle; clean
the skipping candidate's second planted toe and validate hands against a rope.
The two-try generation limit is exhausted for all three. Do not promote any
of these takes to a working station on the strength of a zero pose seam.
