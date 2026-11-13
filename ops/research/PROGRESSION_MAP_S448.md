# PROGRESSION: what the player is eager to unlock, week by week, season by season, across a career (design map v2, S448)

Owner, verbatim: "the player needs something to be eager on unlocking each week that will make his fighter better , so wee need a
proper progression plan , how first amateur weeks and pro weeks run , my thoughts are , in training learn a move (shows up on profile
with the move tree it unlocks and combos) Learn a second move (opens up combos between these moves and so on) use the playbook and try
different combos + movement (fighterns learn the movment here with visible filling graphic) [...] make movement effectiveness assoiated
with body attribute , and do that for other applicable things that apply also on the fight visually and statistiacally . During that it
will take coahces and trainers to raise his attributes and give him xp for learning the moves by reaching thresholds [...] add also coach
progression and other staff buffs maybe". Then: "the loop is not only the week , it is the whole fighter career/progression".

Sources: CRITIC_PACK, CORE_LOOP_MAP_S432 (C1-C33), RPG_LAYER_MAP_S432, TRAINSCENE_MAP_S439, AMATEURWEEK1_MAP_V2_S429,
SCOPE_FOUR_FIGHTERS_S428, BOXING_MANAGER_COMPARE_S425, PROGRESSION_RESEARCH_S448 (other games), and the code on main (files named).
Tags: CODE = the game does it today. AGREED = in an approved map, not built. NEW = this map adds it. ESTIMATE = a number this map sets
until its probe (section 9) measures it. Game text never uses he, she, him or her; plan situations are written "when pressed",
"at range", "waiting to counter", "loading up", "tiring" (the code's situation words are renamed in task 13).

## What v2 changed (round 1: Kalli depth 4 play 6, John depth 5 play 6)
| The critics found | v2 changes the MECHANIC |
|---|---|
| The tree is a queue: every fighter learns every node within two seasons; the pick sets the order, not the fighter (both) | THE SPECIALTY (M3): moves at Sharp and Signature must be HELD with pad, bag or sparring minutes each week or they fade. A fighter can hold only so many, so which ones are held is the fighter's identity, chosen and paid for every week |
| Awards and rows locked each other (Bronze tested a row-3 move) and the award test made every pick a lookup (both) | Awards NO LONGER GATE the tree. Rows open by how many moves the fighter can use (any branch). Awards stay the amateur season milestone they are in the code |
| Start state contradicted the code (hooks start near 30) | Every fighter keeps today's start masteries; any move at 30+ on day 0 is known; the day-0 tree is printed for every start (M1) |
| Grading on attributes "the game doesn't have" | CODE CHECK: the 14 abilities ARE built (`Attrs.gd` PRIMARY + SKILLS, S404; the old seven are a LEGACY summary). The critic pack is updated. Reach and height are kept OUT of the grade: centimetre modifiers in `Duels` only |
| Feint, Roll, Herd, Push off "have no hook"; link nodes double a bar; counts wrong | CODE CHECK: all four are `StrikeMap` plan arrows (step and defence answers). Link nodes and Slip as a node are cut (combinations open by themselves, CODE). 16 nodes, counted in M1 |
| Two walls on Signature (Technique cap + a pads-75 cliff); Hale can never get there | ONE wall, the CODE mastery cap. The coach sets the SPEED of Signature work, a rate not a gate (M6) |
| Stamps a second currency; +5 mood, +1 reputation, S&C x1.1 invisible | Cut. The bar is the experience; its three lines are the thresholds |
| The pro stage is barely different; the veteran has nothing to decide | PROFESSIONALS GET READ (M7): the measured rule "the opponent's corner waits for your best line" switches on for pros only, so a second Signature or a Feint becomes the answer. VETERANS TEACH: a held Signature passes to a club mate in sparring at x1.5 |
| Breadth stops counting after six moves | Breadth is priced by opponent modes (M2 card "answers: when pressed, tiring"); TREEVALUE1 must show a breadth curve |
| Missing: coachability, age, the visiting-pro card, a swap control, a coach market, the head coach's own pads | All added (M2, M6, M8) |
| Amateur bout card names what the opponent tests before any tape | From the free style word only; the exact answer after a tell opens (M2, section 7) |

## 0. The idea in seven lines
1. ONE BAR PER MOVE. Mastery (0-100, CODE) is the move's experience; its lines are the thresholds the owner asked for: Usable 30 (in the
   fight), Sharp 60, Signature 85. Each crossing is a named moment on Monday. No second currency.
