# DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ143)

Brief: research/DESIGN_PLANFLOW1_V3_REVISE_KALLI.md
Sent: 2026-11-15 00:10 | collected: 2026-11-15 00:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing PLANFLOW1 v3 in full now, answering every point from John, Maria and Dola.

# PLANFLOW1 v3: the fight plan as an if-then flowchart, design map (S459, S469, S470, S471, 2026-11-15)

Part 1 of 5

Roadmap row PLANFLOW1. Designer seat: Kalli. Status: v3, for fresh critics. It answers the three v2 critics: John (7/6/7), Maria (7/6/6) and Dola (7/8/7). All three passed the bar; v3 lifts general design, the weakest score.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board and the mockups. The owner's computer is offline, so this map is checked against the critic pack and v2 only.

**Owner rules this map keeps, quoted**
- **S469:** "go with your recommendation". The flowchart is the new look of the plan the game already has, not a second plan system. It ships in stages, simplest first ("ok").
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Boxes, diamonds, arrows, warnings, the round line and tooltips say your boxer, the opponent, your coach.
- **S412:** any gym, any boxers, men or women. No fixed he or she, the opponent's tree included. The code's plan text "she presses" is flagged for "the opponent presses" (CHECK Claude).
- **S425:** every menu and its wiring is in section 11.
- **Pack section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Screens come only from agreed mockups. Nothing opens by itself. No timers. No flavour text. One word per concept.
- **Q-212 (via S470):** no percent stat buffs. Moves are learned, never bought.
- **S439 (via S470):** buttons follow what the game allows at that moment.
- **Pack:** females never fight males; scouting means opponents; classes in kg.
- **S405 / S459:** ESTIMATEs are marked; the map ends with To reach 10/10.

**Tags**
- **CODE:** in the game (pack or S471).
- **NEW:** a small addition, named so Claude can price it.
- **GAME VALUE:** ours by design, with no real source.
- **ESTIMATE:** a starting value the probes size.
- **AGREED, NOT BUILT:** from the pack.
- **CHECK (Claude) / CHECK (John):** open questions.

No probe has run.

## 0. How v3 answers the critics

### 0.1 The six big changes
1. **The opponent's mode is a new tell type (NEW),** with its own place in the tape order. The tree, GUESS and the share bands are tagged as built on it.
2. **Film has one price:** a tape evening is an evening not on pads, in a camp or out of one. In a camp this changes the camp's free Film, so it's owner question 4.
3. **Steps to Sharp are priced at the punch rate** from the same 240 pad units: about 8 weeks on half a pad night, not 4.
4. **Test it plays only against what's known,** so it can't find what film hasn't.
5. **The corner swap is the corner minute's existing "change one plan arrow"** (CODE), drawn on the tree, beside ONE CHANGE, not in place of it. "Resets its PRESSURE" is dropped.
6. **The round filter is cut.** Slow starter and fades late suggest round pace in the Playbook instead.

### 0.2 John's To reach 10/10 (14 points)
| # | Point | v3 |
|---|---|---|
| 1 | Mode as a new tell; tape order | **Done (4.1).** The order is weapon, top unfree mode, habits, second unfree mode, weakness. NEW, CHECK (Claude) |
| 2 | One price for film | **Done (2, 6.2).** Every tape evening costs a pad evening. The camp change waits on owner question 4; without it, section 14 says what's lost |
| 3 | Re-price step pad cards | **Done (5).** 2.1 an hour × 1.25 hours is about 2.6 a full pad night, so 30 to 60 takes about 12 full nights, or about 8 weeks on half a night. STEPS-ONLY runs after |
| 4 | Test against the known file only | **Done (3.5).** Unfound modes are drawn evenly; the result says "2 modes guessed" |
| 5 | GUESS pay rule | **Done (4.3):** "an unfound mode's answer pays as OK, even when right", with a hover |
| 6 | Cut the round filter; suggest pace | **Done (4.4)** |
| 7 | Expected uses per box; pass line per box | **Done (3.1, 9).** Validate warns "rarely reached" |
| 8 | M11 is the plan arrow change; drop the PRESSURE reset | **Done (7.3)** |
| 9 | "Your coach's pick"; a band for 70% | **Done.** No code names on screen; stage 3 prints likely / even / unlikely |
| 10 | Amateur reuse in round 1 only | **Done (6.4).** Tagged GAME VALUE |
| 11 | "Your coach rewrites it"; the opponent's mode count in the minute | **Done (2, 7.3)** |
| 12 | Run the probes | **Not done: I can't run them.** Pass lines are in section 9, and the first batch is named |
| 13 | Settle the CHECKs | **Open (15).** Each row now says what's cut if the answer is no |
| 14 | An aimed shout makes the round active | **Done in part (7.4).** "Lean on it" moves to stage 1 if the shout code allows it (CHECK Claude), otherwise stage 2 |

