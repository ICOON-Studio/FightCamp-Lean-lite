# WEIGHT1: the weight mechanic, design map round 2 (S434)

Roadmap row WEIGHT1. Author: Claude. Status: ROUND 2, for two fresh critics (the S425 rule: depth 7+ from both before the board).
Round 1 scored: coach depth 7 / clarity 6, sim designer depth 6 / clarity 6. Section 11 lists every critic point and where it went.
The owner, S434: "need to strenghen the weight mechanic , what do you think ?", then "yes start it" to the seven parts below.
Sources: `docs/mockups/s434/weight/REAL.md` (the real numbers, each with its source and tag) and `docs/mockups/s434/weight/CODE.md`
(the code today, file:line). Prior research read: J13 (diet = a weekly PLAN plus a standing DISCIPLINE, never a calorie counter),
Q20 (class choice is body and business, not temper), J7 (purse share 20-25%), J53 (amateur miss = walkover, no fine).
TR = `TRAINING_MAP_S432.md` (T8), CW = `CLUBWEEK_MAP_V41_S432.md` (3.5, 3.7), TS = `TRAINSCENE_MAP_S434.md`, CL = `CORE_LOOP_MAP_S432.md`.
Tags: REAL (a measured or rule-book number, REAL.md section given), CODE (in the game today, file:line), GAME VALUE (our choice, a
probe bounds it), ESTIMATE (an effect real data cannot size; a probe keeps it small), TO SOURCE (a real number John must check
before the build; the value given is a placeholder inside the range we know).

THE DRAWINGS (1920x1080, rendered with tools/render_mockup.py):
- `docs/mockups/s434/weight/r2_weight_panel.png` (`.html`): the training scene's WEIGHT PLAN, enlarged: the line to the scale with
  the coach's Monday check, this week by cause, the plan table (whole plans, one currency: win chance), the ENERGY sum, the trim with
  every step marked, the other corner behind scouting, the house rules, the miss risk and what a miss would cost.
- `docs/mockups/s434/weight/r2_class_choice.png` (`.html`): the fighter page's CLASS card: the walking weight and when STAY stops being
  cheap, DOWN / STAY / UP with labelled rows (the cut, the camp, ENERGY, win chance against the likely next three, size against the top
  five, the ladder, the business, the roster, as a pro), Samira's own ask, Test the weight, and "after the next bout".

## 0. The mechanic in one paragraph

Every fighter has a WALKING WEIGHT and a CLASS. The gap between them is the work of every camp, and it is decided three times: at
the CLASS card (which limit, for the career), at the BOUT OFFER (the contract weight: the limit, a catchweight, a matched weight), and
in CAMP (the plan: a diet for weeks plus a fight-week trim; for professionals the last day's water and the refuel). Every plan is
shown as a whole row with one currency the player can weigh: its WIN CHANCE against this opponent, which already contains the ENERGY
at the first bell, the camp goal and the size on the night. The fighter's DISCIPLINE decides the weekends; the player sets standing
HOUSE RULES (meal prep, a Monday weigh-in) and can hire a NUTRITIONIST. The coach checks the weight each Monday, so a camp going
wrong is caught with weeks to spare. Amateurs weigh in on the day, professionals the day before. A miss is graded; repeated misses
change a career. The opponent lives by the same rules, but the player only sees the other corner's weight after scouting it.

## 1. The vocabulary (one set of words on every screen)

| Word | Means | Never say |
|---|---|---|
| WALKING WEIGHT | the weight the body drifts back to between bouts | natural weight, walk-around |
| CLASS · LIMIT | the class name and its kg on the scale ("Welterweight · 65.0 kg") | division (in game text) |
| CONTRACT WEIGHT | the weight agreed at the offer: AT THE LIMIT, CATCHWEIGHT 66.0, MATCHED 64.0 ± 0.5 | |
| THE SCALE | the official weigh-in, with its day and hour ("Scale Sat 28, 4 pm") | weigh-in check, WI |
| COACH'S CHECK | the Monday target on the line ("Check Mon 23: 65.7 or under") | |
| THE PLAN | a diet plus a trim, one row ("Lean + trim 0.6") | |
| DIET: HOLD / LEAN / CUT | the three ways to eat; each shows kg a week | calories (kcal only in the hover) |
| FIGHT-WEEK TRIM | low-fibre, low-carb eating in the last 3 days: gut and glycogen, up to 2% | water cut |
| THE LAST DAY'S WATER | professionals only, the last 24 h before a day-before scale | dehydration (hover's REAL line only) |
| REFUEL | professionals only: what comes back between the scale and the bell | rehydration |
| ON THE NIGHT | the weight in the ring at the first bell | rehydrated weight |
| SLIP | a weekend the diet broke ("+0.5 kg, ate out Saturday") | cheat day |
| HOUSE RULES | standing weekend rules per fighter: Free / Meal prep / + Monday weigh-in | |
| MISS RISK | the chance this plan misses, "2 in 100" | |
| CRASH CUT | too much off too late (part 5) | |
| ENERGY | the fight-night fuel, 0-100 at the first bell | Tank, Fresh |
| FATIGUE | day-to-day tiredness | tiredness on training screens |
| STAMINA | the fitness stat (code `conditioning`) | Cardio, Engine |
| POWER · DURABILITY | the two stats the size edge touches (Data.gd:7-8 says "Durability") | chin (in game text) |
| WIN | win chance in plain fractions or "54 in 100" | odds, % |
Names, never he/she, also in the drawings: "If Samira slips", "Kayleigh starts 5 ENERGY under Samira".

## 2. Amateur, professional and no-gi, side by side

