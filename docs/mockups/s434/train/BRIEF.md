# TRAINSCENE1: training as its own scene, and a summary on the fighter's Training tab (design brief, S434)

Roadmap row TRAINSCENE1 (after FOUNDATION). Author: Claude. Status: brief for the redraw; then two fresh critics, then the owner.
This brief adds NO rule. Every item names the decided rule or the code it shows: TR = `ops/research/TRAINING_MAP_S432.md` v6.1 (passed 7, 7),
CL = `CORE_LOOP_MAP_S432.md`, CW = `CLUBWEEK_MAP_V41_S432.md`, PB = `PLAYBOOK_MAP_S432.md`. Tags: CODE (in the game today), MAP (decided, not
built), and UI (a screen decision of this brief: where a thing sits, never what it does).

## 0. What the owner said, and what this brief answers

- S354: "when picking up the morning exercises it has to sum up gains/loses towards a goal , first week comes close to the goals,then the
  player adjust a bit the intesity to burn weight for example , then the planner for the moves should be another mechanism for the player to
  make unique combinations to improve the fighter ... display it properly to the player the progress of the move, the effectiveness of the
  combos the gains, the losses and everything".
- S370: "assigning training, planning moves for the fighter, booking the fight, how the fighter improves - all these need special
  attention"; "a fighter doesnt want to compete just learn and get stronger, faster - how we make the player feel the goal"; "stitch moves
  like hollywood animal ... display the combo strength/stamina cost"; "moves and strikes as cards".
- S434, his marks on `training_v2.png` (`ops/Feedback/2026-11-11-08/marked.png`):
  - Mark 1, the load panel: "too much room for a simple slider and headline weekload". Answered in section 3C: one slider and one headline.
  - Marks 2 and 3, the abilities table: "i dont understand any of this". Answered in section 3F (three plain lines) and section 7 (the table is cut).
  - Mark 4: "whatif the re is no fight booked , what is displayed there. ? the whole page needs better communication to the player and what
    exactly happens when he changes or sets the program ? where is he learning the moves ;and the combos ? what kind of traning is this ? the
    training should be seperate on a different scene i think and here only display a sumamry maybe ?" Answered in sections 4 (no bout), 5
    (what a change shows), 3E (moves and combinations), 3A (what kind of training), 2 and 6 (its own scene and a summary).
  - In chat: "i thought i told you to pay special attention to all the training mechanic".

WHY THE LAST PAGE FAILED. The map was deep enough: it passed two critics at 7. The page failed because it printed the map. It had fourteen
rows, multipliers, four load cards with three numbers each and a "kept by" column. None of it says what one click does. This brief keeps every
decided mechanic. It changes what the player looks at first: THREE SUMS THE MORNINGS FILL (the goal, the weight, the Tank), CARDS FOR MOVES AND
COMBINATIONS, and ONE LINE FOR EVERY CHANGE. Everything else goes one hover down or onto the page that owns it.

## 1. The questions a new player has about training, and where each is answered

