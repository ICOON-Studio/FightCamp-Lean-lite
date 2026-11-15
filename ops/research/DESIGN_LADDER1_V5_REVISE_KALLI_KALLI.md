# DESIGN_LADDER1_V5_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ195)

Brief: research/DESIGN_LADDER1_V5_REVISE_KALLI.md
Sent: 2026-11-15 22:40 | collected: 2026-11-15 23:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm writing LADDER1 v5 as a full map. It's built around John's table screen and puts every cost of a pick on the card.

# LADDER1 v5: the player picks, and the card shows the whole price (S494, 2026-11-15)

Part 1 of 5. This is a full map that replaces v4. Nothing outside this page stands. The repo is still out of reach, so this is built from the pack, v4 and the two critiques, and the CHECKs are marked.

**Owner, verbatim:** "this is not bad that john made". John's ladder screen is now the screen the player uses, and its structure is kept: filters, columns, the "Why 60 in 100" hover, greyed rows with their reasons, the "Your boxer v the #3" card, one ASK FOR THIS BOUT button, the Rep bar and the season strip.

**Owner rules kept**
- **Q-250:** the player decides, and the rules apply. There's no script and no coach's star.
- **S475:** Rep is the currency, but it's no longer the only price on the card.
- **S428:** amateur bouts come within 1–2 weeks, no camp; every result shows the place earned.
- **S448:** a boxer's name is the header of that row and appears nowhere else, so no names in lines, tips or buttons.
- **S412:** no fixed he or she.
- **Pack 7:** nothing opens by itself.
- **S425:** the menu table is in Part 5.
- **Classes:** women 57/60/65/70/75 kg (70 kg by owner decision Q-S294-233, so the pack needs updating) and men 57.5/60/70/75 kg. One ladder per sex and class.

**Marks:** (P) is proposed, CODE is in the game per the pack, DERIVED is worked from formulas here, ESTIMATE is a hand figure the probes decide, and CHECK is for Claude.

**Kept from v4 (what Dola scored 8):**
- the zero-sum formula and its hover sums;
- the reach line;
- every refusal shown before you ask, with a way to a yes;
- DUCKED and OWED;
- the clock and Rest until;
- open offers that cancel your ask;
- three cases, three different best picks;
- the coach's star stays cut.

## 0. Words and units (John's logic points 1 and 2)
- **Rep** is the boxer's 0–100 ladder number. It's the word on the screen the owner liked, and the currency in S475.
- **Gym standing** is the gym's number. It's the code's gym reputation: +5 on a win, −2 on a loss, and it drives the member target and the sponsor tier (CODE). Only the label changes; the variable is untouched. This is owner question 2.
- **Every distance is in Rep points, never places:** the reach line, the clock's 20-below rule, the DUCKED window and every chip. The reach line reads "Your reach: up to 55".

## 1. The rules

### R1 The ladder is always open (CODE tables)
- One table per region, sex and class, sorted by Rep. It's the same table World > Rankings shows.
- **Ranked** means 4+ wins (CODE). Boxers under 4 wins sit below a line and can still be asked.

### R2 Reach, in points (P)
- **Up:** you may ask up to 10 + Rep ÷ 5 points above you, rounded down. At Rep 0 that's 10 above, at 38 it's 17 above (up to 55), and at 55 it's 21 above.
- **Down:** no limit. But a bout 20+ points below doesn't stop the clock (R8), pays almost nothing, and carries the chip **WON'T STOP THE CLOCK**.

### R3 What a bout pays in Rep (v4 kept; draw changed, P)
$$ \text{expected} = \frac{1}{1 + 10^{(\text{opp} - \text{you})/25}} $$

- **Winner:** gains 16 × (1 − expected) × weight, and the loser loses the same.
- **Weights:** stoppage 1.15 (plus 2 more each way), unanimous 1.0, majority 0.65, split 0.5.
- **Draw:** each side gets **8** × (0.5 − expected). That's Dola's change, so a draw never pays like an upset win.
- **Rounding:** rounded once, and both sides get the same whole number. Rep never goes below 0, and any shortfall is logged as "Ladder top-up".

| Gap (points) | Expected | Win | Loss |
|---|---|---|---|
| −20 | 86% | +2 | −14 |
| −10 | 72% | +5 | −11 |
| 0 | 50% | +8 | −8 |
| +10 | 28% | +11 | −5 |
| +20 | 14% | +14 | −2 |

