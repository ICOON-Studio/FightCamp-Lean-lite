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
