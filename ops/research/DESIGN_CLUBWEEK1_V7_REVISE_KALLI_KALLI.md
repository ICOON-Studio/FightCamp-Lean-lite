# DESIGN_CLUBWEEK1_V7_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ129)

Brief: research/DESIGN_CLUBWEEK1_V7_REVISE_KALLI.md
Sent: 2026-11-14 19:40 | collected: 2026-11-14 20:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Writing CLUBWEEK1 v7 in full now, answering all ten of Maria's points.

# CLUBWEEK1 v7: the club week, with the fight weeks inside it (S459, S472, 2026-11-14)

Part 1 of 4

**Owner rules this map keeps, quoted**
- **Q-190 (S434/S435):** "Just rename it 'gym sponsorship', the club pays." Gym sponsorship (short: sponsorship) is never mixed up with Sponsor deals on Club > Money.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Rows, buttons, tooltips, Home notes, warnings and Why lines say your boxer, the fighter, the grappler, a team-mate, your coach, the opponent.
- **S412:** "the player runs any gym with any boxers, men or women." No fixed he or she, and never one fighter as the story.
- **S425:** every menu it appears on, and what each is wired to (section 7).
- **S459:** 6+ DEPTH and 6+ GENERAL DESIGN from fresh critics; ESTIMATEs marked; buildable from what the game has.
- **Pack section 7:**
  - "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
  - One word per concept.
  - Screens only from agreed mockups. The Club week waits for the owner's OK on a drawn page (owner question 1).
- **Pack section 1:** "Deeper, not wider", and a quiet week is one click.
- **Kept from v6:**
  - Professionals in the line-up.
  - Staff named by role: "Coach" is the hired assistant coach, "You" are the head coach.
  - Classes in kg: women 57/60/65/75, men 57.5/60/70/75.

**Marks**
- **CODE:** in the code today, with the file or symbol named.
- **REAL:** real practice, with its source.
- **ESTIMATE:** ours, gated by the section 9 probes.
- **NEW:** a rule this map adds.
- **v2:** held back, gated on its probe.

**Status, said plainly:** no probe has run on v6 or v7. Every Need, Want, loyalty, price and volume number below is ESTIMATE until section 9 runs.

**One word list**
- **Tiredness** (0–100) is the week's wear (CODE, "Week tiredness").
- **Tank** is fight-night energy.
- **Stamina** is the ability.
- **A place** is one boxer's pad night with Coach or You: **240 drill units**, a whole pad night (CODE, PadWeek.PAD_NIGHT_MINUTES).
- **Fight week** is the code's TAPER week.
- The fighter page tab is **Week**.

## 0. How v7 answers the critic

### Maria (S472: DEPTH 7, GENERAL DESIGN 5, PLAY 6): To reach 10/10
| # | Point | v7 |
|---|---|---|
| 1 | Keep today's training volume: a place is 240 units; Need 2 nights, Want 3; re-run the shortage table | **Done (3.1).** A place is a whole pad night (240). A boxer's Want of 3 places is the code's standard week (720 units), and its Need of 2 is 480. **Owned stays 8, not 10.** With 10, Need is never short without a class night, so the decision would vanish. The table is re-run in 3.1, and the volume loss is printed and probed (VOLUME1) |
| 2 | Probe 1 and TANKPRICE1 first; protect pin; cut By hand if under 4 in 100 | **Done (3.3, 9).** Both are probes 1 and 2, run first. A **Protect** pin is added on each row. **By hand** is cut automatically if it beats Coach's deal by under 4 in 100 |
| 3 | Keep the game's start; the squad of four is a fourth start | **Done (2).** Fresh doors, In debt and Backed are unchanged. The Club week tab appears when a second fighter signs. "Take over a club" is a fourth start, and its 4 places are that start's rule (owner question 3) |
| 4 | Cut to the meters that bite | **Done (section 1, 10).** Core is places, class nights, the sponsorship, loyalty with causes, mornings and the NEXT WEEK line. Favours, fans, season targets, the trial mat, the six new twists, sparring settings and the mood alone rates move to v2, each gated on its probe passing the cut rule |
| 5 | A mockup for the owner before screen work | **Done as spec (12), asked with question 1.** The PNG is drawn in the next board session; this brief asks for the words map only |
| 6 | Words beside every colour | **Done.** Pulls print WEAK SPOT, WEAPON, GOAL and AHEAD; counters print OK, FULL and SHORT; colour only repeats the word |
| 7 | Tie the class night to the code | **Done (3.2).** The code's +$350 is the first-hour members' class and stays. A sold second hour **adds** +$117 (ESTIMATE). CHECK (Claude) that DuesLevers can take a second class per evening |
| 8 | Warn at Accept | **Done (4.1).** The bout page prints the collision before the Accept button, naming the weight class that goes short, never a name |
| 9 | Prove the grappler or drop the grappler from the deal | **Dropped from the deal (3.6).** The grappler's row keeps only the sponsorship and the Saturday corner clash. The rest stays on the grappler page (CODE). GRAPPLE1 gates anything more |
| 10 | The owner's answer on the weigh-in | **Asked (owner question 2).** On a yes it goes to AMATEURWEEK1 as its one rule. This map doesn't own it |

