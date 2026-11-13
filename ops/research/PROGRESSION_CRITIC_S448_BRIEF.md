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


# YOUR JOB (critic, S448): score one design map, version 1 - PROGRESSION

You are a fresh critic. Above is the whole game (the critic pack) and how to see it. Below is version 1 of the design map for
PROGRESSION: what the player is eager to unlock each week, each season and across a fighter's career (a move tree, picking which move
to learn, footwork learned with a filling bar, the body grading every move, skills awards as the fighter's level, coaches as the
speed and the gates). Nothing of it is built. Judge it as a player of deep management sims (Football Manager, Motorsport Manager,
Boxing Manager) would. You have not seen earlier versions.

1. LOGIC CHECK first: does anything in the map contradict the game in the pack or the code facts it quotes? Name any unlock, button,
   number or row that the game could not act on at that moment.
2. DEPTH, score 1 to 10: is "which move do I learn next" a real decision, week after week, for four fighters? Try to break it: name
   any pick that is always right (a lookup), any node nobody would take, any loop that becomes a chore. Does every unlock change fight
   night (numbers and the 3D), or are some invisible +1s?
3. PLAY, score 1 to 10: would this make you eager to press Continue each week, each season, across a career? Is the amateur arc
   different enough from the professional one? Is there a next thing always in view, with a date?
4. Which options are missing, which are useless, what would each change? Go through the menu table (section 7): right place, would the
   player find it, anything shown that cannot be acted on? Is the coach / staff progression deep enough, or too much?
5. END with "To reach 10/10": the concrete list of changes to the MECHANICS (not the wording), most important first, specific enough to
   build. Then describe your 10/10 tree page as a layout on a 1920x1080 screen, panel by panel.
Plain words. No praise. Score honestly: a 7 means you would defend it to the owner. Do not ask questions back.

---

# PROGRESSION: what the player is eager to unlock, week by week, season by season, across a career (design map v1, S448)

Owner, verbatim: "the player needs something to be eager on unlocking each week that will make his fighter better , so wee need a
proper progression plan , how first amateur weeks and pro weeks run , my thoughts are , in training learn a move (shows up on profile
with the move tree it unlocks and combos) Learn a second move (opens up combos between these moves and so on) use the playbook and try
different combos + movement (fighterns learn the movment here with visible filling graphic) [...] make movement effectiveness assoiated
with body attribute , and do that for other applicable things that apply also on the fight visually and statistiacally . During that it
will take coahces and trainers to raise his attributes and give him xp for learning the moves by reaching thresholds [...] add also coach
progression and other staff buffs maybe". Then: "the loop is not only the week , it is the whole fighter career/progression".

Sources read for this map: CRITIC_PACK (the game), CORE_LOOP_MAP_S432 (the agreed loop, decisions C1-C33), RPG_LAYER_MAP_S432 (coach level,
perk picks, Coach grows), TRAINSCENE_MAP_S439, AMATEURWEEK1_MAP_V2_S429, SCOPE_FOUR_FIGHTERS_S428, BOXING_MANAGER_COMPARE_S425, and the
code on main (files named below). Research on other games: section 2. Tags: CODE = the game does it today (file named). AGREED = in a
map the owner approved, not built. NEW = this map adds it. ESTIMATE = a number this map sets until its probe (section 9) measures it.
Game text never says he, she, him or her.

## 0. The idea in seven lines
1. ONE BAR PER THING. A move's mastery (0-100, CODE) is its experience. A fighter's LEVEL is the skills award (Preliminary to Platinum,
   CODE `SkillAwards.gd`, the real GB Boxing Awards), earned by moves reaching their tiers. No second experience currency.
2. THE MOVE TREE: the 22 things the fight already knows how to do (6 punches, 8 footwork moves, 3 defences, 5 combinations' worth of
   links) put in a coach's teaching order. A move opens the moves after it and the combinations it completes.
3. SCARCE LEARNING: a fighter learns 1 new move at a time (2 with a good pads coach); when the slot frees, the coach offers 3 next
   moves and the player picks 1. That pick is the weekly "what do I unlock next".
4. FOOTWORK IS LEARNED like punches (today every step works at full from day one): a filling bar on the pads, in shadow mornings and
   sparring, and a step under Usable is not done in the fight.
