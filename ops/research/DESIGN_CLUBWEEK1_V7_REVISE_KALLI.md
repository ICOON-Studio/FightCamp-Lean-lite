# CLUBWEEK1_V7 - write the NEXT version of this mechanic's design map (S459 design loop)

You are the designer. Read the whole game (critic pack below), the current map, and the critics' answers at the end. Write
the next version of the map in full (not a diff): answer EVERY point of each critic's 'To reach 10/10' list (do it, or say
in one line why not), keep every rule the owner agreed (quoted in the map), keep it buildable from what the game has, and
keep the map's table of every menu the mechanic appears on and what each is wired to (owner S425).
The bar it must reach with fresh critics: 6+ DEPTH and 6+ GENERAL DESIGN (owner S459). Numbers: say which are ESTIMATES.
Plain words; names only in headers. Return only the new map, starting with its title line.

> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups.


> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups and the eight MMA fighters. Written S403 from the code; update it when a mechanic or screen lands.

## What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with **To reach 10/10**: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.


> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups and the eight MMA fighters. Written S403 from the code; update it when a mechanic or screen lands.

## What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with **To reach 10/10**: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.


# FightCamp critic pack: the whole game, for judging whether a screen has the right options

Owner's rule: "i want every screen you design to have the right options so every critic needs to know the whole game design and mechanics to guide you".
This pack is facts only: no scores, no verdicts, no earlier critic comments, and nothing that is merely proposed. Written 2026-11-08 from the code
and the agreed plans. Where a document and the code disagree, the pack says what the code does.

How to read the status tags:
- BUILT = it is in the game now and a player can use it.
- AGREED, NOT BUILT = the owner approved it (or a plan he approved includes it) but the game does not do it yet. Judge a screen as if it will exist.
- PARTLY = some of it is in the game; the pack says which part.
- NOT ESTABLISHED = the pack could not confirm it from the code or the plans. Do not assume either way.
Names only in headers (owner S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"): a person's name sits in the screen's header once; options, buttons, rows, lines and tooltips say her / him / the opponent / your coach. Flag every name you see outside a header.
A screen should offer an option only if the player can act on it (rule in section 7). "Option" below means anything the player can press, drag, pick or type.

## 1. What the game is

- A boxing gym management game for PC (Godot 4.7, Windows). The player is the head coach and owner of one small boxing club. Not a promoter, not a fighter,
  not a tycoon. The club lives on members who pay monthly dues; a fighter's bouts add ticket cuts, reputation and new members.
- Scope for the first release: boxing and no-gi BJJ (the owner decided BJJ ships beside boxing). MMA comes in the first update after launch. Kickboxing and
  Muay Thai are not scheduled. Early Access is the target; no date.
- The player controls: whom to sign and which starting focus; the coaches and staff hired; the week of training for each fighter (mornings, pad and sparring
  evenings, diet); which bouts to take or ask for; the camp before a bout; the game plan written as lines; combinations built and drilled; the corner calls
  and corner minute on fight night; the fighter's next goal; the club's money (dues, spending, deals, upgrades).
- The player does NOT control: the punches thrown. The fight is settled by rules (exchanges of 30 seconds); the 3D fight only shows the settled round and
  never decides. The player also does not control fighters' moods directly, rival fighters, the weather/twist cards, injuries, or when offers arrive.
- The fun, in the owner's and the design's words: raising an unknown into a champion; the plan is the star; you can always see how your plan made the
  difference (the Why after every fight); every week costs something (training, weight, fatigue and money pull against each other); fighters are people
  (traits, habits, moods); fast and honest (anything one click from anywhere, true numbers). The three core mechanics beside the corner (owner S354):
  the morning sessions that add up to a goal and an intensity (the week), the evening move and combination planner, and a fight plan that is fun to design.
  The Playbook/Combos area is the part the owner calls really fun ("to try and also learn from the book").
- Design rule on results: the better-trained fighter usually wins; a good plan turns close fights and gives underdogs a real chance. Measured in tests:
  good plan about 59% of bouts, no plan 45%, bad plan 41% (one matchup). Training beats planning: 5 points better in stats wins about 72%, 10 points about 95%.
- Not mobile, not casual: no timers, gacha, daily rewards or ads. Real stats stay visible. Deeper, not wider (owner approved "build all proposed systems").
- Tone: a gym, warm and tactile, not a spreadsheet. Plain words, one word per concept, no flavour text.

## 2. A career from the first minute to the first pro fight

Time model: the clock runs day by day when the player presses the big CONTINUE button. It stops by itself every Monday (the week review) and for
anything that needs the player (a bout offer on its last day, weigh-in, fight night, injury choice, trial day, walk-in). Day 0 is Monday 5 January 2026.
The button says what it is stopping for ("to Thu 15 Jan, the offer expires"). Quiet week = one click.

1. Title screen: Resume career (if a save exists), New career, Quick start (a ready club, London), Load career, Settings, Credits, Quit.
2. New career, two steps. Step 1 YOU: your name and one of four head coaches on photo cards (Old hand, Ex-pro, Amateur coach, Strength coach), each with one
   edge. Step 2 YOUR CLUB: country, city, gym name, and one of three starts that double as difficulty: Fresh doors (normal), In debt with one good boxer (hard),
   Backed with big expectations (risky). A switch lets the player skip the first-hour guide. Quick start takes the first coach card and Fresh doors.
3. Day 0, Home: the first-hour card (the job: keep the doors open; the first show date; who you are), a walk-in fighter waiting at reception (Lucy Jackson in
   the standard start; other starts and the male-boxer start use other names). The guide strip runs three stages: FIRST WEEK (sign, coach, week, go),
   FIRST FIGHT (offer, prep, fight), THE CLUB (second boxer, bouts for both, set the first boxer's next goal). It can be skipped.
4. Sign the walk-in: an RPG-style card (class from style, potential in stars, each attribute's ceiling, two traits, one habit, a signature move, an
   ambition) and ONE starting focus. Hire an assistant coach (Luke Reid sessional $450 a week, or Marcus Hale full-time $1,090 a week; $1,000 signing fee).
   Without any coach, training runs at 60%. Open the Week and lock in week 1 (the coach has already written a week). Press CONTINUE.
5. Monday of week 2 (day 7): the first bout offer arrives, for the club show on Saturday of week 4 (day 26). Until the first bout is fought there is no twist
   card and no ask. She starts about 1.4 kg over the limit, so weight is the first real decision (a cut needs starting in week 1). Accept shows a poster
   reveal and offers the camp.
6. Fight prep: camp (focus, intensity, partner, film), game plan, weigh-in the day before, fight night, result, Why, goal talk. After the first bout: a second
   walk-in arrives the next Monday, a rival coach (Frank Doyle, Eastside ABC) is named in the news, three club tasks appear on the guide strip, and Ana (the
   no-gi athlete) is teased, then asks to join after the club's second bout or by week 9.
7. The loop afterwards: offers every couple of weeks (a club show every other Saturday from day 12), camps, nationals, money pressure, more fighters.
8. Amateur road: the National Amateur Championships. Entry needs 5 bouts and 3 months registered, age 19-40; entries close in week 10; a London regional then a
   national draw. While in it, no other offers come. A loss, injury or missed weight ends the run.
9. Turning pro: a promoter's offer arrives at 7 wins with a top-3 regional rank, or at 9 wins at any rank. The debut is 4 rounds, about 4 weeks after signing.
   The gym pays the licence ($230) and, the first time, medicals ($875) and the trainer's licence ($140). Stipend stops. After the debut a pro joins a world
   division table unranked and the promoter brings three offers per fight (see 4.12). Older docs said "the game ends near the first pro fights"; the code
   goes further (pro ladder, belts, ageing, retirement), see section 8.
10. The club failing: 8 weeks in a row below $0 closes the gym. A closed gym shows a summary that cannot be dismissed (New career / Load career / Title).

## 3. The fighter: three layers

Plan agreed by the owner (2026-11-08): a fighter has primary attributes (what the fighter IS, same in every sport), skills (how good at one sport) and moves
(a jab, a low kick, an armbar; each has its own level in the Playbook: New, Raw, Usable at 30, Sharp at 60, Signature at 85).

AGREED, NOT BUILT: the 10 primary attributes. Operator: "these 10 lookok"; one Speed for hands and feet (the game's Hand speed becomes Speed). Strength; Explosiveness; Speed;
Stamina; Recovery; Flexibility; Durability; Fight IQ; Composure; Heart. One Strength number for the whole body (no number per hand; left/right differ through
moves and stance). Merges: Chin and Toughness become Durability; boxing Conditioning and BJJ Cardio become Stamina. Power is not its own number (it comes from
Strength, Explosiveness and skill). Weight cut, height, reach and stance are written facts, not bars. "Marks easily" is a label for cuts, not a bar. Aggression is
a slider you set (Patient to Forward), not a bar. Technique and Defence become skills. Explosiveness and Recovery stay only if the fight really uses them.
AGREED, NOT BUILT: 12 skills (ops/research/S400_REVIEW/SKILLS_PROPOSAL_S404.md). Boxing 5: Accuracy, Timing, Defence, Footwork, Inside fighting. Kickboxing and Muay Thai 6: those + Clinch. No-gi BJJ 5: Takedowns, Guard, Top game, Submissions, Escapes. MMA 12 in three groups. The profile design (one body and mind for every sport; only skills swap; a sport switch appears only once the
fighter trains both; crossing over costs training time) is agreed in shape; the mockup number lists (24 numbers, 25 for a boxer) predate the 10-attribute list.

BUILT today (what screens show):
- Boxing: 7 trained stats: Power, Hand speed, Technique, Defence, Conditioning, Ring IQ (fight IQ), Chin; plus Footwork (derived from speed and defence) and
  the personality values Heart, Discipline, Confidence, Coachability, Temper (Loyalty exists but is not on the board). Amateur women's lightweights sit 55-65;
  bands: weak under 45, fair under 55, solid under 65, strong under 75, elite above. Each stat has a potential ceiling ("tick") and a weekly delta.
- Moves with mastery (0-100): Jab, Cross, Lead hook, Body hook, Uppercut, Check hook; from 30 a move is a "weapon" the fight can use. Combinations (the
  book: 1-1, 1-2, 1-1-2, 2-3, 1-2-3, 1-2-3-2, 3b-3, 1-2-3b, 1-6-3, slip 2-3) unlock when their moves are weapons; players can also build their own.
- Body: weight vs class limit, condition (fatigue word), injuries. Style word (Out-boxer, Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher,
  Slugger). Stance. Age. Record. Rank in the region.
- Personality and habits, learned not shown as numbers in the ring: 6 traits (heart, temper, confidence, discipline, coachability, loyalty) and habits
  (for example drops the right after the jab, slow starter, fades late, chases stoppage). A coach's-notes card fills in with words from fights and sparring.
- Morale (stored 0-100): Fired up (75+), Steady (50+), Flat (30+), Low. Moves: win +8, loss -12, goal met/missed, rest week +4, a month without a fight -6,
  bout booked +5, wrong corner call -2, right call +1. Morale is also trust in the corner: Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7 of the corner's
  word taken in; a Low fighter stops listening.
- BJJ athletes have 6 stats (strength, cardio, flexibility, explosiveness, composure, aggression) and mastery per move; belts, not ranks.
- Perks (the perk road): open for good when attributes reach a need, each changes one thing in a bout: Iron chin (Chin 70), Stiff jab (Technique 65),
  Second wind (Conditioning 70), Ring general (Ring IQ 65, corner calls work 25% better), Counter sense (Defence 65 + Check hook weapon), Body snatcher (Body
  hook weapon), Finisher (Power 70), Fast hands (Hand speed 70).

## 4. Every mechanic

### 4.1 The week and training plan - BUILT
- Choice: for each fighter a week of seven mornings (a session each: roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow, neck work, or rest;
  each at Light, Normal or Hard) and seven evenings (Pads, Sparring, Rest, Film). The coach writes the week from the camp phase and repeats it; the player edits
  exceptions (click a day, a popover). "Back to the coach's week" resets. Diet: Hold or Cut 500 kcal a day.
- Phases counted back from a booked bout: BASE (no bout), BUILD (3+ weeks out), PEAK (2 weeks out, hardest, sparring twice), TAPER (fight week: light, three rest
  days, no sparring).
- Changes: each morning adds a small amount to one stat (pace 1.0 per focused week x coach factor x headroom clamp((potential-stat)/25, 0.10, 1.25), a morning
  is a fifth of it, Light x0.6, Hard x1.3, less when tired); kcal and weight; fatigue (0-100, "Week tiredness"; from 80 she is overreached: gains x0.6 and
  injury risk x3). The Week tab shows plan totals, the goal line, the coach's one change with a "Do it" button, and the weeks to fight night.
- Coach factor: 0.5 + rating x 0.7 per cent; no coach = 60%. Strength coach head-coach edge: body mornings +10%, craft mornings -10%.
- Twist card: once a week the coach draws one (sore wrist, rain, weights room shut, partner ill, head cold, visiting pro, quiet week; or a choice card such as
  tight knee, scale will not move, night off, heating breaks, combo clicking, southpaw in town, old coach visits, sponsor photoshoot, rival talks trash). Two
  answers each with a visible price; unanswered = the coach's pick on Monday. Planned vs actual is shown on the review.
- Training load: acute vs usual load; a spike (ratio 1.5+) raises injury risk 2-4x.
- Two fighters in camp competing for the coach's pad nights: AGREED, NOT BUILT (see 4.2).

### 4.2 Pads, combinations and mastery - BUILT (pad nights for two fighters AGREED, NOT BUILT)
- Evenings are nights that carry drill cards. A pad night is 75 minutes split over its cards; a sparring night gives every card already in her hands a share.
  Standard week: 3 pad nights; camp 2+1 / 2+2 / 3+2 pad+spar for Light/Standard/Hard.
- Choice: drag a drill card (a move or combination) onto a pad night; split a night 50/50, 70/30, 30/70; remove or clear; pin cards in the tray; "+ drill it".
- Mastery gain per hour of drilling: pads 2.1, heavy bag 1.05, shadow 0.85, sparring 1.5, speed bag 0.9, double-end bag 1.2. Undrilled moves fade slowly.
  A drilled combination also holds its punches. Tiers: New, Raw (under 30), Usable (30), Sharp (60), Signature (85). A move at 30+ is a weapon.
  Today a planned line fires every time once it is usable; sharp is worth about 1 win in 100 over usable. In the game but SWITCHED OFF (S427,
  measured on 400 bouts a cell): a planned line fires 1 use in 2 at usable, 3 in 4 at sharp, always at Signature (sharp then +2.8 wins in 100
  over usable, Signature +2.7 over sharp). BUILT for professional bouts (S458-S462, `ProRead`): the opponent's corner studies your boxer's
  last two professional fights and waits for the punch thrown most; two real weapons or a feint line blunt it. Amateur bouts: not read across bouts.
- A combination in a fight costs energy (longer costs more); a flurry is limited by hand speed and tiredness; a signature (drilling, not length) may run one
  punch past the speed cap. Own combinations built in the Playbook (Combos tab) get their own pad mastery.
- AGREED, NOT BUILT: with two fighters in camp the coach's pad nights are shared; the top row of "Learn on the pads" shows how many go to each (cost to the
  other fighter), only while two are in camp; a needs flag says when the second camp starts.

### 4.3 Fight camp - BUILT
- Opened by "Set camp" (a need once a bout is 3+ weeks off, or from Fight prep). Choices: camp focus (one of Conditioning, Power, Technique, Defence, Speed);
  intensity Light / Standard / Hard (3, 4, 5 nights; focus multiplier 1.1/1.2/1.35; fight-night edge +0.25/+0.6/+1.0; all free); Partner: club mates (free) or an
  outside mate of the opponent's stance or style ($160); Film (tape study, free).
- Changes: the camp stat gets a forecast to fight night; scale forecast; tape study opens one tell on the opponent's file every few camp days (weapon first,
  weakness last). A camp whose three lines are all met on fight night (made weight, stat on target, never overreached) gives PEAK CAMP: +bonus to every stat for
  that fight. A southpaw partner removes a round-1 penalty for an orthodox boxer who never faced one.

### 4.4 Weight - BUILT
- Each fighter has a class limit (women's 57/60/65/75 kg, men's 57.5/60/70/75 kg). Weigh-in is the day before. Diet Hold/Cut and training burn move weight;
  the bout page and Fight prep forecast "now / on the day". Missing weight calls the bout off and the club pays $300 for the empty slot. A boxer over his
  class can get a bout he can make (a later date). The Old hand head coach makes cuts easier (120 kcal a day more).

### 4.5 Booking and matchmaking - PARTLY
- Amateurs BUILT: offers arrive (a club show every other Saturday; one offer at a time per fighter, answer by a date, usually 8-12 weeks lead at clubs, 2-4
  weeks in the first hour). Each offer: Accept or Pass, both free. An unsafe mismatch (a novice, 0-10 bouts, against an open fighter) cannot be accepted. Win chance
  shown as a band that widens when unscouted. No way to ask for a named amateur opponent: AGREED; rules built (scripts/rules/AskBout.gd), panel not built (Ask for a fight: a "no" is a closed panel or an absent answer with its reason, never a random refusal).
- Pros BUILT (after the debut, on Fights): the promoter brings three offers per fight (TUNE-UP likely, STEP UP about even, PAYDAY long shot) standing 7 days; OR the
  player asks for a named boxer within the promoter's band (about 5 places above, unranked reach 15; a top-5 name needs 3 fans); Scout costs $250 and opens the
  opponent's weapon and weakness and narrows the chance range. A promoter refuses if you duck the step up twice. Each row shows chance, what a win gives (place,
  fans), what a loss costs, stoppage risk, pay (gym's 25% of the purse), and the gap to the next fight (quick, normal, hard night).
- Rank rule: beat someone above you and take their place; beat someone below and nothing moves; a losing record is never ranked in the top 10. Purse: $1,500 unranked
  + $400 per place; tickets follow fans and how close the fight looks. Pro rounds: 4 unranked, 6 ranked, 8 top 10, 10 for a title.

### 4.6 Scouting and the opponent's file - BUILT
- Free at booking: record, look, style word. Hidden until found: best weapon, each habit, weakness. Amateur: tape study in camp opens one a session. Pro: scout
  for $250; the weapon is public tape. A found tell names its answer (a plan situation, a corner call or a drill). The Ex-pro head coach opens one tell the day
  a bout is booked. An opponent with no bouts has no tape. The Tape Room (Fight prep, "Watch the tape") plays 3-4 films of her past bouts, SPOT the tell, then
  YOUR ANSWER picks a move that becomes a plan line.

### 4.7 The game plan (Playbook) - BUILT
- A plan is lines: "At long range -> One-two", "When she presses -> Step back" (places: outside, long, mid, inside, clinch, ropes; situations: she presses, boxes at range,
  waits to counter, loads up, tires). Each answer is rated vs the opponent's game: Beats it / Works / Walks into it, and its edge over improvising, times her pad
  time. Rate against another kind of opponent; round-by-round pace Push/Steady/Save; a go-to combination. The coach's skill sets how many lines (a plan holds
  4-6). Real fight plans can be loaded; See the flow; Open the map. With no plan written the assistant coach writes one (poor to about half of a read plan).
