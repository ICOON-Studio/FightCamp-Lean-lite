# WEIGHT1_R2 - score this mechanic's DESIGN (S459 design loop)

You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design map
at the end. Judge the MECHANIC, not the look of any screen.

Score, each out of 10, with the reasons:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
3. PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
The bar (owner S459): the mechanic is DESIGNED when critics give it 6+ on DEPTH and 6+ on GENERAL DESIGN.

Also answer: which options are missing, which are useless, and what each option changes (owner S403).
End with **To reach 10/10**: the concrete changes that would take it to 10, most important first, each specific enough to
build (owner S405). Then describe your 10/10 as a 1920x1080 page (an HTML file is welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent"). Real-world boxing evidence where it helps.

> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups.


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
  over usable, Signature +2.7 over sharp). Also measured and NOT in the game: an opponent's corner waiting for your best line (costs 7 wins
  in 100, no answer wins back more than 3.7).
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
  shown as a band that widens when unscouted. No way to ask for a named amateur opponent: AGREED; rules built (scripts/rules/AskBout.gd), panel not built (Ask for a fight: a "no" is a closed panel or an absent answer with its reason, never a random refusal).
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
- AGREED, NOT BUILT: opponents adjust by round 2; their note replaces the coach's line in the corner minute naming the line that stopped working.

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
  tie up, roll out. They have no mastery today and always work in full.
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

# WEIGHT1: the weight mechanic, design map round 2 (S434)

Roadmap row WEIGHT1. Author: Claude. Status: ROUND 2, for two fresh critics (the S425 rule: depth 7+ from both before the board).
Round 1 scored: coach depth 7 / clarity 6, sim designer depth 6 / clarity 6. Section 11 lists every critic point and where it went.
The owner, S434: "need to strenghen the weight mechanic , what do you think ?", then "yes start it" to the seven parts below.
Sources: `docs/mockups/s434/weight/REAL.md` (the real numbers, each with its source and tag) and `docs/mockups/s434/weight/CODE.md`
(the code today, file:line). Prior research read: J13 (diet = a weekly PLAN plus a standing DISCIPLINE, never a calorie counter),
Q20 (class choice is body and business, not temper), J7 (purse share 20-25%), J53 (amateur miss = walkover, no fine).
TR = `TRAINING_MAP_S432.md` (T8), CW = `CLUBWEEK_MAP_V41_S432.md` (3.5, 3.7), TS = `TRAINSCENE_MAP_S434.md`, CL = `CORE_LOOP_MAP_S432.md`.
Tags: REAL (a measured or rule-book number, REAL.md section given), CODE (in the game today, file:line), GAME VALUE (our choice, a
probe bounds it), ESTIMATE (an effect real data cannot size; a probe keeps it small), TO SOURCE (a real number John must check
before the build; the value given is a placeholder inside the range we know).

THE DRAWINGS (1920x1080, rendered with tools/render_mockup.py):
- `docs/mockups/s434/weight/r2_weight_panel.png` (`.html`): the training scene's WEIGHT PLAN, enlarged: the line to the scale with
  the coach's Monday check, this week by cause, the plan table (whole plans, one currency: win chance), the ENERGY sum, the trim with
  every step marked, the other corner behind scouting, the house rules, the miss risk and what a miss would cost.
- `docs/mockups/s434/weight/r2_class_choice.png` (`.html`): the fighter page's CLASS card: the walking weight and when STAY stops being
  cheap, DOWN / STAY / UP with labelled rows (the cut, the camp, ENERGY, win chance against the likely next three, size against the top
  five, the ladder, the business, the roster, as a pro), Samira's own ask, Test the weight, and "after the next bout".

## 0. The mechanic in one paragraph

Every fighter has a WALKING WEIGHT and a CLASS. The gap between them is the work of every camp, and it is decided three times: at
the CLASS card (which limit, for the career), at the BOUT OFFER (the contract weight: the limit, a catchweight, a matched weight), and
in CAMP (the plan: a diet for weeks plus a fight-week trim; for professionals the last day's water and the refuel). Every plan is
shown as a whole row with one currency the player can weigh: its WIN CHANCE against this opponent, which already contains the ENERGY
at the first bell, the camp goal and the size on the night. The fighter's DISCIPLINE decides the weekends; the player sets standing
HOUSE RULES (meal prep, a Monday weigh-in) and can hire a NUTRITIONIST. The coach checks the weight each Monday, so a camp going
wrong is caught with weeks to spare. Amateurs weigh in on the day, professionals the day before. A miss is graded; repeated misses
change a career. The opponent lives by the same rules, but the player only sees the other corner's weight after scouting it.

## 1. The vocabulary (one set of words on every screen)

| Word | Means | Never say |
|---|---|---|
| WALKING WEIGHT | the weight the body drifts back to between bouts | natural weight, walk-around |
| CLASS · LIMIT | the class name and its kg on the scale ("Welterweight · 65.0 kg") | division (in game text) |
| CONTRACT WEIGHT | the weight agreed at the offer: AT THE LIMIT, CATCHWEIGHT 66.0, MATCHED 64.0 ± 0.5 | |
| THE SCALE | the official weigh-in, with its day and hour ("Scale Sat 28, 4 pm") | weigh-in check, WI |
| COACH'S CHECK | the Monday target on the line ("Check Mon 23: 65.7 or under") | |
| THE PLAN | a diet plus a trim, one row ("Lean + trim 0.6") | |
| DIET: HOLD / LEAN / CUT | the three ways to eat; each shows kg a week | calories (kcal only in the hover) |
| FIGHT-WEEK TRIM | low-fibre, low-carb eating in the last 3 days: gut and glycogen, up to 2% | water cut |
| THE LAST DAY'S WATER | professionals only, the last 24 h before a day-before scale | dehydration (hover's REAL line only) |
| REFUEL | professionals only: what comes back between the scale and the bell | rehydration |
| ON THE NIGHT | the weight in the ring at the first bell | rehydrated weight |
| SLIP | a weekend the diet broke ("+0.5 kg, ate out Saturday") | cheat day |
| HOUSE RULES | standing weekend rules per fighter: Free / Meal prep / + Monday weigh-in | |
| MISS RISK | the chance this plan misses, "2 in 100" | |
| CRASH CUT | too much off too late (part 5) | |
| ENERGY | the fight-night fuel, 0-100 at the first bell | Tank, Fresh |
| FATIGUE | day-to-day tiredness | tiredness on training screens |
| STAMINA | the fitness stat (code `conditioning`) | Cardio, Engine |
| POWER · DURABILITY | the two stats the size edge touches (Data.gd:7-8 says "Durability") | chin (in game text) |
| WIN | win chance in plain fractions or "54 in 100" | odds, % |
Names, never he/she, also in the drawings: "If Samira slips", "Kayleigh starts 5 ENERGY under Samira".

