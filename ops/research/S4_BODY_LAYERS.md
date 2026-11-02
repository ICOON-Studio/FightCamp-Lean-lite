# S4 (3) — THE LEGS KEEP WALKING WHILE THE ARMS WORK

Step 3 of the S4e order the operator greenlit on 2026-09-15. Two things that were SHIPPED AND UNCALLED get called:
`FightBodyLayers` (R125) and `FightCameraRig` (U58). No engine file is touched and no fight changes.

## POPULATION

One seeded three-round BOXING bout from `FightWorldLiveScreen`'s own booking — seed 94301. **Two male welterweights,
legal for the ruleset and NOT identical** (operator rules 2026-09-12): **A** is f01, an out-boxer (reach, speed),
66.0 kg; **B** is f09, a pressure puncher (power, conditioning), 66.5 kg, differentiated INSIDE boxing by style and
attributes with neither missing a technique the ruleset permits. Catalogue: `assets/data/combat_rulesets.json`, boxing.

The bench checks in the gate use f01 alone and are GEOMETRY — one skeleton against one clip, no matchup and no claim
about fighters.

## THE FIRST DEFECT, MEASURED BEFORE IT WAS CHANGED

Each body has ONE `AnimationPlayer`, so a clip owns the whole skeleton. `FightStagePlayer.walk_at` opened with:

```gdscript
var walking: bool = _walking()
if not walking and current.get_slice("#", 0) != FightStageDirector.ROLE_IDLE:
    return
```

A man whose clip was a punch, a block or a reaction was neither walking nor idling, so **the walk was refused and his
legs held the action clip's footwork** — while `_place_bodies` kept writing him the transform the engine gave him. He
slid. The operator saw it from the other end on 2026-09-12: *"they move their legs but they do not move"*, then
*"they just appear at different place"*.

**S4 (2) made it far worse, which is why this is the next slice.** Before it the engine moved a man 8.7 m in a round
and the slide was centimetres; after it, 134.8 m.

`tools/measure_body_layers.gd`, the shipped room, seed 94301, three rounds:

| | measured OFF | bound |
|---|---|---|
| body-frames | 39,604 | — |
| carried (the engine is moving him fast enough to be given a walk) | 25,226 (63.7%) | — |
| **SLIDE — carried, and no locomotion under him** | **8,423 frames, 21.27% of body-frames, 307.7 m** | **0** |
| the roles he was sliding in | react_head 1869, react_body 1498, hook_lead 1345, jab 1203, cross 1067, hook_rear 652 | — |

**NO STUDY AND NONE IS NEEDED.** This is not a claim about fighters; it is a count of frames in which our picture
contradicts our own engine. The bound is zero and the label is **INTERNAL CONSISTENCY**. And the sliding roles are
punches and reactions with **NOT ONE KICK** in them, so `LEGS_ARE_THE_POINT` refuses none of the frames that matter.

## THE SECOND DEFECT: THE CAMERA WAS AIMED AT THE RING SKIRT

`FightWorldPreview.tscn` carries its camera at `(0, 1.80, 2.60)` with fov 42 — which **is**
`FightCameraRig.SHOTS.establishing`, copied into the scene — and with **no surface offset**, while the rig's own
contract says in as many words: *"Callers MUST pass ArenaRig.surface_y(spec) as surface_y — ring canvas is 1.2700 m"*.

A boxing ring's canvas is 1.27 m off the floor. The shot has therefore been aimed **0.92 m BELOW the floor the fight is
fought on** for as long as the room has existed: the men's feet are at 1.27 and their heads near 3.02, and the camera
was looking at 0.35. Nothing caught it because no test has ever looked through the lens and the operator has seen no
recording at all.

## WHAT CHANGED

**Two switches: `body_layers` (default on) and `camera_shot` (default `establishing`; empty leaves the scene's camera
alone, which is the A/B arm and what every existing test keeps).**

- **`FightBodyLayers` gains a POSE-SPLICE path, and the AnimationTree it already had is NOT what the live room uses.**
  An `AnimationTree` with `active = true` drives the skeleton itself and the `AnimationPlayer` becomes a clip library,
  so `_ap.current_animation` stops describing what is posing the body — and **`FightStagePlayer` reads that property in
  fifteen places**: the foot lock's plant table and frame index, the strike aim, the contact solve, pair detection, the
  retime and the dead blend. Switching the live room to the tree would silently wrong every one of them, in the
  correct-looking, error-free, invisible-to-a-count way this area has already shipped six times. `build()` stays right
  for `FightAnimLabScreen`, which is one body playing one clip with nothing else reading the player.
- So the room **splices poses instead**: the AnimationPlayer stays authoritative, and after it has written the frame the
  bones the lower layer owns are overwritten from the locomotion clip at its own advancing phase. Same partition, same
  `wants_layering` judgement, same deliberate decision that **`Hips` goes with the legs** — hip sway is the foundation
  of a gait and an action clip that seizes the pelvis makes a man whose torso and legs disagree.
