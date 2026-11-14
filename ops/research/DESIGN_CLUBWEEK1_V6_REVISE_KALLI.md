# CLUBWEEK1_V6 - write the NEXT version of this mechanic's design map (S459 design loop)

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

# DESIGN_CLUBWEEK1_V5_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ87)

Brief: research/DESIGN_CLUBWEEK1_V5_REVISE_KALLI.md
Sent: 2026-11-14 01:11 | collected: 2026-11-14 02:11 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# CLUBWEEK1 v5: the club week for four, with the fight weeks inside it, and the season around it (S459)

Part 1 of 3

**Quoted owner rules carried in this map:**
- **Q-190 (S434/S435):** `"Just rename it 'gym sponsorship', the club pays."` What earlier drawings called `PAID SEAT` is `GYM SPONSORSHIP` (short: `sponsorship`), never mixed with Sponsor deals (`Club > Money`).
- **S448 (names only in headers):** `"notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"` — a person's name sits in a card or screen header once; rows, buttons, options, tooltips, Home notes and Why lines say `your boxer`, `the fighter`, `the grappler`, `a team-mate`, `your coach`, or `the opponent`.
- **S412 (sandbox):** `"the player runs any gym with any boxers, men or women."` Never write about one fighter as the story, and never use a fixed `he` or `she` in text or mockups.
- **S425 (menu wiring):** keep the table of every menu the mechanic appears on and what each is wired to.
- **S459 (bar):** must clear 6+ DEPTH and 6+ GENERAL DESIGN with fresh critics; mark which numbers are **ESTIMATE**; stay buildable from what the game has.
- **Owner's line-up & terms kept:** professionals in the line-up with an amateur-to-pro guide; staff named by role (`Coach`, `Coach's evenings`); `Stamina` for the endurance attribute (`Attrs.gd`, S448); amateur weights in **kg** (`57/60/65/75 kg` women, `57.5/60/70/75 kg` men). `"Coach"` is the hired assistant coach; `"You"` is the head coach (the player).

**Marks:** **CODE** = in the code today (file and symbol named). **ESTIMATE** = ours, verified by section 8 probes before UI ships. **NEW** = rule added by this map.

**Source status note:** Revises `CLUBWEEK v4.1` (`S432`) after `LOYAL1_RESULT.md` (`S461` Qwen probe + `S462` Claude rerun & direction), updated against the S403 critic pack (with S409, S410, S448, S451 additions). `CRITIC_ACCESS.md` and the Miro board were not opened directly.

---

## 0. Answer to `LOYAL1_RESULT.md` (S461) and Claude's S462 direction

| Probe finding / suggestion | Change in v5 (or one-line reason why not) |
|---|---|
| **Claude (S462):** `4 starters × 3 pads = 12 asked vs 8 owned` is structurally short every week; split into **NEED = 2** (`short` = under Need), **WANT = 3rd** (decided by deal order), real shortage on fight weeks (`+2`) | **Done (3.1, 3.8, 8).** Every evening slot is unified as an **evening place** (`8` owned: Coach 6 + Head coach 2; pad places for boxers, coached mat places for the grappler). Ordinary week: **Need = 2**, **Want = +1** (`3` asked). `4 × 2 = 8 Need == 8 owned` (0 forced short in ordinary weeks), while `4 × 3 = 12 Asked > 8 owned` (`asked > owned` 100%). Shortage and rotation now happen in **fight weeks (`+2` Need -> 10)**, **Peak camps (`+1` Need -> 9)**, and **class nights (`-2` owned -> 6)**. |
| **Qwen (`SHORTWEEK1`):** reduce `ASK["ordinary"]` to 2, OR raise owned to 12, OR lower holder threshold | **Solved cleanly via Need/Want split (3.1).** `NEED = 2` solves `SHORTWEEK1` (`COACH max run short <= 2`) without losing scarcity (`WANT = +1`, total `12` asked > `8` owned) and without inflating owned to 12 (which would kill the Coach's evenings money tension). |
| **Qwen (`LOYAL1`):** fix pad scarcity OR change `MOVES["short"]` (`-3` to `-1/-2`), `MOVES["full_week"]` (`+1` to `+2/+3`), or `LEAVES_UNDER` (`25` to `15/20`) | **Kept `short -3`, `short_running -6`, `full_week +1` (all Need covered), `LEAVES_UNDER 25`, and added `want_met +1` extra (3.1, 3.8).** With `Need = 2`, ordinary weeks grant `full_week +1` to all 4 fighters so `EVEN` stays `> 60`, `COACH` rotates fight-week shortages (`>= 50`), and `STARVE` drops **only** the starved fighter below 25 (`1` lost per seed, not 4). Re-measured in `LOYAL1` rerun (section 8). |
| **Pack alignment fixes (S412, S448, S450, S451):** remove names outside headers, pro class words on amateurs, `"Cardio"`, stale `"FireLevel switched off"`, and note `4` starter places vs `3` in `GymSlots` | **Done (1, 2, 3–7).** Starter names sit only in Create/Profile card headers; body text uses roles/pronouns; amateurs use kg classes (`57/65/75/60 kg`); `"Cardio"` updated to `Stamina` (`Attrs.gd`); `FireLevel ON` (`S450`) noted; `ClubStart` sets `STARTING_PLACES = 4` (**NEW**) at Unit 1. |

---

## 1. The idea in six lines
1. Four fighters stay at the club you take over in four weight classes: **one professional boxer, two amateur boxers, and one no-gi grappler** (`ClubStart` overrides Unit 1 places to **4**, **NEW**).
2. Every Monday, **Club week** deals three scarce pools across the squad: **evening places** (pad places for boxers, coached mat places for the grappler), **coached mornings**, and **gym sponsorships**; **Asked** (`Need + Want`) is always above **Owned**, and Coach's evenings can be sold as a second beginners' class instead (**the money lever**).
3. A bout stays on the same board: an amateur's **fight week** (`12` days' notice, no camp, `+2` evening Need) and a professional's **camp** (`4` or `6` weeks, `+1` evening Need in Peak) create the real shortages that drive deal-order choices.
4. **Favours** (`0–3`) are the second currency: earned by helping other clubs, spent to bend bout terms (never a win).
5. What lasts past the week (**NEW**): **loyalty** (short weeks under Need, promises, sponsorships), **fans** (home bouts build the crowd that funds the pro debut), and **one season target** per fighter.
6. No Monday repeats: job rotas shift, one club twist lands, a trial prospect visits every 4 weeks, and the opposing corner has had a week too.

---

## 2. The start (`Create, step 2`, names in card headers only)

All six starters sit in different weight classes so no pick blocks another. Each fighter's name appears **once** in their card header; card bodies use role, division, record, and that fighter's own traits.
- **ONE PROFESSIONAL** *(pick 1 of 2; new starter data: 9-win amateur offer cleared, `1-0` pro, licensed, unranked, carried-over amateur fans)*:
  - **Pro slot A:** women's `60 kg`, age 21, out-boxer, potential 84, **34 fans**, full sparring with Amateur slot A & D (**ESTIMATE**).
  - **Pro slot B:** men's `70 kg`, age 23, southpaw pressure fighter, potential 79, discipline 80, **22 fans**, full sparring with Amateur slot C; opens with second pro bout booked `6 weeks` out (**ESTIMATE**).
- **TWO AMATEURS** *(pick 2 of 4; weights in kg)*:
  - **Amateur slot A:** women's `57 kg`, `1-0`, college rota.
  - **Amateur slot B:** women's `65 kg`, `2-1`, shifts rota, loyalty `82`.
  - **Amateur slot C:** women's `75 kg`, `6-4`, office rota, loyalty `66`.
  - **Amateur slot D:** men's `60 kg`, `2-1`, shifts rota, loyalty `58`.
  *(Each card shows job rota, free mornings, sponsorship line, eligible sparring partners, fans, and `Recruit.ambition`.)*
- **THE GRAPPLER:** white belt, 2 stripes, cafe rota; already on roster; first open Sat 7 Feb.
- **Staggered opening:** the unpicked amateurs return on the trial mat; pro opens in camp, one amateur has a bout sheet (Sat 17 Jan), the other has an active goal. Loyalty starts from `Recruit` data (`58–82`).

**THE GUIDE IN WEEKS 1–5** *(step-by-step highlight; skippable; names never used outside headers)*:
1. **MEET THE FOUR:** badge (`PROFESSIONAL` / `AMATEUR` / `GRAPPLER`), season target, one key line.
2. **THE ROAD, AMATEUR TO PROFESSIONAL** *(adds fans + debut ticket forecast)*:
   - `"AMATEUR: 3 rounds, no purse. A home bout pays the club a $450 ticket cut and builds the boxer's own fans."`
   - `"THE OFFER: arrives at 7 wins with a top-3 regional rank, or 9 wins at any rank. A national finalist gets it at once."`
   - `"SAYING NO: returns after 2 wins at 90% terms; second no returns only at No. 1; third never."`
   - `"TURNING PRO: the club pays $1,105 (licence $230, medicals $875). Gym sponsorship stops; amateur bouts end."`
   - `"THE DEBUT: 4 weeks after signing, 4 rounds, paid from tickets: 100 tickets at $50 (20 family + boxer's fans + 25% of club members; under 60 pays nothing; boxer keeps half above 60, club takes 25% of that half)."`
   - `"FROM THE SECOND BOUT: purse ($1,500 unranked + $400 per place from No. 20 up), club keeps 25%; 6 weeks' notice and a camp; promoter brings three offers."`
3. **DEAL THE WEEK:** walks sponsorship -> pulls -> evening places -> bout sheet. 4. **ANSWER THE CALL.** 5. **START WEEK.**
*(After week 1 the guide names the trade, never the answer, and stops after the 3rd fight week.)*

**THE REVEAL ORDER (NEW):**
| Week | Arrives | Guide line |
|---|---|---|
| 1 | Evening places (`Need` vs `Want`), first bout sheet, season strip (locked to ambition) | `"Eight evening places, eight needed, twelve asked."` |
| 2 | Coached mornings; Coach's evenings: training or second class | `"A class pays the rent. Pads and mat work win bouts."` |
| 3 | Club twist, gym sponsorship, sparring setting | `"Hard sparring builds more and cuts more."` |
| 4 | Favours (first earned on sheet); loyalty bar appears and starts moving | `"Whoever goes under their need remembers it."` |
| 5 | Trial mat; season targets unlock; talk card can arrive | `"One target per fighter: the date every Monday works toward."` |

---

## 3. The week, as the player meets it

### 3.1 What is short (counters at top in ONE unit, `fighter-sessions`: `NEED / ASKED / COVERED / SHORT`)
- **EVENING PLACES (pad places for boxers, coached mat places for the grappler; `8` owned):** Coach works `3` evenings (`first hour` = existing `+$350/wk` members' class **CODE**; `second hour` = **2 evening places** OR **second class**, 3.1a). You hold **2** evening places on your own evening (`8` total).
- **NEED vs WANT split (NEW, answering `LOYAL1_RESULT` & S462):**
  - **Ordinary week (`BASE` / `BUILDING`):** **Need = 2**, **Want = +1** (`3` asked). Across 4 starters: **8 Need == 8 Owned** (no forced shortage), **12 Asked > 8 Owned** (`100%` of weeks have real prioritization).
  - **Amateur fight week (`12 days out`):** **Need +2** (total `4` Need, `5` asked). **Total club Need rises to 10+**, creating real shortages!
  - **Pro camp Peak week (week -2):** **Need +1** (total `3` Need, `4` asked).
  - **Trial prospect (`every 4 wks`):** **+1 Want** on the evening pool (doesn't force starter shortage; competes for Wants).
  - **Film evening:** takes **2** places (1 whole Coach evening) when chosen on the fight-week bill.
  - **Talk (`Wants a word`):** takes **1** of your own evening places (except `Tell it straight`).
  - **REST week:** **0 Need, 0 Asked** (frees 2 Need for teammates in fight weeks or class nights!).
- **What Need vs Want buys:**
  - **Meeting Need (`2`):** maintains skills/moves, avoids loyalty penalty (`full_week +1`, **ESTIMATE**).
  - **Going `SHORT` (`covered < Need`):** costs loyalty (`-3`, `-6` running, waived `1 week in 4` if `Loyal 70+`, **ESTIMATE**). Missing a **Want** (`3rd` place) costs **0 loyalty** — its cost is slower mastery/pull progress (`0.7` on 4th, `0.5` on 5th) and missing the `+1` extra loyalty from `want_met`.
  - **Holding pads (`Loyal 70+` & `6+` bouts):** `+1` pad place at `0.7` (`holder` loses own evening, loyalty `+3/wk`, max `4` wks running).
  - **Uncovered evening:** trains alone at mood rate (3.7) unless job rota blocks the evening.
- **COACHED MORNINGS (`6` owned: You 4, Coach 2):** 1 covers 1 fighter in full; 2 fighters on one morning share automatically at `0.8` each (`2` covered, not a choice). Alone trains at mood rate (3.7); discipline `<45` skips `1 in 3` alone mornings unless a teammate trains in the room.
- **GYM SPONSORSHIPS (`Q-190`):** 4-week block, **$1,000**, 6 free mornings/wk, removes job rota, loyalty `+5`. Amateurs & grappler eligible; pros cannot hold one. Block end (**NEW**): `Renew ($1,000, +2 loyalty)`, `Pass on (+5 to receiver, 0 lost)`, or `Let end (0 lost)`. Pulled early: `-8`. Potential `80+` unsponsored for 8 wks asks for one (`-3/wk` until seated or dated promise).

### 3.1a Coach's evenings: training or second class (**NEW**, money lever)
- **Choice:** each of Coach's 3 second-hours switches between **Training (2 evening places)** or **Second class** (`+$117` that night + `~1` new member per `4` weeks taught, **ESTIMATE**). Your own evening can also switch (`2` places <-> `+$117` + members).
- **Why it binds:** Selling 1 class night drops owned evening places from **8 to 6**, turning ordinary `8 Need` into **1 fighter short** unless offset by a `REST` week, a `Loyal` holder, or `COACH` short-rotation. `MONEYFOUR2` tests `1 sponsorship (-$100/wk) + 1 class (+$117/wk)` keeping the bank level.

### 3.2 What is dealt: each fighter's pulls
Priority warnings first: Scale (over limit inside 14 days), Fight (last 7 days), Rest (`tiredness >= 70` or hurt), Punished Habit (`6` of your own places). Then pulls with **size as a range** (**NEW**, measured by probes, colour-coded per currency, never mixed):
- **WEAK SPOT:** lowest of the `14` `Attrs.gd` abilities when `>= 3` below fighter level; from bout 3 opponent exploits it (`+0.25` per point under from round 2, unless covered by a plan line).
- **WEAPON:** stat gating next perk (`"Fast hands at Speed 70: ~4 wks"`).
- **GOAL:** active fighter goal (`+10` met / `-20` missed, **CODE**; bout/win goals judge on fight night, stat goals at deadline per `GOALFIX1`).
- **AHEAD:** next rival up the ladder and answers owned.
*(Pull asks `2` coached mornings, or `2` evening places for Ahead; sponsored holds `2` pulls, day-job holds `1`.)*
Three one-click deal modes: **By hand**, **Keep my changes** (keeps edits, updates rota/twist), **Coach deals it** (prints range delta `"Coach's deal: 2 to 3 in 100 below yours"`).

### 3.3 The rota that moves (dim, 1 line, non-clickable)
- **Shifts** (alternates early/late: earlies lose weekday mornings; lates lose weekday evenings), **College** (Tue/Thu mornings free, exam fortnight 2/wk, holidays all free), **Office** (weekday mornings gone), **Cafe** (every other Saturday). Pro `< top 10` keeps day job (or takes **Camp leave** in 3.9); top 10 trains full-time.

### 3.4 One club twist a week (**NEW**, deck of 12, replaces personal `WeekTwist`)
1 in 4 weeks quiet; never twice running; 2–3 priced answers hitting shared slots/cash/loyalty/favours (`Clock` waits for answer; Monday default = Coach picks):
- Coach off Wed (`-2` places / `$80` cover / senior holds both); Coach stays late Thu (`+2` places for `$60` / pass); Overtime on Sat (take it / ask them to train `-2` loyalty); Visiting pro spar (who gets it); Boiler out Thu (no mornings); Another club asks a kilo; Local paper photo (`+2` members, `1` place); Short-notice call (`+2` favours, no fight week); Sponsor photo (`$150`, `1` pro camp evening); Hall floods (Mon class off, `-$117`); Member's family pad session (`1` place, `+1` member); Quiet week.

### 3.5 Favours, the second currency
`0–3` dots per show club:
- **Earn:** `+1` box on their show / late replacement / sparring trip (`1` of your places) / give a kilo; `+2` 4-day short-notice call.
- **Lose:** `-1` miss weight / pull out (no penalty if *their* boxer pulls).
- **Spend:** `-1` ask a kilo / re-deal sheet / ask named opponent / move bout 1 wk.
- **One kilo rule:** over `1.0 kg` gap on fight day, ask `1` favour (`-1` asker, `+1` giver) for `+2` tank per `0.5 kg` heavier (`WEIGHTGAP1`). Never buys wins, judges, ranks, or places.

### 3.6 The squad changes, sparring and the grappler
- **TRIAL MAT (every 4 wks):** prospect visits 2 wks (`+1` Want evening place/wk). **`Watch`** sits on the trial card only (`2` coached mornings over fortnight -> exact potential, else ranges). Sign (`5th` fighter needs 2nd coach `$280/wk`, bigger unit, or 1 leaves) or Pass.
- **SPARRING (pair picker + setting on Club week, NEW):** `<5 kg` apart full both; `5–10 kg` lighter full / heavier half; `>10 kg` lighter `+10` tiredness. Setting: **Hard** (`×1.3`, `+12` tiredness, `4 in 100` cut), **Technical** (`×1.0`, `+6`, `1 in 100`), **Body only** (`Stamina`/body `×0.8`, `+8`, `0` cut). `SPARSET1` checks Hard `>= +1.5 in 100`.
- **THE GRAPPLER (no-gi, numbers in CODE unless ESTIMATE):** `3` classes/wk on cafe job (`NoGi.CLASSES_PER_WEEK`), `5` on sponsorship (`+6` tiredness each over 3); coached mat places come from the 8-place evening pool (`Need 2, Want 1`). Can give `1` boxer/wk a `0.8` coached `Stamina` morning (`-1` class). **Open division:** enter `White` (`~55 in 100`, gold `+2` no-gi members) or `Promote to Blue first` (`~35 in 100`, owes `BeltRoad.EARLY_DEBT`, `+3` members, unlocks **Teaching** `+$68/wk` + `~1` member/4 wks, `-1` class). Open shows **`Enter / Skip`** card; **`Who corners`** (`You` or `$100` mat coach) shows only if a boxer also fights that Saturday. Stripe calls (`StripeCall`) move loyalty on the shared scale.

### 3.7 Mood with teeth (**ESTIMATE**, `MOODRATE1`)
`Morale` (`0–100`: `Fired up 75+`, `Steady 50+`, `Flat 30+`, `Low <30`, **CODE**). Deal prices move **loyalty**, not mood.
- **Alone rate (no coach / no evening place):** Fired up `0.8` | Steady `0.6` (**CODE** baseline) | Flat `0.4` | Low `0.4` + skips `1 in 2` alone sessions & passes next bout sheet automatically (free, no favour).
- **Fight night corner trust (**CODE**):** `1.05` / `1.0` / `0.85` / `0.7` (Low stops listening).

### 3.8 Loyalty (**NEW**, `0–100`, `Loyalty.gd` + `LOYAL1`)
Bands: `Loyal 70+` (`"Loyal: can hold pads"` + `1` waived short week in `4`), `Settled 50+`, `Wavering 25+`, `Leaving <25`.
- **Moves (ESTIMATE):** `full_week` (all Need covered) `+1` | `want_met` (Need + Want covered) `+1` extra | `short` (covered < Need) `-3` (waived `1/4` if `70+`) | `short_running` (short 2+ wks running) `-6` | promise kept `+5`, broken `-12` | sponsorship given `+5`, renewed `+2`, pulled `-8` | holding pads `+3/wk` (max 4 wks) | ready sheet passed `-2` | target matches ambition `+5`, against `-5` | target met `+10`, missed `-5` | stripe call now `+3`, hold `-5` | overtime refused `-2`.
- **Talk (`<50`, `"Wants a word"`):** max once per 4 wks per fighter; takes `1` of your evening places except `Tell it straight`:
  1. **Give the place back:** dealt first next week, `+4`.
  2. **Dated promise:** pad/mat place, bout, or sponsorship by date (`+5` kept / `-12` broken; listed on `PROMISES OPEN`).
  3. **Tell it straight (free):** coachability roll (`+4` or `-4`, logged in `CoachNotes`; threshold hidden; `8`-wk cooldown).
- **Consequences:** `<25` after 2 talks -> leaves next Monday for Eastside ABC. Turning pro `<50` -> signs with outside manager (`10%` trainer share to club instead of `25%`, **CODE** `GYM_SHARE`).

### 3.9 Season targets & 3.10 Fans (**NEW**)
- **Season target (unlocked week 5):** Amateurs (`Nationals` / `Pro offer` / `Year to grow`), Pro (`Ranked`: 6-wk camp + step-up / `Busy`: 4-wk Light camp + tune-ups; optional **Camp leave** `$120/wk` last 2 wks if job kept `< top 10`), Grappler (`Medal` / `Blue belt`).
- **Fans:** Home win `+4`, home loss `+1`, away `0`, title `+10` (**ESTIMATE**). Debut sells `20 + fans + 25% of club members + 10/title` (`ProDebut` change); carries into pro `Matchmaking.fans` (tens on screen). `FOLLOW1` verifies always-away fails 60-ticket debut while always-home reaches offer 6+ wks later.

---

## 4. The fight week inside the club week
- **Bout sheet (amateur, 12 days out):** `Home` (`$450` cut, `+8` members, `+4` fans, or **Home on our own show** when `ClubShow` is booked — each home boxer brings `PER_HOME_BOXER 25` + fans), `Name above` (away, `-$40` travel, `+1` favour, takes rank up to `3` up), `Unknown` (away, `28`-pt band, opens file). **Pass** holds a name `7` days, costs `-2` loyalty; 2nd pass `-1` favour. **States:** `Ready` (sheets), `Building` (no sheets, `1.1×`), `Rest` (`2` wks post-bout, `0` evening Need, Light mornings, `+4` mood/wk).
- **Scale (4 pm fight day, `1.0 kg` gap):** over gap -> `Eat less` (`-1` tank/`0.1 kg`), `Train off` (no gain, `+5` tiredness/`0.25 kg`), `Ask a kilo` (`1` favour, `+2` tank/`0.5 kg`).
- **Fight-week evenings & bill:** `2` plan lines = `1` place, finish move = `1` per `4.5` mastery short, southpaw rounds = `1`, film = `2`, sharp last 3 days = `1`. **Legs** (`0–100`, tiredness over `50` + weight cut + recent bout, max `-25`). Shapes: `Rest up` / `Tick over` / `Train through`. Bill prints **ONE** range (`"Your week vs Coach's: +2 to +4 in 100"`) + top 3 levers (`Coach runs it` fills Coach's week). Pull-outs (`15 in 100`): replacement, another `Ready` boxer, or home.

*(Pro vs Amateur side-by-side table unchanged in rules from v4.1, using `Stamina`, `kg` classes, `Need +1` Peak camp, `$40` away travel, `+4` home-win fans, `Camp leave`, and `9` expected amateur bouts/yr.)*

---

## 5. Every decision (summary of Section 3 & 4 trades; `"Right when"` stays off UI)
| When | Decision | Options & prices | Probe / Right-when check |
|---|---|---|---|
| Create | Pro (1/2) & Amateurs (2/4) | Weight classes, sparring pairs, fans, ambition | Balanced spar partners & mix of near-pro + high-potential |
| Week 5+ | Season target | Nationals / Pro offer / Grow; Ranked / Busy; Medal / Blue | Matches bout window, bank runway & ambition |
| Monday | Deal mode | By hand / Keep my changes / Coach deals it | Coach deals it when within `1 in 100` |
| Monday | Coach's evenings (`NEW`) | Training (`2` places) vs Second class (`+$117`, `~1` member/4 wks) | Class when runway `<8 wks` or `REST` frees Need |
| Monday | Evening places (`8` vs `8 Need` / `12 Asked`) | `Need (2 / 4 fight wk)` vs `Want (3rd+)`; `Hold pads (70+)` | `COACH` rotates fight-week shortages (`<=2` run) |
| Monday | Sponsorship & block end | `$1,000 / 4 wks`; Renew / Pass on / Let end | Seat on high-potential with bouts; renew/pass by target |
| Monday | Coached mornings (`6`) | `1.0` solo vs `0.8` auto-shared | Solo on fastest-growing or Flat/Low |
| Monday | Pulls, Sparring, Twist, Talk, Trial | Sizes as ranges; `Hard/Tech/Body`; 12 twists; 3 talk answers; `Watch` on trial card | Verified by `WEAKFIND1`, `SPARSET1`, `ROTATWIST1`, `LOYAL1` |
| Sheet / Bill / Open | Home / Away / Rest / Bill / Ana's open | `$450`+fans vs rank+favour; `Enter/Skip`, `White/Blue`, `Who corners` | Verified by `SHEETDEAL1`, `FOLLOW1`, `TANKPRICE1` |

Part 2 of 3

## 6. Every menu it appears on, and what each is wired to (`S425` + `S448` names only in headers)

*(All rows, buttons, tooltips, and Home/Why notes below keep people's names strictly in card headers.)*

| Menu | What it shows (actionable only; names in card headers only) | Wired to |
|---|---|---|
| **Create, step 2** | Pro (1 of 2), Amateurs (2 of 4), Grappler fixed; spar links, job rota, free mornings, sponsorship, fans, ambition | `CreateScreen`, `ClubStart` (`STARTING_PLACES = 4`), `Data`, `Roster.sign_fighter`, `Recruit.ambition` |
| **The guide (wks 1–5)** | 5 steps; road strip with squad's own cards & fans; reveal order (`Need/Want` wk 1, classes wk 2, twist/sparring wk 3, loyalty/favours wk 4, targets/talks wk 5) | `GuideLight`, `GuideLines`, `FirstWeekStrip`, `FirstWeek`, `FirstHour`, `NextStep.STEPS`, `Roster.pro_ready`, `ProDebut` |
| **Fighters > Club week** | `THE SEASON` strip; unified counters (`Need / Asked / Covered / Short` in `fighter-sessions`: evening places, coached mornings, Coach's evenings class switches, sponsorships + block end, favours, trial mat); 4 fighter rows (header name only, badge, mood word, loyalty bar, job/sponsorship, diet Hold/Cut, pulls with range sizes, 7 days + sparring pair/setting); talk card + `PROMISES OPEN`; club twist; top 3 levers + deal delta vs Coach's; 3 deal buttons; `Start week` | `ClubWeek` screen, `ClubDeal` (`NEED`/`WANT`, shared evenings/mornings, class switches), `WeakSpot`, `JobRota`, `ClubTwist`, `Favours`, `TrialMat`, `Loyalty`, `SeasonTarget`, `SparSet`, `LeverSize`, `WeekPlan`, `PadWeek`, `CoachAreas`, `TrainRead`, `WeekPhase`, `GymSpend`, `Attrs`, `FighterProfile.mood`, `DuesLevers.CLASS_WEEKLY`, `SeasonPath`, `BjjSide`, `CoachNotes` |
| **Fighters > Find a fighter (trial)** | Prospect card (name in header only), stat ranges, `Watch` (`2` mornings), Sign / Pass, 5th-fighter requirement | `RecruitPanel`, `Recruit`, `Trial`, `Roster`, `GymSpend.place_blocked`, `TrialMat` |
| **Home** | One row per fighter (card link in name column only, open pull size, days to bout, `"Wants a word"` sticky); call deadline; sponsorship end | `Home`, `HomeRows`, `HomeNeeds`, `Needs`, `Loyalty` |
| **Fighters cards** | Badge (`PRO` / `AMATEUR` / `GRAPPLER`), loyalty word, sponsorship/job status, flag (`Fight week`, `Set camp`, `Wants a word`) | `Fighters`, `RosterCards`, `FighterCard`, `RosterFlag`, `CoachCheck`, `Loyalty` |
| **Fighter > Overview** | Season target + date; pulls (range sizes + buttons); weak-spot cost; `Stamina`; mood (alone rate); loyalty (last 3 moves, `"Loyal: can hold pads"`); fans + debut forecast; road strip | `FighterPage`, `DarkOverview`, `AttrBoard`, `Attrs`, `Duels`, `TrainRead`, `PerkRoad`, `NextStep`, `Loyalty`, `Fans`, `SeasonTarget`, `ProDebut` |
| **Fighter > Training** | Own slots at mood rate; shared slots locked (`"Change on Club week"`) | `WeekBoard`, `WeekEditors`, `WeekDay`, `WeekCards`, `SparSet` |
| **Fighter > Fight prep** | Amateur: fight-week bill with 1 range; Pro: 4-wk Light (`Busy`) / 6-wk (`Ranked`) camp, sparring setting, `Camp leave` | `FightPrep`, `FightWeek`, `LeverSize`, `Camp`, `CampCard`, `PeakCamp`, `CampForecast`, `SparSet`, `SeasonTarget`, `GymSpend` |
| **Grappler page** | 3/5 classes, drills + dates, mat morning, open division (`White`/`Blue` odds), teaching (`$68` + members), stripe loyalty, `Enter / Skip`, `Who corners` (if boxing clash) | `GrapplerPage`, `Grapplers`, `NoGi.win_chance`, `BeltRoad.EARLY_DEBT`, `BjjSide`, `BjjTree`, `BjjOpen`, `StripeCall`, `Loyalty` |
| **Fights (amateur)** | Bout sheet (3 cards: win band, rank, `$450`/fans or `-$40` travel, stoppage risk, file, Legs, kg/bouts); `Home on our own show` when booked; favour dots; `Ready / Building / Rest`; grappler's open card; compare view; `"Ask for this name: 1 favour"` | `Fights`, `OfferCard`, `BoutCompare`, `Bouts`, `Region`, `RankLine`, `OppFile`, `AmateurBooking`, `InjuryRoll`, `BoutSheet`, `Favours`, `Fans`, `ClubShow` |
| **Fights (pro)** | Promoter's 3 offers + ask beside amateur sheets; ticket money from fans | `ProFights`, `ProLadder`, `Matchmaking.pay_of`/`fans`, `StarDeal`, `Fans` |
| **Bout page: the bill** | Scale (`Eat less`, `Train off`, `Ask kilo`), fight-week evenings, `Legs` bars at first bell, bring `4 of 6`, **1** range (`Your week vs Coach's`) + top 3 levers, `Take / Coach runs it / Pass` | `BoutPage`, `FightWeek`, `LeverSize`, `BoutRules`, `BoutRead`, `PadWeek`, `PlanBoard`, `PlanLines`, `TaleOfTape` |
| **Tape room** | Question & answer (`best punch` / `habit` / `their week`); stale mark | `TapeRoom`, `OppFile`, `TapeClips` |
| **Playbook, Game plan** | `"Bring this line"` tick, opponent-seen eye icon, `"2 evening places short"` | `Playbook`, `GamePlan`, `GamePlanRows`, `PlanBoard`, `PlanLines`, `MoveMastery` |
| **Club > People** | Coach card (evenings as training/class, places count); 2nd coach (`"Opens 5th place"`); grappler as beginners' teacher from blue | `Gym`, `StaffCard`, `StaffRoles`, `CoachAreas`, `ClubDeal`, `BjjSide` |
| **Club > Money** | Class nights (`+$117` + members later); sponsorships (`4-wk` blocks); home cut vs away travel; own show `Home` cards; grappler teaching; pro share (`25%` or `10%`), camp bill & `Camp leave` | `Money`, `MoneyPanels`, `GymBills`, `GymSpend.pro_camp`, `CashForecast`, `StarDeal`, `DuesLevers`, `BjjSide`, `ClubShow`, `Membership` |
| **World > Rankings & Champs** | Regional & national ladders lit; club favour dots; nationals as fight weeks | `World`, `WorldLadder`, `Region`, `RankLine`, `ProLadder`, `NationalsView`, `Champs`, `ChampDraw`, `SeasonPath`, `SeasonTarget` |
| **Top bar & Continue** | Flags `FIGHT WEEK`, `SET CAMP` (pro only), `PRO OFFER`, `WANTS A WORD`; stops on pull-out, 4-day call, scale > gap, twist, sponsorship end | `Shell`, `Needs`, `Clock` |
| **Fight night & Why** | Day-of scale + kilo; corner choice; Why sizes (`"Legs: −9 tank"`, `"Give a team-mate the place back"`, `"Rest 2 wks"`), rank, fans, deal delta | `FightNight`, `WeighIn`, `Bouts.weigh`, `BoutNight`, `CornerTrust`, `CornerJobs`, `FightWhy`, `WhyCard`, `AftermathTiles`, `RankLine`, `Fans`, `LeverSize` |
| **Monday Week review** | Shortages vs Need (`loyalty` price + `"Give it back"`); month deal vs Coach's; trial read; targets met/at risk | `WeekReview`, `ReviewReveal`, `WeekActual`, `WeekCause`, `Loyalty`, `SeasonTarget`, `LeverSize` |
| **Pro offer** | Debut ticket forecast from fans, `$1,105`, share (`25%` or `10%` by loyalty), what ends, 3 no answers, road strip | `ProOffer`, `ProDebut`, `Roster`, `Matchmaking.pay_of`, `Fans`, `Loyalty` |

