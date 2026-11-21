# TURNPRO1_V10 - score this mechanic's DESIGN (S459 design loop)

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
- Each fighter has a class limit (amateur, from Data.gd: women's 57/60/65/70/75 kg, men's 55/60/70/75 kg; the pro ladder groups them by ProLadder.division_for). Weigh-in is the day before. Diet Hold/Cut and training burn move weight;
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

# Turning pro — design map v10 (written from the code at main b47d9ad57)

S534, TURNPRO10 side console. Scope: the pro offer, from the call to the debut's money. The pro ladder after the debut is a handoff only.
Method (owner S530/S531: maps come from the code): section 1 is written only from files opened for this map at main `b47d9ad5766dba7c09e96333616584f9e877efc9`. **CODE** = file, function, lines, true at that commit. **ESTIMATE** = a proposal, a sum worked on paper from the code's formulas, or a measured result that is not code. **CUT** = do not build or show it. Godot was not run. No game file was changed.
One file differs in the working tree: `scripts/ui/modals/ProOffer.gd` carries another session's uncommitted edit (the debutant's name moves from the Debut row to a "VS NAME" line in the card head). Line numbers below are the committed file.
Inputs: map v9; its two critics (John 6/6/7, Dola 7/8/7); `docs/TURNPRO6_RESULT.md` (66,000 played bouts); `docs/DEBUTPICK1_RESULT.md` (13,200 played bouts). Prior research run: `python ops/Tools/prior_research.py turning pro debut offer` (v1-v9 and their critics; this map follows v9 as corrected by TURNPRO6 and DEBUTPICK1).

Words: the **bigger gate** = Bow Lane, the house that pays from tickets. The **safer start** = Harrow & Finch, the house that guarantees the purse. **Sales** = the debut tickets the boxer would sell today. **Gap** = rating points the debutant sits under the boxer (a higher gap is an easier night).

## 0. What changed since v9, in six lines
1. BUILT: each house picks the debutant to fit the boxer (aim 60 in 100 and 75 in 100). v9's fixed gaps and every TURNGAP1 number are gone.
2. BUILT: the card shows the win chance of the bout as it will be fought, and names the debutant and why the house picked them.
3. BUILT: morale is off the buttons; one MORALE line gives the reason.
4. STILL TRUE: the offer cannot be held (it blocks time), the safer start pays more at every sales count where both call, four of six ask buttons are free or dead, the contract's step and top are promised but never paid.
5. v10's core change: make the two houses a real fork (section 3), cut the asks to three a house with a price each (section 4), make the hold real (section 5), show three honest money numbers (section 6).
6. v10 drops v9's loan, queue, versioned contract pay and `ProMoney.quote`: each was a new system for a one-night decision. The cheaper answer is in sections 5-6.

## 1. What the game does today (CODE only)

### The call
- **CODE — `scripts/state/Roster.gd` `check_pro` :200-214:** one offer at a time. While one is open the function only runs the lapse check (:201-205). Otherwise the first boxer in roster order who is `pro_ready`, has waited out a lapse, has no bout booked and is not in a championship run gets the call (:206-214). Called from `Sim.end_week` (`scripts/state/Sim.gd` :415), `Bouts.gd` :457 and `BoutFinish.gd` :219 only.
- **CODE — `Roster.gd` `pro_ready` :186-196:** a pro or a boxer with 3 declines gets none. A national finalist with 0 declines is ready at any record. 0 declines: 7 wins and rank 1-3, or 9 wins. 1 decline: 9 wins and rank 1-3, or 11 wins. 2 declines: rank 1 only.
- **CODE — `scripts/state/ProOfferWire.gd` `make` :25-41, `scripts/rules/ProCall.gd` `calls_open` :331-332:** no first call at 32 or older (a boxer who has declined is not age-checked). `scripts/rules/NextStep.gd` `road` :50 never checks age, so the Pro offer step can show done for a boxer who will never be called.
- **CODE — `scripts/rules/ProDebut.gd` `tickets_sold` :27-32, `ProOfferWire.forecast` :20-21:** sales = 20 + half the members + 2 a win + 10 a title + club-show followers, capped at 100.
- **CODE — `ProCall.who_calls` :63-69:** 75 or more: the bigger gate alone. 45 or fewer: the safer start alone. 46 to 74: both.
- **CODE — `ProOfferWire.make` :31-33, `on_decline` :181-183:** after a Stay, one house calls alone at any sales count: `offers[0]`, which is the bigger gate whenever both called (list order, not a rule).
- **CODE — `ProCall.terms` :73-95:** each decline multiplies purse, step and top by 0.9, unless a title came since.

