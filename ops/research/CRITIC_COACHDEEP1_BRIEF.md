# COACHDEEP1 - score this mechanic's DESIGN (fresh critic, S539)

You are a fresh critic: a sports management-sim designer who knows boxing and Football Manager's staff model. Read the whole
game first (the critic pack below: facts only, no scores), then what a critic can open, then the design map and its greybox
probe at the end. Judge the MECHANIC, not the look of any screen. You have seen no earlier review of it; do not look for one
(no file named *_CRITIC_*).

Score, each out of 10, with the reasons, on its own line as `SCORE depth=<n> play=<n> general=<n>`:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
3. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
The bar (owner S534: "mechanics need an 8 critic's to stay in the game for depth and fun"): 8 or more on DEPTH and 8 or
more on PLAY. Below that, say whether you would cut the mechanic, keep it, or what must change.

Also answer (owner S403): which options are MISSING, which are USELESS, and what each option changes in the game.

The owner asked for this (S539): "why not make proper coaches like fottball manager and use them more to tighten and improve
the core loop ?" and "make him more deep , what he know how he mix with fighters and different personalities , his playbook ,
needs proper attributes and personality". Judge HOW the map does it, not whether coaches should be people.

Judge the central claim hardest: that WHO COACHES WHOM, each week, with fewer coached evenings than the boxers want, is a real
choice - the right coach depends on the boxer (style, personality, age, art), and no simple rule of thumb wins nearly always.
The probe says "pair by chemistry" is best in 6 of 10 coach pairs (8 of 10 with the rule that also uses chemistry). Is that a
choice or a solved puzzle? Which rule do you think a player would find, and how fast?

READ THE CODE. Every line the map tags CODE names a file and a line. If you can open the repository (main, 2026-11-23 or
later; say which commit you read), open each and say whether the code does that; read tools/coachdeep1.gd and
tools/coachdeep1_rules.gd too (the probe and its rules). List every claim that is wrong and which files you read. If you
cannot open files, check the map against the excerpts below and the pack, and say plainly that you could not open the rest.
Never guess a code fact.

Judge the probe too (the result at the end): are the bars the right ones, could each pass while the mechanic is still shallow
(the result names three ways it might), and what would you measure instead.

End with **To reach 10/10** (owner S405): the concrete changes that would take it from your score to 10, most important
first, each specific enough to build. A score without that list is not finished.
Then DRAW your 10/10 (owner S411): one complete, self-contained HTML page, 1920x1080, of the screen where this mechanic
matters most (inline CSS, no scripts, no outside files). We render it with `tools/render_mockup.py`. Put it in one code
block at the very end.

Plain words. Names only in headers (the body says "your boxer", "the coach", "the opponent"; no fixed he or she for a boxer).
Real-world boxing evidence where it helps. Change nothing in the repository; never run Godot; open images with a file tool only.

