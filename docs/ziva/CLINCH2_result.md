# CLINCH2 (S354) — the tie-up is a real hold

**RESULT: `CLINCH OK 6/6`, 3 holds measured, 0 script errors.** Main read `CLINCH OK 0/6` with the same 3 holds. The
still run now ties up on every clinch beat of the played bout (4 of 4 in round 1, `gap 0.68 m`, holder 0 or 1), where the
same run on the old code tied up once and left three holds standing a metre apart until the referee parted them.

Branch `ziva/clinch2` (worktree `E:/FightCamp/wt/ZIVA_LEAN`, from main `10e838d`). Commits: `15935c2` (the tie-up engages
once it is tied), `ff09eb8` (the pair walks in), `3464d3b` (this doc and the stills).

## The probe — `tools/clinch_check.gd` (new, 455 lines)

`CLINCH holds n` is the gate: **fewer than 3 holds is VOID and every line FAILS** (the r4 probe printed a vacuous 4/6
with no hold measured at all), so a build with no clinch cannot pass. It builds a real FightStage through `Faces.pair`,
needs `FightCast.crew(stage, false)` (without the crew the hands have no CornerIK and the probe would measure a clinch
that does not exist), fires three scripted clinch beats through BeatFire the way TapeFilm.tick does, and samples six
measurements every 0.1 s of every engaged hold, as shown (`tools/pose_tap.gd`).

    res://tools/clinch_check.gd  (+ `-- debug` for every sample)
      overlap  glove centre >= 0.10 m from the other's head bone, >= 0.08 m from her chest line (Chest..UpperChest)
      heads    head-to-head 0.16 .. 0.26 m
      aframe   pelvis gap - chest gap >= 0.15 m (hips back, chests in)
      hands    every glove centre 0.07 .. 0.40 m under its own head
      jostle   every hold: the pair's axis turns >= 15 deg, the pelvises travel >= 0.15 m
      digs     every dig of every hold comes within 0.08 m of the other's flank (spine_02/03 side)

### Before — main's `Clinch.gd` + `BeatFire.gd`, same probe, same beats

    CLINCH_CHECK start: pair clips true, gap 0.80 m
    CLINCH digs      0/6 within 0.08 m of the flank                             FAIL
    CLINCH overlap   min glove-other head 0.07 m, glove-other chest 0.11 m      FAIL
    CLINCH heads     head-head min 0.21 max 0.65 m                              FAIL
    CLINCH aframe    pelvis gap - chest gap 0.03 m                              FAIL
    CLINCH hands     glove under own head 0.02..0.38 m                          FAIL
    CLINCH jostle    axis turn 10 deg, pelvis travel 0.03 m                     FAIL
    CLINCH holds 3
    CLINCH OK 0/6

Read it as the brief does: the two were within 0.80 m and the tie-up never engaged (`max` head gap 0.65 m — they stood,
did not tie), the axis turned 10 deg with 0.03 m of travel (nobody moved the other), and no dig was ever thrown.

### After — `ff09eb8`

    CLINCH_CHECK start: pair clips true, gap 0.80 m
    CLINCH digs      6/6 within 0.08 m of the flank                             OK
    CLINCH overlap   min glove-other head 0.36 m, glove-other chest 0.14 m      OK
    CLINCH heads     head-head min 0.17 max 0.21 m                              OK
    CLINCH aframe    pelvis gap - chest gap 0.34 m                              OK
    CLINCH hands     glove under own head 0.08..0.38 m                          OK
    CLINCH jostle    axis turn 34 deg, pelvis travel 0.46 m                     OK
    CLINCH holds 3
    CLINCH OK 6/6  (79 samples over 3 holds, 6 digs wanted, 6 digs reached the ribs)

Bounds were never loosened; the only line with a thin margin is `hands` (0.08 against 0.07 m — the holder's blade hand,
which spec 3 puts below her shoulder while her head is down in the tie).

