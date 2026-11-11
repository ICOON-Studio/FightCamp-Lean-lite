# TRAINDEPTH1: the training map, v4 (S432)

The owner's question: "how deep are the training mechanics ? have critics rated them ?"
Round 1: two blind critics scored the training as built 5 and 5 (`docs/mockups/s432/critics/train_coach_review.md`, `train_sim_review.md`).
Round 2 (map v2): 7 and 6 (`tr2_player_review.md`, `tr2_sandc_review.md`). Round 3 (map v3): 6.5 (a sports scientist,
`tr3_science_review.md`) and 7 (a Football Manager player development lead, `tr3_fm_review.md`). The bar is 7 from both.
v4 takes both round-3 lists to 10, item by item (section 12). The scientist proved four errors in the load-fitness-taper core;
v4 fixes those FIRST, each checked in the code (section 3), then answers the FM designer.
Scope: four fighters (Lucy the professional, two amateurs, Ana the grappler), amateur to a first professional fight.
Builds on, never rewrites: CLUBWEEK v4.1 (`ops/research/CLUBWEEK_MAP_V41_S432.md`), the RPG layer v3 (`RPG_LAYER_MAP_S432.md`) and the
fight link map (`FIGHT_LINK_MAP_S432.md`, revised in parallel). Where v4 changes one of their rules, it says so in 6b (one line each).
No second meter for anything.
Words: "You" is the head coach, the player. "Coach" is the hired assistant coach. "Cardio" is the stamina group. Game text never says he,
she, her or him. Drawn: `docs/mockups/s432/training_v2.png` (the Training tab, Samira Khan, Monday 16 Feb, week 7, the hand rested).
TAGS on every effect: CODE = in the game's code today (file and name given, read for v4); WEEK = designed in an agreed sister map (Club week
v4.1, the RPG layer v3 or the fight link map), not built; NEW = new in this map.

## 1. What v4 changes, in one line each
THE FOUR ERRORS, FIXED FIRST (scientist 1 to 4):
- THE LOAD IS PRICED ON THE HOURS THE GAME USES: WeekPlan.hours over PadWeek.evenings for the week as laid out (Injuries.week_hours,
  CODE). The old TrainingLoad.SETTINGS table (6 / 10 / 15 h) and its START_HOURS 10 are retired (T1, LOADHOURS1).
- NO SECOND FITNESS. "Fitness = 55 + 4 x hours" is dropped. Fitness = the abilities (built slowly, lost by fade); tiredness = the
  week's tiredness (CODE week_fatigue), shown only through LEGS. The usual hours show as WORK CAPACITY: how much is safe next week (T14).
- THE TAPER KEEPS INTENSITY AND CUTS VOLUME: a fourth load, SHARPEN (about half the sessions, every one at Hard pace), is the taper, the
  deload and the amateur's fight week. The code's Light taper changes to it (T1, T9, TAPER1).
- LEGS ON EVERY BOUT, AN AMATEUR FIGHT WEEK TOO: one rule with the fight link map (its NOCAMP1): CLUBWEEK's Legs bar replaces
  BoutRules.stale_energy (0 without a camp, CODE) on every bout (T14).
THE REST OF THE SCIENTIST'S LIST: fade needs a DOSE, not one touch (T15); the hard-easy pattern kept, monotony priced (T1); the weigh-in's
timing priced (T8); Recovery shown (T29); the drawing matches the rules (whole points, the 14 abilities, move names from the data);
probes on the amateur fight week too (section 10).
THE FM DESIGNER'S LIST: every option priced in the other panels' terms from ONE run of the week (T24); a panel, "SAT 28: WHAT THIS WEEK
BUYS" (T23); every date past the next bout flagged with the price of bringing it forward (T2); abilities sorted by worth against the booked
opponent, the tested multiplier as a column (T18); the goal on the header and its row (T25); the fighter's voice on the load (T26); the
coach's grade on each coached cell (T27); amateur words and a "keeps" column that reads the plan (T9, T15); probes before pixels; the
professional's camp and Ana's mat specified on the same frame (section 8b); the sparring partner's level (T4).

## 2. The idea in ten lines
1. ONE LOAD A WEEK: Easy, Normal, Hard or Sharpen per fighter, priced in hours against the usual, injury, Legs on the next bout, the goal
   and the first whole point, all from one run of the week.
2. FITNESS IS THE ABILITIES; TIREDNESS IS LEGS. A run of Hard weeks raises what is safe next week (work capacity), not a second bar.
3. SHARPEN, NOT REST: the taper and the deload keep the pace and cut the sessions, so Speed and Explosiveness do not fade in fight week.
4. FADE BY DOSE: each ability is kept by one session in its window (Speed a week, skills 10 days, Cardio and Strength 14 days).
5. ROOM TO GROW: each ability grows by its own distance to its own ceiling.
6. LINES, NOT DECIMALS: every row names the next thing a point changes in the ring and its day; a day after the bout says so, and what
   bringing it forward costs.
7. THE OPPONENT SORTS THE BOARD: abilities in order of worth against the booked name; Coach's week leans toward it.
8. THE BODY TALKS FIRST: a niggle from your own load, each answer priced in the habit, the moves and the bout.
9. WEIGHT TO THE LAST DAY, and the weigh-in's hour: a day-before scale gives 24 h to refill, a club scale 3.
10. A SEASON YOU CAN READ: the strip ahead (blocks, Sharpen, Legs on bout days, safe hours) and the ledger behind.