**THE NEW MECHANICS, MENU BY MENU (each verified in golden-path test):**
| Mechanic | Menus | Wired to |
|---|---|---|
| Evening places (`Need` vs `Want`) & Coach's classes | Club week counter; Club > People; Club > Money; Week review | `ClubDeal`, `DuesLevers.CLASS_WEEKLY`, `GymBills`, `CashForecast`, `Membership` |
| Mood with teeth | Club week alone cells; Training; Overview; Fights (`Low` auto-pass); Fight night | `FighterProfile.mood`, `TrainingWeek`, `BoutSheet`, `CornerTrust` |
| Loyalty (`Loyal` holds pads + `1/4` free short; `Tell it straight`; `PROMISES OPEN`) | Club week rows, talk card, `PROMISES OPEN`; Home; Fighters flag; Overview; Week review; Pro offer; Grappler stripe call | `Loyalty`, `FighterProfile`, `StripeCall`, `Roster.GYM_SHARE`, `Region`, `CoachNotes` |
| Season target (`Busy`/`Ranked` + `Camp leave`) | Club week strip; Overview; Championships; Week review; Create; Fight prep; Money | `SeasonTarget`, `SeasonPath`, `Recruit.ambition`, `ClubDeal`, `Camp`, `GymSpend` |
| Fans | Create; Road strip; Bout sheet; Overview; Pro offer; Why; Pro Fights; ClubShow | `Fans`, `ProDebut.tickets_sold`, `Matchmaking.fans`, `Membership`, `ClubShow` |
| Sparring pair & setting | Club week sparring cells; Training; Fight prep | `SparSet`, `SparNights`, `InjuryRoll` |
| Sizes as ranges & 1 bill number | Pull chips; Bill; `Coach deals it`; Week review; Why | `LeverSize`, `BoutRead`, `ClubDeal.coach_deal` |
| Grappler division, `Enter/Skip`, teaching | Club week row; Grappler page; Fights open card; Money | `NoGi.win_chance`, `BeltRoad`, `BjjSide`, `BjjOpen` |
| `Ready / Building / Rest` | Bout sheet; Overview; Why button | `BoutSheet`, `Aftermath` |
| Sponsorship block end | Club week sponsorship counter; Home; Money | `ClubDeal`, `GymSpend`, `Loyalty` |
| `Home` on own show & away travel | Bout sheet; Club > Money | `ClubShow`, `BoutSheet`, `Fans`, `GymBills` |

