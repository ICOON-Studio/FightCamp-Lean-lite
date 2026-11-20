# DMGCLASS1_V2 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN DMGCLASS1 v2 — Stoppages and Punch Impact by Weight Class and Sex

Kind: design map (v2, rewritten from code after S532 review of `ops/research/DESIGN_DMGCLASS1_V1.md`)
Scope: research and architecture only — zero game code touched, Godot not run.

## Why v1 Failed and What v2 Changes

`ops/research/DESIGN_DMGCLASS1_V1.md` aimed a division multiplier at `Matchmaking.stop_chance` (`CODE`, `scripts/rules/Matchmaking.gd:272-275`), framed weight class as a player choice, proposed unmeasured multipliers on top of unmeasured base rates, and multiplied post-stoppage rest down to 0.5 weeks in lighter women's classes. All four moves break against the live codebase:

1. **Wrong dial fixed:** `Matchmaking.stop_chance` decides zero stoppages. It only formats the `"Stoppage %d%%"` label on professional offer rows (`CODE`, `scripts/ui/ProFights.gd:212-215`) and feeds the 5-axis dominance filter (`CODE`, `scripts/state/ProLadder.gd:229`). Actual hurt states, standing 8-counts, referee wave-offs (`RSC`), clean knockouts (`KO`), and corner towel retirements (`RTD`) are decided inside `RingDuel.settle` (`CODE`, `scripts/state/RingDuel.gd:375-378`), `Knockdowns.round_counts` and `Knockdowns.puncher_chance` (`CODE`, `scripts/rules/Knockdowns.gd:21-70, 122-139`), `BoutNight.count_sides` and `BoutNight._counts` (`CODE`, `scripts/state/BoutNight.gd:246-295`), `Towel.risk` (`CODE`, `scripts/rules/Towel.gd:25-65`), and `WorldBout.fight` / `WorldBout.fast` (`CODE`, `scripts/world/WorldBout.gd:109-143, 173-204`). The class-and-sex factor belongs in one pure rule file (`scripts/rules/ClassDamage.gd`) read by those fight-ending functions; every shown stoppage number then reads the **same** factor.
2. **Fake choice replaced with five real player choices:** Moving a signed boxer up or down a weight class **does not exist anywhere in code**. Weight class and sex are fixed to your boxer's body at signing (`CODE`, `scripts/state/Data.gd:256-270`) and mapped deterministically on turning pro (`CODE`, `scripts/state/ProLadder.gd:46-52`). What the factor actually changes are the numbers behind five live player decisions: which offer or Ask card to take, where to set and answer the corner towel, how to spend Game Plan defence versus finish slots and pace, how to answer a fight-week pull-out replacement or compromised bout, and how to weight chin/heart versus engine/jab in camp and perks. None of the five has a dominant pick.
3. **Measure first, then fit:** Round count (`3` amateur versus `4 / 6 / 8 / 10` professional) and cumulative head damage (`damage / 60.0`) inside `Knockdowns.round_counts` (`CODE`, `scripts/rules/Knockdowns.gd:10, 33`) already create steep endogenous stoppage growth over longer bouts, while code runs a fixed `6` exchanges per round (`CODE`, `scripts/rules/Exchanges.gd:5`) rather than shorter 2-minute rounds in women's professional bouts. Multiplying blind BoxRec ratios on top of `Knockdowns.gd` would double-count round length in men's 10-rounders and over-stop women's 8- and 10-rounders. Section 4 specifies `tools/dmg_class_probe.gd` (copied from `tools/stop_word_probe.gd`) to measure the unmodified baseline across all 17 `(sex x class x ruleset)` cells first and fit `ClassDamage` to the measured base.
4. **Medical rest and injuries stay on the damage ledger:** A featherweight stopped cold does not heal faster than a middleweight stopped cold. `Injuries.after_bout` (`CODE`, `scripts/state/Injuries.gd:192-234`), `InjuryRoll.ko_days` and `InjuryRoll.bout_chance` (`CODE`, `scripts/rules/InjuryRoll.gd:24-56`), `StandDown.make` (`CODE`, `scripts/rules/StandDown.gd:25-31`), `Matchmaking.next_weeks` (`CODE`, `scripts/rules/Matchmaking.gd:279-282`), `Attrs.wear_stoppage` (`CODE`, `scripts/rules/Attrs.gd:129-131`), and `WorldAge.record_stoppage_loss` (`CODE`, `scripts/world/WorldAge.gd:118-120`) take **zero** class or sex multipliers.

---

## 1. Empirical Stoppage Rates by Weight Class and Sex (Dola SQ257)

Preserved from `ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md` (SQ257) and mapped directly onto the repository's 9 amateur divisions (`CODE`, `scripts/state/Data.gd:136-155`) and 8 `WORLD1` professional divisions (`CODE`, `assets/data/world/divisions.json:1-12`):

| Weight Band | Sex | Ruleset | Game Division ID (`limit`) (`CODE`) | Empirical Stoppage % (`KO + TKO/RSC + RTD`) (SQ257) | Real Bout Format & Equipment | Primary Stoppage Driver |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Featherweight** | Women | Amateur | `wfw` (`57.0 kg`) | **1.0% – 2.5%** | 3x3 min, 10 oz gloves, headguard | Safety RSC on unanswered flurries; clean KOs almost zero |
| **Featherweight** | Women | Pro | `w_fw` (`57.0 kg`) | **14% – 18%** | 4–10x2 min, 8 oz gloves, no headguard | Volume TKO and corner RTD; 2-min rounds cap finish windows |
| **Featherweight** | Men | Amateur | `mfw` (`55.0 kg`, note 3) | **4% – 6%** (`3% – 5%` at 55 kg `ESTIMATE`) | 3x3 min, 10 oz gloves, no headguard | High-pace accumulation RSC and standing-count limits |
| **Featherweight** | Men | Pro | `m_fw` (`57.0 kg`) | **33% – 38%** | 4–12x3 min, 8 oz gloves, no headguard | Late-round attrition TKO, body shots, counter KOs |
| **Lightweight** | Women | Amateur | `wlw` (`60.0 kg`) | **1.5% – 3.5%** | 3x3 min, 10 oz gloves, headguard | Referee RSC on mismatch combinations |
| **Lightweight** | Women | Pro | `w_lw` (`61.2 kg`) | **16% – 21%** | 4–10x2 min, 8 oz gloves, no headguard | Accumulation TKO; points decisions remain ~80% of bouts |
| **Lightweight** | Men | Amateur | `mlw` (`60.0 kg`) | **6% – 9%** | 3x3 min, 10 oz gloves, no headguard | Combination RSC, cuts, occasional clean counter |
| **Lightweight** | Men | Pro | `m_lw` (`61.2 kg`) | **38% – 44%** | 4–12x3 min, 8 oz gloves, no headguard | Sharp combination KOs, liver folds, late TKO waves |
| **Welterweight** | Women | Amateur | `www` (`65.0 kg`), `wlm` (`70.0 kg`, note 3) | **2.0% – 5.0%** (`3.5% – 6.5%` at 70 kg `ESTIMATE`) | 3x3 min, 10 oz gloves, headguard | Power mismatch RSC; multi-count referee stops |
| **Welterweight** | Women | Pro | `w_wr` (`66.7 kg`) | **18% – 24%** | 4–10x2 min, 8/10 oz gloves, no headguard | Corner RTD and referee TKO on ropes |
| **Welterweight** | Men | Amateur | `mww` (`70.0 kg`) | **8% – 12%** | 3x3 min, 12 oz (>67 kg), no headguard | Heavy single shots forcing standing 8-counts and RSC |
| **Welterweight** | Men | Pro | `m_wr` (`66.7 kg`) | **43% – 50%** | 4–12x3 min, 8/10 oz gloves, no headguard | True single-shot hurt, knockdowns, and attrition KOs |
| **Middleweight** | Women | Amateur | `wmw` (`75.0 kg`) | **5.0% – 9.0%** | 3x3 min, 12 oz gloves, headguard | Physical strength + shallow-pool skill gaps -> RSC |
| **Middleweight** | Women | Pro | `w_mw` (`72.6 kg`, note 1) | **20% – 26%** | 4–10x2 min, 10 oz gloves, no headguard | Undercard mismatch TKOs; competitive top-10 goes to points |
| **Middleweight** | Men | Amateur | `mmw` (`75.0 kg`) | **12% – 16%** | 3x3 min, 12 oz gloves, no headguard | True one-punch knockdowns and RSC / RSC-I |
| **Middleweight** | Men | Pro | `m_mw` (`72.6 kg`) | **48% – 55%** | 4–12x3 min, 10 oz gloves, no headguard | High clean-KO share alongside multi-knockdown TKOs |

