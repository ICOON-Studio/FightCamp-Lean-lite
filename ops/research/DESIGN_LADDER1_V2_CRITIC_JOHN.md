# LADDER1_V2 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN_LADDER1_V2_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ169)

Brief: research/DESIGN_LADDER1_V2_REVISE_KALLI.md
Sent: 2026-11-15 10:10 | collected: 2026-11-15 10:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing LADDER1 v2 in full now. It moves to opponent-based (Elo) reputation, seeds and drains the top of the ladder, merges the two refusal words into one, and answers every point from John and Dola.

# LADDER1 v2: the season ladder, with reputation as the currency (S459, S475, S477, 2026-11-15)

Part 1 of 4

This is a full map. It replaces v1 (seat SQ153), and nothing outside this page stands.

**What decides this version:**
- John's critic (SQ161): depth 5, general design 5, play 6. Fails.
- Dola's critic (SQ162): depth 7, general design 8, play 7. Passes.

v2 takes John's core fix:
- Reputation is paid by **who you beat**, compared with what the ladder expected, not by the shown chance.
- The top of the ladder is **seeded and drained**.
- The two refusal words become one.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board, the mockups, John's full research file and the owner's S475 sparring note. The owner's computer is offline. This map is checked against the critic pack, Claude's S477 code facts, John's research summary and the two critics.

**Owner rules kept, quoted**
- **S475:** the ladder "must reach 9/10: see the ladder, find an opponent, book", with REPUTATION as the currency, not fixed win counts.
- **S428 and S425:** amateur to the first pro fight; ONE regional ladder first; every fight shows the rank earned; wired and shown on the correct menus. The living world comes after the fight week is built and played.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Names in ladder rows go to the owner (owner question 5).
- **S412:** any gym, any boxers, men or women. No fixed he or she.
- **Pack 4.5, agreed:** "a 'no' is a closed panel or an absent answer with its reason, never a random refusal".
- **Pack 7:**
  - only actionable information;
  - one word per concept;
  - nothing opens by itself;
  - screens only from agreed mockups, so the page waits for the owner's OK (owner question 2).
- **Pack 1:** "the better-trained fighter usually wins; a good plan turns close fights". The currency must reward both (1.1).
- Classes in kg: women 57/60/65/75, men 57.5/60/70/75. The women's 70 kg class (K_WOMEN70) gets its own ladder when it lands. Females never fight males: one ladder per sex and class.
- "Gym" is the facility. Amateurs have a fight week, not a camp.

**Marks**
- **REAL:** a real rule or source, as John reported it.
- **CODE:** in the code today (S477).
- **DERIVED:** worked from this map's formulas.
- **GAME VALUE:** a fixed design number, not tuned.
- **ESTIMATE:** ours, gated by the probes in 6. Every reputation number is ESTIMATE.
- **NEW:** a rule this map adds. **CHECK:** someone must confirm. **v2:** later.

**One word per concept**
- **Reputation** (0–100, never below 0): a boxer's own currency.
- **Standing:** the gym's reputation (CODE `Career`), renamed (owner question 1).
- **Ladder:** the regional table for one sex and one class (CODE `Region.gd`), sorted by reputation. **Place** is a position on it.
- **Ask:** your boxer asks for a named opponent. **Offer:** a bout that comes to you (CODE). **Challenge:** an offer from a ladder boxer below yours.
- **Chance:** the win chance shown at booking (CODE band). **Expected:** what the ladder expects from the two reputations (1.1). The two are kept apart on purpose.

## 0. Every critic point answered

