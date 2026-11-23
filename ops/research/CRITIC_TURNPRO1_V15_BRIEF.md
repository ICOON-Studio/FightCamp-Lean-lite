# TURNPRO1_V15 - score this mechanic's DESIGN (fresh critic, S540)

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


Measured before you: the map's probe (TURNPROBE15, 216 rolls, 5,498 careers) passed 17 of 17 bars with every audit bar. Its
verdict table is at the end, after the map. Judge whether those bars are the right ones and whether any could pass while the
mechanic stays shallow (say which, and what you would measure instead). A probe pass is not a critic pass.

If you can open the repository (main, 2026-11-23 or later; say which commit), check every CODE line in the map against the
code and list each wrong claim with the file you read. If you cannot open files, say so plainly; never guess a code fact.
Return your scores on their own line: `SCORE depth=<n> play=<n> general=<n>`.

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

# Turning pro - design map v15 (v14 with the three bars its probe failed fixed: the favour is the slot on the card, the card reads the boxer's own nights, a tune-up win makes 1)

S537, TURNPRO15 side console. Task: `ops/research/TASK_TURNPRO15.md` (v14's text is kept where v15 changes nothing; **every v15 change is in section 0a** and wins over any older line below). Scope: the pro offer, from the call to the debut and the road after it (the debut and the five sets of offers that follow: the game's "first six pro fights"). The pro ladder after that is a handoff.
Method (owner S530/S531: maps come from the code): **CODE** = file, function, lines. Section 1 carries v13's citations, which the code-checked critic opened one by one (`ops/research/DESIGN_TURNPRO1_V13_CRITIC_ARENA.md`: 75 true, 4 partial, 1 false of about 80); the false one and the partial ones are corrected below, and every line this map ADDS (the booking, the lean, the duck count, the area belt, the ask path) was opened in this session at the working tree of 22 Nov 2026. **ESTIMATE** = a proposal, a sum worked on paper, or a measured result that is not code. **CUT** = do not build or show it. **CHECK** = not confirmed. No game file was changed.
**PROBED (S537):** probe 14 read v14 at PASS 14 of 17 with bars 4, 10 and 15 failed (`docs/TURNPROBE14_RESULT.md`); v15 is the fix of those three and is measured in `docs/TURNPROBE15_RESULT.md`. No critic has scored v14 or v15.
Inputs: map v13 and its probe (`docs/TURNPROBE13_RESULT.md`, PASS 14 of 15); the two v13 critics, both 5 DEPTH / 7 DESIGN / 5 PLAY (the code-checked one above, and `ops/research/DESIGN_TURNPRO1_V13_CRITIC_JOHN_JOHN.md`); Claude's S537 decision (`TASK_TURNPRO14.md`); owner S534: mechanics need 8+ on DEPTH and 8+ on PLAY, probe first, free hand to remove, add or interconnect.

Words: the **ticket house** = Bow Lane. The **guarantee house** = Harrow & Finch. **Seats** = debut tickets the boxer sells. **The table** = the boxer's professional division table. **The name** = the gym's reputation. **A tune-up** = a pro fight the promoter offers as one (the green chip on the row); **a step up** = a ranked name above the boxer (the gold chip). **The road** = the debut and the five sets of offers after it. **Favour** = how the boxer's house feels about your gym, 0 to 10.

## 0a. What v15 changes from v14 (the three bars probe 14 failed; ESTIMATE, sized by probe 15)
What a real promoter does: he puts the trainer who takes his fights on the better nights and freezes out the one who refuses.
1. **The favour is the boxer's slot on the house's card** (bar 15: v14's favour worked backwards, the rebel ended $1,036 to $1,383 better and the keeper gained nothing).
   - **Top of the bill, favour 8 or more** (both houses): the house hands the gym a block of tickets for the fight, **$250 to the gym a fight**. On top, as v14: the guarantee house pays $300 more a purse; the ticket house brings the area title shot after 4 pro wins.
   - **Bottom of the bill, favour under 3:** the house dates the fight **3 weeks later** than it would ("when a slot is free"). Nothing else: the purse, the kinds on the table and the offer days stay.
   - **CUT: "under 3 the house brings only its own kind" and "offers stand 4 days".** Being made to book the house's kind was a help, not a price (probe 14, stage F).
   - The slot is read when the fight is booked, from the favour before that booking moves it. Favour moves as v14 (+1 the house's kind or the title, -1 the other kind when the house's was on the table).
2. **The card reads the boxer's own nights** (bar 4: v14's card under-read some boxers by 8 to 14). When a house calls, the game quietly plays this boxer's debut ahead, camp included, against two of the house's possible debutants (one the plain read puts at 72, one at 50), 500 nights each. What those nights add to the read, on a straight line between the two, goes on every card of that house for this call. v14's flat lift ("+0.2 of every point over 60") is CUT. Both debutants a house names are then searched on that card, so "60" means this boxer wins about 60 of 100. **CHECK for the build:** the cost of 2,000 quiet bouts when the call arrives (spread over the days the call stands, or fewer nights behind a wider band).
3. **A tune-up win makes 1 reputation, not 2** (bar 10: the name-chaser's lead was 2.3 to 2.8 where the bar asks 3). A number change; the step up, payday, title and rebuild win stay at 5.
4. **The bots** (not the design): the favour-keeper books the house's kind until the favour is 9, then the other kind, so it stays at the top of the bill; it takes the title shot when the read is 45 or more. The name-chaser and win-chaser are v14's.
5. **Bar 15 is read more strictly than in probe 14** (fixed before the run): the keeper's line must be a GAIN, the rebel's a LOSS, and neither may have a line the other way. Bar 4's "own nights" are 1,000 scratch nights a boxer (v14: 200), a finer ruler on the same line of 8. The other bars and every line are probe 14's.

## 0. What v14 changes from v13, in seven lines
Both critics put the same item first: under v13 the house decided the kind of every fight after the debut, so the road played itself and the whole mechanic was ONE decision (which house), which the gym's room answered. v14 keeps the fork and gives the road to the player.
1. **The kind is the player's.** Every set of the road carries a tune-up AND a step up, at both houses. The house still sets the aims, the purse, the date and the split; it no longer removes a kind. v13's "firm road" is CUT.
2. **A fight's name follows its kind, and the booking keeps the kind.** Tune-up win +2 reputation; step up, payday or title win +5; a rebuild fight after a loss +5 (v13 paid it +2: a second fine on the loss); a named opponent the player asks for is a step up (+5).
3. **House favour, 0 to 10** (starts at 5). Each house prefers a kind (the ticket house step ups, the guarantee house tune-ups: the lean the code already has). Booking the house's kind +1, the other kind -1. **At 8:** the ticket house opens an area title shot once the boxer has 4 pro wins; the guarantee house pays $300 more a purse. **Under 3:** offers stand 4 days, not 7, and the house brings only its own kind until the favour is back at 3.
4. **The favour replaces the duck count on the road.** Today a tune-up taken while a step up is on the table is a hidden "duck" (two stop the step ups). On the road the favour is that patience, shown as a number.
5. **Pick the debut night.** Each house names two debutants, one to build your boxer (an easier night) and one to test (a harder night that makes a name), both found by the game's own search and both shown with their card. The house's own choice is +1 favour, the other -1.
6. **No per-house debutant style.** Every debutant is the game's own (v13's probe measured a boxer nobody was going to build).
7. The probe is probe 13 again on the same population and pairing, with bots that read the +2 / +5 line (a name-chaser, a win-chaser, a favour-keeper), probe 13's bars 10 and 15 merged into one, and bars 7, 8 and 11 rewritten for the new choice.

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
- **CODE - `scripts/rules/DebutOpp.gd` consts :15-17, `name_for` :22-24, `rating` :32-33, `make` :37-41:** every debutant is a 0-0 "Boxer-puncher" with "Heavy right hand" and "Fades after round 3" (one set of constants for both houses), rated the boxer's no-camp strength less the gap. By house only the name, the gap and the club line ("(house) stable", :39) differ; the name list is by sex. **v14 keeps this: no per-house style** (v13's probe gave each house its own style; that is dropped).
- **CODE - `scripts/rules/BoutRead.gd` `_read_copy` :272, `_games` :277-280, `_tiring` :301, `_round_edges` :328, :337:** the read does use the opponent's style (the mix of games, and the plan the coach writes against that style) and three scouting words ("walks in", "Fades", a body threat). So a different style per house would change the bout, with no new system.
- **CODE - `Roster.turn_pro` :305-309, `debut_day` :319-320:** signing books that debutant for the Saturday `debut_weeks` out, 4 rounds; the rating is taken from the boxer's stats on the signing day.
- **CODE - `scripts/state/ProLean.gd` `LEAN_FIGHTS` :7, `LEAN_KIND` :8, `extra` :12-33; `scripts/state/ProLadder.gd` :23-25, :204-214:** for the first 6 pro fights, **the debut counted** (`pro_fights` = pro_w + pro_l + pro_d, :36-37), so the debut and the five sets after it, the house ADDS one row to each set of offers: a second tune-up (nearest a read of 0.82, inside 0.70-0.93) for the guarantee house, a second step up (nearest 0.50) for the ticket house. The plain set (one tune-up, one step up, one payday) is still there, so the lean widens the choice; it never forces a fight.

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
- **CODE - `scripts/rules/FighterProfile.gd` :25, `scripts/rules/AskDates.gd` `wait_words` :119-122:** "month_no_fight: -6" is READ once, as words: the asks screen says "A month without a fight costs 6 morale", and nothing applies it (v13 said "no caller": FALSE, found by the code-checked critic). It is not part of turning pro: **dropped from this map**; the one-line fix (cut the sentence, since no rule stands behind it) is build order item 0.

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

