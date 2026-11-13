# COACHFIT1_V5 - write the NEXT version of this mechanic's design map (S459 design loop)

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

# DESIGN_COACHFIT1_V4_REVISE_DOLA_DOLA - Dola answer (seat queue SQ74)

Brief: research/DESIGN_COACHFIT1_V4_REVISE_DOLA.md
Sent: 2026-11-13 21:10 | collected: 2026-11-13 21:40 by Tools/seat_queue.py (the 30-min reconcile)
(Dola's whole fresh chat: the brief, then her reply)
Verify the sources before using it.

---

Dola
New Chat
Ctrl N
Scheduled Tasks
Ctrl Shift T
AI Creation
Drive
New
Ctrl Shift D
Skills • Connectors
Ctrl Shift S
Drafts
New Chat
Pinned
Main chat
Projects
Fightcamp
fighter personalities
Fightcamp
Fighter Personalities
Recents
CoachFit1 v3 Mechanic Revision
Training Scene Game Critic Score
Training Scene Game Criticism
Training Scene Game Critic S457
Training Screen (Training Game S456) Criticism
Training Game Screen Criticism
Training Screen Game Criticism
Training Screen Criticism for Game S455
Training Screen Criticism (S454)
Training Screen Game Criticism
Training Screen as Game Criticism
Coach Coaches Mechanic Design for FightCamp Game
Amateur Fight Week Design for FightCamp Game
Amateur Fight Week Design for FightCamp
3D Boxing Motion Capture
FightCamp Pro Show Design
Animation Rebuild Design
FightCamp BJJ Design V5
BJJ Fight Design
FightCamp Design Update
Character Look-Dev Research
FightCamp Training Goals
Miro Board Discussion
REA Profitability
Proto Boxing Animation
Freelancer Planner Review
Recommended Tasks
CLIPREVIEW1 Motion Review
Espresso macro photo
Day Plan Modules
Day Plan System
1
Gym Floor Mechanics
K C908
CoachFit1 v3 Mechanic Revision
Generated by Dola AI
COACHFIT1_V4 - write the NEXT version of this mechanic's design map (S459 design loop)
You are the designer. Read the whole game (critic pack below), the current map, and the critics' answers at the end. Write
the next version of the map in full (not a diff): answer EVERY point of each critic's 'To reach 10/10' list (do it, or say
in one line why not), keep every rule the owner agreed (quoted in the map), keep it buildable from what the game has, and
keep the map's table of every menu the mechanic appears on and what each is wired to (owner S425).
The bar it must reach with fresh critics: 6+ DEPTH and 6+ GENERAL DESIGN (owner S459). Numbers: say which are ESTIMATES.
Plain words; names only in headers. Return only the new map, starting with its title line.
Also read ops/research/CRITIC_ACCESS.md: the Miro board, the real screens, the mockups.
Also read ops/research/CRITIC_ACCESS.md: the Miro board, the real screens, the mockups and the eight MMA fighters. Written S403 from the code; update it when a mechanic or screen lands.
What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with To reach 10/10: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.
FightCamp critic pack: the whole game, for judging whether a screen has the right options
Owner's rule: "i want every screen you design to have the right options so every critic needs to know the whole game design and mechanics to guide you".
This pack is facts only: no scores, no verdicts, no earlier critic comments, and nothing that is merely proposed. Written 2026-11-08 from the code
and the agreed plans. Where a document and the code disagree, the pack says what the code does.
How to read the status tags:
BUILT = it is in the game now and a player can use it.
AGREED, NOT BUILT = the owner approved it (or a plan he approved includes it) but the game does not do it yet. Judge a screen as if it will exist.
PARTLY = some of it is in the game; the pack says which part.
NOT ESTABLISHED = the pack could not confirm it from the code or the plans. Do not assume either way.
Names only in headers (owner S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"): a person's name sits in the screen's header once; options, buttons, rows, lines and tooltips say her / him / the opponent / your coach. Flag every name you see outside a header.
A screen should offer an option only if the player can act on it (rule in section 7). "Option" below means anything the player can press, drag, pick or type.
1. What the game is
A boxing gym management game for PC (Godot 4.7, Windows). The player is the head coach and owner of one small boxing club. Not a promoter, not a fighter,
not a tycoon. The club lives on members who pay monthly dues; a fighter's bouts add ticket cuts, reputation and new members.
Scope for the first release: boxing and no-gi BJJ (the owner decided BJJ ships beside boxing). MMA comes in the first update after launch. Kickboxing and
Muay Thai are not scheduled. Early Access is the target; no date.
The player controls: whom to sign and which starting focus; the coaches and staff hired; the week of training for each fighter (mornings, pad and sparring
evenings, diet); which bouts to take or ask for; the camp before a bout; the game plan written as lines; combinations built and drilled; the corner calls
and corner minute on fight night; the fighter's next goal; the club's money (dues, spending, deals, upgrades).
The player does NOT control: the punches thrown. The fight is settled by rules (exchanges of 30 seconds); the 3D fight only shows the settled round and
never decides. The player also does not control fighters' moods directly, rival fighters, the weather/twist cards, injuries, or when offers arrive.
The fun, in the owner's and the design's words: raising an unknown into a champion; the plan is the star; you can always see how your plan made the
difference (the Why after every fight); every week costs something (training, weight, fatigue and money pull against each other); fighters are people
(traits, habits, moods); fast and honest (anything one click from anywhere, true numbers). The three core mechanics beside the corner (owner S354):
the morning sessions that add up to a goal and an intensity (the week), the evening move and combination planner, and a fight plan that is fun to design.
The Playbook/Combos area is the part the owner calls really fun ("to try and also learn from the book").
Design rule on results: the better-trained fighter usually wins; a good plan turns close fights and gives underdogs a real chance. Measured in tests:
good plan about 59% of bouts, no plan 45%, bad plan 41% (one matchup). Training beats planning: 5 points better in stats wins about 72%, 10 points about 95%.
Not mobile, not casual: no timers, gacha, daily rewards or ads. Real stats stay visible. Deeper, not wider (owner approved "build all proposed systems").
Tone: a gym, warm and tactile, not a spreadsheet. Plain words, one word per concept, no flavour text.
2. A career from the first minute to the first pro fight
Time model: the clock runs day by day when the player presses the big CONTINUE button. It stops by itself every Monday (the week review) and for
anything that needs the player (a bout offer on its last day, weigh-in, fight night, injury choice, trial day, walk-in). Day 0 is Monday 5 January 2026.
The button says what it is stopping for ("to Thu 15 Jan, the offer expires"). Quiet week = one click.
Title screen: Resume career (if a save exists), New career, Quick start (a ready club, London), Load career, Settings, Credits, Quit.
New career, two steps. Step 1 YOU: your name and one of four head coaches on photo cards (Old hand, Ex-pro, Amateur coach, Strength coach), each with one
edge. Step 2 YOUR CLUB: country, city, gym name, and one of three starts that double as difficulty: Fresh doors (normal), In debt with one good boxer (hard),
Backed with big expectations (risky). A switch lets the player skip the first-hour guide. Quick start takes the first coach card and Fresh doors.
Day 0, Home: the first-hour card (the job: keep the doors open; the first show date; who you are), a walk-in fighter waiting at reception (Lucy Jackson in
the standard start; other starts and the male-boxer start use other names). The guide strip runs three stages: FIRST WEEK (sign, coach, week, go),
FIRST FIGHT (offer, prep, fight), THE CLUB (second boxer, bouts for both, set the first boxer's next goal). It can be skipped.
Sign the walk-in: an RPG-style card (class from style, potential in stars, each attribute's ceiling, two traits, one habit, a signature move, an
ambition) and ONE starting focus. Hire an assistant coach (Luke Reid sessional $450 a week, or Marcus Hale full-time $1,090 a week; $1,000 signing fee).
Without any coach, training runs at 60%. Open the Week and lock in week 1 (the coach has already written a week). Press CONTINUE.
Monday of week 2 (day 7): the first bout offer arrives, for the club show on Saturday of week 4 (day 26). Until the first bout is fought there is no twist
card and no ask. She starts about 1.4 kg over the limit, so weight is the first real decision (a cut needs starting in week 1). Accept shows a poster
reveal and offers the camp.
Fight prep: camp (focus, intensity, partner, film), game plan, weigh-in the day before, fight night, result, Why, goal talk. After the first bout: a second
walk-in arrives the next Monday, a rival coach (Frank Doyle, Eastside ABC) is named in the news, three club tasks appear on the guide strip, and Ana (the
no-gi athlete) is teased, then asks to join after the club's second bout or by week 9.
The loop afterwards: offers every couple of weeks (a club show every other Saturday from day 12), camps, nationals, money pressure, more fighters.
Amateur road: the National Amateur Championships. Entry needs 5 bouts and 3 months registered, age 19-40; entries close in week 10; a London regional then a
national draw. While in it, no other offers come. A loss, injury or missed weight ends the run.
Turning pro: a promoter's offer arrives at 7 wins with a top-3 regional rank, or at 9 wins at any rank. The debut is 4 rounds, about 4 weeks after signing.
The gym pays the licence ($230) and, the first time, medicals ($875) and the trainer's licence ($140). Stipend stops. After the debut a pro joins a world
division table unranked and the promoter brings three offers per fight (see 4.12). Older docs said "the game ends near the first pro fights"; the code
goes further (pro ladder, belts, ageing, retirement), see section 8.
The club failing: 8 weeks in a row below $0 closes the gym. A closed gym shows a summary that cannot be dismissed (New career / Load career / Title).
3. The fighter: three layers
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
Boxing: 7 trained stats: Power, Hand speed, Technique, Defence, Conditioning, Ring IQ (fight IQ), Chin; plus Footwork (derived from speed and defence) and
the personality values Heart, Discipline, Confidence, Coachability, Temper (Loyalty exists but is not on the board). Amateur women's lightweights sit 55-65;
bands: weak under 45, fair under 55, solid under 65, strong under 75, elite above. Each stat has a potential ceiling ("tick") and a weekly delta.
Moves with mastery (0-100): Jab, Cross, Lead hook, Body hook, Uppercut, Check hook; from 30 a move is a "weapon" the fight can use. Combinations (the
book: 1-1, 1-2, 1-1-2, 2-3, 1-2-3, 1-2-3-2, 3b-3, 1-2-3b, 1-6-3, slip 2-3) unlock when their moves are weapons; players can also build their own.
Body: weight vs class limit, condition (fatigue word), injuries. Style word (Out-boxer, Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher,
Slugger). Stance. Age. Record. Rank in the region.
Personality and habits, learned not shown as numbers in the ring: 6 traits (heart, temper, confidence, discipline, coachability, loyalty) and habits
(for example drops the right after the jab, slow starter, fades late, chases stoppage). A coach's-notes card fills in with words from fights and sparring.
Morale (stored 0-100): Fired up (75+), Steady (50+), Flat (30+), Low. Moves: win +8, loss -12, goal met/missed, rest week +4, a month without a fight -6,
bout booked +5, wrong corner call -2, right call +1. Morale is also trust in the corner: Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7 of the corner's
word taken in; a Low fighter stops listening.
BJJ athletes have 6 stats (strength, cardio, flexibility, explosiveness, composure, aggression) and mastery per move; belts, not ranks.
Perks (the perk road): open for good when attributes reach a need, each changes one thing in a bout: Iron chin (Chin 70), Stiff jab (Technique 65),
Second wind (Conditioning 70), Ring general (Ring IQ 65, corner calls work 25% better), Counter sense (Defence 65 + Check hook weapon), Body snatcher (Body
hook weapon), Finisher (Power 70), Fast hands (Hand speed 70).
4. Every mechanic
4.1 The week and training plan - BUILT
Choice: for each fighter a week of seven mornings (a session each: roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow, neck work, or rest;
each at Light, Normal or Hard) and seven evenings (Pads, Sparring, Rest, Film). The coach writes the week from the camp phase and repeats it; the player edits
exceptions (click a day, a popover). "Back to the coach's week" resets. Diet: Hold or Cut 500 kcal a day.
Phases counted back from a booked bout: BASE (no bout), BUILD (3+ weeks out), PEAK (2 weeks out, hardest, sparring twice), TAPER (fight week: light, three rest
days, no sparring).
Changes: each morning adds a small amount to one stat (pace 1.0 per focused week x coach factor x headroom clamp((potential-stat)/25, 0.10, 1.25), a morning
is a fifth of it, Light x0.6, Hard x1.3, less when tired); kcal and weight; fatigue (0-100, "Week tiredness"; from 80 she is overreached: gains x0.6 and
injury risk x3). The Week tab shows plan totals, the goal line, the coach's one change with a "Do it" button, and the weeks to fight night.
Coach factor: 0.5 + rating x 0.7 per cent; no coach = 60%. Strength coach head-coach edge: body mornings +10%, craft mornings -10%.
Twist card: once a week the coach draws one (sore wrist, rain, weights room shut, partner ill, head cold, visiting pro, quiet week; or a choice card such as
tight knee, scale will not move, night off, heating breaks, combo clicking, southpaw in town, old coach visits, sponsor photoshoot, rival talks trash). Two
answers each with a visible price; unanswered = the coach's pick on Monday. Planned vs actual is shown on the review.
Training load: acute vs usual load; a spike (ratio 1.5+) raises injury risk 2-4x.
Two fighters in camp competing for the coach's pad nights: AGREED, NOT BUILT (see 4.2).
4.2 Pads, combinations and mastery - BUILT (pad nights for two fighters AGREED, NOT BUILT)
Evenings are nights that carry drill cards. A pad night is 75 minutes split over its cards; a sparring night gives every card already in her hands a share.
Standard week: 3 pad nights; camp 2+1 / 2+2 / 3+2 pad+spar for Light/Standard/Hard.
Choice: drag a drill card (a move or combination) onto a pad night; split a night 50/50, 70/30, 30/70; remove or clear; pin cards in the tray; "+ drill it".
Mastery gain per hour of drilling: pads 2.1, heavy bag 1.05, shadow 0.85, sparring 1.5, speed bag 0.9, double-end bag 1.2. Undrilled moves fade slowly.
A drilled combination also holds its punches. Tiers: New, Raw (under 30), Usable (30), Sharp (60), Signature (85). A move at 30+ is a weapon.
Today a planned line fires every time once it is usable; sharp is worth about 1 win in 100 over usable. In the game but SWITCHED OFF (S427,
measured on 400 bouts a cell): a planned line fires 1 use in 2 at usable, 3 in 4 at sharp, always at Signature (sharp then +2.8 wins in 100
over usable, Signature +2.7 over sharp). Also measured and NOT in the game: an opponent's corner waiting for your best line (costs 7 wins
in 100, no answer wins back more than 3.7).
A combination in a fight costs energy (longer costs more); a flurry is limited by hand speed and tiredness; a signature (drilling, not length) may run one
punch past the speed cap. Own combinations built in the Playbook (Combos tab) get their own pad mastery.
AGREED, NOT BUILT: with two fighters in camp the coach's pad nights are shared; the top row of "Learn on the pads" shows how many go to each (cost to the
other fighter), only while two are in camp; a needs flag says when the second camp starts.
4.3 Fight camp - BUILT
Opened by "Set camp" (a need once a bout is 3+ weeks off, or from Fight prep). Choices: camp focus (one of Conditioning, Power, Technique, Defence, Speed);
intensity Light / Standard / Hard (3, 4, 5 nights; focus multiplier 1.1/1.2/1.35; fight-night edge +0.25/+0.6/+1.0; all free); Partner: club mates (free) or an
outside mate of the opponent's stance or style ($160); Film (tape study, free).
Changes: the camp stat gets a forecast to fight night; scale forecast; tape study opens one tell on the opponent's file every few camp days (weapon first,
weakness last). A camp whose three lines are all met on fight night (made weight, stat on target, never overreached) gives PEAK CAMP: +bonus to every stat for
that fight. A southpaw partner removes a round-1 penalty for an orthodox boxer who never faced one.
4.4 Weight - BUILT
Each fighter has a class limit (women's 57/60/65/75 kg, men's 57.5/60/70/75 kg). Weigh-in is the day before. Diet Hold/Cut and training burn move weight;
the bout page and Fight prep forecast "now / on the day". Missing weight calls the bout off and the club pays $300 for the empty slot. A boxer over his
class can get a bout he can make (a later date). The Old hand head coach makes cuts easier (120 kcal a day more).
4.5 Booking and matchmaking - PARTLY
Amateurs BUILT: offers arrive (a club show every other Saturday; one offer at a time per fighter, answer by a date, usually 8-12 weeks lead at clubs, 2-4
weeks in the first hour). Each offer: Accept or Pass, both free. An unsafe mismatch (a novice, 0-10 bouts, against an open fighter) cannot be accepted. Win chance
shown as a band that widens when unscouted. No way to ask for a named amateur opponent: AGREED; rules built (scripts/rules/AskBout.gd), panel not built (Ask for a fight: a "no" is a closed panel or an absent answer with its reason, never a random refusal).
Pros BUILT (after the debut, on Fights): the promoter brings three offers per fight (TUNE-UP likely, STEP UP about even, PAYDAY long shot) standing 7 days; OR the
player asks for a named boxer within the promoter's band (about 5 places above, unranked reach 15; a top-5 name needs 3 fans); Scout costs $250 and opens the
opponent's weapon and weakness and narrows the chance range. A promoter refuses if you duck the step up twice. Each row shows chance, what a win gives (place,
fans), what a loss costs, stoppage risk, pay (gym's 25% of the purse), and the gap to the next fight (quick, normal, hard night).
Rank rule: beat someone above you and take their place; beat someone below and nothing moves; a losing record is never ranked in the top 10. Purse: $1,500 unranked
$400 per place; tickets follow fans and how close the fight looks. Pro rounds: 4 unranked, 6 ranked, 8 top 10, 10 for a title.
4.6 Scouting and the opponent's file - BUILT
Free at booking: record, look, style word. Hidden until found: best weapon, each habit, weakness. Amateur: tape study in camp opens one a session. Pro: scout
for $250; the weapon is public tape. A found tell names its answer (a plan situation, a corner call or a drill). The Ex-pro head coach opens one tell the day
a bout is booked. An opponent with no bouts has no tape. The Tape Room (Fight prep, "Watch the tape") plays 3-4 films of her past bouts, SPOT the tell, then
YOUR ANSWER picks a move that becomes a plan line.
4.7 The game plan (Playbook) - BUILT
A plan is lines: "At long range -> One-two", "When she presses -> Step back" (places: outside, long, mid, inside, clinch, ropes; situations: she presses, boxes at range,
waits to counter, loads up, tires). Each answer is rated vs the opponent's game: Beats it / Works / Walks into it, and its edge over improvising, times her pad
time. Rate against another kind of opponent; round-by-round pace Push/Steady/Save; a go-to combination. The coach's skill sets how many lines (a plan holds
4-6). Real fight plans can be loaded; See the flow; Open the map. With no plan written the assistant coach writes one (poor to about half of a read plan).
A plan the fighter has not drilled works less well; a wrong answer costs. During a bout: planned right answers that win exchanges build PRESSURE on the opponent
(cuts her output); planned wrong answers she is punished for shrink her energy ceiling.
AGREED, NOT BUILT: opponents adjust by round 2; their note replaces the coach's line in the corner minute naming the line that stopped working.
4.8 Fight night - BUILT
A bout is 3 rounds of 3 minutes (amateur), 4 (pro debut), more later. A round is six 30-second exchanges, each settled by dice on an edge (training, plan, corner call,
pressure, tiredness). The opponent fights one way at a time (Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt), shown as a clue.
Every 30 seconds the player may shout one of the 3 calls that fit, or say nothing: Jab and move, Go to the body, Draw the lead, Hands up move your head, Let your
hands go, Breathe pick your shots, Tie up, Go for the finish. Each has a best / ok / wrong match to the opponent's mode, needs stats, costs or gives energy; only
two instructions per minute get through fully. Pace (Push / Steady / Save) and Aim (Own game / Head / Body / ribs / the hurt head) persist from shout to shout.
A set-up "NOW!" fires a learned combination into a gap the opponent opens: big edge, or a cost if wrong.
Corner minute between rounds: the corner card (what worked, what hurt, the call), the plan call, ONE CHANGE for the next round (a habit fix, or Elbows in: half the body punches go to the head, saving their energy and adding head damage, or Gloves high: the reverse; moved punches change where she is hit and what it costs, measured not to change who wins), RECOVER with 3 points (water, ice on the ribs, clear
her head when hurt), SET-UP (a combination x a gap), TALK (calm / fire up / the truth), change one plan arrow, cutman job (close the cut, enswell an eye, nothing).
Trust: a wrong call she followed costs trust; a Low fighter ignores shouting.
Knockdowns and counts come from power and damage vs chin, heart for the count; amateur RSC at 3 counts in a round or 4 in a bout. Injury roll after the bout.
Result: scorecards (3 judges), win on points / stoppage / draw, "what decided it", the Why, a body report (which part went first, with a "Train X next week"
button), "The plan, lit up" flow, then Back home and the goal talk. Watch modes: with a picture the 3D fight plays (1x/2x, Skip round, Skip bout); headless runs
stay in words. "Sim to result" skips the fight. Highlights/full modes in design notes: NOT ESTABLISHED as options in the UI.
AGREED, NOT BUILT: a cutman card for a closing eye, "stop it (she loses, the eye is safe) or go on (risk of a lasting cut)", behind a divider, never a pop-up,
never pre-selected, not using one of the two fixes (the 3D corner has a cutman job row today; whether its stop-or-go choice exists is NOT ESTABLISHED).
4.9 The Why - BUILT (the hook)
After a bout, plain lines: YOUR PLAN (graded against having no plan: right answers, wrong answers, neutral, worth about +X% chance), AGAINST YOU (what the opponent's
habits cost), NEXT (what to train or write). Graded by how each planned move answered what the opponent was doing, not by the dice; "swing" counts replay the
dice without the plan's edge. A readable reason for every random swing (R11): AGREED, NOT BUILT as a general feature; it lives on existing rows.
4.10 Damage, injuries, suspension - BUILT
Six body places per boxer take punches (head, ribs, etc.); bands fine over 55, hurt 55, critical 35, doctor 15. Bout injury roll from settled damage (about 6% a
3x3 bout; 72% head/neck, 20% cuts); training injury about 1.3% a week, more when overreached. Stoppage loss = 30-day suspension, longer for repeats. While out: no
offers, a quarter of gains. A fighter hurt before a bout: choice "pull out" (club pays the empty slot) or "fight hurt" (less energy: minor 10, moderate 15, serious 20).
A damage ledger and fights-left forecast exist for pros in the world model.
4.11 Morale, trust, goals - BUILT
Goals with deadlines (for example Debut inside a month, Next bout inside a month, Southpaw answer, Five-round engine), set in the office after each bout (Goal talk:
pick one of the offered goals). Status ON TRACK / AT RISK / OFF TRACK / MET / MISSED; ~70% clearable by design; meeting or missing moves morale. "Her asks" can be
heard or overruled (morale +5 / -5). The ambition shown on the signing card does not yet change anything (the design says a kept goal should build loyalty, a broken one may make a fighter leave: AGREED, NOT BUILT). Overruling a low-coachability fighter hurts more.
4.12 Staff - PARTLY
Head coach (you): one of four edges: Old hand (cuts easier), Ex-pro (one tell on file when a bout is booked), Amateur coach (a prospect's exact potential), Strength
coach (+10% body mornings, -10% craft mornings). Assistants: Luke Reid and Marcus Hale (above); training quality, plan lines taught (more with better rating), evening
classes +$350 a week. Staff jobs on the Club page (each changes one number): Second club coach 10 h ($280 a week: +1 roster place, +40 members, runs fitness classes);
Strength and conditioning ($100: training injury risk -15%, a pro camp's bill halved); Physio ($75: injuries back a quarter sooner); Cutman ($150 a pro night: half
the post-bout layoffs). Letting a staff member go costs a week's pay. Letting the main assistant coach go: NOT ESTABLISHED (Let go exists on the staff jobs).
"Coach runs it / I run it" per fighter: AGREED, NOT BUILT (the Roster has no such column).
4.13 Money and the gym - BUILT
The week review gives one short reason beside any change in members (word getting round, gym full, less room, dues too steep, more than the gym's name can hold).
Income each week: members' dues ($35 a month each standard; bands Cheap $25 / Standard $35 / Premium $45 change who joins), evening classes (+$350 with a coach), no-gi
dues, sponsors, fitness classes, juniors' dues. Costs: rent $1,800 a month (bigger premises more), England-Boxing-style fees ($315 club + $18 a boxer + $35 a coach a year),
coach, fighter stipends ($250 a week, optional), heating and power by season, insurance $1,250 a year, staff, kit budget (Low $0 / Standard $45 / Good $80 a week),
upgrades' upkeep. Wages and upkeep are billed every 28 days. Start cash = 1 / 3 / 6 months of costs by start. Runway under 8 weeks warns; below $0 is red; 8 weeks in a
row below $0 closes the gym. A loan ($180 a week for 26 weeks) comes with the debt start; the backed start loses $5,000 if the first show is lost. An overdraft rule
exists (offered after 12 weeks of trading, 16% a year) but NOT ESTABLISHED as having a screen.
One-offs: a bout adds a $450 ticket cut; camps cost a partner fee when used; repairs; a club show you host ($3,500, tickets $25, up to 400 seats, every 16 weeks, can lose
money); a club grant bid once a year (answer in 42 days, needs a second coach, odds follow reputation).
Spending choices on the Money page: Premises (Unit 70 members/3 places, $1,800 rent; Bigger unit 140/5, $3,400, $12,000 to move; Club building 250/7, $5,500, $25,000);
Upgrades (matted floor $2,400; strength corner $3,600; fitness class kit $1,500; youth section $1,800), each bought once, works after a week, one visible effect; Sponsors
(Ironclad $250/week from the start; Bow Road Physio $150 after the first win; bigger sponsors later); dues band; kit budget; evening coaches; pro stipends and contract talks.
Members: walk toward a target set by reputation, dues band, premises and coaches (at most 6 a week). A win adds +8 members and +5 reputation; a loss removes 1 and 2 reputation;
a stoppage loss 2 and 4. Facilities (floor, ring, bags, lockers, office) can be repaired once ($120 bags) for +2 reputation.
A pro's share to the gym starts at 25% (manager 15% + trainer 10%); contract talks at the first top-10 and the first belt (keep 25% for a bonus or drop the share), then yearly.
4.14 Rankings, titles, the world - PARTLY
Amateur regional table (the region's club-show boxers; a player's fighter enters at 4 wins); rankings move as rivals fight each other at shows; news lines. Nationals and the
regional bracket (BUILT). World pro tables for four divisions (women's and men's lightweight and welterweight, about 20 ranked each): boxers age, peak, decline and retire
(damage ledger and age), new ones arrive yearly, belts at four levels (area, national, continental, world) with mandatory challengers and vacated belts, rivals improve (BUILT in the
rules; its screens are on Fights, not World). An open-ended career, year review, three club goals a year, club tiers, a record book of champions and rivalries,
a named rival gym that poaches and rematches, promises/poaching at contract time, a career clock with retirement talk, youth-section home-grown prospects, a commentary line
and a press card are AGREED (owner "all of them", Q-S294-120) and mostly NOT BUILT; Records (the gym's own history log with filters) and the youth section exist.
4.15 BJJ (no-gi) - BUILT
Athletes (Ana Ribeiro) are on the mat, not in the ring: belts white, blue, purple, brown, black with 4 stripes each (IBJJF floor: blue needs 2 years, purple 1.5, brown 1; minimum
ages 16/16/18/19). The week is 3 classes; a class drills the syllabus move she is closest to owning (+3.2 a week; owned at 30, signature 50). Choices: drill a move; stripe call
(now / hold / early) with morale and loyalty costs; promote; enter opens (no-gi tournaments every 35 days, 8-person brackets); fight an open yourself (the player calls the moves on the move
graph) or simulate it; who teaches (hired coach or the athlete). No ranking table: the belt is the ladder. 5-10 minute matches by belt; points: takedown 2, sweep 2, pass 3, knee on belly 2,
mount 4, back 4. A BJJ athlete costs a roster place and a no-gi coach by the class.
The match runs on two-sided beats of about 11 seconds (S405): each side either acts on its pick or works its grips, and a holding lead can draw the referee's 20-second stall count.
Measured over 1,000 bouts: white belts finish about 34% of matches, the first to score keeps the bout about 80% of the time, and a one-belt gap wins about 74%.
4.16 Perks - BUILT (listed in section 3).
5. Every screen in the game today
5.0 The shell (on every game screen)
Top bar, left to right: Back (<) and Forward (>) arrows (greyed when none); gym name; date and week (hover card); red/amber flags (not on Home): GYM CLOSED, BELOW $0, LOW CASH,
APPLICANT, TRIAL, PRO OFFER, SET CAMP, WEEK REVIEW, WEIGH-IN, NEW GOAL (each opens its thing); cash with "running +/- $N a week" (hover card); the big button; Menu.
The big button: CONTINUE ("to <date>, <reason>"), RUNNING (click to pause), NEEDS YOU (n) (opens the first red need), or GO TO FIGHT NIGHT. Space also presses it.
Menu: Mail (opens World News; shows a new count), Save, Load, Settings, Handbook, Quit to title.
Left rail: Home, Fighters, Fights (badge = open offers), Club, World; the club crest (hover: name, members). Keys 1-5 reach the rail (design note: NOT ESTABLISHED in code).
A guide strip (first-hour guide only): the current stage's steps, what to do and why, a button for the next step, and Skip the guide.
Settings: text size (Small/Medium/Large/Largest), window (Windowed/Full screen), days run at (Normal/Fast/Fastest), four sound sliders (all, punches/ring, crowd, music),
Autosave (every Monday, last weeks kept / Off). Handbook: search and group filter (All, Words, The club, The week, The plan, Fight night, Money) with links to areas. Credits.
5.1 Title; 5.2 Create (see section 2). Create buttons: Back to title, Next: your club, Back, Open the gym; picks for coach, country, city, gym name, start.
5.3 Home (no tabs) - BUILT
Notice board of needs as pinned notes, each with a button: Meet the walk-in; Answer a bout offer (Open); Weigh in; Set camp; Hire a coach (Staff); money warning (Money);
a sponsor waiting (Deals); Enter for the nationals (Nationals); Week N review ready (Open); New goal waiting (Talk); Trial today (Watch the trial); Pro offer (Hear it);
Hurt before the bout (Decide); competes today (Go to the mats); The gym has closed (See the summary). Red = stops the clock; amber should come next; steel can wait.
First-hour card until the first bout (the job, show date and countdown, you). The next fight as a matchup card (button: Go to fight night, or the next step).
YOUR FIGHTERS table: fighter (name opens the page), record, rank, next fight, weight, freshness, this week's plan. Right column: SINCE LAST MONDAY (each fighter's biggest gain
with its cause, injuries, rank moves, new members; "All news and mail"), THE CLUB THIS WEEK (money in, costs, members, coach), COMING UP (bouts, weigh-ins, championship dates, bills).
5.4 Fighters > Roster - BUILT
A sortable table (columns: fighter, record, rank, The Road, and more) with flag chips per fighter that open the thing that needs her; a card per no-gi athlete with belt,
stripes, classes, "<name>'s mat: Playbook"; buttons: Meet the walk-in, Open training, Set camp (locked with a reason when it cannot start), See offers.
Fighters > Find a fighter: PROSPECTS NEAR <city> as face cards with scouted ranges for four stats (a range until the trial; the Amateur coach edge shows exact potential),
button Invite to a trial (free; she comes in on the Monday; signing costs the stipend). States: trial date, signed, passed. The reception walk-in is separate.
5.5 Fighter page (tabs: Overview, Week, Fight prep (only with a bout or camp), Playbook, History)
Header: portrait, name, weight class, age, stance, record, goal chip ("Goal, N days: still needs X - at risk").
Overview: NEXT STEP (the road: next step and what it needs; Enter for the nationals; the whole road on hover); attribute board (radar of eight against potential plus all values with weekly
delta, hover says what each does in a fight); BODY (weight of limit, condition, injury), COACH SAYS, COACH'S NOTES n of m; GOAL (title, days left, meter, status, quote;
Talk to <name> when a goal talk is waiting), NEXT BOUT; buttons Plan the week, Fight plan (n arrows), Find a bout; perk road; moves with mastery bars (hover plays the move); combos
learned (gold = thrown in fights); contract text ("club stipend $250 a week, until turning pro") and goals so far.
Week: head (NEXT/THIS WEEK dates, tiredness), PLAN TOTALS, seven columns of morning and evening cards (click opens a popover: Light | Normal | Hard and sessions; Rest | Pads | Sparring
and the drill cards), goal line, the coach's one change with a Do it button, Back to the coach's week, the twist card (choose an answer), LEARN ON THE PADS tray (drag a card to an
evening), THIS CAMP (diet pills Hold / Cut 500 kcal) only with a bout booked, a skills road below.
Fight prep: VS <opponent> (club, record, game), days to fight night and weigh-in, ONE primary button that moves with the state (Set the camp / Write the game plan before sparring /
Watch the tape / Step on the scale / Check the week), the tale of the tape with the win chance and how sure it is, WHAT YOUR PLAN SHOULD ANSWER (each found trait with its answer and
"Write it"; hidden ones say what opens them), CAMP AND WEIGHT (scale margin, the camp stat's line to fight night, Change the week).
Playbook (boxer): tabs Moves (move book by place in the ring; Watch/Steps, Drill, Replay, Slow motion), Game plan (see 4.7: Write a line / Change / Clear this line, Answer: <best>,
Rate against, Load a real plan, Test it (limited tries), See the flow, Open the map, Build plan in the move browser), Combos (build a chain from "+ move" buttons, Play it, Clear, Save to the
book, Drill it on the pads, Watch on the pads, chain hit rates vs opponent types), Escapes (folded into Moves in the agreed menu). A body plays each move on the right.
History: every bout she fought (and brought) with result, opponent, cards and why; milestones.
No-gi athlete page: one Record view: THE ROAD TO BLACK BELT (five belts with stripes), TO <NEXT> BELT (mat time, moves owned, syllabus), COACH'S CALL (give the stripe, Promote to <belt>, next opens
with Enter, who teaches), RECORD in opens; her Playbook is a mat book (moves by group, Systems, Drill, Undo, a game tree with FELT and links).
5.6 Fights (no tabs) - BUILT
Amateur: OFFERS ON THE TABLE (a card per offer: opponent face, record, win band, chips; Open) with each fighter's STANDING beside it (booked or free, next on the road, Enter for the
nationals); when none, the line says when the next offer can come. For a pro: a strip, NEXT FIGHT table (offers, asks: Take this fight / Book <name> / Scout ($250)) and THE ROAD (champions and
places around her). No-gi opens card with Enter. Fixtures list (calendar), RESULTS (who beat whom, cards, why).
Bout page (an offer): head chips (Legal, even match / Weight at risk / Not safe), tale of the tape, stats vs the estimate, win band and ranks at stake, SCOUTING file (locked lines say what
tape study opens), TERMS (date, 3 x 3 minutes, weight, on the scale now/on the day, time for a camp, purse none, club ticket cut $450, answer by). Buttons: Accept the bout (disabled with a
reason when unsafe or answered), Pass. Accept plays the poster reveal and offers Set the camp / Later.
5.7 Club (tabs: People, Money, Records) - BUILT
People: STAFF (you as head coach with your edge; the assistant card with training quality, plan lines, cost, net weekly; two hire cards when none: Hire Luke / Hire Marcus; no-gi coach line;
STAFF JOBS with Hire / Let go), MEMBERS (on the books and drift, reputation word, dues band).
Money: CASH WEEK BY WEEK chart; NOW (cash, weekly in, costs, net, month's bill, runway line, break-even members); WHERE IT COMES FROM / WHERE IT GOES bars; STIPENDS (Pay/Stop the stipend);
CONTRACT TALKS (Keep 25%: pay a bonus / Drop to a lower share); PREMISES (Move); UPGRADES (Buy); KIT BUDGET (Low/Standard/Good); evening coaches (Hire one / Let one go); CLUB GRANT (Bid for a grant);
CLUB SHOW (Book the show); ONE-OFFS IN and PAID OUT (last 8 weeks); DEALS (Sign a sponsor); FACILITIES (Repair); dues bands buttons.
Records: the gym's own history, newest first, with filters (who: everyone / each fighter / coach / gym; what: bouts, honours, people...).
5.8 World (tabs: News, Rankings, Championships) - BUILT
News: AROUND THE REGION (other clubs' bouts, names are links) and fixtures/events. Rankings: a table per division the gym has a fighter in (rank, fighter, gym, record, style, last bout; click a name for the rival file; a
fighter enters at 4 wins; no-gi says the belt is the ladder). Championships: the road to the nationals per amateur (rings for what she still needs, Enter, the London regional and national draw brackets, titles).
Rival file (modal): record, style and the tells found so far; locked lines say what tape study unlocks.
5.9 Modals (open on a press or when the clock stops on them; nothing else opens by itself)
Interview/Trial (walk-in, prospect): the fighter as an RPG recruit, one starting focus (Sharpen the signature +10 mastery, Fix the habit gone in 4 weeks, Raise the ceiling +5 potential), Sign or Pass.
Pro offer: the debut money picture (tickets she sells, her share, what the gym pays now, what ends); buttons Turn <name> pro / Stay amateur.
Goal talk: pick one of the goals offered, Set goal or Later.
Camp: see 4.3; buttons Later / Start (shows the cost).
Weigh-in: Step on the scale (made or missed). Injury choice: pull out or fight hurt.
Fight night: tale of the tape (Begin fight, Sim to result); rounds with shout bar, Sim the round; corner minute (call buttons, fixes, jobs, Say nothing / No fix); To the scorecards / To the result;
result with Train X next week, The plan lit up, Back home.
Week review (per fighter): bars fill to the next whole point, moves drilled, new weapon, rank change, planned vs actual, pads cards turning over, money, the coach's word; rows land one at a time with the biggest
surprise last; the only button is Next week. Open night (BJJ): Simulate this bout or Fight it, Back to the gym. Closed gym summary. Info boxes (Settings, Handbook, Credits).
6. The seven approved menus, and the agreed structure of all menus
Owner, Q-S294-127: "Yes, build the seven": Home, Fighter Week, Boxing profile, Playbook, Fight night, Money, World. A shared warm-wall kit (WarmKit: wall, whiteboard, paper, sticky, magnet, chalkboard, marker
ledge) is built first so screens cannot drift. None of the seven is rebuilt in the kit yet; the screens in section 5 are the current ones. Agreed structure: five rail buttons (Home, Fighters, Fights, Club, World); one
home per job; no mailbox (Mail opens World News and the Monday page replaces the week-review pop-up); nothing opens by itself; time is one big button saying what it stops for; one booked fight runs in a straight line
(Home countdown, camp, weigh-in, tape, fight night, the Why).
Home (agreed): needs first, the job, the next fight, one row per fighter, Since last Monday with causes, the club's week, what is coming; the week review folds in as a need that "sits here, never pops up"; the line
under the big button names the next stop; the first-week guide card only in the first hour.
Fighter Week (agreed): the whiteboard: sessions as magnets, the fight date circled, colour only means risk, one red button moves the week on; plan totals, fatigue, the goal line, the coach's one change with the effect on the
button; Learn on the pads; ADD "Coach's pad nights" as the top row, two fighters in camp only, with the cost to the other fighter (R55).
Boxing profile (agreed in shape; numbers superseded by the 10 attributes in section 3): tabs Overview, Week, Playbook, History on one portrait header; three columns Body, Skills, Mind with a style line ("Keeps it
long"), one thing to work on and where it is trained; the sport switch only once she trains both; a rival gym's offer with its three answers (match it, promise something, let her go) as the top card when it
comes (R58, needs the running world).
Playbook (agreed): Moves (Escapes folded in), Game plan (lines drawn on a board, plays a default at once, rate against each kind of opponent), Combos; "No bout booked: try the plan against each kind of opponent".
Fight night (agreed): dark and tight, handwritten coach notes, three fixes / time for two; stats cut to three rows in the minute; the "she has adapted" note (14 words at most) replaces the coach's note (R25); a
cutman card only when an eye is closing (R28); the result with scorecards and the Why (plan, against you, next); the money lines move from the Why to Home; no "one change for next time" (the Why's NEXT carries it).
Money (agreed): the gym's books on the whiteboard: cash, runway, in and out, bills, deals, repairs, upgrades; dues bands wait for the owner's call on the cut.
World (agreed): News cut to only what touches you; Rankings with rivals that develop (movement arrows, Developing column); Championships; fixtures; no-gi "belt is the ladder".
Other menus in the agreed map (not in the seven; final text per MENU_STRUCTURE_S402): Start (three starts, already in game); First week; Fighters (a real roster); Fights (Ask for a fight sits under
the offers: level, date window, an answer with its reason; it waits for the bot test that a smart ask beats a plain one, R37); Fight prep ("What your plan should answer", no injury-risk lines on camp
choices); Club > People (staff cards keep their faces; members panel cut); Grow (finding and signing only plus the pro offer; no prospect deadlines); Top bar (no change).
Held back, do not build from an old mockup: one change after the Why, camp injury risk, scorecards after each round, members panel, prospect deadlines, sponsor line and per-fighter costs, the progress chart on History.
Conditional elements and when each appears: Coach's pad nights (two fighters in camp, until a camp ends); Needs flag for the second camp (the second camp starts, until she opens the Week); Cutman card (an eye reaches
the closing state at the bell); Adapted note (from round 2, when the opponent has answered one of your lines); Rival offer (the running world sends one; a flag only, answered or past its date); Ask for a fight
(always, once a boxer is signed); Swing reason (a random roll moved a number you can see, scrolls off with the week).
7. The owner's standing rulings on screens (quoted or near-verbatim)
Only actionable information: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Cut it, hover it, or put the action on it.
One top bar and modals; nothing opens by itself; moments come as flags on the top bar. A week review sits as a need on Home.
No flavour text; plain words; one word per concept (Raw, Usable, Sharp, Signature everywhere). Hover explains every number.
Not mobile: "thats not how sim/manager games look , its very simplestic no actual stats to make the player understand how good the fighter is". Real stats stay. Not an 80s spreadsheet; no placeholders.
Do NOT judge against a generic management sim ("they seems like economic management simulator"). Judge fit to this game and its plan.
Look B, the gym whiteboard: marker notes, polaroid, needs as sticky notes, the cash tin, the fight date circled; warm tan plaster wall, wood and aluminium frames, cream paper. ONE art style across menus
("no art consistency" was his complaint). Stylized comic portraits in menus are on and must match the fighter. Marker fonts Permanent Marker and Kalam.
Screens come only from agreed mockups; nothing is built on a menu he has not OK'd. A generic Money page was reverted.
Fight night goes dark and tight (the Miro "Corner minute"); the coach's notes stay handwritten.
Everything new ships switched ON. Hover cards on top-bar date and cash. Animated meters (every bar tweens).
Weekly job pages must not become a pop-up. One-click reach from anywhere. Two Point alignment is parked (the gym floor is out of the first release).
No gym still with the Day Plan or a drawer open; stills of fights show both fighters head to feet; boxers wear boots (visual rules for pictures).
Scouting means opponents; finding fighters is "Find a fighter". The facility is a "gym"; a fight camp is only pre-bout preparation. Fighters are fictional; organisations real-named only where legal.
8. Where the documents and the code differ, and what could not be established
Code wins. For the critic: do not judge a screen against these older statements.
Autosave, Settings and Handbook: docs say "not built"; they are built (autosave every Monday).
Pros have no offers/world after the debut (docs): the code has a pro ladder, promoter offers, asking, scouting, belts, ageing and retirement.
Ask for a fight: docs say impossible; it exists for pros only. Amateurs cannot ask.
Gym closes after 4 weeks below $0 (CLAUDE.md numbers) vs 8 weeks in code. Gym's share of a pro purse 35% (CLAUDE.md) vs 25% in code. A loss costs 3 members and 2 reputation (CLAUDE.md) vs 1 and 2 in code (stoppage 2 and 4).
Ex-pro head-coach edge: design says one extra corner call; code gives one opponent tell on file at booking. Old hand: design "cheaper camps"; code: easier weight cuts.
Roster limit "up to 8": code gives 3 places, +2 per premises tier, +1 per second coach (5 and 7 at the larger premises).
Four rail buttons plus Playbook: the Playbook is reached from the fighter page, not the rail. Docs on Fights tabs are out of date (one page).
"Coach runs it", year review and club goals, club tiers, rival gym, poaching, career clock: not in code. Overdraft has rules but no screen found. Keys 1-5 for the rail and highlights/full watch options: not found.
NOT ESTABLISHED: the exact number of moves in the Playbook; whether the 3D corner's cutman choice offers "stop it / go on"; whether the week review ever opens without a press (the owner listed it as a defect on 2026-11-08);
the owner's answer on an open-ended career and a roster of 8; whether R11 (readable reason for every swing) exists beyond the Why; crossover numbers between boxing and BJJ (left blank on purpose).
Added S409
The building: chosen once at new career, one of four gym plans, each with one small permanent edge (5% more members, 5% more show income, 3% better power and technique training, or injured boxers back 10% sooner).
The gym on Home has people in it: the club's fighters and members, working at equipment and walking the floor. More members, more people (2 to 12). Decoration only: they take no clicks.
Added S410
The shell's top bar is dark on every game screen (5.0).
Fighters > Roster (5.4) is now full-body cards on a painted gym: weight class and rank, a corner flag for the most urgent answer (Set camp, Offer, Weight, Mood low), Condition / Mood / Weight tiles, the next fight and days to it; a click opens the fighter's page. Under them, Scouted for you: up to four prospects, with Invite to a trial. A Cards / Table switch keeps the sortable table (Rank, The Road, Goal).
Fights > a bout offer (5.6) opens as a versus screen: the two boxers on a red and a blue wall, the tale of the tape (record, age, weight on the day against the limit, height, stance), the win chance and how sure it is, what a win and a loss change, Full report / Pass / Accept. Full report is the old bout page: stats against the estimate, win band, ranks at stake, the file, the terms.
The game does not hold a venue, last-five form or a fighter's reach, and there is no scouting before accepting an amateur offer.
Added S448 (code check)
The attributes in section 3 marked AGREED, NOT BUILT are in the code: scripts/rules/Attrs.gd holds the 14 abilities (Strength,
Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure; skills Accuracy, Timing, Defence, Footwork,
Inside fighting) plus Heart; the old seven (Power, Hand speed, Technique, Defence, Conditioning, Ring IQ, Chin) are kept as a summary
read from them. Punches are moves with mastery. Our own fighters have no height or reach value yet (opponents do).
The plan's step and defence answers are StrikeMap arrows: step in, step out, step back, cut off, herd, pivot out, push off, feint,
tie up, roll out. They have no mastery today and always work in full.
Coaches: Luke Reid pads 74 (rating 58), Marcus Hale pads 58 / conditioning 90 (rating 74).
Units: the code counts a pad night as 240 drill units (PadWeek.PAD_NIGHT_MINUTES) for the 75 real minutes in 4.2; a sparring night shares 180
units over the moves on the fighter's cards and plan. Mastery maths uses the units.
Added S451 (code check; where this and an older line above disagree, this wins)
FireLevel is ON since S450: a planned line fires 1 use in 2 at Usable, 3 in 4 at Sharp, always at Signature. The line in 4.2 that says
"SWITCHED OFF" is out of date.
Our own fighters now have height and reach, and the fight reads them (S450). The S448 line saying they have none is out of date.
Phases come from any booked bout, camp or no camp: a bout 1 week out makes the week TAPER (WeekPhase.phase), also for an amateur bout.
Two rest rules after a stoppage loss, both in code: the 30-day suspension (Injuries) and the next bout offered 8 weeks later than usual
(Matchmaking.STOP_REST_WEEKS).
The office is a full-screen computer desktop (owner's Q-213 "A, full screen", S451): the gym's office pin opens it. Its Desktop shows what
needs you, the next four weeks (bouts, bills, dues), mail, the fighters with each one's flag, money 8 weeks ahead and the staff. Its other
apps (Mail, Schedule, Fighters, Staff, Finance, Records) are AGREED, NOT BUILT; today they lead to the existing pages.
SANDBOX (S412): the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never a fixed he or she in text or mockups.
THE DESIGN MAP TO JUDGE
COACHFIT1 v3: coaches who fit, fill up, grow, have a temper and bond (S454)
v2 (COACHFIT1_MAP_V2_S452.md) scored Depth 8 / Play 8 (Dola, COACHFIT_CRITIC_S452_DOLA.md, raw transcript) and Depth 6 / Play 5 (Maria,
COACHFIT_CRITIC_S452_BRIEF_MARIA.md). v1 scored 5/5 (Kalli) and 6/6 (John). v3 takes Maria's whole 10/10 list and Dola's mechanics list.
Maria's core finding: "the weekly gain differences are too small to feel" - TOP FIT against RISKY moved about 0.04 of a stat point a
week. v3's core change: every fit difference is printed on the week in stat points and is big enough to see (0.5+ a week on a focused
area), coaches have a weekly energy, and each temper is a weekly lever, not only a hire.
The critics found	v3 changes the MECHANIC
Maria 1: fit spread x0.90-1.10 is invisible on the week	Gain x0.80 to x1.20, tiredness x0.85 to x1.15; every row prints its predicted gain in stat points; FITPROBE1 bar: TOP FIT vs RISKY >= 0.5 a week on a focused area (section 2)
Maria (logic): "4 boxers x 5 coached sessions" does not match a 10-12 session week	A COACHED SESSION is defined: evenings (pads, sparring, film) and Hard mornings. Light and Normal mornings train alone (0.6) unless assigned. Four fighters need ~16-22 coached sessions against 12 (section 3)
Maria 3: "over list" was a flat penalty forever	COACH ENERGY: 10 a week; a session 1, a Hard session 1.5, a corner night 3; a deficit shrinks next week's list by that much. Over the list is a two-week trade (section 3)
Maria 4: taught-out arrived late, sprung on the player	Graded: -2 at Working when the stat is within 10 of the ceiling, -4 within 6, -6 within 3; the row says "taught out in about 3 weeks" (section 4)
Maria 5: the temper was a hire-time choice	Each temper has a WEEKLY MODE, one toggle per coach per week, its effect printed on the rows (section 5)
Maria (logic) + 6: "coach mood" does not exist in the code	Dropped. SAY NO to a raise = "working to rule": that coach's list -1 session for 4 weeks, on the card (section 4)
Maria (logic) + 9: "Old hand" already names a head-coach background (HeadCoach.gd 29)	The temper is renamed STEADY HAND and is about the calendar, not injuries: with a bout inside 14 days, tiredness x0.85 on every session that coach runs (section 5)
Maria 7: only one pair could ever reach Corner	Bond thresholds 0 / 8 / 35 / 90; apart decay -1 a week (was -2) (section 6)
Maria 8 + Dola: the corner pick needs its difference shown	Each candidate shows expected calls heard ("about 4 of 6") and the win-chance swing from BONDPROBE1 (section 8)
Maria 10: fighters have asks; tie them to coaches	A fighter at Trusted asks for that coach on the pads before a bout: hear it (+5 mood) or overrule it (-5) (section 6)
Maria (logic): Swap mid fight week; Pay with cash under $0	Swap in a fight week is allowed and shows the -20 bond price; Pay is greyed under $0 cash with "not enough cash" (section 10)
Maria (options): Copy last week, lock a cell, list-full warning before Monday	All three on the Staff table / desktop (section 10, 12)
Dola 2: which sessions push a coach over	Hover "9 of 8" lists the sessions, the newest first (section 10)
Dola 3: temporary vs permanent swap	Swap THIS WEEK ONLY (bond pauses, fit -2 that week) or FOR GOOD (bond starts at Stranger) (section 10)
Dola 4 + 10: the school list and growth progress on the card	The market and staff cards list every move in the school and "62 -> 65 in 14 sessions" (section 12)
Dola 5: market filters	Filter by area, temper, ceiling, wage (section 12)
Dola 9: no one-line summary per fighter	Each fighter row on the table starts with the week's predicted gain in the fighter's focus stat and "best swap: +0.4" (section 10)
Maria (logic): pro-night cutman in the corner pick	The corner pick lists the head second only; the cutman stays its own StaffRoles job ($150 a pro night) and is shown beside it, not chosen from the same list (section 8)
Maria (logic): roster places	The map's numbers assume the Bigger unit (5 places) or a second club coach; with the starting Unit (3 places) the table has three rows and the list binds less, said on the Staff app (section 3)
Sources as v2 (his order Q-S294-210; OFFICE_BOOKING_S448 s4; PROGRESSION_MAP_S448 M6, approved Q-211; PADPOOL1; Loyalty.gd; Exchanges'
shout rule; CoachAreas factor 0.5 + rating x 0.7 / 100, alone 0.6; HeadCoach.gd four backgrounds; COACH_DESIGN_S412) plus StaffRoles
(cutman $150 a pro night), BoutRead.gd 228 (coachability from personality), CornerJobs.gd 99 (discipline from personality).
Rules obeyed: names only in headers; game words; "the pads coach", "the fighter" in rows; one pulsing button a screen; every mechanic
wired and shown; no flat "+5% training" perks. ESTIMATE = a number this map sets that a probe sizes.
1. The idea
Today a coach is one average number and nobody decides who trains whom. After COACHFIT1 the player sets each week WHICH coach runs WHICH
area for each fighter, and sees on every row what that pair will add this week in stat points. The answer changes through a season:
bonds grow, coaches near their ceiling with a fighter, a coach's energy runs short in a busy camp, raises are asked, fighters ask for
their coach, and the calendar makes one temper worth more than another.
2. The rating counts once; the fit is the pair, and it is visible
The coach's AREA RATING keeps today's job only: the coach factor (0.5 + rating x 0.7 / 100) on that session's gains, and M6's pads rule
for move speed.
The FIT (0-100) reads only the pair. ESTIMATE, sized by FITPROBE1.
Part	Points	Read from
Temper and its mode x the fighter's state (section 5)	-10 to +8	morale (FighterProfile), fatigue, the calendar
Load: the coach's energy (section 3)	0 in budget, -6 at 1 over, -14 at 2+ over	the week board
Bond (section 6)	Stranger -6, Working 0, Trusted +4, Corner +6	bond step
Taught out, graded (section 4)	-2 / -4 / -6	ceiling, stats
The session trains the fighter's weakest stat of those it moves	+6	stats
What the fit does: GAIN x0.80 at 0, x1.00 at 50, x1.20 at 100; TIREDNESS x1.15 / x1.00 / x0.85.
Every row prints the session's PREDICTED GAIN in stat points ("+0.26 Power, TOP FIT"); hover lists the fit parts with points.
Row words: TOP FIT (80+), GOOD (60-79), MIXED (40-59), RISKY (under 40).
FITPROBE1 bars: TOP FIT vs RISKY on a focused area >= 0.5 stat points a week (a fighter with 3 coached sessions in that area);
best list vs worst list 4-8 wins in 100 over a season, without the rating; no single part more than half of the fit.
3. Assigned by area; coached sessions; coach energy
Each fighter has a coach per AREA: pads (evening), sparring (evening), conditioning mornings (roadwork, intervals, mobility), strength
mornings (strength, neck), bag mornings (heavy bag, speed bag, slip rope, shadow) - CoachAreas.SESSION's five areas.
A COACHED SESSION is an evening (pads, sparring, film) or a HARD morning. Light and Normal mornings train alone (0.6) unless the player
assigns a coach to that morning (then it is coached and costs energy). Four boxers on a normal week: 3 pad nights + 1 sparring night +
1-2 Hard mornings each = 16-22 coached sessions.
COACH ENERGY (ESTIMATE): 10 a week. A session costs 1, a Hard session 1.5, a corner night 3. An assistant's LIST (what fits in 10) is
8 normal sessions with room for a corner night; +2 energy at that area's rating 80+. The head coach has 5 energy (4 sessions + the
office). The second club coach, when hired, has 5, conditioning mornings only, never the corner.
OVER BUDGET: every session on that coach's list takes the load part, and next week's energy is 10 minus the deficit ("tired: 8 next
week"). Over budget is a two-week trade: this week's bout against next week's camp.
Uncoached sessions train ALONE (0.6), shown on the row as "alone".
Roster places: the starting Unit holds 3 fighters, so the table has 3 rows and binds less; with the Bigger unit (5) or a second club
coach the four-fighter numbers above apply. The Staff app says which.
4. Growth, the ceiling, and its price
Growth: +1 in an area per 10 sessions the coach runs there (M6), up to the ceiling. A night with two fighters on the same pads counts
once for the coach.
The ceiling shows as a RANGE on the card from day one ("ceiling 62-74"), exact after 4 weeks of work. The card prints growth progress:
"62 -> 63 in 4 sessions".
TAUGHT OUT, graded and announced: from Working, when the fighter's stat for that area is within 10 of the coach's ceiling the fit takes
-2, within 6 -4, within 3 -6. The row says "taught out in about N weeks" from the fighter's current gain rate. Moving that area to a
fresher coach is a planned move, not a surprise. FITPROBE1 bar: the best table changes at least 5 times a season.
PRICE: each 5 points a coach gains, the Monday review asks +$50 a week: PAY (greyed under $0 cash: "not enough cash"), or SAY NO =
WORKING TO RULE: that coach's energy -1 for 4 weeks, shown on the card. The rival gym's offer (AGREED, NOT BUILT) adds to SAY NO later;
until it is built nothing on screen mentions it.
Growth stays with the coach; let go and it leaves. Growth milestones are announced as gains ("the pads coach reached 65: the
Technician's polish now reaches Sharp moves").
5. Tempers, each with a weekly mode
Every coach has one temper (a word on the card) and two MODES; the player sets the mode once a week (default: the first). ESTIMATE,
FITPROBE1 bar: each temper is the best hire for at least one of the four bot boxer types, and each mode is the better one in at least one
week of a season for that coach.
Temper	Mode A (default)	Mode B	Fit part
Motivator	LIFT: a loss's mood hit -12 becomes -8; +3 mood a week for Flat fighters on the list	DRILL: no mood effect, gains x1.05	+8 with a fighter on Low mood (under 40)
Drill sergeant	PUSH: sparring counts 1.25 for move mastery and plan tests, +3 fatigue a night	EASE: no mastery bonus, fatigue as normal, no friction roll	-10 with Flat or Low mood in PUSH, +4 with discipline 70+
Technician	POLISH: pad learning x1.15 on moves already Usable (Sharp too from rating 65)	TEACH: x1.10 on moves under 30	+4 with coachability 70+
Steady hand	TAPER: with a bout inside 14 days, tiredness x0.85 on every session this coach runs	BUILD: no bout soon, gains x1.05 on conditioning	+4 with a fighter who has a bout inside 14 days
Discipline and coachability are read from the fighter's personality (CornerJobs.gd 99, BoutRead.gd 228). Today's two assistants: the
pads coach is a Technician, the conditioning coach a Drill sergeant. The market adds a young Motivator (pads) and a Steady hand (sparring,
bag). The mode toggle sits on the coach card and on the table header for that coach; each row shows the mode's effect.
6. Bond
Steps Stranger / Working / Trusted / Corner, one per coach and fighter pair (not loyalty to the club).
Built: +1 per session together, +6 per bout this coach worked the corner, +10 for a loss survived together. Thresholds 0 / 8 / 35 / 90
(ESTIMATE, BONDPROBE1: Working after ~1.5 weeks, Trusted ~6 weeks, Corner ~half a season; two or three pairs reach Trusted in a season).
Lost: -1 a week apart; -20 when moved FOR GOOD mid-camp (a THIS WEEK ONLY swap pauses it); a quarrel.
Does: the fit part; THE CORNER (section 8); a Corner-step coach leaving costs the fighter -8 mood. The head coach's bond step IS the
"known" level Loyalty reads.
FIGHTER'S ASK: at Trusted, before a bout the fighter asks for that coach on the pads. HEAR IT (+5 mood, the area moves to that coach for
the camp) or OVERRULE (-5 mood). Uses the existing asks mechanic (Q-S294-209 order: after AMATEURWEEK1).
QUARREL, readable: a Drill sergeant in PUSH with a Flat or Low fighter shows FRICTION on the row; each week at friction, 1 in 6 chance of
a quarrel (-15 bond, -5 mood); the answer is on the row: switch to EASE, move the area, or keep going.
7. The head coach's rule
The head coach (the player) has 5 energy, any areas, rating 60 in the background's area and 45 elsewhere (Ex-pro: pads; Amateur coach:
pads; Strength coach: strength; Old hand: conditioning). No growth, no wage, no temper modes. CHECK before the build: HeadCoach.gd has no
rating today; add the head coach as a coach row in CoachAreas.rating_for, not a special case.
8. The corner is a pick, with its difference shown
On the bout card, WHO WORKS THE CORNER lists each candidate as a card (name in the card's header) with its shout number: coachability rule
x mood x bond (0.90 / 1.00 / 1.05 / 1.10), floor 0.5, and what it means: "about 4 of 6 calls heard" and the win-chance swing against the
head coach from BONDPROBE1. The corner night costs that coach 3 energy. On a pro night the cutman stays a separate StaffRoles job, shown
beside the pick. The fight screen's Heard / Half heard shows it landing; the result page says what an unheard call cost.
9. The school
Each assistant has a school of 5 to 7 punches and combinations, listed in full on the card. In the school: learning x1.1. Outside: Signature
work at x0.5 of M6's rate. Step arrows join when they get mastery (STEPMASTERY1). The head coach's school comes from the background (Ex-pro
Jab, Cross, Lead hook, Check hook; Amateur coach Jab, Cross, Body hook; Strength coach Body hook, Uppercut; Old hand Jab, Lead hook).
10. The decision a week (Monday, Staff app; and the week board)
THE TABLE: fighter rows x five area columns. Each row starts with the fighter's predicted focus-stat gain this week and "best swap:
+0.4". Each cell: coach portrait, FIT word with a bar, predicted gain in points, bond pips, and FRICTION / TAUGHT OUT IN 3 WKS / ALONE.
SWAP: the popover lists each coach with the new fit, gain, energy cost and bond effect, and two buttons: THIS WEEK ONLY (bond pauses, fit
-2 this week) or FOR GOOD (bond starts at Stranger). Allowed in a fight week, with its price shown.
Hover "9 of 8" (energy over) lists the sessions on that list, newest first.
COACH RUNS IT (C20, AGREED) fills the table, never over budget unless there is no choice, says why in one line, and skips LOCKED cells.
COPY LAST WEEK; a LOCK on any cell.
The Monday review: raises (Pay / Say no), growth milestones as gains, bonds reached, a quarrel, a fighter's ask.
The office desktop's Needs you: "the pads coach's energy runs short next week" BEFORE Monday, from the booked calendar.
FIGHT WEEK: the corner pick (section 8).
11. Probes, in order
FITPROBE1 (Goose): 26-week careers via career_harness, four arms (fit at 50 = today; as written; best table weekly; worst weekly), per-
area coaches, energy and modes on. Bars: TOP FIT vs RISKY >= 0.5 stat points a week on a focused area; best minus worst 4-8 wins in 100;
no fit part over half the fit; one assistant for four boxers costs 2-5; the best table changes 5+ times a season; each temper best for one
bot type; each mode best in at least one week.
BONDPROBE1: Stranger vs Corner in close bouts worth 2-4 wins in 100; thresholds land at ~1.5 / ~6 / ~13 weeks.
The four S412 bots (loyal / rotate every block / rotate when taught out / one-week farm) with raises, energy and graded taught-out: fails
if one beats the rest by more than 5 points, or the farm beats loyal once costs count.
12. Every menu it appears on, and what each is wired to
Menu	Shows	Wired to
Week board (Training)	each coached session: coach or "alone", FIT word, predicted gain, parts on hover, FRICTION / TAUGHT OUT IN N WKS	CoachFit (new), WeekPlan, PadWeek
Office: Staff app, coaches	cards: areas, growth "62 -> 63 in 4 sessions", ceiling range, temper + MODE toggle, full school list, energy pips "9 of 10", wage, raise	CoachFit, CoachEnergy (new), CoachGrowth (new), StaffRoles
Office: Staff app, table	fighter x area cells, row summaries, Swap (this week / for good), Lock, Copy last week, Coach runs it	CoachFit, CoachEnergy, Bond
Office: Staff app, market	cards with school list, temper, ceiling range, energy, wage; filters area / temper / ceiling / wage; Hire	StaffRoles, CoachSchool
Office: Desktop	energy short next week; a raise asked; a fighter's ask	OfficeDesk
Fighter page, Training	the fighter's coach per area, bond steps and next threshold	CoachFit, Bond (new)
Fighter page, moves	"in the pads coach's school x1.1" on a move bar	CoachSchool, MoveTree
Learning-slot cards (SLOTS1)	the school reason	LearnSlots
Monday review	raises (Pay / Say no -> working to rule), growth as gains, bonds reached, quarrel, the fighter's ask	CoachGrowth, Bond, WeekCoach
Bout card / fight week	the corner pick: calls heard and the win swing per candidate; cutman beside it on pro nights	Bond, CoachEnergy, AMATEURWEEK1
Fight: shouts	Heard / Half heard, by bond too	Exchanges, Bond
Result page	"The corner: Trusted, 4 of 5 calls heard; the unheard call cost about 3 in 100"	FightWhy, Bond
13. Build order
FITPROBE1, BONDPROBE1, the S412 bots (rules modelled in the probes).
Pure rules + tests: CoachFit, CoachEnergy, CoachGrowth (ceiling, graded taught out, raise, working to rule), Temper (with modes), Bond
(friction, asks), CoachSchool. Data: tempers, modes, schools, ceilings; the head coach as a coach row.
Wiring: WeekPlan/PadWeek read the fit, energy and per-area coach; the shout reads the bond; MoveMastery reads the school.
Screens (Grok Dev, one a task): week board rows, Staff app table + cards + market, the fighter's Training strip, the corner pick.
Golden path: hire the young Motivator, set the table, see a TOP FIT row's gain beat a RISKY one, go over budget and pay it next week,
reach Working, say no to a raise (working to rule), swap an area when TAUGHT OUT IN 1 WK shows, hear a fighter's ask, a bout where the
chosen corner's calls show on the shouts and the result.
14. Needs that are not built yet (said, not hidden)
The rival gym's offer (AGREED, NOT BUILT; not shown until built); step mastery in the school (STEPMASTERY1); the office Staff app
(OFFICE2); the asks mechanic for coaches (after AMATEURWEEK1); per-area coaches on mornings (step 3).
15. Open for him (taste and scope, after the critics)
The four tempers and their modes: the right flavours?
A raise every 5 points: right pace?
CRITIC ANSWER: COACHFIT_CRITIC_S454_KALLI.md
COACHFIT_CRITIC_S454_KALLI - Kalli answer (seat queue SQ69)
Brief: research/COACHFIT_CRITIC_S454_BRIEF.md
Sent: 2026-11-13 17:40 | collected: 2026-11-13 18:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.
Scoring COACHFIT1 v3 against the pack. First I'm opening the office mockup again to check it against this version.
Part 1 of 3
COACHFIT1 v3: critic (S454, Kalli)
Judged on this map, the pack and docs/mockups/s449/office/office_a.png, which I opened with the file tool. I didn't open the Miro board, the real screens or the code.
Verdict: Depth 6/10, Play 5/10.
What now works:
Assigning by area, coach energy as a two-week trade, the graded taught-out warning, and swapping for this week only or for good all make who-trains-whom a weekly question.
What still breaks it:
The fit's own parts can't reach the numbers the map prints. The best possible fit is about 70, so TOP FIT never shows and the gain spread is roughly x0.86 to x1.08, not x0.80 to x1.20.
The probe target of 0.5 stat points a week can't be reached even at the full spread.
Light and Normal mornings at 0.6 quietly cut today's training for every boxer.
Two of the modes are the flat +5% the map says it bans.
1. Logic check
1. The fit can't reach TOP FIT. v3 never states the base (v1 said 50). From 50:
Best case: temper +8, load 0, bond Corner +6, taught out 0, weakest stat +6 = 70.
Worst case: 50 -10 -14 -6 -6 = 14.
So TOP FIT (80+) never appears, and "x1.20 at 100" is never used. The real spread is about x1.08 to x0.86 on gains, and x0.91 to x1.10 on tiredness. That's the same problem the last critics flagged as invisible.
2. The FITPROBE1 bar can't be met. By the pack, a fully focused week adds about 1.0 point times the coach factor (about 0.9), so roughly 0.9 points to the focused stat. Three coached sessions are only part of that week.
At the map's own full x0.80 to x1.20, TOP FIT against RISKY moves about 0.36 a week.
At the reachable spread from point 1, it moves about 0.15.
">= 0.5 stat points a week" fails by design.
3. Mornings left alone cut today's training. Pack 4.1: every morning is multiplied by the coach factor. With Luke Reid at rating 58 that's 0.91, and with Marcus Hale at 74 it's 1.02. v3 makes Light and Normal mornings "alone, 0.6" unless coached. That cuts most of a boxer's mornings by about a third against today, and moves every growth number in the game. FITPROBE1's arm "fit at 50 = today" is then not today.
4. Coach energy doesn't add up. 10 energy holds "8 normal sessions with room for a corner night", but 8 + 3 = 11. And 16 to 22 coached sessions against "12" needs explaining: 12 is one assistant's 8 plus the head coach's 4. Two load models are still live:
PADPOOL1 gives 8 club pad nights a week.
The mockup says "pad nights 4 of 6" for the head coach and "3 of 3" for the assistant.
On top of that, "two fighters on the same pads counts once" is stated for growth but not for energy.
5. The head coach against the 60% rule. Pack: "Without any coach, training runs at 60%." v3 gives the player, who is always present, a rating of 60 or 45, so the coach factor is 0.92 or 0.815. Either the 60% rule goes, or the head coach's rating only applies to sessions they're assigned to. CHECK (Claude): how CoachAreas treats "no coach" today. "4 sessions + the office" also needs a cost for the office.
6. Mood bands are wrong. The Motivator's "+8 with a fighter on Low mood (under 40)". In the game, Low is under 30 and Flat is 30 to 49.
7. Flat +5% perks, against the map's own rule. Motivator DRILL "gains x1.05" and Steady hand BUILD "gains x1.05 on conditioning" are the flat "+5% training" the rules section forbids.
8. The Technician's line is already met. POLISH reaches Sharp moves "from rating 65", and the milestone example says "reached 65: polish now reaches Sharp". The pads coach (Luke Reid) already has pads 74. Also, "moves already Usable" doesn't say whether that includes Sharp (60+).
9. Bond outruns its own target. One pads coach on four fighters runs 3 sessions a week with each, and -1 a week "apart" never applies to an area coach the fighter sees every week. That gives four Working pairs in about 3 weeks and four Trusted pairs in about 12 from that coach alone, against "two or three pairs reach Trusted in a season". "Apart" needs a definition: no session together that week.
10. FOR GOOD wipes a bond the pair already has. Bond is per coach and fighter. Moving the pads area to a coach who already runs the fighter's strength mornings at Working can't "start at Stranger".
11. The fighter's ask is usually moot. Bond is built by sessions together, so the coach a fighter trusts is most often already on her or his pads. The ask only means something when that coach isn't.
12. Who shouts in an assistant's corner is undefined.
The player still picks the shouts. The map has to say the corner coach only changes how many are heard.
Three multipliers stack: morale trust 1.05 to 0.7, coachability, and bond 0.90 to 1.10. Fired up times Corner is 1.155. That needs a cap as well as the floor.
CHECK (John): how many seconds an amateur corner may have, and whether the head coach may stand behind an assistant.
13. A raise is cheaper to refuse.
Pace: +1 per 10 sessions, and a coach doing 8 pads sessions a week gains 5 points in about 6 weeks. That's a raise about 8 times a season, taking $450 a week to about $850.
Working to rule costs one session a week for 4 weeks, against $50 a week for good. Say No wins on money every time.
Whether a second refusal stacks is undefined.
14. The second club coach. The pack's job runs members' fitness classes (+40 members). v3 also puts that coach on fighters' conditioning mornings with 5 energy. Say whether the classes still run and what they cost in energy.
15. The predicted gain is printed in the wrong stat. "+0.26 Power": Power is now a summary read from the abilities (S448), not something a session trains. Print Strength, Stamina, Accuracy and so on.
16. Names. The map keeps names in headers: "the pads coach", "the fighter", and corner cards with the name in their header. No breach found in the map. In the mockup, the mail line "Your coach: The welterweight is sharp" comes from the assistant, since the player is the head coach, so it should read "Your assistant". The mockup has no names outside the header.
17. The mockup.
It shows the office desktop, not the Staff app. There's no table, energy pips, fit words, modes or corner pick.
The staff strip counts pad nights, not energy.
The class labels "Welter 69 kg", "Light 60 kg" and "Feather 57 kg" are pro words, and 69 kg isn't a class in either list.
It's drawn dark, not in the whiteboard style (Look B).
Part 2 of 3
2. Depth: 6/10
I tried to break it with four boxers, the head coach and two assistants.
Assignment is real, and right for the right reason. With 16 to 22 coached sessions against about 12 to 20 energy, someone trains alone or someone goes over budget. Over budget against next week's camp is a real two-week trade. Taught out moves the best table through a season.
Mostly the same pick every week. Within a week the fit varies only from about 14 to 70, and most of that comes from load and bond, which the player doesn't pick freshly each week. So the table settles: the pads coach on pads, the conditioning coach on conditioning, until a taught-out warning or a fight week. That's a decision about once a month per fighter, not weekly.
Tempers:
Motivator: hired only when someone is often low. LIFT's -12 to -8 is worth about 4 mood per loss.
Drill sergeant: PUSH is right with a disciplined, steady fighter and wrong with a flat one. That's a real mode choice.
Technician: POLISH and TEACH split cleanly on whether moves are under or over 30. Real, but it's decided by the fighter's moves, so it's mostly automatic.
Steady hand: TAPER inside 14 days and BUILD otherwise. Per coach, with mixed calendars across four fighters, this is a real trade. The only mode that is.
Bond: it matters at the corner (calls heard) and in the fit (-6 to +6). As written, nearly every pair reaches Trusted (logic 9), so it stops telling pairs apart.
Growth: noticed through raises, mainly as a cost (logic 13). The school and ceiling lines help.
Predicted gains in hundredths: "+0.26" against "+0.22" on one row is too small to feel, which hides the decision that does exist.
3. Play: 5/10
It pulls me on:
Seeing "taught out in about 3 weeks".
Choosing who works the corner and reading "about 4 of 6 heard".
A fighter's ask.
A raise to answer.
What holds it at 5:
20 cells and up to 4 mode toggles a week, with differences in hundredths. "Coach runs it" will take it most weeks.
TOP FIT, the headline word, never shows.
The mornings cut makes everything slower without a choice.
4. Options
Missing:
The week's total per fighter and area in whole points ("pads this week: +0.9 Accuracy"), not per session.
A cap and a shown result where morale trust, coachability and bond multiply at the corner.
A rule for a second refusal of a raise, and what the coach does next.
What the head coach's office time costs, and what "4 of 5" means on the head coach's card.
The second club coach's split between members' classes and fighters' mornings.
"Apart" as a shown state on the bond pips (no session together this week).
Useless as written:
TOP FIT (it can't occur).
Motivator DRILL and Steady hand BUILD, which are flat +5%.
The Technician's "from rating 65" line for the current pads coach.
The fighter's ask when that coach is already on the pads.
FOR GOOD's "starts at Stranger" for a pair that already has a bond.
The menus:
Menu	Right place?	Found?	Can't act on or wrong
Week board (Training)	Yes	Yes	TOP FIT never shows; gains in hundredths; "Power" is a summary stat; mornings at 0.6 cut today's gains
Staff app, coaches	Yes	From the desktop	Energy 8 + corner 3 > 10; the 65 line already met; Say No beats Pay
Staff app, table	Yes	Yes	20 cells weekly; FOR GOOD resets an existing bond; office cost undefined
Staff app, market	Yes	Yes	Fine; the ceiling range must sit above today's rating
Office desktop	Yes (S451)	Yes	The mockup counts pad nights, not energy; "Your coach" should be "Your assistant"
Fighter page, Training	Yes	Yes	Bond pips with no "apart" state
Fighter page, moves	Yes	Yes	Fine; step arrows wait for STEPMASTERY1
Learning-slot cards	Yes	Yes	Fine
Monday review	Yes	Yes	A raise about every 6 weeks per coach; the second refusal undefined
Bout card / fight week	Yes	Yes	Who shouts is undefined; no cap on the stacked multipliers; CHECK (John) on corner seconds
Fight: shouts	Yes	Yes	Fine once the cap exists
Result page	Yes	Yes	"Cost about 3 in 100" needs BONDPROBE1 first
Part 3 of 3
5. To reach 10/10
Mechanics, most important first.
Make the fit reach its own range.
State the base, 50.
Size the parts so the best real pair can reach 90 and the worst 10:
temper and mode -15 to +15
bond -10 / 0 / +8 / +12
weakest stat +8
taught out -4 / -8 / -12
load 0 / -8 / -16
Or keep the parts and set the words on the reachable range (TOP FIT 65+, RISKY under 30).
FITPROBE1 checks that TOP FIT shows on at least 1 row in 5 at some point in a season.
Measure the fit where it can be felt. Keep gain x0.80 to x1.20, and set the FITPROBE1 bar per area across a season: TOP FIT against RISKY worth at least 3 stat points in that area over 26 weeks. Print the week's total per area on the row, not each session's hundredths.
Don't cut today's mornings. An uncoached Light or Normal morning keeps today's factor from the best coach on staff in that area. Assigning a coach to a morning adds the fit on top and costs energy. FITPROBE1's "today" arm must match today's numbers.
Fix the energy sums in one unit.
An assistant has 11 energy (8 sessions + one corner night), or the corner costs 2.
A pad night with two fighters costs the coach 1 energy and counts once for growth.
Retire the pad-night count (PADPOOL1's 8, the mockup's "4 of 6") in favour of energy.
The head coach: 5 energy, the office costs 1.
Settle the head coach and the 60% rule. The player is always a coach. Sessions nobody is assigned to use the head coach's factor (60 in their background's area, 45 elsewhere), and the 60% rule only applies when the head coach is in the office. CHECK (Claude): CoachAreas.rating_for and the "no coach" case.
Replace the flat modes.
Motivator DRILL: +1 plan test per pad night that coach runs.
Steady hand BUILD: that coach's sessions raise the load-spike limit from 1.5 to 1.7 (the injury rule in 4.1).
Each mode changes something the player can see that isn't a flat gain.
Make bond scarce.
Bond builds only from pads, sparring and corner nights.
"Apart" means no session together that week (-1).
Thresholds 0 / 10 / 45 / 110, so one coach with four fighters reaches Trusted with one or two of them in a season.
FOR GOOD keeps the pair's existing bond. The -20 only falls on the coach losing the area mid-camp.
Make raises a real choice.
Growth +1 per 15 sessions (a raise about every 9 weeks).
Say No: energy -1 for 4 weeks. A second No within 12 weeks: energy -2 for 8 weeks.
Pay: the coach's ceiling range narrows by 2 at the top end (the coach invests).
The S412 bots check that neither answer wins more than 60% of the time.
The corner.
The player always shouts. The corner coach changes only how many calls are heard: morale trust times coachability times bond, capped at 1.10, floor 0.5.
The head coach working the corner costs 3 of their 5 energy, so fight week costs the office or a session.
CHECK (John): amateur seconds and who may stand in the corner.
The fighter's ask fires only when the trusted coach isn't already on her or his pads.
Number and word fixes:
Low is under 30.
The Technician's Sharp line set above the pads coach's 74 (for example 80), or dropped.
Predicted gains in the trained abilities, not Power.
The second club coach keeps the members' classes, and each fighter's morning they take costs a class (-5 members' target).
Redraw the mockup as the Staff app:
the table
energy, not pad nights
"Your assistant" in the mail
class labels from the game's lists
the whiteboard style
Probe order:
FITPROBE1, with the reachable range and the season-per-area bar
BONDPROBE1, with the new thresholds
the raise test, with the S412 bots
These need things the game can't do yet: the Staff app (OFFICE2), per-area coaches on mornings, the asks mechanic for coaches, step mastery, the rival gym's offer.
The 10/10 Staff app at 1920×1080
The shell stays: dark top bar, left rail. The content is a whiteboard in the office. The only names on the screen are in each coach card's header.
Header (full width, about 100 px): "Staff, week 11". Coach energy totals ("used 34 of 36"), sessions alone this week, the next fight week, and how many roster places are open. One pulsing button: Lock this week.
The table (centre-left, about 1150 x 620 px): fighter rows (portrait, class and record), with five area columns.
Each row starts with that fighter's week total in whole points for her or his focus ability, and the best swap's gain.
Each cell shows a coach magnet, a fit word with a bar, the week's points for that area, bond pips, and one warning chip (FRICTION, TAUGHT OUT IN 3 WKS, ALONE, OVER BUDGET).
Clicking a cell opens the swap popover, with This week only and For good, each showing its price.
Under the table: Copy last week, Coach runs it, and a lock per cell.
Coach cards (right, about 620 x 620 px, stacked):
Each card: comic portrait with the name in the card's header, temper word, and a mode toggle with its effect in one line.
Energy pips ("9 of 11", red past the line), area ratings with growth ("62 to 63 in 4 sessions"), the ceiling range.
The school's moves as chips, wage, and the raise if one is asked (Pay / Say no, each with its cost).
Fight week strip (bottom-left, about 1150 x 200 px, the one gold frame), shown only when a bout is within 14 days.
Who works the corner, as candidate cards with "about 4 of 6 heard" and the win swing.
The energy each candidate gives up, and the cutman beside them on pro nights.
Market (bottom-right, about 620 x 200 px): filters for area, temper, ceiling and wage. Two or three cards with temper, school, ceiling range and wage, and Hire (greyed with the reason when cash or the roster blocks it).
There's no fit score total and no best-table badge. Hovering any number shows its parts.
CHECK (Claude): the "no coach" rule in CoachAreas; which abilities each morning session feeds.
CHECK (John): amateur corner seconds.
CRITIC ANSWER: COACHFIT_CRITIC_S454_JOHN.md
COACHFIT_CRITIC_S454_JOHN - John answer (seat queue SQ70)
Brief: research/COACHFIT_CRITIC_S454_BRIEF.md
Sent: 2026-11-13 17:40 | collected: 2026-11-13 18:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.
Reading COACHFIT1 v3 against the pack now. The full critic return follows.
COACHFIT1 v3 (S454): critic
Depth 6/10, play 6/10. Assigning by area, coach energy as a two-week trade, weekly temper modes and a scheduled taught-out are the right parts. But the fit arithmetic can't reach its own top word, taught-out compares numbers on two different scales, and morning training gets a silent cut of about 40%. Until those are fixed, the probe bars can't be met as written.
I couldn't open office_a.png (it's on your computer, which is offline), so I judged from the text.
1. Logic check
The fit:
TOP FIT can never appear. The parts run from −36 to +20: temper −10 to +8, load 0 to −14, bond −6 to +6, taught out −6 to 0, weakest stat +6. With 50 as the neutral point, the best possible pair is 50 + 8 + 0 + 6 + 0 + 6 = 70.
TOP FIT (80+) never shows, and real gains run from about ×0.86 to ×1.08. That's almost the spread v2 was criticised for.
The FITPROBE1 bar ("TOP FIT against RISKY ≥ 0.5 a week") can't be tested.
Taught-out compares two scales. A coach's ceiling is an area rating (58–90). A fighter's stat is on the fighter scale (amateur women's lightweights sit 55–65).
Luke's pads are 74 and a 60-Technique fighter is already within 14. A ceiling range of 62–74 puts most club boxers within 10 from day one.
So −2 to −6 is on almost every row from week one, and "taught out in about N weeks" is meaningless.
Mornings:
They get a hidden cut. The pack's rule is that every morning gets the coach factor; with the 74-rated coach that's about 1.02. v3 makes Light and Normal mornings "train alone (0.6)" unless assigned. Most mornings are Normal, so a club with a good assistant loses about 40% of its morning gains.
The measured balance (5 stat points is about 72% to win) was built on today's training. It needs re-measuring, or this rule goes.
The head coach breaks the 60% rule. A rating of 60 in the background's area and 45 elsewhere gives a coach factor of 0.92 or 0.82. A club with no assistant then trains at 82–92%, not the pack's 60%, and the first hire loses most of its pull. The map flags HeadCoach.gd but not this effect.
Energy:
The arithmetic doesn't add up. "A list is 8 normal sessions with room for a corner night" is 8 + 3 = 11, against an energy of 10.
"+2 energy at that area's rating 80+" is unclear. Energy belongs to the coach, not to an area. Does the 90-conditioning coach get 12 for every area?
"A Hard session costs 1.5" is unclear for evenings. Is sparring Hard? Is an evening ever Hard?
The demand count is low. Four boxers × (3 pads + 1 sparring + 1–2 Hard mornings) is 20–24 sessions, not 16–22, before film.
Supply is 5 (head coach) + 10 (one assistant) = 15, or 25 with two.
So one assistant is always over and two never are. The weekly decision exists only with exactly one assistant and four boxers, which is the Bigger unit.
Film is a coached session that belongs to none of the five areas. Which coach runs it, and what fit does it use?
Tempers:
Two modes are flat-percentage training perks. Motivator DRILL (gains ×1.05) and Steady hand BUILD (×1.05 on conditioning) are what the map's rule forbids.
"Low mood (under 40)" is wrong. The pack's bands are Low under 30, Flat 30–49.
Technician POLISH "Sharp too from rating 65" doesn't say which rating (the overall 58 or the pads 74).
Drill sergeant PUSH's "plan tests" still have no fight value.
Raises:
Say no is always right. Refusing costs 1 energy a week for 4 weeks, about 4 sessions once. Paying costs $50 a week forever, about $2,600 a year. Nothing says the coach asks again or leaves.
Bond:
The thresholds don't match the stated timings. At +1 a session, a pair with 3–4 sessions a week reaches 35 in about 9–10 weeks and 90 in about 25. The map says Trusted at about 6 weeks and Corner at "half a season" in section 6 but "~13 weeks" in section 11.
A loss still pays more than a win. A loss gives +10 plus the corner's +6; a win gives +6.
Camps no longer exist for amateurs. "−20 when moved mid-camp" and the fighter's ask "for the camp" need the fight week, since amateur bouts have no camp.
The corner:
The player's shouts still aren't settled. The player is the head coach and makes every shout. The map never says what happens to the player's shouts when an assistant is picked. My reading is that the second passes them on, and the second's bond multiplies them. Say it.
"About 4 of 6 calls heard" has no unit. A bout has 18 exchanges, and the pack lets two instructions a minute through fully.
Names, pronouns and stat names:
Names on the corner pick break S448. "Name in the card's header" puts two or three names on one screen. Use portraits and roles ("the pads coach") on the cards, with the fighter's name once in the bout card's header.
The fixed pronouns are gone. "The fighter" and roles are used throughout.
"+0.26 Power" uses the summary stat. Power is read from Attrs.gd and isn't trained directly (S448). Use Strength, Explosiveness or Accuracy.
2. Depth: 6/10
Real on paper:
Triage when energy is short. Who goes "alone" this week, and is going over worth a tired coach next week?
The weekly mode. For example, the Steady hand's TAPER when a bout is inside 14 days.
Moving an area before a coach is taught out.
Saying no to a raise.
Where it breaks:
The screen solves the week for you. "Best swap: +0.4" on every row, plus Coach runs it, means the right answer is printed. By week 10, Monday is "press the best swap, Continue". The player can only beat it with what lasts beyond this week (bond by the next bout, growth, taught-out timing), and the table shows that only as a cell label.
A spread that's still small. The real fit range is ×0.86 to ×1.08, so the gains per row differ by tenths of a point.
Taught-out is always on because of the scale mismatch, so it stops carrying information.
Load binds only at one assistant with four boxers. At the starting Unit with 3 boxers, demand is 15–18 against 15, so it barely binds. With two assistants it never binds.
Saying no to a raise is always right.
Weekly modes become a habit. TAPER inside 14 days and BUILD otherwise is a rule the auto pick can follow, so after a month nobody touches the toggle.
The bond does matter now. It's in the fit and in the corner pick, so the "bond never matters" problem from v1 is fixed, as long as the corner rule above is settled.
3. Play: 6/10
Growth lines ("62 to 63 in 4 sessions"), a quarrel risk you can see, and a fighter asking for a coach give reasons to look at Monday. But the printed best swap and gains of tenths make the table a chore to approve, not a puzzle.
4. Options and menus
Menu	Verdict
Week board rows	Keep the fit word and predicted gain. Use Attrs stat names. "Alone" on every Normal morning is a nerf to today's training.
Staff card	Keep. Show the ceiling in fighter-stat units so taught-out reads true. Show energy as "8 of 10".
Mode toggle	Keep. Cut DRILL and BUILD as written (flat percentages).
Table: "best swap: +0.4"	Remove it. It hands over this week's answer.
Table: missing	A forward view per cell: weeks until taught out, bond step by the next bout, coach growth ticks this week.
Swap this week or for good	Keep.
Lock and Copy last week	Keep.
Coach runs it	Keep. It must not see the forward columns, so a planning player can beat it.
Monday raise (Pay or Say no)	Say no is always right. Needs a repeat ask and a growing cost.
Fighter's ask	Keep. Tie it to the fight week, not a camp.
Corner pick	Needs the shout rule stated and a unit for "calls heard". Use portraits and roles, not names.
Desktop "energy short next week"	Keep.
Market filters	Keep.
Result page "the unheard call cost about 3 in 100"	Keep, measured by BONDPROBE1.
5. To reach 10/10 (mechanics, most important first)
Make the fit reach its words. Base 50. Parts: temper and mode −14 to +12; load 0, −8 (1 over), −18 (2+ over); bond −8, 0, +6, +12; taught out −4, −8, −12; weakest stat +10.
The best real pair (Corner bond, right mode, weakest stat, in budget) is about 84, so TOP FIT exists.
A stranger in the wrong mode while over budget is about 10.
Keep gains at ×0.80 to ×1.20 and tiredness at ×1.15 to ×0.85.
FITPROBE1 re-sizes all the parts.
Put the ceiling on the fighter's scale. A coach can teach an area up to a fighter stat of 40 + area rating × 0.4 (ESTIMATE): pads 74 teaches to 70, conditioning 90 to 76, pads 58 to 63. Taught-out is graded against that number, the card shows it ("teaches Accuracy up to 70"), and growth raises it.
Keep today's mornings. Light and Normal mornings take the head coach's supervision factor. Only evenings and Hard mornings are coached sessions that get the pair's fit. Re-run the 5-point-gap test after the change.
Size the head coach to the 60% rule. The head coach's sessions use factor 0.6 + 0.004 × (background area rating 60, else 45): 0.84 in the background area and 0.78 elsewhere. A no-assistant club's mornings stay at 0.6, so the first hire still matters.
Fix energy.
A list is 10. A session costs 1; a sparring night or a Hard morning costs 1.5; a corner night costs 3.
+2 energy only if the coach's best area is 80+, on the card.
Film is a pads-area session at 1.
The probe target for one assistant with three boxers at the Unit is 1–2 over in a fight week. The decision has to exist at the start, not only at the Bigger unit.
Settle the corner. The player always shouts. The chosen second passes the calls on. A call lands at coachability × the morale trust number × the second's bond step.
Show "calls heard per round: about 2 of 3".
The head coach as second costs 3 of 5 energy, so in a fight week the player chooses between running sessions and working the corner.
Remove "best swap" and add forward columns. Each cell shows weeks until taught out, the bond step by the next booked bout, and growth ticks this week. Coach runs it optimises this week only. FITPROBE1 bar: a season-planning bot beats Coach runs it by 3+ wins in 100, or the table is cut to a monthly decision.
Make Say no cost more each time. The coach asks again every 4 weeks until paid. Each refusal adds −1 energy for 4 weeks (stacking) and −2 bond with every fighter on the list. After the third refusal the card shows "will leave at the next offer" (needs the rival gym's offer, AGREED, NOT BUILT).
Replace the flat modes.
Motivator DRILL: a twist card with a mood cost costs 2 less this week.
Steady hand BUILD: conditioning sessions don't count in the load ratio this week.
Neither changes gains.
Fix the bond rates. Thresholds 0, 6, 25, 60 at +1 a session, so a pair with 3–4 sessions a week reaches Working in about 2 weeks, Trusted in about 7 and Corner in about 17. Then +6 per corner, +4 for a loss together, −1 a week apart. "Mid-camp" and the ask "for the camp" become "inside the fight week".
Make modes harder to auto-pick. Each mode reads one fact the auto pick doesn't weigh: the Drill sergeant's PUSH pays +2 mastery on a move one night from crossing a tier. That leaves the player a reason to flip it by hand.
Small fixes: Low mood is under 30; predicted gains use Attrs names; the Technician's Sharp unlock reads the pads rating; corner cards use portraits and roles with no names.
The 10/10 Staff app at 1920×1080 (office desktop, full screen)
Window title bar, 56 px: "Staff" with the club name once. Energy across the club ("31 of 35 this week, 28 next"). Copy last week and Coach runs it. The one pulsing button is Confirm the week.
Left column, 480 px: THE COACHES. One card each, by portrait and role:
Energy pips ("9 of 10", and "tired: 8 next week" in amber).
Area bars, each with "teaches up to 70" and growth progress.
The temper word and the A or B mode toggle, with this week's effect in one line.
School chips. Wage, with a raise flag when one is asked.
The head coach's card on top: 5 pips, the background area, no wage.
Centre, 960 px: WHO RUNS WHAT. Fighter rows (portrait and class) by five area columns, plus a FILM cell.
Each cell: coach portrait, a FIT bar with its word, predicted gain ("+0.3 Accuracy"), bond pips, and one tag (FRICTION, TAUGHT OUT IN 3 WKS, or ALONE).
A lock icon on each cell.
Under each row: weeks until taught out for the soonest area, and the bond step by the next bout.
Drag to swap. The ghost shows the new fit, energy, the bond effect, and This week only or For good.
Right column, 400 px: WHAT THIS WEEK COSTS AND BUILDS.
Per fighter: the focus gain against Coach runs it.
Per coach: growth ticks and energy left.
Bonds that cross a step this week.
Risks in red: over budget, a 1-in-6 quarrel, taught out inside 2 weeks.
On a fight week, the corner pick: the second's portrait and role, calls heard per round, the win swing, and the energy price.
Bottom strip, 140 px: THE MARKET. Four candidate cards (portrait, role, temper, "teaches up to", energy, wage, ceiling range), filters for area, temper, ceiling and wage, and Hire. A greyed card gives its reason.
Show More
COACHFIT1_V4 — Coaches who Fit, Fill Up, Grow, Have a Temper and Bond
Design Map — S459 | Version 4.0 | 2026-11-13
Scores target: Depth ≥7/10, Play ≥7/10 | All estimates marked [ESTIMATE]
Sources: COACHFIT1_V3, Kalli S454, John S454, FightCamp Critic Pack S403, S448, S451
CONTENTS
The Core Idea
Fit: Formula, Range & Visibility
Coached Sessions, Energy & Morning Rules
Growth, Ceilings & Raises
Tempers & Weekly Modes
Bond & Fighter Requests
The Head Coach & the 60% Rule
Corner Assignment & Call Clarity
Coach Schools & Mastery
The Weekly Decision: Interface & Workflow
Probe Suite & Validation Targets
Full Menu Wiring & Screen Map
Build Order
Held Back / Not Yet Built
Open Questions
1. THE CORE IDEA
Each week you assign which coach runs which training area for each fighter. Every row shows the predicted weekly gain in whole stat points, not percentages. Fit is per pair — coach × fighter — and changes week to week with energy load, bond, temper mode, growth progress and calendar. Over-budget energy trades this week's performance for next week's recovery. Taught-out warnings appear weeks in advance. Bonds build slowly and matter most when your fighter needs someone in their corner.
2. FIT: FORMULA, RANGE & VISIBILITY
2.1 — Base & Formula
Base fit: 50 (neutral reference point)
Fit range: 10–90 — designed so TOP FIT actually appears
Final fit = 50 + Σ(components), clamped 10–90
Gain multiplier = 0.80 + (fit ÷ 250) → ×0.80 at fit=0 → ×1.16 at fit=90
Tiredness multiplier = 1.15 − (fit ÷ 200) → ×1.15 at fit=0 → ×0.70 at fit=90
Table
Component	Range	Notes
Temper + Mode	−14 to +12	Read weekly from mode toggle + fighter state
Energy Load	0 / −8 / −18	0 = within budget; −8 = 1 over; −18 = 2+ over [ESTIMATE]
Bond Step	−8 / 0 / +6 / +12	Stranger/Working/Trusted/Corner
Taught-Out Gradient	0 / −4 / −8 / −12	Within 10 / 6 / 3 of ceiling
Weakest Stat Match	0 / +10	Session targets the fighter's lowest stat in that area
2.2 — Fit Tiers & Visibility
Table
Word	Fit Range	Gain Multiplier
TOP FIT	75–90	×1.10–1.16
GOOD	55–74	×1.02–1.09
MIXED	35–54	×0.94–1.01
RISKY	10–34	×0.80–0.93
Display: Every session row shows: +0.4 Strength — TOP FIT (whole numbers, not hundredths). Hover expands to list all components with their point values.
FITPROBE1 Target: TOP FIT vs RISKY on a focused area = 0.45–0.65 stat points/week [ESTIMATE]; over 26 weeks = 3.5–5.0 total points difference; TOP FIT visible on ≥20% of rows across a season.
✅ Answers Kalli #1, #2 & John #1: Fit now reaches 90; TOP FIT actually appears; spread meets the 0.5+ target on focused work.
3. COACHED SESSIONS, ENERGY & MORNING RULES
3.1 — What Counts as Coached
Table
Session Type	Coached?	Energy Cost	Notes
Evening: Pads / Sparring / Film	✅ Yes	1.0 / 1.5 / 1.0	Always coached
Hard Morning	✅ Yes	1.5	Requires coach assignment
Normal / Light Morning	⚠️ Supervised	0.5 if assigned	Uses head coach factor × fit if assigned; baseline factor if not — NO SILENT 0.6 NERF
Key fix: Uncoached mornings use the supervision baseline (0.80 × head coach factor), NOT 0.6. Assigning a coach adds their fit bonus on top and costs energy. Today's training numbers remain intact.
✅ Answers Kalli #3 & John #2: Morning training no longer gets a hidden cut.
3.2 — Coach Energy Budget [ESTIMATE]
Table
Coach Type	Weekly Budget	Corner Cost	Notes
Assistant Coach	11	3	8 sessions + corner = full budget; +2 energy if primary area ≥80 rating
Head Coach (Player)	5	3	Office overhead = 1 energy; 4 sessions available per week
2nd Club Coach	5	0	Conditioning mornings only; runs fitness classes (no energy cost, −5 member target per morning used)
Film Session: Counts as 1.0 energy under the Pads area
Two fighters, one pads coach: 1 energy total, NOT per fighter; growth counts for both fighters
Over Budget: Deficit → next week's budget reduced by that amount ("Next week: 9/11")
Budget warning: Appears on the Desktop 3 days before week lock — "Coach at 10/11 next week"
✅ Answers Kalli #4 & John #3: Energy sums balance; office cost explicit; shared sessions cost correctly.
4. GROWTH, CEILINGS & RAISES
4.1 — Ceilings (Fixed Scale Issue)
Coach ceiling now translates to the fighter stat scale: teaches up to = 40 + (coach_rating × 0.4)
Example: Pads coach (74) → teaches Accuracy up to 69.6 → 70; Conditioning coach (90) → teaches Stamina up to 76
Display on coach card: Teaches Accuracy up to 70 + 64 → 66 in 8 sessions
Taught-out warning: Shows when fighter stat ≥ teaches_up_to − 10 → Taught out in ~5 weeks
✅ Answers John #2: Ceilings now compare like-to-like.
4.2 — Growth
+1 area rating per 15 sessions coached (slower pace)
School mastery bonus: moves in coach's school = ×1.15 learning speed
4.3 — Raises & Compensation
Trigger: every 5 rating points gained → Monday review shows request
Cost: +$50/week permanent
Options:
PAY: Cost applies; coach's ceiling narrows upward by +2 ("investing in their work")
SAY NO: −1 energy for 4 weeks; bond −3 with all fighters on their list
2nd NO within 12 weeks: −2 energy for 8 weeks; bond −6; coach flags "Seeking other work"
3rd NO / 2 flags: Leaves at next month-end if rival offer system is built; otherwise stays at −3 energy permanently
✅ Answers Kalli #13 & John #5: Say No is no longer always optimal — costs compound; Pay gives a tangible benefit.
5. TEMPERS & WEEKLY MODES
Table
Temper	Mode A (Default)	Mode B	Fit Effect
Motivator	🟢 LIFT: Loss mood hit −12 → −8; +3 mood/week for Flat/Low fighters	🟡 SHIELD: Twist cards with mood cost cost −2 less	+6 with Low mood fighter; no flat % anywhere
Drill Sergeant	🟢 PUSH: Sparring = ×1.25 mastery; +3 fatigue	🟡 EASE: Normal fatigue; no friction risk	−8 with Low mood in PUSH; +4 with Discipline ≥70
Technician	🟢 POLISH: Usable+ moves learn ×1.15; Sharp unlock at 80 rating	🟡 TEACH: New/Raw moves learn ×1.10	+4 with Coachability ≥70; Sharp unlock above current coach's 74
Steady Hand	🟢 TAPER: Bout <14d away → tiredness ×0.85	🟡 PREPARE: Load ratio limit 1.5 → 1.7 (safer hard sessions)	+4 when bout <14d; no flat % anywhere
Correction: Low mood = under 30; Flat = 30–49 (matches pack values)
Removed: Motivator DRILL ×1.05; Steady hand BUILD ×1.05 — flat percentage perks eliminated
✅ Answers Kalli #6, #7 & John #4: No flat % bonuses; mood bands corrected; Technician unlock above current coach's rating.
6. BOND & FIGHTER REQUESTS
6.1 — Bond Mechanics
Per coach–fighter pair; NOT club loyalty
Build: +1 per coached session together; +4 per corner worked; +6 after a win; +10 after a loss survived together
Decay: −1 per week with NO sessions together (explicit "apart" state)
Thresholds adjusted for scarcity:
Table
Step	Required	When Typically Reached	Fit Bonus
Stranger	0	Start	±0
Working	10	~2–3 weeks	+6
Trusted	45	~10–14 weeks	+10 + fighter requests
Corner	90	~20–28 weeks	+12 + call bonus
Swap — For Good: Bond carries forward at −15 temporary penalty for 3 weeks; does NOT reset to Stranger
Swap — This Week Only: Bond paused; −2 fit penalty that week only
Fighter's Ask (Trusted+): Fires only when their preferred coach is NOT assigned to that area — "She works best with the pads coach — reassign for camp?" HEAR (+5 mood, reassign) / OVERRULE (−5 mood, keep current)
✅ Answers Kalli #7, #10, #11 & John #6: Bond scarce enough to matter; swap preserves bond; ask only when meaningful.
7. THE HEAD COACH & THE 60% RULE
Head coach has a rating per area: 60 in background specialty; 45 elsewhere
Factor calculation: 0.5 + (rating × 0.7 ÷ 100) → 0.92 in specialty, 0.815 elsewhere
60% rule applies only when NO coach is assigned → unassigned sessions = 0.60 baseline; head coach factor only applies when explicitly assigned to that session
Head coach energy: 5 total; 1 consumed by office duties → 4 available sessions + corner availability
Second club coach: Runs fitness classes by default (+40 members, +$280/week). Assign to a conditioning morning = −5 from member growth target that week.
✅ Answers Kalli #5, #14 & John #2, #3: 60% rule preserved; head coach energy balanced; second coach dual role clear.
8. CORNER ASSIGNMENT & CALL CLARITY
The player always chooses shouts. An assistant in the corner only affects how many get through, NOT what is said
Call success rate = MIN(1.10, morale_factor × coachability × bond_factor) → floor 0.5
Display on bout card:
Your assistant in corner: Calls heard ~5 of 6 | Win edge: +2.8% vs head coach alone
Head coach in corner: 100% what you say; costs 3 of 5 energy — visible tradeoff: "Working corner → loses 1 session slot this week"
Cutman: Separate role — "$150/pro fight; reduces cut severity by 40%" — shown beside corner pick, never mixed in
No names — portraits + role labels only; fighter's name appears once in bout header only
✅ Answers Kalli #8, #12 & John #7, #8: Corner rule explicit; stacking capped; names only in headers.
9. COACH SCHOOLS & MASTERY
Each coach has 5–7 moves/combos in their school — listed fully on their card
In school: ×1.15 mastery speed; Outside school: ×0.75
Head coach school by background:
Ex-pro: Jab, Cross, Lead Hook, Check Hook
Amateur coach: Jab, Cross, Body Hook, 1-2
Strength coach: Body Hook, Uppercut, Heavy combinations
Old Hand: Jab, Lead Hook, Step-back, Tight defence
School bonus appears on move bars: +15% learning — in pads coach's school
10. THE WEEKLY DECISION: INTERFACE & WORKFLOW
10.1 — Staff App / Office Desktop (Full Screen, Look B Style)
Table
Zone	What Shows	Actions
Top Bar	Week #, energy used/available, next fight date	Copy Last Week • Coach Runs It • Lock All • Confirm Week
Left — Coach Cards	Portrait + role, energy pips, temper + mode toggle, ceiling/teaching range, school chips, wage + raise flag (if active)	Toggle mode • Hire • View contract
Center — Assignment Table	Fighter rows × 6 columns (Pads, Sparring, Film, Cond., Strength, Bag). Each cell: coach portrait, fit word + bar, weekly gain (+0.4 Acc), bond pips, 1 warning tag	Click → Swap (This Week / For Good) • Lock cell
Row Footer	Weeks until taught-out (soonest area), bond step by next bout	—
Right — Preview	Per fighter: focus stat change vs auto-schedule; per coach: growth tick, energy remaining; risks in red	—
Fight Week Strip (only if bout <14d)	Two portraits: your corner options, calls heard %, win delta, energy cost; cutman toggle	Select corner • Confirm
Bottom — Market	Filter: Area/Temper/Ceiling/Wage; cards show role, temper, ceiling, wage, school snippet	Hire (greyed: reason shown)
REMOVED: "Best swap: +0.4" — auto-optimiser does NOT show the answer. Coach Runs It optimises this week only; forward planning is the player's job
Hover over energy over: Lists which sessions pushed it over, newest first
Taught-out appears on the cell itself: "Taught out in ~4 weeks" — never a surprise
✅ Answers John #4, #9: No free answers; forward planning visible; mockup aligned to spec.
10.2 — Monday Review
Growth milestone: "Pads coach reaches 70 — teaches Accuracy to 72 now"
Bond crossed step: "Trusted with your lightweight"
Raise request: "$50/week — Pay or Say No?"
Fighter ask: "Welterweight wants the pads coach — fight week starts Friday"
Energy warning: "Next week: 12/11 — one session will run short"
11. PROBE SUITE & VALIDATION TARGETS
Table
Probe	What Validates	Pass Target
FITPROBE1	Fit range & visibility	TOP FIT ≥1 row/week on avg; TOP vs RISKY ≥0.45–0.65/week focused; 3.5–5.0 over 26w; no component >40% of total
BONDPROBE1	Bond impact & scarcity	Stranger → Corner worth +2–4 wins/100 close bouts; ≤1–2 Trusted pairs/coach at a time; thresholds land on schedule
RAISEPROBE1	Raise choice balance	Pay chosen 40–60% of time across bots; neither option dominates long-term
MODEPROBE1	Mode distinctness & value	Each mode best choice in ≥1 week scenario; no flat % effects; auto can't always pick the right one
BOTSUITE S412	Overall balance	No bot beats loyal by >5%; farm strategy fails long-term; best table changes ≥5×/season per fighter
12. FULL MENU WIRING TABLE
Table
Menu / Screen	What COACHFIT1 Shows There	Wired To Systems
Week Board → Training Tab	Per session: coach/Alone, fit word, weekly gain, warning tag (FRICTION/TAUGHT OUT/ALONE/OVER BUDGET); hover = fit breakdown	CoachFit, CoachEnergy, PadWeek, WeekPlan
Office → Staff App — Coach Cards	Role portrait, temper, mode toggle, energy pips, ceiling/teaches-to, growth progress, school list, wage, raise button	CoachEnergy, CoachGrowth, CoachSchool, StaffRoles
Office → Staff App — Assignment Table	Fighter × area matrix; fit bar, weekly gain, bond pips, warnings; swap popover; lock; copy last week	CoachFit, Bond, CoachEnergy, WeekPlan
Office → Staff App — Market	Filterable coach cards: temper, teaches-to, school, wage, energy; Hire button	StaffRoles, CoachSchool
Office → Desktop	Energy short next week; raise pending; fighter ask; bond milestones	OfficeDesk, Notifications
Fighter Page → Training	Current coach per area; bond step; next milestone	CoachFit, Bond
Fighter Page → Moves/Playbook	School bonus indicator on move bars	CoachSchool, MoveMastery
Monday Review	Raises, growth, bonds, fighter asks, energy outlook	CoachGrowth, Bond, WeekCoach
Bout Card → Fight Week	Corner options: portrait+role, calls heard %, win delta, energy cost; cutman toggle	Bond, CoachEnergy, FightCorner
Fight Night → Shouts	"Heard clearly / Half heard / Missed" — bond modulates frequency	Exchanges, Bond
Result Page → The Why	"Corner: Trusted — 5 of 6 calls heard; unheard call cost ~2.7 in 100"	FightWhy, BONDPROBE1 data
13. BUILD ORDER
Probes First: FITPROBE1, BONDPROBE1, RAISEPROBE1, MODEPROBE1 — validate numbers before screens
Core Systems: CoachFit (formula + range), CoachEnergy (budgets + overflow), Bond (scaled thresholds + apart decay), Temper (modes without flat %), CoachGrowth (slower pace + ceiling translation)
**
Chat
Create Videos
Create Images
Writing
Homework
Translate


# CRITIC ANSWER: DESIGN_COACHFIT1_V4_CRITIC_KALLI_KALLI.md

# DESIGN_COACHFIT1_V4_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ81)

Brief: research/DESIGN_COACHFIT1_V4_CRITIC_KALLI.md
Sent: 2026-11-13 22:10 | collected: 2026-11-13 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring COACHFIT1 v4 now. The critique follows in parts.

Part 1 of 3

# COACHFIT1 v4: critic (S459, Kalli)

**Depth 6/10, General design 4/10, Play 6/10.** It doesn't pass the S459 bar yet, because General design is under 6.

I judged from the map's text and the pack. I didn't open CRITIC_ACCESS, the Miro board, the screens or the code, and the map names no mockup.

**What v4 fixes:**
- The fit now reaches its top word.
- The flat +5% modes are gone.
- Turning down a raise now costs more each time.
- "Best swap" is removed.
- Film gets its own column.
- Swapping for good keeps the bond.
- The fighter's ask fires only when it means something.
- The player always shouts, and stacked call multipliers are capped.

**What still breaks it:**
- Two bond tables disagree.
- The mornings rule contradicts itself and still cuts today's training.
- The probe targets contradict each other and can't be met.
- One shared pad night for every fighter breaks the energy limit.
- The map stops partway through section 13.

## 1. Logic check

**The fit**

1. **The bond table appears twice with different numbers.** Section 2.1 gives Stranger −8, Working 0, Trusted +6, Corner +12. Section 6.1 gives ±0, +6, +10, +12. The fit's range, the tier words and both probes depend on which is right.
2. **Average fit now cuts tiredness for everyone.** Tiredness = 1.15 − fit/200 gives ×0.90 at the neutral 50, not ×1.00. v3 had ×1.00 at 50. Every session in the game gets 10% less tiredness from this alone. That moves overreach (80+) and the load-spike rule without anyone choosing it.
3. **The tier table doesn't match the formula.** The fit can't go below 10, so the lowest gain is ×0.84, not the ×0.80 printed for RISKY.
4. **The probe targets contradict each other.** "0.45-0.65 a week" times 26 weeks is 12 to 17 points, not "3.5-5.0 over 26 weeks". The reachable spread is about TOP FIT 80 (×1.12) against RISKY 25 (×0.90). On a focused week of about 0.9 points, that's roughly 0.2 a week, so the weekly target fails and the season target only just holds. Pick the season target.
5. **"Whole numbers, not hundredths" sits next to "+0.4 Strength".** One session is about a fifth of a week's gain (about 0.2), so the row can't show a whole point. The table in section 10 says "weekly gain", but section 2.2 says "every session row". Settle on a weekly total per area.

**Mornings and the head coach**

6. **Section 3.1 and section 7 give different rules.**
   - 3.1: an unassigned morning trains at 0.80 × the head coach factor.
   - 7: an unassigned session trains at 0.60, and the head coach factor applies only when assigned.

   Under both rules, a club with a 74-rated assistant drops from today's 1.02 on mornings to 0.65-0.74 or 0.60. "Today's training numbers remain intact" is false. CHECK (Claude): which coach factor CoachAreas gives a morning today.
7. **The head coach's factor is kept at 0.92 / 0.815.** John's sized version (0.84 / 0.78) wasn't taken, and section 7 doesn't say why. The first hire still only adds 0.10 over the head coach.
8. **The head coach in the corner hears "100% what you say".** That breaks the pack: morale trust reaches the corner whoever stands there (Low 0.7), and a Low fighter stops listening. The cap formula has to apply to the head coach too.
9. **Corner cost against the office.** The head coach has 5 energy, 1 goes to the office and 3 to a corner night, which leaves 1. The map prints "loses 1 session slot", but it's 3. Change the text.

**Energy**

10. **A shared pad night costs 1 energy whoever comes.** Nothing caps how many fighters share it or splits the 240 units (PadWeek). Four fighters on one pad night is then 1 energy, and the energy limit disappears. Today PadWeek splits a night's units over its cards.
11. **Normal and Light mornings cost 0.5 when assigned.** That's a new cost, which is fine, but with point 6 the player pays energy just to get back today's numbers.
12. **The second club coach.** "+40 members, +$280/week" reads as income. In the pack, $280 is that coach's wage. "−5 from the member growth target that week" doesn't fit a target that moves at most 6 a week. Say whether it's the target or one week's change.

**Growth and raises**

13. **Pay "narrows the ceiling upward by +2" needs plain words.** Write it as "teaches up to +2".
14. **The raise doesn't come back.** A second refusal only happens at the next 5-point raise, about 9 weeks later at 15 sessions a point, so "within 12 weeks" just works. Without John's repeat ask, a coach who's turned down once stops asking until they grow again. Also unstated: what the next raise asks for, and whether a refused raise carries over.
15. **The permanent −3 energy.** When the rival gym isn't built, the third refusal leaves the coach on −3 energy for good. That's 27% of an assistant forever, and you can't undo it by paying later. Add "Pay now ends it".

**Tempers**

16. **The quarrel is gone.** v3's FRICTION rule (1 in 6, −15 bond, −5 mood) isn't in v4, yet EASE still says "no friction risk" and the warning tags still list FRICTION.
17. **PUSH now gives −8 only with Low.** v3 also applied it with Flat. With the quarrel gone, PUSH has no cost with a Flat fighter.
18. **SHIELD barely does anything.** Twist cards come once a week and only some carry a mood cost, so "−2 less" is about 1 mood a week. LIFT gives +3 a week to every Flat or Low fighter, so SHIELD loses whenever anyone is Flat.
19. **PREPARE's 1.7 limit has no clear target.** The load ratio belongs to the fighter, not the coach. Say it reads "the fighter's ratio this week, when this coach runs the Hard sessions".
20. **The modes can still be picked by a rule.** TAPER under 14 days, otherwise PREPARE. John's point 10 (give each mode a fact the auto-pick doesn't weigh) isn't answered, and MODEPROBE1 states the hope as a target without a mechanism.

**Schools**

21. **"Outside school ×0.75" is a new cut.** v3 cut only Signature work outside the school, to ×0.5. Now most moves learn 25% slower than today's pads rate of 2.1 an hour.
22. **Stacking and invented moves.**
   - School ×1.15 times POLISH ×1.15 is ×1.32 with no cap.
   - "Heavy combinations" and "Tight defence" aren't moves in the game.
   - "Step-back" is a StrikeMap arrow with no mastery until STEPMASTERY1.
   - "1-2" is a book combination, which is allowed.

**Bond**

23. **Bond is still not scarce.** +1 for every coached session, including mornings, with thresholds 10/45/90. One pads coach on four fighters gets all four to Trusted in about 12 weeks. That breaks BONDPROBE1's own "≤1-2 Trusted pairs a coach".
24. **A loss still pays more than a win (+10 against +6).** It's also unstated whether the bout bonus goes to every coach on that fighter or only the corner.
25. **"−15 for 3 weeks" after a swap.** It doesn't say whether that's bond points or fit. It also falls on the new pair, not on the coach who lost the area.

**The corner**

26. **"Calls heard ~5 of 6" still has no unit.** The pack lets two instructions a minute through fully. Use "about 2 of 3 a round".
27. **Wrong word and invented number.**
   - "Win edge +2.8%": the game says "in 100".
   - "Cutman reduces cut severity by 40%": the pack says the cutman halves post-bout layoffs.
   - A cutman toggle on an amateur bout doesn't exist, because the cutman is pro nights only.

**Words and rules**

28. **Fixed pronoun.** "She works best with the pads coach" breaks S412.
29. **Class words.** "Welterweight wants the pads coach" and "Trusted with your lightweight": welterweight isn't an amateur class here. Use the class in kg.
30. **"Reassign for camp?"** Amateur bouts have no camp. Use "for the fight week".
31. **Missing from the map:**
   - No owner rule is quoted (S448 and S412 aren't in the map).
   - Many numbers have no ESTIMATE mark: school ×1.15 / ×0.75, the bond bout values, the raise penalties, the 0.80 supervision factor.
   - It uses emoji and claim ticks ("✅ Answers Kalli #7") whose numbers don't match: my #7 was the flat modes, not bond.
32. **The map is cut off.** Section 13 stops at step 2. "Held back / not built" and "Open questions" are in the contents but missing.
33. **Names.** None found outside headers, apart from the pronoun in point 28. Corner cards use portrait and role, which is right.

Part 2 of 3

## 2. Depth: 6/10

I tested it with four boxers at the Bigger unit, the head coach and one assistant.

**Real choices now:**
- **Energy triage.** Demand is 3 pads + sparring (1.5) + 1-2 Hard mornings (1.5) per boxer, about 6-7.5 each and 24-30 for four, against a supply of 15-17. Someone trains unassigned, or someone goes over budget and pays next week. With three boxers at the starting Unit it still binds (18-22 against 15-17). That fixes John's point that it only bound at one size.
- **Raises.** Paying ($2,600 a year) against compounding refusals (energy, bond, permanent −3) is close enough to need judgement.
- **Drill sergeant PUSH or EASE**, read from the fighter's mood and discipline.
- **Technician POLISH or TEACH**, read from the move tiers.
- **Moving an area before it's taught out.** Now meaningful, because the ceiling is on the fighter's scale ("teaches up to 70").
- **Who works the corner** against the head coach's energy in fight week.

**What holds it at 6:**
- The shared pad night (logic 10) solves energy for free once a player finds it.
- Bond still makes almost every pad pair Trusted, so it stops telling pairs apart.
- TAPER / PREPARE and LIFT / SHIELD each follow a rule, so two of the four mode toggles are automatic.
- The weekly gap between TOP FIT and RISKY is still about 0.2 of a point, so it's felt over a season, not a week.

## 3. General design: 4/10

The parts are mostly the game's own (CoachAreas, PadWeek, StaffRoles, twist cards, the load ratio), so it's buildable. But it breaks itself or the game in about a dozen places:
- The two bond tables.
- The two morning rules.
- Tiredness at neutral fit.
- Probe targets that disagree.
- A head coach who hears 100%.
- The ×0.75 cut outside a coach's school.
- Invented moves and an invented cutman number.
- A fixed pronoun and a pro class word.
- No owner rules quoted.
- A map cut off at section 13.

## 4. Play: 6/10

**It pulls me on:**
- "Teaches Accuracy up to 70" and "taught out in about 5 weeks".
- A coach reaching 80 so the Technician's Sharp line opens, about 11 weeks in.
- A raise that bites either way.
- The corner pick with its energy price.
- Comparing the week against Coach runs it.

**Holds it at 6:** four buttons in the top bar, up to 24 cells a week, and two modes that are automatic.

## 5. Options

**Missing:**
- A cap on fighters per shared pad night, with how the 240 units split across them.
- A repeat raise ask, and "Pay now" to end working to rule.
- Let go on a coach card. The pack's staff jobs cost a week's pay to let go, and the main assistant is NOT ESTABLISHED.
- The quarrel row and its three answers (switch to EASE, move the area, keep going).
- A unit for calls heard ("about 2 of 3 a round").
- A season bar for Coach runs it (John: a planning bot beats it by 3+ in 100).
- Section 14 (what's not built) and section 15 (open for the owner).

**Useless as written:**
- "View contract": coaches have no contract system.
- The cutman toggle on amateur bouts.
- SHIELD (about 1 mood a week).
- "Lock All" beside per-cell locks and Copy last week: it adds a fourth button and duplicates them.
- "Head coach 100% heard": that choice always wins until it's fixed.

**What each option changes:**

| Option | Changes |
|---|---|
| Swap, this week only | the pair for one week; bond paused; −2 fit |
| Swap, for good | the area's coach; bond kept; −15 (unclear what) for 3 weeks |
| Lock cell | Coach runs it skips the cell |
| Copy last week | refills the table |
| Coach runs it | best table for this week only |
| Mode toggle | one effect per temper for the week |
| Pay / Say no | wage +$50 and teaches-up-to +2 / energy and bond penalties, compounding |
| Corner pick | calls heard, against energy |
| Fighter's ask: hear / overrule | +5 mood and reassign / −5 mood |
| Hire (market) | a new coach card |

**The menus:**

| Menu | Right place? | Wired? | Can't act on or wrong |
|---|---|---|---|
| Week board, Training | Yes | CoachFit, CoachEnergy, PadWeek, WeekPlan | per-session "+0.4" against weekly; tiredness at neutral |
| Staff app, coach cards | Yes | CoachEnergy, CoachGrowth, CoachSchool, StaffRoles | View contract useless; no Let go |
| Staff app, table | Yes | CoachFit, Bond, CoachEnergy, WeekPlan | shared pad night unpriced; FRICTION tag has no rule |
| Staff app, market | Yes | StaffRoles, CoachSchool | fine |
| Office desktop | Yes | OfficeDesk, "Notifications" (no such system named in the pack) | wire it to Needs |
| Fighter page, Training | Yes | CoachFit, Bond | fine; show "apart" |
| Fighter page, moves | Yes | CoachSchool, MoveMastery | the ×0.75 cut shows on most bars |
| Monday review | Yes | CoachGrowth, Bond, WeekCoach | "Welterweight" and "lightweight"; "for camp" |
| Bout card, fight week | Yes | Bond, CoachEnergy, FightCorner | cutman toggle on amateur nights; "%" |
| Fight night, shouts | Yes | Exchanges, Bond | head coach at 100% |
| Result page, the Why | Yes | FightWhy | "2.7 in 100" needs BONDPROBE1 first |

Part 3 of 3

## 6. To reach 10/10

Most important first.

1. **Finish the map and use one table for each thing.**
   - One bond table. I'd keep 2.1's: Stranger −8, Working 0, Trusted +6, Corner +12.
   - One morning rule.
   - Restore sections 13-15 in full.
   - Quote S448 and S412 at the top.
   - Mark every new number ESTIMATE.
   - Drop the emoji and the "Answers #n" ticks, and put a two-column table of critic point against change in their place.
2. **Price the shared pad night.** Up to 2 fighters share a pad night for 1 energy, and each gets 120 of the 240 units (PadWeek's split). A third fighter needs a second night. FITPROBE1 checks that sharing never beats separate nights on mastery.
3. **Keep today's mornings.**
   - An unassigned Normal or Light morning trains at today's factor: the best coach on staff in that area, or 0.6 with no assistant.
   - Assigning a coach (0.5 energy) adds the fit on top.
   - Delete section 7's "unassigned = 0.60" line.
   - Re-run the 5-point-gap test (5 points ≈ 72% to win).
   - CHECK (Claude): CoachAreas' morning factor today.
4. **Make neutral fit neutral.** Tiredness = 1.15 − 0.003 × fit, which gives ×1.00 at 50 and ×0.88 at 90. Gains stay 0.80 + fit/250, and the RISKY floor is printed as ×0.84.
5. **One probe target that can be met.** TOP FIT against RISKY is worth 3.5-5.0 points in a focused area over 26 weeks. Drop the weekly figure. Rows print the week's total per area ("pads this week +0.9 Accuracy"), not per session.
6. **Make bond scarce.**
   - Only pads, sparring and corner nights build it (+1 each). Mornings don't.
   - Thresholds 0 / 10 / 45 / 110.
   - Bout bonus only to the corner coach: +4 win, +4 loss.
   - The −20 falls on the coach losing the area for good, not on the new pair.
   - Target: one pads coach reaches Trusted with 1-2 of four fighters in a season.
7. **Every voice in the corner goes through the cap.** Calls heard = coachability × morale trust × bond, capped at 1.10 with a floor of 0.5, for the head coach too, whose bond is the Loyalty "known" level. Print "about 2 of 3 calls heard a round" and "+n in 100". The corner costs the head coach 3 of the 4 sessions left after the office, and the text says 3.
8. **Bring the quarrel back.** PUSH with a Flat or Low fighter shows FRICTION. Each week at friction there's a 1 in 6 chance of a quarrel (−15 bond, −5 mood) (ESTIMATE). The row offers three answers: EASE, move the area, keep going.
9. **Two modes the auto-pick can't solve.**
   - Motivator SHIELD becomes TALK: the next corner TALK from this coach's fighters lands one step better (calm to fire up), so it reads the fight calendar against mood.
   - Steady hand PREPARE: +2 mastery on any move one session from a tier, which the auto-pick doesn't weigh.
   - MODEPROBE1 bar: the hand-set mode beats the rule pick in 1 week in 4.
10. **Schools without a cut.**
    - Outside the school, today's rate (×1.00).
    - In the school ×1.10.
    - School and POLISH capped at ×1.20 together.
    - Head coach schools use only game moves and book combinations (Old hand: Jab, Lead hook, Check hook, 1-2).
    - Step-back joins after STEPMASTERY1.
11. **Close the raise loop.**
    - The coach asks again every 4 weeks until paid.
    - Paying ends working to rule at once.
    - The permanent −3 energy only applies once the rival gym exists. Until then a third refusal gives −2 energy for 8 weeks again.
    - RAISEPROBE1: Pay chosen 40-60% of the time.
12. **A season bar for Coach runs it.** A planning bot beats it by 3+ in 100 over a season, or the table becomes a four-weekly decision.
13. **The head coach's factor.** Take John's sizing: 0.6 + 0.004 × rating, which gives 0.84 in the background area and 0.78 elsewhere. A no-assistant club stays at 0.6 on unassigned sessions, so the first hire matters.
14. **Small fixes:**
    - The second club coach costs $280 a week; drop "+$280".
    - Use member target −5 while assigned.
    - Cutman: halves post-bout layoffs, pro nights only, no toggle on amateur bouts.
    - Classes in kg.
    - "For the fight week", not "for camp".
    - No "She".
    - Cut View contract and Lock All.
    - Add Let go (a week's pay).
    - "Notifications" becomes the Needs pin.
15. **Not built yet:**
    - The Staff app (OFFICE2).
    - Per-area morning coaches.
    - The asks mechanic for coaches (after AMATEURWEEK1).
    - STEPMASTERY1.
    - The rival gym's offer.

## 7. The 10/10 Staff app at 1920×1080

**Frame:** the shell (dark top bar, left rail), with a full-screen office desktop window in Look B: a whiteboard, marker and magnets. The only names on screen are in each coach card's header.

**Window bar (64 px):**
- "Staff, week n".
- Energy for the club: "used 26 of 30, next week 28".
- Sessions unassigned this week.
- Next fight week.
- Copy last week and Coach runs it.
- One pulsing button: Confirm the week.

**Left, coaches (460 px):** one stacked card each. The head coach is on top (4 pips after the office, background area, no wage). Each card has:
- Comic portrait with the name in the header.
- Temper word and the A / B mode toggle, with this week's effect in one line.
- Energy pips ("9 of 11", red past the line, "tired: 9 next week" in amber).
- Area bars with "teaches Accuracy up to 70" and "64 to 65 in 8 sessions".
- School chips, wage, a raise flag (Pay / Say no, each with its cost), and Let go.

**Centre, who runs what (980 px):** fighter rows (portrait, class in kg, record) by six columns: Pads, Sparring, Film, Conditioning, Strength, Bag.
- **Each cell:** a coach magnet, the fit word and bar, the week's points for that area, bond pips (hollow when apart), one tag (FRICTION, TAUGHT OUT IN 3 WKS, OVER BUDGET), and a lock.
- **Pad cells:** a shared night shows "2 of 2" sharing.
- **Under each row:** the soonest taught-out and the bond step by the next bout.
- **Swapping:** drag a magnet to swap. The ghost shows the new fit, energy, bond, and This week only / For good.

**Right, what this week builds (480 px):**
- Each fighter's focus gain against Coach runs it.
- Each coach's growth ticks and energy left.
- Bonds crossing a step.
- Risks in red: over budget, a quarrel chance, taught out inside 2 weeks.

**Bottom-left, fight week strip (only with a bout within 14 days; the one gold frame):**
- Corner candidates by portrait and role.
- "About 2 of 3 calls heard a round", "+n in 100", and the energy each gives up.
- On pro nights, the cutman card beside them.

**Bottom-right, market (480 × 200 px):**
- Filters for area, temper, teaches-up-to and wage.
- Three cards, each with Hire (greyed with its reason).

There's no fit total and no best-table badge. Hovering any number shows its parts. Green is used only for Continue.

**CHECKs:**
- CHECK (Claude): CoachAreas' morning factor and the "no coach" case; how PadWeek splits a shared night.
- CHECK (John): amateur corner seconds, and whether the head coach may stand behind an assistant.


# CRITIC ANSWER: DESIGN_COACHFIT1_V4_CRITIC_MARIA_MARIA.md

# DESIGN_COACHFIT1_V4_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ82)

Brief: research/DESIGN_COACHFIT1_V4_CRITIC_MARIA.md
Sent: 2026-11-13 22:10 | collected: 2026-11-13 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give COACHFIT1 v4 **DEPTH 6, GENERAL DESIGN 4, PLAY 5**, so it doesn't reach the owner's bar. General design fails because the map is cut off and contradicts itself in several places. Three times it says a critic's point is answered when the numbers show it isn't.

## Scores

**1. DEPTH: 6/10**
The weekly triage is real. One assistant can't cover four boxers, so some sessions go uncoached or the coach goes over budget, and over budget is a trade between this week and next. Taught-out is now measured on the fighter's own scale, so the warning means something. Removing "best swap" and adding the row footer (weeks until taught out, bond step by the next bout) gives a planning player an edge over Coach runs it. Paying or refusing a raise is now a real choice.

What keeps it at 6:
- **TOP FIT is only reachable late in a season.** The fit table allows temper and mode from −14 to +12. But the temper table never gives more than +6 (Motivator) or less than −8. So the best real pair is 50 + 6 (temper) + 12 (Corner bond) + 10 (weakest stat) = 78. With Trusted bond it's 50 + 4 + 6 + 10 = 70 at most, which is GOOD. TOP FIT shows only for Corner pairs, about 20 to 28 weeks in by the map's own timing. The probe target of TOP FIT on 20% of rows can't be met.
- **Bond isn't scarce.** It still builds +1 from every coached session, so one pads coach with four fighters at 3 sessions each brings all four to Trusted at the same pace. The probe target of 1 or 2 Trusted pairs per coach fails by design. Kalli's fix (bond only from pads, sparring and corner nights) wasn't taken.
- **Three of the four tempers give the auto pick an obvious answer.** Drill sergeant EASE is just "PUSH off". Steady hand is TAPER inside 14 days and PREPARE otherwise. Technician depends on the fighter's moves. John's fix (a mode that pays on a fact the auto pick doesn't weigh) was skipped, and the map gives no reason.
- **Shared pad nights may stop energy from ever running short.** If one pad night costs the coach 1 energy however many fighters are on it, then 3 pad nights for the whole gym cost 3, and one assistant almost never runs out. If not, four boxers need 24 to 30 energy against 15 (head coach plus one assistant), and someone is always short. The map needs a cap on fighters per session (for example 2) to put the decision in between.

**2. GENERAL DESIGN: 4/10**
- **The map is unfinished.** It stops in the middle of the build order (step 2 ends with "**"). The not-built list and the open questions are missing. The text also still carries the chat app's screen clutter (sidebar, "Chat / Create Videos / Homework"). It can't go to a builder like this.
- **Two morning rules contradict each other.** Section 3.1 says an uncoached morning trains at 0.80 × the head coach's factor. Section 7 says an unassigned session trains at 0.60. Neither one is today's game: the pack gives every morning the assistant's coach factor (0.91 with Luke Reid, 1.02 with Marcus Hale). 0.80 × 0.92 is about 0.74, so the cut Kalli and John flagged is still there. The map's "no silent 0.6 nerf" claim is false.
- **The tiredness formula changes today's balance.** 1.15 − fit ÷ 200 gives 0.90 at the neutral fit of 50, not 1.00. Every ordinary pair gets 10% less tired than today, and a fit of 90 gives ×0.70, beyond the agreed ×0.85. The gain formula also can't reach its own bottom: at the clamped minimum of 10 it gives ×0.84, not the ×0.80 the RISKY row prints.
- **Bond values are in the map twice, with different numbers.** Section 2.1 says −8 / 0 / +6 / +12. Section 6.1 says ±0 / +6 / +10 / +12.
- **The probe numbers don't add up.** 0.45 to 0.65 points a week over 26 weeks is 11.7 to 16.9 points, not the 3.5 to 5.0 the map writes. The weekly target also can't be reached. A fully focused week adds about 0.9 points (pack 4.1), and ×1.16 against ×0.84 is a gap of about 0.29. The bar was lowered from 0.5 to 0.45 and is still out of reach.
- **New silent cuts.** Moves outside a coach's school now learn at ×0.75, so most pad work runs below today's rate. v3 cut only Signature work outside the school. The second club coach is listed as "+$280/week", but that's a cost, not income.
- **Invented or wrong game facts:**
  - The cutman "reduces cut severity by 40%". The pack's cutman halves post-bout layoffs.
  - "Heavy combinations", "Step-back" and "Tight defence" appear as school moves. None is a move in the game, and step arrows have no mastery yet (S448).
  - "Win edge +2.8%" and "cost ~2.7 in 100" are printed as facts before the bond probe exists. Mark them EXAMPLE.
- **Breaks the owner's rules:**
  - "She works best with the pads coach" is a fixed pronoun, against the sandbox rule (S412).
  - "Seeking other work" and "leaves at next month-end if rival offer system is built" put the rival gym's offer on screen. v3 had agreed nothing would mention it until it's built.
  - The header aims at "Depth ≥7, Play ≥7", but the owner's bar is DEPTH and GENERAL DESIGN 6+.
- **Smaller contradictions:**
  - The table has a separate Film column, but section 3.2 puts film under the pads area.
  - "Whole numbers, not hundredths" sits next to "+0.4 Strength".
  - The head coach in the corner is "100% what you say", which breaks the map's own heard-calls formula (coachability and morale still apply).
  - Paying a raise "narrows the ceiling upward by +2", and nobody can say what that means.
  - The menu table dropped the learning-slot cards (SLOTS1) that v3 listed.

**3. PLAY: 5/10**
Reasons to come back: a "taught out in ~4 weeks" countdown, a raise that gets harsher each time you refuse, the corner pick in a fight week, and a fighter asking for a coach. Against that, it's 24 cells and up to four mode toggles every Monday, gains in tenths, and the headline word TOP FIT almost never appears. The third refusal ("−3 energy permanently") is punishment with no way out. That's a dead end, not a story.

## Options: missing, useless, and what each changes

**Missing**
- A cap on fighters per pad night, which decides whether energy ever runs short.
- One morning rule, matching today's numbers.
- A way to repair a refused raise (pay late, after the "Seeking other work" flag), so the third refusal isn't permanent.
- A mode the auto pick can't follow.
- The not-built list, the open questions and the rest of the build order.
- What "−15 for 3 weeks" after a For Good swap is counted in: bond points or fit.

**Useless as written**
- **TOP FIT** before Corner bond: it can't appear.
- **Drill sergeant EASE**: it only switches PUSH off.
- **"Seeking other work"**: it points at a system that doesn't exist.
- **The cutman toggle with "−40% severity"**: the number isn't the game's.
- **The separate Film column**: it contradicts film being part of pads.

**What each option changes**
- **Swap, This week only:** the bond pauses, and the fit is −2 that week.
- **Swap, For good:** the bond carries over, with a 3-week penalty whose unit isn't given.
- **Lock:** Coach runs it skips that cell.
- **Copy last week:** repeats last week's assignments.
- **Coach runs it:** fills this week's best table without looking ahead.
- **Mode toggle:** changes the effect of every session that coach runs that week.
- **Pay:** +$50 a week for good, plus an unclear ceiling gain.
- **Say no:** −1 energy for 4 weeks and −3 bond with every fighter that coach trains. A second refusal makes it −2 for 8 weeks and −6.
- **Hear the ask:** +5 mood and the area moves to that coach. **Overrule:** −5 mood.
- **Corner pick:** changes how many shouts land, and the head coach working the corner costs 3 of their 5 energy.
- **Hire:** adds a coach card and their energy.

## To reach 10/10

1. **Finish the map and clean it.** Strip the chat app's clutter, complete the build order, and restore the not-built list (the Staff app OFFICE2, coach asks after AMATEURWEEK1, STEPMASTERY1, the rival gym's offer) and the open questions. Retarget the header to DEPTH 6+ and GENERAL DESIGN 6+.
2. **One morning rule, equal to today.** An unassigned Light or Normal morning keeps the best staff coach's factor in that area, which is today's number. Assigning a coach adds the fit on top and costs 0.5 energy. The 0.60 applies only with no assistant at all. Delete the 0.80 rule.
3. **Make neutral fit mean "today".** Gain is 0.80 + 0.004 × fit, so ×1.00 at 50, ×0.84 at 10 and ×1.16 at 90. Tiredness is 1.15 − 0.003 × fit, so 1.00 at 50 and 0.88 at 90. Print the word table from those formulas.
4. **Give tempers the range the fit table promises.** Each temper's best case is +12 (right mode and right fighter state) and its worst is −14 (wrong mode on a Flat or Low fighter). Then a Trusted pair in the right mode reaches 50 + 12 + 6 + 10 = 78, so TOP FIT shows by mid-season, not only at Corner bond. Keep one bond table: −8 / 0 / +6 / +12.
5. **Cap a pad night at 2 fighters** (1 energy per night, counted once for growth). This puts four boxers at about 18 to 22 energy against 15 or 26, so the triage exists with one assistant and eases with two.
6. **Make bond scarce.** Bond grows only from pads, sparring and corner nights. Thresholds go to 0 / 10 / 50 / 110. A loss together gives +6, the same as a win, not +10. Probe target: at most 2 Trusted pairs per coach by week 26.
7. **Fix the probe targets so they add up.** TOP FIT against RISKY is worth 0.25 to 0.35 points a week on a fully coached focus area, so 6.5 to 9 points over 26 weeks. TOP FIT shows on 20%+ of rows from week 12 onward. A season-planning bot beats Coach runs it by 3+ wins in 100. If it can't, the table becomes a monthly decision.
8. **Restore school learning outside the school** to ×1.0 for every move, with ×0.5 only on Signature work (v3's rule), and in-school ×1.1. Remove the non-moves from school lists. Step and defence answers join only when STEPMASTERY1 gives them mastery.
9. **Give each temper a mode the auto pick can't read.** Drill sergeant EASE: after a quarrel this week, bond losses are halved and the coach-swap price is waived. Technician TEACH: +2 mastery on a move one pad night from crossing a tier. Steady hand PREPARE: a second Hard morning costs no extra energy. Each pays on a fact the player sees and the auto pick doesn't weigh.
10. **Give raises a way out.** A refused coach can be paid late at any time, which clears the energy penalty after 2 weeks. The third refusal leaves the coach on −2 energy until paid, not permanently. Nothing on screen mentions leaving until the rival gym's offer is built.
11. **Use only the game's numbers.** The cutman is "$150 a pro night, half the post-bout layoffs". Every win swing is marked EXAMPLE until the bond probe measures it. Corner calls are shown per round ("about 2 of 3"). The head coach in the corner uses the same formula, with bond at Corner.
12. **Words and rules.** Replace "She works best..." with "Works best with the pads coach". Fold Film into the pads column. Express Pay's gain as "teaches up to +2". Express the For Good penalty as "−15 bond points for 3 weeks". Restore the SLOTS1 line in the menu table. Show the second club coach as a cost of $280 a week.

These need things the game can't do yet: the office Staff app, per-area coaches on mornings, coach asks, step mastery, and the rival gym's offer.

**My 10/10: the Staff app, 1920×1080, whiteboard style under the dark top bar**
- **Header strip (90 px):** "Staff" and the week, with the only names on the page being on the coach cards. It shows energy used against what's available this week and next ("21 of 26, next week 24"), sessions running alone, and the next fight date circled. Buttons: Copy last week, Coach runs it, and the one pulsing Confirm the week.
- **Left column (460 px), the coaches:** one card each, with the name in the card header and a comic portrait. Each card has:
  - energy pips with a red line past the budget
  - "teaches Accuracy up to 70" with growth ("64 → 65 in 6 sessions")
  - the temper word and a mode toggle, with this week's effect in one line
  - school chips and the wage
  - any raise as a sticky note (Pay / Say no, each with its price)
  - the head coach's card on top: 5 pips, office −1, no wage
- **Centre (1000 px), who runs what:** fighter rows (portrait, class and record) by five area columns.
  - Each cell has a coach magnet, a fit word with a bar, the week's gain in that area ("+0.9 Stamina this week"), bond pips with an "apart" state, and one chip: TAUGHT OUT IN 3 WKS, FRICTION, ALONE or OVER BUDGET.
  - Under each row: the soonest taught-out week and the bond step by the next bout.
  - Clicking a cell opens the swap card with This week only and For good, each with its price.
- **Right column (460 px), what this week costs and builds:**
  - each fighter's focus gain against what Coach runs it would give
  - each coach's growth this week and energy left
  - bonds crossing a step
  - risks marked in red with a symbol: over budget, a 1-in-6 quarrel, taught out within 2 weeks
- **Fight-week strip (bottom left, 200 px, gold frame), only when a bout is within 14 days:** corner candidates by portrait and role, calls heard per round, the win swing marked EXAMPLE until measured, and the energy each gives up. On pro nights the cutman sits beside them as a staff job.
- **Market (bottom right, 200 px):** filters for area, temper, "teaches up to" and wage, and three cards with Hire, greyed with the reason when cash or roster places block it.
