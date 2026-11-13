# CLUBWEEK1_V5 - write the NEXT version of this mechanic's design map (S459 design loop)

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

# CLUBWEEK v4.1: one map. The club week for four, with the fight weeks inside it, and the season around it (S432)
> NAME (operator Q-190, S434/S435): "Just rename it 'gym sponsorship', the club pays". What earlier maps and drawings call the PAID SEAT is the GYM SPONSORSHIP here (short: sponsorship): the CLUB pays its own amateur for a 4-week block. It is not a Sponsor deal (Club > Money), where an outside business pays the club; no screen may mix the two words.


v4.1 (S432): v4 with the ten changes of the verdict written in (`docs/mockups/s432/critics/VERDICT.md`, "The ten changes to write into the map
before the build"): Tell it straight, loyalty's upside, HOME on our own show, Sell tickets cut, class nights bring members, away travel, mood rates
0.8 / 0.6 / 0.4, sizes as ranges, the professional's real choices with camp leave, and the small fixes. Nothing else changed. Each change is marked (v4.1).


Revises CLUBWEEK v3 (S431) after two fresh, blind critics scored its depth 7 and 6 (`docs/mockups/s432/critics/v3_coach_review.md`, `v3_sim_review.md`;
their 10/10 drawings beside them). Both said the same three things in different words: going short costs nothing that lasts, the amateur years do not reach
the professional's money, and nothing on the board says how big a choice is. v4 answers those three, gives the board one money lever and Ana real choices,
cuts seven weak options, and closes the list of mechanics for this version (last section).
Owner's words kept: professionals in the line-up and a guide that explains amateur to professional; staff named by role ("Coach", "Coach's evenings"); a full
name in a heading, a first name in running text; "Cardio" for the stamina group; game text never says he, she, her or him. "Coach" is the hired assistant
coach (Luke Reid in the data); "You" is the head coach, the player.
Drawn: `docs/mockups/s432/clubweek_v4.png` (the Club week board in week 5; v4.1 fix for the drawing: the fight week's Pass reads loyalty -2, not mood). The v3 drawings of the bout sheet, the bill and the road (`docs/mockups/s431/`)
stand, with the changes listed in section 4 and section 6.

## 1. The idea in six lines
- Four fighters stayed at the club you take over, in four weight classes: one PROFESSIONAL boxer, two AMATEUR boxers and one GRAPPLER.
- Every Monday ONE board, Club week, deals three short things between them: PAD PLACES, COACHED MORNINGS and GYM SPONSORSHIPS. Asked is always more than owned,
  and Coach's evenings can be sold as a class instead: the board's money lever.
- A bout is not a separate game: an amateur's FIGHT WEEK (12 days' notice, no camp) and a professional's CAMP (6 weeks) sit on that same board.
- FAVOURS are the second currency: earned by helping other clubs, spent to bend the terms of a bout. Never a win.
- What lasts past the week (NEW): each fighter's LOYALTY to you (going short, promises, the sponsorship), their FANS (home bouts build the crowd that pays the
  professional debut), and one SEASON TARGET each (the nationals, the pro offer, or a year to grow) that every Monday is dealt toward.
- No Monday repeats the last: the jobs' rota moves, one club twist lands, a trial fighter comes every 4 weeks, the other corner has had a week too.

## 2. The start
WHO STAYED (Create, step 2). The six boxers in the data are already in six divisions, so no pick blocks another.
- ONE PROFESSIONAL, picked from two (new data: each has an amateur card that reached the 9-win offer, a professional record of 1-0, the licence, no rank yet,
  and the fans the amateur years built). LUCY JACKSON, lightweight, 21, out-boxer: potential 84, 34 fans; spars in full with Kira and Danny. JOSH HARPER,
  welterweight, 23, southpaw pressure fighter: potential 79, discipline 80, 22 fans; spars in full with Tess; a southpaw in the gym. Opens with the second bout
  booked 6 weeks out.
- TWO AMATEURS, picked from four: Kira Mensah (featherweight, 1-0), Samira Khan (welterweight, 2-1), Tess Reilly (middleweight, 6-4), Danny Osei (lightweight,
  2-1). Each card shows the job, the free mornings, the sponsorship line, who can spar whom, the fans and the ambition (Recruit.ambition, today shown and unused).
