# DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ110)

Brief: research/DESIGN_TURNPRO1_V2_REVISE_KALLI.md
Sent: 2026-11-14 09:42 | collected: 2026-11-14 10:00 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# TURNPRO1 v2: turning pro (S459, S463, 2026-11-14)

Part 1 of 3

**Owner rules this map keeps, quoted**
- S448: "notice how the names are only mentioned on the header, nowhere in text menus options, follow that rule".
- S412: any gym, any boxers, men or women. No fixed he or she, and never one boxer as the story.
- S425: wired and shown on the correct menus, deep enough for a critic's 7/10.
- S428: this map covers amateur to the first pro fight. **It stops at the debut.** The pro ladder, belts and ageing already in the code carry on after it, unchanged (answers Maria 10).
- Section 7: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- Females never fight males. The facility is the gym. "Camp" is pre-bout preparation, and the last week before a bout is TAPER (answers Maria 10).

**Tags**
- **CODE (pack)** means the critic pack confirms it.
- **CODE (S463)** came from Claude's code facts in the TURNPRO1 brief. The pack doesn't show it, and it needs a file:line from Claude before build: CHECK (Claude) (answers Maria 1).
- **REAL** comes from John's J_PRODEBUT1 (UK, 2026-10-31).
- **ESTIMATE** is a starting value that the probes size.
- **EXAMPLE** is only an illustration.

## 1. The choice

### 1.1 When the call comes
- A call comes at 7 wins with a regional top 3, or 9 wins at any rank. **CODE (pack)**
- A national finalist gets a first call at any win count. **CODE (S463)**
- Each decline adds 2 wins to the need. After 2 declines only a regional number 1 brings a call; after 3 the door is closed. **CODE (S463)**
- **Age (new, answers Maria 7):** no first call at 32 or older. The offer and NEXT STEP show the age line, for example "Age 29: first calls stop at 32". The number is ESTIMATE; age itself is BUILT.
- **The offer stands 14 days** (ESTIMATE). Opening it, reading it and asking don't count as a decline; only Stay amateur does (answers Dola, "test the waters").

### 1.2 Who calls: one promoter, or both side by side (answers Maria 3)

| Ticket forecast | Who calls |
|---|---|
| 15+ over Bow Lane's break-even | Bow Lane alone |
| within 15 of break-even, either side | **both, the same week, two offers side by side** |
| 15+ under | Harrow & Finch alone |

- **After a decline**, the next call comes from the same promoter at 0.9× terms, unless your boxer won a title since. A title clears it. **CODE (S463)** for the 0.9×; the title reset is ESTIMATE (answers Dola 5 and the v1 list, item 4).
- **Different ladders after the debut** (answers Dola, "promoters converge"): for the first 6 pro fights, Bow Lane's three offers lean STEP UP (2 in 5 rows) and Harrow & Finch's lean TUNE-UP (2 in 5). ESTIMATE, using ProLadder's existing three rows.

### 1.3 The two promoters (both fictional)

| | Bow Lane Promotions, the ticket house | Harrow & Finch Boxing, the guarantee house |
|---|---|---|
| Debut purse | $1,500 (CODE pack) | $1,800 guaranteed (ESTIMATE) |
| Win bonus to next purse, top | +$500, $3,000 (CODE S463) | +$400, $3,000 (ESTIMATE) |
| Break-even | 60 tickets at $50 (CODE S463) | 70 (ESTIMATE) |
| Boxer's share past break-even | 50% (CODE S463; REAL "50/50 after costs") | 30% (ESTIMATE) |
| Under break-even | purse −$25 a ticket short, floor $500 (ESTIMATE; REAL "poor sellers often fight for nothing") | none |
| Debut date | 4 weeks out (CODE pack) | 6 weeks out (ESTIMATE) |
| Debut opponent | journeyman 1.0 under (CODE S463) | journeyman 1.5 under (ESTIMATE) |

### 1.4 One ask, a real trade, with a counter (answers Maria 5 and Dola 3)
- Before signing, the player may make **one** ask on each offer. Each ask shows its answer before it's pressed: "will take it", "will counter: <terms>", or "won't: <reason>" (AskBout pattern, never a random no).
- Pressing an ask that has a counter shows the counter terms. The player can take the counter or go back to the plain offer; it still counts as the one ask.

