# AMATEURWEEK1_V7 - write the NEXT version of this mechanic's design map (S459 design loop)

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

# AMATEURWEEK1 v6: the amateur fight week (S455)

v6 is v5 (ops/research/AMATEURWEEK1_MAP_V5_S451.md) with every point from its two critics answered. Everything in v5 that this page
does not name stands as written. Critics on v5: Kalli SQ64 (ops/research/AMATEURWEEK_CRITIC_S451_KALLI.md), John SQ65
(ops/research/AMATEURWEEK_CRITIC_S451_JOHN.md). Their shared finding: the trips and sparring sit on the wrong week or buy nothing, so
the fight week has one real decision (Rest up or not), and the default stop is always right.

Code facts read in S455 (Claude):
- The sessions feed, in the game's words (Data.LABEL): Roadwork and Intervals -> Stamina; Heavy bag and Strength circuit -> Power;
  Speed bag -> Speed; Slip rope -> Defence; Shadow boxing and Pads -> Technique; Neck work -> Durability. Sparring -> Fight IQ.
- InjuryRoll: injury risk x1 below 72 tiredness, rising to x2 at 76 and x3 from 80 (WeekPlan.OVERREACHED, where gains run at x0.6).

Words: "the boxer" and roles ("your assistant", "the head coach"); a name only in a header (S448). "Under 4 wins", never "novice"
(the pack's novice is 0-10 bouts, the mismatch rule).

## 1. The idea (changed)
- An amateur bout comes 1 to 3 weeks out and has no camp. The FIGHT WEEK SCREEN covers the bout's last TWO weeks when the bout is 2+
  weeks out: a slim WEEK BEFORE strip (the trip and the last sparring day) above the fight week itself. A 1-week bout shows the fight
  week only. A 3-week bout: week 1 is a normal week on the week board (BUILD), weeks 2-3 on this screen. (John: v5 picked the trip on
  a screen that did not cover the trip's week.)
- Every choice still lands on ON FIGHT NIGHT (TONIGHT + BANKED + SEASON). v6 makes each load stop the right one in some state, and
  prints the season line only from the measured re-run (section 4b).

## 2. The bout sheet (changes)
- SLOTS BY CLASS (Kalli 8): a show offers its 8-12 bouts as slots by sex and class. A sheet card needs an open slot at the boxer's
  weight. Two of the club's boxers in one class: the card goes to the one longer since their last bout; the other's empty slot says
  why ("this slot went to your other welter"). The sheet shows UP TO three cards; the slot test (section 12) must average 2 or more.
- PASS (both): only the pressed PASS button counts - declining the whole sheet. Taking one card closes the others with no pass. Each
  card shows the club's count: "passed 1 of 2". Two pressed passes on one club = 8 weeks without its calls.
- RING RUST counts from the suspension's end, not from the stoppage (Kalli 9): 6 weeks READY without a bout = FLAT in round 1.
- The home ticket cut stays the game's $450, labelled a game number (John: no sourced share exists).
- THE NATIONALS (John): every card shows "bouts to entry n of 5" and the entry date. While a boxer is in the nationals the sheet is
  closed with the reason ("in the nationals until <date>") and the camp opens as the pack says.
- PRO PACE (John): at 9-11 bouts a season and 61% wins, 9 wins arrive in about 1.4 seasons. This goes to his board with the pro road
  (section 13); nothing changes before his answer.
- GOALS THE ASSISTANT CAN READ (John): three goal types join FighterGoal: "Climb to top 3 by <date>", "Earn $n for the club this
  season", "Three bouts before the nationals". "Your assistant picks the bout" reads the goal: a rank goal picks away, a money goal home.

## 3. The bout sheet's trades (one change)
- "A loss to a name below drops two places" changes the pack's rank rule (a loss moves no place). It goes to his board beside the pro
  road (Kalli 10) and is not built without his yes. Without it, an away loss costs only the record.

## 4. The fight week screen (rewritten parts)
### WHERE TO TRAIN: three trips, each a thing only a trip gives (Kalli 3, John 3)
Prices now include food for two ($120) and extras ($50) a week (John S449).

| Trip | Cost | What it does (shown on TONIGHT) | When |
|---|---|---|---|
| Home gym | free | nothing extra | always |
| City club, commute | $150 + $40 food | a partner in the opponent's STYLE (pressure, counter, mover, southpaw): round-1 edge 1.0 against that style. Shown only when the opponent's file names a style. Injury x1.0 (v5's x1.3 had no cause) | fight week or week before |
| Hill cottage | $745 off-season, $1,170 June-August | the WEEK BEFORE runs as Train through with no load-ratio cost, and the fight week starts at tiredness -6: Tick over then costs 3 off the tank, not 6 | week before only (bout 2+ weeks out) |
| Seaside house | CUT | a free home rest week already gives morale and tiredness (both critics) | - |

- THE COACH GOES TOO (John): a trip takes your assistant, or the head coach if there is no assistant. The screen prints the cost at
  home: assistant away = the other boxers train that week at 60% and the evening class stops (-$350); head coach away = no head-coach
  edge and no shouts for any other bout that week.
- CAMPPLACE1 measures each trip PER USE against a home REST week (John), target 1-4 wins in 100 for that bout.

### THE TANK (John)
- The tank is capped at 25 off. Its parts stack in this order and stop at 25: tiredness over 50 (1 a point), the load stop, sparring,
  the weight. The stacked bar shows the part that falls past 25 greyed: "3 more would be lost here".

### THE WEEK'S LOAD: each stop best in a state (Kalli 1, John 2)
| Stop | Tank at the bell | Round 1 | Banked | Carried | Best when |
|---|---|---|---|---|---|
| Rest up | full | FLAT (edge 2.0 against) ONLY when the week starts under 40 tiredness; otherwise sharp | a fifth | tiredness to 30 | the boxer starts the week at 65+ tiredness |
| Tick over (the taper, default) | 6 off | sharp, and ONE chosen plan line fires one level up in round 1 (Usable -> Sharp share) | half | nothing | most weeks |
| Train through | 12 off | sharp | full | +6 tiredness; the week counts in TrainingLoad's ratio (high 1.3x, spike 1.5x: 2-4x injury) | the opponent is rated 5+ below and the next sheet is 4+ weeks away |

- "+1 plan line ready" is now a rule (both): the player picks the line on the screen; it fires at the next level's share in round 1 only.
- BANKED shows its measured size (Kalli 2): about +0.5 stat points between a full week and a fifth; never "+1 to +2".

### SPARRING: the last sparring day, and what it buys (Kalli 4, John 4)
One choice replaces the count: LAST SPARRING 9, 7, 5 or 3 days out, or none.
| Last sparring | Price | Buys |
|---|---|---|
| none | nothing | nothing |
| 9 days out (week before; bout 2+ weeks out only) | free | confirms ONE plan line against a live partner: it fires at its full share from round 1 (as a CONFIRMED tell) |
| 7 days out | 3 off the tank | confirms one line |
| 5 or 3 days out | 3 off the tank and x1.5 training injury each | confirms TWO lines (the second night) |
- So a 2-week bout spars at 9 for free; a 1-week bout trades one confirmed line against the tank; a heavy weight cut picks none.
- Your assistant's default: 9 when it exists, else 7 when the tank stays under 12 off, else none.

### WHO PAYS (John 7)
- SAVINGS come from the boxer's own job: $25-75 a week by background, shown at signing, never club money. They stop while the boxer is
  on the club's stipend only if the background says so ("full-time on the stipend").
- FUNDRAISER: a club night in place of one evening class (-$350) that raises $300-600, the odds rising with reputation.
- Mood: club pays +3; boxer pays +6 on a win, -3 on a loss (a confident boxer wants to pay); half each +2 on a win, -1 on a loss.

### YOUR ASSISTANT'S PICK is fallible and readable (John 1)
- It reads three facts and says which drove it: start tiredness, the weight's tank cost, the opponent's round-1 style.
- It is wrong at (1 - sureness): then it picks the next-best stop and still gives its reason. Sureness = 0.5 + rating / 200.
- The SEASON line compares each stop with the best stop for this boxer this week, never with the pick.
- PROBE TARGET: a player who reads the box beats "always the pick" by 2+ wins in 100 over a season, or the load slider is cut.

## 4b. The price list (what must be re-measured)
- FIGHTWEEKPROBE3 stands for today's booking. v6 adds FIGHTWEEKPROBE4: the season on BoutSheet with 9-11 bouts, the load-ratio cost,
  the late-sparring injury, the new Rest up rule; it reports, FOR EACH STATE (start tiredness band, opponent gap, weeks to the next
  sheet), which stop wins. Build target: each stop is the best in at least 1 fight week in 5; always one stop costs 2-6 in 100. v5's
  "the gaps roughly double" is withdrawn (Kalli 3): the season line prints only from this run.

## 5. The film evening (changed rule, both)
- A tell is checked at the first corner minute where the opponent's MODE matched it (pressure, loading up, tiring). A fade or slow
  start is checked at the round-2 or round-3 minute.
- A tell whose moment never came stays SEEN: no drop. Only a tell whose mode came up and did not show drops a level.

## 6. The weight (restored, John 9; capped, Kalli 12)
- Walk-in boxers' walking weight sits 2-4 kg above their class, so the career's first-hour cut stays.
- ASK FOR A KILO stays inside the smaller boxer's category width (rule 2.7.8); when it would cross, it is greyed with the reason.
  CHECK (John): the 2026 widths against the game's classes.
- TRAIN IT OFF: 0.3 kg for +8 tiredness.
- A MISS: re-matched on the night when the host has a fitting spare (1 in 3), otherwise the bout is off; the host takes 1 favour.

## 7-8. Favours and things that happen (rationed, John 6)
- A host asks for a late replacement at most once per show, only if your boxer fits the gap and is READY: about 1 ask in 6 shows.
- All asks wait for Monday and stop the clock once, as one need.
- The pull-out rate for the player's own bout is 35 in 100 in the final week (John: the middle of 25-50).
- Favour test target: an average club sits at 1-2, not 3.

## 10. Critics' points, each answered
| Point | v6 |
|---|---|
| K1 Tick over always right | state rules per stop; FIGHTWEEKPROBE4 by state; target each stop best 1 in 5 (4, 4b) |
| K2 BANKED too big | +0.5, measured size (4) |
| K3 "Roughly double" a guess | withdrawn; season line only from FIGHTWEEKPROBE4 (4b) |
| K4 / J Trips on the wrong week | WEEK BEFORE strip on this screen; cottage acts on the fight week; seaside cut (1, 4) |
| K5 / J All fight-week sparring late, no benefit | last sparring day; each night confirms a line (4) |
| K6 / J "+1 plan line" undefined | one chosen line one level up in round 1 (4) |
| K7 / J Film punishes untriggered tells | checked when the mode came up; else SEEN (5) |
| K8 Too few slots | slots by class; longer-rested boxer gets it; slot test 2+ (2, 12) |
| K9 Ring rust after every stoppage | counts from the suspension's end (2) |
| K10 Second decided number | the loss-below rule on his board (3, 13) |
| K11 / J Pass undefined | pressed Pass only; per-club count (2) |
| K12 Kilo past the width | capped, greyed with reason (6) |
| K13 Novice | "under 4 wins" (words) |
| K14 Shares in old words | the game's own words: Stamina, Power, Speed, Technique, Defence, Durability (code facts) |
| K15 Commute too narrow | a style partner, shown only when the file names a style (4) |
| K16 Mockup not this screen | redraw as one week + WEEK BEFORE strip, in the camp plan's look (his S455 ruling: the art stays consistent) |
| J Tank past its max | capped at 25, overflow shown (4) |
| J Food, coach absence unpriced | food in every price; coach away priced on screen (4) |
| J Who pays fake third party | savings from the boxer's job; fundraiser; mood favours a confident boxer (4) |
| J Pro pace | to his board (2, 13) |
| J Nationals missing | entry count and date on cards; sheet closed during a run (2) |
| J Assistant can't read goals | three new goal types (2) |
| J Fall-through floods the clock | asks rationed, Monday need, 35 in 100 own bout (7-8) |
| J First-hour weight beat gone | walking weight 2-4 kg over (6) |
| J Ticket share blank | $450, a game number (2) |
| J Assistant's pick | fallible, reasoned, season line against the best stop; probe target or cut (4) |

## 11. Menus (additions to v5's table)
| Menu | What it shows | Wired to |
|---|---|---|
| Fight week screen | WEEK BEFORE strip (trip, last sparring day); the capped tank with its overflow; the chosen Tick-over line; coach-away cost | FightWeek, CampPlace, TrainingLoad |
| Bout card | "bouts to entry n of 5", entry date; "passed 1 of 2" | BoutSheet, Nationals |
| Boxer card | savings a week from the background | Savings, Recruit |
| Goals (boxer page) | the three new goal types | FighterGoal |
| Money | fundraiser nights | GymBills |

## 12. Build order (changed probes)
1. Probes: FIGHTWEEKPROBE4 (by state, on BoutSheet), CAMPPLACE1 (per use, against a home rest week), BudgetProbe (away at $0, the
   fundraiser), the favour test (average club at 1-2), the slot test (2+ cards a sheet).
2-5. As v5.

## 13. Open for him (on the board after the critics)
- The pro road: "9 wins with 3 over ranked names", or keep "9 wins at any rank"; and the pace (a pro offer in about 1.4 seasons).
- A loss to a name below drops two places: yes or no.
- Savings from the boxer's own job ($25-75 a week by background): yes or no.


# CRITIC ANSWER: AMATEURWEEK_CRITIC_S455_BRIEF_KALLI.md

# AMATEURWEEK_CRITIC_S455_BRIEF_KALLI - Kalli answer (seat queue SQ71)

Brief: research/AMATEURWEEK_CRITIC_S455_BRIEF.md
Sent: 2026-11-13 18:40 | collected: 2026-11-13 19:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring the amateur fight week now. First I'm opening the camp plan v3 mockup to check it against the map.

Part 1 of 3

# THE AMATEUR FIGHT WEEK: critic (S455, Kalli)

Judged on PART A over PART B, the pack, and `docs/mockups/s449/camp_v3/camp_plan_v3.png`, which I opened with the file tool. I didn't open the Miro board, the real screens or the code.

**Verdict:** Depth 5/10, Play 6/10.

The bout sheet is the best part:
- Home against away (money against places).
- Slots by sex and class, so females never meet males by construction.
- Favours, and a pass that only counts when pressed.

Choosing between three cards is a real weekly question.

The fight week under it is mostly solved:
- The SEASON line tells the player which stop is best.
- Rest up wins whenever the boxer starts tired.
- Sparring 9 days out is free.
- Club pays wins the mood column.

On top of that, the assistant probe's target can't be reached, so by the map's own rule the load slider gets cut.

## 1. Logic check

**1. The SEASON line gives the answer away.** It "compares each stop with the best stop for this boxer this week". The stop showing "0" is the right one, so the player stops reading and picks it, and the load choice is gone. The same line is the probe's own measure: a player who reads the box always matches the best stop.

**2. Rest up wins from 40 tiredness up, not 65.** From 40 up, Rest up is sharp in round 1 with a full tank, and it carries tiredness down to 30.
- Tick over is 6 off (inside the noise, by 4b) plus one line one level up in round 1 only.
- At 50+, every point over 50 adds to Tick over's tank, and Rest up clears it.

Rest up is therefore right in every week starting at 40+, which after a bout and a normal week is most weeks. FIGHTWEEKPROBE3's Rest up cost came from the FLAT round, which v6 removes for exactly these boxers.

**3. Train through's "best when" almost never happens.** "The next sheet is 4+ weeks away", but the next sheet comes 21 days after a points bout. Only a stoppage loss, a pass or the nationals make it 4+ weeks.

**4. The order of the tank cap rewards being tired.** Parts stack tiredness first and weight last, then stop at 25. A boxer already at 20 off from tiredness and load pays only 5 of a 10-off cut. The more worn out the boxer, the cheaper the weight. The overflow should fall on the part the player can't choose, or the cap should go.

**5. Sparring can't confirm a tell.** PART B section 5 defines CONFIRMED as the opponent showing the tell in the fight, which a club partner can't do.
- A line not built on a tell already fires at its full share, so "confirms one line" adds nothing to it.
- On a SEEN line it adds only the 10% gap, in round 1.

So sparring buys almost nothing, at 3 off the tank or x1.5 injury.

**6. "Last sparring day" against nights.** The choice is one day (9, 7, 5 or 3), but 5 or 3 "confirms TWO lines (the second night)". Which two nights? Is the tank 3 or 6? PART B's "inside 7 days" late-sparring rule also clashes with PART A's "7 days out: no injury".

**7. Sparring 9 days out is always right.** On a 2-week bout it's free and buys a line, and the assistant's default takes it. Nobody picks "none" there.

**8. PEAK against the WEEK BEFORE strip.** The pack's PEAK (2 weeks out) is "hardest, sparring twice". The strip sets one last sparring day and a trip. Say whether the strip replaces PEAK for amateur bouts. CHECK (Claude): WeekPhase on a 2-week amateur bout.

**9. The film rule has a minute that doesn't exist.** "A fade or slow start is checked at the round-2 or round-3 minute." An amateur bout is 3 rounds, so the only corner minutes are after rounds 1 and 2. A fade that shows in round 3 can never be checked.

**10. Matching at walking weight against the first-hour cut.** PART B section 6 matches at actual weight plus the gap, "never the class limit". So a walk-in 2 to 4 kg over the class needs no cut for an amateur bout, and "the first-hour cut stays" doesn't follow. Either amateur matching uses the class limit, or the first-hour lesson changes.

**11. The style is always known.** The city club "shows only when the opponent's file names a style", but the style word is free at booking (pack 4.6). It always shows. At injury x1.0 it's pure gain for $190 whenever there's money.

**12. Cottage units are mixed.**
- "Starts at tiredness -6" only changes the tank above 50.
- "Tick over then costs 3, not 6" is a second, separate rule.
- "The WEEK BEFORE runs as Train through with no load-ratio cost": Train through is a fight-week stop, not a week-before setting.

Say what the cottage does in one unit.

**13. Coach away.**
- "The other boxers train at 60%" while the head coach is at home. The pack's 60% is "without any coach". CHECK (Claude): the coach factor with only the head coach present.
- A commute is daily, so why does the assistant miss the evening class (-$350)?
- The city's "$40 food" doesn't match John's $120 for two.

**14. "Half each" is dominated.** At the measured 61% wins:
- Boxer pays: 0.61 × 6 - 0.39 × 3 = +2.5 mood, $0 to the club.
- Half each: 0.61 × 2 - 0.39 × 1 = +0.8 mood, and the club pays half.

Half each loses on both counts at any win rate over about 25%. "A confident boxer wants to pay" isn't tied to Confidence.

**15. The fundraiser is a chore.** It gives -$350 for $300 to $600, about +$100 on average, pressed every week by anyone short of money. When the assistant is away the class stops anyway, so the fundraiser is free that week.

**16. The assistant probe can't be met.**
- Luke Reid (58) is wrong 21% of the time, and Marcus Hale (74) 13%.
- A wrong pick takes the next-best stop. One night's best-to-worst gap is under 5 in 100, and next-best is usually 1 to 2.
- 21% × about 1.5 is about 0.3 in 100 a season, against a 2+ target.

By the map's own rule the load slider is cut.

**17. Tick over's line.** "One level up in round 1": a Signature line can't go up, and a Raw line (under 30) doesn't fire at all. Say which lines the picker offers.

**18. A pass on a sheet of three clubs.** Does one press add a pass to each club shown? "Passed 1 of 2" is per club, but PASS is per sheet.

**19. Fall-throughs.** 35 in 100 in the final week is about 3 to 4 a season per boxer, so about 14 Continue stops a season for four boxers, plus the host asks. A fall-through after a paid cottage week loses the money. The map doesn't say whether it's refunded.

**20. Word breaches.**
- "This slot went to your other welter": welter isn't one of the game's amateur classes (women's 57/60/65/75 kg, men's 57.5/60/70/75 kg). Say "your other 65 kg boxer".
- WHAT THE WEEK BUILDS says "Strength" while Data.LABEL says Strength circuit leads to Power, and Power is the summary (S448). Two words for one thing.

**21. Names.** The map uses roles only, and I found no name outside a header. "His board" and "his answer" refer to the owner and never reach a screen.

**22. The mockup is the 3-week camp, not this screen.**
- It still has the Seaside camp, which v6 cuts.
- It has no WEEK BEFORE strip, no load stops (Light/Normal/Hard instead), no tank bar, and no TONIGHT, BANKED and SEASON.
- It has "Cardio" and "Legs gains x1.2" (not game words), "gains x1.25" (the flat buff the map bans), and "Fight IQ x1.3".
- Its prices are $875, $400 and $1,000 a week, against the map's $745 and $190.
- It shows PEAK CAMP ("All three lines met = +1 to every stat").
- The pinned note says "YOUR COACH" where the map says "your assistant".
- Gold appears on at least four things.
- It's dark, not Look B.

The header "LUCY JACKSON vs PRIYA NAIR" is the only place names appear, which is correct.

Part 2 of 3

## 2. Depth: 5/10

I played four boxers across a season: two at 60 kg (one woman, one man), a 65 kg woman, and a man at 70 kg.

**Which bout: real.** Home gives $450, +8 members and +5 reputation. Away gives a place and two boxers' facts. That's a true pull every 4 to 6 weeks per boxer, made sharper by the club's money and by the slot going to whoever has waited longer.
- A rank goal or a money goal decides it for the assistant, and mostly for the player too.
- Without the two-places rule, an away loss costs only the record. So once a boxer is at 4 wins, away is the default for anyone climbing.

**Home or away when the card is level: real** until the money is safe. After that, away always wins.

**Where to train:**
- **City club:** taken whenever there's money, with no injury cost and the style always known.
- **Cottage:** only on 2-week bouts, and its gain is in mixed units. Hard to judge.
- **Home:** the default.

That's one real decision in three trips.

**Load:** solved by the SEASON line (logic 1), with Rest up winning from 40 tiredness up (logic 2) and Train through almost never best (logic 3). By the tenth bout this is one click.

**Sparring:** 9 days out on 2-week bouts, none or 7 on 1-week bouts. It buys almost nothing (logic 5).

**Film:** costs a pad night and gets one habit group. A real trade against mastery, and the best small choice here.

**Who pays:** club pays when there's cash and boxer pays when there isn't. Half each is never right.

**Favours:** a real slow resource. The kilo ask against keeping a club's ranked names is a real trade.

**Chores by bout ten:**
- The fundraiser every week.
- The goal mapping in the assistant's pick.
- About 14 fall-through stops a season.
- Choosing the Tick over line again every bout.

## 3. Play: 6/10

**It pulls me on:**
- A new sheet of three cards every few weeks.
- Watching "bouts to entry 3 of 5" and "passed 1 of 2".
- An away win taking a place.
- A late replacement call.
- A tell turning CONFIRMED at the first corner minute.

**What holds it at 6:** once the sheet is picked, the week screen asks seven choices whose answer is printed on it. Most weeks the player presses "Use the pick" and Continue.

## 4. Options

**Missing:**
- **A refund or partial refund rule** when a bout falls through after a paid trip.
- **The choice of which two sparring nights** a 5 or 3-day choice uses, and the tank for each.
- **A way for the player to ask for a named amateur opponent on the sheet.** AskBout rules exist (pack 4.5). The map gives three cards and no ask.
- **A rematch card** for a CONFIRMED tell kept at half value. The map keeps the tell but never brings the rematch.
- **The cottage's refund or cancel** when the bout moves.
- **Boxer pays tied to the Confidence trait,** and greyed with the reason when savings are short.
- **For the city club:** a choice of which style partner when the file names two habits.

**Useless as written:**
- Half each.
- Sparring "none" on a 2-week bout.
- Train through outside a pass or a suspension.
- The SEASON line in its current form (it's the answer, not a price).
- The fundraiser as a weekly money press.
- The round-3 minute for a fade.

**The menus:**

| Menu | Right place? | Found? | Can't act on or wrong |
|---|---|---|---|
| Boxer page, Fights tab | Yes (S448) | Yes | Pass per sheet against per club undefined; no ask for a named opponent; goal mapping decides the pick |
| Fights rail page | Yes | Yes | Fine |
| Bout card | Yes | Yes | "Your other welter" is not a class; risk line fine; "bouts to entry n of 5" good |
| Fight week screen | Yes | From the card | SEASON line shows the answer; tank cap order rewards tiredness; cottage mixed units; half each dominated; sparring "confirms" nothing |
| WEEK BEFORE strip | Yes | Yes | Clashes with PEAK; free 9-day sparring always right |
| Week board | Yes | Yes | Fine once the strip replaces PEAK by name |
| Office desktop / Home | Yes | Yes | Fine, one need for an open sheet |
| Boxer card (Roster) | Yes | Yes | Savings from the background fine; "can take a bout in 7 days" fine |
| Tape room | Yes | Yes | The round-3 check doesn't exist |
| Playbook | Yes | Yes | The Tick over line pick must exclude Raw and Signature |
| Region / club list | Yes | Yes | Fine |
| Continue | Yes | Yes | About 14 fall-through stops a season for four boxers |
| Corner minute (round 1) | Yes | Yes | CONFIRMED / Not seen fine; the round-2 minute is the last check |
| Result page | Yes | Yes | Fine |
| Money | Yes | Yes | The fundraiser as a weekly press |
| Goals (boxer page) | Yes | Yes | Fine; "Earn $n for the club" is a club goal on a boxer page |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Stop printing the answer.** The SEASON line shows each stop's measured season cost against Tick over (a fixed reference), at the boxer's start tiredness band. It never compares against "the best stop this week". The assistant's pick carries the recommendation, with its sureness, and can be wrong.
2. **Give Rest up a price at every tiredness.** Rest up is FLAT in round 1 at any start tiredness, with an edge that shrinks as start tiredness rises (2.0 under 40, 1.0 at 40 to 64, none at 65+). Tick over's line bonus also applies to round 2. FIGHTWEEKPROBE4 must show each stop best in at least 1 week in 5 within each tiredness band, not only overall.
3. **Make Train through's state reachable.** Change "best when" to: the opponent is rated 5+ below, OR the boxer is 2+ weeks from crossing a move to Usable or Sharp (the banked week finishes it). Print that crossing on the stop.
4. **Make sparring buy something real.**
   - A sparring night is one PLAN TEST against a partner of the club's nearest style, as camp does. The test shows how a plan line rates (Beats it / Works / Walks into it) before the bell, so the player can change it.
   - A test doesn't confirm tells. Only the fight does.
   - Pick nights, not "last day": 0, 1 or 2, each placed on a day. A night inside 7 days costs 3 off the tank and x1.5 injury.
   - On a 2-week bout, the free week-before night costs a pad night's mastery instead of nothing.
5. **Fix the tank cap.** Remove the cap, or let the overflow fall on tiredness (which the player didn't pick this week), never on the weight or sparring.
6. **One cottage rule, in one unit.** The week before banks in full with no load-ratio entry, and the fight week starts with 10 less tiredness (so it changes the tank only above 50). Drop "Tick over costs 3". CAMPPLACE1 measures it per use.
7. **Give the city club a price beyond cash.**
   - Injury x1.15 for the week (a strange partner and a strange gym).
   - The assistant's evening class runs only if the commute is days only.
   - Food at John's $120 for two, or explain the $40.
8. **Who pays, without a dominated row.**
   - Club: +3.
   - Boxer: +6 on a win, -3 on a loss, and only offered when Confidence is solid (55+). Otherwise greyed with the reason.
   - Half each: +4 on a win, 0 on a loss (the safe middle).
   - Re-check with the measured win rates that each row is best for some boxer.
9. **Fundraiser:** once every 8 weeks, not weekly, and it needs a coach in the gym that night.
10. **Film timing:** a fade or slow start is checked at the round-2 minute. A fade that never came stays SEEN.
11. **Weight:** amateur matching uses the class limit when the boxer is outside the class's gap, so the first-hour cut stays. ASK FOR A KILO stays as written. CHECK (John): the 2026 category widths.
12. **Fall-throughs:** one stop per boxer per bout at most. A paid trip refunds half when the bout falls through. Keep 35 in 100 only if John's range holds for the final week. CHECK (John).
13. **Passes:** PASS adds one pass to every club on the sheet, shown before pressing ("passing adds 1 to each club").
14. **The assistant probe:** measure "always the pick" against "the best stop each week" instead of "a reader". If the gap is under 1 in 100, keep the slider but default it, and don't call it a decision.
15. **Words:** class labels in kg ("your other 65 kg boxer"); one word for Strength circuit's stat.
16. **Redraw the mockup** as the fight week screen. The fight week screen needs the bout sheet (BoutSheet) and the show calendar (RegionShows), which the game doesn't have yet.

### The 10/10 fight week screen at 1920×1080

The shell stays: dark top bar, left rail. The content is a whiteboard (Look B). Names appear only in the header.

- **Header** (full width, about 110 px):
  - Both portraits, with the names, the class in kg and the records.
  - Days to the bell, home or away, and the favour count with the host.
  - The win band.
  - One red button: Lock the week.
- **WEEK BEFORE strip** (full width, about 140 px, only on 2+ week bouts): three trip magnets (home, city club, hill cottage), each with its cost, its one number, and the coach-away cost in one line. Plus a sparring night slot with its pad-night cost.
- **The fight week** (centre-left, about 1150 x 420 px): seven day columns, with mornings and evenings as magnets.
  - Under them, three picture-stop sliders, each stop showing its tank and banked numbers:
    - LOAD: Rest up, Tick over, Train through
    - SPARRING: nights placed on days
    - WEIGHT: Hold, Eat less, Train it off, Ask for a kilo, greyed with the reason when it would cross
  - The Tick over line picker shows only lines at Usable or Sharp.
- **WHO PAYS** (centre-left, under the week, about 1150 x 140 px): three cards (club, half each, the boxer) with cash and mood on a win or a loss, greyed with the reason.
- **Your assistant's pick** (right, about 620 x 220 px): face, one-line reason naming the fact that drove it, sureness word, Use the pick.
- **ON FIGHT NIGHT** (right, about 620 x 480 px, the one gold frame):
  - TONIGHT: a stacked tank bar (tiredness, load, sparring, weight) with its price in wins, sharp or flat, lines ready at their fire share, the scale margin.
  - BANKED: stat points this week in the trained abilities, the move crossing a line, tiredness carried.
  - SEASON: this stop against Tick over at this tiredness band, measured.
  - Each row shows its change from the assistant's pick.

There's no PEAK CAMP row, no Seaside card and no gains-x multipliers. Hovering any number shows its parts.

CHECK (Claude): WeekPhase on a 2-week amateur bout; the coach factor with only the head coach present.
CHECK (John): 2026 category widths; amateur pull-out rate in the final week.


# CRITIC ANSWER: AMATEURWEEK_CRITIC_S455_BRIEF_JOHN.md

# AMATEURWEEK_CRITIC_S455_BRIEF_JOHN - John answer (seat queue SQ72)

Brief: research/AMATEURWEEK_CRITIC_S455_BRIEF.md
Sent: 2026-11-13 18:40 | collected: 2026-11-13 19:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading the AMATEURWEEK v6 map against the pack now. The full critic return comes next.

# AMATEURWEEK v6 (S455): critic

Depth **6/10**, play **7/10**. v6 fixes a lot of v5: the trips are priced, the tank is capped, the pick can be wrong, savings come from the boxer's job, and there's a fundraiser. But it has new problems:

- The SEASON line now prints which stop is best, so the fallible pick changes nothing.
- The tank cap makes the most tired boxers pay the least for the choices they make.
- Two of the new trades are dominated: half-each paying, and late sparring.

I couldn't open `camp_plan_v3.png` (it's on your computer, which is offline), so I judged from the text.

## 1. Logic check

**The SEASON line gives away the answer.** Part A has it compare each stop "with the best stop for this boxer this week". The stop showing 0 is the answer, so the 13–21% error built into the pick does nothing. Sureness is 0.79 for the 58-rated coach and 0.87 for the 74-rated one; the player just reads the zero. The PROBE TARGET (a reader beats the pick by 2+) passes trivially, and the load slider becomes "press the zero".

**The tank cap's order makes choices free when the boxer is tired.** Tiredness stacks first and the weight last, all stopping at 25. A boxer at 70 tiredness at the bell already has 20 off. Train through then adds 5 of its 12, and a 1 kg Eat less adds nothing. The most tired boxer pays least for loading and cutting, which is the reverse of the intent.

**Train through's "best when" state almost never happens.**
- "The next sheet is 4+ weeks away" can't happen after a points bout, because the sheet comes 21 days later. It happens only after a stoppage suspension or a club lock.
- "Opponent rated 5+ below" is already about 72% to win (the pack's measure).
- So Train through is right in maybe 1 fight week in 15. That misses the build target of each stop being best in 1 week in 5.

**Rest up between 40 and 64 tiredness.** It starts sharp with a full tank, and tiredness carries down to 30. Tick over's only answers are a 6-off tank (inside the noise), half against a fifth of the banked week (about 0.3 stat points), and one line a level up in round 1. Those are close, but it's undefined whether Rest up's "full tank" clears tiredness over 50 or just adds no load part. That decides the 65+ case the map calls Rest up's best.

**Sparring buys almost nothing.**
- "Confirms one plan line: fires at its full share from round 1 (as a CONFIRMED tell)." By Part B section 5, an unconfirmed SEEN line runs at 90% of its share in round 1 only, and a line not built on a tell already runs at 100%.
- So confirming is worth a tenth of one line's share for at most six exchanges, and only for tell-based lines.
- 5 and 3 days out pay 3 off the tank and ×1.5 injury for two such confirmations. Nobody takes them.
- The night count is also unclear: "5 or 3 days out" confirming "TWO lines (the second night)" means two nights, but which two?

**The cottage's two effects overlap.** The week before "runs as Train through with no load-ratio cost". But that week is a normal BUILD/PEAK week on the week board with no load slider, so this adds nothing defined. "Tiredness −6" matters only above 50, and "Tick over then costs 3, not 6" is a second, separate discount. Pick one.

**The pay options: half each is dominated.** At the measured 61% wins:
- The boxer paying is worth 0.61 × 6 − 0.39 × 3 = +2.5 mood at $0 to the club.
- Half each is worth +0.8 mood at half the cost.
- The club paying is +3 at full cost.

Half each is never right while savings cover the trip. Any trip also adds mood just by being taken, so a boxer-paid commute is free mood plus a round-1 edge. Its only cost is the coach going too.

**The weight contradicts itself.** Part B matches "at actual weight plus a gap, never the class limit". Part A keeps "the career's first-hour cut" for walk-ins 2–4 kg over. If matching uses walking weight, nothing forces a cut. Say which number the match uses and what a cut buys: a lighter class, other names, a slot.

**The nationals can't be entered in the first season.** The first bout is day 26. The next sheet comes 21 days after it, with bouts at least 1 week out, so the cycle is at least 28 days: bouts on days 26, 54, 82. Entry closes in week 10 (day 70) and needs 5 bouts and 3 months registered. "Bouts to entry n of 5" counts toward a closed door in year 1. The card has to say "next year's entry".

**Pass still cascades.** "Only the pressed PASS button counts, declining the whole sheet", and the count is kept per club. A sheet of three cards from three clubs puts a pass on all three, so two whole-sheet passes lock three clubs for 8 weeks.

**Tells: the show rate is undefined.** "A tell whose mode came up and did not show drops a level." OppFile tells are facts of the opponent, so does one ever not show? Without a rate for a tape read being wrong, SEEN to CONFIRMED is a ritual.

**Stat names.**
- The code facts map Heavy bag and Strength circuit to Power, and Shadow and Pads to Technique. Both are summary stats since S448.
- "What the week builds: Technique, Strength, Stamina" mixes summary and Attrs names, and Strength isn't a Data.LABEL output.
- BANKED "+0.5 stat points" needs to say which Attrs number.

**Tick over against the evidence.** WeekPhase's taper has three rest days. The evidence (my S449 note) is one rest day with volume cut 40–60%. "Tick over = today's taper" is therefore not "the evidence".

**Code rules changed without the owner.** Part B drops `Matchmaking.STOP_REST_WEEKS` for amateurs, replacing a rule the S451 code check confirms. That's a decided rule change missing from section 13.

**Fall-throughs.** At 35 in 100 a bout, 4 boxers at about 10 bouts each get about 14 fall-through stops a season. Nothing says whether a paid trip or the coach's week away is refunded.

**Names:** none outside headers. Roles and "the boxer" are used throughout, and the club names on cards are clubs, not people.

## 2. Depth: 6/10

**Real decisions:**
- **Which card:** home money against an away place, set by the goal and the favours.
- **Whether the coach goes:** a commute or the cottage costs the other three boxers a week at 60% and the class's $350. With four boxers that's a real Monday trade.
- **The weight route:** Eat less against Train it off depends on tiredness. Train it off is better only below about 42 at the bell.
- **Favours:** a late replacement now for a ranked name later.

**Where it breaks:**
- **The printed best stop.** The load decision is read off the screen.
- **Sizes inside the noise.**
  - A whole fight week's best-to-worst gap is under 5 in 100 (PROBE1).
  - Banked is about 0.5 of a stat point.
  - The commute's 1.0 round-1 edge is worth about 1–1.5 in 100, DERIVED as half of the flat 2.0's 2–3.
  - Sparring confirmation is worth a fraction of one line in one round.
  - By the tenth bout the player trusts "Your assistant runs this week", which is wrong about 1 week in 5 at a cost nobody can see. Every fight week across four boxers (about 40 a season) becomes one click.
- **Always-right picks:**
  - The boxer pays (or the club), never half.
  - Sparring at 9 days when allowed, never 5 or 3.
  - Tick over unless tired.
  - Train through almost never.
  - The fundraiser whenever reputation is middling: −$350 against $300–600 is about +$100 on average.
- **Nobody takes:** half each, late sparring, Train through.
- **Chores:** fall-throughs at 14 a season, and favour asks at about 11 a year across the region, each stopping the clock.

## 3. Play: 7/10

The bout sheet carries the season: home or away, the climb, favours, a slot lost to your other welter, a late replacement. Those make you want to see next Monday. The fight week screen itself is a confirmation page with one real lever, the coach away.

## 4. Options and menus

| Menu or option | Verdict |
|---|---|
| Fights tab bout cards | Keep. Add "next year's entry" when the nationals are out of reach. |
| "Your assistant picks the bout" | Keep. It reads the goals now. Under 4 wins a rank goal has no table, so grey it with the reason. |
| PASS (whole sheet) | Change it. Passing a sheet should cost nothing. Only refusing a card a club offered by name counts against that club. |
| Trips: home, commute, cottage | Keep. Add **Boxer goes alone** (the partner with no coach: half the edge, no coach-away cost). That's the missing option. |
| Coach-away cost line | Keep. It's the best line on the screen. |
| Load stops | Keep three. Fix Train through's state and stop printing the best stop. |
| Last sparring 9/7/5/3/none | Too many stops for one value. Make it 9, 7 and none, or give late sparring a real price. |
| Weight: Eat less, Train it off, Ask for a kilo | Keep. Fix which weight the match reads. |
| Who pays (three choices) | Half each is dominated. Rework the mood or cut it. |
| Fundraiser | Keep. Its payout needs to go negative at low reputation. |
| ON FIGHT NIGHT, SEASON line | Change it: show the price against Tick over for the boxer's state band, not against the best stop. |
| Fall-through card | Missing: what happens to money already spent on a trip. |
| Boxer card "can take a bout in 7 days" | Keep. |
| Corner minute CONFIRMED / Not seen | Keep, once a tell has a chance of being wrong. |
| Money: trips by payer, fundraiser nights | Keep. |

## 5. To reach 10/10 (mechanics, most important first)

1. **Stop printing the answer.** The SEASON line shows each stop's measured price against Tick over, a fixed baseline, for the boxer's start-tiredness band only ("Rest up here: −1 to +2 in 100"). Opponent gap, weight and next-sheet date stay out of the line. The pick reads all of them, so a player who weighs them beats the pick. FIGHTWEEKPROBE4 tests that; otherwise the slider is cut to Tick over or Rest up.
2. **Make sparring the thing that gets a plan ready.** A plan line written or changed since the boxer last sparred fires one level down in rounds 1–2 (Usable to Raw: does not fire). A spar at 9 or 7 days readies two lines; a late spar at 5 or 3 readies all of them at ×1.5 injury and 3 off the tank. A new plan written for this opponent then has to be sparred. Measure it, target 2–5 in 100 a bout.
3. **Charge the boxer's choices first.** Load, sparring and weight stack before tiredness, and the cap cuts tiredness last. The greyed overflow is then always "tiredness already lost". A tired boxer still pays for Train through and a cut.
4. **Bank in mastery, so Train through has a real state.** A full banked week adds the week's pad units (720 for 3 pad nights) to the plan's moves. Half and a fifth scale down. The card shows "Train through: Uppercut Usable by the bell", which with FireLevel on fires 1 in 2. Train through is right when a move sits within one week of a tier. That state is common and readable, unlike "next sheet 4+ weeks away".
5. **Let the player set the rest window.** On the Fights tab: "next bout no sooner than 3 / 5 / 8 weeks". It moves the next sheet, Train through's load-ratio risk, and ring rust at 6+. It replaces the fixed 21 days, so a planned build block exists for a boxer who only wants to learn.
6. **Mood by payer, so each payer wins somewhere.**
   - **The club pays:** +3, but −2 with each other boxer if the club paid for this one more often in the last 8 weeks (fairness).
   - **Half each:** +3 on a win, 0 on a loss.
   - **The boxer pays:** +6 on a win, −6 on a loss. Savings under $100 put the boxer at "skint", −2 a week until refilled.
7. **One weight rule.** The match reads walking weight plus the gap. A cut is a choice to box down a class for that class's slots and ranked names. The first-hour cut becomes "box at 60 against a ranked name in 3 weeks, or at 65 now". The miss rule stays.
8. **The nationals entry on a rolling year.** Five bouts in the last 12 months and 3 months registered. Year 1 shows "next entry: week 10, 2027". Not built today: the nationals screen has no next-year state.
9. **Price passing per card.** Passing a whole sheet is free. Refusing a club's named call counts (2 in 8 weeks = its lock). No cascade across clubs.
10. **Tells can be wrong.** A SEEN tell is true at 70% after one film night and 90% after two. Not shown drops the line a level. That gives a second film night a price and CONFIRMED a meaning.
11. **Rules for a fall-through.** The cottage refunds half, the commute nothing, the banked week stays. The replacement card has three answers: take it, go home (+2 rest, mood −6), or ask the host for next month's slot (−1 favour, booked).
12. **Boxer goes alone** on the commute: half the partner's edge, no coach away, +1 tiredness.
13. **Fundraiser** at reputation odds: under "Known locally" it nets −$150 on average; at "Respected" and above +$150.
14. **Small fixes:** Attrs names for the sessions and the banked row; Tick over at 1 rest day with the volume cut, matching the evidence; the amateur STOP_REST_WEEKS removal added to section 13.

## The 10/10 fight week at 1920×1080

- **Header strip, 96 px:** the boxer's portrait and name once, class, and the bout (days to the bell, home or away club, weigh-in on the day, scale margin now and on the day). At the right, back to Fights.
- **Left column, 440 px: WHERE AND WHO.**
  - Three trip cards and Boxer goes alone. Each shows its cost, its one number on tonight, and its fall-through refund.
  - Under them, a red-edged COACH AWAY card: "3 boxers at 60% this week, evening class off: −$350".
  - The payer row: Club, Half, Boxer, with savings left and each choice's mood on a win and a loss.
  - The week-before strip sits above when the bout is 2+ weeks out.
- **Centre, 920 px: THE WEEK.**
  - Seven day columns of morning and evening magnets, with the sparring day pinned as a red magnet and the film night as a tape magnet.
  - Under them, three sliders with picture stops: LOAD (with the tiredness band printed), LAST SPARRING ("readies 2 lines"), and WEIGHT (Hold, Eat less, Train it off, Ask for a kilo, each greyed with its reason when unusable).
  - Plan lines below as chips: green "ready", amber "not sparred: fires a level down in rounds 1–2", and a SEEN or CONFIRMED tag.
- **Right column, 560 px: ON FIGHT NIGHT (gold frame).**
  - TONIGHT: the stacked tank, with the player's choices in colour, tiredness in grey, the overflow hatched, and its price in wins. Round 1 sharp or flat. Each line's fire per cent. The win band.
  - BANKED: the moves crossing a tier by the bell, Attrs points, tiredness carried.
  - SEASON: this stop against Tick over for the tiredness band, with its range.
- **Bottom strip, 120 px:** your assistant's note (portrait, reason, sureness word, no name in the text), Use the pick, Back to the coach's week, and the one pulsing button, Lock the week.
