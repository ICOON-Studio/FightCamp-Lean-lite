> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups and the eight MMA fighters. Written S403 from the code; update it when a mechanic or screen lands.

## What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with **To reach 10/10**: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.



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

SANDBOX (S412): the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never a fixed he or she in text or mockups.

# What a critic can open (S403)

Operator: "giveaccess to miro board for the critics and everything else required". Read `ops/research/CRITIC_PACK.md` first, then use whatever here helps. All of it is read-only for a critic: change nothing.

## The Miro board
https://miro.com/app/board/uXjVEV03QWA=/ (the only board; never uXjVETf7la4=, it is archived).
Load the tools with ToolSearch, all in one call: `select:mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__canvas_read_as_svg,mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__canvas_search,mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__comment_list_comments,mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__image_get_data`
Read a frame with `canvas_read_as_svg`, `widget_ids: ["<id>"]`. The owner's notes are both yellow stickies and comments, so read comments too with `comment_list_comments`.

| Frame | Id | What it holds |
|---|---|---|
| MENUS FINAL (S402) | 3458764689777613662 | 17 menus: layout, Ludo's painted art, the owner's stickies |
| PAINTED MENUS (S401) | 3458764689772257568 | Painted version of each menu |
| MENUS FOR YOUR OK (S401) | 3458764689771007533 | The earlier round, with the owner's notes |
| MECHANICS LIST (S401) | 3458764689772104154 | 103 candidate mechanics and the owner's notes |
| P0 Where we are | 3458764689579200297 | What is done, being worked on, and next |

Some frames carry earlier critics' scores. Ignore them and reach your own verdict: they are there for the owner, not for you.

## The real game and the plans
- Real screens as the game draws them today, 1920x1080: `E:/FightCamp/critic_pack/screens/*_real.png`. Open them with the file tool.
- Approved menu layouts: `docs/mockups/s402/` (HTML and PNG), painted concepts: `docs/mockups/concepts/S402_*`, and `docs/mockups/s401/` for menus not redone in S402.
- The owner's answers to every design question: `ops/AgentComms/questions.json`.
- Design documents: `docs/GAME_BIBLE.md`, `docs/PLAYER_PATH.md`, `docs/STRUCTURE_DESIGN_S395.md`. In `ops/research/S400_REVIEW/` only YARDSTICK, MENU_STRUCTURE_S402, MECHANICS_DECISION_S402 and PRIMARY_ATTRIBUTES_S403: the rest carries earlier critics' scores.
- All code: `scripts/` (screens in `scripts/ui/areas` and `scripts/ui/modals`, rules in `scripts/rules`, game state in `scripts/state`). Never open `GameState.gd` or `FightRealtime.gd`.
- Research memory: `python ops/Tools/prior_research.py <terms>` lists what was already studied, `ops/research/`.
- Comparison games read from their files: the memory notes on Corner King and Two Point Museum, and `ops/research/TWOPOINT_ALIGNMENT.md`.

## The eight MMA fighters
Every menu is filled with the same eight MMA fighters so the screens are ready before the MMA release: `docs/mockups/s403/roster_mma8.json`, rules in `docs/mockups/s403/MOCKUP_RULES.md`. Grey with a reason means not usable right now; full colour with the warning triangle means not built yet, drawn as it will work. Check a screen against the fighters who stress it most.

## How to judge a screen
Say which options it is missing, which ones are useless, and what each option changes in the game. Open images with the file tool only: never start an app or a window on the owner's monitors, and never run Godot.



# YOUR JOB (critic, S450): score one design map - THE AMATEUR FIGHT WEEK

You are a fresh critic. Above is the whole game (the critic pack) and how to see it. Below is the design map for THE AMATEUR FIGHT WEEK: amateur bouts come 1 to 3 weeks out with no camp; the player finds the bout on the
fighter's page, plans the days before the bell on a one-week version of the camp plan, and every choice lands on one ON FIGHT NIGHT box.
Its fight-night prices are MEASURED through the real bout (section 4b).
Nothing of it is built. The look it will use: `docs/mockups/s449/camp_v3/camp_plan_v3.png` (open it with the file tool). Judge it as a player of deep management sims (Football Manager, Motorsport Manager, Boxing Manager)
would. You have not seen earlier versions.