### The lines v14 builds on (CODE, opened in this session)
- **CODE - `scripts/state/ProLadder.gd` `book` :337-368:** the booked fight is written at :360-362 with opponent, day, rounds, purse and `ladder` (the opponent's id) and NO kind. Nothing after the booking knows whether it was a tune-up. `book` does not check that the opponent was on the table (any id on the division table books when `asked` is false).
- **CODE - `ProLadder._make_offers` :175-216:** one tune-up (read nearest 0.82 inside 0.70-0.93), one step up (a ranked name the boxer may ask for, read nearest 0.50), one payday (a top-10 name read 0.20-0.45). The step up is left out while the boxer rebuilds or after two ducks (:209). A row beaten on every axis by another is dropped (`_drop_dominated`). So a set can already lack a kind.
- **CODE - `scripts/state/ProLean.gd` `LEAN_KIND` :8, `extra` :12-33:** the kind each house leans to is already data: `{"hf": "tune", "bow": "above"}`. **This is the kind the house prefers; v14 adds no new table.**
- **CODE - `scripts/rules/Matchmaking.gd` `note_choice` :196-201, `DUCKS_BLOCK` :39, `ask` :190; called from `ProLadder.book` :354:** booking a fight more than 2 rating points softer than an offered step up is a duck (not while rebuilding); a harder pick clears the count; two ducks stop the step ups (`_make_offers` :209) and refuse an ask for anyone not rated above the boxer (:190). The count is shown only in the row's "duck" line (`ProLadder.stakes`).
- **CODE - `ProLadder.ask_rows` :321-333; `scripts/ui/ProFights.gd` :126, :142, :300; `scripts/ui/BoutActs.gd` :197-200:** the player can NAME an opponent ("OR NAME YOUR OPPONENT"): anyone ranked above, inside the band (`Matchmaking._in_band` :324-331: an unranked boxer may ask from #15 down). An asked fight is booked with `asked` true and carries no kind either.
- **CODE - `scripts/world/WorldRank.gd` `BELT_LEVELS` :5, `champion_of` :164-168; `Matchmaking._take_belt` :303-311 (called :244); `ProLadder.book` :356-357, `ROUNDS_TITLE` :36:** every division table has an AREA champion (the lowest of four belt levels). Beating a belt holder takes the belt; a fight against one is 10 rounds. Today an unranked or low-ranked boxer cannot be offered the area champion unless the champion happens to sit inside the band.
- **CODE - `ProLadder.OFFER_DAYS` :31, `day_events` :134-137:** a set stands 7 days; a lapsed set is "the promoter will call again next week".
- **CODE - `scripts/state/Bouts.gd` :261:** a pro bout can never be a short-notice swap, so "a short-notice tune-up win" (v13's state test) cannot happen: CUT from the tests.
- **CODE - `scripts/rules/DebutOpp.gd` `name_for` :22-24:** the debutant's name is picked from a list of four by the day and the house name's length. A second debutant for the same house is the next name on the list.

## 2. The human question (the brief)
A manager with a new pro picks each early opponent with the promoter - "keep your boxer busy" against "test your boxer" - and keeps the promoter sweet so the good dates keep coming. The money is the boxer's; the club's gain is the name.

## 3. The three decisions (ESTIMATE; the probe of section 9 sizes every number)

### 3a. The house (v13's fork, kept)
| | The ticket house | The guarantee house |
|---|---|---|
| Calls when | the gym sells 46+ seats (CODE `ProCall.who_calls` :63-69) | the gym sells 74 or fewer |
| The debut | 4 weeks out; its own night is the TEST | 6 weeks out; its own night is the BUILD |
| The kind it prefers | step ups (CODE `ProLean.LEAN_KIND` :8) | tune-ups |
| Its door at favour 8 | an area title shot once the boxer has 4 pro wins | $300 more a purse |
| The money | the purse as today. Shown small, said honestly, not a lever | the same |

### 3b. The debut night (NEW: the player picks one of two)
| | Test | Build |
|---|---|---|
| The ticket house | the card reads about 60 in 100 (today's aim, CODE `DebutPick.AIM` :15). A win: +5 reputation **and +1 for every 4 seats sold on the night (20 at most), and the table's last seat**. Favour +1 | the card reads about 70. A win: +5 reputation. Favour -1 |
| The guarantee house | the card reads about 68. A win: +5 reputation **and +1 for every 8 seats sold (20 at most)**. Favour -1 | the card reads about 78 (owner: "78 is fine"). A win: +5 reputation. Favour +1 |
| A loss, either night | reputation -2 (-4 stopped) as today; a rebuild fight before any step up; fans by how it looked (CODE `Matchmaking.loss_fans` :290-291) | the same |
- Both debutants come from `DebutPick`'s own search (CODE `pick` :48-67) run twice on the card of section 5, once at each aim; the house's misjudgement for this boxer (`target` :34-36) moves both alike, so they stay about 10 points apart. Both are the game's debutant (CODE `DebutOpp` :15-17): the same style, threat and weakness, a different name (`name_for` :22-24, the next name on the list) and a different rating.
- "Seats make the name" now belongs to the NIGHT, not the house: it is what a test is for. The guarantee house's test pays half the ticket house's (it sells the night on its guarantee, not on your seats).
- Owner ruling Q-286 ("Pick to each boxer") holds: the promoter still picks each debutant to this boxer; the player picks between the two it found. The ruling "the debutant it picks does not change" holds for each house's OWN night (60 and 78 on the card).

### 3c. The kind of each fight on the road (NEW: the player's, at both houses)
- **Every set of the road carries a tune-up and a step up.** The promoter's set is made as today (CODE `ProLadder._make_offers` :175-216, the house's lean row added by `ProLean.extra` :12-33). Where it lacks a tune-up, the nearest one the table holds is added (the tune band widened from 0.70-0.93 to 0.60-0.97); where it lacks a step up and the boxer is not rebuilding, the ranked name read nearest 0.50 is added. A payday stays when the promoter has one.
- **No kind to be found:** the set says so in a line ("No tune-up this time: nobody suitable is free") and booking the other kind is not a refusal. A set with no row at all is today's lapse (CODE `day_events` :134-137: the promoter calls again in a week). Never a silent change of the rules.
- **After a loss** the game's rule stands: no step up until a rebuild win (CODE `_make_offers` :209, `Matchmaking.ask` :188-189). The tune-ups of that set are REBUILD fights: a win pays +5 and moves no favour.
- **The name a win makes** (the booking keeps the kind: `ProLadder.book` :360-362 gains `kind`; `BoutFinish.gd` :98 reads it):

| The fight booked | A win makes | Favour, ticket house | Favour, guarantee house |
|---|---|---|---|
| Tune-up | +1 reputation (v15; v14 +2: "an easy win is not news") | -1 | +1 |
| Step up (offered, or a name the player asks for) | +5 | +1 | -1 |
| Area title shot | +5 and the belt | +1 | - |
| Payday | +5 | 0 | 0 |
| Rebuild fight | +5 | 0 | 0 |
The members (+8), the purse and the fans are as today. A refusal (-1) counts only when the house's kind was on the table.
- **What already pulls the two kinds apart** (CODE, unchanged): a tune-up is read near 82 in 100, the next fight comes 6 weeks later, it moves no place and a mismatch 6 points under costs the win one fan (`Matchmaking.apply_result` :242, `next_weeks` :283-285); a step up is read near 50, takes the beaten boxer's place (a ranked purse: $1,500 + $400 a place, `pay_of` :216-225), earns a fan more, and the next fight is 12 weeks later. v14 adds the name (+2 against +5) and the favour.

### 3d. House favour (NEW)
- **One number a boxer, 0 to 10, starting at 5**, kept on the fighter with the house. It moves by 1 on the debut night picked and on every fight booked (the table above).
- **v15: the favour is the slot on the card** (section 0a, item 1; v14's two bullets here are replaced).
  - **Top of the bill (8 or more):** $250 to the gym a fight (its block of tickets) at both houses; the guarantee house also pays $300 more a purse (the boxer's money); the ticket house also carries the division's AREA CHAMPION as a TITLE row once the boxer has 4 pro wins (CODE `WorldRank.champion_of` :164-168; 10 rounds, `ROUNDS_TITLE` :36; a win takes the belt and the champion's place, `Matchmaking._take_belt` :303-311).
  - **Bottom of the bill (under 3):** the fight is dated 3 weeks later (CODE today: `ProLadder.book` :360 sets the day). Both kinds stay on the table.
- **On the road the duck count sleeps** (CODE `Matchmaking.note_choice` :196-201): the favour is the promoter's patience there, and it is on the screen. After the sixth pro fight the duck rule runs as today; the favour and its two thresholds stay.
- Why this is depth and not a second meter: the kind's value now depends on the moment. A tune-up is worth 2 reputation and a safer record; at the guarantee house it is also a step toward the top of the bill; at the ticket house it is a step toward the bottom of it, and later dates. A boxer coming off a hard night, a gym with no room for the name, a title shot two wins away: each changes which kind is right.

## 4. The asks (ESTIMATE; v13 unchanged)
| House | Ask | v14 |
|---|---|---|
| Both | **Later +2 weeks** | kept as v13: $150 off the purse (CODE `ProCall._apply_later` :197-201), the card shows about +2. A calendar tool. **It is drawn only when the boxer has a cause it fixes** (an injury or a weight still to make on the debut day); with no cause the offer has no ask (v13 critic: "one button plus dead numbers is worse than no button") |
| - | Softer, own ticket price, costs from the purse, better split, later +4 | **CUT** (probes 11 and 12; the pick of the debut night is what "softer" was reaching for) |

## 5. The read, the seats, the hold (ESTIMATE)
- **v15: the card reads the boxer's own nights** (section 0a, item 2), replacing the +0.2 lift in the next line. **The card shows what plays** (v13): `DebutRead.card` (CODE :17-24) gains +1 point for every week of `debut_weeks` over 4 and +0.2 of every point the read stands over 60. Each card prints a band, not a point ("about 60, 56 to 64"): stage A reads each boxer's own card against that boxer's own nights (v13 checked the mean of six).
- **Seats on the night** (kept): one dashed number on the ticket bar, drawn on the TEST nights only (it is what a test win pays on).
- **The room, as arithmetic** (v13 critic: the old room line printed the answer): "Room for N more members. 3 reputation brings about 2." No sentence telling the player which house to pick.
- **The hold, Stay amateur, the honest ledger, names only in headers:** v13's, unchanged.
- **The purses are equal on the card.** The guarantee house's $1,800 against $1,500 decided nothing in three probes ($104); v14 shows the boxer's take on each night and leaves the constant alone (no test moves).

## 6. The v13 critics' lists, item by item
| # | Critic's item | v14 | Where |
|---|---|---|---|
| A1, J1 | Give the player the kind on every set; the probe bot reads +2 / +5 | **Taken whole** | 3c, 9 |
| A2 | Let the player pick the debut night; styles in or out | **Taken; styles out** | 3b |
| A3 | Make the name worth something in a full gym, or make room cheap | **Not taken in v14.** The full cell is measured again; the arithmetic room line replaces the instruction. The premises are another map's | 5, 9 |
| A4 | Price the fork in members, not dollars | **Taken on the screen** (the room line; the cash rows go) | 5, 7 |
| A5 | The card honest per boxer, with a band | **Taken** (bar 4 is per boxer now) | 5, 9 |
| A6 | An asked fight must have a kind | **Taken:** an asked name is a step up, +5, and counts as one for the favour | 3c |
| A7 | Pair the debut loss, or drop the sentence | **The sentence is dropped.** Bar 12 stays as an unpaired reading and the map quotes no cost from it | 9 |
| A8 | An answer for an empty set | **Taken** | 3c |
| A9 | Cut the dead ink; give the one ask a cause | **Taken** | 4, 5, 7 |
| A10 | Three bot arms on the same rolls | **Taken** (name, win, keeper) | 9 |
| A (2.6.2), J8 | The rebuild fight should not pay +2 | **Taken:** +5 | 3c |
| A (FALSE) | `month_no_fight` is read by the asks screen | **Dropped from this map;** the fix is build item 0 | 1, 11 |
| J2 | A favour score 0 to 10 a house | **Taken**, with the S537 numbers | 3d |
| J3 | One switch of house after fight 3 | **Not in v14** (S537: only if the probe says the fork still solves itself) | 9 |
| J4 | The boxer's wish, from Confidence and Heart | **Not taken** (v11 cut the wish: no goal in the game reads it) | 12 |
| J5 | Fix the numbers and words | **Taken:** "+5, and +1 for every 4 seats"; no "hall"; "your boxer"; the name does NOT pay back the cash by week 40 and the map no longer says it does | 3, 7 |
| J6, J7, J9, J10 | A same-year debutant on the other road; an open night for seats; fewer seats after a debut loss; a one-click move | **Not taken:** each is a new system; the scope rule waits for the road to feel right | 12 |

## 7. Where it appears: CODE TODAY against TO BUILD (every menu the mechanic shows on, and what each is wired to)
| Menu | CODE TODAY (file, function, lines) | Wired to today | TO BUILD (ESTIMATE unless CUT) |
|---|---|---|---|
| Top bar flag | `Needs.flags` :167-168 | red PRO OFFER, act "prooffer" | amber; days left |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83 | `Needs.blockers` :140-141 | runs while the offer is held; one stop on the last day |
| Home, needs | `Needs.needs` :67-70, `_pro_line` :199-206 | act "prooffer", "Hear it" | amber; roles, not names |
| **The offer letter: header** | `scripts/ui/modals/ProOffer.gd` `build` :35-45 | `ProOfferWire.days_left`, `ProCall.age_line` | unchanged |
| **The offer letter: ticket bar** | `ProOffer._tickets` :90-106, `ticket_parts` :211-225 | one mark at 60 | both marks; seats on the night (dashed) with the hover "A test night won is worth 1 reputation for every 4 seats (ticket house) or 8 (guarantee house)" |
| **The offer letter: house card** | `ProOffer._house` :110-170 | `DebutRead.card`, `DebutPick.line/tip`, `ProOfferWire.money` | head THE TICKET HOUSE / THE GUARANTEE HOUSE; one role line ("prefers step ups; at favour 8 an area title shot after 4 wins" / "prefers tune-ups; at favour 8 $300 more a purse"); **the two DEBUT CARDS** (next row); "A loss: a rebuild fight first"; the room line as arithmetic; the boxer's take on the night. CUT: the three gym money rows, step/top, weekly-after, pays-back, "+N loyalty", the $1,800 against $1,500 as a lever |
| **The debut card (two a house, NEW)** | none (one "VS (name)" line, `ProOffer._house` :139-143; the picked line `DebutPick.line` :88-91) | `DebutPick.apply` :71-78 keeps one `opp_gap` a house | a pair of cards inside each house card, one picked: the debutant's name, TEST or BUILD, the win chance as a band, "A win: +5 reputation" or "+5 and +1 for every 4 seats: about +N tonight, and the table's last seat", "Favour +1" / "-1". Wired to: two picks kept on the offer (`opp_gap_test`, `opp_gap_build` from `DebutPick` at the two aims), the chosen one written by a new act "propick" (house, night), read by `Roster.turn_pro` :305 when it books the debut |
| **The offer letter: asks** | `ProOffer._ask` :174-195; acts "proask", "proplain" (`scripts/ui/RosterActs.gd` :96-104) | six buttons a house | Later +2, drawn only with its cause. CUT the other five |
| **The offer letter: foot** | `ProOffer.build` :56-81; acts "turnpro" (`RosterActs.gd` :90-95), "declinepro" (`RosterActs.gd` :105-108) | `ProOfferWire.morale_line` | the table pick of the weight (section 8); Stay's true hover; "Sign with this house" |
| **Fights (pro): the head of NEXT FIGHT** | `scripts/ui/ProFights.gd` :117 (`ProLean.line` :41-47, the house's name in the body) | the lean's sentence | **the favour**: ten pips and one line by state - "The house wants a step up. Favour 6 of 10: at 8 it opens an area title shot (4 pro wins needed, you have 2)" / "Favour 2: the house brings only tune-ups until you take one. Offers stand 4 days". Roles, not names. Wired to the fighter's `pro_favour` |
| **Fights (pro): each row** | `ProFights._row` :155-163 (the kind chip from `KIND_WORD` :21) | `ProLadder.offer_rows` (kind from the offer) | beside the chip: **the name a win makes ("+2 reputation" / "+5") and the favour it moves ("favour +1" / "-1")**; a new TITLE chip and a REBUILD chip; the house's kind marked "the house's pick". The duck line is not drawn on the road. Wired to the row's `kind`, which `ProLadder.book` :360-362 now keeps on the bout |
| **Fights (pro): name your opponent** | `ProFights.gd` :126, :142, :300; `ProLadder.ask_rows` :321-333 | act "probook" with "a" (`scripts/ui/BoutActs.gd` :197-200) | each asked row reads STEP UP, "+5", and its favour move: an asked fight has a kind |
| Fighter, Next Step | `scripts/ui/areas/FighterPage.gd` :338, :344, :355-357; `scripts/rules/NextStep.gd` `road` :50, `pro_line` :73-90 | tickets against each house, age, declines left | "Offer open, N days"; for a pro: the favour and the next door ("2 more step ups open the title shot") |
| Fighter, contract | `FighterPage.gd` :144 | fixed text | the pro share, the house and the favour |
| Week review | `scripts/ui/ProWeekLines.gd` `lines_for` :15-42, `rows` :62-75 | `f["pro_signed"]` | "seats now N (N at the call)"; after every pro fight the reputation line names the kind ("Tune-up win: +2 reputation") and the favour ("Favour 7 of 10"); CUT the NEXT promise and the $75 line |
| Debut result | `scripts/state/BoutFinish.gd` :94-116; `Roster.debut_words` :254-261 | members, reputation, the pay label | the night picked (TEST / BUILD), the name by seats and the last seat after a test won; "a rebuild fight first" after a loss; the true share |
| Pro fight result (every later pro fight) | `BoutFinish.gd` :94-98, :170 | +8 members, +5 reputation on any win | the rank earned (S428), the name made by the kind, the favour after it; a title won shows the belt |
| World, the pro table | `ProLadder.road` :423-438 | rank, fans, the rebuild line | the last seat after a test won at the ticket house; the area champion marked when the title shot is open |
| Money, stipends; World compare; Office desk; History; Toasts; Test jump | as v13's table (`MoneyPanels` :264, `WorldCompare` :269, `OfficeDesk` :39, `BoutHistory` :45, `RosterActs` :95, `TestJump` :195-197) | as v13 | none, but roles in place of names in toasts |
Not reopened this session and not claimed: the top bar's drawing code, the home list's ordering, the week review modal's call site, the roster table, the world news feed.

## 8. The weight class at turning pro (a hook only)
Owned by WEIGHT2. The table pick appears on this call, in the offer's foot (CODE `ProLadder.division_for` :43-49 gives the table today). The probe runs every boxer on the table the code gives.

## 9. The probe (run in this task: `tools/turnprobe15.gd`, rules copy `tools/turnprobe15_rules.gd`, tables `tools/turnprobe15_sum.py`, result `docs/TURNPROBE15_RESULT.md`)
- **Population and pairing: probe 13's.** The six people the game can sign, each played from signing to the first pro call, then called on 37 different weeks: 222 rolls. A boxer's call week is one roll (a bout's dice are the fight day's).
- **Cells.** The gym on the day of the call: seats 48 and 64 with room for more members, and a full gym (members at the cap, a name that draws 10 more). $12,000 in the bank. (Probe 13's 56 cell read the same as 48 and 64 on every row and is left out.)
- **An option** = house x debut night x road bot. The bots read the kind chip and the +2 / +5 line: the **name-chaser** books the step up (the title when it is there), the **win-chaser** the tune-up, the **favour-keeper** the house's kind until the favour is 9 and then the other kind (v15: it stays at the top of the bill; it takes the title shot read at 45 or more). Eight options a cell: each house's own night with the three bots, and the other night with the keeper.
- **v15's run:** the same six boxers on 36 call weeks each (216 rolls) in stage B; stage A on 1,000 scratch nights a row; stage F on 36 rolls (6 call weeks a boxer, all six boxers; probe 14 read 36 rolls of three boxers), one Godot run a boxer.
- **Arms.** V15 = sections 0a and 3 to 5. TODAY = the game's own functions with probe 13's bot (the row read nearest 65), in two cells; its costs ask is the MUTANT (+$909). FLAT = v14 with the tune-up rule off (the win-chaser, same rolls). **Stage F** (the favour): to week 80 on 72 rolls, each house's keeper and its full rebel (the other night, the other kind), with the favour's rules on and off.
- **Three pass rules, lines fixed before the run.** A beats B when ahead by the line on one axis and not behind by the line on any other. THE HOUSE: gym cash $1,000, debut wins 3 in 100 (probe 13's). THE ROAD (three bots, one house): gym cash $1,000, the name 3 reputation, the record 1 pro win less loss. THE NIGHT (test against build): cash $1,000, debut wins 3, the name 3.

| # | Bar (bounds, never an exact count) |
|---|---|
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell |
| 3 | Played debut wins in 100: ticket test 52 to 68, ticket build 62 to 78, guarantee build 70 to 82, guarantee test 60 to 76 |
| 4 | The card is honest: each of the four debutants shown within 3 of played on the mean, AND no boxer's card more than 8 from that boxer's own nights (v15: 1,000 of them) |
| 5 | The house is a trade somewhere: the ticket house (test, keeper) $1,000+ ahead and 3+ debut wins behind the plain guarantee house (build, keeper) in at least one cell |
| 6 | The house flips: the plain guarantee house beats it in at least one cell |
| 7 | AUDIT (the kind; rewritten): inside a house no road is the one answer in more than 6 of 10 house x gym cells |
| 8 | AUDIT (the kind; rewritten): every road is right in at least one house x gym cell, AND in at least half of them two roads differ by a line on some axis |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 debut wins |
| 10 | The name is the kind's (probe 13's bars 10 and 15 were one fact; merged): with the tune-up rule off the win-chaser ends 1+ reputation higher in every cell with room, AND with it on the name-chaser ends 3+ reputation ahead of the win-chaser in the same house in every cell with room |
| 11 | Boxer by boxer (boxer x house x gym; rewritten): no road the one answer in more than 6 cells of 10, every road right in at least 2 |
| 12 | A debut loss leaves a mark: $1,000+ of cash or 20+ points of ranked share behind the same option's wins (not paired: a reading; the map quotes no cost from it) |
| 13 | Inside one house two bots book different kinds: step ups are 25+ points more of the name-chaser's bookings than of the win-chaser's, at each house |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 |
| 15 | The favour moves the result (stage F, the favour's rules on against off, same rolls): a line on some axis ($500 of gym cash, 3 reputation, half a win less loss) for a keeper in at least one house AND for a full rebel in at least one house (v15, stricter: the keeper's line a gain, the rebel's a loss, neither with a line the other way) |
| 16 | The debut night is a trade: in at least one house x gym cell the test is 3+ debut wins behind and 3+ reputation or $1,000 ahead, and neither night is the one answer in more than 6 of 10 of them |
| 17 | Both kinds are on the table: 80%+ of the road's sets that are not rebuild sets carry a tune-up and a step up, at each house |
**PASS = 14 or more of the 17, with bars 7, 8 and 9 all passing** (probe 13's share: 12 of 15). Then two fresh critics (one code-checked), 8+ on DEPTH and 8+ on PLAY (owner S534), before the owner's board.
- **If it fails:** the result says which lever broke and it goes back to Claude. A fourth round under 8 is a cut-or-keep question for the owner (`TASK_TURNPRO15.md`).
- **What no bar can show:** the bots follow fixed rules; they do not read the boxer's form, the gym's room or a title two wins away. Whether a PLAYER feels the choice is the critics' and the play test's.
- **State tests for the build:** last day and reload; a double press on Sign; the night picked then the house changed; an old save's offer with one debutant a house (it keeps today's terms); a debut loss then the first set (no step up, REBUILD chips, +5); a set with no tune-up to be found (the line, no favour move); favour at 0 and at 10 (clamped); the title row when the area belt is vacant (not drawn) or the boxer holds it; an asked name books as a step up; a tune-up win pays 1; favour 8 then a booking (the $250 block, once); favour 2 then a booking (the date 3 weeks later, both kinds still there); an old save's booked pro fight with no kind (pays 5).
- **Golden path:** call, pick the test night, sign, debut, the name and the seat on the result page, the first set with both kinds and the favour pips, one tune-up win and its "+2" line in the week review, the favour line after it.

## 10. Owner rulings kept
- The debut opponent is picked to each boxer (Q-286): `DebutPick` stays the one search, run at two aims.
- The guarantee house about 75 in 100, "78 is fine": its own night is the build at 78 on the card.
- Names only in headers (S448). Only actionable information (C443): no gap, no aim, no assumed weekly figure; the favour is shown because every booking moves it.
- Tooltips explain (S532): the "+2 reputation" hover says why ("an easy win is not news") and what the name is for; the favour hover says what opens at 8, what closes under 3, and what the player can do about it.
- Every fight shows the rank earned (S428): the name made and the favour sit beside it.
- Amateur bouts need no camp (S428): untouched. The normal game starts with no boxer signed (S487): untouched.
- Board text short. The one line for his board, after the probe and two critics at 8+: "Turning pro: you pick the night, then the kind of every fight. Keep the house sweet or go your own way. OK to build?"

## 11. Build order (ESTIMATE; nothing here is built)
0. `AskDates.wait_words` :119-122: cut "A month without a fight costs 6 morale" (nothing applies it). One line, its own commit.
1. The hold (v10): amber, daily lapse, the booking guard, the loyalty pause. Red test first: Continue with an open offer must advance the day.
2. The card shows what plays, with a band; **two debutants a house** (`DebutPick` at two aims, the picks kept on the offer, the act "propick"). Re-run DEBUTPICK1's 22 cells per boxer.
3. The debut counts on the table: fans, the rebuild flag (`ProLadder.result` :376-378 no longer returns early for the debut); a test won: the name by seats, and at the ticket house the last seat.
4. **The kind on the bout:** `ProLadder.book` keeps `kind` (offered row, "above" for an asked name, "rebuild" after a loss); `BoutFinish.gd` :98 pays 2 for a tune-up win.
5. **Both kinds on every road set** (the two fill-in rows, the "nobody suitable" line); CUT v13's firm road. The duck count off for the first six fights (`Matchmaking.note_choice` skipped while `ProLean.pro_fights` < 6).
6. **The favour:** `pro_favour` on the fighter; +1 / -1 at the debut pick and in `book`; the title row at 8 with 4 pro wins (ticket house); +$300 a purse (guarantee house); under 3 the 4-day set of the house's kind.
7. The asks: CUT five; Later +2 only with a cause.
8. The screens of section 7: the debut cards, the favour head, the row line, the result and week-review lines.
Tests that pin today's numbers and will move: `tests/pro_call_test.gd`, `tests/pro_offer_wire_test.gd`, `tests/debut_pick_test.gd`, `tests/debut_read_test.gd`, `tests/pro_ladder_test.gd` (the debut on the table, both kinds, the favour), `tests/matchmaking_bots_test.gd` if it reads ducks inside the first six fights, and any test that reads +5 reputation after a tune-up win.

## 12. Cut list
- **CUT in v14 -** v13's firm road (the house removing a kind); the per-house debutant style; "the name pays back the cash by week 40"; the cost of a debut loss as a quoted number; the room line as an instruction; the three gym money rows on the house card; the duck line on the road; the short-notice tune-up state test; the "+5" printed on every row as the only number (each row now carries its own).
- **Not taken from the critics (each a new system) -** switching house after fight 3; the boxer's wish; a same-year debutant on the other road; an open night for seats; fewer seats after a debut loss; a one-click move to bigger premises.
- **CUT, kept from v13 and before -** every ask but Later +2; the $1,400 guarantee purse; the forgiven loss; loyalty from the boxer's pay; the wish; "won't" buttons; the step and top promise; the assumed $75 a week and the pays-back sentence; a dollar rate for morale or loyalty; the new fees and the manager's licence; a stipend switch on the hold; v9's loan, queue and versioned contract pay; raising the aims of each house's own night.

# THE PROBE'S VERDICT (docs/TURNPROBE15_RESULT.md, bars only)

Rolls: 216. Careers played and counted, stage B: 5498 (v15 4048, v15 with the tune-up rule off 580, today's rules 870). Stage F (the favour, 80 weeks): 864 careers on 36 rolls. Cells skipped because one house called alone: 142.
| 64 | 216 | +943 | 14 | +0.0 |
| 48 | guarantee build keeper | 216 | 75 / 18 / 7 | 65 | +0.0 | -12839 | 59 | 9.9 | 70% | +4.5 | 4.38 - 0.25 | 5.1 | 19 / 77 / 4 / 0 (0.0) | 2.88 | 8.7 | 5 | 65 | 21% |
| 48 | guarantee build name | 216 | 75 / 18 / 7 | 65 | +0.0 | -12533 | 60 | 14.5 | 91% | +4.7 | 3.23 - 0.66 | 4.2 | 87 / 0 / 13 / 0 (0.0) | 0.00 | 2.6 | 6 | 66 | 16% |
| 48 | guarantee build win | 216 | 75 / 18 / 7 | 65 | +0.0 | -12975 | 58 | 7.7 | 68% | +4.1 | 4.61 - 0.17 | 5.2 | 0 / 97 / 3 / 0 (0.0) | 3.76 | 9.8 | 5 | 65 | 23% |
| 48 | guarantee test keeper | 216 | 67 / 23 / 11 | 65 | +5.2 | -12842 | 61 | 12.7 | 65% | +4.1 | 4.55 - 0.21 | 5.2 | 5 / 91 / 4 / 0 (0.0) | 3.74 | 8.3 | 5 | 65 | 24% |
| 48 | ticket build keeper | 216 | 63 / 21 / 16 | 62 | +0.0 | -12089 | 61 | 16.0 | 94% | +4.9 | 3.49 - 0.67 | 4.5 | 88 / 0 / 12 / 0 (1.4) | 0.00 | 7.6 | 6 | 65 | 14% |
| 48 | ticket test keeper | 216 | 53 / 23 / 24 | 62 | +8.0 | -10804 | 64 | 22.8 | 94% | +4.7 | 3.45 - 0.67 | 4.5 | 75 / 11 / 14 / 0 (4.8) | 0.25 | 8.6 | 5 | 65 | 11% |
| 48 | ticket test name | 216 | 53 / 23 / 24 | 62 | +8.0 | -10676 | 63 | 23.1 | 94% | +4.8 | 3.36 - 0.75 | 4.5 | 86 / 0 / 14 / 0 (8.4) | 0.00 | 9.4 | 5 | 65 | 11% |
| 48 | ticket test win | 216 | 53 / 23 / 24 | 62 | +8.0 | -12793 | 61 | 14.8 | 67% | +3.8 | 4.12 - 0.37 | 4.9 | 0 / 92 / 8 / 0 (0.0) | 3.29 | 1.6 | 5 | 65 | 19% |
| 64 | guarantee build keeper | 216 | 75 / 18 / 7 | 70 | +0.0 | -11263 | 61 | 13.3 | 74% | +4.6 | 4.46 - 0.25 | 5.1 | 20 / 76 / 4 / 0 (0.0) | 2.92 | 8.7 | 5 | 65 | 12% |
| 64 | guarantee build name | 216 | 75 / 18 / 7 | 70 | +0.0 | -11061 | 62 | 17.9 | 92% | +4.7 | 3.26 - 0.66 | 4.3 | 87 / 0 / 13 / 0 (0.0) | 0.00 | 2.5 | 6 | 66 | 7% |
| 64 | guarantee build win | 216 | 75 / 18 / 7 | 70 | +0.0 | -11397 | 60 | 11.0 | 70% | +4.2 | 4.70 - 0.17 | 5.3 | 0 / 97 / 3 / 0 (0.0) | 3.85 | 9.8 | 5 | 65 | 13% |
| 64 | guarantee test keeper | 216 | 67 / 23 / 11 | 70 | +5.7 | -11281 | 63 | 16.4 | 70% | +4.2 | 4.65 - 0.21 | 5.3 | 5 / 91 / 4 / 0 (0.0) | 3.84 | 8.4 | 5 | 65 | 13% |
| 64 | ticket build keeper | 216 | 63 / 21 / 16 | 69 | +0.0 | -10615 | 63 | 19.3 | 94% | +5.0 | 3.52 - 0.68 | 4.6 | 88 / 0 / 12 / 0 (1.4) | 0.00 | 7.6 | 5 | 65 | 9% |
| 64 | ticket test keeper | 216 | 53 / 23 / 24 | 69 | +9.0 | -9368 | 65 | 26.9 | 94% | +4.7 | 3.46 - 0.68 | 4.6 | 75 / 11 / 14 / 0 (4.8) | 0.25 | 8.6 | 5 | 65 | 7% |
| 64 | ticket test name | 216 | 53 / 23 / 24 | 69 | +9.0 | -9251 | 64 | 27.3 | 94% | +4.8 | 3.37 - 0.75 | 4.6 | 86 / 0 / 14 / 0 (8.5) | 0.00 | 9.4 | 5 | 65 | 7% |
| 64 | ticket test win | 216 | 53 / 23 / 24 | 69 | +9.0 | -11246 | 63 | 18.9 | 67% | +3.9 | 4.18 - 0.38 | 5.0 | 0 / 92 / 8 / 0 (0.0) | 3.34 | 1.5 | 5 | 65 | 14% |
| 48 | guarantee build name | 216 | +306 | 118 | +0.0 | 0.0 | +4.6 | -1.57 | no measured difference |
| 48 | guarantee build win | 216 | -136 | 46 | +0.0 | 0.0 | -2.2 | +0.30 | no measured difference |
| 48 | guarantee test keeper | 216 | -3 | 79 | -8.3 | 2.0 | +2.8 | +0.19 | beaten by it |
| 48 | ticket build keeper | 216 | +750 | 168 | -13.0 | 4.6 | +6.1 | -1.32 | beaten by it |
| 48 | ticket test keeper | 216 | +2035 | 203 | -22.7 | 4.6 | +12.9 | -1.36 | a trade |
| 48 | ticket test name | 216 | +2163 | 209 | -22.7 | 4.6 | +13.2 | -1.53 | a trade |
| 48 | ticket test win | 216 | +46 | 164 | -22.7 | 4.6 | +4.9 | -0.38 | beaten by it |
| 64 | guarantee build name | 216 | +202 | 112 | +0.0 | 0.0 | +4.6 | -1.60 | no measured difference |
| 64 | guarantee build win | 216 | -134 | 45 | +0.0 | 0.0 | -2.3 | +0.32 | no measured difference |
| 64 | guarantee test keeper | 216 | -18 | 80 | -8.3 | 2.0 | +3.0 | +0.23 | beaten by it |
| 64 | ticket build keeper | 216 | +649 | 163 | -13.0 | 4.6 | +6.0 | -1.37 | beaten by it |
| 64 | ticket test keeper | 216 | +1895 | 205 | -22.7 | 4.6 | +13.6 | -1.43 | a trade |
| 64 | ticket test name | 216 | +2012 | 211 | -22.7 | 4.6 | +13.9 | -1.59 | a trade |
| 64 | ticket test win | 216 | +17 | 167 | -22.7 | 4.6 | +5.6 | -0.41 | beaten by it |
| 48 | ticket | name | 216 | -10676 | 23.1 | +2.61 | 94% | 86% | yes | - |
| 48 | ticket | win | 216 | -12793 | 14.8 | +3.75 | 67% | 0% | - | - |
| 48 | ticket | keeper | 216 | -10804 | 22.8 | +2.78 | 94% | 75% | yes | - |
| 48 | guarantee | name | 216 | -12533 | 14.5 | +2.57 | 91% | 87% | yes | - |
| 48 | guarantee | win | 216 | -12975 | 7.7 | +4.44 | 68% | 0% | yes | - |
| 48 | guarantee | keeper | 216 | -12839 | 9.9 | +4.14 | 70% | 19% | yes | - |
| 64 | ticket | name | 216 | -9251 | 27.3 | +2.62 | 94% | 86% | yes | - |
| 64 | ticket | win | 216 | -11246 | 18.9 | +3.80 | 67% | 0% | yes | - |
| 64 | ticket | keeper | 216 | -9368 | 26.9 | +2.78 | 94% | 75% | yes | - |
| 64 | guarantee | name | 216 | -11061 | 17.9 | +2.61 | 92% | 87% | yes | - |
| 64 | guarantee | win | 216 | -11397 | 11.0 | +4.53 | 70% | 0% | yes | - |
| 64 | guarantee | keeper | 216 | -11263 | 13.3 | +4.21 | 74% | 20% | yes | - |
| 48 | ticket | 216 | +2117 | 120 | +8.3 | 0.4 | -1.14 | 0.11 |
| 64 | ticket | 216 | +1995 | 116 | +8.3 | 0.4 | -1.18 | 0.11 |
| 48 | guarantee | 216 | +442 | 112 | +6.8 | 0.4 | -1.87 | 0.12 |
| 64 | guarantee | 216 | +336 | 106 | +6.9 | 0.4 | -1.92 | 0.12 |
| 64 | ticket | 216 | 18.9 | 32.4 | 13.4 |
| 64 | guarantee | 216 | 11.0 | 26.6 | 15.6 |
| 48 | ticket | 216 | -9.7 | 2.0 | +1285 | 119 | +6.8 | 0.6 | a trade |
| 48 | guarantee | 216 | -8.3 | 2.0 | -3 | 79 | +2.8 | 0.3 | build beats test |
| 64 | ticket | 216 | -9.7 | 2.0 | +1247 | 117 | +7.6 | 0.7 | a trade |
| 64 | guarantee | 216 | -8.3 | 2.0 | -18 | 80 | +3.0 | 0.4 | a trade |
| 48 | guarantee build keeper (keeper) | 36 | +3185 | 334 | +1.7 | 0.4 | +0.81 | 0.17 | 9.2 | 97% | $3560 | 0.00 (0.00) | 0.0% | 0% / 0% |
| 48 | guarantee test name (rebel) | 36 | -2017 | 536 | -4.5 | 1.3 | -0.94 | 0.29 | 0.2 | 0% | $0 | 0.00 (0.00) | 57.5% | 3% / 14% |
| 48 | ticket build win (rebel) | 36 | -1381 | 284 | -1.3 | 0.4 | -1.44 | 0.34 | 0.1 | 0% | $0 | 0.00 (0.00) | 60.2% | 0% / 0% |
| 48 | ticket test keeper (keeper) | 36 | +1349 | 178 | +0.2 | 0.5 | +0.14 | 0.15 | 8.4 | 97% | $1271 | 0.22 (0.08) | 0.0% | 14% / 6% |
| 64 | guarantee build keeper (keeper) | 36 | +2438 | 123 | +0.2 | 0.2 | +0.14 | 0.07 | 9.5 | 100% | $4186 | 0.00 (0.00) | 0.0% | 3% / 3% |
| 64 | guarantee test name (rebel) | 36 | -2007 | 446 | -5.8 | 1.2 | -1.25 | 0.29 | 0.1 | 0% | $0 | 0.00 (0.00) | 63.2% | 3% / 14% |
| 64 | ticket build win (rebel) | 36 | -1777 | 307 | -2.4 | 0.4 | -2.39 | 0.35 | 0.0 | 0% | $0 | 0.00 (0.00) | 70.3% | 0% / 0% |
| 64 | ticket test keeper (keeper) | 36 | +1363 | 157 | -0.6 | 0.6 | -0.28 | 0.22 | 8.6 | 100% | $1507 | 0.33 (0.08) | 0.0% | 14% / 6% |
| 1 | Instrument: today's costs ask reads +$700 to +$1,100 against today's plain guarantee house, error under $100, in every cell it is played | 64: +943, error 14; full: +909, error 0 | PASS |
| 2 | Instrument: the error on every option's cash gap is $250 or less in every pooled cell (a $1,000 gap is four errors) | largest error $215 | PASS |
| 3 | Played debut wins in 100: ticket test 52 to 68, ticket build 62 to 78, guarantee build 70 to 82, guarantee test 60 to 76 | 62.5, 72.2, 77.8, 68.2 | PASS |
| 4 | The card is honest: each of the four debutants shown within 3 of played on the mean, and no boxer's card more than 8 from that boxer's own nights | ticket test 60.5 shown, 62.5 played, worst boxer -2.9; ticket build 70.4 shown, 72.2 played, worst boxer -3.2; guarantee build 78.1 shown, 77.8 played, worst boxer -2.5; guarantee test 68.0 shown, 68.2 played, worst boxer -2.0 | PASS |
| 5 | The house is a trade somewhere: the ticket house (its test debutant, the keeper road) is $1,000+ ahead on cash and 3+ debut wins behind the plain guarantee house in at least one cell | cells: 48, 64 | PASS |
| 6 | The house flips: the plain guarantee house beats that ticket-house option in at least one cell | cells: full | PASS |
| 7 | AUDIT (the kind): inside a house no road is the one answer in more than 6 of 10 house x gym cells | name 0 of 6; win 0 of 6; keeper 0 of 6 | PASS |
| 8 | AUDIT (the kind): every road is right in at least one house x gym cell, and in at least half of them two roads differ by a line on some axis ($1,000, 3 reputation, 1 win less loss) | name right 6 of 6; win right 5 of 6; keeper right 6 of 6; two roads differ in 6 of 6 | PASS |
| 9 | AUDIT: best against laziest - in at least half the cells an option is ahead of the plain guarantee house by $1,000 or 3 debut wins in 100 | 2 of 3 cells (48, 64) | PASS |
| 10 | The name is the kind's (probe 13's bars 10 and 15, one fact): with the tune-up rule off the win-chaser ends 1+ reputation higher in every cell with room it is played in, and with it on the name-chaser ends 3+ reputation ahead of the win-chaser in the same house in every cell with room | the rule takes 13.4 (ticket, 64), 15.6 (guarantee, 64); the name-chaser's lead +8.3 (ticket, 48), +8.3 (ticket, 64), +6.8 (guarantee, 48), +6.9 (guarantee, 64) | PASS |
| 11 | Boxer by boxer (boxer x house x gym): no road the one answer in more than 6 cells of 10, every road right in at least 2 | name right 31, one answer 0 of 36; win right 25, one answer 0 of 36; keeper right 35, one answer 3 of 36 | PASS |
| 12 | A debut loss leaves a mark at the last week: $1,000+ of cash or 20+ points of ranked share behind the same option's wins (not paired: a reading, not a cost) | v15: cash -1844, ranked +2 points behind; today: cash -1054, ranked -2 | PASS |
| 13 | Inside one house two bots book different kinds: step ups are 25+ points more of the name-chaser's bookings than of the win-chaser's, at each house | ticket +86 points; guarantee +86 points | PASS |
| 14 | Later +2: the card shows +1 to +4, the played gain is not below 0 (a calendar tool; the card's part is the card's own formula) | card +2.0 / +2.0; played +2.8 (ticket), +1.2 (guarantee) | PASS |
| 15 | The favour moves the result (stage F, the favour's rules on against off on the same rolls): a line on some axis ($500 of gym cash, 3 reputation, 0.5 of a win less loss) for a keeper in at least one house AND for a full rebel in at least one house (v15 reads it strictly: the keeper's line is a gain, the rebel's a loss, and neither has a line the other way) | keeper gained: guarantee build keeper 48, ticket test keeper 48, guarantee build keeper 64, ticket test keeper 64, guarantee build keeper full, ticket test keeper full; rebel lost: guarantee test name 48, ticket build win 48, guarantee test name 64, ticket build win 64, guarantee test name full, ticket build win full | PASS |
| 16 | The debut night is a trade: in at least one house x gym cell the test debutant is 3+ debut wins behind and 3+ reputation or $1,000 ahead, and neither debutant is the one answer in more than 6 of 10 of them | a trade in: ticket 48, ticket 64, guarantee 64, ticket full; test the one answer 0, build 2 of 6 | PASS |
| 17 | Both kinds are on the table: 80%+ of the road's sets that are not rebuild sets carry a tune-up and a step up, at each house | ticket 100%; guarantee 100% | PASS |
Bars passed: 17 of 17 (17 bars read; 17 are defined). Audit bars (7, 8, 9): all pass. VERDICT: PASS (PASS = 14 or more of 17 with every audit bar).
