# LADDER1 v5 - revise the season ladder (Kalli, S494)

Round v4 scores: Dola depth 8 / general 8 / play 7 (passes); John depth 6 / general 6 / play 7 (misses the owner's 7 and 7
bar). Write v5 as a full map that replaces v4.

THE OWNER LIKED JOHN'S 10/10 SCREEN (verbatim: "this is not bad that john made"): the ladder table with filters (In reach,
Legal now, Likely yes 50+, Ranked, Rivals, Pros), columns record / Rep / style / last / win chance / will say yes / win gives /
loss costs, a hover "Why 62 in 100" breaking the yes chance into parts, greyed rows that say why they cannot be asked, a
"Your boxer v the #3" card with will-say-yes and win-chance boxes, what a win and a loss do, the show and camp, "To raise the
yes" tips, one big ASK FOR THIS BOUT button, the Rep bar with its unlock marks (sponsor, pro offer, squad camp) and the season
strip of shows. Design v5 so that screen is the one the player uses; keep its structure.

Fix John's points (his full critique is below), most important first:
1. The pick is priced in one currency (Rep) and the card shows only that price, so it becomes "take the highest number".
   Put the real trade on the card: training weeks lost (camp or none), money (purse, ticket cut, travel), morale and the risk
   of a layoff (a stoppage loss = suspension), with numbers from the game's rules (amateur bouts need no camp, 1-2 weeks out).
2. A 12-30 row table read every fortnight is heavy: the default view must show the few rows that matter (In reach + Legal
   now), the rest one click away.
3. Keep everything Dola scored high.
Names: a boxer's name is that row's header (the list is of people); no names in the lines, tips or buttons (owner S448).
End with a table of every menu the ladder appears on and what each is wired to (owner S425).

# YOUR v4 MAP

# DESIGN_LADDER1_V4_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ187)

Brief: research/DESIGN_LADDER1_V4_REVISE_KALLI.md
Sent: 2026-11-15 20:10 | collected: 2026-11-15 20:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm writing LADDER1 v4 in full. Nothing hands you a next opponent any more: the player picks, and the rules limit, price and answer the pick. The repo is still out of reach, so I haven't opened `CRITIC_ACCESS.md`. This version is built from the pack and my v3 map.

# LADDER1 v4: the player picks the opponent; the rules limit and reward the pick (S493, 2026-11-15)

Part 1 of 4. This is a full map that replaces v3 (SQ175). Nothing outside this page stands.

**The owner (Q-250, verbatim):** "Why do you make the ladder scripted,make it so player can deicde whos the best opponent for his fighter at any given time and apply rules"

**I keep Claude's reading in full.**
- There is no next opponent and no sequence of rungs.
- At any time the player opens the ladder, sees every ranked boxer of that sex, class and region, and asks for the one they think is best right now.
- Rules shape the pick:
  - a reach limit that widens with reputation;
  - pay by the gap;
  - a deterministic yes or no from the other side;
  - the mandatory challenger and the eliminator as rules for the top;
  - amateur bouts within 1–2 weeks with no camp;
  - offers from others that the player takes or leaves.

The one thing I add: the coach's star goes (section 5). A star picking a row is the script coming back through the side door.

**Not opened:** `CRITIC_ACCESS.md`, the Miro board and the mockups, because the repo was unreachable this session. Code names come from the pack.

**Owner rules kept**
- **S475:** reputation is the currency.
- **S428:** amateur bouts happen within 1–2 weeks with no camp, and every fight shows the rank earned.
- **S425:** wired and shown on the correct menus.
- **S448:** names only in headers.
- **S412:** no fixed he or she.
- **Pack 4.5:** "a 'no' is a closed panel or an absent answer with its reason, never a random refusal".
- **Pack 7:** nothing opens by itself, and only actionable information.
- **Classes:** women 57/60/65/70/75 kg, men 57.5/60/70/75 kg. One ladder per sex and class, because females never fight males.

**Marks**
- **(P):** a number this map proposes, untested.
- **CODE:** in the game today, per the pack.
- **DERIVED:** worked from the formulas here.
- **ESTIMATE:** a real-chance figure in a worked case; the probes decide.

## 1. The rules

### R1 The ladder is always open (CODE tables, NEW use)
- One table per region, sex and class, sorted by reputation 0–100.
- It's the same table World > Rankings shows.
- Rank is a position among boxers with 4+ wins (CODE). Boxers under 4 wins sit greyed below a line and can still be asked.
- Data: `Region.gd` (ladder members), `Roster.gd` (your boxers), CODE results from club shows.

### R2 How far up you may ask (v3 kept, P)
**The reach line** is 10 + your reputation ÷ 5 above you, rounded down:

| Your reputation | You may ask up to |
|---|---|
| 0 | 10 above |
| 30 | 16 above |
| 55 | 21 above |

