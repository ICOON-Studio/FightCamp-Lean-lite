# DESIGN_TURNPRO1_V1_WRITE_KALLI_KALLI - Kalli answer (seat queue SQ105)

Brief: research/DESIGN_TURNPRO1_V1_WRITE_KALLI.md
Sent: 2026-11-14 06:11 | collected: 2026-11-14 06:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# TURNPRO1 v1: turning pro (S459, S463)

Part 1 of 3

**Owner rules this map keeps, quoted**
- S448: "notice how the names are only mentioned on the header, nowhere in text menus options, follow that rule".
- S412: the player runs any gym with any boxers, men or women. There's no fixed he or she, and never one boxer as the story.
- S425: wired and shown on the correct menus, deep enough for a critic's 7/10.
- S428: amateur to the first pro fight only. No TV, belts or world bodies.
- Section 7: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- Females never fight males. The facility is the gym. FIGHT WEEK is the amateur's last week; "camp" is pre-bout preparation.

**Tags.** REAL comes from John's J_PRODEBUT1 (UK BBBofC, 2026-10-31). CODE is what the game does today (S463). GAME VALUE is a chosen number. ESTIMATE is a proposal to be tuned by the probes. GBP is turned into USD at the game's own sheet prices, not by an exchange rate.

## 1. The choice and its depth

### 1.1 When the call comes (CODE, kept)
- A promoter calls when your boxer is "at the line": 7 amateur wins and a regional top 3, or 9 wins at any rank, or a national finalist (first call only).
- Each decline raises the need by 2 wins. After 2 declines only a regional number 1 brings a call. After 3 the door is closed.

**New (ESTIMATE): the first caller is not random.**
- **Bow Lane Promotions calls first** when the ticket forecast reaches its break-even.
- **Harrow & Finch Boxing calls first** when it doesn't.
- The second call comes from the other promoter (CODE, at 0.9× terms).

The player can see which promoter is coming: the NEXT STEP road on the fighter page shows "Tickets 54 of 60: below break-even, the guarantee promoter will call".

### 1.2 The two promoters (both fictional)

| | Bow Lane Promotions, the ticket house | Harrow & Finch Boxing, the guarantee house |
|---|---|---|
| Debut purse | $1,500 (CODE) | $1,800 guaranteed (ESTIMATE) |
| Win bonus, top | +$500 a win, $3,000 top (CODE) | +$400 a win, $3,000 top (ESTIMATE) |
| Break-even | 60 tickets (CODE) | 70 tickets (ESTIMATE) |
| Boxer's share past break-even | 50% (CODE; REAL "50/50 after costs") | 30% (ESTIMATE) |
| Under break-even | purse cut by $25 a ticket short, floor $500 (ESTIMATE; REAL "poor sellers often fight for nothing") | none: the purse is guaranteed |
| Debut date | 4 weeks out (CODE) | 6 weeks out (ESTIMATE) |
| Debut opponent | journeyman rated 1.0 under (CODE) | journeyman rated 1.5 under (ESTIMATE) |
| Later offers (ProLadder mix) | STEP UP more often: 2 in 5 rows (ESTIMATE) | TUNE-UP more often: 2 in 5 rows (ESTIMATE) |

The choice: Bow Lane pays a boxer who sells, and pushes a boxer who wins. Harrow & Finch protects a boxer who doesn't sell, and pays less for success.

### 1.3 One ask (ESTIMATE, AskBout pattern: never a random no)
On the offer, the player may make **one** ask before signing. Each ask shows "will take it" or "won't: <reason>" before it's pressed.

| Ask | Effect | When the promoter takes it |
|---|---|---|
| Later debut | +2 weeks; room for a 3-week pro camp | always |
| Softer opponent | opponent −0.5 more; purse −$250 | always |
| Better split | +10 points past break-even | only if the forecast is 20+ over break-even |
| Your boxer's own ticket price | $40 instead of $50; +15 tickets (ESTIMATE; REAL £40–45) | Bow Lane only |

### 1.4 What waiting buys and costs (per extra amateur win)

| Waiting buys | Number | Tag |
|---|---|---|
| Tickets from the win | +2 | CODE |
| Members from the win (+8, at 0.5 a ticket) | +4 tickets | CODE |
| Amateur title on the record | +10 tickets | CODE |
| The gym's ticket cut from the amateur bout | +$450 | CODE |
| Reputation from the win | +5 | CODE |
| A Bow Lane call (if the forecast crosses break-even) | 50% share instead of 30% | ESTIMATE |

