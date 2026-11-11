# TRAINDEPTH1: the training map, deepened for this version (S432)

The owner's question: "how deep are the training mechanics ? have critics rated them ?"
Two fresh, blind critics scored the training as built 5 and 5 (about 6.5 each if CLUBWEEK v4.1 and the RPG layer are built as written).
Reviews: `docs/mockups/s432/critics/train_coach_review.md` (a club head coach) and `train_sim_review.md` (a sports-sim training designer);
their 10/10 drawings beside them. This map answers both lists inside this version's scope: four fighters (one professional, two
amateurs, Ana the grappler), amateur to a first professional fight.
Builds on, never rewrites: CLUBWEEK v4.1 (`ops/research/CLUBWEEK_MAP_V41_S432.md`: the shared board, pad places, coached mornings,
the sparring pair and setting, mood rates, the season target, the rota) and the RPG layer v3 (`ops/research/RPG_LAYER_MAP_S432.md`:
Known, traits at lines, build direction, perk versions).
Words: "You" is the head coach, the player. "Coach" is the hired assistant coach. "Cardio" is the stamina group. Game text never says
he, she, her or him. Drawn: `docs/mockups/s432/training_v2.png` (the Training tab, Samira Khan, Monday of week 7).

## 1. The verdict in one line each
- WHAT IS GOOD AND STAYS (both critics): the sport science (kcal, load against the usual 42-day load, tiredness that carries over, the 80
  line), the coach writing the week from the phase with the player changing exceptions, one gain rule for forecast, day and review, pad
  nights with dated drill cards, peak camp, the move ladder, perks opened by training, the skills awards.
- WHAT IS THIN (both critics): nothing is shared between four fighters; every choice moves a decimal nobody feels; the fighter as a
  person (mood, discipline, coachability, habits) plays no part in the week; no season the player can shape; weight is Hold or Cut;
  some sessions are duplicates; Ana has almost no weekly choice; the real screen hides its own key lines.
- WHERE EACH POINT GOES: the sharing is CLUBWEEK's (already mapped, scored 7 and 7). This map takes everything that happens INSIDE one
  fighter's week and season, and fixes the tab. Section 11 lists every critic item and where it went.

## 2. The idea in seven lines
1. ONE LOAD A WEEK, not 28 intensity picks: Easy, Normal or Hard per fighter per week, each priced in tiredness, injury and whole points.
2. SIZES YOU CAN FEEL: "Defence 52 on Wednesday", "Check hook Usable Friday", "+1 to +2 in 100 on Sat 28 Feb". Decimals only in hover.
3. ONE SESSION PER JOB: every trainable ability has a morning; look-alike pairs print what really differs (kcal against Recovery).
4. HABITS ARE TRAINING WORK: found in fights, sparring and your own tape; trained out on your pad places through a half-fixed state;
   they come back when the fighter is worn down.
5. THE PERSON TRAINS TOO: coachability sets what a coached session gives; mood and discipline (CLUBWEEK) show where they bite.
6. A SEASON PER FIGHTER: the season target (CLUBWEEK) laid as 12 weeks; you place DELOAD and REST weeks and see the Legs on each bout day;
   the skills award and the bleep test sit on it as dates.
7. WEIGHT IS ALWAYS THERE: walking weight against the class, Hold / Lean / Cut, and a Cut that costs training.

## 3. The training as built (traced in the code, S432)
| Part | What the code does | Where |
|---|---|---|
| Mornings | 10 sessions (roadwork, intervals, heavy bag, strength, speed bag, slip rope, shadow, neck, mobility, rest); each a fifth of a focused week (SESSION_SHARE 0.2) x Light 0.6 / Normal 1.0 / Hard 1.3; x0.6 when tiredness is 80+ | WeekPlan.SESSIONS, INTENSITY, TIRED_GAIN |
| The gain rule | 1.0 a focused week x coach factor (0.5 + rating x 0.007; alone 0.6) x headroom clamp((potential - stat) / 25, 0.10, 1.25) | TrainingPreview |
| Coach | the hired coach's area rating reaches EVERY fighter on EVERY session; no limit | Sim.gd ctx (career.coach), CoachAreas.rating_for |
| Phases | Base / Build / Peak / Taper counted back from a booked bout; the coach writes the week, the player edits exceptions | WeekPhase |
| Tiredness | keeps 87% a night (FATIGUE_KEEP); 44 load points a point; 80 = overreached (gains x0.6, injury x3) | WeekPlan |
| Injury | this week's hours against the usual (EWMA, 42 days): 1.3 safe, 1.5 a spike (2 to 4 times the risk); about 1.3 in 100 a normal week | TrainingLoad, Injuries |
| Weight | kcal = MET x kg x hours; Hold = daily life + 300; Cut = -500 kcal a day (about 0.45 kg a week); Cut costs nothing else | WeekPlan.day |
| Evenings | pads (75 real minutes, drawn as "240 min"), sparring (Fight IQ and a share to cards in hand), film, rest; split 50/50, 70/30, 30/70 | PadWeek, PadEdit |
| Moves | mastery 2.1 a pad hour; Learning, Usable 30, Sharp 60, Signature 85; capped by Technique and Fight IQ | MoveMastery |
| Firing by tier | built and SWITCHED OFF: a line fires 1 in 2 at Usable, 3 in 4 Sharp, always Signature (+2.8 in 100 a step, S427) | FireLevel |
| Habits | one fixed at signing (gone in 4 weeks) or patched for one round in the corner; a punished habit costs 6 power that exchange | Recruit.HABIT_WEEKS, HabitFix.HABIT_COST |
| The person | coachability, discipline and mood are read by NOTHING in the week | (checked: WeekPlan, Sim.step_day) |
| Peak camp | weight made, camp stat on target, never overreached: +1 every stat on the night (professional camp) | PeakCamp |
| Awards | six grades, 8 coached sessions each; a graded move costs 8% less gas (Gold 12%); bleep level read from Cardio | SkillAwards |
| Ana | 3 classes a week drill the move nearest owned (3.2 mastery a week); Cardio +0.6, Strength +0.3 a week | NoGi |
| Old block plan | TrainingPlan's 0 to 6 blocks still feed one read (fractions) beside the seven mornings | Sim.gd 107-114 |

