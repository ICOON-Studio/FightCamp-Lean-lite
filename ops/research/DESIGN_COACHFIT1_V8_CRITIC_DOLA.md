# COACHFIT1_V8 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ131)

Brief: research/DESIGN_COACHFIT1_V8_REVISE_KALLI.md
Sent: 2026-11-14 22:10 | collected: 2026-11-14 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: writing COACHFIT1 v8 in full, with every point from both critics answered.

# COACHFIT1 v8: coaches who fit, fill up, grow and bond, design map (S459, 2026-11-14)

Part 1 of 5

Roadmap row COACHFIT1. Designer seat: Kalli. Status: v8, for two fresh critics. It answers John (6/5/6) and Maria (7/6/6) on v7.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board and the mockups. The owner's computer is offline, so this map is checked against the critic pack and v7 only.

**Owner rules this map keeps, quoted**
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Coaches are named only in a section or card header. Rows and lines say the sessional assistant, the full-time assistant, the club coach, your coach, your 60 kg boxer, the opponent.
- **S412:** "the player runs any gym with any boxers, men or women". No fixed he or she.
- **S425:** every menu and its wiring is in section 11.
- **S459 / S405:** the bar is 6+ / 6+; ESTIMATEs are marked; the map ends with To reach 10/10.
- **Pack section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Also from section 7:
  - Nothing opens by itself.
  - Weekly jobs never become a pop-up.
  - One word per concept.
  - Screens come only from agreed mockups.
  - Look B, the whiteboard.
  - "Gym" is the facility; "camp" means only pre-bout preparation.
  - Money in USD, classes in kg.
- **Kit:** green on Continue only; gold on one thing per frame; every red carries its word.

**Marks:** CODE (in the game today), NEW (must be built), ESTIMATE (our number, set by a probe), AGREED, NOT BUILT (from the pack), CHECK (Claude) / CHECK (John) (open).

**No probe has run.** Every fit, coach time, bond and raise number is ESTIMATE until section 12 prints.

## 0. What changed and how v8 answers the critics

### The four big changes
1. **Evenings train moves, mornings train stats, as the code does.** Fit multiplies the **drill units** on pad and sparring nights, including the step study slot (S463), and the **stat gain** on mornings. The evening-to-stat map is gone.
2. **The worked bout week (10.3) is rebuilt** so every sum adds up, morale included.
3. **One focus:** the FOCUS pill **is** the camp focus during a camp, the camp list uses Attrs names, and modes read this week's drill cards.
4. **Release 1 is designed for one assistant, the promoted club coach and you.** A second assistant is a bonus if the code allows it.

### John's To reach 10/10 (13 points)
| # | Point | v8 |
|---|---|---|
| 1 | Fit on drill units (evenings) and stat gain (mornings) | **Done (2.1, 3.1).** The Monday line reads "Jab 41 to 47: good fit with the pads coach". Faster mastery means FireLevel tiers come sooner |
| 2 | Rewrite 10.3 so it adds up | **Done (10.3).** Every sum is shown; morale trust is in the word taken in (85% Working, 90% Trusted, 105% after LIFT crosses into Steady); fit 48 is MIXED; the PEAK boxer's 60/40 is priced |
| 3 | One focus | **Done (2.3).** The pill is the camp focus in camp, the camp list moves to Attrs names, and the signing pick is renamed "Start with" |
| 4 | Both assistants, settled first | **Done in part.** I can't read the code, so it stays a CHECK (Claude). The design no longer depends on the answer: release 1 is one assistant, the promoted club coach and you (9.1) |
| 5 | England Boxing rule for the promoted coach | **Done (9.1).** Pads, bags, conditioning and corner, no sparring nights. The Level 2 course opens after 52 weeks: sparring, +2 coach time, ceilings +5 |
| 6 | Year-one payoff for a raise; fix the cost and pace | **Done (4.3).** Paying gives +1 coach time for good. Cost is about 6 members per raise ($8.08 a week each), so 3–4 asks are 19–25 members. Pace: per area, and at most one ask per coach in 12 weeks |
| 7 | Cap borrowing | **Done (3.4).** 0.5 over is free; over 0.5 up to 1.5 is −8 fit; over 1.5 is −18. Never more than 2 over. The need carries "Rest next week" |
| 8 | Quarrels without a source | **Done:** quarrels moved to release 2 with the Drill sergeant |
| 9 | SHIELD as the free base; drop TEACH's +2 | **Done (5.1).** SHIELD costs nothing and cushions every boxer's loss; LIFT is the +0.5 boost. The +2 cliff is gone |
| 10 | Film, steps, the plan line, the floor, rounding | **Done.** Film takes no coach and no fit (it opens tells, CODE). Fit applies to the step study slot. Trusted gives +1 line up to 7. The 0.50 floor is removed. Every ceiling rounds down |
| 11 | A balance probe on training | **Done (12, TRAINBALANCE).** A season of TOP fit against average must move bout wins by less than a good plan's +14 in 100, headroom clamp on |
| 12 | The head coach starts at Working | **Done (6.1)** |
| 13 | Owner OKs an M1 mockup; a player who never opens it loses little | **Done (13).** Nothing builds before the OK. The coach's board must sit 2–5 wins in 100 below the best hand board (BOTSUITE) |