### The two houses
- **CODE — `ProCall.promoters` :35-59:** bigger gate: $1,500 purse, break-even 60, 50% of tickets past it, debut 4 weeks out. Safer start: $1,800 guaranteed, break-even 70, 30% past it, debut 6 weeks out. Each also carries step, top and a fixed `opp_gap` (3.0 / 6.0) that the pick below replaces.
- **CODE — `ProCall.debut_purse` :99-108:** the bigger gate loses $25 a seat under 60, floor $500. The safer start pays in full at any sales.
- **CODE — `scripts/rules/DebutPick.gd` `AIM` :15, `NOISE` :17, `target` :34-36, `pick` :48-67, `apply` :71-78; called from `ProOfferWire.make` :38:** when the promoter calls, each house searches the gap (6 over to 14 under, steps of 0.1) until the card's own read sits on its aim for THIS boxer: 60 in 100 for the bigger gate, 75 in 100 for the safer start, each moved up to 4 points by a misjudgement fixed by boxer, house and day. The offer keeps `opp_gap`, `opp_target`, `opp_picked`, `opp_day`.
- **CODE — `scripts/rules/DebutRead.gd` `card` :17-24:** the shown chance reads the same debutant the bout will have (`DebutOpp.make`) through `BoutRead.round_edges` on a 4-round card (`CardOdds.result`), the boxer as today on the usual camp. It does not count the camp weeks still to come, and it does not read `debut_weeks`.
- **CODE — `scripts/rules/DebutOpp.gd` `make` :37-41, `rating` :32-33, `name_for` :22-24, consts :15-17:** the debutant is a 0-0 boxer-puncher ("Heavy right hand", "Fades after round 3"), rated the boxer's no-camp strength less the gap. The name comes from the offer's day and the house, so two houses put up two debutants.
- **CODE — `Roster.gd` `turn_pro` :305-309, `debut_day` :319-320:** signing books that debutant (the deal's gap and `opp_day`; the rating is taken from the boxer's stats on the signing day) for the Saturday `debut_weeks` out, 4 rounds.
- **CODE — `scripts/state/ProLean.gd` `LEAN_KIND` :8, `extra` :12-33:** for the first 6 pro fights the safer start adds a tune-up to each set of offers and the bigger gate adds a step up.

### Signing
- **CODE — `ProDebut.start_costs` :18-24, `Roster.turn_pro` :275-282:** the gym pays at signing: $230 licence, $875 medicals if never licensed, $140 if the coach has no pro licence ($1,245 at most), unless the costs ask was taken.
- **CODE — `Roster.signing_share` :223-224, `turn_pro` :288-291, `scripts/rules/Loyalty.gd` `pro_share` :230-233, `MOVES` :61:** the gym keeps 25% of the boxer's money; under 50 loyalty an outside manager signs the boxer and the gym keeps 10%. Signing then adds 5 loyalty, after the share was read.
- **CODE — `ProCall.morale` :298-308, `ambition_kind` :312-318, `scripts/rules/Recruit.gd` `ambition` :122-126, `ProOfferWire.morale_line` :162-170:** at the call a boxer's goal reads "A regional title within a year" (potential 78 or more) or "A winning record by the summer". Only the title goal moves morale: signing costs 5 when the boxer could still enter the nationals (`Champs.check`, `scripts/state/Champs.gd` :40-41). No goal contains "pro", so the +5 sign / -5 stay branch (:300-301, and the second sentence of `morale_line` :170) never runs.
- **CODE — `Roster.turn_pro` :301-303, `scripts/rules/DayJob.gd` `count_of` :37-40, `scripts/state/GymSpend.gd` `gain` :99-100:** the stipend ends, open amateur offers are closed, and a boxer with a day job trains 6 mornings of 6 again (was 4, or 5 on a half job).
- **CODE — `Roster.turn_pro` :307 and `scripts/state/Bouts.gd` `accept` :192-211:** `turn_pro` writes the debut over `f["bout"]` without checking it is empty, and `accept` never looks at the open pro offer. A boxer can take an amateur bout while the offer is open and lose it on signing.

