# CLUBWEEK1_V10 - write the NEXT version of this mechanic's design map (S459 design loop)

You are the designer. Read the whole game (critic pack below), the current map, and the critics' answers at the end. Write
the next version of the map in full (not a diff): answer EVERY point of each critic's 'To reach 10/10' list (do it, or say
in one line why not), keep every rule the owner agreed (quoted in the map), keep it buildable from what the game has, and
keep the map's table of every menu the mechanic appears on and what each is wired to (owner S425).
The bar it must reach with fresh critics: 7+ DEPTH and 7+ GENERAL DESIGN (owner S425). Numbers: say which are ESTIMATES.
Plain words; names only in headers. Return only the new map, starting with its title line.

> Also read `ops/research/CRITIC_ACCESS.md`: the map, the real screens, the mockups.


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

# CLUBWEEK1_V10 — the club week, with the fight weeks inside it (S459, S514, 2026-11-18)
This version: answers all v9 critic points + MORNINGSPROBE1 results; replaces v9; only this document stands.
Scores targeted: DEPTH ≥7, GENERAL DESIGN ≥7. Numbers marked ESTIMATE where not yet measured in code/probe.
Owner rules kept verbatim:
"Just rename it 'gym sponsorship', the club pays." Never mixed with Sponsor deals on Club > Money.
"Names only on the header" — no names in buttons/rows/tooltips.
"The player runs any gym with any boxers." No fixed pronouns.
Every menu the mechanic appears on, and what each is wired to.
"Only actionable information." Plain words; one word per concept.
"Deeper, not wider." A quiet week = one click.
Weight classes unchanged; females never spar males.
"Gym" = facility; "camp" = pro pre-bout preparation; amateur pre-bout = fight week.
1. Idea in five lines
The Club week is Monday's deal of scarce coach time: pad turns, film sessions, coached mornings, gym sponsorship, and one conversation per week.
Sell pad hours as classes — full or short — that's your main lever for extra cash. Bag nights are the cost: half mastery that evening.
Fight weeks come first: every one needs all 3 pad turns. A class on a fight week = someone goes short OR pays extra cover. The collision line shows this before you accept a bout.
Coached mornings rebalanced: shared mornings now train a shared weak spot so they compete fairly with solo mornings — the probe showed raw multipliers alone wouldn't work.
Loyalty drifts toward 60 — only shortages, broken promises and sponsorship decisions move it meaningfully. A quiet week = one click, nothing changes.
2. When it appears
1 fighter only: Week tab works exactly as built today — nothing changes.
Second fighter signs: new Club Week tab appears under Fighters. Home shows a note: "Two fighters now share coach time → Open Club week". Guide strip updates once.
Quiet week: no shortages, no twists, no fight weeks, no sponsorship changes → page shows counters + rows + "Coach deals it — same as last week" → one click Continue.
3. Full mechanic design
3.1 Pad turns — the core unit
Definitions (one word per concept):
Pad turn: ~20 minutes of coach time drilling moves/combinations. 3 turns = 1 full pad hour. CODE: 1 turn ≈ 80 drill units; full hour = 240 units.
Pad night: 3 turns at full pads rate (2.1 mastery/hr — CODE).
Bag night: same cards run without coach supervision — 1.05 mastery/hr (CODE).
Film session: coach evening reviewing tape/planning — separate counter, never a pad turn.
Coach capacity — CHECK 1 (ESTIMATE until confirmed in code):
Table
Coach	Pad hours/week	Nights	Total turns	Film sessions/week	Coached mornings
Sessional (Luke)	2	Tue, Thu	6	2	2
Full-time (Marcus)	3	Mon, Tue, Thu	9	3	3
You (head coach)	1	Wed	3	2	4
Sessional total	3	—	9	4	6
Full-time total	4	—	12	12	7
Per-night rule:
3 turns per pad hour; 1 boxer per turn; max 1 turn per boxer per night.
Full class = 3 turns sold → that night runs as bag night for everyone affected.
Short class = 2 turns sold → 1 turn remains; row order decides who keeps it.
No pad hours on Friday in weigh-in weeks — weigh-in is Friday, fight Saturday (CODE).
Need/Want per week type:
Table
Week type	Want	Need	Notes
Ordinary	3	2	Standard 3 pad nights (CODE)
PEAK (pro 2+ weeks out)	3	2	2 sparring nights — no turns taken
Fight week (Taper)	3	3	All 3 turns required; film session included
Status words (colour reinforces, never alone):
OK — spare turns available
FULL — all needs met
BAG n — n evenings running at bag rate
SHORT n — n turns below Need; shown as "SHORT 1 · BAG 2"
Capacity table (sessional coach — 9 turns):
Table
Situation	Asked/Need	Result	Film used
Ordinary week, 3 boxers	9/6	FULL	—
1 fight week	9/7	FULL	1 of 4
2 fight weeks	9/8	FULL	2 of 4
Full class (Thu)	6/6	BAG 3	—
Short class (Thu)	7/6	BAG 2	—
Full class + 1 fight week	6/7	SHORT 1 · BAG 3	1 of 4
Short class + 1 fight week	7/7	BAG 2	1 of 4
4 boxers, ordinary	9/8	BAG 1	—
4 boxers + 2 fight weeks	9/10	SHORT 1 · BAG 3	2 of 4
Full-time coach (12 turns): full class + 1 fight week = FULL; 4 boxers ordinary = FULL. All ESTIMATE until CHECK 1 confirms capacity numbers.
Coach's deal order: fight-week boxers first, then row order (drag to reorder, persists week-to-week). Plain editing: drag turns between rows on the same night; drag entire hours to free nights. Lock removed — row order protects priority fairly.
3.2 Classes — the money lever
Pricing — all ESTIMATE until MONEYFOUR2 runs:
Table
Option	What it costs	What you gain	When available
Full class	3 turns → bag night for that group	+$117; member target +4 (capped by premises; CODE max +6/wk)	Any free pad hour
Short class	2 turns → 1 turn remains	+$78; member target +2	Any free pad hour
Cover coach	$130 one-off; 3 turns at full pads rate	Fixes SHORT immediately	Only when SHORT — never otherwise
Pads volunteer (Mon)	$120/wk ongoing; 3 turns at 0.8× mastery rate	Extra capacity every week	Club > People → Staff jobs
Volunteer on call	$50/week, fight weeks only; 3 turns at 0.8× mastery rate	Extra capacity only when needed	Club > People → Staff jobs
Economy — DERIVED:
Full class weekly (sessional, 3 boxers): +$6,100/yr fees + ~$1,700/yr dues from extra members; ~$2,100/yr spent on cover across ~16 SHORT weeks/yr. Net positive — but ~30% of weeks run BAG nights unless you manage around them.
MONEYFOUR2 pass condition: class revenue > cost of cover + mastery loss. If always profitable → price drops to $90/short or member gain reduced to +2.
3.3 Coached mornings — rebalanced from MORNINGSPROBE1
What the probe found: raw multipliers don't make shared mornings viable — solo always wins because it targets the weakest stat where headroom bonus is highest. Design fix: shared mornings now train the pair's shared weak spot — the lowest common ability both boxers need work on. This makes them a genuine choice, not just "worse solo".
MORNINGSPROBE1 results summary:
Solo mornings delivered +8–9% total points and +75% more points on weak abilities than shared at original multipliers
Boosting shared to ×1.35 barely changed win rates — targeting, not rate, is the lever
New design: change what gets trained, not just the number
Revised system — NEW:
Table
Morning type	Multiplier	What it trains	When best choice
Uncoached	×1.0 (CODE)	Coach's default session plan	Rest/light weeks
Solo	×1.25	That fighter's lowest ability	Focus on a specific gap; fight-week prep
Shared — revised	×1.15 each	The lowest ability BOTH share and need — shown in the pairing card	Two boxers lag in the same area; you want total gains over focused gains
Solo on Weak Spot	×1.40	The ability the opponent will target (WEAK SPOT pull)	3+ points behind opponent at that stat; camp prep
Pads in morning	×0.8 pads rate	One move/combo on the pad card; consumes the morning	Heavy technical work; sparring injuries limit evening sessions
UI change: pairing two boxers on a morning shows a card: "Shared focus: Conditioning — both 52/70" — so the player sees exactly what they're getting. No longer a blind choice.
CHECK 7 (COACHFIT1): verify total coached mornings = 6 sessional / 7 full-time; confirm shared targeting logic doesn't over-allocate.
3.4 Fight week structure
When: Taper week — 7 days pre-bout, amateur or pro (CODE WeekPhase.phase).
Structure: 3 one-to-one pad sessions + 1 film session — no turns consumed by film.
Table
Load switch	Turns used	Film	Sparring	Use case
Tick over (default)	3	1 session	None	Standard fight prep
Rest up	2	1 session	None	Tired fighter; coming off injury; short notice bout
Train through	3	1 session	1 sparring night (no turns)	2+ weeks between bouts; opponent styles unfamiliar
Film sessions:
Coached film → opens 1 opponent tell/weakness per session (CODE scouting progress)
Unassisted film (over limit) → "Watching tape alone — no new insight"
You: 2 coached sessions/wk; full-time coach: +1 extra
3.5 Gym sponsorship & day job
Gym sponsorship = fighter stipend — one record, two labels (CHECK 3 confirmed):
$250/wk; billed/show in 4-week blocks of $1,000; Club > Money shows both labels clearly
Amateurs/BJJ only — stops automatically at pro debut (CODE)
Day job — NEW defaults from DAYJOB1 table:
No sponsorship → 1 lost morning/week (Tuesday = WORK) — default
Player option (owner question 3): choose 0 / 1 / 2 lost mornings
0: full sponsorship required
1: default — no compensation needed
2: half-sponsorship option available ($125/wk) — recovers 1 morning
BJJ athlete without sponsorship → misses 1 mat class every 3 sessions
Cost estimate: ~−0.2 stat pts/week on that morning's focus → ~−2 pts over 10 weeks — ESTIMATE, DAYJOB1 will measure exact impact
Sponsorship decisions:
Table
Action	Impact
Give to eligible fighter	+5 loyalty; WORK clears immediately
Renew	−$1,000 block cost; +2 loyalty; no gap in WORK status
Pass to another	Receiver +5; giver −3 loyalty
Let end	0 loyalty; WORK returns next Monday
Stop mid-block	−8 loyalty; repay remaining pro-rated portion
3.6 Loyalty — drift model
What it is: the existing Loyalty trait from code — learned behaviour, not a displayed number by default.
Display choice (owner question 5): bar (0–100) OR band words only. Default = bands only.
Table
Band	Range	Behaviour
Loyal	70+	Drifts down toward 60; 1 short week/4 waived
Settled	50–69	Drifts toward 60 normally
Wavering	25–49	Drifts down −1/week; short weeks hurt more
Leaving	<25	−4 morale/week (directly impacts corner trust: 0.7× effectiveness)
Movement — all ESTIMATE until LOYAL1 runs:
Table
Cause	Loyalty change
All needs met, quiet week	Drift +1 → 60 if below; −1 → 60 if above
Short 1 week	−5; −8 if consecutive
Hold pads (Loyal 70+)	+3/week; max 4 weeks continuous; holder runs bag nights at 0.85 mastery
Promise kept / broken	+5 / −12
Sponsorship given / stopped	+5 / −8
Team-mate released	−5 each remaining fighter
Rest week	+4 morale; loyalty unchanged
Under 25 / leaving state (owner question 4):
Option A (strict): after 2 "Wants a word" conversations with no improvement → fighter gives notice; leaves next Monday; turning pro under 50 → club's purse share drops from 25% to 10% (15% manager fee)
Option B (softer): no departure; only −4 morale/week at <25 loyalty
Owner decides — map supports either path
The conversation — one/week max, per fighter ≤1/4 weeks:
Prioritise next week — guaranteed turn slot next week; +4 loyalty; names who loses a turn
Make a dated promise — must be an open goal/training request/bout date; tracks in PROMISES OPEN; +5 kept / −12 broken
Tell it straight — no cost; coach's assessment shown as odds ("listens: usually" = ~70%)
3.7 Collision line & later dates
Above Accept on bout page: only appears when booking creates a conflict.
Table
Message	Options
"Fight week + class week → SHORT 1. BAG nights lose mastery."	Short class (+$78), cover ($130), Rest up, Later date
"3 fight weeks → FILM 3 of 4. One boxer watches alone."	Reorder schedule, Later date, Accept with risk
Later date button — rule-based, never random:
Opens = next available show date where opponent is also free, weight can be made, season has space
Greyed = reason shown clearly ("Opponent booked", "No shows scheduled in next 4 weeks")
No arbitrary expiry — decision stays open until you choose or the window passes naturally
3.8 Twist cards — revised from v9
Retains code's 16-card deck; 7 evening-impacting cards get 2 priced choices.
Table
Twist	Trigger	Option 1	Option 2
Heating down	Any week	Repair −$120	Run cold → 1 pad hour lost; auto-cover if SHORT results
Needs rest	Any week	Rest week: +4 morale, freed turns	Refuse: −4 morale
Partner sick	Sparring night planned	Pads instead: needs free turn → BAG night if none	Hire replacement: $160 (CODE camp rate)
Southpaw opponent booked	First southpaw matchup	Spar southpaw: $80; round-1 penalty removed	Pass: keep penalty
Former coach visits	Fight Saturday only	Guest pad session: +3 mastery that night	Guest corner: +3 morale
Photo request	Any week	Do shoot: +$150; lowest row loses 1 turn	Decline
Visiting pro	Any week	Spar session: 1 habit unlocked in coach's notes	Gym rental: +$60
4. Every menu — wired reference table (S425 requirement)
Table
Menu	Displays	Wired to
Guide strip	"Share coach time with your second fighter"	GuideLight, Roster.sign_fighter
Fighters > Club Week (NEW tab, 2+ fighters only; owner OK required)	Status row: Asked/Need/Film/Cover; NEXT WEEK collision warning; week grid (nights × turns; PADS/BAG/CLASS); fighter rows (header name only, morale, loyalty band, WORK flag, pulls, load switch); PROMISES OPEN; twist card; Coach's deal / Reset / Start week	ClubDeal, PadWeek, DuesLevers, WeekPhase, WeakSpot, Loyalty, WeekTwist, GymSpend, DayJob
Fighter > Week	Own cells unchanged; shared nights show "Arranged on Club Week"; WORK/Turn markers	WeekBoard, ClubDeal, DayJob
Fighter > Overview	Weak spot; loyalty band/bar with 4-week log; "Wants a word" when due; Release in row menu	FighterPage, AttrBoard, Loyalty, WeakSpot
Fighter > Fight Prep	3 pad sessions + film; load switch; collision line above Accept	FightPrep, FightWeek, ClubDeal.forecast
BJJ/Martial Artist page	Sponsorship status; WORK/missed class marker; rest unchanged	GrapplerPage, NoGi, DayJob, StripeCall
Home	Needs row: Wants a word, sponsorship expiring, NEXT WEEK preview; "Open Club week" note appears at 2 fighters	Home, Needs, ClubDeal
Fighters > Roster cards	Loyalty band, WORK/sponsorship, priority flags	RosterCards, FighterCard
Fights > Bout page / Versus screen	Collision line; Later date button open/greyed with reason	BoutPage, ClubDeal.forecast, Ladder1.availability
Club > People	Coach pad hours	


