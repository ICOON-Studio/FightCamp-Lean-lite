# DESIGN_STEPVALUE1_V1_KALLI_KALLI - Kalli answer (seat queue SQ130)

Brief: research/DESIGN_STEPVALUE1_V1_KALLI.md
Sent: 2026-11-14 20:40 | collected: 2026-11-14 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Writing STEPVALUE1 v1 in full now.

# STEPVALUE1 v1: footwork and defence worth learning (S459, S473, 2026-11-14)

Part 1 of 4

**Owner rules this map keeps, quoted**
- **S473:** "Yes, design it".
- **Q-211 (PROGRESSION_MAP_S448 M5):**
  - "The 7 footwork nodes and 3 defences fill on pad nights, in SHADOW mornings and in sparring ... Under 30 the plan line using it is greyed 'Pivot: learning, 2 pad nights'; from 30 its fire share follows FireLevel."
  - "FOOTWORK1 bounds it: a novice with no Step back loses 1.5 to 5 more in 100 to pressure, never more."
  - GRADE: "steps and defences as LineGrade.DONE_WITH ... Good / OK / Poor ... a planned line's edge x1.2 / 0.85 / 0.35. Mastery says how often it comes off, the grade how well."
- **S448:** names only in headers. Every line below says your boxer, the opponent, your coach.
- **S412:** no fixed he or she. The code's situation ids (`she_tired`, `she_hurt`) stay as ids, but every on-screen line says "the opponent".
- **S422:** game words, not jargon. **S398:** only actionable lines on screen.
- **S459:** 6+ DEPTH and 6+ GENERAL DESIGN, ESTIMATEs marked, buildable. **S425:** the menu table (section 7).

**Marks**
- **CODE:** in the game now, with the symbol named.
- **MEASURED:** from S463–S473 probes.
- **ESTIMATE:** ours, a starting value the section 9 probes tune.
- **NEW:** a rule this map adds.
- **CHECK (Claude)** and **CHECK (John)** are open questions.

**Status, said plainly:** every effect size below is ESTIMATE. The win sizes in section 4 are the targets, and the effect sizes are tuned until the probes hit them.

**One word list**
- **Step** means any of the ten (seven footwork, three defence) when the difference doesn't matter.
- **Fires** means the planned line comes off in that exchange (FireLevel).
- **Grade** (Good / OK / Poor) is how well it comes off.
- **Tier** words stay the game's: New, Raw, Usable 30, Sharp 60, Signature 85.
- **Tank** is fight-night energy. **Tiredness** is the week's wear.

## 0. The problem, in one paragraph (MEASURED)
- **NODEREAD1:** the bout doesn't read step mastery. FireLevel reads every step at 100, so a bar at 0 fires like a Signature.
- **TREEVALUE1:** even firing every time, a step is worth almost nothing (step back +1.7 in 100 against pressure, the rest 0–0.8), because a step lands nothing and changes nothing the exchange scores.
- **PICKSPREAD1:** a step card is the best pick only 12–20% of the times it's offered, so the learn card isn't a choice.

**This map fixes all three:**
1. FireLevel reads the real bar.
2. Each step gets an effect the exchange already knows how to count.
3. The sizes are set so a step card wins its pick against its style about as often as a punch card.

## 1. The idea in five lines
1. **A step doesn't score. It changes the exchange:** it takes damage away, moves the distance, drains the opponent's tank, opens a counter for the next exchange, or breaks what the opponent is doing.
2. **Each step pays against one or two opponent styles and is wrong against others.** The code's best / ok / wrong lists say which.
3. **Mastery says how often it fires** (greyed under 30; FireLevel above). **The grade says how well,** from your boxer's ability against the opponent's.
4. **A step costs a plan slot, pad units a punch doesn't get, and a little tank.** A plan made only of steps loses on the cards, because the judges count landed punches.
5. **The careful player learns the two or three steps that answer the styles the region and the next opponent actually bring,** and matches them to the abilities that grade them.