### 0.1 John (SQ161): To reach 10/10
| # | John's point | v2 |
|---|---|---|
| 1 | Pay by opponent (Elo), not by odds; drop the anti-grind table and the scalp; chance shown for information | **Done (1.1).** Elo with a width of 25, as John wrote it. The win and loss sizes are 16, not 12, so a climb fits the season (ESTIMATE). The anti-grind table, the places-below rules and the scalp are gone. Chance stays on screen. Probes 1, 2 and 9 re-run (6) |
| 2 | Seed and drain the top | **Done (1.3).** Rivals are seeded from their record, so the top 5 sit about 40–65. A rival at 55+ for 8 weeks turns pro and leaves. This is a counted rule, not a roll: the row shows "Pro talk: 3 weeks". A new rival enters each quarter |
| 3 | Merge the two gates into NOT ENOUGH IN IT at 10 + reputation ÷ 5 | **Done (3).** Reach in places is dropped |
| 4 | Make defending real: passing costs, accepting pays Elo | **Done (2.2)**, with a flat −2 for a pass instead of half the loss. Half the loss (−4 to −6) made accepting always right, which is no choice either. Now pass and accept each win in a band of cases (probe 11) |
| 5 | Fix the clock; mark RESTING NEW, or let asks through after 30 days | **Done (1.2).** A booked bout, a suspension and the 8-week rest all stop the clock. Asks open after the 30-day suspension, with the earliest date 8 weeks after the stoppage. RESTING is marked NEW: it mirrors the code's offer rule |
| 6 | Leave pros alone | **Done (2.5).** Starting pro fans stay at today's count (CHECK 4). Reputation shows only on the Pro offer's ticket line (CHECK 5) |
| 7 | Small fixes | **All done.** The split cell is gone with the new table, and majority wins are in it. Reputation floors at 0, and the seed takes the larger of 0 and its result. The draw is the Elo draw (16 × (0.5 − expected)), with no win weight. The short-notice +2 is cut. There's a clubmate rule. Pass lines 1 and 2 are rewritten as given, and the bots write plans. "Tickets she sells" is CHECK 6 for Claude: it's code text and I don't edit code |
| 8 | Rematch, coach's pick, rival file on the card | **All three done (4.3)** |
| 9 | Ask the owner the names question with the drawn page | **Owner question 5** |
| 10 | Run BASE0 and the probes, then draw | **Not done here:** I design and don't run code. They're first in the build order (7), and the page is drawn in the next board session |

### 0.2 John's missing options
| Option | v2 |
|---|---|
| Rematch | Done: an ask on a boxer who beat yours, at most twice a season against one opponent |
| The opponent's file on the card | Done: WHAT WE KNOW, from the rival file |
| The coach's pick | Done: a star on one YES row, with its reason |
| Clubmate rule | Done: never offered, never asked, word CLUBMATE |
| Stay amateur at 55 | Done (2.5): "Stay amateur: keep climbing; the offer returns at reputation 65" |

