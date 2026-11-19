# DESIGN_TURNPRO1_V5_CRITIC_ARENA — a fresh critic on the turning-pro map (v5)

Task: TURNCRITIC5A (S530). Read the whole critic pack, then the map at the end of
`ops/research/DESIGN_TURNPRO1_V5_CRITIC_DOLA.md`; check its numbers against the code; score DEPTH and GENERAL DESIGN;
say which options are missing, which are useless and what each changes; end with "To reach 10/10".

I read no other critic's answer (no file matching `*_CRITIC_*` other than the brief above). I did not run Godot.

## Code I read

- `scripts/rules/ProCall.gd` (all of it). Constants, `who_calls`, `terms`, `debut_purse`, `money`, `asks`,
  `ask_answers`, `_apply_later`, `_apply_softer`, `_split_entry`, `_price_entry`, `_costs_entry`, `apply_ask`, `morale`,
  `ambition_kind`, `age_line`, `calls_open`, `expires`.
- `scripts/state/ProOfferWire.gd` (all). `forecast`, `make`, `sync`, `days_left`, `answers`, `ask`, `back_to_plain`,
  `signed`, `money`, `night`, `morale`, `on_decline`, `lapse_if_due`, `waited`.
- `scripts/state/Roster.gd` (all). `pro_ready`, `check_pro`, `signing_share`, `share_of`, `titles`, `debut_sheet`,
  `debut_night`, `turn_pro` (the opponent at line 306), `debut_day`, `decline_pro`.
- `scripts/rules/DayJob.gd` (all). `LOST`, `HALF_LOST`, `count_of`, `lost_days`, `gain_share`, `block_cost`.
- Read to check the numbers they point at: `scripts/rules/ProDebut.gd` (`TICKETS 100`, `TICKET_PRICE 50`,
  `BREAK_EVEN 60`, `HER_SHARE 0.5`, `MANAGER 0.15`, `TRAINER 0.10`, `tickets_sold`), `scripts/rules/Recruit.gd`
  (`ambition`), `scripts/rules/Loyalty.gd` (`MOVES`, `pro_share`, `SETTLED_AT`), `scripts/rules/BoutRules.gd`
  (`fight_power`, `play_round`, `NO_CAMP_EDGE`, `ROUND_SPREAD`), `scripts/rules/PunchStart.gd` (`bouts_of`,
  `start_levels`), `scripts/rules/AttrGen.gd` (`_attrs_build`), `scripts/rules/Membership.gd`
  (`MAX_WEEKLY_MEMBER_CHANGE`), `scripts/state/GymSpend.gd` (`set_stipend`, `set_half`, `gain_mult`),
  `scripts/state/BoutFinish.gd` (the debut's pay-out), `scripts/state/HomeBout.gd` (`SHOW_FOLLOWERS`),
  `scripts/state/ProLadder.gd` / `scripts/state/ProLean.gd` (who reads the tune-ups), and the offer screen itself,
  `scripts/ui/modals/ProOffer.gd`.

## The one-paragraph verdict

The map is organised, honest about what it does not know, and most of its constants check out against the code. Its
biggest problem is not a missing feature: its headline fix is **sign-inverted**. It raises the debut opponent's gap to
make the debut harder, while the code (and the map's own section 4.2) says a bigger gap makes the opponent weaker. Two
of its three cuts are reasoned wrongly against the probe's own data, and the one downside it does add (trust on the
costs ask) lands on a step function that the map neither measures nor prices. The true shape of the mechanic is better
than 5/10 — there is a real negotiation hiding in here — but v5 as written would move five of the ten measured lines:
one the wrong way, one by changing the probe's bot rather than the game, one only by luck, one by colliding with another
line, and one genuinely (the ambition).

SCORE depth=5 general=5

PLAY 5/10. The moment is good: a call, two houses, a 14-day clock, and the first money in a career that spent 40 weeks
costing money. The reward is felt. But the offer answers almost none of the player's questions — no win chance, no
effect of the asks on the gate, no dollar value on trust — so the player reads a money sheet and presses the button
that says "Turn pro". Anticipation is there; the reason to come back to *this* screen is not.

---

## 1. The scores, with reasons

### DEPTH — 5/10

What is genuinely deep, and already in the code:

- **Three real axes.** When to take the money (now, later, or let the call run out), who pays the licence (the gym now
  or the boxer out of the purse), and how many refusals you can afford (terms 0.9×, then rank 1 only, then shut).
- **It touches the rest of the game.** Club cash and runway (`GymBills.runway_weeks`), the stipend and its 4-week block
  (`DayJob.block_cost`), the club ticket cut, your boxer's age (32), the amateur rankings, morale
  (`ProOfferWire.apply_morale`), loyalty (`Loyalty.apply`), and afterwards the pro ladder, the world table and the share
  (`StarDeal`). A turning-pro decision really does move the club.
- **The money is shown both ways** — the gym's line and the boxer's line, and when the gym is even again. That is more
  than most management games do at the decisive moment.

What holds it at 5:

- **One dominant pick survives.** The costs ask is best in 74% of offers, and the reason is structural, not tuning: it
  is offered by the guarantee house only, and that house only calls when the ticket forecast is thin — the same careers
  that cannot pay $1,245 at signing. The ask and the situation are perfectly correlated, so there is no trade-off to
  weigh. v5 trims it with a trust hit; it does not break the correlation.
- **Three of the six asks are dead**, so the real choice is "pick the money or the money". The probe's own numbers
  (later4 0%, softer 0%, split 0%) say so.
- **The labelled refusal is the punished one.** "Stay amateur" costs 0.9× terms, +2 wins and −8 loyalty; letting the
  14-day window slide costs nothing and brings the house back at full terms. The best refusal has no button and no
  line. A player who does the honest thing is quietly fined.
- **The boxer is not in the decision yet.** The ambition path is inert (1/30), the morale word on the buttons is +0 on
  every existing ambition, and nothing on the screen says what the boxer wants. v5 adds a "pro" ambition — the right
  direction — but only for one potential band, and the pass line measures morale at signing, not the thing that
  changed.
- **The debut itself is not a decision.** The opponent is one of four names, same age, same stance, same style, same
  two tell lines, same rating offset (`Roster.gd` 304–306). There is nothing to prepare for, nothing to scout and
  nothing to plan around, on the one bout that decides whether the whole route exists.

v5 as written moves this to about 5.5 / 6: two cuts (less depth), one real downside (more depth), one warning (no new
choice), one hidden gate change (no new choice), one morale path (a little depth). It cannot reach 7 without picking
between "more asks" and "fewer, better asks" — and it has chosen "fewer" while keeping the dominant one.

### GENERAL DESIGN — 5/10

Good: no new screen; every row on the wire map is an existing element; the words are short; the constants are named in
one place; the map says which numbers are estimates and which are measured; it keeps the owner's rules (14 days, no
names in body, gender-neutral intent, TAPER). Most of section 1 is a correct transcription of the code, including the
46–74 both-call band (the code really does say `>= 75` for one house and `<= 45` for the other) and the member-to-ticket
math that v4 got wrong by ten times.