- `splice_lower` **returns how many bones it wrote**, and every caller checks it. This is U61's C5 again: a splice that
  matched no track writes nothing, raises nothing and leaves a body indistinguishable from one that was never layered.
- **`_advance_lower` runs immediately after `_ap.advance` and BEFORE the inertializer**, so the one-frame join where
  layering starts or stops is smoothed by machinery that already exists for exactly that.
- **THE FEET BELONG TO WHATEVER IS DRAWING THEM.** While the legs are spliced, the foot lock's plant table and phase are
  the WALK's, not the action's. Reading the action clip there would plant a man's feet off a jab's footwork while his
  legs play a strafe — the slide back in a subtler costume.
- **`FightCameraRig.apply` is called** with the arena's real `surface_y`, found by TYPE rather than by node name.

## THE MEASUREMENT

```
godot --headless --path Godot --script tools/measure_body_layers.gd -- seeds=1 rounds=3 arm=both
```

| | OFF | ON |
|---|---|---|
| body-frames | 39,604 | **39,604** |
| **action beats resolved** | **553** | **553** — the engine does not move |
| carried | 25,226 (63.7%) | **25,226 (63.7%)** |
| **SLIDE** | 8,423 (21.27%), 307.7 m | **0 (0.00%), 0.0 m** |

**553 beats in both arms, and it is the same 553 S4 (2) recorded.** The whole of the lower body was rewired and the
fight underneath is the same fight. That is the switch proven at the engine boundary, and the gate asserts it.

## THE GATE — `Godot/tests/fight_body_layers_live_test.gd`, 25 checks, PASS

| rule | tier | stands on |
|---|---|---|
| S4-3-1 the partition | **GATED** | GEOMETRY. The two layers are disjoint and together cover all 22 bones (9 lower + 13 upper) — a bone in neither layer stops being animated and renders as a limb frozen in the bind pose, reporting nothing. `Hips` with the legs, `Spine` with the action. |
| S4-3-2 the splice IS the walk | **GATED** | With the foot lock and the inertializer off — both write bones after the splice by design, and a tolerance wide enough to absorb them would pass a splice that did nothing — the **HIPS and SHIN hold the walk's own pose at its own phase EXACTLY**, the **SPINE does not**, the hips change frame to frame (a frozen splice is the old bug wearing a number), `current_animation` still names the action, the switch off writes zero bones and puts the shin back on the action clip, and **a man throwing `strike_leg` is not layered either way**. |
| S4-3-3 the camera | **GATED** | The shot rides the canvas (y = 1.80 + 1.27 = 3.070), POINTS at the rig's look-at (dot 1.000000) and lands at 1.620 m — a man's chest. The unoffset shot's 0.92 m error is kept as a number. |
| S4-3-4 the room A/B | **GATED** | Same beats layered and not (40 vs 40 over 900 frames), 575 body-frames really spliced, zero spliced with the switch off, **nobody slides layered and 558 frames slide without** — so the measurement is pointed at something real. |

**One check in this file passed for the wrong reason and was fixed rather than kept.** S4-3-3 first read
`cam.global_transform.basis` on a Camera3D parented to the Window, which returns an IDENTITY basis; the "aim point" it
compared was the camera's own height. It passed, on a number that was not the aim at all — the same
passes-without-testing-anything failure the rest of the file is built to catch.

## WHAT THE RE-BASELINE COST, AND WHOSE EACH RED WAS

`run_tests.py --only fight_stage,fight_world,fight_clip,fight_pair,fight_knockdown,fight_room,fight_body,fight_foot` —
**30 tests, 3 failures, and all three were already failing before this stage**: `fight_pair_live` and
`fight_stage_presenter_contract` are red ON PURPOSE while the jab pair is parked (operator ruling 2026-09-15), and
`fight_stage_realism` fails identically on master. `fight_camera_rig` and `test_engine_input_contract`, the two touched
tests outside that subset, are green.

`fight_stage_realism` now carries its own A/B arm (`layers=off`). Run both ways it returns **the same 7 failures of 13
rules, rule for rule** — R1, R2, R3, R5, R5b, R7, R8 fail in both; R2b, R3b, R4 pass in both. **No gated rule moved from
PASS to FAIL or from FAIL to PASS.** One number moved and it is reported rather than gated:

**R3 `planted_foot_skate`: p95 3.007 → 2.710 m/s (−9.9%), mean 0.614 → 0.622 m/s (flat), over 110,545 → 111,040 planted
frames.** The worst-case skate got meaningfully better and the mean did not move, and **the reason is the finding**: the
dominant skate is not the slide this stage fixed, it is `loc_strafe_right` at 0.75 m/s over 17,886 frames and
`loc_strafe_left` at 0.82 over 9,044 — **frames where the man was already walking**. The strafe clips' own stride
against the engine's lateral speed is a separate slice (OPEN 1). Note also that `react_head` and `react_body` ENTER the
planted-frame population layered (6,414 and 5,430 frames), because a man in a reaction now has feet planted against a
walk at all; they were never counted before.

## THE ANIMATION-TREE QUESTION, ASKED BY THE OPERATOR AND ANSWERED WITH A NUMBER

The operator asked how the declined `AnimationTree` would be addressed. A tree gives exactly one thing the splice does
not — **a blend between two lower clips** — so the honest answer was to measure the join rather than argue the
architecture. `tools/probe_layer_joins.gd`, shipped room, one round:

| hips step, deg/frame | hard cut (as S4 (3) first shipped) | crossfaded |
|---|---|---|
| **join** (the frame the lower clip changed), p50 / p95 / max | **45.316 / 64.419 / 75.897** | **14.560 / 27.717 / 45.253** |
| join p95 as a multiple of the gait's own | **19.20x** | **2.12x** |
| lower-clip changes | 211 in one round, 6.92% of spliced frames | same |

**The splice cut, and it cut hard**: 45 degrees of hips in a single frame, 211 times a round. **The inertializer could
not absorb it because it never saw it** — it watches the PLAYER's clip, and a lower-clip change never reaches the
player. That is a real defect and it was shipped; it is fixed here rather than argued away.

**The fix is not a tree, it is a blend.** `splice_lower_blended` crossfades the outgoing lower clip into the incoming
one over `BLEND_S` — R120's uniform 0.10 s, measured by G57, not a number invented here — and the phase is now CARRIED
across a clip change instead of restarting at zero, so a man turning mid-stride keeps his stride. None of the fifteen
`current_animation` readers is touched, which is the whole reason the tree was declined.

**Two honest notes on the measurement.** (1) The probe's first version counted mid-crossfade frames as "steady",
which measures the same fade twice and makes the gait look worse the better the fade gets; `lower_layer()` now reports
`mix` and the probe keeps three populations. (2) The steady population's p95 reads 3.354 under the hard cut and 13.052
crossfaded, and **that difference is not yet attributed** — restoring the phase reset while keeping the crossfade left
it at 13.233, so the phase carry is not the cause. The comparable number across both arms is the JOIN, whose definition
is identical; the steady discrepancy is OPEN 6 and is a reporting question, not a shipped defect.

## OPEN

1. **THE STRAFE IS WHERE THE SKATE LIVES NOW, AND IT IS NOT THIS STAGE'S.** R3's top contributors are the lateral walks
   themselves. U84 measured `H2H_WalkLeft` at 1.705 m/s and `H2H_WalkRight` at 1.764 native, and the engine's lateral
   speed is whatever the wander produces; the rate cap at 1.0 means a man moving faster than native strafes with his
   feet sliding. **Its own slice**: it is a clip-rate question, not a layering one.
2. **THE BETWEEN-EXCHANGE PHASE STILL PICKS NOTHING**, carried unchanged from S4 (2): the RamsterZ pack has no bounce,
   shuffle or hop among its 90 clips, so `engage`/`reset`/`measure` is bucketed for measurement rather than made to
   choose a clip that does not exist. Buying or authoring a measuring bounce is its own slice.
3. **THE ENGINE STILL HAS NO BODY RADIUS** (S4 (2) OPEN 1, untouched here). `S4-2-1` in
   `tests/fight_room_positions_test.gd` is the live tripwire.
4. **THE OPERATOR HAS SEEN NONE OF THIS.** Seven engine and room stages have landed and `--write-movie` aborts under
   `--headless` in a cloud container (measured 2026-09-15), leaving a 0-byte AVI. **Step 4 is a PC job** and the camera
   fix above is the reason a recording will now frame the fight rather than the ring skirt.
6. **THE STEADY-FRAME p95 MOVED AND IS NOT ATTRIBUTED** (3.354 hard-cut -> 13.052 crossfaded, with the phase
   carry ruled out at 13.233). Only the JOIN population is comparable across the two arms. Cheap to settle with
   a switch on the crossfade itself; not worth a stage.
5. **AUTHORING MORE PAIRS STAYS GATED ON STEP 4's VERDICT.** The pair method is UNVALIDATED, not disproved, and the
   withdrawn 2026-09-14 verdict must never be cited as validation.

## Re-running it

```
godot --headless --path Godot --script tests/fight_body_layers_live_test.gd
godot --headless --path Godot --script tools/measure_body_layers.gd -- seeds=1 rounds=3 arm=both
godot --headless --path Godot --script tests/fight_stage_realism_test.gd -- layers=off
```