# CRITIC ANSWER: DESIGN_CLUBWEEK1_V10_CRITIC_DOLA_DOLA.md

# DESIGN_CLUBWEEK1_V10_CRITIC_DOLA_DOLA - Dola answer (seat queue SQ218)

Brief: research/DESIGN_CLUBWEEK1_V10_CRITIC_DOLA.md
Sent: 2026-11-18 11:10 | collected: 2026-11-18 11:40 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.

(the brief is cut; her reply:)

Show More
Today 11:10
CLUBWEEK1_V10 — Mechanic Scorecard
Scoring (each /10)
1. DEPTH — 7/10
Verdict: Meets the 7+ bar
✅ Real trade-offs: extra cash from classes directly costs training quality or requires expensive cover; fight weeks compete for limited coach time; sponsorship buys mornings but costs money and loyalty if pulled; shared vs solo mornings is a genuine choice now (targeting the common weak spot fixes the earlier "solo always wins" problem found in MORNINGSPROBE1)
✅ No dominant pick: full classes give best revenue but hurt mastery; short classes balance money and training; cover fixes shortages but eats profits; rest-up protects the fighter but slows prep
✅ Interconnects deeply: feeds into training gains, mastery progression, fight prep quality, member growth, cashflow, morale, loyalty, and fight-week availability
⚠️ Gaps: loyalty impacts are still ESTIMATE — we don't yet know if −5/−8 per shortage is sharp enough; the "leaving state" severity (Option A vs B) is undecided; no long-term measurement of how chronic bag nights erodes fighter development over a full career
2. GENERAL DESIGN — 8/10
Verdict: Exceeds the 7+ bar
✅ Clear, consistent vocabulary: pad turn, pad night, bag night, film session, FULL/BAG/SHORT, fight week, collision line — one term per concept, no jargon
✅ Builds cleanly on existing systems: uses the pad/mastery numbers already in code; week phases, morale, and money all extend what exists rather than replacing it
✅ Only appears when needed: hidden entirely with 1 fighter; the Club Week tab activates only when a second signs; quiet weeks collapse to one click
✅ Collision line puts the conflict before the player commits — exactly the right place
✅ Names only in headers — no names in buttons/rows; plain action language throughout
⚠️ Gaps: capacity numbers remain ESTIMATE until CHECK 1 confirms them; the full/short class pricing needs MONEYFOUR2 validation; "Coach's deal order" is clear but row drag-and-drop needs one visual cue showing who loses when you reorder
3. PLAY — 8/10
Verdict: Strong week-to-week loop
✅ Anticipation: you see the coming week's bottleneck on Monday — and the collision line warns you before accepting a bout that it'll pinch next week
✅ Quiet week = one click — excellent pacing, no busywork
✅ Reason to plan ahead: booking two bouts on the same week is a real choice with a real cost, not just "you can't"
✅ Small, tangible rewards: extra cash → better facilities/staff; consistent full pad access → mastery climbs faster; keeping everyone fully staffed → loyalty holds steady
⚠️ Gap: loyalty drift toward 60 is subtle — the player needs to feel when their decisions are actually moving the needle; bands-only may hide whether you're 2 points or 20 points from a shift
What each option changes + Missing / Useless
📊 What each option does
Table
Option	What it costs	What it gains	When it matters most
Full class	3 turns → bag night (~half mastery that night)	+$117; members +4	Need quick cash / member growth; no fight weeks that week
Short class	1 turn remains; 1 fighter goes short	+$78; members +2	Mild shortage; fight week coming but not urgent
Cover coach	−$130 one-off	3 full pad turns that week; no mastery loss	Fight week — never let a fight week go short
Pads volunteer	−$120/wk ongoing	+3 turns every week	3+ fighters steady; consistent capacity gap
Volunteer on call	−$50/wk	+3 turns only fight weeks	2 fighters; fight weeks predictable but sparse
Solo morning	Higher mastery on 1 stat	×1.25; targets that fighter's lowest stat	Fix a specific weakness; fight-week fine-tuning
Shared morning	Slightly lower per-fighter gain	×1.15 each; trains one common weak spot	Both lag in same area; efficiency over focus
Weak-spot solo	Highest single-stat gain	×1.40; targets opponent's known strength gap	Behind at a key stat; final camp days
Rest up (fight week)	−1 turn; slower mastery	+4 morale; fresher on fight night	Tired / coming off injury / short notice
Train through (fight week)	No extra turns used	+1 spar session; style matchup prep	Well-rested; unfamiliar opponent style
Give sponsorship	−$250/wk cash	WORK clears; +5 loyalty; no lost mornings	Key fighter; amateur career phase
Let sponsorship end	0 direct cost	+1 lost morning/week by default; loyalty drifts down	Financially tight; pro transition coming soon
❌ Missing options
Reorder film sessions manually — film slots auto-assign but you can't shift which boxer gets coached film first when capacity is tight
Partial sponsorship — today it's all-or-nothing; half-support ($125/wk, 0.5 lost morning) exists but only as a day-job bridge, not a standing choice
Lock a fighter's priority beyond row order — "this fighter never goes short" with a visible permanent cost to everyone else
Weekly forecast — show next 4 weeks of capacity/bouts so you don't get hit with 3 fight weeks all landing together unexpectedly
Rotate who takes the bag night — today it's bottom of the list; let the player rotate it fairly so no single fighter always takes the hit
⚠️ Useless options (or currently weak)
Unassisted film — "watch alone, no insight" is technically correct but feels like wasted time; either remove it entirely or give it something (slower, partial insight) so it's never a pure dead end
2-morning day job — niche enough it's rarely picked; simplify to 0/1 and keep 2 only as a rare event, not a weekly toggle
Rest week twist — excellent option but buried; make it a direct toggle on the Club Week page, not just a twist card
To reach 10/10 — ordered by priority
Each change is specific enough to build. Where it needs new code, it says so clearly.
#1 — Locked priority + fair rotation (MOST IMPORTANT)
Now: Row order decides who loses turns. The bottom fighter always takes the hit. No exceptions.
Change:
Add a ⭐ toggle per fighter row: "Never short" — guarantees that fighter's full pad needs every week
Cost: the toggle shows exactly who will lose turns instead, before you confirm
Add a second toggle: "Rotate who goes short" — cycles the penalty row by row each week so no one absorbs all the downtime
Why it matters: removes the "punish your worst fighter" trap that otherwise dominates every decision
#2 — Show the 4-week capacity forecast
Now: You see this week's conflict. Next week's only appears when you land on it. Booking 3 bouts that all peak together hits you by surprise.
Change:
On the Club Week page, above the grid: a simple row of 4 mini-blocks showing each coming week — number of fight weeks, total pad need vs capacity, any SHORT/BAG risk
Click a block to jump to that week's preview
Collision line on bout offers also shows: "This bout lands Week 14 — that week already has 2 fight weeks. Need +2 turns available then"
Why it matters: decisions happen when you book, not when you're already committed
#3 — Loyalty: show the bands + 4-week trend line
Now: Bands-only is clean but opaque. Players can't tell if they're stable or sliding toward a state shift.
Change:
Default: band words only (Loyal/Settled/Wavering/Leaving) — keep this
Hover/click: show a tiny 4-week mini-chart: up/down arrows + the band boundary lines so players see which way it's trending
On the "Wants a word" conversation card: "Short weeks this month: 3 — that's why this is dropping" — name the cause directly
Why it matters: loyalty only works if players understand why it's moving
#4 — Validate all estimated numbers → lock the table
Now: Capacity, pricing, loyalty deltas, and day-job losses are all ESTIMATE. Until these land in MONEYFOUR2, CHECK1, and LOYAL1, the mechanic is balanced on paper only.
Change (dev task):
Run CHECK1 → lock pad-turns-per-night table
Run MONEYFOUR2 → set final full/short class prices and member-gain values
Run LOYAL1 → confirm −5/−8 per short week and drift speeds; decide Option A vs B for the leaving state
Mark every ESTIMATE line → replace with confirmed number or "in test" label visible only to devs
#5 — Turn "unassisted film" into something, not nothing
Now: Extra film beyond coach capacity = "no insight gained". Pure cost, zero value. Players never choose it.
Change:
Unassisted film → opens 1 tell but takes 2 weeks instead of 1 — progress bar: "Studying: 50% — will open next Monday"
Or: unassisted film = opponent style matchup accuracy improves slightly (+2–3% win chance estimate) but no specific weakness revealed
Why: every option should return some value; never a complete dead end
#6 — Reorder film slots manually
Now: Coach film auto-assigns — fight-week boxers first, then row order. You can't shift it around.
Change:
On the Club Week grid, film slots have a small swap button ↔ between rows
Click to swap which boxer gets coached film that week — cost: the other boxer now watches alone
Why: one bout has a dangerous unknown weapon — being able to redirect that one session is a high-stakes, meaningful choice
10/10 Design — Club Week Screen Spec (1920×1080)
Plain text layout — this is exactly what the HTML/page would render. Warm gym whiteboard style. Dark top bar consistent with the shell. Names appear only in row headers. No flavour text.
plaintext
┌──────────────────────────────────────────────────────────────────────┐
│  CLUB WEEK — Week 14 · 2 fighters · Sessional Coach (9 turns total)    │
│  NEXT 4 WEEKS: [This] [Wk15: 2 bouts ⚠️ SHORT risk] [Wk16: clear] [Wk17: 1 bout]
├──────────────────────────────────────────────────────────────────────┤
│  CAPACITY: Need 7 / 9 turns available · Film: 2 of 4 used              │
│  STATUS: SHORT 1 · BAG 2 · Film 1 coached, 1 alone                    │
│  COLLISION: 1 fight week + Full Class → Thu runs bag night            │
│  ⚠️ "This bout lands Week 15 — already 2 fight weeks then. +2 turns needed."
├──────────────────────────────────────────────────────────────────────┤
│  MON          TUE          WED          THU          FRI (weigh-in)   │
│  3 turns      3 turns      3 turns      3 turns      0 turns          │
│  PADS         PADS         PADS         FULL CLASS    —                │
│               Fight wk →   Fight wk →   → BAG x3     FIGHT DAY        │
├──────────────────────────────────────────────────────────────────────┤
│  │  FIGHTER ROW HEADER                          │  Mon   Tue   Wed   Thu   Fri │  Priority │ WORK │ Loyalty   │
│  ├─────────────────────────────────────────────┼───────┼───────┼───────┼───────┼───────────┼──────┼───────────┤
│  │  [Portrait] · Fight Sat · NEED 3 turns       │   PADS  │   —   │  PADS  │  BAG   │   FIGHT   │ ⭐Lock │ —    │ Loyal ↑65 │
│  │  Weak spot: Conditioning · Rest up ☑         │ Solo C │       │ Solo C│ Bag C  │           │      │      │ 4wk → →   │
│  ├─────────────────────────────────────────────┼───────┼───────┼───────┼───────┼───────────┼──────┼───────────┤
│  │  [Portrait] · Amateur · NEED 2 turns         │   —    │  PADS  │  PADS  │  BAG   │   REST    │ Rotate│ WORK │ Settled ↓ │
│  │  Shared focus: Conditioning (both 52/70)     │ Shared │ Solo S│ Shared│ Bag S  │           │      │      │ 4wk ↓ ↘   │
│  ├─────────────────────────────────────────────┼──────────────────────────────┼───────────┼──────┼───────────┤
│  │  FILM SESSIONS: Coach 2/week · Swap ↔        │  Coached → Fighter A        │ Unassisted → Fighter B (progress 50%) │
│  │  "Watching alone — will open next week"      │                              │                                       │
├──────────────────────────────────────────────────────────────────────┤
│  CLASSES & COVER  │  Full Class +$117 · Thu → BAG 3   │  Short Class +$78 · 1 turn kept │  Cover Coach $130 → fix SHORT 1 │
│  SPONSORSHIPS     │  Active: 2 × $250/wk              │  Next renewal: Week 16       │  End one → 1 lost morning/week  │
│  DAY JOB          │  0 mornings lost (full support)  │  1 lost morning (default)     │  2 lost mornings (−$125/wk)     │
│  TWIST CARD       │  Heating down: Repair −$120      │  Run cold → lose 1 turn + auto-cover if SHORT                  │
│  CONVERSATION     │  ⚠️ "Wants a word — 3 short weeks this month"  │  Prioritise next week │ Promise bout date │ Tell it straight │
├──────────────────────────────────────────────────────────────────────┤
│  COACH'S DEAL  │  Reset to coach's order  │  ↻ Rotate who goes short  │  START WEEK → Next week preview             │
└──────────────────────────────────────────────────────────────────────┘

