# GUARDDMG1_V6 - score this mechanic's DESIGN (S459 design loop)

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

# GUARDDMG1 V6 - guard damage: covering must change who wins the exchange (S534, Fable console, from the code)

Brief: `ops/research/TASK_GUARDREV6.md`. Follows the verdict of `DESIGN_GUARDDMG1_V5_CRITIC_KALLI_KALLI.md` (Depth 6 /
General design 7 / Play 5): "every v5 rule acts after the exchange is settled". That is a METHOD finding, so v6 changes
the method (where the guard enters the fight), not the numbers.
Tags: **CODE** = I opened the file and the line is true on 2026-11-21 (working tree on main at 48f290a26). **DERIVED** = my
sums from CODE numbers, not measured. **ESTIMATE** = a number to tune, not in the game. **V5** = taken from the v5 map's
own CODE table and not re-opened this session. **CUT** = not in v6. No Godot was run. Files opened: section 8.
`scripts/state/LiveRound.gd` has another session's 2 uncommitted lines (245-246, StepWire.ride); line numbers below are the
working tree's. The committed file is 2 lower from line 245 on.

## 0. The short version
- Today the guard is counted AFTER the 30 seconds are decided. It changes knockdown odds and figures. It never changes
  who wins a round, because rounds are exchanges won and nothing from the guard is in the exchange's sum (1.2, 1.3).
- v6 adds one standing setting, **Hands: High / Normal / Loose**, beside Pace and Aim. It adds points to the same sum
  the corner call, the pace and the plan already feed, BEFORE `Exchanges.settle` (section 2).
- Covering now loses rounds against a boxer who boxes at range or is tiring, wins them against one who loads up, and
  tires a presser who keeps punching the guard. Loose hands win rounds against a tired or hurt opponent and get your
  boxer hurt against a counter-puncher.
- A worn guard also costs points in the exchange (the `GUARD_EDGE` the code says is "NOT YET", `GuardState.gd` line 10).
- All three stale screen lines v5 found are already fixed in the code (1.6). Nothing of section 2 is built.

## 1. What the game does today (CODE)

### 1.1 How 30 seconds are decided
- A round is six exchanges (`Exchanges.EXCHANGES` 10). `LiveRound.exchange` builds one number `d`, "her edge in power
  points", then calls `Exchanges.settle(d, roll_a, roll_b)` at **LiveRound 287**.
- `Exchanges.settle` (356-361): margin = d + two dice of +/-33 each (`EX_SPREAD` 66, line 14). Margin 0 or more = your
  boxer won the exchange. The size of the margin picks the landed punches: 4-3, 5-2 or 6-1 (`LANDED` 345, `band` 349-351).
- The round: most exchanges won; 3-3 goes to the bigger total margin (`Exchanges.round_of` 366-379, called by
  `LiveRound.close` 408). The cards: 10-9 a round won (`BoutRules.cards_of` 402-412). The three judges who count
  clean punches and work rate are drawn but do NOT decide (`JudgeNight.DECIDES` false, line 16).
- So today the ONLY way to win a round is to push `d` up. Landed punches decide nothing on the cards.
- DERIVED from `settle` (the same sum `Exchanges.win_shift` 215-223 uses): from an even exchange, +3 points wins 4 more
  exchanges in 100, +5 wins 7, +8 wins 11, +17 (a best corner call done well) wins 22.

### 1.2 Everything that feeds d BEFORE settle (LiveRound 212-283)
| Line | Term | Guard in it? |
|---|---|---|
| 212 | the round's base (`lv["base"]`: the strength gap and energy), the corner call (`Exchanges.call_edge` 255-265), stiff jab perk, an unfixed habit | The call "Hands up, move your head" is here: +17 x how well your boxer does it when the opponent loads up, +5 when your boxer is tired or hurt, 0 in every other game (`MODES` 126-133, `EDGE` 18). It is graded on Defence and head movement (`CALLS` 79; `Attrs` 264-266). |
| 214, 221 | the corner's talk, a fired set-up | no |
| 222 | pace and aim (`PaceAim.edge` 26-41: Push +6, Save -4, a named aim -1.5), push on an empty tank, a cold start | no |
| 233 | the read (counter) | no |
| 265 | the plan's line, the round's reads, the plan's pressure, the pro read | no |
| 267 | camp weeks spent on the opponent's game | no |
| 268 | `CrackWire.guard_edge` (68-74): a cracked rib "guards worse" | a rib rule, not the guard number |
| 275 | the clinch's price | no |
| 279-283 | the place duel, style levers, the step's opening and deny | no |
**Nothing from `GuardState` or `GuardWear` is in this sum.** Kalli's finding is true, with one correction: the call
"Hands up" already moves who wins, but only as a right answer to "Loading up". In the other five games it costs
nothing (edge 0, energy 0: `CALLS` 79) and still earns +5 guard at the corner (1.4). A free cover.

