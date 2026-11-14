# FIGHT WEEK SCREEN v1 - score this SCREEN (S474)

You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design
map (what the fight week mechanic is), then the screen: a 1920x1080 mockup given as its HTML source at the end (render it
in your head or in a browser; every number on it is an example).

Score, each out of 10, with the reasons:
1. CLARITY - can a player read in 10 seconds what each choice costs and gives, and what fight night will look like?
2. COMPLETENESS - does the screen carry every choice and number the map puts on it (map section 10, "Fight week screen"
   row, and section 9 ON FIGHT NIGHT)? Name anything missing, and anything on it that is useless (owner S403, S398:
   "unless the player can really do something about it").
3. PLAY - does setting a fight week here feel like a decision worth making every bout?
Owner rules for screens: names only in the header, never in rows or buttons (S448); game words, not jargon (S422); one
pulsing critical button a screen; hover labels for secondary detail (S442).

End with To reach 10/10: the concrete changes that would take it to 10, most important first, each specific enough to
build. Then describe your 10/10 as a 1920x1080 page (an HTML file is welcome).

---
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
  over usable, Signature +2.7 over sharp). BUILT for professional bouts (S458-S462, `ProRead`): the opponent's corner studies your boxer's
  last two professional fights and waits for the punch thrown most; two real weapons or a feint line blunt it. Amateur bouts: not read across bouts.
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
- BUILT (`PlanRead`): inside a round the opponent adjusts - a planned line pays in full for its first 2 uses in that round, then less each use; it resets
  at the bell. AGREED, NOT BUILT: their note replaces the coach's line in the corner minute naming the line that stopped working.

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
  tie up, roll out. BUILT since S463 (`StepMastery`): each of the 10 has its own mastery bar, given at signing from Footwork; a step fires by its
  bar like a punch (under Usable 30 the coach never plans it and it mostly fails). Training a step (S463, greybox): the fighter page's WHAT TO LEARN NEXT card puts ONE step or defence in the study slot; the week's pad nights raise
  it about 6 a week (step back 0 to 32 in about 5 weeks); at Usable 30 it leaves the slot. One slot only. NOT BUILT: nothing takes a step past 30
  (to Sharp 60), sparring gives a step nothing, and two steps cannot be learned at once.
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

---
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

--- THE MAP ---
# AMATEURWEEK1 v8: the amateur fight week (S459)

Part 1 of 3

v8 is a full map. It replaces v7 (S459, seat SQ73), and nothing outside this page stands.

**Critics on v7:**
- John SQ80: Depth 6, General design 5, Play 6.
- Dola SQ79: Depth 8, General design 8, Play 7.

John's eight build faults decide this version:
1. The tank cap still makes tired boxers pay nothing.
2. Eat less has no tank number.
3. The weight rule mixes a class limit with a weight gap.
4. Fall-throughs land after the bout, and the cottage refunds a stay that already happened.
5. A plan test followed by a change loops back to unsparred.
6. The player can't pick who takes a shared slot.
7. The fundraiser and film have loose edges.
8. Pack changes are missing from the build list.

**Number marks:**
- **MEASURED:** from a probe already run.
- **GAME:** in the code or the pack today.
- **ESTIMATE:** ours, measured before build (section 12).
- **NEW:** a rule this map adds.
- **[R]:** a real-world source.

**Owner rules kept, quoted:**
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". A name appears once, in the screen header. Everywhere else the text says the boxer, the opponent, your assistant or the head coach.
- **S412 SANDBOX:** "the player runs any gym with any boxers, men or women". There is no fixed he or she.
- Females never fight males, and slots are by sex and class.
- **Section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- "Gym" is the facility and "camp" is pre-bout preparation only. Amateur bouts have no camp, so this screen is the FIGHT WEEK.
- **S455:** the art stays consistent; the screen is Look B, the gym whiteboard. Everything new ships switched ON.

**Words:**
- Say "under 4 wins", never "novice".
- Classes are always in kg.
- Stats on this screen use the Attrs names (the 14 abilities).
- The old seven (Power and the rest) appear only as the profile summary.

## 0. Every critic point, answered

**John SQ80, To reach 10/10:**

| # | Point | What v8 does (or why not, in one line) |
|---|---|---|
| J1 | Tank cap exploit | **Done (4.2).** The tank has two layers: tiredness over 50 is capped at 25, and choices subtract after it, uncapped. At start tiredness 75, Train through costs 25 + 12 = 37 off. |
| J2 | Eat less number; FLAT at 65+; Rest up timing | **Done (4.3, 4.5).** Eat less costs 4 off the tank (ESTIMATE). Rest up at 65+ reads "Sharp, no boost". Rest up brings tiredness to 30 before the bell. |
| J3 | Weight rule | **Done (4.5).** Club shows weigh in on bout day, 1 hour before, and match inside a gap table [R] EB 7.1.3 / 2.7.8. The class sets the slot and the ladder, not a cut line. Championships keep the class limit the day before. |
| J4 | Fall-through timing; cottage refund | **Done (6).** The pull-out roll fires on the Monday of fight week, 5 days out, before Saturday. The cottage gives no refund and is allowed only for championship rounds. |
| J5 | Plan test loop; which two lines; one-boxer club; late sparring price | **Done (4.4).** A changed line goes back to UNSPARRED, and the screen says so before the change. The player picks the two lines. A one-boxer club spars a club member. Sparring 5 or fewer days out costs 5 off the tank and ×2.5 injury. |
| J6 | Pick the boxer for a shared slot | **Done (2).** The slot defaults to the longer wait, with a Swap button. |
| J7 | Fundraiser and film edges | **Done (5).** The fundraiser is cut from this map; it belongs to Club > Money and changes no fight week. Film is locked on a debutant. A second film night either raises SEEN 70 to 90 or opens the next group. "Drops a level" now reads "cleared as false". |
| J8 | Pack changes listed; savings vs stipend; layout | **Done (11, 12).** Matchmaking lead time and Set camp are listed. Savings grow only while the stipend is Off. Back to the coach's week is gone. Controls are called magnets and pills. The WEEK BEFORE strip gets its own row. |

