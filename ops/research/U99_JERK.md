## DECISIONS

Worst cause in the top 1% jerk bucket: **join_active** (88% share), then warp (57%) and gap_walk (52%). Take changes alone are 15%; lock_release 2%. Calm frames (`none`) are 0.2% of the worst 1% and p95 jerk 478 m/s³ vs join_active 13643.

Worst point: **LeftHand** (max 61841 m/s³, p99 13686). Feet and head follow; hip/chest are calmest in guard.

Five worst moments (seed / frame / side / point / jerk / take):
1. 94301 f1450 a LeftHand 61841 — react_body#4 (join+gap)
2. 94301 f19779 b RightFoot 60897 — react_head#3 (join+warp+gap)
3. 94301 f1429 b RightFoot 60888 — react_head#3
4. 77003 f4474 b RightFoot 60855 — react_head#3
5. 77003 f10335 b RightFoot 60510 — react_head#1

Smoothness debt clusters on **take joins** (especially receiver reactions) and **strike warp / gap slides**, not idle guard. Hands spike hardest; feet spike when reactions and warp coincide.
