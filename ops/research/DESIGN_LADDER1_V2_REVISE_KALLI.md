# LADDER1_V2 - write the NEXT version of this mechanic's design map (S459 design loop)

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

# DESIGN_LADDER1_V1_WRITE_KALLI_KALLI - Kalli answer (seat queue SQ153)

Brief: research/DESIGN_LADDER1_V1_WRITE_KALLI.md
Sent: 2026-11-15 03:10 | collected: 2026-11-15 03:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing LADDER1 v1 in full now, with reputation as the currency, the ladder screen and the probes.

# LADDER1 v1: the season ladder, with reputation as the currency (S459, S475, S477, 2026-11-15)

Part 1 of 4

This is the first map. It covers the amateur road to the first pro fight, on one regional ladder per weight class.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, `ops/research/LADDER1_RESEARCH_JOHN_JOHN.md` in full (I worked from the summary in the brief), the Miro board, the mockups and the owner's S475 note on the sparring partner screen. The owner's computer is offline. Everything here is checked against the critic pack, Claude's S477 code facts and John's summary only.

**Owner rules kept, quoted**
- **S475:** the ladder "must reach 9/10: see the ladder, find an opponent, book", with REPUTATION as the currency, not fixed win counts.
- **S428 and S425:** amateur to the first pro fight; ONE regional ladder first; every fight shows the rank earned; wired and shown on the correct menus. The living world comes after the fight week is built and played.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". How the ladder handles it is in 4.2.
- **S412:** any gym, any boxers, men or women. No fixed he or she.
- **Pack 4.5, agreed:** "a 'no' is a closed panel or an absent answer with its reason, never a random refusal". This overrules John's yes-chance (see 3).
- **Pack 7:** only actionable information. One word per concept. Nothing opens by itself. Screens only from agreed mockups, so the ladder page waits for the owner's OK on a drawn page (owner question 2).
- Classes in kg: women 57/60/65/75, men 57.5/60/70/75. Females never fight males: each ladder is one sex and one class.
- "Gym" is the facility. Amateurs have a fight week, not a camp (AMATEURWEEK1 v9: 1–2 weeks out).

**Marks**
- **REAL:** a real rule or source, as John reported it.
- **CODE:** in the code today (S477).
- **GAME VALUE:** a fixed design number that isn't meant to be tuned.
- **ESTIMATE:** ours, gated by the probes in 6. Every reputation number is ESTIMATE until those run.
- **NEW:** a rule this map adds. **CHECK:** a fact someone must confirm. **v2:** later.

**One word per concept**
- **Reputation** (0–100) is a boxer's own currency. It's a number on every screen, with the band word (2.1) beside it.
- **Standing** is the gym's reputation (CODE `Career`, today's "reputation word" on Club > People). It needs a new word so "reputation" means one thing (owner question 1).
- **Ladder** is the regional table for one sex and one class (CODE `Region.gd`), now sorted by reputation. **Place** is a boxer's position on it.
- **Ask** means your boxer asks for a named opponent. **Offer** means a bout that comes to you (CODE).
- **Chance** is the win chance shown at booking (CODE band). Reputation reads the **middle of the band the player saw**.

## 1. The currency

### 1.1 How reputation is earned (all ESTIMATE unless tagged)
**A win** gives (2 + 14 × (1 − chance)) × the win-type weight, rounded.

| Win type | Weight | Tag |
|---|---|---|
| Stoppage (RSC or KO) | 1.0 | REAL (BoxRec KO weight), used as GAME VALUE |
| Unanimous points | 0.875 | REAL (BoxRec UD) |
| Majority points | 0.55 | REAL (BoxRec MD) |
| Split points | 0.45 | REAL (BoxRec SD) |

**Worked examples**
| Chance shown | Stoppage | Unanimous | Split |
|---|---|---|---|
| 75% (safe) | +6 | +5 | +3 |
| 50% (even) | +9 | +8 | +4 |
| 30% (long shot) | +12 | +10 | +5 |

**Where the opponent sits changes it (anti-grind, NEW):**
- Opponent above you on the ladder: full value, plus **+3 for a ranked scalp**, once per opponent per season.
- Opponent 1–5 places below: half value.
- Opponent 6+ places below, or off the ladder while you're on it: 0. The win still counts on the record and still gives morale +8 (CODE).
- The same opponent twice in a season: half value the second time.

**One-off gains**
| Event | Reputation |
|---|---|
| A bout taken at short notice (offered under 14 days before the date) | +2 |
| London regional stage won (nationals) | +5 |
| National title | +10 |
| Top of the bill on your own hosted club show, and won | +3 |

**A draw** gives half the win value minus half the loss value.

### 1.2 How reputation is lost (ESTIMATE)
**A loss** costs 1 + 8 × chance, plus 2 more if stopped.

| Chance shown | Points loss | Stopped |
|---|---|---|
| 75% (lost as favourite) | −7 | −9 |
| 50% | −5 | −7 |
| 30% | −3 | −5 |

**Other losses**
| Event | Reputation |
|---|---|
| Missed weight (the club still pays $300, CODE) | −4 |
| Pulled out, not hurt | −2 |
| Pulled out hurt (the empty slot is still paid, CODE) | −1 |
| Inactive | after 8 weeks without a bout, −1 every 4 weeks |