### R4 Everything else a bout pays and costs: the card prices all of it (John's point 1, the main fix)
| Line on the card | Win | Loss | Source |
|---|---|---|---|
| **Rep and place** | R3, and the place after | R3, and the place after | DERIVED |
| **Members** | **+ the Rep won, at least 2 and at most 12** | −1 | Today a win is a flat +8 (CODE). Scaling it is (P), so easy wins no longer bring in members |
| **Gym standing** | +5 | −2 | CODE |
| **Money** | Ticket cut $450. Amateurs get no purse. Travel to an away show is −$40 | Travel only | The ticket cut is CODE per the pack (CHECK it pays on every win). Travel is (P); CHECK whether the code has it, and cut the line if not |
| **Morale** | +8 | −12 | CODE |
| **Training lost** | 1 fight week, win or lose | The same | A booked week turns TAPER: light, three rest days, no sparring (CODE). That's about −0.6 stat points (ESTIMATE, probe 14) |
| **Layoff risk** | — | "Stopped in n of 100: out 8 weeks". If a date already on the season strip falls in those 8 weeks, the line adds "would miss Regional stage 18 Apr" | The 8-week rest after a stoppage (CODE `STOP_REST_WEEKS`), with the 30-day suspension inside it (CHECK). n comes from the fight sim by matchup (probe 16) |
| **Clock** | "Resets the clock", or "Won't stop the clock" | The same | R8 |

There's deliberately no single total or EV column: the trade is a judgement about what the gym needs now.

Part 2 of 5

### R5 Hard rules: the row is greyed and says why and when (CODE and P)
In the default view, these rows fold into one line, "3 in reach can't be asked now ▸".

| Word | When | The row says |
|---|---|---|
| **OUT OF REACH** | Above your reach line (R2) | "Needs 6 more Rep: about one win above you" |
| **BOOKED** | They have a bout on both possible dates | "Free from 22 Mar" |
| **RESTING** | Either boxer is in the 8-week rest after a stoppage (CODE) | The date |
| **AT THE NATIONALS** | Either boxer is in a nationals run (CODE) | The date the run ends |
| **NOT SAFE** | A novice (0–10 bouts) against an open boxer (CODE; CHECK the counts) | A countdown: "Opens after 3 more bouts" (Dola) |
| **CLUBMATE** | Same gym | — |
| **TWICE THIS SEASON** | **At most 2 bouts against one opponent per season.** This is the only rematch rule; v4's contradiction is gone | "Opens 1 Jan" |
| **TOO HEAVY** | The code's **weight forecast** says your boxer misses the class on both dates. v4's 1 kg-a-week line is cut | "Start a cut: makes 60 kg by 11 Apr". The later date then opens |
| **CAP REACHED** | 18 bouts this season. **(P)**, because the cap isn't in the pack. CHECK England Boxing's rest days between bouts as the floor on how often a boxer can box | "Opens 1 Jan" |

Weight between "makes it" and a miss isn't a refusal. The row keeps YES and carries the CODE **Weight at risk** chip, "1.4 kg to go by Fri".

### R6 Will they say yes: a chance built from shown parts (the owner's screen, P)
Rows that pass R5 show **Will say yes: n in 100**. Hovering it gives the sum, with each part labelled in the opponent manager's terms:

| Part | Value |
|---|---|
| Start | 50 |
| **Their odds** | + (their expected − 50). A bout they're favoured in is attractive |
| **Protecting** (within 3 of 55, in Pro talk, or a regional stage inside 4 weeks) | −30, but only if their expected is under 60%. A protecting boxer still takes a bout they're favoured in |
| **Your heat** (your boxer has won the last 3 and gained 15+ Rep in 8 weeks), when they're 0–8 points above | −20 |
| **Their clock is running** (free 6+ weeks) | +3 for each free week over 6, up to +15 |
| **Home show for them / away for them** | +10 / −5 |
| **Last meeting** | they won: +10; you won: −10 |
| Limits | at least 5, at most 95 |

