# DMGCLASS1_V3 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN DMGCLASS1 v3 - stoppages by weight class and sex, written from the code

Kind: design map, research only. No game code changed, Godot not run. Written by a Fable console in the checkout (S534).
Follows: `ops/research/DESIGN_DMGCLASS1_V2.md` and its code-checked critic `ops/research/DESIGN_DMGCLASS1_V2_CRITIC_FABLE.md` (5 / 6 / 4).
Code read at commit 7e63b872a on 2026-11-21. `scripts/state/LiveRound.gd` carries another session's uncommitted edits: its line
numbers are that working copy's. Every other line number is the committed file's.

Words used: CODE = I opened the file for this map and the line is true today. CRITIC-CHECKED = the v2 critic verified it, I did
not re-open it. COUNTED = a real-world number with a sample size and a named source. UNVERIFIED = a seat's number whose source
nobody has opened. ESTIMATE = my number, to be replaced by the probe. Nothing else is claimed.

## 0. What changed from v2, in six lines

1. The class is a decision in three places (signing, turning pro, the towel) and a read in three more (camp, perk road, the Why).
2. ONE fitted number per cell (`count_mult`), not three. Damage and the hurt roll are not touched.
3. Seven fitted numbers in all (four anchors and up to three weight slopes), not 51.
4. The table of real-world rates in v2 section 1 is withdrawn: it is not what the study said (section 2).
5. Women's amateur is the control cell (`count_mult` 1.00): the normal start keeps its towel card.
6. Every false CODE claim of v2 is corrected in section 1.6; F13 is already fixed on main.

## 1. What the game does today (CODE)

### 1.1 Where a bout ends early

| What | Code | Notes |
| :--- | :--- | :--- |
| Round head damage | `Knockdowns.round_counts`, `scripts/rules/Knockdowns.gd:30-32` | Loser +8 / +18 / +32 (close / clear / dominant, `:13`), winner +2 (`:14`). |
| A count | `Knockdowns.round_counts`, `:34-47` | `0.05 x margin factor x exp((power - chin) / 12) x (1 + damage / 60)`, capped 0.85, up to three rolls, each x0.6. |
| The referee | `Knockdowns.round_counts`, `:53-59` | Only after a count: `0.2 x (1 + damage / 60) x (1.4 - heart / 100) x stop_mult`, capped 0.9. A KO needs damage 60 and `(1 - heart / 100) x 0.7`. |
| The count limit | `Knockdowns.round_counts`, `:61-62` | Three counts in a round or four in the bout is an RSC even when the referee roll fails. |
| The puncher's chance | `Knockdowns.puncher_chance`, `:121-138` | The round's winner can be caught: `0.05 x 0.4 x exp(...) x (1 + damage / 60)`, capped 0.5 (`:128`); the same referee roll (`:132-133`). |
| Sides in a player bout | `BoutNight.count_sides`, `scripts/state/BoutNight.gd:236-240` | `RingDuel.side` of each boxer (power = 0.7 power + 0.3 accuracy, chin, heart: `RingDuel.gd:138-139`) plus `stop_mult` = the other side's Finisher (`PerkFight.stop_mult`, 1.5 or 1.0, `PerkFight.gd:30, 64-65`). Nothing else. |
| The round's counts | `BoutNight._counts`, `BoutNight.gd:245-290` | Slugger power added (`:249`), `round_counts` (`:254`), Iron chin (`:256-261`), the liver fold (`:266`), the puncher's chance (`:270`). |
| Damage added inside a watched round | `LiveRound.exchange`, `LiveRound.gd:311-359` (working copy) | Counter sense +15 to the opponent (`:312`, `PerkFight.COUNTER_DAMAGE`), a clinch hit to ours (`:331-334`), a landed set-up +30 to the opponent (`:340`, `CornerJobs.SETUP_DAMAGE`), a landed read +0 today (`:345`, `TheRead.DAMAGE := 0.0`), what gets through the guard to both (`:355-359`). Also `Adaptation.gd:87-89`. |
| The hurt roll in a round | `RingDuel.settle`, `RingDuel.gd:383-386` | Margin past 30 (`Exchanges.HURT_AT`, `Exchanges.gd:54`) and `clamp(0.3 + (power - chin) / 100, 0.1, 0.6)`; ours x talk x 1.6 on a missed set-up or read, clamp to 0.8. |
| World bouts | `WorldBout.fast`, `scripts/world/WorldBout.gd:206-237` | Sides from `_side(profile)` = power, chin, heart only (`:324-325`); built at `fight :127`, `cached :186`, `fast :211`. Calls `round_counts` (`:226`) and `puncher_chance` (`:232`) every round. No live adders. |
| The world's hurt edge | `WorldBout._hurt_edge`, `WorldBout.gd:92-97` | `0.18 + last / 90 + (power - chin) / 60`, clamped 0 to 0.5. |
| Who calls `WorldBout.fast` | `WorldSim.simulate_bout` (`WorldSim.gd:141`), `Region._rival_bout` (`Region.gd:170`, 3 rounds), `Matchmaking.fight` (`Matchmaking.gd:206`, `ROUNDS := 6` at `:24`) | Three callers. |
| World rounds | `WorldSim.rounds_for`, `WorldSim.gd:161-165` | 10 if either is top 10, 8 if ranked, else 6; 3 for a table whose id starts `a_`. No id in `assets/data/world/divisions.json` starts `a_`, so the generated world never takes the 3. It never returns 4. |
| A world stoppage on the record | `WorldSim._apply_bout_result`, `WorldSim.gd:180-189` | `ko` +1 for the winner (`:183`), `WorldAge.record_stoppage_loss` for the loser (`:189`; `WorldAge.gd:119-122`). `WorldSim._roll_stoppage` (`:173-177`) is defined and, per the critic, has no caller. |

None of these functions reads sex, a division or a weight. `ClassDamage`, `punch_mult` and `class_stop` appear nowhere in
`scripts`, `tools` or `tests`; `count_mult` appears only as an unrelated helper name in `tests/deal_contract_test.gd`.

### 1.2 The world is class-blind by construction

