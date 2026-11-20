# TURNPRO1 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN_TURNPRO1_V7 — turning pro map v7
Status: Written from the code, 2026-11-20 | No game code changes; research only | One new file
Tags: CODE = open today (file + function + line, true on this branch), ESTIMATE = a proposal or a target not proven, CUT = removed on purpose. Where the code itself tags a constant ESTIMATE, this map says so. Every CODE line was opened in this checkout; see §18 for the list.
Owner rules kept (quoted in §14): names only in headers; gender-neutral copy; no new screens; actionable information only; the 14-day offer window; TAPER the week before a bout.
How to read: §1 is only what the code does. §2–§7 are the design. §8 is the menu table with CODE TODAY vs TO BUILD. §9 corrects the v6 lines the critic disproved — v6 itself said "All constants verified", which was not true. §10 answers every To reach 10/10 point from both critics. House names (Bow Lane, Harrow & Finch) are organisation names the code already uses; no person is named anywhere in this map.

## 1 — What the game does today (from the code, opened 2026-11-20)

### 1.1 Who calls, and the gates
- The offer comes from `Roster.check_pro` (`scripts/state/Roster.gd:199`): it lapses a pending offer first (`Lapse`: `ProOfferWire.lapse_if_due`), and for each fighter it requires `pro_ready` AND `ProOfferWire.waited` AND an empty `f["bout"]` AND not `Champs.active(f)` (`scripts/state/Roster.gd:201–206`). While a bout is booked or the nationals are live, no offer arrives. CODE
- `Roster.pro_ready` (`scripts/state/Roster.gd:185`): returns false if already pro, or at 3+ declines (`:186`); a national finalist with zero declines is ready at any win count (`:188`); otherwise needs `7 + declines×2` wins at a top-3 rank (`PRO_WINS`/`PRO_RANK`, `scripts/state/Roster.gd:33–34`, formula `:191–195`), or `9 + declines×2` at any rank (`PRO_WINS_ANY_RANK := 9`, `:35`); at 2+ declines ONLY a regional number 1 qualifies (`:192–193`). CODE
- After a lapse, `f["pro_wait_w"] = current wins + 2` is set (`ProOfferWire.lapse_if_due`, `scripts/state/ProOfferWire.gd:172–184`) and `waited()` blocks calls until those wins arrive (`:186`). Lapse does NOT increment `pro_declines`. CODE
- Who calls is decided by the ticket forecast, not by reputation: `ProCall.who_calls` (`scripts/rules/ProCall.gd:63`): forecast ≥ 75 → Bow Lane only; ≤ 45 → Harrow & Finch only; 46–74 → both, side by side. `BAND := 15` around break-even 60, itself tagged ESTIMATE in the code (`ProCall.gd:10`). CODE (band is ESTIMATE-in-code)
- After a decline, the same stored house calls again, if the stored house is non-empty: `keys = [last]` (`ProOfferWire.make`, `scripts/state/ProOfferWire.gd:30–32`, recording in `on_decline` `:166`). A joint offer records only the FIRST house (`offers[0]`), so the other house cannot call after the refusal. CODE
- `make()` enforces the age stop ONLY when `pro_declines == 0` (`ProOfferWire.gd:26–27`; `ProCall.calls_open` `ProCall.gd:331`). A 32+ boxer with one decline still gets calls; `pro_ready` has no age check at all. The 32 stop and the age-29 warning line are ESTIMATE-in-code (`ProCall.gd:14–15`, `age_line` `:322`, `AGE_STOP` `:14`). CODE + ESTIMATE-in-code
- `make()` also reads whether a title was won since the decline (`ProOfferWire.gd:33`); if so, terms factor resets to 1.0 (`ProCall.terms`, `ProCall.gd:73–86`; `values: factor × 0.9 per decline`). A later decline records a new title baseline (`on_decline` writes `pro_titles_at_decline`). CODE

### 1.2 The offer itself
- The offer dict carries one terms block per calling house, the forecast, an expiry day, the spent asks and the pre-ask "plain" terms (`ProOfferWire.make` `:24–39`). The flat legacy keys (`promoter`, `purse`, `terms`, `step`, `top`) follow the first house (`sync` `:43`). CODE
- The window: `ProCall.expires(day) = day + 14` (`ProCall.gd:336`); `WINDOW_DAYS := 14` tagged ESTIMATE in the code (`ProCall.gd:15`). Days left shown to the player come from `ProOfferWire.days_left` (`:61`), clamped at 0. CODE + ESTIMATE-in-code
- The debut is booked as the Saturday of the week, N weeks out, not "N×7 days later" (`Roster.debut_day`, `scripts/state/Roster.gd:320`; `PRO_DEBUT_WEEKS := 4` `:50`, per house 4/6 from `promoters()`). CODE
- The debut opponent: rating = `BoutRules.fight_power(stats, {}, 0, "", true) − deal opp_gap`, built fresh at signing (`Roster.turn_pro`, `scripts/state/Roster.gd:264`, opponent block `:303–310`; `fight_power` `scripts/rules/BoutRules.gd:294`). Houses' gaps in code TODAY are Bow Lane 1.0, Harrow & Finch 1.5 (`ProCall.promoters`, `ProCall.gd:35–57`) — not the −1.0 / 0.0 v6 proposed. CODE
- `Roster.turn_pro` accepts a house argument; empty means the first offer (`scripts/state/Roster.gd:264–270`). Signing sets `f["pro"]`, pays (or moves) costs, zeroes the stipend, books the 4-round debut, sets `pro_house`, `pro_tune_ups`, `pro_signed` (milestone dict), and clears the offer (`scripts/state/Roster.gd:271–318`). CODE

### 1.3 The money, as the code settles it
- Costs the gym can pay at signing: BBBofC licence $230 (`ProDebut.LICENCE`, `scripts/rules/ProDebut.gd:3`), first medicals $875 (`:4`), trainer licence $140 (`CORNER_LICENCE` `:5`); `start_costs` sums them (`:18`): $230, $370, $1,105 or $1,245. CODE
- Tickets: `ProDebut.tickets_sold` (`:27`): 20 family + half the members + 2 per amateur win + 10 per title, clamped to the 100-seat cap (`TICKETS := 100` `:6`, `TICKET_PRICE := 50` `:7`). `ProOfferWire.forecast` adds club-show followers and clamps to 100 (`scripts/state/ProOfferWire.gd:19`). CODE
- Break-even and share: Bow Lane $1,500 purse, break-even 60, 50% of tickets past 60, floor: purse − $25 per missing ticket, floor $500, not guaranteed; Harrow & Finch $1,800 guaranteed, break-even 70, 30% past 70 (`ProCall.promoters` `:35–57`, `debut_purse` `:99`, `SHORT_TICKET`/`PURSE_FLOOR` `:11–12` ESTIMATE-in-code). Gym cut of purse and ticket share = `MANAGER 0.15 + TRAINER 0.10 = 0.25` (`ProDebut.gd:10–11`; `Roster.GYM_SHARE` `scripts/state/Roster.gd:47`). CODE
- Each party's share: `ProCall.money` (`ProCall.gd:112`): ticket share above break-even uses the deal's own price (`t["price"]`, `:117`), gym cut of purse and ticket share, `gym_at_signing = cut − pay_now`; `by_debut` is computed (`:125`) but never shown; `weekly_after = current stipend − 75` (`LOST_CUT_A_WEEK := 75`, ESTIMATE-in-code `:13`, `:122`). `pays_back_line` only fires when `weekly_after > 0`; otherwise it returns the "until ranked" line (`:143`). CODE
- The modal previews the CURRENT stipend as "the gym each week after" — signing zeroes it (`Roster.gd:300`), so the line reads +$175 for a $250-stipend boxer and −$75 for a day-job boxer. Day-job fighters get the "ranked" pays-back line, not a week count. CODE
- The price ask caps sales at the 100 seats in both preview and settlement (`ProOfferWire.money` `:117–120`, `night` `:131–141`). Own price: $40 tickets (`PRICE_TICKET` `:26`), +15 sales (`PRICE_EXTRA_TICKETS` `:27`), Bow Lane only (`_price_entry` `:242`). CODE (ask numbers ESTIMATE-in-code)
- The costs ask: Harrow & Finch counters only; the promoter pays costs at signing and takes costs + a fee from the debut purse before the split (`_costs_entry` `:263`, fee = $100 with runway ≥ 8 weeks, else $200; `signed` `ProOfferWire.gd:107`, `night` `:131`). The Bow Lane answer is a straight "won't". CODE (numbers ESTIMATE-in-code)
- Under 50 loyalty an outside manager signs the boxer and the club keeps only the trainer's 10% (`Loyalty.pro_share`, `scripts/rules/Loyalty.gd:230`; enforced at signing `Roster.gd:222`, `:286–292`); `StarDeal.share` reads `f["gym_share"]`, default 0.25 (`scripts/rules/StarDeal.gd:10`, `:23`). Declining costs the boxer −8 loyalty (`Loyalty.MOVES["decline_pro"]`, `Loyalty.gd:61`); signing gives +5 (`"turn_pro"` same line). CODE
- The modal's "THE GYM PAYS AT SIGNING" line is NOT updated when the costs ask is taken — it always shows the full sheet cost (`ProOffer.gd:54–63`). CODE

### 1.4 The asks, as the code deals them
- `ProCall.asks` returns six kinds for every house: `later2, later4, softer, split, price, costs` (`ProCall.gd:151`); `ask_answers` builds all six, each with its answer and words, and house-mismatch asks come back "won't" (`:156`). The modal shows all six as a 2-column grid; "won't" buttons are greyed and unpressable; pressing one spends nothing (the code returns early) (`ProOffer.gd:_ask` `scripts/ui/modals/ProOffer.gd:149–171`; `ProOfferWire.ask` `:74–90`). CODE
- One ask per house per offer; once spent, only its answer shows, plus a "Back to the plain offer" button after a counter (always available; the ask stays spent) (`ProOfferWire.ask` `:74`, `back_to_plain` `:92`; `ProOffer.gd:_ask` `:149–171`). CODE
- The six, with their code values: later2 = purse −$150, +2 weeks (`_apply_later` `ProCall.gd:197`, floor 0); later4 = −$300, +4 weeks (same function); softer = +0.5 opponent rating (a weaker, easier opponent), next 2 pro offer sets are tune-ups (`_apply_softer` `:204`; consumed by `ProLean`/`ProLadder`, see §8 M13); split = take at forecast ≥ +20 past break-even: +10 share points and opponent 0.5 HARDER; counter at ≥ +5: +5 points; otherwise "won't" (`_split_entry` `:211`); price (Bow Lane only, see 1.3); costs (Harrow & Finch only, see 1.3). All ask numbers are ESTIMATE-in-code (`ProCall.gd:18–32`). CODE + ESTIMATE-in-code
- Best-use lines on ask buttons do not exist in code; nothing in `ProCall`/`ProOfferWire` knows "when best". CODE (absence noted)

