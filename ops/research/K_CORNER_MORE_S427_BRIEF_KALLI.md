# K_CORNER_MORE_S427_BRIEF_KALLI - Kalli answer (seat queue SQ40)

Brief: research/K_CORNER_MORE_S427_BRIEF.md
Sent: 2026-11-10 19:02 | collected: 2026-11-10 19:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'll start with the critic pack, the access notes, Exchanges.gd and PaceAim.gd, then write the corner page and paste it here as text in parts.

I'm writing the corner page now. You'll get it pasted here as text, in parts.

Part 1 of 4

# What else the corner says and changes, in the round and in the minute (S427, Kalli)

The owner's words (2026-11-10): "make them smaller . and use the space to add some live stats ? or add more options (mechanic) or what else the coach can change/say during the corner minute for the player ?" On a competitor's corner: "their stats screen is useful but other than that they do only offer 1 option to the player and leaving him a bit clueless."

**Answer first.** The owner asked three things: make the corner bar smaller, use the space for live stats, and give the corner more to change. The competitor's mistake is one option and a stats screen. This page answers all three on one bar. The calls, Pace and Aim shrink to one row. The freed space holds a live board of 4 rows and **one context slot**. That slot shows at most one of four new in-round decisions at a time: **Break the rhythm**, **Work the hurt place**, **The referee's caution** and **Switch stance**. Each acts on a lever a call does not touch: the opponent's next game, where the punches go, which calls are allowed, or the stance for the rest of the round. In the minute, the two instructions that get through (GAME) become a real budget. Six kinds of instruction compete for them, two of them new: **the round plan** (Bank it / One more big round / Steal it late) and **the stance for next round**. The hands work (water, ice, the cut) is a separate budget of points. **The talk** opens the minute. It is free, but it is priced in trust, and it now includes the lie that lifts the boxer and the truth that wakes the boxer up. Build first: the smaller bar with the live board, Break the rhythm (its lever already exists), and the round plan. A hard critic scores the corner today 5/10 and this design 7.5/10.