### 0.3 Dola (SQ162): To reach 10/10
| # | Dola's point | v2 |
|---|---|---|
| 1 | Run probes, freeze numbers; answer the owner questions | **Not done here** (I don't run code), but first in the build order. The owner questions are 1–5 in 8. Her "SAFE needs 50+ bouts" line is replaced by the Elo grind line (6, line 9) |
| 2a | A harsher inactivity rule | **Done (1.2):** −1 every 2 free weeks after 8, counted only on free weeks. A separate place drop isn't needed, because places follow reputation |
| 2b | Show the gap as reputation and wins | **Done (3):** "Needs 6 more: about one win above you" |
| 2c | One unlock per band (tournaments at 30, eliminators at 45) | **Not done:** neither exists, and eliminators are out of scope (S428). The bands are milestones on the week review and in Records, and "1st, nobody above" has its own line (4.3) |
| 2d | Defending matters: swap places, +2 defence bonus | **Done through Elo (2.2):** a win changes both boxers' reputation, so places swap by themselves. A passed challenge costs −2 |
| 3a | Integrate the S475 sparring note | **Not done:** the note is on the offline computer. The stub stays and is marked CHECK (2.5) |
| 3b | One-line rival tags | **Done (4.3):** the row keeps the style word (CODE). The card's WHAT WE KNOW lists found habits ("slow starter"). Hidden ones stay hidden until tape finds them (pack 4.6) |
| 3c | Decline memory | **Done (2.2):** a challenger passed twice sends no challenge for 8 weeks |

### 0.4 Dola's other gaps and missing options
| Point | v2 |
|---|---|
| Inactivity too soft | 2a above |
| The same rival forever | At most twice a season against one opponent; a third gives the word TWICE THIS SEASON |
| How far the gap is | 2b above |
| Table size | CHECK 1 |
| The ladder feels optional | The coach's star makes the best ask one click. Offers still arrive (CODE), so a quiet player isn't forced |
| No mid-season rewards | 2c above |
| No rival personality | 3b above. Fuller rivalries come with the living world (S428) |
| Drop a class or pause | v2: whether a boxer can change class in code is NOT ESTABLISHED (CHECK 7) |
| Filter by style or stance | Every column sorts (style and stance included). That's one control, not more filters |
| Who fights on which dates | The card's date line and the BOOKED word show the opponent's dates |
| A target opponent | Done: **Pin as target** on the card, shown on Overview's NEXT STEP |
| Mobile layout | Not done: PC only (pack 1) |

Part 2 of 4

## 1. Reputation: how it's earned

### 1.1 Paid by who you beat (NEW, the Elo method John cites; all numbers ESTIMATE)

$$ \text{expected} = \frac{1}{1 + 10^{(\text{opp} - \text{you})/25}} $$

- **Win:** 16 × (1 − expected) × the win weight.
- **Points loss:** −16 × expected. **Stopped:** a further −2.
- **Draw:** 16 × (0.5 − expected), with no win weight.
- **Rounding:** to the nearest whole number. **Floor:** 0.

**Win weights.** These are John's BoxRec ratios (REAL), rescaled so a unanimous win is 1 (GAME VALUE):

| Win | Weight |
|---|---|
| Stoppage | 1.15 |
| Unanimous | 1.0 |
| Majority | 0.65 |
| Split | 0.5 |

**What one bout pays** (DERIVED from the formula). "Gap" is the opponent's reputation minus yours:

| Gap | Expected | Stoppage win | Unanimous | Majority | Split | Draw | Points loss | Stopped |
|---|---|---|---|---|---|---|---|---|
| −20 | 86% | +3 | +2 | +1 | +1 | −6 | −14 | −16 |
| −10 | 72% | +5 | +5 | +3 | +2 | −4 | −11 | −13 |
| 0 | 50% | +9 | +8 | +5 | +4 | 0 | −8 | −10 |
| +10 | 28% | +13 | +11 | +7 | +6 | +4 | −5 | −7 |
| +20 | 14% | +16 | +14 | +9 | +7 | +6 | −2 | −4 |

**Why this beats v1 (DERIVED).** At weight 1, a bout's average gain is

$$ 16 \times (\text{real chance} - \text{expected}) $$

So reputation grows only where your boxer is **better than the ladder thinks**. That has three effects:
- **Training pays everywhere.** It lifts the real chance against every opponent, while expected moves only as reputation moves. This answers John's "reputation taxes training".
- **The plan pays.** The shown chance excludes the plan (CHECK 2), so a plan that beats an opponent's style is value the player can see and the ladder can't.
- **The grind dies by arithmetic.** At a gap of −40, expected is 97.5%, so even a sure win pays about +0.4, and one loss costs 16. No anti-grind table is needed.

**The strategy table, redone** (DERIVED; "real" is a probe figure, not a promise):

| Road | Real chance vs expected | Average per bout | The catch |
|---|---|---|---|
| Far below (gap −40) | 99% vs 97.5% | +0.2 | One loss costs 16; stalls |
| Safe below (gap −20) | 90% vs 86% | +0.6 | Slow; a loss costs 14 |
| Even, with a training edge | 60% vs 50% | +1.6 | Steady |
| Above, plan beats their style (gap +20) | 35% vs 14% | +3.4 | Stoppage risk; needs the plan and the tape |
| Sitting free 8+ weeks | — | −1 every 2 weeks | Falls |

The best road is where the edge is largest, and finding it is the scouting and Playbook game. That's the depth.

### 1.2 The clock (NEW)
- A week is **free** when the boxer has no booked bout, isn't suspended, isn't inside the 8-week rest after a stoppage (CODE `STOP_REST_WEEKS`), and isn't injured (CODE).
- After 8 free weeks in a row: −1 reputation every 2 free weeks. Booking a bout resets the count.
- **RESTING (NEW):** asks open once the 30-day suspension ends (CODE). The earliest date offered is 8 weeks after the stoppage, the same as the code's rule for offers. The Ask button reads "Ask: from 12 Apr".

### 1.3 Seeding, draining and entry (NEW, ESTIMATE)
- **Seed for rivals:** the larger of 0 and (8 + 4 × net wins + 1 × bouts), capped at 65.

  | Record | Seed |
  |---|---|
  | 8-2 | 42 |
  | 5-2 | 23 |
  | 16-4 | capped at 65 |

  Probe 8 checks that the top 5 land at about 40–65.
- **Seed for your gym's boxers:** walk-ins start at 0. Signed prospects use the same formula, capped at 30 (a signing doesn't skip the road).
- **Rivals move by the same formula** when they box each other at shows (CODE results). The ladder lives without your boxer in it.
- **Drain:** a rival who holds 55+ for 8 weeks turns pro and leaves. The countdown is counted, not rolled, and the row shows **Pro talk: n weeks**. A rival with no bout for 52 weeks also leaves.
- **Entry:** on the first Monday of each quarter, one new rival enters each ladder from the opponent pool (CODE rows), at their seed.
- **1st place never stalls:** the top keeps being refilled by seeding, and entry and drain keep it moving (probe 8).