1. LOGIC CHECK first: does anything contradict the game in the pack or the code facts it quotes? Name any button, number or row the
   game could not act on at that moment, and any name used outside a header.
2. DEPTH, score 1 to 10: is each choice in the week (which bout, home or away, where to train, load, sparring, film,
   who pays) a real decision for four fighters across a season? Try to break it: name any pick that is always right, any option nobody
   takes, any loop that becomes a chore by the tenth bout. Section 4b says fight-night levers top out near 5 wins in 100 and moves the
   weight of the choice to the season: is that convincing, or does the week become a formality?
3. PLAY, score 1 to 10: would this make you eager to press Continue each week?
4. Which options are missing, which are useless, what would each change? Go through the menu table.
5. END with "To reach 10/10": the concrete list of changes to the MECHANICS (not the wording), most important first, specific enough
   to build. Then describe your 10/10 screen for it as a layout on a 1920x1080 screen, panel by panel.
Plain words. No praise. Score honestly: a 7 means you would defend it to the owner. Do not ask questions back.

---

# AMATEURWEEK1 v4: the amateur fight week (S450)

Sources:
- His S428 scope change, "make it so amateur fights do not require fight camp and can happen within a week".
- Q-209 "Yes, fight week first"; Q-210 "Yes, that order".
- His S448 camp interview, "the buffs need to be real and reflect in the fight", "Fight week too", and who pays: "affect mood/morale, relationship and not always available for the fighter to pay".
- His S448 direction, "Booking a fight i think is better to be an option within a fighters profile tab".
- The look: camp plan v3 (docs/mockups/s449/camp_v3/camp_plan_v3.png).

Words: the map writes "the boxer" and roles ("your assistant", "the head coach"). The screens follow the names-only-in-headers rule (S448): a name appears only in a header, and rows never carry he or she.

## 1. The idea
- An amateur bout comes 1 to 3 weeks out and has no camp (John: firm club matches are made about 1 to 3 weeks out from availability lists). Camps stay for pro fights, title fights and the nationals.
- The player finds the bout on THE BOXER'S OWN PAGE (Fights tab): up to three bouts that pull different ways. If the player does not want to choose, "Coach picks the bout" takes the card that fits the boxer's goal and says why.
- The days before the bell use the camp plan screen, cut to one week (two when the bout is two weeks or more out).
- Every choice lands on ONE box the player reads before saying yes, ON FIGHT NIGHT:
  - the tank at the first bell
  - sharp or flat in round 1
  - plan lines ready
  - the scale margin
  - the win band
- A later date buys something you can see:
  - a trip away (hills, seaside)
  - a punch finished: "two weeks: Uppercut Usable"
  - a full tank with the work banked

## 2. Find a fight (the boxer's page, Fights tab)
- When the boxer is READY, the tab shows up to three bouts from the coming shows, as versus cards (the tale-of-the-tape look). Taking one closes the others. Each card shows:
  - WHEN: days to the bell.
  - HOME OR AWAY, and the favour count with that club (section 7).
  - RANK: what a win and a loss do to the boxer's place (section 3). Under 4 wins the boxer has no place: the card shows "wins to the table: n" instead.
  - WHAT YOU KNOW: the opponent's file, out of five habit groups. A debutant has no tape: "no bouts, no tape" and film is greyed.
  - THE RISK: the chance of being stopped, and the rest if it happens: 8 weeks (Matchmaking.STOP_REST_WEEKS).
  - THE WEEK IT BUYS: ON FIGHT NIGHT at the coach's default week.
- READY / BUILDING (until a date) / RESTING sits on the same tab.
- THE SHEET'S RHYTHM:
  - The next sheet comes 21 days after a points bout, and the day the 8-week rest ends after a stoppage. The sheet is never dead on arrival.
  - At most 11 bouts a season. The tab shows "bouts this season 7 of 11".
  - The 21-day gap allows up to 17 a year. The cap is what holds a season to 9 to 11, as real club boxers box.
- The Fights rail page becomes a list: one row per boxer with the sheet's state and its best card. A click opens that boxer's Fights tab. Taking a bout happens in one place only.
- REPLACES (code): AmateurBooking's one offer at a time and its 8-12 weeks' lead time, for amateur bouts only. John found no source for the long lead. Pro offers keep theirs.

## 3. The bout sheet's trades
"Home" is a show in your own town, run by the regional board: no cost to the club. It is NOT the hosted club show (HOSTSHOW1: $3,500, every 16 weeks, later).