### Maria's missing options
| Option | v7 |
|---|---|
| Training volume switch ("Full week") | **Done as Want.** A boxer given 3 places has the code's full week. The row prints "Full week" or "2 of 3 nights" |
| Fresh doors with one walk-in | **Done:** kept as it is (2) |
| Warning at Accept | **Done (4.1)** |
| Coach deals it, but protect this boxer | **Done:** the Protect pin (3.3) |

### Maria's useless or near-dominant options
| Option | v7 |
|---|---|
| Hand-dealing at 2 to 3 in 100 | gated: cut if under 4 in 100 (probe 2) |
| Away "Name above" for −$40 | **removed from this map.** The bout sheet cards belong to AMATEURWEEK1; favours are v2 |
| Fans and Unknown sheets | v2 |
| Body-only sparring | **cut.** Sparring settings are v2, and Body only doesn't come back |

### Maria's other faults
| Fault | v7 |
|---|---|
| Too many meters | core is down to 4 meters: places, mornings, loyalty and cash. Mood stays the code's word |
| A new start replacing the old | the fourth start (2) |
| New screen without a mockup | owner question 1 with the page spec |
| Pulls colour-coded | words added |
| Build size of 12 modules | **7 modules** (10) |
| Two fight weeks always leave a boxer short | **Said on the bout page** before Accept (4.1) |
| Monday is a long page | a quiet week collapses to the counters and the rows; one click on Coach deals it, then Continue (3.3) |

## 1. The idea in five lines
1. **The Club week is the Monday deal of the club's scarce things:** the boxing **places** (8 a week), the **coached mornings** (6), the **gym sponsorship**, and **your one talk**.
2. **Coach's second hours can be sold as a class.** That's the money lever, and it makes the places run short.
3. **Bouts sit on the same board.** A fight week is one-to-one at half volume, true to TAPER. Two fight weeks close together are where the real shortages come from, and the bout page says so before Accept.
4. **What lasts past the week is loyalty,** and every move prints its cause.
5. **The NEXT WEEK line** shows a collision two weeks out. A quiet week is one click.

## 2. The start: the game's three starts kept, plus a fourth (answers Maria 3)
**Fresh doors, In debt and Backed: unchanged (CODE).**
- One walk-in, the first weight cut, the first fight.
- The second walk-in comes after the first bout. The grappler arrives after the club's second bout or by week 9.
- The fighter's **Week** tab works as today while there's one fighter.
- **When a second fighter signs, the Club week tab appears (NEW).** One guide line: "Two fighters now share the coach's nights." A Home note opens it.

**Take over a club (NEW fourth start; owner question 3)**
- **The squad:** one pro, two amateurs and the grappler, each in a different weight class.
- **The pro** (pick 1 of 2; starter data: 1-0 pro, licensed, unranked):
  - women's 60 kg out-boxer, age 21, potential 84;
  - or men's 70 kg southpaw pressure fighter, age 23, potential 79, second pro bout booked 6 weeks out.
- **The amateurs** (pick 2 of 4):
  - women's 57 kg, 1-0;
  - women's 65 kg, 2-1, loyalty 82;
  - women's 75 kg, 6-4, loyalty 66;
  - men's 60 kg, 2-1, loyalty 58.
- **The grappler:** white belt, 2 stripes; first open Sat 7 Feb.
- **Rules:**
  - Roster: **4 places** for this start only. CODE gives 3; the fourth is this start's rule, written in ClubStart.
  - Difficulty: Fresh doors cash.
- **Staggered opening:** the pro opens in camp, one amateur has an offer on the table, the other an active goal.
- **Guide for this start** (skippable, names only in headers):
  1. Meet the four.
  2. Deal the week.
  3. Answer the offer.
  4. Continue.

  It stops after the third fight week.
