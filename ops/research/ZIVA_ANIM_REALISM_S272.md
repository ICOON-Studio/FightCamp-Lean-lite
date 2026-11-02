# ZIVA_ANIM_REALISM_S272 - the new clips, the old clips, the 3D fight, and the squat

Ziva, task ZIVARATE1 (operator S272: "have ziva rate the new animations and 3d fight realism"), branch `ziva/playtest`,
boxing demo only. Everything below is measured on **the moving bout on the game's own camera**, which is the one thing the
brief forbids substituting: the stills are moments picked by the numbers, and every rating is a rating of `as_game`.

**Read this first if you only read one paragraph.** The new Rokoko jab/cross/guard are the best animation in the build and
the fight still does not look like the board, and the reason is not the clips: in the 20 s fight the two men are **scaled to
their recorded statures (0.8916 and 0.9490 of the body mesh - 195 cm and 190 cm become 173.9 cm and 180.3 cm)** while the
board renders them unscaled, and the fight-time synthetic layers (guard IK + its body curl, punch load, the level head)
pressed their heads together to **0.62 m** where the capture alone stands at 1.03 m. Both are numbers below, and the second
one is fixed and committed (`mocap_pure`).

---

# PRIORITY 1 - THE FIGHT SQUAT

Operator's screenshots: `docs/previews/s272_fight/operator/squat_lean_in.png` (both men sunk, knees past the toes, heads
pressed, gloves on heads) and `red_hunched.png` (arched back). The same takes in the board renders stand tall.

## 1.1 The four paths to the same take, measured

The question "which layer does it?" needs the same joints read through every path a take can travel. New instruments:

| instrument | path it measures | how |
|---|---|---|
| `tools/ziva_raw_clip_probe.gd` | **the raw clip** - what the board's `rk_` renders show | the take built on the body, sampled through `FightClipRetarget._contact_globals`, no node, no pass |
| `tools/ziva_squat_probe.gd studio=<roles>` | **the studio game-path render** (the operator's "smooth" `boxing_*` renders) | room mounted then STOPPED, `play_role` + `advance(1/30)` on body B, read post-draw |
| `tools/ziva_squat_probe.gd` (default) | **the live fight** | `record_room as_game seed=94301 bodies=09,04` (palette and full moves), read post-draw |
| `tools/ziva_squat_probe.gd off=<switches>` | **the live fight with one layer off** | the room's own red arms (`off=` writes the room's options) |

Numbers (medians over the frames the clip is current; pelvis = hips joint over the deck; knee = the more-bent knee).

| take | RAW clip (board path) | studio (play_role) | fight, before | fight, after `mocap_pure` |
|---|---|---|---|---|
| jab, body 09 | pelvis 0.917, knee 122.5 | 0.866 / 122.4 | **0.818 / 116.5** | 0.821 / 115.8 |
| cross, body 09 | 0.877 / 122.9 | 0.866 / 124.6 | 0.828 / 113.1 | 0.829 / 112.9 |
| idle, body 09 | 0.945 / 140.3 | 0.865 / 121.8 | 0.846 / 133.8 | 0.846 / 130.6 |
| jab, body 04 | 0.917 / 122.5 | 0.901 / 132.9 | 0.870 / 118.9 | 0.865 / 114.6 |
| cross, body 04 | 0.877 / 122.9 | 0.900 / 132.8 | 0.848 / 107.3 | 0.852 / 110.7 |
| idle, body 04 | 0.945 / 140.3 | 0.900 / 132.7 | 0.901 / 136.0 | 0.901 / 135.3 |

Two facts jump out of that table:

* **The raw clip is the tallest of the four**, in both joints (idle pelvis 0.945, knee 140.3 - a tall boxing stance), and
  the same tall picture is what the operator approved on the board.
* **The fight loses 4-13 cm of pelvis and 20-35 degrees of knee** against it, and the loss is **per body** (09 loses more
  than 04 - 10 cm against 4 cm on the idle), which no pose layer can explain: a layer that bent a knee bends both men's.

## 1.2 The cause of the height: the body's stature scale (measured, exact)

`tools/ziva_squat_probe.gd` now logs the fighter node's own scale. In the live bout:

```
frame,side,clip,pelvis_m,root_y,node_scale
    1,a,idle,0.8436,1.2711,0.8916      <- body 09: 195 cm mesh, fighting at 173.9 cm
    1,b,idle,0.9002,1.2719,0.9490      <- body 04: 190 cm mesh, fighting at 180.3 cm
```

* Body 09 is drawn at **0.8916** of its mesh (195 cm -> 173.9 cm), body 04 at **0.9490** (190 cm -> 180.3 cm).
* The arithmetic closes to 2 mm: raw idle pelvis 0.947 x 0.8916 = **0.844** (measured 0.846); 0.947 x 0.9490 = **0.899**
  (measured 0.901). The fight's crouch on the idle/guard is **the scale and nothing else**.
