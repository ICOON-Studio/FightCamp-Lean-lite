# DESIGN_CLUBWEEK1_V8_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ146)

Brief: research/DESIGN_CLUBWEEK1_V8_REVISE_KALLI.md
Sent: 2026-11-15 02:10 | collected: 2026-11-15 02:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing CLUBWEEK1 v8 in full now. It answers all 12 of John's points and all 10 of Maria's.

# CLUBWEEK1 v8: the club week, with the fight weeks inside it (S459, S472, 2026-11-15)

Part 1 of 4

v8 is a full map. It replaces v7 (seat SQ129), and nothing outside this page stands.

**What decides this version:** John's critic (SQ135: depth 6, general design 5, play 6) and Maria's critic (SQ136: depth 7, general design 5, play 6). Both failed v7 on general design.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board and the mockups. The owner's computer is offline, so this map is checked against the critic pack, v7 and the two critics only.

**Owner rules kept, quoted**
- **Q-190 (S434/S435):** "Just rename it 'gym sponsorship', the club pays." It's never mixed up with Sponsor deals on Club > Money.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Rows, buttons, tooltips, notes and Why lines say the 65 kg boxer, a team-mate, the grappler, your coach, the opponent.
- **S412:** "the player runs any gym with any boxers, men or women." No fixed he or she, and never one fighter as the story.
- **S425:** every menu the mechanic appears on, and what each is wired to (section 7).
- **S459:** 6+ DEPTH and 6+ GENERAL DESIGN from fresh critics, ESTIMATEs marked, buildable from what the game has.
- **Pack section 7:**
  - "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
  - One word per concept.
  - Screens only from agreed mockups. The Club week waits for the owner's OK on a drawn page (owner question 1).
- **Pack section 1:** "Deeper, not wider." A quiet week is one click.
- Classes in kg: women 57/60/65/75, men 57.5/60/70/75. Females never fight or spar males.
- "Gym" is the facility. "Camp" means only a pro's pre-bout preparation; an amateur bout has a fight week.

**Marks**
- **CODE:** in the code today, with the file or symbol named.
- **REAL:** real practice, with its source.
- **ESTIMATE:** ours, gated by the section 9 probes. No probe has run on v7 or v8, so every place, loyalty, price and rate below that isn't CODE is ESTIMATE.
- **NEW:** a rule this map adds.
- **v2:** held back until its probe passes.

**One word list**
- **Energy** is fight-night fuel (CODE `BoutNight._energy`, as in WEIGHT1 R4). "Tank" is gone from this map. AMATEURWEEK1 v9 still says "tank" and renames it in its next version.
- **Tiredness** (0–100) is the week's wear (CODE, "Week tiredness"). **Stamina** is the ability.
- **A place** is the coach's pad rounds inside one boxer's evening: about 20 coach minutes, 3 places to a coach's pad hour (NEW, ESTIMATE). It makes that evening count at the **pads rate** (2.1 mastery an hour, CODE).
- **A bag night** is an evening without a place. The boxer still trains the full evening, 240 units over the same drill cards (CODE `PadWeek.PAD_NIGHT_MINUTES`), but at the **heavy-bag rate** (1.05 an hour, CODE). So a bag night is half the mastery.
- **A morning** is a morning session (CODE). A **coached morning** has You or Coach present. **Work** marks a morning lost to a day job (3.6).
- **Coach** is the hired assistant coach. **You** are the head coach.
- **Fight week** is the code's TAPER week (`WeekPhase.phase`).

## 0. Every critic point answered

### 0.1 John (SQ135): To reach 10/10
| # | John's point | v8 |
|---|---|---|
| 1 | Redefine a place as the coach's pad rounds inside the night; without one, bag rate; recount from coach minutes | **Done (3.1).** A place is about 20 coach minutes, 3 to a pad hour. An evening without one is a bag night at 1.05, half the mastery (CODE rates). Owned places are recounted from pad hours: 9 with a sessional coach, 12 with a full-time one. The table is re-run |
| 2 | Close the cover and class money pump | **Done (3.2).** A class pays $117. Cover costs $130, once a week, and is offered only when the counter reads BAG or SHORT. A class plus cover now loses $13 |
| 3 | MONEYFOUR2 around one class night, with loyalty beside cash | **Done (9, probe 7).** One sponsorship plus one class night a week, reporting cash and the lowest loyalty over 52 weeks |
| 4 | Write the job rota as a rule or cut it; one meaning for "mornings" | **Written (3.6).** Without the sponsorship, a boxer loses 2 mornings a week to a day job, marked WORK. "Free mornings" is gone: a coached morning is a coached morning, and WORK is a lost one. Owner question 3 |
| 5 | Write the morning rates against an uncoached morning | **Done (3.5).** Solo coached is +30% over an uncoached morning; shared is +10% each. Both beat training alone, so MORNINGS1 tests two real options |
| 6 | Merge the Protect pin with row order | **Done (3.3).** Drag order sets who's dealt first. The pin becomes **Lock**, which only stops a class, the photo twist or Hold pads taking that boxer's places |
| 7 | Fight week as 3 shorter one-to-one sessions, frequency 80%+, each one slot | **Done (3.4).** 3 sessions of 120 units (360, half volume, 3 of 3 nights). Each takes one place, plus one place for the film and plan night, so a fight week takes 4. That 1 extra is the coach-time cost |
| 8 | Say what loyalty is in code; keep morale separate; move the loop break | **Done (3.7).** Loyalty is the code's Loyalty trait (pack 3) shown as a bar. Morale stays the fight's trust meter. The Low-morale loop break moves to a morale map (MOOD). Leaving is its own one-line rule (owner question 4) |
| 9 | Write all twist answers with prices; the code's clock rule | **Done (3.9), the Maria way.** The code's WeekTwist deck stays. The 7 cards that touch the club's evenings are reworded with 2 priced answers each. No answer means Coach's pick on Monday (CODE). The "clock waits" line is cut |
| 10 | Fix the fourth start's pro (70 kg has no table) | **Moved out (2).** The fourth start goes to its own map, START2, carrying John's fix: the men's pro becomes a 66 kg welterweight |
| 11 | A reward line when a squeeze passes, and an upside Why line | **Done (3.8, 7).** Week review: "Two fight weeks, nobody short: +2 loyalty each". Why: "Full fight week: three one-to-one sessions" |
| 12 | Run probes 1–3 under the new unit, then settle the CHECKs | **Ordered first (10)** under the new unit. The CHECKs are in 11 |

