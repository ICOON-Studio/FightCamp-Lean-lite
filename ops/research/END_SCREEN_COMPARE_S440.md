# The fight result page: how others do it, and what ours should show (S440)

Written 2026-11-12 for the operator's two notes on the result drawings:
"compare our end fight with other boxing and simulator games and also real fight end screens" and, on the
stats strip of `docs/mockups/s439/result/manager.png`, "way to little stats for a simulator game".
His earlier rule still holds: the page reads like a match summary (numbers, bars, icons, arrows), not paragraphs,
and only what the player can act on stays on screen (the rest goes in a hover).

Where this comes from: four research sweeps (boxing games, management sims, real broadcasts, our own fight code).
Installed games (Undisputed, Corner King, Elite MMA Manager demo) were read only for the NAMES of their stats in their
files, under the owner's REA rule: nothing launched, nothing hooked, nothing copied. Boxing Manager comes from our own
S426 playtest stills. Both our drawings were opened for this page (`manager.png`, `final3.png`).
Facts about our page's numbers: `ops/research/RESULT_PAGE_FACTS_S439.json`.

---

## 1. The comparison

"Numbers" = about how many fight numbers one view or report holds. Confidence is in brackets.

### Boxing games

| Source | Stats shown | Layout | Numbers | What it does well |
|---|---|---|---|---|
| **Undisputed** (installed, names read from its files) | Punch table for both boxers: thrown, landed and % for total, jab, straight, hook, uppercut, counter, power, blocked; each split head and body. Per boxer: knockdowns, head and body health left, stamina left, damage picture. Winner banner with method and reason. Round winners with scores. A panel per judge with round scores. | A short sequence you can skip: winner banner, round winners, punch table, boxer cards, judges. Tabs step through round 1 to the last, or the whole fight. | ~70 a view, every round viewable | One compact table that works for any round. A mark shows who won each row, so the numbers read like a verdict. Damage is a picture plus head/body numbers, not words. (high on which stats; medium on look) |
| **Boxing Manager** (our S426 playtest) | Judges revealed one at a time, then the winner. Report tab 1: totals by punch type. Tab 2: round by round (jab, power, body landed of thrown, knockdowns, %), better cell tinted. Tab 3: three named judges. Tab 4: head %, body %, stamina left. Between rounds: a one-line round verdict, 5 paired bars, one chip per round in the winner's colour, stool recovery. | Drama first, then a 4-tab report. | ~75 over 4 tabs | Depth one click away, first view clean. The tinted round table shows where the fight turned. WEAK: hands the manager nothing to act on (no morale, injury, rank, money, next step on the page); damage tab is three bare numbers. (high) |
| **Corner King** (installed, names only) | Per fighter per round: punches tried, landed, head, body, damage dealt and taken. Named judges' cards, also partial cards when stopped. Gym's share of the purse, rank change, followers, injury days, stat before/after, a performance grade. A debrief that points to Training then Schedule; a press conference choice. | Result screen, then debrief and press events (look not seen). | ~15 on the result | Stat before-to-after, a single grade, and a clear "go here next". The story moves out of the stats screen. (medium) |
| **Elite MMA Manager** (demo, names only) | Purse split into bonuses (win, KO, title, streak, performance), injury in days, stats up/down, morale/relationship/popularity changes, rank up/down, judges read in steps, round winners. | Queued pop-ups: result, rankings, stat changes. | ~20 | Turns the fight into consequences the manager acts on. Short reason lines built from the fight numbers. (medium-high) |
| **World Championship Boxing Manager 2** | A broadcast-style stat breakdown after every fight (reviewers). | Not documented. | ? | Stat-minded reviewers praised it. (low) |
| **Title Bout Championship Boxing** (text sim) | Result code, three judges' cards, landed-thrown and % per fighter, per-round punch lines and recaps. | Text report. | ~40 | Years of sim players treat cards + landed/thrown/% as the minimum. (low-medium) |
| **Fight Night Champion** | Stamina, health, damage meters; end screen reportedly accuracy by punch type. | Probably a side-by-side table plus cards. | ? | Players noticed per-punch accuracy. (low) |
| **EA UFC 4/5** | Round stats between rounds; one totals screen at the end. | No round view at the end. | ? | A warning: players complain when there is no round-by-round at the end, and when the end totals disagree with the round screens. (low) |
| **Punch Club** | Win/loss, money, skill points, health lost, mood. | Small reward screen. | 5 | Even a loss moves the boxer forward. (medium-low) |
| **Real Boxing 2, Punch Club 2, Creed** | Nothing found about their end screens. | - | - | - |

