# REARHAND5B result - blend toward guard, partial success

Status: PARTIAL - bars b,d,e,f pass; bar a fails for pro_right_hook, bar c fails for pro_right_hook_ft.

## Method

Dropped the two-bone IK from REARHAND5. Instead, blend each arm bone's rotation track toward its own frame-0 value (the guard) with a smooth weight that rises from 0 at f0 to W over RISE frames, holds, then falls to 0 over FALL frames ending at fs. Same W, RISE, FALL for both clips.

## Parameters

W=0.60, RISE=2, FALL=2
pro_right_hook: f0=2, fs=23, keys=66
pro_right_hook_ft: f0=0, fs=13, keys=39

## READ_CHECK

READ_CHECK pro_right_hook 0.019 got 0.019
READ_CHECK pro_right_hook_ft 0.058 got 0.058
READ_CHECK pro_left_hook 0.177 got 0.177

## Before and after per bar per clip

### pro_right_hook

| Bar | Before | After | Pass? |
|-----|--------|-------|-------|
| a low over hips >= 0.12 | 0.019 | 0.094 | FAIL |
| b strike+ height diff <= 0.01 | - | 0.0000 | PASS |
| c reach within 0.01 of 0.432 | 0.487 | 0.422 | PASS |
| d pop ratio <= 1.1 | - | 0.730 (0.1673 vs 0.2293) | PASS |
| e max elbow <= 175 | - | 100.5 | PASS |
| f non-arm tracks unchanged | - | yes | PASS |

### pro_right_hook_ft

| Bar | Before | After | Pass? |
|-----|--------|-------|-------|
| a low over hips >= 0.12 | 0.058 | 0.171 | PASS |
| b strike+ height diff <= 0.01 | - | 0.0000 | PASS |
| c reach within 0.01 of 0.431 | 0.444 | 0.381 | FAIL |
| d pop ratio <= 1.1 | - | 0.749 (0.1837 vs 0.2323) | PASS |
| e max elbow <= 175 | - | 97.3 | PASS |
| f non-arm tracks unchanged | - | yes | PASS |

## Numbers

pro_right_hook: the low point is at frame 17 (inside the blend window 2..23). The blend lifts the hand from 0.019 to 0.094 but cannot reach 0.12. The reach improved from 0.487 to 0.422 (within 0.01 of 0.432). No pop (ratio 0.730). Elbow 100.5 deg. Non-arm tracks unchanged.

pro_right_hook_ft: the low point lifted from 0.058 to 0.171 (passes 0.12). The reach dropped from 0.444 to 0.381 (too far from 0.431). No pop (ratio 0.749). Elbow 97.3 deg. Non-arm tracks unchanged.

## What was tried

W from 0.50 to 0.90, RISE from 2 to 4, FALL from 2 to 5. The lift for pro_right_hook is stuck at 0.094 regardless of W. The blend modifies the raw animation's rotation tracks, but the retargeting process may not propagate the changes as expected to the hand position. The reach for pro_right_hook_ft is consistently ~0.05 below the target.

## Files

tools/rear_hook_lift.gd (189 lines) - blend tool
tests/rear_hook_lift_test.gd (277 lines) - test with READ_CHECK
assets/anim/baked/mc_Box1_M3_Right_Hook.res - edited
assets/anim/baked/mc_Box1_M3_Right_Hook_FT.res - edited

## Collected S420 (Claude): clips taken on film, the test left out
- Filmed frame by frame with tools/rear_hook_film.gd (move=pro_right_hook / pro_right_hook_ft), main against these clips:
  on main the right hand drops to the hips before the hook (plain frames 7-10, fast 3-5); with these clips it stays at
  chest height and travels as a hook. Taken: both .res and tools/rear_hook_lift.gd.
- Bars (a) plain hook 0.094 < 0.12 and (c) fast hook reach 0.381 vs 0.431 stay unmet; the reach is covered in the fight
  by PunchReach carrying a landed punch onto its target.
- tests/rear_hook_lift_test.gd NOT taken: it reads the unedited clips from res://.godot/orig_*.res, which only the seat's
  machine had (the tool's retargeted copy; main's baked file reads 0.319, not 0.019). It needs fixtures built by the tool
  before it can run anywhere else.
