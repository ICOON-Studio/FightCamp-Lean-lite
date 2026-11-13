# LIVERRIBS1_V2 - write the NEXT version of this mechanic's design map (S459 design loop)

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

# LIVERRIBS1 - the liver and the ribs do different things (design map v1, S460)

His answer, Q-S294-219 (S460 board): "Yes: liver = stamina drain + a knockdown chance when hurt, ribs = the injury place
(cracked rib, weeks out). Design map + critics first".

## Today (read in the code, S460)
- Only `body_hook` reaches a rib. The defender's liver side takes 60 in 100 of them (BodyMap.LIVER_SHARE), her right ribs
  when orthodox, her left when southpaw (BodyMap.gd:76-83).
- Every body shot taken costs the same stamina whatever the side (Exchanges.BODY_COST 1.2, scaled by her body stat,
  Exchanges.gd:35-45; FightMeters caps her tank by body_taken). The "hurt" line is the same on both sides (BodyMap.band).
- Knockdowns read HEAD damage only (Knockdowns.gd: DAMAGE_SCALE, KO_DAMAGE). A body punch never drops anyone.
- After the bout InjuryRoll draws ONE "Rib injury" (weight 10, x3 when a rib place is under 35; 21-35 days), the same for
  either side (InjuryRoll.gd BOUT_TYPES, RIB_HURT_LINE).
- The holo already names the sides "liver" and "ribs" (RoundHits.WORDS), so the player sees two places that act the same.

## The change in one line
The LIVER wins you tonight (her tank drains faster, and once it is hurt a hook can drop her). The RIBS cost her weeks (a
bruised or cracked rib after the bout, and a rib can crack DURING the bout - which hands the corner a real decision).

## Rules
| # | Rule | Numbers (TUNE range) | Real-world basis |
|---|---|---|---|
| 1 | Body stamina by side: a landed liver shot costs BODY_COST x LIVER_DRAIN, a rib shot x RIB_DRAIN. Chosen so 60/40 traffic costs what it costs today (no rebalance of the tank) | LIVER_DRAIN 1.3 (1.2-1.5), RIB_DRAIN 0.55 (0.4-0.7): 0.6x1.3 + 0.4x0.55 = 1.0 | A liver shot sets off a vagal reflex (blood pressure falls, legs go); a rib shot hurts but does not shut the body down |
| 2 | LIVER HURT knockdown: once her liver place is at HURT or worse (BodyMap band), each landed liver hook rolls a delayed fold | 3% x e^((his power - her Durability)/12), clamp 1-8%; x2 at CRITICAL; at most 2 a bout | Liver knockdowns come a beat late and are often full counts (fighter folds, cannot rise) |
| 3 | A liver knockdown is a body count: she rises at 8 or is counted out; her legs bar drops 25 for the round (the 3D shows a fold, not a fall back) | count-out share 35% (25-45%) vs 15% for a head knockdown today | Body knockouts are counted out far more often than head knockdowns (pain, not a blackout) |
| 4 | The S437 FRESH liver counter stays: a counter's left-hand body hook can drop a fresh fighter (0.6%, x2 on her Push, cap 3%, once a bout) | as DAMAGE_MAP_S437 row 10 | the timed liver shot |
| 5 | RIBS in the bout: once a rib place is at CRITICAL, each landed rib hook rolls a CRACK | 4% (2-6%) | ribs crack under repeated hooks; rare on one night |
| 6 | A CRACK changes the bout: her punches from that side x0.6, her guard on that side -10, and at the bell the corner must answer (rule 7). The opponent's crack is shown as a corner read ("she is holding her left side") | x0.6 (0.5-0.8), guard -10 (6-14) | a cracked rib = she shortens that arm and protects the side |
| 7 | YOUR fighter cracked: a corner card between rounds - PULL HER OUT (loss by retirement, the crack heals at the short end) or FIGHT ON (the rest of the bout at rule 6, and the crack heals at the long end x1.5) | Pull out: 35 days; fight on: 56 x1.5 = 84 days (TO SOURCE) | corners retire boxers with a cracked rib; fighting on worsens it |
| 8 | After the bout the ribs roll splits in two: BRUISED RIBS (the non-liver side under 50, or any rib at HURT) and CRACKED RIB (a crack in the bout, or the non-liver side at CRITICAL) | bruised 10-21 days (sparring locked, pads OK); cracked 35-56 days (no sparring, no pads on that side; roadwork, legs, technique OK) | rib bruise 1-3 weeks; rib fracture ~6 weeks to heal |
| 9 | The liver itself is never a weeks-out injury (a hurt liver is gone in days): its price is all on the night | - | liver shots leave no lasting injury in healthy athletes |
| 10 | Training: body sparring and body bag nights roll BRUISED RIBS from load as today (TRAIN_TYPES ribs); a cracked rib never comes from training without a spar night | as today | |

