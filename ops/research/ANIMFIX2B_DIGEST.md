# ANIMFIX2B / S226 - source-bent stop; route to ANIMSOURCE

**The active guard is bent on its own source rig. No production repair was
made.** Task step 2 explicitly says to stop and report in this case. Claude
should route the source to ANIMSOURCE. No clamp, hand offset, recipe change,
mirror/native/foot-bake change, new switch, or import edit was made.

At source time .600, `assets/anim/c223/c237/active_guard.glb` has wrist lines
**Left 19.059479 deg / Right 19.318591 deg**. MH08 retarget output reproduces
the reported **21.160148 deg rear wrist**. The production pose layer leaves
the guard unchanged (the binding has no pose-layer entries).

The source bend does **not** exonerate retargeting: the uppercut rear wrist
still exceeds the matched source by **4.292060 deg on MH08** and **3.301543 deg
on MH09**, above the allowed 3 deg. These are unresolved, not repaired around
the task's stop condition.

## Baseline, instrument and red evidence

Clean `codex/animfix2b`, fetched/rebased to `9763fb9f`; never master. The
diagnostic and red evidence were committed and pushed as `cb48bbc7`.
Task/toolkit, CLAUDE sections 4-7, visual gate and traps were read. Brief and
inbox were checked; historical tasks did not replace the explicit ANIMFIX2B
assignment. The relevant prior ANIMFIX2 ruling message was acknowledged.

`tests/guard_wrist_line_test.gd` measures
`angle(LowerArm -> Hand, Hand -> MiddleProximal)` from posed segment
directions, not Euler/quaternion components. Source FK composes the source
file's complete hierarchy, including `LeftHandMiddle1`/`RightHandMiddle1`.
It does not carry source motion onto an MH rest pose. Target readback uses
the existing retarget construction and decodes intermediate rests on a
duplicate for FK, before foot bake. It then reads the production pose layer.
Independent geometric controls exercise a straight line and a 30-degree bend.

Both source clocks are printed: literal .600, and the source clock matching
game .600 after strike warp. Guard is .600 in both. Uppercut game .600 maps
to **.784633325** source seconds; comparing only raw .600 would compare
different poses.

| Source file | Source time | Left deg | Right deg |
|---|---:|---:|---:|
| `assets/anim/c223/c237/active_guard.glb` | .600 | 19.059479 | 19.318591 |
| `assets/anim/c223/mixamo_pipeline_a/Boxing_Lead_Hand_Uppercut.glb` | .600 raw | 23.391263 | 39.120650 |
| same uppercut | .784633325, matching game .600 | 15.063456 | 37.434658 |

Every row below is game .600, left/right degrees:

| Body | Guard retarget | Guard after layer | Uppercut retarget | Uppercut after layer |
|---|---|---|---|---|
| MH02 | 17.327918 / 19.735910 | 17.327918 / 19.735910 | 14.802246 / 40.186644 | 14.802214 / 40.186644 |
| MH05 | 18.196580 / 16.822177 | 18.196580 / 16.822177 | 13.238618 / 35.526273 | 13.238633 / 35.526239 |
| MH08 | 17.525862 / 21.160148 | 17.525862 / 21.160148 | 15.483590 / 41.726718 | 15.483643 / 41.726660 |
| MH09 | 16.970677 / 19.817135 | 16.970677 / 19.817135 | 14.737431 / 40.736201 | 14.737381 / 40.736163 |

The guard source-relative limits are 22.059479 / 22.318591 deg, and all four
target guards pass those allowances. That does not make the source or the
visible guard straight. Separate absolute 10-degree source/shipped-guard
witnesses keep this defect red; these are not substituted for the task's
relative retarget contract. The uppercut rear limit is 40.434658 deg.

Exact red lines from the final focused run:

```text
WRIST_GATE source guard Left value=19.059479 limit=10.000000 FAIL
WRIST_GATE source guard Right value=19.318591 limit=10.000000 FAIL
WRIST_GATE shipped guard MH08 Right value=21.160148 limit=10.000000 FAIL
WRIST_GATE MH08 idle Right value=21.160148 limit=22.318591 OK
WRIST_GATE MH08 boxing_lead_uppercut Right value=41.726718 limit=40.434658 FAIL
WRIST_GATE MH09 boxing_lead_uppercut Right value=40.736201 limit=40.434658 FAIL
GUARD_WRIST_LINE failures=12
SUITE total=1 fails=1
```

The 12 failures are two source guard witnesses, eight target guard witnesses,
and two uppercut source-relative failures. Full
[log](../docs/previews/animfix2b/red.txt),
[20 stage rows](../docs/previews/animfix2b/red.json), and
[runner summary](../docs/previews/animfix2b/focused_summary.txt).

A read-only code reviewer found no critical/important issue and independently
computed the guard directly from GLB JSON transforms, without Godot or the
retarget helpers: **19.0594849963 / 19.3186047997 deg**. The source has no
animated arm/wrist channels: those wrist-relative transforms are authored
into the source rig. This independently validates the source-bent stop.

## Verification and scope

- Final parse: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- Final focused runner: `--jobs 1 --only guard_wrist_line`, expected red as
  above; no SCRIPT ERROR in the final test log.