### Other management sims

| Source | Stats shown | Layout | Numbers | What it does well |
|---|---|---|---|---|
| **Football Manager** | Score and scorers; 15-20 paired match stats (possession, shots, on target, expected goals, passes %, tackles, fouls, cards); every player's rating out of 10, best player starred; injuries; morale reactions. | Score header, switchable panels (stats, ratings, charts), then team talk and press as separate steps. | ~80 | A RATING per player makes depth readable in one number. Expected goals says whether the result was deserved. (medium) |
| **Out of the Park Baseball** (fetched box score) | Line score by inning, full batting and pitching tables, notes, a one-number performance score per pitcher, player of the game, one-line headline. | Newspaper box score. | ~650 | Maximum depth, but a headline and a "player of the game" on top. (high) |
| **Motorsport Manager** | Finishing order, gaps, points, standings, morale change judged against the predicted finish, sponsor targets. | Results, standings, then morale and interview. | ~60 | Morale is judged against an EXPECTATION shown before the race: "better or worse than expected". (medium-low) |
| **Pro Wrestling Sim** | A rating per match, crowd reaction, show score against a target, attendance. | Show report list. | ~20 | One quality number per bout, compared with a target. (low-medium) |
| **MMA Tycoon** (wiki) | Strikes, takedowns, submissions as attempts with successes. | Paired bars: full bar = tried, darker inner part = landed. | ~12 | One bar shows tried AND landed: double the information, no extra rows. (medium) |
| **MMA Manager 2** (mobile) | Cash, prestige; past fight stats feed the next scouting screen. | Reward screen. | ~5 | Fight stats come back when scouting the next opponent. (low) |

### Real fights (broadcast and official)

