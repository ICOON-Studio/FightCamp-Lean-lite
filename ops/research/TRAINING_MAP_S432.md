# TRAINDEPTH1: the training map, v6.1 (S433)
> NAME (operator Q-190, S434/S435): "Just rename it 'gym sponsorship', the club pays". What earlier maps and drawings call the PAID SEAT is the GYM SPONSORSHIP here (short: sponsorship): the CLUB pays its own amateur for a 4-week block. It is not a Sponsor deal (Club > Money), where an outside business pays the club; no screen may mix the two words.


The owner's question: "how deep are the training mechanics ? have critics rated them ?"
Round 1: two blind critics scored the training as built 5 and 5 (`docs/mockups/s432/critics/train_coach_review.md`, `train_sim_review.md`).
Round 2 (map v2): 7 and 6. Round 3 (v3): 6.5 and 7. Round 4 (v4): 6.5 and 6.5. Round 5 (v5): 6.5 and 7. Round 6 (v6): 7 (a strength and
conditioning coach who plans professional camps, `docs/mockups/s433/critics/tr6_1_0_review.md`) and 6.5 (a lead systems designer of a sports
management series, `tr6_1_1_review.md`). The bar is 7 from both.
v6.1 KEEPS v6's five changes (the load buys fitness, no dead zone, Stamina continuous, the camp is the load, a career arc) and adds what both round-6
lists asked that makes one choice change something the player sees later: BLOCKS THAT BUILD ON EACH OTHER (T35), TWO ENGINES (T36), MORNING RULES
(T37), HOW EACH FIGHTER RESPONDS and AGE (T38), HEAD CONTACT OVER A SEASON (T39), THE LAST DAY'S WATER for professionals (T8), THE GOAL IN FOUR BANDS
(T25), HARD AIMED WHERE IT PAYS with a pass line (T1), ANA ON THE SAME RULES (8c) and the GATE TABLE before any pixel (section 10). Every point of both
lists is answered here or in REJECTED (section 12). The code claims the critics proved stale are fixed (LiveRound 456 lines; Ana's class kinds are not
in the code; the F2b test reads today's shares).
Scope: four fighters (Lucy the professional, two amateurs, Ana the grappler), amateur to a first professional fight.
Builds on, never rewrites: CLUBWEEK v4.1 (`ops/research/CLUBWEEK_MAP_V41_S432.md`), the RPG layer v3 (`RPG_LAYER_MAP_S432.md`), the fight link
map (`FIGHT_LINK_MAP_S432.md`), the mat plan (`MATPLAN_MAP_S433.md`) and the integration (CORE_LOOP). Where v6.1 changes a sister rule, it says so in
6b (one line each). No second meter: the response is Known's (C12), the block's aim is Hard's aim, head contact feeds CeilingShift (C23).
WORDS (integration C1, C2, C3, C13): "You" is the head coach, the player. "Coach" is the hired assistant coach. STAMINA is the ability on every
row, line and goal; CARDIO is the profile group (Stamina, Recovery, Heart). THE TANK is the energy at the first bell (Combos.TANK 100), printed
"Tank at the first bell"; LEGS is the profile group (Speed, Footwork, Flexibility), never the energy. LOYALTY is the bond, MOOD is this week.
A move under 30 is "Learning" (MoveMastery.WORDS, S429; the pack's "Raw" is stale). Sizes: 0-100 for what a fighter is, N in 100 for a chance,
exchanges of the bout for what a choice does (after LEVERS1); a multiplier shows as a word (quick, slow) with its size on hover. Game text never
says he, she, her or him.
Drawn: `docs/mockups/s432/training_v2.png` (the Training tab, Samira Khan, Monday 16 Feb, week 7, a BASE week, the hand rested, on a sponsorship block).
TAGS on every effect: CODE = in the game's code today (file and name given); WEEK = designed in an agreed sister map, not built; NEW = new in
this map. ESTIMATE = a number a probe sets.

## 0. THE FOUNDATIONS: today's code defects, fixed before any training feature
Every price on the tab reads these. Each is one small task with ONE owned file set and ONE unit test red on main today. None adds a screen.
Order: F1, F2a, F2b, F3, F4, F8 (F2b, F4 and F8 all own WeekPlan.gd: one after the other), F5, F6, F9, F10; then F7. This map's F-numbers are its
own; CORE_LOOP section 5 step 0 carries the same tasks by id and adds DOSE1, CAMPLOAD1, CALLSPREAD1 (6b).
| Task | The defect, as the code does it today | The fix | Owned files | The unit test, red on main |
|---|---|---|---|---|
| F1 REST1 | REST MORNINGS DRAIN STAMINA. WeekPlan.day gives a rest morning an `attr_gain`; Sim.step_day (~213) hands it to Attrs.train, which adds it to Recovery AND takes the same off Stamina (Attrs.gd ~329-334, "The same points come off stamina") | Delete the take-off: rest adds Recovery and nothing else | `scripts/rules/Attrs.gd` (two lines removed) | `tests/rest_keeps_stamina_test.gd`: the code's taper week stepped through WeekPlan.full_day and Attrs.apply_session; Stamina ends where it began, Recovery up. Red on main: Stamina falls |
| F2a CEIL14 | ONE CEILING FOR SEVEN, NONE FOR THREE. Sim.week_ctx passes one `pot`; Recruit.ceiling covers the old seven only; Footwork, Inside, Flexibility have none | Recruit.ceiling_of(f, ability) for all 14: pot + the class bias of the ability's parent (+6 / -6; none for Footwork, Inside, Flexibility) + half the archetype's centred tilt (AttrGen.tilt_of), held inside -8 to +8 of pot and never under now + 2; THEN + the fighter's ceiling shifts (T34, CeilingShift, RPG); THEN the one hold, Explosiveness at most Strength + 10 (T35). Samira (out-boxer, pot 68): Footwork 72, Speed 76, Defence 70, Timing 69, Stamina and Durability 67, Recovery 66, Inside 63, Explosiveness 62 held at 60 by Strength 50 | `scripts/rules/Recruit.gd` (one function, ~26 lines; file 123) | `tests/ceiling_shape_test.gd`: Footwork, Inside, Flexibility get ceilings; an out-boxer's Footwork above its Inside; a slugger's Explosiveness above its Speed; a shift of +2 on Legs lifts Footwork's ceiling 2; Strength 50 holds Explosiveness at 60. Red on main: no function |
| F2b GAIN14 | THE GAIN IS WORKED ON THE OLD STAT (preview_gain on power, technique... against one pot, then shared among the children) | Each session names its abilities with a SHARE (below); each ability's gain = share x SESSION_SHARE x the pace's gain x tired x coach factor x head-coach edge x room(ITS ceiling, ITS value) | `scripts/rules/WeekPlan.gd`, `scripts/rules/Attrs.gd`, `scripts/state/Sim.gd` (week_ctx builds `ceil` for 14) | `tests/gain_each_test.gd`, on TODAY'S shares (the table's first column): (a) at equal room each ability gets today's gain; (b) one heavy bag gives Strength with 15 points of room more than Explosiveness with 2. Red on main: (b) equal |
| F3 CARDIO1 (with C3) | STAMINA IS NOT ONE NUMBER IN THE RING. The round-3 fade (LiveRound 65, BoutRules.play_round ~208, BoutRead 325), each round's energy cost (Combos.spend_factor) and the minute's refill (Combos.refill, both passed from BoutNight 302 and BoutRead 187) all read the OLD conditioning, the mean of Stamina and Recovery; the fade is a cliff (OWN_FADE 1.0 under 64, 0 at 64); FighterGoal keys are the old seven and write a trust_delta nothing reads | ONE ROW, ONE NUMBER, AS A SLOPE: the fade reads Stamina, OWN_FADE x clamp(0.25 x (64 - Stamina), 0, 2) (64: none; 62: 0.5; 60: 1.0; 56 or under: 2); spend_factor reads Stamina, refill reads Recovery; NIGHT_LINES' key "stamina"; FighterGoal's keys move to the 14 abilities and its trust_delta is deleted (C1); FADESHARE (section 10) holds the share of fading amateur bouts within 5 points of today's | `scripts/state/LiveRound.gd` (456 since 6ee496fc), `scripts/rules/BoutRead.gd` (497): one-line swaps, no growth; `scripts/rules/BoutRules.gd`; `scripts/state/BoutNight.gd` (one argument); `scripts/rules/FighterGoal.gd` | `tests/cardio_line_test.gd`: Stamina 64, Recovery 50: no fade; Stamina 62: fade 0.5; Stamina 50: 2; spend_factor changes with Stamina and not Recovery, refill with Recovery and not Stamina; a goal "Stamina 63" is met at Stamina 63. Red on main: Stamina 62 gives 1.0 and spend_factor follows Recovery |
| F4 LOADWORK1 | THE INJURY HOURS IGNORE EFFORT (WeekPlan.hours: minutes x the pace's load, no effort; TrainingLoad.SETTINGS and START_HOURS feed a new fighter's usual, so every first week reads 0.8) | ONE LOAD UNIT, WORK: effort x minutes x the pace's load, as tiredness uses it, mornings and evenings. 100 work = Coach's base week (2,607 effort-minutes). Work feeds tiredness, the usual (the 42-day average), the ratio and the injury chance, re-anchored so Coach's base week reads today's 1.04 in 100. Clock time beside it | `scripts/rules/WeekPlan.gd`, `scripts/state/Injuries.gd`, `scripts/rules/TrainingLoad.gd`, `scripts/rules/InjuryRoll.gd` | `tests/load_work_test.gd`: the card's work = Injuries.week_work; a sparring night adds more injury work than 30 min of slip rope; a new fighter's first Coach's week reads ratio 1.0. Red on main: 0.8 |
| F5 TANK1 (inside the fight link map's NOCAMP1) | TWO SCALES AND A DEAD ZONE. BoutRules.stale_energy: 2 energy a point of tiredness over 50, at most 20, 0 with no camp; under 50 costs nothing | ONE TANK, NO DEAD ZONE: energy off at the first bell = 0.3 a point of tiredness from 20 to 50 (at most 9; ESTIMATE, FITLEGS1) + 2 a point over 50 (code, at most 20) + weight left to the day + your own last bout (7 days -8, 14 days -4); all at most 25; on every bout, camp or not; the other corner's Tank by the same rule | `scripts/rules/BoutRules.gd` (tank() in place of stale_energy; NOCAMP1 swaps the call in BoutNight._peak) | `tests/tank_scale_test.gd`: tiredness 20: 0 off; 35: 4.5; 50: 9; 60: 25 (capped); the same amateur at 60 is 25 down with or without a camp. Red on main: 35 gives 0 |
| F6 STANDDOWN1 | NO STAND-DOWN FROM CONTACT (only a stoppage loss suspends, KO_DAYS 30) | After every bout, no sparring for 5 / 10 / 21 days by the head band the bout left (fine 55+, hurt 35-55, critical under 35); a stoppage keeps its suspension; SPAR ANYWAY in fine and hurt at a head-knock roll (2 / 6 in 100, ESTIMATE) | `scripts/rules/StandDown.gd` (NEW, ~40), `scripts/rules/PadWeek.gd` (two lines; 464), `scripts/state/Injuries.gd` (one line) | `tests/stand_down_test.gd`: damage 25 (head 45, hurt): no sparring for 10 days, one on day 11. Red on main: day 5 |
| F8 DOSE1 | THE LOAD BARELY BUYS FITNESS. Hard multiplies only the mornings it turns Hard, by 1.3 (WeekPlan.INTENSITY); over 7 weeks Hard against Normal differs by about 0.06 Stamina (tr5_perf) | (a) THE PACE'S GAIN: Hard 1.3 -> 1.6 (ESTIMATE; Light 0.6, Normal 1.0 kept; the load for tiredness stays 0.6 / 1.0 / 1.5). (b) THE BLOCK'S DOSE: an ability trained on 3 or more mornings of a week at Normal or Hard gets x1.3 on that week's morning points (ESTIMATE). (c) HARD LAYS ON THE AIM: Coach turns Hard the mornings that dose the AIM (T1: default the row with the most worth x test x room x response), never two Hard running, +1 pad night | `scripts/rules/WeekPlan.gd` (INTENSITY gain; the dose count in week(); the Hard lay, ~25 lines) | `tests/dose_test.gd`: one fighter, 7 build weeks, Hard kept against Normal kept: Hard's points on its aim at least 1.6x Normal's, its peak tiredness and injury chance higher. Red on main: about 1.1x |
| F9 CAMPLOAD1 (C15) | THE PROFESSIONAL HAS TWO HARD BUTTONS. BoutRules.PROTOCOLS: camp Light / Standard / Hard, all $0, focus up to x1.35, a night edge up to +1.0. ALSO (Q-186): Roster.turn_pro leaves `day_job` set (GymSpend.DAY_JOB_GAIN x0.85 stays) | THE CAMP IS LOAD BLOCKS (T33): PROTOCOLS' levels become one "Camp" row (focus 1.0, edge 0); the night edge only from PEAK CAMP met = readiness +1 (FL M6); turn_pro clears `day_job` | `scripts/rules/BoutRules.gd`, `scripts/ui/modals/Camp.gd` (the level pick goes), `scripts/state/Roster.gd` (one line) | `tests/camp_load_test.gd`: protocol 1 and 3 give the same bout power; a camp's edge is 0 without PEAK CAMP; after turn_pro `day_job` is false. Red on main: protocol 3 gives +1.0 |
| F10 CALLSPREAD1 | A CALL'S GRADE IS A STEP. Exchanges.grade: the mean of the call's needs reads Poor x0.3 under 50, OK x0.6 to 62, Good x1.0 from 62 | The OK-to-Good step spread across 56 to 62 (0.067 a point); the WORD stays (OK until 62) | `scripts/rules/Exchanges.gd` (grade(), 3 lines; 372) | `tests/call_spread_test.gd`: mean 55.9: 0.6; 59: 0.8; 62: 1.0; 49: 0.3; the word at 61 is OK. Red on main: 59 gives 0.6 |
| F7 PACE1 (a probe, after the rest) | THE DRAWN DATES WERE FASTER THAN THE GAIN RULE | All four fighters 12 weeks at Coach's week and at a focused load on the fixed engine. PASS LINE (tr6_1_1): Hard kept on a FAST row ends at least +2 whole points over Normal kept by the next target; else the load is three options (Easy, Normal on an aim, Sharpen). At least 3 of the 8 top rows reach their next line in the season at a focused load, else the named shares rise (Footwork drills 1.0 -> 2.0). The squad's season points at Coach's week stay within a fifth of today's (Risks: the stacked multipliers). Sets DOSE1's 1.6 and 1.3 | cloud probe, pure | its table (section 10); no date printed before it |

THE SHARES (F2b), TODAY in the code (Attrs.SESSION_ATTRS; the F2b test reads this column) and AFTER MORNINGS1 (T36, a task after F2b):
| Session | Today (CODE) | After MORNINGS1 (NEW) |
|---|---|---|
| Roadwork | Stamina 2.0 | Recovery 1.5, Stamina 0.5 (T36) |
| Intervals | Stamina 2.0 | Stamina 2.0 (v6's extra Recovery 0.5 dropped) |
| Heavy bag | Strength 1.0, Explosiveness 1.0 | Explosiveness 1.0, Inside 1.0 |
| Strength circuit | Strength 2.0 | kept |
| Speed bag / Slip rope / Neck work / Mobility | Speed / Defence / Durability / Flexibility 1.0 | kept (Mobility folds into Rest) |
| Shadow | Accuracy 2.0, Footwork 0.5 | kept |
| Rest | Recovery 1.0 (after F1, nothing off Stamina) | Recovery 1.0, Flexibility 0.5 |
| Pads (evening) | Accuracy 1.0, Timing 1.0 (a camp's pad night: the focus's children 1.0 each) | kept |
| Sparring (evening) | Fight IQ 1.0, Composure 1.0, Timing 0.5, Defence 0.5, Inside 0.5 | kept |
| Footwork drills (NEW morning, T3) | none | Footwork 1.0 (ESTIMATE; PACE1 may raise it to 2.0) |
THE PACE IN ONE LINE (to check every date): a morning gives an ability share x 0.2 x the pace's gain (Light 0.6, Normal 1.0, Hard 1.6) x the coach
factor (0.5 + 0.007 x the area's rating: Coach 0.78; you +48%, 0.89; alone 0.6 x the mood rate, 0.48) x room ((ceiling - now) / 25, held 0.10 to
1.25) x1.3 when the ability has 3+ mornings that week x the response of its Known group (T38) x the age (T38) x1.2 in a SPECIFIC week after a BASE
(T35); x0.6 after a day at 80. Samira's Footwork 57 of 72 (room 0.6, Skills quick x1.2, age x1.1): one coached Hard drill +0.20 (+0.25 with the dose);
Normal's one alone drill +0.08.

## 1. What v6.1 changes, in one line each
1 BLOCKS THAT BUILD (T35): each build block on the strip is BASE or SPECIFIC with its own aim; a SPECIFIC week after a BASE in the last 4 earns x1.2;
  Explosiveness's ceiling is held at Strength + 10. The professional's camp: BUILD = BASE, PEAK = SPECIFIC, TAPER = Sharpen.
2 TWO ENGINES (T36): roadwork builds Recovery (the refill between rounds and the night's clearance), intervals build Stamina (each round's cost, the
  fade). A BASE block's roadwork lowers next block's tiredness, so its Hard fits under the lines.
3 MORNING RULES (T37): four standing toggles set on Monday (the day after 72+: Hard runs Normal; after hard sparring: rest; a third hand day: shadow;
  mood Low: the week runs Easy); they fire without stopping the clock, on the chart and in the review; Coach runs Coach's rules.
4 HOW EACH FIGHTER RESPONDS (T38): one hidden word per Known group (slow, normal, quick), forecasts as ranges until Known opens it; an age chip on
  the gain (x1.1 under 23 down to x0.7 from 32); discipline's existing lines on the header.
5 HARD AIMED WHERE IT PAYS (T1): the default aim is the row with the most worth x test x room x response; the popover lists WHERE HARD PAYS MOST in
  whole points against Normal by the target; the headline is redrawn on Footwork (57 -> 60 on Hard, 58 on Normal: Jab and move reaches Good).
6 PLAIN CARDS (T1): "82% of a usual week", three numbers a card (the aim at the target, injury in 100, the Tank at the first bell), the rest on hover.
7 THE GOAL IN FOUR BANDS (T25): met +10, close (within 0.5) +3, short (within 1) -5, missed -20: no decision stands on a decimal.
8 HEAD CONTACT (T39): hard sparring rounds in 8 weeks; past 48, Durability's ceiling -1 (a second CeilingShift trigger).
9 THE LAST DAY'S WATER (T8): professionals on a day-before scale may leave up to 2% to water, priced in the Tank; a same-day scale forbids it.
10 ANA ON THE SAME RULES (8c): class kinds DRILL / POSITIONAL / HARD ROLLS / FILM in the one run, doses, ceilings, response; each feeds a named
  mat-plan line (MATPLAN, Q-188).
11 THE GATE BEFORE THE PIXELS (section 10): the probe table with its bars and the cut each failure makes; no Cursor brief before it is filled.

## 2. The idea in twelve lines
1. ONE LOAD, CARRIED: Easy, Normal, Hard on an aim or Sharpen per fighter; priced against the usual, injury, tiredness to the bell, the goal and the
   block to the next target, all from one run. Hard buys real points on its aim, at a real price, and the card says where it pays most.
2. BLOCKS IN ORDER: a BASE block makes the SPECIFIC blocks after it pay more; Strength holds Explosiveness's ceiling. The season has a shape.
3. TWO ENGINES: roadwork for Recovery (refill, the night's clearance), intervals for Stamina (each round's cost, the fade).
4. FITNESS IS THE ABILITIES; TIREDNESS IS THE TANK. Fresher always helps a little; tired past 50 hurts a lot.
5. SHARPEN, NOT REST: the taper and the deload keep the pace and cut the sessions; nothing fades in them; the fight week earns "sharp".
6. RULES, NOT STOPS: the week reacts to the morning by rules you set on Monday, each reading a number on screen.
7. FADE BY DOSE: each ability is kept by one session in its window (Speed a week, skills 10 days, Stamina and Strength 14 days).
8. ROOM TO GROW, AND HOW THEY TAKE IT: each ability grows by its own room, its group's response, the fighter's age; ceilings move after named events.
9. SLOPES UNDER LINES: every row names the next thing a point changes in the ring, and what the points under it already buy.
10. THE OPPONENT SORTS THE BOARD; the body talks first (niggles from your load, a stand-down after a bout, head contact over a season).
11. WEIGHT TO THE LAST DAY, and the weigh-in's hour; a professional's last day can be water.
12. A CAREER YOU CAN READ: the strip ahead, the 13 days to the bell, the trend behind, the direction, the ceilings that moved, the responses learned.

## 3. The training as built (traced in the code)
| Part | What the code does | Where |
|---|---|---|
| Mornings | 10 sessions; each a fifth of a focused week (SESSION_SHARE 0.2) x the pace's gain Light 0.6 / Normal 1.0 / Hard 1.3; x0.6 at tiredness 80+ | WeekPlan.SESSIONS, INTENSITY, TIRED_GAIN |
| THE GAIN (DEFECT, F2b) | worked on the OLD stat against one pot, then shared among the children | WeekPlan.day, full_day; Attrs.train |
| THE DOSE (DEFECT, F8) | Hard only x1.3 on the mornings it turns Hard; nothing for training an ability on more days | WeekPlan.INTENSITY |
| REST (DEFECT, F1) | a rest morning adds to Recovery and takes the same off Stamina | Attrs.train (~329-334), Sim.step_day (~213) |
| One potential (DEFECT, F2a) | one `pot`; Recruit.ceiling (old seven) read only by RecruitPanel; Footwork, Inside, Flexibility have none | Sim.gd 120, Recruit.ceiling |
| THE WEEK'S HOURS (DEFECT, F4) | minutes x the pace's load (0.6 / 1.0 / 1.5); evenings at face value; no effort | WeekPlan.hours, Injuries.week_hours |
| Tiredness | effort x minutes x the pace's load / 44 a point; the night keeps 0.87 - 0.003 a point of Recovery over 55 (held 0.70 to 0.95: Recovery 50 keeps 88.5%, 60 keeps 85.5%); 80 = overreached | WeekPlan.day, full_day, fatigue_keep |
| Coach's base week | 2,607 effort-minutes, 7.97 h | WeekPhase.WEEKS, PadWeek |
| The usual load | an average over about 42 days (0.1535 of the gap a week) | TrainingLoad.next_chronic |
| Injury | 1.3 in 100 a 10 h week, x hours; ratio x1 to 1.3, rising to x3 at 1.5; x1 to x3 by the week's peak tiredness from 72 to 80; hand 40, ribs 30, strain 30 | InjuryRoll.training_chance, load_mult, fatigue_mult |
| The Tank (DEFECT, F5) | stale_energy: 2 a point over 50, at most 20, 0 when camp.protocol < 1 | BoutRules.stale_energy, BoutNight._peak 108 |
| Energy in the ring (DEFECT, F3) | each round costs (18 + punches) x spend_factor(1.2 - 0.4 x conditioning/100); the minute refills 52% of the fast debt (60% of what was spent) x (0.8 + 0.4 x conditioning/100) | Combos.round_spend, spend_factor, refill, after_round |
| The fade (DEFECT, F3) | -1 power from round 3 when the mean is under 64; 0 at 64 | LiveRound 65, BoutRules.play_round, BoutRead 325 |
| Calls (DEFECT, F10) | graded on the mean of their needs (Jab and move: the jab and Footwork); Good 62, OK 50, Poor; Fight IQ 65 finds the answer | Exchanges.CALLS, grade, IQ_FINDS |
| The camp (DEFECT, F9) | PROTOCOLS Light / Standard / Hard, all $0, focus x1.1 / 1.2 / 1.35, night edge +0.25 / +0.6 / +1.0 | BoutRules.PROTOCOLS, camp_power, camp_evening |
| Day job | an amateur off the stipend gains x0.85; turn_pro does not clear `day_job` | GymSpend.gain; Roster.turn_pro |
| After a bout (MISSING, F6) | only a stoppage loss suspends (30 days) | InjuryRoll.ko_days, Injuries.after_bout |
| Age | every fighter has an `age` (Lucy 21, Ana 22, Samira 18); the world's professionals age, peak and retire (WA.PEAK_AGE_PRO); no gain reads it | Data, NoGi.athlete, Matchmaking |
| Known | three groups, BODY (Strength, Explosiveness, Speed, Stamina, Recovery, Flexibility), SKILLS (Accuracy, Timing, Defence, Footwork, Inside, Fight IQ), FIRE (Durability, Composure, Heart); ranges narrow by exposure; called by no script yet (KNOWN0) | Knowledge.gd |
| Ana's mat week | 3 classes drill the syllabus move closest to owned (3.2 a week); the classes add cardio 0.6 and strength 0.3 a week toward one BODY_CEIL 90; no class kinds | NoGi.DRILL_GAIN, train_body, body_gain |
| The taper; while injured; fade of moves; the move ceiling; worth of a point | as v6: taper Light with rest days; injured: every session rest, gains x0.25; moves -0.75 mastery a week not drilled; move top 40 + 0.4 x Technique + 0.2 x Fight IQ; Attrs.VALUE (Defence 0.090, Footwork 0.085, Speed 0.080, Explosiveness 0.070, Timing 0.060, Durability and Inside 0.055, Strength and Stamina 0.040, Accuracy 0.030, Fight IQ 0.025, Recovery and Composure 0.020, Flexibility 0.015) | WeekPhase, Injuries.gain_mult, MoveMastery, Attrs.VALUE |
| Coached quality; the goal; the ask; causes; habits; weight | CoachAreas lifts; FighterGoal (met mood +10, missed -20); PushBack (discipline under 50; peaks 68 and 75); WeekCause; HabitFix 6 power where punished; kcal = MET x kg x hours, Cut -500, TAPER_KG | as named |

## 4. Where training is decided (one place each)
| Decision | Screen | Why there |
|---|---|---|
| Who gets the pad places, coached mornings and the sponsorship; the sparring pair and setting (C17, with the head-contact chip); the club twist; the season target | Fighters > Club week (WEEK) | shared between the four |
| The LOAD (Easy / Normal / Hard / Sharpen, carried; in a fight week Easy, Sharpen or Normal); Hard's aim; the MORNING RULES; morning exceptions; each pad place's card; the diet and a professional's last-day water; the deload; the niggle and injury answer; spar anyway; Coach runs this fighter | Fighter page > Training (this map) | one fighter only |
| Each build block's EMPHASIS (BASE / SPECIFIC) and AIM; a deload's place | the season strip on the Training tab (T35) | one fighter's season |
| A professional's camp: its length, focus (= the PEAK block's aim), partner, film | the camp card (T33) and the strip | one fighter |
| The build direction (C22, RPG 12) | Character tab (the Training header shows it) | one fighter |
| Ana's class kinds and the drill | the grappler's page (8c) | one fighter |
The Training tab shows shared slots LOCKED "change on Club week". Nothing is decided twice. The fight-week words Rest up, Tick over, Train through
are retired (C5): the LOAD is the one set of words.

## 5. The mechanics
Foundations first (section 0), then T1 (the load), T35 (blocks), T36 (engines), T14 (the Tank), T15 (fade), T16 (ceilings), T38 (response): every
price on the tab reads them.

### T1. ONE LOAD A WEEK, CARRIED, AIMED WHERE IT PAYS (changed in v6.1)
- WHAT YOU DECIDE: per fighter: EASY, NORMAL, HARD or SHARPEN, carried week to week (a fight week is laid as Sharpen, a rest block as Easy; in a
  fight week Hard is not offered). HARD NAMES ITS AIM; the aim is the BLOCK's (T35), set once for the block on the strip or from the popover.
- THE DEFAULT AIM (NEW, tr6_1_0): the row with the most Attrs.VALUE x the opponent's test (T18) x room x the response (T38); a ceiling or response
  still a range is rated at its LOW end. Samira: Footwork 0.085 x 1.3 x 0.6 x quick 1.2 = 0.080; Defence 0.090 x 1.0 x 0.60 (66, the low end) x 1.2 =
  0.065; Timing has no morning (pads and sparring); Stamina 0.040 x 0.8 x 0.18 = 0.006. Hard's aim: Footwork.
- WHERE HARD PAYS MOST (NEW, the Hard popover, tr6_1_1): the top rows, each with its whole points by the target on Hard against Normal and the line
  it reaches. Samira, by the regional (Sat 4 Apr):
| Aim | On Hard (Normal) | What it reaches |
|---|---|---|
| Footwork (fast, Kayleigh tests x1.3) | 60 (58): +2 | Jab and move Good (the mean with the jab 64 reaches 62) |
| Defence (fast, ceiling 66-74) | 54 (52): +2 | Hands up still under 56: no line yet |
| Stamina (slow, the goal) | 64 (63): +1 | the goal met (mood +10, not +3); no round-3 fade at the regional |
  So the aim is a real pick: what the regional's names test, or the goal and its mood. A SLOW row shows its smaller number honestly.
- THE LAYS (BASE week, the hand rested; work: 100 = Coach's base week):
| Load | How Coach lays it | Samira's week | % of the usual 92 |
|---|---|---|---|
| EASY | every morning Light; 2 pad nights; 1 sparring | work 59 · 5 h 55 | 64% |
| NORMAL | Coach's week; one Hard morning on a build week | work 75 · 5 h 55 | 82% |
| HARD on Footwork | footwork drills Hard Mon, Wed, Fri (never two running); +1 pad night (Tue) | work 98 · 7 h 30 | 106% |
| SHARPEN | about half the sessions, every one at Hard pace; pads on half the nights; no sparring | work 43 · 2 h 50 | 47% |
- THE NORMAL BASE WEEK ADDS UP: Mon slip rope Normal 120 effort-minutes, Tue footwork drills Normal 150, Wed roadwork Hard 337.5, Thu strength
  circuit Normal 240, Fri and Sat shadow Light 72 each, Sun rest; evenings Mon and Wed pads 375 each, Thu sparring 210. 1,951.5 = work 75.
- THE HARD WEEK ADDS UP (aim Footwork): Mon drills Hard 225, Tue roadwork Normal 225, Wed drills Hard 225, Thu strength Normal 240, Fri drills Hard
  225 (rule 1 runs it Normal, 150: T37), Sat shadow Light 72, Sun rest; evenings Mon, Tue, Wed pads 375 each, Thu sparring 210. 2,547 = work 98 as
  laid. A skill aim is a cheap Hard (drills are RPE 5); Hard on Stamina in a SPECIFIC week (intervals Hard x3) is about 109 and on 9 Mar crosses
  the safe line (1.35 of a usual of 81). The Tuesday pad night is a pad place from Club week (Lucy goes short there).
- THE CARD IN PLAIN WORDS (NEW, tr6_1_1): the load's name and "% of a usual week"; THREE NUMBERS: the aim at the target, injury in 100, the Tank at
  the first bell; then one word line (the goal's band, a spike, a rule that fires). Work, clock, the next point's date and the week's peak are one
  hover away. Week 1 shows the name and the % only (reveal order, section 11 step 5).
| Load | % usual | Footwork at the regional | Injury | Tank at the first bell | The line |
|---|---|---|---|---|---|
| Easy | 64% | 58 | 0.6 | 96 | goal close (62.7 on Fri 13) |
| Normal | 82% | 58 | 1 | 95 | goal close (62.9) |
| Hard on Footwork | 106% | 60: Jab and move Good | 2 | 94 | rule 1 fires Fri; goal close |
| Sharpen | 47% | 58 | 0.5 | 97 | a deload: tiredness 40 by Sun, nothing fades |
  WHY INJURY 2 (the hover): work 98 x 1.04 a 100 x the ratio 1.06 (x1) x the week's peak 76 (x2) x the pattern (varied, x1). Without rule 1 the
  peak is 79 (x2.75) and injury 3.
- THE PATTERN: Foster's monotony; ALL ALIKE over 2.0 multiplies the training injury chance x1.5 (NEW, ESTIMATE; PATTERN1); a button that would make
  the week ALL ALIKE turns amber.
- BALANCE BAR (DOSE1, tr6_1_0): across the four fighters' build weeks, Hard is the best load in 25 to 40 of 100 (under 15 a trap, over 60 the only
  answer); PACE1's pass line above.
- LINKS: Club week chip; RPG Hard school x1.4; the fighter's ask on Hard (T26); T15 (nothing fades in Sharpen); T37 (rule 1 caps the peak).

### T35. BLOCKS THAT BUILD ON EACH OTHER (NEW in v6.1; tr6_1_0 point 1, with tr6_1_1 point 10's season choice)
- WHAT YOU DECIDE: each BUILD block on the strip gets an EMPHASIS, BASE or SPECIFIC, and an AIM (Hard's aim for the block, carried every week of
  it). A click on the block opens both. Coach's default: BASE after a REST block or with the next bout 5+ weeks off; SPECIFIC in the last 4 weeks
  before a fight week. Fight weeks, tapers and deloads are Sharpen and take no emphasis.
- WHAT IT LAYS (on the free mornings Coach gives to conditioning; skills and the aim lay as before): BASE: roadwork, strength circuit, neck work.
  SPECIFIC: intervals and the heavy bag. Evenings stay Club week's.
- WHAT IT BUYS: a SPECIFIC week with a BASE week among the 4 weeks before it earns x1.2 on all that week's ability points (ESTIMATE; BLOCKORDER1).
  The BASE week's own price: Stamina waits for intervals (roadwork gives it 0.5, T36), the heavy bag's Explosiveness and Inside wait.
- ONE TRANSFER: Explosiveness's ceiling is held at Strength + 10 when that is lower (F2a's last step). Not a ceiling shift (C23): the ceiling stays;
  the hold lifts point for point as Strength grows. The row prints "held by Strength 50"; Strength's row prints "lifts the Explosiveness ceiling".
  A slugger with Strength 48 and an Explosiveness ceiling 66 plays at 58 until a BASE block's strength circuits lift it.
- THE PROFESSIONAL'S CAMP (C15, T33): BUILD = BASE, PEAK = SPECIFIC (x1.2 from the build), TAPER = Sharpen; the loads stay Hard, Hard, Sharpen by
  default. A real camp's order.
- Samira: 16 Feb BASE (now) · fight week · bout · REST · 9 Mar SPECIFIC x1.2 · 16 Mar SPECIFIC x1.2 · deload · fight week · the regional.
  Worked by hand (ESTIMATE): Hard on Footwork kept reaches 60.4; with this week SPECIFIC instead (no base in the last 4 for 9 and 16 Mar) 60.1,
  and Stamina 0.04 sooner. The base pays later; the specific pays now; BLOCKORDER1 sizes it before any screen prints x1.2.
- REAL BASIS: block periodisation, accumulation then transmutation then realisation, with residual effects carrying a base into the specific
  block (Issurin 2008, 2010); a fight camp's general weeks come before its specific ones.

### T36. TWO ENGINES (NEW in v6.1; tr6_1_0 point 2; MORNINGS1 changes T3)
- ROADWORK builds RECOVERY 1.5 + Stamina 0.5; INTERVALS build STAMINA 2.0. Rest builds Recovery 1.0 (+ Flexibility 0.5).
- WHAT EACH DOES (after F3, CODE numbers): STAMINA sets each round's energy cost (spend_factor 1.2 - 0.4 x Stamina/100) and the round-3 fade (0.25 a
  point under 64). RECOVERY sets the minute's refill (52% of the fast debt x (0.8 + 0.4 x Recovery/100)) AND the night's clearance in training
  (fatigue_keep: each point over 55 clears 0.3% more a night).
- THE LINK THE PLAYER MEETS: a BASE block's roadwork lifts Recovery, which clears the next block's tiredness faster, so its Hard weeks stay under 72
  (rule 1) and 80. Samira Recovery 50 -> 53 by the regional on Normal: the night keeps 87.6% not 88.5%, about 2 off a Hard week's peak (ESTIMATE).
- ON EACH MORNING CARD (printed at the choice): Roadwork "Recovery: clears tiredness overnight, refills between rounds"; Intervals "Stamina: each
  round costs less; no fade from 64".
- ROUND BY ROUND (the Stamina row's hover and the bill): energy at the start of rounds 1, 2, 3 from the Tank, worked from Combos: Samira now 95 /
  74 / 57; after Hard on Stamina kept 95 / 74 / 57.5. The energy part is small; the fade (0.35 now, 0.04 then) is the size. LINES1 prices both;
  if the energy part is under the cut rule the hover prints the fade only.
- TEST `tests/roadwork_vs_intervals_test.gd` (MORNINGS1): 4 weeks of roadwork against 4 of intervals from the same fighter: roadwork lifts
  Recovery more than Stamina and lowers next week's peak; intervals lift Stamina and lower a round's cost, never the refill. Red on main: equal.
- REAL BASIS: aerobic fitness speeds recovery between high-intensity efforts (Tomlin and Wenger 2001); intervals raise the capacity for repeated
  hard work (Laursen and Jenkins 2002).

### T37. MORNING RULES, SET ON MONDAY, NO STOPS (NEW in v6.1; tr6_1_0 point 3; it replaces the rejected morning check)
- WHAT YOU DECIDE: four standing rules per fighter, each ON or OFF, kept until changed:
| Rule | Reads (a number on screen) | Does | Costs |
|---|---|---|---|
| 1 TIRED | the 13-day chart: a day at 72 or more | the next morning, if Hard, runs Normal | that morning's Hard points |
| 2 AFTER HARD SPARRING | a Hard-setting sparring night (Club week) | the next morning is rest (Recovery, Flexibility) | that morning's session |
| 3 THIRD HAND DAY | the hand-day count (T19: bag, speed bag, pads) | a third hand day running turns the bag or speed bag to shadow | the bag's points; the niggle's trigger is met before it fires |
| 4 MOOD LOW | the mood word Low | the rest of the week runs Easy | the week's points; mood +4 for a rest week (code) |
- COACH'S RULES (C20): 1, 2, 3 on, 4 off; "Coach runs <name>" uses them.
- HOW IT RUNS: MorningRules.gd (pure, NEW, ~60 lines) is read inside WeekPlan.week before each day, so the one run (T24) prices every load with the
  rules in it. No rule stops the clock: the one mid-week stop stays a niggle that starts after a sparring night (T13).
- ON SCREEN: the rules line under THE WEEK (four toggles); a cell where a rule will fire is marked ("Fri: Hard runs Normal, rule 1"); the 13-day
  chart puts a dot on the day; the Week review names each firing and its price ("Rule 1 fired Fri: Footwork -0.08, peak 76 not 79").
- MORNRULES1: Coach's rules on against off over a season: injuries lower by 1 in 100 or more with the season's points within a tenth; a rule that
  fires under 1 week in 10 or changes nothing is cut.
- REAL BASIS: coaches adjust the day's session to readiness (subjective wellness and load monitoring, Halson 2014); the rule makes the coach's
  judgement visible and set in advance.

### T30. TWO HORIZONS ON EVERY LOAD (changed in v6.1: the aim is Footwork; the base counted)
- WHAT IT IS: each load prints this week AND the block to the season's next target, the load KEPT on every build week with the strip's emphases,
  fight weeks laid as Sharpen, rest blocks as Easy (WeekPlan.project, ahead, CODE; the fade rule; work capacity; DOSE1; T35; T37).
- Samira, worked by hand (ESTIMATE until the run), by the regional:
  - Easy kept: Footwork 58.2, Stamina 63.0; goal close (62.7 on Fri 13).
  - Normal kept: Footwork 58.3, Stamina 63.2 (fade 0.2), Recovery 52.9; goal close (62.9).
  - Hard on Footwork kept: Footwork 60.4 (Jab and move Good from 16 Mar); Stamina 63.0; goal close; safe every week (9 Mar at 1.19 of the usual).
  - Hard on Stamina kept: Stamina 63.9 (fade 0.04), Recovery 53.6; goal met Wed 11 Mar; but 9 Mar's SPECIFIC Hard runs at 1.35 of a usual of 81:
    over safe, injury x1.3 that week. Ease in with Normal on 9 Mar and the goal slips to close.
- WHY: one week moves a point by a day; a block moves a goal, a call and a fade. HORIZON1 cuts the second horizon if the loads do not reach
  different lines at the target in 6 seasons of 10.

### T31. THE 13 DAYS TO THE BELL (kept; the rules marked)
- A chart from today to the next bell: a bar per day for its work, the tiredness line day by day (WeekPlan.week, ahead), the 70 and 80 lines, THE
  TANK AT THE BELL with its parts, a GHOST LINE (this week on Hard on its aim) and a dot where a rule fires.
- Samira, Normal then a Sharpen fight week: 65, 61, 71, 73 (Thu), 66, 60, 53; then 60, 53, 51, 45, 40; 35 at the bell: Tank 95 (0.3 x 15 off).
  The Hard on Footwork ghost: 66, 68, 73, 76 (Thu), rule 1 Fri: 70, 63, 56; then 65, 58, 55, 49, 44; 40 at the bell: Tank 94.

### T14. THE TANK ON EVERY BOUT; WORK CAPACITY, NOT A SECOND FITNESS (kept)
- FITNESS IS THE ABILITIES (grown by sessions, F2b, F8; lost only by fade, T15). Nothing else is called fitness.
- TIREDNESS IS THE TANK (F5): 0.3 a point from 20 to 50, 2 a point over 50; weight left to the day (T8); your own last bout; at most 25.
- ON EVERY BOUT, ONE RULE with NOCAMP1. NO_CAMP_EDGE applies only to a professional with no camp.
- PRICED: LEVERS1's Tank rows (TANKPRICE1) give a point of Tank in exchanges; until then the tab prints the Tank only.
- WORK CAPACITY (CODE numbers): "usual 92 · safe to 120" (the 1.3 line) on hover. A week moves the usual 0.1535 of the gap: four weeks at about 129
  lift 92 to 102 in two weeks and 110 in four. Fight weeks, rest weeks and deloads pull it back, so the first build week after a taper is where
  spikes live. Shown on the load card's hover, the strip's build weeks ("safe 107") and T30.
- REAL BASIS: fitness-fatigue (Banister 1975); session load as effort x minutes (Foster 2001; boxers, Uchida 2014); the taper (Bosquet 2007).

### T32. THE STAND-DOWN AFTER A BOUT (kept, foundation F6)
- No sparring for 5, 10 or 21 days by the head band; a stoppage keeps its suspension (CODE). The stand-down is the floor; REST (2 weeks, Easy) is
  the choice (C18). SPAR ANYWAY (fine or hurt only): a head-knock roll that night, 2 or 6 in 100 (ESTIMATE); its rounds count double in T39.

### T39. HEAD CONTACT OVER A SEASON (NEW in v6.1; tr6_1_0 point 7)
- COUNTED: sparring rounds with head contact over the last 8 weeks: a Hard-setting night 6 rounds, a Technical night 6 x 0.5, Body only 0; a spar
  anyway night double. Bouts are not counted here (they have the stand-down and the stoppage loss's Durability -2).
- THE LINE: past 48 in 56 days (ESTIMATE; CONTACT1), Durability's ceiling -1 (a second CeilingShift trigger beside the stoppage loss, C23), and
  the count starts again. A Hard night every week reaches it in 8 weeks; Coach's Technical weeks never do.
- SHOWN: the Durability row ("head contact 33 of 48"), Condition, the chip on Club week's pair picker (C17), the Week review when it moves.
- THE TRADE: Hard sparring finds a hidden habit 1 in 3 (Technical 1 in 5) and trains Composure and Inside; the count makes it a season's choice.
- CONTACT1: the line is crossed only when the player sets Hard on more than 2 sparring weeks in 3; Durability at the season's end differs by 1+.
- REAL BASIS: camps cap hard sparring; brain-health studies of fighters tie harm to exposure accumulated over years (Bernick 2015).

### T15. ABILITIES FADE WITHOUT THEIR DOSE (kept: never in a fight week or a deload)
- Each ability is KEPT while it gets one session that trains it inside its window. Past a missed window the HOLD runs from the last dose; then it
  loses a little each week. Never more than 3 points under its best this season. Fight-week and deload days do not count toward any window.
| Group | Dose (one session in) | Hold after a missed dose | Then loses | Real basis |
|---|---|---|---|---|
| Stamina, Strength | 14 days | 30 days | 0.25 a week | about one session a week keeps fitness (Bickel 2011; Spiering 2021); residuals 30 +/- 5 days (Issurin 2008) |
| Recovery, Durability | 10 days | 18 days | 0.25 a week | anaerobic and strength-endurance residuals 15 to 18 days |
| Defence, Footwork, Accuracy, Timing, Inside | 10 days | 21 days | 0.25 a week | motor skill sharpness (ESTIMATE between the two) |
| Speed, Explosiveness | 7 days | 7 days | 0.5 a week (1.0 if DETRAIN1 is flat) | maximal speed residual 5 +/- 3 days |
| Fight IQ, Composure, Flexibility | never | | | learned, not trained shape |
- THE "KEPT BY" COLUMN READS THE PLAN: "Tue drills", "fight week", or "fades 9 Mar" in amber with the one session that stops it on hover. A pad card
  that will drop a tier inside 4 weeks gets a FADING row (MoveMastery.decay_week, CODE). A BASE block keeps Stamina by its roadwork's 0.5.

### T16. ROOM TO GROW: EACH ABILITY'S OWN CEILING (F2a, F2b; it moves: T34; it is held: T35)
- ON SCREEN: a bar from now to the ceiling; on it a GHOST to where the chosen load reaches by the target and a TICK at the next line. The ceiling is
  a range until KNOWN opens its group (C12). One word from the room: FAST at 10+, SLOW at 2.5 to 10, NEAR CAP under 2.5; HELD when T35's hold binds.
  Samira: Footwork 57 of 72 FAST, Defence 51 of 66-74 FAST, Timing 58 of 69 FAST, Speed 69 of 76 SLOW, Explosiveness 60 of 60 HELD (Strength 50),
  Durability 55 of 67 FAST, Stamina 62 of 67 SLOW, Recovery 50 of 66 FAST.

### T38. HOW EACH FIGHTER RESPONDS; AGE (NEW in v6.1; tr6_1_0 point 6, tr6_1_1 points 2, 3, 4, 6)
- THE RESPONSE: each fighter has one hidden word per Known group (C12): BODY, SKILLS, FIRE: SLOW x0.85, NORMAL x1.0, QUICK x1.2 (ESTIMATE; RESPONSE1),
  on every gain in that group. Drawn at signing: 1 in 4 slow, 1 in 2 normal, 1 in 4 quick per group.
- UNTIL KNOWN: every forecast that reads the group prints as a range (its gain x0.85 to x1.2): "Stamina 63-64 at the regional". KNOWN opens the
  group as it opens ranges on numbers and ceilings: your own sessions only (C12). The Amateur coach head-coach edge shows the responses at signing,
  as it shows exact potential. The Monday a group opens, the Week review names it: "Skills: a quick learner".
- SURPRISE WITH A REASON (tr6_1_1 point 6's form): while a group is not known the week lands where the TRUE response puts it, inside the printed
  range, and the review says so: "Stamina +0.4, top of the forecast: Body may be quick". The only other causes named are the game's own (a rule
  that fired, the twist card, the mood rate, a niggle). No dice on the gain.
- WHAT IT CHANGES LATER: the default aim and WHERE HARD PAYS MOST read it (a quick group earns the Hard block); a known slow BODY makes a BASE block
  cost more weeks; Find a fighter and the trial card show "?" per group, so a signing is a bet the sessions settle.
- AGE (tr6_1_1 point 3): every gain x1.1 under 23, x1.0 from 23 to 28, x0.85 from 29 to 31, x0.7 from 32 (ESTIMATE; AGEGAIN1; the critic's x1.2 /
  x0.5 softened so the young starting squad does not inflate PACE1 and a 32-year-old's block is worth less, not worthless). One chip on the header
  ("18: grows x1.1"); on Find a fighter and the trial card. Ceilings falling from 31 stay LEFT FOR LATER.
- DISCIPLINE ON THE HEADER (tr6_1_1 point 4, its readable part): the chip says what discipline does to training TODAY from the RPG lines (under 45
  skips 1 alone morning in 3; under 50 asks to ease the Hard days; the room: nobody skips): "Discipline 46: asks to ease Hard". No new scale.
- REAL BASIS: individual response to the same training varies widely (HERITAGE, Bouchard 1999); younger athletes gain skill faster; trainability
  falls with age in the thirties.

### T17. THE NEXT LINE PER ABILITY, AND WHAT THE POINTS UNDER IT BUY (kept; plain words)
THE RULE (F3, F10): a row prints only lines that read its own number; a line that also reads another row NAMES it; each line prints what the points
already under it buy, so 63.8 is never worth nothing. Words are the game's: "helps from 56", "Good at 62", never a range of two numbers.
| Ability | Its lines (CODE after F3, F10) | Printed on the row |
|---|---|---|
| Stamina | 64: no fade from round 3; Second wind 70 (PerkRoad) | "fade 0.35 · none at 64"; hover: rounds 1-3 energy (T36) |
| Recovery | the minute's refill; the night's clearance | "clears 12% a night · +0.3% a point" |
| Explosiveness | Finisher 70 (PerkRoad); the hold (T35) | "held by Strength 50" or "over ceiling 62" |
| Accuracy | Stiff jab 65; the move ceiling | "every move's top 74" |
| Timing | Draw the lead (with Fight IQ): Good at 62 | "Draw the lead 80%, with IQ 60" |
| Defence | Hands up (with Flexibility): helps from 56, Good 62; Counter sense 65 with a Check hook weapon | "Hands up helps from 56, with Flex" |
| Footwork | Jab and move (with the jab): Good at 62 | "Jab and move 90%, with the jab 64" |
| Speed | Let your hands go (with Stamina): Good at 62; Fast hands 70 | as Timing |
| Fight IQ | 65: finds the right answer alone; Ring general 65 | a step (finds or not) |
| Durability | Iron chin 70; head contact (T39) | "head contact 33 of 48"; hover "Iron chin 70 over ceiling 67" |
| Inside | Tie up (with Heart): Good at 62 mean | "Tie up helps from 56, with Heart" |
- WHOLE POINTS on the row, decimals on hover. Dates from the run (F7); past the season the month or "next season". LINES1 prices each crossing.

### T18. WHAT THIS OPPONENT TESTS, AND THE ORDER OF THE BOARD (kept)
- With a bout booked, OppTests.gd (NEW) gives each ability a multiplier from the opponent's style weights (Exchanges.STYLE_MODES), the right call for
  each game and each place's answering tools (Duels.TOOLS). Kayleigh Bell, counter-puncher: Fight IQ and Timing x1.4, Footwork x1.3, Stamina x0.8.
  The panel lists the 14 by Attrs.VALUE x the multiplier; seven show, the goal's row pinned; "Show all 14". Coach's week leans to it; with no bout, to
  the season target's pull; the direction's x1.10 always (C22). OPPTEST1.

### T19. NIGGLES FROM YOUR LOAD; TRAIN AROUND AN INJURY (kept; rule 3 meets the hand's trigger)
| Part | Comes when | Rest it (the swap) | Push on |
|---|---|---|---|
| Hand | 3 hand days running (heavy bag, speed bag, pads), or a week over 1.3 of the usual with 2 | bag and speed bag to shadow; pad cards on THAT hand pause, their places go to footwork drills | hand injury x3 this week |
| Ribs | 2 sparring nights, or a bout's ribs in the hurt band | no sparring, no body work | ribs x3 |
| Leg strain | 3 roadwork, intervals or footwork mornings and a week over 1.3 | to strength circuit and slip rope | strain x3 |
- EACH ANSWER PRICED IN THE OTHER PANELS (T24). Samira's right hand: REST IT: "the habit HALF FIXED on Sat 28; no bag: Explosiveness fades 9 Mar".
  PUSH ON: "hand injury 4 in 100 (bout off, $300 slot); the habit GONE on Sat 28". Unanswered on Monday: Coach rests it. With rule 3 on, the hand
  niggle comes only from a week over 1.3. TRAIN AROUND an injury: only the hurt part's sessions stop; FULL REST: back 20% sooner (ESTIMATE).

### T2, T23, T24. AFTER THE BOUT; WHAT THIS WEEK BUYS; ONE RUN, EVERY PRICE (kept)
- Every date past the next bout carries an amber "after" tag and the price of bringing it forward ("Check hook Usable Mon 2 Mar · after Sat 28 · on
  Hard: Fri 27 · Lucy goes short on Club week").
- <DAY>: WHAT THIS WEEK BUYS, for the next bout only: READY ON THE NIGHT ("sharp" or not, and the Tank); THE HABIT'S STATE; THE GOAL's band; WHAT
  LANDS AFTER THE BOUT; THE BIGGEST LEVER STILL OPEN. Its size is the week's part of YOU AGAINST COACH (C14), in exchanges, once LEVERS1 has its rows.
- ONE RUN: every option prints its cost in the other panels' terms by running the week WITH it (WeekPlan.week with MorningRules, PadWeek.run_week,
  InjuryRoll, the fade rule, BoutRules.tank, WeekPlan.project) and diffing. One function, TrainWeek.run (NEW). ONERUN1: every printed price equals
  the diff of two runs. A range comes only from an unknown response or ceiling (T38), never from dice.

### T25, T26, T27, T29. THE PERSON ON THE TAB (changed: the goal in four bands)
- THE GOAL IN FOUR BANDS (NEW, tr6_1_1 point 5; GOALBAND1, FighterGoal after F3): MET +10 mood; CLOSE (short by 0.5 or less) +3; SHORT (by 1 or
  less) -5; MISSED -20 (the code's +10 / -20 kept at the ends). The header and the goal row print the band ("Goal: Stamina 63 by Fri 13 Mar ·
  close"), the decimal on hover. A choice now moves a goal by a band, not across a cliff at 0.1.
- THE FIGHTER'S VOICE: PushBack (CODE): discipline under 50 asks to ease the Hard days; the ask sits on the Hard button ("Samira: 'ease the Hard
  days' · overrule: mood -5").
- THE GRADE AND PACE PER CELL: who runs it by stripe (you, Coach, alone) with the lift (CoachAreas): "+48%", "+30%", "x0.8" alone (the mood rate).
- RECOVERY SHOWN on its row (T36). No trust anywhere (C1).

### T3. ONE SESSION PER JOB (after MORNINGS1; the shares are section 0)
| Morning | Trains | Printed at the choice | Block |
|---|---|---|---|
| Roadwork | Recovery 1.5, Stamina 0.5 | "Recovery: clears tiredness overnight, refills between rounds · about 460 kcal" | BASE |
| Intervals | Stamina 2.0 | "Stamina: each round costs less; no fade from 64 · about 360 kcal" | SPECIFIC |
| Strength circuit | Strength 2.0 | "Strength: lifts the Explosiveness ceiling" | BASE |
| Heavy bag | Explosiveness + Inside | "Power punching, up close · hand day" | SPECIFIC |
| Neck work | Durability 1.0 | "Takes a punch" | BASE |
| Speed bag / Slip rope | Speed / Defence 1.0 | "Hand speed · hand day" / "Slips and rolls" | both |
| Footwork drills | Footwork 1.0 | "Ring cutting, angles" (NEW morning, 30 min, RPE 5, MET 7, ESTIMATE) | both |
| Shadow boxing | Accuracy 2.0, Footwork 0.5 | "Form, shots that land" | both |
| Rest | Recovery 1.0, Flexibility 0.5 | "Fresh legs" (no Stamina taken, F1) | |

### T4. WHAT A SPARRING SETTING TRAINS; WHO YOU SPAR WITH (kept; the pair on Club week, C17)
| Setting | Trains | Reveals | Head contact (T39) |
|---|---|---|---|
| HARD | Composure, Inside, Fight IQ | a hidden habit 1 in 3, a trait 1 in 2 (WEEK) | 6 rounds |
| TECHNICAL | Timing, Defence, Fight IQ | a hidden habit 1 in 5, a trait 35 in 100 (CODE) | 3 |
| BODY ONLY | Inside, Stamina, body punches; a ribs day (T19) | a hidden habit 1 in 10 | 0 |
- PARTNER LEVEL (NEW): 5 or more above teaches x1.2, 5 or more below x0.8 (a chip on the pair picker; the cell reads "Spar: Lucy · technical"). SPARLEVEL1.

### T5, T6, T7. HABITS, OWN TAPE, THE PERSON (kept; C19)
- HABITS in your pad places: THERE (6 power where punished, CODE) -> HALF FIXED after 3 -> GONE after 3 more; coachability under 40 one more a step,
  70+ one fewer; Known Skills one fewer, never under 1; back after three weeks over 70 tiredness or a Low week. A habit card names its hand. HABITWEEK1.
- FILM WITH NO BOUT = YOUR OWN TAPE: 2 pad places, a hidden habit 1 in 2 (ESTIMATE). OWNTAPE1.

### T8. WEIGHT TO THE LAST DAY, THE WEIGH-IN'S HOUR, AND THE LAST DAY'S WATER (changed: the water for professionals)
| Diet | kcal a day | About a week | Its price |
|---|---|---|---|
| HOLD | life + 300 (CODE) | holds | none |
| LEAN (NEW) | -250 | -0.23 kg | none |
| CUT | -500 (CODE; Old hand -620) | -0.45 kg; TAPER_KG in a Sharpen fight week | mornings x0.9 (NEW, ESTIMATE) |
| Weigh-in | Who | Time to refill | Tank for weight left to the day |
|---|---|---|---|
| THE DAY BEFORE | professionals, the regional, the nationals | about 24 h | -1 for each 0.2 kg |
| THE SAME DAY | club shows | about 3 h | -1 for each 0.1 kg, -2 past 0.5 kg |
- THE LAST DAY'S WATER (NEW, tr6_1_0 point 8; WATERCUT1): a PROFESSIONAL on a day-before scale may plan up to 2% of body weight to come off in the
  last 24 h as water (Lucy, 60 kg: up to 1.2 kg), refilled by the bell at the row above's price (up to Tank -6). The choice it opens: HOLD or LEAN and
  the water (fresh mornings, a lower Tank) against CUT for weeks (mornings x0.9, a full Tank). One line on the WEIGHT panel, priced by the one run:
  "Lucy: Lean + 0.8 kg water on Fri: Tank -4 at the first bell". Amateurs and same-day scales: not offered (over 0.5 kg left is red, as now).
- On screen: walking weight, the class, the next weigh-in and its hour, and per diet what it leaves and its Tank. Over 2% left: red, "a miss calls the
  bout off, $300" (CODE). REAL BASIS: day-before weigh-ins allow rehydration; up to about 2% water is mostly back in 24 h (Reale 2017).

### T9. THE SEASON STRIP (changed: emphasis and aim on build blocks)
- The next 12 weeks as blocks: AMATEUR BASE / SPECIFIC / FIGHT WEEK / REST / DELOAD; PROFESSIONAL BUILD (BASE) / PEAK (SPECIFIC) / TAPER; each with
  its load (T33) and, on a build block, its aim. A FIGHT WEEK and a TAPER are laid as Sharpen; a DELOAD is a Sharpen week you place (at most 1 in 3
  weeks, after 2+ build weeks). SPECIFIC blocks print "x1.2 base" when a BASE is in the 4 weeks before.
- Bout days print the Tank ("Tank 95"); build weeks the safe work ("safe 107") or a red "spike"; REST the day sparring opens; dates that matter.

### T10, T11, T12, T13. PADS, COACH RUNS IT, ANA, THE TAB (kept)
- PAD TIME PAST USABLE: FireLevel ON (CODE, built and off): 1 in 2 at Usable, 3 in 4 Sharp, always Signature; FIRELEVEL2 once. Each card prints its
  date, an after-the-bout tag, its hand; FADING rows; a KEEP-IT card priced in the card it displaces; a card at its move ceiling says so.
- COACH RUNS SAMIRA (C20): Coach's deal every Monday, Coach's rules (T37); Known stops growing (so responses stay unknown).
- ANA'S MAT WEEK: 8c.
- THE TAB: every cell has its session, pace, who coaches by stripe with the lift, and its reason; your changes keep a gold edge; "Back to Coach's
  week"; "Keep my changes into <the next phase>". ONE MID-WEEK STOP: only when a niggle starts after a sparring night.

### T20, T21, T22. TREND, BOUTS TEACH, THE PROFESSIONAL'S STAMINA (kept)
- Each row shows its last 4 weeks ("+0.9", "-0.4" in red); "Season so far" opens the ledger of whole points with causes (rules, response, blocks).
- A fought bout: Fight IQ +0.5 and Composure +0.5; a step-up or a points loss +1 each. BOUTTEACH1.
- The fade hits every round from the third: for Lucy each point under 64 costs a quarter in each of them. PROFADE1.

### T33. THE CAMP IS THE LOAD (kept; the blocks now carry their emphasis)
- A professional's camp is the strip's blocks, BUILD (BASE) / PEAK (SPECIFIC) / TAPER (Sharpen), each a load: default Hard, Hard, Sharpen; PEAK's aim
  is the camp focus. The camp card keeps LENGTH (4 weeks BUSY, 6 RANKED, CW 3.9), FOCUS, PARTNER (club mate free, outside mate $160) and FILM.
- THE EDGE IS EARNED: PEAK CAMP's three lines (made weight, the focus on target, never overreached) met = readiness +1 (FL M6). The water (T8) counts
  as made weight; rule 1 helps "never overreached".
- CAMPLOAD1 (F9) proves a label no longer moves a bout.

### T34. A CAREER ARC: CEILINGS THAT MOVE, AND A DIRECTION (kept; head contact adds a trigger)
| Event | Change | Group it lands on |
|---|---|---|
| The signing focus "Raise the ceiling" | +5 (CODE) | all |
| A BREAKTHROUGH: a step-up win | +1 (+2 by stoppage) | the group the opponent tested most |
| A BREAKTHROUGH: PEAK CAMP met | +2 | the camp focus's group |
| A BREAKTHROUGH: a season's dose under a coach rated 70+ in that area | +1 | that area's group |
| The fighter's season pick (RPG) | +3 | the picked group |
| A stoppage loss | Durability -2 (CODE) | Guard |
| HEAD CONTACT past 48 in 8 weeks (T39) | Durability -1 | Guard |
  At most +3 a group a season from breakthroughs (ESTIMATE). Groups HEAD, HANDS, GUARD, CARDIO, LEGS (the approved profile).
- ON SCREEN: the room bar's ceiling with its change for 4 weeks ("74, +2: the Kayleigh camp"); the Week review line; a row whose line is over the
  ceiling names what could lift it. THE BUILD DIRECTION (C22) on the header: "Direction from Mon 23: Keep it long".

### 5b. WORK HOURS (the owner's S433 answer Q-186: "No, full-time once pro")
- AN AMATEUR keeps the job rota (CLUBWEEK 3.3): the job's mornings are dim cells "at work"; the load lays its sessions on the free mornings only. A
  gym sponsorship (CLUBWEEK 3.1) frees six mornings; the drawn Samira is on a sponsorship block.
- A PROFESSIONAL trains full time from the debut: every morning free, no job row, no camp leave. COUNTED ONCE: DAY_JOB_GAIN x0.85 retires when
  JobRota lands; until then turn_pro clears `day_job` (F9).
- Q-187 ("Yes, both": featherweight and middleweight professional tables): no training rule changes; the ranking tables are the world's.

## 6. Every effect and its hook
| Effect | Tag | Hook |
|---|---|---|
| Rest keeps Stamina | CODE fix (F1) | Attrs.train; Sim.step_day |
| 14 shaped ceilings; the Strength hold; ceilings that move | CODE + NEW (F2a, T35, T34, T39) | Recruit.ceiling_of; AttrGen.tilt_of; CeilingShift (RPG) |
| Gain per ability on its own room | CODE fix (F2b) | WeekPlan.day, full_day; Attrs.train; Sim.week_ctx |
| The load buys fitness; the default aim | CODE + NEW (F8, T1) | WeekPlan.INTENSITY; week() dose count; the Hard lay; OppTests; Knowledge |
| Blocks: emphasis, x1.2 from the base | NEW (T35) | SeasonStrip (NEW); WeekPhase's lay; WeekPlan.week |
| Two engines | CODE + NEW (T36, MORNINGS1) | Attrs.SESSION_ATTRS; Combos.spend_factor, refill (F3); WeekPlan.fatigue_keep |
| Morning rules | NEW (T37) | MorningRules.gd (NEW) inside WeekPlan.week |
| Response by Known group; age | NEW (T38) | Knowledge.gd (the word per group); Recruit (drawn at signing); f["age"] |
| Head contact | NEW (T39) | SparSet (CW) count; CeilingShift |
| Stamina continuous; energy, refill | CODE fix (F3) | LiveRound 65; BoutRules.play_round; BoutRead 325, 187; BoutNight 302; Combos; FighterGoal |
| Calls climb from 56 | CODE fix (F10) | Exchanges.grade |
| The load in work | CODE + NEW (F4) | WeekPlan.work, clock; Injuries.week_work; TrainingLoad; InjuryRoll |
| One Tank, no dead zone | WEEK + CODE (F5) | BoutRules.tank (NOCAMP1); Combos.TANK |
| The camp is the load | CODE fix (F9) | BoutRules.PROTOCOLS; Camp modal; PeakCamp -> Readiness (FL); Roster.turn_pro |
| Stand-down | NEW (F6) | StandDown.gd; Injuries.after_bout; PadWeek.evenings |
| The goal in four bands | CODE change (GOALBAND1) | FighterGoal |
| The last day's water | NEW (T8) | WeekPlan.day (weight); BoutRules.tank's weight part |
| Load carried; two horizons; 13 days; one run | CODE + NEW | WeekPlan.project, ahead, week; TrainWeek.run (NEW) |
| Sharpen; nothing fades in it; "sharp" | CODE + NEW + WEEK | WeekPhase.WEEKS["taper"]; Detrain; Readiness (FL M6) |
| Pattern; why injury; work capacity | CODE + NEW | WeekPlan.week; InjuryRoll parts; TrainingLoad.next_chronic |
| Fade by dose; next line; opponent tests; niggles; what this week buys | as v6 | Detrain; Exchanges, PerkRoad, MoveMastery; OppTests, LeverSize; Niggle; TrainWeek.run |
| Goal, voice, grade, Recovery; direction; work hours | CODE + WEEK | FighterGoal; PushBack; CoachAreas; BuildDirection; JobRota; Roster.turn_pro |
| Ana's class kinds, doses, ceilings | NEW (8c) | NoGi (class kinds, body gains on the 14's rules); MatLines (MATPLAN) |

### 6b. Changes to the sister maps (carry into their next versions; nothing here adds a meter)
- CORE_LOOP section 5: step 0 adds F8 DOSE1, F9 CAMPLOAD1, F10 CALLSPREAD1 (as v6); step 2's Training group adds MorningRules, SeasonStrip's
  emphasis, MORNINGS1 (shares + roadwork_vs_intervals_test), GOALBAND1; step 1 adds BLOCKORDER1, MORNRULES1, RESPONSE1, AGEGAIN1, CONTACT1, WATERCUT1.
- C12 KNOWN: each group also opens the fighter's RESPONSE word (T38); nothing else grows Known.
- C23 CEILINGSHIFT: a second Durability trigger, head contact past 48 in 8 weeks (T39). The Strength hold is not a shift (T35).
- CLUBWEEK: Q-186 as v6 (full time once pro; camp leave retires); the pair picker shows the head-contact chip (C17); the camp's blocks carry BASE /
  SPECIFIC; usual and safe numbers read WORK.
- FIGHT LINK: one Tank rule; readiness "sharp" = Sharpen or Normal with a pad place in the last five days (C5); PEAK CAMP = readiness +1 (C15); the
  water counts as made weight.
- RPG layer: goals name any of the 14 and move mood in four bands (T25); the age chip and the response words sit on Character's Known panel.
- MAT PLAN (MATPLAN 4.4, 4.8): FILM is taken as Ana's fourth class kind; DRILL and POSITIONAL feed the named lines (8c).

## 7. Every decision
B = before the week, D = during, A = after. The last column is the designer's test (never printed).
| When | Decision | Options, costs and gains (each priced in the other panels, T24) | Right when |
|---|---|---|---|
| B, Monday | The load, carried (T1, T30) | Easy: fresher, few points. Normal: steady. Hard on an aim: +2 whole points on a fast row by the target, a pad night, injury up. Sharpen: nothing fades, few points | Hard on a fast row the opponents test, from a fresh start, not the first week after a taper |
| B, Monday or the strip | Hard's aim (T1, T35) | the default (worth x test x room x response), the goal's row, or another top row: the others keep Coach's sessions | where the list shows the most whole points toward a line, unless the goal's band matters more |
| B, the strip | A build block's emphasis (T35) | BASE now: Recovery, Strength, a later x1.2; SPECIFIC now: intervals and the bag, the goal sooner | BASE after a rest or 5+ weeks out; SPECIFIC in the last 4 |
| B, Monday | The morning rules (T37) | each ON: safer weeks, fewer points when it fires; OFF: more points, a higher peak, a niggle sooner | rules 1-3 on; rule 4 off when a bout is close and mood can carry it |
| B, a fight week | The load: Easy, Sharpen or Normal (C5) | Easy: freshest Tank, not sharp. Sharpen: sharp. Normal with a pad place: sharp, a Tank lower, more points | Sharpen unless the goal is due (Normal) or past 60 tired (Easy) |
| B, any week | A deload on the strip (T9) | a Sharpen week: tiredness clears, nothing fades | after 2+ Hard weeks, before a fight week |
| B, a professional's camp | Its blocks' loads, length, focus, partner, film; the last day's water (T33, T8) | Hard blocks: points on the focus, "never overreached" at risk; the water: fresh mornings for up to Tank -6 | Hard, Hard, Sharpen from a fresh start; water when the cut would run Cut for 3+ weeks |
| B, Monday | The sparring setting (Club week, T4, T39) | Hard: habits found, Composure; head contact 6 rounds | Hard while the count is under 30 |
| B, Monday | The niggle (T19); spar anyway (T32); train around (T19) | as v6 | as v6 |
| B, Monday | Morning exceptions; pad cards; the diet; overrule the ask; own tape; Coach runs it; keep my changes | as v6 | as v6 |
| B, signing (Find a fighter) | Who to sign (T38) | age chip; response "?" per group | a young quick learner is a bet; an older one is a level now |
| B, Monday (Ana) | Each class kind and the drill (8c) | DRILL, POSITIONAL, HARD ROLLS, FILM | positional on the plan's weakest line; hard rolls in the 14 days before an open; film once a bracket is drawn |
| A, the Why and Monday | "Put the habit card on", "Sharpen next week", "Rest the hand", "Train X" | one click into the Training tab with it set | the Why names a cost the week can fix |

## 8. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > Training (drawn) | header (goal in its band; age chip; discipline's line; the direction); the strip (blocks with emphasis, aim, "x1.2 base", Sharpen, the Tank on bout days, safe work); THE LOAD (four cards: % of the usual, the aim at the target, injury, the Tank at the first bell, a word line; Hard's aim and WHERE HARD PAYS MOST; the pattern; the ask); BODY; the week (session, pace, who + lift, reason, rule marks) and MORNING RULES; ABILITIES (by worth against the opponent; the response word per group; the bar with the ceiling, hold, ghost and tick; the line in plain words; trend; kept by; head contact on Durability); PAD PLACES; WHAT THIS WEEK BUYS; THE 13 DAYS (rule dots); WEIGHT (the water for professionals); the buttons | WeekBoard, WeekEditors, WeekTiles, WeekDay, WeekCards; WeekPlan, Injuries, InjuryRoll, TrainingLoad, PadWeek, MoveMastery, FireLevel, Recruit, AttrGen, Knowledge, BoutRules, Combos, Exchanges, Duels, PerkRoad, Attrs, CoachAreas, FighterGoal, PushBack, WeekCause; NEW TrainWeek, MorningRules, SeasonStrip, Detrain, OppTests, Niggle, TrainAround, HabitWork, StandDown; RPG CeilingShift, BuildDirection; FL Readiness |
| Fighters > Club week | each row: the load chip (with the block's aim), the rules chip (n of 4 on), the diet, niggle and stand-down chips, "Coach runs it"; the pair picker with partner level and head contact | ClubDeal, LeverSize, JobRota, Niggle, OppTests, HabitWork, StandDown, SparSet |
| Fighter page > Condition | the tiredness curve with 70 and 80 and the rule dots; the Tank on the next bout day; usual and safe work; the injury and its answer; the stand-down; head contact over 8 weeks | WeekTired, SeasonStrip, TrainAround, StandDown, SparSet |
| Fighter page > Profile | each bar's tick is its own ceiling (held, moved); the trend, "fades" with no dose; hover: next line in plain words | AttrBoard, Recruit, CeilingShift, Detrain |
| Fighter page > Character | Known by group with the response word once known ("Skills: quick"); the age chip | Knowledge, BuildDirection |
| The camp card (professional) | length, focus = PEAK's aim, partner, film; BUILD (BASE) / PEAK (SPECIFIC) / TAPER with loads; PEAK CAMP's three lines; the water line | Camp, PeakCamp, SeasonStrip, Readiness |
| The bill and the bout sheet | both Tanks at the first bell; rounds 1-3 energy on hover; readiness; the weigh-in's hour and the water | BoutSheet, BoutRules.tank, Combos, Readiness |
| Fight night | the Tank; the fade from Stamina as a slope; the refill from Recovery; the calls graded on the climb | BoutRules.tank, LiveRound, Combos, Exchanges.grade |
| Result and the Why | the Tank at the bell and what the strip did; Fight IQ and Composure taught; a ceiling that moved; "Rest the hand"; the stand-down | FightWhy, WhyCard, AfterFight, CeilingShift, Niggle, StandDown |
| Week review (Monday) | whole points with causes (rules fired, base x1.2, the response landing in its range), lines crossed, ceilings moved, a response learned, head contact, fades, niggles, habits, the goal's band | WeekReview, ReviewReveal, WeekCause, MorningRules, Knowledge, CeilingShift, Detrain, Niggle, HabitWork, FighterGoal |
| Fights > Find a fighter; the trial card | age chip; response "?" per group (exact with the Amateur coach edge) | Recruit, Knowledge |
| Playbook | "fires 1 in 2: Usable"; fading cards; a card at its move ceiling | PlanLines, FireLevel, MoveMastery |
| Grappler page | 8c | GrapplerPage, NoGi, MatLines, Niggle, Detrain |
THE NEW AND CHANGED MECHANICS, MENU BY MENU (each shows on every menu listed, in the .exe, and the golden path walks it):
| Mechanic | Menus |
|---|---|
| F1 to F10 foundations | no menu of their own: every number reads them; the golden path asserts each (section 11) |
| T1 the load, the default aim, where Hard pays most, plain cards; T30 two horizons | Training, Club week, Condition |
| T35 blocks and the Strength hold | Training (strip, load card, Explosiveness row), the camp card, Profile (the held tick), Week review |
| T36 two engines | Training (morning cards, Stamina and Recovery rows), the bill, fight night |
| T37 morning rules | Training (rules line, cell marks, chart dots), Club week (chip), Condition (dots), Week review |
| T38 response and age | Training (abilities header, ranges, age chip), Character, Find a fighter, the trial card, Week review |
| T39 head contact | Training (Durability row), Condition, Club week (pair picker), Week review |
| T8 the water | Training (WEIGHT, professionals), the camp card, the bill |
| T25 the goal's bands | Training, Profile (goal ring), Week review, Home's goal line |
| T31 the 13 days; T14 one Tank; T33 the camp; T34 ceilings; T17 slopes; T15 nothing fades; 5b work hours | as v6 |

### 8b. LUCY, THE PROFESSIONAL, ON THE SAME FRAME (specified panel by panel; drawn before the Cursor brief)
| Panel | Lucy (a 6-week camp, the RANKED target) |
|---|---|
| Header | goal in its band; "full time" (Q-186); age 21: grows x1.1; discipline's line; "Direction: Walk them down · Stamina, Inside x1.10" |
| Strip | BUILD · BASE (Hard, aim Strength) · BUILD · BASE (Hard) · PEAK · SPECIFIC x1.2 (Hard, aim Stamina, the focus) · PEAK · SPECIFIC (Normal: the second 80 avoided) · TAPER (Sharpen) · FIGHT; PEAK CAMP's three ticks |
| Load | the block's load and its aim with its two horizons to the fight; WHERE HARD PAYS MOST; no camp level (T33); the camp card's line "6 weeks · focus Stamina · southpaw mate $160 · film" |
| Rules | Coach's three on; rule 1 fires twice in the PEAK blocks (the chart's dots) and keeps "never overreached" |
| 13 days | the camp's last 13 days with the weigh-in THE DAY BEFORE and the water: "Lean + 0.8 kg water: Tank -4" |
| Abilities | the 14 against the booked name; Stamina "no fade in rounds 3 and 4" with its slope; Explosiveness held by Strength until the BASE blocks lift it; response words as Known has them |
| Buys | "FIGHT NIGHT: WHAT THIS CAMP BUYS": readiness (PEAK CAMP's lines), the Tank, the goal's band |
| Weight | the professional class, the day before, the water line |

### 8c. ANA ON THE SAME RULES (Q-188 "This version"; tr6_1_0 point 10, tr6_1_1 point 8; drawn before the Cursor brief)
- THE CODE TODAY (v6's claim corrected): three classes a week drill the syllabus move closest to owned (NoGi.DRILL_GAIN 3.2 a week); the classes add
  cardio 0.6 and strength 0.3 a week toward one BODY_CEIL 90 (NoGi.train_body); Flexibility, Explosiveness, Composure and Aggression do not train.
  THERE ARE NO CLASS KINDS IN THE CODE: v6's "hard rolls +1 a class, CODE scale" was wrong; all of the below is NEW.
- ANA'S ABILITIES ON THE 14'S RULES: Stamina (the code's key "cardio", C3), Strength, Flexibility, Explosiveness train by class; Composure learns from
  opens (bouts teach); Aggression is the mat plan's pace (MATPLAN's scoreboard rows), not trained. Each trained one has its own ceiling (F2a's rule on
  Ana's class, in place of BODY_CEIL 90), T15's dose windows, the response of its Known group (T38) and age 22: x1.1.
- CLASS KINDS (NEW; BJJCLASS1), three classes a week, each one of four, each with its effort and minutes in WORK (F4), so tiredness, the usual,
  injury, the Tank and the one run read the same rules:
| Class | Trains | Feeds the mat plan (MATPLAN 4.1, 4.3) | Load |
|---|---|---|---|
| DRILL | the move you name (default: closest to owned): +1.07 a class (the code's 3.2 a week, split); Flexibility 0.5 | the line's LEVEL ("Felt in 1 Sunday"; ON THE MATS) | light (RPE 4, 60 min) |
| POSITIONAL | rounds from one named position: +0.8 a class on the plan's lined move there; Stamina 1.0 | that line's CHANCE chip ("Frame and recover guard 36 -> 39: the escape 31 -> 34 in 100 vs Rosa") | normal (RPE 6) |
| HARD ROLLS | Stamina 1.0, Strength 1.0, Composure 0.5; open prep: +1 to the next open's form a class in the 14 days before, at most +4 (ESTIMATE) | the TANK chip (each attempt's cost falls with Stamina) | hard (RPE 8); 3 in a week = the strain card |
| FILM | one file entry on the next opponent (MATPLAN 4.4's order) | the READ chip turns from "vs the field" to "vs Rosa" | none |
- THE LOAD FOR ANA: the same four words on the same card; Hard turns 2 of the 3 classes Hard on its aim (a lined move, or a body ability); Sharpen
  is the open's week; rules 1, 3 (a third hard-rolls class: drill instead) and 4 apply.
- TWO HORIZONS TO THE OPEN: positional on the plan's weakest line owns it by the open, or hard rolls give prep; the strain card's day if it comes.
- "THE OPEN: WHAT THIS WEEK BUYS": open prep, the move closest to owned, the plan line one Sunday from Owned, the file entries found.
- BJJCLASS1: each class kind moves the next open's result by the cut rule (C27) or has a season effect (weeks to Owned); a kind that does neither folds
  into DRILL.

## 9. Numbers: from the code, or ESTIMATE
FROM THE CODE: the gain rule and room; today's shares; Recruit's class bias and AttrGen's tilts; Light 0.6 / Normal 1.0 gain and the load 0.6 / 1.0
/ 1.5; session minutes and RPE; Coach's base week 2,607 effort-minutes; tiredness 0.87 - 0.003 a Recovery point over 55 (0.70 to 0.95), 44 and 80;
the usual 0.1535 a week; 1.3 / 1.5 and x3; fatigue_mult from 72; the energy model (ROUND_COST 18, PUNCHES 54, spend_factor 1.2 - 0.4, QUICK_SHARE 0.6,
refill 52% x 0.8 to 1.2); the Tank 100 and 2 a point over 50; the fade line 64; the call grades and EDGE 17; KO_DAYS 30; MoveMastery's numbers and
words; Attrs.VALUE; CoachAreas; FighterGoal's +10 / -20; PushBack; HABIT_COST 6; the ages; Knowledge's three groups; NoGi's 3.2, 0.6, 0.3 and 90;
PROTOCOLS (retired by F9); DAY_JOB_GAIN 0.85 (retired by JobRota); the signing +5.
ESTIMATE (each set by a probe): Hard's gain 1.6 and the dose x1.3 (DOSE1 with PACE1); the base x1.2 and the Strength + 10 hold (BLOCKORDER1); the
two engines' shares (MORNINGS1); the rules' thresholds (MORNRULES1); the response x0.85 / x1.2 and its draw (RESPONSE1); the age steps (AGEGAIN1);
head contact's 48 and the round counts (CONTACT1); the water's 2% (WATERCUT1); the goal's close and short bands (GOALBAND1); the freshness slope
(FITLEGS1); the fade slope (FADESHARE, LINES1); the call climb (LINES1); CeilingShift's sizes (RPG probes); Footwork drills' share; the doses, holds
and fade rates; the Sharpen layout; the pattern's x1.5; the stand-down; niggle triggers; train-around's 20%; OppTests; habit steps; own tape; Lean;
Cut x0.9; bouts teach; partner level; Ana's class kinds (BJJCLASS1).
SAMIRA'S DRAWN NUMBERS were worked by hand from section 0's pace line in a scratch model of these rules (the four lays of T1, the strip of T35, Skills
known quick, Body not known, age 18, Strength 50, Recovery ceiling 66, the jab 64): Footwork 58.2 / 58.3 / 60.4 / 58.6, Stamina 63.0 / 63.2 / 63.0
and 63.9 on Hard on Stamina, Recovery 52.6 to 53.6; work 59 / 75 / 98 / 43; the tiredness days and the Tanks 94 to 97. The built tab reads them
from the run (T24).
ON SCREEN: no size in wins in 100 anywhere. A choice's worth prints in exchanges once LEVERS1 has its row.

## 10. To be measured: THE GATE TABLE before any pixel (tr6_1_0 point 5, tr6_1_1 point 7)
THE CUT RULE (C27): a choice stays if it moves 1.5 wins in 100 on the bouts where it applies OR has a season effect (weeks to a target, a fighter
kept, $150, 4 fans, a habit gone). EVERY PROBE RUNS on the amateur fight week (no camp, NOCAMP1's Tank in) AND on the professional's camp, and only
on the fixed engine (F1 to F10 merged). The table is filled in this map (the "Result" column) and published on the board BEFORE the Training tab's
Cursor brief; every row that fails makes its cut, and the drawing loses that panel.
| Probe | Its bar | Result | If it fails |
|---|---|---|---|
| Foundation unit tests (section 0, MORNINGS1, GOALBAND1) | each red on main, then green | pending | the task is not merged |
| PACE1 | Hard kept on a FAST row +2 whole points over Normal kept by the target; 3 of 8 top rows reach a line in the season; the squad's points at Coach's week within a fifth of today's | pending (by hand: Footwork +2.1) | the load is three (Easy, Normal on an aim, Sharpen); shares rise; multipliers fall in the order of Risks |
| DOSE1 | Hard's aim points 1.6x Normal's over 7 weeks; Hard the best load in 25-40 of 100 build weeks | pending | Hard's 1.6 and the dose move until it holds |
| BLOCKORDER1 | Base, Specific, Sharpen beats Specific, Specific, Sharpen by 1.5 in 100 or a target 2 weeks sooner | pending (by hand: +0.3 Footwork) | emphasis stays as the lay word, the x1.2 goes |
| MORNRULES1 | Coach's rules: injuries 1 in 100 lower a season, points within a tenth; each rule fires 1 week in 10 | pending | that rule goes |
| RESPONSE1 | a known response changes the best Hard aim in 1 build week in 4 | pending | the response folds into ceilings (no word) |
| AGEGAIN1 | with PACE1: the squad's pace within a fifth; a 30-year-old's block worth a target 1+ week later | pending | the age chip goes |
| CONTACT1 | the line crossed only at Hard more than 2 weeks in 3; Durability differs 1+ at the season's end | pending | head contact shows on Condition only, no trigger |
| WATERCUT1 | water against Cut changes a camp's result by the cut rule, either way, in some camps | pending | the water line goes |
| FITLEGS1 | Hard, Hard, Sharpen, bout beats Hard, Hard, Easy, bout by 1 in 100 | pending | Sharpen folds into Easy; the slope's 0.3 goes |
| HORIZON1 | the loads reach different lines at the target in 6 seasons of 10; the printed line reached 8 times in 10 | pending | one horizon |
| SEASON1 (training arm) | a careful player against "Coach runs it": 4+ in 100 on the season's bouts or the target 4+ weeks sooner | pending | the tab is cut back to the load, the chart and the abilities |
| BJJCLASS1 | each class kind passes the cut rule on the next open or a season effect | pending | that kind folds into DRILL |
- THEN, ON THE PLAYED BOUT: LINES1 (each crossing and slope in exchanges; the energy part of T36), OPPTEST1, NIGGLE1 with TRAINAROUND1, HABITWEEK1,
  FIRELEVEL2 (once, C27), PATTERN1, FADESHARE (inside CARDIO1).
- THE SMALL BATCH: SPARTRAIN1, SPARLEVEL1, STANDDOWN2, OWNTAPE1, LEANCUT1, WEIGHHOUR1, COACHRUNS1, BOUTTEACH1, PROFADE1, DETRAIN1.

## 11. Build order, in small tasks
1. THE FOUNDATIONS, one task each (section 0, its order). Each: parse gate, its one test red on main then green, the tests that play its path.
   WeekPlan.gd is owned by F2b, F4 and F8 one after the other, never two seats at once. Then MORNINGS1 (Attrs shares + roadwork_vs_intervals_test)
   and GOALBAND1 (FighterGoal, after F3). Then PACE1 (cloud).
2. THE GATE TABLE (section 10), cloud, pure: PACE1, DOSE1, BLOCKORDER1, MORNRULES1 (on a stub MorningRules), RESPONSE1, AGEGAIN1, CONTACT1, WATERCUT1,
   FITLEGS1, HORIZON1, SEASON1, BJJCLASS1; the results written into the table and onto the board; the cuts made in this map.
3. Rule modules with unit tests, one a task, ONLY after v6.1 passes two fresh critics at 7+ and the gate table is filled: TrainWeek.run (ONERUN1);
   MorningRules; SeasonStrip (emphasis, aim, x1.2); Sharpen and Pattern in WeekPlan; Detrain; OppTests; Niggle; TrainAround; HabitWork; the weigh-in
   hour and the water; head contact in SparSet; bouts teach; partner level; NoGi class kinds; FireLevel on. CeilingShift, BuildDirection and the
   response in Knowledge come from the RPG group.
4. DRAW BEFORE THE BRIEF (tr6_1_0 point 9): three more stills on this frame: the WEEK-1 tab (the load with its name and %, the strip, room to grow
   only), LUCY'S CAMP (8b) and ANA'S MAT WEEK (8c); every cell checked for clipping, text 20 px or more. Then the Training tab from
   `training_v2.png` (Cursor), then the other menus.
5. THE REVEAL ORDER IS A BUILD RULE: week 1 the load (name and %), the strip and room to grow; the 13-day chart with the first booking; the rules and
   the first niggle with the first Hard week; the sort and WHERE HARD PAYS MOST with the first booking; fades from week 3; the emphasis on the strip
   from the first REST block; Sharpen with the first fight week; the stand-down with the first bout; head contact from the first Hard sparring; the
   direction from week 8; a response the Monday Known opens it; a ceiling's change the first time one moves; "Show all 14" folded until week 3.
6. The golden path: Samira's Monday: the card's work equals Injuries.week_work; the BASE week on the strip and SPECIFIC 9 Mar reading x1.2; Hard picked
   with its default aim Footwork (the ask shown, overruled at mood -5), WHERE HARD PAYS MOST listing Footwork, Defence and Stamina; rule 1 firing on
   Friday and the review naming it; the goal reading "close" on Normal and "met" on Hard on Stamina; the hand niggle rested; Check hook brought
   forward by a pad place with Lucy going short on Club week; a Sharpen fight week with Stamina unchanged by its rest days (F1) and no fade on Speed
   (T15); the bout with a Tank under 100 from tiredness 35 (F5) and readiness "sharp"; the round-3 fade read as a slope (F3) and the refill from
   Recovery (T36); a call graded between OK and Good (F10); the stand-down locking Thursday's sparring (F6); Skills opening as "quick" on a Monday
   review (T38); head contact counted on a Hard sparring night (T39); Lucy's camp laid BASE, BASE, SPECIFIC, SPECIFIC, Sharpen with no level pick,
   the water priced in the Tank and PEAK CAMP read as readiness (F9, T8); Lucy turning professional with every morning free (Q-186); a ceiling moving
   after a step-up win (T34); Ana's class kinds before an open, a positional class moving a mat-plan line's chance (8c).

## 12. Every round-6 critic point, and where it went
| Round 6 critic point | Where |
|---|---|
| tr6_1_0 1: blocks that build on each other; BLOCKORDER1; Explosiveness held under Strength + 10 | T35 (emphasis and aim per block, x1.2 from the base, the hold in F2a), T9, T33, section 10 |
| tr6_1_0 2: two engines; ring meaning on each morning card; rounds 1-2-3; the test | T36, T3, MORNINGS1 with roadwork_vs_intervals_test; the rounds drawn on hover and the bill, honest about the small energy part |
| tr6_1_0 3: morning rules set on Monday, no stops; MorningRules.gd; Coach's rules | T37 (four rules as written, each reading a number on screen) |
| tr6_1_0 4: default aim worth x test x room; headline on a fast row; balance bar 25-40 of 100 | T1 (the default aim adds response; Footwork 57 -> 60 on Hard, 58 on Normal; DOSE1's bar) |
| tr6_1_0 5: run the gate before the pixels | section 10's gate table; section 11 steps 2 to 4 |
| tr6_1_0 6: trainability per group | T38 (on Known's three groups, C12; the five profile groups REJECTED) |
| tr6_1_0 7: head contact over a season | T39, T34, T4 |
| tr6_1_0 8: the professional's water | T8 (day-before scale only, priced by T8's own Tank row) |
| tr6_1_0 9: draw the quiet states, Lucy and Ana; clipped cells; 20 px | section 11 step 4; the drawing's cells re-cut (the sparring cell reads "Spar: Lucy · technical") |
| tr6_1_0 10: Ana's mat on the same rules; BJJCLASS1 | 8c |
| tr6_1_0 slips: "Learning" not "Raw"; which shares the F2b test reads | WORDS line; section 0's shares table in two columns |
| tr6_1_1 1: make the load felt; PACE1 pass line; where Hard pays most | T1, F7 PACE1. The SLOW row's +1 as a cut trigger: REJECTED |
| tr6_1_1 2: how each fighter responds, discovered | T38 (Known groups; ranges; named on review). The coach-70 halving: REJECTED |
| tr6_1_1 3: an age curve on the gain | T38 (softened steps) |
| tr6_1_1 4: character in the gain | T38 (discipline's existing lines on the header). The x0.9-x1.1 scale and ambition x1.1: REJECTED |
| tr6_1_1 5: smooth the goal | T25 (four bands, GOALBAND1) |
| tr6_1_1 6: weekly surprise with a reason | T38 (the true response lands inside the printed range; only the game's own causes named). Dice on the gain: REJECTED |
| tr6_1_1 7: run the gate before the brief | section 10, section 11 |
| tr6_1_1 8: Ana to the same depth | 8c with MATPLAN; drawn before the brief |
| tr6_1_1 9: plain words, three numbers a card | T1 (the card), T17 (words), the drawing. "Energy at the first bell" for the Tank: REJECTED (C2) |
| tr6_1_1 10: a season plan in one click | T35 (the aim is the block's, set on the strip). A second season pick: REJECTED (C22) |
| tr6_1_1 small: LiveRound 456 lines | section 0 F3 |
| Rounds 1 to 5 | answered in v5 and v6 (their tables: git S432, S433) |

## REJECTED (asks not taken, and why)
- FIVE RESPONSE GROUPS (HEAD, HANDS, GUARD, CARDIO, LEGS): Known has three groups (Body, Skills, Fire) and C12 makes it the one system; five response
  groups would need a second Known.
- A COACH RATED 70+ HALVING THE WEEKS TO KNOW A RESPONSE: Known grows only by your own sessions (C12); that is what makes running the sessions yourself
  worth something against "Coach runs it".
- DICE ON THE WEEKLY GAIN (+/-25%) WITH NAMED CAUSES ("bad sleep Tue"): an invented cause is flavour text, and noise would hide the very signal (the
  response) the player is reading. The surprise comes from the hidden response inside the printed range; the causes named are the game's own.
- DISCIPLINE SCALING EVERY SESSION (x0.9 to x1.1) AND AMBITION x1.1 AFTER A GOAL IS SET: discipline already has three lines (RPG: skips, the ask, the
  truth) and a fourth continuous rule on the same trait is a passive multiplier with no decision; ambition x1.1 rewards setting goals often, and
  ambition already prices the season target (RPG). The header shows discipline's lines instead.
- A SEASON PLAN OF TWO GROUPS as its own pick: the build direction is the one long aim (C22); the block's aim on the strip makes the aim a season
  choice without a second system.
- "ENERGY AT THE FIRST BELL" IN PLACE OF "TANK": C2 settled THE TANK on every page; the card prints "Tank at the first bell".
- THE SLOW ROW'S +1 AS A CUT TRIGGER: near its ceiling a row is meant to grow slowly; Hard there should look poor, and the list shows it.
- AGE x1.2 / x0.5 AS WRITTEN: the starting four are 18 to 22, so x1.2 would lift the whole squad's pace; x0.5 makes a 32-year-old's block worthless.
- INTERVALS' RECOVERY 0.5 (v6's own NEW share): two engines need one job each.
- THE CRITIC'S DOSE CURVE 1 - e^(-work/60); +1 SPEED AND EXPLOSIVENESS FROM SHARPEN; STRAIN AND SPIKE AS NEW TERMS; A PER-HOUR REFILL LINE; A SECOND
  DEVELOPMENT AIM; THE FULL TRACK REDESIGN: as v6 (each a second number or a second rule for something one rule already does).
- A HIDDEN LOAD TOLERANCE read through a morning check: still out; the visible rules of T37 give the same decision with no hidden number.
- FITNESS AS THE TOP OF THE TANK; "CARDIO" AS ONE ROW; THE TANK AT 1 A POINT; WORK AS RAW EFFORT-MINUTES; A FIFTH LOAD FOR THE FIGHT WEEK; HARD IN A
  FIGHT WEEK; A FIXED TANK PER SHAPE; A THIRD NIGGLE ANSWER; NEW FIGHT LINES FOR DEFENCE, SPEED, FOOTWORK; MOVING THE FADE LINE WITH THE ROUNDS;
  FITNESS AND TIREDNESS AS TWO BARS; A SUPERCOMPENSATION BONUS; COACHABILITY AS A MULTIPLIER; TRAIN THROUGH AN INJURY; AN UNBREAKABLE STAND-DOWN;
  MENTORING ON THE PAIR PICKER; MORE THAN ONE MID-WEEK STOP; MOOD ON ANA'S MAT GAINS; A LETTER GRADE PER CELL; SORTING BY THE MULTIPLIER ALONE;
  STALENESS WEEKS; A SEASON STORY CHART; ONE FOCUS A MONTH; PLYOMETRICS AS AN ELEVENTH MORNING; PER-MORNING INTENSITY AS THE MAIN CHOICE; PAD PLACES
  SPLIT 70/30; A WHITE BELT TEACHING: as v3 to v6.

## Risks, said plainly
- STACKED MULTIPLIERS: Hard 1.6 x the dose 1.3 x the base 1.2 x quick 1.2 x age 1.1 is 3.3 times a plain morning. PACE1 holds the squad's season
  points at Coach's week within a fifth of today's; if over, the base's 1.2 and the dose's 1.3 come down first; Hard's 1.6, the response and the
  age stay (they make choices and fighters differ).
- BLOCKORDER1 may find the base worth little (by hand +0.3 Footwork for Samira): then the emphasis stays a lay word and the x1.2 goes.
- The two engines' energy part is small (+0.5 energy at round 3 for a block); the size is the fade and the night's clearance. LINES1 decides.
- The rules make a Hard week cheaper in injury; DOSE1's balance bar catches Hard becoming the only answer.
- The freshness slope costs most bouts a few energy; the other corner reads the same rule; FITLEGS1 cuts it if it changes no decision.
- The fade slope makes Stamina under 60 cost more than today; FADESHARE holds the share and size of fading bouts.
- F2b, F4, F8 and MorningRules' read all touch WeekPlan.gd (347 lines): one after the other, growth under 80 lines in all; MorningRules is its
  own file.
- LiveRound.gd (456) and BoutRead.gd (497): F3 is a one-line swap in each, never an addition.
- Ana's class kinds are all new code in NoGi.gd (312 lines): one task, under 80 lines, its own test.
- More rules on one tab: the reveal order (section 11 step 5) carries it; the week-1 still proves it.

## TRAINING FOR THIS VERSION
0. THE FOUNDATIONS: rest keeps Stamina; 14 shaped ceilings reaching the gain; Stamina one continuous number; calls that climb; the load in work; one
   Tank with no dead zone; the stand-down; the load buys fitness; the camp is the load; two engines; the goal in four bands.
1. THE LOAD, CARRIED, in work: Easy, Normal, Hard on an aim, Sharpen; three numbers a card; where Hard pays most; two horizons; one run.
2. BLOCKS THAT BUILD: BASE and SPECIFIC with their aims; the base's x1.2; the Strength hold; the professional's camp in that order.
3. MORNING RULES set on Monday, firing without a stop.
4. THE TANK ON EVERY BOUT; the 13 days to the bell; Sharpen.
5. FADE BY DOSE; ROOM TO GROW with ceilings that move; HOW EACH FIGHTER RESPONDS, learned through Known; AGE on the gain.
6. THE NEXT LINE per ability in plain words; THE OPPONENT SORTS THE BOARD; WHAT THIS WEEK BUYS.
7. THE BODY: niggles from the load, the stand-down, head contact over a season.
8. WEIGHT to the scale's day and hour; the professional's last day of water.
9. THE PERSON: the goal in bands, the ask, discipline's lines, coachability's habit steps, the coach's grade per cell.
10. THE SEASON STRIP and TREND; bouts teach; one session one job; sparring by setting and partner; own tape; pad time past Usable; Coach runs it;
    Ana on the same rules, feeding the mat plan.
Built already and kept: the gain rule, phases, tiredness and the 80 line, the injury model, kcal and weight, pad nights and the move ladder,
PEAK CAMP (now readiness), perks, the awards.

## LEFT FOR LATER
- A HIDDEN LOAD TOLERANCE read through a morning check (sleep, soreness, effort felt): after F4's season injury count and SPARTRAIN1.
- A COACH'S REPORT whose accuracy follows the coach's area rating: needs Known's rules for the coach.
- Ceilings falling with age (31+), scars and past injuries raising risk, prime and decline (RPG LEFT FOR LATER); head contact feeding a career
  damage ledger once the small living world lands.
- Moving up a class; crossover training; strength-and-conditioning staff running mornings as a third coach; altitude, travel camps, nutrition
  beyond the three diets, sleep.