2. THE MOVE TREE: 16 moves the fight already plays (6 punches, 7 footwork moves with the Feint, 3 defences), in a coach's teaching order.
   A move opens the moves after it and the combinations it completes.
3. LEARN ONE AT A TIME: one learning slot (two with a pads coach of 65+). When it frees, the coach lays out three next moves with their
   reasons; the player picks one. That is the weekly "what do I unlock next".
4. HOLD WHAT YOU SPECIALISE IN: Sharp and Signature moves cost minutes every week to keep. The few the fighter holds ARE the fighter:
   they name the style, and the style adds a plan line. This is the career's choice, renewed every week.
5. FOOTWORK IS LEARNED: steps get a filling bar like punches; a step under Usable is not done in the fight.
6. THE BODY DECIDES HOW WELL: every move is graded by two of the 14 built abilities (CODE `LineGrade.gd`, wired nowhere today); our fighters
   get height and reach so the duel's reach and height edges stop being 0 for them; the 3D steps follow Speed and height.
7. THREE CLOCKS: the WEEK (a bar crosses a line), the SEASON (awards, a style named, rank, the nationals), the CAREER (the pro offer,
   Signatures, being read and answering it, teaching club mates). The next thing on each clock is always on screen with its date.

## 1. What the game has today (read in the code)
| His idea | Today | Where |
|---|---|---|
| Learn a move | HAVE: 6 punches, mastery 0-100, tiers New / under 30 / Usable 30 / Sharp 60 / Signature 85; cap 40 + 0.4 Technique + 0.2 Ring IQ (50-100); pads 2.1 an hour, sparring 1.5, double-end 1.2, heavy bag 1.05, speed bag 0.9, shadow 0.85; x(1 + 0.4 x pads rating / 100) x (1 - m / cap); undrilled -0.75 a week, never back under 30 | `MoveMastery.gd`, `PadWeek.gd`, `Data.gd:234` |
| Start state | Jab 0.85 x Technique, Cross 0.75, Lead hook 0.62, Body hook 0.5, Uppercut 0, Check hook 0 (at Technique 60: 51 / 45 / 37 / 30 / 0 / 0); "learning" fixed on Uppercut | `PunchStart.gd:11`, `Data.gd:251` |
| Move tree | MISSING for boxing (BJJ has one: `BjjTree.gd`, `ui/MatTree.gd`) | |
| Combos opened by moves | HAVE: 10 book combinations open when all their punches reach 30; own chains with their own mastery | `Combos.gd:56`, `OwnCombos.gd`, `ui/ComboBuilder.gd` |
| Practice bar | HAVE: drill cards on pad nights; projections (day to 30, weeks to 60) | `PadWeek.project`, `ui/DrillCard.gd` |
| Movement learned | MISSING: the 8 step arrows and 2 defences (`StrikeMap.gd:2-49`: step_in, step_out, step_back, cut_off, herd, pivot_out, push_off, feint; tie_up, roll_out) are plan answers with no mastery; the fire rule reads them at 100 | `FireLevel.gd:44-48`, `ui/MoveBook.gd:50` |
| Body drives movement | PARTLY: 14 abilities built (`Attrs.gd`); range steering reads footwork .35, speed .3, jab .25, timing .1 (open) and footwork .4, speed .3, head movement .2, strength .1 (close); reach 0.25 a cm on the jab, height 0.2 a cm inside, capped 4 - but OUR fighters have no height or reach keys, so it is 0; 3D footwork is fixed constants | `Duels.gd:16-54, 412`, `TaleOfTape.gd:5`, `fight3d/BoxerFootwork.gd` |
| Grade by attributes | WRITTEN, UNUSED: two abilities a move, Good / OK / Poor at 62 / 50, edge x1.2 / 0.85 / 0.35 | `LineGrade.gd` |
| Moves matter in the fight | WEAK: a weapon past the fourth +0.3 (cap +0.9); a planned line fires every time from 30, so Sharp is worth about 1 win in 100 over Usable. FireLevel (Usable 1 in 2, Sharp 3 in 4, Signature always: +2.8 and +2.7 wins in 100, S427) is built and OFF. Also measured, not in the game: an opponent's corner waiting for your best line costs 7 wins in 100 | `BoutRules.gd:443`, `FireLevel.gd`, CRITIC_PACK 4.2 |
| Coaches raise attributes | HAVE: 1.0 x quality x (0.5 + 0.7 x rating) x headroom clamp((potential - stat) / 25, 0.10, 1.25) | `TrainingPreview.gd`, `CoachAreas.gd` |
| Levels | PARTLY: six skills awards (Preliminary, Standard Jab+Cross 30, Bronze Lead+Body hook 30, Silver Uppercut+Check hook 30, Gold four punches 60, Platinum a skills bout), 8 coached sessions each; a passed grade's moves cost less energy | `SkillAwards.gd`, `ComboFlow` econ |
| Coach and staff growth | PARTLY: two hireable coaches with fixed areas (Luke Reid pads 74, $450; Marcus Hale pads 58 / conditioning 90, $1,090); four head-coach edges; four staff jobs, one flat effect each; nothing grows (Coach grows is AGREED, RPG 11) | `Data.gd:31-38`, `StaffRoles.gd`, `HeadCoach.gd` |

