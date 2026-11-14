# DESIGN_PLANFLOW1_V2_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ122)

Brief: research/DESIGN_PLANFLOW1_V2_REVISE_KALLI.md
Sent: 2026-11-14 18:40 | collected: 2026-11-14 19:11 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Writing PLANFLOW1 v2 now, in five parts.

# PLANFLOW1 v2: the fight plan as an if-then flowchart (S459, S469, S470, S471, 2026-11-14)

Part 1 of 5

Roadmap row PLANFLOW1. Designer seat: Kalli. Status: v2, for fresh critics.

**What v2 does:**
- It answers the three v1 critics: Dola (7/8/6), Maria (7/6/6) and John (6/5/7, which misses the bar on general design).
- It follows Claude's S471 facts and rulings.
- It folds in the four owner pictures (S470) as Claude's verdicts take them.

The bar is 6+ DEPTH and 6+ GENERAL DESIGN (S459).

**Owner rules this map keeps, quoted:**
- **S469:** "go with your recommendation". The flowchart is the new look of the plan the game already has, not a second plan system. It ships in stages, simplest first ("ok").
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Boxes, diamonds, arrows, warnings, the round line and tooltips say your boxer, the opponent, your coach.
- **S412:** any gym, any boxers, men or women. No fixed he or she on these pages, the opponent's tree included.
- **S425:** every menu it appears on, and what each is wired to (section 11).
- **Pack section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- **Pack:** no timers; nothing opens by itself; no flavour text; one word per concept; females never fight males; scouting means opponents; classes in kg.
- **Q-212 (owner, via the S470 verdict):** no percent stat buffs. Moves are learned, never bought.
- **S439 (via S470):** buttons follow what the game allows at that moment.
- **S405 / S459:** mark ESTIMATEs; end with To reach 10/10.

**Tags:**
- **CODE:** in the game (pack or S471).
- **NEW:** a small addition, named so Claude can price it.
- **ESTIMATE:** a starting value the probes size.
- **AGREED, NOT BUILT:** from the pack.
- **CHECK (Claude) / CHECK (John):** open questions.

No probe has run, so every target win rate is ESTIMATE.

## 0. How v2 answers the critics

