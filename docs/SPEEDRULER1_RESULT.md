# SPEEDRULER1 - sort the 41 failures by check and punch

Status: DONE (S473, Qwen). Discipline: boxing. Method: measure only, no bar changed.

## Two fixed-fps runs: identical

Both runs through `godot_slot.py` with `--fixed-fps 60` printed the same 41 FAIL lines in the same order, confirming the test is deterministic at fixed fps (matching CLASH2_RESULT.md's earlier finding).

## Table

```
move                SPEED    FIRST      POP     SYNC   notes
------------------------------------------------------------
jab                     2        4        4        0   SPEED 4.90-6.88 m/s v 6-8; FIRST 0.000-0.250 s v 0.13; POP 1.00-2.99x v 1.5x
cross                   2        8        7        0   SPEED 5.40-8.78 m/s v 7-9; FIRST 0.150-0.417 s v 0.13; POP 1.26-3.53x v 1.5x
lead_hook               5        1        0        0   SPEED 6.45-14.68 m/s v 7-9; FIRST 0.000-0.300 s v 0.13
rear_hook               2        2        0        0   SPEED 7.08-18.07 m/s v 7-9; FIRST 0.100-0.400 s v 0.13
lead_uppercut           0        2        0        0   FIRST 0.000-0.267 s v 0.13
rear_uppercut           0        1        1        0   FIRST 0.100-0.300 s v 0.13; POP 1.00-1.75x v 1.5x
body_hook               0        0        0        0
------------------------------------------------------------
TOTAL                  11       18       12        0   41
```

SPEED_RULER_SORT total=41

## SPEED (11 failures)

The jab and cross bands (6-8 and 7-9 m/s) catch two plain-take clips each that are too slow: jab_a at 4.90 and jab_c at 5.07 (band floor 6), cross at 6.20 and cross_a at 5.40 (band floor 7). These are the clips played at 1.00x pace with no ReachDrive added (drive 0 m/s), so the glove's own clip speed is below the band. The other jab and cross variants pass because PunchPace adds drive (14 m/s) or the clip's own speed is high enough.

The lead_hook and rear_hook bands (both 7-9) catch the opposite problem: the hard and hard_ft clips overshoot badly. lead_hook_hard at 14.68 m/s and rear_hook_hard_ft at 18.07 m/s are 1.6-2.0x the band ceiling. These clips play at 1.31-1.62x pace, and the pace multiplier pushes the glove past what the band allows. Real crosses run 6-11.5 m/s (CROSS_POWER_S439.md); the hook band's ceiling of 9 m/s is within that range, but the hardest hooks at high pace are nearly double it. The band is too narrow for the variety of takes: it fits the plain cross but not the power hooks.

## FIRST (18 failures)

The bar asks the hand to move within 0.13 s of the punch starting. The cross is the worst offender: all 8 cross variants that fail range from 0.150 to 0.417 s, with cross_b at 0.417 s being the most extreme. The jab has 4 failures (0.183-0.250 s), the uppercuts have 3 (0.233-0.267 s), and the rear hooks have 2 (0.183-0.400 s).

CROSS_POWER_S439.md measured the same start rule on crosses at 0.206-0.375 s, and the real-world literature it cites gives 223-495 ms (K54 line 22: 310 +/- 60 ms; G75 line 112: 223-495 ms). The 0.13 s bar is below what real punches take. The punches that pass (first_s = 0.000-0.100 s) are clips where the hand is already moving at frame 0 or starts moving almost immediately; the ones that fail have a visible wind-up where the hand sits still before the strike. The bar is asking for something no real punch does: start the hand's fast movement in under 130 ms when the literature says 220-500 ms is normal.

## POP (12 failures)

The bar says no bone's worst one-frame step should exceed 1.5x its worst step in the old punch (before step 3). The failures are concentrated on the jab (4) and cross (7), specifically on the punching hand (LeftHand for jabs, RightHand/RightShoulder/RightUpperArm for crosses). The worst is pro_right_cross at 3.53x on RightHand, meaning the reach drive made the hand's worst single-frame jump 3.5 times what it was before step 3.

The pattern is clear: the ReachDrive that PunchPace arms pushes the punching hand faster per frame than the old flat-pace clip. The old punch (played at its clip speed with no drive) had a certain worst step; adding the drive on top makes the hand jump further in a single frame. The rear_uppercut_hurt at 1.75x is the only non-jab/non-cross failure. Hooks and uppercuts mostly pass because their clips already have enough motion that the drive does not change the worst step as dramatically.

## Claude's read (S473, collecting)
- SPEED: two real faults pointing opposite ways. The plain jab_a/jab_c and cross/cross_a takes are slow (4.9-6.2 m/s,
  no drive), and the HARD hooks are far too fast (lead_hook_hard 14.7, rear_hook_hard_ft 18.1 m/s at 1.3-1.6x pace):
  18 m/s is about twice any real hook - on screen a glove that jumps. The hard hooks are the first fix (their pace cap).
- FIRST: the doc's "the bar is wrong" does NOT hold. 220-500 ms in the cited studies is a whole punch / a reaction
  time, not stillness before the hand moves; the 0.3-0.7 s of near-stillness is the defect the clip critics named
  (CLIP_CRITICS_S439.md). The 18 stay real; the cross (8) carries most of them.
- POP: the drive makes the punching hand jump 2-3.5x its old worst frame on the jab and cross - the same speed-up seen
  from the other side; it should fall when the drive is eased in over more frames.
