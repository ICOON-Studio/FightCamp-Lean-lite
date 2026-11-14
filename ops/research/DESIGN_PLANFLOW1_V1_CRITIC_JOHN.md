# PLANFLOW1_V1 - score this mechanic's DESIGN (S459 design loop)

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

# DESIGN_PLANFLOW1_V1_WRITE_KALLI_KALLI - Kalli answer (seat queue SQ117)

Brief: research/DESIGN_PLANFLOW1_V1_WRITE_KALLI.md
Sent: 2026-11-14 15:10 | collected: 2026-11-14 15:28 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# PLANFLOW1 v1: the fight plan as an if-then flowchart (S459, S469, 2026-11-14)

Part 1 of 4

**Owner rules this map keeps, quoted**
- S469: "go with your recommendation". The flowchart is the new look of the plan the game already has, not a second plan system. It ships in three steps, simplest first ("ok").
- S448: "notice how the names are only mentioned on the header, nowhere in text menus options, follow that rule". Boxes, diamonds, lines and tooltips say your boxer, the opponent, your coach.
- S412: any gym, any boxers, men or women. No fixed he or she anywhere on these pages.
- S425: wired and shown on the correct menus, deep enough for a critic's 7/10.
- Section 7: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- The pack: no timers, no flavour text, one word per concept. Females never fight males. Scouting means opponents.

**Tags**
- **CODE** means Claude read it in the code (S469 brief or the pack).
- **REAL** means real boxing practice.
- **GAME VALUE** is a value the game already uses, carried over.
- **ESTIMATE** is a starting value the probes size.
- **NEW** is a small addition this map asks for, named so Claude can price it.

## 1. The decisions, in order

| When | What the player chooses | What it costs or risks | Tag |
|---|---|---|---|
| **The bout is booked** | Nothing to press. Your coach's preset for the opponent's style loads as the plan, built only on free habits (section 3) | none; the preset is about half a good plan | CODE (assistant writes one, "poor to about half") |
| **Camp, film study** | Which camp days go to Film; each opens one habit on the opponent's file, which unlocks one diamond | a film night is a night off the pads: about 240 drill units lost | CODE (tape opens a tell every few camp days; 240 units a pad night) |
| **Pro: scout** | Scout ($250) opens weapon and weakness at once | $250 | CODE |
| **Camp, the editor** | Draw the main line (3 to 4 boxes), place up to 3 IFs on found habits, set Plan B | each box is a move your boxer must drill, so the plan spends pad time | CODE (worth × pad time) |
| **Camp, the tray** | The Training tab's tray becomes "THE PLAN vs the opponent": drag each box's drill card to a pad night | under 30 the box wears the red stamp and is skipped on fight night | CODE |
| **Camp, Test it** | Run the plan against the opponent's file (limited tries) | tries are limited, so testing is a choice | CODE (Test it exists) |
| **The night before** | Last edit, then the plan locks at the weigh-in | an untested late change keeps its red stamps | ESTIMATE (lock point) |
| **Fight night, live** | v1 nothing: watch which branch fires. v2 one shout aims a box (section 5.3) | v2 a shout spent on a box is a shout not spent on a call | CODE (shouts) |
| **Corner minute** | Change ONE box or diamond, with this round's fired counts on screen | one change a round; changing a box that worked resets its reads | CODE (one arrow a round; reads reset at the corner) |
| **After the bout** | The result's "The plan, lit up" shows the flowchart with counts. Redraw for the next opponent | a reused plan meets opponents who adjust, and a pro corner that reads it | CODE (adjust, ProRead) |

## 2. Today's data, drawn as the flowchart (nothing the bout can't honour)