- A plan the fighter has not drilled works less well; a wrong answer costs. During a bout: planned right answers that win exchanges build PRESSURE on the opponent
  (cuts her output); planned wrong answers she is punished for shrink her energy ceiling.
- BUILT (`PlanRead`): inside a round the opponent adjusts - a planned line pays in full for its first 2 uses in that round, then less each use; it resets
  at the bell. AGREED, NOT BUILT: their note replaces the coach's line in the corner minute naming the line that stopped working.

### 4.8 Fight night - BUILT
- A bout is 3 rounds of 3 minutes (amateur), 4 (pro debut), more later. A round is six 30-second exchanges, each settled by dice on an edge (training, plan, corner call,
  pressure, tiredness). The opponent fights one way at a time (Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt), shown as a clue.
- Every 30 seconds the player may shout one of the 3 calls that fit, or say nothing: Jab and move, Go to the body, Draw the lead, Hands up move your head, Let your
  hands go, Breathe pick your shots, Tie up, Go for the finish. Each has a best / ok / wrong match to the opponent's mode, needs stats, costs or gives energy; only
  two instructions per minute get through fully. Pace (Push / Steady / Save) and Aim (Own game / Head / Body / ribs / the hurt head) persist from shout to shout.
  A set-up "NOW!" fires a learned combination into a gap the opponent opens: big edge, or a cost if wrong.
- Corner minute between rounds: the corner card (what worked, what hurt, the call), the plan call, ONE CHANGE for the next round (a habit fix, or Elbows in: half the body punches go to the head, saving their energy and adding head damage, or Gloves high: the reverse; moved punches change where she is hit and what it costs, measured not to change who wins), RECOVER with 3 points (water, ice on the ribs, clear
  her head when hurt), SET-UP (a combination x a gap), TALK (calm / fire up / the truth), change one plan arrow, cutman job (close the cut, enswell an eye, nothing).
  Trust: a wrong call she followed costs trust; a Low fighter ignores shouting.
- Knockdowns and counts come from power and damage vs chin, heart for the count; amateur RSC at 3 counts in a round or 4 in a bout. Injury roll after the bout.
- Result: scorecards (3 judges), win on points / stoppage / draw, "what decided it", the Why, a body report (which part went first, with a "Train X next week"
  button), "The plan, lit up" flow, then Back home and the goal talk. Watch modes: with a picture the 3D fight plays (1x/2x, Skip round, Skip bout); headless runs
  stay in words. "Sim to result" skips the fight. Highlights/full modes in design notes: NOT ESTABLISHED as options in the UI.
- AGREED, NOT BUILT: a cutman card for a closing eye, "stop it (she loses, the eye is safe) or go on (risk of a lasting cut)", behind a divider, never a pop-up,
  never pre-selected, not using one of the two fixes (the 3D corner has a cutman job row today; whether its stop-or-go choice exists is NOT ESTABLISHED).

### 4.9 The Why - BUILT (the hook)
- After a bout, plain lines: YOUR PLAN (graded against having no plan: right answers, wrong answers, neutral, worth about +X% chance), AGAINST YOU (what the opponent's
  habits cost), NEXT (what to train or write). Graded by how each planned move answered what the opponent was doing, not by the dice; "swing" counts replay the
  dice without the plan's edge. A readable reason for every random swing (R11): AGREED, NOT BUILT as a general feature; it lives on existing rows.

### 4.10 Damage, injuries, suspension - BUILT
- Six body places per boxer take punches (head, ribs, etc.); bands fine over 55, hurt 55, critical 35, doctor 15. Bout injury roll from settled damage (about 6% a
  3x3 bout; 72% head/neck, 20% cuts); training injury about 1.3% a week, more when overreached. Stoppage loss = 30-day suspension, longer for repeats. While out: no
  offers, a quarter of gains. A fighter hurt before a bout: choice "pull out" (club pays the empty slot) or "fight hurt" (less energy: minor 10, moderate 15, serious 20).
  A damage ledger and fights-left forecast exist for pros in the world model.

### 4.11 Morale, trust, goals - BUILT
- Goals with deadlines (for example Debut inside a month, Next bout inside a month, Southpaw answer, Five-round engine), set in the office after each bout (Goal talk:
  pick one of the offered goals). Status ON TRACK / AT RISK / OFF TRACK / MET / MISSED; ~70% clearable by design; meeting or missing moves morale. "Her asks" can be
  heard or overruled (morale +5 / -5). The ambition shown on the signing card does not yet change anything (the design says a kept goal should build loyalty, a broken one may make a fighter leave: AGREED, NOT BUILT). Overruling a low-coachability fighter hurts more.