### 0.2 John's missing options
| Option | v8 |
|---|---|
| One cover a week, tied to SHORT | Done (3.2): once a week, only at BAG or SHORT |
| "Bag night" printed on the row | Done: night magnets print PADS or BAG, and the class magnet names the weight class that goes to bag |
| A review line for a squeeze handled | Done (3.8) |
| Fight week as 3 short sessions | Done (3.4) |

### 0.3 Maria (SQ136): To reach 10/10
| # | Maria's point | v8 |
|---|---|---|
| 1 | One owner for the coach's week | **CLUBWEEK1 owns it, in places,** as Maria recommends. COACHFIT1 reads who holds each place for its fit and bond, and converts its budget at 3 places per pad hour. CHECK (Claude, with COACHFIT1's next version) that its sessional 8 / full-time 12 maps onto 2 and 3 pad hours |
| 2 | Energy, not Tank | Done (word list) |
| 3 | Ask the owner about the training cut | **Asked (owner question 2), and the default no longer cuts.** With a sessional coach and 3 boxers, an ordinary week is FULL: 9 places for 9 asked, everyone at the code's full pads volume. Bag nights come only from choices: a class, two fight weeks, a fourth boxer, a twist |
| 4 | Settle the coach's evenings and the second class first | CHECKs 1 and 2, run before any probe (10) |
| 5 | Mark the 10% pro share and leaving as GAME VALUE; owner question | **Done (owner question 4).** Without a yes, the pro share stays 25% (CODE) and a boxer under 25 loyalty only takes morale −4 each Monday (ESTIMATE). Nobody leaves |
| 6 | Take the fourth start out | Done: START2 |
| 7 | Keep WeekTwist and reword it | Done (3.9) |
| 8 | A pads volunteer as the lasting fix | **Done (3.2).** A staff job at $120 a week: +3 places every week, drilled at 0.8 of the pads rate (ESTIMATE). Hiring a full-time coach is the other lasting fix, at 12 places |
| 9 | "Ask for a later date" at Accept | **Done (4.1)** where a collision shows, reading the code's later-date path for weight. CHECK (Claude) that it can be reused |
| 10 | Make loyalty bite | **Done (3.7).** Need met gives 0 (was +1), Want met +1, short −5 (was −3), short again −8 (was −6). LOYAL1 must show the talk turning up 2–4 times a season, or the numbers move again |

### 0.4 Maria's missing and weak options
| Option | v8 |
|---|---|
| Pads volunteer | Done (3.2) |
| A session moved to a morning | **Done (3.5).** A coached morning can become one place for one boxer at 0.8 of the pads rate. It costs that coached morning |
| A later date at a collision | Done (4.1) |
| The season cost of a class printed | Done: "+$117: three evenings go to bag this week" with the weight classes named, and "a class every week: 3 bag nights a week" on hover |
| Borrow a place (rarely right) | **Cut.** Cover, the volunteer and a later date do its job without a debt to track |
| By hand (expected to be cut) | **Cut as a mode.** Moving a night magnet between rows stays as plain editing, and DEALPRICE1 only checks whether editing is worth teaching |
| Pass on the sponsorship (free) | **Fixed:** the giver now loses 3 (it was taken away), the receiver gains 5 |
| Tell it straight (a coin flip) | **Given a real trade (3.7).** Give the place back costs a team-mate a place next week. Tell it straight costs no place, and holds for +6 against −4 |

### 0.5 John's options table, the ones not kept as they were
| Option | v8 |
|---|---|
| Protect pin | becomes Lock (point 6) |
| Cover $80 | $130, once a week, at BAG or SHORT only |
| Solo or shared morning | rewritten against an uncoached morning |
| Club twist (12) | the code deck, 7 cards reworded with answers |
| Fourth start | START2 |

Part 2 of 4

