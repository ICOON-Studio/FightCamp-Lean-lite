# LEDGER1_V4 - critic review of the design (fresh critic, Arena)

Task: `ops/research/TASK_LEDGERCRITIC5A.md`. Brief read in full: `ops/research/DESIGN_LEDGER1_V4_CRITIC_DOLA.md` (critic pack, then the v4 design map). No other critic file was read. Research only: no game code changed, Godot not run.

SCORE depth=6 general=5

The bar (owner S459, S425) is 7 or more on DEPTH and 7 or more on GENERAL DESIGN. Neither is met. PLAY is not scored here because the task asks for DEPTH and GENERAL DESIGN only.

## 1. Verdict in short

The map has the right bones. There are five approach answers, a rival challenge with a pass cost, pro renegotiation, release and a stipend switch, and each has a real price. Those choices touch loyalty, reputation, training and cash, which is what the game needs.

But the map gets several money numbers wrong, reads a few rules in the wrong direction, and tags rules "CODE" that the code does not have. The most serious error: a pro's release fee is cash **into** the gym, and the map writes it as cash out in every table. A builder who follows this map would ship a ledger that cannot reconcile, a warning table with boxer-only answers to a club-wide problem, and probes whose arithmetic is wrong.

## 2. Code read

Named in the task (read in full):
- `scripts/state/Career.gd`
- `scripts/state/BoutFinish.gd`
- `scripts/state/Leaving.gd`
- `scripts/state/ApproachWire.gd`
- `scripts/state/RivalOfferWire.gd`
- `scripts/state/GymDeals.gd`
- `scripts/rules/StarDeal.gd`

Named in the task, but at another path (read in full):
- `scripts/rules/GameMoney.gd`. The task says `scripts/state/GameMoney.gd`; that file does not exist.
- `scripts/rules/CashForecast.gd`. The task says `scripts/state/CashForecast.gd`; that file does not exist.

Read in part, or by grep, to check numbers the map quotes:
- `scripts/rules/RivalOffer.gd` (first 120 lines), `scripts/rules/Approach.gd` (constants, `answers`, `due`)
- `scripts/rules/Membership.gd` (member drift, targets, dues), `scripts/rules/GymBills.gd` (`week`, constants)
- `scripts/rules/BoutRules.gd` (constants), `scripts/rules/ProDebut.gd` (costs), `scripts/rules/DayJob.gd`
- `scripts/rules/Loyalty.gd` and `scripts/state/LoyaltyWire.gd` (stipend loyalty)
- `scripts/state/Sim.gd` (weekly settlement, about lines 296-332)
- `scripts/state/GymSpend.gd` (`set_stipend`, `set_half`, `end_week`), `scripts/state/Roster.gd` (`gym_cut`), `scripts/state/ProLadder.gd` (line 307), `scripts/state/AskFlow.gd` (`host_gate`)

Also: a Python replay of `Membership.settle_week` (scratch script in /tmp, not committed). Not checked: the cash-rich and cash-crisis probe outcomes (they need a game run), the cutman's $150, and the exact closure count behind the red alert.

## 3. The two scores

### DEPTH: 6 of 10

For:
- Real choices with real prices. Approach: Match, Half, Move, Promise, Let go (`ApproachWire.answer`). Rival challenge: Accept, Not this show, Pass (`RivalOfferWire.answer`). Pro renegotiation: keep the share for a bonus or drop it (`GymDeals.answer_talks`). Stipend on or off.
- Each choice reaches past cash: the boxer's loyalty, the teammates', the holder's, reputation, ladder points and training pace.
- Some answers really do depend on the situation. Keep versus drop on a pro's share turns on the purse. Match versus let go turns on whether the boxer is on a day job.

Against:
- Several trade-offs are shown with the wrong sign or size (section 4). The player would decide on numbers that the code does not produce.
- The biggest short-term cash lever for a pro, release, is shown as a cost. So the map's "neither dominates" claim is untested, and the one pro-share probe is wrong by a factor of about eight.
- The stipend has three states in code (full, half, day job). The map shows two.
- A club-wide cash crisis can only be answered boxer by boxer. Dues, kit, staff and the overdraft are missing from the answers.

### GENERAL DESIGN: 5 of 10