Sources. GAME: [EX] scripts/rules/Exchanges.gd, [PA] scripts/rules/PaceAim.gd, [CP] ops/research/CRITIC_PACK.md. Box pages reused: [R28] R28_CUTMAN_DESIGN_MAP_v3.md (the cut and the hands points, not redesigned here), [S425] WEEK_DEPTH_S425_KALLI.md (the read war, the tape window, the show-night trust band), [BJJ] BJJ_LIVE_DECISIONS_S427_KALLI.md (the scheduler and the two-a-minute pattern). REAL: [WB] [World Boxing Competition Rules, Nov 2024](https://worldboxing.org/wp-content/uploads/2026/08/World-Boxing-Competition-Rules-Nov-2024-Approved-4.pdf); [BIBA] [British & Irish Boxing Authority Rules of Boxing](https://boxbiba.com/?page_id=82); [ABC] [ABC Unified Boxing Rules, BC copy](https://www.bcathleticcommission.ca/app/uploads/sites/902/2024/01/ABC-Boxing-Rules.pdf); [BBN] [British Boxing News on BBBofC corners](https://britishboxingnews.co.uk/blogs/whos-in-the-boxers-corner-the-jobs-between-rounds/), a secondary source. I didn't find the BBBofC rule book itself online, so every BBBofC line is CHECK (John). I didn't read the Miro board: it needs a signed-in Miro connector that I don't have here. Opponents are always the same sex as the boxer.

## 0. The real rules the corner works under

| Rule | What it says | Source |
|---|---|---|
| Rest between rounds | 1 minute, every competition (REAL) | [WB] 1.1.7 |
| Round length, amateur | 3 rounds of 3 min for Elite and U19, 2 min for U17 (REAL) | [WB] 1.1.5-1.1.6 |
| Round length, pro women | 2 minutes, at most 10 rounds (REAL, ABC) | [ABC] Duration of Rounds |
| The 10 s call | "Seconds out" 10 s before each round (REAL) | [WB] 10.12.3 |
| The UK pro call | "Corners - 10 seconds", then "Seconds out" 5 s before the round (REAL for BIBA; BBBofC per [BBN], CHECK) | [BIBA] 1.26 |
| How many seconds | Amateur: up to 3, 2 on the apron, 1 in the ring (REAL). UK pro: up to 4, 1 in the ring (REAL BIBA; BBBofC CHECK) | [WB] 3.1.2; [BIBA] 1.11 |
| Coaching in the round | UK pro: "shall not give advice or assistance during the progress of a round" (REAL BIBA). Amateur: seconds stay seated (REAL). ABC pro: "refrain from excessive coaching" (REAL), so some coaching is allowed | [BIBA] 1.36; [WB] 3.2.1; [ABC] Seconds 2c |
| What goes on a cut | Amateur: adrenaline 1/1000 and non-petroleum jelly only; ice bags, Enswell, gauze, swabs (REAL). UK pro: adrenalin 1-1000, petroleum jelly, ice bag, eye iron (REAL BIBA). ABC: adrenaline 1/1000, Avitene, thrombin (REAL) | [WB] 3.1.6-3.1.8; [BIBA] 1.13; [ABC] |
| Stimulants | Only cold water, on the body or as a mouthwash (REAL BIBA) | [BIBA] 1.14 |
| The towel | Amateur: a second may throw the towel, but not during a count (REAL). UK pro: the chief second retires the boxer, never during a round (REAL BIBA). ABC: mount the apron, no towel (REAL) | [WB] 3.1.4; [BIBA] 1.43; [ABC] |
| Fouls, amateur | The referee cautions, then warns. Each warning costs 1 point per judge, and a 3rd warning is a disqualification (REAL) | [WB] 8.11.2, 8.11.4 |
| Fouls, pro | Point deductions on the referee's order; 2 points, mandatory, for an intentional foul (REAL ABC); BBBofC CHECK | [ABC] Fouls, Point deductions |
| Counts, amateur | A standing eight count for a hurt boxer (REAL); at most 3 eight counts in a round and 4 in a bout (REAL), which matches the game's RSC rule (GAME [CP] 4.8) | [WB] 8.6.1, 8.7.1 |
| Sanctions on the corner | Amateur: 1st breach a caution, 2nd a warning (the second goes outside the field of play), 3rd removed for the day (REAL) | [WB] 12.3.2 |

**The liberty the game takes.** Shouting every 30 s (GAME [EX] EX_SECONDS 30) breaks the UK pro rule and stretches the amateur one. It fits ABC's "not excessive" best. Corners shout anyway, and the owner approved the shouts (S308, [EX] header). Keep it, and tie the cost to real practice: past two shouts, the boxer stops taking them in (GAME [EX] FULL_SHOUTS 2, LATE_SHOUT 0.5). Option for John: in an amateur bout, a 4th shout in one round draws a caution on the corner ([WB] 12.3.2). Whether a seated second shouting at their own boxer is a prohibited action under [WB] 3.2 is CHECK (John).

Part 2 of 4

## 1. In the round: the freed space (4 items, one slot)

The slot shows at most one item at a time. An item is never shown twice running. The Caution jumps the queue because the referee forces it. Break the rhythm, the Target and Switch stance count as shouts against the two that land in full (GAME [EX] FULL_SHOUTS 2). So picking one of them means giving up a call. The Caution is free.

**I1 Break the rhythm (feints and tempo).** When: the opponent has kept the same game for 2 exchanges (60 s; GAME [EX] run, MAX_RUN 3) and the boxer lost at least one of them. At most once a round, so about 1-3 a bout (INVENTED).

| Option | Right when | Changes / sees |
|---|---|---|
| Change the rhythm (feints, double jab, speed changes) | the boxer's best answer to this game grades Poor (GAME [EX] GRADE Poor 0.3), so no call beats it | the current game's weight in next_mode x0.4 (INVENTED; uses the existing `bias` argument, GAME [EX] next_mode). Costs 1.5 energy and -3 edge this exchange (INVENTED). The game row reads "Pressing, 60 s" and then "breaking it up" |
| Keep them there | the boxer has the best answer graded Good and won the last exchange | that game's weight x1.5 (INVENTED); KEEP 0.6 is GAME [EX] |
| Leave it | both shouts this minute are needed for calls | nothing |

Why this is not a fourth call: a call changes this exchange's edge (GAME [EX] call_edge). This changes which game the opponent fights next.

**I2 Work the hurt place (the target).** When: an opponent body place drops to "hurt" (55, GAME [CP] 4.10 bands), or their eye starts closing ([R28] 5, the hunt). Aim already adds the place (GAME [PA] offers, _HURT_PLACES). What is new is a one-time prompt in the slot. About 0-2 a bout (INVENTED).

| Option | Right when | Changes / sees |
|---|---|---|
| Work it ("Left ribs!", "The eye") | a round or more is left, the opponent is tiring (core or legs burn 50+, GAME [PA] BODY_ON_TIRED_EDGE 3) | Aim set: +4 edge and x1.3 damage on the place (GAME [PA] HURT_AIM_EDGE, HURT_AIM_DAMAGE), less AIM_COST 1.5 (GAME). NEW: planned lines thrown elsewhere stop building PRESSURE ([CP] 4.7) while the Aim is on. The place glows on the opponent's body strip |
| Stay on the plan | planned right answers are already building PRESSURE, or the last round is nearly over | nothing; the place stays marked on the board |

Why this is not a fourth call: it is the Aim lever. It persists from shout to shout ([CP] 4.8) and costs the plan's pressure, not one exchange.

**I3 The referee's caution.** NEW lever: fouls. [EX] has no fouls, cautions or deductions. When: the boxer holds two exchanges running (Tie up used twice; GAME [EX] CALLS tie), or pushes with low Discipline (Push pace, GAME [PA]; trigger INVENTED). Real ladder: caution, then a warning worth -1 point per judge, then a 3rd warning and disqualification ([WB] 8.11). It comes 0-2 times a bout (INVENTED) and is free.

| Option | Right when | Changes / sees |
|---|---|---|
| Clean it up | a warning is already on the plate, or the corner's read says the round is close | Tie up leaves the offers for the rest of the round; Push edge -2 (INVENTED) |
| Keep holding | the boxer is hurt (GAME [EX] she_hurt), and surviving the round is worth more than a point | the breather stays (Tie up cost -2, GAME). The next hold is a warning: -1 point per judge (REAL [WB] 8.11.4; NEW in the game) |
| Work inside instead | the boxer is not hurt and grades Good on inside fighting | Go to the body replaces Tie up in the offers this round (GAME [EX] CALLS body) |

What the player sees: the referee's stop gesture in 3D ([WB] 8.11.3) and a dot on the board: C, then W, then W. Why this is not a fourth call: the referee forces it, it is free, and it changes which calls the bar may offer.

**I4 Switch stance for the round.** NEW lever: stance in the exchange. Offered only if the switch card is Usable (30, GAME [CP] 4.2), when the opponent has fought "Waiting to counter" or "Boxing at range" for 60 s, or when the read-war eye shows ([S425] 2.1). Once a bout (INVENTED).

| Option | Right when | Changes / sees |
|---|---|---|
| Switch to the bell | the opponent reads the boxer's lines, or they have never faced the other stance | the opponent's read on the boxer's lines lapses (the [S425] read-war rule). The opponent edge drops by 4 for 2 exchanges (INVENTED). Where the opponent never faced the stance, the existing round-1 southpaw penalty ([CP] 4.3) applies to the opponent (NEW use). The boxer's jab and footwork calls drop one grade unless the card is Sharp (60, GAME tier). Costs 2 energy (INVENTED). A stance tag shows on the boxer's row |
| Stay | the card is only Usable and the boxer's energy is under 35 (GAME [EX] SHE_TIRED) | nothing |

Why this is not a fourth call: it lasts to the bell, changes grades and reads rather than one exchange, and is bought in the week.

Part 3 of 4

## 2. In the minute (60 s, REAL [WB] 1.1.7)

| What a real corner does | Real basis | In the game | A choice? | Budget it uses |
|---|---|---|---|---|
| Stool, gumshield out, water rinse | cold water only ([BIBA] 1.14) | RECOVER water (GAME [CP] 4.8) | Part of RECOVER | coach hands, 3 points (GAME) |
| Breathing, legs up | common practice | RECOVER | Part of RECOVER | coach hands |
| Ice on the ribs or neck | ice bag ([BIBA] 1.13h; [WB] 3.1.8) | RECOVER ice | Yes, already | coach hands |
| Cut and swelling | adrenaline 1/1000, jelly, Enswell ([WB] 3.1.6-3.1.8) | cutman job | Yes, per [R28] 6-7 (link, not redesigned) | cutman hands, 3 points ([R28]) |
| The talk: calm, lift, or the truth | common practice | TALK calm / fire up / the truth (GAME [CP] 4.8) | Yes, plus the lie (NEW) | free; priced in trust |
| One technical fix | common practice | ONE CHANGE: a habit fix, Elbows in, Gloves high (GAME) | Yes | **instruction** |
| One tactical change | common practice | change one plan arrow (GAME); urgent once the "adapted" note shows ([CP] 6) | Yes | **instruction** |
| A set-up for the gap | common practice | SET-UP, a combination for a gap (GAME) | Yes | **instruction** |
| How to spend the next round | common practice | NEW: the round plan | Yes | **instruction** |
| Stance for the next round | common practice | NEW, same rule as I4, starts at the bell | Yes | **instruction** |
| The read war: throw the switch, rest the line | [S425] 2.1 | designed, not built | Yes | **instruction** |
| Retire the boxer | towel ([WB] 3.1.4); not during a round ([BIBA] 1.43) | a cut stop exists in [R28] 7 | Only after an eight count or when hurt, behind a divider | free |
| The 10 s call | [WB] 10.12.3 | NEW: shown as the moment a third instruction is lost (GAME rule) | No | none |

**The squeeze.** Six instruction kinds compete for 2 slots (GAME). The 3rd is lost (GAME, brief). The rule a critic can check: in any minute, at least 3 of the 6 should have a real case (probe bar, section 5).

**The round plan (NEW).** All three options use existing Pace levers. The new part is that the plan is set once in the minute, so no shout is spent on it during the round.

| Option | Right when | Changes |
|---|---|---|
| Bank it | the corner's read says ahead and the boxer's energy word is tired, with the last round next | Save for exchanges 1-2 (GAME [PA] PACE_EDGE -4, SAVE_RECOVER 6), then Steady |
| One more big round | the read says behind with one round left, or the opponent is tiring (GAME [EX] OPP_TIRED 45) | Push all round (GAME [PA] +6 edge, spend x1.35); Go for the finish offered at hurt (GAME) |
| Steal it late | the read says close, and energy is in the middle | Steady for exchanges 1-4, Push for 5-6 (INVENTED split) |

**The talk, with the lie (extends the existing TALK).** It opens the minute and does not use an instruction slot.

| Line | Right when | Changes |
|---|---|---|
| Calm | the boxer is hurt or was counted | the existing TALK calm effect (GAME) |
| Fire up | the boxer is Flat and level on the read | the existing fire up effect (GAME) |
| The truth: "You're losing this" | the boxer is Steady or Fired up and coasting behind | NEW: the next round's Push uptake x1.2; morale -2 now if Confidence is low (INVENTED) |
| The lie: "You're winning, keep it up" | the boxer is Low and has stopped listening (GAME [CP] 3: trust x0.7) | NEW: one trust band up next round (Low 0.7 to Flat 0.85, GAME bands). If the bout is then lost on points, morale -6 and the next bout starts one band lower (INVENTED) |

## 3. The live board (in the freed space)

| Show | Why it informs a choice |
|---|---|
| Punches landed both ways, this round and the bout (built S427) | Bank it or One more big round |
| The opponent's game now and how long it has run ("Pressing, 60 s") | I1; never shows how many exchanges it has left |
| Each call used, with a tick or a cross (built S427) | trust; the Why repeats it |
| Both energy words (Fresh / Tiring / Gone) and the opponent's body strip with hurt places | I2, the round plan |
| The referee dots (C, W) for both sides | I3 |
| Shouts left this minute at full: 2, 1, 0 (GAME FULL_SHOUTS) | makes every slot item cost something you can see |
| The corner's read of the bout as a word with a hedge: "probably ahead", "close" | the talk and the round plan; the same read as [R28] 7 |

**Never show:** the judges' scores or any round-by-round scorecard (held back, [CP] 6); edge numbers (GAME [EX] EDGE 17 / 5 / -10) or the dice; the opponent's next game; the opponent's energy as a number, because it would turn OPP_TIRED 45 into a lookup; the fit of each call to the current game. The S310 rule ([EX]) says green means "the boxer does this well", never "this is right". Flag: the brief says the bar grades calls "Beats it / Works / Risky against what the opponent is doing". [EX] offers() always holds exactly one best, one ok and one wrong call, so a label per fit hands over the answer (CHECK (Claude)).

**Size: "make them smaller"** (a layout budget in words, no new parts). One row of 4 compact buttons, the 3 calls and Say nothing (label and the boxer's grade word; cost on hover), about 40% of the bar's width (INVENTED). Pace and Aim each become one chip that opens a 3-way popover, about 15%. The context slot takes about 15% and is empty most of the time. The live board takes about 30%, 4 rows at most ([CP] 6: "stats cut to three rows in the minute" sets the minute's limit). The NOW plate keeps its pop-over spot. Kit gaps: WarmKit ([CP] 6) has no dark fight-night parts. A compact chip with a popover, a two-team stat row, the referee dot and a slot card are not in any kit I can name, so a designer must add them before a mockup.

Part 4 of 4

## 4. The camp link (bought in the week)

| Bought before | Where | What it opens live |
|---|---|---|
| A switch-stance card drilled to Usable 30 / Sharp 60 (NEW card) | Week > Learn on the pads (GAME rates: pads 2.1 an hour) | I4 and the minute's stance slot; Sharp keeps the grades |
| A southpaw camp partner ($160, GAME [CP] 4.3) | Fight prep > camp | a southpaw boxer facing a switch loses the round-1 penalty, so I4 is weaker against them |
| Tape tells such as "fades late" or "holds when hurt" (GAME [CP] 4.6) | Fight prep > Watch the tape | I2 and Steal it late are prompted a round earlier (INVENTED) |
| Trust in the corner (morale bands, GAME [CP] 3) and the show-night corner one band up ([S425] 2.2) | the week's results, goals, Reid's evenings | how much every shout and talk line lands |
| Discipline and Temper (GAME personality) | signing, habits | how often I3 fires |
| The Ring general perk (corner calls 25% better, GAME [CP] 3) | the perk road | every slot item and instruction |
| Cutman tier | Club > People ([R28] 1) | the cutman's 3 hands points in the minute |
| Lines on the opponent's tape (the [S425] tape window) | the last 2 bouts | I4's read lapse matters more |

## 5. Menus, then the build

| Screen | Items | Reads from |
|---|---|---|
| Fight night: the shout bar | calls, Pace chip, Aim chip, slot (I1-I4), live board | [EX] situation, offers, run, energy; [PA] offers, opp_hurt; the foul tally (NEW); shouts used |
| Fight night: the corner minute | the talk, 2 instruction slots, coach hands, CUT card ([R28]), retire divider | [EX] read(); the corner's read; the adapted note; counts; morale |
| Fight prep | stance row, tells, camp partner | the opponent's file, cards owned |
| Week > Learn on the pads | the switch-stance card | mastery |
| Playbook > Moves / Combos | the stance card, the switch ([S425]) | mastery tiers |
| Club > People | cutman tier ([R28]) | staff |
| The Why | grades every slot item, talk line and instruction against the moment, not the dice ([CP] 4.9) | the bout log |

**Smallest build, then the order.**
1. **The probe first**, on tools/exchange_balance.gd, 400 bouts a cell (the S323 count, GAME [PA]). Pass bars (INVENTED): each option is the best pick in 15-60% of the times it is shown; the gap between asks is never more than 60 s; reading the board beats always taking green by at least as much as today (0.67 against 0.59, GAME [EX] S310); the whole set moves win chance by 2-6 in 100; in the minute, at least 3 of the 6 instruction kinds have a case in 80% of minutes.
2. **The smaller bar and the live board.** No new levers.
3. **I1 Break the rhythm.** The bias argument already exists.
4. **The round plan and the talk's lie and truth.** These use Pace and morale.
5. **I2 the target prompt.** Aim exists; the pressure rule is NEW.
6. **I3 the caution.** The foul tally and point deductions are NEW.
7. **I4 and the stance slot, with the switch-stance card.**
8. The cut, per the [R28] order.

## 6. Kill list and scores

| Item | Hardest objection | Answer |
|---|---|---|
| Smaller bar | "Smaller buttons hide the costs." | The costs move to hover, and the grade word stays. If playtests show players missing costs, the cost goes back on the button. |
| Live board | "Stats make it a lookup." | It shows no fit and no thresholds, only words. The read is hedged. |
| I1 | "It is a fourth call." | It moves the opponent's next game, not the edge. Honest: if the probe shows it adds less than 1 in 100, cut it. |
| I2 | "Aim already does this." | True. The prompt and the pressure cost are the only new parts; without the cost, cut it to a glow. |
| I3 | "Nobody keeps holding." | Hurt with 30 s left, the point is worth less than the round. Weak if the boxer is rarely hurt. |
| I4 | "Rare, and needs a card." | Rare on purpose: it is a camp purchase with a live payoff. No full answer for a gym that never drills it. |
| Round plan | "A pace macro." | Partly. Its worth is saving the in-round shouts. If the probe shows no gain over setting Pace live, cut it. |
| The lie | "It is a free trust boost." | It costs more than it gives if the bout is lost. It needs the read to be honest, or it is a guess. |
| Shouting realism | "Real UK pro corners may not coach in the round." | True ([BIBA] 1.36). The owner chose shouts. The optional corner caution makes the rule felt. |

| Part | Now | With this | To reach 10 |
|---|---|---|---|
| The bar as a whole | 5 | 7.5 | the probe passes; a mockup judged by the coach critic; the opponent's corner makes the same choices |
| I1 Break the rhythm | - | 7 | the opponent answers with its own tempo change; the Why names the switch |
| I2 Target | - | 6.5 | the opponent covers the place after one round of work (NEW opponent adjust, [CP] 4.7) |
| I3 Caution | - | 7 | the referee's style on file (strict or loose, scoutable); measured caution rates |
| I4 Switch stance | - | 7 | a 3D stance change; switch drilled as a quiet block ([S425] 2.3) |
| The minute's budget | 6 | 8 | the adapted note built ([CP] 4.7); the Why grades both instructions |
| The talk | 5 | 7 | the boxer answers back in their own words, using Heart and Confidence ([R28] 7) |
| Live board | 6 | 8 | the hedged read tuned so it is right about 3 in 4 (INVENTED target), and shown as such |

## INVENTED numbers (for John)
I1: 1-3 a bout; bias x0.4 and x1.5; 1.5 energy and -3 edge. I2: 0-2 a bout; no PRESSURE off the target. I3: the trigger; 0-2 a bout; Push -2. I4: once a bout; opponent edge -4 for 2 exchanges; 2 energy. Steal it late split 4+2. The truth x1.2 and -2; the lie: one band up, -6 and one band down. Layout shares 40/15/15/30. Tells a round earlier. Probe bars 15-60%, 60 s, 2-6 in 100, 3 of 6 in 80%. The read right 3 in 4.

## CHECK (John)
- The BBBofC rule book itself: seconds in the corner, the no-coaching-in-the-round rule, the 10 s and 5 s calls, cut kit, point deductions (I found only BIBA's wording and [BBN]).
- BBBofC women's pro round length (ABC says 2 minutes).
- Whether England Boxing runs World Boxing's caution and warning ladder and its 3-and-4 count limits.
- Whether a seated amateur second shouting to their own boxer breaks [WB] 3.2.
- The optional corner caution for a 4th shout in a round.

## CHECK (Claude)
- [EX] FULL_SHOUTS 2 is commented "a round", but [CP] 4.8 and the brief say two a minute.
- [EX] EDGE_WORD reads "Big edge / Small edge / No edge / Risky", but the brief says the bar shows "Beats it / Works / Risky". If the bar labels the fit, it gives the answer away (offers() always holds one best).
- [EX] fixes every round at 6 x 30 s = 3:00. Amateur U17 rounds are 2:00 ([WB] 1.1.6) and ABC women's pro rounds are 2:00.
- [EX] has no fouls, cautions or deductions: does BoutRules?

---

The flag that matters most is the Beats it / Works / Risky labels. Every offer holds exactly one best call, one ok call and one wrong call, so labelling each call by how well it fits the opponent's current game hands the player the answer.

The page is saved on my computer at `/workspace/r28/CORNER_ROUND_MINUTE_S427_KALLI.md` and isn't in the repo yet; Claude commits.
