# C198 standing motion

## Pass 1 — 2026-09-25 — bounded thigh clearance, defaults held

**A small improvement, not reel-quality acceptance.** Seed 92012 MMA, grappler
175 cm versus striker 185 cm. All five requested switches ON. No clips bought,
no generator credits used. Only the standing `contact_stop` path changed.

### Video and visual review

- [BEFORE, 60 seconds, 854x480, 30 fps](_captures/watch_loop/c198_pass1_before.mp4)
- [AFTER, same seed/options/camera](_captures/watch_loop/c198_pass1.mp4)

Opened and decoded both MP4s, inspected sequences across the minute and denser
10 fps contact/recovery sequences. This is sampled-frame visual review, not a
claim of uninterrupted real-time playback. The first `shot=tight` recording
cropped the upper bodies and was discarded. The committed recordings derive
from `record_room.gd`, with C191's fixed full-body camera and walkout/hit camera/
camera follow disabled. Godot actually wrote 1920x1080 despite `--resolution`;
the committed MP4s are explicitly downscaled to 854x480.

The three worst visible problems before editing:

1. The kicking upper leg crosses the receiver's chest/head (around 16 seconds;
   further high-kick/recovery problems around 44 and 57 seconds).
2. Strikes and reactions imply contact that the picture does not show. The
   hook around 9 seconds also exposes a facing/target-placement problem.
3. Crowded guards and recovery joins still merge limbs and bodies. The
   standing exchanges do not read as a coordinated two-person performance.

### Change and measurements

Added four bounded iterations for upper-leg versus head/torso capsule overlap,
after the existing root correction and before the final hand contact repair.
The additional pair displacement is limited to 30 cm, fading to zero in the
existing landed-kick contact envelope. No animation, strike, clock, event,
target region, hand visibility, or ground/grip path is removed or changed.

The unmodified C191 instrument is emitted with `readable_onset` and
`human_speed_tempo` added. 3,600 frames at 60 Hz; video is separately rendered
at 30 Hz, so use the video times as approximate rather than frame-exact census
coordinates. [Measurements, including rejected trials](C198_PASS1_MEASUREMENTS.json).

| Metric | All-on BEFORE | Retained AFTER (`c198_trial2`) |
| --- | ---: | ---: |
| Frames above 3 cm overlap | 381 / 3,600 | 372 / 3,600 |
| Share | 10.5833% | 10.3333% |
| Worst overlap | 28.8963 cm | 26.1201 cm |
| Longest continuous run | 0.4833 s | 0.4333 s |
| Landed contact samples | 14 | 14 |
| Hand samples within 2 cm | 8 / 10 | 8 / 10 |
| Two remaining hand gaps | 35.7607 / 49.6951 cm | 35.7607 / 49.5839 cm |

Every sampled landed surface gap is unchanged or closer (tolerance 0.01 mm).
The ten hand samples include adjacent samples of slowed combination clips;
they are **not ten unique punches**. These measurements do not establish
contact for unsampled strikes or for every blow in a multi-strike clip.

All 3,600 `(animation A, animation B, clock A, clock B)` tuples are identical
before/after, as is the engine event-log hash. Thus the overlap improvement
does not come from cutting presentation volume or retiming attacks. The old
C191 14.56% figure used a different switch combination; it is not this pass's
baseline.

Rejected experiments:

- Unfaded thigh correction: 9.25% overlap and 20.08 cm worst, but kicked
  contacts missed farther (up to approximately 9 cm). Rejected despite the
  better overlap number.
- Doubling the punch root-warp cap: one hand gap improved to 17.8 cm, but the
  other worsened and overlap rose to 11.67%. Reverted; original cap retained.

### Default decisions

No default flipped. These are acceptance decisions for this pass's combined
picture, not isolated causal claims about each switch; individual switch A/B
recordings remain outstanding.