| On the page | In the code | Rule |
|---|---|---|
| **Top node**: "Opening: <card>" | the card the opponent's game puts your boxer on at the bell | CODE (PlanFight). The player doesn't pick it; the file shows it once film finds the opponent's game |
| **A box on the main line** | the ANY-TIME arrow `{move, when: any}` on one card | CODE (PlanBoard) |
| **The line from box to box** | where a WON exchange leaves your boxer: the card the box's move goes to | CODE (PlanChain). So the main line is a real chain: box 2 sits on the card box 1's move leads to |
| **An IF diamond beside a box** | a SITUATION arrow `{move, when: <habit>}` on that box's card | CODE. It's taken first when the habit holds this exchange, else the box (PlanBoard.pick) |
| **A diamond's colour** | best / ok / wrong against the opponent's game | CODE |
| **The number on a box** | worth = match × pad time − the average of everything your boxer can do on that card | CODE. Shown as "+n edge", hover shows the parts |
| **The red stamp** | mastery under 30; the coach skips the step on fight night | CODE |
| **The read pips** | reads up (gold pips) or down (red) this round, to the cap | CODE. They reset at the corner minute |
| **Plan B bar** | see below | |

**What Plan B is in code terms.** It's the any-time arrow on the card a LOST exchange sends your boxer to: the opponent's card (CODE, PlanFight). That card is also the opening card, so on the page Plan B is the box at the top, and the "return to top" arrow from the owner's picture is honest: a lost exchange really does go back there.
- So Plan B is drawn as a bar at the bottom with its return line, but it is the opening card's any-time arrow, written once. It is not a third thing.
- **The tired and hurt rule is NOT Plan B.** "When tired or hurt your boxer stays where the fighting is" (S466, CODE) is drawn as a fixed grey diamond, "HURT: hold this card", on every box. In v1 the player can't change it; v2 makes it a state IF (section 5.2).
- **Rejected:** a Plan B that fires "after losing an exchange" as a separate arrow. It needs a new `when` reading the last exchange's result. It's cheap, but it adds nothing the return line doesn't already show. CHECK (Claude): whether `when: lost_last` would be one line in PlanBoard.pick. If it is, it's a v2 candidate.

**Main line length.** A won exchange can lead to a card already on the line, for example a move that steps back out to long range. The line then loops, drawn as an arrow back up, and that's honest. The editor allows at most 4 boxes, one per card (CODE: one any-time arrow per card).

**A diamond with no box.** A situation arrow on a card with no any-time arrow is legal in code. It's drawn as a diamond hanging off an empty, dashed box, "no main move: improvises here". It's legal and shown, but the empty box costs edge 0 exactly as the code does.

## 3. The IF habits

An IF is a habit that holds for a whole exchange, never one punch's outcome (S469). A diamond may sit only on a habit film found, or on one marked FREE, which every opponent of that style has.

### 3.1 Boxing (10)

| IF the opponent… | Free or found | Right answers (best, then ok) | Tag |
|---|---|---|---|
| **presses** | free for a Pressure fighter or Slugger; found for others | best: step back + check hook, pivot out. ok: tie up, 1-2 | mode CODE (Pressing) |
| **boxes at range** | free for an Out-boxer; found for others | best: cut off + jab to the body, herd. ok: 1-1-2 | mode CODE |
| **waits to counter** | free for a Counter-puncher; found for others | best: feint, draw the lead. ok: 1-1 | mode CODE |
| **loads up** | free for a Slugger or Boxer-puncher; found for others | best: jab first, slip 2-3. ok: tie up | mode CODE |
| **tires** | FREE, everyone | best: body hook, let the hands go (1-2-3-2). ok: 2-3 | mode CODE (Tiring) |
| **is hurt** | FREE, everyone | best: the finishing combination your boxer owns. ok: 1-2 | mode CODE (Hurt) |
| **shells up** | found | best: body hook, pivot out. ok: uppercut | tell name CHECK (Claude) |
| **circles away** | found | best: cut off, check hook. ok: step in + jab | tell name CHECK (Claude) |
| **switches stance** | found (free against a known switch-hitter) | best: lead hook to the new lead side, step out. ok: jab | tell name CHECK (Claude) |
| **bites on feints** | found | best: feint + 1-2, feint low + cross over the top. ok: feint + jab | tell name CHECK (Claude) |

**On the ropes is NOT an IF.** The ropes are a card, so they're a box. In the owner's picture, "on the ropes" is answered by the box on the ropes card.

**Habit share.** Each found habit says on the file how often it showed: "pressed in 3 of 4 films". That number is what the diamond is worth betting on (section 4). CODE for the tells; the share line is NEW (the count of films it showed in).

