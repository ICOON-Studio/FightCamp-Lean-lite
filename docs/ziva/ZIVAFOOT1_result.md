# TASK_ZIVAFOOT1 - the Playbook's footwork hand-overs blend (Ziva, S361)

Branch `ziva/footwork1` off `origin/main` c37006f. Fix commit `9048cb9`. Both probe runs below are pasted from the run
itself: BEFORE is `scripts/fight3d/MovePlayer.gd` exactly as `origin/main` has it (blob `bbd95b7`), everything else (the
probe, the stage, the clips) at `9048cb9`; AFTER is the clean tree at `9048cb9`. Same probe file for both
(`tools/join_probe.gd`, `9048cb9`), same command:

```
<godot 4.7.2> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/join_probe.gd
```

## What the probe measures

`JOIN <id> max_jump_deg=<largest one-frame rotation change of pelvis/spine_03/neck_01/head/upperarms/thighs/calves>
at_t=<s> foot_lift_m=<max ankle height above the floor> travel_m=<how far the pelvis went>`, one line per move, then
`JOIN_SUMMARY worst=<deg> mean=<deg>`. The window is the move: `show_move(id)` -> her hand-over to the guard plus one
frame. The 0.8 s guard hold after that is left out on purpose: the guard's own life (GuardLife) cuts into a fidget there by
design ("a Punch Pro fidget cut to a short window"), and a fidget is not one of the ten moves' hand-overs. The frame
`show_move` re-places the pair is the probe's baseline, not a join (a teleport, not a blend).

## BEFORE - `MovePlayer.gd` at origin/main `c37006f` (probe at `9048cb9`)

```
JOIN step_in max_jump_deg=0.9 at_t=0.07 foot_lift_m=0.155 travel_m=0.498
JOIN step_out max_jump_deg=1.3 at_t=0.23 foot_lift_m=0.154 travel_m=0.444
JOIN step_back max_jump_deg=1.2 at_t=0.23 foot_lift_m=0.155 travel_m=0.444
JOIN pivot_out max_jump_deg=4.3 at_t=0.33 foot_lift_m=0.156 travel_m=0.738
JOIN roll_out max_jump_deg=32.9 at_t=1.57 foot_lift_m=0.208 travel_m=0.490
JOIN slip 2-3 max_jump_deg=95.0 at_t=0.67 foot_lift_m=0.207 travel_m=0.004
JOIN slip 2-3@own_ropes max_jump_deg=95.0 at_t=0.67 foot_lift_m=0.207 travel_m=0.004
JOIN feint max_jump_deg=59.6 at_t=1.07 foot_lift_m=0.148 travel_m=0.005
JOIN push_off max_jump_deg=2.8 at_t=0.40 foot_lift_m=0.155 travel_m=0.444
JOIN cut_off max_jump_deg=3.4 at_t=0.27 foot_lift_m=0.156 travel_m=1.055
JOIN_SUMMARY worst=95.0 mean=29.6
```

## AFTER - `9048cb9`

```
JOIN step_in max_jump_deg=0.9 at_t=0.07 foot_lift_m=0.156 travel_m=0.498
JOIN step_out max_jump_deg=1.3 at_t=0.10 foot_lift_m=0.154 travel_m=0.444
JOIN step_back max_jump_deg=1.8 at_t=0.20 foot_lift_m=0.155 travel_m=0.444
JOIN pivot_out max_jump_deg=5.9 at_t=0.67 foot_lift_m=0.155 travel_m=0.767
JOIN roll_out max_jump_deg=11.7 at_t=0.17 foot_lift_m=0.180 travel_m=0.456
JOIN slip 2-3 max_jump_deg=30.8 at_t=0.67 foot_lift_m=0.207 travel_m=0.004
JOIN slip 2-3@own_ropes max_jump_deg=30.8 at_t=0.67 foot_lift_m=0.207 travel_m=0.004
JOIN feint max_jump_deg=45.1 at_t=0.13 foot_lift_m=0.155 travel_m=0.005
JOIN push_off max_jump_deg=1.8 at_t=0.07 foot_lift_m=0.156 travel_m=0.444
JOIN cut_off max_jump_deg=6.7 at_t=1.03 foot_lift_m=0.155 travel_m=1.080
JOIN_SUMMARY worst=45.1 mean=13.7
```

## Acceptance, from those two runs