## Code excerpts (for a critic who cannot open the repository; read 2026-11-23)
`scripts/state/Career.gd:23`
```
@export var coach: Dictionary = {}
```
`scripts/state/Sim.gd:475-480`
```
static func hire(career: Career, coach_id: String) -> Dictionary:
	var c := Data.coach(coach_id)
	if c.is_empty() or not career.coach.is_empty():
		return {}
	career.coach = c
	career.pay(-GameMoney.COACH_SIGNING_FEE, "Signing fee: %s" % c["name"])
```
`scripts/state/Data.gd:33-40`
```
const COACHES: Array[Dictionary] = [
	{"id": "reid", "name": "Luke Reid", "kind": "Sessional assistant coach", "salary": 450, "rating": 58, "spec": "Pad work",
		"note": "three evenings a week",
		"areas": {"pads": 74, "bag": 64, "sparring": 58, "conditioning": 48, "strength": 46}},
	{"id": "hale", "name": "Marcus Hale", "kind": "Full-time assistant coach", "salary": 1090, "rating": 74, "spec": "Conditioning",
		"note": "every day, better gains",
		"areas": {"conditioning": 90, "strength": 84, "bag": 72, "sparring": 66, "pads": 58}},
]
```
`scripts/rules/CoachAreas.gd:63-64`
```
static func lift(rating: float) -> float:
	return (0.5 + rating * 0.7 / 100.0) / ALONE_FACTOR - 1.0
```
`scripts/rules/MoveMastery.gd:66`
```
	var dm: float = rate * (minutes / 60.0) * (float(station_tier) / 2.0) * (1.0 + 0.40 * coach_skill / 100.0) * maxf(0.0, 1.0 - m / cap_value) * clampf(efficiency, 0.0, 1.0)
```
`scripts/state/DrillWeek.gd:159-160`
```
static func pad_skill(career: Career) -> float:
	return float((career.coach.get("areas", {}) as Dictionary).get("pads", career.coach.get("rating", 0.0)))
```
`scripts/rules/CoachPlan.gd:27`
```
const READ_AT := [50.0, 70.0]
```
`scripts/rules/BoutRead.gd:271-272`
```
	if (fx.get("arrows", []) as Array).is_empty():
		fx["arrows"] = CoachPlan.write(str(opp.get("style", "")), coach, fx.get("moves", {}), fx.get("combos", {}), fx.get("steps", {}))
```
`scripts/rules/FighterProfile.gd:7`
```
const TRAITS: Array = ["heart", "temper", "confidence", "discipline", "coachability", "loyalty"]
```
`scripts/rules/FighterProfile.gd:39`
```
const TRUST := {"Fired up": 1.05, "Steady": 1.0, "Flat": 0.85, "Low": 0.7}
```
`scripts/rules/WeighMiss.gd:16-28`
```
const TOUGH := ["Slugger", "Pressure fighter"]


## The other corner's answer. over = kg over the limit (> 0), roll in [0, 1).
static func answer(over: float, opp_style: String, roll: float) -> String:
	if over <= FIGHT_UP_TO:
		return "fight"
	if over > WALK_OVER:
		return "walk"
	var p_walk := (over - FIGHT_UP_TO) / (WALK_OVER - FIGHT_UP_TO)
	if TOUGH.has(opp_style):
		p_walk *= 0.5
	return "walk" if roll < p_walk else "terms"
```
`scripts/rules/OppFile.gd:135-142`
```
static func tape(opp: Dictionary) -> String:
	var left := hidden(opp)
	if left.is_empty():
		return ""
	var id := str(left[0])
	open(opp, id)
	return id
```


## What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with **To reach 10/10**: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.

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


# THE DESIGN MAP TO JUDGE

# DESIGN_COACHDEEP1 - coaches as people (Football Manager depth), from the code (S539)

Owner, S539: "why not make proper coaches like fottball manager and use them more to tighten and improve the core loop ?";
"make him more deep , what he know how he mix with fighters and different personalities , his playbook , needs proper
attributes and personality"; on the pro weigh-in pop-up: "can the 'their corner' be hyperlinked to their coach so you can
quickly see what his coach is good at and get some clues ?".
Task: ops/research/TASK_COACHDEEP1.md. Probe: tools/coachdeep1.gd + tools/coachdeep1_rules.gd, result docs/COACHDEEP1_RESULT.md.
Every line tagged CODE was read on 2026-11-23 at the file:line named. Lines tagged NEW are this design; ESTIMATE = a probe value.

