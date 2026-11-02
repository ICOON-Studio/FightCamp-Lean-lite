# ZIVA_ROKOKOMOVES_S274 (ROKOKOMOVES1) - the guard is long captured windows on one clock; the body cross is the actor's

Model: Ziva (Godot editor seat, wt/ZIVA, effort MAX). Branch `ziva/playtest` (Part A `fb93cb7e`, Part B row 1 `01282d02`),
merged with `origin/master` fabfeef4 (GuardClock) and ab8d4d33 (this brief). Discipline: BOXING (demo).
Datum: bodies 09,04 / body 04, seed 94301, 20 s, fixed 30 fps. Reports: `ZIVA_GUARD_S274.md` (ZIVAGUARD1), brief
`TASK_ROKOKOMOVES1.md`, Arena's `TASK_GUARDCLOCK1.md`.

## 0. What was asked, and what is in this branch (start here)

**Part A** - the guard is long captured takes that cross-fade, never a 2 s loop, and a punch does not restart it.

**Part B, the priority change (Claude + operator, mid-task):** the operator watched the 20 s before/after, *"0:14-0:18 it
shows that it transition to other animation is far from smooth"*, and the fight session measured why: blue's
`boxing_cross_body` played 13.7-14.9 s with the pelvis 0.77-0.92 m and the feet 0.21 -> 0.83 m and then cut into the captured
jab at 15.0 s - two different actors joined in ~0.3 s. **That row is replaced** (section 4). The two hooks were hunted and
**kept on their current clips with the measurement** (section 5) - the task's own escape hatch.

Both are in `previews/rokokomoves1/s274_rokokomoves_ba_14_18.mp4` (and a 4-row sheet beside it): **left = the
committed clips-only base the operator watched, right = this branch**.

## 1. Part A - the guard is TWO long FightingIdle windows on GuardClock (not our own clock)

`FightClipRokoko.GUARD_VARIANTS` is the idle role's TAKES (take 0 keeps the bare `idle` name, so no consumer learns a new
one). Measured with `tools/rokoko_step_finder.gd guard=1` on the game's own Mixamo -> MetaHuman build:

| window | length | fist peak | windows measured `row=1` on mh_boxer_08: head-over-hips | stance max |
|---|---|---|---|---|
| FightingIdle 9.23-18.17 s | 8.93 s | 0.500 m | **0.652-0.657 m** (5 mm) | 0.58 m |
| FightingIdle 35.70-45.00 s | 9.30 s | 0.497 m | **0.654-0.658 m** (5 mm) | 0.61 m |
| ~~ShadowBoxing 11.93-17.13 s~~ **DROPPED** | 5.20 s | 0.482 m | **0.468-0.653 m (185 mm!)** | **0.91 m** |