Key design principles in this 10/10 version:
Everything visible on one screen — no scrolling, no pop-ups needed to make the core decisions
Every conflict visible before you click Accept — collision line + 4-week forecast means no surprises
Every cost named clearly — who loses, how much money it changes, what happens to loyalty — all visible in the row, not hidden in a tooltip
Quiet week: the entire grid dims → "Coach deals it — same as last week" → one button: CONTINUE → Week 15
Names only in headers — every option, button, and row uses "your boxer", "the other boxer", or descriptive labels — no names anywhere else
This mechanic already has a strong core — the decisions are there, the trade-offs are real, and it fits cleanly onto what the game already does. The changes above don't reinvent it — they just make sure every choice feels intentional, every consequence is clear, and the player never feels like the game is hiding the math.
Score summary: DEPTH 7/10 · GENERAL DESIGN 8/10 · PLAY 8/10 — passes the 7+ threshold on both required bars. Next step: lock the estimated numbers and ship the 4-week forecast + rotation toggle.
Today 11:11
Chat
Create Videos
Create Images
Writing
Homework
Translate


# CRITIC ANSWER: DESIGN_CLUBWEEK1_V10_CRITIC_GOOSE.md

# CLUBWEEK1_V10 - second critic (Goose, sports management-sim designer)

You are a fresh, independent critic: a sports management-sim designer. Read the whole brief and judge the MECHANIC, not the look of any screen.

