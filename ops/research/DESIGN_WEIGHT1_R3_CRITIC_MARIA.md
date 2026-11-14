# WEIGHT1_R3 - score this mechanic's DESIGN (S459 design loop)

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


# THE DESIGN MAP TO SCORE: Weight: making weight before a bout

# DESIGN_WEIGHT1_R3_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ116)

Brief: research/DESIGN_WEIGHT1_R3_REVISE_KALLI.md
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