| Switch | Before → after | Reason to withhold default ON |
| --- | --- | --- |
| `strikes_play_whole` | OFF → OFF | Whole takes still intersect bodies and miss intended targets. |
| `reactions_play_whole` | OFF → OFF | Receiver performance does not yet establish believable contact with the retained strikes. |
| `contact_stop` | OFF → OFF | Improvement is small; 26.1 cm worst overlap and two distant hand contacts remain. |
| `readable_onset` | OFF → OFF | More readable wind-up does not resolve facing/contact; isolated timing A/B not yet accepted. |
| `human_speed_tempo` | OFF → OFF | Slower clips still expose intersections and target mismatches; isolated tempo A/B not yet accepted. |

The all-OFF baseline and final replay have **3,600/3,600 identical pose hashes**
and identical event hashes. Full hash evidence is in the measurements JSON.

### WHAT IS STILL WRONG / next pass

- The worst overlap remains 26.1 cm. Upper-arm/guard contacts and the protected
  landed-kick window still need work. Removing the contact protection is not an
  acceptable solution: the rejected experiment demonstrates why.
- Two landed-hand samples remain far outside the requested 1–2 cm. Several
  kick/knee samples also miss the named head target by tens of centimetres.
  This pass does **not** complete target-height selection/warping.
- Investigate target ownership before enlarging root warps: `_present_entry`
  assigns `_whole_roots` before `present_live` reports whether the new actor
  clip actually started. A refused beat could relabel an existing take.
  This is a code-review hypothesis, not a measured diagnosis in this pass.
- Also examine the differing effector rules: `whole_contact_world` chooses
  largest travel while `strike_contact` chooses the farthest +Z hand. Establish
  the correct contact hand per take before claiming all punches land.
- Need individual switch A/Bs and a continuous motion review against the
  vendor reel. No claim that a web listing alone establishes reel parity.

### Research and reproduction

Reviewed the existing take-four recording and the named C191/recording/hash
tools before editing. The vendor's [Hand to Hand set page](https://www.ramsterzanimations.com/store-buy/p/hand-to-hand-set-fbx-only)
describes separate punches, kicks, reactions and root-motion-ready clips; it
does not supply gameplay integration. This supports preserving authored
motion while fixing placement, but does not prove our retargeting is correct.

1. Parse `Godot/tools/c198_prepare_census.gd`, then run it headless. It emits
   `.godot/c198/census.gd` and `.godot/c198/record.gd` without editing the source
   instruments. Parse both emitted files before running them.
2. Census: `--headless --path Godot --script .godot/c198/census.gd -- stop=true out=<label>`.
3. Recorder: use `Tools/godot_hidden.ps1 --path Godot --script .godot/c198/record.gd`
   with `--rendering-method gl_compatibility --rendering-driver opengl3`,
   `--write-movie .godot/c198/<label>.avi --fixed-fps 30 --resolution 854x480
   --quit-after 1800 -- seed=92012 discipline=mma strikes_play_whole=1
   reactions_play_whole=1 contact_stop=1 readable_onset=1 human_speed_tempo=1`.
4. Encode H.264 with `scale=854:480`, CRF 22, yuv420p; retain 30 fps.
5. OFF proof: original `tools/c191_clip_census.gd -- whole=false stop=false out=<label>`
   on both revisions, comparing all pose hashes and the event hash.

Task-specific scope superseded the general master rebase/brief and HANDOFF
workflow: stayed on `codex/c198-standing-motion`; no HANDOFF/status/archive or
prior digest read, no HANDOFF edit, no full suite.

### Validation

- Parse gate on the edited room script and the C198 harness: `CHECK total=2 fails=0`.
  The original and generated census/recorder scripts also passed before execution.
- Required focused runner:
  `python Godot/tools/run_tests.py --only fight_strike,fight_reaction,fight_contact,fight_room,fight_separation`
  returned **`SUITE total=13 fails=0`**. No full suite run.
- Comparative assertions passed: overlap count and maximum decrease; same
  contact sample count; every sampled landed gap unchanged or closer; identical
  clip/clock sequence and engine log; all-OFF poses/events byte-identical.
- Both delivered videos verified as 854x480, 30 fps, 60 seconds.
- Census/recording shutdown reports the same ObjectDB leak warning in baseline
  and candidate; no runtime script error was reported. This pass does not fix
  shutdown ownership.
