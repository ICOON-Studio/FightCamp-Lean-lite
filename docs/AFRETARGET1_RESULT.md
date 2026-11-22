# AFRETARGET1 - is the knee bend in OUR retarget? No: ActionForge changes the legs, our bake copies the actor

S537, 2026-11-22. Owner: "the animation looks fine on actionforge, the knee twisting is not there". Fight player v2 only
(METHOD S510); no correction layer was added. The owner closes this, not a test.

**The cause, in one sentence.** Our bake is not at fault: it puts the bought file's own legs on our body (within 4 degrees
on every picture), and it is ActionForge that differs from the file - it re-poses the legs (both feet flat, the rear leg
locked straight, the front knee bent more), which is why the rear knee's turn-in and lifted heel that the actor really
does in this cross are not there in ActionForge.

So the brief's premise ("the fault is our FBX -> MetaHuman retarget") does not hold, and BOUGHTCLIP1 / KNEEROOT1's
verdict ("the take itself") stands for the legs. What the owner dislikes is in the bought take; what he likes is
ActionForge's change to it. Which legs the game plays is now a taste call, and a test switch shows both.

## How it was judged
Three things were read picture by picture on the same body (mh_boxer_01), the clip alone, no player and no layer:
the bought FBX itself (Godot's FBX reader, none of the bake's code - `tools/afretarget_lib.gd` `file_frames`),
ActionForge's export (`assets/anim/af_retarget/box1_m3_right_cross_af.glb`) and our bake
(`assets/anim/baked/mc_Box1_M3_Right_Cross.res`). Bone directions are read in each body's own pelvis frame, so the
facing and the body's size drop out (`tools/afretarget_src.gd`).

### Off the bought file, worst picture of the take (degrees)
| | thigh / shin direction | knee bend | foot direction | palm turn about the forearm |
|---|---|---|---|---|
| Our bake, rotation copy only (`raw=1`, before any foot stage) | 1 | 0 | 1 | 7 |
| **Our bake as shipped** | **4** | **4** | **4** | **8** |
| **ActionForge's export** | **20** (45 on its one-picture pop at 0.43 s) | 25 (43 on the pop) | 18 (29 on the pop) | **168** |

