# LEDGER1 v5 — independent mechanic critique

SCORE depth=7 general=5

PLAY: 6/10

## Verdict

The core is promising: show the true cash attached to a boxer, keep club-wide money separate, and compare the choices before a difficult conversation. Stipend, training, loyalty, reputation, release and pro-share decisions can make a strong management loop. Depth just clears the brief's bar; general design does not. The map is not ready to build as written because its cash ledger is incomplete and several displayed outcomes do not match the rules.

## Scores

- **Depth — 7/10.** Keeping, reducing or stopping an amateur stipend trades cash against training and loyalty; releasing trades future costs or income against reputation and roster space; pro deals trade an up-front bonus against a different share. These choices touch the bout calendar, the club's cash crisis and the boxer's development. The map also usefully keeps uncertain future bouts conditional. The score stops at 7 because the probes do not yet prove the choices are non-dominant, and some of the displayed outcomes are not the outcomes the code applies.
- **General design — 5/10.** The ID-based tagging, separate club column, explicit estimates and visible refusal reasons are the right foundations. But the proposed `Career.pay` change alone cannot create the promised ledger; direct boxer costs are omitted; the scenario comparison does not exist in `CashForecast`; and several option previews are numerically wrong. This is not yet a consistent, buildable contract map.
- **Play — 6/10.** A next-bill warning and a real choice between protecting cash and protecting a boxer's progress can create useful anticipation. The reward should be a clearer runway or a boxer who stays on the road—not a green badge whose accounting excludes real costs. Until the choices change the forecast honestly, this risks feeling like bookkeeping rather than a satisfying weekly decision.

## Code checked

The core files read were `scripts/state/Career.gd`, `scripts/rules/GameMoney.gd`, `scripts/state/BoutFinish.gd`, `scripts/state/Leaving.gd`, `scripts/state/ApproachWire.gd`, `scripts/state/RivalOfferWire.gd`, `scripts/state/GymDeals.gd`, `scripts/rules/StarDeal.gd`, and `scripts/rules/CashForecast.gd`. The task lists `GameMoney.gd` and `CashForecast.gd` under `scripts/state`; those paths do not exist in this checkout, so I checked their actual locations under `scripts/rules`.

For the numeric and option cross-checks I also read `scripts/rules/Approach.gd`, `scripts/rules/RivalOffer.gd`, `scripts/rules/Membership.gd`, `scripts/rules/GymBills.gd`, `scripts/rules/BoutRules.gd`, `scripts/rules/ProDebut.gd`, `scripts/rules/Loyalty.gd`, `scripts/rules/Promises.gd`, and `scripts/rules/DayJob.gd`; `scripts/state/Roster.gd`, `scripts/state/Sim.gd`, `scripts/state/LoyaltyWire.gd`, and relevant sections of `scripts/state/GymSpend.gd`, `scripts/state/Bouts.gd`, `scripts/state/Injuries.gd`, and `scripts/state/FightWeekPlan.gd`.

## Number and rule checks

### The ledger is not a cash ledger yet

`Career.pay(amount, what)` currently writes only `{d, t, amount}`. `GameMoney.settle_week` credits weekly income, accrues weekly costs, and pays the accrued bill every 28 days. `Sim.end_week` adds the weekly income to cash without a receipt row, then pushes one combined "Month-end bill: wages and upkeep" row when the bill is paid. Adding `fid` and `kind` to `Career.pay` will tag one-off payments, but will not tag the weekly dues or split the combined bill into its real sources. It also cannot split the boxer stipends out of that bill. The reconciliation promise needs a change in the week-settlement path as well as the one-off call sites.

The proposed estimates for dues and stipend are sensible only if they stay outside the cash total. Do not divide member dues across boxers and then call the result a boxer's true net. Dues belong to the club pool; a win-related dues estimate can be shown separately. Likewise, an estimate must never make a boxer look self-funding while the actual stipend is omitted.

The build-change table also misses direct, boxer-specific payments that already use `c.pay`: the pro licence/medical costs in `Roster.turn_pro` (when the club pays them), the outside camp partner in `Bouts.start_camp` ($160 at $40 for four visits), the paid fight-week partners in `FightWeekPlan.lock`, and the $300 empty-slot costs in `Bouts.weigh` and `Injuries.pull_out`. These need a boxer ID and kind too. If a promoter covers the pro start costs, show that as a purse deduction rather than a club cash outflow. Shared club purchases and bills stay in the club column.