### 1.3 Every guard rule, and where it runs: all AFTER settle
| Line (LiveRound) | Rule | Changes |
|---|---|---|
| 288 | `StepWire.levers` (158-190): a planned step denies some of the opponent's punches, a wrong step lets more in, a step can drain the opponent (`lv["opp_drain"]` 184) | `s["landed"][1]`, the opponent's energy (`RingDuel.opp_energy` 332-335) |
| 297 | pace output: Push x1.25, Save x0.75 (`PaceAim.PACE_OUTPUT` 13) | `s["landed"][0]` |
| 300-304 | hurt ribs / a cracked side land less | `s["landed"]` |
| 307-313 | Counter sense perk: +1 landed, margin up, damage | landed, margin (not `won`) |
| 318 | **ONE CHANGE "Gloves high" / "Elbows in"** (`Adaptation.body_shots` 80-90): moves some of the opponent's landed punches between head and body for one round, 2.0 head damage each (`HEAD_DAMAGE` 24) | where punches land. Its own header says "not who wins" (`Adaptation.gd` 5) |
| 325-334 | punches taken in a tie-up (`ClinchRest`) | landed, damage |
| 354 | **`GuardState.after`** (93-135): blocks, wear, recovery, the tie-up's +10, the Hands up flag | the two guards |
| 355-359 | **the leak** (`GuardState.wear_through` 65-81) | `m["damage"]` |
| 389 | `RingDuel.settle` (356-397): energy, who is hurt (from the margin, 383-386), the opponent's next game | the next exchange |
`m["damage"]` is read only by the knockdown rule after the round (`BoutNight._counts` 254 -> `Knockdowns.round_counts` 20-74).

### 1.4 The guard number itself
- Each side has `{g, max, clinch, hands_next}` (`GuardState.open` 37-49). Full: light 80, middle 100, heavy 120, any
  amateur 70 (`GuardWear.max_guard` 268-275).
- Blocks are worked out from the other side's landed count: thrown = landed / 0.33 (`BoutBurn.LAND_RATE` 8); 60 in 100
  of the punches that did not land were blocked (`GuardState.BLOCK_SHARE` 16, `blocked_of` 53-55). The same 60 for every
  boxer: Defence is not in it. No choice of the player changes it.
- A block costs 1 / 3 / 5 guard points by punch kind (`GuardWear.wear` 127-160), the mix is fixed (`BoutBurn.MIX` 9: jab
  50, cross 25, lead hook 13, body hook 6, uppercut 6), then x0.40 pro / x0.28 amateur (`GuardState` 17-18).
  Passed in today: ropes +12%, amateur +15%, shoulder endurance, the "slow starter" habit (`GuardState.after` 100-111).
  In `wear` and passed by nobody: **moving -5%, high posture +8%**, condition, missed weight (138-150).
- The leak: jab 25%, power 42.5%, heavy 55% of a blocked punch at a full guard, doubling on a slope to an empty one
  (`GuardWear.transmission` 100-117), x the punch's worth x 0.038 (`GuardState` 19-20, 78-81).
  The opponent's power is in neither the wear nor the leak.
- Back in the round: +3 (amateur +4) only when the other side threw nothing (`GuardWear.in_round` 219-224).
  DERIVED: `settle` always gives the loser at least 1 landed = 4 thrown, so this fires only when a step's deny or a
  rib rule cuts a side's landed to 0. The "+1 for 1-2 thrown" branch cannot happen.
