# COACHFIT1_V8 - write the NEXT version of this mechanic's design map (S459 design loop)

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


# THE CURRENT MAP (V7)

Sent: 2026-11-14 17:40 | collected: 2026-11-14 18:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: writing COACHFIT1 v7 in full, with sections 11–15 completed and every point from both critics answered.

# COACHFIT1 v7: coaches who fit, fill up, grow, have a temper and bond, design map (S459, 2026-11-14)

Part 1 of 5

Roadmap row COACHFIT1. Designer seat: Kalli. Status: v7, for two fresh critics.

**What v7 does:**
- It answers both v5 critics, Kalli (6/4/5) and Maria (6/4/5).
- It keeps v6's sections 1–10 where they hold and fixes the five places where v6 contradicted itself.
- It writes sections 11–15 (the menus, probes, build, held back, open questions), which v6 lost.
- The bar is 6+ DEPTH and 6+ GENERAL DESIGN (S459).

**Owner rules this map keeps, quoted:**
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Coaches are named only in a card header or a section header. Rows, cells, lines and tooltips say the sessional assistant, the full-time assistant, your coach, your 60 kg boxer, the opponent.
- **S412:** "the player runs any gym with any boxers, men or women". No fixed he or she. v6's "I know what she needs" is rewritten.
- **S425:** the table of every menu and its wiring is section 11.
- **S459 / S405:** reach 6+ / 6+; mark ESTIMATEs; end with To reach 10/10.
- **Pack section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Nothing opens by itself. Weekly jobs never become a pop-up. One word per concept. Screens come only from agreed mockups. Look B (the whiteboard). The facility is a gym; camp is only pre-bout preparation; money in USD; classes in kg.
- **Kit:** green on Continue only, gold on one thing per frame.

**Marks:**
- **CODE:** in the game today.
- **NEW:** must be built.
- **ESTIMATE:** our number, set by a probe.
- **AGREED, NOT BUILT:** from the pack.
- **CHECK (Claude) / CHECK (John):** open.

No probe has run. Every fit, coach time, bond and raise number is ESTIMATE until section 12 runs.

## 0. How v7 answers the critics

### v6's own faults, fixed first
| Fault in v6 | v7 |
|---|---|
| "Energy" for the coach budget, while Energy is fight-night fuel (BoutNight._energy, WEIGHT1 r4) | renamed **coach time**. One word per concept |
| Teaches-up-to printed three ways (66/76 in 3.3 and 9.1, 75/81 in 4.1) | one rule from the area rating: 55 + area rating × 0.35. The sessional assistant teaches Accuracy and Timing up to 81; the full-time assistant teaches Stamina and Recovery up to 86 |
| Temper range "−14 to +12" with no rows reaching it | the honest range is −12 to +10, built from rows that add up (5.2) |
| Fit tops out near ×1.16, so the critics' 10–13-point target can't be reached | gain multiplier = 0.5 + fit ÷ 100 (2.1) |
| Both assistants on 11 coach time, so sessional and full-time cost the same work | sessional 8, full-time 12: the early-game choice (3.3) |
| "Warning 3 days before week lock" | there's no week lock: the warning is a need on Home and a line on the Monday page |
| "I know what she needs"; Stranger −8 on every new pair from day 1 | "I know what's needed"; Stranger −4, and it lasts about 2 weeks |

### Kalli's To reach 10/10 (19 points)
| # | Point | v7 |
|---|---|---|
| 1 | Menu wiring table in full | **Done**, section 11: 21 rows, the Week tab and Club > People included |
| 2 | Pack coach factor; head coach no rating | **Done (7).** 0.5 + rating × 0.7%, no coach 60% (CODE). The head coach runs at the best assistant's factor in that area × 0.9 (ESTIMATE), or 0.60 |
| 3 | Calls heard in pack units | **Done (8).** Trust × coachability step × bond step, cap 1.10. Shown as "your corner's word taken in: 95%"; no per-round count |
| 4 | Delete the Sharp gate | **Done.** POLISH: Usable and Sharp ×1.15 (and New and Raw ×0.9, its price) |
| 5 | Weakest stat becomes Focus match | **Done (2.1).** +10 on the player's FOCUS pick; the weakest stat is the coach's suggestion |
| 6 | Existing staff in one table | **Done (9.1)**, from code stats; the rest marked ESTIMATE |
| 7 | Specify the market or cut it | **Specified (9.3) and moved to release 2.** Release 1 runs on the staff the game has |
| 8 | Sessions to columns to stats | **Done (3.1).** CHECK (Claude) against Attrs |
| 9 | One over-budget rule | **Done (3.4).** Over is allowed and borrowed; nothing runs unassigned because of it |
| 10 | The real bout-week cost | **Done (3.5, 10.3).** A worked week prices the corner against evenings |
| 11 | Caps on growth and raises | **Done (4).** Cap 90; slower above 80; raises stop at 90; "next ask at 79" on the card |
| 12 | Which ceiling binds | **Done (4.1)**, named on hover |
| 13 | No −15 on a swap for good | **Done (6.3)** |
| 14 | Cover, rest week, promote | **Done (3.6, 3.3, 9.1)** |
| 15 | Steady hand automatic | **Done (5.1)** |
| 16 | Cut Copy Last Week and Lock cell; Coach Runs It marked | **Done (14)** |
| 17 | Words and names | **Done.** "60 kg", no names in rows, no emoji, no "Mode A/B", answers in words |
| 18 | Run the probes | **Not done:** I can't run them. Section 12 lists each with its pass line, and nothing builds before they print |
| 19 | A first-season payoff | **Done (6.1, 10.2).** Working in about 2 weeks, Trusted about week 11 (+1 plan line), the first ask or quarrel inside 8 weeks, and the Monday line names the point the fit won |

### Maria's To reach 10/10 (10 points)
| # | Point | v7 |
|---|---|---|
| 1 | Ceiling scale | **Done (4.1).** 55 + area rating × 0.35; warning at 5 below; ×0.5 above, never a hard stop; probe for under 15% tagged in week 1 |
| 2 | Calls from the game's numbers | **Done in part (8).** Morale trust × coachability (0.90 to 1.10) × bond (0.95 to 1.10), cap 1.10, Ring general ×1.25 on top. Not shown as "5 of 6 shouts": the code's unit is the share of the word taken in, and a count would invent a rule. The coachability range is narrower than the 0.8 asked for, so an average fighter keeps today's trust and the 59/45/41 balance holds |
| 3 | Head coach rating from the edge | **Not done.** The pack gives the head coach four edges and no rating, and Kalli 2 asks for the opposite. The head coach runs at the best assistant × 0.9 with the edge applied, so the Strength coach edge makes the head coach right for body mornings. Bond is its own track, not Loyalty: **done** |
| 4 | A choice big enough to feel | **Done.** Fit ×0.60 to ×1.32 (ESTIMATE); Trusted gives +1 plan line in camp; FITPROBE1 targets 10–13 points over 26 weeks; BOTSUITE needs 3+ wins in 100 over the coach's default |
| 5 | Price shared pad nights | **Done (3.2).** 1.5 coach time for two boxers, 240 units split 60/40, the player picks who gets 60, shown on the agreed Coach's pad nights row |
| 6 | The coach pool | **Done (9.3)**, release 2 |
| 7 | Tempers not decided by morale alone | **Done (5).** A mode is set per coach for the week and covers every boxer that coach runs. With two boxers in different states, the mode picks whom to favour. Each mode has a price |
| 8 | Swap rules | **Done in part (6.3).** "Looking for other work" is a Monday line with Pay or Let go. Not done: carrying half the old bond to a new coach, because then trust moves with the boxer and the cost of changing trainers (the one Maria cites) disappears. Also not done: −1 coach time for the old coach, because losing a boxer frees that coach's time |
| 9 | Words and UI | **Done.** "60 kg", morale, modes as a word with an icon, no mobile note, Monday instead of week lock. No pulsing button and no Confirm button: the big CONTINUE is the game's only time button, and the board saves as you edit |
| 10 | Sections 12–15; wire every screen; probes | **Done (11–15).** Probes listed, not run |