| # | The player's question | Answered by | Where | Rule / code |
|---|---|---|---|---|
| Q1 | What is training? What do I actually do here? | The scene's two lanes, named on screen: MORNINGS build the body and skills. EVENINGS (the pads) learn moves and combinations. | Scene, lane titles + first-week guide line | TR T3 (one session per job), CW 3.1 (pad places), PadWeek.run_week (CODE) |
| Q2 | What kind of training is this week? | One header line: the block word in plain words, the load and who runs it. Example: "Base week: building the engine · Normal · Coach's week" | Scene header A; tab line 1 | TR T35 (BASE / SPECIFIC), T9 (strip blocks), T1 (load), C20 (Coach runs it) |
| Q3 | What will this week do to my fighter? | Three meters the mornings fill, each card adding its piece: GOAL, WEIGHT, TANK AT THE BELL. Three plain lines under them: WHAT THE RING GETS | Scene B, F | FighterGoal + TR T25 (bands), T8 (weight), F5/T14 (Tank), T17 (lines), TrainWeek.run (MAP) |
| Q4 | What changes if I pick Hard (or Easy, or Sharpen)? | The slider prints ONE line before you let go, for example: "Hard on Footwork: Footwork 60 by 4 Apr (58 on Normal) · injury 1 -> 2 in 100 · Tank 95 -> 94". The meters move. | Scene C + the change line G | TR T1 (the card's three numbers), T24 one run (ONERUN1), T30 two horizons |
| Q5 | How close is my goal? | The goal meter: now -> forecast -> target, the band word (met / close / short / missed) and the date | Scene B; tab line 2 | FighterGoal (CODE: met +10, missed -20), TR T25 (four bands, GOALBAND1), WeekPlan.project (CODE) |
| Q6 | Where does my fighter learn a move? | EVENINGS lane: each pad place holds one card. The card's ladder shows New > Learning > Usable 30 > Sharp 60 > Signature 85 and the day it climbs | Scene E; tab line 3 | PadWeek (CODE: pad nights 240 min split over the cards), MoveMastery.LADDER / GAIN_PER_HOUR (CODE), CW 3.1 (8 pad places) |
| Q7 | How do I build a combination? | "Build a combination" on the evenings lane opens the COMBO BENCH in the scene. Move cards are stitched left to right, each join judged, with totals. "Drill it" puts it on a pad place | Scene E2 | ComboBuilder, ComboStrip, ComboFlow, ComboOdds, OwnCombos (all CODE), PB 4.6 (own chains are lines) |
| Q8 | What happens when no bout is booked? | The season target takes the bout's place everywhere: header, the buys panel, the sort of WHAT THE RING GETS, the Tank meter folded | Section 4 | CW 3.9 (season target), TR T18 ("with no bout, to the season target's pull"), T30, T5-7 (own tape) |
| Q9 | What did last week actually do? | Tab line 5 and the scene's "Last week" chip: whole points with their cause ("Stamina +1: roadwork Mon, Fri"). The full list is in the Week review | Tab; Week review | WeekCause.words (CODE), WeekRead.cause (CODE), TR T20, CL Week review |
| Q10 | Who is coaching each session, and can I change that? | The stripe on each card: You (gold), Coach (blue), alone (grey). Coached mornings and pad places are dealt on Club week, so they show LOCKED with "change on Club week" | Scene D, E | CW 3.1, CL C17, TR section 4 table |
| Q11 | Is my fighter getting hurt or worn out? | A NIGGLE card appears only when there is one, with its two answers priced. Tiredness feeds the Tank meter | Scene H; tab alert line | TR T19, T31, InjuryRoll (CODE) |
| Q12 | Can I just let the coach do it? | "Coach runs <name>" on the scene footer and the tab | Scene G; tab | CL C20, TR T11 |

## 2. The decision: one scene for training, one summary tab

- THE SCENE (UI): `Training` is a scene of its own (CLAUDE.md rule 5: one scene per screen). It is a full 1920x1080 page in today's dark gym look:
  the matched look of `docs/mockups/s431/final/overview.png`, with the same top bar, face pins and gold primary button.
  - Ways in: the fighter's Training tab button "Open training"; Profile's "Plan the week" (already painted); the load chip on a Club week row;
    the Playbook's ON THE PADS / ON THE MORNINGS buttons (PB 4.9, PlanCards.drill_it CODE); the Why's "Train X" / "Rest the hand" (TR section 7,
    last row). Each way in arrives with that thing already set and its change line showing.
  - Back always returns to where you came from (Miro frame 5).
- THE TAB (UI): Fighter page > Training becomes five lines and one button (section 6). The tab names (Profile, Condition, Training, Playbook,
  Fight plan, History, Character, Crowd: C21) are unchanged.
- The four face pins switch fighters inside the scene. The grappler's scene is the same frame with mat classes in the evening lane (section 8).

## 3. The scene: what it shows and what the player DOES

Layout (UI), top to bottom:
A header · B the three sums (the middle, largest) · C the load slider · D mornings lane · E evenings lane (the pads) · F what the ring gets +
what this week buys (right column) · G the change line + footer · H the niggle card (only when one exists).

### A. Header: who, what kind of week, toward what
| Shows | Plain words on screen | Rule / code |
|---|---|---|
| Name, weight class, age chip | "Samira Khan · Welterweight · 18: grows x1.1" | TR T38 (age, MAP) |
| WHAT KIND OF TRAINING | One line: block word + what it means + load + who runs it. "Base week: building the engine · Normal · Coach's week" / "Fight week: stay fresh, stay sharp · Sharpen" / "For the fight: what Kayleigh tests · Hard on Footwork" | TR T35, T9, T1, C5, C20 |
| THE TARGET | With a bout: "Bout Sat 28 Feb vs Kayleigh Bell · 12 days". With none: section 4 | CW 4, 3.9 |
| The strip, 6 weeks | One tile a week, a block word and one number each: build weeks "safe 107"; bout days "Tank 95"; REST "sparring from Thu 5". Click a build week: its emphasis (Base / For the fight) and its aim | TR T9, T35 (emphasis + aim per block), T14 |
| Direction chip and discipline chip | "Direction: Keep it long"; "Discipline 46: asks to ease Hard". Both are hover-only past week 8 | TR T38, CL C22 |
Screen words (UI, for the critics and the owner): BASE prints "Base: building the engine and strength"; SPECIFIC prints "For the fight:
<what the opponent tests>" and, with no bout, "For the target". The map's names stay in the code.

### B. The three sums: the mornings add up toward something (the owner's S354 mechanic)
Each meter is a bar from NOW to the LINE. The week's morning cards drop onto it as segments, one per day, coloured by the session. Losses show
as red segments. The headline is in whole points with the band word; the decimals are on hover (TR T17, T25).
| Meter | Fills from | The line | Losses shown | Rule / code |
|---|---|---|---|---|
| GOAL | the mornings and nights that train the goal's ability ("Stamina: only Wed feeds it this week") | the goal value and date: "Stamina 62 -> 63 by Fri 13 Mar · close" | a fade (red, "fades 9 Mar: no intervals") | FighterGoal (CODE), TR T25 (bands), T15 (fade by dose), T36 (roadwork vs intervals), WeekPlan.project (CODE) |
| WEIGHT | each session's kcal + the diet (Hold / Lean / Cut chips under the bar) | the class limit and the weigh-in day and hour: "65.9 -> 65.0 by 16 Mar · day before, 24 h to refill" | Cut's "mornings x0.9" as a red chip on the goal meter | TR T8, T3 kcal per morning, Diet kcal (CODE) |
| TANK AT THE FIRST BELL | tiredness day by day to the bell (a small 13-day line under it) | 100, with each part off named: "95: tiredness 35 at the bell -4.5" | a day at 72+ marked; a rule's dot | TR F5, T14, T31, T37 dots; BoutRules.tank (MAP) |
- What the player does here: nothing directly. These are the sums. The player changes the cards (D, E), the slider (C) or the diet chips, and
  watches the three bars move. This is S354's loop: week 1 lands close, then the player tunes the intensity or the diet.
- The goal meter accepts "Set a goal" when none is set (FighterGoal; the Profile's goal ring is the same goal).

### C. The load: one slider and one headline (his mark 1)
- A four-stop slider: EASY · NORMAL · HARD · SHARPEN. In a fight week the stops are Easy, Normal and Sharpen; Hard is not offered (TR T1, CL C5).
  It is carried week to week (TR T1).
- The headline beside it, one line: "Normal · 82% of a usual week" (TR T1's plain card). Week 1 shows only this (TR 11.5).
- Dragging prints the change line (G) before release. It shows the three numbers TR T1 names: the aim at the target, injury in 100, the Tank
  at the first bell.
- On HARD, a chip "Hard on: Footwork" opens WHERE HARD PAYS MOST (TR T1): the top three aims with whole points by the target against Normal and
  the line each reaches ("Footwork 60 (58): Jab and move Good"). The default aim follows TR T1's rule.
- The fighter's ask sits on the Hard stop: "Samira: 'ease the Hard days' · overrule: mood -5" (PushBack CODE, TR T26).
- Hover on the headline: work, clock hours, "usual 92 · safe to 120", the pattern warning (TR T14, PATTERN1).
- MORNING RULES (TR T37): one folded chip "Coach's rules: 3 of 4 on". It opens the four toggles, each with the number it reads. Cells where a rule
  fires carry a small mark.

### D. Mornings lane: seven session cards (the body and skills)
- Seven cards, Mon to Sun. Each card: the session icon and name; the ONE ability it trains in plain words with its ring meaning (TR T3's printed
  words: "Intervals: each round costs less; no fade from 64"); a gold edge when you changed it; who coaches by stripe. Coached mornings are dealt
  on Club week and show a lock and "change on Club week" (CW 3.1). Job mornings are dim and read "at work" (CW 3.3, TR 5b). A professional has none.
- What the player does: click a card to swap the session. The picker shows the ten sessions as cards (TR T3), each with its effect on the three
  meters in one line. A card whose session doses a fading ability shows "keeps Speed" (TR T15).
- On hover: the pace, the coach's lift ("+48%", "x0.8 alone": TR T25-29, CoachAreas CODE) and the reason. These were on the face of the cells
  before and are cut from it (section 7).

### E. Evenings lane: THE PADS. Moves and combinations are learned here (his "where is he learning the moves and the combos")
- The lane title reads "EVENINGS: the pads · where moves and combinations are learned".
- One slot per PAD PLACE the fighter got on Club week (CW 3.1: 8 in the club, asked 10-13). The slot count is locked here ("3 pad places · more on
  Club week"). A sparring night shows its setting and partner, locked (CL C17), and what it trains (TR T4). A sparring night also trains every card
  already Usable (PadWeek, CODE).
- Each pad place holds ONE CARD (S370 "moves and strikes as cards"):
  - Card types (PadWeek CODE ids): move, book combination, own combination, a habit fix (TR T5: 3 pad places to half fixed, 3 more to gone).
  - On the card: the face (move name and icon); the LADDER as five pips, New > Learning > Usable 30 > Sharp 60 > Signature 85
    (MoveMastery.LADDER); a bar from now to this week's end; the day it climbs ("Usable Mon 2 Mar"), with an amber "after the bout" tag when
    that day is past the bout (TR T2); "fires 1 in 2 at Usable" (FireLevel, TR T10).
  - A FADING card shows its date (MoveMastery.decay_week CODE, TR T15). A card at its move ceiling says so (TR T10).
- What the player does:
  1. Drag a card from THE HAND onto a pad place. The hand is a drawer at the lane's end holding the fighter's moves (MoveBook CODE), the book and
     own combinations, and the habit cards. The card it displaces is priced ("takes Mon's: Check hook Usable Thu 5 Mar": TR T10 KEEP-IT).
  2. "Build a combination" opens THE COMBO BENCH (E2).
- E2. THE COMBO BENCH (in the scene, a panel over the lanes; all CODE except where marked):
  - The fighter's moves as cards (ComboBuilder.PALETTE), stitched left to right on the strip (ComboStrip.strip). Each join is judged in the
    coach's words (ComboFlow).
  - The totals S370 asked for: STRENGTH (ComboFlow score), GAS (the share of a round it costs: ComboFlow.energy), LANDS IN (BeatClips.IMPACT_S),
    and LANDS WHOLE against the next opponent (ComboOdds). PB 4.6 cuts the DAMAGE tile.
  - The fit against each game, Beats it / Works / Walks into it (PB 4.6 OwnLine, MAP).
  - The fighter's body throws it on a loop (MovePlayer.show_chain).
  - Save adds it to the fighter's book (OwnCombos). "Drill it" puts the new card on the next free pad place with its change line: "2 pad places:
    Usable by Thu" (PB 4.9).
  - The Playbook tab stays the RECORD of moves and combinations, with tiers and the bout record (PB 6). The bench is where they are made.

### F. Right column: WHAT THE RING GETS and WHAT THIS WEEK BUYS (his marks 2-3: the table goes)
- WHAT THE RING GETS: at most THREE lines, the three abilities this week moves most toward a line. Each line is one sentence in game words
  (TR T17's rule: the row names the line it reaches and what the points under it already buy):
  - "Footwork 57 -> 58 · Jab and move works better (Good at 62)"
  - "Stamina 62 -> 63 · no tiring in round 3 from 64"
  - "Defence 51 · Hands up helps from 56"
  Sorted by what the opponent tests, or with no bout by the season target (TR T18). The full 14 with ceilings stay on PROFILE (approved bars with the
  ceiling tick and "+0.4 a week", CL 3). A "Show all" opens Profile, not a table here.
- WHAT THIS WEEK BUYS, with a bout (TR T23), at most four lines: ready on the night ("sharp" and the Tank: FL M6, F5); the goal's band; a habit's
  state ("habit: half fixed by Sat 28"); the biggest lever still open ("Push on: habit GONE, the hand at risk"). Its size in exchanges shows only once
  LEVERS1 has the row (TR T23, CL C13/C14). Until then the line has no size.
- "Last week" chip: the top two causes (WeekCause CODE). It opens the Week review.

### G. The change line and the footer: what exactly happens when the player changes the program (his mark 4)
- THE RULE (TR T24, ONERUN1; TrainWeek.run, MAP): every change re-runs the week WITH it and prints the difference.
  - ONE LINE, bottom centre, in the change's own colour. At most three terms, picked in this order: the goal's band if it moves; the aim's whole
    points at the target; injury in 100; the Tank at the first bell; weight on the scale day; a card's next-tier date.
  - Examples: "Intervals on Sat: Stamina goal close -> met · Tank 95 -> 94" / "Cut: 65.0 by 9 Mar (16 Mar on Lean) · mornings x0.9" / "Check hook on
    Tue: Usable Fri 27 (Mon 2 Mar) · Lucy goes short on Club week".
  - The three meters animate to the new sums (feedback_animated_meters: every bar tweens).
  - A range shows only when the response is unknown (TR T38). No dice.
- Changed cells keep a gold edge (TR T10-13). Footer, three buttons only: "Back to Coach's week", "Coach runs Samira" (CL C20), "Done"
  (gold). "Keep my changes next week" is a toggle beside Done (TR T13).

### H. The niggle card (only when one exists)
- A card over the lanes. Example: "Right hand sore · 4 hand days this week". It offers REST IT and PUSH ON, each priced in the meters' terms (TR T19:
  "Rest it: habit half fixed Sat 28; no bag, Explosiveness fades 9 Mar" / "Push on: hand injury 4 in 100, the bout off"). Unanswered on Monday, Coach
  rests it. It is the one mid-week stop (TR T13).

## 4. No bout booked: the season target takes the bout's place (his mark 4, first question)
| Panel | With a bout | No bout booked | Rule / code |
|---|---|---|---|
| Header target | "Bout Sat 28 Feb vs Kayleigh Bell · 12 days" | The season target and its date: "Target: the nationals · entries close Sun 15 Mar · 2 bouts to go" / "Target: the pro offer · 7 wins and top 3 (5 wins, No. 6)" / "Target: a year to grow · two perks by Oct". Plus "Next offers Mon 19 Jan" | CW 3.9, SeasonPath (CODE), CL 3 Fighters page "No bout, next offers ..." |
| What kind of week | "For the fight: what Kayleigh tests" | "Base: building the engine" or "For the target"; Coach's default is BASE when the next bout is 5+ weeks off | TR T35 |
| Tank meter | Tank at the first bell | Folded to one chip: "No bout: tiredness 41, fresh by Thu". It opens when a bout is booked | TR T14 (Tank on bout days); reveal order TR 11.5 |
| What the ring gets | sorted by what the opponent tests | sorted by the season target's pull: the weak spot, the weapon and the goal Coach deals toward | TR T18, CW 3.2 (pulls), CL C22 |
| What this week buys | "SAT 28: WHAT THIS WEEK BUYS" | "<TARGET DATE>: WHAT THIS BLOCK BUYS": the goal's band, the weapon's date ("Fast hands at Speed 70: about 4 weeks"), the weak spot's line, the next tier on the pads | TR T30 (the second horizon), CW 3.2 |
| Pads | the cards that answer the opponent first | the weapon and the weak spot first; FILM becomes "your own tape": 2 pad places, a hidden habit 1 in 2 | TR T5-7 (OWNTAPE1), PB 4.9 |
| Slider | Easy / Normal / Hard / Sharpen | same four; Sharpen reads "a deload: nothing fades" | TR T1, T9 |
| The tab's line 4 | "Bout Sat 28 vs Kayleigh · sharp · Tank 95" | "No bout · target the nationals, entries close Sun 15 Mar" | as above |

## 5. What a change shows (one sentence, for the brief's reader)
Every change runs the week again and prints, in one line at the bottom, the difference in the goal's band, the aim's points by the target,
injury in 100, the Tank at the first bell, the weight on the scale day or a card's next-tier date (at most three of them). The three meters
then move to the new sums. TR T24 one run (TrainWeek.run, ONERUN1), T1's three numbers, C13 units.

## 6. The fighter's Training tab: the summary (his "here only display a summary")
Five lines and one button, in the matched look: an icon, a number and a short caption per line, with the words in the hover.
| Line | Example (Samira, Mon 16 Feb) | Rule / code |
|---|---|---|
| 1 What kind of week | "Base week · Normal · 82% of a usual week · Coach's week" | TR T35, T1, C20 |
| 2 The goal, as a small ring | "Stamina 62 -> 63 by Fri 13 Mar · close" | FighterGoal, TR T25 |
| 3 On the pads | "Check hook · Learning -> Usable Mon 2 Mar" (+ "2 more cards") | PadWeek.project, MoveMastery |
| 4 Next | "Bout Sat 28 vs Kayleigh Bell · sharp · Tank 95" or the no-bout line (section 4) | TR T23, CW 3.9 |
| 5 Last week | "Stamina +1 · roadwork Mon, Fri" | WeekCause, WeekRead.cause |
| Alert (only when one exists) | "Right hand sore: answer on Monday" (red, clock-stopping needs stay on Home) | TR T19 |
| ONE BUTTON | "Open training" (gold) | UI |
- WEEK 1 (TR 11.5 reveal order): lines 1 and 3 only, with the button. The goal ring comes once a goal is set. "Next" comes with the first
  sheet. "Last week" comes on the first Monday.

## 7. What of today's page (`training_v2.png`) is cut, moved or kept
| Today's panel | Fate | Goes to |
|---|---|---|
| THIS WEEK'S LOAD, four big cards with three lines each (mark 1) | CUT to a slider + headline | Scene C; the three numbers go into the change line; the lays, work and clock hours go to the headline's hover |
| ABILITIES table: worth dots, "tests x1.3", now, room bar, fast/slow, next line + date, 4 wks, kept by (marks 2-3) | CUT from Training | Three plain lines (F); the 14 with ceilings on Profile; the opponent's multiplier, worth, response and trend go to the ability's hover on Profile; "kept by" becomes a red "fades <date>" chip on the goal meter only when something fades |
| "ABILITIES by worth against Kayleigh" header (mark 4) | CUT | Header A's target line (bout or season target) |
| THE WEEK grid cells "+48%", "x0.8", "Kayleigh", "weak spot" | MOVED to hover | Card hover (D) |
| PAD PLACES panel, small rows | KEPT and promoted | Evenings lane (E) with cards and ladders |
| BODY niggle panel | KEPT only when a niggle exists | Niggle card (H); tab alert line |
| SAT 28: WHAT THIS WEEK BUYS | KEPT, at most four lines | Right column (F); tab line 4 |
| TO THE BELL chart | KEPT small | Under the Tank meter (B); the long curve stays on Condition (CL 3) |
| WEIGHT panel | KEPT as a meter | The weight meter + diet chips (B); also on Condition |
| The season strip (top date tiles) | KEPT, 6 weeks | Header A; not on the tab |
| "Recovery 50: clears 12% a night" in the header | MOVED to hover | Recovery's hover on Profile and on the Tank meter |
| Morning rules toggles | FOLDED | One chip, "Coach's rules: 3 of 4 on" (C) |
| Footer: five buttons | CUT to three + a toggle | G |
| "Season so far" | MOVED | History / Week review (TR T20) |
| The key "You / Coach / alone / your change" | MOVED to hover | The stripe's hover |

## 8. The other three fighters on the same frame
- LUCY, the professional (TR 8b): no job mornings (C31). The strip shows the camp's BUILD (Base) / PEAK (For the fight) / TAPER (Sharpen) blocks
  (T33). The weight meter shows the day-before scale and the water line ("Lean + 0.8 kg water: Tank -4", T8). WHAT THIS WEEK BUYS becomes "FIGHT
  NIGHT: WHAT THIS CAMP BUYS" with PEAK CAMP's three ticks.
- ANA, the grappler (TR 8c, MP): the evenings lane holds the three MAT CLASSES as cards (Drill / Positional / Hard rolls / Film, BJJCLASS1, MAP).
  Each card names the mat-plan line it feeds. The buys panel reads "THE OPEN: WHAT THIS WEEK BUYS". The combo bench is replaced by the drill's move
  (NoGi CODE).
- The second amateur: the same frame as Samira.

## 9. Wiring: each scene element to its rule (for the critics and the Cursor brief)
| Element | Reads | Built? |
|---|---|---|
| Three meters | TrainWeek.run (goal ability, weight, tiredness -> BoutRules.tank) | MAP (TrainWeek, tank); FighterGoal, WeekPlan.project, Diet CODE |
| Slider + headline + Hard aim | WeekPlan INTENSITY + the Hard lay (F8 DOSE1), TR T1 default aim, PushBack | partly CODE; F8 in FOUNDATION |
| Morning cards | WeekPlan.SESSIONS, Attrs.SESSION_ATTRS shares (MORNINGS1), CoachAreas, MorningRules | CODE + MAP |
| Pad places and cards | PadWeek.run_week / project, MoveMastery, FireLevel, OwnCombos, Combos | CODE |
| Combo bench | ComboBuilder, ComboStrip, ComboFlow, ComboOdds, MovePlayer, OwnCombos | CODE (moved into the scene) |
| What the ring gets | TR T17 lines (Exchanges.grade after F10, PerkRoad), OppTests (MAP), Attrs.VALUE | partly CODE |
| What this week buys | TR T23 (Readiness FL M6, HabitWork, the goal) | MAP |
| Change line | TrainWeek.run diff (ONERUN1) | MAP |
| Niggle card | Niggle, TrainAround (MAP), InjuryRoll (CODE) | MAP |
| No-bout case | SeasonPath, CW 3.9 season target, CW 3.2 pulls | CODE + MAP |
| Summary tab | the same reads as above, one line each | UI |
GOLDEN PATH (EVERY NEW MECHANIC rule): one test walks the tab -> "Open training" -> the slider to Hard (the change line names the aim and injury)
-> a morning swapped to intervals (the goal meter's band moves) -> a move card dragged onto a pad place (its Usable date shows) -> a combination
built and drilled -> Done -> the tab's lines changed. Then the same walk with no bout booked (the target line, the folded Tank).

## 10. For the redraw and the critics
- STILLS TO DRAW (1920x1080, tools/render_mockup.py, text 20 px or more, no clipped cell):
  1. the scene with a bout (Samira, 16 Feb, Base week);
  2. the scene with no bout (a Base week toward the nationals);
  3. the combo bench open;
  4. the summary tab;
  5. the tab and the scene in week 1 (reveal order).
- THE CRITICS' QUESTION FIRST (S434 lesson; NEXT_SESSION_PROMPT): "Would a player who never read the map understand this screen? Say what each
  click does before reading any caption." Then the CRITIC_PACK questions (missing options, useless ones, what each changes). Each critic ends with
  the list to 10/10 and a drawn 10/10.
- OPEN ITEMS (these do not change rules; they are decided at the redraw):
  - the screen words for BASE / SPECIFIC (proposed in A: "Base: building the engine", "For the fight / For the target");
  - whether the 13-day line fits under the Tank meter at 20 px, or moves to the Tank's hover;
  - "the season target's pull" sort (TR T18) is read from CW 3.2's pulls. If the run cannot rank them, it falls back to the goal's ability first.
- NOTHING IS BUILT before FOUNDATION lands and TR section 10's gate table is filled (CL 4). The meters' numbers come from the run, never from this
  brief's worked examples (TR section 9: Samira's numbers are hand-worked).