| Ask | Price | Counter | Taken when |
|---|---|---|---|
| Later debut | +2 weeks for purse −$150, or +4 weeks for −$300 | none | always (answers Dola, timeline beyond +2) |
| Softer opponent | −0.5 rating; the next 2 pro offers are TUNE-UP only | none | always |
| Better split | +10 share points; the opponent is 0.5 *higher* | +5 points with the opponent unchanged, when the forecast is 5 to 19 over | 20+ over |
| Own ticket price | $40 not $50; +15 tickets (REAL £40–45) | none | Bow Lane only |
| Costs from the purse | the promoter pays the $1,245 and takes $1,345 from the purse | +$200 instead of +$100 when the gym's runway is under 8 weeks | Harrow & Finch only, since the purse is guaranteed (answers Dola, "defer the costs") |

- **Two asks at once** get "Pick one", shown as a line on the offer (answers Dola 3).
- Every number in this table is ESTIMATE. Probe pass line 7 sizes them.

**Not done: "one more amateur bout after signing"** (Dola). A licensed pro can't box amateur. Later debut +4 is the nearest real option, and the 14-day window lets the player finish a booked amateur bout before answering.

### 1.5 Your boxer's say (answers Maria 4)

| Ambition on the signing card | Turn pro | Stay amateur |
|---|---|---|
| turn pro | morale +5 | morale −5; the next decline −5 more |
| national title | morale −5 if before a nationals run | no change |
| other | no change | no change |

- Morale is CODE (pack). The ambitions doing something is agreed design, not built.
- The two ambition words must match what the signing card holds: CHECK (Claude).
- Loyalty reads the same two answers once the agreed loyalty design is built. Until then this map gives it nothing.
- The offer shows the morale change on each button, with no name.

Part 2 of 3

## 2. The money, gym and boxer apart (answers Maria 2 and Dola 1)

**Gym net at signing** is the gym's 25% of the purse, minus $1,245 (licence $230, medicals $875, corner licence $140, CODE pack). The 25% is CODE (pack). Whether it also covers the ticket share is CHECK (Claude); if it does, add 25% of that.

**After signing, every week:**
- The stipend stops: +$250 a week if it was being paid (CODE pack).
- The amateur ticket cut is lost: $450 a bout, about one bout every 6 weeks, so about −$75 a week (ESTIMATE).

**The boxer's money** is printed on its own line, never mixed with the gym's.

**Worked cases** (70-member gym, 69 tickets for Bow Lane: 35 from members, 20 family, 14 from 7 wins, CODE S463):

| Case | Gym at signing | Weekly after | Gym by debut day | Boxer |
|---|---|---|---|---|
| A. Bow Lane, stipend paid | $375 − $1,245 = **−$870** | +$175 | −$170 (week 4); even about week 5 | 75% of $1,500 + 9 × $50 × 50% = $1,350 |
| B. Bow Lane, no stipend | −$870 | −$75 | −$1,170 | $1,350 |
| C. Harrow & Finch, 54 tickets, stipend paid | $450 − $1,245 = −$795 | +$175 | **+$255** (week 6) | 75% of $1,800 = $1,350 |

**Case B, the honest picture.** Later purses step up by the win bonus, and the gym takes 25%: about $500, $625, $750 from pro fights 2 to 4. With a pro fight about every 8 weeks (ESTIMATE), the lost amateur cut is about $600 per gap. So without a stipend, the debut cost comes back only once your boxer is ranked, unless pro wins add members.
- Pro wins adding members (+8 is about $65 a week each in dues) is CHECK (Claude), and it is the blocker. The pays-back line reads from it.

**What this means:** the stipend decides the timing. A gym paying it gains every week a ready boxer turns pro sooner. A gym not paying it is buying a ranked future. The offer prints one line from the real case:
- "The gym is about even five weeks after signing."
- or "The gym gets its money back once your boxer is ranked."

The 9-win, regional-title case: 83 tickets, $575 more to the boxer, and the gym's line is unchanged under Bow Lane. That's correct: tickets pay the boxer, and the gym's gain from waiting is the extra amateur cuts and members on the way.

