# DESIGN WEIGHT2 - weight as one mechanic, written from the code

Kind: design map + a greybox measurement. No game code changed (nothing under `scripts/`). Written by a Fable console in the
checkout (S535, task `ops/research/TASK_WEIGHTMOVE1.md`). Code read at commit 65423f4a3 on 2026-11-21; `LineGrade.gd`,
`LiveRound.gd` and `StepWire.gd` carry another session's uncommitted edits and are not cited by line.
The owner, S535, verbatim: "The boxer should be able to change weight classes", then "Go deep with weight mechanic for 10/10 it
should be manageable to a certain point and affect various things about fighters performance,scaling etc".
Follows: `BOARD_WEIGHT1_R5_S478.md` (round 5, passed 7 / 7 on the old bar), `J_WEIGHT1.md`, `DESIGN_DMGCLASS1_V3.md` and its
Fable critic (finding L2), `DEPTH_SCOPE_S534.md`. Bar now: 8 depth and 8 play from two fresh critics, AFTER the probe.

Words used: CODE = I opened the file for this map and the line is true today. COUNTED = a real-world number with a sample and a
named source (all of them from `J_WEIGHT1.md`, which John collected in S375; I did not re-open the papers). ESTIMATE = my
number, on John's list (`JOHN_WEIGHT2_ASK.md`) and in the probe's MODEL. NEW = no code path exists. Nothing else is claimed.

## 0. The mechanic in eight lines

