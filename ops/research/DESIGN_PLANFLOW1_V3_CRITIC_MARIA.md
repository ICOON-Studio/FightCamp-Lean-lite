# PLANFLOW1_V3 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ143)

Brief: research/DESIGN_PLANFLOW1_V3_REVISE_KALLI.md
Sent: 2026-11-15 00:10 | collected: 2026-11-15 00:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing PLANFLOW1 v3 in full now, answering every point from John, Maria and Dola.

# PLANFLOW1 v3: the fight plan as an if-then flowchart, design map (S459, S469, S470, S471, 2026-11-15)

Part 1 of 5

Roadmap row PLANFLOW1. Designer seat: Kalli. Status: v3, for fresh critics. It answers the three v2 critics: John (7/6/7), Maria (7/6/6) and Dola (7/8/7). All three passed the bar; v3 lifts general design, the weakest score.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board and the mockups. The owner's computer is offline, so this map is checked against the critic pack and v2 only.

**Owner rules this map keeps, quoted**
- **S469:** "go with your recommendation". The flowchart is the new look of the plan the game already has, not a second plan system. It ships in stages, simplest first ("ok").
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Boxes, diamonds, arrows, warnings, the round line and tooltips say your boxer, the opponent, your coach.
- **S412:** any gym, any boxers, men or women. No fixed he or she, the opponent's tree included. The code's plan text "she presses" is flagged for "the opponent presses" (CHECK Claude).
- **S425:** every menu and its wiring is in section 11.
- **Pack section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Screens come only from agreed mockups. Nothing opens by itself. No timers. No flavour text. One word per concept.
- **Q-212 (via S470):** no percent stat buffs. Moves are learned, never bought.
- **S439 (via S470):** buttons follow what the game allows at that moment.
- **Pack:** females never fight males; scouting means opponents; classes in kg.
- **S405 / S459:** ESTIMATEs are marked; the map ends with To reach 10/10.

**Tags**
- **CODE:** in the game (pack or S471).
- **NEW:** a small addition, named so Claude can price it.
- **GAME VALUE:** ours by design, with no real source.
- **ESTIMATE:** a starting value the probes size.
- **AGREED, NOT BUILT:** from the pack.
- **CHECK (Claude) / CHECK (John):** open questions.

No probe has run.

## 0. How v3 answers the critics

### 0.1 The six big changes
1. **The opponent's mode is a new tell type (NEW),** with its own place in the tape order. The tree, GUESS and the share bands are tagged as built on it.
2. **Film has one price:** a tape evening is an evening not on pads, in a camp or out of one. In a camp this changes the camp's free Film, so it's owner question 4.
3. **Steps to Sharp are priced at the punch rate** from the same 240 pad units: about 8 weeks on half a pad night, not 4.
4. **Test it plays only against what's known,** so it can't find what film hasn't.
5. **The corner swap is the corner minute's existing "change one plan arrow"** (CODE), drawn on the tree, beside ONE CHANGE, not in place of it. "Resets its PRESSURE" is dropped.
6. **The round filter is cut.** Slow starter and fades late suggest round pace in the Playbook instead.

### 0.2 John's To reach 10/10 (14 points)
| # | Point | v3 |
|---|---|---|
| 1 | Mode as a new tell; tape order | **Done (4.1).** The order is weapon, top unfree mode, habits, second unfree mode, weakness. NEW, CHECK (Claude) |
| 2 | One price for film | **Done (2, 6.2).** Every tape evening costs a pad evening. The camp change waits on owner question 4; without it, section 14 says what's lost |
| 3 | Re-price step pad cards | **Done (5).** 2.1 an hour × 1.25 hours is about 2.6 a full pad night, so 30 to 60 takes about 12 full nights, or about 8 weeks on half a night. STEPS-ONLY runs after |
| 4 | Test against the known file only | **Done (3.5).** Unfound modes are drawn evenly; the result says "2 modes guessed" |
| 5 | GUESS pay rule | **Done (4.3):** "an unfound mode's answer pays as OK, even when right", with a hover |
| 6 | Cut the round filter; suggest pace | **Done (4.4)** |
| 7 | Expected uses per box; pass line per box | **Done (3.1, 9).** Validate warns "rarely reached" |
| 8 | M11 is the plan arrow change; drop the PRESSURE reset | **Done (7.3)** |
| 9 | "Your coach's pick"; a band for 70% | **Done.** No code names on screen; stage 3 prints likely / even / unlikely |
| 10 | Amateur reuse in round 1 only | **Done (6.4).** Tagged GAME VALUE |
| 11 | "Your coach rewrites it"; the opponent's mode count in the minute | **Done (2, 7.3)** |
| 12 | Run the probes | **Not done: I can't run them.** Pass lines are in section 9, and the first batch is named |
| 13 | Settle the CHECKs | **Open (15).** Each row now says what's cut if the answer is no |
| 14 | An aimed shout makes the round active | **Done in part (7.4).** "Lean on it" moves to stage 1 if the shout code allows it (CHECK Claude), otherwise stage 2 |