Part 3 of 3

## 7. The numbers (CODE / MEASURED / ESTIMATE)

- **MEASURED (four amateurs, `AMATEURPROBE1`, `MONEYFOUR1`):** `28` bouts/yr (`37` at 1–2 wk lead), `41` wins/100; gates `$12,600/yr`. Sponsorships over a year: `0` -> `$31k` (`+$270/wk`); `1` -> `1.9–2.9` mos runway; `2` -> `1.2` mos; `4` -> `80%` gyms close. Bout tiredness `45+` (`+10` stoppage, max `95`, `Aftermath.toll`). Planned lines fire `1/2` Usable, `3/4` Sharp, `1/1` Signature (`FireLevel` **ON since S450**). Good plan `59%`, none `45%`, bad `41%`; `+5` stats `~72%`.
- **ESTIMATE FOR THIS START:** 2 amateurs (~`9` bouts/yr each, half home): `~$4,200/yr` ticket cuts; `~6` pro bouts at `25%` of `$1,500` + tickets `- $90` camp bill: `$2,000–$3,000` (~`$6,000/yr` under 4 amateurs). Unsponsored all-training `+$150/wk`; 1 sponsorship `-$100/wk`; 1 class night `+$117/wk` + `~1` member/4 wks; grappler teaching (from blue) `+$68/wk` + members; away travel `-$40/bout`.
- **IN CODE TODAY (`S451`) vs v5:** `DuesLevers.CLASS_WEEKLY +$350/wk` stays as 1st-hour classes; 2nd-hour class (`+$117`) is **NEW**. `CornerTrust` + `NoGi.win_chance` kept; mood alone-rates & `Low` pass **NEW**. `Loyalty` expands from `StripeCall` to all 4 (`ClubDeal` + `GymShare`). `ProDebut.tickets_sold` swaps `2/win` for `fans` and halves member share. `WeekPhase.phase` sets `TAPER` 1 wk out for any booked bout (**CODE**). `ClubStart` overrides Unit 1 places (`3 -> 4`, **NEW**).
- **ESTIMATE status:** all `ClubDeal` Need/Want numbers (`2/1/+2/+1`), `Loyalty.MOVES` (`+1/+1/-3/-6`), mood alone-rates (`0.8/0.6/0.4`), sparring settings, `$117` class night, `$40` travel, `+4` fans, and twist prices are **ESTIMATES** gated behind section 8 probes.

