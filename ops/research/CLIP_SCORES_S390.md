# Boxing clip scores (S390, 2026-11-06)

122 in-game clips. Scored by blind Claude sub-agents from 8-frame rows, not people; the operator's eye outranks them.
Each clip alone on a grid, no opponent. **What the fight adds is not in these: the head snap, the arm bent to the target, the joins.** So hit reactions read weaker than they play.
Method: all 122 scored on the board's previews (dated 11-02, before FloorClear, so knockouts showed arms through the floor: a stale-video artefact). The 64 under 6 were re-rendered on the merged build with `mods=game` and re-scored by one judge. Three judges scored the first pass and one was far harsher (32 of 44 under 6, others 15 of 44 and 17 of 34), so treat the 6-line as soft.

| Score | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- |
| Clips | 3 | 17 | 27 | 56 | 19 |

Under 6: 47 of 122. None under 3 on the game stack.

## Taken out of play (BeatClips.OFF_TAKES, reversible)
12 punch takes under 6 whose plain take stays: pro_left_hook_miss, pro_left_hook_special, pro_left_jab_miss, pro_left_uppercut_ft, pro_left_uppercut_miss, pro_left_uppercut_special, pro_right_hook_hurt, pro_right_hook_hurt_ft, pro_right_uppercut_ft, pro_right_uppercut_hard_ft, pro_right_uppercut_miss, pro_right_uppercut_special.

## Kept on purpose
- Hit reactions under 6: operator S310 wants every purchased clip in play for variety, and the head snap is missing here.
- `advance`, `retreat`, strafes are IN PLAY (Footwork.gd walks with them) at 4/10: feet skate and cross on the grid. Fight-film judges have not named foot slide, but say they cannot judge it from sheets.

## Under 6 and still in play
| Clip | Score | Note |
| --- | --- | --- |
| pro_hit_by_cross_v1_short | 3 | Almost no reaction, guard and body barely move |
| pro_hit_by_cross_v2_short | 3 | No readable hit, body stays in idle guard |
| pro_hit_by_hook_v2_short | 3 | No readable hit, body stays in idle guard |
| advance | 4 | Feet skate and cross, toes stabbing down, no real step |
| retreat | 4 | Feet scissor and skate, toes pointing down, weight never settles |
| strafe_left | 4 | Feet bunch and cross mid-step, skating sideways |
| strafe_right | 4 | Feet bunch and cross mid-step, skating sideways |
| pro_left_uppercut | 4 | Glove flies far overhead, arm almost straight up |
| pro_hit_by_jab_v3 | 4 | Barely any head movement, weak reaction |
| pro_hit_by_jab_v5_short | 4 | Slight head tilt only, reaction undersold |
| pro_hit_by_hook_v1 | 4 | Small dip only, head barely turns for a hook |
| pro_hit_by_cross_v1 | 4 | Tiny head turn, too weak for a cross |
| pro_knockout_v2 | 4 | Stiff sit-back drop, leg kicks straight up on landing |
| pro_knockout_v3 | 4 | Instant kneel then backward flip, leg left standing up |
| pro_knockout_v8 | 4 | Knee drop into flip, legs fling up, arms starfish |
| pro_win_v6 | 4 | Arms hang and shake, does not read as a win |
| pro_left_hook | 5 | Arm nearly straight at extension, reads as wide jab |
| pro_body_shot | 5 | Overlong lunge, both arms out, rear foot trails loose |
| pro_left_dodge | 5 | Lead foot flicks off floor, reads as hop not slip |
| pro_right_dodge | 5 | Lead foot lifts, hop-like, upper body barely slips |
| pro_left_weave | 5 | Shallow lean, no real dip under the punch |
| pro_right_weave | 5 | Shallow dip, snaps back, little knee bend |
| pro_hit_by_jab_v1_short | 5 | Head snap reads, hips and feet stay dead |
| pro_hit_by_jab_v2_short | 5 | Head goes back, gloves float up, feet dead |
| pro_hit_by_hook_v1_short | 5 | Head and torso turn reads, but undersold |
| pro_knockout_countdown_v1 | 5 | Long lifeless hold, rise feels compressed |
| pro_knockout_v1 | 5 | Drops too fast, legs kick up after landing |
| pro_knockout_v4 | 5 | Head snap good, fall too fast, body lands rigid |
| pro_knockout_v5 | 5 | Fall too quick, legs fling up on landing |
| pro_knockout_v7 | 5 | Spins away then collapses too quickly, legs kick up |
| clinch_att | 5 | Static hunched crouch, gloves at head, no reach or grab |
| clinch_vic | 5 | Static hunched crouch, little weight shift, reads as cover-up |