| | AMATEUR (club shows, the regional, the nationals) | PROFESSIONAL | NO-GI (Ana, NoGi.gd:74) |
|---|---|---|---|
| The scale | THE DAY ITSELF. Club show: 1 h before the first bell (4 pm for 5 pm). Championships: 9 am, 3 h+ before. REAL (EB 7.1.3; World Boxing 5.6) | THE DAY BEFORE, about 30 h out (Fri 2 pm for Sat). REAL (BBBofC 3.2.2: 24-36 h; IBF 1.A: 20-30 h) | at the mat, right before the first match, in kit. TO SOURCE (IBJJF / ADCC rule books, John) |
| Contract weight | the matchmaker pairs at the limit; a CATCHWEIGHT +1 kg costs a favour (part 4) | AT THE LIMIT / CATCHWEIGHT +1 or +2 kg / MATCHED with 0.5 kg allowance; a SECOND-DAY LIMIT clause (part 4) | the bracket's class only |
| Walking weight | 3-7% over the class (GAME VALUE; REAL 1a: amateurs cut ~6%, 9.5% at most) | 8-15% over (GAME VALUE; REAL 1a: 11-18%, ISSN ceiling 12-15%) | 2-5% over (GAME VALUE) |
| Coach's checks | every Monday of a camp | every Monday; title bouts add 30 days ≤ limit +10%, 7 days ≤ +5% (REAL 4d: WBC); BBBofC title +3% three days out (REAL 4e) | every Monday |
| Trim | up to 2% in 3 days (REAL 7: low-residue 1.5% in 48 h, low-carb ~2%) | the same | the same |
| Water | none (the panel says "no water: amateur" in the scale chip; no greyed row) | up to 3% in the last 24 h (REAL 4c: 2-3% "few disadvantages", ACSM) | none |
| Back by the bell | what was trimmed, at most 1.5% (women) / 2.1% (men) of the scale weight, + 0.3 kg for the meal (REAL 2a: Reale 2017) | REFUEL STANDARD: everything trimmed and dried + 1% for meals; AGGRESSIVE: +1% more (part 4); never over the walk (REAL 2a: +7.2% average) | nothing (minutes, not hours) |
| Trim price (ENERGY at the bell) | -1 a 0.1 kg up to 0.5 kg, -2 a 0.1 kg past it: 0.3 = -3, 0.6 = -7, 0.9 = -13, 1.0 = -15, 1.2 = -19 (TR T8, kept) | -1 a 0.25 kg (glycogen refills overnight; GAME VALUE) | the amateur rate |
| Water price | - | -1 a 0.2 kg up to 2%, -1 a 0.1 kg from 2 to 3%, past 3% = CRASH CUT | - |
| A little over | up to 1.0 kg: ASK A KILO, 1 favour, the bout goes on (CW 3.5); no favour = walkover loss | up to 0.45 kg: nothing. Over: ONE HOUR to sweat it (BBBofC 3.2.4), then the bout goes on and 25% of the purse goes to the opponent (Nevada NAC 467.522) | out of the bracket, entry lost (TO SOURCE) |
| Well over | over 1.0 kg: walkover loss (EB 10.7.2), no fine (REAL 5b) | over 2% of the limit: the other camp calls it off, no purse, the club pays $300 (CODE BoutRules.gd:88, kept for this case) | out of the bracket |
| A title | the nationals: out of the draw (CODE Bouts.gd:332-338) | champion loses the belt on the scale, the bout may go on; a challenger who misses cannot win it (IBF 1.A.1-2) | - |
| Size on the night | both corners land within about 1 kg: ONE LINE ("Level on the night") unless the gap is 1 kg+ | real: up to 3-4 kg, full bars | none |

## 3. The seven parts

Each part: what the player decides, what each option costs and gives, the links (training, fight, money, mood and loyalty,
career). Section 4 has every decision as a table.

### Part 1. WALKING WEIGHT AND THE CLASS CHOICE
THE RULE (kept from round 1, praised).
- Every fighter carries `walk` (kg). Start: CODE start weights (Data.gd:54, :198-240) become walks plus 2-4% (GAME VALUE; Samira
  65.9 now, walks 66.8). World opponents get one from their class and seed (part 6).