### 1.4 One-offs (ESTIMATE)
| Result | Reputation |
|---|---|
| Regional stage won | +5 |
| National title | +10 |
| Headline win at a hosted show | +3 |

The short-notice +2 is cut.

## 2. Answers and offers

### 2.1 The ask (CODE `AskAnswer`, made deterministic)
An ask gets **YES** only when every row of the refusal table (3) passes. Otherwise it gets the word and its reason. Nothing is rolled.

A YES offers the date printed on the button: the opponent's first free show date that's at least 2 weeks ahead (CODE `CAMP_WEEKS` 2).

### 2.2 Challenges and defending (NEW)
- When your boxer is free, a ladder boxer 1–15 below may send a **challenge** through the normal offer list, at most one every 4 weeks.
- **Accept:** the bout is booked and pays by 1.1.
- **Pass:** −2 reputation, with the reason shown on the offer: "Passing costs 2".
- **Memory:** a challenger passed twice sends no challenge for 8 weeks. The offer row says so: "No more challenges from this boxer until 3 May".

Worked case at a gap of −10, where accepting pays +5 or costs −11 (DERIVED):

| Real chance | Accepting averages | Better choice |
|---|---|---|
| 80% | +1.8 | Accept |
| 55% | −2.2 | Pass (−2), unless a weight cut or fight week already blocks it |

### 2.3 Clubmates (NEW)
Two boxers from one gym are never offered against each other and never asked. The word is **CLUBMATE**.

### 2.4 The rematch (NEW)
- After a loss, the card on the boxer who won offers **Ask for a rematch**.
- One opponent at most twice a season. A third ask gives **TWICE THIS SEASON** (opens 1 Jan, CHECK 3).
- A rematch pays by 1.1, the same as any bout.

### 2.5 Pros, and staying amateur
- **Pro offer** at 55 (CODE `ProGate`, which replaces the win count). The modal's buttons:
  - **Turn pro:** starting pro fans stay at today's count (CHECK 4). Reputation appears only on the ticket line: "Ticket draw: Contender" (CHECK 5).
  - **Stay amateur:** "Stay amateur: keep climbing; the offer returns at reputation 65". The regional stage (+5) and the national title (+10) remain.
- **Sparring (S475):** the owner's note wasn't readable this pass (CHECK 8). The stub: WHAT WE KNOW names the opponent's stance and style, and the sparring screen already lists partners by stance (CODE). Nothing more is drawn until the note is read.

Part 3 of 4

## 3. The refusal table: every "no" has a word and a way to a yes

The gap line is 10 + your reputation ÷ 5, rounded down:

| Your reputation | The opponent may be at most this far above |
|---|---|
| 0 | 10 |
| 30 | 16 |
| 55 | 21 |

| Word | When | Line under it | To get a yes |
|---|---|---|---|
| **NOT ENOUGH IN IT** | Opponent above your gap line | "Needs 6 more: about one win above you" | Win; or host a show (owner question 3: a hosted show headliner may ask up to 15 beyond the line) |
| **BOOKED** | Opponent has a bout before the earliest date | "Booked until 22 Mar" | Wait. The date shows |
| **RESTING** (NEW) | Inside the 8-week rest after a stoppage, either boxer | "From 12 Apr" | Wait |
| **TWICE THIS SEASON** | Third ask of one opponent | "Opens 1 Jan" | Wait |
| **CLUBMATE** | Same gym | "Clubmates don't box each other" | None |
| **WRONG CLASS** | Over the limit at the weigh-in date | "Needs 2.1 kg off by Fri" | Fight week, Train through (CLUBWEEK1) |
| **CAP REACHED** | Season bout cap (CODE 18) | "Cap: 18 of 18" | Next season |

