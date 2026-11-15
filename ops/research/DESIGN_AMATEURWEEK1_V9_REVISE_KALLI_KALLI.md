# DESIGN_AMATEURWEEK1_V9_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ144)

Brief: research/DESIGN_AMATEURWEEK1_V9_REVISE_KALLI.md
Sent: 2026-11-15 01:10 | collected: 2026-11-15 01:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing AMATEURWEEK1 v9 in full now. It answers every point in the owner's S475 notes: trips go and the sparring partner screen comes in, tells and mood get shown on screen, and the season ladder moves to its own map.

# AMATEURWEEK1 v9: the amateur fight week, design map (S459, S475, 2026-11-15)

Part 1 of 4

v9 is a full map. It replaces v8 (seat SQ88), and nothing outside this page stands.

**What decides this version:** the owner's S475 board notes on v8 (Q-S294-229), with Claude's six changes. The John SQ80 and Dola SQ79 points that v8 settled are kept and listed in 0.3.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board and the mockups. The owner's computer is offline, so this map is checked against the critic pack, v8 and the S475 notes only.

**Number marks**
- **GAME:** in the code or the pack today.
- **MEASURED:** from a probe already run.
- **ESTIMATE:** ours. None prints on screen before its probe (section 11).
- **NEW:** a rule this map adds.
- **[R]:** a real-world source, carried from v8 and John's work.

**Owner rules kept, quoted**
- **S475:** "4.1 looks like useless logistics and painin the ass for the player, either remove it or adjust it. make the sparring partner mandatory".
- **S475:** "a screen where left side is players fighter in the middel is a list of sparring partners and ton the right athe opponents card (whatever its know about him) so the player can make comparison and decide what sparring partner he needs".
- **S475:** "season ladder needs tobe at least 9/10 (maybe make reputation play bigger role …)". That's a map of its own, LADDER1.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule".
- **S412 SANDBOX:** "the player runs any gym with any boxers, men or women". No fixed he or she.
- Females never fight males. Slots and sparring partners are by sex and class.
- **Section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- "Gym" is the facility; "camp" is pre-bout preparation only. Amateur bouts have no camp, so this is the FIGHT WEEK.
- **S455:** Look B, the gym whiteboard. Everything new ships switched ON. Screens come only from agreed mockups.

**Words:** "under 4 wins", never "novice". Classes in kg. Stats use the Attrs names.

## 0. Every point answered

### 0.1 The owner's S475 notes
| # | The owner's point | v9 |
|---|---|---|
| O1 | "4.1 looks like useless logistics … remove it or adjust it" | **Removed.** Trips, food, cottage, commute, the COACH AWAY card and the trip payer rows are gone. Savings and SKINT went with them, since they existed only to pay for trips |
| O2 | "make the sparring partner mandatory"; a three-column screen | **Done (4.1).** CHOOSE A SPARRING PARTNER: your boxer on the left, the partner list in the middle, the opponent's known card on the right. No sparring night locks without a partner, and none is pre-selected |
| O3 | "4.4 is connected to other things like scouting and film?" | **Yes, now on purpose (4.1, 5).** A partner can only match what's known about the opponent. Each filmed tell adds a match point a partner can share. With nothing filmed, the best match possible is PART, and the screen says "film to find a closer partner" |
| O4 | "4.8 … easy to see the ladder and find an opponent and book a fight … at least 9/10 … reputation" | **Moved to LADDER1.** SEASON is cut from this screen. The bout sheet keeps only what the fight week needs (2), and the nationals entry, the pro road, the assistant picking the bout and the goal types go to LADDER1 with the reputation question |
| O5 | "how is this [tell truth] shown to the player?" | **Drawn (5.2).** Four words on the opponent's card and on every plan line that relies on the tell: "seen on tape: likely", "seen twice: very likely", "confirmed in the fight", "didn't happen" (crossed out). The hover gives the odds |
| O6 | "need to explain to me how this [look again / next group] works" | **Explained (5.3) and printed on the film magnet** as one line with the screen's own count |
| O7 | "How is mood gained and what affects?" | **Answered (6)** from the code's mood events, with what mood does in the corner. Fight week adds one mood move and shows mood in the header and on TONIGHT |
| O8 | "I am not sure about the trip mechanic" | **Cut** (O1). The round-1 edge the trips gave moves to a CLOSE partner match |
| O9 | "I want to see 9s frame" | **Read as: show the screen at a 9/10 standard.** Section 9 specifies both frames at 1920×1080. The PNG boards are the next design session, one board each. Owner question 1 checks this reading |