### 0.3 Maria's To reach 10/10 (10 points)
| # | Point | v3 |
|---|---|---|
| 1 | Owner yes and a drawing before the editor | **Done.** Owner question 1, and the M1, M10, M11 drawings come first. Nothing in stage 1 builds before them |
| 2 | Settle four CHECKs; cut a row on a no | **Done as a rule (15).** Film with no camp, habit as an IF, FireLevel on steps. The round filter is already cut |
| 3 | Probes 1, 2, 4 and 10 first; OK−1 if the gap is small | **Done (9).** If GOOD beats PRESET by under 8, GUESS pays as OK − 1 edge |
| 4 | Re-measure 59/45/41 with GUESS on | **Done (probe 0).** Printed beside the old figures |
| 5 | Price the free picks | **Done.** The timing rule is cut. Copy keeps only drilled pieces. The tires IF sits in every preset and isn't counted as a choice |
| 6 | Where a test's sparring night comes from | **Done (3.5).** It replaces one of the coach's sparring nights in BUILD or PEAK; in BASE it turns a pad night into sparring; never in TAPER. The Week shows "Thu: sparring (plan test)" |
| 7 | Amateur reuse as GAME VALUE, in the first batch | **Done** |
| 8 | A main bet | **Done (3.2).** One diamond carries MAIN BET. The corner read leads with it, and the Why grades it first |
| 9 | A one-step queue for the study slot | **Done (5):** "Next: pivot out (the plan needs it)" moves in when the slot frees. NEW |
| 10 | A live decision in stage 1 | **Done in part:** "Lean on it" (7.4), stage 1 if the CHECK allows |

**Maria's other faults**
| Fault | v3 |
|---|---|
| GUESS weakens a current option | Stated as a change; probe 0 re-measures |
| Test it changes a built feature | Stated (3.5) |
| Lock at the first bell is a change | Stated. No new information arrives between the weigh-in and the bell, so the lock changes no result; probe 0 checks it, with test P7 |
| Presets uncosted | Costed: 6 presets × 4–6 lines, one content task (P1), tuned by probe 2 |
| Coverage count becomes a score | Shown only when an "often" mode is unanswered |

**Maria's missing options:** use the coach's plan and edit one line ("Your coach rewrites it", done); main bet (done); study queue (done); a line on the bout offer, "Your plan against this style last time: +4 to +8" as a band (done, M9).

### 0.4 Dola's To reach 10/10
| Point | v3 |
|---|---|
| Run all probes | Listed (9); I can't run them |
| Film anytime | Done: a Film evening with any bout booked (CHECK Claude) |
| Habit as `when` | CHECK (Claude); a no cuts that habit row |
| Round filters | **Not done:** they answer the wrong question (John 5); round pace does the job |
| FireLevel for steps | CHECK. If steps don't use it, they're priced by their own fire rule, printed the same way |
| Player reorders two diamonds | Only if the code allows two modes at once (CHECK); otherwise there's no number at all |
| Minimum films for "often" | Done: "often" needs 3+ films (4.1) |
| BJJ beats; cutman | Stage 2 and stage 3, unchanged |
| SEEN warning names the line and suggests swaps | Done (7.1) |
| Decoy plan | **Not added as a mechanic:** ProRead waits for the most-thrown punch, and a feint line already blunts it (CODE). Validate shows that punch so the player can steer it |
| Carry the best lines forward | Done: "Start from last bout" keeps the 2–3 lines that fired most and are still at 30+ |
| Preview the opponent's next mode | Done small: the corner read prints the opponent's breathing as likely / even / unlikely to tire next round, from the opponent's Energy band (NEW, CHECK Claude) |
| Tutorial overlay | **Not added:** nothing opens by itself. A "How the chart reads" link on the editor opens the Handbook's plan page (CODE Handbook) |
| Compare two plans | **Not added:** rematches are rare. History shows the plan used each bout |
| Heat map | Done as words, not colour: the tree's hover prints "fired 7 in your last 3 bouts against Pressure fighters" (stage 3) |