### 0.3 Maria's To reach 10/10 (10 points)
| # | Point | v3 |
|---|---|---|
| 1 | Owner yes and a drawing before the editor | **Done.** Owner question 1, and the M1, M10, M11 drawings come first. Nothing in stage 1 builds before them |
| 2 | Settle four CHECKs; cut a row on a no | **Done as a rule (15).** Film with no camp, habit as an IF, FireLevel on steps. The round filter is already cut |
| 3 | Probes 1, 2, 4 and 10 first; OK−1 if the gap is small | **Done (9).** If GOOD beats PRESET by under 8, GUESS pays as OK − 1 edge |
| 4 | Re-measure 59/45/41 with GUESS on | **Done (probe 0).** Printed beside the old figures |
| 5 | Price the free picks | **Done.** The timing rule is cut. Copy keeps only drilled pieces. The tires IF sits in every preset and isn't counted as a choice |
| 6 | Where a test's sparring night comes from | **Done (3.5).** It replaces one of the coach's sparring nights in BUILD or PEAK; in BASE it turns a pad night into sparring; never in TAPER. The Week shows "Thu: sparring (plan test)" |
| 7 | Amateur reuse as GAME VALUE, in the first batch | **Done** |
| 8 | A main bet | **Done (3.2).** One diamond carries MAIN BET. The corner read leads with it, and the Why grades it first |
| 9 | A one-step queue for the study slot | **Done (5):** "Next: pivot out (the plan needs it)" moves in when the slot frees. NEW |
| 10 | A live decision in stage 1 | **Done in part:** "Lean on it" (7.4), stage 1 if the CHECK allows |

**Maria's other faults**
| Fault | v3 |
|---|---|
| GUESS weakens a current option | Stated as a change; probe 0 re-measures |
| Test it changes a built feature | Stated (3.5) |
| Lock at the first bell is a change | Stated. No new information arrives between the weigh-in and the bell, so the lock changes no result; probe 0 checks it, with test P7 |
| Presets uncosted | Costed: 6 presets × 4–6 lines, one content task (P1), tuned by probe 2 |
| Coverage count becomes a score | Shown only when an "often" mode is unanswered |

**Maria's missing options:** use the coach's plan and edit one line ("Your coach rewrites it", done); main bet (done); study queue (done); a line on the bout offer, "Your plan against this style last time: +4 to +8" as a band (done, M9).

### 0.4 Dola's To reach 10/10
| Point | v3 |
|---|---|
| Run all probes | Listed (9); I can't run them |
| Film anytime | Done: a Film evening with any bout booked (CHECK Claude) |
| Habit as `when` | CHECK (Claude); a no cuts that habit row |
| Round filters | **Not done:** they answer the wrong question (John 5); round pace does the job |
| FireLevel for steps | CHECK. If steps don't use it, they're priced by their own fire rule, printed the same way |
| Player reorders two diamonds | Only if the code allows two modes at once (CHECK); otherwise there's no number at all |
| Minimum films for "often" | Done: "often" needs 3+ films (4.1) |
| BJJ beats; cutman | Stage 2 and stage 3, unchanged |
| SEEN warning names the line and suggests swaps | Done (7.1) |
| Decoy plan | **Not added as a mechanic:** ProRead waits for the most-thrown punch, and a feint line already blunts it (CODE). Validate shows that punch so the player can steer it |
| Carry the best lines forward | Done: "Start from last bout" keeps the 2–3 lines that fired most and are still at 30+ |
| Preview the opponent's next mode | Done small: the corner read prints the opponent's breathing as likely / even / unlikely to tire next round, from the opponent's Energy band (NEW, CHECK Claude) |
| Tutorial overlay | **Not added:** nothing opens by itself. A "How the chart reads" link on the editor opens the Handbook's plan page (CODE Handbook) |
| Compare two plans | **Not added:** rematches are rare. History shows the plan used each bout |
| Heat map | Done as words, not colour: the tree's hover prints "fired 7 in your last 3 bouts against Pressure fighters" (stage 3) |