- The corner: +15 a minute, +5 more if "Hands up" was called in the round (`GuardWear.corner` 241-257,
  `GuardState.open` 45-46, `after` 132-133). The tie-up: +10 once a round under half guard (`GuardWear.clinch` 228-236;
  its `skilled` +13 is passed `false` at `GuardState.after` 128).

### 1.5 The opponent's side of it
- The opponent has no Pace or Hands setting. It plays one of six games (`Exchanges.MODES` 124-134) by its style
  (`MODE_V` 180-190), switches to "Tiring" 3 times in 4 once its energy is under 45 (`next_mode` 273-274,
  `OPP_TIRED` 56), and its energy runs from the bell's figure to the round-end figure (`BoutNight._energy` 319-341)
  less body shots and `opp_drain` (`RingDuel.opp_energy` 332-335).
- So "the puncher pays for punching a guard" needs no second energy model: `lv["opp_drain"]` is already a line.

### 1.6 What v5 listed as wrong on screen: fixed in the code since
| v5's stale line | Now (CODE) |
|---|---|
| "Hands up ... your boxer throws less" | "{opp}'s big shots miss" (`Exchanges.CALLS` 80, comment S533 GUARDREV5) |
| "a quiet exchange gives back 4" | "it comes back only when the opponent lands nothing (+4, pro +3)" (`GuardNotes.amateur_note` 24-26) |
| the guard bar's hover never mentioned blocks | "Guard: how high the hands stay. Blocked punches wear it down." (`HudBars.WORDS` 38) |
Still there: the caption that names no button, "The hands are coming down - over the top!" (`HudBars._guard_call` 300-307,
under 55%: `GUARD_LOW` 46); `GuardWear.blocked_strikes` (321), `parry_chance` (302), `posture_damage` (202), `word` (342)
and the clinch's "stamina -10 / free exchange" (236) with no caller in `scripts/` (git grep, this session).

### 1.7 Earlier research this map follows
- GUARDPROBE1 (`docs/GUARDPROBE1_RESULT.md`, `tools/guard_probe.gd`) sized the wear scales and the leak.
- GUARDPROBE2-4 (`docs/GUARDPROBE4_RESULT.md`) tested a HIGH / NEUTRAL / LOW **posture** (head against body) with
  `posture_damage`: HIGH or switching was best everywhere, LOW never. S528 decision: no posture control; the corner's
  Gloves high / Elbows in already is posture. v6 keeps that decision. **Hands is not a posture.** Posture = WHERE the
  punches land (head or body). Hands = HOW MUCH your boxer covers instead of punching. `posture_damage` stays unused.

## 2. The core change (TO BUILD; every size ESTIMATE until the probe of section 6)

### 2.1 Hands: High / Normal / Loose
- A third standing setting beside PACE and AIM on the corner bar. Same life as Pace: counts from the next exchange and
  stays until changed (`PaceAim.WHEN` 101), carried round to round in `m["live"]` (as `pace` / `aim` at LiveRound 111),
  set through the shout string as `|hands=high` (the `|pace=` / `|aim=` parser at LiveRound 167-172).
- The shout **"Hands up, move your head" = High for that one exchange**, whatever the setting. The shout **"Let your
  hands go" = Loose for that one exchange**. This answers v5's open question: a shout lasts 30 seconds, the setting holds.
  If the round's plan call is one of the two (`call` at LiveRound 190), it holds all round.
- New pure module `scripts/rules/HandsEdge.gd` (no preloads), one line in LiveRound next to 222:
  `d += HandsEdge.points(hands, sit, vals) + HandsEdge.worn(share_b) - HandsEdge.worn(share_a)`.
  It joins the SAME sum as the call, the pace and the plan, before `Exchanges.settle` (287).

