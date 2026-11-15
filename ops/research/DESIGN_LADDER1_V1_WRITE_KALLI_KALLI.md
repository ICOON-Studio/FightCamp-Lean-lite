# DESIGN_LADDER1_V1_WRITE_KALLI_KALLI - Kalli answer (seat queue SQ153)

Brief: research/DESIGN_LADDER1_V1_WRITE_KALLI.md
Sent: 2026-11-15 03:10 | collected: 2026-11-15 03:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing LADDER1 v1 in full now, with reputation as the currency, the ladder screen and the probes.

# LADDER1 v1: the season ladder, with reputation as the currency (S459, S475, S477, 2026-11-15)

Part 1 of 4

This is the first map. It covers the amateur road to the first pro fight, on one regional ladder per weight class.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, `ops/research/LADDER1_RESEARCH_JOHN_JOHN.md` in full (I worked from the summary in the brief), the Miro board, the mockups and the owner's S475 note on the sparring partner screen. The owner's computer is offline. Everything here is checked against the critic pack, Claude's S477 code facts and John's summary only.

**Owner rules kept, quoted**
- **S475:** the ladder "must reach 9/10: see the ladder, find an opponent, book", with REPUTATION as the currency, not fixed win counts.
- **S428 and S425:** amateur to the first pro fight; ONE regional ladder first; every fight shows the rank earned; wired and shown on the correct menus. The living world comes after the fight week is built and played.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". How the ladder handles it is in 4.2.
- **S412:** any gym, any boxers, men or women. No fixed he or she.
- **Pack 4.5, agreed:** "a 'no' is a closed panel or an absent answer with its reason, never a random refusal". This overrules John's yes-chance (see 3).
- **Pack 7:** only actionable information. One word per concept. Nothing opens by itself. Screens only from agreed mockups, so the ladder page waits for the owner's OK on a drawn page (owner question 2).
- Classes in kg: women 57/60/65/75, men 57.5/60/70/75. Females never fight males: each ladder is one sex and one class.
- "Gym" is the facility. Amateurs have a fight week, not a camp (AMATEURWEEK1 v9: 1–2 weeks out).

**Marks**
- **REAL:** a real rule or source, as John reported it.
- **CODE:** in the code today (S477).
- **GAME VALUE:** a fixed design number that isn't meant to be tuned.
- **ESTIMATE:** ours, gated by the probes in 6. Every reputation number is ESTIMATE until those run.
- **NEW:** a rule this map adds. **CHECK:** a fact someone must confirm. **v2:** later.

**One word per concept**
- **Reputation** (0–100) is a boxer's own currency. It's a number on every screen, with the band word (2.1) beside it.
- **Standing** is the gym's reputation (CODE `Career`, today's "reputation word" on Club > People). It needs a new word so "reputation" means one thing (owner question 1).
- **Ladder** is the regional table for one sex and one class (CODE `Region.gd`), now sorted by reputation. **Place** is a boxer's position on it.
- **Ask** means your boxer asks for a named opponent. **Offer** means a bout that comes to you (CODE).
- **Chance** is the win chance shown at booking (CODE band). Reputation reads the **middle of the band the player saw**.

## 1. The currency

### 1.1 How reputation is earned (all ESTIMATE unless tagged)
**A win** gives (2 + 14 × (1 − chance)) × the win-type weight, rounded.

| Win type | Weight | Tag |
|---|---|---|
| Stoppage (RSC or KO) | 1.0 | REAL (BoxRec KO weight), used as GAME VALUE |
| Unanimous points | 0.875 | REAL (BoxRec UD) |
| Majority points | 0.55 | REAL (BoxRec MD) |
| Split points | 0.45 | REAL (BoxRec SD) |

**Worked examples**
| Chance shown | Stoppage | Unanimous | Split |
|---|---|---|---|
| 75% (safe) | +6 | +5 | +3 |
| 50% (even) | +9 | +8 | +4 |
| 30% (long shot) | +12 | +10 | +5 |

**Where the opponent sits changes it (anti-grind, NEW):**
- Opponent above you on the ladder: full value, plus **+3 for a ranked scalp**, once per opponent per season.
- Opponent 1–5 places below: half value.
- Opponent 6+ places below, or off the ladder while you're on it: 0. The win still counts on the record and still gives morale +8 (CODE).
- The same opponent twice in a season: half value the second time.

