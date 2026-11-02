# ZIVA_GUARD_S274 (ZIVAGUARD1) - the guard's gloves, measured on BOTH paths

Model: Ziva (Godot editor seat, wt/ZIVA, effort MAX). Branch `ziva/playtest`, merged with `origin/master` de7407cb.
Seat: BOXING (demo). Datum: body 04, seed 94301, fixed 30 fps, 660 frames (22 s), fighters only.

## 0. What the brief became, and why (start here)

The brief (TASK_ZIVAGUARD1.md) said: the fight's guard gloves sit forward and wide of the chin, the board's
`rk_FightingIdle` has them on the face - find the layer that moves them and fix it.

**Claude, S274 mid-flight, with the operator watching a same-seed A/B** (`previews/s274_layers/s274_layers_ab.mp4`,
game as shipped vs the same fight with the bone-rewriting layers OFF): *"the right clip on the video is much better"*.
That answers board Q-S273-2 and makes **clips-only the base** (ANIM_TOOLKIT_S274, order of work 1). The job here is
therefore no longer "find the guilty layer" but:

1. **confirm with the glove columns that the layers-off fight matches the board** (both gloves within 3 cm), and
2. **list which of those layers the fight still NEEDS** - spacing must stay (no chest-to-chest crowding).

Both are answered below, with the switch sets that are safe to turn off and the two that are not.

## 1. The instrument - the same columns on both paths

`tools/anim_orbit_render.gd::glove_columns()` is the ONE measurement; `anim_orbit_render` prints it on its
`pelvis_log=1` line (the board path) and `tools/fight_studio_render.gd` prints it on its `clip_log=1` line (the fight
path), so the two numbers are the same number. Per man, per hand, in metres, in that man's own HEAD FRAME:

| column | meaning |
|---|---|
| `d` | distance from the **Head bone** to the wrist - the glove-to-chin number the 3 cm gate reads |
| `w` | the head-frame x = the man's RIGHT: the glove's **width** off the chin (+ = out to his right) |
| `f` | the head-frame z = where his chest faces: how far the glove sits **in front of** the chin |
| `lead` / `rear` | the man's own hands from his own stance (`guard_southpaw`), not "left/right" |
| `scale` | that man's draw scale - **without it the columns are two different rulers' numbers** |

Why this frame is the right one: it is `FightStagePlayer.head_frame` fed the same two bones the guard IK feeds it
(`LeftUpperArm`, `RightUpperArm`, `Neck`, `Hips`), i.e. **the frame the game's own guard targets are written in**
(`GuardPose` authors every offset in it, and Ludo's "wrist 0.21-0.23 m from the head bone" is measured from the same
bone). `raw_log=1` dumps the world positions and the frame's axes, which is how the frame was proven: the same run's
`f` axis is +Z-ish while the man faces +Z, `y` is the shoulder line, `z` points up.