## 2. The six effects a step can have (built from what the exchange already holds)
Every one uses something the 30-second exchange already counts (CODE: the edge, damage per body place, the tank, the place in the ring, the opponent's mode, PRESSURE, set-up gaps). Only the **ropes count** is NEW.

| Effect | What changes in the exchange | Uses (CODE) |
|---|---|---|
| **DENY** | the opponent's landed damage this exchange × (1 − n) | damage per body place |
| **DISTANCE** | the next exchange starts at a set place (long, mid, inside, ropes) | the plan's places |
| **DRAIN** | the opponent's tank loses n extra | tank |
| **OPEN** | your next planned punch line gets +n edge; a gap the "NOW!" set-up can use | edge; set-up gaps |
| **BREAK** | the opponent's mode switches for the next exchange (Pressing to Boxing at range, for example) | opponent modes |
| **ROPES** (NEW) | a count of exchanges driven backwards; at 3 in a round the next exchange is on the ropes; pivot out or step out clears it | the ropes place |

**Rules that hold for every step**
- **One effect pass per exchange:** the plan picks one answer per situation (CODE), so steps can't stack inside one exchange.
- **A step's edge pays in full for its first 2 uses in a round, then less, and resets at the bell** (PlanRead, CODE). That's the anti-spam rule; nothing new is needed.
- **A step lands no punches,** so it adds nothing to the scorecards by itself. Its value comes from what it denies and opens.
- **When it fires as a wrong answer, it "walks into it" at the code's wrong cost,** plus the step's own downside (section 3).

Part 2 of 4

## 3. The ten, one by one (answers point 1)
**How to read this section**
- **Best / wrong:** for "press" these come from PlanFight.ANSWERS (CODE). Every other best / wrong below is proposed, and **CHECK (Claude): the code's lists win.**
- **Effect sizes:** ESTIMATE starting values, at OK grade.
- **Tank cost:** in the 100 tank, on the scale where a four-punch combination costs 1.2 (CODE).
- **Real-world evidence:** the fights named are well-known examples. **Every one is CHECK (John)** before any line or Handbook text uses it.

### Footwork (7)
**Step back** (`step_back`)
- **Best:** press, loadup (CODE for press).
- **Wrong:** range (stepping away from an out-boxer gives them their distance), counter.
- **When it fires:**
  - DENY 35% of power-punch damage.
  - DISTANCE: long.
  - OPEN +0.10 edge to the next counter line.
  - ROPES +1.
- **Tank:** 0.3.
- **Pays against:** pressure fighters, sluggers.
- **Downside:** three in a round without a pivot out or step out puts your boxer on the ropes. That's where a pressure fighter wants them.
- **Real:** the pull-back counter, Floyd Mayweather's trademark. CHECK (John).

**Step out**, the lateral step (`step_out`)
- **Best:** press, loadup.
- **Wrong:** counter (the side step is where the counter waits).
- **When it fires:**
  - DENY 25%.
  - BREAK: Pressing to Boxing at range for one exchange.
  - Clears the ropes count.
- **Tank:** 0.5.
- **Pays against:** pressure fighters, sluggers, volume punchers.
- **Downside:** costs more tank than step back and opens nothing.
- **Real:** Pernell Whitaker against Julio César Chávez, 1993. CHECK (John).

**Pivot out** (`pivot_out`)
- **Best:** press, the ropes place, inside.
- **Wrong:** range (nothing to pivot off).
- **When it fires:**
  - DISTANCE: mid.
  - Clears the ropes count.
  - OPEN +0.08: the angle leaves the opponent square.
- **Tank:** 0.5.
- **Pays against:** pressure fighters, and any opponent who puts your boxer on the ropes.
- **Downside:** worth little unless your boxer gets pressed back, so it's the partner of step back, not a step on its own.
- **Real:** Vasyl Lomachenko's angle pivots. CHECK (John): name a fight.

**Step in** (`step_in`)
- **Best:** range, `she_tired`.
- **Wrong:** press, counter (CODE for press).
- **When it fires:**
  - DISTANCE: mid or inside.
  - Your next inside punch line +0.12.
  - DRAIN 0.4 on an out-boxer, who has to reset.
- **Tank:** 0.3.
- **Pays against:** out-boxers, tired opponents.
- **Downside:** against a counter-puncher it walks into the counter, at the wrong cost plus 20% more damage taken that exchange.
- **Real:** Mike Tyson's peek-a-boo entries, taught by Cus D'Amato. CHECK (John).

**Cut off** (`cut_off`)
- **Best:** range, `she_tired`.
- **Wrong:** press (CODE).
- **When it fires:**
  - The opponent's own step lines fire 30% less that exchange.
  - DRAIN 0.6.
  - The opponent's ropes count +1.
- **Tank:** 0.5.
- **Pays against:** out-boxers, movers.
- **Downside:** slow. It pays over a round, not in one exchange, so it's weak against an opponent who stands and trades.
- **Real:** Gennady Golovkin's ring-cutting. CHECK (John).

**Herd** (`herd`)
- **Best:** range, `she_tired`, `she_hurt`.
- **Wrong:** press (CODE).
- **When it fires:**
  - The opponent's ropes count +1.
  - At the ropes, your power lines +0.12.
- **Tank:** 0.6.
- **Pays against:** volume punchers and tired or hurt opponents.
- **Downside:** the most tank of the seven, and worthless when the opponent comes forward.
- **Real:** Roberto Durán driving Sugar Ray Leonard to the ropes, 1980. CHECK (John).

**Feint** (`feint`)
- **Best:** counter.
- **Wrong:** press (a pressure fighter walks through it).
- **When it fires:**
  - BREAK: draws the counter early, so the opponent's counter line fires at −0.10.
  - OPEN +0.12 to your next punch line.
- **Tank:** 0.15.
- **Pays against:** counter-punchers, boxer-punchers.
- **Downside:** decays fastest. A third feint in a round pays a third (PlanRead, CODE), so it never carries a round.
- **Real:** Bernard Hopkins's feints. CHECK (John): name a fight.

### Defence (3)
**Tie up** (`tie_up`)
- **Best:** loadup, inside, and your boxer hurt (`hurt`).
- **Wrong:** range.
- **When it fires:**
  - The exchange ends early: both sides land half.
  - Your boxer's tank +0.8.
  - BREAK: Loading up to Boxing at range.
- **Tank:** −0.8 (it recovers).
- **Pays against:** sluggers. It's also the way to survive a hurt round.
- **Downside:** a held exchange wins no round. Amateur referees break holds quickly. CHECK (Claude): whether a holding warning exists in the code.
- **Real:** Muhammad Ali against George Foreman, 1974. CHECK (John).

**Roll out**, the roll under a hook (`roll_out`)
- **Best:** press, loadup (CODE for press).
- **Wrong:** an opponent aiming at the body (rolling guards the head, not the ribs).
- **When it fires:**
  - DENY 40% of head damage from hooks and overhands.
  - OPEN +0.10 to a counter.
- **Tank:** 0.3.
- **Pays against:** sluggers, hook-heavy pressure fighters.
- **Downside:** against a body puncher the ribs take the shots it didn't stop.
- **Real:** Joe Frazier's bob and weave. CHECK (John).

**Push off** (`push_off`)
- **Best:** inside, the clinch place.
- **Wrong:** range.
- **When it fires:**
  - DISTANCE: inside to mid.
  - DRAIN 0.3.
- **Tank:** 0.4.
- **Pays against:** pressure fighters who work inside.
- **Downside:** the smallest worth of the ten. It's an escape, not a weapon.
- **Real:** Wladimir Klitschko's point deduction for pushing against Alexander Povetkin, 2013, shows the referee's limit. CHECK (John).

### Which styles each step answers (summary)
| Style (CODE words) | Steps that pay | Steps that are wrong |
|---|---|---|
| Pressure fighter | step back, step out, pivot out, roll out, push off | step in, cut off, herd, feint |
| Slugger | step out, roll out, tie up, step back | step in |
| Out-boxer | step in, cut off, herd | step back, tie up, push off |
| Counter-puncher | feint | step in, step out |
| Volume puncher | step out, herd | roll out against body work |
| Boxer-puncher | feint, roll out | none fixed |

CHECK (Claude): the style to mode mapping the opponent AI uses.

Part 3 of 4

## 4. Mastery and grade (answers point 2)
### 4.1 Mastery: how often it fires
| Bar | Plan line | Fires | Worth against Sharp |
|---|---|---|---|
| Under 30 (New, Raw) | **greyed**: "Pivot out: learning, 2 pad nights" (Q-211); can't be picked; the coach never plans it | never (NEW: today it mostly fails) | 0 |
| Usable 30–59 | pickable | 1 in 2 (FireLevel, CODE) | about two thirds |
| Sharp 60–84 | | 3 in 4 | 1 |
| Signature 85+ | | always | about four thirds |

**The one code change that makes mastery matter (NEW):** FireLevel reads the step's StepMastery bar instead of 100.

### 4.2 Grade: how well it comes off (Q-211: × 1.2 / 0.85 / 0.35 on the line's edge)
- **How it's set:** each step is graded on one of your boxer's abilities against the opponent's matching ability (Attrs, CODE).
  - **Good:** 5+ above.
  - **OK:** within 4.
  - **Poor:** 5+ below.

  The thresholds are ESTIMATE. CHECK (Claude): how LineGrade.DONE_WITH grades today; if it already has a rule, that rule wins.
- **The multiplier scales every part of the step's effect:** DENY, OPEN, DRAIN and BREAK. Grade never changes DISTANCE or the ropes count; a step either moves the fight or it doesn't.

| Step | Your boxer's ability | Against the opponent's |
|---|---|---|
| Step back | Footwork | Speed |
| Step out | Footwork | Footwork |
| Pivot out | Footwork | Fight IQ |
| Step in | Speed | Timing |
| Cut off | Footwork | Footwork |
| Herd | Footwork | Strength |
| Feint | Fight IQ | Composure |
| Tie up | Inside fighting | Strength |
| Roll out | Defence | Accuracy |
| Push off | Strength | Strength |

**Why this makes a choice:** a slow slugger grades Poor on step back, so learning it wastes weeks, but grades OK or Good on tie up and roll out. An out-boxer with high Footwork gets Good on the footwork seven. **Two boxers in the same gym should learn different steps.**

## 5. Sizes (answers point 3; every number ESTIMATE, the probe gates in section 9)
**Targets at Sharp, OK grade, the step planned for its situation, against the style it answers (FOOTWORK1 bound 1.5–5):**

| Step | Against | Target, wins in 100 | When wrong | Against other styles |
|---|---|---|---|---|
| Step back | Pressure fighter | +3.5 | −1.5 (out-boxer) | 0 to +1 |
| Step out | Slugger | +2.5 | −1 (counter-puncher) | 0 to +1 |
| Pivot out | Pressure fighter | +2.5 (with step back: +4.5 together, never over 5) | −0.5 | 0 |
| Step in | Out-boxer | +3 | −2.5 (counter-puncher) | 0 to +0.5 |
| Cut off | Out-boxer | +3.5 | −1.5 (pressure fighter) | 0 |
| Herd | Volume puncher | +2 | −1.5 (pressure fighter) | 0 to +1 |
| Feint | Counter-puncher | +4 | −1 (pressure fighter) | 0 to +0.5 |
| Tie up | Slugger | +3 (and about 1 in 4 fewer stoppage losses when hurt) | −1 (out-boxer) | 0 |
| Roll out | Slugger | +3 | −1 (volume puncher on the body) | 0 to +1 |
| Push off | Pressure fighter (inside) | +1.5 | −0.5 | 0 |

**Caps (NEW)**
- **Against any one style, all of your boxer's steps together are capped at +5 in 100.** That's the FOOTWORK1 "never more", applied to the stack.
- **A plan made only of steps loses.** With 4 step lines and no punch line, the plan must lose at least 3 in 100 to a balanced plan, because steps don't score.

**Against punches (PICKSPREAD target)**
- A punch at Sharp is worth several points against most styles; a step is worth as much **only against its style**, and nothing or less against the rest.
- So a step card should win its pick when the booked opponent or the region's most common style is the one it answers, and lose otherwise.
- **Gate:** no node is best in more than 4 in 10 of its picks.

## 6. What a step costs, and why a careful player learns some and not others (answers point 4)
**The costs**
1. **Pad units a punch doesn't get.**
   - To Usable: the study slot takes about 5 weeks of the week's pad nights (step back 0 to 32, MEASURED S463), weeks a punch card isn't the study pick.
   - Past 30 (NEW, Q-211), a step trains like a punch:
     - a drill card on the LEARN ON THE PADS tray, sharing a pad night's 240 units (pads 2.1 an hour, CODE);
     - a SHADOW morning with the step picked (0.85, CODE);
     - its share of a sparring night's 180 units when it's in the plan (1.5, CODE).
   - Usable to Sharp takes about 6 weeks on half a pad night plus one shadow morning a week. ESTIMATE, probe STEPPACE1.
2. **A plan slot.** A plan holds 4–6 lines (CODE). A step line is a punch line not written.
3. **Tank,** 0.15 to 0.6 a firing (section 3). Tie up gives tank back.
4. **No score.** Rounds are judged on landed punches. A step's worth comes only through what it denies, and the counter it opens for a punch line. **Step back with no counter punch in the plan is worth about half** (ESTIMATE).
5. **The wrong answer.** Each step has opponents it walks into (section 3), at the code's wrong cost plus its own downside.
6. **The ropes.** Step back alone, used too often, puts your boxer on the ropes. It needs a pivot out or step out beside it.

**Why a careful player learns some and not others**
- **Your boxer's abilities set the grade.** Learn the steps your boxer grades Good or OK on.
- **The opponents set the value.** Learn the steps that answer the styles the next bout and the regional table bring (both are already on Fight prep and World > Rankings, CODE).
- **Pairs pay more than singles:**
  - step back with pivot out against pressure;
  - feint with a counter punch at Sharp;
  - cut off with herd against movers.
- **A boxer whose own style is the answer doesn't need the step.** A pressure fighter who cuts off by style gains less from learning step back than an out-boxer does (ESTIMATE, probe TREEVALUE2).

Part 4 of 4

(The win targets that Part 1 points to are in section 5.)

## 7. Every menu it appears on, and what each is wired to (S425; one line each; names only in headers; answers point 5)
| Menu | The one line it shows | Wired to |
|---|---|---|
| **Fighter page > Overview > WHAT TO LEARN NEXT** (CODE card) | a step card: "Step back: Usable in about 5 weeks. Pays against pressure fighters: about +3 in 100 at Sharp." With a bout booked against that style: "The opponent presses: Usable by fight night." If not: "Not ready by fight night." | StepMastery, StepValue (NEW: the section 5 targets), the opponent's style word, WeekPhase |
| **Fighter page > Week > LEARN ON THE PADS** | from Usable, the step is a drill card with its bar and tier; drag it to a pad night | PadWeek, StepMastery (past 30, NEW) |
| **Fighter page > Week, a morning popover** | SHADOW gets a pick: "Shadow: step back" | WeekEditors, StepMastery |
| **Fighter page > Week review** | "Step back is Usable: it can go in the plan." Shows only on the week it crosses 30 or 60 | WeekReview, StepMastery |
| **Playbook > Moves** | the ten with their bars and tiers; Watch; grade ability on hover ("graded on Footwork against the opponent's Speed") | Playbook, StepMastery, LineGrade |
| **Playbook > Game plan, the answer pick** | under 30: greyed, "Pivot out: learning, 2 pad nights". From 30: "Fires 3 in 4. Grade OK." Beats it / Works / Walks into it stays (CODE) | PlanFight.ANSWERS, FireLevel, LineGrade |
| **Playbook > Game plan, Rate against** | the step's rating changes by opponent kind: the same line shows Beats it against pressure and Walks into it against an out-boxer | PlanFight, LineGrade |
| **Fight prep > WHAT YOUR PLAN SHOULD ANSWER** | when a found tell is answered by a step: the step with "Write it" if Usable, or "Not ready: 2 weeks short" | FightPrep, StepMastery, Scouting |
| **Fight night, corner minute card** | "What worked" or "What hurt" may name a step ("Stepping back stopped the right hand"; "Put on the ropes three times") | CornerCard, StepEffect (NEW), ropes count (NEW) |
| **Result > The Why, YOUR PLAN** | "Step back answered the pressing 5 times: worth about +3 in 100." | FightWhy, StepEffect |
| **Result > The Why, AGAINST YOU** | "On the ropes 4 times with no way off." Only when it happened | FightWhy, ropes count |
| **Result > The Why, NEXT** | "Learn Pivot out" with a button that opens WHAT TO LEARN NEXT | FightWhy, the learn card |
| **Home** | amber note only when the study slot is empty: "Nothing in the study slot" | Home, Needs, StepMastery |
| **Handbook, The plan** | what each step does and what it's wrong against (from section 3, after CHECK (John)) | Handbook |

**Not shown anywhere:** grade numbers, the ropes count during a round, or step worth against styles the player can't meet. Those are hover or Why only (S398).

## 8. Held back
- **The opponent's own step mastery** (opponents use steps through their mode only). Probe: OPPSTEP1.
- **Two steps in the study slot at once:** not needed, because past 30 steps train on the tray.
- **New corner shouts that call a step mid-round:** the shout list stays CODE.

## 9. The probe that proves it (answers point 6)
Played bouts, three seed sets, 400 bouts a cell (the S427 convention), amateur 3 × 3 and pro 4-round both. Gates:

1. **NODEREAD2:** win share now moves with the bar. Step back against pressure, at 0 / 30 / 60 / 85, rises in order, and Sharp against absent is **+1.5 or more**.
2. **TREEVALUE2:** each step at Sharp and OK grade, against its style, lands **in 1.5–5** (the section 5 targets within ±1). Against its wrong style it's **negative**; against the others it's **0 to +1**.
3. **FOOTWORK1 recheck:** a novice with no step back loses **1.5–5 more in 100 to pressure, never more.**
4. **STACK1:** every step at Sharp against one style is **never over +5.** An all-step plan loses **3+** to a balanced plan.
5. **GRADE1:** Good against Poor on the same step spreads **2+ in 100.**
6. **PICKSPREAD2** (Arena rerun, at least 57,040 bouts):
   - no node is best in **more than 4 in 10** of its picks;
   - footwork and defence cards are best in **30–45%** of their offers overall (from 12–20%);
   - against the style a step answers, its card is best within **10 points** of the best punch card's share.
7. **STEPPACE1:** Usable to Sharp in **5–8 weeks** on half a pad night plus a shadow morning. The punch progress given up is printed beside it.
8. **WHY1:** in **9 of 10** bouts where a step fired 3+ times, the Why names it.

**Cut rule:** a step whose card is never best in PICKSPREAD2 is resized, not cut. Every step stays a legal answer.

## 10. Build order (6 rule pieces, then the lines)
1. **FireLevel reads StepMastery** (one change), then rerun NODEREAD2.
2. **StepEffect (NEW):** the six effects per step from section 3, as a data table, so tuning is one file.
3. **The ropes count (NEW)** inside the exchange.
4. **LineGrade for steps:** the ability pairs in 4.2.
5. **StepMastery past 30:** a tray card, shadow mornings and the sparring share.
6. **StepValue:** the section 5 targets read by the learn card.
7. **Run probes 2–7 and tune the step table until they pass.**
8. **The lines:** the learn card, plan greying, Fight prep, the Why, the corner card, the Home note.
9. **One golden-path test:**
   1. A boxer with no step back loses to a pressure fighter in the band.
   2. Learn it to 30 in about 5 weeks.
   3. The plan line ungreys.
   4. The Why names it.
   5. The rematch band improves.

## 11. Owner questions and CHECKs
**Owner questions**
1. **The ropes count:** a step back used three times in a round with no pivot out puts your boxer on the ropes. Take this new rule?
2. **Under 30 a step line can't be picked at all,** not picked-but-failing. Agreed as Q-211 reads?

**CHECK (Claude)**
- The full PlanFight.ANSWERS lists for every situation, and what `tiring` and `hurt` mean against `she_tired` and `she_hurt`.
- Whether LineGrade.DONE_WITH already grades steps.
- Whether the exchange can scale one side's damage, set the next place and move a mode.
- Whether a holding warning exists.
- The style to mode mapping the opponent AI uses.

**CHECK (John):** every fight in section 3: Mayweather, Whitaker against Chávez 1993, Lomachenko, Tyson and D'Amato, Golovkin, Durán against Leonard 1980, Hopkins, Ali against Foreman 1974, Frazier, Klitschko against Povetkin 2013. Name one fight each where the map says "name a fight".

## 12. Risks
- **The exchange may not take a damage scale or a mode switch** without a wider change. If so, DENY and BREAK fall back to plain edge on the line, and the step loses its texture but keeps its size.
- **Steps could end up "right" against every style if the wrong costs are too small.** Gate 2's negative wrong value guards that.
- **Pad time for steps slows punches.** STEPPACE1 prints the trade so the player sees it.

## 13. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6** (mine, not a critic's).

**To reach 10/10:**
1. Run NODEREAD2, TREEVALUE2 and PICKSPREAD2 and paste the tables. Retune the step table until every gate passes.
2. Settle the CHECKs, first the full ANSWERS lists and whether the exchange takes DENY and BREAK.
3. Get the owner's answer on the ropes count.
4. John verifies or replaces every fight named in section 3.
5. Draw the learn card, the greyed plan line and the Why lines at 1920×1080 for the owner before any screen work.