**One-off gains**
| Event | Reputation |
|---|---|
| A bout taken at short notice (offered under 14 days before the date) | +2 |
| London regional stage won (nationals) | +5 |
| National title | +10 |
| Top of the bill on your own hosted club show, and won | +3 |

**A draw** gives half the win value minus half the loss value.

### 1.2 How reputation is lost (ESTIMATE)
**A loss** costs 1 + 8 × chance, plus 2 more if stopped.

| Chance shown | Points loss | Stopped |
|---|---|---|
| 75% (lost as favourite) | −7 | −9 |
| 50% | −5 | −7 |
| 30% | −3 | −5 |

**Other losses**
| Event | Reputation |
|---|---|
| Missed weight (the club still pays $300, CODE) | −4 |
| Pulled out, not hurt | −2 |
| Pulled out hurt (the empty slot is still paid, CODE) | −1 |
| Inactive | after 8 weeks without a bout, −1 every 4 weeks |

- Suspension, injury and a nationals run pause the inactivity clock.
- A boxer leaves the ladder after 52 weeks without a bout (REAL: BoxRec's 365-day inactive rule, as GAME VALUE). The reputation is kept.

### 1.3 Where a boxer starts
- A walk-in with no bouts starts at 0.
- A prospect signed with a record starts at 4 × net wins + 2 × wins, capped at 30 (ESTIMATE).
- Ladder boxers from other clubs (CODE `Region` rows) are given reputation by the same rule when the save loads, then move by 1.1 and 1.2 whenever they fight each other at shows (CODE: rivals fight each other).
- CHECK (Claude): how many rows a regional table holds.

### 1.4 What reputation replaces (by file and constant)
| Today (CODE) | Becomes | Tag |
|---|---|---|
| `Roster.gd PRO_WINS 7` + `PRO_RANK 3` | pro offer at **reputation 55**, with the floors in 1.5 | ESTIMATE |
| `Roster.gd PRO_WINS_ANY_RANK 9` | retired (55 covers it) | NEW |
| `Roster.gd PRO_RETURN_WINS 2` | a declined offer returns at **+10 reputation** since the decline; second promoter at 0.9× terms (CODE, kept) | ESTIMATE |
| `Region.gd RANK_MIN_WINS 4` | on the ladder after **1 bout** | ESTIMATE |
| Region sort: net wins, wins, rating | **reputation**, then net wins, then rating | NEW |
| `AskBout.gd PICK_REACH 4` | ask reach **2 places + 1 per 15 reputation** (0 gives 2, 30 gives 4, 60 gives 6) | ESTIMATE |
| `AskBout.gd CAMP_WEEKS 3` | **2 weeks** minimum lead, so the fight week fits (AMATEURWEEK1 v9: no camp for amateurs) | GAME VALUE |
| `AskBout.gd SHOW_GAP_DAYS 14` | kept: 14 days between a boxer's bouts | CODE |
| `Matchmaking.gd BAND_UP 5`, `UNRANKED_REACH 15`, `TOP_ASK_FANS 3` | unchanged; pros are out of scope (8) | CODE |
| Club reputation +5 / −2 / −4 (`BoutRules.gd` about 115–123) | unchanged, renamed Standing | CODE |

### 1.5 What stays a fixed count (the real rules)
| Rule | Value | Tag |
|---|---|---|
| Novices box novices | 0–10 bouts is novice; a novice can't face an open boxer | CODE, REAL (England Boxing Rule Book 2026 2.7.8: matched on experience and weight) |
| Weight | the boxer must be able to make the class on the date | CODE |
| Bouts a season | 18 at most for seniors | REAL (2.7.9), NEW in code |
| Nationals entry | 5 bouts, 3 months registered, age 19–40 | CODE, REAL (5+ bouts) |
| Nationals draw | no seeding by reputation | REAL ("without bias") |
| Turning pro | age 18+; 5 amateur bouts at least (GAME VALUE floor, so no 2-bout pro, since BBBofC has no fixed minimum John could find) | REAL / GAME VALUE |
| Rest | a stoppage loss gives a 30-day suspension and the next bout 8 weeks later | CODE |
| Sexes | a boxer sees only their own sex's ladder | owner rule |

**The season** is the game year from Monday 5 January (GAME VALUE). It counts the 18-bout cap, the once-a-season scalp and the repeat halving. Reputation carries across seasons. CHECK (John): England Boxing's season dates.

Part 2 of 4

## 2. The choice and its depth

### 2.1 What reputation opens (only what the player can act on)
| Reputation | Band word | Opens | Tag |
|---|---|---|---|
| 0–14 | Unknown | asks 2 places up | ESTIMATE |
| 15–29 | Known locally | asks 3 places up | ESTIMATE |
| 30–44 | Rated | asks 4 places up | ESTIMATE |
| 45–54 | Contender | asks 5 places up; the pro offer is in sight ("10 to go") | ESTIMATE |
| 55+ | Pro-ready | the promoter's offer arrives (with the floors in 1.5), then asks 6+ places up | ESTIMATE |

**Cut from John's unlock list, for now:**
- **Top of the bill at 40:** on other clubs' shows the player can't act on it. On your own show you pick the headliner anyway.
- **Sponsors at 30/50/70:** sponsorships follow gym Standing (K88).
- **Rival clubs' offers at 35:** the R58 world isn't built.

All three are v2.

### 2.2 The four decisions
1. **Who to ask.** Asking above you pays full value plus the scalp. Asking below pays half, or nothing at 6+ places down. Every row prints both sides before the click ("Win +9 and the scalp +3, to 4th. Loss −4, stay 7th").
2. **When to wait.** The best target may be BOOKED or RESTING (3). Waiting costs nothing for 8 weeks, then −1 every 4. Taking an offer from below now pays half and risks the loss cost. The ladder card prints the date the target is free.
3. **When to take a long shot.** A 30% chance pays +10 to +12 plus the scalp, against −3 to −5 for a loss. **The shown chance doesn't count the plan you haven't written yet.** A good plan is worth about 59% against 45% for no plan (MEASURED, pack 1), so a player who studies the tape and writes the plan in the fight week turns long shots into the best value on the ladder. That's the skill reward. CHECK (Claude): that the band on the bout page leaves out the plan.
4. **When to defend a place.** Boxers within 3 places below send offers through the normal offer flow (CODE: one at a time, Accept or Pass, both free). Accepting risks −7 as the favourite for half value. Passing is free, but the inactivity clock runs, and a rival who wins elsewhere climbs past on reputation. A place matters because it sets who is "above you" for full value and scalps, and how far up the ask reaches.

### 2.3 A safe win and an upset, side by side
| | Safe (75%, 2 places below, unanimous) | Upset (30%, 3 places above, stoppage) |
|---|---|---|
| Reputation | +2 (half of 5) | +12, plus the scalp +3 = +15 |
| If lost | −7 | −5 |
| Morale | win +8 / loss −12 (CODE) | same |
| Risk | normal | a stoppage loss means a 30-day suspension and the next bout 8 weeks later (CODE) |
| Club Standing | +5 a win (CODE) | +5 a win (CODE) |

### 2.4 How the gym's Standing and the boxer's reputation meet
1. **Standing is still fed by wins** (CODE +5 / −2 / −4), so the boxer's road keeps the club growing (members, sponsors through K88).
2. **Standing gives pull in an ask:** a gym in the top Standing band counts as +5 reputation in the "not enough in it" check (3). ESTIMATE; CHECK (Claude) the Standing band names.
3. **The hosted club show** ($3,500, tickets $25, up to 400 seats, every 16 weeks, CODE):
   - **Bring them to your show:** invite any ladder opponent who said NOT ENOUGH IN IT, up to 15 reputation beyond the line, if you pay their travel ($150, ESTIMATE, owner question 3).
   - **Headliner:** your headliner's reputation adds to the tickets sold (NEW, ESTIMATE; CHECK Claude what the show's ticket count reads today), and a headline win gives +3.
   - **The trade:** a show can lose money (CODE), so an invite is a money-for-reputation choice.
