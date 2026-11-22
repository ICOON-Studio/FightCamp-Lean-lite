# DESIGN WEIGHT2 v2 - weight as one mechanic: the owner's answers, John's numbers, probe rounds 3, 4 and 5

Kind: design map + a greybox measurement. No game code changed (nothing under `scripts/`). Written by a Fable console in the
checkout (S535, task `ops/research/TASK_WEIGHT2R3.md`). Code read at commit 31d42481e on 2026-11-21; `LineGrade.gd`, `LiveRound.gd`,
`StepWire.gd`, `MHRig.gd` and `Player2.gd` carry other sessions' uncommitted edits and are not cited by line.
Replaces `DESIGN_WEIGHT2.md` (v1, which keeps the full tables of probe rounds 1 and 2).

The owner, S535, verbatim: "The boxer should be able to change weight classes", then "Go deep with weight mechanic for 10/10 it
should be manageable to a certain point and affect various things about fighters performance,scaling etc". His three answers
since v1: Q-292 "Add men's 65 kg"; Q-293 "Yes, he can refuse"; Q-294 "Yes, after the probe" (the 3D body shows his weight).
Bar (owner S534): 8 depth and 8 play from two fresh critics, AFTER the probe.

Words used. CODE = I opened the file for this map and the line is true at the commit above. John's tags are kept as he wrote
them (`JOHN_WEIGHT2_RESEARCH_JOHN.md`, SQ278): SOURCED = he opened the source; DERIVED = his arithmetic on sourced numbers;
ESTIMATE = a judgement (his where a source question is named, mine otherwise); CHECK = cited, not opened; NOT FOUND. I checked
every number below against his line; I did not open the papers. NEW = no code path exists. DESIGN = a game number nobody can
source (a mood price), run in the probe.

What changed from v1: section 2 (ten estimates answered), 3.2 and 3.3 (the drain is a stamina story; safe lines by scale), 3.4
(size fitted to a counted number; the 3D body read), 3.5 (men's 65 kg; the refusal), 3.6 (a miss by bout type), 3.7 (growth by
age and sex), section 4.5 (round 3), and five CODE lines of v1 that were wrong or loose (marked "v1 corrected").

ROUND 4 (S536, task `ops/research/TASK_WEIGHT2R4.md`, a Fable console): the probe's sizes are now SHARES of body weight and a
pro's regain is a share of the water he took off. Changed for it: 3.1 (the diet in weeks), 3.2 (the regain rule), 3.5 (what
"cut harder" is), section 4 (4.6 is round 4: PASS, 7 of 10 cells clear), questions and risks 8 to 10. No CODE line was touched.

ROUND 5 (S536, task `ops/research/TASK_WEIGHT2R5.md`, a Fable console): the probe now runs the same kilos by DIET, WATER,
MIX or carried UP, puts height and reach back, charges the field for its own cut and boxes the design's three scales.
**RESULT: FAIL** (section 4.7): STAY is best in 10 of 15 cells (bar 9), and moving UP is right for nobody, so the frame bar
broke. Inside one scale the diet-or-water question has one answer. Changed for it: section 4 (4.7), questions, risks 11 to 16.
No CODE line was touched; sections 0 to 3 and 5 are as round 4 left them and are NOT yet rewritten for these findings.

## 0. The mechanic in eight lines

