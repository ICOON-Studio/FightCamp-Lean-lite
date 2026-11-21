# WEIGHT2_V2 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN WEIGHT2 v2 - weight as one mechanic: the owner's answers, John's numbers, probe round 3

Kind: design map + a greybox measurement. No game code changed (nothing under `scripts/`). Written by a Fable console in the
checkout (S535, task `ops/research/TASK_WEIGHT2R3.md`). Code read at commit 31d42481e on 2026-11-21; `LineGrade.gd`, `LiveRound.gd`,
`StepWire.gd`, `MHRig.gd` and `Player2.gd` carry other sessions' uncommitted edits and are not cited by line.
Replaces `DESIGN_WEIGHT2.md` (v1, which keeps the full tables of probe rounds 1 and 2).

The owner, S535, verbatim: "The boxer should be able to change weight classes", then "Go deep with weight mechanic for 10/10 it
should be manageable to a certain point and affect various things about fighters performance,scaling etc". His three answers
since v1: Q-292 "Add men's 65 kg"; Q-293 "Yes, he can refuse"; Q-294 "Yes, after the probe" (the 3D body shows his weight).
Bar (owner S534): 8 depth and 8 play from two fresh critics, AFTER the probe.

Words used. CODE = I opened the file for this map and the line is true at the commit above. John's tags are kept as he wrote
them (`JOHN_WEIGHT2_RESEARCH_JOHN.md`, SQ278): SOURCED = he opened the source; DERIVED = his arithmetic on sourced numbers;
ESTIMATE = a judgement (his where a source question is named, mine otherwise); CHECK = cited, not opened; NOT FOUND. I checked
every number below against his line; I did not open the papers. NEW = no code path exists. DESIGN = a game number nobody can
source (a mood price), run in the probe.

What changed from v1: section 2 (ten estimates answered), 3.2 and 3.3 (the drain is a stamina story; safe lines by scale), 3.4
(size fitted to a counted number; the 3D body read), 3.5 (men's 65 kg; the refusal), 3.6 (a miss by bout type), 3.7 (growth by
age and sex), section 4.5 (round 3), and five CODE lines of v1 that were wrong or loose (marked "v1 corrected").

## 0. The mechanic in eight lines

