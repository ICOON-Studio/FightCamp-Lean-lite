# BUILD1 critic brief (Kalli) - you are a FRESH critic: score a DESIGN for Puncher's chance (S570)

You judge a design page, not a build. It maps a fighter's body to a Breachway ship: cards live on the body parts, the deck
in the bout is what the body holds, three pools (conditioning, attack, defence) grow from 50 toward 100 with training. A
greybox probe (bots playing solved mixes) measured two rounds of it. Nobody has played it. The page is below in full,
after the facts about the game.

## The game (facts only: the critic pack, first part)
> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups and the eight MMA fighters. Written S403 from the code; update it when a mechanic or screen lands.

## What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with **To reach 10/10**: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.
**Also score SPEED and THE FIRST FIVE MINUTES** (S569, after the genre's reviews: players praise fast turns, a clean read of what the other side will do, and choices that each matter; they mark down slow turns, unclear results and choices that do not matter): seconds and clicks a turn (a beat) and whether that feels quick, and how far a new player gets in five minutes without help. Both on the 1-10 scale, with their own To reach 10/10 lines.


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

## 4. Every mech

## The fight page today (Puncher's chance, the boxing page the design builds on)
A beat: both men choose at once - a lead-hand card, a rear-hand card (or hold that hand high / low as a guard), and the
feet (step in / hold / back off), in an order of moments (fast punches land first). Three ranges (Inside, Mid, Long);
punches reach only some ranges. Health 18, stamina 8 (a body shot shortens the stamina bar for the bout), guard bar 6.
3 rounds of 6 beats; knockdowns and stoppages; judges score rounds 10-9. The hand of cards (picture cards) sits in a
strip Lead / Rear / Feet. An opponent plays a solved mix with a lean to his style and reads your habits.

## What to score (bar: 8+ on DEPTH and 8+ on PLAY or the mechanic does not stay; be blunt, a kind score is useless)
1. DEPTH (1-10): are there real, lasting decisions - in camp (which cards on which part, which pool to train) and in the
   bout (which part to protect, which card to spend)? Does the probe show the choices matter, or is one choice always right?
2. PLAY / fun (1-10): would a player enjoy building a fighter this way and fighting with that body? Is the "hand is the
   body, his punches take your cards away" idea fun or a chore?
3. GENERAL (1-10): clear, consistent with the game's rules and words, buildable from what exists, nothing useless.
4. SPEED (1-10): seconds and clicks a beat in the bout, and in the camp screen; does it feel quick?
5. THE FIRST FIVE MINUTES (1-10): how far does a new player get without help?
Also: which options a screen would be MISSING, which are useless, and what each changes (the game's critic rule).

## What you must return
- A score table (the five lines above, each with one line of why).
- **To reach 10/10** for EACH score: the concrete changes, most important first, each specific enough to build
  (numbers where you can). A score without this list is not finished.
- **Your 10/10, drawn**: ONE self-contained HTML page, 1920x1080, inline CSS only (no external files, no scripts needed),
  showing the camp screen where the player builds the body (parts, slots, pools) and a strip of the bout hand grouped by
  body part, the way YOU would make it to earn 10/10. Put it between the lines `<!-- PAGE START -->` and `<!-- PAGE END -->`.
  Plain words on screen; names only in headers; nothing drawn on top of the fighters.
- Plain words. The game is called Puncher's chance (never any other name).


---
# THE DESIGN PAGE (ops/research/DESIGN_BUILD1.md)
# DESIGN BUILD1 - the fighter's body as a ship: cards live on the body parts, the deck is what the body holds (S570)

Owner S569 (verbatim): "maybe Try scaling health and the other parameters to start at 50 (or 75) and possible to reach 100
later ... the energy management should be part of the decision making (maybe lower health limits your stamina pool orr
something) . Also consider this analogy with breachway : A fighters body similar as spaceship with variations , then you
can equip different discipline cards depending on your fighter and choices or progression so you will have those moves as
your deck in the fight like you do in breachway for each module , and you got to be careful which moves can blend and flow
etc . You may increase attacking action pool ,or defensive and body conditioning , analogy with the core and card mechanics
increase your earned resources in breachway." And: "we can use it as unique feature so that the player drafts his deck on
the spot , and of course not all move can be combined with others".

Status: design + greybox probe (two rounds) + critics. Nothing on any page or rule file changed. Puncher's chance, boxing first.

## 1. Breachway, read from the installed files (our words; nothing of theirs copied)
Read-only: identifiers in `Breachway_Data/il2cpp_data/Metadata/global-metadata.dat` (153,577 names) and our CARDREF1 notes
(the card table: 1,823 entries, each card rests 0 to 8 turns after use). What the structure says:
- **The ship is a set of mounts** ("hardpoints"). Each mount takes one family of part (an install type decides what fits).
- **A part carries card slots** (a base number of slots per part, more slots from upgrades and from crew) **and passive
  sub-slots** (small modifiers that change the part's cards). The deck in a fight = the cards the installed parts carry.
- **The core (the reactor) sets the economy**: energy made a turn, a ceiling on stored energy, a hand size. It can be
  upgraded, and it has a second purse (heat): spend past a line and you pay a penalty. Energy comes in kinds (three
  allocations are named), so a card asks for the right kind, not only an amount.
- **Cards rest after use** (a cooldown in turns), so the strong card is away for a known time.
- **Slots can be broken or disabled in a fight** (names for a broken slot, a damaged slot, a disabled slot): the enemy
  takes your cards away by hitting the part that carries them.
- **Parts and cards can be combined / merged** for a fee, and the game shows the combined result before you commit.
- **Crew** add slots and their own small energy pool.
How builds differ: which parts sit on which mounts (what kinds of card you can carry at all), how many slots each has, the
core's level (how much you can play a turn), and which cards you upgraded. A build is a set of trade-offs, never "more".

## 2. The map: the fighter's body = the ship
| Breachway | Puncher's chance | What it holds / does |
|---|---|---|
| mounts (hardpoints) | **five body parts**: Lead hand, Rear hand, Legs, Core (trunk), Head | each part takes only its own kind of card |
| card slots on a part | **discipline slots** | Lead: jab family, hooks, feint, push off. Rear: cross family, overhand, uppercut, body cross. Legs: footwork (and kicks when kickboxing comes). Core: clinch, body defence. Head: passives (chin, eyes) |
| the core / reactor | **conditioning (the engine)** | the health bar and the stamina bar |
| energy a turn | **attack pool** | stamina you may spend in one beat and the weight of your punches |
| shields / hull upgrades | **defence pool** | the guard bar (and, measured, what else it must buy: section 6) |
| a broken slot | **a hurt part** | body shots already shorten the stamina bar (the core is hit); kickboxing's low kick takes a Legs card away for the round; a hurt hand is rare (a cut, a bad hand) |
| upgrading a card | **drilling a card** in camp | +1 damage OR 1 less stamina (pad time: the game's decided "a new move is a weapon in 2-3 weeks of pad time") |
| a new slot | **a new weapon learned** | costs camp weeks, never wins |
| crew | **the coach** | a coach's speciality opens one slot of his kind (a boxing coach: a hand slot; a kickboxing coach: a Legs slot) |

**The base cards every body holds** (like the two free blocks in Mixed Martial Cards, so no hand is ever dead): jab, cross,
both guard holds, step in / hold / back off. The build ADDS discipline cards on top: three at the start of a career.

**What is new (why this is not one more deckbuilder, S551 "there are 1 million deckbuilding games")**: there is no draw and no
shuffle. The hand IS the body: every card is always visible on the part that carries it, and **the opponent's punches
take cards away by hurting the part** (the body shot that shortens your stamina is the first such link and is built
already). You do not build a deck; you build a fighter, and in the fight you defend the parts your best cards live on.

## 3. The three pools (his scale: start at 50, grow toward 100)
Shown as three numbers on the fighter's body card: **Conditioning, Attack, Defence**, each 50..100. The in-fight bar reads
the same scale (a 50-health man's bar says 50; damage shows in the same units). Engine: **75 = today's man** on the boxing
page (health 18, stamina 8, up to 6 stamina a beat, guard 6) - the probe's mapping, so 50 = two thirds of today's man.
- Conditioning: health and the stamina bar.
- Attack: how much stamina you may spend in ONE beat (50 = 4, 75 and up = 6: at 50 you throw one punch a beat, rarely two)
  and the weight of your punches (x attack / 75).
- Defence: the guard bar. **Measured: on its own it buys nothing** (section 6, v1). Round 3 makes it buy the chin.
His "lower health limits your stamina pool": measured in section 6 - as a straight link it halves the comebacks
(25% -> 11%), so it is NOT taken as written. RULES569 idea 3 owns the link on the page; this design keeps the body shot
(already built) as the one health-to-stamina link.

## 4. Blend and flow (the deck-building decision)
**Combination table** (two cards dropped on each other = ONE move in ONE moment; RULES569 idea 4 measures it on the page):
| Pair | Combines? | Why (boxing) |
|---|---|---|
| Step in + Jab | yes: the stepping jab | the jab is thrown on the step; the classic way in |
| Back off + Lead hook | yes: the pull counter | weight goes back, the lead hook comes round as he follows |
| Feint (lead) + Cross | yes: feint and cross | the feint draws the hands, the cross goes through the gap |
| Body hook + Lead hook | yes: up-and-down (two moments) | the same hand, body then head, the classic double |
| Two rear-hand punches | no | one rear hand, one moment |
| Back off + Overhand | no | the overhand needs weight moving forward |
| Clinch + any punch | no | both hands are holding |
| Push off + any lead punch | no | the lead glove is on his chest |
**Flow** (which card follows which in the next moment of a beat): jab -> cross, body -> head, feint -> anything. A body
that holds both ends of a flow pair plays it; the slot budget decides which flows you own. Flow bonuses are not measured
here (the page's order of moments already pays some: a counter after a block is +1).

## 5. How it plugs into what exists
- **The fight page** (order.html, the hand of cards S568 "i like the B", the strip Lead / Rear / Feet): the hand is grouped
  by body part on the body view (S561: the body view replaced the board). A hurt part greys its cards ("Legs hurt: no
  step in this round"). Nothing is drawn near the fighters (S562): the cards sit in the panels.
- **The gym side**: training focus raises a pool (the decided pace: 1.0 a focused week, headroom clamp), pad time drills
  a card (MoveMastery), camp weeks open a slot, the coach's speciality opens a slot of his kind. This is where the career
  and the fight finally meet: a week of training changes what the player can click in the next bout.
- **The styles = starting builds**: Outboxer (lead hand weapons, ring craft legs), Pressure fighter (hooks and body,
  stalking legs, the clinch), Generalist (more cards, none drilled). Kickboxing later adds Legs cards (kicks, checks):
  the same body, a new discipline's slots.
- **The ladder**: opponents carry builds and pools too, sized to the ladder (regional 50-60, national 70-80, pro debut 75-85).

## Feedback loops
- **Stronger build -> more wins -> more progression -> stronger build.** Caps: (1) opponents scale with the ladder (their
  pools and slots grow too: a 100 man meets 100 men); (2) slots are scarce - a slot costs camp weeks, never a win; at most
  3 discipline slots a part and 8 on the body; (3) drilling costs pad weeks the gym pays coach time for; (4) every pool
  stops at 100. Measured (v1): a 50 man v a 75 man wins 14%; 100 v 75 wins 58%; 100 v 100 wins 56 / 33 (11% draws) - the
  edge from growth is real and the ladder that grows with you cancels it.
- **Low health -> smaller stamina pool -> fewer actions -> more damage -> lower health** (his link). Floor: the stamina bar
  never drops below its minimum (today 4 of 8), stamina comes back every beat and at the bell. Measured: the share of men
  15%+ behind on health after round 1 who still win was 25% on today's rules and **11% with the link** - it fails the bar
  ("at least the boxing page's comeback share"). Not taken. A softer form (the link takes at most 2 off the bar) was
  queued and stopped by the PC's low-memory reaper before it ran.
- **Trial first**: one rep each (N=12, seed 1) of the outboxer and the pressure fighter mirrors ran before the probe: the
  two plan mixes differ (the outboxer: body cross 39%, holds his ground 41%; the pressure fighter: jab 38%, backs off 40%,
  body hook 29%, clinch 9%), so the probe went on.

## 6. The greybox probe (two rounds, measured)
Tool: `ops/research/s558_balance/build1_probe.mjs` (new; reads order.html's rules through rules.mjs; five small patches in
memory only: a deck filter per man, the spend cap a beat, the guard bar size, the stamina floor, punch weight). Both men
play the beat's solved mix; the look-ahead is today's vtable.json (made for two equal full-deck men - an approximation for
unequal builds). Builds: base cards + 3 discipline cards + 1 drilled card. n=36, seed 1, jobs=1 per cell. Full output:
`results/build1_v1.txt`, `results/build1_v2.txt`. Control: today's man (all 12 cards, 75 everywhere) in the same loop.

**Control (today's rules, 75 v 75, every card)**: 47 / 39 / 14 (wins / losses / draws), stoppages 14%, 2.3 knockdowns a
bout, Inside / Mid / Long 32 / 36 / 32%, comebacks 25%. The loop agrees with the page's own bars.

**v1** (outboxer: drilled jab, body jab, feint, body cross; pressure: drilled cheap hook, body hook, clinch; generalist
control: drilled cross, hook, body jab, body cross):
| Cell (all at 50) | A wins / B wins / draws | stoppages | knockdowns | plan-mix distance |
|---|---|---|---|---|
| outboxer mirror | 47 / 36 / 17 | 8% | 1.9 | 0.09 |
| pressure mirror | 39 / 50 / 11 | 0% | 0.5 | 0.15 |
| generalist mirror | 47 / 44 / 8 | 0% | 0.8 | 0.12 |
| outboxer v pressure | 53 / 47 / 0 | 0% | 0.8 | **1.25** |
| outboxer v generalist | 28 / 58 / 14 | 8% | 1.5 | 0.70 |
| pressure v generalist | 36 / 56 / 8 | 0% | 0.6 | **1.30** |
| every card at 50 (control at 50) | 53 / 42 / 6 | 8% | 1.5 | 0.14 |
Growth (pressure fighter): 50 v 75 wins 14% (stopped 31%); 100 v 75 wins 58%; 100 v 100 56 / 33 / 11.
Where to put 50 points (a 100-50-50 man v a 67-67-67 man): into conditioning 33%, **attack 56%, defence 19%**.

**v2** (fixes tried: a Legs card per style - the pressure fighter may step in after your jab landed, the outboxer may back
off once more on the ropes; the generalist gets 4 cards and no drill; defence takes weight off the punches that land):
| Cell (all at 50) | A / B / draws | stoppages | knockdowns |
|---|---|---|---|
| outboxer mirror | 50 / 50 / 0 | 69% | 3.8 |
| pressure mirror | 36 / 56 / 8 | 67% | 3.9 |
| generalist mirror | 50 / 44 / 6 | 42% | 2.8 |
| outboxer v pressure | 64 / 31 / 6 | 36% | 2.7 |
| outboxer v generalist | 47 / 47 / 6 | 64% | 3.7 |
| pressure v generalist | 42 / 50 / 8 | 25% | 2.2 |
Spread: 100-50-50 v 67-67-67: conditioning 17%, attack 28%, defence 28% - spreading evenly beats any choice. 50 v 75: 0%.

**What the probe says**
1. **The builds play differently - yes.** Two builds against each other share far less of their plan mix (distance 0.7 to
   1.3) than a build against itself (0.1 to 0.2). The body-as-ship map makes styles real in the bout, not a label.
2. **A deck that is part of another is beaten by it** (v1 trial at the old scaling: the outboxer's 6 cards v every card won
   25%). In a game of solved mixes more cards is never worse, so the full deck can never exist: slots must be scarce and
   every build an equal budget. Designed in.
3. **The pool scale decides how violent a bout is.** v1 (punch weight with attack, health with conditioning) keeps 50 v 50
   quiet - 0 to 8% stoppages (bar 10-40%); v2 (defence also takes weight off) makes it 42 to 69%. The number between lies
   in the weight curve, not in the map.
4. **Defence as a bar buys nothing; spreading must not beat choosing.** v1: defence 19% v attack 56%. v2: even spread
   beats every choice. A pool must pay in a way the others cannot - round 3 below.
5. **Dead cards**: the pressure fighter's lead hook is chosen in 0-3% of beats in every cell (drilled or not), the
   overhand 0-1% at 50 (attack 50 caps a beat at 4 stamina: the 3-stamina overhand leaves no feet). The pressure mirror
   drifts to Long (46-51% of beats): the stalking Legs card did not make pressure press.
6. **His health-to-stamina link halves comebacks** (25% -> 11%): not taken as written.
7. Growth changes outcomes the way a career should: 50 v 75 is a heavy loss (14%, v2 0%), 100 v 75 a clear win, a ladder
   that grows with you stays level.

## 7. Round 3 (the design as it now stands, to be measured next)
- **Pools pay in kind, with thresholds (Breachway: the core's level gates what you can mount)**: Attack 60 opens a 2nd
  punch a beat (spend 5), 75 opens the big punches (overhand, rear uppercut). Defence buys the CHIN: get-up health after
  a knockdown (x defence / 75) and the guard bar; Conditioning buys health and the stamina bar. So spreading evenly leaves
  you without the threshold cards - a choice with a cost.
- **Weight curve**: punch weight = attack / 75, health = 18 x (conditioning + 75) / 150 (50 = 15 health), so 50 v 50 sits
  inside 10-40% stoppages.
- **Pressure's card**: the stalking Legs card ALSO takes one ground step from him when you step in and he backs off (the
  cut-off), and the lead hook is replaced in the pressure build by the up-and-down pair (body hook -> lead hook, one card).
- **The hurt part** (the innovation measured): a landed body shot greys one Core card for the round (the clinch) as well as
  shortening the stamina bar - measured only after the above holds.
- Bars for round 3: every build mirror inside the page's bars; each cross-match 35-65%; the three styles form a cycle or
  sit within 40-60% of each other; no card under 3% in its own build; where-to-put-50 points: each choice 35-65% v the
  even spread; comebacks at least 20%.

## 8. Critics
See `BUILD1_CRITIC_*.md` (two fresh critics, one code-checked). The verdict and the last line follow at the end of this page.

