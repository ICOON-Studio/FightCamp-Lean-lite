# PLANFLOW1_V3 - write the NEXT version of this mechanic's design map (S459 design loop)

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


# THE DESIGN MAP TO JUDGE

# DESIGN_PLANFLOW1_V2_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ122)

Brief: research/DESIGN_PLANFLOW1_V2_REVISE_KALLI.md
Sent: 2026-11-14 18:40 | collected: 2026-11-14 19:11 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Writing PLANFLOW1 v2 now, in five parts.

# PLANFLOW1 v2: the fight plan as an if-then flowchart (S459, S469, S470, S471, 2026-11-14)

Part 1 of 5

Roadmap row PLANFLOW1. Designer seat: Kalli. Status: v2, for fresh critics.

**What v2 does:**
- It answers the three v1 critics: Dola (7/8/6), Maria (7/6/6) and John (6/5/7, which misses the bar on general design).
- It follows Claude's S471 facts and rulings.
- It folds in the four owner pictures (S470) as Claude's verdicts take them.

The bar is 6+ DEPTH and 6+ GENERAL DESIGN (S459).

**Owner rules this map keeps, quoted:**
- **S469:** "go with your recommendation". The flowchart is the new look of the plan the game already has, not a second plan system. It ships in stages, simplest first ("ok").
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Boxes, diamonds, arrows, warnings, the round line and tooltips say your boxer, the opponent, your coach.
- **S412:** any gym, any boxers, men or women. No fixed he or she on these pages, the opponent's tree included.
- **S425:** every menu it appears on, and what each is wired to (section 11).
- **Pack section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- **Pack:** no timers; nothing opens by itself; no flavour text; one word per concept; females never fight males; scouting means opponents; classes in kg.
- **Q-212 (owner, via the S470 verdict):** no percent stat buffs. Moves are learned, never bought.
- **S439 (via S470):** buttons follow what the game allows at that moment.
- **S405 / S459:** mark ESTIMATEs; end with To reach 10/10.

**Tags:**
- **CODE:** in the game (pack or S471).
- **NEW:** a small addition, named so Claude can price it.
- **ESTIMATE:** a starting value the probes size.
- **AGREED, NOT BUILT:** from the pack.
- **CHECK (Claude) / CHECK (John):** open questions.

No probe has run, so every target win rate is ESTIMATE.

## 0. How v2 answers the critics

