# COACHMAP1 - score this mechanic's DESIGN (fresh critic, S548)

You are a fresh critic: a sports management-sim designer who knows boxing and Football Manager's staff model. Read the whole
game first (the critic pack below: facts only, no scores), then what a critic can open, then the design map and the greybox
probe result at the end. Judge the MECHANIC, not the look of any screen. You have seen no earlier review of it; do not look
for one (no file named *_CRITIC_*).

Score, each out of 10, with the reasons, on its own line as `SCORE depth=<n> play=<n> general=<n>`:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. PLAY - fun across a season: anticipation, a reason to come back, a reward the player feels.
3. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
The bar (owner S534: "mechanics need an 8 critic's to stay in the game for depth and fun"): 8 or more on DEPTH and 8 or
more on PLAY. Below that, say whether you would cut the mechanic, keep it, or what must change.

Also answer (owner S403): which options are MISSING, which are USELESS, and what each option changes in the game.

The owner asked for coaches as people (S539): "why not make proper coaches like fottball manager and use them more to tighten
and improve the core loop ?"; then (S542) "a staff game, as in Football Manager ... a few decisions a season, not a puzzle
solved again every week"; then (S548) he cut the paid trial week and put the chemistry word on the hire card. Judge HOW the
map does it, not whether coaches should be people.

Judge hardest the list in the map's section 9 (the decisions the player still makes) and the five holes in section 7:
- Is the hire a real choice when the measured best hire is one coach for a gym with a professional and another for a gym
  without? Does chemistry shown on the hire card make it one, and how would you make sure?