## Scores

SCORE depth=6 general=7 play=6

## DEPTH: 6/10

**What works:**
The design has real trade-offs that change outcomes. The class-vs-pads decision is the core lever: selling a full class (+$117, member target +4) costs 3 pad turns and creates BAG nights (half mastery), while keeping pads maintains training quality. This is a genuine money-vs-performance tension. The fight week load stops (tick over / rest up / train through) offer meaningful choices about volume and recovery, grounded in real taper science (Bosquet et al. 2007). The later date rule (decided before the click, never a roll) removes a false choice and gives the player control. Loyalty drifting toward 60 creates ongoing tension without constant crises.

The sponsorship-vs-day-job trade-off is clear: $250/week buys back 1-2 lost mornings, but the day job's cost (-0.2 points/week on one ability) is small enough that a gym can absorb it. The talk system (turn back / promise / straight) gives loyalty management texture.

**What doesn't:**
The coached morning deal is broken. MORNINGSPROBE1 proves that ALL_SOLO dominates both ALL_SHARED and WEAK_FIRST: it gains more total points (63.59 vs 58.53 sessional, 64.32 vs 58.87 full-time) AND more on the weakest ability (16.88 vs 9.29 sessional, 17.68 vs 9.38 full-time). The map claims "shared is the bigger total and solo is the focus" (3.5), but the probe shows solo out-gains shared on every measure because headroom pays the hole more than the multiplier difference compensates. This is a dominant strategy in a weekly decision that should be a real choice.