### THE SCALE, WHICH IS MOST OF ANY RAW DIFFERENCE
The fight draws each man at `FighterPhysique.height_scale` (S272): **body 04 measured 0.9490** (man B) and fighter A
**0.9073**, while the board draws at 1.0. A raw metre of glove-to-chin is therefore ~5-9% shorter in the fight.
Every table below gives the **unscaled** column (fight metres ÷ that man's own scale) beside the raw one, and the
delta is taken against the unscaled board number. Raw-only, the same guard reads "2-5 cm short" for a reason that is
not a layer at all - that was half of the S272 finding, and it is the trap this instrument removes.

### Run it
```
# the board path - the raw take, the same window the fight plays, body 04
Tools\godot_hidden.ps1 --path Godot --resolution 640x360 --fixed-fps 30 --quit-after 200 \
  --script tools/anim_orbit_render.gd -- as_game bodies=04,04 pose_log=1 pelvis_log=1 seconds=2 \
  out=E:/FightCamp/tmp/guard274/orbit roles=rk_FightingIdle@40.867-42.867

# the fight path - any arm (`off=` = room options, `<name>=0` = GameSwitches; ALWAYS --quit-after)
Tools\godot_hidden.ps1 --path Godot --resolution 640x360 --fixed-fps 30 --quit-after 660 \
  --script tools/fight_studio_render.gd -- as_game seed=94301 bodies=04,04 clip_log=1 [arm args]
```
**`--quit-after` is not optional** - a render without it ran for 1 h 45 m (Claude, S274). Also: `pelvis_log` needs
`pose_log=1` (it is `pose_log` that hands the tool the live room), and `off=<name>` only reaches ROOM options -
the GameSwitches (guard_ik, anim_scurve, anim_fatigue, anim_glove_spring, elbow_tuck, anim_inside_uppercut_ik,
alive_events) need `<name>=0`, and a switch that is BOTH needs both (see the arm definitions in section 4).

## 2. Table 1 - the board's `rk_FightingIdle`, the reference (raw take, body 04 at scale 1.0)

9 samples over the 2.4 s window (the tool's own ±0.2 s pad around the fight's 40.867-42.867).

| column | median | p90 | min | max |
|---|---|---|---|---|
| lead d (to chin) | 0.378 | 0.380 | 0.373 | 0.380 |
| lead w (width) | +0.043 | +0.048 | +0.037 | +0.048 |
| lead f (forward) | 0.323 | 0.327 | 0.320 | 0.329 |
| rear d (to chin) | 0.469 | 0.472 | 0.452 | 0.475 |
| rear w (width) | +0.361 | +0.363 | +0.341 | +0.363 |
| rear f (forward) | 0.296 | 0.297 | 0.292 | 0.302 |

**Read this before quoting the operator's words.** The take's own guard is a LOOSE, bouncing one: the lead wrist sits
**0.32 m in front of the chin**, the rear **0.36 m out to his right** at chin height. Ludo's tucked-guard reference is
0.21-0.23 m from the head bone. So `rk_FightingIdle` is not a peekaboo with the gloves on the cheeks - the higher
glove is held out to the side (visible on the f38 frame of the render). **The fight is not "wider than the board";
the board is where the width comes from.** That is why the acceptance is a *match the board* gate, not "tuck the
gloves in", and why hand-posing the guard was the wrong cure (the brief's own trap).

## 3. Table 2 - the fight, every arm (unscaled metres; delta against the board)

Guard = frames where that man's own clip is `idle` (the captured Rokoko take). Both men are orthodox (lead = L).

| arm | a lead | a rear | b lead | b rear | worst | h2h med | h2h min | chest_xz med | chest_xz min |
|---|---|---|---|---|---|---|---|---|---|
| shipped (every layer ON - the game as it ships) | +0.396 (+18) | +0.459 (-10) | +0.397 (+20) | +0.487 (+18) | **20 mm** | 0.778 | 0.365 | 0.927 | 0.631 |
| clips only - the 29, shuffle_from_bell included | +0.403 (+26) | +0.379 (-90) | +0.397 (+20) | +0.432 (-37) | **90 mm** | 0.694 | 0.334 | 0.897 | 0.755 |
| **clips only, latch kept (RECOMMENDED)** | +0.395 (+17) | +0.457 (-12) | +0.396 (+19) | +0.482 (+13) | **19 mm** | 0.798 | 0.379 | 0.915 | 0.780 |
| clips only, latch + human_footwork kept | +0.395 (+17) | +0.456 (-13) | +0.397 (+20) | +0.471 (+2) | **20 mm** | 0.805 | 0.392 | 0.921 | 0.774 |
| clips only + the pair-spacing family also off | +0.397 (+19) | +0.494 (+25) | +0.396 (+19) | +0.493 (+24) | **25 mm** | 0.751 | **0.120** | 0.887 | **0.107** |
| clips only + spacing half A off (roots/placement) | +0.373 (-4) | +0.463 (-6) | +0.381 (+4) | +0.490 (+21) | **21 mm** | 0.704 | 0.301 | 0.825 | 0.597 |
| clips only + spacing half B off (overlap/hold/contact) | +0.397 (+19) | +0.427 (-42) | +0.398 (+20) | +0.426 (-43) | **43 mm** | 0.664 | 0.212 | 0.827 | 0.340 |
| clips only + hand_offset_smooth/head_stop/continuity off | +0.408 (+31) | +0.376 (-93) | +0.397 (+20) | +0.432 (-37) | **93 mm** | 0.698 | 0.308 | 0.730 | 0.205 |

(board reference: lead 0.378, rear 0.469. `h2h` = Head-bone to Head-bone, `chest_xz` = horizontal Chest-to-Chest.)

### THE CONFIRMATION (what Claude asked for)
**Yes - the layers-off fight is the board's guard.** In the recommended arm all four glove columns land within
**2.0 cm** of the board (lead +17/+19 mm, rear -12/+13 mm), i.e. inside the 3 cm gate, and the guard's own spread is
unchanged while the pair keeps its distance. The same is true of the shipped arm (+18/+20/-10/+18) - which is the
S272 result standing: `mocap_pure` had already stopped the layers touching a captured take's guard **pose**. What the
layers were still doing to the guard is the SPACING, and that is section 4.

### The one number that is NOT the guard's fault
"Between punches" frames (the man's clip is a strike, catch, slip or reaction) read rear d 0.344-0.374, i.e. 9.5-12.5 cm
short of the board - in BOTH arms, shipped and clips-only. A throwing or slipping arm holds its rear hand away from
the chin by design; that column is not a guard measurement and is not gated. The gate is the `idle` (guard) rows.

## 4. The bisect - and the cause line

Every arm is the same fight (seed 94301, bodies 04,04, 660 frames) with ONE more group of switches off. Full command
set with the exact `off=`/`=0` strings: `E:/FightCamp/tmp/guard274/arm_*.sh`; the raw logs beside them.

| what was turned off ON TOP of the clips-only set | guards vs the board | spacing (`chest_xz` med / min) | verdict |
|---|---|---|---|
| nothing (= the 29, `shuffle_from_bell` **included**) | worst 90 mm | 0.897 / 0.755 | rear glove 3.7-9.0 cm short |
| the pair-spacing family **also** off | worst 25 mm | 0.887 / **0.107** | gloves match, **the men stand inside each other** |
| spacing half A: single_root_solver, body_spacing, stance_offset, root_accel_cap, warp_on_line, contact_push_on_line | worst 21 mm | 0.825 / 0.597 | spacing broken by half A alone |
| spacing half B: overlap_in_takes, hold_pair_geometry, contact_stop, contact_push_carry | worst 43 mm | 0.827 / **0.340** | spacing broken by half B alone |
| hand_offset_smooth, head_stop, skip_hand_continuity_while_stepping | worst 93 mm | 0.730 / 0.205 | **not a writer of the guard glove** - no change |
| `shuffle_from_bell` OFF (walk falls back to `loc_*` clips) | worst 90 mm | 0.897 / 0.755 | the men leave the guard clip |
| `shuffle_from_bell` ON (either gait) | worst 19-20 mm | 0.915-0.921 / 0.774-0.780 | **the guard clip is held** |

### THE CAUSE LINE
**Nothing in the arm/hand/face/alive layer set moves the fight's guard glove off the board's by more than ~2 cm - the
guard pose on a captured take is already the captured take.** What the layers still own is the PAIR: with the
pair-spacing family off, `chest_xz` falls from 0.915 m to **0.107 m** - the two men's chests 10 cm apart - and that
same pass is what stands the near (rear) glove 4.2-5.6 cm further off the chin than the clip alone would
(half B off: rear 0.427/0.426 against 0.457/0.482 with it on). **The spacing passes are the guard's width, and the
guard's width is the price of not crowding** - turn them off and the gloves match the board while the men walk into
each other.

### THE SECOND CAUSE - clip selection, not layers
The full 29-off list also turns off `shuffle_from_bell`, and that is NOT a bone writer: `FightStagePlayer.walk_at`
(L2418-2465) only plays the guard `idle` while `_shuffle_enabled` is latched (the room latches it at the bell,
`FightWorldLiveScreen.setup` L1566). With the latch off, every travel plays a locomotion clip instead - the arm's own
clip mix goes from `idle x41` to `loc_advance x16 / loc_strafe_left x4 / loc_strafe_right x5` (24% of the samples out
of the guard), and the guard rows that remain are few (n=8-15, against 26-42) and picked at other moments. That is
most of the 90 mm.

## 5. Which layers the fight still NEEDS (the answer)

**KEEP, as a set - the pair-spacing family (10 switches):**
`single_root_solver`, `body_spacing`, `stance_offset`, `root_accel_cap`, `warp_on_line`, `contact_push_on_line`
(half A) and `overlap_in_takes`, `hold_pair_geometry`, `contact_stop`, `contact_push_carry` (half B).
Half A off breaks the spacing on its own (`chest_xz` min 0.597); half B off collapses it to 0.340; both off to
**0.107 m** - measured, not argued. This is exactly the decision's "spacing must stay".

**KEEP - `shuffle_from_bell`** (the gait latch). It is not a bone writer; it is what keeps a travelling man in the
guard CLIP instead of a `loc_*` walk clip. With it on, the guard rows triple and the rear glove lands within 1.3 cm of
the board; with it off they drop by a third and the rear reads 3.7-9.0 cm short. Whether the FOOTWORK PLANNER behind
it is `human_footwork` (HUMAN2) or the legacy shuffle is a second-order choice on these numbers (worst 19 mm vs
20 mm) - that slot is what the captured step library replaces (part 2).

**CAN GO - the arm/hand/face/alive set (28 switches), all measured to make no guard difference:**
`guard_ik`, `guard_ramp_clip`, `elbow_tuck`, `anim_scurve`, `anim_fatigue`, `anim_glove_spring`,
`anim_inside_uppercut_ik`, `alive_events`, `alive_breath`, `alive_stance`, `human_hit_additive`, `human_flinch`,
`human_footwork`, `hit_physics`, `foot_pivot`, `foot_repin`, `active_ragdoll`, `face_drawn_foe`, `reface_in_takes`,
`hand_contact_sync`, `glove_contact`, `hands_smooth_in_whole`, `head_level`, `punch_load`, `punch_retime`,
`strike_speed_caps`, `human_speed_tempo`, `sequence_steps`.

**NOT a guard writer either way** (turning all three off changed the rear glove by 0 mm): `hand_offset_smooth`,
`head_stop`, `skip_hand_continuity_while_stepping`. They are neither needed nor guilty; leave them where they are.

**The residual, for the record:** every arm includes ~+17-26 mm on the LEAD glove, including the arm with every
toggled switch off - so it is not one of these layers. The remaining candidate is the S77 continuous-pose channel
(`FightStagePlayer.settle_hand_offsets` L5052 with the room's `continuous_pose`), which runs on captured takes and is
not in the brief's list. At +2 cm it is inside the gate; it is the next thing to measure if the operator wants it gone.

## 6. The clips (visual gate - operator closes this one)

| file | what it shows |
|---|---|
| `previews/s274_guard/s274_guard_ab.mp4` | 20 s, same seed: **left** = the game as shipped, **right** = clips only + spacing + latch (1920x540) |
| `previews/s274_guard/s274_guard_board_vs_fight.mp4` | **left** = the board's `rk_FightingIdle` window, looped, **right** = the same fight - guard against guard |
| `previews/s274_guard/stills/guard_0*.jpg` | 7 stills through `tools/still_framing.gd::save_if_framed` ONLY (every save logged `STILL_FRAMING OK ... shot=broadcast`), both men head to feet, boots on |

Both mp4s are movie-mode renders (`--fixed-fps 30 --write-movie`, fighters only, grey studio floor) re-encoded with the
worktree's own ffmpeg at 1920x540, the format the operator's own A/B already arrived in.

## 7. Tests

`rokoko_clips_test`, `fight_clip_slice_test`, `punch_retime_test`, `guard_pose_test`, `guard_ik_pass_test`,
`mocap_pure_test`, `guard_face_clear_test`, `guard_wrist_line_test`, `guard_clip_ramp_test`, `fight_guard_contract_test`:

```
python Godot/tools/run_tests.py --only rokoko_clips_test,fight_clip_slice_test,punch_retime_test,guard_pose_test,guard_ik_pass_test,mocap_pure_test,guard_face_clear_test,guard_wrist_line_test,guard_clip_ramp_test,fight_guard_contract_test --verbose
```
**plain SUITE total=10 fails=0; `--as-game` SUITE total=10 fails=0.** (`punch_retime_test` is green on this merge -
Claude's de7407cb fixed it; it was not touched here.)

## 8. Files this seat owns / changed

| file | change |
|---|---|
| `tools/anim_orbit_render.gd` | `glove_columns()` (the shared measurement) + the columns on the `pelvis_log=1` line + `raw_log=1` (the frame proof) |
| `tools/fight_studio_render.gd` | the same columns on the `clip_log=1` line, `scale=`/`lead=`/`rear=`, pair `h2h`/`chest`/`chest_xz`, and `stills=<dir> still_every=<n>` (through `still_framing`, house rule) |

## 9. Part 2 - the Rokoko footwork step library (`assets/anim/rokoko_combat/step_library.json`)

Owner per `FOOTWORK_CONTRACT_S274.md` (the library is the piece Ziva owns; the picker is Arena's `rules/StepPicker.gd`).
Tool: `tools/rokoko_step_finder.gd` (new). Operator rule S274: motion from Rokoko + ActionForge only.

### 9.1 THE MEASUREMENT THAT CHANGED THE METHOD - the takes have no root motion
The plan in the brief was "a step = the clip's own ROOT translation, 0.25-0.45 m". Measured (`travel=1`, the game's own
Mixamo -> MetaHuman path, the toe bones, 30 fps):

| take | length | hips bbox | hips path | foot: bbox | foot path | lifts | biggest plant-to-plant | stance |
|---|---|---|---|---|---|---|---|---|
| FightingIdle | 52.4 s | **0.00 x 0.00 m** | **0.000 m** | L 0.26x0.60 / R 0.28x0.62 | 8.79 / 8.69 m | 7 / 11 | 0.221 / 0.524 m | 0.21-0.59 m |
| Boxing | 17.9 s | **0.00 x 0.00 m** | **0.000 m** | L 0.56x0.72 / R 0.61x0.90 | 7.64 / 8.53 m | 17 / 13 | 0.653 / 0.720 m | 0.21-0.81 m |
| ShadowBoxing | 31.1 s | **0.00 x 0.00 m** | **0.000 m** | L 0.86x0.69 / R 0.96x0.78 | 12.03 / 13.09 m | 22 / 26 | 0.709 / 0.711 m | 0.15-0.95 m |
| KnockOut_Loser | 20.5 s | **0.00 x 0.00 m** | **0.000 m** | L 0.58x1.16 / R 0.83x0.86 | 7.74 / 7.40 m | 3 / 10 | 0.171 / 0.387 m | 0.11-0.56 m |
| KnockOut_Winner | 20.0 s | **0.00 x 0.00 m** | **0.000 m** | L 0.23x0.48 / R 0.31x0.56 | 6.07 / 6.55 m | 11 / 13 | 0.464 / 0.348 m | 0.21-0.65 m |

**Every Rokoko take is ROOT-IN-PLACE: the hips never translate at all (path 0.000 m, bbox 0.00 x 0.00).** The actor
shadow-boxes on one spot while the FEET do the real work (7-26 lifts, 0.17-0.72 m between plants). And the ActionForge
loader pins the root by design - `AFMotion`'s own header: *"Root translation belongs to the room: Hips stays at the
MetaHuman's rest"* - so neither allowed source has a root curve to read.

### 9.2 The one deviation, and why it is the right number
**In an in-place capture the actor's step IS the foot's travel**: the foot leaves the body's ground spot, lifts and lands
somewhere else, and because the hips do not move, the foot's displacement **is** the body's displacement relative to the
ground. So an entry's `move` is measured as THE STEPPING FOOT'S OWN PLANT-TO-PLANT DISPLACEMENT, in the fighter's own
local frame at the window's start (`+y` toward the foe, `+x` his right), and `turn_deg` is the facing's own change over
the same window (positive = toward his left, `Vector2.rotated`'s sense, as the picker reads it). This is StepPicker's
frame exactly; it is the ONE difference from its doc line "the clip's root translation", and it is recorded here.

A window is: both fists within 0.55 m of the Head bone at BOTH ends (guard-to-guard - never mid-punch), one foot on the
floor at the start and that same foot planted again at the end, 0.18-0.60 m apart, 0.25-1.40 s long. The plant test uses
THE LOWER OF THE TWO BALLS that frame as the floor, not one global take minimum (the ball's own height drifts with the
stance - measured decks -0.03 and -0.04 m). `kind` is decided by the PICKER'S OWN `StepPicker.BOUNCE_M` (0.05 m), so the
label can never disagree with how the picker reads the entry.

### 9.3 The library: 11 entries, and what it does not have
```
Tools\godot_hidden.ps1 --path Godot --headless --script tools/rokoko_step_finder.gd -- \
  take=<FightingIdle|Boxing|ShadowBoxing> cut=1 max_s=1.4 min_m=0.18 max_m=0.60 per_dir=3 plant_m=0.03
```
| id | take | window | move (right, forward) | turn | length | kind |
|---|---|---|---|---|---|---|
| idle_in1 | FightingIdle | 17.33-17.70 | +0.020, +0.182 | -11.0 | 0.367 | step |
| box_in1 | Boxing | 3.80-4.70 | +0.143, +0.293 | +10.4 | 0.900 | step |
| box_in2 | Boxing | 4.20-5.10 | -0.026, +0.191 | -1.2 | 0.900 | step |
| box_out1 | Boxing | 10.50-11.17 | -0.003, -0.231 | -5.1 | 0.667 | step |
| shadow_out1 | ShadowBoxing | 9.10-9.90 | -0.227, -0.328 | +0.8 | 0.800 | step |
| shadow_out2 | ShadowBoxing | 15.47-16.20 | -0.043, -0.177 | -4.4 | 0.733 | step |
| idle_bounce1..3 | FightingIdle | 12.97-13.83, 13.83-14.63, 44.17-44.73 | 0.005 / 0.001 / 0.040 m | -2.1 / -2.1 / +4.1 | 0.87 / 0.80 / 0.57 | bounce |
| box_bounce1 | Boxing | 14.17-14.73 | -0.005, -0.046 | +6.6 | 0.567 | bounce |
| shadow_bounce1 | ShadowBoxing | 1.50-1.80 | +0.046, -0.007 | -12.0 | 0.300 | bounce |

**The gaps are the finding, measured - Rokoko does not have these moves and nothing here is stretched to fake them:**
- **No LEFT step and no RIGHT step.** `right 0.30 m` through the picker gets `box_in1` rotated the maximum 10 deg:
  body (+0.176, +0.243), **residual (0.124, -0.243) m** - it walks him forward instead. `left 0.30 m` gets
  `shadow_out1`: body (-0.224, -0.227), residual (-0.076, +0.227). Both cost 60-68 against 2.3-13.5 for the
  directions the library has.
- **No clean in-guard pivot.** The only windows with a big turn (Boxing 15.00-16.00 and 15.17-16.00, 0.43/0.24 m,
  turn **-265.4 / -264.0 deg**) are the take's own turn-around at its end - the actor resets to face the other way.
  StepPicker's `TURN_LIMIT_DEG` is 15, so they are useless as boxing pivots and are left OUT.
- **KnockOut_Loser / KnockOut_Winner are not guard takes at all** (3% and 1% of frames in guard) - nothing cut there.
- `Boxing` 2.87-3.80 (a 0.054 m creep with a -45.7 deg turn) was dropped: over `BOUNCE_M` so the picker reads it as
  travelling, and its turn is the lead-in to the first jab (fists 0.48 -> 0.32), not a guard move.

### 9.4 It works through the picker (the acceptance evidence)
`StepPicker.pick` on the 11 entries, the JSON's `move` arrays as `Vector2` (the loader the contract describes):

| intent | picked | scale | body travel delivered | residual |
|---|---|---|---|---|
| bounce in place | idle_bounce2 | 1.00 | (+0.001, -0.001) | 1 mm |
| in 0.15 | box_in2 | 0.80 | (0.000, +0.154) | **4 mm** |
| in 0.30 | box_in2 | 1.20 | (0.000, +0.231) | 69 mm |
| out 0.23 | box_out1 | 1.00 | (0.000, -0.230) | **0 mm** |
| in 0.20, 8 deg left | box_in2 | 1.04 | (0.000, +0.200) | **0 mm** |
| right 0.30 | box_in1 | 0.92 | (+0.176, +0.243) | (0.124, -0.243) |
| left 0.30 | shadow_out1 | 0.80 | (-0.224, -0.227) | (-0.076, +0.227) |
| pivot 30 deg in place | box_bounce1 | 1.00 | 15 of 30 deg | - |

No intent returns NONE (the picker always answers), and every intent the library actually has a move for comes back
inside the clamp band with a 0-4 mm residual.

### 9.5 Bonus for the queued ROKOKOMOVES1 Part A - the long guard stretches, measured
`guard=1` (contiguous runs where both fists stay within `guard_m` of the Head bone; `seam` = the FACING's own change
over the run, not a full-pose seam):

| take | guard runs >= 4 s | longest | seam of the longest |
|---|---|---|---|
| FightingIdle | **9.13-18.30 s (9.17 s)**, **35.60-45.10 s (9.50 s)** | 9.50 s | **4.6 deg** (the 9.17 s one: 70.7 deg) |
| Boxing | longest 3.33 s from 9.80 s | 3.33 s | - |
| ShadowBoxing | 11.90-17.13 s (5.23 s) | 5.23 s | 14.5 deg |
| KnockOut_Winner / _Loser | none | 0.63 / 0.17 s | - |

So FightingIdle can supply TWO 9+ s guard windows (Claude's guard read of "~8-20 s and ~36-44 s" is confirmed and the
second one extends to 45.10 s), and its 35.60-45.10 stretch turns only 4.6 deg over 9.5 s - the best crossfade partner
in the set. This is input for Part A, not a Part A result.

## 10. Files this seat owns / changed (updated)

| file | change |
|---|---|
| `tools/rokoko_step_finder.gd` | NEW: `travel=1` (what a take contains), `guard=1` (the long guard inventory), `cut=1` (the library) |
| `assets/anim/rokoko_combat/step_library.json` | NEW: the 11 entries StepPicker consumes |
| `tools/anim_orbit_render.gd` | `glove_columns()` (the shared measurement) + the columns on the `pelvis_log=1` line + `raw_log=1` (the frame proof) |
| `tools/fight_studio_render.gd` | the same columns on the `clip_log=1` line, `scale=`/`lead=`/`rear=`, pair `h2h`/`chest`/`chest_xz`, and `stills=<dir> still_every=<n>` (through `still_framing`, house rule) |