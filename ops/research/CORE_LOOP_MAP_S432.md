# CORE LOOP: the S432 maps and the S433 mat plan joined into one loop (S432 integration, updated S433)
> NAME (operator Q-190, S434/S435): "Just rename it 'gym sponsorship', the club pays". What earlier maps and drawings call the PAID SEAT is the GYM SPONSORSHIP here (short: sponsorship): the CLUB pays its own amateur for a 4-week block. It is not a Sponsor deal (Club > Money), where an outside business pays the club; no screen may mix the two words.


The operator's ask (S432): review and strengthen everything that drives the loop (building the fighter and the coach, the playbook, training, and how
they decide the fight) and, before building, decide whether the mechanics for this version are done.
Read whole: CLUBWEEK v4.1 (CW), RPG layer v3 (RPG), HYPE v1 (HY), PLAYBOOK (PB), TRAINING v5 (TR; v6.1 since S433), FIGHT LINK v3 (FL), MAT PLAN v1 (MP, S433), the club week VERDICT, the twelve
final critic reviews (v4_*, rpg3_*, hype_*, pb2_*, fl3_*, tr5_*), CRITIC_PACK, CRITIC_ACCESS, and the approved paintings (docs/mockups/s432/ludo, painting 1;
words from docs/mockups/s431/final/squad.html and overview.html). Code checked where maps disagree (listed in section 2).
Drawn: `docs/mockups/s432/core_loop.html` / `.png` (the loop on one page). Game text never says he, she, her or him. "You" is the head coach (the player);
"Coach" is the hired assistant coach.
S433: training v6.1 passed (7, 7); Ana's mat plan v1 (MP, `MATPLAN_MAP_S433.md`) passed (7, 7); the owner's three answers are in: Q-186 "No,
full-time once pro" (C31), Q-187 featherweight and middleweight professional tables "Yes, both" (C32), Q-188 Ana's mat plan "This version" (C33).

## 1. THE LOOP IN ONE PAGE
| Station | The player decides | What flows to the next station |
|---|---|---|
| 1 THE WEEK (Club week, Monday) | who gets the 8 pad places, the 6 coached mornings and the gym sponsorship; Coach's evenings as pads or a class; the sparring pair and setting; the twist; each fighter's season target and load | -> PAD PLACES, MORNINGS AND THE LOAD: which sessions each fighter gets, at which pace, with whom, coached by whom; cash from class nights |
| 2 TRAINING AND PADS (Training tab) | the load (Easy, Normal, Hard, Sharpen), morning exceptions, each pad place's card, the diet, the niggle's answer | -> POINTS, MASTERY AND WEAR: ability points toward each ability's own ceiling, move mastery (and its fire share), habits half fixed or gone, tiredness, niggles; Known from your own sessions |
| 3 THE FIGHTER AND THE COACH GROW (Profile, Character, Club > You) | a perk's version, the build direction, your either/or level pick and style, the talk, the stance on hype | -> WHAT THE PLAN CAN ASK: how well each line is done (grade), how often it fires, how many lines are brought, which perks fire, which traits cross a line, how much of the corner gets through (mood, loyalty) |
| 4 THE PLAN AND THE BILL (Fight plan, the bout page) | which card on the sheet; lines, rounds and IF READ; WHERE and the pace by round; the scale, film, the four lines brought, the towel line, your prediction | -> THE NIGHT'S STARTING POINT: lines with their worth, WHERE and pace, the Tank at the first bell, readiness, the towel line, the judges you know |
| 5 THE FIGHT (fight night) | shouts every 30 seconds, the corner minute (one change, the line change, recover, set-up, talk, TRUST ME), the towel when it comes | -> WHAT HAPPENED: 18 exchanges (24 in four rounds) with every part stored, rounds scored by the judges, counts, damage, the result |
| 6 WHAT IT TEACHES AND PAYS (the result, the Why, Monday) | each receipt row's button; Ready, Building or Rest; the talk after a loss; cash it in or protect the record | -> NEXT WEEK: the fix put on the board, the stand-down, tiredness, ticket cut and fans, rank and reputation, members, experience, loyalty and mood, marks and traits moved, the Monday snapshot |
Two slower loops run under it: MONEY (dues, class nights, the ticket cut, the purse's 25% -> sponsorships, staff, rent: CW) and THE SEASON (the target, fans,
the regional ladder and the pro offer: CW, HY). Every station prints its price in the next station's terms (TR T24 one run, FL M1 the bill as a forecast
of the receipt), so the player can always see how a Monday choice reached Saturday.