### 2.2 The points, by the game the exchange is fought in (`Exchanges.situation` 194-199)
| The exchange | High | Loose | Why (boxing) |
|---|---|---|---|
| The opponent loads up | +6 | -8 | big single shots hit gloves; loose hands eat them |
| The opponent presses | -3 | +2 | a shell on the ropes gives the 30 seconds away, but see 2.4 |
| The opponent boxes at range | -7 | +3 | covering against a jab is not punching: the round goes |
| The opponent waits to counter | -2 | -6 | nothing to block; loose hands walk onto the counter |
| The opponent is tiring | -8 | +6 | covering lets a tired boxer rest; open up |
| The opponent is hurt | -8 | +5 | same |
| Your boxer is tired | +3 | -6 | survive the 30 seconds |
| Your boxer is hurt | +5 | -10 | survive the 30 seconds |
Normal is 0 everywhere: today's game.
- A plus is multiplied by how well your boxer does it, a minus by how hard your boxer commits to it - the corner
  calls' own rule (`Exchanges.grade` 227-245, `COMMIT` 32). High is graded on Defence and head movement (the "hands" call's
  needs, `CALLS` 79). Loose on Stamina and hand speed ("Let your hands go", 82). **The week feeds the fight here.**
- DERIVED sizes: High against a boxer at range loses about 10 more exchanges in 100; Loose against a tiring opponent
  wins about 9 more; High against a loader wins about 9 more. Between Save (-4) and a best call (+17): a setting matters
  less than a right call and more than nothing.
- The shout on top: "Hands up" against a loader keeps its +17 call edge AND the +6. "Hands up" at range is call edge 0
  AND -7: the free cover of 1.2 now has a price.

### 2.3 A worn guard costs points (the code's "NOT YET")
- `HandsEdge.worn(share)`: guard under half -2, under a quarter -4, for that side. Both sides: the opponent's worn guard
  pays your boxer. This is the first time wearing a guard down wins rounds, and the reason High cannot be held all night
  (2.5: it takes more blocks).

### 2.4 Covering tires the puncher (Kalli point 3)
- While Hands is High and the opponent is pressing or loading up: `lv["opp_drain"] += 1.0` an exchange (the existing line
  of 1.5). DERIVED: 6 energy a round, on top of the opponent's own spend.
- Under 45 energy the opponent turns "Tiring" 3 times in 4 (CODE, 1.5). There High is -8 and Loose is +6. The player
  must SWITCH: cover while the presser is fresh enough to hurt, open up when the mouth is open. The opponent's energy
  bar and the clue line ("mouth is open; the hands come back slow", `CLUES` 146) already show the moment.
- Over 3 amateur rounds the drain rarely gets a fresh presser under 45 in time (ESTIMATE; the probe measures it): there
  High just loses -3 an exchange. Over 6 pro rounds it does. Amateur and pro stay different.