A gym that sells no classes rarely meets SHORT (the design admits this in risks). With 3 boxers, the squeeze is film and the fourth boxer, but that's honest: the money lever is what makes the club week bite. Still, a no-class gym has weak week-to-week tension.

The fight-week cost line may measure under the 1.5-in-100 cut rule (TAPER1), which would make SHORT cost loyalty only, removing that collision's teeth.

Coach's deal may decide most weeks (acknowledged in risks), leaving the player with one click for the ordinary week.

## GENERAL DESIGN: 7/10

**What works:**
The terminology is clear and consistent: pad turn (20 coach minutes, 3 to an hour), bag night (half mastery), film session (own counter, never a turn). Every concept has one word. The design follows all owner rules: names only in headers (S448), no fixed he/she (S412), every menu wired (S425), ESTIMATEs marked (S459), buildable from what the game has. The later date is decided by a rule and printed on the button before the click, so there's nothing to wait for (pack 4.5: a "no" is a closed panel or an absent answer with its reason).

The probe list is specific with cut rules (1.5 in 100), and the build order is sensible: CHECKs first, then pure rules, then code changes, then screens after owner questions. The page layout (section 12) is concrete enough to draw.

**What doesn't:**
The coached morning mechanic is broken and cannot be wired as designed. MORNINGSPROBE1's finding is clear: "the multiplier is not the lever. Wins follow WHICH ability a morning trains." A design change is needed before wiring: e.g., shared trains the ability BOTH boxers are lowest in, or shared mornings buy something solo cannot (pad turns / sparring readiness for both). Until then, CoachedMornings stays unwired.