### The asks (one a house)
- **CODE — `ProCall.ask_answers` :156-194, `ProOfferWire.ask` :76-90, `back_to_plain` :94-98, `scripts/ui/modals/ProOffer.gd` `_ask` :167-188:** six buttons a house, each with "will take it", "counters" or "won't" (a won't button is disabled, `UI.button`'s fourth argument, and is not spent).

| Ask | Bigger gate, sales 46-74 | Safer start, sales 46-74 | What the code does (CODE) |
|---|---|---|---|
| Later +2 weeks | takes | takes | `_apply_later` :197-201: $150 off the purse, 2 more weeks. The card's win chance does not move (the read ignores weeks) |
| Later +4 weeks | takes | takes | $300 off, 4 more weeks |
| Softer opponent | takes | takes | `_apply_softer` :204-208: gap +0.5, free, and the next 2 sets of pro offers are tune-ups only (`ProLean.extra` :14-17; `ProLadder.book` :341-342 spends a set even on a fight the player asked for) |
| Better split | won't under 65, counters +5 share points at 65-74, free | won't (`_split_entry` :211-239 needs 5 over its break-even of 70; it calls at 74 or less) | takes (+10 points, gap -0.5) only at 80+, where the bigger gate calls alone |
| Own ticket price | takes: $40 tickets, 15 more seats, free (`_price_entry` :242-260; `ProOfferWire.money` :125) | won't | |
| Costs from the purse | won't | counters (`_costs_entry` :263-283): the promoter pays the signing costs and takes them plus $100 ($200 under 8 weeks of runway, `GymBills.runway_weeks` `scripts/rules/GymBills.gd` :62-67) off the purse before the split (`ProOfferWire.money` :122-124, `night` :135-136) | |