### 2.1 What waiting buys and costs, per extra amateur win

| Buys | Number | Tag |
|---|---|---|
| Tickets | +2 | CODE S463 |
| Members (+8) as tickets | +4 | members CODE pack; 0.5 a member CODE S463 |
| A title on the record | +10 tickets | CODE S463 |
| The amateur ticket cut | +$450 | CODE pack |
| Reputation | +5 | CODE pack |
| Crossing into the side-by-side band | a real promoter pick | ESTIMATE |

| Costs | Number | Tag |
|---|---|---|
| Stipend, if paid | $250 a week | CODE pack |
| A loss | −1 member, −2 reputation | CODE pack |
| A stoppage loss | 30-day suspension; next offer 8 weeks later | CODE pack |
| Nationals | no other offers while in it | CODE pack |
| Each decline | +2 wins needed; 0.9× terms; door closes after 3 | CODE S463 |
| Age | first calls stop at 32 | ESTIMATE |
| Your boxer's ambition | morale, as in 1.5 | ESTIMATE |

## 3. Preparation, kept only where it changes something

| Preparation | Where | Effect | Cost | Tag |
|---|---|---|---|---|
| Grow the members | Money: dues band, premises, coaches | +0.5 tickets a member | existing prices | CODE S463 |
| Top the club show | Money > CLUB SHOW | +10 ticket followers once per show | $3,500, can lose money | ESTIMATE |
| Pay or stop the stipend | Money > STIPENDS | sets the weekly swing after signing (section 2) | $250 a week | CODE pack |
| Five-round engine | Goal talk (existing goal) | met: no round-4 fade at the debut | goal time | ESTIMATE |
| Strength and conditioning | Club > People, STAFF JOBS | the pro camp bill halved | $100 a week | CODE pack |
| Win a regional title or reach a national final | Fights, World > Championships | +10 tickets; a final brings a first call; clears 0.9× terms | the run | CODE S463 / ESTIMATE |

**Cut from v1** (answers Maria 6): early medicals and the early corner licence. They cost the same and only hid the real cost. All $1,245 is paid at signing, or taken from the purse through the Harrow & Finch ask.

**Cut from v1** (answers Maria 8, Dola 7): the club show seat loss. It wasn't sourced, and John has no figure for it.

## 4. Failure paths that teach (no rigged rolls)
1. **The debut that loses money.** Before signing, the gym and boxer lines show it. After the debut, the week review prints the real gym line, for example "Gym: share $300, costs $1,245, net −$945". The NEXT line names the lever: more members, the stipend, or Harrow & Finch.
2. **The closed door.** Each decline shows the next need before it's pressed: "Stay amateur: the next call needs 9 wins, at 0.9× terms. Two more declines close the door." After the third, the road says "No promoter will call", and the amateur career carries on.
3. **Age.** From 30 the road shows "first calls stop at 32". It's never a surprise.
4. **The debut loss.** The journeyman's file shows on Fight prep. The normal fight settles it. The record reads 0-1, the next three offers are TUNE-UP only for one fight (ESTIMATE), and the Why names the cause.
5. **A missed debut weight.** The club pays the $300 slot (CODE pack), and the next offer is at 0.9× (ESTIMATE).

## 5. Making the leaving felt (answers Dola 4, Maria 9, v1 list item 9)
- **Week review, the 4 weeks after signing:** one line, "Amateur cut lost $450 this month; stipend saved $1,000." It's built from the real ledger.
- **Gym floor:** +2 people for the signing week (S409 decoration, 2 to 12 people; ESTIMATE).
- **Records and History:** "turned pro" with the promoter and the date.
- **World > News:** "A 60 kg boxer from <gym> signs with Bow Lane Promotions", with no person's name.
- **Debut fight night,** first corner minute: the coach's note says "First one as a pro. Same ring, same plan." That's under 70 characters, with no numbers, in the plain gym voice.
- **Fight prep, the pro camp row** (answers Dola 8, v1 list item 6): "4 rounds", the journeyman's file, Five-round engine met or not, and licence and medicals paid. It sits on the existing camp choices; nothing new.