### Missing options both critics named
| Option | v7 |
|---|---|
| Focus against the weakest stat | FOCUS pill per boxer (10.1) |
| Coach rest week | "Rest this week": +3 coach time next week, no sessions, bond paused |
| Cover for an away coach | 3.6 |
| Promote the second club coach | 9.1 |
| The coach asks for an area | Trusted+: the coach's request (6.4) |
| Market cadence | 2 a month, at most 3 (9.3, release 2) |
| What a coach changes in the plan | Trusted pair: +1 plan line in camp, within the plan's 4–6 (CODE cap) |
| Above the coach's ceiling | ×0.5 gains |
| A reason to corner with anyone but the highest bond | coach time: the corner costs 3, and the worked week shows when the second-best corner wins (10.3) |

### Useless options both critics named, all cut
- Copy Last Week: the coach already repeats the week.
- Lock cell.
- The Steady hand toggle.
- The −15 on the old pair.
- The hidden "seeking other work" flag.
- Film as its own column.
- Sharp unlock.
- The cutman as a "corner option": it stays a line, on pro nights only.

Part 2 of 5

## 1. The idea
- **The coach writes the week, and you edit it.** Each boxer's week is split into five areas, and each area has a coach. The coach writes the week, including who runs what, and repeats it. You change the exceptions, as on the Week tab today (CODE 4.1).
- **Fit** is how well that coach suits that boxer this week. It moves with bond, temper and mode, the boxer's FOCUS, how stretched the coach is, and how close the boxer is to what the coach can teach. Good fit trains faster and tires less; poor fit does the reverse.
- **Coach time** is the limit. Going over borrows from next week, and the corner on fight night costs 3.
- **Bond** grows slowly, from pad, sparring and corner nights only. It adds plan lines and a corner the boxer listens to.
- **Coaches grow** and ask for raises. Say no and their rating is held, and they work less.

## 2. Fit

### 2.1 Formula
**Fit = 50 + temper and mode + coach time + bond + taught out + focus, clamped 10–90.** At 50 the session runs exactly as today.

| Part | Values | Notes |
|---|---|---|
| Temper and mode | −12 to +10 | 5.2 |
| Coach time | 0 on budget / −8 at 1 over / −18 at 2+ over | on every cell that coach runs that week (ESTIMATE) |
| Bond | Stranger −4 / Working 0 / Trusted +6 / Corner +12 | 6.1 |
| Taught out | 0, or −6 within 5 of the coach's teaches-up-to | at or above it, the ×0.5 in 4.1 replaces this |
| Focus | 0 / +10 | the session's area holds this boxer's FOCUS stat |

- **Gain multiplier = 0.5 + fit ÷ 100:** ×0.60 at 10, ×1.00 at 50, ×1.32 at 82 (ESTIMATE, FITPROBE1).
- **Tiredness multiplier = 1.125 − 0.0025 × fit:** ×1.10 at 10, ×1.00 at 50, ×0.92 at 82.
- **Reachable range:** about 10 to 82. The top needs Corner bond, a suiting temper in the right mode, FOCUS, on budget, and not taught out.
- **The gain chain:** fit multiplies on top of the CODE gain (pace 1.0 per focused week × coach factor × headroom clamp × Light/Normal/Hard). It doesn't replace any of it.

### 2.2 Fit words
| Word | Fit | Gain | Usually means |
|---|---|---|---|
| TOP FIT | 75+ | ×1.25+ | Corner or Trusted bond, FOCUS, suiting temper, on budget |
| GOOD | 58–74 | ×1.08–1.24 | FOCUS, or Trusted with a good mode |
| MIXED | 40–57 | ×0.90–1.07 | Working bond, small mismatch |
| RISKY | under 40 | under ×0.90 | over budget, Stranger, wrong mode, or near taught out |

A RISKY coached morning trains worse than an uncoached one (3.1), so "leave it uncoached" is a real answer.

**Each cell shows** "+1.0 Accuracy this week · GOOD" in half points. Hover lists every part with its points and names the binding ceiling.

## 3. Sessions, coach time and the morning rule

### 3.1 Areas (CHECK Claude: stat names against Attrs.gd)
| Area | Game sessions (CODE) | Stats |
|---|---|---|
| Pads | Pads evenings, Film evenings | Accuracy, Timing |
| Sparring | Sparring evenings | Defence, Inside fighting |
| Conditioning | Roadwork, Intervals | Stamina, Recovery |
| Strength | Weights, Neck work | Strength, Explosiveness, Durability |
| Bag | Heavy bag, Speed bag, Slip rope, Shadow | Speed, Footwork |

**The morning rule:**
- **Evenings** always have a coach: Pads 1.0, Sparring 1.5, Film 1.0 coach time. An evening with no coach free runs at 60%, as with no coach today (CODE).
- **Mornings** run at today's factor unless you assign a coach. Assigning one applies fit and costs Normal 0.5 or Hard 1.5. Light mornings can't take a coach.
- **Unassigned is fit 50,** so nothing gets worse than today unless you choose it.

### 3.2 Shared pad nights
- **Sharing:** two boxers on one pad night cost 1.5 coach time, not 2.0. The 240 drill units (CODE PadWeek) split 60/40, and the player picks who gets the 60. Both boxers earn bond. Three or more boxers need two nights.
- **On the screen:** the agreed **Coach's pad nights** row (pack 6, R55) shows the split, the cost, and what the 40 side gives up ("−0.3 Accuracy this week for your 65 kg boxer").
- **The trade:** sharing saves 0.5 coach time and costs the 40 side about a fifth of its pad gain. That's worth it only when coach time is short.

### 3.3 Coach time a week (ESTIMATE)
| Coach | Coach time | Corner | Notes |
|---|---|---|---|
| Sessional assistant ($450) | 8 | 3 | cheaper, and runs out in a bout week |
| Full-time assistant ($1,090) | 12 | 3 | covers two boxers' evenings plus a corner |
| Head coach (you) | 4 | 3 | the office takes the rest |
| Second club coach ($280) | 2 | none | conditioning mornings only; each costs −5 to that week's members target (it runs the fitness classes) |
| Promoted club coach ($450) | 8 | 3 | 9.1 |

- **Rest this week** (coach card): no sessions, bond paused, +3 coach time next week.
- **The S&C, physio and cutman staff jobs** take no sessions. Each changes its one number (CODE).

### 3.4 Over budget, one rule
- **Over is allowed.** The amount over comes off next week ("next week 7 of 8"), and every cell that coach runs takes the coach-time part of fit.
- **Nothing is unassigned for you.**
- **Warnings:** an amber need on Home when the board goes over, and a line on the Monday page.

### 3.5 The corner in coach time
- **The fight week is cheap for the boxer who fights:** TAPER means light mornings, three rest days and no sparring (CODE). So the corner's 3 competes with the **other** boxers' BUILD or PEAK evenings.
- **The strip:** in a bout week the fight week strip prints the price, for example "Corner Saturday: 3 of 8. Your 65 kg boxer's second sparring night goes to the head coach."

### 3.6 Cover
- **When a coach is away** (a new twist card, "Assistant off sick", NEW), let go, or gone after a third no, their cells go to the other assistant or the head coach at their own fit. Unfilled evenings run at 60%.
- **The coach's suggestion** fills them when the player doesn't.

Part 3 of 5

## 4. Ceilings, growth and raises

### 4.1 Teaches up to (NEW)
- **The rule:** teaches up to = 55 + area rating × 0.35, using the coach's rating in that area. An area with no rating in the code uses the overall rating (ESTIMATE).

| Coach | Code stats | Teaches up to |
|---|---|---|
| Sessional assistant | pads 74, rating 58 | Accuracy and Timing 81; other areas 75 |
| Full-time assistant | pads 58, conditioning 90, rating 74 | Accuracy and Timing 75; Stamina and Recovery 86; other areas 81 |
| Promoted club coach | rating 45 (ESTIMATE) | 70 |

- **Day one:** boxers sit at 55–65 (CODE), so nearly no one is taught out in season one. Probe: under 15% of rows tagged in week 1.
- **Near the ceiling:** within 5, the tag "taught out in about n weeks" and −6 fit.
- **At or above it:** gains ×0.5, never a hard stop.
- **Which binds:** the boxer's potential (CODE headroom) or teaches-up-to, whichever is lower. The hover names it: "slowed by the coach's limit" or "slowed by potential".

