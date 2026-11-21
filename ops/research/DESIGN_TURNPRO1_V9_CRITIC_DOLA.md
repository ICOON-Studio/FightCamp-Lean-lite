# TURNPRO1_V9 - score this mechanic's DESIGN (S459 design loop)

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
   BUILT S523 (turning pro v2): two fictional promoters. Bow Lane (ticket house: $1,500, less $25 a ticket short of 60 sold,
   floor $500, 50% of tickets past 60, debut 4 weeks out, opponent 1.0 under) and Harrow & Finch (guarantee house: $1,800,
   30% past 70, debut 6 weeks out, opponent 1.5 under). Who calls follows the debut ticket forecast (family 20 + half the
   members + 2 a win + 10 a title + 10 for topping the club's own show): within 15 of 60 both call side by side, else one.
   The offer stands 14 days (running out is not a No: the call returns after 2 more wins); no first call at 32+. One ask
   per promoter, its answer shown before pressing: later debut (+2/+4 weeks for $150/$300 off), softer opponent (and the
   next 2 offer sets are tune-ups), better split (taken 20+ over break-even, a +5 counter at 5-19, else won't), own ticket
   price (Bow Lane), costs from the purse (Harrow & Finch counter). The offer shows the gym at signing, the gym each week
   after, the boxer's money and when the gym is even again; morale on each button (a title-chaser before the nationals
   minds). The debut pays the gym 25% of the purse and of the ticket share. For the first 6 pro fights Harrow & Finch adds
   a second tune-up, Bow Lane a second step up. NEXT STEP shows tickets vs each break-even in wins, age line, declines left.
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
  shown as a band that widens when unscouted. Ask for a fight (amateurs, built S512-S518): the sheet name, a step up or a name you pick, at one of the next club shows; a host can say No with its reason, a No to a boxer ON A RUN is a DUCK, two ducks in 8 weeks and that corner OWES the bout. The door opens the day after a bout (S520); the asked show still falls after the 10-day rest, and the sheet sends its own offer when the rest ends if nothing was asked.
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
  Her mat plan (BUILT S515-S516): a hand of plan lines (a white belt holds 3), shown line by line on the open's result and counted in a season
  book ("this season N of M: works / fails"). Measured (mat_book_test, S516): a white belt tried her plan lines ONCE in four opens - with a hand
  of 3 and early losses, most opens end before a line comes up.

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

# Turning pro — design map v9 (written from the code at main 55fa5a15)

Scope: the pro offer, from the call to the debut ledger: the two houses side by side, the debut opponent gap, the purse, ticket and costs asks, Stay amateur and the lapse. The ladder after the debut is a handoff only. Method (owner S530): section 1 is written only from code opened for this map at main `55fa5a15c898741fe9bda9f1cb6051d59d8aab3e`. Every **CODE** line names the file, the function and the lines, and is true at that commit. **ESTIMATE** means a proposal, a sum worked on paper or a measured result that is not code. **CUT** means do not build or show it. Inputs: map v8, its critic (6/6/7), the critic from the earlier review (6/7/6; the v8 review queued as SQ261 has not landed, so `DESIGN_TURNPRO1_V8_CRITIC_DOLA.md` holds only the brief), `docs/TURNGAP1_RESULT.md` and `ops/research/CRITIC_PACK.md`. Godot was not run.

Words used in this map: the **ticket house** is the house that pays from the gate. The **guarantee house** pays a fixed purse. **Base sales** means the debut ticket forecast. A **gap** is the number taken off the opponent's rating, so a higher gap means an easier opponent.

## 1. What the game does today (CODE only)

### The call
- **CODE — `scripts/state/Roster.gd` `check_pro` :199–204:** while `c.pro_offer` is not empty, the function only runs the lapse check and returns. The gym has one live offer at a time.
- **CODE — `Roster.gd` `check_pro` :205–213:** the call goes to the first boxer in roster order who is `pro_ready`, has waited out any lapse, has no booked bout and is not in an active championship run. There is no queue, and nothing records who else was ready.
- **CODE — `Roster.gd` `pro_ready` :185–195:** a pro, or a boxer with 3 declines, gets no call. A national finalist with 0 declines is ready at any record. With 0 declines the gate is 7 wins and a rank of 1–3, or 9 wins. With 1 decline it is 9 wins and top 3, or 11 wins. With 2 declines only a No. 1 rank qualifies.
- **CODE — `scripts/state/ProOfferWire.gd` `make` :24–27 and `scripts/rules/ProCall.gd` `calls_open` :331–332:** with 0 declines, no offer is made at age 32 or older. With 1 or more declines the age check is skipped.
- **CODE — `scripts/rules/NextStep.gd` `road` :46–50:** the Pro offer step counts as done once `pro_ready` and the lapse wait are met. It never checks age, so a boxer aged 32 or older with 0 declines can show the step as done while `check_pro` skips that boxer every time (:208–210).
- **CODE — `scripts/rules/ProDebut.gd` `tickets_sold` :27–32 and `ProOfferWire.gd` `forecast` :19–20:** base sales are 20, plus half the members rounded down, plus 2 per amateur win, plus 10 per title, plus the club-show followers, capped at 100.
- **CODE — `ProCall.gd` `who_calls` :63–69, const `BAND` :10:** at 75 or more base sales only the ticket house calls. At 45 or fewer only the guarantee house calls. From 46 to 74 both call.
- **CODE — `ProOfferWire.gd` `make` :30–32 and `on_decline` :166–168:** after a decline, the house saved in `pro_last_house` calls alone at any forecast. `on_decline` saves `offers[0]`, and `who_calls` lists the ticket house first, so after refusing two cards the ticket house is the one that comes back.
- **CODE — `ProCall.gd` `terms` :73–95 and `ProOfferWire.gd` `make` :33:** each decline multiplies purse, step and top by 0.9 (0.81 after two), unless a title has been won since the last refusal.

### The two deals
- **CODE — `ProCall.gd` `promoters` :35–59:** ticket house: $1,500 purse, $500 step, $3,000 top, break-even 60, 50% share, 4 weeks, gap 1.0. Guarantee house: $1,800 guaranteed, $400 step, $3,000 top, break-even 70, 30% share, 6 weeks, gap 1.5.
- **CODE — `ProCall.gd` `debut_purse` :99–108:** the ticket house takes $25 off for each seat short of break-even, down to a $500 floor. The guarantee house pays its purse at any sales.
- **CODE — `ProCall.gd` `money` :112–139:** the ticket share is seats above break-even × the deal's price (default $50; :117) × the share rate. The gym's cuts of the purse and of the share are rounded separately. "Gym at signing" is those cuts minus costs. "Weekly after" is the stipend (if paid) minus an assumed $75 (const `LOST_CUT_A_WEEK` :13). `even_week` counts weeks of that weekly figure. None of this is a dated cash flow.
- **CODE — worked from `debut_purse` and `money`:** plain gross for the ticket house vs the guarantee house is $1,150 vs $1,800 at 46 base sales, $1,650 vs $1,800 at 66, and $1,850 vs $1,860 at 74. Wherever both houses call, the guarantee house pays more gross, and its gap is also bigger (1.5 vs 1.0).
- **CODE — `Roster.gd` `turn_pro` :303–310 and `debut_day` :320–321:** the opponent's rating is fixed once, at signing: the boxer's no-camp fight power minus the deal's gap. The bout is on the Saturday `debut_weeks` weeks out, and the camp never changes the opponent.
- **CODE — `scripts/rules/WeekPhase.gd` `phase` :43–51:** for a pro bout the last week is Taper, the week before it is Peak, and every earlier week is Build. Extra weeks before the debut are Build weeks.

### Signing
- **CODE — `ProDebut.gd` `start_costs` :18–24 and `Roster.gd` `turn_pro` :274–281:** the bill is a $230 licence, plus $875 medicals if the boxer has never been licensed, plus $140 if the coach has no pro licence. Cash pays it at signing unless costs are covered.
- **CODE — `Roster.gd` `turn_pro` :286–290, `signing_share` :222–223 and `scripts/rules/Loyalty.gd` `pro_share` :230–233:** under 50 loyalty the gym share is set to 10%. Loyalty then rises by 5 (const `MOVES` :61, `"turn_pro": 5`), but the share was read before that rise.
- **CODE — `Roster.gd` `turn_pro` :277, `ProCall.gd` `morale` :298–308 and `scripts/rules/Recruit.gd` `ambition` :122–126:** signing costs 5 morale when the ambition text contains "title" and `Champs.check` (`scripts/state/Champs.gd` :40–41, basic eligibility only) passes. `Recruit.ambition` never returns text containing "pro", so the +5 sign / −5 stay branch can never fire for a generated goal.
- **CODE — `Roster.gd` `turn_pro` :300 and `scripts/rules/GameMoney.gd` `athlete_payroll` :24–28, `settle_week` :59–67:** the stipend drops to 0, which lowers the payroll that accrues each week. That accrual is billed every 28 days, so the saving shows up on the next bill, not as cash each Monday.
- **CODE — `scripts/rules/DayJob.gd` `count_of` :37–40 and `scripts/state/GymSpend.gd` `gain` :99–100:** an amateur with a day job gains stats at 4/6 of the normal rate (5/6 on a half job). A pro counts 0 lost mornings, so signing restores full gain. `scripts/state/WeekData.gd` never references GymSpend or DayJob (file search), so the week plan's forecast leaves out the day-job cut.
- **CODE — `Roster.gd` `turn_pro` :301–302:** every open amateur sheet offer for the boxer is marked answered.
- **CODE — `Roster.gd` `turn_pro` :264–316 and `scripts/state/Bouts.gd` `accept` :192–210:** `turn_pro` writes the debut into `f["bout"]` (:308) without checking that the slot is empty, and `accept` never checks `c.pro_offer`. A repo search finds `pro_offer` in no amateur booking file (Bouts, AskFlow, HomeBout, ApproachWire, RivalOfferWire, LateAskWire, Champs). `HomeBout.reason` :38–45 checks pro status and an existing bout, but not the offer.

### Holding, staying, lapsing
- **CODE — `scripts/state/Needs.gd` `needs` :66–69, `flags` :166–167, `blockers` :139–140; `scripts/ui/Main.gd` `on_go` :196–200; `scripts/state/Clock.gd` `stop_now` :77–81:** the offer is a red need and a red flag. Continue opens the first blocker instead of running, and the clock stops on any blocker.
- **CODE — `Main.gd` `_unhandled_input` :283–293:** Esc closes the offer modal because it is not in the locked list. The offer stays open, and Continue opens it again.
- **CODE — `ProOfferWire.gd` `lapse_if_due` :172–184 and `ProCall.gd` `expires` :336–337:** the lapse runs only inside `check_pro`, which is called from `scripts/state/Sim.gd` `end_week` :417, `Bouts.gd` `after_fight` :456 and `scripts/state/BoutFinish.gd` `run` :214. Continue cannot move time past a red blocker, so the 14-day lapse cannot happen through Continue. When it does run, it clears the offer and sets `pro_wait_w` to wins + 2, with no loyalty, morale or decline change.
- **CODE — `Roster.gd` `decline_pro` :325–335 and `Loyalty.gd` `commit` :137–147:** Stay adds a decline, saves the house and the title count, applies morale through the ambition, and moves loyalty by −8 (clamped to 0–100). The news line comes from const `DECLINE_NEWS` :39.
- **CODE — `scripts/ui/modals/ProOffer.gd` `build` :73:** the Stay tooltip always says the house calls again after 2 more wins on 0.9x terms. With 1 decline the next gate is really a No. 1 rank (`pro_ready` :192–193), and with 2 declines the door closes.
- **CODE — `scripts/state/Leaving.gd` `_go` :94–95:** when the boxer leaves the gym, the offer is cleared.
- **CODE — `scripts/rules/Promises.gd` const `TURN_PRO` :12, `listed` :26–28, `resolve` :110–113, `can_decline_pro` :73–78:** a "turn pro" promise is defined, but nothing makes one and nothing calls `can_decline_pro`. A repo search finds only `ApproachWire.gd` `answer` :199 making a promise, and that one is show_top.
- **CODE — `scripts/state/LoyaltyWire.gd` `idle_week` :44–53:** a fit boxer with no bout counts idle weeks and loses loyalty (`no_bout`) at `IDLE_WEEKS`. Nothing pauses this for an open offer.

### The asks
- **CODE — `ProCall.gd` `ask_answers` :156–194, `ProOfferWire.gd` `ask` :74–89, `back_to_plain` :92–96:** each house allows one taken ask. A "wont" answer is not spent. Back to plain restores the terms but leaves the ask spent.
- **CODE — `ProCall.gd` `_price_entry` :242–260, `_costs_entry` :263–283, `_split_entry` :211–239:** price is for the ticket house only and costs for the guarantee house only. Split takes at 20 or more over break-even and counters at 5–19. On a first call the guarantee house only calls at 74 or below, at most 4 over its 70, so its split is always "wont". The ticket house can counter from 65 and only takes at 80 or more, where it calls alone.
- **CODE — `ProOfferWire.gd` `money` :117–129, `night` :131–141 and `ProCall.gd` `money` :117:** the price ask means $40 tickets and 15 more seats, capped at 100. At a 25% cut it adds $370 gross at 46, $270 at 66 and $230 at 74. It ties plain at 92 and loses from 93. It has no fee and no other cost.
- **CODE — `ProOfferWire.gd` `money` :119–122, `night` :133–134, `signed` :107–113; `ProCall.gd` consts :28–30 and `_costs_entry` :265; `scripts/rules/GymBills.gd` `runway_weeks` :62–67:** with costs covered, the costs plus a fee come off the purse before the split. The fee is $200 below 8 runway weeks, otherwise $100. Runway reads 999 when the week's net is zero or better. Worked at $1,245 costs, a 25% cut and the $100 fee: the gym gets +$114 and the boxer $341, against plain at gym −$795 and boxer $1,350. The boxer carries 75% of the costs.
- **CODE — `Roster.gd` `turn_pro` :293–294:** with costs covered, `pro_signed.costs` is saved as 0, so the week review ledger shows no costs.
- **CODE — `ProCall.gd` `_apply_later` :197–201, `_apply_softer` :204–208 and `Roster.gd` `turn_pro` :311:** later adds 2 or 4 weeks for $150 or $300 off the base. Softer adds 0.5 to the gap and saves 2 tune-up sets.
- **CODE — `scripts/state/ProLadder.gd` `book` :341–346 and `scripts/state/ProLean.gd` `extra` :14–17:** `book` uses up a tune-up set before it checks an asked fight. `extra` filters the offers to tune-ups only when one exists.

### The debut and the handoff
- **CODE — `BoutFinish.gd` `run` :91–92, :111–116 and `Roster.gd` `debut_night` :246–250:** the debut pays the gym its cut of sales counted on the night. Wins and titles stop rising after signing (`Bouts.gd` `day_events` :124 skips pros), so only members and followers move the count. The ledger label prints `Roster.GYM_SHARE` (25%) even when the cut paid was 10%.
- **CODE — `scripts/state/GymDeals.gd` `pro_camp` :20–35:** the debut has no camp bill, but a cutman on staff is still charged a per-bout fee.
- **CODE — `BoutFinish.gd` `run` :117–122, `ProLadder.gd` `book` :354–361 and `scripts/rules/Matchmaking.gd` `pay_of` :215–224:** later pro bouts pay the gym its share of the booked ladder pay: a $1,500 unranked base (`PURSE_UNRANKED` :49), plus rank and draw additions, plus fan tickets. `f["purse"]` rises by the contract step after a win (:121–122), but a repo search finds nothing that reads it for pay. The contract's purse, step and top are not live pay.
- **CODE — `ProLean.gd` `extra` :12–33, `line` :41–47:** for the first 6 pro fights the guarantee house adds a second tune-up and the ticket house a second step-up, but only when a distinct candidate exists. The ticket house adds no step-up after ducks or a rebuild (:22–23).
- **CODE — `scripts/ui/ProWeekLines.gd` `lines_for` :15–42, `next_line` :46–50:** for 28 days after signing, a line compares the stipend saved with an assumed $75 a week of lost cut. The weeks are clamped to 1–4, so weeks 5 and 6 of a guarantee-house wait show nothing. In the debut week the line shows the gym's share minus signing costs, then promises the contract step that the ladder does not pay.
- **CODE — `scripts/rules/StarDeal.gd` `terms` :41–44:** the yearly "lower" share is max(12%, share − 2%), so a boxer on 10% is "offered" 12%.

### What the screens show today
- **CODE — `ProOffer.gd` `build` :32–42:** the header shows the house names, the boxer's first name, the record and rank, the days left, the age line only from age 29, and the declines left.
- **CODE — `ProOffer.gd` `_tickets` :84, :90:** the debut card's title and the ticket bar use $50 and break-even 60 for both houses, even after the price ask or on a guarantee-only call.
- **CODE — `ProOffer.gd` `_house` :123–144:** each card shows the purse, the share past break-even, the weeks and the gap as "a debutant 1.0 under", the step and top, gym at signing, gym each week after, and the boxer from the debut. The button reads "Turn pro with" plus the house name.
- **CODE — `ProOffer.gd` `_ask` :149–170:** all six asks are shown in a grid, and "wont" ones are disabled with the promoter's words as the tooltip.
- **CODE — `NextStep.gd` `pro_line` :73–89:** the body text names both houses and says the guarantee house "pays from 70", although it pays its purse at any sales.
- **CODE — `NextStep.gd` `_need_for` :136–141:** the unranked sentence can print "1 more wins". The debut line always says 4 weeks after signing, even for a 6-week house or a later ask.
- **CODE — `scripts/ui/ProFights.gd` `_row` :217–221 and `Matchmaking.gd` const `GYM_SHARE` :55:** the gym's pay shows at a fixed 25%, and purse plus tickets is labelled "purse".
- **CODE — `scripts/ui/MoneyPanels.gd` `_earns` :281–285:** any booked bout shows +$450 (the amateur ticket cut), pro bouts included.
- **CODE — `scripts/ui/RosterTable.gd` `_boxer_cells` :44–46:** a pro row shows the amateur win-loss record with " pro" added, and the amateur rank.
- **CODE — `scripts/ui/areas/FighterPage.gd` `_tab` :143–144:** the contract card says "Club stipend, $250 a week, until turning pro" even for a pro.
- **CODE — `scripts/state/Career.gd` `add_news` :179–182 and `scripts/ui/areas/World.gd` `_news` :35–37:** mail news is marked own, and World > News skips own news, so the call, signing and lapse lines never reach the world feed.
- **CODE — `scripts/ui/BoutHistory.gd` `make` :40–42, `_milestone` :67–71:** the milestone header names the house, and `make` returns before the milestone when there are no rows.

## 2. What the code means for the three choices (ESTIMATE reading of section 1)

- **ESTIMATE — which house is dominated today.** Inside the two-house band, the guarantee house gives more gross at every count (CODE sum above), a bigger gap and more weeks. The ticket house's only edges are a debut 2 weeks sooner, a $500 step that is not live pay, and a step-up lean.
- **ESTIMATE (measured evidence, not code) — `docs/TURNGAP1_RESULT.md`:** with the opponent rating set the same way as `turn_pro` (night − gap), the win share was 35.5% at −4, 41% at −2, 67% at −1, 78.5% at 0, 79% at +1 and +2, 83.5% at +4 and 96.5% at +8 (20 boxers × 10 seeds per gap). Today's gaps of 1.0 and 1.5, and the softer +0.5, sit on the flat part of that curve, so they buy no measured safety. The steep part runs from −1 to 0.
- **ESTIMATE — the asks today.** The price ask is free money for the ticket house across 46–74. Covered costs moves most of the bill onto the boxer. The guarantee house's split is never available on a first call. Softer buys nothing measured. Later +4 gives little over +2. Hold is not a real option, because the red blocker forces an answer before any day passes.
- **ESTIMATE — when to turn today.** Stay is the only way to say no. Lapse looks like a free alternative (no −8 loyalty, no 0.9 terms), but play cannot reach it. Nothing in the call stops an amateur booking that collides with it.

## 3. Choice one: which house. A safer start, or an earlier and bigger gate

- **ESTIMATE — terms.** Keep the ticket house as it is. Set the guarantee house to a **$1,650** base with a **30% share above 75**. Set the gaps to **−1.0 for the ticket house and 0.0 for the guarantee house**. Keep the call band anchored at 60 ± 15. This changes `ProCall.promoters` only. The numbers it moves are `opp_gap` → the opponent's rating (`Roster.turn_pro` :306) → the fight, `purse`/`share` → `BoutFinish.run` pay → cash, and `debut_weeks` → the bout day → Build/Peak/Taper weeks.
- **ESTIMATE — plain debut money at a 25% cut, members held flat (worked from the `ProCall.money` formulas with the v9 terms):**

| Base sales | Ticket house gross / gym | Guarantee house gross / gym | Measured win share for the gap (TURNGAP1) | The trade |
|---:|---:|---:|---|---|
| 46 | $1,150 / $288 | $1,650 / $413 | 67% vs 78.5% | Guarantee: more money, safer, 2 weeks later. A thin gate should take it. |
| 66 | $1,650 / $413 | $1,650 / $413 | 67% vs 78.5% | Same money. Earlier and harder, or later and safer. |
| 74 | $1,850 / $463 | $1,650 / $413 | 67% vs 78.5% | Ticket: +$50 to the gym and earlier pay, for a harder opponent. |

- **ESTIMATE — no dominant pick:** the money crosses at 66, and above that the ticket house pays more while the guarantee house is safer. The win shares are pooled figures, not a card's chance. Show them as words ("harder start", "safer start") until section 9 calibrates a number.
- **CUT —** direct house switching, a guaranteed two-house call after a title, and win percentages on the cards.

## 4. Choice two: when to turn. Sign now, hold the offer, or free the amateur calendar

- **ESTIMATE — make hold real.** Make the offer an amber need and flag, not red, so the 14 days can actually pass. In `Sim.step_day`, before the blocker check, run `lapse_if_due` once per day (not only at `end_week`), and run it again on load and before sign or ask. The last usable day is `day < expires`. No offer is replaced on the same tick.
- **ESTIMATE — hold reserves only this boxer's calendar.** While the offer is live, `Bouts.accept`, `AskFlow.book`, `HomeBout.reason`, `ApproachWire` (before any show promise or payment), `RivalOfferWire.answer`, `LateAskWire` and `Champs.enter` refuse this boxer with "Answer the pro offer to book" and leave all state unchanged. `Roster.turn_pro` checks again that `f["bout"]` is empty. Offers already open when the call came keep their own deadlines. If one expires during the hold, it closes with no `Bouts.passed` loyalty charge and the news says it was missed. `LoyaltyWire.idle_week` pauses (does not reset) during the hold.
- **ESTIMATE — why holding costs something:** an entry or bout that needs answering inside the 14 days makes Stay worth its −8 loyalty and 0.9 terms. A quiet fortnight makes holding worth more than an early answer. Numbers it moves: loyalty (`Loyalty.MOVES` decline_pro −8), terms (`ProCall.terms`), `pro_wait_w`, and the bookings the boxer misses.
- **ESTIMATE — Stay and lapse, stated exactly.** Stay shows the real clamped loyalty change, the morale change, the next gate from `pro_ready` ("9 wins and top 3, or 11 wins" / "Only a No. 1 rank" / "No more calls"), the 0.9 terms and which house returns. The lapse shows "2 more wins after the offer runs out, then the normal call rules". This fixes the tooltip at `ProOffer.build` :73.
- **ESTIMATE — the queue.** Keep one active offer. Add `c.pro_queue` in arrival order: each entry saves the boxer id, the arrival day and the age, and is only an eligibility flag. Terms are made when the entry becomes active, and its 14 days start then. An entry that arrived before age 32 keeps the call. Skip a boxer who is booked or in a draw without losing the place. Drop a boxer who has left or turned pro (next to `Leaving._go` :94–95). Show the count on the offer header. No popup.
- **ESTIMATE — the route difference is real.** Signing ends a day-job boxer's training cut (`DayJob.count_of` :38 → `GymSpend.gain` :100: 4/6 → 6/6 of the stat gain) and ends the stipend accrual. Show "Training mornings after signing: 6 of 6 (now 4)" on the boxer strip. This is the honest day-job reason to turn sooner, and no gate needs changing.
- **CUT —** a separate "wait until the nationals" contract (Stay already covers it), an extra lapse penalty, and a guessed return week.

## 5. Choice three: what to ask for. One change per house

| House calling | Ask | Effect (v9) | Numbers it moves | Tag |
|---|---|---|---|---|
| Ticket house | Own ticket price | $40 tickets, +15 seats (cap 100), a **$45** selling fee now at a 25% cut (round(180 × cut), $18 at 10%) | gym cash now, night sales, purse and share | ESTIMATE |
| Ticket house, calling alone (75+) | Safer opponent | Gap −1.0 → −0.5 (the steep part of the curve) for $150 off the base | `opp_gap` → opponent rating; purse | ESTIMATE |
| Ticket house, calling alone (80+) | Harder for a bigger share | +10 share points and a gap of −1.5, both shown on the button | share; opponent rating | ESTIMATE |
| Either | Later debut +2 weeks | $100 off the base. Shown only when the weight plan or a recovery date differs between the two Saturdays | bout day → Build weeks; purse | ESTIMATE |
| Guarantee house | Cover costs (a loan) | $0 at signing. The balance plus the fee is repaid only from the gym's pro cuts, `min(balance, gym cut)` per paid bout. Any remainder is due from the gym when the boxer leaves or retires. The boxer's cut is unchanged | cash now; gym cut per bout; a balance on the boxer | ESTIMATE |
| Guarantee house | Safer opponent | Gap 0 → +0.5 sits on the flat part of the curve (78.5% → 79%) | none measured | CUT |
| Both | Later +4, the split counter, the guarantee-house split and price, the ticket-house cover | Clones, never available, or dominated (section 1) | none | CUT |

- **ESTIMATE — the price ask now has a downside (worked from the formulas, 25% cut, $45 fee, sales held flat):** the gym gets +$47 at 46, +$22 at 66 and +$12 at 74, ties at 84, and loses $1 at 85 and $95 at 100. The boxer gets $131–$278 more from 46 to 85, ties at 92 and loses from 93. In the two-house band its rival is +2 weeks, because a house allows only one ask. Hide the ask when the projected night range makes it strictly worse.
- **ESTIMATE — the ticket house alone at 85 base sales (gym, 25% cut):** plain $531, price $530, safer $494 at a gap of −0.5, harder share $563 at a gap of −1.5. Money and risk pull in different directions, so no single ask dominates.
- **ESTIMATE — cover as a loan, worked:** guarantee house $1,650, 25% cut, $1,245 costs, $100 fee. The debut cut of $413 repays the loan and $932 remains. The boxer gets $1,237, the same as plain. Once the loan is repaid, the gym has paid exactly the fee more than plain. Cover is for a gym that needs cash today. No loyalty charge.
- **ESTIMATE — sweep to run before shipping:** 46, 66, 74, 75, 80, 83–87, 92, 100 base sales at 25% and 10% cuts, with flat, rising (+6 members a week) and falling members, for a poor gym, a ready boxer and a boxer whose weight is at risk.

## 6. Money: one dated source, and the contract handoff

- **ESTIMATE — one helper.** A new `ProMoney.quote(c, f, deal)` returns cash out today, the next bill day and amount (`GameMoney.next_bill_day`, the accrual), the gym and boxer cuts on the booked Saturday, the loan balance after the debut, and the change to the weekly payroll. `ProOffer`, `ProWeekLines`, `MoneyPanels` (booked income), `ProFights._row` and the `BoutFinish` ledger all read it, using the boxer's actual share (`Roster.share_of`). Counterfactual amateur income stays labelled as an estimate. No break-even date is shown until it agrees with the 28-day bill.
- **ESTIMATE — the handoff.** Version new deals (`deal.v = 9`). Save the refusal-adjusted base, step and top before any one-off ask. For a versioned contract, `Matchmaking.pay_of` uses that base in place of `PURSE_UNRANKED`, keeping the rank and draw additions and the fan tickets. The base rises once per settled **post-debut** win, capped at top. A booked fight is never repriced. Old saves keep the current formula and have no step promise. Until this ships, delete the step promise in `ProWeekLines.next_line` and on the card.
- **ESTIMATE — 10% stays 10%:** `StarDeal.terms` year-lower becomes `minf(share, maxf(FLOOR, share − YEAR_STEP))`.
- **ESTIMATE — ledger:** forecast at signing → sold on the night, signing outlay, gym cut, repayment, balance left, and stipend saved vs the **estimated** lost cut. Cover the full wait (6 weeks or 8 with +2), not a clamp at 4.

## 7. Goals and the boxer, told truthfully

- **ESTIMATE —** save a stable goal at recruitment (`f.goal_kind`: title / pro / record) and mark it met when it is reached. Add the pro goal for recruits with bout experience so the existing +5 sign / −5 stay runs. Charge the title −5 only when `Champs.cannot_enter` is "" (entry open, no run this year). Show the real morale and loyalty changes, zero and clamping included, on each button.
- **ESTIMATE —** the age warning from 29 only on a first call. The first-card return lock and the separate lapse wait of +2 wins stay as they are.
- **CUT —** a separate −5% debut performance for the title goal. Morale already carries the cost.

## 8. Where it appears

| Menu | CODE TODAY (file · function · lines) | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|
| Top bar | CODE `Shell.gd` `_build_top` :152–159 → `Needs.flags` :166–167, red "PRO OFFER" outside Home | Amber flag. No countdown in the bar |
| Continue | CODE `Main.gd` `on_go` :196–200, `Clock.stop_now` :77–81: blocked by the offer | Runs while the offer is held; daily lapse check |
| Home | CODE `HomeNeeds.gd` `build` :43–55 (via `ranked`) → `Needs.needs` :66–69, red note, house names in the body (`_pro_line` :198–205), "Hear it" | Amber note: days left, no names in the body |
| Offer header | CODE `ProOffer.gd` `build` :32–42 | Days left, the exact gate after Stay, the queue count; names here only |
| Offer cards | CODE `ProOffer.gd` `_house` :103–145, `ProOfferWire.money` :117–129 | Equal cards with a card-local "Sign". Date, Build weeks, matchmaking words, cash now / on the night / boxer, from `ProMoney.quote` |
| Offer asks | CODE `ProOffer.gd` `_ask` :149–170 → `ProOfferWire.ask` :74–89: six buttons | Only the asks in section 5's table, each with its live change; spent state; back to plain |
| Offer tickets | CODE `ProOffer.gd` `_tickets` :83–99, fixed $50 / 60 | Per-house break-even marks, the deal's price |
| Boxer strip | none (CODE: morale only in button text, `_mood` :173–174) | Goal and morale, training mornings after signing, stipend that ends |
| Offer footer | CODE `ProOffer.gd` `build` :54–79 → `RosterActs.act` "declinepro" :88–91 → `Roster.decline_pro` | Stay with the gate and terms. Review later (closes, keeps everything). A link to the week plan |
| Fighter → Next Step | CODE `FighterPage._road_input` :323–339 → `NextStep.road` :15–68, `pro_line` :73–89 | "Offer open · N days" when the offer belongs to this boxer, an age check on the step, singular/plural, no names |
| Fighter → contract | CODE `FighterPage._tab` :143–144, fixed stipend text | Pro share, house in the header, loan balance |
| Roster table | CODE `RosterTable._boxer_cells` :44–49 | Pro record and world rank for a pro |
| Money → stipends / booked | CODE `MoneyPanels._fighter` :241–264, `_earns` :281–285, `_stipend_card` :360–369 | Pro quote from `ProMoney.quote`, net of the loan |
| Fights → ladder | CODE `ProFights._row` :217–221, `ProLean.line` :41–47 (names the house in the body) | Actual share, "pay" not "purse", no names in the body |
| Week review | CODE `ProWeekLines.rows` :62–75 / `lines_for` :15–42 | The full ledger in section 6, no step promise |
| History | CODE `BoutHistory._milestone` :67–71, `make` :40–42 | The milestone even with no rows; house in the header only |
| News / mail | CODE `Career.add_news` :179–182; `World._news` :35–37 filters it out | Keep it in mail and Records. CUT a world-feed copy |
| Office desktop | CODE `OfficeDesk.gd` icon table :39 maps "prooffer" to the contract icon | No change |
| Toasts | CODE `RosterActs.act` :73–91 | No names; the debut date |

## 9. Evidence to collect before any number goes on a card (ESTIMATE)

- **ESTIMATE —** 200+ paired real-path debuts per house, on the same boxers and seeds. Book through `turn_pro` and run the real camp to settlement. Split by day job, readiness and weight risk, and include draws and cancellation. Expected order: roughly 62–72% for the ticket house and 75–83% for the guarantee house (from the TURNGAP1 points at −1 and 0). Calibrate on separate bouts, and show a range only where reliability is within 10 points. Otherwise use words.
- **ESTIMATE —** test cases: a near-deadline title entry (Stay should win), a quiet fortnight (holding should win), a fit early debut (signing should win), and a cash-short guarantee call (cover should win). Pick rates are there to find dominance, not to hit a quota.
- **ESTIMATE —** state tests: last day and reload, a double press on Sign, a pre-existing amateur offer, a show promise during the hold, age 31→32 while queued, leaving before and after the debut with a loan open, and a 10% share through talks and timeout.

## 10. The critics' lists, answered

### The v8 critic's nine points (6/6/7)
| # | Point | v9 answer |
|---|---|---|
| 1 | Make the hold playable and fair | ESTIMATE §4: amber need, daily lapse, write-path guards in seven named files, the `turn_pro` bout check, idle pause |
| 2 | Queue other boxers | ESTIMATE §4: `c.pro_queue`, the clock starts on activation, the age at arrival is kept |
| 3 | One dated money source | ESTIMATE §6: `ProMoney.quote`, the 28-day bill, cover as a loan, departure and retirement settle the loan |
| 4 | The contract handoff | ESTIMATE §6: versioned base in `pay_of`, post-debut step, no repricing, the step promise deleted until it ships |
| 5 | Asks that differ | ESTIMATE §5: per-house table, the fee, single-house risk asks, +2 kept, +4 cut, a sweep list |
| 6 | Training and forecasts as one calculation | ESTIMATE: `WeekData.plan_of` applies `GymSpend.gain`'s day-job share (CODE gap in §1). Until then the +2 ask shows only weight and recovery facts, and the strip shows mornings, not stat forecasts |
| 7 | Truthful goals and gates | ESTIMATE §7 and §4: stable goal, `cannot_enter`, exact gates, age line on first calls only, fixed tooltip |
| 8 | 200-bout paired validation | ESTIMATE §9 |
| 9 | Finish the surfaces | ESTIMATE §8: each leak in §1 has a row |
| — | Its ten missing interactions | All ten are covered by points 1–9 above. The show promise is the `ApproachWire` guard, the 10% rise is `StarDeal.terms`, and the names are the §8 rows |

### The earlier critic's list (6/7/6)
| Point | v9 answer |
|---|---|
| Review later, no penalty | ESTIMATE §4 (it works only once the offer is amber) |
| Hide the dead asks | ESTIMATE §5: shown only when available and different, the rest CUT |
| Explicit expiry and decline rules | ESTIMATE §4 exact lines, using the real gate, not "2 more wins" for every case |
| Fix lapse beating Stay | ESTIMATE §4: lapse costs time and the calendar is held; Stay frees bookings now. CUT the extra lapse penalty |
| Boxer strip: goal, route, gate | ESTIMATE §4, §7, §8 |
| Night forecast on the delay ask | ESTIMATE: two scenarios (members flat; members drifting, at most +6 a week) on +2 only; +4 CUT |
| Price warning on the button | ESTIMATE §5: crossover with the fee, from the live forecast |
| Real numbers on cover | ESTIMATE §5: loan balance, fee tier and runway shown |
| Career lean on each card | ESTIMATE §8: one line per card, no names in the body, "when a candidate exists" |
| Win chance range | CUT until §9 calibrates it. `docs/TURNGAP1_RESULT.md` shows the signing read (45.3% / 50.5%) is below the measured win share (67% / 78.5%) |
| Decline ladder visible | ESTIMATE header and Stay button |
| Link to the week | ESTIMATE footer link |
| Forecast vs night in the review | ESTIMATE §6 ledger |
| Fix the ambition wiring | ESTIMATE §7 (a saved goal, not a one-string change that would flip with the record) |
| Missing: day-job status | ESTIMATE §4: real mornings 4/5/6, from `DayJob.count_of` |
| Useless: softer, split, +4 | Softer and split are kept only for the ticket house calling alone, where they change risk on the steep part of the curve; +4 CUT |

### Earlier versions (carried from v8 §7, rechecked against the code)
- **ESTIMATE —** the v4–v7 requests keep their v8 decisions: equal cards, no column swap, price from the deal (CODE `ProCall.money` :117), the age warning from 29, cover stops being a subsidy, no early-gate badge for day jobs (CODE: no such gate in `pro_ready`), and History and Week review carry the milestone.
- **ESTIMATE —** the brief's rule 2 names "the v4 critic". This map reads that as the critics named in the brief's inputs and answers their lists above. The v4–v7 points are carried here.

## 11. Owner rules kept
- **ESTIMATE (rules, not code) —** names only in headers (S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"). Gender-neutral game text (S412). Scope ends at the debut, and the handoff only pays what was signed (S428). No new screen. Only actionable information (S425: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it"). A 14-day offer. A Taper week before the fight. One top bar and one modal; nothing opens by itself. Everything ships switched on. Hover explains every number, and costs are visible without hover.

## 12. The offer at 1920×1080 (ESTIMATE)
- **ESTIMATE —** the existing warm-wall modal, 1240 wide with two cards (CODE `ProOffer.build` :28). Header: boxer and house names, days left, declines left and the next gate, queue count. Ticket bar with both break-even marks. Two equal cards, each showing: date and Build weeks, matchmaking words, cash out today, gym on the night, boxer on the night, the one ask with its live change, and Sign. Strip: goal and morale, training mornings after signing, stipend that ends. Footer: Stay amateur (gate, terms, loyalty), Review later (closes and keeps everything), the week-plan link. No second modal, no win percentages.

## 13. Cut list
- **CUT —** Later +4. The split counter. The guarantee-house split, price and safer asks. The ticket-house cover. Win percentages on the cards. Direct house switching. An extra lapse penalty. The world-feed copy of the call. A −5% debut performance for title goals. A separate nationals hold. A guessed return week.