### Maria's To reach 10/10 (10 points)
| # | Point | v8 |
|---|---|---|
| 1 | Check the everyday budget | **Done (3.3).** One boxer in BASE costs 4.5; two cost 9.0. The sessional assistant goes up to 10, so it's on budget in every BASE week. Over budget happens only in camp and bout weeks |
| 2 | Prove the board is worth editing | **Done.** BOTSUITE asks for 2–5 wins in 100 (the floor of 2 so editing matters, the cap of 5 so John's never-open player isn't punished). The Monday page prints "Your board this week: +0.3 Speed, +2 Jab over the coach's", or the reverse |
| 3 | Cap stacking | **Done (2.1).** Fit × the camp focus multiplier is capped at ×1.6 (ESTIMATE). BALANCE also runs on a TOP FIT camp |
| 4 | The morning trap | **Done.** Stranger's −4 applies to evenings only, and a Hard coached morning builds +0.5 bond |
| 5 | Price the free options | **Done.** SHIELD now has a real job (5.1). The coach's request costs +0.5 coach time to grant and −2 bond to refuse (6.4) |
| 6 | The board on Club > People in release 1 | **Done (10.1, M1).** It moves to the Staff app when that app is built |
| 7 | A word beside every red | **Done.** OVER BUDGET and AT RISK always print as text |
| 8 | The three CHECKs | **Still open (15):** I can't read code. Each one now says what changes for either answer |
| 9 | Run the probes | **Not done:** I can't run them. Section 12 has the pass lines, and the build waits for them |
| 10 | Make Trusted felt | **Done (10.2).** The Trusted line lands last on the Monday page, and the new plan line opens on the Game plan with "Write it" |

### v7's own faults
| v7 | v8 |
|---|---|
| Evening stat gains with no NEW tag | Evenings scale drill units (CODE units), with fit as NEW |
| 10.3: C didn't cut the assistant's load; RISKY at 46; morale left out | Rebuilt, with every number shown |
| Raise cost "30–45 members" | About 6 members per $50 raise |
| The 0.50 floor never applied | Removed |
| Two roundings | Always round down |

### Options both critics called useless or near useless
| Option | v8 |
|---|---|
| SHIELD | Now the free base mode: a loss costs every boxer that coach runs −9 morale, not −12 |
| The coach's request | Priced both ways (6.4) |
| Quarrel answers in release 1 | Moved to release 2 |
| Interview "Best fit" line | Moved to the boxer's first Monday page, where it can be acted on |
| A Normal coached morning with a Stranger pair | The Stranger penalty no longer applies to mornings, so it now reads at fit 50 |

### Missing options both critics named
| Option | v8 |
|---|---|
| Drill a step with a chosen coach | The study slot rides the pads cell, so its coach is your choice (3.1) |
| Send the club coach on the Level 2 course | 9.1 |
| Take a boxer yourself for good | Drag the head coach onto cells "For good". The pair starts at Working and costs the head coach's 4 coach time |
| Pay with time | A raise answer: "Give a day off": the rating counts, −1 coach time for good, no cash (4.3) |
| Forgive borrowed time | "Rest next week" on the over-budget need |
| A default line | "Your board this week against the coach's" on Monday |
| Bond from mornings | +0.5 per Hard coached morning |
| Cap on stacking | ×1.6 |

Part 2 of 5

## 1. The idea
- **The coach writes the week, you edit it.** Each boxer's week has five areas, and each area has a coach. The coach writes who runs what along with the sessions and repeats it; you change the exceptions (CODE 4.1).
- **Fit** is how well that coach suits that boxer this week. A good fit means more drill units on evenings and more stat gain on mornings, and less tiredness. A poor fit means the reverse.
- **Coach time** is the limit. Going over borrows from next week, and the corner on fight night costs 3.
- **Bond** grows slowly, mostly on evenings and in the corner. It adds a plan line and a corner the boxer listens to.
- **Coaches grow and ask for raises.** Pay, give a day off, or say no.

## 2. Fit

### 2.1 Formula
**Fit = 50 + temper and mode + coach time + bond + taught out + focus, clamped 10–90.** At 50 a session runs exactly as today.

| Part | Values | Notes |
|---|---|---|
| Temper and mode | −12 to +10 | 5.2 |
| Coach time | 0 up to 0.5 over; −8 over 0.5 up to 1.5; −18 over 1.5 (2 at most) | on every cell that coach runs that week (ESTIMATE) |
| Bond | Stranger −4 (evenings only); Working 0; Trusted +6; Corner +12 | 6.1 |
| Taught out | 0, or −6 within 5 of that coach's ceiling | at or above the ceiling, ×0.5 (4.1) replaces this |
| Focus | +10 on the morning area that trains the FOCUS stat; −3 on the boxer's other coached mornings | mornings only (2.3) |

- **Gain multiplier = 0.5 + fit ÷ 100:** ×0.60 at 10, ×1.00 at 50, ×1.32 at 82.
  - **Evenings:** the multiplier applies to the drill units of every card that evening: 240 a pad night, the sparring night's 180 share, and the step study slot (CODE units).
  - **Mornings:** it applies to the stat gain.
- **Tiredness multiplier = 1.125 − 0.0025 × fit:** ×1.10 at 10, ×1.00 at 50, ×0.92 at 82.
- **Gain chain:** fit multiplies on top of the CODE gain (pace × coach factor × headroom clamp × Light/Normal/Hard, and the units-to-mastery maths). It replaces nothing.
- **Stack cap (NEW, ESTIMATE):** fit × the camp focus multiplier (1.1 / 1.2 / 1.35, CODE) never goes past ×1.6. The hover says "capped".
- **Reachable range:** about 10 to 82.

