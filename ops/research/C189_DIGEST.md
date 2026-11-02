# C189 — whole vendor clips on our fighter, Round 2

2026-09-24. Codex, gpt-6-astra / medium. Branch `codex/c189-control-arm`.
Production baseline: checkpoint `f4aac113`. No production scripts edited.

## Answer and ranking

**The strongest demonstrated cause is the live room's walking/body-layer interaction.**
Turning off **only `body_layers`** on seed 92012 drops peak ankle speed from
**52.784/75.191 to 9.575/9.260 m/s** for fighters A/B. Ankle frames above the
conservative 25 m/s diagnostic bound fall **6/5 -> 0/0**. Both runs contain the
same 14 scheduled events, techniques, contacts and delivery times.

1. **Locomotion plus the lower-body splice: first.** The write-point observer
   catches `body_layer` moving a foot **1.25536 m within one frame**, live
   **3.73333 s**, and hips **0.53545 m** at 3.86667 s. The final visible ankle
   reaches 75.19070 m/s at 3.75 s. D visibly exchanges foot positions, crosses
   knees and crouches/rises abruptly during the hook/reaction. Disabling only
   foot lock, strike aim or contact solving leaves the spikes. Disabling engine
   positions also removes them, but selects the older gap driver: it does not
   isolate engine root translation from its interaction with walking.
2. **Entry seeks and interrupted clip endings: second.** On the SAME f01 poses,
   A peaks at 16.598 m/s wrist; entry-only at 19.248; adding the witnessed cross
   interruption raises it to **24.136**. Within-clip peak remains **16.598** in
   all three: the added peak is a join, not faster captured punching. C visibly
   jumps more sharply at joins. Removing unkeyed reaction lead-in is beneficial;
   the production bindings already do it.
3. **Rig proportions / retarget: smaller in this population.** B is a real owned
   source mannequin. Its wrist/ankle/hip peaks are **19.467/6.567/3.192**, versus
   A's **16.598/6.615/3.139**. A follows B's extension, recoil and reaction shapes
   without D's leg jumps. Low-ankle drift proxy: .0808 m/s B versus .0878 A.
   This does not certify every rig or isolate solver error from limb proportions.
4. **Attack/reaction pairing: unranked, not exonerated.** These six source files
   are solo performances; there is no matched authored two-person performance
   of this sequence. D's independent reactions and close/crossing bodies are
   visible, but their causal cost cannot be separated from locomotion/spacing
   with these sources. Calling pairing fourth-smallest would be invented.

**Tempo adds zero in the observed cases.** All non-locomotion actor entries in
our 60 s probe use rate 1.0; `C_entry` and `C_tempo` have identical parsed frame
arrays. The live entry path calls `present_live` without `set_tempo`. Walk rates
are variable and are separate from strike tempo.

Fix priority: trace/fix lower-layer pose and hip carry around live 3.73–3.87 s
before buying clips or globally slowing hands. Layer-off is a diagnostic, not
an acceptable shipping fix: its skating proxy gets worse.

## Delivered and opened

- [2x2 MP4](./_captures/c189_control_arm.mp4): **1920x1080, 60 fps, 12.5 s,
  3,003,545 bytes**, H.264, silent. Rows A/B and C/D; below 50 MB.
- [Sheet](../docs/previews/c189_control_arm.png): 1920x1390 PNG with figures.
- [Evidence archive](../tools/c189_evidence.json.gz): original source audit,
  live entries, per-frame joint positions and speeds, rules, all arms/controls,
  and reductions. Scratch AVIs are not committed.
- [Harness](../tools/c189_clip_whole.gd), [observer](../tools/c189_live_observer.gd),
  [reducer / capture runner](../tools/c189_control_arm.py).

The MP4 was opened in the associated Windows player. The PNG was opened and
inspected with the image tool; Windows has no default PNG association here.
The final MP4 was also decoded and visually inspected at 1 Hz across its full
length, plus a 30 Hz strip around D's worst ankle transition. A/B share the jab
extension and recoil, then long stationary reaction lead-ins. C repeats the
shortened sequence and travels backward with its stagger. D shows frequent
foot exchanges and body/leg crossings. The sheet uses live 3.75 s for D, the
worst B-ankle witness. No frame-by-frame analysis of the YouTube reel is claimed.