- Suspension, injury and a nationals run pause the inactivity clock.
- A boxer leaves the ladder after 52 weeks without a bout (REAL: BoxRec's 365-day inactive rule, as GAME VALUE). The reputation is kept.

### 1.3 Where a boxer starts
- A walk-in with no bouts starts at 0.
- A prospect signed with a record starts at 4 × net wins + 2 × wins, capped at 30 (ESTIMATE).
- Ladder boxers from other clubs (CODE `Region` rows) are given reputation by the same rule when the save loads, then move by 1.1 and 1.2 whenever they fight each other at shows (CODE: rivals fight each other).
- CHECK (Claude): how many rows a regional table holds.

### 1.4 What reputation replaces (by file and constant)
| Today (CODE) | Becomes | Tag |
|---|---|---|
| `Roster.gd PRO_WINS 7` + `PRO_RANK 3` | pro offer at **reputation 55**, with the floors in 1.5 | ESTIMATE |
| `Roster.gd PRO_WINS_ANY_RANK 9` | retired (55 covers it) | NEW |
| `Roster.gd PRO_RETURN_WINS 2` | a declined offer returns at **+10 reputation** since the decline; second promoter at 0.9× terms (CODE, kept) | ESTIMATE |
| `Region.gd RANK_MIN_WINS 4` | on the ladder after **1 bout** | ESTIMATE |
| Region sort: net wins, wins, rating | **reputation**, then net wins, then rating | NEW |
| `AskBout.gd PICK_REACH 4` | ask reach **2 places + 1 per 15 reputation** (0 gives 2, 30 gives 4, 60 gives 6) | ESTIMATE |
| `AskBout.gd CAMP_WEEKS 3` | **2 weeks** minimum lead, so the fight week fits (AMATEURWEEK1 v9: no camp for amateurs) | GAME VALUE |
| `AskBout.gd SHOW_GAP_DAYS 14` | kept: 14 days between a boxer's bouts | CODE |
| `Matchmaking.gd BAND_UP 5`, `UNRANKED_REACH 15`, `TOP_ASK_FANS 3` | unchanged; pros are out of scope (8) | CODE |
| Club reputation +5 / −2 / −4 (`BoutRules.gd` about 115–123) | unchanged, renamed Standing | CODE |

### 1.5 What stays a fixed count (the real rules)
| Rule | Value | Tag |
|---|---|---|
| Novices box novices | 0–10 bouts is novice; a novice can't face an open boxer | CODE, REAL (England Boxing Rule Book 2026 2.7.8: matched on experience and weight) |
| Weight | the boxer must be able to make the class on the date | CODE |
| Bouts a season | 18 at most for seniors | REAL (2.7.9), NEW in code |
| Nationals entry | 5 bouts, 3 months registered, age 19–40 | CODE, REAL (5+ bouts) |
| Nationals draw | no seeding by reputation | REAL ("without bias") |
| Turning pro | age 18+; 5 amateur bouts at least (GAME VALUE floor, so no 2-bout pro, since BBBofC has no fixed minimum John could find) | REAL / GAME VALUE |
| Rest | a stoppage loss gives a 30-day suspension and the next bout 8 weeks later | CODE |
| Sexes | a boxer sees only their own sex's ladder | owner rule |

**The season** is the game year from Monday 5 January (GAME VALUE). It counts the 18-bout cap, the once-a-season scalp and the repeat halving. Reputation carries across seasons. CHECK (John): England Boxing's season dates.

Part 2 of 4

## 2. The choice and its depth

### 2.1 What reputation opens (only what the player can act on)
| Reputation | Band word | Opens | Tag |
|---|---|---|---|
| 0–14 | Unknown | asks 2 places up | ESTIMATE |
| 15–29 | Known locally | asks 3 places up | ESTIMATE |
| 30–44 | Rated | asks 4 places up | ESTIMATE |
| 45–54 | Contender | asks 5 places up; the pro offer is in sight ("10 to go") | ESTIMATE |
| 55+ | Pro-ready | the promoter's offer arrives (with the floors in 1.5), then asks 6+ places up | ESTIMATE |

**Cut from John's unlock list, for now:**
- **Top of the bill at 40:** on other clubs' shows the player can't act on it. On your own show you pick the headliner anyway.
- **Sponsors at 30/50/70:** sponsorships follow gym Standing (K88).
- **Rival clubs' offers at 35:** the R58 world isn't built.

All three are v2.

### 2.2 The four decisions
1. **Who to ask.** Asking above you pays full value plus the scalp. Asking below pays half, or nothing at 6+ places down. Every row prints both sides before the click ("Win +9 and the scalp +3, to 4th. Loss −4, stay 7th").
2. **When to wait.** The best target may be BOOKED or RESTING (3). Waiting costs nothing for 8 weeks, then −1 every 4. Taking an offer from below now pays half and risks the loss cost. The ladder card prints the date the target is free.
3. **When to take a long shot.** A 30% chance pays +10 to +12 plus the scalp, against −3 to −5 for a loss. **The shown chance doesn't count the plan you haven't written yet.** A good plan is worth about 59% against 45% for no plan (MEASURED, pack 1), so a player who studies the tape and writes the plan in the fight week turns long shots into the best value on the ladder. That's the skill reward. CHECK (Claude): that the band on the bout page leaves out the plan.
4. **When to defend a place.** Boxers within 3 places below send offers through the normal offer flow (CODE: one at a time, Accept or Pass, both free). Accepting risks −7 as the favourite for half value. Passing is free, but the inactivity clock runs, and a rival who wins elsewhere climbs past on reputation. A place matters because it sets who is "above you" for full value and scalps, and how far up the ask reaches.

### 2.3 A safe win and an upset, side by side
| | Safe (75%, 2 places below, unanimous) | Upset (30%, 3 places above, stoppage) |
|---|---|---|
| Reputation | +2 (half of 5) | +12, plus the scalp +3 = +15 |
| If lost | −7 | −5 |
| Morale | win +8 / loss −12 (CODE) | same |
| Risk | normal | a stoppage loss means a 30-day suspension and the next bout 8 weeks later (CODE) |
| Club Standing | +5 a win (CODE) | +5 a win (CODE) |

### 2.4 How the gym's Standing and the boxer's reputation meet
1. **Standing is still fed by wins** (CODE +5 / −2 / −4), so the boxer's road keeps the club growing (members, sponsors through K88).
2. **Standing gives pull in an ask:** a gym in the top Standing band counts as +5 reputation in the "not enough in it" check (3). ESTIMATE; CHECK (Claude) the Standing band names.
3. **The hosted club show** ($3,500, tickets $25, up to 400 seats, every 16 weeks, CODE):
   - **Bring them to your show:** invite any ladder opponent who said NOT ENOUGH IN IT, up to 15 reputation beyond the line, if you pay their travel ($150, ESTIMATE, owner question 3).
   - **Headliner:** your headliner's reputation adds to the tickets sold (NEW, ESTIMATE; CHECK Claude what the show's ticket count reads today), and a headline win gives +3.
   - **The trade:** a show can lose money (CODE), so an invite is a money-for-reputation choice.
4. **Prospects** signed with records arrive with reputation (1.3), so Standing's pull on signings matters through Find a fighter (CODE).