**How an ask is answered:**
- One ask is out per boxer at a time, and the answer comes the next morning. A no costs a day of the fortnight before the show.
- The answer is fixed for each pair and show date (seeded), so asking again for the same date gives the same answer, and save-and-reload changes nothing.
- **A no always names its biggest minus part as the reason,** for example "They're protecting a regional stage spot: −30". The **To raise the yes** tips are the parts you can still change, for example "Ask for 11 Apr: their stage is past, +30" or "Their clock runs from next week: +3 a week".

**DUCKED and OWED (v4's best rule, kept):**
- A no from a boxer 0–8 points above you, while your boxer has heat, is logged as **DUCKED**.
- Two DUCKED in 8 weeks make your boxer **OWED**. Your next ask to anyone who ducked starts at 95 in 100, and a no then pays 3 Rep to your boxer (zero-sum, logged).

**Conflict for the owner (question 1):** pack 4.5 says "never a random refusal". A seeded chance with a named reason is the screen you liked. The other choice is a fixed threshold, where 50+ means yes and the number shows how far their manager leans. Everything else in this map works with either.

### R7 The date: amateur bouts within 1–2 weeks, no camp (S428)
- Club shows run every other Saturday (CODE). The card offers **the next show** (7–14 days) or **the one after** (21–28 days), as a two-way choice above the one Ask button.
- No camp. The bout's week turns TAPER, and that's the **fight week**, priced on the card (R4).

### R8 The clock (v4 kept, in points)
- After 8 free weeks in a row, Rep falls 1 every 2 free weeks.
- A week is free when your boxer isn't booked, resting, injured, suspended, in a nationals run or on chosen rest, and at least one row in reach could say yes.
- A booking resets the clock, except a bout against someone 20+ points below.
- **Rest until <date>:** up to 4 weeks, once a season.
- Rivals use the same clock, and a rival with no bout for 52 weeks leaves.

### R9 Offers from other gyms (CODE offers, P costs)
**Who sends them:** rival managers ask your boxer by the same rules. A rival above you asks down only when its own clock is running.

**The three answers:**

| Answer | Cost |
|---|---|
| **Accept** | Takes that date. Any ask of yours for it is cancelled, and the offer says so |
| **Not this show** | **Free once per challenger a season** (Dola's "remind me later"). After that, −1 Rep to the challenger |
| **Pass** | −2 Rep **to the challenger** (zero-sum). That challenger sends nothing for 8 weeks |

- **Free whenever your boxer is injured, resting, TOO HEAVY or already booked.**
- **This changes today's free Pass (pack 4.5),** and the offer row states it once: "Passing costs 2 Rep".

### R10 The top of the table
- **Amateur tables have no mandatory and no eliminator.** Both critics said so, and it matches real amateur matchmaking. The top moves through the regional stage (+5 one-off) and the nationals seeding (CODE).
- **Mandatory and eliminator (v4's R6) apply only on pro tables.** They're seen through the **Pros** filter once a boxer turns pro.
- **Still holding from v4:**
  - seeding: the larger of 0 and (8 + 4 × net wins + bouts), capped at 65;
  - the 55+ drain, shown as "Pro talk: n weeks";
  - one new entry a quarter;
  - the pro offer at 55 (`ProGate`), which comes back at 65 or after a regional stage win;
  - one-offs: regional stage +5, national title +10, hosted-show headline +3;
  - the season runs 1 Jan to 31 Dec, and Rep carries over;
  - **every result shows the place earned:** "+11 Rep, now ranked 5th".

Part 3 of 5

## 2. The screen (John's, kept as the one the player uses)

### 2.1 Where
It's **Fights > Who do we fight?**, under the offers, and opens only when clicked. World > Rankings shows the same table read-only, and a row opens the same card.

### 2.2 Default view: the few rows that matter (John's point 2)
- **Filters, as chips:** **In reach** and **Legal now** are on by default. The others are Likely yes 50+, Ranked, Rivals and Pros, plus Dola's two, **Beats it** (plan) and **Makes weight**.
- **What In reach means:** from 20 points below (the clock line) up to your reach line. Rows further below are still reachable but pay nothing, so the chip hides them.
- **The count line:** "Showing 6 of 24 · Show all". Probe 18 targets 8 rows or fewer in 80% of opens.
- **Greyed rows** inside reach fold into one line, "3 in reach can't be asked now ▸". When opened, each shows its word and its when (R5).
- **Pros** appears only after the pro offer.
- **Rivals** shows the boxers who have a rival file (CODE).

### 2.3 Columns (the owner's set, with sources)
| Column | Example | From |
|---|---|---|
| **Row header** | the boxer's name, portrait and club, the only place the name appears (S448) | `Region.gd` |
| Rank and move | 4 ▲1 | `Ladder` |
| Record | 9-3 | CODE |
| Rep | 44 | `RepLedger` |
| Style | Counter-puncher · **Beats it** (your plan against that style) | CODE style; Playbook rating against it |
| Last | W RSC 2 · 3 wk ago | CODE results |
| Win chance | 40–55, narrowing with tape | CODE band |
| Will say yes | 60 | R6 |
| Win gives | +11 Rep → 3rd | R3, `Ladder` |
| Loss costs | −5 Rep · stopped 12/100 | R3, probe 16 |
| Chips | Weight at risk · WON'T STOP THE CLOCK · OWED · Pro talk 3 wk | R2, R5, R6, R10 |

**Display rules:**
- Your boxer's row is slate. Every column sorts, and the default sort is Rep.
- A dashed line runs across the table at the reach line, labelled "Your reach: up to 55". It moves as Rep grows (Dola).

**Three ⓘ marks sit in the header:** what reach is, what +8 Rep means, and why far-below bouts pay nothing. Each opens on click and can be dismissed for good. This is Dola's tutorial without anything opening by itself (pack 7).

**Answered with Dola's other wishes:**
- Quick scout: a **Study tape** link on the row (CODE tape study; CHECK its cost and time).
- Plain sentences for every refusal: done in R5 and R6.
- **The EV column is declined.** A single number to sort by puts the script back, and John's point 1 is exactly that.

### 2.4 The card: "Your boxer v the #3"
**Header:** both portraits with class and record, and the title "Your boxer v the #3". No names: the row header above already carries the opponent's name.

**Two boxes side by side:**
- **WILL SAY YES: 60 in 100.** Hover gives the parts (R6). Worked example: start 50, their odds +14, home show for them +10, your heat −20, their clock +6, giving 60.
- **WIN CHANCE: 40–55.** Hover reads "Rep gap +6 · your plan beats a counter-puncher · tape: 1 of 3 habits".

**IF WE WIN / IF WE LOSE** (every line from R4):

| | Win | Loss |
|---|---|---|
| Rep | +11 → 3rd | −5 → 9th |
| Members | +11 | −1 |
| Gym standing | +5 | −2 |
| Money | +$450 ticket cut, −$40 away | −$40 away |
| Morale | +8 | −12 |
| Layoff | — | Stopped in 12 of 100: out 8 weeks, would miss Regional stage 18 Apr |

**THE SHOW AND FIGHT WEEK:**
- The two dates, 28 Mar or 11 Apr, as a toggle. The show's venue and whether it's home or away.
- "Fight week: TAPER, training −0.6 stat points (ESTIMATE). No camp: amateur."
- The clock line.

**TO RAISE THE YES:** up to three tips, each one a part you can change, worded with no names. For example: "Ask for 11 Apr: their stage is past, +30" and "Win once more and your heat passes: +20".

**Buttons:**
- one big **ASK FOR THIS BOUT**, the only gold thing on the screen;
- small links under it: Pin as target, Study tape, and Ask for a rematch (only after a loss to this opponent, within TWICE THIS SEASON).

### 2.5 Above the table
**The Rep bar** (0–100), with your boxer's marker and three unlock marks:
- **Pro offer at 55** (CODE `ProGate`);
- **Sponsor (P 30):** CHECK whether a boxer-level sponsor exists. K88's sponsors key off gym standing. If there's no boxer-level sponsor, this mark is cut;
- **Squad camp (P 45):** CHECK that the code has squad selection, and cut the mark if not.

**The season strip:** every club show from now to 31 Dec, with your booked show, the regional stage, the nationals dates and the 18-bout count (P).

**Status notes:**
- "Clock: free 5 wk, falls from wk 8";
- "Fight weeks this season: 3";
- the pinned target.

**An open offer** from another gym sits above the table with Accept, Not this show and Pass (R9), and the line "Accepting cancels your ask for 28 Mar" when that's true.

Part 4 of 5

**A correction to 2.4's example:** at a Rep gap of +6, the lines read **+10 → 3rd / −6 → 9th, and members +10**. Their odds part, +14, is right.

## 3. Three gyms, three best rows, and the full price changes the pick
**How the cases are worked:**
- **Real chance** = R3's expected + a plan shift: Beats it +7, Works 0, Walks into it −7 (ESTIMATE). The 14-point span is the pack's measured gap between a good plan and no plan, 59 against 45, which answers John's logic point 5.
- **Averages per bout:** chance × win − (1 − chance) × loss, done for each line separately. They aren't added together.
- **Stoppage figures** are ESTIMATE until probe 16.

### Case A: a new gym that's short of money; a novice at Rep 20, 6 bouts (women's 57 kg; reach up to 34)
| Row | Rep, gap | Plan | Chance | Rep win / loss, average | Money, average | Members, average (v5) | Members, average (today's flat +8) | Morale, average |
|---|---|---|---|---|---|---|---|---|
| Pressure fighter | 27, +7 | Works | 34% | +10 / −6, **−0.6** | $153 | 2.7 | 2.1 | −5.2 |
| Slugger | 16, −4 | Beats it | 66% | +7 / −9, **+1.6** | $297 | **4.3** | 4.9 | +1.2 |
| Counter-puncher | 6, −14 | Walks into it | 71% | +3 / −13, **−1.6** | $320 | 1.8 | **5.4** | **+2.2** |

**Reading:**
- Under today's flat members, the lowest row wins on money, members and morale. That's John's farm.
- With members scaled to the Rep won, the even Slugger wins on Rep and members and gives up only $23.
- **Best row: the Slugger,** unless the gym needs that $23 this week.

### Case B: a settled gym; Rep 38, 12 bouts, regional stage in 5 weeks (women's 60 kg; reach up to 55)
| Row | Rep, gap | Plan | Chance | Rep, average | Money | Members | Morale | Stopped in |
|---|---|---|---|---|---|---|---|---|
| Slugger | 46, +8 | Beats it | 39% | +11 / −5, **+1.2** | $176 | 3.7 | −4.2 | 12 of 100 → misses the stage |
| Out-boxer | 40, +2 | Works | 45% | +9 / −7, +0.2 | $203 | 3.5 | −1.0 | 2 of 100 |
| Counter-puncher | 32, −6 | Beats it | 70% | +6 / −10, **+1.2** | $315 | 3.9 | +2.0 | 3 of 100 |

**Reading:**
- On Rep alone, v4's card, it's a tie, and the higher rank makes the Slugger look right.
- **The full card flips it:**
  - the Counter-puncher pays more in money, members and morale;
  - the Slugger carries a 12-in-100 chance of missing the regional stage, about 0.6 Rep of the +5 plus 8 idle weeks.
- **Best row: the Counter-puncher.**
- A gym racing for the pro offer can still take the Slugger, and the card shows the price.

### Case C (v4's Case 3 redone from 44): a strong gym; ranked 3rd at Rep 44, 16 bouts, 11 short of the pro offer (men's 70 kg; amateur, so no mandatory)
| Route | What it takes | Chance of 55 | Fight weeks | Money if it all goes right | Stopped in |
|---|---|---|---|---|---|
| **Ask the #1 now** (Rep 54, gap +10, Works) | One win: +11 → 55 | **28%** | 1 | $450 | 8 of 100 |
| **Two steps:** the #4 (41, gap −3, Beats it, 64%, +7 → 51), then the #2 (50, gap −1, Works, 52%, +8 → 59) | Two wins | **33%** | 2 (about −1.2 stat points) | $900 | 3, then 5 |

**The yes chances decide the timing:**
- **Today the #1 says yes at about 71:** start 50 + their odds +21. Their expected is 72%, so being 1 off 55 doesn't make them protect.
- **From 51, the gap is +3:** their expected drops to 57%, under 60, so protecting −30 applies and the yes falls to about 27.
- **So the shot at the #1 closes the moment you take the safer first step.**

**Reading:**
- The fast route is one bout and one fight week, at 28%.
- The slow route is slightly likelier, pays double and costs a fight week, and it gives up the #1 for now.
- Either can be right, and only the full card shows it.

### Over the three cases
| Bot | A | B | C |
|---|---|---|---|
| THINK (weighs the whole card by gym state) | the Slugger | the Counter-puncher | either, by goal |
| ASKUP | the Pressure fighter (−0.6 Rep, −5.2 morale) | the Slugger (stage at risk) | the #1 |
| EASIEST / FARM | the Counter-puncher: fewer members once scaled, −1.6 Rep | the Counter-puncher (right here, by accident) | a row 20+ below: the clock runs |

There are three different best rows, and in two of the three cases the best row is different with the full price than with Rep alone. That's John's test for depth.

Part 5 of 5

**A correction to Case B:** the Out-boxer's average morale is **−3.0**, not −1.0. The reading doesn't change.

## 4. Every menu the ladder appears on (S425)
| Menu | What it shows | Wired to |
|---|---|---|
| **Fights > Who do we fight?** | Rep bar, season strip, status notes, offer row, filtered table, card, ASK FOR THIS BOUT | `Ladder`, `RepRules`, `RepLedger`, `AskAnswer` (R5 + R6), `Challenge` (R9), `BoutPrice` (R4: members, money, morale, TAPER, layoff), weight forecast (CODE), fixtures (CODE) |
| **World > Rankings** | The same table, read-only; a row opens the card | `Ladder` (replaces the results-only ranking after CHECK 9) |
| **Rival file (World)** | Will say yes, win gives / loss costs, and Ask | `AskAnswer`, `BoutPrice` |
| **Fighter Overview** | Rep and its place, the pinned target in NEXT STEP, the clock line, Rest until | `RepLedger`, `Ladder.pin`, `Clock` |
| **Home notice board** | A note for an open offer, an answer that came in, or OWED coming due | `Challenge`, `AskAnswer` |
| **Top bar** | OFFER and ANSWER flags (each opens its row); Continue stays green | `Challenge`, `AskAnswer` |
| **Bout page (the versus screen)** | Win gives / loss costs, the chance band, the weight chip | `RepRules`, `BoutPrice`, weight forecast |
| **Fight result** | "+11 Rep, now ranked 5th · +11 members · $450"; hover "Beat 28% expected · unanimous" | `RepLedger`, `Ladder`, `BoutPrice` |
| **Week review** | Rep changes, top-ups, DUCKED and OWED, Pass payments, fight weeks this season, drain, new entry | `RepLedger`, `Ladder`, `Season` |
| **Gym / Money** | Ticket cuts, travel, member changes from bouts | `GameMoney`, members drift (CODE) |
| **Pro offer modal** | Turn pro / Stay amateur and its two returns; turning pro opens the Pros filter | `ProGate`, `TopRules` (pro tables only) |
| **Records** | The season's final table | `Season` |

## 5. Each of John's points and what was done
| # | John | v5 |
|---|---|---|
| To 10/10 1 | Price every pick in everything | R4, the card, Cases A–C. Members scale with the Rep won |
| 2 | Two meanings of reputation | Rep (boxer) and Gym standing (gym), section 0. Owner question 2 |
| 3 | One unit | Points everywhere (section 0) |
| 4 | Redo Case 3 | Case C, from 44 |
| 5 | Mandatory for pros only | R10 |
| 6 | Pass rules | R9: paid to the challenger, free when unable, and says it changes today |
| 7 | TOO HEAVY | The weight forecast (R5) |
| 8 | Rematch | At most 2 per pair per season (R5) |
| 9 | 18 cap | Marked (P), with the England Boxing rest days as a CHECK |
| 10 | Look B | Not done: the kit I hold is Bebas Neue / IBM Plex Mono. Owner question 5 |
| 11 | S448 on rows | Per the owner: the name is the row header, and appears nowhere in lines, tips or buttons |
| 12 | Probes 13–15 | Added below |
| 13 | Women's 70 kg | It's in, by Q-S294-233. The pack needs the update |
| 14 | Re-probe, then two critics | To reach 10/10 |
| Logic 5 | Plan swing too large | Capped at the measured ±7 |
| Logic 7 | Reach against NOT SAFE | Every case now gives your boxer's bout count, and NOT SAFE is a greyed row with a countdown |

## 6. Probes (Claude builds and runs them; the numbers freeze only on a pass)
**The bots:** THINK, ASKUP, EASIEST, FARM, SAFE, WAIT and RANDOM, over 200 seeds of 2 seasons. v4's lines 1–5 and 8–12 are kept, and lines 6 and 7 are replaced.

| # | Pass line (P) |
|---|---|
| 6 | 70%+ of hard-rule refusals become legal within 8 weeks. Under the seeded roll, shown yes chances land within ±5 of the real rate in each band of 10 |
| 7 | The amateur top moves without mandatories: ranked 1st changes hands 2+ times a season in 60%+ of seeds |
| 13 | **FARM** (the easiest yes every show) doesn't beat THINK on Rep, money or members over 2 seasons |
| 14 | THINK's fight weeks a season, and the stat points lost to TAPER, are reported |
| 15 | Stats at 55 are within ±5 of the stats when the code makes its pro offer today |
| 16 | A stoppage table by stat gap and style feeds "stopped in n of 100", with an error within ±3 |
| 17 | In 2 of 3 cases, the best row with the full price differs from the best on Rep alone |
| 18 | The default view shows 8 rows or fewer in 80% of opens |

If EASIEST still lasts past 16 weeks in more than 40% of seeds, the fall becomes −1 every week after week 10 (Dola).

## 7. Open questions for the owner
1. **Will they say yes:** a seeded chance, as on John's screen (this conflicts with pack 4.5, "never a random refusal"), or a fixed 50+ threshold?
2. **Words:** "Rep" for the boxer and "Gym standing" on screen for the gym's number?
3. **Mandatory and eliminator on pro tables only?** Both critics say yes.
4. **Pass at −2 to the challenger,** replacing today's free Pass?
5. **Look:** the kit (Bebas Neue, IBM Plex Mono), or the Look B John cites?
6. **Draw** at 8 × (0.5 − expected)?

**CHECKs for Claude:**
1. Ladder size per class.
2. Does the CODE chance include the plan?
3. The NOT SAFE counts.
4. Can offers come from a rival manager (`AmateurBooking`)?
5. Is the ticket cut paid on every win, and nothing on a loss?
6. Does a travel cost exist?
7. Is the 30-day suspension inside `STOP_REST_WEEKS`?
8. Do a boxer sponsor and squad selection exist?
9. What reads the 4-win ranking?
10. England Boxing's rest days between bouts.
11. What morale changes in a fight.

## 8. Self-score (fresh critics decide)
- **Depth 7:** the full price flips the best row in two of three cases, and the yes chance closes windows (Case C).
- **General design 7:** one unit, two names, one rematch rule, the weight forecast, and Pass rules that state their cost.
- **Play 7:** the owner's screen, with a default of 8 rows or fewer.

## To reach 10/10
1. Build in this order:
   - `RepRules`, `RepLedger` and `Clock`;
   - `BoutPrice`;
   - `Ladder` and `Season`;
   - `AskAnswer` and `Challenge`;
   - the bots.

   Then publish probe lines 1–18, starting with 13, 16 and 17.
2. Get owner answers 1–6. Question 1 decides R6.
3. Close the 11 CHECKs. CHECK 9 comes before World > Rankings switches, and cut the travel, sponsor and squad lines if the code lacks them.
4. Draw the screen at 1920×1080 in the stress state, then send the drawing to two fresh critics.

## The 10/10 page (1920×1080, Fights > Who do we fight?)
- **Top bar (0–64):** dark, with the OFFER flag and Continue in green.
- **Header (64–140):** your boxer's portrait, class and record, "Rep 38 · 8th", and the name once.
- **Rep bar and season strip (140–220):** the 30 / 45 / 55 marks and the club shows to 31 Dec.
- **Offer row (220–280):** Accept / Not this show / Pass, with "Accepting cancels your ask for 28 Mar".
- **Left (40–1180): the table.**
  - Filter chips, with In reach and Legal now lit; "Showing 6 of 24 · Show all".
  - Six rows and the dashed reach line at 55. The folded line "3 in reach can't be asked now ▸".
  - Stress state: one Weight at risk chip, one OWED chip, one WON'T STOP THE CLOCK row, and your row in slate.
- **Right (1220–1880): the card,** "Your boxer v the #3", from top to bottom:
  - the yes and chance boxes;
  - the win and loss table;
  - the show and fight week;
  - To raise the yes;
  - ASK FOR THIS BOUT, the only gold thing on the page.
- **Fonts and hover:** Bebas Neue and IBM Plex Mono, nothing under 12, and every number opens its sum on hover.