### 2.5 What Hands does after settle (the count, the guard, the hurt)
The winner from `settle` stands. These lines change counts and damage only, next to LiveRound 297:
| | High | Loose |
|---|---|---|
| The opponent's landed | 1 in 3 becomes a block: 6->4, 5->3, 4->3, 3->2, 2->1, 1->1 (`round(n / 3)` taken off) | +1 when the opponent won the exchange |
| Your boxer's landed | x0.75, rounded as Save is (LiveRound 297): 6->5, 5->4, 4->3, 3->2, 2->2, 1->1 | +1 when your boxer won it |
| Blocked share of misses (`BLOCK_SHARE` 0.60) | 0.75 | 0.45 |
| Wear of each block | +8%: pass `"posture": "high"` to `GuardWear.wear` (CODE, unused today) | no change |
| Chance your boxer is hurt when losing big (`RingDuel.settle` 385-386) | x0.7 | x1.3 |
| Head damage | only the leak | +2.0 for the extra clean punch (`Adaptation.HEAD_DAMAGE`'s size) |
- One count rule (Kalli point 4): the figure line reads "Lost 4-3 - 2 on the guard". Blocks made by High are shown as
  "on the guard", never as landed.
- DERIVED: High means about a quarter more blocks at 8% more wear each; with the leak rising as the guard falls, a boxer
  who covers for three rounds reaches the -2 / -4 of 2.3 about a round earlier. The probe sizes it.

## 3. Kalli's 10 points, one by one
| # | Kalli asks | Verdict | How, and the number it moves |
|---|---|---|---|
| 1 | Covering into the exchange edge before settle, and it holds | **TAKE - section 2** | `d` at LiveRound 222, before `settle` 287. Her -0.15 / -0.20 are restated in the sum's own unit (power points, 2.2). The setting lives beside Pace and Aim, not in ONE CHANGE: that slot is shared with the habit fix and lasts one round (`Adaptation.gd` 2-5, `CallButtons` 73), and "Gloves high" there already means head-against-body (1.7). |
| 2 | "Wrong against heavy hands" true for amateurs | **TAKE** | (a) Wear and leak x (0.5 + power / 110) in `GuardState.wear_through` (power 40 = x0.86, 80 = x1.23; power as `Attrs` 268 builds it). (b) While Hands is High, every 4 power or heavy punches blocked from an opponent of power 70+ add +1 to the referee's look (point 8). DERIVED: about +1 an exchange, so a boxer who shells against a heavy hitter is stopped around the end of round 2 or in round 3, amateur or pro. |
| 3 | Covering tires the puncher | **TAKE - 2.4** | `lv["opp_drain"]`. The opponent has no Pace (1.5), so the trigger is its game (pressing, loading up), not "Push". |
| 4 | One count rule | **TAKE - 2.5** | The winner stands; "Lost 4-3 - 2 on the guard"; BROKEN's punches read "through a broken guard". |
| 5 | Link the week to the guard | **TAKE four, REFUSE one** | Defence sets the block share: 0.50 + Defence / 500 replaces the flat 0.60 (`GuardState.blocked_of`). Defence and head movement grade High; Stamina and hand speed grade Loose (2.2). The Tie up step at Sharp (60, `MoveMastery` 26) passes `skilled` = true: +13 instead of +10 (CODE constant, 1.4); Signature +16 (ESTIMATE). The habit "drops the right after the jab" (`HabitFix.PUNISHED_BY` 17), unfixed and under half guard: 1 block an exchange lands on the head instead. REFUSE "neck work cuts the head leak": neck mornings already train Durability (`Attrs` 273), which is the chin the knockdown rule reads (`Attrs` 261, `Knockdowns` 26) - a second cut would count it twice. Each taken link gets one line on the Training tab through `GuardNotes.lines`. |
| 6 | Guard in the plan and in the Why | **TAKE** | Plan: the round row that already opens a round on a pace (`PlanFile.pace_for`, LiveRound 107) also carries Hands. The plan page rates it against the opponent's main game (`Exchanges.favourite` 312) with 2.2's sign: Beats it / Works / Walks into it. Why: the Hands swing is counted like the plan's (same dice without the edge, LiveRound 290) -> AGAINST YOU or YOUR PLAN reads "Hands High cost 3 exchanges; 14 on the guard, 4 got through" from `FightStats`' blocked / through (33-38). NEXT points at the Training line of point 5. Fight prep (`FilmNight.prep_rows` 89): heavy hands and guard habits as rows with "Write it". |
| 7 | "Through the guard" as an Aim, pro only | **TAKE** | A sixth entry in `PaceAim.AIMS` (7), offered only when the bout is pro: the opponent's guard wears x1.5, your boxer lands 1 fewer clean an exchange, the usual aim cost -1.5 (`AIM_COST` 20). It pays through 2.3: the opponent's guard under half is +2, under a quarter +4. |
| 8 | One referee gauge; drop the warning price and the duplicate; mark the source | **TAKE** | One gauge a boxer: the look 0-10 as the bar, the counts as pips under it (3 in a round, 4 in a bout: `Knockdowns` 7-8). One stop rule: after a count the existing stop chance (`REF_STOP` 15, line 55) is x (1 + look / 10); the look reaching 10 with no count stops it as "outclassed". The "+2 on a warning" price is CUT (no warnings in the game). "Let your hands go: -1 for each exchange won" is CUT (it was the base rule). England Boxing 10.3.2 is John's citation: **CHECK** before any screen quotes it. |
| 9 | Fix and cut | **BUILT in part, TAKE the rest** | The three lines: BUILT (1.6). The caption becomes "The opponent's hands are dropping: Aim Head, hands Loose" - it now names two buttons and is true (2.3). Delete `blocked_strikes` and the clinch's "stamina -10 / free exchange" (energy in a tie-up is `ClinchRest`'s, REFILL 11). `parry_chance` stays for the counter below. |
| 10 | The probe before any board | **TAKE - section 6** | |