### 2.5 Ties to what exists
- **The fight week (AMATEURWEEK1 v9, CLUBWEEK1 v8):** an ask books 2+ weeks out, so the fight week (TAPER, 1 week out, CODE `WeekPhase`) always fits. If the date lands on another boxer's fight week or a class week, the card shows CLUBWEEK1's collision line ("This date lands on the 60 kg boxer's fight week: BAG 2"), with **Next date** beside it.
- **Sparring partners (S475 note, CHECK: not opened):** sparring gives no reputation (REAL: sparring isn't on the record). The sparring partner screen lists an outside partner's style ($160, CODE) and marks the one whose style matches the asked opponent. No other link until the note is read.
- **The pro offer (TURNPRO1):** it arrives at reputation 55 with the floors in 1.5, in the existing Pro offer modal (CODE: the debut money picture, "tickets she sells"). Tickets read reputation (CHECK Claude). Turning pro sets the starting pro fans to reputation ÷ 10, rounded down (ESTIMATE), so a 55 becomes 5 fans. That puts `TOP_ASK_FANS 3` within reach without retuning Matchmaking.
- **Weight:** an ask whose date the boxer can't make shows OVER WEIGHT with the scale forecast and the later date (CODE later-date path, pack 4.4).
- **The nationals:** entry stays 5 bouts (CODE). While in the run, no asks and no offers (CODE). A won stage and a title give reputation (1.1).

### 2.6 The dominant strategies checked
| Strategy | Why it looks strong | Why it doesn't win (ESTIMATE; probe 6 must confirm) |
|---|---|---|
| **Safe wins only** (75%+) | about 3 a bout on paper | safe opponents sit below, so they pay half or 0, and a loss as favourite costs −7. The worked average comes to about +1 a bout, so about 50 bouts to reach 55, beyond the 18-a-season cap |
| **Ask up always** (30%) | +15 a win with the scalp | wins 3 in 10 at the shown chance, and stoppage losses bring suspensions and 8-week waits that burn the season. About +2.6 a bout, and the inactivity clock runs while resting |
| **Even, above you** (45–60%) | the intended road | about +4 a bout, so about 14 bouts and a season and a bit to 55, with plan skill moving it faster |
| **Sit at a high place and wait** | no losses | inactivity costs 1 every 4 weeks after 8, rivals pass on reputation, and waiting earns nothing toward 55 |
| **Grind one weak club's boxers** | easy wins | the 6+ places-below rule gives 0, and repeats give half |
| **Host every show and invite up** | buys long shots | $3,500 every 16 weeks at most (CODE), plus travel, and the show can lose money |

**What should win:** steady bouts against boxers just above, with a written plan, plus long shots when a found tell gives an edge the band doesn't show.

Part 3 of 4

## 3. A refusal that teaches
**No rolls.** The answer to an ask is worked out from shown numbers, so it's printed on the row before the player clicks. That keeps the pack's agreed rule ("never a random refusal"). John's yes-chance is rejected for that one reason: a shown percentage that then says no is still a random refusal. The fight's own dice stay the fight's.

**Every row carries one word, and the card says why and what turns it to YES:**

| Word | Why (the card's line) | To get a yes (the card's line) | Source |
|---|---|---|---|
| **YES** | "The opponent's corner takes it." | none | NEW |
| **OUT OF REACH** | "Asks reach 4 places up; this is 6 up." | "Reach 6 places up at reputation 60 (now 41)." | ESTIMATE |
| **NOT ENOUGH IN IT** | "The opponent is 22 above; corners say yes within 15." | "Yes at reputation 47, or bring them to your show ($150 travel)." | ESTIMATE |
| **BOOKED** | "The opponent is booked on 14 Mar." | "Free from 28 Mar: ask then." | CODE (SHOW_GAP_DAYS 14) |
| **RESTING** | "Stopped on 2 Feb; out 8 weeks." | "Free from 30 Mar." | CODE |
| **NOVICE / OPEN** | "Novice against open is not allowed." | "Your boxer is open at 11 bouts (now 8)." | CODE, REAL |
| **OVER WEIGHT** | "On the day: 61.4 of 60 kg." | "Makes weight by 28 Mar: Next date." | CODE |
| **SEASON FULL** | "18 bouts this season." | "Opens again on 4 Jan." | REAL |
| **YOUR BOXER IS OUT** | "Suspended until 3 Mar." | "Ask from 3 Mar." | CODE |

**Rules for the refusals**
- Rows are never hidden or silently greyed. A refused row stays readable with its word.
- **Within reach** is the default filter. **All** shows the whole ladder.
- **Never a hidden gate:** every gate in 1.4 and 1.5 has a word in this table. The NEXT STEP line on the fighter page names the next one ("Pro offer at reputation 55: 14 to go").

## 4. The screen

### 4.1 Where it sits
- **Fights, under OFFERS ON THE TABLE:** a LADDER block, one ladder at a time, picked by the fighter tabs (portrait and class). This is the agreed "Ask for a fight sits under the offers" (MENU_STRUCTURE_S402), now built as the ladder.
- **World > Rankings** keeps the read-only table, now sorted by reputation, with a Reputation column and a link, "Open on Fights".
- The owner OKs the drawn page first (owner question 2).

### 4.2 Names (S448)
- The page header holds the ladder title ("WOMEN'S 60 KG: LONDON REGIONAL") and your selected boxer's name once.
- **A ladder row's name cell is that row's header,** the one place an opponent's name sits. Opponents need names to be told apart, and a row is a header for that opponent. Each name appears once per row, in that cell only.
- The card's header repeats the selected opponent's name once.
- **Never a name in** buttons ("Ask for this bout"), chips, Why lines, To-get-a-yes lines, the result line or the week review. They say "the opponent", "your boxer", "her" or "him" (that fighter's own), or the weight class.

### 4.3 The page at 1920×1080 (Look B whiteboard; drawn in the next board session)
**Top strip (120–220)**
- Your boxer's reputation bar, 0–100, with pins at 55 (pro offer) and the next reach step.
- The band word and the number.
- One "what next" line in marker, from the rules: "Win once above you to pass 45: reach 5 places up."

**Season strip (220–300)**
- The next 26 weeks as day cells: club shows (every other Saturday, CODE), booked bouts, fight weeks, the hosted show, nationals entry close (week 10).
- Bouts this season: "7 of 18".

**The ladder (left, 40–1260)**

Rows, top place first. Your boxer's row is highlighted with the portrait. Each row shows:
- the place, and an arrow for movement since last Monday;
- the name cell (the row header);
- club;
- record with a NOVICE or OPEN tag;
- reputation;
- style word (CODE);
- last bout (date, W/L, how);
- chance band (CODE, wider when unscouted);
- **Win** "+9, to 4th" and **Loss** "−4, stay 7th";
- the answer word from 3.

Filters: **Within reach** (default) and **All**. Up to 20 rows; CHECK the table size.

**The card (right, 1300–1880)**, for the selected row:
- the name header and the tale of the tape (record, age, height, reach, stance; CODE);
- the chance and how sure it is;
- the date: the earliest show both can make, 2+ weeks out, with a **Next date** chip;
- CLUBWEEK1's collision line, only when there is one;
- "Win gives / loss costs" with the parts on hover (chance, win type, place, scalp);
- the answer word with Why and To get a yes;
- one gold button, **ASK FOR THIS BOUT**, shown only on YES;
- **Bring them to your show** only on NOT ENOUGH IN IT, with a show booked.

Green stays on CONTINUE only.

### 4.4 Clicks to a booked bout: 2
1. Click a row.
2. Click ASK FOR THIS BOUT.

The bout is booked on the card's date, the same as Accept on an offer (CODE: the poster reveal, then the fight-week note on Home). Withdrawing before Continue is free. After Continue it's a pull-out (−2, 1.2). The quiet path for a player who doesn't ask is unchanged: offers still arrive (CODE).

### 4.5 Every fight shows the rank earned (S428)
- **Before the bout:** the offer card, the versus screen and the bout page show "Win +9, to 4th. Loss −4, stay 7th." (S410 versus screen: "what a win and a loss change").
- **The result screen,** under the scorecards: "Reputation 31 to 43 (+12: won from 30%, stoppage). Ladder 7th to 4th." Hover lists each part. A loss reads "Reputation 43 to 37 (−6: lost as favourite, points). Ladder 4th to 6th."
- **The Why:** unchanged (plan, against you, next). The NEXT line may name the ladder only when the next gate is one bout away ("One win above you: pro offer").
- **The week review** gets one row per boxer who fought or moved: "Ladder 4th, up 3. Reputation 43." It also lists inactivity losses and rivals who passed, with the cause ("The 5th-placed boxer won on Saturday: now above you"). The rows land one at a time (CODE), with the biggest move last.
- **History:** each bout row gains "Reputation +12, 7th to 4th".

## 5. Every menu it appears on, and what each is wired to (S425)
| Menu | What shows | Wired to |
|---|---|---|
| **Fights > LADDER** (owner OK needed) | fighter tabs, reputation bar with pins, what-next line, season strip, rows (4.3), filters, card, ASK FOR THIS BOUT, Bring them to your show, Next date | Ladder (NEW), RepRules (NEW), AskAnswer (NEW), AskBout (reach, lead, gap), Region, ClubDeal.forecast, WeekPhase, Fixtures |
| **Fights > OFFERS ON THE TABLE** | each offer card gains "Win +n, to place. Loss −n" | OfferCard, RepRules.preview |
| **Versus screen / bout page** | the same line; ranks at stake read reputation | BoutPage, BoutCompare, RepRules.preview |
| **Fight night result** | the reputation and ladder line with hover parts | FightResult, RepRules.apply, RepLedger |
| **The Why** | NEXT may name the ladder gate when one bout away | FightWhy, ProGate |
| **Week review** | ladder and reputation row with causes; inactivity; rivals who passed | WeekReview, RepLedger, Ladder |
| **Home** | YOUR FIGHTERS rank column reads "4th · 43"; Since last Monday gives rank moves with causes; a Pro offer need (CODE) | Home, HomeRows, RepLedger, ProGate |
| **Fighter > Overview** | NEXT STEP road ("Pro offer at reputation 55: 12 to go"; reach step); reputation in the header beside record and rank | FighterPage, ProGate, RepRules |
| **Fighter > History** | reputation and place per bout | History, RepLedger |
| **Fighters > Roster cards and table** | rank tile with reputation; the table's Rank column sorts by reputation | RosterCards, FighterCard, Ladder |
| **Fight prep** | VS header shows the reputation at stake | FightPrep, RepRules.preview |
| **World > Rankings** | read-only ladders sorted by reputation, with a Reputation column and Open on Fights | World.gd, Ladder |
| **World > News** | only your boxers' ladder moves and the rivals who passed them | WorldNews, RepLedger |
| **World > Championships** | unchanged (5 bouts, no seeding); won stages add reputation | Championships, RepRules |
| **Pro offer modal** | arrives at 55 with floors; tickets read reputation; starting fans | ProOffer, ProGate (replaces the Roster constants) |
| **Club > Money > CLUB SHOW** | headliner pick; invites with $150 travel; tickets read the headliner | ClubShow, AskAnswer, GymBills |
| **Club > People > MEMBERS** | "reputation word" renamed Standing | Career (label only) |
| **Fixtures / FightPoster** | asked bouts listed; the poster shows each boxer's place | Fixtures, FightPoster |
| **Office desktop** | fighters' flags read the ladder; nothing new | OfficeDesk |
| **Records** | milestones: entered the ladder, first scalp, reached 55 | Records, RepLedger |
| **Handbook** | Reputation, Standing, Ladder, Ask: one entry each | Handbook |
| **Top bar** | no new flag (PRO OFFER exists, CODE) | Shell |

Part 4 of 4

## 6. Probes (played bouts, 40 seeds × 2 seasons, all 8 classes, three seed sets; no screen before its table)
**Baseline first (BASE0):** today's fixed counts (7 wins + top 3, or 9). This measures the median weeks to the pro offer, so the new ladder is judged against a real number, not a guess.

**Bots**
| Bot | What it does |
|---|---|
| ASKUP | always asks the highest YES above |
| SAFE | takes only 65%+ chances, offers or asks |
| WAIT | climbs to the top 5, then fights only at 60%+ and waits for a target otherwise |
| COACH | default play: takes offers as they come, asks when the best YES pays more than the best offer |
| PLAN | COACH plus long shots when a found tell answers the opponent's weapon |
| RANDOM | random choices |

**Pass lines (ESTIMATE; a failed line retunes 1.1–1.2, not the screen)**
1. **No dominant road:** no bot reaches the pro offer more than 20% faster than the median of all bots. SAFE and ASKUP are each at least 15% slower than COACH.
2. **Skill shows:** PLAN reaches the offer 10–25% faster than COACH.
3. **Pace:** COACH's median weeks to the offer is within ±25% of BASE0. The road keeps its length and loses its fixed gate.
4. **Risk is real:** ASKUP's stoppage losses are 1.5× SAFE's or more.
5. **Waiting costs:** WAIT drops out of the top 3 within 16 weeks of stopping in 60%+ of seeds.
6. **Asks are worth it:** an asked bout beats the best offer that week in reputation-per-bout by 1.5+ for COACH. This is the bot test the pack asks for (R37). If it fails, the ask stays an offer filter only.
7. **Refusals are reachable:** every refusal word turns to YES within 8 weeks in 70%+ of the cases where the player follows its To-get-a-yes line.
8. **Spread:** the top 5 of each ladder sit at reputation 45–75 at week 52, and no ladder has 3+ boxers over 55 for longer than 8 weeks.
9. **Grind shut:** a bot fighting only boxers 6+ places below reaches 55 in 0 seeds.
10. **Honesty test:** 100% of results and week reviews print the rank line, and the parts on hover sum to the change.

## 7. Build order (small pieces; pure rules first, each with its test)
1. **RepRules** (pure): earn and lose (1.1, 1.2), anti-grind, the preview for a given chance and place. Test: the worked tables in 1.1 and 1.2 as fixtures.
2. **RepLedger** (pure): each change with its cause, read by the result, the week review and History. Test: the parts sum to the change.
3. **Ladder** (`Region` change): sort by reputation, entry after 1 bout, rival reputation at load (1.3), inactivity, drop-off at 52 weeks. Test: seeded ladder order.
4. **AskAnswer** (pure): the answer word, Why and To get a yes from shown numbers only (3). Test: one fixture per word, and no randomness (same input gives the same answer).
5. **ProGate** (replaces the `Roster` constants): 55 plus the floors, the +10 return, starting fans. Test: the four fixtures.
6. **AskBout wiring:** reach, the 2-week lead, the 14-day gap, the 18-bout cap. Test: the cap and lead fixtures.
7. **Probes** BASE0 and 1–10. Tune, then freeze the numbers.
8. **Lines on existing screens:** the result line, week review row, offer and bout page preview, Home rank column, NEXT STEP, World > Rankings column. The Standing label waits for owner question 1.
9. **The LADDER block on Fights,** after the owner's OK on the drawn page.
10. **Hosted-show invites,** after owner question 3.
11. **Golden-path test:**
    1. Fresh doors; first bout won; the boxer enters the ladder.
    2. An OUT OF REACH row shows its line.
    3. A win above with the scalp; the result line.
    4. The week review row.
    5. An ask in 2 clicks.
    6. A NOT ENOUGH IN IT turned by a show invite.
    7. Reputation 55; the pro offer.

## 8. What it does NOT do, and owner questions
**Out of scope, after the fight week is built and played (S428):**
- the national ladder, the mandatory challenger and the eliminator;
- rivals who age and move between clubs; judges with taste;
- belts, world bodies, divisions beyond the code's, TV;
- pro matchmaking changes (fans stay the pro currency, apart from the starting fans);
- sponsors and rival clubs' offers tied to reputation; clips;
- box-offs (REAL: only when a panel asks);
- reputation for BJJ (the belt is the ladder, CODE).

**Owner questions (scope, money, taste)**
1. **Words:** the boxer's is "Reputation" and the gym's becomes "Standing". Yes?
2. **The screen:** the LADDER block on Fights, under the offers, as drawn in 4.3. OK to draw it?
3. **Money:** inviting an opponent to your hosted show costs $150 travel. Yes, or free?
4. **Taste:** show reputation as a number (0–100) with the band word, or the word only with the number on hover?

**CHECK (Claude)**
1. Regional table size.
2. Whether the bout-page band leaves out the plan.
3. What the club show's ticket count reads.
4. The Pro offer's ticket line.
5. The Standing band names.
6. AskBout's callers once wired.

**CHECK (John):** England Boxing's season dates.

**CHECK (Kalli):** the owner's S475 sparring partner note, before 2.5's sparring line is final.

## 9. Self-score: DEPTH 6, GENERAL DESIGN 7, PLAY 6 (mine, not a critic's)
**To reach 10/10**
1. Run BASE0 and probes 1–10, paste the tables, and retune 1.1–1.2 until all ten pass. Every number here is an ESTIMATE until then.
2. Draw 4.3 at 1920×1080, with the row states and the card for YES, OUT OF REACH and NOT ENOUGH IN IT, and get owner questions 1–4 answered on it.
3. Read the S475 sparring note and CRITIC_ACCESS.md, then wire the sparring partner screen properly instead of the style-match stub.
4. Make defending a place matter more than reach and scalps. Candidates, held until probe 5: the promoter's debut terms by ladder place, or the regional stage's draw date.
5. Give the AI corners a visible character beyond the numbers, as a first slice of the living world. Only after the fight week ships (S428).
6. Bring sponsors (K88) and rival clubs' offers onto reputation once R58's world runs.


# CRITIC ANSWER: DESIGN_LADDER1_V1_CRITIC_JOHN_JOHN.md

# DESIGN_LADDER1_V1_CRITIC_JOHN_JOHN - John answer (seat queue SQ161)

Brief: research/DESIGN_LADDER1_V1_CRITIC_JOHN.md
Sent: 2026-11-15 06:40 | collected: 2026-11-15 07:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking LADDER1 v1's reputation maths and its gates against the critic pack first, then I'll score it. The owner's computer is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open.

**Logic check.** I recomputed the formulas, the worked tables, the gates and the strategy table. These hold up:
- The loss table (1 + 8 × chance, plus 2 if stopped) is right in every cell.
- Wins at 50% and 30% are right.
- The reach rule matches its own examples: 41 reaches 4 places up, and 60 reaches 6.
- BOOKED (14 Mar, free 28 Mar) and RESTING (2 Feb, free 30 Mar) are right.
- NOVICE / OPEN at 11 bouts matches the code's 0–10.
- Two clicks to a booked bout.
- Removing the yes-chance keeps the pack's "never a random refusal".
- The wiring table covers every menu in the pack.

Fourteen things don't hold, or aren't stated:

1. **One cell is wrong.** A split win at 75% is 5.5 × 0.45 = 2.5, which rounds to **+2**, not +3. Majority wins are in the formula, but in no table.
2. **The strategy table hides the dominant road: a safe win *above* you.**
   - Chance comes from stats, but places come from reputation, so a better-trained boxer often has 75% against boxers above it on the ladder. The table assumes safe means below.
   - The expected gain per bout for an opponent above, unanimous win, scalp once (DERIVED from 1.1–1.2):
     - 30% chance: about +1.6
     - 50% chance: about +2.9
     - 75% chance: about +4.1
     - 90% chance: about +4.6
   - **The highest chance above you always pays best,** and the long shot pays least. The table's +2.6 / +4 / +1 figures don't follow from its own formula.
3. **Reputation taxes training.** A win pays by how *unlikely* it looked. The pack says training is the main lever (5 stat points better wins 72 in 100, 10 better 95 in 100), yet the better you train, the less each win is worth: about +3 at 90%. The gym's core loop (the week and the pads) pulls against the ladder's currency.
4. **The plan argument depends on an unchecked fact.** The "long shots are the skill reward" line holds only if the bout-page band leaves out the plan (Kalli's own CHECK). The plan also lifts real odds at 75%, so it helps every road, not just long shots.
5. **The top of the ladder stalls.**
   - Rivals get reputation "by the same rule" as signed prospects, which is capped at 30, so every ladder starts with nobody above 30.
   - A boxer who passes them is 1st, with nobody above for full value or scalps. Everyone is 1–5 places below (half value) or 6+ (zero). The climb to 55 slows exactly where it should end.
   - Pass line 8 (top 5 at 45–75) can't happen without a seeding rule.
6. **Rivals never leave.** No rule says what a rival at 55 does (turn pro and leave the ladder). Without it, pass line 8's "no 3+ boxers over 55 for 8 weeks" has nothing to stop it.
7. **Two gates measure the same thing.** OUT OF REACH (places) and NOT ENOUGH IN IT (a 15-reputation gap) both say "the opponent is too far above" on a ladder sorted by reputation. The player has to learn two words for one idea.
8. **55–59 reach is inconsistent.** The band table says "6+ places up" at 55, but the rule (2 + 1 per 15) gives 5 places until 60.
9. **Defending a place is a non-choice.** Accepting a challenge from 1–5 below at 75% is worth about +0.1 (half of +5 × 0.75, against −7 × 0.25). Passing is free, so the right answer is always pass, unless the inactivity clock is close. Kalli's own 10/10 list admits this.
10. **The short-notice +2 is dead.** Asks book 2+ weeks out, and club offers come 8–12 weeks ahead (2–4 only in the first hour), so no path creates a bout under 14 days.
11. **The inactivity clock isn't defined against booked bouts.**
    - With 8–12 week offer leads, a boxer waiting on a booked bout loses reputation while doing nothing wrong.
    - The 30-day suspension pauses the clock, but the 8-week later-offer rule after a stoppage (`STOP_REST_WEEKS`) doesn't.
    - **RESTING turns an offer delay into an ask ban:** that's NEW, not CODE as marked.
12. **The starting pro fans change pros, which are out of scope.** 55 ÷ 10 = 5 fans clears `TOP_ASK_FANS 3`, so a debutant could ask for a top-5 name straight away. Today's debut fan count isn't in the pack (NOT ESTABLISHED).
13. **Floors and holes:**
    - The prospect formula can go negative (4 × net wins), and reputation has no floor at 0 after an early loss.
    - Two of your own boxers on one ladder can ask each other; there's no clubmate rule.
    - The draw formula doesn't say which win weight applies.
14. **Names and sources:**
    - A name in every ladder row reads S448 loosely. World > Rankings and News already show names in rows, so there's a precedent, but the owner has to rule on it, not the map.
    - The Pro offer modal's quoted "tickets she sells" is a fixed she (S412). That's in the code, not this map.
    - The pro-ladder probes need the bots to write plans; that isn't stated.
    - **Pass lines 1 and 2 can't both pass** if COACH sits near the median: PLAN 25% faster than COACH breaks "no bot 20% faster than the median".

I didn't reverify the BoxRec weights, the England Boxing 2.7.8 and 2.7.9 rules, or the 365-day inactive rule this pass. They stay as John's earlier report.

I score LADDER1 v1 at depth 5, general design 5 and play 6, so it doesn't meet the owner's bar yet. Two changes would carry it past 6: pay reputation by the opponent's reputation instead of the shown chance, and seed and drain the top of the ladder. I judged it from the pack and the map only. `CRITIC_ACCESS.md`, the board, the mockups and the S475 sparring note are on the owner's computer, which is offline.

## Scores

**Depth 5.** The pieces are right: who to ask, when to wait, long shots, defending, and a hosted-show invite. They touch bouts, plan, weight, the fight week, money and the pro offer.

The maths behind them flattens the choices:
- **One road wins.** Asking the highest-chance boxer above you beats every other ask.
- **Defending is always "pass".**
- **Waiting is just losing time.**
- **The stall at 1st place** removes the upset road when it matters most.

That's one real decision (find a safe boxer above) wearing four labels.

**General design 5.** Strong parts:
- the no-roll refusal table, each word with its way to YES;
- one word per idea for the boxer;
- a full wiring list;
- pure rules first, each with a test;
- 10 probes, including the R37 ask test;
- a clean replacement table for the `Roster`, `Region` and `AskBout` constants.

What holds it down:
- the currency taxes training, the game's main lever;
- the 30 cap starves the ladder top, and nothing makes rivals leave;
- two gates for one idea;
- a dead +2;
- an unscoped change to pro fans;
- two pass lines that conflict;
- names in rows that need an owner ruling.

**Play 6.**
- The 0–100 bar with "14 to go" and the 55 pin is a strong reason to come back.
- The result line ("Reputation 31 to 43 (+12: won from 30%, stoppage). Ladder 7th to 4th") makes every fight matter.
- Scalps, and the week review's "rival passed you", give stakes.

But the best road is quiet, safe wins above. A strong boxer earns little per win, and the run ends with the boxer stuck at 1st, out of anyone worth beating.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Ask for this bout | Books an opponent you choose, 2+ weeks out | Keep; the core |
| Within reach / All filter | Which rows show | Keep |
| Next date | Moves the date past a clash or a weight problem | Keep |
| Long shot | Bigger gain, smaller loss | Keep, but it only pays once rewards follow the opponent |
| Accept a challenge from below (defend) | Half value against full risk | **Useless as tuned:** about +0.1, so always pass |
| Pass a challenge | Nothing, while the clock runs | Keep |
| Bring them to your show ($150) | Buys an opponent beyond the gap | Keep; a real money-for-reputation trade |
| Headliner on your show | Tickets, +3 on a win | Keep |
| Short-notice +2 | Nothing; no path creates it | **Useless:** cut it, or add short-notice offers |
| Standing +5 in the gap check | Tiny, hidden pull | **Near useless:** show it on the row or cut it |
| Withdraw before Continue | Free undo | Keep |

**Missing options**
- **Ask for a rematch** after a loss, at half value and full loss cost. It's the most natural ask in real boxing, and the map's repeat rule already prices it.
- **The opponent's file on the card:** the World rival file's found tells, with "found at their last bout". Amateurs can't scout before accepting (S410), so the card has to show what the club already knows, or every ask is blind.
- **The coach's pick:** one row starred "your coach would ask this one", with the reason. This matches how the coach writes the week, and it gives the quiet player a one-click ask.
- **A clubmate rule:** clubmates are never offered and can't be asked. That's one line in AskAnswer.
- **Turn pro / stay amateur at 55** already exists in the code, but the map doesn't say what staying amateur does to the ladder. Offer "Stay for the nationals" with its reputation upside.

## To reach 10/10
1. **Pay reputation by opponent, not by odds** (Elo-style, as in chess ratings).
   - Expected = 1 / (1 + 10^((opponent − yours) / 25)).
   - A win gives 12 × (1 − expected) × the win-type weight, and a loss costs 12 × expected.
   - Beating someone 20 below gives about +1, and someone 20 above about +10. That replaces the whole anti-grind table, the places-below rules and the scalp.
   - Training is rewarded (a stronger boxer beats higher-rated boxers), and so is the plan (it wins bouts the ratings say you'd lose).
   - Keep the shown chance on screen for information only. Run probes 1, 2 and 9 again.
2. **Seed and drain the top.**
   - Rivals at load get a spread, with the top 5 at 40–65 (ESTIMATE, drawn from record and age).
   - A rival at 55+ gets a pro offer, and turns pro and leaves within 8 weeks, 1 in 2. A new rival enters at the bottom each quarter.
   - Then pass line 8 can pass, and 1st place still has someone to chase until the offer arrives.
3. **Merge the two gates into one, NOT ENOUGH IN IT:** an opponent more than (10 + your reputation ÷ 5) above says no. That's 10 at reputation 0 and 21 at 55, with one To-get-a-yes line. Drop reach in places.
4. **Make defending real:** a challenge from below that you pass costs half its loss value, the way a real champion vacates. Accepting pays the Elo value. Then "pass" is a price, not free.
5. **Fix the clock:** a booked bout stops it, and so do the suspension and the 8-week rest. Mark RESTING as NEW, or let asks through after the 30-day suspension.
6. **Leave pros alone:** a debut pro starts at today's fan count (CHECK Claude for the number), and reputation shows only on the Pro offer's ticket line.
7. **Small fixes:**
   - Correct the split cell to +2, and add majority wins to the tables.
   - Reputation floors at 0; the prospect formula takes the larger of 0 and its result.
   - The draw uses the unanimous weight.
   - Cut the short-notice +2.
   - Add the clubmate rule.
   - Rewrite pass lines 1 and 2 as "PLAN fastest, COACH within 10% of the best non-PLAN bot, SAFE and ASKUP 15%+ slower than COACH", and have the bots write plans.
   - Fix the existing "tickets she sells".
8. **Add the rematch ask, the coach's pick and the rival file on the card.**
9. **Ask the owner one names question with the drawn page:** "Ladder rows carry the opponent's name, as World > Rankings does today. OK?"
10. **Run BASE0 and the probes, then draw the page.** Every number above is an ESTIMATE until then.

**Real evidence:** in English amateur boxing, club matchmakers pair boxers on experience and weight at club shows; there's no public league table where you climb by challenge. So the ladder is a game layer on top of real matchmaking, which the map handles well by keeping the real floors fixed. I believe amateur bouts under IBA-style rules always have a winner (no draws). That's a CHECK, not reread this pass.

## The 10/10 page (1920×1080, Look B; FIGHTS, LADDER)

**Shell (0–64):** dark top bar; CONTINUE reads "to Sat 14 Mar, club show".

**Header (64–120):** "WOMEN'S 60 KG: LONDON REGIONAL", with your boxer's portrait and name once. Fighter tabs for each of the club's boxers, by class.

**Reputation strip (120–220):** the 0–100 bar.
- A pin at 55 reads "Pro offer", and a small arrow shows this week's move.
- The band word with the number ("Rated 41").
- One marker line: "Beat a boxer rated 50+ to pass 45".
- Hover breaks the last change into its parts.

**Season strip (220–280):** 13 weeks only, with show Saturdays, booked bouts, fight weeks, your hosted show and nationals close. "Bouts this season 7 of 18".

**Ladder (40–1260), up to 20 rows:** place and its weekly arrow, the name cell, club, record with NOVICE or OPEN, reputation, style word, last bout, the chance band.
- **Win / Loss:** "+9, to 4th / −3, stay 7th".
- **The answer word:** YES, NOT ENOUGH IN IT, BOOKED, RESTING, NOVICE/OPEN, OVER WEIGHT, SEASON FULL or OUT.
- A coach's star on one YES row, with its reason on hover. Challenges from below carry a "Challenge: pass costs 3" chip.
- Your row is highlighted.
- Rivals who'll turn pro soon show a small "Pro talk" tag, so the player sees the top drain coming.

**Card (1300–1880):**
- The opponent's name header, the tale of the tape and the chance.
- **WHAT WE KNOW:** found tells from the rival file, or "no tape yet".
- The date, with a Next date chip, and the clash line only when there is one.
- **Win gives / Loss costs,** with hover parts.
- The answer word with Why and To get a yes.
- **Buttons:**
  - one pulsing gold **Ask for this bout**, shown only on YES;
  - **Bring them to your show** on NOT ENOUGH IN IT;
  - **Ask for a rematch** on a boxer who beat yours.

**Stress state (same layout):** your boxer is 1st at 52. The top three rivals are tagged "Pro talk". The only YES rows are below, at +2 each, and the strip line reads "Nobody above: win the regional stage (+5) or wait for a new entry in April".

## Sources
No new outside sources this pass. Every figure is DERIVED from the critic pack and the map's own formulas. Elo's expected-score formula is standard rating maths. The BoxRec and England Boxing rule numbers are from John's earlier report and weren't reverified here.


# CRITIC ANSWER: DESIGN_LADDER1_V1_CRITIC_DOLA_DOLA.md

# DESIGN_LADDER1_V1_CRITIC_DOLA_DOLA - Dola answer (seat queue SQ162)

Brief: research/DESIGN_LADDER1_V1_CRITIC_DOLA.md
Sent: 2026-11-15 07:10 | collected: 2026-11-15 07:40 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.

(the brief is cut; her reply:)
.
Show More
Searched for 2 keywords · 12 sources
LADDER1 v1 — Critic Score & Review
Mechanic: Regional amateur ladder with reputation currency (S459)
Judge: Fresh critic, no prior scores
Scores
Table
Criterion	Score /10	Verdict
DEPTH	7/10	✅ Passes the design bar (6+)
GENERAL DESIGN	8/10	✅ Passes the design bar (6+)
PLAY	7/10	✅ Solid week-to-week motivation
Overall verdict: ✅ DESIGNED — meets the owner's bar (6+ on both Depth and General Design)
1. DEPTH — 7/10
Strengths
Trade-offs are real and asymmetric: Beating someone above you pays full value + scalp bonus; beating someone 6+ places below pays zero. A safe win averages ~+1 per bout; an upset win averages ~+12–15. This directly counters the "fight only easy people" trap common in boxing games.
No dominant strategy identified: The design correctly shows that fighting only safe opponents grinds too slowly (≈50 bouts to pro at 3/season cap), while chasing only long shots brings suspensions and 8-week waits. The intended middle path (even–slightly above, planned well) emerges as strongest — exactly what a sim needs.
Interlocks with existing systems: Reputation feeds into ask reach → pro offer threshold → starting pro fans → club Standing → member growth → money → show budget. It doesn't sit isolated; every major decision ripples.
Plan skill matters: The displayed win chance excludes plan quality. Writing a good plan lifts a 30% shown chance to ~45–50% actual — that's the skill lever that turns long shots from gambling into calculated gambits. Real-world boxing evidence: a game plan that neutralises an opponent's strengths consistently outperforms raw odds.
Gaps
All numbers are ESTIMATE until probes run. We don't yet know if +12 at 30% chance beats +4 at 55% over a full season — the theory is sound but unmeasured.
Inactivity penalty is soft: −1 every 4 weeks after 8 weeks out doesn't meaningfully punish sitting on a high rank. A player could reach #3, then fight only 2–3 times/season and still hold it — real amateur boxing removes inactive boxers from rankings faster than this.
No downside to fighting the same opponent twice: Halving reputation on a rematch is good, but real boxing also has "you've already had your shot" refusal logic that's missing — you can keep re-fighting the same rival forever, just for less reward.
2. GENERAL DESIGN — 8/10
Strengths
Clear language, one word per concept: Reputation (boxer) vs Standing (gym) solves the double meaning cleanly; YES / BOOKED / NOT ENOUGH IN IT etc. use plain, consistent labels. No flavour text, no jargon — matches the game's established tone.
Predictable, never random: Every ask returns a clear answer with a clear path to YES before you click. No hidden dice, no "sorry, random refusal". This is the single strongest design choice in the pack.
Built on existing screens, not a separate world: The ladder lives under Fights → OFFERS ON THE TABLE, not a distant menu. Results feed into the existing result screen, week review, History tab, fighter Overview — minimal new UI, maximum reuse.
Respect for real boxing rules: Novice/open separation, 18-bout season limit, weight class enforcement, inactivity expiry at 52 weeks — all align with England Boxing and BoxRec standards.
Names handled correctly per S448: Opponent names appear only in their row header; buttons and messages say "the opponent". No stray names found.
Gaps
Owner questions unresolved: The screen layout itself is a placeholder waiting for the owner's drawn mockup and three open questions (Standing wording, $150 invite cost, number vs word display). Until those land, the visual design is incomplete.
Some gates lack feedback: "NOT ENOUGH IN IT" tells you the gap, but doesn't show how much — is it 1 point away or 15? A small detail but one that removes guesswork.
No confirmation on regional table size: 20 rows assumed but unconfirmed — critical for understanding how far "6+ places below" actually stretches in a full ladder.
3. PLAY — 7/10
Strengths
Every fight shows the stakes before you commit: "Win +9 to 4th · Loss −4 stay 7th" appears on the offer card, versus screen, and bout page. Players know exactly what's on the line — no surprises after the bell.
Anticipation builds naturally: Reputation bands (Unknown → Known → Rated → Contender → Pro-ready) give visible, incremental milestones. The "12 to go" counter on the fighter page keeps the next target always in sight.
The comeback incentive is strong: A loss doesn't wreck your career — you can recover, but it stings enough that you care. Losing as favourite hurts more than losing as the underdog, which feels exactly right.
The season structure creates pacing: 18 bouts/season means every booking feels finite and meaningful. You can't fight every week forever — you must pick carefully.
Gaps
No mid-season rewards: You climb, you hit gates, you wait for 55. Reaching 30 or 40 doesn't unlock anything exciting yet — no new venues, no regional rankings recognition, no headline opportunities. The journey needs more checkpoints.
No personality in rivals yet: They're rows with numbers, not people. Boxing history is built on rivalries — beating the #1 contender feels different if there's a story attached.
Passive offers still arrive: You can ignore the ladder entirely and just take what shows up. That's fine as an option, but the ladder shouldn't feel optional — it should feel like the main way you shape your own path.
Missing options, useless options, and what each changes
❌ Missing options
Retire from the ladder / drop a class — A boxer stuck at 62 kg in a 60 kg class can't step down or pause their run. Real amateur boxing lets boxers move up in weight or take breaks.
Request a rematch after a loss — You beat someone, then they won't give you a return bout. You lost? You can't ask for redemption. That's a major tension point missing.
Filter ladder by style/stance — Finding a southpaw to spar or prepare against means scanning every row manually.
See your upcoming 4 weeks at a glance on the ladder — The season strip exists but doesn't show who else is fighting on those dates — you only find out when a conflict appears.
Set a "target opponent" — The fighter page says "12 to go" but not "Next: beat #8 to reach Contender band". A single pinned target would anchor the next 2–3 bouts.
⚠️ Useless options (or cut correctly)
Table
Cut	Reason	Correct call?
Top of bill at reputation 40	Player can't act on other clubs' shows	✅ Yes — v2 material
Sponsors at 30/50/70	Follows gym Standing instead	✅ Yes — cleaner separation
Rival club offers at 35	R58 world not built yet	✅ Yes — scope limited correctly
None of these should have been in v1 anyway — the cuts are sound design decisions.
✅ What each option changes
Table
Decision	What it actually changes
Ask someone above	Highest reputation gain + scalp bonus; highest loss cost + suspension risk
Ask someone even	Steady, reliable progress; lowest risk per bout
Ask someone below	Half or zero reputation; safe but slow
Accept an offer from below	Immediate bout but poor value; resets your momentum
Wait 8+ weeks	Inactivity penalty kicks in; rivals climb past you
Bring opponent to your show	Bypasses "NOT ENOUGH IN IT" gate; costs $150 + show risk
Fight a long shot with a written plan	Turns 30% chance into ~45–50% actual; reputation gain stays the same but win rate rises
To reach 10/10: concrete changes, most important first
🥇 Priority 1 — Confirm and calibrate the numbers (do FIRST)
Run BASE0 and probes 1–10. Every reputation number is currently an estimate. The median weeks to pro offer, the safe-win grind rate, and the plan-skill lift all need real data from 40+ seeded runs. Tune the win/loss formulas until:
No bot reaches pro >20% faster than median
PLAN beats COACH by 10–25% (skill reward confirmed)
SAFE takes ≥50 bouts to reach 55 (grind shut)
Then freeze all numbers — they don't get touched again
Answer the 4 owner questions:
✅ "Reputation" vs "Standing" wording — yes/no
✅ Approve the ladder page layout at 1920×1080 — yes/no
✅ $150 travel cost for show invites — yes/no
✅ Show number always, or on hover — yes/no
Nothing else proceeds until these land — the design is blocked on them.
🥈 Priority 2 — Depth and choice
Strengthen inactivity penalty: After 8 weeks out, −1 every 2 weeks (not 4). After 16 weeks out, drop 1 place per month. Real amateur rankings purge inactive boxers quickly — sitting still should hurt.
Show the gap clearly: Change "Yes at reputation 47" → "Need +6 reputation (2 more wins above you)" — tell the player exactly what's missing, not just the number.
Add one mid-tier unlock per reputation band:
30 (Rated): "You can now enter regional rankings tournaments"
45 (Contender): "Regional title eliminators become available"
Small, permanent, tangible things to do before 55. Progress needs intermediate rewards.
Defending your place matters more: When someone within 3 places below you challenges and wins, they swap places with you. When you win, you earn a small "defence bonus" (+2 reputation) — holding your ground should feel as meaningful as moving up.
🥉 Priority 3 — Polish and personality
Read and integrate the S475 sparring partner note. Right now it's a style-match stub — wire it properly so that preparing for a specific opponent on the ladder actually changes your camp choices and fight-week effectiveness. The ladder shouldn't exist separately from training; it should drive training decisions.
Give rivals 1-sentence personality tags on the ladder row: "Hard puncher, slow starter" / "Always pressuring" / "Difficult to draw out". Not a full story — just enough that choosing to fight them feels like picking a specific problem to solve, not just a number. The opponent file already has this data — surface it earlier.
Add one optional "decline reason" when you pass on an ask: "Resting this month", "Fighting elsewhere", "Too risky". The AI remembers — refuse twice and they won't ask back for 8 weeks. Small social texture that makes the ladder feel alive.
10/10 Vision — 1920×1080 Screen Description
(Ready for HTML implementation once owner questions are answered)
plaintext
┌─────────────────────────────────────────────────────────────────────────────┐
│  HEADER: WOMEN'S 60 KG — LONDON REGIONAL LADDER                              │
│  Your boxer: ●●●●●●●○○○  43 / 55  Contender  ·  5 places up  ·  10 to pro   │
│  "Win once above you → reach 5 places up"                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  SEASON CALENDAR  ──  7 of 18 bouts used this season  ──  Season ends 4 Jan │
│  □ Jan □ Feb □ Mar □ Apr □ May □ Jun □ Jul □ Aug □ Sep □ Oct □ Nov □ Dec    │
│  ● = Club show  ★ = Your bout  ░ = Resting  ▼ = Nationals entry closes      │
├──────────────────────────────────────┬──────────────────────────────────────┤
│  ↹ Within reach  ▤ All               │  ╔═════════════════════════════════╗ │
│                                       │  ║  OPPONENT DETAILS               ║ │
│  #  Name          Club    Rec  Reput  │  ║                                ║ │
│  1  [Name]        ABC     8-0   72 ●  │  ║  Tale of the tape               ║ │
│  2  [Name]        West    7-1   67 ●  │  ║  Style · Record · Reach        ║ │
│  3  [Name]        East    6-2   59 ●  │  ║  Win chance: 35% (Unscouted)   ║ │
│  4  ►Your Boxer◄  Gym     5-1   43 ◄─▶│  ║                                ║ │
│  5  [Name]        South   5-2   41    │  ║  Win: +12 (+3 scalp) → #3      ║ │
│  6  [Name]        North   4-2   38    │  ║  Loss: −5 → stays #4            ║ │
│  7  [Name]        Park    4-3   34    │  ║                                ║ │
│  8  [Name]        Lake    3-3   31    │  ║  ✅ YES — Takes the bout       ║ │
│  ...                                  │  ║  Earliest: Sat 28 Mar           ║ │
│                                       │  ║  ════════════════════════════  ║ │
│  ↑↓ = Movement since last week        │  ║   [ ASK FOR THIS BOUT ]        ║ │
└──────────────────────────────────────┴──────────────────────────────────────┘

Design principles for the final HTML:
Look B — warm gym whiteboard style: cream background, marker text, photo polaroids for boxers, sticky-note feel for the answer card
Two-click flow always: click row → click ASK. No extra steps
Hover explains every number: +12 on hover shows: "Base +9 · Scalp bonus +3 · Stoppage bonus +0"
Status colours only, no red alerts: YES = dark marker, BOOKED = greyed text, NOT ENOUGH IN IT = amber, OVER WEIGHT = orange
Mobile-friendly layout: stack card below ladder on narrow screens
This mechanic is solid — it just needs the numbers proven and the visual design signed off before it's truly complete.
Would you like me to convert this review into a standalone HTML file with the 10/10 mockup design included? Just say the word.
Chat
Create Videos
Create Images
Writing
Homework
Translate