### 3.2 BJJ (6, on the position tree)
The steps are positions on BjjTree: guard, half guard, side control, mount, back. A box is the pass, sweep or submission your athlete drills from that position.
- **Timing.** A BJJ beat is about 11 seconds (CODE, S405), so an IF holds over a run of 3 beats, about one exchange's 30 seconds. ESTIMATE.
- CHECK (Claude): whether BjjSide's picks can read a habit over 3 beats.

| IF the opponent… | Free or found | Right answers |
|---|---|---|
| **turtles** | found | best: take the back. ok: front headlock |
| **stalls in guard** | FREE | best: the pass your athlete owns. ok: stand to break |
| **bridges from mount** | found | best: follow to technical mount. ok: armbar |
| **frames from bottom side** | found | best: knee on belly. ok: switch to mount |
| **guards the neck** | found | best: switch to the armbar. ok: keep position for points |
| **tires** | FREE | best: keep the pace, pass. ok: hold for points |

Part 2 of 4

## 4. Depth: why a good flowchart beats a lazy one

### 4.1 What we have, measured
- **S396:** a good plan wins 59% of close bouts, no plan 46%, a bad plan 43% (CODE, measured). So the plan already turns about 1 close bout in 8.
- **S468:** on 20 sample bouts, the plan as written wins 9 of 40, and the best single change 11 of 40 (CODE, measured). One change is worth about 1 bout in 20. That's too little for the player to feel, and it's why the editor isn't yet worth drawing.

### 4.2 What makes the plan matter more (no flat bonus)
Each lever comes from a cause the fight already has.

1. **Found diamonds are the only route to "best" against a found habit.** A free-habit preset can reach "best" only on the free modes. So a hand-made plan with three found IFs gets about two more "best" exchanges a bout than the preset (ESTIMATE, probed).
2. **Reads compound inside a round.** A right planned answer that wins puts the opponent one read down for the rest of the round (CODE). A diamond that fires in exchange 2 makes exchanges 3 to 6 easier. That's why an early-firing IF is worth more than a late one, and the page says so: the box hover shows "fires early: reads build".
3. **Habit share decides the bet.** A diamond on a habit the opponent shows in 1 film of 4 rarely fires. One the opponent shows in 4 of 4 fires most rounds. The player weighs a strong answer to a rare habit against an ok answer to a common one.
4. **Pad time is the budget.** Every box and diamond is a move to drill. Four boxes and three diamonds can be up to 7 drill cards, and a week has 3 pad nights (CODE). A plan with more boxes than your boxer can drill gets red stamps, and the coach skips those steps. The plan's size is a training cost, not a free choice.

**Target numbers, ESTIMATE, set as probe pass lines (section 6):**

| Plan | Close-bout win rate |
|---|---|
| No plan | 46% (CODE, S396) |
| Coach's preset (free habits only) | 51–53% |
| Hand-made with 3 found IFs, all drilled | 62–66% |
| One wrong IF | −3 to −5 points against the same plan without it |
| Built on a habit that didn't show | about the main line alone (section 7) |

### 4.3 What the opponent does about it
- **Adjusts.** An answer used again and again loses edge (CODE). A diamond firing 4 times in a round is worth less on the 4th. This caps any one diamond and rewards a plan with two or three different answers.
- **The pro corner reads it.** After round 1 a pro opponent's corner reads your boxer's plan (ProRead, CODE). On the page, the most-fired diamond gets a dashed outline and the coach's line says "They've seen the body hook." CHECK (Claude): which arrow ProRead targets. This map assumes the most-used one.
- **Habits shift.** A mode can change mid-round, for example from Pressing to Tiring. That's the code's own mode change, so the diamond that fires changes with it.

### 4.4 What a wrong IF costs
A wrong answer that loses puts your boxer one read DOWN for the rest of the round, and the planned wrong answer shrinks the energy ceiling (CODE). So a wrong diamond costs more than an empty one, which costs edge 0. That's the point: don't place a diamond you can't back.