- `agent_comms.py send --help` in this checkout accepts `--topic`, not the
  brief's `--task`; use `--topic C198` for the requested one-line message.
- Importing this initially clean worktree regenerated 1,821 tracked `.import`
  sidecars plus untracked UID/image files. Automatic approval review rejected
  bulk cleanup as insufficiently proven safe for shared work. They remain
  unstaged; only the six explicit C198 deliverables are committed.


## Pass 2 ? 2026-09-25 ? full-pair framing opt-in; upper-arm clearance

**Framing gate passed, not reel-quality acceptance.** Seed 92012 MMA, grappler
175 cm versus striker 185 cm; our existing fighter meshes, all five motion
switches ON. No clips bought, credits spent, Blender MCP, or HANDOFF access.
Claude explicitly extended the camera-follow scope and authorized hidden Godot
recording. The task-specific branch/scope rules superseded the generic master
rebase/brief and HANDOFF workflow.

### Videos ? opened and visually reviewed

- [BEFORE, live establishing/follow camera](_captures/watch_loop/c198_pass2_before.mp4)
- [AFTER, same seed and motion switches, camera_keep_pair ON](_captures/watch_loop/c198_pass2.mp4)

Both are **854x480, 30 fps, 60 seconds**. Rendered through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1`.
Opened/decoded both MP4s: whole-minute sampled-frame review, then 5 fps detail
around the crowded kick at 15?17 seconds and cage approach at 33?35 seconds.
Reviewed the final AFTER across all 60 seconds at 1 fps. This is sampled-frame
visual review plus an every-render-frame geometric check, not a claim of
uninterrupted real-time playback.

MD5 (different, verified from final files):

- BEFORE: `49953cb931128193484544d08b5cbf03`
- AFTER: `b5167ac98f9b2d2c69b675e0756d8dd0`

The BEFORE visibly crops heads and upper bodies. The AFTER retains both full
bodies, including near the fence, but pulling back exposes foreground cage
mesh/posts and makes the fighters smaller. Neither meshes nor strikes were
hidden to obtain the metric.

### Camera change and framing measurement

Added `camera_keep_pair`, **default OFF**, separate from the existing
`camera_follow` option (whose default is unchanged). Existing follow aims at
last frame's root midpoint before final poses/contact corrections. The new
opt-in fits the final posed pair after those writers and hit-camera placement.
It also fits walkout/finished-bout updates. A tree-readiness guard prevents
startup calls before the camera has a viewport.

The fit preserves the chosen shot's direction, uses cached positive-weight
skinned-vertex influence envelopes, accounts for viewport aspect and FOV, and
reserves eight percent on each edge. Pull-out is immediate; return inward is
eased over 1.2 seconds. Only the camera moves; no pose/clock/engine writes.

| 60-second framing check | Both boxes fully inside | Percent |
| --- | ---: | ---: |
| Pass 1 fixed recorder camera, headless remeasurement | 1,434 / 1,800 | 79.6667% |
| Pass 2 BEFORE live follow camera, headless | 0 / 1,800 | 0% |
| Pass 2 AFTER, headless | 1,800 / 1,800 | **100%** |
| Pass 2 AFTER, actual final render frames | 1,800 / 1,800 | **100%** |

The boxes conservatively contain the posed skinned mesh, including limbs;
they are not pixel-tight silhouettes. An outside envelope can overstate
cropping, but an inside envelope contains its skinned vertices. Projection is
checked before each actual rendered frame. This measures frame containment,
**not fence occlusion**. Pass 1's digest failed to report its framing defect;
the new BEFORE deliberately uses the live camera instead of its fixed override.

### Overlap and contact

Extended the existing bounded thigh/core clearance to upper-arm/core pairs,
preserving its displacement cap, landed-kick protection, and final hand repair.
[Full measurements and reproduction sources](C198_PASS2_MEASUREMENTS.json).
The overlap census is 3,600 frames at 60 Hz; video is separately rendered at
30 Hz, so individual contact ticks are not asserted to be video-frame exact.

| Metric | Before | After |
| --- | ---: | ---: |
| Frames above 3 cm overlap | 372 / 3,600 | 322 / 3,600 |
| Share | 10.3333% | **8.9444%** |
| Worst overlap | 26.1201 cm | 26.1201 cm |
| Landed contact samples | 14 | 14 |
| Hand samples within 2 cm | 8 / 10 | 8 / 10 |
| Two remaining hand gaps | 35.76 / 49.58 cm | 35.76 / 49.58 cm |

One previously good hand sample changes from 0.09 cm short to 0.97 cm short;
another reaches 0.43 cm penetration. Both remain within the requested 2 cm.
These are contact samples, not unique punches; some are adjacent samples of
slowed combination clips. No contact claim is made for unsampled blows.

All 3,600 animation/clock tuples and engine events are identical before/after.
Camera ON versus the upper-arm candidate with camera OFF: **3,600/3,600 poses
identical**. All five motion options OFF and new camera option OFF versus the
pre-pass baseline: **3,600/3,600 poses identical**, engine hash identical.

Exploratory target-ownership and punch-effector changes produced no measured
change for this seed and were reverted; FightStagePlayer.gd is unchanged.

### Per-switch default decisions

No default flipped. These decisions concern readiness of the reviewed all-on
picture, not isolated causal A/B claims; five isolated switch videos remain
future work.

| Switch | Before ? after | Decision from this pass |
| --- | --- | --- |
| strikes_play_whole | OFF ? OFF | Whole kicks/guard joins still intersect; target mismatches persist. |
| reactions_play_whole | OFF ? OFF | Visible reaction/contact pairing is still unconvincing; no isolated acceptance. |
| contact_stop | OFF ? OFF | Less overlap, but 26.1 cm worst penetration and two large hand misses remain. |
| readable_onset | OFF ? OFF | Wind-up readability does not establish placement quality; isolated A/B outstanding. |
| human_speed_tempo | OFF ? OFF | Slower playback still exposes crowding and disconnected contact; isolated A/B outstanding. |
| camera_keep_pair | new, OFF | Containment passes; held OFF as directed, with cage obstruction and excessive width still visible. |

### WHAT IS STILL WRONG / next pass

1. **Cage occlusion and composition.** Around 33?41 seconds, the foreground
   mesh/post passes across the fighters. The pair stays inside the frame, but
   that does not mean every body part is unobstructed. The conservative fit can
   be too wide and follows changes in posed bounds; it is not a polished
   broadcast camera. No arena geometry was hidden.
2. **Crowded strikes and recovery joins.** The 15?17-second kick/guard sequence
   still merges limbs/bodies; worst overlap did not improve. The new clearance
   reduces frequency, not the worst event.
3. **Target/contact mismatch.** The two large hand gaps and several kick/knee
   target-height misses remain. This pass does not finish clip picking/warping
   or establish RamsterZ reel parity.

### Validation and reproduction

- Parse gates passed before census/tests/recordings, including final room and
  generated recorder. Final AFTER log has no script/runtime errors; the known
  3,024-instance ObjectDB shutdown warning remains in both arms.
- Required focused suite against frozen final script: **SUITE total=13 fails=0** (`--jobs 4`). No full suite.
- The five permitted delivery paths contain the room, digest, measurements and
  two MP4s only. Probe/recorder/census source strings are embedded under
  `reproduction` in the measurements JSON so they remain reproducible without
  committing extra tool paths. Existing unrelated import/UID churn is unstaged.
- Extract those strings as `framing.gd`, `record_pass2.gd`, `census_final.gd`
  under `Godot/.godot/c198`; recover `pass2_before.gd` from this pass commit's
  parent version of FightWorldLiveScreen.gd. Parse every extracted `.gd` first.
- Headless framing: `--script .godot/c198/framing.gd -- camera=live fit=true out=framing`.
  BEFORE adds `fit=false room_script=res://.godot/c198/pass2_before.gd`.