1. Every boxer has a NATURAL weight (where the body settles; it grows while he is young) and a WALKING weight (today's scale).
2. The player holds the walking weight under the natural one with a DIET (three settings). Holding costs training gain.
3. The last kilos come off as WATER in fight week (three settings). The first 2 % is free; past it water costs his engine.
4. How much is back by the bell depends on the scale: an hour before (club show), three hours (championship), the day before (pro:
   about nine tenths of the water he took off, so a very big cut is never all back).
5. What he weighs IN THE RING against the other boxer is a size edge: about 3 wins in 100 for each 1 % of body weight.
6. The class is a choice between bouts: stay, walk bigger and cut harder, move up, move down. A move costs one rung. He may say no.
7. His body has a limit (how much water he can make) that the player reads with error, and that shrinks with age.
8. Bound: three decisions, never more than one screen: a diet per boxer (Monday), water (fight week), class (between bouts).

"Manageable to a certain point" is lines 1, 2, 6 and 7: the player steers the walking weight, never the natural one, the limit
or the boxer's own mind about his class.

## 1. What the game does today (CODE)

### 1.1 The path of a kilo, end to end

| Step | Code | What it does |
| :--- | :--- | :--- |
| A boxer's two numbers | `Data.gd:60` (Lucy 60.9 for 60.0), `:222-242` (Kira 58.3 / 57, Samira 65.9 / 65, Tess 76.1 / 75, Danny 61.1 / 60, Josh 71.4 / 70) | `weight` and `limit`. Everyone walks 0.9 to 1.4 kg over (1.5 to 2.3 %). No natural weight, no frame. |
| The limit | `Data.fighter_state`, `Data.gd:261` | Copied from `Data.DIVISIONS[div]["limit"]` at signing. Written again only by a save migration (`SaveGame.gd:82-86`) and the first hour (`FirstHour.gd:125`). **No boxer ever changes class.** (v1 corrected: `ClubStart.gd:78` writes a start scenario's `weight`, not the limit.) |
| The classes | `Data.DIVISIONS`, `Data.gd:136-153` | Women 57, 60, 65, 70, 75. Men 55, 60, 70, 75 on main. Men's 65 (`mlm`, "Light welterweight", six region boxers) is on branch `s535/dmgfix` (`Data.gd:151`, `:205-210` there), not merged at this commit. |
| The diet switch | `WeekBoard.gd:353-357` (Hold / Cut pills), `WeekCamp.gd:270`, `BoutActs.gd:48-51` (the `diet` act) | The player CAN set Hold or Cut (v1 corrected: it said "the player sets nothing"). |
| When the cut bites | `Sim.week_ctx`, `Sim.gd:121-126` (the rule is `:123`) | Only while he is within 0.15 kg of the limit or over it AND (`diet` is cut, or a camp is on, or an amateur bout is booked). A camp or a booked bout switches it on by itself; Cut never takes him under the limit. So the pill decides little. |
| What a day moves | `WeekPlan.day`, `WeekPlan.gd:265-290` | kcal = MET x body kg x hours x intensity; kg = -(kcal - 300 allowance + deficit) / 7,700 (`:287-288`). CUT deficit 500 kcal (`:75`), the Old hand head coach 120 more (`HeadCoach.gd:30`). About 0.45 kg a week. |
| Fight-week drop | `WeekPlan.gd:71-73`, `:289-290` | `TAPER_KG` 0.05 kg a day "with no dehydration". There is no water cut in the game. |
| The cage | `Sim.gd:222-224`, the same in `Sim.weigh_forecast :154-156` and `CampForecast.gd:82-84` | Weight is clamped between limit - 1.5 and limit + 1.6 kg. **He can never grow out of a class, balloon on a layoff or go light.** |
| The forecast | `Sim.weigh_forecast`, `Sim.gd:136-160`; `CampForecast.run` (`CampForecast.gd:35`, result `:100`) | Steps the real days to the bout: {now, day, limit, ok, over}. The weigh-in is the day before the bout for everyone (`Sim.gd:142`; `modals/WeighIn.gd:17` "THE DAY BEFORE"). |
| Dating a bout | `Bouts.makeable_day`, `Bouts.gd:163-170` | An offer for a boxer over his class is dated a week at a time later until the forecast makes the limit, 4 weeks at most (`:51`). |
| Club shows | `WeighGap.gd:7-9`, `:33-39`; `AskFlow.gd:83-93`; `FightWeekPlan.weight :183-189` | Two amateurs are matched on walking weight within 2.5 kg (limit up to 65) or 5 kg, 2 kg for a skills bout. The opponent's weight is `opp["weight"]`, else the limit. |
| Fight-week ways | `WeighGap.ways :44`, `FightWeekPick.weight_way :84`, `FightWeek.gd:34` (rules), `modals/FightWeek.gd:131-138` | Eat less (4 off the tank), train it off (0.3 kg for +8 tiredness, `WeighGap.gd:13-14`), ask a kilo (a favour). |
| The scale | `Bouts.weigh`, `Bouts.gd:361-391`; `BoutRules.made_weight :283-284` (tolerance 0.05, `:111`) | Made, or inside the gap. A club-show miss is re-matched 1 time in 3 (`PullOutWire.weigh_miss`, `PullOutWire.gd:195-216`; `WeighGap.gd:18`). Else: news, $300 (`BoutRules.gd:112`), bout and camp gone, next offer in 6 days (`Bouts.gd:48`). A championship miss puts him out of the draw (`Bouts.gd:376-382`, `Champs.withdraw`, `Champs.gd:179-184`). **No reputation, no morale, no record entry.** |
| The tank at the bell | `BoutRules.tank_parts`, `BoutRules.gd:203`; constants `:41-45` | tiredness + the scale part (`eat_kg`: 10 a kg same day, doubled past 0.5 kg; 5 a kg the day before) + the last bout, 25 off at most. |
| ...and its scale part | `BoutRules.gd:237`, `:243` read `bout["eat_kg"]` | **Nothing in `scripts/` writes `eat_kg`** (grep: `BoutRules.gd` is the only file that names it). The scale part of the tank is always 0. Making weight costs nothing on the night except the 4 points of "Eat less". |
| The fight | `Duels.gd`, `Exchanges.gd`, `Knockdowns.gd`, `RingDuel.gd`, `WorldBout.gd` | None reads a weight, a limit or a division (grep at this commit: the only hit is a style-weights table, `Exchanges.gd:313`). Reach and height are read (`Duels.facts`, `Duels.gd:416-425`; `REACH_PER_CM` `:39`, `HEIGHT_PER_CM` `:40`, used at `:196`, `:212`, `:233`). |
| Body by class | `AttrGen.body`, `AttrGen.gd:228-230` | Height = 172 + 1.0 a kg of the LIMIT over 60 (women 8 less) + noise, reach from height: both already follow the class. |
| The opponent's kilos | `TapeRows.opp_weight`, `TapeRows.gd:74-80` | Invented for the tape: 0.2 to 0.8 kg under the limit, fixed by name. World boxers carry no weight. |
| Going pro | `ProLadder.division_for`, `ProLadder.gd:43-49` | The table is picked from the amateur limit (to 57.5 feather, to 62 light, to 70 welter, else middle). `limit` is not rewritten (finding L2 of the DMGCLASS1 v3 critic). |
| The 3D body | `ArmBuild.gd:2-12`, `k :29-30`, `BONES :18-24`, `apply :42-57` | Arms and shoulders are as thick as Strength (40 -> 1.00, 80 -> 1.24, bounds 0.96 to 1.30), by scaling only the helper bones that carry skin, across the limb. Nothing scales with weight. |
| Goals and mood | `FighterGoal.gd:5` | "make-the-weight" was dropped at the restart. No boxer asks for a class or refuses one. |
| His say, elsewhere | `PushBack.gd:50` (his ask about the week), `FighterProfile.gd:18-33` ("heard" +5, "overruled" -5, "refused" -4, goal missed -20 from `FighterGoal.gd:40`), `Loyalty.gd:45-62` (the price list), `Promises.gd:37` | The patterns a refusal can reuse exist: an ask, a mood price, a loyalty price, a promise. |
| Injury | `InjuryRoll.gd`, `FightWeek.gd:40` | No read of a weight or a diet (grep). (`SPAR_LATE_CUT_STOP` is a cut eyebrow.) |
| Age | `WorldAge.gd:29` | World boxers age a year at a time. The only write to an `age` in `scripts/` is that line: the club's own boxers never get older (grep of `["age"] =` and `+=`; a merge I did not find could still do it). |
| Knowledge | `Knowledge.gd:13` (groups), `:94-106` (width), `:174` (`range_of`), `:186`, `:199` (age 30+ widens "body") | The misread pattern exists and has a body group. Weight is not in it: every kilo on every screen is exact. |

### 1.2 Where a player sees weight today

`DarkOverview.gd:438-443` (kg, limit, over), `FighterTile.gd:57-60` (the WEIGHT ring), `HomeRows.gd:196-202` ("1.2 to lose", amber
inside 14 days, `:16`), `RosterRow.gd:140-164` and `RosterTable.gd:56`, `CoachCheck.gd:54-63`, `FightPrep.gd:189-192` (CAMP AND WEIGHT),
`Gauges.gd:47-49` (the SCALE band) and `:60-66` (the class window down to the next class, 3 kg at most, `:35`), `AskPanel.gd:79-84`,
`FirstWeekStrip.gd:189-192`, `modals/FightWeek.gd:60-62, 127-136` (THE WEIGHT), `modals/WeighIn.gd:14-19`, `TapeRows.gd:64-68`,
`BoutActs.gd:259-260` (the toast), `WeekBoard.gd:353-357` (the diet pills). Fourteen places, all of them one question: "is he under
the line on the day?"

### 1.3 What that adds up to

Weight today is a gate with a forecast: make the line or lose $300. It has no price on the night (the dead `eat_kg`), no size,
no choice of class, no body that changes, and its one switch (Cut) is thrown by the camp anyway. This map makes it a decision.

## 2. What is known from the real world (John SQ278, his tags)

| # | Fact | Tag | Source as John gives it |
| :- | :--- | :--- | :--- |
| 1 | A 4.8 % heat cut: repeat efforts 19 % slower after 3 h of eating and drinking, still 14 % slower at 24 h | SOURCED | Barley, JSCR 2018, 14 MMA athletes |
| 1 | A 3.2 % cut: 28 % fewer reps after 3 h, peak strength unchanged | SOURCED | Barley, Front Physiol 2018, 14 athletes |
| 1 | A 3 % cut: punch force -3.2 to -4.6 %, not significant | SOURCED | Smith, IJSNEM 2001, 8 amateur boxers |
| 1 | About 3 % dehydrated: endurance -8.3 %, strength -5.5 %, anaerobic power -5.8 % | SOURCED | Savoie, Sports Med 2015, 28 studies |
| 1 | Attention -0.52, coordination -0.40 (effect sizes); reaction time no significant change; worse above 2 % | SOURCED | Wittbrodt, MSSE 2018, 33 studies, 413 people |
| 1 | Under 2 % is "unlikely to affect" performance | SOURCED | Reale, GSSI 2018 |
| 2 | Pro boxers regain 4.4 kg = 7.2 % of body mass; one in five 10 % or more | SOURCED (high) | Murugappan and Reale, Phys Sportsmed 2022, 399 boxers |
| 2 | Each 1 % regained multiplies the odds of winning by 1.13 | SOURCED (high) | Baribeau, IJSPP 2023, 1,392 boxers |
| 2 | IBF title fights: +3.8 % with about 12 h, no effect on results | SOURCED | Daniele 2016, 142 boxers |
| 2 | Elite amateurs with 3 to 12 h: men +2.1 %, women +1.5 %, no link to winning | SOURCED (medium) | Reale, IJSPP 2017, 100 boxers |
| 2 | Amateurs with 1 h: +0.3 to 1 % | ESTIMATE (NOT FOUND) | John |
| 3 | Dehydration and stoppages or concussion rates | NOT FOUND | The measured risk is being the lighter boxer on the night (Baribeau 2023: the weight gap predicts KO and TKO wins, SOURCED) |
| 4 | Safe: a cut of at most 8 % with more than 12 h; at most 5 % (no more than 3 % by dehydration) with 6 h or less | SOURCED | Reale 2018 |
| 4 | Losing 0.7 % a week kept lean mass; 1 % a week did not | SOURCED | Garthe 2011, 24 athletes |
| 4 | Boxers lose about 3.6 % in the last week | SOURCED | Reale 2017, 73 boxers |
| 4 | England Boxing: club weigh-in 1 hour before; at championships at most 1 kg lost in the 2-hour window. World Boxing: a weigh-in every boxing day, 3 h or more before, no tolerance. BBBofC: 24 to 36 h before. WBC: at most 10 % over at 30 days, 5 % at 14, 3 % at 7 | SOURCED | the bodies' rules |
| 5 | Median growth, kg a year: boys 3.6 (16 to 17), 2.6, 1.9, 1.4 (19 to 20); girls 1.2, 1.0, 1.1, 0.9 | DERIVED | CDC 2000 table (US population, an archive mirror) |
| 5 | Ages 21 to 23: 0.5 to 1 kg a year | ESTIMATE | John |
| 5 | Elite female judoka gained 1.76 kg a year, about 1.6 times the median girl | SOURCED | Smaruj 2019, 12 athletes |
| 5 | Cuts getting harder with age | NOT FOUND | |
| 6 | Heavyweights who had boxed in lower classes were 19.9 % less likely to win | SOURCED | Fiala, IJSSC 2025 |
| 6 | 41 multi-class champions, 2 or more classes up: wins 94 % -> 74 %, KO share of wins 69 % -> 53 %, stopped 2.0 -> 6.5 in 100 | DERIVED, biased: an upper bound | John's count |
| 7 | The heavier boxer on fight night wins more; about +3 wins in 100 per 1 % heavier at even odds | SOURCED; the 3 is John's reading (DERIVED) | Baribeau 2023 |
| 7 | Reach: a 2-inch edge wins 58 %, 8 inches 65 % | weak | Fight Matrix blog 2008, not peer reviewed |
| 8 | Elite amateurs: 1 miss in 101 boxers. An amateur miss is a walkover (England Boxing, World Boxing) | SOURCED | Reale 2017; the rules |
| 8 | Pro boxing miss rate: 1 to 3 % | ESTIMATE (NOT FOUND) | UFC 2021 stands in: men 2.8 %, women 4.7 % (SOURCED, a journalist's count) |
| 8 | Pro fines: Ohio 20 / 25 / 30 % of the purse, Oregon and California 20 %; an IBF champion loses the title on the scale | SOURCED (Nevada 25 %: CHECK) | commissions |
| 9 | Pros are about 7 % over the limit on fight night | SOURCED | as row 2 |
| 9 | Pros between camps 8 to 15 % over; amateurs walk 3 to 5 % over | ESTIMATE | John |
| 10 | UK nutrition support: a 10-week camp 400 to 650 pounds ($500 to $813), a weigh-in night 200 pounds | SOURCED | the providers' own pages |

John's game reading, used in section 3 and in the probe (his section "What this means", DERIVED or ESTIMATE): the first 2 % of
a cut is free; each 1 % past it costs an amateur Stamina 4 %, power 1.5 %, defence and reading 1 %, and a pro Stamina 1.5 %
(3 % past a 5 % cut), power 0 (1 % past 5 %), defence and reading 0.5 %; hard caps 5 % amateur, 8 % pro; regain +0.5 % with a
1-hour scale, +1.9 % with 3 hours or more, +7 % pro; two misses push a boxer up a class; moving up two classes: KO share x 0.88,
stopped x 1.5 (ESTIMATE, half his biased count); a nutritionist halves the camp's stamina penalty (ESTIMATE).

Still unanswered, so still my ESTIMATE: how the size edge splits between punch, chin and hand speed; the training price of
holding weight under natural; the miss slope past the safe line and Discipline's part in it; the tolerance lost per year of age;
one rung for a class move. Three items John cites unopened (CHECK): the 2 to 5 % youth cut, Nevada's 25 %, a 4.4 % amateur
day-before regain. None of the three is used here.

## 3. The design: seven decisions

### 3.1 Two weights and a diet (the week) - replaces the camp's automatic cut

- NEW `natural` (kg): where the body settles. Starts at today's `weight`. Grows while young (3.7).
- `weight` becomes the WALKING weight and loses its cage (`Sim.gd:222-224` and its two copies removed).
- The DIET, one setting per boxer, set on Monday, kept until changed. It replaces the Hold / Cut pills (`WeekBoard.gd:353-357`)
  and the rule in `Sim.week_ctx` (`Sim.gd:123`) that cuts by itself in a camp.

| Diet | Walking weight heads for | Price | Trade-off |
| :--- | :--- | :--- | :--- |
| Eat free | natural + up to 2 % (he fills out) | none | Bigger body, further from the line |
| Hold | natural | none | Today's HOLD |
| Lean | as far as 2.5 % under natural, never faster than 0.7 % of body weight a week (SOURCED, Garthe 2011: that pace keeps lean mass; the game's 0.45 kg a week is 0.6 to 0.8 %) | training gain x (1 - 0.12 per 1 % held under) (ESTIMATE: John found the pace line, no number for a standing deficit) | The line is close on fight week; he learns slower all camp |
| Strip (only on a class move down) | as far as 5 % under, at 1 % a week | the same slope, twice as far; at 1 % a week lean mass goes (SOURCED direction, Garthe 2011) | A new body: weeks of it before the first bout |

The diet in WEEKS (round 4): at the 0.7 % pace, holding 2.5 % of body off is 3.6 weeks of dieting and he keeps 70 % of his
training gain while he holds it; 5 % (Strip) is 7.1 weeks and 40 %; a boxer already 1.5 to 2 % over his class (all five Data
boxers) is 2 to 3 weeks and 76 to 84 %; moving up is 0 weeks and 100 %. The same ESTIMATE as the table (0.12 per 1 % held =
0.084 of the gain per diet week), shown as time because a camp is counted in weeks.

The morning sessions still burn what they burn (`WeekPlan.day`, `WeekPlan.gd:268-269`): a hard week pulls the scale down faster
and a rest week lets it climb. What changes is that the player owns the setting and it costs the gain he is planning that week.

### 3.2 Water in fight week (performance) - gives the dead tank part a job

In the Fight week modal's THE WEIGHT column (`modals/FightWeek.gd:127-136`) the three ways become one question: how much of
what is left comes off as water. None / Light (to 2 % of body weight) / Hard (to his limit, 3.3).

- **Light is free.** Under 2 % performance is not touched (SOURCED, Reale 2018). This is the "manageable" part: a boxer kept
  close by his diet never pays on the night.
- **Past 2 %, the price is his engine, not his punch** (John's table, DERIVED from Barley 2018, Smith 2001, Savoie 2015):

| Each 1 % of water past the free 2 % | Same-day scale (amateur) | Day-before scale (pro) |
| :--- | ---: | ---: |
| Stamina, and the same share off the tank at the first bell | -4 % | -1.5 % (-3 % past a 5 % cut) |
| Power | -1.5 % | 0 (-1 % past a 5 % cut) |
| Defence and reading the fight | -1 % | -0.5 % |

- v1's chin and hand-speed drops are REMOVED: no study links dehydration to stoppages (NOT FOUND) and reaction time does not
  move (SOURCED, Wittbrodt 2018). The stoppage risk of a cut arrives through size (3.4): the boxer who cut and did not get it
  back is the lighter one.
- What is back by the bell, same-day scales: a share of body mass set by the hours, never more than he took off: +0.5 % an
  hour before (a club show; ESTIMATE 0.3 to 1), +1.9 % with three hours or more (a championship day; SOURCED basis: men 2.1,
  women 1.5).
- What is back by the bell, the day before (pro; round 4, replaces the flat +7.2 %): a SHARE OF THE WATER HE TOOK OFF. 0.9 on
  average, as four nights in five 0.81 and one night in five 1.25 (he comes back heavier than he dried). Where the numbers come
  from: the field regains 7.2 % of body mass on average and one in five 10 % or more (SOURCED, Murugappan and Reale 2022);
  7.2 over the 8 % guidance cut is 0.9 and 10 over 8 is 1.25 (DERIVED by me; the divisor is my ESTIMATE: John's note does not
  give those 399 boxers' own cuts, so the 8 % is the guidance cap, not a measured cut). So a pro who took off 4 % boxes 0.4 %
  short on the average night and one who took off 8 % boxes 0.8 % short (1.5 % on a usual night); the opponent rings 7.2 % over.
  The night's share is a roll the player sees only at the bell. John's per-1 % costs (the table above) stay on the size of the
  CUT, as he gives them. The game weighs everyone the day before today (`Sim.gd:142`): the amateur's same-day
  scale is NEW, and it is the round-5 board plan's "one amateur scale, weighed an hour before".
- Where it lands in code: the tank share is `bout["stale"]`, which `BoutNight._energy` already takes off at the first bell
  (`BoutNight.gd:324`); Stamina is what the fade from round 3 reads (`BoutRules.own_fade :330`, the 60-Stamina line at
  `BoutRules.gd:86-89`) and what his combinations spend against (`Combos.round_spend :241`). So a hard cut shows late, where
  a corner expects it, and not in round 1.
- `eat_kg`, its two readers (`BoutRules.gd:237, 243`) and the "Eat less" 4 points (`FightWeek.gd:34`) go. "Ask a kilo" stays.

### 3.3 The body's limit (manageable to a point)

- The SAFE LINE is the scale's, the same for everyone (SOURCED, Reale 2018): 3 % by water on a same-day scale, 8 % in all
  with more than 12 hours. Under it a boxer misses about 1 scale in 100 (SOURCED, Reale 2017: 1 in 101 elite amateurs).
- NEW `cut_tolerance`: HIS line, between the safe line and the hard cap of his scale (5 % same day, 8 % the day before:
  John's caps). Set at signing from his frame and Discipline (ESTIMATE), shrinking with age (3.7).
- Between the safe line and his tolerance each further 1 % is a chance to MISS (ESTIMATE: 20 points a 1 %, x 1.5 for no
  Discipline to x 0.5 for all of it; `personality.discipline`, `Data.gd:229` Samira 34, `:242` Josh 80). Past the cap he misses.
- So the control is real and bounded: the player can always ask for more water, and the body can always say no on the day.

### 3.4 Size on the night (scaling), and the body the player sees

- NEW ring weight = the limit + what he puts back (3.2), or his walking weight when he is under the limit. The opponent has
  one too: world and region boxers get a walking weight from their limit and scale (today `TapeRows.opp_weight` invents 0.2
  to 0.8 under; real amateurs walk 3 to 5 % over, ESTIMATE; pros are 7 % over in the ring, SOURCED).
- **What a kilo is worth is now a counted number:** about 3 wins in 100 for each 1 % heavier at even odds (DERIVED from
  Baribeau 2023, 1,392 boxers). The probe fits the mechanic to it (4.5, step 0).
- Where it is read: where reach and height already are (`Duels.facts`, `Duels.gd:416-425`). Per 1 % heavier: punch +1.2 and
  chin +1.0 in the count odds (`RingDuel.side`, `RingDuel.gd:138-139`; `WorldBout._side :324` for the world), hand speed -0.4,
  capped at 8 points (the split is my ESTIMATE; Baribeau gives the direction: the weight gap predicts KO and TKO wins), and a
  mass term in the exchange odds beside `REACH_PER_CM` (`Duels.gd:39`, `:196`) sized so the total is the 3 in 100.
- This IS the carry-over on a class move: no separate "power carries up" number. Check against John's count (41 champions
  two classes up: KO share x 0.77, stopped x 3.2, an upper bound; his game ESTIMATE x 0.88 and x 1.5): the probe prints it.
- **Men's 65 kg** (Q-292): the class ladder is women 57, 60, 65, 70, 75 and men 55, 60, 65, 70, 75. A 60 kg man's move up is
  5 kg (8 %), not 10. Still missing for a full ladder: one class under the lightest and over the heaviest per sex (scope, asked
  in section 6).

**The 3D body shows his weight (Q-294; built only after the critics pass, and after FIGHTPLAYER2).**

| | The read |
| :--- | :--- |
| The one number | fill = ring weight / frame weight. Frame weight is the weight his height carries, the inverse of `AttrGen.body` (`AttrGen.gd:229`: 60 kg at 172 cm, 1 kg a cm, women 8 cm shorter). Girth factor w = sqrt(fill), bounds 0.96 to 1.06: at a fixed height mass goes with girth squared, so 7 % more mass is 3.5 % more girth. |
| Which bones | The ArmBuild rule, measured on this rig (`ArmBuild.gd:7-12`): scale only helper bones that carry skin, on the two axes across the limb, never a bone of the chain. Trunk: `spine_04_latissimus` and `clavicle_pec` (both already in `ArmBuild.BONES` at half share, `:23`). Legs: the thigh and calf twist helpers, half share. The waist: a helper bone if the rig has one (NOT FOUND in `scripts/`: a bone census of the skeleton is phase 0 of the build), else a body blend shape on the mesh. |
| What is never scaled | `spine_01` to `spine_05`, the neck, the clavicles, the limb bones: a scale there is inherited down the chain and moves the head and the glove, which are the punch targets (`ArmBuild.gd:8-12`). Reach, height, guard and glove read exactly as before; `arm_build_test`'s checks (length, reach, glove unchanged) are extended to the trunk. |
| With Strength | On a shared helper the two factors multiply (Strength k x weight w), total clamped 0.94 to 1.34. Strength is the arms and shoulders; weight is the trunk and legs. |
| What the picture can honestly show | The CLASS (a 57 beside a 75), a boxer who filled out or stripped down (5 % of mass = 2.5 % of girth), and the size gap of the night when it is 4 % or more. It cannot show a kilo, and it cannot show water: 3 % dry is 1.5 % of girth. Drain is shown in words (tape row, the Why) and in the late-round fade, never as a thinner man. |
| Risk | A 1.5 % change may be invisible on the broadcast camera: the build's first step is a still pair at w 0.96 and 1.06 on the game's camera, both men head to feet, before any wiring. |

### 3.5 The class (the owner's ask), and his right to say no

- On the fighter's Overview BODY card, between bouts only: "Box at 65 kg from the next bout" with the forecast beside it
  (weeks to make it, water left for fight week, size against that class's field, where he lands on the ladder).
- "Walk bigger and cut harder" is sized as a SHARE of body, not kilos (round 4): he carries enough that 4 % of body weight is
  left for water at his own class line after a Lean diet (about 7 % over the line: 69.5 kg for a 65). That is above the free
  2 %, past the same-day safe line of 3 % and inside the same-day cap of 5 %; on the day-before scale it is half the 8 % cap.
  A boxer already that far over (the cutter) has nothing more to choose: for her it is STAY. Getting there takes the body time
  (Eat free, growth): the probe treats it as a standing policy, not a switch (risk 9).
- Amateur: his class is whatever he enters at; the regional ladder is per class (`Region.rankings :200`, `our_rank :237`), so he
  joins the new one a place lower than he stood. Pro: a table move one rung down; a top-3 keeps his rung. (Round 1 took two
  rungs and staying was best in 10 of 10 cells; one rung is round 2's measured rule.)
- Turning pro picks the class on purpose: `limit` is rewritten to the table's row (fixes L2, `ProLadder.gd:43-49`).
- He ASKS: after two Hard waters in a row, or a missed scale, he asks to move up (the `PushBack` pattern, `PushBack.gd:50`).
  Turning him down is "overruled": morale -5 (`FighterProfile.gd:30`), loyalty -5 (`target_against`, `Loyalty.gd:51`).

**He can refuse (Q-293).** The answer is on the card BEFORE the player commits: no hidden roll.

| | Rule |
| :--- | :--- |
| What decides it | His GOAL: a class he is ranked top 3 in, or has a championship entry or a promise in, he will not leave; a boxer the scale is already hurting (his own class needs water past the safe line) wants up and all but never refuses it, and fights a move down. His PRIDE (Confidence over 60: "I am not starving myself", "I am the big man here"). His LOYALTY and MORALE: a Loyal boxer (70 and over, `Loyalty.gd:22-24`) goes where the club says unless his goal is against it; a Wavering or Low one says no. |
| As numbers (DESIGN, run in the probe) | Chance of a no: 30 % to a move up, 50 % to a move down, +0.5 a point of Confidence over 60, -0.6 a point of Loyalty over 50; wants up: 5 % for up, +25 for down; never under 5 or over 90. In the game it is the same sum against a fixed line, shown as his answer with its two biggest reasons. |
| Push him: insist | He boxes there. Morale -20 (the size of a missed goal, `FighterGoal.gd:40`), loyalty -8 (the price of `decline_pro`, `Loyalty.gd:61`: both are "the club chose my career"). A Flat or Low boxer takes in less of the corner's word (trust 0.85 / 0.7, `FighterProfile.gd:39`, `:60-61`; read at `BoutRead.gd:235`; a Low one ignores the call, `CornerTrust.gd:11-12`), and under 25 loyalty he leaves (`Loyalty.gd:27`, `leaves :202`). |
| Push him: wait | He boxes on in his class; ask again after the next bout. Each thing that makes the case halves his no: a Hard water, a missed scale, a loss to a bigger man (for up); a loss up there (for down). The probe's player waits three bouts. |
| Push him: a promise | "One bout up there. If it goes wrong, we come back." A new kind in `Promises` (`Promises.gd:37`; kinds today `:11-13`): he says yes; kept +5, broken -12 (`Loyalty.gd:47`). |

### 3.6 The club and what the player knows

- A miss, by bout (v1 changed): a CLUB SHOW keeps today's gap rule (`WeighGap`, `PullOutWire.weigh_miss`): matched on walking
  weights, re-matched 1 in 3, else off + $300. A CHAMPIONSHIP or ladder bout is a walkover loss (SOURCED: England Boxing,
  World Boxing; today he is out of the draw, `Bouts.gd:376-382`). A PRO bout goes on and the club pays 20 % of the purse
  (SOURCED: Oregon, California), and a champion loses the belt on the scale (SOURCED: IBF). Every miss: reputation -1 and
  it is on his file; after two the matchmakers move him up a class (John's reading) - the round-5 "declared walking weight"
  as a consequence.
- A nutrition plan is a coach's job: one of the coach's evening slots a week on a Lean or Strip boxer halves the diet's
  training price (the "coach's hands" of `DEPTH_SCOPE_S534.md` row 3). Or it is BOUGHT for one camp at the real price: $500
  to $625 for an amateur camp, $875 to $1,250 for a pro's (SOURCED prices; "halves the penalty" is John's ESTIMATE). One
  button on Fight prep, no hire.
- KNOWLEDGE: the scale is exact. His tolerance and how dry he is are a read with error (`Knowledge` body group,
  `Knowledge.range_of :174`: a range, never a lie). Each Hard cut he makes narrows it; a layoff or age widens it (`:199`).
  The opponent's weight story is a tape row: "walks 4 kg over: cuts hard" means bigger than you and likely to fade late.

### 3.7 The long career

- Natural weight grows by age and sex (DERIVED, CDC medians; x 1.0 to 1.6 per boxer, SOURCED basis Smaruj 2019): a boy +3.6 kg
  at 16, 2.6 at 17, 1.9 at 18, 1.4 at 19; a girl 1.2, 1.0, 1.1, 0.9; 0.5 to 1 a year from 21 to 23 (ESTIMATE), then none.
  A 16-year-old boy outgrows a class a year whatever the player does. Kira (18, 58.3 for 57, `Data.gd:222`) gains 1.1 to
  1.8 kg this year: she is a lightweight by 19.
- From 28 the tolerance shrinks (ESTIMATE -0.2 a year: John found NOTHING on age and the cut. A critic may cut this line).
- The club's own boxers do not age today (1.1): the build needs a birthday first.
- So a career has a weight arc: start light, fill out, one or two class moves, the last one forced. Each is a decision with
  a price (a rung, his mood) and a window (before the body decides for him).

### 3.8 What it deepens, what it removes (free hand, owner S534)

| | What | Why |
| :--- | :--- | :--- |
| Removes | The camp's automatic cut in `Sim.week_ctx`; the weight cage (three copies); `eat_kg` and its readers; "Eat less" and "Train it off" as separate ways; the invented opponent weight; v1's chin and speed drain | Each is a rule the player cannot touch, a number nothing uses, or a claim no study carries |
| Deepens | The week (a diet has a price in the gain he is planning); the tank and the fade (a reason they differ bout to bout); the count and exchange odds (size); the ladder (a class is a place to be); loyalty and promises (a class is his career too); Knowledge (a body read worth paying for); the coach's evenings | Existing systems get a second input instead of a new screen |
| Adds | natural weight, cut tolerance, ring weight, the class move with his answer, the miss on file, a same-day scale | Six numbers, three decisions |
| Leaves alone | The club-show gap (`WeighGap`), the forecast (`Sim.weigh_forecast` keeps its job with the diet as an input), the $300 at a club show | They work |

### 3.9 Kept manageable: what is NOT in

No calories, no food, no body-fat number, no sauna minigame, no catchweight haggling, no IV or rule-breaking, no per-day water
slider (three settings), no nutritionist hire, no weight for the BJJ fighter (`RosterRow.gd:141-142` keeps her class word).
A week asks at most: one diet setting per boxer on Monday (only shown when he is not on Hold or a bout is near), and in a fight
week one water setting. The class card appears between bouts. One screen.

## 4. The probe (measured before any critic)

`tools/weight2_probe.gd` through `godot_slot`. Real: five Data boxers (Samira the puncher, Josh the volume man, Tess the big
chin, Kira walking 2.5 kg heavier as the drained cutter, Danny as a plain boxer-puncher), their region opponents, and every
bout (`BoutNight.play_out`, `BoutNight.gd:102`, on a scratch career; every choice of a seed on the same nights). Scratch: the weight
model of section 3, on a class table with a step above and below everyone. 10 cells = 5 boxers x 2 scales; 4 choices.
Bars: each lever moves the result; no single choice best in more than 6 of 10 cells. From round 4 also: 4 or more cells clear
of the noise; CUT harder in the leading group of at most 6 cells; at least one amateur cell where CUT is clearly worse than STAY.

| Round | Model | Result | Best counts |
| :--- | :--- | :--- | :--- |
| 1 (875376421) | estimates; a move costs two rungs; 6 bouts | FAIL | STAY 10 of 10 |
| 2 (ddc061494, `docs/WEIGHT2_PROBE.md`) | estimates; one rung; size in the exchanges at 0.35 rating points a 1 %; 12 bouts | PASS | STAY 5, CUT 2, UP 2, DOWN 1 |
| 3 (`docs/WEIGHT2_PROBE3.md`) | John's numbers; the refusal; an error per cell | PASS (weak: no cell clear of the noise) | CUT 4, STAY 2, UP 2, DOWN 2 |
| 4 (S536, `docs/WEIGHT2_PROBE4.md`) | sizes as shares of body; a pro's regain as a share of the cut; the diet in weeks; 40 seeds | **PASS: 7 of 10 cells clear** | STAY 4, CUT 4, UP 2, DOWN 0 |
| 5 (S536, `docs/WEIGHT2_PROBE5.md`) | water first to the free 2 %; frame on; the field pays for its cut; three scales (15 cells); the same kilos four ways | **FAIL**: STAY best in 10 of 15 (bar 9); UP best for nobody (frame bar) | STAY 10, CUT 2, UP 2, DOWN 1 |

Rounds 1 and 2 in full: `DESIGN_WEIGHT2.md` sections 4.1 to 4.4.

### 4.5 Round 3

Run: 20 seeds x 12 bouts a run, 3 seeds for the lever check, 10 seeds for the fit; 23,816 bouts in 1,229 s, no script error.
Full output: `docs/WEIGHT2_PROBE3.md`. On main (the `s535/dmgfix` merge has not landed: risk 5).

**What changed in the model.** The drain is John's table (free to 2 %, then Stamina, tank, power and reading by scale; no chin,
no hand speed). Regain is a share of body mass by scale (0.5 % / 7.2 %), for the opponent too, so a pro field rings 7.2 % over
the limit. A missed amateur scale is a walkover loss; a pro who misses boxes on; two misses move him up a class. Safe lines 3 %
and 8 %, caps 5 % and 8 %. A boxer may refuse a move (3.5) and the player waits three bouts. Every ladder place carries its
standard error, and a choice within two standard errors of the best (seed by seed, same nights) is called a tie.

**Step 0, the fit.** With no cut and no ladder, the stat split of size (punch, chin, hand speed) is worth 1.10 wins in 100 per
1 % of ring weight and a rating point 4.75. To reach John's 3.0 the rest goes in the exchanges: 0.40 rating points per 1 %
(round 2 guessed 0.35). The field was then eased until STAY starts at about half (offset -5.3 amateur, -10.9 pro: our boxers
give a pro field 6 % of body weight just by walking light, risk 7).

| Bar | Measured | |
| :--- | :--- | :--- |
| Each lever moves the result | size 4.5 points of win share (best choice changes in 6 of 10 cells with it off), rank 2.2 (2), diet 1.9 (2), miss 1.7 (0), drain 0.9 (4), refuse 0.6 (0) | met |
| No single choice best in more than 6 of 10 cells | CUT harder 4, STAY 2, UP 2, DOWN 2 | **met** |
| (new) cells where the best is clear of the noise | **0 of 10** | read below |

**RESULT: PASS on round 2's bars, and a weak one.** Ladder place after twelve bouts (1 is the top; +- one standard error):

| Cell | STAY | CUT harder | UP | DOWN | Best | Inside the noise of it |
| :--- | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher / amateur | 9.80 +- 0.57 | 10.00 +- 0.55 | 12.28 +- 0.54 | 12.15 +- 0.52 | STAY | CUT |
| puncher / pro | 10.43 +- 0.47 | 9.57 +- 0.37 | 11.25 +- 0.43 | 9.45 +- 0.48 | DOWN | CUT |
| volume / amateur | 8.88 +- 0.55 | 8.85 +- 0.56 | 10.28 +- 0.53 | 10.73 +- 0.54 | CUT | STAY |
| volume / pro | 8.47 +- 0.45 | 6.58 +- 0.42 | 9.15 +- 0.41 | 6.95 +- 0.41 | CUT | DOWN |
| big chin / amateur | 9.15 +- 0.52 | 9.30 +- 0.53 | 9.18 +- 0.52 | 10.78 +- 0.52 | UP | STAY, CUT |
| big chin / pro | 7.78 +- 0.40 | 7.35 +- 0.43 | 8.85 +- 0.42 | 7.70 +- 0.44 | CUT | DOWN |
| drained cutter / amateur | 10.18 +- 0.53 | 9.40 +- 0.46 | 9.13 +- 0.50 | 12.20 +- 0.45 | UP | CUT |
| drained cutter / pro | 6.10 +- 0.40 | 5.95 +- 0.42 | 7.42 +- 0.40 | 6.35 +- 0.43 | CUT | STAY |
| boxer-puncher / amateur | 8.90 +- 0.48 | 9.28 +- 0.52 | 10.25 +- 0.45 | 10.68 +- 0.62 | STAY | CUT |
| boxer-puncher / pro | 7.38 +- 0.42 | 6.83 +- 0.38 | 8.25 +- 0.40 | 6.58 +- 0.36 | DOWN | CUT |

What it says, and how far to trust it:

1. **No cell has a clear winner.** Every best has at least one other choice inside the noise. The split 4 / 2 / 2 / 2 is the
   lowest mean in each cell, nothing more. What IS established is what loses: a choice two standard errors behind the best.
2. **The scale still decides the direction, and that part is clear.** Same-day scale: moving DOWN is out of the leading group
   in all five cells (1.3 to 3.4 scales missed in twelve; 50 to 100 % of those runs ended moved back up by two misses), and UP
   is out in three. Day-before scale: UP is out in all five (it gives a field that rings 7.2 % over the limit 10 to 11 % of
   body weight) and STAY in four; CUT harder or DOWN leads every cell. An amateur should not cut; a pro must. This held in all
   three rounds.
3. **CUT harder is in the leading group of all 10 cells.** That is the finding a critic should press. On the day-before scale
   it is boxing as it is (walk bigger, get it back). On the same-day scale it is level with STAY because it is nearly free:
   2 kg more is 1.5 to 2.4 % of water, at or just past the free 2 %, and it closes a 0.5 % size gap. A choice that costs nothing
   and gains nothing is not a decision. It needs a price the probe does not carry: the diet weeks, or walking 2 kg heavier all
   camp. (In the cutter's amateur cell "CUT" is not CUT at all: she misses twice in every run and is moved up; that row is
   UP with two walkover losses.)
4. **The drain is small where John puts it.** Its mean effect is 0.9 points of win share: with the first 2 % free and a 5 % cap,
   an amateur can only ever be 1 to 3 % past the line (4 to 12 % of Stamina), and the cells that go further miss the scale
   instead. The stamina story shows in the cutter (-7 % Stamina staying: late rounds are not worse, but she misses 1.5 scales
   in twelve) more through the SCALE than through the fight. The bigger lever by far is size (4.5 points, 6 cells).
5. **Size lands at 1.2 wins in 100 per 1 % on the ladder**, against the 3.0 it was fitted to with the field held still: a
   winner meets better men. That is the right behaviour for a ladder; a build should fit to the 3.0 off the ladder, as here.
6. **The refusal barely moves the ladder** (0.6 points, no cell changes its best; it passes the bar on one cell's 1.2 rungs
   over 3 seeds, which is noise-sized). Waiting three bouts is cheap. As designed the refusal is a mood and loyalty decision,
   not a ladder one; if it should bite, "wait" needs a clock (his window closes, or the next ask is harder).
7. **Moving up, against John.** One class up, pooled: knockout share of the wins 31 % -> 29 % (x 0.91), stopped 5.6 -> 7.2 in
   100 (x 1.29). John's ESTIMATE for two classes: x 0.88 and x 1.5. Same direction, a plausible size for one class.
8. **Not established:** any single cell's winner; the diet, miss, rank and refuse levers on 3 seeds (their changes are of the
   size of the noise); everything in risk 4. Twenty seeds give half a rung of error; separating choices 0.3 rungs apart needs
   about 100 seeds a cell.

Not resized: the bars are met, so the model stands as run. The two things above that I would change before a build (a price
for walking bigger, a clock on "wait") are design changes for the critics to rule on, not number fixes.

### 4.6 Round 4 (S536): the sizes as shares, the regain as a share of the cut

Run: 40 seeds x 12 bouts a run, 3 seeds for the lever check, 10 seeds for the fit; 32,885 bouts in 932 s, no script error.
Full output: `docs/WEIGHT2_PROBE4.md`. One smoke run before it (2 seeds x 4 bouts, to catch script errors; its numbers were
not read for tuning). The first full run met every bar, so nothing was resized after seeing a result.

**What changed in the model** (all in `tools/weight2_probe.gd`; nothing under `scripts/`):

| | Round 3 | Round 4 | Tag |
| :--- | :--- | :--- | :--- |
| CUT harder | walks 2 kg bigger (1.5 to 2.4 % by water: under or at the free 2 %) | walks big enough that 4 % of body is left as water at his own line after the 2.5 % diet (`_walk`: limit / 0.935) | the 4 % is the task's size; free 2 %, safe 3 %, cap 5 % are John's (SOURCED, Reale 2018) |
| UP fills out | 1 kg | 1.5 % of body | ESTIMATE (round 3's kilo as a share) |
| Pro regain | 7.2 % of body, capped at the water taken off: every pro cell 0.0 % dry | a share of the water: 0.8125 four nights in five, 1.25 one in five, 0.9 on average (3.2) | DERIVED by me from John's SOURCED 7.2 % and "one in five 10 %"; the divisor 8 % is an ESTIMATE |
| The diet's price | applied, never printed | the same slope, printed as two columns: diet weeks at 0.7 % a week (SOURCED pace) and training kept | the slope stays an ESTIMATE |
| Seeds a cell | 20 | 40 | |
| Kept as round 3 | John's cost table, the knee at 5 %, caps 5 % and 8 %, the miss rule, the refusal, one rung a move, the fit | | |

The diet IS applied in the cell runs (`_run`: growth a bout x `keep`; `_setup`: keep = 1 - 0.12 per 1 % held, floor 0.4), in
the pro cells as in the amateur ones: STAY keeps 76 to 84 %, CUT 70 %, DOWN 40 %, UP 100 %. With the lever off the mean win
share moves 2.4 points (3 seeds).

**Step 0, the fit:** unchanged from round 3 (same seeds, no cut in it): 1.10 wins in 100 per 1 % from the stat split, 4.75 a
rating point, 0.40 rating points per 1 % in the exchanges, field offsets -5.3 amateur and -10.9 pro.

| Bar | Measured | |
| :--- | :--- | :--- |
| Each lever moves the result | size 4.6 points of win share (best choice changes in 6 of 10 cells with it off), diet 2.4 (2), drain 2.0 (4), rank 1.9 (4), miss 1.8 (0), refuse 0.6 (0) | met |
| No single choice best in more than 6 of 10 cells | STAY 4, CUT harder 4, UP 2, DOWN 0 | met |
| 4 or more cells clear of the noise | **7 of 10** (STAY 3, CUT 3, UP 1) | met |
| CUT harder in the leading group of at most 6 cells | 5 (the five pro cells; none amateur) | met |
| An amateur cell where CUT is clearly worse than STAY | 5 of 5 (+0.28 to +3.19 rungs, seed by seed) | met |

**RESULT: PASS.** Ladder place after twelve bouts (1 is the top; +- one standard error; the last column is CUT minus STAY seed
by seed, + is worse):

| Cell | STAY | CUT harder | UP | DOWN | Best | Inside the noise of it | CUT against STAY |
| :--- | ---: | ---: | ---: | ---: | :--- | :--- | ---: |
| puncher / amateur | 9.31 +- 0.36 | 12.50 +- 0.37 | 11.64 +- 0.36 | 12.20 +- 0.34 | STAY | - | +3.19 +- 0.23 |
| puncher / pro | 9.90 +- 0.33 | 8.66 +- 0.32 | 11.10 +- 0.28 | 9.36 +- 0.35 | CUT | - | -1.24 +- 0.21 |
| volume / amateur | 8.66 +- 0.40 | 10.68 +- 0.38 | 9.94 +- 0.40 | 11.06 +- 0.37 | STAY | - | +2.01 +- 0.23 |
| volume / pro | 8.43 +- 0.29 | 6.14 +- 0.24 | 8.90 +- 0.29 | 6.59 +- 0.31 | CUT | DOWN | -2.29 +- 0.25 |
| big chin / amateur | 9.03 +- 0.33 | 11.35 +- 0.43 | 9.09 +- 0.35 | 10.41 +- 0.35 | UP | STAY | +2.33 +- 0.29 |
| big chin / pro | 7.58 +- 0.29 | 7.09 +- 0.30 | 8.64 +- 0.29 | 7.81 +- 0.34 | CUT | - | -0.49 +- 0.15 |
| drained cutter / amateur | 9.84 +- 0.34 | 10.11 +- 0.37 | 8.86 +- 0.37 | 11.95 +- 0.33 | UP | - | +0.28 +- 0.13 |
| drained cutter / pro | 6.01 +- 0.28 | 5.99 +- 0.29 | 7.15 +- 0.29 | 6.33 +- 0.29 | STAY | CUT | -0.03 +- 0.04 |
| boxer-puncher / amateur | 8.40 +- 0.36 | 10.53 +- 0.42 | 9.61 +- 0.37 | 10.68 +- 0.38 | STAY | - | +2.13 +- 0.24 |
| boxer-puncher / pro | 6.99 +- 0.29 | 6.39 +- 0.28 | 7.88 +- 0.26 | 6.67 +- 0.28 | CUT | - | -0.60 +- 0.17 |

What it says, and how far to trust it:

1. **A hard cut now costs, and the cells separate.** Seven cells have a winner no other choice is within two standard errors
   of (round 3: none). The standard error of a place fell from about 0.5 to about 0.33 rungs with 40 seeds.
2. **On the same-day scale a hard cut is clearly a mistake, in every cell** (2.0 to 3.2 rungs worse for the four boxers who had
   a choice). But read HOW it loses: of the bouts actually boxed, CUT wins as many as STAY (48 to 56 % against 50 to 55 %). It
   loses on the SCALE: 1.55 to 1.8 scales missed in twelve, each a walkover loss, and 63 to 83 % of the runs end with the
   boxer moved up a class by two misses. The -8 % Stamina and -3 % power do not show in the win share over three rounds. So
   the amateur result stands on the miss slope past the safe line (20 points a 1 %, by Discipline), which is still my
   ESTIMATE (section 2), not on John's stamina table. A human coach would recognise the direction ("he boxes with the cut");
   the size of it is not sourced.
3. **On the day-before scale a hard cut clearly pays, in four cells of five** (0.5 to 2.3 rungs better than STAY; the fifth is
   the cutter, for whom CUT is STAY). It pays most for the volume man (wins inside the distance 18 % -> 37 % of bouts) and
   least for the big chin. Part of this is built in: the pro field rings 7.2 % over the line and STAY rings on it, so CUT is
   mostly "be the size the others are" (risk 7).
4. **So CUT harder is a real choice across scales and nearly a rule inside one:** never on a club scale, almost always as a
   pro. Its value depends on the moment only where the scale changes (turning pro, and a championship's three-hour scale,
   which the probe does not run). A critic should press this: inside one scale the player learns the answer once.
5. **Moving DOWN is best in no cell** and in the leading group of one (volume / pro, 0.45 rungs behind CUT). Against CUT in
   the boxer's own class it gives the same ring-weight gap (-3.1 % both, puncher and volume) for a rung, a 27 to 68 % chance
   he refuses, and 40 % of his training kept against 70 %. On the same-day scale it misses 1.4 to 3.1 scales in twelve in four cells of five. As
   sized, DOWN is a dominated option: a design question (what does the class below offer that walking bigger does not?), not
   a number to nudge.
6. **Moving UP is the answer for two boxers on the same-day scale:** the cutter (clear: 8.86 against 9.84 staying) and the big
   chin (level with STAY, 9.09 against 9.03). As a pro it is last in all five cells (6.5 to 11 % lighter than the field).
7. **A pro who cut does box short of it, a little:** 0.4 % of body dry at the bell on the average night after a 4 % cut, 0.6 %
   for the cutter moved down (6.2 % cut, past the knee: -8.1 % Stamina). No pro cell cuts 8 %, so the far end of the regain
   rule ("the day cannot give it back") is in the model and NOT exercised by these five boxers.
8. **The levers.** Drain moved more than in round 3 (2.0 points against 0.9; best choice changes in 4 cells) because CUT now
   sits past the free 2 %. Miss, diet, rank and refuse are measured on 3 seeds and are the size of the noise, as in round 3;
   refuse again barely moves the ladder (0.6 points, 0 cells).
9. **Moving up, against John.** One class up, pooled: knockout share of the wins 29 % -> 27 % (x 0.92), stopped 5.6 -> 6.5 in
   100 (x 1.16). John's ESTIMATE for two classes: x 0.88 and x 1.5.
10. **Not established:** the two remaining ties (volume / pro CUT or DOWN; big chin / amateur UP or STAY) and the cutter's pro
    cell, where STAY and CUT are the same boxer; anything over seasons (risk 4); the regain rule past a 6 % cut (point 7).

### 4.7 Round 5 (S536): the same kilos four ways, frame on, the field cuts, three scales

Run: 40 seeds x 12 bout slots a cell, 16 seeds for the policy table, 20 for the tape read, 3 for the levers, 6 for the fit;
85,774 bouts in 1,883 s. Full output: `docs/WEIGHT2_PROBE5.md`. The probe is three files now (the 500-line rule):
`tools/weight2_model.gd` (the scratch model), `tools/weight2_probe.gd` (the fit and round 4's tables),
`tools/weight2_round5.gd` (sections 5 to 8). Every size was set before the first result and none was changed after. The full
run was played twice: the first printed four broken text lines (a bare % in a format string); the second, with only those two
lines of code fixed, gave the same numbers line for line.

**What changed in the model** (nothing under `scripts/`):

| | Round 4 | Round 5 | Tag |
| :--- | :--- | :--- | :--- |
| Order of the kilos | diet first, water the rest | water first up to the free 2 %, then the diet up to its hold, then water | the task's rule |
| Scales | amateur hybrid (+0.5 %, a walkover), pro | club show (one hour, +0.5 %, the gap rule of `WeighGap`, nothing on the record), championship (three hours, +1.9 %, a walkover, weighed on each of three boxing days), pro | John SOURCED regains; the carry of 0.74 of the cost into the next boxing day is my ESTIMATE |
| Frame | the opponent's height and reach erased | drawn from the class boxed at (`AttrGen.body`), each division its own sheet; the fit takes the average worth of a class of frame out of a move | CODE for the draw; the fit measured that worth as nothing (below) |
| The field | rings 7.2 % over (pro) for free | each opponent took off 2 to 4 % (championship) or 6 to 10 % (pro, mean 8) and pays John's table; a cut worth 15 % of Stamina makes him a fader ("Fades", `AttrGen`); a club-show opponent weighs 1 % under the line | the spreads, the 15 % line and the 1 % are my ESTIMATES |
| New table | - | the same kilos (3 / 4 / 5 / 6 % over) by DIET, WATER, MIX or UP, nobody asked | the task's item 1 |

**Step 0, the fit:** size 1.00 wins in 100 per 1 % from the stat split, a rating point 4.79, so 0.42 rating points per 1 % in
the exchanges (round 4: 0.40). Field offsets -2.1 club, -2.6 championship, -7.5 pro (round 4: -5.3 and -10.9: the field that
pays for its cut needs less of a handicap). A cm of class frame measured -0.20 wins in 100, the wrong sign and inside the
noise of 360 bouts a setting: the game's fight night barely reads a class step of frame, so nothing was taken out of a move.

| Bar | Measured | |
| :--- | :--- | :--- |
| Each of round 4's six levers moves the result | size 3.9 points of win share (6 of 15 cells change), drain 2.3 (6), rank 1.9 (1), miss 1.4 (0), diet 1.0 (3), refuse 0.8 (0); new: field 2.3 (4), frame 0.8 (1) | met |
| No choice best in more than 9 of 15 cells | STAY 10, CUT 2, UP 2, DOWN 1 | **NOT met** |
| 6 or more cells clear of the noise | 10 (STAY 9, UP 1) | met |
| CUT harder in the leading group of at most 9 cells | 5 (four of them pro) | met |
| An amateur cell where CUT is clearly worse than STAY | 8 of 10 (+1.5 to +3.3 rungs) | met |
| Item 1: inside one scale the best policy changes with how far over he is AND with the boxer | club: 2 and 16 pairs; championship: 1 and 1; pro: 0 and 0 | met as written (read point 2) |
| Item 2: DOWN best or tied for a boxer who works off the jab | cutter / club (tied), cutter / pro (best), boxer-puncher / pro (tied) | met |
| Item 2: UP best or tied for the chin with no reach (the volume man, 3 cm short of his class) | no cell: 1.2 to 2.5 rungs behind | **NOT met** |

**RESULT: FAIL.** Broke: round 4's "no choice best too often" bar, and item 2 (frame). Ladder place (1 is the top):

| Cell | STAY | CUT harder | UP | DOWN | Best | Inside the noise of it |
| :--- | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher / club | 7.99 | 10.79 | 13.59 | 13.85 | STAY | - |
| puncher / championship | 9.28 | 12.57 | 12.88 | 12.98 | STAY | - |
| puncher / pro | 9.13 | 9.21 | 13.07 | 11.41 | CUT | STAY |
| volume / club | 10.51 | 12.13 | 12.13 | 12.49 | STAY | - |
| volume / championship | 10.26 | 12.21 | 12.79 | 12.82 | STAY | - |
| volume / pro | 8.54 | 8.41 | 9.65 | 8.79 | CUT | STAY, DOWN |
| big chin / club | 10.21 | 12.53 | 11.25 | 12.40 | STAY | - |
| big chin / championship | 10.51 | 12.71 | 11.57 | 12.45 | STAY | - |
| big chin / pro | 7.69 | 8.66 | 9.61 | 9.86 | STAY | - |
| drained cutter / club | 10.34 | 10.34 | 10.15 | 10.78 | UP | STAY, CUT, DOWN |
| drained cutter / championship | 10.84 | 11.15 | 10.00 | 12.95 | UP | - |
| drained cutter / pro | 6.60 | 6.51 | 7.42 | 6.46 | DOWN | STAY, CUT |
| boxer-puncher / club | 9.35 | 10.88 | 10.91 | 11.51 | STAY | - |
| boxer-puncher / championship | 9.47 | 12.11 | 11.54 | 12.50 | STAY | - |
| boxer-puncher / pro | 7.16 | 7.33 | 8.84 | 7.45 | STAY | CUT, DOWN |

Standard errors are 0.19 to 0.56 rungs (in the output). What it says, and how far to trust it:

1. **Round 4's pass did not survive an honest field.** In round 4 a hard cut clearly paid in four pro cells of five. Now that
   the pro field pays for the 8 % it takes off, CUT is clearly best in no cell: level with STAY in four pro cells, clearly
   worse for the big chin. Round 4's "cut harder as a pro" was mostly the free heavy field (its own risk 7, both critics).
   With two amateur scales and that, STAY wins 10 of 15 and is in the leading group of 14. The class card is close to
   "leave him where he is" for four boxers of five; only the drained cutter has a real question (UP on the amateur scales).
2. **Item 1 is met by the letter and not by the idea.** The best way to take the same kilos off is nearly one answer a scale:
   championship DIET in 19 cells of 20; pro WATER in 18 of 20, with no change by level or boxer at all; WATER and MIX are best
   in none of the 40 amateur cells. The club show's changes (UP 12, DIET 8) all come from one rule: a boxer still inside the
   gap of a class opponent (`WeighGap`: 5 kg over 65 kg, 2.5 kg under) is "carried", boxes in his own class 4 % bigger and
   pays nothing, so he wins; once outside the gap he diets. That splits the boxers by CLASS (the three over 65 kg against the
   two under), which here happens to line up with Stamina over and under 60. Stamina itself and Discipline 34 against 80
   flipped nothing: Discipline moves the chance of a missed scale (42 against 26 in 100 at 5 % over by water) but never the
   best policy. The championship's two flips are the big chin at 6 % over, alone. So: a rule a scale, plus a free ride at the
   club show that the model hands out by construction. This should be read as a fail of the brief's "one policy winning
   every cell is a rule" even though the written bar says met.
3. **Frame back on changes almost nothing.** With it off the win share moves 0.8 points and one cell's best changes. Moving
   DOWN is now in the leading group in four cells (round 4: one) and best in one, all for boxers who keep reach on the class
   below, three of the four as a pro. Moving UP is best only for the drained cutter, as in round 4, and for mass, not frame;
   the short-armed chin is 1.2 to 2.5 rungs worse a class up. The game reads a cm of reach at 0.25 on the long jab
   (`Duels.REACH_PER_CM`) and a class step is about 5 cm: too little against being 2 to 11 % the lighter man.
4. **The field's cut has a cost and no teeth.** A pro opponent who took off 9 or 10 % is HARDER to beat than the rest, not
   easier: 40.5 % wins against him, 47.1 % over all bouts; late rounds won 45.5 % against him, 50.1 % against the rest. He
   rings 8 to 9 % over the line and the fade word does not outweigh that. The lever still moves the ladder (2.3 points, 4
   cells), through the refit.
5. **Reading his cut off the tape, as wired here, loses.** Calling "Let your hands go" from round 3 when the read says 9 % or
   more costs 0.92 +- 0.13 rungs with a ranged read and 1.11 +- 0.15 with an exact one, against the corner left alone. Either
   that call is the wrong answer to a fader on the game's fight night, or the probe's copy of the corner (a replica of
   `BoutNight._box_out`) is weaker than the game's own. Not settled; nothing should be built on the read until it is.
6. **The three scales differ in how a cut is paid.** Club show: nothing goes on the record for a miss and no bout was lost,
   yet CUT is 1.5 to 2.8 rungs worse: he boxes 3.5 % dry an hour after the scale and wins fewer (puncher 56 % to 45 %). This
   answers round 4's risk 8 in part: the loss is in the ring here, not on the miss slope. Championship: 6.7 bouts boxed of 12
   slots (a loss ends the draw), CUT takes 1.0 walkover a run, and by the third day a cut past the free 2 % costs 2.29 times
   day one. Pro: 0.23 misses a run either way, a fine, nothing else.
7. **Moving up, against John:** knockout share of the wins x 0.86, stopped x 1.29 (his ESTIMATE for two classes: 0.88, 1.5).
8. **Kalli's PLAY 5 ("nothing pulls the player back on a Monday").** None of the four changes makes the week's diet a weekly
   decision: inside a scale the diet is set once (point 2). What the run does show is that the right setting differs by the
   NEXT scale: carry the weight to a club show inside the gap (no diet, all training kept), diet for a championship (2.5 % held
   is 3.6 weeks and 30 % of training gain), water as a pro. The smallest change that makes it weekly uses rules the map
   already has (the diet's pace of 0.7 % a week, training gain lost only while he holds, amateur bouts booked 1 to 2 weeks
   out): the walking weight drifts back when the diet is off, and Monday's card shows the next scale, the weeks to it and the
   weeks of diet it needs. Then each Monday is "start holding now for the championship, or stay free and take only club shows
   I can carry". No new system. NOT probed: the probe boxes one scale a run and the diet as a standing policy.
9. **True by construction, not measured:** the carried club-show boxer pays nothing (the gap rule has no price in the model);
   the club opponent weighs 1 % under his line; the carry of 0.74 a boxing day; the field's cut spreads and the 15 % fade
   line; the regain divisor of 8 %; no refusal in the policy table.
10. **Not done:** the round 4 critics' items 5 to 13 (the price of walking bigger, a clock on waiting, real walking weights,
    seasons, growth, tolerance with age, the promise). The drained cutter's CUT is still nearly his STAY (61.0 against
    60.8 kg). No critic was run on round 5.

## 5. Every menu it appears on

| Menu (file) | Shows | Wired to |
| :--- | :--- | :--- |
| Fighter Overview, BODY card (`DarkOverview.gd:438-443`) | Walking / natural / limit, the diet setting, the tolerance as a range, the class card between bouts WITH HIS ANSWER and its two reasons, and the three ways to push | `natural`, `diet`, `cut_tolerance` through `Knowledge.range_of`, the class move, `Loyalty`, `Promises` |
| Week board, Monday (`WeekBoard.gd:353-357`, the goal line `WeekData.gd:38`) | Three diet pills in place of Hold / Cut, the price beside this week's gains ("Lean: -18 % on what he learns") | `WeekPlan.week` (`WeekPlan.gd:302`) gain x the diet multiplier |
| Fight week modal, THE WEIGHT (`modals/FightWeek.gd:127-136`) | Water: None / Light / Hard, with what is back by the bell, the Stamina and tank it costs, and the miss chance as a range; the safe line marked | `bout["water"]` -> `bout["stale"]` and the bout-only Stamina, power and reading; `FightWeekPick.weight_way` proposes it |
| Fight prep, CAMP AND WEIGHT (`FightPrep.gd:189-192`) and the SCALE gauge (`Gauges.gd:47-49, 60-66`) | The forecast with the diet in it; the band from natural down to the limit; "Buy a nutrition plan for this camp" | `Sim.weigh_forecast`; the camp purchase |
| Ask panel (`AskPanel.gd:79-84`), offers | "Makes 60 with 1.1 % water" instead of "Weight at risk" | the same forecast |
| Tale of the tape (`TapeRows.gd:64-68`), versus | Both ring weights and the gap; the opponent's weight story as a row | ring weight both sides, `OppFile` |
| Weigh-in modal (`modals/WeighIn.gd:14-19`) | The scale, WHEN it is (an hour before, three hours, the day before), a miss and what it costs for this bout | `Bouts.weigh` + the miss roll |
| The Why after a fight (`FightWhy`), tank words (`BoutRules.tank_words :266`) | "the scale 9" as a sized line; "outweighed by 3 kg in the ring" | the tank part, the size gap |
| Roster and home rows (`RosterRow.gd:140-164`, `HomeRows.gd:196-202`, `FighterTile.gd:57-60`, `CoachCheck.gd:54-63`) | Kg to lose, the diet as a chip, "asks to move up", "said no to 65" | `weight`, `natural`, the ask, the refusal |
| Ladder (`WorldLadder.gd`, the regional ladder `Region.rankings`) | His class's table; where a move would put him | `ProLadder.division_for` reading the rewritten `limit` |
| 3D fight | Trunk and legs from ring weight against his frame (3.4) | one factor beside `ArmBuild.k` |

Golden path walk for the build: sign, set Lean, see the gain drop on Monday, book, Hard water, weigh in, box drained, read the
Why, ask for 65 on the BODY card, hear no, make the promise, box at the new class, see the ladder place.

## 6. Questions

Answered by the owner: men's 65 kg (Q-292), the refusal (Q-293), the 3D body (Q-294). Answered by John: nine of v1's ten.
Open, for the owner (scope only): one class under the lightest and over the heaviest per sex, so the end boxers have somewhere
to go. Open, for the critics: is the same-day amateur scale worth a new weigh-in time; is "wait" too cheap a way round a
refusal; should the tolerance-with-age line (no evidence) stay. From round 4: inside one scale "cut harder" has one answer
(never on a club scale, nearly always as a pro) - what makes it depend on the boxer and the bout; moving DOWN is best in no
cell - what should the class below offer, or should it go. From round 5 (FAIL, back to Claude): with a field that pays for
its cut STAY wins 10 of 15 cells - what should make leaving the class worth it; the diet-or-water question has one answer a
scale - is the weekly pull the NEXT scale (4.7 point 8); the carried club-show boxer rides free - what does carrying cost;
frame is too weak to send anyone up - should reach count for more, or the frame claim go; the tape read loses as wired.

## 7. Risks and what is not proven

1. Five slopes are still ESTIMATES (section 2, last paragraph). John's game table (the per-1 % costs) is his reading of small
   studies (7 to 14 people), not a counted curve.
2. I did not open John's sources; his note says three are unopened by him too (CHECK), none used here.
3. The probe puts size and drain on our boxer's stats and the opponent's rating (the opponent is the mirror); the build reads
   both sides in `Duels.facts`.
4. Natural-weight growth, the shrinking tolerance, the diet's coach slot, the boxer's ask, the promise and the Knowledge read
   are designed and NOT probed: they act over seasons, and the probe plays twelve bouts.
5. `Knockdowns` still stops pro bouts on the amateur count rule on main (four counts in the bout, `Knockdowns.gd:5`); the fix
   (`pro_rules`) is on branch `s535/dmgfix`, not merged at this commit. The pro cells' stoppage shares will move when it lands.
6. Reach and height follow the class LIMIT (`AttrGen.body`): a boxer who moves up keeps his frame and meets taller men. Size is
   then counted twice (frame and mass) unless the mass term is fitted with reach in the model, as the probe's step 0 does for
   mass alone (the probe strips the opponent's height and reach).
7. The Data boxers walk 1.5 to 2.3 % over their class; real amateurs 3 to 5 % (ESTIMATE) and pros ring 7 % over (SOURCED). On a
   pro table our boxers are the small ones until the diet and the class move are built. The probe's pro cells show exactly that.
8. Round 4's amateur result (a hard cut is clearly worse in 5 of 5 cells) comes through missed scales, not through the fight:
   it rests on the miss slope past the safe line, my ESTIMATE. With a gentler slope the amateur CUT would sit nearer STAY.
9. "Cut harder" assumes the boxer can carry 5 % more body than the Data boxers walk at (69.5 kg for Samira's 65.9). The probe
   gives it to him as a standing policy at no price but the diet; the build has to say where the mass comes from (Eat free
   over weeks, growth) and what it costs while he gets there.
10. A pro's regain share (0.9; 0.81 / 1.25) divides John's SOURCED regain by the 8 % guidance cut, which is not the measured cut
    of those boxers. No cell cuts past 6.2 %, so the rule's far end is untested.
11. Round 5: the club show's "carried" boxer (inside the gap of `WeighGap`) pays nothing in the probe, and that alone makes
    item 1's bar. The build must price carrying (he is the bigger man by the other corner's leave) or the club show has one answer.
12. Round 5: the field's cut (2 to 4 % championship, 6 to 10 % pro, drawn evenly), the 15 % fade line, the club opponent 1 %
    under the line and the carry of 0.74 a boxing day are my ESTIMATES. A hard-cutting pro opponent came out harder to beat.
13. Round 5: frame is on and worth 0.8 points of win share; the fit could not measure a class step of frame (wrong sign, noise).
    Section 3.4's size term and risk 6's double count are therefore unchanged, and "UP for the chin with no reach" is unproven.
14. Round 5: the tape read made results worse through the probe's copy of the corner (`BoutNight._box_out` replica calling
    "let_go" from round 3). The copy is not checked against the game's corner bout by bout.
15. Round 5: the policy table runs 16 seeds a cell (standard errors 0.3 to 1.0 rungs): several of its bests are ties.
16. Sections 0, 3 and 5 still describe the round 4 design. Round 5's findings (points 1 to 5 of 4.7) are not folded into them.