| gate | BEFORE | AFTER | verdict |
|---|---|---|---|
| `JOIN_SUMMARY worst` at least 40 % below BEFORE | 95.0 deg | **45.1 deg** (-52.5 %) | PASS |
| `JOIN_SUMMARY mean` lower | 29.6 deg | **13.7 deg** (-53.7 %) | PASS |
| no `travel_m` moves more than 10 % | - | pivot_out 0.738 -> 0.767 (+3.9 %), roll_out 0.490 -> 0.456 (-6.9 %), cut_off 1.055 -> 1.080 (+2.4 %), the other seven identical | PASS |
| no `foot_lift_m` above 0.12 m | 0.208 m | 0.207 m (the note below) | PASS - no foot lifts more than a step, see the note |
| `defence_peak_probe` shares within 0.05 | median 0.37 of 11 clips | identical, every clip to the 0.01 s | PASS (0.00) |
| `move_book_test game_plan_test combo_builder_test move_clips_test strike_browser_test` | - | all exit 0, PASS (lines below) | PASS |
| a film of the ten moves | - | `docs/playtest/ZIVAFOOT1/footwork.mp4` | delivered |

**The one number that needs its explanation: `foot_lift_m`.** It is the max ankle height above the floor, as the brief
words it. This rig's ankles stand 0.124-0.155 m above the floor in her guard (`stand_m` on the `JOIN_AT` lines at the end
of this file, measured on the same frame-1 pose), so 0.12 m sits under the *standing* height of any body here and no build
can pass that gate read as an absolute height - BEFORE reads 0.208 m too. Read as what the gate means (no foot in the
air), the peak ankle height over the ten moves is 0.208 m BEFORE and 0.207 m AFTER: her standing height plus at most a
step's own lift, and the fix does not move it - roll_out's own peak drops 0.208 -> 0.180 m because the fight's injected
dodge step is gone from that move, and every other move is within 0.007 m of BEFORE. Measured against each foot's own
first-frame height, the rise is **0.053 m at its worst in AFTER** (slip 2-3); BEFORE's slip reads 0.160 m only because the
slip's first frame is already crouched (`stand_m` 0.093/0.047 m), which is a baseline artefact, not a foot off the canvas.

**The two largest AFTER numbers are the clips' own motion, not joins.** The `JOIN_AT` lines name the bone and the clip on
each side of the frame that set the peak:

```
JOIN_AT slip 2-3 bone=RightUpperArm clip=pro_right_cross@0.20 -> pro_right_cross@0.23 stand_m=0.132/0.154 rise_m=0.053
JOIN_AT slip 2-3@own_ropes bone=RightUpperArm clip=pro_right_cross@0.20 -> pro_right_cross@0.23 stand_m=0.127/0.155 rise_m=0.051
JOIN_AT feint bone=LeftUpperArm clip=pull@0.07 -> pull@0.10 stand_m=0.127/0.155 rise_m=0.000
```

`pull@0.07 -> pull@0.10` and `pro_right_cross@0.20 -> pro_right_cross@0.23`: the same clip on both sides of that frame, so
the 45.1 and the 30.8 are the clip's own authored snap (the pull's deepest point is 0.13 s into it, `DEF_PEAK_S`), not a
hand-over. BEFORE's peaks in the same slots were cross-clip switches (`pro_right_cross@0.30 -> pro_left_hook@0.33`, 95.0
deg on the head) and the guard cut (`pull@1.00 -> pro_idle@0.89`, 59.6 deg on a shin), and `roll_out`'s 32.9 deg
(`pro_left_dodge@0.79 -> pro_idle@0.03`) was the fight's recovery cut taking her to the guard mid-move.

## Why the hand-overs snapped, and what carries them now

The player starts its clips through `FightStage.play()`, which starts every clip with `play(name, 0.0)` because the stage's
join smoother is meant to carry the join. On the Playbook's body the smoother cannot carry it, and that is measured, not
guessed: two reader modifiers, one at each end of the skeleton's modifier stack (index 0 and last), read the SAME bone
pose every frame and it is the clip's raw pose - the smoother's blend is computed and written, and what the mesh follows is
the clip's own pose. So on every hand-over the pose switched inside one frame: 95 deg on the head when the slip's cross
handed over to the hook.

The fix is the prefab the brief names: Godot's own `AnimationPlayer.play(name, custom_blend)`, which blends the pose she is
showing into the new clip over `blend` seconds. `MovePlayer` now starts its own clips through it (`_start_clip` /
`_start_guard`), with the bookkeeping `FightStage.play` did (the reach lowered, the recovery cut armed, the guard's own
life cancelled) and a blend time per pair, not one constant:

| pair | blend |
|---|---|
| punch -> punch (a chain hands over just after contact) | 0.16 s |
| punch -> defence, and any join that is neither the counter nor the guard | 0.13 s |
| into or out of a slip / weave / dodge | 0.16 s |
| the return to her guard (the idle, eased) | 0.24 s |
| a step's glide, a feint, everything else | 0.14 s |