### 4.5 Why redraw between fights
- **The habits are the opponent's.** A found IF on one opponent may not exist on the next.
- **The preset is per style.** The player's own plans are per opponent, saved on that opponent's file and reloadable for a rematch.
- **Reuse is punished.** For pros, a plan used against the same corner twice starts with that corner's read already in, from round 1. ESTIMATE: a NEW use of ProRead's memory, CHECK (Claude).
- **Your boxer changes.** New Sharp moves open better boxes, and new slots open (v2, section 5.1).

**No dominant plan.**
- A plan of all-free habits caps at the preset's level.
- A plan stuffed with diamonds runs out of pad time.
- A one-diamond plan is read and adjusted.
- The best plan is opponent-specific, drilled, and spread over two or three answers. Probe pass line 4 checks it.

## 5. The owner's further ideas, weighed (S469)

### 5.1 Slots from knowledge: TAKE, v2
How many boxes and diamonds a plan holds:
- Base 3.
- +1 at 5 bouts, +1 at 12 bouts, +1 at Fight IQ 65, +1 with an assistant coach rated 70+.
- The cap is 7, so the page stays readable.

ESTIMATE. Bouts, Fight IQ and coach rating are CODE. This replaces "the coach's skill sets how many lines (4–6)" with your boxer's and your coach's knowledge together. Plan B never takes a slot.

### 5.2 State and clock triggers: TAKE, v2, with one change

| IF | Exchange-level? | Notes | Tag |
|---|---|---|---|
| **The opponent's tank low** | yes, it's Tiring | already the free "tires" diamond; no new IF | CODE |
| **Your boxer hurt** | yes | the grey "HURT: hold" diamond becomes editable: hold this card, tie up, or shell | CODE (S466 rule) + NEW (choice) |
| **The opponent cut or swollen** | yes | needs the doctor's check (the pack lists cut states and a cutman job); the diamond appears only after a cut is called | CHECK (Claude) that the cut state is readable mid-round |
| **The last exchange of a round** | yes, exchange 6 is one exchange | "steal the round" | CODE (six exchanges) |
| **The last round, behind** | **change** | amateur boxing has no open scoring, so the corner can't know the cards. The trigger reads your coach's own count from the corner card, labelled "behind on your coach's count", and it can be wrong. That's honest | REAL (no open scoring) + CODE (corner card) |

### 5.3 Corner shouts: CHANGE
The idea is 2 a round, each pushing a box for the next exchange. The game already has a shout every 30 seconds, and only two a minute get through fully (CODE). A second counted resource beside it would be a second system, which S469 rules out.
- **Change:** v2 lets a shout aim at a box on the flowchart ("Body hook now"). It forces that box next exchange and uses the existing two-a-minute rule.
- This makes the shout bar and the plan one system.

### 5.4 Bait and conditioning: TAKE, v3
- Each won exchange to the body adds one "expects the body" pip on the opponent, up to 3.
- A diamond "IF expects the body: feint low + cross over the top" cashes the pips.
- The pips are the code's reads, given a target (CODE hook). Their payoff per pip is probed, never flat.
- A sharp opponent (Fight IQ 70+) gains pips at half speed (ESTIMATE).
- The pips show beside the opponent on the flowchart.

### 5.5 Composure: TAKE, v3
- Only after a knockdown or a hurt, the page shows the chance first: "Holds the plan: 70%". ESTIMATE, from Composure and Heart, both CODE attributes.
- **Fail:** the plan greys out and your boxer fights the style's default (edge 0) until the corner minute.
- It's never hidden, and never at any other time.

### 5.6 Drilled or hesitant: TAKE, v1
It's already in the code. The box shows the mastery tier and number, and the red stamp under 30. With FireLevel on (S451, CODE), the box shows the fire rate:
- Usable: "fires 1 in 2"
- Sharp: "3 in 4"
- Signature: "always"

### 5.7 Between rounds: TAKE, v1
The corner minute shows the small flowchart with each box's and diamond's count this round, and FixLab's suggested line (CODE) outlined. The one change is made on the flowchart.

### 5.8 Feint loops: CHANGE
Taken only as the habit "bites on feints", found on film (3.1).