### 0.1 Facts v1 got wrong, now corrected (S471)
| v1 said | Fact (S471) | v2 |
|---|---|---|
| Steps are cheap or free (the critics' reading) | `StepMastery` (S463, CODE): 10 bars given at signing from Footwork. A step fires by its bar, and under 30 the coach never plans it. One study slot raises a step about 6 a week, so step back goes from 0 to 32 in about 5 weeks. Nothing takes a step past 30 | steps are priced by the study slot, and a route to Sharp is added as NEW (section 5). A STEPS-ONLY bot is in the probes |
| Adjusting and ProRead tagged CODE | `PlanRead` (CODE): a line pays in full for its first 2 uses in a round, then less, and resets at the bell. `ProRead` (CODE, pros only): reads the last two pro fights and waits for the most-thrown punch; two real weapons or a feint line blunt it | tagged as built. Amateur reuse gets a small NEW rule (6.4) |
| Film costs a pad night | CODE: Film is a Week evening, so a film evening is a pad evening not taken | kept. Film with a bout booked but no camp is a CHECK (Claude) |
| Baseline 59 / 46 / 43 | pack: 59 / 45 / 41, one matchup | pack figures used |
| Ten IFs, four of them invented modes | the fight has six modes | IFs are the six modes. The real habits are found IFs or timing rules (section 4) |

### 0.2 John's To reach 10/10 (13 points)
| # | Point | v2 |
|---|---|---|
| 1 | Price the step answers | **Done (5).** The study slot is the price to reach Usable; NEW pad cards take a step to Sharp; STEPS-ONLY bot |
| 2 | IFs are the six modes; habits are modifiers | **Done (4).** The four invented modes are held back as fight-engine work (14) |
| 3 | Correct the tags | **Done.** Found-only is NEW and softened: an unfound mode can still carry a diamond, marked GUESS and rated OK at best (4.3). Adjust and ProRead are CODE per S471, so the 7 against 3.7 problem the pack described no longer applies; a probe still checks that a second weapon wins back half (9) |
| 4 | Film without a camp | **Done (3).** A Film evening opens a tell whenever a bout is booked, CHECK (Claude). The Tape Room opens from Fight prep. No bouts means no tape (CODE) |
| 5 | One Plan B | **Done (3.3).** A "lost: back here" arrow from every box to the opening box; no bar, no decision. `when: lost_last` is held back: the arrow already shows the same thing |
| 6 | One word per idea | **Done.** PRESSURE is your edge; "seen" means their corner has read a line; bait is PRESSURE with a target |
| 7 | Answers from the book only | **Done (4.2).** Book moves, book combinations and the 10 steps. Nothing new is added as content |
| 8 | Slots | **Done (3.4).** The coach's 4–6 lines are shared by boxes and diamonds; stage 3 adds bouts or Fight IQ, cap 7 |
| 9 | Test it costs a sparring night; lock at the first bell | **Done (3.5, 2)** |
| 10 | Baseline and probes across six styles | **Done (9).** Probe 8 runs against the stronger GOOD |
| 11 | BJJ | **Done in part.** Stage 2, not stage 1, per Claude's ruling, which puts boxing first. Positions as boxes over BjjTree, with two free IFs |
| 12 | Smaller live panel | **Done (12.2):** a 300 px strip |
| 13 | Missing buttons | **Done:** load the saved plan, copy a team-mate's plan, clear one |

### 0.3 Maria's To reach 10/10 (10 points)
| # | Point | v2 |
|---|---|---|
| 1 | Close the free-answer hole | **Done (5)** |
| 2 | Film against pads in code | **Done:** CODE per S471. The tray prints "Film night: −1 pad night" |
| 3 | Tag adjusting honestly | **Done:** PlanRead is CODE. Amateur reuse NEW (6.4), with its own probe |
| 4 | Probes plus STEPS, one S396 source | **Done (9)** |
| 5 | No colour-only state | **Done:** BEST / OK / WRONG / GUESS, "+2" and "−1", FIRED and SEEN are all printed as words |
| 6 | Settle the CHECKs; drop habits with no tell name | **Done:** the four invented habits are dropped; the remaining CHECKs are listed (15) |
| 7 | The hurt rule as one line | **Done:** one line in THE FILE in stage 1; the emergency box comes in stage 2 |
| 8 | Hurt IF against "Go for the finish" | **Done:** the shout wins and spends its instruction |
| 9 | Something to steer in stage 1 | **Done (7.3):** the corner swap lists dead diamonds first, with the swap list taken from your boxer's drilled bench |
| 10 | PNGs | **Not done here:** this is the words map. The pages are specified in section 12 for the board session |

### 0.4 Dola's To reach 10/10
| Point | v2 |
|---|---|
| Run probes; resolve the CHECKs; verify the margin | **Probes listed with pass lines (9). I can't run them.** S471 settled four CHECKs; the rest are in section 15 |
| Ship the stage 2 features with stage 1 | **Not done.** The owner ruled the simplest stage first (S469). Stage 1 gets the corner swap on the tree instead, so it isn't passive |
| Habit confidence tiers | **Done:** the share "n of m films" and a band (often / some / rare) |
| Habit co-occurrence | **Not done:** films record that a habit showed, not the order of modes, so co-occurrence would be invented |
| Plan health rating | **Done as Validate (7.1):** plain warnings and a coverage count, **no score** (owner picture verdict) |
| Six presets | **Done (3.6)**, as content to write |
| Habit-pattern suggestions in the Tape Room | **Done in part:** YOUR ANSWER suggests from your boxer's drilled bench. There are no pattern sets (no co-occurrence data) |
| Named plans with memory | **Stage 3 (8)** |

### 0.5 Options both lists named
| Kind | Option | v2 |
|---|---|---|
| Missing | Load the saved plan for this opponent (rematch) | added: editor and Rival file |
| Missing | Copy a team-mate's plan | added: same opponent or same style |
| Missing | Drill a step | study slot to 30, NEW pad cards to 60 |
| Missing | Film without a camp | the Week evening popover (CHECK Claude) |
| Missing | Clear one | an × on each box and diamond |
| Missing | Diamond order | numbered when two can hold at once (3.2) |
| Missing | Hold the plan | already exists: "Say nothing / No fix" in the corner minute (CODE) |
| Missing | A reset-reads button | not added: PlanRead resets at every bell anyway (CODE) |
| Missing | The opponent's likely opening | the opponent's tree (7.2) shows the bell card and the most-shown mode |
| Missing | Diamonds that haven't fired by round 2 | the corner swap lists them first (7.3) |
| Useless | Set Plan B; the Plan B bar | cut |
| Useless | Lock at the weigh-in | cut; locks at the first bell |
| Useless | Limited test tries | cut; a test costs a sparring night |
| Useless | A HURT stub on every box | cut; one line in THE FILE |
| Useless | Two diamonds on one mode on one box | blocked by the editor |
| Useless | A diamond on a rare habit | Validate warns |
| Useless | Load preset once your own plan exists | shown only with no plan, or behind "Start again" |
| Useless | Late edits with red stamps | Validate runs on the Fight prep button until the first bell |

Part 2 of 5

## 1. The idea
- **The plan is a chart.** A plan is drawn as boxes (what your boxer throws or does in a place after a won exchange) and diamonds (IF the opponent is fighting a certain way, do this instead).
- **What it costs:**
  - Every piece is a move, combination or step your boxer must have drilled.
  - Every non-free diamond needs film.
  - Every test costs a sparring night.
- **The opponent's file is the same kind of chart,** filled in by film, so you read the opponent the way you write your plan.
- **On the night:**
  - A small strip shows which piece FIRED.
  - The corner minute shows the counts and allows one swap.
  - The result lights up the whole chart.

## 2. The decisions, in order
| When | What the player chooses | Price | Tag |
|---|---|---|---|
| Bout booked | nothing; your coach's preset for the opponent's style loads (free modes only) | none; about half a good plan | CODE (the assistant writes one) + NEW (preset per style) |
| Any week before the bout | Film evenings: each opens one tell, filling a branch of the opponent's tree | a pad evening not taken (about 240 drill units) | CODE; without a camp, CHECK (Claude) |
| Pro only | Scout ($250): weapon and weakness at once | $250 | CODE |
| Before the bout | the study slot: one step toward Usable 30 | the slot is single, about 6 a week | CODE (S463) |
| Before the bout | the editor: boxes per place, diamonds on modes, within the coach's 4–6 lines | each piece is a drill card | CODE (line cap) |
| Before the bout | the tray "THE PLAN vs the opponent": drag each piece's drill card to a pad night | pad time | CODE |
| Before the bout | Test it in sparring | that evening is sparring, not pads; it also spreads 180 units over the plan's moves | CODE (Test it, sparring units) + NEW (the price) |
| Before the bout | Validate: read the warnings and fix or accept | free | NEW |
| First bell | the plan locks | none | NEW (moves the lock to the bell) |
| Live | nothing to set in stage 1; the shouts are as today. "Go for the finish" beats a hurt diamond | a shout | CODE |
| Corner minute | ONE swap on the tree: replace or remove one piece, or say nothing | one a round; swapping a piece resets its PRESSURE | CODE (one change) + NEW (drawn on the tree) |
| After the bout | read "The plan, lit up", then save the plan to this opponent's file | none | CODE (view) + NEW (save) |

## 3. The chart, mapped to the code

### 3.1 Pieces
| On the page | In the code | Tag |
|---|---|---|
| Opening box: "BELL: <place>" and its move | the any-time arrow on the card the opponent's game puts your boxer on at the bell | CODE (PlanFight, PlanBoard) |
| A box | the any-time arrow `{move, when: any}` on one place's card | CODE |
| Arrow from box to box, labelled with a place | where a won exchange leaves your boxer | CODE (PlanChain) |
| A diamond beside a box | a situation arrow `{move, when: <mode>}` on that card, taken first when the mode holds | CODE (PlanBoard.pick) |
| BEST / OK / WRONG printed on a diamond | the code's rating against the opponent's game | CODE |
| GUESS printed on a diamond | a diamond on a non-free mode film hasn't found: rated OK at best | NEW |
| "+2.1 edge" on a box | match × pad time − the average of what your boxer can do on that card | CODE |
| Tier and number ("SHARP 64"), fire rate ("3 in 4") | mastery and FireLevel: 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature | CODE (S451); for steps, CHECK (Claude) that FireLevel applies |
| Red stamp "UNDER 30: SKIPPED" | under 30 the coach skips it | CODE (S464, S463) |
| SEEN on a piece (pros) | the most-thrown punch across the last two pro fights, which ProRead waits for | CODE (ProRead) |
| THE FILE line "Hurt: holds this place" | the S466 rule | CODE |

### 3.2 Rules on the board
- **One box per place.** The six places are outside, long, mid, inside, clinch and ropes. The board allows a box on every place; the line count is the cap, not 4. On the ropes is a place, so it's a box, never an IF. A won exchange that leads back to a place already on the board draws as an arrow back up.
- **One diamond per mode per box.** A second is blocked. Two diamonds on one box with different modes can both hold in one exchange only if the code allows two modes at once. If it does, the one PlanBoard.pick takes first is numbered 1. CHECK (Claude) the pick order. If the player can reorder it, that's NEW; if not, the number is shown only.
- **A diamond on a place with no box** is legal (CODE) and drawn on a dashed box: "no main move here: improvises".

### 3.3 One Plan B (S471 ruling)
- Every box has a thin arrow back to the opening box, labelled "lost: back here". A lost exchange puts your boxer on the opponent's card, which is the bell card (CODE, PlanFight).
- So Plan B is the opening box, written once. There's no bar and no separate decision.

### 3.4 Lines (slots)
- **Stage 1:** boxes and diamonds share the coach's 4–6 lines (CODE). The opening box counts.
- **Stage 3:** +1 at 12 bouts or at Fight IQ 65, whichever comes first, cap 7 (ESTIMATE).
- **Shown** as "Lines 5 of 6"; hover names the source ("your coach: 6").

### 3.5 Test it
- A sparring night with the plan on: the code runs the plan against the opponent's file (CODE Test it) and the night also drills it (180 units, CODE).
- **Result:** worth over no plan as a band ("+6 to +10", NEW: a band, not one number), and which diamonds fired.
- No count of tries and no free Simulate button: each test is an evening (owner picture verdict).

### 3.6 Presets
- One preset per style word (6: Out-boxer, Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher, Slugger). NEW content.
- Each preset uses free modes and your boxer's moves at 30+ only, sized so probe 2 passes.
- "Rate against another kind of opponent" stays for practising with no bout booked (CODE, pack section 6).

Part 3 of 5

## 4. The IFs: six modes, and the habits on top

### 4.1 Modes (CODE, the fight's own)
Free means known from the style word at booking (CODE: the style word is free). Found means a Film evening, the Tape Room or the pro Scout opened it.

| IF the opponent… | Free for | Otherwise |
|---|---|---|
| presses | Pressure fighter, Slugger, Volume puncher | found |
| boxes at range | Out-boxer | found |
| waits to counter | Counter-puncher | found |
| loads up | Slugger, Boxer-puncher | found |
| tires | everyone | free |
| is hurt | everyone | free; "Go for the finish" shouted the same exchange wins |

### 4.2 Answers (book only)
- **Moves:** Jab, Cross, Lead hook, Body hook, Uppercut, Check hook.
- **Combinations:** 1-1, 1-2, 1-1-2, 2-3, 1-2-3, 1-2-3-2, 3b-3, 1-2-3b, 1-6-3, slip 2-3, plus your boxer's own saved combinations.
- **Steps:** step in, step out, step back, pivot out, cut off, herd, feint, tie up, roll out, push off.
- The code rates each answer BEST / OK / WRONG against the opponent's game.
- The editor's suggestion list shows your boxer's drilled answers, BEST first. v2 prints no ratings of its own, because the code decides them.

### 4.3 GUESS (answers John 3)
- A diamond on a mode film hasn't found can still be placed, as today. It prints GUESS and counts as OK at best (NEW).
- Found turns it to its real rating. That keeps what players can do now, and film stays the only route to BEST against an unfree mode.

### 4.4 Habits on the file (CODE habits; how each enters the chart)
| Habit (found by film) | In the chart | Tag |
|---|---|---|
| drops the right after the jab | a found diamond, "after its jab", answered over the top (Cross, slip 2-3, Check hook) | habit CODE; whether PlanBoard.pick can take a habit as `when` is CHECK (Claude) |
| slow starter | timing rule: a diamond can be set to "round 1 only", for example presses in round 1 | NEW (a round filter on a diamond), CHECK |
| fades late | timing rule: "from round 3" on the tires diamond, so its answer is ready early | NEW, CHECK |
| chases the stoppage | a found diamond on your boxer being hurt: the stage 2 emergency box can answer it with tie up or roll out | stage 2 |

**Share.** Each found habit or mode prints "showed in n of m films", with a band: often (3+ of 4), some (2 of 4), rare (1 of 4). NEW (the count per tell, CHECK Claude). No percent.

**Held back:** shells up, circles away, switches stance, bites on feints. They're new fight modes, which is engine work (14).

## 5. Steps: what an answer that moves costs
| Stage of a step | How it's reached | Price | Tag |
|---|---|---|---|
| Given at signing | from Footwork | none | CODE |
| To Usable 30 | the WHAT TO LEARN NEXT study slot, about 6 a week (step back 0 to 32 in about 5 weeks) | the slot holds one step at a time | CODE (S463) |
| Usable to Sharp 60 | NEW: a Usable step can go on a pad night as a drill card, at the pad rate in units. Sparring gives steps a share of its 180 units like moves | pad time, shared with the plan's punches | NEW, ESTIMATE about 4 weeks on half a pad night |
| On the night | fires by its bar; under 30 it's never planned | none | CODE |

**Why this closes the hole:**
- A step answer costs either weeks of the single study slot or pad time, the same budget as punches.
- S471 measured a well-read plan on low step bars at +0.13 over no plan, against the coach's +0.09. So a steps-first plan only pays once the steps are drilled.
- The STEPS-ONLY bot must finish under GOOD (9).

## 6. Depth: why a good chart beats a lazy one

### 6.1 Measured today
- **Good plan 59%, no plan 45%, bad plan 41%,** one matchup (pack). Training beats planning: a 5-point stat gap wins about 72%, a 10-point gap about 95% (pack).
- **One change is small:** in the S469 brief's 20 sample bouts, the plan as written won 9 of 40, and the best single change 11 of 40.

### 6.2 Levers, each from a cause the fight has
1. **Film is the only route to BEST against an unfree mode.** GUESS caps at OK. A film evening costs a pad evening (CODE).
2. **Share is a bet.** A BEST answer on a rare mode, or an OK answer on an often mode.
3. **PRESSURE builds inside a round.** Right answers that win build PRESSURE and cut the opponent's output (CODE), so a diamond that fires early is worth more. The hover says "fires early: PRESSURE builds".
4. **PlanRead caps any one line.** Full value for 2 uses a round, then less (CODE). A plan with two or three different answers beats one answer used six times.
5. **A wrong diamond costs more than an empty one.** Planned wrong answers shrink your boxer's energy ceiling (CODE); empty is edge 0.
6. **Drilling is the budget.** About 3 pad nights a week, film evenings, test evenings and the one study slot all take from it (CODE). A big plan gets red stamps.
7. **Pros: SEEN.** ProRead waits for the most-thrown punch of the last two pro fights. A second real weapon or a feint line blunts it (CODE). The editor marks the SEEN piece, and Validate names the fix.

### 6.3 Targets (ESTIMATE, probe pass lines in 9)
| Plan | Close-bout win rate |
|---|---|
| No plan | 45% (CODE, one matchup) |
| Coach's preset (free modes) | 48–52% |
| GOOD (found modes, drilled) | 57–62% |
| One WRONG diamond | 3+ points below the same plan without it |
| STEPS-ONLY (found modes answered only by steps) | at least 4 points below GOOD |

### 6.4 Amateur reuse (NEW, small; S471 ruling)
- Amateurs aren't read across bouts (CODE).
- Until they are, an amateur opponent who has met your boxer before starts the bout with your most-used line from that bout already SEEN: it pays like a third use from exchange 1.
- The Rival file and the editor print "SEEN: met before".

### 6.5 No dominant plan
- All-free caps at the preset.
- Stuffed runs out of pad time and gets red stamps.
- One-answer is cut by PlanRead, and for pros by ProRead.
- STEPS-ONLY waits on the study slot.
- The best plan is opponent-specific, drilled, and spread over two or three answers.

Part 4 of 5

## 7. From the owner's pictures (S470, as Claude's verdicts take them)

### 7.1 VALIDATE (stage 1, NEW)
A button on the editor, also read by the Fight prep button. It gives plain warnings, one line each, with no score:
- "Uppercut under 30: skipped."
- "Pivot out is Raw: never planned. In the study slot: 2 weeks."
- "Presses is a GUESS: OK at best. A Film evening can find it."
- "Waits to counter showed in 1 of 4 films: rare."
- "Diamond rated WRONG: shrinks the energy ceiling."
- "1-2-3-2 on the bell box: a long combination on every lost exchange costs energy." (combination energy, CODE)
- "SEEN: the Cross is the most-thrown punch. A second weapon or a feint line blunts it." (pros)
- "7 drill cards, 5 pad nights before the bout."
- Coverage, a count only: "Answers 3 of 4 known modes."

### 7.2 The opponent's tree (stage 1, NEW view of CODE data)
- **The file is drawn as a chart** in the same language: the bell place at the top, then the six modes as branches.
- **What fills it:** branches film hasn't found are blank outlines ("not seen yet: 1 Film evening"). Found branches carry the share band and the habit's answer.
- **One red box,** "biggest hole", appears only once the weakness is found. Tape finds the weakness last (CODE).
- **Suggestions** from your boxer's drilled bench, each with what it needs ("needs pivot out drilled to 30").
- **BUILD THE PLAN** opens the editor with this tree beside it.
- **Where it shows:**
  - Amateur offers show the free part only, because there's no scouting before accepting (pack S410).
  - Pro offers show what Scout opened.
  - Fight prep shows it all.
- **No percents.** "2 branches not seen yet" instead of "92% complete". Opponent ratings stay ranges until read.

### 7.3 ONE swap between rounds (stage 1; the corner's existing one change, drawn on the tree)
- **The corner's read** sits beside the chart, with counts the corner can see:
  - "Body hook fired 3, won 2."
  - "Presses diamond: never fired."
  - "Lead hook punished 4 times."
- **Pick a piece:** REPLACE or REMOVE. Dead diamonds are listed first. FixLab's line is outlined (CODE).
- **The swap list** is your boxer's bench: moves, combinations and steps at 30+, ordered by mastery, each with its fire rate as the hesitation note ("Usable: fires 1 in 2").
- **Or "Say nothing / No fix",** which holds the plan (CODE).
- **No running clock** (pack: no timers).
- **No judges' cards:** amateur corners don't see them. Your coach's count is "we think we're ahead", the corner card's own count (CODE).

### 7.4 Emergency box (stage 2, NEW)
- One box, taking no line, which replaces the fixed hurt rule. When your boxer is hurt: hold this place (the S466 default), tie up, or roll out (steps, so they need 30+).
- It also answers a found "chases the stoppage".
- In stage 3, a failed Composure check greys the plan and the emergency box stays lit.

### 7.5 Bait pair (stage 3, NEW)
- **Building the bait:** body work that wins adds "expects the body", a PRESSURE with a target, up to 3. A sharp opponent (Fight IQ 70+) builds it at half speed (ESTIMATE).
- **Cashing it:** a bait diamond "IF expects the body (2+)" answers with a head shot from the book and has an outcome pair: works → the next box (one line); countered → back to the bell box (one line).
- **Payoff per point:** probed, never flat.

### 7.6 What the pictures add that's left out
- Percent IFs (stamina < 50%) and the opponent's exact bars.
- "Biting 94%".
- Synergy buffs.
- Bought moves.
- A free Simulate button.
- A countdown.
- Judges' cards between rounds.
- MMA names.
- Names in feed lines.
- A second commentary panel.
- Exact triggers like "on the ropes > 5 s": the ropes are a place, and the fight is per exchange.

## 8. Stages (simplest first; S469 "ok")
| Stage | Contents |
|---|---|
| 1 (boxing) | the chart from 3.1; the six modes, free or found, with GUESS and share; the habits as found diamonds and timing rules (after their CHECKs); steps priced (the study slot and NEW pad cards to Sharp); lines from the coach's 4–6; Test it as a sparring night; Validate; the opponent's tree; lock at the first bell; the live strip; the corner swap on the tree; "The plan, lit up"; the Why wording; presets; rematch load, team-mate copy, clear one; amateur reuse SEEN. Probes 1–8, 10, 11 |
| 2 | BJJ: positions as boxes over BjjTree with two free IFs (stalls in guard, tires), and the found BJJ habits after the 3-beat CHECK. The emergency box. A shout aimed at a box, inside the two-a-minute rule. The last-exchange timing rule. Probe 9 |
| 3 | lines from bouts or Fight IQ (cap 7); the bait pair; the Composure check with its chance shown ("Holds the plan: 70%", ESTIMATE, from Composure and Heart, after a knockdown or a hurt only); named plans after 3 uses, which a scouting opponent then finds; a cut IF on the cutman card's closing-eye state (AGREED, NOT BUILT); "last round, behind on your coach's count" if the owner keeps it |

## 9. Probes (400 bouts a cell, three seed sets, all six styles, close bouts with a rating gap under 3)
| Bot | Rule |
|---|---|
| NONE | no plan |
| PRESET | the coach's preset for the style |
| GOOD | found modes, BEST answers, all at Sharp |
| WRONG | GOOD with one diamond set to a WRONG answer |
| STUFFED | the line cap filled, drilled only as far as 3 pad nights allow |
| ONE | one diamond, reused every bout |
| STEPS-ONLY | found modes answered only by steps, at their real bars |
| GUESS | GOOD shape with no film (all GUESS) |
| AMREUSE | ONE against an amateur met before |

**Pass lines (all ESTIMATE):**
1. GOOD beats NONE by 12+ points and PRESET by 8+.
2. PRESET beats NONE by 3–7 points.
3. WRONG is 3+ points under the same plan without the wrong diamond.
4. STUFFED, ONE and STEPS-ONLY each finish under GOOD, STEPS-ONLY by 4+. No single shape is best against all six styles.
5. A diamond fires 3+ times in a 3-round amateur bout in 80%+ of GOOD bouts; none fires 10+.
6. 4+ exchanges a bout go through boxes after a won exchange.
7. A diamond on an "often" mode fires 2–4 times as often as one on a "rare" mode.
8. A 10-point stat gap still wins 90%+ against the weaker side on GOOD.
9. BJJ: lines 1 and 5 over 3-beat runs (stage 2).
10. GUESS finishes between PRESET and GOOD, so film is worth its pad evenings.
11. Pros: GOOD with a SEEN line plus a second weapon wins back at least half of what ONE loses to ProRead. AMREUSE loses 2+ points against fresh ONE.

## 10. The failure path that teaches (no rigged roll)
- **The setup:** film found "presses: 2 of 4 films", and the player hung two of three diamonds on it. Tonight the opponent boxes at range (the code's own mode pick).
- **Live:** the diamonds stay dark. The round line says once: "Never pressed this round: the main line fought alone."
- **Corner minute:** "Presses: never fired" sits top of the swap list. FixLab outlines the long-range box. The player swaps one dead diamond for a box answer on long range.
- **The Why:** "YOUR PLAN: two IFs on pressing, never fired. The swap won 3 of 6." NEXT: "Bet IFs on modes shown often; build the main line to stand alone."
- **A second failure:** "Pivot out under 30: skipped 3 times." Validate warned about it before the bout.

Part 5 of 5

## 11. Every menu, and what each is wired to (S425)
| # | Menu | What shows | Player actions | Wired to (CODE) | New wiring (NEW) |
|---|---|---|---|---|---|
| M1 | Fighter > Playbook > Game plan | the editor (3.1), Lines n of m, Validate list | draw, × clear one, Validate, Test it, Save, Load the saved plan, Copy a team-mate's plan, Start again (preset) | PlanBoard, PlanChain, worth, line cap | editor view, GUESS, Validate, save to the file |
| M2 | Fight prep > WHAT YOUR PLAN SHOULD ANSWER | becomes the opponent's tree (7.2) | BUILD THE PLAN; Film evening | tells, tape | tree view, share count |
| M3 | Fight prep > Tape Room > YOUR ANSWER | the picked answer lands as a diamond on its card; suggestions from the bench | pick | Tape Room, PlanBoard | place as diamond |
| M4 | Fighter > Week > evening popover | Film (also with no camp), "−1 pad night" | pick Film | Week evenings | Film opens a tell without a camp (CHECK) |
| M5 | Fighter > Week > tray "THE PLAN vs the opponent" | a drill card per piece, with stamp or tier; Usable steps as cards | drag to a pad night | PadWeek, mastery | step pad cards |
| M6 | Fighter > Overview > WHAT TO LEARN NEXT | the step the plan needs first ("pivot out: plan needs it") | put it in the study slot | StepMastery (S463) | plan's need line |
| M7 | Fight prep, primary button | "Write the game plan", then "Check the plan: n warnings" | opens M1 | Fight prep state | reads Validate |
| M8 | Home > needs | amber "Plan: n warnings", fight week only | opens M1 | Needs | Needs.plan_warn |
| M9 | Fights > bout offer, Full report | the opponent's tree, free part (amateur) or Scout part (pro) | Scout ($250, pro) | bout page, Scout | tree view |
| M10 | Fight night, live | 300 px strip: box in play, FIRED, count, SEEN | shouts as today | PlanFight, PlanRead, round line | strip |
| M11 | Fight night, corner minute | full chart, the corner's read, the swap list | REPLACE / REMOVE one, or Say nothing | one change, FixLab | drawn on the tree |
| M12 | Result > The plan, lit up | full chart with fired and won counts | Save to this opponent's file | result view | save |
| M13 | Result > The Why | YOUR PLAN names boxes and diamonds | Train X next week | Why | wording |
| M14 | Fighter > Overview | "Fight plan (n boxes, n IFs)" | opens M1 | Overview button | label |
| M15 | Rival file (modal) | the tree; "a plan saved for this opponent"; "SEEN: met before" | Load the saved plan | tells | rematch, amateur reuse |
| M16 | Fighter > History | per bout: plan used, counts; named plan (stage 3) | open the plan | Records | plan per bout |

**Not on** Club, World or the top bar: the plan isn't money, standing or a moment. The bout offer's win band already counts the plan.

## 12. Pages, 1920×1080 (Look B; handwriting in marker, numbers in the kit's mono, SIZE_MIN 12, gold on one thing, green only on Continue in the top bar)

### 12.1 Editor (M1)
- **Header 0–120:** your boxer's polaroid left and the opponent's right, each name once; class in kg, style word, stance; "bout in 18 days".
- **Left 40–440, THE FILE:** the opponent's tree, small, at 400 px. Branches show FREE, FOUND "3 of 4 films · often", or blank "not seen yet". The hurt line. Buttons: Film evening (Tue, −1 pad night), Load the saved plan (only if one exists), Copy a team-mate's plan, Start again.
- **Centre 480–1440, the chart:**
  - Bell box at the top, then the boxes by place, 320×110, joined by arrows labelled with places, and grey "lost: back here" arrows to the bell box.
  - Each box: move, "SHARP 64", "3 in 4", "+2.1", a red stamp "UNDER 30", and an ×.
  - Diamonds 150×150 to the right, printing the mode word, the answer, BEST / OK / WRONG / GUESS, the share band, and "1" when ordered.
- **Right 1480–1880, WHAT IT COSTS:**
  - Lines 5 of 6.
  - Drill cards 7, pad nights 5.
  - Film evenings used 2.
  - The Validate list.
  - The worth band from the last test, "+6 to +10 over no plan", in gold (the one gold).
- **Bottom 980–1060:** Validate, Test it in sparring (Thu), Save, Clear.

### 12.2 Live strip (M10)
- Right of the 3D fight (which shows both fighters head to feet), 300 px wide, under the shout bar.
- It shows the box in play, FIRED in 32 px over the diamond that fired, its count, and SEEN on a read line.
- The round line runs along the bottom, under 70 characters, with no numbers and no names.

### 12.3 Corner minute (M11)
- **Left:** the corner's read in counts, plus "we think we're ahead".
- **Centre:** the full chart, with the picked piece outlined and REPLACE / REMOVE.
- **Right:** the bench list with fire rates; FixLab's line outlined; Say nothing.
- No clock.

## 13. Build (each file under 500 lines, test red first; owner Claude or the seat Claude names)
| # | Task | Test red first |
|---|---|---|
| P1 | PRESETS1: 6 style presets | PRESET passes line 2 |
| P2 | GUESS1: unfound modes rated OK at best | an unfound BEST answer reads OK |
| P3 | FILMANY1: Film evening opens a tell with any bout booked (after the CHECK) | no camp, one film evening, one tell |
| P4 | SHARE1: films-shown count and band | "3 of 4 · often" |
| P5 | STEPPADS1: Usable steps as pad cards; sparring share | step back 30 to 60 at the probed weeks |
| P6 | TESTSPAR1: Test it uses a sparring night; band result | no tries counter exists |
| P7 | LOCKBELL1 | an edit after the weigh-in holds |
| P8 | VALIDATE1 | each warning line from its cause |
| P9 | OPPTREE1: the file as a tree (M2, M9, M15) | blank branches until found |
| P10 | PLANEDIT1: the editor (M1, M14) | board = PlanBoard |
| P11 | CORNERSWAP1 (M11) | one swap a round; Say nothing holds |
| P12 | LIVESTRIP1 (M10) | FIRED on the exchange it fired |
| P13 | AMREUSE1: SEEN on a rematch | met before = third use from exchange 1 |
| P14 | PLANSAVE1: save, rematch load, team-mate copy (M12, M15, M16) | a saved plan reloads |
| P15 | PLANGOLDEN1: the section 10 bout end to end | red until P1–P14 |

Then stage 2 (BJJ, emergency box, aimed shout, last exchange), then stage 3.

## 14. Held back
- **The four invented modes** (shells up, circles away, switches stance, bites on feints) and **feint loops:** fight-engine work.
- **`when: lost_last`:** the return arrow already shows it.
- **Co-occurrence of habits:** no data.
- **A plan score:** Validate lists warnings, with no score.
- **Percent buffs, bought moves, a free Simulate, a countdown, judges' cards:** owner rules.
- **MMA, cage and hybrids.**
- **A 2D radar.**
- **Live sliders.**

## 15. Open questions
- **CHECK (Claude):**
  - Film evening with a bout booked but no camp.
  - Whether PlanBoard.pick can take a habit as `when`.
  - The round filter for timing rules.
  - Whether FireLevel applies to steps.
  - Whether two modes can hold at once, and the pick order.
  - The films-shown count per tell.
  - Whether BjjSide can read a mode over 3 beats.
  - The cutman card's closing-eye state, readable mid-round (stage 3).
- **CHECK (John):** whether UK amateur corners keep their own round count. Still not found.
- **Owner:**
  1. Should the chart replace the move-map arrows as the Game plan tab's first view, with the map behind a switch? I recommend replace.
  2. Should "last round, behind on your coach's count", a trigger that can be wrong, stay in stage 3 or be cut?
  3. Should a named plan, once a scouting opponent finds it, start that bout SEEN?
  
  The v1 shout question is closed: the aimed shout uses the two-a-minute rule (S471).

## 16. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6** (mine, not a critic's).

**To reach 10/10:**
1. Run probes 1–8, 10 and 11 on three seed sets across six styles. Replace every ESTIMATE in 5, 6.3, 7.5 and 8 with measured numbers. If GOOD doesn't beat PRESET by 8+, widen the gap between GUESS and found before the editor ships.
2. Settle the eight Claude CHECKs, above all the habit as `when` and Film without a camp. Each decides a row of 4.4 or 2.
3. Probe the step route to Sharp, so STEPS-ONLY sits under GOOD without making steps dead weight.
4. The owner's three answers.
5. Draw M1, M10 and M11 as 1920×1080 PNGs, with a long combination name and a fight against a Southpaw as the stress test.
6. Stage 2 BJJ after the 3-beat check, with probe 9 passing.
