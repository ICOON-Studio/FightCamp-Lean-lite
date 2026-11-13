# PROGRESSION: what the player is eager to unlock, week by week, season by season, across a career (design map v4, S448)

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
until its probe (section 9) measures it.
WORDS: a person's name sits once in a screen's header; rows, buttons, notes and tooltips say her / him (the fighter's own, never one
fixed for all), the opponent, your coach, the assistant (owner S448 rule, with S412). Plan situations read "when pressed", "at range",
"waiting to counter", "loading up", "tiring" (the code's situation words are renamed in task 13).
UNITS: the club's assistant holds 8 PAD NIGHTS a week (AGREED PADPOOL1; Luke Reid works three evenings, two or three fighters an evening).
A pad night is one fighter's share of an evening: 240 DRILL UNITS in the code (`PadWeek.PAD_NIGHT_MINUTES`) for the pack's 75 real minutes.
A sparring night SHARES 180 units (`SPAR_NIGHT_MINUTES`) among the moves on the fighter's cards and plan. Prices below are in units.

## What changed (R1: Kalli depth 4 / play 6, John 5 / 6; R2: Kalli 6 / 6, John 6 / 7; R3: Kalli 6 / 7, John 7 / 7)
| Found | The mechanic now |
|---|---|
| R1: the tree was a queue; awards locked the rows; start state, stamps, invisible bonuses | THE SPECIALTY (held moves) is the identity; rows open by moves Usable; today's start kept; stamps and +1s cut |
| R2: holding through the gain formula; fight weeks cost identity; cheap styles; the read unwritten | Holding is a RULE (`Specialty.gd`); fight weeks and TAPER freeze fades; styles carry fight effects; the read written, shown before the bout |
| R3: sparring was counted as the full 180 for every plan move; it only SHARES 180 | The sparring hold reads each move's SHARE: a bigger plan thins what sparring holds. The plan's size is now the hold trade-off (M3) |
| R3: injury and suspension had no hold rule | Out injured or suspended: fades frozen, learning stopped; a "back in the gym" line on return. A loss never costs identity twice |
| R3: Pivot in three style sets, Cross in three; the cheapest style the same for every start | NEW SETS: each move in at most two sets; each set two row-1 moves and one row-2 or row-3 move used by no other set; day-0 distances printed (M4) |
| R3: styles had no look | Each style shows through the existing 3D step reads (after stills) |
| R3: READ-PROOF was a probe number the game cannot see in a bout | READ-PROOF lights from the bout's own counts (M7) |
| R3: the Feint rule ambiguous | When the Feint line fires in a round, the read misses its target for the rest of that round 1 time in 2 |
| R3: awards: real GB names over invented tests; Silver forced one move | Awards KEEP THE REAL TESTS (CODE, unchanged); they no longer gate anything, so chasing one is a choice the coach's card can name, not a lock |
| R3: old trainer a hire nobody takes; young coach the worse long bet | Old trainer cut; young coach grows +1 per 8 pad sessions to 72 |
| R3: old saves' Feint in a locked row | A node at 30+ in a locked row is known and usable; a row's lock only stops LEARNING new nodes there |
| R3: the coach's default hides the choice | Monday lists "dropped X, holding Y" with Undo |
| R3: dependencies; the always-on pad-night row changes an agreed rule; names in rows | C20 and C17 placed before what uses them; the always-on row goes to the owner as a named change in this approval; names only in headers |

## 0. The idea in seven lines
1. ONE BAR PER MOVE. Mastery (0-100, CODE) is the move's experience; its lines are the thresholds: Usable 30 (in the fight), Sharp 60,
   Signature 85. Each crossing is a named moment on Monday. No second currency.
2. THE MOVE TREE: 16 moves the fight already plays (6 punches, 7 footwork moves with the Feint, 3 defences) in a coach's teaching order.
3. LEARN ONE AT A TIME: one learning slot (two with an assistant whose pads are 65+); when it frees, the coach lays out three next moves
   with reasons; the player picks one.
4. HOLD WHAT YOU SPECIALISE IN: Sharp and Signature moves need their share of the week's drilling or they fade. The plan holds its moves
   in sparring, but a longer plan thins each share. The held set names a STYLE that changes how the fighter fights, in the numbers and on screen.
5. FOOTWORK IS LEARNED: steps get a filling bar like punches; a step under Usable is not done in the fight.
6. THE BODY DECIDES HOW WELL: each move is graded by two of the 14 built abilities (`LineGrade.gd`, wired nowhere today); our fighters get
   height and reach; the 3D steps follow Speed, height and grade.
7. THREE CLOCKS: the WEEK (a bar crosses a line), the SEASON (an award or READ-PROOF, a style named, rank, the nationals), the CAREER (the
   pro offer, Signatures, being read and covering it, teaching club mates). The next thing on each clock is always shown with its date.

## 1. What the game has today (read in the code)
| His idea | Today | Where |
|---|---|---|
| Learn a move | HAVE: 6 punches, mastery 0-100, tiers New / under 30 / Usable 30 / Sharp 60 / Signature 85; cap 40 + 0.4 Technique + 0.2 Ring IQ (50-100); per hour pads 2.1, sparring 1.5, double-end 1.2, bag 1.05, speed bag 0.9, shadow 0.85; x(1 + 0.4 x pads rating / 100) x (1 - m / cap); undrilled -0.75 a week, never back under 30 | `MoveMastery.gd`, `PadWeek.gd`, `Data.gd:234` |
| Start state | Jab 0.85 x Technique, Cross 0.75, Lead hook 0.62, Body hook 0.5, Uppercut 0, Check hook 0 (Technique 60: 51 / 45 / 37 / 30 / 0 / 0); "learning" fixed on Uppercut | `PunchStart.gd:11`, `Data.gd:251` |
| Move tree | MISSING for boxing (BJJ has one: `BjjTree.gd`, `ui/MatTree.gd`) | |
| Combos | HAVE: 10 book combinations open when their punches reach 30; own chains with their own mastery | `Combos.gd:56`, `OwnCombos.gd` |
| Practice bar | HAVE: drill cards on pad nights; projections; the default week 3 pad nights + 1 sparring night | `PadWeek.gd`, `ui/DrillCard.gd` |
| Movement learned | MISSING: 8 step arrows and 2 defences (`StrikeMap.gd:2-49`) are plan answers with no mastery; the fire rule reads them at 100 | `FireLevel.gd:44-48` |
| Body | PARTLY: 14 abilities (`Attrs.gd`) steer range; reach and height edges exist but our fighters have none (0); 3D footwork fixed | `Duels.gd:16-54, 412`, `TaleOfTape.gd:5` |
| Grade | WRITTEN, UNUSED: Good / OK / Poor at 62 / 50, x1.2 / 0.85 / 0.35 | `LineGrade.gd` |
| Moves matter in the fight | WEAK: a line fires every time from 30. FireLevel built and OFF (Sharp +2.8, Signature +2.7 wins in 100). Measured, not in the game: a corner waiting for your best line costs 7 in 100, best answer 3.7 back | `FireLevel.gd`, CRITIC_PACK 4.2 |
| Coaches | HAVE: gain x(0.5 + 0.7 x rating); pads rating x every bar; Luke Reid pads 74 ($450, three evenings), Marcus Hale pads 58 / conditioning 90 ($1,090); nothing grows (RPG 11 AGREED) | `TrainingPreview.gd`, `Data.gd:31-38` |
| Levels | PARTLY: six skills awards (the real GB Boxing Awards: Preliminary; Standard Jab + Cross 30; Bronze Lead + Body hook 30; Silver Uppercut + Check hook 30; Gold four punches 60; Platinum a skills bout), 8 coached sessions each; passed moves cost less energy | `SkillAwards.gd` |

## 2. What other games teach, and what is wrong with ours (notes: PROGRESSION_RESEARCH_S448)
Football Manager: one focus, a trait that changes what the player DOES, coach stars that drop when one coach covers too much. Motorsport
Manager: one part in the factory with a finish date. Boxing Manager (benchmark): training set once and never revisited, quiet weeks ask
nothing - our opening. EA UFC: moves level by USE. Skyrim, NBA 2K: named tiers at visible lines. Path of Exile: too many nodes lose
people. Persona: the week's free time is scarce. Darkest Dungeon: a better trainer raises what heroes can reach. Hades: several bars, each
with a named next reward; unlocks change HOW you play. Gym practice: shadow, bag, pads, sparring, a bout; footwork after the straight punches.
MISSING here: a choice of what to learn; footwork learned; the next unlock with a date; an identity built by specialising; body facts on
our fighters; coach growth and a market. OVERDONE: meters - this map adds none. WRONG NOW: progress shown as decimals; Sharp and
Signature barely change a bout; steps work in full on day one; an unlock arrives as a news line with nothing new to do.

## 3. The three clocks
| Clock | What the player is eager for | How often (ESTIMATE; PROGPROBE1) | Feeds |
|---|---|---|---|
| WEEK | a bar crossing a line (a new plan answer or combination, Sharp, Signature); the next pick; a hold kept or dropped | per fighter, a line crossed 3 weeks in 4; a pick every 2-4 weeks | the specialty, the plan, the award |
| SEASON | AMATEUR: the next award, a style named, rank on every bout, the nationals. PRO: READ-PROOF, a second Signature, rank and belts | an award every 6-10 weeks; a style in season 1; READ-PROOF in the first pro season | the pro offer (CODE 7 wins + top 3, or 9) |
| CAREER | turning pro (being read), Signatures, a coach reaching a rate, a veteran teaching | first Signature in the first pro year, second in the second | the club's next fighters, the coach's growth |

## 4. The mechanics

### M1. THE MOVE TREE (NEW: `assets/data/box_tree.json` + pure `MoveTree.gd` on the BjjTree pattern)
| Row (opens when) | LEAD HAND | REAR HAND / POWER | FOOTWORK | DEFENCE AND INSIDE |
|---|---|---|---|---|
| 1 at signing | Jab, Lead hook | Cross, Body hook | Step in, Step out | (Guard: always) |
| 2 at 5 moves Usable | | Uppercut (Cross 30 + Step in 30) | Step back (Step out 30), Pivot (Step back 30) | Tie up (Step in 30), Roll out (Lead hook 30) |
| 3 at 9 moves Usable | Check hook (Lead hook 60 + Pivot 30), Feint (Jab 60) | | Cut off (Step in 60), Herd (Cut off 30) | Push off (Tie up 30) |
16 nodes: 6 punches (`Data.gd:234`), 7 footwork (`StrikeMap`: step_in, step_out, step_back, pivot_out, cut_off, herd, feint), 3 defence
and inside (tie_up, roll_out, push_off). Every node is already a weapon or a plan answer (CODE); no new fight code or clip; each gets a bar.
Herd and Push off stay only if TREEVALUE1 clears them; else they merge into Cut off and Tie up (14 nodes).
A ROW'S LOCK ONLY STOPS LEARNING: a node already at 30+ in a locked row (a start, an old save, a signing card) is known and usable.
DAY 0: punches at today's shares; Step in and Step out at max(30, 0.55 x Footwork) for Footwork 50+. Any start with Technique 49+ has
Jab, Cross and Lead hook at 30+, so five moves are Usable and row 2 opens on day 0: the FIRST PICK comes in week 1 (the first-hour
guide's "learn a move" step). Footwork under 50: Step in starts in the slot. Every other node starts at 0.
OLD SAVES: a step in the fighter's plan starts at 60 (Sharp, as today it fires in full), any other step at 30; the Monday review says so
once ("Footwork now has bars: the plan's steps start Sharp").
A node shows: bar with ticks at 30 / 60 / 85, grade letter (M5), what it opens (moves, combinations, plan answers: "Pivot: an answer when
pressed, mid range"), its hold price at Sharp (M3), the styles it belongs to (M4); locked, the line it waits for. A toggle keeps the move
book's view BY PLACE IN THE RING. Uppercut opens 1-6-3.

### M2. ONE MOVE IN LEARNING, THE COACH'S THREE (NEW; replaces Data's fixed "learning: Uppercut")
- SLOTS: 1; 2 when an assistant who runs the fighter's pad nights has pads 65+ (M6). Only a move in a slot is drilled while under 30.
- When a slot frees, the Monday review and a steel Home need ("A move to pick", with her / his portrait; never stops the clock) lay out
  THREE open nodes in the coach's order with reasons: the next opponent's STYLE WORD (free at booking, CODE) or a found tell, the build
  direction (AGREED RPG 12), the style set being built (M4), the next award's test (CODE), the grade. Each card prints: weeks to Usable on
  this week's pad nights (`PadWeek.project`), which opponent modes it answers that nothing held answers yet, what it opens, its grade,
  what waits if taken. No card is pre-marked; an unpicked slot on Start week takes the coach's first card.
- SWAP at any time, its price on the button: a half-learned move falls 0.75 a week while out of the slot (CODE decay).
- LEARNING SPEED (NEW, ESTIMATE): x(0.8 + 0.4 x coachability / 100); under 23 x1.1; 31+ x0.9.
- THE VISITING PRO (CODE twist card): a new answer "teach the slot's move": x2 on it this week; PRICE: the week's sparring night is the
  visit (no sparring holds that week, M3).

### M3. THE SPECIALTY: HELD MOVES (NEW, pure `Specialty.gd`; the career's choice)
- A RULE, NOT A GAIN: each Sunday `Specialty.week(f)` checks every move at 60+: if its hold was met, no fade; if not, a Sharp move falls 1.5
  toward 50 and a Signature 1.5 toward 70 (ESTIMATE). Usable moves keep today's floor of 30. Mastery gain (`MoveMastery`) is untouched.
- THE HOLD (ESTIMATE, HOLD1 sets it): 20 drill units a week for Sharp, 40 for Signature, from the move's own SHARE of the week's pads, bag
  and sparring. Sparring's 180 units are SHARED over the moves on the fighter's cards and plan (CODE `PadWeek.spar_pool`): a 4-line plan
  gives each move about 45 (holds a Signature), a 6-line plan with 3 pad cards about 20 (holds Sharp only), a 7-line plan under 20 (holds
  nothing alone). THE PLAN'S SIZE IS THE TRADE: more lines answer more modes but hold less; the rest is bought with pad-night units.
  A fighter on 2 pad nights (480 units) topping up 2 Sharp moves and 1 Signature outside the plan pays 80 and keeps 400 to learn.
- WHEN NOTHING FADES: in a fight week (amateur, AGREED AMATEURWEEK1) and in TAPER (CODE phase: light, no sparring); while OUT INJURED or
  SUSPENDED (CODE: no pads, no sparring; learning stops too), with a "back in the gym: holds kept" line on return. In PEAK (sparring twice)
  sparring counts double for holds. BASE and BUILD use the rule (the coach's default week has one sparring night, CODE).
- COACH HOLDS IT (needs the AGREED "Coach runs it" control, C20, built first): on by default per fighter; the coach holds the plan's moves
  and any Signature; the player overrides on the SPECIALTY BOARD. Hold and Drop are the pad tray's control (Hold puts a hold card on the
  tray, Drop takes it off). Monday lists what the coach dropped and what it holds, with Undo, so the choice is always in view. Only a
  SIGNATURE fading outside the coach's hold raises a need (amber, never in a frozen week).
- SEEN FADING: a held move under its line plays its 3D clip up to 10% slower as it falls from 60 toward 50 (after stills, with M5's reads).

### M4. STYLES: NAMED BY WHAT IS HELD, EACH CHANGES THE FIGHT (NEW; STYLE1 measures every effect)
Three held moves of a style's set at Sharp name it. Each set is two row-1 moves and ONE row-2 or row-3 move no other set uses; each row-1
move sits in exactly two sets (a ring: Jab, Cross, Step in, Body hook, Lead hook, Step out), so neighbours share one move and no move is in
three. DAY-0 DISTANCE = mastery points to bring all three to 60 from a Technique-60, Footwork-55 start (gates included), ESTIMATE:
| Style (CODE words) | Its set | Day-0 distance | Its fight effect (ESTIMATE, existing lever) | Its look (3D step reads, after stills) |
|---|---|---|---|---|
| Out-boxer | Jab, Step out, Pivot | 9 + 30 + 90 = 129 | range steering open +0.1 (`Duels` OPEN) | longer range, steps off the line |
| Volume puncher | Jab, Cross, Feint (row 3) | 9 + 15 + 60 + the row-3 wait (about 5 weeks) | a combination's energy x0.9 (`Combos` spend) | busy feet, short steps in and out |
| Boxer-puncher | Cross, Step in, Uppercut | 15 + 30 + 60 = 105 | plan edge at mid range +0.1 | holds the middle, steps in behind the cross |
| Pressure fighter | Step in, Body hook, Tie up | 30 + 30 + 60 = 120 | pressure from right answers x1.2 | forward steps, rarely backs up |
| Slugger | Body hook, Lead hook, Roll out | 30 + 23 + 60 = 113 | knockdown chance x1.1 (`Knockdowns`) | rolls under, plants to hook |
| Counter-puncher | Lead hook, Step out, Step back | 23 + 30 + 60 = 113 | counter lines' edge +0.15 when the opponent loads up or presses | held stance, steps back and returns |
The spread is 105 to 129 (Volume puncher's lower count waits on row 3); STYLE1 swaps a third move if any set ends more than 20 from the
others in measured weeks. One style at a time: a fighter who holds two sets names one on the board (the other's effect stays off);
STYLE1 also reports how often two sets are held at once (target under 1 in 4). A named style allows ONE plan line past the coach's cap
(at most 7) - which also thins the sparring hold (M3): the style's own extra line has a price. Lose the hold and the style goes the next
Monday; a written plan keeps its extra line until that bout. STYLE1 passes when each effect is worth 1.5 to 4 wins in 100 against what
it suits, none is best against all, and no style is named in more than 1 career in 3 across the four starts.
SIGNATURE sits under the CODE mastery cap (40 + 0.4 Technique + 0.2 Ring IQ): at Technique 60 and Ring IQ 55 the cap is 75, so the first
Signature is also a Technique goal; the node says "cap 75: Signature needs Technique 66".

### M5. FOOTWORK LEARNED; THE BODY DECIDES HOW WELL (steps get mastery; wire `LineGrade.gd`; NEW body facts and 3D reads)
- The 7 footwork nodes and 3 defences fill on pad nights, in SHADOW mornings (0.85 an hour; a shadow morning names its step) and in sparring.
  Under 30 the plan line using it is greyed "Pivot: learning, 2 pad nights" (CODE `StrikeMap.grey_reason` pattern); from 30 its fire
  share follows FireLevel. FOOTWORK1 bounds it: a novice with no Step back loses 1.5 to 5 more in 100 to pressure, never more.
- GRADE: two of the 14 built abilities per node: steps and defences as `LineGrade.DONE_WITH` (CODE); punches added: Jab accuracy + speed,
  Cross strength + accuracy, Lead hook timing + explosiveness, Body hook strength + inside, Uppercut explosiveness + inside, Check hook
  timing + footwork. Good / OK / Poor at the mean 62 / 50; a planned line's edge x1.2 / 0.85 / 0.35 (CODE constants; GRADE1). Mastery says
  how often it comes off, the grade how well. Mornings move these abilities (CODE), so mornings now change how well moves are done.
- BODY FACTS: our fighters get height and reach at signing from their class by the opponents' generator (`AttrGen.gd:227`), on the signing
  card and the tale of the tape; they stay centimetre modifiers in the duel (CODE `Duels.gd:412`), never in the grade.
- ON SCREEN (the 3D shows, never decides): step length from Speed and height; step tempo from Speed and the step's grade (a Poor step is
  shorter and later); punch clips within plus or minus 10% by Speed; fading moves slower (M3); the style's look (M4). Stills and a side
  film before any of it ships.

### M6. COACHES: SPEED, SLOTS AND A MARKET (CODE factor + AGREED RPG 11 + NEW)
- SPEED (CODE): pads rating x every bar; rating x every ability.
- SECOND SLOT: an ASSISTANT running the fighter's pad nights with pads 65+. The head coach's pads (ESTIMATE from the background: Ex-pro 70,
  Amateur coach 66, Old hand 62, Strength coach 52) count only on the head coach's own pad places (AGREED RPG 2), never for the slot.
- SIGNATURE WORK AS A RATE: gain above 60 x clamp((pads - 55) / 20, 0.25, 1): Luke Reid 74 x0.95, Marcus Hale 58 x0.25. No wall but the cap.
- THE MARKET (NEW, ESTIMATE; COACHMARKET1 prices them), four assistants, two at once (each paid; the slot reads the better):
  | Assistant | Pads (growth) | Other areas | Wage | Why hire |
  |---|---|---|---|---|
  | Luke Reid (CODE) | 74 (+1 per 10 sessions, to 82) | bag 64, sparring 58 | $450 sessional, three evenings | second slot and Signature work now |
  | Marcus Hale (CODE) | 58 (to 70) | conditioning 90, strength 84 | $1,090 full time | bodies now: every ability faster |
  | A young pads coach | 60 (+1 per 8 sessions, to 72: second slot in about 5 weeks of 8 nights, Signature rate past Hale's in a season) | sparring 55 | $380 | the long bet, cheapest |
  | A footwork coach | 62 (+1 per 10, to 68) | sparring 72 | $520 | footwork nodes x1.2; sparring that holds |
- LETTING GO: a week's pay; growth already earned stays with that coach; slots and rates re-read at once.
- GROWTH (AGREED RPG 11): +1 per 10 sessions in an area to the hire's ceiling; 40 pad sessions on one move opens the coach's signature
  drill (x1.2). The Monday review names each milestone ahead ("The young coach: 12 pad sessions to 65: second slots").
- STAFF JOBS keep one flat effect each (CODE). No "+5% training" perks.

### M7. PROFESSIONALS GET READ (the measured rule, written, for professionals only; READ1 measures before it is on)
- THE RULE: (1) the opponent's corner waits for the professional's line fired most in their last two bouts; when it fires into a waiting
  corner it loses its edge and the counter costs (S427 size, ESTIMATE until READ1). (2) If a second line was fired within a fifth as often
  (a second Signature does this), the corner alternates by round and the read's cost halves. (3) When the Feint line fires in a round, the
  read misses its target for the rest of that round 1 time in 2.
- SHOWN BEFORE THE BOUT: Fight prep names the target ("their corner will wait for your 1-2") with Change the plan and Swap; the Why names the
  rounds it was read and how that line did in them.
- READ-PROOF (the professional's season milestone, lit from the bout's own counts): in two professional bouts running, the read line won at
  least half its exchanges in the rounds it was read, OR the read was split by a second line (rule 2). READ1 passes only if a careful
  professional (second Signature or Feint, plan changed on the target) ends within 2 in 100 of not being read; else the read's size is
  lowered until it does. Amateurs are never read (a rule of the game: club corners do not study club boxers).

### M8. THE FIGHT TEACHES; VETERANS TEACH (NEW, small)
- A planned line that won two or more exchanges adds +3 mastery to its move (the line receipts, CODE "The plan, lit up") and a gold
  FIGHT-PROVEN pin. If the bout cannot attribute an exchange to a line, the pin waits (checked in task 8).
- VETERAN (31+): fades x0.5 on held moves; learning x0.9. A veteran holding a Signature who spars with a club mate learning that move gives
  the learner x1.5 on it that week (needs the AGREED sparring pair, C17, built first). The career's end is the AGREED career clock's
  retirement talk; a retired fighter as a coach is LEFT FOR LATER in the core loop.
- The Why's NEXT names the open node that would have answered what lost the bout, with Pick (a slot free) or Swap (its price).

### M9. FIRE LEVEL ON (CODE `FireLevel.gd`, queue row FIRELEVEL3, re-measured first)
Without it Sharp and Signature are worth about 1 in 100 and the specialty is invisible. With it: Sharp +2.8, Signature +2.7 wins in 100.

### M10. AWARDS: THE REAL TESTS, NO GATES (CODE `SkillAwards`, unchanged)
The six GB Boxing Awards keep their real tests and their 8 coached sessions; a passed grade's moves cost less energy (CODE). They gate
nothing in the tree: chasing Silver (Uppercut and Check hook) is one reason the coach's card can give, never a lock. A start with good
Technique passes Standard and Bronze on sessions alone, as a club boxer who walks in with ability would. The chip shows for amateurs; a
professional's chip is READ-PROOF and the Signature count.

## 5. Amateur weeks against professional weeks along the arc
| | NOVICE AMATEUR | OPEN AMATEUR | PROFESSIONAL | VETERAN (31+) |
|---|---|---|---|---|
| Tree | rows 1-2 | rows 2-3 | row 3 complete; Feint Sharp | complete; holding |
| Slots | 1 (2 with a 65+ pads assistant) | same | same | same; teaches in sparring |
| Specialty | first Sharp (Jab or Cross) | 3-4 held, a style named | 4-5 held, 1-2 Signatures, READ-PROOF | Signatures held at half fade |
| Mornings | job rota (AGREED C31); shadow names a step | same; a gym sponsorship frees six | all free (C31): shadow and bag for footwork and holds | recovery dearer (AGREED T38) |
| Bouts | today offers 8-12 weeks out; with AMATEURWEEK1 (Q-209) a fight week 1-2 weeks out, holds frozen in it | same; the nationals | camps as load blocks (C15), PEAK doubles sparring holds; three promoter offers | fewer, bigger |
| Threat | none from tape | the regional ladder | the READ | the body: Speed falls, steps shorten on screen |
| Eager for | the first pick (week 1), Standard, the first combination, the first rank | Bronze to Gold, the style, the nationals, the pro offer | Signatures, READ-PROOF, a belt | one more title; a club mate's Signature |

## 6. One week played (designer example; on screen each fighter appears by portrait and weight; numbers ESTIMATE from the code)
Week 9. Monday: the welterweight's Uppercut crossed 30 on Sunday night (opens 1-6-3; the slot frees); the lightweight's Step back reached
30. Home: two steel "A move to pick" notes with their portraits. The welterweight's three, in the coach's order: Pivot (Saturday week's
opponent is a Pressure fighter: answers "when pressed"; 2.5 weeks; grade OK), Tie up (answers "when pressed" inside; 2 weeks; grade Good:
inside 66 + strength 63; third move of the Pressure fighter set, with Step in and Body hook already at 52 and 48), Roll out (answers
"loading up"; 3 weeks). The player takes Tie up. The featherweight (bout in 12 days, PEAK) holds Jab and Cross at Sharp; the plan has 5
lines, so Thursday's sparring gives each move about 36 units, doubled in PEAK: both held. The Week's top row, the club's pad-night board:
8 nights; featherweight 3 (Body hook toward Sharp), welterweight 3 (Tie up in the slot), lightweight 2; the grappler's class is separate.
Monday's hold list: the coach dropped the featherweight's Lead hook (Sharp 61, not in the plan; it settles at 50, still a weapon), Undo
beside it; the player leaves it. Sunday: the featherweight's Body hook 57. Next week is fight week: all fades freeze. Row 3 opens for
the welterweight in about week 12 (PROGPROBE1 reports the real week).

## 7. Every menu it appears on, and what each is wired to (names only in headers; rows show portraits, weight or role)
| Menu | What it shows (and what can be done) | Wired to |
|---|---|---|
| Fighter page > Profile | NEXT UNLOCKS: week (nearest line and its day), season (award or READ-PROOF, or the style's missing move), career (pro offer, next Signature with its Technique need, the read); height, reach; style and its effect; award chip (amateurs); each row opens its node | `MoveTree.next_unlocks`, `SkillAwards.progress`, `PadWeek.project`, `Roster.check_pro` |
| Playbook > Moves = THE TREE | 16 nodes by branch and row (toggle BY PLACE IN THE RING); bars, grade, gold pins, styles per node, locks with reasons; the slot(s); the SPECIALTY BOARD (held moves, each move's share this week, what the coach holds and dropped with Undo, the style and its effect, a second set to choose); a node: Watch (CODE clip), Drill, Pick or Swap with its price, Hold or Drop | `MoveTree.gd`, `Specialty.gd`, `LineGrade.grade`, `MoveMastery`, `ui/MoveBook.gd` |
| Playbook > Combos | book combinations greyed with the node that opens them, Pick (slot free) or Swap; own chains as today | `Combos.unlocked`, `MoveTree` |
| Playbook > Game plan | a line whose move is learning: greyed with days to 30; grade letter per line; the style's extra line (cap 7); each line's sparring share ("this plan holds Sharp, not Signature"); a professional's READ target marked | `StrikeMap.grey_reason`, `LineGrade`, `Specialty.share`, READ1 rule |
| Week | TOP ROW: the club's pad-night board whenever 2+ fighters train (CHANGES the agreed R55 row, which shows only with two in camp: named in his approval), portraits on the nights, holds and learning per fighter, the $75 overtime night; the tray with hold cards and the slot card; shadow mornings name their step | `PadWeek`, AGREED PADPOOL1, `Specialty.units_due` |
| Monday review | lines crossed and what each opened; holds kept, frozen or fading; what the coach dropped (Undo); a style named or lost; an award passed; a slot free with the three cards; "back in the gym: holds kept"; a coach milestone | `DrillWeek` news, `Specialty.week`, `SkillAwards.assess`, RPG 11 |
| Home | steel "A move to pick" and amber "A Signature fading" (outside the coach's hold, never in a frozen week), each with the portrait | Home needs, `MoveTree.slot_free`, `Specialty.fading` |
| Fighters cards | style and award (award for amateurs only) | `Specialty.style`, `SkillAwards` |
| Fights > bout card | from the style word: "Pressure fighter: answers held: Tie up; open: Pivot", Pick or Swap | `OppFile` style, `MoveTree.answers` |
| Fight prep | after a tell, the exact answer node, Pick or Swap; for a professional, the read target with Change the plan | `OppFile.tape`, `MoveTree.answers`, READ1 rule |
| Fight night | 3D steps from Speed, height and grade; the style's look; fading moves slower; grade on hover only | `fight3d/BoxerFootwork.gd`, `LineGrade` |
| Result and the Why | FIGHT-PROVEN pins and mastery added; NEXT names the answering node, Pick or Swap; a professional's read rounds and how the line did; READ-PROOF progress | `BoutNight._finish`, `MoveTree.prove`, `FightWhy` |
| Club > People | each assistant's card (name in its header): pads, second-slot line (65), Signature rate, sessions to the next point; the market (four, two at once); Let go with its price | `CoachAreas`, `Data.COACHES`, RPG 11 |
| Signing card / Find a fighter | the day-0 tree, signature move, height and reach, learning speed from coachability and age | `Recruit`, `AttrGen`, `MoveTree.day0` |
| Pro offer | "turning pro brings the read: the most-fired line is the 1-2; a sharp Feint and a second Signature cover it" | READ1 rule, `MoveTree` |

## 8. How it links (deep, not complicated)
Coach (rating, growth, market) -> bar speed, slots, Signature rate -> moves cross lines (week) -> new plan answers and combinations ->
the plan holds its moves in sparring, thinner the longer it is; the rest cost pad units -> the held set names a style that changes the
fight and its look (season) -> fire share by tier and grade by body on fight night -> wins, proven lines, rank, awards -> the pro offer ->
the read, covered by a second Signature or the Feint, READ-PROOF (career) -> veterans teach club mates -> faster bars. On a usual Monday the
player decides at most one pick per freed slot and the club's pad nights; holds run on the coach's default, shown with Undo.

## 9. To be measured before any build (through the game's real code; each prints today's game first)
| Probe | It plays | It passes when |
|---|---|---|
| PROGPROBE1 cadence | two seasons of the four starters through `Sim`, coach's picks and holds; arm A today, arm B this map | a line crossed 3 weeks in 4 per fighter; a pick every 2-4 weeks; no gym week with nothing crossed; a style named in season 1; first pick in week 1 for all four starts; it reports the week each row opens |
| HOLD1 the specialty | four hold policies (coach's default, widest, deepest, plan only); plans of 4, 6 and 7 lines; a Signature; FOUR BOXERS on 8 nights; an injury layoff; the camp phases | a careful player holds 4 Sharp and 1 Signature AND gets a move to Usable within 4 weeks; plan length is a real trade (4 lines hold more, 7 answer more, neither best in more than 2 of 3 line-ups); same-start fighters end season 2 with different held sets; the hold units set |
| STYLE1 | prints the day-0 distance table and the measured weeks to each style; each style's effect on the played bout, four opponent styles | each worth 1.5 to 4 in 100 against what it suits; none best against all; none named in more than 1 career in 3; two sets held at once under 1 in 4; no set more than 20 points from the others in weeks |
| TREEVALUE1 | each node at Usable and Sharp (60 generated fighters, four styles, FireLevel on) | every node 1.5 in 100 against at least one style; none best against all; wins still rise from 6 to 9 Usable answers |
| PICKSPREAD1 | 60 fighters, first five picks, each card played 6 weeks on; Pivot's share and the award-test card's share reported | no card position best in more than 6 in 10; the coach's first card best in under 5 in 10; no single node best in more than 4 in 10 of the picks it appears in |
| READ1 | professionals with one Signature, two, a Feint, a held style; plan changed on the target or not; read on and off | a careful professional ends within 2 in 100 of not being read; one Signature and no change costs 4 to 7; READ-PROOF lit in the first pro season by a careful player, not by a careless one |
| GRADE1, BODYFACT1, FOOTWORK1 | grade multipliers; height and reach on our fighters; gated steps | Good vs Poor on a line 2+ in 100; longest vs shortest in a class 1-4 in 100; a stepless novice 1.5-5 more in 100 to pressure |
| COACHMARKET1 | the four assistants over three seasons, wage per useful point | no hire best in more than 2 of 3 line-ups; Luke Reid best for season-1 Signatures, the young coach by season 2 in at least one line-up, Marcus Hale best for a body-led line-up |
Results into `ops/AgentComms/levers.json` (C27 cut rule). A mechanic whose probe fails is redesigned before it is drawn.

## 10. Build order (after his OK; each task under 500 lines, one owner, its test red on main first)
1 FIRELEVEL3 (queued). 2 BODYFACTS1 (Qwen). 3 MOVETREE1 (Goose, pure: tree data, rows, row lock = learning only, day 0, old saves,
answers, tests). 4 STEPMASTERY1 (Claude: steps and defences get mastery; FireLevel, PlanFight, StrikeMap read it). 5 LINEGRADE2 (Claude).
6 SLOTS1 (Qwen, pure: slots, the three cards, learning speed). 7 C20 "Coach runs it" control (AGREED, before the coach's hold).
8 SPECIALTY1 (Qwen, pure: the hold rule on shares, frozen weeks incl. injury, the coach's hold and its drop list, styles, their effects
as numbers) + wiring in PadWeek (Claude). 9 FIGHTPROVE1 (Claude; attribution checked first). 10 READ1 rule and READ-PROOF counts
(Claude, after its probe). 11 COACHMARKET1 data, head coach pads, let-go (Qwen). 12 the probes (Goose / Arena), in the order FIRELEVEL3,
HOLD1, STYLE1, READ1, PICKSPREAD1, TREEVALUE1, COACHMARKET1. 13 SITWORDS1: situation words without pronouns (Claude). 14 screens (Grok
Dev, one a task, from an approved drawing): the tree page with the Specialty board, the pick cards, the Week's pad-night row, the Profile
strip, the Monday rows. 15 BOXSTEP3D1 (Ziva, after stills: step reads, style looks, fading). 16 C17 sparring pairs (AGREED), then veteran
teaching. 17 golden path (Grok Dev): signing to the pro offer, the week-1 pick, a style named and lost, holds frozen in a fight week and
an injury, a Signature with the cap shown, the read shown in Fight prep and covered by a Feint, READ-PROOF lit. Coach growth (RPG 11) after
the fighter loop has been played.

## 11. Rejected, and why
- A separate fighter experience or stamps: a second currency; the bar is the experience.
- Awards as row gates (R1: the pick became a lookup); invented tests under the real award names (R3).
- Hard Sharp slots: holding by the club's real scarce pad nights and the plan's sparring share does it.
- A sparring night that holds every plan move in full (R3: the code shares it; the share is the better trade).
- The old trainer (pads 80, no growth): 2% faster bars than Luke Reid for twice the wage (R3).
- New punches (overhand, body jab, shoulder roll): need clips and fight hooks; later nodes once TREEVALUE1 proves the 16.
- Coach perks of "+5% training"; a training mini-game (grind); gating own chains (a built feature he calls fun).

## 12. Risks, said plainly
- Holds as chores: the coach holds by default (shown with Undo), the plan holds itself in sparring, fight weeks and injuries freeze.
- Gated steps could punish novices: FOOTWORK1 bounds it; old saves start plan steps Sharp.
- The read could tax professionals: READ1 must show it can be covered to within 2 in 100.
- Style effects could dominate: STYLE1 bounds each at 1.5 to 4 in 100.
- 3D reads need clean stills before they ship; the numbers ship first.
- One agreed rule changes: the pad-night row on the Week becomes every week (named in his approval).
- AMATEURWEEK1 (Q-209) changes the novice's bout rhythm; this map works on today's rhythm and on that one.