- Hidden recorder: `--path Godot --script .godot/c198/record_pass2.gd
  --rendering-method gl_compatibility --rendering-driver opengl3
  --write-movie .godot/c198/output.avi --fixed-fps 30 --resolution 854x480
  --quit-after 1800 -- seed=92012 discipline=mma fit=true out=render_framing`.
  BEFORE adds `fit=false room_script=res://.godot/c198/pass2_before.gd`.
  Recorder uses actual room/fighter assets; encode to H.264 at 854x480, CRF 22,
  yuv420p, 30 fps. Godot's source AVI is 1920x1080 despite the requested size.
- Census: `--headless --path Godot --script .godot/c198/census_final.gd -- stop=true out=final`.


## Pass 3 - 2026-09-25 (S73): contact reach, low-kick clearance, camera obstruction

**Delivered as an OFF-by-default iteration, not v1 visual acceptance.** The two
large hand misses now reach the target; worst overlap improves slightly, but
frequency regresses. The camera no longer looks through the foreground cage
from outside the contest footprint, but the resulting high angle and remaining
boundary intersections are not broadcast quality.

### Watch and population

Reviewed the before footage first, then decoded the final MP4s for headless
visual inspection: 1 fps across each entire minute and 10 fps around MMA
3-4.5, 8-9.5 and 43.5-45 seconds. This is sampled frame review, not a claim of
having watched every displayed frame at normal speed.