### 5.9 Signature chains: CHANGE (agree with Claude)
- No flat bonus. A chain's worth comes from causes the fight has: body work drains the tank, a drained opponent tires, and "tires" fires the finishing box.
- When a plan's main line plus diamonds is used in 3 bouts, the player may NAME it ("the body-to-head plan") and your boxer becomes known for it.
- A scouting opponent then finds it on film: their corner starts with one read on it (ESTIMATE, v3).

### 5.10 Left out, agreed
Cage, takedowns out of boxing, hybrids (MMA later), live sliders, gear with percentage buffs, any name outside a header, a 2D radar.
- **Real-time countdown on the corner change:** agree, leave it out. The pack's "no timers" rule and a paused corner minute are the game's identity. A countdown would punish reading, which is the very thing the flowchart asks for.

Part 3 of 4

## 6. Probes (400 bouts a cell, three seed sets, close bouts: rating gap under 3)

| Bot | Rule |
|---|---|
| NONE | no plan |
| PRESET | your coach's preset for the opponent's style, free habits only |
| GOOD | hand-made: the 3 most-shown found habits, best answers, all boxes drilled to Sharp |
| WRONG | the same shape with one diamond's answer set to "wrong" |
| STUFFED | 7 boxes, drilled only as far as 3 pad nights allow |
| ONE | one diamond, reused every bout |