- The player now calls the corner live during a fight (eight commands, worth about 10 wins in 100 over a coach who reads the
  opponent's file). What should the coach in the corner be for, so the corner pick is a decision and not decoration?
- In a simmed bout the coach's rating buys nothing (section 5). What rule would make a better coach worth his wage in the
  ring without taking the fight out of the player's hands?
- Which of the moments (raise, rival offer, style push, course) would you keep, cut or change?

Code: the map says which parts are in the game today (section 6, with files); the rest is design. If you can open the
repository (main, 2026-11-24 or later; say which commit), check those lines; if you cannot, say so plainly. Never guess a
code fact.

Judge the probe too (the result at the end): could each bar pass while the mechanic is still shallow, and what would you
measure instead.

End with **To reach 10/10** (owner S405): the concrete changes that would take it from your score to 10, most important
first, each specific enough to build. A score without that list is not finished.
Then DRAW your 10/10 (owner S411): one complete, self-contained HTML page, 1920x1080, of the screen where this mechanic
matters most - the hire card with the chemistry words (inline CSS, no scripts, no outside files). A decision screen is a
scene with cards (a picture, a name, at most four plain facts, one button; details on hover), never rows of key and value.
Put it in one code block at the very end.


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
   BUILT S523 (turning pro v2): two fictional promoters. Bow Lane (ticket house: $1,500, less $25 a ticket short of 60 sold,
   floor $500, 50% of tickets past 60, debut 4 weeks out, opponent 1.0 under) and Harrow & Finch (guarantee house: $1,800,
   30% past 70, debut 6 weeks out, opponent 1.5 under). Who calls follows the debut ticket forecast (family 20 + half the
   members + 2 a win + 10 a title + 10 for topping the club's own show): within 15 of 60 both call side by side, else one.
   The offer stands 14 days (running out is not a No: the call returns after 2 more wins); no first call at 32+. One ask
   per promoter, its answer shown before pressing: later debut (+2/+4 weeks for $150/$300 off), softer opponent (and the
   next 2 offer sets are tune-ups), better split (taken 20+ over break-even, a +5 counter at 5-19, else won't), own ticket
   price (Bow Lane), costs from the purse (Harrow & Finch counter). The offer shows the gym at signing, the gym each week
   after, the boxer's money and when the gym is even again; morale on each button (a title-chaser before the nationals
   minds). The debut pays the gym 25% of the purse and of the ticket share. For the first 6 pro fights Harrow & Finch adds
   a second tune-up, Bow Lane a second step up. NEXT STEP shows tickets vs each break-even in wins, age line, declines left.
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
- Each fighter has a class limit (amateur, from Data.gd: women's 57/60/65/70/75 kg, men's 55/60/70/75 kg; the pro ladder groups them by ProLadder.division_for). Weigh-in is the day before. Diet Hold/Cut and training burn move weight;
  the bout page and Fight prep forecast "now / on the day". Missing weight calls the bout off and the club pays $300 for the empty slot. A boxer over his
  class can get a bout he can make (a later date). The Old hand head coach makes cuts easier (120 kcal a day more).

### 4.5 Booking and matchmaking - PARTLY
- Amateurs BUILT: offers arrive (a club show every other Saturday; one offer at a time per fighter, answer by a date, usually 8-12 weeks lead at clubs, 2-4
  weeks in the first hour). Each offer: Accept or Pass, both free. An unsafe mismatch (a novice, 0-10 bouts, against an open fighter) cannot be accepted. Win chance
  shown as a band that widens when unscouted. Ask for a fight (amateurs, built S512-S518): the sheet name, a step up or a name you pick, at one of the next club shows; a host can say No with its reason, a No to a boxer ON A RUN is a DUCK, two ducks in 8 weeks and that corner OWES the bout. The door opens the day after a bout (S520); the asked show still falls after the 10-day rest, and the sheet sends its own offer when the rest ends if nothing was asked.
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
  Her mat plan (BUILT S515-S516): a hand of plan lines (a white belt holds 3), shown line by line on the open's result and counted in a season
  book ("this season N of M: works / fails"). Measured (mat_book_test, S516): a white belt tried her plan lines ONCE in four opens - with a hand
  of 3 and early losses, most opens end before a line comes up.

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

Operator S403: "giveaccess to miro board for the critics and everything else required" (S499: the board is now our own map page). Read `ops/research/CRITIC_PACK.md` first, then use whatever here helps. All of it is read-only for a critic: change nothing.

## The map (S499: our own page, Miro is no longer used)
The owner's map is http://127.0.0.1:8787/map. A critic reads it from its files, no browser and no Miro tool needed:
- `ops/AgentComms/map/frames.json`: every frame on the map (rows, titles, which pictures each shows as file globs).
- `ops/AgentComms/map/notes.json`: the owner's sticky notes (`who: operator`), each with the frame it sits on. Read them all.
- Where we are (done, now, next): `python ops/Tools/where_we_are.py` prints the cards.

| Frame id | What it holds | Files |
|---|---|---|
| screens | Every screen as the game draws it today | `E:/FightCamp/critic_pack/screens/*_real.png` |
| menus402 / painted402 | Menus final (S402): layouts and Ludo's painted art | `docs/mockups/s402/*.png`, `docs/mockups/concepts/S402_*.png` |
| menus401 / painted401 | The earlier round | `docs/mockups/s401/*.png`, `docs/mockups/concepts/S401_*.png` |
| where | What is done, being worked on, and next | roadmap.json `plan.map` |

The old Miro board (MENUS FINAL, MECHANICS LIST, the owner's stickies up to S498) is a view-only archive; what could be copied
from it is in `ops/AgentComms/map/miro_export.json` (empty until Miro allows a read: see `ops/research/MIRO_EXPORT_S499.md`).

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


---

# THE DESIGN MAP

# DESIGN_COACHMAP1 - coaches, as they stand after the cuts (S548)

One clean page for the critics. It replaces `DESIGN_COACHDEEP9.md` as the page to read (v9 stays as the history).
Sources, cited in brackets: [I n] = the owner's interview `COACH_INTERVIEW_S542.md` point n; [G Qn] = his grill answers
`COACHDEEP_GRILL_S539.md`; [Q-329] = his board answer of S548; [R9 sN] = the measured result `docs/COACHDEEP9_RESULT.md`
section N; [CB] = `docs/CORNERBASE1_RESULT.md`. A number marked ESTIMATE is a guess that the probe ran with, not a study.
NOTHING ON THIS PAGE IS IN THE GAME YET except where section 6 says so.

## Decided while writing
- The trial week is gone everywhere: no button, no price, no line on the money page. The chemistry word shows on the
  hire card for every boxer, free, before signing [Q-329: "Cut it, show chemistry"].
- "Shown only after 2 weeks together" [G Q12] goes with it: a word the hire card already showed cannot be hidden again.
- The falling-out is a news line, not a pop-up (v9's stop rule, [R9 s4]).
- I did not fill the holes the cuts leave. They are listed in section 7.

## 1. The mechanic in ten lines
You own the gym and are its head coach, with no ratings of your own [G Q1]. The coaches you hire carry the ratings.
It is a staff game, as in Football Manager: a few decisions a season, not a weekly puzzle [I 1]. You decide who to hire
and when (the main decision [I 6]), whether to match a raise or a rival's offer, whether to let a coach push a boxer
towards his own style, whether to send him on a course, and who stands in the corner on fight night [I 8, 9]. The week
pairs coaches and boxers by itself; you may overrule it for free [I 2, 14]. A wrong call is felt as story: an unhappy
boxer or coach, a warning on their card, and after two warnings a person lost for good [I 3, 15]. Up to four coaches
[G Q2], each on a weekly wage [G Q3].

## 2. The rules

**A coach.** Eight ratings 1-20, each wired to a rule the game has: pads, conditioning, tactics, cutman, weight
management, film, motivation, teaching beginners [G Q8]. Two or three specialties [G Q9]. A playbook: one of the six
styles [G Q10]. Five traits 1-20: temper, patience, discipline, ambition, loyalty [G Q11]. Each rating has a ceiling
(rating + 3, ESTIMATE), shown in words [G Q22]. Your coaches and candidates show exact numbers [G Q4, Q16].

**The wage - one rule for every coach** [G Q17 "wages scale with ratings"; R9 s2]:
P = (4 x teaching + 3 x pads + 2 x tactics + 2 x conditioning + motivation + film + 0.5 x cutman + 0.5 x weight) / 14;
wage = $150 + $125 x (P - 9) + $150 for each art past the first + $350 for a known name, rounded to $10. The weights and
the three constants are ESTIMATES ([R9 s9]: "the formula itself, not a card, is what the owner should judge").

**The hire list.** Three candidates a month [I 6, G Q15]. The HIRE CARD shows:
- his ratings, specialties, playbook, traits and wage;
- THE CHEMISTRY WORD WITH EACH OF YOUR BOXERS: bond / fine / clash, the reasons on hover [Q-329];
- "Pays for itself at about N members" - N is the smallest membership at which the class nights he can run plus the
  dues of the members his coaching lets the gym carry cover his wage [I 6]; a known name's card says instead "Pays only
  with a pro or a title boxer in his corner" [I 11];
- "The boxers win about X more a season with this coach" - X comes from TRAINING (his ratings on her learning over a
  season), not from the corner: see section 5.

**The known name** [I 11]: $800-1,100 a week. When he works the corner of a professional bout the promoter pays the gym
a name fee of 60% of the purse, capped at $4,000 a bout, and each pro win adds +2 reputation (ESTIMATES). Measured: he
loses 22 to 41 lines over two years in every gym without a pro and gains 12 to 38 in every gym with one [R9 s3].

**Pairing.** Each week the plan pairs every boxer with the coach who suits her best (his areas by her style, his
specialties, his playbook, the chemistry word). "Change" overrules a pairing for free; the new pair's word is the only
consequence [I 2, 14]. Class nights fill the evenings no boxer needs and show as a fact; there is no class-or-pads
choice [I 10].

**Chemistry** [G Q12]. His traits against hers (for example a hot-tempered coach with a hot-tempered boxer -0.4; a
patient coach with an unsure boxer +0.3) plus weeks together (+0.01 a coached week, cap 0.25). The word: bond at +0.15
or more, clash at -0.15 or less, fine between (ESTIMATES). It moves her learning (up to about 4.5% either way), morale
and loyalty. One-way: results and money never move it.

**The moments** - at most one a month, a few a season [I 13], each a pop-up like the pro offer:

| Moment | When | The answers |
|---|---|---|
| A raise | his boxers win 3 in a row or a title; ambition 12+; once in 26 weeks | MATCH: wage +25%, his loyalty +10. REFUSE: his loyalty -20 and a warning. |
| A rival's offer | as the raise, for a coach with loyalty 8 or less | MATCH: wage +25%. LET GO: he leaves in two weeks. |
| A style push | his playbook does not fit her style, 8+ weeks together; once a boxer a season | ALLOW: her style becomes his (faster learning later; her next 2 bouts at 0.6 of the plan; her own combination restarts at half). REFUSE: his loyalty -12 and a warning. |
| A course | a coach under his ceiling, cash over $6,000; once a season | SEND: $600 and 2 of his evenings a week for 3 weeks, then +2 in his lowest of pads / tactics / teaching. NOT NOW: an ambitious coach -3 loyalty. |

Measured [R9 s4]: the raise is a real call (refuse best in 6 gyms of 10, match in 4); the style push is a real call
(refuse 6, allow 4). The course was not measured as a call.

**The falling-out is not a decision** [R9 s4]. Backing the coach was best in 10 gyms of 10, so the gym does it: when a
clash pair has worked together 4+ weeks and falls out, the boxer takes the warning and the player reads one news line
("Reid and Kira fell out. The gym backed the coach: Kira is unhappy, warning 1 of 2, until 12 May."). The player can
still split a clash pair with "Change" before it happens.

**Warnings, and losing people** [I 15; R9 s2]. A moment that goes against a person puts a warning on their card, with
its reason, its cost and its fade date. While it stands: a warned boxer learns 10% slower, hears the corner 15% less
and loses 2 loyalty a week; a warned coach's ratings count 10% less (ESTIMATES). It fades after 26 weeks. A person
with two warnings leaves for good at the next blow that takes their loyalty under 25. In its first 8 weeks a warning
never takes anyone under 25.

**The corner pick** [I 9]. Before a fight you pick the coach in the corner. The best tactician gives better calls
between rounds; the coach with the bond is the one she listens to (calls x (1 + 0.4 x chemistry), ESTIMATE); a clashing
coach gets one call ignored a fight; the known name earns his fee only from the corner. Measured on the greybox: the
tactician was right in 45% of the fights where the two differ, the bonded coach in 55% [R9 s1 bar 4].

## 3. What changed against v9

| Rule | v9 | Now | Why |
|---|---|---|---|
| The trial week | one week of his wage shows the chemistry words; one a month | CUT | the wrong buy in 9 gyms of 10 [R9 s5]; owner [Q-329] |
| Chemistry on the hire card | hidden until a trial or two weeks' work | shown for every boxer, free | owner [Q-329] |
| The falling-out | a pop-up with three answers | a news line; the gym backs the coach | one answer best in 10 of 10 [R9 s4]; v9's stop rule |
| The money page | wages, the trial, the course, the name fee | wages, the course, the name fee | the trial is gone |

## 4. The seven bars after both cuts (from [R9 s1], no new run)

| Bar | Status |
|---|---|
| 1 No hire best in more than 6 gyms of 10 | MET (the film-room coach 4, the known name 6) - but see section 7, hole 1 |
| 2 The known name pays with a pro and loses without | MET |
| 3 No answer best in more than 6 of 10, each moment | MET on the two moments left (raise 6 / 4, push 6 / 4) |
| 4 Corner: tactician and bonded coach each right 25%+ | MET (45% / 55%) - but see section 7, hole 2 |
| 5 A careless owner loses, a careful one does not | MET (careless loses in 5 gyms, careful in 0) |
| 6 The trial is right in 2+ gyms and wrong in 2+ | NO LONGER APPLIES (the trial is cut) |
| 7 Nothing runs away | MET |

To re-run: bar 1 with the chemistry word known at hiring (the probe's hire pick was blind to it), and bar 5 (the
careless owner hired blind; with the word on the card a careless hire is harder to make).

## 5. A fact from another probe this map must not contradict
In a SIMMED bout a coach's rating buys nothing: a corner coach rated 80 against one rated 35 is +0.4 to +0.7 wins in
100 [CB verdict 4]. What helps a simmed boxer is a coach who rests her when she is tired and says "hands up" when she
is hurt (+2.6 wins in 100 at 3 rounds, +6.2 at 6 [CB verdict 2]) - any coach could do that. So the hire card's "win
about X more a season" must come from training, and the corner pick's worth must come from the bond, the ignored call
and the name fee, not from the tactics number, until a rule makes tactics matter in the ring. And in the game today
the win read ignores the corner coach entirely [R9 s7]: every coach would show the same "about X%".

## 6. Every menu the mechanic appears on

| Menu | What it shows | Wired to | In the game today |
|---|---|---|---|
| Office computer > Staff (cards) | each coach as a card: face, name, job, four facts, one button; the chemistry word per boxer on hover | coach data, chemistry | The cards exist (`scripts/ui/StaffDesk.gd`, `StaffDeskCard.gd`, S547). They show today's staff: Luke Reid and Marcus Hale (`scripts/state/Data.gd` l.34-37, one rating each), the mat coach and four jobs (`scripts/rules/StaffRoles.gd`). Eight ratings, traits, chemistry: not built. |
| Staff > the hire list | three candidates a month; the hire card of section 2 | the monthly draw, the wage rule, pays-at N, the X line, chemistry | Not built. Today: "coaches for hire" cards while none is signed (`StaffDesk.gd`), a cash runway line (`scripts/ui/HireRunway.gd`). |
| The coach card | ratings and ceilings in words, specialties, playbook, traits, his boxers and the word with each, warnings, loyalty | coach data, chemistry, warnings | Not built. |
| The week plan | each boxer's coach as a fact, with "Change"; class nights as a fact | the pairing rule, class demand | Not built. Today the class-nights-against-pads control is still there (`scripts/rules/CoachRoles.gd` class_week): the owner cut it [I 10]. |
| The boxer card | her coach, the word, any warning with its cost and fade | pairing, chemistry, warnings | Not built. |
| The moment pop-ups | the raise, the rival offer, the style push, the course: both people's loyalty, who would carry a warning and what it costs | the moment rules | Not built. By the owner's S544 rule these are SCENES with cards, not rows. |
| News / Mail | the falling-out line | the falling-out rule | Not built. |
| The corner pick, before a fight | each coach's tactics, the word with this boxer, the name fee, "about X%" | the corner rules | Not built, and its read needs wiring first [R9 s7]. |
| Finance | wages, the course, the name fee | cash ledger | Wages are there; the course and the fee are not built. |

## 7. What the cuts leave open (not filled here)
1. IS THE HIRE STILL A CHOICE? With the word free on the card, nobody hires into a clash by accident. The measured
   best hire depends on one thing: a gym with a pro wants the known name, a gym without wants the film-room coach
   [R9 s3]. That is two answers by one rule a player learns once. Chemistry on the card may add the second axis (the
   best coach on paper clashes with your best boxer) - or it may not: unmeasured.
2. THE CORNER PICK AGAINST THE LIVE CORNER. Since S543 the player calls the corner live (eight commands), worth about
   +10 wins in 100 over a coach who reads the file [CB]. This page's corner pick was designed before that. What the
   picked coach does when the player is the one calling is undefined: does he set how well she hears the player's
   call (the bond), give the call when the player sims, or both?
3. THE COURSE has no measured trade (it is "send him when you can afford it").
4. WITH THE FALLING-OUT AUTOMATIC, a clash pair costs a warning the player never chose. "Change" is his only lever, and
   the week pairs by best fit, word included, so a clash pair should be rare. If it is never seen, the news line is dead.
5. THE FOUR JOBS in the game today (second coach, strength coach, physio, cutman) "stay until rated coaches replace
   them" [I 10]: which of the eight ratings replaces which job is not written.

## 8. Feedback loops and their caps (v9's, minus the trial)
- A known name -> fee and reputation -> more members and money -> can afford him: capped at $4,000 a bout, +2
  reputation a win, reputation at 100.
- Bond -> she listens in the corner -> wins -> loyalty and morale. Chemistry itself stays one-way; the bond caps at 0.25.
- Warning -> loyalty drains -> the person leaves -> fewer people: one moment a month; two warnings always shown first;
  8 weeks before a drain can take anyone under the line; a person who left triggers nothing. Measured: a careful owner
  loses 0.00 people a career, a careless one 1.05 at worst [R9 s6].
- A style push -> her style changes -> fit rises -> faster learning: one push a boxer a season; the bonus tops at +15%.
- Wages -> cash: the lowest mean end cash was -$19.9k (the known name in a novice gym, the card that says he does not
  pay there) [R9 s6].
- Removed with the trial: "trial -> the word known -> better pairing". The word is now known at hiring for nothing.

## 9. The decisions the critics score
| Decision | How often | What it trades | Measured as a real call? |
|---|---|---|---|
| Who to hire, and when | a few times a career | wage against class nights, training and (the known name) pro purses; now also the word with each boxer | Two answers by gym type [R9 s3]; with the word on the card: unmeasured |
| Match a raise or refuse | about once a season a coach | +25% wage for good, against a warned coach working 10% worse for 26 weeks | Yes: 6 / 4 |
| Match a rival's offer or let him go | rare | +25% wage against losing him | Not measured apart from the raise |
| Allow a style push or refuse | once a boxer a season | two shaky bouts and a restarted combination now for faster learning later, against a warned coach | Yes: 6 / 4 |
| Send him on a course | once a coach a season | $600 and six of his evenings for +2 in one rating | No |
| Who works the corner | every fight | tactics against the bond against the name fee | 45% / 55% on the greybox; in the game the read is not wired, and the live corner changes what it means (hole 2) |
| Overrule a pairing | when a word is clash | her best-fit coach against a pair that will fall out | No |
| (gone) The trial week; the falling-out | - | - | Cut |


---

# THE GREYBOX PROBE RESULT (v9, before the two cuts)

# COACHDEEP9 - coaches v9 (v8 + the three changes its probe named): the greybox probe and THE CUT (S545)

Task: `ops/research/TASK_COACHDEEP9.md`. Map: `ops/research/DESIGN_COACHDEEP9.md` (v8's map whole, changes marked "v9:"; bars s10 =
v7's, stop rule s16, committed before any run: 9398129). Probe: `tools/coachdeep9.gd` + `tools/coachdeep9_rules.gd`, copies of v8's
with the three changes (v8's files untouched), summary `tools/coachdeep9_sum.py`. Nothing under scripts/ or tests/ changed.
Raw (outside the repo): E:/FightCamp/tmp/coachdeep9/ - trial.txt / trial2.txt (+ _sum: one rep, printed in full), full.txt + full_sum.txt
(100 careers a cell per arm, 17 arms, 10 cells, 31.7 min), cut.txt + cut_sum.txt (the same with `cut=fall:back_coach`, 39.2 min).
All runs through `godot_slot.py --who COACHDEEP9`, one at a time, headless, Dummy audio, watchdog GREEN before each; 0 script
errors in the counted runs (one cut run was lost and re-run: another session committed scripts/state/Data.gd while it loaded).

## 1. Verdict: FAIL - 5 of 7 on the full run; 6 of 7 after THE CUT of the falling-out
Stop rule (map s16) applied: bar 3 failed again on the falling-out -> THE CUT (s4). No v10 proposed. No critic brief, nothing queued
for kalli or dola, no code-checked critic owed. Bar 6 (the trial week), which v8 passed, now fails in both runs (s5).

| Bar | Needed | v8 (full) | v9 full run | v9 with THE CUT (falling-out by the rule) |
|---|---|---|---|---|
| (1) no hire best in > 6 of 10 | <= 6 | L 7 - FAIL | **F 4, K 6** - PASS | F 4, K 6 - PASS |
| (2) K > NOHIRE by > 2 SE with a pro / title boxer; not above +2 SE without | 6 + 4 | big_am +5.9 - FAIL | pro/title +20.1, +30.5, +27.4, +37.7, +12.0, +37.7 (all > 2 SE); without -28.8, **-21.9**, -28.6, -41.2 - PASS | same - PASS |
| (3) no answer best in > 6 of 10, each moment | <= 6 | fall coach 8; push refuse 8 - FAIL | **falling-out: back the coach 10**; raise refuse 6 / match 4; push refuse 6 / allow 4 - FAIL | raise 6 / 4, push 6 / 4 - PASS |
| (4) corner: tactician >= 25%, bonded >= 25% | both | 38% / 62% | 45% / 55% (1,373 differing fights) - PASS | same - PASS |
| (5) careless loses in >= 2 cells, careful in <= 1 | both | 5 / 0 | careless 5 cells, careful 0 - PASS | same - PASS |
| (6) trial right (> +2 SE) in >= 2, wrong (< 0) in >= 2 | both | right 4, wrong 6 | **right 1 (big_title +9.0), wrong 9** - FAIL | same - FAIL |
| (7) nothing runs away | all | PASS | members = catchment in every arm; 0 months with two moments; bond max 0.25, chem max 0.72 - PASS | same - PASS |

## 2. The three changes, as run
1. ONE WAGE RULE (grill Q17 "wages scale with ratings"). P = (4 x teaching + 3 x pads + 2 x tactics + 2 x conditioning + motivation
   + film + 0.5 x cutman + 0.5 x weight) / 14; wage = $150 + $125 x (P - 9) + $150 an art past the first + $350 for a known name,
   rounded to $10. Same formula for all five cards, no card tuned:

   | Card | v8 wage | v9 wage | pays for itself at about N members (v9) | moved |
   |---|---|---|---|---|
   | L local pressure, teaching 14 | $200 | $480 | 60 | +$280 |
   | M two-art mat coach, teaching 15 | $450 | $590 | 111 | +$140 |
   | S solid engine room, teaching 7 | $550 | $420 | 48 | -$130 (now the cheapest) |
   | F solid film room, teaching 9 | $480 | $440 | 48 | -$40 |
   | K known name | $1,000 | $960 | never on members | -$40 |
   The best class teacher (L, M) is no longer the cheapest card. Bar 1 now passes: F best in the four cells without a pro, K in
   the six with one. L, best in 7 in v8, is best nowhere (it was the price, not the coach).
2. THE CAREFUL PUSH LINE - this is the probe BOT's policy, not a game rule. In one sentence: "allow a style push from a coach who is
   the main coach of at least half the gym's boxers, refuse one with fewer" (still allow when a refusal would put a second warning
   on him or take him within 10 of the line, as v8). Bar 2 now passes: big_am's K - NOHIRE went from +5.9 +- 2.1 to -21.9 +- 1.7.
3. A STANDING WARNING DRAINS LOYALTY: while one warning stands, the warned person loses 2 a week (see s6 for why 2, not 1) until it
   fades (26 weeks) or a second warning comes; in its first 8 weeks it never takes anyone under 25.

## 3. Score by cell (lines over two years; v7's score), full run
| Cell | NOHIRE | L | M | S | F | K | best | K-NOHIRE | trial-blind (fav -> alt) |
|---|---|---|---|---|---|---|---|---|---|
| small_am | 273.1 | 260.9 | 265.8 | 263.6 | **280.0** | 244.4 | F | -28.8 +- 1.8 | -0.4 +- 0.0 (F -> L) |
| big_am | 298.6 | 295.3 | 305.8 | 298.0 | **314.4** | 276.6 | F | -21.9 +- 1.7 | -3.1 +- 0.7 (S -> L) |
| small_pro | 337.8 | 330.9 | 332.7 | 331.0 | 340.7 | **357.9** | K | +20.1 +- 0.6 | -27.9 +- 0.8 (K -> S) |
| big_pro | 363.3 | 366.6 | 372.9 | 366.7 | 376.5 | **393.7** | K | +30.5 +- 0.6 | -18.2 +- 0.8 (K -> F) |
| small_title | 335.1 | 327.2 | 330.5 | 327.9 | 337.3 | **362.5** | K | +27.4 +- 0.9 | -35.6 +- 1.1 (K -> S) |
| big_title | 360.5 | 363.0 | 370.7 | 363.6 | 373.1 | **398.2** | K | +37.7 +- 0.9 | +9.0 +- 0.7 (S -> F) |
| small_novice | 10.3 | 3.3 | -8.3 | 5.9 | **16.3** | -18.3 | F | -28.6 +- 1.5 | -3.1 +- 0.7 (S -> L) |
| big_hot | 197.8 | 206.7 | 189.2 | 213.2 | **213.8** | 156.6 | F | -41.2 +- 0.2 | -6.9 +- 0.2 (S -> L) |
| small_pro_hot | 235.6 | 234.1 | 221.3 | 240.2 | 238.4 | **247.6** | K | +12.0 +- 0.8 | -0.4 +- 0.0 (F -> L) |
| big_title_mix | 261.2 | 263.7 | 271.2 | 264.3 | 274.9 | **298.9** | K | +37.7 +- 0.9 | -0.4 +- 0.0 (F -> L) |
Population (named in the output, as v7/v8): the TEST CLUB (TestClub.make on Career.quick_start, seed 5391): Lucy (women's lightweight,
Out-boxer, 21), Kira (women's featherweight, Out-boxer, 18), Josh (men's welterweight, Pressure fighter, 23), Ana (no-gi); cells as map s10.

## 4. Forced moments (bar 3), every answer from the same state, the careful line after - and THE CUT
| Cell | falling-out: coach / boxer / split | raise: match / refuse | push: allow / refuse |
|---|---|---|---|
| small_am | **278.1** / 277.7 / 276.4 | 273.0 / **276.5** | **284.4** / 270.0 |
| big_am | **296.2** / 294.7 / 281.5 | 294.4 / **306.0** | 294.8 / **297.4** |
| small_pro | **355.9** / 354.5 / 345.7 | **357.7** / 334.3 | 354.4 / **357.9** |
| big_pro | **391.6** / 390.3 / 376.9 | **393.5** / 365.9 | 390.2 / **393.7** |
| small_title | **360.4** / 359.1 / 350.3 | **361.5** / 336.5 | 359.0 / **362.4** |
| big_title | **361.6** / 360.1 / 346.9 | 360.9 / **366.9** | 360.0 / **363.3** |
| small_novice | **2.6** / 1.4 / -10.8 | 1.1 / **11.5** | **8.2** / 4.8 |
| big_hot | **211.5** / 208.3 / 209.3 | **208.5** / 206.8 | 210.5 / **213.2** |
| small_pro_hot | **236.9** / 236.6 / 235.7 | 232.9 / **238.2** | **238.1** / 233.9 |
| big_title_mix | **271.5** / 271.0 / 270.6 | 268.3 / **275.1** | **276.3** / 263.0 |
The style push is now a real call (allow 4, refuse 6): change 2 plus the drain (a drained coach sits near the line, so the next
push is allowed). The raise stays a real call (6 / 4). The falling-out got worse (back the coach 10 of 10, by 0.3-3.2 lines).

**THE CUT - the falling-out.** It is not a player decision.
- What the game does by itself instead: when a clash pair has worked together 4+ weeks and falls out, the gym backs the coach. The
  boxer takes the warning (loyalty -12, the v8 work cost and the v9 drain); the coach +5. Backing the coach was best in all 10 cells.
- What the player still sees: one news line - "Reid and Kira fell out. The gym backed the coach: Kira is unhappy (warning 1 of 2,
  until 12 May)." The warning shows on the boxer card as before. "Change" on the week plan stays free, so the player can still
  split a clash pair before it falls out (the careful line already does: no falling-out ever fired on its own in a careful arm).
- Re-scored with the falling-out played by the rule in every arm (cut run): bars 1, 2, 4, 5, 7 PASS with the same numbers to the
  decimal (the careful arms never meet a falling-out; the careless line already backs the coach); bar 3 PASSES on the two moments
  left (raise 6 / 4, push 6 / 4); bar 6 FAILS (right 1, wrong 9). Both tables: full_sum.txt and cut_sum.txt.
- Why it cannot be a call (read off the numbers): backing the boxer warns the coach, and the coach coaches most of the gym - his
  10% work cost lands on every boxer he has, plus 13 weeks of a sulk. Backing the coach warns one boxer, and the game's own
  Loyalty refills her: +1 every full week (Loyalty.MOVES full_week), +2 a won bout. One coach serves many boxers; the trade is
  never even.
The coach game left for the build: the hire (F / K / NOHIRE / ... by cell), the trial week (see s5), the raise, the style push,
the course and the corner pick.

## 5. Bar 6 fails: the trial week (a bar v8 passed)
The trial costs one week of the favourite's wage and swaps to the second card when the favourite clashes with a boxer. It was right
in v8 where it swapped to L at $200 - the cheap superset (big_am +35.7, big_hot +35.8). With one wage rule L costs $480 and the
swap target is never a bargain: right only in big_title (S -> F, +9.0), wrong in nine (the week's wage alone, -0.4, where the
favourite shows no clash; -18 to -36 where the swap drops K's name fee). The line that fails: the trial's swap rule (map s3 + the
probe's blind pick "swap to the next card when the trial shows a clash"), not a number. Per the stop rule nothing was tuned.

## 6. Feedback loops (task "Feedback loops") and the trial
- Warning -> loyalty down -> the person leaves: careless line worst cell 1.05 people a career (stop at 3), careful 0.00 everywhere
  (stop at 1). People who left carrying a warning, cost on / off: careless big_hot 0.32 / 0.04 (the drain took Josh, hot-tempered,
  backed against every time), small_pro / big_pro 0.05 / 0, small_title 0.07 / 0.01; 0 elsewhere. Neither stop fired.
- Who carries the warnings: careful line - one warning a career at most (the film-room coach F refusing a push: small_am,
  small_pro_hot, big_title_mix, 100 of 100 careers); careless line - one person carries every warning (Lucy 79 of 79 careers in
  small_pro / big_pro, 75 of 75 small_title; Josh 100 of 100 big_hot): 4 cells of 10, not more than half. Stop did not fire.
- Wages -> cash: arm means hold (lowest mean end cash -$19.9k, K in small_novice; v8's range was -$26.5k). One single career, K in
  small_novice (a known name in a novice gym with no pro, the card that says it does not pay there), dips to -$42.5k.
- Members at the catchment in every arm, 0 months with two moments, bond max 0.25, chemistry max 0.72, one push a boxer a season.
- ONE-REP TRIAL (printed in full, trial_sum.txt): 6 of 7 (bar 3 failed). Trial stop checks: the best hire differed by cell (F / K);
  bars 4-7 passed. The falling-out's two backing answers differed by 0.0-0.3 lines in eight cells: change 3 did nothing at drain 1.
  Reason: a boxer on full weeks gains +1 loyalty a week (Loyalty.MOVES full_week), exactly the drain. TUNED once, inside the task's
  range: drain 1 -> 2 (net -1 a week for a boxer on full weeks, -2 for a coach), and the pop-up's "lasts about N weeks" counts the
  boxer's +1. trial2 gave the same scores: boxers sit at 75-100 loyalty by week 26, so even -26 over the fade does not reach 25,
  and one warning never makes a coach leave. No drain inside 0.5-2 can move the falling-out; the full run is the verdict.
- The careful line with the cost on scores ABOVE its cost-off arm in small_am (+19.9), small_pro_hot (+6.4), big_title_mix (+9.8):
  the drain moves its later answers (a drained coach sits near the line, so his next push is allowed, and allowing pays there).

## 7. Carried from v8 s6 (for the build, step 5 - the corner pick): the game's win read ignores the corner coach
- `BoutRead.chance(f, opp, camp, coach)` uses the coach only to write plan arrows for a boxer with NO plan (`_read_copy`,
  `CoachPlan.write`); every booked boxer has a plan, so the coach argument is dropped (it still changes the cache key).
- The between-round call `_call(f, n)` is `BoutRules.auto_corner(f["stats"])` and its uptake reads her coachability x trust: no
  coach rating, tactics or chemistry.
- The corner pick's build must wire: (a) `_call` takes the picked coach's call (his tactics deciding best / ok / wrong against the
  opponent, priced by `Exchanges.EDGE`, the probe's `corner_edge`); (b) the uptake x the pair's listen (1 + 0.4 x chemistry) and a
  warned boxer's 0.85, a clash ignoring one call; (c) the coach reaches the read when the boxer has a plan (a dict {tactics, playbook
  fit, chemistry}), with the cache key carrying it; (d) the corner coach's cutman and weight ratings reach the weigh-in miss chance.
- Until then the "about X%" line on the corner pick shows the same number for every coach.

## 8. Decided in this task (no questions asked)
- The wage formula's weights (teaching 4, pads 3 first, as the task said) and its three constants: $150 at P 9, $125 a point, $150
  an art (the sessional mat coach's price), $350 the name (keeps K inside interview 11's $800-1,100). Reid ($460 by the rule) and the
  sessional mat coach stay at $450 / $150: they are not cards.
- "Most of the gym's boxers" = the main coach of at least half the boxers still at the gym; the age-under-23 clause went (the task's
  sentence is the whole rule).
- The falling-out's careful line reads the pop-up's weeks: back whoever would reach the line sooner; both past the fade -> split.
- Drain 2 a week (s6). THE CUT's rule = "back the coach" (10 of 10). A cut run arg `cut=fall:back_coach` (also `push:<answer>`).
- No critic brief (`CRITIC_COACHDEEP9_BRIEF.md` is written only on PASS, per the stop rule).

## 9. Honest limits
- Greybox: v7/v8's limits stand (pro opponents from the top of the rival list, rank moves +1/-2, the corner priced by the probe).
- The wage rule's constants are mine; they set where every card lands. A different slope moves which card is best (F here); the
  formula itself, not a card, is what the owner should judge.
- Bar 6's failure follows from change 1 through the probe's blind swap rule; a trial that swaps by the shown words rather than to
  "the next card" was not tried (stop rule).
- Common bout dice across arms: a 0.3-line win counts as "best" under the tie rule (ties only within 0.01).