### 4.2 Coach growth (NEW)
- **Pace:** +1 to an area rating per 15 coached sessions in that area, or per 25 above 80. Cap 90.
- **School moves:** ×1.10 mastery; outside the school ×1.00; a signature outside the school ×0.5; school plus mode ×1.20 at most.
- **Coach factor stays on the overall rating (CODE).** Area ratings set teaches-up-to and growth only, so the 59/45/41 fight balance doesn't move.
- **At a glance:** the sessional assistant runs about 6 pad sessions a week, so +1 pads about every 2.5 weeks, and pads 79 near week 12 (ESTIMATE).

### 4.3 Raises
- **The trigger:** every 5 area points gained, a request on the Monday page. The card shows "next ask at 79". There are no asks at 90.
- **Pay:** +$50 a week for good. The new rating counts, so teaches-up-to rises.
- **Say no:**
  - The rating is held at the old value until paid, and −1 coach time for 4 weeks.
  - Asked again after 4 weeks.
  - A second no within 12 weeks: −2 coach time for 8 weeks, and the Monday line "Looking for other work: Pay or Let go".
  - A third no: the coach leaves at the week's end. The club pays 2 weeks' wages and cover applies (3.6).
- **Cost over a year** (ESTIMATE, RAISEPROBE1): one busy assistant asks 2–3 times, $100–150 a week. That's about 30–45 dues-paying members at $35 a month, enough to feel on the Money page.

## 5. Tempers and modes

### 5.1 Tempers
**A mode is set per coach, for the week,** and covers every boxer that coach runs. With boxers in different states, the mode chooses whom to favour.

| Temper | Who | Mode | Effect | Price |
|---|---|---|---|---|
| Motivator | sessional assistant (ESTIMATE) | LIFT | a loss's −12 morale becomes −8; Flat and Low boxers +3 morale a week | +0.5 coach time |
| | | SHIELD | twist cards' morale costs −2 smaller | Flat and Low get nothing extra |
| Technician | full-time assistant (ESTIMATE) | POLISH | Usable and Sharp moves ×1.15 | New and Raw ×0.90 |
| | | TEACH | New and Raw ×1.10; +2 mastery on a move one session from its tier | Usable and Sharp ×0.95 |
| Steady hand | promoted club coach; pool | automatic, no toggle | inside 14 days of a bout: tiredness ×0.85, gains ×0.90. Otherwise load-spike injury risk two thirds of normal | the gains price inside 14 days |
| Drill sergeant | pool only (release 2) | PUSH | sparring mastery ×1.25; +3 tiredness; 1 in 6 a week a quarrel with a Flat or Low boxer | the quarrel |
| | | EASE | normal tiredness; no quarrel; bond loss after a quarrel halved | no ×1.25 |

### 5.2 Temper and mode in fit (adds up to −12 to +10)
| | Value |
|---|---|
| Temper suits this boxer | +6. Motivator: morale Flat or Low. Technician: coachability 70+. Drill sergeant: discipline 70+. Steady hand: always +2 |
| Temper clashes | −8. Drill sergeant in PUSH with Flat or Low. Technician with coachability under 30 |
| Mode right for this boxer this week | +4. LIFT with Flat or Low; POLISH when the boxer's FOCUS moves are Usable or Sharp; TEACH when New or Raw |
| Mode wrong | −4 (the reverse of each) |

**Example of the fork:** the full-time assistant runs pads for a boxer drilling Raw moves and one polishing Sharp moves. TEACH is +4 for one and −4 for the other, so the mode is a choice of whom to favour.

**A quarrel** (Home need, red): **Switch to EASE** (no more risk this week), **Move the area** (another coach takes the cell, bond paused), or **Keep going** (−6 bond for that pair, −5 morale, and PUSH continues). Each price is printed on its button.

## 6. Bond (per coach and boxer pair; not club loyalty)

### 6.1 Steps
- **What builds it:** +1 per pad, sparring or corner night together, counted for each boxer on a shared night. +4 after a bout together, win or loss. Mornings build nothing.
- **Decay:** −1 a week with no nights together, shown as hollow pips: "apart".

| Step | Bond | Typical (ESTIMATE) | Fit | Unlocks |
|---|---|---|---|---|
| Stranger | 0 | start | −4 | – |
| Working | 8 | about week 2 | 0 | – |
| Trusted | 45 | about week 11 | +6 | the boxer's ask; the coach's request; +1 plan line in camp (the plan still holds 4–6, CODE) |
| Corner | 110 | about week 26 | +12 | corner bond ×1.10 (8.1) |

**Scarcity:** about 4 bond a week per pair at 3 pad nights and 1 sparring night. A coach running 3 boxers reaches Trusted with all 3 only if every evening is theirs, so 1–2 Trusted pairs per coach is the usual state (ESTIMATE, BONDPROBE1).

### 6.2 Head coach bond
The head coach's bond with each boxer is tracked the same way. It is not the code's Loyalty value, which stays separate (CODE, off the board).

### 6.3 Swaps
- **This week only:** the old pair's bond is paused; −2 fit that week.
- **For good:** the new pair starts at its own bond (Stranger if new). The old pair decays at −1 a week. There's no other penalty, because the price is the bond you leave behind.

### 6.4 Asks (Trusted and above)
- **The boxer's ask** fires when the boxer's Trusted coach isn't on an area that coach can run, at most once a week, and never in a week with a quarrel. The line is "Can I do the fight week with my pads coach?" **Hear:** +5 morale, swap this week only. **Overrule:** −5 morale (CODE MORALE_EVENTS; low coachability hurts more, CODE).
- **The coach's request:** "Let me take the roadwork this week. I know what's needed." **Grant:** +3 fit on that cell this week. **Refuse:** nothing.

## 7. The head coach
- **Coach factor** = 0.5 + rating × 0.007 (CODE); no coach 0.60 (CODE).
- **The head coach has no rating.** In sessions they run at the factor of the best assistant in that area × 0.9 (ESTIMATE), or 0.60 with none.
- **The edges stay as in the code:**
  - **Old hand:** cuts 120 kcal a day easier.
  - **Ex-pro:** one tell at booking.
  - **Amateur coach:** a prospect's exact potential.
  - **Strength coach:** body mornings +10%, craft −10%. Applied in the head coach's own sessions, it makes the head coach the right pick for Strength mornings.
- **Head coach school,** by edge (9.2).
- **No temper,** so the head coach's temper and mode part is always 0.

Part 4 of 5

## 8. The corner and calls

### 8.1 Word taken in
**Word taken in = morale trust × coachability step × corner bond step, capped at 1.10, floor 0.50.**

| Part | Values | Tag |
|---|---|---|
| Morale trust | Fired up 1.05 / Steady 1.00 / Flat 0.85 / Low 0.70 | CODE, unchanged |
| Coachability step | 0.90 + coachability × 0.002: 0.90 at 0, 1.00 at 50, 1.10 at 100 | NEW, ESTIMATE |
| Corner bond step | Stranger 0.95 / Working 1.00 / Trusted 1.05 / Corner 1.10 | NEW, ESTIMATE |
| Ring general | ×1.25 on top | CODE |

- **What stays:** the two-instructions-a-minute rule and the shouts are unchanged. The player always chooses the shout, and the corner coach only changes how much of it lands.
- **Shown** on Fight prep and in the corner minute: the corner coach's portrait and role, and "Your corner's word taken in: 95%".
- **Cutman:** a staff job line on pro nights only ("$150 a pro night: halves post-bout layoffs"), not on amateur nights.

## 9. The staff, schools and the pool

### 9.1 The staff the game has (release 1)
| Coach | Code stats | Temper (ESTIMATE) | School (5 moves, game moves only) | Coach time |
|---|---|---|---|---|
| Sessional assistant: Luke Reid | pads 74, rating 58, $450 | Motivator | Jab, Cross, Lead hook, Check hook, 1-2 | 8 |
| Full-time assistant: Marcus Hale | pads 58, conditioning 90, rating 74, $1,090 | Technician | Body hook, Uppercut, 2-3, 1-2-3, 1-2-3-2 | 12 |
| Second club coach | $280, runs fitness classes | none | none | 2 (conditioning mornings) |

