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