## 1. The idea in five lines
1. **The Club week is the Monday deal of the club's scarce things:** the coach's **places**, the **coached mornings**, the **gym sponsorship**, and **your one talk**.
2. **A pad hour can be sold as a class.** That's the money lever. Its price is printed in bag nights, by weight class.
3. **Bouts sit on the same board.** A fight week takes 4 places. Two fight weeks together, or a fight week on a class week, is where boxers go SHORT, and the bout page says so before Accept.
4. **What lasts past the week is loyalty,** the code's trait shown as a bar, and every move prints its cause.
5. **The NEXT WEEK line** shows a collision two weeks out. A quiet week is one click.

## 2. When it appears (the starts unchanged)
- **The game's three starts stay exactly as they are (CODE):** Fresh doors, In debt and Backed.
- **With one fighter,** the fighter's Week tab works as today, and that fighter is dealt every place they ask for.
- **When a second fighter signs, the Club week tab appears on Fighters (NEW).** One guide line, "Two fighters now share the coach's pad hours", and a Home note open it.
- **The fourth start** ("Take over a club") moves to its own map, START2. It carries John's pro fix (a men's 66 kg welterweight, inside the code's table) and Maria's roster question. This map doesn't need it.

## 3. The week, as the player meets it

### 3.1 Places, recounted from coach minutes (answers John 1, Maria 1 and 3)
**What a place is**
- Coach's pad rounds for one boxer in one evening: about 3 rounds plus wraps and notes, about 20 coach minutes (ESTIMATE; CHECK John: pad rounds per boxer on a real club night).
- With a place, the boxer's evening counts at the pads rate, 2.1 an hour (CODE).
- Without one it's a **bag night**: the same evening, the same 240 units and the same drill cards, at 1.05 an hour (CODE). Half the mastery, and the boxer still trained.

**Where the places come from**

| Who | Pad hours a week | Places |
|---|---|---|
| Sessional coach | 2 (ESTIMATE; CHECK Claude) | 6 |
| Full-time coach | 3 (ESTIMATE; CHECK Claude) | 9 |
| You | 1 | 3 |
| **Owned, sessional / full-time** | | **9 / 12** |

- The code's evening members' class (+$350 a week, CODE) is separate from the pad hours and never changes.
- With no coach, only your 3 places exist, and training already runs at 60% (CODE).

**Need and Want**
- **Want 3** places a week, one per evening: the code's standard 3 pad nights at full pads volume.
- **Need 2.**
- **In a fight week,** Need and Want are both 4 (3.4).
- A boxer gets at most Want.

**The counter's words**
| Word | Meaning | Cost |
|---|---|---|
| OK | spare places | none |
| FULL | every Want met | none |
| BAG n | Want unmet: n bag nights this week, every Need met | the mastery only |
| SHORT n | n places under Need | the mastery plus loyalty (3.7) |

Colour repeats the word and is never the only signal.

**The shortage table, sessional coach (owned 9)**
| Week | Asked | Need | Word |
|---|---|---|---|
| Ordinary, 3 boxers | 9 | 6 | **FULL**: today's volume, no cut |
| One amateur fight week | 4 + 3 + 3 = 10 | 8 | BAG 1 |
| Two fight weeks together | 4 + 4 + 3 = 11 | 10 | BAG 2 |
| A class sold, ordinary (owned 6) | 9 | 6 | BAG 3 |
| A class sold plus one fight week | 10 | 8 | **SHORT 2** |
| A class sold plus two fight weeks | 11 | 10 | **SHORT 4** |
| 4 boxers (a bigger unit, CODE roster) | 12 | 8 | BAG 3; a full-time coach makes it FULL |
| Pro camp, BUILD or PEAK | the camp's pad nights: Light 2, Standard 2, Hard 3 (CODE 2+1 / 2+2 / 3+2). Sparring nights take no places | | read per week |
| Pro fight week | 4 | 4 | as the amateur one |

With a full-time coach (owned 12), every row moves up 3. Only stacked choices go SHORT. All values ESTIMATE.

**Steps:** a step in the study slot rises only on nights with a place. 3 places give about 6 a week (CODE S463); 2 give about 4 (ESTIMATE). CHECK (Claude) that StepMastery can read places.

**Freed places,** from a rest week, a pull-out or a bout ending, print on the counter: "Freed 3: give to [row] / [row], or sell as a class +$117". The default follows deal order.

### 3.2 The money lever and its valves (answers John 2, Maria 8)
| Lever | What it does | Price | Tag |
|---|---|---|---|
| **CLASS** (flip a pad hour; yours too) | the hour runs a second members' class | +$117 that night, about 1 new member in 4 weeks taught; 3 places gone, the boxers named on the magnet ("+$117: 60 and 75 kg boxers go to bag Thursday") | ESTIMATE; CHECK Claude: a second class an evening in DuesLevers |
| **Cover a night** | a sessional cover coach takes one pad hour | $130, +3 places at the full rate; once a week, offered only at BAG or SHORT | ESTIMATE |
| **Pads volunteer** (staff job, Club > People) | a club volunteer holds pads every week | $120 a week, +3 places drilled at 0.8 of the pads rate | ESTIMATE |
| **Hire full-time** | Coach's pad hours go from 2 to 3 | the code's full-time wage (CODE $1,090 against $450) | places ESTIMATE |
| **Rest week** (row switch) | Need and Want 0 | +4 morale (CODE rest week) | CODE |