- **Promote the second club coach** (Club > People, NEW): wage +$170 to $450, temper Steady hand, rating 45 (ESTIMATE), coach time 8, school Jab, 1-1, 1-2, Body hook, 3b-3. The fitness classes stop, which takes the +40 from the members target and stops their income. That's the cheap third coach, matching UK clubs that bring a volunteer up through the coaching awards (CHECK John).
- **Both assistants at once:** the second hire card stays open after the first hire. CHECK (Claude): whether the code allows both today. NEW if not.

### 9.2 Head coach school by edge
- Ex-pro: Jab, Cross, Lead hook, Check hook, 1-2.
- Amateur coach: Jab, Cross, Body hook, 1-2, 1-2-3.
- Strength coach: Body hook, Uppercut, 2-3, 1-2-3, 3b-3.
- Old hand: Jab, Lead hook, Check hook, 1-2, 1-6-3.

v6's "Step-back" is not a move with mastery (StrikeMap arrows have none, CODE), so it's replaced. The move bars show "+10% learning: in the pads coach's school".

### 9.3 The coach pool (release 2, NEW)
- **Cadence:** 2 candidates at the start of each month, at most 3 shown, each staying 4 weeks.
- **Each candidate:** a rating of 45–80, rising with club reputation; a temper from the four; a school of 5 game moves; 1–2 area ratings; a wage of $450–1,300 a week by rating (ESTIMATE); signing $1,000 (CODE).
- **Hire** is greyed with its reason (cash, no roster of staff room) when it can't be done.

## 10. The weekly decision