### 3.1 What v5 took from John: kept, changed or cut
| v5 item | v6 |
|---|---|
| 3.1 BROKEN under 20%, pro only: 1 block in 3 lands | KEPT. It also takes 2.3's -4, so it now costs rounds. |
| 3.2 "Hands up" as the cover (opponent lands 1 fewer, yours 30% fewer, the counter, the look) | REPLACED by section 2. Kept from it: the counter off a blocked power punch (`parry_chance("cross", defence)` x 0.25, +1 landed for your boxer), only while Hands is High. |
| 3.3 the referee's look | KEPT, merged into one gauge (point 8). Fed by: lost 6-1 (+1), covered and landed 0-1 (+1), a count (+2), heavy hands on a High guard (point 2), an exchange won (-1), the corner (-2). |
| 3.4 a guard price on each call | KEPT for Tie up (halves that exchange's leak) and Go to the body (every 3 body shots take 5 off the opponent's next corner refill; Aim Body counts too). CHANGED: "Jab and move" passes `"moving": true` to `GuardWear.wear` (-5%, CODE, unused) instead of "blocks become misses"; "Hands up" and "Let your hands go" are the timed High and Loose. |
| 3.4 "+5 at the next corner" for Hands up (`hands_next`, CODE) | CUT once High exists: too small to change a pick (Kalli), and High already pays in the exchange. |
| 3.5 the opponent's power, "Heavy right hand" mix, the pro habit "goes to the arms when ahead" | KEPT, power factor widened (point 2). |
| Section 4, John's page items | KEPT, with Kalli's cut: guard by round only on hover and in the Why, not on the corner card. |

## 4. Does any setting win everything? (the depth claim, to be proven by section 6)
| Opponent | High | Normal | Loose | Best plan |
|---|---|---|---|---|
| Light presser (power under 50) | loses rounds (-3); little to fear | fine | +2, small risk | Loose or Normal |
| Heavy presser, fresh | loses rounds AND fills the look (point 2) | takes clean shots | hurt x1.3 | Normal, tie up, move; High only when hurt |
| Heavy presser over 6 rounds | early: drains 6 a round; switch when it tires | | late: +6 | High, then Loose |
| Loader (slugger) | +6 while the guard lasts; -2 / -4 once worn | | -8 | High in bursts, Tie up to refill |
| Counter-puncher | -2 | best | -6 | Normal; Aim "Through the guard" (pro) |
| Boxer at range, volume puncher | -7 | fine | +3 | Loose, watch the energy |
No column is best on every row, and two rows need a switch during the bout. NOT PROVEN until the probe.