### The offer screen
- **CODE — `ProOffer.gd` `build` :35-45:** header: "A CALL FROM (house names)", "TURN (first name) PRO?", then one line: record and rank, days the offer stands, the age line (`ProCall.age_line` :322-327), declines left.
- **CODE — `ProOffer._tickets` :90-106, `ticket_parts` :204-219:** one ticket bar, who buys, one break-even mark at 60 (the safer start's 70 is not drawn).
- **CODE — `ProOffer._house` :110-163:** per house: badge and name; Debut purse; Ticket share past the break-even and seats sold today; "Debut, N weeks out: (debutant's name), picked as a winnable first night / picked to test your boxer" (`DebutPick.line` :88-91) with a hover (`DebutPick.tip` :96-100: threat, weakness, "Spend the ask on a softer opponent"); "Win chance: about N%, a draw N%" (:147); "After the debut: +$ a win, up to $" (:148); "The gym at signing" (:154, the night's cut minus today's costs in one number); "The gym each week after" (:155, the stipend minus an assumed $75, `ProCall.LOST_CUT_A_WEEK` :13); "The boxer from the debut" (:156); the pays-back sentence (:158, `ProCall.pays_back_line` :143-147); the asks; "Turn pro with (house name)" (:160).
- **CODE — `ProOffer.build` :56-69:** what the gym pays at signing, itemised; WHAT ENDS (stipend, amateur bouts, the club ticket cut); the 10% line under 50 loyalty.
- **CODE — `ProOffer.build` :72-81:** the MORALE line when morale moves; "Stay amateur" with a tooltip that always says "the same house calls again after 2 more wins, on 0.9x terms". After one Stay the real gate is 9 wins and top 3, or 11 wins; after two it is rank 1; after three the door is closed (`pro_ready` above).

### Holding, staying, lapsing
- **CODE — `scripts/state/Needs.gd` `needs` :67-70, `flags` :167-168, `blockers` :140-141; `scripts/ui/Main.gd` `on_go` :195-199; `scripts/state/Clock.gd` `stop_now` :79-83:** the open offer is a red need and a red top-bar flag. Continue opens it and time does not pass.
- **CODE — `ProOfferWire.lapse_if_due` :187-197, `ProCall.expires` :336-337:** the 14-day lapse runs only inside `check_pro`, which needs a week to end or a bout to finish. Since time is blocked, the lapse and the "14 more days" on the card cannot be reached by playing.
- **CODE — `Roster.decline_pro` :324-334, `Loyalty.MOVES` :61:** Stay adds a decline, saves the returning house, applies morale by the goal (0 today for every goal that exists) and costs 8 loyalty.
- **CODE — `scripts/state/LoyaltyWire.gd` `idle_week` :44-53, `IDLE_WEEKS` :19:** a fit boxer with nothing booked loses 3 loyalty every 4 Mondays. It does not pause for an open offer.
- **CODE — `scripts/rules/FighterProfile.gd` :25, `scripts/rules/AskDates.gd` `wait_words` :119-122:** "a month without a fight costs 6 morale" is a table entry and a sentence on the ask screen; a search of `scripts/` finds nothing that applies it. There is no such loss to pause.
- **CODE — `scripts/state/Leaving.gd` `_go` :94-95:** a boxer who leaves takes the offer away.

### The night and after
- **CODE — `scripts/state/BoutFinish.gd` :92, :111-116, `Roster.debut_night` :247-251, `ProOfferWire.night` :133-142:** the debut pays on the seats counted ON THE NIGHT (members and followers as they are then), not the offer's count. The gym is paid its cut of purse and ticket share; the ledger label prints 25% even when the cut was 10% (:114-115).
- **CODE — `BoutFinish.gd` :94-106, `scripts/rules/BoutRules.gd` :114-123:** a debut win brings 8 members and 5 reputation; a loss costs 1 member and 2 reputation (2 and 4 when stopped). The same for both houses.
- **CODE — `BoutFinish.gd` :117-122, `scripts/state/ProLadder.gd` `book` :354-361, `scripts/rules/Matchmaking.gd` `pay_of` :215-224, `PURSE_UNRANKED` :49:** later pro fights pay from the ladder ($1,500 unranked base plus rank, draw and fan tickets). `f["purse"]` steps up after a win (:122) but nothing reads it for pay. The contract's step and top, shown on the card (:148) and promised in the week review (`scripts/ui/ProWeekLines.gd` `next_line` :46-50), are never paid.
- **CODE — `ProWeekLines.lines_for` :15-42, `scripts/ui/modals/WeekReview.gd` :152:** for 28 days after signing the review shows "amateur cut lost / stipend saved" with the assumed $75 a week; in the debut's week a ledger line (gym share, costs, net).
- **CODE — `scripts/state/GymDeals.gd` `pro_camp` :22-35:** the debut has no camp bill; a cutman on staff is still charged.

### The money today, worked from the code (ESTIMATE: sums from `debut_purse` and `ProCall.money` at a 25% cut)
| Sales | Bigger gate: gym / boxer | Safer start: gym / boxer | Bigger gate + own price (free today): gym / boxer |
|---|---|---|---|
| 46 | $288 / $862 | $450 / $1,350 | $380 / $1,140 |
| 56 | $350 / $1,050 | $450 / $1,350 | $430 / $1,290 |
| 60 | $375 / $1,125 | $450 / $1,350 | $450 / $1,350 |
| 66 | $413 / $1,237 | $450 / $1,350 | $480 / $1,440 |
| 74 | $463 / $1,387 | $465 / $1,395 | $520 / $1,560 |

- **ESTIMATE — the fork has one answer today.** The safer start pays more at all 29 sales counts where both call, wins 15 in 100 more often, and a debut win is worth 8 members (about $65 a week in dues at $35 a month). The bigger gate only wins with its free price ask, from 61 sales up, by $5 to $55 for the gym.
- **ESTIMATE — the asks have one answer a house today.** Bigger gate: own price is free money at every count in the band and beats the split counter everywhere. Safer start: softer is free, and the costs ask moves about $900 from the boxer to the gym at no cost the gym feels (plain: gym -$795 after the night, boxer $1,350; covered: gym +$114, boxer $341).

## 2. Evidence (ESTIMATE: measured, not code)
- `docs/TURNPRO6_RESULT.md`: 10 boxers, 66,000 played bouts. About 4.7 points of win share a rating point; 2 more camp weeks are worth about 2 points; the fixed read is within 5 points of played bouts in 57 of 60 cells on fight night.
- `docs/DEBUTPICK1_RESULT.md`: 11 boxers, 13,200 played bouts. Picked: the bigger gate plays 58.7 in 100 (52 to 69 by boxer), the safer start 78.5 (72 to 85). 18 of 22 cells within 7 points of the target. The owner on the safer house's 78: "78 is fine". Left open there: a newcomer still growing reads low on the card (the camp builds the tank and a new punch).

## 3. The fork: two houses, no right answer (ESTIMATE)
The human question (the brief): which contract gets THIS boxer to a second fight with money in the club?

| Lever | Today (CODE) | v10 | Why |
|---|---|---|---|
| Safer start's purse | $1,800 guaranteed | **$1,400 guaranteed** | The money now crosses at 56 sales: below it the safer start pays more, above it the bigger gate does (by $63 for the gym and $187 for the boxer at 66; $98 and $292 at 74) |
| A debut win's crowd | 8 members, either house | **bigger gate 10, safer start 8** | 0.60 x 10 = 0.75 x 8 = 6 members expected: the same on average, the bigger gate swings wider. Without this the safer start's 15 points are worth about $10 a week for good and it dominates again inside two months |
| The boxer's wish | none | **one wish a boxer, in the MORALE line** | Below |
| Aims | 60 and 75 in 100 | unchanged | Owner: 70-80 for the safer house, "78 is fine" |
| Weeks out | 4 and 6 | unchanged | The bigger gate reaches the ladder 2 weeks sooner |
| First 6 pro fights | step ups / tune-ups | unchanged, said on the card in a few words | It is the long tail of the choice |

**The boxer's wish (replaces John's "lean", uses only saved fields).** A boxer working a day job (`day_job`) wants **the bigger purse on the night** (whichever card shows more for the boxer). A boxer with the title goal (potential 78+) wants **the test**. Any other boxer wants **the winnable first night**. Signing the wished house: morale +5. Signing the other: morale -5, loyalty -3. Where only one house calls there is no wish. It is written once, in the existing MORALE line ("Your boxer wants the test. That offer: morale +5. The other: morale -5, loyalty -3."), never on a button (owner S534). The existing title rule (signing costs 5 morale while the nationals are open) stays and is said in the same line.