Each word is a closed panel with its reason, never a random refusal (pack 4.5). The table replaces v1's OUT OF REACH and its places rule. The gap line shows the value as reputation and as about how many wins: one win ≈ the unanimous win at a gap of 0 (+8).

## 4. The page: LADDER (screen waits for owner question 2)

### 4.1 Where it sits
The **LADDER** tab sits inside the fighter area of ShellChrome, beside Overview and Training (CODE tabs). It opens only when clicked (pack 7). Every column sorts.

### 4.2 The table (one row per boxer in that sex and class)
- **Columns:**
  - place;
  - name cell (owner question 5);
  - club;
  - record;
  - stance;
  - style word;
  - reputation number with its band word (owner question 4);
  - **Win / Loss** (the 1.1 values against your boxer: "+11 / −5");
  - **Chance** (the CODE band, or "Unknown" without tape);
  - the answer word.
- **Your boxer's row:** slate highlight. **Pro talk:** a short tag on the row.
- **The coach's star:** a star on one YES row only. It goes on the largest of chance minus expected among YES rows, using the shown chance. Hover reads "Best value: 60% chance, the ladder expects 40%".
- **Gold:** the selected row's Ask button only (kit: gold on one thing per frame).

**Bands**
| Reputation | Band |
|---|---|
| 0–14 | Unknown |
| 15–29 | Known locally |
| 30–44 | Rated |
| 45–54 | Contender |
| 55+ | Pro-ready |

Each band reached is a line on the week review and in Records. It unlocks nothing (0.3, 2c).

### 4.3 The card (on row click)
- Header: the opponent's name and portrait (S448: the name only here).
- **WIN / LOSS:** each outcome with its value. Hover breaks it down: "Expected 28%, win weight 1.0, 16 × 0.72 = +11".
- **WHAT WE KNOW:** found habits from the rival file (CODE), e.g. "slow starter, drops the right after the jab". Without tape: "No tape yet". Style and stance always show.
- **Dates:** the opponent's booked dates and first free date.
- **Buttons:**
  - **Ask: 29 Mar** (gold);
  - **Ask for a rematch** (only after a loss);
  - **Pin as target**: Overview's NEXT STEP then reads "Target: 3rd place, free from 28 Mar", and only one boxer can be pinned.
- **1st, nobody above:** "Top of the ladder. New entry 1 Apr; regional stage +5."

### 4.4 Where reputation shows elsewhere (one word: reputation)
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter Overview | Number and band, NEXT STEP target, clock line "Free 9 weeks: −1 every 2" | `RepLedger`, `Ladder.pin` |
| LADDER tab | Table and card (4.2–4.3) | `Ladder`, `RepRules`, `AskAnswer` |
| Offers list | Win / Loss on each offer, challenge rows with "Passing costs 2" | `RepRules`, `Challenge` |
| Booking confirm | Win / Loss and chance | `RepRules` |
| Fight result | "+11 reputation, now 3rd" (S428: every fight shows the rank earned) | `RepLedger`, `Ladder` |
| Week review | Changes, bands reached, Pro talk departures, new entry | `RepLedger`, `Ladder.drain/entry` |
| Pro offer modal | Turn pro / Stay amateur, ticket line | `ProGate` (CHECK 5, 6) |
| Records | Band milestones | `RepLedger` |
| World > Rankings | Unchanged (CODE); the precedent for owner question 5 | none |

## 5. The decisions this creates
1. **Who to ask:** where your edge over expected is largest, with the star as the quiet default.
2. **When to ask up:** after tape and a plan that beats that style.
3. **Accept or pass** a challenge.
4. **Keep active or rest:** the clock against the stoppage risk.
5. **Turn pro or stay amateur** at 55.
6. **Rematch** or move on.
7. **Pin a target** and plan the weeks toward the date.

Part 4 of 4

## 6. Probes (headless; Claude builds and runs; numbers freeze only on a pass)

**The bots.** Every bot writes a plan:
- PLAN writes the best-rated lines from Playbook's "Rate against" for the opponent's style.
- The other bots use the assistant's default plan (CODE).

