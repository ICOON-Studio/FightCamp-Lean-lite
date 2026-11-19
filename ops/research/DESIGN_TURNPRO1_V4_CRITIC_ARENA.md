# TURNPRO1_V4 - independent design review

Kind: research. Mechanic judged: the turning-pro offer and the road into it. No Godot was run. No other critic answer was read. The verdict is on the mechanic, not on the look of any screen.

## Code files read

Read in full: `scripts/rules/ProCall.gd`, `scripts/state/ProOfferWire.gd` (the two named by the task), plus `scripts/rules/ProDebut.gd`, `scripts/state/Roster.gd`, `scripts/rules/Recruit.gd`, `scripts/state/ProLean.gd`, `scripts/ui/ProWeekLines.gd`. Also grepped `scripts/state/HomeBout.gd` and `scripts/ui/modals/ProOffer.gd` to check two wiring claims. Read `docs/TURNPROBE2_RESULT.md`, the whole brief, and `ops/research/CRITIC_ACCESS.md`. No other critic file was opened.

SCORE depth=5 general=5
PLAY 4/10

## Why these scores

DEPTH 5/10. There is a real tree here: which house to sign with when both call, one ask per house, pay the signing costs now or move them into the purse, keep or stop the stipend, accept, decline, or let the window run out. The house choice and the cash-now / cash-later choice change real numbers. But the tree is mostly dead branches. In the measured probe the costs ask was best in 68% of offers, while later+4, softer, split and no-ask were best in 3%, 0%, 0% and 0%. After the price bug is fixed (it already is in the code), the price ask has almost no downside below the 100-ticket cap, so one more option drifts toward dominant. Moving the debut later is sold as a way to let ticket growth arrive, but the offer's own money preview holds the forecast fixed; nothing on that ask causes the growth. Seven of the eight failing probe lines get no rule change at all in v4 - they get a new sentence on a page. That is presentation, not depth.

GENERAL DESIGN 5/10. The map is mostly faithful to the code and is buildable from it: the two houses' purses, shares, break-evens, gaps and weeks all match, as do the six asks and their constants, the 14-day window, the lapse-is-not-a-decline rule, the 0.9 terms deck and the cost range. But several numbers are wrong in ways a builder would trip over: the both-call band is off by one ticket, the member-to-ticket line is off by a factor of ten, the split counter's gain is about $3 not $5, the age warning is 29 in the rule and 30 in the failure table, and the flagged price bug no longer exists. One "not built" tag is stale - the club-show followers are already in the code. Three wires put a promoter's name in body text while the standing rule says names only in headers, and one "progress" readout describes people the game says are decoration. Consistent with the game's words? Partly. Clear enough to hand to a builder? Not yet.

PLAY 4/10. The countdown, the two-contract reveal and the debut ledger give a real spike of anticipation and a readable reward. Week to week, though, v4 adds almost nothing you can do: the "day-job path" is a note on NEXT STEP, the stipend switch already existed in v2, the club show already existed, and the six asks are all answered once at the offer. Between signing and the debut there is no new gate-building decision, so the four or six weeks are the old camp and weight loop with a new label. The reward lands once, at the debut, and then the mechanic ends as the design says it should.

## Number check against the code