- Every engine launch, including parse/test runner children, used the existing
  `E:/FightCamp/tmp/animfix2/hidden_gate.cmd`: watchdog first, then
  `godot_hidden.ps1`, GUI engine on a hidden desktop. AMBER launches were
  allowed; one engine job at a time. Sandbox escalation succeeded.
- No production scripts or assets changed. The new-test-only tier applies:
  anatomical/generator parity and affected-system subset were not rerun.
  No green production/regression claim is made.
- **No after-change sole gate or before/after comparison:** task step 2 stops
  before a retarget repair and step 3. No historical sole result is relabelled
  as a new run. Feet remain outside this task's repair scope.
- No full suite. `clip_status.py new-anims` reports 0 new animations.
- General rules set aside: task branch overrides the generic master-push
  instruction; task serial-worker allowance overrides the older no-serial
  rule; task tiered gates override the generic skill full-suite advice.
  Diagnostic/research handoff writes no HANDOFF block; Claude owns status.

## Next action

Claude: route the two named source files and their measured wrist lines to
ANIMSOURCE. Preserve this diagnostic. After source repair, rerun the three
stages, then reassess the unresolved MH08/MH09 uppercut retarget residuals.
The visual item remains OPEN for Claude/operator review; this document must
not be treated as a completion or acceptance marker.

## Opened baseline stills and review delivery

Posted all four to S226 with `review_add.py`, batch
`E:/FightCamp/review/2026-10-15_1909_animfix2b_source_bent_stop_unchanged_mh0`
([review board](http://127.0.0.1:8787/review)). These are current, unchanged
production witnesses, not an after-repair set. All four were opened with the
file image tool and returned `STILL_FRAMING OK ... shot=broadcast err=0`.
The camera contains both men head-to-feet. No SendUserFile tool was available;
the review board and repository PNG links are the delivery surfaces.

Capture through the existing hidden/watchdog wrapper:

```text
--path Godot --script tools/animfix2_pose_room.gd --rendering-driver opengl3
--resolution 1280x720 --quit-after 240 -- as_game bench1=1 pose_log=1
seed=930093 discipline=boxing out=res://docs/previews/animfix2b/baseline
```

The harness pauses simulation at frame 30 and seeks Miller's mounted clip;
each still follows four render frames. This is controlled playback, not a
natural exchange/contact witness. No deterministic movie-clock before/after
comparison is claimed. The output viewport is 1920x1080 despite the launch
resolution argument. Renderer warnings and shutdown ObjectDB/resource/
PagedAllocator leak messages appear in the [capture log](../docs/previews/animfix2b/capture.txt);
the final capture has no SCRIPT ERROR. Framing success alone is not a visual
acceptance or a clean-engine claim.

Each caption follows gap / noses / wrists / feet / defect / bodies:

- [Guard .600](../docs/previews/animfix2b/baseline/guard.png): clear step apart,
  no contact; Vance across/slightly down and Miller at Vance; glove axes offset
  from forearms, far wrist foreshortened; wide stance, Miller's rear foot
  pointed with heel raised; bent guard remains; MH09 red / MH08 purple.
- [Catch .100](../docs/previews/animfix2b/baseline/catch_between.png): clear step
  apart; both across/slightly down; rear glove near Miller's face, lead glove
  offset from forearm; wide stance and rolled/pointed rear foot; unchanged
  production catch, no wrist repair; MH09 red / MH08 purple.
- [Catch .275](../docs/previews/animfix2b/baseline/catch_hold.png): clear step
  apart; both at opponent, Miller slightly down; rear glove beside face,
  lead wrist bent and far wrist foreshortened; wide stance with raised/rolled
  rear foot; existing ANIMFIX2 placement visible, source defect unresolved;
  MH09 red / MH08 purple.
- [Uppercut .600](../docs/previews/animfix2b/baseline/uppercut_dip.png): clear
  separation, no contact; Vance across and Miller toward floor; near glove
  bends off forearm, rear glove partly hidden by head; rear leg stretches
  wide with pointed foot/raised heel; bent wrist and deep dip remain;
  MH09 red / MH08 purple.

Stills cannot establish sliding or fully resolve the occluded wrist's angle;
the source/retarget numbers above establish the measured defect. Full six-line
captions are in [review_captions.json](../docs/previews/animfix2b/review_captions.json).
The toolkit's C209 `shadowboxing_take1_raw/sheet.jpg` was also inspected: its
own heading says REJECTED SOURCE, and it depicts a rendered solo boxer. It
was not treated as accepted real-motion or anatomical truth.

Two setup attempts are excluded from review evidence: omission of `pose_log=1`
left `_pose_live` null, produced SCRIPT ERROR/framing FAIL and saved no still;
then omission of `bench1=1` selected the default cast/standing camera. The latter
images were inspected and moved to `E:/FightCamp/tmp/animfix2b/rejected_default_cast`,
not posted or committed. Their command logs are retained as
[missing pose log](../docs/previews/animfix2b/capture_missing_pose_log.txt) and
[default cast](../docs/previews/animfix2b/capture_default_cast.txt). The corrected
third run above supplies all delivered stills. No capture code was changed.