## The player's choices this makes (depth)
- AIM LIVER (tonight): faster tank drain and, once it is hurt, a knockdown. Covered more (it is the rear side of an orthodox
  defender: 60% cover), so it pays against a pocket fighter who will not cover it, and against a southpaw where it is the lead side.
- AIM RIBS (the other side): less cover (30%), little tonight, but the crack chance and the injury after. Against a rival you
  will meet again on the ladder, a cracked rib keeps her off the cards for 6-8 weeks (the small living world reads her injury).
- DEFENCE for her own body: "Cover up" / "Tie up" already cut body shots; now the PLAYER picks WHICH side to cover - a liver
  cover saves the night, a rib cover saves the next two months. One shout, two meanings.
- THE CORNER CARD (rule 7): a cracked rib on your fighter is a real call - a sure loss and 5 weeks, or a chance tonight and 12 weeks.
- TRAINING: a body-puncher's camp picks body sparring on purpose; Durability (chin and body) now buys two different things.
- BOOKING: an opponent's file (scout) shows "hunts the liver" or "breaks ribs" from her past bouts; the forecast reads the Aim.

## Where it shows (every menu, what it is wired to)
| Menu | What the player sees | Wired to | Test |
|---|---|---|---|
| Live round: side holos | "liver" and "ribs" counts as today; tooltip: liver "each costs her X stamina; hurt: a knockdown can come", ribs "hurt: it can crack; weeks out after" | BodyLive + LiverRibs (new pure rules) | holo_live_test row |
| Live round: AIM buttons | "Liver" / "Ribs" in place of "Right ribs" / "Left ribs"; effect line "Liver: drains her, can drop her when hurt" / "Ribs: can crack, weeks out" | PaceAim labels + aim_effect | pace_aim row |
| Live round: corner read | "She is holding her left side" after a crack; "Her liver is hurt" at the HURT band | CornerRead lines | corner read row |
| Live round: knockdown | the 3D fold + count; the commentary names the liver | Knockdowns body path + KnockdownCount | knockdown_rates row |
| Between rounds: corner card | the CRACK card for your fighter: Pull her out / Fight on, each with its days out | CornerJobs + the injury days | golden path |
| Bout forecast (BoutRead) | the Aim's liver / ribs share fires in the forecast the same way as in the fight (S459 rule: mirror every fight lever) | BoutRead | bout_read_test |
| Fight result page | knockdown line "to the liver, round 2"; the injury line "Cracked rib (left), fit Mon 2 Mar" | Aftermath + Injuries.line | result_defects row |
| Home: needs card + news | the injury with its weeks; a crack fought on shows "fought on a cracked rib: 12 weeks" | Injuries.after_bout | injuries_test row |
| Fighter page > Week | locked sessions greyed: "no sparring, ribs, until Mon 2 Mar"; pads allowed on a bruise | PadWeek / StandDown locks | pad_week row |
| Opponent file (scout) | "hunts the liver" / "breaks ribs" from her record | Scout lines | scout row |

## Build (after the critics' 6+ / 6+ and his board OK)
1. LiverRibs.gd (pure, Qwen/Arena): drain(side), liver_fold_chance(power, durability, band), crack_chance(band), injury_split(places, crack) + tests.
2. Wire: Exchanges body cost by side; Knockdowns body path; BodyLive crack + corner card; InjuryRoll split; PaceAim words; BoutRead mirror.
3. Golden path: aim liver, see her tank drop faster, a body knockdown line on the result page; a crack on our fighter, the corner card, the weeks on the Home card.

## Open for the critics
- Is "ribs = weeks out" enough of a reason to aim the ribs for a player who only cares about tonight (rule 7/8 are mostly about
  OUR fighter)? The rival-on-the-ladder payoff needs the small living world; until then it is the crack in the bout.
- Is a liver fold at 3-8% per hurt hook the right size (two or three liver-hurt rounds a season should end in a body count)?


# CRITIC ANSWER: DESIGN_LIVERRIBS1_CRITIC_DOLA_DOLA.md

# DESIGN_LIVERRIBS1_CRITIC_DOLA_DOLA - Dola answer (seat queue SQ77)

