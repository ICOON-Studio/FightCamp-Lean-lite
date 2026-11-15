# AMATEURWEEK1_V9 - score this mechanic's DESIGN (S459 design loop)

You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design map
at the end. Judge the MECHANIC, not the look of any screen.

Score, each out of 10, with the reasons:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
3. PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
The bar (owner S459): the mechanic is DESIGNED when critics give it 6+ on DEPTH and 6+ on GENERAL DESIGN.

Also answer: which options are missing, which are useless, and what each option changes (owner S403).
End with **To reach 10/10**: the concrete changes that would take it to 10, most important first, each specific enough to
build (owner S405). Then describe your 10/10 as a 1920x1080 page (an HTML file is welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent"). Real-world boxing evidence where it helps.

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

# DESIGN_AMATEURWEEK1_V9_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ144)

Brief: research/DESIGN_AMATEURWEEK1_V9_REVISE_KALLI.md
Sent: 2026-11-15 01:10 | collected: 2026-11-15 01:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing AMATEURWEEK1 v9 in full now. It answers every point in the owner's S475 notes: trips go and the sparring partner screen comes in, tells and mood get shown on screen, and the season ladder moves to its own map.

# AMATEURWEEK1 v9: the amateur fight week, design map (S459, S475, 2026-11-15)

Part 1 of 4

v9 is a full map. It replaces v8 (seat SQ88), and nothing outside this page stands.

**What decides this version:** the owner's S475 board notes on v8 (Q-S294-229), with Claude's six changes. The John SQ80 and Dola SQ79 points that v8 settled are kept and listed in 0.3.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board and the mockups. The owner's computer is offline, so this map is checked against the critic pack, v8 and the S475 notes only.

**Number marks**
- **GAME:** in the code or the pack today.
- **MEASURED:** from a probe already run.
- **ESTIMATE:** ours. None prints on screen before its probe (section 11).
- **NEW:** a rule this map adds.
- **[R]:** a real-world source, carried from v8 and John's work.

**Owner rules kept, quoted**
- **S475:** "4.1 looks like useless logistics and painin the ass for the player, either remove it or adjust it. make the sparring partner mandatory".
- **S475:** "a screen where left side is players fighter in the middel is a list of sparring partners and ton the right athe opponents card (whatever its know about him) so the player can make comparison and decide what sparring partner he needs".
- **S475:** "season ladder needs tobe at least 9/10 (maybe make reputation play bigger role …)". That's a map of its own, LADDER1.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule".
- **S412 SANDBOX:** "the player runs any gym with any boxers, men or women". No fixed he or she.
- Females never fight males. Slots and sparring partners are by sex and class.
- **Section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- "Gym" is the facility; "camp" is pre-bout preparation only. Amateur bouts have no camp, so this is the FIGHT WEEK.
- **S455:** Look B, the gym whiteboard. Everything new ships switched ON. Screens come only from agreed mockups.

**Words:** "under 4 wins", never "novice". Classes in kg. Stats use the Attrs names.

## 0. Every point answered

### 0.1 The owner's S475 notes
| # | The owner's point | v9 |
|---|---|---|
| O1 | "4.1 looks like useless logistics … remove it or adjust it" | **Removed.** Trips, food, cottage, commute, the COACH AWAY card and the trip payer rows are gone. Savings and SKINT went with them, since they existed only to pay for trips |
| O2 | "make the sparring partner mandatory"; a three-column screen | **Done (4.1).** CHOOSE A SPARRING PARTNER: your boxer on the left, the partner list in the middle, the opponent's known card on the right. No sparring night locks without a partner, and none is pre-selected |
| O3 | "4.4 is connected to other things like scouting and film?" | **Yes, now on purpose (4.1, 5).** A partner can only match what's known about the opponent. Each filmed tell adds a match point a partner can share. With nothing filmed, the best match possible is PART, and the screen says "film to find a closer partner" |
| O4 | "4.8 … easy to see the ladder and find an opponent and book a fight … at least 9/10 … reputation" | **Moved to LADDER1.** SEASON is cut from this screen. The bout sheet keeps only what the fight week needs (2), and the nationals entry, the pro road, the assistant picking the bout and the goal types go to LADDER1 with the reputation question |
| O5 | "how is this [tell truth] shown to the player?" | **Drawn (5.2).** Four words on the opponent's card and on every plan line that relies on the tell: "seen on tape: likely", "seen twice: very likely", "confirmed in the fight", "didn't happen" (crossed out). The hover gives the odds |
| O6 | "need to explain to me how this [look again / next group] works" | **Explained (5.3) and printed on the film magnet** as one line with the screen's own count |
| O7 | "How is mood gained and what affects?" | **Answered (6)** from the code's mood events, with what mood does in the corner. Fight week adds one mood move and shows mood in the header and on TONIGHT |
| O8 | "I am not sure about the trip mechanic" | **Cut** (O1). The round-1 edge the trips gave moves to a CLOSE partner match |
| O9 | "I want to see 9s frame" | **Read as: show the screen at a 9/10 standard.** Section 9 specifies both frames at 1920×1080. The PNG boards are the next design session, one board each. Owner question 1 checks this reading |

### 0.2 Claude's S475 changes
| # | Change | v9 |
|---|---|---|
| C1 | 4.1 becomes CHOOSE A SPARRING PARTNER, mandatory, three columns; an outside partner costs a favour or a fee, paid by the club | Done (4.1). The fee is $160, the camp's outside partner fee (GAME) |
| C2 | Sparring tied to scouting and film | Done (4.1 match points) |
| C3 | SEASON becomes LADDER1 | Done (O4) |
| C4 | Tells shown in plain words on the card and the plan line | Done (5.2) |
| C5 | Look again vs next group explained on screen | Done (5.3) |
| C6 | Mood: what moves it, what it does | Done (6) |

### 0.3 Kept from v8 (John SQ80, Dola SQ79)
- **The two-layer tank (J1)** and Eat less at 4 off (J2).
- **Rest up at 65+** reads "Sharp, no boost" (J2).
- **One weight rule** with the EB gap at club shows (J3).
- **The pull-out roll** on the Monday of fight week (J4).
- **Each changed line goes back to UNSPARRED,** with a warning first; the player picks which two lines a night readies (J5).
- **Swap** on a shared slot (J6).
- **Film:** locked on a debutant; "cleared as false" (J7).
- **The pack changes listed (J8).**
- **Probes before prints (D1); systems first (D2); the readiness line (D4); the next-stop hover (D5).**
- **No longer needed:** v8's cottage refund answer (J4) and the stipend and savings answer (J8), because trips and savings are cut.

## 1. The idea

An amateur bout is booked 1 to 3 weeks out and has no camp. The FIGHT WEEK screen covers the bout's last two weeks:
- **2+ weeks out:** a WEEK BEFORE strip sits on its own row. It holds the week-before sparring night and film.
- **1 week out:** fight week only.
- **3 weeks out:** week 1 is a normal BUILD week on the week board.

For an amateur bout, the WEEK BEFORE strip replaces PEAK and the fight week's load stop replaces TAPER. That needs a WeekPhase amateur branch (NEW; CHECK Claude, since today a 2-week amateur bout gets PEAK).

**The player's choices in fight week:**
1. Who to spar, and when.
2. How hard to train.
3. How to make the weight.
4. What to film.

Every choice lands on ON FIGHT NIGHT, which has two rows: TONIGHT and BANKED.

## 2. The bout sheet (only what the fight week needs)

**Slots by class:**
- A show offers slots by sex and class, at most three cards on a sheet.
- When two of the club's boxers share a kg class, the slot defaults to the longer wait. A **Swap** button gives it to the other boxer, whose card says "this slot went to your other 65 kg boxer" (NEW).

**Pass:**
- Passing a sheet is free.
- Refusing a card a club offered by name counts against that club: two refusals in 8 weeks lock that club out for 8 weeks. The card shows "refused n of 2".

**Rematch:** a boxer met before is marked REMATCH, and last time's tells come back as "seen on tape: likely".

**Lead time (NEW, pack change):** amateur offers land 1 to 3 weeks out. Set camp never appears for amateur bouts.

**Rest window:**
- Set on the boxer page's Fights tab: "next bout no sooner than 3 / 5 / 8 weeks", default 3.
- It can't be shorter than the 30-day suspension or `Matchmaking.STOP_REST_WEEKS` (both GAME).

**Ring rust:** 6 weeks READY without a bout puts the boxer FLAT in round 1.

**Home and away:** home gives the $450 ticket cut, +8 members and +5 reputation (GAME). Away means a ranked chance, judged in LADDER1.

**Favours with a host (0 to 3, NEW):**
- Earned by filling a late gap.
- Spent on Ask for a kilo (4.4) or on an outside sparring partner (4.1).

**Moved to LADDER1:** the nationals entry count, the pro road (9 wins), the assistant picking the bout, the rank and money goal types, the loss-below rule and the pro pace. Until LADDER1 lands, the game's current rules stand (GAME).

Part 2 of 4

## 4. The fight week screen

### 4.1 CHOOSE A SPARRING PARTNER (NEW screen, mandatory, replaces WHERE TO TRAIN)

**When it opens:**
- Pressing a sparring magnet on the fight week screen opens it. It's a press, so nothing opens by itself.
- A sparring night with no partner stays an empty magnet. The red **Lock the week** button is greyed with the reason "pick a partner for Thu".
- No row is pre-selected. Your assistant's choice carries a small marker note, "your assistant's pick", with its one reason.

**LEFT, your boxer:**
- Portrait and name (the header), the class in kg, stance, height and reach (GAME since S450), the style word.
- The plan lines this night will ready, with a tick beside each of the two picked.
- The three stats that matter for this matchup, read from the opponent's style. For example, against a Pressure fighter: Footwork, Defence, Stamina.

**MIDDLE, the partner list (at most 6 rows):**

| Row type | Who | Cost | What's known about the partner |
|---|---|---|---|
| Club boxer | same sex, within one class | free | style, stance, size, level, every habit (your coach's notes) |
| Club member | always one row | free | stance only. No style, level "below". The test reads "?" on Beats it |
| Partner at another club | 2–3 boxers from nearby clubs on the region table, same sex, within one class | $160 (GAME, the camp's outside partner fee) or 1 favour with that club's host | style, stance, size, level, plus any tell your gym found on them before |

**Each row shows:**
- The partner's style word, stance, size against the opponent ("2 cm shorter reach"), and level (above / level / below).
- The cost.
- The match word with its points.
- What the night readies.

**RIGHT, the opponent's card (only what's known):**
- Record, style word, stance, height and reach. These are free at booking (GAME, S410 tale of the tape).
- Each filmed tell, with its truth word (5.2).
- Every unfound line reads "?" with what opens it ("film night: next group").

**THE MATCH (NEW, ESTIMATE points):**
A partner scores a point for each known fact they share with the opponent:
- **Same style word:** 2.
- **Same stance:** 1.
- **Reach within 5 cm:** 1.
- **Each filmed tell the partner also does:** 1.

| Match | Points | Round-1 edge (moved from v8's trips) | Plan test |
|---|---|---|---|
| CLOSE | 5+ | +1.0 against this opponent (about 1 to 1.5 wins in 100) | Beats it / Works / Walks into it, as trusted |
| PART | 3–4 | +0.5 | the same ratings, marked "likely" |
| LOOSE | 0–2 | 0 | Works / Walks into it only; Beats it shows "?" |

- **Unscouted opponent:** with no filmed tell, the most points possible is 4 (style, stance, reach), so the best match is PART. The middle column's header says "film a tell to find a closer partner". This is the link to scouting and film the owner asked for.
- **Level:**
  - **Above:** the night's injury risk ×1.15 (ESTIMATE, carried from v8's commute).
  - **Below:** the test reads "may flatter" beside Beats it.
  - **Level:** neither.
- **Every match readies lines.** The match changes the round-1 edge and how far the test can be trusted, never whether lines get readied.
- **Females never fight males:** only same-sex partners are listed (owner rule).

**Buttons:** Spar with this partner (one per row), Back to the week. A row whose cost can't be paid is greyed with the reason ("no favours with this host", "cash under $160").

### 4.2 THE TANK (two layers, kept from v8)
The tank is the energy ceiling at the first bell.

| Layer | Parts | Cap |
|---|---|---|
| Tiredness | 1 off for each point of start tiredness over 50 | 25 |
| Choices (after it, uncapped) | Tick over 6, Train through 12; each fight-week sparring night 3, or 5 at 5 or fewer days out; Eat less 4 | none |

**Worked at start tiredness 75:**
- **Rest up:** 0 off, since tiredness is brought to 30 before the bell.
- **Tick over:** 31 off.
- **Train through:** 37 off.
- **Train through with two late nights:** 47 off.

All of these are ESTIMATES until FIGHTWEEKPROBE4. The bar shows the tiredness layer in grey and the choices in colour, each with its price in wins in 100 on hover.

### 4.3 THE WEEK'S LOAD (three stops, kept from v8)
| Stop | The week | Tank | Round 1 | Banked | After the bell | Best when (printed) |
|---|---|---|---|---|---|---|
| Rest up | three rest days | 0; tiredness to 30 before the bell | under 40: FLAT −2.0; 40–64: FLAT −1.0; 65+: Sharp, no boost (ESTIMATE) | a fifth of the pad units | nothing | start tiredness 65+, or a heavy cut |
| Tick over (default) | one rest day, volume halved [R] | 6 off | Sharp; ONE chosen line at Usable or Sharp fires a level up in rounds 1–2 | half the pad units | nothing | most weeks under 65 |
| Train through | full week | 12 off | Sharp | full pad units (720 for 3 nights, GAME) on the plan's moves, with the crossing printed ("Uppercut 27 to 31: Usable by the bell") | +6 tiredness; enters TrainingLoad (a 1.5× spike means injury ×2–4, GAME) | a plan move is within a week of a tier, or the opponent is rated 5+ below |

**Next-stop hover:** it shows the next stop's tank, round-1 and banked lines side by side, and names prices, never "best".

### 4.4 SPARRING: the night that readies a plan (kept, with the partner)
- **UNSPARRED:** a line written or changed since the last sparring night fires one level down in rounds 1 and 2. Before a change, the screen says "changing this line makes it UNSPARRED until the next sparring night".
- **Which lines:** an early night readies two lines the player picks. The default is the first two UNSPARRED lines in plan order.
- **Never confirms a tell:** only the fight does.

| Night | Price | Readies |
|---|---|---|
| Week before (8+ days out) | one pad night's mastery | two lines |
| Fight week, 7 or 6 days out | 3 off the tank | two lines |
| Fight week, 5 or fewer days out | 5 off the tank, training injury ×2.5, and a cut that ends the bout 3 in 100 (ESTIMATE; NEW, overrides TAPER's no sparring at a stated price [R] Buglioni, Boxing News 2016) | every line |

**Partners:** each night has its own partner, so two nights can use two partners.

### 4.5 THE WEIGHT (kept from v8)

**Club shows (NEW, [R] EB 7.1.3 and 2.7.8):**
- Weigh-in on bout day, 1 hour before, matched at walking weight within a gap: 2.5 kg up to 65 kg classes, 5 kg above, 2 kg for skills bouts.
- The class sets the slot only.

**Championships:** the class limit, the day before (GAME).

**Ways to make it:**
- **Eat less:** Cut 500 kcal (GAME), 4 off the tank.
- **Train it off:** 0.3 kg for +8 tiredness. It's better only under about 42 start tiredness (DERIVED, John).
- **Ask for a kilo:** 1 favour, only within 1 kg of the gap's edge.

**A miss:** the host re-matches on the night 1 in 3 (ESTIMATE; CHECK John on EB rules). Otherwise the bout is off, $300 (GAME), and 1 favour is lost.

### 4.6 YOUR ASSISTANT'S PICK
- **What it reads:** six facts, which are start tiredness, the weight's tank cost, the opponent's round-1 style, the rating gap, unsparred lines and the best partner match. It names the one fact that drove it.
- **Partner:** on the partner screen it's a marker note only, never a selection.
- **Load and weight:** "Use the pick" applies the stops.
- **Sureness:** 0.5 + rating / 200, from the GAME ratings: about 0.79 for the sessional assistant and 0.87 for the full-time one. When it's wrong, it takes the next stop and still gives its reason.
- The card says "your assistant" beside the portrait.

Part 3 of 4

## 5. Film and tells

### 5.1 The film night
- A film night costs one pad night and opens one tell group (GAME rate kept).
- **Locked on a debutant:** a magnet reads "no tape on a debutant" (GAME: no bouts means no tape).
- A tell is checked at the first corner minute where the opponent's mode matched it. A fade or slow start is checked at the round-2 minute, since amateur bouts have minutes after rounds 1 and 2 only.

### 5.2 How a tell's truth is shown (answers O5)
| State | Word on screen | Drawn as | Hover (ESTIMATE until the film test) |
|---|---|---|---|
| Filmed once | "seen on tape: likely" | marker text | "About 7 in 10 tells seen once are real." |
| Filmed twice (Look again) | "seen twice: very likely" | marker text, underlined | "About 9 in 10." |
| Seen in the fight | "confirmed in the fight" | marker text with a tick | "It happened tonight." |
| The moment came, the tell didn't | "didn't happen" | the line crossed out in marker | "The opponent was in that mode and didn't do it." |
| The moment never came | stays "likely" / "very likely" | unchanged | "The fight never gave it a chance." |

**Where it shows:**
- On the opponent's card: the right column of the partner screen, the bout card and the Tape room.
- On every plan line that relies on that tell (Playbook, Game plan).
- At the corner minute, as the same word in the corner card.

A crossed-out tell turns its plan line's tag to "relies on a tell that didn't happen". That's something the player can act on: the corner minute's "change one plan arrow" (GAME).

### 5.3 Look again or next group (answers O6)
**The rule, in plain words:**
- A plan line that relies on a tell is wasted if the tell turns out false.
- At "likely" that happens about 3 times in 10; at "very likely" about 1 time in 10.
- So **Look again** saves about a fifth of a line for every line that relies on those tells.
- **Next group** finds a new tell, each only likely. It's worth about seven tenths of a line, but only if the plan has room for a new line (a free line, or a line answering nothing found).

**So:**
- Look again pays more when 4 or more lines rely on the tells you have, or when the plan has no free line.
- Next group pays more when the plan answers many different things and has room.
- All of this is ESTIMATE until the film test.

**Printed on the second film magnet, one line each, with the screen's own counts:**
- "Look again: 3 lines rely on these tells. Makes them very likely."
- "Next group: 1 free line. Finds new tells, each only likely."

The magnet never says which is best. The counts let the player see it.

## 6. Mood: what moves it and what it does (answers O7, GAME `FighterProfile.MORALE_EVENTS`)

**What moves it:**

| Event | Mood |
|---|---|
| A win / a loss | +8 / −12 |
| A bout booked | +5 |
| A rest week | +4 |
| A month with no fight | −6 |
| A goal met / missed | up / down (GAME) |
| A night off given / refused | +4 / −4 |
| Their ask granted / overruled | +5 / −5 |
| A corner call that worked / went wrong | +1 / −2 |
| **NEW, fight week:** the bout falls through and the boxer goes home | −6 |

**What changes the size:** Heart softens losses, Confidence scales gains, and Coachability softens being overruled (GAME).

**Words:** Fired up 75+, Steady 50+, Flat 30+, Low under 30 (GAME).

**What it does:** mood is trust in the corner. The corner's words land at 1.05 Fired up, 1.0 Steady, 0.85 Flat and 0.7 Low. A Low boxer ignores shouting (GAME).

**On this screen:**
- The mood word in the header, with a hover listing the last three moves and their causes.
- On TONIGHT, one line: "Mood Flat: the corner's words land at about 85 in 100."
- What the player can do about it this week: grant the boxer's ask, give the night off, or Rest up (rest week +4).

**Cut with the trips:** v8's payer mood rows and SKINT.

## 7. Things that happen

**The pull-out roll:**
- It fires on the Monday of fight week, 5 days out, and stops the clock once as a need on Home.
- 35 in 100 per bout, inside John's sourced 25–50% [R] (Northants Telegraph 2025; Sussex Express 2015).

**The fall-through card's three answers:**
- **Take the replacement:** the host's name at short notice (GAME: tougher, double reputation on a win). The partner screen re-opens on a press, since the opponent's card changed.
- **Go home:** tiredness carries as under Rest up; mood −6.
- **Ask for next month's slot:** 1 favour, booked.

**What stays:**
- A banked week always stays.
- An outside partner's fee already paid stays paid.

**Late asks:** a host asks at most once per show, only when the boxer fits the gap and is READY, about 1 show in 6 (ESTIMATE). They land with Monday's need.

## 8. What each option changes
| Option | Changes |
|---|---|
| Swap slot | which same-class boxer gets the slot |
| Pass / refuse named card | nothing / that club's lockout count |
| Rest window | when the next sheet comes; ring rust |
| Sparring partner | round-1 edge, how far the test is trusted, injury (level above), cash or a favour |
| Sparring nights | ready lines, against tank, injury and cut risk |
| Load stop | tank, round 1, banked mastery, tiredness after |
| Eat less / Train it off / Ask a kilo | weight margin, against 4 tank / +8 tiredness / 1 favour |
| Film / Look again / Next group | which tells are known and how sure |
| Fall-through answers | the bout, mood, a favour |
| Use the pick | applies the load and weight stops, with the reason |

Part 4 of 4

## 9. ON FIGHT NIGHT and the two frames (answers O9)

### 9.1 ON FIGHT NIGHT (the one gold frame on the fight week screen)
- **Readiness line (top):** "n ready, n UNSPARRED, n tells likely, n very likely". Clicking it highlights those lines.
- **TONIGHT:**
  - The two-layer tank.
  - Round 1: Sharp, Sharp (no boost) or FLAT.
  - The partner match word and its round-1 edge.
  - Each plan line's fire share with its tag (READY / UNSPARRED) and its tell word.
  - The scale margin against the gap.
  - The mood line.
  - The win band.
- **BANKED:** the Attrs points, the moves crossing a tier by the bell, and tiredness after.
- Each row shows its change from your assistant's pick, and hovering any number shows its parts.
- No SEASON row (LADDER1). No PEAK CAMP row.

### 9.2 Frame A: the fight week screen (1920×1080, Look B)
- **Shell:** the dark top bar and left rail around a whiteboard.
- **Header (96 px):** both portraits with the names once, the class in kg, records, days to the bell, home or away, favours with the host, the scale margin now and on the day, and the mood word.
- **WEEK BEFORE strip (84 px, only 2+ weeks out):** the week-before sparring magnet with its partner's match word, and the film magnet.
- **Left (440 px):** the WEIGHT pills (Eat less, Train it off, Ask a kilo with its favour), and the film magnets with the Look again / Next group lines.
- **Centre (920 px):**
  - Seven day columns of magnets. Sparring is red, showing the partner's match word or "pick a partner". Film is tape.
  - The LOAD three-stop pill with the line picker and the next-stop hover.
  - Plan line chips with their tags.
- **Right (560 px):** ON FIGHT NIGHT in gold.
- **Bottom (120 px):** your assistant's note, **Use the pick**, and the red **Lock the week**. Green is used only for Continue.

### 9.3 Frame B: CHOOSE A SPARRING PARTNER (1920×1080, Look B)
- **Header (96 px):** "Sparring, Thu, 6 days out", your boxer's name once, and "pick one partner".
- **Left (520 px):** your boxer's polaroid, class, stance, height and reach, style word, the three matchup stats, and the two lines to ready (ticks).
- **Middle (760 px):** up to 6 partner rows on cream paper. Each row has a silhouette or portrait, style, stance, reach against the opponent, level, cost, match word and points, "your assistant's pick" note on one row, and **Spar with this partner**.
- **Right (520 px):** the opponent's card: polaroid, record, style, stance, size, filmed tells with their truth words, and "?" lines with what opens them.
- **Bottom (120 px):** "film a tell to find a closer partner" (when no tell is filmed) and **Back to the week**.
- **Gold:** on the picked row's match word only.

## 10. Menus: every place the mechanic appears (S425)
| Menu | What it shows / lets you do | Wired to |
|---|---|---|
| Home (needs) | an open sheet; the Monday-of-fight-week need (pull-out roll, asks) | Needs, BoutSheet, Clock |
| Office desktop | sheet and bout dates for the next four weeks | Desktop (built), BoutSheet |
| Fights rail page | up to 3 cards, Pass, "refused n of 2", Swap | BoutSheet, RegionShows |
| Bout card / versus screen | REMATCH, the weight gap, the tells with truth words | BoutSheet, OppFile, WeighGap (NEW) |
| Boxer page, Fights tab | rest window 3 / 5 / 8 | Matchmaking |
| Fight week screen | strip, magnets, LOAD, WEIGHT, film lines, ON FIGHT NIGHT, the pick | FightWeek, WeekPhase (amateur branch), PadWeek, TrainingLoad, WeighGap |
| Choose a sparring partner (NEW) | three columns, match words, cost, Spar with this partner | PartnerPick (NEW), MatchScore (NEW), RegionShows, OppFile, Favours |
| Week board | the BUILD week of a 3-week bout | WeekPlan, WeekPhase |
| Playbook, Game plan | UNSPARRED tag and warning; tell words on lines; plan test ratings by match | Playbook, StrikeMap, FireLevel |
| Tape room | film nights, truth words, debutant lock | OppFile, TapeRoom |
| Corner minute (rounds 1 and 2) | confirmed / didn't happen; change one plan arrow | FightNight, OppFile |
| Weigh-in | bout-day scale at club shows; class limit the day before at championships | Bouts.weigh (home-show branch, NEW) |
| Result / Why | unsparred lines and lines relying on a tell that didn't happen, in AGAINST YOU | Why |
| Money | outside partner fees | GymBills |
| Continue button | stops once on the Monday of fight week | Clock |

## 11. Pack changes and build

**Pack changes:**
- Amateur lead time goes to 1–3 weeks, with no Set camp.
- WeekPhase gets an amateur branch.
- Bouts.weigh gets the club-show gap.
- The rest window replaces the fixed 21 days.
- TAPER's no-sparring rule is overridden at a price.
- NEW sparring partner screen and match score.
- Removed from v8: trips, savings, SKINT, the cottage and SEASON.

**Build order:**
1. **Probes:**
   - **FIGHTWEEKPROBE4:** each stop best in 1 week in 5 per tiredness band; a gap of 3 to 8 in 100.
   - **Assistant probe:** a reader beats the pick by 2+ in 100. If not, load folds to two stops.
   - **PARTNERPROBE (NEW):** CLOSE is worth 1 to 1.5 in 100 over LOOSE; the outside partner is worth its fee in at least 1 bout in 4; level-above injury doesn't wipe out the gain.
   - **Film test:** Look again and Next group are each best in some state; it sets the 7 and 9 in 10.
   - **Tank test, favour test (1 to 2), sparring test (2 to 5 in 100).**
2. **Systems:** BoutSheet, RegionShows, the WeekPhase amateur branch, the Bouts.weigh branch, WeighGap, PartnerPick, MatchScore, Favours.
3. **Frames A and B** as Look B PNG boards for the owner's OK, then build.
4. **Rest window, Swap, REMATCH, the Monday card.**
5. **Truth words and Look again / Next group lines.**

## 12. Open for the owner
1. "I want to see 9s frame": does that mean the two screens drawn at a 9/10 standard (Frames A and B as PNG boards next), or something else?
2. The sparring partner screen as specified, mandatory with nothing pre-selected: yes?
3. Outside partner cost of $160 or a favour: yes?
4. The rest window replacing the fixed 21 days: yes or no?
5. Tick over at one rest day instead of the three-day TAPER: yes or no?
6. Club-show weigh-in on bout day within the EB gap: yes or no?
7. The pro road, the nationals entry and the loss-below rule: decided in LADDER1, with reputation as the currency.

**CHECKs**
- **Claude:**
  - The WeekPhase amateur branch.
  - The home-show branch in Bouts.weigh.
  - Region-table boxers' height, reach and stance readable as partners.
  - A tell's habit data readable on club boxers for the match.
- **John:** whether a host may re-match a missed boxer on the night under EB rules, and how often.

## 13. Self-score: depth 7, general design 7, play 7

**To reach 10/10**
1. Get the owner's answers 1–6, and draw Frames A and B as PNG boards for his OK.
2. Run PARTNERPROBE and the film test, and replace the match points, the round-1 edges and the 7 and 9 in 10 with measured values.
3. Run FIGHTWEEKPROBE4 and the assistant probe. Fold load to two stops if the pick is near-best.
4. Land LADDER1 so the bout sheet's booking reads from reputation, and re-check section 2 against it.
5. Settle the four Claude CHECKs. If region-table boxers can't be read, outside partners show style and stance only, and the most they can reach is PART.
6. Size the fall-through mood (−6) and the late-ask rate with a bout-log probe.