| Choice | Gives | Costs |
|---|---|---|
| Home show | the club keeps the $450 ticket cut; a win brings +8 members and +5 reputation (the code's numbers) | home cards draw names BELOW the boxer: a win adds a win but no place |
| Away show | the host puts its ranked names on its own card, so away is where the boxer climbs (a win over a name above takes that place); free facts on two boxers seen that night; an away win still brings +4 members, +3 reputation (half) | no ticket cut; the van $40 |
| Novice (under 4 wins) | home: the ticket cut, as above; away: free facts and +1 favour with the host | no place to climb yet: the card counts wins to the table |
| Pass | the boxer stays fresh; the next sheet comes in 7 days | mood -3; 6 weeks without a bout = FLAT in round 1 of the next (ring rust); two passes on the same club = it stops calling for 8 weeks |
| Loss to a name above | no place lost | counts in the record |
| Loss to a name below | a new rule (NOT in code today): drops two places | the record |

- The home-judging edge in v3 is REMOVED. Amateur scoring is meant to be neutral, and no measured home effect was found. John's critic answer SQ59 can bring it back only with a measured source.
- The money line: four boxers at about 10 bouts a season is about 40 bouts. The year's ticket money runs from $0 (all away) to $18,000 (all home).
- The card shows the season so far: "home 5, away 3: $2,250 earned, 2 places climbed".
- REPLACES (code): the ticket cut and the members per win now depend on home or away. They used to come with every bout. BudgetProbe re-runs the break-even and the runway on the new income before the build freezes.

## 4. The fight week screen (the camp plan, one week)
Opened from the bout card ("Plan the week") or filled by "The coach runs this week". The layout is camp plan v3, scaled down.

### WHERE TO TRAIN
Prices are for the boxer plus one coach for a week (John, measured on 13 Nov 2026, in GBP x 1.25). Buffs multiply stats the fight reads.

| Location | Cost | Fight-night buffs | Injury | When |
|---|---|---|---|---|
| Home gym | free | none; pad nights as usual | x1.0 | always |
| City club, commute | $150 | new sparring styles: +1 plan test a sparring night; Fight IQ gains x1.3 | x1.3 | always |
| City club, stay over | $1,000 | as the commute, plus one extra sparring night | x1.3 | bout 2+ weeks out |
| Hill cottage | $575 off-season, $1,000 peak | Cardio gains x1.25; Legs gains x1.2 | x1.1 (steep path) | bout 2+ weeks out (the week away, then a week home) |
| Seaside house | $590 off-season, $1,150 peak | recovery +15%; Legs gains x1.15; mood +3 | x1.0 | bout 2+ weeks out |

- Peak season is June to August.
- THE CAP: no location may be worth more than 4 wins in 100 on its own. A probe (CAMPPLACE1) measures each one before the numbers freeze.

### HOW HARD
Three sliders with picture stops. Under each stop, what it does on fight night in numbers.

THE WEEK'S LOAD:

| Stop | Tank at the bell | Round 1 | Banked this week | Carried into next week |
|---|---|---|---|---|
| Rest up | full | FLAT (round-1 edge 2.0 against) | a fifth | nothing |
| Tick over | 6 off | sharp, +1 line ready | half | nothing |
| Train through | 12 off | sharp | a full week | +1 tiredness |

- The probe's prices: section 4b.
- Every point of tiredness over 50 costs 1 off the tank (no cap).
- John's taper (Bosquet 2007; Buglioni 2016): 1 rest day, the same number of sessions, volume cut 40-60%. "Tick over" is that taper. "Rest up" is more rest than the evidence supports; the FLAT round 1 is what it costs.
- REPLACES (code): nothing is cleared. The camp's TAPER phase never ran for an amateur bout, so the load slider IS the amateur bout's taper.

SPARRING: 0, 1 or 2 nights. Each night is one plan test against a live partner, and tiredness rises.
- John: hold the last sparring 7 or more days out.
- On a one-week bout, every sparring night also costs 3 off the tank.
- On a two-week bout, sparring in week 1 is free of that cost.

THE WEIGHT: shown only when the boxer walks outside the gap (section 6). Stops:
- Hold.
- Eat less: 1 off the tank per 0.1 kg, up to 10.
- Train it off: tiredness.

### WHAT THE WEEK BUILDS
- Technique, Power and Cardio shares, always 100%. They apply only to the banked part of the week.
- THE SECOND WEEK'S PUNCH: a two-week bout adds 2 pad nights.
  - If a move would cross Usable (30) or Sharp (60) in that time, the card shows "two weeks: Uppercut Usable" (MoveMastery's pace).
  - That is the only "finished punch" line.

### WHO PAYS (any trip)
John: club boxers get no stipend beyond the club's and have about $25-75 a week to spare. Trips are paid by the club or crowdfunded.

| Payer | Cash | Mood (0-100 scale; a win is +8, a loss -12) | Loyalty (the hidden Loyalty trait) |
|---|---|---|---|
| The club | the club pays it all | +3 | none |
| Half each | half from the club, half from the boxer's savings | +1 | none |
| The boxer | all from savings; greyed with "can't afford it" | win +4, loss -5 | +1 |

- Savings is a new number on the boxer, filled by the stipend's leftover ($25-75 a week; John).

### THE COACH'S PICK
- The pinned note: the head coach's face, a one-line reason, and how sure the coach is. Sureness grows with the coach's rating.
- "Use coach's pick" fills every slider.

### ON FIGHT NIGHT
- The tank, sharp or flat, lines ready (each with its per cent), the scale margin and the win band. It moves live with every slider.
- Each row shows its change from the coach's default week.

## 4b. The price list (FIGHTWEEKPROBE1, measured through the real bout; docs/FIGHTWEEKPROBE1_RESULT.md)
400 bouts a cell, three calibrated pairs (even 45 %, edge 69 %, under 38 % at a full tank), seeds 4421-4423, a men's class.
- THE TANK IS CURVED: 0 to 8 off costs 0 to 4 wins in 100 (inside the noise), 12 to 20 off about 0.7-1.0 a point; the full 25 costs
  8 (even), 16 (edge), 12 (under). The load stops sit on the flat part (8 and 12 off): a "Train through" costs about 2-4.
- TODAY'S FLAT ROUND 1 (the stance cost, 0.6) IS WORTH ABOUT 1 WIN IN 100 and moves round 1 itself by 0-2. Too small to price anything.
- TODAY REST UP WINS FOR ALL THREE PAIRS and the spread is 2 to 6: a lookup, half the 10-12 target.

FIGHTWEEKPROBE2 (S450, same pairs, 400 bouts a cell; LiveRound reads bout["r1_flat"], 0 = sharp, round 1 only):
| Flat round 1 | 0 | 1.0 | 2.0 | 3.0 |
|---|---|---|---|---|
| EVEN: win / round 1 won | 49 / 48 | 48 / 46 | 46 / 43 | 45 / 41 |
| EDGE | 72 / 55 | 71 / 52 | 70 / 49 | 69 / 46 |
| UNDER | 33 / 27 | 32 / 25 | 31 / 23 | 29 / 20 |
Even a 3.0 flat costs the bout only 3-4 wins (round 1 itself 7-9). With Rest up's flat at 2.0 the shapes read: EVEN Rest up 45, Tick
over (6) 45, Tick over (8) 45, Train through 42; EDGE 70 / 69 / 67 / 67; UNDER 26 / 28 / 27 / 26. Rest up no longer wins every pair, but
every gap is inside the noise.

THE FINDING (it changes the target): in this engine a fight week's levers on FIGHT NIGHT are worth at most about 5 wins in 100 (the whole
25-point tank 8-16, a flat round 1 3-4). The v3 target "best week vs laziest 10-12 in 100 on fight night" cannot be met without making
one week outweigh a fighter's training, which would be untrue to boxing (a fight week sharpens, it does not build). So v4's target is
THE TRADE, measured over a season, not one night:
- On fight night: no stop wins every pair (met at flat 2.0); the best-to-worst fight-night gap stays under 5 in 100.
- Over the season (FIGHTWEEKPROBE3 through the career harness, 26 weeks, three players: always Rest up / always Train through / the coach's
  pick by matchup and tiredness): the banked work (Train through = a full week, Tick over = half) must make the always-Rest-up player
  finish the season 4-8 wins in 100 behind the coach's pick, and the always-Train-through player lose 2-5 more stoppages or injuries.
  Season gap best-vs-laziest: 8-12 in 100. That is where the week's decision weighs, and it is the number the critics get.

v4's prices (Rest up's flat at 2.0, from the table above):
| Stop | Tank at the bell | Round 1 | Fight-night credit | Banked |
|---|---|---|---|---|
| Rest up | full | FLAT: a round-1 edge of 2.0 against the boxer (round 1 about 5 points worse) | none | a fifth |
| Tick over | 6 off | sharp | +1 plan line ready (the sharpening session) | half |
| Train through | 12 off | sharp | none | a full week, +1 tiredness carried |