---

## 8. Probes required before the build (on played bouts, never averages; UI waits for tables)

**THE CUT RULE:** any choice worth `<1.5` wins in `100` on a bout AND zero season effect (target weeks, bouts/yr, loyalty, cash) is cut, not drawn.

1. **`SHORTWEEK1` + `LOYAL1` (rerun with `Need = 2, Want = 1, Fight week Need +2`, 40 seeds × 52 wks, S462 Claude spec):**
   - `SHORTWEEK1`: `asked (Need + Want) > owned` in `>= 9/10` weeks (`>= 36/40` seeds); `COACH max run short (covered < Need) <= 2` weeks.
   - `LOYAL1`: `COACH min loyalty >= 50`; `STARVE` loses **1** fighter per seed (not 4); `EVEN min loyalty > 60`; `CLASS` (`1` class night/wk) tests real shortage/rotation pressure (`max run` & cash `+$117/wk`).
2. **`TANKPRICE1`:** best week vs Coach's `4–6` wins in `100`; best vs laziest `10–12`; no single job `>6`. Sizes finish-a-punch & southpaw rounds (kept only at `>=1.5`).
3. **`SEASON1`:** careful player vs `Coach deals it` -> pro offer `6+` wks sooner OR `2+` more wins/yr; fails if biggest-win bot wins the season.
4. **`ROTATWIST1`:** best deal differs from previous week in `>=3/4` weeks; no twist answer wins `>2/3` weeks.
5. **`FOLLOW1`:** always-away amateur reaches pro offer sooner but fails `<60` debut tickets; always-home sells `70+` but arrives `6+` wks later; mix clears both.
6. **`MOODRATE1`:** `0.8 / 0.6 / 0.4` alone rates + `Low` skip shift season training by `>=1` stat point over `4` Flat weeks.
7. **`SPARSET1`:** `Hard` vs `Technical` over 6-wk camp `>= +1.5` wins in `100`, with cuts costing `>= 1 in 20` bouts/yr.
8. **`WEAKFIND1`:** lowest-stat bot cannot beat mixed bot by `>3` wins/100 over a season.
9. **`SHEETDEAL1` / `WEIGHTGAP1` / `HOMELEAN1`:** no sheet card dominates all 5 lines (`1,000` sheets); `+2` tank per `0.5 kg`; close rounds lean home `7 in 10`.
10. **`MONEYFOUR2` + `PROCAMP1`:** `1` sponsorship + `1` class night/wk leaves club cash level over 52 wks; measures 6-wk camp cost on amateurs.