### 4.12 Staff - PARTLY
- Head coach (you): one of four edges: Old hand (cuts easier), Ex-pro (one tell on file when a bout is booked), Amateur coach (a prospect's exact potential), Strength
  coach (+10% body mornings, -10% craft mornings). Assistants: Luke Reid and Marcus Hale (above); training quality, plan lines taught (more with better rating), evening
  classes +$350 a week. Staff jobs on the Club page (each changes one number): Second club coach 10 h ($280 a week: +1 roster place, +40 members, runs fitness classes);
  Strength and conditioning ($100: training injury risk -15%, a pro camp's bill halved); Physio ($75: injuries back a quarter sooner); Cutman ($150 a pro night: half
  the post-bout layoffs). Letting a staff member go costs a week's pay. Letting the main assistant coach go: NOT ESTABLISHED (Let go exists on the staff jobs).
- "Coach runs it / I run it" per fighter: AGREED, NOT BUILT (the Roster has no such column).

### 4.13 Money and the gym - BUILT
- The week review gives one short reason beside any change in members (word getting round, gym full, less room, dues too steep, more than the gym's name can hold).
- Income each week: members' dues ($35 a month each standard; bands Cheap $25 / Standard $35 / Premium $45 change who joins), evening classes (+$350 with a coach), no-gi
  dues, sponsors, fitness classes, juniors' dues. Costs: rent $1,800 a month (bigger premises more), England-Boxing-style fees ($315 club + $18 a boxer + $35 a coach a year),
  coach, fighter stipends ($250 a week, optional), heating and power by season, insurance $1,250 a year, staff, kit budget (Low $0 / Standard $45 / Good $80 a week),
  upgrades' upkeep. Wages and upkeep are billed every 28 days. Start cash = 1 / 3 / 6 months of costs by start. Runway under 8 weeks warns; below $0 is red; 8 weeks in a
  row below $0 closes the gym. A loan ($180 a week for 26 weeks) comes with the debt start; the backed start loses $5,000 if the first show is lost. An overdraft rule
  exists (offered after 12 weeks of trading, 16% a year) but NOT ESTABLISHED as having a screen.
- One-offs: a bout adds a $450 ticket cut; camps cost a partner fee when used; repairs; a club show you host ($3,500, tickets $25, up to 400 seats, every 16 weeks, can lose
  money); a club grant bid once a year (answer in 42 days, needs a second coach, odds follow reputation).
- Spending choices on the Money page: Premises (Unit 70 members/3 places, $1,800 rent; Bigger unit 140/5, $3,400, $12,000 to move; Club building 250/7, $5,500, $25,000);
  Upgrades (matted floor $2,400; strength corner $3,600; fitness class kit $1,500; youth section $1,800), each bought once, works after a week, one visible effect; Sponsors
  (Ironclad $250/week from the start; Bow Road Physio $150 after the first win; bigger sponsors later); dues band; kit budget; evening coaches; pro stipends and contract talks.
- Members: walk toward a target set by reputation, dues band, premises and coaches (at most 6 a week). A win adds +8 members and +5 reputation; a loss removes 1 and 2 reputation;
  a stoppage loss 2 and 4. Facilities (floor, ring, bags, lockers, office) can be repaired once ($120 bags) for +2 reputation.
- A pro's share to the gym starts at 25% (manager 15% + trainer 10%); contract talks at the first top-10 and the first belt (keep 25% for a bonus or drop the share), then yearly.

### 4.14 Rankings, titles, the world - PARTLY
- Amateur regional table (the region's club-show boxers; a player's fighter enters at 4 wins); rankings move as rivals fight each other at shows; news lines. Nationals and the
  regional bracket (BUILT). World pro tables for four divisions (women's and men's lightweight and welterweight, about 20 ranked each): boxers age, peak, decline and retire
  (damage ledger and age), new ones arrive yearly, belts at four levels (area, national, continental, world) with mandatory challengers and vacated belts, rivals improve (BUILT in the
  rules; its screens are on Fights, not World). An open-ended career, year review, three club goals a year, club tiers, a record book of champions and rivalries,
  a named rival gym that poaches and rematches, promises/poaching at contract time, a career clock with retirement talk, youth-section home-grown prospects, a commentary line
  and a press card are AGREED (owner "all of them", Q-S294-120) and mostly NOT BUILT; Records (the gym's own history log with filters) and the youth section exist.

### 4.15 BJJ (no-gi) - BUILT
- Athletes (Ana Ribeiro) are on the mat, not in the ring: belts white, blue, purple, brown, black with 4 stripes each (IBJJF floor: blue needs 2 years, purple 1.5, brown 1; minimum
  ages 16/16/18/19). The week is 3 classes; a class drills the syllabus move she is closest to owning (+3.2 a week; owned at 30, signature 50). Choices: drill a move; stripe call
  (now / hold / early) with morale and loyalty costs; promote; enter opens (no-gi tournaments every 35 days, 8-person brackets); fight an open yourself (the player calls the moves on the move
  graph) or simulate it; who teaches (hired coach or the athlete). No ranking table: the belt is the ladder. 5-10 minute matches by belt; points: takedown 2, sweep 2, pass 3, knee on belly 2,
  mount 4, back 4. A BJJ athlete costs a roster place and a no-gi coach by the class.
- The match runs on two-sided beats of about 11 seconds (S405): each side either acts on its pick or works its grips, and a holding lead can draw the referee's 20-second stall count.
  Measured over 1,000 bouts: white belts finish about 34% of matches, the first to score keeps the bout about 80% of the time, and a one-belt gap wins about 74%.

### 4.16 Perks - BUILT (listed in section 3).

## 5. Every screen in the game today

### 5.0 The shell (on every game screen)
- Top bar, left to right: Back (<) and Forward (>) arrows (greyed when none); gym name; date and week (hover card); red/amber flags (not on Home): GYM CLOSED, BELOW $0, LOW CASH,
  APPLICANT, TRIAL, PRO OFFER, SET CAMP, WEEK REVIEW, WEIGH-IN, NEW GOAL (each opens its thing); cash with "running +/- $N a week" (hover card); the big button; Menu.
- The big button: CONTINUE ("to <date>, <reason>"), RUNNING (click to pause), NEEDS YOU (n) (opens the first red need), or GO TO FIGHT NIGHT. Space also presses it.
- Menu: Mail (opens World News; shows a new count), Save, Load, Settings, Handbook, Quit to title.
- Left rail: Home, Fighters, Fights (badge = open offers), Club, World; the club crest (hover: name, members). Keys 1-5 reach the rail (design note: NOT ESTABLISHED in code).
- A guide strip (first-hour guide only): the current stage's steps, what to do and why, a button for the next step, and Skip the guide.
- Settings: text size (Small/Medium/Large/Largest), window (Windowed/Full screen), days run at (Normal/Fast/Fastest), four sound sliders (all, punches/ring, crowd, music),
  Autosave (every Monday, last weeks kept / Off). Handbook: search and group filter (All, Words, The club, The week, The plan, Fight night, Money) with links to areas. Credits.

### 5.1 Title; 5.2 Create (see section 2). Create buttons: Back to title, Next: your club, Back, Open the gym; picks for coach, country, city, gym name, start.

### 5.3 Home (no tabs) - BUILT
- Notice board of needs as pinned notes, each with a button: Meet the walk-in; Answer a bout offer (Open); Weigh in; Set camp; Hire a coach (Staff); money warning (Money);
  a sponsor waiting (Deals); Enter for the nationals (Nationals); Week N review ready (Open); New goal waiting (Talk); Trial today (Watch the trial); Pro offer (Hear it);
  Hurt before the bout (Decide); competes today (Go to the mats); The gym has closed (See the summary). Red = stops the clock; amber should come next; steel can wait.
- First-hour card until the first bout (the job, show date and countdown, you). The next fight as a matchup card (button: Go to fight night, or the next step).
- YOUR FIGHTERS table: fighter (name opens the page), record, rank, next fight, weight, freshness, this week's plan. Right column: SINCE LAST MONDAY (each fighter's biggest gain
  with its cause, injuries, rank moves, new members; "All news and mail"), THE CLUB THIS WEEK (money in, costs, members, coach), COMING UP (bouts, weigh-ins, championship dates, bills).

### 5.4 Fighters > Roster - BUILT
- A sortable table (columns: fighter, record, rank, The Road, and more) with flag chips per fighter that open the thing that needs her; a card per no-gi athlete with belt,
  stripes, classes, "<name>'s mat: Playbook"; buttons: Meet the walk-in, Open training, Set camp (locked with a reason when it cannot start), See offers.
- Fighters > Find a fighter: PROSPECTS NEAR <city> as face cards with scouted ranges for four stats (a range until the trial; the Amateur coach edge shows exact potential),
  button Invite to a trial (free; she comes in on the Monday; signing costs the stipend). States: trial date, signed, passed. The reception walk-in is separate.

### 5.5 Fighter page (tabs: Overview, Week, Fight prep (only with a bout or camp), Playbook, History)
- Header: portrait, name, weight class, age, stance, record, goal chip ("Goal, N days: still needs X - at risk").
- Overview: NEXT STEP (the road: next step and what it needs; Enter for the nationals; the whole road on hover); attribute board (radar of eight against potential plus all values with weekly
  delta, hover says what each does in a fight); BODY (weight of limit, condition, injury), COACH SAYS, COACH'S NOTES n of m; GOAL (title, days left, meter, status, quote;
  Talk to <name> when a goal talk is waiting), NEXT BOUT; buttons Plan the week, Fight plan (n arrows), Find a bout; perk road; moves with mastery bars (hover plays the move); combos
  learned (gold = thrown in fights); contract text ("club stipend $250 a week, until turning pro") and goals so far.
- Week: head (NEXT/THIS WEEK dates, tiredness), PLAN TOTALS, seven columns of morning and evening cards (click opens a popover: Light | Normal | Hard and sessions; Rest | Pads | Sparring
  and the drill cards), goal line, the coach's one change with a Do it button, Back to the coach's week, the twist card (choose an answer), LEARN ON THE PADS tray (drag a card to an
  evening), THIS CAMP (diet pills Hold / Cut 500 kcal) only with a bout booked, a skills road below.
- Fight prep: VS <opponent> (club, record, game), days to fight night and weigh-in, ONE primary button that moves with the state (Set the camp / Write the game plan before sparring /
  Watch the tape / Step on the scale / Check the week), the tale of the tape with the win chance and how sure it is, WHAT YOUR PLAN SHOULD ANSWER (each found trait with its answer and
  "Write it"; hidden ones say what opens them), CAMP AND WEIGHT (scale margin, the camp stat's line to fight night, Change the week).
- Playbook (boxer): tabs Moves (move book by place in the ring; Watch/Steps, Drill, Replay, Slow motion), Game plan (see 4.7: Write a line / Change / Clear this line, Answer: <best>,
  Rate against, Load a real plan, Test it (limited tries), See the flow, Open the map, Build plan in the move browser), Combos (build a chain from "+ move" buttons, Play it, Clear, Save to the
  book, Drill it on the pads, Watch on the pads, chain hit rates vs opponent types), Escapes (folded into Moves in the agreed menu). A body plays each move on the right.
- History: every bout she fought (and brought) with result, opponent, cards and why; milestones.
- No-gi athlete page: one Record view: THE ROAD TO BLACK BELT (five belts with stripes), TO <NEXT> BELT (mat time, moves owned, syllabus), COACH'S CALL (give the stripe, Promote to <belt>, next opens
  with Enter, who teaches), RECORD in opens; her Playbook is a mat book (moves by group, Systems, Drill, Undo, a game tree with FELT and links).

### 5.6 Fights (no tabs) - BUILT
- Amateur: OFFERS ON THE TABLE (a card per offer: opponent face, record, win band, chips; Open) with each fighter's STANDING beside it (booked or free, next on the road, Enter for the
  nationals); when none, the line says when the next offer can come. For a pro: a strip, NEXT FIGHT table (offers, asks: Take this fight / Book <name> / Scout ($250)) and THE ROAD (champions and
  places around her). No-gi opens card with Enter. Fixtures list (calendar), RESULTS (who beat whom, cards, why).
- Bout page (an offer): head chips (Legal, even match / Weight at risk / Not safe), tale of the tape, stats vs the estimate, win band and ranks at stake, SCOUTING file (locked lines say what
  tape study opens), TERMS (date, 3 x 3 minutes, weight, on the scale now/on the day, time for a camp, purse none, club ticket cut $450, answer by). Buttons: Accept the bout (disabled with a
  reason when unsafe or answered), Pass. Accept plays the poster reveal and offers Set the camp / Later.

### 5.7 Club (tabs: People, Money, Records) - BUILT
- People: STAFF (you as head coach with your edge; the assistant card with training quality, plan lines, cost, net weekly; two hire cards when none: Hire Luke / Hire Marcus; no-gi coach line;
  STAFF JOBS with Hire / Let go), MEMBERS (on the books and drift, reputation word, dues band).