## 5. The film evening, and tells confirmed in the fight
- Film takes ONE of the boxer's own pad nights (PadWeek: each boxer has 3). The boxer pays for film with one fewer pad night. The v3 "shared evenings" and "goes to the bag" lines are gone.
- One evening answers ONE of five habit groups. They map onto the code's opponent file (OppFile):

  | Habit group | OppFile entry |
  |---|---|
  | entries | weapon |
  | preferred range | weapon |
  | reactions under pressure | habits |
  | defensive habits | habits |
  | when the opponent starts slow or fades | weakness |

- A debutant has no tape: film is greyed, with the reason.
- The opponent's file shows the five groups, each SEEN, CONFIRMED or UNKNOWN.
- A tell seen on tape is a guess until the fight shows it:
  - A plan line built on a SEEN tell runs at 90% in round 1.
  - At the first corner minute the corner says whether it showed. CONFIRMED gives full value from round 2. Not seen drops the line to Works.
  - A CONFIRMED tell is kept for the rematch at half value.
  - NEEDS FireLevel on: the progression build's FIRELEVEL3 switches move levels on in the fight. Until it lands, plan lines fire every time and the 90% line is not built.
- Free facts come at AWAY shows only: up to two boxers at your weights, one group each. This is part of the home or away trade.
- The pool refreshes: two new names a weight each season, one leaves.