**Why the pump is shut:**
- A class plus cover nets −$13.
- A class plus the volunteer nets −$3 a week, and the volunteer's places are worth less.
- Classes earn only by leaving boxers on bag.
- The **second club coach** ($280, CODE) adds no places, because its hours are fitness classes in the code. Its card says so.

### 3.3 The deal (answers John 6, Maria's "By hand")
- **Coach deals it** is the default and one click. It deals Want in **row order**: drag a row up and it's dealt earlier, and the order is kept week to week.
- **Lock (NEW, one row at most):** a class, the photo twist (3.9) and Hold pads can't take that boxer's places. Its price prints before Start week: "Lock the 65 kg boxer: the class takes the 60 kg boxer's Thursday instead."
- **Editing:** drag a night magnet from one row to another. **Back to Coach's deal** undoes it.
- **Pulls, printed as words:** warnings first (SCALE inside 14 days, FIGHT WEEK, REST at tiredness 70+ or hurt), then at most two labelled stickies:
  - **WEAK SPOT:** the lowest ability the fight reads, 3+ under the fighter's level, with who finds it ("Low Defence: pressure fighters find it"). CHECK (Claude) which abilities the fight reads.
  - **WEAPON:** the ability gating the next perk ("Fast hands at Speed 70: about 4 weeks").
  - **GOAL:** the active goal (CODE).
  - **AHEAD:** the next rival up the regional table, and the answers owned.

  A pull asks for 2 coached mornings, or AHEAD asks for its place first.
- **A quiet week:** when nothing differs from last week (no fight week, no BAG or SHORT, no talk, no twist due), the page shows only the counters and the rows, and the button reads "Coach deals it: same as last week". Press it, then Continue.

### 3.4 The fight week: 3 one-to-one sessions (answers John 7)
- **When:** the 7 days before any booked bout (CODE TAPER, `WeekPhase.phase`), amateur or pro.
- **Sessions:** 3 one-to-one sessions of 120 units each, 360 for the week. That's half the standard 720 at full frequency (3 of 3 nights). Each session is about 40 minutes of the boxer's work with 20 of Coach's on the pads (ESTIMATE).
- **Places:** each session takes one place, and the film and plan night takes one more: **4 places**. That extra place is the coach-time cost of a bout.
- **Real taper (REAL, Bosquet et al. 2007, meta-analysis of 27 studies):** cut volume 41–60%, keep intensity and frequency; frequency 80%+ of pre-taper.
- **Load stops and sparring belong to AMATEURWEEK1 v9** (Rest up / Tick over / Train through, and fight-week sparring at its price).
  - Rest up drops to 2 sessions (3 places).
  - Sparring nights take no places.
- **The row prints:** "Fight week: 3 one-to-one sessions, half volume".

### 3.5 Coached mornings (answers John 5, Maria's morning session)
**Owned:** 6 a week, You 4 and Coach 2 (ESTIMATE; COACHFIT1 reads these).

**Rates against an uncoached morning (CODE rate × coach factor):**

| Use | Rate | Tag |
|---|---|---|
| Uncoached | 1.0 (CODE) | CODE |
| Solo coached | 1.3, without Hard's extra tiredness | ESTIMATE |
| Shared coached, two fighters | 1.1 each | ESTIMATE |
| Pads in the morning | one place for one boxer at 0.8 of the pads rate, using up that coached morning | ESTIMATE |

**What 6 coached mornings give:**
- all solo: +1.8 morning-equivalents on one or two pulls;
- all shared: +1.2 spread over up to 12 sessions.

MORNINGS1 requires each to win in 30–70% of seeds.

### 3.6 The gym sponsorship and the day job (answers John 4)
**The sponsorship is the stipend** (CODE, $250 a week, Club > Money > STIPENDS):
- Shown and billed as the gym sponsorship in 4-week blocks of $1,000.
- Who can hold one: amateurs and the grappler. A pro can't, because the stipend stops on signing (CODE).

**The day job (NEW, ESTIMATE; owner question 3)**
- **A boxer without the sponsorship** works a day job: 2 mornings a week (Tue and Thu) are marked WORK on the Week tab and train nothing.
- **A grappler without it** misses 1 mat class in 3 (NoGi classes, CODE count).
- **A pro** has no day job.
- **With the sponsorship,** every morning trains.

**Block choices and loyalty**
- Give: loyalty +5.
- Renew: −$1,000, loyalty +2.
- Pass on: the receiver +5, the giver −3.
- Let end: 0.
- Stop mid-block: −8.

CHECK (Claude) that the stipend and the sponsorship are one record.

**The grappler's row** on the Club week holds two things only:
- **SPONSORSHIP:** held or not.
- **SATURDAY CORNER:** shown only when a boxer and the grappler compete the same Saturday. Pick You, or a $100 mat coach (ESTIMATE).

Everything else stays on the grappler page (CODE). GRAPPLE1 gates more (v2).

Part 3 of 4

### 3.7 Loyalty: the code's trait, shown as a bar (answers John 8, Maria 5 and 10)
**What it is:** the code's Loyalty trait (pack 3: it exists but isn't on the board), shown 0–100 as a bar on the row and on Overview.