## 5. Every menu the mechanic appears on
| Menu | Shows | Wired to | Status |
|---|---|---|---|
| 3D fight, corner bar | PACE and AIM buttons with hover | `CornerBar` 156-186, `PaceAim.pace_tip` / `aim_tip` | CODE TODAY |
| 3D fight, corner bar | HANDS: High / Normal / Loose, the chosen one gold; hover = what it buys and costs in the game on show now, and "Counts from the next exchange" | `HandsEdge.points`, `lv["hands"]` | TO BUILD |
| Fight night (words), shout bar | PACE row and its cost line | `ShoutBar._draw_drive` 86-95 | CODE TODAY |
| Fight night (words), shout bar | HANDS row and its one-line effect | same as above | TO BUILD |
| Shout bar, the eight calls | when, energy, grade, win shift | `Exchanges.CALLS` 69-94, `win_shift` 215 | CODE TODAY |
| Shout bar, the calls | "Hands up" = High for 30 s, "Let your hands go" = Loose for 30 s; guard prices of 3.1 | `HandsEdge` | TO BUILD |
| 3D fight HUD, guard arc | fill, hover number, "?" until scouted | `HudBars` 38, 252-253; `FightMeters.bars` 45-47 | CODE TODAY |
| 3D fight HUD | the state under the arc: WORN (-2), ARMS DROPPING (-4), BROKEN (pro) | `HandsEdge.worn`, `GuardWear.word` (342, unused) | TO BUILD |
| 3D fight, caption | "The hands are coming down - over the top!" | `HudBars._guard_call` 300-307 | CODE TODAY -> reword (point 9) |
| 3D fight / corner minute | the referee's gauge with count pips | `f["bout"]["look"]`, `m["counts"]` (`BoutNight` 276) | TO BUILD |
| Corner minute | "Guard down to N% (leaking / arms dropping): Hands up or a tie-up buys it back." | `CornerCard.guard_line` 107-110, `card` 76-77 | CODE TODAY -> reword: "costs N points an exchange: a tie-up buys 10 back, or take the hands off High" |
| Corner minute | the coach's Hands pick for next round, with the reason (the opponent's game in the last three exchanges, as `Exchanges.read` 410-431 already reads it) | `HandsEdge.points` over `read`'s game | TO BUILD |
| Corner minute, ONE CHANGE | Gloves high / Elbows in (head against body, one round) | `Adaptation.offers` 31-47; `CornerOverlay` 344 | CODE TODAY, unchanged. Wording: rename the tile "Protect the head" / "Protect the body" so "high" means one thing on screen |
| Result page, figures | Punches blocked, Got through the guard (in punches), Guard left at the last bell | `FightStats.rows` 66-76 | CODE TODAY |
| Result page, figures | exchange lines as "4-3 - 2 on the guard"; "through a broken guard" | `rec["guard"]["blocked"]` (`GuardState.after` 134) | TO BUILD |
| The Why | AGAINST YOU / YOUR PLAN / NEXT (ropes, counts, steps today) | `FightWhy` 96-110; `WhyCard` 21 | CODE TODAY, no guard line |
| The Why | "Hands High cost / won N exchanges; N on the guard, M got through"; NEXT -> the Training line | hands swing (as LiveRound 290), `FightStats` | TO BUILD |
| Plan page, round rows | the round's pace | `PlanFile.pace_for` (LiveRound 107) | CODE TODAY |
| Plan page, round rows | the round's Hands, rated Beats it / Works / Walks into it | `HandsEdge.points` x `Exchanges.favourite` | TO BUILD |
| Fight prep, WHAT YOUR PLAN SHOULD ANSWER | the filed claims with "Write it" | `FilmNight.prep_rows` 87-90; `FightPrep` 9 | CODE TODAY, no guard row |
| Fight prep | heavy hands -> "High fills the referee's look"; the guard habit -> its round | point 2, `OppFile.GUARD_NOTE` 66 | TO BUILD |
| Opponent file | three guard habits | `OppFile.GUARD_NOTE` 64-67 | CODE TODAY |
| Opponent file | "goes to the arms when ahead" (pro) | v5 3.5 | TO BUILD |
| Training tab (bout booked) | the ropes warning, the amateur note | `GuardNotes.lines` 29-34 | CODE TODAY |
| Training tab | "Defence 58: blocks 62 in 100 of what misses"; "High guard: OK (Defence 58, head movement 55)"; "Tie up Sharp: +13 in a tie-up" | point 5 | TO BUILD |
| Boxer page, attributes | shoulder endurance: "the guard wears N% slower" | V5 (`AttrBoard` 281-287) | CODE TODAY (V5) |
Not asked of the 3D fight: nothing. It shows the settled round; the hands' height on screen is FIGHTPLAYER2's work
(METHOD line), and this map adds no layer in `scripts/fight3d`.

## 6. The probe that must pass before any board (GUARDPROBE6)
- Tool: `tools/guard_probe6.gd`, built on `tools/guard_probe.gd`'s population and `_play` (whole bouts through the game's
  own BoutNight path; `tools/guard_onoff.gd` 3-8 reuses it the same way). Headless, through `godot_slot.py`. GUARDPROBE4
  played 2,400 bouts in about a minute, so this is cheap.
- Population, named in the output: at least 3 different boxers of ours (never one boxer for every cell; never two
  identical fighters), against FOUR opponent types, 3 different opponents each: **light presser** (Pressure fighter,
  power under 50), **heavy presser** (Pressure fighter or Slugger, power 75+), **counter-puncher**, **volume puncher**.
  Formats: **amateur 3 rounds, pro 4, pro 6**. 12 cells, 200 bouts a cell, seeds printed.