Many ESTIMATEs rest on CHECKs not yet run (pad hours, second class, stipend as sponsorship, step mastery counting, weak spot abilities, later-date path, coach budget, loyalty range, pro camp length). If CHECK 1 finds no pad-hour count in code, the 9 and 12 turn values are design values the code must adopt (owner question 2).

The day job is a punishment with no real choice. The default is 1 lost morning (owner question 3), but the player cannot act on it except through sponsorship. A half-sponsorship tier ($125) exists only if the owner picks 2 lost mornings, because at 1 there's nothing to halve. This is a slider the player cannot slide.

Loyalty as a bar conflicts with "traits are learned not shown as numbers" (pack section 3). The design offers owner question 5 (bar or band word only), but the bar's hover says "Under 25: morale -4 each Monday, and morale is the corner's trust," which makes the number matter in the fight. If the owner says no, the bar becomes the band word only, but the moves still happen, so the player needs to see them somewhere.

The page is complex: 1920x1080 with counter strip, coach's week grid, squad rows (one per boxer with morale, loyalty, stickies, seven morning cells, evening magnets, load switch, drag order), grappler row, twist card, talk card, promises, and buttons. That's a lot for one Monday.

## PLAY: 6/10

**What works:**
The collision line ("This fight week lands on a class week: SHORT 1. Short class, cover, Rest up, or the later date.") gives anticipation two weeks out. The reward line ("Fight week on a class week, nobody short: +2 loyalty each") is a small satisfaction. Loyalty drifting toward 60 creates ongoing tension without constant crises. Twists with 2 priced answers add variety. The talk system (turn back / promise / straight) creates drama, especially with the odds in words ("listens: usually").