## What was controlled

Same fixed camera in all panels: position `(2.4,3.6,4.0)`, target `(0,2.2,0)`,
FOV 39; same boxing arena and shell lighting. No follow, hit-cam or walkout.
D uses normal recording-mode defaults otherwise, seed 92012, with one second
of warm-up: film covers **live 1.0–13.5 s**, excluding startup spawn placement.
D's fighters are f01, 1.74 m / 66 kg, and f09, 1.82 m / 66.5 kg.
A/C use the same f01 mount/scale. B uses the pack's native
`Android_SkeletalMesh.fbx`, verified **1 skinned mesh / 68 bones**; A != B.

A/C use production silhouette corrections and retargeting at production **30 Hz**,
sampled at **60 Hz**. No FightStagePlayer, engine, walk layer, inertializer, IK,
foot lock or hand limiter poses A/B/C. All source horizontal pelvis/root travel
is retained, including non-returning stagger travel. B composes the source
poses onto its own skeleton without our retarget corrections. Initial source
XZ is removed per clip, then endpoint travel accumulates across joins: no
harness-created root reset/teleport. No rotation crossfade is invented.
Independent-performance pose joins remain and their speeds are counted.

The six rendered clips, in order (H2H_ prefix, .FBX suffix): **JabInPlace,
StraightPunchInPlace, HitReaction01, HookPunch_InPlace, StaggerSmall01,
HitReaction04**. Whole duration **12.5 s**. The original six-source audit below
is preserved; the rendered experiment replaces uppercut/HitReaction02 with
StaggerSmall01/HitReaction04 because all rendered clips have live timing witnesses.
A/B play once. C repeats a **4.62667 s** cycle to fill 12.5 s, ending partway
through cycle three. C has more joins; counts are exposure counts, not a matched
number of punches.

C changes only the playback clock on A's poses: binding trim, actual seek/rate,
and observed interruption duration. Witness rule: greatest observed seek per
source, then earliest occurrence in the 60 s probe. This deliberately exposes
entry damage; it is not an average/random sample. Live mirroring, blending,
layers and root suppression are not added to C. HitReaction04's live witness
is mirrored; C borrows only that witness's clock, retaining A's original pose.

A/B isolates rig+retarget; A/C isolates clock policy. **C->D changes multiple
systems and is not a causal one-factor contrast.** The requested four panels
cannot alone isolate it. Extra `D_no_*` runs each change ONE configuration
option against D; `C_entry` and `C_tempo` separate clock factors. No source
modifications were needed. No matched paired-performance control is available
for this selected solo sequence, so pairing remains explicitly unresolved.

## Arm numbers

World metres/second, finite differences at 60 Hz. Each row: 751 poses / 750
intervals. Wrist/ankle = maximum of the two joints; hips = pelvis. Boundary
speeds included. Counts use a .001 m/s tolerance to exclude floating-point
noise such as 12.00004 from a 12 m/s cap.

| Arm/body | Peak wrist | Peak ankle | Peak hips | Wrist >12 frames | Ankle >25 frames | Low-ankle path m | Low-ankle mean m/s |
|---|---:|---:|---:|---:|---:|---:|---:|
| A / f01 whole | 16.598 | 6.615 | 3.139 | 6 | 0 | 1.786 | .0878 |
| B / source mannequin | 19.467 | 6.567 | 3.192 | 8 | 0 | 1.659 | .0808 |
| C / f01 room clocks | 24.136 | 10.045 | 8.367 | 27 | 0 | 4.485 | .3285 |
| D / f01 | 15.579 | 52.784 | 27.136 | 2 | 6 | 1.311 | .3120 |
| D / f09 | 16.474 | 75.191 | 33.060 | 1 | 5 | .564 | .5373 |

The live hand limiter masks much of the wrist discontinuity; low wrist counts
do not make D smooth. Velocity is not acceleration or a universal quality score.