### 0.2 Claude's S475 changes
| # | Change | v9 |
|---|---|---|
| C1 | 4.1 becomes CHOOSE A SPARRING PARTNER, mandatory, three columns; an outside partner costs a favour or a fee, paid by the club | Done (4.1). The fee is $160, the camp's outside partner fee (GAME) |
| C2 | Sparring tied to scouting and film | Done (4.1 match points) |
| C3 | SEASON becomes LADDER1 | Done (O4) |
| C4 | Tells shown in plain words on the card and the plan line | Done (5.2) |
| C5 | Look again vs next group explained on screen | Done (5.3) |
| C6 | Mood: what moves it, what it does | Done (6) |

### 0.3 Kept from v8 (John SQ80, Dola SQ79)
- **The two-layer tank (J1)** and Eat less at 4 off (J2).
- **Rest up at 65+** reads "Sharp, no boost" (J2).
- **One weight rule** with the EB gap at club shows (J3).
- **The pull-out roll** on the Monday of fight week (J4).
- **Each changed line goes back to UNSPARRED,** with a warning first; the player picks which two lines a night readies (J5).
- **Swap** on a shared slot (J6).
- **Film:** locked on a debutant; "cleared as false" (J7).
- **The pack changes listed (J8).**
- **Probes before prints (D1); systems first (D2); the readiness line (D4); the next-stop hover (D5).**
- **No longer needed:** v8's cottage refund answer (J4) and the stipend and savings answer (J8), because trips and savings are cut.

## 1. The idea

An amateur bout is booked 1 to 3 weeks out and has no camp. The FIGHT WEEK screen covers the bout's last two weeks:
- **2+ weeks out:** a WEEK BEFORE strip sits on its own row. It holds the week-before sparring night and film.
- **1 week out:** fight week only.
- **3 weeks out:** week 1 is a normal BUILD week on the week board.

For an amateur bout, the WEEK BEFORE strip replaces PEAK and the fight week's load stop replaces TAPER. That needs a WeekPhase amateur branch (NEW; CHECK Claude, since today a 2-week amateur bout gets PEAK).

**The player's choices in fight week:**
1. Who to spar, and when.
2. How hard to train.
3. How to make the weight.
4. What to film.

Every choice lands on ON FIGHT NIGHT, which has two rows: TONIGHT and BANKED.

## 2. The bout sheet (only what the fight week needs)

**Slots by class:**
- A show offers slots by sex and class, at most three cards on a sheet.
- When two of the club's boxers share a kg class, the slot defaults to the longer wait. A **Swap** button gives it to the other boxer, whose card says "this slot went to your other 65 kg boxer" (NEW).

**Pass:**
- Passing a sheet is free.
- Refusing a card a club offered by name counts against that club: two refusals in 8 weeks lock that club out for 8 weeks. The card shows "refused n of 2".

**Rematch:** a boxer met before is marked REMATCH, and last time's tells come back as "seen on tape: likely".

**Lead time (NEW, pack change):** amateur offers land 1 to 3 weeks out. Set camp never appears for amateur bouts.

**Rest window:**
- Set on the boxer page's Fights tab: "next bout no sooner than 3 / 5 / 8 weeks", default 3.
- It can't be shorter than the 30-day suspension or `Matchmaking.STOP_REST_WEEKS` (both GAME).

**Ring rust:** 6 weeks READY without a bout puts the boxer FLAT in round 1.

**Home and away:** home gives the $450 ticket cut, +8 members and +5 reputation (GAME). Away means a ranked chance, judged in LADDER1.

**Favours with a host (0 to 3, NEW):**
- Earned by filling a late gap.
- Spent on Ask for a kilo (4.4) or on an outside sparring partner (4.1).