- AFTER A BOUT half the gap to `walk` comes back in week 1, the rest over 3 weeks (REAL 1b: 3.5-4.8% in a week). HOLD sits at `walk`.
- THE WALK MOVES SLOWLY: LEAN between camps takes 0.25 kg a month off (at most 4% under the start walk); under 21 adds 0.8 kg a year;
  a camp cut over 8% adds 0.2 kg after the bout (GAME VALUE; REAL 1b, Morehen's fat mass creep).
- The hidden clamp (Sim.gd:214-216, :149-151, CampForecast.gd:67-69) goes; `walk` replaces it.
THE DECISION (fighter page, CLASS card; drawn): DOWN / STAY / UP, now with timing and a trial.
- MOVE NOW (no bout booked) or MOVE AFTER THE NEXT BOUT (scheduled; the next offer still comes at the current limit). At most once
  in 12 weeks unless forced (part 5).
- TEST THE WEIGHT: one bout at a catchweight between the classes (Samira: 63.0 kg, the midpoint rounded to 0.5) before committing.
  No lock, no ladder move; the bout counts on the record and gives half ladder credit (part 4's catchweight rule). It shows the real
  cut: the slips that happened, ENERGY at the bell, the trim it took. The CLASS card then shows "Tested at 63.0: ENERGY 80, 1 slip".
- Each option shows, as labelled rows (drawn): THE CUT (% and kg from the walk; red past 10% for amateurs, REAL 1a), THE CAMP (weeks
  of diet to get down, then per bout), ENERGY at the bell, WIN against the likely next three opponents at that class (the existing
  win band, Matchmaking.win_chance :86, with the class's ENERGY and size), SIZE against the walks of that class's top five, THE LADDER
  (place the record earns, CODE ladder), THE BUSINESS (offers at that class in the last 8 weeks; weeks without a bout while getting
  down; ticket cuts lost at $450 each, CODE BoutRules.gd:89), THE ROSTER (a team-mate in that class shares club-show slots and the
  ladder: "Lucy Jackson boxes at 60.0: one of them sits out some shows"), AS A PRO (the pro limit and the size there).
- WHEN STAY STOPS BEING CHEAP: the date the growing walk puts the cut past 4% (Samira: about Apr 2027, walk 67.7). Drawn on the walk line.
THE FIGHTER'S VOICE (new, uses the existing ask rule, PushBack.gd:1-9, WeekTwist.gd:73-77 ASKS): two new ask cards.
- "Move me up" when CUT ran 3+ weeks in two camps running, or two slips forced a trim over 1.0 kg. "Move me down" when the lower ladder
  has a top-3 place the record would earn and the walk is under 8% over its limit. "Keep me here" when the player opens a move to a
  cut over 8%.
- Her way = `heard` (+5 morale), refused = `refused` (-4) (CODE FighterProfile.gd:28-29). A forced move to a cut over 8% also costs
  loyalty 3 ("You'd starve me", kept). The ask shows on the CLASS card with HEAR / OVERRULE.
LINKS. Training: the cut decides the diet weeks (part 2). Fight: size and ENERGY. Money: ticket cuts lost while getting down; thin
classes give fewer offers but a faster pro offer (7 wins + top 3, K-PROLINE1). Mood and loyalty: the asks. Career: the class is the
ladder, the rank, the pro offer and the pro limit; the roster rule (S428: four fighters in four classes) makes a move a squad decision.
NEW CLASSES NEEDED (the owner's scope call): women 70 kg and men 65 kg (World Boxing classes; names from Kalli). Without them a women's
welterweight's UP is 75 kg.

### Part 2. THE CUT HAS A PRICE AND A PRIZE, IN ONE CURRENCY
THE PRICE (camp).
| Diet | kg a week (60-65 kg) | Training gains | FATIGUE a day | Mood |
|---|---|---|---|---|
| HOLD | +0.02 (CODE WeekPlan.gd:73, life + 300 kcal) | x1.0 | +0 | - |
| LEAN | -0.20 (-250 kcal; TR T8) | x0.97 (GAME VALUE; REAL 2c) | +0.5 | - |
| CUT | -0.43 (CODE WeekPlan.gd:74; Old hand -0.52) | x0.9 (TR T8 ESTIMATE) | +1.5 (GAME VALUE) | -3 a week past 2 weeks (REAL 3: Hall and Lane 2001) |
- The diet is the player's choice in camp. Today a camp cuts by itself while over (CODE Sim.gd:117-118); that rule goes.
- TAPER_KG (CODE WeekPlan.gd:70-72, 0.05 kg a day, REAL 7: 3-6x too small) is replaced by the FIGHT-WEEK TRIM.
THE PRICE (fight night): ENERGY AT THE FIRST BELL = 100 - Fatigue carried (CODE BoutRules.stale_energy :165-168: 2 a point over 50,
at most 20; the diet's extra Fatigue flows through it and is shown as its own share) - the trim - the water - a refuel shortfall.
Drawn as one bar with its parts: "100 · Fatigue carried -4 · Lean's share -3 · trim 0.6 kg -7 = 86". Every ENERGY number on every
screen is this sum (round 1's 79 / 86 / 85 could not be rebuilt; now each is: HOLD 100-4-0-15 = 81, LEAN 100-4-3-7 = 86, CUT
100-4-8-3 = 85).
THE PRIZE: SIZE ON THE NIGHT. Night weight = the scale + what comes back, never above `walk`. The heavier corner gets +0.6 Power and
+0.6 Durability per kg of gap from 1 kg, at most 4 kg (+2.4). ESTIMATE kept small (REAL 2b: no measured effect on who wins in boxing;
PEAK CAMP is +1 to every stat, PeakCamp.gd:11). Amateurs: one line unless 1 kg+.
THE CURRENCY: WIN CHANCE. Every plan row, class option and contract option shows WIN against this opponent: the existing win band
(Matchmaking.win_chance :86) run with that option's ENERGY, size edge and camp-goal result. What ENERGY is worth depends on the FIGHT
PLAN (PlanFight / PlanPressure): a pressure plan or a late Push counts ENERGY x1.4; a power plan counts the size edge x1.4; others x1
(GAME VALUE, probe P10). Shown under the ENERGY bar: "1 ENERGY = about 0.4 in 100 with Push R3". The kg, ENERGY and camp goal stay in
their columns so the player sees WHY a row wins.
LINKS. Training: the diet's gains and Fatigue land on the mornings the scene prices (TS 6). Fight: ENERGY, size, the plan's weights.
Mood: CUT past 2 weeks. Career: none directly.

### Part 3. THE FIGHTER'S CHARACTER, AND WHAT THE CLUB CAN DO ABOUT IT
THE RULE (a game rule: Q20 found no published link; REAL 3 gives the weekend proxy).
- On LEAN or CUT each weekend can SLIP. Chance = 0.8 - discipline/100, 5 to 60 in 100 (GAME VALUE). Samira, discipline 34: 46 in 100,
  shown "1 in 2". A slip is +0.3 to +0.6 kg (GAME VALUE, about 5x Racette 2008's +0.06 kg a weekend day). News: "Samira: +0.5 kg, ate
  out Saturday". Fight week halves it (the coach weighs every morning; BBBofC 16.7's diary).
- A HARD CUT (CUT 3+ weeks, or a trim over 1.5%) costs mood 3 (new `hard_cut` -3; `made_it` +2 after one). REAL 3: Hall and Lane 2001.
- DISCIPLINE GROWS (new): three camps in a row made clean (no slip forced an extra trim, no crash cut) = discipline +2; a crash cut -2;
  a miss -1; at most +6 a year (GAME VALUE). Shown: "Clean camps in a row: 1 of 3". The habit system (MOODHABIT1) reads it.
THE DECISION: HOUSE RULES, set once per fighter, they run every diet week (J13: a weekly plan plus a standing discipline; a weekly pick
is a chore with four fighters). Odds in plain fractions.
| House rule | Price | Samira's slip chance |
|---|---|---|
| FREE | nothing | 1 in 2 |
| MEAL PREP DELIVERED | $70 a week, only in diet weeks (TO SOURCE: UK meal-prep plans about GBP 55-80 for 10 meals) | halved: 1 in 4 |
| + MONDAY WEIGH-IN at the gym | mood -1 each diet Monday | halved again: 1 in 9 |
Round 1's CLUB DINNER is gone (critics: a club meal keeps nobody on a diet).
THE NUTRITIONIST (new staff job, StaffRoles.LIST, CODE StaffRoles.gd:7-15 shape): $100 a week (TO SOURCE: a UK sports nutritionist
session GBP 50-100). For every fighter: the trim's ENERGY price x0.8, the forecast line exact to 0.1 kg (the band keeps only slips),
slips x0.75, a pro refuel +0.5% more. With the Old hand's x0.75 (HeadCoach.gd:23-24) the trim price never falls under x0.65 (the
StaffRoles RISK_FLOOR idea, :21). Money for weight, every fighter at once.
THE CYCLE WEEK (women, forecast only): the line's band widens by 0.5-1.0 kg on the days the fighter's cycle puts water on (a 28-day
seed; ESTIMATE, TO SOURCE). It changes no stat; the coach then advises the diet a few days earlier. Shown only in the band's hover.
LINKS. Mood: the weigh-in, hard cuts. Money: meal prep, the nutritionist. Career: discipline grows with clean camps; a low-discipline
fighter is a heavier long-term cut, and the CLASS card shows it.

### Part 4. THE SCALE: WHEN, AND AT WHAT WEIGHT
WHEN (kept): section 2. One function names the scale's day and hour for every bout kind: club show (the day, 1 h before the first
bell), the regional and the nationals (the day, 9 am), professional (the day before, 2 pm), a pro title (the day before, plus a
fight-morning check if the contract has the second-day limit).
AT WHAT WEIGHT: THE CONTRACT WEIGHT on the bout offer (new; weight is decided when the deal is made, not only in camp).
| Option | Amateur | Professional | What it changes |
|---|---|---|---|
| AT THE LIMIT | the default | the default | full ladder credit |
| CATCHWEIGHT +1 kg | costs 1 favour (CW 3.5) | 10% of the asker's purse to the other camp (GAME VALUE inside J7's 20-25% band for a miss) | a smaller cut (ENERGY back), the other corner's size too; half ladder credit (GAME VALUE) |
| CATCHWEIGHT +2 kg | - | 15% of the purse | the same, more; no title credit |
| MATCHED WEIGHT ± 0.5 kg | the matchmaker's way at a club show: both at one agreed weight under the limit | both camps agree it | used to test a lower class (part 1) |
| SECOND-DAY LIMIT (a clause) | - | either camp may ask it: fight morning, limit +10% (REAL 4b: IBF) | caps the other corner's refuel: the counter to a big water cut |
The other camp ACCEPTS or REFUSES with a reason built from its own walk: "Kayleigh's coach: no, Kayleigh walks 67.6, we'd give away
size" (OppWeight's walk vs the ask). A refusal leaves the offer at the limit.
SHORT-NOTICE OFFERS (new): when a world bout loses a fighter (Matchmaking.offers :150), an offer can come 10-14 days out at a
catchweight +2 kg or at the fighter's walk, with the purse +30% (pro) or a favour owed (amateur) (GAME VALUE). No cut is possible, so
the decision is size and ENERGY now against a planned camp later.
REFUEL (professionals, the WEIGHT PLAN's pro row): STANDARD (back = dried + trimmed + 1%) or AGGRESSIVE (+1% more, but ENERGY -2 if the
scale-to-bell time is under 24 h, GAME VALUE). The second-day limit blocks AGGRESSIVE.
THE WATER (professionals): 0 / 1 / 2 / 3% in the last 24 h.
SETTLED CONTRADICTIONS (kept): a club show weighs in 1 h before its first bell; championships 9 am; TR T8's regional and nationals move
to the day; CW 3.7's club scale moves to the class limit (the 1.0 kg lives on as ASK A KILO); TS's 66.0 becomes 65.0.
LINKS. Money: the purse share, favours. Fight: ENERGY, size, the second-day cap. Career: catchweights give half ladder credit.

### Part 5. GRADED CONSEQUENCES, PRICED BEFORE THE SCALE
THE LADDER: section 2's rows. MISS RISK (new): one badge in the WEIGHT PLAN header, from the slip chance, the slip size and the spare
kg against the 2% trim cap: "MISS 2 IN 100 with this plan". Beside it, IF SAMIRA MISSES, this bout's real prices: up to 1.0 kg over:
ask a kilo (favours held: 1 of 2) or the walkover; over 1.0 kg: a walkover loss, -$450 ticket cut, mood -6, ladder 5th to 7th; the
record: a miss stays 12 months, 2 = fewer offers.
THE DECISIONS ON THE SCALE (the weigh-in modal):
- PRO, 0.45-1.0 kg over: SWEAT IT OFF in the hour (ENERGY -1 a 0.1 kg) or STEP OFF AND PAY (25% of the purse).
- AMATEUR, up to 1.0 kg over: ASK A KILO (1 favour) or TAKE THE WALKOVER.
- THE OTHER CORNER MISSES: decided IN ADVANCE now (a standing order on the WEIGHT PLAN's other-corner box, the coach's default "box them
  unless the ladder is at stake"): BOX THEM (pro: +25% of their purse; amateur: they owe a favour) or REFUSE (amateur: walkover win;
  pro: no bout, the $300 slot paid to the club). The modal only confirms it.
REPEAT MISSES (REAL 5c: no study; a game rule built on the rule books): 2 in 12 months = half the offers at that class for 6 months,
reputation -4; 3 = forced up a class (California's rule).
THE CRASH CUT: an amateur who takes off more than 5% in the last 7 days (REAL 5d: Green 2007, judo) or a pro with water over 3%. Never
hidden: the trim and water steps past it are red. Effect: injury chance x1.5 in that bout, STAMINA -3 for the bout and -1 for two weeks,
mood -6, discipline -2, news (GAME VALUE; REAL 5d: 9.3% in 24 h caused kidney injury). No brain-injury claim (REAL 5d: no proof).
COACH'S CHECK WEIGHTS (new, the gate before fight week): every camp Monday the line carries a target (the plan's own line + 0.1 kg).
- On track: nothing happens; the week review ticks it.
- Over: a card on Monday with two choices: SWITCH THE DIET NOW (e.g. Lean to Cut; the plan table re-prices) or ASK TO MOVE THE DATE
  (amateur: a favour, the show may say no; pro: one week later, promoter trust -1).
- Pro title checks (30 days ≤ limit +10%, 7 days ≤ +5%; REAL 4d WBC): a failed check warns the promoter (trust -1); two failed = the
  bout may be given to the next contender.
- The CONTINUE button names it: "to Mon 23 Feb, weight check".
LINKS. Money: purse shares, the $300, the $450 ticket cut. Mood -6 for a walkover loss. Reputation. Career: the miss record, offers,
the forced move. Fight: the crash cut's STAMINA.

### Part 6. THE OPPONENT CUTS TOO, AND YOU SCOUT IT
THE RULE (kept): every opponent gets `walk` (amateurs 2-7% over, pros 6-15%; GAME VALUE inside REAL) and plays the coach's cheapest
plan. One module (OppWeight) replaces the two invented formulas (CODE TapeRows.gd:71-80, TaleOfTape.gd:24-29).
FOG (new; the free exact numbers are gone):
| What the player knows | Unscouted | Amateur: tape study (OppFile stages, OppFile.gd:2) | Pro: the $250 scout (Matchmaking.gd:39) |
|---|---|---|---|
| Walk | a 2 kg range ("67-69") | ± 0.4 kg after the first tape | ± 0.2 kg |
| The cut and trim | unknown | the trim (± 0.3 kg) after the first tape | exact |
| Faded late before? | locked | the second tape opens it from their record | opens it |
THEY MAY FADE LATE: no separate rule. Their ENERGY starts lower by their own trim and water; the fight's ENERGY already runs out late
(EnergyForecast.gd). Kayleigh, scouted: 100 - 4 carried - 2 Lean - 13 trim 0.9 = 81, five under Samira's 86 (round 1 printed -9 for
this trim; the rule says -13).
THE PRIZE AN AMATEUR CAN WIN (the size edge is dead at a same-day scale): "Kayleigh starts 5 ENERGY under Samira: the gap grows each
round" with WRITE IT: one click adds a plan line (PlanLines / PlanTemplates: "Steady R1-2, Push R3" or "When Kayleigh tires: let your
hands go") and shows its win gain ("+2 in 100").
THEY MAY MISS: under 6% cut 1 in 100; 6-10% 1 in 30; over 10% 1 in 10 (GAME VALUE; REAL 5c ~6% of UFC bouts; REAL 6: missers won 31%).
LINKS. Fight: their ENERGY, size, the plan line. Money: their purse share, the $250 scout. The film: a heavy cutter is a tell.

### Part 7. A PLAN YOU CAN CALCULATE
THE PANEL (training scene, drawn): the LINE TO THE SCALE, day by day in kg for the chosen plan, other plans dashed, the slip band, the
coach's Monday check as a marker, the trim's three days, the limit in red. Under it THIS WEEK BY CAUSE: "Lean -0.22 · 3 Hard roadworks
-0.13 · 2 rest days +0.08 = -0.27 kg" and ONE SWAP the coach suggests with its kg ("Swap Sun rest for Light roadwork: -0.06 kg").
Round 1's kg-a-day table (three decimals) is gone; the per-session kg sits in each session's hover (WeekPlan.gd:244-245, :262-263).
THE PLAN TABLE (whole plans, one row each; the coach marks the cheapest that makes weight):
| Plan (Samira, 65.9 now, limit 65.0, 12 days, house rule Meal prep) | The scale | Camp goal (Stamina +2.5) | ENERGY | WIN | If Samira slips Sat 21 |
|---|---|---|---|---|---|
| HOLD + trim 1.0 | 65.9 -> trim 1.0 -> 64.9 MADE | met | 81 (-4 · 0 · -15) | 52 | no diet to break |
| LEAN + trim 0.6 (COACH) | 65.5 -> 0.6 -> 64.9 MADE | met | 86 (-4 · -3 · -7) | 54 | trim 1.1, ENERGY 76, 50 |
| CUT + trim 0.3 | 65.2 -> 0.3 -> 64.9 MADE | close (+2.2) | 85 (-4 · -8 · -3) | 52 | trim 0.8, ENERGY 77, 49 |
| LEAN + trim 0.3 + ASK A KILO (GAMBLE, amateur) | 65.5 -> 0.3 -> 65.2, 0.2 OVER | met | 90 (-4 · -3 · -3) | 56 | 0.7 over, still a favour, 55; no favour = walkover |
MISS per row: 1 / 2 / 1 in 100; the gamble needs 1 of 2 favours. Win = 54 + 0.4 x (ENERGY - 86) with Push R3, - 1.5 for a goal left
close (P10 checks the band). The TRIM is set by the coach (the row's trim); the stepper opens from a row and marks every step: 0 =
0.5 over (ask a kilo), 0.3 = 0.2 over (a favour), 0.6 made -7, 0.9 made -13, 1.2 made -19, 1.3 = the 2% cap.
The diet cards lose their kcal (it sits in the hover: "Lean: 250 kcal a day under Hold = 0.032 kg a day; 7,700 kcal = 1 kg").
LINKS. Every number comes from one run (the week sim plus WeightRules), the same run the training scene's three sums use (TS 6).

## 4. Every decision as a table (when, the options with prices, which case each wins: never printed on screen)

| # | When | Decision | Options and their prices | Which case each option wins |
|---|---|---|---|---|
| D1 | Fighter page, CLASS card | THE CLASS | DOWN / STAY / UP, NOW or AFTER THE NEXT BOUT; DOWN: weeks of diet to get down (ticket cuts lost), a bigger cut each camp, the roster clash, loyalty -3 past 8%; UP: size against (to -2.4), a thinner ladder with fewer offers | DOWN: a pro with discipline 60+ and a walk under 10% over the lower limit, or a thin lower ladder near the pro offer. STAY: the cut is under 6% and the rank climbs. UP: the walk keeps rising or the cut costs the goal every camp |
| D1b | CLASS card | TEST THE WEIGHT | one catchweight bout between the classes: half ladder credit, no lock | when DOWN looks right on paper but the fighter's discipline is under 50 (slips decide it) |
| D1c | An ask card | HEAR or OVERRULE the fighter's class ask | hear +5 morale; overrule -4 (and loyalty -3 if it forces a cut past 8%) | hear unless the move costs the pro offer or clashes with a team-mate |
| D2 | The bout offer | CONTRACT WEIGHT | limit / catchweight +1 (favour or 10%) / +2 (15%) / matched / second-day limit | catchweight: a fighter whose cut is past 6% against a natural for the class; limit: when the ladder credit is the point; second-day limit: against a big pro refueller with a power plan |
| D3 | The bout offer | SHORT NOTICE at +2 kg or the walk | +30% purse or a favour owed; no cut, no camp | take it when the size gap is under 1.5 kg or the fight plan is pace; pass with a power opponent |
| D4 | WEIGHT PLAN, any camp week (the coach picks by default) | THE PLAN (diet + trim) | section 3 part 7's rows | HOLD + big trim: under 0.5 kg to lose, or a goal that needs every morning. LEAN + mid trim: most camps. CUT + small trim: over 1.2 kg to lose, or a same-day scale where trim is dear. GAMBLE: favours held, a 0.1-0.3 kg gap, a pressure plan |
| D5 | WEIGHT PLAN, pro, last 3 days | THE WATER and THE REFUEL | water 0-3% (ENERGY), refuel standard / aggressive | water + aggressive refuel: no second-day clause, a power plan, the opponent a natural; none: a pace plan |
| D6 | WEIGHT PLAN, once per fighter | HOUSE RULES | Free / Meal prep $70 a week / + Monday weigh-in (mood -1) | Free: discipline 70+. Meal prep: discipline under 50 and cash spare. Weigh-in: a 0.3 kg margin and mood Good+ |
| D7 | Club > People | THE NUTRITIONIST | $100 a week, all fighters | two or more fighters cutting at once, or a pro with a water cut |
| D8 | Monday of a camp, over the check | SWITCH THE DIET or MOVE THE DATE | switch: the plan re-prices (gains, Fatigue); move: a favour / promoter trust -1 | switch: 2+ weeks left; move: under 2 weeks and a crash line ahead |
| D9 | WEIGHT PLAN, other corner box | IF THE OTHER CORNER MISSES (standing order) | box (+25% of their purse / a favour owed) / refuse (walkover win / no bout, $300 slot) | box: their miss came from a crash cut; refuse: the rank is near the pro offer, or they are 2+ kg heavier on the night |
| D10 | WEIGHT PLAN | WRITE IT (the fade line) | adds a plan line, no price | when the other corner starts 4+ ENERGY under |
| D11 | The scale, pro, 0.45-1.0 kg over | SWEAT or PAY | sweat: ENERGY -1 a 0.1 kg; pay: 25% of the purse | sweat while ENERGY stays over 70 |
| D12 | The scale, amateur, up to 1.0 kg over | ASK A KILO or WALKOVER | 1 favour / a loss, mood -6, -$450 | ask while a favour is held and the rank is at stake |
| - | Forced after a 3rd miss in 12 months | UP A CLASS | no choice; the card says why | - |

## 5. Every menu it appears on, and what each is wired to (the S425 rule)

New code: `scripts/rules/WeightRules.gd` (pure: diets, walk drift, trim, water, refuel, the ENERGY sum, night weight, size edge, slip
chance, miss risk, crash line, the plan table rows, class options), `scripts/rules/OppWeight.gd` (pure: an opponent's walk, plan,
fog by scouting stage, night weight, the accept/refuse reason), `scripts/state/WeighDay.gd` (the scale's day and hour, the graded
result, the standing order, the miss record, the forced move), `scripts/rules/ContractWeight.gd` (pure: contract options and prices,
short-notice offers), `scripts/state/Classes.gd` (moves, scheduled moves, the test bout, asks). Sim.gd is at 499 lines: its weight
lines (week_ctx :117-121, the clamps :149-151, :214-216) move out, net lines <= 0.

| # | Menu | What it shows | Wired to today (file:line) | New wiring |
|---|---|---|---|---|
| M1 | Training scene: WEIGHT sum card (TS :49-50) | SCALE SAT 28 · 4 PM, now -> scale, MADE / OVER, MISS RISK, the coach's plan | WeekCamp.gd:76-94, :236-262; GaugeRow.gd:141-148, :246-248 | WeightRules.plan_rows(f, bout); click opens M2 |
| M2 | Training scene: WEIGHT PLAN (drawn) | the line + Monday check, week by cause + one swap, the plan table, ENERGY sum, trim steps, other corner (fog, standing order, Write it), house rules, nutritionist, miss box | none (TS mark 6) | WeightRules.path / plan_rows / energy_sum / miss_risk; WeekPlan day kcal (:244-245, :262-263); OppWeight.known(opp, scout_stage); PlanLines add on Write it; f.house_rules |
| M3 | Fighter page: CLASS card (drawn) | walk + when STAY stops being cheap, DOWN/STAY/UP rows, the ask, Test, Move now / after | FighterPage.gd:127-129; DarkOverview.gd:379-387 | WeightRules.class_options(f, ladder, roster); Classes.move / schedule / test; WeekTwist ASKS + PushBack.pick |
| M4 | Bout offer (BoutPage, VersusPanel) | the scale's day and hour, CONTRACT WEIGHT options with ENERGY / size / ladder credit / price, the other camp's answer, short-notice tag, the plan's WIN | BoutPage.gd:44-56, :95, :145-147; VersusPanel.gd:159, :185-196; Bouts.makeable_day :150-162 | ContractWeight.options(f, opp); makeable_day reads WeightRules.best_plan; VersusPanel's WEIGHT row reads OppWeight.known |
| M5 | Monday card (week start) | the coach's check: on track / over with SWITCH or MOVE THE DATE; CONTINUE label "weight check" | WeekReview.gd:413-414; Main.gd (CONTINUE) | WeighDay.check(f, monday) |
| M6 | Fight prep (last 3 days) | the trim (coach set, override), pro water + refuel, "Scale: 0.1 kg to spare", the hour | FightPrep.gd:30, :65-66, :92-99, :139-158 | WeightRules.plan; steppers write f.bout.trim / water / refuel |
| M7 | THE SCALE (weigh-in modal + toast) | the hour, the reading, MADE / the grade, its choices (D11, D12), the standing order (D9) confirmed | WeighIn.gd:2, :13-28; BoutActs.gd:219-227; Bouts.weigh :327-347; :89-91 | WeighDay.weigh_hour, WeighDay.weigh -> {grade, choices} |
| M8 | Tale of the tape (2D) and the 3D intro | ON THE SCALES, ON THE NIGHT (one line if under 1 kg for amateurs), the edge | TapeVersus.gd:21-26; TapeRows.gd:64-80; TaleOfTape.gd:16, :24-29 | OppWeight + WeightRules.night; the two old formulas removed |
| M9 | Fight night | ENERGY at the first bell with its parts, size edge, crash STAMINA | BoutRules.stale_energy :165-168; BoutNight.gd:104-110 | WeightRules.energy_sum and size_edge beside PEAK CAMP |
| M10 | The Why card after the bout | "Weight: ENERGY 79 at the bell (trim 1.0 kg -15) cost about 3 in 100 in round 3" / the size line | WhyCard.gd (29 lines) | WeightRules.why_line(bout) |
| M11 | Week review (Monday) | plan vs actual with the cause ("+0.5 kg, ate out Saturday"), the check result, clean camps 1 of 3 | WeekReview.gd:413-414; WeekActual.gd:42-45, :82-91; WeekCoach.gd:38-44 | WeekActual reads f.slips; WeekCoach names the plan |
| M12 | Home: roster row, needs, strip, fixtures | "0.9 to lose", "Scale today 4 pm", miss risk if 10+ in 100, walk drift | HomeRows.gd:15, :195-201; Needs.gd:75-76; Home.gd:62-63; Fixtures.gd:19 | WeighDay.weigh_hour; HomeRows reads walk, miss_risk |
| M13 | News | missed / sweat / walkover / crash cut / slip / class move / ask / the other corner missed / short notice | HomeSide.gd:11; c.add_news in Bouts.gd:339 | WeighDay, Classes, WeightRules events write lines |
| M14 | Club > People (staff) | NUTRITIONIST row with its effect and wage | StaffRoles.gd:7-15; StaffCard.gd:30-31 (role words, icons) | StaffRoles.LIST + "nutritionist"; WeightRules reads c.staff_roles |
| M15 | Fight plan page | the line added by Write it, tagged "from the weight plan" | PlanLines / PlanTemplates | PlanLines.add(line, source) |
| M16 | Fighters: roster table, cards, tile | class, walk, a miss dot, a scheduled move | RosterTable.gd:55-56; RosterCards.gd:175, :213-220; FighterTile.gd:57-60, :99-100 | read walk, f.misses, f.class_move |
| M17 | Create screen / the walk-in | "Walks 66.8 kg · Welterweight 65.0" | CreateScreen.gd:247-248; ClubStart | ClubStart sets walk |
| M18 | No-gi match day (Ana) | "Scale at the mat, before the first match", made / out of the bracket | NoGi.gd:74 (class word only) | WeighDay.weigh_hour for sport "bjj" |

## 6. The build (one owner each, every file under 500 lines, a golden-path step each; nothing starts before two critics score 7+)

| # | Task | Owner | Owns (lines) | Golden-path step |
|---|---|---|---|---|
| B1 | WEIGHTRULES1: pure module + tests (diets, drift, trim, water, refuel, ENERGY sum, night, size, slips, miss risk, crash, plan rows, win via win_chance) | Qwen (Goose route) | scripts/rules/WeightRules.gd (~320), tests/weight_rules_test.gd | - (unit) |
| B2 | OPPWEIGHT1: opponent walk, plan, fog by stage, refuse reason; TapeRows/TaleOfTape call it | Qwen | scripts/rules/OppWeight.gd (~120), two call sites, tests/opp_weight_test.gd | the tape and the 3D intro show the same weight |
| B3 | WALKWEIGHT1: `walk` in state, start values, drift, clamps replaced, save migration | Claude | Data.gd, ClubStart.gd, Sim.gd (net <= 0), CampForecast.gd, SaveGame.gd | after the first bout the weight climbs back |
| B4 | DIETS1: diets real in camp, gains and Fatigue, coach picks the cheapest row, TAPER_KG -> trim | Qwen | WeekPlan.gd (363 + ~30), WeekCoach.gd | Lean picked changes the scale and the gains |
| B5 | WEIGHDAY1: scale hour per bout kind (and no-gi), grades, standing order, miss record, forced move, crash cut, Monday checks | Claude | scripts/state/WeighDay.gd (~260), Bouts.gd (weigh moves out), Sim.gd:136-137 | a club show weighs in at 4 pm on the day; a Monday over the check offers the switch |
| B6 | CONTRACT1: contract weight, the other camp's answer, short-notice offers, second-day clause | Arena | scripts/rules/ContractWeight.gd (~180), tests | a catchweight ask is refused with Kayleigh's reason |
| B7 | NIGHTSIZE1: ENERGY sum at the bell, size edge, plan weights (x1.4), Why line | Arena | BoutNight.gd hook, BoutRules.gd (300 + ~15), WhyCard.gd (29 + ~20) | the fight starts with the sum shown; the Why names it |
| B8 | SLIPS1: slips, house rules, discipline growth, mood events, nutritionist staff row | Qwen | WeightRules (slip roll), FighterProfile.gd (+3 events), StaffRoles.gd (65 + 3), Sim Monday hook (net <= 0) | a slip shows in the week review with its cause |
| B9 | CLASSES1: new classes (Kalli names), Classes.gd (move now/after, test bout, asks via WeekTwist), ladder placement, roster clash | Claude + Kalli | Data.gd DIVISIONS, scripts/state/Classes.gd (~200), WeekTwist.gd ASKS (+2 cards) | moving Samira up after the next bout re-deals Samira's offers at 70 kg |
| B10 | WEIGHTPANEL1: M1, M2 | Cursor | scripts/ui/WeightPlan.gd (~420) + WeightLine.gd (~200) | the panel's numbers equal WeightRules' run |
| B11 | CLASSCARD1: M3 | Cursor | scripts/ui/ClassCard.gd (~350) | DOWN / STAY / UP with labelled rows; STAY by default |
| B12 | WEIGHTSHOW1: M4-M9, M11-M18 | Cursor | the files in section 5, each edit small | every menu in section 5 shows its line in the .exe |
| B13 | WEIGHTGOLDEN1: offer (contract) -> plan -> slip -> Monday check -> trim -> scale at the hour -> standing order -> night weights -> ENERGY sum -> the Why line -> drift back | Grok Dev | tests/weight_golden_test.gd | the whole path |
| B14 | John: TO SOURCE items (no-gi scale rules, meal-prep and nutritionist prices, cycle-week water, EB matching allowances) | John (chat seat) | ops/research/WEIGHT_SOURCES_S434.md | - |

## 7. The probes (the gate before the pixels: each runs on the built rules)

| # | Probe | Bar | If it fails |
|---|---|---|---|
| P1 | Forecast honesty | discipline 80+: scale morning within 0.1 kg in 95 of 100 runs; any discipline: inside the band 95 of 100 (women: with the cycle band) | widen the band or fix the forecast before any UI |
| P2 | The prize is small and the price can cancel it (equal fighters, 3 kg gap) | heavier wins 53-58 with no price; with the trim and 3% water that bought it, 48-53 | scale the edge |
| P3 | No dominant plan row (300 seeded camps, both sexes, amateur and pro, 4 classes) | each of HOLD, LEAN, CUT rows is best (by WIN, then goal) in 15+ in 100; the GAMBLE in 5-25 in 100 when favours are held | re-price LEAN / CUT / the gamble |
| P4 | Real ranges in the world | amateur cuts 3-7% (median ~5%); pro walks 6-15% over; pro night gain 4-9%; amateur 1-2.5% | re-seed OppWeight |
| P5 | Misses | world pro bouts with a miss 3-7 in 100; the roster on the coach's plans under 1 in 50 | re-price |
| P6 | Slips and house rules | discipline 34: 40-55 in 100 diet weekends; 80: 8 or fewer; meal prep halves; meal prep pays back (avoided extra trim) in 1 of 2 camps for discipline under 50 | change the slope or the price |
| P7 | The opponent's fade | opponents trimming over 1.5% or drying over 2% lose round 3 more often by 3-8 in 100 | the ENERGY price is off |
| P8 | Walk drift | 45-60% of the cut back in week 1, at the walk by week 4 | change the drift |
| P9 | Class moves are a trade (50 careers) | down and up each win 45-55 in 100 of the next 10 bouts | change the edge or ladder placement |
| P10 | The plan decision matters | best and worst sensible plan rows differ by 3+ in 100 WIN in 60+ in 100 camps | raise the plan weights (x1.4) or the trim prices |
| P11 | Catchweight is a trade | with the coach's default, catchweight asks win the bout more often but cost ladder places; accepted in 30-70 in 100 asks | change the purse share or the refusal rule |
| P12 | Monday checks fire usefully | a check flags 70+ in 100 of the camps that would miss, with 2+ weeks left; false alarms under 1 in 5 | change the check's slack (0.1 kg) |
| P13 | The nutritionist | pays its $100 back (ENERGY -> win -> purse and ticket cuts) with 2+ fighters cutting; not with one amateur | change the wage or the effects |
| P14 | Discipline growth is slow | a disciplined club gains +4 to +6 a year; never past +6 | change the steps |

## 8. What changes against today (for the brief writers)

- The camp no longer cuts by itself (Sim.gd:117-118); the plan rows are real. TAPER_KG (WeekPlan.gd:70-72) becomes the trim.
- Amateurs and no-gi weigh in on the day; pros the day before (Bouts.gd:89-91, Sim.gd:136-137).
- A miss is graded (Bouts.gd:338-345, BoutRules.gd:88); `bout["made"]` (Bouts.gd:331, never read) becomes the grade.
- PEAK CAMP's weight line (PeakCamp.gd:35) reads "made at the scale" from the grade.
- The opponent gets one weight from OppWeight, behind the scouting stages (TapeRows.gd:71-80 and TaleOfTape.gd:24-29 go).
- The clamp band goes (Sim.gd:149-151, :214-216; CampForecast.gd:67-69); `walk` replaces it.
- The Old hand (HeadCoach.gd:23-24) keeps -120 kcal on a cut and adds the trim price x0.75 (floor x0.65 with the nutritionist).
- CW 3.7's club scale moves to the class limit; TS's 66.0 becomes 65.0; TR T8's regional and nationals move to the day.
- StaffRoles gains the nutritionist; WeekTwist gains two class asks; the bout offer gains contract weight.

## 9. Open for the owner (scope only)

- Add two classes so UP and DOWN are real steps: women 70 kg, men 65 kg (World Boxing classes; Kalli writes the names).

## 10. The critics, round 2

Not yet scored. Brief: CRITIC_PACK.md + CRITIC_ACCESS.md first, then this map and the two r2 drawings; depth (7+), what a screen is
missing or does not need, what each changes; each ends with the list to 10/10 and draws its 10/10.

## 11. Round 1's points and where they went

| Critic point | Done in round 2 |
|---|---|
| Contract weight on the offer (both) | Part 4 table, D2, M4, B6, P11 |
| Coach's check weights | Part 5, D8, M5, B5, P12; CONTINUE says "weight check" (drawn) |
| Meal prep instead of the club dinner (both) | Part 3 house rules, D6 (drawn); club dinner cut |
| Nutritionist staff job (both) | Part 3, D7, M14, B8, P13 (drawn) |
| Test the weight for one bout | Part 1, D1b (drawn) |
| The fighter's voice on the class (both) | Part 1 asks, D1c, B9 (drawn: "Samira asks") |
| Short-notice heavier offers | Part 4, D3 |
| Refuel setting + second-day limit | Part 4, D5 |
| Cycle week band | Part 3 (forecast only, ESTIMATE, TO SOURCE) |
| A Why line | M10, B7 |
| One currency: WIN on every option; ENERGY sum (sim) | Part 2, part 7's table, the ENERGY bar (drawn) |
| Kayleigh -9 vs -13 | fixed: -13, Kayleigh 81 (part 6) |
| Opponent fog + Write it | Part 6 fog table, D10, M15 (drawn) |
| Trim + ask a kilo as a plan row | the GAMBLE row (drawn) |
| Discipline grows | Part 3 (drawn: clean camps 1 of 3) |
| Weekend as a standing house rule, plain fractions | Part 3, D6 (drawn) |
| Class card: business, next 3 with win, top-5 walks, roster clash, move after next bout, when STAY stops being cheap | Part 1 (drawn) |
| BJJ weight rule | Section 2's no-gi column, M18 |
| Trim steps marked MISS / favour / cap | Part 7 (drawn) |
| MISS RISK badge + If Samira misses | Part 5 (drawn) |
| Decide in advance if the other corner misses | Part 5, D9 (drawn) |
| CUT: kg-a-day table, kcal on cards, greyed water row, amateur size bars, HOW A MOVE WORKS footer, unlabelled icon chips | all cut: week by cause + one swap; kcal in hover; water in the scale chip; one LEVEL line; the move rules in the Move buttons' hover; row labels |
| Coach sets the trim (both) | the plan row carries the trim; the stepper opens from the row |