## 6. The weight, at walking weight (England Boxing Rules 2026, John)
- Matching is at actual weight plus a gap, never the class limit. The gap is the smaller boxer's weight-category width (rule 2.7.8):
  - 2.5 kg at 57-65 kg
  - 5 kg at 65-75 kg
  - youth uses the same rule (2.6.6)
- Each bout card names the agreed weight.
- Inside the gap: no weight question, and the slider is hidden. Just outside: Eat less or Train it off. A club-show cut is 0 to 1 kg (John).
- THE WEIGH-IN IS ON BOUT DAY, one hour before the boxing (rule 7.1.3). It moves from the day before in code.
- A MISS: the bout is off, or re-matched on the night if the other boxer is inside the gap. The host takes 1 favour.
  - The $300 fee goes: it is not in the rule book.
  - Youth tolerance is 300, 500 or 700 g by weight band (rule 7.1.14).
- ASK FOR A KILO costs one favour (section 7). The opponent then starts with 5 more in the tank.
- The boxer's card: "can take a bout in 7 days: yes / no".
- The regional table stays per class.

## 7. Favours
- A count of 0 to 3 per club, shown on each bout card and on the region's club list.
- EVERY CLUB STARTS AT 1, and a club below 1 comes back to 1 after 12 weeks with no ask. The climb can never be locked from day 0.
- Earned:
  - taking a late replacement on their show
  - saying yes to their kilo ask
  - an away novice bout on their show
  - (later) putting their boxer on your hosted show
- Spent:
  - asking for a kilo
  - pulling out of their show late
  - missing weight on their show
- AT 0: the club still offers its ranked names, but only on away cards, and never agrees to a kilo.
- Favours never buy rank or wins.

## 8. Things that happen, and routine bouts
- A BOUT FALLS THROUGH: 25 in 100 in the week before a show. John: club shows lose a quarter to a half of their bouts; the low end is used.
  - The matchmaker offers ONE late replacement, 0 to 5 days out: less known, or up to a kilo heavier inside the gap, or three bouts more experienced (never across the novice line).
  - Take it: +1 favour with the host.
  - Go home: no bout, mood -6, the week spent.
  - Continue stops for it.
- TWO SHOWS ON ONE NIGHT:
  - The head coach takes one corner and your assistant takes the other.
  - The assistant's calls are right 0.5 + rating/200 of the time (rating 58 is about 0.79, 74 about 0.87).
  - With no assistant, a club member works the corner: calls are right 1 in 2, and there is no ONE CHANGE.