- THE GRAPPLER, Ana Ribeiro (no-gi, white belt, 2 stripes): already there, not a pick. First open: Saturday 7 February.
Four fighters at the first unit (the code has 3). The two boxers not picked come back on the trial mat. The start is staggered: the professional is in camp, one
amateur has the first sheet (for Saturday 17 January), the other has a goal due. Each fighter's SEASON TARGET starts as the one their ambition names (section 3.9);
LOYALTY starts at the loyalty trait already in the data (Samira 82, Tess 66, Kira 60, Danny 58, Josh 70; Lucy's is rolled).
THE GUIDE IN WEEK 1 (one step at a time; the light rings the thing to press; it can be skipped):
1. MEET THE FOUR: one card each with a badge (PROFESSIONAL, AMATEUR, GRAPPLER), the season target and the one line that matters this week.
2. THE ROAD, AMATEUR TO PROFESSIONAL (drawn: `docs/mockups/s431/road_v3.png`; v4 adds each boxer's fans to the strip and the debut's ticket forecast):
   - "AMATEUR: 3 rounds, no purse. A home bout pays the club a $450 ticket cut and builds the boxer's own fans. The regional ladder."
   - "THE OFFER comes at 7 wins and a top-3 rank on the regional ladder, or at 9 wins at any rank. A national finalist is offered at once."
   - "SAYING NO: the offer returns after 2 more wins, on 90% of the terms. A second no: only No. 1 brings it back. A third: never."
   - "THE DAY A BOXER TURNS PROFESSIONAL the club pays $1,105: licence $230, medicals $875. The gym sponsorship stops; amateur bouts end for good."
   - "THE DEBUT: 4 weeks after signing, 4 rounds, paid from tickets: 100 tickets at $50, sold to the boxer's family (20), the boxer's fans and a quarter of the
     club's members; under 60 sold pays nothing; the boxer keeps half of what is above, the club 25% of that half." ("Tess: 26 fans. The debut would sell 61 today.")
   - "FROM THE SECOND BOUT: a purse ($1,500 unranked; ranked, $400 more for each rank from No. 20 up), the club keeps 25%; 6 weeks' notice and a camp; three
     offers from the promoter; 4 rounds, then 6, 8 and 10 up the national ladder." ("Lucy turned professional in October: this is the card after.")
3. DEAL THE WEEK: the light walks the board in order: the sponsorship, each pull, the pad places, the card. 4. ANSWER THE CALL. 5. START WEEK.
After week 1 the guide names the trade and never the answer ("Film for Tess means the bag for Samira. Your call.") and goes quiet after the third fight week.
THE REVEAL ORDER (NEW; the guide names each on the day it arrives; until then the board does not show it and its numbers do not move):
| Week | Arrives | What the guide says |
|---|---|---|
| 1 | pad places, the first sheet, the season strip (targets set from each fighter's ambition, not yet changeable) | "Eight pad places, eleven asked." |
| 2 | coached mornings; Coach's evenings: pads or the class | "A class pays the rent. Pads win bouts." |
| 3 | the club twist, the gym sponsorship, the sparring setting | "Hard sparring builds more and cuts more." |
| 4 | favours (the first is earned on that week's sheet); loyalty starts to move and its bar appears | "Whoever goes short remembers it." |
| 5 | the trial mat; season targets can be changed; the talk card can come | "One target a fighter: the date the week is built toward." |

## 3. The week, as the player meets it
### 3.1 What is short (each has a counter on top of the board, all in ONE unit, fighter-sessions: ASKED, COVERED, SHORT; covered is never more than owned; v4.1)
- PAD PLACES. Coach works 3 evenings; each evening's first hour is the members' class (the code's evening classes, +$350 a week, unchanged) and the second hour is
  either PADS (2 pad places) or a SECOND CLASS (NEW, section 3.1a). You hold 2 pad places on your own evening. All pads: 8. Always the two words, "pad place".
  Asked: a boxer's ordinary week 3; a fight week +2; a professional's camp 2 to 3, plus 1 to 2 sparring evenings; a trial fighter 1; film takes a whole Coach
  evening (2 pad places); a talk takes 1 of yours (section 3.8). A quiet week asks 10, a busy one 13. A fourth and fifth pad place for one boxer still pay, at
  0.7 and 0.5. Only a LOYAL boxer (loyalty 70 or more, v4.1) with 6 or more bouts can HOLD PADS: one extra pad place at 0.7, the holder's own evening gone, loyalty +3 a
  week it is held (at most 4 weeks running count). The loyalty bar shows "Loyal: can hold pads". An evening with no pad place is a session alone (section 3.7 gives its rate by mood), unless the rota takes the evening.
- COACHED MORNINGS. You 4, Coach 2: 6. One coached morning covers ONE fighter in full; TWO fighters on the same session share it AUTOMATICALLY, at 0.8 each (counted as 2
  fighter-sessions covered; v4.1, not a choice). Alone trains at the mood rate (section 3.7). Every slot shows what THIS coach adds to THIS session (Coach is a pad and bag coach, weaker on Cardio
  work). A fighter with discipline under 45 skips 1 alone morning in 3 unless a team-mate trains in the room.
- GYM SPONSORSHIPS. A sponsorship is a 4-week block: $1,000, six mornings a week, no job rota. A professional cannot hold one: the purse is the pay. Sponsorship given: loyalty +5.
  At the block's end (NEW) the Monday card asks: RENEW ($1,000 more, loyalty +2), PASS IT ON (to another fighter, loyalty +5 to them, nothing lost by the
  holder) or LET IT END (nothing lost). Pulled before its end: loyalty -8. A fighter with potential 80 or more and no sponsorship for 8 weeks asks for one: loyalty -3
  a week until seated or given a dated promise (kept +5, broken -12).
### 3.1a Coach's evenings: pads or a second class (NEW, the board's money lever)
- WHAT YOU DECIDE: for each of Coach's 3 evenings, the second hour is PADS (2 pad places) or a SECOND CLASS, the beginners' class (+$117 that night, and about one new member every 4 weeks it is taught; v4.1). Shown as
  three switches on the Coach's evenings counter, beside the pad places, with the week's cash change. Your own evening can also be taught as a class (+$117 and
  members the same way, your 2 pad places gone).
- WHAT IT CHANGES: cash against training, every week, on the same board. Two class nights pay $234 that week, bring about two new members every 4 weeks later, and leave 4 pad places for 10 to 13 asked.
- NUMBERS: ESTIMATE $117 = the code's $350 a week over three nights; real basis, pay-as-you-go beginners' classes at about GBP 6 for 15 to 18 people (GBP x 1.25).
  MONEYFOUR2 tests both the night's $117 and the members it brings later (v4.1): one gym sponsorship plus one class night a week should leave the bank about level (the v3 estimate is one sponsorship = -$100 a week).
- LINKS: the sponsorship (cash out) against the class (cash in); every class night takes 2 pad places, so somebody goes short and loyalty pays; a twist can take an
  evening; "Coach deals it" picks pads unless the bank has under 8 weeks of runway, then one class night.
### 3.2 What is dealt: each fighter's pulls
Coach reads each fighter in order: THE SCALE (over, with a bout inside 14 days), FIGHT (the last 7 days), REST (tiredness forecast 70 or more, or hurt), A HABIT the
next opponent punishes (only your own pad places train it out: 6 pad places). Then the pulls side by side, each with a number, a date, whose voice it is (Coach's
star, the fighter's ask, the ladder) and its SIZE (NEW):
- WEAK SPOT: the lowest of the 14 abilities on the fighter page, when it is 3 or more under the fighter's level. From the third bout the other corner goes for it:
  in every exchange that reads that ability the opponent gains +0.25 for each point under, from round 2. "Weak spot: Defence. Opponents gain +1.6 an exchange
  until Defence is 54". A plan line can cover it and uses one of the four lines brought. The level weighs each ability by what it is worth in a bout, so the
  lowest number is not always the one to train.
- WEAPON: the number the next perk hangs on ("Fast hands at Speed 70: about 4 weeks").
- GOAL: what the fighter asked for (met: mood +10; missed: -20; code). A bout goal is met when the bout is FOUGHT.
- AHEAD: the next name up the ladder and the answers owned ("Siobhan: answers 1 of 3").
A pull asks 2 slots a week: a weak spot, a weapon or a goal asks 2 coached mornings on its session; Ahead asks 2 pad places. A sponsored fighter carries two pulls, a
day-job fighter one. THE SIZE ON EVERY CHIP (NEW): each pull prints what it is worth, in wins in 100 on the next booked bout, in weeks sooner to the season
target, in dollars or in loyalty, ALWAYS AS A RANGE, never as one exact number (v4.1: "+3 to +5 in 100 on 31 Jan"). Each kind keeps its own colour and
is never added to another kind (wins in 100, weeks to the target, dollars, loyalty). The sizes come only from the probes (section 8); a number the probes have not measured is not shown, never
guessed on screen. Coach has a taste (the weapon and the pads, 2 times in 3) and deals toward each fighter's season target. Three one-click deals: by hand, KEEP
MY CHANGES (your edits from last week stay, the new rota and twist come in; replaces "Same as last week"), COACH DEALS IT (its line on the button: "Coach's deal:
2 to 3 in 100 below yours this week").

### 3.3 The rota that moves (each fighter's row names this week and the next; a sponsorship removes it)
- SHIFTS: earlies and lates alternate by the week. Earlies: weekday mornings at work. Lates: mornings free, no weekday evenings, so no Coach pads.
- COLLEGE: term (Tuesday and Thursday mornings free), an exam fortnight twice a year (two sessions a week in all), holidays (every morning free).
- OFFICE: weekday mornings at work. CAFE (Ana): works every other Saturday. (Overtime left the rota: it is a twist card now, section 3.4.)
- A professional under the top 10 keeps the job (in the code a professional trains full time on no pay: a change). Ranked in the top 10: full time.
- On the board the job cells are narrow, one line and dim: they are not choices.

### 3.4 One club twist a week (replaces the personal twist cards in the code: WeekTwist, TwistCard, TwistSwing)
Drawn on Monday from a deck of 12, never the same twice running, 1 week in 4 quiet (the code's own rules, kept). It hits something shared and has 2 or 3 answers,
each with a price on named fighters, cash, loyalty or a favour. Start week waits for it; unanswered, Coach picks. The deck: "Coach is off Wednesday: 2 pad places
gone (both miss it / pay for cover $80 / the senior holds both)"; "COACH CAN STAY LATE THURSDAY: +2 pad places for $60, or no" (replaces Coach's three extra
evenings a quarter); "OVERTIME: the office wants a fighter on Saturday (take it: the Saturday is lost / ask them to train: loyalty -2, it costs them money)"
(replaces the overtime row); "A visiting professional gives one sparring session: who gets it"; "The boiler is out Thursday: no mornings"; "Another coach asks
you for a kilo" (the kilo rule, 3.5); "The local paper wants a picture: +2 members, 1 pad place"; "A club needs a boxer on Saturday: +2 favours, no fight week"
(the 4-day call); "A sponsor's photo day: $150, one evening of the professional's camp"; "The hall floods: Monday's class is off, -$117"; "A member's son asks for
pads: a pad place, +1 member"; "A quiet week".

### 3.5 Favours, the second currency
0 to 3 held with each of the three clubs that run shows (Repton, West Ham, Fitzroy Lodge), drawn as dots beside the club's name.
- EARN 1: box on their show; take a late replacement on their card; a sparring trip there (one of your 2 pad places that week); give a kilo (below). EARN 2: send
  a boxer on a 4-day call to fill their card.
- LOSE 1: miss the weight on their show; pull your boxer out. Going home because THEIR boxer pulled out costs and earns nothing.
- SPEND 1: ask a kilo (below); re-deal a bout sheet now; ask for a named opponent on their next show; move a bout by a week.
- ONE KILO RULE, BOTH WAYS (replaces v3's two): when a boxer is over the 1.0 kg gap on the day, that corner may ask for one kilo more. The corner that asks
  spends 1 favour with the other club; the corner that gives earns 1. The heavier boxer then has +2 tank for each 0.5 kg over the agreed weight (WEIGHTGAP1).
- CANNOT BUY: a win, a judge, a rank, training, a pad place, a sponsorship. Favours bend terms, never bouts.

### 3.6 The squad changes, sparring and Ana
TRIAL MAT: every 4 weeks one prospect trains with the club for 2 weeks and takes 1 pad place a week from the four. WATCH sits on the trial card only (moved off
every morning slot): give 2 of your coached mornings over the fortnight and the ranges close to true numbers, or do not. At the end: Sign (a fifth fighter needs
the second club coach, $280 a week, or bigger premises, or one of the four leaves) or Pass.
SPARRING: the pair is picked on Club week (NEW: a pair picker on each sparring evening), any pair, by weight (a bout is never mixed): under 5 kg apart, full for both;
5 to 10 kg, the lighter gets full work and the heavier half; over 10 kg, the lighter takes +10 tiredness.
SPARRING SETTING (NEW), one per sparring evening, both boxers pay it:
| Setting | Gain from the evening | Tiredness | A cut or knock that takes the boxer off a show inside 10 days |
|---|---|---|---|
| HARD | x1.3 | +12 | 4 in 100 |
| TECHNICAL | x1.0 | +6 | 1 in 100 |
| BODY ONLY | body punches and Cardio only, x0.8 | +8 | none |
ESTIMATE; real basis: how hard to spar is the main weekly call in a club; body-only sparring is a common club drill. The bill's "sparring cut" line reads from it;
the shape of the week (section 4) no longer carries its own cut. SPARSET1 must show Hard worth at least 1.5 wins in 100 to a boxer 3+ weeks out, or Hard goes.
ANA (the grappler; every number below is in the code unless marked):
- CLASSES: on the cafe job 3 a week (NoGi.CLASSES_PER_WEEK); on a sponsorship 5 (NEW; drills 5/3 as fast, the stripe date printed for both); each class over 3 adds 6
  tiredness. Classes are free for Ana (the $34 is what the club pays the members' class coach, BjjSide.COACH_CLASS).
- MAT MORNING: Ana can give one boxer a week a coached Cardio morning at 0.8; it costs Ana one class.
- THE DIVISION AT AN OPEN (NEW on the board; promotion exists): enter at WHITE (Ana's chance a match about 55 in 100 today, NoGi.win_chance at 65% of the way to
  ready; gold +2 no-gi members, silver +1) or PROMOTE TO BLUE FIRST (early: Ana owes a quarter of the blue belt's mat time, BeltRoad.EARLY_DEBT, so about 35 in 100
  a match; +3 no-gi members at once, BjjSide.BLUE_MEMBERS; and teaching opens). Real basis: IBJJF belt divisions and the pressure not to "sandbag" at a lower belt.
- TEACHING (in the code from blue, BjjSide.can_teach): Ana teaches the beginners' class: +$68 a week (the two coach classes the club stops paying for,
  BjjSide.teach_saves) and, like a class night, about one new member every 4 weeks (v4.1; MONEYFOUR2 measures it), one
  class fewer for Ana. So the division choice is also a money choice. (A white belt teaching was asked by both critics; the code's
  rule, from blue, is kept: blue and purple belts assist with beginners at real academies.)
- THE STRIPE CALL (in the code: StripeCall, now / hold / early) now moves Ana's loyalty on the same scale as the boxers' (section 3.8).
- ENTER OR SKIP (v4.1): each open comes as a card with two answers, Enter or Skip.
- WHO CORNERS THE OPEN: you, or the mat coach for the day ($100), never Coach. The choice shows only when a boxer of yours boxes that day (v4.1);
  otherwise you corner. Ana's open shows on the Fights sheet tab like a boxer's bout (NEW).

### 3.7 Mood with teeth (CHANGED: mood now costs something in the week)
Mood stays the code's morale (0 to 100: Fired up 75+, Steady 50+, Flat 30+, Low) and stays moved only by what happens to the fighter: a win +8, a loss -12, a rest
week +4, a month with no bout -6, a bout booked +5, a goal met +10 or missed -20, an ask heard +5 or overruled -5, the corner's calls (all code). The prices of
your deals move LOYALTY, not mood (section 3.8), so each price has one home.
NEW, what mood does in the week (v4.1: alone rates 0.8 / 0.6 / 0.4, set 0.2 apart because 0.1 would not show in a season; MOODRATE1 still decides
whether they stay; ESTIMATE; real basis: Football Manager's morale and training, and how a flat boxer trains alone):
| Mood | A session alone (no coach, no pad place) | Booking | Fight night (code) |
|---|---|---|---|
| Fired up | 0.8 | as dealt | takes in 1.05 of the corner's word |
| Steady | 0.6 (today's rate for everyone) | as dealt | 1.0 |
| Flat | 0.4 | as dealt | 0.85 |
| Low | 0.4, and skips 1 alone session in 2 | passes the next sheet by itself (free, no favour) | 0.7, stops listening |
So a short week costs more when the fighter is down, and a loss echoes into the next week's training. For Ana, mood already moves the match chance (NoGi.win_chance).
### 3.8 Loyalty (NEW: the long cost of going short; the loyalty trait made live, not a new meter)
- WHAT IT IS: each fighter's LOYALTY 0 to 100, the trait already in the data and on the signing card ("Loyal: stays through a bad run"), now moved by your
  deals. Ana's loyalty already moves this way in the code (StripeCall; under 50 "other clubs start to call"). One word, already in the game; "Standing", the
  critic's word, is already the Fights page's column for booked or free. Bands: Loyal 70+, Settled 50+, Wavering 25+, Leaving under 25.
  WHAT LOYAL GIVES (v4.1, no new counter): only a Loyal fighter can hold pads (3.1), and a Loyal fighter takes one short week in four without losing
  loyalty. The bar reads "Loyal: can hold pads".
- WHAT MOVES IT (ESTIMATE): went short a week -3, -6 when it is the second week running or more (a Loyal fighter's one short week in four costs nothing, v4.1); a week dealt in full +1; a dated promise kept +5, broken -12; the
  sponsorship given +5, pulled early -8, renewed +2; holding pads +3 a week (4 weeks at most); a READY fighter's sheet passed by you -2; the season target set to their
  ambition +5, against it -5; the season target met +10, missed -5; the stripe call (Ana, code: now +3, hold -5); overtime refused -2.
- WHAT IT DOES: UNDER 50, a "WANTS A WORD" card on Club week. The talk takes 1 of YOUR pad places that week, except Tell it straight. Three answers: GIVE THE PAD PLACE BACK (that fighter
  is dealt first next week, loyalty +4), A DATED PROMISE (a pad place, a bout or the sponsorship by a named date: kept +5, broken -12), TELL IT STRAIGHT (v4.1:
  free, no pad place; the result is a roll on coachability, loyalty +4 or -4, written in the Coach's notes (CoachNotes); it cannot be used on that fighter
  again for 8 weeks; the screen never shows the coachability threshold). UNDER 25 after two talks, the fighter leaves the next Monday for Eastside ABC (the rival club already named in the news).
  AT TURNING PROFESSIONAL, a boxer under 50 signs with an outside manager: the club keeps the trainer's 10%, not 25% (code Roster.GYM_SHARE is manager 15% +
  trainer 10%). Real basis: the commonest way a club loses a good amateur is a boxer who feels second in line moving gyms; amateurs who turn professional often
  sign with a manager outside the club.
- PROMISES OPEN (v4.1): every dated promise (the talk's, the sponsorship's) sits on one list on Club week: who, what, by which date, until kept or broken.
- LINKS: every pad place dealt away, every class night and every sponsorship now has a price that lasts; the talk spends your own pad places (Tell it straight
  excepted); coachability (a trait)
  prices the plain answer; loyalty decides who the club keeps and what the professional pays the club. RPGLAYER1 (the bond, coaching style, the coach growing)
  builds on this number later; this map adds nothing more to it.
### 3.9 The season target (NEW: what every Monday is dealt toward)
- WHAT YOU DECIDE: one target per fighter, with its date, from week 5 (before that, the one each fighter's ambition names). Changed again after each championship
  or when a target is met or missed. Shown as THE SEASON strip on top of Club week.
| Fighter | Targets (pick one) | What it sets |
|---|---|---|
| Amateur | THE NATIONALS (code SeasonPath: 5 bouts and 3 months registered, age 19 to 40, entries close Sun 15 Mar, the regional semi-final and final a week apart, the nationals 3 weeks later, two pairs of back-to-back days); THE PRO OFFER (7 wins and a top-3 rank, or 9 wins); A YEAR TO GROW (two perks by the date) | NATIONALS: sheets until the entry date, then no sheets; the run sits on the board as fight weeks (+2 pad places each round's week), weigh-in at the class limit the day before (as today); a national final brings the pro offer at once. PRO OFFER: a sheet every Monday; Coach favours the Ahead pull and the name-above card. GROW: BUILDING 3 weeks in 4, one bout a month; Coach favours the weapon and the weak spot |
| Professional | RANKED (into the national table by the date: a 6-week camp and the step-up offer, v4.1); BUSY (3 bouts by the date: a 4-week Light camp that takes tune-ups, v4.1) | the camp's length and load and which offer Coach puts first; camp leave while the job stays (below) |
| Grappler | A MEDAL (gold or silver at an open by the date: stay white); BLUE BELT (promoted by the date: teaching, members) | the division at each open; the drill Coach picks |
- CAMP LEAVE (v4.1, only if the owner keeps the day job until the top 10, an open taste question in section 12): about $120 a week for the last 2
  camp weeks gives the professional the job's mornings back.
- WHAT IT CHANGES: the BUILDING dates, Coach's deal and Coach's preferred pull; loyalty +10 met, -5 missed; ambition matched +5, against -5. Ambitions map to
  targets: "A regional title within a year" = the nationals; "A winning record by the summer" = the pro offer; "A first win in front of a home crowd" = a year
  to grow (home bouts).
- REAL BASIS: coaches plan the year around championship entry dates; a boxer in a development year boxes less. Uses SeasonPath's rules, already built.
### 3.10 Fans (NEW: the boxer's own crowd, the bridge from amateur to professional)
- WHAT IT IS: each boxer's FANS, counted as people who buy a ticket. A HOME win +4, a home loss +1, an away bout 0 (v4.1: the +1 for an away win is dropped, noise beside +4 at home), a title +10 (ESTIMATE, sized
  to the debut's 100 tickets; the critic's +8 a home win would fill the debut from 5 home wins and make away free).
- WHERE IT GOES: the debut sells 20 (family) + the boxer's fans + a quarter ticket per club member + 10 a title (ProDebut.tickets_sold changes: the boxer's fans
  replace "2 per amateur win", the member share halves). On turning professional, fans carry into Matchmaking's fans, which sell every later bout's tickets (code:
  ticket money follows fans and closeness): the code's -5 to 12 scale becomes tens of people on screen (3 = 30 fans), so one word, one unit.
- WHAT YOU DECIDE: home or away on each sheet (home: the ticket cut, members and fans, never the best rank prize; away: the climb and favours, about $40 in
  travel, v4.1). Selling tickets is cut (v4.1): the fans and the HOME card carry the debut.
- REAL BASIS: UK small-hall professionals are paid from the tickets their own supporters buy; amateurs build that crowd at home shows.
- FOLLOW1 must show: an always-away amateur reaches the offer sooner but sells under 60 at the debut; an always-home one sells but reaches it later; a mix does both.

## 4. The fight week inside the club week
An amateur bout has no camp. Its jobs are paid in the same pad places and mornings as everything else.
- THE SHEET. A READY boxer gets a sheet of up to three bouts every Monday, all for the Saturday 12 days out (a bout 5 days out only comes as a call). Three kinds,
  one of each: HOME (a local show near the club, v4.1: the $450 ticket cut, +8 members and +4 fans a win; never the best rank prize); A NAME ABOVE (away: a win takes that
  rank, at most 3 up); THE UNKNOWN (a file of 1 of 4: the win chance band is 28 points wide, not 12, and the first look opens that file to 2 of 4 for the
  season). No card may beat another on all of cash, rank, win chance, fans and file (it is redrawn). Away pays nothing and costs about $40 in travel, printed on the card (v4.1); it earns 1 favour with the host and +3
  members a win; the top three names box on their own show 7 times in 10: the climb is away. Every win counts toward the 9-win offer, except over a name 6 or
  more points weaker (half the gate too). A loss to a name below drops 2 ranks. Each card prints the stoppage risk
  ("stopped 3 in 100: 30 days out"), the fans ("+4 fans a win") and what is given ("+0.7 kg, +3 bouts"). Ana's open shows on the same tab (3.6).
- HOME ON OUR OWN SHOW (v4.1). When the club books its own show (Book the show on Club > Money, ClubShow.gd, already in the game), every READY boxer
  gets a HOME card for that Saturday on the sheet. Each of your boxers on the card adds tickets (ClubShow.PER_HOME_BOXER, 25 each, code), and their fans
  add to the ticket count (new). The ordinary HOME card means a local show near the club. The old "+$300 for two on one card" rule is deleted.
- READY, BUILDING OR REST (REST is NEW). READY: a sheet every Monday. A pass keeps one name for 7 days, costs loyalty -2 (ready and held back), and a second pass
  running costs 1 favour with the club that stays. BUILDING to a date: no sheets, training kept at 1.1. REST, 2 weeks after a bout: no sheets, no sparring, Light
  mornings, mood +4 a week (code rest_week), the tank full at the next sheet's bell. Real basis: clubs send a boxer home after a hard night. The season target
  sets the default (the nationals: Building to the entry date).
- THE SCALE. A club bout is made at the weight both boxers walk at, with a gap of 1.0 kg allowed. The answers appear only over that gap. Weigh-in: 4 pm on fight
  day. EAT LESS: tank -1 for each 0.1 kg (-2 past 0.5 kg). TRAIN IT OFF: each 0.25 kg is one session with no gain and +5 tiredness (free on rested legs, dear
  over 50). ASK A KILO: the one kilo rule (3.5). The club scale reads true (v3's HOLD, a dice roll inside 0.2 kg, is cut: Eat less covers it). A miss is no bout,
  $300 and a favour. Cuts to the class limit stay for professionals and the nationals.
- COACH'S EVENINGS BEFORE THE BOUT. Prices in pad places: walk two plan lines 1; finish a nearly-learnt punch 1 for each 4.5 mastery short; southpaw rounds 1
  (against a southpaw: the edge the code's "lefty week" gives today); film 2 (the whole evening, one a week for the club). Lines and punches count up to 4 days
  before the bout; the last three days only keep the boxer sharp (1 pad place). The strip shows every pad place before the bout as a face and names who goes
  on the bag. Film asks one of three: the best punch, a habit, or THEIR WEEK. It can be spent on a name before the yes (choose better) or after (prepare better).
- THE PLAN IS A HAND. A plan holds as many lines as the coach can carry (6 with Coach; 4 to 9 in the code); a bout takes 4, each walked for it. A line left
  behind does not come out in round 1 and plays at 80% after. With no coach the plan holds 4. A corner that shared a show card with you has seen your winning
  line: it lands half as often, for two bouts. THE OTHER CORNER HAS A WEEK: their Legs show on the card (boxed 7 days ago -8, 14 days ago -4, back from a
  stoppage -5 and a slow start, fresh 0), or "?" unless one of yours shared a card with them.
- THE LEGS. One bar called LEGS (0 to 100): the tank at the first bell. Tiredness and the tank are never shown as two numbers (v4.1): tiredness
  shows only as the Legs it costs. Tiredness over 50 costs 1 a point; eating weight off as above; your own last bout costs the same as
  theirs (7 days ago -8, 14 days ago -4); they ADD, at most 25 off. Three shapes: REST UP (tank full; SLOW START: round 1 at -1.0 points; mood +4; a fifth of the
  week's training kept); TICK OVER (about 8 off; sharp if 1 pad place is spent in the last five days; half kept); TRAIN THROUGH (about 12 off; sharp; all kept;
  its sparring cut is the sparring setting's, 3.6).
- ON THE NIGHT. The scale first, both weights. Then your corner, or COACH'S CORNER: the plan call and the water; no habit fix, no set-up, no talk.
- THE BILL'S ONE NUMBER (CHANGED). "Coach runs it" fills Coach's standard week in one click. The bill no longer prints two overlapping win chances: it prints
  ONE number, YOUR WEEK AGAINST COACH'S (a range, v4.1: "+2 to +4 in 100"), with its parts as ranges (film +1 to +2, lines +0.5 to +1.5, shape
  +0.5 to +1), and ranks the three biggest levers. Definition:
  Coach's deal run on the same Monday state against the deal played, as the bout's win chance (BoutRead). The same number, summed over the month with money and
  loyalty in words, replaces "Coach's score: 3 right, 1 wrong" on the Monday review (cut: it was never defined).
- THE BILL AFTER THE CUT. Kept: the scale, film, the four lines, the shape of the week, the corner, Coach runs it. Kept only if TANKPRICE1 measures each at 1.5 wins
  in 100 or more: finish a punch, southpaw rounds. Gone: Hold (into Eat less), the second kilo rule (one rule), "the other boxer is over" as its own row (it is
  the kilo rule).
- PULL-OUTS (15 in 100). Take the replacement (in the code: a tougher name, twice the reputation on a win), send another READY boxer, or go home.
- AFTER. A bout leaves tiredness (measured: 45 on a full tank, more when the tank was low, +10 after a stoppage loss, at most 95). The Monday after: READY, BUILDING
  or REST. Stopped: 30 days out; again inside 90 days: 90.

HOW A PROFESSIONAL DIFFERS (shown side by side wherever both appear):
| | Amateur: fight week | Professional: camp |
|---|---|---|
| Notice and who offers | 12 days; the bout sheet, up to three | 6 weeks; the promoter's three offers (7 days to answer) or ask for a name; scout $250 |
| The first night | any show | the debut: 4 weeks after signing, 4 rounds, paid from tickets (family, fans, a quarter of the members; under 60 sold pays nothing) |
| Preparation | one week on the club board | camp: focus, Light / Standard / Hard, partner, film; peak and taper weeks; the sparring setting each sparring evening; BUSY target: a 4-week Light camp that takes tune-ups, RANKED: a 6-week camp and the step-up; camp leave while the job stays (v4.1) |
| Takes from the club | 2 to 4 pad places in one week | 2 to 3 pad places and 1 to 2 sparring evenings a week for 6 weeks, a club mate's evening each |
| Weight | walking weight, 1.0 kg gap, 4 pm on the day | the class limit, the day before |
| Rounds | 3 | 4, then 6 ranked, 8 in the top 10, 10 for a title |
| Money | $450 ticket cut at home; away about $40 in travel (v4.1) | purse $1,500 unranked (+$400 a rank from No. 20 up; +$150 a rank for a name above; ticket money from fans); the club keeps 25% (10% if the boxer signed with an outside manager; 20% in the top 10, 17% with a belt) and pays the camp bill, 6% of the purse, and the cutman, $150, if hired |
| Fans | +4 a home win, none away (v4.1) | carried over; every bout's tickets follow them (code) |
| Ladder and sponsorship | the regional ladder; may hold a gym sponsorship | the national ladder (about 20 ranked); no sponsorship |
| Season target | the nationals, the pro offer, a year to grow | ranked (a 6-week camp, the step-up), or busy (a 4-week Light camp, tune-ups) |
| How often; stopped | about 18 a season allowed (England Boxing), about 9 expected (v4.1); 30 days out, then 90 | every 6, 8 or 12 weeks by how hard the last night was; stopped: 8 weeks more |

## 5. Every decision
B = before the week or the bout, D = during, A = after. The last column is THE DESIGNER'S TEST: the case each option should win, written for the probes and the
critics. IT IS NEVER PRINTED on a screen, a hover or the guide (the game would play itself); the screen shows prices, sizes and forecasts only.
| When | The decision | Options: what each costs and gives | Designer's test: each option is right when (never on screen) |
|---|---|---|---|
| B, Create | Which professional; which two amateurs | Lucy: potential 84, 34 fans, full sparring with Kira and Danny. Josh: southpaw, full sparring with Tess, discipline 80, 22 fans. Amateurs: record, job, weight, fans, ambition | Lucy: the amateurs picked are light. Josh: Tess is picked, or a southpaw leads a picked weight. Amateurs: one near the offer (Tess) with one far from potential (Kira 86, Samira 82) |
| B, week 5 then after each championship | Each fighter's season target | Amateur: the nationals, the pro offer, a year to grow. Professional: ranked (a 6-week camp, the step-up) or busy (a 4-week Light camp, tune-ups). Grappler: a medal or blue belt. Matching the ambition: loyalty +5; against it -5; met +10, missed -5 | Nationals: 5 bouts reachable before 15 Mar and the class limit is near. Pro offer: inside 2 wins of a step. Grow: 8 or more under potential, aged under 20. Ranked: fresh, winning. Busy: the bank is short. Medal: Ana far from blue. Blue: the bank needs the teaching |
| B, Monday | How to deal the board | By hand. Keep my changes: last week's edits, this week's rota. Coach deals it: Coach's taste, toward each target; its line on the button gives Coach's deal against yours | By hand: a fight week, a camp peak or a twist. Keep: nothing big changed. Coach: Coach's deal is within 1 in 100 of yours |
| B, Monday | Coach's evenings (NEW) | Each of 3: pads (2 pad places) or a second class (+$117 that night, about one new member every 4 weeks later, v4.1). Your own evening: pads (2) or a class (the same) | Class: under 8 weeks of runway, or asked is 9 or under. Pads: a fight week or a camp peak this week |
| B, Monday | Who holds the gym sponsorship | An amateur: $1,000 for 4 weeks, 6 mornings, no rota, loyalty +5. Ana: $1,000, 5 classes a week. Nobody | Amateur: 10 or more under potential with two bouts inside the block. Ana: a stripe inside the block and no open in its last week. Nobody: under 2 months of costs in the bank |
| B, block end (NEW) | The sponsorship's end | Renew: $1,000, loyalty +2. Pass it on: to another, loyalty +5 to them. Let it end: nothing lost | Renew: the holder's target date is inside the next block. Pass: another fighter's loyalty is under 50 or their target is nearer. End: the bank |
| B, Monday | The talent asks for a sponsorship | Sponsorship now. A dated promise: kept +5, broken -12. Neither: loyalty -3 a week | Sponsorship: the bank holds 3 months. Promise: the sponsorship frees inside 4 weeks. Neither: loyalty is 70 or more and a bout is 2 weeks off |
| B, Monday | Each coached morning (6) | One fighter: 1.0 against the mood rate alone. Two fighters on one session share it automatically, 0.8 each (v4.1: not a choice) | One: the fastest-growing number, or a Flat or Low fighter |
| B, Monday | Each fighter's pull | Weak spot, weapon, goal, ahead: each with its size as a range (v4.1; sell tickets cut) | Weak spot: third bout or later, a bout inside 3 weeks, and its size is over the weapon's. Weapon: the perk is under 4 weeks away. Goal: under 3 weeks left. Ahead: under 2 of 3 answers owned |
| B, Monday | A plan line to cover the weak spot | Cover: the gain is gone while that line is brought; one of the four lines is spent. Train it: 2 mornings a week | Cover: the bout is inside 2 weeks. Train: 3 weeks or more to the bout |
| B, Monday | Each pad place (8 for 10 to 13 asked) | Ordinary drill: mastery and a date. A fourth or fifth for one boxer: 0.7, 0.5. A habit: your pad places only, 6 in all. A fight-week job (section 4) | Ordinary: a move within 2 pad places of Usable or Sharp. Fourth: a punch needed before a booked bout. Habit: the next opponent punishes it. Fight week: the bill shows a line or sharpness missing |
| B, Monday | A Loyal senior holds pads (loyalty 70 or more, v4.1) | Yes: +1 pad place at 0.7, the holder's evening gone, loyalty +3 a week (4 weeks at most). No | Yes: a camp and a fight week in the same week. No: the holder's own fight week |
| B, Monday | The sparring pair and its setting (pair picker NEW, setting NEW) | Pair by weight: full / full and half / +10 tiredness. Hard x1.3, +12, cut 4 in 100. Technical x1.0, +6, 1 in 100. Body only: body and Cardio x0.8, +8, no cut. A trip to another club: one of your 2 pad places, +1 favour | Hard: both are 3 weeks or more from a bout. Technical: one boxes inside 3 weeks. Body only: one boxes inside 10 days, or has a cut healing. Trip: no fair pair, a southpaw is needed, or favours are at 0 |
| B, Monday | The club twist | 2 or 3 priced answers (the deck, 3.4) | Each card's answers are tested by ROTATWIST1: no answer best in more than 2 weeks of 3 |
| B, Monday (NEW) | A fighter wants a word (loyalty under 50) | The talk takes 1 of your pad places, except Tell it straight. Give the pad place back: dealt first next week, +4. A dated promise: kept +5, broken -12, kept on PROMISES OPEN. Tell it straight (v4.1): free, a roll on coachability, +4 or -4, written in the Coach's notes, not again for that fighter for 8 weeks; the threshold is never shown | Back: the fighter's target date is near. Promise: a free pad place or sponsorship is coming inside 4 weeks. Straight: coachability 60 or more |
| B, every 4 weeks | The trial fighter | Watch: 2 of your coached mornings over the fortnight, true numbers. Do not watch: ranges stay wide. Sign: second coach $280 a week, bigger premises, or one leaves. Pass | Watch: a weight the club lacks. No watch: two bouts that fortnight. Sign: potential above the lowest of the four and the bank over 3 months. Pass: otherwise |
| B, Monday | Ana's classes; the mat morning; teaching (from blue) | 3 classes; 5 on a sponsorship; 2 when a mat morning is given (a boxer's Cardio at 0.8). Teaching: +$68 a week and about one new member every 4 weeks (v4.1), one class fewer | 5: a stripe inside 4 weeks and no open that week. 3: the week of an open. Mat morning: a Cardio pull with no coached morning left. Teach: the bank is short and no open inside 2 weeks |
| B, Ana's open (NEW on the board) | Enter or Skip (v4.1); the division; who corners (shown only when a boxer of yours boxes that day, v4.1) | Skip: no open this time. White: about 55 in 100 a match, gold +2 members. Promote to blue first: about 35 in 100, +3 members at once, teaching opens, a quarter of the blue mat time owed. Corner: you (no boxing corner that Saturday) or the mat coach, $100 | Skip: Ana's chance is under 35 in 100 in both divisions. White: the target is a medal. Blue: the target is blue belt, or the bank needs the teaching. You: no boxer of yours boxes that day |
| B, sheet | Which bout | Home (a local show near the club; on the Saturday of our own show every READY boxer's home card is on it, v4.1): $450, +8 members, +4 fans, no climb. Name above, away: that rank (at most 3 up), +1 favour, about $40 travel, the lowest win chance. The unknown, away: a wide band, +1 favour, about $40 travel, the file opened. Pass: 7 days, loyalty -2 | Home: the bank is under 2 months, or the debut forecast is under 60. Name above: 7 wins and outside the top 3. Unknown: wins are the road, or both known names are under 40 in 100. Pass: tiredness over 50 on Monday |
| B, sheet | Spend a favour on the sheet | Re-deal now. A named opponent on that club's next show. Move the bout a week | Re-deal: all three are under 35 in 100. Name: one win over that name brings the offer. Move: a team-mate's camp peaks that week |
| A, Monday after a bout | Ready, building or rest | READY: a sheet every Monday. BUILDING to a date: no sheets, training at 1.1. REST 2 weeks: tank full, mood +4 a week, Light | Ready: tiredness under 50 and inside 2 wins of a step. Building: within 2 points of a perk, or the nationals' entry. Rest: tiredness 60 or more, or a stoppage either way |
| B, bill | Who corners (two halls on one night) | You: the full corner. Coach: the plan call and the water only | You: the closer bout or the lower coachability. Coach: the bout with the higher win chance |
| B, bill | The scale (only over the 1.0 kg gap) | Eat less: tank -1 per 0.1 kg. Train it off: a session with no gain and +5 tiredness per 0.25 kg. Ask a kilo: 1 favour | Eat: tiredness will be over 50 at the bell. Train: resting up, tiredness under 40. Ask: over 0.5 kg with a favour held |
| B, bill | The film evening | Which night (who goes on the bag), which name, which question: best punch, a habit, their week | Best punch: a line can still be walked. Habit: Coach is in the corner. Their week: the shape is not set. Before the yes: two cards within 5 in 100 |
| B, bill | Which four lines; finish a punch; southpaw rounds | Walk two owned lines: 1 pad place. Finish a punch: 1 per 4.5 mastery short. Southpaw rounds: 1 | Walk: the plan already beats the opponent's game. Finish: within the pad places left and the file says it lands. Southpaw: the name is a southpaw |
| B, bill | The shape of the week | Rest up, tick over, train through | Rest: the opponent fades late, or the last bout was 7 days ago. Tick over: a slow starter opposite. Train through: 10 or more under potential and an opponent 6 or more weaker |
| B, bill | Coach runs it | One click: Coach's standard week; the bill's one number shows what yours adds | Coach: the number is under 1 in 100 |
| B, pull-out | The replacement | Take: tougher, twice the reputation on a win. Send another READY boxer. Go home: half the gate at home, mood -3 | Take: the win chance stays over 40 in 100. Send: a team-mate is inside the gap. Go home: under 30 in 100, or hurt |
| B, the day, over the gap | Their corner asks you for a kilo | Give it: +1 favour, their boxer +2 tank per 0.5 kg. Refuse: the bout stands at the gap or is called off by them | Give: your win chance stays over 45 in 100 |
| B, professional | Which offer; the scout | Tune-up, Step up, Payday, Ask a name, Scout $250 | Tune-up: after a loss, or the target is busy. Step up: fresh, the target is ranked. Payday: the bank is under 2 months. Scout: two offers look alike |
| B, professional | The camp's length and load | BUSY target: a 4-week Light camp that takes tune-ups. RANKED target: a 6-week camp and the step-up, at Light, Standard or Hard: more gain, more tiredness, more of the club's evenings (v4.1) | Light: an amateur fight week falls in its peak fortnight, or the target is busy. Hard: no amateur bout in the 6 weeks |
| B, professional, the last 2 camp weeks (v4.1, only while the job stays) | Camp leave | About $120 a week: the job's mornings come back for the last 2 camp weeks. Or keep the job | Leave: a step-up or a ranked bout and the bank holds 2 months. Keep the job: a tune-up |
| B, professional | The sparring partner | A club mate: free, takes that fighter's evening. Outside: $160 for 4 visits | Club mate: the bank is under 2 months and nobody is in a fight week. Outside: an amateur is in a fight week |
| D, the bout | Corner calls, the minute, the cutman | As in the game today | Unchanged by this map |
| A, the Why | Next week from the result | "Walk this line next week", "Train X", "Give Samira the pad place back", "Rest 2 weeks" | Walk: the line came up and lost. Train: a weak spot was found. Give back: a team-mate went short for this bout. Rest: tiredness 60 or more |
| A, the offer | Turn professional or stay amateur | Turn: $1,105, the sponsorship stops, the debut in 4 weeks; under loyalty 50 the club keeps 10%, not 25%. Stay: the nationals stay open; first no, back after 2 more wins at 90%; second, only at No. 1; third, never | Turn: the bank holds 2 months after the fee and the debut forecast is 60 or more. Stay: the nationals are inside 10 weeks and it is the first no |
Removed in v4.1: Sell tickets; the choice of two fighters on one coached morning (now automatic).
Removed from v3's table: overtime (now a twist card), Coach's 3 extra evenings (a twist answer), watch on every morning (on the trial card), Hold on the scale, the
second kilo row, the one left without a bout (now the talk card and loyalty).

## 6. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Create, step 2 | one professional of two, two amateurs of four, Ana fixed; lines between the picks: full spar, half spar, who can hold pads; job, free mornings, sponsorship line, fans, ambition | CreateScreen, ClubStart, Data.lucy, Data.PROSPECTS, Roster.sign_fighter, Recruit.ambition; new data: Lucy's and Josh's rows as professionals with fans |
| The guide, weeks 1 to 5 | the five steps of section 2; the road strip with the club's own two people and their fans; the reveal order | GuideLight, GuideLines, FirstWeekStrip, FirstWeek, FirstHour, NextStep.STEPS, Roster.pro_ready, ProDebut; new Reveal table |
| Fighters > Club week | THE SEASON strip (each target and date, Enter the nationals when eligible); counters in one unit (fighter-sessions: asked, covered, short; v4.1): pad places, coached mornings (shared automatically), Coach's evenings (pads or class with the week's cash), gym sponsorship (with the block-end card), favours, trial mat; four rows (badge, mood word, loyalty bar, sponsorship or job, the diet cell Hold or Cut (v4.1), pulls with sizes as ranges, seven days with the sparring pair and setting, what the week gives); the talk card; PROMISES OPEN (v4.1); the twist; the biggest levers and your deal against Coach's; three deal buttons; Start week | new: ClubWeek screen; ClubDeal rule (shared pad places, mornings, pulls, Coach's evenings); WeakSpot; JobRota; ClubTwist (replaces WeekTwist, TwistCard, TwistSwing); Favours; TrialMat; Loyalty; SeasonTarget; SparSet; LeverSize (the probes' tables); reads WeekPlan (the diet cell), PadWeek, CoachAreas, TrainRead, WeekPhase, GymSpend, Attrs, FighterProfile.mood, DuesLevers.CLASS_WEEKLY, SeasonPath, BjjSide, CoachNotes (Tell it straight) |
| Fighters > Find a fighter, the trial | the prospect, the ranges, Watch (2 of your mornings), sign or pass, what a fifth fighter needs | RecruitPanel, Recruit, Trial, Roster.invite / trial_read / sign_prospect / pass_on, GymSpend.place_blocked, new TrialMat |
| Home | one line a fighter: the open pick with its size, days to the bout, "wants a word" as a need; the call with its answer-by day; the sponsorship's end | Home, HomeRows, HomeNeeds, Needs, Loyalty |
| Fighters cards | badge PROFESSIONAL / AMATEUR / GRAPPLER; loyalty word; sponsorship block end or the job's week; corner flag "Fight week" (amateur), "Set camp" (professional), "Wants a word" | Fighters, RosterCards, FighterCard, RosterFlag, CoachCheck, Loyalty |
| Fighter page, Overview | the season target with its date; the pulls with sizes as ranges and buttons; the weak spot's cost; the Cardio group; mood with what it does alone; loyalty with its last three moves ("Loyal: can hold pads"); fans and the debut forecast; the road strip | FighterPage, DarkOverview, AttrBoard, Attrs, Duels, TrainRead, PerkRoad, NextStep, Loyalty, Fans, SeasonTarget, ProDebut |
| Fighter page, Training | that fighter's own slots at the mood rate; shared slots (coach, pad place, sparring and its setting) locked with "change on Club week" | WeekBoard, WeekEditors, WeekDay, WeekCards, SparSet |
| Fighter page, Fight prep | amateur: the fight-week bill with the one number; professional: the camp, 4 weeks Light on the BUSY target or 6 on RANKED, with the sparring setting and camp leave while the job stays (v4.1) | FightPrep, new FightWeek rule, LeverSize; Camp, CampCard, PeakCamp, CampForecast, SparSet, SeasonTarget, GymSpend (camp leave) |
| Grappler page | classes 3 or 5, the drills with dates, the mat morning, the division at the next open with both chances, teaching (from blue) with its $68 and the members it brings, the stripe call with its loyalty, Enter or Skip on the next open, who corners (only when a boxer of yours boxes that day) | GrapplerPage, Grapplers, NoGi.win_chance, BeltRoad.EARLY_DEBT, BjjSide.can_teach / teach_saves / BLUE_MEMBERS, BjjTree, BjjOpen, StripeCall, Loyalty |
| Fights (amateur) | the bout sheet: three cards (win chance, rank, pay or about $40 travel away, fans, stoppage risk, file, Legs, kilos and bouts given); the HOME cards on our own show's Saturday (v4.1); favour dots; Ready / Building / Rest; Ana's open as a card with Enter or Skip; the compare view; the names at the weight with "ask for this name: 1 favour" | Fights, OfferCard, BoutCompare, Bouts, Region, RankLine, OppFile, AmateurBooking, InjuryRoll; new: BoutSheet rule, Favours, Fans; ClubShow (HOME on our own show) |
| Fights (professional) | the promoter's three offers and the ask, beside the amateur sheets, labelled; tickets from fans | ProFights, ProLadder, Matchmaking.pay_of / fans, StarDeal, Fans |
| Bout page: the bill | the scale (eat less, train it off, a kilo), Coach's evenings before the bout, the Legs, bring 4 of 6, both Legs bars at the first bell (one bar each, v4.1), ONE number as a range (your week against Coach's) with its parts and the three biggest levers, Take / Coach runs it / Pass | BoutPage, new FightWeek rule, LeverSize, BoutRules, BoutRead, PadWeek, PlanBoard, PlanLines, TaleOfTape |
| Tape room | the name, the one question and its answer; "their week"; a stale mark | TapeRoom, OppFile, TapeClips |
| Playbook, Game plan | a tick "bring this line", an eye on a line a corner has seen, "2 pad places short" | Playbook, GamePlan, GamePlanRows, PlanBoard, PlanLines, MoveMastery |
| Club > People | Coach's card: the week's evenings as pads or class, the pad places as faces; the second coach as "opens a fifth fighter"; Ana as the beginners' teacher from blue | Gym, StaffCard, StaffRoles, CoachAreas, ClubDeal, BjjSide |
| Club > Money | class nights and what they brought (cash that night, members later); sponsorships as 4-week blocks and what each brought; the ticket cut only at home, away travel; our own show's HOME cards; Ana's teaching; the professional's purse, the club's 25% (or 10%), the camp bill and camp leave | Money, MoneyPanels, GymBills, GymSpend.pro_camp, CashForecast, StarDeal, DuesLevers, BjjSide, ClubShow, Membership |
| World > Rankings | the regional ladder (new rule) and the national ladder, the club's fighters lit; favour dots on each club | World, WorldLadder, WorldLadderRules, Region, RankLine, ProLadder |
| World > Championships | the nationals: entry, the run as fight weeks, the season strip's date | NationalsView, Champs, ChampDraw, SeasonPath, SeasonTarget |
| Top bar and Continue | flags FIGHT WEEK, SET CAMP (professional only), PRO OFFER, WANTS A WORD; stops for a pull-out, a 4-day call, the scale over the gap, an unanswered twist, a sponsorship's end | Shell, Needs, Clock |
| Fight night | the scale as the first step with both weights and the kilo; the corner picked | FightNight, WeighIn, Bouts.weigh, BoutNight, CornerTrust, CornerJobs |
| Result and the Why | sizes ("Legs: 9 off the tank, round 3 lost"), the rank earned, fans earned, your week against Coach's, buttons for next week including Rest 2 weeks | FightWhy, WhyCard, AftermathTiles, Aftermath, RankLine, AfterFight, Fans, LeverSize |
| Week review (Monday) | who went short with its loyalty price and "give it back"; your deal against Coach's over the month (one number, money, loyalty); the trial fighter's read; targets met or at risk | WeekReview, ReviewReveal, WeekActual, WeekCause, Loyalty, SeasonTarget, LeverSize |
| Pro offer | the debut's ticket forecast from the boxer's fans, the $1,105, the share (25% or 10% by loyalty), what ends, the three answers to "no", the road strip | ProOffer, ProDebut, Roster.check_pro / pro_ready / decline_pro, Matchmaking.pay_of, Fans, Loyalty |
THE NEW MECHANICS, MENU BY MENU (the rule: each shows on every menu below in the .exe, and the golden-path test walks it):
| Mechanic | Menus | Wired to |
|---|---|---|
| Coach's evenings: pads or class | Club week counter; Club > People (Coach's card); Club > Money (class nights); Week review | ClubDeal, DuesLevers.CLASS_WEEKLY, GymBills, CashForecast, Membership (members later) |
| Mood with teeth | Club week rows (alone cells at the mood rate); Training; Overview; Fights (a Low fighter's own pass); fight night (code) | FighterProfile.mood, TrainingWeek (alone rate), BoutSheet, CornerTrust |
| Loyalty (Loyal: holds pads, one free short week in four; Tell it straight; promises open) | Club week rows, the talk card and PROMISES OPEN; Home need; Fighters card flag; Overview; Week review; Pro offer (the share); Grappler page (stripe call) | new Loyalty rule; FighterProfile personality.loyalty; StripeCall; Roster.GYM_SHARE; Region (Eastside ABC); CoachNotes (Tell it straight) |
| Season target (with the professional's BUSY or RANKED camp and camp leave) | Club week season strip; Overview; World > Championships; Week review; Create (ambition); Fight prep (the camp's length); Club > Money (camp leave) | new SeasonTarget rule; SeasonPath; Recruit.ambition; ClubDeal (Coach's deal); Camp; GymSpend.pro_camp |
| Fans | Create cards; the road strip; Fights sheet cards; Overview; Pro offer; the Why; professional Fights | new Fans rule; ProDebut.tickets_sold; Matchmaking fans; Membership; ClubShow (fans add to our own show's tickets) |
| Sparring setting and pair | Club week sparring cells and card; Training; Fight prep (camp and the bill's cut line) | new SparSet rule; SparNights; InjuryRoll |
| Sizes as ranges and one number | every pull chip; the bill; Coach deals it button; Week review; the Why | new LeverSize (probe tables); BoutRead; ClubDeal.coach_deal |
| Ana's division, Enter or Skip, and teaching | Club week (Ana's row); Grappler page; Fights (Ana's open card); Club > Money | NoGi.win_chance, BeltRoad, BjjSide, BjjOpen |
| Ready / Building / Rest | Fights sheet; Overview; the Why's button | BoutSheet, Aftermath |
| Sponsorship block end | Club week sponsorship counter; Home need; Club > Money | ClubDeal, GymSpend, Loyalty |
| HOME on our own show (v4.1) | Fights sheet (HOME cards for that Saturday); Club > Money (Book the show) | ClubShow, BoutSheet, Fans |
| Away travel (v4.1) | Fights sheet cards; Club > Money | BoutSheet, GymBills |

## 7. The numbers
MEASURED, ON FOUR AMATEUR BOXERS (Lucy, Kira, Samira, Tess; AMATEURPROBE1, MONEYFOUR1): 28 bouts a year today and 37 at a lead of 1 to 2 weeks, 41 wins in 100 in both;
the short lead brings 3 injuries a year against 2 and 2 missed weights against 0; gates $12,600 a year today. Sponsorships over a year: none, $31,000 in the bank (about
+$270 a week); one, 1.9 to 2.9 months of costs; two, 1.2 months of costs left at week 52; four, 8 clubs in 10 close. A bout leaves tiredness 45 on a full tank, more
when the tank was low, +10 after a stoppage loss, at most 95 (Aftermath.toll). A planned line fires 1 time in 2 at Usable, 3 in 4 at Sharp, always at Signature,
about 2.8 wins in 100 a step (S427, built and switched off). A good plan wins 59 in 100, none 45, a bad one 41; 5 points better wins 72 in 100.
ESTIMATE FOR THIS START (not measured): two amateurs at about 9 bouts each, half at home: about $4,200 a year in ticket cuts; six professional bouts at 25% of $1,500
plus ticket money, less a $90 camp bill each: $2,000 to $3,000. About $6,000 a year less than the measured four amateurs. So nobody seated and all pads is about +$150
a week; one sponsorship about -$100 a week; each class night +$117 and about one new member every 4 weeks; Ana teaching (from blue) +$68 and members the same way; each away bout about -$40
in travel (v4.1).
IN THE CODE TODAY, AND WHAT v4 DOES TO IT (v3's list stands; v4 adds): evening classes +$350 a week with a coach (DuesLevers.CLASS_WEEKLY: stays, the first hour);
the second hour as a class is new. Morale moves by the code's events and changes only the corner's uptake (CornerTrust) and Ana's match chance (NoGi): v4 adds the
alone rate by mood and the Low fighter's own pass. Loyalty is a trait in the data (Recruit "Loyal") that only Ana's stripe call moves today (StripeCall, under 50 a
news line): v4 moves it for all four and gives it the talk, the leaving rule and the outside manager. The debut sells 20 + half a ticket per member + 2 per amateur
win + 10 per title (ProDebut.tickets_sold): v4 replaces the per-win 2 with the boxer's fans and halves the member share. A professional's fans start at 0, range -5 to
12 (Matchmaking): v4 starts them from the amateur fans, tens on screen. Ana's teaching saves $68 a week from blue (BjjSide); early promotion owes a quarter of the
belt's mat time (BeltRoad.EARLY_DEBT): both kept, now on the board. The nationals' rules (SeasonPath: 5 bouts, 91 days, entries close day 70, regional then
national) are kept and become a season target. The trial's watch moves to the trial card. The scale's random 0.2 kg reading is not built (it was a v3 proposal).
DESIGN VALUES of this map (every price in sections 3 and 4 not listed as measured or in the code): first guesses for the probes below.

## 8. To be measured before the build (each a probe on the played bout, never on the harness's average; no screen is built before its table exists)
THE CUT RULE (both critics): any choice worth under 1.5 wins in 100 on a bout AND with no season effect (weeks to the target, bouts a season, a fighter kept, dollars)
is cut, not drawn.
- TANKPRICE1: what one point of the tank is worth, and the slow start. Target: your best week against Coach's week 4 to 6 wins in 100; best against laziest 10 to
  12; no single job over 6. Under 8 for best against laziest: the bill is redesigned. It also sizes finish a punch and southpaw rounds (kept only at 1.5+).
- SEASON1 (NEW): a careful player against "Coach deals it" every week, over a season with this line-up. Target: the pro offer 6 or more weeks sooner, or 2 or more
  bouts won more a season. If not, the board's choices are paperwork and are cut back. SEASON1 also fails if a bot that always takes the biggest win chip wins the season (v4.1).
- SHORTWEEK1: a year of pulls on 8 pad places and 6 coached mornings. Target: asked is over owned in 9 weeks of 10, and Coach's own deal leaves nobody short more
  than 2 weeks running. ROTATWIST1: the best deal differs from last week's in at least 3 weeks of 4; no twist answer best in more than 2 weeks of 3.
- LOYAL1 (NEW): Coach's own deal never drives anyone under 50 in a season; a bot that always starves the fighter with no bout soon loses one fighter a season;
  a bot that always deals evenly holds everyone over 60 but reaches the targets later.
- FOLLOW1 (NEW): an always-away amateur reaches the offer sooner but sells under 60 at the debut; an always-home one sells 70 or more but reaches the offer at least
  6 weeks later; a mix does both.
- MOODRATE1 (NEW): the alone rates 0.8 / 0.6 / 0.4 (v4.1) and the Low skip move a season's training by at least 1 point of a stat for a fighter who spends 4 weeks Flat.
  If not, the rates widen or mood leaves the week.
- SPARSET1 (NEW): Hard against Technical over a 6-week camp: at least 1.5 wins in 100 for Hard, and Hard's cuts cost at least 1 bout in 20 a year. Else Hard goes.
- WEAKFIND1: three bots (always the lowest number; weapon, goal and ladder; a mix). None beats another by over 3 wins in 100 a season; if the lowest-number bot does,
  the gain drops to +0.15 a point; if it still does, the rule goes.
- SHEETDEAL1: 1,000 dealt sheets. No card beats another on all five lines (fans added); always-home, always-pass and always-unknown bots all finish behind a bot that
  mixes. WEIGHTGAP1: +2 tank for each 0.5 kg heavier at the bell, +1 point for each 3 bouts more. HOMELEAN1: close rounds going home 7 times in 10.
- MONEYFOUR2: a year with this line-up: the gate only at home, away travel (about $40 a bout), our own show's HOME cards, the purses, the camp bills, camp leave,
  class nights and the members they bring later, Ana's teaching and the members it brings (v4.1). Target: one sponsorship plus one
  class night a week leaves the bank level over the year; if not, the class night's $117 is re-priced first, then the home ticket cut. PROCAMP1: what one 6-week
  camp costs two amateurs in bouts and pad places.

## 9. Build order, in small tasks
1. Probes (cloud, pure, on the played bout): TANKPRICE1, SEASON1, SHORTWEEK1, LOYAL1, FOLLOW1, MONEYFOUR2, then the rest of section 8. Each writes the size table
   LeverSize reads.
2. Pure rule modules with unit tests, one a task: Favours; JobRota; ClubDeal (with Coach's evenings); ClubTwist (the deck of 12); WeakSpot; FightWeek (tank, sharp,
   lines, the scale against the gap, the one number); BoutSheet (three kinds, no best card, the ladder, Ready / Building / Rest, away travel, HOME cards on our own show); TrialMat; Loyalty; SeasonTarget;
   Fans (with the ProDebut, Matchmaking and ClubShow changes); SparSet; LeverSize.
3. Clear the camp rules for amateurs: the 1.5-point loss and its line in the Why, the "Set camp" flag, the peak bonus, tape that needs a camp; the bout goal met when
   fought; 4 fighters at the first unit; sponsorships as blocks; WeekTwist's cards retired; the alone rate by mood.
4. The start: Lucy's and Josh's rows as professionals (1-0, licensed, unranked, fans); Create's three picks with fans and ambition; FirstWeek.STEPS rewritten to the
   five steps and the reveal order; FirstHour's offer day, show day, second walk-in and Ana's joining day removed; the road strip with fans; the Pro offer screen's
   purse line and ticket forecast. New data: 3 more names a weight, the Saturday show calendar.
5. Screens, one a task, from the drawings: Club week (`clubweek_v4.png`); the bout sheet; the Bout page's bill with the one number; the road and Fights with both
   kinds; the badges and loyalty on the cards and Overview; Coach's card; Money's lines; the Grappler page's division and teaching; the Why's sizes and buttons.
6. ONE golden-path test: Create with a professional and two amateurs, the guide's five steps and the reveal to week 5, a season target set, a sponsorship placed and renewed,
   a class night sold, two pulls followed and one refused, a fighter dealt short twice and the talk answered, a sparring evening set to Hard, a twist answered, a sheet,
   a home win adding fans, a bout picked away for a favour, the bill with film, four lines and the one number, the scale at 4 pm, the fight, the Why with sizes and the
   rank earned, the favour spent on the next sheet, Ana entered white at an open, the professional's camp run to its own bout, the debut forecast moving.

## 10. Risks, said plainly
- It is the biggest change since the restart: one new board, thirteen new rule modules, new data and a new start: several weekly builds, not one.
- Nothing here has a measured price yet. If TANKPRICE1 or SEASON1 says the week moves too little, the bill and the board are cut, not decorated.
- The money falls: this line-up earns about $6,000 a year less from bouts than the four amateurs measured. The class night is the board's answer; MONEYFOUR2 is first.
- Day-one load: four people, three counters, favours, a rota, a twist, mood, loyalty, targets, fans. The reveal order carries it: week 1 shows two things.
- Two numbers about a person (mood and loyalty) can read as one. Mood is shown as its word only (Fired up, Steady, Flat, Low); loyalty is the one bar. Each price on
  the board names which it moves.
- Loyalty can turn into a nag. LOYAL1 checks Coach's own deal never triggers the talk; the talk comes at most once a fighter every 4 weeks.
- The professional game after the debut exists but the owner has played little of it: the first hour will show its rough edges at once.

## 11. What changed from v3, and the critic point each change answers (reviews in `docs/mockups/s432/critics/`)
| Change | Answers |
|---|---|
| Loyalty: the trait made live; the talk card; leaving under 25; the outside manager at turning professional | Club coach: "going short has no lasting cost"; systems designer: "mood is priced everywhere and buys nothing" |
| Mood with teeth: the alone rate by mood, the Low fighter's own pass; deal prices moved from mood to loyalty | Systems designer: "a third of the prices on the board are paper" |
| Fans: home and away reach the debut's tickets and the professional's fans | Club coach: "home or away never reaches the professional career" (ProDebut, Matchmaking checked) |
| The season target and its strip; the nationals as fight weeks on the board | Club coach: "no season: every Monday is solved again from zero" |
| Coach's evenings: pads or a second class (+$117) | Systems designer: "the money has no lever on the board"; what happens to the code's $350 is now said |
| Sizes on every chip; the bill's one number with its parts; the three biggest levers; "your deal against Coach's" replaces Coach's score | Systems designer: "no screen shows which choice moved the win chance most"; "Coach's score is never defined" |
| The sparring setting and a pair picker | Club coach: "the biggest weekly call a real coach makes"; systems designer: "nowhere to pick the pair" |
| Ana: the division at an open, teaching from blue, the open on the sheet tab | Systems designer: "Ana has almost no choices" |
| Sponsorship block end: renew, pass on, let it end | Systems designer |
| Rest 2 weeks after a bout | Club coach |
| Cut: overtime row (twist card), Same as last week (Keep my changes), Coach's extra evenings (twist answer), watch on every morning (trial card), Hold, the second kilo rule, the senior's mood curve, Coach's score; dim job cells | Both critics' useless lists |
| The reveal order; the "right when" column never printed; the cut rule and four new probes | Both critics |
| v4.1: the ten changes of the verdict (Tell it straight, loyalty's upside, HOME on our own show, Sell tickets cut, class members, away travel, mood rates, sizes as ranges, the professional's choices and camp leave, the small fixes) | The two final critics on v4 and the verdict (`docs/mockups/s432/critics/VERDICT.md`) |

ASKS NOT TAKEN AS WRITTEN, AND WHY:
- "Standing with you" as a new 0-100 number: taken as LOYALTY, the trait already in the data and already live for Ana. The owner's earlier ruling was "her morale is the
  trust score, no new meter" (Q-S294-86), and "Standing" is already the Fights page's word for booked or free.
- "3 weeks Low = asks to train at a rival club" (systems designer): folded into loyalty's one leaving rule; two ways to lose a fighter would read as noise.
- Fans "+8 a home win": +4, sized to the debut's 100 tickets (break-even 60); at +8, five home wins fill a debut and away costs nothing.
- Ana teaching as a white belt for +$90: the code's rule (from blue, $68, real academies) is kept and tied to the division choice instead.
- Watch "made automatic" (systems designer): kept as one choice on the trial card (club coach's version); SHORTWEEK1 makes it automatic if it is never a real choice.
- A club season frame, three club goals a year (systems designer, marked not needed now): it belongs to the year review in the small living world; the per-fighter
  targets give the weeks their direction now.
- "Rank road" as a third amateur target (club coach): the rank is shown on every fight and is the pro offer's road already; the third target is A YEAR TO GROW, which
  differs in the deal (more building weeks).

## 12. Still open
- OWNER, scope (data): a featherweight or a middleweight who turns professional has no table of that weight (Kira, Tess). Add two professional tables as data, or let
  only lightweights and welterweights be picked at the start?
- OWNER, taste: a professional keeps the day job until the top 10 (if yes, CAMP LEAVE comes with it, 3.9); sparring pairs by weight across men and women; the shell look of the drawings.
- TO MEASURE: every design value (section 8).
- TO CONFIRM IN CODE before FightWeek's brief: that the opponent's tank is always full and no judge sees a close round today.

## MECHANICS FOR THIS VERSION
The complete list, one line each. With these the set is closed for this version: after the probes, choices are cut, never added.
1. THE FOUR: one professional of two, two amateurs of four, Ana the grappler; four places at the first unit.
2. CLUB WEEK: one Monday board dealing pad places, coached mornings (shared automatically) and gym sponsorships (4-week blocks with renew, pass on, let end);
   every counter in one unit (fighter-sessions: asked, covered, short); PROMISES OPEN; the diet cell on each boxer's row; by hand, keep my changes, Coach deals it.
3. COACH'S EVENINGS: each one pads or a second class (+$117 that night, about one new member every 4 weeks later), the board's money lever.
4. PULLS: weak spot, weapon, goal, ahead; each with its measured size shown as a range, each kind in its own colour, never added to another.
5. THE JOB ROTA: shifts, college, office, cafe; a professional keeps the job until the top 10 (the owner's call; camp leave if so).
6. THE CLUB TWIST: one card a week from a deck of 12, priced answers (overtime and Coach staying late are cards).
7. FAVOURS: 0 to 3 with each show club; earned helping, spent bending terms; one kilo rule both ways.
8. THE TRIAL MAT: a prospect every 4 weeks for 2 weeks; watch on its card; sign or pass.
9. SPARRING: the pair by weight and the setting (Hard, Technical, Body only) on each sparring evening.
10. MOOD WITH TEETH: the alone rate by mood (0.8 / 0.6 / 0.4); a Low fighter passes a sheet; the corner's uptake (code).
11. LOYALTY: the trait made live; Loyal fighters can hold pads and take one free short week in four; the talk (Tell it straight free, a roll on
    coachability, once in 8 weeks); promises open; leaving under 25; the club's share when turning professional.
12. THE SEASON TARGET: one per fighter (the nationals, the pro offer, a year to grow; ranked with a 6-week camp and the step-up, or busy with a 4-week
    Light camp and tune-ups; a medal or blue belt); the season strip.
13. FANS: home wins build the crowd that sells the debut and every professional bout (away adds none).
14. THE BOUT SHEET: home (a local show near the club, or our own show when one is booked), a name above, the unknown (away about $40 in travel);
    no best card; Ready, Building or Rest; the regional ladder and the rank earned on every fight.
15. THE FIGHT WEEK: the scale at walking weight with the gap, Coach's evenings before the bout, film, the plan as a hand of four lines, the Legs bar and the shape of
    the week, the other corner's week, the corner, pull-outs and the 4-day call; the bill's one number against Coach's week.
16. ANA'S MAT: classes 3 or 5, the mat morning, the division at each open with Enter or Skip, teaching from blue (cash and members later), the stripe
    call, who corners (only when a boxer of yours boxes that day).
17. THE ROAD TO PROFESSIONAL: the offer and its three answers to no, the $1,105, the ticket-paid debut, the promoter's offers, the camp (camp leave if the job stays).
18. THE GUIDE: five steps in week 1 and the reveal order to week 5.
Built already and unchanged by this map: the fight itself, the corner calls and minute, the Playbook and combinations, the Why, injuries, perks, goals.
LEFT FOR LATER, ON PURPOSE: the RPG layer (the coach growing with either-or perks, a coaching style, traits that change, fighter moments; RPGLAYER1, next, built on
loyalty); a rival club that approaches and poaches; the hosted club show's card filling and owed favours (HOSTSHOW1, after this map; HOME on our own show is in it now); the small living world (one national ladder with a mandatory
challenger and an eliminator, rivals who age and move, judges with taste); a club season frame and the year review; the full promotion (pro cards, belts, TV); more
professional tables (owner's call, section 12); show-night conditions; the ten novice bouts; what a bout teaches.


# CRITIC ANSWER: LOYAL1_RESULT.md

# LOYAL1 Result — S461 qwen/loyal1

## Setup
- 52 club weeks, 4 fighters (Kira 60, Tess 66, Danny 58, Ana 60), 40 seeds per policy.
- Bout calendar: bouts every 4–6 weeks, staggered by fighter index, fight week = 1–2 weeks before bout.
- Pad ask: ASK ordinary 3, +2 in fight week. Mornings: 2 each, chosen for realistic sharing.
- Coach's evenings: ["pads","pads","pads"], own evening "pads" → 8 pad places.
- No holder (no fighter has loyalty ≥70 AND bouts ≥6 at start).
- Policies: COACH (coach_order), EVEN (rotate order), STARVE (no-bout fighter last), CLASS (one class night).

## Results

### SHORTWEEK1 — FAIL

| Metric | Target | Got |
|---|---|---|
| asked > owned (9/10 weeks) | ≥36/40 seeds | 40/40 (100%) ✓ |
| COACH max run short ≤2 | ≤2 | **52** ✗ |

**Root cause:** 4 fighters × 3 pads = 12 asked vs 8 owned. Every fighter gets 2 pads every week. Every fighter is short every week. The COACH short_last_week mechanism cannot help because ALL fighters are short simultaneously — there is no one to prioritise.

### LOYAL1 — FAIL

| Line | Target | Got |
|---|---|---|
| COACH min loyalty ≥50 | ≥50 | **0** ✗ |
| STARVE loses 1 fighter | ≥1 | **4 per seed (all)** ✗ |
| EVEN min loyalty >60 | >60 | **0** ✗ |

All policies drive loyalty to 0 because every fighter is short every week:
- Week 1: short (−3)
- Week 2+: short_running (−6) because the previous week's "short" is within 7 days
- Loyalty reaches 0 by ~week 10 and stays clamped

STARVE loses all 4 fighters (not 1) because all drop below 25 and accumulate 2 talks.

CLASS cash: $243,360 total across 40 seeds ($117/class night × 52 weeks × 40 seeds).

## ESTIMATES to move

The root cause is structural: **12 pad asks vs 8 pad places**. The map's "quiet week asks 10" (CLUBWEEK_MAP 3.1) was written for 3 fighters. With 4 fighters at ASK ordinary 3, the quiet week asks 12.

### To pass SHORTWEEK1 (COACH max run ≤2):
- **ClubDeal.ASK["ordinary"]** (currently 3) → **2**: so 4 × 2 = 8 = owned. Nobody short in ordinary weeks.
- OR add a 4th Coach evening (or increase own evening to 3 pad places) so owned ≥ 12.
- OR introduce a holder earlier (lower LOYAL_AT or HOLD_BOUTS) so the pool is 9+.

### To pass LOYAL1 (COACH min ≥50):
- Same pad fix as SHORTWEEK1 (if nobody is short, loyalty grows from full_week +1).
- OR **Loyalty.MOVES["short"]** (currently −3) → **−1 or −2**: slower drop, stays above 50 longer.
- OR **Loyalty.MOVES["full_week"]** (currently +1) → **+2 or +3**: recovery outweighs occasional short.

### To pass LOYAL1 (STARVE loses exactly 1):
- The pad fix above would reduce short weeks under STARVE, so fewer fighters drop.
- OR **Loyalty.LEAVES_UNDER** (currently 25) → **15 or 20**: harder to trigger leaving.
- OR **Loyalty.MOVES["short"]** less negative: fighters stay above 25 longer.

### To pass LOYAL1 (EVEN min >60):
- Same pad fix: if fighters aren't all short every week, EVEN's rotation keeps everyone fed.
- OR **Loyalty.MOVES["full_week"]** (currently +1) → **+3**: even occasional full weeks recover loyalty fast.

## Verdict summary

```
SHORTWEEK1 = fail
LOYAL1 = fail
```

The probe's one clear finding: **the pad place count (8) is too low for 4 fighters at ASK ordinary 3**. Until either the asks come down or the places go up, every policy drowns in short weeks and loyalty collapses. The COACH rotation, the EVEN fairness, and the STARVE pressure all measure correctly — they just have no room to work.

## Regression

```
RESULT: tests/club_deal_test.gd -> CLUB_DEAL failures=0
RESULT: tests/loyalty_test.gd -> LOYALTY failures=0
```

## S462 Claude's rerun and decision
- Rerun on the same seeds (S462): every number above reproduced line for line. The page is honest.
- Decision: nothing is wired (INTEGRATION_S459 #6 Loyalty, #11 ClubDeal stay waiting). The fail is structural, not a tuning slip:
  four starters (SCOPE S428) ask 12 pad places against 8 owned, so "short" (covered < asked) is true for every fighter every
  week and no deal order can rotate it. The club-week map goes back to the design loop (CLUBWEEK v5) with this finding. The
  direction Claude asks the designer to test: a fighter's NEED is 2 pad places (short = under the need), the 3rd is a WANT that
  only the deal order decides; fight weeks (+2) are where the real shortage and the choices are. Re-measure with this probe.