**The other bots:**
- **SAFE:** the highest-chance YES row.
- **ASKUP:** the highest-reputation YES row.
- **COACH:** the starred row.
- **WAIT:** offers only.
- **GRIND:** only opponents 20+ below.

**Pass lines** (each over 200 seeds of 2 seasons; **BASE0** is the code's current pro-offer pace):

| # | Line |
|---|---|
| 1 | PLAN reaches 55 fastest. COACH within 10% of the best non-PLAN bot. SAFE and ASKUP each 15%+ slower than COACH |
| 2 | PLAN 10–25% faster than COACH |
| 3 | COACH's time to 55 within ±25% of BASE0 |
| 4 | ASKUP takes 1.5× or more SAFE's stoppage losses |
| 5 | WAIT leaves the top 3 within 16 free weeks in 60%+ of seeds |
| 6 | An ask by COACH beats the best offer that week by 1.5+ reputation a bout on average |
| 7 | 70%+ of refusals become a yes within 8 weeks |
| 8 | Top 5 at week 52 sit between 40 and 75; never 3+ rivals above 55 for more than 8 weeks |
| 9 | GRIND reaches 55 in 0 seeds |
| 10 | Hover parts sum to the shown value in every case |
| 11 | Pass and accept are each the better choice in 30–70% of challenges |
| 12 | A boxer +5 on stats over rivals reaches 55 at least 25% faster than one at par (John 3) |

## 7. Build order (each step after the one before passes)
1. `RepRules` (1.1 formula and table) and `RepLedger` (floor, clock). Run lines 9 and 10.
2. `Ladder`: seed, rivals moving, drain, entry. Run line 8.
3. `AskAnswer` (refusal table, deterministic date) and `Challenge`. Run lines 7 and 11.
4. Bots with plans. Run BASE0 and lines 1–6 and 12. Freeze the numbers.
5. `ProGate` at 55, Stay amateur, and starting pro fans unchanged.
6. The page (4), from the agreed mockup only, after owner questions 2, 4 and 5.

## 8. Owner questions and checks

**Owner questions**
1. Rename the gym's CODE `Career` reputation to **Standing**, so "reputation" means a boxer only?
2. OK the LADDER tab page (4.2–4.3) as the board to draw next?
3. May a hosted show's headliner ask up to 15 beyond the gap line, at about $150 travel for the guest (ESTIMATE)?
4. Show the reputation number on rows, or the band word only?
5. Ladder rows carry the opponent's name in the name cell, as World > Rankings does today. If no, rows show portrait, club and record, with the name only in the card header (S448).

**CHECKs**
1. Ladder size per class, from `Region.gd`.
2. Whether the shown chance excludes the plan.
3. Season start date for TWICE THIS SEASON and the cap.
4. Starting pro fan count in code today.
5. Whether the Pro offer modal can show a ticket line.
6. The modal's code text "tickets she sells" breaks S412: Claude to make it "tickets the boxer sells".
7. Whether a boxer can change class in code (for v2).
8. The owner's S475 sparring note, unread.
9. Do amateur bouts in code allow draws? John believes amateur bouts always have a winner. The draw rule is kept in case code allows them.

**v2:** class change and its reputation carry; the national ladder; rivalries with the living world (S428).

## 9. Risks
- **Elo can feel stingy at the top** (+2 for a safe win). The star and the edge line show why.
- **The drain could empty a small ladder.** Line 8 guards it, and the quarter entry refills it.
- **The pass cost (−2) is one number** and line 11 is its only test.
- **16 and 25 are untested.** Steps 1 and 4 freeze or change them.

## 10. Self-score (fresh critics decide)
- **Depth 7:** an edge-over-expected currency tied to training, plan and tape; real defending; a living top.
- **General design 7:** one refusal word for reach, every "no" with a way to a yes, the S425 menu table kept.
- **Play 6:** until the probes run.

**To reach 10/10**
1. Run steps 1–4 and publish the 12 lines with numbers.
2. Answer the 5 owner questions.
3. Read the S475 sparring note and wire it into WHAT WE KNOW and the sparring screen.
4. Draw the LADDER page at 1920×1080 from the kit, then a critic pass on the drawing.
5. Close CHECKs 1–9, especially 2 (chance and plan) and 9 (draws).