---

## 9. Build order, in small tasks

1. **Probes first (cloud, pure):** rerun **`SHORTWEEK1` + `LOYAL1`** (confirm Need=2 / Want=1 passes S462), then `TANKPRICE1`, `SEASON1`, `ROTATWIST1`, `FOLLOW1`, `MOODRATE1`, `SPARSET1`, `WEAKFIND1`, `SHEETDEAL1`, `MONEYFOUR2` -> emit `LeverSize` tables.
2. **Pure rules + unit tests (1 per task):** `Favours`, `JobRota`, `ClubDeal` (`NEED`/`WANT`, evening places, mornings, Coach's classes), `ClubTwist` (deck of 12), `WeakSpot`, `FightWeek`, `BoutSheet`, `TrialMat`, `Loyalty` (`full_week`/`want_met`/`short`/`short_running`, `Tell it straight`), `SeasonTarget`, `Fans`, `SparSet`, `LeverSize`.
3. **Wire rules & clean amateur camps:** remove amateur camp penalties/flags (`1.5`-pt loss, `Set camp`), align `GOALFIX1` (bout goals at bout, stat goals at deadline), `ClubStart` `4` places at Unit 1, retire `WeekTwist`, wire mood alone-rates.
4. **Start & data:** Pro A/B starter rows (`1-0`, licensed, fans), Amateur A–D kg rows (`57/65/75/60 kg`), `FirstWeek` 5-step reveal, `ProOffer` debut ticket forecast, `3` new rivals/weight, Saturday calendar.
5. **Screens (Look B whiteboard, S448 names only in headers):** `ClubWeek`, `BoutSheet`, `BoutPage` bill, `Fights` (pro + amateur), `Overview` loyalty/fans/target, `Coach` card, `Money`, `Grappler` page, `Why`.
6. **One golden-path test:** Create -> 5-wk reveal -> season target -> sponsorship renew -> class night -> fight-week shortage rotation (`short < Need` vs `Want` skipped) -> talk card (`Tell it straight`) -> Hard spar -> twist -> home/away bout -> bill + `Legs` + `4 pm` scale -> fight -> `Why` -> grappler `White` open -> pro camp + debut forecast.

---

## 10. Risks, said plainly

- **Build size:** 13 new pure rule modules, new start, new board — ships across several weekly milestones, gated on `SHORTWEEK1`/`LOYAL1` passing first.
- **Unifying pad & mat slots (`Need = 2, Want = 1`):** `LOYAL1` must confirm that putting the grappler's coached mat slots into the `8`-place evening pool keeps `COACH`, `EVEN`, `STARVE`, and `CLASS` in sweet-spot balance across all 52 weeks (`Ask = 12 > 8` while `Need = 8 == 8`).
- **Two meters (`Mood` word vs `Loyalty` bar):** keep strict visual separation (`Mood` word only; `Loyalty` bar only; every price names which moves).
- **Pro mid-game:** pro ladder after debut is largely unplaytested by the owner; first hour exposes any rough edges immediately.

## 11. Open for owner & code check
- **OWNER (data scope):** featherweight (`57 kg`) / middleweight (`75 kg`) amateurs turning pro need matching pro tables or starter restriction to `60/70 kg`?
- **OWNER (taste):** confirm pro keeps day job `< top 10` (with `$120/wk` **Camp leave**), cross-gender weight sparring allowed, and `STARTING_PLACES = 4` at Unit 1.
- **CHECK (Claude):** verify `Bouts` / `Aftermath` assume full opponent tank and `FightJudges` close-round home lean (`HOMELEAN1`).

---

## MECHANICS FOR THIS VERSION (closed set; post-probe cuts only)
1. **THE FOUR:** 1 pro (of 2), 2 amateurs (of 4), 1 grappler; `4` starter places at Unit 1.
2. **CLUB WEEK:** Monday board dealing evening places (`Need = 2, Want = 1`, `+2` fight week, `+1` Peak camp; `8` owned), auto-shared coached mornings (`6`), and 4-wk gym sponsorships (Renew / Pass on / Let end); `PROMISES OPEN`, diet Hold/Cut, `By hand / Keep my changes / Coach deals it`.
3. **COACH'S EVENINGS:** each switches between `Training (2 places)` and `Second class (+$117/night, ~1 member/4 wks)`.
4. **PULLS:** Weak spot, Weapon, Goal, Ahead — range sizes, colour per currency.
5. **JOB ROTA:** Shifts, College, Office, Cafe; pro keeps job `< top 10` (with Camp leave).
6. **CLUB TWIST:** 1 card/wk from deck of 12, priced answers.
7. **FAVOURS:** `0–3` per club; service-earned, term-spending, mutual `1.0 kg` kilo rule.
8. **TRIAL MAT:** 2-wk prospect every 4 wks (`+1` Want place/wk); `Watch` on trial card.
9. **SPARRING:** weight-based pair + `Hard / Technical / Body only` setting.
10. **MOOD WITH TEETH:** `0.8 / 0.6 / 0.4` alone rates, `Low` auto-pass, corner uptake (**CODE**).
11. **LOYALTY:** `Loyal 70+` holds pads & gets `1/4` free short week; `Need` met `+1`, `Want` met `+1`, `short (< Need)` `-3/-6`; talk (`Give back / Promise / Tell it straight`); leaves `<25`; `10%` pro share `<50`.
12. **SEASON TARGET:** Nationals / Pro offer / Year to grow; Ranked / Busy; Medal / Blue belt.
13. **FANS:** home bouts build debut & pro crowd (`+4` win, `+1` loss, `0` away, `+10` title).
14. **BOUT SHEET:** Home (local or `ClubShow`), Name above, Unknown (`-$40` travel); `Ready / Building / Rest`; regional rank.
15. **FIGHT WEEK:** `4 pm` scale (`1.0 kg` gap), fight-week evenings, film, 4-line hand, `Legs` bar, 3 shapes, opponent's `Legs`, corner choice, pull-outs, **1** bill range.
16. **GRAPPLER MAT:** 3 or 5 classes, mat morning, `White / Blue` open decision (`Enter/Skip`), teaching from blue (`$68` + members), stripe loyalty, conditional corner.
17. **PRO ROAD:** offer + 3 no answers, `$1,105`, ticket-paid debut, promoter offers, camp + Camp leave.
18. **GUIDE:** 5 steps wk 1, reveal order wks 1–5.

*(Left for later: `RPGLAYER1`, rival gym poaching, `HOSTSHOW1` full card-filling, living world, club season/year review, TV/belts, pro weight tables, show-night conditions, 10 novice bouts.)*


# CRITIC ANSWER: DESIGN_CLUBWEEK1_V5_CRITIC_JOHN_JOHN.md

# DESIGN_CLUBWEEK1_V5_CRITIC_JOHN_JOHN - John answer (seat queue SQ98)

Brief: research/DESIGN_CLUBWEEK1_V5_CRITIC_JOHN.md
Sent: 2026-11-14 12:11 | collected: 2026-11-14 12:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading CLUBWEEK1 v5 against the pack now. Scores, options, To reach 10/10 and the page come next.

# CLUBWEEK1 v5 (SQ87): critic

Scores: **depth 7/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

The idea is strong: four people share a coach's evenings, and the money lever (sell an evening as a class) pulls straight against the squad. What holds design down are rules that clash with the code, with real training and with each other.

- I couldn't open `CRITIC_ACCESS.md`, the board or the mockups, because your computer is offline, so I judged from the map and the pack.
- Names: the screens pass. One leak sits in the decision table in section 5 ("Ana's open"), so rename it "the grappler's open" before it reaches a label.

## Logic check

**1. The grappler can't draw from the boxing coach's places.**
- The 8 evening places come from your assistant coach (a boxing pads coach) and you (a boxing head coach, all four head-coach cards are boxing). The pack has a separate no-gi coach, paid by the class, and "who teaches" on the grappler's page.
- A boxing coach giving a coached mat place is not something a real gym does.
- Pooling the grappler is also the only reason "8 Need = 8 owned" works. Take the grappler out and the pool is 3 boxers × 2 = 6 Need against 8 owned.
- **Fix:** boxing places only.
  - Ordinary weeks then have 2 places of slack, while Want is 9 against 8, so one is still always short of its third.
  - One fight week fills the pool (8 against 8), and two fight weeks or a class night make someone short.
  - The grappler's classes come from the no-gi coach (code `NoGi.CLASSES_PER_WEEK`). The grappler competes with the boxers for your mornings, a sponsorship and your Saturday corner.
  - The scarcity survives, now with a reason behind it.

**2. Fight week asks for more evenings, but the code and real training ask for less volume.**
- Code `WeekPhase` makes the week before any booked bout TAPER: light, three rest days, no sparring.
- The best-supported taper keeps the number of sessions and cuts volume by 41–60% (Bosquet et al. 2007 meta-analysis, MEASURED). My S449 evidence matches: no sparring in fight week.
- So "+2 Need" (4 evening places in fight week) is double the work just when the boxer should do less.
- **Fix, same scarcity and true to life:** fight-week places are one-to-one.
  - The boxer keeps 2 sessions, the same frequency, each half the volume.
  - Each session takes the coach's whole second hour, which is 2 pool places.
  - Club Need still rises by 2, and the reason printed is "one-to-one in fight week".

**3. Ordinary weeks have zero slack, so every small event makes someone short, and two loops feed themselves.**
- With Need equal to owned, the "Coach off Wed" twist, a class night, a talk, or a film night each makes someone short.
- **The talk loop:** a talk takes one of your evening places, so loyalty under 50 brings a talk, the talk makes someone short, and that costs −3. The talk that's meant to mend loyalty causes a short.
- **The mood loop:** a Low mood fighter auto-passes the bout sheet (loyalty −2). A month without a fight costs −6 morale (CODE), so the fighter stays Low.
- **Fix:**
  - A talk uses no evening place. It costs your Monday attention: one talk a week for the whole club.
  - Low passes the sheet but doesn't pay the month-without-a-fight penalty while Low.

**4. Sponsorship costs don't add up.**
- A block is $1,000 for 4 weeks, which is $250 a week. Section 7 says "1 sponsorship −$100/wk" and MONEYFOUR2 tests against −$100.
- If the $150 gap is the stipend that sponsorship replaces, say so. Two payments to the same amateur (stipend $250 a week in the pack, plus sponsorship) are otherwise undefined.
- **Fix:** sponsorship replaces the stipend for that fighter, and the card shows "$250 a week instead of the $250 stipend: +$0 if the stipend was on, −$250 if off". MONEYFOUR2 then tests both.

**5. The "re-measured" claim isn't delivered.** Section 0 says the Need/Want split was "re-measured in LOYAL1 rerun", but section 8 lists that rerun as still required. Every Need, Want and loyalty number is an unprobed ESTIMATE.

**6. It clashes with the other S459 map for the same week (AMATEURWEEK1 v8).**

| | CLUBWEEK1 v5 | AMATEURWEEK1 v8 |
|---|---|---|
| Weight gap | 1.0 kg | 2.5 kg up to 65 kg, 5 kg above |
| Fight-week pull-outs | 15 in 100 | 35 in 100 |
| Weigh-in | 4 pm on the day | Code: the day before |

- On the weigh-in, the EB rule book (7.1.3) is with v5, but it's a code change, and the map should list it as one.
- On the gap, real club matching sits nearer 2 kg (Stevenage ABC). 1.0 kg will trip the scale far more than real shows do.
- One rule set has to win, and the other map points to it.

**7. What one "place" is isn't defined.**
- The code counts a pad night as 240 drill units over 75 minutes, one fighter. v5 splits the coach's second hour into 2 places, but never says how many units a place carries, so mastery can't be built or probed.
- Also undefined:
  - "0.7 on 4th, 0.5 on 5th" (4th what?).
  - Whether a pad holder counts as short when it gives up its own evening (+3 holding against −3 short).
  - The pro camp's Light, Standard or Hard nights (3, 4 or 5, CODE) against "Peak +1 Need".

**8. Coached mornings are listed as both a choice and not a choice.**
- Section 3.1 says two fighters on a morning share at 0.8 "automatically (not a choice)". Section 5 lists "Solo 1.0 vs 0.8 auto-shared" as a Monday decision.
- As priced, sharing always wins: 6 mornings shared cover 12 at 0.8, which is 9.6, against 6.0 solo.
- Either cut the line, or make solo worth it, for example solo counts as a Hard morning with no tiredness rise.

**9. The weak spot counts the stat twice.**
- The fight already reads all 14 abilities (`Attrs.gd`), so a low stat already costs.
- An extra +0.25 edge per point under, from round 2, charges it twice. WEAKFIND1 only checks one bot against another, not this.
- Also, the weak spot must come from abilities the fight reads. The pack keeps Explosiveness and Recovery "only if the fight really uses them".

**10. Words drift.**
- The same tired-body idea appears as "Legs", "tank", "tiredness" and Stamina.
- "Fighter > Training" should be "Week", the pack's tab name.
- "Fighters > Club week" is a new screen outside the seven approved menus, so it needs the owner's OK before any build (pack section 7).
- Set one word list: tiredness (0–100), tank (fight-night energy), Stamina (ability). Drop Legs.

**11. The guide overloads week 1.** Six dense money lines on the road to pro come before the player has dealt a single week. Show the road strip when the first amateur reaches 5 wins.

**12. Section 4's pro-against-amateur table is "unchanged from v4.1" but not included.** A fresh critic can't check it.

**13. Home and away is still unclear.** The pack gives the $450 ticket cut for every bout, and +8 members only for a win. v5 lists $450 and +8 members under Home only. Say what an away bout gives.

## Scores, with reasons

**Depth 7.**
- Four currencies pull against each other on one board:
  - evening places against class money;
  - sponsorship cash against loyalty and mornings;
  - home fans against away rank and favours;
  - one pro's camp against three amateurs.
- Choices reach past the week through loyalty, fans, season targets and the pro share (25% or 10%).
- Fight weeks give a rhythm: places are short before a bout and freed during Rest after it.
- Short of 8: shared mornings always win, Body-only sparring is nearly dominated, and the Unknown sheet card has no reward.

**General design 5.**
- It's buildable in modules, the probes come first, and the cut rule is the right discipline.
- What keeps it at 5:
  - It pools a boxing coach with BJJ.
  - Fight week asks for more volume against the code's taper.
  - The sponsorship arithmetic doesn't add up.
  - The re-measurement is claimed but not done.
  - It clashes with AMATEURWEEK1 on the gap, pull-outs and weigh-in day.
  - What a place is, is undefined.
- Points 1, 2 and 4 alone would lift it to 6.

**Play 6.**
- Monday has a real squad puzzle, a 5-week reveal, a trial every 4 weeks, and fans that make a debut feel earned.
- Holding pads, where a senior fighter helps a team-mate, is a gym moment players will remember.
- Two things drag it down. The board asks for about 12 decisions a Monday. The talk and Low-mood loops can make the club feel like it's punishing you.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Pick 1 pro of 2, 2 amateurs of 4 | Classes, sparring pairs, fans, ambition | Keep |
| Deal by hand / Keep my changes / Coach deals it | Who sets the week; the printed gap against Coach's deal | Keep. Make "Coach deals it" the one-click default |
| Coach's evening: training or second class | 2 places, or +$117 and about 1 member every 4 weeks | Keep. The best lever in the map |
| Evening places Need/Want | Loyalty and mastery | Keep. Boxers only (point 1) |
| Hold pads (Loyal 70+) | +1 place at 0.7 for a team-mate; the holder +3 loyalty | Keep. Say whether the holder counts as short |
| Coached mornings, solo or shared | Nothing: sharing always wins | **Useless** as priced |
| Sponsorship: give, Renew, Pass on, Let end | Cash, free mornings, no day job, loyalty | Keep. Fix the cost line |
| Pulls: Weak spot, Weapon, Goal, Ahead | Where mornings and places go | Keep. Remove the double count |
| Sparring: Hard / Technical | Gains, tiredness, cut risk | Keep |
| Sparring: Body only | Lower gain, no cut | **Nearly useless.** Make it the only setting allowed with an open cut or within 10 days of a bout |
| Club twist answers | Places, cash, loyalty, favours | Keep |
| Favours: earn and spend | Bout terms, never wins | Keep. Use one regional pool, as I said in AMATEURWEEK1 |
| Talk: give back / promise / tell it straight | Loyalty | Keep. Show the odds of Tell it straight from the visible Coachability, and use no evening place |
| Bout sheet: Home / Name above | Cash and fans against rank and favours | Keep |
| Bout sheet: Unknown | A wider band and an open file | **Useless:** no reward over Name above. Give it a sooner date or a +1 favour |
| Pass a sheet | Holds the name 7 days, −2 loyalty | Keep |
| Scale: Eat less, Train off, Ask a kilo | Tank, tiredness, a favour | Keep. Say who gets the "+2 tank per 0.5 kg" |
| Season target | Bout window, camp length, loyalty | Keep |
| Camp leave | $120 a week, the pro's last 2 weeks | Keep |
| Grappler: White or Blue first, Enter / Skip, Who corners, teaching | Odds, members, $68 a week | Keep |
| Trial: Watch, Sign or Pass | Exact potential for 2 mornings | Keep |

**Missing options:**
- **Cover for one night:** buy 2 places for $80, the twist's price, in any week. Today the only way to buy places is a second coach at $280 a week. It's the natural valve between cash and places.
- **Does a second coach add evening places?** Not stated. The pack says +1 roster place, +40 members and fitness classes.
- **A chosen rest week:** a "Rest this week" switch for a fighter (0 Need, +4 morale), not only after a bout.
- **Let a fighter go:** "1 leaves" for the 5th fighter has no button or price.
- **The stipend on the Club week:** Pay or Stop, beside sponsorship (point 4).

## To reach 10/10

1. **Boxing places only.**
   - 3 boxers × Need 2 = 6 of 8 owned; Want 9.
   - The grappler's classes come from the no-gi coach (per class, CODE), and its Need shows in its own counter.
   - Re-run LOYAL1 and SHORTWEEK1 on this pool and paste the tables into the map.
2. **Fight-week places are one-to-one.**
   - The boxer gets 2 sessions at half volume (TAPER, Bosquet 41–60%).
   - Each session takes a whole coach second hour (2 places), and the counter prints the reason.
   - No sparring in fight week.
3. **Define a place in code units.** One place is 120 drill units (half of `PAD_NIGHT_MINUTES` 240). A one-to-one fight-week place is 120 units at no sharing. Replace "0.7 on 4th, 0.5 on 5th" with a stated rule.
4. **Sponsorship replaces the stipend.** The card prints both lines, and MONEYFOUR2 tests with the stipend on and off.
5. **Break the loops.**
   - A talk costs no evening place (one talk a week for the club).
   - Low mood stops the month-without-a-fight penalty.
   - A holder isn't counted short while holding.
6. **One rule set shared with AMATEURWEEK1:**
   - weigh-in on the day, 1 hour before (EB 7.1.3), listed as a code change from the day before;
   - agreed weight ± 2 kg at club shows;
   - one pull-out rate, probed.
7. **Mornings:** cut "solo or shared", or make solo a Hard morning with no tiredness cost, and probe it.
8. **Weak spot:** drop the +0.25 per point edge, since the fight already reads the stat. Keep it as a pull that names which opponent style finds it. Use only the abilities the fight reads.
9. **Unknown card:** sooner date (7 days instead of 12), plus 1 favour.
10. **Add four options:** cover a night ($80, 2 places), a chosen rest week, let a fighter go (−1 week's stipend, −5 loyalty to the others), and the stipend switch.
11. **One word list:** tiredness, tank, Stamina. Drop Legs. Rename "Training" to "Week". Get the owner's OK on the Club week tab.
12. **Home and away printed on the sheet:**
    - Both pay $450.
    - Home: +8 members on a win, +4 fans.
    - Away: −$40, +1 favour, rank up to 3 places.
13. **Put the pro-against-amateur table back in, and move the road strip to 5 amateur wins.**

## The 1920×1080 page (Look B: Fighters > Club week)

**Shell:** a dark top bar (CONTINUE reads "to Mon 19 Jan, deal the week") and the left rail with Fighters lit, around a tan plaster wall with a whiteboard 1640×960.

**Counter strip (100) across the top, chalk numbers:**
- BOXING PLACES: Need 6 · Asked 9 · Owned 8 · Short 0.
- MAT CLASSES: 3 of 3 (no-gi coach).
- MORNINGS: 6 coached.
- SPONSORSHIP: 1 of 1, ends in 2 weeks.
- CASH: runway 14 weeks.
- FAVOURS: 2 magnets of 3.

**Left (300), the coach's evenings:**
- Three evening magnets (Tue, Wed, Thu). Each flips between "Pads: 2 places" and "Class: +$117".
- Your own evening magnet below.
- A "Cover a night: $80" sticky.

**Centre (980), four fighter rows of 200 each:**
- The header holds the name (the only place a name appears), the badge, the mood word and the loyalty bar with its last move.
- Seven day cells. Evening cells are red pad magnets, and a fight week shows a one-to-one magnet twice as wide.
- The pull chip with its range, e.g. "Speed to Fast hands: about 4 weeks".
- The sparring pair and setting magnet.
- The row's Need/Want ticks.
- The grappler's row shows mat classes in green, from its own coach.

**Right (360):**
- The club twist card with its two priced answers.
- The talk card ("Wants a word", three answers, with the odds for Tell it straight).
- PROMISES OPEN.
- The bout sheet card, if one is open.

**Bottom strip (110):**
- "Coach's deal: 2 to 3 in 100 below yours" in marker, with the top 3 levers.
- **Coach deals it** (the default), **Keep my changes**, then the red **Start week**.

## Sources (read 2026-11-14)
- [Bosquet et al. 2007, Effects of tapering on performance: a meta-analysis](https://pubmed.ncbi.nlm.nih.gov/17762369/), Med Sci Sports Exerc 39(8). A 2-week taper with volume cut 41–60%, keeping intensity and frequency (MEASURED, 27 studies).
- [EB Technical and Competition Rules 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf): 7.1.3, weigh-in 1 hour before boxing (OFFICIAL).
- [Stevenage ABC, weight and amateur boxing](https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing) (undated): no weight classes in club boxing, about 2 kg usual allowance (club practice).


# CRITIC ANSWER: DESIGN_CLUBWEEK1_V5_CRITIC_DOLA_DOLA.md

# DESIGN_CLUBWEEK1_V5_CRITIC_DOLA_DOLA - Dola answer (seat queue SQ97)

Brief: research/DESIGN_CLUBWEEK1_V5_CRITIC_DOLA.md
Sent: 2026-11-14 06:11 | collected: 2026-11-14 06:41 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.

(the brief is cut; her reply:)
.)
Show More
CLUBWEEK1_V5 — Mechanic Design Scorecard
(Judge: fresh critic — only the critic pack + design map above, no prior scores)
Scores — each out of 10
1. DEPTH — 8/10
Why:
Real, meaningful trade-offs across three scarce pools every week: evening places, coached mornings, sponsorships. The Need/Want split solves the earlier structural shortage problem cleanly — ordinary weeks have zero forced shortage but always have more requests than slots, so you are always prioritising. Fight weeks and Peak camps push the system into genuine shortage — that is exactly where depth lives.
No dominant strategy: selling a class night gives immediate cash but costs training slots; sponsorships remove job rota but lock an amateur in place for four weeks; sending someone to spar builds skill but increases fatigue and injury risk. Every choice has an opportunity cost you can see.
Excellent cross-system interaction: feeds directly into loyalty, fight readiness, fatigue, weight management, fans, cash flow, and eventually pro debut readiness. Decisions here echo across weeks and seasons — this mechanic is not isolated, it is the central rhythm of the whole game.
What holds it back: a few values are still ESTIMATE (loyalty move sizes, class income, mood alone-rates). Until those probes run, we cannot be 100% sure the numbers stay balanced long-term. Also, shortage pressure drops too low during Rest weeks — they free slots but don't create interesting redistribution decisions.
2. GENERAL DESIGN — 8/10
Why:
Clear, consistent language throughout — Need/Want, short/covered, blocks, renew/pass. Terminology is plain and stays consistent across every screen. Builds entirely on systems already in the game: the week loop, fatigue, loyalty, bout offers, money, mood. No weird new systems bolted on out of nowhere.
The Need/Want distinction is a masterstroke — it communicates how much someone needs this vs how much they want it in plain terms the player can act on immediately. No useless information on screen — every number is something you can change or that changes a decision for you.
Strictly follows the naming rule: all names live only in headers, body text uses "your boxer", "the fighter", "the grappler", "your coach". No violations found.
What holds it back: the 12 club twists are good but a few answers feel like "pick your penalty" rather than interesting trade-offs. Also, the grappler slot integration is solid but could be clearer — players may not immediately see that mat places come from the same shared pool as pad time. A couple of probes are still pending — until they pass, we cannot confirm every lever is tuned correctly.
3. PLAY — 8/10
Why:
Strong weekly rhythm: start with the board, see the needs, make the tough calls, watch it resolve through the week, see the impact on loyalty and fight readiness. Shortages in fight weeks create genuine tension — exactly when you need everything perfect, that's when resources are tightest. That tension is fun.
Meaningful progression loops: fans build toward the debut, loyalty builds trust and perks, sponsorships unlock longer-term plans, season targets give each fighter a clear purpose. There is always a reason to come back and do better next week.
The coach's deal gives a safe baseline — new players have something to fall back on, experienced players can refine every allocation by hand. Great onboarding without removing depth.
What holds it back: week-to-week repetition could feel routine after a while — the twist deck helps but 12 options may not be enough long-term. Also, the payoff for good decisions can feel slow — loyalty builds gradually, fans take time to matter. That is correct design but it may not hook everyone immediately.
Bar check: DEPTH 8 ≥ 6 ✓, GENERAL DESIGN 8 ≥ 6 ✓ — This mechanic is DESIGNED. ✅
Missing options, useless options, and what each option changes
❌ Which options are MISSING
Table
Missing option	Why it matters	Priority
Reorder fighters manually on Club Week board	You can't just drag to put your pro first — you have to work through the allocation logic	Medium
"Skip this fighter for one week" button	Rest weeks free slots but you can't voluntarily bench someone who's healthy just to shift resources — it's all-or-nothing Rest	Medium
See next 2 weeks' forecast shortages	You can't easily plan: "next week is a fight week — I should sell a class tonight and rebook it later"	High
Give a fighter a non-sparring partner	Sparring only has Hard/Technical/Body — no "light touch, just stay sharp" option	Low
Emergency one-off favour	Can't borrow one evening place from next week for a critical fight week — no "borrow one, pay back two"	Low
Set default allocation rules	Can't say "always give my pro first dibs on evenings" — you have to re-prioritise manually every Monday	Medium
⚠️ Which options are USELESS (or borderline)
Table
Option	Why it feels useless	Fix
Pass on a bout sheet without reason shown	You see the loyalty cost but not why it matters long-term — feels like an arbitrary penalty	Show: "Pass — loses 2 loyalty; next offer arrives in 2 weeks"
"Tell it straight" cooldown	Hidden 8-week cooldown — player doesn't know why it's greyed out	Show: "Available in 5 weeks"
Film evening	Costs 2 full evening places but the benefit feels vague — "opens one tell"	Make it clearer: "Film → reveals opponent's weapon or weakness immediately"
Pass on a sponsorship with no timeline	You don't see when it might come back or if a better one will appear	Show: "Next offer likely in ~8 weeks"
✅ What each option CHANGES — simplified
Table
Option	What it costs	What it gives	Long-term effect
Meet Need (2 places)	Nothing extra in ordinary weeks	Full training rate, loyalty +1	Steady progress, no friction
Meet Want (3rd place)	One teammate gets less or you sell a class	Faster mastery, loyalty +1 extra	Perks unlock sooner, fighter happier
Go Short	Loyalty −3 / −6 running	You save that slot for someone else	Slower gains → worse fight readiness → more likely to lose → fewer fans/money
Sell Coach's evening as class	−2 evening places (someone goes short)	+$117/night + ~1 member/4 weeks	More cash now → can afford upgrades/staff sooner; slower fight prep now → risk next bout
Sign sponsorship	No job income, tied for 4 weeks, pro cannot hold	+6 free mornings, removes rota conflict	Fastest stat gains; fighter unavailable for outside work; blocks other sponsors
Renew sponsorship	−$1,000 again	Loyalty +2, no disruption	Continued smooth training; cash outflow continues
Pass on sponsorship	0 cost	Loyalty +5 for the receiver	Someone else benefits; your cash stays higher
Let sponsorship end	No cost immediately	Free mornings gone, job rota returns	Cash pressure returns; fighter back to full availability
Give place back (talk)	−1 evening place this week	Loyalty +4 immediately	Builds goodwill now; short-term training dip
Dated promise	Must deliver or lose −12 loyalty	Loyalty +5 now	Goodwill now; heavy penalty if you miss the deadline
Tell it straight	Cooldown 8 weeks	+4 or −4 randomly	Honesty pays off or backfires — builds character flavour
Hold pads for a teammate	−1 of your own evening places	Loyalty +3/wk (max 4 wks)	Teamwork bonus; your own training slows a little
Rest week	0 Need, 0 Asked	Frees 2 slots for teammates; fighter recovers	Great safety valve; no progress that week
Enter home bout	No travel cost	+4 fans, +8 members, $450 ticket cut	Builds local following; opponent may be tougher
Enter away bout	−$40 travel, +1 favour	Rank opportunity	Progress faster; no gate money, fatigue cost higher
Skip grappler open	No entry cost	Save the evening place	Miss out on medal/membership boost
Enter grappler open	−1 evening place that day	+2–3 members, belt progress	Good gym exposure; possible loss hurts morale
To reach 10/10 — concrete changes, most important first
🥇 1. Run the pending probes and tune all ESTIMATE values
What: LOYAL1, SHORTWEEK1, MONEYFOUR2, TANKPRICE1, FOLLOW1, SPARSET1 — every number marked ESTIMATE needs measured data. Specifically confirm:
Loyalty penalties feel fair (short −3, running −6 — is −3 the sweet spot or should it be −2.5?)
Class nights actually balance cash vs training loss over 52 weeks
Fans → debut ticket numbers are achievable but not automatic
Why: Right now the structure is 10/10 but the calibration is 7/10. This is the single biggest gap — everything else is polish.
Build difficulty: Medium — it's running simulations, not new art
🥈 2. Add a 2-week forecast bar to the Club Week header
What: Beside the Need/Asked numbers show: "Next week: Fight week → Need rises to 10 — 2 short if you sell a class tonight"
Why: Players make better decisions when they can see the cost of tonight's choice next Monday. Right now the shortage sneaks up on you.
Build difficulty: Low — just reads future state from existing rules
🥉 3. Expand the club twist deck from 12 to 18 options
What: Add: Local club fundraiser (donation vs evening slot), equipment failure (bag/ring — repair cost or improvise), media interview (reputation vs 1 place), seasonal break (holiday — reduced hours, fewer places), guest coach visit (one fighter gets bonus training — who?), sponsor event (must attend or lose deal), illness bug (2 fighters down — redistribute or rest)
Why: 12 is enough for a few months but starts repeating. Variety keeps the mechanic fresh long-term.
Build difficulty: Low — just new text + price pairs
4. Show the "why" behind every loyalty change in the week review
What: Instead of "Loyalty −3" say "Loyalty −3 — didn't get the pad place needed 2 weeks running". Keep a 4-week visible log per fighter.
Why: Trust builds when the cause is clear. Mystery penalties feel unfair even when they're correct.
Build difficulty: Low — already tracked internally, just surface it
5. Add one "safety valve" option — borrow one slot from next week
What: Fight week looming, everyone needs that extra evening? Option: "Borrow one evening place — next week automatically one short". Visible cost upfront.
Why: Sometimes the perfect storm hits — 3 fighters all fighting on the same Saturday. Players should have the option to mortgage next week if they're willing to pay the price.
Build difficulty: Low — one new rule: borrowed = true → next week Need+1
6. Rest weeks should offer redistribution choices, not just free slots
What: When someone rests: "Rest — free 2 places. Redistribute to: [fighter A] [fighter B] [save for next week]"
Why: Rest weeks currently feel passive — you get the slots but nothing interesting happens. Make the player choose where that breathing room goes.
Build difficulty: Medium — new UI row + allocation logic
What the 10/10 Club Week page looks like — 1920×1080 layout
plaintext
┌──────────────────────────────────────────────────────────────────────────────┐
│  GYM NAME — CLUB WEEK — MONDAY 14 JANUARY — WEEK 6                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  THE SEASON  →  Your pro: 4 weeks to debut — 84 tickets needed            │ │
│  │  FORECAST → This week: Need 8 / Owned 8 — balanced  │  Next: Fight week — │ │
│  │  Need 10 → 2 short if you sell a class tonight                            │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                                                                │
│  ┌──────────────────────┐  ┌───────────────────────────────────────────────┐ │
│  │  EVENING PLACES      │  │  COACHED MORNINGS                              │ │
│  │  Need 8 / Asked 12   │  │  Owned 6 / Used 6                              │ │
│  │  Covered 8 — 0 short │  │  ┌─────────────┐ ┌─────────────┐ ┌───────────┐ │ │
│  │  ┌─────────────────┐ │  │  │Your boxer   │ │Your boxer   │ │Your grappler│ │ │
│  │  │Coach evenings:  │ │  │  │alone 0.6x    │ │shared 0.8x  │ │+Stamina    │ │ │
│  │  │[TRAINING 2→]    │ │  │  └─────────────┘ └─────────────┘ └───────────┘ │ │
│  │  │[CLASS +$117 →]  │ │  │  ┌─────────────┐ ┌─────────────┐              │ │
│  │  │Your evenings: 2 │ │  │  │Your boxer   │ │Your boxer   │              │ │
│  │  └─────────────────┘ │  │  │solo 1.0x     │ │shared 0.8x  │              │ │
│  └──────────────────────┘  │  └─────────────┘ └─────────────┘              │ │
│                            └───────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  GYM SPONSORSHIPS — amateur only, 4-week blocks                           │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                    │ │
│  │  │Your boxer    │  │Your boxer    │  │Available:    │                    │ │
│  │  │Active → Renew│  │None → Offer  │  │$1,000/4wks   │                    │ │
│  │  │[Renew +2 ♥]  │  │[Seat +5 ♥]   │  │              │                    │ │
│  │  │[Pass +5 ♥]   │  │              │  │              │                    │ │
│  └──┴──────────────┴──┴──────────────┴──┴──────────────┴────────────────────│ │
│                                                                                │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  THIS WEEK'S ALLOCATION — click a slot to change, drag to swap            │ │
│  │  ┌──────────────┬────────────┬────────────┬────────────┐                │ │
│  │  │ YOUR BOXER   │ YOUR BOXER │ YOUR BOXER │ YOUR GRAPPLER │               │ │
│  │  │ PRO • 60kg   │ AM • 57kg  │ AM • 75kg  │ NO-GI        │               │ │
│  │  │──────────────│────────────│────────────│────────────│               │ │
│  │  │Need: 2 ✓     │Need: 2 ✓   │Need: 2 ✓   │Need: 2 ✓    │               │ │
│  │  │Want: 3 ✗     │Want: 3 ✗   │Want: 3 ✗   │Want: 3 ✗    │               │ │
│  │  │Loyal: 76 ↑   │Loyal: 62 — │Loyal: 51 ↓ │Loyal: 68 ↑  │               │ │
│  │  │Fight week →  │Home bout   │Away +1 fav│Open Sat      │               │ │
│  │  │Need +2       │+$450 +4    │-$40        │White belt    │               │ │
│  │  │──────────────│────────────│────────────│────────────│               │ │
│  │  │Spar: Tech    │Spar: Full  │Spar: Light │Classes: 3   │               │ │
│  │  │Morn: Shared  │Morn: Solo  │Morn: Job   │Morn: Mat    │               │ │
│  │  │Evenings: 3   │Evenings: 2 │Evenings: 2 │Evenings: 2  │               │ │
│  │  │Pull: Weak    │Pull: Goal

Chat
Create Videos
Create Images
Writing
Homework
Translate