**Dola's missing options:**
- **Filter the tree by round:** not added, because films record that a habit showed, not when.
- **Mark a branch low priority:** not added, because the tape order is fixed in the code.
- **Auto-switch preset:** not added, because the style word doesn't change while scouting.
- **Version history:** History per bout covers it.

### 0.5 Options, all lists
| Option | v3 |
|---|---|
| Copy a team-mate's plan (John: by style; Maria: same opponent only) | **By style, drilled pieces only.** It copies only the pieces your boxer has at 30+ and leaves the rest as empty lines: "3 of 5 lines copied; 2 need drilling" |
| Diamond order "1" | Only if two modes can hold at once; otherwise cut |
| Round filter | Cut |
| Tires IF | In every preset; not counted as a choice |
| Coverage count | Only when an often mode is unanswered |
| Expected uses on each box | Added |
| Your coach rewrites it | Added |
| Pace link from a found habit | Added |
| The opponent's mode count in the minute | Added |
| Main bet, study queue, offer line | Added |

Part 2 of 5

## 1. The idea
The plan is a chart your boxer carries into the ring. Each box starts with a diamond: "IF the opponent is pressing". The diamond leads to the answer: "THEN step back and counter with the right hand". Film fills in the diamonds you can trust. Pads make the answers sharp.

In the fight, the game picks the box for the mode the opponent is in (CODE: six modes). It then throws that box's answer, at its FireLevel (CODE). The opponent's last two pro fights decide whether one of those answers is waited for (ProRead, CODE).

The player's work is three choices:
1. Which modes to plan for.
2. Which answers are worth the pad time.
3. Which box to trust most (MAIN BET).

In the corner, the player gets one plan arrow change a round (CODE), on top of ONE CHANGE (CODE).

## 2. What the game already has (CODE)
| Piece | Value | Source |
|---|---|---|
| Plan line worth | edge best 9 / ok 3 / wrong −7; an undrilled line ×0.8 | pack 4.6 |
| Line cap | 4–6, set by the coach | pack |
| FireLevel | 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature | S450 |
| PlanRead | full pay for the first 2 uses of a line in a round, then less; resets at the bell | pack |
| ProRead | pros only: waits for the most-thrown punch of the last two pro fights; two weapons or a feint line blunt it | pack |
| Fight modes | Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt | pack |
| Opponent's file | weapon, habits, weakness, opened in tape order (weapon first, weakness last) | pack 4.3 |
| Camp Film | free in a camp; a Film evening is a Week evening | pack 4.3 |
| Pads | 2.1 mastery an hour; a pad night is 240 units | pack |
| Steps | 10 steps; one study slot gives about 6 a week to Usable 30; nothing passes 30 today | S463 |
| Corner minute | ONE CHANGE (a habit fix / Elbows in / Gloves high) and a separate change to one plan arrow | pack 4.8 |
| Results | good plan 59 / no plan 45 / bad plan 41 | pack |
| Corner scores | corners never see scorecards during a bout | EB 12.10.1, IBA 18.8 (John) |

## 3. The chart (M1, the Playbook editor)

### 3.1 The board
- **Left:** the opponent's tree (from scouting). **Right:** your boxer's chart.
- One box for each mode you plan for, at most as many as the line cap allows. Each box holds one diamond and one answer.
- **Box parts:** the diamond (IF), the answer (THEN: a punch, a combination or a step), the answer's FireLevel stamp (USABLE / SHARP / SIGNATURE), and the uses line.
- **Uses line (NEW, ESTIMATE until probe 6):**
  - "About 1 use a round, 1 in full" on most boxes.
  - "About 3 uses a round, 2 in full" on the bell box. The bell box is the always-on answer, used when no diamond holds.
