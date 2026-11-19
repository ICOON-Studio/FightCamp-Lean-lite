# LEDGER1_V2 - write the NEXT version of this mechanic's design map (S459 design loop)

You are the designer. Read the whole game (critic pack below), the current map, and the critics' answers at the end. Write
the next version of the map in full (not a diff): answer EVERY point of each critic's 'To reach 10/10' list (do it, or say
in one line why not), keep every rule the owner agreed (quoted in the map), keep it buildable from what the game has, and
keep the map's table of every menu the mechanic appears on and what each is wired to (owner S425).
The bar it must reach with fresh critics: 7+ DEPTH and 7+ GENERAL DESIGN (owner S425). Numbers: say which are ESTIMATES.
Plain words; names only in headers. Return only the new map, starting with its title line.

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

# LEDGER1 v1 - what a boxer has been worth (design map; Dola SQ227, extracted S525)

Source: ops/research/DESIGN_LEDGER1_V1_WRITE_DOLA_DOLA.md lines 502-590 (Dola's reply, chat chrome removed). Brief: DESIGN_LEDGER1_V1_WRITE_DOLA.md.

CLAUDE CHECK (S525, against the code): 'Signing bonus' (income) is NOT IN CODE - no such payment exists; a critic should say whether it belongs. 'Bout entry fee per event' is NOT IN CODE - England Boxing fees are yearly (GymBills: $315 club + $18 a boxer + $35 a coach). Release fee: scripts/state/Leaving.gd. Members after a win: BoutRules.WIN_MEMBERS 8 (the map is right). Cutman, sparring partner, scouting, licence + medicals: in code (BoutRules, Matchmaking/ProLadder, ProDebut). Dola's own score (7.7) does not count: two fresh critics score it.

LEDGER1_V1 — Design Map: What a Boxer Has Been Worth
Design Loop S524 | Priority Order: Amateur Week → Office → Coach Depth → This Map
1. What the Player Decides
Every decision shows clear numbers, trade-offs, and a value tag.
Table
Decision	What It Means	Trade-off	Value Tag
Keep / Release	Keep the boxer on roster or let them go	Keep: −$250/week stipend
Release: −future ticket cuts/purse share; may lose a fan draw	REAL
Pay / Stop Stipend	Toggle weekly stipend for amateurs	Stop: +$250/week immediately
Risk: −5–15 morale; slower loyalty growth	GAME VALUE
Push for Pro Deal	Encourage them to turn pro earlier	Pro: stipend ends; debut purse/ticket share begins
Earlier: smaller debut audience; risk −10 morale if declined	ESTIMATE
Renegotiate Contract	Adjust gym's purse share at milestones (top‑10 / first belt)	Keep 25%: no bonus paid
Drop to 20%: −5% income per bout; +loyalty +5–10	CODE
Sell / Let Leave	Lose the boxer to outside interest (loyalty < 50)	Lose: club keeps only 10% trainer cut
Keep: pay signing bonus match + retain 25% purse share	REAL
2. Where a Boxer's Worth Comes From — Ledger Lines Only
All lines from existing game ledger — nothing invented.
✅ INCOME — What They Bring In
Table
Line	Source	Amount
Amateur ticket cut	Club show bout	$450 per bout
Home bout gate	Club hosts show	Gate revenue split
Debut tickets sold	Pro debut	Per formula: family + members + wins + title bonus
Debut purse share	Pro debut	25% of purse to gym
Pro purse share	All pro bouts	25% of purse to gym
Signing bonus	Pro contract talks	One‑time payment to club
Member growth	Win → new members	+8 members / win; +5 reputation
❌ COSTS — What They Take Out
Table
Line	Source	Amount
Weekly stipend	Amateur roster	$250/week; $125/week home‑grown junior
Bout entry fee	Entering a bout	Per event
Sparring partner	Camp prep	$160 when booked
Cutman fee	Pro fight night	$150/pro bout
Pro licence + medicals	Pro signing	$230 licence + $875 scans + $140 trainer licence
Scouting fee	Scout opponent	$250/pro bout
Release fee	End contract early	One‑time cost
📊 NET WORTH CALCULATION
Running Total = All Income Lines − All Cost Lines — per boxer, per week + per event
3. Failure Path — "Too Late to Cut"
The Lesson: Every week you carry a loser, you burn runway.
The Pattern: An amateur with 0–3 bouts, 1–2 losses, no upcoming offer, sitting 8+ weeks. Stipend keeps paying — $2,000+ gone — while they bring in nothing.
The Warning: Week review flags: "No bouts booked in 6 weeks — costing $250/week with no return"* → **Net Worth: −$1,500*
The Mistake: Player waits "just one more week" for a turnaround. Another loss → morale drops → loyalty falls → no new offers arrive → they leave anyway. Club recovers $0 — only saved the trainer's 10%.
The Teach: "Release early. The money you save is already money earned." — shown on release confirmation: "You have spent $1,750 on this boxer with $450 total return. Releasing now saves $250/week going forward."
4. Where It Appears — Menu Wire Map
Table
Screen	What Is Shown	What You Can Do	Wired To
Fighter Page → Contract Tab	Full ledger: income + costs + running net worth; stipend status; pro readiness; loyalty; next review date	Keep / Release; toggle stipend; push pro talk; renegotiate share	Fighter roster → Contract tab → Week review → Money page
Club → Money → Per Boxer View	Sortable list: weekly net, all‑time net, stipend cost vs bout income, runway impact	Sort by cost / value / upcoming bouts; toggle multiple stipends	Money page → Contract tab → Week review
Week Review (Per Fighter Row)	That week: stipend cost vs any income from that week; rolling 8‑week trend	Open full ledger; set reminder to review next month	Home → Week review → Contract tab
Pro Offer Modal	Debut ledger: stipend saved vs debut income vs one‑time costs; break‑even week; net return at 5/10 bouts	Accept / Decline; negotiate terms; see 4‑week forecast	Pro offer → Contract tab → Money page
Office → Fighters Card	Quick snapshot: This Month In / This Month Out / Net	Click through to full ledger	Office → Contract tab → Money page
5. Probes to Prove It
Three parallel runs — same start, 12 weeks, no other changes.
Table
Bot Strategy	Expected Outcome	Pass Line
Keep Everyone	Sign all comers; never cut anyone	Net club cash: −$3,000+ by week 12; 3+ boxers at −value; gym runway < 6 weeks
Release the Losers	Cut anyone with −3 straight weeks / no bouts in 6 weeks	Net club cash: +$500–$800 by week 12; runway > 12 weeks; top 2 fighters profitable
Sell the Star	Renegotiate at top‑10; keep share vs drop share + loyalty	Keep share: +$1,200 more at 5 bouts; loyalty −5; risk of departure
Drop share: −$240 income; loyalty +8; retained
Pass conditions:
Net worth updates instantly on any decision (stipend toggle, bout completion, contract change)
Week review row matches Money page total within ±$1
Pro offer preview matches ledger projection within 5% at 10 bouts
6. Scope — What It Does NOT Do + Open Questions
❌ Does NOT Do
No transfer market between gyms — boxers only leave via loyalty / release / retirement
No TV rights or broadcast deals — income only from tickets, purses, dues, sponsors
No per‑fight variable expenses beyond existing ledger lines
No future projection beyond 10 bouts / 8 weeks
❓ Open Questions (Owner Decisions Only)
Should the running net worth persist permanently on the fighter's history page, or reset at year‑end?
Should home‑grown juniors show a different worth curve (lower stipend but slower initial income)?
What is the maximum acceptable "negative worth window" before the game flags it as critical? 4 weeks? 8 weeks?
Should a boxer's worth also factor in member retention/reputation effects — or keep it strictly money in/money out?
7. Critic Score & Roadmap
Table
Criterion	Score / 10	Notes
Depth	8	Full ledger, decisions with trade‑offs, failure path, probes — but no historical trend chart
General Design	8	Actionable everywhere shown; clean lines from existing data; scope boundaries clear
Play Out	7	Three distinct strategies with measurable outcomes — but no rival gym bidding / market dynamics yet
OVERALL	7.7 / 10	Solid foundation — missing polish and depth features
To Reach 10/10
Add 8‑week trend graph to Contract tab — show net worth week‑by‑week → Critical, week‑by‑week visibility
Add threshold alert — "This boxer has cost more than they've earned for 6 straight weeks" → Teach the failure path earlier


# CRITIC ANSWER: DESIGN_LEDGER1_V1_CRITIC_DOLA_DOLA.md

# DESIGN_LEDGER1_V1_CRITIC_DOLA_DOLA - Dola answer (seat queue SQ228)

Brief: research/DESIGN_LEDGER1_V1_CRITIC_DOLA.md
Sent: 2026-11-19 11:40 | collected: 2026-11-19 12:10 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.

(the brief is cut; her reply:)

Show More
Today 11:40
📊 CRITIC SCORE — LEDGER1_V1 (What a Boxer Has Been Worth)
Design Loop S524 — Judged against FightCamp design rules and code facts only
🎯 SCORES (each /10)
Table
#	Criterion	Score	Reasoning
1	DEPTH	8/10	✅ Real decisions with clear trade-offs; no single dominant choice. Keep/Release, Stipend, Pro timing, Contract share, Sell/Let Leave each pull in different directions. Interlocks well with existing systems (morale, loyalty, money, matchmaking). ❌ Missing: no sensitivity sliders; one clear missing option (temporary loan/sabbatical for injured fighters); no "opportunity cost" line (what that roster spot/stipend could have earned elsewhere).
2	GENERAL DESIGN	8/10	✅ Every number comes from existing code/data — nothing invented. Consistent plain language; every line maps to a decision point. Scope boundaries clear ("Does NOT Do" section is excellent). ❌ Two lines confirmed not in code: Signing bonus, Bout entry fee — these are misleading and should be removed or marked proposed. No guardrails shown on estimates.
3	PLAY	7/10	✅ Strong failure path — "Too Late to Cut" is the core lesson players learn; week-review warnings create real anticipation. Three distinct strategies proved in parallel runs — measurable outcomes. ❌ Feels a little dry/abstract week-to-week; no personality/mood tie-in; rival gym bidding/market dynamics missing so "Sell the Star" only happens one way. Reward is information clarity, not an in-game event.
✅ MECHANIC STATUS: DESIGNED
7+ on both Depth and General Design — meets owner S425's bar.
🧩 OPTIONS REVIEW
✅ What each option changes
Table
Decision	What it actually does in-game
Keep / Release	−$250/week stipend saved; loses future purse/ticket share; may lose reputation/members if a fan draw
Pay / Stop Stipend	Immediate +$250/week cash; morale −5 to −15; loyalty grows slower
Push for Pro Deal	Stipend ends earlier; purse/ticket share starts sooner; smaller debut audience; morale −10 if declined
Renegotiate Contract	Keep 25% = full income, no bonus, loyalty unchanged; Drop to 20% = −5% per bout, +5–10 loyalty
Sell / Let Leave	Lose the boxer entirely; keep only 10% trainer cut; OR match outside offer + pay bonus + keep 25% share
❌ Missing options
Temporary inactive / injured reserve — fighters get hurt often (section 4.10) but you can only carry them full-price or release them entirely; no pause stipend while injured
Set a review date — "I'll review this in 4 weeks" button with a calendar reminder, instead of only the 6-week warning
Opportunity cost line — "This spot could generate ~$X/week with a different boxer" — the ledger shows this boxer's worth but not the alternative
Seasonal/phase adjustments — reduce stipend temporarily during an inactive spell, not just ON/OFF
⚠️ Useless / incorrect options
Signing bonus — ❌ NOT IN CODE; remove from "Income" table entirely or move to Open Questions
Bout entry fee per event — ❌ NOT IN CODE; England Boxing fees are yearly, not per event; move to Open Questions or delete
⭐ TO REACH 10/10
Ordered by importance — build these first:
1. Remove or mark unimplemented lines (HIGH)
Move Signing bonus and Bout entry fee from confirmed Income/Cost tables → Open Questions. Keep the map honest — if it's not in scripts/, it does not belong in the "What They Bring In" table.
2. Add the 8‑week trend graph to Contract tab (HIGH)
Simple line chart: Net Worth Week by Week, last 8 weeks
Horizontal red line at $0
Colour bands: green (positive), yellow (negative <4 weeks), red (negative ≥6 weeks)
Hover: exact $ figure + what happened that week (bout income, stipend, scout fee paid)
Why: Players see the slide before it hits the 6‑week warning — turns a surprise into a decision window
3. Add two early warning thresholds + one-click review (MEDIUM)
Yellow alert: "−3 weeks running — costing $250/week" → button: Review in 2 weeks
Red alert: "−6 weeks running — $1,500 total invested, $450 return" → button: Keep / Release / Wait 2 more weeks
The "review in N weeks" sets a flag on the Week Review — no pop-up, just a reminder row
4. Add Inactive/Injured status option (MEDIUM)
When a fighter is injured/suspended: toggle to Inactive → stipend $0/week, but they stay on roster
Cost: loyalty −10; no training gains; no offers arrive while inactive
Clear trade-off: save money but fall behind — solves the "carry a hurt fighter with no income" dead zone
5. Add opportunity cost estimate (LOW)
One line at the bottom of the ledger:
"This roster spot occupied since Week 12. A typical active boxer generates ~$180/week net."
Helps answer: "Is it this boxer I should cut, or that one?"
6. Surface the three strategies on the intro page (LOW)
Short summary:
Keep Everyone → safer early, risky late | Release Early → fastest cash recovery | Keep Stars → negotiate loyalty for share, not just money
Players understand the patterns before they learn them the hard way
🖥️ 10/10 SCREEN DESCRIPTION — Fighter → Contract Tab
1920×1080 layout — clean gym whiteboard style, consistent with FightCamp visual rules
plaintext
┌─────────────────────────────────────────────────────────────────────┐
│  [Name] — CONTRACT & LEDGER                      Week 18 · Net: −$750 │
│  Status: ACTIVE  │  Loyalty: 62  │  Pro Readiness: 3/5 bouts        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌─────────────────────────┐    ┌─────────────────────────────────┐ │
│  │   LAST 8 WEEKS TREND    │    │ DECISIONS                       │ │
│  │  $                        ↑      [Keep]   [Release]             │ │
│  │        ╭───╮                      Stipend: [$250 ▾] $0 OFF     │ │
│  │    ╭───╯   ╰───╮                  Pro Talk: [Later ▾]          │ │
│  │  ╭─╯             ╰──╮            Contract: [25% share ▾]      │ │
│  │──│───────────────────│── $0      Inactive: [No ▾]              │ │
│  │  ╰──╮           ╭───╯                                          │ │
│  │     ╰───────────╯              ╭─────────────────────────────╮ │ │
│  │  W12 W13 W14 W15 W16 W17 W18    │ ⚠ −6 weeks · $1,500 invested │ │
│  │                                 │  [Review in 2w]  [Release]   │ │
│  └─────────────────────────┘      └─────────────────────────────┘ │ │
│                                                                       │
│  INCOME                      │  COSTS                                  │
│  ───────────────────────────┼────────────────────────────────────── │
│  Amateur bout   $450 ×1      │  Weekly stipend      $250 ×6 wks      │
│  Member growth  +28 members  │  Sparring partner    $160 ×1          │
│  Reputation     +3           │  Scouting fee        $250 ×1          │
│  ───────────────────────────┼────────────────────────────────────── │
│  TOTAL INCOME   $450         │  TOTAL COSTS        $1,900            │
│  ───────────────────────────┴────────────────────────────────────── │
│  NET WORTH TO DATE: −$1,450    │  Weekly run rate: −$250/week       │
│  Opportunity cost: ~$1,350 foregone on this spot                     │
└─────────────────────────────────────────────────────────────────────┘

Layout principles:
One screen, no scrolling — all critical info visible
Numbers first, buttons second — plain words only, no jargon
Trend chart left → history; actions right → what to do now
Warning sits between them — the problem before the choice
Hover every number: "This boxer has cost $X/week on average since signing"
No flavour text — every line answers: What do I know? What can I do? What happens if I do it?
Would you like me to turn this into a complete HTML mockup file you can drop straight into your design review? It would include the 8‑week trend chart, alert states, and all five decision panels fully interactive.
Today 11:41
Chat
Create Videos
Create Images
Writing
Homework
Translate


# CRITIC ANSWER: DESIGN_LEDGER1_V1_CRITIC_GOOSE.md

# LEDGER1_V1 Critique — Goose (Sports Management-Sim Designer)

Critic: Goose | Discipline: Boxing management simulation | Date: 2026-11-19

---

## SCORES

**DEPTH: 7/10**

**GENERAL DESIGN: 6/10**

---

## DEPTH — Reasons

**Strengths:**
- Five decisions with real trade-offs that interact with morale, loyalty, and cash flow
- The failure path ("Too Late to Cut") is excellent design — it teaches the player through consequences, not tutorials
- Probes are specific and measurable (three bot strategies with pass lines)
- Decisions have immediate and long-term consequences (release now saves $250/week but loses future income)

**Weaknesses:**
- No opportunity cost display — the player cannot see what else that roster spot could earn if filled by a different boxer
- No prime window indicator — a 28-year-old boxer with 3 years left at peak is worth more than a 34-year-old with 1 year, even if their current net worth is identical
- No break-even analysis — the player cannot see when a boxer will become profitable (critical for amateurs with 0-3 bouts)
- No comparison view — how does this boxer's worth compare to others on the roster? The player needs relative value, not just absolute
- No exit cost calculator — what's the total cost if I release now vs in 4 weeks? The failure path teaches this after the fact, but the player needs it before the decision
- Historical trend is mentioned as missing (8-week graph) but the design doesn't specify what the trend should show — just "net worth week-by-week" is not enough; it needs to show income vs costs separately so the player sees the trajectory

**Missing Interactions:**
- The design doesn't account for how releasing a boxer affects other boxers' morale ("if they cut him, will they cut me?")
- No consideration of reputation impact — releasing a popular boxer hurts member retention
- No rival gym bidding — if a boxer's loyalty is low, the design says they leave, but doesn't show the player a competing offer to match

---

## GENERAL DESIGN — Reasons

**Strengths:**
- All income and cost lines are from existing game ledger — nothing invented
- Clear menu wire map showing where the mechanic appears
- Scope boundaries are explicit (no transfer market, no TV rights, no per-fight variable expenses beyond ledger lines)
- The failure path is actionable and teaches through the UI

**Weaknesses:**
- **CRITICAL: Two cost lines do not exist in code**
  - "Signing bonus" (income) — NOT IN CODE. The CLAUDE CHECK (S525) confirms this. The design says it comes from "Pro contract talks" but no such payment exists. This is a design flaw — either remove it or specify how to build it.
  - "Bout entry fee per event" (cost) — NOT IN CODE. England Boxing fees are yearly ($315 club + $18 a boxer + $35 a coach), not per event. This line is wrong and should be removed or corrected.
- **"Sell / Let Leave" is confusing** — is this a rival gym making an offer, or the player selling the contract? Real boxing doesn't have transfer fees. The design says "Lose: club keeps only 10% trainer cut" but doesn't explain the mechanism. Is this a rival gym poaching? If so, where does that appear in the menu wire map?
- **Menu wire map references "Contract Tab" but the fighter page doesn't have one** — section 5.5 shows tabs: Overview, Week, Fight prep, Playbook, History. No Contract tab. The design needs to specify where this tab goes or which existing tab it replaces.
- **No consideration of time value** — a dollar earned today is worth more than a dollar earned in 10 weeks. The design treats all dollars equally, which is fine for a game, but the projection should discount future income (or at least note the assumption).
- **One-time costs vs recurring costs are mixed** — the ledger shows "Pro licence + medicals" ($1,245 total) as a single line, but this is only paid once at pro signing. The design should separate one-time costs from recurring weekly costs so the player sees the cash flow impact clearly.

---

## Which Options Are Missing

1. **Opportunity cost display** — "This roster spot could earn $X/week with a replacement from the prospect pool" — shows the player the cost of keeping a underperforming boxer
2. **Prime window indicator** — "3 years at peak, then decline" — helps the player decide whether to invest in a boxer or cut them before they age out
3. **Break-even week** — "This boxer becomes profitable at week 14 (after 3 amateur bouts)" — critical for amateurs with no income yet
4. **Comparison view** — "Your boxers ranked by net worth" — shows relative value, not just absolute
5. **Exit cost calculator** — "Release now: save $1,000 over 4 weeks. Wait 4 weeks: cost $1,000 more" — helps the player time the release decision
6. **Morale impact preview** — "Releasing this boxer will lower other boxers' morale by -3" — shows the hidden cost of the decision
7. **Reputation impact preview** — "Releasing a 5-0 boxer will cost -2 reputation and -5 members" — shows the member retention cost

---

## Which Options Are Useless

1. **Signing bonus (income)** — NOT IN CODE. Remove it or specify how to build it. A critic should not judge a mechanic that doesn't exist.
2. **Bout entry fee per event (cost)** — NOT IN CODE. England Boxing fees are yearly, not per event. Remove it or correct it to "Yearly England Boxing fees: $315 club + $18 a boxer + $35 a coach" and spread that cost across the year.
3. **"Sell / Let Leave" as written** — confusing terminology. If this is a rival gym poaching, rename it "Rival offer" and show it in the menu wire map. If this is the player selling the contract, explain the mechanism (real boxing doesn't have transfer fees).

---

## What Each Option Changes

**Keep / Release:**
- Keep: −$250/week stipend, +future ticket cuts/purse share, roster spot occupied
- Release: +$250/week saved, −future income, roster spot open, morale impact on other boxers, reputation impact if boxer was popular
- **Changes:** cash flow, roster capacity, morale of other boxers, reputation, member retention

**Pay / Stop Stipend:**
- Pay: −$250/week, +morale, +loyalty growth, boxer feels valued
- Stop: +$250/week, −5–15 morale, slower loyalty growth, boxer feels undervalued
- **Changes:** weekly cash flow, morale, loyalty, training quality (morale affects performance), risk of boxer leaving

**Push for Pro Deal:**
- Push: stipend ends, debut purse/ticket share begins, risk of −10 morale if declined
- Wait: stipend continues, no pro income yet, boxer may lose patience
- **Changes:** cash flow (stipend vs purse share), morale, loyalty, career progression

**Renegotiate Contract:**
- Keep 25%: no bonus paid, risk of −5 loyalty, boxer may leave at top-10
- Drop to 20%: −5% income per bout, +5–10 loyalty, boxer feels rewarded
- **Changes:** gym's share of purse, loyalty, risk of boxer leaving, long-term income

**Sell / Let Leave (as written):**
- Let Leave: lose boxer, club keeps only 10% trainer cut, roster spot open
- Keep: pay signing bonus match (DOESN'T EXIST) + retain 25% purse share
- **Changes:** roster spot, income share, loyalty (if kept), morale (if lost)
- **Note:** This option is broken because "signing bonus match" doesn't exist in code. Fix the terminology or the mechanic.

---

## To Reach 10/10

**Most important first:**

1. **Fix the code discrepancies** — Remove "Signing bonus" and "Bout entry fee per event" from the cost/income lines, or specify how to build them. A design that references non-existent mechanics is not buildable. (Specific: delete lines 2 and 7 from the ❌ COSTS table, or add a build spec for each.)

2. **Add break-even analysis to the Contract tab** — Show "This boxer becomes profitable at week X (after Y amateur bouts)" with a progress bar. This is the single most important number for an amateur boxer with no income yet. (Specific: add a card to the Contract tab showing break-even week, calculated from weekly stipend cost vs average amateur ticket cut.)

3. **Add opportunity cost display** — Show "This roster spot could earn $X/week with a replacement" based on the prospect pool's average potential. This teaches the player that keeping an underperforming boxer has a hidden cost. (Specific: add a line to the Contract tab showing "Opportunity cost: $X/week" calculated from the average net worth of available prospects.)

4. **Add prime window indicator** — Show "X years at peak, then decline" based on age and age curve. A 28-year-old with 3 years at peak is worth more than a 34-year-old with 1 year, even if their current net worth is identical. (Specific: add a line to the Contract tab showing "Prime window: X years" calculated from age and the age decline curve in the world model.)

5. **Clarify "Sell / Let Leave"** — Rename to "Rival offer" if this is a rival gym poaching, and show it in the menu wire map (Home → Needs flag → Rival offer modal). If this is the player selling the contract, explain the mechanism (real boxing doesn't have transfer fees; the only cost is the 10% trainer cut if the boxer leaves). (Specific: rewrite the decision table to show "Rival offer" with a modal that shows the rival's offer, the player's counter, and the morale/loyalty impact.)

6. **Add historical trend graph** — Show 8-week net worth week-by-week, with income and costs as separate lines (not just net). This lets the player see the trajectory, not just the current number. (Specific: add a chart to the Contract tab with three lines: income, costs, net worth, each week for the last 8 weeks.)

7. **Add comparison view** — Show "Your boxers ranked by net worth" on the Money page. This lets the player see relative value, not just absolute. (Specific: add a sortable table to the Money page showing each boxer's net worth, weekly net, and all-time net, sortable by any column.)

8. **Add exit cost calculator** — Show "Release now: save $X over 4 weeks. Wait 4 weeks: cost $X more." This helps the player time the release decision. (Specific: add a button to the Contract tab "Calculate exit cost" that shows the cost of releasing now vs in 4/8/12 weeks, based on weekly stipend and projected income.)

9. **Add morale and reputation impact preview** — Show "Releasing this boxer will lower other boxers' morale by -3 and cost -2 reputation" before the player confirms. This shows the hidden cost of the decision. (Specific: add a preview to the Release confirmation modal showing morale impact on other boxers and reputation impact.)

10. **Separate one-time costs from recurring costs** — The ledger should show "One-time costs: $X" and "Recurring weekly costs: $Y" separately, so the player sees the cash flow impact clearly. (Specific: split the ❌ COSTS table into two tables: "One-time costs" and "Recurring weekly costs".)

---

## 10/10 Description — 1920x1080 Page

**Layout:**

**Top bar (1920x60):** Back arrow, gym name, date/week, flags, cash with "running +/- $N a week", big button, Menu.

**Left panel (600x1020):** Fighter portrait, name, age, record, rank. Below: **PRIME WINDOW** card showing "3 years at peak, then decline" with a progress bar. Below: **BREAK-EVEN** card showing "Profitable at week 14 (after 3 amateur bouts)" with a progress bar. Below: **OPPORTUNITY COST** card showing "This roster spot could earn $300/week with a replacement" with a comparison to the prospect pool.

**Center panel (800x1020):** **NET WORTH LEDGER** with two tables:
- **INCOME** (amateur ticket cut, home bout gate, debut tickets, debut purse share, pro purse share, member growth) with amounts and totals
- **COSTS** split into **One-time** (sparring partner, cutman fee, pro licence + medicals, scouting fee, release fee) and **Recurring weekly** (weekly stipend)
- **NET WORTH** running total with a chart showing 8-week trend (three lines: income, costs, net worth)

**Right panel (520x1020):** **DECISIONS** card with five buttons:
- **Keep / Release** with preview: "Release now: save $1,000 over 4 weeks. Morale impact: -3. Reputation impact: -2."
- **Pay / Stop Stipend** with preview: "Stop: +$250/week. Morale: -10. Loyalty: -5."
- **Push for Pro** with preview: "Stipend ends. Debut purse: $X. Risk: -10 morale if declined."
- **Renegotiate** with preview: "Drop to 20%: -$240/bout. Loyalty: +8."
- **Rival offer** (if any) with preview: "Match: pay $X bonus. Let leave: keep 10% trainer cut."

**Bottom panel (1920x200):** **COMPARISON VIEW** table showing "Your boxers ranked by net worth" with columns: name, net worth, weekly net, all-time net, prime window, break-even week. Sortable by any column.

**Action:** Click a decision button to open a modal with full preview and confirm/cancel.

---

SCORE depth=7 general=6

## CLAUDE'S CODE CHECK (S526) - v2 must follow it
- NOT in the game: a signing bonus, a per-bout entry fee (England Boxing fees are yearly: $315 club + $18 a boxer + $35 a
  coach). Remove both lines, or write them as a NEW rule with its number, its menu and its probe line.
- In the game: rival offers for a boxer (RivalOffer, S517), a boxer leaving (Leaving / Loyalty), the pro offer and its
  terms (ProCall / Roster), GymBills (dues, rent, fees), stipend, ticket cut. "Sell" does not exist - real boxing has no
  transfer fee; say "rival offer" and wire it to what exists.
- The fighter page tabs today: Overview, Week, Fight prep, Playbook, History. Name the tab the ledger lives on (a new
  "Contract" tab is allowed - say so in the menu table).
- Split one-time costs (pro licence + medicals) from weekly ones. Every number marked CODE (exists) or ESTIMATE (new).