### Sources and Thin-Data Notes (Preserved from SQ257)
- **Sources:** BoxRec and FightMatrix active divisional stoppage rates (4- to 12-round pro bouts); IBA Men's and Women's World Boxing Championships official results books (2018–2023); Paris 2024 Olympic Games official boxing results book; Bianco et al. (2013, *BJSM*) on women's Olympic RSC rates; Gavagan et al. (2017) and Krkeljas & Kovac (2021) on mass/sex punch-force scaling versus neck isometric strength; England Boxing Rule Book 2024–2025 (Rule 4.1.2 head-stoppage suspension); BBBofC medical suspension guidelines.
- **Thin-data note 1 — Women's pro middleweight (`w_mw`, 72.6 kg):** Fewer than 100 active professionals compete globally on BoxRec at 160 lb. Raw stoppage totals (~20–26%) are inflated by A-side prospects stopping novices on 4/6-round undercards; evenly matched ranked bouts finish inside the distance closer to ~15–20%. Fitting `ClassDamage` on competitive ranked pairs must stay near the bottom of `20% – 26%` so top-10 fights do not turn into coin-flip shootouts.
- **Thin-data note 2 — Amateur standing counts without RSC:** IBA and Olympic summary books publish final `RSC` / `KO` outcomes, not total standing 8-counts in bouts that still reach the final bell. Standing-count targets keep the `J_KDRATES1_JOHN.md` rule documented in `Knockdowns.gd` (`CODE`, `scripts/rules/Knockdowns.gd:2-5`): roughly **2 to 4 counted bouts per stopped bout** (`ESTIMATE`).
- **Thin-data note 3 — Amateur class alignment (`mfw` 55 kg, `wlm` 70 kg, `mww` 70 kg):** `Data.DIVISIONS` (`CODE`, `scripts/state/Data.gd:136-155`) carries 5 women's classes (`57, 60, 65, 70, 75 kg`) and 4 men's classes (`55, 60, 70, 75 kg`). On turning pro, `ProLadder.division_for` (`CODE`, `scripts/state/ProLadder.gd:46-52`) maps `<= 57.5 -> fw`, `<= 62.0 -> lw`, `<= 70.0 -> wr`, and `> 70.0 -> mw` (so both `www` 65 kg and `wlm` 70 kg enter `w_wr`, and `mww` 70 kg enters `m_wr`). Keying `ClassDamage` directly by division ID (with `sex` + `limit` fallback) lets `wlm` (70 kg) sit cleanly between `www` (65 kg) and `wmw` (75 kg) instead of collapsing them.
- **Ruleset note — Club novices vs elite brackets, and 2-minute rounds:** Regional club shows have wider skill gaps than Olympic brackets (handled naturally in code by `exp((power - chin) / 12.0)` in `Knockdowns.gd:33`), while women's pro bouts run 2-minute rounds in reality versus fixed `Exchanges.EXCHANGES = 6` (`CODE`, `scripts/rules/Exchanges.gd:5`) in code. The pro cells in `ClassDamage` therefore absorb the 2-minute-round finish-window compression for women's pro without changing exchange counts on the UI.

---

## 2. Where Stoppages, Knockdowns, and Hurt Actually Happen in Code

### 2.1 Why `Matchmaking.stop_chance` and `CounterCut` Are Not the Fight Dial
- **`Matchmaking.stop_chance(win_chance_now, opp)` (`CODE`, `scripts/rules/Matchmaking.gd:272-275`):** Computes `(1.0 - win_chance_now) * maxf(0.1, opp.ko / opp.w)` (using `0.25` when `wins == 0`). It is called in only two places in the entire repository: `ProLadder.offer_axes` (`CODE`, `scripts/state/ProLadder.gd:229`) for the 5-axis dominance filter and `ProFights._row` (`CODE`, `scripts/ui/ProFights.gd:213`) to format `"Stoppage %d%%"` on the promoter's card. No bout, round, or knockdown ever calls it.
- **`CounterCut.cut(b, cut_at)` (`CODE`, `scripts/rules/CounterCut.gd:20-35`):** Appears when grepping `stopped` (`moved["stopped"] = true` at `line 33`, pinned by `tests/counter_cut_test.gd`), **but it is a 3D punch-animation helper**, not a bout stoppage rule. When a counter-punch lands first in 3D, `CounterCut` trims the interrupted punch beat so `BeatFire` skips the interrupted shot's hit sound. Touching it has zero effect on bout outcomes.

### 2.2 Every Real Hurt, Knockdown, and Stoppage Roll in the Codebase

1. **In-round exchange hurt (watched and simulated player bouts):**
   - `RingDuel.side(a)` (`CODE`, `scripts/state/RingDuel.gd:204-206`) builds `{power: 0.7 * power + 0.3 * accuracy, chin, heart}`.
   - After each of the 6 exchanges in a round, `RingDuel.settle` (`CODE`, `scripts/state/RingDuel.gd:375-378`) checks whether the exchange margin beat `Exchanges.HURT_AT` (`30.0`, `CODE`, `scripts/rules/Exchanges.gd:55`):
     - The opponent hurt (`lv["opp_hurt"]`, `line 376`): `(margin > 30.0 and rng.randf() < clampf(0.3 + (ks.power - ko.chin) / 100.0, 0.1, 0.6))` or landed corner set-up.
     - Your boxer hurt (`line 377-378`): `margin < -30.0 and rng.randf() < clampf((0.3 + (ko.power - ks.chin) / 100.0) * talk_hurt * (1.6 if missed_setup_or_read else 1.0), 0.1, 0.8)`.
   - Being hurt enters the hurt situation on the next exchange (`CODE`, `scripts/rules/Exchanges.gd:145-149`) and strips `Duels.HURT_DEF * (1.2 - composure / 100.0)` (`8.0` base) off `guard`, `head_movement`, and `footwork` (`CODE`, `scripts/rules/Duels.gd:88, 141-143`), snowballing round margins toward `"clear"` and `"dominant"`.
   - On the unwatched world path, `WorldBout._hurt_edge` (`CODE`, `scripts/world/WorldBout.gd:88-93`) computes the expected hurt carry-over `pa` / `pb` from `HURT_BASE + last / 90.0 + (power - chin) / 60.0`.