**The dropped third window is a finding, not a preference.** The ShadowBoxing window holds the fists at the chin (its 0.482 m
fist peak passes the guard's own gate) but the actor CROUCHES inside it: head over hips runs 185 mm against the FightingIdle
windows' 5 mm, its stance reaches 0.91 m against the guard's 0.58-0.61, and its facing (yaw_deg 71.4) is ~70 deg off the other
two - so every turn of the sleeve to it turned the man 70 deg and dropped his head. It is a shadow-boxing stretch, not a
guard take. This was caught by the suite's own as_game arm, not by eye: the "no added bob" gate read **0.189 m** with three
windows and **0.002 m** with two - the board's own `rk_FightingIdle` reads 0.002 m (S274 rokoko_neck_probe).

**The clock is not ours.** `scripts/rules/GuardClock.gd` (Arena's GUARDCLOCK1, merged while this seat worked) is the ONE
clock. `FightStagePlayer` only asks it: `start()` on bind - seeded from the body's own node name so the two men do not guard
in lockstep - `advance()` every frame, `at()` for the take and the entry position. The player's hooks are thin on purpose:
`_guard_tick` (one call + the cross-fade), `guard_state()` (its `at()`), `guard_cycle_s()`, `guard_clock_s()` (telemetry), and
the resume hook in `_play_single_role` (the idle role enters on the clock, never on the round robin).

The clock runs whether or not the guard is on screen, and that IS the resume. As played, `-- as_game`:

```
ROKOKO_GUARD_RESUME away=0.5s (clock ran 0.70 s) window 0 5.98s -> window 0 6.68s (guard clock 29.87 -> 30.57); body plays 6.681s in idle
ROKOKO_GUARD_RESUME away=2.5s (clock ran 2.50 s) window 1 1.01s -> window 1 3.51s (guard clock 33.53 -> 36.03); body plays 3.507s in idle#1
ROKOKO_GUARD cycle=18.24s frames=578 fist_peak=0.475 m windows=2 tour=[0, 1, 0]
ROKOKO guard as played: head over hips range 0.002 m max=0.015 (no added bob)
```
`away=0.5 s` runs 0.70 s of clock because a CAPTURED PUNCH PLAYS WHOLE (master's `_whole_hold_s`: *"let captured punches
finish their recovery"*) and the guard is refused until the punch's recovery ends - the test waits for the guard and measures
the away time that actually elapsed, so the gate stays exact: **the guard resumes at position + time away, 6.681 s for
6.681 s, never at the window's first frame.**

### The two bugs the new gates found on the way (both in the captured path, both fixed)
1. **A sliced guard window came back LOOP_LINEAR.** `FightClipSlice.slice` copies the source's loop mode (line 57) and the
   Mixamo takes import looping, so the guard wrapped every window - the very rhythm Part A removes. `load_animation` now sets
   the cut's loop mode from the role's own flag.
2. **Every captured punch built as the WHOLE 18.9 s Boxing file.** The graft's take spec carries `start_s`/`end_s` as -1.0 for
   a whole-strike role (`strikes_play_whole`) and `load_animation` was reading them as the window. It now reads only the
   `rk_*` window: the jab is 0.670 s again (aim -0.0 deg), the cross 0.670 s.

## 2. The instrument that did Part B: `tools/rokoko_step_finder.gd row=1`

Cutting a row by eye and then finding out it fails a gate is the expensive way. `row=1 hand=R|L t0= t1= [row_frames=1]`
measures a candidate window on the game's own build in the exact frames the tests read: guard in/out (each fist to the Head
bone), stance max, hips drop, head over hips, and at the fist's most-ahead frame the `ahead`/`dy` (in the body frame the test
builds at the window's first frame), the elbow joint angle, and the punch's own travel yaw off +Z - which IS the row's
`yaw_deg`, negated. `body=08` measures on the body the suite uses.

```
... --script tools/rokoko_step_finder.gd -- body=08 take=ShadowBoxing row=1 hand=R t0=11.03 t1=12.13
ROW ShadowBoxing Right 11.03-12.13 s (1.10 s) guard_in 0.40/0.41 guard_out 0.23/0.32 stance_max 0.79 hips_drop 0.087
  head_over_hips 0.652-0.660 | most_ahead 11.80 s ahead 0.46 dy -0.40 elbow 149 travel -86.2 (yaw_deg 86.2) reach 0.54 lat -0.16 fore -5
```

## 3. The body cross - what the row is, and the one window that was rejected

`FightClipRokoko.ROLES["boxing_cross_body"]` = **ShadowBoxing 11.03-12.13 s** (1.10 s), `yaw_deg 86.2`, `contact_s 0.77`.
The role was the Ramsterz `H2H_StraightPunchInPlace` retarget carrying a hand-authored Hips/Spine pose layer (drop_frac
0.07). `FightStagePlayer` **replaces** the binding with the Rokoko metadata (L1922-1924), so the pose layer, foot locks and
strike warp of the old clip cannot follow the captured take - no hand-authored layer is left on it (the brief's trap).

The window was picked by measurement. **Rejected first: 10.97-12.13.** Same rear hand at the start (0.40 m) but its dip reads
**0.108 m**, 8 mm over the brief's hips gate, so the window starts where the take's hips are still high (11.03). What the row
gates on, on the test's own body:

| gate | RAW (the take) | PLAYED (`-- as_game`) |
|---|---|---|
| starts and ends in guard (fists to the head, gate 0.50) | 0.40/0.41 -> 0.23/0.32 | - |
| lands BELOW the head (gate <= -0.20) | -0.401 m | -0.469 m |
| fist in front of the head (gate >= 0.20) | 0.455 m | 0.380 m |
| a straight, not a hook (elbow gate >= 140) | 149.1 deg | 118.5 deg - **report-only, see below** |
| stance (gate <= 0.80) | 0.79 m | 0.79 m |
| hips drop (gate <= 0.10) | 0.087 m | 0.078 m |
| one punch (gate <= 1.20 s) | 1.100 s | 1.100 s |
| drives at the opponent (gate <= 12 deg) | - | aim -8.9 deg |

**Why the played elbow is reported and not gated: the game plays a tracked punch at the fighter's own tempo.** With
`human_speed_tempo=0` the same measurement reads elbow 132.1 and the last-frame rear hand 0.32 m (the take's own value); as
shipped it reads 118.5 and 0.55 m, because `_apply_human_speed_tempo` + `_begin_onset_warp` mean the played pose at the row's
contact TIME is not the take's pose at that time (the reached-arm peak moves 0.733 -> 0.867 s). A pose-at-a-clip-time gate on
the played body would be reading the tempo, not the row; the take's own shape (a straight) is gated on the RAW cut, and the
played arm is gated on the time-robust quantities (where the fist lands, the feet, the hips, the drive).

## 4. The A/B the operator asked for (0:14-0:18, seed 94301, bodies 09,04)

`docs/previews/rokokomoves1/s274_rokokomoves_ba_14_18.mp4` - left = **the committed clips-only base** (the right half of the
operator's own `s274_before_after.mp4`: the state they watched), right = **this branch**, same seed, same bodies, the
studio's own camera, no text over the men. `..._ba_14_18_sheet.jpg` is the same four moments as a sheet.

Measured on the render's own `clip_log=1` (`CLIP f=` every 10 frames), man B / blue:

| t | BEFORE (from the fight session's own measurement) | AFTER (this branch) |
|---|---|---|
| 13.7 s | `boxing_cross_body` pelvis **0.77 -> 0.92 m** inside the clip, feet **0.21 -> 0.83 m** | `boxing_cross_body` (captured) pelvis 0.883 -> 0.764-0.795, stance 0.57 -> 0.76 |
| 15.0-15.3 s | cuts into the captured jab (upright, feet 0.18 m) | `boxing_cross_body` -> `boxing_cross`: pelvis 0.759 -> 0.823 (**64 mm**), stance 0.76 -> 0.67 |
| 16.3 s | the native `boxing_lead_hook` stands **0.944 m** pelvis against the guard's 0.90 ("pops") | `boxing_cross` -> `boxing_jab`: 0.843 -> 0.869 (26 mm); the hook is still played at 9.0 s (section 5) |

Every join of man B in 13.5-18.5 s, from the same log: 13.67 s idle#1 -> cross_body **-18 mm**; 15.33 s cross_body -> cross
**+64 mm**; 16.00 s cross -> jab +26 mm; 17.33 s jab -> cross +20 mm; 18.00 s cross -> jab +29 mm. For scale, the fight's other
joins in the same 20 s are 44-92 mm apart (idle -> cross 64 mm, jab -> idle#1 59 mm, cross -> lead_hook **92 mm**): **the
flagged join is now an ordinary one, and the 150 mm rise + the 0.62 m foot move + the chest-to-chest pitch are gone.** The
residual 64 mm is the ShadowBoxing section's own guard level (the actor stands lower there, hips 0.75-0.77 against
FightingIdle's 0.90) meeting the Boxing take's cross - a level difference between two of the actor's own takes, and the same
size as the joins the fight already has.

The right-hand side of the mp4 is not only this row: it is master's own newer fight (FIGHTLINK2B's punch choice) + Part A's
guard + this row, so the pair standing further apart and more upright in the AFTER is partly the fight session's own pairing
work, not this row.

## 5. The hooks - hunted, measured, and KEPT on their current clips (the task's own escape hatch)

The takes' punches are 10, and only three are lead/rear swings that come from the side at head height (`row=1` + the trace):

| candidate | fist | elbow at the landing | verdict |
|---|---|---|---|
| Boxing 9.30-10.23 (landing 9.47) | 0.65 m across at head height, 0.37 m ahead, guard-to-guard, stance 0.78, hips drop 0.053, 0.93 s | **146 deg, and 165 deg at the widest (9.70)** | a WIDE STRAIGHT - the arm straightens through the landing |
| Boxing 12.90-13.80 (landing 13.37) | 0.71 m across, 0.45 m ahead | **169 deg** | a wide straight |
| ShadowBoxing 19.03-19.47 (the "rear uppercut load" the operator flagged in S272) | elbow **125 deg** (bent - the only one) | 0.12 m ahead of the head (gate 0.20), **stance 0.95 m** (gate 0.80) | fails the reach and the stance |

`boxing_lead_hook` and `boxing_rear_hook` therefore keep their current clips (`H2H_HookPunch_InPlace.FBX` and
`Boxing_Back_Hand_Hook.glb`) and are listed here, as the task allows. The one number to hand the fight session: the native
lead hook still makes man B's pelvis jump to **0.944 m** against the guard's 0.90-0.92 (the operator's second pop, at 9.0 s in
this seed rather than 16.3 s) - a captured hook does not exist in these takes, so that pop needs a different cure.

## 6. Tests

```
python Godot/tools/run_tests.py --only rokoko_clips_test,mocap_pure_test,punch_retime_test,fight_clip_slice_test,guard_clock_test,guard_pose_test,guard_ik_pass_test,guard_face_clear_test,guard_wrist_line_test,guard_clip_ramp_test,fight_guard_contract_test --verbose [--as-game]
```
**plain SUITE total=11 fails=0; `--as-game` SUITE total=11 fails=0.** `rokoko_clips_test` gained: the sleeved guard (>= 2
long windows, none loops, fist peak <= 0.50 over the whole 18.24 s cycle, the windows TOUR in order and never sit on one, the
bob gate, the resume at both away times) and the body-cross row's gates in section 3. All new gates were RED before their
row: the guard gates on the 2 s loop (no variants, LOOP_LINEAR), the body gates on `H2H_StraightPunchInPlace`.

The suite's `--as-game` arm is why the third guard window and the played-elbow question were found at all: run the new gates
plain AND as_game before believing them.

## 7. Renders (all with `--quit-after`; stills only through `still_framing.save_if_framed`)

```
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --fixed-fps 30 --resolution 1920x1080 \
  --write-movie E:/FightCamp/tmp/rokokomoves1/after.avi --quit-after 600 --script tools/fight_studio_render.gd \
  -- as_game seed=94301 bodies=09,04 clip_log=1 stills=<dir> still_every=15
```
38 stills, every one logged `STILL_FRAMING OK ... shot=broadcast`; `docs/previews/rokokomoves1/stills/guard_*_f04*.png` are
the 14-17 s frames quoted above (both men head to feet, boots on).

## 8. Files this seat changed

| file | change |
|---|---|
| `scripts/FightClipRokoko.gd` | `GUARD_VARIANTS` = the two long FightingIdle windows (the ShadowBoxing window measured, dropped and recorded); the `boxing_cross_body` row; `_window()` take specs; `load_animation(meta, skel, take)` reads the `rk_*` window only and sets the cut's loop mode |
| `scripts/FightStagePlayer.gd` | the guard sleeve: `_guard_sync` (GuardClock.start, seeded per body), `_guard_tick` (GuardClock.advance, the cross-fade, the entry seek), `guard_state`/`guard_cycle_s`/`guard_clock_s`, the resume hook in `_play_single_role`, the seed in `bind` |
| `tests/rokoko_clips_test.gd` | the guard gates (sleeve, tour, fist peak, bob, resume), the body-cross gates (RAW + played), `_await_guard` (a whole punch is refused the guard) |
| `tools/rokoko_step_finder.gd` | `row=1` (+ `row_frames=1`, `body=`) - the candidate-window instrument of section 2 |
| `docs/previews/rokokomoves1/` | the 14-18 s before/after mp4, its sheet, the stills |

## 9. What a future pass should do next (measured, not guessed)

1. **The body shot's twin.** `boxing_jab_body` (Long_Body_Jab) and `boxing_body_hook` are still vendor clips; ShadowBoxing
   4.00-4.60 s is a measured rear body straight (dip -0.22 m) but it is a COMBO (the lead hand drops 0.71 m), so it needs the
   same guard-to-guard cut and the same gates as the row above.
2. **The combos as one clip each** (the brief's Part B list): the labels' 5 combos are all "the other hand loads the next
   punch" - each one is a candidate for a single two-punch row, cut guard-to-guard, gated the same way.
3. **The lead hook's pop has no captured cure in these takes** (section 5). If the operator wants it gone, the row has to come
   from another allowed source (ActionForge) or the native hook's level has to be fixed on its own clip.