### 0.1 Facts v1 got wrong, now corrected (S471)
| v1 said | Fact (S471) | v2 |
|---|---|---|
| Steps are cheap or free (the critics' reading) | `StepMastery` (S463, CODE): 10 bars given at signing from Footwork. A step fires by its bar, and under 30 the coach never plans it. One study slot raises a step about 6 a week, so step back goes from 0 to 32 in about 5 weeks. Nothing takes a step past 30 | steps are priced by the study slot, and a route to Sharp is added as NEW (section 5). A STEPS-ONLY bot is in the probes |
| Adjusting and ProRead tagged CODE | `PlanRead` (CODE): a line pays in full for its first 2 uses in a round, then less, and resets at the bell. `ProRead` (CODE, pros only): reads the last two pro fights and waits for the most-thrown punch; two real weapons or a feint line blunt it | tagged as built. Amateur reuse gets a small NEW rule (6.4) |
| Film costs a pad night | CODE: Film is a Week evening, so a film evening is a pad evening not taken | kept. Film with a bout booked but no camp is a CHECK (Claude) |
| Baseline 59 / 46 / 43 | pack: 59 / 45 / 41, one matchup | pack figures used |
| Ten IFs, four of them invented modes | the fight has six modes | IFs are the six modes. The real habits are found IFs or timing rules (section 4) |

### 0.2 John's To reach 10/10 (13 points)
| # | Point | v2 |
|---|---|---|
| 1 | Price the step answers | **Done (5).** The study slot is the price to reach Usable; NEW pad cards take a step to Sharp; STEPS-ONLY bot |
| 2 | IFs are the six modes; habits are modifiers | **Done (4).** The four invented modes are held back as fight-engine work (14) |
| 3 | Correct the tags | **Done.** Found-only is NEW and softened: an unfound mode can still carry a diamond, marked GUESS and rated OK at best (4.3). Adjust and ProRead are CODE per S471, so the 7 against 3.7 problem the pack described no longer applies; a probe still checks that a second weapon wins back half (9) |
| 4 | Film without a camp | **Done (3).** A Film evening opens a tell whenever a bout is booked, CHECK (Claude). The Tape Room opens from Fight prep. No bouts means no tape (CODE) |
| 5 | One Plan B | **Done (3.3).** A "lost: back here" arrow from every box to the opening box; no bar, no decision. `when: lost_last` is held back: the arrow already shows the same thing |
| 6 | One word per idea | **Done.** PRESSURE is your edge; "seen" means their corner has read a line; bait is PRESSURE with a target |
| 7 | Answers from the book only | **Done (4.2).** Book moves, book combinations and the 10 steps. Nothing new is added as content |
| 8 | Slots | **Done (3.4).** The coach's 4–6 lines are shared by boxes and diamonds; stage 3 adds bouts or Fight IQ, cap 7 |
| 9 | Test it costs a sparring night; lock at the first bell | **Done (3.5, 2)** |
| 10 | Baseline and probes across six styles | **Done (9).** Probe 8 runs against the stronger GOOD |
| 11 | BJJ | **Done in part.** Stage 2, not stage 1, per Claude's ruling, which puts boxing first. Positions as boxes over BjjTree, with two free IFs |
| 12 | Smaller live panel | **Done (12.2):** a 300 px strip |
| 13 | Missing buttons | **Done:** load the saved plan, copy a team-mate's plan, clear one |

### 0.3 Maria's To reach 10/10 (10 points)
| # | Point | v2 |
|---|---|---|
| 1 | Close the free-answer hole | **Done (5)** |
| 2 | Film against pads in code | **Done:** CODE per S471. The tray prints "Film night: −1 pad night" |
| 3 | Tag adjusting honestly | **Done:** PlanRead is CODE. Amateur reuse NEW (6.4), with its own probe |
| 4 | Probes plus STEPS, one S396 source | **Done (9)** |
| 5 | No colour-only state | **Done:** BEST / OK / WRONG / GUESS, "+2" and "−1", FIRED and SEEN are all printed as words |
| 6 | Settle the CHECKs; drop habits with no tell name | **Done:** the four invented habits are dropped; the remaining CHECKs are listed (15) |
| 7 | The hurt rule as one line | **Done:** one line in THE FILE in stage 1; the emergency box comes in stage 2 |
| 8 | Hurt IF against "Go for the finish" | **Done:** the shout wins and spends its instruction |
| 9 | Something to steer in stage 1 | **Done (7.3):** the corner swap lists dead diamonds first, with the swap list taken from your boxer's drilled bench |
| 10 | PNGs | **Not done here:** this is the words map. The pages are specified in section 12 for the board session |

### 0.4 Dola's To reach 10/10
| Point | v2 |
|---|---|
| Run probes; resolve the CHECKs; verify the margin | **Probes listed with pass lines (9). I can't run them.** S471 settled four CHECKs; the rest are in section 15 |
| Ship the stage 2 features with stage 1 | **Not done.** The owner ruled the simplest stage first (S469). Stage 1 gets the corner swap on the tree instead, so it isn't passive |
| Habit confidence tiers | **Done:** the share "n of m films" and a band (often / some / rare) |
| Habit co-occurrence | **Not done:** films record that a habit showed, not the order of modes, so co-occurrence would be invented |
| Plan health rating | **Done as Validate (7.1):** plain warnings and a coverage count, **no score** (owner picture verdict) |
| Six presets | **Done (3.6)**, as content to write |
| Habit-pattern suggestions in the Tape Room | **Done in part:** YOUR ANSWER suggests from your boxer's drilled bench. There are no pattern sets (no co-occurrence data) |
| Named plans with memory | **Stage 3 (8)** |

### 0.5 Options both lists named
| Kind | Option | v2 |
|---|---|---|
| Missing | Load the saved plan for this opponent (rematch) | added: editor and Rival file |
| Missing | Copy a team-mate's plan | added: same opponent or same style |
| Missing | Drill a step | study slot to 30, NEW pad cards to 60 |
| Missing | Film without a camp | the Week evening popover (CHECK Claude) |
| Missing | Clear one | an × on each box and diamond |
| Missing | Diamond order | numbered when two can hold at once (3.2) |
| Missing | Hold the plan | already exists: "Say nothing / No fix" in the corner minute (CODE) |
| Missing | A reset-reads button | not added: PlanRead resets at every bell anyway (CODE) |
| Missing | The opponent's likely opening | the opponent's tree (7.2) shows the bell card and the most-shown mode |
| Missing | Diamonds that haven't fired by round 2 | the corner swap lists them first (7.3) |
| Useless | Set Plan B; the Plan B bar | cut |
| Useless | Lock at the weigh-in | cut; locks at the first bell |
| Useless | Limited test tries | cut; a test costs a sparring night |
| Useless | A HURT stub on every box | cut; one line in THE FILE |
| Useless | Two diamonds on one mode on one box | blocked by the editor |
| Useless | A diamond on a rare habit | Validate warns |
| Useless | Load preset once your own plan exists | shown only with no plan, or behind "Start again" |
| Useless | Late edits with red stamps | Validate runs on the Fight prep button until the first bell |

Part 2 of 5

## 1. The idea
- **The plan is a chart.** A plan is drawn as boxes (what your boxer throws or does in a place after a won exchange) and diamonds (IF the opponent is fighting a certain way, do this instead).
- **What it costs:**
  - Every piece is a move, combination or step your boxer must have drilled.
  - Every non-free diamond needs film.
  - Every test costs a sparring night.
- **The opponent's file is the same kind of chart,** filled in by film, so you read the opponent the way you write your plan.
- **On the night:**
  - A small strip shows which piece FIRED.
  - The corner minute shows the counts and allows one swap.
  - The result lights up the whole chart.

## 2. The decisions, in order
| When | What the player chooses | Price | Tag |
|---|---|---|---|
| Bout booked | nothing; your coach's preset for the opponent's style loads (free modes only) | none; about half a good plan | CODE (the assistant writes one) + NEW (preset per style) |
| Any week before the bout | Film evenings: each opens one tell, filling a branch of the opponent's tree | a pad evening not taken (about 240 drill units) | CODE; without a camp, CHECK (Claude) |
| Pro only | Scout ($250): weapon and weakness at once | $250 | CODE |
| Before the bout | the study slot: one step toward Usable 30 | the slot is single, about 6 a week | CODE (S463) |
| Before the bout | the editor: boxes per place, diamonds on modes, within the coach's 4–6 lines | each piece is a drill card | CODE (line cap) |
| Before the bout | the tray "THE PLAN vs the opponent": drag each piece's drill card to a pad night | pad time | CODE |
| Before the bout | Test it in sparring | that evening is sparring, not pads; it also spreads 180 units over the plan's moves | CODE (Test it, sparring units) + NEW (the price) |
| Before the bout | Validate: read the warnings and fix or accept | free | NEW |
| First bell | the plan locks | none | NEW (moves the lock to the bell) |
| Live | nothing to set in stage 1; the shouts are as today. "Go for the finish" beats a hurt diamond | a shout | CODE |
| Corner minute | ONE swap on the tree: replace or remove one piece, or say nothing | one a round; swapping a piece resets its PRESSURE | CODE (one change) + NEW (drawn on the tree) |
| After the bout | read "The plan, lit up", then save the plan to this opponent's file | none | CODE (view) + NEW (save) |

## 3. The chart, mapped to the code

### 3.1 Pieces
| On the page | In the code | Tag |
|---|---|---|
| Opening box: "BELL: <place>" and its move | the any-time arrow on the card the opponent's game puts your boxer on at the bell | CODE (PlanFight, PlanBoard) |
| A box | the any-time arrow `{move, when: any}` on one place's card | CODE |
| Arrow from box to box, labelled with a place | where a won exchange leaves your boxer | CODE (PlanChain) |
| A diamond beside a box | a situation arrow `{move, when: <mode>}` on that card, taken first when the mode holds | CODE (PlanBoard.pick) |
| BEST / OK / WRONG printed on a diamond | the code's rating against the opponent's game | CODE |
| GUESS printed on a diamond | a diamond on a non-free mode film hasn't found: rated OK at best | NEW |
| "+2.1 edge" on a box | match × pad time − the average of what your boxer can do on that card | CODE |
| Tier and number ("SHARP 64"), fire rate ("3 in 4") | mastery and FireLevel: 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature | CODE (S451); for steps, CHECK (Claude) that FireLevel applies |
| Red stamp "UNDER 30: SKIPPED" | under 30 the coach skips it | CODE (S464, S463) |
| SEEN on a piece (pros) | the most-thrown punch across the last two pro fights, which ProRead waits for | CODE (ProRead) |
| THE FILE line "Hurt: holds this place" | the S466 rule | CODE |

### 3.2 Rules on the board
- **One box per place.** The six places are outside, long, mid, inside, clinch and ropes. The board allows a box on every place; the line count is the cap, not 4. On the ropes is a place, so it's a box, never an IF. A won exchange that leads back to a place already on the board draws as an arrow back up.
- **One diamond per mode per box.** A second is blocked. Two diamonds on one box with different modes can both hold in one exchange only if the code allows two modes at once. If it does, the one PlanBoard.pick takes first is numbered 1. CHECK (Claude) the pick order. If the player can reorder it, that's NEW; if not, the number is shown only.
- **A diamond on a place with no box** is legal (CODE) and drawn on a dashed box: "no main move here: improvises".

### 3.3 One Plan B (S471 ruling)
- Every box has a thin arrow back to the opening box, labelled "lost: back here". A lost exchange puts your boxer on the opponent's card, which is the bell card (CODE, PlanFight).
- So Plan B is the opening box, written once. There's no bar and no separate decision.

### 3.4 Lines (slots)
- **Stage 1:** boxes and diamonds share the coach's 4–6 lines (CODE). The opening box counts.
- **Stage 3:** +1 at 12 bouts or at Fight IQ 65, whichever comes first, cap 7 (ESTIMATE).
- **Shown** as "Lines 5 of 6"; hover names the source ("your coach: 6").

### 3.5 Test it
- A sparring night with the plan on: the code runs the plan against the opponent's file (CODE Test it) and the night also drills it (180 units, CODE).
- **Result:** worth over no plan as a band ("+6 to +10", NEW: a band, not one number), and which diamonds fired.
- No count of tries and no free Simulate button: each test is an evening (owner picture verdict).

### 3.6 Presets
- One preset per style word (6: Out-boxer, Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher, Slugger). NEW content.
- Each preset uses free modes and your boxer's moves at 30+ only, sized so probe 2 passes.
- "Rate against another kind of opponent" stays for practising with no bout booked (CODE, pack section 6).

Part 3 of 5

## 4. The IFs: six modes, and the habits on top

### 4.1 Modes (CODE, the fight's own)
Free means known from the style word at booking (CODE: the style word is free). Found means a Film evening, the Tape Room or the pro Scout opened it.

| IF the opponent… | Free for | Otherwise |
|---|---|---|
| presses | Pressure fighter, Slugger, Volume puncher | found |
| boxes at range | Out-boxer | found |
| waits to counter | Counter-puncher | found |
| loads up | Slugger, Boxer-puncher | found |
| tires | everyone | free |
| is hurt | everyone | free; "Go for the finish" shouted the same exchange wins |

### 4.2 Answers (book only)
- **Moves:** Jab, Cross, Lead hook, Body hook, Uppercut, Check hook.
- **Combinations:** 1-1, 1-2, 1-1-2, 2-3, 1-2-3, 1-2-3-2, 3b-3, 1-2-3b, 1-6-3, slip 2-3, plus your boxer's own saved combinations.
- **Steps:** step in, step out, step back, pivot out, cut off, herd, feint, tie up, roll out, push off.
- The code rates each answer BEST / OK / WRONG against the opponent's game.
- The editor's suggestion list shows your boxer's drilled answers, BEST first. v2 prints no ratings of its own, because the code decides them.

### 4.3 GUESS (answers John 3)
- A diamond on a mode film hasn't found can still be placed, as today. It prints GUESS and counts as OK at best (NEW).
- Found turns it to its real rating. That keeps what players can do now, and film stays the only route to BEST against an unfree mode.

### 4.4 Habits on the file (CODE habits; how each enters the chart)
| Habit (found by film) | In the chart | Tag |
|---|---|---|
| drops the right after the jab | a found diamond, "after its jab", answered over the top (Cross, slip 2-3, Check hook) | habit CODE; whether PlanBoard.pick can take a habit as `when` is CHECK (Claude) |
| slow starter | timing rule: a diamond can be set to "round 1 only", for example presses in round 1 | NEW (a round filter on a diamond), CHECK |
| fades late | timing rule: "from round 3" on the tires diamond, so its answer is ready early | NEW, CHECK |
| chases the stoppage | a found diamond on your boxer being hurt: the stage 2 emergency box can answer it with tie up or roll out | stage 2 |

**Share.** Each found habit or mode prints "showed in n of m films", with a band: often (3+ of 4), some (2 of 4), rare (1 of 4). NEW (the count per tell, CHECK Claude). No percent.

**Held back:** shells up, circles away, switches stance, bites on feints. They're new fight modes, which is engine work (14).

## 5. Steps: what an answer that moves costs
| Stage of a step | How it's reached | Price | Tag |
|---|---|---|---|
| Given at signing | from Footwork | none | CODE |
| To Usable 30 | the WHAT TO LEARN NEXT study slot, about 6 a week (step back 0 to 32 in about 5 weeks) | the slot holds one step at a time | CODE (S463) |
| Usable to Sharp 60 | NEW: a Usable step can go on a pad night as a drill card, at the pad rate in units. Sparring gives steps a share of its 180 units like moves | pad time, shared with the plan's punches | NEW, ESTIMATE about 4 weeks on half a pad night |
| On the night | fires by its bar; under 30 it's never planned | none | CODE |

**Why this closes the hole:**
- A step answer costs either weeks of the single study slot or pad time, the same budget as punches.
- S471 measured a well-read plan on low step bars at +0.13 over no plan, against the coach's +0.09. So a steps-first plan only pays once the steps are drilled.
- The STEPS-ONLY bot must finish under GOOD (9).

## 6. Depth: why a good chart beats a lazy one

### 6.1 Measured today
- **Good plan 59%, no plan 45%, bad plan 41%,** one matchup (pack). Training beats planning: a 5-point stat gap wins about 72%, a 10-point gap about 95% (pack).
- **One change is small:** in the S469 brief's 20 sample bouts, the plan as written won 9 of 40, and the best single change 11 of 40.

### 6.2 Levers, each from a cause the fight has
1. **Film is the only route to BEST against an unfree mode.** GUESS caps at OK. A film evening costs a pad evening (CODE).
2. **Share is a bet.** A BEST answer on a rare mode, or an OK answer on an often mode.
3. **PRESSURE builds inside a round.** Right answers that win build PRESSURE and cut the opponent's output (CODE), so a diamond that fires early is worth more. The hover says "fires early: PRESSURE builds".
4. **PlanRead caps any one line.** Full value for 2 uses a round, then less (CODE). A plan with two or three different answers beats one answer used six times.
5. **A wrong diamond costs more than an empty one.** Planned wrong answers shrink your boxer's energy ceiling (CODE); empty is edge 0.
6. **Drilling is the budget.** About 3 pad nights a week, film evenings, test evenings and the one study slot all take from it (CODE). A big plan gets red stamps.
7. **Pros: SEEN.** ProRead waits for the most-thrown punch of the last two pro fights. A second real weapon or a feint line blunts it (CODE). The editor marks the SEEN piece, and Validate names the fix.

### 6.3 Targets (ESTIMATE, probe pass lines in 9)
| Plan | Close-bout win rate |
|---|---|
| No plan | 45% (CODE, one matchup) |
| Coach's preset (free modes) | 48–52% |
| GOOD (found modes, drilled) | 57–62% |
| One WRONG diamond | 3+ points below the same plan without it |
| STEPS-ONLY (found modes answered only by steps) | at least 4 points below GOOD |

### 6.4 Amateur reuse (NEW, small; S471 ruling)
- Amateurs aren't read across bouts (CODE).
- Until they are, an amateur opponent who has met your boxer before starts the bout with your most-used line from that bout already SEEN: it pays like a third use from exchange 1.
- The Rival file and the editor print "SEEN: met before".

### 6.5 No dominant plan
- All-free caps at the preset.
- Stuffed runs out of pad time and gets red stamps.
- One-answer is cut by PlanRead, and for pros by ProRead.
- STEPS-ONLY waits on the study slot.
- The best plan is opponent-specific, drilled, and spread over two or three answers.

Part 4 of 5

## 7. From the owner's pictures (S470, as Claude's verdicts take them)

### 7.1 VALIDATE (stage 1, NEW)
A button on the editor, also read by the Fight prep button. It gives plain warnings, one line each, with no score:
- "Uppercut under 30: skipped."
- "Pivot out is Raw: never planned. In the study slot: 2 weeks."
- "Presses is a GUESS: OK at best. A Film evening can find it."
- "Waits to counter showed in 1 of 4 films: rare."
- "Diamond rated WRONG: shrinks the energy ceiling."
- "1-2-3-2 on the bell box: a long combination on every lost exchange costs energy." (combination energy, CODE)
- "SEEN: the Cross is the most-thrown punch. A second weapon or a feint line blunts it." (pros)
- "7 drill cards, 5 pad nights before the bout."
- Coverage, a count only: "Answers 3 of 4 known modes."

### 7.2 The opponent's tree (stage 1, NEW view of CODE data)
- **The file is drawn as a chart** in the same language: the bell place at the top, then the six modes as branches.
- **What fills it:** branches film hasn't found are blank outlines ("not seen yet: 1 Film evening"). Found branches carry the share band and the habit's answer.
- **One red box,** "biggest hole", appears only once the weakness is found. Tape finds the weakness last (CODE).
- **Suggestions** from your boxer's drilled bench, each with what it needs ("needs pivot out drilled to 30").
- **BUILD THE PLAN** opens the editor with this tree beside it.
- **Where it shows:**
  - Amateur offers show the free part only, because there's no scouting before accepting (pack S410).
  - Pro offers show what Scout opened.
  - Fight prep shows it all.
- **No percents.** "2 branches not seen yet" instead of "92% complete". Opponent ratings stay ranges until read.

### 7.3 ONE swap between rounds (stage 1; the corner's existing one change, drawn on the tree)
- **The corner's read** sits beside the chart, with counts the corner can see:
  - "Body hook fired 3, won 2."
  - "Presses diamond: never fired."
  - "Lead hook punished 4 times."
- **Pick a piece:** REPLACE or REMOVE. Dead diamonds are listed first. FixLab's line is outlined (CODE).
- **The swap list** is your boxer's bench: moves, combinations and steps at 30+, ordered by mastery, each with its fire rate as the hesitation note ("Usable: fires 1 in 2").
- **Or "Say nothing / No fix",** which holds the plan (CODE).
- **No running clock** (pack: no timers).
- **No judges' cards:** amateur corners don't see them. Your coach's count is "we think we're ahead", the corner card's own count (CODE).

### 7.4 Emergency box (stage 2, NEW)
- One box, taking no line, which replaces the fixed hurt rule. When your boxer is hurt: hold this place (the S466 default), tie up, or roll out (steps, so they need 30+).
- It also answers a found "chases the stoppage".
- In stage 3, a failed Composure check greys the plan and the emergency box stays lit.

### 7.5 Bait pair (stage 3, NEW)
- **Building the bait:** body work that wins adds "expects the body", a PRESSURE with a target, up to 3. A sharp opponent (Fight IQ 70+) builds it at half speed (ESTIMATE).
- **Cashing it:** a bait diamond "IF expects the body (2+)" answers with a head shot from the book and has an outcome pair: works → the next box (one line); countered → back to the bell box (one line).
- **Payoff per point:** probed, never flat.

### 7.6 What the pictures add that's left out
- Percent IFs (stamina < 50%) and the opponent's exact bars.
- "Biting 94%".
- Synergy buffs.
- Bought moves.
- A free Simulate button.
- A countdown.
- Judges' cards between rounds.
- MMA names.
- Names in feed lines.
- A second commentary panel.
- Exact triggers like "on the ropes > 5 s": the ropes are a place, and the fight is per exchange.

## 8. Stages (simplest first; S469 "ok")
| Stage | Contents |
|---|---|
| 1 (boxing) | the chart from 3.1; the six modes, free or found, with GUESS and share; the habits as found diamonds and timing rules (after their CHECKs); steps priced (the study slot and NEW pad cards to Sharp); lines from the coach's 4–6; Test it as a sparring night; Validate; the opponent's tree; lock at the first bell; the live strip; the corner swap on the tree; "The plan, lit up"; the Why wording; presets; rematch load, team-mate copy, clear one; amateur reuse SEEN. Probes 1–8, 10, 11 |
| 2 | BJJ: positions as boxes over BjjTree with two free IFs (stalls in guard, tires), and the found BJJ habits after the 3-beat CHECK. The emergency box. A shout aimed at a box, inside the two-a-minute rule. The last-exchange timing rule. Probe 9 |
| 3 | lines from bouts or Fight IQ (cap 7); the bait pair; the Composure check with its chance shown ("Holds the plan: 70%", ESTIMATE, from Composure and Heart, after a knockdown or a hurt only); named plans after 3 uses, which a scouting opponent then finds; a cut IF on the cutman card's closing-eye state (AGREED, NOT BUILT); "last round, behind on your coach's count" if the owner keeps it |

## 9. Probes (400 bouts a cell, three seed sets, all six styles, close bouts with a rating gap under 3)
| Bot | Rule |
|---|---|
| NONE | no plan |
| PRESET | the coach's preset for the style |
| GOOD | found modes, BEST answers, all at Sharp |
| WRONG | GOOD with one diamond set to a WRONG answer |
| STUFFED | the line cap filled, drilled only as far as 3 pad nights allow |
| ONE | one diamond, reused every bout |
| STEPS-ONLY | found modes answered only by steps, at their real bars |
| GUESS | GOOD shape with no film (all GUESS) |
| AMREUSE | ONE against an amateur met before |

**Pass lines (all ESTIMATE):**
1. GOOD beats NONE by 12+ points and PRESET by 8+.
2. PRESET beats NONE by 3–7 points.
3. WRONG is 3+ points under the same plan without the wrong diamond.
4. STUFFED, ONE and STEPS-ONLY each finish under GOOD, STEPS-ONLY by 4+. No single shape is best against all six styles.
5. A diamond fires 3+ times in a 3-round amateur bout in 80%+ of GOOD bouts; none fires 10+.
6. 4+ exchanges a bout go through boxes after a won exchange.
7. A diamond on an "often" mode fires 2–4 times as often as one on a "rare" mode.
8. A 10-point stat gap still wins 90%+ against the weaker side on GOOD.
9. BJJ: lines 1 and 5 over 3-beat runs (stage 2).
10. GUESS finishes between PRESET and GOOD, so film is worth its pad evenings.
11. Pros: GOOD with a SEEN line plus a second weapon wins back at least half of what ONE loses to ProRead. AMREUSE loses 2+ points against fresh ONE.

## 10. The failure path that teaches (no rigged roll)
- **The setup:** film found "presses: 2 of 4 films", and the player hung two of three diamonds on it. Tonight the opponent boxes at range (the code's own mode pick).
- **Live:** the diamonds stay dark. The round line says once: "Never pressed this round: the main line fought alone."
- **Corner minute:** "Presses: never fired" sits top of the swap list. FixLab outlines the long-range box. The player swaps one dead diamond for a box answer on long range.
- **The Why:** "YOUR PLAN: two IFs on pressing, never fired. The swap won 3 of 6." NEXT: "Bet IFs on modes shown often; build the main line to stand alone."
- **A second failure:** "Pivot out under 30: skipped 3 times." Validate warned about it before the bout.

Part 5 of 5

## 11. Every menu, and what each is wired to (S425)
| # | Menu | What shows | Player actions | Wired to (CODE) | New wiring (NEW) |
|---|---|---|---|---|---|
| M1 | Fighter > Playbook > Game plan | the editor (3.1), Lines n of m, Validate list | draw, × clear one, Validate, Test it, Save, Load the saved plan, Copy a team-mate's plan, Start again (preset) | PlanBoard, PlanChain, worth, line cap | editor view, GUESS, Validate, save to the file |
| M2 | Fight prep > WHAT YOUR PLAN SHOULD ANSWER | becomes the opponent's tree (7.2) | BUILD THE PLAN; Film evening | tells, tape | tree view, share count |
| M3 | Fight prep > Tape Room > YOUR ANSWER | the picked answer lands as a diamond on its card; suggestions from the bench | pick | Tape Room, PlanBoard | place as diamond |
| M4 | Fighter > Week > evening popover | Film (also with no camp), "−1 pad night" | pick Film | Week evenings | Film opens a tell without a camp (CHECK) |
| M5 | Fighter > Week > tray "THE PLAN vs the opponent" | a drill card per piece, with stamp or tier; Usable steps as cards | drag to a pad night | PadWeek, mastery | step pad cards |
| M6 | Fighter > Overview > WHAT TO LEARN NEXT | the step the plan needs first ("pivot out: plan needs it") | put it in the study slot | StepMastery (S463) | plan's need line |
| M7 | Fight prep, primary button | "Write the game plan", then "Check the plan: n warnings" | opens M1 | Fight prep state | reads Validate |
| M8 | Home > needs | amber "Plan: n warnings", fight week only | opens M1 | Needs | Needs.plan_warn |
| M9 | Fights > bout offer, Full report | the opponent's tree, free part (amateur) or Scout part (pro) | Scout ($250, pro) | bout page, Scout | tree view |
| M10 | Fight night, live | 300 px strip: box in play, FIRED, count, SEEN | shouts as today | PlanFight, PlanRead, round line | strip |
| M11 | Fight night, corner minute | full chart, the corner's read, the swap list | REPLACE / REMOVE one, or Say nothing | one change, FixLab | drawn on the tree |
| M12 | Result > The plan, lit up | full chart with fired and won counts | Save to this opponent's file | result view | save |
| M13 | Result > The Why | YOUR PLAN names boxes and diamonds | Train X next week | Why | wording |
| M14 | Fighter > Overview | "Fight plan (n boxes, n IFs)" | opens M1 | Overview button | label |
| M15 | Rival file (modal) | the tree; "a plan saved for this opponent"; "SEEN: met before" | Load the saved plan | tells | rematch, amateur reuse |
| M16 | Fighter > History | per bout: plan used, counts; named plan (stage 3) | open the plan | Records | plan per bout |

**Not on** Club, World or the top bar: the plan isn't money, standing or a moment. The bout offer's win band already counts the plan.

## 12. Pages, 1920×1080 (Look B; handwriting in marker, numbers in the kit's mono, SIZE_MIN 12, gold on one thing, green only on Continue in the top bar)

### 12.1 Editor (M1)
- **Header 0–120:** your boxer's polaroid left and the opponent's right, each name once; class in kg, style word, stance; "bout in 18 days".
- **Left 40–440, THE FILE:** the opponent's tree, small, at 400 px. Branches show FREE, FOUND "3 of 4 films · often", or blank "not seen yet". The hurt line. Buttons: Film evening (Tue, −1 pad night), Load the saved plan (only if one exists), Copy a team-mate's plan, Start again.
- **Centre 480–1440, the chart:**
  - Bell box at the top, then the boxes by place, 320×110, joined by arrows labelled with places, and grey "lost: back here" arrows to the bell box.
  - Each box: move, "SHARP 64", "3 in 4", "+2.1", a red stamp "UNDER 30", and an ×.
  - Diamonds 150×150 to the right, printing the mode word, the answer, BEST / OK / WRONG / GUESS, the share band, and "1" when ordered.
- **Right 1480–1880, WHAT IT COSTS:**
  - Lines 5 of 6.
  - Drill cards 7, pad nights 5.
  - Film evenings used 2.
  - The Validate list.
  - The worth band from the last test, "+6 to +10 over no plan", in gold (the one gold).
- **Bottom 980–1060:** Validate, Test it in sparring (Thu), Save, Clear.

### 12.2 Live strip (M10)
- Right of the 3D fight (which shows both fighters head to feet), 300 px wide, under the shout bar.
- It shows the box in play, FIRED in 32 px over the diamond that fired, its count, and SEEN on a read line.
- The round line runs along the bottom, under 70 characters, with no numbers and no names.

### 12.3 Corner minute (M11)
- **Left:** the corner's read in counts, plus "we think we're ahead".
- **Centre:** the full chart, with the picked piece outlined and REPLACE / REMOVE.
- **Right:** the bench list with fire rates; FixLab's line outlined; Say nothing.
- No clock.

## 13. Build (each file under 500 lines, test red first; owner Claude or the seat Claude names)
| # | Task | Test red first |
|---|---|---|
| P1 | PRESETS1: 6 style presets | PRESET passes line 2 |
| P2 | GUESS1: unfound modes rated OK at best | an unfound BEST answer reads OK |
| P3 | FILMANY1: Film evening opens a tell with any bout booked (after the CHECK) | no camp, one film evening, one tell |
| P4 | SHARE1: films-shown count and band | "3 of 4 · often" |
| P5 | STEPPADS1: Usable steps as pad cards; sparring share | step back 30 to 60 at the probed weeks |
| P6 | TESTSPAR1: Test it uses a sparring night; band result | no tries counter exists |
| P7 | LOCKBELL1 | an edit after the weigh-in holds |
| P8 | VALIDATE1 | each warning line from its cause |
| P9 | OPPTREE1: the file as a tree (M2, M9, M15) | blank branches until found |
| P10 | PLANEDIT1: the editor (M1, M14) | board = PlanBoard |
| P11 | CORNERSWAP1 (M11) | one swap a round; Say nothing holds |
| P12 | LIVESTRIP1 (M10) | FIRED on the exchange it fired |
| P13 | AMREUSE1: SEEN on a rematch | met before = third use from exchange 1 |
| P14 | PLANSAVE1: save, rematch load, team-mate copy (M12, M15, M16) | a saved plan reloads |
| P15 | PLANGOLDEN1: the section 10 bout end to end | red until P1–P14 |

Then stage 2 (BJJ, emergency box, aimed shout, last exchange), then stage 3.

## 14. Held back
- **The four invented modes** (shells up, circles away, switches stance, bites on feints) and **feint loops:** fight-engine work.
- **`when: lost_last`:** the return arrow already shows it.
- **Co-occurrence of habits:** no data.
- **A plan score:** Validate lists warnings, with no score.
- **Percent buffs, bought moves, a free Simulate, a countdown, judges' cards:** owner rules.
- **MMA, cage and hybrids.**
- **A 2D radar.**
- **Live sliders.**

## 15. Open questions
- **CHECK (Claude):**
  - Film evening with a bout booked but no camp.
  - Whether PlanBoard.pick can take a habit as `when`.
  - The round filter for timing rules.
  - Whether FireLevel applies to steps.
  - Whether two modes can hold at once, and the pick order.
  - The films-shown count per tell.
  - Whether BjjSide can read a mode over 3 beats.
  - The cutman card's closing-eye state, readable mid-round (stage 3).
- **CHECK (John):** whether UK amateur corners keep their own round count. Still not found.
- **Owner:**
  1. Should the chart replace the move-map arrows as the Game plan tab's first view, with the map behind a switch? I recommend replace.
  2. Should "last round, behind on your coach's count", a trigger that can be wrong, stay in stage 3 or be cut?
  3. Should a named plan, once a scouting opponent finds it, start that bout SEEN?
  
  The v1 shout question is closed: the aimed shout uses the two-a-minute rule (S471).

## 16. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6** (mine, not a critic's).

**To reach 10/10:**
1. Run probes 1–8, 10 and 11 on three seed sets across six styles. Replace every ESTIMATE in 5, 6.3, 7.5 and 8 with measured numbers. If GOOD doesn't beat PRESET by 8+, widen the gap between GUESS and found before the editor ships.
2. Settle the eight Claude CHECKs, above all the habit as `when` and Film without a camp. Each decides a row of 4.4 or 2.
3. Probe the step route to Sharp, so STEPS-ONLY sits under GOOD without making steps dead weight.
4. The owner's three answers.
5. Draw M1, M10 and M11 as 1920×1080 PNGs, with a long combination name and a fight against a Southpaw as the stress test.
6. Stage 2 BJJ after the 3-beat check, with probe 9 passing.


# CRITIC ANSWER: DESIGN_PLANFLOW1_V2_CRITIC_JOHN_JOHN.md

# DESIGN_PLANFLOW1_V2_CRITIC_JOHN_JOHN - John answer (seat queue SQ133)

Brief: research/DESIGN_PLANFLOW1_V2_CRITIC_JOHN.md
Sent: 2026-11-14 20:45 | collected: 2026-11-14 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading PLANFLOW1 v2 against the pack now, and checking for real UK corner evidence. Logic comes first, then the scores, options, To reach 10/10 and the page.

# PLANFLOW1 v2: critic

Scores: **depth 7/10, general design 6/10, play 7/10**. It **passes the owner's bar** (6+ and 6+).

v2 fixes v1's main faults:
- The modes are the fight's six.
- Steps carry a real price (the study slot).
- Plan B is one arrow, not a bar.
- Test it costs an evening.
- Answers come from the book only.
- Every shown state is printed as a word.

What holds general design at 6 is a set of smaller faults:
- "found modes" isn't in the opponent's file today, but it's tagged as if it were;
- the price to take a step to Sharp is out of line with the study slot;
- Test it may leak hidden information;
- the timing rules are mixed up;
- some code names leak onto the screen.

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the map and the pack, and checked the England Boxing and IBA scoring rules myself.

Names: the editor header (12.1) names both boxers once, which is allowed. Boxes, diamonds, warnings, the round line and the Why say "your boxer" or "the opponent". I found no fixed he or she. The critic names in section 0 are design notes, not screen text.

## Logic check

**1. "Found modes" is new data, tagged as if it were in the code.**
- The pack's file holds three kinds of hidden fact: the best weapon, each habit and the weakness (4.6). Tape opens them in the order weapon first, weakness last.
- How often the opponent uses each mode isn't a tell anywhere in the pack. So the "free or found" table in 4.1, GUESS, the share bands and the blank branches on the opponent's tree all rest on a new tell type. Only the share count is tagged NEW plus CHECK.
- **Fix:** tag "mode as a tell" NEW and give it a slot in the tape order. My suggestion: weapon, then the opponent's most-used mode, then habits, then the second mode, then the weakness. Then tape days decide how much of the tree an amateur camp can fill.

**2. Film is free inside a camp, so lever 1 only bites without one.**
- The camp's Film (tape study) is free and opens a tell every few camp days (4.3). The Tape Room is in Fight prep.
- So the "costs a pad evening" price applies only to bouts with no camp. Under S428 those are short-notice amateur bouts, where an opponent with no bouts has no tape at all.
- The result:
  - in pro and title camps, film is close to free and GUESS rarely happens;
  - in quick amateur bouts, everything non-free is a GUESS, whatever the player does.
- **Fix:** keep one price for film. A camp's film days take camp nights like a Film evening does, so 4.3's "free" becomes "a camp night". Or state outright that a camp buys tape, and make the camp's intensity the trade.

**3. Taking a step to Sharp is priced faster than the slot that gets it to Usable.**
- The slot gives about 6 a week using the week's pad nights (S463).
- The NEW route, "about 4 weeks on half a pad night" for 30 to 60, is about 7.5 a week on half of one night.
- So the Sharp route is quicker and cheaper than the Usable route. That breaks the "same budget as punches" claim in section 5.
- With pads at 2.1 an hour, half a 75-minute night is about 1.3 a week for a punch. Four weeks gives about 5, not 30.
- **Fix:** take the step pad card rate from the same 240 units a pad night as punches, and print the weeks that gives. Probe 4 (STEPS-ONLY) only means something after that.

**4. Test it may find what film hasn't.**
- 3.5 runs the plan "against the opponent's file" and reports which diamonds fired. If the test uses the hidden real opponent, a GUESS diamond that fires tells the player which mode is real, so one sparring night does a film evening's job and grades the plan too.
- **Fix:** Test it plays against what's known: free modes plus found ones. Unfound modes are drawn evenly and the result is marked "with 2 modes guessed". Or say plainly that a test also opens one tell, and price it the same as film.

**5. The timing rules answer the wrong question.**
- "Slow starter: presses in round 1 only" puts a diamond on the opponent pressing in a round where a slow starter doesn't press.
- "Fades late: from round 3 on the tires diamond" adds nothing, because the tires diamond only fires when the opponent is Tiring anyway.
- What both habits really change is **your** pace by round, and the Playbook already has round-by-round pace (Push / Steady / Save, 4.7).
- **Fix:** cut the round filter. A found "slow starter" suggests Push in round 1, and "fades late" suggests Save then Push. Validate prints it, with no NEW mechanic.

**6. The bell box carries most of the bout, and PlanRead hits it hardest.**
- Lost exchanges return to the opening box (3.3). In a close bout, about half of the 18 exchanges start there: the bell plus every loss.
- PlanRead pays full value for 2 uses a round, so the bell box is the most-worn piece in the plan, while other boxes are rarely reached.
- That's real depth: diamonds belong on the bell box, and a long combination there costs energy every lost exchange. But the editor doesn't show it.
- **Fix:** each box prints its expected uses a round ("about 3 a round, 2 at full"), from the probes. Pass line 6, "4+ exchanges a bout through boxes after a won exchange", is too easy across 18 exchanges, so change it to a share for each box.

**7. Swapping "resets its PRESSURE", but PRESSURE isn't held per piece.**
- In the pack, PRESSURE builds on the **opponent** from right answers that win. There's no per-line PRESSURE.
- **Fix:** either make PRESSURE per line (NEW, a probe) or drop the line. The real cost of a swap is already in the code: the new piece starts fresh, which is a **gain** under PlanRead. So the swap should cost something else, for example taking the minute's one change.

**8. The corner minute already has the plan swap, so don't double it up.**
- Pack 4.8 lists "change one plan arrow" in the corner minute **separately** from ONE CHANGE (a habit fix, Elbows in, Gloves high).
- 7.3 calls the swap "the corner's existing one change" and holds it with "Say nothing / No fix", which belongs to the shouts and fixes.
- **Fix:** M11 is the plan arrow change drawn on the tree, tagged CODE. ONE CHANGE stays its own row, so the player still gets both, as today.

**9. Labels: GUESS and "OK at best".**
- It isn't clear whether a GUESS changes what the line pays, or only what the label says. Probe 10 implies the pay is capped.
- If the code's rating says BEST and the screen says OK, the screen is lying. If the pay is capped, a guess that happens to be right is still punished, which is the real cost of not filming.
- **Fix:** state it as a rule: "an unfound mode's answer pays as OK, even when right", and the hover says why.

**10. Words on the screen.**
- "FixLab's line is outlined" uses a code name. Write "your coach's pick".
- Stage 3's "Holds the plan: 70%" breaks the map's own "no percents" and 7.6. Print the band instead (likely / even / unlikely).
- "Lines 5 of 6": good, and it's one word throughout.

**11. Amateur reuse needs a scope.**
- It doesn't say whether "SEEN: met before" applies only to round 1, since PlanRead resets at the bell, or to every round.
- Amateur rematches are rare at club shows, so this has little weight either way.
- **Fix:** round 1 only. Then it's a fair, small punishment that a fresh opening box can dodge.

**12. CHECK (John), answered with the real rule.**
- England Boxing (Rule Book 2023/24, 12.10.1): a club coach who wants the scores must ask the Supervisor in writing within 20 minutes of the **end** of the bout, and gets the bout totals only, in random order.
- IBA rules (2022, 18.8): judges' round scores "must not be disclosed or displayed until the winner of the Bout is announced".
- So amateur corners never see the cards during a bout. "We think we're ahead" as your coach's own count is right.
- Whether UK corners formally keep their own count: no written source. It's coaching practice, NOT FOUND as a rule.
- That makes owner question 2 ("last round, behind on your coach's count") real, but only as a trigger that can be wrong. Keep it in stage 3 with the uncertainty printed.

## Scores, with reasons

**Depth 7.**
- Every piece pulls on a budget the rest of the game already has:
  - pad time and the single study slot (training);
  - film evenings (the week);
  - a sparring night per test (camp phases: no sparring in TAPER);
  - line slots (the coach you hired);
  - SEEN (the pro career).
- Seven levers come from causes the fight already has, so no plan shape dominates:
  - film is the route to BEST against an unfree mode;
  - share is a bet between a strong answer on a rare mode and a fair one on a common mode;
  - PRESSURE rewards a diamond that fires early;
  - PlanRead caps any one line;
  - a wrong diamond costs more than an empty one;
  - drilling is the budget;
  - SEEN punishes a pro's one favourite punch.
- The bell box carrying most of the bout (point 6) is a real trade the player has to find.
- Held to 7: in camps, film is close to free (point 2), and quick amateur bouts are mostly GUESS whatever the player does, so the found-mode bet only works in the middle of the range.

**General design 6.**
- Good:
  - one Plan B;
  - answers from the book only;
  - every state printed as a word;
  - menus wired to code files;
  - a stage cut that follows S469;
  - probes with pass lines;
  - every critic point answered or openly declined.
- Held to 6:
  - found modes are new data tagged as code (point 1);
  - the step rate to Sharp is out of line with the slot (point 3);
  - Test it may leak (point 4);
  - the timing rules are wrong (point 5);
  - per-piece PRESSURE doesn't exist (point 7);
  - the swap is mixed up with ONE CHANGE (point 8);
  - FixLab on screen and a percent in stage 3 (point 10).
- All of these are fixable without changing the structure.

**Play 7.**
- Three real beats:
  - filling the opponent's tree film by film before the bout;
  - the corner minute, with "Presses: never fired" at the top of the swap list;
  - "The plan, lit up" afterwards, with counts for each piece.
- The section 10 failure path is the best teaching moment in the map. It has no rigged roll and points to a fix the player can make.
- Stage 1's live round is passive: the strip only reports. The play lives before the bout and in the minute.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Coach's preset at booking | Free-mode plan, about +3 to +7 over none | Keep |
| Film evening | One tell, −1 pad night | Keep. Price camp film the same (point 2) |
| Scout ($250, pro) | Weapon and weakness | Keep |
| Study slot (one step to 30) | Steps become plannable | Keep |
| Step pad cards to Sharp | A step fires 3 in 4 | Keep. Re-price from units (point 3) |
| Boxes (one per place) | What your boxer does after a won exchange | Keep. Show expected uses (point 6) |
| Diamonds (one per mode per box) | What to do when a mode holds | Keep |
| GUESS diamond | Pays as OK | Keep. State the pay rule (point 9) |
| Diamond order number | Which of two diamonds fires | Keep only if the CHECK shows two modes can hold at once. Otherwise **useless** |
| Round filter on a diamond | Nothing that the mode and pace don't already do | **Useless** (point 5) |
| Tray, drag to pad night | Mastery for the plan's pieces | Keep |
| Test it (a sparring night) | A worth band and fire counts | Keep. Test against what's known only (point 4) |
| Validate | Warnings, no score | Keep |
| Lock at the first bell | Edits allowed until the fight | Keep |
| Load saved plan / Copy a team-mate's plan / × clear one / Start again | Starting points | Keep. Copying by opponent is near useless (team-mates rarely share an opponent), so copy by style |
| Corner swap (REPLACE / REMOVE / no change) | One plan piece a round | Keep, as the CODE arrow change beside ONE CHANGE (point 8) |
| "Go for the finish" beats a hurt diamond | Order of rules | Keep |
| Save to this opponent's file | Rematch | Keep |
| Amateur reuse SEEN | The most-used line pays as a third use | Keep, round 1 only (point 11) |

**Missing options:**
- **Expected uses on each box,** so the player can see the bell box carries the bout (point 6).
- **"Ask your coach to rewrite with the film so far"** (one press, with the line cap): the free middle path between the preset and writing it all by hand. The pack's assistant already writes plans.
- **Pace link from a found habit** (slow starter or fades late) to the Playbook's round pace, in place of the round filter.
- **In the corner minute, "Show me the opponent's mode count this round"** ("pressed 1 of 6 exchanges"). It's the information the swap needs, and the fight already decides the mode every exchange.

## To reach 10/10

1. **Make "the opponent's mode" a new tell type** with a place in the tape order (weapon, then the top mode, habits, the second mode, the weakness). Tag the tree, GUESS and the share as built on it.
2. **One price for film:** camp tape days take a camp night, the same as a Film evening. Otherwise found modes are free in every camp.
3. **Re-price step pad cards** from the 240 pad units at the punch rate. Print the weeks from 30 to 60, and run STEPS-ONLY after.
4. **Test it plays against the known file only,** with unfound modes drawn evenly and the result marked "n modes guessed".
5. **Write the GUESS pay rule** ("pays as OK, even when right") as a rule with a hover.
6. **Cut the round filter.** Found slow starter and fades late suggest round pace in Validate.
7. **Each box prints its expected uses a round** and how many pay in full (PlanRead). Change pass line 6 to a minimum share for each box.
8. **M11 is the plan arrow change (CODE),** separate from ONE CHANGE. Drop "resets its PRESSURE", or probe a per-line PRESSURE first.
9. **Replace "FixLab" with "your coach's pick",** and stage 3's "70%" with a word band.
10. **Amateur reuse SEEN applies in round 1 only.**
11. **Add "Your coach rewrites it"** (one press, using the found tells) and the corner minute's mode count.
12. **Run probes 1–8, 10 and 11,** then replace every ESTIMATE in 5, 6.3 and 7.5.
13. **Settle the Claude CHECKs:** habit as `when`, two modes at once, FireLevel for steps.
14. **Stage 2's aimed shout** makes the live round something you do, not something you watch. Stage 1's strip stays a report.

## The 1920×1080 page (Fighter > Playbook > Game plan, Look B whiteboard)

**Header (0–120):** your boxer's polaroid on the left and the opponent's on the right, each name once; 60 kg, the style words, the stances; "bout in 18 days". The dark top bar holds CONTINUE, the only green.

**Left (40–440), THE FILE as a tree:**
- The bell place at the top and six mode branches.
- **Tires and Hurt** are marked FREE.
- **Presses** is FOUND, "3 of 4 films · often".
- **Waits to counter** is blank, "not seen yet: 1 Film evening (−1 pad night)".
- The red "biggest hole" box appears only once the weakness is found.
- A pace sticky, "Slow starter: Push round 1", with Use it.
- At the foot: Film evening, Your coach rewrites it, Load the saved plan (only if one exists).

**Centre (480–1440), the chart:**
- The bell box at the top is the biggest card. It prints the move, "SHARP 64 · fires 3 in 4 · +2.1" and "about 3 uses a round, 2 in full".
- The boxes by place hang below it, joined by marker arrows labelled with places. Thin grey arrows run back up, labelled "lost: back here".
- Each diamond sits right of its box and prints the mode, the answer, BEST / OK / WRONG / GUESS, the share band, and an ×.
- A Raw piece carries a red stamp, "UNDER 30: SKIPPED".

**Right (1480–1880), WHAT IT COSTS:**
- Lines 5 of 6.
- Drill cards 7 against pad nights 5.
- Study slot: pivot out, 2 weeks to 30.
- Film evenings 2.
- The Validate list, one line a warning.
- The last test, "+6 to +10 over no plan · 1 mode guessed", in gold (the one gold).

**Bottom (980–1060):** Validate, Test it in sparring (Thu), Save, Clear.

**The corner minute (M11) uses the same chart, dark:**
- **Left:** the counts ("Body hook fired 3, won 2"; "the opponent pressed 1 of 6") and "we think we're ahead".
- **Centre:** the chart with dead diamonds outlined, REPLACE or REMOVE.
- **Right:** the bench with fire rates, and your coach's pick outlined.
- Below, separately, the ONE CHANGE row as today.

## Sources
- England Boxing, [Rule Book 2023/24](https://www.englandboxing.org/wp-content/uploads/2023/09/Rule-Book-Final.pdf), read 2026-11-14. OFFICIAL:
  - 12.10.1: a club coach gets the bout score totals only, on a written request within 20 minutes of the end of the bout, in random order;
  - 11.1.7: with manual scoring, the round scores go to the Supervisor between rounds, not to the corners.
  - I didn't check the 2026 edition's numbering for these clauses.
- IBA, [Technical and Competition Rules](https://www.iba.sport/wp-content/uploads/2022/09/20220901-IBA_Technical__Competition_Rules.pdf) (2022), read 2026-11-14. OFFICIAL, 18.8: the judges' round scores "must not be disclosed or displayed until the winner of the Bout is announced".
- Whether UK amateur corners keep a formal count of their own: NOT FOUND.
- All other figures are DERIVED from the critic pack (4.2 pad rates, S463 slot rate, PlanRead, FireLevel, 59/45/41) and the map's own numbers.


# CRITIC ANSWER: DESIGN_PLANFLOW1_V2_CRITIC_MARIA_MARIA.md

# DESIGN_PLANFLOW1_V2_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ134)

Brief: research/DESIGN_PLANFLOW1_V2_CRITIC_MARIA.md
Sent: 2026-11-14 20:45 | collected: 2026-11-14 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give PLANFLOW1 v2 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**. It reaches the owner's bar, but GENERAL DESIGN only just makes it.

v2 fixes v1's big faults:
- The ten invented IFs are now the fight's six real modes.
- Step answers are paid for through the single study slot and pad time.
- PlanRead and ProRead are tagged as built.
- Plan B is one arrow back to the bell box, not a second system.
- Every state is printed as a word.

It stays at 6 because eight Claude CHECKs still decide whole rows, the main screens have no agreed mockup, and no probe has run.

## Scores

**1. DEPTH: 7/10**

What works:
- **Film is now the only route to BEST against a mode the style word doesn't give away.** A guessed answer caps at OK, and a film evening costs a pad evening. That one rule makes film, pad time and the plan trade against each other every week.
- **How often a habit showed on film is a real bet.** "Showed in 3 of 4 films, often" against "1 of 4, rare" lets you weigh a BEST answer on a rare mode against an OK answer on a common one. Real corners do exactly this from tape: you plan for what the opponent does most, not what they did once.
- **Five built rules stop any one plan from winning.** PlanRead pays a line in full only twice a round. ProRead waits for a pro's most-thrown punch. Wrong answers shrink your energy ceiling. Pad time is limited. A step waits on the study slot. The best plan has to be built for this opponent, drilled, and spread over two or three answers.
- **The corner swap gives the player something to steer in stage 1.** Diamonds that never fired are listed first, and the swap list comes from what your boxer has actually drilled.
- **The failure example in section 10 teaches without a rigged roll:** "two IFs on pressing, never fired".

What holds it back:
- **Measured gains are small.** In the brief's sample bouts, the best single change took the plan from 9 wins in 40 to 11. Pass line 1 asks GOOD to beat PRESET by 8+, but nothing yet shows the gap is that wide. If it isn't, the editor is a lot of screen for 3 or 4 bouts in 100.
- **Two of the four habit rows rest on CHECKs.** Whether a habit can be an IF, and whether a diamond can be limited to certain rounds, are both unconfirmed. Without them, the habits only add a share label, and the "slow starter" and "fades late" depth disappears.
- **The timing rules for slow starter and fades late may be free picks.** If a "round 1 only" diamond takes no extra line, it's always worth setting. Say it costs one line like any diamond.

**2. GENERAL DESIGN: 6/10**

What works:
- Every critic point has a row: done, done in part, or not done with a reason.
- Book answers only, with no new content.
- Lines share the coach's 4–6 cap, as in the code.
- No percents, no score, no timer, no judges' cards.
- The held-back list obeys the owner's rulings (Q-212 no percent buffs, S439 buttons that follow the game).
- No names in the body and no fixed pronouns.
- Section 11 wires 16 menus, each marked CODE or NEW.

What fails:
- **The main screen isn't agreed.** The editor replaces the Game plan tab's move map, and the opponent's tree replaces "What your plan should answer". Pack section 7 says screens come only from agreed mockups. The map's own owner question 1 asks this, so stage 1 can't start until he answers it and approves a drawing.
- **It weakens something players can do today.** Today a diamond on any mode is rated by the code. GUESS caps an unfound mode at OK, which is right for depth but changes current results. That shifts the 59 / 45 / 41 balance, and no probe yet re-measures it.
- **Eight CHECKs change the sums.** Film with no camp decides row 2 of the decisions table. Habit-as-IF and the round filter decide three habit rows. Whether FireLevel applies to steps decides how step answers are priced. Whether two modes can hold at once decides diamond order. Stage 1 depends on all of them.
- **Amateur reuse is invented.** "Met before: your most-used line starts SEEN" has no source in real amateur boxing or in the code. It's reasonable, since amateur coaches do remember opponents from club shows. Tag it GAME VALUE and give the player a way to see it coming (the Rival file prints "SEEN: met before", which is good).
- **Test it changes a built feature.** Today Test it has limited tries. The map makes each test cost a sparring night instead. That's a fair price, but it changes the Week, because PEAK already has two sparring nights. Say whether a test can use one of the coach's planned sparring nights or must add a new one.
- **Locking the plan at the first bell** is a NEW rule. Today edits after the weigh-in are possible. That's fine, but it's a change, so give it its own probe.
- **Six presets are content** that nobody has costed. Each needs writing and tuning so PRESET lands 3 to 7 points above no plan.

**3. PLAY: 6/10**

There's a weekly rhythm:
- Film fills in a blank branch of the opponent's tree.
- Validate gives a short to-do list.
- Test it costs an evening and returns a band.
- On the night, FIRED lands on the strip.
- The corner minute shows what's dead.
- "The plan, lit up" shows the whole chart afterwards.

Filling in the opponent's tree is the best anticipation the plan has had. But the payoff is a 3 to 8 point swing in close bouts, and most of the time spent happens before the bout, in an editor. Stage 1 has no live choice beyond today's shouts and one swap a round.

## Options: missing, useless, and what each changes

**Missing**
- **"Use the coach's plan and edit one line":** the fastest way into the editor for a player who doesn't want to draw from scratch.
- **Mark one diamond as the main bet.** Its share band and fire count lead the corner read, so the swap decision is about that bet.
- **A study-slot queue of one:** "next step after this one". The pack says only one step can be learned at a time, so without a queue the plan's second step need waits on the player remembering it.
- **A line on the bout offer:** "Plan from your last bout against this style: +n". Use the band, not a percent.

**Useless or near-dominant**
- **"Copy a team-mate's plan" for the same style:** the drill cards almost never match another boxer's mastery, so it fills the board with red stamps. Keep it for the same opponent only.
- **Diamond order "1",** if the code can't let two modes hold at once. Then it's a label with no effect. Cut it unless the CHECK says yes.
- **The tired IF on every box:** it's free for everyone and the opponent is always there by round 3. Expect one on every plan. Fine, but then make it part of the preset and stop counting it as a choice.
- **The coverage count "answers 3 of 4 known modes"** risks becoming a score the player fills for its own sake. Show it only when a common mode is left unanswered.

**What each option changes**
- **Film evening:** opens one tell, filling a branch, and turns a GUESS into its real rating. Costs about 240 pad units.
- **Scout ($250, pros only):** opens the weapon and the weakness at once and narrows the chance range.
- **Study slot:** about +6 a week on one step, until Usable 30.
- **Step pad card (NEW):** takes a step from 30 toward Sharp 60, sharing pad time with punches.
- **Box:** your boxer's main answer in a place after a won exchange. Worth is shown as the edge.
- **Diamond:** taken first when its mode holds. BEST, OK, WRONG or GUESS changes the edge, and WRONG shrinks the energy ceiling.
- **Timing rule:** limits a diamond to round 1, or to round 3 and later.
- **× (clear one):** frees a line.
- **Test it:** spends that evening on sparring, spreads 180 units over the plan's moves, and returns a band.
- **Validate:** shows warnings only.
- **Save, Load the saved plan, Copy a team-mate's plan:** save the plan, reuse it for a rematch, or start from another boxer's plan.
- **Start again (preset):** the coach's plan for the style word, using free modes.
- **Corner swap:** replaces or removes one piece. The new piece's PRESSURE starts at zero.
- **Say nothing:** holds the plan.
- **"Go for the finish":** beats a hurt diamond and spends one of the two instructions that get through each minute.

## To reach 10/10

1. **Get the owner's yes, and his OK on a drawing, before P10.** Ask "the chart replaces the move map as the Game plan tab's first view?", then show him M1, M10 and M11 at 1920×1080 in Look B. Nothing in stage 1 builds before that.
2. **Settle the four CHECKs that decide stage 1:** Film with no camp, habit as an IF, the round filter, and FireLevel on steps. Cut any habit row whose CHECK says no rather than inventing a stand-in.
3. **Run probes 1, 2, 4 and 10 first.** If GOOD beats PRESET by under 8, make GUESS cap at "OK minus 1" before building the editor, so film is worth its evenings.
4. **Re-measure 59 / 45 / 41 with GUESS on.** Print the new figures beside the old ones in the pack.
5. **Price the free picks.** A timing rule takes one line. Copying a team-mate's plan works only for the same opponent. The tired IF goes into every preset.
6. **Say where a test's sparring night comes from.** It replaces one of the coach's planned sparring nights in BUILD or PEAK, never a TAPER night, and the Week shows "Thu: sparring (plan test)".
7. **Tag amateur reuse GAME VALUE,** and add AMREUSE to the first probe batch, since it changes rematch odds.
8. **Add a "main bet" mark** on one diamond. The corner read leads with it, and the Why grades it first ("Main bet: presses, fired 4, won 3").
9. **Add a one-step queue to the study slot.** "Next: pivot out (the plan needs it)" moves in by itself when the slot frees.
10. **Give stage 1 one live decision.** At the first exchange in which a found mode shows, the strip offers "Lean on it". Your next shout is aimed at that diamond's answer and counts as one of the two instructions that get through each minute. Today that's stage 2. Move it to stage 1 if the shout code allows it.

**My 10/10: Fighter > Playbook > Game plan, 1920×1080, Look B whiteboard**
- **Dark top bar:** the date, cash, and CONTINUE reading "to Sat 28, fight night".
- **Header (0–120):** your boxer's polaroid on the left and the opponent's on the right, each name once. Class in kg, style word, stance. The fight date circled, "18 days".
- **Left (40–440), THE OPPONENT:**
  - A marker tree, with the bell place at the top and six mode branches.
  - Found branches read "presses · 3 of 4 films · often" with the habit's answer. Blank outlines read "not seen yet: 1 Film evening".
  - The biggest hole as one red box, labelled in words.
  - Buttons: Film evening (Tue, −1 pad night), Load the saved plan, Start again.
- **Centre (480–1440), YOUR PLAN:**
  - The bell box at the top, then boxes by place, joined by arrows labelled with places, and grey "lost: back here" arrows.
  - Each box shows the move, "SHARP 64", "fires 3 in 4", "+2.1", a red "UNDER 30: SKIPPED" stamp when it applies, and an ×.
  - Diamonds to the right show the mode word, the answer, BEST / OK / WRONG / GUESS, the share band, and a timing tag ("round 1 only").
  - One diamond carries a gold "MAIN BET" magnet.
- **Right (1480–1880), WHAT IT COSTS:**
  - "Lines 5 of 6".
  - "Drill cards 7, pad nights 5".
  - "Study slot: pivot out, 2 weeks; next: step back".
  - The Validate list, one plain line each.
  - The last test's band, "+6 to +10 over no plan".
- **Bottom strip (980–1060):** Validate, Test it (Thu sparring), Save, Clear. A line in words: "Ready for fight night: 1 warning".


# CRITIC ANSWER: DESIGN_PLANFLOW1_V2_CRITIC_DOLA_DOLA.md

# DESIGN_PLANFLOW1_V2_CRITIC_DOLA_DOLA - Dola answer (seat queue SQ137)

Brief: research/DESIGN_PLANFLOW1_V2_CRITIC_DOLA.md
Sent: 2026-11-14 20:45 | collected: 2026-11-14 21:10 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.

(the brief is cut; her reply:)
.
Show More
PLANFLOW1 v2 — Critic Score & Review
I've reviewed the full critic pack and the v2 design map. Scores out of 10 each, with reasoning.
📊 Scores
1. DEPTH — 7/10
✅ Real trade-offs: Film costs pad time; steps cost study-slot weeks; a plan stuffed with un-drilled moves gets red stamps; one-answer plans get eaten by PlanRead/ProRead. No dominant build — GOOD beats PRESET, but PRESET beats nothing and is free.
✅ Interacts with the wider game: pad budgets, step mastery, scouting, camp phases, ProRead/PlanRead rules, and the corner's single swap all tie directly into existing systems.
⚠️ Gap: Most values are still ESTIMATE — we don't know if the margins hold up across all 6 styles. STEPS-ONLY is targeted but unproven. Habits as when conditions are still a CHECK — if they don't work, depth drops noticeably.
⚠️ No true counter-play loop yet — the opponent reads your plan, but you can't build a decoy plan before they've seen you fight. Amateur reuse is a start, but shallow.
2. GENERAL DESIGN — 8/10
✅ Clean mapping: Boxes = moves/combos/steps; Diamonds = IF conditions; Arrows = flow between positions. Everything maps directly to existing code systems (PlanBoard, PlanChain, PlanRead, StepMastery). No invented systems.
✅ Consistent language: One word per concept (BEST/OK/WRONG/GUESS; FIRED/SEEN; Usable/Sharp/Signature). No flavour text, no percent buffs. Follows the "names only in headers" rule.
✅ Actionable information only: Validate gives specific warnings, not abstract scores. Everything shown is something the player can fix.
✅ Stage-gated complexity: Stage 1 keeps it simple; advanced mechanics arrive later. Clear what ships when.
⚠️ Several CHECKs remain — Film-without-camp, whether steps use FireLevel, multi-mode priority order. These need resolving before it's fully buildable.
3. PLAY — 7/10
✅ Clear loop: Scout → Film → Build → Drill → Test → Fight → Review & Save. Every step feels meaningful. "The plan lit up" showing exactly what fired and why is the strongest hook.
✅ Anticipation builds: You see branches fill in on the opponent's tree as you watch film. The corner swap keeps you engaged between rounds. Rematch/load/copy saves repetition.
✅ Honest feedback: Wrong choices show clearly in the Why — "two IFs on pressing, never fired" — and suggest the fix directly.
⚠️ Stage 1 can feel passive: You build the plan, then mostly watch it execute. The single corner swap helps, but you're still not actively guiding during the round itself.
⚠️ No meaningful progression on the plan itself — it doesn't evolve with your fighter's career beyond unlocking more lines at higher Fight IQ/bout counts.
Bar check: DEPTH 7 ≥ 6 ✓ | GENERAL DESIGN 8 ≥ 6 ✓ — ✅ Meets the design bar.
🔍 Options Analysis — Missing, Useless, & What Changes What
✅ What Each Option Changes
Table
Option	What it actually changes	Cost
Film evening	Reveals opponent mode → diamond becomes BEST instead of GUESS	−1 pad night
Scout (pro)	Reveals weapon + weakness instantly	$250
Study slot	Raises one step toward Usable (30)	Blocks other step progress
Pad drill card (step)	Raises a step from Usable → Sharp	Shares pad time with punches
Test it	Shows which diamonds fired + win-rate band; drills all plan moves	−1 sparring night
Validate	Lists gaps/risks before fight night	Free
Swap in corner minute	Replaces one dead/wrong piece; resets PRESSURE on that line	1 per round; only change allowed
Save plan	Stores it on opponent's file for rematch	Free
Load/Copy plan	Starts from a known-good baseline	Free
❌ Missing Options
Filter the opponent's tree by round shown — habits like "slow starter" or "fades late" exist, but you can't yet filter when a mode appears in the tree view
Compare two plans side-by-side — you can test one, but not see Plan A vs Plan B win-rate side by side
Mark a branch "low priority" — film is finite; let players flag which tells they don't need yet
Auto-switch preset — "if opponent style changes during scouting, offer the matching preset"
Plan version history — see what you changed between versions and how that affected outcomes
🗑️ Useless Options (already removed or flagged)
Plan B bar / separate fallback plan → replaced by "lost: back here" arrow
Lock at weigh-in → moved to first bell
Limited free Test tries → each Test costs a sparring night
HURT stub on every box → one line in THE FILE
Multiple diamonds on same mode → editor blocks duplicates
Plan quality percentage score → replaced by Validate warnings + coverage count
Simulate button (free) → Test it costs a sparring night instead
🚀 To reach 10/10 — Concrete Changes, Priority Order
Priority 1 — Resolve & Verify (Ship Blockers)
Run all probes (1–11) across 3 seed sets × 6 styles. Replace every ESTIMATE with measured numbers. If GOOD doesn't beat PRESET by 8+ points, increase the film/drill payoff gap. If STEPS-ONLY finishes more than 4 points below GOOD without being viable, adjust pad time cost for steps to Sharp.
Resolve all 8 Claude CHECKs:
✅ Allow Film evenings without a booked camp → "Watch tape" from the opponent's file anytime
✅ Enable habit triggers as when: conditions in PlanBoard.pick
✅ Implement round filters (round 1 only / from round 3) on diamonds
✅ Confirm steps use FireLevel values — if not, lower pad time cost to compensate
✅ Define multi-mode priority order — let player manually reorder when both could fire
✅ Standardise "showed in n of m films" counting — minimum 3 films for "often" band
✅ BJJ 3-beat mode detection — confirm BjjTree can track timing reliably
✅ Stage 3 cutman integration — tie "eye closing" to an emergency box condition
Close the feedback loop: Once a plan is SEEN (ProRead/rematch), show which specific line got read in the opponent's tree, and suggest 1–2 easy swaps directly in the SEEN warning itself.
Priority 2 — Depth & Counter-Play
Decoy/Feint plans (Stage 3): Let players mark 1 line as "bait" — it fires at 50% effectiveness but ProRead targets it instead of your real weapon. Costs 1 line slot; blunts SEEN entirely for 1 bout.
Partial plan carry-over: After a win/loss, keep 2–3 highest-firing lines locked into the next bout's baseline — don't rebuild from scratch every time.
Opponent adaptation preview: In the corner minute, show next round's likely mode shift based on this round's pattern — "pressed all 3 exchanges → likely to tire in round 2" — not just what already happened.
Priority 3 — Polish & Discoverability
Interactive tutorial overlay: First time opening the editor → walk through: Bell box → position flow → diamond IF → BEST/WRONG rating → Validate → Test it → Save. 5 tooltips max, skippable.
Plan comparison view: Side-by-side chart showing which lines fired/won across the last 2 bouts against the same opponent.
Heat map overlay on the tree: Darker branches = fired more often across your history against this style/opponent.
🖥️ 10/10 Screen Design — 1920×1080 Spec
Game Plan Editor — Look B (Gym Whiteboard Style)
plaintext
┌─────────────────────────────────────────────────────────────────────┐
│  [⬅ Back]      YOUR BOXER          vs          THE OPPONENT        📋 │
│  Style: Out-boxer              Style: Pressure Fighter   12 days to  │
│  Stance: Orthodox              Stance: Orthodox      bout             │
├──────────────────┬──────────────────────────────────┬────────────────┤
│                   │  ╔════════════════════════════╗   │                │
│   THE OPPONENT    │  ║  BELL: Long Range          ║   │   COSTS &      │
│   ════════════    │  ║  ↳ 1-2  | SHARP 64  [3/4] ║   │   STATUS       │
│                   │  ╚════════════════════════════╝   │   ════════     │
│  🔵 presses       │       ↑       ↑                    │                │
│     Free · Style  │       │       │                    │   Lines: 5/6 │
│                   │  ╔═══════════╗ ╔══════════════╗   │   Drills: 7    │
│  🔵 boxes at range │  ║ Long    ║ ║ Mid-Range    ║   │   Pad nights: 5│
│     2 of 4 films  │  ║ ↳ Jab    ║ ║ ↳ Body Hook  ║   │   Film used: 2 │
│     · some        │  ║ BEST     ║ ║ BEST +2.1    ║   │                │
│                   │  ╚═══════════╝ ╚══════════════╝   │   ⚠️ VALIDATE: │
│  ⚠️ waits to cntr  │       │       │                    │   • Pivot out │
│     Not seen yet  │       ↓       ↓                    │     under 30   │
│     · GUESS       │  ╔═══════════╗ ╔══════════════╗   │   • 1-2-3-2 on│
│                   │  ║ Inside    ║ ║ Clinch        ║   │     bell = high│
│  💀 is hurt       │  ║ ↳ Uppercut║ ║ ↳ Tie Up     ║   │     energy cost │
│     Free          │  ║ WRONG ⚠️ ║ ║ BEST          ║   │   • SEEN: Cross│
│                   │  ╚═══════════╝ ╚══════════════╝   │     is most-thrown│
│                   │    ↑   ↑      ↑                     │                │
│   [Film -1 pad]   │    │   │      │                     │  +6→+10 vs no │
│   [Load Plan]     │    ╚═══╪══════╝                     │  plan (TESTED)│
│   [Copy Team]     │        │  "lost: back to bell"      │                │
│   [Start Over]    │        ╚═══════════════════════════╝                │
│                   │                                        ⚡ GOLD        │
├──────────────────┴────────────────────────────────────────────────────┤
│  [💾 Save]  [🗑️ Clear One]  [🔍 Validate]  [🥊 Test in Sparring −1 eve] │
└─────────────────────────────────────────────────────────────────────┘

Visual spec:
Background: Warm tan plaster wall, cream paper grid, thin hand-drawn marker lines
Boxes: 320×110 rounded rectangles, white card, soft shadow
Diamonds: 150×150, pale blue = FREE, soft green = FOUND, light grey = GUESS, pale red = WRONG
Text: Permanent Marker for headers, Kalam for flow, monospace for numbers
One gold accent only: the win-rate band on the right panel
No timers, no countdowns, no percentage buffs
Hover on any diamond: shows film count, fire history across bouts, and 1-sentence explanation of why the rating
Corner Minute view — 10/10 spec:
plaintext
┌─────────────────────────────────────────────────────────────────────┐
│  ⏱ ROUND 2 — CORNER MINUTE                                            │
├──────────────┬──────────────────────────────────────┬─────────────────┤
│  THE STATS   │  THE PLAN CHART                       │  YOUR BENCH     │
│  ═══════════ │  Bell→Long→Mid→Inside→Clinch          │  (30+ mastery)  │
│              │                                        │                 │
│  Punches:    │  🔴 presses diamond — NEVER FIRED     │  Jab        1/2 │
│  12 vs 9     │  🔵 Body Hook — 3 fired / 2 won       │  Cross      3/4 │
│              │  ⚡ SEEN: Cross read last bout        │  Lead Hook  2/3 │
│  We think:   │                                        │  Step Out   1/2 │
│  AHEAD       │  ┌──────────────────────────────┐    │  Pivot Out   — │
│              │  │ Replace │ Remove │ Say Nothing │    │                 │
│              │  └──────────────────────────────┘    │  [Swap Selected]│
└──────────────┴──────────────────────────────────────┴─────────────────┘

This is the design at its best: clear flow, honest feedback, meaningful choices, and direct control at exactly the moments that matter — before the fight and between rounds — never overwhelming, never passive.
Would you like me to turn this 10/10 spec into a standalone HTML mockup you can drop straight into the design review? Just say the word. ✅
Chat
Create Videos
Create Images
Writing
Homework
Translate