**What it isn't:** morale stays the fight's meter (CODE: win +8, loss −12, and so on; trust in the corner 1.05 / 1.0 / 0.85 / 0.7). Loyalty never touches the corner.

**Bands:** Loyal 70+, Settled 50+, Wavering 25+, Leaving under 25.

**Moves (NEW, ESTIMATE except where marked)**
| Cause | Loyalty |
|---|---|
| Want met | +1 |
| Need met only | 0 |
| Short (under Need) | −5; short again next week −8; 1 short week in 4 waived at Loyal 70+ |
| A squeeze passed, nobody short (3.8) | +2 each |
| Promise kept / broken | +5 / −12 |
| Sponsorship given / renewed / passed away / stopped | +5 / +2 / −3 / −8 |
| Holding pads | +3 a week, 4 weeks at most |
| Stripe call now / hold | as StripeCall (CODE) |
| A team-mate let go | −5 |
| The talk | below |

**Every move prints its cause:** "−5: short of a place this week". Overview keeps a 4-week log, and the week review shows the week's moves.

**Hold pads (Loyal 70+, 6+ bouts):** the holder gives one of their places to a team-mate. The team-mate's night counts at 0.7 of the pads rate, the holder isn't counted short, and the holder gets +3 a week. ESTIMATE.

**The talk** (loyalty under 50, flag "Wants a word")
- **Limits:** one talk a week for the club. It costs your Monday, not a place. Each fighter at most once in 4 weeks.
- **The three answers:**
  1. **Give the place back:** dealt first next week, +4. The card names the boxer who drops a place next week.
  2. **A dated promise** (a place, a bout, the sponsorship): +5 kept, −12 broken, listed under PROMISES OPEN.
  3. **Tell it straight:** costs no place. It holds on the visible Coachability, printed on the button ("holds: 60 in 100"): +6 if it holds, −4 if not, then an 8-week wait.

**Under 25** (owner question 4)
- **If the owner says yes:** after 2 talks the fighter leaves the next Monday (one line, NEW). A fighter turning pro under 50 signs with an outside manager, and the club's share is 10%, the code's 25% minus its 15% manager part (GYM_SHARE, CODE).
- **Without a yes:** nobody leaves, the share stays 25%, and the fighter takes morale −4 each Monday under 25 (ESTIMATE).

**Moved out:** the Low-morale loop break (no −6 for a month without a fight while Low) goes to a morale map, MOOD.

### 3.8 The NEXT WEEK line and the reward line
**The NEXT WEEK line** sits under the counters. It reads booked bouts, camps and class nights, and shows only when the next two weeks differ from this one:
- "NEXT WEEK: fight week for the 65 kg boxer; Asked 10 of 9, BAG 1. A class leaves 2 SHORT."
- "IN 2 WEEKS: two fight weeks; BAG 2. Cover a night, or ask for a later date."

**The reward (answers John 11):** when a week with a fight week or a class ends with nobody short, the Monday review prints "Two fight weeks, nobody short: +2 loyalty each". The Why gets the upside line too: "Full fight week: three one-to-one sessions".

