# Fight tests, S393: what was tried, how it was judged

All blind, two fresh judges a round, films in E:/FightCamp/tmp/s393/film/, key hidden. Whole-fight scores stay 4.5-5, under the 7 bar. Nothing shown to the operator.

| Change | Boxing judge | Animation judge | Measured | State |
|---|---|---|---|---|
| Fold room (RingPlace.room) | for it, 5, 5 vs 4, 4.5 | equal, 4, 4.5 | sunk outside clinch 620 -> 431 frames | main |
| Trunk limit 30 deg (HitSnap) | against, 5, 5 vs 5.5, 5 | for it, 5, 5 vs 4.5, 4.5 | thrower's head in body 103 -> 60 | branch claude/trunkcap; try a softer limit |
| Punch interrupted (CounterCut) | for it, 5, 5 vs 4.5, 5 | for it, 5, 5 vs 4.5, 4.5 | visible stops 5 -> 9 in 3 rounds, median 0.35 -> 0.10 s from contact | main |
| Inside work (InsideWork) | against | against | see INSIDE_WORK_S393.md | branch claude/insidework1 |

Calm lens (C242, TvShot.anchored, DEAD_M 0.5): no blind A/B, it answers the operator's own comment. cam_motion_probe: lens move p50 0.05 -> 0.00, max 0.40 -> 0.27 m/s, turn max 5.3 -> 2.4 deg/s, 24 shots against 22. Film lens.mp4: both boxers stay in frame; at 0:27-0:29 the red boxer's feet touch the bottom edge. The probe's FAIL (2 short shots) is on both arms, so it is not new.

Probe traps: fold_probe first stopped at the chest and overstated the gain. interrupt_probe first read the reach, which only a landing punch arms. hidden_desktop loses stdout on a timeout: use --log-file. Film frames crop the right edge: the window is 1920x1009, the canvas 2055 wide.
