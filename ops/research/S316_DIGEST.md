# S316 digest (2026-10-30, same session as S315) - Lean update 19: a real guard, gloves on the wrist, smoother footwork

Operator, mid-session, on update 18 stills: "this guard is so wrong", "the gloves do not stick properly on the wrist",
"bad", "very bad" (a clinch still), "the animations look so much better here [board /animations - the raw Rokoko takes],
but in the fight are nowhere near that smooth", and the body map ask (S316_BODY_MAP_PLAN.md, Q-S294-29).

## What now works (Lean 3f3384a + f907b6e + d807465; update 19 exported, 33/33 tests, exe smoke 0 errors)
- ONE GUARD AT EVERY RANGE: GuardTuck draws each wrist to its own GUARD point from the head bone (rear 0.14 fwd / 0.10 out
  / -0.03 up = the cheek; lead 0.26 / 0.07 / -0.04 = in front at chin height; lead 5 cm lower at long range; elbows bent
  down and in). The S313 low guard (wrists 0.26/0.16 m lower at range) is gone - it crossed the gloves at the chest.
- GLOVES IN LINE WITH THE FOREARM: Gloves.gd lays each glove 85 % from the hand to the forearm (`-- bentwrist` = control).
- HEADS CLEAR EACH OTHER: GloveClear leans the trunk out of an overlapping head and reads the other's head AS SHOWN
  (peer.shown_head) - which also took gloves-in-a-head from 13 to 0.
- STEPS FLOW: a finished step's clip plays on (slowing) for 0.35 s; the next step on the same clip carries it on.
- CLINCH: holder overhooks at the elbows, heads ear by ear (still stiff: built from a block pose).

## Evidence
tools/inside_guard_probe.gd (round 1's first 90 s, pose as shown), long range ("rest", 366 hand-frames):
| | update 18 | update 19 |
|---|---|---|
| wrist below the head bone | 0.306 m | 0.033 m |
| wrists apart | 0.125 m | 0.202 m |
| elbow out from the torso axis (median) | 0.205 m | 0.182 m |
| glove off the forearm | (bent hand) | 2-6 deg |
| inside: heads < 0.16 m / closest | 8 / 0.026 m | 4 / 0.141 m |
| glove centre deep in a head (all ranges) | 13 | 0 |
tools/smooth_probe.gd (new; kinks = second difference of hands/head off the hips > 2 cm/frame):
| run | clip changes/min | kinks/min | median kink |
|---|---|---|---|
| update 18 | 294 | 1556 | 5.2 mm |
| all layers off (noguard noreach nosnap noglove nofeet) | 294 | 1397 | 5.7 mm |
| joins off | 294 | 2513 | 4.8 mm |
| update 19 | 174 | 1511 | 3.2 mm |
Before: guard idle restarted 120x (played 0.13 s), retreat 100x / advance 76x (0.23 s each). After: 42x idle,
53/47 steps playing 0.53-0.63 s. The remaining kinks sit inside pro_left_hook_v2 / pro_body_shot / pro_left_hook:
not yet known whether that is the clip itself or our recovery speed-up (BeatClips.recover_scale) - measure the raw clip.
Stills: previews/s316 (guard_long_range.jpg, clinch_overhook.jpg), review S316.

## Board
Q-S294-29 body map + round data plan (S316_BODY_MAP_PLAN.md) - waits on his answer. Q-S294-30 update 19.
Operator offered to find clinch / rope-entry clips ("do you want me to find them") - answered yes: a two-person clinch
with the break, FBX humanoid; a boxer stepping through the ropes. Cascadeur is out (ended 10-27).

## Next
1. Punch kinks: play pro_left_hook_v2 / pro_body_shot raw on one body vs in the fight; if the recovery speed-up kinks
   them, ease it in. 2. The clinch clips he finds -> bake + play pure. 3. Body map (on his yes): rules BodyMap from the
   beats, live figure, corner jobs, round data. 4. Short hooks inside, J-INSIDE3 shares, Ziva Monday.