5. THE BODY DECIDES HOW WELL: every move is graded by two attributes (CODE `LineGrade.gd`, written, wired nowhere) and our fighters get
   the height and reach the fight already reads for opponents. The grade changes the fight's numbers AND the 3D (step length, pace).
6. COACHES SET THE SPEED AND THE CEILING: the pads coach's rating speeds every bar and opens the second learning slot and Signature
   work; coaches grow by the sessions they run (AGREED, RPG 11).
7. THREE CLOCKS, NESTED: the WEEK (a bar crosses a line), the SEASON (an award, a style named, rank and the nationals), the CAREER
   (fundamentals as an amateur, a specialty and a Signature as a professional, keeping it as the body declines). The player always
   sees the next thing on each clock and its date.

## 1. What the game has today toward his idea (read in the code)
| His idea | Today | Where |
|---|---|---|
| Learn a move | HAVE: 6 punches with mastery 0-100; tiers New / Learning under 30 / Usable 30 / Sharp 60 / Signature 85; cap 40 + 0.4 Technique + 0.2 Ring IQ (50-100); pads 2.1 an hour, sparring 1.5, double-end 1.2, heavy bag 1.05, speed bag 0.9, shadow 0.85; x(1 + 0.4 x coach / 100) x (1 - m / cap); -0.75 a week undrilled, never back under 30 | `MoveMastery.gd`, `PadWeek.gd`, `state/Data.gd:234` |
| Start state | Jab 0.85 x Technique, Cross 0.75, Lead hook 0.62, Body hook 0.5, Uppercut 0, Check hook 0; "learning" starts on Uppercut | `PunchStart.gd:11`, `Data.gd:251` |
| Move tree | MISSING for boxing. The only gates: a combination waits for all its punches at 30; award grades in a fixed order. BJJ has a real tree (49 positions, 135 links, felt at 15, owned 30) | `Combos.gd:56`, `SkillAwards.gd`, `BjjTree.gd`, `ui/MatTree.gd` |
| Combos opened by moves | HAVE: 10 book combinations + own chains (`own:N`) with their own pad mastery; combo edge +0.12 / 0.20 / 0.30 at 30 / 60 / 85 | `Combos.gd`, `OwnCombos.gd`, `ui/ComboBuilder.gd` |
| Practice bar | HAVE: drill cards on pad nights, projections (day to 30, weeks to 60), news when a combo reaches 30 or 85 | `PadWeek.project`, `ui/DrillCard.gd`, `DrillWeek.gd:143` |
| Movement learned | MISSING: steps have no mastery, "ready the day she can stand", and the fire rule reads them at 100 | `ui/MoveBook.gd:50`, `FireLevel.gd:44-48` |
| Body drives movement | PARTLY: Footwork / Speed / Defence / Strength steer range in the duel (open: footwork .35, speed .3, jab .25, timing .1). Reach 0.25 a cm on the jab, height 0.2 a cm inside, capped 4, but OUR fighters have no height or reach keys, so that edge is 0. The 3D uses height only for the mesh; footwork is fixed constants | `Duels.gd:16-54, 412`, `TaleOfTape.gd:5`, `fight3d/BoxerFootwork.gd` |
| Grade by attributes | WRITTEN, UNUSED: each move's two attributes, Good / OK / Poor at 62 / 50, edge x1.2 / 0.85 / 0.35 | `LineGrade.gd` (no caller) |
| Moves matter in the fight | WEAK: a weapon past the fourth adds +0.3 (cap +0.9); a planned line fires every time once Usable, so Sharp is worth about 1 win in 100 over Usable. The fire rule (Usable 1 in 2, Sharp 3 in 4, Signature always: +2.8 and +2.7 wins in 100) is built and OFF | `BoutRules.gd:443`, `FireLevel.gd` (queue row FIRELEVEL3) |
| Coaches raise attributes | HAVE: weekly gain 1.0 x quality x (0.5 + 0.7 x rating) x headroom clamp((potential - stat) / 25, 0.10, 1.25); no coach 60% | `TrainingPreview.gd`, `CoachAreas.gd` |
| Levels and XP | PARTLY: the six awards, 8 coached sessions each plus moves at tiers; a passed grade's moves cost less energy. No fighter XP; perks open at attribute lines | `SkillAwards.gd`, `PerkRoad.gd` |
| Coach progression, staff buffs | PARTLY: fixed coach areas, four head-coach edges, four staff jobs with one flat effect each; nothing grows. Coach level, either/or picks and "Coach grows" are AGREED (RPG layer 7/7), not built | `Data.gd:31`, `StaffRoles.gd`, `HeadCoach.gd`, RPG 2 and 11 |