## 2. What other games teach, and what is wrong with ours (full notes: PROGRESSION_RESEARCH_S448)
Football Manager: one individual focus, a trait that changes what the player DOES, coach stars that drop when one coach covers too much.
Motorsport Manager: always one part in the factory with a finish date. Boxing Manager (our benchmark): experience from bouts spent on
ratings, potential as a visible pool, training set once and never revisited (quiet weeks ask nothing: our opening). EA UFC: moves level
by USE, faster when they land; a guest teaches a move. Skyrim and NBA 2K: named tiers at visible lines. Path of Exile: 1,300 nodes lose
people. Persona: the week's free time is the scarce thing. Darkest Dungeon: upgrading the trainer raises what heroes can reach. Hades:
several bars at once, each with a named next reward; unlocks change HOW you play. Gym practice: shadow, bag, pads, sparring, a bout;
footwork once the straight punches and the hook are in.
MISSING here: a choice of what to learn; footwork as something learned; a next unlock with a date; an identity built by specialising;
body facts on our own fighters; coach growth and a coach market. OVERDONE: meters (loyalty, mood, Known, hype, Tank, tiredness, fire
share, grade, suit, direction, marks, moments): this map adds NONE. WRONG NOW: progress shown as decimals; Sharp and Signature barely
change a bout (fire rule off); steps work at full on day one; an unlock arrives as a news line, with nothing new to do.

## 3. The three clocks
| Clock | What the player is eager for | How often (ESTIMATE; PROGPROBE1 measures) | Feeds |
|---|---|---|---|
| WEEK | a bar crossing a line (Usable = a new plan answer or combination; Sharp; Signature); the next pick; Monday's held/fading list | per fighter, a line crossed 3 weeks in 4; a pick every 2 to 4 weeks | the specialty, the plan, the awards |
| SEASON | the next award (amateur), a STYLE NAMED (+1 plan line), a rank line on every bout, the nationals | an award every 6 to 10 weeks; a style named in season 1 | the pro offer (CODE 7 wins + top 3, or 9 wins) |
| CAREER | turning pro (the professional row, being read), the first and second Signature, a coach reaching a rate, a veteran teaching | a first Signature in the first pro year; a second in the second | the club's next fighters (veteran teaching), the coach's growth |

## 4. The mechanics

