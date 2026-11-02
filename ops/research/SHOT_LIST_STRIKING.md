# SHOT LIST - BOXING AND KICKBOXING (S115, Claude) - the standard every C223 clip is reviewed against

What a human does: an animation lead writes one row per move - the pose that proves it is THAT move, its timing, and what
it chains from - before a clip is made, and reviews each take against the row. Rows are the 56 catalogue moves read by
`tools/q133_clip_coverage.gd -- disc=boxing,kickboxing` on 2026-09-27.

**Sources (primary):** `G75_STRIKE_SPEEDS.md` section 1 (peak effector speed) and section 2 (onset->impact: Stanley 2018,
Piorkowski 2011, Atha 1985; Ueberschar 2021 split throw 71-117 / contact 122-144 / retract 169-262 ms);
`J28_HOW_FIGHT_MOVES_FLOW.md` rules 1-5 (retract ~170 ms power / ~262 ms jab, Menzel & Potthast 2021; never hard-cut
mid-extension; rear hand stays up while the lead works). Bag-study timing is single-max, not in-bout - bands, never points.

**Every strike, every row (the common checks):** starts and ends in the SAME guard pose as `H2H_Idle` (so any clip chains
into any clip); the striking limb reaches full extension on the target line (head or body, as named); the non-striking
hand stays at the chin; the planted foot does not slide; hips/shoulders rotate INTO the strike (a punch thrown with the arm
alone is wrong); retract ends in guard, not mid-air. Stills: guard / load / extension / retract / guard, game camera.

## Boxing - punches (batch 1)
| Move | The still that proves it | Onset->impact | Peak fist |
|---|---|---|---|
| boxing_jab | lead hand straight, shoulder rolls up to cover chin, small lead-foot step | 100-405 ms | 4.5-9.5 m/s |
| boxing_double_jab | two jabs, second from HALF retraction (not back to guard) | 2 x jab | jab |
| boxing_up_jab | jab thrown from a low lead hand, rising line | jab | jab |
| boxing_jab_body | jab with a LEVEL CHANGE (knees bend, head off line), fist to the solar plexus | jab | jab |
| boxing_cross | rear hand straight, rear heel lifts and pivots, rear hip drives through | 223-495 ms | 6-11.5 m/s |
| boxing_cross_body | cross with a level change to the body | cross | cross |
| boxing_lead_hook | lead elbow ~90 deg, horizontal arc, lead foot pivots on the ball | 132-657 ms (S118: fist-onset..Stanley bracket, K32) | 8-14 m/s |
| boxing_rear_hook | rear hook, rear foot pivots, torso turns through | 132-586 ms | 8-14 m/s |
| boxing_body_hook | lead hook to the ribs with a level change - NOT the head hook clip | hook | hook |
| boxing_rear_hook_body | rear hook to the body with a level change | hook | hook |
| boxing_shovel_hook | half hook, half uppercut, elbow in to the hip, to the liver | hook/uppercut | 6.5-14 m/s |
| boxing_lead_uppercut | lead fist rises vertically, knees load then drive up | 71-627 ms | 6.5-13.5 m/s |
| boxing_rear_uppercut | rear fist rises vertically, rear hip drives | 71-606 ms | 6.5-13.5 m/s |
| boxing_inside_uppercut | short uppercut at clinch range, compact | uppercut | uppercut |
| boxing_overhand | looping cross over the top, torso side-bends | cross band, slower start | ~6-11 m/s |

## Boxing - defence and counters (batch 2)
| Move | The still that proves it |
|---|---|
| boxing_slip_counter | head moves OFF the centre line (knee bend, torso tilt), then a counter from the slipped position |
| boxing_pull_counter | weight shifts to the rear foot, head leans back out of range, counter (usually cross) on the return |
| boxing_catch_counter | rear glove catches the jab at the face, immediate counter jab/cross |
| boxing_counter_over_jab | counter cross thrown OVER the opponent's jab (his arm under ours) |
| boxing_check_hook | lead hook while pivoting off the line on the lead foot (the opponent runs past) |
| boxing_check_hook_pivot | check hook plus the full pivot that turns the attacker |
| boxing_counter_combination | defensive move, then 2-3 punches (chain) |