### 1.5 Decline and lapse, exact behavior
- "Stay amateur" (the only selectable refusal): `Roster.decline_pro` (`Roster.gd:325`) — `pro_declines += 1`; the same stored house is recorded for next time; morale applies (`apply_morale(stay=true)` — see §7); loyalty −8; news line by decline count (`DECLINE_NEWS`, `Roster.gd:39`: back after more wins / only a regional number 1 / no promoter will call); the offer clears. CODE
- Terms after a decline: 0.9× purse, step and top for EACH decline, compounding (0.9, 0.81, 0.729…), unless a title was won since the last decline, then 1.0× (`ProCall.terms` `:73–86`). Purse floors at $0 only via the later-ask path; there is no other floor on reduced terms. CODE
- Lapse (the 14 days ran out): sets `pro_wait_w = wins + 2`, clears the offer, posts a news line; NO decline increment, NO loyalty or morale move, and the house is NOT recorded — if `pro_declines == 0` the next call's house is re-decided by `who_calls` at that future forecast, so the promoter may not be the same one; prior decline factors still apply if any exist (`lapse_if_due` `ProOfferWire.gd:172–184`; `waited` `:186`; `make` `:24–39`). CODE
- There is no "review later" close action and no selectable "let it run out"; a player can only wait for the clock to stop (`Sim` week end and bout finish call `check_pro`: `scripts/state/Sim.gd:414`, `scripts/state/BoutFinish.gd:213`, `scripts/state/Bouts.gd:456`). CODE
- Save/load: the offer and every fighter field (declines, wait wins, house, titles-at-decline, the `pro_signed` milestone) survive a save. `Career.pro_offer` is a script variable (`scripts/state/Career.gd:47`), serialized by `SaveGame.to_dict`/`from_dict` through `get_property_list` (`scripts/state/SaveGame.gd:20–58`); fighter dicts are deep-duplicated the same way. CODE
- The whole decline ladder persists: 3 declines = `pro_ready` false forever, no reset path exists anywhere in code. CODE

### 1.6 The boxer's voice — the true wiring
- `Recruit.ambition` (`scripts/rules/Recruit.gd:122`) returns exactly three strings: 0 bouts → "A first win in front of a home crowd"; potential ≥ 78 → "A regional title within a year"; otherwise "A winning record by the summer". CODE
- `ProCall.ambition_kind(words)` maps any string containing "title" → `title`, containing "pro" → `pro`, else `other` (`ProCall.gd:312`). NO recruit ambition string contains "pro", so the `pro` branch is UNREACHABLE, and the morale effect the offer shows for signing/staying is always 0 except one reachable case: a title-ambition boxer signing while still eligible for the nationals takes −5 morale (`ProCall.morale` `:298`, `before_nationals` = `Champs.check(c, f)["ok"]`; applied at signing and at decline via `ProOfferWire.apply_morale`, `Roster.gd:277`, `:331`). CODE
- The modal shows morale on a button only when non-zero (`_mood`, `ProOffer.gd:173`, on the Stay and Sign buttons `:71`, `:142`); there is no ambition line, no day-job line, and nothing else about the boxer's voice on the offer. CODE
- Day job: a boxer off the stipend works 2 of 6 mornings (`DayJob.LOST := 2`, `scripts/rules/DayJob.gd:21`), half sponsorship works 1 (`HALF_LOST := 1`, `:34`), gains scale by `gain_share` (`:73`), week lines from `line` (`:91`). There is NO day-job or half-sponsorship branch anywhere in `Roster.pro_ready` or `ProOfferWire.make` — v6's "6 wins for a day-job boxer" gate does not exist in code. The only pro-call day-job effect in the whole game is indirect: fewer mornings → slower stats → fewer wins. CODE (absence noted)
- The measured result (TURNPROBE3B, see §12): 3 of 180 day-job careers ever reach a first call in 104 weeks (stipend half: all did). CODE-cited probe, not code.
- Stipends: full $250/wk (`GameMoney.FIGHTER_STIPEND`, `scripts/rules/GameMoney.gd:9`), half = half that (`GymSpend.set_half`, `scripts/state/GymSpend.gd:140–155`), $125; the Money page shows on/off/half with tooltips about mornings and loyalty (`MoneyPanels.gd:256–273`) and a truthful line that an open offer ends the stipend (`:264–266`). No "pro call gate" text exists anywhere. CODE