The void gate, caught firing during the work (a mid-round build that had lost the engage on one of the three beats):

    CLINCH holds 2
    CLINCH OK 0/6
    CLINCH VOID: 2 holds measured, 3 needed - every line FAILS

## The fix — `scripts/fight3d/Clinch.gd` (233 -> 478 lines), `BeatFire.gd` (128 -> 129)

Everything is in `Clinch.gd`; `BeatFire.gd` is the one line that hands the beat's `digs`/`digger` to
`stage.clinch.start(who, dur, digs, digger)`.

1. **The engage gate.** `start()` sets the tie's pose (both bodies' IK: the overhook hand, the blades, the grip) and the
   tie's spacing, but `engaged` only turns true once the pair **stands at the tie's spacing** with the tie's own clip
   clock at `TIE_SET_S` (0.4 s) and both boxers free. A hold whose first sample landed mid-join read the *old* pose
   (`heads max 0.65 m` above).
2. **The tie's spacing, walked to.** `floor_m` returns the tie's gap and writes it into `feet.want_m` inside
   `RingPlace.compose`, so the range machine's want is the tie's gap for the whole hold. RangeBreath's `CLINCH_M` 0.38 is
   below the pair clips' 0.77: the holder was mid-step on every frame of the hold, nobody was ever standing, the tie-up
   never engaged, and the live pair was dragged across the canvas for the whole hold (S318).