For:
- Plain words, one table per answer with availability, refusal reason, deadline and lapse. Names only in headers.
- The answers that are in the code are mostly named right (pass, not-this-show, renegotiation steps, pro camp bill, scouting, the licence costs).

Against:
- Five cash statements are wrong: the release-fee sign, the match cost, the per-win dues estimate (about 2.6 times too high in the long run), the ticket cut a pro never receives after the debut, and the pause's loyalty cost.
- "CODE" tags on rules the code does not have: release after 6 weeks below $0, pause after 4 weeks below $0, idle counts, yellow four-week net blocks.
- The reconciliation rule cannot pass with the current ledger. Weekly dues and the parts of the month bill are not in `Career.ledger`.
- The per-boxer ledger tags by name in the text. The map's own check says the build may not do that, but `GymDeals.year_take` already does.
- The rival row for a second "Not this show" gives a wrong refusal reason. The stipend lock starts later than the map says.
- `CashForecast.project()` takes no scenario, so "Keep / Pause / Release from project()" needs a new argument before it can exist.

## 4. Numbers checked

Key: OK = matches the code. WRONG = the code says otherwise. GAP = the code has it and the map misses it. NOT IN CODE = the map tags it CODE, no such rule found. UNVERIFIED = not checked.

| # | Map says | Code says (file, lines) | Status |
|---|---|---|---|
| 1 | A pro's release fee is cash out ("pro pays", "release fee deducted") | `Leaving.gd` 91-93: the fee is positive and `c.pay(fee, ...)` adds it to cash. The comment says the pro's manager pays the gym | WRONG |
| 2 | Pro release fee = max($500, 40% of the year's take, rounded to $100) | `Leaving.gd` 46-50; `StarDeal.YEAR_BONUS` 0.4 | OK |
| 3 | Amateur release fee $0 | `Leaving.gd` 47-48 | OK |
| 4 | A booked bout inside 14 days is boxed first, for a player release too | Only `leave()` defers (`Leaving.gd` 82). `let_go()` does not defer. `let_go_price()` refuses any booked, unfinished bout (71-72) | WRONG |
| 5 | Release when 6+ weeks below $0 and no bout in 3 weeks (CODE tag) | No such test in `Leaving.gd`. `weeks_below` is read only by `GymBills.status` and `CashForecast` | NOT IN CODE |
| 6 | Pause allowed when 4+ weeks below $0 and no bout in 6 weeks (CODE tag) | `GymSpend.set_stipend` (116-135) checks pro, same state, approach lock and half job only | NOT IN CODE |
| 7 | Stipend locked while an approach answer is pending | Lock set when an answer is taken (`ApproachWire.gd` 168-187), held 84 days (`Approach.WINDOW_DAYS`). A pending approach does not lock | WRONG |
| 8 | Pause: loyalty drifts -3 a week (probe) | Pausing fires `sponsor_pulled` -8 once; resuming fires `sponsor_given` +5 (`LoyaltyWire.gd` 22-28; `Loyalty.gd` 48) | WRONG |
| 9 | Stipend has pay or pause only | `GymSpend.set_half` (138-155): half pay, one work morning, loyalty +3 up, -4 down | GAP |
| 10 | Pause applies to every boxer | `set_stipend` refuses pros: "a pro lives on purses" (117-118) | GAP |
| 11 | Match: always available, no cash line | On a keep offer, Match restarts $250 a week for 84 days: $3,000 (`Approach.gd`, `match_cash`) | GAP |
| 12 | Move: holder gets "grievance ticks" | Holder loses 12 loyalty at once (`HOLDER_MOVE` -12), trains x0.85, and gets -3 every 28 days (`TICK`, `GRIEVANCE_DAYS`) | GAP |
| 13 | Half refused only with "No eligible teammate" | Also refused when the talk failed, or the offer is a bout offer (`Approach.gd`, `half_why`) | GAP |
| 14 | Promise: lapse "Same" | A promise is tied to the club show. No bout that night breaks it and the boxer leaves the next Monday (`ApproachWire.gd` 222-249). The show costs $3,500 (`SHOW_COST`) | GAP |
| 15 | Tell it straight: "optional", no outcome given | Once per approach, free. Landed: 0 loyalty. Failed: -4. Blocked 8 weeks after a talk (`ApproachWire.gd` 126-141; `Approach.gd` `TALK_*`) | GAP |
| 16 | Not this show: refused when used ("Already used this season") | A second use returns ok and counts as a pass (`RivalOffer.answer`). The boxer loses 2 ladder points unless hurt or booked | WRONG |
| 17 | Pass: free while hurt or booked, else -2 | Behaviour matches. But `RivalOfferWire._free()` is true when the boxer is NOT booked and NOT hurt. The name is inverted, and the comment at line 98 says the opposite | OK behaviour, WRONG naming |
| 18 | Accept: always available | Accept can still fail at booking: "the bout could not be booked" (`RivalOfferWire.gd` 129-130) | PARTLY |
| 19 | Top-10 renegotiation: keep for $2,500 or drop to 20%. Belt: $5,000 or 17%. Yearly: 40% of take or -2 points, floor 12% | `StarDeal.gd` 11-18, 41-46 | OK |
| 20 | Probe: pro at 20% share, top-10 talks, "drop to 17%" | The first top-10 talks start at 25% (`START`) and drop to 20%. 17% is the belt step. 20% cannot be reached before the top 10 | WRONG |
| 21 | Belt: contract talks only | A belt also offers a title sponsor on Money > Deals (`GymDeals.gd` 43-46) | GAP |
| 22 | Top-3 milestone = (purse + $450 ticket cut) x share, less camp | After the debut a pro's bout pays only the purse share (`BoutFinish.gd` 117-122). No ticket cut. Overstates by $77 to $112 a bout | WRONG |
| 23 | Pro camp: 6% of purse, halved with the strength coach, after the debut | `StarDeal.gd` 19-20, 49-50; `GymDeals.pro_camp` 22-35 | OK |
| 24 | Scouting $250, tagged "Scouting X for Y" | `ProLadder.gd` 307 | OK |
| 25 | Ticket cut $450; zero for a championship or club show | `BoutRules.TICKET_CUT` 450. `BoutFinish.gd` 127: also zero when the host keeps the gate on a named opponent (`host_gate`, `AskFlow.gd` 169) | PARTLY |
| 26 | A win's +8 members = 8 x $35 / 4.33 = $64.7 a week, for a window | Members close 25% of the gap to a reputation target each week (cap 6). Replay: +6 members in week 1, +3 from week 4, which is about $25 a week sustained. Over 26 weeks about $700, not about $1,680 | WRONG |
| 27 | Dues come from `GymBills.week()` at a flat $35 | Live dues come from `Membership.weekly_dues` by dues band (`Sim.gd` 8-10). `CashForecast` uses `Sim.weekly_income` | WRONG source |
| 28 | Stipend $250 a week | `GameMoney.FIGHTER_STIPEND` 250 | OK |
| 29 | Per-boxer cash out is "tagged in the ledger" (section 2 heading) | Stipends are not in the ledger. They are summed into the month bill (`GameMoney.athlete_payroll`) | WRONG |
| 30 | Ledger rows carry the boxer | `Career.pay(amount, what)` writes `{d, t, amount}` with no boxer id (`Career.gd` 184-186). The map's own check says so, but section 2's heading does not | WRONG |
| 31 | Dues and bills reconcile to `Career.cash` to within $1 from the ledger | Weekly dues and settlement write cash directly (`Sim.gd` 17-22). The month bill is one line, "Month-end bill: wages and upkeep" (`Sim.gd` 23-26). Dues never appear in the ledger | WRONG |
| 32 | `CashForecast.project()` gives Keep / Pause / Release | `project(c, weeks)` takes no scenario (`CashForecast.gd` 25). Each column needs a copied career with the stipend, roster or fee changed | GAP (build work) |
| 33 | Yellow and orange alerts: 4-week net blocks, idle count | No per-boxer net or idle count found in `scripts/` | NOT IN CODE |
| 34 | Red alert: closure after 8 weeks below $0 | `GymBills.CLOSE_AFTER_WEEKS` = 8 (line 16). Red offers boxer answers only | OK, but club answers missing |
| 35 | Probe: a release is blocked only when a bout is inside 14 days | Any booked, unfinished bout blocks it (`Leaving.gd` 71-72) | WRONG |
| 36 | Probe: releasing costs -2 reputation | Player let-go: -1, or -3 if ranked (top 5 regional, or pro) (`Leaving.gd` 27-30, 89) | WRONG |
| 37 | Probe: keep 20% for $2,500 vs drop to 17%; keep pays back in about 4 bouts at a $1,500 purse | Keep (25%) vs drop (20%) is 5% of purse a bout. $2,500 at $1,500 a purse takes about 33 bouts. A 4-bout payback needs a purse near $12,500; 10 bouts, about $5,000 | WRONG |
| 38 | Probe: Half, both train x0.925, holder -4 | `Approach.gd` `TRAIN` half 0.925, `HOLDER_HALF` -4 | OK |
| 39 | Probe: Move, "holder takes day job, grievance ticks" | Also -12 holder loyalty at once | GAP |
| 40 | Pro licence $230, medicals $875, trainer's licence $140 | `ProDebut.gd` `LICENCE`, `MEDICALS`, `CORNER_LICENCE` | OK |
| 41 | Rent $1,800 a month; governing fees $315 + $18 a boxer + $35 a coach a year; insurance $1,250; power $560 winter / $280 summer | `GymBills.gd` 8-24 | OK |
| 42 | Approach answer deadline | `Approach.ANSWER_DAYS` = 7. The map gives no number | GAP (missing number) |
| 43 | Files `scripts/state/GameMoney.gd` and `scripts/state/CashForecast.gd` | They are in `scripts/rules/` | WRONG PATH |

## 5. Options: missing and useless

### Missing (the code has it, the map does not offer it)

- **M1. Half stipend (sponsorship half).** Half the pay ($125 a week), one work morning, loyalty +3 when it goes up and -4 when it goes down. It changes the cash-crisis case: a middle step that saves $125 a week without a full loss.
- **M2. Club levers on the red alert.** Dues band (cheap $25, standard $35, premium $45 a month, with different draw), kit budget (low / standard $45 / good $80 a week), evening coach hire or let-go (+$350 a week with a coach), staff let-go, premises, the club show ($3,500), and the arranged overdraft. Each has an eight-week cash effect that `CashForecast` can show. The red alert today offers only "release" or "book a bout first", both per boxer.
- **M3. Overdraft.** After 12 weeks of trading, the arranged overdraft (16% a year, per the `Career.gd` comment) changes the closure count: `CashForecast` passes the limit into `GymBills.next_below`. It changes whether the red alert is reached at all.
- **M4. Match's cash cost.** On a keep offer, Match is the most expensive answer in cash: $3,000 over 84 days, and it restarts the boxer's stipend. On a bout offer, Match costs nothing. The map shows it as free.
- **M5. Tell it straight.** Free, once per approach. It changes Half's outcome (+10 loyalty instead of +6 when it landed), the boxer's loyalty (0 when it lands, -4 when it fails), and blocks a second talk for 8 weeks.
- **M6. Promise.** $3,500 for a club show, +4 loyalty now and +10 more if it is kept. A missed night breaks it and the boxer leaves the next Monday. It is the only answer that keeps a boxer on a day job without a stipend.
- **M7. Title sponsor on a belt** (`GymDeals.check_talks`). An extra offer on Money > Deals next to the belt's contract talks.

### Useless or misleading (as the map presents them)

- **U1. "Pause stipend" for a pro.** There is no such option; a pro lives on purses. The comparison's pause column and the pro-share probes should not offer it.
- **U2. Release as a cash lever for a boxer on a day job.** It saves $0, because there is no stipend to stop. It costs -1 reputation (-3 if ranked) and -2 loyalty for each settled team-mate. Release saves cash only while the stipend is on.
- **U3. "Not this show" a second time.** It is not a refusal. It is a silent pass worth -2 ladder points, unless the boxer is hurt or booked. Show it as "counts as a pass" on the button.
- **U4. The "exit fee $0" row for amateurs** in the comparison is a row of zeros. Keep it for pros.
- **U5. Keep the pro's share, as "neither dominates".** At a purse of about $5,000 or less over 10 bouts, dropping the share wins outright. The map presents it as an even choice.

## 6. To reach 10/10

Most important first. Each item is specific enough to build.

1. **Flip the release-fee sign everywhere** (sections 1, 2, 3 and the probes). A pro's release brings in 40% of the year's take, minimum $500, rounded to $100 (`Leaving.gd` 91-93). The real choice is "fee now" against "the share this pro brings per bout". Show the break-even in bouts, using `StarDeal.gym_net(purse, 0, share, strength)`. Add a probe where release is the best cash move and still loses over the long run.

2. **Make the ledger able to reconcile.** Change `Career.pay(amount, what)` to take the boxer's id and a kind (bout, camp, bill, stipend, dues, club). Log weekly dues, and each week's stipends, as lines: `Sim.gd` 17-22 writes cash directly today. Split "Month-end bill: wages and upkeep" into rent, coaches, staff, stipends and upkeep. Then "sum of lines = `Career.cash` to within $1" becomes a unit test. Replace `GymDeals.year_take`'s text match (`t.contains(first)`) with the id, because a first name can appear in another boxer's line.

3. **Replace the per-win dues estimate.** Replay `Membership.settle_week` for the win and show the real effect: about +6 members in week 1, +3 from week 4 (about $25 a week). Or drop the per-boxer dues line and show only the +8 members in the news. Do not show $65 a week.

4. **Correct the milestone formula.** After the debut a pro's bout pays purse x share (`BoutFinish.gd` 117-122). Remove the $450 ticket cut from the top-3, belt and debut lines, and recompute each tier with `StarDeal.gym_net`.

5. **Give the warning table club-wide answers.** For the red alert, list the club levers with their eight-week cash effect: dues band, kit budget, half stipend, pausing one stipend, releasing one boxer (amateur: stipend stops; pro: fee comes in), an evening coach, a staff let-go, premises, the overdraft. This needs `project(c, weeks, change)`, where `change` is an optional dictionary applied to a copy (`CashForecast._copy` already exists). Cut the yellow and orange rows, or tag them NOT BUILT, until a per-boxer net and an idle count exist.

6. **Rewrite the approach table with each answer's cash and loyalty.**
   - Match: on a keep offer, $3,000 over 84 days and the stipend restarts; on a bout offer, free. Boxer +12.
   - Half: no cash change for the pair. Boxer +6, or +10 if the talk landed. Holder -4. Both train x0.925. Refused when the talk failed, or the offer is a bout offer.
   - Move: no cash change. Boxer +12. Holder -12 at once and -3 every 28 days. Holder trains x0.85.
   - Promise: $3,500 for the club show. +4 now, +10 if kept. A missed night breaks it and the boxer leaves the next Monday.
   - Let go: boxer leaves the next Monday. Each team-mate under loyalty 50 loses 2. Reputation -2, or -5 if ranked.
   - Tell it straight: free, once. Landed 0, failed -4. Then an 8-week wait.
   - Deadline: 7 days (`Approach.ANSWER_DAYS`). Show it.

7. **Show all three stipend states.** Full ($250 a week), half ($125, one work morning, +3 up / -4 down), day job (trains 4 of 6 days, -8 loyalty once at the pause, +5 once at the resume). Pause is for amateurs only. Say when the lock starts: from the answer, for 84 days. Or change the code so a pending approach locks, and say that instead.

8. **Fix the rival rows.** A second "Not this show" is a pass worth -2 ladder points unless hurt or booked; show it on the button. Rename `RivalOfferWire._free()` to `_charged()`, so builders do not invert it, and fix its comment at line 98. Put "the bout could not be booked" in the Accept row's refusal column.

9. **Rebuild every probe from the code.** (a) Pro share: keep 25% against drop 20% is 5% of the purse a bout. $2,500 at a $1,500 purse takes 33 bouts, and about $5,000 of purse pays back over 10 bouts. (b) Player release of a boxer with a booked bout: refused whenever a bout is booked. (c) Amateur release: -1 reputation. (d) Move: holder -12. (e) Pause: -8 once. Each probe states which decision wins, and at what number.

10. **Add the belt's title sponsor and the host's gate.** The title sponsor offer (`GymDeals.gd` 43-46) and the $0 ticket cut when the host keeps the gate on a named opponent (`BoutFinish.gd` 127-129) go into the rows and the probes.

11. **Correct the file paths and the CODE tags.** The files are `scripts/rules/GameMoney.gd` and `scripts/rules/CashForecast.gd`. Remove the CODE tag from every rule not in the code: release after 6 weeks below $0, pause after 4 weeks below $0, the idle count, yellow net blocks, "keep if a bout in 3 weeks". Or build them and cite the function.

12. **Re-score after 1-11.** Depth should reach 7 once the approach answers, the stipend states and the club levers carry their real costs. General design should reach 7 once the ledger reconciles and every tag names code that exists.