- `AttrGen.generate(rng, archetype)` (`scripts/rules/AttrGen.gd:103`) takes no sex and no division: a world boxer's power, chin
  and heart come from the same dice in every division.
- `WorldGen._roll_rating` (`scripts/world/WorldGen.gd:209-216`): 64 to 80 ranked, 55 to 68 unranked, by age only.
- `WorldGen._make_boxer` (`:140-185`): the starting record's KO share is `clamp(0.3 + explosiveness / 30, 0.05, 0.75)`
  (`:150`) in every division. Sex and weight reach only height and reach (`AttrGen.body`, `:152`).
- 35 boxers a division: `RANKED_PER_DIVISION 20 + UNRANKED_PER_DIVISION 15` (`:20-21, 87`); the entry point is
  `WorldGen.generate(seed)` (`:27`).

So today the eight pro tables can differ only through the number of rounds. The control arm of the probe needs one world
number per round count (6, 8, 10), not one per division. The amateur pools are different: `Data.DIVISION_RIVALS`
(`scripts/state/Data.gd:171-211`) are hand-written, and the men's rows are rated lower (53 to 62, one 69 or 70) than the
women's (58 to 65, one 70 to 72.5). An amateur division can read differently today because of WHO is in it, never because of
a rule. The probe must keep those two apart (section 5).

### 1.3 Classes

- Nine amateur divisions: women 57, 60, 65, 70, 75 kg; men 55, 60, 70, 75 kg (`Data.DIVISIONS`, `Data.gd:136-155`).
- Eight pro tables, featherweight to middleweight for each sex, upper limits 57.0 / 61.2 / 66.7 / 72.6 kg
  (`assets/data/world/divisions.json`). The file gives `pro_rounds` 10, and 12 for men's welter and middle; per the
  critic no bout code reads it.
- A signed boxer gets `div`, `sex` ("f" / "m") and `limit` once (`Data.fighter_state`, `Data.gd:254-270`, the write at
  `:260-261`). The pro table is worked out from sex and limit each time: at or under 57.5 feather, 62.0 light, 70.0 welter,
  else middle (`ProLadder.division_for`, `scripts/state/ProLadder.gd:43-49`).
- Player pro bouts are 4 / 6 / 8 / 10 rounds (`ProLadder.ROUNDS_*`, `ProLadder.gd:33-36`). Every round is six exchanges
  for everyone (`Exchanges.EXCHANGES := 6`, `Exchanges.gd:10`): a women's pro round is as long as a men's.
- No code moves a signed boxer to another class. The only writes to `limit` are `FirstHour.refuse`
  (`scripts/rules/FirstHour.gd:125`, the second walk-in), `SaveGame.gd:85` (old saves) and a goal's copy (`WeekData.gd:38`).

### 1.4 The towel and what a stoppage costs

- The towel's risk: `Towel.risk` (`scripts/rules/Towel.gd:23-64`) plays the next round 200 times
  (`TowelWire.TRIALS`, `TowelWire.gd:20`) through `round_counts` and `puncher_chance`. Its sides are passed in by
  `BoutNight._shout` (`BoutNight.gd:220`, `count_sides`); `TowelWire.state` adds the Slugger power itself (`TowelWire.gd:37`).
- The lines are fixed: careful 0.12, normal 0.20, brave 0.33 (`Towel.LINES`, `Towel.gd:11`), set on
  `FightPrep.towel_row` (`scripts/ui/FightPrep.gd:78-99`).
- The card does NOT come only at the line. `Towel.reasons` (`Towel.gd:89-101`) gives four reasons: a count in the round
  just gone, the head at or under 35 (`BodyMap.CRITICAL`; head = 100 - damage x 2.2, `TowelWire.gd:22, 54`), a closing eye,
  or the risk at the line. Only the coach's own pull is tied to the line alone (`Towel.coach_pulls`, `:110-112`). So v2's
  critic point "in a light class the card stops coming" is half right: the LINE stops mattering, the card still comes on a count.
- The three answers read Pull out / Box safe / One more round (`TowelStrip.ANSWERS`, `scripts/ui/TowelStrip.gd:8-10`).
- A pull: 14 days out, morale -4, loyalty +2 or -6 by band, no injury roll (`Towel.answer`, `Towel.gd:117-126`;
  `TowelWire.pull`, `TowelWire.gd:97-109`; `Injuries.after_bout` returns on "RTD", `scripts/state/Injuries.gd:181-182`).
- **F13 is fixed on main (S534).** `BoutFinish.run` wears the chin only when `stop != "" and stop != "RTD"`
  (`scripts/state/BoutFinish.gd:101-102`); `tests/towel_wire_test.gd:74` checks the cap does not move. A towel now keeps
  the 2.0 chin ceiling (`Attrs.STOP_DROP`, `Attrs.wear_stoppage`, `scripts/rules/Attrs.gd:42, 127-128`).
- Still true after the fix, and NOT decided here (for the main session): an "RTD" loss is treated as a stopped loss in five
  other places of `BoutFinish.run`: 2 members and 4 reputation (`:103, 105`; `BoutRules.gd:122-123`), the pro ladder is
  told it was stopped (`:110`, which adds the 8 rest weeks), the amateur lesson is cut as stopped (`:132`), loyalty takes
  "stopped" -3 on top of the towel's own loyalty move (`:178`; `Loyalty.gd:60`), and the knowledge read widens (`:180`).
- A referee stoppage loss: 30 / 90 / 365 days (`InjuryRoll.ko_days`, `scripts/rules/InjuryRoll.gd:12-16, 42-56`), chin ceiling
  -2, no stand-down (`StandDown.make` returns {} when stopped, `scripts/rules/StandDown.gd:27-29`), +8 pro weeks
  (`Matchmaking.next_weeks`, `scripts/rules/Matchmaking.gd:280-282`: base 6 / 8 / 12, `:30-33`), rating -0.8 (`STOP_COST`, `:48`).
- A distance bout: no sparring 5 / 10 / 21 days by head = 100 - damage x 0.8 (`StandDown.gd:7-10, 27-32`); an injury roll of
  `0.06 x rounds / 3 x (0.4 + 1.2 x worst place)` x a flexibility factor, capped 0.4 (`InjuryRoll.bout_chance`, `:29-39`).