## 3. The training as built (traced in the code for v4)
| Part | What the code does | Where |
|---|---|---|
| Mornings | 10 sessions; each a fifth of a focused week (SESSION_SHARE 0.2) x Light 0.6 / Normal 1.0 / Hard 1.3; x0.6 at tiredness 80+ | WeekPlan.SESSIONS, INTENSITY, TIRED_GAIN |
| THE WEEK'S HOURS (USED) | mornings: minutes x the intensity's load (Light 0.6, Normal 1.0, Hard 1.5); evenings: pads 75 min, sparring 30, at face value (the taper's pads x0.5) | WeekPlan.hours, read by Injuries.week_hours over PadWeek.evenings(f, false) |
| What that gives | the coach's base week (WeekPhase.WEEKS base, 3 pad nights, 1 sparring) = 7.97 h; every morning Hard + PadWeek's 4th pad night = 11.4 h; all Light + 2 pad nights = 5.4 h (checked by hand from the tables) | WeekPhase.WEEKS, PadWeek.NIGHTS |
| THE STALE TABLE (DEFECT) | TrainingLoad.SETTINGS (rest 3, light 6, normal 10, hard 15 h) and START_HOURS 10 still feed TrainingLoad.ratio(setting), camp_default and a new fighter's usual; Injuries uses 3.0 h for a rest week | TrainingLoad.gd, Injuries.gd 199 |
| The usual load | an average of the week's hours over about 42 days (EWMA 0.1535 a week); starts at 10 h, so every new fighter's first weeks read 0.8 of usual | TrainingLoad.next_chronic, fresh_chronic |
| Injury | 1.3 in 100 a 10 h week, x hours; ratio to the usual: x1 to 1.3, x3 from 1.5; x1 to x3 by the week's peak tiredness from 72 to 80; types hand 40, ribs 30, strain 30 | InjuryRoll.training_chance, load_mult, fatigue_mult |
| Tiredness | keeps 87% a night (FATIGUE_KEEP); Recovery moves it 0.70 to 0.95 (Recovery 50: 0.885, clears 12% a night); 44 load points a point; 80 = overreached | WeekPlan.fatigue_keep |
| LEGS AT THE BELL (DEFECT) | stale_energy: 2 energy a point of tiredness over 50, at most 20, BUT 0 when camp.protocol < 1 - so no amateur fight week (no camp) pays for tiredness | BoutRules.stale_energy, read in BoutNight._peak |
| The taper (WRONG WAY ROUND) | WeekPhase.WEEKS taper: roadwork Light, shadow Light, rest, speed bag Light, roadwork Light, rest, rest: it cuts intensity, the opposite of the evidence | WeekPhase.WEEKS["taper"] |
| Two Hard mornings running | the second is flagged red | WeekPlan.week "red" |
| One potential for all (DEFECT) | Sim.week_ctx passes `"pot": int(f["pot"])`; WeekPlan.day / full_day read only that. Recruit.ceiling (pot +6 on the class's strength, -6 on its gap) is read only by RecruitPanel | Sim.gd 120, WeekPlan 166 and 252, Recruit.ceiling |
| While injured | every morning and evening becomes rest; gains x0.25 | Sim.step_day, Injuries.gain_mult |
| Body cards | "sore wrist" (bag mornings become shadow) and "tight knee" drawn AT RANDOM; "you pushed through the warning" | WeekTwist, InjuryRoll.training_cause |
| Fade | moves only: -0.75 mastery a week not drilled; Usable (30) kept for good. Abilities never fall | MoveMastery.decay_week |
| Fight lines | Power past 60, Technique past 61, Cardio under 64 fades from round 3; calls graded on the mean of their needs: Good 62 (x1.0), OK 50 (x0.6), Poor (x0.3); Fight IQ 65 finds the answer; the 8 perk needs | BoutRules.NIGHT_LINES, LiveRound 65, Exchanges.grade, IQ_FINDS, PerkRoad.PERKS |
| What a style asks | each opponent style plays four games by weight; each place's tools name the abilities that answer them | Exchanges.STYLE_MODES, MODES, CALLS; Duels.TOOLS |
| Worth of a point | +10 on each ability against the reference field: Defence 0.090, Footwork 0.085, Speed 0.080, Explosiveness 0.070, Timing 0.060, Durability and Inside 0.055, Strength and Cardio 0.040, Accuracy 0.030, Fight IQ 0.025, Recovery and Composure 0.020, Flexibility 0.015 | Attrs.VALUE |
| Coached quality | five areas (pads, bag, conditioning, strength, sparring), each a rating; printed as "+53%" over training alone (pads: +24% at 60) | CoachAreas.rating_for, pct, pct_for |
| The goal | FighterGoal: a target with a deadline (for example Cardio +2.5 in 28 days); met: mood +10, trust +25; missed: mood -20, trust -25 | FighterGoal |
| The fighter's ask | discipline under 50 asks to ease the Hard mornings; a peak of 68 asks for easier mornings, 75 a day off; heard +5 mood / overruled -5 | PushBack, WeekTwist.ASKS |
| The week's causes | which sessions moved which stat, kept a week | WeekCause, f["week_src"] |
| Your changes | kept while the phase holds | WeekPhase.edits |
| Habits | fixed at signing (4 weeks) or patched for a round; costs 6 power an exchange where punished | Recruit.HABIT_WEEKS, HabitFix.HABIT_COST, PUNISHED_BY |
| Bouts | teach nothing | AfterFight, Aftermath |
| Weight | kcal = MET x kg x hours; Hold = life + 300; Cut -500 (Old hand -620); a cut in the taper sheds 0.05 kg a day more | WeekPlan.day, TAPER_KG |

## 4. Where training is decided (one place each)
| Decision | Screen | Why there |
|---|---|---|
| Who gets the pad places, coached mornings and the seat; the sparring pair and setting; the club twist; the pulls; the season target | Fighters > Club week (WEEK) | shared between the four |
| The LOAD (Easy / Normal / Hard / Sharpen, which in a fight week IS the fight-week shape); morning exceptions; each pad place's card; the diet; the deload; the niggle and the injury answer; Coach runs this fighter's week | Fighter page > Training (this map) | one fighter only |
| Ana's class kinds and the drill | the grappler's page | one fighter |
The Training tab shows the shared slots LOCKED with "change on Club week". Nothing is decided twice. CLUBWEEK's fight-week shape (Rest up,
Tick over, Train through) is the same choice as this tab's load in a fight week (6b): one button, two names never shown together.

## 5. The mechanics
The FOUNDATIONS are T1 (the load on real hours), T14 (Legs on every bout), T15 (fade by dose) and T16 (each ceiling): everything priced on
the tab reads them, so their probes run first (section 10).

### T1. ONE LOAD A WEEK, ON THE HOURS THE GAME USES (fixed in v4)
- WHAT YOU DECIDE: per fighter, per week: EASY, NORMAL, HARD or SHARPEN. Coach lays each on the week's own sessions; a single morning can
  still be set apart in its popover.
| Load | How Coach lays it | Hours (Samira's week, WeekPlan.hours) | Against usual 7.8 h | Use |
|---|---|---|---|---|
| EASY | every morning Light; 2 pad nights; 1 sparring | 5.1 | 0.65 | after a bout, hurt, Low mood; Rest up in a fight week |
| NORMAL | Coach's week (the pulls of Club week) | 7.4 | 0.95 | the default; Train through in a fight week |
| HARD | 3 mornings Hard, never two running (hard, normal, hard...); a 4th pad night | 9.8 | 1.25 | a build block 3+ weeks out from a fresh start; not in a fight week |
| SHARPEN | about half the sessions, every one at Hard pace; pads on half the nights at full minutes; no sparring | 4.8 | 0.62 | the fight week (Tick over), the professional's taper, a deload |
- THE HOURS ARE THE CODE'S: the load card's hours are Injuries.week_hours for that fighter with that load laid (WeekPlan.hours over
  PadWeek.evenings). The usual is Injuries.chronic. Ratio, the 1.3 / 1.5 lines and the injury chance are InjuryRoll's on those numbers.
  TrainingLoad.SETTINGS hours and START_HOURS are retired: a new fighter's usual starts at the hours of Coach's base week (7.97 h,
  computed, not typed); TrainingLoad.ratio(setting) and camp_default read the week's hours. LOADHOURS1 (unit test): the load card's hours
  equal Injuries.week_hours for the same fighter, red on main today (the card would read SETTINGS).
- THE PATTERN (scientist 6): Coach lays a Hard week hard-easy; two Hard mornings running stay the code's red day. A "Pattern" line reads
  VARIED or ALL ALIKE from Foster's monotony (the mean of the seven days' loads over their spread). ALL ALIKE (over 2.0, e.g. every morning
  Hard by hand: 10.6 h, 1.36 of usual) multiplies the training injury chance x1.5 (NEW, ESTIMATE; PATTERN1). The player may break the
  pattern by hand at that price.
- ON THE BUTTON, all from one run of WeekPlan.week + PadWeek.run_week + InjuryRoll for THIS fighter (T24): hours and the ratio; the first
  whole point and its day; the goal's status; overreached if the week's peak crosses 80 (gains x0.6 from that day, CODE); injury in 100;
  Legs on the next bout day and its worth there (T14). Samira, Monday 16 Feb, Kayleigh on Sat 28:
  - "Easy 5.1 h · Defence 52 Thu · goal AT RISK · Legs 100 · injury under 1"
  - "Normal 7.4 h · Defence 52 Wed · goal on track · Legs 99 · injury 1"
  - "Hard 9.8 h, 1.25 (safe to 10.1) · Defence 52 Tue · worn out Fri: x0.6 (overreached, gains x0.6) · Legs 94, -1 to -3 · injury 4"
  - "Sharpen 4.8 h · keeps Speed and Explosiveness · Defence 52 Fri · goal AT RISK · Legs 100"
  Why Hard reads injury 4 although under the 1.3 line: Samira starts the week at tiredness 61 and the week peaks at 88 (fatigue_mult x3,
  CODE). The same Hard week from a rested start reads 1 in 100. The card says which: "from tired 61".
- LINKS: Club week chip; RPG Hard school x1.4; the fighter's ask on Hard (T26); T15 (Sharpen keeps the fast abilities).

### T14. LEGS ON EVERY BOUT; WORK CAPACITY, NOT A SECOND FITNESS (rewritten in v4)
- FITNESS IS THE ABILITIES: Cardio, Strength and the rest grow slowly by sessions (CODE) and fall by fade (T15). Nothing else is called
  fitness. v3's "Fitness = 55 + 4 x usual hours" as the top of Legs is DROPPED (REJECTED below): a Cardio-70 fighter after a light month
  would have entered with less tank than a Cardio-60 fighter who trains a lot.
- TIREDNESS IS LEGS: the week's tiredness (CODE, 0.87 a night, Recovery 0.70 to 0.95) shows only as LEGS, CLUBWEEK's one bar (WEEK): the
  tank at the first bell = 100 minus tiredness over 50 (1 a point), weight eaten off (T8), your own last bout (7 days ago -8, 14 days -4);
  they add, at most 25 off.
- ON EVERY BOUT (scientist 4; ONE RULE with the fight link map's NOCAMP1): the Legs bar replaces BoutRules.stale_energy in BoutNight._peak
  on every bout, an amateur fight week included; NO_CAMP_EDGE applies only to a professional with no camp. This map adds nothing to that
  task; it prices it. Before NOCAMP1 the load has no payoff for the amateurs (stale_energy is 0 without a camp, CODE).
- PRICED IN WINS: each load button prints its Legs on the next bout and their worth on that bout in wins in 100 from CLUBWEEK's
  TANKPRICE1 (what one point of tank is worth); until TANKPRICE1 reports, the button prints Legs only.
- WORK CAPACITY (the slow reward, CODE numbers): the usual hours (Injuries.chronic, a 42-day average) are shown as "usual 7.8 h · safe to
  10.1 h next week" (the 1.3 line). A Hard week lifts the usual about 0.3 h (0.1535 of the gap, CODE), so two Hard weeks make a 10.4 h camp
  week safe that was not. That is what Hard buys besides points: room for a bigger week later. No bar, one line on the load card and the
  strip.
- WHERE IT SHOWS: the strip's bout days print "Legs 99"; the buys panel (T23) breaks Legs into its parts; the load card prints Legs on each
  button; the Condition tab keeps the tiredness curve with its 70 and 80 lines.
- REAL BASIS: the fitness-fatigue model (Banister 1975): fitness slow, fatigue fast; work capacity and the acute:chronic load (Gabbett 2016).

### T15. ABILITIES FADE WITHOUT THEIR DOSE (changed in v4: a dose, not one touch)
- WHAT IT IS: each ability is KEPT while it gets its DOSE: one session that trains it (Attrs.SESSION_ATTRS, CODE) inside its window. Once a
  window passes with no session, the HOLD runs from the last dosed session; when the hold runs out it loses a little each week. A lone
  session after a missed window stops that week's loss but restarts the hold only when the dose is back (two windows running with a
  session each). So one roadwork every 29 days does not keep Cardio (scientist 4). It never falls more than 3 points under its best this season.
| Group | Dose (one session in) | Hold after a missed dose | Then loses | Real basis |
|---|---|---|---|---|
| Cardio (Stamina), Strength | 14 days | 30 days | 0.25 a week | keeping fitness at about one session a week (Bickel 2011; Spiering 2021); residuals 30 +/- 5 days (Issurin 2008) |
| Recovery, Durability | 10 days | 18 days | 0.25 a week | anaerobic and strength-endurance residuals 15 to 18 days |
| Defence, Footwork, Accuracy, Timing, Inside | 10 days | 21 days | 0.25 a week | motor skill sharpness (an ESTIMATE between the two) |
| Speed, Explosiveness | 7 days | 7 days | 0.5 a week (1.0 if DETRAIN1 is flat) | maximal speed residual 5 +/- 3 days |
| Fight IQ, Composure, Flexibility | never | | | learned, not trained shape |
- ON SCREEN, THE "KEEPS" COLUMN READS THE PLAN (FM 8): "kept by Sat speed bag", "kept by Thu sparring", or, when nothing in the planned
  weeks doses it, "fades from Sat 28: -0.5 a week" in amber with the one session that stops it. Moves: a pad card that will drop a tier
  inside 4 weeks gets a FADING row from MoveMastery.decay_week (CODE). A move never falls under Usable (CODE).
- WHY: with a dose, keeping is a real cost (DETRAIN1 must show a season of keep-it sessions takes about a fifth of the week), and a camp
  has an order: engine and strength early, speed and explosiveness kept to the bell by Sharpen.
- DETRAIN1: a camp in the right order beats the reverse by 1.5+ in 100; a season with no keep-it sessions loses 2 to 4 points; if it comes
  back flat, Speed and Explosiveness lose 1.0 a week rather than fade being cut (FM 9).

### T16. ROOM TO GROW: EACH ABILITY'S OWN CEILING (fix a CODE defect; show it)
- THE FIX: Sim.week_ctx builds `ceil` = {stat: Recruit.ceiling(f, stat)} and WeekPlan.day / full_day pass ceil[stat] to the headroom instead
  of the one pot. Recruit.ceiling is CODE; only its readers change. Abilities read their parent stat's ceiling (Attrs.LEGACY, CODE).
- ON SCREEN: a bar from now to the ceiling, the ceiling as a range until KNOWN opens its group (WEEK RPG 8; Knowledge.width, CODE), and one
  word from the headroom (TrainingPreview, CODE): FAST at 10+ points of room (headroom 0.4+), SLOW at 4 to 9, NEAR CAP under 4 (it trains
  at the 0.10 floor). v3's words were set where no amateur could reach FAST; v4 sets them on room in points. Samira (out-boxer, pot 68):
  Footwork 57 of 68 FAST, Speed 69 of 74 SLOW, Explosiveness 60 of 62 NEAR CAP ("Finisher 70 is over the ceiling").
- CEILING1 (unit test, the defect): two fighters with the same stats and different classes gain differently over 8 weeks; red on main today.

### T17. THE NEXT LINE, PER ABILITY, WITH ITS DAY (CODE lines; NEW display)
| Ability | Its lines in the code |
|---|---|
| Cardio | 64: no fade from round 3 (BoutRules, LiveRound); 70: Second wind |
| Strength, Explosiveness (Power) | Power past 60: "Go to the body" goes strong; Explosiveness 70: Finisher |
| Accuracy, Timing (Technique) | Technique past 61: "Jab and move" strong; Accuracy 65: Stiff jab; "Draw the lead" graded on Timing and Fight IQ: Good at 62 |
| Defence | "Hands up, move your head" (0.65 Defence + 0.35 Flexibility): OK 50, Good 62 (64 at Flexibility 50); Counter sense 65 with a Check hook weapon |
| Footwork | "Jab and move" graded on the jab and Footwork: Good at 62 |
| Speed | "Let your hands go" (Cardio and Speed): Good at 62; 70: Fast hands |
| Fight IQ | 65: finds the right answer alone; Ring general |
| Durability | 70: Iron chin |
| Inside | "Tie up" (Inside and Heart): Good at 62 |
- A call going from OK to Good lifts its edge from x0.6 to x1.0 of 17 power points in each exchange it fits (Exchanges.EDGE, GRADE, CODE).
- ON SCREEN, WHOLE POINTS ONLY (decimals on hover, scientist 9): "Cardio 61 · 64: no fade from round 3 · Fri 6 Mar". A line over the
  ceiling says so. LINES1 prices each crossing in wins in 100 on the bouts it applies to; a line under 1.5 is printed as a word only.

### T18. WHAT THIS OPPONENT TESTS, AND THE ORDER OF THE BOARD (changed in v4: a column, and the sort)
- WHAT IT IS: with a bout booked, OppTests.gd (NEW) reads the opponent's style weights (Exchanges.STYLE_MODES), the right call for each game
  (Exchanges.MODES, CALLS needs) and each place's answering tools (Duels.TOOLS), and gives each ability a multiplier against THIS opponent.
  Kayleigh Bell, counter-puncher (counter 55, range 25, press 10, load up 10 in 100): Fight IQ and Timing x1.4 (Draw the lead), Footwork x1.3,
  Cardio x0.8 (a counter-puncher gives away quiet rounds).
- THE SORT (FM 4, scientist 9): the abilities panel lists the 14 abilities by WORTH AGAINST THIS OPPONENT = Attrs.VALUE (CODE) x the
  multiplier, as four dots (never a decimal); the multiplier is a column ("x1.4"), not a separate card. 8 rows show, the goal's row is
  pinned if it is not among them, "Show all 14" is one click. Samira against Kayleigh: Footwork (4 dots, x1.3), Defence, Timing (x1.4),
  Speed (3), Explosiveness, Durability, Inside (2), then Cardio pinned (the goal, x0.8). Fight IQ is tested x1.4 but is worth little a point
  (0.025, CODE); the sort says so honestly. Never an old-seven summary row ("Power" is gone from the board: it is two abilities with two
  doses).
- WHAT IT CHANGES: CLUBWEEK's pull sizes (LeverSize, WEEK) multiply by it, so Coach's week leans toward it; each morning's reason names it
  ("Footwork: Kayleigh"). With no bout booked the sort is by plain worth (Attrs.VALUE).
- Before tape study it uses the style word only (CODE); a found tell (CODE) sharpens it. OPPTEST1 sets the multipliers from the played bout.

### T19. NIGGLES FROM YOUR LOAD; TRAIN AROUND AN INJURY (kept; the answers now cross-priced)
| Part | Comes when | Rest it (the swap) | Push on |
|---|---|---|---|
| Hand | 3 hand days running (heavy bag, speed bag, pads), or a week over 1.3 of the usual with 2 | bag and speed bag to shadow (WeekTwist's sore-wrist swap, CODE); pad cards on THAT hand pause (each card names its hand: jab, lead hook, check hook lead; cross, uppercut, a rear-hand habit rear) and their places go to footwork drills | hand injury x3 this week (SPIKE_MULT, CODE) |
| Ribs | 2 sparring nights, or a bout's ribs in the hurt band | no sparring, no body work | ribs x3 |
| Legs (strain) | 3 roadwork, intervals or footwork mornings and a week over 1.3 | to strength circuit and slip rope | strain x3 |
- EACH ANSWER PRICED IN THE OTHER PANELS (FM 1), from the same run (T24). Samira's right hand, Monday 16 Feb:
  - "REST IT: no bag; Wed's habit pads become footwork drills, so the habit is still HALF FIXED on Sat 28 (Kayleigh punishes it: -2 to -4
    in 100); Explosiveness has no session by Sat 28 (-0.5 on the night); Footwork +1 Sat."
  - "PUSH ON: hand injury 4 in 100 (out 2 to 4 weeks: the bout off, $300 slot); the habit GONE on Sat 28."
- Unanswered on Monday: Coach rests it. The two body cards leave the random deck (CLUBWEEK's ClubTwist already replaces WeekTwist).
- AN INJURY, TRAINED AROUND (Coach's default) turns off only the hurt part's sessions, the rest at full; FULL REST: back 20% sooner
  (ESTIMATE). Bouts stay closed until cleared (CODE). NIGGLE1, TRAINAROUND1.

### T2. SIZES YOU CAN FEEL; DATES PAST THE BOUT FLAGGED (changed in v4)
- Whole points with their day ("Defence 52 Wed"), tiers with their day, lines with their day (T17), and with a bout booked the week's worth
  as a range in wins in 100 from the probes (LeverSize, WEEK). Decimals in hover only.
- AFTER THE BOUT (FM 3): every date past the next bout carries an amber "after Sat 28" tag and, where it can be moved, THE PRICE OF BRINGING
  IT FORWARD from PadWeek.project / WeekPlan.project (CODE) with the extra place or session: "Check hook Usable Mon 2 Mar · after Sat 28 ·
  +1 pad place Thu: Usable Fri 27 · Lucy goes short on Club week". Where no load or place can bring it forward the tag says "not before Sat
  28 at any load" (Footwork 62 needs 5 points in 12 days). Where bringing it forward is cheap, the buys panel lists it as a lever.

### T23. SAT 28: WHAT THIS WEEK BUYS (NEW panel, FM 2)
One panel on the Training tab, read from the same run as everything else, for the next bout only:
- YOUR WEEK AGAINST COACH'S as a range in wins in 100 (CLUBWEEK's one number, LeverSize, WEEK; the same number as the bout page's bill).
- LEGS AT THE BELL and its parts: tiredness (this week + the fight week as laid), weight, the last bout; "Recovery 50: clears 12% a night".
- THE HABIT'S STATE on the night and what it costs where this opponent punishes it.
- THE GOAL: on track or at risk, and its day.
- WHAT LANDS AFTER THE BOUT (T2's flags in one line).
- THE BIGGEST LEVER STILL OPEN this week with its size (the largest single change the board could still make).
With no bout booked the panel reads "This week buys" for the season target instead (the nationals, a grading), from the same run.

### T24. ONE RUN, EVERY PRICE (NEW rule for the screen, FM 1)
Every option on the tab (the load, the niggle's answers, a keep-it card, the diet, a deload, an after-the-bout fix) prints its cost in the
OTHER panels' own terms, computed by running the week WITH that option (WeekPlan.week, PadWeek.run_week, InjuryRoll, the fade rule, the
Legs rule) and diffing against the week as it stands. One function (TrainWeek.run, NEW, a thin wrapper) feeds every panel, so no panel can
disagree with another. ONERUN1 (unit test): every printed price equals the diff of two runs.

### T25. THE GOAL ON THE TAB (FM 5)
FighterGoal (CODE) shows on the header ("Goal: Cardio 64 by Fri 6 Mar · on track") and on the ability row it names ("your goal"); every
load and diet button prints the goal's status after it. Met: mood +10, trust +25; missed: mood -20, trust -25 (CODE), said on hover.

### T26. THE FIGHTER'S VOICE ON THE LOAD (FM 6)
PushBack (CODE) already makes a fighter with discipline under 50 ask to ease the Hard mornings (and asks for a day off after a peak of 75).
The ask now sits on the button it is about, handwritten: "Samira: 'ease the Hard mornings' · overrule: mood -5". Picking it anyway is the
overrule (CODE price, -5; more under coachability 40, RPG). The ask still takes the twist card's place that week (CODE).

### T27. THE COACH'S GRADE ON EVERY COACHED CELL (FM 7)
Each cell names who runs it and the area's lift from CoachAreas (CODE): "Coach +53%" on a bag morning, "Coach +30%" on intervals (Coach is
weak on conditioning), "You +48%", "alone x0.8" (the mood rate, CLUBWEEK 3.7). The coached-morning choice reads as a quality choice.

### T29. RECOVERY SHOWN (scientist 8)
The Recovery ability already sets how fast tiredness clears (WeekPlan.fatigue_keep, CODE: 0.70 to 0.95 a night). The header says it
("Recovery 50: clears 12% a night") and the buys panel's Legs line repeats it, so a slow recoverer's longer Sharpen reads as a fact.

### T3. ONE SESSION PER JOB (kept)
| Morning | Trains | Printed at the choice | Change (tag) |
|---|---|---|---|
| Roadwork | Stamina | "Cardio · about 460 kcal · doses Cardio" | kept (CODE) |
| Intervals | Stamina + Recovery | "Cardio + Recovery · about 360 kcal" | adds Recovery (NEW) |
| Strength circuit | Strength | "Strength" | kept (CODE) |
| Heavy bag | Explosiveness + Inside | "Power punching, up close · hand day" | was Strength + Explosiveness (NEW) |
| Speed bag | Speed | "Hand speed · hand day" | kept (CODE) |
| Footwork drills | Footwork | "Ring cutting, angles" | NEW morning (30 min, RPE 5, MET 7, ESTIMATE) |
| Slip rope | Defence | "Slips and rolls" | kept (CODE) |
| Shadow boxing | Accuracy + Footwork | "Form, shots that land" | kept (CODE) |
| Neck work | Durability | "Takes a punch" | kept (CODE) |
| Rest | Recovery + Flexibility | "Fresh legs" | Mobility folds in (NEW) |
The old block plan (TrainingPlan) is retired. MORNINGS1 joins the small batch.

### T4. WHAT A SPARRING SETTING TRAINS; WHO YOU SPAR WITH (partner level added, FM 11)
| Setting (prices WEEK) | Trains | Reveals |
|---|---|---|
| HARD | Composure, Inside, Fight IQ; Fire known faster (WEEK) | a hidden habit 1 in 3, a trait 1 in 2 (WEEK) |
| TECHNICAL | Timing, Defence, Fight IQ | a hidden habit 1 in 5, a trait 35 in 100 (CODE) |
| BODY ONLY | Inside, Stamina, body punches; a ribs day (T19) | a hidden habit 1 in 10 |
- PARTNER LEVEL (NEW): a partner 5 or more above (their mean of the abilities the setting trains) teaches those abilities x1.2; one 5 or
  more below x0.8. The pair picker on Club week prints it ("Lucy: 6 above, x1.2"). SPARLEVEL1 in the small batch; cut under the rule.

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
a team-mate is in the room. Shown on the cells ("alone x0.8", "may skip").

### T8. WEIGHT TO THE LAST DAY, AND THE WEIGH-IN'S HOUR (changed in v4)
| Diet | kcal a day | About a week | Its price |
|---|---|---|---|
| HOLD | life + 300 (CODE) | holds | none |
| LEAN (NEW) | -250 | -0.23 kg | none |
| CUT | -500 (CODE; Old hand -620) | -0.45 kg; -0.05 kg a day more in a Sharpen fight week on a cut (CODE TAPER_KG) | mornings x0.9 (NEW, ESTIMATE) |
- THE WEIGH-IN'S TIMING (scientist 7; the rate CLUBWEEK uses for the scale is kept for the same day):
| Weigh-in | Who | Time to refill | Legs for weight left to the day |
|---|---|---|---|
| THE DAY BEFORE | professionals, the regional, the nationals | about 24 h | -1 for each 0.2 kg |
| THE SAME DAY | club shows (amateur) | about 3 h | -1 for each 0.1 kg, -2 past 0.5 kg (CLUBWEEK) |
- ALWAYS ON SCREEN: walking weight, the class, the next weigh-in that reads the class and its hour ("Fri 3 Apr, the day before: 24 h to
  refill"), and per diet what it leaves to that day and its Legs: "Lean: 65.0 by Mon 16 Mar, nothing left" / "Hold: 0.9 kg left, Legs -5".
  Club shows at walking weight with CLUBWEEK's 1.0 kg gap say so ("Sat 28 club show: 65.9 is inside the 1.0 kg gap"). Over 2% of body weight
  left to the day: red, "a miss calls the bout off, $300" (CODE). Each diet button prints its goal and first-point effect (T24).

### T9. THE SEASON STRIP (changed in v4: Sharpen, amateur words, safe hours)
- The next 12 weeks as blocks: for an AMATEUR, BUILD / FIGHT WEEK / REST / DELOAD (CLUBWEEK words, FM 8); for the PROFESSIONAL, BUILD /
  PEAK / TAPER (CODE WeekPhase). A FIGHT WEEK and a TAPER are laid as SHARPEN by default; a DELOAD is a Sharpen week you place (at most 1
  in 3 weeks, after 2+ build weeks). REST is an Easy week or a fortnight after a bout (WEEK). The dates that matter: bouts, entries closing
  (CODE SeasonPath), the next grading (CODE SkillAwards).
- EACH BLOCK draws its Legs (bout days, "Legs 99") or its safe hours (build weeks, "safe 10.1 h"), so a Hard block's reward (more safe
  hours later) and a fight week's (full Legs) read on one line. Hover a deload: "Legs on Sat 4 Apr 99, 93 without; a fifth of a week's
  points" (T24).
- Pinned buttons say the phase that is next for this fighter: "Keep my changes into the fight week" for an amateur, "into Peak" only for
  the professional (FM 8).

### T10. PAD TIME PAST USABLE IS WORTH IT (kept)
FireLevel switched ON (CODE, built and off): a line fires 1 in 2 at Usable, 3 in 4 Sharp, always Signature; FIRELEVEL2 first. A pad place
drills one card or two at half each; each card prints its date, an after-the-bout tag (T2) and its hand (T19). FADING rows (T15) and a
KEEP-IT card priced in the card it displaces: "1 pad place keeps Uppercut Sharp to Mon 23 Mar; it takes Mon's Check hook place: Usable
slips to Thu 5 Mar". Move names come from the data only (Data.MOVES: Jab, Cross, Lead hook, Body hook, Uppercut, Check hook).

### T11. COACH RUNS IT, PER FIGHTER (kept)
"Coach runs Samira's week": Coach's deal every Monday; Known stops growing (WEEK RPG). The button prints its size: "-1 to -2 in 100 on Sat 28".

### T12. ANA'S MAT WEEK (kept)
Class kinds DRILL / POSITIONAL / HARD ROLLS with the stripe date for each choice; open prep +1 in 100 a match per Hard rolls class in the 14
days before an open (at most +4). T15's fade with its dose (Cardio: one hard-rolls class in 14 days), T19's niggle (hard rolls 3 in a
week: a strain card). BJJCLASS1.

### T13. THE TAB (kept, with v4's panels)
Every cell has its word, who coaches with the grade (T27) and its reason ("Slip rope: weak spot", "Shadow: hand rested", "Footwork:
Kayleigh"); a cell you change keeps a gold edge; "Back to Coach's week"; "Build a combination". YOUR CHANGES KEEP while the phase holds (CODE);
"Keep my changes into <the next phase>" carries them across. The tiredness curve lives on the Condition tab.

### T20. SEASON SO FAR (kept)
Each whole point since the season target was set with its causes counted, bouts among them, losses in red ("-1 Speed: no dose, 3 weeks").
WeekCause tallies a week (CODE); v4 keeps f["season_src"] until the target is met or changed. Lines, never a chart.

### T21. BOUTS TEACH (kept)
A fought bout adds Fight IQ +0.5 and Composure +0.5; a step-up or a points loss +1 each. BOUTTEACH1: never outweighs a month of sparring.

### T22. THE PROFESSIONAL'S CAMP LEANS TO CARDIO (kept, CODE truth shown)
The fade hits every round from the third (LiveRound 65, CODE): 1 round in 3 for an amateur, 2 in 4 on the debut, 4 in 6 ranked. The
professional's camp card prints "Cardio 64: no fade in rounds 3 and 4". PROFADE1 measures the worth.

## 6. Every effect and its hook
| Effect | Tag | Hook |
|---|---|---|
| Load on the week's hours | CODE + NEW | Injuries.week_hours (WeekPlan.hours over PadWeek.evenings), Injuries.chronic, InjuryRoll.training_chance; NEW: one load laid on all mornings; TrainingLoad.SETTINGS hours and START_HOURS retired |
| Sharpen; the taper and deload keep the pace | CODE + NEW | WeekPhase.WEEKS["taper"] rewritten; PadWeek.nights_for (taper); NEW Sharpen layout |
| Pattern (monotony) | CODE + NEW | WeekPlan.week "red"; NEW Pattern x1.5 in InjuryRoll |
| Legs on every bout | WEEK + CODE | CLUBWEEK FightWeek Legs -> BoutNight._peak in place of BoutRules.stale_energy (fight link NOCAMP1) |
| Work capacity | CODE | TrainingLoad.next_chronic; InjuryRoll.SAFE_RATIO |
| Fade by dose | NEW | Detrain rule reading Attrs.SESSION_ATTRS (CODE) and the planned weeks (WeekPlan.ahead, PadWeek.ahead) |
| Moves fade, fading rows | CODE + NEW | MoveMastery.decay_week, gain |
| Each ability's ceiling | CODE (defect fix) | Recruit.ceiling; Sim.week_ctx; WeekPlan.day / full_day; TrainingPreview.headroom; Knowledge.width |
| Next line and its day, after-the-bout tag | CODE + NEW | BoutRules.NIGHT_LINES; Exchanges.grade, EDGE, IQ_FINDS; PerkRoad.PERKS; WeekPlan.project; PadWeek.project |
| Opponent tests; the sort | CODE + NEW + WEEK | Exchanges.STYLE_MODES, MODES, CALLS; Duels.TOOLS; Attrs.VALUE; NEW OppTests; LeverSize (WEEK) |
| Niggles, cross-priced | CODE + NEW | InjuryRoll.TRAIN_TYPES, SPIKE_MULT; WeekTwist swap; NEW Niggle (hand per card) |
| What this week buys; one run | WEEK + NEW | LeverSize, FightWeek (WEEK); NEW TrainWeek.run over WeekPlan.week, PadWeek.run_week, InjuryRoll, Detrain |
| Goal on the tab | CODE | FighterGoal |
| The fighter's voice | CODE | PushBack, WeekTwist.ASKS |
| Coach's grade per cell | CODE | CoachAreas.rating_for, pct, pct_for |
| Recovery shown | CODE | WeekPlan.fatigue_keep |
| Weigh-in timing | WEEK + NEW | CLUBWEEK scale rate (same day); NEW day-before rate |
| Season so far | CODE + NEW | WeekCause.add; NEW season keep |
| Bouts teach | NEW | AfterFight |
| Pro camp leans to Cardio | CODE | LiveRound 65, BoutRules.FADE_CONDITIONING |
| Mornings, one job each | CODE + NEW | WeekPlan.SESSIONS; Attrs.SESSION_ATTRS |
| Sparring setting and partner level | CODE + WEEK + NEW | Attrs.SESSION_ATTRS["sparring"]; SparSet (WEEK); NEW split, partner level |
| Habits as work | CODE + WEEK + NEW | HabitFix; Recruit.HABIT_WEEKS; pad places (WEEK); NEW HabitWork |
| Own tape | CODE + NEW | WeekPlan.EVENINGS["film"] |
| Weight to the last day | CODE + WEEK + NEW | WeekPlan.day (ALLOWANCE, CUT_DEFICIT, head_cut, TAPER_KG); NEW Lean, Cut x0.9 |
| Season strip | CODE + WEEK + NEW | WeekPhase.phase; SeasonPath; SkillAwards; NEW SeasonStrip |
| Firing by tier | CODE | FireLevel (switch on in GameSwitches.GAME_ON) |
| Coach runs it | WEEK + NEW | CLUBWEEK bout bill |
| Ana's class kinds | CODE + NEW | NoGi 3.2 a week |

### 6b. Changes to the sister maps (carry into their next versions; nothing here adds a meter)
- CLUBWEEK: the Legs bar's top stays 100 (v3's Fitness top is withdrawn). The fight-week shapes ARE this tab's loads: Rest up = Easy, Tick
  over = Sharpen, Train through = Normal; their Legs come from the week as laid (about 0, 1 and 5 off for Samira this month), not fixed
  "about 8" and "about 12". The same-day scale rate stays; the day-before rate is added (T8). Pull sizes read the ceilings (T16) and the
  opponent's tests (T18). The pair picker prints partner level (T4). WeekTwist's body cards live on as niggles (T19).
- FIGHT LINK: one Legs rule, NOCAMP1's; this map prices it on the load buttons and the buys panel and adds nothing to the bout.
  The readiness "sharp" input (M6) is met by Sharpen or Train through with 1 pad place in the last five days.
- RPG layer: coachability's lines gain the habit step (T7); the "what your picks won" ledger takes one line from SEASON SO FAR (T20).

## 7. Every decision
B = before the week, D = during, A = after. The last column is the designer's test (never printed).
| When | Decision | Options, costs and gains (each priced in the other panels, T24) | Right when |
|---|---|---|---|
| B, Monday | The load (T1) | Easy: Legs full, points slower, goal may slip. Hard: points sooner and safe hours up, Legs down, overreach from a tired start. Sharpen: keeps the fast abilities, clears tiredness, few points | Hard: 3+ weeks out from a fresh start. Sharpen: fight week, a deload. Easy: after a bout, hurt, Low mood |
| B, a fight week | The shape = the load (6b) | Rest up (Easy) / Tick over (Sharpen) / Train through (Normal) | Sharpen unless the opponent fades late (Rest up) or the goal is due (Train through) |
| B, any week | A deload on the strip (T9) | a Sharpen week: tiredness clears, the fast abilities kept, a fifth of the points | the week before a fight week after 2+ Hard weeks |
| B, Monday | Which ability the mornings build or dose (T15, T16, T18) | build where room is FAST and the opponent tests; dose what is fading | engine early, speed kept to the bell |
| B, Monday | Follow the opponent or the season (T18) | Coach's lean toward the opponent's tests, or the season's weak spot | the bout is the season's target, or a step-up |
| B, Monday | The niggle (T19) | Rest it (the habit and cards on that hand pause) / Push on (that part x3) | Push only when the paused work is worth more on the bout than the risk |
| B, an injury | Train around / full rest (T19) | the rest at full / back 20% sooner | full rest only when the 20% reopens a bout |
| B, Monday | Morning exceptions | any morning; break the pattern at x1.5 | a team-mate in the room, a weigh-in, a dose |
| B, Monday | Each pad place's card (T5, T10, T2) | a new move, a tier, the habit, a keep-it card, bringing a date before the bout | a card within 2 places of a tier or a line; the habit the opponent punishes |
| B, Monday | The diet (T8) | Hold / Lean / Cut (x0.9), each with its last day's Legs at that weigh-in's hour | Lean 4+ weeks out; Cut 2 to 4 weeks out and over 0.5 kg; earlier for a same-day scale |
| B, Monday | Overrule the fighter's ask (T26) | the Hard week at mood -5 | the Hard week's points are worth more than a mood step |
| B, no bout | Film: your own tape (T6) | 2 pad places; a habit 1 in 2 | Known Skills low, or an unexplained loss |
| B, Monday | Coach runs this fighter (T11) | your sessions freed, Known stops | that fighter's size is under 1 in 100 |
| B, a phase change | Keep my changes into the next phase (T13) | your exceptions carry | they still have a reason |
| B, Monday (Ana) | Each class kind (T12) | drill / positional / hard rolls | Hard rolls inside 14 days of an open |
| A, the Why and Monday | "Put the habit card on", "Sharpen next week", "Rest the hand", "Train X" | one click into the Training tab with it set | the Why names a cost the week can fix |

## 8. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > Training (drawn) | header (goal, Recovery); the strip (blocks, Sharpen, Legs on bout days, safe hours); the LOAD (four buttons priced from one run, the pattern, usual and safe hours, the fighter's ask); BODY (niggle answers cross-priced); the week (word, who + grade, reason; gold on your changes); ABILITIES (sorted by worth against the opponent, the tested column, room, next line with day and after-the-bout tag, the dose that keeps it); PAD PLACES (dates, after-the-bout price, the habit with its hand, a fading card priced in what it displaces); SAT 28: WHAT THIS WEEK BUYS; WEIGHT with the weigh-in's hour; SEASON SO FAR; Keep my changes, Back to Coach's week, Coach runs it, Back to Club week | WeekBoard, WeekEditors, WeekTiles, WeekDay, WeekCards; WeekPlan, Injuries, InjuryRoll, TrainingLoad, PadWeek, MoveMastery, FireLevel, Recruit, Knowledge, BoutRules, Exchanges, Duels, PerkRoad, Attrs, CoachAreas, FighterGoal, PushBack, WeekCause, SkillAwards; NEW TrainWeek, Detrain, OppTests, Niggle, TrainAround, HabitWork, SeasonStrip |
| Fighters > Club week | each row: the load chip (and the fight-week shape under its CLUBWEEK name), the diet, the habit chip, a red niggle chip, "Coach runs it"; pull sizes with ceilings and the opponent; partner level on the pair picker | ClubDeal, LeverSize (WEEK), Niggle, OppTests, HabitWork |
| Fighter page > Condition | the tiredness curve with 70 and 80; Legs on the next bout day; usual and safe hours; the injury and its answer | WeekTired, SeasonStrip, TrainAround |
| Fighter page > Profile | room to grow, next line, the dose and fading in amber; the habit's state | AttrBoard, Recruit, Detrain, HabitWork |
| Fight prep and the bout sheet | what the opponent tests; the habit's worth; the diet's last day at the weigh-in's hour; the Legs; "a step-up teaches twice as much" | FightPrep, OppTests, HabitWork, WeekPlan, SeasonStrip |
| Fight night | the habit at its state; Legs as the first bell's tank | HabitFix, FightWeek (WEEK) |
| Result and the Why | the habit's cost; Legs at the bell and what the strip did; Fight IQ and Composure taught; "Rest the hand" | FightWhy, WhyCard, SeasonStrip, AfterFight, Niggle |
| Week review (Monday) | whole points with causes, lines crossed, fades, niggles answered, habits moved, SEASON SO FAR's new lines | WeekReview, ReviewReveal, WeekCause, Detrain, Niggle, HabitWork |
| Playbook | "fires 1 in 2: Usable" beside each line; fading cards | PlanLines, FireLevel, MoveMastery |
| Grappler page | class kinds with stripe dates; niggle; Cardio's dose | GrapplerPage, NoGi, Niggle, Detrain |
| Coach's notes | habits and traits found, and where | CoachNotes, HabitWork |
THE NEW MECHANICS, MENU BY MENU (each shows on every menu listed, in the .exe, and the golden-path test walks it):
| Mechanic | Menus |
|---|---|
| T1 load on real hours, Sharpen, pattern | Training, Club week, Condition |
| T14 Legs on every bout, work capacity | Training, Condition, Club week, bout sheet, fight night, the Why |
| T15 fade by dose | Training, Profile, Week review, Playbook, Grappler page |
| T16 room to grow | Training, Profile, Club week, signing card |
| T17 next line; T2 after-the-bout tag | Training, Profile, Week review |
| T18 opponent tests and the sort | Training, Club week, Fight prep |
| T19 niggles cross-priced | Training, Club week, Condition, Week review, the Why, Grappler page |
| T23 what this week buys | Training (the bout page's bill shows the same one number) |
| T25 goal, T26 voice, T27 grade, T29 Recovery | Training (goal also on the header everywhere it is today) |
| T20 season so far; T21 bouts teach; T22 pro camp | Training, Week review, RPG ledger; bout sheet, the Why; the professional's camp card |

### 8b. The same frame for the other three (FM 10; drawn before the Cursor brief, build step 4)
| Panel | Lucy, the professional (camp, 4 rounds) | Ana, the grappler (mat week) |
|---|---|---|
| Strip | BUILD / PEAK / TAPER; the taper laid as Sharpen; "Legs 98" on fight night | classes a week, opens every 35 days, "stripe Mon 6 Apr" |
| Load | Easy / Normal / Hard / Sharpen; the camp's intensity (CODE) stays on the camp card; "Cardio 64: no fade in rounds 3 and 4" on the Cardio row (T22) | class kind per class: DRILL / POSITIONAL / HARD ROLLS, each with its stripe date (T12) |
| Body | niggle as boxers | the strain card after 3 hard-rolls classes |
| Abilities | sorted against the booked name; the weigh-in the day before: "24 h to refill" | Strength, Cardio, Flexibility, Explosiveness, Composure (her six, CODE) with doses; no ring lines, the mat's own (owned at 30, signature 50) |
| Buys | "FRI 20 MAR: WHAT THIS CAMP BUYS" with PEAK CAMP's three lines (CODE) | "THE OPEN: WHAT THIS WEEK BUYS": open prep +1 a hard-rolls class (at most +4) |
| Weight | the professional class, the day before | the open's division |

## 9. Numbers: from the code, or ESTIMATE
FROM THE CODE: the gain rule and headroom; Recruit's ceilings (+6 / -6); intensity 0.6 / 1.0 / 1.3 and load 0.6 / 1.0 / 1.5; the week's hours from
the sessions' minutes (WeekPlan.SESSIONS, EVENINGS: pads 75, sparring 30) - Coach's base week 7.97 h; tiredness 0.87 (Recovery 0.70 to
0.95) and 44 and 80; the 42-day usual (0.1535 a week); the 1.3 / 1.5 lines and x3; fatigue_mult from 72; 1.3 in 100 a 10 h week; the training
injury types; rest x0.25; kcal by MET, -500 cut and TAPER_KG; mastery 2.1 a pad hour and -0.75 a week; the night lines; the call grades;
IQ_FINDS 65; the perk needs; the style weights; Attrs.VALUE; CoachAreas lifts; FighterGoal's mood and trust; PushBack's 50, 68, 75;
HABIT_COST 6; FireLevel's shares; stale_energy 2 a point, max 20 (to be retired by NOCAMP1).
ESTIMATE (each set by a probe): the doses, holds and fade rates; the Sharpen layout; the pattern's x1.5; the day-before refill rate; the niggle
triggers and per-hand pauses; train-around's 20%; OppTests' multipliers; the FAST / SLOW / NEAR CAP points; habit 3 + 3 pad places; own tape
1 in 2; Lean -250; Cut x0.9; bouts teach 0.5 / 1; footwork drills; partner level x1.2 / x0.8; Ana's class kinds. Samira's numbers in the
drawing (hours 5.1 / 7.4 / 9.8 / 4.8, peak 88 from a tired 61, Legs 100 / 99 / 94) were worked by hand from the code's tables; the built
tab reads them from the run (T24).
ON SCREEN: a size in wins in 100 is printed only once its probe has reported (CLUBWEEK's rule); before that, the row prints the thing
itself (Legs 94, HALF FIXED, Usable Mon 2 Mar) and no number.

## 10. To be measured (one gate, four foundations, then the rest in one batch)
THE CUT RULE (as CLUBWEEK): a choice worth under 1.5 wins in 100 on the bouts it touches AND with no season effect is cut, not drawn.
EVERY PROBE RUNS TWICE (scientist 10): on the AMATEUR FIGHT WEEK (12 days' notice, no camp, NOCAMP1's Legs in) and on the professional's camp.
- THE GATE, TRAINSEASON1: a careful player against "Coach runs it" for all four over a season: 4+ in 100 on the season's bouts, or the
  season target 4+ weeks sooner. Else the map is cut back.
- FOUNDATION 1, LOADHOURS1 (unit test) and CEILING1 (unit test): both red on main today.
- FOUNDATION 2, FITLEGS1 (rewritten): on NOCAMP1's Legs, "Hard, Hard, Sharpen, bout" beats "Hard, Hard, Easy, bout" by 1 in 100 or more
  (else Sharpen folds into Easy and the taper goes back to Light) and beats "Normal throughout"; "Hard to the bell" loses.
- FOUNDATION 3, DETRAIN1: a camp in the right order beats the reverse by 1.5+ in 100; a season with no keep-it sessions loses 2 to 4
  points; keep-it sessions cost about a fifth of the week. Flat: Speed and Explosiveness at 1.0 a week, then re-run.
- FOUNDATION 4, TANKPRICE1 (CLUBWEEK's): the worth of a point of Legs, so the load buttons can print theirs.
- THEN, ON THE PLAYED BOUT: LINES1, OPPTEST1, NIGGLE1 with TRAINAROUND1, HABITWEEK1, FIRELEVEL2, PATTERN1 (monotony against injuries a season).
- THE SMALL BATCH (one run, each line cut if under the rule): MORNINGS1, SPARTRAIN1, SPARLEVEL1, OWNTAPE1, LEANCUT1, WEIGHHOUR1, COACHRUNS1,
  BOUTTEACH1, PROFADE1, BJJCLASS1.

## 11. Build order, in small tasks
1. The defects first, one task each: LOADHOURS1 (the load on Injuries.week_hours; SETTINGS hours and START_HOURS retired); CEILING1 (Sim.week_ctx,
   WeekPlan.day / full_day); NOCAMP1 is the fight link map's task (Legs on every bout), not duplicated here; TAPER1 (WeekPhase.WEEKS taper laid as
   Sharpen) waits for FITLEGS1.
2. Probes (cloud, pure): FITLEGS1, DETRAIN1, TANKPRICE1; then the played-bout six; then the small batch. Each writes the table LeverSize reads.
3. Rule modules with unit tests, one a task: TrainWeek.run (the one run, ONERUN1); Sharpen and Pattern in WeekPlan; Detrain.gd (dose); OppTests.gd
   (with the sort); Niggle.gd (hand per card); TrainAround.gd; HabitWork.gd; SeasonStrip.gd; the weigh-in hour; bouts teach in AfterFight;
   partner level; NoGi class kinds; FireLevel on in GameSwitches.GAME_ON; TrainingPlan retired.
4. Draw Lucy's camp and Ana's mat on this frame (8b); then the Training tab from `training_v2.png` (Cursor), then the other menus, one a task.
5. The golden path: Samira's Monday: the load card's hours equal Injuries.week_hours; Hard picked (the ask shown, overruled at mood -5) and back to
   Normal; the hand niggle rested and the habit's state on Sat 28 read HALF FIXED in the buys panel; Check hook brought forward by a pad place
   with Lucy's Club week row going short; Lean picked with the regional's day-before hour; a Sharpen fight week; the bout with Legs 99 on a
   no-camp amateur bout (non-zero Legs row when tired); the Why's "Put the habit card on"; the next Monday's review naming the whole points, a
   line crossed, one fade and the season ledger's new lines; Ana's class kinds before an open.

## 12. Every critic point, and where it went
| Round 3 critic point | Where |
|---|---|
| Scientist 1: price the load on WeekPlan.hours over PadWeek.evenings; unit test | T1, LOADHOURS1, section 3 |
| Scientist 2: drop "Fitness = 55 + 4 x hours"; fitness = abilities, tiredness = Legs; work capacity | T14 |
| Scientist 3: Sharpen; the taper and deload keep intensity | T1, T9, TAPER1, FITLEGS1 |
| Scientist 4: Legs for every bout, priced in wins | T14 (one rule: fight link NOCAMP1), TANKPRICE1 |
| Scientist 5: a minimum dose to keep each ability | T15 |
| Scientist 6: keep the hard-easy pattern; monotony priced | T1 (Pattern), PATTERN1 |
| Scientist 7: price the weigh-in's timing | T8 |
| Scientist 8: show what Recovery does | T29 |
| Scientist 9: the drawing matches the rules (whole points, 14 abilities sorted, column not card, buys card from the run, move names) | T17, T18, T23, T24, T10; the drawing |
| Scientist 10: probes on the amateur fight week too | section 10 |
| FM 1: every option priced in the other panels' terms from one run | T24, T19, T10, T8, T9 |
| FM 2: what this week buys | T23 |
| FM 3: after-the-bout flag with the price of bringing it forward | T2 |
| FM 4: abilities sorted by worth against the opponent; show all 14; no old-seven row | T18 |
| FM 5: the goal on the header and its row | T25 |
| FM 6: the fighter's voice on the load | T26 |
| FM 7: the coach's grade per cell | T27 |
| FM 8: amateur phase words; keeps reads the plan | T9, T15 |
| FM 9: probes before pixels; flat fade raises the fast rates | section 9 (ON SCREEN), section 10, T15 |
| FM 10: draw the professional's camp and Ana's mat | 8b, build step 4 |
| FM 11: partner level | T4 |
| Rounds 1 and 2 | v3's answers kept (CLUBWEEK v4.1 and T1 to T22) |

## REJECTED (asks not taken, and why)
- FITNESS AS THE TOP OF LEGS (v3's own T14, withdrawn in v4): a second fitness beside Cardio; the scientist showed a Cardio-70 fighter after a
  light month would enter with less tank than a Cardio-60 fighter. Work capacity shows the usual hours instead, as what is safe.
- A FIFTH LOAD FOR THE FIGHT WEEK (CLUBWEEK's Rest up / Tick over / Train through beside Easy / Sharpen / Normal): one choice, two names would be
  two rules. In a fight week the load IS the shape (6b).
- HARD IN A FIGHT WEEK: not offered; Train through (Normal) is the most a fight week takes.
- A FIXED LEGS COST PER SHAPE ("about 8", "about 12"): the Legs come from the week as laid, so a slow recoverer and a fresh start differ.
- A THIRD NIGGLE ANSWER ("pads only"): the per-hand pause already keeps the other hand's cards; a third answer is a third estimate.
- NEW FIGHT LINES FOR DEFENCE, SPEED AND FOOTWORK: the fight already grades the calls on them (Exchanges.grade); v4 shows those lines.
- MOVING THE FADE LINE WITH THE ROUNDS: the code's fade already hits every round from the third; shown instead (T22).
- FITNESS AND TIREDNESS AS TWO BARS: one Legs bar (CLUBWEEK); the curve lives on Condition.
- A FIXED SUPERCOMPENSATION BONUS AFTER A DELOAD: the payoff comes from the code's two time constants and Sharpen's dose.
- COACHABILITY AS A MULTIPLIER: lines at 40 and 70 (T7).
- TRAIN THROUGH AN INJURY: an injury already closes bouts; push on is for niggles only.
- MOOD ON ANA'S MAT GAINS: Ana's classes are always coached; mood bites through the stripe call (CODE).
- A ROW SAYING A MOVE "DROPS TO LEARNING": the code keeps Usable for good.
- A LETTER GRADE PER CELL (FM 7's "bag A"): CoachAreas already prints a lift in per cent; one scale, the one the Staff page shows.
- SORTING BY THE MULTIPLIER ALONE (FM 4 expected Timing first): the sort is worth a point x the multiplier; Fight IQ and Timing are tested
  hardest by Kayleigh but Footwork and Defence are worth more a point (Attrs.VALUE, measured). The column shows both.
- STALENESS AND "IT CLICKED" WEEKS; A SEASON STORY CHART; ONE FOCUS A MONTH; PLYOMETRICS AS AN ELEVENTH MORNING; PER-MORNING INTENSITY AS THE
  MAIN CHOICE; PAD PLACES SPLIT 70/30; A WHITE BELT TEACHING: as in v3.

## Risks, said plainly
- More rules again: the load on real hours, Sharpen, dose, ceilings, lines, the sort, niggles, one run. The reveal order carries it: week 1
  shows the load, the strip and room to grow; the first niggle with the first Hard week; the opponent's sort with the first booking; fades
  from week 3; Sharpen with the first fight week.
- Before NOCAMP1 lands, Legs do nothing on an amateur bout, so the load's Legs line is hidden for amateurs until it does (never a dead number).
- Fade can feel like punishment: it never takes more than 3 points under the season's best, and every fading row names the one session that stops it.
- The doses, Sharpen and the pattern are guesses until FITLEGS1, DETRAIN1 and PATTERN1. If FITLEGS1 says Sharpen is not worth 1 in 100 over
  Easy, it folds back and the taper returns to Light; the map keeps the load on real hours, Legs on every bout, ceilings, lines, the sort,
  niggles and habits.
- FireLevel changes every plan's numbers: FIRELEVEL2 first; a good plan must stay 55+ in 100.

## TRAINING FOR THIS VERSION
1. THE LOAD A WEEK on the game's real hours: Easy, Normal, Hard, Sharpen, each priced from one run in hours, injury, Legs, the goal and points.
2. LEGS ON EVERY BOUT (with the fight link map); work capacity as the slow reward; fitness is the abilities.
3. SHARPEN: the taper, the deload and the fight week keep the pace and cut the sessions.
4. FADE BY DOSE: one session in each ability's window keeps it; the keeps column reads the plan.
5. ROOM TO GROW: each ability's own ceiling (the code defect fixed) and on screen.
6. THE NEXT LINE per ability with its day, flagged when it lands after the bout, with the price of bringing it forward.
7. THE OPPONENT SORTS THE BOARD: worth a point x what this opponent tests; Coach leans toward it.
8. WHAT THIS WEEK BUYS for the next bout, and every option priced in the other panels.
9. NIGGLES FROM THE LOAD, cross-priced; injuries trained around.
10. WEIGHT to the scale's day and its hour.
11. THE PERSON: the goal on the tab, the fighter's ask on the load, coachability's habit steps, Recovery shown, the coach's grade per cell.
12. THE SEASON STRIP and SEASON SO FAR; bouts teach a little; ten mornings one job each; sparring by setting and partner; own tape; pad time
    past Usable; Coach runs it; Ana's class kinds.
Built already and kept: the gain rule, phases, tiredness and the 80 line, the injury model, kcal and weight, pad nights and the move ladder,
peak camp, perks, the awards, the professional camp.

## LEFT FOR LATER
- Moving up a class (the owner's call in CLUBWEEK section 12).
- Scars and age: past injuries raising risk, a fighter's prime and decline (RPG LEFT FOR LATER).
- Crossover training (a boxer learning to grapple) waits for the crossing rules.
- Strength-and-conditioning staff running mornings as a third coach.
- Altitude, travel camps, nutrition plans beyond the three diets, sleep.