Part 3 of 3

## 6. Every menu, and what each is wired to (S425)

| # | Menu | What shows | Wired to |
|---|---|---|---|
| M1 | Top bar flag | PRO OFFER, red on its last day of 14 | opens M3 |
| M2 | Home notice board | "Pro offer: Hear it" (one note, even with two offers) | opens M3 |
| M3 | Pro offer modal | one or two contracts; terms; the one ask with its answer or counter; the gym line and boxer line; the pays-back line; morale on each button; age; declines left; Turn pro with <promoter> / Stay amateur | Roster.pro_ready, ProDebut, StarDeal; new: PromoterStyle, the ask, the two-offer band |
| M4 | Fighter page > Overview > NEXT STEP | wins of 7 or 9, rank, age line, declines left; ticket forecast as a line over 8 weeks, with the week it crosses each break-even (answers Dola 6) | Roster.pro_ready, ProDebut forecast |
| M5 | Fighter page > Overview > contract | stipend, then the pro split | StarDeal |
| M6 | Fighters > Roster | The Road: "at the line" chip | M4 |
| M7 | Club > Money > STIPENDS | Pay / Stop, with a hover: "Stopping it at signing saves $250 a week" | stipend, ledger |
| M8 | Club > Money > ONE-OFFS | licence, medicals, corner licence at signing, or "from the purse" | ProDebut, ledger |
| M9 | Club > Money > CLUB SHOW | "Top of the bill: +10 ticket followers" | hosted show |
| M10 | World > News | the signing line, with no person's name | news |
| M11 | Week review | the 4-week leaving line; the debut ledger and NEXT line | ledger, Why |
| M12 | Fighter page > Fight prep | the pro camp row | camp, ProDebut, opponent file |
| M13 | Fight night, corner minute | the debut coach's note, once | corner card |
| M14 | Fights | after signing: the debut card, then ProLadder with the promoter's lean | ProLadder |
| M15 | Fighter page > History | milestone "turned pro" | Records |
| M16 | Club > Records | "turned pro" with the promoter | Records |
| M17 | Office desktop | needs: Pro offer; next four weeks: debut date | Desktop (S451) |
| M18 | Goal talk | Five-round engine offered at 5+ wins | goals |
| M19 | Home gym floor | +2 people for the signing week | S409 people |

The v1 row "Club > People: Corner licence (Buy $140)" is cut, along with the early buy.

## 7. Probes (200 careers each, two years, three seed sets; half the careers pay the stipend)

| Bot | Rule |
|---|---|
| YES | signs at the first call; takes the best-looking ask |
| RANK | waits for a regional number 1 or a title |
| PREP | grows to 90+ members and tops a club show, then signs at the first side-by-side call |
| NEVER | stays amateur |
| AMB | follows the boxer's ambition |

**Pass lines (all ESTIMATE):**
1. No bot has the best cash at week 104 in more than 60% of careers, on every seed set.
2. PREP beats YES on cash at week 104 by $1,500+.
3. With the stipend paid, YES beats NEVER by week 52. Without it, NEVER leads at week 52 and YES leads by week 104.
4. YES's debut loses gym money in 40–70% of careers.
5. RANK's door closes in 10–30%.
6. Debut win rate is 65–80% at 1.0 under and 70–85% at 1.5 under.
7. Each of the five asks is the best ask in 10%+ of offers, and each counter is taken in 20–60% of the times it's shown.
8. Harrow & Finch is the right pick in 25%+ of first calls, and both promoters call together in 25–50% of first calls.
9. AMB's morale stays Steady or better at signing in 70%+ of careers.

## 8. Scope
- Stops at the debut.
- No managers or agents.
- No promoter memory beyond the 0.9× and the title reset.
- No rival gym poaching.
- No BJJ pro path.
- No new screen.

## 9. Owner questions
1. Should both promoters call side by side near break-even, or one at a time?
2. Should a debut be allowed to cost the gym money (about −$870 at signing)? It's REAL.
3. Should a closed door reopen with a national title?
4. Should first calls stop at 32?