- None of the rest, suspension, wear or injury functions reads sex or class.

### 1.5 Stoppage numbers the player sees today

| Screen | Code | What it shows |
| :--- | :--- | :--- |
| Pro row, the opponent | `ProFights._row`, `scripts/ui/ProFights.gd:173-178` | "Stopped N of the M beaten", red from 40%, amber from 20%: fixed lines. |
| Pro row, the loss column | `ProFights._row`, `:221-223` | "Stopped: N% chance; then out W weeks, and damage", red from 15%, amber from 7%: fixed lines. |
| Pro row, the coach's read | `ProFights._row :182-183` into `CoachRead.pro_read`, `scripts/rules/CoachRead.gd:166-181` | "a N% chance of being stopped" from 7% up: a fixed line. |
| The offer filter | `ProLadder.offer_axes`, `ProLadder.gd:220-228` | `stop` is one of the five numbers a row is judged on. |
| The number behind all three | `Matchmaking.stop_chance`, `Matchmaking.gd:272-275` | `(1 - win chance) x max(0.1, ko / w)`, 0.25 with no wins. Three call sites: `ProLadder.gd:228`, `ProFights.gd:183`, `ProFights.gd:221`. It decides no bout. |
| The ask card | `AskFlow.answers`, `scripts/state/AskFlow.gd:105-120` (the call at `:117`); printed by `AskPanel._answer`, `scripts/ui/AskPanel.gd:112-114` | "Getting stopped: unlikely / possible / a real risk." |
| The late-ask card | `LateAskWire.view`, `scripts/state/LateAskWire.gd:119-126` (the call at `:125`); printed at `scripts/ui/LateAskCard.gd:28` | The same word. |
| The word's rule | `StopWord.word(gap)`, `scripts/rules/StopWord.gd:20-25` | Under gap 0 unlikely, under 8 possible, else a real risk (`:15-16`), for chances of 8% and 20% (`:8-9`). One signature, two callers. Pure: no preload (pinned at `tests/stop_word_test.gd:106`). |
| The towel strip | `Towel.words`, `Towel.gd:139-143` | "Stopped next round: N in 100 (Box safe: M in 100). Your line: L." |
| The perk road | `FighterPage._tab`, `scripts/ui/areas/FighterPage.gd:108-111`, rows from `PerkRoad.status` | Iron chin needs durability 70, Finisher needs explosiveness 70 (`scripts/rules/PerkRoad.gd:10, 16`). No division word. |
| The signing card | `RecruitPanel.build`, `scripts/ui/RecruitPanel.gd:35-54`; used by the walk-in interview (`scripts/ui/modals/Interview.gd:64`) and the trial (`scripts/ui/modals/Trial.gd:29`) | The style's class word, potential stars, attributes, traits, perks. The weight class is one word in the trial's sub-line (`Trial.gd:24`). Nothing about stoppages. |
| The prospect card | `Fighters._scouting`, `scripts/ui/areas/Fighters.gd:181-232` (the line at `:212`) | Age, weight class word, style, the scout's note, scouted ranges (plus or minus 5, `Data.SCOUT_SPREAD`). |
| The turn-pro call | `scripts/ui/modals/ProOffer.gd` `build`, `:25-60` | Record, days left, declines left, tickets, the houses' terms. Nothing about stoppages. |

Measured today, from an existing probe (not run for this map): `docs/STOPWORD1_RESULT.md`, 960 real three-round bouts of the
test club's three boxers (seed 4421). Between level boxers (real gap -2.5 to 0, n 300) our boxer was stopped 5.3 in 100 and
the opponent 3.7 in 100: 9 in 100 bouts stopped, inside John's club band of 5 to 12. Stoppage kinds: 132 RSC, 15 KO (10% KO).
The chin moves it far more than the class does: the featherweight with chin 52 was stopped 10.0 and 11.7 in 100 against
level opponents, the lightweight with chin 66 was stopped 1.7 in 100 against one four points better. The men's welterweight
(chin 64) read like the women's lightweight at level gaps (1.7 to 8.3 in 100). Three boxers cannot show a class effect; the
code in 1.1 shows there is none in the rules.

### 1.6 v2's false claims, corrected