Against that: one inverted lever, two wrong cut reasons, a ledger that disagrees with the game's own numbers, a
trigger table that omits the gates that actually decide when the call comes, a pass line made to pass by changing the
bot, a 3× error in the day-job pace, and a wire map that does not distinguish what is already built from what is new.
Details in sections 2–4. It is a good working document with a broken centre; fix section 4 and this is an 8.

---

## 2. The numbers, checked against the code

| # | The map says | The code says | Verdict |
|---|---|---|---|
| 1 | §4.2 "The opponent rating is `night_power − gap`. A larger gap means a weaker opponent." | `Roster.gd:306` `"rating": snappedf(night - float(deal.get("opp_gap", PRO_OPP_GAP)), 0.1)` | **CORRECT** — and it contradicts the map's own fix (row 2). |
| 2 | §4.3 "Raise the gap 1.0 → 1.6 (and 1.5 → 2.1) to make the debut harder: target 65–80% wins." | Same line: a bigger gap is a **lower** opponent rating, i.e. an **easier** debut. | **WRONG DIRECTION.** v5's headline change would take 94% and push it toward 97%. The map also says in one breath that 2.1 "keeps the guarantee house's debut harder" and that it is "slightly easier" — both cannot be true of the same number. |
| 3 | §4.3 "Bow Lane's gap of 1.6 is a noticeably harder fight." | The base it subtracts from is `BoutRules.fight_power(stats, {}, 0, "", true)` = mean of six stats **plus `NO_CAMP_EDGE = −1.5`** (no camp at signing). So "1.0 under" is already about 2.5 under your boxer's stat mean; 1.6 makes it about 3.1 under. | **The label understates the gap and the change makes it wider, not tighter.** |
| 4 | §1.1 age cutoff / window / age warning, tagged ESTIMATE | `ProCall.AGE_STOP 32`, `WINDOW_DAYS 14`, `age_line` from 29 | **CORRECT**, and honestly tagged. |
| 5 | §1.1 "After 2 declines, only regional rank 1 brings a call." | `pro_ready`: `if pro_declines >= 2: return rank == 1` — returned **before** the win gate, so the wins requirement disappears entirely. | **Incomplete.** A 2-wins-8-losses regional number 1 gets a full first call. Decide whether that is intended and say so. |
| 6 | §1.1 trigger table: three rules | `check_pro` also needs `ProOfferWire.waited(f)` (2 wins after a lapse), an empty `f["bout"]`, and `not Champs.active(f)`; and the age gate lives in `ProOfferWire.make`, not `pro_ready`. | **Four gates missing.** A player can be 7-win top-3 for weeks and get no call because a bout is booked or the nationals are running. Worse: `Roster.pro_ready()` returns true at 33 with 0 declines while `make()` refuses, so the roster chip can say "Ready" forever. |
| 7 | §1.2 bands 46–74 both, 45 only the guarantee house | `who_calls` with `ProDebut.BREAK_EVEN 60` and `BAND 15` | **CORRECT** (v4's error fixed properly). |
| 8 | §1.3 debut purses 1,500 / 1,800, break-even 60 / 70, share 50% / 30%, 4 / 6 weeks, gaps 1.0 / 1.5 | `ProCall.promoters()` | **CORRECT**, all seven numbers. |
| 9 | §1.3 "Win bonus / top: +$500 / $3,000" | `step` is the **next** purse's rise: `BoutFinish` pays the purse, then `f["purse"] += purse_step` on a win. No bonus lands at the debut. | **Mislabelled.** The UI says "After the debut +$500 a win", which is right; the map's "win bonus" will be built as a payment that does not exist. |
| 10 | §2.1 later2 −$150 / +2 weeks; §2.2 later4 −$300 / +4 | `LATER2_PURSE_CUT 150`, `LATER4_PURSE_CUT 300`, `_apply_later` | **CORRECT.** |
| 11 | §2.2 "The stated reason for later+4 (3–4 weeks of ticket growth) is not in the money preview" | True of the **preview** (`ProOfferWire.money` reads the forecast frozen into `c.pro_offer`). False of the **night**: `Roster.debut_night` → `ProOfferWire.forecast(c, f, titles(f))` recomputes from the members on the books that night. | **Half right, wrong conclusion.** The ticket growth is real; the preview is what is broken. Cutting the ask hides a display bug. |
| 12 | §2.4 split counter "worth about $3" | `SPLIT_COUNTER_SHARE 0.05` over 5–19 tickets at `TICKET_PRICE 50` × boxer share: $12.50–$47.50 to the boxer, 25% of that to the gym | **CORRECT as an order of magnitude** — and the reason is better than the map's: the counter only exists at 65–79 tickets, exactly where the price ask pays $200–$255. The split is not bad; it is dominated in its own band. |
| 13 | §2.4/§2.5 price ask: $50 → $40, +15 tickets, and above 91 tickets plain pays $1,000 vs price $800 | `_price_entry` sets `price 40`, `extra_tickets 15`; `ProCall.money` uses `t.get("price", 50)`; `mini(100, forecast + extra)`. At 92 tickets the two are **equal** ($800 each); plain gains $25 for every ticket past 92, $200 at the 100-cap. | **CORRECT**, including the "above 91" cutoff. Best in the map. But the "When best 60–91" range is too narrow: from 46–60 tickets plain pays **nothing** past break-even while the price ask pays $20–$300, so the ask is at its strongest exactly where the map says it is not offered. |
| 14 | §2.5 "the lower price costs you $200" | $40 is lower than $50 — the ask trades price for bodies | **CORRECT** wording. |
| 15 | §2.6 costs ask: $0 now, fee +$100 (runway ≥ 8 weeks) / +$200 (runway < 8), deducted before the split | `COSTS_BASE_ADD 100`, `COSTS_RUNWAY_ADD 200`, `COSTS_RUNWAY_THRESHOLD 8`; `ProOfferWire.money` subtracts costs **and** fee from the purse before `ProCall.money` splits it; `night()` floors the purse at 0 | **CORRECT.** Two holes the map misses: (a) the purse is floored at zero, so on a small debut the boxer never repays the whole deferral and the promoter silently eats the rest; (b) the ask exists only at the guarantee house, which is the house that calls the poor careers — the dominance is structural. |
| 16 | §2.6 "−10 loyalty … lowers the gym's future share on later pro fights" | `Loyalty.MOVES` already has `turn_pro: +5` and `decline_pro: −8`. `Loyalty.pro_share` has exactly **two** values: 25% at loyalty ≥ 50, 10% below. `Roster.turn_pro` sets `f["gym_share"]` from `pro_share` **before** `Loyalty.apply("turn_pro")`. | **Not a slope, a cliff, and the net is −5 not −10.** Whether it bites is decided by whether loyalty was 55+ before signing — invisible to the player and effectively a coin toss. If it crosses 50 the club keeps 10% of **every** pro purse until contract talks (first top-10 / first belt), and the offer screen then prints the outside-manager warning. The map should state the ordering and the two possible shares, not "future share lower". |
| 17 | §3.1 signing costs $230–$1,245 | `ProDebut.start_costs(230 licence, +875 first licence, +140 coach licence)` | **CORRECT.** |
| 18 | §3.2 ledger at 70 members, 7 wins: "69 tickets forecast" | `tickets_sold` = 20 + 35 + 14 = 69 ✓ — but the number the offer shows is `ProOfferWire.forecast`, which **adds `f["followers"]`** (`HomeBout.SHOW_FOLLOWERS = 10`). A boxer who has topped the club's own show is at 79, which is past `60 + 15`: the guarantee house does **not** call, and the whole example (and its costs ask) is unavailable. | **Wrong number.** Say which figure the ledger uses. |
| 19 | §3.2 "Gym's 25% of the purse ($1,500) = $375", "break-even week 5" | True at `StarDeal` 25% **and** loyalty ≥ 50. At loyalty < 50 the share is 10%: $150, and the debut total goes from −$114 to −$339. `decline_pro` is −8, so **one refusal** from a starting loyalty of 50 drops it to 42 → 10%. | **A missing row that changes the ledger's answer.** This is also the real price of refusing, and the map's section 5 does not mention it. |
| 20 | §3.4 "80 members = 60 tickets (20 family + 40 from members)" | `FAMILY 20 + floor(80 × 0.5)`, cap 100 | **CORRECT** (v4's factor-of-ten error genuinely fixed). |
| 21 | §5 the door: 3 declines shut it; a warning is what is missing | `DECLINE_NEWS` already writes "Only a regional number 1 brings another call." / "No promoter will call." **after** the fact, and `ProOffer.gd` already prints "Declines left before the door closes: N" and "Second call: 90% of the first terms." | **Mostly built.** The marginal change is one words line, not a wiring gap. The genuinely missing information is the loyalty −8 and the share collapse (row 19). |
| 22 | §6.1 ambition words and the dead "pro" path | `Recruit.ambition` returns exactly the three strings quoted; `ambition_kind` looks for "title" then "pro"; none contains "pro" | **CORRECT — the best finding in the map.** The v4 critics were right and v5 diagnoses it precisely. |
| 23 | §7.3 "Six wins on a day job takes about 30 weeks (a win every 5 weeks); seven takes 35+" , target 30% called | The probe's own table: day-job median **6 wins and 2 losses at week 104**, best rank 4. That is a win every ~17 weeks, not 5. Stipend careers median 10 wins at rank 3. | **Off by ~3×.** The gate is not the only binding leg — the rank leg (median 4, needs ≤3) binds too — so "lower 7 to 6" moves the win leg only, and the median career sits exactly on 6, which makes the 30% target a coin toss rather than a design. |
| 24 | §7.2 "slower is real: a day-job boxer loses 2 coached mornings a week" | `DayJob.LOST 2`, `gain_mult` = (5−2)/6… actually `(WEEK_DAYS 6 − count_of)/6` = 4/6 training. And `count_of` returns **0 the moment your boxer turns pro**. | **Correct on the penalty, silent on the fact that it ends at signing** — so the day-job story is about reaching the door, not about the pro career. Also unmentioned: the half sponsorship already in the code ($125, one morning, `set_half`), which is the tuned middle the player can already choose. |
| 25 | §1.1/§9 "the day-job arms" | In the probe, all six bots end the day-job half at the same dollar ($12,110 at w52, −$2,417 at w104) | **One arm, not six.** Half the population (180 of 360 careers) contributes no variance, so pass line 1 ("no bot dominates") is half-vacuous and line 3 is unsatisfiable by construction. |
| 26 | §10 wire map as a work list | M1, M2, M3 (declines left, 0.9× factor, morale on buttons), M4 (`NextStep` pro step), M5, M9/M10 (`ProWeekLines`), M11 (proxy of the same), M14 (`BoutHistory` milestone) are **already shipped** (S523/S524 comments in the code). | **No BUILT tag.** A builder cannot tell the 6 new rows from the 12 existing ones. |

Net: of the numbers it quotes, the great majority are right, and two of its own corrections (the band, the member
maths) are right. The errors cluster where the map reasons from a number to a cause — section 4 (direction), section 2
(why the cuts are dead), section 3 (which forecast), section 5 (what a refusal costs), section 7 (the pace).

---

## 3. Would v5 move the ten measured lines?

| Line | v5's move | Will it move? |
|---|---|---|
| 1 no bot dominates | nothing direct (day-job route only) | **No.** The line passes today only because every bot is broke at w104 (−$1,444 to −$3,233). It measures the club's economics, not the decision. Half the population is one arm (row 25). |
| 2 PREP beats YES by $1,500 | the line is cut | **Cut, not answered.** And nothing replaces it: "prepare before signing" still has no lever in the game. It should be fixed (see 10/10 #4), not deleted. |
| 3 stipend timing | unchanged, "rerun to confirm" | **Cannot pass.** In the no-stipend half both bots run the identical career to the dollar. Redefine it (stipend vs half vs day job at w52) or drop it. |
| 4 a stipend debut loses money 40–70% | indirectly: costs gets more expensive, gap "harder", price warning | **Will move against line 7.** If the costs ask drops to ≤40% the deferral becomes rarer, the gym pays $1,245 at signing again, and line 4 climbs back above its band. Lines 4 and 7 fight each other; the map does not say which wins. |
| 5 the door shuts 10–30% | a warning line, and a new bot that refuses at 0.85 | **Passes without the game changing.** The line becomes a property of the bot's threshold. The design question — what does the third refusal cost that the first two did not — is unanswered (and the answer is in the code: nothing extra; the real cost is −8 loyalty, row 19). |
| 6 win rate 65–80% / 70–85% | gap 1.0 → 1.6, 1.5 → 2.1 | **Moves the wrong way** (row 2). Even with the sign fixed, 0.6 points is a nudge on a 0–100 level that offsets all 14 abilities uniformly (`AttrGen._attrs_build`: `a[k] = level + shape + wear`), against a game that already rolls ±13.5 a round (`ROUND_SPREAD 27`). No probe has ever measured the slope; the map admits it and then writes the number as if measured. |
| 7 each kept ask ≥10%, costs ≤40% | three asks deleted, price downside shown, costs loyalty −10 | **Partly, and by the wrong measure.** "Best of the six" compares asks with each other, so the biggest cash transfer (deferring $1,245) wins by construction and everything else reads 0%. Cut asks should be scored against **the plain deal on the same offer**, not against the deferral. The price warning is real and will help price. Costs at ≤40% via a threshold-driven loyalty hit is luck, not tuning (row 16). |
| 8 house pick 63% / both 43% | nothing | **No change needed** (it passes) — but note the map is changing the gaps of exactly the two houses whose relative appeal it is not measuring. |
| 9 ambition aligns 70% | a "pro" ambition for potential 60–77 with 3+ bouts | **Moves, and cannot be read.** The line measures morale at signing; the change's better half is the −5 for *staying*, which that line never sees. Measure days-to-signing and morale at week 52 instead. |
| 10 day-job careers called ≥30% | the win gate 7 → 6 | **Possibly, by luck.** The median day-job career is exactly 6 wins, so half clear the win leg — and the rank leg (median 4, needs ≤3) decides the rest. Unprobed, and the map's own pace arithmetic is 3× off. |

---

## 4. The options: what each changes, which are useless, which are missing

### 4.1 What each live option changes (in the code, today)

| Option | What it actually changes |
|---|---|
| Turn pro with this house | Ends the stipend (−$250/wk for the club) and the amateur cut (−~$75/wk), freezes the purse (1,500 / 1,800), books a Saturday 4 or 6 weeks out, sets a 4-round debut, generates the opponent (four rotating names, 0.0 record, rating `night − gap`), sets the gym's share for the pro career, +5 loyalty, morale by ambition. |
| Stay amateur | Terms 0.9× (compounding), the win gate +2, `pro_declines +1`, −8 loyalty (**the club's pro share can fall from 25% to 10% for good**), morale −5 only with a "pro" ambition (never fires today), a news line naming what is left. |
| Let the 14 days run out | Nothing. The same house calls again at **full** terms after 2 more wins. Strictly cheaper than "Stay amateur" in money, loyalty and terms. No button, no line, no warning. |
| Ask: later +2 | Purse −$150, date +2 weeks, ~$350 more stipend saved, and up to ~6 more tickets at the night (unseen in the preview). |
| Ask: later +4 | Purse −$300, date +4 weeks, up to ~12 more tickets at the night (unseen). |
| Ask: softer opponent | `opp_gap +0.5` (a weaker opponent — easier debut), and the next 2 pro offer sets lean tune-up (`ProLean` reads `pro_tune_ups`). Invisible on the offer; visible on Fights later. |
| Ask: better split (take) | +10 share points to the boxer, opponent 0.5 harder, only at 80+ tickets. |
| Ask: better split (counter) | +5 share points, only at 65–79 tickets; $12.50–$47.50 to the boxer, ~$3–$12 to the gym. |
| Ask: own ticket price (ticket house only) | $50 → $40 and +15 tickets. Plain pays nothing past break-even under 61 tickets; the ask pays from 46. The edge peaks at 60–61 tickets (~$280–$300 to the boxer), shrinks to **equal at 92**, then loses $25 a ticket past 92 and $200 at the 100-ticket cap. |
| Ask: costs from the purse | The promoter pays $230–$1,245 now; it comes off the gross purse plus a $100 fee ($200 if runway < 8 weeks); the purse floors at 0, so a small debut never repays it all. |
| Back to the plain offer | Undo after a counter; the one ask stays spent. |

### 4.2 Useless (and why, from the code rather than the prose)

1. **later +4.** 0/31 best, and its real effect (ticket growth) exists at the night but not in the preview. v5 cuts
   it; the right move is to show the growth and keep it — the ask is the *only* lever on the one number that decides
   who calls (the forecast reads members, and members grow up to 6 a week).
2. **softer opponent.** 0/31, and the gap change is the *wrong direction* for difficulty anyway (row 2). But the ask
   is also the only link into `ProLean`'s tune-up sets; cut it and that code and its line go dead. Either wire it into
   something visible at the debut or delete `ProLean`'s tune-up branch with it.
3. **better split, counter.** ~$3 to the gym at its floor. Dead by arithmetic.
4. **better split, take.** 0/31 not because it is bad but because it shares its band (80+ tickets) with the price ask,
   which pays more. Two asks competing for one situation is one ask too many.
5. **the three disabled "won't" buttons.** Half the ask grid is greyed on every offer. The owner's rule is "only
   actionable information"; a disabled row with a tooltip explaining why is still a row the player reads and cannot
   act on. Show only the asks that can land, and say in one line why the house will not move on the rest.
6. **"no ask" / back to plain.** Not an option, an undo. The map is right to say so; keep it out of the scoring.
7. **The decline-vs-wait pair.** Not useless, but one of the two is: waiting dominates refusing on terms, money and
   loyalty. A mechanic where the unlabelled path beats the labelled one is a bug with a design name.

### 4.3 Missing — the options a manager would reach for

1. **"Let the call run out."** The best refusal in the game has no button. It should be a third, honest option on the
   offer: "Don't answer: the offer goes in N days, the same promoter calls after 2 more wins at the same terms."
2. **A move on the gate.** The ticket forecast is the number the whole call pivots on (`who_calls`), it is drawn on
   the offer, and the player cannot act on it in 14 days. The game already has the action: the club's own show
   (Club → Money → Book the show, $3,500, 400 seats, $25) and `HomeBout.SHOW_FOLLOWERS` (+10 tickets for topping
   your own show). A promoter's offer that can be answered with "put your boxer on my show" is the missing option that makes
   "later" a strategy instead of a $150 discount.
3. **A win chance for the debut.** Amateur offers show a band that narrows with tape study. The pro debut — the one
   bout that decides whether a 40-week amateur career turns into a pro one — shows "a debutant 1.0 under" and no
   chance at all. `BoutRead.likely` / `BoutRead.band` already do this for every other bout.
4. **A scout ticket for the debut opponent.** $250 buys the weapon and the weakness on Fights for pro bouts; the debut
   opponent is generated at the moment of signing with `threat: "Heavy right hand"` and `weak: "Fades after round 3"`
   for free. Either sell the scout or randomise the tells; today the debut has no unknown in it.
5. **The sponsorship switch inside the decision.** The day-job finding is not a gate problem, it is the price of the
   sponsorship the player already chooses (full $250 / half $125 and one morning / day job $0 and two mornings). The
   offer should show what each choice cost in the amateur years and what it buys at the door — and note it stops
   mattering the day your boxer signs (`DayJob.count_of` returns 0 for a pro).
6. **The true price of a refusal, in dollars.** The offer never says "refusing costs your club 15% of every purse
   until we renegotiate". It is in `Loyalty.pro_share` and it is the largest number on the screen.
7. **A named price from your side.** One ask, take it or leave it, is a menu, not a negotiation. "I want $2,000 or a
   later date" — the promoter says yes or no and why — is the option a manager would actually use, and the game
   already has the pattern (amateurs' "Ask for a fight" with a reason and a DUCK ledger).
8. **An age clock on the offer itself.** "First calls stop at 32" appears only from 29 and only as a line; there is no
   "this is the last call you will get" for the 31-year-old. The state is one integer away from the button.

---

## 5. To reach 10/10

Most important first. Each is specific enough to build; where it needs something the game cannot do, it says so.

**1. Fix the sign of the opponent gap, and find the number by measuring, not by assertion.**
`Roster.gd:306` is `rating = night − opp_gap`: a bigger gap is a weaker opponent. Delete §4.3's 1.6 / 2.1 and the
duplicate claim that the guarantee house is both harder and easier. Run one paired sweep on **one fixed boxer** through
`ProOfferWire.signed` (so the override actually reaches the deal this time) at gaps **−4, −1, 0, 1.0, 4, 8**; the
answer is the gap whose chance band lands at 65–80%. Expect the needed change to be several points, not 0.6: the gap
is a uniform offset on all 14 abilities (`AttrGen._attrs_build`) inside a game that rolls ±13.5 a round
(`ROUND_SPREAD 27`). Then set `ProCall.promoters()` and `Roster.PRO_OPP_GAP` from the curve, and let the house keep its
0.5 handicap (guarantee house 0.5 easier) written in **one** place, read by both.

**2. Put the win chance on the offer, in words, next to the gap.**
"A debutant: about 72% to win (63–81% until you scout)." Use `BoutRead.likely` and `BoutRead.band`, which every
other bout already uses. Replace "a debutant 1.0 under" with the chance plus the record. Without this, no change to
the gap can be felt, because the player cannot see what a tenth of a point is worth — the same reason the map
correctly cuts two asks.

**3. Make the costs ask a price, not a cliff.**
Drop the −10 loyalty. Charge a fee proportional to what is deferred — 15% of $1,245 = $187, or one share point off the
boxer's ticket share — and print both sides on the button: "The promoter pays $1,245 today. She repays $187 at the
debut. Your share stays 25%." If a trust cost is wanted, gate it on the boxer's own words (an ambition or a trait, "your boxer
hates owing anyone") and show the exact share before and after, because `Loyalty.pro_share` has only two values (25%
or 10% below loyalty 50) and a −10 therefore does not mean "a bit less", it means "the club loses 15 points of every
purse" or nothing at all.

**4. Fix the preview so a later debut pays, then keep later +4 and answer line 2.**
`ProOfferWire.money` values the offer at the forecast frozen on the day it arrived. The night already recomputes it
(`Roster.debut_night` → `forecast(c, f, titles(f))`). Show the projection for the debut date: members grow at most 6 a
week (`Membership.MAX_WEEKLY_MEMBER_CHANGE`) at 0.5 ticket each, so "+6 weeks: about 81 tickets, +$525 to your boxer". With
that row on the screen, later+2 and later+4 have a visible price, "prepare before signing" becomes a real player
strategy (line 2 is answered by a mechanic instead of deleted), and the map no longer cuts an ask for a number it
simply refused to display.

**5. Show what a refusal costs, and add "let it run out".**
Three lines on the Stay amateur button, before the press: "Terms 0.9×; the next call needs 2 more wins; **loyalty −8**
— under 50 your club keeps the trainer's 10% instead of 25% of every purse; one of two refusals used." Then a third
foot button, "Don't answer (the offer goes in N days; the promoter calls again after 2 more wins at the same terms)".
This turns line 5 from "make the bot reach the door" into "make the player choose the door", and it retires the worst
thing in the current build: the honest option is the punished one.

**6. Score each ask against the plain deal, not against the other asks.**
The probe's "best of six" makes any big cash transfer win by construction, so the deferral always wins and everything
else reads 0%. For each offer, record: does this ask beat the plain deal, by how much, and in how many offers is it
the only ask that helps. Then decide the three cuts on that, and if an ask survives, name the situation on the panel
("behind on the gate", "cash now", "a date I cannot move", "a bigger share"). This also settles whether the price ask
is a 6% option or (as its own arithmetic says at 46–91 tickets) the strongest ask the ticket house offers.

**7. Answer the day-job question with the lever the player already holds, not a hidden gate.**
Do not lower the win gate to 6. Instead (a) probe the half sponsorship as a third arm ($125, one lost morning) — the
game already has it (`GymSpend.set_half`); (b) let the call also come on the gate itself, because a promoter signs
ticket-sellers: a boxer with 6 wins and 70 members sells about 67 tickets, past the guarantee house's break-even of 60
— so add "or a forecast of 75+ with 5 wins"; (c) show the three states on the boxer's card with their training cost
(6/6, 5/6, 4/6 mornings). A route the player can see and pull is worth more than a gate the player cannot.

**8. Fill the two holes in the trigger table and stop the chip lying.**
Add to §1.1: no bout booked, not in the nationals, `waited()` after a lapse, and the age gate that lives in
`ProOfferWire.make` rather than `pro_ready` — and move the age test into `pro_ready` so the roster chip cannot say
"Ready" at 33. Decide the rank-1-after-two-declines case explicitly: today the win gate vanishes entirely at rank 1.

**9. Wire the "pro" ambition, and measure the half that costs something.**
Keep the `Recruit.ambition` branch exactly as v5 writes it (it is right), but measure **days from ready to signing**
and **morale at week 52**, not morale at signing — the −5 for staying is the half that changes behaviour and it is
invisible to the current line. Show the boxer's line on the offer ("She wants this: +5 morale" / "She wants a title
first: −5"), which the buttons already print through `_mood()`.

**10. Give the wire map a BUILT column, and put the deletions in the work list.**
At least M1, M2, M3 (declines left, the 0.9× line, morale on the buttons), M4, M5, M9/M10 and M14 are already shipped
(S523/S524). And every CUT needs its deletion named: `ProCall.asks()`, the three `ask_answers` entries,
`_apply_later(…, 4, …)`, `_apply_softer`, `_split_entry`, `LATER4_PURSE_CUT`, `SPLIT_*`, `SOFTER_OPP_ADD`, plus the
`ProLean` / `f["pro_tune_ups"]` reader if softer goes. Otherwise the cut asks stay in the UI as greyed buttons and
`ProCall.asks()` stays as a dead list.

**11. Make the debut opponent a person, not a constant.**
Four names by day-of-month, all age 24, orthodox, boxer-puncher, the same two tells. Give the opponent a 2–4 bout
record, one weapon, one habit and a style drawn from the same generator every other bout uses, and price the house's
gap off *that* opponent rather than off a global constant. The debut should be the first bout where the file matters.

**12. Clean the ledger to the game's own numbers.**
Use `forecast` (with followers), show the live share (25% or 10% by loyalty) as a row, label "$500 a win" as the next
purse rather than a bonus, and add the row the deferral hides: the purse floors at 0, so a short debut leaves part of
the licence unpaid and the promoter carries it.

---

## 6. My 10/10 as a 1920 x 1080 page

One screen, the offer, 1920 x 1080, warm wall, the paper sheet the promoter left. Header only, once: the two houses'
marks and "A CALL TO TURN PRO". Everywhere else: "your boxer", "the promoter", "the ticket house", "the guarantee
house". No new screen: this is the existing pro offer modal, grown.

```
+---------------------------------------------------------------------------------------------+
| <  GYM NAME       Mon 12 Oct 2026 (Wk 41)      CASH $4,120 (+$180/wk)      CONTINUE  >      |
+---------------------------------------------------------------------------------------------+
| A CALL TO TURN PRO.  Two promoters call.  The offer stands 14 days.  Refusals left: 2 of 3. |
|                                                                                             |
|+ THE TICKET HOUSE -------------------------+   + THE GUARANTEE HOUSE ----------------------+|
|| Purse $1,500, $25 a ticket under 60       |   | Purse $1,800, guaranteed                  ||
|| Debut: Sat 7 Nov, 4 rounds, 4 wks out     |   | Debut: Sat 21 Nov, 4 rounds, 6 wks out    ||
|| Opponent: a debutant, 0-0                 |   | Opponent: a debutant, 0-0                 ||
|| About 72% to win (63-81% unscouted)       |   | About 78% to win (69-86% unscouted)       ||
|| [ Scout $250: weapon, weakness, the       |   | [ Scout $250: weapon, weakness, the       ||
||   chance range narrows ]                  |   |   chance range narrows ]                  ||
||                                           |   |                                           ||
|| THE GATE now 69 -> at the debut ~75       |   | THE GATE now 61 -> at the debut ~67       ||
|| #############-------- 60 break-even       |   | ##########--------------- 70 break-even   ||
||                                           |   |                                           ||
|| YOUR MONEY     sign    in 4 weeks         |   | YOUR MONEY     sign    in 6 weeks         ||
||  licence + scans  -$1,245   -$1,245       |   |  licence + scans  -$1,245   -$1,245       ||
||  your 25%           +$431     +$431       |   |  your 25%           +$450     +$450       ||
||  stipend saved          -    +$1,000      |   |  stipend saved          -    +$1,500      ||
||  amateur cut lost       -      -$300      |   |  amateur cut lost       -      -$450      ||
||  NET                -$814     +$100       |   |  NET                -$795     -$245       ||
||  even again: 5 weeks after                |   |  even again: 4 weeks after                ||
||                                           |   |                                           ||
|| ONE ASK (pick one; the answer shows)      |   | ONE ASK (pick one; the answer shows)      ||
||  (o) Later +2 wks: -$150, gate ~+9        |   |  (o) Later +2 wks: -$150, gate ~+9        ||
||  (o) Own price $40 +15 tickets:           |   |  (o) Costs from the purse: pay $0         ||
||      +$210 under 92, -$200 above          |   |      now, your boxer repays $187 at       ||
||      (the hall holds 100)                 |   |      the debut, your share stays 25%      ||
||  (-) costs: a gate-backed purse           |   |  (-) price: the purse is fixed            ||
||      cannot be paid up front              |   |                                           ||
||                                           |   |                                           ||
|| YOUR BOXER WANTS: "Turn pro and           |   | YOUR BOXER WANTS: "Turn pro and           ||
||  build a career" -> morale +5 now         |   |  build a career" -> morale +5 now         ||
||                                           |   |                                           ||
|| [ TURN PRO - TICKET HOUSE ]               |   | [ TURN PRO - GUARANTEE HOUSE ]            ||
|| [ PUT YOUR BOXER ON MY SHOW ]             |   |                                           ||
|+-------------------------------------------+   +-------------------------------------------+|
|                                                                                             |
| STAY AMATEUR  morale -5, loyalty -8, terms 0.9x, +2 more wins. Under 50 loyalty             |
| your club keeps 10% not 25% of every pro purse.                                             |
| DON'T ANSWER  the offer goes in 14 days; the promoter calls back after 2 more               |
| wins at the same terms, no refusal counted.                                                 |
+---------------------------------------------------------------------------------------------+
```

The figures on that page are illustrative, not measured; the rows are the point.

Six things that page does that v5 cannot yet: it says the chance, it says what the gate will be on the night, it puts
a dollar figure on every ask including the one it refuses, it names what your boxer wants, it gives the club's own
show as an answer, and it makes the two refusals different so the player can choose one.

A buildable HTML file of the page is a **separate deliverable**: this task's contract is one markdown file and nothing
else, so the wireframe above is the mockup for now.

---

## 7. One line for the owner

Keep section 1, section 2.5 (the price cutoff is the best work in the map), and section 6.2 (the dead ambition is
found and fixed correctly). Throw away the opponent-gap change and start it again from a measured curve; stop cutting
asks that fail because the metric is dominated by the deferral; and put the win chance, the gate and the dollar value
of trust on the screen, because those three lines are the whole mechanic.