- All starter numbers are ESTIMATE.

**The road strip** ("The road, amateur to professional") shows when any amateur reaches 5 wins, in every start. TURNPRO1 owns its numbers.

Part 2 of 4

## 3. The week, as the player meets it

### 3.1 Boxing places: 8 owned, each a whole pad night (answers Maria 1)
**Where the 8 come from**
- Coach works 3 evenings (ESTIMATE; CHECK (Claude) the coach's evenings in code).
- The first hour of each is the existing members' class: +$350 a week, CODE, unchanged.
- The second hour is **2 places**: Coach holds pads for two boxers in turn, a pad night each.
- You hold 2 places on your own evening.
- 3 × 2 + 2 = **8 places**, 1,920 units a week.

**A place = 240 units:** a whole pad night, split over that boxer's drill cards exactly as today (CODE PadWeek).

**Need and Want, ordinary weeks (BASE, BUILD)**
- **Need 2 places** (480 units) and **Want 3** (720 units, the code's standard week of 3 pad nights; pack 4.2).
- A boxer gets at most 3 places.
- 3 boxers: **Need 6, Asked 9, Owned 8.** Every ordinary week, one boxer is on 2 of 3. ESTIMATE.

**Training volume against today, printed and probed**
- **Against the code:** the code's standard week gives every boxer 720 units. Here, the average in an ordinary week is 640 (8 places over 3 boxers), 11% under, and a boxer on Need drills a third less.
- **On the row:** it prints "Full week" or "2 of 3 nights: about a third less drilling".
- **Steps:** at 2 nights the step study slot would rise about 4 a week, not 6 (ESTIMATE). CHECK (Claude) that StepMastery scales with pad nights.
- **VOLUME1 re-measures the "Usable in n weeks" lines and the 59/45/41 plan numbers** at 640 and 480 units. If the plan numbers move by more than 2 in 100, Owned rises to 9.

**Why 8 and not 10.** With 10 places, Need is never short in an ordinary week or a single fight week. Only a class night would bite, and the Monday decision disappears.

**What creates a real shortage**
| Event | Places | Club Need against owned | Tag |
|---|---|---|---|
| Ordinary week | 2–3 each | Need 6, Asked 9 of 8 | ESTIMATE |
| One amateur fight week (3.4) | that boxer takes 4 | Need 4 + 2 + 2 = 8 of 8: FULL | ESTIMATE |
| Two fight weeks at once | 4 + 4 + 2 | 10 of 8: **SHORT 2** | ESTIMATE |
| Pro camp BUILD / PEAK | the camp's pad nights: Light 2, Standard 2, Hard 3 (its sparring nights take no places) | Need 6–7 of 8 | camp nights CODE (2+1 / 2+2 / 3+2); places ESTIMATE |
| Pro fight week | one-to-one, 4 | 8 of 8: FULL | ESTIMATE |
| One class night sold (3.2) | owned 8 to 6 | 6 of 6: FULL in an ordinary week; any fight week leaves someone SHORT | ESTIMATE |
| Film evening in a fight week | 2 (one coach hour) | +2 | ESTIMATE |

**Valves**
- **Cover a night:** +2 places for $80. A sessional cover coach takes a second hour. ESTIMATE.
- **Borrow a place:** +1 now, next week 1 owned short. One outstanding at a time; the NEXT WEEK line shows the debt. ESTIMATE.
- **Rest week:** a switch on a boxer's row: Need 0, Asked 0, +4 morale (CODE rest week +4).
- **Freed places** (from a rest week, a pull-out, or a bout ending) print on the counter: "Freed 2: give to [row] / [row] / sell as a class +$117". The default follows deal order.
- **Hold pads** (Loyal 70+, 6+ bouts): the holder gives one place to a team-mate at 0.7 (168 units) and holds the pads for them.
  - The holder isn't counted short.
  - Loyalty +3 a week, for 4 weeks at most.
  - ESTIMATE.
- **Second club coach** ($280, CODE): +1 roster place, +40 members, fitness classes. It adds **no** places, because its hours are fitness classes in the code. The card says so.

**What meeting or missing costs (ESTIMATE)**
- Need met: loyalty +1. Want met as well: +1 more.
- **Short** (under Need): −3, or −6 when short 2+ weeks running. Waived 1 week in 4 at Loyal 70+.
- A missed Want costs no loyalty, only the 240 units.

### 3.2 Coach's second hours: Pads or Class (answers Maria 7)
- **Each second hour switches** between **PADS (2 places)** and **CLASS**. So does your own evening.
- **CLASS pays +$117 that night** and brings about 1 new member every 4 weeks taught. ESTIMATE.
- **It's on top of the code's +$350 first-hour class,** which never changes. CHECK (Claude) that DuesLevers can hold a second class an evening.
- **Why it binds:** one class night drops owned places to 6, exactly the ordinary Need. Any fight week, pro taper or film then makes someone SHORT, and the counter says who before Start week.

### 3.3 The deal (answers Maria 2 and the long Monday)
**Buttons**
- **Coach deals it** is the default and one click.
- **Keep my changes.**
- **By hand** stays only while TANKPRICE1 shows hand-dealing beats Coach's deal by 4+ in 100. Under that, it's cut and the Protect pin carries the choice.

**Protect pin (NEW)**
- One pin on one row. Coach's deal then gives that boxer Want first, and takes the shortfall from the others in deal order.
- The pin prints its cost before Start week: "Protect the 65 kg boxer: the 60 kg boxer drops to 2 of 3".

**Deal order is row order.** Drag a row and it's dealt earlier. The order is kept week to week.

**Pulls, printed as words** (answers Maria 6). Warnings first: SCALE (over the limit inside 14 days), FIGHT WEEK, REST (tiredness 70+ or hurt). Then up to two pulls, each a labelled sticky with its size as a range:
- **WEAK SPOT:** the lowest ability the fight reads, when 3+ below the fighter's level. It adds no edge of its own (the fight already charges for it). It names who finds it: "Low Defence: pressure fighters find it". CHECK (Claude) which abilities the fight reads.
- **WEAPON:** the ability gating the next perk ("Fast hands at Speed 70: about 4 weeks").
- **GOAL:** the active goal (CODE goals).
- **AHEAD:** the next rival up the ladder, and the answers owned.

A pull asks for 2 coached mornings, or a place for AHEAD.

**A quiet week is one click.** When nothing differs from last week (no fight week, no SHORT, no talk, no twist answer due), the page shows only the counters and the rows, with "Same as last week" on Coach deals it. Press it, then Continue.

### 3.4 The fight week: one-to-one, half volume
- **When:** the 7 days before any booked bout (WeekPhase.phase, CODE TAPER), amateur or pro.
- **Sessions:** two, each one-to-one, taking a coach's whole second hour (2 places), so 4 places in all.
- **Half volume:** each session drills **180 units**, 360 for the week, half the standard 720. That's inside the real 41–60% volume cut (REAL: Bosquet et al. 2007). The rest of each hour is the fight-week bill (4.2).
- **No sparring** (CODE TAPER).
- **The row prints:** "Fight week: one-to-one, 2 sessions, half volume".

### 3.5 Coached mornings (6 owned: You 4, Coach 2)
- **Solo:** one fighter with a coach counts as a Hard morning (×1.3) without Hard's extra tiredness.
- **Shared:** two fighters on one morning get 0.8 each.
- So 6 mornings give either 7.8 concentrated on a pull, or up to 9.6 spread thin. ESTIMATE, MORNINGS1.
- Other mornings train alone at the code's rate.

Part 3 of 4

### 3.6 The gym sponsorship, and the grappler's row (answers Maria 9)
**The sponsorship is the stipend (CODE, $250 a week, Club > Money > STIPENDS)**
- **Billing:** shown and billed as the gym sponsorship in 4-week blocks ($1,000). The card prints "−$250 a week, billed per block".
- **What it gives:** 6 free mornings, no job rota, loyalty +5.
- **Who can hold one:** amateurs and the grappler. A pro can't, because the stipend stops on signing (CODE).
- **At the block's end:**
  - Renew: −$1,000, loyalty +2.
  - Pass on: the receiver +5, nobody loses.
  - Let end: 0.
- **Stopping it mid-block:** loyalty −8.
- CHECK (Claude): the stipend and the sponsorship as one record.
- Loyalty numbers are ESTIMATE.

**The grappler's row on the Club week holds only two things:**
- **SPONSORSHIP:** holds it or not. The grappler competes with the boxers for it.
- **SATURDAY CORNER:** shown only when a boxer and the grappler compete the same Saturday. Pick You, or a $100 mat coach. ESTIMATE.

**Everything else stays on the grappler page as it is today:** mat classes from the no-gi coach (NoGi.CLASSES_PER_WEEK, CODE), the open, stripe calls (StripeCall, CODE) and teaching. The grappler doesn't draw on places or coached mornings. GRAPPLE1 gates any more (v2).

### 3.7 Loyalty (0–100), every move with its cause
**Bands**
- **Loyal 70+:** can hold pads; 1 short week in 4 is waived.
- **Settled 50+.**
- **Wavering 25+.**
- **Leaving** under 25.

**Moves (ESTIMATE)**
- Need met +1; Want met +1 more.
- Short −3; short again −6.
- Promise kept +5; broken −12.
- Sponsorship given +5; renewed +2; stopped −8.
- Holding pads +3 a week.
- Stripe call: now +3, hold −5 (StripeCall, CODE).
- A team-mate let go −5.
- The talk ±4.

**Every move prints its cause:** "−3: short of a pad night this week". Overview keeps a 4-week log; the Week review shows the week's moves.

**The talk** (loyalty under 50, flag "Wants a word")
- **One talk a week for the club.** It costs your Monday, not a place. Each fighter at most once in 4 weeks.
- **The three answers:**
  1. **Give the place back:** dealt first next week, +4.
  2. **A dated promise** of a place, a bout or the sponsorship (+5 kept, −12 broken; listed under PROMISES OPEN).
  3. **Tell it straight:** the odds come from the visible Coachability, printed on the button ("holds: 60%"): +4 or −4. It shows "back in n weeks" through its 8-week cooldown.
- **Consequences:**
  - Under 25 after 2 talks: the fighter leaves next Monday for the rival club (Eastside ABC).
  - Turning pro under 50: the fighter signs with an outside manager and the club's share is 10% instead of 25% (GYM_SHARE, CODE).
- **The loop break (NEW, one line):** while morale is Low, the month-without-a-fight morale penalty (−6, CODE) doesn't apply.

### 3.8 The NEXT WEEK line
One line under the counters, read from booked bouts, camps, borrowed places and class nights. It shows only when the next two weeks differ from this one:
- "NEXT WEEK: fight week for the 65 kg boxer; Need 8 of 8. A class tonight leaves 2 SHORT."
- "IN 2 WEEKS: two fight weeks; Need 10 of 8."

### 3.9 One club twist a week (12 cards, core)
- 1 week in 4 is quiet, and the same card never comes twice running.
- **Answers:** each card has 2–3 priced answers. The clock waits for an answer; with none, Coach picks on Monday.
- **The cards:**
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
- **What it replaces:** the per-fighter WeekTwist (CODE). In the fourth start and once two fighters are signed, the club deck replaces it; a single fighter keeps WeekTwist as today. The six new cards are v2.

### 3.10 Let a fighter go (NEW)
- **Where:** a row menu.
- **Price:** the rest of the sponsorship block, or 1 week's stipend; −5 loyalty to each team-mate; the roster place is freed now. ESTIMATE.
- **Confirm:** a second press, never pre-selected.

## 4. The fight week inside the club week

### 4.1 The offer and the collision warning (answers Maria 8)
**The amateur offer stays as the code has it:** one at a time, Accept or Pass, both free (CODE, pack 4.5). The bout sheet's cards (Home, Name above, Unknown) and their rules belong to AMATEURWEEK1.

**This map adds one line on the bout page, above Accept (NEW):**
- "This fight week overlaps the 60 kg boxer's: Need 10 of 8, one boxer SHORT 2."
- Or "This fight week lands on a class night: Need 8 of 6, SHORT 2. Switch the class to pads, or cover a night ($80)."

It names the weight class, never a name. It appears only when the dates collide, reading ClubDeal's forecast.

### 4.2 The fight-week bill and the scale
**The bill (inside the one-to-one sessions):**
- 2 plan lines, the finish move, southpaw rounds, film (2 places), sharpening in the last 3 days.
- **Three shapes:** Rest up / Tick over / Train through.
- **One range:** "Your week against Coach's: +2 to +4 in 100" (ESTIMATE, LeverSize), plus the top 3 levers and tiredness at the first bell.

**The scale:** AMATEURWEEK1 owns weigh-in time, the allowance and the pull-out rate. Owner question 2 settles weigh-in on the day, 1 hour before (REAL: EB rule book 7.1.3), against the code's day before. The answer goes to AMATEURWEEK1 as one rule.

### 4.3 Pro and amateur side by side
| | Amateur | Professional |
|---|---|---|
| Notice | an offer by its date (CODE) | promoter's offers, about 6 weeks to the bout (CODE) |
| Before the bout | fight week only: one-to-one, half volume | camp of 4 or 6 weeks: Light / Standard / Hard (CODE), then the fight week |
| Places | 2–3 ordinary, 4 in the fight week | camp pad nights 2 / 2 / 3; 4 in the fight week |
| Rounds | 3 × 3 minutes (CODE) | 4 unranked, 6 ranked (CODE) |
| Money to the club | $450 ticket cut (CODE) | 25% of the purse (CODE); camp bill |
| Sparring | yes, not in the fight week | yes, not in the fight week |
| Sponsorship | can hold one | can't (stipend ends on signing, CODE) |

## 5. Every decision (core)
| When | Decision | Options and prices | Probe |
|---|---|---|---|
| Create | Start | Fresh doors / In debt / Backed (CODE) / Take over a club (NEW) | START1 |
| Monday | Deal | Coach deals it (default) / Keep my changes / By hand (gated); Protect pin; drag rows | TANKPRICE1 |
| Monday | Second hours | PADS (2 places) or CLASS (+$117) | MONEYFOUR2 |
| Monday | Places | Cover $80; Borrow 1; Rest week; Freed places; Hold pads | SHORTWEEK1, LOYAL1, COVER1 |
| Monday | Mornings | Solo ×1.3 or shared 0.8 each | MORNINGS1 |
| Monday | Sponsorship | give, renew, pass on, let end, stop (−8) | MONEYFOUR2 |
| Monday | Talk, twist | 3.7, 3.9 | LOYAL1, ROTATWIST1 |
| Offer | Accept (with collision line) / Pass | 4.1 | SHORTWEEK1 |
| Fight week | Rest up / Tick over / Train through | 4.2 | TAPER1 |
| Saturday | Who corners (clash only) | You / $100 mat coach | none: shown rarely |
| Any time | Let a fighter go | 3.10 | none: a rare act |

Part 4 of 4

## 6. The numbers
**MEASURED (earlier probes, four amateurs):**
- 28 bouts a year, 41 wins in 100.
- Sponsorships over a year: none gives +$31k; 4 close 80% of gyms (AMATEURPROBE1, MONEYFOUR1).
- Good plan 59%, none 45%, bad 41%; +5 stats about 72% (pack). FireLevel on (S450).

**CODE:**
- Stipend $250; first-hour class +$350.
- Ticket cut $450; win +8 members, +5 reputation.
- PAD_NIGHT 240 units; standard week 3 pad nights.
- Camp nights 2+1 / 2+2 / 3+2; TAPER 1 week out.
- NoGi 3 classes; GYM_SHARE 25%; rest week +4.
- Morale bands and corner trust.

**ESTIMATE:**
- Coach's 3 evenings; owned 8.
- Need 2, Want 3.
- Fight week 4 places at 180 units.
- Class +$117; cover $80; borrow.
- Loyalty moves; solo ×1.3, shared 0.8.
- The step slot at 2 nights.
- Mat coach $100.
- Starter data.

**Cash for the fourth start (ESTIMATE):**
- 2 amateurs at about 9 bouts each: about $8,100 a year in ticket cuts.
- The pro's 25%: about $2,000–3,000.
- 1 sponsorship: −$13,000 a year.
- 1 class night every week: +$6,100 a year, plus members.

## 7. Every menu it appears on, and what each is wired to (S425; names only in headers)
| Menu | What shows | Wired to |
|---|---|---|
| **Create, step 2** | the three starts as today, plus Take over a club (pro 1 of 2, amateurs 2 of 4, grappler) | CreateScreen, ClubStart (fourth start, 4 places, NEW), Roster.sign_fighter |
| **The guide** | one line when the second fighter signs; the fourth start's 4 steps; road strip at the first amateur's 5th win | GuideLight, FirstWeek, NextStep, Roster.pro_ready |
| **Fighters > Club week** (appears with 2+ fighters; owner OK needed) | counters with words (PLACES Need, Asked, Owned, OK / FULL / SHORT; MORNINGS; SPONSORSHIP; runway); NEXT WEEK line; second-hour magnets PADS / CLASS; Cover; Borrow; rows (header name, mood word, loyalty bar with last cause, rota or sponsorship, pulls as labelled stickies, places "2 of 3 nights", rest switch, Protect pin); grappler row (sponsorship, corner clash); Freed places; talk card; PROMISES OPEN; twist; deal buttons; Start week | ClubDeal (240-unit places, Need and Want, fight week, cover, borrow, freed, protect), DuesLevers (second class), PadWeek, WeekPhase, WeakSpot, JobRota, ClubTwist (12), Loyalty (causes), LeverSize, GymSpend (stipend) |
| **Fighter > Week** | own cells as today; shared cells say "Change on the Club week"; "Full week" or "2 of 3 nights" | WeekBoard, WeekEditors, ClubDeal |
| **Fighter > Overview** | pulls with labels and who finds the weak spot; loyalty with its 4-week log; Let go in the row menu | FighterPage, AttrBoard, Attrs, PerkRoad, Loyalty |
| **Fighter > Fight prep** | amateur: fight-week bill, one-to-one sessions, one range; pro: camp nights as places | FightPrep, FightWeek, Camp, CampCard, LeverSize |
| **Grappler page** | unchanged (classes, open, stripe calls, teaching); sponsorship line | GrapplerPage, NoGi, BjjOpen, StripeCall, Loyalty |
| **Home** | one row per fighter; "Wants a word" note; sponsorship ending; NEXT WEEK SHORT note; Club week note when the second fighter signs | Home, HomeRows, Needs, Loyalty, ClubDeal |
| **Fighters cards** | loyalty word, sponsorship or job, flag (Fight week, Set camp, Wants a word) | RosterCards, FighterCard, RosterFlag |
| **Fights, bout page** | the collision line above Accept (4.1) | BoutPage, OfferCard, ClubDeal.forecast |
| **Fights (pro)** | the promoter's offers as today, with the collision line | ProFights, ClubDeal.forecast |
| **Club > People** | Coach card with second hours as PADS / CLASS; second coach "+1 roster place, no places"; no-gi coach by the class | StaffCard, CoachAreas, ClubDeal |
| **Club > Money** | class nights (beside the +$350); sponsorship as the stipend with block dates; cover nights; pro share 25% or 10% | Money, GymBills, GymSpend, CashForecast, DuesLevers |
| **Top bar and Continue** | flags FIGHT WEEK, SET CAMP, WANTS A WORD; stops for a SHORT week with an open choice, a twist and a sponsorship end | Shell, Needs, Clock |
| **Fight night and the Why** | Why lines "Short of pads in the fight week", "Tiredness at the first bell" | FightWhy, LeverSize |
| **Monday Week review** | shortages with causes and "Give it back"; loyalty moves with causes; the month's deal against Coach's | WeekReview, WeekCause, Loyalty |
| **Pro offer** | share 25% or 10% by loyalty (TURNPRO1 owns the rest) | ProOffer, Loyalty |

## 8. Held for v2, each gated on its probe passing the cut rule
| Held | Probe |
|---|---|
| Favours (one regional pool, with AMATEURWEEK1) | SHEETDEAL1 |
| Fans and home against away | FOLLOW1 |
| Season targets and Camp leave | SEASON1 |
| Trial mat every 4 weeks | TRIAL1 |
| Six new twists | ROTATWIST1 at 18 |
| Sparring settings (Hard / Technical; Body only cut) | SPARSET1 |
| Mood alone rates | MOODRATE1 |
| Grappler in the deal (mornings, places) | GRAPPLE1 |

## 9. Probes (played bouts, 40 seeds × 52 weeks, three seed sets; the UI waits for the tables)
**Cut rule:** any choice worth under 1.5 wins in 100 on a bout, and with no season effect, is cut, not drawn.

1. **SHORTWEEK1 + LOYAL1** (3 boxers, 8 places of 240, fight week 4):
   - Asked over owned in 9/10+ weeks.
   - A boxer SHORT in 15–35% of weeks.
   - COACH's longest short run 2 or less; COACH's lowest loyalty 50+.
   - STARVE loses exactly 1 fighter a seed; EVEN stays above 60.
   - CLASS (1 a week) is SHORT in 40%+ of weeks yet gains cash.
2. **TANKPRICE1 + PROTECT1:**
   - The best hand deal against Coach's: 4+ in 100 keeps By hand; under 4 cuts it.
   - Protect against no pin: 1.5+ in 100 for the pinned boxer.
3. **VOLUME1:** mastery paces and the plan numbers at 640 and 480 units against 720. If the plan's 59/45/41 moves by more than 2, Owned rises to 9.
4. **TAPER1:** one-to-one, 360-unit fight week against a full-volume week. The taper wins 1.5+ in 100.
5. **MORNINGS1:** solo-on-the-pull against spread. Each wins in 30–70% of seeds.
6. **COVER1 / BORROW1:** cover chosen in 10–40% of fight weeks; borrow best in under 1 week in 4.
7. **MONEYFOUR2:** 1 sponsorship plus 2 class nights stays level over 52 weeks.
8. **ROTATWIST1 (12 cards):** the best deal changes in 3/4+ weeks; no answer best over 2/3.
9. **START1:** the fourth start's first 10 weeks have a SHORT week by week 4 in 60%+ of seeds.

## 10. Build order (7 rule modules, down from 12)
1. Probes 1, 2 and 3 first. Emit the LeverSize tables.
2. Pure rules, one per task:
   - ClubDeal (places, Need and Want, fight week, cover, borrow, freed, protect, forecast)
   - Loyalty (causes)
   - ClubTwist (12)
   - WeakSpot (no edge)
   - LeverSize
   - Stipend as sponsorship
   - ClubStart (fourth start)
3. Code changes, listed: the second class per evening (DuesLevers); ClubTwist replacing WeekTwist with 2+ fighters; the Low-morale loop break.
4. Screens, after owner question 1 and the drawn page: the Club week, the collision line, the Overview loyalty log, the Money lines.
5. **One golden-path test:**
   1. Fresh doors with the second fighter signing, then the Club week appears.
   2. A class night.
   3. A fight week fills the pool.
   4. Accept shows the collision line.
   5. The second fight week leaves a boxer SHORT.
   6. Cover a night.
   7. A talk.
   8. A twist.
   9. The Why line.

## 11. Owner questions and CHECKs
**Owner questions**
1. **The Club week:** OK it as a tab on Fighters, or as the Monday page that replaces the week review? Asked with the drawn page from section 12.
2. **Weigh-in on the day, 1 hour before** (the real rule) is a code change from the day before. Take it? It goes to AMATEURWEEK1.
3. **The fourth start, Take over a club,** with its own 4 roster places. Add it?
4. **The fourth start's 57 and 75 kg amateurs** have no pro table yet. Keep them, or limit starters to 60, 65 and 70?

**CHECK (Claude)**
- The coach's evenings in code.
- A second class per evening in DuesLevers.
- The stipend and the sponsorship as one record.
- StepMastery's rate at 2 pad nights.
- Which abilities the fight reads, for the weak spot.

## 12. The page for the owner (1920×1080, Look B whiteboard; drawn in the next board session)
- **Top strip (0–120):** counter magnets, each with a word and a number: PLACES "Need 6 · Asked 9 · Owned 8 · OK", MORNINGS "6", SPONSORSHIP "1 of 1", cash runway.
- **Under it (120–180):** the NEXT WEEK line in marker, only when the next two weeks differ.
- **Left (40–440), COACH'S EVENINGS:**
  - four magnets: three second hours and yours, each flippable PADS / CLASS with its price written;
  - Cover a night ($80);
  - Borrow.
- **Centre (480–1480), THE SQUAD:**
  - one row per boxer, the name once in its header cell;
  - then a mood word, the loyalty bar with its last cause in words, rota or sponsorship, WEAK SPOT / WEAPON / GOAL / AHEAD stickies;
  - the week's places as night magnets ("2 of 3 nights"), with fight-week nights drawn double and printed FIGHT WEEK;
  - the rest switch and the Protect pin;
  - the grappler's row last: sponsorship and the corner clash only.
- **Right (1520–1880):** the twist with priced answers, the talk card with its odds, PROMISES OPEN with dates.
- **Bottom (980–1060):** Coach deals it (default; "Same as last week" when quiet), Keep my changes, By hand while it survives the probe. Gold only on Start week.
- **Stress test:** two fight weeks plus a class night, with the SHORT word on the counter and on one row.

## 13. Risks
- **Volume:** an average boxer drills 11% less than today. VOLUME1 decides whether Owned rises to 9.
- **The default may still dominate.** The Protect pin and cutting By hand under 4 in 100 accept that, and put the choice where it bites: class nights, cover, sponsorship and the talk.
- **The fourth start needs its own owner OK.** Without it, the Club week only meets a player once a second fighter signs, and that's fine.

## 14. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6** (mine, not a critic's).

**To reach 10/10:**
1. Run probes 1–3 and paste the tables. Fix Owned at 8 or 9 from VOLUME1.
2. Draw section 12 at 1920×1080 and get owner question 1 answered on it.
3. Settle the five Claude CHECKs, first the coach's evenings and the second class.
4. Owner questions 2 and 3; hand the weigh-in to AMATEURWEEK1.
5. Bring back v2 items only as their probes pass the cut rule, GRAPPLE1 first, so the grappler's row carries real choices.