**Dola SQ79, To reach 10/10:**

| # | Point | What v8 does (or why not, in one line) |
|---|---|---|
| D1 | Run every probe; fall back to two stops | **Done (12).** No ESTIMATE prints before its probe. The two-stop fallback stays. |
| D2 | Build the missing systems first | **Done (12, step 2).** BoutSheet, RegionShows, the WeekPhase amateur branch, Savings, the Nationals next-year state, and the home-show weigh-in. |
| D3 | Ask for a fight panel | **Not in this map.** The panel is agreed and waits on bot test R37; the sheet keeps its space (2). |
| D4 | Plan readiness row | **Done (9).** One line at the top of ON FIGHT NIGHT: "n ready, n UNSPARRED". |
| D5 | Next-best hover | **Done (4.3).** Hovering a stop shows the next stop's price and what it buys. It never says "best". |
| D6 | Lock weight / lock load toggle | **Not taken.** Load and weight are already separate controls that don't move each other, so a lock adds a button with nothing to lock. |
| D7 | Season at a glance | **Done through what's built.** The Office desktop already shows the next four weeks; the header links to it. |
| D8 | Source the pull-out rate | **Done (6).** John sourced 25–50% [R]; 35 in 100 sits inside that range. |

**Dola's missing options:**
- **A search for a short-notice bout:** this is the fall-through card's "Take the replacement", since the host offers the name.
- **A rest window per bout:** the window is already per boxer, on that boxer's Fights tab.
- **A calendar several weeks ahead:** this is the Office desktop.

## 1. The idea

An amateur bout is booked 1 to 3 weeks out and has no camp. The FIGHT WEEK SCREEN covers the bout's last two weeks:
- **2+ weeks out:** a WEEK BEFORE strip (trip and sparring night) sits on its own row above the fight week.
- **1 week out:** fight week only.
- **3 weeks out:** week 1 is a normal BUILD week on the week board.

For an amateur bout the WEEK BEFORE strip replaces PEAK; that week runs as BUILD plus whatever the strip sets. The fight week replaces TAPER and is set by the load stop. This needs a WeekPhase amateur branch (NEW). CHECK (Claude): today WeekPhase gives PEAK to a 2-week amateur bout.

Every choice lands on ON FIGHT NIGHT, which has three rows: TONIGHT, BANKED and SEASON.

## 2. The bout sheet

**SLOTS BY CLASS:**
- A show offers 8 to 12 bouts as slots by sex and class.
- When two of the club's boxers share a kg class, the slot defaults to the one who has waited longer since their last bout.
- A **Swap** button gives the slot to the other boxer. That boxer's card says "this slot went to your other 65 kg boxer" (NEW).
- A sheet shows up to three cards. Slot test target: 2+ cards on average.

**PASS:**
- Passing a whole sheet is free.
- Refusing a card a club offered by name counts against that club; two refusals in 8 weeks lock that club out for 8 weeks.
- Each named card shows "refused n of 2".

**REMATCH:** when a boxer met before is on a sheet, the card is marked REMATCH and the tells found last time come back at SEEN.

**ASK FOR A NAMED OPPONENT:** agreed, and waits on R37. The sheet keeps space under the cards.

**LEAD TIME (NEW):**
- Amateur offers land 1 to 3 weeks out, not the pack's 8–12 weeks (Matchmaking change, listed in 12).
- Set camp never appears for amateur bouts.

**THE REST WINDOW:**
- Set on the boxer page's Fights tab: "next bout no sooner than 3 / 5 / 8 weeks", default 3.
- It replaces the fixed 21 days after a points bout.
- It can't be set shorter than the 30-day suspension or `Matchmaking.STOP_REST_WEEKS` (both GAME, both kept).

**RING RUST:** 6 weeks READY without a bout puts the boxer FLAT in round 1, counted from the end of any suspension.

**HOME AND AWAY:**
- **Home:** the $450 ticket cut, +8 members, +5 reputation (GAME).
- **Away:** a chance at a ranked place, plus the opponent's facts on file.
- The loss-below rule ("a loss to a name below drops two places") stays on the owner's board. Until a yes, an away loss costs only the record.

**THE NATIONALS:**
- Entry needs 5 bouts in the last 12 months and 3 months registered.
- Cards show "bouts to entry n of 5" and the entry week.
- In year 1, when week 10 can't be reached, the card says "next entry: week 10, next year".
- The sheet is closed during a run, with the reason.
- The next-year state is NEW.

**YOUR ASSISTANT PICKS THE BOUT:**
- A rank goal picks away; a money goal picks home.
- A rank goal under 4 wins is greyed: "no table under 4 wins".
- New FighterGoal types (NEW):
  - "Climb to top 3 by <date>"
  - "Bring $n to the club this season"
  - "Three bouts before the nationals"

**FAVOURS WITH A HOST (0 to 3):**
- Earned by filling a late gap.
- Spent on Ask for a kilo, or on a re-match after a miss.
- Test target: an average club sits at 1 to 2.

**PRO PACE:** 9 to 11 bouts a season at 61% wins (MEASURED) means about 1.4 seasons to 9 wins. This goes to the owner's board (13).

Part 2 of 3

## 4. The fight week screen

### 4.1 WHERE TO TRAIN (one trip per bout; the card says which week it uses)

Food for two costs $120 a week [R] John S449, and extras $50.