**Dola's missing options:**
- **Filter the tree by round:** not added, because films record that a habit showed, not when.
- **Mark a branch low priority:** not added, because the tape order is fixed in the code.
- **Auto-switch preset:** not added, because the style word doesn't change while scouting.
- **Version history:** History per bout covers it.

### 0.5 Options, all lists
| Option | v3 |
|---|---|
| Copy a team-mate's plan (John: by style; Maria: same opponent only) | **By style, drilled pieces only.** It copies only the pieces your boxer has at 30+ and leaves the rest as empty lines: "3 of 5 lines copied; 2 need drilling" |
| Diamond order "1" | Only if two modes can hold at once; otherwise cut |
| Round filter | Cut |
| Tires IF | In every preset; not counted as a choice |
| Coverage count | Only when an often mode is unanswered |
| Expected uses on each box | Added |
| Your coach rewrites it | Added |
| Pace link from a found habit | Added |
| The opponent's mode count in the minute | Added |
| Main bet, study queue, offer line | Added |

Part 2 of 5

## 1. The idea
The plan is a chart your boxer carries into the ring. Each box starts with a diamond: "IF the opponent is pressing". The diamond leads to the answer: "THEN step back and counter with the right hand". Film fills in the diamonds you can trust. Pads make the answers sharp.

In the fight, the game picks the box for the mode the opponent is in (CODE: six modes). It then throws that box's answer, at its FireLevel (CODE). The opponent's last two pro fights decide whether one of those answers is waited for (ProRead, CODE).

The player's work is three choices:
1. Which modes to plan for.
2. Which answers are worth the pad time.
3. Which box to trust most (MAIN BET).

In the corner, the player gets one plan arrow change a round (CODE), on top of ONE CHANGE (CODE).

## 2. What the game already has (CODE)
| Piece | Value | Source |
|---|---|---|
| Plan line worth | edge best 9 / ok 3 / wrong −7; an undrilled line ×0.8 | pack 4.6 |
| Line cap | 4–6, set by the coach | pack |
| FireLevel | 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature | S450 |
| PlanRead | full pay for the first 2 uses of a line in a round, then less; resets at the bell | pack |
| ProRead | pros only: waits for the most-thrown punch of the last two pro fights; two weapons or a feint line blunt it | pack |
| Fight modes | Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt | pack |
| Opponent's file | weapon, habits, weakness, opened in tape order (weapon first, weakness last) | pack 4.3 |
| Camp Film | free in a camp; a Film evening is a Week evening | pack 4.3 |
| Pads | 2.1 mastery an hour; a pad night is 240 units | pack |
| Steps | 10 steps; one study slot gives about 6 a week to Usable 30; nothing passes 30 today | S463 |
| Corner minute | ONE CHANGE (a habit fix / Elbows in / Gloves high) and a separate change to one plan arrow | pack 4.8 |
| Results | good plan 59 / no plan 45 / bad plan 41 | pack |
| Corner scores | corners never see scorecards during a bout | EB 12.10.1, IBA 18.8 (John) |

## 3. The chart (M1, the Playbook editor)

### 3.1 The board
- **Left:** the opponent's tree (from scouting). **Right:** your boxer's chart.
- One box for each mode you plan for, at most as many as the line cap allows. Each box holds one diamond and one answer.
- **Box parts:** the diamond (IF), the answer (THEN: a punch, a combination or a step), the answer's FireLevel stamp (USABLE / SHARP / SIGNATURE), and the uses line.
- **Uses line (NEW, ESTIMATE until probe 6):**
  - "About 1 use a round, 1 in full" on most boxes.
  - "About 3 uses a round, 2 in full" on the bell box. The bell box is the always-on answer, used when no diamond holds.