**Down has no limit, but asking far down buys nothing (closes John's hole):**
- A bout with someone **20 or more below** doesn't stop the clock (R7).
- It pays almost nothing (R3).
- Its row carries the chip **WON'T STOP THE CLOCK**.

### R3 What a win and a loss are worth: by the gap, zero-sum (v3 kept, P)

$$ \text{expected} = \frac{1}{1 + 10^{(\text{opp} - \text{you})/25}} $$

- **The winner gains** 16 × (1 − expected) × win weight. The loser loses the same amount.
- **Win weights:** stoppage 1.15 (plus 2 more each way), unanimous 1.0, majority 0.65, split 0.5.
- **Draw:** each side gets 16 × (0.5 − expected).
- **Rounding:** rounded once, and both sides get the same whole number.
- **Floor:** reputation can't go below 0. The shortfall is logged as "Ladder top-up" on the week review.

**Unanimous results by gap** (DERIVED; gap = their reputation minus yours):

| Gap | Expected | Win | Loss |
|---|---|---|---|
| −40 | 97.5% | 0 | −16 |
| −20 | 86% | +2 | −14 |
| −10 | 72% | +5 | −11 |
| 0 | 50% | +8 | −8 |
| +10 | 28% | +11 | −5 |
| +20 | 14% | +14 | −2 |

Beating someone above moves you more, and losing to someone far below costs more. That's (b) in Claude's reading, and the same numbers sit on every row.

### R4 The other side may say no: their manager's rules, never a roll (NEW, P)
An ask gets **YES** only when every line below passes. Otherwise the row shows the word, its reason and the way to a yes.

| Word | Their manager says no when | Way to a yes |
|---|---|---|
| **OUT OF REACH** | They're above your reach line (R2) | "Needs 6 more: about one win above you" |
| **TOO RISKY FOR THEM** | They're protecting: within 3 of 55 (the pro offer), in Pro talk, or with a regional stage inside 4 weeks. **And** your expected against them is 40% or more | Wait for the mandatory (R6). Or come back once their stage is past |
| **DUCKED** | They're up to 8 above you, and your boxer won the last 3 and gained 15+ in 8 weeks | Logged. Two DUCKED from anyone in 8 weeks makes your boxer **OWED** (below) |
| **BOOKED** | They have a bout on both of your possible dates | "Free from 22 Mar" |
| **RESTING** | Either boxer is inside the 8-week rest after a stoppage (CODE `STOP_REST_WEEKS`) | The date |
| **AT THE NATIONALS** | Either boxer is in a nationals run (CODE) | The date the run ends |
| **NOT SAFE** | A novice (0–10 bouts) against an open boxer (CODE rule) | "Opens after 3 more bouts" |
| **CLUBMATE** | Same gym | None |
| **TWICE THIS SEASON** | A third bout with one opponent this season | 4 Jan |
| **TOO HEAVY** | Making the class on that date needs more than 1 kg a week (P) | The later date, or start a cut |
| **CAP REACHED** | 18 bouts this season (CODE) | 4 Jan |

**OWED (NEW, P):**
- An owed boxer's next ask to anyone who ducked them can't be refused except for date words (BOOKED, RESTING, AT THE NATIONALS).
- If the ducker still won't take it, the ducker pays 3 reputation to your boxer (zero-sum, logged).

So ducking has a price, and a hot boxer has a way through. The manager weighs your reputation (reach and expected), their own rank (protecting) and the date (the date words). That's (c), and every input is a number the game holds.

**Weight under the TOO HEAVY line** isn't a refusal. The row carries the CODE **Weight at risk** chip ("1.4 kg to go by Fri") with Start a cut and Later date.

### R5 The date: amateur bouts within 1–2 weeks, no camp (S428, CODE shows)
- Club shows run every other Saturday (CODE), so a YES offers two buttons:
  - **Ask: <next show>**, which is 7–14 days out;
  - **Ask: <the one after>**, which is 21–28 days out.
- No camp. A booked bout makes its week TAPER (CODE `WeekPhase`), and that's the fight week.
- The v3 rule of "at least 2 weeks out" (`CAMP_WEEKS`) is cut for amateurs.

### R6 The mandatory and the eliminator: rules on the top, not a path for yours (NEW, P)
**Both are set on the first Monday of each quarter.**

**MANDATORY:** the ranked 2nd is mandatory for the ranked 1st.
- The ranked 1st must box them within 8 weeks. This overrides TOO RISKY FOR THEM and DUCKED.
- If the ranked 1st hasn't taken it by week 8, they pay 6 reputation to the mandatory (zero-sum).
- It arrives as an offer with a flag on the top bar. It's never booked by itself.

**ELIMINATOR:** the ranked 3rd and 4th each get an offer against the other.
- The winner becomes next quarter's mandatory, ahead of the ranked 2nd, and takes +2 from outside the ladder (logged).
- If either side passes, the ranked 5th takes the slot. Passing costs nothing but the slot.

Your boxer meets these rules only by standing in those places. Rivals meet them too, so the top of the table moves without you.

### R7 The clock: activity, not a schedule (v3 kept, P)
**A week is free when all of these are true:**
- no bout booked;
- not resting, injured or suspended;
- not in a nationals run;
- not on chosen rest;
- **and** at least one row inside your reach says YES.

**The rules:**
- **The fall:** after 8 free weeks in a row, −1 every 2 free weeks.
- **What resets the count:** a booking resets it, except a bout against someone 20+ below (R2).
- **Rest until <date>:** up to 4 weeks, once a season. The clock is paused, and no asks or offers come.
- **Rivals** use the same clock. A rival with no bout for 52 weeks leaves.

### R8 Others ask your boxer too (CODE offers, NEW sender, P)
- The club-show offers that arrive today (CODE, one open offer per boxer, answered by a date) become **asks from other gyms**.
- A rival's manager picks your boxer by the same rules: your boxer must be inside their reach, and no refusal word may apply from your side.
- A rival above you asks down only when it has been free 6+ weeks, which means it's running from the clock. Those offers pay you more.

**Three answers:**

| Answer | Cost |
|---|---|
| **Accept** | Takes that show date. Any ask of yours pending for it is cancelled, and the row names it |
| **Not this show** | −1 reputation (closes John's hole). The challenger moves to the next show after. Use it once per challenger; a second time counts as Pass |
| **Pass** | −2 reputation. That challenger sends none for 8 weeks |

### R9 Everything else from v3 that still holds
- Seeding: rivals start at the larger of 0 and (8 + 4 × net wins + bouts), capped at 65. Walk-ins start at 0.
- The 55+ drain to pro, shown as "Pro talk: n weeks".
- One new entry per quarter.
- The pro offer at 55 (`ProGate`). If the boxer stays amateur, the offer returns at 65 or after a regional stage win, whichever comes first.
- Rematch: twice a season.
- One-offs from outside the ladder: regional stage +5, national title +10, hosted-show headline +3.
- **Season:** 1 Jan to 31 Dec. The final table goes to Records, the cap and rematch counts reset, and reputation carries over.
- **Every fight shows the rank earned (S428):** "+11 reputation, now ranked 5th".

Part 2 of 4

## 2. The pick screen

### 2.1 Where
It sits on **Fights, under the offers**, where the agreed map puts Ask for a fight (pack 6). It opens only when clicked. World > Rankings shows the same table, read-only apart from opening the card.

### 2.2 One row per boxer in your boxer's sex, class and region
Every value below is one the game can compute.

| Column | Example | Computed from |
|---|---|---|
| Rank and last week's move | 5 ▲1 | `Ladder` sort (CODE results) |
| Portrait, club | — | `Region.gd` |
| Record | 9-3 | CODE |
| Stance, style word | Southpaw · Counter-puncher | CODE |
| **Your plan against them** | Beats it / Works / Walks into it / No plan | Playbook Rate against for that style (CODE) |
| **Chance** | 40–70 | CODE win band; narrows with tape |
| **Win / Loss** | +11 → 5th / −5 → 8th | R3 on the two reputations, then the `Ladder` re-sort |
| **Answer** | YES, or the word from R4 | `AskAnswer`, deterministic |
| **Next show** | 28 Mar | Fixtures (CODE) and the opponent's bookings |
| Chips | Weight at risk · WON'T STOP THE CLOCK · Pro talk 3 wk · MANDATORY · ELIMINATOR · OWED | R2, R4, R6, R9 |

**Lines across the table:**
- a dotted line under the last row inside your reach, labelled "Your reach: up to 16 above";
- a dotted line above the boxers with under 4 wins, labelled "Not ranked yet: 4 wins".

**Display rules:**
- Your boxer's row is slate.
- **Show:** All / Same stance / Same style. Every column sorts.
- **Gold:** only the selected row's first Ask button. Green: none on this screen.

### 2.3 The card (opens when a row is clicked)
- **Header:** the opponent's portrait and name, the only place the name appears (S448).
- **WIN / LOSS:** all four results with values and the rank after each. Hover gives the sum: "Expected 28% · unanimous · 16 × 0.72 = +11".
- **YOUR PLAN:** its rating against this style, kept apart from Chance.
- **WHAT WE KNOW:** stance, style and found habits (CODE rival file). Locked lines say "Tape study opens this".
- **ANSWER:** YES, or the word, its line and the way to a yes. On a refusal, the Ask buttons are dimmed.
- **Buttons:**
  - **Ask: 28 Mar** (gold);
  - **Ask: 11 Apr**;
  - **Pin as target**: one pin, shown on Overview's NEXT STEP;
  - **Ask for a rematch**, only after a loss to this boxer.

### 2.4 The strip above the table
- **CLOCK:** "Free 5 weeks: falls from week 8".
- **PRO OFFER:** "At 55: needs 24".
- **SEASON:** "Ends 4 Jan · bouts 7 of 18".
- **TOP:** "Mandatory for ranked 1st by 9 May · Eliminator: 3rd v 4th".
- **TARGET:** the pinned row.

**An open offer from another gym** sits as a row above the table, with Accept, Not this show (−1) and Pass (−2). Its line reads "Accepting cancels your ask for 28 Mar" when that's true.

## 3. Why the pick is a real choice: three gyms, three different best picks

**How the cases are worked:**
- **EV** means the average reputation from one bout: real chance × win − (1 − real chance) × loss.
- The win and loss values are R3's rounded figures (DERIVED).
- **Real chances are ESTIMATE**, built on the pack's measured anchors: a good plan wins about 59% against 45% for no plan, and +5 stats wins about 72%.
- The three bots:
  - **THINK** weighs plan, chance, pay and the rules;
  - **ASKUP** always asks the highest boxer it may;
  - **EASIEST** always asks the lowest.

### Case 1: a settled gym; a boxer at reputation 30, plan written, tape on file
Women's 60 kg. Reach: up to 46.

| Row | Rep | Gap | Your plan | Real chance | Win / Loss | EV |
|---|---|---|---|---|---|---|
| Ranked 3rd, Out-boxer | 44 | +14 | Walks into it | 20% | +13 / −3 | **+0.2** (ASKUP) |
| Ranked 4th, Counter-puncher | 40 | +10 | Beats it | 50% | +11 / −5 | **+3.0** (THINK) |
| Ranked 12th, novice | 4 | −26 | Works | 97% | +1 / −15 | **+0.5** (EASIEST), and it doesn't stop the clock |

THINK asks the 4th: a lower boxer than the 3rd, chosen because the plan beats that style.

### Case 2: a new gym; a novice at reputation 8, 3 bouts, sessional coach
Women's 57 kg. Reach: up to 19. Every open boxer reads NOT SAFE.

| Row | Rep | Gap | Your plan | Real chance | Win / Loss | EV |
|---|---|---|---|---|---|---|
| 6 bouts, Pressure fighter, +3 stats on yours | 15 | +7 | Works | 37% | +10 / −6 | **−0.1** (ASKUP) |
| 4 bouts, Slugger | 9 | +1 | Beats it | 62% | +8 / −8 | **+1.9** (THINK) |
| 2 bouts, Counter-puncher | 4 | −4 | Walks into it | 55% | +7 / −9 | **−0.2** (EASIEST) |

Here the best pick is the even bout. The lowest row is a trap, because the style beats your plan.

### Case 3: a strong gym; a boxer at reputation 50, ranked 2nd, 14 bouts
Men's 70 kg. Reach: up to 70.

| Row | Rep | Gap | Answer | Real chance | Win / Loss | EV |
|---|---|---|---|---|---|---|
| Ranked 1st, Out-boxer | 54 | +4 | **TOO RISKY FOR THEM** (within 3 of 55; your expected 41%) | — | +9 / −7 | **0**: the week is lost (ASKUP) |
| Ranked 5th, Pressure fighter | 40 | −10 | YES | 80% | +5 / −11 | **+1.8** (THINK) |
| Ranked 12th | 6 | −44 | YES | 99% | 0 / −16 | **−0.2**, and the clock runs (EASIEST) |

THINK takes the 5th now, because R6 makes your boxer the ranked 1st's mandatory on the next quarter Monday. The ranked 1st then has to box them within 8 weeks. That bout is worth about +1.0 at 50% (ESTIMATE), or 6 paid over if it's ducked, which takes the boxer past 55 either way.

### Over the three cases (per bout, DERIVED from the ESTIMATE chances)
| Bot | Case 1 | Case 2 | Case 3 |
|---|---|---|---|
| THINK | +3.0 | +1.9 | +1.8, then the mandatory |
| ASKUP | +0.2 | −0.1 | 0 (refused) |
| EASIEST | +0.5, clock running | −0.2 | −0.2, clock running |

**Why both fixed habits lose:**
- **ASKUP** walks into bad styles and protected boxers, and it takes more stoppage losses (probe 4).
- **EASIEST** earns about nothing per win, pays 15 or 16 for a loss, and the fall eats it once the clock keeps running.

Three gyms give three different best rows: the 4th, an even novice, and a mid-table bout while a rule forces the top one.

Part 3 of 4

## 4. Every menu it appears on (S425)
| Menu | What it shows | Wired to |
|---|---|---|
| Fights, under the offers | Strip, table, card, open offer row (2) | `Ladder`, `RepRules`, `AskAnswer`, `Challenge`, `TopRules` (mandatory and eliminator) |
| World > Rankings | The same table, read-only; a row opens the card | `Ladder` (replaces the results-only ranking, CHECK 6) |
| Rival file (World) | Win / Loss, answer and Ask on the file | `RepRules`, `AskAnswer` |
| Fighter Overview | Reputation and band word, the pinned target in NEXT STEP, the clock line, Rest until | `RepLedger`, `Ladder.pin`, `Clock` |
| Home notice board | A note for an open offer, a mandatory or eliminator, or an OWED bout coming due | `Challenge`, `TopRules` |
| Top bar | Flags: OFFER, MANDATORY, ELIMINATOR (each opens its row) | `TopRules`, `Challenge` |
| Bout page (the versus screen) | Win / Loss with the rank after each, chance, weight chip | `RepRules`, weight forecast (CODE) |
| Fight result | "+11 reputation, now ranked 5th", with hover "Beat 28% expected · unanimous · gap +10" | `RepLedger`, `Ladder` |
| Week review | Changes, top-ups, ducks, OWED, drain, new entry, season end | `RepLedger`, `Ladder`, `Season` |
| Pro offer modal | Turn pro / Stay amateur and its two returns | `ProGate` |
| Records | Final season table, band milestones | `Season` |

## 5. What changes from v3, and what's cut
| v3 | v4 |
|---|---|
| **Coach's star** on one row | **Cut.** The player picks. The plan column and the chance band carry what the coach knows |
| `CoachRead` with an error by coach rating | **Cut** with the star. The CODE band and tape do that job |
| Challenges only from lower boxers | **Widened (R8):** any rival may ask, and those above ask only when the clock is running on them |
| Not this show free | **−1**, once per challenger (John's hole) |
| Earliest date 2 weeks out (`CAMP_WEEKS`) | **Next show 7–14 days, or the one after (R5).** No camp for amateurs |
| Any booking resets the clock | **Not a bout 20+ below (R2)** (John's hole) |
| A no only for reach, safety and date | **Added: TOO RISKY FOR THEM, DUCKED, OWED (R4)** |
| No mandatory or eliminator | **Added (R6),** as rules on the top places |
| Ladder tab option | **Cut.** It sits on Fights only |
| Kept | Zero-sum formula, weights, floor log, reach line, clock and rest, seeding, drain, entry, season, rematch, NOT SAFE, CLUBMATE, weight chip, pro gate 55, stay-amateur returns, one table, rank on every result |

## 6. Probes (Claude builds and runs; numbers freeze only on a pass)
**The bots:** THINK (best EV by plan rating and band middle), ASKUP, EASIEST, SAFE (highest band), WAIT (offers only), RANDOM (any YES row). Each runs over 200 seeds of 2 seasons.

| # | Pass line (P) |
|---|---|
| 1 | THINK reaches 55 at least 25% faster than ASKUP, EASIEST and SAFE |
| 2 | Each of 3 rows (above you, even, below you) is THINK's pick in 20%+ of its asks, so no single rung is the answer |
| 3 | ASKUP takes 1.5× or more THINK's stoppage losses |
| 4 | EASIEST averages under +0.5 a bout above reputation 30 |
| 5 | WAIT is out of the top 3 within 16 weeks in 60%+ of seeds |
| 6 | 70%+ of refusals turn into a yes within 8 weeks. TOO RISKY FOR THEM and DUCKED are each under 25% of all asks |
| 7 | Ranked 1st meets the mandatory within 8 weeks in 80%+ of quarters |
| 8 | The ladder total moves within ±5% a season, not counting entry, drain and one-offs. Top-ups stay under 3% |
| 9 | Accept, Not this show and Pass are each the better answer in 15%+ of offers |
| 10 | +5 stats reaches 55 at least 25% faster than par |
| 11 | THINK's time to 55 is within ±25% of the code's current pro-offer pace |
| 12 | Hover sums equal the shown values in every case |

**Build order:**
1. `RepRules`, `RepLedger`, `Clock` (line 12).
2. `Ladder`, `Season`, `TopRules` (lines 7–8).
3. `AskAnswer`, `Challenge` (lines 6, 9).
4. Bots (lines 1–5, 10–11).
5. `ProGate`.
6. World > Rankings reads `Ladder`.
7. The page, from an agreed mockup only.

Part 4 of 4

## 7. Open questions for the owner (taste and scope)
1. **Mandatory and eliminator at amateur level:** keep them, or keep them for pro tables only? Real amateur boxing has no mandatories, but they make the top of the table move.
2. **Ducking:** should the other side ever say no for tactics (TOO RISKY FOR THEM, DUCKED), or only for reach, safety and dates?
3. **Names in rows:** World > Rankings shows names today. Should rows carry them, or only portrait, club and record, with the name in the card header (S448)?
4. **The number:** show the reputation number on rows, or the band word only?
5. **A coach's hint:** no star at all, as written here, or a coach's note on hover with no row marked?
6. **Amateur draws:** keep them (the code has them), or should every amateur bout have a winner?

**CHECKs for Claude:**
1. Ladder size per class (`Region.gd`).
2. Does the CODE chance include the plan?
3. The novice and open bout counts for NOT SAFE.
4. Can a club-show offer come from a named rival's manager (`AmateurBooking`)?
5. Does a booked show date ever fall under 7 days?
6. What else reads the 4-win ranking (nationals entry, the old pro gate) before World > Rankings switches over?

## 8. Self-score (fresh critics decide)
- **Depth 7:** the pick depends on plan, style, chance, gap, date, weight and the other side's rules. The three cases give three different best rows.
- **General design 7:** no script; every no is a word with a way to a yes; one table; the S425 table is complete.
- **Play 6:** until the probes run and the page is drawn.

## To reach 10/10
1. Run the build order and publish all 12 lines with numbers. If line 2 fails, retune the reach line and R3's 25-point scale before anything else.
2. Get owner answers 1–6, especially 1 (the mandatory) and 2 (ducking), because they decide whether R4 and R6 stay.
3. Close CHECKs 1–6, with CHECK 6 before World > Rankings changes.
4. Draw the pick screen at 1920×1080 in the stress state, then send the drawing to a critic:
   - your boxer ranked 6th;
   - an open offer that would cancel an ask;
   - one TOO RISKY FOR THEM row;
   - one NOT SAFE row;
   - one Weight at risk chip;
   - the MANDATORY tag on ranked 1st;
   - gold on the selected Ask only.
5. If line 9 fails, cut Not this show. If line 6 shows ducking over 25%, cut DUCKED and OWED.

## The 10/10 page (1920×1080)
- **Top bar:** dark (CODE), with the OFFER flag.
- **Header:** the gym name and the boxer's portrait, class and reputation, with the name once.
- **Strip:** CLOCK, PRO OFFER, SEASON, TOP, TARGET.
- **Open offer row:** under the strip.
- **The table:** 12 rows with the reach and ranked lines, chips, and your row in slate.
- **Right panel:** the card for the selected row, with WIN / LOSS, YOUR PLAN, WHAT WE KNOW and ANSWER, and two Ask buttons. Only the first is gold.
- **Fonts:** Bebas Neue for headings, IBM Plex Mono for numbers, nothing under 12.
- **Hover:** every number opens its sum.


# JOHN'S v4 CRITIQUE (full, with his 10/10)

# DESIGN_LADDER1_V4_CRITIC_JOHN_JOHN - John answer (seat queue SQ189)

Brief: research/DESIGN_LADDER1_V4_CRITIC_JOHN.md
Sent: 2026-11-15 21:10 | collected: 2026-11-15 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score LADDER1 v4 as a fresh critic, starting by rechecking the reputation formula, the three worked cases and the refusal rules against the pack. The owner's computer is still offline, so `CRITIC_ACCESS.md` and the mockups aren't open to me.

**Logic check.** I recomputed the map's numbers from its own formulas.

**These hold:**
- **The R3 table** checks out at every gap: −40 is 0 / −16, −20 is +2 / −14, −10 is +5 / −11, 0 is ±8, +10 is +11 / −5, and +20 is +14 / −2.
- **All nine case rows** match their win, loss and EV figures, for example gap +14 at 21.6% expected gives +13 / −3, and gap −26 at 91.6% gives +1 / −15.
- **Case 3's TOO RISKY row is correct:** gap +4 gives an expected of 40.9%, and 54 is within 3 of 55.

**What doesn't hold:**
1. **Two different things are both called reputation.** In the pack, reputation is the gym's number: a win adds +5 and a loss takes 2, and it drives the member target. The map uses the same word for each boxer's 0–100 ladder number. That breaks the one-word-per-concept rule, and every line of section 4 becomes unclear about which number moves.
2. **Places or points?** R2 says "16 above", and the dotted line repeats it. A table sorted by position reads that as 16 places. The cases use points ("rep 30, reach up to 46"). DUCKED ("up to 8 above") and the "20+ below" clock rule have the same problem.
3. **Case 3 doesn't play out as written.** At 50, a unanimous win over the 5th is +5, which is already 55 and the pro offer. The mandatory argument is moot. Also, a boxer ranked 2nd is already the mandatory under R6 if they held 2nd on the quarter Monday, and the eliminator winner can jump ahead of them. The case uses neither rule.
4. **The EVs count only ladder points.** In the code, every win adds +8 members, a $450 ticket cut and +8 morale, whoever the opponent is. A loss takes 1 member and 12 morale. So EASIEST at 97% is the best route for money and members, which isn't "earns about nothing". Also, every booked bout makes its week TAPER (light, three rest days, no sparring). Asking every 1–2 weeks halves training, and training is the stronger lever (5 stat points is about 72%). None of this is on the card or in the cases.
5. **Some chance estimates are larger than the measured anchors.** Case 1's "Beats it" lifts 28% expected to 50%, a +22 swing. The pack measured +14 for a good plan over no plan (59 against 45). Unless the stats differ too, the cases overstate how much the plan matters.
6. **The rematch rule contradicts itself.** R4 says TWICE THIS SEASON blocks a third bout. R9 says "rematch: twice a season", which allows three.
7. **The reach line contradicts itself at the bottom.** R2 says asking down has no limit, but CHECK 3's NOT SAFE rule blocks many low rows. Case 1's "ranked 12th, novice" reads NOT SAFE if your boxer is open, and the case doesn't give your boxer's bout count.
8. **Passing now costs reputation, but nothing says so.** Today Pass is free (pack 4.5). The map makes it −2, and Not this show −1, with no exception for an injured, resting or overweight boxer. It also doesn't say where those points go, which breaks the zero-sum claim.
9. **The TOO HEAVY line is looser than the code's weight forecast.** It refuses only above 1 kg a week. A 500 kcal a day cut is slower than that: the pack's 1.4 kg needs about 3 weeks. So rows between the two show YES and then miss weight, which costs $300.
10. **Classes and caps don't match the pack.**
    - The **18-bout season cap**, tagged CODE, isn't in the pack: NOT FOUND.
    - **Women's 70 kg** isn't in the pack's classes, which are 57/60/65/75 (CHECK Q-S294-233).
11. **The page breaks Look B.** Bebas Neue, IBM Plex Mono, slate rows and green aren't Look B, which uses Permanent Marker and Kalam on cream paper, with colour meaning risk only.

I score LADDER1 v4 at depth 6, general design 6 and play 7, so it doesn't reach the owner's 7 and 7 bar yet. The core is right: the player picks, every no has a reason and a way to a yes, and there's no script. But the pick is priced in only one currency, and the card shows that price. That turns choosing an opponent into "take the highest number on the screen", while the costs that would make it a real trade (training weeks lost, money, morale, layoffs) aren't shown. As in the last round, I recomputed the numbers by hand from the pack and the map, because the owner's computer is offline.

## Scores

**Depth 6.**
- **What earns it:**
  - Plan rating against style genuinely changes the best row; all three cases pick a different row.
  - The other side's rules (TOO RISKY, DUCKED, OWED) cost real calendar time.
  - The clock punishes waiting.
  - The open offer cancelling your ask is a nice collision.
- **What stops it at 7:**
  - Every case is solved by one procedure: the highest of chance × win − (1 − chance) × loss. The screen shows the chance, the win and the loss, so once tape narrows the band the pick is arithmetic.
  - The game already has the counter-pressures that would make it a judgment call, and the map ignores all of them:
    - each bout's TAPER week costs training, and training beats planning (5 points ≈ 72%);
    - easy wins pay the same $450 and +8 members as hard ones;
    - a stoppage loss means 30 days out plus 8 weeks before the next offer;
    - morale moves +8 / −12.

**General design 6.**
- **What's good:**
  - Refusals are deterministic and shown before you ask.
  - The formula is simple and its hover sum is honest.
  - The menu table is complete.
  - The build order is sensible.
  - Cutting the coach's star was right.
- **What costs points:**
  - two meanings of reputation;
  - places against points;
  - the rematch contradiction;
  - a free Pass silently becoming −2 with no injury exception and no zero-sum destination;
  - TOO HEAVY looser than the weight forecast;
  - an unsourced 18-bout cap;
  - the women's 70 kg class;
  - Case 3's arithmetic;
  - fonts and colours that aren't Look B.

**Play 7.** Choosing who your boxer fights is the core fantasy of a fight manager, and this delivers it. You get a target to pin, a mandatory flag on the top bar, a ducker who now owes you, a table that moves without you, and "+11, now ranked 5th" after every result. It's held back by a 12–30 row table to read every fortnight, and by a reward that's only points while the money and training effects stay hidden.

**Real boxing.** Mandatory challengers and eliminators are pro sanctioning-body rules (CHECK the WBC and IBF rules). Amateur bouts are made by club coaches and show matchmakers agreeing a match. So "ask, and their coach says yes or no with a reason" is true to amateur boxing, and a quarterly mandatory isn't.

## What each option changes
| Option | What it changes | Verdict |
|---|---|---|
| Ask: next show / the one after | Bout in 7–14 or 21–28 days; that week turns TAPER | Keep; **show the training cost** |
| Reach line | Caps how far up you can ask | Keep; **one unit (points)** |
| Answer words (R4) | Deterministic no with a way to yes | Keep all except as below |
| TOO HEAVY at 1 kg a week | Refuses impossible cuts | **Wrong threshold**; use the code's weight forecast |
| DUCKED + OWED | Prices ducking, rewards a hot boxer | Keep; it's the best new rule |
| Mandatory / eliminator for amateurs | Moves the top of the table | **Not real for amateurs**; keep for pro tables |
| Not this show (−1) / Pass (−2) | Price for refusing an ask | Keep; **say who gets the points**; free when injured, resting or TOO HEAVY |
| Rest until (4 weeks, once a season) | Pauses the clock | Keep |
| Pin as target | One row shown in NEXT STEP | Keep, low value |
| Show: same stance / same style | Filters the table | Keep |
| Ask for a rematch | After a loss | Keep; **fix the twice-a-season count** |
| **Missing:** training weeks lost, money and members per row, stoppage risk and layoff, morale | The other side of every pick | **Add**: these are what make it a decision |

## To reach 10/10
1. **Price every pick in everything it costs, on the card and in the probes.** Add a row to the card: "Training: 1 TAPER week (−0.6 stat points)", "Money: +$450, members +8 on a win / −1 on a loss", "Stoppage risk 6% → out 12 weeks", "Morale +8 / −12". Then make the gym's member gain from a win scale with the gap (for example +8 × win points ÷ 8, at least +2), so easy wins don't farm the gym. Re-run the three cases on the full value; if the best row is the same with and without these lines, depth hasn't improved.
2. **Give the two numbers two names.** Keep "reputation" for the gym (the code's meaning). Call the boxer's 0–100 number something else, for example "standing", and use it everywhere: R2–R9, the strip, the result line and the week review.
3. **Use one unit.** Reach, DUCKED, the "20+ below" clock rule and every chip use points, and the dotted line reads "Your reach: up to 46".
4. **Redo Case 3.** The boxer at 50 crosses 55 by beating the 5th. Rebuild it from 44 or 45, and walk through the mandatory and eliminator timing.
5. **Mandatory and eliminator for pro tables only.** At amateur level, the top moves through the regional stage and the nationals seeding the code already has. That answers the map's owner question 1, pending the owner.
6. **Set the Pass rules.** Not this show −1 and Pass −2 go to the challenger (zero-sum). Both are free when your boxer is injured, resting, TOO HEAVY or already booked. State that this changes today's free Pass.
7. **Replace TOO HEAVY's 1 kg a week with the code's weight forecast for that date.** If the forecast says a miss, show TOO HEAVY with "Start a cut: makes it by 11 Apr".
8. **Write one rematch rule:** at most 2 bouts against one opponent per season.
9. **Source the 18-bout cap or mark it (P).** Add England Boxing's rest days between bouts as the bout-frequency floor (CHECK).
10. **Follow Look B:**
    - Permanent Marker for headings and Kalam for notes, on cream paper;
    - one pulsing button (the selected Ask);
    - colour only for risk, so no slate or green.
11. **Follow S448 on rows.** Rows show portrait, club and record, and the name appears once in the card header. That answers owner question 3, pending the owner.
12. **Add three probes:**
    - **13:** a FARM bot that books the easiest YES every show must not beat THINK in money plus standing over 2 seasons.
    - **14:** THINK's training weeks lost to TAPER per season are reported.
    - **15:** the boxer's stats at 55 are within ±5 of today's pro-offer stats.
13. Close the women's 70 kg CHECK.
14. Re-probe, then send it to two fresh critics.

## The 10/10 page (1920×1080, Look B: Fights > "Who do we fight?")
**Shell (0–64):** dark top bar, with an OFFER flag and CONTINUE.

**Header (64–150):** the boxer's comic portrait, name once, class, record and "Standing 38 · 8th".

**Strip (150–220)** as five sticky notes:
- "Clock: free 5 wk, falls from wk 8";
- "Pro offer at 55: needs 17";
- "Season: 7 bouts, ends 4 Jan";
- "Pinned: the southpaw, 4th";
- "Training: 3 TAPER weeks this season".

**Open offer (220–290):** a red-edged note with Accept / Not this show (−1 to them) / Pass (−2 to them), and "Accepting cancels your ask for 28 Mar".

**Left whiteboard (40–1180): the table,** 14 rows on cream paper.
- Each row: rank and arrow, portrait, club, record, stance and style, the plan magnet (Beats it / Works / Walks into it), chance band, win and loss with the place after, the answer word, the next show and a risk chip.
- Marker lines: "your reach: up to 46" and "not ranked yet: 4 wins".
- Stress state:
  - your boxer 8th;
  - a TOO RISKY row near 55;
  - a NOT SAFE novice;
  - a Weight at risk chip;
  - an OWED tag on a ducker;
  - a WON'T STOP THE CLOCK row.

**Right panel (1220–1880): the card,** with the opponent's name in its header only. Four blocks:
- **IF WE WIN / IF WE LOSE:** standing, place, members, money and morale.
- **WHAT IT COSTS:** TAPER week, stoppage risk and layoff.
- **YOUR PLAN AGAINST THIS STYLE.**
- **WHAT WE KNOW**, with locked tells.

The answer line sits under them, then Ask: 28 Mar (the only pulsing button) and Ask: 11 Apr. Every number opens its sum on hover.

**Sources:** every game number above is DERIVED from the pack and the map. The amateur-matchmaking and pro-mandatory points are CHECK, from memory, and no web sources were used this round.


# DOLA'S v4 SCORES AND 10/10 LIST

Fonts: Bebas Neue for headings, IBM Plex Mono for numbers, nothing under 12.
Hover: every number opens its sum.
Show More
LADDER1_V4 — Score & Full Critique
Mechanic: Player-driven opponent selection + reputation ladder rules | Source: Critic Pack + DESIGN_LADDER1_V4_REVISE_KALLI_KALLI | Standard: two critics ≥7 on both DEPTH and GENERAL DESIGN
📊 SCORES (each /10)
Table
#	Criterion	Score	Reasoning
1	DEPTH	8/10	Real trade-offs across plan/style, gap/value, date, risk, clock, and opponent availability; no universally dominant pick; interacts strongly with reputation, weight, plan, rest rules, and pro gate. Three distinct optimal choices across three cases proves meaningful depth. Only missing: deeper rival personality hooks and fewer opaque refusal reasons.
2	GENERAL DESIGN	8/10	Consistent with existing game systems; every rule has a visible reason; deterministic yes/no (no random refusals); cleanly wired to existing screens; cuts legacy cruft (coach star, scripted sequence). Only: some formulas unproven, UI placement needs polish, a few edge cases untested.
3	PLAY	7/10	Strong comeback incentive via clock/fall and OWED mechanic; tangible rewards (rank, reputation, mandatory shots); clear short/medium/long-term goals. Anticipation works well. Held back by: no in-game tutorial for new players; no visual/ceremonial payoff for big wins yet.
Bar status ✅ — meets the owner's bar: DEPTH ≥7 and GENERAL DESIGN ≥7.
📋 What Each Option Changes — Missing & Useless Options
What each pick does
Table
Pick type	What changes
✅ Higher, within reach	Higher reputation gain if you win; higher loss if you lose; better ranking position; may trigger TOO RISKY FOR THEM or DUCKED; may become mandatory later
✅ Even-matched	Most reliable expected value; balanced risk/reward; plan/style knowledge matters most — highest EV in the design
✅ Far below	Near-zero reputation gain; doesn't reset the activity clock; high reputation cost if you somehow lose; almost never optimal
✅ Ask now (7–14d)	Sooner fight; less time to cut weight/study tape; may be refused if opponent is booked/resting
✅ Ask later (21–28d)	More prep time; higher weight-cut success; opponent may become available; delays your next move
✅ Pin as target	Visible goal on Fighter Overview; no mechanical bonus — purely player organisation
✅ Accept incoming offer	Secures that date; cancels your pending ask; minor reputation cost if you bail later
✅ Not this show	−1 reputation; keeps the door open for the next date
✅ Pass	−2 reputation; no contact for 8 weeks
⚠️ Missing options
Filter by plan match — "Beats it / Works / Walks into it" should be a one-click table filter
Sort by expected value — EV is calculated internally but not shown or sortable; players shouldn't do the math themselves
Quick scout — One-click tape-study from the table row without opening the full card
Sort by weight-cut need — Show only opponents you can make weight for comfortably
Amateur vs Pro toggle — Once a boxer is eligible for both paths, clearly separate the two
❌ Useless options / edge cases
Asking 20+ below — WON'T STOP THE CLOCK chip; negligible gain; huge penalty on upset loss; never a good choice except to fulfil a belt requirement
Re-asking immediately after DUCKED — They'll say no again; wastes your mental energy; OWED mechanic already handles the consequence
Asking when NOT SAFE — Explicitly blocked; players will try; needs clearer "opens after X more bouts" countdown instead of static text
🎯 To reach 10/10 — Changes, Most Important First
🔴 Priority 1 — Core clarity & feedback
Show Expected Value on each row — Add a column: EV = (win chance × win value) − (lose chance × loss value). Sorted descending by default. Players need one clear "smart pick" metric without doing math.
Explain every refusal clearly — Replace short words with full sentences: instead of TOO RISKY FOR THEM, show: "They're protecting their regional spot. Try again 4 weeks after their next bout." Include a countdown where possible.
Tutorial/intro overlay — First time opening the table: 3 inline callouts: ⓘ Your reach limit ⓘ What +8 reputation means ⓘ Why far-below bouts are bad. Non-intrusive, dismissible forever.
Visualise the reach line — Not just text: a horizontal dashed line across the table with a label showing exactly how far above you can reach; grows as your reputation increases.
🟡 Priority 2 — Polish & depth
Add 3 quick filters — Top of table: All / Good plan only / Safe weight only. One click each, no dropdown.
Dismiss/Defer incoming offers — When another gym approaches: add "Remind me in 2 weeks" option with −0 reputation (once per opponent per season). Only Accept/Not this show/Pass today is too rigid.
Proven number tuning — Complete all 12 probes. Specifically: if EASIEST bot survives >16 weeks in >40% of seeds, increase the fall rate from −1 every 2 free weeks to −1 every week after week 10 — the "easy grind" must not be viable.
Owner decisions on open questions:
Q1 — Recommendation: Mandatory/Eliminator = Pro only. Real amateur boxing has no mandatory challengers; keeps the amateur ladder fluid and less bureaucratic.
Q2 — Recommendation: Keep DUCKED/OWED. It rewards active boxers and punts overly cautious opponents — creates narrative rivalries.
Q3 — Decision needed: Names on rows vs headers only. Align strictly with S448: names only in headers. Rows = portrait + club + record only.
Q4 — Recommendation: Show reputation number in small faded text; band word prominently beside it. Both.
Q5 — Recommendation: No coach star, no coach hint. Your plan rating and chance band are your coach's advice. Let the player trust their own preparation.
Q6 — Recommendation: Keep draws (code has them). They're rare but realistic; change the draw reward from 16 × (0.5 − expected) to 8 × (0.5 − expected) so draws never feel like a "win for the underdog" that overperforms actual boxing reality.
🟢 Priority 3 — Finish & presentation
Open questions resolved — All 6 owner questions answered before visual polish.
1920×1080 screen implementation — Full layout spec below.
Test the stress state — Your boxer ranked 6th; open offer pending; one TOO RISKY; one NOT SAFE; weight-at-risk; MANDATORY flag visible; one gold button only. Nothing overflows; all text readable at 100% zoom.
Hover consistency — Every number shows its formula source on hover: "Gap +10: 28% chance → +11 reputation on win".
🖥️ The 10/10 Screen — 1920×1080 Layout
plaintext
┌──────────────────────────────────────────────────────────────────────┐
│  DARK TOP BAR  —  Gym name  │  Mon 23 Mar  │  $4,280  │  ⚑ OFFER MANDATORY  │
├──────────────────────────────────────────────────────────────────────┤
│  [BOXER PORTRAIT — NAME IN HEADER ONLY] · Women's 60kg · Rep 30/100    │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │  ⏱ Clock: Free 5 weeks — falls Week 8  │  🔒 Pro: 25 to go       │ │
│  │  📅 Season ends 4 Jan — 7/18 bouts    │  🎯 Target: Ranked 4th   │ │
│  │  👑 MANDATORY: Rank 1st must fight #2 by 9 May                    │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │  ⚠️ OFFER FROM ANOTHER GYM — [Opponent] · 8-1 · 12 Apr           │ │
│  │  Accept (+$450)  │  Not this show (−1 rep)  │  Pass (−2 rep)     │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  🔍 Filter: [All ▾]  [Good plan only]  [Safe weight only]            │
│  Sort: [Rank ▾]  Rep  Plan  Chance  EV  Win/Loss  Answer  Next bout   │
│  ├─────────────────────────────────────────────────────────────────┤
│  │ ┄┄┄┄ Your reach line: up to 46 (+16 above you) ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄ │
│  │ 1  ██  54  Out-boxer  Walks❌  20%  +9/−7  TOO RISKY  —           │
│  │ 4     40  Counter     Beats✅  50%  +11/−5 YES        28 Mar ✅   │ ← GOLD
│  │ 5     38  Pressure    Works🟡  55%  +10/−6 YES        11 Apr       │
│  │ ┄┄┄┄ Ranked line: 4+ wins required ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄ │
│  │ 12     4  Novice      Works🟡  97%  +1/−15 YES        28 Mar ⚠️   │
│  │        │                                    ⮡ WON'T STOP THE CLOCK │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  ┌──────────────────────────────┐  ┌───────────────────────────────┐ │
│  │   SELECTED OPPONENT — CARD    │  │  Win: +11 rep → Rank 3rd      │ │
│  │  Counter-puncher · 9-3        │  │  Loss: −5 rep → Rank 8th      │ │
│  │  Style: Counter-puncher       │  │  Expected: 28% · EV: +3.0     │ │
│  │  Stance: Southpaw             │  │                               │ │
│  │  Habit: Slow starter ⬜ Locked │  │  ✅ Ask: 28 Mar  [GOLD]      │ │
│  │  Weakness: Overcommits ⬜ Locked│ │  Ask: 11 Apr                  │ │
│  │                              │  │  📌 Pin as target              │ │
│  │  Tape study opens 2 tells     │  │  🔁 Ask for rematch (post-loss)│ │
│  └──────────────────────────────┘  └───────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘

Visual specs:
Background: warm tan plaster (WarmKit consistent style)
Your boxer's row: slate grey highlight
Good plan = green check ✅ / Works = yellow dash 🟡 / Bad plan = red cross ❌
Gold button only on the primary action for the selected row
Fonts: Bebas Neue headers / IBM Plex Sans UI / numbers monospaced
Hover: every number reveals its source formula in a small tooltip
Chips: ⚠️ Weight at risk · 👑 Mandatory · 🥊 Eliminator · ⏳ Owed
This mechanic is solid and ready to build — the core loop works, the three-case test proves meaningful choice, and the rule set is consistent with the rest of FightCamp. The changes above polish clarity and close the few remaining gaps — nothing fundamental needs rewriting.
Would you like me to turn this into a standalone HTML mockup of the 10/10 screen? Tap Fast then select Pro to get it.
Chat
Create Videos
Create Images
Writing
Homework
Translate

