# CLUBWEEK1 build plan, v1 (S485)

Spec: ops/research/DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md, cut by the owner's S484 answers and the closed CHECKs
(ops/research/CLUBWEEK1_V9_CHECKS_S483.md). His answers, verbatim in substance:
- Q-242 "No, never short": every boxer always gets full pads. No pad-turn rule, nobody goes to the bag.
- Q-243 "2 mornings": a boxer without the gym sponsorship (the stipend) loses 2 coached mornings a week to work.
- Q-244 "Yes, they can leave": under 25 loyalty after 2 talks = leaves; turning pro under 50 = outside manager, 10% share.
- Q-245: a 0-100 bar with its word beside it ("62 - Settled").

## What v1 is (Claude decided)
1. **Day job = 2 mornings gone.** Replaces GymSpend.DAY_JOB_GAIN 0.85 (a flat cut nobody sees) with two named mornings the
   week shows as "Work". Module DAYJOB1 (pure, Arena), wired by Claude into the week and the Money "stipend" act.
2. **Loyalty shown and live.** Loyalty.gd (on main since R58LOYAL1) already has bands, dated causes, leaves() and
   pro_share(). v1 wires it: the bar on the fighter's Overview ("62 - Settled" + the last three moves on hover), the
   sponsorship causes (given / pulled / renewed), the talk, leaving (a news line and she is gone), and pro_share at the
   pro debut. The "short" causes stay unused (never short). Claude (INTEGRATE1).
3. **A second class an evening.** +$117 a night (ClubDeal.class_cash), costs the coach 1 coach time that evening, member
   target +4 while it runs. Needs the coach-time budget, so it lands WITH COACHFIT1's build, not before. Queued, not briefed.
4. **Film over** on the bout page: "Film: 3 boxers, 2 seats - one watches alone" (the only collision left). Claude.
5. **Cut to v2:** pad turns, bag nights, short class, cover, Later date, the collision line's SHORT cases (no trigger left
   under "never short"). ClubDeal.gd's pad dealer is superseded.

## Menus (names only in headers)
| Menu | Shows | Wired to |
|---|---|---|
| Fighter > Overview | Loyalty bar "62 - Settled", hover = last three moves | Loyalty.value / band / reasons |
| Week plan | two mornings marked Work for a boxer off the sponsorship | DayJob.lost_days |
| Club > Money | Sponsorship on/off per boxer, "4-week block: $1,000" | GymSpend.set_stipend + DayJob.block_cost; Loyalty sponsor_* |
| News | "She has left the club." | Loyalty.leaves at the week roll |
| Pro offer | the club's share 25% or 10% with why | Loyalty.pro_share |
| Bout page | Film line when 3+ boxers fight one week | FightWeekPlan film seats |

## Golden path (one test, after the wiring)
Fresh doors, four fighters; take one off the sponsorship -> her week shows 2 Work mornings and a loyalty move; a talk; push
her under 25 with two talks -> she leaves on the week roll; another turns pro at 40 loyalty -> share 10%.
