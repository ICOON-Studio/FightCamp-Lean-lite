# C138 — BJJ long script

Recorded 30 fps in the FightWorldLive room with the approved no-gi population f05_m_mma_light versus f06_m_mma_lhw.

## Built

The continuous six-beat chain is throw → control → ground-and-pound → sweep → submission attempt → submission finish. The chain uses the nine verified paired bindings only; the ground strike is the verified paired strike binding. Every pair is placed by one rigid transform for both bodies, and the pair clocks stayed aligned.

## Joins and travel

| beat | film | start–end s | frames | drift s | join to next: attacker hips / victim hips / attacker hands m | source attacker hip / live graft m |
|---:|---|---:|---:|---:|---|---:|
| 1 | `Paired_FullMount_Takedown_BodyLock_Start` | 0.000–2.333 | 70 | 0.000000 | 1.562 / 1.573 / 1.750 | 2.021 / 2.032 |
| 2 | `Paired_FullMount_Takedown_BodyLock_Loop` | 2.333–4.000 | 50 | 0.000000 | 0.319 / 0.288 / 0.576 | 0.000 / 1.573 |
| 3 | `Paired_FullMount_H2H_Punches` | 4.033–5.200 | 35 | 0.000000 | 0.322 / 0.327 / 0.517 | 0.000 / 0.319 |
| 4 | `Paired_FullMount_Reversal` | 5.233–7.066 | 55 | 0.000000 | 0.151 / 0.151 / 0.173 | 0.510 / 0.382 |
| 5 | `Paired_FullMount_H2H_ArmBar` | 7.067–11.534 | 134 | 0.000000 | 0.946 / 0.323 / 0.658 | 0.668 / 0.829 |
| 6 | `Paired_FullMount_H2H_Strangle` | 11.567–17.567 | 180 | 0.000000 | — | 0.038 / 0.323 |

The source/live travel columns are deliberately separate: a small live value is not evidence that the source film had no root travel.

## Camera grammar

The cameras are hard cam, high three-quarter, low three-quarter, and top-down. All four positions stay on the positive side of the fight line; the top-down is still inside that same 180-degree broadcast arc, not a reverse-side camera. Cuts occur only at beat boundaries. The five-shot rhythm is 2.333 s, 1.667 s, 3.000 s, 4.467 s, and 6.000 s; the ground-and-pound and sweep share the third shot so no shot is a sub-1.5-second strobe.

## What still looks wrong

This is an honest delivery, not an acceptance claim. The source clips do not share a single authored end pose, so the rigid alignment and 0.2 s pose blend can still read as a visible hitch at the larger joins, especially into the armbar and strangle. The retargeted root travel remains a risk: the measured source/live pairs expose where the graft suppresses travel. The camera cuts help hide the worst discontinuities, but a cut cannot hide a join it lands in the middle of, and this capture does not pretend it does. Faces and hand contact are not re-authored in C138.

Recording SHA-256: `978783958409590239df1f7d1ed8144f5ba5942a764be3d31456e0d38bbf00c2`