1. Every boxer has a NATURAL weight (where the body settles; it drifts with age) and a WALKING weight (today's scale).
2. The player holds the walking weight under the natural one with a DIET (three settings). Holding costs training gain.
3. The last kilos come off as WATER in fight week (three settings). Water is what drains him on the night.
4. How much water is back by the bell depends on the scale: same day (amateur, a quarter back) or the day before (pro, most back).
5. What he weighs IN THE RING against the other boxer is a size edge: punch, chin, the inside.
6. The class is a choice between bouts: stay, walk bigger and cut harder, move up, move down. A move costs one rung of rank (round 1's two rungs made staying always best; section 4).
7. His body has a limit (how much water he tolerates) that the player reads with error, and that shrinks with age.
8. Bound: three decisions, never more than one screen: a diet per boxer (Monday), water (fight week), class (between bouts).

"Manageable to a certain point" is lines 1, 2 and 7: the player steers the walking weight and never the natural one or the limit.

## 1. What the game does today (CODE)

### 1.1 The path of a kilo, end to end

| Step | Code | What it does |
| :--- | :--- | :--- |
| A boxer's two numbers | `Data.gd:60` (Lucy 60.9 for 60.0), `:221-241` (prospects: Kira 58.3 / 57, Samira 65.9 / 65, Tess 76.1 / 75, Danny 61.1 / 60, Josh 71.4 / 70) | `weight` and `limit`. Everyone walks 0.9 to 1.4 kg over. No natural weight, no frame. |
| The limit | `Data.fighter_state`, `Data.gd:261` | Copied from `Data.DIVISIONS[div]["limit"]` at signing. Written again only by a save migration (`SaveGame.gd:82-86`), the first hour (`FirstHour.gd:125`) and a start scenario (`ClubStart.gd:78`). **No boxer ever changes class.** |
| The classes | `Data.DIVISIONS`, `Data.gd:136-153` | Women 57, 60, 65, 70, 75. Men 55, 60, 70, 75 (no 65: a 10 kg hole). |
| When he cuts | `Sim.week_ctx`, `Sim.gd:121-126` | CUT only while within 0.15 kg of the limit or over it AND (`diet` is cut, or a camp is on, or an amateur bout is booked). Otherwise HOLD. The player sets nothing. |
| What a day moves | `WeekPlan.day`, `WeekPlan.gd:268-288` | kcal = MET x body kg x hours x intensity; kg = -(kcal - 300 allowance + deficit) / 7,700. CUT deficit 500 kcal (`:75`), the Old hand head coach +120 (`HeadCoach.gd:30`). About 0.45 kg a week. |
| Fight-week drop | `WeekPlan.gd:71-73` | `TAPER_KG` 0.05 kg a day "with no dehydration". There is no water cut in the game. |
| The cage | `Sim.gd:222-224`, the same in `Sim.weigh_forecast :154-156` and `CampForecast.gd:82-84` | Weight is clamped between limit - 1.5 and limit + 1.6 kg. **He can never grow out of a class, balloon on a layoff or go light.** |
| The forecast | `Sim.weigh_forecast`, `Sim.gd:136-159`; `CampForecast.run` (`CampForecast.gd:51-100`) | Steps the real days to the bout: {now, day, limit, ok, over}. Read by the ask panel, the first-week strip, fight prep, the coach's check. |
| Dating a bout | `Bouts.makeable_day`, `Bouts.gd:163-170` | An offer for a boxer over his class is dated a week at a time later until the forecast makes the limit, 4 weeks at most (`:51`). |
| Club shows | `WeighGap.gd:7-9`, `:33-39`; `AskFlow.gd:81-93`; `FightWeekPlan.weight :184-188` | Two amateurs are matched on walking weight within 2.5 kg (limit up to 65) or 5 kg, 2 kg for a skills bout. The opponent's weight is `opp["weight"]`, else the limit. |
| Fight-week ways | `WeighGap.ways :44-`, `FightWeekPick.weight_way :84`, `FightWeek.gd:34` | Eat less (4 off the tank), train it off (0.3 kg for +8 tiredness), ask a kilo (a favour). |
| The scale | `Bouts.weigh`, `Bouts.gd:361-391`; `BoutRules.made_weight :283-284` (tolerance 0.05, `:111`) | Made, or inside the gap. A club-show miss is re-matched 1 time in 3 (`PullOutWire.gd:192-215`). Else: news, $300 (`BoutRules.gd:112`), bout and camp gone, next offer in 6 days (`Bouts.gd:48`). A championship miss withdraws him. **No reputation, no morale, no record entry.** |
| The tank at the bell | `BoutRules.tank_parts`, `BoutRules.gd:203-212`; constants `:41-45` | tiredness + the scale part (`eat_kg`: 10 a kg same day, doubled past 0.5 kg; 5 a kg the day before) + the last bout, 25 off at most. |
| ...and its scale part | `BoutRules.gd:237`, `:243` read `bout["eat_kg"]` | **Nothing in `scripts/` writes `eat_kg`.** The scale part of the tank is always 0. Making weight costs nothing on the night except the 4 points of "Eat less". |
| The fight | `Duels.gd`, `Exchanges.gd`, `Knockdowns.gd`, `RingDuel.gd`, `WorldBout.gd` | None reads a weight, a limit or a division (grep; the same finding as DMGCLASS1 v3 section 1.1). Reach and height are read (`Duels.facts`, `Duels.gd:415-425`; `REACH_PER_CM`, `HEIGHT_PER_CM` in `_ob :189-233`). |
| Body by class | `AttrGen.body`, `AttrGen.gd:228-229`; `BodyFacts.fill` | Height = 172 + 1.0 a kg of the LIMIT over 60 (women 8 less) + noise, so height and reach already follow the class. |
| The opponent's kilos | `TapeRows.opp_weight`, `TapeRows.gd:74-80` | Invented for the tape: 0.2 to 0.8 kg under the limit, fixed by name. World boxers carry no weight. |
| Going pro | `ProLadder.division_for`, `ProLadder.gd:43-49` | The table is picked from the amateur limit (to 57.5 feather, to 62 light, to 70 welter, else middle). `limit` is not rewritten: finding L2 of the DMGCLASS1 v3 critic (a 70 kg boxer on a 66.7 kg table) is live. |
| The 3D body | `scripts/fight3d/v2/ArmBuild.gd:2-6` | Arms and shoulders are as thick as Strength (40 -> 1.00, 80 -> 1.24). Nothing scales with weight. |
| Goals and mood | `FighterGoal.gd:5` | "make-the-weight" was dropped at the restart. No boxer asks for a class or refuses one. |
| Injury | `InjuryRoll.gd`, `FightWeek.gd:39-40` | No read of a cut. (`SPAR_LATE_CUT_STOP` is a cut eyebrow.) |
| Age | `WorldAge.gd:29` | World boxers age a year at a time. The only write to an `age` in `scripts/` is that line: **the club's own boxers never get older** (grep of writes; a merge I did not find could still do it). |
| Knowledge | `Knowledge.gd:85-106` (groups and widths), `:185-186` (stale widens "body") | The misread pattern exists and has a body group. Weight is not in it: every kilo on every screen is exact. |

### 1.2 Where a player sees weight today

`DarkOverview.gd:438-443` (kg, limit, over), `FighterTile.gd:57-60` (the WEIGHT ring), `HomeRows.gd:196-202` ("1.2 to lose", amber
inside 14 days), `RosterRow.gd:140-164` and `RosterTable.gd:56`, `CoachCheck.gd:54-63`, `FightPrep.gd:189-208` (CAMP AND WEIGHT),
`GaugeRow.gd` + `Gauges.gd:47-48, 60-66` (SCALE: the class window down to the next class, 3 kg at most), `AskPanel.gd:79-84`,
`FirstWeekStrip.gd:189-200`, `modals/FightWeek.gd:60-62, 127-139` (THE WEIGHT), `modals/WeighIn.gd:14-19`, `TapeRows.gd:64-67`,
`BoutActs.gd:259-260` (the toast). Thirteen places, all of them one question: "is he under the line on the day?"

### 1.3 What that adds up to

Weight today is a gate with a forecast: make the line or lose $300. It has no price on the night (the dead `eat_kg`), no size,
no choice of class, no body that changes, and the one lever (CUT) switches itself on. The round-5 board plan (declared walking
weight, one amateur scale, a target with a date) made the gate fairer. It did not make weight a decision. This map does.

## 2. What is known from the real world

| Fact | Label | Source |
| :--- | :--- | :--- |
| Amateur boxers lose 4.2 to 5.6 % of body mass in the last 5 to 10 days, mostly fluid and gut content | COUNTED | Brown 2021 (63 men), Hall and Lane 2001 (16), Reljic 2013 (10), Breen / Norton 2019 (123), in `J_WEIGHT1.md` |
| Safe rate 0.5 to 1 kg a week; fluid loss under 1 to 2 % of body weight | OFFICIAL | England Boxing weight-management guidance 2024, in `J_WEIGHT1.md` |
| A same-day weigh-in: keep the short loss at 5 % or less | COUNTED (a recommendation) | Reale 2017, in `J_WEIGHT1.md` |
| One pro lost 9.4 kg over 12 weeks with no water cut planned | COUNTED (one man) | Morton 2010, in `J_WEIGHT1.md` |
| Club shows match walking weights inside a gap | OFFICIAL, CODE | England Boxing 2026 rules 7.1.3, 2.7.8, as `WeighGap.gd:2-9` records them |
| Performance lost per 1 % dehydrated; regain by scale; ring weight over the limit; dehydration and the chin; what a kilo of size is worth; class-move results; growth 16 to 23; age and the cut; the cost of a standing deficit; how often boxers miss | **ESTIMATE, all ten** | `JOHN_WEIGHT2_ASK.md` questions 1 to 10 |

Every slope in section 3 is an ESTIMATE until John answers. The probe (section 4) measures whether the SHAPE of the mechanic
holds decisions; the answers will move the sizes, and the probe is re-run on them before any critic sees this map.

## 3. The design: seven decisions

### 3.1 Two weights and a diet (the week) - replaces the automatic CUT

- NEW `natural` (kg): where the body settles. Starts at today's `weight`. Drifts: growth while young, age later (3.7).
- `weight` becomes the WALKING weight and loses its cage (`Sim.gd:222-224` and its two copies removed).
- The DIET, one setting per boxer, set on Monday, kept until changed. It replaces the `diet` hold / cut flag that `Sim.week_ctx` flips.

| Diet | Walking weight heads for | Price | Trade-off |
| :--- | :--- | :--- | :--- |
| Eat free | natural + up to 2 % (he fills out) | none; recovery a touch better | Bigger body, further from the line |
| Hold | natural | none | Today's HOLD |
| Lean | as far as 2.5 % under natural, at 0.45 kg a week (`WeekPlan` 500 kcal, CODE) | training gain x (1 - 0.12 per 1 % held under), injury roll up | The line is close on fight week; he learns slower all camp |
| Strip (only on a class move down) | as far as 5 % under | the same slope, twice as far | A new body: weeks of it before the first bout |

The morning sessions still burn what they burn (`WeekPlan.day`): a hard week pulls the scale down faster and a rest week lets it
climb, so the plan and the diet read each other as they do today. What changes is that the player owns the setting and it
costs something he cares about (the training gain he is planning the same week).

### 3.2 Water in fight week (performance) - gives the dead tank part a job

In the Fight week modal's THE WEIGHT column the three ways (eat less, train it off, ask a kilo) become one question: how much
of what is left comes off as water. None / Light (to 2 % of body weight) / Hard (to his limit, 3.3).

- At the bell he is DRY by water x (1 - regain). Regain: a quarter back on a same-day scale, four fifths the day before (ESTIMATE, John 2).
- Each 1 % dry: 3 off the tank at the first bell (`bout["stale"]`, the number `BoutNight._energy` already takes off at `BoutNight.gd:324`),
  Stamina -2, chin -1.5, hand speed -0.8, power -0.5 for this bout only; each 1 % past 3 % counts twice (ESTIMATE, John 1 and 4).
- Because it is Stamina and the tank, it shows where the coach expects it: from round 3 (`BoutRules.own_fade`, the 60-Stamina line at
  `BoutRules.gd:86-89`) and in the energy his combinations spend (`Combos.round_spend`), not in round 1.
- `eat_kg`, its two readers and the "Eat less" 4 points go. "Ask a kilo" stays, as the favour it is.

### 3.3 The body's limit (manageable to a point)

- NEW `cut_tolerance` (% of body weight he can sweat out and still make the scale): 3 to 6 %, set at signing from his frame and
  Discipline, shrinking with age (3.7).
- Past the scale's safe line (2 % same day, 4 % the day before) each further 1 % is a chance to MISS, bigger for a boxer with low
  Discipline (`personality.discipline`, which Data already carries: Samira 34, Josh 80). Past his tolerance he misses outright.
- So the control is real and bounded: the player can always ask for more water, and the body can always say no on the day.

### 3.4 Size on the night (scaling)

- NEW ring weight = the limit + what he puts back (or his walking weight when he is under the limit). The opponent has one too:
  world and region boxers get a walking weight from their limit, age and style (today `TapeRows.opp_weight` invents 0.2 to 0.8 under).
- The gap in ring weight, as a % of body weight, is read where reach and height already are (`Duels.facts` ctx, `Duels.gd:415-425`):
  per 1 % heavier, punch +1.2 and chin +1.0 in the count odds (`RingDuel.side :138-139` -> `Knockdowns.round_counts`, and
  `WorldBout._side` for the world), the inside and the clinch his, hand speed -0.4. Capped at 8 points (ESTIMATE, John 5).
  It must also reach the exchange odds (a mass term in `Duels._ob` beside `REACH_PER_CM`): with punch and chin alone, giving away
  5 to 9 % cost nothing in round 1. Round 2 ran it as 0.35 rating points per 1 % (section 4.4).
- This IS the carry-over on a class move: no separate "power carries up" number. A puncher who moves up meets heavier men and
  his punch is worth less against them; his speed is worth more.
- 3D: the body should scale with weight, lightly, beside `ArmBuild` (Strength = arms and shoulders; ring weight = torso and neck
  width, 0.97 to 1.05), so a drained boxer and a filled-out one look it. One number into the same rig call; after FIGHTPLAYER2.

### 3.5 The class (the owner's ask)

- On the fighter's Overview BODY card, between bouts only: "Box at 65 kg from the next bout" with the forecast beside it
  (weeks to make it, water left for fight week, size against that class's field, where he lands on the ladder).
- Amateur: his class is whatever he enters at; the regional ladder is per class, so he joins the new one a place
  lower than he stood. Pro: a table move one rung down; a top-3 keeps his rung. (Round 1 took the whole rank away and staying
  was best in 10 of 10 cells; one rung is round 2's measured rule, section 4.4.)
- Turning pro picks the class on purpose: `limit` is rewritten to the table's row (fixes L2, `ProLadder.gd:43-49`).
- The class table gets a step above and below every boxer: men's 65 back (the 60 to 70 hole makes "move up" a 10 kg jump),
  and one class under the lightest and over the heaviest per sex (the probe ran on 54 to 81 women, 55 to 86 men).
- The boxer has a say (`FighterGoal`, where make-the-weight once lived): after two Hard water cuts in a row he ASKS to move up
  (refuse: morale -20, the size of a missed goal today); a proud one (Confidence high) refuses a move down once.

### 3.6 The club and what the player knows

- A miss: bout off and $300 as today, plus reputation -1 and it is on his file: after two, matchmakers book him off his walking
  weight (the round-5 "declared walking weight" becomes the consequence, not a form to fill).
- A nutrition plan is a coach's job, not a new hire: one of the coach's evening slots a week on a Lean or Strip boxer halves the
  training price of the diet. This is the "coach's hands as the club's currency" of `DEPTH_SCOPE_S534.md` row 3: the same hands that
  hold pads. A club with one coach cannot keep two boxers lean for free.
- KNOWLEDGE: the scale is exact. His tolerance and how dry he is are a read with error (`Knowledge` body group: range, never a
  lie). Each Hard cut he makes narrows it; a layoff or a birthday makes it stale. The opponent's weight story is a tape row:
  "walks 4 kg over: cuts hard" means bigger than you and likely to fade late.

### 3.7 The long career

- Natural weight grows while he is young (ESTIMATE +1.5 kg a year to 20, +0.5 to 23; John 7): an 18-year-old featherweight is a
  lightweight at 21 whatever the player does. Kira (18, 58.3 for 57) is that story from the first week.
- From 28 the tolerance shrinks (ESTIMATE -0.2 a year; John 8): the veteran who made 60 for ten years stops making it.
- So a career has a weight arc: start light, fill out, one or two class moves, the last one forced. Each is a decision with a
  price (rank) and a window (before the body decides for him).

### 3.8 What it deepens, what it removes (free hand, owner S534)

| | What | Why |
| :--- | :--- | :--- |
| Removes | The automatic CUT in `Sim.week_ctx`; the weight cage (three copies); `eat_kg` and its readers; "Eat less" and "Train it off" as separate ways; the invented opponent weight | Each is a rule the player cannot touch or a number nothing uses |
| Deepens | The week (a diet has a price in the gain he is planning); the tank and the fade (a reason they differ bout to bout); the count odds (size); the ladder (a class is a place to be); Knowledge (a body read worth paying for); the coach's evenings | Existing systems get a second input instead of a new screen |
| Adds | natural weight, cut tolerance, ring weight, the class move, the miss on file | Five numbers, three decisions |
| Leaves alone | The club-show gap (`WeighGap`), the forecast (`Sim.weigh_forecast` keeps its job with the diet as an input), the $300 | They work |

### 3.9 Kept manageable: what is NOT in

No calories, no food, no body-fat number, no sauna minigame, no catchweight haggling, no IV or rule-breaking, no per-day water
slider (three settings), no separate nutritionist hire, no weight for the BJJ fighter (`RosterRow.gd:141-142` keeps her class word).
A week asks at most: one diet setting per boxer on Monday (only shown when he is not on Hold or a bout is near), and in a fight
week one water setting. The class card appears between bouts. One screen.

## 4. The probe (measured before any critic): round 1 FAIL, round 2 PASS

Run: `tools/weight2_probe.gd` through `godot_slot`, 20 seeds x 6 bouts a run, 9,760 bouts in 721 s, no script error. Full
output: `docs/WEIGHT2_PROBE.md`. Real: five Data boxers (Samira the puncher, Josh the volume man, Tess the big chin, Kira
walking 2.5 kg heavier as the drained cutter, Danny as a plain boxer-puncher), their region opponents, and every bout
(`BoutNight.play_out` on a scratch career, the fight DAY's dice, every choice of a seed on the same nights). Scratch: the
weight model of section 3 (the probe's MODEL), on a class table with a step above and below everyone.

### 4.1 Round 1 result: FAIL

| Bar | Measured | |
| :--- | :--- | :--- |
| Each lever moves the result | drain 3.7 points of win share (best choice changes in 4 of 10 cells with it off), size 2.9 (5 cells), diet 1.9 (3), miss 0.9 (2), rank 3.1 (4) | met |
| No single choice best in more than 6 of 10 cells | **STAY is best in 10 of 10** on ladder place at the end | **not met** |

Ladder place after six bouts (1 is the top; everyone starts on 8, a class move starts on 10):

| Cell | STAY | CUT harder | UP | DOWN | Best |
| :--- | ---: | ---: | ---: | ---: | :--- |
| puncher / amateur | 9.88 | 10.45 | 10.98 | 11.55 | STAY |
| puncher / pro | 10.63 | 10.63 | 11.15 | 10.93 | STAY |
| volume / amateur | 9.45 | 10.10 | 10.23 | 11.18 | STAY |
| volume / pro | 9.43 | 9.70 | 10.98 | 10.30 | STAY |
| big chin / amateur | 9.63 | 10.07 | 10.40 | 11.15 | STAY |
| big chin / pro | 10.25 | 10.43 | 10.88 | 10.80 | STAY |
| drained cutter / amateur | 10.18 | 11.23 | 10.65 | 11.82 | STAY |
| drained cutter / pro | 10.43 | 10.45 | 11.03 | 11.30 | STAY |
| boxer-puncher / amateur | 9.43 | 9.57 | 10.43 | 11.40 | STAY |
| boxer-puncher / pro | 9.90 | 10.10 | 10.80 | 10.88 | STAY |

Win share of the bouts fought (120 bouts a number; about 4 points either way is noise, so a gap under 6 is not established):

| Cell | STAY | CUT harder | UP | DOWN |
| :--- | ---: | ---: | ---: | ---: |
| puncher / amateur | 30 % | 23 % | 30 % | 21 % |
| puncher / pro | 18 % | 18 % | 18 % | 20 % |
| volume / amateur | 36 % | 29 % | 42 % | 32 % |
| volume / pro | 24 % | 23 % | 19 % | 26 % |
| big chin / amateur | 33 % | 26 % | 41 % | 29 % |
| big chin / pro | 15 % | 13 % | 21 % | 21 % |
| drained cutter / amateur | 32 % | 15 % | 38 % | 23 % |
| drained cutter / pro | 20 % | 20 % | 28 % | 23 % |
| boxer-puncher / amateur | 37 % | 36 % | 42 % | 34 % |
| boxer-puncher / pro | 23 % | 23 % | 24 % | 22 % |

### 4.2 What the numbers say

1. **The rank a class move costs decides everything.** Starting two rungs lower cannot be won back in six bouts by any weight
   edge the model produces (an edge of 2 to 9 points of win share is worth a fraction of a rung). STAY wins every cell for that
   reason alone; with the rank lever off, the best choice changes in 4 of 10 cells. Section 3.5's "rank is lost" is too dear.
2. **In the bouts themselves, moving UP is the strongest pick, not staying**: on win share UP is first or level in 7 of 10 cells
   (clearly in two: volume / amateur +6, big chin / amateur +8). Giving away 4 to 9 % of body weight cost little: the size rule
   moves punch and chin, and those two stats barely move who wins rounds in today's fight (they move the counts). A model whose
   size edge is worth less than fresh legs makes "up" free. The size slope has to reach the exchange odds (`Duels`), not only the counts.
3. **CUT harder is a dead choice.** Walking 2 kg bigger in the same class is never best on either measure: on a same-day scale
   it is all drain (the cutter loses 46 % of her bouts inside the distance at 5.1 % dry), on a day-before scale it only draws level with STAY.
4. **The scale kind works as designed.** The same 4 % of water is 3.0 % dry on the amateur scale and 0.8 % on the pro scale; DOWN
   is the worst amateur pick in all five cells and first or level on win share in three of the five pro cells. This is the
   part of the mechanic that already reads like boxing.
5. **Drain shows late and in the stoppages, as intended.** The cutter cutting harder: late rounds won 46 % -> 24 %, stopped 13 % -> 46 %.
6. **Discipline shows at the scale.** Samira (Discipline 34) misses 2.95 scales in six moving down; Tess (62) misses 0.95 on a smaller cut.
7. **A flaw of the probe, not of the design:** every boxer loses most bouts on every choice (15 to 42 % wins) against opponents
   rated at his own paper strength, so the ladder only ever falls and squeezes against rung 12. The next run fits the opponents
   so that STAY wins about half, or the ladder cannot separate anything.

### 4.3 What round 1 said to change

| Change | Why | Section |
| :--- | :--- | :--- |
| A class move keeps most of the rank: one rung lost, not two; a top-3 keeps his place | Finding 1 | 3.5 |
| Size reaches the exchanges: ring-weight gap into `Duels.facts` beside reach (the inside, the clinch, being walked down), not only punch and chin | Finding 2 | 3.4 |
| CUT harder stops being a choice (WITHDRAWN after round 2: it is best in two pro cells, 4.4) | Finding 3 | 3.1, 3.5 |
| The class above pays: a heavier class has a deeper field and bigger tickets (ESTIMATE), so UP has a reason beyond the bouts and DOWN a price | UP must not be free | 3.5, 3.6 |
| The probe: opponents fitted to 50 % for STAY, 12 bouts a run, the score = ladder place AND the season's money | Finding 7 | probe |

### 4.4 Round 2, measured: PASS

The changes of 4.3 that a greybox can hold went into the probe's MODEL: a class move costs ONE rung; the size gap also makes
the opponent worth 0.35 rating points more or less per 1 % of ring weight (size in the exchanges, ESTIMATE); opponents eased
(3 points amateur, 6 pro) so the ladder can rise; 12 bouts a run on a 20-rung ladder, everyone starting on 10. Same boxers, same
nights for every choice of a seed. 15,167 bouts in 650 s, no script error. Full table: `docs/WEIGHT2_PROBE.md` (round 1's is in
commit 875376421). The money of the class above was NOT modelled.

| Bar | Measured | |
| :--- | :--- | :--- |
| Each lever moves the result | size 3.6 points of win share (best choice changes in 5 of 10 cells with it off), drain 2.3 (4), rank 1.7 (3), miss 1.7 (1), diet 1.5 (1) | met |
| No single choice best in more than 6 of 10 cells | STAY 5, CUT harder 2, UP 2, DOWN 1 | **met** |

Ladder place after twelve bouts (1 is the top; start 10, a class move starts on 11):

| Cell | STAY | CUT harder | UP | DOWN | Best |
| :--- | ---: | ---: | ---: | ---: | :--- |
| puncher / amateur | 11.32 | 12.23 | 13.35 | 15.10 | STAY |
| puncher / pro | 11.93 | 11.30 | 13.45 | 11.43 | CUT |
| volume / amateur | 10.20 | 10.85 | 11.10 | 12.78 | STAY |
| volume / pro | 9.82 | 8.78 | 11.90 | 8.85 | DOWN (level with CUT, higher win share) |
| big chin / amateur | 10.85 | 11.25 | 10.88 | 12.80 | UP (level with STAY, higher win share) |
| big chin / pro | 10.05 | 10.10 | 11.50 | 11.45 | STAY |
| drained cutter / amateur | 12.32 | 14.88 | 10.90 | 15.88 | UP |
| drained cutter / pro | 9.07 | 10.82 | 9.93 | 10.88 | STAY |
| boxer-puncher / amateur | 10.38 | 11.13 | 11.57 | 14.32 | STAY |
| boxer-puncher / pro | 9.95 | 9.35 | 10.80 | 9.85 | CUT |

What it says, and how far to trust it:

1. **The scale decides the direction.** On the same-day amateur scale no cut ever pays: STAY or UP in all five cells, DOWN last
   in all five (5 to 9 missed scales in twelve for the three with the most water). On the day-before pro scale size comes back
   cheaply, so CUT harder or DOWN is best in three of five. This is the mechanic's spine and it held in both rounds.
2. **The body decides inside that.** The cutter who has outgrown her class must move up as an amateur (10.90 against 12.32, and
   3.45 missed scales staying) yet is best staying put as a pro. The big chin can afford to give weight away (UP level with STAY);
   the puncher cannot (UP is her worst amateur pick by two rungs: her punch is worth less up there).
3. **CUT harder is alive on the pro scale**, which round 1 called dead. It stays a choice. Its amateur form is still never best.
4. **Thin margins.** Two cells are decided inside a tenth of a rung, and 240 bouts a number leaves about 3 points of win share
   as noise. The split 5 / 2 / 2 / 1 is the finding; any single cell's winner is not. STAY at 5 of 10 is also the upper end of
   healthy: the money of the class above (not modelled) is what should pull one or two cells off it.
5. **Still estimates.** size_rating 0.35 and the one-rung cost were chosen after round 1, not sourced. John's answers (SQ278)
   replace the slopes; the probe is re-run on them, on main after the `s535/dmgfix` merge, before the critics.

Section 3 as it now stands for the critics carries round 2: one rung lost on a move (3.5), size in the exchanges (3.4), four choices.

## 5. Every menu it appears on

| Menu (file) | Shows | Wired to |
| :--- | :--- | :--- |
| Fighter Overview, BODY card (`DarkOverview.gd:438-443`) | Walking / natural / limit, the diet setting, the tolerance as a range, the class card between bouts | `natural`, `diet`, `cut_tolerance` through `Knowledge.range_of`, the class move |
| Week board, Monday (`WeekPlan`, `WeekData.gd:38` goal line) | The diet's price beside this week's gains ("Lean: -18 % on what he learns") | `WeekPlan.week` gain x the diet multiplier |
| Fight week modal, THE WEIGHT (`modals/FightWeek.gd:127-139`) | Water: None / Light / Hard, with dry-at-the-bell, the tank it costs and the miss chance as a range | `bout["water"]` -> `bout["stale"]` and the bout-only stat drops; `FightWeekPick.weight_way` proposes it |
| Fight prep, CAMP AND WEIGHT (`FightPrep.gd:189-208`) and the SCALE gauge (`GaugeRow.gd`, `Gauges.gd`) | The forecast with the diet in it; the band from natural down to the limit | `Sim.weigh_forecast` |
| Ask panel (`AskPanel.gd:79-84`), offers | "Makes 60 with 1.1 % water" instead of "Weight at risk" | the same forecast |
| Tale of the tape (`TapeRows.gd:64-67`), versus | Both ring weights and the gap; the opponent's weight story as a row | ring weight both sides, `OppFile` |
| Weigh-in modal (`modals/WeighIn.gd`) | The scale, a miss, the re-match | `Bouts.weigh` + the miss roll |
| The Why after a fight (`FightWhy`), tank words (`BoutRules.tank_words :265`) | "the scale 9" as a sized line; "outweighed by 3 kg in the ring" | the tank part, the size gap |
| Roster and home rows (`RosterRow.gd:140-164`, `HomeRows.gd:196-202`, `FighterTile.gd:57-60`, `CoachCheck.gd:54-63`) | Kg to lose, the diet as a chip, "asks to move up" | `weight`, `natural`, the ask |
| Ladder (`WorldLadder.gd`, the regional ladder) | His class's table; where a move would put him | `ProLadder.division_for` reading the rewritten `limit` |
| 3D fight | Torso width from ring weight | one factor beside `ArmBuild.k` |

Golden path walk for the build: sign, set Lean, see the gain drop on Monday, book, Hard water, weigh in, box drained, read the
Why, move up on the BODY card, box at the new class, see the ladder place.

## 6. The round-5 board plan folded in, and its three questions

| Round 5 (`BOARD_WEIGHT1_R5_S478.md`) | Here |
| :--- | :--- |
| Your corner declares a walking weight; fault follows it | Kept as a consequence: after two misses matchmakers book him off his walking weight (3.6) |
| One amateur scale, weighed an hour before, a meal back | 3.2: the same-day regain is the amateur's whole problem; the pro scale is the same rule with a different number |
| A weight target with a date, a Monday check-in | 3.1: the diet setting and the forecast on the Monday board |
| No new screen | Kept (section 5) |

| Its open question | Since then (CODE) | The answer this design needs |
| :--- | :--- | :--- |
| 1. A boxer at fault at the scale: bout off and $300, or a walkover loss? | S513: a club-show miss is re-matched 1 in 3, else off + a favour + $300 (`Bouts.gd:365-374`, `PullOutWire.gd:192-215`) | Keep bout off + $300, ADD reputation -1 and the miss on his file. A walkover loss would make every Hard cut a record gamble and push the probe's CUT cells toward never. |
| 2. Add women's 70 kg and men's 65 kg? | Women's 70 is in (`Data.gd:143`, Q-233 "add womans only"). Men's 65: the owner said yes while this map was being written (Q-292 "Add men's 65 kg"), added as `mlm` on branch `s535/dmgfix`, not on main yet | Answered. Still open: one class under the lightest and over the heaviest per sex, so the end boxers have somewhere to go. |
| 3. Men's 57.5 is not a World Boxing class | Changed to 55 (`Data.gd:132-133, 147`, Q-234 "Yes, 55 kg") | Closed. Nothing needed. |

New questions this map raises for the owner (taste and scope only): the outer classes (above); whether a boxer may REFUSE a move
(3.5) and whether the 3D body changes with weight (3.4) - both already on his board (S535). John's list went out as SQ278.

## 7. Risks and what is not proven

1. Ten slopes are ESTIMATES. The probe shows the shape works on them, not that they are right.
2. The probe puts size and drain on our boxer's stats only (the opponent is the mirror); the build reads both sides in `Duels.facts`.
3. Natural-weight growth, the shrinking tolerance, the diet's injury price, the boxer's ask and the Knowledge read are designed
   and NOT probed: they act over seasons, and the probe plays six bouts.
4. `Knockdowns` still stops pro bouts on the amateur count rule on main (L1, fixed on branch `s535/dmgfix`): the pro cells'
   stoppage shares (up to 44 % lost inside the distance) will move when that lands. Run round 2 after the merge.
5. Reach and height follow the class LIMIT (`AttrGen.body`): a boxer who moves up keeps his frame and meets taller men. That is
   right, and it means size is counted twice (frame and mass) unless the mass slope is fitted with reach in the model.