Brief: research/DESIGN_LIVERRIBS1_CRITIC_DOLA.md
Sent: 2026-11-13 22:10 | collected: 2026-11-13 22:40 by Tools/seat_queue.py (the 30-min reconcile)
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
LiverRibs1 Mechanic Design
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
LiverRibs1 Mechanic Design
Generated by Dola AI
LIVERRIBS1 - score this mechanic's DESIGN (S459 design loop)
You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design map
at the end. Judge the MECHANIC, not the look of any screen.
Score, each out of 10, with the reasons:
DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
The bar (owner S459): the mechanic is DESIGNED when critics give it 6+ on DEPTH and 6+ on GENERAL DESIGN.
Also answer: which options are missing, which are useless, and what each option changes (owner S403).
End with To reach 10/10: the concrete changes that would take it to 10, most important first, each specific enough to
build (owner S405). Then describe your 10/10 as a 1920x1080 page (an HTML file is welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent"). Real-world boxing evidence where it helps.
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
LIVERRIBS1 - the liver and the ribs do different things (design map v1, S460)
His answer, Q-S294-219 (S460 board): "Yes: liver = stamina drain + a knockdown chance when hurt, ribs = the injury place
(cracked rib, weeks out). Design map + critics first".
Today (read in the code, S460)
Only body_hook reaches a rib. The defender's liver side takes 60 in 100 of them (BodyMap.LIVER_SHARE), her right ribs
when orthodox, her left when southpaw (BodyMap.gd:76-83).
Every body shot taken costs the same stamina whatever the side (Exchanges.BODY_COST 1.2, scaled by her body stat,
Exchanges.gd:35-45; FightMeters caps her tank by body_taken). The "hurt" line is the same on both sides (BodyMap.band).
Knockdowns read HEAD damage only (Knockdowns.gd: DAMAGE_SCALE, KO_DAMAGE). A body punch never drops anyone.
After the bout InjuryRoll draws ONE "Rib injury" (weight 10, x3 when a rib place is under 35; 21-35 days), the same for
either side (InjuryRoll.gd BOUT_TYPES, RIB_HURT_LINE).
The holo already names the sides "liver" and "ribs" (RoundHits.WORDS), so the player sees two places that act the same.
The change in one line
The LIVER wins you tonight (her tank drains faster, and once it is hurt a hook can drop her). The RIBS cost her weeks (a
bruised or cracked rib after the bout, and a rib can crack DURING the bout - which hands the corner a real decision).
Rules
#	Rule	Numbers (TUNE range)	Real-world basis
1	Body stamina by side: a landed liver shot costs BODY_COST x LIVER_DRAIN, a rib shot x RIB_DRAIN. Chosen so 60/40 traffic costs what it costs today (no rebalance of the tank)	LIVER_DRAIN 1.3 (1.2-1.5), RIB_DRAIN 0.55 (0.4-0.7): 0.6x1.3 + 0.4x0.55 = 1.0	A liver shot sets off a vagal reflex (blood pressure falls, legs go); a rib shot hurts but does not shut the body down
2	LIVER HURT knockdown: once her liver place is at HURT or worse (BodyMap band), each landed liver hook rolls a delayed fold	3% x e^((his power - her Durability)/12), clamp 1-8%; x2 at CRITICAL; at most 2 a bout	Liver knockdowns come a beat late and are often full counts (fighter folds, cannot rise)
3	A liver knockdown is a body count: she rises at 8 or is counted out; her legs bar drops 25 for the round (the 3D shows a fold, not a fall back)	count-out share 35% (25-45%) vs 15% for a head knockdown today	Body knockouts are counted out far more often than head knockdowns (pain, not a blackout)
4	The S437 FRESH liver counter stays: a counter's left-hand body hook can drop a fresh fighter (0.6%, x2 on her Push, cap 3%, once a bout)	as DAMAGE_MAP_S437 row 10	the timed liver shot
5	RIBS in the bout: once a rib place is at CRITICAL, each landed rib hook rolls a CRACK	4% (2-6%)	ribs crack under repeated hooks; rare on one night
6	A CRACK changes the bout: her punches from that side x0.6, her guard on that side -10, and at the bell the corner must answer (rule 7). The opponent's crack is shown as a corner read ("she is holding her left side")	x0.6 (0.5-0.8), guard -10 (6-14)	a cracked rib = she shortens that arm and protects the side
7	YOUR fighter cracked: a corner card between rounds - PULL HER OUT (loss by retirement, the crack heals at the short end) or FIGHT ON (the rest of the bout at rule 6, and the crack heals at the long end x1.5)	Pull out: 35 days; fight on: 56 x1.5 = 84 days (TO SOURCE)	corners retire boxers with a cracked rib; fighting on worsens it
8	After the bout the ribs roll splits in two: BRUISED RIBS (the non-liver side under 50, or any rib at HURT) and CRACKED RIB (a crack in the bout, or the non-liver side at CRITICAL)	bruised 10-21 days (sparring locked, pads OK); cracked 35-56 days (no sparring, no pads on that side; roadwork, legs, technique OK)	rib bruise 1-3 weeks; rib fracture ~6 weeks to heal
9	The liver itself is never a weeks-out injury (a hurt liver is gone in days): its price is all on the night	-	liver shots leave no lasting injury in healthy athletes
10	Training: body sparring and body bag nights roll BRUISED RIBS from load as today (TRAIN_TYPES ribs); a cracked rib never comes from training without a spar night	as today	
The player's choices this makes (depth)
AIM LIVER (tonight): faster tank drain and, once it is hurt, a knockdown. Covered more (it is the rear side of an orthodox
defender: 60% cover), so it pays against a pocket fighter who will not cover it, and against a southpaw where it is the lead side.
AIM RIBS (the other side): less cover (30%), little tonight, but the crack chance and the injury after. Against a rival you
will meet again on the ladder, a cracked rib keeps her off the cards for 6-8 weeks (the small living world reads her injury).
DEFENCE for her own body: "Cover up" / "Tie up" already cut body shots; now the PLAYER picks WHICH side to cover - a liver
cover saves the night, a rib cover saves the next two months. One shout, two meanings.
THE CORNER CARD (rule 7): a cracked rib on your fighter is a real call - a sure loss and 5 weeks, or a chance tonight and 12 weeks.
TRAINING: a body-puncher's camp picks body sparring on purpose; Durability (chin and body) now buys two different things.
BOOKING: an opponent's file (scout) shows "hunts the liver" or "breaks ribs" from her past bouts; the forecast reads the Aim.
Where it shows (every menu, what it is wired to)
Menu	What the player sees	Wired to	Test
Live round: side holos	"liver" and "ribs" counts as today; tooltip: liver "each costs her X stamina; hurt: a knockdown can come", ribs "hurt: it can crack; weeks out after"	BodyLive + LiverRibs (new pure rules)	holo_live_test row
Live round: AIM buttons	"Liver" / "Ribs" in place of "Right ribs" / "Left ribs"; effect line "Liver: drains her, can drop her when hurt" / "Ribs: can crack, weeks out"	PaceAim labels + aim_effect	pace_aim row
Live round: corner read	"She is holding her left side" after a crack; "Her liver is hurt" at the HURT band	CornerRead lines	corner read row
Live round: knockdown	the 3D fold + count; the commentary names the liver	Knockdowns body path + KnockdownCount	knockdown_rates row
Between rounds: corner card	the CRACK card for your fighter: Pull her out / Fight on, each with its days out	CornerJobs + the injury days	golden path
Bout forecast (BoutRead)	the Aim's liver / ribs share fires in the forecast the same way as in the fight (S459 rule: mirror every fight lever)	BoutRead	bout_read_test
Fight result page	knockdown line "to the liver, round 2"; the injury line "Cracked rib (left), fit Mon 2 Mar"	Aftermath + Injuries.line	result_defects row
Home: needs card + news	the injury with its weeks; a crack fought on shows "fought on a cracked rib: 12 weeks"	Injuries.after_bout	injuries_test row
Fighter page > Week	locked sessions greyed: "no sparring, ribs, until Mon 2 Mar"; pads allowed on a bruise	PadWeek / StandDown locks	pad_week row
Opponent file (scout)	"hunts the liver" / "breaks ribs" from her record	Scout lines	scout row
Build (after the critics' 6+ / 6+ and his board OK)
LiverRibs.gd (pure, Qwen/Arena): drain(side), liver_fold_chance(power, durability, band), crack_chance(band), injury_split(places, crack) + tests.
Wire: Exchanges body cost by side; Knockdowns body path; BodyLive crack + corner card; InjuryRoll split; PaceAim words; BoutRead mirror.
Golden path: aim liver, see her tank drop faster, a body knockdown line on the result page; a crack on our fighter, the corner card, the weeks on the Home card.
Open for the critics
Is "ribs = weeks out" enough of a reason to aim the ribs for a player who only cares about tonight (rule 7/8 are mostly about
OUR fighter)? The rival-on-the-ladder payoff needs the small living world; until then it is the crack in the bout.
Is a liver fold at 3-8% per hurt hook the right size (two or three liver-hurt rounds a season should end in a body count)?
Show More
🧊 LIVERRIBS1 — Mechanic Score & Review
Scoring: 1–10; 6+ = meets design standard
📊 Scores
Table
#	Criterion	Score	Reason
1	DEPTH	9/10	Two distinct targets with truly different rewards & risks — liver wins tonight, ribs win the campaign. No dominant pick: each shines in different matchups. Choices cascade into planning, scouting, corner calls, booking & training. Trade-offs are sharp and visible.
2	GENERAL DESIGN	9/10	Clean rule set, consistent boxing logic, minimal new jargon. Builds entirely on existing systems: Aim buttons, damage bands, injury roll, corner card, scout file, week locks. Nothing feels tacked on; every part has a clear place.
3	PLAY	8/10	Immediate tension every body shot lands. Anticipation builds: will the tank empty? Will a rib crack? Scouting adds meaningful homework. The rival injury payoff needs the living world to feel complete — until then it works well but not great.
Design bar met ✅ — DEPTH & GENERAL DESIGN both well above 6+
📋 Breakdown: Options, Changes, Gaps
What each option changes
Table
Choice	Immediate effect	Longer-term effect
Aim Liver	Faster stamina drain; knockdown chance once hurt; easier to miss — rear side for orthodox	Can end a fight early; no lasting injury to opponent
Aim Ribs	Minimal stamina cost; small but cumulative crack risk	Crack = 5–8 weeks out; opponent falls off rankings; no immediate finish
Cover Liver	Slows opponent's finish chance; tank holds longer	No cost tonight, but opponent can switch target
Cover Ribs	No immediate benefit; opponent keeps draining you	Protects your fighter's next months on the calendar
Pull Out	Safe loss; 5 weeks recovery	No long-term damage; record takes a hit
Fight On	Keep fighting at reduced performance; crack worsens	12 weeks out; higher permanent damage risk
✅ What works well
Symmetry: liver = tonight, ribs = tomorrow — simple, powerful distinction
Real boxing evidence aligned: vagal reflex / body knockouts vs rib fracture healing times
Every existing screen gets a clear, lightweight update — no rebuild needed
⚠️ Useless options — none
Every choice matters in some context. Even niche decisions (e.g., Fight On) serve specific player goals like title timing or fan loyalty.
❌ Missing options
Switch target mid-bout — no in-bout prompt when scouting reveals opponent protects one side well
Partial rib protection — only full-cover / no-cover choices; can't "guard more carefully but keep working"
Taper sparring intensity — no "light contact only on body" option to reduce bruise risk during hard camps
Injury forecast on bout accept — you see the style but not the risk profile before signing the contract
Opponent adjusts target — AI never switches sides after you cover one well; missing the "chess match" depth
🚀 To reach 10/10 — Priority Changes
🔹 #1 — AI adapts target (HIGHEST)
When you consistently cover one side well, the opponent switches aim after 1–2 rounds. Shows in corner read: "She's going to the other side now". Forces genuine adjustment instead of setting one Aim and forgetting it.
Build: Add last_3_rounds_aim → switch_after = 2 to OpponentAI; wire to existing CornerRead line.
🔹 #2 — Injury risk on bout offer
On the bout acceptance screen, under scouting notes: "Style: body specialist — moderate rib injury risk". Not a guarantee — just probability bands (Low / Moderate / High). Lets players weigh "is this win worth 2 months out?" before committing.
Build: Add injury_risk_band to BoutRead from opponent's style + body-shot frequency; 3-band display, no exact percentage.
🔹 #3 — Three corner options instead of two
Replace binary Pull/Fight with:
✋ Pull out — loss, heals 35 days
⚡ Fight through — -40% power/defence, heals 84 days
🛡️ Defend only — no power penalty but you lose that side's offence; heals 63 days
Gives a genuine middle ground — most pros protect but don't quit.
Build: Add third button to CornerCrack modal; adjust injury_days and fight_effect multipliers.
🔹 #4 — Switch target from corner card
Between rounds, if opponent shows a clear preference: "She's overworking your left side — aim her right ribs instead". One-click Aim override. No extra complexity — just exposes what's already calculated.
Build: When opponent_aim_consistent > 2 rounds → add suggestion button to corner notes; sets next_round_aim.
🔹 #5 — Small living world reactions
Opponent misses her next scheduled bout → news line: "Out with cracked rib — pulls from regional eliminator". Your ranking shifts automatically. That's when "injuring the ribs" feels like a ladder move, not just a stat line.
Build: Wire InjuryRoll → WorldNews + OpponentCalendar; delay next_bout_date if injured.
🖥️ 10/10 Design — 1920×1080 Layout
plaintext
┌─────────────────────────────────────────────────────────────────────┐
│  TOP BAR — dark, date + cash + flags                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  LIVE ROUND DISPLAY                        OPPONENT INFO PANEL        │
│  ┌─────────────────────┐                  ┌───────────────────────┐  │
│  │  ● LIVER    ● RIBS   │                  │  Style: Body hooker   │  │
│  │  Drain: HIGH    │    │                  │  Prefers: Liver (60%)│  │
│  │  Risk:  DROP    │    │                  │  Injury risk: HIGH    │  │
│  └─────────────────────┘                  └───────────────────────┘  │
│                                                                       │
│  AIM BUTTONS — one always lit                                         │
│  [ AIM LIVER — drain stamina → finish late ]  [ AIM RIBS — damage → ] │
│                                                                       │
│  DEFEND BUTTONS — one active                                         │
│  [ COVER LIVER — save tonight ]    [ COVER RIBS — save next month ] │
│                                                                       │
│  OPPONENT STATUS — updates every exchange                            │
│  ────────────────────────────────────────────────────────────────── │
│  Round 3: "Her breathing tight — liver taking effect"                 │
│  Round 4: "She's switching — going to your left ribs now"            │
│  Round 5: ⚠️ "Holding side — possible crack"                          │
│                                                                       │
│  ────────────────────────────────────────────────────────────────── │
│  CORNER CARD — BETWEEN ROUNDS              │  SCOUTING NOTES         │
│  ┌─────────────────────────────────────┐  │  ┌───────────────────┐  │
│  │ ⚠️ CRACKED RIB — LEFT SIDE           │  │  │  Last 3 fights     │  │
│  │                                      │  │  │  ✅ Cracked 2 opp │  │
│  │  ✋ Pull Out      → Loss / 35 days   │  │  │  ❌ Liver 0 KO    │  │
│  │  🛡️ Defend Only   → -0% power,      │  │  └───────────────────┘  │
│  │                     63 days recovery │  │                         │
│  │  ⚡ Fight Through → -40% power,    │  │  INJURY FORECAST        │
│  │                     84 days recovery │  │  Rib risk: HIGH        │
│  └─────────────────────────────────────┘  │  Next bout: 6 weeks   │
│                                            └───────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘

What makes this 10/10:
Every decision has a clear why and what next — no hidden math
Immediate feedback loops: see the tank drain, see the opponent adapt
The corner card gives three realistic choices instead of a brutal binary
Injury risk is visible before you commit — so you never feel tricked later
Scouting and world news complete the loop: injuring someone changes the division, not just one fighter's calendar
Bottom line: LIVERRIBS1 is already an excellent mechanic — it hits the core requirement of creating real trade-offs without unnecessary complexity. The missing pieces are all behavioural and contextual, not foundational. With those five changes, it becomes one of FightCamp's most satisfying systems — every body shot carries a decision that echoes both tonight and next season. ✅
Fast→Pro: I can turn this into a full HTML mockup with working buttons and state previews, or refine the balance numbers into a ready-to-build spec sheet — tap Fast and select Pro to get it.
Chat
Create Videos
Create Images
Writing
Homework
Translate


# CRITIC ANSWER: DESIGN_LIVERRIBS1_CRITIC_JOHN_JOHN.md

# DESIGN_LIVERRIBS1_CRITIC_JOHN_JOHN - John answer (seat queue SQ78)

Brief: research/DESIGN_LIVERRIBS1_CRITIC_JOHN.md
Sent: 2026-11-13 22:10 | collected: 2026-11-13 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading the LIVERRIBS1 map against the pack now. The full critic return comes next.

# LIVERRIBS1 v1 (S460): critic

Scores: depth **5/10**, general design **5/10**, play **6/10**. That misses the owner's bar on both depth and general design. I couldn't open `CRITIC_ACCESS.md` or the board, because your computer is offline, so I judged from the map and the pack.

## Logic check

**The code puts the liver on the wrong side for a southpaw.** The map reads `BodyMap.gd:76-83` as the right side when orthodox and the left side when southpaw. The liver sits on the right side of every body; stance only decides whether that side is the lead or the rear. The map's own line ("against a southpaw where it is the lead side") is anatomically right and contradicts the code. Fix the code first, or every southpaw bout aims at an organ that isn't there.

**The side is set by the hand that throws, not by a free Aim.** A hook from the attacker's left hand lands on the defender's right side (the liver). A right-hand hook lands on the left side (ribs and spleen).
- Every body punch in the book is `body_hook` (3b, the lead hook). For an orthodox attacker that's the left hand, so it can only reach the liver.
- Rule 4 already says "a counter's left-hand body hook" goes to the liver, which is right, but Aim Ribs then needs a punch the game doesn't have: a rear body hook or a right to the body.
- Real boxing bears this out. The orthodox boxer's left hook to the liver is the classic body shot, and in a southpaw against orthodox fight, the southpaw's rear left to the liver is a staple.
- Without a rear-hand body move, "Aim Ribs" is a label with no punch behind it.

**Liver beats ribs for tonight in every matchup the map lists.** The map's own cover figures are 60 in 100 on the liver and 30 on the ribs. Neither figure is in the pack or in the "Today" code list, so both need a source in the code.
- Per body hook thrown, the liver lands 0.4 × 1.3 = 0.52 of drain, against 0.7 × 0.55 = 0.385 for the ribs. The liver does 35% more, plus the fold chance.
- Against a southpaw the liver is the lead side, so it's covered less and the liver wins by more.
- So for tonight, ribs are never right, and the only reason to pick them is weeks out.

**Rule 8 makes a crack almost certain, and that dwarfs rule 5.** "Cracked rib if the non-liver side is at CRITICAL after the bout" is deterministic. Today that same state only triples a weight-10 roll inside a 6% bout-injury chance.
- Any bout where the rib side reaches CRITICAL now costs 35–56 days for sure, so the 4% crack per hook during the bout barely matters by comparison.
- The map gives no figure for how often a rib side reaches CRITICAL in a 3 × 3 amateur bout. Without it, the injury rate across a season could jump several times over.

**Rules 8 and 9 contradict each other.** Rule 8 gives bruised ribs if "any rib is at HURT", and the liver side is a rib place. Rule 9 says the liver is never a weeks-out injury. "Under 50" and "at HURT" (under 55) also overlap, so "under 50" does nothing.

**Pulling out costs more than its 35 days.** A retirement is a stoppage loss under rules the game already has:
- the 30-day suspension
- offers 8 weeks later than usual (`STOP_REST_WEEKS`)
- −2 members, −4 reputation and −12 morale

So the next bout is about 8 weeks away either way, and the real gap between the two answers is about 4 weeks (56 days against 84) traded for a win chance the card doesn't print. "Fight on" also carries no added risk beyond the ×1.5, which is what a real corner fears most.

**The opponent's crack has no corner rule.** The map doesn't say whether the opponent's corner ever pulls her out, or at what odds. If it never does, a crack on the opponent becomes a free edge for the player.

**Defence by side is promised but has no rule.** "Cover up" isn't one of the eight calls. There's "Hands up move your head" and "Tie up", and no rule number covers a liver or rib cover. The corner minute's Elbows in and Gloves high already move body punches, and the pack says they were "measured not to change who wins". With liver knockdowns they will, so they need measuring again.

**Things it uses that don't exist yet:**
- A "legs bar" (rule 3) isn't in the pack.
- "Her body stat" (rule 1) isn't named.
- Rule 2 uses "his power", and Power is a summary stat since S448. It should use the punch's own power from Strength, Explosiveness and the move's mastery.
- Reading a rival's injury on the ladder needs NPC injuries, which aren't established. An injured rival also keeps her rank, so the payoff is small anyway.

**The amateur rules are left unsaid.** The map doesn't say whether a body knockdown counts toward the RSC limit of 3 counts a round and 4 a bout. In amateur boxing most stoppages come by RSC after counts, not by a count-out, so a 35% count-out share fits pro fights better than amateur ones.

**The writing breaks S412.** The defender is always "her" and the attacker "his", and the card's button says "PULL HER OUT". Both need the fighter's own pronoun, or "your boxer" and "the opponent". There are no names outside headers.

**The real-world basis mostly holds.**
- The NHS says broken or bruised ribs usually heal by themselves within 2 to 6 weeks ([NHS: broken or bruised ribs](https://www.nhs.uk/conditions/broken-or-bruised-ribs/), read 2026-11-13). The map's 35–56 days for a crack (the TO SOURCE value) is a fair return-to-sparring figure on top of that.
- A delayed liver fold and a count-out are what Hopkins against De La Hoya (2004) looked like: a left hook to the liver, a beat late, counted out on one knee.
- The map has no sourced rate for body knockdowns. I found none either, so treat that as NOT FOUND.

## Depth: 5/10

**The real decisions:**
- The crack card is a real call. It trades about 4 extra weeks out for a win chance, it's touched by morale, Heart and trust, and it ties into suspension and offer timing.
- The liver fold gives the Aim a payoff on the night, and Durability now does two jobs.

**Where it breaks:**
- Liver beats ribs for tonight in every matchup, so the Aim comes down to one question: do I care about this opponent's next two months?
- The rival payoff needs a living world that isn't established.
- The side cover is undefined.
- The crack card fires rarely: you need 4% per hook, only once a rib is at CRITICAL, only on your own fighter.
- Training and booking hooks ("hunts the liver") are listed but given no numbers.

## General design: 5/10

What it gets right:
- It's clear about what the code does today.
- Rule 1 is drain-neutral at 60/40.
- The menu table wires each label to a rule.
- The build is small and pure.

What pulls it down:
1. The liver is on the wrong side for a southpaw.
2. Side is set by hand, and the game has no rear body punch.
3. Rule 8 makes a crack certain at CRITICAL.
4. Rules 8 and 9 contradict each other.
5. The pull-out price is hidden.
6. The opponent's corner, the side cover, the legs bar and the body stat are undefined.
7. It uses the Power summary stat.
8. It writes a fixed her and his.
9. It sets no probe targets. The Test column names rows but gives no figures to pass.

## Play: 6/10

A delayed fold to the liver is one of boxing's great moments, and "Her liver is hurt" in the corner read gives a round something to build toward. The crack card is a strong rare beat. But the ribs give the player nothing to feel tonight, and most players will rarely see the card.

## The two open questions

**Is "weeks out" enough reason to aim the ribs?** No. Give the ribs a payoff on the night. A boxer hurt on one side drops that elbow, which opens the head on that side (the old line "kill the body and the head will follow"). At HURT, the opponent's guard on that side drops by 5 and her punches from that side by ×0.85. That makes "ribs, then the head" a plan line, and it connects to the head knockdowns already in the game.

**Is 3–8% per hurt hook the right size?** That depends on how many liver hooks land in a hurt round, which the map doesn't measure. The chance of a fold in a hurt round is \(1-(1-p)^n\):

| Landed liver hooks in a hurt round | At 3% | At 8% | At 6% (3% ×2 at CRITICAL) |
|---|---|---|---|
| 3 | 9% | 22% | 17% |
| 5 | 14% | 34% | 27% |

If "two or three liver-hurt rounds should end in a body count" means about 1 in 3 hurt rounds, the 3% base is too low unless 5 or more hooks land. The fix is to tune \(p\) to a measured target, not to pick it by hand.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Aim Liver | ×1.3 drain, and the fold once the liver is HURT | Keep. It's left-hand hooks only. |
| Aim Ribs | ×0.55 drain, the crack chance, weeks out | Keep, once there's a rear body punch and a tonight effect. |
| Cover a side (shout) | Promised, with no rule | Missing as written. Make it Elbows in by side. |
| Pull out (card) | A stoppage loss, 35 days plus the offer delay | Keep, with the full price on the card. |
| Fight on (card) | 84 days, ×0.6 and −10 for the rest of the bout | Keep, with a win figure and a worse-crack risk. |
| Opponent's crack corner read | Information only | Keep, and add an opponent-corner rule. |
| Camp body sparring | Bruised ribs from load | Keep, and price it. |
| Scout lines ("hunts the liver") | Information | Keep, once the forecast reads them. |

**Missing:**
- A rear body hook and a right to the body as moves with mastery.
- Defence by side.
- The opponent's corner retiring a boxer with a crack.
- The amateur count rule for body knockdowns.
- An injury rate per 100 bouts to test against.

## To reach 10/10 (most important first)

1. **Fix the anatomy.** The liver is always the defender's right side. `BodyMap` picks the side from the attacker's hand: left-hand hooks reach the liver, right-hand hooks reach the left ribs. The defender's stance only sets cover: lead side 30, rear side 60 (both figures sourced in code or probed).
2. **Add rear-hand body punches.** "Rear body hook" (4b) and "Right to the body" (2b) as moves with mastery and drill cards, plus the book combinations 1-2b-3, 2b-3 and 3b-4b. The Aim then means "favour this hand to the body", so Aim Ribs costs rear-hand energy and reach, which is a fair trade.
3. **Give the ribs a payoff tonight.** At HURT on the rib side, the opponent's guard on that side drops by 5 and her punches from that side by ×0.85. A plan line "when her side is hurt, then the head on that side" is rated Beats it. A crack works as now.
4. **Make the injury rule a roll, then probe it.**
   - CRITICAL at the bell rolls a crack at 25 in 100 (TUNE), not 100.
   - Bruised ribs come from the rib side under 50 only. The liver side is never a weeks-out injury (rule 9 wins).
   - Probe on 400 bouts a cell, with targets: rib injuries at 2–4 per 100 bouts (today about 6% bout injury × the rib share), cracks at most 1 per 100, and body knockdowns at 10–20% of all knockdowns (ESTIMATE, to be set by the owner).
5. **Print the full price on the crack card.**
   - Pull out: "a stoppage loss, back sparring in 35 days, next bout in about 8 weeks, −4 reputation".
   - Fight on: "a win chance of N in 100 from `BoutRead` with the crack, back in 84 days, 1 in 10 worse (another 28 days)".
   - A high-Heart boxer loses 3 morale if pulled; a trust cost applies only when fighting on ends in a stoppage.
   - Write it with the fighter's own pronoun, or "Pull your boxer out".
6. **Add an opponent-corner rule.** The opponent's corner retires a cracked boxer 40 in 100 at each bell, higher when she's losing on the cards. The corner read shows "her corner is talking about stopping it".
7. **Defence by side.** The corner minute's ONE CHANGE gets "Right elbow in (guard the liver)" and "Left elbow in (guard the ribs)": that side's cover +20, the head on that side −10. Measure it again, since liver folds now make it change who wins.
8. **Set the fold to a target.** Measure the liver hooks landed per hurt round, then tune \(p\) so the owner's rate holds. Clamp after the ×2 (so the cap is 8%, or state 16%). The power comes from Strength, Explosiveness and the move's mastery, not Power.
9. **Follow the amateur rules.** A body knockdown is a count of 8 and counts toward the RSC limit of 3 a round and 4 a bout. The count-out share is 35% at pro, and amateur stoppages go to RSC. The legs effect is written as the energy ceiling −25 for the round (an existing meter) until a legs bar exists.
10. **Wire the rest or cut it.** Scout lines come from the opponent's real body-shot share. "A rival out injured" ships only when NPC injuries exist; until then the ribs' payoff is item 3. Bruised ribs don't block offers but cost −5 energy if she boxes; a crack blocks offers.
11. **Labels.** "Liver (right side)" and "Ribs (left side)" on Aim. Tooltips give the numbers ("each landed liver shot costs her 1.3 stamina"), with pronouns per fighter.

## The 10/10 page at 1920×1080 (Fight night, corner minute after round 2, dark and tight)

- **Header strip, 88 px:** both boxers' names once, the round, the score read, the corner's clock.
- **Left column, 560 px: YOUR BOXER.** A body silhouette with six places as marker rings, the liver and ribs coloured by band, "cracked" stamped on the rib side when it happens. Below it, energy and the energy ceiling, and the RSC counts so far.
- **Centre, 800 px: THE CARD.** When there's a crack, two cream cards side by side: Pull out (loss, 35 days, next bout about 8 weeks, −4 reputation) and Fight on (win N in 100, 84 days, 1 in 10 worse). Neither is pre-selected, and both sit behind the divider. Without a crack, the usual corner minute with the side elbow fixes.
- **Right column, 560 px: THE OPPONENT.** Her silhouette and bands, the corner read in handwriting ("liver hurt", "guarding the left side"), and the Aim set as Liver / Ribs / Head with each effect line and the fold or crack chance this round.
- **Bottom strip, 120 px:** your coach's note (one reason, no names), Say nothing, and the bell button.