## 0. Why the last coach design failed, and what is different here
- CODE docs/COACHHIRE1_RESULT.md (S538): a second coach as a stat multiplier plus a wage was never a choice - with one boxer the
  wage only closed the gym sooner; CoachMarket and CoachFit were removed. Its own limit: "a coach matters when coaching TIME is
  short (three or four boxers sharing one coach's evenings)".
- NEW: the choice here is not "hire or not" but WHO COACHES WHOM, every week, with fewer coached evenings than the boxers want.
  A coach is a person with a way of boxing and a temper; the same coach is right for one boxer and wrong for the next.

## 1. What the game has today (CODE)
- One coach per club: `Career.coach` is one Dictionary (scripts/state/Career.gd:23); `Sim.hire` refuses a second
  (scripts/state/Sim.gd:475-479). `Career.extra_coaches` (Career.gd:69) is an evening-class count, not a person.
- The coach is numbers only: `Data.COACHES` (scripts/state/Data.gd:33-40) - Reid and Hale, a rating, a spec, five areas
  (pads, bag, sparring, conditioning, strength). No personality, no playbook, no knowledge.
- Areas lift training: `CoachAreas.lift` (scripts/rules/CoachAreas.gd:63) = (0.5 + r x 0.7 / 100) / 0.6 against training
  alone (ALONE_FACTOR 0.6, :8). Pads teach moves: `MoveMastery.gain` x (1 + 0.40 x coach skill / 100)
  (scripts/rules/MoveMastery.gd:66), the skill read by `DrillWeek.pad_skill` (scripts/state/DrillWeek.gd:159).
- The coach writes her plan when the player writes none: `CoachPlan.write` (scripts/rules/CoachPlan.gd:65), one card read at
  rating 50 and two at 70 (READ_AT, :27); `BoutRead.chance`'s `coach` argument feeds it (scripts/rules/BoutRead.gd:272, :382).
- Film opens the opponent's file: `OppFile.tape` (scripts/rules/OppFile.gd:135), `known` (:120), `film_depth` (:209).
- The boxer is a person already: `FighterProfile.TRAITS` heart, temper, confidence, discipline, coachability, loyalty
  (scripts/rules/FighterProfile.gd:7); trust in the corner by mood `TRUST` (:39); "overruled" hurts a low-coachability boxer
  more (:163); a Low boxer stops taking in the corner (`CornerTrust.lands`, scripts/rules/CornerTrust.gd:11); the corner's
  word lands by coachability (`Exchanges.uptake`, scripts/rules/Exchanges.gd:249).
- Coached mornings are dealt by the coach (`CoachedMornings.week_deal`, scripts/rules/CoachedMornings.gd:142; `owned` :34).
- The other corner is a style only: the weigh-in answer reads the OPPONENT's style (`WeighMiss.answer` / TOUGH,
  scripts/rules/WeighMiss.gd:16-20, called from scripts/state/WeighMissWire.gd:29); the pop-up says "THEIR CORNER ANSWERS"
  (scripts/ui/modals/WeighIn.gd:46). REPEATBITE's read speed depends on the opponent's rating, not a coach
  (tools/repeatbite1_rules.gd:16-22, IQ_AT 65).
- The player's own background already follows "one clear edge" (`HeadCoach`: free_tells :65, cut_kcal :79).
- Staff cards list `Data.COACHES` (scripts/ui/StaffCard.gd:53, scripts/ui/OfficeDesk.gd:356).

## 2. The coach (NEW)
### 2.1 Attributes, 1-20 (eight, each wired to a rule that exists)
| Attribute | What it changes | Wired to (CODE) |
|---|---|---|
| Pads | moves learned on his pad nights | MoveMastery.gain coach_skill (MoveMastery.gd:66) via DrillWeek.pad_skill (DrillWeek.gd:159), per boxer instead of per club |
| Conditioning | engine gains on his sessions | CoachAreas.lift on the conditioning / strength areas (CoachAreas.gd:63) |
| Tactics | how many cards his plan reads | CoachPlan.write rating (CoachPlan.gd:27, :65), BoutRead.chance coach (BoutRead.gd:382) |
| Film | tells opened before a bout | OppFile.tape sessions (OppFile.gd:135): 8+ one, 14+ two (ESTIMATE) |
| Weight | the miss chance on a cut | the cut's daily kcal, as HeadCoach.cut_kcal (HeadCoach.gd:79); upstream of WeighMiss (WeighMiss.gd:20) |
| Cutman | guard recovery between rounds | GuardState recovery (scripts/state/GuardState.gd:124) - PHASE 2, not probed |
| Motivation | weekly morale on his boxers | FighterProfile morale (FighterProfile.gd:147) |
| Teaching young | learning for boxers under 21 | the learning multiplier (NEW), Kira 18 in the test club |
x5 = the game's 0-100 rating, so today's Reid (pads 74) reads Pads 15. One overall number stays for old readers (Data.gd:33 note).