| Map claim | Code says | Verdict |
|---|---|---|
| First call at 7 wins plus top-3 rank, or 9 wins any rank; national finalist; +2 wins after a decline; rank 1 only after two; shut after three | `Roster.pro_ready()`: `need = 7 + declines * 2`, rank 1-3, any rank at 9+, `rank == 1` at two declines, `false` at three | Correct |
| Terms 0.9 after one decline, compounding, title since decline resets to 1.0 | `ProCall.terms()`: `0.9^declines` unless `title_since_decline` | Correct |
| Ticket house: $1,500, 50% past break-even, $25 under, floor $500, 4 weeks, gap 1.0; guarantee house: $1,800, 30%, 70 tickets, 6 weeks, gap 1.5 | `ProCall.promoters()`; `ProDebut.BREAK_EVEN = 60`, `HER_SHARE = 0.5`, `TICKET_PRICE = 50`, `TICKETS = 100` | Correct |
| Both call at 45-74, guarantee house only at 44 or fewer | `who_calls()`: `>= 75` ticket house only, `<= 45` guarantee house only, so both is 46-74 | Wrong by one. At 45 tickets only one house calls |
| 14-day window; running out is not a decline; same house returns after 2 more wins | `ProCall.WINDOW_DAYS = 14`, `ProOfferWire.lapse_if_due()` sets `pro_wait_w = w + 2` and never touches `pro_declines` | Correct |
| After a decline the same house calls only | `make()` forces `keys = [last]` when `declines > 0` | Correct. After a lapse, `declines` stays 0 and `who_calls()` is recomputed, so a lapsed offer can bring both houses later - section 4.5 wrongly says there is no way to wait for the other house |
| Six asks, shown before the press, one per house, with a return to plain | `ask_answers()`, `ask()`, `back_to_plain()` | Correct. A "wont" answer is not spent, which the map does not say; a counter is applied on the press, with no separate accept step |
| Price ask bug: `money()` uses the fixed $50, ask is cosmetic, needs a CHANGE | `ProCall.money()` reads `t.get("price", ProDebut.TICKET_PRICE)` with an S529 comment | Stale. The bug is fixed in this checkout. The CHANGE line, item 10.6 and question C1 must be deleted and the probe rerun |
| Example ledger: 69 tickets, worst costs $1,245, gym -$1,245 then +$375 and +$56, +$175 a week for four weeks, -$114 at debut, boxer $1,294, even in week 5 | `money()`: sign bucket -$814, `weekly_after = 250 - 75 = 175`, `by_debut = -114`, `even_week = 5`, boxer $1,294 | Arithmetic correct. One wording problem: the code’s bucket is named `gym_at_signing`, while the table calls the same money "receivable at debut". Pick one date |
| Deferral: $1,800 - $1,245 - $200 = $355, gym $89, boxer $266 | `night()` deducts `costs_paid + costs_from_purse` before the 25% split | Correct - and it means the boxer absorbs 75% of the costs. Paying now gives the gym -$795 and the boxer $1,350; deferring gives the gym +$89 and the boxer $266. That is a $884 transfer from your boxer, not a free saving. No loyalty or morale line shows it |
| Costs $230-$1,245; fee $100 base, $200 under 8 weeks | `ProDebut.start_costs()`; `COSTS_BASE_ADD = 100`, `COSTS_RUNWAY_ADD = 200`, `COSTS_RUNWAY_THRESHOLD = 8` | Correct |
| +0.5 tickets per member, "~+4 tickets at 80 members" | `floor(80 * 0.5) = 40`, plus 20 family tickets | Off by ten. Eighty members already make 60 tickets from members and family before any wins |
| Split counter at break-even +5 is worth "~$5" to the gym | 5 tickets x $50 x 5 points = $12.50, rounded to 13; gym's 25% rounds to $3 | Off by about $2. This is why the option measures 0% |
| Age warning from 29 in section 1.1 and 6.2; from 30 with a reminder at 31 in section 9 | `ProCall.age_line()`: `age >= 29`, stop at 32 | Section 9 is wrong |
| Club-show followers "not yet built" | `HomeBout.SHOW_FOLLOWERS = 10` is added in `boxed()`, and `ProOfferWire.forecast()` reads `f["followers"]` | Stale tag. The lever exists; only the NEXT STEP wording is new |
| Later +4 weeks lets 3-4 more weeks of ticket growth arrive | `_apply_later()` changes only `debut_weeks` and `purse`; `money()` computes the preview from the offer's fixed forecast | The preview cannot show the growth. Real tickets are recomputed at the debut, but the offer gives no action that causes them |
| Later +2 is best when an amateur bout is booked in weeks 3-4 | `Roster.check_pro()` only creates an offer when `f["bout"]` is empty | At offer time no bout is booked. Only a bout asked for after the offer arrives fits this case; there is no reschedule option |
| Price ask: $40 tickets, +15 tickets, best with membership over 80 | With the cap at 100, the ask beats plain at forecasts up to 91 and loses from 92 (plain 40 x $25 = $1,000; price 40 x $20 = $800). At 69 it pays $480 instead of $225 | "Best over 80 members" is backwards, and the 85-91 band silently throws away sold tickets |
| Missed weight at debut costs $300 and 0.9 terms; cancelled bout loses the costs | No such path in the two named files | ESTIMATE. Do not show either as a rule until built |
| Names only in headers | Map rows M10, M15 and M16 put a promoter name in a body line; M10 says "no names" in the same row | Violates the standing rule. The existing night line in `ProOfferWire.night_words()` has the same leak |
| M19: +1 person a week "building toward break-even" | S409 says the gym crowd is decoration and takes no clicks | Useless readout by the game's own only-actionable rule |

## Would v4 move the measured lines?

The v2 probe is 8 of 9 failed. Judgement, line by line:

| Line | v2 | v4 lever | Would it move? |
|---|---|---|---|
| 1. No bot over 60% at week 104 | FAIL | "Day-job path diversifies" | No. v4 adds a caption, not a bot rule or a payment. In the probe every day-job bot ends at the same week-104 median; they mostly never sign. A PREP bot that actually stops the stipend earlier and builds the gate has to be written into the probe |
| 2. PREP beats YES by $1,500 paired at week 104 | FAIL, median $0 | Defer + club show | No, and the two levers pull apart. Defer improves cash now and costs your boxer $884; the club-show followers are already in the code and were available to v2. Nothing in v4 makes PREP sign at a better time |
| 3. Stipend timing, both stipend states | FAIL | `LOST_CUT_A_WEEK` | No. The constant stays 75. No-stipend YES and NEVER still end at the same -$2,417 |
| 4. Debut loses gym money 40-70% | FAIL at "27% average" | Purse floor / short-ticket | The target is already met. Stipend debuts lost money in 67% and 40% of cases in the two seed sets - inside the band. The 27% is an unweighted average over four groups, two of which had no debuts. Fix the pass line's population; do not retune the purse floor |
| 5. Door closes in 10-30% of careers | FAIL, 0% | "3-decline hard stop, already CODE" | No. That stop existed in v2 and still produced 0/60. The missing piece is a career where refusing twice is rational; v4 gives no terms or warning that change a bot's mind |
| 6. Win rate 65-80% at gap 1.0, 70-85% at gap 1.5 | FAIL, 80% / 60% | `PRO_OPP_GAP`, softer ask | No constant changes. Also the two gaps are measured on different populations - the guarantee house is picked by cash-poor, weaker careers - so 60% may be selection, not gap. Needs a paired same-fighter test before any retune |
| 7. Every ask best in at least 10% | FAIL; 3%, 0%, 0%, 0%, 6%, 68%, 0% | "Probe decides" | Partly. The price fix could take the price ask over 10% (it is already in the code and unmeasured). The other four dead options get no threshold change, so they stay dead. "Probe decides" is a decision deferred, not a design |
| 8. Guarantee house picked 25%+, both call 25-50% | PASS, 55% / 43% | Unchanged band | Yes, it stays passed. Correcting the 45 boundary changes one ticket out of the band and should not break it |
| 9. Ambition preference aligns 70% of decisions | FAIL, 3% | Visible line, -5% debut form | Maybe, but not for most careers. Only a high-potential boxer gets the title ambition; the other two strings get "follows your call", which gives the bot nothing to align with. The -5% has no code path to the fight and no visible win-band change |

Net: one pass stays passed, one failure is a measurement error, one may move after a rerun of an already-fixed bug, and five have no rule change that can move them.

## Options: which are missing, which are useless, and what each changes

### Missing from the map (some already exist in code)

- **Let the window lapse, build the gate, get a second house.** The code already allows it: a lapse is not a decline, and `make()` recomputes `who_calls()` from the new forecast. Add the line and a button with the forecast after two more wins. Changes the house choice without spending a decline.
- **A reason only one house called.** Show "44 short of both houses; +8 members or one win brings the other." Changes an opaque gate into a target the player can make.
- **Share the deferral with your boxer.** Split the saving, or charge loyalty. Changes who pays the $1,245 and stops the deferral being a free gym upgrade.
- **A reschedule window, not two fixed steps.** A date between 2 and 8 weeks with a visible purse curve. Changes later2/later4 from blunt purse cuts into a real calendar choice.
- **A cancel or postpone path after signing.** Map says there is no code path. Add the $300 slot fee and a terms hit. Changes the cost of a bad debut date.
- **A debut weight-miss rule with a number.** $300 and 0.9 terms are ESTIMATE. Changes what waiting and cutting are worth.
- **A weekly gate action in the 4-6 weeks before the debut.** Sell tickets from NEXT STEP: one coach evening, fewer pads, more followers, capped by the 100-ticket room. Changes the waiting weeks into play rather than a note.
- **A preference for all three ambition strings.** Title-first, turn-pro-now, prove-the-record. Changes the 3% alignment line.
- **A house-match ask when only one house calls.** Changes the one-house career from a take-it-or-leave-it choice into a negotiation.

### Useless as written (and what each changes today)

- **Later +4 weeks.** Changes purse -$300 and date +4 weeks; best in 3% of offers. Its stated ticket-growth reason is not in the preview. Cut it or rebuild it around a booked bout.
- **Softer opponent.** Changes a hidden gap by +0.5 and sets two tune-up fights; best in 0% because the offer shows no win-band change. Either show the new band or cut it.
- **Better split, counter branch.** Changes the boxer's share by 5 points, about $3 to the gym at break-even +5; best in 0%. Raise the gain or cut the branch.
- **No ask / Back to plain.** Changes nothing in the world; it is an undo after the one ask is spent. Keep it as an undo, but do not score it as an option in line 7.
- **Own ticket price above forecast 91.** Changes sold tickets that the 100 cap throws away; from 92 it costs the boxer $200. Either explain the cap or remove the dead zone.
- **Costs from the purse as drawn.** Changes gym cash +$884 and boxer cash -$1,084 with no trust cost, hence best in 68%. It is dominant, not a choice.
- **Roster chip "Day-job - saving".** Changes no value; there is no fund variable. Delete it or wire it to saved stipend weeks.
- **Gym floor "+1 person a week toward break-even".** Decoration given a progress meaning. Delete the number or make it a clickable link to members.
- **News and milestone lines with a promoter name in the body.** Change no decision and break the names rule. Move the name to the header or say "the promoter".

