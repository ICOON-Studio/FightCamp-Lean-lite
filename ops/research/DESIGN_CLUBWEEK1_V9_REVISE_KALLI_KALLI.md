# DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ159)

Brief: research/DESIGN_CLUBWEEK1_V9_REVISE_KALLI.md
Sent: 2026-11-15 06:10 | collected: 2026-11-15 06:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing CLUBWEEK1 v9 in full now. It answers all 12 of John's points and all 10 of Maria's.

# CLUBWEEK1 v9: the club week, with the fight weeks inside it (S459, S472, 2026-11-15)

Part 1 of 4

This is a full map. It replaces v8 (seat SQ146), and nothing outside this page stands.

**What decides this version:** John's critic (SQ157: depth 6, general design 5, play 6) and Maria's critic (SQ158: depth 7, general design 6, play 6). John failed v8 on general design.

**The big changes:**
- "Place" is renamed **pad turn**.
- Pad turns are tied to nights, one boxer per turn.
- Film moves out of the pad turns.
- Lock is cut, and a short class is added.
- The later date is decided by a rule, not a roll.
- Loyalty drifts toward 60 instead of climbing.
- The day job gets its own probe and defaults to 1 lost morning.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board and the mockups. The owner's computer is offline, so this map is checked against the critic pack, v8 and the two critics only.

**Owner rules kept, quoted**
- **Q-190 (S434/S435):** "Just rename it 'gym sponsorship', the club pays." It's never mixed up with Sponsor deals on Club > Money.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Rows, buttons, tooltips and Why lines say the 65 kg boxer, a team-mate, the grappler, your coach, the opponent.
- **S412:** "the player runs any gym with any boxers, men or women." No fixed he or she, and never one fighter as the story.
- **S425:** every menu the mechanic appears on, and what each is wired to (section 7).
- **S459:** 6+ DEPTH and 6+ GENERAL DESIGN from fresh critics, ESTIMATEs marked, buildable from what the game has.
- **Pack 4.5, agreed:** "a 'no' is a closed panel or an absent answer with its reason, never a random refusal". The later date follows it too (4.1).
- **Pack section 7:**
  - "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
  - One word per concept.
  - Screens only from agreed mockups. The Club week waits for the owner's OK on a drawn page (owner question 1).
- **Pack section 3:** traits are "learned not shown as numbers". Loyalty as a bar is therefore owner question 5.
- **Pack section 1:** "Deeper, not wider." A quiet week is one click.
- Classes in kg: women 57/60/65/75, men 57.5/60/70/75. Females never fight or spar males.
- "Gym" is the facility. "Camp" means only a pro's pre-bout preparation; an amateur bout has a fight week.

**Marks**
- **CODE:** in the code today, with the file or symbol named.
- **REAL:** real practice, with its source.
- **DERIVED:** worked out from CODE or GAME numbers.
- **ESTIMATE:** ours, gated by the section 9 probes. No probe has run on v8 or v9, so every turn count, loyalty move, price and rate that isn't CODE is ESTIMATE.
- **NEW:** a rule this map adds.
- **v2:** held back until its probe passes.

**One word list**
- **Pad turn:** the coach's pad rounds for one boxer on one evening, about 20 coach minutes, 3 to a pad hour (NEW, ESTIMATE). With a pad turn, that evening counts at the **pads rate** (2.1 mastery an hour, CODE).
- **Place** keeps its two code meanings only: a roster place and a ranking place.
- **Bag night:** an evening without a pad turn. It's the same 240 units (CODE `PadWeek.PAD_NIGHT_MINUTES`) on the same drill cards, at the **heavy-bag rate** (1.05 an hour, CODE). So a bag night is half the mastery.
- **Film session:** a coach evening of tape and plan, counted on its own counter, never as a pad turn.
- **Energy** is fight-night fuel (CODE `BoutNight._energy`). **Tiredness** (0–100) is the week's wear (CODE). **Stamina** is the ability.
- **Coached morning:** a morning session (CODE) with You or Coach present. **WORK** marks a morning lost to a day job (3.6).
- **Coach** is the hired assistant coach. **You** are the head coach.
- **Fight week** is the code's TAPER week (`WeekPhase.phase`).

## 0. Every critic point answered

### 0.1 John (SQ157): To reach 10/10
| # | John's point | v9 |
|---|---|---|
| 1 | Rename "place" to "pad turn" | **Done** everywhere. "Place" is only a roster or ranking place |
| 2 | Write the per-night rule; Lock works or is cut; move You's hour off weigh-in night | **Done (3.1).** A pad hour holds 3 turns, one boxer per turn, and a boxer takes at most one turn a night. A class takes the whole hour. **Lock is cut:** with whole-hour classes it can't protect anyone. Row order now decides who keeps the one turn left by the new **short class**. You's hour moves to **Wednesday**, so no pad hour sits on Friday, the weigh-in night for a Saturday show (CODE: weigh-in the day before) |
| 3 | Fix the table; rewrite "only stacked choices go SHORT"; fix the example lines; run SHORTWEEK1 with show-Saturday bouts | **Done (3.1, 3.8, 4.1).** John's sum was right for v8 (4 + 4 + 2 = 10 against 9, SHORT 1). v9 takes film out of the turns (point 4), so two fight weeks with 3 boxers is now **FULL with FILM 2 of 2**. The rule now reads "SHORT comes from a class on a fight week, or two fight weeks with 4 boxers". Every example line is re-done from the new table. SHORTWEEK1 uses show-Saturday bouts, with John's DERIVED rates (9). |
| 4 | Split the fight week: 3 turns for sessions plus 1 coach evening for film; count Rest up and Train through | **Done (3.4).** Tick over: 3 turns + 1 film session. Rest up: 2 turns + film. Train through: 3 turns + 1 sparring night (no turn) + film. The names match AMATEURWEEK1 v9 |
| 5 | Coached morning as a multiplier on the coach factor; other mornings unchanged | **Done (3.5).** Solo ×1.25, shared ×1.15 each, on top of the code's coach factor (0.5 + rating × 0.7%). Every other morning runs exactly as today, so it's a bonus, not a cut |
| 6 | Give the day job a probe; default 1 lost morning | **Done (3.6, 9).** DAYJOB1 reports stat gain and wins in 100 at 0, 1 and 2 lost mornings. The default is 1 WORK morning (Tuesday). Owner question 3 is asked with that table |
| 7 | Loyalty: start at the trait; Want met 0; drift to 60; short −5/−8; talk odds as words; admit that under 25 touches morale | **Done (3.7).** Each part as asked. The hover on the bar says "Under 25: morale −4 each Monday, and morale is the corner's trust" |
| 8 | Shut the members leak: the class raises the member target by 4, capped by premises; cover only at SHORT | **Done (3.2).** A full class raises the target by 4 and a short class by 2, capped by premises. Members still walk to the target at most 6 a week (CODE). Cover is offered only at SHORT |
| 9 | Fix four twists | **Done (3.9).** Heating $120. Old coach: hold pads, or corner Saturday. Southpaw: a sparring night at $80, drawn only when it applies. Visiting pro: opens one habit in the coach's notes |
| 10 | The later date answers inside the answer-by date | **Done better (4.1).** The answer is decided by a rule and printed on the button before the click ("28 Feb: the opponent is free"), so there's nothing to wait for |
| 11 | Small things: pro camp length, amateur PEAK, Hold pads 0.85 with the holder on bag, full-time coach 3 coached mornings | **All done:** camp length is CHECK, not "4 or 6"; PEAK is a row in 3.1; Hold pads is 0.85, and the holder's night is a bag night; Coach's mornings are 2 sessional and 3 full-time, so COACHFIT1 reads 6 + 2 = 8 and 9 + 3 = 12 |
| 12 | Run probes 1–3 and DAYJOB1, then draw and ask | **Not done here:** I design and don't run code. They come first in the build order (10), with pass lines in 9, and the page is drawn in the next board session |