## 2. What successful games do, and what that says about us
Research in our words (sources in the S448 research note, `ops/research/PROGRESSION_RESEARCH_S448.md`).
| Game | The mechanism that makes the next week worth waiting for | What we take |
|---|---|---|
| Football Manager | one individual focus per player (three in FM26); a trait (a preferred move that changes what the player DOES) can be taught; coach stars per area drop when one coach covers too much; green and red arrows each month | a TRAIT-LIKE unlock (a move changes what the boxer does), coach quality per area, the workload penalty (one pads coach shared by four) |
| Motorsport Manager | always a part in the factory with a finish date; driver-mechanic chemistry opens perks at levels | the NEXT UNLOCK WITH A DATE on every fighter; a coach-fighter bond (already AGREED: loyalty) |
| Boxing Manager (our benchmark, installed; S425/S426 study) | ring experience spent on single ratings at the trainer's price; potential is one visible pool; training sliders set once and never touched again | its weakness is our opening: quiet weeks ask nothing there. We keep potential as ceilings and add a weekly pick |
| EA UFC 4/5 career | moves unlock at one star and level up by being USED, faster when they land; a guest fighter teaches a move | USE-BASED: a move landed in a bout grows and earns a FIGHT-PROVEN mark |
| Fight Night Champion, Undisputed | training mini-games pay points; training costs stamina so rest competes with work | the price on practice: pad nights are scarce, sparring costs tiredness and risk |
| Skyrim, NBA 2K badges | use raises the skill; tiers (bronze to gold) at visible thresholds; a perk needs a skill line | named tiers we already have (Usable, Sharp, Signature) and prerequisites by line |
| Path of Exile | 1,300 nodes: new players are lost | the warning: about 20 nodes, one screen, no scroll |
| Persona 5 | the week's free time is the scarce thing; ranks open real abilities | the club's pad nights are the scarce thing (AGREED PADPOOL1) |
| Darkest Dungeon | upgrading the trainer raises the top level a hero can reach | the coach's rating opens the second learning slot and Signature work |
| Hades | several bars fill at once, each with a named next reward; unlocks change HOW a run plays more than how strong it is | several bars per fighter, each with its next reward named; a new move changes the plan's options, not just a number |
Principles taken: (1) one bar near its line every week, (2) the unlock changes what the fighter can do, (3) use teaches, (4) named tiers,
(5) a pick of 3 under a cap, (6) staff are the multiplier and grow, (7) show the next unlock and its date, (8) a small readable tree,
(9) a slow permanent clock and a fast one. Failure modes avoided: grind, invisible +1s, many currencies, trees nobody reads, maxed fighters.

WHAT WE ARE MISSING: a choice of what to learn (all six punches are present at signing; the game picks "Uppercut" itself); footwork as
something learned; any next-unlock preview with a date; a level the player can read (the awards exist but sit on the Training tab);
body facts on our own fighters; coach growth. WHAT WE OVERDO: meters. The agreed maps carry loyalty, mood, Known, hype, the Tank,
tiredness, fire share, grade, suit, direction, marks and moments. This map adds NO new meter: it gives order (the tree), a pick, and
wires two built-but-idle modules (LineGrade, FireLevel). WHAT IS WRONG NOW: progress is shown as decimals (+0.4 a week); Sharp and
Signature barely change a bout because the fire rule is off; steps work at full on day one, so footwork can never be a reward;
an unlock arrives as a news line, not as a moment with something new to do.

## 3. The three clocks
| Clock | What fills | What the player is eager for | How often (ESTIMATE, PROGPROBE1 measures) |
|---|---|---|---|
| WEEK | pad nights, shadow mornings and sparring fill move bars; mornings fill attributes | a move crossing a line (Usable = in the fight, Sharp, Signature); a combination opening; the next move to pick | per fighter, a line crossed in 3 weeks of 4; per gym of four, a pick most weeks |
| SEASON | bouts (moves landed teach), awards, the regional ladder, the nationals | the next AWARD (opens a tree row and a pick), a STYLE NAMED (three moves of a style at Sharp), a rank line, the nationals entry | an award every 6 to 10 weeks; a style named in season 1; rank on every bout (S428) |
| CAREER | ceilings, awards, styles, Signatures, the coach's level | the PRO OFFER, the first Signature, a perk, a belt; for the club, a better coach and the second learning slot | the pro offer at 7 wins and top-3 or 9 wins (CODE); a first Signature in the first pro year |
Each lower clock feeds the next: a move's line (week) is a stamp toward an award (season); an award opens the tree row a professional
style needs (career); the coach's growth (career) speeds every bar (week).