4. **Prospects** signed with records arrive with reputation (1.3), so Standing's pull on signings matters through Find a fighter (CODE).

### 2.5 Ties to what exists
- **The fight week (AMATEURWEEK1 v9, CLUBWEEK1 v8):** an ask books 2+ weeks out, so the fight week (TAPER, 1 week out, CODE `WeekPhase`) always fits. If the date lands on another boxer's fight week or a class week, the card shows CLUBWEEK1's collision line ("This date lands on the 60 kg boxer's fight week: BAG 2"), with **Next date** beside it.
- **Sparring partners (S475 note, CHECK: not opened):** sparring gives no reputation (REAL: sparring isn't on the record). The sparring partner screen lists an outside partner's style ($160, CODE) and marks the one whose style matches the asked opponent. No other link until the note is read.
- **The pro offer (TURNPRO1):** it arrives at reputation 55 with the floors in 1.5, in the existing Pro offer modal (CODE: the debut money picture, "tickets she sells"). Tickets read reputation (CHECK Claude). Turning pro sets the starting pro fans to reputation ÷ 10, rounded down (ESTIMATE), so a 55 becomes 5 fans. That puts `TOP_ASK_FANS 3` within reach without retuning Matchmaking.
- **Weight:** an ask whose date the boxer can't make shows OVER WEIGHT with the scale forecast and the later date (CODE later-date path, pack 4.4).
- **The nationals:** entry stays 5 bouts (CODE). While in the run, no asks and no offers (CODE). A won stage and a title give reputation (1.1).

### 2.6 The dominant strategies checked
| Strategy | Why it looks strong | Why it doesn't win (ESTIMATE; probe 6 must confirm) |
|---|---|---|
| **Safe wins only** (75%+) | about 3 a bout on paper | safe opponents sit below, so they pay half or 0, and a loss as favourite costs −7. The worked average comes to about +1 a bout, so about 50 bouts to reach 55, beyond the 18-a-season cap |
| **Ask up always** (30%) | +15 a win with the scalp | wins 3 in 10 at the shown chance, and stoppage losses bring suspensions and 8-week waits that burn the season. About +2.6 a bout, and the inactivity clock runs while resting |
| **Even, above you** (45–60%) | the intended road | about +4 a bout, so about 14 bouts and a season and a bit to 55, with plan skill moving it faster |
| **Sit at a high place and wait** | no losses | inactivity costs 1 every 4 weeks after 8, rivals pass on reputation, and waiting earns nothing toward 55 |
| **Grind one weak club's boxers** | easy wins | the 6+ places-below rule gives 0, and repeats give half |
| **Host every show and invite up** | buys long shots | $3,500 every 16 weeks at most (CODE), plus travel, and the show can lose money |

**What should win:** steady bouts against boxers just above, with a written plan, plus long shots when a found tell gives an edge the band doesn't show.

Part 3 of 4

## 3. A refusal that teaches
**No rolls.** The answer to an ask is worked out from shown numbers, so it's printed on the row before the player clicks. That keeps the pack's agreed rule ("never a random refusal"). John's yes-chance is rejected for that one reason: a shown percentage that then says no is still a random refusal. The fight's own dice stay the fight's.

**Every row carries one word, and the card says why and what turns it to YES:**

| Word | Why (the card's line) | To get a yes (the card's line) | Source |
|---|---|---|---|
| **YES** | "The opponent's corner takes it." | none | NEW |
| **OUT OF REACH** | "Asks reach 4 places up; this is 6 up." | "Reach 6 places up at reputation 60 (now 41)." | ESTIMATE |
| **NOT ENOUGH IN IT** | "The opponent is 22 above; corners say yes within 15." | "Yes at reputation 47, or bring them to your show ($150 travel)." | ESTIMATE |
| **BOOKED** | "The opponent is booked on 14 Mar." | "Free from 28 Mar: ask then." | CODE (SHOW_GAP_DAYS 14) |
| **RESTING** | "Stopped on 2 Feb; out 8 weeks." | "Free from 30 Mar." | CODE |
| **NOVICE / OPEN** | "Novice against open is not allowed." | "Your boxer is open at 11 bouts (now 8)." | CODE, REAL |
| **OVER WEIGHT** | "On the day: 61.4 of 60 kg." | "Makes weight by 28 Mar: Next date." | CODE |
| **SEASON FULL** | "18 bouts this season." | "Opens again on 4 Jan." | REAL |
| **YOUR BOXER IS OUT** | "Suspended until 3 Mar." | "Ask from 3 Mar." | CODE |

**Rules for the refusals**
- Rows are never hidden or silently greyed. A refused row stays readable with its word.
- **Within reach** is the default filter. **All** shows the whole ladder.
- **Never a hidden gate:** every gate in 1.4 and 1.5 has a word in this table. The NEXT STEP line on the fighter page names the next one ("Pro offer at reputation 55: 14 to go").

## 4. The screen

### 4.1 Where it sits
- **Fights, under OFFERS ON THE TABLE:** a LADDER block, one ladder at a time, picked by the fighter tabs (portrait and class). This is the agreed "Ask for a fight sits under the offers" (MENU_STRUCTURE_S402), now built as the ladder.
- **World > Rankings** keeps the read-only table, now sorted by reputation, with a Reputation column and a link, "Open on Fights".
- The owner OKs the drawn page first (owner question 2).

### 4.2 Names (S448)
- The page header holds the ladder title ("WOMEN'S 60 KG: LONDON REGIONAL") and your selected boxer's name once.
- **A ladder row's name cell is that row's header,** the one place an opponent's name sits. Opponents need names to be told apart, and a row is a header for that opponent. Each name appears once per row, in that cell only.
- The card's header repeats the selected opponent's name once.
- **Never a name in** buttons ("Ask for this bout"), chips, Why lines, To-get-a-yes lines, the result line or the week review. They say "the opponent", "your boxer", "her" or "him" (that fighter's own), or the weight class.

### 4.3 The page at 1920×1080 (Look B whiteboard; drawn in the next board session)
**Top strip (120–220)**
- Your boxer's reputation bar, 0–100, with pins at 55 (pro offer) and the next reach step.
- The band word and the number.
- One "what next" line in marker, from the rules: "Win once above you to pass 45: reach 5 places up."

**Season strip (220–300)**
- The next 26 weeks as day cells: club shows (every other Saturday, CODE), booked bouts, fight weeks, the hosted show, nationals entry close (week 10).
- Bouts this season: "7 of 18".

**The ladder (left, 40–1260)**

Rows, top place first. Your boxer's row is highlighted with the portrait. Each row shows:
- the place, and an arrow for movement since last Monday;
- the name cell (the row header);
- club;
- record with a NOVICE or OPEN tag;
- reputation;
- style word (CODE);
- last bout (date, W/L, how);
- chance band (CODE, wider when unscouted);
- **Win** "+9, to 4th" and **Loss** "−4, stay 7th";
- the answer word from 3.

Filters: **Within reach** (default) and **All**. Up to 20 rows; CHECK the table size.

**The card (right, 1300–1880)**, for the selected row:
- the name header and the tale of the tape (record, age, height, reach, stance; CODE);
- the chance and how sure it is;
- the date: the earliest show both can make, 2+ weeks out, with a **Next date** chip;
- CLUBWEEK1's collision line, only when there is one;
- "Win gives / loss costs" with the parts on hover (chance, win type, place, scalp);
- the answer word with Why and To get a yes;
- one gold button, **ASK FOR THIS BOUT**, shown only on YES;
- **Bring them to your show** only on NOT ENOUGH IN IT, with a show booked.

Green stays on CONTINUE only.

### 4.4 Clicks to a booked bout: 2
1. Click a row.
2. Click ASK FOR THIS BOUT.

The bout is booked on the card's date, the same as Accept on an offer (CODE: the poster reveal, then the fight-week note on Home). Withdrawing before Continue is free. After Continue it's a pull-out (−2, 1.2). The quiet path for a player who doesn't ask is unchanged: offers still arrive (CODE).

### 4.5 Every fight shows the rank earned (S428)
- **Before the bout:** the offer card, the versus screen and the bout page show "Win +9, to 4th. Loss −4, stay 7th." (S410 versus screen: "what a win and a loss change").
- **The result screen,** under the scorecards: "Reputation 31 to 43 (+12: won from 30%, stoppage). Ladder 7th to 4th." Hover lists each part. A loss reads "Reputation 43 to 37 (−6: lost as favourite, points). Ladder 4th to 6th."
- **The Why:** unchanged (plan, against you, next). The NEXT line may name the ladder only when the next gate is one bout away ("One win above you: pro offer").
- **The week review** gets one row per boxer who fought or moved: "Ladder 4th, up 3. Reputation 43." It also lists inactivity losses and rivals who passed, with the cause ("The 5th-placed boxer won on Saturday: now above you"). The rows land one at a time (CODE), with the biggest move last.
- **History:** each bout row gains "Reputation +12, 7th to 4th".

## 5. Every menu it appears on, and what each is wired to (S425)
| Menu | What shows | Wired to |
|---|---|---|
| **Fights > LADDER** (owner OK needed) | fighter tabs, reputation bar with pins, what-next line, season strip, rows (4.3), filters, card, ASK FOR THIS BOUT, Bring them to your show, Next date | Ladder (NEW), RepRules (NEW), AskAnswer (NEW), AskBout (reach, lead, gap), Region, ClubDeal.forecast, WeekPhase, Fixtures |
| **Fights > OFFERS ON THE TABLE** | each offer card gains "Win +n, to place. Loss −n" | OfferCard, RepRules.preview |
| **Versus screen / bout page** | the same line; ranks at stake read reputation | BoutPage, BoutCompare, RepRules.preview |
| **Fight night result** | the reputation and ladder line with hover parts | FightResult, RepRules.apply, RepLedger |
| **The Why** | NEXT may name the ladder gate when one bout away | FightWhy, ProGate |
| **Week review** | ladder and reputation row with causes; inactivity; rivals who passed | WeekReview, RepLedger, Ladder |
| **Home** | YOUR FIGHTERS rank column reads "4th · 43"; Since last Monday gives rank moves with causes; a Pro offer need (CODE) | Home, HomeRows, RepLedger, ProGate |
| **Fighter > Overview** | NEXT STEP road ("Pro offer at reputation 55: 12 to go"; reach step); reputation in the header beside record and rank | FighterPage, ProGate, RepRules |
| **Fighter > History** | reputation and place per bout | History, RepLedger |
| **Fighters > Roster cards and table** | rank tile with reputation; the table's Rank column sorts by reputation | RosterCards, FighterCard, Ladder |
| **Fight prep** | VS header shows the reputation at stake | FightPrep, RepRules.preview |
| **World > Rankings** | read-only ladders sorted by reputation, with a Reputation column and Open on Fights | World.gd, Ladder |
| **World > News** | only your boxers' ladder moves and the rivals who passed them | WorldNews, RepLedger |
| **World > Championships** | unchanged (5 bouts, no seeding); won stages add reputation | Championships, RepRules |
| **Pro offer modal** | arrives at 55 with floors; tickets read reputation; starting fans | ProOffer, ProGate (replaces the Roster constants) |
| **Club > Money > CLUB SHOW** | headliner pick; invites with $150 travel; tickets read the headliner | ClubShow, AskAnswer, GymBills |
| **Club > People > MEMBERS** | "reputation word" renamed Standing | Career (label only) |
| **Fixtures / FightPoster** | asked bouts listed; the poster shows each boxer's place | Fixtures, FightPoster |
| **Office desktop** | fighters' flags read the ladder; nothing new | OfficeDesk |
| **Records** | milestones: entered the ladder, first scalp, reached 55 | Records, RepLedger |
| **Handbook** | Reputation, Standing, Ladder, Ask: one entry each | Handbook |
| **Top bar** | no new flag (PRO OFFER exists, CODE) | Shell |

Part 4 of 4

## 6. Probes (played bouts, 40 seeds × 2 seasons, all 8 classes, three seed sets; no screen before its table)
**Baseline first (BASE0):** today's fixed counts (7 wins + top 3, or 9). This measures the median weeks to the pro offer, so the new ladder is judged against a real number, not a guess.

**Bots**
| Bot | What it does |
|---|---|
| ASKUP | always asks the highest YES above |
| SAFE | takes only 65%+ chances, offers or asks |
| WAIT | climbs to the top 5, then fights only at 60%+ and waits for a target otherwise |
| COACH | default play: takes offers as they come, asks when the best YES pays more than the best offer |
| PLAN | COACH plus long shots when a found tell answers the opponent's weapon |
| RANDOM | random choices |

**Pass lines (ESTIMATE; a failed line retunes 1.1–1.2, not the screen)**
1. **No dominant road:** no bot reaches the pro offer more than 20% faster than the median of all bots. SAFE and ASKUP are each at least 15% slower than COACH.
2. **Skill shows:** PLAN reaches the offer 10–25% faster than COACH.
3. **Pace:** COACH's median weeks to the offer is within ±25% of BASE0. The road keeps its length and loses its fixed gate.
4. **Risk is real:** ASKUP's stoppage losses are 1.5× SAFE's or more.
5. **Waiting costs:** WAIT drops out of the top 3 within 16 weeks of stopping in 60%+ of seeds.
6. **Asks are worth it:** an asked bout beats the best offer that week in reputation-per-bout by 1.5+ for COACH. This is the bot test the pack asks for (R37). If it fails, the ask stays an offer filter only.
7. **Refusals are reachable:** every refusal word turns to YES within 8 weeks in 70%+ of the cases where the player follows its To-get-a-yes line.
8. **Spread:** the top 5 of each ladder sit at reputation 45–75 at week 52, and no ladder has 3+ boxers over 55 for longer than 8 weeks.
9. **Grind shut:** a bot fighting only boxers 6+ places below reaches 55 in 0 seeds.
10. **Honesty test:** 100% of results and week reviews print the rank line, and the parts on hover sum to the change.

## 7. Build order (small pieces; pure rules first, each with its test)
1. **RepRules** (pure): earn and lose (1.1, 1.2), anti-grind, the preview for a given chance and place. Test: the worked tables in 1.1 and 1.2 as fixtures.
2. **RepLedger** (pure): each change with its cause, read by the result, the week review and History. Test: the parts sum to the change.
3. **Ladder** (`Region` change): sort by reputation, entry after 1 bout, rival reputation at load (1.3), inactivity, drop-off at 52 weeks. Test: seeded ladder order.
4. **AskAnswer** (pure): the answer word, Why and To get a yes from shown numbers only (3). Test: one fixture per word, and no randomness (same input gives the same answer).
5. **ProGate** (replaces the `Roster` constants): 55 plus the floors, the +10 return, starting fans. Test: the four fixtures.
6. **AskBout wiring:** reach, the 2-week lead, the 14-day gap, the 18-bout cap. Test: the cap and lead fixtures.
7. **Probes** BASE0 and 1–10. Tune, then freeze the numbers.
8. **Lines on existing screens:** the result line, week review row, offer and bout page preview, Home rank column, NEXT STEP, World > Rankings column. The Standing label waits for owner question 1.
9. **The LADDER block on Fights,** after the owner's OK on the drawn page.
10. **Hosted-show invites,** after owner question 3.
11. **Golden-path test:**
    1. Fresh doors; first bout won; the boxer enters the ladder.
    2. An OUT OF REACH row shows its line.
    3. A win above with the scalp; the result line.
    4. The week review row.
    5. An ask in 2 clicks.
    6. A NOT ENOUGH IN IT turned by a show invite.
    7. Reputation 55; the pro offer.

## 8. What it does NOT do, and owner questions
**Out of scope, after the fight week is built and played (S428):**
- the national ladder, the mandatory challenger and the eliminator;
- rivals who age and move between clubs; judges with taste;
- belts, world bodies, divisions beyond the code's, TV;
- pro matchmaking changes (fans stay the pro currency, apart from the starting fans);
- sponsors and rival clubs' offers tied to reputation; clips;
- box-offs (REAL: only when a panel asks);
- reputation for BJJ (the belt is the ladder, CODE).

**Owner questions (scope, money, taste)**
1. **Words:** the boxer's is "Reputation" and the gym's becomes "Standing". Yes?
2. **The screen:** the LADDER block on Fights, under the offers, as drawn in 4.3. OK to draw it?
3. **Money:** inviting an opponent to your hosted show costs $150 travel. Yes, or free?
4. **Taste:** show reputation as a number (0–100) with the band word, or the word only with the number on hover?

**CHECK (Claude)**
1. Regional table size.
2. Whether the bout-page band leaves out the plan.
3. What the club show's ticket count reads.
4. The Pro offer's ticket line.
5. The Standing band names.
6. AskBout's callers once wired.

**CHECK (John):** England Boxing's season dates.

**CHECK (Kalli):** the owner's S475 sparring partner note, before 2.5's sparring line is final.

## 9. Self-score: DEPTH 6, GENERAL DESIGN 7, PLAY 6 (mine, not a critic's)
**To reach 10/10**
1. Run BASE0 and probes 1–10, paste the tables, and retune 1.1–1.2 until all ten pass. Every number here is an ESTIMATE until then.
2. Draw 4.3 at 1920×1080, with the row states and the card for YES, OUT OF REACH and NOT ENOUGH IN IT, and get owner questions 1–4 answered on it.
3. Read the S475 sparring note and CRITIC_ACCESS.md, then wire the sparring partner screen properly instead of the style-match stub.
4. Make defending a place matter more than reach and scalps. Candidates, held until probe 5: the promoter's debut terms by ladder place, or the regional stage's draw date.
5. Give the AI corners a visible character beyond the numbers, as a first slice of the living world. Only after the fight week ships (S428).
6. Bring sponsors (K88) and rival clubs' offers onto reputation once R58's world runs.