- **Rarely reached:** a box expected under 0.5 uses a bout shows "rarely reached" (ESTIMATE, from probe 6).

### 3.2 Main bet (NEW)
- One diamond can carry the MAIN BET magnet.
- The corner read opens with it: "Main bet: pressing. Met 3 times, paid 2."
- The Why after the bout grades it first.
- It costs nothing and changes no number. It sets what the player sees first.
- Gold stays on the worth band only, so the magnet is slate with the word MAIN BET.

### 3.3 Buttons
| Button | Does | Stage |
|---|---|---|
| Use a preset | Picks one of 6 style presets (Pressure, Range, Counter, Power, Survive, Balanced). Each has 4–6 lines and already includes the tires IF | 1 |
| Your coach rewrites it | The coach builds the plan from found tells and drilled pieces within the cap; you then edit any line | 1 |
| Start from last bout | Keeps the 2–3 lines that fired most last bout and are still at 30+ | 1 |
| Copy a team-mate's plan | By style. Keeps only pieces at 30+: "3 of 5 lines copied; 2 need drilling" | 2 |
| Test it | One sparring night against the known file (3.5) | 1 |
| Save / Load | Named plans per boxer | 1 |
| How the chart reads | Opens the Handbook's plan page (CODE Handbook) | 1 |

### 3.4 Validate (the strip under the board)
At most 3 lines, each with a fix button:
- "Pressing: often, no box. Add it" (only when an often mode is unanswered).
- "Right hand to the body: not drilled, pays ×0.8. Put it on pads"
- "Slow starter found. Push round 1: Use it" (4.4).
- SEEN warnings for pros (7.1).
- "Rarely reached: clinch box"

### 3.5 Test it (NEW, changes a built feature)
- **Night:** it takes one of the coach's sparring nights in BUILD or PEAK. In BASE it turns one pad night into sparring. Never in TAPER. The Week shows "Thu: sparring (plan test)".
- **Against:** only the known file. Unfound modes are drawn evenly from the ones left.
- **Result:** "Worth: +4 to +9. 2 modes guessed." It finds no tells.
- **Why it costs:** a test night spends the sparring night's units (180, CODE) on the plan, not on general sparring gains.

## 4. The opponent's tree (left side)

### 4.1 Tells (NEW: modes as a tell type)
- **Tape order:** weapon, top unfree mode, habits, second unfree mode, weakness.
- A free mode is known from the style word. A Pressure fighter's "Pressing" is free.
- **Share bands:** "often" needs 3+ films and a mode shown in at least 3 of 4; "some"; "rare". With under 3 films, the most a mode can show is "some" (NEW, ESTIMATE).
- Film opens one tell per Film evening (CODE rate kept).

### 4.2 Habits as triggers
- A found habit can be a diamond: "IF the opponent drops the left after a jab". CHECK (Claude): can a plan line's `when` take a habit?
- If not, habit rows are cut and habits stay ONE CHANGE fixes only.

### 4.3 GUESS (NEW, changes results)
- A box can answer a mode not yet found.
- **Pay rule:** an unfound mode's answer pays as OK, even when it's right. The hover says "Not found on film: pays as OK."
- If probe 1 finds GOOD beats PRESET by under 8, GUESS pays as OK − 1 edge, so film keeps its worth.
- Probe 0 re-measures 59/45/41 with GUESS on and prints both sets.

### 4.4 Round pace (replaces the round filter)
- A found "slow starter" or "fades late" habit puts one line in Validate: "Slow starter found. Push round 1: Use it".
- Use it sets round 1's existing pace choice (CODE fight plan pace, CHECK Claude). It adds no new control.
- If no pace control exists by round, this line is cut.

Part 3 of 5

## 5. Pad time and steps (the cost side)
- **Punch or combination answers:** CODE pad rate, 2.1 an hour.
- **Step answers (NEW pricing):** the same 240 units at the punch rate.
  - A full pad night is about 2.6 mastery (2.1 × 1.25 hours; ESTIMATE, CHECK Claude that 240 units is 75 minutes).
  - Usable 30 to Sharp 60 takes about 12 full nights. On half a pad night, 3 nights a week, that's about 8 weeks (ESTIMATE).
  - The study slot still takes a step to 30 at about 6 a week (S463), so a step reaches 30 in about 5 weeks.