* Where it comes from: `FightWorldStage.mount` scales each body by `FighterPhysique.describe(...)["height_scale"]` =
  target / mesh height, so a fighter's recorded stature (or his class's reference height) rules the drawn body.
* **The board renders do not scale.** `tools/anim_orbit_render.gd` draws the body at its own size, so the operator approved
  a 195 cm boxer and watches a 174 cm one - a 21 cm difference against a full-size ring, ropes, opponent and camera. That
  is the "deep squat" read: the man is not bending more, he is 10-11 % shorter than the picture he was approved from, and
  shorter by a DIFFERENT factor than the man in front of him (0.892 against 0.949 - a 5 cm stature mismatch inside one
  weight class).

**Verdict: the squat is a scale mismatch between the board and the fight, not a body layer.** It is also exactly what the
operator said in his own words: *"this has nothing to do with the animations i see on the board"*.

## 1.3 The A/B: one layer at a time, ten red arms

Same bout, same seed, same bodies, 600 frames each, one switch off per run (`off=` writes the room's own option, the switch
the room reads; verified in each run's `RECORD options` line). Pelvis median for body 09's idle / jab and body 04's cross:

| arm | idle 09 | jab 09 | cross 04 | verdict |
|---|---|---|---|---|
| baseline (all on) | 0.846 | 0.817 | 0.847 | - |
| `foot_repin` | 0.846 | 0.817 | 0.847 | no change |
| `single_root_solver` | 0.846 | 0.817 | 0.847 | no change |
| `head_level` | 0.846 | 0.817 | 0.847 | no change |
| `punch_load` | 0.846 | 0.817 | 0.847 | no change |
| `foot_lock` | 0.846 | 0.814 | 0.847 | no change (deepest-frame pelvis +2 cm) |
| leg family (`foot_lock,foot_repin,foot_pivot,shuffle_from_bell,stance_offset`) | 0.846 | 0.815 | 0.847 | no change (deepest +3 cm) |
| aim/spacing family (`reface_in_takes,face_drawn_foe,strike_aim,hold_pair_geometry,body_spacing`) | 0.846 | 0.816 | 0.849 | no change |
| `guard_ik` | 0.846 | 0.816 | 0.852 | no change |
| `overlap_in_takes` | 0.846 | 0.812 | 0.849 | no change |
| `join_default` | 0.846 | 0.817 | 0.852 | no change |

Not one of the named layers moves the crouch by more than 5 mm; the pelvis median is identical to the millimetre across ten
arms. That is the honest answer to "which layer causes it": **none of them - the height is the scale (1.2), and what the
layers did was press the men together (1.4)**. It is also why the developer's decision to fade the whole synthetic stack on
a captured take is the right shape of fix rather than hunting one switch.

## 1.4 What the synthetic stack WAS doing: heads pressed together - and the fix

`mocap_pure` (landed, see below) fades, while a take with the `rokoko_clip` meta plays: guard IK and its body curl, punch
load, the level head, the foot re-pin's re-bend, punch retime, the S-curve and the onset warp. Root placement and the pair's
own spacing stay. Measured on the operator's own 20 s configuration (`seed=94301 bodies=09,04 palette=boxing_jab,boxing_cross`,
600 frames, one switch apart):

| | layers on (before) | `mocap_pure` (after) |
|---|---|---|
| head-to-head, median | 0.831 m | **0.938 m** |
| frames with heads < 0.80 m | 272 (45 %) | **117 (20 %)** |
| frames with heads < 0.65 m | 92 | **30** |
| head-to-head at frame 150 (a idle / b cross) | 0.6215 m | **1.0254 m** |
| pelvis median / knee median | 0.846 / 131 | 0.846 / 128 |

So the "heads pressed together, gloves on each other's heads" half of the operator's screenshot is the synthetic stack, and
it is 41 cm better at the same frame of the same bout with the same clips. The other half - the squat - is 1.2's scale.

Evidence, all in the repo:

* `docs/previews/s272_fight/ziva_pure_clip/ab_f150_before_after.png` - the same frame, one switch apart: before, both men
  sunk with their guards tangled above their heads; after, two tall boxers exchanging at a proper distance.
* `docs/previews/s272_fight/ziva_layers_clip/before_3to6s_10fps.png` and `ziva_pure_clip/after_3to6s_10fps.png` - the
  operator's own 3-6 s window at 10 fps, both arms, same seed, same bodies.
* `docs/previews/s272_fight/ziva_pure_clip/pelvis_f0474_sidea.png` - scored by the numbers, not by eye: the probe saves a
  still through `tools/still_framing.gd` **when a new lowest pelvis / deepest knee is reached**, so the worst pose of the run
  is the one on disk (29-31 stills per arm, all framed both men head to boots).