## 10. CHECKs
- **CHECK (Claude):**
  - file:line for every CODE (S463) number.
  - Whether the 25% covers the ticket share.
  - Whether pro wins add members.
  - The ambition words on the signing card.
- **CHECK (John):** typical UK first-pro age cut-offs, and how common it is for a promoter to take costs from the purse.

## 11. Critic points, answered

**Dola**

| # | Point | Answer |
|---|---|---|
| 1 | Settle the CHECKs | **Listed as the blocker** (section 10). The ledger now prints both outcomes until settled |
| 2 | Run the probes, tune | **Done as a plan**: 9 pass lines on three seed sets, with a stipend split. Running them is Claude's |
| 3 | Counter-offers, "pick one" | **Done** (1.4) |
| 4 | Milestone felt | **Done** (section 5). Corner note in gym voice; no "we're behind you" line, as it's flavour text (section 7 of the pack) |
| 5 | Negotiation history | **Done**: 0.9× from the same promoter, a title clears it |
| 6 | Forecast trend | **Done** (M4) |
| 7 | Source or remove the show penalty | **Removed** |
| 8 | Pro camp card | **Done** (M12) |
| missing | Defer costs | **Done**: Costs from the purse ask |
| missing | Later than +2 | **Done**: +4 weeks |
| missing | Test the waters | **Done**: 14 days, asks don't count |
| missing | Undercard first | **Not done**: a licensed pro can't box amateur |

**Maria**

| # | Point | Answer |
|---|---|---|
| 1 | file:line or ESTIMATE | **Done**: split into CODE (pack) and CODE (S463), with a CHECK for file:line |
| 2 | Fix the gym ledger | **Done** (section 2), stipend included |
| 3 | Real promoter pick | **Done** (1.2) |
| 4 | Your boxer's say | **Done** (1.5) |
| 5 | Asks as trades | **Done** (1.4) |
| 6 | Cut early medicals and licence | **Done** |
| 7 | Age | **Done** (1.1) |
| 8 | Show seat loss | **Dropped** |
| 9 | Leaving felt | **Done** (section 5) |
| 10 | Scope words | **Done**: stops at the debut; TAPER |

## 12. Build order
1. Settle the CHECKs.
2. Gym and boxer ledger lines on M3, with the stipend.
3. The two-offer band and the promoter terms, with every ESTIMATE as a named constant marked ESTIMATE (v1 item 10).
4. The asks and counters on the AskBout pattern.
5. Ambition, age, and the 14-day window.
6. Section 5 beats and M4's forecast line.
7. Run the probes and tune.

## 13. My score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6.**

- **Depth.** Timing now turns on the stipend, age, ambition and tickets. Promoters are a real pick near break-even, and every ask has a price and a counter. The proof waits on the probes.
- **General design.** The ledger is honest and split. Useless options are cut, and the unsourced loss is dropped. Tags are honest, with 19 menus wired and no new screen. Points come off because seven CODE (S463) numbers still need file:line, and the members CHECK decides the pays-back line.
- **Play.** The forecast line, the side-by-side moment, the boxer's say and the leaving beats add feeling. The debut itself is still a normal fight night.

## To reach 10/10
1. **Settle the members-from-pro-wins CHECK** and reprint cases A to C with it.
2. **Run the probes on three seed sets,** and replace every ESTIMATE with its probed value.
3. **file:line for the seven CODE (S463) numbers,** or retag them.
4. **Owner rulings** on questions 1, 2 and 4.
5. **John's age and costs-from-purse sources** (CHECK (John)), to make them REAL.
6. **The 1920×1080 offer page,** Look B:
   - **Header (120 px):** the polaroid, the name once, class in kg, age, record, rank, ambition.
   - **Left (640 px):** one or two paper contracts with the ask as a red pen note showing its answer or counter.
   - **Centre (640 px):** the ticket bar against each break-even, the gym line, the boxer line, and the pays-back line, with gold on that line only.
   - **Right (640 px):** what staying means: the next need, declines left, age, the amateur cut kept, morale.
   - **Bottom:** Turn pro with <promoter>, and Stay amateur, each with its price.
7. **A debut walkout beat** on fight night once the arena work (M38) lands: the gym's members in the seats, from the real ticket count.