### 2.2 Fit words (every word printed; colour only backs the word)
| Word | Fit | Gain | Usually means |
|---|---|---|---|
| TOP FIT | 75+ | ×1.25+ | Corner or Trusted bond, a suiting temper, the right mode, on budget |
| GOOD | 58–74 | ×1.08–1.24 | Trusted, or FOCUS on a morning |
| MIXED | 40–57 | ×0.90–1.07 | Working bond, small mismatch, slightly over |
| RISKY | under 40 | under ×0.90 | 2 over, a clash, or near the ceiling |

**Each cell shows** the gain in its real unit:
- evenings: "Jab +2.4 · GOOD", in mastery points from the units;
- mornings: "Speed +0.4 · MIXED".

Hover lists every part and names the ceiling that binds.

### 2.3 One focus
- **FOCUS is one stat per boxer,** set on the pill. The coach's suggestion (the weakest stat with headroom) is outlined, never set for you.
- **In camp the pill is the camp focus,** locked to it. The camp modal's focus list moves onto Attrs names: Stamina, Strength, Accuracy, Defence, Speed (was Conditioning, Power, Technique, Defence, Speed). This is NEW and CHECK (Claude) against what each old focus trains.
- **The signing card's "one starting focus" is renamed "Start with"** (NEW label), so "focus" means one thing.
- **Mode tests read this week's drill cards,** not FOCUS (5.2).

## 3. Areas, coach time and who runs what

### 3.1 Areas
| Area | Sessions (CODE) | What fit scales |
|---|---|---|
| Pads (evening) | Pad nights, with every drill card and the step study slot | drill units into move and step mastery |
| Sparring (evening) | Sparring nights | the 180-unit share over the boxer's cards and plan |
| Conditioning (morning) | Roadwork, Intervals | stat gain: Stamina, Recovery |
| Strength (morning) | Weights, Neck work | stat gain: Strength, Explosiveness, Durability |
| Bag (morning) | Heavy bag, Speed bag, Slip rope, Shadow | stat gain: Speed, Footwork, Accuracy |

- **The morning-to-stat lists are CHECK (Claude),** against what each session trains in the code. The code's list wins.
- **Film** has no coach and no fit. It opens tells (CODE) and costs no coach time.
- **Flexibility, Fight IQ, Composure and Heart** sit in no area, because no session trains them today (CHECK Claude). If one does, it joins that session's area.
- **Steps:** the S463 study slot fills on pad nights (about 6 a week, CODE), so the pads cell's coach and fit set its pace. "Pivot out +7 this week · GOOD" is the line. This ties COACHFIT1 to STEPVALUE1.

**The morning rule**
- **Evenings always have a coach.** The coach's board assigns one. The head coach is always there, so no evening runs uncoached. Today's 60% applies only when the club has no assistant and the head coach is past 2 over.
- **Mornings run at today's factor unless you assign a coach.** Assigning one applies fit and costs coach time: Normal 0.5, Hard 1.0. Light can't take a coach.
- **Uncoached mornings read as fit 50.**
- **Why you'd coach a morning:** FOCUS (+10), a suiting temper (+6), or Hard for bond (+0.5).

### 3.2 Shared nights (NEW)
- **Pad night:** two boxers cost 1.5 instead of 2.0. The 240 units split 60/40, and the player picks who gets the 60.
- **Sparring night:** two of your boxers on the same night cost 2.0 instead of 3.0, and each keeps the full 180 share (they spar each other).
- **Three or more boxers** need two nights.
- **The Coach's pad nights row** (pack 6, R55, AGREED, NOT BUILT) shows the split and what the 40 side loses: "−96 units: about −1 Jab for your 65 kg boxer". CHECK (Claude): whether a shared night already counts per boxer.

### 3.3 Coach time a week (ESTIMATE)
| Coach | Coach time | Corner | Note |
|---|---|---|---|
| Sessional assistant ($450) | 10 | 3 | on budget in any BASE week; tight in camp |
| Full-time assistant ($1,090) | 14 | 3 | a camp plus a corner fits |
| Head coach (you) | 4 | 3 | the office takes the rest |
| Second club coach ($280) | 2 | none | coached conditioning mornings only |
| Promoted club coach ($450) | 8, then 10 at Level 2 | 3 | no sparring nights until Level 2 (9.1) |

**Evening costs:**
- pad night 1.0, or shared 1.5;
- sparring 1.5, or two boxers 2.0;
- film 0;
- corner 3.