## Boxing - footwork (batch 3) - real boxing footwork, NEVER a dodge or run clip
| Move | The still that proves it |
|---|---|
| boxing_step_in_out | push step: front foot steps, rear follows the same distance; out: rear first; feet never cross |
| boxing_circle_lead / _rear | lateral step, stepping foot first, stance width kept, guard up |
| boxing_angle_step | step off the line at 30-45 deg, feet square to the new line |
| boxing_pivot_footwork | pivot on the lead ball, rear foot swings round ~90 deg |
| boxing_switch_stance | feet swap lead in a small hop or step, guard swaps with them |
| boxing_rhythm_change | small bounces with a tempo break (J28 rule 2: neutral is stance, footwork and feints) |
| boxing_drawing | a deliberate opening (hand drop or lean) then a set to counter |
| boxing_feint | a short start of a punch (shoulder or hand twitch) that stops before extension, back to guard |

## Boxing - combinations (batch 4) - CHAINS of batch-1 clips with J19 joins, never one clip
one_two = jab + cross; one_two_hook = jab + cross + lead hook; jab_body_head = jab_body + jab; liver_combo = jab + cross +
shovel hook (liver); six_punch_combo = jab, cross, lead hook, cross, lead hook, cross (alternating hands, J28 rule 5).
Each join: the next punch starts from the previous one's RETRACT (J28 rule 1), no return to full guard in between.

## Kickboxing (batch 5) - re-audit the EXACT rows first
| Move | The still that proves it | Onset / peak |
|---|---|---|
| kickboxing_roundhouse / body_kick / high_kick | support foot pivots on the ball (heel toward the target), hip turns over, shin lands at head/body/thigh as named | body RH 8-18 m/s; head RH 0.45-0.46 s, 8-17 m/s |
| kickboxing_low_kick | the same rotation, shin to the THIGH, kicker leans back | 8-18 m/s |
| kickboxing_jab_lowkick | jab then low kick (chain) - the current clip is a PUNCH combo: WRONG | chain |
| kickboxing_jab_cross_lowkick | jab, cross, low kick (chain) - current clip WRONG | chain |
| kickboxing_switch_kick | quick stance switch (feet swap) then a lead-side roundhouse | RH band |
| kickboxing_front_kick / kickboxing_teep | knee chambers up, foot extends STRAIGHT (ball or sole), teep pushes, then recoils | 5-16 m/s |
| kickboxing_side_kick | chamber, hip turns side-on, heel drives out sideways | 6-12 m/s |
| kickboxing_hook_kick | leg extends past the target then the heel hooks back | snapping, RH-fast |
| kickboxing_axe_kick | straight leg lifts high, heel drops down | - |
| kickboxing_spinning_back | turn the back to the target, look over the shoulder, heel drives straight back | 6-12 m/s, 0.27 s |
| kickboxing_spinning_hook | spin, the heel sweeps horizontally | snapping |
| kickboxing_question_mark | the kick starts like a front/low kick, turns over into a high roundhouse | RH band |
| kickboxing_catch_kick_return | trap the incoming kick under the arm, then return a strike (single actor: the catching side) | - |
| kickboxing_clinch_knee | hands pull the head down, straight knee drives up | knee 4-8 m/s |
| kickboxing_four_strike / blitz_four_kick / dutch_combination | chains: punches finish on a kick (the Dutch style ends on a low kick) | chain |

## Refuse
A clip passed on its name; a head clip bound to a body move; a combo made from one strike; a kick combo ending on a punch;
a footwork move from a dodge or run cycle; a speed "fixed" by retiming until it looks fast (G75: fast arcs can look wrong
at 30 fps - judge the band, not the look).
