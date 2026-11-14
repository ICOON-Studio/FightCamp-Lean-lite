# WEIGHT1_R4 - write the NEXT version of this mechanic's design map (S459 design loop)

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


# THE CURRENT MAP (R3)

Sent: 2026-11-14 16:40 | collected: 2026-11-14 17:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: writing WEIGHT1 round 4 in full now, answering every point from both critics.

# WEIGHT1 round 4: the weight mechanic, design map (S459, 2026-11-14)

Part 1 of 4

Roadmap row WEIGHT1. Designer seat: Kalli. Status: ROUND 4, for two fresh critics. This round answers both round-2 critics, John (7/5/6) and Kalli (8/6/7), against the round-3 map. The bar is 6+ DEPTH and 6+ GENERAL DESIGN (S459), not 7+.

**Owner rules this map keeps, quoted**
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Round 3's rule ("Names on every line, never he or she") was the opposite. It's withdrawn. Rows, buttons, lines, tooltips and news say your boxer, the fighter, the opponent, your coach, or "your 65 kg boxer". The worked examples name a fighter only in their section header.
- **S412:** "the player runs any gym with any boxers, men or women." No fixed he or she: "Her way = heard" becomes "the fighter's way = heard". The code's plan situation text "she tires" is flagged for "the opponent tires" (CHECK, Claude).
- **S425:** the table of every menu and its wiring is section 9.
- **S459:** the bar above; ESTIMATEs marked; buildable from what the game has.
- **Pack section 7:**
  - only information the player can act on;
  - one word per concept;
  - screens only from agreed mockups;
  - classes in kg: women 57/60/65/75, men 57.5/60/70/75. Round 3's "Welterweight 65.0" is withdrawn.
  - Scouting means opponents; the facility is a gym; camp is only pre-bout preparation; money in USD.
- **Kept from round 3:** B0 SAVECAP1 before anything else; Watch tape 2 is free; the goal is judged after the bout.

**Marks**
- **CODE** is in the game today (file:line or constant).
- **REAL** is real practice, with its source.
- **GAME VALUE** is ours by design, with no real source behind it.
- **ESTIMATE** is ours, to be set by a probe.
- **NEW** must be built.
- **CHECK (John)** or **CHECK (Claude)** is open.

No probe has run on round 4. Every price below is ESTIMATE until section 10 runs.

## 0. How round 4 answers the critics

### John's To reach 10/10 (14 points)
| # | Point | Round 4 |
|---|---|---|
| 1 | Names out of every row | **Done.** Rule rewritten above; every row, label, Why line and news line rewritten. The examples carry names in headers only |
| 2 | Club show against championship | **Done (section 4).** A club show uses an AGREED WEIGHT with a 2 kg matched gap, a scale 1 hour before, and only the meal back by the bell. A championship uses the class limit, a morning scale and refuel |
| 3 | Size edge on real stats | **Done (4.4).** A flat dice edge in the inside and clinch places only, named in the Why. Power is gone |
| 4 | Tiredness share as a function | **Done (5.3).** The Energy price of carried tiredness is `stale_energy`(tiredness at the bell after the TAPER week), the CODE formula extended to every booked bout (NEW). Example rows are re-printed from it |
| 5 | The club's cash on every money line | **Done.** Every price prints what lands in the cash tin, pro purse lines included (× 25%) |
| 6 | BBBofC for pros | **Done (7).** The California forced move and the Nevada 25% are gone; the remaining pro penalties are tagged GAME VALUE |
| 7 | Nutritionist does one thing | **Done.** Asks × 0.5, $100 a week. The Old hand edge is unchanged (CODE +120 kcal a day), so the owner has nothing to OK |
| 8 | Fog holds | **Done.** No refusal prints a weight; every WIN on an offer is a band |
| 9 | Price AGGRESSIVE refuel | **Done.** Renamed FULL: −2 live Energy in round 1. The injury ×1.1 is not added: no source, and one price is enough |
| 10 | Plan table opens on need | **Done (5.5).** The coach's row plus one alternative. The full table opens only at a miss risk of 5 in 100+ or a WIN spread of 3+. The gamble row was already cut in round 3, so no favour row remains |
| 11 | Missing options | **Done.** Withdraw at any point once the forecast miss passes 1 in 3; the class at signing; the championship refuel; the no-gi class up (TO SOURCE, waits on John's B14) |
| 12 | One word list across maps | **Done (section 3).** Energy (the bell), tiredness (the week), Stamina (the ability); mood words from the pack only; favours owned by AMATEURWEEK1; promoter trust is the CODE "two ducks" rule. CLUBWEEK1 v7 changes its "tank" to Energy |
| 13 | Owner first: two classes; men's 57.5 | **Done (section 12).** Both are owner questions |
| 14 | John's sourcing (B14) | **Kept as B13.** No-gi scale rules, UK meal-prep and nutritionist prices, the EB club allowance and championship weigh-in hour |

**John's logic points not in the list:**
- **"The size edge is dead at a same-day scale."** Withdrawn. At a club show the matched gap is the size edge (4.4).
- **"Same kilos counted twice":** fixed. At a club show nothing comes back but the meal, so the trim's Energy price stands in full and the size counts the meal only. At a championship the refuel gives back part of the trim's price and part of the weight, from one rule (4.3).
- **Amateur "box them":** gone. For amateurs, the opponent over the gap is the opponent's walkover (EB 10.7.2).
- **Promoter trust, "Mood Good+", favours:** a missed Monday check counts as one duck (CODE: a promoter refuses after two). Mood words are Fired up / Steady / Flat / Low. Favours are AMATEURWEEK1's regional pool.

### Kalli's To reach 10/10 (14 points)
| # | Point | Round 4 |
|---|---|---|
| 1 | Names out | **Done**, as John 1 |
| 2 | EB amateur scale, with a re-weigh | **Done (4.2).** Same day, 1 hour before (EB 7.1.3); matched within the gap (EB 2.7.8, club practice 2 kg); one re-weigh inside the session (ESTIMATE 30 minutes, CHECK John). Amateur catchweight and ASK A KILO are cut. The favour becomes "ask the matchmaker for another name" |
| 3 | Classes in kg only | **Done** |
| 4 | One energy word | **Done.** Energy, kept because the code's word is Energy (BoutNight._energy) and the fight-night screens already show it. FATIGUE is dropped and tiredness kept |
| 5 | Size edge on Attrs | **Not done.** Adding to Strength and Durability for one bout would move the radar and the training targets. A place-limited dice edge is how size works, and the Why can name it |
| 6 | Price the gamble | **Moot.** The gamble row has been gone since round 3. No weight option spends a favour except asking for another name |
| 7 | Fold rows | **Done (5.5)** |
| 8 | A first release | **Done (section 8).** Release 1 is the amateur core; release 2 is pro and no-gi |
| 9 | Pull out before the scale | **Done (5.4).** A Home need once the forecast miss passes 1 in 3, from the offer to the scale: $300 slot, no walkover, mood 0 (the same rule as the CODE injury pull-out; one rule, not two) |
| 10 | Roster clash option | **Done (6, D7).** When two of the club's boxers share a class: "Share shows" or "One moves" |
| 11 | Cycle band | **Cut.** It changed nothing the player acts on (pack section 7) |
| 12 | Office desktop | **Done.** Row M18 |
| 13 | Loop alignment | **Done.** The bar is 6+; owners are Claude or the seat Claude names; USD only |
| 14 | Spread probes first | **Done.** P1 (spread), P2 (size edge) and P3 (gap risk) run first, after B0 |

**Kalli's missing options:** the re-weigh (done); the release cut (done); pull out (done); the coach-pick trust line (done: a hover on the coach's row, "the coach's row was best in n of your last m bouts", read from the Why history, NEW); two boxers in one class (done).

**Kalli's useless options:** amateur catchweight (cut); ASK A KILO (replaced); MATCHED as a separate option (it's the club-show default, not an option); cycle band (cut); second-day clause (release 2).

**Kalli's menus:** the CLASS card ask reads "your boxer asks to move up"; news says "your 65 kg boxer"; the Office desktop row is added.

Part 2 of 4