### 0.2 John's missing options
| Option | v9 |
|---|---|
| Swap a pad hour's night | Plain editing: drag an hour to another free night. It's never allowed on Friday of a weigh-in week, and never two hours on one night |
| A shorter class | **Added (3.2):** 40 minutes, +$78, takes 2 turns. Row order keeps the third turn |
| Lend the coach for film | Done: film sessions are their own counter (3.4) |
| A promise with a reason | Done (3.7): a dated promise must be one of the boxer's open asks (CODE goal talk "asks"), or a turn, a bout or the sponsorship |

### 0.3 Maria (SQ158): To reach 10/10
| # | Maria's point | v9 |
|---|---|---|
| 1 | Settle CHECKs 1 and 2 first; if no pad hours in code, say they're new and ask | **Done (10, 11).** The CHECKs run first. If the code has no pad-hour count, pad turns are a NEW design value, and "a sessional coach gives 2 pad hours" goes to the owner inside question 2 |
| 2 | Soften the day job; half-sponsorship tier | **Done (3.6).** The default is 1 lost morning, not 2. The $125 half tier exists only if the owner picks 2 lost mornings, because at 1 there's nothing to halve |
| 3 | Print a short fight week's fight-night cost | **Done (4.1, 7)** as a line filled by TAPER1. Until then it reads "fight-night cost: not measured yet". If TAPER1 measures under 1.5 in 100 (the cut rule), the line and the Why line are cut, and a short fight week costs loyalty only. That's stated now, not hidden |
| 4 | Put coached mornings under CHECK 7 with COACHFIT1 | **Done:** CHECK 7 covers turns and mornings (8 and 12) |
| 5 | Owner lines for the 4-place fight week and Lock | **Lock is cut.** The fight week no longer costs an extra turn. Its cost (a class on a fight week leaves that boxer SHORT) is written into owner question 2 |
| 6 | Fix the free twist answers | **Done (3.9).** Old coach has two real gains to choose between and is drawn only on a fight Saturday. Southpaw is drawn only when a southpaw is booked against a boxer who never faced one |
| 7 | Rest up on the Club week | **Done:** a switch on each fight-week row: 2 turns, Need 2 |
| 8 | Edit magnets out of the decision table | **Done (5).** It's plain editing now |
| 9 | Run probes 1, 3, 4, 7; act on MONEYFOUR2 | **Not done here: I don't run code.** The rule is written into 9: if a class every week is always right, the member target drops to +2 or the price to $90 |
| 10 | Make solo mornings matter | **Done (3.5):** a solo morning on the WEAK SPOT pull runs ×1.4, against ×1.25 elsewhere |

### 0.4 Maria's missing and weak options
| Option | v9 |
|---|---|
| Half sponsorship | Only if the owner picks 2 lost mornings (3.6) |
| Rest up on the Club week | Done |
| The fight-night cost of short | Done, filled by TAPER1 |
| Volunteer for fight weeks only | **Added:** on call, $50 a fight week, +3 turns at 0.8 that week (ESTIMATE) |
| Editing magnets | Kept, out of the decision table |
| Old coach: "Thank them" | Replaced |
| Southpaw: "Pass" | Now a real cost: the boxer keeps the round-1 penalty |

Part 2 of 4

## 1. The idea in five lines
1. **The Club week is the Monday deal of the club's scarce things:** the coach's **pad turns**, the **film sessions**, the **coached mornings**, the **gym sponsorship**, and **your one talk**.
2. **A pad hour can be sold as a class,** full or short. That's the money lever, and its price is printed in bag nights, by weight class.
3. **Bouts sit on the same board.** A fight week needs every one of its 3 turns. A class on a fight week leaves that boxer SHORT, and the bout page says so before Accept.
4. **What lasts past the week is loyalty,** drifting toward 60 and moved only by named causes.
5. **The NEXT WEEK line** shows a collision two weeks out. A quiet week is one click.

## 2. When it appears (the starts unchanged)
- **The three starts stay as they are (CODE):** Fresh doors, In debt and Backed.
- **With one fighter,** the Week tab works as today, and that fighter gets every turn they ask for.
- **When a second fighter signs, the Club week tab appears on Fighters (NEW).** One guide line, "Two fighters now share the coach's pad hours", and a Home note open it.
- **The fourth start** stays in its own map, START2.