### Pro terms and the probes

The corrected release-fee direction is right: `Leaving.release_fee` is money in for a professional's departure, `max($500, 40% of the last year's qualifying take rounded to $100)`. The default pro share is 25%; `StarDeal` gives the top-10 choice of $2,500 to keep that share or a lower 20%, the belt choice of $5,000 or 17%, and yearly terms of 40% of last year's take (minimum $500) or a two-point reduction with a 12% floor. The pro camp bill is 6% of purse, halved with the strength coach, and `gym_net` subtracts it from the gym's share. The map's post-debut purse-share / debut-ticket distinction also matches `BoutFinish`; the $450 amateur ticket cut is absent for a championship, a home show or a host-kept gate.

Two probe conclusions do not follow from their own arithmetic:

- At a $5,000 purse, the top-10 share difference is 5%, or $250 per bout. Ten bouts produce exactly $2,500, so keeping the share ties the $2,500 bonus; it does not win. Eleven such bouts are needed to beat it. At a $1,500 purse the break-even is 33⅓ bouts, or 34 whole bouts to pass the bonus.
- The release probe uses 5% of a $2,000 purse as the value of keeping a professional at a 25% share. That 5% is only the difference between 25% and 20%; it is not the income from keeping the boxer rather than releasing them. With no strength coach or cutman, `StarDeal.gym_net` is $380 on a $2,000 purse at a 25% share, or $1,520 over four bouts, before any cutman charge. A $3,000 prior-year take gives a $1,200 release fee. Which option wins depends on the time horizon, the camp/cutman costs and whether those bouts happen. State those assumptions and make a fixture where the trade-off is real.

There is also a low-loyalty edge case. `Roster.turn_pro` can set the club share to the trainer's 10% when loyalty is under 50. At 10%, the top-10 and belt "drop" terms resolve to the same 10% share, so paying $2,500 or $5,000 to keep it is dominated. The yearly formula's 12% floor would raise that 10% share to 12%, not lower it. Do not offer a "drop" that raises the share or a paid "keep" that changes nothing; suppress the talk or define valid terms for this contract.

### Approach choices do not all have the stated effects

The headline approach amounts mostly check out: a keep offer's $3,000 is twelve weeks of $250 stipend, not money paid at the moment of the answer; splitting the stipend has no incremental wage cost; and promising the club show spends $3,500. Label the $3,000 as a 12-week commitment so it cannot be mistaken for an immediate debit.

Three important mismatches remain:

- `Approach.answers` previews the holder after **Move** at 0.85 training. `ApproachWire.answer` instead makes the holder a day-job boxer, and `GymSpend.gain` applies four of six training mornings, or about 0.67. The preview must use the same rule as training.
- The promise preview reports an end change of +8 ( +4 now, +10 if kept, then two invented -3 ticks). The live path gives +4 on acceptance and +10 when the promise is kept; no such two ticks are applied. Show the stages the code actually changes, or implement a real decay rule and test it.
- **Let Go** is not always $0 and not always next Monday. The approach route makes the boxer leave through `Leaving.leave`: an amateur departure costs reputation (−2, or −5 if ranked), and a professional departure also brings the club the release fee. A booked bout inside the 14-day farewell window can delay the departure until after that bout. Show the fee, reputation and actual leaving date.

`Approach.due` includes professionals, including manager/debut offer groups. For those groups, the five-column card still offers `Match`; the current answer only adds loyalty and does not match the manager's share or terms. Add a group-specific keep/counter choice with its actual share and cash effect, or do not present the stipend answers for those offers.

### Other checked rules

- A win adds **8 members and 5 reputation** in `BoutFinish`. `Membership.settle_week` then moves members toward a target based on reputation, dues band and capacity, at a capped step. The map's replay is the right method, but its 80-to-90 example holds the target fixed after the reputation change. Replay both the +8 members and +5 reputation against the no-win path; do not use a flat $65/week except as a clearly labelled upper bound.
- `CashForecast.project(c, weeks)` is a no-change projection (default eight weeks) and extends far enough to include a bill. `_copy` exists, but `project` has no `change` parameter. The proposed comparison cannot yet calculate half stipend, day job or release. `bill_split` can explain the next bill, not simulate those choices.
- The rival challenge's four-day answer window and two-point pass cost match the rules. `_free` in `RivalOfferWire` is named backwards: it is true for a healthy, unbooked boxer, and the code uses that value as “charge a pass.” The current penalty calculation works, but rename the predicate and test it before building the card. After the one free **Not This Show** use, that choice is just a pass with the same penalty; disable it and explain why rather than presenting a duplicate action.

## Missing options and what they change

- **A full current-state comparison, not just a table of promised outcomes.** For every legal choice, show change versus keeping the current deal: next bill, lowest projected cash, stipend/fee, training, loyalty, reputation and roster place. This makes the cash-saving choice comparable to its development cost. Apply each choice to a copy of the same state; do not use “higher” without a value.
- **A manager-approach choice for a professional.** “Match” must either preserve or counter the actual share, with the bonus and future purse income shown; “Let Go” must include its release fee and departure delay. This changes whether the gym keeps the professional's future share or takes the fee now.
- **All direct cash lines on the boxer record.** Include paid camp partners, missed-weight/pull-out charges and pro start costs, alongside purse, debut tickets, scout, camp, cutman, bonus and release fee. This changes whether the per-boxer total is trustworthy. Keep shared dues and shared bills in the club column; show a win's member effect as a separate estimate.
- **A conditional, not guaranteed, “Find a bout” effect in the warning.** An ask may be refused, and a bout does not always pay the club a ticket cut. This changes whether the cash warning is honest: the no-bout forecast stays the baseline; a prospective bout is a separate conditional path.

## Useless or duplicate options

- **Set review date** has no defined effect in the map, while the game already stops each Monday. If it is just a snooze, say when the alert returns and keep the closure warning visible; otherwise remove it. It should not imply that the player changed the cash outcome.
- **Not This Show after its seasonal use** has no unique effect: it becomes Pass with the same ladder penalty. Disable it, rather than letting the player choose a duplicate.
- **Sort by any column** changes the table order, not the game state. Keep it as navigation if useful, but do not count it as mechanic depth.
- **Self-funding** is misleading while real stipend and other direct costs are estimates or missing, and annualized milestone values are unsupported without a bout-rate assumption. Keep the conditional per-bout figure; defer the badge and annual total until the complete cash model exists.

## To reach 10/10

1. **Define the accounting contract first.** Give each real cash movement a date, signed amount, source, kind and optional boxer ID. Record weekly income and split the month-end bill at the point it is paid; tag the actual boxer stipends there. Update `Sim.end_week` as well as `Career.pay`. Keep estimates outside the cash ledger, and make the cash reconciliation sum actual movements only.
2. **Tag every direct boxer payment.** Audit every `c.pay` path, including the pro licence/medical charge, camp partners, fight-week partners and empty-slot charges. Use IDs, never a name in the text. Keep club show costs, dues and shared overhead in the club column; show promoter-covered costs as a purse deduction, not cash paid by the club.
3. **Make comparisons executable.** Add a scenario argument to `CashForecast.project` and apply each legal option to a deep copy. Preserve the 28-day bill timing; include release fees, stipend changes, member/target effects, loyalty and training. Count only booked or already received fight money in the baseline; display unbooked bouts and member-growth effects as conditional estimates.
4. **Unify option previews with the rules.** Fix the 0.85-versus-four-of-six Move result, the promise's +8-versus-actual +14 forecast, the pro/ amateur Let Go fees and reputation, and the 14-day farewell date. Handle professional manager/debut approaches separately. Fix the 10% share renegotiation so no “drop” raises a share and no paid “keep” leaves it unchanged. Replay a win with both +8 members and +5 reputation.
5. **Repair and rerun the probes.** Make the $5,000-purse top-10 case a tie at ten bouts and a win only after that; compare release to the full current-share net, camp bill and cutman over an explicit horizon. Test the same-state cash reconciliation to ±$1, every option's locks and deadlines, and cases with no booked bout. A probe passes only when both choices really win somewhere.
6. **Specify the alert lifecycle and remove no-op controls.** Base yellow/orange/red on the projected bill dates and the eight-week closure rule. State what dismissing or snoozing does; remove “set review date” if it has no separate effect. Never count a hoped-for bout as certain cash.
7. **The 10/10 page at 1920×1080:** put the boxer and current deal/deadline in the header; use the left two-thirds for dated cash-in/cash-out/net rows, with estimates visibly separate; use the right third for only the legal choices and their next-bill, lowest-cash, training, loyalty and release-fee deltas; reserve the bottom strip for club-wide bills, the eight-week cash path and the exact warning reason. Each button should state what changes and why a locked choice is unavailable. Keep the view on one boxer at a time, with a clear route back to the club comparison.