### 10.1 The Staff app, "Coaches this week" (Office Desktop, AGREED, NOT BUILT; Look B)
| Zone | Shows | Actions |
|---|---|---|
| Dark top bar (shell) | week, the next bout circled, "Coach time: 11 of 12 · 3 of 4 · 2 of 2" | the big CONTINUE only. The board saves as you edit |
| Left: coach cards | name in the card header; portrait, role; temper and mode as a word and icon; coach time pips ("borrowed 1"); teaches-up-to per area; growth tick ("next +1 in 6 sessions"); school chips; wage; raise sticky when asked | mode switch, Rest this week, Pay / Say no, Let go (a week's pay), Promote (second club coach only) |
| Centre: who runs what | one row per boxer: portrait, class in kg, record, FOCUS pill (the coach's suggestion is outlined, never set for you). Five columns, each cell with the coach magnet, fit word and bar, "+1.0 Accuracy", bond pips, one tag at most (OVER BUDGET, TAUGHT OUT IN 4 WEEKS, QUARREL RISK) | drag a coach onto a cell, or click: This week / For good; set FOCUS; leave a morning uncoached |
| Right: on Monday | each boxer's FOCUS stat now and after the week; bonds crossing a step; coach growth; next week's coach time; risks in red. The week's best gain gets the one gold frame | none |
| Fight week strip (a bout within 14 days) | corner magnets with word taken in, coach time, bond step, and what moves to cover the cost. Cutman line on pro nights | pick the corner |
| Bottom (release 2) | the coach pool | Hire |

### 10.2 The Monday page lines (the week review; never a pop-up)
- "Accuracy 63 to 64, a week early: good fit with the pads coach."
- "Trusted with your 60 kg boxer: one more plan line in camp."
- "The pads coach asks for $50 a week. Pay / Say no."
- "Next week: 7 of 8 coach time (1 borrowed)."
- "Your 65 kg boxer's Accuracy is near the pads coach's limit: about 5 weeks."
- "Drill sergeant in PUSH: quarrel risk 1 in 6 this week." (release 2)

### 10.3 A worked bout week (header only: week 9, the sessional assistant and the head coach with the Strength coach edge)
- **The roster:** your 60 kg boxer fights Saturday (TAPER: 2 light pad nights, no sparring) at morale Flat, coachability 52, bond with the assistant Working. Your 65 kg boxer is in PEAK: 3 pad nights, 2 sparring nights, 2 Hard weights mornings, FOCUS Accuracy.
- **The assistant's costs:** 2 shared pad nights 3.0, a lone pad night 1.0, 2 sparring nights 3.0, corner 3.0, so **10 of 8.**

| Answer | Assistant | Head coach | What changes (ESTIMATE) |
|---|---|---|---|
| A. Assistant does everything | 10 of 8, so −18 fit on all its cells, next week 6 | 0 of 4 | 65 kg pads goes GOOD 64 to RISKY 46: +1.0 becomes +0.86 Accuracy; word taken in 100%; next week also short |
| B. Head coach corners | 7 of 8 | 3 of 4 | the assistant is on budget; word taken in 95% (Stranger with the head coach) |
| C. Assistant corners, head coach takes the 2 Hard weights mornings | 7 of 8 | 3 of 4 | word taken in 100%; the weights mornings run at the best assistant × 0.9 × the edge's 1.10, about today's value with no fit bonus; bond unaffected |

- **The mode:** LIFT costs +0.5. Under C that's 7.5 of 8, and it lifts the Flat boxer +3 morale. That's worth 0.85 to 1.0 trust if it crosses into Steady.
- **The answer:** C is best this week. A is the trap, and B is right when the head coach already has bond with the 60 kg boxer.

Part 5 of 5

## 11. Every menu it appears on, and what each is wired to (S425)
| # | Menu | What COACHFIT1 shows | Player actions | Wired to today (CODE) | New wiring (NEW) |
|---|---|---|---|---|---|
| M1 | Office Desktop > Staff app, "Coaches this week" | 10.1 in full | assign, swap, FOCUS, mode, rest, corner, pay or refuse a raise, let go, promote | Desktop (S451, built); Staff app AGREED, NOT BUILT; StaffRoles.gd | CoachFit.fit, CoachTime, Bond, StaffBoard |
| M2 | Office Desktop, home | needs: raise, over budget, quarrel; staff panel with coach time | opens M1 | Desktop staff panel | CoachTime.week |
| M3 | Home > needs | raise (amber); over budget (amber); quarrel (red, stops the clock); coach off sick (amber) | open M1 or the choice | Needs.gd | Needs: raise, over_budget, quarrel, cover |
| M4 | Home > THE CLUB THIS WEEK | "Coaches: 11 of 12 coach time" in the coach line | opens M1 | HomeRows.gd | CoachTime.summary |
| M5 | Fighter > Week | each card shows the coach face and fit word; the popover adds "Who runs it" and "Uncoached" for mornings; FOCUS pill in the head; Coach's pad nights row (2 boxers in camp) with the 60/40 pick and cost | change the coach on a card; FOCUS; pick the 60 side | WeekBoard.gd; PadWeek; WeekPlan.day | CoachFit on cards; PadWeek.split |
| M6 | Fighter > Overview | COACH SAYS gains "Trusted with the pads coach"; the attribute hover names the binding ceiling | none (information you act on in M5) | FighterPage.gd | Bond.step; CoachFit.ceiling |
| M7 | Fighter > Playbook > Moves, Combos | "+10% learning: in the pads coach's school" on move bars | none | Mastery | Schools.bonus |
| M8 | Fighter > Playbook > Game plan | "Lines 5 of 6: +1 from a Trusted coach" | write the extra line | PlanBoard line count | Bond.extra_line |
| M9 | Fighter > Fight prep | corner pick with word taken in and coach time | pick the corner | FightPrep.gd | Corner.assign |
| M10 | Fight night: tale of the tape and corner minute | the corner coach's portrait and role; "word taken in 95%" | none new | BoutNight; FighterProfile.trust | Corner.trust_step |
| M11 | Result > the Why | "Corner: word taken in 95%"; "Fit: +1.2 Accuracy over the camp" | none | WhyCard.gd | CoachFit.why_line |
| M12 | Week review (the Monday page) | the 10.2 lines | Pay or Say no; Hear or Overrule | WeekReview.gd | CoachFit.review |
| M13 | Club > People | the same coach cards as M1 (one card, two places); hire cards; Promote | hire, let go, rest, mode, raise, promote | StaffRoles.gd :7-21 | Staff.promote; Raise |
| M14 | Club > Money | "Raise: pads coach +$50 a week"; promotion wage; severance | none new | c.pay; GymBills | Raise.bill |
| M15 | Club > Records | coach joined, raise paid or refused, coach left | filter | Records log | Records.add |
| M16 | Fighters > Roster cards | corner flag "Ask" when the boxer's ask waits | opens M12 or M1 | RosterCards.gd | Needs.ask |
| M17 | Interview / Trial | one line: "Best fit: the pads coach (Motivator)" | none | Interview modal | CoachFit.preview |
| M18 | Week > twist card | "Assistant off sick": cover by the other assistant / the head coach | pick | Twist cards | Twist.coach_off |
| M19 | Top bar | no new flag (agreed top bar: no change); needs reach it through NEEDS YOU | none | Shell flags | none |
| M20 | World > News | nothing; a coach leaving is in Records | none | none | none |
| M21 | No-gi athlete page | unchanged: "who teaches" stays as it is (held back) | none | NoGi.gd | none |

## 12. Probes (headless, before build; none run)
| Probe | Pass line |
|---|---|
| FITPROBE1 | TOP against RISKY on the FOCUS area: 10–13 points over 26 weeks; TOP FIT on 20%+ of rows from week 12; taught-out on under 15% of rows in week 1 |
| BOTSUITE | a hand-made board beats the coach's default by 3+ wins in 100 over a season, and no single board wins in 60%+ of clubs |
| COACHTIMEPROBE | a 2-boxer club with the sessional assistant is over budget in 30–60% of bout weeks; with the full-time assistant, under 20% |
| BONDPROBE1 | Working by week 2–3; first Trusted by week 9–14; at most 2 Trusted pairs per coach in 80% of runs |
| RAISEPROBE1 | 2–3 asks a year for a busy assistant; refusing all 3 costs more fight wins than paying (wins in 100 against cash) |
| MODEPROBE1 | each two-mode temper: each mode is best in 30–70% of weeks across rosters |
| CORNERPROBE1 | Trusted corner against Stranger: the measured win change. If under 1 in 100, the corner pick shows coach time first |
| BALANCE | an average Steady boxer with a Working corner keeps 59 / 45 / 41 |

## 13. Build (each file under 500 lines, test red first; owners Claude or the seat Claude names; nothing builds before fresh critics score 6+ / 6+)
**Release 1, on the staff the game has**

| # | Task | Test red first |
|---|---|---|
| C1 | COACHDATA1: tempers, schools, area ratings, coach time for both assistants and the second club coach; head coach schools by edge | the sessional assistant teaches Accuracy up to 81 |
| C2 | COACHFIT1: fit, gain and tiredness multipliers | fit 50 equals today's gain exactly |
| C3 | ASSIGN1: who runs each area per boxer, written by the coach with the week; uncoached mornings | the coach's default fills every evening |
| C4 | COACHTIME1: costs, over budget borrowed, rest week, corner 3 | 10 of 8 gives next week 6 |
| C5 | PADSPLIT1: shared nights, 1.5, the 60/40 pick | two boxers on one night cost 1.5 |
| C6 | BOND1: steps, decay, swaps, +1 plan line | 45 bond adds a line up to 6 |
| C7 | CORNER1: word taken in | Steady, coachability 50, Working reads 1.00 |
| C8 | MODES1: Motivator, Technician, Steady hand | POLISH Raw ×0.90 |
| C9 | GROWTH1: area growth, caps, raises, refusals, leaving | a third no ends the contract |
| C10 | ASKS1: boxer's ask, coach's request, quarrel answers | the ask never fires in a quarrel week |
| C11 | PROMOTE1, COVER1 (the twist card) | promotion stops fitness class income |
| C12 | STAFFBOARD1 (M1) | board = CoachFit |
| C13 | COACHSHOW1 (M2–M18) | each menu shows its line |
| C14 | COACHGOLDEN1: the 10.3 week, answer C, then Monday shows the lines | red until C1–C13 |

**Release 2:** the coach pool and the Drill sergeant; Coach runs it (when agreed and built).

## 14. Held back
- **Coach market:** release 2.
- **Coach runs it:** AGREED, NOT BUILT, not shown.
- **Copy last week and Lock cell:** the coach already repeats the week, and nothing moves cells.
- **A head coach rating:** none in the pack.
- **Carrying bond across coaches.**
- **No-gi coaches on the board.**
- **Rival gyms poaching coaches:** waits on the rival gym.
- **A top-bar flag.**
- **Coach lines in News.**

## 15. Open questions
- **CHECK (Claude):**
  - Can both assistants be hired together?
  - Which rating does WeekPlan read today for a pad session: pads or overall?
  - Does a shared pad night already count per boxer?
  - The area-to-stat names against Attrs.gd.
- **CHECK (John):**
  - UK amateur clubs: how volunteers move to paid coaching through the England Boxing coach awards.
  - Real sessional coach pay rises, to set the $50.
- **Owner:**
  - May a refused coach leave (the third no), or should refusals cap at the held rating?
  - Is the pool in release 1 or 2?

## 16. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6.**

**To reach 10/10:**
1. Run FITPROBE1, BOTSUITE, COACHTIMEPROBE and BALANCE, and print the measured numbers in place of every ESTIMATE in 2.1, 3.3 and 8.1.
2. Claude's four CHECKs, especially both assistants at once and the rating WeekPlan reads.
3. Draw M1 at 1920×1080 in two states: a quiet BUILD week, and the 10.3 bout week with the fight week strip.
4. The owner's two answers.
5. Release 2: the pool and the Drill sergeant, with MODEPROBE1 passing.


# THE CRITICS ON V7

## Critic John: depth 6, general 5, play 6

Sent: 2026-11-14 18:40 | collected: 2026-11-14 19:12 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading COACHFIT1 v7 against the pack now. Logic first, then the scores, options, To reach 10/10 and the page.

# COACHFIT1 v7: critic

Scores: **depth 6/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

v7 is far tighter than a typical map. It has one formula for fit, honest marks, a full wiring table and probes with pass lines. What holds design at 5:
- the evening half of the system trains stats, but in code evenings train move mastery;
- the worked bout week, which is meant to prove the choice, has arithmetic that doesn't hold;
- "focus" now means three things;
- release 1 may have only one assistant, and most of the depth needs two.

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the map and the pack.

Names: rows, Monday lines and menu text keep to S448. The names appear only in table 9.1 of the design doc ("Sessional assistant: Luke Reid"), which is fine for a doc but must never reach a screen. I found no fixed he or she (S412).

## Logic check

**1. Evenings train moves, not stats. This is the biggest fault.**
- In the pack (4.1, 4.2, S448), each morning adds a small amount to one stat. Pad and sparring nights carry drill cards and raise move mastery: 240 units a pad night, 180 shared on a sparring night.
- Table 3.1 maps Pads evenings to Accuracy and Timing, and Sparring to Defence and Inside fighting. 10.3 then prices pad nights in "+1.0 Accuracy". That's a new stat gain on evenings that the code doesn't have, and it isn't tagged NEW.
- **Fix:** fit multiplies the **drill units** on evenings (240 × 1.14 at GOOD) and the **stat gain** on mornings. Then fit feeds FireLevel (Usable 30, Sharp 60), which ties coaches to the plan. The better design was already there for free.

**2. The worked bout week (10.3) doesn't add up, and it's the map's proof of choice.**
- **Answer C doesn't reduce the assistant's load.** The assistant's 10 is pads 3.0, lone pad 1.0, sparring 3.0 and corner 3.0. The two Hard weights mornings were never in it. Moving them to the head coach leaves the assistant at **10 of 8**, not 7. For C to work, the head coach has to take an evening: a sparring night (1.5) plus the lone pad night (1.0) gives 7.5 of 8 and 2.5 of 4.
- **Fit 46 is MIXED, not RISKY.** The fit table puts RISKY under 40. And 0.96 ÷ 1.14 gives +0.84, not +0.86.
- **The "word taken in" figures ignore morale.** The fighting boxer is Flat, so trust is 0.85 before anything else:
  - A or C: 0.85 × 1.004 × 1.00 = **85%**, not 100%;
  - B: 0.85 × 1.004 × 0.95 = **81%**, not 95%.
  The Flat boxer is the reason LIFT is in the example, so the example has to show the 85%.
- The shared pad nights split the PEAK boxer's pad units 60/40 in its hardest week, and no answer prices that.

**3. "Focus" now means three things.**
- There's the signing "starting focus", the camp focus (Conditioning, Power, Technique, Defence, Speed: the old summary stat names), and the new FOCUS pill.
- In camp, the camp focus and the FOCUS pill can point at different stats.
- POLISH and TEACH also test "the boxer's FOCUS moves", but FOCUS is a stat, so FOCUS moves aren't defined.
- **Fix:** one word per concept. In camp, the FOCUS pill **is** the camp focus, locked to it. Outside camp, it's the pill. Rename the camp list onto Attrs names. The mode test reads the moves on this week's drill cards.

**4. The head coach and the cheap third coach.**
- Pack 5.7 shows two hire cards when there's no assistant, "Hire Luke / Hire Marcus", which reads as one or the other. If the CHECK finds only one assistant can be hired, release 1 is one assistant plus you (4 coach time). Then the mode forks between coaches, swaps, the second-best corner and the shared-night pick mostly disappear.
- **Fix:** answer that CHECK before scoring v8. If it's one assistant, make the promoted club coach the release 1 second coach and design for that pair.
- The head coach is a Stranger to every boxer on day 0, though they're the owner who signed them. Start the head coach's pairs at Working.

**5. The promotion breaks England Boxing's real rules.**
- A Level 1 Assistant Coach "cannot take sparring", can only assist under a Level 2, and "can corner a boxer in competition". Level 2 needs at least one year at Level 1.
- The promoted club coach should:
  - corner (allowed);
  - run pads, bags and conditioning;
  - **not** run sparring nights, until a Level 2 step at least 52 weeks later.
- That's a real, cheap second coach with a limit you plan around, and a second growth beat (the Level 2 course).

**6. The raise pays for a ceiling nobody reaches in season one.**
- Coach factor stays on the overall rating (4.2), so growth only moves the teaching ceiling. The map's own day-one note says boxers at 55–65 are almost never taught out against ceilings of 75–86.
- So paying $50 a week buys nothing for about a year, and refusing costs only −1 coach time for 4 weeks. Refusing is the dominant early answer.
- **Fix:** a raise also adds coach time (+1), or a paid pair grows bond 25% faster. Or area growth also lifts the coach factor in that area only, with BALANCE probing it.
- **The raise money is wrong.** $100–150 a week is about 12–19 members at $35 a month ($8.08 a week each), not 30–45.
- **The pace is wrong.** +1 per 15 pad sessions at about 6 a week gives a raise every 12.5 weeks, so about 4 asks a year, not 2–3. If "every 5 area points" sums across areas, it's more. Say per area or summed.

**7. Borrowing coach time can spiral.**
- 10 of 8 leaves next week at 6, and a PEAK week at 6 goes over again.
- Fractions aren't covered: is 0.5 over −8 or nothing?
- **Fix:** at most 2 borrowed. 0 to 0.5 over is free, up to 1.5 over is −8, and over that is −18.

**8. Quarrels have no source in release 1.**
- Only the Drill sergeant quarrels, and it's release 2. Yet the quarrel need (M3), the QUARREL RISK tag, three quarrel answers and an ASKS1 test are all release 1.
- **Fix:** move them to release 2, or give the Technician a release 1 clash (a coachability-under-30 boxer in POLISH: 1 in 8 a week).

**9. Modes: SHIELD barely counts, and the Motivator lowers fit for Steady boxers.**
- With no Flat or Low boxer, LIFT is "wrong" (−4), so the player must toggle to SHIELD every week. SHIELD's "price" ("Flat and Low get nothing extra") isn't a price, and whether twist cards cost morale at all isn't in the pack.
- **Fix:** let SHIELD be the Motivator's base state at 0, with LIFT as a paid boost. Or give SHIELD a real job: halving the morale cost of a loss for every boxer, at 0 coach time.
- TEACH's "+2 on a move one session from its tier" is a cliff the player can't see. Drop it and keep ×1.10.

**10. Gaps against the stats and the code.**
- **Film evenings** sit under Pads and train Accuracy and Timing. In code, Film opens tells. If it gives anything, Fight IQ fits.
- Flexibility, Fight IQ, Composure and Heart are in no area.
- **Steps (S463 `StepMastery`)** are learned in the study slot on pad nights at about 6 a week. Fit should multiply that too, and the map never mentions it.
- The extra plan line from Trusted does nothing when the coach already gives 6. Say "+1, up to 6", or let Trusted raise the cap to 7.
- The 0.50 floor on word taken in never binds: the lowest is 0.70 × 0.90 × 0.95 = 0.60.
- Rounding: 55 + 90 × 0.35 = 86.5, and the map gives 86. 55 + 45 × 0.35 = 70.75, and it gives 70. Pick one rounding.

**11. Fit could beat the plan, against the game's own rule.**
- FITPROBE's target of 10–13 more points on the FOCUS stat over 26 weeks is close to the pack's "10 points better wins about 95%" (that's on overall stats, but still).
- BALANCE only checks the corner, not the training.
- **Fix:** add a probe that TOP against average fit over a season moves bout wins by no more than the plan does (+14 in 100). Run it with the pack's headroom clamp, which will eat part of the gain.

**12. A second weekly page.**
- The Week tab per boxer stays, and M1 adds a club-wide board in an Office app that's AGREED, NOT BUILT and has no mockup the owner has OK'd.
- Pack 7: screens come only from agreed mockups, and weekly jobs mustn't turn into chores.
- **Fix:** the coach's default must be good enough that a player who never opens M1 loses nothing (BOTSUITE's other side). Get the owner's OK on a mockup of M1 before building.

**Real-world support:** Jowett's 3+1Cs research (closeness, commitment, complementarity, co-orientation) ties good coach-boxer relationships to faster skill learning and reaching performance goals. That backs bond as a slow, per-pair track that pays in learning.

## Scores, with reasons

**Depth 6.**
- Real trades:
  - coach time against the corner's 3;
  - who gets the 60 on a shared night;
  - a mode that favours one boxer over another;
  - leaving a morning uncoached when the fit is poor;
  - bond you lose by swapping;
  - a raise against a coach who works less.
- It touches training, mastery, the plan, the corner, morale and money.
- Held to 6:
  - refusing raises is dominant in year one (point 6);
  - SHIELD barely counts (point 9);
  - quarrels have no source in release 1 (point 8);
  - with one assistant, most forks collapse (point 4).

**General design 5.**
- Good: one fit formula, honest CODE, NEW and ESTIMATE tags, 21 wired menus, probes with pass lines, and the v6 faults fixed.
- Held to 5:
  - evenings train stats against the code (point 1);
  - the showcase week's arithmetic is wrong in three places (point 2);
  - focus means three things (point 3);
  - the raise money and pace are wrong (point 6);
  - borrowing can spiral (point 7);
  - quarrels are built with no cause (point 8);
  - Film and steps are left out (point 10).
- Fixing points 1 to 3 alone would take it to 6.

**Play 6.**
- Working in 2 weeks, Trusted near week 11 with a visible plan line, asks and raises on the Monday page, and the Why naming what the fit won: all good reasons to come back.
- But the moments are small multipliers on numbers. The one live decision (the bout week) is muddied by its own example.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Drag a coach onto a cell (This week / For good) | Fit on that cell; bond builds with that pair; coach time | Keep |
| Leave a morning uncoached | Fit 50, no coach time | Keep. A real answer when fit is RISKY |
| FOCUS pill | +10 fit in that area | Keep, but merge with camp focus (point 3) |
| Shared pad night, pick the 60 side | Saves 0.5 coach time; the 40 side loses about a fifth of its pad gain | Keep |
| Mode switch (LIFT/SHIELD, POLISH/TEACH) | Whom the coach favours this week | Keep POLISH/TEACH. SHIELD is **nearly useless** as written (point 9) |
| Rest this week | +3 coach time next week, no sessions | Keep. It's the cure for borrowing |
| Pick the corner | Word taken in against coach time | Keep, with the morale term shown |
| Pay / Say no to a raise | $50 a week against −1 coach time | Keep, but paying needs a year-one payoff (point 6) |
| Let go (a week's pay) | Frees the wage; cover takes the cells | Keep |
| Promote the second club coach | A cheap third coach; fitness classes stop | Keep, with the England Boxing sparring limit (point 5) |
| Boxer's ask: Hear / Overrule | ±5 morale, swap this week | Keep |
| Coach's request: Grant / Refuse | +3 fit on one cell; refusing costs nothing | **Near useless.** Grant is always right. Give it a cost (it takes 0.5 coach time from another cell) or cut it |
| Quarrel answers | Bond and morale costs | **Useless in release 1** (point 8) |
| Twist card "Assistant off sick" | Cover choice | Keep |
| Interview line "Best fit: the pads coach" | Nothing to act on at signing | **Useless** under the pack's rule. Move it to the boxer's first Monday |

**Missing options:**
- **Drill a step with a chosen coach:** fit on the S463 study slot.
- **Send the club coach on the Level 2 course:** about 52 weeks after promotion, a fee, and it opens sparring nights.
- **Take a boxer yourself as head coach for good:** a head coach bond track starting at Working, with a visible cost in office time.
- **Pay with time, not money:** a raise answered with "+1 day off a week" (−1 coach time for good, no cash). That's a real UK club answer for volunteers.
- **Forgive the borrowed time:** the Rest this week button shown on the over-budget need itself.

## To reach 10/10

1. **Fit multiplies drill units on evenings and stat gain on mornings.** Remove the evening-to-stat map. The Monday line says "Jab 41 to 47: good fit with the pads coach". Fit then speeds FireLevel tiers.
2. **Rewrite 10.3 so it adds up.** Under C the head coach takes the lone pad night and one sparring night (7.5 of 8 and 2.5 of 4). Print the word taken in with Flat morale (85% Working, 81% Stranger) and the LIFT case that crosses to Steady (100%). Fit 46 is MIXED. Price the PEAK boxer's 60/40 split.
3. **One focus.** The FOCUS pill is the camp focus in camp. Camp focus uses Attrs names, and mode tests read this week's drill cards.
4. **Answer "can both assistants be hired" before v8.** If not, design release 1 for one assistant plus the promoted club coach plus you.
5. **The England Boxing rule for the promoted coach:** pads, bags, conditioning and corner, no sparring nights. A Level 2 course after 52 weeks, for a fee, opens sparring (+2 coach time, teaching ceiling +5).
6. **Give the raise a payoff in year one:** paid means +1 coach time for good, or bond grows 25% faster with that coach. Fix the cost line to "about 12–19 members" and the pace to 3–4 asks a year per area, or sum across areas and say so.
7. **Cap borrowing at 2.** Up to 0.5 over is free. The over-budget need carries the Rest this week button.
8. **Quarrels:** move them to release 2, or give the Technician a release 1 clash with a printed chance.
9. **Modes:** SHIELD is the free base and LIFT a +0.5 boost. Remove TEACH's +2 cliff.
10. **Fill the gaps:** Film gives Fight IQ or nothing. Fit applies to the step study slot. "+1 plan line, up to 7" for Trusted. Drop the 0.50 floor. One rounding rule.
11. **A balance probe on training:** a season of TOP fit against average must not move bout wins more than a good plan does (+14 in 100), with the headroom clamp on.
12. **The head coach starts at Working** with every boxer the club signs.
13. **The owner OKs a mockup of M1 before build.** BOTSUITE also checks that a player who never opens M1 loses under 2 wins in 100.

## The 1920×1080 page (Office > Staff, "Coaches this week", Look B whiteboard)

**Dark top bar (0–64):** the week, the bout circled ("Sat, 60 kg"), cash, and CONTINUE in green, the only green on the frame.

**Left column (32–452), coach cards on cream paper:** three magnets stacked, each 128 px tall.
- The name in the card header, once, then the portrait and role (sessional assistant, head coach, club coach).
- The temper word with an icon, and the mode switch (SHIELD | LIFT +0.5).
- Coach time pips "7.5 of 8", with hollow pips for borrowed and a cap mark at 2.
- Teaching ceiling per area as five short ticks, and the school as five move chips.
- Growth: "Pads 76 · next +1 in 6 sessions".
- The wage, then **Rest this week** and **Let go**.
- When asked, a yellow sticky: "Asks +$50: +1 coach time for good · Pay / Say no".
- The club coach card shows "No sparring nights (Level 1)" and **Send on the Level 2 course**.

**Centre (484–1436), who runs what:** one row per boxer, 96 px each.
- The portrait, "60 kg", the record and the FOCUS pill (locked to the camp focus during camp).
- Seven evening and seven morning slots folded into five area cells, each with:
  - the coach magnet, the fit word and a 0–90 bar;
  - the gain in its real unit ("+58 units Jab" for an evening, "+0.4 Speed" for a morning);
  - bond pips;
  - at most one tag (OVER BUDGET, TAUGHT OUT IN 4 WEEKS, NO SPARRING: LEVEL 1).
- Hovering a cell lists every fit part and the binding ceiling.
- The shared pad night is a split magnet with a 60/40 handle and "−0.3 of a pad night for the 40 side".

**Right column (1468–1888), on Monday:**
- Each boxer's FOCUS number now and after the week.
- Bonds crossing a step ("Trusted next week: +1 plan line").
- Next week's coach time per coach.
- Risks in red.
- The one gold frame on the week's best gain.

**Bottom strip (fight week only, 880–1040):** the corner choice as three magnets.
- **Assistant:** word taken in **85%** (Flat · Working), costs 3, which leaves "the 65 kg boxer's lone pad night to the head coach".
- **Head coach:** **81%**, costs 3 of 4.
- **LIFT this week:** "+3 morale, Flat to Steady by Saturday: 100%".
- Picking one moves the cells it displaces, shown greyed for a beat.

**Pairs with:** the Week tab card showing the same coach face and fit word, and the Monday lines in the real unit.

## Sources
- England Boxing, [Coaching Rules Policy (Feb 2026)](https://www.englandboxing.org/wp-content/uploads/2026/02/Coaching-Rules-Policy-Updated-Feb-26.pdf), read 2026-11-14. OFFICIAL: a Level 1 Assistant Coach can't take sparring or run a club and can corner in competition; Level 2 needs a minimum of one year at Level 1.
- England Boxing, [Coaches](https://www.englandboxing.org/coaching/), read 2026-11-14. OFFICIAL: three levels; Level 1 is a 4-day course and assists ringside and in supervised sparring.
- England Boxing, [Coaching Handbook Part 1](https://www.englandboxing.org/wp-content/uploads/2026/02/EB_Boxing-Coaching-Handbook-Part-1_09_02_26.pdf), read 2026-11-14. OFFICIAL: Level 1 delivers bags and pads, warm-ups and circuits.
- Jowett, [The coach-athlete relationship within a cross-boundary team of experts](https://www.tandfonline.com/doi/full/10.1080/1750984X.2024.2416968), read 2026-11-14. MEASURED (review): good-quality relationships are linked to learning skills and reaching performance goals.
- Real sessional coach pay rises (the $50): NOT FOUND, not researched this pass.
- All other figures are DERIVED from the critic pack and the map's own formulas.


## Critic Maria: depth 7, general 6, play 6

Sent: 2026-11-14 18:40 | collected: 2026-11-14 19:12 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give COACHFIT1 v7 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it reaches the owner's bar, just. It fixes v6's contradictions. It now has one word for the coach's budget (coach time, no longer "energy"), one rule for how high a coach can teach, a fit range that adds up, and sessional against full-time as a real early choice. The worked bout week (10.3) proves the corner costs something. It stays at 6 on general design because a lot of new rules sit on top of a week the game already has, the coach's default may beat a hand-made board, and nothing is probed yet.

## Scores

**1. DEPTH: 7/10**
What works:
- **The corner costs coach time,** so cornering competes with the other boxers' PEAK evenings. The worked week shows a trap (A), a fair answer (B) and the best answer (C).
- **Modes are a fork:** TEACH helps the boxer on Raw moves and hurts the one on Sharp moves, so a mode picks whom to favour.
- **Shared pad nights:** 1.5 coach time against a fifth of the second boxer's gain.
- **Bond is scarce:** 1 or 2 Trusted pairs per coach, and leaving a pair costs the bond you built.
- **Raises:** pay, or a held rating and a coach who works less.
- **Promoting the club coach** costs the fitness classes and 40 members.
- **Real fit.** Real small clubs work this way: the head trainer can't hold every pad night, a volunteer gets brought up, and the corner goes to whoever the boxer listens to.

What holds it back:
- **The coach's default may be good enough.** BOTSUITE asks for only 3 wins in 100 over a season for a hand-made board. If the default writes a sound board, most players never open it, and the depth stays hidden.
- **Fit stacks five parts** (temper, mode, coach time, bond, focus) on top of the existing chain (pace × coach factor × headroom × intensity). Gain runs from ×0.60 to ×1.32. With PEAK CAMP and the camp focus multiplier as well, a TOP FIT camp could outgrow the 59/45/41 balance. BALANCE only tests an average boxer.
- **Focus +10 is always on** for whichever area holds the FOCUS stat, so the right cell is always the FOCUS cell. That's a small default, not a choice.

**2. GENERAL DESIGN: 6/10**
What works:
- Every critic point gets a row: done, done in part, or refused with a reason.
- Code numbers are kept: coach factor, morale trust, Ring general ×1.25, the 4–6 plan line cap.
- No names outside headers, no fixed pronouns.
- No week lock, no new top-bar flag, no pop-up.
- Useless options cut.
- 21 menus wired, with honest NEW and CODE columns.

What fails:
- **The main screen is in an app that isn't built.** M1 lives in the office desktop's Staff app, which the pack says is AGREED, NOT BUILT. Its look needs an agreed mockup first (pack section 7). Club > People could carry the board in release 1.
- **The evening rule changes today's training.** "An evening with no coach free runs at 60%" applies the no-coach rule per evening. Today one hired assistant covers every evening at the coach factor. With the sessional assistant at 8 coach time, two boxers in a normal week (3 pad + 1 sparring each, about 9 coach time) are over budget every week, not only in bout weeks. COACHTIMEPROBE expects 30–60% of bout weeks; the sums suggest more. Re-check that one boxer plus the sessional assistant stays on budget in BASE.
- **"Mornings build nothing" for bond, but most fit parts apply to mornings.** Assigning a morning coach for Stranger fit (−4) makes a coached morning worse than an uncoached one until bond grows, and bond can't grow there. The map says "leave it uncoached" is a real answer. On day one it's the only answer.
- **The head coach at "the best assistant × 0.9"** means the head coach gets worse when there's no assistant, and better the moment one is hired, with no rating of their own. It's honest to the pack but odd to read. Hover must explain it.
- **Coach growth +1 per 15 sessions** with the full-time assistant at conditioning 90 already maxed. Growth only matters for the sessional assistant and the promoted club coach. Fine, but say so.
- **Colour:** fit words are written (TOP FIT, GOOD, MIXED, RISKY) and that's good. But "risks in red" on the Monday column, and the quarrel need in red, need words beside them.
- **CHECKs that change the sums:** whether both assistants can be hired together, which rating WeekPlan reads, and whether a shared night already counts per boxer.

**3. PLAY: 6/10**
There's a first-season arc: Working in about 2 weeks, Trusted around week 11 with a visible extra plan line, the first raise or quarrel inside 8 weeks, and Monday lines that name the point the fit won ("Accuracy 63 to 64, a week early"). The corner's word taken in shows on fight night. But the gains are small and spread out (+1.0 against +0.86), and most weeks the player confirms the coach's board. The moments that feel like something (a quarrel, a raise, a coach leaving) are rare by design.

## Options: missing, useless, and what each changes

**Missing**
- **A clear default line:** "Coach's board: n in 100 below your best last month", so the player knows when editing is worth it.
- **A cap on stacking:** fit, camp focus and PEAK CAMP together shouldn't pass a set gain (EXAMPLE ×1.6).
- **Bond from mornings at a low rate** (+0.5 for a Hard coached morning), so a morning coach isn't always a loss on day one.
- **A release-1 home for the board** on Club > People, until the Staff app is built.

**Useless or near-dominant**
- **Coaching a Normal morning with a Stranger pair:** fit 46, worse than uncoached and costs 0.5.
- **SHIELD mode:** twist morale costs −2 smaller, against LIFT's −12 to −8 and +3 a week. LIFT almost always wins.
- **The coach's request** ("Let me take the roadwork"): +3 fit, refuse costs nothing. It's free to grant, so always granted.

**What each option changes**
- **Assigning a coach to a cell:** that cell runs at fit (×0.60 to ×1.32 gain, ×1.10 to ×0.92 tiredness) and costs coach time.
- **Uncoached morning:** today's gain, no cost.
- **FOCUS:** +10 fit on that stat's area.
- **Mode:** LIFT (a loss −8 not −12, Flat and Low +3 morale, +0.5 time), SHIELD (twists −2), POLISH (Usable and Sharp ×1.15, New and Raw ×0.90), TEACH (the reverse), PUSH or EASE (release 2).
- **Shared pad night:** 1.5 coach time, 60/40 split you pick.
- **Rest this week:** no sessions, bond paused, +3 coach time next week.
- **Corner pick:** 3 coach time; word taken in from morale × coachability × bond, capped 1.10.
- **Swap this week:** −2 fit. **Swap for good:** new pair from its own bond, old pair decays.
- **Raise:** pay +$50 a week, or a held rating, −1 coach time, then −2 and "looking for work", then the coach leaves.
- **Promote the club coach:** +$170, 8 coach time, Steady hand; fitness classes and +40 members stop.
- **The boxer's ask:** hear +5 morale, overrule −5.
- **Quarrel:** EASE, move the area, or keep going (−6 bond, −5 morale).

## To reach 10/10

1. **Check the everyday budget.** Price an ordinary BASE week for one and for two boxers with each assistant. If the sessional assistant is over budget in a normal two-boxer week, raise it to 10 or make a pad night cost 0.75. Pass line: one boxer plus the sessional assistant is on budget in every BASE week.
2. **Prove the board is worth editing.** BOTSUITE's pass line becomes 5+ wins in 100 a season, or the Monday page prints "Coach's board: n in 100 below your best last month" so the player knows when to look.
3. **Cap stacking.** Fit × camp focus × PEAK CAMP stops at a probed ceiling. BALANCE runs on a TOP FIT camp as well as the average one.
4. **Fix the morning trap.** Hard coached mornings build +0.5 bond, or a Stranger's −4 doesn't apply to mornings.
5. **Price the free options.** SHIELD also halves a quarrel's bond loss. The coach's request costs −2 bond when refused and +3 fit when granted.
6. **Put the board on Club > People in release 1,** with an owner-agreed mockup. Move it to the Staff app when that app is built.
7. **Words beside every red:** "QUARREL" and "OVER BUDGET" print as text on the Monday column and Home.
8. **Settle the three CHECKs that change the sums:** both assistants at once, the rating WeekPlan reads, and whether a shared night counts per boxer.
9. **Run FITPROBE1, COACHTIMEPROBE, BONDPROBE1 and BALANCE,** and replace each ESTIMATE in 2.1, 3.3, 6.1 and 8.1.
10. **Make Trusted felt.** When a pair reaches Trusted, the Monday line lands last as the week's surprise, and the new plan line opens with "Write it" on the Game plan.

**My 10/10: Coaches this week, 1920×1080, Look B whiteboard (Club > People in release 1)**
- **Dark top bar:** the week, the next bout circled, coach time per coach as "7 of 8", and the big CONTINUE.
- **Left (440 px), COACH CARDS:** name in the card header, portrait, role, temper and mode as a word with its price, coach-time pips with "borrowed 1" in text, teaches-up-to per area, growth "next +1 in 6 sessions", school chips, wage, and a raise sticky with Pay and Say no. Buttons: mode switch, Rest this week, Let go, Promote.
- **Centre (1000 px), WHO RUNS WHAT:** one row per boxer with portrait, class in kg, record and a FOCUS pill. Five area columns, each cell with the coach magnet, fit word, "+1.0 Accuracy", bond pips and at most one tag in words. The Coach's pad nights row at the top when two boxers are in camp, showing the 60/40 pick and what the 40 side loses.
- **Right (400 px), ON MONDAY:** each boxer's FOCUS stat now and after the week, bonds crossing a step, next week's coach time, risks in words, and "Coach's board: 2 in 100 below yours", with one gold frame on the week's best gain.
- **Bottom strip, in a bout week:** corner magnets with word taken in, coach-time cost, bond step, and what moves to cover it.

