# WEIGHT1_R3 - write the NEXT version of this mechanic's design map (S459 design loop)

You are the designer. Read the whole game (critic pack below), the current map, and the critics' answers at the end. Write
the next version of the map in full (not a diff): answer EVERY point of each critic's 'To reach 10/10' list (do it, or say
in one line why not), keep every rule the owner agreed (quoted in the map), keep it buildable from what the game has, and
keep the map's table of every menu the mechanic appears on and what each is wired to (owner S425).
The bar it must reach with fresh critics: 6+ DEPTH and 6+ GENERAL DESIGN (owner S459). Numbers: say which are ESTIMATES.
Plain words; names only in headers. Return only the new map, starting with its title line.

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

# WEIGHT1: the weight mechanic, design map, clarity round 3 (S439)

Roadmap row WEIGHT1. Author: Claude (designer seat). Status: CLARITY ROUND 3, for two fresh critics.
History: S434 round 2 (`WEIGHT_MAP_S434.md`) depth 8 and 7, clarity 6 and 5. S439 round 1 (`screen_r1.png`) depth 5 / 5,
clarity 6 / 6. S439 round 2 (`screen_r2.png`) depth 5 / 5, clarity 6 / 5. Round 3 changes the MECHANIC where round 2's
critics found lookups or wrong code claims:

| Round-2 finding | What changed in the mechanic (round 3) |
|---|---|
| The roadwork row was fixed to "4 slip-rope mornings", which are not even in the coach's week (WeekPlan / WeekPhase) | BURN MORNINGS is a picker over the coach's REAL peak week (WeekPhase.WEEKS["peak"], CODE). Each morning shows what it trains and its own price, computed with WeekPlan.day (CODE). The goal price appears only on the mornings that feed the goal; the others cost their own stat. Mornings that already burn (roadwork, intervals) are not offered |
| Meal prep was a $120 lookup; the slip was a dice roll the player could only buy down | The slip is now SAMIRA'S ASK, built on the game's own asks (PushBack: chance from coachability, heard +5 / overruled -5, CODE). The player sets the standing answer: Let Samira eat / Half a plate / No. Each answer has a different currency (Energy, mood, a small kg). Meal prep is $25 a day ($300 for 12 days, two-thirds of the bout's $450 ticket cut) and halves how often she asks |
| The diet row (Lean / Lean + roadwork / Hold / Cut) read off one cell | The diet is no longer a free pick: Lean is the coach's and runs; Cut appears ONLY as one of three priced answers to the Monday check. Hold is a hover line (it cannot make 65.0 for Samira) |
| Standing order "Switch to Cut / Ask me": one answer | Three priced answers: Trust the trim (Energy kept, less room under the cap) / Cut 5 days (-1 Energy at the bell, twice the room) / Pull out now ($300 slot, the $450 not earned, no loss) |
| The goal price claimed "the corner's calls land less on the night" | Wrong: the goal is judged AFTER the bout (BoutNight._finish :423 morale first, :426-432 goal). The screen now says "judged after the bout" and shows the mood after the bout for a win and a loss. The ON-THE-NIGHT mood price comes from the ask's "No" (Samira 54 -> 49.6 = Flat, trust 0.85, CODE) |
| Save round 1 refills to 100 and erases every weight plan's price | B0 SAVECAP1 (fight model, before anything else): Save breathes back 1 an exchange (was 6), the next round never starts above this round's start, live Energy never above 100. With the cap the weight gap carries into round 2 (94 -> 92, 84 -> 82). P16 measures it |
| The curve drew Samira's lines (55, 40, 35) as if Kayleigh had them; her own line (45) was missing | Each fighter's own lines: 70 (both, the round's power), 45 (Kayleigh: under it she goes "Tiring" 3 exchanges in 4, Exchanges.OPP_TIRED / next_mode), 35 (Samira: "tired", her plan's situations stop, Exchanges.SHE_TIRED / situation). The 40 line is gone (read on the round's START Energy, never reached by Samira); 55 is said only on the Push card |
| The window where "When Kayleigh tires" can fire was not shown | THE WINDOW is shaded: Kayleigh under 45 AND Samira at 35 or more. Its exchange count is on every plan row and every pace card (5 / 4 / 3) |
| Pace only for round 1, no round tell | A pace for each round (R1 / R2 / R3, the plan's own store f.round_pace, CODE), with the tape's round tell (PlanFile.round_hints, CODE) or "none found yet" |
| Watch tape 2 priced in a pad night through WeekPhase.film_night (wrong: Build phase with a camp only) | Watch tape 2 is FREE, as the Tape Room is today (TapeRoom.gd: a viewing costs nothing). It is a link, not a decision |
| Write it compared +0.6 against +0.9 with no count | One unit: exchanges it fires x the line's edge (PlanFight.EDGE best 9, ok 3, UNDRILLED 0.8). The replaced line: about 7 pressing exchanges x 3 = 21. The new line: window x 3/4 x 9 x 0.8. Worth it at a window of 5 (27), even at 4 (21.6), a loss at 3 (16.2): the weight plan decides it |
| Opponent Energy, walkover, scale on the day shown as if they exist | Tagged NEW on the screen ("today she starts at 100"); the worth cards carry the code's loss and win prices (CODE) and mark the walkover NEW |
| Clutter (Hold row, Cut note, scale-day timeline, Body and class strip, two selection controls) | Cut. One control per choice; the scale day is one bar of three rules |

Read for this round: `CRITIC_PACK.md` (whole), `WEIGHT_MAP_S434.md`, both round-2 critics' notes and 10/10 drawings
(`critic_systems_r2.png`, `critic_coach_r2.png`) and the code: `scripts/rules/{Exchanges,PaceAim,Combos,OwnCombos,PlanFile,
PlanFight,PlanBoard,WeekPlan,WeekPhase,WeekTwist,PushBack,FighterProfile,BoutRules}.gd`, `scripts/state/{BoutNight,LiveRound,
LiveRoundAfter,RingDuel,Data}.gd`, `scripts/ui/{FightPrep,TapeRoom}.gd`. The Energy numbers are a replay of the code's formulas
(Combos.after_round, RingDuel.her_energy / opp_energy, PaceAim) with no calls and no body shots: the drawn curve is the best case.

THE DRAWING: `docs/mockups/s439/weight/screen_r3.html` (+ `.png`, 1920x1080): Samira Khan's Fight prep, sub-tab THE WEIGHT, on
Mon 16 Feb 2026 (day 42), the day the offer is accepted, 12 days before a club show.
Rendered headless with tools/render_mockup.py and opened: nothing clipped. Left: the three levers (burn mornings strip over the
real peak week, her ask's three answers + meal prep, the Monday check's three answers), the result row, four plans side by side,
the scale-day rules. Right: pace per round, the curve with each fighter's own lines (70 / 45 / 35) and the shaded window, the
other three paces as cards, the other corner (tape 2 free, Write it in one unit). NEW parts carry a NEW tag on the screen.

Tags: CODE = in the game today (file:line or constant). ESTIMATE = our value, not in the code. NEW = must be built (task named).

## 0. The idea in five lines

1. Every fighter walks above the class limit; making weight is the work of every bout, and it pays in Energy at the first bell.
2. The player shapes the cut with three priced levers: which training mornings to burn (a stat or the goal), how to answer the
   fighter's ask to eat (Energy, mood, or cash for meal prep), and what to do if the Monday check reads over (Energy, room, or pull out).
3. Energy at the bell decides the WINDOW: the exchanges where the opponent tires and our fighter is still fresh enough to punish it.
4. Pace per round and the plan's "when she tires" line are bought against that window, so weight, pace and the plan are one budget.
5. What runs for months (the walk, between-fights eating, the class) lives on the fighter's Body and class tab.

## 1. What is built today (read in the code)

| Part | What runs | Where (CODE) |
|---|---|---|
| One weight a fighter | `f["weight"]` moves daily by a kcal sum; no walking weight | Sim.gd:207-209; WeekPlan.day :241-270 |
| Sessions burn and train | kcal = MET x kg x min/60 x burn; gain = 0.2 (SESSION_SHARE) x intensity gain x headroom x coach; roadwork MET 9.3 / 45 min, slip rope 4.5 / 30, shadow 5.5 / 30, intervals 11 / 30; Light gain 0.6 burn 0.7, Hard gain 1.3 burn 1.35 load 1.5 | WeekPlan SESSIONS :31-41, INTENSITY :45-49, day :241-270 |
| The coach's week by phase | 12 days out = PEAK: Mon intervals Hard, Tue the focus session, Wed roadwork, Thu slip rope Light, Fri intervals, Sat shadow Light, Sun rest. Fight week = TAPER: roadwork Light, shadow Light, rest, speed bag Light, roadwork Light, rest, rest | WeekPhase.WEEKS :25-34, phase :43-47 (ceil(days/7): 2 = peak, 1 = taper), FOCUS :35 (defence -> slip_rope) |
| Two diets | HOLD (+300 kcal allowance), CUT -500 kcal (Old hand -620) | WeekPlan ALLOWANCE 300, CUT_DEFICIT 500 |
| The scale | made = weight <= limit + 0.05, the day before | BoutRules WEIGH_TOLERANCE 0.05, made_weight :171 |
| A miss today | bout off, $300 empty slot, next offer 6 days later, no loss, no morale change | Bouts.weigh :327-347; BoutRules MISSED_WEIGHT_COST 300 |
| Energy at the first bell | TANK 100 - hurt - stale; the opponent always 100 | BoutNight._energy :300-306 |
| Stale | 2 a fatigue point over 50, at most 20, only after a camp | BoutRules.stale_energy :165-168 |
| A round's spend | ROUND_COST 18 + punches, x spend_factor (1.2 - 0.4 x Stamina/100); the minute refills 52% of the fast 60% x fitness | Combos :26-38, after_round :272-276 |
| Live Energy in a round | lerp(start, end, exchange/6) - the calls' and pace's cost - body shots x 1.2 | RingDuel.her_energy :299-302, opp_energy :305-308 |
| The round's power fade | tired_penalty(round END Energy): 0 at 70, 6 at 0, BOTH fighters, computed before pace and calls | Combos.tired_penalty :285; BoutNight.gd:323 |
| Own combinations | share 0.33, 0.25 when the ROUND'S START Energy is under 40; 0.40 when the plan names the go-to whatever the Energy | OwnCombos.use_share, ring_edge :183-194 (called with a0) |
| Samira tired | under 35 the situation is "Your fighter is tired" whatever the opponent does; best call Breathe, Let your hands go is wrong | Exchanges.SHE_TIRED 35, situation :170-175, MODES she_tired |
| Kayleigh tires | under 45 the opponent goes "Tiring" 3 exchanges in 4; a "fades late" habit 1 in 2 in round 3 | Exchanges.OPP_TIRED 45, next_mode :221-227 |
| Pace | Push +6 an exchange, 1.35x the drop, its edge fades from 55 to -6 net at 25; Save -4 an exchange, 0.6x the drop and +6 back an exchange | PaceAim PACE_EDGE, PACE_SPEND, SAVE_RECOVER 6, push_gassed :187-190; LiveRoundAfter.gd:51-53 |
| Pace carried | the round's pace cost comes off the next round's start, clamped at the ceiling | LiveRound.close :392-399 |
| Round pace in the plan; round tells | f.round_pace (PlanFile.pace_for / set_pace); the tape's "slow to start" -> push R1 (+3 in its first 2 exchanges), "fades late" -> R3 | PlanFile.round_hints :113-125, cold_edge :128-133, COLD_EDGE 3 |
| Plan lines | best 9, ok 3, wrong -7 an exchange; an undrilled combination x0.8; the coach holds 6 lines (Luke Reid 58) | PlanFight.EDGE :19; PlanBoard.UNDRILLED 0.8, arrow_limit |
| Weapons | a move or combination is a weapon from 30 mastery; pads 2.1 an hour, a pad night 75 min | BoutRules.WEAPON_MASTERY 30; Combos.LEARN_AT 30; WeekPlan EVENINGS |
| Her asks | when she has a reason, she asks lerp(0.6, 0.2, coachability/100) of weeks; answers heard +5 / overruled -5 (overruled x lerp(1.4, 0.7, coachability), negatives x lerp(1.3, 0.7, heart)); low discipline = under 50 | PushBack ASK_MOST/LEAST, pick, LOW_DISCIPLINE 50; FighterProfile.MORALE_EVENTS :18-33, apply_morale :155-170 |
| Mood is trust | Fired up 75+ 1.05, Steady 50+ 1.0, Flat 30+ 0.85, Low 0.7 of the corner's word taken in | FighterProfile.trust |
| After the bout | morale of the result first (win +8, loss -12), THEN the goal (met +10, missed -20) | BoutNight._finish :423, :426-432 |
| Club prices of a result | win +8 members +5 reputation; loss -1 member -2 reputation; every bout fought pays the $450 ticket cut | BoutRules WIN_MEMBERS 8, WIN_REPUTATION 5, LOSS_MEMBERS 1, LOSS_REPUTATION 2, TICKET_CUT 450 |
| The tape | the Tape Room plays the films free; a spotted tell opens; tape study in a camp opens one a session | TapeRoom.gd; OppFile; FightPrep.next_step :71 (button only with camp.film) |
| Samira Khan | 65.9 kg, Welterweight 65.0, 2-1, Slugger, Stamina 60, Defence 50.5, Technique 54.5, discipline 34, coachability 52, heart 70, confidence 66, potential 82 | Data.gd:210-213 |

Four code findings for the main session (fight model, not weight; this design leans on the first):
- SAVE REFILLS PAST THE TOP. Save's per-exchange cost is drop x (0.6 - 1) - 6, so a round on Save adds about +48 to the next
  start (clamped at 100 in LiveRound.close) and the LIVE Energy rises inside the round with no clamp (a 96 start reads 111 by the
  sixth exchange, RingDuel.her_energy). One Save round erases any start gap. B0 fixes it.
- Pace does not change its own round's power fade: tired_penalty reads the round's end Energy from _energy, before pace.
- The goal's mood lands after the bout, so a goal missed never touches the night it was earned for.
- 12 days out with no camp, FightPrep.next_step says "Set the camp" (CAMP_MIN_DAYS 7): until AMATEURWEEK1 lands, an amateur
  bout still asks for a camp.

## 2. What is thin today

- Weight never reaches the fight: no Energy price for a trim, the opponent always starts at 100, two invented opponent-weight
  formulas disagree (TapeRows.gd:71-80, TaleOfTape.gd:24-29).
- A miss is $300 for everyone, no loss, though amateurs lose by walkover (EB 10.7.2); everyone weighs in the day before though
  amateurs weigh on the day (EB 7.1.3).
- The fighter's character never touches weight (the asks exist for training only).
- Energy has rules but no screen shows where it runs out, the window it buys, or what pace does to it.

## 3. The words (one set on every screen)

| Word | Means | Never |
|---|---|---|
| Walking weight ("walks 66.8") | where the body settles when nobody cuts | natural weight |
| Class, limit ("Welterweight 65.0") | the class and its scale number | division |
| The scale ("Sat 28, 4 pm") | the official weigh-in, its day and hour | weigh-in check |
| Burn morning | a training morning swapped for Hard roadwork to lose weight | cardio day |
| Trim ("trim 0.53") | the last 3 days' low-fibre, low-salt eating, at most 2% of the limit | water cut (amateurs) |
| Her ask ("Samira asks to eat") | the fighter asks to break the diet one weekend | cheat day |
| Meal prep | the club pays for the fighter's meals for this bout's days | |
| Energy | fight-night fuel, 100 at a fresh first bell | Tank, gas |
| The window | the exchanges where the opponent is tiring and our fighter is not tired | |
| Stamina | the fitness stat (code `conditioning`) | Cardio, Engine |
Names on every line ("If Samira asks"), never he or she.

## 4. The split: what lives where

| Where | What the player decides there |
|---|---|
| FIGHT PREP > THE WEIGHT (a bout booked) | burn mornings (D1), the answer to her ask and meal prep (D2), the Monday check's answer (D3), the pace of each round (D4), Write it (D5); Watch tape 2 is a free link |
| HOME need, only past the trim cap | Pull out or go to the scale (D6) |
| BODY AND CLASS tab | reads: walk, between-fights eating (the coach's), last 6 scales; decides the class (D7) when two are in reach |
| CLUB > PEOPLE | the nutritionist (D8) |
| THE BOUT OFFER | Accept or Pass (CODE, free); one line: the coach's plan and its Energy at the bell |
Fight prep keeps its head (VS, days, the one primary button) and gets four sub-tabs: THE WEIGHT / YOUR PLAN'S ANSWERS / THE TAPE /
THE WEEK. Between-fights eating is the coach's setting (Lean while over the limit and able to take offers, Hold when injured or at
the limit), shown on Body and class with its reason.

## 5. The mechanics, each a decision with priced options

The price of a kilo (ESTIMATE, B1): the trim costs -1 Energy a 0.1 kg up to 0.5, -2 a 0.1 from 0.5 to 1.0, -3 a 0.1 past 1.0;
the cap is 2% of the limit (65.0 -> 1.3) in 3 days (REAL.md 7). Lean is -250 kcal a day, 0.03 kg a day (ESTIMATE, B4).
What Energy buys: the WINDOW (section 6 table, replay of CODE formulas) and the round's power (tired_penalty, CODE: 0.086 power a
point under 70 at each round's end). As a win chance: 0.4 in 100 a point of start Energy (ESTIMATE, P10).

### D1. Burn mornings (pick 0 to 3)
The coach's peak week (CODE WeekPhase.WEEKS["peak"], focus Defence -> Tue is slip rope). A picked morning becomes Hard roadwork
(CODE kcal and gain formulas). Only training mornings that do not already burn are offered; the fight week is the coach's taper
(fresh legs) and is not offered; Mon 16 is done.
| Morning (Samira, 65.9 kg) | kcal today -> Hard roadwork | kg off | Lost | Gained | Its price for Samira |
|---|---|---|---|---|---|
| Tue 17 slip rope Normal | 148 -> 620 | 0.061 | Defence 0.23 (0.2 x 1.25 headroom x 0.906 coach) | Stamina 0.21 | THE GOAL: Defence 50.64 < 50.8, missed (mood -19.9 after the bout) |
| Thu 19 slip rope Light | 104 -> 620 | 0.067 | Defence 0.14 | Stamina 0.21 | THE GOAL: Defence 50.72, missed |
| Sat 21 shadow Light | 127 -> 620 | 0.064 | Technique 0.12 (0.12 x 1.1 x 0.906) | Stamina 0.21 | Technique only |
| Wed 18 roadwork, Mon 16 / Fri 20 intervals | already burn (0.02-0.03 kg) | | | | not offered |
- The goal (ESTIMATE example): "Defence 50.8 by Sat 28", set two weeks ago. The coach's week reaches 50.86 (Tue 0.23 + Thu 0.14;
  the taper has no slip rope): met by 0.06.
- Each morning is worth about +1 Energy while the trim sits in the -1/-2 tier, about +2 in the -3 tier, and it is what keeps a
  trim under the cap after a slip. Stamina +0.21 lowers the round's spend by about 0.1 Energy (spend_factor, CODE): shown in the hover only.
- Not a lookup. Samira: only Sat is worth it (Tue and Thu cost the goal, -19.9 mood after the bout). Kira Mensah (58.3 kg over a
  57.0 limit, no goal due): her trim is 0.94, in the -2 tier near the -3 tier, so all three mornings (Tue speed bag, Thu slip
  rope, Sat shadow) buy 3.4 Energy for Speed -0.14, Defence -0.12, Technique -0.12. A fighter whose trim is under 0.5 buys 1 Energy
  a morning for 0.12-0.23 of a stat and takes none. The answer comes from the trim's tier, the goal, and which stat each morning feeds.

### D2. If Samira asks to eat (a standing answer, set now; and meal prep)
NEW B7: a weekend ask beside the weekly card (it touches only the diet, so it does not break the one-card-a-week rule). She has a
reason when a diet is running and discipline is under 50 (CODE LOW_DISCIPLINE); she asks lerp(0.6, 0.2, coachability/100) of
the weekends she has a reason (CODE PushBack rate): Samira (coachability 52) 0.39, "about 2 weekends in 5". This bout has one
weekend (Sat 21). Kira (discipline 64) never asks: her screen has no D2.
| Answer | kg (ESTIMATE) | Mood (CODE apply_morale, Samira) | Energy at the bell (with Sat burned) | Best when |
|---|---|---|---|---|
| Let Samira eat | +0.5 | heard: +5.2 -> 59.4 | 84 (trim 1.03) | she is Flat near Steady (+5 lifts her trust 0.85 -> 1.0 for the night) and the trim has room |
| Half a plate (NEW middle answer) | +0.2 | 0 -> 54.2 | 90 (trim 0.73) | mood near the Steady/Flat edge AND the trim near a tier |
| No, stay on the plan (the coach's default, as every ask's "b") | 0; but under discipline 50 she eats anyway (50 - discipline)/100 = 1 in 6 (NEW, ESTIMATE) | overruled: -4.6 -> 49.6 = FLAT on the night, trust 0.85 | 94 (82 if she eats anyway: trim 1.09) | mood well inside a band, trim near the cap |
- MEAL PREP for this bout: $25 a day (ESTIMATE from GBP 5.5-8 a meal, 3 meals, x1.25; TO SOURCE B13), $300 for 12 days, paid at
  once (CODE c.pay, Club > Money PAID OUT). She asks half as often (0.39 -> 0.20) and a "No" always holds (the food is planned).
- Not a lookup: three currencies. For Samira at Steady 54 the "No" puts her Flat on the night 2 times in 5 (-2 in 100, ESTIMATE
  P17); Half a plate costs 4 Energy 2 times in 5; Let her eat costs 10 Energy and gives +5 mood. Meal prep is worth $300 only with
  Let her eat or No (it halves a big price), not with Half a plate (it halves 4 Energy: 0.8 Energy for $300). The mood band edge, the
  trim tier and the runway each move the answer.

### D3. If the Monday check reads over (Mon 23; a standing answer, the clock does not stop)
Target = the plan's line + 0.1 (Samira: 65.7). Over it, the standing answer runs:
| Answer | Price (Samira after eating, 66.13 on Mon 23) | Best when |
|---|---|---|
| Trust the trim (the coach's) | trim 1.03: Energy 84, room under the cap 0.27, miss 4 in 100 (ESTIMATE) | the trim stays under 1.0 |
| Cut 5 days (Mon 23 - Fri 27) | -0.16 kg (250 kcal a day more, CODE CUT_DEFICIT), -1 Energy a Cut day (ESTIMATE, B4): Energy 83, room 0.43, miss 1 in 100 | the trim passes 1.0 (the -3 tier) |
| Pull out now | $300 slot (CODE MISSED_WEIGHT_COST, the injury pull-out path), the $450 ticket cut not earned, no loss, the next offer 6 days later (AFTER_MISSED_WEIGHT) | the forecast trim is near the cap |
Not a lookup: Energy against room under the cap against cash. The miss chance by room (ESTIMATE, B1): 1 in 100 from 0.4, 4 at 0.27,
8 at 0.2, 20 at 0.1.

### D4. The pace of each round (Energy panel)
Three picks a round, writing the plan's f.round_pace (CODE, the store Playbook > Game plan uses): Push / Steady / Save. "Opening pace:
you change it every 30 s on the night." The round tell from the tape (CODE round_hints) shows when found.
| Samira 94, Kayleigh 86 (NEW B6) | Window | Exchanges Samira is tired | Price |
|---|---|---|---|
| Steady all three | 5 | 1 (R3 last) | none |
| Push round 1 | 3 | 3 | +6 an exchange in R1 while over 55 (CODE); +3 more in R1's first 2 against a slow starter (CODE cold_edge) |
| Save round 1 (after B0) | 6 | 0 | R1 at -4 an exchange and 0.75x output (CODE): round 1 is likely given away |
| Push round 3 | 4 | 2 | best only against "fades late" (CODE round_hint) |
Not a lookup: the pick turns with the weight plan (Samira 84: Steady window 3, Push R1 window 0 and 7 tired exchanges), with the round
tell (none found yet; tape 2 can open one) and with Write it (the window is where its line pays). Win change per pace waits for P16.

### D5. Write it: "When Kayleigh tires -> 1-2-3" (the plan is full, 6 of 6)
It replaces "When Kayleigh presses -> Step back" (Works, ok 3, CODE PlanFight.EDGE). One unit, edge x exchanges it fires:
- Replaced: about 7 pressing exchanges of 18 (ESTIMATE: Kayleigh is a Pressure fighter) x 3 = 21.
- New: window x 3/4 (CODE OPP_TIRED chance) x 9 (best, the 1-2-3 against a tiring opponent, PlanFight) x 0.8 (the 1-2-3 is at
  27, under 30: UNDRILLED, CODE) = 27 at a window of 5, 21.6 at 4, 16.2 at 3. Drilled to 30 (two more pad nights on it: +2.6 each,
  CODE 2.1 an hour x 75 min) it is 33.8 at 5.
- Not a lookup: worth it on the 94 plan (window 5), even on the 90 plan (4), a loss if she eats (84, window 3). The weight plan and
  the pace decide it; pad nights on the 1-2-3 (the Training tab) move it.

### D6. Past the cap (a Home need that stops the clock; the only weight card)
When the forecast trim passes 1.3: PULL OUT ($300, no ticket cut, no loss) or GO TO THE SCALE (the cap's trim, up to 0.3 sweated
off at -2 Energy a 0.1, ESTIMATE; past that a WALKOVER LOSS, NEW B5: the loss path, -12 mood, -1 member, -2 reputation, the record).

### D7. The class (Body and class; only when two classes are in reach) and D8. The nutritionist (Club > People)
Kept from round 2 unchanged: D7 within reach = no more than 9.5% under the walk and 4 kg over it; a move leaves the regional table
(CODE, per class). D8 $100 a week for all fighters: trim price x0.8, asks x0.75 (ESTIMATE); pays back with two fighters cutting at once (P13).

### Watch tape 2 (a free link, not a decision)
The Tape Room plays tape 2 free (CODE TapeRoom.gd). Spotting the tell opens it (CODE OppFile: weapon first, weakness last); it may be a
round tell (D4). NEW B2: it also narrows Kayleigh's trim, so her Energy reads to +-1.

### Cut, with the reason
- Diet rows Lean / Lean + roadwork / Hold / Cut: read off one cell. Lean runs; Cut is a Monday-check answer; Hold is a hover.
- Per-bout meal prep at $120 and the weekly house rule: cash lookups. Now $300 tied to the ask's answer.
- "Switch to Cut / Ask me": one answer. Now three priced answers.
- A priced Watch tape 2: contradicted the free Tape Room.
- The 40 and 55 lines on the curve, the water note, the scale-day timeline, the Body and class strip, PICKED/ADD chips.
- A gym weigh-in Saturday as cover (critic 1): its price (mood) duplicates the "No" answer; one mood lever is enough.

## 6. One week, played (Samira Khan, Mon 16 to Mon 23 Feb 2026)

Start: day 42, week 7 (CODE: day 0 is Mon 5 Jan 2026). Samira (CODE Data.gd:210-213), 65.9 kg, Welterweight 65.0, 2-1. Walks
66.8 (ESTIMATE, B3). Mood 54.2 Steady (ESTIMATE example: 49 after her loss, booked +5 x1.03 = +5.2). Goal Defence 50.8 by Sat 28
(ESTIMATE example). Focus Defence. Cash $12,940, running -$280 a week. No camp (fight week, S428). Coach Luke Reid 58.

MON 16. Offer: Kayleigh Bell (2-1, Pressure fighter, an example rival), club show Sat 28 (day 54). Accept. The worth cards: a win
3-1 (one win from the regional table, CODE: enters at 4) +8 members +5 reputation +8 mood; a loss -1 member -2 reputation -12 mood;
the $450 ticket cut either way (CODE); Samira misses = walkover loss (NEW); Kayleigh misses = walkover win, about 4 in 100 (NEW, ESTIMATE).

THE WEIGHT opens on the coach's plan: Lean 12 days -0.36 -> 65.54, trim 0.59 (Thu-Sat) -> price 5 + 1.8 = 6.8 -> Energy 93.
The player's three levers:
1. BURN MORNINGS: Tue and Thu are marked "Defence: the goal" (50.86 -> 50.64 / 50.72, missed). Sat shadow costs Technique 0.12. The
   player burns SAT: 65.48 at the trim, trim 0.53 -> 5 + 0.6 = 5.6 -> Energy 94 (+1).
2. IF SAMIRA ASKS TO EAT: the coach's "No" would put her at 49.6, Flat on the night, 2 times in 5. The player sets HALF A PLATE: if
   she asks, +0.2 kg, trim 0.73 -> 9.6 -> Energy 90, mood stays 54. No meal prep (it would buy 0.8 Energy on average for $300).
3. IF THE MONDAY CHECK READS OVER: TRUST THE TRIM (a half plate leaves the trim at 0.73, under 1.0).

| Plan | Energy clean / if she asks | Mood on the night if she asks | Window | Win (ESTIMATE, band 46-62) | Costs | Mood after the bout, win / loss |
|---|---|---|---|---|---|---|
| Coach's: no burn, No, trust the trim | 93 / 93 (82 if she eats anyway) | 49.6 Flat (trust 0.85) | 5 (3) | 53 | Flat 2 in 5 | 73 / 54 (68 / 49 if she asked) |
| Yours: Sat burned, Half a plate | 94 / 90 | 54.2 Steady | 5 / 4 | 54 (+1) | Technique -0.12 | 73 / 54 |
| Sat burned, Let her eat, meal prep $300 | 94 / 84 (she asks 1 in 5) | 59.4 Steady | 5 / 3 | 54 (+1) | $300 | 73 / 54 (78 / 59 if she asked) |
| All three burned, Half a plate | 96 / 93 | 54.2 Steady | 5 / 5 | 55 (+2) | Defence goal missed, Technique -0.12 | 43 Flat / 24 Low |
Arithmetic: Win = 54 at Energy 93 (the bout's band middle, ESTIMATE) + 0.4 a point; Flat on the night -2 (P17); averaged over the ask
(0.39, or 0.20 with meal prep) and "eats anyway" (1 in 6 of a No). Mood after: win +8.26, loss -10.56 (heart 70), goal met +10.32,
goal missed -19.9 (CODE apply_morale with Samira's traits). The differences in win chance are inside the band: the screen says "too
close to call" and the decision rests on the tails (Flat on the night, the goal, the cash).

THE PACE: no round tell on file. Steady all three: Samira 94 -> 64, 74 -> 44, 58 -> 28 (tired for the last exchange); Kayleigh
86 -> 56, 65 -> 35, 49 -> 19 (NEW B6; today she starts at 100). The window: round 2's last exchange and round 3's second to fifth = 5.
Push R1 would cut it to 3 and leave Samira tired for 3. Save R1 (after B0) widens it to 6 and gives round 1 away. The player keeps Steady.
WRITE IT: window 5 x 3/4 x 9 x 0.8 = 27 against 21 for Step back: the player writes it. Pads on the 1-2-3 (Training tab) would make it 33.8.
TAPE 2: free in the Tape Room; the player watches it on Tue (a round tell would change D4).
TUE 17 - FRI 20. Lean: 65.87, 65.84, 65.81, 65.78 (ESTIMATE, CODE day formula).
SAT 21. The ask comes (0.39). Half a plate: +0.2. News: "Samira asked to eat at a birthday meal: half a plate."
MON 23. The check: 65.63 + 0.2 = 65.83 against 65.7: over 0.13. The standing answer (Trust the trim) runs; the week review says so.
SAT 28 (as it will run): 4 pm the scale 64.95, made (zero allowance NEW B5; up to 0.3 over sweated off at -2 Energy a 0.1);
5 pm the first bell at Energy 90; the window is 4.

## 7. The professional (debut onwards): the same sub-tab, more levers
Kept from S434: the scale the day before about 30 h out (BBBofC 3.2.2), the last day's water (0 to 3%), refuel, catchweight for 10% /
15% of the asker's purse (CODE gym share 25%), a missed opponent (box for +25% of their purse, or refuse). A pro camp's stale Energy
(CODE stale_energy) prices every burn morning in fatigue as well.

## 8. Every menu it appears on, and what each is wired to

| # | Menu | What it shows | Wired to today (CODE) | New wiring |
|---|---|---|---|---|
| M1 | FIGHTER > FIGHT PREP > THE WEIGHT (drawn) | worth cards; the three levers (burn mornings strip, the ask's answer + meal prep, the Monday answer); the result row; plans side by side; Energy round by round with pace per round, each fighter's lines and the window; the other corner (tape 2 link, Write it) | FightPrep.gd:34-50, next_step :60-74, _camp_card :140-163; Sim.weigh_forecast; PlanFile.set_pace; TapeRoom | WeightRules.plan / mornings / ask_rows / monday_rows / window; EnergyCurve; PlanLines.add(replaces) |
| M2 | FIGHTER > BODY AND CLASS (a shown tab) | walk and drift, between-fights eating (the coach's), asks to eat (rate), the last 6 scales, the class card | FighterPage.gd:29-30 (TABS[2] not in TAB_ORDER) | TAB_ORDER [0, 2, 3, 5, 7, 4]; BodyClass.make |
| M3 | FIGHTER > TRAINING (week board) | a burned morning shows "Hard roadwork, for the weight" | WeekBoard.gd:402-416; WeekPhase.edits | WeightRules writes f.week_edits (the Week's own exceptions store) |
| M4 | FIGHTS > BOUT OFFER | the scale's day and hour; the coach's plan's Energy at the bell | VersusPanel.gd:159, :185-196; BoutPage.gd:44-56 | WeightRules.coach_plan(f, day) |
| M5 | HOME > NEEDS | only past the cap: Pull out / Go to the scale | Needs.gd:75-76 | WeighDay.past_cap |
| M6 | THE WEIGH-IN (modal) | the hour, the reading, made / sweated (-Energy) / walkover loss | WeighIn.gd:13-28; Bouts.weigh :327-347 | WeighDay.weigh |
| M7 | TALE OF THE TAPE + 3D intro | weights on the scale and on the night | TapeRows.gd:64-80; TaleOfTape.gd:24-29 | OppWeight (the two formulas go) |
| M8 | FIGHT NIGHT | first card "Energy 90: trim 0.7 -10" for both corners; the round pace as set | BoutNight.gd:306; PlanFile.pace_for | WeightRules.energy_sum into :306 for both |
| M9 | RESULT > THE WHY | "Weight: Energy 90 at the bell; the window 4; your tires line fired 3 times" | WhyCard.gd | WeightRules.why_line |
| M10 | WEEK REVIEW | the ask and its answer, the Monday answer that ran, planned vs actual | WeekReview.gd:413-414; WeekActual.gd:82-91 | WeighDay.check; EatAsk.log |
| M11 | HOME fighter row, Coming up | "0.83 to lose · scale Sat 4 pm" | HomeRows.gd:195-201; Fixtures.gd:19 | WeighDay.hour |
| M12 | FIGHTERS > ROSTER | weight against the limit; amber when the Monday answer ran, red past the cap | RosterCards.gd:213-220 | f.plan state |
| M13 | CLUB > PEOPLE | the nutritionist | StaffRoles.gd:7-21 | StaffRoles + "nutritionist" |
| M14 | CLUB > MONEY | "Meal prep: Samira, 12 days $300" in PAID OUT | c.pay | WeightRules.buy_meal_prep |
| M15 | WORLD > NEWS | the ask and answer, made / sweated / walkover | c.add_news (Bouts.gd:339) | WeighDay, EatAsk |
| M16 | PLAYBOOK > GAME PLAN | the round pace (same store); the line Write it added, "from the weight plan", and the line it replaced | GamePlanRows.gd:20-32; PlanFile.set_pace | PlanLines.add(line, source, replaces) |
| M17 | NO-GI athlete page | "Scale at the mat, before the first match" | NoGi.gd:74 | WeighDay.hour for bjj (TO SOURCE) |

## 9. The build (each file under 500 lines, one owner, its test red on main first; nothing before two critics score 7+)

| # | Task | Owner | Owns (lines) | Test red first |
|---|---|---|---|---|
| B0 | SAVECAP1 (fight model, first): SAVE_RECOVER 6 -> 1; the next round never starts above this round's start; live Energy clamped at 100 | Claude | PaceAim.gd (+2), LiveRound.close (+2), RingDuel.her_energy (+1), tests/save_cap_test.gd | Save R1 from 90 starts R2 at 100 and reads 111 live (red today); after: R2 <= 90, live <= 100. Then P16 and the fight balance re-measure |
| B1 | WEIGHTRULES1 (pure): trim price and cap, burn-morning prices from WeekPlan.day, the ask's answers, the Monday answers, miss by room, Energy sum, window by replay, win change | Qwen (Goose route) | scripts/rules/WeightRules.gd (~340), tests/weight_rules_test.gd | Samira's three mornings return 0.061 / 0.067 / 0.064 kg and Defence 0.23 / 0.14, Technique 0.12; Energy 93 / 94 / 90 / 84 |
| B2 | OPPWEIGHT1: opponent walk and trim, fog by tape | Qwen | scripts/rules/OppWeight.gd (~120), tests/opp_weight_test.gd | tape and 3D intro give one weight (red: two today) |
| B3 | WALKWEIGHT1: `walk` in the save, Hold drifts back, the clamp replaced | Claude | Data.gd, ClubStart.gd, Sim.gd (net <= 0, at 499), SaveGame.gd | Hold from 65.9 reaches 66.4 in 12 days for a 66.8 walk (red: flat) |
| B4 | DIETS1: Lean; Cut as the Monday answer with its -1 Energy a day | Qwen | WeekPlan.gd (+~25), WeekCoach.gd | a Lean day loses 0.03 kg (red: no Lean) |
| B5 | WEIGHDAY1: the hour, amateurs on the day, zero allowance, sweat-off, the walkover loss through the loss path, the Monday answers, the past-cap need | Claude | scripts/state/WeighDay.gd (~240), Bouts.gd (net <= 0), Needs.gd (+~10) | an amateur miss writes a loss and -12 morale (red: none) |
| B6 | NIGHTENERGY1: the Energy sum into BoutNight for both sides; the Why line | Arena | BoutNight.gd (:306, net <= +6), WhyCard.gd (+~20), tests/night_energy_test.gd | a trim of 1.0 starts at 85 (red: 100); the opponent's trim lowers hers |
| B7 | EATASK1: the weekend ask (reason, rate from PushBack), the three answers with the standing answer, "eats anyway", meal prep | Qwen | scripts/rules/EatAsk.gd (~160), tests/eat_ask_test.gd | discipline 34 / coachability 52 asks 35-43 in 100 weekends over 1,000 seeds, discipline 64 never (red: no ask) |
| B8 | CLASSES1: classes within reach | Claude | scripts/state/Classes.gd (~180) | Josh's card offers 75; Samira's none |
| B9 | WEIGHTPANEL1: M1 | Cursor (or Grok Dev) | scripts/ui/WeightPlan.gd (~380), BurnStrip.gd (~140), EnergyCurve.gd (~200), FightPrep.gd sub-tabs (+~30) | the panel's numbers equal WeightRules'; a pace pick writes f.round_pace; a picked morning writes f.week_edits |
| B10 | BODYCLASS1: M2 | Cursor | scripts/ui/BodyClass.gd (~300); FighterPage.gd (net <= +3) | the tab shows; the ask rate changes with the nutritionist |
| B11 | WEIGHTSHOW1: M3-M17 small edits | Cursor | the files in section 8, each under 30 lines | every menu shows its line in the .exe |
| B12 | WEIGHTGOLDEN1: offer -> burn Sat -> Half a plate -> the ask comes -> Monday answer -> scale on the day -> Energy 90 -> the window in the Why; second run: No -> eats anyway -> past the cap -> Go to the scale -> walkover loss; third: Kira shows no ask and a different best set of mornings | Grok Dev | tests/weight_golden_test.gd | red until B0-B11 land |
| B13 | John: TO SOURCE (club-show weigh-in hour, meal prep and nutritionist prices, no-gi scale rule) | John | ops/research/WEIGHT_SOURCES_S439.md | - |
Order: B0 first (it changes every fight number), AMATEURWEEK1 (S428) with B5.

Probes before the board (headless tools/ scripts on the PC, after B0):
- P10: the win chance a point of start Energy (the 0.4 ESTIMATE): 400 bouts a cell, starts 100 / 90 / 80 / 70.
- P14: across the four starters x three cash levels x goal due / not due x 300 seeds, no burn-morning set and no ask answer is best
  in more than 60 in 100 cases.
- P15: the best and worst sensible plans differ by 3+ in 100 in 60 of 100 bouts; if not, the screen leads with the tails.
- P16: Save R1 + the worst plan does not beat Steady + the best plan in more than 1 bout in 3 (after B0).
- P17: Flat on the night (trust 0.85) against Steady, in win chance (the -2 ESTIMATE).
- P18: the window's count against the "when she tires" line's fires in 400 bouts (the replay is the forecast; this checks it).

## 10. Rejected, and why

| Rejected | Why |
|---|---|
| Diet rows with one answer column | the pick read off one cell (round-2 critics) |
| A fixed "4 slip-rope mornings" roadwork row | not the coach's week (WeekPhase); the price was a drawing choice |
| Meal prep at $120 | a cash lookup at any healthy runway |
| A slip as a dice roll bought down with cash | the game already has asks with mood prices; the slip is now her ask |
| Standing order "Switch / Ask me" | Switch won every case |
| A priced Watch tape 2 | the Tape Room plays it free |
| Gym weigh-in Saturday | a second mood lever beside the "No" answer |
| Energy lines 20, 40, 55 on the curve | 20 is 3D-only; 40 reads the round's start; 55 is Push only (said on its card) |
| Burn mornings in the fight week | the coach's taper is for fresh legs; the code has no price for its fatigue without a camp, so it would be free |
| The other corner's walk and eat-back | nothing to act on |

## 11. Open for the owner (scope only)
- Women's 70 kg and men's 65 kg (World Boxing classes): without them D7 is a decision for few fighters.

## 12. Risks
- B0 changes every fight number: Save is used by the corner and the fight balance (59 / 45 / 41) must be re-measured.
- The win differences between plans are 1-2 in 100, inside the band; P15 decides whether the screen leads with the win chance or
  with the tails (Flat on the night, the goal, the cash, a walkover).
- The trim prices, the 0.4-a-point rate, the ask's kg and "eats anyway" are ESTIMATES (REAL.md 2b: no measured link between kg
  regained and winning).
- Opponent Energy under 100 (B6) changes the window from 0-2 (today, Kayleigh at 100) to 3-6: without B6 the window, and so D4 and
  D5's link to weight, is mostly empty. B6 is not optional.
- A walkover from a dice roll feels unfair: B5's test: no walkover without the past-cap need shown first, unless the slip came in
  the last 3 days.
- Sim.gd is at 499 lines (B3 net <= 0). Cursor was out of usage in S438: B9-B11 may go to another seat.

## 13. The critics, clarity round 3
Not yet scored. Brief: CRITIC_PACK.md + CRITIC_ACCESS.md first, then this map and `docs/mockups/s439/weight/screen_r3.png`.


# CRITIC ANSWER: DESIGN_WEIGHT1_R2_CRITIC_JOHN_JOHN.md

# DESIGN_WEIGHT1_R2_CRITIC_JOHN_JOHN - John answer (seat queue SQ104)

Brief: research/DESIGN_WEIGHT1_R2_CRITIC_JOHN.md
Sent: 2026-11-14 13:10 | collected: 2026-11-14 13:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading WEIGHT1 round 2 against the pack now. Logic first, then the scores, options, To reach 10/10 and the page.

# WEIGHT1 round 2: critic

Scores: **depth 7/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

The class choice is a real career decision, and the plan table's arithmetic holds. I rebuilt every ENERGY and WIN number in section 3, part 7 and they all match. What holds design down: the map writes names into rows as a rule, uses one stat the game no longer has, models the most common amateur bout wrongly, and gives one staff job four effects.

- I couldn't open `CRITIC_ACCESS.md`, the two r2 drawings or the board, because your computer is offline, so I judged from the map and the pack.

## Logic check

**1. Names and fixed gender are written in as the rule.**
- Section 1 says "Names, never he/she, also in the drawings". That's the opposite of S448: names go in the header once, and rows, buttons, lines and tooltips say her or him for that fighter, or "the opponent".
- Leaks in rows, labels and lines:
  - "If Samira slips" and "IF SAMIRA MISSES" (box labels).
  - "Samira asks" and "Samira's own ask" (the CLASS card).
  - "Kayleigh starts 5 ENERGY under Samira" (the fade line).
  - "Kayleigh's coach: no, Kayleigh walks 67.6" (the refusal reason).
  - "Lucy Jackson boxes at 60.0" (the roster row).
  - "Scale at the mat" row for Ana (M18).
  - The news "Samira: +0.5 kg" is fine only if news counts as a header line. Say which.
- S412: "Her way = heard" (part 1) sets her for every fighter. Use "the fighter's way".
- **Fix:** "If the fighter slips", "The opponent starts 5 ENERGY under", "The other coach: no, the opponent walks 67.6", "A team-mate boxes at 60.0".

**2. Most amateur bouts aren't fought at a class limit.**
- In real club boxing there are no weight classes at club shows. Boxers are matched by weight with an allowance, about 2 kg in usual practice (Stevenage ABC). EB 2.7.8 caps the gap at the width of the smaller category. The class limit is the championship case.
- The map treats every club show as "at the limit, 1 kg grace, ask a kilo". That makes amateurs cut for club shows when real ones mostly don't, which is the code's mistake carried forward.
- **Fix:** split the amateur column in two.
  - **Club show:** MATCHED WEIGHT is the default. Both corners agree a weight on the offer, within the allowance (the same number AMATEURWEEK1 uses). A cut is rare, and the size gap comes from the matching, not the cut.
  - **Championships** (the regional and the nationals): the class limit, a weigh-in at 9 am on the day, and cutting matters.
- This also kills the claim that "the size edge is dead at a same-day scale". At a club show a 2 kg matching gap is the size edge.

**3. What comes back by the bell can't be one number for both amateur scales.**
- The map gives every amateur up to 1.5% (women) or 2.1% (men) back plus 0.3 kg, citing a championship study.
- A club show scale is 1 hour before the bell. Glycogen and gut content don't come back in an hour.
- **Fix:** club show, the meal only (+0.3 kg at most); championships at 9 am, the map's numbers.
- This matters because the amateur trim's ENERGY price assumes nothing comes back, while the size number assumes it does. The same kilos are counted on both sides.

**4. "Power" isn't a number any more.**
- The size edge gives "+0.6 Power and +0.6 Durability per kg". Since S448, `Attrs.gd` holds 14 abilities. Power is a summary read from Strength, Explosiveness and skill, so nothing can be added to it.
- **Fix:** put the edge on Strength and Durability for the bout, or as a flat edge on the exchange dice in clinch and inside places only. The second is closer to how size works, and the Why can name it.

**5. The diet's Fatigue share can't be rebuilt from the stated rule.**
- The rule is that carried Fatigue costs 2 ENERGY a point over 50, at most 20 (`stale_energy`).
- LEAN adds +0.5 Fatigue a day. Over 12 days that's 6 points, so the cost is 12 ENERGY if the fighter is already over 50, or 0 if under. The map prints −3.
- CUT adds +1.5 a day, which is 18 points: 36 capped to 20, or 0. The map prints −8.
- Fight week is TAPER (three rest days, light), which drains Fatigue before the bell.
- **Fix:** write the share as a function: the Fatigue still carried at the bell after taper, × 2 over 50. Re-print the table from it. Every WIN in part 7 moves with it.

**6. The money side of a pro penalty isn't the club's money.**
- The gym takes 25% of the purse (CODE). "10% of the asker's purse", "25% of the purse to the opponent" and "+25% of their purse" don't say what lands in the cash tin.
- **Fix:** every price line prints the club's change, e.g. "Catchweight +1: −$95 to the club (10% of a $3,800 purse × your 25%)".

**7. A UK game borrows American rules.**
- "3 misses = forced up a class (California's rule)" and the 25% penalty (Nevada NAC 467.522) come from US commissions.
- The pros here are licensed by the BBBofC (the pack's licence and medicals).
- **Fix:** use BBBofC rules where they exist (the map already cites 3.2.2 and 3.2.4). Tag anything else as a GAME VALUE, not REAL with a foreign source behind it.

**8. Amateur "box them" breaks the amateur rule.**
- D9's amateur BOX THEM for a corner over the allowance contradicts EB 10.7.2, which the map itself cites: over the allowance is a walkover, and the bout is called off.
- **Fix:** for amateurs, the standing order only covers the ask-a-kilo case: "accept their kilo request: they owe you a favour" or "refuse: walkover win".

**9. The nutritionist breaks the staff rule.**
- The pack says each staff job changes one number. The nutritionist changes four: the trim price, the forecast, slips and the refuel.
- **Fix:** one effect. Slips ×0.5 for every fighter on a diet is the one real practice backs (support, not chemistry). The forecast band narrows as a consequence. Drop the trim and refuel effects.
- The Old hand's added trim ×0.75 changes an approved head-coach edge. That needs the owner's OK, so list it under section 9.

**10. The fog leaks, and the amateur contract is decided blind.**
- The refusal reason "the opponent walks 67.6" gives away the exact walk that scouting is meant to sell.
- An amateur can't scout before accepting (S410). So D2 at the offer is chosen with the walk at a 2 kg range, and the WIN printed there must be a band, not 54.
- **Fix:** the refusal says "we'd give away size", with no number. Every WIN on an offer shows the band (the pack's rule: the win chance is a band that widens when unscouted).

**11. The per-camp plan table decides very little.**
- In the worked camp the rows are 52, 54, 52 and 56. Leaving out the gamble, the spread is 2 in 100, below the map's own bar (P10: 3+ in 60 of 100 camps).
- The coach marks the cheapest row that makes weight, so the player learns to press the coach's row. The depth then lives on the CLASS card and the contract, not in the camp.
- The GAMBLE shows the top WIN whenever a favour is held, and its real price (a favour from a shared pool) isn't in the WIN. On screen it looks dominant.
- **Fix:** price the favour in the row ("uses 1 of 2 favours: the next ask a kilo would be a walkover"). Accept that the table is a check more than a choice: hide it behind the coach's row and open it only when the MISS RISK is 5 in 100 or more, or the WIN spread is 3 or more.

**12. REFUEL AGGRESSIVE is free for pros.**
- Its only cost applies when the scale-to-bell time is under 24 hours. The pro scale is about 30 hours out, so AGGRESSIVE always wins unless the second-day clause blocks it.
- **Fix:** price it on the night: ENERGY −2 for the first round (gut weight), and a stoppage or injury roll ×1.1. Or cut STANDARD and leave the clause as the only lever.

**13. It leans on numbers the pack doesn't have.**
- "Promoter trust −1" (the pack only has "refuses if you duck twice").
- "Mood Good+" (the mood words are Fired up, Steady, Flat and Low).
- "Favours" (in CLUBWEEK1 and AMATEURWEEK1, not built).
- Either name the map that owns each, or swap to what exists. For trust: a missed check counts as one duck.

**14. One word list, held to.**
- FATIGUE (the map) against "Week tiredness" (the code's label), "tank" (CLUBWEEK1) and ENERGY. Pick one per idea across all three maps: tiredness for the week, ENERGY for the bell.
- STAMINA is fine; `Attrs.gd` has it.

**15. Scope.**
- The map has 5 new modules, 18 menus, 14 builds, 14 probes and two new classes needing the owner's scope call.
- The two classes are a precondition for UP and DOWN being real for a 65 kg woman (the next step up is 75). Ask that first. Without them, D1 is half a decision.

## Scores, with reasons

**Depth 7.**
- The CLASS card is a career-long trade that reaches the ladder, the business, a team-mate's slots, the pro limit and the fighter's asks. TEST THE WEIGHT and MOVE AFTER THE NEXT BOUT make it a timed decision.
- Contract weight, house rules, the standing order and the Monday check each move a different currency: favours, cash, mood, the ladder.
- The opponent's cut feeding a written plan line ("Write it") ties weight to the plan, the game's star.
- Short of 8: the per-camp table spreads 2 in 100, the coach's row is nearly always the answer, AGGRESSIVE is free for pros, and the gamble looks dominant.

**General design 5.**
- It's well sourced, the numbers rebuild, the menus are wired file by file, and the probes gate the pixels.
- What keeps it at 5:
  - Names and fixed gender are written in as the rule.
  - Power is used as a stat.
  - Club shows are modelled as class-limit bouts.
  - What comes back by the bell is wrong for a 1-hour scale.
  - The Fatigue shares can't be derived.
  - The nutritionist has four effects.
  - US rules sit in a UK game.
  - Favours and trust depend on things the pack doesn't have.
- Points 1 to 5 would lift it to 6 or 7.

**Play 6.**
- Each camp has a line to the scale with a Monday check, slips that land as news with a cause, a MISS RISK to watch fall, and the Why naming what weight cost in round 3. A class move debuting after the next bout gives a reason to come back.
- What drags it down: with four fighters, the WEIGHT PLAN panel is a lot to read every camp for a 2 in 100 choice. And at club shows, where most amateur bouts happen, real boxers rarely cut at all, so the drama belongs to championships and pros.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| CLASS: DOWN / STAY / UP | Cut size each camp, size on the night, ladder, offers, roster clash, pro limit | Keep. Needs the two new classes |
| Move now / after the next bout | Bouts lost while getting down against one more bout at the old weight | Keep |
| TEST THE WEIGHT | One catchweight bout that reveals the real cut, at half ladder credit | Keep, championships and pros only (club shows are matched anyway) |
| Class ask: HEAR / OVERRULE | Morale ±5/−4, loyalty −3 past 8% | Keep |
| Contract: AT THE LIMIT | Full ladder credit | Keep (pro, championships) |
| Contract: CATCHWEIGHT +1 / +2 | Smaller cut, half or no ladder credit, a share of the purse | Keep for pros. **Useless for amateurs** as written: club shows match by weight already |
| Contract: MATCHED | Both at one agreed weight | Make it the **club show default** |
| SECOND-DAY LIMIT | Caps the other corner's refuel | Keep (pro) |
| SHORT NOTICE at +2 kg or the walk | Size and ENERGY now against a camp later | Keep |
| THE PLAN rows: HOLD / LEAN / CUT + trim | Gains, Fatigue, ENERGY, a 2 in 100 spread | Keep, behind the coach's row (point 11) |
| The GAMBLE row | A favour against ENERGY | Keep, with the favour priced in the row |
| Trim stepper | ENERGY against the miss | Keep |
| WATER 0–3% (pro) | Size against ENERGY | Keep |
| REFUEL STANDARD / AGGRESSIVE | Nothing at a 30-hour scale | **Useless** (AGGRESSIVE dominant). Price it or cut it |
| HOUSE RULES: Free / Meal prep / + Monday weigh-in | Slips against $70 a week against mood | Keep |
| NUTRITIONIST | Four effects | Keep, with one effect |
| Monday check: SWITCH THE DIET / MOVE THE DATE | Saves the camp | Keep |
| Standing order: BOX / REFUSE | Purse share or walkover | Keep for pros. Amateur version per point 8 |
| WRITE IT (the fade line) | A plan line from the opponent's cut | Keep. The best link in the map |
| At the scale: SWEAT / PAY (pro) | ENERGY against purse | Keep |
| At the scale: ASK A KILO / WALKOVER | Favour against a loss | Keep |

**Missing options:**
- **Withdraw from the bout** at a failed Monday check, with the $300 slot (CODE) and no miss on the record. Today, past a switch or a date move, the only way out is to miss on the scale.
- **Starting class at signing:** the Interview and Trial card should show the walk and let you pick the class there. Today the class is fixed until the CLASS card.
- **Refuel for amateur championships** (9 am scale, 3 hours or more out): Standard or Light. It's the one amateur case where a refuel is real.
- **No-gi: enter a class up.** The bracket's class is given, and a bracket a class up should be a choice for a fighter at the top of her class. Tag it TO SOURCE (IBJJF and ADCC weigh-in rules are on my B14 list, not yet checked).

## To reach 10/10

1. **Names out of every row.** Rewrite section 1's rule to S448 ("names in the header once; rows say the fighter or the opponent") and fix every label listed in point 1, the drawings included. Replace "Her way" with "the fighter's way".
2. **Split amateur weight into club show and championship.**
   - Club show: MATCHED WEIGHT on the offer within the allowance (one number shared with AMATEURWEEK1 and CLUBWEEK1), scale 1 hour before, the meal only back by the bell, and the size edge from the matching gap.
   - Championship: the class limit, a 9 am scale, the map's regain numbers, and the refuel choice.
3. **The size edge on real stats.** Use Strength and Durability, or a flat dice edge in clinch and inside places only. Re-run P2.
4. **The Fatigue share as a function** of the tiredness left at the bell after the TAPER week. Re-print part 7's table and the drawings from one run.
5. **The club's cash on every money line:** the purse share already times 25%, the $300 slot, the $450 ticket cut.
6. **BBBofC for pros.** Replace the California forced move and the Nevada 25% with a GAME VALUE or a sourced BBBofC rule.
7. **The nutritionist does one thing:** slips ×0.5, $100 a week. Put the Old hand's trim change on the owner's list.
8. **Fog holds:** refusals give no number, and every WIN on an offer is a band.
9. **Price AGGRESSIVE**, at ENERGY −2 in round 1 and an injury roll ×1.1, or cut it.
10. **The plan table opens on need:** the coach's row by default, the table when the MISS RISK is 5 in 100 or more or the WIN spread is 3 or more. The gamble row prints its favour.
11. **Add the missing options:** withdraw at a check, the class at signing, the championship refuel, and the no-gi class up.
12. **One word list across WEIGHT1, CLUBWEEK1 and AMATEURWEEK1:** ENERGY (the bell), tiredness (the week), Stamina (the ability); mood words from the pack only; favours and trust owned by one named map.
13. **Ask the owner first** for the two classes (women 70, men 65). While there, also check the code's men's 57.5 kg class, which isn't a World Boxing class (the nearest is 55).
14. **Me (B14):** I source the no-gi scale rules, UK meal-prep and nutritionist prices, the cycle-week water, and the EB club allowance before the build, each with a tag.

## The 1920×1080 page (Fighter > Week, the WEIGHT PLAN, Look B)

**Shell:** the dark top bar, with CONTINUE reading "to Mon 23 Feb, weight check". Then the left rail, then the header strip: portrait, name (the only name), "Welterweight · 65.0 kg", "Walks 66.8".

**Whiteboard (1640×900), three columns:**

- **Left (560), THE LINE TO THE SCALE:**
  - A marker line from today to the scale chip "Scale Sat 28 · 4 pm · on the day, no water", with the slip band in pale red.
  - Monday checks as magnets ("Mon 23: 65.7 or under").
  - The trim's three days hatched, and the limit as a red tape line.
  - Below: THIS WEEK BY CAUSE in one line, plus the coach's one swap as a sticky with **Do it**.

- **Centre (620), THE PLAN:**
  - The coach's row large: "Lean + trim 0.6 · made, 0.1 to spare · ENERGY 86 · WIN 50–58".
  - Under it, the ENERGY bar split into its parts (tiredness at the bell, diet share, trim).
  - "Other plans" opens the table as a fold, and only opens itself when the miss risk is 5 or more.
  - The MISS badge "2 in 100" with a hover: "if the fighter misses: walkover, −$450, mood −6".
  - The trim stepper with the made, favour and cap steps marked.

- **Right (460), as cards:**
  - THE OTHER CORNER: "Walk 67–69 (tape 1 of 3)"; "Starts about 5 ENERGY under"; **Write it** (+2 in 100); and the standing order magnet "If the opponent misses: box / refuse".
  - HOUSE RULES: three magnets, "Meal prep · $70 a week in diet weeks · slips 1 in 4", and "Clean camps 1 of 3".
  - Staff line: "Nutritionist: slips halved · $100 a week" (Hire, or Hired).
  - Bottom ledge: the red **Withdraw ($300)** sits behind a divider, and only shows after a failed check.

**A second view: the fighter's CLASS card** (Overview), the same board:
- The walk line over 18 months, with "STAY stops being cheap: Apr 2027".
- Three columns DOWN, STAY and UP with the labelled rows (the cut, camp weeks, ENERGY, WIN band against the likely three, size against the top five, ladder place, offers in the last 8 weeks, a team-mate in the class, as a pro).
- The fighter's ask as a sticky with **Hear** and **Overrule**.
- **Test the weight**, then **Move now** and **Move after the next bout**.

## Sources (read 2026-11-14)
- [EB Technical and Competition Rules 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf): 2.7.8 (the weight gap in matched bouts), 7.1.3 (weigh-in 1 hour before boxing) (OFFICIAL).
- [Stevenage ABC, weight and amateur boxing](https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing) (undated): no weight classes at club shows, about 2 kg usual allowance, a bout called off on a miss (club practice).
- Everything else above is checked against the critic pack and the map's own numbers. I haven't re-read the map's other sources (Reale 2017, BBBofC, IBF, Nevada) this pass.


# CRITIC ANSWER: DESIGN_WEIGHT1_R2_CRITIC_KALLI_KALLI.md

# DESIGN_WEIGHT1_R2_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ103)

Brief: research/DESIGN_WEIGHT1_R2_CRITIC_KALLI.md
Sent: 2026-11-14 05:11 | collected: 2026-11-14 05:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# WEIGHT1 round 2: critic score (S459, fresh critic)

Part 1 of 3

**DEPTH 8, GENERAL DESIGN 6, PLAY 7. It clears the S459 bar (6+ and 6+), only just on General design.**

This is the deepest map in the loop. Weight is decided three times: the class (a career choice), the contract weight (a deal choice) and the camp plan (a week choice). Every option is priced in one currency, win chance, and the reason sits in its own column. General design is held at 6 by four things:
- **Names in the body,** an S448 breach throughout.
- **Amateur rules that don't match England Boxing:** a catchweight and a kilo favour at a same-day matched scale.
- **A second word for the energy ceiling** that clashes with other maps.
- **A build of 14 tasks and 5 new modules** with no smaller first release.

## DEPTH 8

**What works:**
- **No plan row is free.** HOLD + big trim, LEAN + mid trim and CUT + small trim each win in a different state: kg to lose, a goal that needs every morning, a same-day scale where trim is dear. P3 tests that each is best in 15+ in 100 camps, which is the right test.
- **The fighter pushes back.** Discipline drives weekend slips, house rules buy them down with money or mood, and discipline grows slowly from clean camps. That's a long-term investment with a weekly cost.
- **The opponent lives by the same rules behind fog.** Their trim shows only after tape, and WRITE IT turns their lower energy into a plan line. That ties weight to the Playbook, the part the owner calls really fun.
- **Every class option has a real price.** DOWN costs diet weeks, lost ticket cuts and a roster clash. UP costs size and a thinner ladder. Test the weight is the scouting move for your own boxer.
- **Monday checks** turn a hidden miss into a decision with weeks to spare.

**What keeps it from 10:**
- **The GAMBLE row is the best row whenever a favour is held.** It shows 56 against 54, and its downside (still a favour at 0.7 over) is nearly the same as its upside. Favours become a weight currency, and the gamble wins until favours run out.
- **The WIN spread across sensible rows is 52 to 56.** P10 asks for 3+ in 100 in 60% of camps, and the drawn example only just meets it. The player will often see rows within 2 in 100, which makes it the coach's pick in practice.
- **Size edge is dead for amateurs** at a same-day scale (the map says so). The class choice for the first 9 wins rests on energy and the ladder only, so UP and DOWN are thinner trades for most of a career.

## GENERAL DESIGN 6

**Rule breaches:**
1. **S448 and S412.** "Samira", "Kayleigh" and "Lucy Jackson" appear in rows, plan names, the ask card, the trim note, the fog line and the WRITE IT line. Even the vocabulary note says "Names, never he/she… 'If Samira slips'". The owner's rule is the opposite: the name sits once in the header, and the body says your boxer and the opponent. "Her way = heard" is a fixed pronoun. Every one of these has to go.
2. **Class words.** "Welterweight · 65.0 kg" names classes the code doesn't hold. The game says classes in kg (women's 57/60/65/75, men's 57.5/60/70/75), and 65 kg isn't a welterweight limit in amateur boxing.
3. **The amateur scale rules.** England Boxing seniors are matched at a same-day weigh-in within the width of the smaller boxer's category (rule 2.7.8), which makes a kilo allowance a matter of the match gap, not a favour. Two parts aren't real amateur practice: "CATCHWEIGHT +1 kg costs 1 favour" and "ASK A KILO up to 1.0 kg". CHECK (John): whether a show's matchmaker may re-pair inside the gap on the night.
4. **Words that clash.** ENERGY ("never Tank, Fresh") and FATIGUE ("never tiredness") collide with the pack's "Week tiredness" and with other S459 maps that use "tank". One word per concept has to hold across maps: pick ENERGY or the tank once, and keep the pack's "tiredness" on training screens.
5. **Old stat names.** Power and Durability as the size edge: Power isn't an Attrs value (it's read from Strength, Explosiveness and skill). Put the edge on Strength and Durability.
6. **Currency.** The TO SOURCE prices are in GBP and the game is in USD. Pick one.

**Buildability:**
- **The scope is too big for one row:** 5 new modules, 14 tasks, 18 menus and 14 probes. There's no cut line between the first release and later.
- Pro water, refuel, the second-day clause, title checks, short-notice catchweights and no-gi weigh-ins all sit beside the amateur core. The amateur road is the first 9 wins and most of the game.
- **Ownership.** The build table names Qwen, Arena, Cursor and Grok Dev as owners. The owner's loop is designers, critics and Claude committing, and the pack has no such seats. CHECK (Claude).
- **The bar.** "Nothing starts before two critics score 7+" contradicts the owner's S459 bar of 6+.

**Strong points:**
- Every number is tagged REAL, CODE, GAME VALUE, ESTIMATE or TO SOURCE, with a file and line.
- The energy sum is rebuilt and checkable (HOLD 81, LEAN 86, CUT 85 all add up).
- The menu wiring table is complete, with 18 rows plus new wiring.
- Round 1's points are answered in a table.

## PLAY 7

- **Good:** the line to the scale with a Monday check, a slip in the news with its cause, "clean camps 1 of 3", and seeing the opponent's trim after tape and turning it into a plan line. These are small weekly beats with a payoff on fight night, and the Why line closes the loop.
- **Weak:**
  - **House rules are set once,** which takes away a weekly decision but lowers the noise; that's the right call.
  - **With four boxers cutting,** the weight panel is one more screen a week per boxer. The coach's pick is the default, so a player who skips it loses only 1 to 2 in 100. That's fine for pace, but low for anticipation.

Part 2 of 3

## Logic check

| Claim | Check | Result |
|---|---|---|
| Energy sums | HOLD 100−4−0−15 = 81; LEAN 100−4−3−7 = 86; CUT 100−4−8−3 = 85 | holds |
| Trim prices | 0.6 = 5 + 2 = 7; 0.9 = 5 + 8 = 13; 1.2 = 5 + 14 = 19 | holds |
| Slip chance at discipline 34 | 0.8 − 0.34 = 0.46, about 1 in 2; meal prep 0.23; weigh-in 0.115, about 1 in 9 | holds |
| Opponent energy | 100 − 4 − 2 − 13 = 81, five under 86 | holds |
| WIN formula | 54 + 0.4 × (energy − 86) − 1.5 for a goal left close; CUT 85 gives 53.6 − 1.5 = 52.1 | holds |
| GAMBLE | energy 90 gives 55.6, about 56; needs a favour either way | the best row whenever a favour is held (a dominance risk) |
| Amateur size edge | same-day scale, back by the bell at most 1.5–2.1% + 0.3 kg | the size edge rarely reaches 1 kg, so one line: holds |
| Walk drift | half back in week 1, the rest over 3 weeks; REAL 3.5–4.8% a week | holds |
| Repeat misses | 3 in 12 months forces a class up | sound, but at amateur level a walkover loss already ends a nationals run |

## Missing options

1. **Re-weigh within the window at amateur shows.** Real club shows let a boxer step off and re-weigh inside the weigh-in session. That's a cheap fix that would replace "Ask a kilo".
2. **A cut-line for the first release.** An amateur-only version (class card, plan rows, house rules, Monday check, same-day scale, opponent fog) and a pro version later.
3. **Pull out before the scale.** When the Monday check shows a sure miss under 2 weeks out, the player should be able to withdraw early, which costs the slot but no walkover on the record. The pack already has "pull out (club pays the empty slot)" for injury.
4. **A coach-pick trust line:** how often the coach's plan row was right last season, so the player knows when to override.
5. **Weight across two boxers in one class:** the roster clash is shown but has no option (share shows, alternate, or one moves).

## Useless or weak options

- **CATCHWEIGHT +1 kg at amateur level.** It isn't real at a matched same-day show. Cut it for amateurs and keep it for pros.
- **ASK A KILO as a favour.** Replace it with the match gap and a re-weigh.
- **MATCHED WEIGHT ± 0.5 kg** as a separate option at club shows. Amateur matching is already by gap, so this is the default, not an option.
- **The cycle-week band.** It changes nothing the player acts on except "the coach advises a few days earlier". Keep it only if it moves the Monday check, or else hide it (section 7, actionable information only).
- **The second-day limit clause:** a rare pro edge case, for later.

## What each option changes

| Option | Changes |
|---|---|
| Class DOWN / STAY / UP, now or after | cut % each camp, diet weeks, energy at the bell, size, ladder place, offers, roster clash, pro limit |
| Test the weight | one bout at a midpoint catchweight; half ladder credit; real slip and trim data on the card |
| Hear / overrule a class ask | morale +5 / −4, loyalty −3 past an 8% cut |
| Contract weight (limit / catch +1 / +2 / matched / second-day) | cut size, energy, the opponent's size, ladder credit, purse share or a favour |
| Short notice at +2 or the walk | no camp, no cut; purse +30% or a favour owed |
| Plan row (diet + trim) | scale weight, training gains, tiredness, energy, camp goal, miss risk, WIN |
| Water and refuel (pro) | energy, night weight, size edge |
| House rules | slip chance, against $70 a diet week or mood −1 a Monday |
| Nutritionist | trim price ×0.8, an exact forecast, slips ×0.75 for every boxer, $100 a week |
| Monday check: switch diet / move date | gains and tiredness re-priced / a favour or promoter trust |
| Standing order on the opponent's miss | box (money or a favour) or refuse (walkover or slot fee) |
| WRITE IT | adds a plan line tied to the opponent's lower energy |
| Sweat or pay; ask a kilo or walkover | energy / purse share; a favour / a loss, mood −6, −$450 |

## Menus

The map's own table (M1 to M18) is complete. Three notes:
- **M3 (CLASS card)** puts names in the ask card. It should read "your boxer asks to move up".
- **M13 (News)** is a body line, so it says "your 65 kg boxer", not a name.
- **The Office desktop is missing.** The next four weeks there should carry "scale today 4 pm" and the Monday check (Desktop is built, S451).

Part 3 of 3

## To reach 10/10 (most important first)

1. **Take every name out of the body** (S448, S412). Plan rows, ask cards, fog lines, WRITE IT, news, the trim note and the vocabulary note say your boxer, the opponent, your 60 kg boxer, and her / him for that fighter's own. Names stay in the CLASS card header and the weight plan header only. Fix "Her way = heard".
2. **Rewrite the amateur scale to England Boxing.** Same day, about 1 hour before boxing at club shows (7.1.3). Matched within the gap allowed by the smaller boxer's category (2.7.8). A boxer outside the gap may re-weigh once inside the session (ESTIMATE window 30 minutes), CHECK (John). Cut amateur catchweight and ASK A KILO; the favour moves to "ask the matchmaker for another name". Championships keep the class limit.
3. **Classes in kg only.** "65 kg", never "Welterweight · 65.0". The two new classes (women 70 kg, men 65 kg) go to the owner as a scope question with their kg, and names only if he wants them.
4. **One energy word across all maps.** Decide ENERGY or the tank once, put it in the GLOSSARY, keep the pack's "tiredness" (Week tiredness) on training screens, and drop FATIGUE.
5. **Put the size edge on Attrs:** +0.6 Strength and +0.6 Durability per kg from 1 kg, capped at 4 kg. No Power.
6. **Price the GAMBLE so it isn't dominant.** A favour spent on a weight gap also costs host trust −1 for 8 weeks (ESTIMATE), or the gamble's miss branch is a walkover with no favour route. P3 must show the gamble best in 5 to 25 in 100 even with favours held.
7. **Widen the plan spread or fold rows.** If P10 fails, show only the coach's row and one alternative ("Instead: CUT + trim 0.3, energy 85, 52 in 100"), and keep the full table behind "All plans".
8. **Cut a first release.** Release 1 is the amateur core: walk, class card, plan rows (HOLD / LEAN / CUT with trim), house rules, the Monday check, same-day scale with re-weigh, opponent fog with WRITE IT, the Why line, the nutritionist. Release 2 is pro: water, refuel, second-day clause, contract catchweights, title checks, short notice. No-gi comes with John's sourcing. Re-number B1 to B14 under these two releases.
9. **Add "Pull out before the scale"** on the Monday check when the plan's miss risk passes 1 in 3 under 2 weeks out. The club pays the $300 slot, the record shows no walkover, and mood −3 (ESTIMATE).
10. **Give the roster clash an option.** On the CLASS card, when two of the club's boxers share a kg class: "share shows" (the longer wait gets the slot) or "one moves" (opens DOWN / UP for one of them).
11. **Make the cycle band actionable or hide it.** If kept, the Monday check uses the wider band, so a check can fire a week earlier. Otherwise cut it from the screen.
12. **Add the Office desktop** to the menu table: scale day and hour in the next four weeks, and the Monday check as a need.
13. **Align with the loop.** The bar is S459's 6+, not 7+. Owners are Claude and the design seats, with no unlisted tool owners. Use one currency (USD) with GBP as a TO SOURCE note only.
14. **Run P3, P10 and P12 first** and print the measured WIN spread before any panel is built.

## The 10/10 page at 1920×1080 (Fighter page > Week, WEIGHT PLAN, Look B)

- **Dark top bar (64 px):** "to Mon 23 Feb, weight check" on CONTINUE (green, the only green).
- **Header (110 px):** polaroid portrait and the name once, the class in kg, the walk ("walks 66.8 kg · class 65 kg · 2.8% over"), the scale chip ("SCALE SAT 28 · 4 PM · same day, matched within 2.5 kg") and the MISS RISK badge ("2 in 100").
- **Left (760 px), THE LINE TO THE SCALE:**
  - The chosen plan solid and the others dashed, with the slip band shaded.
  - Monday check markers (a tick or a red ring) and the three trim days hatched, with the limit as a red line.
  - Under it, THIS WEEK BY CAUSE in one marker line and one coach swap with its kg and a "Do it" magnet.
- **Centre (680 px), THE PLAN:**
  - The coach's row in the one gold frame: diet + trim, scale result, camp goal, energy as a stacked bar (tiredness carried, diet's share, trim), WIN "54 in 100", and "if your boxer slips Saturday: 50".
  - One alternative row below it, and "All plans" opens the rest.
  - The trim stepper with every step marked (made −7, made −13, the 2% cap in red).
- **Right (480 px):**
  - **THE OPPONENT:** the walk as a range until tape, then the trim; "the opponent starts 5 energy under" with a WRITE IT magnet showing "+2 in 100".
  - **HOUSE RULES:** three pills with slip odds in fractions ("1 in 2 / 1 in 4 / 1 in 9") and their prices.
  - **Nutritionist line** with its effect, or Hire.
  - **IF YOUR BOXER MISSES:** re-weigh once, then a walkover loss, −$450, mood −6, and the ladder place lost.
- **Bottom (96 px):** your assistant's note (one reason, never "best") and the red **Lock the week**.
- No names outside the header. Every number has a hover with its parts.