## 2. OVERLAPS AND CONTRADICTIONS, AND THE ONE DECISION FOR EACH
Code read for these: BoutRules.stale_energy (0 when camp.protocol < 1, 2 a point over 50, at most 20), BoutRules.NO_CAMP_EDGE -1.5, BoutNight._peak line 108,
Data.START_MOVE_SHARE (uppercut and check hook 0), Knockdowns (stop_mult read only in round_counts, set only for side "b" in BoutNight line 227;
puncher_chance never reads it), FighterGoal (writes a trust_delta nothing reads), FighterProfile.trust (reads morale), PerkRoad needs (already the 14
abilities), Combos.spend_factor / refill (read the old conditioning mean, passed from BoutNight 302 and BoutRead 187), Exchanges.round_of and
BoutRules.scorecards, Exchanges.FULL_SHOUTS 2, CornerJobs.RECOVER_POINTS 3; Knowledge.gd is called by no script; LiveRound.gd 494 lines, BoutRead.gd 497.
S433 also: Roster.turn_pro (240) leaves f["day_job"] set, so GymSpend.gain keeps DAY_JOB_GAIN x0.85 on a professional; ProLadder.division_for (39)
picks the world table by limit over 62 kg, so a featherweight professional lands on the lightweight table and a middleweight on the welterweight;
assets/data/world/divisions.json holds four tables (women's and men's lightweight and welterweight); WorldLadder._weight (463) and WorldCompare (247)
know only "lightweight" and "welterweight".
| # | The conflict | The one decision | Maps that change |
|---|---|---|---|
| C1 | The bond: loyalty (CW, RPG), "trust +25" on a goal (TR T25, FighterGoal), "you sold me" (HY), the towel's answer (FL) | LOYALTY (0-100) is the bond, the only one. MOOD is this week (morale; its corner uptake is the code's FighterProfile.trust). FighterGoal's dead trust_delta is deleted; a goal moves mood (code) and a met season target moves loyalty (CW). Every other price on a person names loyalty or mood | TR T25; code FighterGoal |
| C2 | "Legs": CW and TR call the energy at the first bell the Legs; the approved Profile and Fighters page use LEGS for the group Speed, Footwork, Flexibility | The approved page keeps LEGS for the group. The energy at the first bell is THE TANK everywhere (Combos.TANK 100: "Tank 92 at the first bell"). Tiredness (0-100) is the training number on Training, Condition, Profile and Fighters; fight pages (sheet, bill, tale of the tape, the result) show the Tank only, never both on one row | CW 4, 6; TR F5, T14, T31; FL M1 row LEGS -> TANK; PB 4.5 |
| C3 | "Cardio": TR F3 makes it the word for the Stamina ability; the approved Profile uses CARDIO for the group Stamina, Recovery, Heart (operator S431: "Cardio" not "Engine") | CARDIO is the group. The ability is STAMINA on every row, line and goal ("Stamina 64: no fade from round 3"; "Goal: Stamina to 61", as painted). F3 also moves Combos.spend_factor to Stamina and Combos.refill to Recovery (tr5_perf, checked: both read the mean today) | TR F3, T17, T22, T25 |
| C4 | The Tank's scale: CW 1 a point of tiredness over 50; code and TR 2 a point | 2 a point over 50 (code), that part at most 20; plus weight left to the day (same-day scale 1 per 0.1 kg, 2 past 0.5; day before 1 per 0.2 kg) and your own last bout (7 days -8, 14 days -4); all at most 25 off; on every bout, camp or not (NOCAMP1). The freshness slope under 50 is a training v6 change (section 4) | CW 4 |
| C5 | The fight-week shape (CW Rest up / Tick over / Train through, fixed "about 8" and "about 12" off) and the load (TR Easy / Normal / Hard / Sharpen) are one control under two names | One set of words: the LOAD. In a fight week the choice is Easy, Sharpen or Normal (no Hard); its Tank comes from the week as laid. Rest up, Tick over, Train through retire as words. Readiness (FL M6) reads it: Sharpen or Normal with one pad place in the last five days = sharp +1; Easy = 0 and a slow round 1 | CW 4, 5; FL M6, section 6; TR 6b |
| C6 | CW's BUILDING trains at x1.1 while TR prices every gain from the load | BUILDING means no sheets, nothing more; its reward is that Hard blocks fit. The x1.1 goes | CW 4 |
| C7 | Three pace controls: HY Entertain / Box smart / Safe on the bill, PB round pace, FL M5 Push moving the dial | ONE: Push / Steady / Save per round phase on the Fight plan's round strip, changed live as built; Push also moves the pace dial +15 (FL M5). HY's Entertain / Safe pick is cut (both hype critics): the show is READ from the settled fight (rounds at Push, a count scored, a stoppage win; rounds at Save or tied up count against) and gives the buzz. The bill keeps YOUR PREDICTION | HY 4.4, 5, 6; FL M5 |
| C8 | Scoring: PB 4.3 halves a safe line's won exchange in Exchanges.round_of; FL M2 replaces BoutRules.scorecards with Judges | ONE scoring rule, Judges (FL M2). PB 4.3's "points" column becomes the clean punches a won exchange lands for the judges (a leave line x0.5, tie up x0.5, feint x0.75, four punches x1.3). round_of stays the exchange count for the corner's card and the scales. Amateur cards: a count is a big round bonus, 10-8 only with a clearly won round, every round has a winner; professionals: 10-8 a count, 10-10 allowed (referee critic) | PB 4.3; FL M2 |
| C9 | Ahead or behind before the last round: PB 4.5 counts rounds itself (level = behind); FL M7 the corner's card | One read, the corner's card (M7), right as often as the cornering coach; PB 4.5's IF AHEAD / IF BEHIND reads it | PB 4.5 |
| C10 | Where the fight goes: PB 4.7 place counts, FL M3 three places, FL M5 WHERE | One strip, THE THREE PLACES (M3), fed by PB's place counts; the Fight plan header shows it once; WHERE is the only pick. The line's worth carries both chips: GRADE (how this fighter does the move, PB 4.1) and SUIT (where it takes the fight, FL M4), one number | PB 4.7; FL M3, M4 |
| C11 | The towel: FL M13, RPG's "towel" asks, CRITIC_PACK's cutman card (R28) | ONE card, FL M13. Its reasons: a count, head damage critical, the risk past your towel line, an eye closing (for an amateur that reason is the doctor's look, shown as such). RPG adds marks PULLED ME OUT and SENT ME OUT to its marks table (the knockout card reads them); loyalty by band is RPG 3's. It never uses the minute's ONE CHANGE | RPG 9; FL M13 |
| C12 | Known: RPG 8 (Knowledge.gd), "THE READ" (v4 critic), ceilings as ranges (TR T16), the grade as a range (PB 4.1), heart printed plain at Known 2 (progression critic) | ONE system, KNOWN = Knowledge.gd, by its three groups Body / Skills / Fire, grown only by your own sessions. Every range on a fighter's own numbers is Known's (abilities, ceilings, the grade, heart, the towel's risk). Heart is in Fire: a range until Fire is known, unless it was on show at signing. "TheRead" stays a fight rule's name, never a screen word; "pip" is not a game word: "4 more sessions with you". HY's hype lift is Known's input for prospects only | RPG 8, 15; TR T16; PB 4.1; HY 3 |
| C13 | Units: wins in 100 on chips (CW), edge points "+4.0 a use" (PB), "+2.1 in 100" in the ledger (RPG), exchanges (FL) | Three kinds only. WHAT A FIGHTER IS: 0-100 (abilities, mastery, tiredness, mood, loyalty, hype, heart; kg, $ and fans as counts). WHAT A CHOICE DID OR WILL DO ON A BOUT: exchanges of the bout (18, 24), a range before, a number after. A CHANCE: N in 100 (the win chance and its difference, stoppage, injury, a cut). Season effects in their own unit: weeks, $, loyalty points, fans; each in its own colour, never added. The cut rule stays in wins in 100, a designer's line never printed | CW 3.2, 4; PB 5, 4.x; RPG 6, 13; TR T2, T23; HY 4.4 |
| C14 | Four "against Coach" numbers: CW's bill (your week), PB (your plan, said to be the same number: it is not), TR T23 (your week), FL's Monday sum | ONE number on the bill: YOU AGAINST COACH, the bout's win chance with all your preparation against Coach doing all of it (the deal, the load, the plan, the night's picks), N in 100 as a range, with three parts: THE WEEK, THE PLAN, THE NIGHT'S PICKS. The Fight plan shows the plan's part, Training's buys panel the week's part; Monday sums the month in exchanges | CW 4; PB 5, 4.14; TR T23; FL M1 |
| C15 | The professional's camp: PROTOCOLS Light / Standard / Hard (free, flat edge up to +1.0) kept on the camp card beside the load (TR 8b); FL M9 removes the edge; CW sets length by target | The camp IS load blocks: BUILD / PEAK / TAPER on the strip, each with a load (default Hard, Hard, Sharpen); the camp card keeps length (4 weeks BUSY, 6 RANKED, CW 3.9), focus, partner and film. PROTOCOLS' levels and their night edge retire; PEAK CAMP's three lines met = readiness +1 (FL M6) | TR 8b; CW 3.9, 4; CRITIC_PACK 4.3 |
| C16 | Nerves: HY (hype 60+, confidence under 60: round 1 -0.5) against FL M6 (Hot, confidence under 45: readiness -1) | One rule inside readiness: -1 when Hot and confidence under 60, or Warm and confidence under 45. SHIELD and TALK THEM DOWN clear it | HY 4.5, 4.7; FL M6 |
| C17 | The sparring pair: CW pair picker and setting, TR partner level, FL matchup sparring, RPG partners and feuds, TR stand-down | ONE pair picker on Club week, each a chip on it: weight fit, setting, partner level (x1.2 / x0.8), "fights like <opponent>", PARTNERS / FEUD, greyed in a stand-down, no Hard under Family club. The Training tab shows sparring cells locked "change on Club week" | CW 3.6; TR T4; FL M14; RPG 10 |
| C18 | After a bout: TR stand-down (no sparring 5 / 10 / 21 days by head band), CW REST (2 weeks), RPG "two weeks off" | The stand-down is the floor, set by the bout; REST is the choice (2 weeks, Easy, no sheets); the moment's answer IS Rest | none |
| C19 | Habits: CW 6 of your pad places, TR 3 + 3 by coachability, RPG Known pip 3 "a week sooner" | Counted in YOUR pad places: 3 to half fixed, 3 more to gone; coachability under 40 one more a step, 70+ one fewer; Known Skills known: one fewer (never under 1); One on one's lone morning counts as a pad place on it. In the fight x1 / x0.5 / 0 of HabitFix's cost, shown in exchanges | RPG 8 |
| C20 | "Coach runs it" in three places | Three buttons by scope, never more: COACH DEALS IT (the board), COACH RUNS <NAME> (one fighter's weeks; Known stops growing), COACH CORNERS (the night) | CW 4; TR T11; RPG 11 |
| C21 | Fighter page tabs: approved painting (Profile, Condition, Training, Playbook, Fight plan, History); RPG adds Character; HY adds Crowd; pb2_player wants no Fight plan tab; CRITIC_PACK has Week and Fight prep | The approved six plus CHARACTER and CROWD (eight). FIGHT PLAN is the Playbook's Game plan page (one page); the Playbook tab holds Moves and Combos. Fight prep goes: its parts live on the bout page and the Fight plan header | RPG 15; HY 6; PB 6 |
| C22 | A development aim (tr5_series) and the build direction (RPG 12) | One system, BUILD DIRECTION (RPG 12); the Training header shows it; Coach's week leans to the booked opponent (TR T18) when a bout is booked, else to the season target's pull, and the direction's x1.10 always | TR T13, T18 |
| C23 | Ceilings: fixed (TR F2a), "raise a ceiling" (progression critic, fighter season pick), "+3 potential" on the trial mat at Hot (HY), +5 at signing (code) | One rule, CEILINGSHIFT: a ceiling moves only by a named event: the signing focus (+5, code), a breakthrough (+1 to +3 on a group after a step-up win, PEAK CAMP met, or a season's dose under a coach rated 70+), the fighter's season pick (+3, RPG), a stoppage loss (Durability -2, code). HY's trial-mat +3 goes | TR (v6); RPG 6; HY 3 |
| C24 | Fans: CW (home win +4, home loss +1, away 0, title +10), HY (hype x0.15 home, x0.05 away), RPG marks (+2, +3) | One Fans rule fed by all three; away is 0 everywhere (verdict change 6), so HY's away share goes | HY 3 |
| C25 | Small hype receipts below the cut line (both hype critics): mood +2 a week at Warm, topping an away bill, a free clip button, QUIET as a card | Cut mood +2 and the away slot; the clip happens by itself (+4 heat on a week you hold a pad place with them); QUIET is "no stance". One home per action: the stance on the Crowd tab (a chip on Club week), the paper on Club week, the prediction on the bill, the call-out on the Crowd tab | HY 3, 4, 6 |
| C26 | The corner minute: one change (code), a WHERE step (FL), two set-ups (RPG The minute), the line change (PB 4.10), the towel (FL), TRUST ME (RPG) | The minute holds, in this order: the corner's card line (or the adapted note, R25); ONE CHANGE (habit fix, Elbows in, Gloves high, or one WHERE step); the line change (the line that lost most and two rated replacements); RECOVER 3 points (4 with TRUST ME when hurt); SET-UP (two with The minute); TALK; the cutman job; TRUST ME once a bout; behind a divider, THE TOWEL when it comes. Stats cut to three rows | PB 4.10; FL M13; RPG 2, 3 |
| C27 | Probes named twice or measuring the same thing: TANKPRICE1 (CW, TR), FIRELEVEL2 (PB, TR), SEASON1 / TRAINSEASON1 / PLANSEASON1, LeverSize against levers.json | LEVERS1 (FL M10) is the ONE measured table (ops/AgentComms/levers.json); LeverSize reads only it; TANKPRICE1 is its Tank rows. FIRELEVEL2 runs once. ONE season harness, SEASON1, with four arms (the board, training, the plan, the night), each with its map's gate. One cut rule: a choice stays if it moves 1.5 wins in 100 on the bouts where it applies (over a season, four matchups) OR has a season effect (weeks to a target, a fighter kept, $150, 4 fans, a habit gone) | CW 8; TR 10; PB 7; FL M10 |
| C28 | The pro offer and the club's share, set in three maps | One function each: Roster.check_pro reads CW's rule, HY's Hot (one win sooner) and SHIELD's PROTECTED (one more); the share reads the loyalty band (under 50: 10%) and HY's manager line (60 if LET IT RIDE) | none |
| C29 | The luck knob (FL 2.2 FORM_SD) is on the small term (engine critic: the 18 exchange dice dwarf form) | LUCK over 20 in the target: EX_SPREAD 66 -> 58 first, FORM_SD only for form. The corner's best call 17 -> 12 now (its size is known too big); LEVERS1 sets the final number | FL 2.2, M10 |
| C30 | THE COUNT card names an exchange and a minute the code never rolls (both FL critics) | Counts move into the exchange stream (KDEXCH1, section 5): a hurt exchange rolls the count from power against chin and damage carried, the round's total chance kept (KDRATE2). Until it lands the card names the round only | FL M12 |
| C31 | The professional's day: CW 3.3 kept a professional under the top 10 on the job rota (with CAMP LEAVE, CW 3.9); the code keeps day_job after turn_pro | Q-186 "No, full-time once pro": an AMATEUR keeps the job rota (dim "at work" mornings; a gym sponsorship frees six); a PROFESSIONAL trains full time from the debut: every morning free, no job row, no camp leave. Counted once: DAY_JOB_GAIN x0.85 retires when JobRota lands; until then turn_pro clears day_job (CAMPLOAD1) | CW 3.3, 3.9, 12; TR 5b (done) |
| C32 | Professional tables: four in the world data; the start has four fighters in four weight classes (S428) | Q-187 "Yes, both": EIGHT professional tables, women's and men's featherweight, lightweight, welterweight, middleweight, each about 20 ranked with belts as now; the amateur class maps to its table by NAME, never by kg (PROTABLES1) | CRITIC_PACK 4.14 |
| C33 | Two fight plans: the boxers' (PB) and the grappler's (MP) | One page logic and one set of words: lines on places, rated BEATS IT / WORKS / WALKS INTO IT, priced, a receipt after; Push / Steady / Save (MP's scoreboard rows); the Tank (C2); Coach's draft with your changes in gold; ON THE MATS beside ON THE PADS; the corner's grade by replay on the same dice (the Why's words). Units (C13): a mat choice in points and beats of the match, chances in 100. The grappler's Fight plan tab is MP's MatPlanPanel; the boxers' tab is PB's | PB; MP; FL M11; TR 8c |

## 3. THE PAGES (each built once; [map] says where its content comes from)
FIGHTERS PAGE, approved (painting 1, `ludo/fighters_paint-v1.png`, words of `s431/final/squad.html`). Exactly:
- Top bar: back and forward, the club name, date and week, Gym, Mail (n new), cash and "running -$N a week", NEEDS YOU (n) with the first need, Menu.
- Head: the Fighters badge; tabs All four, Club week, Compare two, Find a fighter ("4 of 4 places taken"); the THIS WEEK strip (the club twist and its
  price, "Club week >").
- One row a fighter, columns: FIGHTER (face pin, red badge when it needs you; name on a navy label; weight class and age; style word and stance; record and
  the road line, e.g. "1 win from the table", "Number 8, London", a belt); OVERALL (ring 0-100, five group bars Head, Hands, Guard, Cardio, Legs with a dot
  on the best of the four; "Best move: Jab 61 Sharp"); TIREDNESS (number, bar with the 80 mark, a word: Fresh, 3 rest days); WEIGHT (kg, bar to the limit,
  amber "0.9 kg over" only with a weigh-in coming, else "limit 65.0"); MOOD (number, bar, word); COACH SAYS, THIS WEEK (Coach's one change with its tag
  FIX / REST / DRILL and its weekly gain; the goal ring with goal, days left and status); NEXT FIGHT (days, tag OFFER or OPEN, name and record, date and
  answer-by; or "No bout, next offers Mon 19 Jan"); DO NEXT (one pin: Answer offer in gold when it stops the clock, Set a goal, Rest 3 days, Enter the open).
- The one-line key at the bottom (in the game, hover).
Added without a new column: the role (PROFESSIONAL / AMATEUR / GRAPPLER) on the weight-class line [CW]; loyalty word and hype band in the face pin's hover
[CW, RPG, HY]; DO NEXT takes the single most urgent need from every map in one fixed order (clock-stopping first: offer, weigh-in, pull-out, wants a word,
perk pick, moment, the manager's call, set camp) [CW, RPG, HY]; COACH SAYS shows the top pull with its size range [CW]. The painting shows the old start
(Lucy an amateur): the build fills it from CW's start, the professional's row showing the promoter's offer or the camp block.
FIGHTER PROFILE, approved (painting 1, `ludo/profile_paint-v1.png`, words of `s431/final/overview.html`). Exactly:
- Tabs Profile, Condition, Training, Playbook, Fight plan, History (Character and Crowd join, C21); the next-step strip ("Show in 19 days · Bout offer:
  <name> · <what it opens>") and one gold button; the name, weight class on a navy label, age, stance, style; record and road line; the ring "60 of 100";
  four face pins to step between fighters (red dot = needs you); the 3D figure with five group pins and leader lines.
- Groups, each a pin, a title and a caption: HEAD "reads the fight, keeps the plan" (Fight IQ, Composure, Discipline, Confidence, Coachability, Temper;
  the four traits hatched "cannot be trained", each with its word: holds the plan, swings by round, shouts land less, Trades when hit); HANDS "what
  lands" (Accuracy, Timing, Inside fighting, Strength, Explosiveness); GUARD "what gets through" (Defence, Durability); CARDIO "how long it lasts" (Stamina,
  Recovery, Heart "gets up"); LEGS "gets in and out" (Speed, Footwork, Flexibility); TODAY with the weight limit (Weight with "+ Cut", Tiredness with its
  word, Mood with its word).
- Each bar: the white ceiling tick, the number, "+0.4 a week", a session tag ("+ Sparring", "+ Mobility"); the key line (ceiling, goal, cannot be trained,
  Weak to Elite); the goal ring ("Goal: Stamina for five rounds · Stamina 58 of 61, 18 days left · On track"); buttons Plan the week, Fight plan (n lines),
  Compare the four, Stipend ($250 a week; a professional: the purse share); Coach's pin and bubble with one line, its weekly gain and "Do it".
What the maps put into it: the tick is the ability's OWN ceiling, a range until Known [TR F2a, RPG 8]; an open group's numbers show as ranges, Heart a range
until Fire is known [C12]; "+0.4 a week" is the 4-week trend, turning amber "fades Sat 28" when no session doses it [TR T20, T15]; hover gives the next
line and its day and the trait's next line [TR T17, RPG 5]; under the record line one row of three chips that open their tabs: loyalty word, hype band,
direction [RPG, HY]; Coach's bubble is the top pull with its size range and "Do it" [CW].
CONDITION: the long tiredness curve with 70 and 80, the Tank on the next bout's day, usual and safe work, the injury and its answer (train around / full
rest), the niggle, the stand-down and the day sparring opens, the body places and damage [TR 8, T19, T32].
TRAINING: header (goal on an ability, Recovery's clear rate, the direction); the season strip (blocks, Sharpen, the Tank on bout days, safe work); THE LOAD
(four buttons, work and clock, this week and the block to the target, the fighter's ask); the week grid (session, pace, who coaches with the lift, reason;
your changes gold; shared slots locked "change on Club week"; alone cells at the mood rate); abilities sorted by worth against the booked opponent with
room, next line, trend and the dose that keeps them; pad places (dates, fire share, the habit with its hand); <DAY>: WHAT THIS WEEK BUYS (the week's
part of YOU AGAINST COACH); the 13 days to the bell; weight with the weigh-in's hour [TR 8, CW 3.7]. A professional's grid has no job row (C31); Ana's
tab is the class kinds with FILM and "THE OPEN: WHAT THIS WEEK BUYS" [TR 8c, MP 4.8]. Training v6.1 passed (section 4); built after its stills (TR 11.4).
PLAYBOOK (Moves, Combos) and FIGHT PLAN: Moves with each move's two attributes and the grade; Combos with fit rows, place, exposure, fire share, record and
"Put in the plan" [PB 6]. Fight plan: header with THE THREE PLACES strip, WHERE and its price [FL M3, M5]; the lines (where with x of 18, round pips only when
not all, read, grade, suit, fires, price chips, worth in exchanges a bout, a range while a tell is hidden, IF READ); ROUND BY ROUND with pace per phase
and the Tank forecast; the opponent's game; THE LINE (the evidence); the last receipt; the plan's part of YOU AGAINST COACH; Test it, Real plans that
fit, Map, Coach's draft with your changes marked (pb2_player) [PB 5, C7, C10, C13, C14].
ANA'S FIGHT PLAN (the grappler's tab, MatPlanPanel): the A-game strip with the OPENING; the lines (where with beats of 27, line and timing, read vs the
opponent, grade, level, price chips, chance, worth); the hand by belt; THE SCOREBOARD rows Level / Ahead / Behind; the opponent's file with FILM; where
the match goes; THE LINE; the last open's receipt; plan against Coach's; Coach's draft, Systems, Test it in Sunday's roll [MP 5, 6, C33].
CHARACTER: the loyalty bar with bands and the forecast; what they want (ambition against the season target); marks; the perk pick priced on the next three
names (in exchanges, ranges); traits with their next line and the button that moves it; Known by group with "N more sessions with you"; the direction;
what your picks won (exchanges and rounds turned; for Ana, mat plans in points and matches turned, MP 4.7); who decides this fighter's fights (FL M1); a waiting moment card [RPG 15, FL M1].
CROWD: the hype gauge (buzz solid, heat striped, band word), the 12-week line, what moved it, fans with "+N on a home win", receipts and costs as tiles, the
stance (Sell, Shield), the call-out; no Entertain buttons, no clip button [HY 6, C7, C25].
HISTORY: each bout with its scales and count card, marks beside the bouts that made them, CHAMPION at the season's end [FL M1, RPG 9].
CLUB WEEK: the season strip; counters in one unit (asked, covered, short) for pad places, coached mornings, Coach's evenings (pads or class with the cash),
the sponsorship, favours, the trial mat; a row a fighter: role badge, mood word, loyalty bar with forecast, sponsorship or job (amateurs only, C31), diet cell, load chip, tiredness, pulls
with size ranges in their own colours, seven days with the pair picker and setting, the crowd cell, direction and captain chips, moment cards with coin
tags; the talk card; PROMISES OPEN; the twist; your deal against Coach's; three deal buttons; Start week [CW 6, RPG 15, HY 6, TR 8, C17].
CLUB > YOU and CLUB > PEOPLE: your level, experience by outcome, the either/or pick with BEST FOR, the road, your style in this squad's numbers, what your picks
won, Known per fighter, the squad; Coach's card with evenings as pads or class, the signature drill, the raise [RPG 15, CW 6].
FIGHTS, THE SHEET AND THE BILL: the sheet's three cards (win chance, rank, pay or travel, fans, stoppage risk, file, the strip line, the judges' leans known or
"?", the Tank of the other corner when known, hype on the cut) and Ana's open (bracket names, file dots, "Plan for R1: ready / Coach's draft", MP 6);
the professional's three offers [CW 6, FL 7, HY 6]. OPEN NIGHT (Ana): YOUR PLAN in one line; between bouts ONE CHANGE or WATCH THE OTHER SEMI;
the result's line receipts and the corner's word [MP 4.9, 6]. THE BILL (one page): the scale
(eat less, train it off, a kilo); Coach's evenings before the bout; film; bring 4 lines; both Tanks at the first bell; the scales' forecast rows in
exchanges; WHERE and the pace (links to the Fight plan); the towel line; your prediction; YOU AGAINST COACH with its three parts; Take / Coach runs it / Pass.
FIGHT NIGHT: tale of the tape (readiness word in exchanges, leans, WHERE, the towel line, the crowd line, Begin); the round (shouts, pace and aim, the live
strip, plan captions, nerves on round 1 as readiness); THE CORNER MINUTE as in C26 [FL 7, RPG 15, PB 6].
THE RESULT AND THE WHY: opens on the one story that decided it (the cards, a count, or the towel), the rest one press away, never more than six rows on screen
(referee critic): the bout strip, THE SCALES with the headline in row 1 and each row's button (YOUR PLAN opens PB's per-line receipt), the judges with one
reason each, THE COUNT when one came, what you did to them, the rank earned, fans and hype before and after, perk and trait chips, the towel call named, the
stand-down day; the Why in one line. Money lines go to Home and Money [FL M1, PB 4.11, HY 6, CW 6].
WEEK REVIEW (Monday, a need on Home, never a pop-up): whole points with causes, lines crossed, fades, habits moved, who went short and its loyalty price,
experience by outcome, traits crossing lines, hype moves, "your choices this month: +N exchanges; Coach's week would have given +M" [all six].
HOME: needs only, one line a fighter, the next fight. PRO OFFER: the debut's tickets from fans and hype, the $1,105, the share by loyalty, what ends (the
stipend and the day job: full time from the debut, C31), cash it in or not yet with each path's expected club money and the manager risk priced inside
it (hype designer) [CW 6, HY 6]. WORLD > RANKINGS: the professional table of each division the gym has a professional in, eight in all (C32).