- **Rarely reached:** a box expected under 0.5 uses a bout shows "rarely reached" (ESTIMATE, from probe 6).

### 3.2 Main bet (NEW)
- One diamond can carry the MAIN BET magnet.
- The corner read opens with it: "Main bet: pressing. Met 3 times, paid 2."
- The Why after the bout grades it first.
- It costs nothing and changes no number. It sets what the player sees first.
- Gold stays on the worth band only, so the magnet is slate with the word MAIN BET.

### 3.3 Buttons
| Button | Does | Stage |
|---|---|---|
| Use a preset | Picks one of 6 style presets (Pressure, Range, Counter, Power, Survive, Balanced). Each has 4–6 lines and already includes the tires IF | 1 |
| Your coach rewrites it | The coach builds the plan from found tells and drilled pieces within the cap; you then edit any line | 1 |
| Start from last bout | Keeps the 2–3 lines that fired most last bout and are still at 30+ | 1 |
| Copy a team-mate's plan | By style. Keeps only pieces at 30+: "3 of 5 lines copied; 2 need drilling" | 2 |
| Test it | One sparring night against the known file (3.5) | 1 |
| Save / Load | Named plans per boxer | 1 |
| How the chart reads | Opens the Handbook's plan page (CODE Handbook) | 1 |

### 3.4 Validate (the strip under the board)
At most 3 lines, each with a fix button:
- "Pressing: often, no box. Add it" (only when an often mode is unanswered).
- "Right hand to the body: not drilled, pays ×0.8. Put it on pads"
- "Slow starter found. Push round 1: Use it" (4.4).
- SEEN warnings for pros (7.1).
- "Rarely reached: clinch box"

### 3.5 Test it (NEW, changes a built feature)
- **Night:** it takes one of the coach's sparring nights in BUILD or PEAK. In BASE it turns one pad night into sparring. Never in TAPER. The Week shows "Thu: sparring (plan test)".
- **Against:** only the known file. Unfound modes are drawn evenly from the ones left.
- **Result:** "Worth: +4 to +9. 2 modes guessed." It finds no tells.
- **Why it costs:** a test night spends the sparring night's units (180, CODE) on the plan, not on general sparring gains.

## 4. The opponent's tree (left side)

### 4.1 Tells (NEW: modes as a tell type)
- **Tape order:** weapon, top unfree mode, habits, second unfree mode, weakness.
- A free mode is known from the style word. A Pressure fighter's "Pressing" is free.
- **Share bands:** "often" needs 3+ films and a mode shown in at least 3 of 4; "some"; "rare". With under 3 films, the most a mode can show is "some" (NEW, ESTIMATE).
- Film opens one tell per Film evening (CODE rate kept).

### 4.2 Habits as triggers
- A found habit can be a diamond: "IF the opponent drops the left after a jab". CHECK (Claude): can a plan line's `when` take a habit?
- If not, habit rows are cut and habits stay ONE CHANGE fixes only.

### 4.3 GUESS (NEW, changes results)
- A box can answer a mode not yet found.
- **Pay rule:** an unfound mode's answer pays as OK, even when it's right. The hover says "Not found on film: pays as OK."
- If probe 1 finds GOOD beats PRESET by under 8, GUESS pays as OK − 1 edge, so film keeps its worth.
- Probe 0 re-measures 59/45/41 with GUESS on and prints both sets.

### 4.4 Round pace (replaces the round filter)
- A found "slow starter" or "fades late" habit puts one line in Validate: "Slow starter found. Push round 1: Use it".
- Use it sets round 1's existing pace choice (CODE fight plan pace, CHECK Claude). It adds no new control.
- If no pace control exists by round, this line is cut.

Part 3 of 5

