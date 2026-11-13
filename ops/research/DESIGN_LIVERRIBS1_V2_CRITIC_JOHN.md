# LIVERRIBS1_V2 - score this mechanic's DESIGN (S459 design loop)

You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design map
at the end. Judge the MECHANIC, not the look of any screen.

Score, each out of 10, with the reasons:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
3. PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
The bar (owner S459): the mechanic is DESIGNED when critics give it 6+ on DEPTH and 6+ on GENERAL DESIGN.

Also answer: which options are missing, which are useless, and what each option changes (owner S403).
End with **To reach 10/10**: the concrete changes that would take it to 10, most important first, each specific enough to
build (owner S405). Then describe your 10/10 as a 1920x1080 page (an HTML file is welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent"). Real-world boxing evidence where it helps.

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

# DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ85)

Brief: research/DESIGN_LIVERRIBS1_V2_REVISE_KALLI.md
Sent: 2026-11-14 00:11 | collected: 2026-11-14 00:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# LIVERRIBS1 v2: the liver and the ribs do different things (design map, round 2, S460)

Part 1 of 3

**Quoted owner rules carried in this map:**
- **Q-S294-219 (S460 board):** `"Yes: liver = stamina drain + a knockdown chance when hurt, ribs = the injury place (cracked rib, weeks out). Design map + critics first."`
- **S448 (names only in headers):** a person's name sits in the screen or card header once; options, buttons, rows, lines and tooltips say `your boxer`, `the opponent`, `your coach`, or use no fixed pronoun.
- **S412 (sandbox):** the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never use a fixed `he` or `she` in text or mockups.
- **S425 (menu wiring):** keep the map's table of every menu the mechanic appears on and what each is wired to.
- **S459 (bar & mirrors):** must clear 6+ DEPTH and 6+ GENERAL DESIGN with fresh critics; mirror every fight lever in `BoutRead`; mark which numbers are **ESTIMATE**; stay buildable from what the game has.
- **Section 7 rulings:** only actionable information; plain words, one word per concept; hover explains every number; corner retirement cards sit behind a divider and are never pre-selected.

**Marks:** **CODE** = in the code today (file and symbol named). **ESTIMATE** = ours, verified by `LIVERPROBE1` (section 7) before shipping. **NEW** = rule or move added by this map. **[R]** = real-world source (NHS / boxing rules).

**Source status note:** Written from the S403 critic pack (with S409, S410, S448, S451 additions), LIVERRIBS1 v1, Dola's critic return (`SQ77`), and John's critic return (`SQ78`). `CRITIC_ACCESS.md` and the Miro board were not opened directly.

---

## 0. Answer to every critic point (`To reach 10/10`, Dola SQ77 & John SQ78)

| Critic & point | Change in v2 (or one-line reason why not) |
|---|---|
| **John #1:** Fix anatomy (`BodyMap` put liver on left for southpaws; source cover 30/60) | **Done (2, 3.1).** Liver is always the defender's **right side** (`BodyMap.SIDE_RIGHT`); ribs/spleen are always the defender's **left side** (`BodyMap.SIDE_LEFT`). Attacker's hand sets the side hit; defender's stance sets base cover: lead side `30%`, rear side `60%` (**ESTIMATE**, probed in `LIVERPROBE1`). |
| **John #2:** Add rear-hand body punches (`4b`, `2b`) + combos (`1-2b-3`, `2b-3`, `3b-4b`) | **Done (2).** Added `Rear body hook (4b)` and `Rear straight to the body (2b)` as moves with mastery/drill cards, plus book combinations `1-2b-3`, `2b-3`, `3b-4b`. `Aim Liver` / `Aim Ribs` favours the hand that reaches that side, trading rear-hand reach/energy vs lead speed. |
| **John #3:** Give ribs a payoff tonight (`HURT` drops guard -5 & output x0.85; Playbook line) | **Done (3.6, 5).** At `HURT` (`<=55`) on the left ribs, the defender drops that elbow: left-side head guard **-5** and left-hand punches **x0.85** (**ESTIMATE**). Playbook line `"When opponent's ribs are hurt -> Attack the head"` rates `Beats it`. |
| **John #4:** Injury rule as roll (25% crack at CRITICAL at bell, bruise <50 only, liver never; probe 400 bouts/cell) | **Done (3.8–3.10, 7).** `CRITICAL` on left ribs at final bell rolls crack at **25 in 100** (**ESTIMATE**), not 100%. Bruised ribs trigger only on left ribs `< 50` (removed `"any rib at HURT"`). Liver never causes a weeks-out injury. Added `LIVERPROBE1` targets: `2–4` rib injuries/100 bouts, `<=1` crack/100, `10–20%` body KDs. |
| **John #5:** Print full price on crack card; neutral pronouns; Heart/trust rules | **Done (4.1).** All three corner choices print exact prices (`30-day suspension`, `STOP_REST_WEEKS`, `-4` rep, `-2` members, `-12` morale, `BoutRead` win chance, days out, `1 in 10` worse). High-Heart boxer loses `-3` morale on Pull out; `-2` trust fires only if fighting on ends in stoppage (**ESTIMATE**). Zero fixed `he`/`she`. |
| **John #6:** Opponent-corner retirement rule (40 in 100 at each bell, higher if behind) | **Done (3.7).** Opponent's corner retires a cracked boxer **40 in 100** at each bell (**65 in 100** if behind on scorecards, **ESTIMATE**). Corner read prints `"Opponent's corner is talking about stopping it"`. |
| **John #7:** Defence by side (`Right elbow in` / `Left elbow in` in corner `ONE CHANGE`) | **Done (4.2).** Replaced unbuilt `"Cover up"` shout promise with corner `ONE CHANGE` options **`Right elbow in (guard liver)`** and **`Left elbow in (guard ribs)`**: `+20` side cover, `-10` head guard on that side (**ESTIMATE**). Probed again in `LIVERPROBE1` because body KDs/drops change who wins. |
| **John #8:** Tune fold `p` to target; clamp after x2; use `Strength` + `Explosiveness` + mastery | **Done (3.2).** `attack_power` reads `Attrs.gd` `Strength`, `Explosiveness`, and the landed body move's mastery (no `Power` summary stat). `CRITICAL` doubles `p`, clamped at **16%** max (`1–8%` base at `HURT`, **ESTIMATE**). `LIVERPROBE1` measures hooks landed per hurt round and tunes `BASE_FOLD` to owner's body-KD target. |
| **John #9:** Amateur rules (8-count, RSC 3/4 limit; 35% count-out pro only; energy ceiling -25) | **Done (3.3).** Body knockdown is an 8-count and counts toward amateur RSC (`3` in round, `4` in bout, **CODE**). Pro fights use `35%` count-out share (**ESTIMATE**); amateur body stoppages record as `RSC`. Drop unbuilt `"legs bar"`: use existing `FightMeters` **energy ceiling -25** for the round. |
| **John #10:** Wire scout lines & bruised/cracked offer rules; gate NPC rival calendar | **Done (5, 6, 9).** Scout lines (`"Hunts the liver"` / `"Breaks ribs"`) derive from opponent's real body-shot share. Bruised ribs allow offers (`-5` energy if boxing bruised, **ESTIMATE**); cracked rib blocks offers. Rival missed-bout news is **gated behind living-world NPC injuries (`AGREED, NOT BUILT`)**. |
| **John #11:** Clear Aim labels & numeric tooltips | **Done (6).** Aim buttons read **`Liver (right side)`** and **`Ribs (left side)`** with numeric tooltips (`"Each landed liver shot costs 1.3x body stamina; hurt: fold chance"`). |
| **Dola #1:** AI adapts target after 2 rounds of heavy cover | **Done (4.3).** When one side's cover (`Right/Left elbow in` or high stance cover) blocks most shots over **2 rounds**, `OpponentAI` shifts aim to the other side; corner read prints `"Opponent is targeting your other side now"`. |
| **Dola #2:** Injury risk band on bout offer (`BoutRead`) | **Done (5, 6).** Bout offer / Full report scouting notes show `"Body threat: [Low / Moderate / High] rib injury risk"` from opponent's body-shot share + `Strength`/`Explosiveness` (**NEW**, no exact %). |
| **Dola #3:** Three corner options on crack card (`Pull out`, `Defend only`, `Fight through`) | **Done (4.1).** Added **`Defend the side`**: `0` punches from cracked side, `-4` guard on that side, normal power on good side, heals **63 days** (**ESTIMATE**). All three print `BoutRead` win odds and full consequences. |
| **Dola #4:** One-click target switch suggestion on corner card | **Done (4.3).** If `CornerRead` flags heavy cover on one side (`2+` rounds) or `HURT` on left ribs, corner card shows a one-click button (`"Switch Aim to Ribs (left side)"` / `"Target the hurt side's head"`). |
| **Dola #5:** Small living-world reactions on opponent crack | **Gated cleanly (6, 9).** `OpponentCalendar` / rival news (`"Out with cracked rib"`) is **not built in code today (`AGREED, NOT BUILT`)**, so it is wired as a gated hook behind living-world NPC injuries rather than faked; tonight's payoff stands on its own (guard `-5`/`-10`, output `x0.85`/`x0.6`, `40%` corner retirement). |

*(Also fixed from John's logic check: replaced vague `"her body stat"` with `Attrs.gd` `Durability` + `Stamina`; fixed S412 pronouns everywhere.)*

---

## 1. Today in the code (`S460`) and the change in one line

**Today (CODE):**
- Only `body_hook` (`3b`) reaches the body (`60%` liver side, `40%` other side). `BodyMap.gd:76-83` swaps liver side by defender stance (wrong for southpaws).
- `Exchanges.BODY_COST 1.2` (`Exchanges.gd:35-45`) drains the same stamina on both sides; `FightMeters` caps energy ceiling by `body_taken`.
- `Knockdowns.gd` (`DAMAGE_SCALE`, `KO_DAMAGE`) reads **head** damage only.
- `InjuryRoll.gd` (`BOUT_TYPES`, `RIB_HURT_LINE`) draws one `"Rib injury"` (`weight 10`, `x3` under 35; `21–35` days) identically for both sides.
- `RoundHits.WORDS` already names `"liver"` and `"ribs"`, so the player sees two labels that behave the same.

**The change in one line:**
**LIVER (right side)** wins tonight (faster stamina drain + delayed fold knockdown when `HURT`, never a weeks-out injury); **RIBS (left side)** drop guard/output tonight (`HURT` opens the head, `CRACK` cripples that arm or triggers corner retirement) and cost **2–12 weeks** in recovery after the bell.

---

## 2. Anatomy, punches, and stance cover

### Fixed anatomy (**CODE fix in `BodyMap.gd`**)
- **`BodyMap.SIDE_RIGHT` = Liver:** always the defender's **right side**, orthodox or southpaw.
- **`BodyMap.SIDE_LEFT` = Ribs:** always the defender's **left side** (ribs/spleen), orthodox or southpaw.

### Hand-to-side rule + new rear-hand body punches (**NEW**)
A punch's throwing hand determines which side it hits:
- **Attacker's left hand** hits defender's **right side (Liver)**:
  - Orthodox attacker: `Body hook (3b)` (**CODE**, lead left).
  - Southpaw attacker: `Rear body hook (4b)` / `Rear straight to the body (2b)` (**NEW**, rear left).
- **Attacker's right hand** hits defender's **left side (Ribs)**:
  - Orthodox attacker: `Rear body hook (4b)` / `Rear straight to the body (2b)` (**NEW**, rear right).
  - Southpaw attacker: `Body hook (3b)` (**CODE**, lead right).

**New moves & book combinations (added to `Playbook > Moves / Combos`, `PadWeek` drill cards):**
- **`Rear body hook (4b)`** and **`Rear straight to the body (2b)`** (**NEW**): carry mastery (`New / Raw / Usable 30 / Sharp 60 / Signature 85`). Rear-hand body shots carry **higher energy cost and commitment** than lead `3b` (`ESTIMATE`, probed in `LIVERPROBE1`), giving `Aim Liver` vs `Aim Ribs` a real reach/gas trade in every stance matchup.
- **New book combinations:** `1-2b-3`, `2b-3`, `3b-4b` (**NEW**).

### Base cover by defender stance (**ESTIMATE**, verified in `LIVERPROBE1`)
- **Lead side** = **30%** base cover (left ribs for orthodox; right liver for southpaw).
- **Rear side** = **60%** base cover (right liver for orthodox; left ribs for southpaw).
- **Why both Aims matter:** Against an orthodox defender, `Aim Liver` uses quick left hooks into `60%` rear cover for drain and fold; `Aim Ribs` throws committed right body shots into `30%` lead cover to drop their left guard and open head punches. Against a southpaw, `Liver` sits on their `30%` lead side (exposed to the rear left), while `Aim Ribs` hits their `60%` rear side to take away their rear power hand.

---

## 3. Rules (`CODE` / `NEW` / `ESTIMATE`)

| # | Rule | Numbers (`ESTIMATE` / `TUNE` range) | Real-world basis |
|---|---|---|---|
| 1 | **Stamina drain by side:** landed liver shot costs `BODY_COST × LIVER_DRAIN` scaled by defender `Durability`; rib shot costs `BODY_COST × RIB_DRAIN`. Neutral at 60/40 traffic (`0.6×1.3 + 0.4×0.55 = 1.0`) | `LIVER_DRAIN 1.3` (`1.2–1.5`), `RIB_DRAIN 0.55` (`0.4–0.7`) (**ESTIMATE**) | Liver shot triggers vagal reflex (blood pressure drop); rib shot hurts locally without draining the whole tank |
| 2 | **Liver `HURT` fold:** once defender's right side (Liver) is at `HURT` (`<=55`) or worse (`BodyMap.band`), each landed left-hand body shot rolls a delayed fold. `attack_power` uses `Attrs.gd` `Strength`, `Explosiveness`, and the move's mastery (not `Power`) | `p = clamp(BASE_FOLD × exp((attack_power - defender_durability)/12), 0.01, 0.08)` (**ESTIMATE**, `BASE_FOLD` default `0.03` tuned by `LIVERPROBE1`); `×2` at `CRITICAL` (`<=35`), **capped at 16%**; max `2` per bout | Delayed liver fold; tuned against measured hooks per hurt round to hit `10–20%` body-KD share |
| 3 | **Body knockdown & counts:** body knockdown is an **8-count** and drops defender's `FightMeters` **energy ceiling by −25** for that round (**ESTIMATE**). Counts toward amateur RSC limit (**3 counts/round, 4/bout**, **CODE**). 3D shows a fold, not a fall back | Pro count-out share `35%` (`25–45%`, **ESTIMATE**) vs `15%` head KD; amateur stoppages record as **RSC** | Amateur bouts halt via RSC on counts; pro bouts see more full 10-counts from liver pain |
| 4 | **Fresh liver counter (S437):** stays as `DAMAGE_MAP_S437` row 10 on a landed left-hand body counter | `0.6%` (`×2` on opponent Push, cap `3%`), once per bout (**CODE/S437**) | Timed liver counter |
| 5 | **Ribs `HURT` tonight payoff:** once defender's left ribs reach `HURT` (`<=55`), they drop that elbow to protect the side: left-side head guard **−5** and left-hand punches **×0.85** | Guard `−5` (`3–7`), output `×0.85` (`0.80–0.90`) (**ESTIMATE**) | "Kill the body and the head will follow": protecting sore ribs drops the guard on that side |
| 6 | **Ribs `CRACK` in the bout:** once left ribs are `CRITICAL` (`<=35`), each landed right-hand body shot rolls a crack; on crack, corner read flags holding the side | `4%` (`2–6%`) per landed shot (**ESTIMATE**); unmitigated crack gives left-side punches `×0.6`, left guard `−10` (**ESTIMATE**) | Repeated hooks to already-damaged ribs can crack one mid-fight |
| 7 | **Opponent crack corner rule:** at each bell after an opponent's rib cracks, opponent's corner retires them **40 in 100** (**65 in 100** if trailing on scorecards). Corner read warns before the bell | `40%` base / `65%` behind (**ESTIMATE**) | Corners pull compromised fighters rather than let a cracked rib keep taking shots |
| 8 | **Your boxer cracked (corner card):** between rounds, behind a divider, never pre-selected: **Pull your boxer out** / **Defend the side** / **Fight through** (full prices in 4.1) | Heals: `35` days / `63` days / `84` days (`+28` days `1 in 10`) (**ESTIMATE**, `[R]` NHS 2–6 wks + return-to-sparring) | Real corners choose between retiring, shelling up to survive, or risking a worse break |
| 9 | **Post-bout injury split:** **Liver side never produces a weeks-out injury.** Left ribs only: **Bruised ribs** if left ribs `< 50` without crack; **Cracked rib** if cracked in bout OR **25 in 100** roll at final bell when left ribs are `CRITICAL` | Bruised `10–21` days (sparring locked, pads OK; offers allowed, `−5` energy if fighting bruised); Cracked `35–56` days (offers blocked; no sparring, no pads on left side; roadwork/legs/footwork OK) (**ESTIMATE**) | NHS: bruised/cracked ribs heal in 2–6 weeks; cracked rib adds sparring clearance time |
| 10 | **Training:** body sparring and heavy-bag sessions roll **Bruised ribs** from load (`TRAIN_TYPES` ribs, **CODE**); a cracked rib never occurs in training without sparring | As **CODE** today | Training load bruises, heavy contact fractures |

Part 2 of 3

## 4. Corner card, side defence, and corner adaptation

### 4.1 Your boxer's crack card (between rounds, behind a divider, never pre-selected)
Uses the fighter's dynamic pronoun or `"your boxer"` (zero fixed `he`/`she`, zero names outside the header). Every number comes live from `BoutRead` and `Injuries`:

| Option button | Exact text shown on the card | Mechanical effect |
|---|---|---|
| **Pull your boxer out** | `"Stoppage loss · 30-day suspension · next bout ~8 wks (STOP_REST_WEEKS) · −4 reputation · −2 members · −12 morale · rib heals 35 days"` *(adds `"−3 morale"` if high Heart, **ESTIMATE**)* | Ends bout immediately by retirement (`CODE` stoppage effects + `35` days rib recovery, **ESTIMATE**) |
| **Defend the side** | `"Win chance N in 100 (BoutRead) · 0 punches from cracked side, −4 left guard · heals 63 days"` *(adds `"−2 trust if stopped"`, **ESTIMATE**)* | Good side fights normally; cracked side throws `0` punches; left guard `−4` instead of `−10`; heals `63` days (**ESTIMATE**) |
| **Fight through** | `"Win chance N in 100 (BoutRead) · ×0.6 punches from cracked side, −10 left guard · heals 84 days (1 in 10 worse: +28 days)"` *(adds `"−2 trust if stopped"`, **ESTIMATE**)* | Cracked side punches `×0.6`; left guard `−10`; heals `84` days with `10%` risk of `+28` extra days (**ESTIMATE**) |

### 4.2 Side defence in the corner minute (`ONE CHANGE`, **NEW**)
Replaces the unbuilt `"Cover up"` shout idea. Corner minute `ONE CHANGE` adds two explicit side-guard fixes beside the existing `Elbows in` / `Gloves high` / habit fixes:
- **`Right elbow in (guard liver)`:** right-side (Liver) cover **+20**, right-side head guard **−10** (**ESTIMATE**).
- **`Left elbow in (guard ribs)`:** left-side (Ribs) cover **+20**, left-side head guard **−10** (**ESTIMATE**).
- **Shout bar:** existing `Tie up` continues to cut body punches overall; `Aim` controls offensive side (`Liver (right side)` vs `Ribs (left side)`).

### 4.3 Opponent AI adaptation & corner switch button (**NEW**)
- **Opponent AI switches target:** if `your boxer` heavily covers one side (e.g. via `Right/Left elbow in` or high cover blocking most shots over **2 consecutive rounds**), `OpponentAI` shifts its body aim to the open side (`ESTIMATE`). `CornerRead` prints: `"The opponent is targeting your other side now"`.
- **Corner one-click switch button:** between rounds, if `CornerRead` detects the opponent overworking one side (`2+` rounds) or sees opponent's left ribs at `HURT` (`<=55`), the corner card offers a single-click suggestion button: **`"Switch Aim: Ribs (left side)"`** or **`"Target opponent's hurt side (head)"`**.

---

## 5. Depth and choices across the career

- **Booking (`Bout offer` / `Full report`):**
  - Opponent's file (`Scout lines`) reports `"Hunts the liver"` or `"Breaks ribs"` derived from their real left/right body-shot share (**NEW**, replaces invented labels).
  - `BoutRead` prints `"Body threat: [Low / Moderate / High] rib injury risk"` from opponent's body-shot frequency + `Strength` / `Explosiveness` (**NEW**, no exact percentage).
- **Training & Camp:**
  - `Durability` now protects against two distinct threats (liver fold resistance vs rib damage).
  - Players drill `Rear body hook (4b)`, `Rear straight to the body (2b)`, or `3b` depending on whether their fighter hunts liver or ribs and their stance.
  - Camp partner / sparring choices weigh body-shot preparation against `Bruised ribs` load risk.
- **Playbook:**
  - New situational line: `"When opponent's ribs are hurt -> Attack the head"` (rates `Beats it`, exploiting the `−5` left-side head guard from Rule 5).
- **Live round & Corner minute:**
  - **Aim `Liver (right side)`:** drains stamina faster (`×1.3`) and builds to delayed `HURT` fold (`8`-count / RSC / pro KO); leaves no post-bout injury.
  - **Aim `Ribs (left side)`:** lowers target cover against orthodox (`30%`), opens the opponent's left-side head guard (`−5`) and slows their left hand (`×0.85`) at `HURT`, risks mid-bout `CRACK` (`−10` guard, `×0.6` arm, `40–65%` opponent corner retirement), and inflicts `10–56` day injuries after the bout.
  - **Guard choice (`Right elbow in` vs `Left elbow in`):** save tonight's stamina & fold risk vs save the next 5–12 weeks on the calendar, while trading `-10` head guard on that side and forcing reads when the AI adapts.

---

## 6. Every menu it appears on, what each is wired to, and tests (`S425`)

| Menu | What the player sees / acts on (names in headers only; no fixed `he`/`she`) | Wired to | Test / Probe bar |
|---|---|---|---|
| **Live round: side holos** | `"Liver (right)"` and `"Ribs (left)"` hit/band counts; numeric hover tooltips: `"Each landed liver shot costs 1.3× body stamina; hurt: fold chance"` / `"Hurt: drops left guard −5; critical: can crack, weeks out"` | `BodyLive` + `LiverRibs` (pure) | `holo_live_test`: orthodox & southpaw both map Liver -> `SIDE_RIGHT` |
| **Live round: AIM buttons** | **`Liver (right side)`** / **`Ribs (left side)`** (replacing `"Right/Left ribs"`); effect lines match Rule 1/2/5/6 | `PaceAim` + `Exchanges` (`3b` vs `4b/2b` hand routing) | `pace_aim_test`: orthodox & southpaw aim routes to correct hand & side |
| **Live round: corner read** | `"Opponent's liver is hurt"`; `"Opponent is guarding the left side (head −5)"`; `"Opponent is holding the left side"`; `"Opponent's corner is talking about stopping it"`; `"Opponent is targeting your other side now"` | `CornerRead` + `OpponentAI` | `corner_read_test`: reads fire at `HURT`, `CRACK`, and 2-round AI switch |
| **Live round: knockdown** | 3D fold animation + 8-count; `"Body knockdown (liver)"`; `FightMeters` energy ceiling `−25` for round; amateur RSC counter increments | `Knockdowns` body path + `KnockdownCount` + `FightMeters` | `knockdown_rates_test`: amateur stops by RSC at 3/4 counts; pro 35% count-out |
| **Between rounds: corner minute & crack card** | Side elbow fixes (`Right elbow in` / `Left elbow in`); one-click Aim switch button; behind divider, never pre-selected **CRACK CARD**: `Pull your boxer out` / `Defend the side` / `Fight through` with full prices | `CornerJobs` + `BoutRead` + `Injuries` | `corner_crack_golden_test`: 3 buttons un-selected, full prices match `BoutRead` & `STOP_REST_WEEKS` |
| **Bout offer / Full report (`BoutRead`)** | `"Body threat: [Low/Moderate/High] rib injury risk"`; Aim lever mirrored in `BoutRead` simulation; scout lines `"Hunts the liver"` / `"Breaks ribs"` | `BoutRead` + `Scout` | `bout_read_test`: Aim liver vs Aim ribs produces measurable delta in `BoutRead` |
| **Playbook (`Moves` & `Combos` & `Game plan`)** | `Rear body hook (4b)` & `Rear straight to the body (2b)` drill cards; combos `1-2b-3`, `2b-3`, `3b-4b`; new situation `"When opponent's ribs are hurt"` | `MovesBook` + `PadWeek` + `GamePlan` | `playbook_body_moves_test`: `4b`/`2b` learn & fire in `Exchanges` |
| **Fight result page** | `"Body knockdown (liver), round 2"`; `"Cracked rib (left), fit Mon 2 Mar"` or `"Bruised ribs (left), fit Mon 2 Feb"` | `Aftermath` + `Injuries.line` | `result_defects_test`: liver never prints weeks-out injury |
| **Home: needs & news** | Injury card with weeks out; fought-on note (`"Fought through cracked rib: 12 weeks"`); bruised warning (`"−5 energy if booked while bruised"`) | `Injuries.after_bout` + `HomeNeeds` | `injuries_test`: `2–4` rib injuries/100 bouts, `<=1` crack/100 in probe |
| **Fighter > Week** | Bruised: sparring locked, pads OK; Cracked: `"No sparring or left-side pads until Mon 2 Mar"` (roadwork/footwork OK) | `PadWeek` + `StandDown` locks | `pad_week_test`: cracked blocks offers & left-side pads; bruised allows offers at `-5` energy |
| **World > News / Region *(GATED)*** | *Only once living-world NPC injuries (`AGREED, NOT BUILT`) ship:* `"Opponent out with cracked rib — pulls from regional show"` | `Region` / `OpponentCalendar` *(gated flag)* | Inactive until living-world NPC injury calendar lands |

Part 3 of 3

## 7. Build tasks, `LIVERPROBE1` bars, and Golden Path

### Build tasks (after critics hit 6+ / 6+ and owner approves board)
1. **Fix `BodyMap.gd` anatomy (`SIDE_RIGHT` = Liver always, `SIDE_LEFT` = Ribs always) + add `Rear body hook (4b)`, `Rear straight to body (2b)` and combos `1-2b-3`, `2b-3`, `3b-4b`.** (Qwen)
2. **`LiverRibs.gd` (pure):** `drain(side)`, `liver_fold_chance(strength, explosiveness, mastery, durability, band)`, `ribs_hurt_penalty(band)`, `crack_chance(band)`, `bell_crack_roll(left_rib_value)`, `opponent_corner_retire(crack, score_diff)`, `injury_split(left_rib_value, cracked, choice)` + unit tests. (Qwen)
3. **`LIVERPROBE1` (pure, cloud, 400 bouts per cell):** tune `BASE_FOLD`, rear-hand `4b/2b` gas/reach cost, and `Right/Left elbow in` cover/head-open values against Section 7 bars. (Goose)
4. **Wire combat, corner, & injury systems:** `Exchanges` (hand-to-side + drain + `HURT` guard `-5`/output `×0.85` + `OpponentAI` 2-round switch), `Knockdowns` (body 8-count + `-25` energy ceiling + RSC count), `BodyLive` / `CornerJobs` (3-choice crack card behind divider + side elbow fixes + Aim switch button), `InjuryRoll` (bruised `<50` / cracked 25% roll + `35/63/84` days), `BoutRead` (mirror Aim + `injury_risk_band`), `Scout` lines. (Claude / Cursor)
5. **Golden path test (`tests/liver_ribs_golden_test.gd`):** aim `Liver (right side)` -> verify `1.3×` drain, `HURT` fold 8-count, `-25` energy ceiling, zero post-bout liver injury; aim `Ribs (left side)` -> verify `HURT` `-5` guard / `×0.85` output, `CRACK` card with 3 un-selected full-priced buttons (`35 / 63 / 84` days), and `Fighter > Week` lock enforcement. (Grok Dev)

### `LIVERPROBE1` probe bars (400 bouts per cell, run before UI ships any `ESTIMATE`)
- **Rib injury rate:** **2–4 per 100 bouts** overall; **cracked ribs <= 1 per 100 bouts** (**ESTIMATE**, matching today's ~6% total bout injury × rib share).
- **Body knockdown share:** **10–20% of all knockdowns** (**ESTIMATE**, `BASE_FOLD` tuned from measured hurt-round hooks to hit owner's target).
- **No dominant Aim:** across `(orthodox balanced, orthodox pocket, southpaw, high-guard)`, `Aim Liver` and `Aim Ribs` each win the highest expected edge in at least one matchup (never >75% one-sided).
- **Side elbow fixes:** `Right elbow in` vs `Left elbow in` measurably shift win chance when facing a liver hunter vs rib breaker without dominating head-hunting matchups (`-10` head guard cost bites).
- **Season stability:** average career layoff days from body injuries stay within **+10%** of today's baseline.

---

## 8. The 10/10 page at 1920×1080 (`Fight night`, corner minute after round 2, dark and tight)

*(Names sit once in the two corner headers; zero names and zero fixed `he`/`she` anywhere else.)*

- **Header strip (88 px):** dark fight-night bar — your boxer's name (left header) vs opponent's name (right header), round `2 of 3` (or pro rounds), live scorecard read, 60-second corner clock.
- **Left column (560 px) — `YOUR BOXER`:**
  - Body silhouette with 6 hit zones as marker rings; **Liver (right)** and **Ribs (left)** coloured by damage band (`Fine / Hurt / Critical`), `"CRACKED"` stamped over left ribs when triggered.
  - Existing `FightMeters` below: current energy & energy ceiling (showing `-25` round drop if folded), plus amateur RSC count tally (`1 of 3 this round / 1 of 4 bout`).
- **Centre column (800 px) — `CORNER MINUTE`:**
  - *When your boxer has a cracked rib (behind a divider, never pre-selected):* three cream cards side by side — **`Pull your boxer out`** (`Stoppage loss · 30-day suspension · ~8 wks · −4 rep · −2 members · −12 morale · 35 days`), **`Defend the side`** (`Win N in 100 · 0 left punches · −4 left guard · 63 days`), **`Fight through`** (`Win N in 100 · ×0.6 left punches · −10 left guard · 84 days, 1 in 10 +28d`).
  - *Standard corner minute (no crack):* handwritten coach card, `RECOVER` (3 points), `SET-UP`, `TALK`, and `ONE CHANGE` featuring **`Right elbow in (guard liver)`** / **`Left elbow in (guard ribs)`** (`+20 side cover / −10 head guard`) + one-click **`Switch Aim`** suggestion chip when triggered by `CornerRead`.
- **Right column (560 px) — `THE OPPONENT`:**
  - Opponent silhouette with Liver (right) and Ribs (left) bands.
  - Handwritten `CornerRead` log (`"Left ribs hurt — head guard −5"`, `"Targeting your other side now"`, `"Corner talking about stopping it"`).
  - Live `Aim` selector (**`Liver (right side)`** / **`Ribs (left side)`** / `Head`) with numeric hover tooltips and this round's fold/crack threat indicator.
- **Bottom strip (120 px):** your coach's handwritten one-line note (no names, no fixed pronoun), `Say nothing / No fix`, and the single round-bell button.

---

## 9. Rejected / gated items and risks

- **Rejected / replaced:**
  - `"Cover up"` generic shout -> replaced by `Right elbow in` / `Left elbow in` in corner `ONE CHANGE`.
  - Unbuilt `"legs bar"` -> replaced by existing `FightMeters` energy ceiling (`-25` for the round).
  - Deterministic crack at `CRITICAL` -> replaced by `25 in 100` roll at final bell.
  - Summary `Power` stat in fold formula -> replaced by `Strength` + `Explosiveness` + move mastery.
- **Gated on unbuilt systems:**
  - `World > News` / `OpponentCalendar` (`"Rival out with cracked rib"`) stays inactive behind living-world NPC injuries (`AGREED, NOT BUILT`).
- **Risks, said plainly:**
  - Adding `Rear body hook (4b)` and `Rear straight to body (2b)` requires 2 move definitions + 3 book combo entries + pad drill animation mapping (`Playbook`), though `StrikeMap` / `Exchanges` already support arbitrary move entries.
  - If `LIVERPROBE1` shows rear-hand body shots land too easily at `30%` lead cover, rear-hand reach/energy penalties must carry the balance so `Aim Ribs` does not become free head damage.
  - All `ESTIMATE` numbers (`1.3`/`0.55` drain, `BASE_FOLD`, `25%` bell crack, `35/63/84` days, `40%` opponent retirement, `+20/−10` elbow fixes) remain provisional until `LIVERPROBE1` passes.

**CHECKs:**
- **CHECK (Claude):** verify `PadWeek` / move book slots for adding `4b` and `2b` and confirm `Exchanges.gd` accesses `Strength` + `Explosiveness` + mastery per move rather than `Attrs` summary `Power`.
- **CHECK (John):** confirm owner's target body-KD share (`10–20%` of all knockdowns vs `"2–3 hurt rounds a season"`).