| Waiting costs | Number | Tag |
|---|---|---|
| Stipend, if paid | $250 a week | CODE |
| Each decline | the need rises by 2 wins; 3 declines and the door is closed | CODE |
| An amateur loss | −1 member, −2 reputation; no ticket rise | CODE |
| A stoppage loss | 30-day suspension and next offer 8 weeks later | CODE |
| Nationals entry | no other offers while in it | CODE |
| Age | none today (the career clock isn't built) | CHECK (Claude) |

**The worked tension (CODE numbers, Bow Lane, a 70-member gym, 7 wins):**
- Tickets: 35 from members + 20 family + 14 from wins = 69. That's 9 past break-even, so 9 × $50 × 50% = **$225** to your boxer.
- Gym's 25% of the purse is $375, plus $56 if the cut includes the ticket share (CHECK (Claude)).
- Paid on signing: $230 + $875 + $140 = **$1,245**.
- So the gym is about **−$814** on the debut, against **+$450** for one more amateur bout.

**Same gym, 9 wins and a regional title:** 35 + 20 + 18 + 10 = 83 tickets. That's 23 past break-even, so $575 to your boxer. The gym is about −$726 on the debut, but each later pro fight is +$500 a win to the purse.

Turning pro is an investment that pays back from about the third pro win. That's the decision.

### 1.5 What the gym loses when an amateur leaves (shown on the offer)

| Loss | Number | Tag |
|---|---|---|
| Amateur ticket cut | $450 a bout, about every 6 weeks, so about $75 a week | CODE / ESTIMATE |
| Regional table place and nationals run | lost | CODE |
| Amateur win members | +8 a win stops; whether pro wins add members | CHECK (Claude) |
| Club show top bout | the hosted show sells −40 seats without a 5+ win amateur on top, so about −$1,000 at $25 | ESTIMATE |
| Stipend saved | +$250 a week | CODE |
| Pro share | 25% of each purse | CODE |

The offer prints one line: "**The club's amateur results lose about $75 a week. The pro share pays back from about pro win 3.**"

Part 2 of 3

## 2. Preparation before the call

Each item is tied to a system the game already has.

| Preparation | Where | System | Effect | Cost | Tag |
|---|---|---|---|---|---|
| Grow the members | Money: dues band, premises, coaches | member target (CODE) | +0.5 tickets a member | existing prices | CODE |
| Top the club show | Money > CLUB SHOW | hosted show (CODE) | +10 ticket followers for your boxer, once per show | $3,500 show, can lose money | ESTIMATE |
| Book the medicals early | Money > ONE-OFFS, new row "Pro medicals" | ProDebut sheet | $875 paid now and valid 12 months; the debut sheet then shows $0 | $875 | CODE cost; 12 months is CHECK (John) |
| Trainer's corner licence | Club > People, your card | ProDebut sheet | $140 now; the sheet then shows $0 | $140 | CODE |
| Pro-style engine | Goal talk: "Five-round engine" (existing goal) | goals (CODE) | if met, the debut's round 4 fade penalty is removed (ESTIMATE) | goal time | ESTIMATE |
| Strength and conditioning staff | Club > People, STAFF JOBS | staff (CODE) | a pro camp's bill halved | $100 a week | CODE |
| Win the regional title | Fights, World > Championships | nationals (CODE) | +10 tickets; a national finalist gets a first call at any win count | the run | CODE |

**Nothing here is a new screen.** Two new rows: "Pro medicals" in ONE-OFFS and "Corner licence" on your staff card.

## 3. Failure paths that teach (no rigged rolls)

1. **The debut that loses money.** The sheet shows the forecast before signing. Under break-even with Bow Lane, the purse falls by $25 a ticket short. After the debut, the week review prints the real ledger line ("tickets 48 of 60, purse $1,200, gym paid $1,245, net −$945") and one NEXT line ("+20 members would have covered it").
2. **The closed door.** Each decline shows the next need before it's pressed ("Stay amateur: the next call needs 9 wins and a top 3. Two more declines close the door."). After the third, the road shows "No promoter will call" and the amateur career carries on, so nothing is taken away.
3. **The debut loss.** The journeyman's file is shown (CODE: "heavy right hand, fades after round 3"). A loss is settled by the normal fight. The pro record reads 0-1, the next ProLadder offers are TUNE-UP only for one fight (ESTIMATE), and the Why names the cause.
4. **A missed debut weight** costs the slot (CODE $300) and the promoter's next offer drops to 0.9× (ESTIMATE). Weight is handled by WEIGHT1.

## 4. Every menu, and what each is wired to

| # | Menu | What shows | Wired to |
|---|---|---|---|
| M1 | Top bar flag | PRO OFFER (red, stops the clock on its last day) | opens M3 |
| M2 | Home notice board | "Pro offer: Hear it" | opens M3 |
| M3 | Pro offer modal | promoter, terms, ticket forecast and break-even, the debut ledger, what the club loses, the one ask; buttons Turn pro / Stay amateur | Roster.pro_ready, ProDebut, StarDeal; new: PromoterStyle, the one ask |
| M4 | Fighter page > Overview > NEXT STEP | road to the call: wins of 7 or 9, rank, tickets of break-even, which promoter will call, declines left | Roster.pro_ready, ProDebut forecast |
| M5 | Fighter page > Overview > contract | "club stipend $250 a week, until turning pro", then the pro split | StarDeal |
| M6 | Fighters > Roster | The Road column: "at the line" chip | M4 |
| M7 | Club > Money | ONE-OFFS (medicals, licences), STIPENDS (stops on signing), CONTRACT TALKS | ProDebut, ledger |
| M8 | Club > People | your card: Corner licence (Buy $140) | ProDebut |
| M9 | Club > Money > CLUB SHOW | "Top of the bill: your 7+ win amateur, +10 ticket followers" | hosted show, ticket followers |
| M10 | World > News | "Bow Lane Promotions signs a 60 kg boxer from <gym>" or "stays amateur for now" (no person's name in the line) | news |
| M11 | Week review | debut ledger line and NEXT line; decline count | ledger, Why |
| M12 | Fights | after signing: the debut card and the ProLadder strip | ProLadder |
| M13 | Fighter page > History | milestone "turned pro" | Records |
| M14 | Club > Records | "turned pro" with the promoter | Records |
| M15 | Office desktop | needs: Pro offer; next four weeks: debut date, medicals due | Desktop (built S451) |
| M16 | Goal talk | "Five-round engine" offered once the boxer has 5+ wins | goals |

## 5. Probes (bots, 200 careers each, two years)

| Bot | Rule |
|---|---|
| YES | signs at the first call |
| RANK | declines until a regional number 1 or a title, then signs |
| PREP | grows to 90+ members and books the medicals early, then signs at the first call that clears break-even |
| NEVER | stays amateur |

**Pass lines (all ESTIMATE):**
1. No bot has the best cash at week 104 in more than 60% of careers.
2. PREP beats YES on cash at week 104 by $1,500+.
3. NEVER beats YES on cash at week 52 but loses by week 104.
4. YES's debut loses money in 40–70% of careers.
5. RANK has the door close in 10–30%.
6. The debut win rate is 65–80% at 1.0 under, and 70–85% at 1.5 under.
7. Each of the four asks is the best ask in 10%+ of offers.
8. Harrow & Finch is the right pick in 25%+ of first calls.

Part 3 of 3

## 6. Scope and open questions

**What this map does not do:**
- No TV, belts, world bodies or full cards (S428).
- No managers, agents or contracts beyond the one ask.
- No promoter loyalty across fights (beyond the 0.9× second call), and no rival gym poaching.
- No age clock.
- No pro sparring partners beyond the existing camp partner.
- No no-gi pro path: BJJ has no pros.
- No new screen.

**Open questions for the owner (scope, money and taste):**
1. Should the two promoters differ as shown (ticket house against guarantee house), or keep one shape at 0.9×?
2. Should the one ask exist, or is the offer take-it-or-leave-it?
3. Should a debut be allowed to lose the gym money (about −$800 in a 70-member gym)? It's REAL, but harsh.
4. Should a closed door stay closed for good, or reopen with a national title?
5. Should the club show lose seats without its top amateur (−$1,000)?

**Questions for Claude and John:**
- CHECK (Claude): whether the gym's 25% includes the ticket share, and whether pro wins add members.
- CHECK (John): whether the medicals' validity is 12 months, and whether club shows really draw on a top amateur.

## 7. My score of this map

**DEPTH 6, GENERAL DESIGN 6, PLAY 5.**

- **Depth.** The real choice is when: wins and tickets against the stipend, declines and the club's amateur cut. On top of that are two promoters with opposite shapes, one ask, and preparation tied to members, medicals and the show. The promoter terms are still estimates, and the ask is shallow.
- **General design.**
  - All of it is buildable from ProDebut, Roster.pro_ready, StarDeal, ProLadder and Money.
  - There are no names outside headers, and 16 menus are wired.
  - Weak spots: the club show seat loss and the "pro wins add members" question are unchecked, and the ledger depends on the 25% question.
- **Play.** The forecast building towards break-even gives anticipation over weeks. But the moment itself is still one modal, and losing the amateur feels like a number, not a goodbye.

## To reach 10/10 (most important first)

1. **Run the four probes and print the cash curves.** Tune the Harrow & Finch numbers until pass lines 1, 2 and 8 hold.
2. **Settle the two CHECKs** (the 25% on tickets, and members from pro wins). The debut ledger is only true once they're known.
3. **Make the leaving felt in the club's numbers.** For 4 weeks after signing, the week review shows the amateur cut lost against the stipend saved, and the club show's seat line.
4. **Give the ask a second layer.** A promoter remembers a declined offer: the second call carries 0.9× terms (CODE) unless the boxer won a title since. That gives each decline a visible price beyond the win count.
5. **Ticket forecast as a line over time** on NEXT STEP (wins, members, the show), so the player can plan the week the forecast crosses break-even.
6. **A pro camp row on Fight prep** for the debut: 4 rounds, the journeyman's file, "Five-round engine" met or not, with the existing camp choices.
7. **Source the club show draw** (CHECK (John)) or drop the −40 seats.
8. **The 1920×1080 offer page (Look B):**
   - The polaroid and the name once in the header.
   - Left: the promoter's terms as a paper contract with the one ask as a red pen note.
   - Centre: the ticket bar against break-even, and the debut ledger with every number on hover.
   - Right: "What the club loses" with three lines.
   - Gold on the forecast line only, and the red Turn pro button beside Stay amateur.
9. **A debut-day news line and a gym crowd beat** (more people on the gym floor for one week, ESTIMATE +2), so the first pro fight feels like an event without TV.
10. **Mark every ESTIMATE in the code constants** so the critics can audit them against the probe results.