**Who should pick what (the design intent the sweep must confirm):**
| Sales | Money says | A boxer who wants the test | A boxer who wants the winnable night | A boxer on a day job |
|---|---|---|---|---|
| 46-49 | safer start (even against the priced ticket ask) | split: wish against money and safety | safer start, clear | safer start |
| 50-56 | safer start plain; bigger gate with its ticket ask | bigger gate | split | whichever pays the boxer more: the bigger gate with the ask |
| 57-74 | bigger gate | bigger gate, clear | split: wish and safety against money | bigger gate |

No house is right across the band; the clear cells are at the ends, where one house nearly calls alone anyway.

## 4. The asks: three a house, each with a price, each best somewhere (ESTIMATE)
Only asks the house will grant are drawn. No "won't" buttons. Each button shows its price and the card's numbers after it (the win chance through `DebutRead.card` on the ask's terms, the money through the same sums as the card), before it is pressed.

| House | Ask | Today (CODE) | v10 | Best pick when |
|---|---|---|---|---|
| Bigger gate | Own ticket price | $40 tickets, +15 seats, free | the same, **$180 off the purse before the split** | sales are under 84: worth +$190 at 46 and +$50 at 74 between gym and boxer; the button says "worth it under 84 seats" |
| Bigger gate | Softer opponent | gap +0.5, free, 2 tune-up sets | **gap +1.0 (about 5 in 100 more), $300 off the purse, no tune-up rider** | a loss would hurt most: a boxer who wants the winnable night but whose money sits with this house |
| Both | Later +2 weeks | $150 off | unchanged; the words say "+2 Build weeks, the opponent stays as picked" | the boxer is injured or far over the weight at the call, or is new to the gym (the card reads a newcomer low; the camp is where that boxer grows) |
| Safer start | Costs from the purse | costs + $100/$200 off the purse | the same, **and loyalty -6** (the boxer boxes the debut for almost nothing: $41 at $1,400 and full costs) | cash cannot carry $1,245 today, or runway is under 8 weeks |
| Safer start | Softer opponent | free | **CUT** | the house already aims at 75 |
| Both | Later +4, Better split (counter and take) | free or dominated | **CUT** | the split counter loses to the ticket ask at every count; the take only exists at 80+ |

- **ESTIMATE — at 75+ sales (the bigger gate alone)** the three asks stay; own price stops paying at 84 and is hidden from there.
- **ESTIMATE — prices are per win point, on purpose different:** Later about $75 a point and two weeks; Softer about $60 a point and no delay; so Later is only right when the time itself is needed. The sweep in section 8 checks it.