2. **Round-end head damage, standing counts, referee `RSC`, and `KO`:**
   - At the bell of every round in a player bout (`Bouts.fight_step` and `BoutNight.play_out`, also called by `PlanTest.run` at `scripts/state/PlanTest.gd:47` and `FixLab.run` at `scripts/state/FixLab.gd:45`), `BoutNight._counts` (`CODE`, `scripts/state/BoutNight.gd:256-295`) builds `sides := count_sides(f, opp)` (`lines 246-250`):
     - `sides["a"]` = your boxer (`stop_mult = PerkFight.stop_mult(opp)` — the opponent's `Finisher` perk `1.5`, else `1.0`, `CODE`, `scripts/rules/PerkFight.gd:16, 48-49`), plus `StyleName.knock_power` for a Slugger (`line 258`).
     - `sides["b"]` = the opponent (`stop_mult = PerkFight.stop_mult(f)`).
   - `Knockdowns.round_counts(margin, loser, sides, damage, counts_so_far, rng)` (`CODE`, `scripts/rules/Knockdowns.gd:21-70`):
     - Adds round head damage (`lines 30-31`): `DAMAGE_PER_ROUND[margin]` (`close: 8.0, clear: 18.0, dominant: 32.0`) to `damage[loser]` and `WINNER_DAMAGE` (`2.0`) to `damage[winner]`. (Live exchange events in `LiveRound.gd:268-323` also add `PerkFight.COUNTER_DAMAGE`, dirty clinch, set-up, read, and guard bleed-through into `m["damage"]`.)
     - Standing-count roll (`lines 33-46`): `p = minf(0.85, BASE_COUNT * MARGIN_FACTOR[margin] * exp((power - chin) / POWER_CHIN_SCALE) * (1.0 + loser_dmg / DAMAGE_SCALE))` with `BASE_COUNT = 0.05`, `POWER_CHIN_SCALE = 12.0`, `DAMAGE_SCALE = 60.0`, rolled up to 3 times with `0.6x` decay.
     - Referee wave-off and `KO` (`lines 50-69`, gated by `counts > 0`): `stop_p = minf(0.9, REF_STOP * (1.0 + damage_out[loser] / DAMAGE_SCALE) * (1.4 - heart / 100.0) * loser_side.get("stop_mult", 1.0))` (`REF_STOP = 0.2`). If waved off and `damage_out[loser] >= KO_DAMAGE` (`60.0`), rolls `(1.0 - heart / 100.0) * KO_ODDS` (`0.7`) for `"KO"`, else `"RSC"`. Three counts in one round (`COUNTS_ROUND_STOP = 3`) or four in the bout (`COUNTS_BOUT_STOP = 4`) also force `"RSC"`.
   - `PerkFight.iron_chin` (`CODE`, `scripts/state/BoutNight.gd:264-269`, `scripts/rules/PerkFight.gd:24-31`) converts your boxer's first standing count of the bout into a stagger (unless already a `KO`).
   - `LiverFold.roll` (`CODE`, `scripts/state/LiverFold.gd:26-57`, called at `BoutNight.gd:272` when `counts == 0`): rolls a body 8-count from accumulated right-side liver shots; stops the bout (`"RSC"`) only if that body count is the boxer's 4th count of the bout (`COUNTS_BOUT_STOP`).
   - `Knockdowns.puncher_chance` (`CODE`, `scripts/rules/Knockdowns.gd:122-139`, called at `BoutNight.gd:275` when `counts == 0`): lets the round's **loser** catch the round's **winner** with `BASE_COUNT * COUNTER_SHARE` (`0.05 * 0.4 = 0.02` base), then rolls the exact same `stop_p` (reading `sides[target].get("stop_mult", 1.0)`) and `KO` / `RSC` check.

3. **Between-round corner retirements (`RTD` / `RTD_B`):**
   - `TowelWire.card` (`CODE`, `scripts/state/TowelWire.gd:46-66`, called from `BoutNight._shout` at `line 235`) passes `BoutNight.count_sides(f, opp)` into `Towel.risk` (`CODE`, `scripts/rules/Towel.gd:25-65`), which runs `200` seeded next-round simulations through `Knockdowns.round_counts` and `Knockdowns.puncher_chance`. When `risk["stop"]` meets `f["towel_line"]` (`0.12 / 0.20 / 0.33`), `TowelStrip` offers `"Throw the towel"` (`TowelWire.pull` sets `r["stopped"] = "RTD"`, `lines 96-114`), or `TowelWire.coach_pull` (`lines 79-93`) auto-pulls during simulated rounds.
   - `CrackWire.answer` and `CrackWire.bell` (`CODE`, `scripts/state/CrackWire.gd:52-87`) set `"RTD"` (your corner) or `"RTD_B"` (the opponent's corner) on a cracked rib.

4. **Unwatched world and rival bouts (`WorldBout`, `WorldSim`, `Region`, `WorldGen`):**
   - `WorldBout.fight` (`CODE`, `scripts/world/WorldBout.gd:109, 132-141`), `WorldBout.cached` (`line 160`), and `WorldBout.fast` (`lines 177, 192-201`) build `sides` via `_side(profile)` (`line 324`, **which today sets only `{power, chin, heart}` and no `stop_mult` or class keys**) and call `Knockdowns.round_counts` and `Knockdowns.puncher_chance` every round.
   - `WorldSim.simulate_bout` (`CODE`, `scripts/world/WorldSim.gd:142, 167-174`) runs `WorldBout.fast` for 6, 8, or 10 rounds (`rounds_for` at `lines 150-154`) and increments `winner["ko"]` and `WorldAge.record_stoppage_loss(loser)` whenever `r["stopped"]` is true. (`WorldSim._roll_stoppage` at `lines 160-164` is dead uncalled code left over from before S398.)
   - `Region._rival_bout` (`CODE`, `scripts/state/Region.gd:172`) runs `WorldBout.fast(a, b, 3, rng)` for 3-round amateur club-show bouts between division rivals.
   - `WorldGen._make_boxer` (`CODE`, `scripts/world/WorldGen.gd:153-154`) seeds initial world records with `ko_share = clampf(0.3 + explosiveness / 30.0, 0.05, 0.75)` — completely blind to `sex` and `div_id`, giving day-one women's featherweights and men's middleweights the same ~30% KO-to-win ratio.

5. **Where `stopped` is recorded after the bell:**
   - `BoutFinish.run` (`CODE`, `scripts/state/BoutFinish.gd:33-155`) reads `BoutNight.stopped(m)` (`""`, `"RSC"`, `"KO"`, `"RTD"`, `"RTD_B"`), writes `m["stopped"]`, updates records (`ko` on stoppage win), applies `Attrs.wear_stoppage` (`-2.0` `durability_cap`) on non-`RTD` stoppage losses (`line 67`), calls `ProLadder.result` -> `Matchmaking.apply_result` (`stop != ""`, `line 79`), calls `Injuries.after_bout` (`line 146`), and passes `stopped` to `AfterFight.book` (`CODE`, `scripts/state/AfterFight.gd:31-75`) for `Aftermath.toll` (`+10.0` tiredness on stopped bouts, `CODE`, `scripts/rules/Aftermath.gd:22, 28-30`).

### 2.3 Where the New Dial Goes: `scripts/rules/ClassDamage.gd`

Create **one pure static rule file**, `scripts/rules/ClassDamage.gd` (zero `preload` statements, no `Career` dependency), keyed by `(sex, div_id, pro)` with `(sex, limit_kg, pro)` fallback for raw dicts. Each cell provides three numbers fitted by `tools/dmg_class_probe.gd` (Section 4):

- **`punch_mult`** — **how hard punches land:**
  - Multiplies round head damage `DAMAGE_PER_ROUND[margin]` and `WINNER_DAMAGE` in `Knockdowns.round_counts` (`Knockdowns.gd:30-31`) via `float(winner_side.get("punch_mult", 1.0))`. Heavier and men's bouts cross `KO_DAMAGE = 60.0` earlier (raising clean `KO` share relative to `RSC` naturally) and leave higher `m["damage"]` after wars; lighter and women's bouts stay below `KO_DAMAGE` far more often (keeping almost all amateur stops as `RSC`).
  - Multiplies the exchange hurt probability in `RingDuel.settle` (`RingDuel.gd:376-378`) and expected hurt probability `pa` / `pb` in `WorldBout._hurt_edge` (`WorldBout.gd:88-93`).
- **`count_mult`** and **`class_stop`** — **how often counts and referee wave-offs fire:**
  - In `Knockdowns.round_counts` (`Knockdowns.gd:33, 52`) and `Knockdowns.puncher_chance` (`Knockdowns.gd:129, 134`):
    - Standing-count chance `p` multiplies by `float(winner_side.get("count_mult", 1.0))`.
    - Referee wave-off `stop_p` multiplies by `float(loser_side.get("stop_mult", 1.0)) * float(loser_side.get("class_stop", 1.0))`.
  - Why both `count_mult` and `class_stop` are needed: in `Knockdowns.gd`, wave-offs and KOs are gated behind `if counts > 0:` (`line 50`), while 3 counts in a round or 4 in a bout auto-stop even when `stop_p = 0` (`line 58`). Moving `class_stop` alone cannot drop women's featherweight amateur stops to `1.0% – 2.5%` without leaving excessive 8-counts, nor lift men's middleweight pro stops to `48% – 55%` across 4/6/8-round bouts if `BASE_COUNT = 0.05` never scales.
  - Why `class_stop` is a **separate key** from `stop_mult` on `sides`: `tests/stop_mult_test.gd` (`CODE`, `tests/stop_mult_test.gd:20-23, 35`) explicitly asserts that `BoutNight.count_sides(f, opp)` sets `plain["a"]["stop_mult"] == 1.0` and `plain["b"]["stop_mult"] == 1.0` when neither boxer has perks, and that `stop_mult` moves only the referee and not the count. Keeping `stop_mult` strictly for `PerkFight.stop_mult` while attaching `punch_mult`, `count_mult`, and `class_stop` (all defaulting to `1.0` when omitted!) keeps `tests/stop_mult_test.gd` and `tests/knockdowns_test.gd` 100% green.

Where `ClassDamage` is attached:
1. **`BoutNight.count_sides(f, opp)` (`BoutNight.gd:246-250`):** Attaches `punch_mult`, `count_mult`, and `class_stop` from `ClassDamage` to `sides["a"]` and `sides["b"]`. Covers live bouts, simulated bouts, `PlanTest.run`, `FixLab.run`, and `Towel.risk`.
2. **`RingDuel.settle` (`RingDuel.gd:375-378`):** Scales both corners' hurt roll odds by `ClassDamage.punch_mult`.
3. **`WorldBout.fight`, `WorldBout.cached`, `WorldBout.fast`, and `WorldBout._hurt_edge` (`WorldBout.gd:88-93, 109, 160, 177`):** Builds sides via `_side_for(boxer, profile)` attaching `ClassDamage` from `boxer.get("sex")`, `boxer.get("div")`, and `boxer.get("limit")`. Covers `WorldSim.simulate_bout` and `Region._rival_bout`.

### 2.4 How Every Shown Stoppage Number Reads the Same Factor

1. **Corner Towel (`TowelStrip.gd` via `TowelWire.card` -> `Towel.risk`):** Already calls `BoutNight.count_sides(f, opp)` (`TowelWire.gd:51`) and runs 200 trials of `Knockdowns.round_counts` and `Knockdowns.puncher_chance` (`Towel.gd:40-61`). Once `count_sides` carries `ClassDamage`, `"Stopped next round: X in 100"` automatically reflects the division's exact ring math with zero duplicate formula.
2. **Pro Offer Rows (`ProFights._row` & `ProLadder.offer_axes` -> `Matchmaking.stop_chance`):**
   - `WorldGen._make_boxer` (`WorldGen.gd:153-154`) replaces the flat `0.30` center with `ClassDamage.pro_ko_share(sex, div_id)` (derived from the probe's measured division KO share, `ESTIMATE` ~`0.16` in `w_fw` up to ~`0.52` in `m_mw`) plus the existing `explosiveness / 30.0` tilt.
   - `WorldSim.simulate_bout` then evolves `ko / w` through `WorldBout.fast` using the same `ClassDamage` ring factor.
   - `Matchmaking.stop_chance(win_chance_now, opp)` (`Matchmaking.gd:272-275`) reads `ClassDamage.pro_ko_share` when `opp["w"] == 0` (replacing hardcoded `0.25`) and scales the `0.10` floor proportionally by division, so a `0-0` or `12-2` opponent in `w_fw` vs `m_mw` shows a `"Stoppage %d%%"` that matches actual `BoutNight` outcomes.
3. **Amateur Ask Cards & Offer Comparison (`AskFlow.answers` -> `StopWord` -> `AskPanel` / `BoutCompare`):**
   - `tests/stop_word_test.gd` (`CODE`, `tests/stop_word_test.gd:106`) enforces that `StopWord.gd` stays pure with **zero `preload(` calls** and preserves `StopWord.word(gap)` on the `STOPWORD1` fixture.
   - Add `StopWord.word_for(gap: float, stop_factor: float = 1.0) -> String` (where `word(gap)` calls `word_for(gap, 1.0)`), shifting the effective rating gap by the division's probe-measured log-hazard offset `ClassDamage.amateur_gap_shift(sex, div_id)` (`AskFlow.answers` at `AskFlow.gd:113` passes the shift in). At the same `+3.0` rating gap, `wfw` reads `"unlikely"` (<8% stop risk) while `mmw` reads `"possible"` or `"a real risk"` (>20% stop risk).

### 2.5 Tests That Pin `stopped` and `stop_mult`

| Test File (`CODE`) | What It Pins Today | How v2 Keeps It Honest |
| :--- | :--- | :--- |
| `tests/stop_mult_test.gd` | `BoutNight.count_sides` sets `stop_mult == 1.0` without perks, `> 1.0` with `Finisher`; `stop_mult` moves referee wave-off in `puncher_chance`, not standing counts; `stop_mult == 1.0` equals omitted key. | Keep `stop_mult` exclusively for perks; `ClassDamage` uses separate `punch_mult`, `count_mult`, `class_stop` keys defaulting to `1.0` when omitted. |
| `tests/knockdowns_test.gd` | Raw `sides` 3-round stop share `[0.03, 0.12]`, count share `[0.10, 0.25]`, 3-in-round & 4-in-bout RSC, `KO_DAMAGE = 60.0` gate, `DAMAGE_PER_ROUND` accumulation, determinism. | Raw `sides` dicts in unit tests omit class keys -> default `1.0`, zero change to base `Knockdowns` unit math. |
| `tests/bout_stoppage_test.gd` | 400 `Bouts.fight_step(..., "sim")` bouts for `wlw` (60 kg women's amateur): counts in `[3%, 60%]`, stops in `[0.25%, 20%]`, early round termination, `"RSC|KO round n"`. | `wlw` SQ257 target (`1.5% – 3.5%`) sits squarely inside `[0.25%, 20%]`. |
| `tests/towel_test.gd`, `tests/towel_wire_test.gd` | `Towel.risk` matches `Knockdowns.round_counts` / `puncher_chance`; `RTD` gives `14` days out and skips `wear_stoppage`; `FightPrep.towel_row` buttons. | `Towel.risk` reads the same `sides` dict from `BoutNight.count_sides`; `RTD` rules stay untouched. |
| `tests/perk_fight_test.gd` | `Iron chin` turns count #1 into stagger; `Finisher` `1.5x` `stop_mult`. | Multiplicative with `class_stop`; perk invariants hold in every class. |
| `tests/stop_word_test.gd` | `StopWord.word(gap)` cutoffs (`0.0`, `8.0`), monotonicity, mutant kills, **no `preload(` in `StopWord.gd`**. | `StopWord.gd` keeps zero preloads and `word(gap)` unchanged; `AskFlow` passes `ClassDamage` offset into `word_for`. |
| `tests/rib_damage_test.gd` | `LiverFold` body 8-count -> 4th-count `RSC`; `CrackWire` `RTD` / `RTD_B`. | Body fold count limit (`COUNTS_BOUT_STOP = 4`) and rib `RTD` unchanged. |
| `tests/injuries_test.gd`, `tests/injury_roll_test.gd` | `ko_days` (`30 / 90 / 365`), `RTD` skipping `InjuryRoll`, `StandDown` days, `bout_chance`. | Zero class/sex multipliers in injury or stand-down code. |
| `tests/counter_cut_test.gd` | `CounterCut.cut` sets `moved["stopped"] = true` on interrupted 3D punch beat. | Untouched (animation helper, not bout stoppage). |
| **New:** `tests/class_damage_test.gd` | Monotonicity (`fw <= lw <= wr <= mw`; `f < m` at matched limit and ruleset; amateur < pro per division), default-`1.0` omission parity, `ProFights` / `Matchmaking.stop_chance` / `Towel.risk` / `WorldBout.fast` alignment. | Added in implementation slice to lock every division invariant. |

---

## 3. Weight Class Is Fixed; Five Real Player Choices Whose Numbers Move

### 3.1 Verification in Code: Weight Class Is Not a Player Choice
A grep across `scripts/` for writes to `["div"]`, `["limit"]`, and `["wc"]` confirms **moving up or down a weight class does not exist**:
- `Data.fighter_state` (`CODE`, `scripts/state/Data.gd:256-270`) writes `div`, `wc`, and `limit` once from `Data.DIVISIONS[div]` when a boxer joins the gym. Only `SaveGame.gd` save-migration helpers touch missing legacy keys.
- Walk-ins (`CODE`, `scripts/rules/FirstHour.gd:116-130`), scouted prospects (`CODE`, `scripts/state/Data.gd:221-244`, `scripts/state/Roster.gd:113-125`), and home juniors arrive with fixed `sex`, `div`, `limit`, and walking `weight`. Neither `FighterPage.gd` nor `FightPrep.gd` has a division switcher; weight management (`FightWeek.gd`, `Camp.gd`) is strictly making your boxer's fixed `f["limit"]` on weigh-in morning.
- Turning pro (`Roster.turn_pro` -> `ProLadder.division_for`, `CODE`, `scripts/state/ProLadder.gd:46-52`) maps `(sex, limit)` deterministically onto `w_fw / w_lw / w_wr / w_mw` or `m_fw / m_lw / m_wr / m_mw`.

Do **not** invent a weight-class selector for this task. Instead, `ClassDamage` changes the trade-off math of **five real choices the player already makes** (Depth target 7+: five genuine multi-axis choices, zero dominant picks):

### 3.2 Five Real Player Choices Moved by `ClassDamage`

1. **Which Promoter Offer or Amateur Ask Card to Accept (`ProLadder.offer_axes` / `ProFights._row` and `AskFlow.answers` / `AskPanel`):**
   - **Code hook:** Pro offers (`CODE`, `scripts/state/ProLadder.gd:195-229`) put `tune`, `above`, `payday`, and `ProLean.extra` rows on the table, trading `chance`, `place` (rank climb), `pay` (`purse + tickets`), `weeks`, and `stop` (`Matchmaking.stop_chance`). Amateur Ask cards (`CODE`, `scripts/state/AskFlow.gd:104-119`) trade `FightLearn.teach_for` (`0.0` growth if stopped, `AskFlow.gd:185`) and regional rank climb against `StopWord` (`"unlikely / possible / a real risk"`).
   - **How numbers move:** Consider a `35%` win-chance step-up (`payday` or `reach`, `+6` rating gap) against a heavy-handed opponent (`explosiveness +8`):
     - In `w_fw` / `wfw`, opponent KO share sits near ~`16%` (`ESTIMATE`), so pro `"Stoppage"` reads ~`10%` (`ESTIMATE`) and amateur `StopWord` stays `"unlikely"` / low `"possible"`. Losing mostly means a decision loss (`3–4` weeks rest, full `FightLearn` lesson, zero `durability_cap` wear).
     - In `m_mw` / `mmw`, opponent KO share against a puncher sits near ~`62%` (`ESTIMATE`), so pro `"Stoppage"` jumps to ~`40%` (`ESTIMATE`) and amateur `StopWord` flips to `"a real risk"`. A stoppage loss adds `+8` pro rest weeks (`STOP_REST_WEEKS`, `Matchmaking.gd:15`), `30 / 90 / 365` KO suspension days (`InjuryRoll.gd:13-17`), `-2.0` permanent `durability_cap` (`Attrs.STOP_DROP`, `Attrs.gd:41`), `0.0` `FightLearn` growth, `-0.8` extra rating loss (`STOP_COST`, `Matchmaking.gd:25`), and `+0.5` years career wear (`WorldAge.gd:11`).
   - **Why nothing dominates:** Ducking step-ups in `m_mw` hits `DUCKS_BLOCK = 2` (`ProLadder.gd:212`, locking out `"above"` offers) and starves gym cash; taking unscreened puncher paydays wrecks `durability_cap` and burns months on medical suspension. Conversely, playing timidly in `w_fw` wastes prime dates when tough step-ups rarely end in career-shortening KOs.

2. **Setting the Pre-Fight Towel Line and Answering the Live Towel Strip (`FightPrep.towel_row` + `TowelWire` / `TowelStrip`):**
   - **Code hook:** Before fight night, `FightPrep.towel_row` (`CODE`, `scripts/ui/FightPrep.gd:80-100`) sets `Careful (12 in 100)`, `Normal (20 in 100)`, or `Brave (33 in 100)` (`Towel.LINES`, `scripts/rules/Towel.gd:11`). Between rounds, `Towel.risk` (`Towel.gd:25-65`) simulates next-round `stop` vs `stop_safe` (`Box safe`) and triggers `TowelStrip` (`Throw the towel` = `RTD`, `14` days out, `-4` morale, zero `STOP_DROP`, zero `ko_history`; `Box safe` = softer round margins, higher `lose_safe`; `Send out` = full comeback/KO odds, full stop risk) or `coach_pull` on simmed rounds (`TowelWire.gd:79-114`).
   - **How numbers move:** After two lost rounds (`36–50` head damage):
     - In `w_fw` / `wlw`, next-round stop risk sits near ~`5–10%` (`ESTIMATE`) — below even `Careful (12%)` unless badly hurt, while setting `Careful` against a rare `Finisher` can forfeit a close 29-28 fight that would have gone the distance 90% of the time.
     - In `m_wr` / `m_mw`, one standing count + `40` head damage spikes `Towel.risk["stop"]` to ~`24–36%` (`ESTIMATE`), tripping `Careful (12%)` and `Normal (20%)` immediately while `Box safe` pulls it down to ~`13–19%` (`ESTIMATE`).
   - **Why nothing dominates:** In `m_mw`, `Careful` protects `durability_cap` and avoids a 90-day second-KO ban, **but** your boxer also carries `m_mw` `puncher_chance` power — throwing the towel in round 5 forfeits real one-shot comeback KOs when behind on the cards. `Brave` preserves two-way KO comebacks at steep chin cost; `Box safe` survives a bad round while conceding 10-9 on the cards.

3. **Allocating Game Plan Slots Between Defence Lines, Finish Lines, and Pace (`GamePlan.gd`, `PlanFight.gd`, `PaceAim.gd`, `PlanTest.gd`):**
   - **Code hook:** `GamePlan.gd` gives a finite coach-capped rule budget (`PlanBoard`) across conditional triggers (`hurt`, opponent hurt, `losing`, `ropes`, `final_round`, `any`), range (`long`, `pocket`, `inside`), tools (`guard`, `clinch`, `footwork`, `jab`, `hooks`, `uppercut`), `PaceAim`, and `CornerJobs` combo set-ups (which multiply your boxer's hurt chance by `1.6x` when a set-up or read misses in `RingDuel.settle`, `CODE`, `scripts/state/RingDuel.gd:378`). `PlanTest.run` (`CODE`, `scripts/state/PlanTest.gd:31-67`) tests the plan over 20 `BoutNight.play_out` bouts.
   - **How numbers move:** In `m_mw` / `m_wr` (`punch_mult > 1.0`), leaving `"when hurt"` without `long + guard/clinch` or running high `pace` with a risky combo set-up turns missed exchanges into hurt states (`1.6x * punch_mult`) and dominant-round `KO`s; conversely, spending a slot on `"when opponent hurt -> pocket + hooks"` converts hurt opponents into stoppages reliably. In `w_fw` / `w_lw` (`punch_mult < 1.0`), over-investing slots in `guard` / `clinch` / low `pace` gives away 3-3 exchange splits and drops 96-94 decisions where `jab`, `footwork`, and `final_round` flurry lines win fights.
   - **Why nothing dominates:** Defensive shell plans survive `m_mw` punchers on `PlanTest` yet lose points decisions to out-boxers; pocket press plans punish weak chins (`weak == "chin"`) yet bleed stoppages against counter-punchers.

4. **Answering a Fight-Week Pull-Out Replacement or Boxing Compromised (`PullOutWire.gd`, `StandDown.gd`, `CrackWire.gd`):**
   - **Code hook:** Five days before an away amateur bout, `PullOutWire` (`CODE`, `scripts/state/PullOutWire.gd:34-40, 88-106`) rolls opponent pull-outs with three answers: `Take the replacement` (unscouted rival raised to `>= old_rating + 5.0` for `2x` reputation), `Go home` (`-6` morale, `5` days wait), or `Next month's slot` (spends `1` scarce club favour to postpone `28` days).
   - **How numbers move:** Because `exp((power - chin) / 12.0)` (`Knockdowns.gd:33`) is exponential, an unscouted `+5.0` replacement multiplies raw count odds by ~`1.5x`. Combined with `ClassDamage`, `+5.0` in `mmw` / `mww` pushes stoppage loss risk past `20%` (`"a real risk"`, risking a 30-day KO ban + `STOPPED_LOSS_MEMBERS = 2` lost gym members, `BoutRules.gd:88`), making spending a club favour high-value; in `wfw` / `wlw`, the same `+5.0` jump stays near `4–9%` stop risk (`ESTIMATE`), making the `2x` reputation shot viable when chasing regional qualification.
   - **Why nothing dominates:** Club favours run out; `Go home` hurts morale and wastes fight-week prep; `Take the replacement` trades double reputation against division-scaled stoppage danger.

5. **Camp Attribute Targets and Career Perks (`WeekBoard.gd`, `Attrs.gd`, `PerkFight.gd`):**
   - **Code hook:** Weekly training and camps build `chin` (`durability`), `heart`, `guard` versus `engine`, `jab`, `footwork`, `power`, while `PerkFight` (`CODE`, `scripts/rules/PerkFight.gd:14-21`) offers `Iron chin` (negates count #1), `Finisher` (`1.5x` `stop_mult`), `Counter sense`, and `Second wind` (`+18` round-3 energy).
   - **How numbers move:** Adding `+4` `chin` cuts `exp((power - chin) / 12.0)` by `28%`. Cutting `28%` off a `40%` stoppage hazard in `m_mw` saves ~`11` points of KO risk per fight (and `Finisher` `1.5x` turns hurt rounds into finishes), whereas cutting `28%` off a `2%` hazard in `wfw` saves `0.5` points — where `Second wind`, `jab`, and `footwork` swing far more 29-28 decisions.
   - **Why nothing dominates:** Chin/power builds still lose wide decisions if `footwork` and `jab` cannot close `Duels` range (`Duels.gd`); speed/engine builds sweep scorecards until caught by `puncher_chance` in heavier classes if `chin` is neglected.

---

## 4. Headless Measurement Probe Spec: `tools/dmg_class_probe.gd`

**Status:** Specification only — **do not run Godot in this task**.

### 4.1 Closest Existing Probe to Copy
Copy **`tools/stop_word_probe.gd`** (`CODE`, `tools/stop_word_probe.gd:1-210`). It already:
- Extends `SceneTree` and parses `-- bouts=N seed=S` user CLI args (`lines 42-48`).
- Runs the **exact player bout loop** (`_fight` at `lines 154-184`): duplicates the boxer and named division opponent, sets a deterministic `c.day` seed, calls `Bouts.fight_step(c, g, m, "start")`, drains live exchanges with `Bouts.fight_step(c, g, m, "shout:")`, calls `BoutRules.auto_corner` between rounds, calls `Bouts.fight_step(c, g, m, "end")`, records `Bouts.stopped(m)` (`""`, `"RSC"`, `"KO"`, `"RTD"`), and restores `c.fighters`, `c.rivals`, `c.results`, `c.news`, and `c.day` so zero fatigue, injury, KO history, or rating drift leaks across trials.

Pair that player-bout loop with a second pass calling **`WorldBout.fast(a, b, rounds, rng)`** (`CODE`, `scripts/world/WorldBout.gd:173-204`) — the exact function `WorldSim.simulate_bout` (`WorldSim.gd:142`) and `Region._rival_bout` (`Region.gd:172`) execute — so player bouts and simulated world KO records are verified side by side.

### 4.2 Cells, Populations, and Functions Measured

Run `N = 400` bouts per cell (`ESTIMATE`, ~`6,800` player bouts + `6,800` `WorldBout.fast` bouts; runtime ~`25–45s` headless based on `stop_word_probe`'s ~`1,260` bouts in ~`6s`):

1. **9 Amateur Cells (`Bouts.rounds_of(g) == 3`, `pro = false`):**
   - Every key in `Data.DIVISIONS` (`CODE`, `scripts/state/Data.gd:136-155`): `wfw` (57), `wlw` (60), `www` (65), `wlm` (70), `wmw` (75), `mfw` (55), `mlw` (60), `mww` (70), `mmw` (75).
   - Population: build `Career.quick_start()` seeded by `base_seed` (which populates `Data.DIVISION_RIVALS` + `Newcomers` novices per division). Draw distinct legal pairs `(a, b)` (`a != b`, `abs(rating_a - rating_b) <= 8.0` matching `AmateurBooking` / club show matchmaking, plus a separate mismatch diagnostic bucket `abs(gap) > 8.0`). Convert `a` via `Data.fighter_state` (`f["towel_line"] = "normal"`) and run both:
     - `Bouts.fight_step` (with a flag logging whether `TowelWire.coach_pull` fired vs pure referee `RSC` / `KO`), and
     - `WorldBout.fast(a, b, 3, rng)` (matching `Region._rival_bout`).
2. **8 Pro Cells (`pro = true`, `4 / 6 / 8 / 10` rounds):**
   - Every division in `assets/data/world/divisions.json` (`CODE`): `w_fw` (57.0), `w_lw` (61.2), `w_wr` (66.7), `w_mw` (72.6), `m_fw` (57.0), `m_lw` (61.2), `m_wr` (66.7), `m_mw` (72.6).
   - Population: `WorldGen.new().generate_world(base_seed)` (`CODE`, `scripts/world/WorldGen.gd:36`, 45 boxers per division). Sample competitive pro pairings across the division's schedule mix (`4r` unranked/debut 30%, `6r` unranked/fringe 35%, `8r` ranked 11–20 20%, `10r` top-10/title 15% `ESTIMATE`, matching `ProLadder.ROUNDS_*` at `ProLadder.gd:36-39` and `WorldSim.rounds_for` at `WorldSim.gd:150-154`), and also print sub-tables per round count (`4r`, `6r`, `8r`, `10r`). Run both `Bouts.fight_step` (converting boxer `a` to a player pro fighter dict and `b` via `ProLadder.bout_opp`) and `WorldBout.fast(a, b, rounds, rng)`.

### 4.3 Printed Columns and Two-Pass Fitting Protocol

Per cell, `tools/dmg_class_probe.gd` prints:
```text
cell | sex | div | kg | rules | rds | path | n | count% | stop% | rsc% | ko% | rtd% | liver% | mean_dmg | sq257_lo..hi | pass
```

- **Pass 1 — Unmodified Baseline (`-- mode=base bouts=400 seed=5321`, writes `docs/DMGCLASS1_BASELINE.md`):**
  All `ClassDamage` factors equal `1.0`. Expected baseline shape (`ESTIMATE` from reading `Knockdowns.gd` and `tests/knockdowns_test.gd`): all 9 amateur 3-round cells cluster around the same class-blind ~`6% – 11%` stoppage rate, while all 8 pro cells jump together to ~`22% – 38%` across 6–10 rounds purely from round count and `damage / 60.0` compounding — with zero separation between `w_fw` and `m_mw`.
- **Pass 2 — Fitted `ClassDamage` (`-- mode=fit bouts=400 seed=5321`, writes `docs/DMGCLASS1_RESULT.md`):**
  Fit `(punch_mult, count_mult, class_stop)` per cell **against Pass 1's measured baseline**, never by multiplying SQ257 ratios blindly on top:
  1. Every cell's `stop%` on `Bouts.fight_step` and `WorldBout.fast` lands inside its Section 1 SQ257 band (with `w_mw` competitive pairs anchored in `18% – 24%` per thin-data note 1).
  2. Amateur `count% / stop%` stays within **2.0x – 4.0x** (`J_KDRATES1_JOHN.md` invariant).
  3. Clean `KO` share of stoppages (`ko% / stop%`) stays `< 15%` (`ESTIMATE`) in women's amateur (`punch_mult < 1.0` keeps 3-round head damage mostly under `KO_DAMAGE = 60.0`) and rises above `35%` (`ESTIMATE`) in men's pro welterweight/middleweight (`punch_mult > 1.0` crosses `KO_DAMAGE = 60.0` regularly).
  4. `liver%` of total counts stays inside `10% – 20%` (`LIVERPROBE1` bar in `scripts/state/LiverFold.gd:14`).
  5. Monotonicity holds strictly across every adjacent weight step (`fw <= lw <= wr <= mw`), across sex at matched weight (`f < m`), and from amateur to pro (`amateur < pro`).

Slot-runner command (for the implementation task that builds the probe — not executed here):
```bash
python ops/Tools/godot_slot.py run --who dmgclass1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --log-file tmp/dmgclass1.log --script res://tools/dmg_class_probe.gd -- mode=base bouts=400 seed=5321
```

---

## 5. Medical Rest, Stand-Downs, Injuries, and Wear Stay on the Damage Ledger

**Hard rule:** `ClassDamage` governs **only** how hard punches land (`punch_mult`) and how often counts and stoppages happen (`count_mult`, `class_stop`). Once a bout ends, healing, mandatory medical suspensions, no-sparring stand-downs, and permanent wear read **only** what happened in the bout and in the boxer's damage ledger — **never** a class or sex multiplier:

| Post-Bout Consequence | Live Code Today (`CODE`) | Class / Sex Multiplier in v2 | How Division Differences Emerge Naturally |
| :--- | :--- | :--- | :--- |
| **Head-stoppage suspension (`KO` / `RSC`)** | `Injuries.after_bout` (`scripts/state/Injuries.gd:205-225`) -> `InjuryRoll.ko_days` (`scripts/rules/InjuryRoll.gd:34-48`): **30 days** (1st), **90 days** (2nd within 90d), **365 days** (3rd within 365d), England Boxing Rule 4.1.2. | **None (`1.0x`).** | A 57 kg boxer stopped cold sits out the exact same 30 / 90 / 365 days as a 75 kg boxer stopped cold; 57 kg boxers simply suffer fewer head stoppages. |
| **Corner towel retirement (`RTD`)** | `TowelWire.pull` (`scripts/state/TowelWire.gd:105-108`) -> `Towel.PULL_DAYS = 14` days out (`scripts/rules/Towel.gd:13`); `Injuries.after_bout` (`Injuries.gd:195`) skips `InjuryRoll` and `Attrs.wear_stoppage`. | **None (`1.0x`).** | Throwing the towel saves `16+` rest days and `2.0` `durability_cap` in every division, making `FightPrep.towel_row` matter more where `Towel.risk` climbs faster. |
| **Post-bout no-sparring stand-down** | `StandDown.make(c.day, dmg, head_stop)` (`scripts/rules/StandDown.gd:25-31`): `head = 100 - dmg * 0.8` -> **5 days** (`>=55`), **10 days** (`35..55`), **21 days** (`<35`). | **None (`1.0x`).** | Because `punch_mult` scales round damage into `m["damage"]["a"]`, a brutal 75 kg war that lands `85` damage earns `21` no-sparring days while a clean `28`-damage 57 kg points bout earns `5` days — from **damage taken**, never faster healing. |
| **Distance-bout injury roll (cut, nose, head, hand, ribs)** | `InjuryRoll.bout_chance` & `bout_roll` (`scripts/rules/InjuryRoll.gd:24-60`): `0.06 * (rounds / 3.0) * (0.4 + 1.2 * s)` from worst `places` (`head`, eyes, nose, ribs) and `rounds`; layoffs `14–56` days (`BOUT_TYPES`, `line 19`). | **None (`1.0x`).** | Higher `m["damage"]["a"]` lowers `places["head"]` (`Injuries.gd:198`), nudging injury odds only when your boxer actually absorbed heavy punishment. |
| **Pro promoter turnaround weeks** | `Matchmaking.next_weeks(gap, stopped_loss)` (`scripts/rules/Matchmaking.gd:15, 279-282`): `6 / 8 / 10` weeks base + **`STOP_REST_WEEKS = 8`** (`56` days) on a stopped loss. | **None (`1.0x`).** | Stopped losses cost `+8` weeks on every pro ladder; points bouts turn around in `6–10` weeks by difficulty (`gap`). |
| **Permanent chin / career wear** | `Attrs.wear_stoppage` (`scripts/rules/Attrs.gd:41, 129-131`): `-2.0` `durability_cap` per non-`RTD` stoppage loss. `WorldAge.record_stoppage_loss` (`scripts/world/WorldAge.gd:11, 118-120`): `+0.5` years career wear and `-2.0` annual `AttrGen.age_wear` durability drop (`AttrGen.gd:169-170`). | **None (`1.0x`).** | Heavyweight/middleweight sluggers accumulate more `stoppage_losses` and `hard_fights` in `damage_ledger` over a career, aging chins faster without fake age/rest multipliers. |
| **Post-fight tiredness** | `AfterFight.book` (`scripts/state/AfterFight.gd:39`) -> `Aftermath.toll` (`scripts/rules/Aftermath.gd:22, 28-30`): energy spent in `m["energy"]` + `TOLL_STOPPED = 10.0` if stopped. | **None (`1.0x`).** | Follows actual tank spent and whether the bout was stopped. |

---

## 6. Menu and Systems Map (`Menu | CODE TODAY | TO BUILD`)

Preserved from v1's layout and corrected against every file read in the codebase:

| Menu / System | CODE TODAY (Verified `CODE`) | TO BUILD (Using `ClassDamage`) |
| :--- | :--- | :--- |
| **Fight Night — Ring, Counts & Referee** (`RingDuel.gd`, `BoutNight.gd`, `Knockdowns.gd`) | `RingDuel.settle` (`RingDuel.gd:375-378`) rolls hurt states with class-blind `(0.3 + (power - chin) / 100.0)`. `BoutNight.count_sides` (`BoutNight.gd:246-250`) sets only `PerkFight.stop_mult` (`1.0` or `1.5`). `Knockdowns.round_counts` (`Knockdowns.gd:21-70`) and `puncher_chance` (`lines 122-139`) run identical `DAMAGE_PER_ROUND`, `BASE_COUNT = 0.05`, and `REF_STOP = 0.2` across every sex and weight class. (`CounterCut.gd:20-35` is 3D punch-interrupt animation only.) | Create pure `scripts/rules/ClassDamage.gd` (`punch_mult`, `count_mult`, `class_stop`, all defaulting to `1.0` when omitted). Attach in `BoutNight.count_sides` (keeping `stop_mult` strictly for perks so `stop_mult_test.gd` stays green); read in `Knockdowns.round_counts`, `Knockdowns.puncher_chance`, and `RingDuel.settle`. |
| **World & Rival Simulation** (`WorldBout.gd`, `WorldSim.gd`, `Region.gd`, `WorldGen.gd`) | `WorldBout.fight`, `cached`, and `fast` (`WorldBout.gd:109, 160, 177`) build `_side` (`line 324`) with `{power, chin, heart}` only and call `Knockdowns`. `WorldSim.simulate_bout` (`WorldSim.gd:142`) and `Region._rival_bout` (`Region.gd:172`) call `WorldBout.fast`. `WorldGen._make_boxer` (`WorldGen.gd:153-154`) seeds `ko_share` around `0.30` regardless of `sex` or `div_id`. | Attach `ClassDamage` in `WorldBout` (`_side_for(boxer, profile)`) and `WorldBout._hurt_edge` (`lines 88-93`). Seed `WorldGen._make_boxer` initial `ko_share` around `ClassDamage.pro_ko_share(sex, div_id)` so day-one pro records match simulated world bouts. |
| **Pro Fights — Promoter Offers** (`ProFights.gd`, `ProLadder.gd`, `Matchmaking.gd`) | `ProFights._row` (`ProFights.gd:213`) displays `"Stoppage %d%%"` and `ProLadder.offer_axes` (`ProLadder.gd:229`) filters dominated offers via `Matchmaking.stop_chance(win_chance_now, opp)` (`Matchmaking.gd:272-275`), which computes `(1 - win_chance) * max(0.10, opp.ko / opp.w)` (`0.25` if `w == 0`). Decides no fights; reads flat ~30% `ko_share` in every division. | `opp.ko / opp.w` now comes from `WorldGen` + `WorldBout.fast` running `ClassDamage`; update `Matchmaking.stop_chance` to read `ClassDamage.pro_ko_share` when `w == 0` and scale the `0.10` floor by division so the shown % matches actual `BoutNight` risk. |
| **Amateur Fights — Ask for a Bout** (`AskFlow.gd`, `StopWord.gd`, `AskPanel.gd`) | `AskFlow.answers` (`AskFlow.gd:113`) calls `StopWord.word(gap)` (`StopWord.gd:20-25`) with static gap cutoffs `0.0` (8%) and `8.0` (20%); `AskPanel._answer` (`AskPanel.gd:109`) prints `"Getting stopped: <word>."` Blind to sex and weight class. | Add `StopWord.word_for(gap, shift := 0.0)` in `StopWord.gd` (**zero preloads**, `word(gap)` unchanged for `stop_word_test.gd`); `AskFlow.answers` passes `ClassDamage.amateur_gap_shift(sex, div)`. |
| **Amateur Fights — Club Offers & Bout Page** (`OfferCard.gd`, `BoutPage.gd`, `BoutCompare.gd`) | Shows `BoutRead.band` win % (`OfferCard.gd:26`, `BoutPage.gd:55`) and `BoutCompare.offer_chips` (`Strength gap`, `BoutCompare.gd:103`), with no stoppage read and fixed `f["wc"]` / `f["limit"]`. | Keep weight class fixed (no selector). Surface `StopWord.word_for` on `BoutCompare` / `OfferCard` when division + rating/power gap reaches `"possible"` or `"a real risk"`. |
| **Fight Prep & Corner Stool — The Towel** (`FightPrep.gd`, `TowelWire.gd`, `Towel.gd`, `TowelStrip.gd`) | `FightPrep.towel_row` (`FightPrep.gd:80-100`) sets `Careful (12)`, `Normal (20)`, or `Brave (33)`. Between rounds, `TowelWire.card` (`TowelWire.gd:46-66`) passes `BoutNight.count_sides` into `Towel.risk` (`Towel.gd:25-65`, 200 MC trials of `Knockdowns`). Blind to class and sex today. | Automatic once `BoutNight.count_sides` carries `ClassDamage`: `Towel.risk` runs `Knockdowns` with the division's numbers, tripping the towel earlier in heavy men's wars and keeping light women's scorecards alive. |
| **Game Plan & Sparring Plan Test** (`GamePlan.gd`, `PlanFight.gd`, `PlanTest.gd`) | Player writes conditional range/tool rules, pace, and set-ups (`GamePlan.gd`). `PlanTest.run` (`PlanTest.gd:31-67`) simulates 20 bouts via `BoutNight.play_out` (`line 47`). | Automatic once `BoutNight.count_sides` and `RingDuel.settle` read `ClassDamage`: `PlanTest` rewards `when hurt` defence in heavy divisions and volume/range scoring in lighter divisions. |
| **Fight Week — Pull-Out Card** (`PullOutWire.gd`, `FightWeekEvents.gd`) | `PullOutWire` (`PullOutWire.gd:34-40, 88-106`) offers `Take the replacement` (`rating >= old + 5.0`, `2x` rep), `Go home` (`-6` morale), or `Next month's slot` (`1` club favour) with no division stoppage read on the replacement. | Show `StopWord.word_for` on the replacement column so the player sees when `+5.0` short-notice power in `mww` / `mmw` crosses into `"a real risk"`. |
| **Fighters — Scouting & Signing** (`Fighters.gd`, `Roster.gd`, `Data.gd`, `ProLadder.gd`) | `sex`, `div`, `wc`, and `limit` are fixed on each boxer (`Data.fighter_state`, `Data.gd:261`; `ProLadder.division_for`, `ProLadder.gd:46-52`). Moving up or down a class does not exist. | Touch nothing on weight-class assignment; do **not** add a limit selector. |
| **Post-Bout Rest, Stand-Downs, Injuries & Wear** (`Injuries.gd`, `InjuryRoll.gd`, `StandDown.gd`, `AfterFight.gd`, `WorldAge.gd`) | `ko_days` (`30 / 90 / 365`), `Towel.PULL_DAYS` (`14`), `StandDown.make` (`5 / 10 / 21` from `m["damage"]["a"]`), `InjuryRoll.bout_chance` (from body places + rounds), `STOP_REST_WEEKS` (`8`), `STOP_DROP` (`2.0`), `DAMAGE_PER_STOPPAGE_LOSS` (`0.5`). | **Touch nothing.** Zero class or sex multipliers on rest, suspension, injury days, or per-stoppage wear. |

---

## 7. Ordered Follow-Up Build Slices (When Ready to Implement)

1. **`DMGPROBE1` (Measurement tool + baseline doc):** Build `tools/dmg_class_probe.gd` from `tools/stop_word_probe.gd` + `WorldBout.fast`, run `mode=base`, and commit `docs/DMGCLASS1_BASELINE.md`.
2. **`DMGCLASS1` (Core ring + world dial + fitted table):** Add `scripts/rules/ClassDamage.gd`, wire `BoutNight.count_sides`, `Knockdowns.round_counts` / `puncher_chance`, `RingDuel.settle`, and `WorldBout` (`_side_for` + `_hurt_edge`), fit the 17-cell table with `tools/dmg_class_probe.gd -- mode=fit`, commit `docs/DMGCLASS1_RESULT.md`, and pin with `tests/class_damage_test.gd` while keeping `stop_mult_test.gd`, `knockdowns_test.gd`, `bout_stoppage_test.gd`, and `towel_test.gd` green.
3. **`DMGREAD1` (Shown risk parity):** Wire `WorldGen._make_boxer` and `Matchmaking.stop_chance` to `ClassDamage.pro_ko_share`, and wire `StopWord.word_for` into `AskFlow.answers`, `BoutCompare`, and `PullOutWire` while keeping `tests/stop_word_test.gd` green.
