# LADDER1_V6 - score this mechanic's DESIGN (S459 design loop)

You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design map
at the end. Judge the MECHANIC, not the look of any screen.

Score, each out of 10, with the reasons:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
3. PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
The bar (owner S459): the mechanic is DESIGNED when critics give it 7+ on DEPTH and 7+ on GENERAL DESIGN (owner S425).

Also answer: which options are missing, which are useless, and what each option changes (owner S403).
End with **To reach 10/10**: the concrete changes that would take it to 10, most important first, each specific enough to
build (owner S405). Then describe your 10/10 as a 1920x1080 page (an HTML file is welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent"). Real-world boxing evidence where it helps.

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

# DESIGN_LADDER1_V6_DOLA - Dola answer (seat queue SQ211)

Brief: research/DESIGN_LADDER1_V5_REVISE_KALLI.md
Sent: 2026-11-17 21:40 | collected: 2026-11-17 22:10 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.

---

Dola
New Chat
Ctrl N
Ctrl
N
Scheduled Tasks
Ctrl Shift T
Ctrl
Shift
T
AI Creation
Drive
New
Ctrl Shift D
Ctrl
Shift
D
Skills • Connectors
Ctrl Shift S
Ctrl
Shift
S
More
Drafts
New Chat
Pinned
Main chat
Projects
Fightcamp
fighter personalities
Fightcamp
Fighter Personalities
Recents
Ladder1 V5 Matchmaking Mechanic
FightCamp 3D Animation Rebuild Plan
Ask For A Fight Mechanic Criticism
GUARDDMG1_V1 Guard Mechanic
LADDER1_V5 Mechanic Design Evaluation
CoachSpec1 Coach Roles Design
Fight Film Analysis Mechanic
Fight Film Mechanic Design
Fight Film Mechanic Design Score
LADDER1_V4 Opponent Pick Mechanic
CoachSpec1 Coach Roles Mechanic
Coach Roles and Specialties
TRAINGAME2 V2 Training Week Mechanic
Season Ladder 1 V3 Design
LADDER1_V2 Mechanic Design Review
FightCamp Training Scene K Layout Spec
FightCamp Coach Weekly Board Page
LADDER1_V1 Amateur Fight Ladder
FightCamp Training Scene K
Amateur Week 1 Mechanic Design Review
FightCamp Training Scene Update
K C908
Ladder1 V5 Matchmaking Mechanic
Generated by AI
LADDER1_V5 - write the NEXT version of this mechanic's design map (S459 design loop)
You are the designer. Read the whole game (critic pack below), the current map, and the critics' answers at the end. Write
the next version of the map in full (not a diff): answer EVERY point of each critic's 'To reach 10/10' list (do it, or say
in one line why not), keep every rule the owner agreed (quoted in the map), keep it buildable from what the game has, and
keep the map's table of every menu the mechanic appears on and what each is wired to (owner S425).
The bar it must reach with fresh critics: 7+ DEPTH and 7+ GENERAL DESIGN (owner S425). Numbers: say which are ESTIMATES.
Plain words; names only in headers. Return only the new map, starting with its title line.
Also read ops/research/CRITIC_ACCESS.md: the Miro board, the real screens, the mockups.
Also read ops/research/CRITIC_ACCESS.md: the Miro board, the real screens, the mockups and the eight MMA fighters. Written S403 from the code; update it when a mechanic or screen lands.
What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with To reach 10/10: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.
FightCamp critic pack: the whole game, for judging whether a screen has the right options
Owner's rule: "i want every screen you design to have the right options so every critic needs to know the whole game design and mechanics to guide you".
This pack is facts only: no scores, no verdicts, no earlier critic comments, and nothing that is merely proposed. Written 2026-11-08 from the code
and the agreed plans. Where a document and the code disagree, the pack says what the code does.
How to read the status tags:
BUILT = it is in the game now and a player can use it.
AGREED, NOT BUILT = the owner approved it (or a plan he approved includes it) but the game does not do it yet. Judge a screen as if it will exist.
PARTLY = some of it is in the game; the pack says which part.
NOT ESTABLISHED = the pack could not confirm it from the code or the plans. Do not assume either way.
Names only in headers (owner S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"): a person's name sits in the screen's header once; options, buttons, rows, lines and tooltips say her / him / the opponent / your coach. Flag every name you see outside a header.
A screen should offer an option only if the player can act on it (rule in section 7). "Option" below means anything the player can press, drag, pick or type.
1. What the game is
A boxing gym management game for PC (Godot 4.7, Windows). The player is the head coach and owner of one small boxing club. Not a promoter, not a fighter,
not a tycoon. The club lives on members who pay monthly dues; a fighter's bouts add ticket cuts, reputation and new members.
Scope for the first release: boxing and no-gi BJJ (the owner decided BJJ ships beside boxing). MMA comes in the first update after launch. Kickboxing and
Muay Thai are not scheduled. Early Access is the target; no date.
The player controls: whom to sign and which starting focus; the coaches and staff hired; the week of training for each fighter (mornings, pad and sparring
evenings, diet); which bouts to take or ask for; the camp before a bout; the game plan written as lines; combinations built and drilled; the corner calls
and corner minute on fight night; the fighter's next goal; the club's money (dues, spending, deals, upgrades).
The player does NOT control: the punches thrown. The fight is settled by rules (exchanges of 30 seconds); the 3D fight only shows the settled round and
never decides. The player also does not control fighters' moods directly, rival fighters, the weather/twist cards, injuries, or when offers arrive.
The fun, in the owner's and the design's words: raising an unknown into a champion; the plan is the star; you can always see how your plan made the
difference (the Why after every fight); every week costs something (training, weight, fatigue and money pull against each other); fighters are people
(traits, habits, moods); fast and honest (anything one click from anywhere, true numbers). The three core mechanics beside the corner (owner S354):
the morning sessions that add up to a goal and an intensity (the week), the evening move and combination planner, and a fight plan that is fun to design.
The Playbook/Combos area is the part the owner calls really fun ("to try and also learn from the book").
Design rule on results: the better-trained fighter usually wins; a good plan turns close fights and gives underdogs a real chance. Measured in tests:
good plan about 59% of bouts, no plan 45%, bad plan 41% (one matchup). Training beats planning: 5 points better in stats wins about 72%, 10 points about 95%.
Not mobile, not casual: no timers, gacha, daily rewards or ads. Real stats stay visible. Deeper, not wider (owner approved "build all proposed systems").
Tone: a gym, warm and tactile, not a spreadsheet. Plain words, one word per concept, no flavour text.
2. A career from the first minute to the first pro fight
Time model: the clock runs day by day when the player presses the big CONTINUE button. It stops by itself every Monday (the week review) and for
anything that needs the player (a bout offer on its last day, weigh-in, fight night, injury choice, trial day, walk-in). Day 0 is Monday 5 January 2026.
The button says what it is stopping for ("to Thu 15 Jan, the offer expires"). Quiet week = one click.
Title screen: Resume career (if a save exists), New career, Quick start (a ready club, London), Load career, Settings, Credits, Quit.
New career, two steps. Step 1 YOU: your name and one of four head coaches on photo cards (Old hand, Ex-pro, Amateur coach, Strength coach), each with one
edge. Step 2 YOUR CLUB: country, city, gym name, and one of three starts that double as difficulty: Fresh doors (normal), In debt with one good boxer (hard),
Backed with big expectations (risky). A switch lets the player skip the first-hour guide. Quick start takes the first coach card and Fresh doors.
Day 0, Home: the first-hour card (the job: keep the doors open; the first show date; who you are), a walk-in fighter waiting at reception (Lucy Jackson in
the standard start; other starts and the male-boxer start use other names). The guide strip runs three stages: FIRST WEEK (sign, coach, week, go),
FIRST FIGHT (offer, prep, fight), THE CLUB (second boxer, bouts for both, set the first boxer's next goal). It can be skipped.
Sign the walk-in: an RPG-style card (class from style, potential in stars, each attribute's ceiling, two traits, one habit, a signature move, an
ambition) and ONE starting focus. Hire an assistant coach (Luke Reid sessional $450 a week, or Marcus Hale full-time $1,090 a week; $1,000 signing fee).
Without any coach, training runs at 60%. Open the Week and lock in week 1 (the coach has already written a week). Press CONTINUE.
Monday of week 2 (day 7): the first bout offer arrives, for the club show on Saturday of week 4 (day 26). Until the first bout is fought there is no twist
card and no ask. She starts about 1.4 kg over the limit, so weight is the first real decision (a cut needs starting in week 1). Accept shows a poster
reveal and offers the camp.
Fight prep: camp (focus, intensity, partner, film), game plan, weigh-in the day before, fight night, result, Why, goal talk. After the first bout: a second
walk-in arrives the next Monday, a rival coach (Frank Doyle, Eastside ABC) is named in the news, three club tasks appear on the guide strip, and Ana (the
no-gi athlete) is teased, then asks to join after the club's second bout or by week 9.
The loop afterwards: offers every couple of weeks (a club show every other Saturday from day 12), camps, nationals, money pressure, more fighters.
Amateur road: the National Amateur Championships. Entry needs 5 bouts and 3 months registered, age 19-40; entries close in week 10; a London regional then a
national draw. While in it, no other offers come. A loss, injury or missed weight ends the run.
Turning pro: a promoter's offer arrives at 7 wins with a top-3 regional rank, or at 9 wins at any rank. The debut is 4 rounds, about 4 weeks after signing.
The gym pays the licence ($230) and, the first time, medicals ($875) and the trainer's licence ($140). Stipend stops. After the debut a pro joins a world
division table unranked and the promoter brings three offers per fight (see 4.12). Older docs said "the game ends near the first pro fights"; the code
goes further (pro ladder, belts, ageing, retirement), see section 8.
The club failing: 8 weeks in a row below $0 closes the gym. A closed gym shows a summary that cannot be dismissed (New career / Load career / Title).
3. The fighter: three layers
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
Boxing: 7 trained stats: Power, Hand speed, Technique, Defence, Conditioning, Ring IQ (fight IQ), Chin; plus Footwork (derived from speed and defence) and
the personality values Heart, Discipline, Confidence, Coachability, Temper (Loyalty exists but is not on the board). Amateur women's lightweights sit 55-65;
bands: weak under 45, fair under 55, solid under 65, strong under 75, elite above. Each stat has a potential ceiling ("tick") and a weekly delta.
Moves with mastery (0-100): Jab, Cross, Lead hook, Body hook, Uppercut, Check hook; from 30 a move is a "weapon" the fight can use. Combinations (the
book: 1-1, 1-2, 1-1-2, 2-3, 1-2-3, 1-2-3-2, 3b-3, 1-2-3b, 1-6-3, slip 2-3) unlock when their moves are weapons; players can also build their own.
Body: weight vs class limit, condition (fatigue word), injuries. Style word (Out-boxer, Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher,
Slugger). Stance. Age. Record. Rank in the region.
Personality and habits, learned not shown as numbers in the ring: 6 traits (heart, temper, confidence, discipline, coachability, loyalty) and habits
(for example drops the right after the jab, slow starter, fades late, chases stoppage). A coach's-notes card fills in with words from fights and sparring.
Morale (stored 0-100): Fired up (75+), Steady (50+), Flat (30+), Low. Moves: win +8, loss -12, goal met/missed, rest week +4, a month without a fight -6,
bout booked +5, wrong corner call -2, right call +1. Morale is also trust in the corner: Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7 of the corner's
word taken in; a Low fighter stops listening.
BJJ athletes have 6 stats (strength, cardio, flexibility, explosiveness, composure, aggression) and mastery per move; belts, not ranks.
Perks (the perk road): open for good when attributes reach a need, each changes one thing in a bout: Iron chin (Chin 70), Stiff jab (Technique 65),
Second wind (Conditioning 70), Ring general (Ring IQ 65, corner calls work 25% better), Counter sense (Defence 65 + Check hook weapon), Body snatcher (Body
hook weapon), Finisher (Power 70), Fast hands (Hand speed 70).
4. Every mechanic
4.1 The week and training plan - BUILT
Choice: for each fighter a week of seven mornings (a session each: roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow, neck work, or rest;
each at Light, Normal or Hard) and seven evenings (Pads, Sparring, Rest, Film). The coach writes the week from the camp phase and repeats it; the player edits
exceptions (click a day, a popover). "Back to the coach's week" resets. Diet: Hold or Cut 500 kcal a day.
Phases counted back from a booked bout: BASE (no bout), BUILD (3+ weeks out), PEAK (2 weeks out, hardest, sparring twice), TAPER (fight week: light, three rest
days, no sparring).
Changes: each morning adds a small amount to one stat (pace 1.0 per focused week x coach factor x headroom clamp((potential-stat)/25, 0.10, 1.25), a morning
is a fifth of it, Light x0.6, Hard x1.3, less when tired); kcal and weight; fatigue (0-100, "Week tiredness"; from 80 she is overreached: gains x0.6 and
injury risk x3). The Week tab shows plan totals, the goal line, the coach's one change with a "Do it" button, and the weeks to fight night.
Coach factor: 0.5 + rating x 0.7 per cent; no coach = 60%. Strength coach head-coach edge: body mornings +10%, craft mornings -10%.
Twist card: once a week the coach draws one (sore wrist, rain, weights room shut, partner ill, head cold, visiting pro, quiet week; or a choice card such as
tight knee, scale will not move, night off, heating breaks, combo clicking, southpaw in town, old coach visits, sponsor photoshoot, rival talks trash). Two
answers each with a visible price; unanswered = the coach's pick on Monday. Planned vs actual is shown on the review.
Training load: acute vs usual load; a spike (ratio 1.5+) raises injury risk 2-4x.
Two fighters in camp competing for the coach's pad nights: AGREED, NOT BUILT (see 4.2).
4.2 Pads, combinations and mastery - BUILT (pad nights for two fighters AGREED, NOT BUILT)
Evenings are nights that carry drill cards. A pad night is 75 minutes split over its cards; a sparring night gives every card already in her hands a share.
Standard week: 3 pad nights; camp 2+1 / 2+2 / 3+2 pad+spar for Light/Standard/Hard.
Choice: drag a drill card (a move or combination) onto a pad night; split a night 50/50, 70/30, 30/70; remove or clear; pin cards in the tray; "+ drill it".
Mastery gain per hour of drilling: pads 2.1, heavy bag 1.05, shadow 0.85, sparring 1.5, speed bag 0.9, double-end bag 1.2. Undrilled moves fade slowly.
A drilled combination also holds its punches. Tiers: New, Raw (under 30), Usable (30), Sharp (60), Signature (85). A move at 30+ is a weapon.
Today a planned line fires every time once it is usable; sharp is worth about 1 win in 100 over usable. In the game but SWITCHED OFF (S427,
measured on 400 bouts a cell): a planned line fires 1 use in 2 at usable, 3 in 4 at sharp, always at Signature (sharp then +2.8 wins in 100
over usable, Signature +2.7 over sharp). BUILT for professional bouts (S458-S462, ProRead): the opponent's corner studies your boxer's
last two professional fights and waits for the punch thrown most; two real weapons or a feint line blunt it. Amateur bouts: not read across bouts.
A combination in a fight costs energy (longer costs more); a flurry is limited by hand speed and tiredness; a signature (drilling, not length) may run one
punch past the speed cap. Own combinations built in the Playbook (Combos tab) get their own pad mastery.
AGREED, NOT BUILT: with two fighters in camp the coach's pad nights are shared; the top row of "Learn on the pads" shows how many go to each (cost to the
other fighter), only while two are in camp; a needs flag says when the second camp starts.
4.3 Fight camp - BUILT
Opened by "Set camp" (a need once a bout is 3+ weeks off, or from Fight prep). Choices: camp focus (one of Conditioning, Power, Technique, Defence, Speed);
intensity Light / Standard / Hard (3, 4, 5 nights; focus multiplier 1.1/1.2/1.35; fight-night edge +0.25/+0.6/+1.0; all free); Partner: club mates (free) or an
outside mate of the opponent's stance or style ($160); Film (tape study, free).
Changes: the camp stat gets a forecast to fight night; scale forecast; tape study opens one tell on the opponent's file every few camp days (weapon first,
weakness last). A camp whose three lines are all met on fight night (made weight, stat on target, never overreached) gives PEAK CAMP: +bonus to every stat for
that fight. A southpaw partner removes a round-1 penalty for an orthodox boxer who never faced one.
4.4 Weight - BUILT
Each fighter has a class limit (women's 57/60/65/75 kg, men's 57.5/60/70/75 kg). Weigh-in is the day before. Diet Hold/Cut and training burn move weight;
the bout page and Fight prep forecast "now / on the day". Missing weight calls the bout off and the club pays $300 for the empty slot. A boxer over his
class can get a bout he can make (a later date). The Old hand head coach makes cuts easier (120 kcal a day more).
4.5 Booking and matchmaking - PARTLY
Amateurs BUILT: offers arrive (a club show every other Saturday; one offer at a time per fighter, answer by a date, usually 8-12 weeks lead at clubs, 2-4
weeks in the first hour). Each offer: Accept or Pass, both free. An unsafe mismatch (a novice, 0-10 bouts, against an open fighter) cannot be accepted. Win chance
shown as a band that widens when unscouted. No way to ask for a named amateur opponent: AGREED; rules built (scripts/rules/AskBout.gd), panel not built (Ask for a fight: a "no" is a closed panel or an absent answer with its reason, never a random refusal).
Pros BUILT (after the debut, on Fights): the promoter brings three offers per fight (TUNE-UP likely, STEP UP about even, PAYDAY long shot) standing 7 days; OR the
player asks for a named boxer within the promoter's band (about 5 places above, unranked reach 15; a top-5 name needs 3 fans); Scout costs $250 and opens the
opponent's weapon and weakness and narrows the chance range. A promoter refuses if you duck the step up twice. Each row shows chance, what a win gives (place,
fans), what a loss costs, stoppage risk, pay (gym's 25% of the purse), and the gap to the next fight (quick, normal, hard night).
Rank rule: beat someone above you and take their place; beat someone below and nothing moves; a losing record is never ranked in the top 10. Purse: $1,500 unranked
$400 per place; tickets follow fans and how close the fight looks. Pro rounds: 4 unranked, 6 ranked, 8 top 10, 10 for a title.
4.6 Scouting and the opponent's file - BUILT
Free at booking: record, look, style word. Hidden until found: best weapon, each habit, weakness. Amateur: tape study in camp opens one a session. Pro: scout
for $250; the weapon is public tape. A found tell names its answer (a plan situation, a corner call or a drill). The Ex-pro head coach opens one tell the day
a bout is booked. An opponent with no bouts has no tape. The Tape Room (Fight prep, "Watch the tape") plays 3-4 films of her past bouts, SPOT the tell, then
YOUR ANSWER picks a move that becomes a plan line.
4.7 The game plan (Playbook) - BUILT
A plan is lines: "At long range -> One-two", "When she presses -> Step back" (places: outside, long, mid, inside, clinch, ropes; situations: she presses, boxes at range,
waits to counter, loads up, tires). Each answer is rated vs the opponent's game: Beats it / Works / Walks into it, and its edge over improvising, times her pad
time. Rate against another kind of opponent; round-by-round pace Push/Steady/Save; a go-to combination. The coach's skill sets how many lines (a plan holds
4-6). Real fight plans can be loaded; See the flow; Open the map. With no plan written the assistant coach writes one (poor to about half of a read plan).
A plan the fighter has not drilled works less well; a wrong answer costs. During a bout: planned right answers that win exchanges build PRESSURE on the opponent
(cuts her output); planned wrong answers she is punished for shrink her energy ceiling.
BUILT (PlanRead): inside a round the opponent adjusts - a planned line pays in full for its first 2 uses in that round, then less each use; it resets
at the bell. AGREED, NOT BUILT: their note replaces the coach's line in the corner minute naming the line that stopped working.
4.8 Fight night - BUILT
A bout is 3 rounds of 3 minutes (amateur), 4 (pro debut), more later. A round is six 30-second exchanges, each settled by dice on an edge (training, plan, corner call,
pressure, tiredness). The opponent fights one way at a time (Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt), shown as a clue.
Every 30 seconds the player may shout one of the 3 calls that fit, or say nothing: Jab and move, Go to the body, Draw the lead, Hands up move your head, Let your
hands go, Breathe pick your shots, Tie up, Go for the finish. Each has a best / ok / wrong match to the opponent's mode, needs stats, costs or gives energy; only
two instructions per minute get through fully. Pace (Push / Steady / Save) and Aim (Own game / Head / Body / ribs / the hurt head) persist from shout to shout.
A set-up "NOW!" fires a learned combination into a gap the opponent opens: big edge, or a cost if wrong.
Corner minute between rounds: the corner card (what worked, what hurt, the call), the plan call, ONE CHANGE for the next round (a habit fix, or Elbows in: half the body punches go to the head, saving their energy and adding head damage, or Gloves high: the reverse; moved punches change where she is hit and what it costs, measured not to change who wins), RECOVER with 3 points (water, ice on the ribs, clear
her head when hurt), SET-UP (a combination x a gap), TALK (calm / fire up / the truth), change one plan arrow, cutman job (close the cut, enswell an eye, nothing).
Trust: a wrong call she followed costs trust; a Low fighter ignores shouting.
Knockdowns and counts come from power and damage vs chin, heart for the count; amateur RSC at 3 counts in a round or 4 in a bout. Injury roll after the bout.
Result: scorecards (3 judges), win on points / stoppage / draw, "what decided it", the Why, a body report (which part went first, with a "Train X next week"
button), "The plan, lit up" flow, then Back home and the goal talk. Watch modes: with a picture the 3D fight plays (1x/2x, Skip round, Skip bout); headless runs
stay in words. "Sim to result" skips the fight. Highlights/full modes in design notes: NOT ESTABLISHED as options in the UI.
AGREED, NOT BUILT: a cutman card for a closing eye, "stop it (she loses, the eye is safe) or go on (risk of a lasting cut)", behind a divider, never a pop-up,
never pre-selected, not using one of the two fixes (the 3D corner has a cutman job row today; whether its stop-or-go choice exists is NOT ESTABLISHED).
4.9 The Why - BUILT (the hook)
After a bout, plain lines: YOUR PLAN (graded against having no plan: right answers, wrong answers, neutral, worth about +X% chance), AGAINST YOU (what the opponent's
habits cost), NEXT (what to train or write). Graded by how each planned move answered what the opponent was doing, not by the dice; "swing" counts replay the
dice without the plan's edge. A readable reason for every random swing (R11): AGREED, NOT BUILT as a general feature; it lives on existing rows.
4.10 Damage, injuries, suspension - BUILT
Six body places per boxer take punches (head, ribs, etc.); bands fine over 55, hurt 55, critical 35, doctor 15. Bout injury roll from settled damage (about 6% a
3x3 bout; 72% head/neck, 20% cuts); training injury about 1.3% a week, more when overreached. Stoppage loss = 30-day suspension, longer for repeats. While out: no
offers, a quarter of gains. A fighter hurt before a bout: choice "pull out" (club pays the empty slot) or "fight hurt" (less energy: minor 10, moderate 15, serious 20).
A damage ledger and fights-left forecast exist for pros in the world model.
4.11 Morale, trust, goals - BUILT
Goals with deadlines (for example Debut inside a month, Next bout inside a month, Southpaw answer, Five-round engine), set in the office after each bout (Goal talk:
pick one of the offered goals). Status ON TRACK / AT RISK / OFF TRACK / MET / MISSED; ~70% clearable by design; meeting or missing moves morale. "Her asks" can be
heard or overruled (morale +5 / -5). The ambition shown on the signing card does not yet change anything (the design says a kept goal should build loyalty, a broken one may make a fighter leave: AGREED, NOT BUILT). Overruling a low-coachability fighter hurts more.
4.12 Staff - PARTLY
Head coach (you): one of four edges: Old hand (cuts easier), Ex-pro (one tell on file when a bout is booked), Amateur coach (a prospect's exact potential), Strength
coach (+10% body mornings, -10% craft mornings). Assistants: Luke Reid and Marcus Hale (above); training quality, plan lines taught (more with better rating), evening
classes +$350 a week. Staff jobs on the Club page (each changes one number): Second club coach 10 h ($280 a week: +1 roster place, +40 members, runs fitness classes);
Strength and conditioning ($100: training injury risk -15%, a pro camp's bill halved); Physio ($75: injuries back a quarter sooner); Cutman ($150 a pro night: half
the post-bout layoffs). Letting a staff member go costs a week's pay. Letting the main assistant coach go: NOT ESTABLISHED (Let go exists on the staff jobs).
"Coach runs it / I run it" per fighter: AGREED, NOT BUILT (the Roster has no such column).
4.13 Money and the gym - BUILT
The week review gives one short reason beside any change in members (word getting round, gym full, less room, dues too steep, more than the gym's name can hold).
Income each week: members' dues ($35 a month each standard; bands Cheap $25 / Standard $35 / Premium $45 change who joins), evening classes (+$350 with a coach), no-gi
dues, sponsors, fitness classes, juniors' dues. Costs: rent $1,800 a month (bigger premises more), England-Boxing-style fees ($315 club + $18 a boxer + $35 a coach a year),
coach, fighter stipends ($250 a week, optional), heating and power by season, insurance $1,250 a year, staff, kit budget (Low $0 / Standard $45 / Good $80 a week),
upgrades' upkeep. Wages and upkeep are billed every 28 days. Start cash = 1 / 3 / 6 months of costs by start. Runway under 8 weeks warns; below $0 is red; 8 weeks in a
row below $0 closes the gym. A loan ($180 a week for 26 weeks) comes with the debt start; the backed start loses $5,000 if the first show is lost. An overdraft rule
exists (offered after 12 weeks of trading, 16% a year) but NOT ESTABLISHED as having a screen.
One-offs: a bout adds a $450 ticket cut; camps cost a partner fee when used; repairs; a club show you host ($3,500, tickets $25, up to 400 seats, every 16 weeks, can lose
money); a club grant bid once a year (answer in 42 days, needs a second coach, odds follow reputation).
Spending choices on the Money page: Premises (Unit 70 members/3 places, $1,800 rent; Bigger unit 140/5, $3,400, $12,000 to move; Club building 250/7, $5,500, $25,000);
Upgrades (matted floor $2,400; strength corner $3,600; fitness class kit $1,500; youth section $1,800), each bought once, works after a week, one visible effect; Sponsors
(Ironclad $250/week from the start; Bow Road Physio $150 after the first win; bigger sponsors later); dues band; kit budget; evening coaches; pro stipends and contract talks.
Members: walk toward a target set by reputation, dues band, premises and coaches (at most 6 a week). A win adds +8 members and +5 reputation; a loss removes 1 and 2 reputation;
a stoppage loss 2 and 4. Facilities (floor, ring, bags, lockers, office) can be repaired once ($120 bags) for +2 reputation.
A pro's share to the gym starts at 25% (manager 15% + trainer 10%); contract talks at the first top-10 and the first belt (keep 25% for a bonus or drop the share), then yearly.
4.14 Rankings, titles, the world - PARTLY
Amateur regional table (the region's club-show boxers; a player's fighter enters at 4 wins); rankings move as rivals fight each other at shows; news lines. Nationals and the
regional bracket (BUILT). World pro tables for four divisions (women's and men's lightweight and welterweight, about 20 ranked each): boxers age, peak, decline and retire
(damage ledger and age), new ones arrive yearly, belts at four levels (area, national, continental, world) with mandatory challengers and vacated belts, rivals improve (BUILT in the
rules; its screens are on Fights, not World). An open-ended career, year review, three club goals a year, club tiers, a record book of champions and rivalries,
a named rival gym that poaches and rematches, promises/poaching at contract time, a career clock with retirement talk, youth-section home-grown prospects, a commentary line
and a press card are AGREED (owner "all of them", Q-S294-120) and mostly NOT BUILT; Records (the gym's own history log with filters) and the youth section exist.
4.15 BJJ (no-gi) - BUILT
Athletes (Ana Ribeiro) are on the mat, not in the ring: belts white, blue, purple, brown, black with 4 stripes each (IBJJF floor: blue needs 2 years, purple 1.5, brown 1; minimum
ages 16/16/18/19). The week is 3 classes; a class drills the syllabus move she is closest to owning (+3.2 a week; owned at 30, signature 50). Choices: drill a move; stripe call
(now / hold / early) with morale and loyalty costs; promote; enter opens (no-gi tournaments every 35 days, 8-person brackets); fight an open yourself (the player calls the moves on the move
graph) or simulate it; who teaches (hired coach or the athlete). No ranking table: the belt is the ladder. 5-10 minute matches by belt; points: takedown 2, sweep 2, pass 3, knee on belly 2,
mount 4, back 4. A BJJ athlete costs a roster place and a no-gi coach by the class.
The match runs on two-sided beats of about 11 seconds (S405): each side either acts on its pick or works its grips, and a holding lead can draw the referee's 20-second stall count.
Measured over 1,000 bouts: white belts finish about 34% of matches, the first to score keeps the bout about 80% of the time, and a one-belt gap wins about 74%.
4.16 Perks - BUILT (listed in section 3).
5. Every screen in the game today
5.0 The shell (on every game screen)
Top bar, left to right: Back (<) and Forward (>) arrows (greyed when none); gym name; date and week (hover card); red/amber flags (not on Home): GYM CLOSED, BELOW $0, LOW CASH,
APPLICANT, TRIAL, PRO OFFER, SET CAMP, WEEK REVIEW, WEIGH-IN, NEW GOAL (each opens its thing); cash with "running +/- $N a week" (hover card); the big button; Menu.
The big button: CONTINUE ("to <date>, <reason>"), RUNNING (click to pause), NEEDS YOU (n) (opens the first red need), or GO TO FIGHT NIGHT. Space also presses it.
Menu: Mail (opens World News; shows a new count), Save, Load, Settings, Handbook, Quit to title.
Left rail: Home, Fighters, Fights (badge = open offers), Club, World; the club crest (hover: name, members). Keys 1-5 reach the rail (design note: NOT ESTABLISHED in code).
A guide strip (first-hour guide only): the current stage's steps, what to do and why, a button for the next step, and Skip the guide.
Settings: text size (Small/Medium/Large/Largest), window (Windowed/Full screen), days run at (Normal/Fast/Fastest), four sound sliders (all, punches/ring, crowd, music),
Autosave (every Monday, last weeks kept / Off). Handbook: search and group filter (All, Words, The club, The week, The plan, Fight night, Money) with links to areas. Credits.
5.1 Title; 5.2 Create (see section 2). Create buttons: Back to title, Next: your club, Back, Open the gym; picks for coach, country, city, gym name, start.
5.3 Home (no tabs) - BUILT
Notice board of needs as pinned notes, each with a button: Meet the walk-in; Answer a bout offer (Open); Weigh in; Set camp; Hire a coach (Staff); money warning (Money);
a sponsor waiting (Deals); Enter for the nationals (Nationals); Week N review ready (Open); New goal waiting (Talk); Trial today (Watch the trial); Pro offer (Hear it);
Hurt before the bout (Decide); competes today (Go to the mats); The gym has closed (See the summary). Red = stops the clock; amber should come next; steel can wait.
First-hour card until the first bout (the job, show date and countdown, you). The next fight as a matchup card (button: Go to fight night, or the next step).
YOUR FIGHTERS table: fighter (name opens the page), record, rank, next fight, weight, freshness, this week's plan. Right column: SINCE LAST MONDAY (each fighter's biggest gain
with its cause, injuries, rank moves, new members; "All news and mail"), THE CLUB THIS WEEK (money in, costs, members, coach), COMING UP (bouts, weigh-ins, championship dates, bills).
5.4 Fighters > Roster - BUILT
A sortable table (columns: fighter, record, rank, The Road, and more) with flag chips per fighter that open the thing that needs her; a card per no-gi athlete with belt,
stripes, classes, "<name>'s mat: Playbook"; buttons: Meet the walk-in, Open training, Set camp (locked with a reason when it cannot start), See offers.
Fighters > Find a fighter: PROSPECTS NEAR <city> as face cards with scouted ranges for four stats (a range until the trial; the Amateur coach edge shows exact potential),
button Invite to a trial (free; she comes in on the Monday; signing costs the stipend). States: trial date, signed, passed. The reception walk-in is separate.
5.5 Fighter page (tabs: Overview, Week, Fight prep (only with a bout or camp), Playbook, History)
Header: portrait, name, weight class, age, stance, record, goal chip ("Goal, N days: still needs X - at risk").
Overview: NEXT STEP (the road: next step and what it needs; Enter for the nationals; the whole road on hover); attribute board (radar of eight against potential plus all values with weekly
delta, hover says what each does in a fight); BODY (weight of limit, condition, injury), COACH SAYS, COACH'S NOTES n of m; GOAL (title, days left, meter, status, quote;
Talk to <name> when a goal talk is waiting), NEXT BOUT; buttons Plan the week, Fight plan (n arrows), Find a bout; perk road; moves with mastery bars (hover plays the move); combos
learned (gold = thrown in fights); contract text ("club stipend $250 a week, until turning pro") and goals so far.
Week: head (NEXT/THIS WEEK dates, tiredness), PLAN TOTALS, seven columns of morning and evening cards (click opens a popover: Light | Normal | Hard and sessions; Rest | Pads | Sparring
and the drill cards), goal line, the coach's one change with a Do it button, Back to the coach's week, the twist card (choose an answer), LEARN ON THE PADS tray (drag a card to an
evening), THIS CAMP (diet pills Hold / Cut 500 kcal) only with a bout booked, a skills road below.
Fight prep: VS <opponent> (club, record, game), days to fight night and weigh-in, ONE primary button that moves with the state (Set the camp / Write the game plan before sparring /
Watch the tape / Step on the scale / Check the week), the tale of the tape with the win chance and how sure it is, WHAT YOUR PLAN SHOULD ANSWER (each found trait with its answer and
"Write it"; hidden ones say what opens them), CAMP AND WEIGHT (scale margin, the camp stat's line to fight night, Change the week).
Playbook (boxer): tabs Moves (move book by place in the ring; Watch/Steps, Drill, Replay, Slow motion), Game plan (see 4.7: Write a line / Change / Clear this line, Answer: <best>,
Rate against, Load a real plan, Test it (limited tries), See the flow, Open the map, Build plan in the move browser), Combos (build a chain from "+ move" buttons, Play it, Clear, Save to the
book, Drill it on the pads, Watch on the pads, chain hit rates vs opponent types), Escapes (folded into Moves in the agreed menu). A body plays each move on the right.
History: every bout she fought (and brought) with result, opponent, cards and why; milestones.
No-gi athlete page: one Record view: THE ROAD TO BLACK BELT (five belts with stripes), TO <NEXT> BELT (mat time, moves owned, syllabus), COACH'S CALL (give the stripe, Promote to <belt>, next opens
with Enter, who teaches), RECORD in opens; her Playbook is a mat book (moves by group, Systems, Drill, Undo, a game tree with FELT and links).
5.6 Fights (no tabs) - BUILT
Amateur: OFFERS ON THE TABLE (a card per offer: opponent face, record, win band, chips; Open) with each fighter's STANDING beside it (booked or free, next on the road, Enter for the
nationals); when none, the line says when the next offer can come. For a pro: a strip, NEXT FIGHT table (offers, asks: Take this fight / Book <name> / Scout ($250)) and THE ROAD (champions and
places around her). No-gi opens card with Enter. Fixtures list (calendar), RESULTS (who beat whom, cards, why).
Bout page (an offer): head chips (Legal, even match / Weight at risk / Not safe), tale of the tape, stats vs the estimate, win band and ranks at stake, SCOUTING file (locked lines say what
tape study opens), TERMS (date, 3 x 3 minutes, weight, on the scale now/on the day, time for a camp, purse none, club ticket cut $450, answer by). Buttons: Accept the bout (disabled with a
reason when unsafe or answered), Pass. Accept plays the poster reveal and offers Set the camp / Later.
5.7 Club (tabs: People, Money, Records) - BUILT
People: STAFF (you as head coach with your edge; the assistant card with training quality, plan lines, cost, net weekly; two hire cards when none: Hire Luke / Hire Marcus; no-gi coach line;
STAFF JOBS with Hire / Let go), MEMBERS (on the books and drift, reputation word, dues band).
Money: CASH WEEK BY WEEK chart; NOW (cash, weekly in, costs, net, month's bill, runway line, break-even members); WHERE IT COMES FROM / WHERE IT GOES bars; STIPENDS (Pay/Stop the stipend);
CONTRACT TALKS (Keep 25%: pay a bonus / Drop to a lower share); PREMISES (Move); UPGRADES (Buy); KIT BUDGET (Low/Standard/Good); evening coaches (Hire one / Let one go); CLUB GRANT (Bid for a grant);
CLUB SHOW (Book the show); ONE-OFFS IN and PAID OUT (last 8 weeks); DEALS (Sign a sponsor); FACILITIES (Repair); dues bands buttons.
Records: the gym's own history, newest first, with filters (who: everyone / each fighter / coach / gym; what: bouts, honours, people...).
5.8 World (tabs: News, Rankings, Championships) - BUILT
News: AROUND THE REGION (other clubs' bouts, names are links) and fixtures/events. Rankings: a table per division the gym has a fighter in (rank, fighter, gym, record, style, last bout; click a name for the rival file; a
fighter enters at 4 wins; no-gi says the belt is the ladder). Championships: the road to the nationals per amateur (rings for what she still needs, Enter, the London regional and national draw brackets, titles).
Rival file (modal): record, style and the tells found so far; locked lines say what tape study unlocks.
5.9 Modals (open on a press or when the clock stops on them; nothing else opens by itself)
Interview/Trial (walk-in, prospect): the fighter as an RPG recruit, one starting focus (Sharpen the signature +10 mastery, Fix the habit gone in 4 weeks, Raise the ceiling +5 potential), Sign or Pass.
Pro offer: the debut money picture (tickets she sells, her share, what the gym pays now, what ends); buttons Turn <name> pro / Stay amateur.
Goal talk: pick one of the goals offered, Set goal or Later.
Camp: see 4.3; buttons Later / Start (shows the cost).
Weigh-in: Step on the scale (made or missed). Injury choice: pull out or fight hurt.
Fight night: tale of the tape (Begin fight, Sim to result); rounds with shout bar, Sim the round; corner minute (call buttons, fixes, jobs, Say nothing / No fix); To the scorecards / To the result;
result with Train X next week, The plan lit up, Back home.
Week review (per fighter): bars fill to the next whole point, moves drilled, new weapon, rank change, planned vs actual, pads cards turning over, money, the coach's word; rows land one at a time with the biggest
surprise last; the only button is Next week. Open night (BJJ): Simulate this bout or Fight it, Back to the gym. Closed gym summary. Info boxes (Settings, Handbook, Credits).
6. The seven approved menus, and the agreed structure of all menus
Owner, Q-S294-127: "Yes, build the seven": Home, Fighter Week, Boxing profile, Playbook, Fight night, Money, World. A shared warm-wall kit (WarmKit: wall, whiteboard, paper, sticky, magnet, chalkboard, marker
ledge) is built first so screens cannot drift. None of the seven is rebuilt in the kit yet; the screens in section 5 are the current ones. Agreed structure: five rail buttons (Home, Fighters, Fights, Club, World); one
home per job; no mailbox (Mail opens World News and the Monday page replaces the week-review pop-up); nothing opens by itself; time is one big button saying what it stops for; one booked fight runs in a straight line
(Home countdown, camp, weigh-in, tape, fight night, the Why).
Home (agreed): needs first, the job, the next fight, one row per fighter, Since last Monday with causes, the club's week, what is coming; the week review folds in as a need that "sits here, never pops up"; the line
under the big button names the next stop; the first-week guide card only in the first hour.
Fighter Week (agreed): the whiteboard: sessions as magnets, the fight date circled, colour only means risk, one red button moves the week on; plan totals, fatigue, the goal line, the coach's one change with the effect on the
button; Learn on the pads; ADD "Coach's pad nights" as the top row, two fighters in camp only, with the cost to the other fighter (R55).
Boxing profile (agreed in shape; numbers superseded by the 10 attributes in section 3): tabs Overview, Week, Playbook, History on one portrait header; three columns Body, Skills, Mind with a style line ("Keeps it
long"), one thing to work on and where it is trained; the sport switch only once she trains both; a rival gym's offer with its three answers (match it, promise something, let her go) as the top card when it
comes (R58, needs the running world).
Playbook (agreed): Moves (Escapes folded in), Game plan (lines drawn on a board, plays a default at once, rate against each kind of opponent), Combos; "No bout booked: try the plan against each kind of opponent".
Fight night (agreed): dark and tight, handwritten coach notes, three fixes / time for two; stats cut to three rows in the minute; the "she has adapted" note (14 words at most) replaces the coach's note (R25); a
cutman card only when an eye is closing (R28); the result with scorecards and the Why (plan, against you, next); the money lines move from the Why to Home; no "one change for next time" (the Why's NEXT carries it).
Money (agreed): the gym's books on the whiteboard: cash, runway, in and out, bills, deals, repairs, upgrades; dues bands wait for the owner's call on the cut.
World (agreed): News cut to only what touches you; Rankings with rivals that develop (movement arrows, Developing column); Championships; fixtures; no-gi "belt is the ladder".
Other menus in the agreed map (not in the seven; final text per MENU_STRUCTURE_S402): Start (three starts, already in game); First week; Fighters (a real roster); Fights (Ask for a fight sits under
the offers: level, date window, an answer with its reason; it waits for the bot test that a smart ask beats a plain one, R37); Fight prep ("What your plan should answer", no injury-risk lines on camp
choices); Club > People (staff cards keep their faces; members panel cut); Grow (finding and signing only plus the pro offer; no prospect deadlines); Top bar (no change).
Held back, do not build from an old mockup: one change after the Why, camp injury risk, scorecards after each round, members panel, prospect deadlines, sponsor line and per-fighter costs, the progress chart on History.
Conditional elements and when each appears: Coach's pad nights (two fighters in camp, until a camp ends); Needs flag for the second camp (the second camp starts, until she opens the Week); Cutman card (an eye reaches
the closing state at the bell); Adapted note (from round 2, when the opponent has answered one of your lines); Rival offer (the running world sends one; a flag only, answered or past its date); Ask for a fight
(always, once a boxer is signed); Swing reason (a random roll moved a number you can see, scrolls off with the week).
7. The owner's standing rulings on screens (quoted or near-verbatim)
Only actionable information: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Cut it, hover it, or put the action on it.
One top bar and modals; nothing opens by itself; moments come as flags on the top bar. A week review sits as a need on Home.
No flavour text; plain words; one word per concept (Raw, Usable, Sharp, Signature everywhere). Hover explains every number.
Not mobile: "thats not how sim/manager games look , its very simplestic no actual stats to make the player understand how good the fighter is". Real stats stay. Not an 80s spreadsheet; no placeholders.
Do NOT judge against a generic management sim ("they seems like economic management simulator"). Judge fit to this game and its plan.
Look B, the gym whiteboard: marker notes, polaroid, needs as sticky notes, the cash tin, the fight date circled; warm tan plaster wall, wood and aluminium frames, cream paper. ONE art style across menus
("no art consistency" was his complaint). Stylized comic portraits in menus are on and must match the fighter. Marker fonts Permanent Marker and Kalam.
Screens come only from agreed mockups; nothing is built on a menu he has not OK'd. A generic Money page was reverted.
Fight night goes dark and tight (the Miro "Corner minute"); the coach's notes stay handwritten.
Everything new ships switched ON. Hover cards on top-bar date and cash. Animated meters (every bar tweens).
Weekly job pages must not become a pop-up. One-click reach from anywhere. Two Point alignment is parked (the gym floor is out of the first release).
No gym still with the Day Plan or a drawer open; stills of fights show both fighters head to feet; boxers wear boots (visual rules for pictures).
Scouting means opponents; finding fighters is "Find a fighter". The facility is a "gym"; a fight camp is only pre-bout preparation. Fighters are fictional; organisations real-named only where legal.
8. Where the documents and the code differ, and what could not be established
Code wins. For the critic: do not judge a screen against these older statements.
Autosave, Settings and Handbook: docs say "not built"; they are built (autosave every Monday).
Pros have no offers/world after the debut (docs): the code has a pro ladder, promoter offers, asking, scouting, belts, ageing and retirement.
Ask for a fight: docs say impossible; it exists for pros only. Amateurs cannot ask.
Gym closes after 4 weeks below $0 (CLAUDE.md numbers) vs 8 weeks in code. Gym's share of a pro purse 35% (CLAUDE.md) vs 25% in code. A loss costs 3 members and 2 reputation (CLAUDE.md) vs 1 and 2 in code (stoppage 2 and 4).
Ex-pro head-coach edge: design says one extra corner call; code gives one opponent tell on file at booking. Old hand: design "cheaper camps"; code: easier weight cuts.
Roster limit "up to 8": code gives 3 places, +2 per premises tier, +1 per second coach (5 and 7 at the larger premises).
Four rail buttons plus Playbook: the Playbook is reached from the fighter page, not the rail. Docs on Fights tabs are out of date (one page).
"Coach runs it", year review and club goals, club tiers, rival gym, poaching, career clock: not in code. Overdraft has rules but no screen found. Keys 1-5 for the rail and highlights/full watch options: not found.
NOT ESTABLISHED: the exact number of moves in the Playbook; whether the 3D corner's cutman choice offers "stop it / go on"; whether the week review ever opens without a press (the owner listed it as a defect on 2026-11-08);
the owner's answer on an open-ended career and a roster of 8; whether R11 (readable reason for every swing) exists beyond the Why; crossover numbers between boxing and BJJ (left blank on purpose).
Added S409
The building: chosen once at new career, one of four gym plans, each with one small permanent edge (5% more members, 5% more show income, 3% better power and technique training, or injured boxers back 10% sooner).
The gym on Home has people in it: the club's fighters and members, working at equipment and walking the floor. More members, more people (2 to 12). Decoration only: they take no clicks.
Added S410
The shell's top bar is dark on every game screen (5.0).
Fighters > Roster (5.4) is now full-body cards on a painted gym: weight class and rank, a corner flag for the most urgent answer (Set camp, Offer, Weight, Mood low), Condition / Mood / Weight tiles, the next fight and days to it; a click opens the fighter's page. Under them, Scouted for you: up to four prospects, with Invite to a trial. A Cards / Table switch keeps the sortable table (Rank, The Road, Goal).
Fights > a bout offer (5.6) opens as a versus screen: the two boxers on a red and a blue wall, the tale of the tape (record, age, weight on the day against the limit, height, stance), the win chance and how sure it is, what a win and a loss change, Full report / Pass / Accept. Full report is the old bout page: stats against the estimate, win band, ranks at stake, the file, the terms.
The game does not hold a venue, last-five form or a fighter's reach, and there is no scouting before accepting an amateur offer.
Added S448 (code check)
The attributes in section 3 marked AGREED, NOT BUILT are in the code: scripts/rules/Attrs.gd holds the 14 abilities (Strength,
Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure; skills Accuracy, Timing, Defence, Footwork,
Inside fighting) plus Heart; the old seven (Power, Hand speed, Technique, Defence, Conditioning, Ring IQ, Chin) are kept as a summary
read from them. Punches are moves with mastery. Our own fighters have no height or reach value yet (opponents do).
The plan's step and defence answers are StrikeMap arrows: step in, step out, step back, cut off, herd, pivot out, push off, feint,
tie up, roll out. BUILT since S463 (StepMastery): each of the 10 has its own mastery bar, given at signing from Footwork; a step fires by its
bar like a punch (under Usable 30 the coach never plans it and it mostly fails). Training a step (S463, greybox): the fighter page's WHAT TO LEARN NEXT card puts ONE step or defence in the study slot; the week's pad nights raise
it about 6 a week (step back 0 to 32 in about 5 weeks); at Usable 30 it leaves the slot. One slot only. NOT BUILT: nothing takes a step past 30
(to Sharp 60), sparring gives a step nothing, and two steps cannot be learned at once.
Coaches: Luke Reid pads 74 (rating 58), Marcus Hale pads 58 / conditioning 90 (rating 74).
Units: the code counts a pad night as 240 drill units (PadWeek.PAD_NIGHT_MINUTES) for the 75 real minutes in 4.2; a sparring night shares 180
units over the moves on the fighter's cards and plan. Mastery maths uses the units.
Added S451 (code check; where this and an older line above disagree, this wins)
FireLevel is ON since S450: a planned line fires 1 use in 2 at Usable, 3 in 4 at Sharp, always at Signature. The line in 4.2 that says
"SWITCHED OFF" is out of date.
Our own fighters now have height and reach, and the fight reads them (S450). The S448 line saying they have none is out of date.
Phases come from any booked bout, camp or no camp: a bout 1 week out makes the week TAPER (WeekPhase.phase), also for an amateur bout.
Two rest rules after a stoppage loss, both in code: the 30-day suspension (Injuries) and the next bout offered 8 weeks later than usual
(Matchmaking.STOP_REST_WEEKS).
The office is a full-screen computer desktop (owner's Q-213 "A, full screen", S451): the gym's office pin opens it. Its Desktop shows what
needs you, the next four weeks (bouts, bills, dues), mail, the fighters with each one's flag, money 8 weeks ahead and the staff. Its other
apps (Mail, Schedule, Fighters, Staff, Finance, Records) are AGREED, NOT BUILT; today they lead to the existing pages.
SANDBOX (S412): the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never a fixed he or she in text or mockups.
THE DESIGN MAP TO JUDGE
LADDER1 v5: the player picks, and the card shows the whole price (S494, 2026-11-15)
Part 1 of 5. This is a full map that replaces v4. Nothing outside this page stands. The repo is still out of reach, so this is built from the pack, v4 and the two critiques, and the CHECKs are marked.
Owner, verbatim: "this is not bad that john made". John's ladder screen is now the screen the player uses, and its structure is kept: filters, columns, the "Why 60 in 100" hover, greyed rows with their reasons, the "Your boxer v the #3" card, one ASK FOR THIS BOUT button, the Rep bar and the season strip.
Owner rules kept
Q-250: the player decides, and the rules apply. There's no script and no coach's star.
S475: Rep is the currency, but it's no longer the only price on the card.
S428: amateur bouts come within 1–2 weeks, no camp; every result shows the place earned.
S448: a boxer's name is the header of that row and appears nowhere else, so no names in lines, tips or buttons.
S412: no fixed he or she.
Pack 7: nothing opens by itself.
S425: the menu table is in Part 5.
Classes: women 57/60/65/70/75 kg (70 kg by owner decision Q-S294-233, so the pack needs updating) and men 57.5/60/70/75 kg. One ladder per sex and class.
Marks: (P) is proposed, CODE is in the game per the pack, DERIVED is worked from formulas here, ESTIMATE is a hand figure the probes decide, and CHECK is for Claude.
Kept from v4 (what Dola scored 8):
the zero-sum formula and its hover sums;
the reach line;
every refusal shown before you ask, with a way to a yes;
DUCKED and OWED;
the clock and Rest until;
open offers that cancel your ask;
three cases, three different best picks;
the coach's star stays cut.
0. Words and units (John's logic points 1 and 2)
Rep is the boxer's 0–100 ladder number. It's the word on the screen the owner liked, and the currency in S475.
Gym standing is the gym's number. It's the code's gym reputation: +5 on a win, −2 on a loss, and it drives the member target and the sponsor tier (CODE). Only the label changes; the variable is untouched. This is owner question 2.
Every distance is in Rep points, never places: the reach line, the clock's 20-below rule, the DUCKED window and every chip. The reach line reads "Your reach: up to 55".
1. The rules
R1 The ladder is always open (CODE tables)
One table per region, sex and class, sorted by Rep. It's the same table World > Rankings shows.
Ranked means 4+ wins (CODE). Boxers under 4 wins sit below a line and can still be asked.
R2 Reach, in points (P)
Up: you may ask up to 10 + Rep ÷ 5 points above you, rounded down. At Rep 0 that's 10 above, at 38 it's 17 above (up to 55), and at 55 it's 21 above.
Down: no limit. But a bout 20+ points below doesn't stop the clock (R8), pays almost nothing, and carries the chip WON'T STOP THE CLOCK.
R3 What a bout pays in Rep (v4 kept; draw changed, P)
expected=
1+10
(opp−you)/25
1
	​

Winner: gains 16 × (1 − expected) × weight, and the loser loses the same.
Weights: stoppage 1.15 (plus 2 more each way), unanimous 1.0, majority 0.65, split 0.5.
Draw: each side gets 8 × (0.5 − expected). That's Dola's change, so a draw never pays like an upset win.
Rounding: rounded once, and both sides get the same whole number. Rep never goes below 0, and any shortfall is logged as "Ladder top-up".
Gap (points)	Expected	Win	Loss
−20	86%	+2	−14
−10	72%	+5	−11
0	50%	+8	−8
+10	28%	+11	−5
+20	14%	+14	−2
R4 Everything else a bout pays and costs: the card prices all of it (John's point 1, the main fix)
Line on the card	Win	Loss	Source
Rep and place	R3, and the place after	R3, and the place after	DERIVED
Members	+ the Rep won, at least 2 and at most 12	−1	Today a win is a flat +8 (CODE). Scaling it is (P), so easy wins no longer bring in members
Gym standing	+5	−2	CODE
Money	Ticket cut $450. Amateurs get no purse. Travel to an away show is −$40	Travel only	The ticket cut is CODE per the pack (CHECK it pays on every win). Travel is (P); CHECK whether the code has it, and cut the line if not
Morale	+8	−12	CODE
Training lost	1 fight week, win or lose	The same	A booked week turns TAPER: light, three rest days, no sparring (CODE). That's about −0.6 stat points (ESTIMATE, probe 14)
Layoff risk	—	"Stopped in n of 100: out 8 weeks". If a date already on the season strip falls in those 8 weeks, the line adds "would miss Regional stage 18 Apr"	The 8-week rest after a stoppage (CODE STOP_REST_WEEKS), with the 30-day suspension inside it (CHECK). n comes from the fight sim by matchup (probe 16)
Clock	"Resets the clock", or "Won't stop the clock"	The same	R8
There's deliberately no single total or EV column: the trade is a judgement about what the gym needs now.
Part 2 of 5
R5 Hard rules: the row is greyed and says why and when (CODE and P)
In the default view, these rows fold into one line, "3 in reach can't be asked now ▸".
Word	When	The row says
OUT OF REACH	Above your reach line (R2)	"Needs 6 more Rep: about one win above you"
BOOKED	They have a bout on both possible dates	"Free from 22 Mar"
RESTING	Either boxer is in the 8-week rest after a stoppage (CODE)	The date
AT THE NATIONALS	Either boxer is in a nationals run (CODE)	The date the run ends
NOT SAFE	A novice (0–10 bouts) against an open boxer (CODE; CHECK the counts)	A countdown: "Opens after 3 more bouts" (Dola)
CLUBMATE	Same gym	—
TWICE THIS SEASON	At most 2 bouts against one opponent per season. This is the only rematch rule; v4's contradiction is gone	"Opens 1 Jan"
TOO HEAVY	The code's weight forecast says your boxer misses the class on both dates. v4's 1 kg-a-week line is cut	"Start a cut: makes 60 kg by 11 Apr". The later date then opens
CAP REACHED	18 bouts this season. (P), because the cap isn't in the pack. CHECK England Boxing's rest days between bouts as the floor on how often a boxer can box	"Opens 1 Jan"
Weight between "makes it" and a miss isn't a refusal. The row keeps YES and carries the CODE Weight at risk chip, "1.4 kg to go by Fri".
R6 Will they say yes: a chance built from shown parts (the owner's screen, P)
Rows that pass R5 show Will say yes: n in 100. Hovering it gives the sum, with each part labelled in the opponent manager's terms:
Part	Value
Start	50
Their odds	+ (their expected − 50). A bout they're favoured in is attractive
Protecting (within 3 of 55, in Pro talk, or a regional stage inside 4 weeks)	−30, but only if their expected is under 60%. A protecting boxer still takes a bout they're favoured in
Your heat (your boxer has won the last 3 and gained 15+ Rep in 8 weeks), when they're 0–8 points above	−20
Their clock is running (free 6+ weeks)	+3 for each free week over 6, up to +15
Home show for them / away for them	+10 / −5
Last meeting	they won: +10; you won: −10
Limits	at least 5, at most 95
How an ask is answered:
One ask is out per boxer at a time, and the answer comes the next morning. A no costs a day of the fortnight before the show.
The answer is fixed for each pair and show date (seeded), so asking again for the same date gives the same answer, and save-and-reload changes nothing.
A no always names its biggest minus part as the reason, for example "They're protecting a regional stage spot: −30". The To raise the yes tips are the parts you can still change, for example "Ask for 11 Apr: their stage is past, +30" or "Their clock runs from next week: +3 a week".
DUCKED and OWED (v4's best rule, kept):
A no from a boxer 0–8 points above you, while your boxer has heat, is logged as DUCKED.
Two DUCKED in 8 weeks make your boxer OWED. Your next ask to anyone who ducked starts at 95 in 100, and a no then pays 3 Rep to your boxer (zero-sum, logged).
Conflict for the owner (question 1): pack 4.5 says "never a random refusal". A seeded chance with a named reason is the screen you liked. The other choice is a fixed threshold, where 50+ means yes and the number shows how far their manager leans. Everything else in this map works with either.
R7 The date: amateur bouts within 1–2 weeks, no camp (S428)
Club shows run every other Saturday (CODE). The card offers the next show (7–14 days) or the one after (21–28 days), as a two-way choice above the one Ask button.
No camp. The bout's week turns TAPER, and that's the fight week, priced on the card (R4).
R8 The clock (v4 kept, in points)
After 8 free weeks in a row, Rep falls 1 every 2 free weeks.
A week is free when your boxer isn't booked, resting, injured, suspended, in a nationals run or on chosen rest, and at least one row in reach could say yes.
A booking resets the clock, except a bout against someone 20+ points below.
Rest until <date>: up to 4 weeks, once a season.
Rivals use the same clock, and a rival with no bout for 52 weeks leaves.
R9 Offers from other gyms (CODE offers, P costs)
Who sends them: rival managers ask your boxer by the same rules. A rival above you asks down only when its own clock is running.
The three answers:
Answer	Cost
Accept	Takes that date. Any ask of yours for it is cancelled, and the offer says so
Not this show	Free once per challenger a season (Dola's "remind me later"). After that, −1 Rep to the challenger
Pass	−2 Rep to the challenger (zero-sum). That challenger sends nothing for 8 weeks
Free whenever your boxer is injured, resting, TOO HEAVY or already booked.
This changes today's free Pass (pack 4.5), and the offer row states it once: "Passing costs 2 Rep".
R10 The top of the table
Amateur tables have no mandatory and no eliminator. Both critics said so, and it matches real amateur matchmaking. The top moves through the regional stage (+5 one-off) and the nationals seeding (CODE).
Mandatory and eliminator (v4's R6) apply only on pro tables. They're seen through the Pros filter once a boxer turns pro.
Still holding from v4:
seeding: the larger of 0 and (8 + 4 × net wins + bouts), capped at 65;
the 55+ drain, shown as "Pro talk: n weeks";
one new entry a quarter;
the pro offer at 55 (ProGate), which comes back at 65 or after a regional stage win;
one-offs: regional stage +5, national title +10, hosted-show headline +3;
the season runs 1 Jan to 31 Dec, and Rep carries over;
every result shows the place earned: "+11 Rep, now ranked 5th".
Part 3 of 5
2. The screen (John's, kept as the one the player uses)
2.1 Where
It's Fights > Who do we fight?, under the offers, and opens only when clicked. World > Rankings shows the same table read-only, and a row opens the same card.
2.2 Default view: the few rows that matter (John's point 2)
Filters, as chips: In reach and Legal now are on by default. The others are Likely yes 50+, Ranked, Rivals and Pros, plus Dola's two, Beats it (plan) and Makes weight.
What In reach means: from 20 points below (the clock line) up to your reach line. Rows further below are still reachable but pay nothing, so the chip hides them.
The count line: "Showing 6 of 24 · Show all". Probe 18 targets 8 rows or fewer in 80% of opens.
Greyed rows inside reach fold into one line, "3 in reach can't be asked now ▸". When opened, each shows its word and its when (R5).
Pros appears only after the pro offer.
Rivals shows the boxers who have a rival file (CODE).
2.3 Columns (the owner's set, with sources)
Column	Example	From
Row header	the boxer's name, portrait and club, the only place the name appears (S448)	Region.gd
Rank and move	4 ▲1	Ladder
Record	9-3	CODE
Rep	44	RepLedger
Style	Counter-puncher · Beats it (your plan against that style)	CODE style; Playbook rating against it
Last	W RSC 2 · 3 wk ago	CODE results
Win chance	40–55, narrowing with tape	CODE band
Will say yes	60	R6
Win gives	+11 Rep → 3rd	R3, Ladder
Loss costs	−5 Rep · stopped 12/100	R3, probe 16
Chips	Weight at risk · WON'T STOP THE CLOCK · OWED · Pro talk 3 wk	R2, R5, R6, R10
Display rules:
Your boxer's row is slate. Every column sorts, and the default sort is Rep.
A dashed line runs across the table at the reach line, labelled "Your reach: up to 55". It moves as Rep grows (Dola).
Three ⓘ marks sit in the header: what reach is, what +8 Rep means, and why far-below bouts pay nothing. Each opens on click and can be dismissed for good. This is Dola's tutorial without anything opening by itself (pack 7).
Answered with Dola's other wishes:
Quick scout: a Study tape link on the row (CODE tape study; CHECK its cost and time).
Plain sentences for every refusal: done in R5 and R6.
The EV column is declined. A single number to sort by puts the script back, and John's point 1 is exactly that.
2.4 The card: "Your boxer v the #3"
Header: both portraits with class and record, and the title "Your boxer v the #3". No names: the row header above already carries the opponent's name.
Two boxes side by side:
WILL SAY YES: 60 in 100. Hover gives the parts (R6). Worked example: start 50, their odds +14, home show for them +10, your heat −20, their clock +6, giving 60.
WIN CHANCE: 40–55. Hover reads "Rep gap +6 · your plan beats a counter-puncher · tape: 1 of 3 habits".
IF WE WIN / IF WE LOSE (every line from R4):
	Win	Loss
Rep	+11 → 3rd	−5 → 9th
Members	+11	−1
Gym standing	+5	−2
Money	+$450 ticket cut, −$40 away	−$40 away
Morale	+8	−12
Layoff	—	Stopped in 12 of 100: out 8 weeks, would miss Regional stage 18 Apr
THE SHOW AND FIGHT WEEK:
The two dates, 28 Mar or 11 Apr, as a toggle. The show's venue and whether it's home or away.
"Fight week: TAPER, training −0.6 stat points (ESTIMATE). No camp: amateur."
The clock line.
TO RAISE THE YES: up to three tips, each one a part you can change, worded with no names. For example: "Ask for 11 Apr: their stage is past, +30" and "Win once more and your heat passes: +20".
Buttons:
one big ASK FOR THIS BOUT, the only gold thing on the screen;
small links under it: Pin as target, Study tape, and Ask for a rematch (only after a loss to this opponent, within TWICE THIS SEASON).
2.5 Above the table
The Rep bar (0–100), with your boxer's marker and three unlock marks:
Pro offer at 55 (CODE ProGate);
Sponsor (P 30): CHECK whether a boxer-level sponsor exists. K88's sponsors key off gym standing. If there's no boxer-level sponsor, this mark is cut;
Squad camp (P 45): CHECK that the code has squad selection, and cut the mark if not.
The season strip: every club show from now to 31 Dec, with your booked show, the regional stage, the nationals dates and the 18-bout count (P).
Status notes:
"Clock: free 5 wk, falls from wk 8";
"Fight weeks this season: 3";
the pinned target.
An open offer from another gym sits above the table with Accept, Not this show and Pass (R9), and the line "Accepting cancels your ask for 28 Mar" when that's true.
Part 4 of 5
A correction to 2.4's example: at a Rep gap of +6, the lines read +10 → 3rd / −6 → 9th, and members +10. Their odds part, +14, is right.
3. Three gyms, three best rows, and the full price changes the pick
How the cases are worked:
Real chance = R3's expected + a plan shift: Beats it +7, Works 0, Walks into it −7 (ESTIMATE). The 14-point span is the pack's measured gap between a good plan and no plan, 59 against 45, which answers John's logic point 5.
Averages per bout: chance × win − (1 − chance) × loss, done for each line separately. They aren't added together.
Stoppage figures are ESTIMATE until probe 16.
Case A: a new gym that's short of money; a novice at Rep 20, 6 bouts (women's 57 kg; reach up to 34)
Row	Rep, gap	Plan	Chance	Rep win / loss, average	Money, average	Members, average (v5)	Members, average (today's flat +8)	Morale, average
Pressure fighter	27, +7	Works	34%	+10 / −6, −0.6	$153	2.7	2.1	−5.2
Slugger	16, −4	Beats it	66%	+7 / −9, +1.6	$297	4.3	4.9	+1.2
Counter-puncher	6, −14	Walks into it	71%	+3 / −13, −1.6	$320	1.8	5.4	+2.2
Reading:
Under today's flat members, the lowest row wins on money, members and morale. That's John's farm.
With members scaled to the Rep won, the even Slugger wins on Rep and members and gives up only $23.
Best row: the Slugger, unless the gym needs that $23 this week.
Case B: a settled gym; Rep 38, 12 bouts, regional stage in 5 weeks (women's 60 kg; reach up to 55)
Row	Rep, gap	Plan	Chance	Rep, average	Money	Members	Morale	Stopped in
Slugger	46, +8	Beats it	39%	+11 / −5, +1.2	$176	3.7	−4.2	12 of 100 → misses the stage
Out-boxer	40, +2	Works	45%	+9 / −7, +0.2	$203	3.5	−1.0	2 of 100
Counter-puncher	32, −6	Beats it	70%	+6 / −10, +1.2	$315	3.9	+2.0	3 of 100
Reading:
On Rep alone, v4's card, it's a tie, and the higher rank makes the Slugger look right.
The full card flips it:
the Counter-puncher pays more in money, members and morale;
the Slugger carries a 12-in-100 chance of missing the regional stage, about 0.6 Rep of the +5 plus 8 idle weeks.
Best row: the Counter-puncher.
A gym racing for the pro offer can still take the Slugger, and the card shows the price.
Case C (v4's Case 3 redone from 44): a strong gym; ranked 3rd at Rep 44, 16 bouts, 11 short of the pro offer (men's 70 kg; amateur, so no mandatory)
Route	What it takes	Chance of 55	Fight weeks	Money if it all goes right	Stopped in
Ask the #1 now (Rep 54, gap +10, Works)	One win: +11 → 55	28%	1	$450	8 of 100
Two steps: the #4 (41, gap −3, Beats it, 64%, +7 → 51), then the #2 (50, gap −1, Works, 52%, +8 → 59)	Two wins	33%	2 (about −1.2 stat points)	$900	3, then 5
The yes chances decide the timing:
Today the #1 says yes at about 71: start 50 + their odds +21. Their expected is 72%, so being 1 off 55 doesn't make them protect.
From 51, the gap is +3: their expected drops to 57%, under 60, so protecting −30 applies and the yes falls to about 27.
So the shot at the #1 closes the moment you take the safer first step.
Reading:
The fast route is one bout and one fight week, at 28%.
The slow route is slightly likelier, pays double and costs a fight week, and it gives up the #1 for now.
Either can be right, and only the full card shows it.
Over the three cases
Bot	A	B	C
THINK (weighs the whole card by gym state)	the Slugger	the Counter-puncher	either, by goal
ASKUP	the Pressure fighter (−0.6 Rep, −5.2 morale)	the Slugger (stage at risk)	the #1
EASIEST / FARM	the Counter-puncher: fewer members once scaled, −1.6 Rep	the Counter-puncher (right here, by accident)	a row 20+ below: the clock runs
There are three different best rows, and in two of the three cases the best row is different with the full price than with Rep alone. That's John's test for depth.
Part 5 of 5
A correction to Case B: the Out-boxer's average morale is −3.0, not −1.0. The reading doesn't change.
4. Every menu the ladder appears on (S425)
Menu	What it shows	Wired to
Fights > Who do we fight?	Rep bar, season strip, status notes, offer row, filtered table, card, ASK FOR THIS BOUT	Ladder, RepRules, RepLedger, AskAnswer (R5 + R6), Challenge (R9), BoutPrice (R4: members, money, morale, TAPER, layoff), weight forecast (CODE), fixtures (CODE)
World > Rankings	The same table, read-only; a row opens the card	Ladder (replaces the results-only ranking after CHECK 9)
Rival file (World)	Will say yes, win gives / loss costs, and Ask	AskAnswer, BoutPrice
Fighter Overview	Rep and its place, the pinned target in NEXT STEP, the clock line, Rest until	RepLedger, Ladder.pin, Clock
Home notice board	A note for an open offer, an answer that came in, or OWED coming due	Challenge, AskAnswer
Top bar	OFFER and ANSWER flags (each opens its row); Continue stays green	Challenge, AskAnswer
Bout page (the versus screen)	Win gives / loss costs, the chance band, the weight chip	RepRules, BoutPrice, weight forecast
Fight result	"+11 Rep, now ranked 5th · +11 members · $450"; hover "Beat 28% expected · unanimous"	RepLedger, Ladder, BoutPrice
Week review	Rep changes, top-ups, DUCKED and OWED, Pass payments, fight weeks this season, drain, new entry	RepLedger, Ladder, Season
Gym / Money	Ticket cuts, travel, member changes from bouts	GameMoney, members drift (CODE)
Pro offer modal	Turn pro / Stay amateur and its two returns; turning pro opens the Pros filter	ProGate, TopRules (pro tables only)
Records	The season's final table	Season
5. Each of John's points and what was done
#	John	v5
To 10/10 1	Price every pick in everything	R4, the card, Cases A–C. Members scale with the Rep won
2	Two meanings of reputation	Rep (boxer) and Gym standing (gym), section 0. Owner question 2
3	One unit	Points everywhere (section 0)
4	Redo Case 3	Case C, from 44
5	Mandatory for pros only	R10
6	Pass rules	R9: paid to the challenger, free when unable, and says it changes today
7	TOO HEAVY	The weight forecast (R5)
8	Rematch	At most 2 per pair per season (R5)
9	18 cap	Marked (P), with the England Boxing rest days as a CHECK
10	Look B	Not done: the kit I hold is Bebas Neue / IBM Plex Mono. Owner question 5
11	S448 on rows	Per the owner: the name is the row header, and appears nowhere in lines, tips or buttons
12	Probes 13–15	Added below
13	Women's 70 kg	It's in, by Q-S294-233. The pack needs the update
14	Re-probe, then two critics	To reach 10/10
Logic 5	Plan swing too large	Capped at the measured ±7
Logic 7	Reach against NOT SAFE	Every case now gives your boxer's bout count, and NOT SAFE is a greyed row with a countdown
6. Probes (Claude builds and runs them; the numbers freeze only on a pass)
The bots: THINK, ASKUP, EASIEST, FARM, SAFE, WAIT and RANDOM, over 200 seeds of 2 seasons. v4's lines 1–5 and 8–12 are kept, and lines 6 and 7 are replaced.
#	Pass line (P)
6	70%+ of hard-rule refusals become legal within 8 weeks. Under the seeded roll, shown yes chances land within ±5 of the real rate in each band of 10
7	The amateur top moves without mandatories: ranked 1st changes hands 2+ times a season in 60%+ of seeds
13	FARM (the easiest yes every show) doesn't beat THINK on Rep, money or members over 2 seasons
14	THINK's fight weeks a season, and the stat points lost to TAPER, are reported
15	Stats at 55 are within ±5 of the stats when the code makes its pro offer today
16	A stoppage table by stat gap and style feeds "stopped in n of 100", with an error within ±3
17	In 2 of 3 cases, the best row with the full price differs from the best on Rep alone
18	The default view shows 8 rows or fewer in 80% of opens
If EASIEST still lasts past 16 weeks in more than 40% of seeds, the fall becomes −1 every week after week 10 (Dola).
7. Open questions for the owner
Will they say yes: a seeded chance, as on John's screen (this conflicts with pack 4.5, "never a random refusal"), or a fixed 50+ threshold?
Words: "Rep" for the boxer and "Gym standing" on screen for the gym's number?
Mandatory and eliminator on pro tables only? Both critics say yes.
Pass at −2 to the challenger, replacing today's free Pass?
Look: the kit (Bebas Neue, IBM Plex Mono), or the Look B John cites?
Draw at 8 × (0.5 − expected)?
CHECKs for Claude:
Ladder size per class.
Does the CODE chance include the plan?
The NOT SAFE counts.
Can offers come from a rival manager (AmateurBooking)?
Is the ticket cut paid on every win, and nothing on a loss?
Does a travel cost exist?
Is the 30-day suspension inside STOP_REST_WEEKS?
Do a boxer sponsor and squad selection exist?
What reads the 4-win ranking?
England Boxing's rest days between bouts.
What morale changes in a fight.
8. Self-score (fresh critics decide)
Depth 7: the full price flips the best row in two of three cases, and the yes chance closes windows (Case C).
General design 7: one unit, two names, one rematch rule, the weight forecast, and Pass rules that state their cost.
Play 7: the owner's screen, with a default of 8 rows or fewer.
To reach 10/10
Build in this order:
RepRules, RepLedger and Clock;
BoutPrice;
Ladder and Season;
AskAnswer and Challenge;
the bots.
Then publish probe lines 1–18, starting with 13, 16 and 17.
Get owner answers 1–6. Question 1 decides R6.
Close the 11 CHECKs. CHECK 9 comes before World > Rankings switches, and cut the travel, sponsor and squad lines if the code lacks them.
Draw the screen at 1920×1080 in the stress state, then send the drawing to two fresh critics.
The 10/10 page (1920×1080, Fights > Who do we fight?)
Top bar (0–64): dark, with the OFFER flag and Continue in green.
Header (64–140): your boxer's portrait, class and record, "Rep 38 · 8th", and the name once.
Rep bar and season strip (140–220): the 30 / 45 / 55 marks and the club shows to 31 Dec.
Offer row (220–280): Accept / Not this show / Pass, with "Accepting cancels your ask for 28 Mar".
Left (40–1180): the table.
Filter chips, with In reach and Legal now lit; "Showing 6 of 24 · Show all".
Six rows and the dashed reach line at 55. The folded line "3 in reach can't be asked now ▸".
Stress state: one Weight at risk chip, one OWED chip, one WON'T STOP THE CLOCK row, and your row in slate.
Right (1220–1880): the card, "Your boxer v the #3", from top to bottom:
the yes and chance boxes;
the win and loss table;
the show and fight week;
To raise the yes;
ASK FOR THIS BOUT, the only gold thing on the page.
Fonts and hover: Bebas Neue and IBM Plex Mono, nothing under 12, and every number opens its sum on hover.
CRITIC ANSWER: DESIGN_LADDER1_V5_CRITIC_JOHN_JOHN.md
DESIGN_LADDER1_V5_CRITIC_JOHN_JOHN - John answer (seat queue SQ201)
Brief: research/DESIGN_LADDER1_V5_CRITIC_JOHN.md
Sent: 2026-11-16 01:10 | collected: 2026-11-16 01:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.
On it. I'll score LADDER1 v5 as a fresh critic, starting with a hand check of the Rep formula, the yes-chance sums and the three cases. The owner's computer is still offline, so I can't open CRITIC_ACCESS.md or the mockups.
Logic check. I worked v5's numbers by hand. The owner's computer is offline, so no probes were run and none of the code facts could be confirmed.
These hold:
The R3 table is right. At a gap of +10 the expected chance is 28.5%, so a win pays +11 and a loss costs −5; at +20 it's +14 and −2. The corrected +6 example gives +10 / −6 and their odds part +14.
The reach lines are right: 34, 55 and 62 for Rep 20, 38 and 44.
The worked yes chance adds up: 50 + 14 + 10 − 20 + 6 = 60.
Every cell in Cases A and B is right for Rep, money, members and morale, including both corrections (−3.0 morale, and +10 / −6 at a gap of +6).
Case C holds: 0.64 × 0.52 = 33%, the #1 says yes about 71 from 44, and from 51 their chance is 57%, so protecting fires and the yes falls to 27.
What doesn't hold:
The map's own anti-farm test fails on its own money rule. R4 pays the $450 ticket cut only on a win, so farming a boxer 20 below (86% to win) earns about $387 a bout against roughly $250 for a hard pick. FARM then beats THINK on money and probe 13 fails. Gym standing (+5 flat) and morale (+8 flat) favour the farm the same way, and probe 13 doesn't even measure them. The pack says "a bout adds a $450 ticket cut", which reads as per bout, win or lose (CHECK 5). In the real world, ticket money doesn't depend on who wins. If it's per bout, the money column is the same on every row, and the "$23" in Case A disappears.
The clock's exception never applies. A week counts as free only when your boxer isn't booked, so a farm bout every fortnight keeps every week booked and the clock never runs. The rule "a bout 20+ below doesn't reset the clock" changes nothing unless those weeks still count as free.
The game has no venue. The pack (S410) says the game doesn't hold one, yet R6 uses home or away (+10 / −5) and R4 uses away travel. The map marks travel as a CHECK, but not the home or away part of the yes chance.
A no sometimes has no reason to give. At 85 in 100 with no minus parts, a no has nothing to name, which is exactly the "random refusal" pack 4.5 rules out.
The Pass rule is ambiguous two ways.
"−2 Rep to the challenger" can be read as the challenger losing 2. The offer line ("Passing costs 2 Rep") means your boxer pays 2 to the challenger, and the rule should say so.
If rivals obey the same rules, a rival saying no to your ask could count as a Pass that pays you 2. Then you could farm refusals by asking up every day. The map should state that a no to an ask pays nothing, except under OWED.
The cases treat Rep's expected chance as the real chance to win. In the game, the win is decided by stats and the plan; Rep's formula only sets the pay. The card already shows the code's win band, so the cases should use it. That gap is also the ladder's best hidden decision: a boxer whose training has outrun their Rep earns big points from the boxers above.
The ±7 plan shift is an ESTIMATE. The measured 14 points is good plan against no plan (59 against 45); bad plan is 41. The plan is also the player's own: in Case A the player would rewrite a plan that walks into the Counter-puncher. Done that way, the Counter-puncher goes to about 85%: +0.6 Rep, 2.4 members, +5.0 morale. The Slugger still wins on Rep and members, so the reading holds.
Case A ignores NOT SAFE. Your boxer has 6 bouts, so is a novice, but the case never gives the opponents' bout counts. A Rep-27 boxer is likely open (11+ bouts), which would grey that row.
Case B values the regional stage too cheaply. 0.12 × 5 = 0.6 assumes the stage is always won; the real value is 12 in 100 × the chance of winning the stage × 5, plus the road to the nationals that the stage feeds.
"Study tape" has no path for amateurs. Tape study opens tells only in a camp, and S428 removed amateur camps. The pack lists a Film evening in the week, so that's the way in.
The card leaves out the bout injury roll. About 6 in 100 boxers come out of a 3×3 bout injured, win or lose (CODE).
LADDER1 v5 scores 7 for DEPTH, 6 for GENERAL DESIGN and 7 for PLAY, so it fails the bar on general design by one point. Fixes 1 to 5 in the 10/10 list are each a line of rules, and they would clear it.
DEPTH 7. This is a real step up.
The full card makes the gym's needs and the boxer's needs pull against each other.
The yes chance makes timing matter, as Case C shows: the safe step closes the shot at the #1.
DUCKED and OWED turn a hot streak into leverage.
Fight weeks cost training, so how often to box is a real trade. At 18 bouts a season that's about −11 stat points, against the pack's 5 points = 72%.
It isn't 8 because the farm still wins for the gym on money, gym standing and morale (logic point 1), and the cases never show the most interesting pick: the boxer who is better than their Rep.
GENERAL DESIGN 6. One unit and two names are clean, and so are the single rematch rule, the weight forecast and the folded grey rows.
What holds it at 6 is four rule contradictions:
the clock exception that never applies;
the money that makes probe 13 fail;
the home or away part, which uses a venue the game doesn't have;
the Pass and ask wording.
On top of those, a no can be a reason-less refusal, and the Look question is listed as open when the owner has already ruled Look B (pack section 7).
PLAY 7. It has anticipation: the answer comes the next morning, and there's the clock note, OWED coming due, and the season strip. The upset payoff, "+11 Rep, now ranked 5th", feels earned.
It isn't 8 because rivals have no memory beyond DUCKED and a single last-meeting part. The rival gym is agreed but not built.
Options
Option	Verdict	What it changes
One ask that covers both dates	Missing	Each date has its own seeded answer, so players will ask twice anyway; one ask saves the wasted day
"Write a line" on the card's plan chip	Missing	Turns "Walks into it" into an action in the Playbook (pack 7: only actionable information)
An injury line, win or lose	Missing	Prices the 6 in 100 bout injury (CODE) that the card leaves out
Pulling out of a bout you asked for	Missing	The card prices the ask but not backing out; the $300 empty slot (CODE) is the obvious price
Pin as target linked to the goal talk	Missing	"Beat the #3 by June" becomes a goal with morale on it (CODE goals) instead of a bare pin
Ask for a rematch link	Useless	The row's own Ask already handles it under TWICE THIS SEASON; cut it
Makes weight filter	Useless	Legal now already hides TOO HEAVY, and the Weight at risk chip shows the rest
Sponsor 30 and squad camp 45 marks	Useless until confirmed	Cut them unless CHECK 8 finds them in the code
Rest until	Keep	Protects a training block from the clock, once a season
Not this show / Pass	Keep, with the wording fixed	Gives saying no a price without forcing a bout
No EV column	Agree	A single total would put the script back
Owner questions, my reading
Use a fixed threshold, not a seeded roll. Add each rival manager's temperament as a part (careful −10, normal 0, bold +10), shown after their first answer. That replaces chance with something the player learns, and it keeps "never a random refusal".
Yes to Rep and Gym standing.
Yes to mandatories on pro tables only. That matches real amateur matchmaking (CHECK).
Yes to the Pass price, worded as "Your boxer pays 2 Rep to the challenger".
Look B is already ruled by pack section 7, so this isn't an open question.
Yes to the draw rule.
To reach 10/10
Make money and standing match the game, then re-run probe 13 on all five lines (Rep, money, members, gym standing, morale).
Pay the $450 cut every bout (per pack 4.13, CHECK 5).
Scale gym standing with the Rep won: at least +1, at most +8.
Scale win morale with the expected chance: +4 at 86%, +10 at 14%.
FARM must lose on the boxer's lines and win only on the gym's money line.
Fix the clock: weeks booked for a bout 20+ below still count as free.
Write R6 as a threshold with manager temperament, so every no names its reason. With no minus parts, the answer is always yes.
Rewrite R9's wording: "Your boxer pays 2 Rep to the challenger." State that a no to your ask pays nothing, except under OWED.
Add a host gym to each club show, or cut the home or away part and the travel line. Without a venue they can't be built.
Redo the cases with the code's win band, not Rep's expected chance.
Give each opponent's bout count, and grey any NOT SAFE rows.
Add a Case D: a boxer whose stats run 5 points ahead of their Rep. That shows the ladder paying for training.
Value the regional stage as the chance of missing it × the chance of winning it, plus the nationals road.
Add the missing card lines and links:
injured in 6 of 100, win or lose;
a "Write a line" link on the plan chip;
one ask for both dates;
"Pull out: $300";
Pin as target turned into a goal.
Cut the rematch link, the Makes weight filter, and the 30 and 45 marks unless the code has them.
Make Study tape put a Film evening on the next week against that opponent, opening one tell (S428: no amateur camp).
Close the CHECKs, especially 5, 8 and 10. England Boxing's minimum days between bouts and its stoppage medical layoffs set the 18 cap and the 8 weeks (both CHECK).
Draw the page in Look B, then send it to two fresh critics.
The 10/10 page (1920×1080, Fights > Who do we fight?, Look B)
Dark top bar (0–64): the OFFER flag and Continue.
Cream whiteboard header (64–140):
your boxer's polaroid, class and record, with the name once;
"Rep 38 · 8th" in Permanent Marker.
Rep bar as a marker line (140–200): only the 55 pro mark.
Season strip as fixtures pinned on the board (200–250): your show circled in marker, the regional stage, the nationals, and "Bouts 7 of 18".
Offer note (250–300): a sticky note with Accept, Not this show and "Pass: your boxer pays 2 Rep".
Left table (40–1180), in Kalam on cream:
chips for In reach and Legal now, and "Showing 6 of 24 · Show all";
the dashed reach line at 55;
the folded line "3 can't be asked now ▸";
red only for risk: Weight at risk, stopped 12 of 100, injured 6 of 100;
your row with a slate tab.
Right card (1220–1880), a paper sheet:
"Your boxer v the #3";
the yes box ("Leans yes +10", hover for the parts, careful manager −10) and the win box (the code's band, with a "Write a line" link on the plan chip);
the win and loss lines in two columns;
one dates toggle;
To raise the yes;
one pulsing ASK FOR THIS BOUT, with Pin as goal and Study tape (Film night) as small links.
Type and hover: nothing under 14 px, and every number opens its sum on hover.
Sources: the arithmetic is DERIVED from the map and the pack. The CHECKs, from memory and not looked up this turn:
that BoxRec's rating gives more points for beating higher-rated opponents;
that amateur matchmaking pairs boxers by bout count and weight, with no mandatories;
that England Boxing sets rest periods between bouts and medical layoffs after a stoppage.
The real boxing evidence is limited to those three memory checks. I couldn't open CRITIC_ACCESS.md or the mockups, or confirm any code fact, while the owner's computer is offline.
CRITIC ANSWER: DESIGN_LADDER1_V5_CRITIC_DOLA_DOLA.md
DESIGN_LADDER1_V5_CRITIC_DOLA_DOLA - Dola answer (seat queue SQ199)
Brief: research/DESIGN_LADDER1_V5_CRITIC_DOLA.md
Sent: 2026-11-16 01:10 | collected: 2026-11-16 01:40 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.
(the brief is cut; her reply:)
.
Show More
Searched for 2 keywords · 12 sources
⚔️ LADDER1_V5 — Critic Score & Full Review
DEPTH — 8/10
Why:
✅ Meaningful trade-offs in every case: In 2 of 3 test cases, the "best" choice changes when you look at the full card vs Rep alone. No single dominant pick
✅ Multiple interacting systems: Rep gain/loss, clock pressure, money, members, morale, stoppage risk, and timing of future opportunities all pull in different directions
✅ Reach rule creates a moving window: As your Rep grows, your pool of possible opponents expands — but so does the "protecting" penalty on those above you, closing high-value windows you didn't take when you could (Case C)
✅ DUCKED/OWED adds a reputation layer beyond points: Saying no twice creates future leverage — a long-term consequence not visible on any single card
✅ Plan quality modifies win chance directly: your Playbook choices change what each opponent is worth to you — the ladder doesn't exist in isolation from your training
Where it's not 10:
The bot tests are still pending — we don't yet know if "easiest path" still outperforms smart play over a full season
No long-term rival system yet — DUCKED feels like a hint that could grow into something bigger but stays contained
GENERAL DESIGN — 8/10
Why:
✅ One consistent unit: Rep for boxer standing, Gym Standing for club reputation — no confusion on what each number means
✅ Every refusal explains itself: greyed rows name exactly why and when they'll become available again — no invisible walls
✅ Weight forecast integrated directly: TOO HEAVY doesn't just block — it tells you exactly when you can make weight and which date opens
✅ Rules align with real amateur boxing: experience protection, rest periods between bouts, no mandatory defences at amateur level
✅ Names only in headers — S448 fully respected
✅ Pro/am split clean: mandatories and eliminators appear only after turning pro — exactly as the real amateur system works
Where it's not 10:
6 open CHECKs remain unresolved — travel cost, sponsor marks, squad camp, 18-bout cap, exact chance formula, and pass cost all depend on code answers
Two conflicting design directions on "Will they say yes": seeded chance vs fixed threshold — one of these needs winning; the ambiguity confuses the whole system
No confirmation yet that the plan rating actually feeds into the win chance band — it shows on the card but may not be pulling weight behind the scenes
PLAY — 8/10
Why:
✅ The card shows the full price up front: no hidden costs — you see Rep, members, money, morale, stoppage risk, layoff length, and clock impact all in one place
✅ "To raise the yes" gives actionable steps: you don't just see a number — you see exactly what changes would improve the odds
✅ Heat/ducked/owed creates story moments: "they won't fight me now but they owe me one later" — this builds rivalries naturally without scripted events
✅ Clock pressure works: the 8-week idle drain and the 20+ point "won't stop the clock" bouts mean you can't just wait forever or farm easy wins
✅ Season strip shows the road ahead: you see nationals, regionals, and key dates — decisions feel grounded in a timeline
Where it's not 10:
No personal feel beyond the card — rival managers don't develop personalities or patterns over time
Passive progression only: you can improve yes chances by winning or waiting, but there's no "build a reputation" action beyond what happens naturally
No "decline to answer" — every offer must be responded to immediately
Summary Scores
Table
Criterion Score /10 Meets bar? (7+)
DEPTH 8 ✅ Yes
GENERAL DESIGN 8 ✅ Yes
PLAY 8 ✅ Yes
Overall: 8/10 — SOLID, above the 7+ bar on both core metrics ✅
Missing Options
"Remind me later" for offers that aren't right now — Not This Show exists but only per challenger per season; a general "check back in 2 weeks" is missing
Filter by: stoppage risk — important when timing a run at regionals
Sort by: net value — the card shows all the numbers but you can't sort the table by the combination that matters most to you right now
"Watch tape" from the table row — exists but its cost and time cost aren't confirmed
Set a target — Pin as Target exists but nothing in the UI shows you progress toward that specific opponent
Season calendar view — the strip shows dates but you can't see your whole schedule at a glance
Useless Options
❌ EV column — deliberately declined by design; this is correct, not a flaw
⚠️ Sponsor (30) and Squad Camp (45) marks — pending CHECK; remove if code doesn't support them
⚠️ Travel cost line — pending CHECK; remove if away shows don't actually cost money in code
What Each Option Changes
Table
Choice What it actually changes
Ask higher opponent Higher Rep upside, lower win chance, higher refusal chance, possible "protecting" penalty if they have a bout coming up
Ask lower opponent Safe win, small Rep gain, doesn't reset the clock, fewer members gained, no heat built
Pick later date More time to make weight, their "protecting" penalty may expire, but your clock keeps running
Accept rival offer You get the bout sooner, but it cancels your own ask for that date; your clock resets
Not this show Keeps the relationship open, but limited to once per challenger per season
Pass Clean break — costs them 2 Rep, they won't ask again for 8 weeks
Wait and build heat first Your next ask to anyone above you gets the −20 penalty removed; but if they duck you twice, they OWE you instead
To reach 10/10 — ordered by priority
🥇 1. Resolve the 6 open owner questions — Blocker
Q1 — Yes chance: seeded or fixed threshold. Pick one. If seeded, the "50–95 in 100" number is honest. If threshold, the number becomes "lean" strength indicator. Document clearly
Q2 — Words: Confirm "Rep" and "Gym Standing" as the permanent screen labels
Q3 — Pro-only mandatories: Confirm — this looks correct and matches real amateur boxing
Q4 — Pass cost: Confirm −2 Rep to challenger. If yes, update the existing offer system to match
Q5 — Fonts/visual: Choose Bebas+Plex or Look B. Apply consistently across all ladder screens
Q6 — Draw formula: Confirm 8 × (0.5 − expected). It's fair — a draw should never beat a win
🥈 2. Close the 11 CHECKs — Build dependency
Remove or keep travel cost, sponsor, squad camp, 18-bout cap, rest days between bouts, and the rest. Do not build placeholder lines — if the code doesn't have it, cut it from the screen
🥉 3. Run the full bot probe suite — Balance lock
Probe 13: Confirm FARM ≠ THINK over 2 seasons — if the easy path still wins too often, adjust the clock drain
Probe 16: Build the stoppage-risk table from actual fight data — the "n in 100" number needs to be real, not estimated
Probe 17: Confirm >66% of picks differ when using full card vs Rep-only sorting — this is the core proof the mechanic works
Probe 18: Default view ≤8 rows in 80%+ of opens — keep it clean
Add 3 missing filters — Quality of life
Add toggle filters: Low risk, Beats plan, Makes weight — one click each, no extra columns
Show "next available" when greyed out — Clarity polish
Instead of just "Free from 22 Mar", add: "Comes off rest 22 Mar · +3 yes chance from that date" — turn a wait into a plan
🖥️ The 10/10 Screen — 1920×1080 Layout
plaintext
┌─────────────────────────────────────────────────────────────────────┐
│ TOP BAR — dark shell · OFFER flag visible · Continue → green │
├─────────────────────────────────────────────────────────────────────┤
│ [PORTRAIT] YOUR BOXER · 57kg · 6-1 · Rep 38 · 8th │
│ ┌───────────────────────────────────────────────────────────────┐ │
│ │ ████████████████████░░░░░░░░░░░░░░░░░░░░░░░░ Rep 38 / 100 │ │
│ │ ●30 Sponsor ●45 Squad Camp ●55 PRO OFFER → │ │
│ │ ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ │
│ │ Jan 14 · Jan 28 ◆Regionals Apr 18 · Dec 31 Season end │ │
│ └───────────────────────────────────────────────────────────────┘ │
│ ═══ OFFER FROM ANOTHER GYM ═══ │
│ Your boxer vs the #7 · 62 yes chance · 28 Mar show │
│ [ACCEPT] [NOT THIS SHOW — Free] [PASS — Costs them 2 Rep] │
│ ┌────────────────────────────────────┐ ┌─────────────────────────┐ │
│ │ FILTERS: In reach ✓ Legal now ✓ │ │ ⓘ Reach ⓘ What Rep │ │
│ │ Likely yes 50+ Ranked Rivals │ │ ⓘ Why far bouts pay │ │
│ │ Showing 6 of 24 · ▸ Show all │ │ │ │
│ ├────────────────────────────────────┤ │ WILL SAY YES │ │
│ │ ▸ 3 in reach can't be asked now │ │ ┌─────────────────┐ │ │
│ ├────────────────────────────────────┤ │ │ 60 / 100 │ │ │
│ │ Rank Name Rec Rep Styl │ │ │ ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ │ │ │
│ │ 5 [Portrait] 8-2 46 Slug │ │ │ Their odds +14 │ │ │
│ │ 7 [Portrait] 7-3 40 Out- │ │ │ Home show +10 │ │ │
│ │ 9 [Portrait] 6-2 32 Coun │ │ │ Your heat −20 │ │ │
│ │ ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄│ │ │ │ Their clock +6 │ │ │
│ │ 15 [Portrait] 3-4 22 Pres │ │ └─────────────────┘ │ │
│ │ 22 [Portrait] 1-5 8 Volu │ │ WIN CHANCE │ │
│ │ ⚠ Weight at risk · OWED · WON'T │ │ 40–55% │ │
│ └────────────────────────────────────┘ │ Rep gap +6 · Plan: │ │
│ │ Works vs Counter │ │
│ THE CARD: YOUR BOXER v THE #3 │ │
│ ┌────────────────────────────────────┐ └─────────────────────────┘ │
│ │ IF WE WIN │ IF WE LOSE │ │
│ │ Rep +11 → 3rd │ −5 → 9th │ │
│ │ Members +11 │ −1 │ │
│ │ Gym Stand +5 │ −2 │ │
│ │ Money +$450 ticket │ −$40 travel │ │
│ │ Morale +8 │ −12 │ │
│ │ Layoff — │ 12/100 stopped → 8w │ │
│ └────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────┐ │
│ │ SHOW & FIGHT WEEK ◆ ☐ 28 Mar │ ☑ 11 Apr │ │
│ │ Home/Away: Away · Taper week: −0.6 training · No camp │ │
│ │ CLOCK: 5 free weeks → starts falling week 8 │ │
│ ├───────────────────────────────────────────────────────────────┤ │
│ │ ✅ TO RAISE THE YES: │ │
│ │ • Ask 11 Apr → their regional stage past, +30 chance │ │
│ │ • Win once more → heat fades, +20 chance │ │
│ │ │ │
│ │ ⚡ ASK FOR THIS BOUT [Pin] [Study tape] [Rematch] │ │
│ └───────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
Visual spec: Warm tan wall background, cream paper cards, marker-style headers (Bebas Neue), clean mono data (IBM Plex Mono). Gold button only for the main action — everything else flat. Hover reveals every formula; nothing opens automatically
Final verdict: This mechanic passes the bar comfortably — it already works well. The remaining work is clarification, confirmation, and polish rather than redesign. Once the open questions resolve and the probes confirm balance, it's a 9–10/10 system that players will think carefully about every single week.
I can turn this into a ready-to-use HTML mockup of the 10/10 screen for you — just tap Fast and select Pro to get it.
Chat
Create Videos
Create Images
Writing
Homework
Translate
Show More
Today 21:40
LADDER1_V6 — The player picks, and the card shows the whole price
(S494 / S459 design loop · 2026-11-17 · Replaces v5 in full)
Owner rules retained
Q-250: Player decides; no scripted outcomes, no coach's star rating
S475: Rep is currency — but not the only price shown
S428: Amateur bouts within 1–2 weeks; no camp
S448: Names appear only in row headers — never in body text, tips, or buttons
S412: Gender-neutral pronouns throughout
Pack §7: Nothing opens by itself
S425: Full menu wiring in Part 5
Classes: Women 57/60/65/70/75 kg; Men 57.5/60/70/75 kg — one ladder per sex/class
Conventions
CODE = confirmed in game files; DERIVED = calculated from agreed formulas; ESTIMATE = working figure marked for probe validation; CHECK = pending code confirmation
Part 1 — Rules & Definitions
0. Words & Units
Rep = Boxer's ladder standing (0–100). Every distance in Rep points — reach, clock limits, penalties
Gym Standing = Club reputation (CODE: +5 win / −2 loss). Label confirmed
Season = 1 Jan–31 Dec; Rep carries over
R1 — Ladder Structure
One table per region + sex + class; sorted by Rep; matches World > Rankings exactly
Ranked = 4+ wins (CODE). Boxers below 4 wins appear in the table but are separated by a dashed line
Amateur tables: no mandatories, no eliminators — these appear only on pro tables (Pros filter, unlocked at Rep 55)
R2 — Reach (Points)
Up: Ask up to 10 + floor(Rep ÷ 5) above you. Rep 0 → 10; Rep 38 → 17 (max 55); Rep 55 → 21 (max 76)
Down: No limit — but bouts 20+ points below carry WON'T STOP THE CLOCK chip: pays reduced member gain, resets clock only partially, and counts as a free week for drain purposes
Default view hides rows more than 20 below — toggle Show all to reveal
R3 — Rep Changes
Expected chance=
1+10
(oppRep−yourRep)/25
1
	​

Win: + round(16 × (1 − expected) × weight)
Loss: − round(16 × (1 − expected) × weight) (never below 0)
Weights: Unanimous 1.0 · Split 0.5 · Majority 0.65 · Stoppage 1.15 (+2 bonus each way)
Draw: ± 8 × (0.5 − expected) — capped so a draw never pays like an upset win
Zero-sum rounding — any shortfall logged as "Ladder top-up"
Table
Gap	Expected	Win	Loss
−20	86%	+2	−14
−10	72%	+5	−11
0	50%	+8	−8
+10	28%	+11	−5
+20	14%	+14	−2
R4 — Full Price Card (Every cost shown before asking)
Table
Line	Win Result	Loss Result	Source
Rep & Place	+N Rep → New rank	−N Rep → New rank	R3 / Ladder
Members	+max(2, min(12, Rep won))	−1	Scaled (was flat +8)
Gym Standing	+max(1, min(8, floor(Rep won ÷ 2)))	−2	Scaled from CODE flat +5
Money	$450 ticket cut — per bout, win or lose	$450 ticket cut	Pack §4.13 — confirmed per event
Travel	−$40 if away	−$40 if away	CHECK — remove if no venue data
Morale	+floor(4 + 6 × (1 − expected))	−12	Scaled by upset margin
Training Cost	TAPER week: approx −0.6 stat pts	TAPER week: approx −0.6 stat pts	CODE phase / ESTIMATE — probe 14
Injury Risk	Injured in 6/100	Injured in 6/100	CODE bout injury roll
Stoppage / Layoff	—	Stopped in N/100 → 8 weeks out. Highlights conflicts: "Would miss Regional: 18 Apr"	CODE STOP_REST_WEEKS / probe 16
No single "total EV" column — trade-offs are intentional judgement calls per gym state
R5 — When a Row Cannot Be Asked (Greyed, folded if >1 hidden)
Table
Status	Condition	Message
OUT OF REACH	Above R2 limit	Needs N more Rep — approx 1 win
BOOKED	Opponent has confirmed bout	Free from DD Mmm
RESTING	Within 8w post-stoppage	Returns DD Mmm
NATIONALS	Either boxer in nationals run	Returns DD Mmm
NOT SAFE	Novice (0–10 bouts) vs open (11+)	Opens after N more bouts
CLUBMATE	Same gym	Cannot box own boxer
TWICE THIS SEASON	Already met twice	Opens 1 Jan
TOO HEAVY	Weight forecast misses limit	Start cut → makes weight DD Mmm
SEASON CAP	18 bouts this calendar year	Opens 1 Jan
Within weight range but at risk → shows Weight at risk chip with kg remaining × date — still askable
R6 — Will They Say Yes? Fixed Threshold + Temperament
Replaces seeded roll — pack §4.5: "never a random refusal"
Base score 50. Each factor modifies the score. Final score ≥ 50 → Yes; < 50 → No
Every No names its single largest factor — never a blank refusal
Displays as: "Leans Yes / Leans No" with hover breakdown
Table
Factor	Effect
Their odds favour them	+floor((their expected − 50) ÷ 2)
Protecting — bout within 4w or top-3 spot	−30 (only if their expected < 60%)
Your boxer on a hot streak (3 wins / +15 Rep in 8w)	−20 if they rank 0–8 above you
Their clock idle > 6w	+3 per week, max +15
Home show for them	+10 · CHECK — remove if no venue
Away show for them	−5 · CHECK — remove if no venue
Last meeting — they won	+10 · they lost: −10
Manager Temperament (learned after 1st interaction)	Careful −10 · Normal 0 · Bold +10
Bounds	Minimum 5 · Maximum 95
Ask Mechanics
One outstanding ask per boxer at a time. Answer arrives next morning
Ask for both dates in one action — system returns separate answers for each
Re-asking identical opponent + date = identical answer (deterministic)
DUCKED: Opponent ranked 0–8 above, says No while your boxer is hot → marked DUCKED
OWED: Two DUCKED within 8w → next ask to that opponent starts at 95 score. If No then → they pay your boxer +3 Rep
R7 — Dates & Camp
Club shows run every other Saturday (CODE). Two selectable dates: Next show (7–14d) · Following show (21–28d)
Amateur bouts = no camp — fight week automatically becomes TAPER (CODE)
R8 — The Clock
Countdown: 8 consecutive free weeks → Rep falls −1 every 2 weeks
Free week definition: Not booked, not resting/injured/suspended/nationals, AND at least one legal opponent in reach
Critical fix: Bouts 20+ below count as free weeks — do NOT reset the clock
Booking resets the clock — except bouts 20+ below (partial reset only)
Rest until: One 4-week pause per season — pauses clock drain
Rivals share identical rules — inactive rivals leave the rankings after 52w
R9 — Offers From Opposing Gyms
Three responses — ambiguous wording corrected
Table
Response	Effect
Accept	Confirms that date. Your pending ask for that date is cancelled → notification shown
Not This Show	No cost, once per opponent per season. After that → Pass cost applies
Pass	Your boxer pays 2 Rep to the challenger. They will not approach again for 8 weeks
Free when your boxer is injured / resting / TOO HEAVY / already booked
A No received to your own ask → pays 0 Rep — only OWED exceptions apply
R10 — Pro Rules Only (Pros filter, Rep ≥ 55)
Mandatories, eliminators, title paths appear only on pro tables
Seeding: max(0, 8 + 4 × netWins + boutCount) → capped 65
Rep 55+ drain: −1 every 4w unbooked. "Pro talk: N weeks"
Pro offer arrives at Rep 55; returns at 65 or after regional stage win
Season carries Rep forward — final season table in Records
Part 2 — The Screen
2.1 Location & Navigation
Table
Screen	Behaviour
Fights > Who do we fight?	Full interactive ladder — default landing
World > Rankings	Identical table — read-only. Click row opens card
Rival File (World)	Shows Yes/Lean, win/loss cost, Ask button
Fighter Overview	Rep value, rank, pinned target, clock status
Home Board	Sticky note: incoming offers / answers received / OWED due
Top Bar	OFFER / ANSWER flags — green Continue always active
Bout vs Screen	Win/loss preview, chance band, weight chip
Fight Result	"+N Rep → #X · +M members" — hover shows breakdown
Week Review	Rep changes, DUCKED/OWED, season bout count
Club > Money	Ticket income, travel costs, member changes
Pro Offer Modal	Turn pro / Stay amateur — explains Pros filter unlock
Records	Season final standings archive
2.2 Layout — Fights > Who do we fight?
Visual style: LOOK B confirmed — warm tan plaster wall, cream paper cards, marker headers (Permanent Marker / Kalam), mono data (IBM Plex Mono). Gold accent only on main button
Table
Zone	Content
Header	Your boxer portrait · class · record · name once only · "Rep 38 · 8th"
Rep Bar	0–100 bar with marker. Pro gate at 55. Sponsor(30) / Squad(45) marks shown only if confirmed in code
Season Strip	All club shows → 31 Dec. Your bouts circled. Regional stage · Nationals dates · "Bouts X of 18"
Status Line	Clock: N free weeks → drain at week 8 · Target pinned if set
Incoming Offer (if any)	Sticky note: "Offer from [club] · Leans Yes 60 · 28 Mar" — [Accept] [Not This Show] [Pass: −2 Rep] · note conflict if applicable
Filters (chips)	✓ In reach · ✓ Legal now · Likely Yes 50+ · Ranked · Rivals · Pros · Beats plan · Makes weight · Show all
Table	See columns below. Dashed line at reach limit. Your row slate background. Greyed rows fold: "N in reach cannot ask now ▸"
Card (right pane)	Side-by-side win/loss breakdown. Updates on row selection
Table Columns
Table
Column	Source
Name/Portrait/Club	Row header only — names nowhere else
Rank ▲▼	Ladder position vs last week
Record	CODE
Rep	Current value
Style · Plan	Style word · Beats / Works / Walks into it link → "Write a line" in Playbook
Last	Result · Weeks since
Win Chance	Code band — plan-modified
Leans Yes	R6 threshold breakdown
Win →	Rep gain → new rank · member gain · standing
Loss →	Rep cost → new rank · injury risk · layoff conflict
Chips	Weight at risk · OWED · DUCKED · WON'T STOP · Stopped N%
2.3 — The Card
Your Boxer vs the #3 — no opponent name repeated
Table
Panel	Content
Leans Yes	Verdict + hover: breakdown of all R6 factors
Win Chance	Code band — hover: Rep gap + plan effect + scouting notes
IF WE WIN	Rep → rank · Members · Gym Standing · Money · Morale · Injury risk
IF WE LOSE	Rep → rank · Members · Gym Standing · Money · Morale · Injury risk · Stoppage chance & conflict
SHOW DATES	☐ DD Mmm / ☑ DD Mmm toggle. Home/Away. Taper note. Clock impact
TO RAISE YES	Up to 3 actionable tips — each tied to one R6 factor
BUTTONS	⚡ ASK FOR BOTH DATES (gold) · Pin as Goal · Study Tape → adds Film evening to next week · Ask Rematch (if eligible)
2.4 — Key Clarifications
Study Tape (Amateur): No camp → scouting costs 1 Film evening that week, reveals 1 opponent habit/tell
Pin as Goal: Opens Goal Talk modal: "Beat [opponent] by [date]" → ON TRACK / AT RISK with morale reward on completion
Pulling Out: Confirmed booked bout → withdraw costs $300 empty slot fee. Shown on card once confirmed
Regional Stage Value: Probability of missing × stage prize value + nationals pathway weighting — not flat 0.6 Rep
Case A Correction: Novice vs open boxer rows greyed with NOT SAFE countdown
Plan Rewrite: "Walks into it" → direct link to Playbook: rewrite that line before committing
Part 3 — Updated Test Cases
Case A — New Gym, Rep 20, 6 bouts, 57kg Women, Reach ≤ 34
FARM no longer dominates — money equal across all rows; members scale with Rep gain
Table
Opponent	Rep Gap	Plan	Win Chance	Rep ±	Members ±	Money	Morale ±	Key Risk	Best For
Pressure	+7	Works	34%	−0.6 avg	2.7 avg	$450	−5.2	Stopped 15%	High-risk, need heat
Slugger	−4	Beats	66%	+1.6 avg	4.3 avg	$450	+1.2	Low	Balanced pick
Counter	−14	Rewrite → Beats	85%	+0.6 avg	1.8 avg	$450	+5.0	Clock won't reset	Safe morale boost
Money identical across all — choice now Rep/morale/clock only
Case B — Settled Gym, Rep 38, Regional in 5w, 60kg Women, Reach ≤ 55
Regional stage valued at: 12% miss chance × (5 Rep + nationals path) = ~0.9 effective Rep at stake
Table
Opponent	Rep Gap	Plan	Win Chance	Rep ± avg	Members	Money	Morale	Layoff Risk	Value
Slugger	+8	Beats	39%	+1.2	3.7	$410	−4.2	12% → miss stage	High upside / high risk
Out-boxer	+2	Works	45%	+0.2	3.5	$450	−3.0	2%	Safe mid-tier
Counter	−6	Beats	70%	+1.2	3.9	$450	+2.0	3%	Best all-round
Full card flips decision — Slugger's stage risk makes Counter the clear pick
Case C — Strong Gym, Rep 44, Pro at 55, 70kg Men, Amateur
Protective threshold confirmed: opponent defends top-3 spot when within 4w of regional → Yes drops from 71 → 27
Table
Route	Steps	Chance 55	Time	Money	Risk	Trade-off
Ask #1 NOW	One win	28%	2w	$450	8% stoppage	Fast shot / likely miss window
Two-step	Beat #4 → Beat #2	33% total	4w	$900	3% then 5%	Slightly better odds / window closes
Either valid — card shows both paths and their full price
Part 4 — Checklist: Critic Feedback Addressed
Table
#	John's 10/10 Item	Status
1	Full pricing on every pick	✅ R4 complete — money equal across bouts, members scaled
2	Two distinct reputation systems	✅ Rep (boxer) / Gym Standing (club) — labels confirmed
3	Single unit throughout	✅ Rep points everywhere
4	Case 3 redo with closing window	✅ Case C shows protective penalty closing the door
5	Mandatories = pro only	✅ Confirmed — Pros filter only
6	Pass rule — clear wording + cost direction	✅ "Your boxer pays 2 Rep to challenger" — no Rep exchanged on rejected ask
7	TOO HEAVY = actionable forecast	✅ R5 — shows when weight made + which date opens
8	Rematch cap = 2/season	✅ R5 — clear message when next available
9	18-bout season cap	⏳ Pending CHECK — England Boxing rest days confirm
10	Visual style = Look B	✅ Confirmed — fonts, colours, layout specified
11	Names only in headers	✅ S448 — full compliance
12	Probes 13–18	⏳ Pending run — defined in Part 6
13	Women's 70kg class	✅ Added per
Today 21:42
Chat
Create Videos
Create Images
Writing
Homework
Translate
