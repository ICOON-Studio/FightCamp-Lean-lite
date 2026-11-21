# TURNPRO1_V13 - score this mechanic's DESIGN (S459 design loop)

You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design map
at the end. Judge the MECHANIC, not the look of any screen.

Score, each out of 10, with the reasons:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
3. PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
The bar (owner S534, raised from 7): the mechanic STAYS in the game only when critics give it 8+ on DEPTH and 8+ on PLAY (fun).

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

# Turning pro - design map v13 (v12 with three changes; code lines re-read at main 0ea035621)

S536, TURNPRO13 side console. Task: `ops/research/TASK_TURNPRO13.md`. Scope: the pro offer, from the call to the debut and the first six pro fights the choice of house shapes. The pro ladder after that is a handoff.
Method (owner S530/S531: maps come from the code): **CODE** = file, function, lines. Sections 1 and 7 carry v12's citations (written at `65423f4a3`). `git diff --stat 65423f4a3 0ea035621 -- scripts/` touches two files this map cites, `rules/Matchmaking.gd` (+3 lines) and `state/ProLadder.gd`; every line number of those two was re-read and moved in this session, and `BoutRules.gd` :114-115, `BoutFinish.gd` :94-106, `DebutPick.gd` :15-17, `DebutRead.gd` :5-6, :17-24 and `ProFights.gd` :161-163 were opened for the new lines. The other citations hold at this commit (their files did not change). **ESTIMATE** = a proposal, a sum worked on paper, or a measured result that is not code. **CUT** = do not build or show it. **CHECK** = not confirmed. No game file was changed.
**PROBED (S536): PASS, 14 of 15 bars, every audit bar - `docs/TURNPROBE13_RESULT.md`** (222 rolls, 2,894 careers). The name stays: the ticket house ends 8.1 to 8.7 reputation ahead by week 40 with room (v12: 2.7 to 3.4), and the tune-up rule is what does it (2.3 with the rule off). The trade is $1,812 to $1,976 of gym cash against 28 debut wins in 100 with room; in a full gym the guarantee house is the one answer. The guarantee card shows 78.1 and plays 78.8. The one miss is the instrument's (cash error $253 against $250 in the full cell). Its limits are in the result's section 2: two options pass the audit bars more easily than three, and the bot does not read the +2 / +5 line. Next: two fresh critics (one code-checked), 8+ on DEPTH and 8+ on PLAY.
Inputs: map v12; `docs/TURNPROBE12_RESULT.md` (v12 FAIL, 10 of 15 bars; its section 2 is this map's brief); Claude's S536 decision (`ops/research/TASK_TURNPRO13.md`: drop the Softer ask, make the name last, the guarantee card at 78, every ask cut but Later +2); owner S534: mechanics need 8+ on DEPTH and 8+ on PLAY, probe first, free hand to remove, add or interconnect.

Words: the **ticket house** = Bow Lane. The **guarantee house** = Harrow & Finch. **Seats** = debut tickets the boxer sells. **Gap** = rating points the debutant sits under the boxer. **The table** = the boxer's professional division table (the pro ladder). **The name** = the gym's reputation. **A tune-up** = a pro fight the promoter offers as one (the kind chip on the row).

## 0. What v13 changes from v12, in six lines
1. **Softer is gone.** Probe 12: it was right in 0 of 4 cells, the guarantee house done worse. With probe 11's four failed asks that is every ask on the contract: none is a decision. The offer keeps one button, Later +2 weeks, a calendar tool.
2. **Turning pro is one decision: which house.** The ticket house = a hard first night in front of the hall, then step ups. The guarantee house = a safe first night, then tune-ups. v12's fork is kept whole (section 3).
3. **The name lasts.** A tune-up win makes +2 reputation, not +5; every other pro win stays +5. The table already pays a soft win one fan less; now the gym's name follows the same rule. The safe road still wins more fights, but it no longer buys the ticket house's name back one tune-up at a time.
4. **The card shows what plays.** The read runs low on a favourite (75.0 shown, 78.6 played); the card adds back a fifth of every point the read stands over 60, and the guarantee house aims that card at 78 (owner: "78 is fine"). The opponent it picks is the one it picks today.
5. **The road is visible fight by fight.** Every offered pro fight says the name a win makes (+2 or +5), so the first six fights are six small readings of the same trade, not one signature.
6. The probe is probe 12 again on the same population and pairing, with a control arm for the new lever (the tune-up rule switched off on the same rolls).

## 1. What the game does today (CODE only)

### The call
- **CODE - `scripts/state/Roster.gd` `check_pro` :200-214:** one offer at a time. With one open, the function only runs the lapse check (:201-205). Otherwise the first boxer in roster order who is `pro_ready`, has waited out a lapse, has no bout booked and is not in a championship run gets the call. It is called from `Sim.gd` :415, `Bouts.gd` :457, `BoutFinish.gd` :219 (and the test jump, `TestJump.gd` :167, :195).
- **CODE - `Roster.pro_ready` :186-196:** a pro, or a boxer with 3 declines, gets none. A national finalist with 0 declines is ready at any record. 0 declines: 7 wins and rank 1-3, or 9 wins. 1 decline: 9 wins and rank 1-3, or 11 wins. 2 declines: rank 1 only.
- **CODE - `scripts/state/ProOfferWire.gd` `make` :25-41; `scripts/rules/ProCall.gd` `calls_open` :331-332, `AGE_STOP` :14:** no first call at 32 or older (a boxer who has declined is not age-checked).
- **CODE - `scripts/rules/ProDebut.gd` `tickets_sold` :27-32; `ProOfferWire.forecast` :20-21; `scripts/state/HomeBout.gd` :13, :69:** seats = 20 + half the members + 2 a win + 10 a title + followers (10 for topping our own club show), capped at 100.
- **CODE - `ProCall.who_calls` :63-69:** 75 seats or more: the ticket house alone. 45 or fewer: the guarantee house alone. 46 to 74: both.
- **CODE - `ProOfferWire.make` :31-33, `on_decline` :181-183:** after a Stay one house calls alone: `offers[0]`, which is the ticket house whenever both called (list order, not a rule).
- **CODE - `ProCall.terms` :73-95:** each decline multiplies purse, step and top by 0.9, unless a title came since.

### The two houses
- **CODE - `ProCall.promoters` :35-59:** ticket house: $1,500 purse, break-even 60, 50% of tickets past it, debut 4 weeks out. Guarantee house: $1,800 guaranteed, break-even 70, 30% past it, debut 6 weeks out.
- **CODE - `ProCall.debut_purse` :99-108, `money` :112-139:** the ticket house loses $25 a seat under 60 (floor $500); past 60 it adds half of each $50 ticket. So its total is $25 a seat across the whole band. The guarantee house pays in full at any count.
- **CODE - `scripts/rules/DebutPick.gd` `AIM` :15, `NOISE` :17, `target` :34-36, `pick` :48-67, `apply` :71-78; called from `ProOfferWire.make` :38:** each house searches the gap (6 over to 14 under, steps of 0.1) until the card's own read sits on its aim for THIS boxer: 60 in 100 for the ticket house, 75 for the guarantee house, each moved up to 4 points by a misjudgement fixed by boxer, house and day. The offer keeps `opp_gap`, `opp_target`, `opp_picked`, `opp_day`.
- **CODE - `scripts/rules/DebutRead.gd` `card` :17-24, header :5-6:** the shown chance reads the debutant the bout will have through `BoutRead.round_edges` on a 4-round card, the boxer as today, on the usual camp (`{"protocol": BoutRead.USUAL_CAMP}`, :22). The function never reads `debut_weeks`; its own header says the weeks to come "are not counted, so the read errs low by a point or two".
- **CODE - `scripts/rules/DebutOpp.gd` consts :15-17, `name_for` :22-24, `rating` :32-33, `make` :37-41:** every debutant is a 0-0 "Boxer-puncher" with "Heavy right hand" and "Fades after round 3", rated the boxer's no-camp strength less the gap. Only the name and the gap differ by house.
- **CODE - `scripts/rules/BoutRead.gd` `_read_copy` :272, `_games` :277-280, `_tiring` :301, `_round_edges` :328, :337:** the read does use the opponent's style (the mix of games, and the plan the coach writes against that style) and three scouting words ("walks in", "Fades", a body threat). So a different style per house would change the bout, with no new system.
- **CODE - `Roster.turn_pro` :305-309, `debut_day` :319-320:** signing books that debutant for the Saturday `debut_weeks` out, 4 rounds; the rating is taken from the boxer's stats on the signing day.
- **CODE - `scripts/state/ProLean.gd` `LEAN_FIGHTS` :7, `LEAN_KIND` :8, `extra` :12-33; `scripts/state/ProLadder.gd` :23-25, :204-214:** for the first 6 pro fights the house ADDS one row to each set of offers: a second tune-up (nearest a read of 0.82, inside 0.70-0.93) for the guarantee house, a second step up (nearest 0.50) for the ticket house. The plain set (one tune-up, one step up, one payday) is still there, so the lean widens the choice; it never forces a fight.

### Signing
- **CODE - `ProDebut.start_costs` :18-24, `Roster.turn_pro` :275-282:** the gym pays at signing: $230 licence, $875 medicals if never licensed, $140 if the coach has no pro licence ($1,245 at most), unless the costs ask was taken.
- **CODE - `Roster.signing_share` :223-224, `turn_pro` :288-291; `scripts/rules/Loyalty.gd` `pro_share` :230-233, `MOVES` :61:** the gym keeps 25% of the boxer's money; under 50 loyalty an outside manager signs the boxer and the gym keeps 10%. Signing then adds 5 loyalty, after the share was read.
- **CODE - `ProCall.morale` :298-308, `ambition_kind` :312-318; `scripts/rules/Recruit.gd` `ambition` :122-126; `ProOfferWire.morale_line` :162-170:** a boxer's goal reads "A regional title within a year" (potential 78 or more) or "A winning record by the summer". Only the title goal moves morale: signing costs 5 while the boxer could still enter the nationals (`Champs.check`, `scripts/state/Champs.gd` :40-41). No goal contains "pro", so the +5 / -5 branch (:300-301) never runs.
- **CODE - `Roster.turn_pro` :301-303, :307; `scripts/state/Bouts.gd` `accept` :192-200:** the stipend ends and open amateur offers are closed. `turn_pro` writes the debut over `f["bout"]` without checking it is empty, and `accept` (lines opened) does not look at the open pro offer.

### The asks (one a house)
- **CODE - `ProCall.ask_answers` :156-194; `ProOfferWire.ask` :76-90, `back_to_plain` :94-98; `scripts/ui/modals/ProOffer.gd` `_ask` :174-195:** six buttons a house, each tagged "will take it", "counters" or "won't" (a won't button is disabled and not spent).

| Ask | Ticket house | Guarantee house | What the code does (CODE) |
|---|---|---|---|
| Later +2 / +4 weeks | takes | takes | `_apply_later` :197-201: $150 / $300 off the purse, 2 / 4 more weeks. The card's win chance cannot move (the read ignores weeks) |
| Softer opponent | takes | takes | `_apply_softer` :204-208: gap +0.5, free, and the next 2 sets of pro offers are tune-ups only (`ProLean.extra` :14-17; `ProLadder.book` :342-343 spends a set on any booking) |
| Better split | won't under 65 seats, counters +5 share points at 65-79, takes +10 (gap -0.5) at 80+ | won't under 75 (it calls at 74 or less) | `_split_entry` :211-239 |
| Own ticket price | takes: $40 tickets, 15 more seats, free | won't | `_price_entry` :242-260; `ProOfferWire.money` :125 |
| Costs from the purse | won't | counters: the promoter pays the signing costs and takes them plus $100 ($200 under 8 weeks of runway) off the purse before the split | `_costs_entry` :263-283; `ProOfferWire.money` :122-124, `night` :135-136; `scripts/rules/GymBills.gd` `runway_weeks` :62-67. `maxi(0, ...)` is the only floor: the boxer's pay can reach $0 |

### The offer screen
- **CODE - `ProOffer.build` :35-45:** header "A CALL FROM (house names)", "TURN (first name) PRO?", then one line: record and rank, days the offer stands, the age line, declines left.
- **CODE - `ProOffer._tickets` :90-106, `ticket_parts` :211-225:** one ticket bar, who buys, one break-even mark at 60 (`bar.break_even = ProDebut.BREAK_EVEN` :97; the guarantee house's 70 is not drawn).
- **CODE - `ProOffer._house` :110-170:** per house: badge and name, and "VS (debutant's name)" in the card head (:139-143, now committed); Debut purse; Ticket share and seats today; "Debut, N weeks out: Picked as a winnable first night / Picked to test your boxer" with a hover (`DebutPick.line` :88-91, `tip` :96-100); "Win chance: about N%, a draw N%" (:154); "After the debut: +$ a win, up to $" (:155); "The gym at signing", "The gym each week after" (the stipend minus an assumed $75, `ProCall.LOST_CUT_A_WEEK` :13), "The boxer from the debut" (:161-163); the pays-back sentence (:165); the asks; "Turn pro with (house name)" (:167).
- **CODE - `ProOffer.build` :56-69:** what the gym pays at signing, itemised; WHAT ENDS; the 10% line under 50 loyalty.
- **CODE - `ProOffer.build` :72-81:** the MORALE line when morale moves; "Stay amateur", whose tooltip always says "the same house calls again after 2 more wins, on 0.9x terms" (:80). After one Stay the real gate is 9 wins and top 3, or 11 wins; after two, rank 1 (`pro_ready`).

### Holding, staying, lapsing
- **CODE - `scripts/state/Needs.gd` `needs` :67-70, `blockers` :140-141, `flags` :167-168; `scripts/ui/Main.gd` `on_go` :195-199; `scripts/state/Clock.gd` `stop_now` :79-83:** the open offer is a red need and a red top-bar flag. Red needs are blockers: Continue opens the offer and the clock stops.
- **CODE - `ProOfferWire.lapse_if_due` :187-197, `ProCall.expires` :336-337:** the 14-day lapse runs only inside `check_pro`, which needs a week to end or a bout to finish. With time blocked, the lapse and the "14 more days" on the card cannot be reached by playing.
- **CODE - `Roster.decline_pro` :324-334; `Loyalty.MOVES` :61:** Stay adds a decline, saves the returning house, applies morale by the goal (0 for every goal that exists) and costs 8 loyalty.
- **CODE - `scripts/state/LoyaltyWire.gd` `idle_week` :44-53, `IDLE_WEEKS` :19:** a fit amateur with nothing booked loses 3 loyalty every 4 Mondays; it does not pause for an open offer.
- **CODE - `scripts/rules/FighterProfile.gd` :25:** "month_no_fight: -6" is a table entry; this session did not find a caller (v10 searched `scripts/` and found none).

### The night and what it leaves (the part v10 priced only in members)
- **CODE - `scripts/state/BoutFinish.gd` :92, :111-116; `Roster.debut_night` :247-251; `ProOfferWire.night` :133-142:** the debut pays on the seats counted ON THE NIGHT. The ledger label prints 25% even when the cut was 10% (:114-115).
- **CODE - `BoutFinish.gd` :94-106; `scripts/rules/BoutRules.gd` :114-123:** a win brings 8 members and 5 reputation. A loss costs 1 member and 2 reputation; a stopped loss 2 and 4. The same for both houses.
- **CODE - `BoutFinish.gd` :176; `FighterProfile.MORALE_EVENTS` :18-20, `apply_morale` :147-170:** morale +8 on a win (x0.9 to 1.1 by confidence), -12 on a loss (x1.3 to 0.7 by heart).
- **CODE - `BoutFinish.gd` :177-178; `Loyalty.MOVES` :60:** loyalty +2 on a win, -1 on a loss, -3 when stopped.
- **CODE - `BoutFinish.gd` :101-102; `scripts/rules/Attrs.gd` `wear_stoppage` :127-129, `STOP_DROP` :42:** a stoppage loss (not a corner retirement) lowers the boxer's durability ceiling by 2 for good.
- **CODE - `scripts/rules/Membership.gd` :15-16, :19, :29, `step_members` :45-53:** the gym can carry 48 members + 0.6 a reputation point (before the dues band); the count walks a quarter of the gap a week, 6 at most. So reputation is members later, and seats can grow between signing and the night.
- **CODE - `ProLadder.result` :372-378:** the debut has no ladder opponent, so the function joins the boxer to the table and returns; the debut's result is not applied to a rank there.
- **CODE - `BoutFinish.gd` :117-122; `scripts/rules/Matchmaking.gd` `PURSE_UNRANKED` :50, `pay_of` :216-218:** later pro fights pay from the ladder ($1,500 unranked). `f["purse"]` steps up after a win (:122) but the booked purse comes from `pay_of` (`ProLadder.book` :355, :361). The contract's step and top, shown on the card (:155) and promised in the week review (`scripts/ui/ProWeekLines.gd` `next_line` :46-50), are never paid.
- **CODE - `ProWeekLines.lines_for` :15-42:** for 28 days after signing the review shows "amateur cut lost / stipend saved" with the assumed $75 a week; in the debut's week a ledger line (share, costs, net).
- **CODE - `scripts/state/GymDeals.gd` `pro_camp` :22-35:** the debut has no camp bill; a cutman on staff is still charged.

### The table after the debut (new in v12; lines re-read for v13)
- **CODE - `scripts/state/BoutFinish.gd` `run` :94-106, :110:** the debut's result is booked as any bout's: `pro_w` / `pro_l`, +8 members and +5 reputation on a win, -1 member and -2 reputation on a loss (-2 and -4 when stopped), then `ProLadder.result`.
- **CODE - `scripts/state/ProLadder.gd` `result` :372-378, `join` :93-107; `scripts/rules/Matchmaking.gd` `join` :68-82:** the debut has no table opponent (`opp_id == 0`, :377), so the function joins the boxer to the table and returns. The boxer arrives unranked, 0 fans, no rebuild flag, with the debut's record copied (:102-104). **A debut loss leaves no mark on the table; a debut win earns nothing there.**
- **CODE - `Matchmaking.apply_result` :230-270 (fans :242), `loss_fans` :290-291:** every LATER pro fight moves fans (+1 a win, +1 more for a step up, +1 for a stoppage, -1 for a mismatch 6 points under; a loss costs 0 to 2 by how the fight looked), sets `rebuild` on a loss (:252) and clears it on a win (:245).
- **CODE - `ProLadder._make_offers` :175-216 (:209), `Matchmaking.ask` :180-192 (:188-189):** while `rebuild` is set the promoter offers no step up and refuses an ask above the boxer's place.
- **CODE - `ProLadder._review_streak` :407-420, `REVIEW_WINS` :37:** an unranked boxer with 5 wins and a winning record is given the table's last ranked seat.
- **CODE - `Matchmaking.pay_of` :216-225, constants :50-53:** an unranked boxer's purse is $1,500; a ranked one's is $1,500 + $400 for every place above the bottom of a 20-place table; a ranked name above adds $150 a place; tickets are $150 x (fans + 5) x closeness. The gym keeps a quarter (`GYM_SHARE` :56).
- **CODE - `ProLadder.book` :337-368 (:360-361), `LEAD_DAYS` :32; `Matchmaking.next_weeks` :283-285:** a booked pro fight is six weeks out; the next night is 6 weeks after a mismatch, 8 after a level fight, 12 after a step up, 8 more after a stopped loss.
- **CODE - `scripts/state/ProLean.gd` `extra` :12-33, `LEAN_FIGHTS` :7, `LEAN_KIND` :8:** for the first 6 pro fights the house ADDS a row (a second tune-up or a second step up); the plain set stays, so today the lean never removes a fight from the table.

### The name and the room (new in v12; lines re-read for v13)
- **CODE - `scripts/rules/BoutRules.gd` `WIN_MEMBERS` :114, `WIN_REPUTATION` :115; `scripts/state/BoutFinish.gd` :96, :98:** every win pays 8 members and 5 reputation, whoever was beaten (only a short-notice win doubles the 5). The table already tells a soft win from a real one for FANS (`Matchmaking.apply_result` :242: a mismatch 6 points under, `SOFT_GAP` :43, costs the win one fan) and for growth (:236), but the gym's name does not. So a road of tune-ups buys the same name as a road of step ups, one win at a time.
- **CODE - `scripts/ui/ProFights.gd` :161-163; `ProLadder._make_offers` :175-216:** every offered pro fight already carries its kind (tune-up, step up, payday) and shows it as a chip on its row.
- **CODE - `scripts/rules/Membership.gd` `natural_members` :38-40, `BASE_MEMBERS` :15, `MEMBERS_PER_REPUTATION_POINT` :16, `step_members` :45-53, `settle_week` :90-102, `weekly_dues` :83-84:** the gym's name carries 48 members + 0.6 a reputation point; the count walks a quarter of the gap a week (6 at most) toward that, never past the gym's cap; each member pays $35 a month. One reputation point with room is about $4.85 a week.
- **CODE - `scripts/state/GymSpend.gd` `member_cap` :160-161; `scripts/rules/GymUpgrades.gd` :27-29:** the cap is the smallest of the premises' room (70 in the first unit, 140 and 250 after a move), what the coaches can carry and the places on the floor. Past it reputation brings nobody in.
- **CODE - `GymUpgrades.LOAN` :127, `GymSpend.move` :242-248:** the move to the bigger unit can be taken on a fit-out loan ($3,000 down, $750 a month for 12). The game's answer to a cash hole is here, not in a boxer's purse.
- **CODE - reputation is read elsewhere too:** `scripts/rules/ClubShow.gd` `draw` :26-27 (tickets for our own show), `scripts/rules/Grants.gd` `chance` :28-29, `scripts/rules/CardAsk.gd` `chance` :74-75. A name with no room still does those three things.

### Today's fork, as measured (ESTIMATE: `docs/TURNPROBE11_RESULT.md`, 1,498 careers, 8,400 scratch bouts; `docs/TURNPROBE12_RESULT.md`, 2,388 careers)
- On today's rules the guarantee house is best on money in 6 of 6 cells and its costs ask is the best option every time: +$909 in a healthy gym (error $0), +$1,128 in a crunch. That is one answer.
- The ticket house's gym cut on the night is $2 to $77 away from the guarantee house's; own ticket price adds $13 at most; $1,400 against $1,800 of guarantee purse is $104. One career's cash swings about $1,700 on the fights that follow.
- Members, morale and loyalty are within 2 members, a few morale points and 2 loyalty of each other by week 40, whatever is signed.
- What is real: the debut (56 wins in 100 at the ticket house, 76 at the guarantee house; 25 losses against 10), the softer opponent (+4.7 wins in 100) and the house's lean (it changes the bot's pick in 44% of offer sets at the ticket house, 20% at the guarantee house).
- Probe 12, on v12's rules: the ticket house ends $1,518 to $1,656 of gym cash ahead with room for 23 debut wins in 100, and only $619 ahead in a full gym. Softer was right in 0 of 4 cells. The ticket house's name was 8 to 9 reputation on the night and 2.7 to 3.4 by week 40. The guarantee card read 75.0 and played 78.6; the ticket card read 60.4 and played 59.9.

## 2. The human question (the brief)
A coach picks a promoter on who they will put in front of his boxer, not on a few hundred dollars: a builder who gives soft tune-ups, or a promoter who throws him in and gets him noticed. The money is the boxer's; the club's gain is the name.

## 3. The fork (ESTIMATE; the probe of section 9 sizes every number)
| | The ticket house | The guarantee house |
|---|---|---|
| The first night | aimed at 60 wins in 100 (CODE `DebutPick.AIM` :15), a crowd-pleaser ("Pressure fighter"), 4 weeks out | a cautious "Out-boxer", 6 weeks out. **The card is aimed at 78** (section 5); the opponent is the one today's aim of 75 picks (owner: "78 is fine") |
| A debut win | the usual +8 members and +5 reputation, **plus 1 reputation for every 4 seats sold on the night (20 at most)**: +14 at 56 seats, +18 at 72. **The boxer takes the table's last seat** (ranked: a $1,900 purse, and may ask five places up: CODE `Matchmaking.pay_of` :218, `BAND_UP` :35). Fans as any pro win | +8 members, +5 reputation. Unranked. Fans as any pro win |
| A debut loss | reputation -2 (-4 stopped) as today; **a rebuild fight before any step up**; fans by how it looked (an even fight lost: 1) | the same rule; the favourite who loses costs 2 fans (CODE `Matchmaking.loss_fans` :290-291) |
| The first six fights | **step ups** (read nearest 50 in 100) and the payday; no tune-up unless rebuilding. **A win: +5 reputation** | **tune-ups** (read nearest 82 in 100); a step up only after 3 pro wins; no payday. **A tune-up win: +2 reputation** (NEW in v13); a step-up win +5 |
| The money | the purse as today. Shown small, said honestly, not a lever | the same |
| Right when | the gym has room for the members a name brings, and the hall is big enough to make one | the gym is full or the hall is small (the name would be wasted), or the boxer's record or chin cannot take a 1-in-4 loss |

**The tune-up rule (NEW).** A pro win in a fight the promoter offered as a tune-up pays +2 reputation in place of `BoutRules.WIN_REPUTATION` (5, CODE :115; paid at `BoutFinish.gd` :98). The members (+8), the purse and the fans are untouched. It applies to every tune-up, on either road and after the sixth fight too: the rule is about the fight, not the house. The ticket house's rebuild fight after a loss is a tune-up and pays +2 as well.

Why this is a choice and v12 was only half of one. Probe 12 measured the trade (cash against debut wins) and found it real with room and gone in a full gym. But the thing the ticket house sells, the name, was 8 to 9 reputation on the night and 3 by week 40: the guarantee house's road wins 0.85 more fights, each at +5. Under the tune-up rule two thirds of that road pays +2, so what the hard road wins on the first night it keeps. One reputation point with room is about $4.85 a week (section 1), so the lasting lead is also what pays the ticket house's cash by week 40. In a full gym it still pays nothing until the player makes room: **the fork interconnects with the premises** (free hand, owner S534), and that is where it flips.

What a debut loss costs at week 40 (probe 12: $2,287 behind the same option's winners, today $972): the rebuild fight is a tune-up purse instead of a step up and one whole fight later on the table; at the ticket house it also forfeits the name and the seat.

## 4. The asks (ESTIMATE)
| House | Ask | Today (CODE) | v13 | Right when / wrong when |
|---|---|---|---|---|
| Both | **Later +2 weeks** | $150 off (`ProCall._apply_later` :197-201) | unchanged; the card shows about +2 in 100 (section 5). **A calendar tool, not a fork lever:** it is for an injury, the weight or a boxer new to the gym. It is measured on the night only and is outside the audit's bars | Right when the boxer is not ready. Otherwise skip it |
| - | Softer opponent | gap +0.5, free, 2 tune-up sets (`_apply_softer` :204-208) | **CUT** (probe 12: right in 0 of 4 cells; the promoter already picks the debutant to suit the boxer, DEBUTPICK1) | |
| - | Own ticket price | `_price_entry` :242-260 | **CUT.** A purse lever: $13 at most for the gym (probe 11) | |
| - | Costs from the purse | `_costs_entry` :263-283 | **CUT.** Today it is the one answer (+$909) | |
| - | Later +4, Better split | free or dominated | **CUT** (v10, v11) | |
Two probes say the same thing: nothing bolted onto the contract is a decision. No further ask is to be designed for this screen.

## 5. The read, the seats, the hold (ESTIMATE)
- **The card shows what plays** (probe 12 bar 4). `DebutRead.card` (CODE :17-24; its header :5-6 says the read "errs low by a point or two") gains two terms: +1 point for every week of `debut_weeks` over 4 (v12), and **+0.2 of every point the read stands over 60** (NEW: probe 12 stage A read 75.0 for 78.6 played and 60.4 for 59.9, so the shortfall grows with the favourite, not with the weeks). `DebutPick` searches on that card, and **the guarantee house's aim moves from 75 to 78 on it** (`DebutPick.AIM` :15), which lands on the debutant today's aim picks. The ticket house reads as today. Later +2 shows about +2.
- **Seats on the night** (v11, kept): one dashed number on the ticket bar, today's seats plus half the members the gym gains by the debut. It matters for one thing only: the name a ticket-house win is worth (seats / 4). The hover says so.
- **The room line** (new): when the forecast members by the debut are within 6 of the cap, both cards say "Your gym is nearly full: the name brings nobody in until there is room (Club, Money)".
- **The hold** (v10 and v11, kept whole): amber need and flag, so Continue runs; the lapse checked every day; one stop on the last day; no bout bookable for this boxer while the offer is open; the idle-loyalty count pauses.
- **Stay amateur** says the real next gate, terms x0.9 unless a title comes, loyalty -8, declines left. The returning house: the ticket house at 56 seats or more, the guarantee house below (v11).
- **The money, said honestly** (v10, kept): Cash today, The gym on the night, The boxer on the night, in small type under the road. CUT the step and top promise, the assumed $75 a week and the pays-back sentence.
- **The name a fight makes** (NEW): each row of NEXT FIGHT says "+2 reputation" (tune-up) or "+5" beside its kind chip, and the result page and week review repeat it after the fight.
- **The guarantee purse stays $1,800** (probe 11 item 8: $104 either way; it decides nothing, so nothing is changed and no test moves).

## 6. Probe 12's section 2, item by item
| # | Probe 12 | v13 | Where |
|---|---|---|---|
| 1 | CUT every ask on the offer except Later +2 | **Taken whole.** Softer is cut; the asks row is one button | Sections 0, 4 |
| 2 | KEEP one decision: which house | **Taken.** v12's fork unchanged | Section 3 |
| 3 | "Turning pro is one good decision, not a deep screen. The depth an 8 needs is in the six fights of the road and in the gym's room" | **Taken.** The tune-up rule puts the trade on every one of the six fights, where the player already picks a row; nothing is added to the offer screen | Sections 3, 5, 7 |
| 4 | (a) drop Softer | Done | Section 4 |
| 5 | (b) make the name last: a soft win makes less name than a hard one, as it already makes fewer fans | **The tune-up rule:** +2 reputation, not +5 | Section 3 |
| 6 | (c) aim the guarantee house's card at what plays, 78 | **The card adds the favourite's shortfall; the aim is 78 on it** | Section 5 |
| 7 | Run the probe again on 180 or more rolls | **Run in this task** with 36 call days asked a boxer (30 in probe 12) | Section 9 |
Kept from v12 without change: each house's own debutant, the name by seats and the table's last seat for a ticket-house debut win, the debut counted on the table (fans, the rebuild flag), the firm road, the room line, the hold, Stay's true hover, the returning house, the honest ledger, names only in headers.

## 7. Where it appears: CODE TODAY against TO BUILD (every menu the mechanic shows on, and what each is wired to)
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar flag | `Needs.flags` :167-168 | red PRO OFFER, act "prooffer" | amber; days left |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` :140-141 | runs while the offer is held; one stop on the last day |
| Home, needs | `Needs.needs` :67-70, `_pro_line` :199-206 (house names in the body) | act "prooffer", "Hear it" | amber; roles, not names |
| Office desk | `scripts/ui/OfficeDesk.gd` :39 | the contract icon for "prooffer" | none |
| Offer header | `ProOffer.build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | "Another boxer's call waits behind this one." |
| Offer ticket bar | `ProOffer._tickets` :90-106 | `ticket_parts` :211-225, one mark at 60 | both marks; seats on the night (dashed) and its hover: "The ticket house's win is worth 1 reputation for every 4 seats sold" |
| Offer house card | `ProOffer._house` :110-170 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | head THE TICKET HOUSE / THE GUARANTEE HOUSE and a role line ("a hard first night in front of the hall, then step ups" / "a safe first night, then tune-ups"); the debutant's style; win chance (what plays: the favourite's shortfall and the weeks past four counted; the guarantee house about 78); "A win: +N reputation and the table's last seat" / "A win: +5 reputation"; "A loss: a rebuild fight first, N fans"; "Your first six fights: step ups, +5 reputation a win" / "tune-ups, +2 reputation a win; a step up after 3 wins"; the room line when the gym is full ("Your gym is full: the name brings nobody in until there is room"); three money numbers in small type. CUT step/top, weekly-after, pays-back, "+N loyalty", "A win brings N members" |
| Offer asks | `ProOffer._ask` :174-195 | `ProOfferWire.answers/ask/back_to_plain`; acts "proask", "proplain" (`scripts/ui/RosterActs.gd` :96-104) | one ask, on both houses: Later +2 weeks, with what it changes on the card. CUT Softer, own ticket price, costs from the purse, better split, later +4. The six-button row becomes one button |
| Offer foot | `ProOffer.build` :56-81 | `ProOfferWire.morale_line`; acts "turnpro" :90-95, "declinepro" :105-108 | the table pick of the weight (WEIGHT2's hook, section 8); Stay's true hover; Review later; "Sign this offer". CUT the wish |
| Fighter, Next Step | `scripts/ui/areas/FighterPage.gd` :338, :344, :355-357; `scripts/rules/NextStep.gd` `road` :50, `pro_line` :73-88 | tickets against each house, age, declines left | "Offer open, N days"; roles, not names |
| Fighter, contract | `FighterPage.gd` :144 | fixed text "Club stipend, $250 a week / Until turning pro" | the pro share and house for a pro |
| Money, stipends | `scripts/ui/MoneyPanels.gd` :264, `_stipend_card` :360-367 | "signing ends it anyway" when the offer is this boxer's | none |
| World compare | `scripts/ui/WorldCompare.gd` :269 | the "offer waiting" mark | none |
| Fights (pro) | `scripts/ui/ProFights.gd` :117; `ProLean.line` :41-47 (house name in the body) | the lean's line under NEXT FIGHT | roles, not names; "Your house's road: step ups (N of 6 left)" / "tune-ups; a step up after 3 wins"; the rebuild line after a debut loss; no tune-up rider line. **Each row says the name a win makes: "+2 reputation" on a tune-up, "+5" on any other fight** (beside the kind chip, :161-163) |
| Week review | `ProWeekLines.lines_for` :15-42, `rows` :62-75 | `f["pro_signed"]` (`Roster.turn_pro` :294-295, `BoutFinish.gd` :123-124) | "seats now N (N at the call)"; the ledger with the true share, the reputation won and the table seat; after every pro fight the reputation line names the kind ("Tune-up win: +2 reputation"); CUT the NEXT promise and the $75 line |
| History | `scripts/ui/BoutHistory.gd` :45, :68 | "TURNED PRO WITH (house), (date)" header | none |
| Debut result | `BoutFinish.gd` :94-116; `Roster.debut_words` :254-261 | members, reputation, the pay label and news line | the name by seats and the table's last seat (ticket house win); fans from the debut; "a rebuild fight first" after a loss; the true share |
| Pro fight result (every later pro fight) | `BoutFinish.gd` :94-98, :170 (the win's news line) | +8 members, +5 reputation on any win | the rank earned (S428) and the name made: +2 reputation after a tune-up, +5 after any other win; the news line says which |
| Game plan / camp for the debut | `BoutRead._read_copy` :272 (the coach's plan against the opponent's style) | one style today | reads the house's debutant; no screen change |
| Toasts | `RosterActs.gd` :95, :108 | "(first name) is a pro. Debut on (date)." | "Your boxer is a pro. Debut on (date)." |
| World, the pro table | `scripts/state/ProLadder.gd` `road` :423-438 | rank, fans, "Coming off a loss: win a rebuild fight first" | the debut's result shows there: the last seat after a ticket-house win, the rebuild line after a loss |
| Money, members | `scripts/ui/areas/Money.gd` :123-124 | members / cap (`GymSpend.member_cap` :160-161) | none: it already shows the room the name needs |
| Test jump | `scripts/ui/TestJump.gd` :195-197 | opens the offer on the test club | keep working |
Not reopened this session and not claimed: the top bar's drawing code (`Shell.gd`), the home list's ordering (`HomeNeeds.gd`), the week review modal's call site, the roster table, the world news feed.

## 8. The weight class at turning pro (a hook only)
The weight a boxer turns pro at is OWNED by the WEIGHT2 design (`ops/research/TASK_WEIGHTMOVE1.md`, running now). v13 designs nothing of it and names one hook: **the table pick appears on this call**, in the offer's foot above "Sign this offer". Today the table follows the amateur class's limit with no choice (CODE `ProLadder.division_for` :43-49). Whatever WEIGHT2 decides plugs in there; the probe below runs every boxer on the table the code gives today.

## 9. The probe (run in this task: `tools/turnprobe13.gd`, rules copy `tools/turnprobe13_rules.gd`, tables `tools/turnprobe13_sum.py`, result `docs/TURNPROBE13_RESULT.md`)
- **Population and pairing: probe 12's.** The six people the game can sign, each played from signing to the first pro call, then called on 37 different weeks: 222 rolls (a boxer's call week is one roll: a bout's dice are the fight day's). Printed in the result.
- **Cells.** The gym on the day of the call: seats 48, 56 and 64 with room for more members, and a full gym (members at the cap, a name that draws 10 more). $12,000 in the bank.
- **Arms.** V13 = sections 3 to 5 (the ticket house, the guarantee house; no ask). TODAY = the game's own functions, in two cells. The MUTANT is today's costs ask (+$909): the instrument must read it. **FLAT** (new) = v13 with the tune-up rule off, in the same two cells on the same rolls: the new lever's control arm.
- **The bot** takes the offered pro fight read nearest 65 in 100 from what the house's road puts on the table, to week 40. It does not run the gym and does not read the +2 / +5 line: it measures the rule's size, not the player's use of it.
- **The pass rule** (probe 11 item 3). Every option is read against the plain guarantee house on the same roll. A beats B in a cell when A is ahead by the line on one axis ($1,000 of gym cash by week 40, or 3 debut wins in 100) and not behind by the line on the other. RIGHT = beaten by nobody. THE ONE ANSWER = beats every other option.

| # | Bar (bounds, never an exact count). The bars of probe 12; bar 10 was Softer's and is now the new lever's |
|---|---|
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell |
| 3 | Played debut wins: ticket house 52 to 68 in 100, guarantee house 70 to 82 (the night, 200 scratch nights a row) |
| 4 | The card is honest: shown within 3 of played, each house |
| 5 | The fork is a trade somewhere: the ticket house is $1,000+ ahead on cash and 3+ debut wins behind in at least one cell |
| 6 | The fork flips: the guarantee house beats the ticket house in at least one cell |
| 7 | AUDIT: no option is the one answer in more than 6 cells of 10 |
| 8 | AUDIT: every option is right in at least one cell |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 wins in 100 |
| 10 | The lever is real: with the tune-up rule off, on the same rolls, the ticket house's reputation lead is 1+ smaller in every cell with room it is played in |
| 11 | Boxer by boxer (boxer x gym cells): no option the one answer in more than 6 cells of 10, every option right in at least 2 |
| 12 | A debut loss leaves a mark at week 40: $1,000+ of cash or 20+ points of ranked share behind the same option's wins |
| 13 | The roads differ: step ups are 25+ points more of the ticket house's bookings than of the guarantee house's |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 |
| 15 | The name stays: the ticket house ends 4+ reputation ahead of the guarantee house in every cell with room |
**PASS = 12 or more of the 15, with bars 7, 8 and 9 all passing** (probe 12's rule, unchanged). Then two fresh critics (one code-checked), 8+ on DEPTH and 8+ on PLAY (owner S534), before the owner's board.
- **If it fails:** the result says which lever broke and it goes back to Claude. A third fail in a row is a cut-or-keep question for the owner (`TASK_TURNPRO13.md`).
- **State tests for the build:** last day and reload; a double press on Sign; an amateur offer open at the call; Stay at 1 and 2 declines; the 10% share on the ledger; an old save's offer with no `opp_picked`; an old save's offer with the Softer ask already taken (it keeps today's terms); a debut loss then the first offer set (no step up); a ticket-house win when the table has no ranked boxer left to unseat; a tune-up win pays 2 and a short-notice tune-up win pays 4.
- **Golden path:** call, hold three days, Later +2 on and off, sign, the seats line on Monday, debut, the name and the seat on the result page, the first offer set on the house's road with its +2 / +5 line, one tune-up win and its line in the week review.

## 10. Owner rulings kept
- The debut opponent is picked to each boxer (Q-286): `DebutPick` stays the one search.
- The guarantee house about 75 in 100, "78 is fine": the debutant it picks does not change; its card now says 78, which is what plays.
- Names only in headers (S448). Only actionable information (C443): no gap, no aim, no assumed weekly figure; the room line shows only when the gym is nearly full.
- Tooltips explain (S532): the "+2 reputation" hover on a tune-up says why ("an easy win is not news") and what the name is for (members, when the gym has room).
- Every fight shows the rank earned (S428): the name made sits beside it on the result page.
- Amateur bouts need no camp (S428): untouched. The normal game starts with no boxer signed (S487): untouched.
- Board text short. The one line for his board, after the probe and two critics at 8+: "Turning pro: room and a big hall - the hard road. Full gym or a fragile record - the safe one. OK to build?"

## 11. Build order (ESTIMATE; nothing here is built)
1. The hold (v10): amber, daily lapse, the booking guard, the loyalty pause. Red test first: Continue with an open offer must advance the day.
2. The card shows what plays (the weeks past four, the favourite's shortfall, the guarantee aim at 78); the two debutants. Re-run DEBUTPICK1's 22 cells.
3. The debut counts on the table: fans, the rebuild flag (`ProLadder.result` :376 no longer returns early for the debut).
4. The ticket house's win: the name by seats, the table's last seat.
5. The firm road: `ProLean` removes rows as well as adding them.
6. The asks: CUT Softer, own price, costs, split, later +4; one button (Later +2).
6b. The tune-up rule: +2 reputation on a tune-up win (`BoutFinish.gd` :98 reads the booked kind, which `ProLadder.book` :337-368 must keep on the bout); the +2 / +5 line on the Fights rows, the result page and the week review.
7. The card and the other menus of section 7; the result page and week-review lines.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd`, `tests/pro_offer_wire_test.gd`, `tests/debut_pick_test.gd`, `tests/debut_read_test.gd`, `tests/pro_ladder_test.gd` (the debut on the table, the road), and any test that reads +5 reputation after a tune-up win.

## 12. Cut list
- **CUT in v13 -** the Softer ask on either house (and its tune-up rider, already cut); Softer's hover; bar 10 as a Softer bar. No new ask is to be designed for the offer.
- **CUT from v11 -** the $1,400 guarantee purse; the win crowd by seats in members; the forgiven loss; loyalty from the boxer's pay; the wish; the $270 ticket ask; the gated and floored costs ask; the crunch cell; "worth it under 66 seats".
- **CUT, kept from v10 and v11 -** Later +4. Better split. The tune-up rider. "Won't" buttons. The step and top promise. The assumed $75 a week and the pays-back sentence. A dollar rate for morale or loyalty. The new fees and the manager's licence until the source is opened. The hard-camp line on the offer. A stipend switch on the hold. v9's loan, queue and versioned contract pay. A win-chance range. Raising the aims.
