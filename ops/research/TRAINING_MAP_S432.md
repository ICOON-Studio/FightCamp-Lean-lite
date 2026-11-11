# TRAINDEPTH1: the training map, v5 (S432)

The owner's question: "how deep are the training mechanics ? have critics rated them ?"
Round 1: two blind critics scored the training as built 5 and 5 (`docs/mockups/s432/critics/train_coach_review.md`, `train_sim_review.md`).
Round 2 (map v2): 7 and 6 (`tr2_player_review.md`, `tr2_sandc_review.md`). Round 3 (map v3): 6.5 and 7 (`tr3_science_review.md`,
`tr3_fm_review.md`). Round 4 (map v4): 6.5 (a strength and conditioning lead, `tr4_programme_review.md`) and 6.5 (a sports management
game reviewer, `tr4_reviewer_review.md`). The bar is 7 from both.
BOTH round-4 critics found defects in TODAY'S CODE under the map's own foundations. v5 checks each one in the code (section 0), designs the
fix as a FOUNDATION TASK that comes before any training feature (its owned file and the unit test that is red on main today), and only then
answers the rest of both lists (section 12).
Scope: four fighters (Lucy the professional, two amateurs, Ana the grappler), amateur to a first professional fight.
Builds on, never rewrites: CLUBWEEK v4.1 (`ops/research/CLUBWEEK_MAP_V41_S432.md`), the RPG layer v3 (`RPG_LAYER_MAP_S432.md`) and the
fight link map (`FIGHT_LINK_MAP_S432.md`). Where v5 changes one of their rules, it says so in 6b (one line each). No second meter for anything.
Words: "You" is the head coach, the player. "Coach" is the hired assistant coach. "Cardio" is the game's word for the Stamina ability, and
from v5 it means that one number everywhere (F3). Game text never says he, she, her or him.
Drawn: `docs/mockups/s432/training_v2.png` (the Training tab, Samira Khan, Monday 16 Feb, week 7, the hand rested).
TAGS on every effect: CODE = in the game's code today (file and name given, read for v5); WEEK = designed in an agreed sister map (Club week
v4.1, the RPG layer v3 or the fight link map), not built; NEW = new in this map. ESTIMATE = a number a probe sets.