## 4. The mechanics, each a decision with its price

### M1. THE MOVE TREE (NEW: data + a pure module on the BjjTree pattern; nodes are actions the fight already plays)
22 nodes in four branches, in the order a club coach teaches (gym coaching practice: shadow, bag, pads, controlled sparring, then a
bout; footwork after the straight punches and the hook). A node opens when the moves under it reach the line named; the tree is one
screen, no scroll.
| Row (opened by) | LEAD HAND | REAR HAND / POWER | FOOTWORK | DEFENCE AND INSIDE |
|---|---|---|---|---|
| 1 Preliminary (signing) | Jab | Cross | Step in, Step out | Guard (always, not a node) |
| 2 Standard award | Lead hook (Jab 30) | 1-2 and 1-1-2 links (Jab, Cross 30) | Step back (Step out 30) | Slip (Jab 30) |
| 3 Bronze award | Body hook (Lead hook 30) | Uppercut (Cross 30 + Step in 30) | Pivot (Step back 30); Cut off (Step in 60) | Roll (Slip 30); Tie up (Body hook 30) |
| 4 Silver award | Check hook (Lead hook 60 + Pivot 30) | 1-6-3 link (Uppercut 30) | Herd (Cut off 30) | Push off (Tie up 30) |
| 5 Gold award, PROFESSIONALS | Feint (Jab 60) | own chains of 4+ (any 3 at 60) | in-and-out rhythm = Step in + Step out both 60 (a combined node) | slip 2-3 counter link (Slip 60 + Cross 60) |
- Nodes are the 6 punches (`Data.gd:234`), the 8 steps and 2 defences of `StrikeMap.gd` plus Slip (`ComboFlow` move types), and the
  book's links. NO new animation is needed for any node; every node already has a fight hook and a clip or a step.
- A node shows: its bar (0-100) with ticks at 30 / 60 / 85, its grade (M4), what it OPENS (moves below it, combinations it completes,
  plan answers it gives: "Pivot: answers 'when she presses' at mid range"), and, locked, the line it waits for.
- A row waits for its award (M3): the award is the "level" that widens the tree. A professional (Gold) row stays closed to amateurs:
  the pro offer is also a tree unlock.
- Real basis: GB Boxing Awards test exactly these in this order (`SkillAwards.AWARDS` "tests"); a check hook needs the hook and the
  pivot first.