3. **The pair clips start only at the spacing** (`NEAR_M` 0.07, above Footwork's 0.06 clinch band). `clinch_att` /
   `clinch_vic` are not step clips (`Footwork.can_step` wants a guard or a fidget), so starting them on the beat's own
   frame **froze the holder mid-ring**: the played bout measured three of one round's four holds never closing a
   centimetre and timing out. The holder now walks in on her own guard clip and the tie's clip takes over the frame the
   spacing is reached.
4. **The tie is a real hold**: the pair turns 34 deg about its own middle (equal and opposite, easing in) while the
   holder walks the other back, and the digger's free hand throws the beat's `digs` short body hooks — out 0.28 m, in to
   0.02 m of the rib band, on an eased arc, `Dig` contact on the ribs every time.
5. **Fixed while measuring**: `floor_m` typed `feet` as a `Node` — `Footwork` is a `RefCounted`, so that line threw on
   every frame of every hold (the range machine kept RangeBreath's 0.38 and the walk-in had no gap to stop at).

`ClinchPose.gd` was not needed: `Clinch.gd` is 478 lines, under the 500-line rule.

## The stills — `tools/clinch_still.gd`, a played bout on the game's own broadcast camera

    python tools/hidden_desktop.py run --timeout=1400 <godot> --path . --windowed --resolution 1920x1080 \
      --audio-driver Dummy --fixed-fps 30 --script res://tools/clinch_still.gd -- res://docs/ziva/shots/clinch2 12

12 stills in `docs/ziva/shots/clinch2/`: five tie-ups (0.8 s in), five breaks (0.3 s in), plus the tool's own range and
pocket frames (not clinch frames, not part of the gate). Every clinch still was opened and read; Lucy Jackson (red) vs
Maria Ortega (blue), TestJump's fight night, day 33 of the career.

`docs/ziva/shots/clinch2/before/` holds four stills of the same bout on the old code — 44.0 s, 66.6 s and 112.1 s are
the breaks of holds that never tied (the pair standing a metre apart with no tie-up to break), and 8.7 s of round 2 is
the one hold that did tie. They are run 1's files, kept as the picture of the bug.

| still | bodies | gap | noses | wrists / hands | feet |
|---|---|---|---|---|---|
| `c02_r1_tie_14.4s` (r1, Lucy holds) | chest to chest, no daylight between the trunks | 0.68 m | both faces at each other's temple, Lucy's nose into Maria's cheek | Lucy's right glove over Maria's far shoulder, on the upper back below the shoulder, white cuff clear; Maria's left glove on Lucy's ribs | four boots planted wide, interleaved, no overlap |
| `c05_r1_tie_42.2s` (r1, Maria holds) | pressed, trunks overlapping in screen space | 0.68 m | Maria's nose down into Lucy's hair, Lucy's face at Maria's neck | Maria's right glove over Lucy's left arm onto the far blade; Lucy's left glove low on Maria's ribs | four planted, knees bent, one boot between Maria's |
| `c07_r1_tie_64.6s` (r1, Lucy holds) | pressed, no gap | 0.68 m | Lucy's face to Maria's cheek; Maria's chin tucked | Lucy's left glove over Maria's right arm onto the blade; Maria's gripping glove at Lucy's flank, her free glove up by her own ear (spec 3's bound still holds it 0.08 m under her own head) | four planted, no clipping |
| `c09_r1_tie_106.9s` (r1, Lucy holds) | fully pressed, heads together, A-frame readable | 0.68 m | Maria's nose at Lucy's cheek, Lucy turned into her | Lucy's left glove behind Maria's shoulder (blade), wrists on the other's arms; Maria's glove on Lucy's flank | four planted wide, boots clear of each other |
| `c11_r2_tie_8.7s` (r2, Maria holds) | pressed, no gap | 0.68 m | Maria above Lucy, nose down at her; Lucy tucked at Maria's shoulder | Maria's blue glove over Lucy's back onto the blade; Lucy's red glove on Maria's ribs | four planted, wide base, no overlap |
| `c03_r1_break_14.9s` / `c06_44.0s` / `c08_66.6s` / `c12_r2_11.6s` | both stepped back to 1.43-1.50 m | — | both facing each other again | both gloves coming up to the guard (spec 6) | both feet planted, apart, no clipping |
| `c10_r1_break_112.1s` (r1) | camera crowded the pair (the game's own broadcast camera, close behind Lucy) — her back fills the frame, the referee leaning in to the right | — | not readable at this frame | Lucy's glove up | her boots planted |

Two things the stills show that are **not** this round's files: the referee's break pose (Referee.gd's `af_push`)
leans him in with his head low between them, and the broadcast camera can end up nearly inside a boxer at 0.3 s after a
release. Both are untouched by S354 and were left alone.

## Regression

    tools/run_tests.sh JOBS=3                                    91 PASS, 1 FAIL (pre-existing: body_figure portraits,
                                                                 missing holo_f_mask.png import in this worktree)
    tests/clinch_beats_test.gd                                   CLINCH_BEATS failures=0
    tests/beat_clips_test.gd                                     BEATCLIPS failures=0
    tests/inside_beats_test.gd                                   INSIDE_BEATS failures=0
    tests/golden_path_test.gd                                    GOLDEN_PATH failures=0
    tools/clinch_probe.gd   (hand heights)                       CLINCH_PROBE above-head samples: { "AttLeft": 17 }

The last line is the S318 reading of the pair clips' own arms, unchanged: the clip's lead glove still rides above its own
head, which is exactly why the tie's hands are IK'd on top of it.

## Re-running any of it

    # the six checks (gate: CLINCH holds >= 3, then 6/6); -- debug prints every sample
    <godot> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/clinch_check.gd

    # the stills, hidden from the owner's monitors, 30 fps, game's own camera
    python tools/hidden_desktop.py run --timeout=1400 <godot> --path . --windowed --resolution 1920x1080 \
      --audio-driver Dummy --fixed-fps 30 --script res://tools/clinch_still.gd -- res://docs/ziva/shots/clinch2 12

    # why a live hold does or does not engage (three of four failed before the fix):
    #   a temporary watcher printed holds/clip/gap/move_left per 0.2 s of a played bout - it is not committed.
## Collected S355 (Claude, 2026-11-02)
Re-run on main 9654051: main `CLINCH OK 1/6` (heads max 0.63 m, 0 digs), with the fix `CLINCH OK 6/6`, 3 holds. clinch_beats, beat_clips, range_breath, clinch_rest tests green. Two stills kept here; the rest stay on branch `ziva/clinch2`.