## 4. Where training is decided (one place each)
| Decision | Screen | Why there |
|---|---|---|
| Who gets the pad places, the coached mornings, the seat; the sparring pair and setting; the twist | Fighters > Club week (CLUBWEEK) | they are shared between the four |
| The pull each fighter follows (weak spot, weapon, goal, ahead) and the season target | Club week | they set what the shared slots go to |
| THE LOAD for the week; morning exceptions; which card each pad place drills (the habit card among them); the diet; deload and rest weeks on the season strip; Coach runs this fighter's week | Fighter page > Training (this map) | they touch one fighter only |
| Ana's class kinds and the drill | the grappler's page (Training) | one fighter |
The Training tab shows the shared slots (who coaches, the sparring partner) LOCKED with "change on Club week". Nothing is decided twice.

## 5. The mechanics

### T1. ONE LOAD A WEEK (replaces Light / Normal / Hard on every morning)
- WHAT YOU DECIDE: per fighter, per week: EASY, NORMAL or HARD. One choice on the Training tab, also a chip on the fighter's Club week row.
  A single morning can still be set apart (an exception in the morning's popover), as today.
- WHAT IT CHANGES (the code's numbers, applied to every morning of that fighter):
| Load | Morning gain | Load | kcal | What it costs (shown on the button, for THIS fighter this week) |
|---|---|---|---|---|
| EASY | x0.6 | x0.6 | x0.7 | tiredness peak about 15 lower; the usual load slides (a second Easy week in a row: the next Normal reads as a spike) |
| NORMAL | x1.0 | x1.0 | x1.0 | the coach's week (peak about 68 in a camp) |
| HARD | x1.3 | x1.5 | x1.35 | from a usual 10 h, 15 h is a 1.5 spike: training injury 2 to 4 times; overreached in the second Hard week running (about 83) |
- ON THE BUTTON (sizes, never decimals): "Hard: tired peak 74 · injury 3 in 100 (usual 1) · Defence 52 Tue, 53 by Sat 28 Feb". The
  numbers are the week run through WeekPlan.week, so the button cannot lie.
- WHY: both critics called 28 per-morning picks a week, each worth hundredths, the weakest choice in the game. The real call a coach makes
  is how hard THIS boxer goes THIS week; the morning-by-morning shape is the coach's craft and stays the coach's (the phase templates).
- LINKS: Club week (the chip; Coach deals it picks Normal, Easy in a Rest week, Hard only 3+ weeks from a bout with tiredness under 40);
  RPG (Hard school makes Hard x1.4; discipline under 50 pushes back on a Hard week, code PushBack); the fight (tiredness becomes the Legs
  bar at the bell, CLUBWEEK; a training injury pulls a bout).
- PROBE LOADDIAL1, cut rule below.

### T2. SIZES YOU CAN FEEL
- WHAT CHANGES ON SCREEN: every session cell, the load buttons and the week's summary print what crosses a WHOLE point and on which day
  ("Defence 52 Wed"), what turns Usable or Sharp and when ("Check hook Usable Fri"), and, with a bout booked, the week's worth on that bout
  as a RANGE in wins in 100 ("+1 to +2 in 100 on Sat 28 Feb"). Two-decimal gains live in hover only.
- NUMBERS: whole-point days from WeekPlan.week (exact, the same rule as the sim). Wins in 100 only from the probes' tables (CLUBWEEK
  LeverSize; one point of an ability is worth about 4 to 5 in 100 at the measured 5 points = 72 in 100, weighted by Attrs.VALUE). A size
  the probes have not measured is not printed.
- WHY: "a player can see a week was tiring; it is hard to see it was GOOD" (sim critic). The decimals stay true; they move to hover.
- LINKS: CLUBWEEK LeverSize and "your week against Coach's"; the Monday review prints the same whole points.

### T3. ONE SESSION PER JOB (the morning menu)
| Morning | Trains (Attrs.SESSION_ATTRS) | Printed at the moment of choice | Change |
|---|---|---|---|
| Roadwork | Stamina | "Cardio · burns about 460 kcal (best for the scale) · tired +5" | kept |
| Intervals | Stamina + Recovery | "Cardio + Recovery · about 360 kcal · tired +6" | CHANGED: adds Recovery (repeat-sprint work), so it is not a twin of roadwork |
| Strength circuit | Strength | "Strength · tired +6" | kept |
| Heavy bag | Explosiveness + Inside fighting | "Power punching, up close · tired +5" | CHANGED: was Strength + Explosiveness (a twin of the circuit); bag rounds are where club boxers work the inside |
| Speed bag | Speed | "Hand speed, rhythm · tired +2" | kept |
| Footwork drills | Footwork | "Ring cutting, ladder, angles · tired +4" | NEW: Footwork is worth 0.085 a 10 points (second only to Defence) and was trained only as a side share of shadow boxing |
| Slip rope | Defence | "Slips and rolls · tired +2" | kept |
| Shadow boxing | Accuracy + Footwork | "Form, shots that land · tired +2" | kept |
| Neck work | Durability | "Takes a punch · tired +1" | kept |
| Rest | Recovery + Flexibility, tiredness drains | "Fresh legs" | CHANGED: Mobility folds in here (Flexibility is worth 0.015, the least of all, and a stand-alone morning was a decoy); Rest no longer takes its Recovery out of Stamina (the old legacy share) |
- NUMBERS: footwork drills ESTIMATE MET 7, 30 minutes, RPE 6 (agility and skipping work, Compendium range 6 to 8); kcal for a 66 kg boxer
  from the code's METs (roadwork 9.3 x 66 x 0.75 h; intervals 11 x 66 x 0.5 h); "tired +n" is the session's load / 44.
- Ten mornings stay ten. The old block plan (TrainingPlan) is retired; its one read takes its fractions from the seven mornings.

### T4. WHAT A SPARRING SETTING TRAINS (extends CLUBWEEK's SparSet; the pair and setting are picked on Club week)
| Setting (CLUBWEEK prices kept) | Trains (NEW: the setting decides WHAT, not only how much) | Reveals (RPG: traits; this map: habits) |
|---|---|---|
| HARD (x1.3, +12 tired, cut 4 in 100) | Composure, Inside fighting, Fight IQ, and Fire known faster | a hidden habit 1 in 3, a trait 1 in 2 |
| TECHNICAL (x1.0, +6, cut 1 in 100) | Timing, Defence, Fight IQ | a hidden habit 1 in 5, a trait 35 in 100 (code) |
| BODY ONLY (x0.8, +8, no cut) | Inside fighting, Stamina, body punches | a hidden habit 1 in 10 |
- Today one sparring night trains Timing, Defence, Inside, Fight IQ and Composure at once (Attrs.SESSION_ATTRS["sparring"]); the setting
  splits that list, so the pick changes WHICH abilities move, not only by how much. ESTIMATE reveal odds; SPARTRAIN1.
- LINKS: the habit card (T5) gets its finds here; the partner's weight and stance stay CLUBWEEK's; the RPG's temper drift (Hard) stays.

### T5. HABITS ARE TRAINING WORK (NEW)
- WHAT IT IS: each fighter carries habits (FighterProfile.HABITS; the signing card shows one, the rest are hidden). In a bout, a habit
  the opponent's game punishes costs 6 power in that exchange (HabitFix.HABIT_COST, code; HabitFix.PUNISHED_BY names which game punishes it).
- HOW ONE IS FOUND: the fight (a punished habit goes into Coach's notes at the bell: code); sparring by setting (T4); YOUR OWN TAPE (T6).
- WHAT YOU DECIDE: put the HABIT CARD on your own pad places (CLUBWEEK: only your pad places train a habit; you hold 2 a week).
| State | How it gets there | In a bout |
|---|---|---|
| THERE | found | costs 6 an exchange where punished |
| HALF FIXED | 3 of your pad places on it (2 at Known 3, RPG) | costs 3 |
| GONE | 6 of your pad places (4 at Known 3) | costs 0 |
- IT COMES BACK (the relapse): in the WEEK, three weeks running with a tiredness peak over 70, or one week at Low mood: one step back
  (Gone to Half fixed, Half to There). In the BOUT, once the fighter's energy falls under 30, the habit plays one step worse for the rest
  of the bout. One pad place puts a slipped habit back. The card prints both lines: "Slips back: 3 weeks over 70 tired, or tired in a bout".
- THE SIZE ON THE CARD: what GONE is worth against the booked opponent, as a range from HABITWEEK1 ("Sat 28 Feb, Kayleigh Bell, a
  counter-puncher: gone +2 to +4 in 100"). Against an opponent whose game does not punish it: "Kayleigh does not punish it".
- The signing card's "Fix the habit" focus (Recruit, 4 weeks) stays: it starts that habit at HALF FIXED with Coach's 2 pad places a week.
- REAL BASIS: a coach drills a fault out on the pads over weeks ("hands back to the chin after the jab"); a half-learnt correction holds in
  the gym and breaks down when the boxer is tired (motor skills degrade with fatigue). ESTIMATE: 6 pad places, the 70 line, the energy 30 line.
- LINKS: Club week (the habit is one of the four pulls; your pad places are the scarce coin); RPG (Known 3 a week sooner; Coachability under
  40 halves a corner fix, the corner's patch for one round stays); the fight (HabitFix reads the state); the Why ("Drops the right after the
  jab: cost 3 exchanges, half fixed. Gone in 2 of your pad places").

### T6. FILM WITH NO BOUT = YOUR OWN TAPE (replaces a dead option)
- Today Film is offered on every evening, with or without an opponent to study (both critics: useless with no bout).
- NOW: with no bout booked the evening reads "Film: your own sparring". It costs what film costs on Club week (a whole Coach evening, 2 pad
  places) and finds the next hidden habit for sure, or, with none left, the most hidden trait (RPG). With a bout booked it is the opponent's
  tape as today (CLUBWEEK's three questions).
- REAL BASIS: club coaches film sparring to show a boxer the fault they cannot feel. OWNTAPE1 checks a found habit pays its 2 pad places.

### T7. THE PERSON TRAINS TOO
- NEW: COACHABILITY sets what a COACHED session gives: x(0.85 + 0.3 x coachability / 100), so 0.91 at 20, 1.0 at 50, 1.09 at 80. A
  session alone is not touched (it runs at the mood rate). Shown on the fighter's row: "Coachability 36: your sessions x0.96".
- FROM CLUBWEEK, SHOWN HERE: a session alone at the mood rate (Fired up 0.8, Steady 0.6, Flat and Low 0.4); discipline under 45 skips 1
  alone morning in 3 unless a team-mate trains in the room. The Training tab prints each against the session it touches ("alone x0.8",
  "may skip: put Tess in the room").
- WHY: "In FM the professionalism and morale of a player are half the training story" (sim critic). It turns WHOM you coach into a choice
  with a person in it, and gives the RPG's coachability line a weekly use.
- LINKS: RPG traits (coachability moves +1 an ask heard, -2 overruled: the button that moves it); CLUBWEEK coached mornings. COACHABLE1.

### T8. WEIGHT IS ALWAYS THERE
- WHAT YOU DECIDE: the diet, on the Training tab and the Club week row (CLUBWEEK's diet cell), WITH OR WITHOUT a bout booked:
| Diet | kcal a day | About a week | Its price |
|---|---|---|---|
| HOLD | daily life + 300 for training (code) | walking weight holds | none |
| LEAN (NEW) | -250 | -0.23 kg | none |
| CUT | -500 (code; the Old hand head coach -620) | -0.45 kg | NEW: mornings x0.9 while cutting (low energy available, training quality drops) |
- ON SCREEN, ALWAYS: walking weight, the class limit, the next weigh-in that reads the class (the nationals, a professional bout) and the
  day the line lands ("65.9 kg · class 65.0 · nationals weigh-in Fri 3 Apr · Lean lands it Mon 16 Mar").
- Club bouts at walking weight with the 1.0 kg gap and the scale's answers on the day stay CLUBWEEK's.
- REAL BASIS: 500 kcal a day is the usual cut and 0.5 to 1% of body weight a week the safe rate (Reale et al. 2017, in WeekPlan); training
  in a large deficit lowers the work a boxer can do. ESTIMATE: x0.9. LEANCUT1 checks Lean is the right answer more than 1 time in 4.

### T9. A SEASON PER FIGHTER (the strip on the Training tab)
- WHAT IT SHOWS: the next 12 weeks of THIS fighter as blocks, drawn from the season target (CLUBWEEK 3.9) and the bookings: BUILD, FIGHT WEEK
  (amateur), CAMP weeks BUILD / PEAK / TAPER (professional, code), REST, DELOAD, and the dates that matter: bouts, entries closing, an open
  (Ana), the next skills award assessment, the bleep test.
- WHAT YOU DECIDE (NEW): place a DELOAD week (Easy load, no sparring, at most 1 in 3 weeks) or a REST fortnight after a bout (CLUBWEEK's
  Rest) on any week; drag it off again. Each fight week on the strip prints its LEGS AT THE BELL (CLUBWEEK's tank bar) as the strip stands,
  so the price shows before the drop ("Regional semi Sat 4 Apr: Legs 91 with the deload, 76 without").
- WHAT A DELOAD DOES (code numbers, no invented bonus): tiredness drains (87% kept a night, no new load); the usual load holds (one Easy week
  takes 10 h to 8.9 h, TrainingLoad's EWMA), so the week after is not a spike; a fifth of the week's gains. Its value is fresh legs on a
  bout day and fewer injuries; DELOAD1 must find it.
- TESTS AS DATES: the next skills award grade is assessed after 8 coached sessions (code); the strip prints its date and what it still
  needs ("Silver Sun 22 Mar: Check hook 24 of 30, 2 pad places"). A pass gives the grade's gas saving (code: 8%, Gold 12%) and +3 exposure
  to Skills in Known (RPG). The bleep test is read every 6 weeks and printed as "level 7.4 (club 7.0)".
- WHY: both critics: no season the player can shape; the phases exist only as the coach's four words. The target is CLUBWEEK's; this is
  the fighter's own line toward it.

### T10. PAD TIME PAST USABLE IS WORTH IT
- SWITCH ON the measured firing rule (FireLevel, built, S427): a planned line fires 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature
  (+2.8 in 100 a step, measured on 400 bouts a cell). Without it a pad place spent past Usable is worth about 1 in 100 (both critics).
  FIRELEVEL2 re-runs it on this line-up first: if a good plan falls under 55 in 100 (59 today), the shares become 0.75 / 0.9 / 1.0.
- THE PAD NIGHT, SIMPLER: "75 minutes" (not "240 min"); a pad place drills ONE card, or two cards half each (the 70/30 and 30/70 splits go);
  each card prints its date ("Usable Fri", "Sharp in 3 pad places").
- LINKS: Playbook (each line shows "fires 1 in 2: Usable" beside it); CLUBWEEK's Ahead pull and finish-a-punch price; skills awards.

### T11. COACH RUNS IT, PER FIGHTER (agreed, not built; now placed)
- WHAT YOU DECIDE: on the Training tab, "Coach runs <name>'s week": Coach's deal for this fighter every Monday (load, mornings, pad cards,
  diet), none of YOUR sessions go to this fighter, and Known stops growing (RPG). The button prints its size: "Coach's week against yours:
  -1 to -2 in 100 on Sat 28 Feb; frees your Wed pad places".
- WHY: with four fighters a player needs to hand one week over knowingly, and see what it gives up. COACHRUNS1.

### T12. ANA'S MAT WEEK (class kinds; the classes 3 or 5 stay CLUBWEEK's)
| Class kind (one per class) | Mastery on the drilled move | Body | Tiredness | Price |
|---|---|---|---|---|
| DRILL | x1.5 (about 1.6 a class) | none | +3 | no Fire known, no open edge |
| POSITIONAL (start in a position, 2-minute rounds) | x1.0 | Guard or Top game +0.15 (the direction leans it, RPG) | +6 | |
| HARD ROLLS | x0.6 | Cardio x2 (the code's BODY_GAIN), Composure | +10 | a mat injury 1 in 100 a class |
- OPEN PREP: each Hard rolls class in the 14 days before an open adds 1 in 100 a match (at most +4), against slower stripe progress.
- WHAT YOU DECIDE: the kind of each class (Coach's default: 2 drill + 1 positional; the week of an open: 1 drill + 2 hard rolls), shown with
  the stripe date for each choice ("blue by 30 Jun" against "blue by 21 Jul"). The drill choice (coach / open / favourite, code) stays.
- REAL BASIS: academies run drilling, positional sparring and open rolling as different classes; competitors roll harder before a
  tournament. ESTIMATE every number; BJJCLASS1.

### T13. THE TAB'S DEFECTS, FIXED NOW (seen on `trainingb2_23e_real.png`)
- The coach's change sits under the guide bubble: the coach's line gets its own place; the guide never covers a button's subject.
- The goal line is half under the coach's portrait: moved into the week's summary.
- The fight date, the phase and the camp lines live in a hidden Legacy panel (WeekBoard._build): shown on the season strip.
- Day tiles are icons only: every cell has the session's word and who coaches it.
- "240 min tonight": "75 minutes". "Leave": "Back to Coach's week". The bare "Combo" bar: "Build a combination" (opens Playbook > Combos).
- Tiredness opens at 78 with no reason: the curve's first point says why ("carried from last week: 3 hard nights").

## 6. Every decision
B = before the week, D = during, A = after. The last column is the designer's test (never printed on screen).
| When | Decision | Options and what each costs and gives | Right when |
|---|---|---|---|
| B, Monday | The load (T1) | Easy x0.6 / Normal / Hard x1.3 gains; Hard x1.5 load (a spike from a usual 10 h), overreached in the second Hard week | Easy: a bout inside 7 days or tiredness 60+. Hard: 3+ weeks to a bout, tiredness under 40, Easy last week not taken |
| B, Monday | A morning exception | any of the ten mornings on one day, at its own load | a team-mate in the room (discipline), or a weigh-in near (roadwork's kcal) |
| B, Monday | Roadwork or intervals (T3) | more kcal against + Recovery | Roadwork: on Cut or Lean. Intervals: Recovery under the fighter's level |
| B, Monday | Heavy bag or strength (T3) | Explosiveness + Inside against Strength | Bag: a pressure fighter, or a perk at Explosiveness. Strength: Strength is the weak spot |
| B, Monday | The habit card on your pad places (T5) | 3 to half fixed, 6 to gone; your pad places leave a weapon or the Ahead card | the next opponent's game punishes it |
| B, Monday | Film: your own tape (T6, no bout) | a Coach evening (2 pad places); one hidden habit found | Known Skills low, or a loss with an unexplained Why |
| B, Monday | The diet (T8) | Hold / Lean -250 / Cut -500 (mornings x0.9) | Lean: a class weigh-in 4+ weeks off. Cut: 2 to 4 weeks off and over 0.5 kg. Hold: walking weight under the class |
| B, any week | Deload or Rest on the strip (T9) | a fifth of the gains, legs fresh, no spike after | Deload: the week before a fight week after 3 Normal or Hard weeks. Rest: after a hard bout |
| B, Monday | Which card each pad place drills; one card or two halves (T10) | dated tiers; firing by tier | a card within 2 pad places of a tier, or the Ahead pull |
| B, Monday | Coach runs this fighter's week (T11) | your sessions freed; Known stops; its size printed | that fighter's size is under 1 in 100 against yours |
| B, Monday (Ana) | Each class kind (T12) | drill / positional / hard rolls | Hard rolls: an open inside 14 days. Drill: a stripe inside 4 weeks |
| D, the bout | (none new) | the habit's state and its relapse play by themselves | |
| A, the Why and Monday | "Put the habit card on next week", "Deload next week", "Train X" | one click into the Training tab with it set | the Why names a cost the week can fix |

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > Training (drawn) | the season strip (12 weeks, deload and rest you place, Legs on each bout day, award and bleep dates); the LOAD (three priced buttons); the week (7 days, AM and PM, each cell the session's word, who coaches by colour, the whole point it crosses); the pad nights with dated cards and the habit card; the tiredness curve with 80 (overreached) and 70 (habits slip); the habit card; weight; the person (mood, coachability, discipline at the sessions they touch); the week's sizes and your week against Coach's; Coach runs it; Back to Club week | WeekBoard, WeekEditors, WeekTiles, WeekTired, WeekDay, WeekCards; WeekPlan (load, sessions, diet), TrainingPreview (coachability factor), TrainingLoad, PadWeek, PadEdit, MoveMastery, FireLevel; NEW HabitWork rule, NEW SeasonStrip rule, LeverSize (CLUBWEEK), SkillAwards, Knowledge |
| Fighters > Club week | on each row: the load chip, the diet cell, a habit chip with its state, "Coach runs it" mark; the shared slots as CLUBWEEK | ClubDeal, WeekPlan, HabitWork |
| Fighter page > Overview (Profile) | the habit's state and size beside the habits; weight line; the abilities' "+ Footwork drills" pills | FighterPage, AttrBoard, HabitWork, WeekPlan |
| Fighter page > Condition | the tiredness curve, Legs on the next bout day, relapse warning | WeekTired, SeasonStrip, HabitWork |
| Playbook > Game plan, Combos | "fires 1 in 2: Usable" beside each line and card | PlanLines, PlanBoard, FireLevel |
| Fight night and the corner minute | a habit acts at its state and one step worse under 30 energy; the corner's fix for one round (code) | HabitFix (reads HabitWork state), CornerJobs |
| Result and the Why | habit cost with its state and "Put the habit card on"; Legs at the bell and what the strip did | FightWhy, WhyCard, HabitWork, SeasonStrip |
| Week review (Monday) | whole points crossed and their sessions; habits moved (and slipped, with the reason); deload weeks and the injury roll they avoided; award dates | WeekReview, ReviewReveal, WeekCause, HabitWork, SkillAwards |
| Coach's notes | habits and traits found, where (fight, sparring setting, own tape) | CoachNotes, HabitWork |
| Grappler page | class kind per class with the stripe date for each; open prep | GrapplerPage, NoGi (class kinds), BjjSide |
| Fight prep | the habit's size against this opponent; the diet against the weigh-in | FightPrep, HabitWork, WeekPlan |
THE NEW MECHANICS, MENU BY MENU (each shows on every menu listed in the .exe, and the golden-path test walks it):
| Mechanic | Menus |
|---|---|
| T1 load a week | Training, Club week row, Week review |
| T2 sizes | Training, Club week, Week review, Fight prep |
| T3 morning menu | Training (the morning popover), Overview pills |
| T4 sparring trains by setting | Club week sparring card, Training cell, Coach's notes |
| T5 habits | Training, Club week, Overview, Fight night, the Why, Week review, Coach's notes, Fight prep |
| T6 own tape | Training (evening popover), Club week, Coach's notes |
| T7 coachability in the week | Training, Club week row, Character tab (RPG) |
| T8 weight always | Training, Club week row, Overview, Fight prep |
| T9 season strip, deload, tests | Training, Condition, Week review, the Why |
| T10 firing by tier, pad night | Training, Playbook, the Why |
| T11 Coach runs it | Training, Club week row |
| T12 Ana's class kinds | Grappler page, Club week (Ana's row) |

## 8. Numbers: from the code, or ESTIMATE
FROM THE CODE: the gain rule, coach factor, headroom, intensity 0.6 / 1.0 / 1.3, load x0.6 / x1.0 / x1.5, tiredness 0.87 and 44 and 80,
x0.6 overreached, the 42-day usual load and the 1.3 / 1.5 lines, kcal by MET, 7,700 kcal a kg, the -500 cut, mastery 2.1 a pad hour, the
tiers, HABIT_COST 6, the punish table, the award grades and their gas, FireLevel's measured shares, Ana's 3.2 a week and body gains,
Attrs.VALUE (Footwork 0.085, Defence 0.090, Flexibility 0.015).
ESTIMATE (first guesses for the probes): footwork drills MET 7; the habit's 3 and 6 pad places, the 70 line and the 30-energy relapse; the
reveal odds by setting; coachability 0.85 to 1.15; Lean -250; Cut x0.9; deload at most 1 in 3 weeks; Ana's class kinds; open prep +1 a class.

## 9. To be measured before the build (each a probe on the played bout, never the harness's average)
THE CUT RULE (both critics, as CLUBWEEK): a choice worth under 1.5 wins in 100 on the bouts it touches AND with no season effect (weeks to
the target, bouts a season, a fighter kept, dollars) is cut, not drawn.
- LOADDIAL1: a season of each load policy (always Normal; Hard 3+ weeks out; the bot that reads tiredness) on this line-up. Target: the
  reading bot beats always-Normal by 1.5+ in 100 on bouts, and always-Hard loses a fighter-month to injury a season. Else Easy and Hard
  are re-priced; if still flat, the load goes back to the coach and the screen keeps only the curve.
- MORNINGS1: roadwork against intervals, bag against strength, each over 8 weeks: each pair differs by 1 point of an ability or 0.5 kg.
- SPARTRAIN1: a season of Hard, Technical and Body only: each setting is best for some fighter; the reveal odds find a habit in 4 to 8 weeks.
- HABITWEEK1: one habit THERE, HALF and GONE against an opponent whose game punishes it: GONE worth 1.5+ in 100 (else HABIT_COST rises to 8
  before any screen); the relapse fires in 1 to 3 bouts in 10 for a tired fighter.
- OWNTAPE1: a found habit trained out repays the 2 pad places within the season.
- COACHABLE1: coachability 30 against 80 moves a season by 1+ point of the focused ability; else the factor widens or leaves the week.
- LEANCUT1: Lean is the best diet in at least 1 week in 4 across a season of weigh-ins; Cut's x0.9 costs 0.5+ points a camp.
- DELOAD1: a deload the week before a fight week against none: 1.5+ in 100 on that bout or fewer training injuries a season; else deload
  folds into Rest.
- FIRELEVEL2: FireLevel on, this line-up: a good plan stays 55+ in 100; a Sharp line is worth 1.5+ over Usable.
- COACHRUNS1: Coach runs one fighter against you running all four: the size printed is within 1 in 100 of the measured gap.
- BJJCLASS1: each class kind is Ana's best in some month of a season (opens, stripes, blue by the date).
- TRAINSEASON1 (the whole map): a careful player against "Coach runs it" for all four over a season: 4+ in 100 more on the season's bouts,
  or the season target 4+ weeks sooner. Else the map is paperwork and is cut back (with CLUBWEEK's SEASON1).

## 10. Build order, in small tasks
1. Probes (cloud, pure, on the played bout): LOADDIAL1, HABITWEEK1, FIRELEVEL2, DELOAD1, then the rest. Each writes the size table LeverSize reads.
2. Rule changes with unit tests, one a task: WeekPlan (the week's load, the ten mornings, Lean, Cut's x0.9); Attrs.SESSION_ATTRS (heavy bag,
   intervals, footwork drills, rest; the Rest/Stamina share fixed); TrainingPreview (coachability on coached sessions); NEW HabitWork.gd
   (state, pad places, relapse, the bout hook read by HabitFix); NEW SeasonStrip.gd (blocks from SeasonTarget and the bookings, deload and
   rest, Legs on bout days, award and bleep dates); SparSet split by setting (CLUBWEEK's module); NoGi class kinds; FireLevel on in
   GameSwitches.GAME_ON; TrainingPlan retired.
3. The Training tab from `training_v2.png`, one task (Cursor, the 2D screen seat), the per-fighter drill-down of Club week.
4. The other menus of section 7, one a task.
5. The golden path: Samira's Monday: the load set to Hard and back to Normal, a footwork morning, the habit card on Wednesday, Lean picked, a
   deload placed before the regional, a Technical sparring night that finds a habit, the bout with the habit HALF FIXED, the Why's
   "Put the habit card on", the next Monday's review naming the whole points; Ana's class kinds before an open.

## 11. Every critic point, and where it went
| Critic point | Where |
|---|---|
| Squad board, shared limits; who spars whom; life around the gym; one club twist; mood alone rates; discipline skips; season target | CLUBWEEK v4.1 (kept; the Training tab is its drill-down) |
| Intensity per week, not 28 picks (both) | T1 |
| Sizes in fight terms, whole points, decimals in hover (both) | T2 |
| A session for every attribute; roadwork/intervals and bag/strength as twins; Mobility a decoy; Rest takes Stamina (both) | T3 |
| Sparring setting priced and what it trains (both) | T4 + CLUBWEEK |
| Habits trained in the week, half fixed, relapse (both) | T5 |
| Film with no bout (both) | T6 |
| Coachability, the person in the week (sim) | T7 |
| Weight as a season line; a gentler option; cut speed with a price (both) | T8 |
| A season strip the player can shape; deload; form on the day; tests as beats (both) | T9 |
| Sharp and Signature worth nothing while the firing rule is off; pad split busywork; 240 min (both) | T10, T13 |
| Coach runs it per fighter (sim) | T11 |
| Ana's mat week: class kinds, hard rolls before an open (both) | T12 |
| Screen defects: guide over the coach's line, goal under the portrait, Legacy panel, icon tiles, Leave, Combo bar (both) | T13 |
| The old block plan (sim) | T3 (retired) |
| Staleness and "it clicked" weeks (sim); a season story chart (sim); move up a class (sim); a focus a month (coach) | REJECTED or LEFT FOR LATER, below |

## REJECTED (asks not taken, and why)
- STALENESS AND "IT CLICKED" WEEKS (sim critic): headroom already slows an ability as it nears its ceiling, and the load ratio already
  punishes sameness of load; a third slow-down would read as the same thing, and changing a session only to dodge it is busywork. A
  random "it clicked" week is a swing the player cannot steer.
- A SEASON STORY CHART ON THE FIGHTER PAGE (sim critic): the progress chart on History is on the agreed "held back" list; the Monday
  review and the Why already name each gain's cause, and the strip shows what is coming, which the player can act on.
- ONE FOCUS A MONTH (coach critic): the pull on Club week is the focus, re-dealt each Monday because the rota, bouts and twists change
  weekly; a month-long lock would fight the bout sheet's 12-day notice.
- A FORM NUMBER (fitness against tiredness, sim critic): the Legs bar is the form on the day (CLUBWEEK) and the strip now prints it on
  every bout day; a second number for the same thing breaks "one word per concept".
- A SUPERCOMPENSATION BONUS AFTER A DELOAD: not in the evidence the game cites as a fixed number; the deload is priced by the code's own
  tiredness and load rules, and DELOAD1 decides whether that is enough.
- PLYOMETRICS AS AN ELEVENTH MORNING (sim critic): the heavy bag now trains Explosiveness; a second Explosiveness session would be a twin.
- PER-MORNING LIGHT / NORMAL / HARD AS THE MAIN CHOICE: kept only as an exception in the popover (both critics: hundredths each).
- COACH'S PAD PLACES SPLIT 70/30 AND 30/70: one card or two halves cover it.
- TEACHING A WHITE BELT TO TEACH, OR A MAT CLASS AT 4 A WEEK: CLUBWEEK's 3 or 5 and teaching from blue stand.

## Risks, said plainly
- Many small rules: a load, ten mornings, habits, diets, a strip. The reveal order carries it: week 1 shows the load and the week; habits
  arrive with the first found habit; the strip with the season target (CLUBWEEK week 5); Lean with the first class weigh-in.
- HABIT_COST 6 may be too small for a habit to be worth 6 of your pad places: HABITWEEK1 comes before any screen.
- FireLevel changes every plan's numbers; FIRELEVEL2 first, and the good-plan line (55 in 100) is the floor.
- The coachability factor and Cut's x0.9 are first guesses; the cut rule removes them if the season does not feel them.

## TRAINING FOR THIS VERSION
1. THE LOAD A WEEK: Easy, Normal or Hard per fighter, priced on the button in tiredness, injury and whole points; morning exceptions stay.
2. SIZES YOU CAN FEEL: whole points with their day, tiers with their day, wins in 100 as ranges from the probes; decimals in hover.
3. TEN MORNINGS, ONE JOB EACH: Footwork drills new; Heavy bag to Explosiveness + Inside; Intervals adds Recovery; Mobility into Rest.
4. SPARRING BY SETTING: the setting decides what is trained and what is found (pair and setting picked on Club week).
5. HABITS AS TRAINING WORK: found in the fight, sparring and your own tape; There, Half fixed, Gone on your pad places; slip back when worn down.
6. FILM WITH NO BOUT: your own tape, a found habit.
7. THE PERSON: coachability scales coached sessions; mood and discipline (CLUBWEEK) printed at the sessions they touch.
8. WEIGHT ALWAYS: walking weight, the class weigh-in, Hold, Lean or Cut (Cut costs training).
9. THE SEASON STRIP: 12 weeks per fighter from the season target; deload and rest you place; Legs on every bout day; award and bleep dates.
10. PAD TIME PAST USABLE: the firing rule on; a 75-minute pad night of one card or two halves; dated tiers.
11. COACH RUNS IT, PER FIGHTER, with its size.
12. ANA'S CLASS KINDS: drill, positional, hard rolls; open prep.
13. THE TAB FIXED: the coach's line readable, words on the cells, real minutes, the date and phase back, "Back to Coach's week".
Built already and kept: the gain rule, phases, tiredness and the 80 line, load against the usual, kcal and weight, pad nights and the
move ladder, peak camp for professionals, perks, the skills awards, the twist (as CLUBWEEK's club twist), the professional camp.

## LEFT FOR LATER
- MOVING UP A CLASS (sim critic): amateur club bouts are at walking weight; the class matters for the nationals and the professional
  tables, and only lightweight and welterweight have professional tables today (CLUBWEEK section 12, the owner's call).
- Scars and age: past injuries raising training injury risk, a fighter's prime and decline (RPG LEFT FOR LATER).
- Crossover training (a boxer learning to grapple) waits for the crossing rules.
- Strength-and-conditioning staff running mornings as a third coach (the staff job exists as an injury cut; a coach seat is a new hire).
- Altitude, travel camps, nutrition plans beyond the three diets, sleep.