* the operator's clip: `docs/previews/s272_fight/fight_20s_rokoko_pure_ziva.mp4` (20 s, `as_game seed=94301 bodies=09,04
  palette=boxing_jab,boxing_cross`, `mocap_pure` on) beside the pre-fix `fight_20s_rokoko_only.mp4`.

## 1.5 What the fix is (committed) and what it deliberately is not

* `scripts/GameSwitches.gd` - new `mocap_pure` in `GAME_ON` with the reasoning on the switch.
* `scripts/FightStagePlayer.gd` - `mocap_take_now()` (the take's own `rokoko_clip` meta) and `mocap_pure_now()`; the ten
  gates: `_retime_active`, `retime_plan_for`, `_onset_warp_active`, `_scurve_active`, `_punch_load_pass`, `_head_level_pass`,
  `_guard_ik_pass`, `relock_feet_after_root`, and the `_anim_pose_pass` call site.
* `tests/mocap_pure_test.gd` - 12 checks 0 failures: the switch ships on; pure-ness is decided by the take and by nothing
  else (the old clip set is untouched); with pure on the three clocks that re-time a take are inactive even when their own
  state says they would run; one frame later, on an old clip, the layers are back. `off=mocap_pure` (or `mocap_pure=0`) is
  the A/B's red arm.
* It changes no simulation and no clip: only what is laid over a capture. The old clip set keeps every layer it had.

## 1.6 What still holds the squat back (measured, not guessed)

1. **The residual knee.** Even after the fix the fight bends the knee 10-15 degrees deeper than the take's own lowest
   (idle: fight 130.6 against the take's 140.3). It is scale-invariant, so it is pose: the leg IK holding the canvas pins.
   The leg family off recovers about 3 cm at the deepest frames and nothing at the median, so this needs its own arm inside
   `FightFootLock`/`_bend_leg` rather than a switch.
2. **The scale question is a decision, not a patch** (proposal **P1**): either the board renders should draw the body at the
   fight's own scale (one line in `tools/anim_orbit_render.gd`, then what the operator approves is what fights), or heavies
   should fight nearer their mesh height (a physique policy change, and the reach/spacing model reads the same statures, so
   it moves the fight maths). I did not touch `FighterPhysique` - it is the game's own model and not in my ownership.
3. The two-men-one-captured-take case is the one where the pair geometry still shows: spacing reaches 0.52 m head-to-head
   on the worst frames (a clinch read) even after the fix.

---

# THE RATINGS

A Steam reviewer of a boxing management sim, honest, 1-10, evidence for each. Fight stills on the game camera:
`ziva_pure_clip/` (after) and `ziva_layers_clip/` (before); board reference: `board_rokoko_21/` and `board_vs_fight/`.

| # | Row | Grade | Evidence (frame / number / still) |
|---|---|---|---|
| 1 | **The new clips** (jab, cross, guard) as played | **7/10** | Raw/board: jab guard pelvis 0.917, lowest 0.876 (a 4.1 cm dip of its own), knee lowest 122.5, shoulder line swings 61.6 deg off its start - a real jab. In the fight the guard reads clean (the take's own idle holds the shoulders within 1.8 deg and the head within 0.2 cm of the take, which is why S271 faded the synthetic bob) and the jab/cross read as straight punches at head height. Held back by: the entry join (below), the 11-21 cm stature the board promised and does not deliver, and the guard's fists sitting slightly wide of the chin at the pocket. Stills: `ziva_pure_clip/key_f0150.png` (a jab/cross exchange), `pelvis_f0474_sidea.png` (the worst crouch of the run). |
| 2 | **The old clips beside them** | **4/10** | The five that hurt most, by the join census on the full palette bout (`throw_f2` joins, deg in ONE frame, against the outgoing clip's own p90 per-frame motion): **1. `boxing_lead_hook` - 59.7-60.2 deg into the idle (2.1x its own motion), the worst join in the build**; **2. `boxing_slip` - 22.3-28.3 deg at both ends (up to 2.5x)**; **3. `boxing_catch` - 19.8 deg into the jab**; **4. `boxing_cross_body` - the deepest knees of the whole bout (median 99.9, min 91) and a 104-frame span spent 3 cm lower than the jab**; **5. `boxing_rear_hook` - 0.978 m pelvis on its own (a hop), 0.904 median, and a 116 deg hips turn**. Nothing else in the old set is as bad as these five. |
| 3 | **3D fight realism as a whole** | **5/10** | *Spacing:* the pair is inside 0.80 m head-to-head on 45 % of frames before the fix and 20 % after, with the worst at 0.50-0.52 m - chest-to-chest, gloves above heads, reads as grappling, and range is the one thing a boxing player reads first ("footwork and range are the game", research/CLIPREVIEW1_KALLI.md). *Feet:* joins move a foot 2.3-4.5 cm (idle->jab) and the captured takes themselves plant clean (the take's own plants, pooled IoU 0.70); the retargeted old clips still need the lock, which is why it stays on for them. *Head:* the captured guard holds the head steady (the trace's own 5.2 cm -> 0.2 cm on the take); the hit snap and flinch are subtle and read as a head snap in the stills. *Weight transfer:* the capture's own, now that punch load is off over it; the old clips' load remains synthetic and small (3 cm pelvis shift). *Reactions:* the stagger/ragdoll is present but the receiving man's guard rarely breaks in the recorded 20 s (palette bout: no knockdowns). *Broadcast look:* the 22 deg ringside camera, the dimmed corner card and the impact tag are the build's strongest realism asset (item 9/10 of ZIVA9). Compared with the reference bar (Fight Night/Undisputed's readable weight transfer and range-first footwork, research/CLIPREVIEW1_GROK.md, KALLI.md): the punches now reach the bar, the spacing and the stature do not. |
| 4 | **The blending** (operator: "but they need blending ?") | **5.5/10** | Measured per join over the two new-clip runs (worst tracked bone among both upper arms and both forearms, angle between the last frame of one take and the first of the next; foot pop = the larger foot's move in that same frame): **into the new clips the joins are the best in the build** - `boxing_jab -> idle` 1.3-13.9 deg at **0.00 cm** foot pop (0.1-0.8x the jab's own per-frame motion, i.e. invisible), `idle -> boxing_jab` 9.8-11.5 deg (RightForeArm) at 2.3-4.5 cm (up to 9.8x a slow idle's own motion - a visible snap), `boxing_jab -> boxing_cross` 22-24 deg (1.3x), `boxing_slip -> boxing_cross` 26.5 deg, `boxing_lead_hook -> idle` 59.7-60.2 deg. Verdict on the blend TIMES: the default join is ~0.10 s and that is fine - the pops are all at the FIRST frame of the join, which means the join starts from a pose the previous take was not in (and, for the hook, from a take whose own end is 60 deg away). More blend time would smear the punch; the fix is pose-matched joins for the captured takes (they share guard endpoints already) and one entry blend for idle->jab. |

**Overall: 5.5/10** - a Steam reviewer's line: *the new mocap punches are visibly better than everything else in the ring,
but the men are not the size the studio render promised, half the exchanges end with their heads touching, and the old
defence clips clang.*

---

# TOP THREE FIXES, rating gained per hour

1. **`mocap_pure`** (LANDED, ~1 h): every captured take now plays as captured; the pressed heads are 45 % -> 20 % of frames
   and 41 cm better at the same frame, and the arms/curl/head hygiene applies to every future captured clip for free.
   Gains rows 1 and 3, and is the precondition for sourcing more clips (each new capture lands clean).
2. **The stature mismatch between the board and the fight** (proposal P1, ~30 min as a render-tool change): draw the board
   at the fight's scale, or decide the heavies' scale policy. This is the single largest visual mismatch measured in this
   report (0.892/0.949 vs 1.000; 21 cm and 10 cm) and it is the one the operator has already reacted to twice.
3. **Pose-matched joins for the captured set + retire the lead hook** (~2-3 h): kills the 10-11 deg / 2.3-4.5 cm entry pop on
   every jab and the 60 deg lead-hook exit, i.e. rows 4 and 2, and it is the difference between "the clips are good" and
   "the fight is smooth".

---

# Evidence index

| what | where |
|---|---|
| raw-clip numbers (board path, bodies 09+04) | `tools/ziva_raw_clip_probe.gd`, `/e/FightCamp/tmp/zr1/raw_rows.csv` |
| fight / studio / per-layer numbers | `tools/ziva_squat_probe.gd`, `/e/FightCamp/tmp/zr1/{op20_baseline,fight_phase,pure_on,pure_off,movie,movie_off,arm_off_*}.csv` |
| the scale | `ziva_squat_probe` `node_scale` column; `scripts/FightWorldStage.gd:200`; `scripts/FighterPhysique.gd:87` |
| A/B stills + sheets | `docs/previews/s272_fight/ziva_pure_clip/`, `.../ziva_layers_clip/` |
| the operator's clip, fixed | `docs/previews/s272_fight/fight_20s_rokoko_pure_ziva.mp4` |
| red test | `tests/mocap_pure_test.gd` (12 checks, 0 failures); regression `tests/rokoko_clips_test.gd` PASS |

House notes for whoever re-runs this: `record_room` + `--fixed-fps 30` + `--write-movie` is the only honest clock; a
`--script` test run does not read `GAME_ON` switches unless it is given `-- as_game` (my own test's first red line, learned
here); `off=<switch>` reaches room options and `GameSwitches.on` reads user args as `<switch>=0`, which is a different arm;
one Godot run at a time, watchdog first.