## 2. Amateur, professional and no-gi, side by side

| | AMATEUR (club shows, the regional, the nationals) | PROFESSIONAL | NO-GI (Ana, NoGi.gd:74) |
|---|---|---|---|
| The scale | THE DAY ITSELF. Club show: 1 h before the first bell (4 pm for 5 pm). Championships: 9 am, 3 h+ before. REAL (EB 7.1.3; World Boxing 5.6) | THE DAY BEFORE, about 30 h out (Fri 2 pm for Sat). REAL (BBBofC 3.2.2: 24-36 h; IBF 1.A: 20-30 h) | at the mat, right before the first match, in kit. TO SOURCE (IBJJF / ADCC rule books, John) |
| Contract weight | the matchmaker pairs at the limit; a CATCHWEIGHT +1 kg costs a favour (part 4) | AT THE LIMIT / CATCHWEIGHT +1 or +2 kg / MATCHED with 0.5 kg allowance; a SECOND-DAY LIMIT clause (part 4) | the bracket's class only |
| Walking weight | 3-7% over the class (GAME VALUE; REAL 1a: amateurs cut ~6%, 9.5% at most) | 8-15% over (GAME VALUE; REAL 1a: 11-18%, ISSN ceiling 12-15%) | 2-5% over (GAME VALUE) |
| Coach's checks | every Monday of a camp | every Monday; title bouts add 30 days ≤ limit +10%, 7 days ≤ +5% (REAL 4d: WBC); BBBofC title +3% three days out (REAL 4e) | every Monday |
| Trim | up to 2% in 3 days (REAL 7: low-residue 1.5% in 48 h, low-carb ~2%) | the same | the same |
| Water | none (the panel says "no water: amateur" in the scale chip; no greyed row) | up to 3% in the last 24 h (REAL 4c: 2-3% "few disadvantages", ACSM) | none |
| Back by the bell | what was trimmed, at most 1.5% (women) / 2.1% (men) of the scale weight, + 0.3 kg for the meal (REAL 2a: Reale 2017) | REFUEL STANDARD: everything trimmed and dried + 1% for meals; AGGRESSIVE: +1% more (part 4); never over the walk (REAL 2a: +7.2% average) | nothing (minutes, not hours) |
| Trim price (ENERGY at the bell) | -1 a 0.1 kg up to 0.5 kg, -2 a 0.1 kg past it: 0.3 = -3, 0.6 = -7, 0.9 = -13, 1.0 = -15, 1.2 = -19 (TR T8, kept) | -1 a 0.25 kg (glycogen refills overnight; GAME VALUE) | the amateur rate |
| Water price | - | -1 a 0.2 kg up to 2%, -1 a 0.1 kg from 2 to 3%, past 3% = CRASH CUT | - |
| A little over | up to 1.0 kg: ASK A KILO, 1 favour, the bout goes on (CW 3.5); no favour = walkover loss | up to 0.45 kg: nothing. Over: ONE HOUR to sweat it (BBBofC 3.2.4), then the bout goes on and 25% of the purse goes to the opponent (Nevada NAC 467.522) | out of the bracket, entry lost (TO SOURCE) |
| Well over | over 1.0 kg: walkover loss (EB 10.7.2), no fine (REAL 5b) | over 2% of the limit: the other camp calls it off, no purse, the club pays $300 (CODE BoutRules.gd:88, kept for this case) | out of the bracket |
| A title | the nationals: out of the draw (CODE Bouts.gd:332-338) | champion loses the belt on the scale, the bout may go on; a challenger who misses cannot win it (IBF 1.A.1-2) | - |
| Size on the night | both corners land within about 1 kg: ONE LINE ("Level on the night") unless the gap is 1 kg+ | real: up to 3-4 kg, full bars | none |

## 3. The seven parts

Each part: what the player decides, what each option costs and gives, the links (training, fight, money, mood and loyalty,
career). Section 4 has every decision as a table.

### Part 1. WALKING WEIGHT AND THE CLASS CHOICE
THE RULE (kept from round 1, praised).
- Every fighter carries `walk` (kg). Start: CODE start weights (Data.gd:54, :198-240) become walks plus 2-4% (GAME VALUE; Samira
  65.9 now, walks 66.8). World opponents get one from their class and seed (part 6).