## 1. The idea in six lines
1. Every fighter walks above the weight they box at. How far, and what it costs, depends on the bout: a **club show** is matched by weight, a **championship** by the class limit, and a **pro** bout by a contract.
2. At a club show the decision is the **agreed weight** on the offer: give away size and box safe, or keep size and risk being outside the gap.
3. When there's weight to lose (a championship, a pro limit, or a tight agreed weight), three priced levers shape the cut. Which mornings to burn (a stat or the goal); how to answer the fighter's ask to eat (Energy, mood or cash); what runs if the Monday check reads over (Energy, room, or pull out).
4. Energy at the bell, for both corners, sets **the window**: the exchanges where the opponent tires and your boxer is still fresh enough to punish it.
5. Pace per round and the plan's "when the opponent tires" line are bought against that window, so weight, pace and the plan are one budget.
6. What runs for months (the walk, between-fights eating, the class) lives on the fighter's Body and class tab and the CLASS card.

## 2. What is built today (CODE, unchanged from round 3)
| Part | What runs | Where |
|---|---|---|
| One weight a fighter | daily kcal sum, no walking weight | Sim.gd:207-209; WeekPlan.day :241-270 |
| Sessions burn and train | MET × kg × min; gain 0.2 × intensity × headroom × coach | WeekPlan SESSIONS :31-41, INTENSITY :45-49 |
| The coach's week by phase | PEAK 2 weeks out; TAPER in the fight week, from any booked bout | WeekPhase.WEEKS :25-34, phase :43-47 |
| Diets | HOLD (+300), CUT −500 (Old hand −620) | WeekPlan ALLOWANCE, CUT_DEFICIT |
| The scale | made at limit + 0.05, the day before | BoutRules WEIGH_TOLERANCE, made_weight :171 |
| A miss | bout off, $300 slot, next offer 6 days later, no loss | Bouts.weigh :327-347 |
| Energy at the first bell | 100 − hurt − stale; the opponent always 100 | BoutNight._energy :300-306 |
| Stale | 2 a tiredness point over 50, at most 20, only after a camp | BoutRules.stale_energy :165-168 |
| Round spend, power fade | ROUND_COST 18 + punches × spend_factor; tired_penalty from round-end Energy, both corners | Combos :26-38, :272-285 |
| Your boxer tired, the opponent tiring | under 35 / under 45 (Tiring 3 exchanges in 4) | Exchanges.SHE_TIRED, OPP_TIRED, next_mode |
| Pace, round pace, round tells | Push / Steady / Save; f.round_pace; tape round_hints | PaceAim; PlanFile :113-133 |
| Plan lines | best 9, ok 3, wrong −7; undrilled × 0.8 | PlanFight.EDGE; PlanBoard.UNDRILLED |
| The fighter's asks | rate lerp(0.6, 0.2, coachability); heard +5, overruled −5 | PushBack; FighterProfile.MORALE_EVENTS |
| Mood is trust | 1.05 / 1.0 / 0.85 / 0.7 | FighterProfile.trust |
| After the bout | result morale, then the goal | BoutNight._finish :423-432 |
| Club prices | win +8 members +5 reputation; loss −1 / −2; $450 ticket cut every bout | BoutRules |
| Places in a fight | outside, long, mid, inside, clinch, ropes | Exchanges places |

The four round-3 code findings stand: Save refills past the top (B0), pace doesn't change its own round's fade, the goal's mood lands after the bout, and an amateur bout 12 days out still asks for a camp until AMATEURWEEK1 lands.

## 3. The words (one set on every screen, and in CLUBWEEK1 and AMATEURWEEK1)
| Word | Means | Never |
|---|---|---|
| Walking weight ("walks 66.8 kg") | where the body settles when nobody cuts | natural weight |
| Class ("65 kg") | the class, by its kg | Welterweight, division |
| Agreed weight ("agreed 65.5 kg, gap 2 kg") | a club show's matched weight on the offer | catchweight (amateurs) |
| The gap | the most the two boxers may differ on the scale | allowance, grace |
| The scale ("Sat 28, 4 pm") | the official weigh-in, day and hour | weigh-in check |
| Re-weigh | one more step on the scale inside the session | |
| Burn morning | a training morning swapped for Hard roadwork | cardio day |
| Trim | the last 3 days' light eating, at most 2% of the limit | water cut (amateurs) |
| The fighter's ask | the fighter asks to break the diet one weekend | cheat day, slip |
| Meal prep | the club pays for this bout's meals | |
| Refuel | eating between a morning scale and the bell | |
| Energy | fight-night fuel, 100 at a fresh first bell | tank, gas |
| Tiredness | the week's wear, 0–100 (the code's "Week tiredness") | fatigue |
| The window | exchanges where the opponent is tiring and your boxer isn't tired | |
| Stamina | the ability (Attrs.gd) | cardio, engine |

## 4. Three kinds of bout, three scales

### 4.1 Which scale applies
| Bout | Weight rule | Scale | Back by the bell | Tag |
|---|---|---|---|---|
| Amateur club show | AGREED WEIGHT on the offer; the two boxers within the gap | same day, 1 hour before | the meal only, at most +0.3 kg | EB 7.1.3 REAL; gap 2 kg REAL (Stevenage ABC, club practice); EB 2.7.8 caps it at the smaller boxer's category width |
| Amateur championship (the regional, the nationals) | the class limit | same day, morning (hour CHECK John) | refuel (4.3) | EB 7.1.3 REAL; hour TO SOURCE |
| Professional | the contract weight | the day before, about 30 hours out | water and refuel (release 2) | BBBofC 3.2.2 REAL |

The weigh-in on the day replaces today's day-before scale for amateurs: a code change, shared with AMATEURWEEK1 (B5).

### 4.2 The club show: the agreed weight (D0, on the offer)
- **On the offer:** the opponent's declared weight (on the offer, as on real club-show cards) and the gap (2 kg).
- **Fog:** the opponent's weight on the day is a range until tape is watched (amateurs can't scout before accepting, S410). The risk is printed as a band.
- **Your boxer's three answers**, set on the offer and changeable until the Monday of the fight week:

| Answer | What your boxer weighs in at | Price | Best when |
|---|---|---|---|
| **Box near the walk** (Hold) | the walk minus the coach's taper drift | the risk of being outside the gap if the opponent comes in light (band); keeps the size edge | your boxer fights inside (Slugger, Pressure fighter), the opponent's range is narrow |
| **Meet the declared weight** (the coach's: Lean) | within 1 kg of the declared weight | little size edge; rarely outside the gap | the opponent's range is wide or unknown |
| **Come in light** (Lean + a small trim) | at or under the declared weight | the trim's Energy price; gives the size to the opponent | your boxer fights at range and the bout is about Energy, not size |

- **Outside the gap at the scale:**
  1. One **re-weigh** inside the session (ESTIMATE 30 minutes, CHECK John), sweating at −2 Energy a 0.1 kg, up to 0.3 kg.
  2. If still outside, **ask the matchmaker for another name:** 1 favour from AMATEURWEEK1's regional pool. A boxer within the gap is found about 1 time in 2 (ESTIMATE).
  3. Else a **walkover loss** for the boxer outside the gap (EB 10.7.2): the CODE loss path (−12 mood, −1 member, −2 reputation, the record), and the $450 ticket cut not earned. CHECK (John): whether a club show calls the bout off instead (Stevenage says it does).
- **The opponent outside the gap:** your boxer's walkover win (+8 members, +5 reputation, CODE win path; $450 paid, NEW). No "box them" choice for amateurs.

### 4.3 Refuel at a championship (D-R, a standing answer)
| Answer | Energy back by the bell | Weight back | Price |
|---|---|---|---|
| **Light** (the coach's) | a quarter of the trim's Energy price | +0.3 kg | none |
| **Full** | half of the trim's Energy price | women +1.5%, men +2.1% of the limit (REAL, Reale 2017, championship study) | −2 live Energy in round 1 (gut weight) |

All ESTIMATE except the regain. One rule gives both the Energy back and the weight back, so no kilo is counted twice.

### 4.4 The size edge (NEW, ESTIMATE; probe P2)
- **The edge:** +1 on the exchange dice, in the **inside and clinch places only**, per kg of the scale gap past 1 kg, at most +3. Weights are read after what comes back by the bell.
- **Why it isn't an ability:** the Why names it: "Size: +1 inside (1.8 kg heavier)".
- **Where it matters:** at a club show the gap is up to 2 kg, so the edge is 0 to +1. At a championship both boxers are near one limit, so it's usually 0, unless one corner refuels Full. That's the real trade.

Part 3 of 4

## 5. The cut: levers, each priced (shown only when there's weight to lose)
The levers open when the forecast at the scale is over the target. The target is the class limit (championship), the agreed weight's line (club show), or the contract (pro). A club show boxer near the declared weight sees only D0 and the line to the scale.

### 5.1 The price of a kilo (ESTIMATE, B1)
- **Trim:** −1 Energy a 0.1 kg up to 0.5, −2 a 0.1 from 0.5 to 1.0, −3 a 0.1 past 1.0; the cap is 2% of the limit in 3 days (REAL.md 7). Lean is −250 kcal a day, about 0.03 kg a day.
- **What a point of Energy buys:** the window (section 6) and the round's power (CODE tired_penalty). As a win chance it's 0.4 in 100 a point (ESTIMATE, P10).

### 5.2 D1. Burn mornings (pick 0 to 3), from round 3
- **Source:** the coach's real PEAK week (CODE WeekPhase.WEEKS["peak"]). A picked morning becomes Hard roadwork, priced with WeekPlan.day (CODE).
- **What's offered:** only mornings that don't already burn. The fight week is the coach's taper and isn't offered.
- **The goal price** shows only on mornings that feed the goal; the rest cost their own stat.
- **Not a lookup:** the answer turns on the trim's tier, the goal, and which stat each morning feeds (worked in section 6).

### 5.3 Tiredness at the bell, as a function (answers John 4)
- **The rule:** Energy price = 2 × (tiredness at the first bell − 50), at least 0, at most 20. That's CODE stale_energy, extended from "after a camp" to every booked bout (NEW, B6).
- **Tiredness at the bell** = tiredness on Monday of the fight week + the fight week's sessions − the TAPER's rest days. The code's rest-day recovery is used as written (CHECK Claude: the per-day value).
- **What each answer adds:** Cut adds +1.5 tiredness a day (ESTIMATE), a burn morning +4 (Hard, CODE load 1.5).
- **Re-printed for three starting points** (fight-week Monday tiredness; ESTIMATE until the rest-day value is read):

| Fight-week Monday | Trust the trim | Cut 5 days | One burn morning in PEAK, then trust |
|---|---|---|---|
| 40 (fresh) | 0 | 0 | 0 |
| 55 | 0 | 0 if the taper drains 8+, else 2–4 | 0 |
| 70 (worn) | 6–10 | 14–18 | 8–12 |

So a Cut is cheap for a fresh fighter and dear for a worn one. The tiredness bar on the plan row shows which applies.

### 5.4 D2. If the fighter asks to eat (a standing answer, and meal prep)
- **The ask (NEW B7):** a weekend ask beside the weekly card, built on CODE PushBack. The fighter has a reason when a diet runs and discipline is under 50. The rate is lerp(0.6, 0.2, coachability/100) of those weekends. A fighter with discipline 50+ never asks, and that boxer's panel has no D2.
- **The three answers:**

| Answer | kg (ESTIMATE) | Mood (CODE apply_morale) | Best when |
|---|---|---|---|
| **Let the fighter eat** | +0.5 | heard, +5 | Flat near Steady (lifts trust to 1.0 for the night) and the trim has room |
| **Half a plate** | +0.2 | 0 | mood near a band edge and the trim near a tier |
| **No** (the coach's) | 0; under discipline 50 the fighter eats anyway (50 − discipline) in 100 (ESTIMATE) | overruled, −5 | mood well inside a band, trim near the cap |

- **Meal prep:** $25 a day for this bout's days (ESTIMATE, TO SOURCE B13). The card prints "−$300 from the club's cash, 12 days". **One effect: a "No" always holds.**
- **Nutritionist** (Club > People, $100 a week, one effect): asks × 0.5 for every fighter on a diet.

### 5.5 What the player sees: the coach's row, folded (answers John 10, Kalli 7)
- **The coach's row** in the one gold frame, with Energy as a stacked bar: tiredness at the bell, trim, sweat. It also shows the scale result, the miss risk, the WIN band, and the hover "the coach's row was best in n of your last m bouts" (NEW, from the Why history).
- **One alternative row** under it: the best row that differs in one lever.
- **"All plans"** opens the full table. It opens itself only when the miss risk is 5 in 100+ or the WIN spread is 3+ (P1).

### 5.6 D3. If the Monday check reads over (Monday of the fight week; a standing answer)
| Answer | Price | Best when |
|---|---|---|
| **Trust the trim** (the coach's) | the trim's Energy price; less room under the cap | the trim stays under 1.0 |
| **Cut 5 days** | −0.16 kg (CODE CUT_DEFICIT); its price is the tiredness function in 5.3 | the trim passes 1.0 and the fighter is fresh |
| **Pull out now** | "−$300 from the club (empty slot); the $450 ticket cut not earned"; no loss; next offer 6 days later (CODE). At a championship it ends the run (CODE) | the forecast trim is near the cap |

**Miss chance by room under the cap** (ESTIMATE, B1): 1 in 100 at 0.4 kg, 4 at 0.27, 8 at 0.2, 20 at 0.1.

**Pull out before the scale (answers Kalli 9, John 11):** from the offer to the scale, whenever the forecast miss passes 1 in 3, a Home need offers **Pull out** with the same prices. Mood 0, as the CODE injury pull-out, so it's one rule.

### 5.7 D4. The pace of each round, and D5. Write it (from round 3, reworded)
- **D4.** Push / Steady / Save for R1, R2 and R3, written to f.round_pace (CODE), with the tape's round tell when found. Every pace card prints the window and how many exchanges your boxer is tired. Win changes per pace wait for P16, after B0.
- **D5. Write it:** "When the opponent tires → 1-2-3", replacing the weakest line when the plan is full. One unit, edge × exchanges it fires:
  - the window × 3/4 (CODE OPP_TIRED) × 9 (best) × 0.8 (undrilled under 30), against the replaced line's fires × its edge.
  - Pad nights on the 1-2-3 (the **Week** tab) move it.

### 5.8 Past the cap (Home need, stops the clock)
When the forecast trim passes the cap: **Pull out** (5.6), or **Go to the scale** (up to 0.3 kg sweated at −2 Energy a 0.1, one re-weigh). Past that, the club-show or championship rule in 4.2: a walkover loss through the CODE loss path. No walkover can come without this need shown first, unless the ask came in the last 3 days (B5 test).

## 6. The class, the walk, and the class at signing (D7, Body and class tab and the CLASS card)
- **The walk** drifts back when nobody cuts: half in week 1, the rest over 3 weeks (B3; REAL 3.5–4.8% a week of what was lost). Between fights the coach runs Lean while over the limit and able to take offers, and Hold when hurt or at the limit, with its reason shown.
- **The CLASS card** opens when two classes are in reach: no more than 9.5% under the walk, 4 kg over. Its columns are DOWN / STAY / UP, priced in cut per camp, Energy, size, ladder place (CODE: a move leaves the regional table), offers in the last 8 weeks, and team-mates in the class. Its options:
  - **Test the weight** (championships and pros only, because club shows are matched anyway).
  - **Move now** or **Move after the next bout.**
  - The fighter's ask, "your boxer asks to move up": **Hear** (+5) or **Overrule** (−5, CODE).
- **Two of the club's boxers in one class (answers Kalli 10):**
  - **Share shows:** the one waiting longer gets the next offer.
  - **One moves:** opens DOWN or UP for one of them.
- **The class at signing (answers John 11):** the Interview and Trial card shows the walk and the classes in reach, and the player picks the class there (NEW).
- **No-gi:** enter a bracket one class up, as an option on the open card. TO SOURCE (IBJJF/ADCC rules, B13); release 2.

## 7. The professional (release 2)
- **Scale:** the day before, about 30 hours out (BBBofC 3.2.2 REAL).
- **Water:** the last day's water, 0 to 3%, buys size at an Energy price (GAME VALUE).
- **Refuel:** Light or Full, as 4.3 (Full −2 in round 1).
- **Catchweight +1 / +2 kg** (GAME VALUE): the other side asks 10% / 15% of your boxer's purse. The row prints the club's cash: "Catchweight +1: −$95 to the club (10% of a $3,800 purse × your 25%)".
- **The opponent misses** (GAME VALUE): **Box** (the opponent pays 25% of their purse to your boxer: "+$x to the club at your 25%") or **Refuse** (no bout, no slot fee).
- **Repeat misses:** after 2 misses in 12 months the promoter offers only the class up (GAME VALUE, replacing the California rule).
- **Promoter trust:** a missed Monday check counts as one duck, and two ducks mean the promoter refuses (CODE).
- **A pro camp:** its stale Energy (CODE) prices every burn morning in tiredness too.

Part 4 of 4

## 8. Worked examples (names in headers only)

### 8.1 Example: Samira Khan (Data.gd:210-213), London regional, 65 kg, 12 days out
- **The boxer:** 65.9 kg, walks 66.8 (ESTIMATE), discipline 34, coachability 52, heart 70, mood 54 Steady, goal Defence 50.8 (example), Week tiredness 45 on the fight-week Monday (ESTIMATE). Coach rating 58. The scale is on the day, in the morning; your boxer's refuel is Light.
- **The coach's row:** Lean −0.36, trim 0.59, price 6.8. Energy at the scale 93; Light refuel +1.7, so **95 at the bell**. Tiredness at the bell under 50, so 0.
- **D1:**
  - Tue and Thu feed the goal (Defence 50.86 drops to 50.64 / 50.72: missed, −19.9 mood after the bout).
  - Sat costs Technique 0.12 and buys +1 Energy. The player burns Sat: trim 0.53, **96 at the bell.**
- **D2:** the ask comes about 2 weekends in 5. "No" would put your boxer at 49.6, Flat, 2 times in 5. The player sets **Half a plate** (if asked, trim 0.73, **92 at the bell**, mood holds). No meal prep: it would buy about 0.8 Energy for $300.
- **D3:** Trust the trim. The fold opens on the alternative row only: the WIN spread is 2 and the miss risk is 2 in 100.
- **Full refuel instead?** +3.4 at the bell, but −2 live in round 1, and +1.4 kg back gives a size edge of 0 to +1 against an opponent on Light. The alternative row shows it; P20 decides.

**Opponent (the drawn opponent, NEW B6):** 86 at the bell. The window under Steady is 5.
**D5:** 5 × 3/4 × 9 × 0.8 = 27, against 21 for the pressing line. The player writes it.

| Plan | Energy at the bell, clean / if asked | Mood on the night if asked | Window | WIN band (ESTIMATE) | Costs |
|---|---|---|---|---|---|
| Coach's | 95 / 95 (84 if eats anyway) | Flat 2 in 5 | 5 (3) | 47–61 | Flat risk |
| Yours: Sat burned, Half a plate | 96 / 92 | Steady | 5 / 4 | 48–62 | Technique −0.12 |
| Sat burned, Let eat, meal prep | 96 / 86 | Steady | 5 / 3 | 48–62 | −$300 from the club |
| All three burned | 98 / 94 | Steady | 5 | 49–63 | goal missed (−19.9 after), Technique −0.12 |

The middles differ by 1–2, inside the band. The screen says "too close to call", and the choice rests on the tails: Flat on the night, the goal, the cash.

### 8.2 Example: the same boxer at a club show
- **The offer:** opponent declared 65.0 kg, gap 2 kg, range 64.5–66.5 until tape.
- **Box near the walk:** about 66.3 at the scale; outside the gap if the opponent comes in under 64.3, so 5–12 in 100 (band). Gap about 1.3 kg after the meal, so +0 to +1 inside: worth it for a Slugger.
- **Meet the declared weight** (the coach's): about 65.5; outside 1 in 100; no edge; Energy 100.
- **Come in light:** 65.0 at a trim of 0.5, so Energy 95; gives the size away. Rarely right for this style.
- **After tape 2** the range narrows to ±0.5 and the band with it.

### 8.3 Example: Kira Mensah (57 kg, discipline 64)
No ask (discipline 50+), so there's no D2 row. The trim is 0.94, in the −2 tier near −3, so all three mornings are worth 3.4 Energy. Fresh on the fight-week Monday, so a Cut costs 0. The best set differs from 8.1.

## 9. Every menu it appears on, and what each is wired to (S425)
| # | Menu | What it shows | Wired to today (CODE) | New wiring |
|---|---|---|---|---|
| M1 | Fighter > Fight prep > THE WEIGHT | D0 or the cut levers by bout kind; the coach's row and one alternative; All plans on need; Energy round by round with pace per round, both corners' lines and the window; the other corner (tape 2 link, Write it) | FightPrep.gd:34-74; Sim.weigh_forecast; PlanFile.set_pace; TapeRoom | WeightRules.*; EnergyCurve; PlanLines.add |
| M2 | Fighter > Body and class | walk and drift, between-fights eating with its reason, ask rate, last 6 scales, CLASS card | FighterPage.gd:29-30 | TAB_ORDER; BodyClass |
| M3 | Fighter > **Week** (renamed) | a burned morning reads "Hard roadwork, for the weight" | WeekBoard.gd:402-416 | f.week_edits |
| M4 | Fights > bout offer | club show: declared weight, gap, the three D0 answers, outside-gap band; championship/pro: the scale's day and hour; every WIN a band | VersusPanel.gd:159-196; BoutPage.gd:44-56 | WeightRules.agreed_rows / coach_plan |
| M5 | Home > needs | Pull out (forecast miss past 1 in 3); past the cap | Needs.gd:75-76 | WeighDay.pull_out, past_cap |
| M6 | Weigh-in modal | the hour, the reading, re-weigh, another name (1 favour), made / sweated / walkover | WeighIn.gd:13-28; Bouts.weigh | WeighDay.weigh, reweigh |
| M7 | Tale of the tape + 3D intro | weights at the scale and at the bell | TapeRows.gd:64-80; TaleOfTape.gd:24-29 | OppWeight (the two formulas go) |
| M8 | Fight night | first card "Energy 92: trim −7, refuel +2" for both corners; round pace; "Size: +1 inside" | BoutNight.gd:306 | WeightRules.energy_sum; size edge in Exchanges |
| M9 | Result > the Why | "Weight: Energy 92 at the bell; the window 4; your tires line fired 3 times; size +1 inside" | WhyCard.gd | WeightRules.why_line |
| M10 | Week review | the ask and its answer, the Monday answer that ran, planned vs actual | WeekReview.gd:413-414; WeekActual.gd:82-91 | WeighDay.check; EatAsk.log |
| M11 | Home fighter row, Coming up | "0.83 kg to lose · scale Sat 9 am" | HomeRows.gd:195-201; Fixtures.gd:19 | WeighDay.hour |
| M12 | Fighters > Roster | weight against the target; amber when the Monday answer ran, red past the cap | RosterCards.gd:213-220 | f.plan state |
| M13 | Club > People | nutritionist (asks × 0.5, $100) | StaffRoles.gd:7-21 | + "nutritionist" |
| M14 | Club > Money | "Meal prep, your 65 kg boxer, 12 days, −$300"; pro purse lines at 25% | c.pay | WeightRules.buy_meal_prep |
| M15 | World > News | "Your 65 kg boxer asked to eat: half a plate"; made / re-weighed / walkover | c.add_news (Bouts.gd:339) | WeighDay, EatAsk |
| M16 | Playbook > Game plan | round pace; the Write it line "from the weight plan" and what it replaced | GamePlanRows.gd:20-32 | PlanLines.add(source, replaces) |
| M17 | Interview / Trial | the walk, the classes in reach, the class pick | Interview modal | Classes.in_reach |
| M18 | Office desktop (S451) | next four weeks: scale day and hour; the Monday check as a need | Office Desktop | WeighDay.hour, check |
| M19 | No-gi athlete page | scale at the mat; class up (release 2) | NoGi.gd:74 | TO SOURCE |

## 10. Build, in two releases (each file under 500 lines, test red first; owners Claude or the seat Claude names; nothing builds before fresh critics score 6+ / 6+)
**Release 1, the amateur core**

| # | Task | Test red first |
|---|---|---|
| B0 | SAVECAP1: Save +1 an exchange, the next round never above this round's start, live Energy ≤ 100 | Save R1 from 90 reads 111 live today |
| B1 | WEIGHTRULES1: trim price, cap, burn-morning prices, ask rows, Monday rows, miss by room, Energy sum, window | the 8.1 numbers |
| B2 | OPPWEIGHT1: opponent walk, declared weight, fog by tape | one weight on tape and intro |
| B3 | WALKWEIGHT1: walk in the save, drift | Hold drifts back |
| B4 | DIETS1: Lean; Cut as a Monday answer | Lean −0.03 kg a day |
| B5 | WEIGHDAY1: amateurs on the day, the gap, re-weigh, another name, walkover through the loss path, pull out, past cap (with AMATEURWEEK1) | an amateur outside the gap after a re-weigh writes a loss |
| B6 | NIGHTENERGY1: Energy sum for both corners; stale_energy for every booked bout; size edge inside and clinch; the Why line | trim 1.0 starts at 85; size +1 inside at 1.8 kg |
| B7 | EATASK1: ask, three answers, eats anyway, meal prep, nutritionist | discipline 34 asks 35–43 in 100 weekends |
| B8 | CLASSES1: in reach, signing pick, roster clash | two boxers in one class get both options |
| B9 | WEIGHTPANEL1 (M1) | panel = WeightRules |
| B10 | BODYCLASS1 (M2) | tab shows |
| B11 | WEIGHTSHOW1 (M3–M18) | each menu shows its line |
| B12 | WEIGHTGOLDEN1: club show near the walk → re-weigh → made; regional → Sat burned → half a plate → Light refuel → the window in the Why; second run: outside the gap → another name fails → walkover loss | red until B0–B11 |
| B13 | John: no-gi scale, meal-prep and nutritionist prices, EB club gap, championship weigh-in hour, club-show call-off | – |

**Release 2:** pro scale, water, refuel for pros, catchweight, the opponent's miss, repeat misses, short notice, second-day clause, no-gi class up.

## 11. Probes (after B0; headless; P1–P3 first)
- **P1:** the spread between the best and worst sensible plans is 3+ in 100 in 60 of 100 bouts, or the screen leads with the tails.
- **P2:** the size edge at 1.8 kg is worth 1–3 in 100 for an inside style and under 1 for an out-boxer.
- **P3:** "Box near the walk" is outside the gap in 3–12 in 100 club shows, and each D0 answer is best in 20–60 in 100.
- **P10:** the win chance per point of start Energy (the 0.4).
- **P14:** across four starters × three cash levels × goal due or not, no D1 set and no D2 answer is best in more than 60 in 100.
- **P16:** Save R1 + the worst plan beats Steady + the best plan in under 1 bout in 3.
- **P17:** Flat on the night against Steady (the −2).
- **P18:** the window's forecast against the tires line's real fires.
- **P20:** Light against Full refuel: each best in 30–70 in 100 championship bouts.

## 12. Owner questions (scope only)
1. Add women's 70 kg and men's 65 kg (World Boxing classes)? Without them, UP and DOWN are thin for a 65 kg woman.
2. The men's 57.5 kg class isn't a World Boxing class (the nearest is 55). Keep it or change it?

**CHECK (John):** the championship weigh-in hour; the re-weigh window; whether a club show calls the bout off or gives a walkover.
**CHECK (Claude):** the TAPER rest-day recovery value; the plan text "she tires".

## 13. Risks
- B0 changes every fight number, so the 59 / 45 / 41 balance must be re-measured.
- The plan middles differ by 1–2 in 100. P1 decides whether the screen leads with WIN or with the tails.
- Opponent Energy under 100 (B6) is what makes the window real; without it the window is mostly 0–2.
- The club-show walkover may be a call-off in real practice. If John's CHECK says so, M6's last line changes to "bout off, $300 to the club over the gap".

## 14. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6.**

**To reach 10/10:**
1. Run P1–P3 and print the measured spread and gap risk.
2. John's B13 sourcing, especially the call-off rule.
3. Owner questions 1 and 2.
4. Draw M1 at 1920×1080 in two states:
   - **Club show:** D0's three magnets and the line to the scale.
   - **Regional:** the coach's row in gold, one alternative, the Energy curve with the window, the other corner.
5. CLUBWEEK1 v7 and AMATEURWEEK1 adopt this map's scale, gap and Energy word.


# THE CRITICS ON R3

## Critic John: depth 6, general 5, play 6

Sent: 2026-11-14 19:40 | collected: 2026-11-14 20:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading WEIGHT1 round 4 against the pack now, and checking the England Boxing weigh-in rules it leans on. Logic comes first, then the scores, options, To reach 10/10 and the page.

# WEIGHT1 round 4: critic

Scores: **depth 6/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

Round 4 fixes what round 2 asked for:
- names are in headers only;
- money lines show what lands in the club's cash;
- the BBBofC rules are used for pros;
- the plan table folds;
- there's a release cut;
- weight risk is shown as a band.

The arithmetic for the trim in 8.1 checks out: trim 0.59 costs 6.8, so Energy is 93 at the scale and 95 after a Light refuel. What still holds design at 5 are three rules at the heart of the mechanic:
- who loses when two boxers are outside the gap;
- the hour of the championship weigh-in, which the map's own source contradicts;
- the size edge, which the map's own refuel study found makes no difference.

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the map and the pack, and checked the England Boxing rule book and the Reale study myself.

Names: Samira Khan and Kira Mensah appear only in example headers, which is fine. Rows, news and asks say "your boxer" or "your 65 kg boxer". I found no fixed he or she outside the code's own "she tires", which the map flags.

## Logic check

**1. "Outside the gap" has no loser, and the map gives the loss to your boxer.**
- The gap is between two boxers, so when they're 2.3 kg apart, both are outside it. 4.2 says the boxer outside the gap takes a walkover loss, and 8.2 prices "Box near the walk" as outside the gap if the opponent comes in light. So your boxer takes a record loss, −12 mood, −1 member and −2 reputation because the **opponent** came in under their own declared weight.
- That's neither fair nor real. The real check is each boxer against their **own declared weight**, and a mismatch is matched again or called off.
- **Fix:** each corner declares a weight on the offer. The boxer further from their own declared weight is the one at fault. If neither is out by more than the scale tolerance, the bout is off with no fault: no slot fee, no loss.
- The walkover-as-loss question (EB 10.7.2) should stay a CHECK until the text is read. The map's own risk 13 already doubts it.

**2. The championship scale contradicts the rule the map cites.**
- EB rule 7.1.3 says "For domestic boxing, the weigh in should be completed 1 hour prior to boxing commencing", and it doesn't carve out championships.
- The map tags a championship "morning scale and refuel" as EB 7.1.3 REAL. That's the opposite of what the rule says. The Reale numbers (+1.49% women, +2.12% men) come from the **Australian** nationals, which weighed in each morning.
- If England Boxing championships also weigh in 1 hour before, the whole refuel lever (D-R, 4.3, P20) has no basis in release 1.
- **Fix:** find a championship-specific England Boxing rule before building D-R. Without one, release 1 has one amateur scale (1 hour before, the meal only) and refuel moves to release 2 with the pros.

**3. The size edge goes against the study the map uses for the regain.**
- Reale 2017 found regain had "no link to success". In 41 of 85 bouts the heavier boxer won, and in 40 the lighter one did.
- The map uses that paper for the Full refuel weight and then pays +1 a kg inside the ring for it. P2's target of "1–3 in 100 for an inside style" sets the edge to win.
- **Fix:** set P2 to accept about 0. Keep the edge only if the bout model shows a tie-up or clinch effect worth printing. Otherwise cut the size edge, and D0 has to stand on Energy and risk alone (point 4).

**4. D0 collapses to one answer.**
- In 8.2, "Meet the declared weight" is 1 in 100 outside the gap at Energy 100.
- "Come in light" costs 5 Energy and gives away size. It's worse in every way, and the map says so: "Rarely right".
- "Box near the walk" adds a 5–12 in 100 chance of a walkover loss to buy +0 to +1 inside, and point 3 says that's worth about nothing.
- So P3's target, "each D0 answer best in 20–60 in 100", can't pass as the answers are written.
- **Fix:** make the real club-show lever **what your corner declares**. Declare low, and the matchmaker finds a smaller opponent (lower win risk, but a cut). Declare your walk, and you get no cut but a bigger opponent. That's what real club coaches trade, and it uses the code's weight and Energy, not a size edge.

**5. The Write it maths (D5) leaves out two systems that are BUILT.**
- 5 × 3/4 × 9 × 0.8 = 27 counts every fire in the window at full value.
- `PlanRead` pays a line in full only for its first 2 uses in a round. A tiring opponent's window sits mostly in round 3, so 5 fires in one round drop after the second.
- FireLevel fires a line 1 use in 2 at Usable. An undrilled 1-2-3 is Raw, so its moves may not be weapons at all, and the line may not exist.
- With both, 27 falls to about 11–14, below the pressing line's 21. The example's "the player writes it" turns around.
- **Fix:** the D5 unit is fires × FireLevel × the PlanRead taper per round × edge. Print the round split of the window.

**6. The kilo maths uses two different rates.**
- Lean −250 kcal a day becomes "about 0.03 kg a day", which is about 7,700 kcal a kg.
- At that rate, Cut 5 days (5 × 500 kcal) is about 0.32 kg, not the −0.16 kg the map tags CODE.
- **Fix:** read the code's kcal per kg and use one rate. Then re-print D3 and the miss table.

**7. A goal miss is a cliff that decides D1.**
- 8.1 has Defence forecast at 50.64 against a goal of 50.8, which means "missed, −19.9 mood". That's a bigger hit than losing the bout (−12).
- The pack doesn't give the size of a goal miss. If it's about −20, D1 becomes a lookup: never burn a morning that feeds the goal.
- The same example still uses the old summary stat "Technique". Mornings train Attrs abilities since S448.
- **Fix:** print the goal-miss value with its code tag, and state the cost of a burn morning in Attrs abilities.

**8. Tiredness and Energy: a rule change for every bout, priced as a weight detail.**
- Extending `stale_energy` from camps to every booked bout, plus "+1.5 tiredness a day on a Cut", changes every amateur bout, including bouts with no cut.
- The map lists B0 as the reason to re-measure 59/45/41. B6 is just as big.
- **Fix:** run B6 with B0 under one balance re-measure, and tag it in risks.

**9. The fog may never clear.**
- The opponent's weight range clears "after tape 2". An opponent with no bouts has no tape (4.6), and novice club bouts are common.
- Amateur bouts within a week have no camp (S428), so tape days may not exist.
- **Fix:** the declared weight is the fog's centre. With no tape, the band stays wide and says why ("no tape: first bout").

**10. Some options with nothing behind them.**
- **Roster clash (Share shows / One moves):** offers are per fighter, one at a time (4.5). Nothing in the code takes an offer from a second boxer in the same class, and club shows ignore class. Nothing to solve.
- **Test the weight:** no effect is defined.
- **"Let the fighter eat" plus meal prep** (8.1 row 3): meal prep only makes a No hold, so paying $300 and then saying yes buys nothing.
- **D4 round pace:** the Playbook already sets round-by-round pace (4.7). It's a link, not a weight option.

**11. Screens and words.**
- The fighter page gets a new "Body and class" tab (M2) and a "THE WEIGHT" panel (M1). Neither is in an agreed mockup, and pack 7 says screens come only from agreed mockups.
- M3 "Week (renamed)": it's already called Week.
- A walkover win gives +8 members and +5 reputation, the full win. Nobody watched it, so half seems fairer, as a GAME VALUE.
- Two Pull out entries (the Home need, and D3 on the fight-week Monday) plus past the cap is three doors to one action. That's fine if they all go to one screen.

**12. What the real rule book adds.**
- England Boxing matches boxers within the smaller of the two boxers' category widths (2.5 kg when one is in a 2.5 kg category). Use that instead of a flat 2 kg from one club.
- EB 7.1.14's limit on weight change at the weigh-in covers minors, schools, juniors and youth only. Nothing found covers a senior re-weigh, so the 30-minute re-weigh stays a CHECK.
- Reale also found 0.37% more regain before an afternoon bout than a morning one. That's a free real detail if refuel survives point 2.

## Scores, with reasons

**Depth 6.**
- The cut levers carry real, competing tails:
  - a burn morning against the goal and the stat it would have trained;
  - the ask to eat against the mood band edge (Steady to Flat changes how much of the corner's word is taken in);
  - meal prep against cash;
  - a Cut against how tired your boxer is on the fight-week Monday;
  - pulling out against a walkover.
- Energy then feeds the window and the plan's "when the opponent tires" line, so weight touches training, mood, money and the plan.
- Held to 6:
  - D0 collapses to Meet (point 4);
  - the size edge has no real support (point 3);
  - the D5 trade turns around once FireLevel and PlanRead count (point 5);
  - the goal cliff decides D1 (point 7).
- The map's own WIN bands differ by only 1 or 2 in 100, so the depth lives in the tails, not in win chance.

**General design 5.**
- Good: one word list, CODE and REAL tags, menus wired to file lines, a release cut, probes with pass lines, and 26 of 28 critic points answered.
- Held to 5:
  - the gap rule punishes the wrong boxer (point 1);
  - the championship scale contradicts its own source (point 2);
  - the size edge contradicts its own source (point 3);
  - two kilo rates (point 6);
  - D5 leaves out BUILT systems (point 5);
  - an old stat name;
  - options with nothing behind them (point 10);
  - two screens with no mockup (point 11).
- Fixing points 1 to 3 would take it to 6.

**Play 6.**
- The weigh-in is the best moment in the map: the reading, one re-weigh, and finding another name. The scale is real fight-week drama, and the Monday check gives a reason to come back.
- The Why line ("Energy 92 at the bell; the window 4; your tires line fired 3 times") ties a quiet week of choices to fight night.
- But most weeks the coach's row is right within the band, so many players will just accept it.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| D0 Box near the walk | Size (+0 to +1 inside), 5–12 in 100 outside the gap | **Useless** as written (points 3 and 4). Replace with what your corner declares |
| D0 Meet the declared weight | Small cut, about 1 in 100 risk | Keep, as the default |
| D0 Come in light | Costs 5 Energy and gives size away | **Useless**, worse in every way |
| Re-weigh, sweating up to 0.3 kg | −2 Energy per 0.1 kg against a walkover | Keep, as an automatic step. Never refused, so it's not a choice |
| Ask the matchmaker for another name | 1 favour for about 1 in 2 to save the bout | Keep |
| D1 burn mornings | Trim tier and Energy against a stat or the goal | Keep. Print the goal cliff honestly (point 7) |
| D2 Let eat / Half a plate / No | Kilos, mood (+5 / 0 / −5), and eating anyway | Keep. The best of the cut levers |
| Meal prep | $25 a day, a No always holds | Keep. Combining it with Let eat is useless |
| Nutritionist | Asks × 0.5, $100 a week | Keep, for a club with several cutting fighters |
| D3 Trust the trim / Cut 5 days / Pull out | Energy, tiredness, $300 | Keep. Fix the kilo rate |
| Refuel Light / Full | Energy and weight back, −2 in round 1 | **Hold** until a championship scale is sourced (point 2) |
| D4 round pace | Energy across rounds | Already in the Playbook. Link it, don't duplicate it |
| D5 Write it | One plan line | Keep. Fix the maths (point 5) |
| CLASS card: Move now / after the next bout; Hear / Overrule | Class, ladder place, cut per camp | Keep |
| Test the weight | Not defined | **Useless** until it does something |
| Share shows / One moves | Nothing in the code | **Useless** |
| The class at signing | Sets the class for championships | Keep |

**Missing options:**
- **What your corner declares to the matchmaker:** your boxer's own declared weight, which picks who the matchmaker can pair you with. That's the real club-show lever.
- **No-fault call-off when both boxers are off** (point 1).
- **A weight test on a set date** (S370's test system): "65.4 kg by Monday the 9th", a weekly check-in and a personal best for the leanest healthy walk. It turns the long walk into a goal the player can chase without a bout.
- **Ask the opponent's corner to come up 0.5 kg** at a club show, for a favour. It's real club-show haggling, and it's the amateur's only way to change the declared weight after accepting.

## To reach 10/10

1. **The gap rule:** each corner declares a weight on the offer. The boxer further from their own declared weight is at fault. If both are within the scale tolerance but outside the gap, the bout is off with no fault. Read EB 10.7.2 before printing "walkover loss".
2. **One amateur scale for release 1:** 1 hour before, the meal only (EB 7.1.3), unless a championship-specific England Boxing weigh-in time is found. Refuel moves to release 2 with the pros, with Reale's 1.49% / 2.12% and the +0.37% for afternoon bouts.
3. **Size edge:** P2 accepts about 0 (Reale: no link). Drop the edge unless the bout model shows a tie-up or clinch gain worth printing.
4. **Replace D0** with what your corner declares: walk, walk −1 kg, walk −2 kg. Each shifts the matched opponent band and the cut. P3 checks each is best in 20–60 in 100.
5. **The D5 unit** counts FireLevel and the PlanRead taper per round. Print the window's round split.
6. **One kcal per kg rate** from the code. Re-print Cut 5 days and the miss table.
7. **The goal-miss value with its code tag.** Burn-morning costs in Attrs abilities, not Technique.
8. **Run B6** (stale for every bout, Cut tiredness) **with B0** under one 59/45/41 re-measure.
9. **Cut** Share shows / One moves, Test the weight, and the Let eat plus meal prep row. Link D4 to the Playbook instead of duplicating it.
10. **The match gap** is the smaller of the two boxers' EB category widths, not a flat 2 kg.
11. **The weight test** (S370): a target kilo on a set date, a weekly check-in and a personal best on the Body card.
12. **The fog** centres on the declared weight. With no tape, it stays wide and says "no tape: first bout".
13. **The owner OKs mockups** of M1 and the Body and class tab before build, or the weight lives as a block inside Fight prep and Overview's BODY.
14. **Half members and reputation** on a walkover win.

## The 1920×1080 page (Fighter > Fight prep > THE WEIGHT, Look B whiteboard)

**Header (0–120):** the portrait and the fighter's name once, then "65 kg · scale Sat 28, 4 pm (1 hour before) · 12 days". The dark top bar holds CONTINUE, the only green on the page.

**Left third (32–640), the scale line:**
- A marker line on cream paper from today's 65.9 kg to the scale, with the walk as a dotted line at 66.8 and the declared weight as a magnet you can drag (walk / −1 / −2).
- Under the magnet, a polaroid card of the matched opponent band ("declared 65.0 · range 64.5–66.5 · tape opens ±0.5").
- At the bottom, the risk in one row: "Outside your declared weight: 1 in 100 · no-fault call-off if both off".

**Centre (672–1248), the coach's row in the one gold frame:**
- A stacked Energy bar: tiredness at the bell 0, trim −7, meal +0. Below it, "Energy 93 at the bell · miss 2 in 100 · WIN 47–61", with the hover "the coach's row was best in 4 of your last 6 bouts".
- One alternative row underneath ("Sat burned: 94 · costs Speed +0.1"), and "All plans" greyed until the miss risk passes 5 in 100.
- Three sticky notes in a row for the standing answers:
  - **If your boxer asks to eat:** Let eat / Half a plate / No, with each answer's mood and kilos;
  - **If Monday reads over:** Trust the trim / Cut 5 days / Pull out ($300);
  - **Meal prep:** "−$300 from the club, a No always holds".

**Right third (1280–1888), fight night:**
- An Energy curve by exchange (18 dots, rounds 1–3) for both corners, in blue and red.
- The window shaded, with the round split under it ("R2: 1 · R3: 3").
- Your "when the opponent tires" line with its real count: "fires about 2 in R3 after the opponent adjusts (Usable: 1 in 2)", with Write it beside it.
- A weight test card at the bottom: "Target 65.4 kg by Mon 9 · check-ins 3 of 4 · best 65.6".

**Bottom strip (980–1040):** the Monday check as a marker tick box with the date, and the walk drifting back after the bout as a ghost line.

## Sources
- England Boxing, [Rule Book 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final.pdf), read 2026-11-14. OFFICIAL:
  - 7.1.3: "For domestic boxing, the weigh in should be completed 1 hour prior to boxing commencing";
  - 7.1.14: the limit on weight change at the weigh-in is for minors, schools, juniors and youth only;
  - weight matching uses the smaller of the two boxers' category widths;
  - For One Night Only bouts allow 2.5–3 kg differences.
- England Boxing, [Rule Book page](https://www.englandboxing.org/rules-regs-resources/rule-book/), read 2026-11-14. OFFICIAL: the 2026 edition is current.
- Reale, Cox, Slater and Burke, [Weight Regain: No Link to Success in a Real-Life Multiday Boxing Tournament](https://doi.org/10.1123/ijspp.2016-0311) (IJSPP 2017), read 2026-11-14. MEASURED:
  - 100 elite boxers at the Australian nationals, weighed in each morning;
  - regain 1 hour before the bout was 2.12% (men) and 1.49% (women);
  - 0.37% more before afternoon bouts;
  - no link between regain and winning (41 to 40 bouts).
- England Boxing championship weigh-in hour, senior re-weigh window, and EB 10.7.2 walkover wording: NOT FOUND this pass.
- All other figures are DERIVED from the critic pack and the map's own formulas.


## Critic Maria: depth 6, general 5, play 6

Sent: 2026-11-14 19:40 | collected: 2026-11-14 20:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give WEIGHT1 round 4 **DEPTH 6, GENERAL DESIGN 5, PLAY 6**, so it doesn't pass the owner's bar yet. It fixes the round-3 faults:
- Names now sit only in headers.
- Weights are in kg only.
- One energy word is used everywhere.
- The club show and the championship now weigh in differently, which is how amateur boxing really works.
- The plan table folds away until it's needed.

It falls short because the map changes what a missed weight does today, adds a new tab with no agreed mockup, depends on two other designs that aren't built, and admits that its best and worst sensible plans differ by only 1 or 2 bouts in 100.

## Scores

**1. DEPTH: 6/10**

What works:
- **The weight you agree on a club-show offer is a real bet.** Keeping size helps a boxer who fights inside, but it risks being outside the 2 kg gap if the opponent comes in light. Watching tape 2 narrows that risk, so tape study now has a second use.
- **Each lever is paid in a different currency.** Burn mornings cost a stat or the goal. The fighter's ask costs mood or cash. The Monday answer costs Energy or the bout. Different payments make choices that differ from boxer to boxer, as the worked examples show.
- **Tiredness at the bell changes the answer.** A Cut is free for a fresh boxer and costs 14 to 18 Energy for a worn one, so the same plan isn't right twice.
- **The window ties weight to pace and the plan.** Energy at the bell sets how often the "when the opponent tires" line fires. That links three core systems, which is what deeper-not-wider asks for.
- **The real-world fit is good.** In England Boxing, amateurs weigh in on the day. Club shows are matched within a gap, and championships use the class limit. A light refuel against a full one is a real trade at multi-day championships.

What holds it back:
- **The map admits the choices barely change the result.** The WIN middles in 8.1 sit within 1 to 2 points of each other, inside the band. The choice then rests on the side costs (Flat on the night, the goal, cash). That's a real choice, but it's thin. P1 may show the screen should lead with those costs rather than with WIN.
- **The size edge is close to nothing at amateur level.** At a club show it's 0 to +1, and only inside and in the clinch. At a championship it's usually 0. "Keep size" only pays off when P2 says it does.
- **The window only exists if the opponent starts below 100 Energy (B6).** The map says that without it, the window is mostly 0 to 2 exchanges. So half the depth depends on one new rule.
- **Some answers win too easily (see Useless).** Half a plate looks like the safe answer for a boxer with low discipline. Come in light is rarely right.

**2. GENERAL DESIGN: 5/10**

What works:
- Every point from both critics gets an answer.
- The CODE tags match the pack: the $300 empty slot, stale Energy, CUT_DEFICIT, PushBack, morale ±5, the trust bands and the promoter refusing after two ducks.
- One rule for pulling out, shared with the injury pull-out.
- Prices print what lands in the cash tin.
- No pop-ups. Needs sit on Home.
- Release 1 and release 2 are cut cleanly.
- The words table is the best in any map so far.

What fails:
- **It changes a built rule without asking the owner.** Today a missed weight calls the bout off, the club pays $300, and it counts as no loss (pack 4.4). The map turns an amateur outside the gap into a walkover loss, with −12 mood, a member lost, reputation lost and a mark on the record. The map's own CHECK says real club shows may simply call the bout off. That should be owner question 3, not a CHECK left to the researcher.
- **It moves the amateur scale from the day before to the same day.** That's right for the real sport, but it touches every amateur bout, the Home "Weigh in" need and the weigh-in modal. It's shared with AMATEURWEEK1, which isn't built, so release 1 can't ship alone.
- **It leans on other designs that aren't built.** The favour pool belongs to AMATEURWEEK1. CLUBWEEK1 v7 has to adopt this map's Energy word. B0 (the Save fix) changes every fight number. That's three outside dependencies for a release called "the core".
- **It adds a screen nobody agreed.** M2, the Body and class tab, is a new tab on the fighter page, and the CLASS card is a new panel. Pack section 7 says screens come only from agreed mockups. M1 is drawn only as a to-do in the map's own 10/10 list.
- **Odd numbers go unexplained.** A missed goal costs "−19.9 mood after the bout", but the pack gives no goal value of that size: NOT VERIFIED. Cut 5 days is "−0.16 kg (CODE)", but 500 kcal a day for 5 days is about 0.3 kg by the usual 7,700 kcal per kg: NOT VERIFIED. The miss chance by room under the cap is ESTIMATE. No probe has run.
- **The title doesn't match the content.** The map is called R3 but says round 4. The header names "KALLI_KALLI". Small, but it confuses which version is being scored.
- **Weight on the Roster is shown by colour.** Amber and red need a word beside them ("Monday answer ran", "PAST THE CAP").

**3. PLAY: 6/10**

There's a real arc:
- The offer arrives with a weight bet.
- The Monday check lands as a number to sweat over.
- The scale is a moment, with the re-weigh as a tense second step.
- The Why names "Energy 92 at the bell, the window 4, your line fired 3 times".

That's anticipation and a payoff. But the scale only gets tense when the forecast is tight. Most weeks it's a line on Home, and the coach's row is gold for a reason. The fighter's ask is the only part with a person in it, and it never comes for a boxer with discipline of 50 or more.

## Options: missing, useless, and what each changes

**Missing**
- **The owner's choice on a miss:** bout off (today's rule) or walkover loss (EB 10.7.2).
- **Ask the opponent's corner to meet you halfway** at a club show. The two coaches agree a new weight at the scale, which really happens at club shows. It's free when your boxer is inside 2.5 kg, and the opponent's corner may refuse.
- **A plain line for when it doesn't matter:** "Weight is safe: nothing to decide". It sits on Fight prep so the player knows they can skip it.
- **A rough history of how close past scales were**, so the walk and the trim feel earned over a career.

**Useless or near-dominant**
- **Meal prep at $25 a day:** in 8.1 it buys 0.8 Energy for $300. Nobody pays that until money is plentiful. Make it cheaper or give it more effect.
- **Come in light:** gives away size and costs Energy. It only wins if the opponent is a big puncher you want to outlast, and the map itself says it's "rarely right".
- **Half a plate** for discipline under 50: it keeps mood and costs little weight. It's likely best almost every time unless the trim is near its cap. P14 should test it alone.
- **The nutritionist** at $100 a week: it halves asks only for boxers with discipline under 50 who are on a diet. With 3 roster places, that's often zero boxers.

**What each option changes**
- **Box near the walk:** keeps the size edge (0 to +1 inside), with a 5 to 12 in 100 band of being outside the gap.
- **Meet the declared weight:** no edge, Energy 100, outside the gap about 1 in 100.
- **Come in light:** costs the trim's Energy price and gives the size away.
- **Burn morning:** −weight, +1 to 3.4 Energy at the bell, minus that morning's stat. If the morning fed the goal, the goal may be missed.
- **The fighter's ask, Let eat:** +0.5 kg, mood +5.
- **The fighter's ask, Half a plate:** +0.2 kg, no mood change.
- **The fighter's ask, No:** mood −5, and with discipline under 50 the fighter may eat anyway.
- **Meal prep:** −$300 for 12 days, and a No always holds.
- **Monday check, Trust the trim:** costs the trim's Energy.
- **Monday check, Cut 5 days:** −0.16 kg, paid in tiredness.
- **Monday check, Pull out:** −$300, the $450 ticket cut is lost, no loss on the record. At a championship it ends the run.
- **Refuel Light:** gives back a quarter of the trim's Energy price.
- **Refuel Full:** gives back half of it plus 1.5 to 2.1% weight, but costs −2 live Energy in round 1.
- **Re-weigh:** sweat up to 0.3 kg at −2 Energy per 0.1 kg.
- **Another name:** costs 1 favour and works about 1 time in 2.
- **Pace per round:** sets the window and how many exchanges your boxer spends tired.
- **Write it:** adds the "when the opponent tires" line, replacing the weakest line.
- **The CLASS card (Move now, Move after the next bout, Test the weight):** changes the cut every camp, the size edge, the ladder place and how many offers come.
- **Share shows or One moves:** decides who gets the next offer when two of the club's boxers share a class.

## To reach 10/10

1. **Ask the owner about a miss before anything else:** "An amateur outside the gap: bout off with $300 (today) or a walkover loss?" Build only the answer he gives.
2. **Run P1, P2 and P3 now,** with B0 and B6 in a test branch. If the plan spread is under 3 in 100 in most bouts, the panel leads with the side costs ("Flat on the night 2 in 5", "Goal missed", "−$300") and drops the WIN column.
3. **Make release 1 stand alone.** Move the same-day scale, the gap and the re-weigh into WEIGHT1's own B5. Put a club-level stand-in for AMATEURWEEK1's favour pool in its place ("ask the matchmaker: once per 8 weeks"). Nothing in release 1 should wait on another map.
4. **Get M1 and M2 agreed as owner mockups before B9 and B10,** in Look B, at 1920×1080. Fold M2 into the existing Overview's BODY block instead of a new tab if the owner prefers.
5. **Fix the free and dominant answers.** Meal prep drops to $10 a day or also gives +1 Energy. Half a plate costs −2 mood under discipline 40. Come in light is cut, or it gives +2 Energy for one round against a Slugger.
6. **Make the size edge felt or cut it.** If P2 shows under 1 in 100 for every style, drop "keep size" from the club show and make the weight bet purely about the gap risk.
7. **Show the numbers' sources.** Read the goal-miss mood value from the code, or mark −19.9 ESTIMATE. Work out Cut 5 days from the kcal maths.
8. **Words beside every colour** on the Roster and on Home: "PAST THE CAP" and "MONDAY ANSWER RAN" as text.
9. **Add "Weight is safe: nothing to decide"** as the one line Fight prep shows when the forecast miss is under 1 in 100, so most weeks stay one click.
10. **Give the scale a moment.** The weigh-in modal shows the reading ticking up to its number, then MADE or OUTSIDE in words. A re-weigh is the second step, and it's the only weight event that stops the clock.

**My 10/10: Fight prep > THE WEIGHT, 1920×1080, Look B whiteboard**
- **Dark top bar:** the date, cash, and the big CONTINUE reading "to Sat 28, the scale at 9 am".
- **Header:** portrait, name once, 65 kg, the record, and the bout circled in marker ("London regional, 12 days").
- **Left (520 px), THE SCALE:**
  - A drawn bathroom scale.
  - "Now 65.9, on the day 65.2 (limit 65.0)".
  - The walk line, and the room under the cap as a marker bar with the words "0.4 kg room".
  - The miss risk in words ("1 in 100").
- **Centre (860 px), THE PLAN:**
  - The coach's row in the one gold frame, as three magnets: Burn mornings (Tue, Thu, Sat as pickable magnets, each showing its stat cost), If the fighter asks (Let eat, Half, No) and Monday check (Trust, Cut, Pull out).
  - Under each magnet, its price in words.
  - One alternative row in pencil.
  - "All plans" only when the risk is 5 in 100 or more.
  - At a club show this whole area is replaced by the three weight-bet magnets and the gap band.
- **Right (440 px), FIGHT NIGHT:**
  - Energy at the bell as a stacked bar for both corners: tiredness, trim, refuel.
  - The window drawn as shaded exchanges across three rounds.
  - Pace per round as Push, Steady and Save magnets.
  - The "when the opponent tires" line with Write it, and what it replaces.
- **Bottom strip:**
  - The deciding costs in words: "Flat on the night 2 in 5", "Goal: on track", "Cash: no cost".
  - "Too close to call on WIN" when it is.