## 0. THE FOUNDATIONS: today's code defects, fixed before any training feature
Every price on the tab reads these. Each was read in the code for v5; each is one small task with ONE owned file set and ONE unit test that
is red on main today. None adds a screen. They run in this order (F2 needs F1's clean Recovery; F7 measures F1 to F3).
| Task | The defect, as the code does it today | The fix | Owned files | The unit test, red on main |
|---|---|---|---|---|
| F1 REST1 | REST MORNINGS DRAIN STAMINA. WeekPlan.day gives a rest (or rest-only) morning an `attr_gain` on Conditioning's headroom; Sim.step_day (line ~213) hands it to Attrs.apply_session -> Attrs.train("", gain, ["recovery"]), which adds it to Recovery AND, in the lines at Attrs.gd ~329-334 ("The same points come off stamina"), takes the same off Stamina so the old Conditioning mean holds. So every taper rest day, every Easy or Sharpen week and every injured week (all rest) quietly turns Stamina into Recovery | Delete the take-off: rest adds Recovery and nothing else. The old Conditioning mean then rises a little on rest days; its only remaining readers after F3 are the between-rounds energy rate (Combos.after_round), where Recovery helping is true to the sport | `scripts/rules/Attrs.gd` (two lines removed) | `tests/rest_keeps_stamina_test.gd`: a fighter steps the code's taper week (three rest mornings) through WeekPlan.full_day and Attrs.apply_session; Stamina ends where it began and Recovery is up. Red on main: Stamina falls by the Recovery gained |
| F2a CEIL14 | ONE CEILING FOR SEVEN, NONE FOR THREE. Sim.week_ctx passes one `pot`; Recruit.ceiling(f, stat) gives the OLD seven a ceiling (pot +6 on the class's strength, -6 on its gap) and is read only by RecruitPanel. Footwork, Inside and Flexibility have no parent in Attrs.LEGACY, so no ceiling at all | Recruit.ceiling_of(f, ability) for all 14 abilities: pot + the class bias of the ability's parent (+6 / -6, as now; none for Footwork, Inside, Flexibility) + half the archetype's centred tilt for that ability (AttrGen.tilt_of, CODE), the sum held inside -8 to +8 of pot and never under now + 2 (as Recruit.ceiling). So 14 ceilings with a shape, not one number. Samira (out-boxer, pot 68): Footwork 72, Speed 76, Defence 70, Timing 69, Durability, Cardio and the rest 67, Inside 63, Strength and Explosiveness 60 (62: now + 2) | `scripts/rules/Recruit.gd` (one function, ~20 lines; file 123 lines) | `tests/ceiling_shape_test.gd`: Footwork, Inside and Flexibility each get a ceiling; an out-boxer's Footwork ceiling is above its Inside ceiling; a slugger's Explosiveness above its Speed. Red on main: the function does not exist and Recruit.ceiling("footwork") returns pot |
| F2b GAIN14 | THE GAIN IS WORKED ON THE OLD STAT. WeekPlan.day works out preview_gain on the OLD stat's value against the one pot; Attrs.train then shares that gain among the children. So Strength and Explosiveness always grow at Power's pace, and Footwork and Inside at whatever the session's old stat allows. T16's "each ability grows by its own room" cannot happen | Each session names its abilities with a SHARE (the table below, read from what Attrs.train gives each child TODAY per unit of the old stat's gain). Each named ability's gain = share x SESSION_SHARE x intensity x tired x coach factor x head-coach edge x headroom(ITS ceiling from F2a, ITS value). The camp multiplier, GymSpend.gain and STAT_CAP stay where Sim.step_day applies them. The old seven are rewritten as the mean (Attrs.sync, CODE), as now. WeekCause records by ability | `scripts/rules/WeekPlan.gd` (day, full_day: hand on the session's budget, not a stat's gain), `scripts/rules/Attrs.gd` (train reads the shares), `scripts/state/Sim.gd` (week_ctx builds `ceil` for 14) | `tests/gain_each_test.gd`: (a) with every ability at the same room, each session gives each ability exactly today's gain (the shares are today's split); (b) from one heavy bag, Strength with 15 points of room gains more than Explosiveness with 2. Red on main: (b) gains are equal |
| F3 CARDIO1 | "CARDIO 64" IS NOT CARDIO. LiveRound line 65, BoutRules.play_round (line ~208) and BoutRead line 325 read `stats.conditioning`, the MEAN of Stamina and Recovery, for the round-3 fade; FighterGoal.STAT_KEYS are the old seven, so a Cardio goal is that mean too. Samira at Stamina 64 and Recovery 50 sits at 57 and still fades | ONE RULE: A ROW PRINTS ONLY A LINE THAT READS THAT ROW'S NUMBER. The fade reads Stamina (Cardio) against FADE_STAMINA 64 (the same number); NIGHT_LINES' key becomes "stamina"; FighterGoal's keys move to the 14 abilities (a goal reads "Cardio 63" = Stamina 63; it can now be "Footwork 60"). Recovery is its own row and its own word. The two other NIGHT_LINES (the body call past Power 60, jab and move past Technique 61) read a mean of two rows, so the tab never prints them on an ability row (T17 shows the calls Exchanges.grade reads instead) | `scripts/state/LiveRound.gd` (494 lines), `scripts/rules/BoutRules.gd`, `scripts/rules/BoutRead.gd` (497 lines): a one-line swap each, no growth (both near the 500 cap); `scripts/rules/FighterGoal.gd` (STAT_KEYS and the targets) | `tests/cardio_line_test.gd`: Stamina 64, Recovery 50: no own fade in round 3; Stamina 63, Recovery 70: fades. A goal "Cardio 63" is met when Stamina reaches 63. Red on main: the first fades and the second does not |
| F4 LOADWORK1 | THE INJURY HOURS IGNORE EFFORT. Tiredness already uses effort x minutes (Foster: RPE x minutes x the pace's load, WeekPlan.day and full_day). The injury ratio and chance use WeekPlan.hours: minutes x the pace's load, no effort. 30 minutes of sparring = 30 of slip rope = 0.5 h; and a Hard minute counts 1.5, so "hours" are not clock time either. TrainingLoad.SETTINGS (3 / 6 / 10 / 15 h) and START_HOURS 10 still set a new fighter's usual (every first week reads 0.8) and an injured week (3.0 h) | ONE LOAD UNIT, WORK: the effort x minutes that tiredness already uses, mornings and evenings, sparring included. 100 work = Coach's base week (2,607 effort-minutes, computed from WeekPhase base + 3 pad nights + 1 sparring, never typed). Work feeds tiredness (as now), the usual (the 42-day average, CODE EWMA), the ratio and the injury chance. The chance is re-anchored so Coach's base week reads what it reads today (1.04 in 100). Clock time is shown beside it ("work 75 · 6 h 15"). A new fighter's usual starts at 100; an injured week counts its real work (0 at full rest). SETTINGS hours and START_HOURS retired | `scripts/rules/WeekPlan.gd` (work(), clock()), `scripts/state/Injuries.gd` (week_work, end_week), `scripts/rules/TrainingLoad.gd` (fresh usual), `scripts/rules/InjuryRoll.gd` (the base per 100 work) | `tests/load_work_test.gd`: (a) the load card's work equals Injuries.week_work for the same fighter; (b) a sparring night adds more injury work than 30 minutes of slip rope; (c) a new fighter's first Coach's week reads ratio 1.0. Red on main: (b) both 0.5 h, (c) 0.8 |
| F5 LEGS1 (inside the fight link map's NOCAMP1) | TWO LEGS SCALES. The code: stale_energy, 2 energy a point of tiredness over 50, at most 20, and 0 with no camp. CLUBWEEK: Legs, 1 a point over 50, at most 25 off with weight and the last bout | ONE SCALE: LEGS IS THE ENERGY TANK AT THE FIRST BELL (Combos.TANK 100); "Legs 94" = 6 energy off. Tiredness over 50: 2 a point (the code's rate, kept), that part at most 20; weight left to the day and your own last bout as CLUBWEEK; all added, at most 25 off; on every bout, camp or not. So the professional's camp costs what it costs today (reviewer 2's point 5), and an amateur fight week pays for the first time | `scripts/rules/BoutRules.gd` (legs() in place of stale_energy; NOCAMP1 swaps the call in BoutNight._peak) | `tests/legs_scale_test.gd`: the same amateur at tiredness 60 starts 20 down with or without a camp; the Training tab's Legs number equals BoutRules.legs for the same inputs. Red on main: 0 without a camp |
| F6 STANDDOWN1 | NO STAND-DOWN FROM CONTACT. Only a stoppage loss stops a boxer (30 days, CODE KO_DAYS). A boxer who took a beating on Saturday can spar on Thursday | After every bout, no sparring for a number of days set by the head damage the bout left (Injuries.after_bout already works out the head place: 100 - damage x 2.2): fine (55+) 5 days, hurt (35 to 55) 10, critical (under 35) 21; a stoppage keeps its suspension. Sparring nights inside it LOCK with the reason ("no sparring to Thu 5 Mar: the head took 25"). SPAR ANYWAY is offered in the fine and hurt bands at a price: a head-knock roll that night (fine 2 in 100, hurt 6, ESTIMATE), out 14 to 21 days with bouts closed (InjuryRoll "head", no choice, CODE) | `scripts/rules/StandDown.gd` (NEW, pure, ~40 lines), read by `scripts/rules/PadWeek.gd` evenings (two lines; file 464) and set in `scripts/state/Injuries.gd` after_bout (one line) | `tests/stand_down_test.gd`: after a bout with damage 25 (head 45, hurt), PadWeek.evenings holds no sparring night for 10 days, and one on day 11. Red on main: sparring runs on day 5 |
| F7 PACE1 (a probe, after F1 to F3) | THE DRAWN DATES WERE FASTER THAN THE GAIN RULE (reviewer 2's point 4) | Run the one run (T24) on all four fighters for 12 weeks, at Coach's week and at a focused load. The next line must land inside the season for at least 3 of the 8 top rows at a focused load; if not, the named-session share of the slow rows rises (Footwork drills 1.0 -> 2.0, the share a one-target session on Stamina or Strength gets today) until it does. Every date on the drawing comes from this run | cloud probe, pure | the probe's table; no row printed before it |

THE SHARES (F2b), read from Attrs.train and SESSION_ATTRS today (CODE), one row per session:
| Session | Abilities and share |
|---|---|
| Roadwork | Stamina 2.0 |
| Intervals | Stamina 2.0 (T3's Recovery share is NEW and waits for MORNINGS1) |
| Heavy bag | Strength 1.0, Explosiveness 1.0 |
| Strength circuit | Strength 2.0 |
| Speed bag | Speed 1.0 |
| Slip rope | Defence 1.0 |
| Shadow | Accuracy 2.0, Footwork 0.5 |
| Neck work | Durability 1.0 |
| Rest | Recovery 1.0 (and, after F1, nothing off Stamina) |
| Mobility | Flexibility 1.0 |
| Pads (evening) | Accuracy 1.0, Timing 1.0 (a camp's pad night: its stat's children 1.0 each, as now) |
| Sparring (evening) | Fight IQ 1.0, Composure 1.0, Timing 0.5, Defence 0.5, Inside 0.5 |
| Footwork drills (NEW morning, T3) | Footwork 1.0 (ESTIMATE; PACE1 may raise it to 2.0) |
THE PACE IN ONE LINE (so a critic can check every date): a session gives an ability share x 0.2 x pace (Light 0.6, Normal 1.0, Hard 1.3)
x the coach factor (0.5 + 0.007 x the area's rating; no coach 0.6) x room ((ceiling - now) / 25, held 0.10 to 1.25). Samira's slip rope with
you (rating 55, factor 0.885) at Defence 51 of 70: 1.0 x 0.2 x 0.885 x 0.76 = 0.13 a morning. Samira's Footwork, about 0.25 a week on the drawn
plan: 62 is about 20 weeks away, so its row says "June", not "30 Mar" (v4's date was wrong).

## 1. What v5 changes, in one line each
THE FOUNDATIONS (section 0): rest stops draining Stamina (F1); 14 shaped ceilings that reach the gain itself (F2a, F2b); Cardio means
Stamina, one row one number (F3); one load unit, WORK, priced on effort for tiredness, the usual and injury alike (F4); one Legs scale, the
energy tank, 2 a point (F5); a stand-down from sparring after every bout, by the head damage (F6); a pace probe before pixels (F7).
THE TAB: the drawn week's numbers rebuilt from the code's tables (work 75, 6 h 15 on the clock, the peak 73); every week cell prints its
pace (Light / Normal / Hard) and its minutes in the evenings; the day-by-day tiredness to the bell drawn as a 13-day chart with the Hard
week as a ghost line (T31); the stand-down on the strip and on locked nights (T32).
THE HEADLINE LOAD MOVES SOMETHING YOU CAN SEE (reviewer 2): the load now carries week to week until you change it, and every load button
prints TWO HORIZONS, this week and the block to the season's next target (T30): for Samira, Normal kept to the regional leaves Cardio at
63 and the round-3 fade in place; Hard kept reaches Cardio 64 on Fri 3 Apr, no round-3 fade at the regional, at 3 in 100 injury a week. The
chart shows the Hard week crossing 80 on Thursday. Each ability row gains a 4-week trend (T20).
SMALLER: NEAR CAP set where the code's floor starts (under 2.5 points of room); the move ceiling printed on the skill rows (T17); goals can
name any ability (F3); the reveal order is a build rule (section 11).

## 2. The idea in ten lines
1. ONE LOAD, CARRIED: Easy, Normal, Hard or Sharpen per fighter, kept week to week until changed; priced in WORK against the usual, injury,
   tiredness to the bell, the goal, and the block to the next target, all from one run.
2. FITNESS IS THE ABILITIES; TIREDNESS IS LEGS. A run of Hard weeks raises what is safe next week (work capacity), not a second bar.
3. SHARPEN, NOT REST: the taper and the deload keep the pace and cut the sessions, so Speed and Explosiveness do not fade in fight week.
4. FADE BY DOSE: each ability is kept by one session in its window (Speed a week, skills 10 days, Cardio and Strength 14 days).
5. ROOM TO GROW: each of the 14 abilities grows by its own distance to its own ceiling, and the ceilings have the fighter's shape.
6. LINES, NOT DECIMALS: every row names the next thing a point changes in the ring and its day, and a row prints only a line that reads it.
7. THE OPPONENT SORTS THE BOARD: abilities in order of worth against the booked name; Coach's week leans toward it.
8. THE BODY TALKS FIRST: a niggle from your own load; after a bout, a stand-down from sparring set by what the head took.
9. WEIGHT TO THE LAST DAY, and the weigh-in's hour: a day-before scale gives 24 h to refill, a club scale 3.
10. A SEASON YOU CAN READ: the strip ahead, the 13 days to the bell, and the trend behind.

## 3. The training as built (traced in the code for v5)
| Part | What the code does | Where |
|---|---|---|
| Mornings | 10 sessions; each a fifth of a focused week (SESSION_SHARE 0.2) x Light 0.6 / Normal 1.0 / Hard 1.3; x0.6 at tiredness 80+ | WeekPlan.SESSIONS, INTENSITY, TIRED_GAIN |
| THE GAIN (DEFECT, F2b) | worked on the OLD stat's value against the one pot (preview_gain), then shared among the children by Attrs.train (the shares in section 0) | WeekPlan.day, full_day; Attrs.train |
| REST (DEFECT, F1) | a rest morning adds its gain to Recovery and takes the same off Stamina, so Conditioning's mean holds | Attrs.train (~329-334), from Sim.step_day (~213) |
| One potential (DEFECT, F2a) | Sim.week_ctx passes `"pot"`; Recruit.ceiling (old seven only) is read only by RecruitPanel; Footwork, Inside, Flexibility have no parent | Sim.gd 120, Recruit.ceiling, Attrs.LEGACY |
| THE WEEK'S HOURS (DEFECT, F4) | mornings: minutes x the pace's load (Light 0.6, Normal 1.0, Hard 1.5); evenings at face value (pads 75, sparring 30; the taper's pads x0.5); no effort score | WeekPlan.hours, read by Injuries.week_hours over PadWeek.evenings(f, false) |
| Tiredness | effort x minutes x the pace's load (RPE, Foster) / 44 a point; keeps 87% a night (Recovery moves it 0.70 to 0.95; Recovery 50 keeps 0.885); 80 = overreached | WeekPlan.day, full_day, fatigue_keep |
| What that gives | Coach's base week: 7.97 h by the hours rule, 2,607 effort-minutes by tiredness's rule (worked from the tables) | WeekPhase.WEEKS, PadWeek |
| The stale table (DEFECT, F4) | TrainingLoad.SETTINGS (rest 3, light 6, normal 10, hard 15 h) and START_HOURS 10 feed camp_default, a new fighter's usual (first weeks read 0.8) and an injured week (3.0 h) | TrainingLoad.gd, Injuries.end_week |
| The usual load | an average over about 42 days (EWMA 0.1535 a week) | TrainingLoad.next_chronic |
| Injury | 1.3 in 100 a 10 h week, x hours; ratio to the usual: x1 to 1.3, x3 from 1.5; x1 to x3 by the week's peak tiredness from 72 to 80; types hand 40, ribs 30, strain 30 | InjuryRoll.training_chance, load_mult, fatigue_mult |
| Legs at the bell (DEFECT, F5) | stale_energy: 2 energy a point over 50, at most 20, BUT 0 when camp.protocol < 1 | BoutRules.stale_energy, BoutNight._peak line 108 |
| The fade line (DEFECT, F3) | the round-3 fade reads the old Conditioning (the mean of Stamina and Recovery) against 64; goals target the old seven | LiveRound 65, BoutRules.play_round, BoutRead 325, FighterGoal.STAT_KEYS |
| After a bout (MISSING, F6) | a stoppage loss suspends 30 days (more for repeats); any other bout stands nobody down from sparring | InjuryRoll.ko_days, Injuries.after_bout |
| The taper | roadwork Light, shadow Light, rest, speed bag Light, roadwork Light, rest, rest; half pad nights; no sparring: it cuts intensity AND volume | WeekPhase.WEEKS["taper"], PadWeek |
| Two Hard mornings running | the second is flagged red | WeekPlan.week "red" |
| While injured | every morning and evening becomes rest; gains x0.25 | Sim.step_day, Injuries.gain_mult |
| Body cards | "sore wrist" and "tight knee" drawn AT RANDOM | WeekTwist, InjuryRoll.training_cause |
| Fade | moves only: -0.75 mastery a week not drilled; Usable (30) kept for good. Abilities do not fade by time (but see F1: rest days moved Stamina) | MoveMastery.decay_week |
| The move ceiling | a move tops out at 40 + 0.4 x Technique + 0.2 x Fight IQ (Technique 58: about 74, under Signature 85) | MoveMastery.cap |
| Calls | graded on the mean of their needs: Good 62 (x1.0), OK 50 (x0.6), Poor (x0.3); Fight IQ 65 finds the answer; the 8 perk needs | Exchanges.grade, IQ_FINDS, PerkRoad.PERKS |
| What a style asks | each opponent style plays four games by weight; each place's tools name the abilities that answer them | Exchanges.STYLE_MODES, MODES, CALLS; Duels.TOOLS |
| Worth of a point | +10 on each ability against the reference field: Defence 0.090, Footwork 0.085, Speed 0.080, Explosiveness 0.070, Timing 0.060, Durability and Inside 0.055, Strength and Cardio 0.040, Accuracy 0.030, Fight IQ 0.025, Recovery and Composure 0.020, Flexibility 0.015 | Attrs.VALUE |
| Coached quality | five areas, each a rating; printed as a lift over training alone (pads: +24% at 60) | CoachAreas.rating_for, pct |
| The goal | FighterGoal: a target with a deadline; met: mood +10, trust +25; missed: mood -20, trust -25 | FighterGoal |
| The fighter's ask | discipline under 50 asks to ease the Hard mornings; a peak of 68 asks for easier mornings, 75 a day off; heard +5 mood / overruled -5 | PushBack, WeekTwist.ASKS |
| The week's causes | which sessions moved which stat, kept a week | WeekCause, f["week_src"] |
| Your changes | kept while the phase holds | WeekPhase.edits |
| Habits | fixed at signing (4 weeks) or patched for a round; costs 6 power an exchange where punished | Recruit.HABIT_WEEKS, HabitFix |
| Weight | kcal = MET x kg x hours; Hold = life + 300; Cut -500 (Old hand -620); a cut in the taper sheds 0.05 kg a day more | WeekPlan.day, TAPER_KG |
| Two clocks for a pad night | 75 minutes for load and tiredness; 240 game minutes in mastery's tally (PAD_NIGHT_MINUTES, the calibrated move pace). The tab prints only the 75 and the dates; mastery keeps its measured pace | WeekPlan.EVENINGS, PadWeek |

## 4. Where training is decided (one place each)
| Decision | Screen | Why there |
|---|---|---|
| Who gets the pad places, coached mornings and the seat; the sparring pair and setting; the club twist; the pulls; the season target | Fighters > Club week (WEEK) | shared between the four |
| The LOAD (Easy / Normal / Hard / Sharpen, carried; in a fight week it IS the fight-week shape); morning exceptions; each pad place's card; the diet; the deload; the niggle and the injury answer; spar anyway in a stand-down; Coach runs this fighter's week | Fighter page > Training (this map) | one fighter only |
| Ana's class kinds and the drill | the grappler's page | one fighter |
The Training tab shows the shared slots LOCKED with "change on Club week". Nothing is decided twice. CLUBWEEK's fight-week shape (Rest up,
Tick over, Train through) is the same choice as this tab's load in a fight week (6b): one button, two names never shown together.

## 5. The mechanics
The FOUNDATIONS are section 0 (F1 to F7), then T1 (the load in work), T14 (Legs on every bout), T15 (fade by dose) and T16 (each ceiling):
everything priced on the tab reads them, so their tests and probes run first (section 10).

### T1. ONE LOAD A WEEK, IN WORK, CARRIED (changed in v5)
- WHAT YOU DECIDE: per fighter: EASY, NORMAL, HARD or SHARPEN. The load CARRIES: Coach lays it on every week until you change it, except
  that a fight week is laid as Sharpen and a rest block as Easy (the strip shows each). A single morning can still be set apart in its popover.
| Load | How Coach lays it | Samira's week as laid, the hand rested: work (100 = Coach's base week) · clock | Against usual 92 | Use |
|---|---|---|---|---|
| EASY | every morning Light; 2 pad nights; 1 sparring | 59 · 6 h 15 | 0.64 | after a bout, hurt, Low mood; Rest up in a fight week |
| NORMAL | Coach's week (the pulls of Club week); one Hard morning on a build week | 75 · 6 h 15 | 0.82 | the default; Train through in a fight week |
| HARD | 3 mornings Hard, never two running (hard, normal, hard...); a 4th pad night | 96 · 7 h 30 | 1.04 | a build block 3+ weeks out from a fresh start; not in a fight week |
| SHARPEN | about half the sessions, every one at Hard pace; pads on half the nights at full minutes; no sparring | 44 · 2 h 45 | 0.48 | the fight week (Tick over), the professional's taper, a deload |
- HOW THE NORMAL WEEK ADDS UP (the drawn cells, so a critic can rebuild it): mornings Mon slip rope Normal (4 x 30 = 120 effort-minutes),
  Tue footwork drills Normal (5 x 30 = 150), Wed intervals Hard (8 x 30 x 1.5 = 360), Thu roadwork Normal (5 x 45 = 225), Fri and Sat shadow
  Light (4 x 30 x 0.6 = 72 each), Sun rest; evenings Mon pads and Wed pads (5 x 75 = 375 each), Thu sparring (7 x 30 = 210). 1,959
  effort-minutes = work 75; 375 minutes on the clock = 6 h 15. v4's "7.4 h" could not be rebuilt from the cells; this can.
- WORK, NOT HOURS (F4): the load card's number is Injuries.week_work for that fighter with that load laid. Ratio, the 1.3 / 1.5 lines and
  the injury chance are InjuryRoll's on work. Clock time sits beside it and in the hover. A Hard minute is more work, not more clock.
- THE PATTERN: Coach lays a Hard week hard-easy; two Hard mornings running stay the code's red day. A "Pattern" line reads VARIED or ALL
  ALIKE from Foster's monotony (the mean of the seven days' work over their spread). ALL ALIKE (over 2.0) multiplies the training injury
  chance x1.5 (NEW, ESTIMATE; PATTERN1).
- ON THE BUTTON, all from one run of WeekPlan.week + PadWeek.run_week + InjuryRoll for THIS fighter (T24), two horizons (T30):
  THIS WEEK: the work and clock; the first whole point and its day; the week's peak tiredness (and "over 80 Thu: gains x0.6 from Fri" when it
  crosses, CODE); the goal's status; injury in 100. KEPT TO THE NEXT TARGET: the line it reaches or misses and when.
  Samira, Monday 16 Feb, starting the week at tiredness 61, Kayleigh on Sat 28, the regional on Sat 4 Apr:
  - "Easy · work 59 · Defence 52 next Mon · goal at risk · kept: Cardio 63, fades in round 3"
  - "Normal · work 75 · Defence 52 Thu · peak 73 · injury 1 · kept: Cardio 63, fades in round 3"
  - "Hard · work 96 · Defence 52 Mon · over 80 Thu: x0.6 · injury 3 · kept: Cardio 64 Fri 3 Apr, no fade"
  - "Sharpen · work 44 · keeps Speed and Explosiveness · goal at risk · a deload: tiredness 40 by Sun"
  Why Hard reads injury 3 although its work is about the usual: the week peaks at 80.2 from a start of 61 (fatigue_mult x3, CODE). The same
  Hard week from a rested start reads 1 in 100. The card says which: "from tired 61".
  LEGS ARE ONE LINE ABOVE THE BUTTONS, not on each: from this start every load leaves Samira at tiredness 35 to 39 at the bell (Recovery 50 clears
  12% a night over a Sharpen fight week), so Legs read 100 at any load this time. The line says so; the loads differ in what they print
  below it. Legs bite on a bout inside about 5 days of a Hard week (the strip and the chart show it when it happens).
- LINKS: Club week chip; RPG Hard school x1.4; the fighter's ask on Hard (T26); T15 (Sharpen keeps the fast abilities).

### T30. TWO HORIZONS ON EVERY LOAD (NEW in v5; reviewer 2's first depth point)
- WHAT IT IS: each load button prints this week AND the block to the season's next target (the next bout with a camp, the regional, a
  grading; with none, 6 weeks), with the load KEPT on every build week, fight weeks laid as Sharpen and rest blocks as Easy. Computed by
  carrying the one run forward (WeekPlan.project with WeekPlan.ahead, CODE; the T15 fade rule; work capacity).
- WHAT IT PRINTS: the one line the block reaches or misses (the most valuable line against the target's opponent, else the goal's), the
  usual and safe work at the target, and the weeks overreached. Samira: Normal kept: Cardio 63 by the regional, the round-3 fade stays; Hard
  kept: Cardio 64 on Fri 3 Apr, no round-3 fade at the regional, safe work 133 by then, 1 week in 4 over 80 from a tired start; Easy kept:
  Cardio 63, safe work 108. This is the depth a single week cannot show: the block decides whether Samira fades in round 3.
- WHY: one week of load moves a point by a day; a block moves a line in the ring. Football Manager's intensity matters because a month shows
  in the arrows; here the button says what the month buys before you commit to it, and the trend column (T20) shows it after.
- SIZE: LINES1 prices the line in wins in 100 at the target; before it reports, the button prints the line and its day only.

### T31. THE 13 DAYS TO THE BELL (NEW in v5; reviewer 1's point 6)
- WHAT IT IS: a chart on the tab from today to the next bout's bell: a bar per day for that day's work, the tiredness line day by day (CODE:
  WeekPlan.week's per-day fatigue, carried into WeekPlan.ahead's fight week), the 70 and 80 lines, LEGS AT THE BELL with its parts (tiredness,
  weight, the last bout), and a GHOST LINE: the same days with this week Hard, so the price of Hard reads as a shape.
- Samira, Normal then a Sharpen fight week: 65, 61, 71, 73 (Thu, the peak), 66, 60, 53; then 60, 53, 51, 45, 40; 35 at the bell. Legs 100
  (tiredness under 50: 0; inside the club scale's gap: 0; last bout 5 weeks ago: 0). The Hard ghost: 67, 71, 79, 80 (Thu, over the line), 75,
  68, 60, then 66, 58, 56, 49, 44; 39 at the bell.
- The Condition tab keeps the long curve; this chart is the one a coach plans a taper from.

### T14. LEGS ON EVERY BOUT; WORK CAPACITY, NOT A SECOND FITNESS (scale fixed in v5)
- FITNESS IS THE ABILITIES: Cardio, Strength and the rest grow slowly by sessions (CODE, and F2b) and fall by fade (T15). Nothing else is
  called fitness. v3's "Fitness = 55 + 4 x usual hours" stays DROPPED (REJECTED).
- TIREDNESS IS LEGS, ON ONE SCALE (F5): Legs = the energy tank at the first bell (Combos.TANK 100). Tiredness over 50 costs 2 a point (the
  code's STALE_PER_POINT), that part at most 20; weight left to the day (T8) and your own last bout (7 days ago -8, 14 days -4) add; at most
  25 off. "Legs 92" is 8 energy off at the first bell, nothing else.
- ON EVERY BOUT (ONE RULE with the fight link map's NOCAMP1): Legs replace BoutRules.stale_energy in BoutNight._peak on every bout, an amateur
  fight week included; NO_CAMP_EDGE applies only to a professional with no camp. This map fixes the scale and prices it; NOCAMP1 builds it.
  Before NOCAMP1 lands, the Legs line is hidden for amateurs (never a dead number).
- PRICED IN WINS: TANKPRICE1 (CLUBWEEK) gives the worth of a point of tank; until it reports, the tab prints Legs only.
- WORK CAPACITY (the slow reward, CODE numbers): the usual work (the 42-day average) is shown as "usual 92 · safe to 120 next week" (the 1.3
  line). A week moves the usual 0.1535 of the gap: a block of Hard build weeks at about 129 lifts Samira's usual from 92 to about 102 in four
  weeks, so a camp week of 133 becomes safe that was not. No bar: one line on the load card, the strip's build weeks and T30's horizon.
- REAL BASIS: the fitness-fatigue model (Banister 1975): fitness slow, fatigue fast; the acute:chronic load (Gabbett 2016); session load as
  effort x minutes (Foster 2001; valid in boxers, Uchida 2014).

### T32. THE STAND-DOWN AFTER A BOUT (NEW in v5, foundation F6)
- WHAT IT IS: after every bout, no sparring for 5, 10 or 21 days by the head band the bout left (fine, hurt, critical); a stoppage keeps its
  suspension (CODE). Real programmes stand a boxer down from contact after head knocks; England Boxing mandates it after a stoppage (CODE
  30 days); the lighter bands are an ESTIMATE (STANDDOWN1 probe in the small batch: re-injury against lost sparring value).
- ON SCREEN: the strip's REST block prints the day sparring opens ("spar Thu 5"); a sparring night inside it is LOCKED with the reason; the
  Why's "Rest" button carries it; Club week's pair picker greys the fighter with the day. Before the bout, the strip shows the fine band's
  5 days as the least it will be.
- THE CHOICE: SPAR ANYWAY on a locked night (fine or hurt band only): a head-knock roll that night, 2 in 100 (fine) or 6 (hurt), ESTIMATE; a
  head knock is out 14 to 21 days with bouts closed (CODE, no choice). Worth it only when that night's sparring opens a habit or a line the
  next bout needs; the button prints both.

### T15. ABILITIES FADE WITHOUT THEIR DOSE (kept; F1 makes it the only way an ability falls)
- WHAT IT IS: each ability is KEPT while it gets its DOSE: one session that trains it (the shares, section 0) inside its window. Once a window
  passes with no session, the HOLD runs from the last dosed session; when the hold runs out it loses a little each week. A lone session after
  a missed window stops that week's loss but restarts the hold only when the dose is back (two windows running with a session each). It never
  falls more than 3 points under its best this season. After F1, a rest morning never takes Stamina: fade by dose is the only way down.
| Group | Dose (one session in) | Hold after a missed dose | Then loses | Real basis |
|---|---|---|---|---|
| Cardio (Stamina), Strength | 14 days | 30 days | 0.25 a week | keeping fitness at about one session a week (Bickel 2011; Spiering 2021); residuals 30 +/- 5 days (Issurin 2008) |
| Recovery, Durability | 10 days | 18 days | 0.25 a week | anaerobic and strength-endurance residuals 15 to 18 days |
| Defence, Footwork, Accuracy, Timing, Inside | 10 days | 21 days | 0.25 a week | motor skill sharpness (an ESTIMATE between the two) |
| Speed, Explosiveness | 7 days | 7 days | 0.5 a week (1.0 if DETRAIN1 is flat) | maximal speed residual 5 +/- 3 days |
| Fight IQ, Composure, Flexibility | never | | | learned, not trained shape |
- ON SCREEN, THE "KEPT BY" COLUMN READS THE PLAN: "Tue drills", "Thu sparring", or, when nothing in the planned weeks doses it, "fades Sat 28"
  in amber with the one session that stops it on hover. Moves: a pad card that will drop a tier inside 4 weeks gets a FADING row
  (MoveMastery.decay_week, CODE). A move never falls under Usable (CODE).
- DETRAIN1: a camp in the right order beats the reverse by 1.5+ in 100; a season with no keep-it sessions loses 2 to 4 points; if it comes
  back flat, Speed and Explosiveness lose 1.0 a week rather than fade being cut. RUNS AFTER F1 (or it measures the rest drain).

### T16. ROOM TO GROW: EACH ABILITY'S OWN CEILING (made real by F2a and F2b)
- THE FIX: F2a gives all 14 abilities a ceiling with the fighter's shape; F2b makes each session's gain read that ability's own room. Strength
  and Explosiveness from one heavy bag now grow at their own rates; Footwork and Inside have ceilings of their own.
- ON SCREEN: a bar from now to the ceiling, the ceiling as a range until KNOWN opens its group (WEEK RPG 8; Knowledge.width, CODE), and one
  word from the room in points: FAST at 10+ (room 0.4+), SLOW at 2.5 to 10, NEAR CAP under 2.5 (it trains at the code's 0.10 floor; v4 drew
  this line at 4, where the floor does not start). Samira: Footwork 57 of 72 FAST, Defence 51 of 66-74 FAST, Timing 58 of 69 FAST, Speed 69 of
  76 SLOW, Explosiveness 60 of 62 NEAR CAP ("Finisher 70 is over the ceiling"), Cardio 62 of 67 SLOW, Inside 50 of 63 FAST.

### T17. THE NEXT LINE, PER ABILITY, WITH ITS DAY (one row, one number in v5)
THE RULE (F3): a row prints only a line that reads that row's own number.
| Ability | Its lines (all read this ability, CODE after F3) |
|---|---|
| Cardio (Stamina) | 64: no fade from round 3 (LiveRound, BoutRules, BoutRead after F3); Second wind (Stamina 70, PerkRoad) |
| Explosiveness | Finisher 70 (PerkRoad) |
| Accuracy | Stiff jab 65 (PerkRoad); THE MOVE CEILING: every move tops out at 40 + 0.4 x Technique + 0.2 x Fight IQ (MoveMastery.cap, CODE), and Technique is Accuracy and Timing's mean: "every move's top 74 now; Signature needs Technique 83" |
| Timing | "Draw the lead" (Timing and Fight IQ): Good at 62 mean (64 for Samira at Fight IQ 60); the move ceiling as Accuracy |
| Defence | "Hands up, move your head" (0.65 Defence + 0.35 Flexibility): OK 50, Good 62; Counter sense 65 with a Check hook weapon |
| Footwork | "Jab and move" (the jab and Footwork): Good at 62 |
| Speed | "Let your hands go" (Cardio and Speed): Good at 62; Fast hands 70 |
| Fight IQ | 65: finds the right answer alone; Ring general 65 |
| Durability | Iron chin 70 |
| Inside | "Tie up" (Inside and Heart): Good at 62 mean |
- The body call past Power 60 and jab and move past Technique 61 (BoutRules.NIGHT_LINES, the old sim path) read a mean of two rows: never
  printed on a row. A call going from OK to Good lifts its edge from x0.6 to x1.0 of 17 power points in each exchange it fits (Exchanges.EDGE).
- ON SCREEN, WHOLE POINTS ONLY (decimals on hover): "Cardio 62 · 64: no fade from round 3 · Hard kept: Fri 3 Apr". A line over the ceiling
  says so. Dates come from the run (F7); a date past the season reads the month or "next season", never a fake near date. LINES1 prices each
  crossing in wins in 100; a line under 1.5 is printed as a word only.

### T18. WHAT THIS OPPONENT TESTS, AND THE ORDER OF THE BOARD (kept)
- WHAT IT IS: with a bout booked, OppTests.gd (NEW) reads the opponent's style weights (Exchanges.STYLE_MODES), the right call for each game
  and each place's answering tools (Duels.TOOLS), and gives each ability a multiplier against THIS opponent. Kayleigh Bell, counter-puncher
  (counter 55, range 25, press 10, load up 10 in 100): Fight IQ and Timing x1.4 (Draw the lead), Footwork x1.3, Cardio x0.8.
- THE SORT: the abilities panel lists the 14 by WORTH AGAINST THIS OPPONENT = Attrs.VALUE (CODE) x the multiplier, as four dots; the
  multiplier is a column. Seven rows show and the goal's row is pinned below them; "Show all 14" is one click. Samira against Kayleigh:
  Footwork, Defence, Timing, Speed, Explosiveness, Durability, Inside, then Cardio pinned (the goal, x0.8). Never an old-seven row.
- WHAT IT CHANGES: CLUBWEEK's pull sizes (LeverSize, WEEK) multiply by it, so Coach's week leans toward it; each morning's reason names it.
  With no bout booked the sort is by plain worth. Before tape study it uses the style word only (CODE); a found tell sharpens it. OPPTEST1.

### T19. NIGGLES FROM YOUR LOAD; TRAIN AROUND AN INJURY (kept; the triggers now count work)
| Part | Comes when | Rest it (the swap) | Push on |
|---|---|---|---|
| Hand | 3 hand days running (heavy bag, speed bag, pads), or a week over 1.3 of the usual work with 2 | bag and speed bag to shadow (WeekTwist's sore-wrist swap, CODE); pad cards on THAT hand pause (each card names its hand) and their places go to footwork drills | hand injury x3 this week (SPIKE_MULT, CODE) |
| Ribs | 2 sparring nights, or a bout's ribs in the hurt band | no sparring, no body work | ribs x3 |
| Legs (strain) | 3 roadwork, intervals or footwork mornings and a week over 1.3 | to strength circuit and slip rope | strain x3 |
- EACH ANSWER PRICED IN THE OTHER PANELS, from the same run (T24). Samira's right hand, Monday 16 Feb:
  - "REST IT: no bag; Wed's habit pads become footwork drills, so the habit is still HALF FIXED on Sat 28 (Kayleigh punishes it: -2 to -4
    in 100); Explosiveness has no session by Sat 28 (-0.5 on the night)."
  - "PUSH ON: hand injury 4 in 100 (out 2 to 4 weeks: the bout off, $300 slot); the habit GONE on Sat 28."
- Unanswered on Monday: Coach rests it. The two random body cards leave the deck. A niggle that starts mid-week (after a sparring night) is the
  ONE mid-week stop (T13).
- AN INJURY, TRAINED AROUND (Coach's default) turns off only the hurt part's sessions, the rest at full; FULL REST: back 20% sooner
  (ESTIMATE). Bouts stay closed until cleared (CODE). NIGGLE1, TRAINAROUND1.

### T2. SIZES YOU CAN FEEL; DATES PAST THE BOUT FLAGGED (kept)
- Whole points with their day, tiers with their day, lines with their day (T17); with a bout booked, the week's worth as a range in wins in
  100 from the probes (LeverSize, WEEK). Decimals in hover only.
- AFTER THE BOUT: every date past the next bout carries an amber "after" tag and, where it can be moved, THE PRICE OF BRINGING IT FORWARD
  from PadWeek.project / WeekPlan.project (CODE): "Check hook Usable Mon 2 Mar · after Sat 28 · +1 pad place Thu: Usable Fri 27 · Lucy goes
  short on Club week". Where nothing can bring it forward the tag says "not before Sat 28 at any load".

### T23. SAT 28: WHAT THIS WEEK BUYS (kept; Legs moved to the chart)
One panel on the Training tab, read from the same run, for the next bout only: YOUR WEEK AGAINST COACH'S as a range in wins in 100
(CLUBWEEK's one number, LeverSize); THE HABIT'S STATE on the night and its cost where this opponent punishes it; THE GOAL, on track or at
risk, and its value on the night; WHAT LANDS AFTER THE BOUT (T2's flags in one line, and "Cardio 64: not by Sat 28 at any load" when the
fade line cannot be reached in time); THE BIGGEST LEVER STILL OPEN with its size. Legs and their parts live on the chart (T31), beside it.
With no bout booked the panel reads "This week buys" for the season target (T30's horizon) instead.

### T24. ONE RUN, EVERY PRICE (kept)
Every option on the tab (the load, the niggle's answers, a keep-it card, the diet, a deload, spar anyway, an after-the-bout fix) prints its
cost in the OTHER panels' own terms, computed by running the week WITH that option (WeekPlan.week, PadWeek.run_week, InjuryRoll, the fade
rule, the Legs rule, and for T30 WeekPlan.project) and diffing against the week as it stands. One function (TrainWeek.run, NEW, a thin
wrapper) feeds every panel. ONERUN1 (unit test): every printed price equals the diff of two runs.

### T25. THE GOAL ON THE TAB (kept; any ability after F3)
FighterGoal shows on the header ("Goal: Cardio 63 by Fri 13 Mar · on track") and on the row it names; every load and diet button prints the
goal's status after it. After F3 a goal names an ability ("Footwork 60"), so the opponent sort can pin it. Met: mood +10, trust +25; missed:
mood -20, trust -25 (CODE), said on hover.

### T26. THE FIGHTER'S VOICE ON THE LOAD (kept)
PushBack (CODE): a fighter with discipline under 50 asks to ease the Hard mornings; the ask sits on the button it is about, handwritten:
"Samira: 'ease the Hard days' · overrule: mood -5". Picking it anyway is the overrule (CODE price; more under coachability 40, RPG).

### T27. THE COACH'S GRADE ON EVERY COACHED CELL (kept, beside the pace)
Each cell names who runs it by its stripe colour (you, Coach, alone) and prints its lift from CoachAreas (CODE) beside its pace: "Normal +48%",
"Hard +30%" (Coach is weak on conditioning), "Normal x0.8" alone (the mood rate, CLUBWEEK 3.7).

### T29. RECOVERY SHOWN (kept)
The Recovery ability sets how fast tiredness clears (WeekPlan.fatigue_keep, CODE: 0.70 to 0.95 a night). The header says it ("Recovery 50:
clears 12% a night") and the chart's Legs line repeats it. After F1, Recovery grows on rest days and costs nothing else.

### T3. ONE SESSION PER JOB (kept; the shares are section 0)
| Morning | Trains (share) | Printed at the choice | Change (tag) |
|---|---|---|---|
| Roadwork | Cardio 2.0 | "Cardio · about 460 kcal" | kept (CODE) |
| Intervals | Cardio 2.0 (+ Recovery 0.5, NEW) | "Cardio + Recovery · about 360 kcal" | adds Recovery (NEW, MORNINGS1) |
| Strength circuit | Strength 2.0 | "Strength" | kept (CODE) |
| Heavy bag | Explosiveness + Inside | "Power punching, up close · hand day" | was Strength + Explosiveness (NEW, MORNINGS1) |
| Speed bag | Speed 1.0 | "Hand speed · hand day" | kept (CODE) |
| Footwork drills | Footwork 1.0 | "Ring cutting, angles" | NEW morning (30 min, RPE 5, MET 7, ESTIMATE) |
| Slip rope | Defence 1.0 | "Slips and rolls" | kept (CODE) |
| Shadow boxing | Accuracy 2.0, Footwork 0.5 | "Form, shots that land" | kept (CODE) |
| Neck work | Durability 1.0 | "Takes a punch" | kept (CODE) |
| Rest | Recovery 1.0 (+ Flexibility, NEW) | "Fresh legs" | no longer takes Stamina (F1); Mobility folds in (NEW) |
The old block plan (TrainingPlan) is retired.

### T4. WHAT A SPARRING SETTING TRAINS; WHO YOU SPAR WITH (kept)
| Setting (prices WEEK) | Trains | Reveals |
|---|---|---|
| HARD | Composure, Inside, Fight IQ; Fire known faster (WEEK) | a hidden habit 1 in 3, a trait 1 in 2 (WEEK) |
| TECHNICAL | Timing, Defence, Fight IQ | a hidden habit 1 in 5, a trait 35 in 100 (CODE) |
| BODY ONLY | Inside, Stamina, body punches; a ribs day (T19) | a hidden habit 1 in 10 |
- PARTNER LEVEL (NEW): a partner 5 or more above (their mean of the abilities the setting trains) teaches those abilities x1.2; one 5 or more
  below x0.8. The pair picker prints it ("Lucy: 6 above, x1.2"). SPARLEVEL1. A fighter in a stand-down (T32) is greyed on the picker.
- CONTACT (NEW, ESTIMATE): sparring work counts x1.5 in the training injury chance only (on top of its higher effort, F4). SPARTRAIN1 sets or
  cuts it.

### T5. HABITS ARE TRAINING WORK (kept)
| State | How | In a bout (CODE cost 6, NEW halves) |
|---|---|---|
| THERE | found in a fight, sparring (T4) or own tape (T6) | costs 6 an exchange where punished (HabitFix.PUNISHED_BY) |
| HALF FIXED | 3 of your pad places on it | 3 |
| GONE | 3 more | 0 |
- STEPS BY COACHABILITY (T7): under 40, 4 pad places a step; 70 and up, 2; Known 3 (WEEK RPG) takes one more off, never under 1.
- IT COMES BACK: three weeks running over 70 tiredness, or a week at Low mood: one step back; in a bout under 30 energy it plays one step
  worse. The card prints its worth against the booked opponent. A habit card names its hand (T19). HABITWEEK1.

### T6. FILM WITH NO BOUT = YOUR OWN TAPE (kept)
"Film: your own sparring · 2 pad places": finds a hidden habit 1 in 2 (ESTIMATE), else the most hidden trait (WEEK RPG); "Nothing left on
tape" greys it. With a bout: the opponent's tape (CODE). OWNTAPE1.

### T7. THE PERSON TRAINS TOO (kept)
Coachability at the RPG's lines: under 40 a habit step takes one more pad place; 70 and up one fewer. Mood and discipline (WEEK CLUBWEEK
3.7): a session alone at the mood rate (Fired up 0.8, Steady 0.6, Flat and Low 0.4); discipline under 45 skips 1 alone morning in 3 unless
a team-mate is in the room. Shown on the cells ("Normal x0.8", "may skip").

### T8. WEIGHT TO THE LAST DAY, AND THE WEIGH-IN'S HOUR (kept; Legs on F5's scale)
| Diet | kcal a day | About a week | Its price |
|---|---|---|---|
| HOLD | life + 300 (CODE) | holds | none |
| LEAN (NEW) | -250 | -0.23 kg | none |
| CUT | -500 (CODE; Old hand -620) | -0.45 kg; -0.05 kg a day more in a Sharpen fight week on a cut (CODE TAPER_KG) | mornings x0.9 (NEW, ESTIMATE) |
| Weigh-in | Who | Time to refill | Legs for weight left to the day |
|---|---|---|---|
| THE DAY BEFORE | professionals, the regional, the nationals | about 24 h | -1 for each 0.2 kg |
| THE SAME DAY | club shows (amateur) | about 3 h | -1 for each 0.1 kg, -2 past 0.5 kg (CLUBWEEK) |
- ALWAYS ON SCREEN: walking weight, the class, the next weigh-in that reads the class and its hour ("Fri 3 Apr, the day before: 24 h to
  refill"), and per diet what it leaves to that day and its Legs: "Lean: 65.0 by Mon 16 Mar, nothing left" / "Hold: 0.9 kg left, Legs -5".
  Club shows at walking weight with CLUBWEEK's 1.0 kg gap say so. Over 2% of body weight left to the day: red, "a miss calls the bout off,
  $300" (CODE). Each diet button prints its goal and first-point effect (T24).

### T9. THE SEASON STRIP (kept; work and the stand-down added)
- The next 12 weeks as blocks: for an AMATEUR, BUILD / FIGHT WEEK / REST / DELOAD (CLUBWEEK words); for the PROFESSIONAL, BUILD / PEAK / TAPER
  (CODE WeekPhase). A FIGHT WEEK and a TAPER are laid as SHARPEN; a DELOAD is a Sharpen week you place (at most 1 in 3 weeks, after 2+ build
  weeks). REST is an Easy week or a fortnight after a bout, and prints the day sparring opens (T32). The dates that matter: bouts, entries
  closing (CODE SeasonPath), the next grading (CODE SkillAwards).
- EACH BLOCK draws its Legs (bout days, "Legs 100") or its safe work (build weeks, "safe 120"; a Hard block "Hard · 129"). Hover a deload:
  its Legs on the next bout with and without it, and "a fifth of a week's points" (T24).
- Pinned buttons say the phase that is next: "Keep my changes into the fight week" for an amateur, "into Peak" only for the professional.

### T10. PAD TIME PAST USABLE IS WORTH IT (kept)
FireLevel switched ON (CODE, built and off): a line fires 1 in 2 at Usable, 3 in 4 Sharp, always Signature; FIRELEVEL2 first. A pad place
drills one card or two at half each; each card prints its date, an after-the-bout tag (T2) and its hand (T19). FADING rows (T15) and a
KEEP-IT card priced in the card it displaces. A card at its move ceiling says "capped by Technique: train Accuracy or Timing" (T17). Move
names come from the data only (Data.MOVES).

### T11. COACH RUNS IT, PER FIGHTER (kept)
"Coach runs Samira's week": Coach's deal every Monday; Known stops growing (WEEK RPG). The button prints its size: "-1 to -2 in 100 on Sat 28".

### T12. ANA'S MAT WEEK (kept)
Class kinds DRILL / POSITIONAL / HARD ROLLS with the stripe date for each choice; open prep +1 in 100 a match per Hard rolls class in the 14
days before an open (at most +4). T15's fade with its dose (Cardio: one hard-rolls class in 14 days), T19's niggle (hard rolls 3 in a week:
a strain card). Ana's classes are effort x minutes too (F4), so Ana's usual work and safe line read the same way. BJJCLASS1.

### T13. THE TAB (kept, with v5's panels)
Every cell has its session, its PACE (Light / Normal / Hard; an evening its minutes), who coaches by stripe with the lift (T27), and its reason
("Slip rope: weak spot", "Footwork: Kayleigh"); a cell you change keeps a gold edge; "Back to Coach's week". YOUR CHANGES KEEP while the phase
holds (CODE); "Keep my changes into <the next phase>" carries them across. ONE MID-WEEK STOP (reviewer 2's point 6, the smallest form): the
clock stops once, after a sparring night, only when a niggle starts (T19's triggers); never in a quiet week.

### T20. THE TREND AND SEASON SO FAR (changed in v5: a column)
Each ability row shows its last 4 weeks as a signed number ("+0.9", "-0.4" in red), from f["season_src"] (WeekCause tallies by ability
after F2b; NEW keep). Hover: the sessions that made it. "Season so far" (a button) opens the full ledger: each whole point since the season
target was set with its causes, bouts among them, losses in red ("-1 Speed: no dose, 3 weeks"). Lines, never a chart.

### T21. BOUTS TEACH (kept)
A fought bout adds Fight IQ +0.5 and Composure +0.5; a step-up or a points loss +1 each. BOUTTEACH1: never outweighs a month of sparring.

### T22. THE PROFESSIONAL'S CAMP LEANS TO CARDIO (kept; reads Stamina after F3)
The fade hits every round from the third (LiveRound 65): 1 round in 3 for an amateur, 2 in 4 on the debut, 4 in 6 ranked. The professional's
camp card prints "Cardio 64: no fade in rounds 3 and 4". PROFADE1 measures the worth.

## 6. Every effect and its hook
| Effect | Tag | Hook |
|---|---|---|
| Rest keeps Stamina | CODE (defect fix F1) | Attrs.train; Sim.step_day |
| 14 shaped ceilings | CODE + NEW (F2a) | Recruit.ceiling_of (NEW) from Recruit.CLASSES and AttrGen.tilt_of |
| Gain per ability on its own room | CODE (defect fix F2b) | WeekPlan.day, full_day; Attrs.train (shares); Sim.week_ctx `ceil`; TrainingPreview.headroom |
| Cardio is Stamina; one row one number | CODE (defect fix F3) | LiveRound 65; BoutRules.play_round, NIGHT_LINES; BoutRead 325; FighterGoal.STAT_KEYS |
| The load in work | CODE + NEW (F4) | WeekPlan.work, clock (from day/full_day's load); Injuries.week_work, end_week; TrainingLoad fresh usual; InjuryRoll base per 100 work |
| One Legs scale on every bout | WEEK + CODE (F5) | BoutRules.legs in place of stale_energy (NOCAMP1 in BoutNight._peak); Combos.TANK |
| Stand-down after a bout | NEW (F6) | StandDown.gd (NEW); Injuries.after_bout head band; PadWeek.evenings; InjuryRoll "head" |
| Load carried; two horizons | CODE + NEW | WeekPlan.project, ahead; TrainWeek.run (NEW) |
| The 13 days to the bell | CODE + NEW | WeekPlan.week per-day fatigue; WeekPlan.ahead; BoutRules.legs |
| Sharpen; the taper and deload keep the pace | CODE + NEW | WeekPhase.WEEKS["taper"] rewritten; PadWeek.nights_for (taper); NEW Sharpen layout |
| Pattern (monotony) | CODE + NEW | WeekPlan.week "red"; NEW Pattern x1.5 in InjuryRoll |
| Work capacity | CODE | TrainingLoad.next_chronic; InjuryRoll.SAFE_RATIO |
| Fade by dose | NEW | Detrain rule reading the shares and the planned weeks (WeekPlan.ahead, PadWeek.ahead) |
| Moves fade, fading rows; the move ceiling | CODE + NEW | MoveMastery.decay_week, gain, cap |
| Next line and its day, after-the-bout tag | CODE + NEW | Exchanges.grade, EDGE, IQ_FINDS; PerkRoad.PERKS; the fade line (F3); WeekPlan.project; PadWeek.project |
| Opponent tests; the sort | CODE + NEW + WEEK | Exchanges.STYLE_MODES, MODES, CALLS; Duels.TOOLS; Attrs.VALUE; NEW OppTests; LeverSize (WEEK) |
| Niggles, cross-priced; the mid-week stop | CODE + NEW | InjuryRoll.TRAIN_TYPES, SPIKE_MULT; WeekTwist swap; NEW Niggle (hand per card); the clock's stop list (NEW entry) |
| What this week buys; one run | WEEK + NEW | LeverSize, FightWeek (WEEK); NEW TrainWeek.run |
| Goal on the tab, any ability | CODE (F3) | FighterGoal |
| The fighter's voice | CODE | PushBack, WeekTwist.ASKS |
| Coach's grade and pace per cell | CODE | CoachAreas.rating_for, pct; WeekPlan.INTENSITY |
| Recovery shown | CODE | WeekPlan.fatigue_keep |
| Weigh-in timing | WEEK + NEW | CLUBWEEK scale rate (same day); NEW day-before rate |
| Trend and season so far | CODE + NEW | WeekCause.add by ability; NEW season keep |
| Bouts teach | NEW | AfterFight |
| Pro camp leans to Cardio | CODE (F3) | LiveRound 65, BoutRules.FADE_STAMINA |
| Mornings, one job each | CODE + NEW | WeekPlan.SESSIONS; the shares |
| Sparring setting, partner level, contact | CODE + WEEK + NEW | Attrs.SESSION_ATTRS["sparring"]; SparSet (WEEK); NEW split, partner level, contact x1.5 |
| Habits as work | CODE + WEEK + NEW | HabitFix; Recruit.HABIT_WEEKS; pad places (WEEK); NEW HabitWork |
| Own tape | CODE + NEW | WeekPlan.EVENINGS["film"] |
| Weight to the last day | CODE + WEEK + NEW | WeekPlan.day (ALLOWANCE, CUT_DEFICIT, head_cut, TAPER_KG); NEW Lean, Cut x0.9 |
| Season strip | CODE + WEEK + NEW | WeekPhase.phase; SeasonPath; SkillAwards; NEW SeasonStrip; StandDown |
| Firing by tier | CODE | FireLevel (switch on in GameSwitches.GAME_ON) |
| Coach runs it | WEEK + NEW | CLUBWEEK bout bill |
| Ana's class kinds | CODE + NEW | NoGi 3.2 a week |

### 6b. Changes to the sister maps (carry into their next versions; nothing here adds a meter)
- CLUBWEEK: THE LEGS SCALE: tiredness over 50 costs 2 a point (was 1), that part at most 20, the whole at most 25 off as now; Legs is the
  energy tank at the first bell (F5). The fight-week shapes ARE this tab's loads: Rest up = Easy, Tick over = Sharpen, Train through = Normal;
  their Legs come from the week as laid, not a fixed "about 8" and "about 12" (for Samira this month all three leave Samira at 100). Pull sizes
  read the 14 ceilings (F2a) and the opponent's tests (T18). The pair picker prints partner level (T4) and greys a fighter in a stand-down
  (T32). The usual and safe numbers on Club week rows read WORK (F4).
- FIGHT LINK: one Legs rule, NOCAMP1's, on F5's scale (LEGS1 is NOCAMP1's unit test). Every line the fight map prints on a fighter's row
  reads that row's own number (F3: "Cardio" = Stamina). The readiness "sharp" input (M6) is met by Sharpen or Train through with 1 pad place in
  the last five days.
- RPG layer: coachability's lines gain the habit step (T7); the "what your picks won" ledger takes one line from SEASON SO FAR (T20); goals can
  name any of the 14 abilities (F3).

## 7. Every decision
B = before the week, D = during, A = after. The last column is the designer's test (never printed).
| When | Decision | Options, costs and gains (each priced in the other panels, T24) | Right when |
|---|---|---|---|
| B, Monday | The load, carried (T1, T30) | Easy: tiredness low, points slower, the goal may slip. Hard: points sooner, safe work up over a block, overreach from a tired start, injury up. Sharpen: keeps the fast abilities, clears tiredness, few points. Each shows this week and the block | Hard: a block 3+ weeks out from a fresh start, when the block reaches a line the target needs. Sharpen: fight week, a deload. Easy: after a bout, hurt, Low mood |
| B, a fight week | The shape = the load (6b) | Rest up (Easy) / Tick over (Sharpen) / Train through (Normal), read on the 13-day chart | Sharpen unless the opponent fades late (Rest up) or the goal is due (Train through) |
| B, any week | A deload on the strip (T9) | a Sharpen week: tiredness clears, the fast abilities kept, a fifth of the points | the week before a fight week after 2+ Hard weeks |
| B, Monday | Which ability the mornings build or dose (T15, T16, T18) | build where room is FAST and the opponent tests; dose what is fading | engine early, speed kept to the bell |
| B, Monday | Follow the opponent or the season (T18) | Coach's lean toward the opponent's tests, or the season's weak spot | the bout is the season's target, or a step-up |
| B, Monday | The niggle (T19) | Rest it (the habit and cards on that hand pause) / Push on (that part x3) | Push only when the paused work is worth more on the bout than the risk |
| B, after a bout | Spar anyway in a stand-down (T32) | that night's sparring (a habit step, a line) / a head-knock roll, out 14 to 21 days | almost never; only in the fine band with a bout 3+ weeks off |
| B, an injury | Train around / full rest (T19) | the rest at full / back 20% sooner | full rest only when the 20% reopens a bout |
| B, Monday | Morning exceptions | any morning and its pace; break the pattern at x1.5 | a team-mate in the room, a weigh-in, a dose |
| B, Monday | Each pad place's card (T5, T10, T2) | a new move, a tier, the habit, a keep-it card, bringing a date before the bout | a card within 2 places of a tier or a line; the habit the opponent punishes |
| B, Monday | The diet (T8) | Hold / Lean / Cut (x0.9), each with its last day's Legs at that weigh-in's hour | Lean 4+ weeks out; Cut 2 to 4 weeks out and over 0.5 kg; earlier for a same-day scale |
| B, Monday | Overrule the fighter's ask (T26) | the Hard week at mood -5 | the Hard block's line is worth more than a mood step |
| D, after a sparring night | The mid-week niggle (T13, T19) | rest it from Friday / push on | as T19 |
| B, no bout | Film: your own tape (T6) | 2 pad places; a habit 1 in 2 | Known Skills low, or an unexplained loss |
| B, Monday | Coach runs this fighter (T11) | your sessions freed, Known stops | that fighter's size is under 1 in 100 |
| B, a phase change | Keep my changes into the next phase (T13) | your exceptions carry | they still have a reason |
| B, Monday (Ana) | Each class kind (T12) | drill / positional / hard rolls | Hard rolls inside 14 days of an open |
| A, the Why and Monday | "Put the habit card on", "Sharpen next week", "Rest the hand", "Train X" | one click into the Training tab with it set | the Why names a cost the week can fix |

## 8. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > Training (drawn) | header (goal on an ability, Recovery); the strip (blocks, Sharpen, Legs on bout days, safe work, the stand-down); the LOAD (four buttons, work and clock, two horizons, the pattern, usual and safe work, the fighter's ask, one Legs line); BODY (niggle answers cross-priced); the week (session, pace, who + lift, reason; gold on your changes; locked sparring with its reason); ABILITIES (sorted by worth against the opponent, the tested column, room to its own ceiling, next line with day and after-the-bout tag, 4-week trend, the dose that keeps it); PAD PLACES (dates, after-the-bout price, the habit with its hand, a fading card priced in what it displaces, the move ceiling); SAT 28: WHAT THIS WEEK BUYS; THE 13 DAYS TO THE BELL; WEIGHT with the weigh-in's hour; Keep my changes, Back to Coach's week, Coach runs it, Season so far, Back to Club week | WeekBoard, WeekEditors, WeekTiles, WeekDay, WeekCards; WeekPlan, Injuries, InjuryRoll, TrainingLoad, PadWeek, MoveMastery, FireLevel, Recruit, AttrGen, Knowledge, BoutRules, Exchanges, Duels, PerkRoad, Attrs, CoachAreas, FighterGoal, PushBack, WeekCause, SkillAwards; NEW TrainWeek, Detrain, OppTests, Niggle, TrainAround, HabitWork, SeasonStrip, StandDown |
| Fighters > Club week | each row: the load chip (and the fight-week shape under its CLUBWEEK name), the diet, the habit chip, a red niggle chip, a stand-down chip, "Coach runs it"; pull sizes with ceilings and the opponent; partner level on the pair picker | ClubDeal, LeverSize (WEEK), Niggle, OppTests, HabitWork, StandDown |
| Fighter page > Condition | the long tiredness curve with 70 and 80; Legs on the next bout day; usual and safe work; the injury and its answer; the stand-down | WeekTired, SeasonStrip, TrainAround, StandDown |
| Fighter page > Profile | room to its own ceiling, next line, the trend, the dose and fading in amber; the habit's state | AttrBoard, Recruit, Detrain, HabitWork |
| Fight prep and the bout sheet | what the opponent tests; the habit's worth; the diet's last day at the weigh-in's hour; the Legs on F5's scale; "a step-up teaches twice as much" | FightPrep, OppTests, HabitWork, WeekPlan, SeasonStrip, BoutRules.legs |
| Fight night | the habit at its state; Legs as the first bell's tank; the round-3 fade from Stamina | HabitFix, BoutRules.legs, LiveRound |
| Result and the Why | the habit's cost; Legs at the bell and what the strip did; Fight IQ and Composure taught; "Rest the hand"; the stand-down and its day | FightWhy, WhyCard, SeasonStrip, AfterFight, Niggle, StandDown |
| Week review (Monday) | whole points with causes, lines crossed, fades, niggles answered, habits moved, the trend's new numbers | WeekReview, ReviewReveal, WeekCause, Detrain, Niggle, HabitWork |
| Playbook | "fires 1 in 2: Usable" beside each line; fading cards; a card at its move ceiling | PlanLines, FireLevel, MoveMastery |
| Grappler page | class kinds with stripe dates; niggle; Cardio's dose; usual work | GrapplerPage, NoGi, Niggle, Detrain |
| Coach's notes | habits and traits found, and where | CoachNotes, HabitWork |
THE NEW MECHANICS, MENU BY MENU (each shows on every menu listed, in the .exe, and the golden-path test walks it):
| Mechanic | Menus |
|---|---|
| F1 to F6 foundations | no menu of their own: every number below reads them; the golden path asserts each (section 11) |
| T1 load in work, carried; T30 two horizons; Sharpen; pattern | Training, Club week, Condition |
| T31 the 13 days to the bell | Training (the long curve on Condition) |
| T14 Legs on every bout, one scale; work capacity | Training, Condition, Club week, bout sheet, fight night, the Why |
| T32 the stand-down | Training (strip, locked nights), Club week, Condition, the Why |
| T15 fade by dose | Training, Profile, Week review, Playbook, Grappler page |
| T16 room to its own ceiling | Training, Profile, Club week, signing card |
| T17 next line (one row one number); T2 after-the-bout tag; the move ceiling | Training, Profile, Week review, Playbook |
| T18 opponent tests and the sort | Training, Club week, Fight prep |
| T19 niggles cross-priced; the mid-week stop | Training, Club week, Condition, Week review, the Why, Grappler page, the top bar's stop |
| T23 what this week buys | Training (the bout page's bill shows the same one number) |
| T25 goal on any ability, T26 voice, T27 grade and pace, T29 Recovery | Training (goal also on the header everywhere it is today) |
| T20 trend and season so far; T21 bouts teach; T22 pro camp | Training, Profile, Week review, RPG ledger; bout sheet, the Why; the professional's camp card |

### 8b. The same frame for the other three (drawn before the Cursor brief, build step 4)
| Panel | Lucy, the professional (camp, 4 rounds) | Ana, the grappler (mat week) |
|---|---|---|
| Strip | BUILD / PEAK / TAPER; the taper laid as Sharpen; "Legs 98" on fight night | classes a week, opens every 35 days, "stripe Mon 6 Apr" |
| Load | Easy / Normal / Hard / Sharpen, two horizons to the fight; the camp's intensity (CODE) stays on the camp card; "Cardio 64: no fade in rounds 3 and 4" on the Cardio row (T22) | class kind per class: DRILL / POSITIONAL / HARD ROLLS, each with its stripe date (T12) |
| 13 days | the camp's last 13 days with the weigh-in the day before | the 13 days to the open |
| Body | niggle as boxers; the stand-down after the debut | the strain card after 3 hard-rolls classes |
| Abilities | sorted against the booked name; 14 ceilings; the weigh-in the day before: "24 h to refill" | Ana's six (Strength, Cardio, Flexibility, Explosiveness, Composure, Aggression, CODE) with doses; no ring lines, the mat's own (owned at 30, signature 50) |
| Buys | "FRI 20 MAR: WHAT THIS CAMP BUYS" with PEAK CAMP's three lines (CODE) | "THE OPEN: WHAT THIS WEEK BUYS": open prep +1 a hard-rolls class (at most +4) |
| Weight | the professional class, the day before | the open's division |

## 9. Numbers: from the code, or ESTIMATE
FROM THE CODE: the gain rule and headroom; the shares (section 0, read from Attrs.train); Recruit's class bias (+6 / -6) and AttrGen's tilts;
intensity 0.6 / 1.0 / 1.3 and load 0.6 / 1.0 / 1.5; session minutes and RPE (WeekPlan.SESSIONS, EVENINGS: pads 75 at RPE 5, sparring 30 at
RPE 7); Coach's base week 2,607 effort-minutes (7.97 h); tiredness 0.87 (Recovery 0.70 to 0.95) and 44 and 80; the 42-day usual (0.1535 a
week); the 1.3 / 1.5 lines and x3; fatigue_mult from 72; the injury base (re-anchored to 1.04 in 100 at work 100, which is today's number for
Coach's week); the training injury types; rest x0.25; kcal by MET, -500 cut and TAPER_KG; mastery 2.1 a pad hour and -0.75 a week; the move
ceiling; the call grades; IQ_FINDS 65; the perk needs; the style weights; Attrs.VALUE; CoachAreas lifts; FighterGoal's mood and trust;
PushBack's 50, 68, 75; HABIT_COST 6; FireLevel's shares; the energy tank 100 and 2 a point over 50, at most 20 (F5 keeps it); the fade line
64 (F3 moves it to Stamina); KO_DAYS 30; the head place from damage x 2.2.
ESTIMATE (each set by a probe): the half-tilt in the 14 ceilings and its +/-8 hold (CEIL14 in PACE1); Footwork drills' share (PACE1); the
doses, holds and fade rates; the Sharpen layout; the pattern's x1.5; contact x1.5; the stand-down's 5 / 10 / 21 days and the spar-anyway
2 / 6 in 100; the day-before refill rate; the niggle triggers and per-hand pauses; train-around's 20%; OppTests' multipliers; habit 3 + 3
pad places; own tape 1 in 2; Lean -250; Cut x0.9; bouts teach 0.5 / 1; partner level x1.2 / x0.8; Ana's class kinds. Samira's numbers in the
drawing (work 59 / 75 / 96 / 44, the clock, the tiredness days, the peak 73 and 80.2 from a tired 61, Legs 100, the horizons) were worked by
hand from the code's tables (the Normal week's sum is in T1); the built tab reads them from the run (T24).
ON SCREEN: a size in wins in 100 is printed only once its probe has reported (CLUBWEEK's rule); before that, the row prints the thing itself
(Legs 100, HALF FIXED, Usable Mon 2 Mar, Cardio 64 Fri 3 Apr) and no number.

## 10. To be measured (the foundations' tests first, one gate, then the rest in one batch)
THE CUT RULE (as CLUBWEEK): a choice worth under 1.5 wins in 100 on the bouts it touches AND with no season effect is cut, not drawn.
EVERY PROBE RUNS TWICE: on the AMATEUR FIGHT WEEK (12 days' notice, no camp, NOCAMP1's Legs in) and on the professional's camp.
EVERY PROBE RUNS ON THE FIXED ENGINE: nothing below runs before F1 to F5 are merged, or it measures the defects.
- FOUNDATION UNIT TESTS (section 0), each red on main today: REST1, CEIL14, GAIN14, CARDIO1 (with FADESHARE: the share of amateur bouts with an
  own round-3 fade on 400 bouts stays within 5 points of today's; if not, FADE_STAMINA moves to the value that keeps it), LOADWORK1, LEGS1 (in
  NOCAMP1), STANDDOWN1.
- FOUNDATION PROBE: PACE1 (F7), before any date is drawn again.
- THE GATE, TRAINSEASON1: a careful player against "Coach runs it" for all four over a season: 4+ in 100 on the season's bouts, or the
  season target 4+ weeks sooner. Else the map is cut back.
- THEN: FITLEGS1 (on F5's Legs, "Hard, Hard, Sharpen, bout" beats "Hard, Hard, Easy, bout" by 1 in 100 or more, else Sharpen folds into Easy
  and the taper goes back to Light, keeping the volume cut; and beats "Normal throughout"; "Hard to the bell" loses); DETRAIN1; TANKPRICE1
  (CLUBWEEK's); HORIZON1 (T30: the block line the button prints is reached in the played season 8 times in 10).
- THEN, ON THE PLAYED BOUT: LINES1, OPPTEST1, NIGGLE1 with TRAINAROUND1, HABITWEEK1, FIRELEVEL2, PATTERN1.
- THE SMALL BATCH (one run, each line cut if under the rule): MORNINGS1, SPARTRAIN1 (contact x1.5), SPARLEVEL1, STANDDOWN2 (the bands' days
  against re-injury), OWNTAPE1, LEANCUT1, WEIGHHOUR1, COACHRUNS1, BOUTTEACH1, PROFADE1, BJJCLASS1.

## 11. Build order, in small tasks
1. THE FOUNDATIONS FIRST, one task each, in this order (section 0): F1 REST1 (Attrs.gd); F2a CEIL14 (Recruit.gd); F2b GAIN14 (WeekPlan.gd,
   Attrs.gd, Sim.gd); F3 CARDIO1 (LiveRound.gd, BoutRules.gd, BoutRead.gd, FighterGoal.gd); F4 LOADWORK1 (WeekPlan.gd, Injuries.gd,
   TrainingLoad.gd, InjuryRoll.gd); F5 LEGS1 inside the fight link map's NOCAMP1 (BoutRules.gd, BoutNight._peak); F6 STANDDOWN1 (StandDown.gd
   NEW, PadWeek.gd, Injuries.gd). Each: parse gate, its one test red on main then green, and the tests that play the path it touches. F2b and
   F4 both own WeekPlan.gd: one after the other, never two seats at once. Then F7 PACE1 (cloud probe).
2. Probes (cloud, pure): FITLEGS1, DETRAIN1, TANKPRICE1, HORIZON1; then the played-bout six; then the small batch. Each writes the table
   LeverSize reads. TAPER1 (WeekPhase.WEEKS taper laid as Sharpen) waits for FITLEGS1.
3. Rule modules with unit tests, one a task: TrainWeek.run (the one run and the horizons, ONERUN1); Sharpen and Pattern in WeekPlan; Detrain.gd
   (dose); OppTests.gd (with the sort); Niggle.gd (hand per card); TrainAround.gd; HabitWork.gd; SeasonStrip.gd; the weigh-in hour; bouts teach in
   AfterFight; partner level; NoGi class kinds; FireLevel on in GameSwitches.GAME_ON; TrainingPlan retired.
4. Draw Lucy's camp and Ana's mat on this frame (8b); then the Training tab from `training_v2.png` (Cursor), then the other menus, one a task.
5. THE REVEAL ORDER IS A BUILD RULE (reviewer 2's point 12), each with its golden-path step: week 1 shows the load (two horizons), the strip and
   room to grow; the 13-day chart with the first booking; the first niggle with the first Hard week; the opponent's sort with the first
   booking; fades from week 3; Sharpen with the first fight week; the stand-down with the first bout; "Show all 14" folded until week 3.
6. The golden path: Samira's Monday: the load card's work equals Injuries.week_work and its clock is the sessions' minutes; the Normal week's
   cells print their pace; Hard picked (the ask shown, overruled at mood -5), the chart's line crosses 80 on Thursday, and back to Normal; the
   Hard horizon reads "Cardio 64 Fri 3 Apr"; the hand niggle rested and the habit's state on Sat 28 read HALF FIXED in the buys panel; Check
   hook brought forward by a pad place with Lucy's Club week row going short; Lean picked with the regional's day-before hour; a Sharpen fight
   week with Stamina unchanged by its rest days (F1); the bout with a non-zero Legs row when tired on a no-camp amateur bout (F5); the round-3
   fade read from Stamina (F3); the stand-down locking the next Thursday's sparring (F6); the Why's "Put the habit card on"; the next Monday's
   review naming the whole points, the trend, one fade; Ana's class kinds before an open.

## 12. Every critic point, and where it went
| Round 4 critic point | Where |
|---|---|
| S&C 1: the injury hours ignore effort; one unit for tiredness, ratio and injury; work, with clock beside | F4 LOADWORK1, T1, T14 |
| S&C 2: rest drains Stamina; fix before FITLEGS1 and DETRAIN1 | F1 REST1; section 10 (probes on the fixed engine) |
| S&C 3: one ceiling per ability must reach the gain; Footwork and Inside need their own | F2a CEIL14, F2b GAIN14, T16 |
| S&C 4: Cardio must mean one thing; the goal reads the same number | F3 CARDIO1, T17, T25 |
| S&C 5: settle the Legs scale with NOCAMP1; a test with or without a camp | F5 LEGS1, T14, 6b |
| S&C 6: return to sparring after a bout | F6 STANDDOWN1, T32 |
| S&C 7: the 12-day chart with the Hard ghost line; each cell shows its pace | T31, T13, the drawing |
| S&C 8: a hidden load tolerance | LEFT FOR LATER (with its reason) |
| S&C 9: draw Lucy's camp and Ana's mat on the frame | 8b, build step 4 (the frame is specified; drawn before the Cursor brief) |
| S&C 10: probes on the fixed engine; keep Sharpen's shape if FITLEGS1 folds its size | section 10, FITLEGS1 |
| S&C: "Normal 7.4 h" cannot be rebuilt from the drawn week | T1 (the Normal week's sum: work 75, 6 h 15) |
| Reviewer 1a: rest stops taking Stamina; REST1 | F1 |
| Reviewer 1b: one word, one number; FADE1 | F3 (CARDIO1 is that test) |
| Reviewer 2: a pace probe before pixels; Footwork drills at full | F7 PACE1, section 0's pace line, the redrawn dates |
| Reviewer 3: two horizons on every load button | T30, T1, the drawing |
| Reviewer 4: per-ability ceilings with a shape | F2a (class bias + archetype tilt), F2b |
| Reviewer 5: a trend column and a coach's report | T20 (the trend column); the coach's report LEFT FOR LATER |
| Reviewer 6: one mid-week stop | T13 (the niggle after a sparring night only) |
| Reviewer 7: show the move ceiling on the skill rows | T17, T10 |
| Reviewer 8: discipline scales every session | LEFT FOR LATER (DISCIPLINE1 first) |
| Reviewer 9: mentoring on the pair picker | REJECTED (partner level already does it) |
| Reviewer 10: say the Legs change for the professional | F5 keeps 2 a point: the professional's camp is not cheaper |
| Reviewer 11: goals on abilities | F3 (FighterGoal keys to the 14) |
| Reviewer 12: the reveal order as a build rule | section 11 step 5 |
| Reviewer small: NEAR CAP under 4 is not the floor; pads 75 vs 240 minutes; habit cards not drilled today | T16 (2.5), section 3 (two clocks named), T5 (tagged NEW) |
| Rounds 1 to 3 | v4's answers kept (T1 to T29) |

## REJECTED (asks not taken, and why)
- FITNESS AS THE TOP OF LEGS (v3's own T14, withdrawn in v4): a second fitness beside Cardio.
- "CARDIO (STAMINA + RECOVERY)" AS ONE ROW (the other half of reviewer 1's point 4 and S&C 4): two numbers under one word; v5 makes Cardio
  Stamina and gives Recovery its own row, which is truer to the sport and keeps one word per concept.
- LEGS AT 1 A POINT (CLUBWEEK v4.1): it would halve what tiredness costs a professional today without a measurement; the code's 2 a point is
  kept and the amateur fight week now pays it too.
- WORK SHOWN AS RAW EFFORT-MINUTES ("work 1,959"): a number with no anchor; 100 = Coach's base week reads at a glance, with the clock beside it.
- A FIFTH LOAD FOR THE FIGHT WEEK: in a fight week the load IS the shape (6b).
- HARD IN A FIGHT WEEK: not offered; Train through (Normal) is the most a fight week takes.
- A FIXED LEGS COST PER SHAPE ("about 8", "about 12"): the Legs come from the week as laid.
- A THIRD NIGGLE ANSWER ("pads only"): the per-hand pause already keeps the other hand's cards.
- NEW FIGHT LINES FOR DEFENCE, SPEED AND FOOTWORK: the fight already grades the calls on them (Exchanges.grade).
- MOVING THE FADE LINE WITH THE ROUNDS: the fade already hits every round from the third; shown instead (T22).
- FITNESS AND TIREDNESS AS TWO BARS: one Legs bar; the long curve lives on Condition, the 13 days on the tab.
- A FIXED SUPERCOMPENSATION BONUS AFTER A DELOAD: the payoff comes from the code's two time constants and Sharpen's dose.
- COACHABILITY AS A MULTIPLIER: lines at 40 and 70 (T7).
- TRAIN THROUGH AN INJURY: an injury already closes bouts; push on is for niggles only.
- A STAND-DOWN THAT CANNOT BE BROKEN in the fine and hurt bands: a coach can overrule, at a priced risk; past a stoppage it cannot (CODE).
- MENTORING (the professional teaching an amateur Composure on the pair picker): partner level (T4) already makes a stronger partner teach
  x1.2; a second rule for the same pairing would be a second estimate.
- MORE THAN ONE MID-WEEK STOP ("it clicked", a skipped morning): one stop, for a niggle, is the smallest form that changes a decision; the
  others show on Monday's review.
- MOOD ON ANA'S MAT GAINS; A ROW SAYING A MOVE "DROPS TO LEARNING"; A LETTER GRADE PER CELL; SORTING BY THE MULTIPLIER ALONE: as in v4.
- STALENESS AND "IT CLICKED" WEEKS; A SEASON STORY CHART; ONE FOCUS A MONTH; PLYOMETRICS AS AN ELEVENTH MORNING; PER-MORNING INTENSITY AS THE
  MAIN CHOICE; PAD PLACES SPLIT 70/30; A WHITE BELT TEACHING: as in v3.

## Risks, said plainly
- F2b changes every gain in the game the moment ceilings differ. GAIN14's part (a) proves it gives today's gains at equal room; PACE1 then
  shows how much slower a near-cap ability gets. If the four fighters' season points fall by more than a fifth, the half-tilt shrinks.
- F3 changes who fades in round 3 (Stamina is not the mean). FADESHARE holds the share of fading bouts where it is today.
- F4 re-anchors the injury chance so Coach's week reads today's number; a week heavy on sparring now reads higher than before (that is the
  point). If the season's training injuries rise by more than a fifth, the contact x1.5 is the first thing cut.
- F2b and F4 both touch WeekPlan.gd (347 lines): one task after the other, and F2b's growth is kept under 40 lines.
- LiveRound.gd (494) and BoutRead.gd (497) sit at the 500-line rule: F3 is a one-line swap in each, never an addition.
- More rules again on one tab. The reveal order (section 11 step 5) carries it.
- Before NOCAMP1 lands, Legs do nothing on an amateur bout, so the Legs line is hidden for amateurs until it does.
- Fade can feel like punishment: never more than 3 points under the season's best, and every fading row names the one session that stops it.
- Many next-line dates will read a month or "next season" once the run prints them (reviewer 2's warning). T30's block line is the answer: a
  line out of reach this week is often in reach of a block, and the button says which. If PACE1 shows fewer than 3 of the top 8 rows reachable
  in a season at a focused load, the named shares rise (F7), not the dates.
- FireLevel changes every plan's numbers: FIRELEVEL2 first; a good plan must stay 55+ in 100.

## TRAINING FOR THIS VERSION
0. THE FOUNDATIONS: rest keeps Stamina; 14 shaped ceilings reaching the gain; Cardio is Stamina; the load in work; one Legs scale; the stand-down.
1. THE LOAD, CARRIED, in work: Easy, Normal, Hard, Sharpen, each with this week and the block to the next target, from one run.
2. LEGS ON EVERY BOUT on one scale; work capacity as the slow reward; fitness is the abilities.
3. THE 13 DAYS TO THE BELL: work, tiredness day by day, the Hard ghost, Legs and their parts.
4. SHARPEN: the taper, the deload and the fight week keep the pace and cut the sessions.
5. FADE BY DOSE: one session in each ability's window keeps it; the kept-by column reads the plan.
6. ROOM TO GROW: each ability's own shaped ceiling, on screen.
7. THE NEXT LINE per ability with its day (one row, one number), flagged after the bout, with the price of bringing it forward; the move ceiling.
8. THE OPPONENT SORTS THE BOARD: worth a point x what this opponent tests; Coach leans toward it.
9. WHAT THIS WEEK BUYS for the next bout, and every option priced in the other panels.
10. NIGGLES FROM THE LOAD, cross-priced, the one mid-week stop; injuries trained around; the stand-down after a bout.
11. WEIGHT to the scale's day and its hour.
12. THE PERSON: the goal on any ability, the fighter's ask on the load, coachability's habit steps, Recovery shown, the coach's grade and pace per cell.
13. THE SEASON STRIP and the TREND; bouts teach a little; ten mornings one job each; sparring by setting and partner; own tape; pad time past
    Usable; Coach runs it; Ana's class kinds.
Built already and kept: the gain rule, phases, tiredness and the 80 line, the injury model, kcal and weight, pad nights and the move ladder,
peak camp, perks, the awards, the professional camp.

## LEFT FOR LATER
- A HIDDEN LOAD TOLERANCE (fragile / normal / durable, injury x1.3 / 1.0 / 0.8, found after two Hard weeks; S&C 8): a good discovery, but it
  is a third estimate on an injury chance that F4 has just re-anchored and SPARTRAIN1 has not yet measured. After F4's season injury count.
- DISCIPLINE SCALING EVERY SESSION (0.85 to 1.15; reviewer 8): it moves every price on the tab at once; DISCIPLINE1 (one season, all four) must
  show it changes a decision before it enters. Discipline keeps its skip line (T7) meanwhile.
- A COACH'S REPORT whose accuracy follows the coach's area rating (reviewer 5, second half): needs the RPG's Known rules for the coach.
- Moving up a class (the owner's call in CLUBWEEK section 12).
- Scars and age: past injuries raising risk, a fighter's prime and decline (RPG LEFT FOR LATER).
- Crossover training (a boxer learning to grapple) waits for the crossing rules.
- Strength-and-conditioning staff running mornings as a third coach.
- Altitude, travel camps, nutrition plans beyond the three diets, sleep.