- **Pad card:** "Pivot out: 34 now, Sharp in about 8 weeks on half a night"
- **Study queue (NEW):** one step waits behind the slot: "Next: step back (the plan needs it)". It moves in when the slot frees. Nothing else changes.
- **STEPS-ONLY** (probe 8) runs after this pricing to check a step plan isn't stronger than a punch plan for the same pad time.

## 6. Film, the Week, the amateur game

### 6.1 The offer line (M9, NEW)
- The bout offer shows "Your plan against this style last time: +4 to +8" (a band from that bout's Why).
- It shows only if your boxer has met that style.

### 6.2 One price for film
- **A Film evening** is a Week evening not on pads (CODE).
- **In a camp (owner question 4):** each tape day takes one of the camp's evenings (Light 3, Standard 4, Hard 5; CODE counts). The camp's Film tick shows "Film: 2 evenings (2 tells)".
- **If the owner says no:** camp Film stays free, the film lever only costs outside camps, and section 14 names that risk.
- **Film anytime (Dola):** a Film evening can be set with any bout booked, not only in a camp (CHECK Claude).

### 6.3 Week cost, worked (ESTIMATE)
- A 4-week camp at Standard has 16 evenings. Three film days open the weapon, the top mode and one habit, which leaves 13 for pads.
- Spending those 3 on pads instead buys about 4 mastery on one line (3 × 1.3, at half a night each).

### 6.4 Amateur reuse (GAME VALUE)
- Amateurs have no ProRead.
- **In round 1 only:** a plan used unchanged against the same opponent's club twice in a row starts with its first box SEEN, which halves that box's first full use.
- It's a game value, not a real rule. Probe AMREUSE in the first batch sizes or cuts it.

## 7. In the fight

### 7.1 SEEN (pros only, CODE ProRead)
- **Validate:** "SEEN: right hand at range was your most-thrown in the last two pro fights. Swap to the left hook or add a feint line."
- It names the read line and suggests 1–2 swaps from drilled pieces.
- It also shows "Most-thrown across your last two pro fights: right hand". This is the honest decoy: the player steers it over a career.
- **Named plan SEEN** (owner question 3) is stage 3.

### 7.2 The round line (M10)
- After each round, one line: "Pressing 4 times. Box met 4, paid 2 in full. Main bet held."

### 7.3 The corner minute (M11)
- **Row 1, ONE CHANGE (CODE):** habit fix / Elbows in / Gloves high / No fix.
- **Row 2, the plan arrow (CODE):** change one arrow on the tree, or Keep the plan.
  - The new answer starts fresh under PlanRead. That's the gain (CODE reset at the bell).
  - There's no PRESSURE reset.
- **The opponent's mode count:** "The opponent pressed 1 of 6 exchanges"
- **Breathing (NEW, CHECK Claude):** "The opponent: likely to tire next round" (likely / even / unlikely, from Energy bands).
- No scores. Corners never see cards (EB 12.10.1, IBA 18.8).

### 7.4 Lean on it (NEW)
- When a found mode shows in an exchange, the strip offers "Lean on it". It spends one of the two shouts a minute (CODE).
- **Effect:** that box's answer pays in full for one more use this round, past PlanRead's 2 (ESTIMATE; probe 11 sizes it).
- **Stage:** 1 if a shout can aim at a box (CHECK Claude), otherwise 2.

### 7.5 After the bout (the Why)
- Main bet first, then each box: met, paid, missed.
- Then one line: "Next camp: drill the left hook (fired 1 in 2)."
- The bout's plan is saved to History.

Part 4 of 5

## 8. Worked examples (EXAMPLE DATA, ESTIMATE values)

### 8.1 Amateur, women's 60 kg: a Counter style opponent
- **Film:** 2 Film evenings open the weapon (left hook) and the top unfree mode (Pressing, some).
- **Plan:** a Counter preset, then Your coach rewrites it.
  - Box 1, Waiting to counter (free): feint then step in. MAIN BET.
  - Box 2, Pressing (found): step back, right hand. SHARP.
  - Box 3, Loading up (GUESS): pays as OK.
  - The tires IF comes with the preset.
- **Validate:** "Right hand: not drilled, ×0.8. Put it on pads". The player puts it on half a night.
- **Test it:** BUILD week, Thu sparring. "Worth +3 to +8. 1 mode guessed."
- **In the fight:**
  - Round 1 line: "Waiting to counter 3 times. Main bet met 3, paid 2."
  - Corner: "The opponent pressed 2 of 6 exchanges"
  - Arrow change: box 3 to step back. ONE CHANGE: Gloves high.

### 8.2 Pro, men's 70 kg: SEEN
- **Validate:** "SEEN: jab-right was your most-thrown in the last two pro fights. Swap to jab-hook or add a feint line." The player adds a feint line, which takes 1 of 5 lines.
- **Steps:** "Pivot out: 34 now, Sharp in about 8 weeks on half a night". The player leaves it at Usable and uses the queue: "Next: step back".
- **Lean on it:** used in round 3 on the Pressing box, spending 1 of 2 shouts.

## 9. Probes (none run)
**First batch:** 0, 1, 2, 4, 10, AMREUSE.

| # | Probe | Pass line |
|---|---|---|
| 0 | Re-measure 59/45/41 with GUESS on and the bell lock | Both sets printed; GOOD stays ≥ 56 |
| 1 | GOOD vs PRESET | GOOD beats PRESET by 8+, else GUESS pays OK − 1 |
| 2 | Each preset alone | Each 50–55 against its own style (ESTIMATE) |
| 3 | Film worth: 3 tape days vs 3 pad half-nights | Film wins against an unknown style, pads win against a known one |
| 4 | Test it accuracy against the known file | Band holds the real result 2 in 3 |
| 5 | SEEN with and without a feint line | The feint cuts the loss by half |
| 6 | Uses per box | Every box planned for an often mode gets 0.5+ uses a bout in half the bouts; prints the uses lines |
| 7 | Arrow change in the minute | Positive for the boxer behind on mode count |
| 8 | STEPS-ONLY vs PUNCH-ONLY, same pad time | Within 3 points |
| 9 | Start from last bout vs fresh | Within 2 (carry-over is a time saver, not a buff) |
| 10 | Your coach rewrites it vs GOOD | Within 3 below |
| 11 | Lean on it | +1 to +2 a use when spent on a found mode |
| AMREUSE | Round 1 reuse | Sized or cut |

## 10. Build (each a small task for Claude)
| # | Task | Stage |
|---|---|---|
| P0 | Owner yes to the chart look; drawings of M1, M10, M11 agreed | before all |
| P1 | 6 presets × 4–6 lines (content task, Kalli writes, probe 2 tunes) | 1 |
| P2 | Mode as a tell type in the tape order; share bands | 1 |
| P3 | GUESS pay rule and its hover | 1 |
| P4 | Chart view of the existing plan lines (M1) | 1 |
| P5 | Uses line, rarely reached, Validate (3 lines max) | 1 |
| P6 | Your coach rewrites it; Start from last bout; Save/Load | 1 |
| P7 | Lock at the first bell (from the weigh-in) | 1 |
| P8 | Test it on a sparring night | 1 |
| P9 | Step pad pricing; study queue of one | 1 |
| P10 | Round line (M10); corner mode count and arrow on the tree (M11) | 1 |
| P11 | Main bet magnet | 1 |
| P12 | Pace link from habits (if the CHECK allows) | 1 |
| P13 | Lean on it | 1 or 2 |
| P14 | Offer line (M9); film evening anytime | 2 |
| P15 | Copy a team-mate's plan, drilled pieces only | 2 |
| P16 | Breathing band in the corner | 2 |
| P17 | BJJ beats; cutman; named plan SEEN; the fired hover | 3 |

Part 5 of 5

## 11. Every menu and its wiring (S425)
| Menu | What the plan shows | Wired to |
|---|---|---|
| M1 Playbook editor | Tree, chart, Validate, buttons | Plan lines (CODE), opponent's file, pad mastery |
| M2 Opponent file | Tells in tape order, share bands | Scouting / Film (CODE) |
| M3 Week | Film evenings, "Thu: sparring (plan test)" | Week evenings (CODE) |
| M4 Camp | Film tick with evening count | Camp nights (owner question 4) |
| M5 Pads | Pad cards with "Sharp in about n weeks" | Pad mastery (CODE) |
| M6 Study slot | Current step and "Next:" | StepMastery (S463), queue NEW |
| M7 Boxer profile | Plan tab: saved plans, main bet | Save/Load |
| M8 Team-mate's profile | Copy plan (stage 2) | Copy rule |
| M9 Bout offer | "Your plan against this style last time" | The Why history |
| M10 Round line | Mode, met, paid, main bet | FireLevel, PlanRead (CODE) |
| M11 Corner minute | ONE CHANGE, plan arrow, mode count, breathing | Corner (CODE), Energy band (NEW) |
| M12 Fight strip | Lean on it | Shouts (CODE) |
| M13 Weigh-in | "Plan locks at the first bell" | Lock P7 |
| M14 The Why | Main bet, boxes, next drill | Fight log |
| M15 History | Plan per bout | Save |
| M16 Handbook | The plan page | Handbook (CODE) |

## 12. Words (one per concept)
| Word | Means |
|---|---|
| plan | the whole chart |
| box | one IF-THEN pair |
| diamond | the IF |
| answer | the THEN |
| mode | what the opponent is doing (six) |
| tell | anything film finds |
| MAIN BET | the box to watch first |
| SEEN | a box the opponent waits for |
| GUESS | a box for an unfound mode |
| Test it | a sparring night against the known file |
| Lean on it | the shout that extends a box |

## 13. Stages
- **Stage 1:** P0–P12, and P13 if the CHECK allows.
- **Stage 2:** P13–P16.
- **Stage 3:** P17, and diamond order if two modes can hold at once.

## 14. Risks
- **GUESS shrinks film's worth.** The guard is the OK pay rule, plus OK − 1 if probe 1 fails.
- **If owner question 4 is no,** film costs nothing in a camp, and the film choice only bites in fights booked without a camp.
- **The chart is a second look at one system.** The rule is that one plan feeds both the list and the chart. There's no second store.
- **ESTIMATE uses lines can mislead** until probe 6 runs. Each one has a hover saying "estimate".
- **Six presets may play alike.** Probe 2 tunes them.

## 15. Open questions
**Owner**
1. Does the chart replace the move map as the plan's first view, and are the M1, M10, M11 drawings OK?
2. The last-round trigger: stage 3 with its uncertainty printed, or cut? A corner's own count isn't found as a rule (John).
3. Named plan SEEN in stage 3: yes or no?
4. Does film in a camp take a camp evening?

**CHECK (Claude), each cut on a no**
- Habit as a line's `when` (cuts 4.2).
- Two modes at once (cuts diamond order).
- FireLevel on steps (if no, steps print their own fire rule).
- 240 units equal 75 minutes (re-prices section 5).
- A shout aimed at a box (moves Lean on it to stage 2).
- Pace by round (cuts 4.4).
- Opponent Energy readable as a band (cuts breathing).
- Film evening with no camp (cuts film anytime).
- "she presses" in the plan text (flagged under S412).

**CHECK (John):** Is "often" at 3+ films fair against how much film real amateur corners see? Mark it GAME VALUE until answered.

## 16. Self-score: depth 7, general design 7, play 7

**To reach 10/10**
1. Get owner answers 1–4 and the drawing OK, then build stage 1.
2. Run the first batch (0, 1, 2, 4, 10, AMREUSE) and replace every ESTIMATE in sections 3.1, 5, 6.3 and 7.4 with measured values.
3. Settle the nine CHECKs, and cut every row whose answer is no.
4. If probe 1 fails even with OK − 1, cut GUESS to stage 2 and make film the only way to open a box.
5. Run STEPS-ONLY after the re-price, and set the step pad rate from it.
6. Size AMREUSE, or cut it.
7. Write the six presets (P1) and tune them with probe 2.
8. Build the breathing band only if probe 7 shows the arrow change pays for the boxer behind.
