# DESIGN_CLUBWEEK1_V6_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ115)

Brief: research/DESIGN_CLUBWEEK1_V6_REVISE_KALLI.md
Sent: 2026-11-14 15:29 | collected: 2026-11-14 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: writing CLUBWEEK1 v6 in full now, answering every point from John and Dola.

# CLUBWEEK1 v6: the club week for four, with the fight weeks inside it and the season around it (S459, 2026-11-14)

Part 1 of 4

**Owner rules this map keeps, quoted**
- **Q-190 (S434/S435):** "Just rename it 'gym sponsorship', the club pays." What earlier drawings called PAID SEAT is GYM SPONSORSHIP (short: sponsorship), never mixed up with Sponsor deals on Club > Money.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Rows, buttons, tooltips, Home notes and Why lines say your boxer, the fighter, the grappler, a team-mate, your coach, the opponent. (v5's "Ana's open" is now "the grappler's open".)
- **S412:** "the player runs any gym with any boxers, men or women." No fixed he or she anywhere, and never one fighter as the story.
- **S425:** the table of every menu, and what each is wired to, is in section 6.
- **S459:** 6+ DEPTH and 6+ GENERAL DESIGN from fresh critics; ESTIMATEs marked; buildable from what the game has.
- **Pack section 7:** only information the player can act on; one word per concept; screens only from agreed mockups. The Club week tab needs the owner's OK (owner question 1).
- **Kept from v5:** professionals in the line-up with an amateur-to-pro guide; staff named by role. "Coach" is the hired assistant coach and "You" is the head coach. Stamina for the ability (Attrs.gd). Amateur classes in kg: women 57/60/65/75, men 57.5/60/70/75.

**Marks**
- **CODE** is in the code today (file or symbol named).
- **REAL** is real practice, with its source.
- **ESTIMATE** is ours, gated by the section 8 probes.
- **NEW** is a rule this map adds.

**Status, said plainly:** no probe has run on v6. v5's "re-measured in the LOYAL1 rerun" was wrong and is withdrawn. Every Need, Want, loyalty, mood and price number below is ESTIMATE until section 8 runs.

**One word list (answers John 10)**
- **Tiredness** (0–100) is the week's wear (CODE, "Week tiredness").
- **Tank** is fight-night energy.
- **Stamina** is the ability.
- "Legs" is dropped. What v5 called Legs is now "tiredness at the first bell".
- The fighter page tab is **Week**, not "Training".
- **A place** is defined in 3.1.

## 0. How v6 answers the critics

### John (5/7 design; 13-point list)

| # | Point | v6 |
|---|---|---|
| 1 | Grappler can't draw on the boxing coach | **Done (3.1, 3.6).** Boxing places only: 3 boxers × Need 2 = 6 of 8 owned, Want 9. The grappler's classes come from the no-gi coach, with their own counter. The grappler competes for mornings, the sponsorship and the Saturday corner. LOYAL1 and SHORTWEEK1 are re-specified on this pool; the tables come when they run (they're Claude's runs, so they can't be pasted yet) |
| 2 | Fight week asks for more, against TAPER | **Done (3.2).** Fight-week sessions are one-to-one: the same 2 sessions, half volume, each using the coach's whole hour (2 places). No sparring |
| 3 | Define a place | **Done (3.1).** One place is 120 drill units, half of PAD_NIGHT_MINUTES 240. The "0.7 on 4th, 0.5 on 5th" rule is replaced: at most 3 places a week, each full |
| 4 | Sponsorship sums | **Done (3.5).** The sponsorship IS the stipend ($250 a week, CODE), paid in 4-week blocks. One switch, one cost line: −$250 a week. MONEYFOUR2 is re-set |
| 5 | Loops | **Done.** A talk uses no evening place (one talk a week for the club). Low mood pays no month-without-a-fight penalty. A pad holder isn't counted short |
| 6 | One rule set with AMATEURWEEK1 | **Done (section 4).** AMATEURWEEK1 owns the bout rules and this map points to them. Recommended for its next version: weigh-in on the day, 1 hour before (EB 7.1.3, a code change from the day before); ±2 kg at club shows (REAL); one probed pull-out rate |
| 7 | Mornings, choice or not | **Done (3.4).** Solo now counts as a Hard morning (×1.3) with no Hard tiredness, against shared at 0.8 each. Spread against concentrate, probed |
| 8 | Weak spot counted twice | **Done (3.3).** The +0.25 edge is dropped. The pull names which opponent style finds it, from abilities the fight reads only |
| 9 | Unknown card useless | **Done (4.1).** It comes sooner (7 days, not 12) and carries +1 favour |
| 10 | Four missing options | **Done.** Cover a night ($80, 2 places), a chosen rest week, let a fighter go, and the stipend switch (merged into the sponsorship). A second coach adds no places, with the reason in 3.1 |
| 11 | Words; Week tab; owner OK | **Done.** Word list above; owner question 1 |
| 12 | Home and away on the sheet | **Done (4.1)** |
| 13 | Pro table back; road strip later | **Done (4.3, 2).** The road strip shows at the first amateur's 5th win |
| also | Favours: one regional pool | **Done (3.7),** matching AMATEURWEEK1 |
| also | Body only nearly useless | **Done (3.6).** It's the only setting allowed with an open cut |

### Dola (8/8/8; 6-point list, missing and useless options)

| # | Point | v6 |
|---|---|---|
| 1 | Run the probes | **Planned (section 8),** with pass lines. Running them is Claude's |
| 2 | 2-week forecast | **Done (3.8).** The NEXT WEEK line under the counters |
| 3 | Twists 12 to 18 | **Done (3.9).** Six added. "Media interview" was not added because the local paper card already does it |
| 4 | Why behind every loyalty move | **Done (3.10).** Every move prints its cause, with a 4-week log on Overview and in the Week review |
| 5 | Borrow from next week | **Done (3.1).** Borrow a place: +1 now, next week −1 owned, one at a time |
| 6 | Rest redistributes | **Done (3.1).** Freed places show "give to" choices or "sell as a class" |
| missing | Reorder fighters / default rules | **Done.** Deal order is row order: drag the rows, and the order is kept week to week |
| missing | Skip a fighter a week | **Done.** The chosen rest week |
| missing | Light sparring | **Not added.** Technical is the light setting (+6 tiredness, 1 cut in 100) |
| missing | Emergency borrow | **Done.** Same as point 5 |
| useless | Pass shows nothing | **Done.** "Pass: −2 loyalty; this name held 7 days; next sheet in about 2 weeks" |
| useless | Hidden cooldown | **Done.** "Tell it straight: back in n weeks", with the odds shown |
| useless | Film vague | **Done.** The card names what the next film opens ("next: the habit") |
| useless | Sponsorship "pass" timeline | **Not changed.** The sponsorship is the club's to give, not an outside offer. "Pass on" moves it to a team-mate |

## 1. The idea in six lines
1. Four fighters stay at the club you take over: one professional boxer, two amateur boxers and one no-gi grappler, each in a different weight class. ClubStart sets 4 places at Unit 1 (NEW; CODE gives 3).
2. Every Monday, the Club week deals the club's short things: the coach's **boxing evening places** (8), **coached mornings** (6), the **gym sponsorship**, your **one talk**, and your **Saturday corner**. Coach's evenings can be sold as a second beginners' class: the money lever.
3. Bouts sit on the same board. An amateur's fight week is one-to-one and half volume, true to TAPER. A pro's camp sets its own pad nights. Two fights close together are where the real shortages come from.
4. **Favours** are the second currency: one regional pool, earned by helping other clubs, spent to bend bout terms, never wins.
5. What lasts past the week: **loyalty**, **fans** (home bouts build the crowd that pays the pro debut) and **one season target** per fighter.
6. No Monday repeats: job rotas shift, one club twist lands (deck of 18), a trial prospect visits every 4 weeks, and the NEXT WEEK line shows what's coming.

## 2. The start (Create, step 2; each name once, in its card's header)
- **ONE PROFESSIONAL** (pick 1 of 2; new starter data: 1-0 pro, licensed, unranked, amateur fans carried over):
  - **Pro slot A:** women's 60 kg, age 21, out-boxer, potential 84, 34 fans (ESTIMATE).
  - **Pro slot B:** men's 70 kg, age 23, southpaw pressure fighter, potential 79, discipline 80, 22 fans, second pro bout booked 6 weeks out (ESTIMATE).
- **TWO AMATEURS** (pick 2 of 4):
  - **A:** women's 57 kg, 1-0, college rota.
  - **B:** women's 65 kg, 2-1, shifts rota, loyalty 82.
  - **C:** women's 75 kg, 6-4, office rota, loyalty 66.
  - **D:** men's 60 kg, 2-1, shifts rota, loyalty 58.
  - Each card shows the job rota, free mornings, sparring partners in reach, fans and ambition (Recruit.ambition).
- **THE GRAPPLER:** white belt, 2 stripes, cafe rota; the first open is Sat 7 Feb.
- **Staggered opening:** the unpicked amateurs return on the trial mat. The pro opens in camp, one amateur has a bout sheet, the other an active goal.

**The guide, weeks 1–5** (skippable; names only in headers):
1. Meet the four.
2. Deal the week.
3. Answer the call.
4. Start week.

After week 1 the guide names the trade, never the answer, and it stops after the 3rd fight week.
- **Road strip moved (answers John 11 and 13):** "The road, amateur to professional" (offer rule, saying no, the $1,245 at signing, the ticket-paid debut, purses) appears when any amateur reaches 5 wins. TURNPRO1 v2 owns its numbers.

**Reveal order (NEW)**

| Week | Arrives | Guide line |
|---|---|---|
| 1 | Boxing places (Need, Want), NEXT WEEK line, first bout sheet | "Eight places, six needed, nine asked." |
| 2 | Coached mornings; Coach's evenings as training or class | "A class pays the rent. Pads win bouts." |
| 3 | Club twist, sponsorship, sparring setting | "Hard sparring builds more and cuts more." |
| 4 | Favours, loyalty bar and its causes | "Whoever goes under their need remembers it." |
| 5 | Trial mat, season targets, talk card | "One target per fighter." |

Part 2 of 4

## 3. The week, as the player meets it

### 3.1 Boxing evening places (8 owned)
- **Where the 8 come from:** Coach works 3 evenings. The first hour is the existing members' class (+$350 a week, CODE). The second hour is 2 places, or a second class (3.1a). You hold 2 places on your own evening.
- **What a place is (answers John 3):** one place is **120 drill units**, half of a pad night's 240 (CODE, PadWeek.PAD_NIGHT_MINUTES). It goes onto the boxer's drill cards exactly as pad time does today.
  - A boxer takes at most 3 places a week (360 units).
  - Every place is full; there are no 0.7 or 0.5 places.

**Need and Want, ordinary weeks (BASE, BUILD)**
- Each boxer needs 2 and wants 1 more.
- 3 boxers: **Need 6 of 8 owned, Asked 9.** Every ordinary week has 2 spare places and still one boxer without a third. ESTIMATE.

**What creates real shortage**

| Event | Places | Club Need against owned | Tag |
|---|---|---|---|
| One amateur fight week (3.2) | that boxer takes 4 (2 one-to-one sessions × 2) | 8 of 8: full | ESTIMATE |
| Two fight weeks at once | 4 + 4 + 2 | 10 of 8: 2 short | ESTIMATE |
| Pro camp, BUILD and PEAK | the camp's pad nights × 2: Light 2 nights = 4, Standard 2 = 4, Hard 3 = 6 | 8 to 10 of 8 | camp nights CODE (2+1 / 2+2 / 3+2); places ESTIMATE |
| Pro TAPER week | one-to-one, 4 | 8 of 8 | ESTIMATE |
| One class night sold | owned 8 to 6 | 6 of 6 in an ordinary week; any fight week makes someone short | ESTIMATE |
| Film evening on a fight week | 2 (one coach hour) | +2 | ESTIMATE |
| Trial prospect (every 4 weeks) | +1 Want | competes for spare places only | ESTIMATE |

**Valves (answers John 10, Dola 5 and 6)**
- **Cover a night:** buy 2 places for $80 in any week. A sessional cover coach takes a second hour. Same price as the twist's cover. ESTIMATE.
- **Borrow a place:** +1 now, and next week is 1 owned short. One borrow outstanding at a time. The NEXT WEEK line shows the debt. ESTIMATE.
- **Chosen rest week:** a switch on any boxer's row: 0 Need, 0 Asked, +4 morale (CODE rest week +4).
- **Freed places, from rest, a pull-out, or a booked bout ending:** the counter shows "Freed 2: give to [row] / [row] / sell as a class +$117". This is Dola's redistribution. The default follows deal order.
- **Hold pads (Loyal 70+, 6+ bouts):** the holder gives one of its own places to a team-mate at 0.7 (84 units).
  - The holder is NOT counted short while holding (answers John 5).
  - Loyalty +3 a week, for at most 4 weeks.
- **Deal order is row order:** drag a row up and it's dealt first. The order is kept week to week (Dola's "default rules").
- **Second club coach** ($280, CODE: +1 roster place, +40 members, fitness classes) adds **no** places. Its 10 hours are fitness classes in the code. So the night cover is the cash-for-places valve.

**What meeting or missing costs**
- Need met: loyalty +1.
- Want met as well: +1 more.
- Short (covered under Need): −3, or −6 when short 2+ weeks running. Waived 1 week in 4 at Loyal 70+.
- A missed Want costs no loyalty, only the 120 units.
- All ESTIMATE.

### 3.1a Coach's evenings: training or a second class (the money lever)
- Each of Coach's 3 second hours, and your own evening, switches between **Pads (2 places)** and **Class (+$117 that night, about 1 new member every 4 weeks taught)**. ESTIMATE; the first-hour class's $350 is CODE.
- **Why it binds:** one class night drops owned places to 6, which is exactly ordinary Need. Any fight week, camp or film then makes someone short.

### 3.2 The amateur fight week: one-to-one, half volume (answers John 2)
- **The fight week** is the code's TAPER week, the 7 days before any booked bout (WeekPhase.phase, CODE).
- **The boxer keeps 2 sessions,** the same frequency. Each is one-to-one: the coach's whole second hour, which is 2 places.
- **Half volume:** each session drills 60 units of pads. The other half-hour is the fight-week bill: plan lines, the finish move, southpaw rounds, sharpening.
  - So the week drills 120 units, half the ordinary 240. That's inside the 41–60% volume cut (REAL: Bosquet et al. 2007).
- **No sparring in the fight week** (CODE TAPER).
- The counter prints the reason: "Fight week: one-to-one, 2 sessions".

### 3.3 What each fighter pulls
Warnings come first: Scale (over the limit inside 14 days), Fight (last 7 days), Rest (tiredness 70+ or hurt). Then up to two pulls, each with its size as a range and colour-coded by what it spends:
- **WEAK SPOT (answers John 8):** the lowest ability the fight reads, when 3+ below the fighter's level.
  - It adds no extra edge, since the fight already charges for the low ability.
  - The chip names who finds it: "Low Defence: pressure fighters find it."
  - Only abilities the fight reads. Whether Explosiveness and Recovery count is CHECK (Claude), per the pack.
- **WEAPON:** the ability gating the next perk ("Fast hands at Speed 70: about 4 weeks").
- **GOAL:** the active goal (+10 met, −20 missed, CODE).
- **AHEAD:** the next rival up the ladder, and the answers owned.

A pull asks for 2 coached mornings, or 2 places for Ahead. A sponsored fighter can hold 2 pulls; one with a day job, 1.

**Three deal buttons:** **Coach deals it** (the one-click default, John), **Keep my changes**, **By hand**. Under them sits "Coach's deal: 2 to 3 in 100 below yours". ESTIMATE, sized by TANKPRICE1.

### 3.4 Coached mornings (6 owned: You 4, Coach 2) (answers John 7)
- **Solo:** one fighter with a coach counts as a **Hard morning (×1.3) without Hard's extra tiredness.**
- **Shared:** two fighters on one morning get 0.8 each.
- So 6 mornings are either 6 × 1.3 = 7.8 on a few fighters, or up to 12 × 0.8 = 9.6 spread thin. Concentrating on one pull is the cost. ESTIMATE, probe MORNINGS1.
- **Alone mornings** train at the mood rate (3.11). Discipline under 45 skips 1 alone morning in 3 unless a team-mate trains in the room.
- The grappler competes for these mornings like any fighter.

### 3.5 The gym sponsorship IS the stipend (answers John 4)
- **One payment, one switch:** the code's stipend ($250 a week, CODE, Club > Money > STIPENDS) is shown and billed as the gym sponsorship in 4-week blocks ($1,000).
- **What it gives:** 6 free mornings a week, no job rota, loyalty +5.
- **The card prints:** "−$250 a week, billed per block."
- **Who can hold one:** amateurs and the grappler. A pro can't; the stipend stops on signing (CODE).
- **At the block's end:**
  - Renew: −$1,000, loyalty +2.
  - Pass on: the receiver +5, nobody loses.
  - Let end: 0.
- **Stopping it mid-block:** loyalty −8. A fighter with potential 80+ unsponsored for 8 weeks asks for one: −3 a week until it's given or a promise is dated.
- CHECK (Claude): that the stipend and the sponsorship can be one record.
- All loyalty numbers are ESTIMATE.

### 3.6 Sparring and the grappler
**Sparring** (pair and setting on the Club week; not in a fight week):

| Weight gap | Effect |
|---|---|
| Under 5 kg | full for both |
| 5–10 kg | lighter full, heavier half |
| Over 10 kg | lighter +10 tiredness |

| Setting | Gain | Tiredness | Cut risk | Allowed |
|---|---|---|---|---|
| Hard | ×1.3 | +12 | 4 in 100 | normal |
| Technical | ×1.0 | +6 | 1 in 100 | normal |
| Body only | Stamina and body ×0.8 | +8 | 0 | **the only setting allowed with an open cut** (answers John) |

All ESTIMATE; SPARSET1.

**The grappler (answers John 1):**
- Mat classes come from the **no-gi coach, paid by the class** (CODE): 3 a week on the cafe job (NoGi.CLASSES_PER_WEEK, CODE), 5 on a sponsorship (+6 tiredness for each over 3, ESTIMATE).
- Its own counter: "MAT CLASSES 3 of 3".
- **What the grappler competes with the boxers for:** your coached mornings, the sponsorship, the one talk, and your Saturday corner.
  - Who corners appears only when a boxer and the grappler both compete that Saturday: You, or a $100 mat coach.
- **The open:** Enter or Skip, with a choice between:
  - White: about 55 in 100; a gold brings +2 no-gi members.
  - Promote to Blue first: about 35 in 100, owes BeltRoad.EARLY_DEBT, +3 members.
- From blue, **Teaching** gives +$68 a week and about 1 member every 4 weeks, at −1 class.
- Stripe calls move loyalty on the shared scale (StripeCall, CODE).
- Numbers are ESTIMATE unless named.

Part 3 of 4

### 3.7 Favours: one regional pool (answers John)
- **Pool:** 0 to 5 favour magnets for the club with the region's show clubs. ESTIMATE, matching AMATEURWEEK1.
- **Earn:**
  - +1 for boxing on their show, a late replacement, or a sparring trip (1 of your places).
  - +1 for the Unknown sheet card.
  - +2 for a 4-day short-notice call.
- **Lose:** −1 for missing weight or pulling out. No loss if their boxer pulls out.
- **Spend:** −1 to ask a kilo, re-deal the sheet, ask for a named opponent, or move a bout a week.
- Favours never buy a win, a judge, a rank or a place.

### 3.8 The NEXT WEEK line (answers Dola 2)
One line under the counters, read from booked bouts, camps, rotas and borrowed places:
- "NEXT WEEK: fight week for your 65 kg boxer; Need 8 of 8. Selling a class tonight leaves 2 short."
- "IN 2 WEEKS: two fight weeks; Need 10 of 8."

It shows only when the next two weeks differ from this one.

### 3.9 One club twist a week (deck of 18; Dola 3)
- 1 week in 4 is quiet, and the same card never comes twice running.
- Each card has 2–3 priced answers. The clock waits for an answer; with none, Coach picks on Monday.
- **The 12 kept from v5:**
  - Coach off Wed
  - Coach stays late Thu
  - Overtime on Sat
  - Visiting pro spar
  - Boiler out Thu
  - Another club asks a kilo
  - Local paper photo
  - Short-notice call
  - Sponsor photo
  - Hall floods
  - Member's family pad session
  - Quiet week
- **Six new (ESTIMATE prices):**
  1. **Club fundraiser night:** give your evening (−2 places, +$300 once), or say no.
  2. **Bag splits:** repair ($120, +2 reputation, CODE repair), or improvise (heavy bag mornings ×0.8 for 2 weeks).
  3. **Bank holiday:** hall shut one evening. Lose 2 places, or pay the hall $90.
  4. **Guest coach Thursday:** one boxer gets a free one-to-one (2 places' worth). Pick who; the others see it (−1 loyalty to the one passed over if Wavering).
  5. **Winter bug:** two fighters miss 2 mornings. Rest them (−1 pull each), or train through (+10 tiredness each).
  6. **Junior taster:** your evening as a taster (−2 places, +2 members after 4 weeks), or pass.

### 3.10 Loyalty (0–100), every move with its cause (Dola 4)
**Bands**
- Loyal 70+: can hold pads, and 1 short week in 4 is waived.
- Settled 50+.
- Wavering 25+.
- Leaving, under 25.

**Moves (ESTIMATE):**
- Need met +1; Want met +1 more.
- Short −3; short again −6.
- Promise kept +5; broken −12.
- Sponsorship given +5; renewed +2; stopped −8.
- Holding pads +3 a week.
- Passing a ready sheet −2.
- A season target matching ambition +5; against it −5.
- Target met +10; missed −5.
- Stripe call: now +3, hold −5.
- Overtime refused −2.
- A team-mate let go −5 (3.12).

**Every move prints its cause:** "−3: short of the second place this week". Overview keeps a 4-week log, and the Week review shows the week's moves.

**The talk (loyalty under 50, "Wants a word"):**
- **One talk a week for the whole club.** It costs your Monday, **not an evening place** (answers John 5).
- Each fighter at most once in 4 weeks.
- The three answers:
  1. **Give the place back:** dealt first next week, +4.
  2. **A dated promise** of a place, a bout or the sponsorship, by a date (+5 kept, −12 broken; listed under PROMISES OPEN).
  3. **Tell it straight:** the odds come from the visible Coachability, shown on the button ("holds: 60%"): +4 or −4. The button shows "back in n weeks" during its 8-week cooldown.
- **Consequences:**
  - Under 25 after 2 talks, the fighter leaves next Monday for Eastside ABC.
  - Turning pro under 50, the fighter signs with an outside manager, and the club takes 10% instead of 25% (GYM_SHARE, CODE).

### 3.11 Mood with teeth (ESTIMATE, MOODRATE1)
- Morale bands (CODE): Fired up 75+, Steady 50+, Flat 30+, Low under 30.
- **Alone rate:**

| Mood | Alone rate |
|---|---|
| Fired up | 0.8 |
| Steady | 0.6 (CODE baseline) |
| Flat | 0.4 |
| Low | 0.4, skips 1 alone session in 2, passes the next bout sheet (no loyalty cost) |

- **Loop broken (answers John 5):** while Low, the month-without-a-fight morale penalty (−6, CODE) doesn't apply.
- Corner trust on fight night: 1.05 / 1.0 / 0.85 / 0.7 (CODE).

### 3.12 The squad changes
- **Trial mat, every 4 weeks:**
  - The prospect visits for 2 weeks (+1 Want).
  - **Watch** costs 2 coached mornings and gives exact potential.
  - Then Sign or Pass.
- **Let a fighter go (NEW, answers John 10):** a button on the fighter's row menu.
  - Price: the rest of the sponsorship block, if any, or 1 week's stipend; −5 loyalty to each team-mate; frees a roster place now. ESTIMATE.
  - Confirm on a second press, never pre-selected.
  - Signing a 5th fighter needs a place: the second club coach (+1 place, CODE), the bigger unit, or letting one go.

### 3.13 Season targets and fans
- **Season target** (unlocked week 5):

| Fighter | Targets |
|---|---|
| Amateurs | Nationals / Pro offer / Year to grow |
| Pro | Ranked (6-week camp, step-ups) / Busy (4-week Light camp, tune-ups) |
| Grappler | Medal / Blue belt |

  A pro outside the top 10 keeps the day job and may take **Camp leave** ($120 a week, the last 2 camp weeks).
- **Fans** (ESTIMATE):
  - Home win +4, home loss +1, away 0, title +10.
  - They feed TURNPRO1's debut ticket count and the pro's Matchmaking.fans (CODE field).

## 4. The fight week inside the club week

### 4.1 The bout sheet (amateur), with the rules owned by AMATEURWEEK1
| Card | What it gives | Tag |
|---|---|---|
| **Home** (local or the club's own show) | $450 ticket cut; +8 members on a win; +4 fans on a win, +1 on a loss | $450 and +8 CODE; fans ESTIMATE |
| **Name above** (away) | $450; +8 members on a win; −$40 travel; +1 favour; a name up to 3 places above | $450, +8 CODE; rest ESTIMATE |
| **Unknown** (away) | $450; +8 on a win; **7 days' notice instead of 12; +1 favour;** a wide band; a file to open | ESTIMATE |

- **Pass:** "−2 loyalty; this name held 7 days; next sheet in about 2 weeks".
- **States:**
  - Ready: gets sheets.
  - Building: no sheets, ×1.1 training.
  - Rest: 2 weeks after a bout; Need 0, Light mornings, +4 morale.

### 4.2 The scale and the bill (shared with AMATEURWEEK1, answers John 6)
**One rule set: AMATEURWEEK1 owns these numbers.** This map recommends, for its next version:
- **Weigh-in on the day, 1 hour before boxing** (REAL, EB rule book 7.1.3). This is a **code change** from today's day-before weigh-in.
- **Agreed weight ±2 kg at club shows** (REAL, Stevenage ABC club practice), replacing v5's 1.0 kg.
- **One pull-out rate,** probed in SHEETDEAL1 (v5 said 15 in 100, AMATEURWEEK1 v8 35 in 100: one value wins after the probe).

**Over the allowance:**
- Eat less: −1 tank per 0.1 kg.
- Train it off: no gain, +5 tiredness per 0.25 kg.
- Ask a kilo: 1 favour. **The heavier boxer** then boxes with +2 tank per 0.5 kg over, and the lighter gets nothing (WEIGHTGAP1).

**The fight-week bill:** 2 plan lines, the finish move, southpaw rounds, film (2 places), sharpening in the last 3 days. Three shapes: Rest up / Tick over / Train through. One range: "Your week against Coach's: +2 to +4 in 100". Plus the top 3 levers, and tiredness at the first bell.

### 4.3 Pro and amateur side by side (restored, answers John 13)

| | Amateur | Professional |
|---|---|---|
| Notice | bout sheet, 7 or 12 days (AMATEURWEEK1) | 6 weeks (promoter, CODE) |
| Before the bout | fight week only, one-to-one, half volume | camp of 4 or 6 weeks: Light / Standard / Hard nights (CODE) |
| Places | 2 ordinary, 4 in the fight week | camp nights × 2; 4 in TAPER |
| Rounds | 3 × 3 minutes (CODE) | 4 unranked, 6 ranked (CODE) |
| Money to the club | $450 ticket cut (CODE) | 25% of the purse (CODE); camp bill |
| Sparring | yes, not in the fight week | yes, not in TAPER |
| Day job | rota unless sponsored | kept outside the top 10; Camp leave $120 a week |
| Sponsorship | can hold one | can't (stipend ends on signing, CODE) |
| Fans | home bouts build them | sell the tickets (TURNPRO1) |
| Bouts a year | about 9 (ESTIMATE) | about 6 (ESTIMATE) |

Part 4 of 4

## 5. Every decision

| When | Decision | Options and prices | Probe |
|---|---|---|---|
| Create | 1 pro of 2, 2 amateurs of 4 | classes, sparring pairs, fans, ambition | START1 |
| Week 5+ | Season target | per fighter (3.13) | SEASON1 |
| Monday | Deal | Coach deals it (default) / Keep my changes / By hand; drag rows for order | TANKPRICE1 |
| Monday | Coach's evenings | Pads (2 places) or Class (+$117) | MONEYFOUR2, LOYAL1 |
| Monday | Places | Need and Want; Cover a night $80; Borrow 1; Freed places; Hold pads | SHORTWEEK1, LOYAL1, COVER1 |
| Monday | Mornings | Solo (×1.3) or shared (0.8 each) | MORNINGS1 |
| Monday | Sponsorship | give, renew, pass on, let end, stop (−8) | MONEYFOUR2 |
| Monday | Rest week | switch per boxer | LOYAL1 |
| Monday | Pulls, sparring, twist, talk, trial | 3.3, 3.6, 3.9, 3.10, 3.12 | WEAKFIND1, SPARSET1, ROTATWIST1 |
| Any time | Let a fighter go | −block or 1 week's stipend; −5 to team-mates | none: a rare act |
| Sheet | Home / Name above / Unknown / Pass | 4.1 | SHEETDEAL1, FOLLOW1 |
| Fight day | Scale | Eat less / Train it off / Ask a kilo | WEIGHTGAP1 |
| Saturday | The grappler's open, Who corners | Enter or Skip; White or Blue; You or $100 | GRAPPLE1 |

## 6. Every menu it appears on, and what each is wired to (S425; names only in headers)

| Menu | What shows | Wired to |
|---|---|---|
| **Create, step 2** | pro (1 of 2), amateurs (2 of 4), grappler; rota, mornings, sparring reach, fans, ambition | CreateScreen, ClubStart (4 places, NEW), Roster.sign_fighter, Recruit.ambition |
| **The guide, weeks 1–5** | 4 steps; reveal order; road strip at the first 5th amateur win | GuideLight, FirstWeek, NextStep, Roster.pro_ready |
| **Fighters > Club week** (owner OK needed) | counters: BOXING PLACES (Need, Asked, Owned, Short), MAT CLASSES, MORNINGS, SPONSORSHIP, FAVOURS, runway; NEXT WEEK line; Coach's evening magnets (Pads or Class); Cover a night; Borrow; rows draggable for deal order (header name, badge, mood word, loyalty bar with its last cause, rota or sponsorship, pulls, 7 days, sparring pair and setting, rest switch); Freed places; talk card with odds and cooldown; PROMISES OPEN; twist; 3 deal buttons; Start week | ClubDeal (places, 120 units, one-to-one fight week, cover, borrow, freed), DuesLevers.CLASS_WEEKLY, PadWeek, WeekPhase, WeakSpot, JobRota, ClubTwist (18), Favours (regional pool), TrialMat, Loyalty (with causes), SeasonTarget, SparSet, LeverSize, GymSpend (stipend), NoGi.CLASSES_PER_WEEK |
| **Fighter > Week** (renamed from Training) | own cells at the mood rate; shared cells say "Change on the Club week" | WeekBoard, WeekEditors, SparSet |
| **Fighter > Overview** | season target; pulls with who finds the weak spot; mood alone rate; loyalty with its 4-week log; fans; Let go in the row menu | FighterPage, AttrBoard, Attrs, PerkRoad, Loyalty, Fans, SeasonTarget |
| **Fighter > Fight prep** | amateur: fight-week bill, one-to-one sessions, one range; pro: camp nights and places, Camp leave | FightPrep, FightWeek, Camp, CampCard, LeverSize, GymSpend |
| **Grappler page** | mat classes from the no-gi coach (3 or 5), mat morning, open with White or Blue odds, teaching, stripe calls, Enter or Skip, Who corners when it clashes | GrapplerPage, NoGi, BeltRoad.EARLY_DEBT, BjjOpen, StripeCall, Loyalty |
| **Fighters > Find a fighter (trial)** | prospect card, ranges, Watch (2 mornings), Sign or Pass, the 5th-place need | RecruitPanel, Trial, TrialMat, GymSpend.place_blocked |
| **Home** | one row per fighter (name only in the name cell), open pull, days to bout, "Wants a word" note, sponsorship ending, NEXT WEEK shortage note | Home, HomeRows, Needs, Loyalty, ClubDeal |
| **Fighters cards** | badge, loyalty word, sponsorship or job, flag (Fight week, Set camp, Wants a word) | RosterCards, FighterCard, RosterFlag |
| **Fights (amateur)** | bout sheet: Home / Name above / Unknown with the lines in 4.1; Pass text; favour magnets; Ready / Building / Rest; the grappler's open card | Fights, BoutSheet, OfferCard, Favours, Fans, ClubShow, AmateurBooking |
| **Fights (pro)** | promoter's three offers beside the sheets; ticket money from fans | ProFights, ProLadder, Matchmaking.fans |
| **Bout page: the bill** | scale (±2 kg, 3 answers), bill items, tiredness at the first bell, one range, top 3 levers, Take / Coach runs it / Pass | BoutPage, FightWeek, LeverSize, WeighIn, PlanBoard |
| **Tape room** | the next film says what it opens | TapeRoom, OppFile |
| **Playbook > Game plan** | "Bring this line" tick; fight-week places the lines need | GamePlan, PlanBoard, MoveMastery |
| **Club > People** | Coach card (evenings as Pads or Class); second coach "+1 roster place, no evening places"; no-gi coach by the class | StaffCard, CoachAreas, ClubDeal |
| **Club > Money** | class nights; sponsorship as the stipend (−$250 a week, block dates); cover nights; away travel; grappler teaching; pro share 25% or 10%; Camp leave | Money, GymBills, GymSpend, CashForecast, DuesLevers, StarDeal |
| **World > Rankings, Championships** | ladders; nationals as fight weeks | WorldLadder, Region, NationalsView, SeasonTarget |
| **Top bar and Continue** | flags FIGHT WEEK, SET CAMP (pro), PRO OFFER, WANTS A WORD; stops for a pull-out, a 4-day call, the scale, a twist, a sponsorship end | Shell, Needs, Clock |
| **Fight night and the Why** | weigh-in on the day; corner; Why lines ("Tiredness at the first bell: −9 tank", "Short of pads in the fight week"), rank, fans, deal gap | FightNight, WeighIn, CornerTrust, FightWhy, LeverSize |
| **Monday Week review** | shortages with causes and "Give it back"; loyalty moves with causes; the month's deal against Coach's; targets | WeekReview, WeekCause, Loyalty, SeasonTarget |
| **Pro offer** | debut forecast from fans; share 25% or 10% by loyalty (TURNPRO1 owns the rest) | ProOffer, ProDebut, Fans, Loyalty |

## 7. The numbers
- **MEASURED (earlier probes, four amateurs):**
  - 28 bouts a year, 41 wins in 100.
  - Sponsorships over a year: 0 gives +$31k; 4 close 80% of gyms (AMATEURPROBE1, MONEYFOUR1).
  - Good plan 59%, none 45%, bad 41%; +5 stats about 72% (CODE pack). FireLevel on (S450).
- **CODE:** stipend $250; first-hour class +$350; ticket cut $450; win +8 members, +5 reputation; PAD_NIGHT 240 units; camp nights 2+1 / 2+2 / 3+2; TAPER 1 week out; NoGi 3 classes; GYM_SHARE 25%; corner trust bands; rest week +4.
- **ESTIMATE:** place = 120 units; Need 2, Want 1; fight week 4 places at half volume; class night +$117; cover $80; borrow; loyalty moves; mood rates; solo ×1.3; sparring settings; favours 0–5; fans; the six new twist prices; Camp leave; travel $40; Unknown 7 days.
- **Cash for this start (ESTIMATE):**
  - 2 amateurs, about 9 bouts each: about $8,100 a year in ticket cuts.
  - Pro: 25% of purses, about $2,000–3,000.
  - 1 sponsorship: −$13,000 a year.
  - 1 class night every week: +$6,100 a year, plus members.

## 8. Probes (played bouts, 40 seeds × 52 weeks, three seed sets; the UI waits for the tables)
**Cut rule:** any choice worth under 1.5 wins in 100 on a bout AND with no season effect is cut, not drawn.

1. **SHORTWEEK1 + LOYAL1, on the boxing pool** (3 boxers, 8 places, fight week 4):
   - Asked over owned in 9/10+ weeks.
   - A boxer short in 15–35% of weeks.
   - COACH's longest short run 2 or less; COACH's lowest loyalty 50+.
   - STARVE loses exactly 1 fighter a seed; EVEN stays above 60.
   - CLASS (1 class a week) is short in 40%+ of weeks yet gains cash.
2. **TAPER1:** one-to-one, half-volume fight week against v5's +2 Need full volume. Taper wins 1.5+ in 100.
3. **MORNINGS1:** solo-on-the-pull against spread. Each wins in 30–70% of seeds, judged on season target weeks.
4. **COVER1 / BORROW1:** cover chosen in 10–40% of fight weeks; borrow best in under 1 week in 4.
5. **TANKPRICE1:** best week against Coach's 4–6 in 100; no single job over 6.
6. **SEASON1:** a careful player against Coach deals it: pro offer 6+ weeks sooner, or 2+ more wins a year.
7. **ROTATWIST1 (18 cards):** the best deal changes in 3/4+ weeks; no answer best over 2/3.
8. **FOLLOW1:** always-away fails the 60-ticket debut; always-home arrives 6+ weeks later; a mix clears both.
9. **MOODRATE1:** alone rates move 1+ stat point over 4 Flat weeks.
10. **SPARSET1:** Hard beats Technical by 1.5+ in 100 over 6 weeks, with cuts costing 1+ bout in 20.
11. **WEAKFIND1:** with no extra edge, the weak-spot pull still beats a random pull by 1.5+.
12. **SHEETDEAL1 / WEIGHTGAP1:** no card dominates; one pull-out rate set; ±2 kg trips the scale in 5–15% of bouts.
13. **MONEYFOUR2:** 1 sponsorship (−$250) plus 2 class nights stays level over 52 weeks, with stipend-equals-sponsorship.

## 9. Build order
1. Probes 1, 2, 13 first, then the rest. Emit the LeverSize tables.
2. Pure rules, one per task: ClubDeal (120 units, Need and Want, one-to-one, cover, borrow, freed), Loyalty (causes), Favours (regional), ClubTwist (18), WeakSpot (no edge), SparSet, SeasonTarget, Fans, TrialMat, JobRota, LeverSize, stipend as sponsorship.
3. Code changes, listed: weigh-in on the day, 1 hour before (with AMATEURWEEK1); ClubStart 4 places; retire WeekTwist.
4. Start data and the guide.
5. Screens, after owner question 1: Club week, bout sheet, the bill, Overview loyalty log, Money lines, the grappler page.
6. One golden-path test: Create, the 5-week reveal, a class night, a fight week fills the pool, a second fight week makes one short, cover a night, a talk, a twist, a home bout, the scale on the day, the Why, the grappler's open, the pro camp.

## 10. Risks
- **Build size:** 12 rule modules; ships over several milestones, gated on probe 1.
- **Two meters:** mood is shown as a word only and loyalty as a bar only, and every price names which one it moves.
- **Boxing-only places** mean the grappler's week is thinner. The grappler's tension lives in mornings, the sponsorship and the corner, and GRAPPLE1 must show the grappler's choices matter.

## 11. Owner questions (scope, money, taste)
1. **The Club week:** OK it as a tab on Fighters, or make it the Monday page that replaces the week review?
2. **Weigh-in on the day, 1 hour before** (the real rule) is a code change from the day before. Take it?
3. Should a pro outside the top 10 keep the day job, with Camp leave at $120 a week?
4. Starter amateurs at 57 and 75 kg have no pro table yet. Keep them, or limit the starters to 60, 65 and 70?

**CHECK (Claude)**
- The stipend and the sponsorship as one record.
- Which abilities the fight reads, for the weak spot.
- The home lean in close rounds (HOMELEAN1).

## 12. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6.**

**To reach 10/10:**
1. Run probe 1 on the boxing pool and paste the tables.
2. AMATEURWEEK1 adopts the shared bout rules.
3. Owner question 1.
4. Draw the Club week at 1920×1080. Counter strip on top. NEXT WEEK line under it. Coach's evening magnets on the left. Three boxer rows and the grappler's row in the centre, with fight-week magnets drawn double width. Twist, talk and PROMISES OPEN on the right. The deal buttons at the bottom, with gold only on Start week.
5. Probe GRAPPLE1 so the grappler's row carries real choices.