| # | v2 said | True today |
| :--- | :--- | :--- |
| F1 | `stop_chance` has two callers | Three: `ProLadder.offer_axes` (`ProLadder.gd:228`), `ProFights._row` twice (`:183` into the coach's read, `:221`). CODE. |
| F2 | The label is "Stoppage %d%%" | "Stopped: %d%% chance; then out %d weeks, and damage" (`ProFights.gd:222`), red 15 / amber 7. CODE. |
| F3 | `TowelWire.card` calls `count_sides` | The sides are passed in from `BoutNight._shout` (`BoutNight.gd:220`). CODE. |
| F4 | Second wind +18 | `SECOND_WIND := 10.0`, round 3 (`PerkFight.gd:14-15`). CODE. |
| F5 | Pro turnaround 6 / 8 / 10 weeks | 6 / 8 / 12 (`Matchmaking.gd:30-32`), +8 after a stopped loss (`:33`). CODE. |
| F6 | 45 boxers a division, `WorldGen.new().generate_world` | 35; `WorldGen.generate(seed)` (`WorldGen.gd:20-21, 27`). CODE. |
| F7 | A 4-round share "matching `rounds_for`" | `rounds_for` gives 10 / 8 / 6 (and 3 for an `a_` table that does not exist). Four rounds are the player's unranked bouts only. CODE. |
| F8 | Sides read `sex`, `div`, `limit` off any boxer | Four shapes, section 3.3. CODE. |
| F9 | The hurt state is entered at `Exchanges.gd:145-149` | CRITIC-CHECKED: `Exchanges.situation` and `Exchanges.next_mode`. v3 does not touch the hurt state, so the claim is cut. |
| F10 | An annual -2.0 chin drop for world boxers | `STOP_CHIN 2.0` x stoppage losses, once per loss (`AttrGen.age_wear`, `AttrGen.gd:67, 172-181`). CODE. |
| F11 | `CounterCut.cut` | CRITIC-CHECKED: `CounterCut.apply`, animation only. Cut from the map: it is not part of this mechanic. |
| F12 | Two signatures for `StopWord.word_for` | No such function exists. v3 gives one signature (section 3.5) and names both callers. |
| F13 | A towel skips the chin wear | It did not; it does since S534 (`BoutFinish.gd:101`). Fixed on main, tested. |
| - | Towel buttons "Throw the towel / Box safe / Send out" | Pull out / Box safe / One more round (`TowelStrip.gd:8-10`). CODE. |
| - | Only `WorldSim` and `Region` call `WorldBout.fast` | Also `Matchmaking.fight` (`Matchmaking.gd:206`). CODE. |
| - | Walk-ins at `FirstHour.gd:116-130`, prospects at `Roster.gd:113-125` | `FirstHour.walkin` (`:103`) and `refuse` (`:114`); `Roster.trial_read` (`:109`); the table is `Data.PROSPECTS` (`Data.gd:221-243`). CODE. |
| - | A stopped amateur loss teaches "0.0" | CRITIC-CHECKED: the base lesson minus 0.8, floored at 0 (`AskFlow.teach_after` floors it, `AskFlow.gd:180`, CODE). |
| - | `tools/stop_word_probe.gd` is 210 lines | CRITIC-CHECKED: 479 lines. |

Every line number of v2 is withdrawn. A build brief re-reads the function named here.

## 2. The real-world numbers, and what v2 got wrong about them

v2's section 1 gave sixteen ranges (women's amateur featherweight 1.0 to 2.5 in 100 up to men's pro middleweight 48 to 55) and
said they were "preserved from SQ257". They are not in that study. `ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md`
holds three bands per sex and ruleset, no per-division row, and different numbers (men's pro light 55, middle 68; women's pro
light 24, middle 30; men's amateur light 7, middle 11; women's amateur light 5, middle 6). The sixteen ranges are withdrawn.
The study's own header says "Verify the sources before using it", and several of its sources cannot be opened as cited
("unpublished aggregated summaries", "Boxingweightclasses.org", "The Fight Algorithm").

What we have, ranked by how far it can be trusted:

| Fact | Number | Source | Status |
| :--- | :--- | :--- | :--- |
| Women's amateur, world championships 2018 to 2023 | 4.4 to 11.4 in 100 bouts stopped (1,036 bouts) | John, `ops/research/J_KDRATES1_JOHN.md`, counted from Olympedia and Wikipedia brackets | COUNTED (by a seat; not checked against the official results books) |
| Women's amateur, four Olympics | 4 of 278 = 1.4 in 100 | same | COUNTED |
| Women's amateur BY WEIGHT, the same championships | up to 54 kg 10.6 (51 of 479); 57 to 70 kg 9.5 (54 of 569); middleweight and up 11.2 (22 of 196) | same, his section 5: "There's no real difference" | COUNTED |
| Women's pro | 29 in 100 end by KO or TKO (5 KO, 24 TKO), 14,555 bouts, BoxRec 2014 to 2024 | AAN 2025 abstract, https://www.aan.com/msa/Public/Events/AbstractDetails/58398 (via John) | COUNTED |
| Men's pro | 47 in 100, same abstract; the project's own topic page says the same ("boxing ~47% KO/TKO in BoxRec's modern census", `ops/research/topics/knockdowns_stoppage.md`, study G108) | same | COUNTED |
| Women against men per minute fought | about 0.83; "nearly equal" | John, same file | COUNTED (rough) |
| Men's Olympic amateur, all early endings | 17.3 in 100 before headguards, 21.8 after 1984 | BJSM 2013, https://bjsm.bmj.com/content/47/7/452 (via John) | COUNTED, but an old era and elite brackets |
| Counted bouts per stopped bout | 2 to 4 | John: "my assumption, not data" | GUESS (the code is tuned to it, `Knockdowns.gd:2-4`) |
| Men's amateur by weight | light 6 to 9, middle 9 to 13, heavy 14 to 18 | Dola SQ257 | UNVERIFIED |
| Men's pro by weight | light 55, middle 68, heavy 75 | Dola SQ257 | UNVERIFIED, and its level contradicts the counted 47: it reads like ranked and title bouts |
| Women's pro by weight | light 22 to 28, middle 28 to 34 | Dola SQ257 | UNVERIFIED |

What the evidence supports, in plain words:

1. **The ruleset is the big step.** Amateur about 5 to 12 in 100, pro about 29 (women) and 47 (men). Turning pro multiplies the
   chance of an early ending by three to six.
2. **Sex is the second step, and in the pro game it is mostly round length.** Women's pro rounds are two minutes; per minute
   fought the sexes are nearly equal. The game gives everyone the same six exchanges a round (`Exchanges.gd:10`), so the
   women's pro cell has to carry that as a factor. Saying so is honest; a hidden "women hit softer" number would not be.
3. **Weight is the smallest step inside the game's range.** The game spans 55 to 75 kg. Counted women's amateur data shows no
   slope at all. The unverified men's rows suggest middle is 1.2 to 1.4 times light. v2's fiftyfold spread from the lightest
   cell to the heaviest was not in any source.

This changes the design. A division read that told the player "featherweights never get stopped" would be false. The honest
decision is: which sex and class you sign, how THIS boxer's chin sits in that field, and above all when you turn pro.

## 3. The dial

### 3.1 One number per cell

A new pure file `scripts/rules/ClassDamage.gd` (TO BUILD; no preload, no career). A cell is (sex, ruleset, limit in kg). It gives
one fitted number, `count_mult`: how often a clean shot puts a boxer on a count in this cell.

- Read in `Knockdowns.round_counts` at the count chance (`Knockdowns.gd:34`) and in `Knockdowns.puncher_chance` at its
  count chance (`:128`), from the PUNCHER's side: `float(winner_side.get("count_mult", 1.0))`. It multiplies before the
  0.85 and 0.5 caps, so the caps stay where they are.
- A missing key is 1.0: `tests/knockdowns_test.gd` (raw sides, band [0.03, 0.12] at `:49`) and `tests/stop_mult_test.gd` do not move.
- `stop_mult` stays the perk's alone (Finisher). The referee's roll, the KO rule, the count limits, the damage table and
  both hurt rolls are NOT touched.

Why one number and why there (the critic's problems 2, 3 and 4):
- Stoppages are gated behind counts (`Knockdowns.gd:53`), so the stopped share follows the count chance almost in
  proportion. One number per cell is fitted to one sourced target per cell. Nothing is under-determined.
- The count-to-stoppage ratio (John's 2 to 4, a guess the code is already tuned to) is kept without a second knob.
- The watched bout and the world bout get the same multiplier at the same line. The live damage adders (section 1.1) are
  not scaled, so they differ between the two paths exactly as they do today; the probe's control arm shows by how much.
- Not scaling the hurt roll removes the "inside or outside the clamp" question.
- Not scaling damage means the stand-down, the head place, the injury roll and the towel's head reason are untouched. "The
  same price in every division; it just happens more or less often" becomes true in effect, not only in the code.
- The price: the KO share of stoppages is an output, not a dial. The one counted number is women's pro, 5 KO in 29 stopped
  (17%). The probe reports the share per cell. If it sits far outside 8 to 30 in the pro cells, a later version argues for a
  second number with that evidence in hand.

### 3.2 Seven fitted numbers, each with its target

`count_mult = anchor[sex][ruleset] x (1 + slope[sex][ruleset] x (limit - 62) / 13)` (62 kg is the middle of the game's range,
13 kg the distance from there to the 75 kg top; ESTIMATE of the form, the probe may show a flat slope everywhere).

| Number | Target (per 100 bouts between level boxers unless said) | Evidence | Value today |
| :--- | :--- | :--- | :--- |
| Anchor, women's amateur | 5 to 12 stopped | John, COUNTED; the code is tuned to it and STOPWORD1 measured 9 | **1.00 by definition: the control cell** |
| Anchor, men's amateur | 6 to 16 stopped | UNVERIFIED (Dola's light and middle rows) plus the old Olympic 17 to 22; a John brief must check it before the fit | ESTIMATE 1.2 to 1.6 |
| Anchor, women's pro | 22 to 34 over the world's season mix | AAN 2025, COUNTED (29) | fitted: target middle / control measurement |
| Anchor, men's pro | 40 to 54 over the world's season mix | AAN 2025 and G108, COUNTED (47) | fitted the same way |
| Slope, women's amateur | none: the three weight rows within 3 points of each other | John, COUNTED (10.6 / 9.5 / 11.2) | **0** |
| Slope, men (amateur and pro share one) | middle 1.0 to 1.4 times feather | UNVERIFIED | ESTIMATE 0.15 |
| Slope, women's pro | middle 1.0 to 1.4 times feather | UNVERIFIED | ESTIMATE 0.10 |

Club against elite (the critic's problem 7): the amateur anchors follow the CLUB band, which is what the code is tuned to and
what the game's bouts are. No separate elite cell. The difference between a club show and the Olympics is who is matched, and
the count chance already reads that through power against chin. The probe prints championship bouts as their own row.

### 3.3 One lookup, four shapes

| Shape | What it carries today (CODE) | How the cell is found |
| :--- | :--- | :--- |
| A signed boxer | `sex` "f" / "m", `div` = the amateur id for life, `limit` in kg, `pro` (`Data.gd:260-264`); the bout says `bout.pro` (`BoutFinish.gd:61`) | sex, limit, `bout.pro` |
| A world boxer | `sex` "women" / "men", `div` "w_lw" and so on, no `limit` (`WorldGen.gd:155-185`) | the division id: sex from its row, limit = the row's `max_kg`, pro always |
| An amateur rival | `div` = the amateur id, no `sex`, no `limit` (`Data.DIVISION_RIVALS`, `Data.gd:171-211`) | the amateur id through `Data.DIVISIONS`: sex and limit; pro false |
| A bout opponent, and the player's ladder entry | `ProLadder.bout_opp` copies OUR boxer's amateur id into `div` and sets `pro: true`, no sex, no limit (`ProLadder.gd:253-261`); the ladder entry has no sex, div or limit at all (`Matchmaking.join`, `Matchmaking.gd:67-70`) | not from itself: see the rule below |

The rule that makes this safe: **a bout has one cell, taken once, and both sides get it.** The owner's rulings guarantee it:
females never fight males, and booking matches the weight class. So:
- `BoutNight.count_sides(f, opp)`: the cell comes from OUR boxer `f` (sex, limit, `f.bout.pro`). The opponent dict is never asked.
- `WorldBout` (`fight :127`, `cached :186`, `fast :211`): `ClassDamage.cell_of_pair(x, y)` takes the first of the two that
  resolves. That covers `Matchmaking.fight`, where `p` is the keyless ladder entry and `opp` is a world boxer.
- There is no silent 1.0. `cell_of_pair` returns an empty cell when neither side resolves, and `tests/class_damage_test.gd`
  (TO BUILD) feeds all four shapes through the three real call paths and fails on an empty cell or on two sides that resolve to
  different cells.
- `WorldBout.cached` stores the sides (`:185-186`) under a key of id, name, shape, age and rounds (`_key`, `:193-202`). A
  boxer's class never changes, so the cache stays right in the game. The probe changes factors between arms and must empty
  `WorldBout._cache` (`:33`) each time.

### 3.4 What reaches everything else for free

Once `count_sides` carries the number: the round's counts (`BoutNight._counts`), the towel's risk (`Towel.risk` through
`BoutNight._shout`), and, CRITIC-CHECKED, the plan test and the fix lab (they play `BoutNight.play_out`, `BoutNight.gd:102`).
Once `WorldBout` carries it: the world's records (`ko` over wins), rival bouts, the simulated pro bout.

### 3.5 Shown numbers that need a hand

- `StopWord.word(gap: float, shift: float = 0.0)`: ONE signature. The word is read at `gap + shift`. Both callers
  (`AskFlow.answers`, `LateAskWire.view`) pass `ClassDamage.gap_shift(cell)` = `12 x ln(count_mult)` rating points: the count
  chance grows by e every 12 points of power over chin (`Knockdowns.POWER_CHIN_SCALE`, `Knockdowns.gd:11`), so a factor is worth
  that many points. ESTIMATE: the probe checks that each word's measured chance sits in its band in every amateur cell.
  `StopWord.gd` stays pure; today's one-argument calls and its test do not change. Women's amateur shift is 0.
- `Matchmaking.stop_chance`: the 0.25 for an opponent with no wins and the 0.1 floor become the cell's own stoppage share of
  wins (`ClassDamage.ko_share(cell)`, measured by the probe on the world arm) and 0.4 of it.
- `WorldGen._make_boxer` (`:150`): the 0.3 centre of a starting record's KO share becomes the same `ko_share(cell)`, so a
  day-one record agrees with what the world then produces.
- The three fixed colour lines (`ProFights._row` 40 / 20 and 15 / 7, `CoachRead.pro_read` 7) become relative to the cell:
  amber from the cell's usual, red from twice it (the stopped chance) or one and a half times it (the opponent's stopped
  share). ESTIMATE; the probe bound is that 5 to 35 in 100 offer rows are red in every pro cell. A colour that never changes
  is noise.

## 4. The class as a decision: the critic's list, one by one

### 4.1 "To reach 10/10"

| # | The critic asked | Answer | How, and which number it moves |
| :--- | :--- | :--- | :--- |
| 1 | A THIS DIVISION row at signing | **Take** | One row in `RecruitPanel.build`, so the walk-in interview and the trial both get it, and one short line on the prospect card (`Fighters._scouting`). Three facts: "Stopped early here: about N in 100 amateur bouts, M in 100 as a pro" (the cell's two measured rates); "Chin 52 against this field's punch 61" (the boxer's `RingDuel.side` chin against the mean punch of the division's pool); the read: **protect early** (chin 6 or more under the field's punch), **can be moved fast** (6 or more over), **a puncher here** (own punch 6 or more over the field's chin). Six points is half of the 12-point scale: 1.65 times the count chance (ESTIMATE). For a scouted prospect the chin is a range of plus or minus 5, so the read can say "protect early, or fine: the trial tells". It moves whom the player signs, and which starting focus is picked on the same card. |
| 1b | (added) The same row on the turn-pro call | **Take** | `ProOffer.build` gets one line: "As a pro here about M in 100 end early; as an amateur N." plus the chin read against the PRO field. This is the largest real step in the evidence (section 2) and the buttons already exist: sign, or Stay amateur with declines left. It moves when a thin-chinned boxer turns pro. |
| 2 | Run the baseline probe before the next map | **Take, as the next task, not in this file** | This task may not run Godot. Section 5 is the probe. Three cells are already measured (section 1.5). v4 replaces every ESTIMATE here with the probe's number. |
| 3 | Decide club against elite | **Take: club** | Section 3.2. Women's amateur `count_mult` is 1.00, so the first walk-in's bouts keep their towel card and their 9 in 100. |
| 4 | Keep the towel a choice in every division | **Take the second form** | The lines stay 12 / 20 / 33: a corner judges absolute danger, and section 2 shows the amateur cells are close together, so the collapse the critic feared is an amateur-against-pro matter. `FightPrep.towel_row` adds to each button "the card comes about 1 fight in N here" (the probe's measured share for that cell and line). `Towel.words` adds "A usual round here: U in 100." Test: in every cell the three lines bring the card on shares at least 3 points apart; a cell that fails gets its own lines at 0.6 / 1.0 / 1.6 of its usual, and only that cell. |
| 5 | Two knobs, not three; state the clamp; scale the live adders or prove parity | **Take, further: one knob** | Section 3.1. No clamp is touched. Parity is a probe bound: the watched path and the world path within 5 points in the same cell. |
| 6 | One `cell_of` for three shapes, a test that fails on a fallback | **Take** | Section 3.3: four shapes, one cell per bout, no silent 1.0. The ladder entry carries no sex, div or limit (`Matchmaking.gd:67-70`); the pair rule covers it. |
| 7 | Fix every shown number; wire `LateAskWire`; one `word_for` | **Take** | Section 3.5. |
| 8 | Say it in the Why | **Take** | One sentence pushed into the bout's reasons in `BoutFinish.run` (it already pushes lines to the front of `why`, `BoutFinish.gd:75-82`) when the bout was stopped or a towel came in: "Stopped in round 4. Bouts here end early about N in 100; tonight the punch was 12 points over the chin." Roles, not names ("your boxer", "the opponent"). `FightWhy._count_line` already stays silent on a stopped bout (`scripts/rules/FightWhy.gd:259-263`), so nothing is said twice. Not added after a distance bout: nothing to act on. |
| 9 | Chin's worth on the week board and the perk road | **Take the perk road; refuse the week board** | Perk road (`FighterPage._tab`): Iron chin and Finisher get a tail from the cell, "a count comes about 1 bout in N here". It moves which perk the mornings train toward. The week board has no chin row today (no "chin" or "durability" in `scripts/ui/WeekBoard.gd`); adding one is a new screen element. The camp line of 4.2 item 3 does that job where the camp is chosen. |
| 10 | Name the follow-up: moving a class | **Take** | Section 4.3. |
| 11 | Correct F1 to F13, strip line numbers, F13 first | **Take** | Section 1.6. F13 is fixed on main. The members, loyalty, lesson and ladder treatment of a towel (section 1.4) is listed for the main session, not decided here. |

### 4.2 The five missing options

| # | Option | Answer |
| :--- | :--- | :--- |
| 1 | A division read at signing | Taken: 4.1 rows 1 and 1b. |
| 2 | A division line on the towel row | Taken: 4.1 row 4. |
| 3 | A style read that names the division | **Take**, on the camp card of fight prep (`FightPrep._camp_card`, `FightPrep.gd:190`; body not opened for this map): "Chin 58 against this opponent's punch 66. Four more chin this camp: about X fewer stoppages in 100 here." X = the ask card's chance for this gap in this cell times 0.28 (four points of chin cut the count chance by 28%: exp(-4 / 12), `Knockdowns.gd:11, 34`). It moves what the camp trains. |
| 4 | Moving up or down a class | Named as the follow-up: 4.3. |
| 5 | The Why after the fight | Taken: 4.1 row 8. |

### 4.3 The follow-up this mechanic exists to price: moving a class

Not built by this map; it gets its own (MOVECLASS1). What is already there: a boxer has a walking `weight` and a `limit`
(`Data.PROSPECTS`: 58.3 kg against 57, 65.9 against 65), each sex has a ladder of limits (`Data.DIVISIONS`), and the pro table
is picked from the limit at 57.5 / 62 / 70 (`ProLadder.division_for`). So the natural moment is the turn-pro call: a 60 kg
amateur is a pro lightweight by default and could be offered welterweight.
- Up a class: an easier weight week, a bigger field. The boxer's punch and chin are read against a heavier pool, and the cell's
  `count_mult` is the next one up. Good for a boxer who is "a puncher here" by a wide margin, bad for "protect early".
- Down a class: a hard cut before every bout, a smaller field. Punch reads better, the tank reads worse on the night.
- What the move would need that no code has: the ladder place and points in the new division, a new rival pool, what the record
  is worth there, and a real-world number for how punch and chin change with a 5 kg step (UNVERIFIED today; v2 named papers
  that are not in the study it cited).
- Where the button would live: the turn-pro call and the fighter page beside the weight line.

### 4.4 The critic's "useless or harmful as written"

- `class_stop` as a third number: gone, and `punch_mult` with it.
- The 4-round share "matching `rounds_for`": gone. The world arm uses 6 / 8 / 10 as `rounds_for` gives them; 4 rounds are
  measured on the player path only.
- Fixed colour lines: made relative (section 3.5).

## 5. The probe that sizes the numbers (before any board)

`tools/dmg_class_probe.gd` (TO BUILD; it does not exist). Base: the player-bout loop of `tools/stop_word_probe.gd`
(CRITIC-CHECKED: its `_fight` plays `Bouts.fight_step` to the end and restores the pool) plus direct `WorldBout.fast` calls.
It writes `docs/DMGCLASS1_BASELINE.md`. It runs headless through the Godot slot, never in a design session.

**Arms.**
1. CONTROL: today's rules (every `count_mult` 1.0). Same build, same seeds. It cannot share the new code's bugs because the
   new key is absent.
2. FIT: the seven numbers of section 3.2.
3. MUTANT: FIT with one cell's number doubled. That cell's bound must FAIL. A probe that cannot read worse proves nothing.
The control is expected to FAIL the sex separation in the pro cells (today nothing can separate them). If the control passes
every bound, the instrument is blind and the run is void.

**Populations**, each named with its catalogue in the output:
- P1, made pairs: two different `AttrGen.generate` profiles (different seeds, never the same archetype twice in a pair: no
  identical fighters), set at rating gaps -8, -4, 0, +4, +8. This separates the RULE from who happens to be in a pool.
- P2, the real pools: the amateur rivals of each division as the career holds them (4 to 11 names: the n is printed, a small
  pool is reported as small, never padded with repeats), and `WorldGen.generate(seed)`'s 35 boxers per pro table.
- Only legal bouts: one sex, one division per bout.

**Paths.** `WorldBout.fast` at 3 rounds (as `Region._rival_bout`), at 6 / 8 / 10 as `WorldSim.rounds_for` picks them, and at 6
(as `Matchmaking.fight`). The player bout at 3 rounds (amateur) and 4 / 6 / 8 / 10 (pro), once with the towel line normal and
once with the corner never pulling, so referee stoppages are not hidden behind towels. `WorldBout._cache` is emptied between arms.

**Printed per row:** population, catalogue, cell, path, rounds, n, bouts with a count, stopped, RSC / KO / RTD split, our boxer
stopped, mean head damage, liver share of counts, towel card share at careful / normal / brave, the bound, PASS or FAIL.

**Bounds** (ranges, never an exact count):

| Bound | Range | From |
| :--- | :--- | :--- |
| Women's amateur, level pairs, stopped | 5 to 12 in 100, in both arms | John, COUNTED; today's test band |
| Women's amateur, three weight rows | within 3 points of each other | John, COUNTED |
| Men's amateur, level pairs, stopped | 6 to 16 in 100; middle not under light | UNVERIFIED: a John brief first |
| Women's pro, the world's season mix | 22 to 34 in 100 | AAN 2025 |
| Men's pro, the same | 40 to 54 in 100; never under the women's row of the same class | AAN 2025, G108 |
| Women's over men's, pro | 0.50 to 0.75 | 29 / 47 = 0.62 |
| Middle over feather, per sex, pro | 1.0 to 1.4 | UNVERIFIED |
| KO share of stoppages, pro cells | reported; 8 to 30 expected | women's pro 5 of 29 |
| Counted bouts per stopped bout | reported, not a gate | John's own guess |
| Liver share of counts | 10 to 20 in 100, and within 3 points of the control | `docs/LIVERPROBE1_RESULT.md` |
| Watched path against world path, same cell | within 5 points | the critic's problem 3 |
| Towel card share, the three lines, each cell | pairwise at least 3 points apart; on normal between 5 and 60 in 100 bouts | section 4.1 row 4 |
| Ask-card word, each amateur cell | each word's measured chance inside its band (under 8, 8 to 20, over 20) | `StopWord.gd:8-9` |
| Red offer rows, each pro cell | 5 to 35 in 100 | section 3.5 |
| The same seed twice | the same table | the only seed reuse |

**The fit rule.** One number per anchor: target middle divided by the control's measurement, rerun, at most three rounds. A
slope is set only where the made pairs show the bound failing without it. No per-division hand numbers.

**What the control alone already decides.** If today's pro bouts sit near 29 to 47 through rounds alone, the pro anchors are near
1 and the mechanic is mostly the reads of section 4. If they sit far off, the anchors do real work. Either result is an answer.

**Before the fit, one research task:** a John brief to check the men's amateur rates and the by-weight slopes against sources
that can be opened (England Boxing championship results, BoxRec by division). Until then those three numbers stay UNVERIFIED
and their bounds stay wide.

## 6. Every menu the mechanic appears on

| Menu | CODE TODAY | TO BUILD | Wired to |
| :--- | :--- | :--- | :--- |
| Fight night: counts and the referee | `BoutNight.count_sides` sets only the perk's `stop_mult`; `Knockdowns` reads no class | `count_sides` adds `count_mult` from OUR boxer's cell to both sides; `Knockdowns` multiplies the two count chances | `ClassDamage.cell_of` |
| The world, rival bouts, the simulated pro bout | `WorldBout._side` = power, chin, heart | The three places that build sides add the pair's cell | `ClassDamage.cell_of_pair` |
| Reception: the walk-in interview | `Interview.build` shows `RecruitPanel`; no stoppage word | THIS DIVISION row: two rates, chin against the field, the read | `ClassDamage.usual(cell)`, the division pool's mean punch |
| Find a fighter: the prospect card | Age, class word, style, note, scouted ranges | One line: the read as a range | the same, with the scouted plus or minus 5 |
| The trial | `Trial.build` shows `RecruitPanel` | The same THIS DIVISION row, exact after the trial | the same |
| The turn-pro call | Record, days, declines, tickets, terms | "As a pro here about M in 100 end early; as an amateur N" and the chin read against the pro field | `usual` of the amateur and the pro cell |
| Amateur ask card and late-ask card | `StopWord.word(gap)`, the same in every division | Both callers pass the cell's shift | `ClassDamage.gap_shift` |
| Pro fights: the offer rows | Three fixed colour lines; `stop_chance` with 0.25 and 0.1 | Colours relative to the cell; the two fallbacks from the cell | `usual`, `ko_share` |
| A new world's records | KO share centred on 0.3 everywhere | Centred on the cell's `ko_share` | `ko_share` |
| Fight prep: the towel row | "Careful (12 in 100)" and so on, fixed | Each button adds "the card comes about 1 fight in N here" | the probe's per-cell table in `ClassDamage` |
| The corner: the towel strip | "Stopped next round: N in 100 (Box safe: M in 100). Your line: L." | Adds "A usual round here: U in 100." The risk itself moves by itself through the sides | `Towel.risk` (already wired), `usual` |
| Fight prep: the camp card | No stoppage line | "Chin against this opponent's punch; four more chin = about X fewer stoppages in 100 here" | the ask card's chance for the gap, the cell |
| The plan test and the fix lab | Play the real bout | Nothing: they read the new sides by themselves | `count_sides` |
| The fighter page: the perk road | Iron chin and Finisher with fixed words | A tail on those two rows: "a count comes about 1 bout in N here" | the probe's count share per cell |
| The result page: the Why | No sentence about the division | One sentence after a stoppage or a towel | the cell's `usual`, the night's punch over chin |
| Rest, stand-down, injuries, wear | No class anywhere | **Nothing.** Damage is not scaled, so nothing reaches them | - |
| The week board | No chin row | **Nothing** (refused, 4.1 row 9) | - |
| A weight-class switch | Does not exist | **Nothing here**: the follow-up map (4.3) | - |

Owner rulings kept: females never fight males and booking matches the weight class (the one-cell-per-bout rule depends on
both, and the probe books only legal bouts); names only in headers (every new line says "your boxer", "the opponent", "here");
only actionable information (each new line sits beside the button it informs: sign or pass, turn pro or stay, the towel line,
the camp, the perk; nothing is added after a distance bout or on the rest screens); a real-world source for every number, and
where the source has not been opened the number is marked UNVERIFIED and held behind a research task.

## 7. Order of work

1. DMGPROBE1: build the probe, run the control arm, commit `docs/DMGCLASS1_BASELINE.md`. In parallel, the John brief on the men's
   amateur rates and the weight slopes.
2. Map v4: this file with the ESTIMATEs replaced by the control's numbers, then two fresh critics. The board only at 7 or more.
3. DMGCLASS1: `ClassDamage.gd`, the two lines in `Knockdowns`, `count_sides`, `WorldBout`, the lookup test, the fit arm.
4. DMGREAD1: the shown numbers of section 3.5.
5. DMGSIGN1: the THIS DIVISION row (interview, prospect card, trial, turn-pro call), the towel row, the camp line, the perk
   road, the Why. One golden-path test walks them.

## 8. Files opened for this map

`scripts/rules`: Knockdowns.gd, Towel.gd, StopWord.gd, StandDown.gd (whole); Attrs.gd, AttrGen.gd, InjuryRoll.gd, Matchmaking.gd,
PerkFight.gd, PerkRoad.gd, CoachRead.gd, FightWhy.gd, FirstHour.gd, Exchanges.gd, Adaptation.gd, Loyalty.gd, BoutRules.gd (the
functions and constants cited).
`scripts/state`: TowelWire.gd (whole); BoutFinish.gd (30-239), BoutNight.gd (196-300), Data.gd (128-270), Injuries.gd (165-220),
RingDuel.gd, ProLadder.gd, AskFlow.gd, LateAskWire.gd, Region.gd, Roster.gd, LiveRound.gd (306-360, working copy).
`scripts/world`: WorldBout.gd (32-48, 85-100, 116-243, 322-328), WorldSim.gd (136-195), WorldGen.gd, WorldAge.gd (117-123).
`scripts/ui`: TowelStrip.gd (whole); ProFights.gd (168-228), FightPrep.gd (74-100), RecruitPanel.gd (33-56), modals/Trial.gd,
modals/ProOffer.gd (1-60); by search: modals/Interview.gd, areas/Fighters.gd, areas/FighterPage.gd, AskPanel.gd, LateAskCard.gd,
OfferCard.gd, WeekBoard.gd.
Other: assets/data/world/divisions.json, tests/knockdowns_test.gd (36-52), tests/bout_stoppage_test.gd, tests/towel_wire_test.gd
(by search), docs/STOPWORD1_RESULT.md, docs/LIVERPROBE1_RESULT.md, ops/research/J_KDRATES1_JOHN.md,
ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md, ops/research/topics/knockdowns_stoppage.md.
Not opened (their claims above are marked CRITIC-CHECKED or left out): LiverFold.gd, CrackWire.gd, CounterCut.gd, FightLearn.gd,
PlanTest.gd, FixLab.gd, PullOutWire.gd, BoutCompare.gd, Duels.gd, the bodies of FightPrep._camp_card and BoutRules.why,
tools/stop_word_probe.gd beyond its header. No real-world source was opened on the web for this map: the COUNTED rows are a
seat's counts with their links, to be checked before a number ships.