### At the contact (0.30 s), on our leg (84 cm) - the brief's numbers
| | lead knee off line | lead knee bend | rear knee off line | rear knee bend | lead / rear foot turned out | stance wide x long | punching arm straight |
|---|---|---|---|---|---|---|---|
| The bought file (actor's skeleton) | 3.7 cm | 11 deg | 1.0 cm | 22 deg | 9 / 27 deg | 36 x 36 cm | - |
| Our bake, every v2 layer off | 4.5 cm | 13 deg | 2.2 cm | 26 deg | 7 / 27 deg | 37 x 34 cm | 99% |
| Our bake in the v2 player (the game now) | 4.5 cm | 13 deg | 2.2 cm | 26 deg | 7 / 27 deg | 37 x 34 cm | 99% |
| ActionForge's export | 2.4 cm | 29 deg | 0.2 cm (other side) | 2 deg | -5 / 10 deg | 31 x 33 cm | 99% |
| Test clip in the v2 player (`-- afretarget`) | 2.4 cm | 29 deg | 0.2 cm | 2 deg | -5 / 10 deg | 31 x 33 cm | 99% |

(`tools/kneeroot_probe.gd -- only=knee arms=game [afretarget]`, blue; red reads the same within 0.1.)

### What ActionForge does differently (measured, its settings are not readable from the export)
- **It re-poses the legs.** The rear leg is at 99-100% of its full reach on every picture (the file: 95-98%), the rear
  knee bend is 2 degrees through the punch (the file: 20-33), the lead knee stays bent 26-30 degrees (the file
  straightens it to 9-11). The ankles end 41 cm apart at the contact on its body where the file, at that body's size,
  has 46: the feet stay near where they started instead of following the actor's pivot. That is the look of a leg
  solver holding the feet flat on the floor, not of a copy of the actor's joints.
- **Its feet are turned in a constant 12-17 degrees** against the file on every picture, both feet the same amount
  (a rest-pose choice, not motion).
- **One-picture pop**: the lead shin jumps 24 degrees at 0.43 s and returns (its own export; mended in the test clip).
- **Its hands are turned 152-168 degrees about the forearm** against the actor's, constant over the take: nearly upside
  down, and the forearm skin shows the twist in the side still. Our bake's palms are within 8 degrees of the file.
  This is why ActionForge's export should not be played whole.
- It keys no toes. Its upper body otherwise follows the file like ours (a constant offset per joint that changes 1-9 degrees
  over the take).

## Step 2: the stage in our bake that produces the difference
None. The rotation copy alone (`tools/owned_mocap_bake.gd:335-346`, the `raw=1` switch at `:420` stops there) is within
1 degree of the file; the foot stages after it (`:423-465`: smooth, pin, fit) add at most 3 degrees. Rest pose, bone
roll, axis and twist were each checked by the result: thigh and shin directions, knee bend, foot direction and palm
turn all match the file. KNEEROOT1 already found the same with its own ruler (1.2 cm, 4 deg).

## Step 3: fix or ship ActionForge's clips?
There is no bake fault to fix, so no take was re-baked and no other baked take needs it.
Making our bake "match ActionForge within 2 cm / 3 deg" would mean copying a leg re-pose whose rules we cannot read;
not done.

What exists instead, as a TEST SWITCH (not shipped): `-- afretarget` (`scripts/fight3d/FightClips.gd:56-57, 106-107`)
plays `assets/anim/af_retarget/<take>.res` in place of our bake where one exists. Today only the plain cross has one.
That clip (`tools/afretarget_convert.gd`) is **ActionForge's legs and hip travel under our bake's upper body**: the
legs the owner liked, without ActionForge's turned hands; its pop mended; turned, sized and floored like our bake so
the plan's distances hold. `whole=1` converts all of ActionForge instead (for comparison only).

**Recommendation.** Keep our bake as the shipped clip: it is the actor's cross (rear heel up, hips turned through). If the owner prefers ActionForge's planted legs after seeing
the film, the route is: export each take from ActionForge on mh_boxer_01 (GLB, as he did for the cross; the plain
punches first, 145 takes for the whole pro set), run `afretarget_convert.gd` on each (legs only), play them
with the switch on by default. Cost to know first: flat feet on a cross and hook lose the weight shift, and every
take must be exported by hand in ActionForge.

## Step 4: tests
- `tests/retarget_match_test.gd` (RETARGETMATCH): against ActionForge, our bake reads 3.6 cm at the knee and 33 deg on
  thigh / shin (red against the brief's 2 cm / 3 deg bar - kept as the control arm that proves the ruler sees the
  difference); the `afretarget` clip reads 0.1 cm / 0.0 deg (green). Against the bought FILE, where it is on the
  machine: our bake 3.6 deg legs / 7.8 deg palms (kept), ActionForge 20.4 / 168.3 (not kept), the test clip keeps our
  palms (7.8). 9 checks, failures=0.
- Green: player2_test, choreographer_test, arm_build_test, file_limits_test, golden_path_test (each run alone, headless).

## Step 5: film and stills (opened: the difference shows plainly)
`ops/previews/s537_afretarget1/` (local, not in git): `cross_side_body_slow.mp4`, `cross_side_legs_slow.mp4`,
`cross_front_legs_slow.mp4` (the take at one third speed) and the three `*_contact.png`; every picture in `frames/`.
Panes: ActionForge's export | our bake (= the bought file) | the test clip. Fixed camera, every pane turned to the same
facing and stood on the same floor (`tools/afretarget_film.gd`).
- Side, at the contact: our bake has the rear heel off the floor, the rear knee bent and turned in, the weight over an
  almost straight front leg, the trunk leaning into the punch. ActionForge stands more upright on two flat feet with
  the rear leg straight and the front knee bent. The test clip has ActionForge's legs with our trunk and arms.
- Front, at the contact: our bake stands wider with the feet turned out; ActionForge is narrower and its front shin
  angles out below the knee. Neither shows a broken knee; they are two different leg poses.
- ActionForge's punching forearm shows a wrung skin and a bent wrist (the 150+ degree hand turn); ours does not.

## Not done / open
- The owner's call: the actor's legs (shipped) or ActionForge's planted legs (the switch). Nothing changes in the
  shipped game until he says.
- Only the cross has an ActionForge export; no other take was compared.
- The earlier run's scratch (`tools/afretarget_dump.gd`) was removed; `raw=1` stays in the bake tool as a probe switch.
