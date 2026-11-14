# COACHFIT1_V6 - write the NEXT version of this mechanic's design map (S459 design loop)

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

COACHFIT1_V5 — Coaches Who Fit, Fill Up, Grow, Have a Temper and Bond
Design Map — S459 | Version 5.0 | 2026-11-14
Target: Depth ≥6/10, General Design ≥6/10, Play ≥6/10 | All estimates marked [ESTIMATE]
Sources: COACHFIT1_V4, Kalli S459, Maria S459, FightCamp Critic Pack S403, S448, S451
CONTENTS
Core Idea
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
1. CORE IDEA
Each week you assign which coach runs which training area for each fighter. Every row shows the weekly total gain per area in whole stat points, not per session. Fit is per unique coach–fighter pair — it changes week to week with energy load, bond, temper mode, growth progress and calendar. Over-budget energy trades this week's performance for next week's recovery. Taught-out warnings appear weeks in advance. Bonds build slowly from coached sessions and corner time, and matter most when your fighter needs someone in their corner.
2. FIT: FORMULA, RANGE & VISIBILITY
2.1 — Base & Formula
Base fit: 50 (neutral reference point = today's baseline performance)
Fit range: 10–90, clamped.
Table
Component	Range	Notes
Temper + Mode	−14 to +12	Read weekly from mode toggle + fighter mood/discipline
Energy Load	0 / −8 / −18	0 = within budget; −8 = 1 over; −18 = 2+ over [ESTIMATE]
Bond Step	−8 / 0 / +6 / +12	Stranger / Working / Trusted / Corner — single table, authoritative
Taught-Out Gradient	0 / −4 / −8 / −12	Fighter stat within 10 / 6 / 3 of coach's teaches-up-to value
Weakest Stat Match	0 / +10	Session targets the fighter's lowest stat in that area
Final Fit = 50 + Σ(components), clamped 10–90
Gain Multiplier = 0.80 + (fit ÷ 250) → ×0.84 at 10, ×1.00 at 50, ×1.16 at 90
Tiredness Multiplier = 1.15 − (0.003 × fit) → ×1.12 at 10, ×1.00 at 50, ×0.88 at 90 — neutral fit = neutral tiredness
2.2 — Fit Tiers & Visibility
Table
Word	Fit Range	Gain Multiplier	Appears When
TOP FIT	75–90	×1.10–1.16	Corner bond + optimal mode + matched stat + on budget
GOOD	55–74	×1.02–1.09	Strong bond + good mode
MIXED	35–54	×0.94–1.01	Working bond or minor mismatch
RISKY	10–34	×0.84–0.93	Stranger + poor mode + over budget + taught-out
Display: Each area cell shows +0.9 Accuracy this week — GOOD (weekly total per area, whole or half points). Hover expands to list all fit components with their point values.
FITPROBE1 Target: TOP FIT vs RISKY on a focused area = 0.25–0.35 points/week; 6.5–9.0 points over 26 weeks; TOP FIT visible on ≥20% of rows from week 12 onward [ESTIMATE].
✅ Answers Kalli #1–5, Maria #1–4, John #1: Single bond table; neutral fit = ×1.00 tiredness; achievable targets; clear visibility.
3. COACHED SESSIONS, ENERGY & MORNING RULES
3.1 — Session Types & Coaching
One authoritative morning rule:
Evenings (Pads / Sparring / Film): Always coached. Energy cost: 1.0 / 1.5 / 1.0
Hard Mornings: Coached if assigned. Energy cost: 1.5
Normal / Light Mornings: NOT coached. Run at today's baseline factor (best available coach in that area, or 0.60 with no assistant). Assigning a coach is optional: adds fit bonus + costs 0.5 energy.
✅ Answers Kalli #6, Maria #2, John #2: One consistent rule; today's baseline intact; no hidden nerf.
3.2 — Shared Pad Nights
Max 2 fighters per pad night. 3+ fighters = 2 pad nights scheduled.
1 energy total per night, NOT per fighter. PadWeek's 240 units split evenly across fighters on that night.
Growth counts for every fighter on the night.
✅ Answers Kalli #10, Maria #5: Cap prevents infinite sharing; energy limit stays meaningful.
3.3 — Coach Energy Budget [ESTIMATE]
Table
Coach Type	Weekly Budget	Corner Cost	Notes
Assistant Coach	11	3	8 sessions + corner = full; +2 energy if primary area ≥80 rating
Head Coach (Player)	4	3	1 consumed by office duties; 4 sessions available
2nd Club Coach	5	0	Runs fitness classes (+40 members, $280/week — this is their wage). Assign to conditioning morning = −5 member growth target that week
Film session: counts as Pads area, 1.0 energy
Over Budget: deficit reduces next week's budget by that amount ("Next week: 9/11")
Warning appears on Desktop 3 days before week lock
✅ Answers Kalli #4, #12, Maria #5, John #3: Balanced energy; shared sessions priced; second coach clarified.
4. GROWTH, CEILINGS & RAISES
4.1 — Ceilings (Fixed Scale)
Teaches up to = 40 + (coach_rating × 0.4) — same scale as fighter stats
Pads coach (74) → teaches Accuracy up to 70
Conditioning coach (90) → teaches Stamina up to 76
Display: "Teaches Accuracy up to 70 | 64 → 65 in 8 sessions"
Taught-out warning: appears when fighter stat ≥ teaches_up_to − 10 → "Taught out in ~5 weeks"
✅ Answers John #2: Like-for-like comparison; warning means something.
4.2 — Growth
+1 area rating per 15 coached sessions (slower, sustainable pace)
School mastery bonus: moves in coach's school = ×1.10 learning speed
Outside school: ×1.00 (no penalty — restored to today's rate). Signature moves only: ×0.5 outside school.
✅ Answers Kalli #21, Maria #8: No general slowdown; only Signature work outside school is slower.
4.3 — Raises & Compensation
Trigger: every 5 rating points gained → Monday review shows request
Cost: +$50/week permanent
PAY: Cost applies; teaches-up-to value increases by +2 ("teaches Accuracy up to 72")
SAY NO: −1 energy for 4 weeks; −3 bond with all fighters on their list
2nd NO within 12 weeks: −2 energy for 8 weeks; −6 bond; coach flags "Seeking other work" — screen text hidden until rival gym system built
3rd NO: −2 energy for 8 weeks (repeats); Pay now clears all penalties immediately
Coach asks again every 4 weeks until resolved
✅ Answers Kalli #13, #15, Maria #10, John #5: Closeable loop; permanent penalty removed; repeat ask defined.
5. TEMPERS & WEEKLY MODES
No flat percentage bonuses. Each mode changes a specific, visible mechanic. Low mood = under 30; Flat = 30–49 (matches pack).
Table
Temper	Mode A (Default)	Mode B	Fit / Effect
Motivator	🟢 LIFT: Loss mood hit −12 → −8; +3 mood/week for Flat/Low fighters	🟡 SHIELD: Twist cards with mood cost cost −2 less this week	+6 with Low mood fighter; no flat % anywhere
Drill Sergeant	🟢 PUSH: Sparring = ×1.25 mastery; +3 fatigue; FRICTION risk with Flat/Low	🟡 EASE: Normal fatigue; no friction risk; after quarrel: bond losses halved	−8 with Low mood in PUSH; +4 with Discipline ≥70
Technician	🟢 POLISH: Usable+ moves learn ×1.15; Sharp unlock at 80 rating	🟡 TEACH: New/Raw moves learn ×1.10; +2 mastery on any move 1 session from tier	+4 with Coachability ≥70; Sharp unlock above Luke's 74
Steady Hand	🟢 TAPER: Bout <14d away → tiredness ×0.85	🟡 PREPARE: Fighter's load ratio limit 1.5 → 1.7 when this coach runs Hard sessions	+4 when bout <14d; no flat % anywhere
FRICTION restored: PUSH + Flat/Low = 1 in 6 chance/week of quarrel (−15 bond, −5 mood). Three options: Switch to EASE / Move area / Keep going.
✅ Answers Kalli #6, #7, #16, #17, #18, Maria #3, John #4: No flat %; quarrel restored; modes have distinct, non-automatable value.
6. BOND & FIGHTER REQUESTS
Per coach–fighter pair; NOT club loyalty.
6.1 — Bond Mechanics
Builds ONLY from: Pads, Sparring, Corner nights (+1 each). Mornings do NOT build bond.
Bonus: +4 after a win together; +4 after a loss survived together (equal value)
Decay: −1 per week with no sessions together ("Apart" shown on bond pips)
Thresholds:
Table
Step	Required	Typical Timeline	Fit Bonus
Stranger	0	Start	−8
Working	10	~2–3 weeks	0
Trusted	45	~10–14 weeks	+6 + fighter requests
Corner	110	~22–28 weeks	+12 + call success bonus
Swap — For Good: Bond carries forward; −15 bond points for 3 weeks on the losing coach's side, NOT the new pair. Does NOT reset to Stranger.
Swap — This Week Only: Bond paused; −2 fit penalty that week only.
Scarcity Target: ≤1–2 Trusted pairs per coach at a time [ESTIMATE].
6.2 — Fighter's Ask
Fires ONLY at Trusted+ AND when preferred coach is NOT already assigned to that area
"Works best with the pads coach — reassign for the fight week?"
HEAR: +5 mood, reassigns for this week only
OVERRULE: −5 mood, keep current assignment
✅ Answers Kalli #7, #10, #11, #23, #24, #25, Maria #6, John #6: Scarcer bond; equal win/loss; meaningful ask; swap penalty clarified.
7. THE HEAD COACH & THE 60% RULE
Head coach factor: 0.6 + (rating × 0.004) → 0.84 in background specialty (60), 0.78 elsewhere (45)
60% rule applies ONLY when NO coach is assigned to a session at all
Head coach energy: 4 available sessions + corner duty; 1 consumed by office
When head coach works corner: same call-success formula applies — morale × coachability × bond (Loyalty value used as bond)
Calls heard cap: MIN(1.10, product), floor 0.5 — applies to everyone, head coach included
Display: "About 2 of 3 calls heard a round" — unit matches pack's 2 instructions/minute rule
Energy cost visible: "Working corner → loses 1 session slot this week" (3 of 4 used)
✅ Answers Kalli #8, #9, Maria #7, John #7: Head coach follows same rules; clear energy cost; correct unit for calls.
8. CORNER ASSIGNMENT & CALL CLARITY
Player always chooses shouts. Assisting coach affects only how many get through, NOT what is said
Call success rate = MIN(1.10, morale_factor × coachability × bond_factor), floor 0.5 — applies to ALL corners
Display on bout card:
Portrait + role only — NO names except in bout header
"Assistant in corner: ~2 of 3 calls heard a round | +X in 100 fights [EXAMPLE — measured by BONDPROBE1]"
Energy cost shown clearly
Cutman: Pro nights only. "$150/pro fight; halves post-bout layoffs." No toggle on amateur bouts — hidden entirely
Head coach in corner: "You in corner: ~2 of 3 calls heard | 3/4 session energy used this week"
✅ Answers Kalli #26, #27, Maria #7, John #7: Correct units; example values; pro-only cutman; names rule followed.
9. COACH SCHOOLS & MASTERY
Each coach has 5–7 moves/combos in their school — listed fully on their card
In school: ×1.10 mastery speed
Outside school: ×1.00 (today's baseline)
Signature moves outside school only: ×0.5 mastery speed
Stack cap: school bonus + mode bonus ≤ ×1.20 total
Head coach schools — only game moves/combos:
Ex-pro: Jab, Cross, Lead Hook, Check Hook, 1-2
Amateur coach: Jab, Cross, Body Hook, 1-2, 1-2-3
Strength coach: Body Hook, Uppercut, 2-3, 1-2-3
Old Hand: Jab, Lead Hook, Check Hook, 1-2, Step-back (when STEPMASTERY1 lands)
Display on move bars: "+10% learning — in pads coach's school"
✅ Answers Kalli #21, #22, Maria #8, John #8: No general penalty; capped bonuses; only valid game content listed.
10. THE WEEKLY DECISION: INTERFACE & WORKFLOW
10.1 — Staff App / Office Desktop (Full Screen, Look B Style)
Dark top bar; whiteboard background; names only in coach card headers.
Table
Zone	What Shows	Actions
Top Bar	Week #, energy used/available, next fight date circled, sessions unassigned this week	Copy Last Week • Coach Runs It • Confirm Week (1 pulsing button) — REMOVED: Lock All, View Contract
Left — Coach Cards	Portrait + role, energy pips ("9 of 11", "tired: 9 next week"), temper + mode toggle, teaches-up-to + growth progress, school chips, wage, raise flag (Pay/Say No), Let go (cost: 1 week's pay)	Toggle mode • Hire • Let go
Centre — Assignment Table	Fighter rows (portrait, class kg, record) × 5 columns: Pads, Sparring, Film (folded into Pads on mobile), Cond., Strength, Bag. Each cell: coach portrait, fit word + bar, weekly total gain (+0.9 Acc), bond pips (hollow = apart), 1 tag (FRICTION/TAUGHT OUT IN N WKS/OVER BUDGET), lock icon	Click → Swap (This Week / For Good) • Lock cell • Drag to reassign
Row Footer	Weeks until taught-out (soonest area), bond step by next bout	—
Right — Preview	Per fighter: focus stat change vs Coach Runs It; per coach: growth ticks, energy left; bonds crossing a step; risks in red	—
Fight Week Strip (bout <14d only)	2 portraits: corner options, calls heard/round, win swing [EXAMPLE], energy cost; cutman visible pro nights only	Select corner • Confirm
Bottom — Market	Filters: Area/Temper/Teaches-up-to/Wage; cards show role, temper, school snippet, wage; Hire button (greyed with reason)	Hire
REMOVED: "Best swap" — auto-schedule shows baseline only; player finds the better fit
Hover over energy over: lists sessions newest-first that pushed it over
"Apart" visible on bond pips when no session together that week
✅ Answers Kalli #28–33, Maria #9, John #9: Clean spec; pronoun/class fixes; finished sections; owner rules quoted; estimates marked.
10.2 — Monday Review
Growth milestone: "Pads coach reaches 70 — teaches Accuracy to 72 now"
Bond crossed step: "Trusted with your lightweight"
Raise request: "$50/week — Pay or Say No? Pay clears penalties immediately."
Fighter ask: "Welterweight — 60kg — works best with the pads coach for the fight week"
Energy warning: "Next week: 12/11 — one session will run unassigned"
11. PROBE SUITE & VALIDATION TARGETS
Table
Probe	What Validates	Pass Target
FITPROBE1	Fit range, visibility & impact	TOP FIT ≥20% rows from week 12; TOP vs RISKY 6.5–9.0/26w; no component >40% of total; ×0.84–1.16 range maintained
BONDPROBE1	Bond scarcity & impact	Stranger→Corner worth +2–4 wins/100 close bouts; ≤1–2 Trusted pairs/coach; thresholds land on schedule
RAISEPROBE1	Raise choice balance	Pay chosen 40–60% across bots; neither dominates long-term; Pay late option used 15–25% of refusals
MODEPROBE1	Mode distinctness & value	Hand-set mode beats auto-pick ≥1 in 4 weeks; each mode has at least one unique use case
BOTSUITE S412	Overall balance	No bot beats loyal by >5%; farm strategy fails long-term; best table changes ≥5×/season per fighter; planning bot beats Coach Runs It by ≥3 wins/100 over 26w OR table shifts to 4-weekly decisions
12. FULL MENU WIRING TABLE
| Menu / Screen | What COACHFIT1 Shows There | Wired

[CLAUDE S463: Dola's v5 answer ends here - the chat cut section 12 (the full menu wiring table) and anything after it. Score sections 1-11 as written; count the missing wiring table against GENERAL DESIGN and list it in your To reach 10/10.]


# CRITIC ANSWER: DESIGN_COACHFIT1_V5_CRITIC_KALLI_KALLI.md

# DESIGN_COACHFIT1_V5_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ99)

Brief: research/DESIGN_COACHFIT1_V5_CRITIC_KALLI.md
Sent: 2026-11-14 04:11 | collected: 2026-11-14 04:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# COACHFIT1 v5: critic score (S459, fresh critic)

Part 1 of 3

**DEPTH 6, GENERAL DESIGN 4, PLAY 5. It is not designed yet: General design is under the bar.**

The idea is strong now. Who runs which area, a coach's energy, a slow bond and a raise you can refuse are real trade-offs that touch training, the corner and money. What sinks it is the build: the numbers contradict the pack in four places, it relies on a coach market and on tempers the game doesn't have, and the menu wiring table was cut off.

## DEPTH 6

**What works:**
- **Energy is a real budget.** Over budget borrows from next week, and the corner costs 3 of 11. Putting the coach in the corner competes with training, which is right.
- **Bond builds slowly from evenings and the corner only,** and it decays when a pair works apart. A swap "This week only" against "For good" is a real choice.
- **A raise is a closeable loop,** and Pay restores the teaches-up-to ceiling, so Say No has a price you can see.
- **Each mode changes one mechanic,** not a flat percentage. Drill sergeant PUSH against a Flat or Low fighter carries quarrel risk, so the mode depends on the fighter's state.

**What holds it at 6:**
- **Weakest stat match +10 always wins.** It's the biggest single part of fit, and nothing ever makes it wrong. Every row will chase the lowest stat, which takes away the player's focus choice.
- **Early on there's nothing to decide.** The club starts with one assistant and the head coach. Two coaches and one fighter make a 2-way choice per area, and the table only gets interesting with 3+ staff and 3+ fighters, which comes late.
- **The fit spread is small.** The multiplier runs ×0.84 to ×1.16, against training's 5 points = 72% wins (pack). FITPROBE1's 6.5–9 points over 26 weeks is meaningful, but the weekly cell shows +0.8 against +0.9, which a player won't feel.
- **Modes are mostly set-and-forget.** Steady hand is TAPER when a bout is close and PREPARE otherwise, so the calendar picks it. Motivator LIFT is right for every Flat fighter. Only Drill sergeant and Technician depend on the fighter's state.

## GENERAL DESIGN 4

**It contradicts the pack:**
1. **The head coach factor.** v5 uses 0.6 + rating × 0.004. The pack has coach factor = 0.5 + rating × 0.7% and no coach at all = 60%. The head coach has no rating in the game; the edge is one of four perks. "0.84 in background specialty (60)" invents a rating.
2. **"Sharp unlock at 80 rating" (Technician POLISH).** This puts a coach-rating gate on a tier the pack sets at 60 mastery for every move. It would lock Sharp for every club with a pads coach under 80.
3. **Calls heard.** The pack says "only two instructions per minute get through fully", and morale trust is 1.05 / 1.0 / 0.85 / 0.7. v5 multiplies morale × coachability × bond factor, capped at 1.10 with a floor of 0.5:
   - Coachability is a 0–100 value.
   - The bond factor has no number.
   - A "success rate" of 1.10 isn't a rate.
   - "About 2 of 3 calls heard a round" mixes the minute unit with the round (a round has six exchanges).
4. **The fighter's ask text** reads "Welterweight — 60kg". 60 kg is lightweight, and there's no amateur welterweight class in the code.

**It isn't buildable from what the game has:**
- **No market.** The game has two hire cards and staff jobs. The Market row (filters by area, temper, ceiling, wage) needs coach generation that doesn't exist, and the map doesn't list it as a system to build.
- **No tempers or schools.** Neither assistant has a temper, a school or per-area ratings beyond pads and conditioning. v5 doesn't say what temper each existing coach gets.
- **Coach Runs It** is AGREED, NOT BUILT. It sits in the top bar as if it were built.
- **"Film (folded into Pads on mobile)".** This is a PC game, and the owner ruled out mobile.

**It contradicts itself:**
- Over budget is allowed and borrowed from next week (3.3), but the Monday line says "12/11, one session will run unassigned" (10.2).
- A swap "For good" puts −15 bond on the losing coach's side. That pair no longer trains together, so the penalty bites nothing, and it decays anyway.
- **Columns don't match sessions.** The table has Pads, Sparring, Film, Cond., Strength and Bag. The game's mornings are roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow and neck work, and the stats are the 14 Attrs. There's no mapping from session to column to stat.
- The energy table names three coach kinds but leaves out the S&C staff job ($100) and the physio, and doesn't say whether they take sessions.
- Raises have no ceiling. +1 rating every 15 sessions with ~9 sessions a week gives a raise about every 8 weeks, which is +$300 a week after a year (ESTIMATE from the map's own numbers). Ratings also climb past 90 with nothing to stop them.
- **Double ceiling.** Teaches-up-to (40 + rating × 0.4) sits on top of the fighter's potential headroom clamp. The map doesn't say which binds first.

**Names and words:**
- **S448 breach:** "Sharp unlock above Luke's 74" is a name outside a header.
- The emoji (🟢🟡) and "Mode A / Mode B" aren't game words.
- Every section ends "✅ Answers Kalli #…", and none of it can be checked here.

**The menu wiring table (S425) is missing,** cut at section 12. This counts against the score.

## PLAY 5

- **Good:** Monday lines like "Trusted with your lightweight" and "Pads coach reaches 70" are rewards a player feels. A quarrel at 1 in 6 a week is a story beat.
- **Weak:**
  - It's a 5×N grid to fill every week, and the gain per cell is a tenth of a point.
  - The anticipation (a bond to Corner in 22–28 weeks) is too far away for the first season.
  - The fight-night payoff, "+X in 100 fights", is only an example number.

Part 2 of 3

## Logic check (the numbers run)

| Claim | Check | Result |
|---|---|---|
| Neutral fit 50 gives ×1.00 gain and ×1.00 tiredness | 0.80 + 50/250 = 1.00; 1.15 − 0.15 = 1.00 | holds |
| TOP vs RISKY 0.25–0.35 points a week | the gap is ×0.32; a focused week ≈ 1.0 × coach factor (≈1.0 at rating 74) | holds only for the one focused area; the other areas get a fifth of that |
| Corner bond in 22–28 weeks | about 4 bond a week (3 evenings + corner) plus win/loss +4 | 110 / 4 ≈ 27 weeks, so it holds; but a 3-fighter club shares pad nights, two to a night, and bond per pair needs per-fighter counting (not stated) |
| Assistant budget 11 | 3 fighters × (3 pads shared + 1 spar) ≈ 1.5×3 + 1.5×3 = 9, plus corner 3 = 12 | over budget in any week with a bout and 3 fighters, so the "full" line is the normal state |
| Head coach 4 sessions | 1 lost to the office, corner 3 | a bout week leaves 1 session; that should be shown as the price |
| Teaches up to | rating 58 → 63; fighters sit 55–65 | the existing sessional coach is taught out for half the starting roster at once |
| Calls heard | 1.05 × coachability(0–100?) × bond(?) | can't be computed |

## Missing options

1. **Choose the fighter's focus area against the weakest stat.** Today the +10 makes the choice for the player.
2. **A coach's day off or rest week.** Over budget can only be paid back by the next week, with no deliberate rest.
3. **Who covers a sick or away coach.** Fight-week trips and twist cards take coaches away, and the map has no cover rule.
4. **Promote the second club coach to an assistant role,** or train a member up. That would be the cheap way to a third coach in an amateur club, which is common in UK clubs, where volunteer coaches work toward England Boxing coach awards.
5. **Asking the coach which area to take.** Bond at Trusted could let the coach request an area, as the fighter's ask does.
6. **A coach market cadence:** when new coaches appear and how many. Without it the Market is empty.

## Useless or harmful options

- **Copy Last Week.** The coach already repeats the week (pack 4.1), so this duplicates it.
- **Lock cell.** Nothing auto-moves cells except Coach Runs It, which isn't built. Cut it until that exists.
- **Steady hand mode toggle.** The calendar decides it. Make it automatic or give it a real fork.
- **The −15 bond on the coach being swapped out.** It hits a pair that no longer works together.
- **Cutman line.** Pro only, and already a staff job. It's fine as a line, but not as a "corner option".

## What each option changes

| Option | Changes |
|---|---|
| Assign coach to an area cell | that area's weekly gain (fit ×0.84–1.16), tiredness ×0.88–1.12, bond (evenings only), coach energy |
| Assign a coach to a Normal/Light morning | +fit on that morning for 0.5 energy |
| Mode toggle | one mechanic: loss mood hit, twist mood cost, sparring mastery and fatigue, learning by tier, taper tiredness, load limit |
| Swap This week / For good | that week's fit −2 with bond paused / the new pair starts at its own bond, and the old side −15 |
| Corner pick | calls heard, coach energy −3, bond +1 |
| Pay / Say No on a raise | +$50 a week and +2 ceiling / −1 or −2 energy and bond losses for 4–8 weeks |
| Hear / Overrule the fighter's ask | +5 / −5 mood and that week's coach |
| FRICTION answers (Switch to EASE / Move area / Keep going) | quarrel risk against PUSH's ×1.25 sparring mastery |
| Hire / Let go | wage, energy available, schools; one week's pay to let go |
| 2nd club coach on a conditioning morning | +coach on the morning, −5 member growth target that week |

## Menus (what v5 implies; its own table is missing)

| Menu | What should be there | Wired to | v5 says |
|---|---|---|---|
| Office Desktop, Staff app | the full assignment table | Desktop (built), Staff app (AGREED, NOT BUILT) | yes (10.1) |
| Fighter page > Week | which coach runs each session, fit word on the card | WeekPlan, TrainingLoad | not mentioned |
| Fighter page > Playbook move bars | "+10% learning, in the pads coach's school" | Mastery | yes (9) |
| Club > People | coach cards, raise, Let go, hire | Staff | not mentioned (it moves to the Staff app?) |
| Home needs / Monday review | raise, bond step, ask, energy warning, quarrel | Needs, WeekReview | yes (10.2) |
| Fight prep / Fight night corner | who is in the corner, calls heard | FightNight trust | yes (8), units wrong |
| Money | wage changes from raises | GymBills | not mentioned |
| Top bar flags | raise or quarrel waiting | Shell flags | not mentioned |

Part 3 of 3

## To reach 10/10 (most important first)

1. **Write the menu wiring table in full** (S425): every menu above, plus the Week tab and Club > People, with what each shows, what you can press, and the system it's wired to.
2. **Use the pack's coach factor.** Coach factor = 0.5 + rating × 0.7%, and no coach = 60%. Fit multiplies on top of that. Give the head coach no rating: their four edges stay as they are, and in sessions they run at the factor of the best assistant in that area × 0.9 (ESTIMATE), or 60% with none. Delete 0.6 + rating × 0.004.
3. **Fix calls heard to the pack's units.** Two instructions a minute get through fully, and trust is 1.05 / 1.0 / 0.85 / 0.7. The corner coach's bond adds a step: Stranger −0.05, Working 0, Trusted +0.05, Corner +0.10, with the total capped at 1.10 trust. Show "your corner's word taken in: 95%", and drop "2 of 3 a round".
4. **Delete the Sharp gate at rating 80.** Technician POLISH becomes "Usable and Sharp moves learn ×1.15".
5. **Turn Weakest stat match into Focus match.** +10 when the session's area is the fighter's chosen focus (the player picks one per fighter on the Week tab). The weakest stat is only the coach's suggestion.
6. **Give the existing staff their tempers, schools and area ratings in one table.** List both hire cards and the second club coach, using only stats the code has. Pads 74 / rating 58 and conditioning 90 / rating 74 come from the pack; anything else is an ESTIMATE.
7. **Specify the coach market or cut it.** If kept: 1 new coach card every 4 weeks (ESTIMATE), at most 3 shown, rating 45–80 by club reputation, with temper and school rolled from the four lists. List it in the build order as a new system.
8. **Map sessions to columns to stats.** Pads covers Accuracy and Timing; Sparring covers Defence and Inside fighting; Conditioning covers roadwork and intervals for Stamina and Recovery; Strength covers weights and neck work for Strength, Explosiveness and Durability; Bag covers heavy bag, speed bag, slip rope and shadow for Speed and Footwork. Film goes into the Pads column, without the mobile note. CHECK (Claude) against Attrs.
9. **One over-budget rule.** Over is allowed and borrowed. Delete "one session will run unassigned".
10. **Fix the energy budget to the real case.** Show that a 3-fighter bout week costs about 12. Either raise the budget to 13 or make "corner costs 3" the visible trade with a one-line price ("corner this Saturday: two Normal mornings go uncoached").
11. **Put a ceiling on growth and raises.** Area rating caps at 90, raises stop at the cap, and growth slows to +1 per 25 sessions above 80. Show the raise schedule on the card ("next ask at 70").
12. **Say which ceiling binds:** teaches-up-to or the fighter's potential, whichever is lower, with the hover naming which one.
13. **Swap For good:** drop the −15 on the old side. The cost is that the new pair starts at its own bond and the old bond decays at −1 a week.
14. **Missing options:** cover for an away coach (the head coach covers, or 60%); a coach rest week (+3 energy next week); promote the second club coach (wage +$170, takes sessions, the fitness classes stop).
15. **Make Steady hand automatic** (TAPER within 14 days), or replace PREPARE with a real fork.
16. **Cut Copy Last Week and Lock cell** until Coach Runs It is built, and mark Coach Runs It AGREED, NOT BUILT.
17. **Words and names:** fix "Welterweight — 60kg" to "60 kg"; remove "Luke's 74"; drop the emoji and "Mode A/B" (use LIFT / SHIELD and so on); give the ✅ answer lists the critic's text, not numbers.
18. **Run the probes** (FITPROBE1, BONDPROBE1, RAISEPROBE1, MODEPROBE1, BOTSUITE) and print measured numbers in place of "+X in 100 [EXAMPLE]" before build.
19. **Play: give the first season a payoff.** Working arrives in 2–3 weeks, Trusted around week 12, and a quarrel or an ask in the first 8 weeks (ESTIMATE). The Monday line names the stat point the fit won ("Accuracy 63 → 64, a week early: good fit").

## The 10/10 page at 1920×1080 (Office Desktop, Staff app, Look B)

- **Dark top bar (64 px):** week, the next bout circled, "coach energy 9 of 11", and one red **Lock the week**. Green is used only for Continue.
- **Left column (480 px), coach cards on the whiteboard:**
  - A polaroid portrait with the name in the card header only.
  - Role, temper word with a two-pill mode (LIFT / SHIELD).
  - Energy pips with "borrowed 1 from next week".
  - Area ratings with "teaches Accuracy up to 70".
  - Growth tick "next +1 in 6 sessions".
  - School chips (game moves only), wage, a raise sticky when asked (Pay +$50 / Say no, with the price on hover), and Let go (one week's pay).
- **Centre (960 px), the assignment board:**
  - One row per fighter: portrait, class in kg, record and the chosen FOCUS pill.
  - Five columns: Pads, Sparring, Conditioning, Strength, Bag.
  - Each cell holds a coach magnet, a fit word with a bar, "+0.9 Accuracy this week", bond pips (hollow when apart) and one red tag at most (QUARREL RISK, TAUGHT OUT IN 4 WKS, OVER BUDGET).
  - Click: This week / For good.
  - Hover: every fit part with its number and the binding ceiling.
- **Right (480 px), ON MONDAY preview:** each fighter's focus stat now and after the week; bond steps crossing; coach growth; next week's energy; risks in red. One gold frame, the week's best gain, is the only gold.
- **Fight week strip (bottom of centre, 120 px, a bout within 14 days):** two corner magnets, "your corner's word taken in: 95%" from measured numbers, "costs 3 energy: two mornings uncoached", and the cutman line on pro nights only.
- **Bottom (96 px):** the coach market strip, a maximum of 3 cards with Hire (greyed with its reason). Your assistant's note gives one suggestion and never the answer.
- Names appear only in the headers of the cards and polaroids. Rows say your boxer, your assistant and the opponent.


# CRITIC ANSWER: DESIGN_COACHFIT1_V5_CRITIC_MARIA_MARIA.md

# DESIGN_COACHFIT1_V5_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ100)

Brief: research/DESIGN_COACHFIT1_V5_CRITIC_MARIA.md
Sent: 2026-11-14 05:11 | collected: 2026-11-14 05:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give COACHFIT1 v5 **DEPTH 6, GENERAL DESIGN 4, PLAY 5**, so it still doesn't reach the owner's bar. The weekly coach-to-fighter choice now has a real price and a real long-term payoff. General design fails because several numbers contradict the game or each other, a big part of the map is missing, and the coach market it depends on doesn't exist.

## Scores

**1. DEPTH: 6/10**
There are real choices here:
- **Energy.** One coach can't run everything, so you have to decide which fighter gets the best pads coach this week. Going over budget borrows from next week.
- **Bond against fit.** A pair that has worked together for months is worth keeping even when a newer coach teaches the stat better. That matches real boxing: fighters do switch trainers to fix a hole, as Anthony Joshua did when he went from Rob McCracken to Robert Garcia and then Derrick James. Switching gives up years of corner trust.
- **Raises.** Pay, or say no and take an energy and bond hit.
- **Long-term effect.** TOP FIT against RISKY over 26 weeks is worth 6.5 to 9 stat points, and the pack says 5 points of stats wins about 72%. Over a season, the choice changes who wins.

What holds it back:
- **Too small to feel from week to week.** 0.25 to 0.35 points a week is below what the week review shows as a whole-point fill. The player chooses every week but sees the effect only every few months.
- **The pad-night cap rewards sharing.** One energy covers two fighters on the same pad night, so sharing is almost always the right pick. It costs only half the drill units, which the fighter loses anyway when there's one coach.
- **The trade-offs never fight each other.** A Motivator is best with a Low fighter, and a Drill Sergeant is worst with one, so the temper choice follows straight from mood. Each mode is the right pick in an obvious situation.
- **Nothing ties it to the fight plan or the Why.** Coaches change gains and the share of calls heard, but not the plan lines a coach can teach. Today, coach rating sets how many plan lines a fighter gets.

**2. GENERAL DESIGN: 4/10**
v5 gives one morning rule (Normal and Light mornings keep today's factor, so there's no hidden nerf), one bond table, and keeps the cutman pro-only. What fails:
- **The taught-out ceiling hits on day one.** "Teaches up to" is 40 + rating × 0.4, which gives about 70 for the pads coach (74). Amateur lightweights sit at 55 to 65, so most fighters are already within 10 of that ceiling. They'd take the −4 to −12 taught-out penalty from the first week, and the warning would show everywhere. The map never says what happens above the ceiling: is it a hard stop, or just the gradient?
- **The calls-heard unit is wrong.** "About 2 of 3 calls heard a round" doesn't match the game. A round is six 30-second exchanges, and two instructions a minute get through fully, so a round has six shout chances. The formula multiplies coachability, a 0–100 personality value, with no scale given. It also ignores the Ring general perk (+25% corner calls) and the existing trust factors (Fired up 1.05 down to Low 0.7). The map says it reuses them, but the formula doesn't show it.
- **The head coach formula is new and unsourced.** "0.6 + rating × 0.004" isn't the game's coach factor, which is 0.5 + rating × 0.7%, and the head coach (you) has no rating in the game. "Loyalty used as bond" relies on a value the game doesn't show on the board.
- **The temper range doesn't add up.** The table promises −14 to +12, but the listed values are +6, −8, +4 and +4. Nothing reaches −14 or +12.
- **Some effects aren't defined.**
  - "Sharp unlock at 80 rating" and "Sharp unlock above Luke's 74" mean nothing: moves turn Sharp at 60 mastery, not by coach rating.
  - PREPARE "raises the load limit 1.5 → 1.7", but in the game 1.5 is where risk starts rising, not a hard limit.
- **It relies on things the game doesn't have.**
  - The game has two assistants (Luke Reid and Marcus Hale), not a coach market with tempers and schools. "Bottom: Market" needs a coach pool that isn't built.
  - "Coach Runs It" is agreed but not built.
  - "Week lock" isn't a game concept. The clock stops on Mondays.
- **Some changes do nothing.**
  - The swap-for-good penalty lands on "the losing coach's side", but that pair no longer exists.
  - "Seeking other work" is a state the player can't see.
- **Words and rules broken.**
  - "Welterweight, 60 kg" is wrong: 60 kg is lightweight, and welterweight is 65 (women) or 70 (men).
  - "Folded into Pads on mobile": the game isn't on mobile.
  - "Confirm Week (1 pulsing button)" is a continuous pulse.
  - The modes are shown by green and yellow dots, which is state by colour alone.
  - "Mood" sits alongside the game's word "morale"; one word per concept.
- **Section 12 (menu wiring) and everything after it is missing,** so there's no build order, no held-back list and no open questions. No probe has run either; every target is a guess.

**3. PLAY: 5/10**
The best moments:
- A Monday line saying a pair has reached Trusted.
- The fighter asking for the pads coach in fight week.
- A raise asked for with a real cost either way.

These are about people, which fits the "fighters are people" pillar. But the weekly job is a table of fighters × five areas × coaches, with fit words that move by 1 to 4 points. That's a spreadsheet chore, and "Copy last week" will be the usual click. The quarrel (1 in 6 a week under PUSH with a Low fighter) is the only surprise, and it's a punishment.

## Options: missing, useless, and what each changes

**Missing**
- Hiring from a real coach pool: who arrives, when, and how much each costs.
- What a coach changes in the fight plan, such as lines taught.
- What happens to a fighter above the coach's ceiling.
- Corner choice on amateur nights. The energy cost is shown, but is there a reason to pick anyone other than the highest bond?
- The menu wiring, the build order and the held-back list.

**Useless as written**
- **Swap for good's penalty** on a pair that no longer exists.
- **The hidden "Seeking other work" flag.**
- **The Film column** as its own area. It already "counts as Pads".
- **Technician "Sharp unlock"**, because the effect is undefined.

**What each option changes**
- **Assign a coach to a cell:** the fit word, so gains go ×0.84 to ×1.16 and tiredness goes ×1.12 to ×0.88. It costs energy (evenings 1 to 1.5, Hard mornings 1.5, optional Normal mornings 0.5) and builds bond on evenings.
- **Swap this week:** −2 fit that week, and the bond pauses.
- **Swap for good:** the bond carries over, plus a penalty to a pair that no longer exists.
- **The mode toggle:**
  - LIFT or SHIELD: smaller morale losses.
  - PUSH: ×1.25 sparring mastery, +3 fatigue, quarrel risk.
  - EASE: no quarrel, softer bond losses.
  - POLISH or TEACH: faster learning by tier.
  - TAPER: ×0.85 tiredness inside 14 days.
  - PREPARE: a higher load-spike limit.
- **Pay the raise:** +$50 a week and +2 to teaches-up-to.
- **Say no:** −1 or −2 energy and −3 or −6 bond, repeating until paid.
- **Hear or overrule the fighter's ask:** +5 or −5 morale, plus a reassignment for one week.
- **The corner pick:** the share of calls heard, and 3 energy.
- **Let go:** a week's pay.

## To reach 10/10

1. **Fix the ceiling scale.** Make "teaches up to" 55 + rating × 0.35. That gives the pads coach (74) a ceiling of 81, and conditioning (90) 86 (EXAMPLE). The warning starts at 5 below. Above the ceiling, gains run at ×0.5, never a hard stop. Probe: under 15% of rows tagged taught-out in week 1.
2. **Use the game's numbers for calls.** Calls heard = the existing trust factor (morale 0.7 to 1.05) × coachability (0.8 at 0, 1.1 at 100) × bond (Stranger 0.9 up to Corner 1.1), capped at 1.1. Ring general stays ×1.25 on top. Show it as "about 5 of 6 shouts land fully this round".
3. **Give the head coach a rating from the edge chosen at new career.** For example, Ex-pro 60 on pads and 45 elsewhere (EXAMPLE), run through the existing coach formula. Bond starts at Working and builds from sessions together, not from Loyalty.
4. **Make the week's choice big enough to feel.**
   - Widen fit to ×0.75 to ×1.25 (EXAMPLE).
   - Add one visible weekly payoff: a Trusted or Corner pair teaches 1 extra plan line in camp.
   - Probe: TOP against RISKY is worth 10 to 13 points over 26 weeks, and a hand-made table beats Coach Runs It by 3+ wins in 100.
5. **Price shared pad nights.** Two fighters on one night cost 1.5 energy and split 240 units 60/40, with the player choosing who gets 60. Show the cost on the Coach's pad nights row the game already agreed.
6. **Write the coach pool.**
   - 2 candidates show each month, so 6 a season.
   - Each has a temper, a school, a rating per area and a wage band ($450 to $1,300 a week, EXAMPLE).
   - Signing costs $1,000, as today.
   - The day-one choice stays Luke or Marcus.
7. **Rebuild the tempers so no choice follows from mood alone.**
   - Use the full −14 to +12 range.
   - Each mode costs something: LIFT −0.5 energy, PUSH quarrel, POLISH slower Raw moves, TAPER −10% gains.
   - Cut "Sharp unlock".
   - Change PREPARE to "load-spike risk ×2 instead of ×3".
8. **Fix the swap rules.**
   - Swap for good: the new pair starts at half the old pair's bond, capped at Trusted.
   - The old coach loses 1 energy for 2 weeks.
   - Show "Seeking other work" as a Monday line with Pay or Let go, or cut it.
9. **Fix the words and UI.** Write "60 kg lightweight", "morale", and one Confirm week button without a pulse. Show modes as a word and an icon, not colour alone. Remove the mobile note. Replace "week lock" with "Monday".
10. **Finish sections 12 to 15.** Wire it to every screen:
    - Office Staff app.
    - Fighter Week (fit word on each card).
    - Fight prep (the corner pick).
    - The corner minute (calls heard).
    - Week review (growth, bond, raise).
    - Club > People.
    - Then the build order, the held-back list and the open questions.
    - Run FITPROBE1, BONDPROBE1 and the bot suite before v6.

**My 10/10: the Office Staff app's Coaches this week, 1920×1080**
- **Header (100 px):** week and dates, the fight date circled, total coach energy "18 of 22", Copy last week, Coach runs it, and one Confirm week button.
- **Left column (480 px), YOUR COACHES:** one card per coach.
  - The name in the card header only.
  - Portrait, temper, and a mode switch with words.
  - Energy pips.
  - Teaches up to, per area.
  - School chips.
  - Wage, and a raise note with Pay and Say no when one is due.
- **Centre (960 px), WHO RUNS WHAT:** fighter rows × five areas (Pads, Sparring, Strength, Conditioning, Bag). Each cell shows:
  - the coach's face
  - the fit word (Top fit, Good, Mixed, Risky) with an icon
  - the weekly gain ("+1.2 Accuracy")
  - bond pips with the step's word
  - at most one tag (Over budget, Taught out in 5 weeks, Friction risk)
  - hover lists every part of fit, with its points.
- **Right column (480 px), WHAT THIS WEEK BUYS:** for each fighter, the focus stat by fight night compared with Coach runs it, any bond reaching the next step, the plan lines a coach will teach in camp, and risks in words.
- **Fight week strip (only within 14 days of a bout):** two corner choices, each with "about 5 of 6 shouts land fully", energy cost and bond step. The cutman shows on pro nights only.
- **Bottom strip (140 px), COACHES LOOKING FOR WORK:** this month's two candidates with temper, school, ratings, wage and Hire (greyed with the reason).