| Trip | Week | Cost | What it does (shown on TONIGHT) | Price beyond cash |
|---|---|---|---|---|
| Home gym | either | free | nothing extra | none |
| City club, commute with your assistant | week before **or** fight week | $150 + $120 food | a partner in the opponent's style: round-1 edge +1.0 against that style (ESTIMATE, about 1 to 1.5 in 100) | injury ×1.15 that week (ESTIMATE); assistant away by day, and the evening class still runs |
| City club, the boxer goes alone | week before **or** fight week | $150 + $60 food | half the edge (+0.5) | +1 tiredness a travel day (ESTIMATE); no coach away |
| Hill cottage | week before, **championship rounds only** (regional and national draws) | $745 off-season / $1,170 June to August [R] | the week before banks in full with no TrainingLoad entry, and fight week starts 10 tiredness lower | the coach is away all week; no refund once the stay starts |

- **Why the cottage is championship-only:** at $1,095 to $1,520 with the lost class, it costs 5 to 7 weeks of an early club's profit for a $450 bout. In a championship run a loss ends the run, so the price can be worth it there. CAMPPLACE1 checks this, and if the cottage is never best even there, it's cut.
- **Seaside house:** stays cut, because a free home Rest up week gives the same rest.
- **Partner choice:** not taken, because the opponent's file holds one style word.

**COACH AWAY (a red-edged card, shown only when the trip takes a coach):**
- **Assistant away a full week:** the other boxers train at the head coach's factor (the screen prints the real number) and the evening class stops (−$350, GAME). CHECK (Claude): the coach factor with only the head coach present.
- **Head coach away:** no head-coach edge, and no shouts at any other bout that week.

### 4.2 THE TANK (two layers, NEW, answers J1)

The tank is the energy ceiling at the first bell, and it's built from two layers.

| Layer | Parts | Cap |
|---|---|---|
| Tiredness | 1 off for each point of start tiredness over 50 | 25 |
| Choices (after the tiredness layer, uncapped) | load stop (Tick over 6, Train through 12), each fight-week sparring night (3, or 5 when 5 or fewer days out), Eat less 4 | none |

**Worked at start tiredness 75 (25 over 50):**

| Choice | Tank at the bell |
|---|---|
| Rest up | tiredness to 30 before the bell, so 0 off |
| Tick over | 25 + 6 = 31 off |
| Train through | 25 + 12 = 37 off |
| Train through + two late sparring nights | 25 + 12 + 10 = 47 off |

A tired boxer pays every point of every choice.

**On screen:** the tank bar shows the tiredness layer in grey and the choices stacked in colour after it, each with its price in wins in 100 on hover. Every number in the table above is an ESTIMATE until FIGHTWEEKPROBE4 runs.

### 4.3 THE WEEK'S LOAD (three stops, each best in a state you can read)

| Stop | The week | Tank (choice layer) | Round 1 | Banked | After the bell | Best when (printed on the stop) |
|---|---|---|---|---|---|---|
| Rest up | three rest days | 0; tiredness brought to 30 **before the bell** | under 40 start tiredness: FLAT, −2.0 edge; 40 to 64: FLAT, −1.0; **65+: Sharp, no boost** (ESTIMATE) | a fifth of the week's pad units | nothing extra | start tiredness 65+, or a heavy cut |
| Tick over (default) | one rest day, volume halved [R] John S449 | 6 off | Sharp; ONE chosen plan line fires one level up in rounds 1 and 2 | half the pad units | nothing extra | most weeks under 65 |
| Train through | full week | 12 off | Sharp | the full week's pad units (720 for 3 pad nights, GAME units) on the plan's moves | +6 tiredness; the week enters TrainingLoad's ratio (1.5× spike: injury ×2–4, GAME) | a plan move sits within one week of Usable or Sharp, or the opponent is rated 5+ below |

- **The Tick over line picker** offers only lines at Usable or Sharp.
- **Train through banks mastery** and prints the crossing it buys ("Uppercut 27 to 31: Usable by the bell"). With FireLevel ON (GAME, S450), a move that crosses to Usable fires 1 use in 2 that night.
- **BANKED** shows the Attrs number and the move, never a range ("Strength +0.4": ESTIMATE until the probe).
- **Next-stop hover (D5):** hovering a stop shows the next stop's tank, round-1 and banked lines side by side ("Train through instead: 6 more off, Uppercut reaches Usable, +6 tiredness after"). It names prices, never "best".

### 4.4 SPARRING: the night that gets a plan ready

**THE RULE:**
- A plan line written or changed since the boxer last sparred is UNSPARRED and fires one level down in rounds 1 and 2. Usable drops to Raw, which doesn't fire.
- Before any change after a sparring night, the screen says so: "changing this line makes it UNSPARRED until the next sparring night" (answers J5).

**WHAT A NIGHT DOES:**
- It readies lines and runs a PLAN TEST against a partner of the nearest style.
- The test rates each line (Beats it / Works / Walks into it) before the bell.
- If the player changes a line after the test, that line is UNSPARRED again; a second night readies it, at that night's price.
- Sparring never confirms tells; only the fight does.

**WHICH LINES:**
- An early night readies two lines, which the player picks.
- The default is the first two UNSPARRED lines in plan order.

**ONE-BOXER CLUB (NEW):**
- With no second boxer in the right weight (the first weeks before the second walk-in), the partner is a club member.
- The plan test then rates only "Works / Walks into it", and Beats it shows as "?".
- The night still readies lines.