- AFTER A BOUT half the gap to `walk` comes back in week 1, the rest over 3 weeks (REAL 1b: 3.5-4.8% in a week). HOLD sits at `walk`.
- THE WALK MOVES SLOWLY: LEAN between camps takes 0.25 kg a month off (at most 4% under the start walk); under 21 adds 0.8 kg a year;
  a camp cut over 8% adds 0.2 kg after the bout (GAME VALUE; REAL 1b, Morehen's fat mass creep).
- The hidden clamp (Sim.gd:214-216, :149-151, CampForecast.gd:67-69) goes; `walk` replaces it.
THE DECISION (fighter page, CLASS card; drawn): DOWN / STAY / UP, now with timing and a trial.
- MOVE NOW (no bout booked) or MOVE AFTER THE NEXT BOUT (scheduled; the next offer still comes at the current limit). At most once
  in 12 weeks unless forced (part 5).
- TEST THE WEIGHT: one bout at a catchweight between the classes (Samira: 63.0 kg, the midpoint rounded to 0.5) before committing.
  No lock, no ladder move; the bout counts on the record and gives half ladder credit (part 4's catchweight rule). It shows the real
  cut: the slips that happened, ENERGY at the bell, the trim it took. The CLASS card then shows "Tested at 63.0: ENERGY 80, 1 slip".
- Each option shows, as labelled rows (drawn): THE CUT (% and kg from the walk; red past 10% for amateurs, REAL 1a), THE CAMP (weeks
  of diet to get down, then per bout), ENERGY at the bell, WIN against the likely next three opponents at that class (the existing
  win band, Matchmaking.win_chance :86, with the class's ENERGY and size), SIZE against the walks of that class's top five, THE LADDER
  (place the record earns, CODE ladder), THE BUSINESS (offers at that class in the last 8 weeks; weeks without a bout while getting
  down; ticket cuts lost at $450 each, CODE BoutRules.gd:89), THE ROSTER (a team-mate in that class shares club-show slots and the
  ladder: "Lucy Jackson boxes at 60.0: one of them sits out some shows"), AS A PRO (the pro limit and the size there).
- WHEN STAY STOPS BEING CHEAP: the date the growing walk puts the cut past 4% (Samira: about Apr 2027, walk 67.7). Drawn on the walk line.
THE FIGHTER'S VOICE (new, uses the existing ask rule, PushBack.gd:1-9, WeekTwist.gd:73-77 ASKS): two new ask cards.
- "Move me up" when CUT ran 3+ weeks in two camps running, or two slips forced a trim over 1.0 kg. "Move me down" when the lower ladder
  has a top-3 place the record would earn and the walk is under 8% over its limit. "Keep me here" when the player opens a move to a
  cut over 8%.
- Her way = `heard` (+5 morale), refused = `refused` (-4) (CODE FighterProfile.gd:28-29). A forced move to a cut over 8% also costs
  loyalty 3 ("You'd starve me", kept). The ask shows on the CLASS card with HEAR / OVERRULE.
LINKS. Training: the cut decides the diet weeks (part 2). Fight: size and ENERGY. Money: ticket cuts lost while getting down; thin
classes give fewer offers but a faster pro offer (7 wins + top 3, K-PROLINE1). Mood and loyalty: the asks. Career: the class is the
ladder, the rank, the pro offer and the pro limit; the roster rule (S428: four fighters in four classes) makes a move a squad decision.
NEW CLASSES NEEDED (the owner's scope call): women 70 kg and men 65 kg (World Boxing classes; names from Kalli). Without them a women's
welterweight's UP is 75 kg.

### Part 2. THE CUT HAS A PRICE AND A PRIZE, IN ONE CURRENCY
THE PRICE (camp).
| Diet | kg a week (60-65 kg) | Training gains | FATIGUE a day | Mood |
|---|---|---|---|---|
| HOLD | +0.02 (CODE WeekPlan.gd:73, life + 300 kcal) | x1.0 | +0 | - |
| LEAN | -0.20 (-250 kcal; TR T8) | x0.97 (GAME VALUE; REAL 2c) | +0.5 | - |
| CUT | -0.43 (CODE WeekPlan.gd:74; Old hand -0.52) | x0.9 (TR T8 ESTIMATE) | +1.5 (GAME VALUE) | -3 a week past 2 weeks (REAL 3: Hall and Lane 2001) |
- The diet is the player's choice in camp. Today a camp cuts by itself while over (CODE Sim.gd:117-118); that rule goes.
- TAPER_KG (CODE WeekPlan.gd:70-72, 0.05 kg a day, REAL 7: 3-6x too small) is replaced by the FIGHT-WEEK TRIM.
THE PRICE (fight night): ENERGY AT THE FIRST BELL = 100 - Fatigue carried (CODE BoutRules.stale_energy :165-168: 2 a point over 50,
at most 20; the diet's extra Fatigue flows through it and is shown as its own share) - the trim - the water - a refuel shortfall.
Drawn as one bar with its parts: "100 · Fatigue carried -4 · Lean's share -3 · trim 0.6 kg -7 = 86". Every ENERGY number on every
screen is this sum (round 1's 79 / 86 / 85 could not be rebuilt; now each is: HOLD 100-4-0-15 = 81, LEAN 100-4-3-7 = 86, CUT
100-4-8-3 = 85).
THE PRIZE: SIZE ON THE NIGHT. Night weight = the scale + what comes back, never above `walk`. The heavier corner gets +0.6 Power and
+0.6 Durability per kg of gap from 1 kg, at most 4 kg (+2.4). ESTIMATE kept small (REAL 2b: no measured effect on who wins in boxing;
PEAK CAMP is +1 to every stat, PeakCamp.gd:11). Amateurs: one line unless 1 kg+.
THE CURRENCY: WIN CHANCE. Every plan row, class option and contract option shows WIN against this opponent: the existing win band
(Matchmaking.win_chance :86) run with that option's ENERGY, size edge and camp-goal result. What ENERGY is worth depends on the FIGHT
PLAN (PlanFight / PlanPressure): a pressure plan or a late Push counts ENERGY x1.4; a power plan counts the size edge x1.4; others x1
(GAME VALUE, probe P10). Shown under the ENERGY bar: "1 ENERGY = about 0.4 in 100 with Push R3". The kg, ENERGY and camp goal stay in
their columns so the player sees WHY a row wins.
LINKS. Training: the diet's gains and Fatigue land on the mornings the scene prices (TS 6). Fight: ENERGY, size, the plan's weights.
Mood: CUT past 2 weeks. Career: none directly.

### Part 3. THE FIGHTER'S CHARACTER, AND WHAT THE CLUB CAN DO ABOUT IT
THE RULE (a game rule: Q20 found no published link; REAL 3 gives the weekend proxy).
- On LEAN or CUT each weekend can SLIP. Chance = 0.8 - discipline/100, 5 to 60 in 100 (GAME VALUE). Samira, discipline 34: 46 in 100,
  shown "1 in 2". A slip is +0.3 to +0.6 kg (GAME VALUE, about 5x Racette 2008's +0.06 kg a weekend day). News: "Samira: +0.5 kg, ate
  out Saturday". Fight week halves it (the coach weighs every morning; BBBofC 16.7's diary).
- A HARD CUT (CUT 3+ weeks, or a trim over 1.5%) costs mood 3 (new `hard_cut` -3; `made_it` +2 after one). REAL 3: Hall and Lane 2001.
- DISCIPLINE GROWS (new): three camps in a row made clean (no slip forced an extra trim, no crash cut) = discipline +2; a crash cut -2;
  a miss -1; at most +6 a year (GAME VALUE). Shown: "Clean camps in a row: 1 of 3". The habit system (MOODHABIT1) reads it.
THE DECISION: HOUSE RULES, set once per fighter, they run every diet week (J13: a weekly plan plus a standing discipline; a weekly pick
is a chore with four fighters). Odds in plain fractions.
| House rule | Price | Samira's slip chance |
|---|---|---|
| FREE | nothing | 1 in 2 |
| MEAL PREP DELIVERED | $70 a week, only in diet weeks (TO SOURCE: UK meal-prep plans about GBP 55-80 for 10 meals) | halved: 1 in 4 |
| + MONDAY WEIGH-IN at the gym | mood -1 each diet Monday | halved again: 1 in 9 |
Round 1's CLUB DINNER is gone (critics: a club meal keeps nobody on a diet).
THE NUTRITIONIST (new staff job, StaffRoles.LIST, CODE StaffRoles.gd:7-15 shape): $100 a week (TO SOURCE: a UK sports nutritionist
session GBP 50-100). For every fighter: the trim's ENERGY price x0.8, the forecast line exact to 0.1 kg (the band keeps only slips),
slips x0.75, a pro refuel +0.5% more. With the Old hand's x0.75 (HeadCoach.gd:23-24) the trim price never falls under x0.65 (the
StaffRoles RISK_FLOOR idea, :21). Money for weight, every fighter at once.
THE CYCLE WEEK (women, forecast only): the line's band widens by 0.5-1.0 kg on the days the fighter's cycle puts water on (a 28-day
seed; ESTIMATE, TO SOURCE). It changes no stat; the coach then advises the diet a few days earlier. Shown only in the band's hover.
LINKS. Mood: the weigh-in, hard cuts. Money: meal prep, the nutritionist. Career: discipline grows with clean camps; a low-discipline
fighter is a heavier long-term cut, and the CLASS card shows it.

### Part 4. THE SCALE: WHEN, AND AT WHAT WEIGHT
WHEN (kept): section 2. One function names the scale's day and hour for every bout kind: club show (the day, 1 h before the first
bell), the regional and the nationals (the day, 9 am), professional (the day before, 2 pm), a pro title (the day before, plus a
fight-morning check if the contract has the second-day limit).
AT WHAT WEIGHT: THE CONTRACT WEIGHT on the bout offer (new; weight is decided when the deal is made, not only in camp).
| Option | Amateur | Professional | What it changes |
|---|---|---|---|
| AT THE LIMIT | the default | the default | full ladder credit |
| CATCHWEIGHT +1 kg | costs 1 favour (CW 3.5) | 10% of the asker's purse to the other camp (GAME VALUE inside J7's 20-25% band for a miss) | a smaller cut (ENERGY back), the other corner's size too; half ladder credit (GAME VALUE) |
| CATCHWEIGHT +2 kg | - | 15% of the purse | the same, more; no title credit |
| MATCHED WEIGHT ± 0.5 kg | the matchmaker's way at a club show: both at one agreed weight under the limit | both camps agree it | used to test a lower class (part 1) |
| SECOND-DAY LIMIT (a clause) | - | either camp may ask it: fight morning, limit +10% (REAL 4b: IBF) | caps the other corner's refuel: the counter to a big water cut |
The other camp ACCEPTS or REFUSES with a reason built from its own walk: "Kayleigh's coach: no, Kayleigh walks 67.6, we'd give away
size" (OppWeight's walk vs the ask). A refusal leaves the offer at the limit.
SHORT-NOTICE OFFERS (new): when a world bout loses a fighter (Matchmaking.offers :150), an offer can come 10-14 days out at a
catchweight +2 kg or at the fighter's walk, with the purse +30% (pro) or a favour owed (amateur) (GAME VALUE). No cut is possible, so
the decision is size and ENERGY now against a planned camp later.
REFUEL (professionals, the WEIGHT PLAN's pro row): STANDARD (back = dried + trimmed + 1%) or AGGRESSIVE (+1% more, but ENERGY -2 if the
scale-to-bell time is under 24 h, GAME VALUE). The second-day limit blocks AGGRESSIVE.
THE WATER (professionals): 0 / 1 / 2 / 3% in the last 24 h.
SETTLED CONTRADICTIONS (kept): a club show weighs in 1 h before its first bell; championships 9 am; TR T8's regional and nationals move
to the day; CW 3.7's club scale moves to the class limit (the 1.0 kg lives on as ASK A KILO); TS's 66.0 becomes 65.0.
LINKS. Money: the purse share, favours. Fight: ENERGY, size, the second-day cap. Career: catchweights give half ladder credit.

### Part 5. GRADED CONSEQUENCES, PRICED BEFORE THE SCALE
THE LADDER: section 2's rows. MISS RISK (new): one badge in the WEIGHT PLAN header, from the slip chance, the slip size and the spare
kg against the 2% trim cap: "MISS 2 IN 100 with this plan". Beside it, IF SAMIRA MISSES, this bout's real prices: up to 1.0 kg over:
ask a kilo (favours held: 1 of 2) or the walkover; over 1.0 kg: a walkover loss, -$450 ticket cut, mood -6, ladder 5th to 7th; the
record: a miss stays 12 months, 2 = fewer offers.
THE DECISIONS ON THE SCALE (the weigh-in modal):
- PRO, 0.45-1.0 kg over: SWEAT IT OFF in the hour (ENERGY -1 a 0.1 kg) or STEP OFF AND PAY (25% of the purse).
- AMATEUR, up to 1.0 kg over: ASK A KILO (1 favour) or TAKE THE WALKOVER.
- THE OTHER CORNER MISSES: decided IN ADVANCE now (a standing order on the WEIGHT PLAN's other-corner box, the coach's default "box them
  unless the ladder is at stake"): BOX THEM (pro: +25% of their purse; amateur: they owe a favour) or REFUSE (amateur: walkover win;
  pro: no bout, the $300 slot paid to the club). The modal only confirms it.
REPEAT MISSES (REAL 5c: no study; a game rule built on the rule books): 2 in 12 months = half the offers at that class for 6 months,
reputation -4; 3 = forced up a class (California's rule).
THE CRASH CUT: an amateur who takes off more than 5% in the last 7 days (REAL 5d: Green 2007, judo) or a pro with water over 3%. Never
hidden: the trim and water steps past it are red. Effect: injury chance x1.5 in that bout, STAMINA -3 for the bout and -1 for two weeks,
mood -6, discipline -2, news (GAME VALUE; REAL 5d: 9.3% in 24 h caused kidney injury). No brain-injury claim (REAL 5d: no proof).
COACH'S CHECK WEIGHTS (new, the gate before fight week): every camp Monday the line carries a target (the plan's own line + 0.1 kg).
- On track: nothing happens; the week review ticks it.
- Over: a card on Monday with two choices: SWITCH THE DIET NOW (e.g. Lean to Cut; the plan table re-prices) or ASK TO MOVE THE DATE
  (amateur: a favour, the show may say no; pro: one week later, promoter trust -1).
- Pro title checks (30 days ≤ limit +10%, 7 days ≤ +5%; REAL 4d WBC): a failed check warns the promoter (trust -1); two failed = the
  bout may be given to the next contender.
- The CONTINUE button names it: "to Mon 23 Feb, weight check".
LINKS. Money: purse shares, the $300, the $450 ticket cut. Mood -6 for a walkover loss. Reputation. Career: the miss record, offers,
the forced move. Fight: the crash cut's STAMINA.

### Part 6. THE OPPONENT CUTS TOO, AND YOU SCOUT IT
THE RULE (kept): every opponent gets `walk` (amateurs 2-7% over, pros 6-15%; GAME VALUE inside REAL) and plays the coach's cheapest
plan. One module (OppWeight) replaces the two invented formulas (CODE TapeRows.gd:71-80, TaleOfTape.gd:24-29).
FOG (new; the free exact numbers are gone):
| What the player knows | Unscouted | Amateur: tape study (OppFile stages, OppFile.gd:2) | Pro: the $250 scout (Matchmaking.gd:39) |
|---|---|---|---|
| Walk | a 2 kg range ("67-69") | ± 0.4 kg after the first tape | ± 0.2 kg |
| The cut and trim | unknown | the trim (± 0.3 kg) after the first tape | exact |
| Faded late before? | locked | the second tape opens it from their record | opens it |
THEY MAY FADE LATE: no separate rule. Their ENERGY starts lower by their own trim and water; the fight's ENERGY already runs out late
(EnergyForecast.gd). Kayleigh, scouted: 100 - 4 carried - 2 Lean - 13 trim 0.9 = 81, five under Samira's 86 (round 1 printed -9 for
this trim; the rule says -13).
THE PRIZE AN AMATEUR CAN WIN (the size edge is dead at a same-day scale): "Kayleigh starts 5 ENERGY under Samira: the gap grows each
round" with WRITE IT: one click adds a plan line (PlanLines / PlanTemplates: "Steady R1-2, Push R3" or "When Kayleigh tires: let your
hands go") and shows its win gain ("+2 in 100").
THEY MAY MISS: under 6% cut 1 in 100; 6-10% 1 in 30; over 10% 1 in 10 (GAME VALUE; REAL 5c ~6% of UFC bouts; REAL 6: missers won 31%).
LINKS. Fight: their ENERGY, size, the plan line. Money: their purse share, the $250 scout. The film: a heavy cutter is a tell.

### Part 7. A PLAN YOU CAN CALCULATE
THE PANEL (training scene, drawn): the LINE TO THE SCALE, day by day in kg for the chosen plan, other plans dashed, the slip band, the
coach's Monday check as a marker, the trim's three days, the limit in red. Under it THIS WEEK BY CAUSE: "Lean -0.22 · 3 Hard roadworks
-0.13 · 2 rest days +0.08 = -0.27 kg" and ONE SWAP the coach suggests with its kg ("Swap Sun rest for Light roadwork: -0.06 kg").
Round 1's kg-a-day table (three decimals) is gone; the per-session kg sits in each session's hover (WeekPlan.gd:244-245, :262-263).
THE PLAN TABLE (whole plans, one row each; the coach marks the cheapest that makes weight):
| Plan (Samira, 65.9 now, limit 65.0, 12 days, house rule Meal prep) | The scale | Camp goal (Stamina +2.5) | ENERGY | WIN | If Samira slips Sat 21 |
|---|---|---|---|---|---|
| HOLD + trim 1.0 | 65.9 -> trim 1.0 -> 64.9 MADE | met | 81 (-4 · 0 · -15) | 52 | no diet to break |
| LEAN + trim 0.6 (COACH) | 65.5 -> 0.6 -> 64.9 MADE | met | 86 (-4 · -3 · -7) | 54 | trim 1.1, ENERGY 76, 50 |
| CUT + trim 0.3 | 65.2 -> 0.3 -> 64.9 MADE | close (+2.2) | 85 (-4 · -8 · -3) | 52 | trim 0.8, ENERGY 77, 49 |
| LEAN + trim 0.3 + ASK A KILO (GAMBLE, amateur) | 65.5 -> 0.3 -> 65.2, 0.2 OVER | met | 90 (-4 · -3 · -3) | 56 | 0.7 over, still a favour, 55; no favour = walkover |
MISS per row: 1 / 2 / 1 in 100; the gamble needs 1 of 2 favours. Win = 54 + 0.4 x (ENERGY - 86) with Push R3, - 1.5 for a goal left
close (P10 checks the band). The TRIM is set by the coach (the row's trim); the stepper opens from a row and marks every step: 0 =
0.5 over (ask a kilo), 0.3 = 0.2 over (a favour), 0.6 made -7, 0.9 made -13, 1.2 made -19, 1.3 = the 2% cap.
The diet cards lose their kcal (it sits in the hover: "Lean: 250 kcal a day under Hold = 0.032 kg a day; 7,700 kcal = 1 kg").
LINKS. Every number comes from one run (the week sim plus WeightRules), the same run the training scene's three sums use (TS 6).

## 4. Every decision as a table (when, the options with prices, which case each wins: never printed on screen)

| # | When | Decision | Options and their prices | Which case each option wins |
|---|---|---|---|---|
| D1 | Fighter page, CLASS card | THE CLASS | DOWN / STAY / UP, NOW or AFTER THE NEXT BOUT; DOWN: weeks of diet to get down (ticket cuts lost), a bigger cut each camp, the roster clash, loyalty -3 past 8%; UP: size against (to -2.4), a thinner ladder with fewer offers | DOWN: a pro with discipline 60+ and a walk under 10% over the lower limit, or a thin lower ladder near the pro offer. STAY: the cut is under 6% and the rank climbs. UP: the walk keeps rising or the cut costs the goal every camp |
| D1b | CLASS card | TEST THE WEIGHT | one catchweight bout between the classes: half ladder credit, no lock | when DOWN looks right on paper but the fighter's discipline is under 50 (slips decide it) |
| D1c | An ask card | HEAR or OVERRULE the fighter's class ask | hear +5 morale; overrule -4 (and loyalty -3 if it forces a cut past 8%) | hear unless the move costs the pro offer or clashes with a team-mate |
| D2 | The bout offer | CONTRACT WEIGHT | limit / catchweight +1 (favour or 10%) / +2 (15%) / matched / second-day limit | catchweight: a fighter whose cut is past 6% against a natural for the class; limit: when the ladder credit is the point; second-day limit: against a big pro refueller with a power plan |
| D3 | The bout offer | SHORT NOTICE at +2 kg or the walk | +30% purse or a favour owed; no cut, no camp | take it when the size gap is under 1.5 kg or the fight plan is pace; pass with a power opponent |
| D4 | WEIGHT PLAN, any camp week (the coach picks by default) | THE PLAN (diet + trim) | section 3 part 7's rows | HOLD + big trim: under 0.5 kg to lose, or a goal that needs every morning. LEAN + mid trim: most camps. CUT + small trim: over 1.2 kg to lose, or a same-day scale where trim is dear. GAMBLE: favours held, a 0.1-0.3 kg gap, a pressure plan |
| D5 | WEIGHT PLAN, pro, last 3 days | THE WATER and THE REFUEL | water 0-3% (ENERGY), refuel standard / aggressive | water + aggressive refuel: no second-day clause, a power plan, the opponent a natural; none: a pace plan |
| D6 | WEIGHT PLAN, once per fighter | HOUSE RULES | Free / Meal prep $70 a week / + Monday weigh-in (mood -1) | Free: discipline 70+. Meal prep: discipline under 50 and cash spare. Weigh-in: a 0.3 kg margin and mood Good+ |
| D7 | Club > People | THE NUTRITIONIST | $100 a week, all fighters | two or more fighters cutting at once, or a pro with a water cut |
| D8 | Monday of a camp, over the check | SWITCH THE DIET or MOVE THE DATE | switch: the plan re-prices (gains, Fatigue); move: a favour / promoter trust -1 | switch: 2+ weeks left; move: under 2 weeks and a crash line ahead |
| D9 | WEIGHT PLAN, other corner box | IF THE OTHER CORNER MISSES (standing order) | box (+25% of their purse / a favour owed) / refuse (walkover win / no bout, $300 slot) | box: their miss came from a crash cut; refuse: the rank is near the pro offer, or they are 2+ kg heavier on the night |
| D10 | WEIGHT PLAN | WRITE IT (the fade line) | adds a plan line, no price | when the other corner starts 4+ ENERGY under |
| D11 | The scale, pro, 0.45-1.0 kg over | SWEAT or PAY | sweat: ENERGY -1 a 0.1 kg; pay: 25% of the purse | sweat while ENERGY stays over 70 |
| D12 | The scale, amateur, up to 1.0 kg over | ASK A KILO or WALKOVER | 1 favour / a loss, mood -6, -$450 | ask while a favour is held and the rank is at stake |
| - | Forced after a 3rd miss in 12 months | UP A CLASS | no choice; the card says why | - |

## 5. Every menu it appears on, and what each is wired to (the S425 rule)

New code: `scripts/rules/WeightRules.gd` (pure: diets, walk drift, trim, water, refuel, the ENERGY sum, night weight, size edge, slip
chance, miss risk, crash line, the plan table rows, class options), `scripts/rules/OppWeight.gd` (pure: an opponent's walk, plan,
fog by scouting stage, night weight, the accept/refuse reason), `scripts/state/WeighDay.gd` (the scale's day and hour, the graded
result, the standing order, the miss record, the forced move), `scripts/rules/ContractWeight.gd` (pure: contract options and prices,
short-notice offers), `scripts/state/Classes.gd` (moves, scheduled moves, the test bout, asks). Sim.gd is at 499 lines: its weight
lines (week_ctx :117-121, the clamps :149-151, :214-216) move out, net lines <= 0.

| # | Menu | What it shows | Wired to today (file:line) | New wiring |
|---|---|---|---|---|
| M1 | Training scene: WEIGHT sum card (TS :49-50) | SCALE SAT 28 · 4 PM, now -> scale, MADE / OVER, MISS RISK, the coach's plan | WeekCamp.gd:76-94, :236-262; GaugeRow.gd:141-148, :246-248 | WeightRules.plan_rows(f, bout); click opens M2 |
| M2 | Training scene: WEIGHT PLAN (drawn) | the line + Monday check, week by cause + one swap, the plan table, ENERGY sum, trim steps, other corner (fog, standing order, Write it), house rules, nutritionist, miss box | none (TS mark 6) | WeightRules.path / plan_rows / energy_sum / miss_risk; WeekPlan day kcal (:244-245, :262-263); OppWeight.known(opp, scout_stage); PlanLines add on Write it; f.house_rules |
| M3 | Fighter page: CLASS card (drawn) | walk + when STAY stops being cheap, DOWN/STAY/UP rows, the ask, Test, Move now / after | FighterPage.gd:127-129; DarkOverview.gd:379-387 | WeightRules.class_options(f, ladder, roster); Classes.move / schedule / test; WeekTwist ASKS + PushBack.pick |
| M4 | Bout offer (BoutPage, VersusPanel) | the scale's day and hour, CONTRACT WEIGHT options with ENERGY / size / ladder credit / price, the other camp's answer, short-notice tag, the plan's WIN | BoutPage.gd:44-56, :95, :145-147; VersusPanel.gd:159, :185-196; Bouts.makeable_day :150-162 | ContractWeight.options(f, opp); makeable_day reads WeightRules.best_plan; VersusPanel's WEIGHT row reads OppWeight.known |
| M5 | Monday card (week start) | the coach's check: on track / over with SWITCH or MOVE THE DATE; CONTINUE label "weight check" | WeekReview.gd:413-414; Main.gd (CONTINUE) | WeighDay.check(f, monday) |
| M6 | Fight prep (last 3 days) | the trim (coach set, override), pro water + refuel, "Scale: 0.1 kg to spare", the hour | FightPrep.gd:30, :65-66, :92-99, :139-158 | WeightRules.plan; steppers write f.bout.trim / water / refuel |
| M7 | THE SCALE (weigh-in modal + toast) | the hour, the reading, MADE / the grade, its choices (D11, D12), the standing order (D9) confirmed | WeighIn.gd:2, :13-28; BoutActs.gd:219-227; Bouts.weigh :327-347; :89-91 | WeighDay.weigh_hour, WeighDay.weigh -> {grade, choices} |
| M8 | Tale of the tape (2D) and the 3D intro | ON THE SCALES, ON THE NIGHT (one line if under 1 kg for amateurs), the edge | TapeVersus.gd:21-26; TapeRows.gd:64-80; TaleOfTape.gd:16, :24-29 | OppWeight + WeightRules.night; the two old formulas removed |
| M9 | Fight night | ENERGY at the first bell with its parts, size edge, crash STAMINA | BoutRules.stale_energy :165-168; BoutNight.gd:104-110 | WeightRules.energy_sum and size_edge beside PEAK CAMP |
| M10 | The Why card after the bout | "Weight: ENERGY 79 at the bell (trim 1.0 kg -15) cost about 3 in 100 in round 3" / the size line | WhyCard.gd (29 lines) | WeightRules.why_line(bout) |
| M11 | Week review (Monday) | plan vs actual with the cause ("+0.5 kg, ate out Saturday"), the check result, clean camps 1 of 3 | WeekReview.gd:413-414; WeekActual.gd:42-45, :82-91; WeekCoach.gd:38-44 | WeekActual reads f.slips; WeekCoach names the plan |
| M12 | Home: roster row, needs, strip, fixtures | "0.9 to lose", "Scale today 4 pm", miss risk if 10+ in 100, walk drift | HomeRows.gd:15, :195-201; Needs.gd:75-76; Home.gd:62-63; Fixtures.gd:19 | WeighDay.weigh_hour; HomeRows reads walk, miss_risk |
| M13 | News | missed / sweat / walkover / crash cut / slip / class move / ask / the other corner missed / short notice | HomeSide.gd:11; c.add_news in Bouts.gd:339 | WeighDay, Classes, WeightRules events write lines |
| M14 | Club > People (staff) | NUTRITIONIST row with its effect and wage | StaffRoles.gd:7-15; StaffCard.gd:30-31 (role words, icons) | StaffRoles.LIST + "nutritionist"; WeightRules reads c.staff_roles |
| M15 | Fight plan page | the line added by Write it, tagged "from the weight plan" | PlanLines / PlanTemplates | PlanLines.add(line, source) |
| M16 | Fighters: roster table, cards, tile | class, walk, a miss dot, a scheduled move | RosterTable.gd:55-56; RosterCards.gd:175, :213-220; FighterTile.gd:57-60, :99-100 | read walk, f.misses, f.class_move |
| M17 | Create screen / the walk-in | "Walks 66.8 kg · Welterweight 65.0" | CreateScreen.gd:247-248; ClubStart | ClubStart sets walk |
| M18 | No-gi match day (Ana) | "Scale at the mat, before the first match", made / out of the bracket | NoGi.gd:74 (class word only) | WeighDay.weigh_hour for sport "bjj" |

## 6. The build (one owner each, every file under 500 lines, a golden-path step each; nothing starts before two critics score 7+)

| # | Task | Owner | Owns (lines) | Golden-path step |
|---|---|---|---|---|
| B1 | WEIGHTRULES1: pure module + tests (diets, drift, trim, water, refuel, ENERGY sum, night, size, slips, miss risk, crash, plan rows, win via win_chance) | Qwen (Goose route) | scripts/rules/WeightRules.gd (~320), tests/weight_rules_test.gd | - (unit) |
| B2 | OPPWEIGHT1: opponent walk, plan, fog by stage, refuse reason; TapeRows/TaleOfTape call it | Qwen | scripts/rules/OppWeight.gd (~120), two call sites, tests/opp_weight_test.gd | the tape and the 3D intro show the same weight |
| B3 | WALKWEIGHT1: `walk` in state, start values, drift, clamps replaced, save migration | Claude | Data.gd, ClubStart.gd, Sim.gd (net <= 0), CampForecast.gd, SaveGame.gd | after the first bout the weight climbs back |
| B4 | DIETS1: diets real in camp, gains and Fatigue, coach picks the cheapest row, TAPER_KG -> trim | Qwen | WeekPlan.gd (363 + ~30), WeekCoach.gd | Lean picked changes the scale and the gains |
| B5 | WEIGHDAY1: scale hour per bout kind (and no-gi), grades, standing order, miss record, forced move, crash cut, Monday checks | Claude | scripts/state/WeighDay.gd (~260), Bouts.gd (weigh moves out), Sim.gd:136-137 | a club show weighs in at 4 pm on the day; a Monday over the check offers the switch |
| B6 | CONTRACT1: contract weight, the other camp's answer, short-notice offers, second-day clause | Arena | scripts/rules/ContractWeight.gd (~180), tests | a catchweight ask is refused with Kayleigh's reason |
| B7 | NIGHTSIZE1: ENERGY sum at the bell, size edge, plan weights (x1.4), Why line | Arena | BoutNight.gd hook, BoutRules.gd (300 + ~15), WhyCard.gd (29 + ~20) | the fight starts with the sum shown; the Why names it |
| B8 | SLIPS1: slips, house rules, discipline growth, mood events, nutritionist staff row | Qwen | WeightRules (slip roll), FighterProfile.gd (+3 events), StaffRoles.gd (65 + 3), Sim Monday hook (net <= 0) | a slip shows in the week review with its cause |
| B9 | CLASSES1: new classes (Kalli names), Classes.gd (move now/after, test bout, asks via WeekTwist), ladder placement, roster clash | Claude + Kalli | Data.gd DIVISIONS, scripts/state/Classes.gd (~200), WeekTwist.gd ASKS (+2 cards) | moving Samira up after the next bout re-deals Samira's offers at 70 kg |
| B10 | WEIGHTPANEL1: M1, M2 | Cursor | scripts/ui/WeightPlan.gd (~420) + WeightLine.gd (~200) | the panel's numbers equal WeightRules' run |
| B11 | CLASSCARD1: M3 | Cursor | scripts/ui/ClassCard.gd (~350) | DOWN / STAY / UP with labelled rows; STAY by default |
| B12 | WEIGHTSHOW1: M4-M9, M11-M18 | Cursor | the files in section 5, each edit small | every menu in section 5 shows its line in the .exe |
| B13 | WEIGHTGOLDEN1: offer (contract) -> plan -> slip -> Monday check -> trim -> scale at the hour -> standing order -> night weights -> ENERGY sum -> the Why line -> drift back | Grok Dev | tests/weight_golden_test.gd | the whole path |
| B14 | John: TO SOURCE items (no-gi scale rules, meal-prep and nutritionist prices, cycle-week water, EB matching allowances) | John (chat seat) | ops/research/WEIGHT_SOURCES_S434.md | - |

## 7. The probes (the gate before the pixels: each runs on the built rules)

| # | Probe | Bar | If it fails |
|---|---|---|---|
| P1 | Forecast honesty | discipline 80+: scale morning within 0.1 kg in 95 of 100 runs; any discipline: inside the band 95 of 100 (women: with the cycle band) | widen the band or fix the forecast before any UI |
| P2 | The prize is small and the price can cancel it (equal fighters, 3 kg gap) | heavier wins 53-58 with no price; with the trim and 3% water that bought it, 48-53 | scale the edge |
| P3 | No dominant plan row (300 seeded camps, both sexes, amateur and pro, 4 classes) | each of HOLD, LEAN, CUT rows is best (by WIN, then goal) in 15+ in 100; the GAMBLE in 5-25 in 100 when favours are held | re-price LEAN / CUT / the gamble |
| P4 | Real ranges in the world | amateur cuts 3-7% (median ~5%); pro walks 6-15% over; pro night gain 4-9%; amateur 1-2.5% | re-seed OppWeight |
| P5 | Misses | world pro bouts with a miss 3-7 in 100; the roster on the coach's plans under 1 in 50 | re-price |
| P6 | Slips and house rules | discipline 34: 40-55 in 100 diet weekends; 80: 8 or fewer; meal prep halves; meal prep pays back (avoided extra trim) in 1 of 2 camps for discipline under 50 | change the slope or the price |
| P7 | The opponent's fade | opponents trimming over 1.5% or drying over 2% lose round 3 more often by 3-8 in 100 | the ENERGY price is off |
| P8 | Walk drift | 45-60% of the cut back in week 1, at the walk by week 4 | change the drift |
| P9 | Class moves are a trade (50 careers) | down and up each win 45-55 in 100 of the next 10 bouts | change the edge or ladder placement |
| P10 | The plan decision matters | best and worst sensible plan rows differ by 3+ in 100 WIN in 60+ in 100 camps | raise the plan weights (x1.4) or the trim prices |
| P11 | Catchweight is a trade | with the coach's default, catchweight asks win the bout more often but cost ladder places; accepted in 30-70 in 100 asks | change the purse share or the refusal rule |
| P12 | Monday checks fire usefully | a check flags 70+ in 100 of the camps that would miss, with 2+ weeks left; false alarms under 1 in 5 | change the check's slack (0.1 kg) |
| P13 | The nutritionist | pays its $100 back (ENERGY -> win -> purse and ticket cuts) with 2+ fighters cutting; not with one amateur | change the wage or the effects |
| P14 | Discipline growth is slow | a disciplined club gains +4 to +6 a year; never past +6 | change the steps |

## 8. What changes against today (for the brief writers)

- The camp no longer cuts by itself (Sim.gd:117-118); the plan rows are real. TAPER_KG (WeekPlan.gd:70-72) becomes the trim.
- Amateurs and no-gi weigh in on the day; pros the day before (Bouts.gd:89-91, Sim.gd:136-137).
- A miss is graded (Bouts.gd:338-345, BoutRules.gd:88); `bout["made"]` (Bouts.gd:331, never read) becomes the grade.
- PEAK CAMP's weight line (PeakCamp.gd:35) reads "made at the scale" from the grade.
- The opponent gets one weight from OppWeight, behind the scouting stages (TapeRows.gd:71-80 and TaleOfTape.gd:24-29 go).
- The clamp band goes (Sim.gd:149-151, :214-216; CampForecast.gd:67-69); `walk` replaces it.
- The Old hand (HeadCoach.gd:23-24) keeps -120 kcal on a cut and adds the trim price x0.75 (floor x0.65 with the nutritionist).
- CW 3.7's club scale moves to the class limit; TS's 66.0 becomes 65.0; TR T8's regional and nationals move to the day.
- StaffRoles gains the nutritionist; WeekTwist gains two class asks; the bout offer gains contract weight.

## 9. Open for the owner (scope only)

- Add two classes so UP and DOWN are real steps: women 70 kg, men 65 kg (World Boxing classes; Kalli writes the names).

## 10. The critics, round 2

Not yet scored. Brief: CRITIC_PACK.md + CRITIC_ACCESS.md first, then this map and the two r2 drawings; depth (7+), what a screen is
missing or does not need, what each changes; each ends with the list to 10/10 and draws its 10/10.

## 11. Round 1's points and where they went

| Critic point | Done in round 2 |
|---|---|
| Contract weight on the offer (both) | Part 4 table, D2, M4, B6, P11 |
| Coach's check weights | Part 5, D8, M5, B5, P12; CONTINUE says "weight check" (drawn) |
| Meal prep instead of the club dinner (both) | Part 3 house rules, D6 (drawn); club dinner cut |
| Nutritionist staff job (both) | Part 3, D7, M14, B8, P13 (drawn) |
| Test the weight for one bout | Part 1, D1b (drawn) |
| The fighter's voice on the class (both) | Part 1 asks, D1c, B9 (drawn: "Samira asks") |
| Short-notice heavier offers | Part 4, D3 |
| Refuel setting + second-day limit | Part 4, D5 |
| Cycle week band | Part 3 (forecast only, ESTIMATE, TO SOURCE) |
| A Why line | M10, B7 |
| One currency: WIN on every option; ENERGY sum (sim) | Part 2, part 7's table, the ENERGY bar (drawn) |
| Kayleigh -9 vs -13 | fixed: -13, Kayleigh 81 (part 6) |
| Opponent fog + Write it | Part 6 fog table, D10, M15 (drawn) |
| Trim + ask a kilo as a plan row | the GAMBLE row (drawn) |
| Discipline grows | Part 3 (drawn: clean camps 1 of 3) |
| Weekend as a standing house rule, plain fractions | Part 3, D6 (drawn) |
| Class card: business, next 3 with win, top-5 walks, roster clash, move after next bout, when STAY stops being cheap | Part 1 (drawn) |
| BJJ weight rule | Section 2's no-gi column, M18 |
| Trim steps marked MISS / favour / cap | Part 7 (drawn) |
| MISS RISK badge + If Samira misses | Part 5 (drawn) |
| Decide in advance if the other corner misses | Part 5, D9 (drawn) |
| CUT: kg-a-day table, kcal on cards, greyed water row, amateur size bars, HOW A MOVE WORKS footer, unlabelled icon chips | all cut: week by cause + one swap; kcal in hover; water in the scale chip; one LEVEL line; the move rules in the Move buttons' hover; row labels |
| Coach sets the trim (both) | the plan row carries the trim; the stepper opens from the row |