- Arms: CONTROL (today's rules: a static switch `HandsEdge.on = false`, like `GuardState.damage_on` 21), NORMAL all
  bout, HIGH all bout, LOOSE all bout, READ (High against loading up or own trouble, Loose against tiring or hurt, else
  Normal), ROPE (High until the opponent is under 45 energy, then Loose).
- Bars (bands, never exact counts):
  1. NORMAL is within 2 wins in 100 of CONTROL in every cell: the change does not move the base game.
  2. No fixed setting (HIGH, NORMAL, LOOSE) is best against all four types in any format.
  3. HIGH and LOOSE are each best of the three in at least one cell.
  4. Pro 6, heavy presser: ROPE beats NORMAL by 5+ wins in 100.
  5. Amateur 3, heavy presser: HIGH loses to NORMAL by 5+ wins in 100, and more of its losses are stoppages.
  6. READ beats every fixed setting in at least 8 of 12 cells: reading the fight pays.
  7. GUARDPROBE1's guard bands still hold on NORMAL (amateur round 3 in yellow with red rare, pro last round in
     orange), and amateur stoppages stay inside 5-12 in 100 (`Knockdowns.gd` 3-4).
- The instrument can read worse: a mutant arm with 2.2's table zeroed must FAIL bars 2-6.
- A bar that fails is fixed on the table of 2.2 or the sizes of 2.3-2.5, and the probe is run again. The result page
  `docs/GUARDPROBE6_RESULT.md` is the run's own printed lines.
- Cannot be run today: 12-round bouts (the game has none).

## 7. Rulings kept
- The 3D fight never decides: every rule here is in `LiveRound.exchange` before the ring draws it; the new edge is in
  `d` before `settle`.
- Names only in headers: every new string says "your boxer" / "the opponent" (as `Exchanges.roles` 107 does).
- Only actionable information: every new line names the button that answers it (the caption, the corner line, the
  Why's NEXT). The guard-by-round history is on hover only.
- Amateur and pro stay apart: amateur full guard 70, +15% wear, scale 0.28, never BROKEN, no "Through the guard" aim,
  no "goes to the arms"; and three rounds are too short for the rope trade (2.4), six are not.
- Every new mechanic wired, shown, 7+: section 5 is the wiring table; the build is done only when each row shows in
  the .exe and one golden-path test sets Hands, plays a round and reads the Why's hands line.
- Build order when approved: `HandsEdge.gd` + its unit test (a pure module: a cloud seat), the LiveRound line and the
  setting, GUARDPROBE6, then the screens of section 5. Regression: `tests/guard_wear_test.gd`, `tests/guard_contract_test.gd`.

## 8. Code files opened (this session)
Whole: `scripts/rules/Exchanges.gd`, `GuardWear.gd`, `GuardNotes.gd`, `CornerCard.gd`, `CornerJobs.gd` (no guard rule in it:
nothing to cite), `LineGrade.gd` (read only; no guard rule), `PaceAim.gd`, `Knockdowns.gd`, `scripts/state/GuardState.gd`.
In part: `scripts/state/LiveRound.gd` (100-142, 160-468), `RingDuel.gd` (300-398), `StepWire.gd` (150-190), `BoutNight.gd`
(225-342), `JudgeNight.gd` (1-80), `CrackWire.gd` (55-80); `scripts/rules/Adaptation.gd` (1-110), `BoutRules.gd` (395-425),
`Judges.gd` (1-40), `FightStats.gd` (1-80), `BoutBurn.gd` (1-14), `ClinchRest.gd` (1-30), `Attrs.gd` (260-268), `PlanFight.gd`
(44-58), `FightWhy.gd` (90-110), `FilmNight.gd` (84-92); `scripts/fight3d/HudBars.gd` (30-48, 200-212, 238-256, 286-310),
`CornerBar.gd` (150-186), `ShoutBar.gd` (84-96). By git grep only (the cited line): `OppFile.gd` 64-66, `HabitFix.gd` 17,
`MoveMastery.gd` 26, `CallButtons.gd` 73, `CornerOverlay.gd` 344, `FightCast.gd` 79, `WhyCard.gd` 21, `FightPrep.gd` 9,
`tools/guard_probe.gd`, `guard_onoff.gd`. Results read: `docs/GUARDPROBE1_RESULT.md` to `GUARDPROBE4_RESULT.md` (head and RESULT lines).
Not opened, so nothing of theirs is tagged CODE: `AttrBoard.gd`, `FightNight.gd`, `PlanFile.gd`, `Combos.gd`. The v1-v4 maps were
not used as evidence.