- ROUTINE: "The coach runs this week" fills the default week in one click. The clock stops only for a fall-through, a weigh-in margin under 0.2 kg, or two shows on one night.

## 9. Code rules this map replaces or adds (by name)
| Code today | v4 |
|---|---|
| AmateurBooking: one offer at a time, 8-12 weeks' lead | BoutSheet: three cards, 1-3 weeks out, for amateur bouts; pro offers unchanged |
| A $450 ticket cut and +8 members / +5 rep on every bout | home only; an away win at half (+4 / +3); BudgetProbe re-run |
| Weigh-in the day before, $300 for a miss | bout day, 1 hour before; a miss = bout off or re-matched, -1 favour, no fee |
| TAPER only inside a camp | unchanged; the amateur bout's load slider is its taper |
| A stoppage rests 8 weeks | unchanged; the next sheet comes the day it ends |
| Nationals entry: 5 bouts, 3 months, age 19-40, closes week 10 | unchanged; the v3 "win share line" is DROPPED unless John confirms a real selection |
| A loss moves no place | new: a loss to a name below drops two places |
| Plan lines fire every time (FireLevel off) | the 80% / 90% lines wait for FIRELEVEL3 |
| No savings on the boxer | new: savings |
| No favours | new: Favours |

## 11. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Boxer page, Fights tab | up to three bout cards, READY/BUILDING/RESTING, the season line (home/away, earned, places, bouts of 11), Coach picks the bout | BoutSheet (new), Region, RankLine, OppFile, Favours |
| Fights rail page | one row per boxer: sheet state + best card; opens the tab | BoutSheet |
| Bout card | ON FIGHT NIGHT at the default week, the risk, what you know, favours with that club, "two weeks: <move> Usable" | FightWeek (new), BoutRules, OppFile, MoveMastery |
| Fight week screen | locations with costs, buffs and injury; load / sparring / weight sliders; shares; who pays with mood and loyalty; the coach's pick; ON FIGHT NIGHT live | FightWeek, CampPlace (new), PadWeek, Money, savings, Loyalty |
| Week board (Training) | the fight week's nights, film on the boxer's own pad night, trip days | WeekPhase, PadWeek |
| Office desktop (OFFICE1) | the bout and fight-week chips on the calendar; "Needs you" for an open sheet | OfficeDesk |
| Boxer card (Roster) | "can take a bout in 7 days"; the tank bar in fight week | Fighters, weigh_forecast |
| Tape room | five groups SEEN / CONFIRMED / UNKNOWN; free facts from away shows | TapeRoom, OppFile |
| Playbook | each line ready (after FIRELEVEL3: its per cent) | GamePlan, PlanLines |
| Region / club list | each club's favours | Favours |
| Continue | stops for a fall-through, a tight weigh-in, two shows | Clock, Needs |
| Fight night | the bout-day weigh-in first; the corner chosen | BoutNight |
| Corner minute (round 1) | CONFIRMED / Not seen (after FIRELEVEL3) | the corner read, OppFile |
| Result page | the sizes ("Legs: 14 off the tank, round 3 lost"), the rank earned, the season line | FightWhy, RankLine |
| Money | home ticket cuts, the van, trips by payer | Money, GymBills |

## 12. Build order
1. Probes:
   - FIGHTWEEKPROBE1 (done, section 4b)
   - BudgetProbe on the home/away money
   - CAMPPLACE1: each location under 4 in 100
   - the favour test: can a new club reach a ranked away name inside 8 weeks
   - the season count of bouts under the cap
2. Pure rules with tests: FightWeek, BoutSheet, CampPlace, Favours, TellConfirm, Savings.
3. Wire-ups:
   - the bout-day weigh-in
   - the miss rule
   - the home-only ticket cut
   - the stop rest feeding the sheet
4. Screens, one a task: the Fights tab with bout cards, the Fights rail list, the fight week screen (camp plan look), the week board's nights, the corner's confirm line (after FIRELEVEL3), the result's sizes.
5. Golden path: Find a fight, pick, plan the week (one trip, one film), weigh-in on the day, the fight, the result with sizes and the rank earned.

## 13. Open for him (taste and scope, on the board after the critics)
- Away shows are where the boxer climbs: the club-boxing feel he wants?
- Savings on each boxer (new): yes or no.
- Hills and seaside only for bouts two weeks out: right, or too strict?