## 5. Pad time and steps (the cost side)
- **Punch or combination answers:** CODE pad rate, 2.1 an hour.
- **Step answers (NEW pricing):** the same 240 units at the punch rate.
  - A full pad night is about 2.6 mastery (2.1 × 1.25 hours; ESTIMATE, CHECK Claude that 240 units is 75 minutes).
  - Usable 30 to Sharp 60 takes about 12 full nights. On half a pad night, 3 nights a week, that's about 8 weeks (ESTIMATE).
  - The study slot still takes a step to 30 at about 6 a week (S463), so a step reaches 30 in about 5 weeks.
- **Pad card:** "Pivot out: 34 now, Sharp in about 8 weeks on half a night"
- **Study queue (NEW):** one step waits behind the slot: "Next: step back (the plan needs it)". It moves in when the slot frees. Nothing else changes.
- **STEPS-ONLY** (probe 8) runs after this pricing to check a step plan isn't stronger than a punch plan for the same pad time.

## 6. Film, the Week, the amateur game

### 6.1 The offer line (M9, NEW)
- The bout offer shows "Your plan against this style last time: +4 to +8" (a band from that bout's Why).
- It shows only if your boxer has met that style.

### 6.2 One price for film
- **A Film evening** is a Week evening not on pads (CODE).
- **In a camp (owner question 4):** each tape day takes one of the camp's evenings (Light 3, Standard 4, Hard 5; CODE counts). The camp's Film tick shows "Film: 2 evenings (2 tells)".
- **If the owner says no:** camp Film stays free, the film lever only costs outside camps, and section 14 names that risk.
- **Film anytime (Dola):** a Film evening can be set with any bout booked, not only in a camp (CHECK Claude).

### 6.3 Week cost, worked (ESTIMATE)
- A 4-week camp at Standard has 16 evenings. Three film days open the weapon, the top mode and one habit, which leaves 13 for pads.
- Spending those 3 on pads instead buys about 4 mastery on one line (3 × 1.3, at half a night each).

### 6.4 Amateur reuse (GAME VALUE)
- Amateurs have no ProRead.
- **In round 1 only:** a plan used unchanged against the same opponent's club twice in a row starts with its first box SEEN, which halves that box's first full use.
- It's a game value, not a real rule. Probe AMREUSE in the first batch sizes or cuts it.

## 7. In the fight

### 7.1 SEEN (pros only, CODE ProRead)
- **Validate:** "SEEN: right hand at range was your most-thrown in the last two pro fights. Swap to the left hook or add a feint line."
- It names the read line and suggests 1–2 swaps from drilled pieces.
- It also shows "Most-thrown across your last two pro fights: right hand". This is the honest decoy: the player steers it over a career.
- **Named plan SEEN** (owner question 3) is stage 3.

### 7.2 The round line (M10)
- After each round, one line: "Pressing 4 times. Box met 4, paid 2 in full. Main bet held."

### 7.3 The corner minute (M11)
- **Row 1, ONE CHANGE (CODE):** habit fix / Elbows in / Gloves high / No fix.
- **Row 2, the plan arrow (CODE):** change one arrow on the tree, or Keep the plan.
  - The new answer starts fresh under PlanRead. That's the gain (CODE reset at the bell).
  - There's no PRESSURE reset.
- **The opponent's mode count:** "The opponent pressed 1 of 6 exchanges"
- **Breathing (NEW, CHECK Claude):** "The opponent: likely to tire next round" (likely / even / unlikely, from Energy bands).
- No scores. Corners never see cards (EB 12.10.1, IBA 18.8).

### 7.4 Lean on it (NEW)
- When a found mode shows in an exchange, the strip offers "Lean on it". It spends one of the two shouts a minute (CODE).
- **Effect:** that box's answer pays in full for one more use this round, past PlanRead's 2 (ESTIMATE; probe 11 sizes it).
- **Stage:** 1 if a shout can aim at a box (CHECK Claude), otherwise 2.

### 7.5 After the bout (the Why)
- Main bet first, then each box: met, paid, missed.
- Then one line: "Next camp: drill the left hook (fired 1 in 2)."
- The bout's plan is saved to History.

Part 4 of 5

## 8. Worked examples (EXAMPLE DATA, ESTIMATE values)

### 8.1 Amateur, women's 60 kg: a Counter style opponent
- **Film:** 2 Film evenings open the weapon (left hook) and the top unfree mode (Pressing, some).
- **Plan:** a Counter preset, then Your coach rewrites it.
  - Box 1, Waiting to counter (free): feint then step in. MAIN BET.
  - Box 2, Pressing (found): step back, right hand. SHARP.
  - Box 3, Loading up (GUESS): pays as OK.
  - The tires IF comes with the preset.
- **Validate:** "Right hand: not drilled, ×0.8. Put it on pads". The player puts it on half a night.
- **Test it:** BUILD week, Thu sparring. "Worth +3 to +8. 1 mode guessed."
- **In the fight:**
  - Round 1 line: "Waiting to counter 3 times. Main bet met 3, paid 2."
  - Corner: "The opponent pressed 2 of 6 exchanges"
  - Arrow change: box 3 to step back. ONE CHANGE: Gloves high.

### 8.2 Pro, men's 70 kg: SEEN
- **Validate:** "SEEN: jab-right was your most-thrown in the last two pro fights. Swap to jab-hook or add a feint line." The player adds a feint line, which takes 1 of 5 lines.
- **Steps:** "Pivot out: 34 now, Sharp in about 8 weeks on half a night". The player leaves it at Usable and uses the queue: "Next: step back".
- **Lean on it:** used in round 3 on the Pressing box, spending 1 of 2 shouts.

## 9. Probes (none run)
**First batch:** 0, 1, 2, 4, 10, AMREUSE.

| # | Probe | Pass line |
|---|---|---|
| 0 | Re-measure 59/45/41 with GUESS on and the bell lock | Both sets printed; GOOD stays ≥ 56 |
| 1 | GOOD vs PRESET | GOOD beats PRESET by 8+, else GUESS pays OK − 1 |
| 2 | Each preset alone | Each 50–55 against its own style (ESTIMATE) |
| 3 | Film worth: 3 tape days vs 3 pad half-nights | Film wins against an unknown style, pads win against a known one |
| 4 | Test it accuracy against the known file | Band holds the real result 2 in 3 |
| 5 | SEEN with and without a feint line | The feint cuts the loss by half |
| 6 | Uses per box | Every box planned for an often mode gets 0.5+ uses a bout in half the bouts; prints the uses lines |
| 7 | Arrow change in the minute | Positive for the boxer behind on mode count |
| 8 | STEPS-ONLY vs PUNCH-ONLY, same pad time | Within 3 points |
| 9 | Start from last bout vs fresh | Within 2 (carry-over is a time saver, not a buff) |
| 10 | Your coach rewrites it vs GOOD | Within 3 below |
| 11 | Lean on it | +1 to +2 a use when spent on a found mode |
| AMREUSE | Round 1 reuse | Sized or cut |

## 10. Build (each a small task for Claude)
| # | Task | Stage |
|---|---|---|
| P0 | Owner yes to the chart look; drawings of M1, M10, M11 agreed | before all |
| P1 | 6 presets × 4–6 lines (content task, Kalli writes, probe 2 tunes) | 1 |
| P2 | Mode as a tell type in the tape order; share bands | 1 |
| P3 | GUESS pay rule and its hover | 1 |
| P4 | Chart view of the existing plan lines (M1) | 1 |
| P5 | Uses line, rarely reached, Validate (3 lines max) | 1 |
| P6 | Your coach rewrites it; Start from last bout; Save/Load | 1 |
| P7 | Lock at the first bell (from the weigh-in) | 1 |
| P8 | Test it on a sparring night | 1 |
| P9 | Step pad pricing; study queue of one | 1 |
| P10 | Round line (M10); corner mode count and arrow on the tree (M11) | 1 |
| P11 | Main bet magnet | 1 |
| P12 | Pace link from habits (if the CHECK allows) | 1 |
| P13 | Lean on it | 1 or 2 |
| P14 | Offer line (M9); film evening anytime | 2 |
| P15 | Copy a team-mate's plan, drilled pieces only | 2 |
| P16 | Breathing band in the corner | 2 |
| P17 | BJJ beats; cutman; named plan SEEN; the fired hover | 3 |

Part 5 of 5

## 11. Every menu and its wiring (S425)
| Menu | What the plan shows | Wired to |
|---|---|---|
| M1 Playbook editor | Tree, chart, Validate, buttons | Plan lines (CODE), opponent's file, pad mastery |
| M2 Opponent file | Tells in tape order, share bands | Scouting / Film (CODE) |
| M3 Week | Film evenings, "Thu: sparring (plan test)" | Week evenings (CODE) |
| M4 Camp | Film tick with evening count | Camp nights (owner question 4) |
| M5 Pads | Pad cards with "Sharp in about n weeks" | Pad mastery (CODE) |
| M6 Study slot | Current step and "Next:" | StepMastery (S463), queue NEW |
| M7 Boxer profile | Plan tab: saved plans, main bet | Save/Load |
| M8 Team-mate's profile | Copy plan (stage 2) | Copy rule |
| M9 Bout offer | "Your plan against this style last time" | The Why history |
| M10 Round line | Mode, met, paid, main bet | FireLevel, PlanRead (CODE) |
| M11 Corner minute | ONE CHANGE, plan arrow, mode count, breathing | Corner (CODE), Energy band (NEW) |
| M12 Fight strip | Lean on it | Shouts (CODE) |
| M13 Weigh-in | "Plan locks at the first bell" | Lock P7 |
| M14 The Why | Main bet, boxes, next drill | Fight log |
| M15 History | Plan per bout | Save |
| M16 Handbook | The plan page | Handbook (CODE) |

## 12. Words (one per concept)
| Word | Means |
|---|---|
| plan | the whole chart |
| box | one IF-THEN pair |
| diamond | the IF |
| answer | the THEN |
| mode | what the opponent is doing (six) |
| tell | anything film finds |
| MAIN BET | the box to watch first |
| SEEN | a box the opponent waits for |
| GUESS | a box for an unfound mode |
| Test it | a sparring night against the known file |
| Lean on it | the shout that extends a box |

## 13. Stages
- **Stage 1:** P0–P12, and P13 if the CHECK allows.
- **Stage 2:** P13–P16.
- **Stage 3:** P17, and diamond order if two modes can hold at once.

## 14. Risks
- **GUESS shrinks film's worth.** The guard is the OK pay rule, plus OK − 1 if probe 1 fails.
- **If owner question 4 is no,** film costs nothing in a camp, and the film choice only bites in fights booked without a camp.
- **The chart is a second look at one system.** The rule is that one plan feeds both the list and the chart. There's no second store.
- **ESTIMATE uses lines can mislead** until probe 6 runs. Each one has a hover saying "estimate".
- **Six presets may play alike.** Probe 2 tunes them.

## 15. Open questions
**Owner**
1. Does the chart replace the move map as the plan's first view, and are the M1, M10, M11 drawings OK?
2. The last-round trigger: stage 3 with its uncertainty printed, or cut? A corner's own count isn't found as a rule (John).
3. Named plan SEEN in stage 3: yes or no?
4. Does film in a camp take a camp evening?

**CHECK (Claude), each cut on a no**
- Habit as a line's `when` (cuts 4.2).
- Two modes at once (cuts diamond order).
- FireLevel on steps (if no, steps print their own fire rule).
- 240 units equal 75 minutes (re-prices section 5).
- A shout aimed at a box (moves Lean on it to stage 2).
- Pace by round (cuts 4.4).
- Opponent Energy readable as a band (cuts breathing).
- Film evening with no camp (cuts film anytime).
- "she presses" in the plan text (flagged under S412).

**CHECK (John):** Is "often" at 3+ films fair against how much film real amateur corners see? Mark it GAME VALUE until answered.

## 16. Self-score: depth 7, general design 7, play 7

**To reach 10/10**
1. Get owner answers 1–4 and the drawing OK, then build stage 1.
2. Run the first batch (0, 1, 2, 4, 10, AMREUSE) and replace every ESTIMATE in sections 3.1, 5, 6.3 and 7.4 with measured values.
3. Settle the nine CHECKs, and cut every row whose answer is no.
4. If probe 1 fails even with OK − 1, cut GUESS to stage 2 and make film the only way to open a box.
5. Run STEPS-ONLY after the re-price, and set the step pad rate from it.
6. Size AMREUSE, or cut it.
7. Write the six presets (P1) and tune them with probe 2.
8. Build the breathing band only if probe 7 shows the arrow change pays for the boxer behind.