**Foot bound = 25 m/s, a generous diagnostic threshold, not a biological maximum
or proposed animation clamp.** Vagner et al., *Sports* 11(8):141 (2023),
[doi:10.3390/sports11080141](https://doi.org/10.3390/sports11080141),
[Table 2 / open full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC10459763/),
report elite high roundhouse kicks into air at **16.29 +/- 2.16 m/s**, one mean
result / 7 participants. Mean + 3 SD = 22.77; rounded upward to 25 for a
conservative flag. This is an authored bound grounded in measured human motion,
not a population limit. Foot markers and our ankle origins differ; these
controls are punches/reactions, not maximum-effort kicks.

Skating is a **low-ankle proxy**, not validated contact: both endpoints within
2.5 cm of that foot's minimum observed Y, vertical speed <=.15 m/s; integrate
horizontal travel. Clip-boundary intervals are excluded because contact cannot
be assumed across performances. Paths sum both feet; mean divides by their
summed eligible time. Minima/eligible windows vary by arm, so this is not a
force-plate or identical-contact-mask comparison.

## Fractions / actual timing

A/B whole-file fraction **1.000 for all six**, including unkeyed lead-in.
C table applies to each complete cycle; final repetition is censored by the
12.5 s film. Keyed retained uses the room binding window BEFORE seek.

| Source | Whole s | C source entry s | C played s | Whole fraction | Keyed retained | Witness live s / side |
|---|---:|---:|---:|---:|---:|---|
| JabInPlace | .833333 | .100000 | .733333 | .8800 | .8800 | 11.800 / b |
| StraightPunchInPlace | .833333 | 0 | .600000 | .7200 | .7203 | 21.0167 / b |
| HitReaction01 | 3.033333 | 2.470000 | .560000 | .1846 | 1.0000 | 21.300 / a |
| HookPunch_InPlace | 1.000000 | .166667 | .833333 | .8333 | .8333 | 3.5167 / b |
| StaggerSmall01 | 1.000000 | 0 | 1.000000 | 1.0000 | 1.0000 | 1.250 / a |
| HitReaction04 | 5.800000 | 4.900000 | .900000 | .1552 | 1.0000 | 3.5833 / a |

The cross is interrupted; the other selected witness segments reach their
bound ends. Natural completion = last sampled clock plus one interval reaches
the end, avoiding falsely calling every clip cut one frame early. Binding
rounding exists: HitReaction01's actual first key is 2.466667, not 2.470000.

D non-loop episodes, with sampled source-clock coverage. Natural endpoints can
be up to one frame beyond the final sampled pose; fractions below are sampled
coverage, not claims that natural clips were interrupted.

| Live start s | Body / take | Sampled bound fraction | Whole-file interpretation |
|---:|---|---:|---|
| 1.0167 | b / jab | .9804 | .816667/.833333; natural finish |
| 1.2500 | a / react_body | .9833 | .983333/1; natural finish |
| 3.2500 | b / hook_lead | .2667 | interrupted/re-entered at 3.5167 |
| 3.5167 | b / hook_lead | .8167 | source .166667..983333; remaining take finishes |
| 3.5833 | a / react_head#3_lead | .9815 | .883333/5.8 = .1523; trimmed reaction |
| 8.4333 | a / hook_lead | .9833 | natural finish |
| 8.7667 | b / react_head#3_lead | .9815 | same trimmed reaction |
| 11.4000 | b / boxing_one_two, jab file | .4800 | interrupted at 11.8 |
| 11.8000 | a / react_head#2 | .9960 | .833333/4.866667 = .1712 |
| 11.8000 | b / boxing_one_two_hook, jab file | .8600 | starts at .1; remaining take finishes |
| 13.1000 | b / block | .9596 | natural finish; outside six controls |

Idle/locomotion loops and clocks are in the archive. D is a real fight and
therefore includes clips outside the solo playlist. Source identities come
from the actual playing take and binding variant, not only the beat request.

## Matched one-factor supplements

| Single option changed from D | Peak ankle A/B | Peak hips A/B | Ankle >25 frames A/B |
|---|---:|---:|---:|
| none | 52.784 / 75.191 | 27.136 / 33.060 | 6 / 5 |
| body_layers=false | 9.575 / 9.260 | 4.707 / 4.098 | 0 / 0 |
| engine_positions=false | 5.574 / 6.672 | 3.365 / 3.564 | 0 / 0 |
| foot_lock=false | 52.784 / 75.191 | 27.136 / 33.060 | 6 / 5 |
| strike_aim=false | 52.784 / 75.191 | 27.136 / 31.033 | 6 / 5 |
| contact_solve=false | 53.915 / 75.258 | 28.331 / 30.510 | 6 / 5 |

Layer-off low-ankle mean speed is **.5332/.5910 m/s**, versus D's .3120/.5373.
It removes explosive pose changes while leaving/worsening sliding. Foot-lock-off
worsens the proxy to .7186/.9315 without removing the spikes.

| f01 timing policy | Peak wrist / ankle / hips m/s | Wrist >12 frames |
|---|---:|---:|
| A whole | 16.598 / 6.615 / 3.139 | 6 |
| Trim + seek, C_entry | 19.248 / 8.859 / 5.658 | 24 |
| Above + actual tempo, C_tempo | identical frame arrays | 24 |
| Above + interruption, C | 24.136 / 10.045 / 8.367 | 27 |

## Original source baseline — preserved from f4aac113

Native source skeleton, whole files, 60 Hz, no clip-to-clip joins.

| Clip (H2H_ prefix, .FBX suffix) | Whole s | First key s | Peak wrist | Peak ankle | Peak pelvis | Wrist >12 frames |
|---|---:|---:|---:|---:|---:|---:|
| JabInPlace | .8333 | 0 | 18.1506 | 5.2333 | 1.9823 | 1 |
| StraightPunchInPlace | .8333 | 0 | 19.4666 | 2.8392 | 1.0972 | 2 |
| HitReaction01 | 3.0333 | 2.4667 | 4.1061 | .6859 | 2.2154 | 0 |
| HookPunch_InPlace | 1.0000 | 0 | 18.6296 | 5.4933 | 3.1917 | 5 |
| LeadingUppercut_InPlace | 1.0000 | 0 | 13.1769 | 5.5666 | 3.2437 | 2 |
| HitReaction02 | 4.0000 | 3.0667 | 5.3817 | 1.1708 | 2.1340 | 0 |

**Vendor punches peak at 13.18–19.47 m/s at the wrist. A 12 m/s hand clamp clips
real captured motion.** Exceedance alone does not establish retarget damage.
HitReaction01/02 have **2.4667/3.0667 s leading unkeyed time**: file-frame-zero
playback makes them seconds late. Live bindings already trim it; whole A/B
intentionally expose lead-in.

Original baseline: 10.7000 s, 648 samples including endpoints, 642 intervals,
10 wrist exceedances. Leading unkeyed time 5.5333 s / 51.71%. First-key statistic
uses tracks with at least two keys, not perceptual onset. Round-2 bake at 30 Hz
versus this original 60 Hz audit is explicit; no baseline numbers were replaced.

## Gates / reproduction / scope

Parse gate on both new .gd files: **CHECK total=2 fails=0 autoload_refs=0
autoload_warnings=0**. All final captures/measurements exited 0, no SCRIPT ERROR.
Live runs emitted shutdown ObjectDB leak warnings (3024 headless / 3026 movie);
no leak-free claim. No suite, per task's new-tool gate. Initial import completed
in Round 1. Python reduction, packing, ffmpeg decode and encoding succeeded.
Entry/tempo frame identity and D/layer-off event-stream identity were checked.
A separate headless D baseline reproduced the filmed D frame arrays AND entries
exactly, validating the rendering/headless comparison used for the ablations.

After project import, with Pillow and imageio-ffmpeg installed:

```powershell
python Godot/tools/c189_control_arm.py --mode capture
```

The runner performs source audit, 60 s probe, four hidden windowed captures,
headless one-switch supplements, reduction, MP4/sheet and archive. All windowed
Godot runs use `Tools/godot_hidden.ps1`. `--mode rules`, `--mode arms`,
`--mode media`, `--mode archive` rebuild individual parts from scratch evidence.
The committed archive retains numbers when `.godot/c189` is absent.

Explicit Round-2 read permission resolves the earlier scope question. The user's
checkpoint/branch instruction supersedes general startup rebase: production
was not rebased mid-experiment. Task no-HANDOFF supersedes the general block rule.
Brief/inbox emitted unrelated assignments; none changed this task. Generated
import metadata is excluded. Only C189 tools/evidence, MP4, sheet and digest
are staged. Round-1 source mail: e0069519085d. Round-2 results are sent per part
to Claude under C189 after pushing.
