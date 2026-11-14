# LANDREACH3 - the landed lead glove stops 5-11 cm above or below the face point

## Diagnosis

Suspect 1 confirmed: `PunchReach._note_shown` resets `_hit_w` to the glove AS DRAWN on the hit frame via
`ReachLimit.carry_base`. For lead hand punches, `carry_base` returns `shown` (the drawn glove), which sits
5-11 cm off the face point mostly in HEIGHT (y). The carry runs from that off point, so the landed glove
inherits the gap.

Probe data (at contact frame, paused):
| Setup | Clip | to_face | height_err | carry_base moved _hit_w |
|---|---|---|---|---|
| A_B | pro_left_jab | 0.076 | 0.077 | no |
| A_B | pro_right_cross | 0.063 | 0.044 | yes (rear cross, S466 fix) |
| A_B | pro_left_hook | 0.038 | 0.109 | no |
| B_A | pro_left_hook | 0.091 | 0.087 | no |
| A_A | pro_left_hook | 0.055 | ~0.06 | no |

The lead hand punches (jab, lead hook) never have carry_base move `_hit_w` - the carry starts from the drawn
glove, which is 5-11 cm off in height.

## Fix attempted: Y-snap in carry_base

For lead hand punches where `shown` is > SHOWN_M from `face`, snap only the y to face height:
`Vector3(shown.x, face.y, shown.z)`. The x/z stay on the punch line.

Results:
| Test | Baseline | Y-snap | Requirement |
|---|---|---|---|
| block_meet failures | 4 | 4 (different rows) | <= 4 - fixed |
| hit_frame failures | 12 | 14 | <= 12, no new THROUGH |
| hit_carry failures | 38 | 38 | <= 38 |

The Y-snap fixes 2-3 block_meet rows (A_B jab, B_A jab, sometimes A_A hook) but breaks 2-3 others
(A_B hook gets worse: 0.038 -> 0.113). The A_B hook's drawn glove has a large XZ offset from the face
(~6 cm) due to the 0.30 m cap; the Y-snap fixes the height but the XZ offset remains, and the through
direction pushes the glove further from the face.

More critically, the Y-snap adds 2 new THROUGH failures in hit_frame_test (pro_left_jab_hurt, pro_left_hook),
violating the "no new THROUGH row" constraint.

## Why it can't be fixed within OWNS

The carry_base controls BOTH the contact frame height AND the through carry start point through a single
variable (`_hit_w`). These need independent values:
- Contact frame: _hit_w should be at face height (so the glove meets the face)
- Through carry: _hit_w should be at the drawn glove position (so the carry doesn't overshoot)

`_note_shown` resets `_hit_w` to `shown` every frame, so any correction is immediately overwritten. The
through direction `_dir_w` has a Y component from the glove's approach arc, so snapping the carry base to
face height causes the through carry to push the glove above face height.

Fixing this requires either:
1. Adding a separate "through start" variable in PunchReach (no room: 498 lines, limit 500)
2. Modifying `_drive` to correct the aim height after the through carry (same room issue)
3. Changing the cap (CORR_M) or reach solve to reduce the XZ offset (in ReachLimit, but affects all punches)

## Status: NOT FIXED

The root cause is confirmed (suspect 1: carry_base returns shown for lead hand). The fix is blocked by the
coupling between contact frame height and through carry through `_hit_w`, combined with the 500-line limit
on PunchReach.gd preventing the decoupling code.