## 5. Holding, staying, lapsing (ESTIMATE)
- **Review later is real.** The need and the top-bar flag turn amber (not red), so Continue runs. `lapse_if_due` is checked every day (`Sim.step_day`), and the clock stops once on the last day. The card's "14 more days" becomes true.
- **While it is open:** no bout can be booked for this boxer (`Bouts.accept` and the ask flows refuse with "Answer the pro offer first"), which also closes the overwrite in `turn_pro`. The idle loyalty count pauses for this boxer (the month-without-a-fight morale loss John names is not applied by any code today, so there is nothing else to pause). Other boxers are untouched.
- **Holding is not free training against a frozen opponent:** the debutant's rating is taken from the boxer on the signing day (CODE above), so it rises with the boxer. The hold costs up to two more weeks of stipend and two weeks later on the ladder.
- **Stay amateur says what it does**, on the button's hover: the real next gate (from `pro_ready`), terms x0.9 unless a title comes, loyalty -8, declines left. And **which house returns is a rule**: the one whose break-even is nearer the sales on the day of the Stay (said in roles: "the bigger gate calls back").
- **Another boxer ready:** one line in the header, "Another boxer's call waits behind this one." No count, no queue system: `check_pro` already calls the next ready boxer when this offer clears.
- **CUT:** the queue list, an extra lapse penalty, a countdown in the top bar.

## 6. The money, said honestly (ESTIMATE)
- **Three numbers a card**, replacing "the gym at signing", "the gym each week after" and the pays-back sentence: **Cash today** (the signing costs, or $0 when covered), **The gym on the night**, **The boxer on the night**. All at today's sales, from the sums the card already runs.
- **Paid on the night's seats.** The ticket row's hover: "Paid on the seats sold on the night. Every 2 new members is 1 more seat." It is the one thing the player can do about it. No range.
- **Both break-even marks** on the ticket bar (60 and 70).
- **CUT — the step and top promise** ("After the debut: +$ a win, up to $" on the card and the NEXT line in the week review) until pro pay reads it. The ladder already pays by rank; a second pay rule for the contract is out of scope (S428: the scope ends at the debut).
- **CUT — the assumed $75 a week** and the pays-back week: a number the player cannot check or change (owner C443).
- **Fix:** the debut ledger prints the share that was paid (10% or 25%), and adds "sold N on the night (N at signing)".
- **WHAT ENDS** gains, for a boxer on a day job: "The day job ends: 6 training mornings of 6 (now 4)."
- **Names:** "Turn pro with (house)" becomes "Sign this offer" (names only in headers; the card's head keeps the house's name and, under it, THE BIGGER GATE / THE SAFER START).

## 7. Where it appears
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar | `scripts/ui/Shell.gd` :152-153 | `Needs.flags` :167-168, red PRO OFFER | amber |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` | runs while the offer is held; stops once on the last day |
| Home, needs | `scripts/ui/HomeNeeds.gd` `ranked` :25-26 | `Needs.needs` :67-70, `_pro_line` :199-206 (house names in the body) | amber; days left; roles, not names |
| Office desk | `scripts/ui/OfficeDesk.gd` `NEED_ICON` :39 | the contract icon for "prooffer" | none |
| Offer header | `ProOffer.build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | "Another boxer's call waits" line |
| Offer ticket bar | `ProOffer._tickets` :90-106 | `ticket_parts` :204-219, one mark at 60 | both marks; the night's-seats hover |
| Offer house card | `ProOffer._house` :110-163 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | role line under the name; three money numbers; first-6-fights words; CUT step/top, weekly-after, pays-back |
| Offer asks | `ProOffer._ask` :167-188 | `ProOfferWire.answers/ask/back_to_plain`, act "proask" / "proplain" (`scripts/ui/RosterActs.gd` :96-104) | three granted asks, each with price and the numbers after |
| Offer foot | `ProOffer.build` :56-81 | `ProOfferWire.morale_line`, acts "turnpro" :90-95, "declinepro" :105-108 | the wish in the MORALE line; Stay's true hover; Review later; "Sign this offer" |
| Fighter, Next Step | `scripts/ui/areas/FighterPage.gd` :336-339 | `NextStep.road` :15-68, `pro_line` :73-89 (house names in the body) | "Offer open, N days" for this boxer; the age check; roles, not names |
| Fighter, contract | `FighterPage.gd` :144 | fixed text "Club stipend, $250 a week / until turning pro" | the pro share and house for a pro |
| Money, stipends | `scripts/ui/MoneyPanels.gd` :264, `_stipend_card` :360-369 | "Signing the open pro offer ends it anyway" | none |
| World compare | `scripts/ui/WorldCompare.gd` :269 | the "offer waiting" mark | none |
| Fights (pro) | `scripts/ui/ProFights.gd` :117-119 | `ProLean.line` :41-47 (house name in the body) | roles, not names; no tune-up rider line |
| Week review | `WeekReview.gd` :152 | `ProWeekLines.rows` :62-75 | the fixed ledger line; CUT the NEXT promise and the $75 line |
| History | `scripts/ui/BoutHistory.gd` :45-68 | "TURNED PRO WITH (house), (date)" milestone | none |
| Result of the debut | `BoutFinish.gd` :111-116, `Roster.debut_words` :254-261 | news line and pay label | the true share; members by house |
| Toasts | `RosterActs.gd` :95, :108 | "(first name) is a pro. Debut on (date)." | none |
| Test jump | `scripts/ui/TestJump.gd` :192-197 | opens the offer on the test club | keep working |
v9's rows for the roster table and the world news feed were not reopened for this map; they are not claimed here.

