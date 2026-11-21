# DEPTH AUDIT (S534) - how strategically deep is FightCamp today?

Owner S534: "do you think we should go deeper into the strategy aspect of the game ? how strategically deep is our game".
Research only (DEPTHAUDIT1). Nothing was run: every number below is quoted from a result page, a critic file or the code.

## The answer in 10 lines
1. The game is WIDE, not deep. About 240 rule modules (39,700 lines) offer the player roughly 37 kinds of decision.
2. Of the 23 decisions that have been measured, only 5 are real choices (they move who wins and have no single best answer).
3. 10 have one right answer once you know it (always take the loan, always pay the stipend, never Rest up, always ice).
4. 8 barely reach the result at all (ring places, guard posture, coached-morning deals, mood, equipment, paid scouting).
5. The other 14 were never measured as choices; several are free options, so they are likely one-answer too.
6. What decides a bout today: training level first (5 points better = about 72% wins), then the plan (16 points between a
   good and a bad plan), then everything on fight night together (about 3 to 5 wins in 100).
7. The deep part is real and it is the part you already call fun: pad nights, what is drilled, and the plan written from tells.
8. The references put their depth in four places: scarce resources, long plans, hidden information, opponents who adapt.
   We have one scarce resource (the coach's pad nights), short plans, almost no hidden information and no adapting amateur.
9. So: yes, go deeper - but by making the existing choices matter, not by adding systems. Five changes are listed in part 4.
10. One process finding: critics scored designs 7-8 for depth on paper, and the same mechanics failed when measured.
    A depth score on a map does not predict depth in the game; the probe should come before the critics, not after.

How to read the labels: REAL = moves the result and no pick is best most of the time. ONE ANSWER = moves the result, but one
pick wins nearly always. FAINT = the effect does not reach the result or is under about 1 win in 100. NOT MEASURED = no probe
has tested it as a choice (my reading of the code is given, marked as a reading).

---

## 1. The player's decisions, from the code

"How often" is for one boxer. Line numbers are where the rule sits today.

### A normal week

| # | Decision | What it changes (file, function or constant) | How often | Is there a dominant answer? |
|---|---|---|---|---|
| 1 | Which session each morning (the stat it builds) | scripts/rules/WeekPlan.gd INTENSITY (L46) and session table; pace 1.0 a focused week x headroom (TrainingPlan.STAT_OF L17) | Set once, repeats; edited a few times a month | REAL but slow. +5 on one stat is worth +2.6 wins in 100 (COACHFITPROBE3 dose arm). The coach's written week is close to the best, so most weeks the right move is to leave it (MORNINGSPROBE2: three week policies tied on 36 of 40 seeds). |
| 2 | Light / Normal / Hard per morning | WeekPlan.INTENSITY (x0.6 / x1.0 / x1.3); tiredness; from 80 gains x0.6 and injury x3; TrainingLoad.SPIKE_RATIO 1.5 (L25) | Same | NOT MEASURED as a choice. On paper a true trade (speed against injury). |
| 3 | Coached-morning deal: solo, shared, weak spot | CoachedMornings.week_deal (L142), SOLO 1.25 / SOLO_WEAK 1.4 / SHARED 1.15 (L14-16) | Weekly, clubs with 2+ boxers | FAINT. MORNINGSPROBE1: "NOT A REAL CHOICE... the multiplier is not the lever". MORNINGSPROBE2: 36 of 40 seeds tied. |
| 4 | Evenings: pads, sparring, rest, film - and which drill card on each pad night | MoveMastery.gain (L62): pads 2.1 a hour, sparring 1.5; a move is a weapon at 30, Sharp at 60 | Weekly | REAL. The strongest weekly choice. A player who rotates the cards crosses a mastery line in 74% of weeks, the coach's default in 12-13% (PROGPROBE1). Sharp over Usable is +2.8 wins in 100 (FireLevel, S450). Pad time is truly scarce: only 6% of camps own every answer by fight week (HANDSPROBE1). |
| 5 | What to learn next (the coach's three cards) | StudyWeek.pick (L34), LearnSlots.cards (L46) | Every few weeks | ONE ANSWER. PICKSPREAD1 failed: Body hook is best in 66% of its appearances. "The pick is not a real choice until a step's six weeks are worth wins." |
| 6 | Footwork and defence steps to learn and plan | StepEffect.TABLE, StepWire; places via LiveRound.exchange (L235-237) | Every few weeks | FAINT. Gate TREEVALUE2: pass 0 of 10 steps after nine rounds. STEPPAY1: "No place is an edge" - the opponent on the ropes scores the same as being on the ropes yourself. |
| 7 | Diet: Hold or Cut | weight forecast; a missed weight calls the bout off, $300 (BoutRules.MISSED_WEIGHT_COST L112) | When a bout is booked | ONE ANSWER (reading): cut when over, hold when not. A chore with a fail state, not a trade. |
| 8 | The twist card (two answers, each with a price) | WeekTwist.answer (L139) | Weekly | NOT MEASURED. Small by design. |
| 9 | A bout offer: accept or pass | scripts/state/Bouts.gd accept; CoachRead.read (L26) gives the coach's view | Every 2-4 weeks | NOT MEASURED, and every probe bot simply accepts every offer. Passing a sheet offer is free; passing a rival gym's call costs 2 ladder points (RivalOffer.PASS_COST L6). |
| 10 | Ask for a fight: the sheet name, a step up, or a name you pick; which show | AskBout.answers (L98), step_up (L138) | After each bout | REAL for a boxer you are growing, flat for the rest. ASKPROBE2: no answer wins more than 6 in 10, but asking and waiting are even on 40 / 36 / 49 of 60 fighters. The show date (ASKPROBE4) is "a choice about preparation, not about the result" (win moves 0.7). |
| 11 | A rival gym rings: accept, not this show, pass | RivalOffer.answer (L45) | A few times a season | NOT MEASURED as a choice (LADDERPROBE4 checked the table stays sane, not which answer is best). |
| 12 | The goal talk and "her asks" (hear or overrule) | FighterGoal; morale +5 / -5 | After each bout | FAINT. MOODHABIT1: Steady to Flat is -0.8 points with the corner calling, 0.0 without. "Mood is NOT worth an evening." |
| 13 | Dues band: Cheap / Standard / Premium | Membership.DUES (L23), settle_week (L90) | Rarely | NOT MEASURED for a best band. |
| 14 | Class nights | ClubClasses.cash (L44) | Rarely | ONE ANSWER. MONEYFOUR2: "Free lunch within noise" - $6,094 more cash, wins +0.0. (One leak was fixed after; the trade itself was not re-measured.) |
| 15 | Stipend or day job for the boxer | DayJob.LOST 2 mornings (L21), GymSpend.set_half | Rarely | ONE ANSWER. Day-job boxers reach the first pro call in 3 of 180 careers, stipend boxers in 180 of 180 (TURNPROBE3B). Halving the stipend "does not help" (GYMSURVIVE1). |
| 16 | Equipment | GymUpgrades.LIST (L11), gain_mult (L92) | A few times a career | FAINT. GYMKIND1: $800 to $15,600 buys +0.1 to +1.2 on one stat over three years. |
| 17 | Move to bigger premises, with the loan | GymUpgrades.LOAN (L127), PREMISES (L26) | Once or twice | ONE ANSWER. LOANPROBE1: takers reach 130-153 members against 70-85, end with more cash, and "it was never a trap in two years". |
| 18 | Staff: sessional or full-time coach, S&C, physio, cutman, second coach | StaffRoles.LIST (L7), CoachRoles.class_week (L52) | Rarely | NOT MEASURED. The first coach is forced (no coach = training at 60%). Coach FIT was closed after three probes with nothing built (FITPROBE2: +0.08 wins in 100; CoachFit.gd and CoachMarket.gd have no caller). |
| 19 | Whom to sign, and the starting focus | Recruit.apply_focus (L130), Knowledge.range_of | A few times a career | ONE ANSWER on the person: sign the best shown rating. Even a signer who knows the truth beats a blind one by under 8% (KNOWBOTS4); the shown number is off by only 0.83 (KNOWBOTS5). Paying to read prospects came out at -1 against not paying (KNOWBOTS1). The focus pick is NOT MEASURED. |
| 20 | Host a club show | ClubShow.night (L44), COST $3,500 (L8) | About 3 a year | NOT MEASURED. |

### A fight week, a camp and fight night

| # | Decision | What it changes | How often | Is there a dominant answer? |
|---|---|---|---|---|
| 21 | Fight week load: Rest up / Tick over / Train through (amateur) | FightWeek.STOP_TANK 0 / 6 / 12 (L28), round_one (L124), banked (L138) | Every amateur bout | ONE ANSWER when measured at design stage: always Rest up costs 6 wins in 100, "TRAIN THROUGH HAS NO SEASON COST TODAY" (FIGHTWEEKPROBE3). The built week gives Train through a tank cost; it was not re-measured. |
| 22 | Sparring partner | PartnerMatch.EDGE: close 2.5, part 1.25, loose 0 (L37); cost (L169) $160 or a favour | Every bout | ONE ANSWER: the closest match (+3.7 / +5.3 wins in 100, S482). The favour that was meant to make it a trade barely exists: 0.24 favours a host after a year, target 1-2 (FAVOURPROBE1). |
| 23 | Camp (pro, title, nationals): focus stat, Light / Standard / Hard, film | BoutRules.PROTOCOLS: focus x1.1 / 1.2 / 1.35, edge +0.25 / +0.6 / +1.0, every cost $0; night_edge (L312); PeakCamp.BONUS 1.0 (L12) | Every pro bout | NOT MEASURED. Reading: Hard gives the most of everything and costs no money; only tiredness holds it back. Leans one answer. |
| 24 | Watch the tape, spot the tell, pick the answer | BoutRules.FILM_PER_ANSWER 0.4, FILM_EDGE_MAX 1.2 (L63-64); opens plan lines | Every bout | Feeds 25. Free apart from the evening, so the answer is "always", but what you find differs each opponent. |
| 25 | The game plan: which answer at which range and situation | PlanFight.ANSWERS; PlanRead.edge (L22) STACK_EDGE 3.5, FREE_USES 2; PlanPressure.EDGE 3.0 (L21) | Every bout | REAL. The biggest single lever a player has: good plan 59.0% of close bouts, none 45.8%, bad 42.8% (PlanRead header, 400 bouts). No fixed best plan: it depends on the opponent's game and what is drilled. |
| 26 | Fix a habit before or during the bout | HabitFix.cost; corner minute ONE CHANGE | Every bout | REAL. A habit costs 6 to 15 points against the opponent who punishes it (MOODHABIT1). Which habit to spend pad nights on depends on who is next. |
| 27 | Round pace: Push / Steady / Save | PaceAim.PACE_EDGE +6 / 0 / -4, PACE_SPEND 1.35 / 1.0 / 0.6 (L11-12) | Every round | ONE ANSWER. PUSHPROBE2: "Push while wind > 45" is best in 14 of 19 cells and beats the coach. "It does not yet give the player a decision." |
| 28 | Aim: head, body, liver, ribs | PaceAim.AIM_BODY_SHARE (L16), HURT_AIM_EDGE 4.0 (L17) | Every exchange | NOT MEASURED as a choice. It has a real cost: "Go to the body" every round emptied one boxer's tank and lost her round 4 four times in five (TURNPRO6). |
| 29 | The eight corner shouts | BoutRules.CORNER_STRONG 1.0 / CORNER_WEAK 0.3 (L96-97); Exchanges.FULL_SHOUTS 2 (L47) | Every 30 seconds | Small. The whole corner is worth about 2.8 points (MOODHABIT1). The screen shows which calls fit, so it is matching, not judging. |
| 30 | Corner minute: recover points (water, ice, clear the head) | BoutNight corner | Every round | ONE ANSWER. "always ice the whole minute is the best answer in 14 of 19 and 17 of 20 cells" (PUSHPROBE2). |
| 31 | Corner minute: Elbows in / Gloves high (guard posture) | GuardWear.posture_damage | Every round | FAINT. The pack says it is "measured not to change who wins". GUARDPROBE2: high guard was best in 12 of 12 cells. Kalli on guard v5: "Every v5 rule acts after the exchange is settled." |
| 32 | Corner minute: talk (calm / fire up / the truth), change one plan arrow, the set-up | CornerTrust, PlanRead | Every round | NOT MEASURED. Trust is mostly paper: CornerTrust.lands had no caller in the fight (MOODHABIT1, S428). Against a pro corner that has read your boxer, dropping or swapping the line "both fail... no proven counterplay" (READBACK1). |
| 33 | The towel: careful / normal / brave | Towel.answer (L117), LINES 0.12 / 0.20 / 0.33 (L11) | Rare | NOT MEASURED. A true trade on paper (the result against a layoff). |

### Turning pro and after

| # | Decision | What it changes | How often | Is there a dominant answer? |
|---|---|---|---|---|
| 34 | Turning pro: sign now or wait, which promoter, the one ask | ProCall.terms (L73), ask_answers (L156), who_calls (L63) | Once a boxer | ONE ANSWER. The "costs" ask is best in 74% of offers; later +4, softer, split and no ask are never best. Preparing first is "not a different path" (median difference $0). The door never shuts (0 of 60). The debut is won 94% of the time (TURNPROBE3B). Critics on map v10: depth 6 and 6, "one point short". |
| 35 | Pro offers: tune-up, step up, payday, or ask for a name | Matchmaking.offers (L150), ask (L179) | Every 2 months | NOT MEASURED. Designed as a four-way pull (place, fans, money, damage). |
| 36 | Scout for $250 | Matchmaking.scout (L125) | Every pro bout | FAINT so far: paying for reads did not beat not paying (KNOWBOTS1: -1 top-10 place; KNOWBOTS3: +6 places and no flops, for $634,100 of reads and less cash at the end). |
| 37 | Contract steps, promises, loyalty | StarDeal.terms (L41), Promises.resolve (L97), Loyalty.leaves (L202) | Rare | NOT MEASURED since built. LOYAL1 (S462) failed structurally: eight pad places could not serve four fighters whatever the policy. |

Ten rule modules have no caller in the game at all (BalanceHarness, CoachFit, CoachMarket, HeadEase, HeadSplit, HookPast,
KnowReads, PunchSnap, StandOff, TrainingWeek): built or half-built, never reached.

---

## 2. What the measurements already say

### The count
| | How many | Which |
|---|---|---|
| REAL | 5 | pad nights and drill cards (4), the game plan (25), habit work (26), asking for a fight for a boxer you are growing (10), which stat the mornings build (1, slow) |
| ONE ANSWER | 10 | learn pick (5), diet (7), class nights (14), stipend (15), loan (17), whom to sign (19), fight week load (21), partner (22), pace (27), ice (30), turning pro's ask (34) (eleven rows: diet is a reading, the other ten are measured) |
| FAINT | 8 | coached-morning deal (3), steps and ring places (6), goal talk and mood (12), equipment (16), guard posture (31), paid scouting (36), coach fit (18, never built), corner shouts (29, small) |
| NOT MEASURED | 14 | intensity (2), twist card (8), accept or pass (9), rival's call (11), dues band (13), staff jobs (18), hosted show (20), camp settings (23), the tape night (24), aim (28), corner talk (32), towel (33), pro offers (35), contracts (37) |

So of 23 measured decisions, 5 are real: about one in five. The classification is mine, made from the result pages; the
rows above quote the line each one rests on.

### The pattern: the lever is built, the effect never reaches the result
- STEPS (STEPPAY1, TREEVALUE9, STEPS_PAYOFF_SCOPE_S533): a place in the ring changes only which plan line fires. The ropes
  are not an edge. "A number on an effect the round does not read is a guess."
- GUARD (v5 critic): covering changes the landed count after the winner of the exchange is already picked. The cards do not move.
- COACH FIT: a top fit brought Sharp 1.5 weeks sooner and +0.08 wins in 100. Three probes, nothing felt, closed.
- TURNING PRO: nine pass lines, two passed at first. No constant moved the others (TURNTUNE1). One ask decides the fork.
- DAMAGE BY CLASS (map v2, Fable critic, depth 5): "It adds no choice. It re-prices five choices that exist."
- MOOD: only multiplies the corner's word, and the corner is worth 2.8 points, so mood is worth under 1.
- FIGHT WEEK: "a fight week's fight-night levers top out at about 5 wins in 100 in this engine" (FIGHTWEEKPROBE1).

### Why: where a win comes from today
1. Training level. 5 points better across the stats wins about 72%, 10 points about 95% (critic pack, from the tests).
   Stats rise about 1 point a focused week on the coach's own week. So the main road to winning is time passing.
2. The plan. 16 points between a good and a bad plan in a close bout.
3. Mastery of what is planned. Sharp over Usable +2.8 in 100.
4. Everything on fight night (corner, pace, fight week): 3 to 5 in 100 together.
A lever that feeds none of these four cannot matter, however well it is designed. Most of the faint ones feed number 4.

### Free options
Many options cost nothing, so the best one is the only one: camp intensity ($0 at every level), accepting an offer, class
nights, film, ice. A free option is a setting, not a decision.

### Paper depth did not predict measured depth
| Mechanic | Critics' depth on the map | Measured after |
|---|---|---|
| Steps worth learning (STEPVALUE1 v1) | Dola 8, Maria 7 | gate pass 0 of 10 |
| Turning pro (v2) | Dola 7, Maria 7 | 2 of 9 lines pass; v10 still depth 6 / 6 |
| Coach fit (v8) | Dola 7, John 7 | +0.08 wins in 100; closed |
| Push and tank (v2) | Dola 8, Maria 7 | PUSHPROBE2 "FAIL, back to design" |
| Damage by class (v2) | Dola 9 | Fable 5, Kalli 6 |
The critics read a map and judge whether trade-offs are described. Only a probe shows whether they exist.

### Probe quality (so these numbers are read with care)
Several pages were wrong on first read and corrected: one boxer counted as 20 (TURNGAP1), a seat's page its own probe could
not have produced (KNOWBOTS1, READ1), identical fighters (PROGPROBE1). The verdicts used above are the corrected ones. Some
are old (PUSHPROBE2 S443, FIGHTWEEKPROBE3 S450, MOODHABIT1 S428) and the game has moved; where I know it moved, the row says so.

---

## 3. Against the genre's references (our own words)

Where strategy lives in the good ones:

| Reference | Where its depth is | Ours |
|---|---|---|
| Football Manager | A squad bigger than the minutes available, so every pick costs someone else. Hidden attributes and scouting that can be wrong. Opponents who change shape against you. Contracts and ages that force planning years ahead. | One boxer at a time needs nothing shared. The shown rating is nearly the true one. Amateur opponents never adjust between bouts. Careers were ending near year one in probes (the gym closed) until the growth work. |
| Out of the Park Baseball | A budget that cannot buy everything; development that is uncertain, so prospects are bets; a long horizon where today's trade hurts in three years. | Money is survival, not a budget for competing goals. Potential is close to known (the Amateur coach edge even shows it exactly). Nothing bought today is regretted later. |
| Boxing Manager (Steam) | Matchmaking as risk: the right fight is not the one you will win. Rankings that punish ducking. Ageing and wear. | We have the pieces (step up, ducks, owed bouts, ladder points) and asking for a fight is one of our five real choices. For most boxers asking and waiting come out even. |
| World Championship Boxing Manager | Simple, but training time, money and fight frequency pull against each other, and fighters wear out. | Our tiredness and injury rules exist; the choices that would spend them (Hard mornings, Train through, Hard camp) are unmeasured or free. |
| Punch Club | Stats decay, so you cannot hold everything; a build is a commitment. Time is the currency. | Undrilled moves fade slowly; stats do not. There is no build to commit to: a boxer can be good at everything given weeks. |
| Two Point Hospital | Not strategy in the fight sense: layout and staffing under queues. Its lesson is readable cause and effect - you see why a room fails. | We match this well: the Why page, the week review's reasons, honest numbers. It is a strength to keep. |

In the four places depth lives:
- LONG-TERM PLANNING: weak. The road is fixed (wins, nationals, pro call) and the big fork, turning pro, has one answer.
- TRADE-OFFS BETWEEN RESOURCES: one real one, the coach's pad time against the calendar. Money, tiredness and morale rarely bind.
- INFORMATION UNDER UNCERTAINTY: tells on the opponent's file are real hidden information and they feed the plan - our best
  example. Prospects, win chances and scouting are not: the truth is nearly shown, so reading it pays nothing.
- OPPONENTS WHO ADAPT: inside a round only (a planned line pays in full twice, then less; PlanRead). Across bouts, only a
  pro's corner reads your boxer (ProRead). No amateur, rival coach or promoter changes behaviour because of what you did.

---

## 4. Verdict: wide, and the answer is "make existing choices matter"

FightCamp has more systems than any reference of its size and fewer live decisions than most of them. The core is sound:
drill, tape, plan, Why is a real strategic loop and it is the part you enjoy. Around it sit about thirty options that are
free, solved, or do not reach the result. Adding systems would add to that ring, not to the core. This agrees with your own
rule that new systems enter only when the last build feels right.

The changes, most depth for least build first. Each deepens something that exists.

1. GIVE EVERY FREE OR SOLVED OPTION A PRICE IN SOMETHING SCARCE (deepens: camp, fight week, class nights, corner minute,
   pace, the loan, turning pro's ask). Mostly constants plus one probe each. The ten one-answer rows are the work list.
   Examples: a Hard camp spends the tiredness that Peak Camp needs; ice takes the seconds the talk needs; the loan can bite
   in a bad quarter; each of turning pro's asks is best in at least 1 offer in 10. Pass line for each, measured before any
   screen work: no pick best in more than 6 cells of 10, and best against laziest worth 3+ wins in 100 or real money.
   Least build of the five, and it converts the most rows.

2. LET THE EXCHANGE READ WHERE THE BOXERS ARE AND HOW THEY COVER (deepens: steps, ring places, guard, the plan). One edge
   in one place - the exchange odds - for the opponent on the ropes or in the corner, and covering applied before the winner
   is picked. Already scoped (STEPS_PAYOFF_SCOPE_S533 phases 2-3; Kalli's guard fix "put covering into the exchange edge
   before settle"). This turns three faint systems into plan decisions and makes "what to learn next" a real pick, because a
   step would then be worth wins against the style it answers. No fight3d change needed.

3. MAKE THE COACH'S HANDS THE CLUB'S CURRENCY (deepens: the week, pad nights, loyalty, the second and third boxer). Pad time
   is the one resource that is truly scarce and truly decides bouts. Sharing the pad nights between boxers in camp is agreed
   and not built (critic pack 4.2). Built, every week asks "whose fight matters more", which is the squad-minutes question
   Football Manager is made of, and it gives loyalty and the goal talk something real to push against. LOYAL1 says the
   place count must be sized first (eight places could not serve four fighters).

4. LET THE PLAYER BE WRONG ABOUT PEOPLE (deepens: signing, scouting, the opponent's file, the coach's read). Today a
   prospect's attribute errors cancel out, so the shown rating is right. KNOWBOTS6 found the fix and its size: one shared
   misread per prospect (half shared) makes knowing the truth worth 9 to 14%. The same idea on opponents makes the $250
   scout and the film night worth their price. A small change inside Knowledge, no new screen.

5. ONE OPPONENT WHO REMEMBERS (deepens: rival coaches, the ladder, ProRead, the plan). The pro corner already studies your
   boxer's last two fights and waits for the punch thrown most. Give the same read to the named rival gym's corner in
   amateur rematches and on the ladder, and give the player a working counter (READBACK1 found none today: dropping or
   swapping the line both fail). Then a plan that won last month is a risk this month, which is what makes a plan a
   strategy and not a lookup.

What I would not do: another mechanic (damage by class, coach fit, a defence tab) until 1 and 2 are measured. And one change
to how we work: a mechanic's lever is probed on a greybox BEFORE the critics score its map - "moves the result, no pick best
past 6 in 10" - because five maps passed the critics at 7+ and then failed that test in the game.

## Sources read
Code: scripts/rules (constants and functions cited in part 1), scripts/state/LiveRound.gd, RingDuel.gd, Bouts.gd.
Results (docs/): STEPPAY1, TREEVALUE9, GUARDPROBE1-4, COACHFITPROBE2-3, FITPROBE1-2, TURNPROBE1-3B, TURNTUNE1, TURNGAP1,
TURNPRO6, KNOWBOTS1-7, MORNINGSPROBE1-2, PARTNERPROBE1, FAVOURPROBE1, FAVOURS2, LOANPROBE1, LADDERPROBE4, AMATEURPROBE1,
FIGHTWEEKPROBE1 and 3, PROGPROBE1, PUSHPROBE2, HANDSPROBE1, ASKPROBE1-4, STREAKPROBE1, PICKSPREAD1, MONEYFOUR2, MOODHABIT1,
READ1, READBACK1, GYMKIND1, LOYAL1, THURSDAY2, FIRELEVEL3, JUDGES1.
Research (ops/research/): CRITIC_PACK, DESIGN_LOOP_S459, S527_PROBES, S531_PROBE_READS, TURNPROBE3_READ_S530,
STEPS_PAYOFF_SCOPE_S533, and the critics' files for TURNPRO1 v10, DMGCLASS1 v2, GUARDDMG1 v5, COACHFIT1 v9, LADDER1 v6,
CLUBWEEK1 v11, AMATEURWEEK1 v9, PLANFLOW1 v3, THREEP4P v2, STEPVALUE1 v1, PUSHTANK v2.
The reference games in part 3 are described from general knowledge of them, not from a new study.