- MMA: [before](_captures/watch_loop/c198_pass3_before.mp4) /
  [after](_captures/watch_loop/c198_pass3.mp4), seed 92012, grappler 175 cm
  versus striker 185 cm, f05/f06 distinct men in MMA gloves under MMA rules.
- Boxing: [before](_captures/watch_loop/c198_pass3_boxing_before.mp4) /
  [after](_captures/watch_loop/c198_pass3_boxing.mp4), seed 92012, distinct
  f01/f02 men scaled to the bout's 174/182 cm athletes, red/blue boxing gloves
  under boxing rules. Explicit mesh overrides avoid the default bare-hand f09.
- Every file is 60 seconds, 1,800 frames, 854x480, 30 fps. These are our actual
  room/fighters, rendered through `Tools/godot_hidden.ps1`. No Blender or paid
  generation was used. The numerical contact census below is MMA only.

### What changed

The raw whole-clip hand prediction was more than an arm length away from the
posed hand in the two bad hooks. With `contact_stop` enabled, such takes now
anchor remaining authored travel on the pre-contact pose. A cached pose keeps
last frame's correction out of the next frame's placement calculation. The
exceptional root-warp budget is 0.8 m; normal punches remain 0.4 m and kicks
0.12 m. Anatomically bounded pelvis/leg adjustment and torso lean finish the
reach before the existing hand IK. Arm bones, clip clocks and engine events
are unchanged. Procedural pelvis and bone adjustments unwind next frame.

For leg-target kicks only, the receiver's upper body rotates away from the
non-striking thigh, bounded to 45 degrees, with a rollback if the named foot's
leg-target depth worsens. Broader torso deflection trials were rejected because
they worsened other kick gaps. Head/body kick matching is still unfinished.

Behind `camera_keep_pair`, camera X/Z stays inset within the contest footprint;
it rises enough to retain the conservative posed skin boxes and eases back down.
No fence, ropes, hands or body geometry is hidden. This removes the old external
foreground-viewing problem, but is not a complete occlusion solution: fighters
can still crowd the boundary, and the high view loses contact readability.