### 1.7 The screens the mechanic touches today
- The modal: one or two house columns side by side, a tickets bar against the Bow Lane break-even, `ONE ASK` grid, the gym's pays-now and pays-weekly lines, the pays-back line, Stay amateur, per-house Sign (`ProOffer.gd`, whole file; house card `:103`, tickets `:83`, asks `:149`). House names are in the modal's caps header and inside each card (`:25`, `:115`). CODE
- The top bar: the flag text is exactly "PRO OFFER", always red, no countdown (`Needs.flags`, `scripts/state/Needs.gd:140–163`; rendered by `Shell.gd:153`); no red-last-3-days behavior exists. The Home note carries "A promoter wants to sign <name>", the days-left sub-line "%d days to answer", and the "Hear it" button (`Needs.needs` `:62–65`, `_pro_line` `:194`). CODE
- Fighter → Next Step: five steps with the lit one and its need, plus the S523 line: tickets today against each house's break-even, the age line, declines left (`NextStep.road` `scripts/rules/NextStep.gd:15`, `pro_line` `:73`; rendered `FighterPage.gd:322–357`). No route line, no decline-adjusted requirement text, no next-offer date. CODE
- Week review: the after-signing and debut ledger lines ARE wired (`WeekReview.gd:26`, `:152` → `ProWeekLines.rows` `scripts/ui/ProWeekLines.gd:62`): four weekly lines ("Amateur cut lost $X; stipend saved $Y (N weeks since signing)", `LOST_CUT_A_WEEK × weeks`; a day-job boxer's saved line is $0 and flagged bad) and the debut ledger + NEXT line (net cash line, `AFTER_SIGNING_DAYS := 28`). `by_debut` from `ProCall.money` is computed and never shown. CODE
- History: a single gold caps milestone "TURNED PRO WITH <HOUSE>, <DATE>" between the amateur and pro records (`BoutHistory._milestone`, `scripts/ui/BoutHistory.gd:67–71`). No week number, no opponent. CODE
- After the debut: the promoter brings three offers per fight (tune-up / step up / payday) standing 7 days (`ProLadder` header and `OFFER_DAYS := 7`, `scripts/state/ProLadder.gd:31`; `Matchmaking` rules), and for the first 6 pro fights the house leans — Harrow & Finch a second tune-up, Bow Lane a second step up (`ProLean.LEAN_FIGHTS := 6`, `scripts/state/ProLean.gd:7`, `LEAN_KIND` `:8`, `extra` `:12`). A decline sets tune-ups too if the softer ask was taken (`Roster.turn_pro` `:311`). CODE
- Costs neither loyalty nor the modal mentions: the costs ask applies NO loyalty move at all (no costs key in `Loyalty.MOVES`, `Loyalty.gd:45–63`; `ProOfferWire.ask` never calls loyalty). CODE (absence noted)

### 1.8 Save/load corner cases the design must respect
`SaveGame` round-trips script variables with Godot's typed format (`SaveGame.gd:1–20, 20–58`), so an offer pending across a save renders identically later; `declines`, `pro_wait_w`, `pro_last_house`, `pro_titles_at_decline`, `pro_signed` all persist. Any new field this design adds (§5) must likewise be a plain script variable or explicitly migrated; the `_migrate_v1` path shows old saves get defaults (`SaveGame.gd:130+`). CODE

## 2 — The offer side by side: what signing with each house really changes

Two houses call side by side only in the 46–74 forecast band (`ProCall.who_calls`, `ProCall.gd:63`); below 46 only Harrow & Finch, above 74 only Bow Lane. So "which house" is a live choice only there. Everywhere else the choice is between Sign, an ask, Stay amateur, or running out the clock — the design must not pretend a choice exists when it does not. ESTIMATE targets below are labelled.

The two houses, CODE values from `ProCall.promoters` (`ProCall.gd:35–57`) and TURNGAP1 (measured, §11):

| | Bow Lane | Harrow & Finch |
|---|---|---|
| Purse | $1,500, −$25/ticket under break-even, floor $500 | $1,800 guaranteed |
| Break-even | 60 | 70 |
| Ticket share past break-even | 50% | 30% |
| Debut | 4 weeks out (Saturday of that week, `Roster.debut_day` `Roster.gd:320`) | 6 weeks out |
| Opponent gap in code today | 1.0 | 1.5 |
| Opponent gap proposed (ESTIMATE) | −1.0 | 0.0 |
| Measured debut win share at proposed gap (TURNGAP1, n=200 each) | ~67% | ~78.5% |
| After the debut: purse growth | +$500/win, up to $3,000 | +$400/win, up to $3,000 |
| First-6-fights lean (CODE) | second step-up (`ProLean.LEAN_KIND`, `ProLean.gd:8`) | second tune-up (`:8`) |
| Who calls | forecast ≥ 75 alone; 46–74 side by side | forecast ≤ 45 alone; 46–74 side by side |

Career comparison, not one night: over the first 6 pro fights (`ProLean.LEAN_FIGHTS`), Bow Lane leans to step-ups (harder fights, faster ranking, +$500 steps) and Harrow & Finch leans to tune-ups (easier fights, slower ladder, +$400 steps); the purse tops are the same $3,000. The choice changes: debut risk (the −25/ticket exposure vs a $300 safety margin), the date the debut lands (4 vs 6 weeks), the after-debut ladder shape (steps and lean), and ticket-share upside past 60/70 sales. It does NOT change: the 4-round debut, the 100-seat cap, the gym's 25% cut default, the stipend ending, or the amateur rankings ending.

The signing decision itself — decline or sign — changes the week and the fight immediately: the stipend ($250/wk, or $0 day job) stops (`Roster.turn_pro` `Roster.gd:300`), the amateur ticket cut ($450/bout, `BoutRules.TICKET_CUT` `BoutRules.gd:113`, ~$75/wk modelled loss, `ProCall.LOST_CUT_A_WEEK` ESTIMATE `ProCall.gd:13`) is lost, loyalty +5 (`Loyalty.gd:61`), and the debut books N weeks out with the fight-week TAPER applied to that week (`WeekPhase.phase`, `scripts/rules/WeekPhase.gd:43`).

## 3 — The three real choices, with trade-offs (depth 7+)

No dominant pick in reachable states, and every choice changes a number the game already uses. Numbers marked §6 are worked in the money table.

### Choice A — Which house (live only at forecast 46–74)
- Bow Lane: riskier night, pays MORE if the gate goes well (50% past 60 vs 30% past 70), $300 less guaranteed, debut 2 weeks sooner, after-debut ladder faster (+$500 steps, step-up lean). Changes: debut opponent rating (today's gap 1.0 → ESTIMATE −1.0, `ProCall.promoters` `ProCall.gd:45`, `:56`), purse/ticket money (`ProCall.money` `:112`), and the week count to fight night (`Roster.debut_day` `Roster.gd:320`).
- Harrow & Finch: $300 more even on a dead night, zero gate risk, 2 more weeks to prepare (week structure: 2 extra BUILD/PEAK weeks and one more member-drift cycle, `Membership.step_members` `Membership.gd:45`), slower and safer after-debut ladder. Changes the same numbers in the other direction.
- Trade-off name: safety vs upside vs date. Break-even discipline decides: at forecast 46–60, Bow Lane's floor path costs the gym real money (~$250–$1,000); at 74 both break even and Bow Lane pays more (share past 60). At 75+ the game never offers the choice. Trade the purse floor for the $300 safer night.
- What this choice does NOT decide: the debut opponent is fixed per house (one opponent per house by design); the asks (§4) are one per house; refusals (§5) are global. The houses differ on money, date and gap — nothing else. That restraint is deliberate and stays.
- Not dominant: Harrow & Finch dominates at 46–60 (guaranteed $1,800 vs Bow Lane's $1,250–$1,500); Bow Lane dominates at 74 ($1,850+ vs $1,800 flat); they tie near 69–74 depending on the gym's cut and loyalty. ESTIMATE bands until a cohort probe maps them across cash bands (§12).

### Choice B — When to turn (sign now vs Later +2 vs Later +4)
- CODE: Later +2 = purse −$150 and the debut moves +2 weeks (`_apply_later`, `ProCall.gd:197`; applied in `Roster.turn_pro` via the ask, `Roster.gd:276–277`); Later +4 = −$300, +4 weeks. Both floor the purse at $0, and both shift the settlement date of the debut — which is what actually pays (`debut_night` uses the forecast ON THE NIGHT, `scripts/state/Roster.gd:246`, `:253`).
- What the delay buys: member drift, capped at 6 members/week toward target (`MAX_WEEKLY_MEMBER_CHANGE`, `Membership.gd:29`; ¼ of the gap per week, min 1, `step_members` `:45`), and 0.5 tickets/member (`ProDebut.PER_MEMBER` `ProDebut.gd:13`). So +2 weeks ≈ up to +6 tickets, +4 weeks ≈ up to +12 — ONLY if the club's member target is above its current books; otherwise zero, or negative. Ticket cap is absolute at 100 (`ProDebut.TICKETS` `:6`).
- Why the code rules out v6's "conflicting amateur bout" rationale: offers only exist with an empty bout booked (`Roster.check_pro` `Roster.gd:206`), so a delay ask can never resolve a CURRENT bout clash; it can only pre-position the debut around a bout accepted in the 14-day window (or the nationals run). CODE (absence of that rule noted)
- Trade-off name: purse now vs tickets later, and prep weeks vs the debut date. Changes: purse (`ProCall._apply_later`), settlement week and thus the week's TAPER (`WeekPhase.phase` `:43`), and expected night income (`ProCall.money` `:112`). Later +4 is only worth its $300 when ≥ ~12 tickets are genuinely on the table at the night; above forecast ~88 the 100-seat cap erases any gain (§6) — ESTIMATE, to be settled by the on-button preview this map requires (§8 M5).
- Not dominant: at forecast ≥ 88 (cap-bound), both delay asks are strictly worse than signing now unless the gym needs the prep weeks; at 46–74 they are live options if the club is still growing.

### Choice C — What to ask, and how to refuse (accept the ask, Stay amateur, or let it run out)
- Asks (one per house, §4): the purse/share/date/opponent levers above. The costs ask trades cash flow for immediate relief: $0 now vs $1,245 + a $100/$200 fee off the debut purse (§6 shows who actually profits). The price ask trades $5 per ticket past break-even ($20 vs $25 share rate) for +15 sales, capped at 100 (§6 crossover at 92).
- Stay amateur (the only selectable refusal, `Roster.decline_pro` `Roster.gd:325`): keep fighting amateurs, loyalty −8 (`Loyalty.gd:61`), terms 0.9× compounding (`ProCall.terms` `ProCall.gd:73`), next call needs 9 wins top-3 or 11 any rank (not "+2 wins" — §9.4), and at 2 declines only a regional No.1 brings a call. Changes: loyalty → pro share (`Loyalty.pro_share` `:230`), terms, and the Next Step text.
- Let it run out (not selectable today): no loyalty hit, no morale hit, +2 wins wait (`ProOfferWire.waited`/`lapse_if_due`), terms unchanged unless declines exist, and the next house is re-rolled by forecast at zero declines (§5). Changes: time and the wait counter only — the cheapest refusal, which is exactly why it dominates Stay amateur today and breaks v6's "two distinct refusals with visible costs" claim. §5 proposes the fix.
- Trade-off name: money now vs money later vs the relationship with the boxer vs the door. Every branch changes a number: purse/share (`ProCall.money`), loyalty (`7.6`-adjacent, `Loyalty.MOVES`), terms factor, or `pro_wait_w`/`pro_declines` (the Next Step lines read them, `NextStep.pro_line` `NextStep.gd:73`).
- Not dominant: Stay amateur strictly dominates nothing (it costs −8 loyalty and 0.9× terms); letting it run out strictly dominates Stay amateur for a player who wants time — until the probe says waits are too cheap (§12). Signing dominates both for a title-ambition boxer before the nationals (−5 either way is only worth one decision) and for a cash-rich gym at forecast ≥ 60.

## 4 — The asks: keep, change or cut, with the reason and the number

The code shows all six (`ProCall.asks` `:151`). v6 cut softer and split. This map keeps the cuts, for balance reasons (not "unused code"), and keeps both delay asks only with the mandatory on-button preview:

| Ask | CODE today (file+function) | Change proposed | Number it changes |
|---|---|---|---|
| Later +2 weeks | purse −$150, +2 weeks (`_apply_later`) | KEEP, add at-night forecast line (TO BUILD, §8 M5) | purse (floored at 0), debut week, TAPER week |
| Later +4 weeks | purse −$300, +4 weeks (`_apply_later`) | KEEP only with the same preview; if the preview cannot ship, CUT | purse, debut week, drift headroom (max +12 tickets) |
| Softer opponent | +0.5 gap (weaker), next 2 offer sets tune-ups (`_apply_softer`; wired via `ProLean`/`ProLadder`) | CUT from the offer (hide the button); keep the code path for the softer-start design use | debut opponent rating; future tune-up bias |
| Better split | take at +20 past BE: +10 share points, opponent 0.5 HARDER; counter +5 at +5; else won't (`_split_entry`) | CUT — probe shows 0% best in every band; dominated by price in the same band | share rate (0.5→0.6 / 0.3→0.4), opponent gap −0.5 |
| Own ticket price (Bow Lane) | $40, +15 sales, 100 cap (`_price_entry`) | KEEP; add on-button warning recomputed at CURRENT forecast: "Above 92 sold-equivalent: −$200 total gross" is only true at 100 (§6) — the button must say the live number (TO BUILD) | ticket price, extra tickets, settlement total |
| Costs from the purse (Harrow & Finch) | $0 now; purse reduced by costs + $100/$200 fee before split (`_costs_entry`) | KEEP; show the total on the button ("gym keeps $114 instead of $450; fee is the price") and the runway weeks that set the fee; do NOT add v6's −5%-share-for-3-fights penalty (§6.3, unvalidated, would not fix dominance) | purse at the night, gym cash at signing |

Why the probe makes the cuts: TURNPROBE3B line 7 — costs 74% best, later2 19%, price 6%, later4 / softer / split / none 0% (360 careers, 104 weeks, read with the documented fork defect; treat as direction, not precision). A 0%-best ask is clutter; the owner rule is options the player can act on — and CUTTING does not delete code, it hides two buttons. ESTIMATE: re-probe after the price-warning fix lands (§12).

## 5 — Decline and lapse: the door, made coherent

CODE behavior (§1.5) has three holes the critic named: expiry is a free pass that dominates refusal; the return terms are not reset by expiry; the house is not recorded, so "same house" promises are void. Proposal (all TO BUILD, no new screens, no modal redesign):

1. One wait action, honestly priced. Add a third action on the offer footer: "Review later" — closes the modal, the offer STAYS live, the 14-day stop remains visible wherever the player goes (the Home need already shows "N days to answer", `Needs._pro_line` `Needs.gd:194`). No new screen, one flag. This is the "review later" the critic asked missing; the passive 14-day wait then has no special role and stays exactly as coded (lapse = expiry = no decline, +2-win wait).
2. Make expiry exact, not vague. On lapse the news line and the Next Step card must state the requirement exactly: "the promoters call again after N more wins" (rank 1 if two declines already used, `pro_ready` `:192`) — never "~8 weeks" (a lies-by-calendar promise; wins are not on a calendar).
3. Record the event. On lapse, store the calling house and the win count at lapse (`pro_last_house`, `pro_wait_w`) with declines untouched; on the next `make()`, apply the same same-house rule and keep prior decline factors (current behavior for stored houses; today a zero-decline lapse re-rolls the house, which can flip the promoter silently) (`ProOfferWire.make` `:24–39`).
4. Give expiry one cost, or fold it into (1). If the studio wants expiry to differ from refusal, the honest cost is time, not morale or loyalty: the wait at a zero-decline lapse is 2 wins; at 104 weeks a typical amateur books ~every 2–3 weeks — the cost is already real, it just needs to be SAID. No new penalty is added; the probe keeps the pick-rate target honest (§12).
5. Decline ladder rendered on the offer (already partly there): the modal shows declines left (`ProOffer.gd:41`); TO BUILD adds the exact next requirement per state — 0 left → full terms; 1 left → "9 wins and a top-3 ranking, or 11 wins, next call at 0.9×"; 2 left → "only a regional No.1"; 3 → door closed permanently (`pro_ready` `:186–195`; no reset exists in code, §9.5). After a save/load round-trip this text must come from the same functions, never cached UI state (CODE: fields persist, §1.8).
6. Refusal-vs-expiry display parity: "Stay amateur" must show loyalty −8 and the 0.9× compounding on its own button line (tooltip exists today: same house, N more wins, 0.9× unless a title — `ProOffer.gd:72–74`); the proposed "Review later" button shows "nothing happens; the offer runs out in N days; the promoter returns after 2 wins". Both visible, both honest, neither dominant.

## 6 — The money, worked end to end

### 6.1 At signing, full loyalty, $1,245 first-start costs, $250 stipend

| Forecast | House | Purse | Gym cut (25%) | Signing cash | Weekly after | Weeks to even | Boxer keeps |
|---|---|---|---|---|---|---|---|
| 50 | Bow Lane | $1,250 (floor path) | $313 | −$932 | +$175 | 6 | $937 |
| 50 | Harrow & Finch (both call) | $1,800 | $450 | −$795 | +$175 | 5 | $1,350 |
| 60 | Bow Lane | $1,500 | $375 | −$870 | +$175 | 5 | $1,125 |
| 60 | Harrow & Finch | $1,800 | $450 | −$795 | +$175 | 5 | $1,350 |
| 69 | Bow Lane | $1,500 (9 past BE: +$225) | $431 | −$814 | +$175 | 5 | $1,294 |
| 69 | Harrow & Finch | $1,800 (below BE: no deduction) | $450 | −$795 | +$175 | 5 | $1,350 |
| 74 | Bow Lane | $1,500 (+$350 share, gross $1,850) | $463* | −$782 | +$175 | 5 | $1,387 |
| 80 | Bow Lane (alone) | $2,000 (20 past BE: +$500) | $500 | −$745 | +$175 | 5 | $1,500 |
*$463 = round($1,850 × 0.25); the code uses `int(round(...))` (`ProCall.money`, `ProCall.gd:112–142`) and floats can round half either way — both figures are within a dollar. Numbers from the code formulas; rounding noted once, not hidden.

### 6.2 Own ticket price — the true crossover (Bow Lane, before the 25% gym cut, before rounding)
Forecast vs plain: gain = sold − share diff with the cap at 100. F ≤ 85: price gains +15 sales; net vs plain = $600 − $5·F gross... shown at the points that matter:

| Forecast | Plain gross (purse+share) | Price gross | Diff |
|---|---|---|---|
| 50 | $1,250 | $1,600 | +$350 (also moves above BE) |
| 69 | $1,725 | $1,980 | +$255 |
| 85 | $2,125 | $2,300 | +$175 |
| 92 | $2,300 | $2,300 | $0 (crossover) |
| 100 | $2,500 | $2,300 | −$200 |

The v6 line "Above 91 tickets: −$25/ticket above cap" and its "−$200 total income" claim are both wrong; §9.9. The button must show the live number at the CURRENT forecast (recomputed, tooltip or line, not tooltip-only) — TO BUILD.

### 6.3 Costs from the purse — who actually profits (Harrow & Finch, $1,245 costs, fee by runway)
- Plain: gym pays $1,245 now; at the night it banks 25% × $1,800 = $450 → net −$795 (plus weekly +$175 while the stipend winds down).
- Costs ask (runway ≥ 8): gym pays $0 now; night purse $1800 − 1245 − $100 = $455; gym banks $114 instead of $450 → −$336 at the night, but +$1,245 of cash today. The fee is the price; the "repayment" does not exist as a stream.
- Costs ask (runway < 8): same with $200; purse $1800 − 1245 − $200 = $355; gym banks $89 instead of $450 → −$361 at the night.
- v6's −5% share for 3 fights would cost the gym ≈ 0.05 × (purses of 3 fights ≈ 1800+2200+2600) ≈ $330 — STRICTLY WORSE RELIEF for a cash-poor gym than paying the $100 fee today, so it would not fix the measured 74% best-pick rate; it would just tax the honest closure-insurance play. CUT it (unvalidated and backwards), keep the fee as the visible price, and let the probe (§12) decide if any penalty is needed.
- The dominance is rational for cash-poor launch gyms: closure beats 100/200. The fix is DISPLAY (runway line, total on the button), not punishment. A cash-rich gym takes the plain path for $100 back.

### 6.4 What signing does to the two parties after the debut
- Stipend stops ($250/wk saved; day-job already $0), amateur cut lost ($75/wk modelled; the real $450/bout lands only when bouts happen, `BoutRules.TICKET_CUT` `:113`), so the week services change — the ProWeekLines ledger lines show exactly this for 4 weeks then hand over to the debut ledger (`ProWeekLines.gd:15–44`).
- Under 50 loyalty the gym's cut drops to 10% for the debut and beyond (until contract talks) — sign under 50 and the honest modal must show it (it does, `ProOffer.gd:67`).
- Post-debut, the house ladder re-prices everything: Harrow & Finch pays more per fight via its tune-up lean only on win rates, less on steps; Bow Lane pays faster on steps. The $3,000 top is shared. ESTIMATE: a full career EV comparison belongs in the probe (§12), not in this map as a number.

## 7 — The boxer's voice: what the code actually says

CODE truth (§1.6): the ambition on the signing card is read by exactly one function chain — `Recruit.ambition` → `ProCall.morale` — and the `pro` branch is dead, because no ambition string contains "pro". The only morale effect reachable today is a title-chaser signing while still nationals-eligible: −5 (signing) and 0 (staying, or signing after the nationals). Everything the v6 map printed about a "Turn pro and build a career" ambition firing +5/−5 at pot 60–77 was text that does not exist in the game.

Design answer (TO BUILD, and it is enough):
1. One string changes. In `Recruit.ambition` (`scripts/rules/Recruit.gd:122`), the pot ≥ 78 / else branch pair becomes: pot ≥ 78 → "A regional title within a year"; otherwise → "A career in the pros" (ESTIMATE wording, no person, gender-neutral). Now `ambition_kind` returns `pro` for every boxer not chasing a title, and the signing/staying morale line becomes live: sign +5, stay −5, shown on both buttons via the existing `_mood` path (`ProOffer.gd:_mood`, applied to Sign/Stay today, inert until this lands). The 0-bout line stays.
2. The offer shows the effect, not just the number. TO BUILD one line on the boxer-status strip (§8 M6): "Wants the pros: signing now +5 morale / staying −5" — only when the effect is non-zero, matching today's display rule (`_mood` suppresses zero). For title-chasers before the nationals: "Chasing the title first: signing −5 until the nationals are done."
3. Day-job truth on the same strip, no invented gate: "Full stipend" / "Day job: 4 of 6 mornings (Tue, Thu work)" / "Half sponsorship ($125/wk): 5 of 6 mornings" — read from `f["day_job"]`, `f["half_job"]`, `DayJob.count_of` (`DayJob.gd:37`). No claim of an earlier call, because none exists in code.
4. The 9-win alternative appears in the same breath: "No offer yet: 7 wins and a top-3 ranking, or 9 wins, brings the call." (the Next Step card already says a version of this, `NextStep._need_for` `NextStep.gd:113–121`; the offer strip repeats it only if the offer somehow persisted — it cannot, offers only exist post-eligibility; the line lives on Next Step instead.)
5. What this fix does NOT do: it does not make the boxer's personal choice dominant, it does not add a conversation tree, and it does not solve the day-job call rate — that is a balance question for the probe (§12), with the real options:
   (a) 6 wins + top 3 for day-job boxers (v6's CHANGE, never built) — but TURNPROBE3B shows the rank leg binds too (day-job best rank 4 at w104), so this alone likely does not reach 30%;
   (b) 6 wins at ANY rank (ESTIMATE, double the gate's permissiveness, would need the door re-probed);
   (c) accept the arithmetic — day-job means a slower career, visible on the strip above — and CUT the "≥30% first call" target from the pass lines (recommended until TURNPROBE3C says otherwise);
   (d) stipend-halves only (half sponsorship exists precisely as the middle path; nothing in code prevents choosing it).
   Recommendation: (c) + strip; owner decides (a) or (b) with probe data. One line, plainly: the v6 gate was a proposal presented as a fix, never built, and unprobed against the rank leg.

## 8 — The menu table: every menu the mechanic appears on

Columns: what it shows today (CODE, opened) | wired to | CODE TODAY | TO BUILD (and what it must do). "Missing" means the feature does not exist in code; that is said once and not softened.

| # | Menu | What shows today | Wired to | CODE TODAY | TO BUILD |
|---|---|---|---|---|---|
| M1 | Top bar flag | "PRO OFFER", red, static | `Needs.flags` (`Needs.gd:140,163`) → `Shell.gd:153` | BUILT, claim corrected: NO countdown, NO red-last-3-days | CUT those claims; nothing to build (or add "PRO OFFER N" days? No — the Home note carries the days; keep the flag minimal) |
| M2 | Home board | Red need: "A promoter wants to sign <name>", days-to-answer sub-line, "Hear it" button | `Needs.needs` (`Needs.gd:62–65`) → `HomeNeeds` flow | BUILT (wording ≠ v6's mockup line) | nothing; the note IS the countdown |
| M3 | Offer modal — header | "A CALL FROM <HOUSES>", "TURN <FIRSTNAME> PRO?", facts row (record, days left, age line, declines left) | `ProOffer.gd:_ask`-adjacent header block (`ProOffer.gd:22–47`) | BUILT | keep house names in this header only; "REVIEW LATER" affordance enters the FOOTER, not the header (§5) |
| M4 | Offer — each house card | Purse (guaranteed/shortfall+floor), ticket share past break-even + "N sold today", "Debut: N weeks out, a debutant %.1f under", after-debut step/top, "Second call: N% of first terms" (only under <1.0), gym-at-signing / gym-each-week / boxer-from-the-debut, pays-back line | `ProOffer.gd:_house` (`:103–148`) → `ProCall.promoters/terms/money`, `ProOfferWire.money` | BUILT | add: calibrated win-chance RANGE ("about 45% to win, honest spread 9–82%" from `BoutRead.likely/band` `BoutRead.gd:407/398` — see §11, label ESTIMATE until calibrated); at-night ticket forecast with its assumption line; the raw gap text can go once the chance range ships; Sign button must not carry the house name (S448) — "Sign" inside the card (house name stays in the card header) |
| M5 | Offer — one-ask grid | SIX asks, each "label – will take it / counters / won't", tooltip carries the words; won't greyed | `ProOfferWire.answers/ask` (`:66/:74`), `ProCall.ask_answers` (`:156`) | BUILT | hide softer + split (CUT, §4); on-button live cost lines: price ("above N sold: −$X total gross", crossover 92, §6.2), costs ("gym keeps $114, fee is $100; runway N weeks", §6.3); Later +4 (and +2) show the at-night forecast ("if the club adds M members: +K tickets") — CUT both asks again if this cannot ship |
| M6 | Offer — boxer-status strip | nothing | — | MISSING | one strip, three facts, only actionable text (owner rule §14): ambition+morale effect (§7.2), route (§7.3), who called and why at this forecast ("both called: the gate is between 46 and 74 — pick one" — that is information the player can act on) |
| M7 | Offer — footer refusals | "Stay amateur" (morale in parens if non-zero) + tooltip (same house, N more wins, 0.9× unless a title) | `ProOffer.gd:71–77`, `Roster.decline_pro` (`:325`) | BUILT | two distinct, costed actions: "Stay amateur" (costs line on the button: loyalty −8, terms 0.9×) and "Review later" (offer stays live; the 14-day stop keeps ticking — §5.1); disabled-state reasons for both when applicable |
| M8 | Fighter → Next Step | five steps, lit step, need; S523 line: tickets today vs each break-even, age line, declines left | `NextStep.road/pro_line` (`NextStep.gd:15/:73`) → `FighterPage.gd:322–357`, `RosterTable.gd:47`, `Fights.gd:130` | BUILT | add: route (full/half/day) one-word line; decline-adjusted requirement text (§5.5); NO next-offer date promises (wins are not a calendar) |
| M9 | Money → Stipends | on/off/half toggle + tooltips (2 mornings Tue/Thu; 4 of 6; half: 1 morning, $125); stops on pro; held by Eastside answer; "an open pro offer ends the stipend" | `MoneyPanels.gd:240–276` → `GymSpend.set_stipend/set_half` | BUILT | CUT the v6 "pro call gate" hover claim (fiction — no such gate in code); keep the signing-ends-it line; add nothing |
| M10 | World → News | nothing about pro signings; the only news is the named "…turns pro with…" line at signing | `Roster.turn_pro` (`Roster.gd:313`) → `Career.add_news` (`Career.gd:178`) | CODE exists but IS NOT names-free | TO BUILD an optional names-free region-news line ("a debutant from a gym in the region signs pro") in `WorldNews`, or CUT — owner's call; not required for the offer to work |
| M11 | Week review | TURNED PRO lines for 4 weeks after signing (cut lost $75/wk, stipend saved), then THE DEBUT ledger (share − costs = net) and one NEXT line | `WeekReview.gd:26/:152` → `ProWeekLines.rows/lines_for/next_line` (`ProWeekLines.gd:62/:15/:46`) | BUILT | TO BUILD: on the debut ledger, add "forecast N — sold N" (both `ProOfferWire.forecast` at booking vs `night()` at settlement — the promised-vs-actual line the critic demanded; no new screen, one line) |
| M12 | Fighter → History | gold caps milestone "TURNED PRO WITH <HOUSE>, <DATE>" between amateur and pro records | `BoutHistory._milestone` (`BoutHistory.gd:67`) | BUILT (v6's "Week N · House · Opponent" claim was fiction) | nothing; if the house is ever to appear as logo instead of text, that is art scope, not design |
| M13 | Fights → pro ladder | after the debut: three offers per fight (tune-up / step up / payday, 7 days), the road map; post-debut house lean for the first 6 pro fights | `ProLadder` (`OFFER_DAYS := 7`, `ProLadder.gd:31`), `ProLean.line/extra` (`ProLean.gd:41/:12`) | BUILT | keep visible — this is what makes the house choice a career choice (Bow Lane step-ups vs Harrow & Finch tune-ups), replacing the missing "compare over a career" view with something already in the game |
| M14 | Toasts | sign / stay / ask / press-feedback toasts | `RosterActs.gd:69–91` (`prooffer`, `turnpro`, `proask`, `proplain`, `declinepro`) | BUILT | nothing |

No new screens appear in this table, and none is proposed. The modal stays one modal; the offer stays one decision.

## 9 — The wrong CODE claims in v6, corrected (each opened in this checkout)

v6 shipped with a wrong-claim problem the code does not support. Corrected here, one by one; the v6 status line "All constants verified against S530 + TURNGAP1" was not accurate.

| # | v6 claim (tag) | The code says | v7 tag |
|---|---|---|---|
| 9.1 | Day-job first call: 6 wins + top 3 (CHANGE) | No day-job branch anywhere in `pro_ready`/`make` (`Roster.gd:185`, `ProOfferWire.gd:24`); measured 3/180 first calls (day-job median 6–2, best rank 4 at w104 — TURNPROBE3B) | MISSING (proposal never built); §7 option set |
| 9.2 | After decline: "need +2 wins", terms ×0.9 (CODE) | Need is 9 wins top-3 or 11 any rank (formula, not "plus two"); terms ×0.9 PER decline, compounding; already-eligible boxers get the call with zero new wins (`Roster.gd:191–195`; `ProCall.gd:73–86`) | CODE corrected |
| 9.3 | A two-house refusal: "same promoter calls" (CODE, incomplete) | Records only the FIRST house of a joint offer; the other can never call while `pro_declines ≥ 1` (`on_decline` `ProOfferWire.gd:166–170`, `make` `:34–36`) | CODE corrected |
| 9.4 | Expiry: "not a decline; waits 2 wins; FULL terms" (CODE) | Lapse sets `pro_wait_w = wins+2` and no decline (`ProOfferWire.gd:172–184`), but prior decline factors still apply — full terms only at zero declines or after a title (`ProOfferWire.gd:33`, `ProCall.terms` `:73–86`) | CODE corrected |
| 9.5 | After 3 declines: door closed permanently (CODE) | True in code (`pro_ready` false ≥3, `Roster.gd:186`); no feature resets `pro_declines` anywhere in the checkout | CODE kept, reachability CUT (§12) |
| 9.6 | Offer window 14 days (CODE) | `WINDOW_DAYS := 14` is tagged ESTIMATE in the code itself (`ProCall.gd:15`); expiry is 14 days and the flag shows no countdown (M1) | ESTIMATE-in-code |
| 9.7 | Age cutoff 32+, warning from 29 (CODE) | Enforced only at ZERO declines (`ProOfferWire.gd:26–27`); both constants ESTIMATE-in-code (`ProCall.gd:14`, `:322–334`) | ESTIMATE-in-code + gate corrected |
| 9.8 | Later +2 "best for conflicting amateur bout" (CODE) | No best-use rule exists; offers cannot exist while a bout is booked (`Roster.gd:206`); the rationale is impossible as written | CUT (rationale); ESTIMATE (real uses) |
| 9.9 | Price: "above 91 tickets: plain $25/ticket vs price $20 → −$25/ticket above cap"; "above 91 = −$200 total income" (CODE) | $25/$20 are gross ticket-share RATES past break-even, not incremental deltas; vs plain the price ask at 91-forecast gains $25, ties at 92, loses $200 at 100 (gross, pre-split); "above 91" is not one number, and no such warning exists in the modal (§6.2; `ProOffer.gd:_ask` `:149–171`) | CODE corrected (numbers) |
| 9.10 | Price: button shows "Above 91 tickets: −$200 total income" (CODE) | The button renders the generic label; extra tickets and price live in the tooltip; −$200 applies only at forecast 100 | CUT (the claim) |
| 9.11 | Costs: "removed the loyalty cliff (−10)"; v6's "−5% share ×3 fights" | No loyalty effect of the costs ask exists in the code at all (no costs key in `Loyalty.MOVES`; nothing applies loyalty there). The cliff was invented in v5 and corrected against itself, not against code. −5%×3 is new, unvalidated, and backwards (§6.3: would not fix dominance, costs the honest play $330) | CUT (both) |
| 9.12 | Later +4 restored: "+~8 tickets visible" (CHANGE) | Drift caps at 6 members/week (¼ of gap, min 1); +12 max over 4 weeks, only if target > stock (`Membership.gd:19,29,45`; `ProDebut.PER_MEMBER` `:13`); "8" was arithmetic error; AND no at-night forecast is rendered anywhere | ESTIMATE corrected + TO BUILD preview |
| 9.13 | Later +2: "+~4 tickets (6 members × 0.5)" | 6 × 0.5 = 3, not 4; same cap stale | ESTIMATE corrected |
| 9.14 | Top bar flag "PRO OFFER — 14-day countdown; red last 3 days" (BUILT) | Flag is static "PRO OFFER", always red (`Needs.gd:163`, `Shell.gd:153`); the countdown lives on Home and in the modal (`Needs._pro_line` `:194`, `ProOffer.gd:37`) | CUT (claim) |
| 9.15 | M4 "NEW win chance" (BUILT label) | The modal never calls `BoutRead`; raw gap text "a debutant %.1f under" is what ships (`ProOffer.gd:128`; grep confirms no BoutRead in the modal) | MISSING / TO BUILD |
| 9.16 | M5 "Wired To: ProCall.asks()" (BUILT) | The grid shows SIX asks per house; hiding softer/split is a UI change that has not shipped (`ProOffer.gd:149–171`) | BUILT (6 asks) + TO BUILD (cut two) |
| 9.17 | M6 "ambition wired and visible" (BUILT) | Nothing on the modal reads ambition/day-job; the "pro" morale branch is unreachable (§7); no gate, no badge | MISSING / TO BUILD |
| 9.18 | M8 "route type, age warning, declines left, next offer date" (BUILT + route label) | Shows steps, tickets-vs-BE today, age line, declines left; route and next-date MISSING (`NextStep.pro_line` `:73–90`) | BUILT (partial) |
| 9.19 | M9 hover: "each changes … pro call gate" | No such gate or text anywhere in the stipend UI (`MoneyPanels.gd:240–276`) | CUT (fiction) |
| 9.20 | M10: "World → News: a boxer from the gym signs pro — no names" | No pro-signing line exists in WorldNews; only the named signing toast/news at `Roster.gd:313` | MISSING / optional |
| 9.21 | M11: "Amateur cut lost −$75/wk; stipend saved +$250/wk" | Real lines exist but are weeks-since-signing based and read the real stipend (day-job: $0 saved, bad line) (`ProWeekLines.gd:15–44`) | BUILT, claim corrected |
| 9.22 | M12: history milestone "Turned pro — Week N · House · Opponent" | Milestone is "TURNED PRO WITH <HOUSE>, <DATE>"; no week, no opponent (`BoutHistory.gd:67–71`) | BUILT, claim corrected |
| 9.23 | "Softer opponent — tune-up code unused" | `f["pro_tune_ups"]` is set at signing and consumed by `ProLean` (`ProLean.gd:12–33`, `:41–47`; set `Roster.gd:311`); tune-ups ARE wired | CODE corrected |
| 9.24 | "Window expires: promoter waits 2 more wins, FULL terms" (v6 §1.1 table) | See 9.4 — full terms only at zero declines/title | CODE corrected |
| 9.25 | v6 target line: "Day-job careers ≥ 30% get first call" (probe target) | Measured 3/180 at w104, rank-leg bound; the gate change was never built (§7) | ESTIMATE target refuted; see §12 |
| 9.26 | "Debut win chance ~67% / ~79% (target 65–80% / 70–85%)" (CHANGE) | Measured TURNGAP1 at PROPOSED gaps (−1.0 → 67.0%, 0.0 → 78.5%, n=200 each); CODE today is 1.0/1.5 with a measured 94% debut win rate (TURNPROBE3B); displayed number would be ~45/~50 via `BoutRead.likely` (§11) | ESTIMATE (proposal, not installed) |

Rule going forward for this map: nothing is tagged CODE unless the file was opened, and every number that is not in the code says ESTIMATE — including every pick-rate target, which is calibration, not design.

## 10 — Both critics' To reach 10/10 lists, answered point by point

Two live critics reviewed this mechanic: the ARENA critic (v6, scored depth 5 / general 4) and the DOLA_DOLA critic (v3 review). The task's "v4 critic" has no file in this checkout; the ARENA review is the latest and it is answered in full, and the DOLA_DOLA review — whose list the owner still wants answered — is answered in full. Each item: done, or one line why not.

### 10.1 The ARENA critic (v6) — To reach 10/10
1. "Make the return rules coherent before balancing. Record wins and eligible houses at refusal or expiry. Decide whether 'two more wins' means since that event and enforce it consistently; preserve or reset decline factors explicitly. Give expiry a distinct cost from immediate refusal, or use one clear wait action. Show exact requirements rather than an eight-week promise. Cover zero, one and two prior refusals, titles, both houses, age cutoff and save/load."
→ ANSWERED in §5, all eight sub-points: (1) record house+wins at refusal or expiry — §5.3 TO BUILD; (2) "two more wins" stays "from the wait count", never "since decline" — the misleading phrase is deleted from the copy, requirements always computed from `pro_ready` (§5.2/§5.5); (3) decline factors are compounding and preserved across lapse, reset only by a title — kept, made explicit (§1.5, §9.2/9.4); (4) expiry's cost is TIME — fold it into one wait action ("Review later") and make the lapse itself legible (§5.1/§5.4); (5) exact requirement text, never eight weeks (§5.2/§5.5); (6) zero declines → both houses re-rolled, one → first-called house calls, yours at expiry preserved (§1.1/§5.3); (7) one or two declines covered explicitly in the on-offer ladder text (§5.5); (8) save/load: fields persist today, verified against `SaveGame` (§1.8); (9) titles: factor resets on title-since-decline, kept as-is (CODE), now stated on the offer (§5.5); (10) age cutoff: gate corrected to zero-declines-only disclosure (§9.7). A test plan for all of these is §12, not new code.
2. "Make each decision truthful end to end. Future ticket projections from actual member drift with a range, 100-seat capacity and assumptions; settle from actual night values; preview gross and net for both parties, signing cash and weekly stipend/cut changes; recompute the price warning at the current forecast, shown on the action; forecasts must not be guaranteed income."
→ ANSWERED (§4, §8 M4/M5, §6): at-night forecast = night settlement values (code already settles from night values, `Roster.debut_night` `:246`; the PREVIEW is the missing piece — TO BUILD with a labeled range, not a single number); both parties' proceeds shown (modal already shows gym/boxer/pays-back — CODE); signing cash (the pays-now row — CODE); weekly stipend/cut changes (the each-week line — CODE); price warning recomputed at the live forecast on the button (TO BUILD) and at-night cap handling (§6.2); forecasts labelled "today / at night / ESTIMATE", never as guaranteed income; the at-night preview carries its assumption line (drift cap 6/wk, ¼-gap, floor 0, cap 100).
3. "Implement and test the proposed changes, not just labels. Wire the new opponent gaps into booking; show BoutRead as a calibrated range with scouting uncertainty; test across fighters/camps/styles/booked fights; implement the costs penalty with precise percentage-point, floor, and three-fight expiry semantics, show its total estimated cost; wire ambition using the actual recruit text; make the day-job gate and nine-win alternative explicit."
→ ANSWERED as follows. Gaps −1.0/0.0: NOT wired (still 1.0/1.5 in code, §9.26) — TO BUILD in `ProCall.promoters` (two constants) with a rerun of TURNGAP1 to confirm in the real booking path (the earlier probe overrode the deal gap, and the debut rebuilt it fresh; see §11). BoutRead as a range: TO BUILD on M4, displayed as "about N%" with the honest band; calibration first (§11) — showing the raw 45/50 today next to a measured 67/79 would be a lie, so calibration is a PREREQUISITE, tag ESTIMATE. Costs penalty (−5×3): REJECTED with numbers (§6.3) — no such semantics are built, and it would not achieve the ≤40% goal; if the studio still wants it, the full spec would be: −5 percentage points off `gym_share` (0.25→0.20), floor = `Loyalty.pro_share` floor (0.10 under 50), starts at the FIRST pro fight AFTER signing, expires after 3 paid pro nights, shows total estimated cost on the button ("about $X over 3 fights") — NOT adopted in this map; it is listed so a future probe can measure it (Q2). Ambition: answered in §7 (one string + display rule + the reachable −5). Day-job gate: options (a–d) in §7, decision is the owner's with probe data; the NINE-WIN alternative is already explicit in Next Step (`NextStep._need_for` `NextStep.gd:113–121`) and is repeated on M6.
4. "Test for real choices rather than target uptake alone. Seeded career cohorts across ticket bands, cash, injuries, ambition, titles, day-job routes, both sexes; compare plain and each ask including future purse growth, coach time, closure, morale, win/loss risk; report sample sizes and uncertainty; verify no action dominates within a meaningful reachable state; tune houses and waits BEFORE enforcing pick-rate targets."
→ ANSWERED: §12 rewrites the pass lines as hypotheses with sample sizes and uncertainty; the selection rule (no action dominant in any reachable state) is adopted as the ONE hard line; pick-rate bands drop to tripwires; boundary tests at 45/46/74/75 and 84/85/91/92/100 added (the 84/85 boundary is where price's 15 extra tickets stop fitting under the cap; 91/92 the crossover); and the tune-before-target rule is adopted verbatim: houses/waits tune FIRST, bands second. "Both sexes" cohorts: the sandbox rule (§14) requires any result quote to hold for every boxer the game generates; note PRO_OPP_NAMES are hardcoded to a women's division (`Roster.gd:53`) — a content issue flagged to the owner, out of scope here.
5. "Make the milestone playable across weeks. Add the review-later action, links to week/weight/camp, a visible post-signing timeline with cost paid, training milestones, and a post-fight comparison of forecast versus actual. Keep post-debut offer bias as a visible contract consequence. Avoid extra screens or interrupting the weekly flow."
→ ANSWERED: review-later = §5.1; week/camp links: the offer modal links NOTHING today, and adding navigation out of a signing decision is a design smell — instead the Fighter page (Next Step) and week review carry the consequences (M8/M11), which are already one click away; a side link to the Week page from the modal footer is permissible as the same-moment answer to "what does this do to my camp?" (TO BUILD, disposable link, no new screen); visible post-signing timeline = the week-review ledger lines for 4 weeks + debut ledger with the new forecast-vs-actual line (M11, TO BUILD) — that is the comparison, delivered in existing flow; cost paid = `costs` in `pro_signed` is already stored and shown via the ledger (`ProWeekLines.gd:28–40`); training milestones = existing TAPER and the debut booking itself (no extra structure); post-debut bias as a visible contract consequence = ProLean's line is already on the Fights screen (M13) — keep it visible, cite it on the offer card ("Harrow & Finch leans tune-ups for your first 6 fights" — TO BUILD one line).
6. "1920×1080 page description: warm gym wall, single header + countdown, two equal paper cards, each card: gross purse, risk, debut date, opponent chance range, now-and-projected tickets, gym cash now and night proceeds for both parties, per-card one ask with before/after cost, card-local Sign; a narrow strip for boxer ambition/route/opportunity/bias; footer Review later and one honestly costed Stay amateur; disabled actions explain why; side link to week/camp; no invented names."
→ ANSWERED in §15 as a labelled PROPOSAL (not a claim about the current modal), with the owner rules applied: names only in card headers, the house name only in its header, buttons say "Sign", disabled asks say why, Review later present, Stay amateur carries its cost, and the only person in the header is the fighter's first name — the fighter's name in a screen header is the one place the existing UI already uses names.
Missing points from the same review (its "Missing:" list), answered:
- "An explicit review later close action that leaves the offer live, with the real expiry stop" → §5.1/M7. TO BUILD.
- "A comparison of cash now, gym and boxer proceeds on fight night, weekly changes and future house purse/offer bias" → parts already in the modal (pays-now, each-week, boxer, pays-back — CODE); bias line added on the card + kept on Fights (§5.5/M13); a single "at the night" forecast is the missing number (M4). TO BUILD.
- "A link to the week/camp and weight forecast before signing" → TO BUILD one disposable link in the footer to the fighter's Week page (existing screen, existing route, no new screen); NO weight forecast exists on the offer today and none is invented for it.
- "An honest opponent win range plus uncertainty and scouting limits" → M4 (TO BUILD): BoutRead.band as lo–hi with the "hidden tells move nothing until found" rule already built into the band math (`rating_range`/`band` `BoutRead.gd:92/:398`); the display says "unscouted" when `stage()["found"] == 0`.
- "A route/eligibility explanation including the nine-win alternative and why an offer cannot arrive" → M6 strip line + M8 need text; the "why not yet" line lives on Next Step (not here — an offer modal with no offer waiting is not rendered).
- "Do not promise a delay resolves a booked-bout clash" → kept (§3 Choice B, §9.8).

### 10.2 The DOLA_DOLA critic (v3) — To reach 10/10 and its Missing/Useless table
P1 — Fix the dominant choice & visibility:
1. "Show the loyalty effect clearly on the Costs button — 'Future pro purses: gym share −X% for 3 fights'" → DONE in spirit, with a correction: there IS no loyalty effect to show (code has none, §9.11); the honest button line is the fee/total line (§6.3). If a penalty is ever adopted (Q2), this exact line is its spec.
2. "Surface the day-job advantage on the offer — badge 'Day-job fighter: offer arrived earlier (6 wins vs 7)'" → REJECTED as written: the 6-win gate does not exist, so the badge would print a lie. Replaced by the route line (§7.3) and, behind the owner's decision, option (a)/(b) (§7.5).
3. "Add one-line context on the ambition match — 'She wants to turn pro — signing now: morale +5'" → DONE (§7.2), minus the pronoun (sandbox rule) and with the actually-reachable rule (title −5 pre-nationals) plus the one-string fix that makes +5 real (§7.1).
P2 — Deepen the choices:
4. "Add one real negotiation option per house — Bow Lane: move the debut outdoors, +15 tickets, weather risk; Harrow & Finch: 2 extra weeks' camp, opponent gap +0.3 (harder), win rate −5%" → REJECTED, one line each in §13: no outdoor-venue system exists for pro nights (a new system, new weather risk, new balance surface — a CUT by the no-new-systems rule); and "2 extra weeks for +0.3 harder" is Later +2 with a disguised second cost — the one-ask design already prices that trade (purse vs time), and coupling difficulty in would double-charge the same currency with no probe behind it.
5. "Show projected win rate beside each opponent gap — '~72% chance to win'" → DONE, with the method attached (§11): displayed as a calibrated ESTIMATE range, not a fake precision point; today's code path would print ~45/~50, which is why calibration is a prerequisite, not an afterthought.
P3 — Feel & feedback:
6. "The moment of signing: a short, distinct milestone card — 'Turned Pro — Licence #XXX, first fight scheduled — she's no longer just your boxer'" → PARTLY DONE, no new screen: the History milestone exists ("TURNED PRO WITH <HOUSE>, <DATE>", `BoutHistory.gd:67`) and the week-review TURNED PRO ledger lines exist (M11). "She's no longer" is a fixed-pronoun line (§14) and a new modal would breach no-new-screens; if the owner wants a ceremony, it extends the EXISTING milestone line, not a card. Licence numbers do not exist in the code (no licence counter) — not invented here.
7. "Next Step forecast: show the full timeline — 'If you decline now → next offer in ~8 weeks at 2 more wins → window closes permanently after 2 more declines'" → DONE IN SUBSTANCE, with the wording fixed: exact requirements, never a date promise ("~8 weeks" is a calendar claim about wins nobody can schedule); the words: after a refusal — "9 wins and a top-3 ranking (or 11 wins) brings the call again, at 0.9× terms"; after two — "only a regional No.1 brings a call"; after three — "no promoter will call" (§5.2/§5.5; the raw strings already exist as `DECLINE_NEWS`, `Roster.gd:39`).
P4 — Data confirmation:
8. "Run the paired gap probe — confirm 1.6/2.1 lands in 65–85%; adjust if too easy/hard" → DONE as TURNGAP1 (2026-11-20): measured curves −1.0 → 67.0%, 0.0 → 78.5% (n=200 per gap, 20 boxers × 8 gaps × 10 seeds); the map adopts −1.0/0.0 as the PROPOSED signing gaps (ESTIMATE — NOT INSTALLED; in-code gaps remain 1.0/1.5 and the debut is measured at 94%, TURNPROBE3B). TURNGAP2 required in the real booking path.
9. "Verify the loyalty curve — does −10 loyalty meaningfully change the Costs pick rate from 74% toward the 40% target? If not, increase to −15 or make the share penalty steeper" → DONE WITH A FINDING: the −10 loyalty cost never existed in code (§9.11), so there was nothing to verify — the 74% was measured against a fee of $100/$200 only. This map therefore reasons from the fee: §6.3 shows no point-penalty in the proposed range closes the dominance for cash-poor gyms, so cranking the penalty is the wrong lever; the fee stays at $100/$200 and the probe line moves to the closure-risk comparison (§12). Sample sizes and uncertainty are now required on the line (n=360 read with its defect; treat direction only).

Its Missing/Useless table, answered:
- "Bow Lane — harder opponent (1.6 gap)" / "Harrow & Finch — easier opponent (2.1 gap)": superseded by TURNGAP1's measured −1.0/0.0 and the 1.0/1.5 that ships in code; "harder/easier" ordering kept.
- Later +2 "missing: no preview of exactly which week the new date lands" → ANSWERED (M5): on-button date text ("debut on <date>"), already computable from `Roster.debut_day(c.day, weeks + asked)` — the button can say it today; TO BUILD.
- Later +4 "useless — purely cosmetic delay" → ANSWERED in §4 row 2: kept ONLY with the at-night preview; otherwise CUT (this map's decision rule, not a loophole).
- Own price "cap cost was hidden — now visible in v5" → PARTIALLY — v5 made the cap visible in prose; the live warning on the button is still not in code (§6.2 crossover 92, must be recomputed); TO BUILD.
- Costs "dominant pick — loyalty penalty new and untested" → ANSWERED (§6.3, §10.2 P4.9): penalty deleted; dominance diagnosed as cash-flow rational; display fix adopted; probe required.
- "No way to negotiate opponent quality directly — you only pick the house" → ANSWERED: that IS the matchup dial of this design (the house pick IS the opponent negotiation, by date/purse/risk/lean); a direct opponent-quality dial is the softer ask, CUT on probe evidence (§4) — one line why not: measured 0% best.
- "No option to decline and explain — staying amateur is a binary yes/no" → ANSWERED: "explain" is not a game action; the truthful version is the route line (§7.3) and the decline's visible costs (§5.6). No dialogue trees (no new screens; plain words).
- "No career pacing control — you can delay 2 weeks or let it lapse, but can't say 'wait until after the nationals'" → ANSWERED: the passive lapse IS that control — a player who wants to clear the offer without refusing simply lets it run out (no loyalty/morale cost, §1.5); plus the nationals already gate offers (`check_pro` skips `Champs.active` fighters, `Roster.gd:206`) and a national finalist is called at any record with zero declines (`pro_ready` `:188`). A separate "wait until after nationals" action would be a third refusal button doing what lapse already does — CUT.
- "Day-job status doesn't appear anywhere on the offer screen — the easier gate is invisible until you open Next Step" → ANSWERED (§7.3/M6): strip line TO BUILD; and the "easier gate" is corrected — it does not exist; the truth is the opposite (day-job boxers almost never get called, §7.4).
- Milestone card / licence number: see P3.6 — folded into History milestone + week ledger; licence counter does not exist; not invented.
- "Window closes permanently after 2 more declines" in their mockups: corrected to 3 (the game's rule is 3, `pro_ready` `:186`), and both critics' "2" is the same arithmetic slip repeated; this map uses 3.

## 11 — The debut opponent gap: what is measured, what is displayed

TURNGAP1 (`docs/TURNGAP1_RESULT.md`, 20 boxers × 8 gaps × 10 seeds, run 2026-11-20): win share by gap — −4.0 → 35.5%, −2.0 → 41.0%, −1.0 → 67.0%, 0.0 → 78.5%, +1.0 → 79.0%, +2.0 → 79.0%, +4.0 → 83.5%, +8.0 → 96.5%. Per-gap medians are 40/40/80/90/90%… — a bimodal outcome (the fighter usually wins or loses on style fit and form, not on the gap increment). Note the caveat the probe itself carries: one night's form variance dominates inside a gap.

The offer would show, via `BoutRead.likely` at signing (`BoutRead.gd:407`): −4.0 → 31.8%, −2.0 → 40.2%, −1.0 → 45.3%, 0.0 → 50.5%, +1.0 → 55.2%, +2.0 → 59.6% — far below the measured win shares, because `chance()` models a single bout with form integrated at SD·√2 and the probe curve includes selection (boxers called to those gaps are already good). Both numbers are true for different questions; the modal must not print either as "the" chance until the calibration question is answered.

DECISION (ESTIMATE, not installed): set `ProCall.promoters()` gaps to Bow Lane −1.0 / Harrow & Finch 0.0 (the TURNGAP1 "gap targets" lines: −1.0 for the 65–80% band; 0.0 for 70–85%) and show on each card:
"About 4 wins in 10 to 8 in 10 — scouting narrows this" style honest range: the code already has the machinery (`BoutRead.band` `BoutRead.gd:398`, fed by `stage()` `:66`, `rating_range` `:92`, and `SLACK := 0.03`); until TURNGAP2 recalibrates it against real booked debuts, display it as a WIDE range with the word ESTIMATE, never a point. If calibration cannot land, show the TURNGAP1 measured share as the line ("debutants at this level win about 7 of 10") — a probe observation is at least an honest one, labeled with its n.

What is NOT changed: `Roster.PRO_OPP_GAP := 1.0` (`Roster.gd:52`) is only the fallback for missing deal data — deals always carry the house gap, so the houses' values are the real lever; `PRO_OPP_NAMES` (`Roster.gd:53`) remains a person-named string constant used in body copy at debut (History rows, toasts) — flagged to owner (§14, names rule) as a content decision, out of scope for this map.

## 12 — Probe lines v7 (calibration, not design law)

Reframe: TURNPROBE3/B ran 360 careers × 104 weeks with fork defects in two lines, so its direction is trustworthy and its decimals are not; every line below states its measure and its sample caveat. No line is enforced until the tune-before-target rule is satisfied.

| # | Line | v6 status | v7 measure (ESTIMATE targets until re-probed) |
|---|---|---|---|
| 1 | No action dominant in a meaningful reachable state | not measured as such | HARD line: in seeded cohorts (≥ 180 careers per house band, low/high cash × full/day-job × ambition), no option beats every other option by a margin that survives ±1 SD at w104 and w156. Boundary cells: 45/46/74/75 (who calls), 84/85/91/92/100 (price cap and crossover) |
| 2 | Costs best-pick rate | 74% (TURNPROBE3B) | not a beat-the-target line; report the rate with the closure-risk split (runway < 8 weeks). If it stays > 50% among cash-RICH gyms, the fee is too low (raise COSTS_BASE_ADD, ESTIMATE) before any share penalty is considered (§6.3) |
| 3 | Price best-pick at ≥ 92 forecast | 6% | expect ≈ 0 above the crossover with the live warning; below 60 the ask wins by design (shortfall avoided) |
| 4 | Day-job first-call rate at w156 | 3/180 at w104 | re-measure at w156 AND with stipend-half included; if still < 10%, the 6-win gate (§7 option a) or any-rank (option b) goes to the owner with numbers; do NOT adopt silently |
| 5 | Door: 2nd refusal reachable | 0/60 (TURNPROBE3B) | reframe: report the DISTRIBUTION of declines (0/1/2/3) at w104/w156; keep 10–30% door-closes only if the gates are re-tuned; otherwise CUT the target and say the door is vanishingly rare by construction |
| 6 | Ambition alignment (sign when pro-ambitious) | 1/30 (dead path) | after the one-string fix (§7.1), expect alignment ≫ 70% with an n reported; the +5/−5 needs a live path before the line means anything |
| 7 | Debut win rate at proposed gaps | 94% at 1.0/1.5 (TURNPROBE3B) | re-run TURNGAP1-style seats in the REAL booking path; target bands −1.0 → 60–75%, 0.0 → 72–85%; adjust gaps one notch, not three |
| 8 | Win chance DISPLAYED matches measured within 10 pp at each gap | never measured | M4 calibration gate: `likely()` within 10 pp of the measured share at the two installed gaps, on n ≥ 200 booked debuts; otherwise ship the wide band, not a point |
| 9 | Two refusals distinct in behavior | untested | Stay: declines+1, loyalty −8, terms 0.9ⁿ; Review-later/lapse: no decline, wait counter +2 wins; verify neither silences the other; verify save/load across the window (§1.8) |

Report format for any rerun: n, seeds, horizon weeks, the numbers above with intervals, and the boundary cells — the same honesty this map applies to the code.

## 13 — CUT list (removed on purpose, with reasons)

1. Softer opponent ask — CUT from the offer UI. Reason: measured 0% best (TURNPROBE3B); one dial for two effects (this debut and the next two offer sets); tune-ups remain wired for the code path (`SofterAsk` sets `pro_tune_ups`; `ProLean` consumes it) if the owner later wants it back.
2. Better split ask — CUT. Reason: 0% best; dominated by price in the same +5..+20 band; +0.5 harder opponent is an invisible cost (players cannot read 0.5 rating points).
3. v6's "−5% gym share for 3 fights" costs penalty — CUT. Reason: would not flip dominance (§6.3), punishes the honest closure-insurance play, and had no code or probe behind it.
4. Outdoor/relocation negotiation (DOLA_DOLA P2.4, Bow Lane) — CUT. Reason: no outdoor-venue system exists for pro nights; a new weather-risk system is a new balance surface, and the one-ask rule prices trades honestly without it.
5. "2 extra weeks camp, gap +0.3 harder" (DOLA_DOLA P2.4, Harrow & Finch) — CUT. Reason: Later +2 already sells time for purse; coupling a harder opponent double-charges the same trade with zero probe support.
6. "Wait until after the nationals" as a distinct button — CUT. Reason: lapse already is that action, the nationals already block offers (`Roster.gd:206`) and override the record gate at finals (`pro_ready` `:188`); a third refusal is noise.
7. A signing milestone MODAL / licence card — CUT. Reason: no-new-screens; the History milestone and the week-review ledger carry the moment; licence numbers do not exist in the code.
8. The "8-week return" promise anywhere — CUT. Reason: wins are not scheduled; exact requirement text only (§5.2).
9. The top-bar countdown / red-last-3-days — CUT. Reason: not in code; the flag is static; the Home note carries the days.
10. The "pro call gate" stipend hover claim — CUT. Reason: fiction.
11. The "≥30% day-job first call" pass-line as a hard target — CUT pending TURNPROBE3C (§12 line 4).
12. Names in buttons / in body copy — CUT as a rule ("Sign" inside a card headed by the house name; the fighter's first name stays a header). House art badges in card headers keep (they are organisation identity, as in the current modal).
13. v6's "one ask per offer per house" phrasing kept; the "return to plain always available" kept but scoped to post-counter (code only rolls back after a counter, `back_to_plain` `ProOfferWire.gd:92`).
14. Behavioural prediction targets (uptake bands) as pass/fail — CUT as design acceptance; demoted to §12 tripwires after tune-before-target.

## 14 — Owner rules kept (verbatim where quoted)

- Sandbox (S412, CRITIC_PACK): "the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never a fixed he or she in text or mockups." — This map quotes code strings verbatim (they obey it) and proposes no he/she anywhere (§7 strips them from the ambition line and card copy).
- Names only in headers (S448, CRITIC_PACK): "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule" — house names stay in the modal header and card headers; persons' names: only the fighter's first name in the modal header and History; the debut opponent's generated name (Roster.PRO_OPP_NAMES, Roster.gd:53) shows today in debut rows and History data (data, not menu copy) — flagged for the owner, not silently re-scoped.
- Only actionable information (CRITIC_PACK §7): "i do not want stupid and unecessary information to be displayed unless the player can really do something about it" — M6 shows route/ambition only because both change a decision; the raw gap goes when the chance range ships; everything disabled says why.
- One top bar and modals; nothing opens by itself; weekly job pages must not become pop-ups (CRITIC_PACK §7) — the design adds zero screens and zero interruptive flows; Review later closes, it does not open.
- Everything new ships switched ON (CRITIC_PACK §7) — the To BUILD items above are specs for the next build, not flags; nothing is half-on.
- Hover explains every number (CRITIC_PACK §7) — kept for the price crossover and the costs fee (line or tooltip, not tooltip-only, §10.1.2).
- Offers an option only if the player can act on it (CRITIC_PACK intro + §7) — Review later is actionable; softer/split are not chosen often enough to justify the slot; Stay vs let-run-out are both acts with visible costs.
- From v6's kept list, kept here: names only in headers; gender-neutral; no new screens; actionable info only; 14-day window; TAPER week before bouts (`WeekPhase.phase` `WeekPhase.gd:43`, opened).
- No flavour text; plain words; one word per concept (CRITIC_PACK §1/§7) — the copy sketches above obey it; "wait" never means two different things without a counter.

## 15 — 1920×1080 page description (PROPOSAL — not a claim about the current modal)

One warm gym-wall panel, the existing modal kit aesthetic (the current ProOffer already uses the kit; nothing is re-themed and no screen is added):
- Top strip: "TURN <FIRST> PRO?" left; right-aligned "The offer stands N more days" and "Declines left: N of 3" — two lines, both from code (`days_left`, `pro_declines`). The refusal-ladder warning sits here, not after a refusal.
- Two equal paper cards, Harrow & Finch left / Bow Lane right (or forecast order; house names only in card headers beside the badge art): purse + guarantee terms, break-even vs the forecast bar, tickets-now and tickets-at-night with its assumption line, "about N wins in 10 — ESTIMATE" chance range, debut date (Saturday), after-debut ladder hint ("leans tune-ups/step-ups for 6 fights"), one ask well per card showing the live before/after cost on the button.
- Each card: card-local "Sign" button; a card-local collapsed option or nothing for asks won't-take (disabled with the reason: "the guarantee house won't change the ticket price").
- A narrow strip under the cards: boxer line ("Wants the pros — signing now: +5 morale / staying: −5"), route line ("Full stipend / Day job: 4 of 6 mornings"), eligibility line ("7 wins and a top-3 ranking brings the call — or 9 wins, or the nationals final").
- Footer: "Stay amateur" with its costs on the button ("loyalty −8 · next call 0.9× · needs 9+3 wins and a top-3"), and "Review later" ("offer stays live; N days left; gone in N days if you don't decide; no refusal recorded"), plus a disposable link "See the week" to the existing Week page.
- Disabled states explain themselves inline; nothing is grey without a reason; no invented names anywhere in copy; countdowns never duplicate the flag.
- Explicit non-goals: no licence number, no illustrated contract, no separate signing ceremony screen, no opponent portrait choice, nothing modal on top of the modal.

## 16 — Changed from v6 — summary

1. Written from the code, with §9 as the bill of indictment for the v6 verification claim (26 corrected lines).
2. Gap proposal kept (−1.0/0.0 from TURNGAP1) but tagged ESTIMATE and NOT installed; calibration (§11) is a prerequisite for display; TURNPROBE3B's 94% at installed gaps reported without flinching.
3. Costs ask: v6's −5%×3 penalty CUT with arithmetic (§6.3); fee IS the price; display fix adopted; dominance diagnosed correctly for the first time.
4. All six asks shown in code; the design hides softer/split (CUT) and keeps Later +4 ONLY with an at-night forecast (else it cuts again).
5. Price: the "91/cap/−$200" trio replaced by the true 92 crossover and the live-warning requirement (§6.2).
6. Expiry made coherent: "Review later" wait action, exact-requirement text, event recorded; "full terms" and "~8 weeks" promises deleted (§5).
7. Boxer's voice wired for real: one ambition string makes the dead +5/−5 path live; the title −5 is stated; day-job strip shows truth, not a fictional 6-win gate (§7).
8. Menu table kept in full, with CODE TODAY vs TO BUILD per row and twelve rows, not ten (M13 pro ladder, M14 toasts added).
9. Both critics' To reach 10/10 answered line by line (§10), including the DOLA_DOLA list and its missing/useless options, and including the one-line why-nots.
10. Probe lines reframed as calibrated hypotheses with sample sizes, boundary cells 45/46/74/75 and 84/85/91/92/100, tune-before-target adopted (§12).
11. Owner rules re-quoted and re-obeyed, including stripping names from buttons and "she" from the ambition line (§14).
12. v6's probe questions closed or re-cut: Q3 (day-job 30%) CUT-for-now pending TURNPROBE3C (§7/§12); Q1 (Costs ≤40%) retargeted to the cash-rich split; Q2 (Later+4 ≥5%) kept with the mandatory preview; Q4 (gap stability) = TURNGAP2 (§17).

## 17 — Outstanding questions

Q1. TURNGAP2: recalibrate `BoutRead.likely`/`band` on real booked debuts in the shipped booking path (not the probe override); gate the M4 point display on it (§11, §12 line 8). Owner: whoever runs the next probe session.
Q2. If the studio still wants a costs-ask penalty: adopt precisely — −5 percentage points off `gym_share`, floor `Loyalty.pro_share` (0.10), first pro night AFTER signing, expires after 3 paid pro nights, "about $X over 3 fights" on the button — and measure dominance with it BEFORE enforcing anything (§10.1.3). Otherwise fee-only (CODE) stands.
Q3. Day-job: adopt option (a) 6 wins + top-3 (would still likely fail on the rank leg), option (b) 6 wins any rank (double-permissive, needs the door re-probed), or accept (c) the arithmetic and CUT the 30% target. Owner's call; probe at w156 first (§12 line 4).
Q4. The debut opponent's display name (`Roster.PRO_OPP_NAMES`, person strings shown in bout data and History rows, `Roster.gd:53`): replace with a stable label ("Bow Lane stable") or keep as data? Names-only-in-headers would say replace; records-as-data says keep. Owner decision; out of this map's scope.
Q5. Save/load across a live offer: fields persist by construction (§1.8) but there is no round-trip test; add one to the next Godot test run (not in this task; no code changes allowed here).
Q6. Joint-offer refusal records only the first house (§9.3) — is that intended design ("the house you were going to sign with follows you") or a defect? If defect, `on_decline` should record the house the player was closest to accepting, or both, at the cost of double-calling. Owner call; flagged, not fixed.

## 18 — Code files opened for this map (as required for the PR body)

scripts/rules/ProCall.gd; scripts/rules/ProDebut.gd; scripts/rules/BoutRead.gd; scripts/rules/Recruit.gd; scripts/rules/Loyalty.gd; scripts/rules/DayJob.gd; scripts/rules/StarDeal.gd; scripts/rules/Membership.gd; scripts/rules/WeekPhase.gd; scripts/rules/GameMoney.gd; scripts/rules/BoutRules.gd (fight_power, TICKET_CUT); scripts/rules/NextStep.gd; scripts/state/ProOfferWire.gd; scripts/state/Roster.gd; scripts/state/Needs.gd; scripts/state/SaveGame.gd; scripts/state/Career.gd; scripts/state/Champs.gd; scripts/state/ProLean.gd; scripts/state/ProLadder.gd; scripts/state/Sim.gd; scripts/state/BoutFinish.gd; scripts/state/Bouts.gd; scripts/state/GymSpend.gd; scripts/ui/modals/ProOffer.gd; scripts/ui/modals/WeekReview.gd; scripts/ui/ProWeekLines.gd; scripts/ui/BoutHistory.gd; scripts/ui/MoneyPanels.gd; scripts/ui/RosterActs.gd; scripts/ui/Shell.gd; scripts/ui/HomeNeeds.gd; scripts/ui/areas/FighterPage.gd; scripts/ui/RosterTable.gd; scripts/ui/areas/Fights.gd. Plus the research inputs: docs/TURNGAP1_RESULT.md, ops/research/DESIGN_TURNPRO1_V6.md, ops/research/DESIGN_TURNPRO1_V6_CRITIC_ARENA.md, ops/research/DESIGN_TURNPRO1_V5_CRITIC_DOLA_DOLA.md, ops/research/CRITIC_PACK.md, ops/research/TURNPROBE3_READ_S530.md.

Inputs answered: v6's structure kept where true (houses side by side, asks, two refusals, door ladder, milestone, menu table, probe lines), corrected everywhere the code disagreed; the ARENA critic's CODE-check list fully addressed (§9/§10.1); the DOLA_DOLA critic's To reach 10/10 and Missing/Useless table fully answered (§10.2); TURNGAP1's measured curve drives the only proposed rule change (the gap), still ESTIMATE.

End of map. The next version starts from the code again, not from this page.