| Source | Stats shown | Layout | Numbers | What it does well |
|---|---|---|---|---|
| **TV punch counts (the CompuBox style)** | Per fighter: total, jabs, power punches, each landed of thrown with %, body landed in brackets. Same per round. Extras on their site: own % minus opponent's %, work rate against the division average. | Two columns facing each other, three rows; full sheet repeats it per round. | 18 final, 200+ with rounds | The shared language of boxing: who was busier, cleaner, and did the hurtful work, in one glance. (high) |
| **Official pro scorecards** | Three named judges, every round 10-9 / 10-8 / 10-10, deductions, totals, unanimous/split/majority. | TV: three totals then the verdict. Card: rounds as columns, running totals. | ~75 for 12 rounds | Shows how close it was and WHICH rounds swung it. (high) |
| **Amateur / Olympic scoring** (our amateur bouts' model) | 3 judges at English club shows (5 at Olympics), 3 rounds, 10-9 / 10-8 / 10-7 per judge, totals, split 2-1 or 3-0. Warnings cost a point on every card, 3 warnings = disqualified. Results: win on points, referee stops, injury stop, corner retires, KO, disqualified, walkover. Standing counts. | Arena scoreboard shows each judge's round once confirmed. | ~20 | The honest model for our club-level page. Warnings and standing counts are events a coach cares about. (high) |
| **UFC Stats** (for our BJJ fighter) | Knockdowns; significant strikes landed of tried and %; by TARGET (head/body/leg) and by POSITION (distance/clinch/ground); takedowns and %; submission tries; reversals; control time. Every table per round. | Header (method, round, time, referee), totals table, strikes table, per-round copies, bar charts. | ~150 | Splits WHERE strikes landed from WHERE the fight happened, plus the grappling numbers. (medium-high) |
| **UFC.com fighter pages** | Accuracy rings, 3-way splits (head/body/leg; standing/clinch/ground) with count and %, wins by method. | Ring gauges, body-zone figure, no paragraphs. | ~30 | Exactly his "icons, numbers, arrows" style. (high) |
| **ufcalendar fight page** | 3 "what happened" lines, then totals, where it landed, where it happened, round by round, a range-by-target table. | Short two-sided sections, a marker on the side that leads each row. | ~200 | Summary on top, detail below; the marker lets you read who won each row without reading numbers. (high) |
| **BoxRec** | Winner, method, last round of scheduled rounds, venue, referee, judges' totals, titles, records before. | Card table. | ~15 | METHOD + ROUND + scheduled rounds: the shortest true summary. (medium) |
| **DeepStrike AI** (TNT, Fury-Usyk 2024) | Thrown, landed, HIGH-IMPACT punches, who the data says won each round, combination trees. | Panels (not readable). | ~40 | Counts quality, not just volume, and a "data's card" beside the judges'. (low-medium) |
| **TV end graphics** (DAZN, ESPN, Sky, TNT) | The judges' totals and verdict on one panel, the three-row punch block on another. | Two panels, corner colours, no paragraphs. | ~24 | One job each: the cards say WHO and how close, the punch block says WHY. (content medium-high, look low) |

---

## 2. Where our page stands

| Drawing | Fight numbers | What is there |
|---|---|---|
| `manager.png` (the one he marked) | 6 fight numbers (+3 judge totals) | landed 49-78, rounds 1-2, energy left 46-34 |
| `final3.png` (newest) | ~22 | 3 judge totals with round dots, 3 round chips (landed each round), landed, head, body, exchanges won, energy at the last bell |
| Genre | 15 (Corner King) to 75 (Boxing Manager) to 150+ (real MMA) | |

He is right: we are at the bottom of the genre, about 5 to 10 times short. The KINDS missing matter more than the count:

1. **Thrown and %.** Every serious source shows thrown beside landed. Without it there is no work rate and no accuracy,
   the two numbers a boxing fan reads first.
2. **Punch types.** Everyone splits jab from power at least.
3. **Round by round.** Every sim has it; EA UFC players complain where it is missing.
4. **Each judge's round scores.** We show totals only.
5. **Events.** Standing counts, times rocked, warnings: none on our page.
6. **Damage DEALT.** We show only what she took; the opponent's body map is recorded but unused.
7. **Ring control and the corner's work.** Recorded, unused.
8. **One rating per fighter** and **"better or worse than expected".** The best sims have both.

What we already do BETTER than Boxing Manager: the "after the fight" row (tiredness, morale, goal, damage in days,
ranking, club money) and the "after continue" strip with where to go next. Keep both as they are.

Two honesty problems found in our own code (sweep 4), which a deeper page would expose:

- **Thrown does not exist in the fight.** The "X of Y" on the corner card comes from the 3D replay script, where misses
  are a fixed 6 for the exchange winner and 8 for the loser. That "accuracy" only repeats who won, its landed counts
  disagree with the real totals, and nothing saves it. It must not go on the result page as it is.
- **The judges are made up from the rounds won.** Two judges copy the round count, the third flips the closest round,
  so every fight that is not a shutout is a SPLIT decision, and a standing count never gives a 10-8 round, while the
  corner card says "10-8 ON YOUR CARD". `final3.png` shows exactly this (28-29, 28-29, 29-28, "split decision").

---

## 3. The recommended stat set (simulator depth, few words)

### How the page holds it

- **First view stays the summary** (final3's skeleton): the verdict, the cards, the round strip, the fight band, then
  "your result", "why she lost", "after the fight", "after continue".
- **The fight band becomes a punch table**: both boxers facing each other, rows of numbers, a bar in each row whose
  OUTER part is thrown and INNER part landed (one bar, two numbers), and a mark on the side that won the row.
- **Round tabs** above the band: ALL / R1 / R2 / R3. The same band shows any round. The sim records every round and every
  30-second exchange, so this costs nothing in data.
- **Hover** on any number: what it means in one line and what trains it.
- **Detail drawer** (one click, optional): ring and corner numbers that a coach reads less often.

Target count: first view about **60 fight numbers**, about **200** across the round tabs, about **40 more** in the
drawer. That is Boxing Manager's depth with Undisputed's per-round reach, and still no paragraph.

Where it goes: SHOWN = on the first view; ROUND = changes with the round tabs; HOVER; DRAWER.
Source: **RECORDED** = the fight already keeps it, only the page must show it. **DERIVABLE** = counted from what is
recorded, a few lines. **NEW** = needs a new fight mechanic (section 5).

### A. The header (who won, how, how close)

| Stat | What the player learns / does with it | Form | Where | Source |
|---|---|---|---|---|
| Verdict and method (points / KO / referee stops / corner retires / disqualified) | The result | Big word | SHOWN | RECORDED (BoutNight m.win, m.outcome) |
| Stoppage round of scheduled rounds | How far she lasted | "R2 of 3" | SHOWN | RECORDED |
| Time of the stoppage in the round | Exact moment, for the replay | "R2 2:30" | SHOWN | NEW 5 (count time) |
| Three judges' totals and the split (3-0 / 2-1) | How close it was | 3 score chips | SHOWN | RECORDED today, but made up; honest with NEW 3 (judges) |
| Each judge's score for each round, 10-8 marked | Which round lost it, and which judge saw it differently | 3 x 3 grid of small scores | ROUND (the grid under the chips) | DERIVABLE today (Broadcast.judge_rounds), honest with NEW 3 |
| What each judge favours (work rate / clean punches / body work) | Who to fight for next time: a busy fighter in front of a work-rate judge | Small icon under the judge | HOVER | NEW 3 |
| Expected before the fight vs result ("38% to win: UPSET WIN") | Was this a good night or a bad one, beside the luck | Badge with an arrow | SHOWN | NEW 4 (one saved number) |
| Performance rating per fighter, 0-10 | One number for "how well did she box", even in a loss; drives the coach's read | Big number per side | SHOWN | DERIVABLE (formula published in the hover) |

### B. The punch table (the fight band) - ROUND tabs apply to every row

| Row | What the player learns / does with it | Form | Source |
|---|---|---|---|
| **Total**: thrown, landed, % | Work rate (cardio, pace) and accuracy (hand speed vs their defence) | Paired bar, outer thrown / inner landed, % at the end | landed RECORDED; thrown and % NEW 1 |
| **Jabs**: thrown, landed, % | Did the jab work; train the jab | Same | NEW 2 (punch kinds) |
| **Power punches** (everything not a jab): thrown, landed, % | Did she do hurtful work; style read | Same | NEW 2 |
| **To the head** landed | Where she scored | Paired bar | RECORDED (landed minus body) |
| **To the body** landed | Body plan paying off | Paired bar | RECORDED (per exchange) |
| **Counters** landed | Timing and ring sense; train counters | Paired bar | NEW 8 |
| **Big shots** (the punches that hurt) | Who had the power moments | Paired count with a fist icon | NEW 10 |
| **Exchanges won** (of 18) | Who controlled it: this is what the cards really score | Paired bar | RECORDED |
| **Rocked** (times hurt) | Chin and defence; who was in trouble | Paired count, star icon | DERIVABLE (exchange "hurt" flags) |
| **Standing counts / knockdowns** | Danger: one more and it stops | Paired count, icon on the round chip | RECORDED |
| **Warnings / points taken** | Discipline cost points; train discipline | Paired count, referee icon | NEW 6 |
| **Punches avoided** (blocked / slipped) | Defence at work; train guard or head movement | Small paired split | HOVER on Total, NEW 7 |
| **Work rate** (punches a minute) | Fading or outworking | Small bars per round | ROUND, comes free with NEW 1 |

### C. Condition at the end (beside the body figures)

| Stat | What the player learns / does with it | Form | Where | Source |
|---|---|---|---|---|
| Energy at each bell, both | Did she run out; cardio and pace choice | Two small lines across the rounds | SHOWN | RECORDED (start and end of each round) |
| Energy recovered on the stool | Is her recovery the weak point | "+12" per break | HOVER | DERIVABLE |
| Head damage meter, both | Why the count came, how close to a stoppage | Paired bar | SHOWN | RECORDED (m.damage) |
| Body map of BOTH fighters | What she did to the opponent, not only what she took (rematch, rival's next fight) | The two figures already drawn, callouts on the opponent too | SHOWN | RECORDED (side b unused today) |
| Damage per round, worst place | When the eye went | Small row per round | ROUND | DERIVABLE (snapshot each round) |
| What gave out first (legs, arms...) | What to train | Callout "legs went R2" | SHOWN (ours) | RECORDED; the opponent's is NEW 11 |
| Started tired (camp fatigue, earlier hurt) | Her energy was low from the first bell: plan the camp | Small "started at 88" | HOVER | RECORDED |

### D. The round strip (one column per round)

| Stat | What the player learns / does with it | Form | Source |
|---|---|---|---|
| Round winner | The story in one row | Chip in the winner's colour (already drawn) | RECORDED |
| Landed each, per round | Who had the round in punches | Two numbers in the chip (already drawn) | RECORDED |
| Momentum: 6 exchanges a round, how clearly each was won | Where it turned, inside the round | 18 small bars above / below a line | RECORDED (exchange margin) |
| Event icons: count, rocked, warning, plan worked | The key moments | Icons on the bars | RECORDED / DERIVABLE (warnings NEW 6) |
| Corner call for the round, and won or not | Did my instruction work | Small icon under the chip | RECORDED |
| Win chance after each round | How the fight swung | Small line under the chips | NEW 4 |

### E. The drawer (one click: the coach's notes, in numbers)

| Stat | What the player learns / does with it | Form | Source |
|---|---|---|---|
| Opponent's game and how she did against each (pressing 2 of 5) | The answer to train for a rematch or this style | Pips per game | RECORDED |
| Corner calls used and won, live shouts that worked (3 of 5) | Is my corner work right; corner trust | Pips | RECORDED |
| Pace chosen and its record (push 4, won 3) | Work-rate choice vs result | Three-part bar | RECORDED |
| Ring place: range / pocket / inside, on the ropes | Where the fight was fought | Three-colour strip per round | RECORDED |
| Ring control (got the range she wanted) | Footwork and plan | Paired % bar | DERIVABLE |
| The duel that decided it (her jab vs his head movement, 3 of 6) | Which attribute won or lost it: what to train | Two attribute icons and a count | RECORDED |
| Plan: arrows used, plan grade, exchanges the plan swung (+2) | Is my fight plan worth it (counted against the same dice without it) | Grade badge, "+2" | RECORDED |
| Set-ups landed, reads landed, clinches and rib shots | Fight IQ and inside work | Small counts | RECORDED |
| Habits punished (dropped the right: cost 3 exchanges) | A trainable fix | Count with the habit icon | RECORDED |
| Combinations landed whole (her 1-2-3: 4 of 7) | The combo planner pays off | Count per combo | NEW 9 |
| Form on the night (sharp +3 / off night -4) | Honest about luck | Small +/- | HOVER, RECORDED |

### F. Kept from final3 (already right)

Your result (loss, split, record), why she lost (turned in round 2, energy unused, plan used), after the fight
(tiredness, morale, goal, damage days, ranking, club money), after continue (where to go next). Add an arrow
"better / worse than expected" on morale and ranking once NEW 4 exists.

### The BJJ fighter

Her match (`scripts/rules/BjjMatch.gd`) has its own numbers (points, calls, initiative). The UFC Stats model fits her:
by target and by position, takedowns of tries, control time, submission tries, reversals. It needs its own audit before
any drawing; it is not covered here.

---

## 4. What we must NOT copy

- **No art, icons, fonts, colours, screens or animations** of any game or broadcaster. The layouts above are general
  ideas (two columns facing, rows, round tabs), which every sports graphic shares.
- **No wording.** Our own labels in our game words (memory S422: "Cardio", "Energy", plain words). Not their round
  verdict words, not their tab names, not their judge descriptions.
- **No brand names on screen.** No "CompuBox", "DeepStrike", "Undisputed" or broadcaster names in the game; our punch
  count is our own.
- **No real officials.** Judge and referee names are fictional, like the fighters.
- **Nothing from installed games' files** goes into the project: the names were read for this comparison only.
- **Not their weaknesses**: Boxing Manager's mostly empty Cards and Damage tabs, its report that leaves the manager
  nothing to do, EA UFC's end totals that disagree with the round screens. Our rule: the round tabs add up to ALL, and
  the 3D replay shows the same counts as the page.
- **No stand-in numbers** (operator S439): no stat goes on the page until the fight really produces it. Today that
  rules out thrown, %, punch types and the 10-8 cards until their mechanics land.

---

## 5. Build tasks

Each is one brief for one seat. Rules for every brief (CLAUDE.md, WORKFLOW s5, s6): the test goes red on main first;
never two identical fighters (population named in the test output: two fighters who differ in stats); bounded values,
never an exact count; plain `--script` tests are the OFF arm, `as_game` the ON arm; new features read through
`GameSwitches.on()` and ship ON; files under 500 lines. Seat suggestion in brackets: pure rule module + test = Goose /
Arena (cloud); UI wiring = a Godot UI seat or Claude; design questions (judge taste weights, rating formula) =
Dola / Grok bots / Kalli as a question, never code.

### 5a. Show what is recorded (no new mechanic)

| # | Task | Where | Test that proves it |
|---|---|---|---|
| D1 | `FightReport` pure module: from `m.rounds[].exchanges` count per side and per round: rocked, exchanges won, ring control share, range share, on the ropes, energy at each bell and stool recovery, opponent game record, call record, pace record, set-ups, reads, clinches, habit costs. One dictionary the page reads. | new `scripts/rules/FightReport.gd` (reads only; no change to the fight) | `tests/fight_report_test.gd`: on 50 seeded bouts of two different fighters, per-round values add up to the ALL value for every stat; exchanges won sum to 18 for a full 3-round bout; rocked equals the count of hurt flags. (Goose/Arena) |
| D2 | Momentum strip data: the 18 exchange margins, the turning round (first round the running margin changes side), event icons per exchange. | `FightReport.gd` | Same test file: a bout whose margins are all positive has no turning round; the icons appear on the exchange that holds the event. |
| D3 | Damage dealt: put the opponent's body map (side b) on the page beside hers; damage per round snapshot after each round. | `scripts/fight3d/BoutMarks.gd` (snapshot), result page scene | `tests/bout_marks_rounds_test.gd`: the last round's snapshot equals the final map; side b is not empty after a bout she won on points. |
| D4 | Performance rating 0-10 per fighter from exchange margins, exchanges won, rocked, head damage dealt and taken, plan swing. Formula written in the hover. (Ask Kalli/Dola to review the weights before build.) | `scripts/rules/FightRating.gd` | `tests/fight_rating_test.gd`: always 0-10; the winner of a shutout rates above the loser in at least 95% of 200 bouts; a loss with more exchanges won than the opponent can still rate higher than him. |
| D5 | The page: punch table with round tabs, round strip, drawer, body figures for both, using only D1-D4 and recorded data. | the result screen scene and its script | Golden-path test walks a bout to the page and checks each ROUND tab adds up to ALL; stills on the hidden desktop, opened by Claude, before the operator sees them. |

### 5b. New mechanics

| # | Mechanic | What the fight sim must start tracking, and where | What it adds to the fight | Size | Test that proves it |
|---|---|---|---|---|---|
| NEW 1 | **Thrown punches and %** | Each exchange: thrown per side from output (cardio + hand speed, times pace, times the opponent's game: pressing raises it, countering lowers it, times energy). Landed stays as settled; accuracy vs defence nudges the %. Store `thrown[2]` in the exchange record. `scripts/state/LiveRound.gd` ~302-305, `scripts/rules/Exchanges.gd` settle ~307. The 3D replay (`ExchangeBeats` / `RoundScript.gd` 21-22) sizes its misses from it instead of the fixed 6 / 8. | Work rate and accuracy become real; pace and cardio show; the 3D view and the page agree. | Medium (~100 lines + test) | `tests/thrown_test.gd`: thrown >= landed every exchange; on 200 bouts the higher hand speed + cardio side throws more on average; push pace throws more and spends more energy than save; % rises with accuracy against the same defence; the replay's thrown equals the record's. Red on main (no `thrown`). (Goose/Arena) |
| NEW 2 | **Punch kinds** (jab, straight, hook, uppercut; power = not jab) | At settle, split landed and thrown by the fighter's own punch mix (`RoundStyle.punch`, `RoundScript.gd` ~256), seeded; store `kinds` in the record. The replay plays exactly those kinds. Needs NEW 1. | Style shows in numbers; training the jab shows on the page. | Small-medium | `tests/punch_kinds_test.gd`: kinds add up to landed and to thrown every exchange; a jab-heavy style lands a higher jab share than a puncher over 200 bouts; same seed, same split. |
| NEW 3 | **Judges with taste, 10-8 for a count** | Each judge scores each round from the six exchange margins plus his own noise and one taste weight (work rate, clean punches or body work); a standing count makes it 10-8. Replaces `BoutRules.gd` scorecards (~244) and `Broadcast.gd` judge_rounds (~259); store each judge's round scores. Fixes the corner card's "10-8 ON YOUR CARD". NOTE: this is the S425 "judges with taste" item of the small living world; the operator said it is built after the week. Brief it when the week is done, or ask him to bring it forward. | Split, majority and unanimous decisions mean something; a judge's taste becomes a booking choice. | Medium | `tests/judges_taste_test.gd`: a round with a count scores 10-8 for the other side on every card; over 200 close bouts unanimous, majority and split all occur (bounded shares, not exact); a work-rate judge favours the busier side more often than a clean-punch judge. Red on main (two judges always match). |
| NEW 4 | **Expected result and win chance after each round** | Save the win chance at the first bell (`scripts/rules/BoutRead.gd` ~401 band mid) into `m.odds_before`; after each round, rounds won plus BoutRead's edge for the rounds left into `m.odds_rounds`. Never recompute after the fight (the peak is gone by then). | "Upset win", "better than expected" arrows on morale and ranking, a swing line. | Small | `tests/odds_saved_test.gd`: odds_before is saved before round 1 and unchanged after the bout; the last value is 0 or 100 for a stoppage; the favourite wins more than half of 200 bouts. |
| NEW 5 | **Count and stoppage time inside the round** | Roll the count at the exchange where the round's loser was hurt, not after the bell (`scripts/state/BoutNight.gd` _counts ~233-270); store the exchange index (time = index x 30 s). The replay shows the count at that exchange. | "Stopped R2 2:30"; the replay and the page agree. | Small-medium | `tests/count_time_test.gd`: every count sits on an exchange where that fighter was hurt or the one before; time is within the round; a stoppage's time equals its count's time. |
| NEW 6 | **Fouls, warnings, points taken** | A foul roll in clinch and tired exchanges from discipline, next to `ClinchRest.roll` (`LiveRound.gd` ~284-287). Amateur rule: a warning takes a point off every card, three warnings disqualify. Store per side. Needs NEW 3 to change the cards. | The referee has a role; the discipline stat costs points. | Medium | `tests/fouls_test.gd`: low discipline draws more warnings than high over 200 bouts; each warning is minus 1 on every card; three warnings end the bout as a disqualification. |
| NEW 7 | **Defence: punches blocked and slipped** | Split each side's missed punches by the defender's guard vs head movement (`RoundStyle.defend`, used today only by the replay, `RoundScript.gd` ~262-270). Needs NEW 1. | Defence training becomes visible. | Small | `tests/defence_split_test.gd`: blocked + slipped = thrown - landed; a high-guard fighter blocks a bigger share than a head-movement fighter. |
| NEW 8 | **Counters landed** | Tag a share of landed punches as counters when the other side led the exchange (counter games, "draw the lead" call), scaled by timing and ring IQ, in `Exchanges.gd` settle / LiveRound. Needs NEW 2. | Counter-punchers read as counter-punchers. | Small | `tests/counters_test.gd`: counters <= landed; a counter style tags more than a presser; zero counters in exchanges she led. |
| NEW 9 | **Combinations landed whole** | At settle, pick 0-2 of her drilled combos per exchange (`Combos.pick`, OwnCombos mastery; today only in the replay, `RoundScript.gd` ~100-110) and record landed whole or not. | The combo planner shows up in the fight result. | Medium | `tests/combos_settle_test.gd`: only drilled combos appear; higher mastery lands more whole over 200 bouts; the replay plays the recorded combos. |
| NEW 10 | **Big shots** | When a hurt roll fires (`scripts/state/RingDuel.gd` ~342-345), record the punch kind and exchange. Needs NEW 2. | A true "biggest shot" for the summary and the 1.5 s close-up. | Small | `tests/big_shots_test.gd`: every rocked moment has exactly one big shot with a kind from that exchange's kinds. |
| NEW 11 | **Opponent's body report** | Run `BoutBurn.per_round` (`scripts/rules/BoutBurn.gd` ~58) for the opponent's profile. | "His legs went in round 3": body work pays off visibly. | Small-medium | `tests/opponent_burn_test.gd`: a body-heavy plan burns the opponent's body more than a head plan, same opponent, 100 bouts. |
| NEW 12 | **Weight on the night (kg)** | Store both weigh-in weights (`scripts/state/Bouts.gd` ~194 keeps only made/not made). | Tale-of-the-tape line, weight-cut stories. | Small | `tests/weigh_in_kg_test.gd`: weights saved, within the class limit when "made" is true. |
| NEW 13 | **Fight of the night score** | From lead changes, rocked moments and counts. Feeds a small member/ticket bonus. Touches MONEY: the operator's call before any brief. | Exciting fights help the gym. | Small | Only after his yes. |

### Order

1. D1, D2, D4 (cloud seats, pure modules, in parallel) and NEW 4 (one saved number): the page gains ~35 honest numbers at once.
2. NEW 1, then NEW 2 (the punch table's core: thrown, %, jab and power), with NEW 7 and NEW 8 right after.
3. D3 and D5 (the page itself), drawn only from what 1-2 produce; critics score it against this file before he sees it.
4. NEW 5, NEW 10, NEW 9, NEW 11, NEW 12.
5. NEW 3 and NEW 6 (judges and referee) when the week is done or he brings them forward; NEW 13 only on his yes.

---

## Fight-only page additions

Added 2026-11-12 with the drawing `docs/mockups/s440/result/fight_only.png` (operator: "Yes, fight only"). The page uses
NEW 1, 2, 4, 7, 8, 9 and 10 from section 5b as they stand, plus two extensions below. Everything else on it is RECORDED or
DERIVABLE. NEW 3 (judges with taste) is NOT used: the cards follow today's `BoutRules.cards_of` (two judges round for round,
the third gives the closest 3-3 round the other way), so the drawing's split decision needs a 3-3 round, and has one.

| # | Mechanic | What the fight sim must start tracking, and where | What it adds to the page | Size | Test that proves it |
|---|---|---|---|---|---|
| NEW 2b | **Punch kinds per move** (jab, cross, lead hook, body hook, uppercut: `BodyMap.PUNCHES`) instead of only jab / straight / hook / uppercut | NEW 2's split, but by the fighter's own moves, and only moves at 30+ mastery (weapons) can be thrown. Store `kinds` per move in the exchange record. | One table row per move, with the player's fighter's mastery level (New / Raw / Usable / Sharp / Signature) beside it: the fight points back at the pad nights. A Raw move shows "not a weapon yet". | Small on top of NEW 2 | `tests/punch_kinds_test.gd` extended: every move's thrown and landed add up to the totals; a move under 30 mastery is never thrown; the same seed gives the same split. |
| NEW 7b | **Clean misses** beside blocked and slipped | NEW 7 splits thrown minus landed into blocked, slipped AND missed (a punch that was just wide or short), so `blocked + slipped + missed = thrown - landed`. The miss share rises with the thrower's tiredness and falls with accuracy; blocked and slipped come from the defender's guard and head movement. | "Avoided" credits the defender only with blocked + slipped; the "All punches" bar shows where every punch went (landed / blocked / slipped / missed). Answers the round-1 critic: a defence number that counted every miss was not believable. | Small | `tests/defence_split_test.gd` extended: the four parts add up to thrown every exchange; a tired thrower misses clean more often than a fresh one over 200 bouts; a high-guard defender blocks a bigger share than a head-movement defender. |

Derivable, no new mechanic, but the page needs them per exchange (for D1/D2 `FightReport`): the live shout's verdict
(worked / wrong / not counted) on its exchange, the plan line that fired on each exchange with won or lost, the ring
place of each exchange and each boxer's wanted range (for "Range wanted 7 / 11 of 18"), the habit punished on its
exchange, and the opponent's ranking line (`RankLine.after` run for the opponent's name too).