### 3.9 Twists: the code's deck, reworded (answers John 9, Maria 7)
- **The code's WeekTwist deck stays,** one card a week.
- **No answer means Coach's pick on Monday (CODE).**
- **With 2+ fighters,** the 7 cards that touch the evenings are reworded for the club, each with 2 priced answers (prices ESTIMATE unless marked).
- The other cards (sore wrist, rain, weights room shut, head cold, quiet week, tight knee, scale won't move, combo clicking, rival talks trash) stay per fighter, as today.

| Card | Answer 1 | Answer 2 |
|---|---|---|
| Heating breaks | Fix it today: −$180 | Run cold: one pad hour lost, 3 places |
| Night off (a boxer asks) | Give it: +4 morale (CODE), 1 place freed | Refuse: −4 morale (CODE) |
| Partner ill | Pads instead: the sparring night becomes a pad night and needs a place | Outside partner: $160 (CODE camp fee) |
| Southpaw in town | Book the southpaw: $40, one boxer's place becomes southpaw rounds (lifts the round-1 penalty, as the CODE camp rule) | Pass |
| Old coach visits | Let them hold pads: +3 places one night, free | Thank them: nothing |
| Sponsor photoshoot | Do it: +$150, one boxer loses one place (never a Locked one) | Decline |
| Visiting pro | Spars one boxer: one sparring night at "above" level, injury ×1.15 (AMATEURWEEK1 rule) | Rent them the gym: +$60 |

The 6 new cards from v7 are v2, behind ROTATWIST1.

### 3.10 Let a fighter go
- **Where:** the row menu.
- **Price:** the rest of the sponsorship block or 1 week's stipend, and −5 loyalty to each team-mate. The roster place frees now.
- **Confirm:** a second press, never pre-selected. ESTIMATE.

## 4. The fight week inside the club week

### 4.1 The offer, the collision line and a later date (answers Maria 9)
**The offer stays as the code has it:** one at a time, Accept or Pass, both free (CODE, pack 4.5). The bout sheet's cards and rules belong to AMATEURWEEK1 v9 and LADDER1.

**The collision line (NEW), above Accept:**
- It appears only when dates collide, reading ClubDeal's forecast.
- It names the weight class, never a name. Examples:
  - "This fight week lands on the 60 kg boxer's: BAG 2."
  - "This fight week lands on a class week: SHORT 2. Flip the class to pads, cover a night ($130), or ask for a later date."

**Ask for a later date (NEW button, only beside a collision line):**
- It asks the host for the next show, 2 weeks later.
- The host agrees about 1 time in 2 (ESTIMATE). The answer comes with Monday's need, and the offer stays open until then.
- It reads the code's later-date path for a boxer over the class. CHECK (Claude) that it can be reused.

### 4.2 Pro and amateur side by side
| | Amateur | Professional |
|---|---|---|
| Notice | an offer by its date (CODE) | promoter's offers, standing 7 days (CODE) |
| Before the bout | fight week only, 4 places | camp of 4 or 6 weeks, Light / Standard / Hard pad nights 2 / 2 / 3 (CODE), then the fight week, 4 places |
| Rounds | 3 × 3 minutes (CODE) | 4 unranked, 6 ranked (CODE) |
| Money to the club | $450 ticket cut (CODE) | 25% of the purse (CODE) |
| Sponsorship | can hold one | can't (CODE) |
| Day job | yes, without the sponsorship | none |

## 5. Every decision
| When | Decision | Options and prices | Probe |
|---|---|---|---|
| Monday | Deal | Coach deals it (default) / drag row order / Lock one row / edit magnets / Back to Coach's deal | DEALPRICE1, LOCK1 |
| Monday | Each pad hour | PADS (3 places) or CLASS (+$117) | MONEYFOUR2 |
| Monday | Valves | Cover $130 (once, at BAG or SHORT); rest week; freed places; Hold pads | COVER1, SHORTWEEK1 |
| Monday | Coached mornings | Solo 1.3 / shared 1.1 each / pads in the morning | MORNINGS1 |
| Monday | Sponsorship | give, renew, pass on, let end, stop | MONEYFOUR2 |
| Monday | Talk | place back / promise / straight | LOYAL1 |
| Monday | Twist | 2 priced answers | ROTATWIST1 |
| Offer | Accept (collision line) / Ask for a later date / Pass | 4.1 | LATER1 |
| Club > People | Pads volunteer $120 a week; full-time coach | 3.2 | COVER1 |
| Fight week | Load stops | AMATEURWEEK1 v9 | its probes |
| Saturday | Who corners a clash | You / $100 mat coach | none: rare |
| Any time | Let a fighter go | 3.10 | none: rare |

Part 4 of 4

## 6. The numbers
**MEASURED (earlier probes, four amateurs):**
- 28 bouts a year, 41 wins in 100.
- No sponsorship gives +$31k over a year; 4 sponsorships close 80% of gyms (AMATEURPROBE1, MONEYFOUR1).
- Plans: good 59%, none 45%, bad 41%; +5 stats is about 72% (pack). FireLevel is on (S450).

**CODE:**
- Pads 2.1 an hour, heavy bag 1.05.
- PAD_NIGHT 240 units; the standard week is 3 pad nights.
- Stipend $250; members' evening class +$350.
- Ticket cut $450; full-time coach $1,090 against sessional $450; second club coach $280.
- Camp pad nights 2+1 / 2+2 / 3+2; TAPER 1 week out; outside partner $160.
- Rest week and night off: morale +4; refused night off −4.
- GYM_SHARE 25% (manager 15% + trainer 10%); the Loyalty trait; StripeCall; NoGi class count.

**REAL:** taper volume −41–60% with frequency kept at 80%+ (Bosquet et al. 2007).

**ESTIMATE:**
- 20 coach minutes a place; pad hours 2 / 3 / 1.
- Need 2, Want 3; fight week 4 places at 120 units a session.
- Class +$117; cover $130; volunteer $120 at 0.8.
- Solo 1.3, shared 1.1, morning pads 0.8; Hold pads 0.7.
- Every loyalty move; the day job's 2 mornings.
- Mat coach $100; later date 1 in 2; twist prices.
- Steps at 2 places.

**Cash, sessional coach, 3 boxers, a year (ESTIMATE):**
- A class every week: +$6,100, plus members, and 3 bag nights every week.
- 1 sponsorship: −$13,000, giving 2 mornings a week back and loyalty.
- Cover in each fight week (about 28 a year with 3 or 4 boxers): up to −$3,600.

## 7. Every menu it appears on, and what each is wired to (S425; names only in headers)
| Menu | What shows | Wired to |
|---|---|---|
| **The guide** | one line when the second fighter signs | GuideLight, Roster.sign_fighter |
| **Fighters > Club week** (appears with 2+ fighters; owner OK needed) | counters with words (PLACES Asked / Need / Owned with OK / FULL / BAG n / SHORT n; COACHED MORNINGS; SPONSORSHIP; runway); NEXT WEEK line; pad-hour magnets PADS / CLASS with the weight classes that go to bag; Cover (only at BAG or SHORT); rows (name once in the header cell, morale word, loyalty bar with its last cause, sponsorship or WORK, pulls as labelled stickies, night magnets PADS / BAG / FIGHT WEEK, rest switch, Lock); grappler row (sponsorship, corner clash); freed places; talk card; PROMISES OPEN; twist; Coach deals it / Back to Coach's deal; Start week | ClubDeal (places, Need and Want, fight week, cover, freed, lock, forecast), DuesLevers (second class), PadWeek (rates), WeekPhase, WeakSpot, Loyalty, WeekTwist (club wording), LeverSize, GymSpend (stipend), DayJob (NEW) |
| **Fighter > Week** | own cells as today; shared cells say "Change on the Club week"; PADS or BAG on each evening; WORK on day-job mornings | WeekBoard, WeekEditors, ClubDeal, DayJob |
| **Fighter > Overview** | pulls with labels; loyalty bar with its 4-week log; Let go in the row menu | FighterPage, AttrBoard, Attrs, PerkRoad, Loyalty |
| **Fighter > Fight prep** | amateur: the fight week's 3 sessions and its places; pro: camp pad nights as places | FightPrep, FightWeek, Camp, ClubDeal |
| **Grappler page** | unchanged; sponsorship line; missed class on WORK | GrapplerPage, NoGi, StripeCall, Loyalty, DayJob |
| **Home** | one row per fighter; "Wants a word"; sponsorship ending; NEXT WEEK SHORT note; later-date answer; Club week note when the second fighter signs | Home, HomeRows, Needs, Loyalty, ClubDeal, BoutSheet |
| **Fighters cards** | loyalty word, sponsorship or WORK, flag (Fight week, Set camp, Wants a word) | RosterCards, FighterCard, RosterFlag |
| **Fights, bout page / versus screen** | the collision line above Accept; Ask for a later date | BoutPage, OfferCard, ClubDeal.forecast, the later-date path (CHECK) |
| **Fights (pro)** | the promoter's offers as today, with the collision line | ProFights, ClubDeal.forecast |
| **Club > People** | Coach card with pad hours (2 or 3) and PADS / CLASS; pads volunteer staff job ($120, +3 places at 0.8); second club coach "+1 roster place, no places"; no-gi coach | StaffCard, CoachAreas, StaffJobs, ClubDeal |
| **Club > Money** | class nights beside the +$350; sponsorship as the stipend with block dates; cover nights; volunteer | Money, GymBills, GymSpend, CashForecast, DuesLevers |
| **Top bar and Continue** | flags FIGHT WEEK, SET CAMP, WANTS A WORD; stops once for a SHORT week, a twist answer and a sponsorship end | Shell, Needs, Clock |
| **Fight night and the Why** | "Short of pads in the fight week" and the upside "Full fight week: three one-to-one sessions" | FightWhy, LeverSize |
| **Monday week review** | bag nights and shortages with causes; loyalty moves with causes; the reward line | WeekReview, WeekCause, Loyalty |
| **Pro offer** | the share, 25%, or 10% only if the owner says yes (owner question 4) | ProOffer, Loyalty |

## 8. Held for v2, each gated on its probe passing the cut rule
| Held | Probe |
|---|---|
| Favours, one regional pool with AMATEURWEEK1 | SHEETDEAL1 |
| Fans and home against away | LADDER1 |
| Trial mat every 4 weeks | TRIAL1 |
| Six new twist cards | ROTATWIST1 |
| Sparring settings (Body only stays cut) | SPARSET1 |
| Mood-only rates | MOODRATE1 |
| The grappler in the deal | GRAPPLE1 |
| The fourth start | START2 (its own map) |

## 9. Probes (played bouts, 40 seeds × 52 weeks, three seed sets; no screen before its table)
**Cut rule:** a choice worth under 1.5 wins in 100 on a bout, with no season effect, is cut, not drawn.

1. **SHORTWEEK1 + LOYAL1** (3 boxers, sessional, owned 9):
   - BAG in 25–50% of weeks; SHORT in 5–20%.
   - Coach's deal's longest short run is 2 or fewer weeks.
   - The talk turns up 2–4 times a season per club.
   - Starving one row loses exactly one fighter a seed if owner question 4 is yes.
2. **DEALPRICE1 + LOCK1:**
   - Edited deals against Coach's: under 4 in 100 means editing stays but isn't taught.
   - Lock against no lock in class weeks: 1.5+ in 100 for the locked boxer.
3. **VOLUME1:** mastery paces and the 59/45/41 plan numbers at 1, 2 and 3 bag nights a week. If one bag night a week moves the plan numbers by more than 2, the class pays more or the volunteer gets cheaper.
4. **TAPER1:** 3 sessions at 360 units against a full-volume fight week; the taper wins by 1.5+ in 100.
5. **MORNINGS1:** solo 1.3 against shared 1.1 against morning pads; each best in 30–70% of seeds.
6. **COVER1:** cover chosen in 10–40% of fight weeks; the volunteer pays back within 26 weeks in at least 1 seed set in 2.
7. **MONEYFOUR2:** 1 sponsorship plus 1 class night a week stays cash-level over 52 weeks, reporting the lowest loyalty beside cash, which must stay 40+ under Coach's deal.
8. **LATER1:** a later date beats Accept-and-cover in 25–60% of collisions.
9. **ROTATWIST1 (the 7 reworded cards):** no answer best more than 2 times in 3.

## 10. Build order (5 rule modules, down from 7)
1. **CHECKs 1 and 2 first** (pad hours, a second class), then probes 1–3 under the new place unit, emitting the LeverSize tables.
2. **Pure rules, one per task:**
   - ClubDeal (places, Need and Want, fight week, cover, lock, freed, forecast)
   - Loyalty (bar, causes, talk)
   - WeakSpot
   - LeverSize
   - DayJob with the stipend as the sponsorship
3. **Code changes:** a second class an evening (DuesLevers), the club wording for 7 WeekTwist cards, the pads volunteer in StaffJobs, the later-date path at a collision.
4. **Screens, after owner question 1 and the drawn page:** the Club week, the collision line and later-date button, the Overview loyalty log, the Money lines.
5. **One golden-path test:**
   1. Fresh doors; the second fighter signs, and the Club week appears.
   2. A class is sold, and BAG 3 shows.
   3. A fight week.
   4. A collision line at Accept, then Ask for a later date.
   5. A class plus a fight week leaves a boxer SHORT 2.
   6. Cover a night.
   7. A talk.
   8. A reworded twist.
   9. The reward line, then the Why line.

## 11. Owner questions and CHECKs
**Owner questions**
1. **The Club week:** OK it as a tab on Fighters? Asked with the drawn page from section 12.
2. **Bag nights:** an ordinary week keeps today's full pads volume, but a class, two fight weeks, a fourth boxer or a twist can put a boxer on bag nights (half the mastery that night). Yes?
3. **The day job:** a boxer without the gym sponsorship loses 2 mornings a week to work. Yes, or does the sponsorship give loyalty only?
4. **Leaving and the pro share:** a fighter under 25 loyalty after 2 talks leaves, and turning pro under 50 drops the club's share to 10%. Yes, or morale only?

**CHECK (Claude)**
1. The coach's pad hours in code (sessional 2, full-time 3).
2. A second class an evening in DuesLevers.
3. The stipend and the sponsorship as one record.
4. StepMastery counting only nights with a place.
5. Which abilities the fight reads, for WEAK SPOT.
6. The later-date path reused at a collision.
7. With COACHFIT1: its budget read as 3 places a pad hour.

**CHECK (John):** pad rounds per boxer on a real club night, and the 20-minute place.

## 12. The page for the owner (1920×1080, Look B whiteboard; drawn in the next board session)
- **Dark top bar:** CONTINUE reads "to Mon 9 Feb, the week review".
- **Top strip (0–120):** counter magnets, each a word and numbers: PLACES "Asked 10 · Need 8 · Owned 9 · BAG 1", COACHED MORNINGS "Solo 4 · Shared 2", SPONSORSHIP "1 of 1 · block ends 2 Mar", RUNWAY "11 weeks".
- **Under it (120–180), in red marker, only when it matters:** "IN 2 WEEKS: two fight weeks, BAG 2. Cover a night or ask for a later date."
- **Left (40–440), PAD HOURS:**
  - three magnets (Tue and Thu for Coach, Fri for You), each flipping PADS ("3 boxers on pads") and CLASS ("+$117: 60 and 75 kg boxers go to bag");
  - COVER ($130, "only at BAG or SHORT, once a week");
  - a note pointing to the volunteer on Club > People.
- **Centre (480–1480), THE SQUAD:**
  - one row per boxer, the name once in its header cell, with the weight class;
  - the morale word;
  - the loyalty bar, its last cause in marker ("+1: full week");
  - up to two stickies (WEAK SPOT, WEAPON, GOAL, AHEAD);
  - night magnets, solid PADS, hatched BAG, three small FIGHT WEEK session magnets;
  - WORK on day-job mornings;
  - the rest switch and the Lock;
  - drag to reorder;
  - the grappler's row last, with the sponsorship and the corner clash only.
- **Right (1520–1880):** the twist with 2 priced answers, the talk card with its odds, PROMISES OPEN with dates.
- **Bottom (980–1060):** Coach deals it ("same as last week" when quiet), Back to Coach's deal, and Start week in gold. Green appears only on Continue.
- **Stress state on the same page:** a class on Thursday plus a fight week. PLACES reads SHORT 2, one row shows two BAG nights, and the class magnet names the weight classes that pay for it.

## 13. Risks
- **Coach's deal may still dominate.** That's accepted. The choices that bite are the class, cover, the volunteer, a later date, the sponsorship and the talk, not the deal itself.
- **The day job and leaving need the owner (questions 3 and 4).** Without them, the sponsorship is loyalty only and loyalty only moves morale. The map still runs, with less depth.
- **The place maths rests on CHECK 1.** If the code has no pad-hour count, 9 and 12 are design values the code must adopt.

## 14. Self-score: DEPTH 7, GENERAL DESIGN 7, PLAY 7 (mine, not a critic's)
**To reach 10/10**
1. Settle CHECKs 1 and 2, then run probes 1–3 under the new place unit and paste the tables.
2. Draw section 12 at 1920×1080 and get owner questions 1–4 answered on it.
3. Align with COACHFIT1 so both maps read one place count (CHECK 7).
4. Tune loyalty from LOYAL1 until the talk turns up 2–4 times a season.
5. Bring back v2 items only as their probes pass, GRAPPLE1 first, so the grappler's row carries real choices.