- Money: CASH WEEK BY WEEK chart; NOW (cash, weekly in, costs, net, month's bill, runway line, break-even members); WHERE IT COMES FROM / WHERE IT GOES bars; STIPENDS (Pay/Stop the stipend);
  CONTRACT TALKS (Keep 25%: pay a bonus / Drop to a lower share); PREMISES (Move); UPGRADES (Buy); KIT BUDGET (Low/Standard/Good); evening coaches (Hire one / Let one go); CLUB GRANT (Bid for a grant);
  CLUB SHOW (Book the show); ONE-OFFS IN and PAID OUT (last 8 weeks); DEALS (Sign a sponsor); FACILITIES (Repair); dues bands buttons.
- Records: the gym's own history, newest first, with filters (who: everyone / each fighter / coach / gym; what: bouts, honours, people...).

### 5.8 World (tabs: News, Rankings, Championships) - BUILT
- News: AROUND THE REGION (other clubs' bouts, names are links) and fixtures/events. Rankings: a table per division the gym has a fighter in (rank, fighter, gym, record, style, last bout; click a name for the rival file; a
  fighter enters at 4 wins; no-gi says the belt is the ladder). Championships: the road to the nationals per amateur (rings for what she still needs, Enter, the London regional and national draw brackets, titles).
- Rival file (modal): record, style and the tells found so far; locked lines say what tape study unlocks.

### 5.9 Modals (open on a press or when the clock stops on them; nothing else opens by itself)
- Interview/Trial (walk-in, prospect): the fighter as an RPG recruit, one starting focus (Sharpen the signature +10 mastery, Fix the habit gone in 4 weeks, Raise the ceiling +5 potential), Sign or Pass.
- Pro offer: the debut money picture (tickets she sells, her share, what the gym pays now, what ends); buttons Turn <name> pro / Stay amateur.
- Goal talk: pick one of the goals offered, Set goal or Later.
- Camp: see 4.3; buttons Later / Start (shows the cost).
- Weigh-in: Step on the scale (made or missed). Injury choice: pull out or fight hurt.
- Fight night: tale of the tape (Begin fight, Sim to result); rounds with shout bar, Sim the round; corner minute (call buttons, fixes, jobs, Say nothing / No fix); To the scorecards / To the result;
  result with Train X next week, The plan lit up, Back home.
- Week review (per fighter): bars fill to the next whole point, moves drilled, new weapon, rank change, planned vs actual, pads cards turning over, money, the coach's word; rows land one at a time with the biggest
  surprise last; the only button is Next week. Open night (BJJ): Simulate this bout or Fight it, Back to the gym. Closed gym summary. Info boxes (Settings, Handbook, Credits).

## 6. The seven approved menus, and the agreed structure of all menus

Owner, Q-S294-127: "Yes, build the seven": Home, Fighter Week, Boxing profile, Playbook, Fight night, Money, World. A shared warm-wall kit (WarmKit: wall, whiteboard, paper, sticky, magnet, chalkboard, marker
ledge) is built first so screens cannot drift. None of the seven is rebuilt in the kit yet; the screens in section 5 are the current ones. Agreed structure: five rail buttons (Home, Fighters, Fights, Club, World); one
home per job; no mailbox (Mail opens World News and the Monday page replaces the week-review pop-up); nothing opens by itself; time is one big button saying what it stops for; one booked fight runs in a straight line
(Home countdown, camp, weigh-in, tape, fight night, the Why).

- Home (agreed): needs first, the job, the next fight, one row per fighter, Since last Monday with causes, the club's week, what is coming; the week review folds in as a need that "sits here, never pops up"; the line
  under the big button names the next stop; the first-week guide card only in the first hour.
- Fighter Week (agreed): the whiteboard: sessions as magnets, the fight date circled, colour only means risk, one red button moves the week on; plan totals, fatigue, the goal line, the coach's one change with the effect on the
  button; Learn on the pads; ADD "Coach's pad nights" as the top row, two fighters in camp only, with the cost to the other fighter (R55).
- Boxing profile (agreed in shape; numbers superseded by the 10 attributes in section 3): tabs Overview, Week, Playbook, History on one portrait header; three columns Body, Skills, Mind with a style line ("Keeps it
  long"), one thing to work on and where it is trained; the sport switch only once she trains both; a rival gym's offer with its three answers (match it, promise something, let her go) as the top card when it
  comes (R58, needs the running world).
- Playbook (agreed): Moves (Escapes folded in), Game plan (lines drawn on a board, plays a default at once, rate against each kind of opponent), Combos; "No bout booked: try the plan against each kind of opponent".
- Fight night (agreed): dark and tight, handwritten coach notes, three fixes / time for two; stats cut to three rows in the minute; the "she has adapted" note (14 words at most) replaces the coach's note (R25); a
  cutman card only when an eye is closing (R28); the result with scorecards and the Why (plan, against you, next); the money lines move from the Why to Home; no "one change for next time" (the Why's NEXT carries it).
- Money (agreed): the gym's books on the whiteboard: cash, runway, in and out, bills, deals, repairs, upgrades; dues bands wait for the owner's call on the cut.
- World (agreed): News cut to only what touches you; Rankings with rivals that develop (movement arrows, Developing column); Championships; fixtures; no-gi "belt is the ladder".
- Other menus in the agreed map (not in the seven; final text per MENU_STRUCTURE_S402): Start (three starts, already in game); First week; Fighters (a real roster); Fights (Ask for a fight sits under
  the offers: level, date window, an answer with its reason; it waits for the bot test that a smart ask beats a plain one, R37); Fight prep ("What your plan should answer", no injury-risk lines on camp
  choices); Club > People (staff cards keep their faces; members panel cut); Grow (finding and signing only plus the pro offer; no prospect deadlines); Top bar (no change).
- Held back, do not build from an old mockup: one change after the Why, camp injury risk, scorecards after each round, members panel, prospect deadlines, sponsor line and per-fighter costs, the progress chart on History.
- Conditional elements and when each appears: Coach's pad nights (two fighters in camp, until a camp ends); Needs flag for the second camp (the second camp starts, until she opens the Week); Cutman card (an eye reaches
  the closing state at the bell); Adapted note (from round 2, when the opponent has answered one of your lines); Rival offer (the running world sends one; a flag only, answered or past its date); Ask for a fight
  (always, once a boxer is signed); Swing reason (a random roll moved a number you can see, scrolls off with the week).

## 7. The owner's standing rulings on screens (quoted or near-verbatim)

- Only actionable information: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Cut it, hover it, or put the action on it.
- One top bar and modals; nothing opens by itself; moments come as flags on the top bar. A week review sits as a need on Home.
- No flavour text; plain words; one word per concept (Raw, Usable, Sharp, Signature everywhere). Hover explains every number.
- Not mobile: "thats not how sim/manager games look , its very simplestic no actual stats to make the player understand how good the fighter is". Real stats stay. Not an 80s spreadsheet; no placeholders.
- Do NOT judge against a generic management sim ("they seems like economic management simulator"). Judge fit to this game and its plan.
- Look B, the gym whiteboard: marker notes, polaroid, needs as sticky notes, the cash tin, the fight date circled; warm tan plaster wall, wood and aluminium frames, cream paper. ONE art style across menus
  ("no art consistency" was his complaint). Stylized comic portraits in menus are on and must match the fighter. Marker fonts Permanent Marker and Kalam.
- Screens come only from agreed mockups; nothing is built on a menu he has not OK'd. A generic Money page was reverted.
- Fight night goes dark and tight (the Miro "Corner minute"); the coach's notes stay handwritten.
- Everything new ships switched ON. Hover cards on top-bar date and cash. Animated meters (every bar tweens).
- Weekly job pages must not become a pop-up. One-click reach from anywhere. Two Point alignment is parked (the gym floor is out of the first release).
- No gym still with the Day Plan or a drawer open; stills of fights show both fighters head to feet; boxers wear boots (visual rules for pictures).
- Scouting means opponents; finding fighters is "Find a fighter". The facility is a "gym"; a fight camp is only pre-bout preparation. Fighters are fictional; organisations real-named only where legal.

## 8. Where the documents and the code differ, and what could not be established

Code wins. For the critic: do not judge a screen against these older statements.
- Autosave, Settings and Handbook: docs say "not built"; they are built (autosave every Monday).
- Pros have no offers/world after the debut (docs): the code has a pro ladder, promoter offers, asking, scouting, belts, ageing and retirement.
- Ask for a fight: docs say impossible; it exists for pros only. Amateurs cannot ask.
- Gym closes after 4 weeks below $0 (CLAUDE.md numbers) vs 8 weeks in code. Gym's share of a pro purse 35% (CLAUDE.md) vs 25% in code. A loss costs 3 members and 2 reputation (CLAUDE.md) vs 1 and 2 in code (stoppage 2 and 4).
- Ex-pro head-coach edge: design says one extra corner call; code gives one opponent tell on file at booking. Old hand: design "cheaper camps"; code: easier weight cuts.
- Roster limit "up to 8": code gives 3 places, +2 per premises tier, +1 per second coach (5 and 7 at the larger premises).
- Four rail buttons plus Playbook: the Playbook is reached from the fighter page, not the rail. Docs on Fights tabs are out of date (one page).
- "Coach runs it", year review and club goals, club tiers, rival gym, poaching, career clock: not in code. Overdraft has rules but no screen found. Keys 1-5 for the rail and highlights/full watch options: not found.
- NOT ESTABLISHED: the exact number of moves in the Playbook; whether the 3D corner's cutman choice offers "stop it / go on"; whether the week review ever opens without a press (the owner listed it as a defect on 2026-11-08);
  the owner's answer on an open-ended career and a roster of 8; whether R11 (readable reason for every swing) exists beyond the Why; crossover numbers between boxing and BJJ (left blank on purpose).

## Added S409
The building: chosen once at new career, one of four gym plans, each with one small permanent edge (5% more members, 5% more show income, 3% better power and technique training, or injured boxers back 10% sooner).
The gym on Home has people in it: the club's fighters and members, working at equipment and walking the floor. More members, more people (2 to 12). Decoration only: they take no clicks.

## Added S410
- The shell's top bar is dark on every game screen (5.0).
- Fighters > Roster (5.4) is now full-body cards on a painted gym: weight class and rank, a corner flag for the most urgent answer (Set camp, Offer, Weight, Mood low), Condition / Mood / Weight tiles, the next fight and days to it; a click opens the fighter's page. Under them, Scouted for you: up to four prospects, with Invite to a trial. A Cards / Table switch keeps the sortable table (Rank, The Road, Goal).
- Fights > a bout offer (5.6) opens as a versus screen: the two boxers on a red and a blue wall, the tale of the tape (record, age, weight on the day against the limit, height, stance), the win chance and how sure it is, what a win and a loss change, Full report / Pass / Accept. Full report is the old bout page: stats against the estimate, win band, ranks at stake, the file, the terms.
- The game does not hold a venue, last-five form or a fighter's reach, and there is no scouting before accepting an amateur offer.

## Added S448 (code check)
- The attributes in section 3 marked AGREED, NOT BUILT are in the code: `scripts/rules/Attrs.gd` holds the 14 abilities (Strength,
  Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure; skills Accuracy, Timing, Defence, Footwork,
  Inside fighting) plus Heart; the old seven (Power, Hand speed, Technique, Defence, Conditioning, Ring IQ, Chin) are kept as a summary
  read from them. Punches are moves with mastery. Our own fighters have no height or reach value yet (opponents do).
- The plan's step and defence answers are `StrikeMap` arrows: step in, step out, step back, cut off, herd, pivot out, push off, feint,
  tie up, roll out. BUILT since S463 (`StepMastery`): each of the 10 has its own mastery bar, given at signing from Footwork; a step fires by its
  bar like a punch (under Usable 30 the coach never plans it and it mostly fails). Training a step (S463, greybox): the fighter page's WHAT TO LEARN NEXT card puts ONE step or defence in the study slot; the week's pad nights raise
  it about 6 a week (step back 0 to 32 in about 5 weeks); at Usable 30 it leaves the slot. One slot only. NOT BUILT: nothing takes a step past 30
  (to Sharp 60), sparring gives a step nothing, and two steps cannot be learned at once.
- Coaches: Luke Reid pads 74 (rating 58), Marcus Hale pads 58 / conditioning 90 (rating 74).
- Units: the code counts a pad night as 240 drill units (PadWeek.PAD_NIGHT_MINUTES) for the 75 real minutes in 4.2; a sparring night shares 180
  units over the moves on the fighter's cards and plan. Mastery maths uses the units.

## Added S451 (code check; where this and an older line above disagree, this wins)
- FireLevel is ON since S450: a planned line fires 1 use in 2 at Usable, 3 in 4 at Sharp, always at Signature. The line in 4.2 that says
  "SWITCHED OFF" is out of date.
- Our own fighters now have height and reach, and the fight reads them (S450). The S448 line saying they have none is out of date.
- Phases come from any booked bout, camp or no camp: a bout 1 week out makes the week TAPER (WeekPhase.phase), also for an amateur bout.
- Two rest rules after a stoppage loss, both in code: the 30-day suspension (Injuries) and the next bout offered 8 weeks later than usual
  (Matchmaking.STOP_REST_WEEKS).
- The office is a full-screen computer desktop (owner's Q-213 "A, full screen", S451): the gym's office pin opens it. Its Desktop shows what
  needs you, the next four weeks (bouts, bills, dues), mail, the fighters with each one's flag, money 8 weeks ahead and the staff. Its other
  apps (Mail, Schedule, Fighters, Staff, Finance, Records) are AGREED, NOT BUILT; today they lead to the existing pages.

SANDBOX (S412): the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never a fixed he or she in text or mockups.


# THE CURRENT MAP (v6)

# DESIGN_CLUBWEEK1_V6_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ115)

Brief: research/DESIGN_CLUBWEEK1_V6_REVISE_KALLI.md
Sent: 2026-11-14 15:29 | collected: 2026-11-14 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: writing CLUBWEEK1 v6 in full now, answering every point from John and Dola.

# CLUBWEEK1 v6: the club week for four, with the fight weeks inside it and the season around it (S459, 2026-11-14)

Part 1 of 4

**Owner rules this map keeps, quoted**
- **Q-190 (S434/S435):** "Just rename it 'gym sponsorship', the club pays." What earlier drawings called PAID SEAT is GYM SPONSORSHIP (short: sponsorship), never mixed up with Sponsor deals on Club > Money.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Rows, buttons, tooltips, Home notes and Why lines say your boxer, the fighter, the grappler, a team-mate, your coach, the opponent. (v5's "Ana's open" is now "the grappler's open".)
- **S412:** "the player runs any gym with any boxers, men or women." No fixed he or she anywhere, and never one fighter as the story.
- **S425:** the table of every menu, and what each is wired to, is in section 6.
- **S459:** 6+ DEPTH and 6+ GENERAL DESIGN from fresh critics; ESTIMATEs marked; buildable from what the game has.
- **Pack section 7:** only information the player can act on; one word per concept; screens only from agreed mockups. The Club week tab needs the owner's OK (owner question 1).
- **Kept from v5:** professionals in the line-up with an amateur-to-pro guide; staff named by role. "Coach" is the hired assistant coach and "You" is the head coach. Stamina for the ability (Attrs.gd). Amateur classes in kg: women 57/60/65/75, men 57.5/60/70/75.

**Marks**
- **CODE** is in the code today (file or symbol named).
- **REAL** is real practice, with its source.
- **ESTIMATE** is ours, gated by the section 8 probes.
- **NEW** is a rule this map adds.

**Status, said plainly:** no probe has run on v6. v5's "re-measured in the LOYAL1 rerun" was wrong and is withdrawn. Every Need, Want, loyalty, mood and price number below is ESTIMATE until section 8 runs.

**One word list (answers John 10)**
- **Tiredness** (0–100) is the week's wear (CODE, "Week tiredness").
- **Tank** is fight-night energy.
- **Stamina** is the ability.
- "Legs" is dropped. What v5 called Legs is now "tiredness at the first bell".
- The fighter page tab is **Week**, not "Training".
- **A place** is defined in 3.1.

## 0. How v6 answers the critics

### John (5/7 design; 13-point list)

| # | Point | v6 |
|---|---|---|
| 1 | Grappler can't draw on the boxing coach | **Done (3.1, 3.6).** Boxing places only: 3 boxers × Need 2 = 6 of 8 owned, Want 9. The grappler's classes come from the no-gi coach, with their own counter. The grappler competes for mornings, the sponsorship and the Saturday corner. LOYAL1 and SHORTWEEK1 are re-specified on this pool; the tables come when they run (they're Claude's runs, so they can't be pasted yet) |
| 2 | Fight week asks for more, against TAPER | **Done (3.2).** Fight-week sessions are one-to-one: the same 2 sessions, half volume, each using the coach's whole hour (2 places). No sparring |
| 3 | Define a place | **Done (3.1).** One place is 120 drill units, half of PAD_NIGHT_MINUTES 240. The "0.7 on 4th, 0.5 on 5th" rule is replaced: at most 3 places a week, each full |
| 4 | Sponsorship sums | **Done (3.5).** The sponsorship IS the stipend ($250 a week, CODE), paid in 4-week blocks. One switch, one cost line: −$250 a week. MONEYFOUR2 is re-set |
| 5 | Loops | **Done.** A talk uses no evening place (one talk a week for the club). Low mood pays no month-without-a-fight penalty. A pad holder isn't counted short |
| 6 | One rule set with AMATEURWEEK1 | **Done (section 4).** AMATEURWEEK1 owns the bout rules and this map points to them. Recommended for its next version: weigh-in on the day, 1 hour before (EB 7.1.3, a code change from the day before); ±2 kg at club shows (REAL); one probed pull-out rate |
| 7 | Mornings, choice or not | **Done (3.4).** Solo now counts as a Hard morning (×1.3) with no Hard tiredness, against shared at 0.8 each. Spread against concentrate, probed |
| 8 | Weak spot counted twice | **Done (3.3).** The +0.25 edge is dropped. The pull names which opponent style finds it, from abilities the fight reads only |
| 9 | Unknown card useless | **Done (4.1).** It comes sooner (7 days, not 12) and carries +1 favour |
| 10 | Four missing options | **Done.** Cover a night ($80, 2 places), a chosen rest week, let a fighter go, and the stipend switch (merged into the sponsorship). A second coach adds no places, with the reason in 3.1 |
| 11 | Words; Week tab; owner OK | **Done.** Word list above; owner question 1 |
| 12 | Home and away on the sheet | **Done (4.1)** |
| 13 | Pro table back; road strip later | **Done (4.3, 2).** The road strip shows at the first amateur's 5th win |
| also | Favours: one regional pool | **Done (3.7),** matching AMATEURWEEK1 |
| also | Body only nearly useless | **Done (3.6).** It's the only setting allowed with an open cut |

### Dola (8/8/8; 6-point list, missing and useless options)

| # | Point | v6 |
|---|---|---|
| 1 | Run the probes | **Planned (section 8),** with pass lines. Running them is Claude's |
| 2 | 2-week forecast | **Done (3.8).** The NEXT WEEK line under the counters |
| 3 | Twists 12 to 18 | **Done (3.9).** Six added. "Media interview" was not added because the local paper card already does it |
| 4 | Why behind every loyalty move | **Done (3.10).** Every move prints its cause, with a 4-week log on Overview and in the Week review |
| 5 | Borrow from next week | **Done (3.1).** Borrow a place: +1 now, next week −1 owned, one at a time |
| 6 | Rest redistributes | **Done (3.1).** Freed places show "give to" choices or "sell as a class" |
| missing | Reorder fighters / default rules | **Done.** Deal order is row order: drag the rows, and the order is kept week to week |
| missing | Skip a fighter a week | **Done.** The chosen rest week |
| missing | Light sparring | **Not added.** Technical is the light setting (+6 tiredness, 1 cut in 100) |
| missing | Emergency borrow | **Done.** Same as point 5 |
| useless | Pass shows nothing | **Done.** "Pass: −2 loyalty; this name held 7 days; next sheet in about 2 weeks" |
| useless | Hidden cooldown | **Done.** "Tell it straight: back in n weeks", with the odds shown |
| useless | Film vague | **Done.** The card names what the next film opens ("next: the habit") |
| useless | Sponsorship "pass" timeline | **Not changed.** The sponsorship is the club's to give, not an outside offer. "Pass on" moves it to a team-mate |

## 1. The idea in six lines
1. Four fighters stay at the club you take over: one professional boxer, two amateur boxers and one no-gi grappler, each in a different weight class. ClubStart sets 4 places at Unit 1 (NEW; CODE gives 3).
2. Every Monday, the Club week deals the club's short things: the coach's **boxing evening places** (8), **coached mornings** (6), the **gym sponsorship**, your **one talk**, and your **Saturday corner**. Coach's evenings can be sold as a second beginners' class: the money lever.
3. Bouts sit on the same board. An amateur's fight week is one-to-one and half volume, true to TAPER. A pro's camp sets its own pad nights. Two fights close together are where the real shortages come from.
4. **Favours** are the second currency: one regional pool, earned by helping other clubs, spent to bend bout terms, never wins.
5. What lasts past the week: **loyalty**, **fans** (home bouts build the crowd that pays the pro debut) and **one season target** per fighter.
6. No Monday repeats: job rotas shift, one club twist lands (deck of 18), a trial prospect visits every 4 weeks, and the NEXT WEEK line shows what's coming.

## 2. The start (Create, step 2; each name once, in its card's header)
- **ONE PROFESSIONAL** (pick 1 of 2; new starter data: 1-0 pro, licensed, unranked, amateur fans carried over):
  - **Pro slot A:** women's 60 kg, age 21, out-boxer, potential 84, 34 fans (ESTIMATE).
  - **Pro slot B:** men's 70 kg, age 23, southpaw pressure fighter, potential 79, discipline 80, 22 fans, second pro bout booked 6 weeks out (ESTIMATE).
- **TWO AMATEURS** (pick 2 of 4):
  - **A:** women's 57 kg, 1-0, college rota.
  - **B:** women's 65 kg, 2-1, shifts rota, loyalty 82.
  - **C:** women's 75 kg, 6-4, office rota, loyalty 66.
  - **D:** men's 60 kg, 2-1, shifts rota, loyalty 58.
  - Each card shows the job rota, free mornings, sparring partners in reach, fans and ambition (Recruit.ambition).
- **THE GRAPPLER:** white belt, 2 stripes, cafe rota; the first open is Sat 7 Feb.
- **Staggered opening:** the unpicked amateurs return on the trial mat. The pro opens in camp, one amateur has a bout sheet, the other an active goal.

**The guide, weeks 1–5** (skippable; names only in headers):
1. Meet the four.
2. Deal the week.
3. Answer the call.
4. Start week.

After week 1 the guide names the trade, never the answer, and it stops after the 3rd fight week.
- **Road strip moved (answers John 11 and 13):** "The road, amateur to professional" (offer rule, saying no, the $1,245 at signing, the ticket-paid debut, purses) appears when any amateur reaches 5 wins. TURNPRO1 v2 owns its numbers.

**Reveal order (NEW)**

| Week | Arrives | Guide line |
|---|---|---|
| 1 | Boxing places (Need, Want), NEXT WEEK line, first bout sheet | "Eight places, six needed, nine asked." |
| 2 | Coached mornings; Coach's evenings as training or class | "A class pays the rent. Pads win bouts." |
| 3 | Club twist, sponsorship, sparring setting | "Hard sparring builds more and cuts more." |
| 4 | Favours, loyalty bar and its causes | "Whoever goes under their need remembers it." |
| 5 | Trial mat, season targets, talk card | "One target per fighter." |

Part 2 of 4

## 3. The week, as the player meets it

### 3.1 Boxing evening places (8 owned)
- **Where the 8 come from:** Coach works 3 evenings. The first hour is the existing members' class (+$350 a week, CODE). The second hour is 2 places, or a second class (3.1a). You hold 2 places on your own evening.
- **What a place is (answers John 3):** one place is **120 drill units**, half of a pad night's 240 (CODE, PadWeek.PAD_NIGHT_MINUTES). It goes onto the boxer's drill cards exactly as pad time does today.
  - A boxer takes at most 3 places a week (360 units).
  - Every place is full; there are no 0.7 or 0.5 places.

**Need and Want, ordinary weeks (BASE, BUILD)**
- Each boxer needs 2 and wants 1 more.
- 3 boxers: **Need 6 of 8 owned, Asked 9.** Every ordinary week has 2 spare places and still one boxer without a third. ESTIMATE.

**What creates real shortage**

| Event | Places | Club Need against owned | Tag |
|---|---|---|---|
| One amateur fight week (3.2) | that boxer takes 4 (2 one-to-one sessions × 2) | 8 of 8: full | ESTIMATE |
| Two fight weeks at once | 4 + 4 + 2 | 10 of 8: 2 short | ESTIMATE |
| Pro camp, BUILD and PEAK | the camp's pad nights × 2: Light 2 nights = 4, Standard 2 = 4, Hard 3 = 6 | 8 to 10 of 8 | camp nights CODE (2+1 / 2+2 / 3+2); places ESTIMATE |
| Pro TAPER week | one-to-one, 4 | 8 of 8 | ESTIMATE |
| One class night sold | owned 8 to 6 | 6 of 6 in an ordinary week; any fight week makes someone short | ESTIMATE |
| Film evening on a fight week | 2 (one coach hour) | +2 | ESTIMATE |
| Trial prospect (every 4 weeks) | +1 Want | competes for spare places only | ESTIMATE |

**Valves (answers John 10, Dola 5 and 6)**
- **Cover a night:** buy 2 places for $80 in any week. A sessional cover coach takes a second hour. Same price as the twist's cover. ESTIMATE.
- **Borrow a place:** +1 now, and next week is 1 owned short. One borrow outstanding at a time. The NEXT WEEK line shows the debt. ESTIMATE.
- **Chosen rest week:** a switch on any boxer's row: 0 Need, 0 Asked, +4 morale (CODE rest week +4).
- **Freed places, from rest, a pull-out, or a booked bout ending:** the counter shows "Freed 2: give to [row] / [row] / sell as a class +$117". This is Dola's redistribution. The default follows deal order.
- **Hold pads (Loyal 70+, 6+ bouts):** the holder gives one of its own places to a team-mate at 0.7 (84 units).
  - The holder is NOT counted short while holding (answers John 5).
  - Loyalty +3 a week, for at most 4 weeks.
- **Deal order is row order:** drag a row up and it's dealt first. The order is kept week to week (Dola's "default rules").
- **Second club coach** ($280, CODE: +1 roster place, +40 members, fitness classes) adds **no** places. Its 10 hours are fitness classes in the code. So the night cover is the cash-for-places valve.

**What meeting or missing costs**
- Need met: loyalty +1.
- Want met as well: +1 more.
- Short (covered under Need): −3, or −6 when short 2+ weeks running. Waived 1 week in 4 at Loyal 70+.
- A missed Want costs no loyalty, only the 120 units.
- All ESTIMATE.

### 3.1a Coach's evenings: training or a second class (the money lever)
- Each of Coach's 3 second hours, and your own evening, switches between **Pads (2 places)** and **Class (+$117 that night, about 1 new member every 4 weeks taught)**. ESTIMATE; the first-hour class's $350 is CODE.
- **Why it binds:** one class night drops owned places to 6, which is exactly ordinary Need. Any fight week, camp or film then makes someone short.

### 3.2 The amateur fight week: one-to-one, half volume (answers John 2)
- **The fight week** is the code's TAPER week, the 7 days before any booked bout (WeekPhase.phase, CODE).
- **The boxer keeps 2 sessions,** the same frequency. Each is one-to-one: the coach's whole second hour, which is 2 places.
- **Half volume:** each session drills 60 units of pads. The other half-hour is the fight-week bill: plan lines, the finish move, southpaw rounds, sharpening.
  - So the week drills 120 units, half the ordinary 240. That's inside the 41–60% volume cut (REAL: Bosquet et al. 2007).
- **No sparring in the fight week** (CODE TAPER).
- The counter prints the reason: "Fight week: one-to-one, 2 sessions".

### 3.3 What each fighter pulls
Warnings come first: Scale (over the limit inside 14 days), Fight (last 7 days), Rest (tiredness 70+ or hurt). Then up to two pulls, each with its size as a range and colour-coded by what it spends:
- **WEAK SPOT (answers John 8):** the lowest ability the fight reads, when 3+ below the fighter's level.
  - It adds no extra edge, since the fight already charges for the low ability.
  - The chip names who finds it: "Low Defence: pressure fighters find it."
  - Only abilities the fight reads. Whether Explosiveness and Recovery count is CHECK (Claude), per the pack.
- **WEAPON:** the ability gating the next perk ("Fast hands at Speed 70: about 4 weeks").
- **GOAL:** the active goal (+10 met, −20 missed, CODE).
- **AHEAD:** the next rival up the ladder, and the answers owned.

A pull asks for 2 coached mornings, or 2 places for Ahead. A sponsored fighter can hold 2 pulls; one with a day job, 1.

**Three deal buttons:** **Coach deals it** (the one-click default, John), **Keep my changes**, **By hand**. Under them sits "Coach's deal: 2 to 3 in 100 below yours". ESTIMATE, sized by TANKPRICE1.

### 3.4 Coached mornings (6 owned: You 4, Coach 2) (answers John 7)
- **Solo:** one fighter with a coach counts as a **Hard morning (×1.3) without Hard's extra tiredness.**
- **Shared:** two fighters on one morning get 0.8 each.
- So 6 mornings are either 6 × 1.3 = 7.8 on a few fighters, or up to 12 × 0.8 = 9.6 spread thin. Concentrating on one pull is the cost. ESTIMATE, probe MORNINGS1.
- **Alone mornings** train at the mood rate (3.11). Discipline under 45 skips 1 alone morning in 3 unless a team-mate trains in the room.
- The grappler competes for these mornings like any fighter.

### 3.5 The gym sponsorship IS the stipend (answers John 4)
- **One payment, one switch:** the code's stipend ($250 a week, CODE, Club > Money > STIPENDS) is shown and billed as the gym sponsorship in 4-week blocks ($1,000).
- **What it gives:** 6 free mornings a week, no job rota, loyalty +5.
- **The card prints:** "−$250 a week, billed per block."
- **Who can hold one:** amateurs and the grappler. A pro can't; the stipend stops on signing (CODE).
- **At the block's end:**
  - Renew: −$1,000, loyalty +2.
  - Pass on: the receiver +5, nobody loses.
  - Let end: 0.
- **Stopping it mid-block:** loyalty −8. A fighter with potential 80+ unsponsored for 8 weeks asks for one: −3 a week until it's given or a promise is dated.
- CHECK (Claude): that the stipend and the sponsorship can be one record.
- All loyalty numbers are ESTIMATE.

### 3.6 Sparring and the grappler
**Sparring** (pair and setting on the Club week; not in a fight week):

| Weight gap | Effect |
|---|---|
| Under 5 kg | full for both |
| 5–10 kg | lighter full, heavier half |
| Over 10 kg | lighter +10 tiredness |

| Setting | Gain | Tiredness | Cut risk | Allowed |
|---|---|---|---|---|
| Hard | ×1.3 | +12 | 4 in 100 | normal |
| Technical | ×1.0 | +6 | 1 in 100 | normal |
| Body only | Stamina and body ×0.8 | +8 | 0 | **the only setting allowed with an open cut** (answers John) |

All ESTIMATE; SPARSET1.

**The grappler (answers John 1):**
- Mat classes come from the **no-gi coach, paid by the class** (CODE): 3 a week on the cafe job (NoGi.CLASSES_PER_WEEK, CODE), 5 on a sponsorship (+6 tiredness for each over 3, ESTIMATE).
- Its own counter: "MAT CLASSES 3 of 3".
- **What the grappler competes with the boxers for:** your coached mornings, the sponsorship, the one talk, and your Saturday corner.
  - Who corners appears only when a boxer and the grappler both compete that Saturday: You, or a $100 mat coach.
- **The open:** Enter or Skip, with a choice between:
  - White: about 55 in 100; a gold brings +2 no-gi members.
  - Promote to Blue first: about 35 in 100, owes BeltRoad.EARLY_DEBT, +3 members.
- From blue, **Teaching** gives +$68 a week and about 1 member every 4 weeks, at −1 class.
- Stripe calls move loyalty on the shared scale (StripeCall, CODE).
- Numbers are ESTIMATE unless named.

Part 3 of 4

### 3.7 Favours: one regional pool (answers John)
- **Pool:** 0 to 5 favour magnets for the club with the region's show clubs. ESTIMATE, matching AMATEURWEEK1.
- **Earn:**
  - +1 for boxing on their show, a late replacement, or a sparring trip (1 of your places).
  - +1 for the Unknown sheet card.
  - +2 for a 4-day short-notice call.
- **Lose:** −1 for missing weight or pulling out. No loss if their boxer pulls out.
- **Spend:** −1 to ask a kilo, re-deal the sheet, ask for a named opponent, or move a bout a week.
- Favours never buy a win, a judge, a rank or a place.

### 3.8 The NEXT WEEK line (answers Dola 2)
One line under the counters, read from booked bouts, camps, rotas and borrowed places:
- "NEXT WEEK: fight week for your 65 kg boxer; Need 8 of 8. Selling a class tonight leaves 2 short."
- "IN 2 WEEKS: two fight weeks; Need 10 of 8."

It shows only when the next two weeks differ from this one.

### 3.9 One club twist a week (deck of 18; Dola 3)
- 1 week in 4 is quiet, and the same card never comes twice running.
- Each card has 2–3 priced answers. The clock waits for an answer; with none, Coach picks on Monday.
- **The 12 kept from v5:**
  - Coach off Wed
  - Coach stays late Thu
  - Overtime on Sat
  - Visiting pro spar
  - Boiler out Thu
  - Another club asks a kilo
  - Local paper photo
  - Short-notice call
  - Sponsor photo
  - Hall floods
  - Member's family pad session
  - Quiet week
- **Six new (ESTIMATE prices):**
  1. **Club fundraiser night:** give your evening (−2 places, +$300 once), or say no.
  2. **Bag splits:** repair ($120, +2 reputation, CODE repair), or improvise (heavy bag mornings ×0.8 for 2 weeks).
  3. **Bank holiday:** hall shut one evening. Lose 2 places, or pay the hall $90.
  4. **Guest coach Thursday:** one boxer gets a free one-to-one (2 places' worth). Pick who; the others see it (−1 loyalty to the one passed over if Wavering).
  5. **Winter bug:** two fighters miss 2 mornings. Rest them (−1 pull each), or train through (+10 tiredness each).
  6. **Junior taster:** your evening as a taster (−2 places, +2 members after 4 weeks), or pass.

### 3.10 Loyalty (0–100), every move with its cause (Dola 4)
**Bands**
- Loyal 70+: can hold pads, and 1 short week in 4 is waived.
- Settled 50+.
- Wavering 25+.
- Leaving, under 25.

**Moves (ESTIMATE):**
- Need met +1; Want met +1 more.
- Short −3; short again −6.
- Promise kept +5; broken −12.
- Sponsorship given +5; renewed +2; stopped −8.
- Holding pads +3 a week.
- Passing a ready sheet −2.
- A season target matching ambition +5; against it −5.
- Target met +10; missed −5.
- Stripe call: now +3, hold −5.
- Overtime refused −2.
- A team-mate let go −5 (3.12).

**Every move prints its cause:** "−3: short of the second place this week". Overview keeps a 4-week log, and the Week review shows the week's moves.

**The talk (loyalty under 50, "Wants a word"):**
- **One talk a week for the whole club.** It costs your Monday, **not an evening place** (answers John 5).
- Each fighter at most once in 4 weeks.
- The three answers:
  1. **Give the place back:** dealt first next week, +4.
  2. **A dated promise** of a place, a bout or the sponsorship, by a date (+5 kept, −12 broken; listed under PROMISES OPEN).
  3. **Tell it straight:** the odds come from the visible Coachability, shown on the button ("holds: 60%"): +4 or −4. The button shows "back in n weeks" during its 8-week cooldown.
- **Consequences:**
  - Under 25 after 2 talks, the fighter leaves next Monday for Eastside ABC.
  - Turning pro under 50, the fighter signs with an outside manager, and the club takes 10% instead of 25% (GYM_SHARE, CODE).

### 3.11 Mood with teeth (ESTIMATE, MOODRATE1)
- Morale bands (CODE): Fired up 75+, Steady 50+, Flat 30+, Low under 30.
- **Alone rate:**

| Mood | Alone rate |
|---|---|
| Fired up | 0.8 |
| Steady | 0.6 (CODE baseline) |
| Flat | 0.4 |
| Low | 0.4, skips 1 alone session in 2, passes the next bout sheet (no loyalty cost) |

- **Loop broken (answers John 5):** while Low, the month-without-a-fight morale penalty (−6, CODE) doesn't apply.
- Corner trust on fight night: 1.05 / 1.0 / 0.85 / 0.7 (CODE).

### 3.12 The squad changes
- **Trial mat, every 4 weeks:**
  - The prospect visits for 2 weeks (+1 Want).
  - **Watch** costs 2 coached mornings and gives exact potential.
  - Then Sign or Pass.
- **Let a fighter go (NEW, answers John 10):** a button on the fighter's row menu.
  - Price: the rest of the sponsorship block, if any, or 1 week's stipend; −5 loyalty to each team-mate; frees a roster place now. ESTIMATE.
  - Confirm on a second press, never pre-selected.
  - Signing a 5th fighter needs a place: the second club coach (+1 place, CODE), the bigger unit, or letting one go.

### 3.13 Season targets and fans
- **Season target** (unlocked week 5):

| Fighter | Targets |
|---|---|
| Amateurs | Nationals / Pro offer / Year to grow |
| Pro | Ranked (6-week camp, step-ups) / Busy (4-week Light camp, tune-ups) |
| Grappler | Medal / Blue belt |

  A pro outside the top 10 keeps the day job and may take **Camp leave** ($120 a week, the last 2 camp weeks).
- **Fans** (ESTIMATE):
  - Home win +4, home loss +1, away 0, title +10.
  - They feed TURNPRO1's debut ticket count and the pro's Matchmaking.fans (CODE field).

## 4. The fight week inside the club week

### 4.1 The bout sheet (amateur), with the rules owned by AMATEURWEEK1
| Card | What it gives | Tag |
|---|---|---|
| **Home** (local or the club's own show) | $450 ticket cut; +8 members on a win; +4 fans on a win, +1 on a loss | $450 and +8 CODE; fans ESTIMATE |
| **Name above** (away) | $450; +8 members on a win; −$40 travel; +1 favour; a name up to 3 places above | $450, +8 CODE; rest ESTIMATE |
| **Unknown** (away) | $450; +8 on a win; **7 days' notice instead of 12; +1 favour;** a wide band; a file to open | ESTIMATE |

- **Pass:** "−2 loyalty; this name held 7 days; next sheet in about 2 weeks".
- **States:**
  - Ready: gets sheets.
  - Building: no sheets, ×1.1 training.
  - Rest: 2 weeks after a bout; Need 0, Light mornings, +4 morale.

### 4.2 The scale and the bill (shared with AMATEURWEEK1, answers John 6)
**One rule set: AMATEURWEEK1 owns these numbers.** This map recommends, for its next version:
- **Weigh-in on the day, 1 hour before boxing** (REAL, EB rule book 7.1.3). This is a **code change** from today's day-before weigh-in.
- **Agreed weight ±2 kg at club shows** (REAL, Stevenage ABC club practice), replacing v5's 1.0 kg.
- **One pull-out rate,** probed in SHEETDEAL1 (v5 said 15 in 100, AMATEURWEEK1 v8 35 in 100: one value wins after the probe).

**Over the allowance:**
- Eat less: −1 tank per 0.1 kg.
- Train it off: no gain, +5 tiredness per 0.25 kg.
- Ask a kilo: 1 favour. **The heavier boxer** then boxes with +2 tank per 0.5 kg over, and the lighter gets nothing (WEIGHTGAP1).

**The fight-week bill:** 2 plan lines, the finish move, southpaw rounds, film (2 places), sharpening in the last 3 days. Three shapes: Rest up / Tick over / Train through. One range: "Your week against Coach's: +2 to +4 in 100". Plus the top 3 levers, and tiredness at the first bell.

### 4.3 Pro and amateur side by side (restored, answers John 13)

| | Amateur | Professional |
|---|---|---|
| Notice | bout sheet, 7 or 12 days (AMATEURWEEK1) | 6 weeks (promoter, CODE) |
| Before the bout | fight week only, one-to-one, half volume | camp of 4 or 6 weeks: Light / Standard / Hard nights (CODE) |
| Places | 2 ordinary, 4 in the fight week | camp nights × 2; 4 in TAPER |
| Rounds | 3 × 3 minutes (CODE) | 4 unranked, 6 ranked (CODE) |
| Money to the club | $450 ticket cut (CODE) | 25% of the purse (CODE); camp bill |
| Sparring | yes, not in the fight week | yes, not in TAPER |
| Day job | rota unless sponsored | kept outside the top 10; Camp leave $120 a week |
| Sponsorship | can hold one | can't (stipend ends on signing, CODE) |
| Fans | home bouts build them | sell the tickets (TURNPRO1) |
| Bouts a year | about 9 (ESTIMATE) | about 6 (ESTIMATE) |

Part 4 of 4

## 5. Every decision

| When | Decision | Options and prices | Probe |
|---|---|---|---|
| Create | 1 pro of 2, 2 amateurs of 4 | classes, sparring pairs, fans, ambition | START1 |
| Week 5+ | Season target | per fighter (3.13) | SEASON1 |
| Monday | Deal | Coach deals it (default) / Keep my changes / By hand; drag rows for order | TANKPRICE1 |
| Monday | Coach's evenings | Pads (2 places) or Class (+$117) | MONEYFOUR2, LOYAL1 |
| Monday | Places | Need and Want; Cover a night $80; Borrow 1; Freed places; Hold pads | SHORTWEEK1, LOYAL1, COVER1 |
| Monday | Mornings | Solo (×1.3) or shared (0.8 each) | MORNINGS1 |
| Monday | Sponsorship | give, renew, pass on, let end, stop (−8) | MONEYFOUR2 |
| Monday | Rest week | switch per boxer | LOYAL1 |
| Monday | Pulls, sparring, twist, talk, trial | 3.3, 3.6, 3.9, 3.10, 3.12 | WEAKFIND1, SPARSET1, ROTATWIST1 |
| Any time | Let a fighter go | −block or 1 week's stipend; −5 to team-mates | none: a rare act |
| Sheet | Home / Name above / Unknown / Pass | 4.1 | SHEETDEAL1, FOLLOW1 |
| Fight day | Scale | Eat less / Train it off / Ask a kilo | WEIGHTGAP1 |
| Saturday | The grappler's open, Who corners | Enter or Skip; White or Blue; You or $100 | GRAPPLE1 |

## 6. Every menu it appears on, and what each is wired to (S425; names only in headers)

| Menu | What shows | Wired to |
|---|---|---|
| **Create, step 2** | pro (1 of 2), amateurs (2 of 4), grappler; rota, mornings, sparring reach, fans, ambition | CreateScreen, ClubStart (4 places, NEW), Roster.sign_fighter, Recruit.ambition |
| **The guide, weeks 1–5** | 4 steps; reveal order; road strip at the first 5th amateur win | GuideLight, FirstWeek, NextStep, Roster.pro_ready |
| **Fighters > Club week** (owner OK needed) | counters: BOXING PLACES (Need, Asked, Owned, Short), MAT CLASSES, MORNINGS, SPONSORSHIP, FAVOURS, runway; NEXT WEEK line; Coach's evening magnets (Pads or Class); Cover a night; Borrow; rows draggable for deal order (header name, badge, mood word, loyalty bar with its last cause, rota or sponsorship, pulls, 7 days, sparring pair and setting, rest switch); Freed places; talk card with odds and cooldown; PROMISES OPEN; twist; 3 deal buttons; Start week | ClubDeal (places, 120 units, one-to-one fight week, cover, borrow, freed), DuesLevers.CLASS_WEEKLY, PadWeek, WeekPhase, WeakSpot, JobRota, ClubTwist (18), Favours (regional pool), TrialMat, Loyalty (with causes), SeasonTarget, SparSet, LeverSize, GymSpend (stipend), NoGi.CLASSES_PER_WEEK |
| **Fighter > Week** (renamed from Training) | own cells at the mood rate; shared cells say "Change on the Club week" | WeekBoard, WeekEditors, SparSet |
| **Fighter > Overview** | season target; pulls with who finds the weak spot; mood alone rate; loyalty with its 4-week log; fans; Let go in the row menu | FighterPage, AttrBoard, Attrs, PerkRoad, Loyalty, Fans, SeasonTarget |
| **Fighter > Fight prep** | amateur: fight-week bill, one-to-one sessions, one range; pro: camp nights and places, Camp leave | FightPrep, FightWeek, Camp, CampCard, LeverSize, GymSpend |
| **Grappler page** | mat classes from the no-gi coach (3 or 5), mat morning, open with White or Blue odds, teaching, stripe calls, Enter or Skip, Who corners when it clashes | GrapplerPage, NoGi, BeltRoad.EARLY_DEBT, BjjOpen, StripeCall, Loyalty |
| **Fighters > Find a fighter (trial)** | prospect card, ranges, Watch (2 mornings), Sign or Pass, the 5th-place need | RecruitPanel, Trial, TrialMat, GymSpend.place_blocked |
| **Home** | one row per fighter (name only in the name cell), open pull, days to bout, "Wants a word" note, sponsorship ending, NEXT WEEK shortage note | Home, HomeRows, Needs, Loyalty, ClubDeal |
| **Fighters cards** | badge, loyalty word, sponsorship or job, flag (Fight week, Set camp, Wants a word) | RosterCards, FighterCard, RosterFlag |
| **Fights (amateur)** | bout sheet: Home / Name above / Unknown with the lines in 4.1; Pass text; favour magnets; Ready / Building / Rest; the grappler's open card | Fights, BoutSheet, OfferCard, Favours, Fans, ClubShow, AmateurBooking |
| **Fights (pro)** | promoter's three offers beside the sheets; ticket money from fans | ProFights, ProLadder, Matchmaking.fans |
| **Bout page: the bill** | scale (±2 kg, 3 answers), bill items, tiredness at the first bell, one range, top 3 levers, Take / Coach runs it / Pass | BoutPage, FightWeek, LeverSize, WeighIn, PlanBoard |
| **Tape room** | the next film says what it opens | TapeRoom, OppFile |
| **Playbook > Game plan** | "Bring this line" tick; fight-week places the lines need | GamePlan, PlanBoard, MoveMastery |
| **Club > People** | Coach card (evenings as Pads or Class); second coach "+1 roster place, no evening places"; no-gi coach by the class | StaffCard, CoachAreas, ClubDeal |
| **Club > Money** | class nights; sponsorship as the stipend (−$250 a week, block dates); cover nights; away travel; grappler teaching; pro share 25% or 10%; Camp leave | Money, GymBills, GymSpend, CashForecast, DuesLevers, StarDeal |
| **World > Rankings, Championships** | ladders; nationals as fight weeks | WorldLadder, Region, NationalsView, SeasonTarget |
| **Top bar and Continue** | flags FIGHT WEEK, SET CAMP (pro), PRO OFFER, WANTS A WORD; stops for a pull-out, a 4-day call, the scale, a twist, a sponsorship end | Shell, Needs, Clock |
| **Fight night and the Why** | weigh-in on the day; corner; Why lines ("Tiredness at the first bell: −9 tank", "Short of pads in the fight week"), rank, fans, deal gap | FightNight, WeighIn, CornerTrust, FightWhy, LeverSize |
| **Monday Week review** | shortages with causes and "Give it back"; loyalty moves with causes; the month's deal against Coach's; targets | WeekReview, WeekCause, Loyalty, SeasonTarget |
| **Pro offer** | debut forecast from fans; share 25% or 10% by loyalty (TURNPRO1 owns the rest) | ProOffer, ProDebut, Fans, Loyalty |

## 7. The numbers
- **MEASURED (earlier probes, four amateurs):**
  - 28 bouts a year, 41 wins in 100.
  - Sponsorships over a year: 0 gives +$31k; 4 close 80% of gyms (AMATEURPROBE1, MONEYFOUR1).
  - Good plan 59%, none 45%, bad 41%; +5 stats about 72% (CODE pack). FireLevel on (S450).
- **CODE:** stipend $250; first-hour class +$350; ticket cut $450; win +8 members, +5 reputation; PAD_NIGHT 240 units; camp nights 2+1 / 2+2 / 3+2; TAPER 1 week out; NoGi 3 classes; GYM_SHARE 25%; corner trust bands; rest week +4.
- **ESTIMATE:** place = 120 units; Need 2, Want 1; fight week 4 places at half volume; class night +$117; cover $80; borrow; loyalty moves; mood rates; solo ×1.3; sparring settings; favours 0–5; fans; the six new twist prices; Camp leave; travel $40; Unknown 7 days.
- **Cash for this start (ESTIMATE):**
  - 2 amateurs, about 9 bouts each: about $8,100 a year in ticket cuts.
  - Pro: 25% of purses, about $2,000–3,000.
  - 1 sponsorship: −$13,000 a year.
  - 1 class night every week: +$6,100 a year, plus members.

## 8. Probes (played bouts, 40 seeds × 52 weeks, three seed sets; the UI waits for the tables)
**Cut rule:** any choice worth under 1.5 wins in 100 on a bout AND with no season effect is cut, not drawn.

1. **SHORTWEEK1 + LOYAL1, on the boxing pool** (3 boxers, 8 places, fight week 4):
   - Asked over owned in 9/10+ weeks.
   - A boxer short in 15–35% of weeks.
   - COACH's longest short run 2 or less; COACH's lowest loyalty 50+.
   - STARVE loses exactly 1 fighter a seed; EVEN stays above 60.
   - CLASS (1 class a week) is short in 40%+ of weeks yet gains cash.
2. **TAPER1:** one-to-one, half-volume fight week against v5's +2 Need full volume. Taper wins 1.5+ in 100.
3. **MORNINGS1:** solo-on-the-pull against spread. Each wins in 30–70% of seeds, judged on season target weeks.
4. **COVER1 / BORROW1:** cover chosen in 10–40% of fight weeks; borrow best in under 1 week in 4.
5. **TANKPRICE1:** best week against Coach's 4–6 in 100; no single job over 6.
6. **SEASON1:** a careful player against Coach deals it: pro offer 6+ weeks sooner, or 2+ more wins a year.
7. **ROTATWIST1 (18 cards):** the best deal changes in 3/4+ weeks; no answer best over 2/3.
8. **FOLLOW1:** always-away fails the 60-ticket debut; always-home arrives 6+ weeks later; a mix clears both.
9. **MOODRATE1:** alone rates move 1+ stat point over 4 Flat weeks.
10. **SPARSET1:** Hard beats Technical by 1.5+ in 100 over 6 weeks, with cuts costing 1+ bout in 20.
11. **WEAKFIND1:** with no extra edge, the weak-spot pull still beats a random pull by 1.5+.
12. **SHEETDEAL1 / WEIGHTGAP1:** no card dominates; one pull-out rate set; ±2 kg trips the scale in 5–15% of bouts.
13. **MONEYFOUR2:** 1 sponsorship (−$250) plus 2 class nights stays level over 52 weeks, with stipend-equals-sponsorship.

## 9. Build order
1. Probes 1, 2, 13 first, then the rest. Emit the LeverSize tables.
2. Pure rules, one per task: ClubDeal (120 units, Need and Want, one-to-one, cover, borrow, freed), Loyalty (causes), Favours (regional), ClubTwist (18), WeakSpot (no edge), SparSet, SeasonTarget, Fans, TrialMat, JobRota, LeverSize, stipend as sponsorship.
3. Code changes, listed: weigh-in on the day, 1 hour before (with AMATEURWEEK1); ClubStart 4 places; retire WeekTwist.
4. Start data and the guide.
5. Screens, after owner question 1: Club week, bout sheet, the bill, Overview loyalty log, Money lines, the grappler page.
6. One golden-path test: Create, the 5-week reveal, a class night, a fight week fills the pool, a second fight week makes one short, cover a night, a talk, a twist, a home bout, the scale on the day, the Why, the grappler's open, the pro camp.

## 10. Risks
- **Build size:** 12 rule modules; ships over several milestones, gated on probe 1.
- **Two meters:** mood is shown as a word only and loyalty as a bar only, and every price names which one it moves.
- **Boxing-only places** mean the grappler's week is thinner. The grappler's tension lives in mornings, the sponsorship and the corner, and GRAPPLE1 must show the grappler's choices matter.

## 11. Owner questions (scope, money, taste)
1. **The Club week:** OK it as a tab on Fighters, or make it the Monday page that replaces the week review?
2. **Weigh-in on the day, 1 hour before** (the real rule) is a code change from the day before. Take it?
3. Should a pro outside the top 10 keep the day job, with Camp leave at $120 a week?
4. Starter amateurs at 57 and 75 kg have no pro table yet. Keep them, or limit the starters to 60, 65 and 70?

**CHECK (Claude)**
- The stipend and the sponsorship as one record.
- Which abilities the fight reads, for the weak spot.
- The home lean in close rounds (HOMELEAN1).

## 12. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6.**

**To reach 10/10:**
1. Run probe 1 on the boxing pool and paste the tables.
2. AMATEURWEEK1 adopts the shared bout rules.
3. Owner question 1.
4. Draw the Club week at 1920×1080. Counter strip on top. NEXT WEEK line under it. Coach's evening magnets on the left. Three boxer rows and the grappler's row in the centre, with fight-week magnets drawn double width. Twist, talk and PROMISES OPEN on the right. The deal buttons at the bottom, with gold only on Start week.
5. Probe GRAPPLE1 so the grappler's row carries real choices.


# THE CRITICS ON v6

## Critic (fresh, S472): DEPTH 7, GENERAL DESIGN 5 - general design misses the bar by one

# DESIGN_CLUBWEEK1_V6_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ124)

Brief: research/DESIGN_CLUBWEEK1_V6_CRITIC_MARIA.md
Sent: 2026-11-14 16:40 | collected: 2026-11-14 17:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give CLUBWEEK1 v6 **DEPTH 7, GENERAL DESIGN 5, PLAY 6**, so it doesn't reach the owner's bar yet. The Monday deal is a real decision: eight evening places against a need of six and asks of nine, a class night that pays the rent but leaves the pads short, and fight weeks that collide. But the map quietly halves every boxer's pad time compared with the game today. It replaces the game's start with a fixed squad of four. It asks for about 12 new rule modules on top of a game that already has a week. And after six versions, no probe has run.

## Scores

**1. DEPTH: 7/10**
What works:
- **A real shortage with causes.** Ordinary weeks leave two spare places. A fight week fills the pool. Two fight weeks, or one class night, make someone short. That's how a real small amateur club runs: one coach, a few evenings, and whoever has a show coming gets the pads.
- **The valves each cost something different:** cover a night for $80, borrow from next week, a chosen rest week, a boxer holding pads for a team-mate, and the freed places.
- **Mornings:** concentrate (solo, ×1.3) or spread (shared, 0.8 each).
- **The sponsorship** merged into the stipend is one lever, not two.
- **Favours** bend terms, never wins.
- **Home against away** feeds fans, which feed the pro debut.
- **The weak-spot pull** stops double-counting: it names who finds the low ability rather than adding an edge.

What holds it back:
- **Too many meters for one decision.** Loyalty, mood, favours, fans, tiredness, places, mornings, mat classes, season targets, promises and the sponsorship all move from one Monday. Depth comes from a few levers that bite, not from eleven. Several (fans from home bouts, favours, the trial mat every 4 weeks) are close to always-take choices, and the map can't show otherwise until the probes run.
- **Coach deals it is probably dominant.** "Coach's deal: 2 to 3 in 100 below yours" means hand-dealing every Monday is worth about one bout in 40. Most players will press the default every week, and then the depth is invisible. Probe TANKPRICE1 must prove a bigger gap, or the deal needs a sharper trade.
- **The grappler is thin, and the map says so.** The grappler's choices are the open, the belt call and the corner clash. GRAPPLE1 hasn't run.

**2. GENERAL DESIGN: 5/10**
What works:
- One word list (Tiredness, Tank, Stamina; "Week" tab).
- No names outside headers, no fixed pronouns, the "grappler's open" fix.
- Every loyalty move prints its cause.
- Real sources for the taper (Bosquet 2007), the weigh-in on the day (EB 7.1.3) and ±2 kg at club shows.
- Honest "no probe has run" line, with v5's false claim withdrawn.
- The pro and amateur side-by-side table.

What fails:
- **Pad time is halved against the code.** The pack's standard week is 3 pad nights of 240 units each, 720 a week. The map caps a boxer at 3 places of 120 units, 360 a week. In an ordinary week, with Need 2, a boxer drills 240 units, a third of today. Every mastery pace, every "Usable in N weeks" line, the step study slot (about 6 a week from pad nights) and the 59/45/41 plan numbers were measured on the old volume. The map doesn't say it's halving training, or why.
- **The start replaces the game's start.** The pack's career begins with one walk-in, a guide that signs a second boxer after the first bout, and the grappler arriving by week 9. The map's start hands over a pro, two amateurs and a grappler on day 0, with 4 roster places where the code gives 3. The first hour's teaching (one boxer, the first weight cut, the first fight) is gone. That's a different game start. It needs the owner's OK as a separate question, and the three existing starts (Fresh doors, In debt, Backed) aren't mentioned.
- **A new screen with no agreed mockup.** The Club week is a new tab. The map itself says it needs the owner's OK. Under the pack's rule, screens come only from agreed mockups.
- **Colour shows state alone.** Pulls are "colour-coded by what it spends". They need a word.
- **The class night's price is new.** The code's evening classes give +$350 a week with a coach. The map's +$117 a night and "1 member every 4 weeks" are ESTIMATE, and it doesn't say how they sit beside the existing +$350.
- **Build size.** 12 rule modules, a weigh-in rule change, a new start, a new tab, and a changed training volume. The map lists this as a risk but doesn't cut anything. Under the owner's "deeper, not wider", the season target, fans, the trial mat every 4 weeks and six new twists could each wait.
- **"The fight week is one-to-one, 2 places a session"** uses the coach's whole hour per boxer. With two fight weeks, that's 8 places on fight weeks alone. The map counts it right (10 of 8), but it means any two amateur bouts within 7 days always leave a third boxer with nothing. Say so on the sheet before Accept.

**3. PLAY: 6/10**
There's a weekly pull: the NEXT WEEK line warns of the collision two weeks out, the class-or-pads switch is felt in cash, and a team-mate holding pads is a warm club moment. Talks, dated promises and a fighter leaving for the rival club give the squad a story. But Monday becomes a long page of counters, rows, magnets, a twist, a talk, a trial, sparring pairs and settings. The owner's pack says a quiet week should be one click. Coach deals it keeps it one click, which then hides the depth.

## Options: missing, useless, and what each changes

**Missing**
- **A training volume switch** that keeps today's pad nights: a boxer on "Full week" takes 3 nights (720 units) at the cost of 6 places, so the shortage is real without halving training.
- **A "Fresh doors with one walk-in" start** that keeps the game's teaching hour, with the squad of four as a fourth start.
- **A warning at Accept** when the bout's fight week collides with another, naming who goes short.
- **"Coach deals it, but protect this boxer"**: one pin on a row, so the default respects a priority without hand-dealing.

**Useless or near-dominant**
- **Hand-dealing** at a gain of 2 to 3 in 100.
- **Away "Name above"** when its only cost is −$40 travel and it gives a favour and a ranked name.
- **Fans and Unknown sheets** are probably always-take until probed.
- **Body-only sparring** outside an open cut.

**What each option changes**
- **Coach's evening, Pads or Class:** 2 places, or +$117 and members.
- **Cover a night:** +2 places for $80.
- **Borrow:** +1 now, −1 next week.
- **Rest week:** that boxer needs 0, +4 morale.
- **Hold pads:** gives one place at 0.7 to a team-mate, loyalty +3 a week, holder not counted short.
- **Mornings:** solo ×1.3 or shared 0.8 each.
- **Sponsorship:** −$250 a week, 6 free mornings, no job rota, loyalty +5; stop −8, renew +2, pass on +5 to the receiver.
- **Sparring setting:** Hard ×1.3 and 4 cuts in 100, Technical ×1.0 and 1 in 100, Body only ×0.8 with no cut.
- **Talk:** give the place back (+4), a dated promise (+5 kept, −12 broken), or tell it straight (odds from Coachability, +4 or −4).
- **Sheet:** Home (fans +4 on a win), Name above (+1 favour, −$40), Unknown (7 days, +1 favour), Pass (−2 loyalty).
- **Scale:** eat less (tank), train it off (tiredness), ask a kilo (1 favour).
- **Favours:** spend one to ask a kilo, re-deal the sheet, name an opponent, or move a bout.
- **Let a fighter go:** frees a place, −5 to each team-mate.
- **Grappler:** Enter or Skip, White or Blue, You or a $100 mat coach.

## To reach 10/10

1. **Keep today's training volume.** One place = 240 units (a full pad night). The coach owns 4 nights plus yours (10 places' worth, ESTIMATE). A boxer's Need is 2 nights and Want 3, as in the code's standard week. Re-run the shortage table on that.
2. **Run probe 1 (SHORTWEEK1 and LOYAL1) and TANKPRICE1** before anything else. If hand-dealing beats Coach's deal by under 4 in 100, add "protect this boxer" and cut By hand.
3. **Keep the game's start.** The squad of four becomes a fourth start ("Take over a club"), with 4 places written as that start's rule. Fresh doors keeps the walk-in, and the Club week appears when the second boxer signs.
4. **Cut to the meters that bite.** Ship places, class nights, the sponsorship, loyalty with causes, and the NEXT WEEK line. Move favours, fans, season targets, the trial mat and the six new twists to a v2, each gated on its probe passing the cut rule.
5. **Give the owner a mockup** of the Club week before any screen work, and ask question 1 with it.
6. **Words beside every colour:** pulls print "WEAK SPOT", "WEAPON", "GOAL", "AHEAD".
7. **Tie the class night to the code:** say whether +$117 replaces or adds to the +$350 evening class, and confirm with Claude.
8. **Warn at Accept:** the bout page prints "This fight week overlaps the 60 kg boxer's: one boxer short 2 places" before the button.
9. **Prove the grappler's row** with GRAPPLE1, or drop the grappler from the deal and keep only the corner clash.
10. **Get the owner's answer on the weigh-in change** (question 2), then hand it to AMATEURWEEK1 as one rule.

**My 10/10: the Club week, 1920×1080, Look B whiteboard**
- **Top strip (120 px):** counters as magnets on the board: PADS (owned, needed, asked, short), MORNINGS, SPONSORSHIP, cash runway. Each prints a word and a number.
- **Under it (60 px):** the NEXT WEEK line in marker, only when the next two weeks differ.
- **Left (420 px), COACH'S EVENINGS:** four evening magnets, each flippable Pads or Class with its price written, plus Cover a night ($80).
- **Centre (1000 px), THE SQUAD:** one row per boxer, the name once in a header cell, then:
  - a mood word and loyalty bar with its last cause in words,
  - the job rota or the sponsorship,
  - pulls as labelled stickies,
  - the week's pad nights, fight-week nights drawn double,
  - the sparring pair and setting,
  - the rest switch and a "protect" pin.
  The grappler's row sits last, with mat classes and the open.
- **Right (400 px):** the week's twist with priced answers, the talk card with its odds, and PROMISES OPEN with dates.
- **Bottom (100 px):** Coach deals it (default) and Keep my changes, with gold only on Start week.
