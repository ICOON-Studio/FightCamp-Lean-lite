## DECISIONS

| role | source guard | f01 guard | source retract | f01 retract | Menzel LAB | defect |
|------|--------------|-----------|----------------|-------------|------------|--------|
| jab | no | no | never | never | 262±42 ms (Menzel jab) | PERFORMANCE |
| jab_lead | no | no | never | never | 262±42 ms (Menzel jab) | PERFORMANCE |
| cross | no | no | never | never | 169±41 ms (Menzel cross) | PERFORMANCE |
| cross_lead | no | no | never | never | 169±41 ms (Menzel cross) | PERFORMANCE |
| hook_lead | no | no | 131 ms | 164 ms | 168±97 ms (Menzel hook) | PERFORMANCE |
| hook_rear | no | no | 164 ms | 164 ms | 168±97 ms (Menzel hook) | PERFORMANCE |
| boxing_double_jab | yes | yes | 383 ms | 383 ms | 262±42 ms (Menzel jab) | none |
| boxing_overhand | yes | yes | 183 ms | 283 ms | 171±33 ms (Menzel uppercut) | none |
| muay_thai_round_kick | yes | yes | 383 ms | 350 ms | NO LAB anchor | none |
| muay_thai_switch_kick_body | yes | yes | 383 ms | 350 ms | NO LAB anchor | none |
| muay_thai_straight_knee | yes | yes | 233 ms | 233 ms | NO LAB anchor | none |
| kickboxing_roundhouse | yes | yes | 383 ms | 350 ms | NO LAB anchor | none |
| kickboxing_body_kick | yes | yes | 383 ms | 350 ms | NO LAB anchor | none |
| kickboxing_low_kick | yes | yes | 333 ms | 333 ms | NO LAB anchor | none |
| kickboxing_jab_lowkick | no | no | never | never | 262±42 ms (Menzel jab) | PERFORMANCE |
| kickboxing_jab_cross_lowkick | no | no | never | never | 262±42 ms (Menzel jab) | PERFORMANCE |

### Roles that do not end in guard on f01
- **jab**: candidate H2H_JabInPlace.FBX; defect **PERFORMANCE**.
- **jab_lead**: candidate H2H_JabInPlace.FBX; defect **PERFORMANCE**.
- **cross**: candidate H2H_StraightPunchInPlace.FBX; defect **PERFORMANCE**.
- **cross_lead**: candidate H2H_StraightPunchInPlace.FBX; defect **PERFORMANCE**.
- **hook_lead**: candidate H2H_HookPunch_InPlace.FBX; defect **PERFORMANCE**.
- **hook_rear**: candidate H2H_HookPunch_InPlace.FBX; defect **PERFORMANCE**.
- **kickboxing_jab_lowkick**: candidate H2H_JabInPlace.FBX; defect **PERFORMANCE**.
- **kickboxing_jab_cross_lowkick**: candidate H2H_StraightPunchInPlace.FBX; defect **PERFORMANCE**.

The realism test (41b3c86) saw the jab leave with the hand still about half out (0.26 of 0.49 m); f01 end_ratio=0.53 matches that screen read.

**S4a guard return:** wrist distance in the chest frame on each skeleton; idle defines guard. Lean in world space reads as extension.