## 4. MECHANICS COMPLETE FOR THIS VERSION
| Track | Final scores | Verdict |
|---|---|---|
| Club week (CW v4.1) | 7, 7 | YES (verdict's ten changes in) |
| RPG layer (RPG v3) | 7, 7 | YES, with: an upside line on every trait (confidence 75, temper under 35, heart 70, discipline 75); Known and traits agree (C12); a fighter's season pick (deepen, also open at a price, raise a ceiling via C23); every size a range; a price on changing direction (drift restarts, loyalty -2); the room and the captain split (captain: nobody skips; the room: shared morning 0.9); the reveal spread (direction week 8, moments 9, ledger 12, a perk pick the day one opens) |
| Hype (HY v1) | 7, 7 | YES, with C7, C16, C24, C25, YOUR WORD (calls landed this season scale the next call's heat) and WHO CARRIES A LOSS (On me / On the fighter on the Why after a hyped loss) |
| Playbook (PB) | 7, 7 | YES, with C8 to C14; the price built in the exchange (LinePrice into the round's cost and the opponent's landed punches); worth in exchanges with ranges while a tell is hidden; Coach's draft for every booked boxer with your changes marked and "keep last plan, re-rated"; HOLDS THE PLAN (fire share x0.7 hurt, x0.8 under Tank 40, Composure gives it back) |
| Fight link (FL v3) | 7, 7 | YES, with C26, C29, C30, the amateur / professional rule branch (C8), and a referee's book left for later (section 6) |
| Training (TR v6.1) | 7, 7 (2 rounds in S433: v6 7 / 6.5, v6.1 7 / 7; tr6_2_0, tr6_2_1) | YES: v6's five changes (the load buys fitness, no dead zone, Stamina continuous, the camp is the load, a career arc) plus blocks that build (T35), two engines (T36), morning rules (T37), response and age (T38), head contact (T39), the professional's last day's water (T8), the goal in four bands (T25), Hard aimed where it pays (T1), Ana on the same rules (8c), the gate table before any pixel (TR 10), full time once professional (5b, C31) |
| Ana's mat plan (MP v1, MATPLAN_MAP_S433) | 7, 7 (mp_1_0, mp_1_1) | YES, with two fixes from the critics folded into their tasks: the improviser's pin value for both sides in M4 before MATPLAN0 runs (an unlined pin tries escapes at a sane rate; GAMETREE bands kept), and the defender's hand-fighting stack counted in every chance, so M3's worked numbers are what the walk plays |
WHAT PASSING MEANS FOR THE BUILD. The set is closed for all seven tracks; nothing new enters them, the probes only cut. Training's rule modules and the
Training tab are UNBLOCKED (section 5 step 2 and screen 14); each module waits only on its own foundation tasks and its gate-table row (TR 10), and the
tab's Cursor brief on the three stills TR 11.4 names (week 1, Lucy's camp, Ana's mat week). Ana's mat plan joins as its own group (MP 9, section 5).
Sizes in wins in 100 stay off every screen until their probes report.
MECHANICS DONE: YES. Every track for this version is at 7 and 7; building goes by section 5.

## 5. THE BUILD ORDER
Seats: pure module + test -> Qwen (PC) or Goose (cloud); probes -> Goose or Arena (cloud); screen -> Cursor (Claude checks the stills); fight code and core
state -> Claude, the 3D side -> Ziva; golden path -> Grok Dev. Each task under 500 lines, one owner, its test red on main first.
STEP 0, FOUNDATION FIXES IN TODAY'S CODE (nothing measured or drawn before these land; files touched by two tasks run one after the other)
| Task | What | Map | Seat | Waits on |
|---|---|---|---|---|
| F1 REST1 | rest stops taking Stamina (Attrs.train) | TR | Qwen | none |
| F2a CEIL14 | 14 shaped ceilings (Recruit.ceiling_of) | TR | Qwen | none |
| F2b GAIN14 | each session's gain on each ability's own room (WeekPlan, Attrs, Sim.week_ctx) | TR | Claude | F1, F2a |
| F3 CARDIO1 | the fade, goals, spend_factor and refill read Stamina / Recovery; FighterGoal's dead trust_delta deleted; FADESHARE | TR, C1, C3 | Claude | none |
| F4 LOADWORK1 | one load unit, work (WeekPlan, Injuries, TrainingLoad, InjuryRoll) | TR | Claude | F2b (WeekPlan) |
| F5 NOCAMP1 + TANK1 | BoutRules.tank on every bout in place of stale_energy (BoutNight._peak); NO_CAMP_EDGE professionals only; the canned Why lines deleted | FL, TR, C2, C4 | Claude | none |
| F6 STANDDOWN1 | StandDown.gd (pure) + wiring in PadWeek, Injuries | TR | Qwen, then Claude | none |
| F7 PUNCHSTART1 | one punch rule for both corners (Data.fighter_state, AttrGen._attrs_build) | FL M8 | Claude | none |
| F8 STOPMULT1 | stop_mult set for side "a" as for "b"; puncher_chance reads it | RPG 17 | Claude | none |
| F9 LIVESPLIT1 | the exchange's edge sum moved to a pure ExchangeParts.gd (LiveRound is 494 lines) | FL | Claude | F5 |
| F10 KNOWN0 | Knowledge.known() and the pip bands (Qwen); range_of wired into the attribute board, Profile, trial card, bout sheet (Cursor) | RPG 8, C12 | Qwen, Cursor | none |
| F11 KDEXCH1 | counts rolled inside the exchange stream, the round's chance kept (KDRATE2 within 10% on 600 bouts) | FL, C30 | Claude | F9 |
| F12 CORNER17 | the corner's best call 17 -> 12 (one constant; LEVERS1 sets the final) | FL, C29 | Claude | none |
| F13 DOSE1 | the load buys fitness: Hard's gain 1.6, the block's dose x1.3, Hard laid on the aim (WeekPlan; tests/dose_test.gd) | TR F8 | Claude | F4 (WeekPlan) |
| F14 CAMPLOAD1 | PROTOCOLS' levels become one Camp row (edge 0; PEAK CAMP = readiness +1); Roster.turn_pro clears day_job (BoutRules, modals/Camp.gd, Roster; tests/camp_load_test.gd) | TR F9, C15, C31 | Claude | F5 (BoutRules) |
| F15 CALLSPREAD1 | a call's OK-to-Good step spread across 56 to 62 (Exchanges.grade; tests/call_spread_test.gd) | TR F10 | Qwen | none |
| F16 PROTABLES1 | eight professional tables: divisions.json gains w_fw, m_fw (57.2 kg) and w_mw, m_mw (72.6 kg); ProLadder.division_for maps the amateur class by its name (Data.DIVISIONS "short"), not limit > 62; WorldLadder._weight and WorldCompare read the table's name; a save whose world lacks a table gets it generated on load (WorldGen). New tests/pro_tables_test.gd, red on main (a 57 kg professional sits on the lightweight table): each class on its own table, eight tables of about 20 ranked; pro_ladder_test, world_years_test, matchmaking_bots_test, save_load_test stay green | C32 | Claude | none |
Then MORNINGS1 (the session shares, after F2b) and GOALBAND1 (FighterGoal, after F3), as TR 11.1.
STEP 1, PROBES ON THE PLAYED BOUT (cloud; each prints today's game first; each writes levers.json; the cut rule of C27 applies; no size on any screen before
its row exists): LEVERS1 with THE TARGET first (preparation 55-70, the night 20-30, luck 10-20 of every 100 exchanges turned; its Tank rows are
TANKPRICE1); PUNCHFLOOR1; PLANTUNE1 and LINEGRADE1 (they move every plan number); FIRELEVEL2; JUDGES1; SEASON1 (four arms); LOYAL1, SHORTWEEK1, FOLLOW1,
MONEYFOUR2 (with TICKETCUT1), MOODRATE1, SPARSET1, SHEETDEAL1; LINEPRICE1, ADAPT1, PHASE1, OWNLINE1, CARRY1; AIM1, FORM1, CARDREAD1, TOWEL1, DAMAGE1, SPARAS1;
HYPEFLOW1, SELLSHIELD1, CASHIN1, CALLOUT1, CRASH1; COACHPICK1, PERKPICK1, TRAITLINE1, KOTURN1, KNOWN1, DIRECTION1, STYLE1, MOMENT1, COACHXP1. Training's
gate table (TR 10): PACE1, DOSE1, BLOCKORDER1, MORNRULES1, RESPONSE1, AGEGAIN1, CONTACT1, WATERCUT1, FITLEGS1, HORIZON1, BJJCLASS1. The mat (MP 8):
MATPLAN0 once M4's pin fix is in, then on M4 MATKNOW1, TRAILFIX1, MATLINE1, MATFRAME1, MATFINISH1, MATCLOCK1, MATCARRY1. All Goose or Arena. They wait on
Step 0.
STEP 2, RULE MODULES (pure, unit tests; Qwen or Goose; wiring into fight code by Claude, one task per file touched)
| Group | Modules | Waits on |
|---|---|---|
| Club week | Favours, JobRota, ClubDeal (with Coach's evenings), ClubTwist, WeakSpot, FightWeek, BoutSheet, TrialMat, Loyalty (bands, forecast), SeasonTarget, Fans, SparSet, LeverSize | Step 0; LeverSize on levers.json |
| Fight | Snapshot, Scales (true-replay headline), Judges + Officials, Readiness (with nerves, C16), Aim (WHERE and the pace dial), CountCard, Towel, SparAs, CornerCard; wiring: parts into ExchangeParts, Judges into BoutNight, Readiness into RingDuel.form, Towel into CornerJobs (Claude) | F9, F11; JUDGES1 for Judges |
| Playbook | LineGrade, LinePrice (into the round's cost and landed punches), PlanPhase, OwnLine, PlanWhere, suit in PlanFight; FireLevel on in GAME_ON; ReadBack on only if ADAPT1 passes | PLANTUNE1, LINEGRADE1, FIRELEVEL2 |
| RPG | CoachLevel, CoachStyle, TraitDrift, BuildDirection, PerkPick (eight pairs + Ana's), Moments, Marks, SquadBonds, Ambition, Ledger, CoachGrowth, CeilingShift | Loyalty, ClubDeal, KNOWN0, STOPMULT1 |
| Hype | Hype (buzz, heat, the show read from the fight, conversion to fans and tickets), HypeStance, CallOut; ProDebut, Matchmaking.pay_of, Roster.check_pro changes | Fans, BoutSheet, Loyalty |
| Training (UNBLOCKED: v6.1 passed 7 and 7) | TrainWeek.run (ONERUN1), MorningRules, SeasonStrip (emphasis, aim, x1.2), Sharpen and Pattern in WeekPlan, Detrain, OppTests, Niggle, TrainAround, HabitWork, the weigh-in hour and the water, head contact in SparSet, bouts teach, partner level, NoGi class kinds (with FILM, MP 4.4), FireLevel on | F1-F4, F13, MORNINGS1; each module on its gate-table row (TR 10); CeilingShift, BuildDirection and the response in Knowledge from the RPG group |
| Ana's mat plan (MP 9) | M0 MATSPLIT1 (Claude: MatTreeInfo 502 split, MatTree slot; tests/mat_split_test.gd); M2 MatLines, M3 MatPrice (with the defender's stack), M6 MatFile (+ FILM in NoGi.classes_of), M7 MatReceipt (Qwen); wiring M4 MATWALK1 (with the pin value for both sides), M5 MATKNOW1 + TRAILFIX1, M7's BOUTTEACH in Grapplers._close, M10 MATLIVE1 (Claude) | M0, M2 at once; M3, M4, M6 on M2; M5 on its probes; M7 on M4 |
STEP 3, SCREENS (Cursor, one a task, from the drawings; Claude opens every still): 1 Fighters page and 2 Profile to painting 1 (they read existing data and
KNOWN0, so they come first); 3 Club week; 4 Fights, the sheet and the bill; 5 Fight plan and Playbook; 6 the result page with the scales and the count card
(Ziva shows a count on its exchange in 3D); 7 the corner minute with the towel; 8 Character; 9 Club > You and People; 10 Crowd; 11 Condition; 12 Pro offer;
13 Week review and Home needs; 14 Training (unblocked; after TR 11.4's three stills); 15 Ana's Fight plan (M8 MATPLANUI1, from matplan_v1);
16 the open night with ONE CHANGE and the receipts (M9 MATOPEN1, with GrapplerPage, Club week and Training hooks). World > Rankings needs no new screen:
it lists the eight tables once PROTABLES1 lands. Each waits on its rule modules and the levers.json rows it prints.
STEP 4, ONE GOLDEN-PATH TEST (Grok Dev), walking a season: create with a professional and two amateurs; the guide's reveal to week 5; a season target; a sponsorship
placed and renewed; a class night; two pulls followed; a fighter dealt short twice and the talk answered; a Hard sparring evening with a partner chip; the
load card's work equal to Injuries.week_work; a Poor line swapped by its grade and a line taken to Sharp on the pads; a sheet; a no-camp amateur bout after a
hard week with a non-zero TANK row and no NO_CAMP_EDGE part; WHERE and pace by round; the bill's YOU AGAINST COACH with its three parts; a home win adding
fans and hype; the scales naming LAST 4 WEEKS with the pad card's mastery in it; the judges' reasons; a bout with a count on its exchange, THE COUNT card and
the towel card at the line, pulled out once (no durability loss, 14 days); the stand-down locking Thursday's sparring; a level and a pick; a perk version
picked on named opponents; Known making Body plain; a trait crossing a line; a moment and its memory card; the pro offer read through hype; turning
professional with every morning free and no job row (C31); a featherweight or middleweight professional on its own table (C32); the next Monday's
review with "your choices this month". Ana's open walks its own path (M11, tests/mat_plan_path_test.gd, Grok Dev, after M9): Coach's draft, film once,
the swap hint, FRAME FIRST on side control, BEHIND Push, the receipt naming the line, the corner's word, ON THE MATS, Sunday's roll on the same plan.

## 6. LEFT FOR LATER (one list)
- HOSTSHOW1: filling our own card with owed favours, a two-way favours ledger, the house counted in seats and its sales curve, club v club nights.
- The small living world: one national ladder with a mandatory challenger and an eliminator, rivals who age and move, named judges with taste, a rival club
  that poaches fighters and Coach (Eastside ABC as an actor), promises and poaching at contract time, opponents' corners that remember and read your scales.
- The opponent's corner on the same rules (its own change and towel each minute: engine critic), two-sided hype (the opponent's band and the hot-name choice).
- The referee's book: cautions, public warnings, disqualification, stoppages for a one-sided bout and the doctor's cut (referee critic).
- Damage counted from landed punches in place of round bands; a punch-by-punch box on the result.
- A hidden load tolerance read through a morning check (sleep, soreness, effort felt); discipline scaling every session; the coach's report.
- Off-plan by temper and coachability (pb2_player); stance on lines (pb2_boxer); shouts that are the card's lines (pb2_boxer); a line that answers "if they switch".
- The mat plan's next layer (MP 12 and its critics): opponents who bring their own lines by style, a B-game route, one Tank across the bracket's day,
  Ana's Composure holding a timing line under a pin, a grade and receipt for a live bout, the field filming Ana, the live bout on the tree.
- The club's terms at turning professional as a choice; a boxer's own sponsor earned by fans; strike while hot; the comeback heat; a ticket night.
- Scars, prime and decline, retirement talk, retired fighters as coaches; crossover training; coach award names on the levels.
- The full promotion (pro cards, belts, TV), a club season frame and the year review.
OPEN FOR THE OPERATOR: none. Answered S433: Q-186 (C31), Q-187 (C32, F16), Q-188 (C33, section 4, the mat plan group in section 5).