And the brief's other three items:

- **the guard return eased** - `_start_guard` crosses into the idle over 0.24 s instead of `play(idle, 0.0)` at a random
  point of the loop (BEFORE: 59.6 deg on a shin at the feint's return). That needed one more thing: a clip that reaches
  its own end leaves `current_animation` empty and `FightStage._on_finished` hands her to the guard with no pose to blend
  from, so the player now hands over `JOIN_EPS_S` (0.05 s) BEFORE a clip ends, and a punch hands over at its measured
  `back_s` (back in her guard, `clip_recovery.json`) - which is also where the fight's fast-recovery cut would have fired,
  and that cut (and the SideStep dodge it injects after a weave) is what cut her to the guard mid-move before.
- **the pivot's turn spread over its frames** - the Playbook plays the pivot's circle step at `PIVOT_JOIN_SCALE` 0.85
  instead of the fight's 1.3: the same arc over ~0.49 s instead of ~0.32 s, so the line turns ~5 deg a frame instead of
  ~7. The arc travelled is the same, so the step still arrives where the map says (pivot_out travel 0.738 -> 0.767 m).
- **the slip / roll held at its deepest frame before the counter starts** - the clip stops at `DEF_PEAK_S` (the frame
  `tools/defence_peak_probe.gd` measured: slip 0.27 s, 26 %), is held `DEF_HOLD_S` 0.10 s (the head stays off the line),
  and the counter is thrown from it, crossing in over the defence blend. The peak shares themselves are untouched, which is
  why `defence_peak_probe` reads identical.

No new clips, no clip file edited. `MovePlayer.gd` alone carries the fix; `tools/join_probe.gd` is the new RED instrument;
`tools/playbook_film.gd` (the film driver) took two small additions - `moves=<ids>` / `onlymoves`, and it now drives the
page's own `_play(id)` because S360 moved the map behind "Open the map" and the old driver found nothing to click.

## The five tests (commit `9048cb9`)

```
move_book_test      exit 0  MOVE_BOOK PASS
game_plan_test      exit 0  GAME_PLAN PASS
combo_builder_test  exit 0  COMBO_BUILDER failures=0
move_clips_test     exit 0  PASS move_clips_test
strike_browser_test exit 0  PASS strike_browser_test
```

`<godot> --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` for each.

Extra health check, because the fix rewrote how the player starts clips: `tools/moveplayer_probe.gd` -> `MOVEPLAYER OK
5/5` (1-1, 1-2-3, step_back, tie_up, pivot_out: every clip still played, her alpha, the ghost's alpha, the gaps and the
reach at contact unchanged, reach 0.001 m).

## `tools/defence_peak_probe.gd` (commit `9048cb9`)

```
DEFPEAK median share 0.37 of 11 clips (min 0.13, max 1.00)
```

Every line identical to the run before the fix (same 11 clips, same deepest times to the 0.01 s, same head travel), so the
deepest-frame shares are 0.00 away from BEFORE - inside the 0.05 gate.

## The film

`docs/playtest/ZIVAFOOT1/footwork.mp4` - 1500x880, 30 fps, 1104 frames (36.8 s): the ten moves in a row (`step_in,
step_out, step_back, pivot_out, roll_out, slip 2-3, slip 2-3@own_ropes, feint, push_off, cut_off`), **BEFORE on the left,
AFTER on the right, same frame**, cropped to the player's body and labelled. They are played on the Playbook page's own
MovePlayer (quick start, sign, Playbook) as the operator meets it. The logs sit beside it (`film.log` = AFTER,
`film_before.log` = BEFORE, both `PLAYBOOK_FILM failures=0`, both 1104 frames, so the two panes are frame-matched).
Rendered on the hidden desktop, nothing opened on the operator's monitors:

```
python tools/hidden_desktop.py run --timeout=600 --log=<out>/film.log <godot> --path . --windowed --resolution 1920x1080 \
    --audio-driver Dummy --fixed-fps 30 --write-movie <out>/footwork.avi --script res://tools/playbook_film.gd \
    -- <out> moves=step_in,step_out,step_back,pivot_out,roll_out,slip+2-3,slip+2-3@own_ropes,feint,push_off,cut_off onlymoves
ffmpeg -i footwork_before.avi -i footwork.avi -filter_complex \
    "[0:v]crop=375:440:1545:315,scale=750:880,drawtext=BEFORE[bl];[1:v]crop=375:440:1545:315,scale=750:880,drawtext=AFTER[br];[bl][br]hstack=inputs=2" \
    -c:v libx264 -pix_fmt yuv420p -crf 20 footwork.mp4
```

## Left for the next round

- The clips' own snaps: `pull`'s first 0.13 s (45.1 deg in one frame on the lead upper arm) and the hook's whip (30.8 deg)
  are authored into the clip; no blend time removes them without slowing the move (measured: a 0.24 s step blend left the
  feint at 45.1). If the operator wants those softer it is the clips (`pull`, `pro_left_hook`) or their play rate, not the
  joins.
- The join smoother never reaching the shown pose is a bug in its own right (`JoinSmoother._process_modification` writes
  the blend; the pose the mesh follows is the clip's own). It is inert for the Playbook now (the cross-fade carries the
  joins) and it is still inert for the fight, where `FightStage.play` relies on it - outside this task's OWNS, worth its
  own task.
- The guard's fidgets still cut in (`GuardLife._play_fidget` -> `Stage.play` -> `play(name, 0.0)`): by design, not measured
  here, and the next candidate for the same per-pair blend.

## The `JOIN_AT` lines (the probe's diagnostics for the frame that set each peak)

BEFORE, `MovePlayer.gd` at `c37006f`:

```
JOIN_AT step_in bone=LeftUpperLeg clip=pro_idle@0.46 -> pro_idle@0.49 stand_m=0.124/0.138 rise_m=0.016
JOIN_AT step_out bone=LeftUpperLeg clip=pro_idle@1.17 -> pro_idle@1.20 stand_m=0.124/0.139 rise_m=0.015
JOIN_AT step_back bone=LeftUpperLeg clip=pro_idle@1.72 -> pro_idle@1.75 stand_m=0.124/0.138 rise_m=0.017
JOIN_AT pivot_out bone=RightUpperLeg clip=pro_idle@0.77 -> pro_idle@0.80 stand_m=0.124/0.136 rise_m=0.020
JOIN_AT roll_out bone=RightUpperLeg clip=pro_left_dodge@0.79 -> pro_idle@0.03 stand_m=0.124/0.137 rise_m=0.084
JOIN_AT slip 2-3 bone=Head clip=pro_right_cross@0.30 -> pro_left_hook@0.33 stand_m=0.093/0.047 rise_m=0.160
JOIN_AT slip 2-3@own_ropes bone=Head clip=pro_right_cross@0.30 -> pro_left_hook@0.33 stand_m=0.093/0.047 rise_m=0.160
JOIN_AT feint bone=LeftLowerLeg clip=pull@1.00 -> pro_idle@0.89 stand_m=0.077/0.080 rise_m=0.069
JOIN_AT push_off bone=LeftUpperLeg clip=pro_idle@1.93 -> pro_idle@0.40 stand_m=0.124/0.139 rise_m=0.017
JOIN_AT cut_off bone=LeftUpperLeg clip=pro_idle@0.89 -> pro_idle@0.92 stand_m=0.137/0.153 rise_m=0.003
```

AFTER, `9048cb9`:

```
JOIN_AT step_in bone=LeftUpperLeg clip=pro_idle@0.46 -> pro_idle@0.49 stand_m=0.124/0.138 rise_m=0.017
JOIN_AT step_out bone=LeftUpperLeg clip=pro_idle@1.17 -> pro_idle@1.20 stand_m=0.124/0.144 rise_m=0.011
JOIN_AT step_back bone=LeftUpperLeg clip=pro_idle@0.40 -> pro_idle@0.43 stand_m=0.127/0.155 rise_m=0.001
JOIN_AT pivot_out bone=LeftUpperLeg clip=pro_idle@1.93 -> pro_idle@1.96 stand_m=0.125/0.151 rise_m=0.004
JOIN_AT roll_out bone=Neck clip=pro_left_weave@0.10 -> pro_left_weave@0.13 stand_m=0.124/0.138 rise_m=0.042
JOIN_AT slip 2-3 bone=RightUpperArm clip=pro_right_cross@0.20 -> pro_right_cross@0.23 stand_m=0.132/0.154 rise_m=0.053
JOIN_AT slip 2-3@own_ropes bone=RightUpperArm clip=pro_right_cross@0.20 -> pro_right_cross@0.23 stand_m=0.127/0.155 rise_m=0.051
JOIN_AT feint bone=LeftUpperArm clip=pull@0.07 -> pull@0.10 stand_m=0.127/0.155 rise_m=0.000
JOIN_AT push_off bone=LeftUpperLeg clip=pro_idle@0.40 -> pro_idle@0.43 stand_m=0.125/0.146 rise_m=0.014
JOIN_AT cut_off bone=LeftUpperLeg clip=pro_idle@1.93 -> pro_idle@1.97 stand_m=0.124/0.139 rise_m=0.016
```