### M1. THE MOVE TREE (NEW: `assets/data/box_tree.json` + pure `MoveTree.gd` on the BjjTree pattern)
| Row (opens when) | LEAD HAND | REAR HAND / POWER | FOOTWORK | DEFENCE AND INSIDE |
|---|---|---|---|---|
| 1 at signing | Jab, Lead hook | Cross, Body hook | Step in, Step out | (Guard: always, not a node) |
| 2 at 5 moves Usable | | Uppercut (Cross 30 + Step in 30) | Step back (Step out 30), Pivot (Step back 30) | Tie up (Step in 30), Roll out (Lead hook 30) |
| 3 at 9 moves Usable | Check hook (Lead hook 60 + Pivot 30) | | Cut off (Step in 60), Herd (Cut off 30) | Push off (Tie up 30) |
| 4 PROFESSIONALS (turning pro) | Feint (Jab 60) | | | |
16 nodes: 6 punches (`Data.gd:234`), 7 footwork (`StrikeMap`: step_in, step_out, step_back, pivot_out, cut_off, herd, feint), 3 defence
and inside (tie_up, roll_out, push_off). Every node is already a weapon or a plan answer in the bout (CODE), so no node needs new fight
code or a new clip; each gets a bar. Within a row a node also waits for the moves named in brackets.
DAY 0 (Technique 60, Footwork 55, today's start shares; Step in and Step out start at 0.55 x Footwork, ESTIMATE): Jab 51, Cross 45,
Lead hook 37, Body hook 30, Step in 30, Step out 30: six Usable, so row 2 is open on day 0 and the FIRST PICK comes in week 1 (the
first-hour guide's "learn a move" step). A fighter with Footwork under 55 starts the steps under 30 with Step in in the slot. Every other
node starts at 0. Saves load as they are; steps in old saves start at 30 (today
they work at 100).
A node shows: its bar with ticks at 30 / 60 / 85, its grade letter (M5), what it opens (moves, combinations, plan answers: "Pivot: an
answer when pressed, mid range"), what it costs to hold at Sharp (M3); locked, the line it waits for. A toggle keeps the old move book
view BY PLACE IN THE RING (escapes, inside, long) beside BY BRANCH.

### M2. ONE MOVE IN LEARNING, THE COACH'S THREE (NEW; replaces Data's fixed "learning: Uppercut")
- LEARNING SLOTS: 1; 2 when the best pads rating among the fighter's coaches is 65+ (M6). Only a move in a slot can be drilled while under
  30; moves at 30+ can always be drilled.
- When a slot frees, the Monday review and a steel Home need (never stops the clock) lay out THREE open nodes in the coach's order, each
  with its reason: what the next opponent's STYLE WORD suggests (free at booking, CODE) or a found tell (after tape), the build direction
  (AGREED RPG 12), and the fighter's grade on it. Each card prints: weeks to Usable on this week's pad nights (`PadWeek.project`), which
  opponent modes it answers, what it opens, its grade, and what waits if it is taken. No card is pre-marked; an unpicked slot on Start
  week takes the coach's first card.
- SWAP: any time, with the price on the button: a half-learned move falls 0.75 a week (CODE decay) while out of the slot.
- LEARNING SPEED (NEW, ESTIMATE): x(0.8 + 0.4 x coachability / 100) (CODE trait); under 23 x1.1, over 30 x0.9.
- THE VISITING PRO (CODE twist card "visiting pro"): a new answer, "teach the slot's move": that week x2 on it.
- Breadth pays through modes: the opponent fights one way at a time (six modes, CODE); a fighter with an answer for more modes keeps the
  plan's edge in more exchanges. Each card says which modes it covers that the fighter cannot answer yet.

### M3. THE SPECIALTY: HELD MOVES (NEW; the career's choice)
- HOLDING: a move at Sharp needs 20 minutes a week of pads, bag or sparring on it; at Signature 40 (ESTIMATE, HOLD1 sets them). Unheld,
  a Sharp move falls 1.5 a week toward 50 and a Signature toward 70 (Usable moves keep today's floor of 30). A pad night is 240 minutes,
  a sparring night shares 180 among the moves in the fighter's plan and pad cards (CODE `PadWeek.spar_pool`), so THE PLAN HOLDS ITS OWN
  MOVES in sparring and the rest cost pad minutes.
- With the club's 8 pad nights shared by four fighters (AGREED PADPOOL1), a fighter can hold about 4 to 5 Sharp moves and 1 to 2
  Signatures and still learn (ESTIMATE). Which ones is the player's call, shown as THE SPECIALTY BOARD on the tree page: the held moves,
  their weekly minutes, and the day each starts to fade if dropped.
- STYLE NAMED: three held moves of one style's set at Sharp name it: Out-boxer (Jab, Step back, Pivot), Pressure fighter (Cut off, Body
  hook, Tie up), Counter-puncher (Check hook, Roll out, Pivot), Boxer-puncher (Cross, Lead hook, Step in), Volume puncher (Jab, Cross,
  Step out). A named style ADDS ONE PLAN LINE (a plan holds 4-6 by the coach today, CODE) and the style word on the Profile now comes from
  what the fighter can do. Lose the hold, lose the line. Two fighters with the same start end season 2 with different held sets (HOLD1).
- SIGNATURE is reached under the CODE mastery cap (40 + 0.4 Technique + 0.2 Ring IQ): at Technique 60 and Ring IQ 55 the cap is 75, so
  the first Signature is also a Technique goal; the node shows "your cap 75: Signature needs Technique 66".

### M4. FOOTWORK IS LEARNED (NEW: steps and defences get mastery; FireLevel reads it)
The 7 footwork nodes and 3 defences fill on pad nights, in SHADOW mornings (0.85 an hour; a shadow morning names its step) and in sparring.
Under 30 the plan line using it is greyed "Pivot: learning, 2 pad nights" (CODE `StrikeMap.grey_reason` pattern); from 30 its fire share
follows FireLevel. The bar is the visible filling graphic, on the node, the drill card and the Monday review. FOOTWORK1 bounds the cost:
a novice with no Step back must not lose more than 5 in 100 to pressure.

### M5. THE BODY DECIDES HOW WELL (wire `LineGrade.gd`; NEW body facts; NEW 3D reads)
- Each node is graded by two of the 14 built abilities: steps and defences as `LineGrade.DONE_WITH` (CODE: step_in footwork +
  explosiveness, pivot footwork + composure, cut_off footwork + fight IQ, roll_out defence + flexibility, tie_up inside + strength...);
  punches added: Jab accuracy + speed, Cross strength + accuracy, Lead hook timing + explosiveness, Body hook strength + inside, Uppercut
  explosiveness + inside, Check hook timing + footwork. Good / OK / Poor at the mean 62 / 50; a planned line's edge x1.2 / 0.85 / 0.35
  (CODE constants, GRADE1 sets them). Mastery: how often it comes off. Grade: how well when it does.
- BODY FACTS (NEW, a dead edge fixed): our fighters get height and reach at signing from their class, by the generator opponents use
  (`AttrGen.gd:227`), on the signing card and the tale of the tape. They stay centimetre modifiers in the duel (CODE `Duels.gd:412`,
  reach on the jab, height inside, capped 4), never inside the grade's mean.
- ON SCREEN (NEW; the 3D shows, never decides): step length from Speed and height; step tempo from Speed and the step's grade (a Poor step
  is visibly shorter and later); punch clips within plus or minus 10% by Speed (ESTIMATE). Stills and a side film before it ships.
- Training already moves these abilities (CODE mornings); so a coach's mornings now change how well every move is done, on screen.

### M6. COACHES: SPEED, SLOTS AND A MARKET (CODE factor + AGREED RPG 11 + NEW)
- SPEED (CODE): pads rating x every bar; rating x every ability.
- SECOND SLOT at a pads rating of 65+ (best of the coaches running the fighter's pad nights, the head coach included).
- SIGNATURE WORK AS A RATE, NOT A GATE (NEW): gain above 60 x clamp((pads - 55) / 20, 0.25, 1). Reid (74): x0.95. Hale (58): x0.25,
  rising as Hale grows.
- THE HEAD COACH'S PADS (NEW, ESTIMATE, from the background card): Ex-pro 70, Amateur coach 66, Old hand 62, Strength coach 52. Your own
  pad places (AGREED RPG 2) use it.
- A MARKET (NEW, ESTIMATE): five assistants for hire, each with an area profile, a growth ceiling and a wage: Luke Reid (pads 74, +8,
  $450 sessional), Marcus Hale (conditioning 90, pads 58, +12, $1,090), and three new: a young pads coach (pads 64, +16, $380, grows into
  the second slot), an old trainer (pads 80, bag 76, +2, $900: Signatures now, no growth), a footwork specialist (pads 60, sparring 72,
  footwork nodes x1.2, $520). The club may hire two (each paid; the slot reads the better). A hire is now a career decision: moves now,
  bodies now, or a coach who grows.
- GROWTH (AGREED RPG 11): +1 in an area per 10 sessions run in it, to the hire's ceiling; 40 pad sessions on one move opens Coach's
  signature drill (x1.2). Hale's pads 58 -> 65 needs 70 pad sessions: about 12 weeks at 6 a week. The Monday review names each milestone
  ahead ("Young coach: 9 pad sessions to 65: second slots for the club").
- STAFF JOBS keep their one flat effect each (CODE). No coach perk of "+5% training".

### M7. PROFESSIONALS GET READ (CODE measured rule, switched on for pros only, NEW)
From the debut, the opponent's corner waits for the professional's MOST-FIRED line (measured S427: costs 7 wins in 100 unanswered; READ1
re-measures). The answers are career unlocks: a SECOND Signature (the read splits), the FEINT (row 4, a plan answer that draws the read),
a held style's extra line. Amateurs are never read (club opponents have no tape on them). This is what makes the pro weeks different:
specialise, then cover the specialty.

### M8. THE FIGHT TEACHES; VETERANS TEACH (NEW, small)
- A planned line that won two or more exchanges in a bout adds +3 mastery to its move (the line receipts, CODE "The plan, lit up") and a
  gold FIGHT-PROVEN pin on the node. If a bout cannot attribute an exchange to a line, the pin waits (checked in task 8).
- A fighter holding a move at Signature who spars with a club mate learning it (AGREED sparring pair, C17): the learner x1.5 on that move
  that week. A veteran's last seasons have a purpose; the club's next fighters learn faster.
- Veterans (31+): fade on held moves x0.5; learning x0.9 (M2).
- The Why's NEXT names the open node that would have answered what lost the bout, with Pick or Swap on it.

### M9. FIRE LEVEL ON (CODE `FireLevel.gd`, queue row FIRELEVEL3, its first-season re-measure first)
Without it Sharp and Signature are worth about 1 in 100 and the specialty is invisible on fight night. With it: Sharp +2.8, Signature +2.7
wins in 100 (S427).

## 5. Amateur weeks against professional weeks along the arc
| | NOVICE AMATEUR | OPEN AMATEUR | PROFESSIONAL | VETERAN (31+ or 20+ pro bouts) |
|---|---|---|---|---|
| Tree | rows 1-2 | rows 2-3 | row 4 (Feint) | complete; holding |
| Slots | 1 (2 with a 65+ pads coach) | same | same | same; teaches in sparring |
| Specialty | first Sharp | 3 to 4 held, a style named | 4 to 5 held, 1 to 2 Signatures | Signatures held at half fade |
| Mornings | job rota (AGREED C31): fewer free; shadow names a step | same; a gym sponsorship frees six | all free (C31): more shadow and bag for footwork and holding | recovery costs more (AGREED T38) |
| Bouts | today: offers 8-12 weeks out; with AMATEURWEEK1 (Q-209) a fight week 1-2 weeks out; one plan line ready | same; the nationals (5 bouts, 3 months) | camps as load blocks (C15); 4 then 6 rounds; three promoter offers | fewer, bigger |
| Threat | none from tape | the regional ladder | READ (M7) | the body: Speed falls, steps shorten on screen |
| Eager for | first award, first combination, first rank | Silver and Gold, the style, the nationals, the pro offer | first and second Signature, answering the read, a belt | one more title; a club mate's Signature |

## 6. One week played (four fighters, week 9; numbers ESTIMATE from the code's formulas)
Monday: Tess's Uppercut crossed 30 on Sunday night (opens 1-2-3b and 1-6-3; her slot frees); Lucy's Step back 30. Home: two steel needs.
Tess's three, in the coach's order: Pivot (next opponent is a pressure fighter: answers "when pressed"; 2.5 weeks; grade OK), Tie up
(answers "when pressed" inside; 2 weeks; grade Good: inside 66 + strength 63), Roll out (answers "loading up"; 3 weeks). Samira holds
Jab and Cross at Sharp (40 minutes, covered by sparring because both are in her plan) and wants Body hook to Sharp for Pressure fighter
(she holds Cut off and Tie up): that is 3 of the club's 8 pad nights this week; Lucy's Pivot gets 2. The Specialty board says Samira's
Lead hook (Sharp 61, not in her plan) starts fading Sunday unless it gets 20 minutes: the player drops it (it will settle at 50, still a
weapon) to pay for the Body hook. Saturday Samira wins; her Body hook line won 3 exchanges: +3, FIGHT-PROVEN. Sunday: Body hook 60, three
held: PRESSURE FIGHTER named, her plan holds 6 lines from next week.

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows (and what can be done) | Wired to |
|---|---|---|
| Fighter page > Profile | NEXT UNLOCKS: three rows (week: the nearest line and its day; season: next award or the style's missing move; career: the pro offer, the next Signature with its Technique need, or the read); height, reach; the style named; the award chip; each row opens its node | `MoveTree.next_unlocks`, `SkillAwards.progress`, `PadWeek.project`, `Roster.check_pro` |
| Playbook > Moves = THE TREE | 16 nodes by branch and row (toggle BY PLACE IN THE RING); bars, grade, gold pins, locks with reasons; the slot(s); the SPECIALTY BOARD; a node: Watch (CODE clip), Drill (to the pad tray), Pick or Swap with its price, Hold or Drop | `MoveTree.gd`, `LineGrade.grade`, `MoveMastery`, `ui/MoveBook.gd`, new `Specialty.gd` |
| Playbook > Combos | book combinations greyed with the node that opens them, Pick on it when a slot is free; own chains as today (no gate) | `Combos.unlocked`, `MoveTree` |
| Playbook > Game plan | a line whose move is learning: greyed with its days to 30; the grade letter on each line; the style's extra line slot | `StrikeMap.grey_reason`, `LineGrade`, `Specialty.style_line` |
| Week (pad tray, mornings) | drill cards for steps and defences; the slot card first; held moves' minutes shown on the tray ("Hold: 60 min this week, 40 by sparring"); shadow mornings name their step | `PadWeek`, `WeekPlan`, `Specialty.minutes_due` |
| Monday review | lines crossed and what each opened; held moves fading; a style named or lost; an award passed; a slot free with the three cards; a coach's area milestone | `DrillWeek` news, `Specialty`, `SkillAwards.assess`, RPG 11 growth |
| Home | steel need A MOVE TO PICK; amber need A SIGNATURE FADING (Sunday) | Home needs, `MoveTree.slot_free`, `Specialty.fading` |
| Fighters page cards | style word and award on the card (S410 cards) | `Specialty.style`, `SkillAwards` |
| Fights > bout card | from the style word only: "Pressure fighter: answers you hold: Tie up; open: Pivot (Pick)" | `OppFile` style, `MoveTree.answers` |
| Fight prep (after a tell) | the exact answer node and how far, Pick or Swap | `OppFile.tape`, `MoveTree.answers` |
| Fight night | 3D steps from Speed, height and grade; grade on hover only (the minute's three rows stay) | `fight3d/BoxerFootwork.gd`, `LineGrade` |
| Result and the Why | FIGHT-PROVEN pins and mastery added; NEXT names the node that would have answered, Pick or Swap on it; for a pro, "your Jab line was read in rounds 3-4" | `BoutNight._finish`, `MoveTree.prove`, `FightWhy`, READ1 rule |
| Club > People | each coach: pads rating, second-slot line (65), Signature rate, sessions to the next point; the market (five, hire two) | `CoachAreas`, `Data.COACHES`, RPG 11 |
| Signing card / Find a fighter | the day-0 tree (known moves), signature move, height and reach, coachability's learning speed | `Recruit`, `AttrGen`, `MoveTree.day0` |
| Pro offer | "turning pro opens the Feint and brings the read: your most-fired line now is the Jab 1-2" | `MoveTree.row_for(4)`, READ1 |

## 8. How it links (deep, not complicated)
Coach (rating, growth, market) -> bar speed, slots, Signature rate -> moves cross lines (week) -> new plan answers and combinations ->
held moves name a style and add a line (season) -> fire share by tier and grade by body on fight night -> wins, proven lines, rank,
awards -> the pro offer -> the read, answered by a second Signature or the Feint (career) -> veterans teach club mates -> faster bars.
On Monday the player does at most: pick a move (when a slot freed), decide what to hold (when the board says something fades), place the
club's pad nights (AGREED). Everything else is shown, not asked.

## 9. To be measured before any build (through the game's real code; each prints today's game first)
| Probe | It plays | It passes when |
|---|---|---|
| PROGPROBE1 cadence | two seasons of four starters through `Sim`, coach's picks, arm A today, arm B this map | each fighter crosses a line 3 weeks in 4; a pick every 2-4 weeks; no gym week with nothing crossed; a style named in season 1; first Signature in the first pro year |
| HOLD1 the specialty | the same two seasons, four hold policies (plan only, widest, deepest, coach) | two fighters with the same start end season 2 with different held sets; 4 to 5 Sharp held by a careful player; no policy best in more than 2 of 3 line-ups; the hold minutes set |
| TREEVALUE1 node worth and breadth | each node at Usable and Sharp on the played bout (60 generated fighters, four opponent styles, FireLevel on) | every node moves 1.5 wins in 100 against at least one style; none best against all four; wins still rise from 6 to 9 Usable answers (breadth curve) - else the bottom nodes merge |
| PICKSPREAD1 the three cards | 60 fighters, first five picks, each card played 6 weeks on | no card position best in more than 6 in 10; the coach's first card best in under 5 in 10 |
| READ1 the professional's read | pros with one Signature, two, a Feint, a held style, against the read on and off | the read costs 4 to 7 in 100 on one Signature; each answer wins back at least 2; no answer wins all back |
| GRADE1, BODYFACT1, FOOTWORK1 | grade multipliers; reach and height for our fighters; gated steps | Good vs Poor on one line 2+ in 100; the longest vs shortest in a class 1 to 4 in 100; a stepless novice loses 1.5 to 5 more in 100 to pressure |
| COACHMARKET1 | five coaches over three seasons | no hire best in more than 2 of 3 line-ups; growth worth less than the gap between hires in season 1 |
Results into `ops/AgentComms/levers.json` (C27 cut rule). A mechanic whose probe fails is redesigned before it is drawn.

## 10. Build order (after his OK; each task under 500 lines, one owner, its test red on main first)
1 FIRELEVEL3 (queued). 2 BODYFACTS1 (Qwen). 3 MOVETREE1 (Goose, pure: tree data, rows, day 0, answers, tests). 4 STEPMASTERY1 (Claude:
steps and defences get mastery; FireLevel, PlanFight and StrikeMap read it; old saves at 30). 5 LINEGRADE2 (Claude: grade into PlanFight).
6 SLOTS1 (Qwen, pure: slots, the three cards, learning speed). 7 SPECIALTY1 (Qwen, pure: hold minutes, fade, style named, +1 line) and its
wiring in PadWeek (Claude). 8 FIGHTPROVE1 (Claude: line receipts -> mastery and pin; checks attribution first). 9 READ1 rule for pros
(Claude, after its probe). 10 COACHMARKET1 data + head coach pads (Qwen). 11 the probes (Goose / Arena). 12 screens (Grok Dev, one a task,
from an approved drawing): the tree page with the Specialty board, the pick cards, the Profile strip, the Monday rows. 13 SITWORDS1: the
plan situation words without pronouns (Claude). 14 BOXSTEP3D1 (Ziva, after stills). 15 golden path (Grok Dev): signing to the pro offer,
six picks, a style named and lost, a Signature with the cap shown, the read answered by a Feint, a veteran teaching. Coach growth (RPG 11)
after the fighter loop has been played.

## 11. Rejected, and why
- A separate fighter experience or stamps: a second currency; the bar is the experience.
- Awards as row gates: they made the pick a lookup (round 1).
- Hard caps on Sharp slots (3 / 5): holding by minutes gives the same limit through the club's real scarce thing (pad time) and lets a
  fighter with more nights hold more.
- New punches (overhand, body jab, shoulder roll): need clips and fight hooks; later nodes once TREEVALUE1 proves the 16.
- Coach perks of "+5% training"; a training mini-game (grind).
- Gating own chains by length: it would take away a built feature the owner calls fun.

## 12. Risks, said plainly
- Holding costs could feel like upkeep chores: the plan's sparring holds its own moves, and only a FADING Signature raises a need.
- Gated steps could make novices lose more to pressure: FOOTWORK1 bounds it; old saves start steps at 30.
- The read could punish pros too hard: READ1 bounds it at 4-7 in 100 with answers worth 2+.
- Four fighters x picks x holds: at most two decisions a fighter on a busy Monday, most weeks none.
- 3D reads need clean stills before they ship; the numbers ship first.
- AMATEURWEEK1 (Q-209) changes the novice's bout rhythm; this map works on today's rhythm and on that one.