**Pass lines (all ESTIMATE):**
1. GOOD beats NONE by 12+ points, and PRESET by 8+ points, in close bouts.
2. PRESET beats NONE by 4 to 8 points, so the preset helps but leaves room.
3. WRONG loses 3+ points to the same plan without the wrong diamond.
4. **No dominant plan:** STUFFED and ONE each finish under GOOD, and against pros ONE loses 3+ points from round 2 (ProRead). No single plan shape is best against all six styles.
5. **The player sees it:** a diamond fires at least 3 times in a 3-round amateur bout in 80%+ of GOOD bouts, and no diamond fires more than 9 (else it's really the main line).
6. **The main line works too:** at least 4 exchanges a bout go through main-line boxes after a won exchange.
7. **Habit share honesty:** a diamond on a "3 of 4 films" habit fires 2 to 4 times more often than one on "1 of 4".
8. **Training still wins:** a 10-point stat gap still wins about 90%+ with the weaker side on GOOD. The pack's rule is that training beats planning.
9. **BJJ:** the same as lines 1 and 5, over 3-beat runs.

## 7. The failure path that teaches (no rigged roll)

**The plan on a habit that didn't show.**
- Film found "presses: 2 of 4 films". The player built two of three diamonds on it.
- Tonight the opponent opens Boxing at range and stays there: the code's own mode pick, given the matchup.
- **Live:** those diamonds stay dark. The round line says, once a round, "Never pressed this round: your main line fought alone."
- **Corner minute:** the counts show 0 and 0 on the two diamonds. FixLab outlines the box on long range.
- **The Why:** "YOUR PLAN: two IFs on pressing, never fired. The main line won 5 of 12 on its own."
- **NEXT:** "Build the main line to stand alone; bet IFs on habits shown in 3 of 4 films."

**What it teaches:** habit share is a bet, and the main line must work without diamonds. The odds were on the file before the fight.

**A second failure: the undrilled box.** A diamond's move is under 30 on the night. It shows a red stamp and fires 0 times because the coach skips it (CODE). The Why line names it: "Uppercut not drilled: skipped 3 times."

## 8. Every menu, and what each is wired to (S425)

| # | Menu | What shows | Wired to |
|---|---|---|---|
| M1 | Fighter page > Playbook > Game plan | **the editor**, replacing the move-map arrows as the default view; "Open the map" stays as a switch | PlanBoard, PlanChain, worth calc |
| M2 | Fight prep > WHAT YOUR PLAN SHOULD ANSWER | each found habit with its share and "Add IF" (opens M1 at that card); hidden ones say what opens them | tells, M1 |
| M3 | Fight prep > Tape Room > YOUR ANSWER | the picked move becomes a diamond on the right card, not a loose line | Tape Room, PlanBoard |
| M4 | Fighter page > Week > the tray, "THE PLAN vs the opponent" | one drill card per box and diamond, each with the red stamp or tier; drag to a pad night | PadWeek, mastery |
| M5 | Fight prep, the primary button | "Write the game plan" until the plan has a main line; then "Check the plan: n stamps" while any box is under 30 | Fight prep state |
| M6 | Playbook > Game plan > Load preset | your coach's preset for the opponent's style; free habits only | preset per style (NEW content, 6 styles) |
| M7 | Playbook > Game plan > Test it | worth against no plan, and which diamonds fired in the test | Test it (CODE) |
| M8 | Fight night, live | the flowchart panel; the box in play outlined; a fired diamond lit with FIRED; read pips; the round line carries it | PlanFight, reads, round line |
| M9 | Fight night, corner minute | small flowchart with counts; FixLab's line outlined; change ONE box or diamond here; the pro "They've seen" note on the read diamond | corner change (CODE), FixLab, ProRead |
| M10 | Result > The plan, lit up | the full flowchart with fire and win counts per box and diamond | existing result view |
| M11 | Result > The Why | YOUR PLAN lines name diamonds and boxes, not "lines" | Why |
| M12 | Fighter page > Overview | "Fight plan (n boxes, n IFs)", replacing "(n arrows)"; opens M1 | Overview button |
| M13 | Rival file (modal) | each found habit with its share and whether your plan answers it | tells |
| M14 | Fighter page > History | per bout: the plan used, its counts; v3 the named plan | Records |

**Not on:** Home, Club, World, Fights. The plan isn't money or booking (section 7 rule). The bout offer's win band already counts the plan through the chance, so no plan chip goes on it.

## 9. Scope: what it does NOT do
- No punch-by-punch IFs.
- No live sliders.
- No gear buffs.
- No timers.
- No second plan system.
- No plan beyond 7 boxes.
- No name outside a header.
- No new screen: the editor replaces the Game plan tab's view.
- No MMA, cage or hybrid.
- No AI writing a plan better than the preset.

## 10. Owner questions (scope, money, taste)
1. Should the flowchart **replace** the move-map arrows as the Game plan tab's first view (the map kept behind a switch), or sit beside it?
2. In v2, should a corner shout aimed at a box use the existing two-a-minute rule (this map), or be its own 2 a round as in your list?
3. "Last round, behind" reads your coach's count, which can be wrong. Is a trigger that can misfire acceptable, or cut it?
4. v3 named plans: should an opponent who scouted a named plan start with a read on it, so being known costs something?

## 11. CHECKs
- **CHECK (Claude):**
  - Which tell names exist for shells up, circles away, switches stance and bites on feints.
  - Whether the cut state is readable mid-round.
  - Whether `when: lost_last` is one line.
  - Which arrow ProRead targets.
  - Whether ProRead remembers across bouts.
  - Whether BjjSide can read a habit over 3 beats.
  - The films-shown count per tell.
- **CHECK (John):** whether UK amateur corners keep their own round count (supports "behind on your coach's count").

Part 4 of 4

## 12. Build order (three steps, simplest first; owner "ok")

**v1: the look, the habits, the fired branch**
- The editor drawn from PlanBoard and PlanChain (section 2), with Plan B as the opening card's any-time arrow and its return line.
- The ten habits, found or free, with the share line.
- Red stamps and fire rates on boxes.
- The live panel with FIRED and the round line.
- Corner minute counts and one change.
- "The plan, lit up", the Why wording, and the presets.
- Probes 1, 2, 3, 5, 6, 7, 8.

**v2: slots, and state and clock triggers**
- Slots from knowledge (5.1).
- The editable HURT diamond, the opponent cut, the last exchange, and the last round behind on your coach's count (5.2).
- A shout aimed at a box (5.3).
- Probe 4.

**v3: bait and composure**
- The expects-the-body pips (5.4).
- The Composure check with the chance shown (5.5).
- Named plans and opponents reading them (5.9).
- Probe 9 for BJJ if BJJ lands then.

## 13. The editor page, 1920×1080 (Look B whiteboard, warm wall)

- **Header, 0–120 px:** polaroid of your boxer left (name once), "VS" and the opponent's polaroid right (name once), with the class in kg, style word and stance each.
- **Left column, x 40–440, "THE FILE":**
  - Habit chips, each 360×56: habit word, share "3 of 4 films", FOUND or FREE. Locked chips say "Film opens this".
  - Under them, the opening card: "Bell: long range".
  - Load preset button, 360×48.
- **Centre, x 480–1440, the flowchart:**
  - Top node 320×64 at y 160: "OPENING: <card>".
  - Main line: up to 4 boxes, each 320×110, x 560, at y 260 / 410 / 560 / 710, joined by arrows labelled with the card the move leads to.
  - Each box shows the move or combination (marker, 28 px), tier and number ("SHARP 64"), fire rate ("3 in 4"), and edge ("+2.1"). A red stamp sits top-right under 30.
  - Diamonds sit right of their box, 150×150 at x 960, with a line in. Each holds the habit word (22 px), the answer move under it, and a best/ok/wrong dot.
  - Grey "HURT: hold" stubs sit left of each box, 90×40.
  - Plan B bar: 760×70 at y 880, "PLAN B: <move> on <card>", with the return arrow up the left edge to the top node.
- **Right column, x 1480–1880, "WHAT IT'S WORTH":**
  - Slots "5 of 6" (v2), drill cards needed against pad nights left ("6 cards, 5 nights").
  - Warnings, one line each: "Uppercut under 30: skipped".
  - The worth line "+8 over no plan, your coach's test", in **gold** (the one gold on the frame).
  - Tests left "2 of 3".
- **Bottom bar, y 980–1060:** Save plan, Test it, Clear. No green; Continue lives in the top bar.
- **Hover:** every number explains itself: a box's edge breaks into match, pad time and card average.

## 14. The live fight page, 1920×1080 (fight night, dark and tight)

- **Top, 0–90 px:** the scorebug: both names once (header), the round, the exchange "3 of 6", and the opponent's mode clue word.
- **Left 1180×800, x 40–1220, y 110–910:** the 3D fight of the settled exchange, both fighters head to feet.
- **Right panel, x 1260–1880:** the flowchart at 60% scale.
  - The box in play is outlined in white.
  - A fired diamond fills red with "FIRED" (32 px) over it for the exchange, its line glowing back to the box.
  - The count by each diamond ("2").
  - Read pips beside the opponent's polaroid at the top of the panel: up to the cap, filled in gold when your boxer is up (the one gold) and red when down.
  - Dashed outline on a diamond the pro corner has read.
- **Bottom strip, y 930–1050, the round line,** one line, under 70 characters, no numbers: "Shelled up: the body hook lands, pivot out."
- **Corner minute, the same panel larger:** counts per box, FixLab's line outlined, "Change one" on each box and diamond.

## 15. My score
**DEPTH 6, GENERAL DESIGN 7, PLAY 6** (my own, not a critic's).
- **Depth.** Found habits as the only route to best answers, habit share as a bet, pad time as the budget, reads compounding, adjust and ProRead. The numbers that prove it are ESTIMATE until the probes run.
- **General design.** One system with a new look. Every element maps to code (section 2). 14 menus wired, no new screen. Points come off for seven CHECKs.
- **Play.** FIRED is the moment, and the failure path teaches. The live fight is still watched, not steered, until v2.

## To reach 10/10
1. **Run probes 1 to 8 on three seed sets.** Replace every ESTIMATE in 4.2 and 5.x with probed values. If GOOD doesn't beat PRESET by 8+, the found-only rule needs a stronger edge for found answers before the editor ships.
2. **Settle the CHECKs:** tell names, cut state, ProRead's target and memory, and the films-shown count. Each decides one row of section 3 or 5.
3. **Owner answers 1 and 2:** replace or beside, and the shout rule.
4. **Write the six presets as content:** one per style, free habits only, sized to pass line 2.
5. **Draw the two pages as PNGs at 1920×1080** from sections 13 and 14, with the eight MMA fighters for stress (a long combination name, a switch-hitter).
6. **BJJ:** confirm the 3-beat habit window, then draw the BJJ editor with positions as boxes.
7. **v2 slot numbers** probed so a green boxer's 3-box plan still beats the preset when drilled.
8. **Bait payoff and Composure chance** probed so neither becomes the dominant plan or a hidden swing.