1. Every boxer has a NATURAL weight (where the body settles; it grows while he is young) and a WALKING weight (today's scale).
2. The player holds the walking weight under the natural one with a DIET (three settings). Holding costs training gain.
3. The last kilos come off as WATER in fight week (three settings). The first 2 % is free; past it water costs his engine.
4. How much is back by the bell depends on the scale: an hour before (club show), three hours (championship), the day before (pro).
5. What he weighs IN THE RING against the other boxer is a size edge: about 3 wins in 100 for each 1 % of body weight.
6. The class is a choice between bouts: stay, walk bigger and cut harder, move up, move down. A move costs one rung. He may say no.
7. His body has a limit (how much water he can make) that the player reads with error, and that shrinks with age.
8. Bound: three decisions, never more than one screen: a diet per boxer (Monday), water (fight week), class (between bouts).

"Manageable to a certain point" is lines 1, 2, 6 and 7: the player steers the walking weight, never the natural one, the limit
or the boxer's own mind about his class.

## 1. What the game does today (CODE)

### 1.1 The path of a kilo, end to end

| Step | Code | What it does |
| :--- | :--- | :--- |
| A boxer's two numbers | `Data.gd:60` (Lucy 60.9 for 60.0), `:222-242` (Kira 58.3 / 57, Samira 65.9 / 65, Tess 76.1 / 75, Danny 61.1 / 60, Josh 71.4 / 70) | `weight` and `limit`. Everyone walks 0.9 to 1.4 kg over (1.5 to 2.3 %). No natural weight, no frame. |
| The limit | `Data.fighter_state`, `Data.gd:261` | Copied from `Data.DIVISIONS[div]["limit"]` at signing. Written again only by a save migration (`SaveGame.gd:82-86`) and the first hour (`FirstHour.gd:125`). **No boxer ever changes class.** (v1 corrected: `ClubStart.gd:78` writes a start scenario's `weight`, not the limit.) |
| The classes | `Data.DIVISIONS`, `Data.gd:136-153` | Women 57, 60, 65, 70, 75. Men 55, 60, 70, 75 on main. Men's 65 (`mlm`, "Light welterweight", six region boxers) is on branch `s535/dmgfix` (`Data.gd:151`, `:205-210` there), not merged at this commit. |
| The diet switch | `WeekBoard.gd:353-357` (Hold / Cut pills), `WeekCamp.gd:270`, `BoutActs.gd:48-51` (the `diet` act) | The player CAN set Hold or Cut (v1 corrected: it said "the player sets nothing"). |
| When the cut bites | `Sim.week_ctx`, `Sim.gd:121-126` (the rule is `:123`) | Only while he is within 0.15 kg of the limit or over it AND (`diet` is cut, or a camp is on, or an amateur bout is booked). A camp or a booked bout switches it on by itself; Cut never takes him under the limit. So the pill decides little. |
| What a day moves | `WeekPlan.day`, `WeekPlan.gd:265-290` | kcal = MET x body kg x hours x intensity; kg = -(kcal - 300 allowance + deficit) / 7,700 (`:287-288`). CUT deficit 500 kcal (`:75`), the Old hand head coach 120 more (`HeadCoach.gd:30`). About 0.45 kg a week. |
| Fight-week drop | `WeekPlan.gd:71-73`, `:289-290` | `TAPER_KG` 0.05 kg a day "with no dehydration". There is no water cut in the game. |
| The cage | `Sim.gd:222-224`, the same in `Sim.weigh_forecast :154-156` and `CampForecast.gd:82-84` | Weight is clamped between limit - 1.5 and limit + 1.6 kg. **He can never grow out of a class, balloon on a layoff or go light.** |
| The forecast | `Sim.weigh_forecast`, `Sim.gd:136-160`; `CampForecast.run` (`CampForecast.gd:35`, result `:100`) | Steps the real days to the bout: {now, day, limit, ok, over}. The weigh-in is the day before the bout for everyone (`Sim.gd:142`; `modals/WeighIn.gd:17` "THE DAY BEFORE"). |
| Dating a bout | `Bouts.makeable_day`, `Bouts.gd:163-170` | An offer for a boxer over his class is dated a week at a time later until the forecast makes the limit, 4 weeks at most (`:51`). |
| Club shows | `WeighGap.gd:7-9`, `:33-39`; `AskFlow.gd:83-93`; `FightWeekPlan.weight :183-189` | Two amateurs are matched on walking weight within 2.5 kg (limit up to 65) or 5 kg, 2 kg for a skills bout. The opponent's weight is `opp["weight"]`, else the limit. |
| Fight-week ways | `WeighGap.ways :44`, `FightWeekPick.weight_way :84`, `FightWeek.gd:34` (rules), `modals/FightWeek.gd:131-138` | Eat less (4 off the tank), train it off (0.3 kg for +8 tiredness, `WeighGap.gd:13-14`), ask a kilo (a favour). |
| The scale | `Bouts.weigh`, `Bouts.gd:361-391`; `BoutRules.made_weight :283-284` (tolerance 0.05, `:111`) | Made, or inside the gap. A club-show miss is re-matched 1 time in 3 (`PullOutWire.weigh_miss`, `PullOutWire.gd:195-216`; `WeighGap.gd:18`). Else: news, $300 (`BoutRules.gd:112`), bout and camp gone, next offer in 6 days (`Bouts.gd:48`). A championship miss puts him out of the draw (`Bouts.gd:376-382`, `Champs.withdraw`, `Champs.gd:179-184`). **No reputation, no morale, no record entry.** |
| The tank at the bell | `BoutRules.tank_parts`, `BoutRules.gd:203`; constants `:41-45` | tiredness + the scale part (`eat_kg`: 10 a kg same day, doubled past 0.5 kg; 5 a kg the day before) + the last bout, 25 off at most. |
| ...and its scale part | `BoutRules.gd:237`, `:243` read `bout["eat_kg"]` | **Nothing in `scripts/` writes `eat_kg`** (grep: `BoutRules.gd` is the only file that names it). The scale part of the tank is always 0. Making weight costs nothing on the night except the 4 points of "Eat less". |
| The fight | `Duels.gd`, `Exchanges.gd`, `Knockdowns.gd`, `RingDuel.gd`, `WorldBout.gd` | None reads a weight, a limit or a division (grep at this commit: the only hit is a style-weights table, `Exchanges.gd:313`). Reach and height are read (`Duels.facts`, `Duels.gd:416-425`; `REACH_PER_CM` `:39`, `HEIGHT_PER_CM` `:40`, used at `:196`, `:212`, `:233`). |
| Body by class | `AttrGen.body`, `AttrGen.gd:228-230` | Height = 172 + 1.0 a kg of the LIMIT over 60 (women 8 less) + noise, reach from height: both already follow the class. |
| The opponent's kilos | `TapeRows.opp_weight`, `TapeRows.gd:74-80` | Invented for the tape: 0.2 to 0.8 kg under the limit, fixed by name. World boxers carry no weight. |
| Going pro | `ProLadder.division_for`, `ProLadder.gd:43-49` | The table is picked from the amateur limit (to 57.5 feather, to 62 light, to 70 welter, else middle). `limit` is not rewritten (finding L2 of the DMGCLASS1 v3 critic). |
| The 3D body | `ArmBuild.gd:2-12`, `k :29-30`, `BONES :18-24`, `apply :42-57` | Arms and shoulders are as thick as Strength (40 -> 1.00, 80 -> 1.24, bounds 0.96 to 1.30), by scaling only the helper bones that carry skin, across the limb. Nothing scales with weight. |
| Goals and mood | `FighterGoal.gd:5` | "make-the-weight" was dropped at the restart. No boxer asks for a class or refuses one. |
| His say, elsewhere | `PushBack.gd:50` (his ask about the week), `FighterProfile.gd:18-33` ("heard" +5, "overruled" -5, "refused" -4, goal missed -20 from `FighterGoal.gd:40`), `Loyalty.gd:45-62` (the price list), `Promises.gd:37` | The patterns a refusal can reuse exist: an ask, a mood price, a loyalty price, a promise. |
| Injury | `InjuryRoll.gd`, `FightWeek.gd:40` | No read of a weight or a diet (grep). (`SPAR_LATE_CUT_STOP` is a cut eyebrow.) |
| Age | `WorldAge.gd:29` | World boxers age a year at a time. The only write to an `age` in `scripts/` is that line: the club's own boxers never get older (grep of `["age"] =` and `+=`; a merge I did not find could still do it). |
| Knowledge | `Knowledge.gd:13` (groups), `:94-106` (width), `:174` (`range_of`), `:186`, `:199` (age 30+ widens "body") | The misread pattern exists and has a body group. Weight is not in it: every kilo on every screen is exact. |

### 1.2 Where a player sees weight today

`DarkOverview.gd:438-443` (kg, limit, over), `FighterTile.gd:57-60` (the WEIGHT ring), `HomeRows.gd:196-202` ("1.2 to lose", amber
inside 14 days, `:16`), `RosterRow.gd:140-164` and `RosterTable.gd:56`, `CoachCheck.gd:54-63`, `FightPrep.gd:189-192` (CAMP AND WEIGHT),
`Gauges.gd:47-49` (the SCALE band) and `:60-66` (the class window down to the next class, 3 kg at most, `:35`), `AskPanel.gd:79-84`,
`FirstWeekStrip.gd:189-192`, `modals/FightWeek.gd:60-62, 127-136` (THE WEIGHT), `modals/WeighIn.gd:14-19`, `TapeRows.gd:64-68`,
`BoutActs.gd:259-260` (the toast), `WeekBoard.gd:353-357` (the diet pills). Fourteen places, all of them one question: "is he under
the line on the day?"

### 1.3 What that adds up to

Weight today is a gate with a forecast: make the line or lose $300. It has no price on the night (the dead `eat_kg`), no size,
no choice of class, no body that changes, and its one switch (Cut) is thrown by the camp anyway. This map makes it a decision.

## 2. What is known from the real world (John SQ278, his tags)

| # | Fact | Tag | Source as John gives it |
| :- | :--- | :--- | :--- |
| 1 | A 4.8 % heat cut: repeat efforts 19 % slower after 3 h of eating and drinking, still 14 % slower at 24 h | SOURCED | Barley, JSCR 2018, 14 MMA athletes |
| 1 | A 3.2 % cut: 28 % fewer reps after 3 h, peak strength unchanged | SOURCED | Barley, Front Physiol 2018, 14 athletes |
| 1 | A 3 % cut: punch force -3.2 to -4.6 %, not significant | SOURCED | Smith, IJSNEM 2001, 8 amateur boxers |
| 1 | About 3 % dehydrated: endurance -8.3 %, strength -5.5 %, anaerobic power -5.8 % | SOURCED | Savoie, Sports Med 2015, 28 studies |
| 1 | Attention -0.52, coordination -0.40 (effect sizes); reaction time no significant change; worse above 2 % | SOURCED | Wittbrodt, MSSE 2018, 33 studies, 413 people |
| 1 | Under 2 % is "unlikely to affect" performance | SOURCED | Reale, GSSI 2018 |
| 2 | Pro boxers regain 4.4 kg = 7.2 % of body mass; one in five 10 % or more | SOURCED (high) | Murugappan and Reale, Phys Sportsmed 2022, 399 boxers |
| 2 | Each 1 % regained multiplies the odds of winning by 1.13 | SOURCED (high) | Baribeau, IJSPP 2023, 1,392 boxers |
| 2 | IBF title fights: +3.8 % with about 12 h, no effect on results | SOURCED | Daniele 2016, 142 boxers |
| 2 | Elite amateurs with 3 to 12 h: men +2.1 %, women +1.5 %, no link to winning | SOURCED (medium) | Reale, IJSPP 2017, 100 boxers |
| 2 | Amateurs with 1 h: +0.3 to 1 % | ESTIMATE (NOT FOUND) | John |
| 3 | Dehydration and stoppages or concussion rates | NOT FOUND | The measured risk is being the lighter boxer on the night (Baribeau 2023: the weight gap predicts KO and TKO wins, SOURCED) |
| 4 | Safe: a cut of at most 8 % with more than 12 h; at most 5 % (no more than 3 % by dehydration) with 6 h or less | SOURCED | Reale 2018 |
| 4 | Losing 0.7 % a week kept lean mass; 1 % a week did not | SOURCED | Garthe 2011, 24 athletes |
| 4 | Boxers lose about 3.6 % in the last week | SOURCED | Reale 2017, 73 boxers |
| 4 | England Boxing: club weigh-in 1 hour before; at championships at most 1 kg lost in the 2-hour window. World Boxing: a weigh-in every boxing day, 3 h or more before, no tolerance. BBBofC: 24 to 36 h before. WBC: at most 10 % over at 30 days, 5 % at 14, 3 % at 7 | SOURCED | the bodies' rules |
| 5 | Median growth, kg a year: boys 3.6 (16 to 17), 2.6, 1.9, 1.4 (19 to 20); girls 1.2, 1.0, 1.1, 0.9 | DERIVED | CDC 2000 table (US population, an archive mirror) |
| 5 | Ages 21 to 23: 0.5 to 1 kg a year | ESTIMATE | John |
| 5 | Elite female judoka gained 1.76 kg a year, about 1.6 times the median girl | SOURCED | Smaruj 2019, 12 athletes |
| 5 | Cuts getting harder with age | NOT FOUND | |
| 6 | Heavyweights who had boxed in lower classes were 19.9 % less likely to win | SOURCED | Fiala, IJSSC 2025 |
| 6 | 41 multi-class champions, 2 or more classes up: wins 94 % -> 74 %, KO share of wins 69 % -> 53 %, stopped 2.0 -> 6.5 in 100 | DERIVED, biased: an upper bound | John's count |
| 7 | The heavier boxer on fight night wins more; about +3 wins in 100 per 1 % heavier at even odds | SOURCED; the 3 is John's reading (DERIVED) | Baribeau 2023 |
| 7 | Reach: a 2-inch edge wins 58 %, 8 inches 65 % | weak | Fight Matrix blog 2008, not peer reviewed |
| 8 | Elite amateurs: 1 miss in 101 boxers. An amateur miss is a walkover (England Boxing, World Boxing) | SOURCED | Reale 2017; the rules |
| 8 | Pro boxing miss rate: 1 to 3 % | ESTIMATE (NOT FOUND) | UFC 2021 stands in: men 2.8 %, women 4.7 % (SOURCED, a journalist's count) |
| 8 | Pro fines: Ohio 20 / 25 / 30 % of the purse, Oregon and California 20 %; an IBF champion loses the title on the scale | SOURCED (Nevada 25 %: CHECK) | commissions |
| 9 | Pros are about 7 % over the limit on fight night | SOURCED | as row 2 |
| 9 | Pros between camps 8 to 15 % over; amateurs walk 3 to 5 % over | ESTIMATE | John |
| 10 | UK nutrition support: a 10-week camp 400 to 650 pounds ($500 to $813), a weigh-in night 200 pounds | SOURCED | the providers' own pages |

John's game reading, used in section 3 and in the probe (his section "What this means", DERIVED or ESTIMATE): the first 2 % of
a cut is free; each 1 % past it costs an amateur Stamina 4 %, power 1.5 %, defence and reading 1 %, and a pro Stamina 1.5 %
(3 % past a 5 % cut), power 0 (1 % past 5 %), defence and reading 0.5 %; hard caps 5 % amateur, 8 % pro; regain +0.5 % with a
1-hour scale, +1.9 % with 3 hours or more, +7 % pro; two misses push a boxer up a class; moving up two classes: KO share x 0.88,
stopped x 1.5 (ESTIMATE, half his biased count); a nutritionist halves the camp's stamina penalty (ESTIMATE).

Still unanswered, so still my ESTIMATE: how the size edge splits between punch, chin and hand speed; the training price of
holding weight under natural; the miss slope past the safe line and Discipline's part in it; the tolerance lost per year of age;
one rung for a class move. Three items John cites unopened (CHECK): the 2 to 5 % youth cut, Nevada's 25 %, a 4.4 % amateur
day-before regain. None of the three is used here.

## 3. The design: seven decisions

### 3.1 Two weights and a diet (the week) - replaces the camp's automatic cut

- NEW `natural` (kg): where the body settles. Starts at today's `weight`. Grows while young (3.7).
- `weight` becomes the WALKING weight and loses its cage (`Sim.gd:222-224` and its two copies removed).
- The DIET, one setting per boxer, set on Monday, kept until changed. It replaces the Hold / Cut pills (`WeekBoard.gd:353-357`)
  and the rule in `Sim.week_ctx` (`Sim.gd:123`) that cuts by itself in a camp.

| Diet | Walking weight heads for | Price | Trade-off |
| :--- | :--- | :--- | :--- |
| Eat free | natural + up to 2 % (he fills out) | none | Bigger body, further from the line |
| Hold | natural | none | Today's HOLD |
| Lean | as far as 2.5 % under natural, never faster than 0.7 % of body weight a week (SOURCED, Garthe 2011: that pace keeps lean mass; the game's 0.45 kg a week is 0.6 to 0.8 %) | training gain x (1 - 0.12 per 1 % held under) (ESTIMATE: John found the pace line, no number for a standing deficit) | The line is close on fight week; he learns slower all camp |
| Strip (only on a class move down) | as far as 5 % under, at 1 % a week | the same slope, twice as far; at 1 % a week lean mass goes (SOURCED direction, Garthe 2011) | A new body: weeks of it before the first bout |

The morning sessions still burn what they burn (`WeekPlan.day`, `WeekPlan.gd:268-269`): a hard week pulls the scale down faster
and a rest week lets it climb. What changes is that the player owns the setting and it costs the gain he is planning that week.

### 3.2 Water in fight week (performance) - gives the dead tank part a job

In the Fight week modal's THE WEIGHT column (`modals/FightWeek.gd:127-136`) the three ways become one question: how much of
what is left comes off as water. None / Light (to 2 % of body weight) / Hard (to his limit, 3.3).

- **Light is free.** Under 2 % performance is not touched (SOURCED, Reale 2018). This is the "manageable" part: a boxer kept
  close by his diet never pays on the night.
- **Past 2 %, the price is his engine, not his punch** (John's table, DERIVED from Barley 2018, Smith 2001, Savoie 2015):

| Each 1 % of water past the free 2 % | Same-day scale (amateur) | Day-before scale (pro) |
| :--- | ---: | ---: |
| Stamina, and the same share off the tank at the first bell | -4 % | -1.5 % (-3 % past a 5 % cut) |
| Power | -1.5 % | 0 (-1 % past a 5 % cut) |
| Defence and reading the fight | -1 % | -0.5 % |

- v1's chin and hand-speed drops are REMOVED: no study links dehydration to stoppages (NOT FOUND) and reaction time does not
  move (SOURCED, Wittbrodt 2018). The stoppage risk of a cut arrives through size (3.4): the boxer who cut and did not get it
  back is the lighter one.
- What is back by the bell is a share of body mass set by the hours, never more than he took off: +0.5 % an hour before
  (a club show; ESTIMATE 0.3 to 1), +1.9 % with three hours or more (a championship day; SOURCED basis: men 2.1, women 1.5),
  +7.2 % the day before (pro; SOURCED). The game weighs everyone the day before today (`Sim.gd:142`): the amateur's same-day
  scale is NEW, and it is the round-5 board plan's "one amateur scale, weighed an hour before".
- Where it lands in code: the tank share is `bout["stale"]`, which `BoutNight._energy` already takes off at the first bell
  (`BoutNight.gd:324`); Stamina is what the fade from round 3 reads (`BoutRules.own_fade :330`, the 60-Stamina line at
  `BoutRules.gd:86-89`) and what his combinations spend against (`Combos.round_spend :241`). So a hard cut shows late, where
  a corner expects it, and not in round 1.
- `eat_kg`, its two readers (`BoutRules.gd:237, 243`) and the "Eat less" 4 points (`FightWeek.gd:34`) go. "Ask a kilo" stays.

### 3.3 The body's limit (manageable to a point)

- The SAFE LINE is the scale's, the same for everyone (SOURCED, Reale 2018): 3 % by water on a same-day scale, 8 % in all
  with more than 12 hours. Under it a boxer misses about 1 scale in 100 (SOURCED, Reale 2017: 1 in 101 elite amateurs).
- NEW `cut_tolerance`: HIS line, between the safe line and the hard cap of his scale (5 % same day, 8 % the day before:
  John's caps). Set at signing from his frame and Discipline (ESTIMATE), shrinking with age (3.7).
- Between the safe line and his tolerance each further 1 % is a chance to MISS (ESTIMATE: 20 points a 1 %, x 1.5 for no
  Discipline to x 0.5 for all of it; `personality.discipline`, `Data.gd:229` Samira 34, `:242` Josh 80). Past the cap he misses.
- So the control is real and bounded: the player can always ask for more water, and the body can always say no on the day.

### 3.4 Size on the night (scaling), and the body the player sees

- NEW ring weight = the limit + what he puts back (3.2), or his walking weight when he is under the limit. The opponent has
  one too: world and region boxers get a walking weight from their limit and scale (today `TapeRows.opp_weight` invents 0.2
  to 0.8 under; real amateurs walk 3 to 5 % over, ESTIMATE; pros are 7 % over in the ring, SOURCED).
- **What a kilo is worth is now a counted number:** about 3 wins in 100 for each 1 % heavier at even odds (DERIVED from
  Baribeau 2023, 1,392 boxers). The probe fits the mechanic to it (4.5, step 0).
- Where it is read: where reach and height already are (`Duels.facts`, `Duels.gd:416-425`). Per 1 % heavier: punch +1.2 and
  chin +1.0 in the count odds (`RingDuel.side`, `RingDuel.gd:138-139`; `WorldBout._side :324` for the world), hand speed -0.4,
  capped at 8 points (the split is my ESTIMATE; Baribeau gives the direction: the weight gap predicts KO and TKO wins), and a
  mass term in the exchange odds beside `REACH_PER_CM` (`Duels.gd:39`, `:196`) sized so the total is the 3 in 100.
- This IS the carry-over on a class move: no separate "power carries up" number. Check against John's count (41 champions
  two classes up: KO share x 0.77, stopped x 3.2, an upper bound; his game ESTIMATE x 0.88 and x 1.5): the probe prints it.
- **Men's 65 kg** (Q-292): the class ladder is women 57, 60, 65, 70, 75 and men 55, 60, 65, 70, 75. A 60 kg man's move up is
  5 kg (8 %), not 10. Still missing for a full ladder: one class under the lightest and over the heaviest per sex (scope, asked
  in section 6).

**The 3D body shows his weight (Q-294; built only after the critics pass, and after FIGHTPLAYER2).**

| | The read |
| :--- | :--- |
| The one number | fill = ring weight / frame weight. Frame weight is the weight his height carries, the inverse of `AttrGen.body` (`AttrGen.gd:229`: 60 kg at 172 cm, 1 kg a cm, women 8 cm shorter). Girth factor w = sqrt(fill), bounds 0.96 to 1.06: at a fixed height mass goes with girth squared, so 7 % more mass is 3.5 % more girth. |
| Which bones | The ArmBuild rule, measured on this rig (`ArmBuild.gd:7-12`): scale only helper bones that carry skin, on the two axes across the limb, never a bone of the chain. Trunk: `spine_04_latissimus` and `clavicle_pec` (both already in `ArmBuild.BONES` at half share, `:23`). Legs: the thigh and calf twist helpers, half share. The waist: a helper bone if the rig has one (NOT FOUND in `scripts/`: a bone census of the skeleton is phase 0 of the build), else a body blend shape on the mesh. |
| What is never scaled | `spine_01` to `spine_05`, the neck, the clavicles, the limb bones: a scale there is inherited down the chain and moves the head and the glove, which are the punch targets (`ArmBuild.gd:8-12`). Reach, height, guard and glove read exactly as before; `arm_build_test`'s checks (length, reach, glove unchanged) are extended to the trunk. |
| With Strength | On a shared helper the two factors multiply (Strength k x weight w), total clamped 0.94 to 1.34. Strength is the arms and shoulders; weight is the trunk and legs. |
| What the picture can honestly show | The CLASS (a 57 beside a 75), a boxer who filled out or stripped down (5 % of mass = 2.5 % of girth), and the size gap of the night when it is 4 % or more. It cannot show a kilo, and it cannot show water: 3 % dry is 1.5 % of girth. Drain is shown in words (tape row, the Why) and in the late-round fade, never as a thinner man. |
| Risk | A 1.5 % change may be invisible on the broadcast camera: the build's first step is a still pair at w 0.96 and 1.06 on the game's camera, both men head to feet, before any wiring. |

### 3.5 The class (the owner's ask), and his right to say no

- On the fighter's Overview BODY card, between bouts only: "Box at 65 kg from the next bout" with the forecast beside it
  (weeks to make it, water left for fight week, size against that class's field, where he lands on the ladder).
- Amateur: his class is whatever he enters at; the regional ladder is per class (`Region.rankings :200`, `our_rank :237`), so he
  joins the new one a place lower than he stood. Pro: a table move one rung down; a top-3 keeps his rung. (Round 1 took two
  rungs and staying was best in 10 of 10 cells; one rung is round 2's measured rule.)
- Turning pro picks the class on purpose: `limit` is rewritten to the table's row (fixes L2, `ProLadder.gd:43-49`).
- He ASKS: after two Hard waters in a row, or a missed scale, he asks to move up (the `PushBack` pattern, `PushBack.gd:50`).
  Turning him down is "overruled": morale -5 (`FighterProfile.gd:30`), loyalty -5 (`target_against`, `Loyalty.gd:51`).

**He can refuse (Q-293).** The answer is on the card BEFORE the player commits: no hidden roll.

| | Rule |
| :--- | :--- |
| What decides it | His GOAL: a class he is ranked top 3 in, or has a championship entry or a promise in, he will not leave; a boxer the scale is already hurting (his own class needs water past the safe line) wants up and all but never refuses it, and fights a move down. His PRIDE (Confidence over 60: "I am not starving myself", "I am the big man here"). His LOYALTY and MORALE: a Loyal boxer (70 and over, `Loyalty.gd:22-24`) goes where the club says unless his goal is against it; a Wavering or Low one says no. |
| As numbers (DESIGN, run in the probe) | Chance of a no: 30 % to a move up, 50 % to a move down, +0.5 a point of Confidence over 60, -0.6 a point of Loyalty over 50; wants up: 5 % for up, +25 for down; never under 5 or over 90. In the game it is the same sum against a fixed line, shown as his answer with its two biggest reasons. |
| Push him: insist | He boxes there. Morale -20 (the size of a missed goal, `FighterGoal.gd:40`), loyalty -8 (the price of `decline_pro`, `Loyalty.gd:61`: both are "the club chose my career"). A Flat or Low boxer takes in less of the corner's word (trust 0.85 / 0.7, `FighterProfile.gd:39`, `:60-61`; read at `BoutRead.gd:235`; a Low one ignores the call, `CornerTrust.gd:11-12`), and under 25 loyalty he leaves (`Loyalty.gd:27`, `leaves :202`). |
| Push him: wait | He boxes on in his class; ask again after the next bout. Each thing that makes the case halves his no: a Hard water, a missed scale, a loss to a bigger man (for up); a loss up there (for down). The probe's player waits three bouts. |
| Push him: a promise | "One bout up there. If it goes wrong, we come back." A new kind in `Promises` (`Promises.gd:37`; kinds today `:11-13`): he says yes; kept +5, broken -12 (`Loyalty.gd:47`). |

### 3.6 The club and what the player knows

- A miss, by bout (v1 changed): a CLUB SHOW keeps today's gap rule (`WeighGap`, `PullOutWire.weigh_miss`): matched on walking
  weights, re-matched 1 in 3, else off + $300. A CHAMPIONSHIP or ladder bout is a walkover loss (SOURCED: England Boxing,
  World Boxing; today he is out of the draw, `Bouts.gd:376-382`). A PRO bout goes on and the club pays 20 % of the purse
  (SOURCED: Oregon, California), and a champion loses the belt on the scale (SOURCED: IBF). Every miss: reputation -1 and
  it is on his file; after two the matchmakers move him up a class (John's reading) - the round-5 "declared walking weight"
  as a consequence.
- A nutrition plan is a coach's job: one of the coach's evening slots a week on a Lean or Strip boxer halves the diet's
  training price (the "coach's hands" of `DEPTH_SCOPE_S534.md` row 3). Or it is BOUGHT for one camp at the real price: $500
  to $625 for an amateur camp, $875 to $1,250 for a pro's (SOURCED prices; "halves the penalty" is John's ESTIMATE). One
  button on Fight prep, no hire.
- KNOWLEDGE: the scale is exact. His tolerance and how dry he is are a read with error (`Knowledge` body group,
  `Knowledge.range_of :174`: a range, never a lie). Each Hard cut he makes narrows it; a layoff or age widens it (`:199`).
  The opponent's weight story is a tape row: "walks 4 kg over: cuts hard" means bigger than you and likely to fade late.

### 3.7 The long career

- Natural weight grows by age and sex (DERIVED, CDC medians; x 1.0 to 1.6 per boxer, SOURCED basis Smaruj 2019): a boy +3.6 kg
  at 16, 2.6 at 17, 1.9 at 18, 1.4 at 19; a girl 1.2, 1.0, 1.1, 0.9; 0.5 to 1 a year from 21 to 23 (ESTIMATE), then none.
  A 16-year-old boy outgrows a class a year whatever the player does. Kira (18, 58.3 for 57, `Data.gd:222`) gains 1.1 to
  1.8 kg this year: she is a lightweight by 19.
- From 28 the tolerance shrinks (ESTIMATE -0.2 a year: John found NOTHING on age and the cut. A critic may cut this line).
- The club's own boxers do not age today (1.1): the build needs a birthday first.
- So a career has a weight arc: start light, fill out, one or two class moves, the last one forced. Each is a decision with
  a price (a rung, his mood) and a window (before the body decides for him).

### 3.8 What it deepens, what it removes (free hand, owner S534)

| | What | Why |
| :--- | :--- | :--- |
| Removes | The camp's automatic cut in `Sim.week_ctx`; the weight cage (three copies); `eat_kg` and its readers; "Eat less" and "Train it off" as separate ways; the invented opponent weight; v1's chin and speed drain | Each is a rule the player cannot touch, a number nothing uses, or a claim no study carries |
| Deepens | The week (a diet has a price in the gain he is planning); the tank and the fade (a reason they differ bout to bout); the count and exchange odds (size); the ladder (a class is a place to be); loyalty and promises (a class is his career too); Knowledge (a body read worth paying for); the coach's evenings | Existing systems get a second input instead of a new screen |
| Adds | natural weight, cut tolerance, ring weight, the class move with his answer, the miss on file, a same-day scale | Six numbers, three decisions |
| Leaves alone | The club-show gap (`WeighGap`), the forecast (`Sim.weigh_forecast` keeps its job with the diet as an input), the $300 at a club show | They work |

### 3.9 Kept manageable: what is NOT in

No calories, no food, no body-fat number, no sauna minigame, no catchweight haggling, no IV or rule-breaking, no per-day water
slider (three settings), no nutritionist hire, no weight for the BJJ fighter (`RosterRow.gd:141-142` keeps her class word).
A week asks at most: one diet setting per boxer on Monday (only shown when he is not on Hold or a bout is near), and in a fight
week one water setting. The class card appears between bouts. One screen.

## 4. The probe (measured before any critic)

`tools/weight2_probe.gd` through `godot_slot`. Real: five Data boxers (Samira the puncher, Josh the volume man, Tess the big
chin, Kira walking 2.5 kg heavier as the drained cutter, Danny as a plain boxer-puncher), their region opponents, and every
bout (`BoutNight.play_out`, `BoutNight.gd:102`, on a scratch career; every choice of a seed on the same nights). Scratch: the weight
model of section 3, on a class table with a step above and below everyone. 10 cells = 5 boxers x 2 scales; 4 choices.
Bars: each lever moves the result; no single choice best in more than 6 of 10 cells.

| Round | Model | Result | Best counts |
| :--- | :--- | :--- | :--- |
| 1 (875376421) | estimates; a move costs two rungs; 6 bouts | FAIL | STAY 10 of 10 |
| 2 (ddc061494, `docs/WEIGHT2_PROBE.md`) | estimates; one rung; size in the exchanges at 0.35 rating points a 1 %; 12 bouts | PASS | STAY 5, CUT 2, UP 2, DOWN 1 |
| 3 (this map, `docs/WEIGHT2_PROBE3.md`) | John's numbers; the refusal; an error per cell | PASS (weak: no cell clear of the noise) | CUT 4, STAY 2, UP 2, DOWN 2 |

Rounds 1 and 2 in full: `DESIGN_WEIGHT2.md` sections 4.1 to 4.4.

### 4.5 Round 3

Run: 20 seeds x 12 bouts a run, 3 seeds for the lever check, 10 seeds for the fit; 23,816 bouts in 1,229 s, no script error.
Full output: `docs/WEIGHT2_PROBE3.md`. On main (the `s535/dmgfix` merge has not landed: risk 5).

**What changed in the model.** The drain is John's table (free to 2 %, then Stamina, tank, power and reading by scale; no chin,
no hand speed). Regain is a share of body mass by scale (0.5 % / 7.2 %), for the opponent too, so a pro field rings 7.2 % over
the limit. A missed amateur scale is a walkover loss; a pro who misses boxes on; two misses move him up a class. Safe lines 3 %
and 8 %, caps 5 % and 8 %. A boxer may refuse a move (3.5) and the player waits three bouts. Every ladder place carries its
standard error, and a choice within two standard errors of the best (seed by seed, same nights) is called a tie.

**Step 0, the fit.** With no cut and no ladder, the stat split of size (punch, chin, hand speed) is worth 1.10 wins in 100 per
1 % of ring weight and a rating point 4.75. To reach John's 3.0 the rest goes in the exchanges: 0.40 rating points per 1 %
(round 2 guessed 0.35). The field was then eased until STAY starts at about half (offset -5.3 amateur, -10.9 pro: our boxers
give a pro field 6 % of body weight just by walking light, risk 7).

| Bar | Measured | |
| :--- | :--- | :--- |
| Each lever moves the result | size 4.5 points of win share (best choice changes in 6 of 10 cells with it off), rank 2.2 (2), diet 1.9 (2), miss 1.7 (0), drain 0.9 (4), refuse 0.6 (0) | met |
| No single choice best in more than 6 of 10 cells | CUT harder 4, STAY 2, UP 2, DOWN 2 | **met** |
| (new) cells where the best is clear of the noise | **0 of 10** | read below |

**RESULT: PASS on round 2's bars, and a weak one.** Ladder place after twelve bouts (1 is the top; +- one standard error):

| Cell | STAY | CUT harder | UP | DOWN | Best | Inside the noise of it |
| :--- | ---: | ---: | ---: | ---: | :--- | :--- |
| puncher / amateur | 9.80 +- 0.57 | 10.00 +- 0.55 | 12.28 +- 0.54 | 12.15 +- 0.52 | STAY | CUT |
| puncher / pro | 10.43 +- 0.47 | 9.57 +- 0.37 | 11.25 +- 0.43 | 9.45 +- 0.48 | DOWN | CUT |
| volume / amateur | 8.88 +- 0.55 | 8.85 +- 0.56 | 10.28 +- 0.53 | 10.73 +- 0.54 | CUT | STAY |
| volume / pro | 8.47 +- 0.45 | 6.58 +- 0.42 | 9.15 +- 0.41 | 6.95 +- 0.41 | CUT | DOWN |
| big chin / amateur | 9.15 +- 0.52 | 9.30 +- 0.53 | 9.18 +- 0.52 | 10.78 +- 0.52 | UP | STAY, CUT |
| big chin / pro | 7.78 +- 0.40 | 7.35 +- 0.43 | 8.85 +- 0.42 | 7.70 +- 0.44 | CUT | DOWN |
| drained cutter / amateur | 10.18 +- 0.53 | 9.40 +- 0.46 | 9.13 +- 0.50 | 12.20 +- 0.45 | UP | CUT |
| drained cutter / pro | 6.10 +- 0.40 | 5.95 +- 0.42 | 7.42 +- 0.40 | 6.35 +- 0.43 | CUT | STAY |
| boxer-puncher / amateur | 8.90 +- 0.48 | 9.28 +- 0.52 | 10.25 +- 0.45 | 10.68 +- 0.62 | STAY | CUT |
| boxer-puncher / pro | 7.38 +- 0.42 | 6.83 +- 0.38 | 8.25 +- 0.40 | 6.58 +- 0.36 | DOWN | CUT |

What it says, and how far to trust it:

1. **No cell has a clear winner.** Every best has at least one other choice inside the noise. The split 4 / 2 / 2 / 2 is the
   lowest mean in each cell, nothing more. What IS established is what loses: a choice two standard errors behind the best.
2. **The scale still decides the direction, and that part is clear.** Same-day scale: moving DOWN is out of the leading group
   in all five cells (1.3 to 3.4 scales missed in twelve; 50 to 100 % of those runs ended moved back up by two misses), and UP
   is out in three. Day-before scale: UP is out in all five (it gives a field that rings 7.2 % over the limit 10 to 11 % of
   body weight) and STAY in four; CUT harder or DOWN leads every cell. An amateur should not cut; a pro must. This held in all
   three rounds.
3. **CUT harder is in the leading group of all 10 cells.** That is the finding a critic should press. On the day-before scale
   it is boxing as it is (walk bigger, get it back). On the same-day scale it is level with STAY because it is nearly free:
   2 kg more is 1.5 to 2.4 % of water, at or just past the free 2 %, and it closes a 0.5 % size gap. A choice that costs nothing
   and gains nothing is not a decision. It needs a price the probe does not carry: the diet weeks, or walking 2 kg heavier all
   camp. (In the cutter's amateur cell "CUT" is not CUT at all: she misses twice in every run and is moved up; that row is
   UP with two walkover losses.)
4. **The drain is small where John puts it.** Its mean effect is 0.9 points of win share: with the first 2 % free and a 5 % cap,
   an amateur can only ever be 1 to 3 % past the line (4 to 12 % of Stamina), and the cells that go further miss the scale
   instead. The stamina story shows in the cutter (-7 % Stamina staying: late rounds are not worse, but she misses 1.5 scales
   in twelve) more through the SCALE than through the fight. The bigger lever by far is size (4.5 points, 6 cells).
5. **Size lands at 1.2 wins in 100 per 1 % on the ladder**, against the 3.0 it was fitted to with the field held still: a
   winner meets better men. That is the right behaviour for a ladder; a build should fit to the 3.0 off the ladder, as here.
6. **The refusal barely moves the ladder** (0.6 points, no cell changes its best; it passes the bar on one cell's 1.2 rungs
   over 3 seeds, which is noise-sized). Waiting three bouts is cheap. As designed the refusal is a mood and loyalty decision,
   not a ladder one; if it should bite, "wait" needs a clock (his window closes, or the next ask is harder).
7. **Moving up, against John.** One class up, pooled: knockout share of the wins 31 % -> 29 % (x 0.91), stopped 5.6 -> 7.2 in
   100 (x 1.29). John's ESTIMATE for two classes: x 0.88 and x 1.5. Same direction, a plausible size for one class.
8. **Not established:** any single cell's winner; the diet, miss, rank and refuse levers on 3 seeds (their changes are of the
   size of the noise); everything in risk 4. Twenty seeds give half a rung of error; separating choices 0.3 rungs apart needs
   about 100 seeds a cell.

Not resized: the bars are met, so the model stands as run. The two things above that I would change before a build (a price
for walking bigger, a clock on "wait") are design changes for the critics to rule on, not number fixes.

## 5. Every menu it appears on

| Menu (file) | Shows | Wired to |
| :--- | :--- | :--- |
| Fighter Overview, BODY card (`DarkOverview.gd:438-443`) | Walking / natural / limit, the diet setting, the tolerance as a range, the class card between bouts WITH HIS ANSWER and its two reasons, and the three ways to push | `natural`, `diet`, `cut_tolerance` through `Knowledge.range_of`, the class move, `Loyalty`, `Promises` |
| Week board, Monday (`WeekBoard.gd:353-357`, the goal line `WeekData.gd:38`) | Three diet pills in place of Hold / Cut, the price beside this week's gains ("Lean: -18 % on what he learns") | `WeekPlan.week` (`WeekPlan.gd:302`) gain x the diet multiplier |
| Fight week modal, THE WEIGHT (`modals/FightWeek.gd:127-136`) | Water: None / Light / Hard, with what is back by the bell, the Stamina and tank it costs, and the miss chance as a range; the safe line marked | `bout["water"]` -> `bout["stale"]` and the bout-only Stamina, power and reading; `FightWeekPick.weight_way` proposes it |
| Fight prep, CAMP AND WEIGHT (`FightPrep.gd:189-192`) and the SCALE gauge (`Gauges.gd:47-49, 60-66`) | The forecast with the diet in it; the band from natural down to the limit; "Buy a nutrition plan for this camp" | `Sim.weigh_forecast`; the camp purchase |
| Ask panel (`AskPanel.gd:79-84`), offers | "Makes 60 with 1.1 % water" instead of "Weight at risk" | the same forecast |
| Tale of the tape (`TapeRows.gd:64-68`), versus | Both ring weights and the gap; the opponent's weight story as a row | ring weight both sides, `OppFile` |
| Weigh-in modal (`modals/WeighIn.gd:14-19`) | The scale, WHEN it is (an hour before, three hours, the day before), a miss and what it costs for this bout | `Bouts.weigh` + the miss roll |
| The Why after a fight (`FightWhy`), tank words (`BoutRules.tank_words :266`) | "the scale 9" as a sized line; "outweighed by 3 kg in the ring" | the tank part, the size gap |
| Roster and home rows (`RosterRow.gd:140-164`, `HomeRows.gd:196-202`, `FighterTile.gd:57-60`, `CoachCheck.gd:54-63`) | Kg to lose, the diet as a chip, "asks to move up", "said no to 65" | `weight`, `natural`, the ask, the refusal |
| Ladder (`WorldLadder.gd`, the regional ladder `Region.rankings`) | His class's table; where a move would put him | `ProLadder.division_for` reading the rewritten `limit` |
| 3D fight | Trunk and legs from ring weight against his frame (3.4) | one factor beside `ArmBuild.k` |

Golden path walk for the build: sign, set Lean, see the gain drop on Monday, book, Hard water, weigh in, box drained, read the
Why, ask for 65 on the BODY card, hear no, make the promise, box at the new class, see the ladder place.

## 6. Questions

Answered by the owner: men's 65 kg (Q-292), the refusal (Q-293), the 3D body (Q-294). Answered by John: nine of v1's ten.
Open, for the owner (scope only): one class under the lightest and over the heaviest per sex, so the end boxers have somewhere
to go. Open, for the critics: is the same-day amateur scale worth a new weigh-in time; is "wait" too cheap a way round a
refusal; should the tolerance-with-age line (no evidence) stay.

## 7. Risks and what is not proven

1. Five slopes are still ESTIMATES (section 2, last paragraph). John's game table (the per-1 % costs) is his reading of small
   studies (7 to 14 people), not a counted curve.
2. I did not open John's sources; his note says three are unopened by him too (CHECK), none used here.
3. The probe puts size and drain on our boxer's stats and the opponent's rating (the opponent is the mirror); the build reads
   both sides in `Duels.facts`.
4. Natural-weight growth, the shrinking tolerance, the diet's coach slot, the boxer's ask, the promise and the Knowledge read
   are designed and NOT probed: they act over seasons, and the probe plays twelve bouts.
5. `Knockdowns` still stops pro bouts on the amateur count rule on main (four counts in the bout, `Knockdowns.gd:5`); the fix
   (`pro_rules`) is on branch `s535/dmgfix`, not merged at this commit. The pro cells' stoppage shares will move when it lands.
6. Reach and height follow the class LIMIT (`AttrGen.body`): a boxer who moves up keeps his frame and meets taller men. Size is
   then counted twice (frame and mass) unless the mass term is fitted with reach in the model, as the probe's step 0 does for
   mass alone (the probe strips the opponent's height and reach).
7. The Data boxers walk 1.5 to 2.3 % over their class; real amateurs 3 to 5 % (ESTIMATE) and pros ring 7 % over (SOURCED). On a
   pro table our boxers are the small ones until the diet and the class move are built. The probe's pro cells show exactly that.