**Everyday check** (BASE: 3 pad nights and 1 sparring night a boxer; CHECK Claude that this is the coach's BASE week):

| Week | Cost | Sessional (10) | Full-time (14) |
|---|---|---|---|
| One boxer, BASE | 3.0 + 1.5 = 4.5 | on budget | on budget |
| Two boxers, BASE | 9.0 | on budget, 1 spare | on budget |
| One BUILD (3 pad + 2 spar) and one BASE | 6.0 + 4.5 = 10.5 | 0.5 over, free | on budget |
| One PEAK (3 pad + 2 spar) and one fighting (2 pads + corner) | 6.0 + 5.0 = 11.0 | 1 over, −8 | on budget |

**Rest this week** (coach card): no sessions, bond paused, +3 coach time next week (it wipes any borrowing). The coach's cells go to cover (3.6).

### 3.4 Over budget, one rule
- **Over is allowed, up to 2.** The board refuses a drag past 2 over and says why. The overage comes off next week ("next week 9 of 10").
- **Fit penalty** on every cell that coach runs: 0 up to 0.5 over, −8 over 0.5 up to 1.5, −18 over 1.5.
- **Warnings:** an amber need on Home, "OVER BUDGET: sessional assistant 11 of 10", with a **Rest next week** button, and a Monday line.
- **Nothing is moved for you.**

### 3.5 The corner
- **The fighting boxer's week is cheap:** TAPER means light, three rest days and no sparring (CODE). The corner's 3 competes with the other boxers' BUILD or PEAK evenings.
- **The strip prints the price:** "Corner Saturday: 3 of 10. Your 65 kg boxer's evenings stay with the assistant."

### 3.6 Cover
- **When a coach is away, let go, or gone:** "Assistant off sick" (NEW twist card, a choice card with two answers), a Level 2 course week, or a coach let go or leaving. Their cells go to the other coach or the head coach, at that coach's own fit.
- **The coach's suggestion fills the cells** when the player doesn't.

Part 3 of 5

## 4. Ceilings, growth and raises

### 4.1 Ceilings (NEW; always round down)
| Area kind | Ceiling | Above it |
|---|---|---|
| Morning (stats) | 55 + area rating × 0.35 | that stat's gain ×0.5, never a hard stop |
| Evening (moves and steps) | mastery up to the area rating | that card's units ×0.5, never a hard stop |

- **No rating in an area:** the area uses the coach's overall rating (ESTIMATE).
- **The head coach** uses the best assistant's ceiling in that area, or 60 for moves and 70 for stats with no assistant (ESTIMATE).

| Coach | Code stats | Pads (moves) | Sparring (moves) | Conditioning | Strength and Bag |
|---|---|---|---|---|---|
| Sessional assistant | pads 74, rating 58 | 74 | 58 | 75 | 75 |
| Full-time assistant | pads 58, conditioning 90, rating 74 | 58 | 74 | 86 | 80 |
| Promoted club coach | rating 45 (ESTIMATE) | 45 | none (no sparring until Level 2) | 70 | 70 |

**This is the real choice between the two hires:**
- The sessional assistant takes moves past Sharp on pads.
- The full-time assistant slows on pads above 58, just under Sharp 60, but carries conditioning to 86 and sparring to 74.
- Signature (85) on pads needs a coach grown to 85, or ×0.5 above the ceiling. Never a gate.

**More rules**
- **Near the ceiling:** within 5 of it, the tag "AT THE COACH'S LIMIT IN ABOUT n WEEKS" and −6 fit.
- **Which ceiling binds:** the boxer's potential (CODE headroom) or the coach's ceiling, whichever is lower. The hover names it ("slowed by the coach's limit" or "slowed by potential").
- **Week 1:** boxers sit at 55–65 and most moves are New or Raw, so under 15% of cells should carry the tag (probe TAUGHTOUT1).

### 4.2 Coach growth (NEW)
- **Pace:** +1 to an area rating per 15 coached sessions in that area, or per 25 above 80. Cap 90.
- **Who grows:** growth matters for the sessional assistant, the promoted club coach and the full-time assistant's pads 58. The full-time assistant's conditioning is already at 90.
- **Coach factor stays on the overall rating (CODE),** so the 59/45/41 balance doesn't move. Area ratings set ceilings only.
- **At a glance:** the sessional assistant runs about 6 pad sessions a week for two boxers, so pads +1 about every 2.5 weeks (ESTIMATE).

**Schools:**
- Moves in the coach's school drill ×1.10, and ×1.00 outside it.
- A signature move outside the school drills ×0.5.
- School and mode together top out at ×1.20.

### 4.3 Raises
**Trigger:** every 5 points in **one area**, with at most one ask per coach every 12 weeks. The card shows "next ask at pads 79". No asks once an area reaches 90. A busy assistant asks 3–4 times a year (ESTIMATE, RAISEPROBE1).

**Three answers on the Monday page:**

| Answer | Money | Rating | Coach time |
|---|---|---|---|
| **Pay** | +$50 a week for good | the new rating counts | +1 for good, at most +3 over the base |
| **Give a day off** | none | the new rating counts | −1 for good |
| **Say no** | none | held at the old value | −1 for 4 weeks |

**Refusing again:**
- **A second no within 12 weeks:** −2 coach time for 8 weeks, and the line "Looking for other work: Pay or Let go".
- **A third no:** the coach leaves at the week's end. The club pays 2 weeks' wages, and cover applies (3.6).

**Cost:** a member pays $35 a month, which is $8.08 a week, so a $50 raise is about 6 members' dues. Three or four raises by the year's end come to $150–200 a week, or 19–25 members, and that shows on the Money page.

## 5. Tempers and modes

### 5.1 Tempers
**A mode is set per coach, for the week,** and covers every boxer that coach runs.

| Temper | Who (ESTIMATE) | Mode | Effect | Coach time |
|---|---|---|---|---|
| Motivator | sessional assistant | **SHIELD** (base) | a loss costs −9 morale, not −12, for every boxer that coach runs | 0 |
| | | **LIFT** | Flat and Low boxers +3 morale a week, and a loss −8 for them. Others lose the SHIELD cushion | +0.5 |
| Technician | full-time assistant | **POLISH** | Usable and Sharp cards ×1.15; New and Raw ×0.90 | 0 |
| | | **TEACH** | New and Raw cards ×1.10; Usable and Sharp ×0.95 | 0 |
| Steady hand | promoted club coach | automatic, no toggle | inside 14 days of a bout: tiredness ×0.85, gains ×0.90. Otherwise load-spike injury risk is two thirds of normal | 0 |
| Drill sergeant | release 2 (the pool) | PUSH / EASE | 14 | |

### 5.2 Temper and mode in fit (−12 to +10)
| Part | Value |
|---|---|
| Temper suits | +6. Motivator: morale Flat or Low. Technician: coachability 70+. Steady hand: +2 always |
| Temper clashes | −8. Technician with coachability under 30 |
| Mode right this week | +4. LIFT with a Flat or Low boxer; POLISH when most of the boxer's drill cards this week are Usable or Sharp; TEACH when most are New or Raw |
| Mode wrong | −4. POLISH and TEACH only. SHIELD and LIFT carry no wrong value |

**The forks:**
- **TEACH against POLISH:** with one boxer on Raw cards and one on Sharp cards, TEACH gives +4 to one and −4 to the other. You choose whom to favour.
- **SHIELD against LIFT:** LIFT costs coach time and takes the loss cushion off your Steady boxers to pull up a Flat one.

## 6. Bond (per coach and boxer pair; not the code's Loyalty)

### 6.1 Steps
**How it moves:**
- **+1** per pad, sparring or corner night together, counted for each boxer on a shared night.
- **+0.5** per Hard coached morning.
- **+4** after a bout together.
- **−1** a week with no nights together, shown as hollow pips: "apart".

| Step | Bond | Typical (ESTIMATE) | Fit | Unlocks |
|---|---|---|---|---|
| Stranger | 0 | a new coach | −4 on evenings | none |
| Working | 8 | about week 2; **the head coach starts here** with every boxer the club signs | 0 | none |
| Trusted | 45 | about week 11 | +6 | the boxer's ask; the coach's request; +1 plan line in camp, up to 7 (the code cap is 6, so 7 is NEW) |
| Corner | 110 | about week 26 | +12 | corner bond step 1.10 (8) |

- **Scarcity:** about 4 bond a week per pair, so one coach usually holds 1–2 Trusted pairs (BONDPROBE1).
- **The head coach's bond with each boxer** is tracked the same way (6.1). It's separate from Loyalty.

### 6.2 Swaps
- **This week only:** the old pair's bond is paused, and the cell takes −2 fit that week.
- **For good:** the new pair starts at its own bond; the old pair decays at −1 a week. There's no other penalty.

### 6.3 Asks (Trusted and above)
**The boxer's ask:**
- At most once a week, when the boxer's Trusted coach isn't on an area that coach can run: "Can I do the fight week with my pads coach?"
- **Hear:** +5 morale, a swap for this week only.
- **Overrule:** −5 morale (CODE MORALE_EVENTS; low coachability hurts more, CODE).

**The coach's request:** "Let me take the roadwork this week. I know what's needed."
- **Grant:** +3 fit on that cell, +0.5 coach time.
- **Refuse:** −2 bond with that boxer.

## 7. The head coach
- **Coach factor:** 0.5 + rating × 0.007 (CODE); with no coach, 0.60 (CODE).
- **The head coach has no rating** in the pack. Their sessions run at 0.9 × the best assistant's factor, or 0.60 with none (ESTIMATE). The hover says it: "Your sessions run at nine tenths of your best assistant's: 0.82."
- **Edges as in the code:**
  - Old hand: cuts 120 kcal a day easier.
  - Ex-pro: one tell at booking.
  - Amateur coach: a prospect's exact potential.
  - Strength coach: body mornings +10% and craft −10%, in the head coach's own sessions, which makes the head coach the right pick for Strength mornings.
- **No temper**, so the temper and mode part is 0. Bond starts at Working.
- **School** by edge (9.2).

Part 4 of 5

Two corrections to earlier parts: the coach's request that Part 1 points to is in 6.3, and the Drill sergeant row in 5.1 is held back to release 2 (section 14).

## 8. The corner: word taken in
**Word taken in = morale trust × coachability step × corner bond step, capped at 1.10. Ring general ×1.25 applies after the cap (CODE).** There's no floor: the lowest product is 0.70 × 0.90 × 0.95 = 0.60.

| Part | Values | Tag |
|---|---|---|
| Morale trust | Fired up 1.05 / Steady 1.00 / Flat 0.85 / Low 0.70 | CODE |
| Coachability step | 0.90 + coachability × 0.002 | NEW, ESTIMATE |
| Corner bond step | Stranger 0.95 / Working 1.00 / Trusted 1.05 / Corner 1.10 | NEW, ESTIMATE |

- **The shouts and the two-instructions-a-minute rule are unchanged.** The corner coach changes how much of a shout lands, never which shout.
- **Shown** on Fight prep and in the corner minute: the corner coach's portrait and role, and "Your corner's word taken in: 85%".
- **The cutman** stays a staff job line on pro nights only.

## 9. The staff, schools, Level 2

### 9.1 The staff in release 1: Luke Reid, Marcus Hale and the club coach
| Role | Code stats | Temper (ESTIMATE) | School (5 game moves) | Coach time |
|---|---|---|---|---|
| Sessional assistant | pads 74, rating 58, $450 | Motivator | Jab, Cross, Lead hook, Check hook, 1-2 | 10 |
| Full-time assistant | pads 58, conditioning 90, rating 74, $1,090 | Technician | Body hook, Uppercut, 2-3, 1-2-3, 1-2-3-2 | 14 |
| Second club coach | $280, runs the fitness classes | none | none | 2 |

**The release 1 design pair is one assistant, the promoted club coach and you.** The pack's "Hire Luke / Hire Marcus" reads as one or the other.
- **If the code allows both** (CHECK Claude), the second hire card stays open and the club gets a fourth coach.
- **If not,** nothing in this map breaks: every fork in 10.3 uses one assistant, the head coach and, optionally, the club coach.

**Promote the second club coach** (Club > People, NEW)
- **The change:**
  - The wage rises by $170 to $450.
  - Temper Steady hand, rating 45 (ESTIMATE), coach time 8.
  - School: Jab, 1-1, 1-2, Body hook, 3b-3.
- **What it costs:** the fitness classes stop. That removes the +40 from the members target and stops their income (amount: CHECK Claude).
- **The England Boxing rule, as Level 1 Assistant Coach** (England Boxing Coaching Rules Policy, Feb 2026, from critic John's sources; CHECK John before any screen text):
  - Can run pads, bags, conditioning mornings and the corner.
  - **Can't run sparring nights.** The cell refuses it with the tag "NO SPARRING: LEVEL 1".
- **Send on the Level 2 course** (button, from 52 weeks after promotion):
  - A fee: $600, ESTIMATE, CHECK John.
  - The coach is away 1 week, and cover applies.
  - Then: sparring nights open, +2 coach time (10), and every ceiling +5.
  - It's the club coach's second growth beat.

### 9.2 Head coach school by edge
- Ex-pro: Jab, Cross, Lead hook, Check hook, 1-2.
- Amateur coach: Jab, Cross, Body hook, 1-2, 1-2-3.
- Strength coach: Body hook, Uppercut, 2-3, 1-2-3, 3b-3.
- Old hand: Jab, Lead hook, Check hook, 1-2, 1-6-3.

**On the move bars:** "+10% learning: in the pads coach's school".

### 9.3 The coach pool (release 2)
- Two candidates each month, at most 3 shown, each staying 4 weeks.
- Rating 45–80, rising with reputation; a temper from the four; a school; 1–2 area ratings.
- A wage of $450–1,300 by rating (ESTIMATE); a signing fee of $1,000 (CODE).
- Hire is greyed, with its reason, when it can't be done.

## 10. The weekly decision

### 10.1 "Coaches this week": Club > People in release 1 (moves to the Office Staff app when that app is built); Look B; owner-agreed mockup first
| Zone | Shows | Actions |
|---|---|---|
| Dark top bar (shell) | week, the next bout circled, "Coach time: 9.5 of 10 · 2 of 4 · 8 of 8" | the big CONTINUE only; the board saves as you edit |
| Left: coach cards | name in the card header; portrait and role; temper, and mode as a word with its price; coach time pips with "borrowed 1" in text; ceilings per area; "next +1 pads in 6 sessions"; school chips; wage; a raise sticky when asked; "NO SPARRING: LEVEL 1" on the club coach | mode switch; Rest this week; Pay / Give a day off / Say no; Let go (a week's pay); Promote; Send on the Level 2 course |
| Centre: who runs what | one row per boxer: portrait, class in kg, record, FOCUS pill (locked in camp; the coach's suggestion outlined). Five area cells, each with the coach magnet, fit word and bar, gain in its unit ("Jab +2.4" or "Speed +0.4"), bond pips, at most one tag in words. The Coach's pad nights row on top when two boxers are in camp | drag a coach onto a cell (This week / For good); set FOCUS; leave a morning uncoached; pick the 60 side |
| Right: on Monday | each boxer's FOCUS stat now and after the week; bonds crossing a step; next week's coach time; risks in red with their word; "Your board this week: +0.3 Speed, +2 Jab over the coach's"; one gold frame on the week's best gain | none |
| Fight week strip (a bout within 14 days) | corner magnets: word taken in, coach time cost, bond step, what moves to cover it; the cutman line on pro nights | pick the corner |

### 10.2 The Monday page (the week review; never a pop-up)
- "Jab 41 to 47: good fit with the pads coach."
- "Speed 62 to 63: FOCUS morning with the head coach."
- "Next week: 9 of 10 coach time (1 borrowed)."
- "The pads coach asks for $50 a week. Pay / Give a day off / Say no."
- "Your board this week: +0.3 Speed, +2 Jab over the coach's."
- "Your 65 kg boxer's Jab is near the pads coach's limit: about 5 weeks."
- First Monday after a signing: "Best fit for your new boxer: the pads coach." (moved from the Interview)
- **Last line, when it happens:** "Trusted with your 60 kg boxer: one more plan line in camp. Write it" (it opens the Game plan).

### 10.3 A worked bout week (week 12; the sessional assistant and the head coach with the Strength coach edge)
**The roster**
- **Your 60 kg boxer fights Saturday.** TAPER: 2 light pad nights, no sparring. Morale Flat (47, ESTIMATE), coachability 52. Trusted with the assistant, Working with the head coach.
- **Your 65 kg boxer is in PEAK:** 3 pad nights and 2 sparring nights. Morale Steady, Trusted with the assistant.

**The coach's default** (everything on the assistant, nothing shared): 2.0 + 3.0 + 3.0 + corner 3.0 = **11.0 of 10**, 1 over.

**The 65 kg boxer's pads cell:**
- On budget it's fit 56: Trusted +6, SHIELD 0, no suit. That's MIXED, gain ×1.06.
- At 1 over it's 48: still MIXED, ×0.98.

**Word taken in:**
- With the assistant: 0.85 × 1.004 × 1.05 = **90%**.
- With the head coach: 0.85 × 1.004 × 1.00 = **85%**.

| Answer | Assistant | Head coach | What changes (ESTIMATE) |
|---|---|---|---|
| **A. Leave it** | 11 of 10, −8 fit on all its cells | 0 of 4 | The 65 kg boxer's 1,080 units (720 pads + 360 sparring) drop from ×1.06 to ×0.98: −86 units, about −1 mastery point. Next week starts at 9 of 10, still in PEAK. Word taken in 90% |
| **B. Share two pad nights, the 65 kg boxer takes the 60** | 1.5 + 1.5 + 1.0 + 3.0 + 3.0 = 10.0 of 10 | 0 of 4 | On budget, but the 65 kg boxer gets 144 instead of 240 on two nights: −192 units, ×1.06 = about −204. The 60 kg boxer gets 96 instead of 240 on two light nights. **The worst answer in PEAK** |
| **C. The head coach takes the 60 kg boxer's two pad nights; the assistant corners** | 9.0 of 10 | 2.0 of 4 | 65 kg on budget at fit 56. The 60 kg boxer's two light nights run at 0.9 × the assistant's factor: about −10% of those units. The Trusted pair misses 2 bond. Word taken in 90% |
| **D. The head coach corners** | 8.0 of 10 | 3.0 of 4 | 65 kg on budget. The 60 kg boxer keeps the assistant on pads. Word taken in 85% |

**Add LIFT (+0.5):**
- **C plus LIFT** is 9.5 of 10. The Flat boxer gets +3 morale by Saturday: 47 to 50, which is Steady. LIFT is the right mode for that boxer (+4 fit on the assistant's cells for the 60 kg boxer only). Word taken in 1.00 × 1.004 × 1.05 = **105%**. The 65 kg boxer loses the SHIELD loss cushion, which costs nothing in a week with no bout.
- **D plus LIFT:** 1.00 × 1.004 × 1.00 = **100%**.

**The answer:** C plus LIFT. A is the borrowing trap, because next week's PEAK starts short. B shows that sharing costs most in a camp. D is right when the head coach has the stronger bond.

Part 5 of 5

One correction to 10.3: a mode covers every boxer that coach runs, **corner included**. Under C the assistant runs none of the 60 kg boxer's sessions, so LIFT gives that boxer the +3 morale through the corner but no +4 fit. The sums and the 105% stand.

## 11. Every menu it appears on, and what each is wired to (S425)
| # | Menu | What COACHFIT1 shows | Player actions | Wired to today (CODE) | New wiring (NEW) |
|---|---|---|---|---|---|
| M1 | Club > People, "Coaches this week" (release 1); Office Staff app later | 10.1 in full | assign, swap, FOCUS, mode, rest, corner, raise answers, let go, promote, Level 2 | StaffRoles.gd; Club > People | CoachFit.fit, CoachTime, Bond, StaffBoard |
| M2 | Office Desktop, staff panel | coach time per coach; raise and over-budget needs | opens M1 | Desktop (S451) | CoachTime.week |
| M3 | Home > needs | OVER BUDGET (amber, with Rest next week); raise (amber); coach off sick (amber) | Rest next week; open M1 or the choice | Needs.gd | Needs: over_budget, raise, cover |
| M4 | Home > THE CLUB THIS WEEK | "Coaches: 9.5 of 10 coach time" | opens M1 | HomeRows.gd | CoachTime.summary |
| M5 | Fighter > Week | each card shows the coach face, fit word and gain in its unit; the popover adds "Who runs it" and "Uncoached" for mornings; FOCUS pill; Coach's pad nights row with the 60/40 pick | change the coach; FOCUS; pick the 60 side | WeekBoard.gd; PadWeek; WeekPlan.day | CoachFit on cards; PadWeek.split |
| M6 | Fighter > Overview, WHAT TO LEARN NEXT | the step study slot shows the pads coach and fit: "Pivot out +7 a week · GOOD" | open M5 | StepMastery (S463) | CoachFit.units |
| M7 | Fighter > Overview, attributes and COACH SAYS | the binding ceiling on hover; "Trusted with the pads coach" | none (you act on it in M5) | FighterPage.gd | Bond.step; CoachFit.ceiling |
| M8 | Fighter > Playbook > Moves, Combos | "+10% learning: in the pads coach's school"; "at the coach's limit" tag | none | Mastery | Schools.bonus; CoachFit.ceiling |
| M9 | Fighter > Playbook > Game plan | "Lines 7 of 7: +1 from a Trusted coach" | Write it | PlanBoard line count | Bond.extra_line (cap 7) |
| M10 | Camp modal | focus list on Attrs names; "FOCUS locks to this" | pick focus | Camp | CampFocus.attrs |
| M11 | Interview / Trial | "Start with" in place of "one starting focus" | the same three picks | Interview modal | label only |
| M12 | Fighter > Fight prep | corner pick with word taken in and coach time | pick the corner | FightPrep.gd | Corner.assign |
| M13 | Fight night: tale of the tape and corner minute | corner coach portrait and role; "word taken in 90%" | none new | BoutNight; trust | Corner.trust_step |
| M14 | Result > the Why | "Corner: word taken in 90%"; "Fit: Jab +6 over the camp" | none | WhyCard.gd | CoachFit.why_line |
| M15 | Week review (the Monday page) | the 10.2 lines | Pay / Give a day off / Say no; Hear / Overrule; Grant / Refuse; Write it | WeekReview.gd | CoachFit.review |
| M16 | Club > Money | raises, promotion wage, Level 2 fee, severance | none new | c.pay; GymBills | Raise.bill |
| M17 | Club > Records | coach joined, raise answered, Level 2 passed, coach left | filter | Records log | Records.add |
| M18 | Fighters > Roster cards | corner flag "Ask" when the boxer's ask waits | opens M15 | RosterCards.gd | Needs.ask |
| M19 | Week > twist card | "Assistant off sick": cover by the other coach / the head coach | pick | Twist cards | Twist.coach_off |
| M20 | Top bar | no new flag; needs reach it through NEEDS YOU | none | Shell flags | none |
| M21 | World > News | nothing | none | none | none |
| M22 | No-gi athlete page | unchanged ("who teaches" stays) | none | NoGi.gd | none |

## 12. Probes (headless, before build; none run)
| Probe | Pass line |
|---|---|
| FITPROBE1 | TOP against average fit (50): FOCUS stat +3 to +5 over 26 weeks; a drilled move reaches Sharp 2–4 weeks sooner |
| TRAINBALANCE | a season of TOP fit against average moves bout wins by +4 to +8 in 100, under the plan's +14 (59 against 45), headroom clamp on |
| BALANCE | an average Steady boxer with a Working corner keeps 59 / 45 / 41; a TOP FIT camp stays inside the stack cap ×1.6 |
| BOTSUITE | the best hand board beats the coach's board by 2–5 wins in 100 a season; no single board wins in 60%+ of clubs |
| COACHTIMEPROBE | one or two boxers with the sessional assistant: on budget in every BASE week; over in 30–60% of camp or bout weeks; full-time assistant over in under 20% |
| MORNINGPROBE | a coached morning is the better pick in 20–50% of mornings |
| BONDPROBE1 | Working by week 2–3; first Trusted by week 9–14; at most 2 Trusted pairs per coach in 80% of runs |
| RAISEPROBE1 | 3–4 asks a year for a busy assistant; paying beats saying no on wins in 100 per $1,000 over a season |
| MODEPROBE1 | SHIELD and LIFT, POLISH and TEACH: each mode best in 30–70% of weeks |
| TAUGHTOUT1 | under 15% of cells tagged in week 1 |
| CORNERPROBE1 | Trusted against Stranger corner: measured win change; if under 1 in 100, the strip shows coach time first |

## 13. Build (each file under 500 lines, test red first; nothing builds before fresh critics score 6+ / 6+, the probes pass, and the owner OKs an M1 mockup)
| # | Task | Test red first |
|---|---|---|
| C1 | COACHDATA1: tempers, schools, area ratings, ceilings, coach time | the full-time assistant's pads ceiling is 58 |
| C2 | COACHFIT1: fit, unit and stat multipliers, tiredness, stack cap | fit 50 equals today exactly |
| C3 | ASSIGN1: who runs each area, written with the week; uncoached mornings | the coach's board fills every evening |
| C4 | COACHTIME1: costs, borrowing at most 2, rest | 11 of 10 gives next week 9 |
| C5 | SHARED1: shared pad and sparring nights | two boxers on one pad night cost 1.5 |
| C6 | BOND1: steps, decay, mornings, swaps, head coach at Working, +1 line to 7 | a new signing reads Working with the head coach |
| C7 | CORNER1: word taken in | Flat, coachability 52, Trusted reads 0.896 |
| C8 | MODES1: Motivator, Technician, Steady hand | SHIELD makes a loss −9 |
| C9 | GROWTH1: growth, raises, three answers, refusals, leaving | Give a day off sets −1 coach time for good |
| C10 | ASKS1: the boxer's ask; the coach's request, priced | refusing the request costs −2 bond |
| C11 | PROMOTE1 and LEVEL2: no sparring at Level 1, the course | a Level 1 club coach can't take a sparring cell |
| C12 | FOCUS1: one focus; camp list on Attrs; "Start with" label | in camp the pill equals the camp focus |
| C13 | STAFFBOARD1 (M1 on Club > People) | board = CoachFit |
| C14 | COACHSHOW1 (M2–M19) | each menu shows its line |
| C15 | COACHGOLDEN1: the 10.3 week, answer C plus LIFT, then the Monday lines | red until C1–C14 |

## 14. Held back
- **Release 2:** the coach pool; the Drill sergeant with PUSH / EASE and quarrels (the quarrel need, tag and three answers).
- **Coach runs it:** AGREED, NOT BUILT; not shown.
- **Not built:** carrying bond across coaches; no-gi coaches on the board; rival gyms poaching coaches; a top-bar flag; coach lines in News; Copy last week; Lock cell.
- **Coaching Film, and areas for Flexibility, Fight IQ, Composure and Heart:** waiting until a session trains them.

## 15. Open questions
**CHECK (Claude)**
- **Can both assistants be hired together?** If yes, a fourth coach. If no, release 1 is as designed.
- **Which rating does WeekPlan read for a pad session?** If pads, growth in pads also lifts the factor, so BALANCE reruns. If overall, the map stands.
- **Does a shared night already count per boxer?** If yes, SHARED1 shrinks to the 60/40 pick.
- **The morning-to-stat lists against Attrs.gd,** and whether any session trains Flexibility, Fight IQ, Composure or Heart.
- **Is the coach's BASE week 3 pad nights plus 1 sparring night?**
- **The fitness class income.**

**CHECK (John)**
- England Boxing Level 2: the fee, the length, and the 52-week rule as policy text.
- Real sessional pay rises, to set the $50.

**Owner**
- May a coach refused three times leave?
- The plan cap of 7 with a Trusted coach.
- Rename the camp focus list to Attrs names.
- OK an M1 mockup on Club > People.

## 16. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6** (mine, not a critic's).

**To reach 10/10:**
1. Run FITPROBE1, TRAINBALANCE, BOTSUITE, COACHTIMEPROBE and BALANCE, and put the measured numbers in place of the ESTIMATEs in 2.1, 3.3, 6.1 and 8.
2. Claude's CHECKs, first both assistants and the rating WeekPlan reads.
3. Draw M1 at 1920×1080 in two states, a quiet BASE week and the 10.3 bout week, for the owner's OK.
4. The owner's four answers.
5. John checks the Level 2 rule and fee.
6. Release 2: the pool and the Drill sergeant, with MODEPROBE1 passing.
