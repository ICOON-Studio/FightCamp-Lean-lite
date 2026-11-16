# S498 digest (2026-11-16) - fight motion week, day 3

Tags: fight motion, head overlap, body shot, HeadClear, contact-frame jump, chest lean, FILMCOUNT1, CAMHOLD1, COACHNECK1

## What is on main (a65d80b4f)
- HeadClear.gd + GloveClear._lean_head: heads keep 0.28 m between true centres, lean to opposite sides, eased; a body
  puncher dips his head 11 cm before the punch lands. Control arm `-- noheadside`, trace `-- headtrace`.
- CAMHOLD1 (Qwen): no broadcast cut while a punch is in flight (+0.35 s). `-- nocamhold`.
- FILMCOUNT1 (Goose): FilmCount.gd + FilmMoments.gd (split from 578 lines). Its test is red on a finding (below).
- Training: full pads for every boxer, no sharing (the Training K session, his Q-S294-260).

## Measured (same bout, seed 7, 75 s, 30 fps; E:/FightCamp/tmp/fightweek)
| film | what | head inside a body (frames) | heads < 25 cm | head jumps > 12 cm |
| r0 | S496 baseline | 9 | 0.18 % | 53 |
| r2b | S497 (not main's state: does not repeat) | 15 | 0.40 % | 39 |
| r3ctl | today's main, old head lean | 9 | 0.22 % | 49 |
| r3d | today's main, HeadClear | 5 | 0.13 % | 50 |
| r3nocam | r3d without CAMHOLD1 | 5 | 0.13 % | 50 |

## Causes found
1. Head overlap = one pair of clips: pro_body_shot against the pro_hit_by_gutshot fold. The fold starts on the contact
   frame (react_from 0.65 s in, 1.5x) and moves the hit head 11-18 cm a frame for five frames toward the puncher.
2. Contact-frame head jumps = the PUNCHER's trunk: head minus hips 19-24 cm in the jab's contact frame, root and hips
   2-3 cm. PunchReach's chest lean (ReachLimit.lean, LEAN_MAX 0.30 rad) under a held glove; PopCap exempts it (S497).
3. A hit never moves the hit boxer's root (no knock-back in HitImpact / RangeLive): a body shot leaves her in place.
4. COACHNECK1's fix moves the neck under 1 degree on a pose dumped from the game; its probe's chest axis is wrong
   (neck_vs_chest 131 deg on a ~40 deg neck).
5. Film night claims that pass by chance over the 8 % bar on FilmBout's tapes: jab -> wild 26.5 %, round1 -> outlanded
   13.3 %, after_body -> outlanded 11.6 %, round1 -> right_low 8.1 %, walked -> outlanded 8.0 %.

## Next
The chest lean's rate limit, arms home (FIGHTWEEK2_WIP_S497.patch), reaction size + a body-shot step back, then film r1
and two new blind critics. Details: NEXT_SESSION_PROMPT.md.