### 2.2 What he knows
- Arts: boxing, BJJ (no-gi), later MMA. A coach who does not know the art teaches it at training-alone rate (probe: the Ana
  column; the only BJJ coach is C). Moves he knows: his best two punches drill at full pads, the rest at 80% (PHASE 2).
- Styles he reads best: his playbook's style; his film opens one more tell against it (PHASE 2).

### 2.3 His playbook (his way of boxing)
- One of: outbox ("jab and move"), pressure ("walk them down, body"), counter ("make them miss, pay them"), later volume.
- Fit with her style (FIT table, tools/coachdeep1_rules.gd): +1 his way, -1 against it. Learning x (1 + 0.15 x fit); his plan
  reads x (1 + 0.20 x fit) (ESTIMATE). A pressure coach on an out-boxer teaches slower and plans worse; on a presser, faster.
- Shown as his PLAN LINES: the arrows he writes first (CoachPlan.write's cards in his style's order) - the player sees what
  "his" plan for her would be on the Plan screen before choosing who corners her.

### 2.4 Personality and how he mixes
- Coach traits (0-100): temper, discipline, patience (+ ambition and loyalty for PHASE 3 careers).
- Chemistry -1..+1 from the two people (rules copy `chemistry`): two short fuses -0.4; a shouting coach folds a soft heart
  (heart < 45) -0.3; a hard heart likes a hard voice +0.2; strict coach + undisciplined boxer -0.25 (or +0.1 if she is very
  coachable); both disciplined +0.2; patience builds a doubter (confidence < 45) +0.3, impatience -0.25; a calm voice cools a
  hothead +0.15; positives scale with her coachability.
- Effects: learning x (1 + 0.30 x chemistry); morale +3 x chemistry a fully coached week, plus his motivation; her mood sets how
  much she takes in (FighterProfile.TRUST, FighterProfile.gd:39). Low for 6 weeks running: she leaves (the probe's stand-in for
  Loyalty.leaves, scripts/rules/Loyalty.gd:202).
- The BOND: +0.01 chemistry a week together, up to +0.25; fades 0.005 a week apart. Moving a boxer between coaches costs it.
- A clash is VISIBLE: the coach card's "with her" line (Good / Fine / Rubs her wrong, with the one reason in words: "he shouts,
  she folds"), her mood arrow, and the week review's "learned slower: wrong voice".

### 2.5 Time - the core choice
- Each coach has evenings a week (sessional 3, full time 5). Each boxer wants her three pad nights coached (PadWeek's
  Mon/Wed/Fri). Four fighters want 12; two sessional coaches give 6. The Week board assigns: drag a coach onto a boxer's night.
- An evening without a coach is training alone (CoachAreas ALONE). Her corner on fight night = the coach with most of her
  evenings that week (he writes the plan and watches the film).