**Moved to LADDER1:** the nationals entry count, the pro road (9 wins), the assistant picking the bout, the rank and money goal types, the loss-below rule and the pro pace. Until LADDER1 lands, the game's current rules stand (GAME).

Part 2 of 4

## 4. The fight week screen

### 4.1 CHOOSE A SPARRING PARTNER (NEW screen, mandatory, replaces WHERE TO TRAIN)

**When it opens:**
- Pressing a sparring magnet on the fight week screen opens it. It's a press, so nothing opens by itself.
- A sparring night with no partner stays an empty magnet. The red **Lock the week** button is greyed with the reason "pick a partner for Thu".
- No row is pre-selected. Your assistant's choice carries a small marker note, "your assistant's pick", with its one reason.

**LEFT, your boxer:**
- Portrait and name (the header), the class in kg, stance, height and reach (GAME since S450), the style word.
- The plan lines this night will ready, with a tick beside each of the two picked.
- The three stats that matter for this matchup, read from the opponent's style. For example, against a Pressure fighter: Footwork, Defence, Stamina.

**MIDDLE, the partner list (at most 6 rows):**

| Row type | Who | Cost | What's known about the partner |
|---|---|---|---|
| Club boxer | same sex, within one class | free | style, stance, size, level, every habit (your coach's notes) |
| Club member | always one row | free | stance only. No style, level "below". The test reads "?" on Beats it |
| Partner at another club | 2–3 boxers from nearby clubs on the region table, same sex, within one class | $160 (GAME, the camp's outside partner fee) or 1 favour with that club's host | style, stance, size, level, plus any tell your gym found on them before |

**Each row shows:**
- The partner's style word, stance, size against the opponent ("2 cm shorter reach"), and level (above / level / below).
- The cost.
- The match word with its points.
- What the night readies.

**RIGHT, the opponent's card (only what's known):**
- Record, style word, stance, height and reach. These are free at booking (GAME, S410 tale of the tape).
- Each filmed tell, with its truth word (5.2).
- Every unfound line reads "?" with what opens it ("film night: next group").

**THE MATCH (NEW, ESTIMATE points):**
A partner scores a point for each known fact they share with the opponent:
- **Same style word:** 2.
- **Same stance:** 1.
- **Reach within 5 cm:** 1.
- **Each filmed tell the partner also does:** 1.

| Match | Points | Round-1 edge (moved from v8's trips) | Plan test |
|---|---|---|---|
| CLOSE | 5+ | +1.0 against this opponent (about 1 to 1.5 wins in 100) | Beats it / Works / Walks into it, as trusted |
| PART | 3–4 | +0.5 | the same ratings, marked "likely" |
| LOOSE | 0–2 | 0 | Works / Walks into it only; Beats it shows "?" |

- **Unscouted opponent:** with no filmed tell, the most points possible is 4 (style, stance, reach), so the best match is PART. The middle column's header says "film a tell to find a closer partner". This is the link to scouting and film the owner asked for.
- **Level:**
  - **Above:** the night's injury risk ×1.15 (ESTIMATE, carried from v8's commute).
  - **Below:** the test reads "may flatter" beside Beats it.
  - **Level:** neither.
- **Every match readies lines.** The match changes the round-1 edge and how far the test can be trusted, never whether lines get readied.
- **Females never fight males:** only same-sex partners are listed (owner rule).

**Buttons:** Spar with this partner (one per row), Back to the week. A row whose cost can't be paid is greyed with the reason ("no favours with this host", "cash under $160").

### 4.2 THE TANK (two layers, kept from v8)
The tank is the energy ceiling at the first bell.

| Layer | Parts | Cap |
|---|---|---|
| Tiredness | 1 off for each point of start tiredness over 50 | 25 |
| Choices (after it, uncapped) | Tick over 6, Train through 12; each fight-week sparring night 3, or 5 at 5 or fewer days out; Eat less 4 | none |

**Worked at start tiredness 75:**
- **Rest up:** 0 off, since tiredness is brought to 30 before the bell.
- **Tick over:** 31 off.
- **Train through:** 37 off.
- **Train through with two late nights:** 47 off.

All of these are ESTIMATES until FIGHTWEEKPROBE4. The bar shows the tiredness layer in grey and the choices in colour, each with its price in wins in 100 on hover.

### 4.3 THE WEEK'S LOAD (three stops, kept from v8)
| Stop | The week | Tank | Round 1 | Banked | After the bell | Best when (printed) |
|---|---|---|---|---|---|---|
| Rest up | three rest days | 0; tiredness to 30 before the bell | under 40: FLAT −2.0; 40–64: FLAT −1.0; 65+: Sharp, no boost (ESTIMATE) | a fifth of the pad units | nothing | start tiredness 65+, or a heavy cut |
| Tick over (default) | one rest day, volume halved [R] | 6 off | Sharp; ONE chosen line at Usable or Sharp fires a level up in rounds 1–2 | half the pad units | nothing | most weeks under 65 |
| Train through | full week | 12 off | Sharp | full pad units (720 for 3 nights, GAME) on the plan's moves, with the crossing printed ("Uppercut 27 to 31: Usable by the bell") | +6 tiredness; enters TrainingLoad (a 1.5× spike means injury ×2–4, GAME) | a plan move is within a week of a tier, or the opponent is rated 5+ below |

**Next-stop hover:** it shows the next stop's tank, round-1 and banked lines side by side, and names prices, never "best".

### 4.4 SPARRING: the night that readies a plan (kept, with the partner)
- **UNSPARRED:** a line written or changed since the last sparring night fires one level down in rounds 1 and 2. Before a change, the screen says "changing this line makes it UNSPARRED until the next sparring night".
- **Which lines:** an early night readies two lines the player picks. The default is the first two UNSPARRED lines in plan order.
- **Never confirms a tell:** only the fight does.

| Night | Price | Readies |
|---|---|---|
| Week before (8+ days out) | one pad night's mastery | two lines |
| Fight week, 7 or 6 days out | 3 off the tank | two lines |
| Fight week, 5 or fewer days out | 5 off the tank, training injury ×2.5, and a cut that ends the bout 3 in 100 (ESTIMATE; NEW, overrides TAPER's no sparring at a stated price [R] Buglioni, Boxing News 2016) | every line |

**Partners:** each night has its own partner, so two nights can use two partners.

### 4.5 THE WEIGHT (kept from v8)

**Club shows (NEW, [R] EB 7.1.3 and 2.7.8):**
- Weigh-in on bout day, 1 hour before, matched at walking weight within a gap: 2.5 kg up to 65 kg classes, 5 kg above, 2 kg for skills bouts.
- The class sets the slot only.

**Championships:** the class limit, the day before (GAME).

**Ways to make it:**
- **Eat less:** Cut 500 kcal (GAME), 4 off the tank.
- **Train it off:** 0.3 kg for +8 tiredness. It's better only under about 42 start tiredness (DERIVED, John).
- **Ask for a kilo:** 1 favour, only within 1 kg of the gap's edge.

**A miss:** the host re-matches on the night 1 in 3 (ESTIMATE; CHECK John on EB rules). Otherwise the bout is off, $300 (GAME), and 1 favour is lost.

### 4.6 YOUR ASSISTANT'S PICK
- **What it reads:** six facts, which are start tiredness, the weight's tank cost, the opponent's round-1 style, the rating gap, unsparred lines and the best partner match. It names the one fact that drove it.
- **Partner:** on the partner screen it's a marker note only, never a selection.
- **Load and weight:** "Use the pick" applies the stops.
- **Sureness:** 0.5 + rating / 200, from the GAME ratings: about 0.79 for the sessional assistant and 0.87 for the full-time one. When it's wrong, it takes the next stop and still gives its reason.
- The card says "your assistant" beside the portrait.

Part 3 of 4

## 5. Film and tells

### 5.1 The film night
- A film night costs one pad night and opens one tell group (GAME rate kept).
- **Locked on a debutant:** a magnet reads "no tape on a debutant" (GAME: no bouts means no tape).
- A tell is checked at the first corner minute where the opponent's mode matched it. A fade or slow start is checked at the round-2 minute, since amateur bouts have minutes after rounds 1 and 2 only.

### 5.2 How a tell's truth is shown (answers O5)
| State | Word on screen | Drawn as | Hover (ESTIMATE until the film test) |
|---|---|---|---|
| Filmed once | "seen on tape: likely" | marker text | "About 7 in 10 tells seen once are real." |
| Filmed twice (Look again) | "seen twice: very likely" | marker text, underlined | "About 9 in 10." |
| Seen in the fight | "confirmed in the fight" | marker text with a tick | "It happened tonight." |
| The moment came, the tell didn't | "didn't happen" | the line crossed out in marker | "The opponent was in that mode and didn't do it." |
| The moment never came | stays "likely" / "very likely" | unchanged | "The fight never gave it a chance." |

**Where it shows:**
- On the opponent's card: the right column of the partner screen, the bout card and the Tape room.
- On every plan line that relies on that tell (Playbook, Game plan).
- At the corner minute, as the same word in the corner card.

A crossed-out tell turns its plan line's tag to "relies on a tell that didn't happen". That's something the player can act on: the corner minute's "change one plan arrow" (GAME).

### 5.3 Look again or next group (answers O6)
**The rule, in plain words:**
- A plan line that relies on a tell is wasted if the tell turns out false.
- At "likely" that happens about 3 times in 10; at "very likely" about 1 time in 10.
- So **Look again** saves about a fifth of a line for every line that relies on those tells.
- **Next group** finds a new tell, each only likely. It's worth about seven tenths of a line, but only if the plan has room for a new line (a free line, or a line answering nothing found).

**So:**
- Look again pays more when 4 or more lines rely on the tells you have, or when the plan has no free line.
- Next group pays more when the plan answers many different things and has room.
- All of this is ESTIMATE until the film test.

**Printed on the second film magnet, one line each, with the screen's own counts:**
- "Look again: 3 lines rely on these tells. Makes them very likely."
- "Next group: 1 free line. Finds new tells, each only likely."

The magnet never says which is best. The counts let the player see it.

## 6. Mood: what moves it and what it does (answers O7, GAME `FighterProfile.MORALE_EVENTS`)

**What moves it:**

| Event | Mood |
|---|---|
| A win / a loss | +8 / −12 |
| A bout booked | +5 |
| A rest week | +4 |
| A month with no fight | −6 |
| A goal met / missed | up / down (GAME) |
| A night off given / refused | +4 / −4 |
| Their ask granted / overruled | +5 / −5 |
| A corner call that worked / went wrong | +1 / −2 |
| **NEW, fight week:** the bout falls through and the boxer goes home | −6 |

**What changes the size:** Heart softens losses, Confidence scales gains, and Coachability softens being overruled (GAME).

**Words:** Fired up 75+, Steady 50+, Flat 30+, Low under 30 (GAME).

**What it does:** mood is trust in the corner. The corner's words land at 1.05 Fired up, 1.0 Steady, 0.85 Flat and 0.7 Low. A Low boxer ignores shouting (GAME).

**On this screen:**
- The mood word in the header, with a hover listing the last three moves and their causes.
- On TONIGHT, one line: "Mood Flat: the corner's words land at about 85 in 100."
- What the player can do about it this week: grant the boxer's ask, give the night off, or Rest up (rest week +4).

**Cut with the trips:** v8's payer mood rows and SKINT.

## 7. Things that happen

**The pull-out roll:**
- It fires on the Monday of fight week, 5 days out, and stops the clock once as a need on Home.
- 35 in 100 per bout, inside John's sourced 25–50% [R] (Northants Telegraph 2025; Sussex Express 2015).

**The fall-through card's three answers:**
- **Take the replacement:** the host's name at short notice (GAME: tougher, double reputation on a win). The partner screen re-opens on a press, since the opponent's card changed.
- **Go home:** tiredness carries as under Rest up; mood −6.
- **Ask for next month's slot:** 1 favour, booked.

**What stays:**
- A banked week always stays.
- An outside partner's fee already paid stays paid.

**Late asks:** a host asks at most once per show, only when the boxer fits the gap and is READY, about 1 show in 6 (ESTIMATE). They land with Monday's need.

## 8. What each option changes
| Option | Changes |
|---|---|
| Swap slot | which same-class boxer gets the slot |
| Pass / refuse named card | nothing / that club's lockout count |
| Rest window | when the next sheet comes; ring rust |
| Sparring partner | round-1 edge, how far the test is trusted, injury (level above), cash or a favour |
| Sparring nights | ready lines, against tank, injury and cut risk |
| Load stop | tank, round 1, banked mastery, tiredness after |
| Eat less / Train it off / Ask a kilo | weight margin, against 4 tank / +8 tiredness / 1 favour |
| Film / Look again / Next group | which tells are known and how sure |
| Fall-through answers | the bout, mood, a favour |
| Use the pick | applies the load and weight stops, with the reason |

Part 4 of 4

## 9. ON FIGHT NIGHT and the two frames (answers O9)

### 9.1 ON FIGHT NIGHT (the one gold frame on the fight week screen)
- **Readiness line (top):** "n ready, n UNSPARRED, n tells likely, n very likely". Clicking it highlights those lines.
- **TONIGHT:**
  - The two-layer tank.
  - Round 1: Sharp, Sharp (no boost) or FLAT.
  - The partner match word and its round-1 edge.
  - Each plan line's fire share with its tag (READY / UNSPARRED) and its tell word.
  - The scale margin against the gap.
  - The mood line.
  - The win band.
- **BANKED:** the Attrs points, the moves crossing a tier by the bell, and tiredness after.
- Each row shows its change from your assistant's pick, and hovering any number shows its parts.
- No SEASON row (LADDER1). No PEAK CAMP row.

### 9.2 Frame A: the fight week screen (1920×1080, Look B)
- **Shell:** the dark top bar and left rail around a whiteboard.
- **Header (96 px):** both portraits with the names once, the class in kg, records, days to the bell, home or away, favours with the host, the scale margin now and on the day, and the mood word.
- **WEEK BEFORE strip (84 px, only 2+ weeks out):** the week-before sparring magnet with its partner's match word, and the film magnet.
- **Left (440 px):** the WEIGHT pills (Eat less, Train it off, Ask a kilo with its favour), and the film magnets with the Look again / Next group lines.
- **Centre (920 px):**
  - Seven day columns of magnets. Sparring is red, showing the partner's match word or "pick a partner". Film is tape.
  - The LOAD three-stop pill with the line picker and the next-stop hover.
  - Plan line chips with their tags.
- **Right (560 px):** ON FIGHT NIGHT in gold.
- **Bottom (120 px):** your assistant's note, **Use the pick**, and the red **Lock the week**. Green is used only for Continue.

### 9.3 Frame B: CHOOSE A SPARRING PARTNER (1920×1080, Look B)
- **Header (96 px):** "Sparring, Thu, 6 days out", your boxer's name once, and "pick one partner".
- **Left (520 px):** your boxer's polaroid, class, stance, height and reach, style word, the three matchup stats, and the two lines to ready (ticks).
- **Middle (760 px):** up to 6 partner rows on cream paper. Each row has a silhouette or portrait, style, stance, reach against the opponent, level, cost, match word and points, "your assistant's pick" note on one row, and **Spar with this partner**.
- **Right (520 px):** the opponent's card: polaroid, record, style, stance, size, filmed tells with their truth words, and "?" lines with what opens them.
- **Bottom (120 px):** "film a tell to find a closer partner" (when no tell is filmed) and **Back to the week**.
- **Gold:** on the picked row's match word only.

## 10. Menus: every place the mechanic appears (S425)
| Menu | What it shows / lets you do | Wired to |
|---|---|---|
| Home (needs) | an open sheet; the Monday-of-fight-week need (pull-out roll, asks) | Needs, BoutSheet, Clock |
| Office desktop | sheet and bout dates for the next four weeks | Desktop (built), BoutSheet |
| Fights rail page | up to 3 cards, Pass, "refused n of 2", Swap | BoutSheet, RegionShows |
| Bout card / versus screen | REMATCH, the weight gap, the tells with truth words | BoutSheet, OppFile, WeighGap (NEW) |
| Boxer page, Fights tab | rest window 3 / 5 / 8 | Matchmaking |
| Fight week screen | strip, magnets, LOAD, WEIGHT, film lines, ON FIGHT NIGHT, the pick | FightWeek, WeekPhase (amateur branch), PadWeek, TrainingLoad, WeighGap |
| Choose a sparring partner (NEW) | three columns, match words, cost, Spar with this partner | PartnerPick (NEW), MatchScore (NEW), RegionShows, OppFile, Favours |
| Week board | the BUILD week of a 3-week bout | WeekPlan, WeekPhase |
| Playbook, Game plan | UNSPARRED tag and warning; tell words on lines; plan test ratings by match | Playbook, StrikeMap, FireLevel |
| Tape room | film nights, truth words, debutant lock | OppFile, TapeRoom |
| Corner minute (rounds 1 and 2) | confirmed / didn't happen; change one plan arrow | FightNight, OppFile |
| Weigh-in | bout-day scale at club shows; class limit the day before at championships | Bouts.weigh (home-show branch, NEW) |
| Result / Why | unsparred lines and lines relying on a tell that didn't happen, in AGAINST YOU | Why |
| Money | outside partner fees | GymBills |
| Continue button | stops once on the Monday of fight week | Clock |

## 11. Pack changes and build

**Pack changes:**
- Amateur lead time goes to 1–3 weeks, with no Set camp.
- WeekPhase gets an amateur branch.
- Bouts.weigh gets the club-show gap.
- The rest window replaces the fixed 21 days.
- TAPER's no-sparring rule is overridden at a price.
- NEW sparring partner screen and match score.
- Removed from v8: trips, savings, SKINT, the cottage and SEASON.

**Build order:**
1. **Probes:**
   - **FIGHTWEEKPROBE4:** each stop best in 1 week in 5 per tiredness band; a gap of 3 to 8 in 100.
   - **Assistant probe:** a reader beats the pick by 2+ in 100. If not, load folds to two stops.
   - **PARTNERPROBE (NEW):** CLOSE is worth 1 to 1.5 in 100 over LOOSE; the outside partner is worth its fee in at least 1 bout in 4; level-above injury doesn't wipe out the gain.
   - **Film test:** Look again and Next group are each best in some state; it sets the 7 and 9 in 10.
   - **Tank test, favour test (1 to 2), sparring test (2 to 5 in 100).**
2. **Systems:** BoutSheet, RegionShows, the WeekPhase amateur branch, the Bouts.weigh branch, WeighGap, PartnerPick, MatchScore, Favours.
3. **Frames A and B** as Look B PNG boards for the owner's OK, then build.
4. **Rest window, Swap, REMATCH, the Monday card.**
5. **Truth words and Look again / Next group lines.**

## 12. Open for the owner
1. "I want to see 9s frame": does that mean the two screens drawn at a 9/10 standard (Frames A and B as PNG boards next), or something else?
2. The sparring partner screen as specified, mandatory with nothing pre-selected: yes?
3. Outside partner cost of $160 or a favour: yes?
4. The rest window replacing the fixed 21 days: yes or no?
5. Tick over at one rest day instead of the three-day TAPER: yes or no?
6. Club-show weigh-in on bout day within the EB gap: yes or no?
7. The pro road, the nationals entry and the loss-below rule: decided in LADDER1, with reputation as the currency.

**CHECKs**
- **Claude:**
  - The WeekPhase amateur branch.
  - The home-show branch in Bouts.weigh.
  - Region-table boxers' height, reach and stance readable as partners.
  - A tell's habit data readable on club boxers for the match.
- **John:** whether a host may re-match a missed boxer on the night under EB rules, and how often.

## 13. Self-score: depth 7, general design 7, play 7

**To reach 10/10**
1. Get the owner's answers 1–6, and draw Frames A and B as PNG boards for his OK.
2. Run PARTNERPROBE and the film test, and replace the match points, the round-1 edges and the 7 and 9 in 10 with measured values.
3. Run FIGHTWEEKPROBE4 and the assistant probe. Fold load to two stops if the pick is near-best.
4. Land LADDER1 so the bout sheet's booking reads from reputation, and re-check section 2 against it.
5. Settle the four Claude CHECKs. If region-table boxers can't be read, outside partners show style and stance only, and the most they can reach is PART.
6. Size the fall-through mood (−6) and the late-ask rate with a bout-log probe.