| Night (0, 1 or 2 placed as magnets) | Price | Readies |
|---|---|---|
| Week before (8+ days out) | one pad night's mastery | two lines |
| Fight week, 7 or 6 days out | 3 off the tank | two lines |
| Fight week, 5 or fewer days out | **5 off the tank, ×2.5 training injury, a cut that ends the bout 3 in 100** (ESTIMATE; NEW, overrides the pack's no-sparring TAPER on purpose and prices it [R] Buglioni, Boxing News 2016) | every line |

**When each choice is right:**
- **No night:** the plan is unchanged since the last sparring.
- **Week before:** there's time.
- **Late night:** the player rewrote the plan after the tape and accepts the risk.

**Your assistant's default:** a week-before night when one exists, else a 7-day night if the choice layer stays under 12, else none.

Sparring test target: worth 2 to 5 wins in 100 when the plan is new (ESTIMATE).

### 4.5 THE WEIGHT (one rule, answers J3)

**AT CLUB SHOWS (every amateur bout outside a championship), NEW, [R] EB 2026 rules 7.1.3 and 2.7.8:**
- The weigh-in is on bout day, 1 hour before boxing. This needs a home-show branch in `Bouts.weigh`, which runs the day before today. CHECK (Claude).
- The two boxers are matched at walking weight within this gap:

| Bout | Gap allowed |
|---|---|
| Classes up to 65 kg (women's 57 / 60 / 65, men's 57.5 / 60) | 2.5 kg |
| Classes above 65 kg (women's 75, men's 70 / 75) | 5 kg |
| Skills bout | 2 kg |

- The gap never reads the game's 10 kg class jumps.
- **The class decides the slot and the ladder table only.** Boxing down a class is a choice to enter that class's table and slots, and the cut is how to get there. A walk-in 2 to 4 kg over the lightest class chooses "box at 60 kg in 3 weeks, or at 65 kg now".

**WAYS TO MAKE THE MATCH:**
- **EAT LESS** (Cut 500 kcal, GAME): 4 off the tank (ESTIMATE).
- **TRAIN IT OFF:** 0.3 kg for +8 tiredness. It beats Eat less only when start tiredness is under about 42 (DERIVED by John).
- **ASK FOR A KILO:** −1 favour with the host, only when the boxer is within 1 kg of the gap's edge. Greyed with the reason otherwise.

**A MISS (outside the gap on the day):**
- The host re-matches on the night if it has a fitting spare, 1 in 3 (ESTIMATE).
- Otherwise the bout is off, the club pays $300, and the host takes 1 favour.
- The $300 is a GAME value, not a rule-book fine.

**CHAMPIONSHIPS (regional and national draws):** the class limit, the day before, as today (GAME). No kilo is asked and no favour is spent.

### 4.6 WHO PAYS

**Savings (NEW):**
- Savings come from the boxer's own job: $25 to $75 a week by background, shown at signing.
- They grow only while the stipend is **Off** on Club > Money. With the stipend On, savings stay where they are (answers J8).

| Payer | Club's cash | Mood (ESTIMATE) | Gate |
|---|---|---|---|
| The club | full | +3; −2 with each other boxer when the club paid for this one more often in the last 8 weeks | none |
| Half each | half | +3 on a win, 0 on a loss | savings cover half |
| The boxer | none | +6 on a win, −6 on a loss; savings under $100 after paying make the boxer SKINT, −2 a week until savings refill | Confidence 55+ and savings cover it; otherwise greyed with the reason |

At 61% wins (MEASURED) that comes to:
- The boxer row: about +1.3 mood.
- Half each: about +1.8.
- The club: +3, less the fairness cost.

BudgetProbe cuts any row that is never best for some boxer.

### 4.7 YOUR ASSISTANT'S PICK

- The pick reads five facts: start tiredness, the weight's tank cost, the opponent's round-1 style, the rating gap, and unsparred lines. It names the one fact that drove it.
- It's wrong at (1 − sureness), where sureness = 0.5 + rating / 200 (Luke Reid 0.79, Marcus Hale 0.87; GAME ratings). When wrong, it takes the next stop and still gives its reason.
- The card says "your assistant" beside the portrait and names no one.

### 4.8 SEASON, the price line

- SEASON shows each stop's measured season cost against Tick over, for the boxer's start-tiredness band only ("Rest up here: −1 to +2 in 100").
- The rating gap, the weight, unsparred lines and moves near a tier stay out of the line, so SEASON never prints the answer.
- The numbers print only from FIGHTWEEKPROBE4.

Part 3 of 3

## 5. The film evening

**What a night does:**
- A film night costs one pad night and opens one tell group.
- A tell is checked at the first corner minute where the opponent's mode matched it.
- A fade or a slow start is checked at the round-2 minute, because amateur bouts have minutes only after rounds 1 and 2.

**LOCKED ON A DEBUTANT (NEW):** when the opponent has no bouts, the film magnet is greyed: "no tape on a debutant" (GAME: no bouts means no tape).

**TRUTH:** a SEEN tell is true 70 in 100 (ESTIMATE). A tell whose mode came up and didn't show is **cleared as false**. A tell whose moment never came stays SEEN.

**THE SECOND FILM NIGHT is a choice (NEW):**
- **Look again:** raises one group's SEEN tells from 70 to 90 in 100.
- **Next group:** opens the next tell group at 70.

The choice is right one way or the other depending on how many lines rely on one tell.

**The fundraiser** is cut from this map. It changes no fight week, and if kept it belongs to Club > Money (J7).

## 6. Things that happen

**THE PULL-OUT ROLL (answers J4):**
- It fires on the **Monday of fight week, 5 days out**, and stops the clock once, as one need on Home.
- Own-bout fall-through is 35 in 100 per bout. That's inside John's sourced 25–50% for the final week ([R] Northants Telegraph 2025; Sussex Express 2015).

**The fall-through card has three answers:**
- **Take the replacement:** the host's name, at short notice (GAME: a tougher name, double reputation on a win).
- **Go home:** tiredness carries as under Rest up; mood −6.
- **Ask the host for next month's slot:** −1 favour, booked.

**What stays and what's lost:**
- A banked week always stays.
- A commute that already happened refunds nothing.
- The cottage is only used in championship rounds, where a draw doesn't fall through, so it has no refund rule.

**Late replacement asks:** a host asks at most once per show, only when the boxer fits the gap and is READY, about 1 ask in 6 shows (ESTIMATE). These land with Monday's need.

**At most one stop per boxer per bout.**

## 7–8. What each option changes (summary)

| Option | Changes |
|---|---|
| Swap slot | which of two same-class boxers gets the slot |
| Pass sheet / refuse named card | nothing / that club's count toward its lockout |
| Rest window 3 / 5 / 8 weeks | when the next sheet comes; ring rust |
| Trip | round-1 edge, injury, cash, the coach at home, tiredness |
| Load stop | tank, round 1, banked mastery, tiredness after |
| Sparring nights | ready lines and a plan test, against tank, injury and cut risk |
| Eat less / Train it off / Ask a kilo | the weight margin, against 4 tank / +8 tiredness / 1 favour |
| Who pays | club cash, boxer savings, mood, fairness |
| Film night / look again / next group | which tells you know and how sure you are |
| Fall-through answers | the bout tonight, mood, a favour |
| Use the pick | the assistant's settings, with the reason |

## 9. ON FIGHT NIGHT (the one gold frame)

**PLAN READINESS (top line, D4):** "n ready, n UNSPARRED, n SEEN tells" in marker. Clicking it highlights those lines.

**TONIGHT:**
- The two-layer tank: tiredness grey, choices coloured, each with its price in wins in 100 on hover.
- Round 1: Sharp, Sharp (no boost) or FLAT.
- Each plan line's fire share, tagged READY, UNSPARRED, SEEN 70 / 90 or CONFIRMED.
- The scale margin against the gap.
- The win band.

**BANKED:** the Attrs points, the moves crossing a tier by the bell, and tiredness after the bell.

**SEASON:** this stop against Tick over in this tiredness band, as a range.

Each row shows its change from your assistant's pick, and hovering any number shows its parts. There is no PEAK CAMP row and no "gains ×".

## 10. Menus: every place the mechanic appears

| Menu | What it shows / lets you do | Wired to |
|---|---|---|
| Home (needs) | one need for an open sheet; one Monday-of-fight-week need for the pull-out roll and asks | Needs, BoutSheet, Clock |
| Office desktop | the sheet and bout dates for the next four weeks (D7) | Desktop (built), BoutSheet |
| Fights rail page | each boxer's sheet: up to 3 cards, PASS, "refused n of 2", Swap on a shared slot | BoutSheet, RegionShows |
| Bout card / versus screen | slot reason, REMATCH, "bouts to entry n of 5" / next entry, home or away trade, win band, the weight gap | BoutSheet, Nationals, OppFile, WeighGap (NEW) |
| Boxer page, Fights tab | rest window 3 / 5 / 8; your assistant picks the bout (goal read, greyed reason) | Matchmaking, FighterGoal |
| Fight week screen | WEEK BEFORE strip row; seven day columns of magnets (sparring red, film tape); LOAD three-stop pill; WEIGHT pills; trip cards; COACH AWAY card; who pays; the pick; ON FIGHT NIGHT | FightWeek, CampPlace, TrainingLoad, WeekPhase (amateur branch), PadWeek, Savings, WeighGap |
| Week board | the BUILD week of a 3-week bout; the strip's settings read-only | WeekPlan, WeekPhase |
| Playbook, Game plan | UNSPARRED tag and the warning before a change; plan test ratings ("?" with a club member) | Playbook, StrikeMap, FireLevel |
| Tape room | film nights, SEEN 70 / 90, cleared as false, debutant lock | OppFile, TapeRoom |
| Corner minute (rounds 1 and 2) | CONFIRMED / Not seen; fade check at round 2 | FightNight, OppFile |
| Fight night: weigh-in | bout-day scale 1 hour before at club shows; class limit the day before at championships | Bouts.weigh (home-show branch, NEW), WeighIn |
| Result page / Why | lines that fired a level down because unsparred, named in AGAINST YOU | Why |
| Roster boxer card | savings a week (stipend Off only); SKINT flag | Savings, Recruit |
| Goals (boxer page) | the three new goal types | FighterGoal |
| Money | trips by payer; commute and cottage costs; stipend Off/On and savings | GymBills, Savings |
| Championships | rolling entry count, next entry week, cottage allowed | Nationals |
| Continue button | stops once on the Monday of fight week for the roll and asks | Clock |

## 11. Pack changes this map makes (answers J8)

- **Matchmaking:** amateur offer lead goes from 8–12 weeks to 1–3 weeks. Set camp is never raised for amateur bouts.
- **WeekPhase:** an amateur branch. WEEK BEFORE replaces PEAK; the fight week's load stop replaces the fixed TAPER.
- **Bouts.weigh:** bout-day weigh-in and a gap match for club shows. Championships unchanged.
- **The 21-day rest after a points bout** becomes the rest window (3 / 5 / 8). Suspension and STOP_REST_WEEKS are unchanged.
- **TAPER's no-sparring rule** is overridden for late sparring at a stated price.
- **Savings** are a new value tied to the stipend toggle.

## 12. Build order

1. **Probes (no ESTIMATE prints before its probe, D1):**
   - **FIGHTWEEKPROBE4:** by state. Each stop best in at least 1 fight week in 5 per tiredness band; best-to-worst gap 3 to 8 in 100.
   - **Assistant probe:** a reader beats the pick by 2+ in 100 a season. If pick-to-best is under 1 in 100, load folds to two stops (Tick over / Rest up) under "Change the load".
   - **CAMPPLACE1:** each trip per use against a home Rest up week, target 1 to 4 in 100. The cottage must be best in at least one championship state, or it's cut.
   - **BudgetProbe:** each payer row best for some boxer.
   - **Tank test:** at start tiredness 75, Train through plus a late night costs at least 4 in 100 more than Tick over.
   - Favour test (1 to 2); slot test (2+ cards); sparring test (2 to 5 in 100 for a new plan); film test (look again vs next group each best in some state).
2. **Systems first (D2):** BoutSheet, RegionShows, the WeekPhase amateur branch, Savings, the Nationals next-year state, the Bouts.weigh home-show branch, WeighGap.
3. **The fight week screen,** from a redrawn Look B mockup of this screen. Seaside, PEAK CAMP, gains-× and the dark style are dropped.
4. **The rest window, Swap, REMATCH, the Monday pull-out card.**
5. **Tell truth, look again / next group, the debutant lock.**

**The screen at 1920×1080 (Look B):** the dark shell (top bar and left rail) around a whiteboard.
- **Header (96 px):** both portraits with the names once, the class in kg, records, days to the bell, home or away, favours with the host, and the margin against the gap now and on the day. A link opens the next four weeks on the Office desktop.
- **WEEK BEFORE strip (84 px, own row, only 2+ weeks out):** the trip pill and the week-before sparring magnet.
- **Left (440 px):** trip cards (cost, week, tonight's number); the COACH AWAY card (only when a coach leaves); the payer row (savings, Confidence gate, SKINT).
- **Centre (920 px):** seven day columns of magnets (sparring red, film tape); the LOAD three-stop pill with the line picker and next-stop hover; the WEIGHT pills (Eat less, Train it off, Ask a kilo with its favour); plan line chips.
- **Right (560 px):** ON FIGHT NIGHT in the one gold frame, with the readiness line on top.
- **Bottom (120 px):** your assistant's note, **Use the pick**, and the red **Lock the week**. Green is used only for Continue.

## 13. Open for the owner

- **Pro road:** "9 wins with 3 over ranked names" or keep "9 wins at any rank"; the pace is about 1.4 seasons.
- **Loss to a name below:** drops two places, yes or no.
- **Savings from the boxer's job** ($25 to $75 a week, stipend Off): yes or no.
- **Rest window replacing the fixed 21 days:** yes or no.
- **Tick over at one rest day** instead of today's three-day TAPER: yes or no.
- **Club-show weigh-in on bout day within a gap** (EB rules) instead of the class limit the day before: yes or no.
- **Cottage for championship rounds only:** yes, or cut.

**CHECKs:**
- **Claude:** the WeekPhase amateur branch; the coach factor with only the head coach; the home-show branch in Bouts.weigh.
- **John:** whether a host may re-match a missed boxer on the night under EB rules, and how often.

--- THE SCREEN (HTML source) ---
```html
<!doctype html>
<html><head><meta charset="utf-8"><title>Fight week v1 (S474)</title>
<link href="https://fonts.googleapis.com/css2?family=Barlow:wght@500;600;700;800&family=Permanent+Marker&display=swap" rel="stylesheet">
<style>
:root{--ink:#ece7dc;--dim:#a9b0b8;--line:#4a5560;--gold:#f2c14b;--red:#d9463a;--green:#58c27a;--blue:#4f8fe0;--board:#2c3236}
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;font-family:Barlow,Arial,sans-serif;color:var(--ink);
 background:#3a2c1f radial-gradient(900px 500px at 50% 40%,#4a3826,#2a1f15)}
.frame{position:absolute;left:150px;top:14px;width:1620px;height:1052px;border:16px solid #6b4a2b;border-radius:8px;
 box-shadow:inset 0 0 0 3px #3a2816,0 10px 40px rgba(0,0,0,.7);
 background:var(--board) radial-gradient(1200px 700px at 40% 30%,#3a4146,#24292c)}
.m{font-family:"Permanent Marker",cursive}
.inner{position:absolute;inset:18px 26px}
/* header 96 */
.hd{height:96px;display:flex;align-items:center;gap:22px;border-bottom:2px solid #55606a}
.por{width:74px;height:74px;border-radius:6px;background:#6b7a88;border:2px solid #cfd6dd;display:flex;align-items:center;justify-content:center;font-size:12px;color:#223}
.hd .nm{font-size:30px;line-height:1}.hd .sub{font-size:17px;color:var(--dim);margin-top:6px}
.vs{font-size:24px;color:var(--dim)}
.tags{margin-left:auto;display:flex;gap:10px;align-items:center}
.tag{border:2px solid #6d7882;border-radius:7px;padding:6px 10px;font-weight:700;font-size:17px;white-space:nowrap}
.tag.g{border-color:var(--gold);color:var(--gold)}.tag.b{border-color:var(--blue);color:#9cc3ff}
.days{font-size:44px;color:var(--gold);line-height:1;text-align:center}.days small{display:block;font-family:Barlow;font-size:14px;color:var(--dim)}
/* week-before strip 84 */
.strip{height:84px;margin-top:10px;display:flex;align-items:center;gap:16px;border:2px dashed #7d8790;border-radius:8px;padding:0 16px;background:rgba(255,255,255,.03)}
.strip .lbl{font-size:24px;color:#d9dee3;width:200px}
.pill{border:2px solid #6d7882;border-radius:20px;padding:7px 14px;font-weight:700;font-size:17px}
.pill.on{border-color:var(--gold);background:rgba(242,193,75,.12);color:var(--gold)}
.mag{width:52px;height:52px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:13px;color:#fff;box-shadow:0 3px 6px rgba(0,0,0,.5)}
.mag.spar{background:var(--red)}.mag.film{background:#2b2b2b;border:3px solid #ddd}.mag.pads{background:var(--blue)}
.note{font-size:16px;color:var(--dim)}
/* body columns */
.body{position:absolute;top:212px;left:0;right:0;height:676px;display:flex;gap:18px}
.col{display:flex;flex-direction:column;gap:9px}
.card{border:2px solid #5c6670;border-radius:9px;padding:12px 14px;background:rgba(0,0,0,.18)}
.card.on{border-color:var(--gold);box-shadow:0 0 0 2px rgba(242,193,75,.25)}
.card.red{border-color:var(--red)}
.ttl{font-size:22px;margin-bottom:6px}
.row{display:flex;justify-content:space-between;font-size:16px;margin:3px 0}
.row b{font-weight:800}.up{color:var(--green)}.dn{color:#ff8a7a}.gold{color:var(--gold)}
.sec{font-size:22px;color:#d9dee3;margin:2px 0 2px}
/* centre */
.daysrow{display:flex;gap:8px}
.day{flex:1;height:132px;border:2px solid #56616b;border-radius:8px;padding:6px;display:flex;flex-direction:column;align-items:center;gap:6px;background:rgba(255,255,255,.03)}
.day .d{font-weight:800;font-size:16px}.day .t{font-size:13px;color:var(--dim);text-align:center}
.day.bell{border-color:var(--gold);background:rgba(242,193,75,.08)}
.load{display:flex;gap:10px}
.stop{flex:1;border:2px solid #5c6670;border-radius:9px;padding:7px 12px;background:rgba(0,0,0,.18);position:relative}
.stop.on{border-color:var(--gold);background:rgba(242,193,75,.08)}
.stop .n{font-size:21px}.stop .best{font-size:14px;color:var(--dim);margin-top:4px;font-style:italic}
.hov{position:absolute;left:104%;top:auto;bottom:-10px;width:250px;width:330px;background:#14181b;border:2px solid var(--gold);border-radius:8px;padding:8px 10px;font-size:15px;z-index:5;box-shadow:0 8px 24px rgba(0,0,0,.6)}
.chips{display:flex;gap:8px;flex-wrap:wrap}
.chip{border:2px solid #6d7882;border-radius:7px;padding:5px 10px;font-weight:700;font-size:15px}
.chip.uns{border-color:var(--red);color:#ff9a8a}.chip.rdy{border-color:var(--green);color:#8fe0a8}
.wt{display:flex;gap:10px}
.wp{flex:1;border:2px solid #5c6670;border-radius:9px;padding:6px 12px;font-size:15px}
.wp.off{opacity:.45}
/* right gold frame */
.gold-frame{border:4px solid var(--gold);border-radius:10px;padding:14px 16px;background:rgba(242,193,75,.05);height:100%;display:flex;flex-direction:column;gap:10px}
.ready{font-size:22px;color:var(--gold)}
.tank{height:30px;display:flex;border:2px solid #6d7882;border-radius:6px;overflow:hidden}
.tank div{height:100%}
.band{font-size:15px;color:var(--dim)}
.big{font-size:34px;font-weight:800}
.ln{display:flex;justify-content:space-between;align-items:center;font-size:16px;padding:4px 0;border-bottom:1px solid #46505a}
.tg{font-size:12px;font-weight:800;border-radius:4px;padding:2px 6px;margin-left:6px}
.tg.r{background:#2f6b45}.tg.u{background:#8a2c24}.tg.s{background:#5a4a12;color:var(--gold)}
/* bottom 120 */
.bot{position:absolute;bottom:0;left:0;right:0;height:112px;border-top:2px solid #55606a;display:flex;align-items:center;gap:18px}
.asst{display:flex;gap:12px;align-items:center;flex:1}
.asst .por{width:64px;height:64px}
.asst .say{font-size:24px;line-height:1.2}.asst .why{font-size:16px;color:var(--dim)}
.btn{border-radius:8px;padding:14px 22px;font-weight:800;font-size:20px;border:2px solid #7a6a55;background:#3b2f24}
.btn.red{background:#b2352b;border-color:#e2675c}
</style></head><body>
<div class="frame"><div class="inner">

<div class="hd">
 <div class="por">photo</div>
 <div><div class="nm m">Fight week</div><div class="sub">Lucy 3-1 &nbsp;v&nbsp; Priya Nair 4-2 &nbsp;&middot;&nbsp; 60 kg</div></div>
 <div class="por">photo</div>
 <div class="tags">
  <span class="tag b">AWAY at Fitzroy Lodge</span>
  <span class="tag">Favours with the host &#9679;&#9675;&#9675;</span>
  <span class="tag">Scale: 61.4 now &middot; inside the 2.5 kg gap by 0.6 on the day</span>
  <span class="tag g">Next 4 weeks &#8599;</span>
  <div class="days m">9<small>days to the bell</small></div>
 </div>
</div>

<div class="strip">
 <div class="lbl m">The week before</div>
 <span class="pill">Home gym &middot; free</span>
 <span class="pill on">City club, with your assistant &middot; $270</span>
 <span class="pill">Alone &middot; $210</span>
 <div style="width:30px"></div>
 <div class="mag spar">SPAR</div>
 <div class="note">Week-before sparring: costs one pad night, readies <b>2 lines</b> (you pick)</div>
</div>

<div class="body">
 <!-- LEFT 440 -->
 <div class="col" style="width:440px">
  <div class="sec m">Where to train</div>
  <div class="card on"><div class="ttl">City club, commute with your assistant</div>
   <div class="row"><span>$150 + $120 food</span><b class="gold">week before</b></div>
   <div class="row"><span>A partner who also counters</span><b class="up">round 1 +1.0</b></div>
   <div class="row"><span>Injury that week</span><b class="dn">x1.15</b></div>
  </div>
  <div class="card red"><div class="ttl" style="color:#ff9a8a">Your assistant is away all week</div>
   <div class="row"><span>Your other boxers train at</span><b class="dn">0.85 (head coach only)</b></div>
   <div class="row"><span>Evening class</span><b class="dn">stops: -$350</b></div>
  </div>
  <div class="sec m">Who pays the trip</div>
  <div class="card on"><div class="row"><b>The club</b><span>$270 &middot; mood +3</span></div>
   <div class="row note"><span>paid for her more than the others lately</span><span class="dn">-2 with each</span></div></div>
  <div class="card"><div class="row"><b>Half each</b><span>$135 &middot; mood +3 on a win</span></div></div>
  <div class="card" style="opacity:.5"><div class="row"><b>She pays</b><span>savings $90: too little</span></div></div>
 </div>

 <!-- CENTRE 920 -->
 <div class="col" style="width:640px;flex:1">
  <div class="sec m">Fight week</div>
  <div class="daysrow">
   <div class="day"><div class="d">Mon</div><div class="t">roadwork</div><div class="mag pads">PADS</div></div>
   <div class="day"><div class="d">Tue</div><div class="t">shadow</div><div class="mag spar">SPAR</div><div class="t dn">-3 tank</div></div>
   <div class="day"><div class="d">Wed</div><div class="t">intervals</div><div class="mag film">FILM</div></div>
   <div class="day"><div class="d">Thu</div><div class="t">speed bag</div><div class="mag pads">PADS</div></div>
   <div class="day"><div class="d">Fri</div><div class="t">rest</div></div>
   <div class="day"><div class="d">Sat</div><div class="t">light shadow</div></div>
   <div class="day bell"><div class="d gold">Sun</div><div class="t gold">FIGHT NIGHT<br>weigh-in 1 h before</div></div>
  </div>
  <div class="sec m">The week's load</div>
  <div class="load">
   <div class="stop"><div class="n">Rest up</div><div class="row"><span>tank</span><b>0 off</b></div><div class="row"><span>round 1</span><b class="dn">flat -1.0</b></div><div class="row"><span>banked</span><b>a fifth</b></div><div class="best">best: tiredness 65+, or a heavy cut</div></div>
   <div class="stop on"><div class="n gold">Tick over</div><div class="row"><span>tank</span><b>6 off</b></div><div class="row"><span>round 1</span><b class="up">sharp + 1 line up</b></div><div class="row"><span>banked</span><b>half</b></div><div class="best">best: most weeks under 65</div>
    <div class="hov"><b class="gold">Train through instead:</b> 6 more off the tank, Uppercut 27 &#8594; 31 reaches <b>Usable</b> by the bell, +6 tiredness after.</div></div>
   <div class="stop"><div class="n">Train through</div><div class="row"><span>tank</span><b class="dn">12 off</b></div><div class="row"><span>round 1</span><b class="up">sharp</b></div><div class="row"><span>banked</span><b>the full week</b></div><div class="best">best: a move a week from Usable</div></div>
  </div>
  <div class="row" style="font-size:16px"><span>Tick over fires one line a level up in rounds 1-2:</span><b class="gold">Waits &#8594; feint, body hook &#9662;</b></div>
  <div class="sec m">The weight</div>
  <div class="wt">
   <div class="wp"><b>Eat less</b><br><span class="dn">4 off the tank</span></div>
   <div class="wp"><b>Train it off</b><br>0.3 kg for <span class="dn">+8 tiredness</span></div>
   <div class="wp off"><b>Ask for a kilo</b> &#9679;<br>only within 1 kg of the gap</div>
  </div>
  <div class="sec m">Plan lines</div>
  <div class="chips"><span class="chip rdy">Waits &#8594; feint, body hook</span><span class="chip rdy">Pressed &#8594; step back</span><span class="chip uns">Loads up &#8594; check hook &middot; UNSPARRED</span><span class="chip">Inside &#8594; tie up</span></div>
 </div>

 <!-- RIGHT 560 -->
 <div class="col" style="width:470px">
  <div class="gold-frame">
   <div class="ready m">2 ready &middot; 1 UNSPARRED &middot; 2 SEEN tells</div>
   <div class="sec m" style="margin:0">On fight night</div>
   <div><div class="row"><span>The tank at the first bell</span><b class="big">85</b></div>
    <div class="tank"><div style="width:6%;background:#7c858d"></div><div style="width:6%;background:#e0a33a"></div><div style="width:3%;background:var(--red)"></div><div style="flex:1;background:#2c6b46"></div></div>
    <div class="band">grey: tiredness 3 &middot; gold: tick over 6 &middot; red: sparring 3 &nbsp;(hover: wins in 100 each)</div></div>
   <div class="row"><span>Round 1</span><b class="up">Sharp, one line up</b></div>
   <div class="ln"><span>Waits &#8594; feint, body hook<span class="tg r">READY</span><span class="tg s">SEEN 70</span></span><b>fires 1 in 2</b></div>
   <div class="ln"><span>Pressed &#8594; step back<span class="tg r">READY</span></span><b>1 in 3</b></div>
   <div class="ln"><span>Loads up &#8594; check hook<span class="tg u">UNSPARRED</span></span><b class="dn">level down</b></div>
   <div class="row"><span>Scale on the day</span><b class="up">inside the gap by 0.6 kg</b></div>
   <div class="row"><span>Win band</span><b class="big gold" style="font-size:28px">46-58%</b></div>
   <div class="sec m" style="margin-top:4px">Banked</div>
   <div class="row"><span>Technique</span><b class="up">+0.4</b></div><div class="row"><span>Tiredness after the bell</span><b>+0</b></div>
   <div class="sec m" style="margin-top:4px">Season</div>
   <div class="row note"><span>Tick over at this tiredness v the others</span><b>-1 to +2 in 100</b></div>
  </div>
 </div>
</div>

<div class="bot">
 <div class="asst"><div class="por">coach</div><div><div class="say m">"Tick over, the city club the week before, spar Tuesday."</div><div class="why">Your assistant's pick - what drove it: the opponent counters in round 1. Sure 4 in 5.</div></div></div>
 <div class="btn">Use the pick</div>
 <div class="btn red">Lock the week</div>
</div>

</div></div>
</body></html>
```
