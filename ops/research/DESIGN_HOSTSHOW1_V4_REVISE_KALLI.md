# HOSTSHOW1_V4 - write the NEXT version of this mechanic's design map (S459 design loop)

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

# HOSTSHOW1: host your own club show (design map, round 3, S439)

Sources read whole: `CRITIC_PACK.md`, `SCOPE_FOUR_FIGHTERS_S428.md` (item 4: "a permit, a doctor, an MC, a card of about 15 bouts with your
fighters and others, ticket money; the show is the unit of R37"), `R37_ASK_FOR_A_FIGHT_MAP_S428.md` (favours: "a clean show with a club earns a
favour with it; a pull-out by you costs one"), `HYPE_MAP_S432.md`, `BOXING_MANAGER_COMPARE_S425.md`.
Code read for round 3 (each claim names its file and number): `scripts/rules/ClubShow.gd` (whole), `scripts/state/Region.gd` (`day_events` 92-129:
`busy` holds only `f.bout` opponents 101-106, `SHOW_BOUTS` 2 a division a show 14, `before` 183-190, `rankings` 168-179 with ours at `rating` 0.0 176),
`scripts/state/Data.gd` (`SHOW_FIRST_DAY` 12, `SHOW_EVERY_DAYS` 14, rivals 66-185 and their clubs), `scripts/state/Roster.gd` (`pro_ready` 174-184,
`check_pro` 188: only with no bout booked), `scripts/state/BoutNight.gd` (goal judged at the bout 426-432, `update_rank` 433, `check_pro` 459),
`scripts/state/Bouts.gd` (`withdraw_bout` 270-280 and its news words 274, `weigh` 328-342, `short_notice` 252, `check_pro` 413),
`scripts/rules/FighterGoal.gd` (`progress` 96-158: MET only when every target is reached; `SUCCESS_MORALE_DELTA` +10, `FAILURE_MORALE_DELTA` -20),
`scripts/rules/FighterProfile.gd` (`MORALE_EVENTS` 20-33; `month_no_fight` has no caller: grep finds only line 25), `scripts/state/GymSpend.gd`
(`member_cap` 115, `member_target` 132, `member_limit` 140-147), `scripts/rules/GymSlots.gd` (`member_room` 67 = places x 3), `assets/data/gym_slots.json`
(the opening floor: 22 places), `scripts/rules/Membership.gd` (48 + 0.6 a point, x the dues band's draw: Cheap 1.15, Premium 0.85), `scripts/state/Sim.gd`
(`weigh_forecast` 131-155: one weight, no spread; the coming weeks' twist cards are not drawn), `scripts/rules/BoutRules.gd` (`WEIGH_TOLERANCE` 0.05 87,
`MISSED_WEIGHT_COST` 88, `TICKET_CUT` 89, `stale_energy` 165: 2 Energy a fatigue point over 50, at most 20, only with a camp), `scripts/rules/WeekPlan.gd`
(`CUT_DEFICIT` 500 74, burn 245-263).

Marks: **CODE** = in the code today (file and name given). **ESTIMATE** = ours, measured by HOSTPROBE1 (section 9) before a screen shows it.
**NEW** = a rule that does not exist yet. **[R]** = a real-world number from the research files above. Game text never uses he, she, her or him.

Drawn: `docs/mockups/s439/hostshow/screen_r3.html` / `.png` (Fights > Our show, Thu 9 Jul, 16 days out, the moment Priya Nair's no arrives).

## 0. What changed in round 3 (each critic finding answered in the mechanic)
| Finding | What changed |
|---|---|
| Three rank lines wrong by `Region.before` | Every rank line is now a CONDITION, worked with `before` on the table after the night's other bouts and the region's show before it. Danny's ladder row now says "No. 3 only if Danny boxes and wins and Liam wins"; the novice tile "No. 3 if Liam beats Dean (38 in 100), else No. 4"; Lucy's ladder row "counts only if Lucy boxes Maria and wins". ShowCard tests one case each (task 6). |
| The region's show on Sat 18 Jul ignored | HOLD RULE (NEW, one line in `Region.day_events`' `busy`): every name on our card, opponent or visiting pair, is held from the region's shows from the day it goes on the card. The show is a node on the timeline with the names still free ("Priya Nair and Ellie Ward free: may meet"), and every rank line counts it (Maria's route: 33 in 100, both roads counted). |
| No combined number; the player multiplies | Each Lucy tile prints one number: "Pro offer from this show: N in 100", counting a second ask after a no; "Lucy wins N in 100" with the band in brackets. |
| "Pay their travel $120" was always right | CUT. Replaced by FAVOURS per club (R37 brought forward): a small count each (0 to 3), spent on +3 in 10 on a yes, on a ladder swap, on a stand-down without bad blood; earned by a clean bout of ours against one of that club's boxers. The same club's one favour now has two uses on the screen (section 4.5). |
| The return-bout promise had no real price | Its price is now the pro offer: `check_pro` runs on the night (BoutNight 459, CODE) and the return bout is written the Monday after, so the offer is not blocked, but turning pro breaks the promise: that club's favours -2. Shown on the tile. |
| Ladder Swap was free | A swap costs one favour with EACH club that moves a boxer, and both clubs must say yes (7 in 10, 3 days). Its options show inline with their odds and the Supervisor's band. The one swap worth drawing: Erin v Priya, two names above Lucy, one of whom must lose. |
| Danny's ladder did nothing | True (`before`: a Liam win leaves Liam 8-5 above Danny 4-1). The pair stays one plain line; no swap is offered: at 4 wins a rank opens nothing (the pro offer needs 7, CODE). |
| Samira: no miss chance, Stand down a lookup on the chip | Three priced tiles: Keep the cut (miss 1 in 6), Harder fight week (two Hard interval mornings: miss 1 in 25, Energy -12 on the night), Stand down (-25 seats, one Islington favour). The miss chance is NEW (`WeighOdds`, section 4.4). |
| Danny's "Leave off" only had costs; "-6 morale" is not in the code | The -6 is gone from the screen until MOODIDLE1 lands. The real price found in the code: the goal is judged at the bout (`BoutNight` 426-432) and is MET only when the target is reached, so a bout before the goal is done costs -20 morale (CODE). Leave off keeps the full weeks: the goal is met Thu 23 Jul and pays +10 at the next bout. |
| The price grid was a lookup per hall | CUT. Each hall has its price; the hall is the choice; the door price can only be cut at the read. |
| The ticket read panel was not actionable for 4 days | It is a timeline node until Mon 13 Jul. The favours panel takes its place. |
| Member room named only the premises | Read from `GymSpend.member_limit`: the opening floor's 22 places x 3 = 66 binds before the Unit's 70 and the coaches' 110; reputation 30 fills it at standard dues (Cheap: 16). An "Add places" button opens the gym picture. |
| Wrong words | Our stand-down writes its own news line (`withdraw_bout` gets a reason, NEW). No pronouns; "reputation" in full; "brings 28 tickets". |

## 1. The idea in five lines
1. About three times a year (`ClubShow.EVERY_DAYS` 112, CODE) the club puts on its own amateur show: you pick the date and the hall, and you are the
   matchmaker.
2. For each of your boxers you choose whom to ask (a name above, a name below, an outside novice, a skills bout, wait, or nobody) and how (as it is,
   with a favour, or with a promised return bout); each tile prints the yes chance, the win chance, the rank line as a condition, and the pro-offer
   chance from the show.
3. The coach fills the rest of the card; pairs that hold a name above one of your boxers are LADDER pairs, and a swap costs favours with both clubs.
4. The region's shows go on around yours; names on your card are held from them, the free names may move the table before your night.
5. The night: your bouts in front of your own crowd; the sheet gives the money against boxing the same bouts away, reputation part by part (and the
   members it can still buy), the rank moves, the pro offer if it came, and the favours earned or spent.

## 2. What is built today (read in the code)
- `ClubShow.gd` (pure, 59 lines): COST $3,500 at booking (comment: venue ~$2,000, officials + doctor + ambulance ~$1,200, trophies ~$300), TICKET $25,
  HALL 400, EVERY_DAYS 112, LEAD_DAYS 28, draw = 40 + 0.7 a member + 1.0 a reputation point + 2.5 a junior + 25 a home boxer, LUCK 0.70-1.15, RAFFLE
  $600-$1,400, one member per 40 tickets on a night that made money. CODE.
- `GymSpend.book_show` / `day_events`: pays, rolls luck and raffle, pays tickets and raffle, adds members, one news line. `home_boxers` = every
  uninjured amateur, boxing or not. CODE. One screen: Club > Money, CLUB SHOW row (`ClubSpend._show`). CODE.
- An away amateur bout pays $450 (`BoutRules.TICKET_CUT` 89). Win +8 members, +5 reputation; loss -1, -2; stoppage loss -2, -4 (`BoutRules` 90-99).
  A short-notice win doubles the reputation only (`BoutNight` 363-366). CODE.
- The region: a show every 14 days from day 12 (`Data` 101-102); at each, up to 2 bouts a division (`Region.SHOW_BOUTS`) from the rivals not booked
  against one of ours (`busy` = `f.bout` opponents only, 101-106), the novice rule both ways. `rankings` orders by net wins, then wins, then rating;
  ours carry 0.0 (176) and lose every tie. CODE.
- Pro offer: `pro_ready`: 7 wins and a top-3 place, or 9 wins; `check_pro` makes it only when no bout is booked, and runs after every bout
  (`BoutNight` 459, `Bouts` 413) and in the weekly step (`Sim` 406). CODE.
- Goals: judged at the bout night (`BoutNight` 426-432): MET only if every target is reached that day (`FighterGoal.progress` 127-137), else missed;
  met +10 morale, missed -20 (`FighterGoal` 29, 31). CODE.
- Morale moves (`FighterProfile.MORALE_EVENTS`): win +8, loss -12, booked +5; `month_no_fight` -6 has no caller. CODE.
- Weight: `Sim.weigh_forecast` gives one weight for the weigh-in day, with next weeks' twist cards left undrawn (144). The weigh-in is the day
  before; `made_weight` allows 0.05 kg; a miss calls the bout off and the club pays $300 (`Bouts` 328-342). CODE.
- `stale_energy`: 2 Energy a fatigue point over 50, at most 20, and only when the bout has a camp (`BoutRules` 165-168). CODE.
- Members: `member_target` = min(`natural_members`, `member_cap`); `member_cap` = min(premises - upgrades' room, coaching cap, equipment places x 3) +
  kit; `member_limit` names which binds. The opening floor holds 22 places (66 members). CODE.

## 3. What is thin
1. The show has no card; every uninjured amateur counts 25 tickets whether boxing or not.
2. One decision (book or not), always yes for a grown club.
3. A night leaves only cash: nothing touches reputation, ranks or the pro offer.
4. It lives only on Club > Money.
5. World defects: ours lose every rank tie (RANKTIE1); the men's lightweight novice pool empties (Liam Doherty is open after one more bout);
   several "London" opponents carry clubs far away (`Data` 66 Guadalajara, 69 Leicester, 72 Belfast, 183 Rotunda, 184 Everton; DATAFIX1).
   Section 6 uses the club names the code holds today.

## 4. The mechanics, each a decision with its options and prices

### 4.1 Date (8 weeks out or more)
- One of the next four free Saturdays at least 8 weeks out ([R] England Boxing permits 8 to 12 weeks ahead; `LEAD_DAYS` 28 becomes 56).
- A Saturday that is also a region show (CODE days 12 + 14k) splits the crowd: draw x0.8 (ESTIMATE). Each boxer shows per date: free, booked elsewhere
  (`f.bout.day`), suspended, in the nationals (`Champs.active`). CODE.
- The region's show a week before ours matters too (4.6): the screen names it per date.
- A decision because the nearest Saturday is often the one a boxer cannot make.

### 4.2 Hall (one choice at booking; the price comes with the hall)
| Hall | Seats | Rent | Ticket | Card | A name above says yes (base) | Full (85%+) | Half-empty (<50%) |
|---|---|---|---|---|---|---|---|
| The gym floor | 120 | $300 | $35 | 6 bouts | 3 in 10 | +3 reputation | -3 |
| Community hall | 250 | $1,000 | $25 | 9 bouts | 5 in 10 | +4 | -3 |
| Town hall | 400 | $2,000 | $25 | 12 bouts | 7 in 10 | +6 | -4 |
Every hall also pays officials, doctor and ambulance $1,200 and medals $300 (the `ClubShow` comment's split, CODE comment). 30% of the rent at
booking. All other numbers ESTIMATE ([R] club show crowds 200-500, tickets GBP 12-20).
The booking screen shows per hall: likely net, net on a bad night (1 in 10), full chance, half-empty chance, the names' yes (`ClubShow.v2.preview`).
A decision because the halls trade money, a sure full room, and the names: the town hall buys +2 in 10 on every name above and three more pairs
(more ladder pairs) for less likely money and a real chance of a half-empty -4 (6.10). The price was a separate choice in round 2: per hall one price
always won, so it went.

### 4.3 Your boxers on the card (the matchmaker's choice, one per boxer)
The card opens 19 days out; the bout sheet closes 3 days out ([R] R37). One open ask per boxer; answers in 3 days (NEW, ESTIMATE). Posters print at
the ticket read, 12 days out: a main event settled by then sells its poster tickets (4.7). A name who says no is spent for that boxer this show.
Every tile prints: yes chance; "<boxer> wins N in 100 (band)" (`BoutRead.band`, CODE); the rank line on a win and a loss AS A CONDITION
(`RankLine.after`, NEW, on `Region.before`, CODE, after the night's other bouts and the region's show); the pro-offer chance from the show
(`Roster.pro_ready`, CODE, on each branch); seats it brings; reputation.
- A NAME ABOVE: yes = the hall's base + 1 in 10 for every 2 rating points that name holds over ours, at most 9 in 10 (ESTIMATE). Win +5 reputation,
  +8 members (CODE). The card's highest-ranked opponent makes the main event (4.7).
- A NAME BELOW: yes 9 in 10 (ESTIMATE). A home win over a name below: +3 reputation, not +5 (ESTIMATE, [R] HYPE_MAP 2.1); members +8 (CODE).
- AN OUTSIDE NOVICE (only when the pool holds no legal name): always yes, travel $80, no tape (`OppFile`, CODE), band about 30-70.
- A SKILLS BOUT (only when the pool holds no legal name): the same outside novice, $80, three rounds, no winner given ([R] England Boxing skills bouts).
  It runs through `BoutNight` without a result (NEW: no record, rank, win/loss morale, members or reputation), so `booked` +5 applies and the GOAL IS
  JUDGED, as at any bout (CODE 426-432).
- WAIT FOR THE REGION'S SHOW: no ask now; ask once after it (one ask only: the answer must land before the sheet closes). Costs the poster tickets;
  keeps the favours; the rank lines are read with the region's result known.
- NOT ON THE CARD: full training weeks; other clubs' offers keep coming (CODE); the goal is not judged that night. (`month_no_fight` -6 appears on the
  tile only once MOODIDLE1 gives it a caller.)
- HOW TO ASK (inside each tile, where it can change anything): AS IT IS; WITH A FAVOUR (that club's favours -1: +3 in 10, still at most 9 in 10);
  PROMISE A RETURN BOUT (9 in 10, no favour now: our boxer's next bout is fixed, away at their show against the same name within 12 weeks, $450 cut as
  usual, CODE; HostShow writes it into `f.bout` the Monday after our night, so the night's `check_pro` (BoutNight 459) is not blocked; turning pro or
  standing down breaks it: that club's favours -2 (NEW)). A how-to-ask choice that cannot change the yes (a name already at 9 in 10) is not drawn.
- STAND DOWN (after a yes): `Bouts.withdraw_bout` (CODE: camp ends, offers resume after 5 days) with our own words in the news (NEW reason); the
  boxer's seats leave the draw; that club's favours -1.
- RULES ON EVERY TILE: the novice rule (`experience_match_ok`, CODE); the Supervisor's line: no bout whose band tops out under 30 for either boxer
  (NEW, on the band the player sees). A refused name is greyed with its reason. Weight class matches (product rule): no catchweights.

### 4.4 Weight on our own show (a decision with three prices)
- MISS CHANCE (NEW `WeighOdds.miss`, pure): runs `Sim.weigh_forecast` once for each twist card that can be drawn on each coming Monday (WeekTwist's
  weights), and counts the share over limit + 0.05. Printed "misses 1 in 6".
- KEEP THE CUT: on a miss the bout is off on the weigh-in day; we host, so no $300 (NEW); the crowd has its tickets; reputation -2 and that club's
  favours -1 (ESTIMATE / NEW).
- HARDER FIGHT WEEK: two of the fight week's rest mornings become Hard intervals (the week editor, CODE): about -0.17 kg (11.0 MET x 62 kg x 0.75 h x
  1.3 x 2 / 7,700, `WeekPlan` 245-263 formula; ESTIMATE hours) and fatigue about 56 on the night: Energy -12 by `stale_energy` (CODE rate; NEW: the
  fight week counts as a camp of protocol 1 for it). Win chance falls (shown).
- STAND DOWN: section 4.3.
- A decision because each answer pays in a different coin: risk and a favour, Energy on the night, or seats and a favour for sure.

### 4.5 Favours with other clubs (R37's ledger, brought forward)
- Each club holds 0 to 3 favours with us (NEW, `Career.favours`, starts at 1 with each club a boxer of ours has met, 0 with Eastside ABC).
- EARN: a clean bout of ours against one of that club's boxers, home or away (no pull-out and no missed weight by us): +1, at most 3.
- SPEND: +3 in 10 on a yes; one per club on a ladder swap; a stand-down or a missed weight (-1, forced). A broken return-bout promise: -2.
- OWED (below 0): that club's yes -2 in 10 on everything until a clean bout brings it back to 0.
- A decision because one club's single favour has more than one use on the same screen (Belfast Gloves ABC's: Erin's yes, or half of the Erin v Priya
  swap), and every one spent now is not there for the next show or for an away ask (R37).

### 4.6 The region's show before our night (a rule, shown)
- HOLD (NEW, `Region.day_events`' `busy` also takes `c.show` card names): a name on our card does not box at the region's shows.
- The names still free in a division with one of ours can box (CODE, 2 bouts a division). The timeline names them, and every rank line is read
  over both outcomes. In section 6 the Maria route counts "Priya Nair loses on Sat 18 Jul" as its second road.

### 4.7 The crowd: followings, visitors, main event (rules)
- Each of our boxers on the card brings 10 + 3 a win (ESTIMATE; replaces `PER_HOME_BOXER` 25): Lucy 28, Samira 22, Danny 22.
- Each boxer from another club brings 3 supporters; the host pays $40 travel each (ESTIMATE). Outside novices bring none ($80).
- MAIN EVENT: the bout with the highest-ranked opponent closes the night. If settled by the posters it sells half its boxer's following again, +10 with
  a pro offer on the line (ESTIMATE). Main-event win +3 reputation, loss -3 (ESTIMATE).

### 4.8 Ladder pairs (visiting bouts that move our boxers)
- The coach fills the card with legal pairs; visiting bouts are settled first on the night with `Region._rival_bout` (CODE), so `update_rank` and
  `check_pro` on our bouts see them.
- A LADDER pair holds a name above one of ours whose loss can lift our boxer. Its line says the condition in full ("counts only if Lucy boxes Maria and
  wins") and the odds (`WorldBout.fast`, probed).
- SWAP: the legal swaps inline, each with its odds, the Supervisor's band, and its price (one favour with each club that moves a boxer; both say yes 7
  in 10; 3 days). Pairs that move none of ours are one line, no button.

### 4.9 The ticket read (12 days out; a timeline node until that day)
Advance luck is drawn; the read shows sold so far (69% of the night's figure, [R]) and the band for the night. Options, each with its money against Keep:
KEEP; DOOR PRICE $15 for walk-ups (x1.3 draw on the last third); SELL (each boxer on the card gives up one fight-week pad evening, 75 min of pads =
about 2.6 mastery on the move drilled, `PadWeek` 2.1 an hour, CODE rate; +10 seats each); ANA SELLS (one no-gi class less: the closest syllabus move
-1.1, 3.2 a week over 3 classes, CODE; +10 seats; no fight-week cost); MOVE DOWN (deposit lost, smaller hall, card cut from the visiting pairs); CANCEL
(deposit lost, -3 reputation, every club on the card -1 favour).

### 4.10 Pull-outs, the night and the sheet
- An invited opponent pulls out 1 in 10 in the last week (ESTIMATE): tougher replacement (`Bouts.short_notice`, CODE), outside novice, or stand down.
  A night with under two-thirds of its card is a SHORT NIGHT: -2 reputation (ESTIMATE; on the sheet, not on the planning screen).
- The night: visiting bouts settle first, then ours as fight nights (`Bouts.fighting_today`, CODE), main event last; "Sim to result" for any.
- THE SHEET: money in parts, NET, against away ($450 a boxer who had a legal away bout, CODE); reputation part by part; members (CODE) and where they
  settle under `member_cap` with `member_limit` named; rank moves; the pro offer; favours earned and spent; next show's crowd (full: +15% of sold;
  half-empty: -10%; ESTIMATE).

## 5. Every decision (B before, D during, A after; the last column is the designer's test, NEVER printed)
| When | Decision | Options and prices | Right when (never on screen) |
|---|---|---|---|
| B | Date | 4 Saturdays; region-show clash x0.8; who is free | The date most boxers can make, unless cash is needed sooner |
| B | Hall | Gym floor / community / town (4.2) | Gym floor: a young club or tight cash. Community: most money. Town: a boxer one win from the pro offer whose name above says no too often |
| B | Lucy's route | Erin as it is 40 / with the favour 44 / with a promise 44 / Maria 36 / Maria + swap 54 / wait 37 (in 100, section 6) | Strong Lucy and favours needed elsewhere: Erin as it is. Favours to spare: Maria + swap. Belfast Gloves favour wanted later: wait |
| B | Samira's weight | Keep (1 in 6) / harder week (1 in 25, Energy -12) / stand down (-25 seats, a favour) | Margin 0.1 kg: harder week. 0.4: keep. 0.8 over: stand down |
| B | Danny | Outside novice / skills bout / leave off | Goal done and morale Steady: novice. Goal done and Flat: skills bout. Goal on the line: leave off |
| B | Ladder swap | Keep the coach's pair / swap (a favour each club) | Swap when it turns a condition into a near-certainty for a pro offer |
| B, read | Keep / door / sell / Ana sells / move down / cancel | 4.9 | Sell when the band ends within 30 of full and no move is one session from Sharp |
| D | Pull-out | Tougher / novice / stand down | Tougher when its band stays 40+ |
The probe (section 9) checks each row against these cases; any tile that wins in every case is cut or re-priced.

## 6. One show, played (real numbers; CODE or ESTIMATE on each)
State on Mon 25 May 2026 (day 140): 58 members, reputation 24, standard dues, no juniors, the Unit (70), one hired coach (coaching cap 110), the opening
floor (22 places: room 66, CODE `member_limit` "equipment"), cash $11,700. Natural members at reputation 24: 62 (CODE); reputation 30 fills the 66.
Favours: Belfast Gloves ABC 1, Leicester ABC 1, Islington BC 1, Dale Youth ABC 1, Everton Red Triangle ABC 1, Eastside ABC 0 (NEW).
Boxers (records are the state assumed for the example):
- Lucy Jackson 6-1, women's 60 kg, No. 4, novice (7 bouts), fight power 62.5 (RANKTIE1 rating), goal met.
- Samira Khan 4-2, women's 65 kg, No. 4, novice, forecast 64.9 kg for 65.0, morale Steady 58.
- Danny Osei 4-1, men's 60 kg, No. 4, novice; lost Sat 27 Jun; morale Flat 41; goal "Stamina for five rounds" (`five_round_engine`: Conditioning +2.5,
  set Mon 29 Jun, deadline Mon 27 Jul, CODE archetype), +1.3 done on Thu 9 Jul.
- Ana Ribeiro (no-gi): not on the boxing card; can sell tickets at the read (4.9).
Tables: women's 60: 1 Dana Whitfield 14-2, 2 Erin Doyle 8-2 (65.5, Belfast Gloves), 3 Priya Nair 7-1 (63.5, Leicester), 4 Lucy 6-1, 5 Sophie Turner 8-4
(open), 6 Chloe Bennett 6-3 (Dale Youth), 7 Maria Ortega 4-2 (61.5), 8 Ellie Ward 4-2. Women's 65: 1 Kerry Walsh, 2 Rosa Delgado 7-2, 3 Laura Finch 5-2
(62.0, Islington), 4 Samira 4-2, 5 Jade Okoro 3-1. Men's 60: 1 Mateusz Kowalczyk, 2 Arjun Patel 10-3, 3 Dean Clarke 8-5, 4 Danny 4-1, 5 Liam Doherty 7-5.

1. BOOK (Mon 25 May): Sat 25 Jul (day 201); region shows Sat 18 Jul and Sat 1 Aug (days 194, 208, CODE). Community hall, $25. Deposit $300.
2. CARD OPENS (Mon 6 Jul): Samira asks Laura (5 + 1 = 6 in 10); Lucy asks Priya (5 in 10). The coach's women's 60 pairs: Erin v Chloe (LADDER for
   Lucy), Dana v Sophie (no ladder); men's 60: Dean v Liam.
3. THU 9 JUL (drawn): Laura YES; Priya NO. Lucy's routes (worked with `before`; wins from `BoutRead.band`, ESTIMATE):
   - ERIN AS IT IS: yes 6 in 10 (5 + 3.0/2); Lucy wins 45 (38-52). Win: Lucy 7-1 (net 6) passes Erin 8-3 (net 5). Sat 18 Jul: Erin, Chloe, Dana, Sophie
     are held, so Priya and Maria (both novices, the only two free) meet. Priya wins: 8-1 (net 7), Lucy No. 3. Priya loses: 7-2 (net 5), Lucy No. 2.
     Either way top 3 with 7 wins: PRO OFFER on the night. Loss: 6-2 (net 4), behind Sophie 8-4 and Chloe if Chloe wins her new pair: No. 5 or 6.
     A no (4 in 10) leaves one ask after the posters: Maria (below, 33). Pro offer from the show: 0.6 x 0.45 + 0.4 x 0.33 = 40 in 100. Main event:
     Lucy's (Erin No. 2): +24 poster seats instead of Samira's +11.
   - ERIN WITH A FAVOUR (Belfast Gloves 1 -> 0): 9 in 10: 0.9 x 0.45 + 0.1 x 0.33 = 44 in 100.
   - ERIN WITH A PROMISE: 9 in 10, 44 in 100; and in the 41 in 100 where the offer comes, turning pro breaks the promise: Belfast Gloves 1 -> -1 (owed).
   - MARIA AS IT IS: yes 9 in 10; Lucy wins 65 (58-72). Win: 7-1 ties Priya on net and wins; Priya's 63.5 beats 62.5: No. 4 unless (a) Chloe beats Erin
     in the ladder pair (42 in 100): Erin 8-3 drops, Lucy No. 3; or (b) Erin wins and Priya loses on Sat 18 Jul: Maria is held (on our card), so the free
     novices are Priya and Ellie, who meet; Priya loses 25 in 100: Lucy passes Priya (7-2), No. 3. Road: 0.42 + 0.58 x 0.25 = 0.565.
     Pro offer: 0.9 x 0.65 x 0.565 + 0.1 x (Erin after a no: 0.6 x 0.45) = 33 + 3 = 36 in 100. Win reputation +3. Main event stays Samira's.
   - MARIA + SWAP ERIN v PRIYA (Belfast Gloves 1 -> 0, Leicester 1 -> 0; both clubs yes 7 in 10; Supervisor: Erin wins 55, band 48-62, allowed): one of
     the two names above Lucy must lose; a Lucy win is No. 3 either way. 0.9 x 0.65 x (0.7 + 0.3 x 0.565) = 51, + about 3 if Maria says no = 54 in 100.
   - WAIT FOR SAT 18 JUL: no ask; Priya and Maria (both free) meet there. Priya loses (35 in 100): any Lucy win is No. 3, then ask Maria (5-2 by then,
     yes 9, wins 62): 56. Priya wins: ask Maria (4-3) or Erin, about 27. 0.35 x 0.56 + 0.65 x 0.27 = 37 in 100; both favours kept; no poster seats
     (-13 against Erin); one ask only, answered Tue 21 Jul, the sheet closes Wed 22 Jul.
   - DANNY (goal +1.3 of 2.5 done; full weeks bring it to 2.5 on Thu 23 Jul; with the fight week from Mon 20 Jul, Light with three rest days, 2.2 on the
     night, ESTIMATE from `Sim.daily_gain`):
     Outside novice: booked +5; wins 50 (30-70); win: "No. 3 if Liam beats Dean (38 in 100), else No. 4" (Dean 9-5 net 4 beats Danny 5-1 net 4 on wins);
     loss: 4-2, No. 5; goal judged on the night, 2.2 of 2.5: missed -20 (CODE). Morale after: win 41+5+8-20 = 34 Flat, loss 14 Low. +22 seats.
     Skills bout: booked +5, goal missed -20: 26 Low. +22 seats.
     Leave off: goal met Thu 23 Jul (+10 at the next bout, CODE); morale 41 now; 0 seats.
   - SAMIRA (miss 1 in 6, NEW `WeighOdds`): Keep; Harder week (64.73 kg, miss 1 in 25; fatigue 56: Energy -12; wins 38 -> 33); Stand down (-25 seats:
     22 following + 3 Laura's supporters; Islington 1 -> 0). Samira v Laura: wins 38 (31-45); win: 5-2 (net 3) passes Laura 5-3: No. 3 (Jade, free on
     Sat 18 Jul, reaches 4-1 at best: net 3, 4 wins, below); loss: 4-3, No. 5.
   The player asks Erin as it is, keeps Samira's cut and leaves Danny off (goal on the line).
4. FORECAST (with those picks): club 40 + 0.7 x 58 + 24 = 104.6 (CODE formula); followings 28 + 22 = 50; posters 24; supporters: 6 visiting pairs = 12
   + Laura + Erin = 14 x 3 = 42; draw 220.6 at $25 in 250 seats. Luck 0.75-1.10 x 0.93-1.05 (200,000 draws, ESTIMATE): sold 171 (1 in 10 under) / 202
   likely / 233 (1 in 10 over); full (213+) 36 in 100; never half-empty. Costs: hall $1,000 + $1,200 + $300 + travel 14 x $40 = $560: $3,060.
   Likely: 202 x $25 = $5,050 + raffle about $1,000 - $3,060 = +$2,990; 1 in 10 under +$2,160; 1 in 10 over +$3,820. Away instead: $900 (Lucy and Samira
   $450 each, CODE). What moves it: Maria instead of Erin -13 seats; Danny on the card +22 seats (full room 61 in 100, likely +$420); Samira stands down -25.
5. SUN 12 JUL: Erin says yes. Erin v Chloe ends; the coach pairs Chloe v Ellie.
6. MON 13 JUL, THE READ: advance luck 0.96: sold so far 220.6 x 0.96 x 0.69 = 146; the night 197 to 222. Sell (+20 seats for two pad evenings) would
   lift the full chance; the player keeps (Lucy's pads are on the main event's answer).
7. SAT 18 JUL: Priya beats Maria (Priya 8-1). Lucy's win line still reads No. 3.
8. FRI 24 JUL: Samira makes 64.95 kg (CODE tolerance 65.05).
9. THE NIGHT (Sat 25 Jul): walk-up 1.00: 212 sold (85% is 213: just short of full). Money: 212 x $25 = $5,300 + raffle $1,050 - $3,060 = NET +$3,290.
   Visiting bouts first: Dean beats Liam. Samira loses to Laura (-1 member, -2 reputation; 4-3, No. 5). Lucy beats Erin (+8 members, +5, main event +3):
   7-1, No. 3; `check_pro` on the night: PRO OFFER ($1,500 debut purse, CODE). Reputation 24 + 6 = 30. Members 58 + 8 - 1 + 5 (212 / 40) = 70; target
   min(48 + 18 = 66, room 66) = 66: 4 drift away; the sheet says "the gym is full: the equipment's 66 places; Add places". Favours: Belfast Gloves +1
   (2), Islington +1 (2). Against away: +$3,290 against $900.
10. THE BAD NIGHT, same picks: advance 0.76, walk-up 0.95: 159 sold (64%). 159 x $25 + $700 - $3,060 = +$1,615. Lucy loses (-2, main event -3; 6-2,
    No. 5), Samira loses (-2): reputation 17, target 58. Still over the $900 away; the pro offer is months off.
11. THE TOWN HALL, BAD NIGHT (12 bouts: 9 pairs + Laura + Erin = 20 visitors x 3 = 60; draw 104.6 + 50 + 24 + 60 = 238.6; travel $800; costs $2,000 +
    $1,200 + $300 + $800 = $4,300): luck 0.70: 167 sold, 42%: HALF-EMPTY -4. 167 x $25 + $600 - $4,300 = +$475: LESS than the $900 away.

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows (only what the player can act on) | Wired to |
|---|---|---|
| Fights > OUR SHOW (tab beside Bouts) | PLAN: 4 Saturdays (who is free, region-show clash), 3 hall cards. BOOKED: header (date, hall, seats, price, booked date, days); timeline (asks left, posters and read, the region's show with the free names, fight week, sheet, weigh-in, night); a row per boxer (weight, condition, morale, goal chips; tiles with yes, win, conditional rank lines, pro offer from the show, seats; how to ask inside the tile; stand down; weight answers); ladder pairs with priced swaps; THE NIGHT (seats bar, what moves it, money that adds up, against away); REPUTATION AND MEMBERS (parts, the binding member limit, Add places); FAVOURS (per club). THE READ on its day. AFTER: the sheet | `ClubShow` v2, `ShowCard`, `HostShow`, `RankLine`, `Favours`, `WeighOdds`, `Region` (hold rule, RANKTIE1), `Roster.pro_ready`, `BoutRead.band`, `Sim.weigh_forecast`, `Sim.daily_gain`, `FighterGoal.progress`, `GymSpend.member_target` / `member_limit` |
| Club > Money > CLUB SHOW row | Not booked: "Plan a show" (opens the tab), greyed with the opening date. Booked: date, hall, deposit, likely net | `ClubSpend._show`, `GymSpend` |
| Club > People (new FAVOURS line under staff) | Each club and its favours, what earns one | `Favours` (R37's Network screen later) |
| Home: notice board + COMING UP | "The card is open: ask opponents"; "Priya Nair said no: ask for Lucy before the posters"; "Ticket read"; "Samira: weight answer"; "Pull-out"; "Show night". COMING UP: the show, the read, the region's show, the sheet | `Needs`, `HomeNeeds`, `Career.show` |
| Top bar | Flags SHOW CARD / TICKET READ / PULL-OUT / SHOW NIGHT; NEEDS YOU while a boxer on the card has no ask out before the posters | `Clock.next_stop`, `Needs.blockers` |
| Fighter page > Overview, NEXT BOUT | "Our show, Sat 25 Jul, main event v Erin Doyle" or "Asked: Erin Doyle, answer Sun 12 Jul"; an owed return bout; the goal chip says "judged at the bout" when a bout is booked before it is met | `Career.show`, `f.bout`, `Sim.goal_read` |
| Fighter page > Week | The fight week; harder-week mornings if chosen; a TICKETS evening if chosen at the read | AMATEURWEEK1, `DrillWeek` |
| Fights > a bout offer | For a boxer on our card: "on our show that night"; an owed return bout arrives marked "promised"; an offer against a club we hold favours with shows "+1 favour on a clean bout" | `Bouts.day_events`, `Favours` |
| Fight night: tale of the tape | "Crowd 212, our show, main event" | `FightNight`, `Attendance.of` |
| Result and the Why: THE CLUB tile | "Our show: on the night's sheet" instead of +$450; main event part; "No. 3: 7 wins, a pro offer"; favour earned | `BoutNight` (no cut on our show), `RankLine`, `Favours` |
| The night's sheet | Section 4.10 | `ClubShow.settle`, `RankLine.after`, `Region`, `GymSpend.member_limit`, `Favours` |
| World > News and Rankings | Visiting results "on Anvil Street's show"; rank arrows | `Region._rival_bout`, `Region.rankings` |
| Week review (the Monday after) | The show's net and reputation with causes; members settling; favours | `WeekReview`, `Career.show.night` |
| Club > Money: one-offs and cash forecast | Deposit; the night's costs; tickets and raffle; the likely net in the runway line | `Career.pay`, `CashForecast` |
| Handbook | Club show, Hall, Card, Main event, Posters and the ticket read, Ladder pair, Swap, Favours, Skills bout, Return bout, Short night | `Handbook` |
GOLDEN-PATH STEP (task 10): book the community hall; ask a name above (answer no), then a second name with a favour (yes); leave a boxer with a goal on
the line off; take the harder fight week for a boxer 0.1 kg over; keep at the read; fight the bouts; check the sheet's net, away line, reputation parts,
member limit, rank lines, pro offer on the night, favours earned and spent, against `ClubShow.settle`, `Roster.pro_ready` and `Favours`.

## 8. Build tasks (each under 500 lines, one owner, the test red first)
| # | Task | Owner | Owns | The test (red on main first) |
|---|---|---|---|---|
| 1 | RANKTIE1: ours carry `BoutRules.fight_power` (no camp) as `rating` | Qwen | `Region.gd` (one line + helper), `tests/rank_tie_test.gd` | "ours with a higher power wins the tie" |
| 2 | MOODIDLE1: `month_no_fight` -6 on the 30th day without a bout | Qwen | `Roster.gd` (~15), `tests/mood_idle_test.gd` | "30 days with no bout costs 6 morale" |
| 3 | DATAFIX1: regional opponents' clubs inside the region | Qwen | `Data.gd` 66-185 club strings | `tests/data_clubs_test.gd` |
| 4 | HOLD1: names on our show's card are busy at the region's shows | Qwen | `Region.gd` `day_events` (~6), `tests/region_hold_test.gd` | "Erin on our card does not box on Sat 18 Jul" |
| 5 | Favours + WeighOdds (pure) | Qwen | `scripts/rules/Favours.gd` (~120), `scripts/rules/WeighOdds.gd` (~90), tests | "a stand-down costs one", "owed: yes -2 in 10", "64.9 of 65.0 misses on a head-cold week" |
| 6 | ShowCard + RankLine: tiles, conditional rank lines on `before`, pro offer from the show, swaps with prices | Qwen | `ShowCard.gd` (~320), `RankLine.gd` (~120), `tests/show_card_test.gd` | "Danny's ladder row: No. 3 only if Danny wins and Liam wins", "the novice tile: No. 3 if Liam beats Dean, else No. 4", "Lucy's ladder row counts only with a Lucy win over Maria", "Erin v Priya swap: a Lucy win is No. 3 both ways" |
| 7 | HOSTPROBE1 (pure, cloud) | Goose | `tools/host_probe.gd`, `ops/research/HOSTPROBE1.md` | section 9 bars |
| 8 | ClubShow v2: halls, two-part luck, followings, supporters, travel, posters, room reputation, main event, short night, comeback, `settle`, away line | Qwen | `ClubShow.gd` (~230), `tests/club_show_v2_test.gd` | "half-empty town hall costs 4", "a full gym's reputation adds no members" |
| 9 | HostShow state: book, asks, answers, posters, read, weight answers, stand down with our words, pull-outs, return bout written the Monday after, visiting bouts first, skills bout through BoutNight with no result, fight week as protocol 1 for `stale_energy` | Claude | `HostShow.gd` (~420), small edits `GymSpend.gd`, `BoutNight.gd`, `Bouts.withdraw_bout` (reason) | `tests/host_show_flow_test.gd` ("the pro offer comes on the night with a promise made") |
| 10 | Fights > Our show tab from screen_r3 | Cursor | `OurShow.gd` (~460) + `OurShowTiles.gd` (~300) | `tests/our_show_screen_test.gd` |
| 11 | Needs, top bar, Money row, People favours line, fighter NEXT BOUT, offers, the sheet, Why tile, Week review, News | Cursor | `Needs.gd`, `HomeNeeds.gd`, `ClubSpend.gd` edits; `ShowSheet.gd` (~300) | `tests/host_show_needs_test.gd`, `tests/show_sheet_test.gd` |
| 12 | Golden path (section 7) | Grok Dev | `tests/host_show_golden_test.gd` | walks it end to end |
Order: 1-4 now (they fix the world either way), 5, 7, then 6 and 8, 9, then 10 and 11, then 12. Discipline: boxing. Ships ON (`GameSwitches.GAME_ON`).

## 9. Probe bars (HOSTPROBE1, before any screen shows an ESTIMATE)
- Lucy's route: across (strong, weak, wants the nationals) x (favours 0, 1, 2 with Belfast Gloves) each of Erin as it is / with a favour / promise /
  Maria / Maria + swap / wait is best in at least one case and in no more than half.
- Favours: spending one best in no more than 3 of 4 asks; the swap best in no more than 2 of 3 cases.
- Samira: across margins 0.1 / 0.4 / 0.8 kg each of keep / harder / stand down best once.
- Danny: across (goal met, Steady) / (goal met, Flat) / (goal on the line) each tile best once (checked by hand in 6.3: novice / skills / off).
- Hall: no hall best for all three clubs (young 40/10, mid 58/24, grown 120/60); the town hall loses against away at least 1 night in 8 for the mid club.
- Every printed rank line equals `Region.rankings` after a replayed night in 1,000 seeds (no line printed as certain is ever wrong).
- The cut rule: any choice worth under $150 and under 1 reputation and under 3 in 100 of a pro offer is cut, not drawn.

## 10. What was rejected, and why
- Pay their travel $120 (round 2): $80 never binds against $11,400; always right below 9 in 10. Replaced by favours.
- The 3 x 3 hall and price grid (round 2): one price won in every hall. The price comes with the hall.
- A swap for Danny's ladder (Dean v Arjun): it buys a rank number with no prize at 4 wins; a favour spent on it is never right.
- Catchweights (a 57.5 kg novice at 59, a 66 kg Samira): booking matches weight class (product rule, WORKFLOW 5).
- A members' slot of skills bouts for families: needs juniors and adult members' bouts the game does not hold yet (`PER_JUNIOR` exists, the junior
  card does not); it comes with the youth section's map.
- Asking two names at once: R37 owns parallel asks; here one open ask per boxer keeps the 3-day clock a price.
- A reserve bout on standby: the outside novice already covers a pull-out at $80 on the day.
- "Make main event" as a choice (round 1), Change on every visiting pair (round 1), per-pair supporters, two outside novices: read-offs or under the cut.
- Host or not as a decision; shows every 12 weeks; pro cards, belts, TV; a BJJ bout on the card; choosing officials; bar and raffle choices.
- Morale -6 printed before MOODIDLE1: a cost the game does not apply.

## 11. Risks, said plainly
- Every number marked ESTIMATE (yes chances, win odds, the twist-card miss chance, followings, favours) is ours until HOSTPROBE1.
- The hold rule thins the region's shows in a division where our card takes four names (women's 60: only Priya and Maria free); rank movement slows.
- Judging the goal at a skills bout may feel harsh; the tile says it plainly, and the Handbook explains it is the same rule as any bout.
- Favours start at 1 with every club met: a player who never hosts never spends them; R37 uses the same ledger for asks.
- RANKTIE1 changes every rank tie in the game; tests that read ranks rerun with it.
- Three of our bouts in one night: "Sim to result" exists; the sheet must not wait for all of them.
- Cash: the night's costs ($3,060 here) land in a month with stipends; CashForecast must carry them.


# CRITIC ANSWER: DESIGN_HOSTSHOW1_CRITIC_JOHN_JOHN.md

# DESIGN_HOSTSHOW1_CRITIC_JOHN_JOHN - John answer (seat queue SQ75)

Brief: research/DESIGN_HOSTSHOW1_CRITIC_JOHN.md
Sent: 2026-11-13 21:10 | collected: 2026-11-13 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading the HOSTSHOW1 round 3 map against the pack now. The full critic return comes next.

# HOSTSHOW1 round 3 (S459): critic

Scores: depth **6/10**, general design **5/10**, play **7/10**. That misses the owner's bar on general design. I couldn't open `CRITIC_ACCESS.md`, the Miro board or `screen_r3.png`, because your computer is offline, so I judged from the map and the pack.

## Logic check

**Names outside headers: this breaks the S448 rule throughout.** Every tile and line identifies people by name:
- "Lucy wins N in 100"
- "No. 3 only if Danny boxes and wins and Liam wins"
- "counts only if Lucy boxes Maria and wins"
- "Priya Nair and Ellie Ward free: may meet"
- The Home notes "Priya Nair said no: ask for Lucy before the posters" and "Samira: weight answer"
- NEXT BOUT "main event v Erin Doyle" and "Asked: Erin Doyle"
- The read option "ANA SELLS"

A matchmaker screen has to say who, but the place for that is each card's own header, not the rows. "Ana sells" also assumes the gym has that athlete, which breaks the sandbox rule.

**The hall choice is dominated for this club.** The draw hardly depends on the hall: the community hall gets 220.6, and the town hall only 238.6 because of 18 extra visiting supporters. So the 120-seat gym floor sells out every night. Worked through the same way as section 6:
- **Gym floor:** 6 bouts, so 4 visiting pairs plus Laura and Erin makes 10 visitors at $40 = $400. Costs are $300 + $1,200 + $300 + $400 = $2,200. Takings are 120 × $35 = $4,200 plus about $1,000 of raffle. That's **+$3,000 every night, with +3 reputation for sure.**
- **Community hall:** +$2,990 likely, and +4 reputation only 36 in 100 times.
- **What the gym floor costs:** Erin's yes drops from 6 to 4 in 10. Lucy's pro offer goes from 0.6 × 0.45 + 0.4 × 0.33 = 40 to 0.4 × 0.45 + 0.6 × 0.33 = 38 in 100.

Two in 100 of a pro offer buys a sure full room. The raffle is a fixed $600–1,400 whatever the crowd, which makes the small room look even better. There's also no check that a 120-seat show with a ring fits on an opening floor of 22 places. And $35 is above your own [R] range of GBP 12–20 ($15–25).

**Favours are close to free.** Every clean bout against a club's boxer earns +1, home or away, up to 3. Four boxers at about 8–10 bouts a year is roughly 35 clean bouts against about six clubs. That fills every club to 3 within a season. Spending is about 2–4 favours a show, three shows a year. So "with a favour" beats "as it is" almost every time, and the swap is nearly always taken. The probe bars (a favour best in no more than 3 of 4 asks, the swap in no more than 2 of 3) will fail once the ledger fills. The earning rule has also drifted from R37's "a clean show with a club", and beating a club's boxer isn't goodwill in real life.

**Promising a return bout is nearly free for anyone not near the pro offer.** It gets the same 9 in 10 as a favour, and its only listed price is breaking it by turning pro. For a boxer with no pro chance (Samira, Danny), the hidden costs go unshown:
- The boxer's next bout is fixed for up to 12 weeks, and with one offer at a time, other offers are blocked.
- The rematch is away, on the opponent's terms.

**Danny's choice is built on a likely defect.** A conditioning goal "missed, −20" because a bout happened 2 days before its deadline isn't a coaching truth. It's `BoutNight` 426–432 judging every goal at every bout. The map turns that into the main price of the Danny tiles, so his three options become a read-off of one −20. Fix the judge, then give Danny's options real prices. The goal also reads "Conditioning +2.5", and Conditioning is a summary stat since S448; the goal should be on Stamina.

**The novice rule contradicts the Danny case.** The pack says a novice has 0–10 bouts. Liam is 7-5 (12 bouts), yet the map says "open after one more bout".
- If Liam is still a novice, Dean v Liam breaks the novice rule (Dean has 13 bouts), and Liam is a legal name for Danny. Then the outside novice and the skills bout shouldn't be offered ("only when the pool holds no legal name").
- If Liam is open, the line about the novice pool is wrong.

**The pull-out rate is a third of the real one or less.** The map uses 1 in 10 in the last week. My S449 sources found 25–50% of matched amateur bouts fall over in the final week. At real rates a 9-bout card loses 2–4 bouts, so a short night (under two-thirds of the card) becomes a normal outcome. Rejecting a standby reserve bout was decided on the wrong rate.

**Weight is judged against the wrong real-world rule.** The map keeps the code's day-before weigh-in and class-limit matching. England Boxing weighs on the day (rule 7.1.3, in my S449 note) and matches bouts within a gap of 2.5 kg at 57–65 kg. At a host's own show, 0.1 kg over is a talk between corners, not an automatic call-off. Samira's three answers are missing the real one: ask the other corner to accept.

**The card counts are one bout short.** The community hall card is 9 bouts: 2 of ours plus 7 visiting pairs means 16 visitors, $640 of travel and 48 supporters, not 6 pairs, $560 and 42. The town hall's 12 bouts with 9 visiting pairs is 11. Either the cards are smaller or the forecasts are wrong.

**The win bands look generous.** On the pack's measured curve (5 points better wins about 72%):
- Erin is 3 points above Lucy, so Lucy is about 37, not 45.
- Maria is 1 point below Lucy, so Lucy is about 54, not 65.

The order of the routes survives, but every printed figure should come from `BoutRead.band`, not from hand numbers.

**Undefined rules:**
- Whether the swap's "both say yes 7 in 10" is each club (so 49 in 100 together) or the pair.
- What MOVE DOWN does to tickets already sold at one hall's price.
- Whether a boxer can be kept free for the show between booking (8 weeks out) and the card opening (19 days out). Away offers arrive 8–12 weeks ahead and will land on the date.

## Depth: 6/10

**The real decisions:**
- **Lucy's route** is the best decision in the game so far. Six routes trade the yes chance, the win chance, rank conditions, the region's show, poster seats and favours, and waiting is a real option with a real price (no posters, one ask left).
- **Samira's weight** is a genuine trade in different coins. Worked out:
  - Keeping the cut is about +0.22 reputation and −0.17 favours on average.
  - The harder week is about +0.22 reputation and −0.04 favours, but costs about 1.5 morale more on average from the lower win chance.

**Where it breaks:**
- **The hall is dominated for any club whose draw beats the gym floor's seats.**
- **Favours fill up**, so their cost disappears and "with a favour" and the swap become the default.
- **Danny's three tiles** come down to one −20 from a defect.
- **At the ticket read,** "Ana sells" costs 1.1 on a BJJ syllabus move for $250, so it's always taken. Selling costs 2.6 mastery for $250 a boxer, which the cut rule lets through but which is almost never wrong.
- **Every tile prints the combined pro-offer number,** so once favours are free the route pick is a read of the biggest number.

It does connect to the rest of the game: rank, the pro offer, members against the room limit, cash, the region's table, and R37. That keeps it at 6.

## General design: 5/10

What it gets right: it's carefully wired to named code, it states its changes, and it follows the cut rule.

What pulls it down:
1. It breaks the owner's names rule on nearly every row.
2. It builds a decision on a goal-judging defect.
3. It uses a summary stat name.
4. The novice rule contradicts itself.
5. Two worked examples miscount the card.
6. It keeps a weigh-in and matching model that differs from England Boxing's.
7. It sets the pull-out rate well under the real one.
8. It leaves three rules undefined (how swap odds combine, MOVE DOWN, holding a boxer for the date).

It also has the heaviest build cost I've seen on a map: 12 tasks, about 2,400 new lines, and four world fixes first. The rank-line conditions ("No. 3 if Liam beats Dean (38 in 100), else No. 4") pile up as visiting pairs are added, which pushes against "only actionable information" and plain words.

## Play: 7/10

Hosting your own show is a strong fantasy, and the timeline gives a real build-up:
- the card opening
- a no landing
- the posters
- the region's show deciding a rank
- the read
- weigh-in, then the night and the sheet

A home main event that can bring the pro offer that night is a moment players will remember. It happens about three times a year, so it stays an event.

What holds it back: the 5 weeks between booking and the card opening are empty, and the sheet is mostly a recap.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Date (4 Saturdays) | Who can box, the region clash at ×0.8 | Keep. Add holding boxers free for the date. |
| Hall | Seats, price, yes chances, card size | Re-price (the gym floor dominates). |
| A name above | Rank, pro offer, +5 reputation | Keep. |
| A name below | Safe win, +3 reputation | Keep. |
| Outside novice / skills bout | A bout when there's no legal name | Keep, once the novice rule is consistent. |
| Wait for the region's show | Better information for no posters | Keep. |
| Not on the card | Training weeks | Keep. Needs a real price once the goal judge is fixed. |
| Ask as it is / with a favour | Yes chance | Keep, once favours are scarce. |
| Promise a return bout | 9 in 10 yes | Price the lock on future offers, or it's dominant. |
| Stand down | Seats, a favour | Keep. |
| Keep cut / harder week / stand down | Weight risk | Keep. Add asking the other corner to accept. |
| Ladder swap | Rank certainty | Keep. Define how the odds combine. |
| Read: keep / door / sell | Seats against pads | Keep. |
| Read: Ana sells | Seats against nothing | Useless as priced, and it names a person. |
| Read: move down | Undefined | Define it or cut it. |
| Read: cancel | Escape hatch | Keep. |
| Pull-out answers | Replacement | Keep, at the real rate. Add standby reserves. |

**Missing:**
- Hold a boxer for our show from booking day.
- Ask the other corner to accept a small overweight.
- Standby reserves.
- Earning a favour by service: boxing on a club's show at short notice, or hosting its boxers.

## To reach 10/10 (most important first)

1. **Make favours scarce.**
   - **Earn:** +1 only for a service, either our boxer taking that club's short-notice slot or boxing on its show away, or the club's boxer getting a bout on our card.
   - **Cap and lapse:** at most 2, and a favour lapses after 26 weeks unused.
   - **Probe:** at about 4–6 favours earned a year across all clubs, check that "as it is" is best in at least 1 of 3 asks.
2. **Price the promise.** A promised rematch locks the boxer, so no offers arrive until it's fought. The other club picks the date, 4–12 weeks out, and the tile shows "no other bouts until then". Breaking it costs −2 favours, as now.
3. **Fix the hall maths.**
   - The draw grows with the hall's reach: gym floor ×0.8, community ×1.0, town ×1.25 (ESTIMATE, to be probed).
   - Gym-floor seats are equipment places × 4 (88 on the opening floor), at $25.
   - The raffle pays per head, about $5 a seat sold.
   - The probe checks that each hall is best for one of the three test clubs.
4. **Fix the goal judge before using it as a price.** Stat goals are judged at their deadline, and only a "next bout" or "win" goal is judged at a bout. Then Danny's tiles carry real prices:
   - Boxing costs the fight week's taper (about 2.5 days of gains, from `Sim.daily_gain`), the 6% injury roll, and a stoppage's 30 days out.
   - Leaving him off costs the seats, the rank chance and, once MOODIDLE1 lands, the idle month.
   - The goal is written on Stamina, not Conditioning.
5. **Set pull-outs to the real rate, with standby reserves.**
   - Each invited bout falls over 25 in 100 in the final week ([R], my S449 sources).
   - The host can keep up to 2 reserves: an outside novice or a free regional name at $40 to stand by, with travel paid only if used.
   - A short night is fixed by a reserve or costs −2 reputation.
   - The fight week becomes the host's real headache, which it is in boxing.
6. **Make weight the England Boxing way.**
   - Weigh-in on the day, about an hour before boxing (rule 7.1.3).
   - A fourth answer, "Ask the other corner to accept": up to 0.5 kg over, −1 favour, a yes 7 in 10.
   - "Keep the cut" only risks the bout if that ask is refused.
   - This needs a day-of weigh-in for home shows, which the game can't do today (`Bouts.weigh` runs the day before).
7. **Keep a boxer free for the show.** From booking, each boxer's row has a toggle that passes away offers landing within 14 days of the date. The offer card says "held for our show".
8. **One novice rule.** Correct Liam's record or the novice text, and say whether Dean v Liam is legal and whether Danny has a legal name.
9. **Count the card properly** (ours plus visiting pairs). Fix 6.4 (7 pairs, 48 supporters, $640) and 6.11 (11 bouts, or 10 pairs).
10. **Take every win figure from `BoutRead.band`.** The hand numbers run 8–11 in 100 above the pack's curve.
11. **Names in headers only.** Each opponent and each of our boxers is a face card with the name in the card's own header. Rows say "the opponent", "your boxer", "the No. 2", "the name above". Home notes read "An opponent said no: ask again before the posters". The read option becomes "A no-gi athlete sells", priced as one no-gi class lost to its paying members, or it's cut.
12. **Define the rest.**
    - The swap needs each club's yes at 8 in 10, so 64 in 100 together, and the tile prints the joint figure.
    - MOVE DOWN keeps the tickets already sold, refunds any sold beyond the smaller hall's seats, and costs −2 reputation.
    - The gym floor needs a check that a ring and the seats fit the floor.
13. **Rank lines as one number.** Print "No. 3 or better: 56 in 100", with the condition tree on hover.

## The 10/10 page at 1920×1080 (Fights > Our show, 16 days out)

- **Header strip, 96 px:** the club crest, "Our show", the date circled in marker, the hall and its seats, ticket price, days out, and the timeline as magnets (asks close, posters and read, the region's show, the weigh-in on the day, the night).
- **Left column, 520 px: OUR BOXERS.**
  - One whiteboard row per boxer: face card with the name in its header, weight on the day against the limit, condition, morale, a hold toggle.
  - Under each, up to three route tiles: the opponent's face card with the name in its header; yes, win and rank lines as single numbers ("No. 3 or better 56 in 100"); pro offer from the show; seats.
  - How to ask: As it is, Favour (with "also half the swap" shown when that's true), or Promise ("no other bouts until then").
  - Weight answers on the row with a miss chance each.
- **Centre, 840 px: THE CARD AND THE LADDER.**
  - The bout sheet as cream paper: our bouts in red marker, visiting pairs in pencil, the main event boxed.
  - Beside it, the division table with arrows showing who our night and the region's show can move.
  - Ladder pairs highlighted, each swap with its joint yes and its price in favours.
  - Two reserve slots, each with a standby fee.
- **Right column, 560 px: THE NIGHT.**
  - A seats bar split into club, followings, posters and visitors, with the full and half-empty marks.
  - Money against the away line, with the likely, bad and good nights.
  - Reputation in parts, and members against the binding limit, with Add places.
  - The favours ledger: each club's chips, and what earns one.
- **Bottom strip, 120 px:** your assistant's note (portrait, one reason, no names in the text), Back to the coach's card, and the one pulsing button, **Send the asks**.