## 8. Depth: the test before any number is final (ESTIMATE)
- **The sweep (John 13).** A bot that values cash, members, morale and loyalty at the game's own prices plays the real route (`check_pro` to the settled debut and 12 weeks after) over sales 46-74, the six signable people, three wishes, three cash states (safe, under 8 weeks, cannot pay the costs), one injured-at-the-call case. Pass: each house is picked 30-70% of the time across the band and by no more than 85% in any single sales count from 50 to 70; each of the four asks is the best pick in at least one cell; "no ask" is best in at least one cell a house. Its output names the population. Control arm: today's numbers, which must read as dominated (the safer start near 100%).
- **Tuning order if it fails:** the bigger gate's win crowd (10), then the safer start's purse ($1,400), then the wish's loyalty (-3). The aims do not move.
- **State tests:** last day and reload; a double press on Sign; an amateur offer open at the call; Stay at 1 and 2 declines (the hover matches `pro_ready`); the 10% share on the ledger; an old save's offer with no `opp_picked`.
- **Golden path:** call, hold three days, one ask, sign, debut, week review ledger.

## 9. John's 13 points (6/6/7), one by one
| # | Point | v10 |
|---|---|---|
| 1 | Pick the opponent to each boxer | **BUILT.** CODE `DebutPick.pick` :48-67 via `ProOfferWire.make` :38; frozen in the offer. Measured 18 of 22 within 7 points (John asked 90%; the misses are newcomers the card reads low). Aims 60 / 75, owner "78 is fine" |
| 2 | Show the win read on each card | **BUILT.** CODE `ProOffer._house` :147. The range is refused: one number the two houses differ on and the asks move; a range adds nothing to act on (C443) |
| 3 | Safer start $1,400 | **Take** (section 3). Moves DEPTH: the crossover goes from none to 56 |
| 4 | The boxer's lean | **Take, smaller** (section 3): from saved fields, no new `goal_kind`; one MORALE line, not a line a card. Moves DEPTH and PLAY |
| 5 | Price-ask fee off the gross | **Take:** $180 off the purse before the split, "worth it under 84 seats". Today the ask is free (CODE) |
| 6 | A night range on the ticket card | **Refuse the range, take the fact:** the hover says pay is on the night's seats and what moves them |
| 7 | Always show Later +2 | **Built** (always shown today); take the words. Later +4 CUT |
| 8 | Re-price the lone-call asks | **Take for softer** ($300, gap +1.0); **cut harder** (John's own alternative). TURNPRO6 puts 0.5 of gap at 2.4 points, not "many" |
| 9 | Hold = Review later only | **Take** (section 5): amber, daily lapse, the idle-loyalty pause. His second pause (month without a fight, morale -6) has no code to pause: the number is only words today (CODE, section 1) |
| 10 | The returning house by a rule | **Take** (section 5) |
| 11 | Real costs | **Take the two fees** ($238 licence, $150 trainer; ESTIMATE until his BBBofC source is opened) and the manager's licence ($438, once a coach) as a signing cost. The yearly medical is a ladder bill: handoff note, not this map |
| 12 | One pulsing button; no names in card titles | **Take the names** (button and body lines, section 6). **Refuse the pulse-after-pick:** it adds a click to pick a card before signing it; two equal choices, neither pulses |
| 13 | The bot test | **Take** as the gate (section 8) |
| - | His evidence: real debutants win 90 in 100 | **Refuse** raising the aims: the owner's shape is a debut "expected to win but can lose", 70-80 for the safer house |
| - | Costs off the top is the real BBBofC model | **Keep the code's model**, add the loyalty cost; v9's loan is CUT |

## 10. Dola's list (7/8/7), one by one
| # | Point | v10 |
|---|---|---|
| 1 | Make the hold work: amber, daily lapse, block only this boxer, pause idle loyalty | **Take**, all four (section 5) |
| 2a | Three numbers a card | **Take** (section 6), from the card's own sums; no `ProMoney.quote` |
| 2b | Remove the step/top promise until it is paid | **Take** (CUT, section 6) |
| 2c | Full ledger in the week review | **Take, short:** the true share and sold-against-signing; no loan lines (no loan) |
| 2d | The crossover on the price ask | **Take** ("worth it under 84 seats") |
| 3a | One pro and one con a house | **Take:** the role line and the first-6-fights words |
| 3b | Stay shows exactly what happens | **Take** (section 5); today's tooltip is wrong after the first Stay (CODE) |
| 3c | Training mornings on the strip | **Take**, only for a boxer on a day job, in WHAT ENDS |
| 3d | The cost of waiting on the hold | **Take:** "No bout can be booked for your boxer while the offer is open." |
| 4 | Thin the asks: hide dead ones, at most 3, no "won't" buttons | **Take** (section 4): three a house at most |
| 5 | Validate, then show confidence in words only | **Built / refuse the words:** 79,200 played bouts stand behind the read (section 2); the number stays because the asks move it by known steps and the owner reviewed that card (C442/C443) |
| 6a | "Next in line" in the header | **Take as words**, no count (section 5) |
| 6b | Next Step says why now and what a pass costs | **Take:** the Stay hover's gate line, reused |
| - | Her "missing" table: real hold, cost of waiting, queue, day-job benefit, plain contract terms | all five answered above (1, 3d, 6a, 3c, 2b) |

## 11. Owner rulings kept
- Amateur bouts need no camp (S428): untouched; the debut keeps its camp (`WeekPhase.phase` :43-51).
- The debut is 70-80 in 100 for the safer house; "78 is fine" (DEBUTPICK1). The aims do not move.
- Names only in headers (S448): the button and three body lines that carry a house's name today are in the build list.
- Only actionable information (S425, C443 "can he do anything about them?"): no gap, no aim, no range, no assumed weekly figure; every number left is one the choice or an ask changes.
- Morale off the buttons, one MORALE line (S534): the wish lives in that line.
- One offer screen, no new screen; everything ships switched on.
- Board text short. The one line for his board, when two fresh critics have scored this map 7+: "Turning pro: safer house pays less, bigger gate wins bring more members, the boxer has a wish. OK to build?"

## 12. Build order (ESTIMATE; nothing here is built)
1. Hold: amber, daily lapse, the booking guard, the two pauses. Red test first: Continue with an open offer must advance the day.
2. Asks: three a house, prices, numbers-after on each button; cut the rest.
3. The fork: $1,400, the win crowd by house, the wish. Then the sweep (section 8) before the numbers are final.
4. The card: three money numbers, both marks, roles and names, Stay's hover, the returning-house rule.
5. Ledger and week-review fixes; the fees.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd` (:44, :79-80, :117, :145, :160), `tests/pro_offer_wire_test.gd` (:52-58, :66, :70), `tests/debut_pick_test.gd` (:150-151 softer on the safer start).

## 13. Cut list
- **CUT —** Later +4. Better split (counter and take). Softer on the safer start. The tune-up rider. "Won't" buttons. The step and top promise. The assumed $75 a week and the pays-back week. v9's loan, queue list, `ProMoney.quote` and versioned contract pay. A win-chance range or word bands. The pulse-after-pick. A countdown in the top bar. An extra lapse penalty. Raising the aims to 65 / 80.