### 2.6 The other corner (PHASE 2)
- Opponents' coaches on the same model; "THEIR CORNER" on the weigh-in pop-up opens a card: Tactics (how fast they adjust in
  round 2), Film (how fast they read a repeated combination - REPEATBITE's read: one throw sooner at Film 14+, replacing the
  opponent-rating rule tools/repeatbite1_rules.gd:22), Weight (their own boxer's miss chance), Temper (walks or takes terms on a
  weigh-in miss - WeighMiss.answer reads their corner's temper instead of TOUGH styles). Only lines the player can act on.

### 2.7 Careers (PHASE 3, sketch only)
Reputation grows with his boxers' wins; a rival gym offers him a job (poaching); a retired boxer of yours becomes a coach with
her own style as his playbook (MMA Empire, MMAEMPIRE1_COMPARE.md s1; MMA Fighter: Road to Champion's mentor); wages by reputation.

## 3. Every menu it appears on, and what each is wired to
| Menu | What shows | Wired to |
|---|---|---|
| Staff (StaffCard.gd:53) | the coach card: eight attributes 1-20, arts, playbook, three traits, evenings used/free | Data coach row (new fields) |
| Staff -> coach card -> boxers | one row per boxer: chemistry word + reason, fit word, bond weeks | rules chemistry / fit / bond |
| Week board (Training) | each pad night: who coaches it; drag to change; unfilled = "alone" | the week's assignment -> DrillWeek.pad_skill per boxer |
| Boxer card | "her coach", chemistry word, mood arrow with the coach's share | morale_week |
| Plan screen | "his plan for her": the arrows CoachPlan.write would write at his tactics and fit | CoachPlan.write (CoachPlan.gd:65) |
| Fight week | who corners her; his film = tells opened; his weight = miss chance on the cut line | OppFile.tape, cut kcal |
| Week review | learned faster/slower and why (coach, fit, chemistry); bond up | the week's multipliers |
| Weigh-in pop-up (PHASE 2) | THEIR CORNER links to their coach card | WeighMiss.answer by their temper |
| Hire screen | candidate coaches with the same card; wage | PHASE 2 (prices) |

## 4. Phase plan
1. YOUR COACHES (this probe's lever): coach model, two coaches, per-boxer assignment on the Week board, chemistry, fit, bond,
   per-boxer pads skill and corner. Golden path: assign, see learning and mood change, fight with his plan.
2. THE OTHER CORNER: opponents' coach cards, their weigh-in answer, their read speed, cutman.
3. CAREERS: hiring market priced by reputation, poaching, retired boxer -> coach.

## 5. Cut list
- Coach "rating" as the main number: kept only for old readers; never shown.
- CoachMarket / CoachFit (already removed S538): not brought back - their hire-as-multiplier was the failed lever.
- A coach that is better at everything: no. The probe's coach A (Pads 15, patient) was the better coach for all three boxers in 3 of
  the 4 pairs he is in (see the result): wages must scale with ability, or the pair choice is solved by the hire screen.
- Ambition / loyalty traits until PHASE 3 (nothing uses them before careers).

## 6. The probe (summary; details docs/COACHDEEP1_RESULT.md)
10 coach pairs x 6 assignment rules x 30 paired careers x 104 weeks, the test club, the game's fight read. All five bars
PASS: no rule best in more than 6 of 10 cells (chemistry-first 6, expected-learning 2, numbers 1, star-first 1); chemistry moves
a line in 10 of 10; the right coach differs by boxer in 9 of 10 (5 of 10 without Ana's BJJ); best beats "everyone the same"
by 11-20 lines in 10 of 10. Caveats in the result: chemistry's size is an ESTIMATE, losing a boxer is too cheap in the score.


# THE GREYBOX PROBE AND ITS RESULT


Task: ops/research/TASK_COACHDEEP1.md. Design map: ops/research/DESIGN_COACHDEEP1.md. Probe: tools/coachdeep1.gd + the rules
copy tools/coachdeep1_rules.gd. Nothing under scripts/ changes.

## 1. What is probed (the core lever only)
Two coaches with different attributes, playbooks and personalities share SIX coached evenings a week between the TEST CLUB's
four fighters, who want EIGHT (two pad nights each). The player's choice each week: which coach takes which boxer. The probe
asks whether that choice is real: does it depend on the coaches and the boxers, does chemistry move results, and does a
thought-out week beat "everyone gets the same".

Population: TestClub.make on Career.quick_start (Lucy wlw Out-boxer, Kira wfw Out-boxer aged 18, Josh mww Pressure fighter,
Ana no-gi), their own personalities. Cells: the 10 pairs of five coaches (A pad man, B engine room, C mat and gloves - the only
one who knows BJJ, D film room, E fire starter). 104 weeks, a bout every 4 weeks each (staggered), her division's named rivals
(Data.DIVISION_RIVALS) in rising order, each three times. The fight is the game's read (BoutRead.chance), with her corner's
plan written by CoachPlan.write at his tactics rating and his film opening OppFile tells; the dice fall on the fight day.
Paired arms: one rng per (rep, fighter, bout, event), the same in every arm. 30 reps a cell.

Arms (assignment rules, every week): LAZY (everyone the same: each coach's evenings split evenly over all four), STAT (best
pads/conditioning numbers first), CHEM (best chemistry + playbook fit first), NEXT (whoever boxes soonest gets the best
tactics + film), STAR (highest potential gets the best pads), SMART (expected learning: numbers x chemistry x fit x youth x
mood). Controls: CHEMOFF (the cell's best arm with chemistry and the bond set to 0) and ALL_x (one coach takes all four,
capacity ignored: which coach is right for each boxer).

A line = $1,000, 3 reputation, 0.5 of a win less loss, or 5 morale (the task's own units). Score = the sum in lines.

## 2. Bars (written before the run, not loosened)
- (a) No single assignment rule is the best arm (by score) in more than 6 of the 10 cells.
- (b) Chemistry moves an outcome by a line (cash $1,000, reputation 3, win less loss 0.5, or morale 5; best arm v CHEMOFF,
  paired) in at least 5 of the 10 cells.
- (c) The right coach differs by boxer (ALL_x v ALL_y per boxer: at least one boxer prefers each coach) in at least 5 cells.
- (d) The best arm beats LAZY by at least one line of score in at least 5 cells.
- (e) Every effect counted in (b), (c) and (d) is larger than 2 standard errors (paired); a cell whose effect is inside
  2 errors does not count.
PASS = all five.

## 3. Result: PASS on all five bars
Raw: E:/FightCamp/tmp/coachdeep1/full.jsonl (10 cells, 30 reps, 347 s, 0 script errors), run through godot_slot. Scores are
in lines (mean over 30 paired careers); ± is one standard error of the paired difference.

| Bar | Needed | Got | |
|---|---|---|---|
| (a) no rule best in more than 6 of 10 | <= 6 | CHEM 6, SMART 2, STAT 1, STAR 1 | PASS (on the edge) |
| (b) chemistry moves a line | >= 5 cells | 10 of 10 | PASS |
| (c) the right coach differs by boxer | >= 5 cells | 9 of 10 (CD fails) | PASS |
| (d) best beats LAZY by a line | >= 5 cells | 10 of 10 (+10.8 to +20.0) | PASS |
| (e) every counted effect > 2 errors | - | applied in (b), (c), (d) | PASS |

### 3.1 Score by arm (lines)
| Cell | LAZY | STAT | CHEM | NEXT | STAR | SMART | best | best − LAZY (lines) |
|---|---|---|---|---|---|---|---|---|
| AB | 109.8 | 125.0 | 124.4 | 109.9 | 111.4 | 118.7 | STAT | +15.2 ± 3.3 |
| AC | 112.1 | 120.9 | 131.8 | 117.3 | 123.8 | 126.6 | CHEM | +19.7 ± 3.3 |
| AD | 111.8 | 118.9 | 118.9 | 113.3 | 123.9 | 121.2 | STAR | +12.1 ± 2.5 |
| AE | 108.2 | 115.7 | 128.2 | 108.3 | 115.7 | 122.6 | CHEM | +20.0 ± 2.7 |
| BC | 105.5 | 104.8 | 119.6 | 111.7 | 118.9 | 120.0 | SMART | +14.5 ± 2.9 |
| BD | 106.7 | 102.8 | 121.3 | 114.8 | 102.8 | 121.3 | CHEM | +14.5 ± 2.2 |
| BE | 101.0 | 113.5 | 117.6 | 102.8 | 102.1 | 112.3 | CHEM | +16.6 ± 2.1 |
| CD | 110.2 | 119.8 | 125.4 | 112.2 | 117.7 | 125.4 | CHEM | +15.2 ± 2.4 |
| CE | 111.6 | 111.6 | 121.8 | 110.7 | 117.0 | 122.4 | SMART | +10.8 ± 2.2 |
| DE | 106.3 | 107.8 | 125.2 | 107.3 | 115.4 | 125.2 | CHEM | +18.9 ± 2.2 |

### 3.2 Chemistry on v off (the cell's best arm, paired)
| Cell | best arm | cash $ | reputation | win less loss | morale | lines moved (> 1 line and > 2 errors) |
|---|---|---|---|---|---|---|
| AB | STAT | -975.0 ± 305.2 | +4.6 ± 1.7 | +2.2 ± 0.5 | +7.5 ± 1.0 | rep, wl, morale |
| AC | CHEM | +0.0 ± 0.0 | +3.5 ± 1.3 | +1.0 ± 0.4 | +4.9 ± 0.4 | rep, wl |
| AD | STAR | +0.0 ± 0.0 | +7.2 ± 1.5 | +2.1 ± 0.4 | +7.0 ± 0.2 | rep, wl, morale |
| AE | CHEM | +0.0 ± 0.0 | +4.7 ± 1.5 | +1.3 ± 0.4 | +8.3 ± 0.4 | rep, wl, morale |
| BC | SMART | -15.0 ± 15.0 | +3.3 ± 1.1 | +1.0 ± 0.3 | +5.1 ± 0.1 | rep, wl, morale |
| BD | CHEM | +345.0 ± 190.2 | +3.8 ± 1.4 | +0.8 ± 0.5 | +9.3 ± 0.5 | rep, morale |
| BE | CHEM | -1290.0 ± 244.8 | +2.2 ± 1.1 | +1.8 ± 0.3 | +1.6 ± 0.6 | cash, wl |
| CD | CHEM | +0.0 ± 0.0 | +3.0 ± 0.9 | +0.9 ± 0.3 | +5.1 ± 0.2 | rep, wl, morale |
| CE | SMART | +0.0 ± 0.0 | +2.6 ± 0.8 | +0.7 ± 0.2 | +5.3 ± 0.2 | wl, morale |
| DE | CHEM | +0.0 ± 0.0 | +4.2 ± 1.2 | +1.2 ± 0.4 | +8.5 ± 0.2 | rep, wl, morale |

### 3.3 Which coach for which boxer (ALL_first minus ALL_second, per boxer score in lines)
| Cell | Lucy | Kira | Josh | Ana | coaches preferred (significant) | differs? |
|---|---|---|---|---|---|---|
| AB | +24.9 ± 2.5 | +15.2 ± 2.1 | +2.1 ± 0.6 | -3.8 ± 1.0 | Ana B, Josh A, Kira A, Lucy A | yes |
| AC | +7.4 ± 2.2 | +9.6 ± 1.6 | +4.3 ± 0.9 | -18.8 ± 1.8 | Ana C, Josh A, Kira A, Lucy A | yes |
| AD | +9.0 ± 1.7 | +14.5 ± 1.7 | +4.7 ± 0.8 | -4.1 ± 1.2 | Ana D, Josh A, Kira A, Lucy A | yes |
| AE | +16.1 ± 2.4 | +12.2 ± 1.7 | -6.4 ± 0.9 | +7.9 ± 1.5 | Ana A, Josh E, Kira A, Lucy A | yes |
| BC | -17.5 ± 1.7 | -5.6 ± 1.9 | +2.2 ± 1.0 | -15.1 ± 1.8 | Ana C, Josh B, Kira C, Lucy C | yes |
| BD | -15.9 ± 1.9 | -0.7 ± 1.8 | +2.5 ± 1.0 | -0.3 ± 1.3 | Josh B, Lucy D | yes |
| BE | -8.8 ± 1.6 | -3.0 ± 1.9 | -8.5 ± 1.0 | +11.7 ± 1.7 | Ana B, Josh E, Lucy E | yes |
| CD | +1.6 ± 1.0 | +4.9 ± 0.5 | +0.4 ± 0.6 | +14.8 ± 1.3 | Ana C, Kira C | no |
| CE | +8.7 ± 1.1 | +2.6 ± 0.7 | -10.7 ± 1.2 | +26.7 ± 2.2 | Ana C, Josh E, Kira C, Lucy C | yes |
| DE | +7.1 ± 1.4 | -2.3 ± 0.6 | -11.0 ± 1.2 | +12.0 ± 2.0 | Ana D, Josh E, Kira E, Lucy D | yes |

## 4. Read it honestly (what the PASS does not prove)
1. Bar (a) passes on the edge, and the two rules that use chemistry (CHEM, SMART) are best in 8 of 10 cells. "Pair by
   chemistry" is close to a dominant rule of thumb. It is not the best everywhere (STAT in AB, STAR in AD), but a critic
   should judge whether 6 of 10 is a choice or a solved puzzle.
2. Chemistry's size is mine (learning x (1 + 0.30 x chemistry), morale +3 a week): an ESTIMATE. Bar (b) shows the lever CAN
   move a line at these sizes; it does not show the sizes are right. Halve them and (b) may still pass on morale only.
3. Leaving is too cheap in the score. In the best arms one boxer leaves in many careers, and it is always Kira (heart 36,
   18, mostly losing bouts): check run E:/FightCamp/tmp/coachdeep1/who.jsonl (cells AC, BC, BE: Kira left 13-30 of 30
   under CHEM and SMART in all three cells and under STAT in BE; never under LAZY in those three - in the full run LAZY loses a boxer only in BD). Her bouts were mostly losses, so losing her costs the score little. Diagnostic
   (not the verdict, bars unchanged): charging 10 lines a departure leaves the best rules CHEM 6, STAR 2, SMART 1, STAT 1 and
   best > LAZY in 10 of 10; charging 20 lines spreads them further (STAR 4, CHEM 2, STAT 2, SMART 1, NEXT 1), best > LAZY
   in 10 of 10. The game must price a departure (Loyalty.leaves, the stipend sunk, the boxer's future) before build.
4. Bar (c) leans on Ana: a coach who does not know BJJ cannot teach her, so she always prefers the BJJ coach. Without Ana the
   right coach differs by boxer in 5 of 10 cells (AE, BC, BD, CE, DE) - exactly the bar. Coach A (Pads 15, patient) is the
   better coach for all three boxers in AB, AC and AD: an all-round good coach solves the pair. Wages must scale with ability.
5. Not probed: cutman, the other corner, hiring prices, wages (both coaches are paid in every arm, so wages cancel), the
   pro side. Cash moves only by weigh-in misses and departures (ticket cuts), so cash is the weakest line here.
6. Greybox simplifications: Ana's match is a logistic on the gap (no BJJ read in BoutRead); training is a rules copy of the
   decided pace (1.0 a focused week at a 58 coach, headroom clamp) with CoachAreas.lift and MoveMastery.gain from the game.

## 5. What this means for the design
The core lever is real at these sizes: who coaches whom moves 11-20 lines over two years against "everyone the same", and
the right answer depends on the people. Before build: (1) price a boxer leaving; (2) give wages by ability so one coach is
not best for all; (3) shrink chemistry until "pair by chemistry" is best in at most half the cells while (b) still passes -
a second probe round, measured. Critics are queued on the map (ops/research/CRITIC_COACHDEEP1_BRIEF.md: kalli, dola).