## To reach 10/10

1. **Define and rerun the probe before tuning anything.** Filter line 4 to stipend debuts only, so 40% and 67% count as a pass. For every line state the population, the objective (gym cash or boxer cash) and the seeds. Rerun all nine with the current code, not the pre-fix price code.
2. **Delete the stale price-bug work item.** Confirm the `t.get("price", ...)` line in `ProCall.money()`; remove the CHANGE, item 10.6 and C1. Then give the price ask a downside: make the ticket house purse `price * sold` rather than a count past break-even, or charge a promotion cost for the extra 15 tickets, and retest line 7.
3. **Correct the map's numbers and tags in one pass.** Boundary 45 not 44; 40 tickets at 80 members, not 4; split counter about $3; age warning 29 everywhere; 100-ticket cap shown on the ask; club-show followers marked built; "receivable at debut" and `gym_at_signing` given one date.
4. **Make waiting a visible, existing option.** On the offer, add "Let it lapse and build the gate" with the forecast after two more wins; keep full terms for a lapse and 0.9 for a decline; show which houses call at the new forecast. Correct section 4.5. Wire the line to `ProOfferWire.lapse_if_due()` and `who_calls()`.
5. **Put a cost on the deferral.** In `ProCall._costs_entry()` and `Roster.turn_pro()`, apply a loyalty or morale hit when more than half the signing costs move to the boxer, and print both purses on the button: "Gym +$884 now; boxer -$1,084; trust -N". Target: costs ask no more than 40% best in line 7.
6. **Retire or rebuild the four dead asks.** Cut later4 and the split counter, or retune with buildable thresholds: later4 only when a bout was asked for after the offer; split counter at break-even +2 with a $50 gym floor; softer available only with an injury flag and showing its new win band. Every kept ask must clear 10% in the fork probe.
7. **Fix the win-rate line with a paired test.** Hold the boxer, camp and plan constant; test gaps 0.7, 1.0 and 1.5 on the same fighter, then set `ProCall.promoters()` gaps to land 65-80% and 70-85%. Do not let house selection stand in for opponent difficulty.
8. **Make three declines reachable.** Show "Terms 0.81; one more refusal closes the door" on the second offer, and add a probe bot that refuses when terms fall below 0.8. Retune `SECOND_TERMS` or the rank-1 gate only if the closure rate is still below 10%.
9. **Give every ambition a preference.** Extend `Recruit.ambition()` and `ProCall.ambition_kind()` so all three strings carry title-first, pro-now or record-first; show one line on both buttons; wire the -5% debut form into `BoutRules.fight_power()` and into the visible win band. Target 70% alignment.
10. **Add one gate action per week before the debut.** Put "Sell tickets" on NEXT STEP: one coach evening spent, a capped follower gain, a shown cost to pads. Reuse `HomeBout.SHOW_FOLLOWERS` and `ProOfferWire.forecast()`, so no new screen is needed. That gives the four or six waiting weeks a reason to come back.
11. **Enforce the words.** Move promoter names out of the news and milestone bodies (rows M10, M15, M16 and the existing night line) into headers; remove the decoration-as-progress line in M19; show only numbers the player can change.

### The finished page at 1920x1080

A dark top bar 80px high carries the red offer flag, the 14-day count and the big button. Below it, a warm 240px header band holds the gym name, the boxer's record, rank and age, and - in the header only - the house name or the two house names. The middle is two paper-coloured columns of about 760px each, one per contract when both call, one wide column when only one does. Each column starts with five plain rows: purse, break-even, share, debut weeks, opponent gap. Under them a money strip shows gym cash now, gym cash at the debut, boxer cash and the even week, with bars that tween. The ask row is six small cards, each reading "purse / date / share / win band / trust" with the before value crossed out and the after value beside it; a "back to plain" link sits under a counter. The age line, declines left and the next-call condition sit in a narrow footer strip, followed by two full-width buttons: sign, and stay amateur, each with its morale and trust effect written on it. Nothing in the body names a person or a house. Red is used only for the last three days, a loss or a closed door. The whole screen is one screen, no drawer, and every number has a hover that names the file and function it came from.