### M2. ONE MOVE IN LEARNING, THE PICK OF THREE (NEW; replaces Data's fixed "learning: Uppercut")
- A fighter has LEARNING SLOTS: 1 (2 when the club's pads coach is rated 65 or more, M6). A move in a slot is the only move under 30
  that pad nights can carry; moves at 30+ can always be drilled toward Sharp and Signature.
- When a slot frees (its move reaches 30), the Monday review and the Home need "A MOVE TO PICK" (steel: does not stop the clock) show
  the COACH'S THREE: open nodes ranked by (a) what the booked or next likely opponent tests (TR T18, CODE `OppFile`), (b) the build
  direction (AGREED RPG 12), (c) the body's grade on it (M4). Each card prints: the weeks to Usable on this week's pad nights (from
  `PadWeek.project`), what it opens, and its worth on the next bout ("+0 on Sat 28, Usable for the next one") in the one-number unit
  of TRAINSCENE D1. Pick one; an unpicked slot takes the coach's first card on Monday's Start week.
- THE PRICE: a slot is the cost. Taking the Uppercut means the Pivot waits 2 to 3 more weeks, and every card says what waits.
  Swapping a move out of the slot keeps its mastery but restarts nothing (it simply stops growing).
- Signing: a new fighter arrives knowing row 1 (Jab, Cross, Step in, Step out from Technique / Footwork x the start shares, CODE
  `PunchStart`) plus their SIGNATURE MOVE (CODE `Recruit`) and anything the signing card shows; the rest is open or locked.
- Real basis: a coach brings in one new thing at a time and drills it to habit before the next (FM's one focus; Motorsport Manager's
  one part in the factory).

### M3. THE AWARD IS THE LEVEL; STAMPS ARE ITS EXPERIENCE (CODE awards + NEW stamps read from the bars)
- The owner's "xp for learning the moves by reaching thresholds": every line a move crosses is a STAMP: Usable 1, Sharp 2, Signature 3;
  a move landed 3+ times in a won bout once (FIGHT-PROVEN mark) 1. Stamps are COUNTED from the bars, never spent: no second currency.
- An AWARD needs its moves at the lines `SkillAwards.AWARDS` names (CODE) AND its stamp total (ESTIMATE: Standard 3, Bronze 8, Silver
  14, Gold 22, Platinum 30 and a skills bout) AND 8 coached sessions (CODE `SESSIONS`). Passing it: the next tree row opens, a
  passed grade's moves cost less energy in the bout (CODE `SkillAwards.economy_ids`), the fighter's mood +5 (CODE morale), the club's
  reputation +1 (NEW, ESTIMATE), and the coach who ran most of the sessions gets experience (AGREED RPG 2).
- Shown: an award chip on the Profile header, the Fighters row and the bout card ("Bronze 11 of 14 stamps; next: Body hook Usable,
  2 pad nights"). The chip is the fighter's level everywhere.
- Professionals keep the award at Gold or Platinum; their level from then on is the Signature count and the perk picks (career clock).

### M4. THE BODY DECIDES HOW WELL (wire `LineGrade.gd`; NEW body facts; NEW 3D reads)
- Every node has its two attributes (CODE `LineGrade.DONE_WITH`; punches added: Jab accuracy + reach, Cross strength + accuracy,
  Lead hook timing + explosiveness, Body hook strength + inside, Uppercut explosiveness + inside, Check hook timing + footwork, Slip
  defence + flexibility). Grade Good / OK / Poor at the mean 62 / 50 (CODE `Exchanges.grade`); in the bout a planned line's edge
  is x1.2 / 0.85 / 0.35 (CODE constants, LINEGRADE1 sets them). MASTERY says how often it comes off; GRADE says how well when it does.
- BODY FACTS (NEW, fixing a dead edge): our fighters get height and reach at signing from their class (the same generator opponents
  use, `AttrGen.gd:227`), shown on the signing card and the tale of the tape. The duel then pays reach on the jab and height inside
  as it already does for opponents (`Duels.gd:412`). Reach also grades the Jab (above); height counts against Inside work.
- ON SCREEN (NEW, 3D reads only, the fight never decides): step length from Speed and height, step tempo from Speed and the step's
  grade; a Poor-grade step takes a visibly shorter, later step; a learning move is never shown (it is not thrown). Hand Speed scales
  punch clip playback within plus or minus 10% (ESTIMATE; stills and a side film check it, visual gate).
- This is the strongest part of his idea and the cheapest: one module written, one generator call, two 3D reads.

### M5. FOOTWORK IS LEARNED (NEW: steps get mastery; FireLevel stops reading them at 100)
- The 8 steps and 3 defences get mastery like punches, filled on pad nights (2.1 an hour), in SHADOW mornings (0.85, today the only
  session that trains the Footwork attribute) and in sparring (1.5). A step under 30 is not done: the plan line using it is greyed
  "Pivot: learning, 2 pad nights" (CODE grey reason pattern, `StrikeMap.grey_reason`). From 30 its fire share follows FireLevel tiers.
- The bar is the visible filling graphic he asked for, on the tree node, the drill card and the week review ("Pivot 24 -> 31: Usable,
  answers 'when she presses'").
- A shadow morning names its step ("Shadow: Pivot") so a morning now feeds a move bar, not only an attribute. No new session kind.

### M6. COACHES SET THE SPEED AND THE CEILING (CODE coach factor + AGREED RPG 11 + NEW gates)
- Speed: the pads coach's rating already multiplies every bar (x1 + 0.4 x rating / 100, CODE) and every attribute (0.5 + 0.7 x rating).
- NEW GATES read the pads coach's rating: 65+ opens the second learning slot; 75+ is needed to drill a move from Sharp toward
  Signature (below 75 the bar stops at 84: "needs a pads coach of 75 for Signature"). The gates read the club's best pads rating among the coaches who run that
  fighter's pad nights (CODE `Data.COACHES` areas). Luke Reid (pads 74, $450 sessional) gives two slots and reaches Signature work
  after 10 more pad sessions; Marcus Hale (pads 58, conditioning 90, $1,090 full time) gives one slot and much faster attributes.
  The hire is now a real choice between faster MOVES and faster BODIES, and a coach is a progression event, not only a percentage.
- GROWTH (AGREED RPG 11, unchanged): each of Coach's five areas +1 per 10 sessions run in it, up to the hire's ceiling (Reid +8, Hale
  +12, so Hale's pads can reach 70 and open the second slot in about two seasons); 40 pad sessions on one move opens Coach's
  signature drill (that move x1.2). Reid reaching pads 75 from 74 is the moment his fighters can start Signature work: the Monday
  review says so, a career milestone the player sees coming ("Reid: 3 pad sessions to 75").
- THE SHARED COACH (FM's workload): with four fighters, the club's pad nights are scarce (AGREED PADPOOL1: 8 a week, one overtime
  night $75). Two fighters with moves in learning compete for them; the pick card says whose bar slows.
- STAFF JOBS keep their one flat effect each (CODE `StaffRoles`); one link is added: the strength and conditioning coach makes
  Explosiveness and Strength mornings count for the power branch's grade (x1.1 on those attributes, ESTIMATE). No new staff meter.
- YOU (the head coach): AGREED RPG 2 (level from your own hours, either/or picks). Its source table gains one row: a move taken from
  30 to 60 on YOUR pad places: +1 experience.

### M7. THE FIGHT TEACHES AND PROVES (NEW, small)
- A move landed in a bout gains mastery as sparring does for its share of the exchanges (1.5 an hour, ESTIMATE for a 9-minute bout:
  about +1 to +3 on the moves used). Landed 3+ times in a won bout: FIGHT-PROVEN (gold on the node, CODE already marks combos thrown
  in fights gold) and one stamp.
- The Why's NEXT row names the node that would have answered what lost the bout ("Her pressure won 4 exchanges: Pivot would answer,
  it is 2 picks away") and its pick card opens from there.

### M8. FIRE LEVEL ON (CODE `FireLevel.gd`, queue row FIRELEVEL3, a first-season re-measure first)
- Without it Sharp and Signature are worth 1 in 100 and the tree's upper lines are invisible on fight night. With it (S427, 400 bouts a
  cell): Usable fires 1 in 2, Sharp 3 in 4, Signature always; Sharp +2.8 wins in 100 over Usable, Signature +2.7 over Sharp.

## 5. Amateur weeks against professional weeks along the arc
| | NOVICE AMATEUR (weeks 1 to about 12) | OPEN AMATEUR (season 1 to 2) | PROFESSIONAL (from the debut) | VETERAN (30+, or 20+ pro bouts) |
|---|---|---|---|---|
| Tree | rows 1-2 | rows 3-4 | row 5 opens (Gold) | no new rows; keeping moves |
| Slots | 1 | 1, or 2 with a 65+ pads coach | 2 with the coach; Signature with a 75+ coach | 2; Signature drilling counts double toward HOLDING (no decay) |
| Mornings | job rota (AGREED C31): about 3 free mornings; shadow names a step | the same; a gym sponsorship frees six (AGREED) | every morning free (C31): 2 more shadow or bag mornings a week for footwork | recovery mornings cost more (AGREED T38 age) |
| Bouts | a fight week, no camp, 1 to 2 weeks out (S428); every 3 to 4 weeks; one plan line ready | the same; the nationals (5 bouts, 3 months) | camps as load blocks (C15); 4 then 6 rounds; three promoter offers | fewer bouts, each worth more |
| What the week is for | Usable: get the fundamentals into the fight; Standard and Bronze awards | Sharp on two or three moves; a STYLE NAMED; Silver | a SPECIALTY: one move to Signature, the Gold row, perk picks | holding Signatures as Speed and ceilings fall |
| What they are eager for | the first combo, the first award, the first rank (S428) | the nationals, Silver, the pro offer | the first Signature, a perk, a belt | one more title before the body goes |
STYLE NAMED (NEW, season clock): three moves of one style's set at Sharp names the style on the Profile (Out-boxer: Jab, Step back,
Pivot; Pressure fighter: Cut off, Body hook, Tie up; Counter-puncher: Slip, Check hook, Roll; Boxer-puncher: Cross, Lead hook, Pivot;
Volume puncher: Jab, 1-2, Step in). The style word (CODE `FighterProfile` style words) then comes from what the fighter can DO, not
only from the dials, and the build direction (AGREED RPG 12) offers its style's nodes first.

## 6. One week played (four fighters, week 9, ESTIMATES worked from the code's formulas)
Monday: two moves crossed lines on Sunday night (Tess's Body hook 30: Usable, opens 1-2-3b and Tie up; Lucy's Step back 30). Home shows
two steel needs, A MOVE TO PICK x2. Tess's three: Tie up (her next opponent presses: answers inside; 2 weeks), Uppercut (Bronze needs
it; 3 weeks; Poor grade, explosiveness 48), Pivot (direction Keep it long first; 2.5 weeks). Lucy's: Pivot, Cut off, Slip. The club has
8 pad nights; Samira (bout Saturday) holds 3 for her plan lines; the pick card says Lucy's Pivot takes 3 weeks on 2 nights, 2 weeks on 3
(one of Tess's). Shadow mornings name Pivot for Lucy. Sunday: Lucy's Pivot 17, Tess's Tie up 16; Samira wins; her Lead hook landed 4
times: FIGHT-PROVEN, a stamp, Bronze 13 of 14. Next Monday's preview already says: "Samira: Bronze next week if Body hook reaches 30".

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > Profile (Overview) | award chip with stamps; NEXT UNLOCKS strip: three rows (week: the bar nearest its line and its day; season: next award and what it opens; career: pro offer or Signature line); height and reach on the header | `SkillAwards.progress`, new `MoveTree.next_unlocks(f)`, `PadWeek.project`, `Roster.check_pro` |
| Playbook > Moves (becomes THE TREE) | the 22 nodes in four branches by row; bar, ticks, grade letter, what it opens, locked reason; the slot(s) marked; click a node: watch it (CODE MoveBook clip), drill it (to the pad tray), pick it (when a slot is free) | new `MoveTree.gd` (pure), `LineGrade.grade`, `MoveMastery`, `ui/MoveBook.gd` clip player |
| Playbook > Combos | each book combo greyed with the node that opens it ("needs Uppercut: 3 weeks if picked") | `Combos.unlocked`, `MoveTree` |
| Playbook > Game plan | a line whose move is in learning: greyed with its days to 30; the line's grade letter | `StrikeMap.grey_reason`, `LineGrade` |
| Week / Training (pad tray) | drill cards for steps and defences as for punches; the learning slot's card first; shadow mornings name their step | `PadWeek`, `WeekPlan` shadow session target |
| Monday review | lines crossed with what each opened; award passed (a card, the new row lit); the pick card when a slot freed; Coach's area rising past a gate ("Reid pads 75: Signature work open") | `DrillWeek` news, `SkillAwards.assess`, `CoachAreas` growth (RPG 11) |
| Home | steel need A MOVE TO PICK (never stops the clock); amber when unpicked by Sunday | Home needs list, `MoveTree.slot_free` |
| Fighters page | the award chip beside "Best move"; the style named | `SkillAwards`, `MoveTree.style_named` |
| Fights > bout card and bout page | "what this opponent tests" names the open node that answers it and how far it is | `OppFile`, `MoveTree.answers` |
| Fight night | 3D step length and tempo from Speed, height and the step's grade; plan captions carry the grade | `fight3d/BoxerFootwork.gd` reads, `LineGrade` |
| Result and the Why | FIGHT-PROVEN marks; mastery the bout added; NEXT names the node that would have answered and opens its pick | `BoutNight._finish`, new `MoveTree.prove`, `FightWhy` |
| Club > People | each coach's pads rating, what the next gate opens (second slot 65, Signature 75), sessions to the next area point | `CoachAreas`, RPG 11 growth |
| Signing card / Find a fighter | rows already known, the signature move, height and reach | `Recruit`, `AttrGen` body facts |
| Pro offer | "turning pro opens the Gold row: Feint, own chains of four, the slip-counter" | `MoveTree.row_for("gold")` |

## 8. How it all links (so it stays deep but simple)
pads coach rating -> bar speed, slots, Signature gate -> moves cross lines -> stamps -> award -> next tree row + energy discount ->
new plan answers and combinations -> fight night (fire share by tier, grade by body) -> bouts won, moves proven -> rank, nationals,
pro offer -> the Gold row and Signatures -> the coach's sessions grow the coach -> faster bars. One bar per move, one chip per fighter
(the award), one pick per freed slot. Nothing new to manage on Monday except the pick.

## 9. To be measured before any build (through the game's real code; each prints today's game first)
| Probe | What it plays | It passes when |
|---|---|---|
| PROGPROBE1 cadence | two seasons of the four starters through `Sim` with the coach's week and a pick policy (coach's first card); logs every line crossed, combo opened, award, pick, style named, per fighter per week; today's game as arm A, this map as arm B | each fighter crosses a line in 3 of 4 weeks; a pick every 2 to 3 weeks per fighter; no gym week with nothing crossed; Standard by week 6 to 10, Bronze in season 1, a style named in season 1; Gold not before the pro offer |
| TREEVALUE1 node worth | each node at Usable and at Sharp, on the played bout (BoutRead + real bouts as ASKPROBE2, 60 generated fighters, four opponent styles), FireLevel ON | every node moves 1.5 wins in 100 or more against at least one style (the C27 cut rule) and no node is best against all four; a node under the bar is cut or merged |
| PICKSPREAD1 the three cards | 60 fighters at their first five picks; each of the three cards played forward 6 weeks | no card position wins more than 6 in 10; the coach's first card is best less than 7 in 10 (else the pick is a lookup) |
| BODYFACT1 height and reach | our fighters with body facts against without, per class | the reach and height edge moves 1 to 4 wins in 100 between the longest and shortest in a class, never more |
| GRADE1 (LINEGRADE1) | the grade multipliers on the played bout | Good against Poor on the same line worth 2 or more wins in 100; no attribute pair decides more than a third of grades |
| FOOTWORK1 | steps gated by mastery against today's always-on steps | a novice without Step back loses at least 1.5 more in 100 to pressure; nothing worse than 5 (it must not make novices unplayable) |
Gate: the probes report into `ops/AgentComms/levers.json` (C27); a mechanic whose probe fails is redesigned before it is drawn.

## 10. Build order (after his OK; each task under 500 lines, one owner, its test red on main first)
1 FIRELEVEL3 (queued; Claude): fire share on in GAME_ON after its re-measure. 2 BODYFACTS1 (Qwen): height and reach for our fighters
+ test. 3 MOVETREE1 (Goose, pure): `MoveTree.gd` + `assets/data/box_tree.json` (nodes, rows, needs, opens, style sets) + tests.
4 STEPMASTERY1 (Claude, fight code): steps and defences get mastery; FireLevel and PlanFight read it; StrikeMap grey reason.
5 LINEGRADE2 (Claude): LineGrade wired into PlanFight. 6 SLOTS1 (Qwen, pure): learning slots, the coach's three, coach gates.
7 AWARDSTAMP1 (Qwen): stamps counted from bars in SkillAwards. 8 FIGHTPROVE1 (Claude): bout mastery and the mark. 9 the probes
(Goose / Arena, section 9). 10 screens (Grok Dev, one a task, from the approved drawing): the tree page, the pick card, the Profile
strip, the Monday rows. 11 BOXSTEP3D1 (Ziva, after the stills): step length and tempo reads. 12 golden path (Grok Dev): a fighter
from signing to the pro offer picking 6 moves, passing Standard and Bronze, naming a style, a fight-proven mark, Reid crossing pads 75.
Staff growth (RPG 11) is built after the fighter loop has been played (the lead's order and his scope rule).

## 11. Rejected, and why
- A separate fighter XP spent on ratings (Boxing Manager): a second currency beside mastery and the coach's experience; the bars
  already say what was earned.
- A big tree with new punches (overhand, body jab, shoulder roll): each needs clips and fight hooks; LATER, as nodes added to the same
  tree once the 22 prove themselves (TREEVALUE1).
- Learning any number of moves at once: no decision; the slot is the decision.
- Coach perks that are "+5% training": AGREED RPG cut rule; the coach's growth opens gates instead.
- A training mini-game for pads: grind (Fight Night Champion); the pick and the pad nights are the play.

## 12. Risks, said plainly
- Starting fighters who know fewer moves will look weaker in the first weeks; the signing state keeps row 1 at today's start shares.
- Gating steps can make novices lose more to pressure (FOOTWORK1 bounds it).
- Four fighters' picks every week could feel like chores: the pick is one click with the coach's first card pre-marked, and an
  unpicked slot takes it by itself.
- The 3D reads need clean stills before they ship (visual gate); the numbers ship first.
- Stamps and award thresholds are ESTIMATES until PROGPROBE1.
