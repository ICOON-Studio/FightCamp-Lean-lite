# Knowledge stakes v9 - they box on Saturday, the trial runs by the day, and the scout is wrong one time in three

S541, 2026-11-23. Board row KNOWLEDGE1. Map only: nothing is built by this page. Bar (owner S534): 8 on DEPTH and 8 on PLAY.
Lines tagged CODE were opened on 2026-11-23 at the file:line given (main at 7fc74f4e1). ESTIMATE = proposed, not in the
game. MEASURED = a probe result, with its file. Words: "the prospect", "your boxer", "they"; no fixed he or she.
v8 (`DESIGN_KNOW_STAKES1_V8.md`) stays the base, and v7 under it: every line not changed here holds.

One sentence: **the scout brings a name they cannot call, who boxes on a date you can see, while a rival club decides inside
a window you can see; you can sign on the hunch, take them on trial and stop the evening you have seen enough, or wait for
the bout - and the two dates on the card say which.**

## 0. What changed from v8, in eight lines
1. **EVERY SCOUTED NAME BOXES SOON.** The scout finds names at shows: the card carries their next bout, 4 to 18 days out,
   free to watch. Watching opens under fire (rough) and moves the record. v8 had a bout only now and then.
2. **THE TRIAL RUNS BY THE DAY, AND EACH DAY ANSWERS ONE QUESTION.** Day 1 the fitness test (body). Days 2-4 pads (skills).
   Day 5 the pad test (the ceiling). Day 6 conditioning (the rest of the body read). Day 7 the hard spar, optional (under
   fire). Every evening: **Sign, Send home, or Another day.** $36 a day (a week's stipend by the day; $250 for all seven).
3. **THE TEST DAY BUTTON IS GONE.** It is day 1 of the trial. One read with a depth the player chooses, instead of two.
4. **THE WINDOW COMES FROM WHAT THE RIVAL SEES, NOTHING ELSE.** Their look above the level: they decide between day 1 and
   day 13 ("Lynn AC want this one"). Not above: between day 8 and day 20 ("having a look"). The record no longer shortens
   it (the player can already read the record; it was a second, stacked minus 7).
5. **THE SCOUT'S MAYBES ARE TIGHTER:** a scouted name's first look sits within 2 of the level (was 3). MEASURED: the first
   look's call is then wrong 33.0% of the time - one in three.
6. **A SIGNED BOXER'S NUMBERS COME BACK ON THE READ ALONE.** A group prints single numbers once it is a good read. The
   second gate (12 weeks or 3 bouts) is cut: both critics found it late or confusing.
7. **THE NEXT CARD REMEMBERS THE LAST ONE.** A "Last time" strip on every signing card: the last one who got away and
   where they box now; the last trial, what the first look said and what the trial found.
8. **A READ THAT CHANGES THE ANSWER SAYS WHY.** "Body 56-72 -> 61-69: now clear of the level" / "now under it".
Kept from v8 unchanged: the 12-week bond, the refund when the rival signs during a trial, the rival's look on the card,
the ceiling range and its pad test, the open session read while waiting, the got-away list and the return bout, two named
prospects from day 0, Pass freeing the slot.

## 1. Why the first critic's score fell (v7 depth 7 -> v8 depth 6), and what v9 does about it
v7 was scored on a claim; it had no probe. v8 printed its own probe: all three calls end the same on 82% of prospects, the
wait misses its bar, and the scout filter does the spreading. The critic scored that. The design points added: the stacked
minus-7s leave no room to wait on the prospects worth waiting for; the test day is free information; the numbers return too
late; no screen shows any of it. v9: the bout gives the wait its own read (0.1), the window is unstacked (0.4), the test
day is inside the clock as day 1 (0.3), the numbers gate is cut (0.6), and screen wiring is step 1 of the order (section 7).

## 2. What the game does today (only what v9 adds to v7 and v8 section 1)
- **C1 CODE - the trial's price is $500, not $125.** `scripts/rules/KnowReads.gd:9` PRICE_TRIAL_WEEKS 4, `:28`
  "half stipend for 4 weeks" = 4 x $250 / 2. v7 and v8 wrote $125 without flagging the change (the first critic's code
  check). **v9 flags it: `price("trial")` becomes $36 a day.** MEASURED why (section 6): at $18 a day ($125 the week)
  always taking the trial ties the careful player; at $36 it does not.
- **C2 CODE - the test day.** `KnowReads.gd:11` PRICE_TEST_DAY 60, `:114-119 _apply_test_day` (body exposure 16). v9
  keeps the read and drops the price and the button: it is what day 1 of the trial applies.
- **C3 CODE - the trial's read stays the code's.** `KnowReads.gd:105-111 _apply_trial`: body 24, skills 24. v8 cut body
  to 12; **v9 puts it back** (16 on day 1 + 8 on day 6; skills 8 a day on days 2-4). MEASURED: body 12 gains nothing.
- **C4 CODE - no screen reads the knowledge code.** Searched today: no file under `scripts/ui` names `Knowledge`,
  `KnowWire` or `KnowReads`; the callers are `scripts/state/BoutFinish.gd`, `KnowWire.gd`, `Roster.gd`, `Sim.gd`. The
  first critic is right: the mechanic is invisible today. Wiring one screen is step 1.
- **C5 CODE - the bond is new work.** `scripts/state/Leaving.gd:65 let_go_price` prices reputation only (v8 B1 said so;
  repeated because the critic listed it).

## 3. The design (changes to v8 section 2 only)

### A. The card
- Two dates, side by side, on one 21-day strip: **the bout** ("Boxes Sat 23 Jan at the Lynn show, free to watch") and
  **the rival's window** ("Lynn AC want this one: they decide between Mon 18 and Sun 24 Jan"). Days before the window
  are marked safe. The strip is the decision: a bout before the window says wait; a window that opens tomorrow says
  hunch or one trial day.
- Under the ranges, as v8: the rival's look, the stake line with the bond.
- Bottom: the "Last time" strip (0.7). Only real entries; empty until there is one.

### B. The calls
| Call | Cash | Days | What it answers | Odds on the button |
|---|---|---|---|---|
| **Sign now** | the bond: $250 a week, 12 weeks | 0 | Nothing more | "About 1 first look in 3 like this ends under the level." (MEASURED 33%) |
| **Start the trial** | $36 a day, refunded if the rival signs during it; a place held | 1 to 7, your choice each evening | Day 1 body (16 wide to about 7). Days 2-4 skills (to about 9 wide by day 4). Day 5 the ceiling, halved. Day 6 body to about 6. Day 7 hard spar: under fire and the pressure trait; injury x2 that night, +15 tiredness | Each evening on **Another day**: "Tomorrow: pads, skills narrow again. Lynn AC may decide tomorrow: 0 in 7" or "1 in 5" (days left in the window) |
| **Wait for the bout** (Continue) | $0, your evening | to the bout | Under fire, rough (about 23 wide); the record moves; the open session narrows body and skills a little each week (v8) | "Lynn AC may decide before the bout: 0 in 7" or "3 in 7" |
| **Pass** | $0 | 0 | Frees the slot today; they box on at the rival club; no news line | "Kept on the got-away list with your look." |
- Letting the window run out is not Pass: it writes "Lynn AC sign the prospect, 24 Jan" in the news and on the got-away
  list with that date (the second critic's item 5).
- The trial and the bout combine: a trial can start the day after the bout, and a bout can fall inside a trial (the
  prospect boxes that evening; that trial day reads under fire instead of its own question, at no injury risk to you;
  ESTIMATE, not in the probe).
- MEASURED (docs/KNOWSTAKES9_RESULT.md): the pure trial call runs 5.2 days on average. Ending it by the day halves what the
  careful player loses to the rival during a trial (7.5% of prospects against 16.2% with a whole-week trial).

### C. The rival
- Window (ESTIMATE): 7 days long. Last day = 7 when the rival's own look is above the level, 14 when not, plus 0-6. So
  the first possible day is day 1 to 7 for a name they want and day 8 to 14 for one they are looking at. One rule, read
  off the rival's look that is already on the card. MEASURED: beside the first look the clock adds 0.015 of R2 about the
  truth; day 1 of the trial adds 0.041 (B4 PASS).
- Everything else as v8 (the region row, the return bout within 26 weeks tagged "you passed").

### D. Arrivals
- The scout brings names within 2 of the level, each with a bout date. Walk-ins, visitors and home juniors stay
  unfiltered and have no bout line unless the region sheet has them on a show.
- At most two open at once, as v7. The side-by-side strip shows every open name (there are never more than two).

### E. Numbers for signed boxers
- A group prints single numbers once it is a good read (60% of the range gone). No second gate. Before that: the middle,
  the range on hover, the weekly gain moving the middle. The number shown is the middle of a range under 3 wide, never a
  jump to the truth (v7 L3). Prospects always show ranges.

## 4. Feedback loops (owner S541; written after the probe - the rule landed during this session)
| The change feeds | Does that feed back? | Cap |
|---|---|---|
| Better signings -> wins -> cash -> more trial days | Yes, a rich club reads more | 3 places; one new name every 4-6 weeks; two open at once; 7 trial days a name ($252) |
| A flop -> the bond -> less cash -> the hunch instead of a read -> more flops | Yes, downward | The bond is paid only on letting go and never above $3,000; keeping a flop costs the stipend they already draw. NOT MEASURED on the real loop: the build's probe must run a cash-tight club (gym closes after 8 weeks below $0) |
| Prospects the rival signs -> stronger region rows -> a higher level -> the scout's maybes centre higher | Yes, slowly | 8-12 names a year, a sheet of many rows; the level is a mean. To measure in P-F (v7): the level's drift over two years stays under 2 points |
| Trial days / waiting -> the rival's window | No: the window is fixed when the name arrives | - |
| Watching the bout -> the record -> the rival's window | No in v9 (the record no longer sets the window) | - |
One-rep trial run before the full probe: run 0 of the result (2,000 prospects, v8 rules replayed) before any v9 run.

## 5. Menus (v8 section 3 holds; rows that change)
| Menu | v9 changes | Wired to |
|---|---|---|
| Signing card | the 21-day strip with the bout and the window; Start the trial replaces Test day and Trial week; Wait for the bout; "Last time" strip; "1 in 3" on Sign now | prospect record: `bout_day` (new), `window_from`, `window_to`, `rival_seed`; `Knowledge.range_of` |
| Trial (`ui/modals/Trial.gd`) | the seven days as a ladder with today's question lit; the before / after strip each evening with its "why" line; Sign / Send home / Another day with tomorrow's question and tomorrow's odds | `KnowReads` per-day reads (new: `apply_trial_day(k, day)`), `KnowReads.price("trial")` = 36 x days |
| Top bar Continue | stops each trial evening, on the bout day, on the window's first and last day | `Clock` candidates |
| Needs strip | "Trial day 3: decide tonight"; "The prospect boxes tonight"; "Lynn AC decide from today" | same |
| Fights / the region show | the prospect's bout is a row on that show: Watch (free, your evening) | the region sheet + `bout_day` |
| Find a fighter | scouted names within 2 of the level, each with its bout date; "Next name: about N weeks" | `Data.PROSPECTS` order, the arrival clock, the filter on `Knowledge.range_of` centres |
| Fighter page / Week / attribute board | single numbers once a good read; the middle with the range on hover before | `Knowledge.share_gone` |
| News / got-away list | "Lynn AC sign the prospect, 24 Jan" when a window runs out; nothing on Pass | prospect record -> `Leaving.rival_row` shape |
| `KnowReads.gd` | trial price by the day; PRICE_TEST_DAY and the test_day read kind folded into trial day 1 | CODE change, C1-C3 |

## 6. Every item on both "to reach 10/10" lists: taken or why not

**First critic (code-checked; depth 6, play 6, general 7):**
| # | Item | Answer |
|---|---|---|
| 1 | Make more decisions matter: widen the starting ranges, make the bond bite; 40% of prospects decisive | PARTLY. The bond stays as v8. Wider first looks MEASURED: they lift flips by a point and then break B2 (always-trial ties the careful player), so the widths stay the code's and the scout filter tightens to 2 instead: first look wrong 33.0%, decisive 18.1 -> 24.2%. The 40% bar: 59.6% on the critic's own measure, but that pass comes from the trial's price ($252 a full week); at $125 it reads 26.8%. Said plainly in the result. |
| 2 | Give wait its own read: the prospect's bout inside the window | TAKEN, as the centre of v9 (0.1). MEASURED: wait best in 12.8% -> 32.4%; without the bout 22.1%. |
| 3 | Base the deadline on what the rival sees; drop the stacked minus 7s; keep the floor of 7 | TAKEN (0.4). |
| 4 | Price the test day in time or a held place | TAKEN, further: the test is day 1 of the trial, so it holds a place and spends a day of the clock. |
| 5 | Put the trial's body reading back to 24 | TAKEN (C3). MEASURED: 12 gains nothing. |
| 6 | Settle the trial price: $125 on the map against $500 in code | TAKEN: $36 a day, $252 the week, written as a code change (C1). MEASURED: $18 a day fails B2, $36 and $72 pass. |
| 7 | Charge the weeks left in `let_go_price`; show it on the card | ALREADY IN v8 (stake line, let-go confirm); listed as new work (C5). |
| 8 | Feedback on the next card, not 12 weeks later | TAKEN (0.7, the "Last time" strip; 0.6 cuts the 12-week gate). |
| 9 | Wire one screen to `KnowWire` | TAKEN as step 1 of the order (section 7); C4 confirms nothing is wired. |
| 10 | Re-run the probe with shared dice and the new measures | TAKEN: the dice are shared (stated in the result); decisive share of all prospects, the card-only player's regret against the truth (+$1,024), and filter on / off side by side are in the final table. |
| Missing | Watching the prospect's bout inside the window | TAKEN (item 2). |
| Useless | Numbers after a good read AND 12 weeks or 3 bouts | TAKEN: the second gate is cut (0.6). |

**Second critic (depth 7, play 8, general 9):**
| # | Item | Answer |
|---|---|---|
| 1 | Strengthen the wait read: open session body 12, skills 10 | REFUSED on the measurement: 50.6 / 17.1 / 32.3 against 50.7 / 17.7 / 31.5. No bar moves; the bout does the work. |
| 2 | Trial skills exposure 24 -> 30; keep body at 12 | REFUSED: flips 25.0 -> 25.5 for a code change; body at 12 measured no better than 24. The trial keeps the code's 24 / 24. |
| 3 | Scout filter within 3 -> within 4 | REFUSED on the measurement: 57.1 / 15.6 / 27.3, decisive 20.9, flips 23.6 - worse on every line. v9 goes the other way, to 2. |
| 4 | A partial trial: stop early, keep the read | TAKEN, as the trial's whole shape (0.2). No refund rule is needed: the days are paid as they are used. |
| 5 | Make Pass and letting the window expire differ | TAKEN (3B). |
| 6 | Watch them box: buff it; a habit clue | THE BOUT TAKEN for every scouted name. The habit clue REFUSED here: habits are their own map (v7 split them off). |
| 7 | Remove the "12 weeks or 3 bouts" gate | TAKEN (0.6). |
| 8 | A "why" on the line when a read flips the decision | TAKEN (0.8), worded from the range and the level only. |
| 9 | Compare up to 4 prospects | NOT NEEDED: the list never holds more than two open names (v7 2C); the strip shows both. |
| Missing | A scout filter toggle | REFUSED: without the filter the hunch is right 87% of the time and best in 75.9% (MEASURED) - the toggle's other position is the dull game. |
| Missing | A lever on the rival's window (a better offer) | REFUSED on the measurement: matching the rival's offer at +$50 a week makes the hunch best in 68.2% (B1 FAIL); it removes the loss the window exists for. |
| Useless | Pass against expiry | TAKEN (item 5). |

## 7. Probes
Greybox: `tools/knowstakes9.gd`. Every run: **docs/KNOWSTAKES9_RESULT.md.** One line: **v9 PARTIAL - B1, B2, B3, B4 PASS for
the first time; B5 (how often the choice matters) half met; the no-clock control missed its bar.**
| Bar | v8 | v9 (20,000 maybes) |
|---|---|---|
| B1 best per decision: hunch / look / wait (each 15-60%) | 56.4 / 30.8 / 12.8 - FAIL | **45.4 / 22.2 / 32.4 - PASS** |
| B2 selective beats every arm but the truth, low end > 0 | PASS | PASS, thin over always-trial: +$32 (19..46) |
| B3 selective's reads flip the first-look call 25-60% | 18.0 - FAIL | **25.7 - PASS, by 0.7** |
| B4 the clock adds less than the first paid read | 0.013 vs 0.035 - PASS | 0.015 vs 0.041 - PASS |
| B5 (new) best beats worst by > $250 in >= 40% of all prospects; best beats second by >= $250 in >= 30% | 22.7 / 15.4 | 59.6 (price-led; 26.8 at $125 a week) / **17.8 - FAIL** |
| Decisive decisions, of all prospects | 18.1% | 24.2% |
| Control: no clock -> hunch best under 15% | - | 26.9 - FAIL (with the clock 45.4: the clock does move it) |
**The honest gap.** With three calls, two of which are ways of looking again, one call stands alone only when the other
two both go wrong; the ceiling is the share of wrong first looks (33%) plus the prospects the rival takes. If the critics
hold B5's second half, the next lever is a fourth call that is not a look - for example signing on a short 4-week bond at
a dearer stipend, so the hunch has a cheap and a committed form - not another read strength. Not in v9: unmeasured.

## 8. Order of work
1. One screen reads `KnowWire` (the signing card's ranges), with P-A from v7. 2. The prospect record: bout day, window,
rival's look; the 21-day strip; the trial by the day; the bond; B1-B5 and P-F re-run on the real loop (KNOWBOTS worlds),
including a cash-tight club (section 4). 3. The got-away list, the return bout, the "Last time" strip. 4. Numbers for
signed boxers. Each step is done when its menus show it in the .exe and the golden path walks one prospect to each of
five endings: signed on the hunch, signed on trial day 3, sent home after the pad test, signed at ringside after the bout,
taken by the rival and met again.

## Sources read today
v8 and v7 maps; both v8 critics' answers (`CRITIC_KNOW_STAKES1_V8_BRIEF_KALLI.md`, `_DOLA.md` from line 1031); the first
critic's v7 answer; `docs/KNOWSTAKES8_RESULT.md`; `tools/knowstakes8.gd` (whole); `scripts/rules/KnowReads.gd` (:1-135),
`Knowledge.gd` (constants and function list), `CardAsk.gd` and `VisitWire.gd` (grep: TRIAL_LOSS is at `CardAsk.gd:26` and
`VisitWire.gd:146-149` on today's main - the first critic's copy was two days older), `Leaving.gd:65`; a search of
`scripts/ui` and `scripts/state` for the knowledge code. Probe runs: 56.