The NEXT WEEK line shows collisions early, so the player can plan. The later date button (open or greyed with its reason) gives control. The fight week's "three one-to-one sessions, half volume" is a clear, readable change.

**What doesn't:**
The coached morning choice is not fun because it has a dominant strategy (ALL_SOLO). A weekly decision that is not a real choice is not fun to make.

A quiet week is one click ("Coach deals it: same as last week"). This is fast but not engaging. The design accepts this (risks: "Coach's deal may still decide most weeks"), but it means many Mondays are not interesting.

A gym that sells no classes has little week-to-week tension. The squeeze is film and the fourth boxer, but that's not enough to make every Monday bite.

The fight-week cost may be cut (if TAPER1 measures under 1.5 in 100), removing that collision's teeth. Then SHORT costs loyalty only, which is a small price.

The day job is a punishment the player cannot act on (except through sponsorship), so it's not a fun tension.

## Missing options

**Shared mornings that train the pair's shared weak spot:** The probe shows shared is dominated because it trains the coach's day ability for both boxers, not their shared hole. If shared trained the ability BOTH boxers are lowest in, it would be a real choice against solo (which trains one boxer's hole). This would make the coached morning deal a real weekly decision.

**A no-class gym squeeze:** A gym that sells no classes has weak tension. The living world's rival offers (R58) is the likely source, but until that lands, a no-class gym needs a squeeze of its own once a probe shows it needs one. This could be a rival gym poaching a member, or a prospect choosing another gym, or a sponsor asking for results.

**A day job the player can act on:** The day job is a punishment with no real choice. The player cannot slide the slider (0, 1, or 2 mornings) except through sponsorship. A half-sponsorship tier ($125) exists only if the owner picks 2 lost mornings. The player needs a way to negotiate the day job: e.g., "Work mornings only" (2 lost mornings, no sponsorship) or "Work evenings" (1 lost evening, no morning lost) or "No day job" (sponsorship required). This would make the day job a real choice.

**A loyalty bar that doesn't conflict with "traits are learned not shown":** The design offers owner question 5 (bar or band word only), but the bar's hover makes the number matter in the fight. If the owner says no, the player needs to see the moves somewhere. A 4-week log on Overview (as designed) is good, but the player needs a way to see the trend without a bar. A sparkline or a "Loyalty trend: rising / steady / falling" word would work.

## Useless options

**The coached morning deal as designed:** ALL_SOLO dominates ALL_SHARED and WEAK_FIRST on every measure. Until the design changes (shared trains the pair's shared weak spot, or shared mornings buy something solo cannot), this weekly decision is not a real choice. It should not be wired.

**The day job at 1 lost morning with no half-sponsorship tier:** The player cannot act on it except through full sponsorship ($250/week). The half-sponsorship tier ($125) exists only if the owner picks 2 lost mornings, because at 1 there's nothing to halve. This is a slider the player cannot slide, so it's not a real choice.

## What each option changes

**Class (full +$117, short +$78):** Trades pad turns for money and member target. A full class costs 3 turns and creates BAG nights (half mastery). A short class costs 2 turns and keeps the third for row order. This is the core money lever.

**Cover a night ($130, only at SHORT):** Buys 3 turns at the full rate when a class or bout stack leaves a boxer SHORT. Offered only when needed, once a week.

**Pads volunteer ($120/week or $50 on call):** Adds an extra pad hour every week (sessional: Mon, full-time: Sun) at 0.8 of the pads rate. On call is fight weeks only.

**Coached mornings (solo x1.25, shared x1.15, solo on WEAK SPOT x1.40):** Multiplies the morning's stat gain. Solo focuses on one boxer's hole, shared spreads across both boxers. BUT the probe shows solo dominates, so this is not a real choice as designed.

**Sponsorship ($250/week in 4-week blocks):** Buys back the day job's lost mornings. Amateurs and the grappler can hold one. A pro can't.

**Day job (default 1 lost morning, Tuesday):** A boxer without the sponsorship loses 1 morning a week to work. Costs about -0.2 points/week on that morning's ability.

**Fight week load stops (tick over / rest up / train through):** Tick over (default): 3 turns + 1 film. Rest up: 2 turns + 1 film. Train through: 3 turns + 1 film + 1 sparring night (no turn).

**Later date (next show, 2 weeks later):** Decided by a rule, not a roll. Open if the opponent is free, the boxer can make weight, and the season isn't full. Printed on the button before the click.

**Talk (turn back / promise / straight):** Loyalty under 50 triggers "Wants a word." Turn back: dealt first next week, +4. Promise: one of the boxer's open asks, +5 kept / -12 broken. Straight: odds in words, +6 if it holds / -4 if not, then 8-week wait.

**Hold pads (Loyal 70+, 6+ bouts):** The holder gives up their own turn that night and goes to bag. The team-mate's night counts at 0.85 of the pads rate. +3 loyalty a week, 4 weeks at most.

**Twists (7 reworded cards, 2 priced answers each):** Heating breaks, night off, partner ill, southpaw in town, old coach visits, sponsor photoshoot, visiting pro. Each has 2 priced answers.

## To reach 10/10

**1. Fix the coached morning deal before wiring it.** Redesign shared so it trains the ability BOTH boxers are lowest in (their shared weak spot), or give shared mornings a benefit solo cannot buy (pad turns / sparring readiness for both). Then run MORNINGS1 again and confirm each policy is best on 30-70 of 40 seeds. Until then, CoachedMornings stays unwired and the weekly decision is cut.

**2. Settle CHECKs 1 and 2, then run probes 1, 3, 4, and 8, and paste the tables.** The turn maths rests on CHECK 1 (pad hours in code). If the code has no pad-hour count, 9 and 12 are design values the code must adopt (owner question 2). The probes will confirm whether the class price, volunteer price, fight-week cost, and day-job cost are right.

**3. Draw section 12 at 1920x1080 and get owner questions 1-5 answered on it.** The page is complex, and the owner needs to see it before approving. Questions 1 (Club week tab), 2 (bag nights), 3 (day job), 4 (leaving and pro share), and 5 (loyalty bar or band word) all need answers.

**4. Give a no-class gym a squeeze of its own once a probe shows it needs one.** A gym that sells no classes has weak week-to-week tension. The living world's rival offers (R58) is the likely source, but until that lands, a no-class gym needs a squeeze: e.g., a rival gym poaching a member, or a prospect choosing another gym, or a sponsor asking for results.

**5. Make the day job a real choice the player can act on.** The player cannot slide the slider (0, 1, or 2 mornings) except through full sponsorship. Add negotiation options: "Work mornings only" (2 lost mornings, no sponsorship), "Work evenings" (1 lost evening, no morning lost), or "No day job" (sponsorship required). This would make the day job a real weekly decision.

**6. Align with COACHFIT1 so both maps read one budget of turns and mornings (CHECK 7).** The map says "Owned: You 4; Coach 2 sessional or 3 full-time" for coached mornings, but CHECK 7 with COACHFIT1 reads "6 + 2 = 8 and 9 + 3 = 12" for turns plus mornings. Both maps need to agree.

**7. Tune loyalty from LOYAL1 until the talk turns up 2-4 times a season in a class-selling gym.** The drift to 60 and the short penalties need to create the right amount of tension. Too little, and loyalty is a non-issue. Too much, and the player is always in crisis.

**8. Bring back v2 items only as their probes pass, GRAPPLE1 first.** The grappler in the deal, the six new twist cards, sparring settings, mood-only rates, favours, fans and home against away, trial mat, and the fourth start are all gated on their probes. GRAPPLE1 is the most urgent because the grappler is already in the game.

## What a 10/10 looks like (1920x1080 page)

The page is the same layout as section 12, but with the coached morning deal fixed and the day job a real choice. The counter strip shows PAD TURNS, FILM, COACHED MORNINGS (with the fixed shared option), SPONSORSHIP (with negotiation options), and RUNWAY. The coach's week grid shows the pad turns, classes, and cover. The squad rows show the boxers with morale, loyalty (bar or band word, owner's choice), stickies, morning cells (with the day job negotiation), evening magnets, load switch, and drag order. The twist card, talk card, and promises are on the right. The NEXT WEEK line shows collisions early. The reward line is there when nobody is short. The page is complex but readable, and every weekly decision is a real choice with no dominant strategy.