## 3. The week, as the player meets it

### 3.1 Pad turns, tied to nights (answers John 1–4, Maria 1)
**The per-night rule (NEW)**
- A pad hour holds **3 turns**, one boxer per turn.
- A boxer takes **at most one turn a night**.
- A class takes the whole hour (a short class takes 2 turns).
- No pad hour sits on Friday of a week with a weigh-in.

**Where the hours sit**

| Who | Pad hours | Nights | Turns |
|---|---|---|---|
| Sessional coach | 2 (ESTIMATE; CHECK 1) | Tue, Thu | 6 |
| Full-time coach | 3 (ESTIMATE; CHECK 1) | Mon, Tue, Thu | 9 |
| You | 1 | Wed | 3 |
| **Owned, sessional / full-time** | | | **9 / 12** |

- An hour can be dragged to another free night (plain editing).
- The code's evening members' class (+$350, CODE) is separate and never changes.
- With no coach, only your 3 turns exist, and training runs at 60% (CODE).

**Need and Want**
- **Ordinary and PEAK weeks:** Want 3 (one per pad night, the code's 3 pad nights), Need 2. PEAK's two sparring nights (CODE) take no turns.
- **A fight week:** Want 3, Need 3 (3.4).
- A boxer gets at most Want.

**Coach's deal order:** fight-week boxers first, then row order (drag to change, kept week to week).

**The counter's words** (colour repeats the word and is never the only signal)

| Word | Means |
|---|---|
| OK | spare turns |
| FULL | every Want met |
| BAG n | n bag nights in all this week (Asked minus dealt) |
| SHORT n | n turns under Need; shown with BAG, as "SHORT 1 · BAG 3" |

**The table, sessional coach (owned 9, film 2)**

| Week, 3 boxers unless said | Owned | Asked / Need | Turns | Film |
|---|---|---|---|---|
| Ordinary or PEAK | 9 | 9 / 6 | **FULL** | none |
| One fight week | 9 | 9 / 7 | FULL | 1 of 2 |
| Two fight weeks | 9 | 9 / 8 | FULL | 2 of 2 |
| Three fight weeks | 9 | 9 / 9 | FULL | 3 of 2: one boxer watches alone |
| Full class | 6 | 9 / 6 | BAG 3 | none |
| Short class | 7 | 9 / 6 | BAG 2 | none |
| Full class + one fight week | 6 | 9 / 7 | **SHORT 1 · BAG 3** | 1 of 2 |
| Short class + one fight week | 7 | 9 / 7 | BAG 2 (the fight-week boxer keeps the third turn) | 1 of 2 |
| Full class + two fight weeks | 6 | 9 / 8 | **SHORT 2 · BAG 3** | 2 of 2 |
| Two full classes | 3 | 9 / 6 | **SHORT 3 · BAG 6** | none |
| 4 boxers (a bigger unit, CODE roster) | 9 | 12 / 8 | BAG 3 | none |
| 4 boxers, two fight weeks | 9 | 12 / 10 | **SHORT 1 · BAG 3** | 2 of 2 |
| Pro camp, BUILD or PEAK | as the camp's pad nights: Light 2, Standard 2, Hard 3 (CODE); sparring takes no turns | | read per week | none |

- **With a full-time coach** (owned 12 over 4 nights, film 3), a full class plus one fight week is FULL, and 4 boxers are FULL. All values are ESTIMATE.
- **Where SHORT comes from:** a class on a fight week, or two fight weeks with 4 boxers.

**How often (DERIVED, John's method):**
- Fight weeks fall only before show Saturdays, so in 26 of 52 weeks.
- At about 7 bouts a boxer, each boxer has one in about 27 in 100 show weeks.
- With 3 boxers, at least one has a fight week in about 31 in 100 of all weeks.
- So **a gym selling a class every week meets a SHORT week about 3 times in 10** unless it acts.
- Two fight weeks together come about 9 in 100 weeks. They cost film, not turns.

**Steps:** a step in the study slot rises only on nights with a turn. 3 turns give about 6 a week (CODE S463); 2 give about 4 (ESTIMATE). CHECK 4.

**Freed turns** come from a rest week, a pull-out or a bout ending. They print on the counter: "Freed 3: give to [row], or sell as a class +$117". The default follows deal order.

### 3.2 The money lever and its valves (answers John 8, Maria 8–9)
| Lever | What it does | Price | Tag |
|---|---|---|---|
| **CLASS**, full (any pad hour, yours too) | the hour runs a second members' class | +$117 that night; member target +4 while classes run (capped by premises, walk at most 6 a week, CODE); 3 turns gone, with the weight classes named on the magnet | ESTIMATE; CHECK 2 |
| **CLASS**, short (40 minutes) | 2 turns go; row order keeps the third | +$78; member target +2 | ESTIMATE |
| **Cover a night** | a sessional cover coach runs an extra pad hour on a free night | $130, +3 turns at the full rate; **offered only at SHORT**, once a week | ESTIMATE |
| **Pads volunteer** (staff job, Club > People) | an extra pad hour every week, on Mon (sessional) or Sun (full-time) | $120 a week, +3 turns at 0.8 of the pads rate | ESTIMATE |
| **Volunteer on call** | the same hour, fight weeks only | $50 a fight week | ESTIMATE |
| **Hire full-time** | Coach goes from 2 pad hours to 3, and 2 coached mornings to 3 | the code's wage ($1,090 against $450) | turns ESTIMATE |
| **Rest week** (row switch) | Need and Want 0 | +4 morale (CODE rest week) | CODE |

**Why it isn't a pump**
- Cover is offered only when a class or a bout stack leaves a boxer SHORT, so a class's BAG 3 never buys cover.
- **A year of a full class every week (sessional, 3 boxers, DERIVED from the ESTIMATEs):**
  - +$6,100 in class money;
  - about +$1,700 in dues from 4 more members on the target;
  - about −$2,100 for cover in the about 16 SHORT weeks;
  - 3 bag nights in every ordinary week.
- MONEYFOUR2 and VOLUME1 decide whether that's ever wrong. If a class every week is always right, the member target drops to +2 or the price to $90 (9, probe 7).
- The **second club coach** ($280, CODE) adds no turns: its hours are fitness classes in the code. Its card says so.

### 3.3 The deal (Lock cut, answers John 2)
- **Coach deals it** is the default and one click. Fight-week boxers come first, then row order.
- **Plain editing, out of the decision table:** drag a turn between rows on the same night, drag an hour to another free night. **Back to Coach's deal** undoes it.
- **Lock is cut.** A full class takes every turn that night, so Lock could protect nobody. Row order already decides who keeps the short class's third turn, and who loses one to the photo twist.
- **Pulls, printed as words:** warnings first (SCALE inside 14 days, FIGHT WEEK, REST at tiredness 70+ or hurt), then at most two labelled stickies:
  - **WEAK SPOT:** the lowest ability the fight reads, 3+ under the fighter's level, with who finds it ("Low Defence: pressure fighters find it"). CHECK 5.
  - **WEAPON:** the ability gating the next perk ("Fast hands at Speed 70: about 4 weeks").
  - **GOAL:** the active goal (CODE).
  - **AHEAD:** the next rival up the regional table, and the answers owned (LADDER1).

  A pull asks for solo coached mornings (3.5).
- **A quiet week:** when nothing differs from last week (no fight week, no BAG or SHORT, no talk, no twist due), the page shows only the counters and the rows, and the button reads "Coach deals it: same as last week". Press it, then Continue.

### 3.4 The fight week: 3 one-to-one sessions plus film (answers John 4, Maria 7)
- **When:** the 7 days before any booked bout (CODE TAPER, `WeekPhase.phase`), amateur or pro.
- **Sessions:** 3 one-to-one sessions of 120 units, one turn each, on Tue, Wed and Thu (Mon too with a full-time coach). That's 360 units, half the standard 720, at 3 of 3 nights. Friday stays free for the scale.
- **Film session:** one coach evening of tape and plan, on the FILM counter, never a turn.
  - **Owned:** You 2 a week, plus 1 with a full-time coach (ESTIMATE).
  - Over the count, the boxer watches alone: the session opens no tell (ESTIMATE). What a coached session opens belongs to AMATEURWEEK1 v9.
- **Load stops (AMATEURWEEK1 v9 names), as a switch on the row:**

| Load stop | Turns (Need) | Film | Sparring |
|---|---|---|---|
| Tick over (default) | 3 | 1 | none |
| Rest up | 2 | 1 | none |
| Train through | 3 | 1 | 1 sparring night (no turn), at AMATEURWEEK1's price |

- **Real taper (REAL, Bosquet et al. 2007, meta-analysis):** cut volume 41–60%, keep intensity, keep frequency at 80%+. The best results came from 8–14 days, so the code's 1-week fight week is at the short end.
- **The row prints:** "Fight week: three one-to-one sessions, half volume".

### 3.5 Coached mornings (answers John 5, Maria 4 and 10)
**Owned:** You 4; Coach 2 sessional or 3 full-time (ESTIMATE; CHECK 7 with COACHFIT1, which reads 6 + 2 = 8 and 9 + 3 = 12).

**Every morning keeps the code's rate:** a fifth of the week's pace × the coach factor (0.5 + rating × 0.7%, so Luke Reid 0.91 and Marcus Hale 1.02; no coach 0.6) × headroom. A coached morning multiplies that:

| Use | Multiplier | Tag |
|---|---|---|
| Not coached | ×1.0, today's rate | CODE |
| Solo | ×1.25, without Hard's extra tiredness | ESTIMATE |
| Solo on the WEAK SPOT pull | ×1.4 | ESTIMATE |
| Shared, two fighters | ×1.15 each | ESTIMATE |
| Pads in the morning | one turn for one boxer at 0.8 of the pads rate, using up that coached morning | ESTIMATE |

**What 6 coached mornings add (in morning-equivalents):**
- all shared: +1.8, spread over up to 12 sessions;
- all solo: +1.5;
- solo on one WEAK SPOT: +2.4 on one ability.

So shared is the bigger total and solo is the focus. MORNINGS1 requires each to be best in 30–70 in 100 seeds.

### 3.6 The gym sponsorship and the day job (answers John 6, Maria 2)
**The sponsorship is the stipend** (CODE, $250 a week, Club > Money > STIPENDS):
- Shown and billed as the gym sponsorship in 4-week blocks of $1,000.
- Amateurs and the grappler can hold one. A pro can't: the stipend stops on signing (CODE).

**The day job (NEW; owner question 3)**
- **Default until DAYJOB1 runs:** a boxer without the sponsorship loses **1 morning a week** (Tuesday), marked WORK.
- **What it costs (DERIVED):** about −0.2 points a week on that morning's ability, before headroom and the coach factor, so about −2 over 10 weeks. The pack measures 5 stat points at about 72 in 100.
- **A grappler without it** misses 1 mat class in 3 (NoGi class count, CODE).
- **A pro** has no day job.
- **If the owner picks 2 mornings:** a half sponsorship ($125 a week) gives 1 morning back.
- **Existing saves:** a boxer already paid keeps it. The others get WORK from the next Monday, with one Home note.

**Block choices and loyalty**
- **Give** (a boxer without one): +5.
- **Renew** (the same boxer): −$1,000, +2. WORK stays off with no gap; letting it end brings WORK back next Monday.
- **Pass on:** the receiver +5, the giver −3.
- **Let end:** 0.
- **Stop mid-block:** −8.

CHECK 3: that the stipend and the sponsorship are one record.

**The grappler's row** holds two things only:
- **SPONSORSHIP:** held or not.
- **SATURDAY CORNER:** shown only when a boxer and the grappler compete the same Saturday. Pick You, or a $100 mat coach (ESTIMATE).

Everything else stays on the grappler page (CODE). GRAPPLE1 gates more (v2).

Part 3 of 4

### 3.7 Loyalty: the code's trait, drifting (answers John 7, owner question 5)
**What it is:** the code's Loyalty trait (pack 3: it exists but isn't on the board).

**How it's shown:** a 0–100 bar on the row and on Overview, **if the owner says yes**. Otherwise it's the band word only, because the pack keeps traits "learned not shown as numbers".

**Bands:** Loyal 70+, Settled 50+, Wavering 25+, Leaving under 25.

**Start:** the trait's value at signing (CODE; CHECK 8 its range).

**Moves (NEW, ESTIMATE except where marked)**
| Cause | Loyalty |
|---|---|
| A week with Want met | drifts 1 toward 60 (up from below, down from above) |
| Need met only | 0 |
| Short (under Need) | −5; short again next week −8; 1 short week in 4 waived at Loyal 70+ |
| A squeeze passed, nobody short (3.8) | +2 each |
| Promise kept / broken | +5 / −12 |
| Sponsorship given / renewed / passed away / stopped | +5 / +2 / −3 / −8 |
| Holding pads | +3 a week, 4 weeks at most |
| Stripe call now / hold | as StripeCall (CODE) |
| A team-mate let go | −5 |

So loyalty sits near 60 on its own. Only shorts, broken promises, stops and lets-go push a boxer under 50, and only kept promises, sponsorship and Hold pads lift a boxer past 70.

**Every move prints its cause:** "−5: short of a pad turn this week". Overview keeps a 4-week log, and the week review shows the week's moves.

**Hold pads (Loyal 70+, 6+ bouts):** the holder gives up their own turn that night and goes to bag. The team-mate's night counts at 0.85 of the pads rate, the holder isn't counted short, and the holder gets +3 a week (ESTIMATE). It costs the club mastery and buys loyalty.

**The talk** (loyalty under 50, flag "Wants a word")
- **Limits:** one talk a week for the club. It costs your Monday, not a turn. Each fighter at most once in 4 weeks.
- **The three answers:**
  1. **Give the turn back:** dealt first next week, +4. The card names the weight class of the team-mate who drops a turn.
  2. **A dated promise:** one of the boxer's open asks (CODE goal talk), or a turn, a bout or the sponsorship. +5 kept, −12 broken, listed under PROMISES OPEN.
  3. **Tell it straight:** costs no turn. Its odds come in words from the coach's notes (CODE: traits learned from fights and sparring): "listens: usually" (7 in 10), "sometimes" (5 in 10), "rarely" (3 in 10), "not known yet" (5 in 10). ESTIMATE. +6 if it holds, −4 if not, then an 8-week wait.

**Under 25 (owner question 4)**
- **If the owner says yes:** after 2 talks the fighter leaves the next Monday. A fighter turning pro under 50 signs with an outside manager, and the club's share is 10%: the code's 25% minus its 15% manager part (GYM_SHARE, CODE).
- **Without a yes:** nobody leaves, the share stays 25%, and the fighter takes morale −4 each Monday under 25.
- **This does reach the corner,** because morale is the corner's trust (CODE 1.05 / 1.0 / 0.85 / 0.7). The bar's hover says so: "Under 25: morale −4 each Monday, and morale is the corner's trust."

**Moved out:** the Low-morale loop break goes to a morale map, MOOD.

### 3.8 The NEXT WEEK line and the reward line
**The NEXT WEEK line** sits under the counters. It reads booked bouts, camps and classes, and shows only when the next two weeks cost something (BAG, SHORT, or film over):
- "NEXT WEEK: fight week for the 65 kg boxer on a class week: SHORT 1. Short class, cover a night, Rest up, or the later date."
- "IN 2 WEEKS: three fight weeks: FILM 3 of 2, one boxer watches alone."

Two fight weeks that cost nothing print nothing.

**The reward:** when a week with a fight week and a class ends with nobody short, the Monday review prints "Fight week on a class week, nobody short: +2 loyalty each".

The Why's upside line, "Full fight week: three one-to-one sessions", is kept only if TAPER1 measures it at 1.5+ in 100 (4.1).

### 3.9 Twists: the code's deck, reworded (answers John 9, Maria 6)
- **The code's WeekTwist deck stays,** one card a week. No answer means Coach's pick on Monday (CODE).
- **With 2+ fighters,** the 7 cards that touch the evenings are reworded with 2 priced answers each (prices ESTIMATE unless marked).
- The other 9 cards stay per fighter, as today (7 + 9 = the code's 16).

| Card | Drawn when | Answer 1 | Answer 2 |
|---|---|---|---|
| Heating breaks | any week | Fix it today: −$120 | Run cold: one pad hour lost (3 turns). Cover only if that makes someone SHORT |
| Night off (a boxer asks) | any week | Give it: +4 morale (CODE), 1 turn freed | Refuse: −4 morale (CODE) |
| Partner ill | a sparring night is planned | Pads instead: needs a free turn, otherwise a bag night | Outside partner: $160 (CODE camp fee) |
| Southpaw in town | a southpaw is booked against a boxer who never faced one | Spar the southpaw: $80, one sparring night (no turn); lifts the round-1 penalty (CODE) | Pass: keep the penalty |
| Old coach visits | a boxer fights that Saturday | Hold pads: +3 turns one night | Corner Saturday: +3 morale for the boxer on the card |
| Sponsor photoshoot | any week | Do it: +$150; the lowest row loses one turn | Decline |
| Visiting pro | any week | Spar one boxer: one sparring night (usual sparring injury chance, CODE) and one of the boxer's own habits opens in the coach's notes | Rent them the gym: +$60 |

The 6 new cards from v7 stay v2, behind ROTATWIST1.

### 3.10 Let a fighter go
- **Where:** the row menu.
- **Price:** the rest of the sponsorship block, or 1 week's stipend, and −5 loyalty to each team-mate. The roster place frees now.
- **Confirm:** a second press, never pre-selected (ESTIMATE).

## 4. The fight week inside the club week

### 4.1 The offer, the collision line and the later date (answers John 10, Maria 3)
**The offer stays as the code has it:** one at a time, Accept or Pass, both free (CODE, pack 4.5). The bout sheet belongs to AMATEURWEEK1 v9 and LADDER1.

**The collision line (NEW), above Accept:**
- It shows only when the fight week costs something (SHORT, or film over), reading ClubDeal's forecast.
- It names weight classes, never a name. Examples:
  - "This fight week lands on a class week: SHORT 1. Short class (+$78), cover ($130), Rest up, or the later date."
  - "This fight week makes three: FILM 3 of 2, one boxer watches alone."
- **The fight-night cost, from TAPER1:** "A bag night in a fight week: about n in 100." Until TAPER1 runs it reads "fight-night cost: not measured yet". If TAPER1 measures under 1.5 in 100, the line is cut, and a short fight week costs loyalty only.

**The later date (NEW button, only beside a collision line). Decided by a rule, never a roll:**
- **The rule:** it's the next show, 2 weeks later. It's open if the opponent is free that date (not BOOKED or RESTING, LADDER1's words), the boxer can make weight by then, and the season isn't full.
- **Open:** the button reads "Later date: 28 Feb. The opponent is free." One press books it at once.
- **Closed:** the button is shown greyed, with its reason ("28 Feb: the opponent is booked"). It's never hidden.
- **Nothing to wait for,** so the answer-by date can't run out.
- It reads the code's later-date path for a boxer over the class. CHECK 6.

### 4.2 Pro and amateur side by side
| | Amateur | Professional |
|---|---|---|
| Notice | an offer by its date (CODE) | promoter's offers, standing 7 days (CODE) |
| Before the bout | fight week: 3 turns plus film | the camp as the code sets its length (CHECK 9), pad nights Light 2 / Standard 2 / Hard 3 (CODE); then the fight week: 3 turns plus film |
| Rounds | 3 × 3 minutes (CODE) | 4 unranked, 6 ranked (CODE) |
| Money to the club | $450 ticket cut (CODE) | 25% of the purse (CODE) |
| Sponsorship | can hold one | can't (CODE) |
| Day job | yes, without the sponsorship | none |

## 5. Every decision (choices only; plain editing left out)
| When | Decision | Options and prices | Probe |
|---|---|---|---|
| Monday | Deal | Coach deals it (default) / drag row order / Back to Coach's deal | DEALPRICE1 |
| Monday | Each pad hour | PADS (3 turns), short CLASS (+$78, 2 turns), or full CLASS (+$117, 3 turns) | MONEYFOUR2, VOLUME1 |
| Monday | Valves | Cover $130 (only at SHORT); volunteer on call $50; rest week; freed turns; Hold pads | COVER1, SHORTWEEK1 |
| Monday | Fight-week load | Tick over / Rest up / Train through | TAPER1 |
| Monday | Coached mornings | Solo ×1.25 (×1.4 on WEAK SPOT) / shared ×1.15 each / pads in the morning | MORNINGS1 |
| Monday | Sponsorship | give, renew, pass on, let end, stop | MONEYFOUR2, DAYJOB1 |
| Monday | Talk | turn back / promise / straight | LOYAL1 |
| Monday | Twist | 2 priced answers | ROTATWIST1 |
| Offer | Accept with the collision line / Later date (if open) / Pass | 4.1 | LATER1 |
| Club > People | Pads volunteer $120 a week; full-time coach | 3.2 | COVER1 |
| Saturday | Who corners a clash | You / $100 mat coach | none: rare |
| Any time | Let a fighter go | 3.10 | none: rare |

Part 4 of 4

## 6. The numbers
**CODE:**
- Pads 2.1 an hour, heavy bag 1.05.
- PAD_NIGHT 240 units; the standard week is 3 pad nights.
- Coach factor 0.5 + rating × 0.7%; a morning is a fifth of the week's pace.
- Stipend $250; members' evening class +$350; members walk to the target at most 6 a week.
- Ticket cut $450; full-time coach $1,090 against sessional $450; second club coach $280.
- Camp pad nights 2+1 / 2+2 / 3+2; TAPER 1 week out; PEAK 2 weeks out with sparring twice.
- Weigh-in the day before; outside partner $160.
- Rest week and night off morale +4; refused night off −4.
- GYM_SHARE 25% (manager 15% + trainer 10%); the Loyalty trait; StripeCall; NoGi class count.

**MEASURED, pack:** plans good 59%, none 45%, bad 41%; +5 stats about 72%; FireLevel on (S450).

**Earlier probe reports, not in the pack:** 28 bouts a year, 41 wins in 100; 4 sponsorships close 80% of gyms (AMATEURPROBE1, MONEYFOUR1). CHECK 10: that the files still stand. Until then nothing here rests on them.

**REAL:** a taper cuts volume 41–60% and keeps frequency at 80%+, best over 8–14 days (Bosquet et al. 2007).

**DERIVED:**
- A fight week in 31 in 100 weeks (3 boxers); two together in 9 in 100.
- A day-job morning costs about −0.2 a week on one ability.
- A year of a full class every week: +$6,100 class money, about +$1,700 dues, about −$2,100 cover.
- One sponsorship: −$13,000 a year.

**ESTIMATE:**
- 20 coach minutes a turn, 3 turns an hour; pad hours 2 / 3 / 1; film You 2 (+1 full-time).
- Need 2, Want 3; fight week Need 3.
- Class +$117 (member target +4); short class +$78 (+2); cover $130; volunteer $120 at 0.8; on call $50.
- Solo ×1.25, ×1.4 on WEAK SPOT; shared ×1.15; morning pads 0.8; Hold pads 0.85.
- Every loyalty move, the drift to 60, and the talk's odds in words.
- The day job's 1 morning; half sponsorship $125; mat coach $100; twist prices.
- Steps at 2 turns.

## 7. Every menu it appears on, and what each is wired to (S425; names only in headers)
| Menu | What shows | Wired to |
|---|---|---|
| **The guide** | one line when the second fighter signs | GuideLight, Roster.sign_fighter |
| **Fighters > Club week** (2+ fighters; owner OK needed) | counters with words (PAD TURNS Asked / Need / Owned with OK / FULL / BAG n / SHORT n; FILM n of m; COACHED MORNINGS; SPONSORSHIP; runway); NEXT WEEK line; the coach's week grid (nights × 3 turns, each hour PADS / short CLASS / CLASS with the weight classes that go to bag); Cover (only at SHORT); rows (name once in the header cell, morale word, loyalty bar or word with its last cause, sponsorship or WORK, pulls as stickies, night magnets PADS / BAG / FIGHT WEEK, load switch on fight-week rows, rest switch, drag order); grappler row; freed turns; talk card; PROMISES OPEN; twist; Coach deals it / Back to Coach's deal; Start week | ClubDeal (turns per night, Need and Want, fight week, film, cover, freed, forecast), DuesLevers (second class, short class, member target), PadWeek (rates), WeekPhase, WeakSpot, Loyalty, WeekTwist (club wording), LeverSize, GymSpend (stipend), DayJob (NEW) |
| **Fighter > Week** | own cells as today; shared cells say "Change on the Club week"; PADS or BAG on each evening; WORK on the day-job morning; coached mornings marked with your face or Coach's | WeekBoard, WeekEditors, ClubDeal, DayJob |
| **Fighter > Overview** | pulls with labels; loyalty with its 4-week log and the under-25 hover; Let go in the row menu | FighterPage, AttrBoard, Attrs, PerkRoad, Loyalty |
| **Fighter > Fight prep** | amateur: the 3 sessions, the film session and the load stop; pro: camp pad nights as turns | FightPrep, FightWeek, Camp, ClubDeal |
| **Grappler page** | unchanged; sponsorship line; missed class on WORK | GrapplerPage, NoGi, StripeCall, Loyalty, DayJob |
| **Home** | one row per fighter; "Wants a word"; sponsorship ending; NEXT WEEK SHORT note; Club week note when the second fighter signs; day-job note on old saves | Home, HomeRows, Needs, Loyalty, ClubDeal |
| **Fighters cards** | loyalty word, sponsorship or WORK, flag (Fight week, Set camp, Wants a word) | RosterCards, FighterCard, RosterFlag |
| **Fights, bout page / versus screen** | the collision line above Accept, with the TAPER1 cost line; Later date (open or greyed with its reason) | BoutPage, OfferCard, ClubDeal.forecast, the later-date path (CHECK 6), AskAnswer's BOOKED / RESTING (LADDER1) |
| **Fights (pro)** | the promoter's offers as today, with the collision line | ProFights, ClubDeal.forecast |
| **Club > People** | Coach card with pad hours and coached mornings (2 + 2 or 3 + 3); pads volunteer ($120, or on call $50); second club coach "+1 roster place, no pad turns"; no-gi coach | StaffCard, CoachAreas, StaffJobs, ClubDeal |
| **Club > Money** | class nights (full and short) beside the +$350; sponsorship as the stipend with block dates; cover nights; volunteer | Money, GymBills, GymSpend, CashForecast, DuesLevers |
| **Top bar and Continue** | flags FIGHT WEEK, SET CAMP, WANTS A WORD; stops once for a SHORT week, a twist answer and a sponsorship end | Shell, Needs, Clock |
| **Fight night and the Why** | "Short of pads in the fight week" and "Full fight week: three one-to-one sessions", only if TAPER1 measures 1.5+ in 100 | FightWhy, LeverSize |
| **Monday week review** | bag nights and shortages with causes; loyalty moves with causes; the reward line | WeekReview, WeekCause, Loyalty |
| **Pro offer** | the share: 25%, or 10% only if the owner says yes | ProOffer, Loyalty |

## 8. Held for v2, each gated on its probe passing the cut rule
| Held | Probe |
|---|---|
| Favours, one regional pool with AMATEURWEEK1 | SHEETDEAL1 |
| Fans and home against away | LADDER1 |
| Trial mat every 4 weeks | TRIAL1 |
| Six new twist cards | ROTATWIST1 |
| Sparring settings | SPARSET1 |
| Mood-only rates | MOODRATE1 |
| The grappler in the deal | GRAPPLE1 |
| The fourth start | START2 |
| Lock (only if a half-hour class arrives) | none until then |

## 9. Probes (played bouts, 40 seeds × 52 weeks, three seed sets; bouts only on show Saturdays; no screen before its table)
**Cut rule:** a choice worth under 1.5 wins in 100 on a bout, with no season effect, is cut, not drawn.

1. **SHORTWEEK1 + LOYAL1** (3 boxers, sessional, owned 9):
   - No class: SHORT in 0 weeks; FILM over in about 1 in 100.
   - A class every week: SHORT in 25–35 in 100 weeks (DERIVED 31).
   - Coach's deal's longest short run is 2 weeks or fewer.
   - With the drift to 60, the talk turns up 2–4 times a season in a class-selling gym, and 0–2 in one that sells none.
   - Starving one row loses exactly one fighter a seed if owner question 4 is yes.
2. **DEALPRICE1:** edited deals against Coach's. Under 4 in 100 means editing stays but isn't taught.
3. **VOLUME1:** mastery paces and the 59/45/41 plan numbers at 1, 2 and 3 bag nights a week. If one bag night a week moves the plan numbers by more than 2, the class price rises or the volunteer gets cheaper.
4. **TAPER1:** Tick over against Rest up against a full-volume fight week, and a bag night in a fight week. It fills the collision line's cost and decides the Why lines.
5. **MORNINGS1:** solo, solo on WEAK SPOT, shared and morning pads; each best in 30–70 in 100 seeds.
6. **COVER1:** cover taken in 10–40 in 100 SHORT weeks; the volunteer pays back within 26 weeks in at least 1 seed set in 2; on call beats the full volunteer for 3-boxer gyms.
7. **MONEYFOUR2:** 1 sponsorship plus 1 full class a week stays cash-level over 52 weeks, with the lowest loyalty reported beside cash; it must stay 40+ under Coach's deal. If a class every week is always right, the target drops to +2 or the price to $90, and the probe runs again.
8. **DAYJOB1:** stat gain and wins in 100 at 0, 1 and 2 lost mornings over 52 weeks. It's the table for owner question 3.
9. **LATER1:** the later date is open in 40–80 in 100 collisions, and beats Accept-and-fix in 25–60 in 100. If it's always best, it costs the bout's place on that show (v2 note).
10. **ROTATWIST1 (the 7 reworded cards):** no answer best more than 2 times in 3.

## 10. Build order (5 rule modules)
1. **CHECKs 1 and 2 first** (pad hours, a second class). Then probes 1, 3, 4 and 8 under the pad-turn unit, emitting the LeverSize tables.
2. **Pure rules, one per task:**
   - ClubDeal (turns per night, Need and Want, fight week, film, cover, freed, forecast)
   - Loyalty (start, drift, causes, talk)
   - WeakSpot
   - LeverSize
   - DayJob, with the stipend as the sponsorship
3. **Code changes:** a full and a short second class (DuesLevers, member target), the club wording for 7 WeekTwist cards, the pads volunteer and on-call in StaffJobs, the later-date rule at a collision.
4. **Screens, after owner questions 1 and 5 and the drawn page:** the Club week, the collision line and later-date button, the Overview loyalty log, the Money lines.
5. **One golden-path test:**
   1. Fresh doors; the second fighter signs, and the Club week appears.
   2. A full class is sold, and BAG 3 shows.
   3. A fight week is booked on a class week: the collision line shows SHORT 1.
   4. The later date is greyed with its reason, so a short class is taken: BAG 2.
   5. A talk.
   6. A reworded twist.
   7. The reward line.

## 11. Owner questions and CHECKs
**Owner questions**
1. **The Club week:** OK it as a tab on Fighters, on the drawn page?
2. **Bag nights:** an ordinary week keeps today's full pads. A class, a fourth boxer or a twist puts boxers on bag nights (half the mastery that night), and a class on a fight week leaves that boxer short. If the code has no pad hours: a sessional coach gives 2 pad hours a week, a full-time coach 3. Yes?
3. **The day job:** a boxer without the gym sponsorship loses 0, 1 or 2 mornings a week to work, picked from the DAYJOB1 table. 1 is the default.
4. **Leaving and the pro share:** a fighter under 25 loyalty after 2 talks leaves, and turning pro under 50 drops the club's share to 10%. Yes, or morale only?
5. **Loyalty on screen:** a 0–100 bar, or the band word only (Loyal, Settled, Wavering, Leaving), as traits are learned, not shown?

**CHECK (Claude)**
1. The coach's pad hours in code.
2. A second class an evening (full and short) in DuesLevers, and the member target.
3. The stipend and the sponsorship as one record.
4. StepMastery counting only nights with a turn.
5. Which abilities the fight reads, for WEAK SPOT.
6. The later-date path reused at a collision.
7. With COACHFIT1: its budget read as turns plus coached mornings, 8 and 12.
8. The Loyalty trait's range.
9. The pro camp's length.
10. That the AMATEURPROBE1 and MONEYFOUR1 files still stand.

**CHECK (John):** pad rounds per boxer on a real club night, and the 20-minute turn.

## 12. The page for the owner (1920×1080, Look B whiteboard; drawn in the next board session)
- **Dark top bar:** CONTINUE reads "to Mon 9 Feb, the week review".
- **Counter strip (64–170):** five magnets: PAD TURNS "Asked 9 · Need 7 · Owned 6 · SHORT 1 · BAG 3", FILM "1 of 2", COACHED MORNINGS "Solo 4 · Shared 2", SPONSORSHIP "1 of 3 · 2 on WORK", RUNWAY "11 weeks".
- **Under it, in red marker, only when it costs something:** "NEXT WEEK: fight week on a class week, SHORT 1. Short class, cover, Rest up, or the later date."
- **Left (40–440), THE COACH'S WEEK:**
  - a grid of nights × 3 turns (Tue and Thu for Coach, Wed for You, Friday blank in weigh-in weeks);
  - each turn is a chip with the weight class;
  - each hour flips PADS, short CLASS ("+$78 · 2 turns") or CLASS ("+$117 · +4 member target · 60, 65 and 75 kg go to bag Thursday");
  - COVER appears only at SHORT;
  - the volunteer line, with "on call: fight weeks only".
- **Centre (480–1480), THE SQUAD:**
  - one row per boxer, the name once in its header cell, with the weight class;
  - the morale word, and loyalty with its last cause ("drift to 60");
  - up to two stickies;
  - seven morning cells (coached ones marked with a face, WORK greyed "Tue: day job");
  - evening magnets: solid PADS, hatched BAG, and FIGHT WEEK as 3 turn magnets plus a FILM magnet, with the Tick over / Rest up / Train through switch;
  - drag to reorder; the grappler's row last.
- **Right (1520–1880):** the twist with 2 priced answers, the talk card with "listens: usually", PROMISES OPEN with dates.
- **Bottom (980–1060):** Coach deals it ("same as last week" when quiet), Back to Coach's deal, and Start week in gold. Green appears only on Continue. Hover on any BAG magnet: "half the mastery tonight: 1.05 an hour against 2.1".
- **The stress state is the default drawing:** a class on Thursday plus one fight week. It's drawn with the short-class fix beside it as the second state (BAG 2, nobody short).

## 13. Risks
- **Coach's deal may still decide most weeks.** That's accepted. The choices that bite are the class (full or short), cover, the volunteer, the load stop, the later date, the sponsorship and the talk.
- **A gym that sells no classes rarely meets SHORT.** With 3 boxers, its squeeze is film and the fourth boxer. That's honest: the money lever is what makes the club week bite.
- **The turn maths rests on CHECK 1.** Without a pad-hour count in code, 9 and 12 are design values the code must adopt (owner question 2).
- **The fight-night cost of a short fight week may measure under the cut.** Then SHORT costs loyalty only, and the map says so on screen.

## 14. Self-score: DEPTH 7, GENERAL DESIGN 7, PLAY 6 (mine, not a critic's)
**To reach 10/10**
1. Settle CHECKs 1 and 2, then run probes 1, 3, 4 and 8, and paste the tables.
2. Draw section 12 at 1920×1080 and get owner questions 1–5 answered on it.
3. Align with COACHFIT1 so both maps read one budget of turns and mornings (CHECK 7).
4. Tune loyalty from LOYAL1 until the talk turns up 2–4 times a season in a class-selling gym.
5. Give a no-class gym a squeeze of its own once a probe shows it needs one. The living world's rival offers (R58) is the likely source.
6. Bring back v2 items only as their probes pass, GRAPPLE1 first.