Research: read the C191/Q154 findings located through `RESEARCH_INDEX.md` and
reviewed [Epic's Motion Warping documentation](https://dev.epicgames.com/documentation/unreal-engine/motion-warping-in-unreal-engine).
The target-window concept informed the investigation; this is a custom Godot
implementation, not an imported Unreal solver.

### Measurements beside the footage

| Seed 92012 MMA, 60 s / 3,600 census frames | Before | After |
| --- | ---: | ---: |
| Hand samples within 2 cm | 8/10 | 10/10 |
| Rear-hook gap at tick 236 | 35.76 cm | 0.0036 cm |
| Lead-hook gap at tick 535 | 49.58 cm | below 0.001 cm |
| Frames with >3 cm overlap | 322 (8.9444%) | 355 (9.8611%) |
| Worst overlap | 26.12 cm | 25.26 cm |
| Original worst frame, tick 2687 | 26.12 cm | 12.33 cm |
| Rendered MMA frames containing both complete screen boxes | 1,800/1,800 | 1,800/1,800 |

The frequency regression is **33 frames / 0.9167 percentage points worse**.
Legacy-strike overlap frames rise 33 to 69; whole-strike frames rise 233 to 244;
reaction frames fall 30 to 16. Closing the misses is not an overall overlap win.
The new maximum is the axe-kick sequence at tick 3458 (57.63 s).
All 14 contact samples remain present. Existing knee/body/axe gaps remain
23.25 / 37.41 / 38.40-41.04 cm; none was traded for the lower worst overlap.
All 3,600 animation/clock tuples and the engine-event hash match before/after.

Final boxing framing is also **1,800/1,800 = 100%**. Both final cameras are inside
the contest footprint in 1,800/1,800 rendered frames. That geometric fact is
**not an all-pixel occlusion measurement**: the review still sees boundary
mesh/ropes crossing edge-crowding poses, including MMA around 27 s and boxing
near 38-41 s. The camera is excessively overhead, especially in boxing.

MD5 (before and after differ for each legal population):

| Video | MD5 |
| --- | --- |
| c198_pass3_before.mp4 | b5167ac98f9b2d2c69b675e0756d8dd0 |
| c198_pass3.mp4 | 0c435d6735f75fa0ea64d8336ea17267 |
| c198_pass3_boxing_before.mp4 | e0ced426069dae68088c22f492b27241 |
| c198_pass3_boxing.mp4 | 243107df471ea2e0faffcc77a2da2198 |

### Per-switch default decisions

All remain **OFF -> OFF**, as directed. No isolated switch acceptance is claimed.

| Switch | Reason it is not ready |
| --- | --- |
| strikes_play_whole | Kick height/target misses and poor standing joins remain. |
| reactions_play_whole | Hook reactions still collapse the body into implausible crouches. |
| contact_stop | Two misses fixed, but overlap frequency worsens and a 25.3 cm collision remains. |
| readable_onset | No isolated visual acceptance; the all-on picture remains unconvincing. |
| human_speed_tempo | Slower presentation exposes poor joins; no isolated acceptance. |
| camera_keep_pair | 100% containment, but high angle and boundary obstruction remain. |

### WHAT IS STILL WRONG / next pass

1. **Standing poses are not believable.** Around both repaired hooks the men
   crouch/kneel sharply; hand contact now measures correctly but the complete
   exchange still does not read like a clean standing hook. Fix the source-pose
   join/reaction ownership rather than adding more end-effector correction.
2. **Body overlap and kick targets remain poor.** Frequency worsened, the axe
   kick still reaches 25.3 cm penetration, and four kick/knee contact samples
   miss by 23-41 cm. Start the next pass with these windows and the new crowding
   caused by getting the hands into range. Do not remove exchanges to lower it.
3. **Camera composition is unresolved.** Near-overhead framing makes glove
   depth hard to judge; mesh/ropes can still cross a fighter at the boundary.
   The next camera needs a better interior azimuth and body-aware boundary
   clearance, not merely more height. This pass does not establish reel parity.

### Gates and reproduction

- Parse passed before runtime work; final owned scripts: `CHECK total=2 fails=0`.
- Required focused suite: **SUITE total=13 fails=0**, `--jobs 4`. No full suite.
- All features OFF versus the isolated pre-pass scripts: **3,600/3,600 pose
  hashes byte-identical**, engine-event hash identical. Ordered pose-hash digest
  is `9ed5d23a15b1ee92dad51e1b6c452e9fc567c26f3e189bbe02d359e1329923d1` in both arms.
- Final renders have no script errors. The existing 3,024-instance ObjectDB
  shutdown warning occurs in before and after.
- [C198_PASS3_MEASUREMENTS.json](C198_PASS3_MEASUREMENTS.json) holds contacts,
  every census frame depth, pose hashes, framing counts, video hashes and exact
  probe/recorder source strings. Extract those to `Godot/tools/c198_pass3_*.gd`,
  parse them first, then use the commands under `reproduction`.
- Baseline scripts are from `0620cdb7`. The scratch baseline player is renamed
  to avoid a duplicate global class; its room preload/types point at that copy.
  MMA BEFORE rerender is byte-identical to the delivered Pass 2 AFTER MP4.
- Task scope overrides the general HANDOFF/full-suite rules. No ground/grip
  paths, FightPoseSolver, HANDOFF, defaults or unrelated imports were edited.


## Pass 4 - 2026-09-25 (S74): frequency regression removed; career witness

**Ready for integration review as an opt-in change; not visual-quality acceptance.**
Rebased on master `1566c12db49b2693c6f6add95fde2fcbb435d7a2` without conflicts.
PASS 3 after rebase is `36d6d0450e27817ba4bf7db3f77e89df41a0b947`.
Only the standing contact-stop path changed. Defaults remain OFF. No ground/grip,
FightRealtime, HANDOFF, status/archive, SMPL/SMPL-X/BUDDI, or paid-generation work.
The explicit task/worktree scope superseded the general brief/HANDOFF workflow.

### Change and measured result

The root clearance constraint previously covered leg/leg but excluded the feet.
Include leg/foot and foot/foot in that same bounded solve, preserving the landed-kick
fade. This addresses the most frequent remaining capsule pair without changing
strikes, clocks, event volume, or the overlap instrument. Extend the existing
receiver torso deflection to thigh/shin interference for all foot kicks, retaining
its rotation bound and rollback whenever the named foot-to-target depth worsens.
The retained PASS 3 hook reach repair is unchanged.

Same seed 92012, distinct f05/f06 men, grappler 175 cm versus striker 185 cm, MMA
rules/gloves; all five motion options ON. Each arm has 3,600 samples at 60 Hz,
no preroll, no walkout/hit camera. The same fixed camera is used in every arm:
position (3.4, 8, 10), target (0, 1, 0), FOV 48, follow/keep-pair disabled.
This isolates motion from the camera implementation that changed across passes.

| Metric | Master | PASS 3 | PASS 4 |
| --- | ---: | ---: | ---: |
| Frames with >3 cm overlap | 381/3600 | 355/3600 | **224/3600** |
| Share | 10.5833% | 9.8611% | **6.2222%** |
| Worst depth | 28.8963 cm | 25.2611 cm | **24.9859 cm** |
| Landed hand samples within 2 cm | 8/10 | 10/10 | **10/10** |
| All landed contact samples | 14 | 14 | **14** |

Worst-depth improvement over PASS 3 is only **0.2753 cm**; frequency improves by
**131 frames / 3.6389 percentage points**. Both measures improve, but a 25 cm
intersection remains a serious defect. All sampled kick gaps are unchanged or
closer than PASS 3. All 3,600 animation/clock tuples and engine-event hashes match
across all three arms. Samples include adjacent ticks, not 14 unique strikes.
Capsule depth is the existing skin-calibrated approximation, not triangle penetration.

An exploratory thigh-only expansion reduced frequency to 224 but raised the
maximum to 26.1146 cm: rejected. Including the obstructing shin as well produced
the retained result. No clip was removed to obtain the lower count.

### Video and career review

- [Master BEFORE, 60 s](_captures/watch_loop/c198_pass4_before.mp4)
- [PASS 4 AFTER, same diagnostic camera, 60 s](_captures/watch_loop/c198_pass4.mp4)
- [Career booking flow and live boxing bout, 90.633 s](_captures/watch_loop/c198_pass4_career.mp4)

All three are 854x480 at 30 fps. Opened/decoded the final files and inspected both
comparison minutes at one frame per second, plus enlarged 16.0/16.2/57.6-second
pairs; inspected the career fight at five-second intervals. This is sampled-frame
visual review, not uninterrupted playback or a claim that the 60 Hz census ticks
are exact video frames. Both diagnostic videos contain both full posed screen
boxes in **1800/1800 frames (100%)**. The camera is deliberately wide and is not
an improved broadcast composition; foreground fence still obscures bodies near
44 seconds. Nothing is hidden to improve the metric.

Career witness uses the actual supplied `s74/walk12.plan` flow through BEGIN FIGHT,
then 60 seconds at 1X, with an isolated `fightcamp_c198_pass4_walk` test save.
`c198_pass4_career.gd` derives from `s64_career_walk.gd`, uses fixed-frame waits for
movie recording, and enables the five optional motion switches plus keep-pair
before room readiness. It does not change shipped career defaults. The actual
booking is **Nasir Larkin versus Santiago Pereira**, boxing, seed **2288268096**,
distinct f01/f02 rigs in red/blue boxing gloves. `WALK DONE steps=21 failures=0`.
This is a career-context witness, not a second controlled before/after census.

MD5, computed from every final MP4 after encoding (before/after differ):

| File | MD5 |
| --- | --- |
| c198_pass4_before.mp4 | ff526ec1f82c3e8330be71dfdf24ba5d |
| c198_pass4.mp4 | b8cfb6c6983a498adafe25e25006f089 |
| c198_pass4_career.mp4 | 47504b65d21abf219e545c44c2fdbcd0 |

### WHAT IS STILL WRONG

- Deep kick/reaction intersections remain, especially the body-kick window near
  16 seconds and the axe kick near 57.6 seconds. The small worst-depth improvement
  is not a visual cure. Head-target kick/knee misses remain roughly 23-41 cm.
- Hook/reaction joins still crouch or kneel implausibly. Career footage around
  40-45 and 65-70 seconds exposes this clearly. Correct glove reach does not make
  the whole-body action believable.
- The diagnostic camera is too wide for contact judgment; the live career camera
  is too high. Boundary obstruction and presentation polish remain unresolved.
- No per-switch isolated acceptance: strikes/reactions/contact_stop/readable_onset/
  human_speed_tempo and camera_keep_pair remain OFF. No reel-parity claim.

### Gates and reproduction

- Parse gates passed before all runtime runs; final runtime/code tools passed.
- Required focused runner: **SUITE total=13 fails=0**, `--jobs 4`. No full suite.
- Master versus PASS 4 all-OFF: **3600/3600 pose hashes byte-identical**, event hash
  identical. Evidence and all three complete censuses are in
  [C198_PASS4_MEASUREMENTS.json](C198_PASS4_MEASUREMENTS.json).
- Final census and render logs have no SCRIPT ERROR or ERROR lines. Existing FBX
  buffer warnings and ObjectDB shutdown leak warnings remain. Initial post-rebase
  RawAsset class-cache failure was cleared by a headless editor/import refresh;
  it was not counted as a passing test. Initial recordings with an invalid early
  `look_at` call were discarded and replaced by clean renders.
- No game-dev adapter exists in this worktree; followed the task's existing Godot
  census/hidden-recorder workflow. The visual-debugging skill informed controlled
  comparisons and the distinction between measurements and artistic acceptance.

Reproduce the baseline copies from the exact refs above: extract
`scripts/FightStagePlayer.gd` and `scripts/FightWorldLiveScreen.gd` into
`.godot/c198/{master,pass3}_{player,room}.gd`; replace `FightStagePlayer` with
`C198masterPlayer` / `C198pass3Player` and point the renamed room preload at its
scratch player. This avoids duplicate global classes. Parse all copies first.

Census: `--headless --path Godot --script tools/c198_pass4_probe.gd -- stop=true
out=<arm>`; master/PASS 3 add `room_script=res://.godot/c198/<arm>_room.gd`.
OFF proof uses `tools/c191_clip_census.gd -- whole=false stop=false out=<arm>`
with the same baseline-room selection. Read output, not PowerShell's warning exit.

Record via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1
--path Godot --script tools/c198_pass4_record.gd --rendering-method gl_compatibility
--rendering-driver opengl3 --write-movie .godot/c198/<arm>.avi --fixed-fps 30
--resolution 854x480 --quit-after 1800 -- seed=92012 discipline=mma out=<arm>`;
BEFORE adds the master room_script. Encode H.264 CRF 22, scale=854:480, yuv420p.
Career uses the same hidden launcher/movie flags with `tools/c198_pass4_career.gd`,
no quit-after, `plan=res://research/C198_PASS4_CAREER.plan out=res://.godot/c198/career_shots`.
