# DESIGN STANCE1 - the stance pad, a map from the code (S536, Fable console)

Brief: `ops/research/TASK_STANCEPROBE1.md` (owner S536 "yes both"). Mockup: `docs/mockups/s536/stance.png`. Probe: `tools/stanceprobe1.gd`, result
`docs/STANCEPROBE1_RESULT.md`. Nothing under scripts/ was edited. Prior research run: `prior_research.py stance footwork guard posture`
(the canonical page is `ops/research/topics/footwork.md`: it has studies on southpaw, bearing and steps, NONE on foot width or
angle; `K46_BOXER_FEET_DURING_PUNCHES.md` 93-96 says outright "stance width/length: NO STUDY", coaching says "a little more than
shoulder width"). Memory S528: posture is already the corner's ONE CHANGE (Adaptation) - checked, section 4 builds on it.
Tags: **CODE** = I opened the file on 2026-11-21 (main at 3fe705b8f plus the STEPPAY2 working tree) and the line is true.
**PROBE** = measured by tools/stanceprobe1.gd. **ESTIMATE** = a size or rule of mine. **DERIVED** = my sum from CODE or source numbers.
`StepWire.gd`, `LiveRound.gd`, `LineGrade.gd` carry another session's STEPPAY2 edits: read only, line numbers are the working tree's.

## 0. The short version
- The game has NO stance width or angle today. "Stance" in the code is only orthodox / southpaw (`Duels.facts` 416-426,
  `BoutRules.stance_edge` 163). So the pad is a NEW mechanic, not a tuning of an old one.
- It does not need a new fight rule. Every chip on the mockup already has a number the fight reads: the boxer's own
  attributes (`Attrs.of` 59-84), which the duel, the knockdown rule and the tank all read. A stance is a small, two-sided
  change to those numbers. The probe did exactly that on a local copy and played the game's own fight night.
- Feet = set in camp (weeks to own). Weight lean = the corner's ONE CHANGE between rounds. Hands = the guard v7 plan line.
  Three clocks, one page for the player: "How he stands" (section 4, the merge answer).
- PROBE verdict: **FAIL, twice** (section 7). Round 1 (three attribute points a step): six of ten effects moved fewer than 2 bouts
  in 100 and Squared won every cell. Round 2 (the one resize): every effect moves and no stance dominates, but only 1 of 10
  cells has a clear best. The pad is real and too fine to feel. It comes back to Claude; no critic brief.

## 1. What the code does today, and where each effect plugs in (CODE)

### 1.1 The one place all of it meets: the boxer's attributes
- `Attrs.of(f)` (Attrs.gd 59-84) returns `f["attrs"]`: 14 abilities, 4 punches (jab, straight, hooks, uppercuts) and the
  old names the fight still asks for, written by `_alias` 256-268 (guard, head_movement, power, chin, body, foot_speed,
  hand_speed). It is rebuilt only when a stat, the footwork number, a dial or a move's mastery changed (`_clean` 88-109).
- A stance would be a LAYER on that dict, added in one new pure function (say `Stance.apply(attrs, cell, natural, owned, lean)`)
  called where the bout copies the boxer in (`RingDuel.step` 108, `BoutNight.count_sides` 236, `BoutNight._energy` 328,
  `LiveRound.open` 104). It must NOT be written into the stored attributes (training reads those).
- Trap found by the probe: a punch written under its move's mastery, or Timing changed, makes `_clean` false and the game
  rebuilds the dict (`_punches_match` 112-123, the raw floor `PunchStart.raw_floor` 34). The first smoke run lost 296 copies this
  way. The build must layer, never overwrite.

### 1.2 Chip by chip
| Chip (mockup) | The number it would move | Where the fight reads it | Today |
|---|---|---|---|
| Rear power | `power` | the pocket's power tool x0.45 and the inside body tool x0.25 (`Duels.TOOLS` 16-26, `_ob` 189); the knockdown's punch 0.7 x power (`RingDuel.side` 138, `Knockdowns.round_counts` 34: every 12 points over the chin = x e); the hurt roll (`RingDuel.settle` 383) | CODE |
| Slips | `head_movement` | the answer to all three pocket tools (0.25 / 0.30 / 0.22), the step-in's answer 0.6, closing 0.2 (`Duels._ctrl` 340) | CODE |
| Stays up | `chin` | the knockdown's chin and the hurt roll (`Knockdowns` 34, `RingDuel.settle` 385) only | CODE |
| Step speed | `foot_speed` | the answer to every long-range tool (0.25 / 0.30 / 0.20), opening and closing the distance x0.3 (`Duels.OPEN / CLOSE` 53-54) | CODE |
| Pivots | `footwork` | the jab tool x0.30, the long answers 0.35 / 0.35 / 0.30, steering x0.35-0.4; the grade of step_back, step_out, pivot_out, cut_off (`StepEffect.ABILITY` 21, `grade_for` 298) | CODE |
| Legs drain | the tank | `BoutNight._energy` 319-340 (`Combos.round_spend` 241 x `spend_factor` 262 on Stamina); tired legs take 12 points off guard, head movement, footwork, foot speed under 65 energy (`Duels.effective` 127, `TIRED_AT` 71) | CODE; a per-stance cost is NEW |
| Hooks | `hooks` | pocket combos x0.27, power x0.25; inside short x0.18, body x0.35; the step-in counter x0.3 | CODE |
| Inside work | `inside` | every inside tool, attack 0.5 / 0.4 / 0.3 AND answer 0.65 / 0.65 / 0.55; the tie-up | CODE (the heaviest single number in the duel: 3.05 of weight) |
| Body target bigger / hidden | `body` | only the price of a body shot taken (`Exchanges.body_cost` 44, read at `LiveRound.open` 115). How MANY body shots land is a fixed share (`Exchanges.BODY_SHARE` 0.2, `LiveRound` 316-318) | CODE; "fewer land" is NEW |
| Jab reach | `reach` (cm) | the long jab tool only, 0.25 a cm (`Duels.REACH_PER_CM` 39, `RingDuel.step` 112 -> `Duels.facts`) | CODE |
| Lead hook - (bladed) | `hooks` and the two hook moves' mastery | as Hooks; mastery also feeds the plan's fire share | CODE |

### 1.3 The other pieces of the design
| Piece | What exists | What is new |
|---|---|---|
| The footwork steps | Ten planned steps, each graded by two abilities against the opponent's (`StepEffect.ABILITY` 21, `GRADE_MULT` 17), fired from the plan (`LiveRound` 242-245, `StepWire.ride` 43), the place they lead to pays 5 / 6.5 points (`PlaceEdge.edge` 25). | Nothing to add: a wide stance lowers footwork and foot speed, so pivot_out / step_out / cut_off grade one word lower against a mover. The stance reaches the steps through the grade the game already shows. No new line in StepWire. |
| Tired legs pull the feet in | Tired legs already cost 12 points of feet and guard (`Duels.effective`). | The drift itself: under 65 energy at the bell a stance narrows, a whole step by 35; each body shot taken adds a little. Read at the bell (`BoutNight._open` 174). |
| Natural stance | Height and reach exist for every boxer (`BodyFacts.fill` 11-23), style and stats too. | The rule naming his natural cell (ESTIMATE, section 2). |
| Owning a cell (pad weeks) | The pad week drills cards night by night and steps have a mastery bar that makes them usable at 30 (`PadWeek.run_week` 369, `StepMastery.shadow_gain` 63, `nights_to_usable` 68). | One more drillable card kind, "Stance: Wide / Bladed", with the same bar; owned at Usable. |
| The corner's lean | The corner has ONE CHANGE a round that already is posture: Elbows in / Gloves high (`Adaptation.offers` 31, `start` 63, parsed at `BoutNight.corner_jobs` 154, shown by `CallButtons.gd` 73). | Two more offers in the SAME slot: Sit down (Front) / On the back foot (Back). No new corner row. |
| Read on tape | A pro's fired combinations are kept on a tape and the rival's corner waits for the most used one: -6 points on that line (`ProReadWire.target` 20, `edge` 39, `READ_EDGE` 15, tape kept 4 bouts). What the player knows of a boxer narrows with bouts (`Knowledge.range_of` 174). | The stance on the same tape: the same cell in 3 of the last 4 pro bouts = read. |
| Guard v7 | Not built (no HandsLine.gd). Its probe 8 says a guard line costs nothing because a plan has dead lines (`docs/GUARDPROBE8_RESULT.md`). | Section 4. |

## 2. The design probed
- **The pad**: width Narrow / Shoulder / Wide x angle Squared / Half / Bladed, set on the camp screen, held for the bout.
- **Natural**: each boxer has one cell that costs nothing. Rule used (ESTIMATE; the game has no stance data to derive it from):
  width from (Power - Speed) / 4 (+2 or more Wide, -2 or less Narrow); angle from the style (Out-boxer bladed; Pressure fighter,
  Slugger, Volume puncher squared) plus one step bladed for a reach 3 cm over the height, one squared for 3 cm under.
- **A stance is measured from his natural cell**: in it the boxer is today's boxer; each step away adds the pad's difference.
  A player who never opens the pad plays today's game (plus the tired-legs drift).
- **Owning**: a cell that is not his natural costs slower steps (-2 footwork, -2 foot speed) and 2 energy a round until owned.
- **In the fight**: tired legs and body shots pull the feet in (section 1.3). Narrow never drifts: that is what it is for.
- **The lean** (Back / Centred / Front): a corner call from round 2. Front = power +3, walks forward (the game's own forward
  dial +10, which costs guard: `Duels.FWD_GUARD` 57), head movement -3. Back = the reverse, timing +3, head movement +2.
- **Tape**: a rival who has read the stance comes in 1.5 points better prepared (ESTIMATE).

## 3. Sizes and where they come from
| Size | Round 1 | Round 2 | Tag |
|---|---|---|---|
| Wide, per step: power / head movement / chin | +3 / +2 / +3 | +5 / +5 / +5 | ESTIMATE. Direction: a wider base of support is more stable (SOURCED, general biomechanics: Human Kinetics "factors affecting stability"); the legs give 38 % of an experienced boxer's punch (SECONDARY, Filimonov 1985 as cited, original not read). No study sizes punch force by stance width: a 2022 Sports paper (doi 10.3390/sports10090136) groups boxers narrow / mid / wide; only its table was seen, NOT read. |
| Wide, per step: footwork and foot speed | -3 each | -3 each | ESTIMATE. Direction: coaching and change-of-direction work (a narrow base turns); the web search found no study of first-step time by stance width. |
| Wide, per step: energy a round | -1.5 | -1.5 | ESTIMATE |
| Tired legs: the feet come in | from 65 energy, a step by 35 | same | CODE for the line (`Duels.TIRED_AT`); the drift is ESTIMATE |
| Bladed, per step: reach | +5 cm | +5 cm | DERIVED: half a 39 cm shoulder line x the sine of the shoulder's angle to the opponent (25 / 45 / 70 degrees) = 8 / 14 / 18 cm |
| Bladed, per step: jab level | 0 | +4 | ESTIMATE (round 2: reach alone is 0.2 of a point in the duel) |
| Bladed, per step: hooks / inside work | -3 / -3 | -2 / -1 | ESTIMATE |
| Bladed, per step: body toughness | +4 | +8 | ESTIMATE |
| Rear power | bladed only, -2 | -2 a step, both ways | ESTIMATE |
| Not owned / lean / read | as section 2 | same | ESTIMATE |
- Round 1's rule: one step = three attribute points on each tool (three focused camp weeks at the decided pace of 1.0 a week).
- Round 2's rule (the ONE resize, set before its run, never on the test's seeds): each side of a trade is worth about one
  exchange point in the place it acts, summed from `Duels.TOOLS`' own weights for an average boxer (DERIVED: a point of an
  attribute is worth weight x K 0.5 / 3 of an exchange point; round 1 measured one such point as about 3 bouts in 100).
  Wide: +1.1 in the pocket, +0.2 inside, against -1.0 at range and the legs. Bladed: +1.0 at range, against -0.8 inside and
  -0.3 in the pocket. Chips that could not reach a point alone are folded into the chip they act with: "stays up" into
  the base (power + chin, both in the knockdown rule), "body hidden" and the jab into "long", rear power into the hooks.
- The honest read of the sources: every DIRECTION has a coaching or textbook reason; NO size has a study. John should be
  asked for stance-width numbers before a build (SQ, not run here).

## 4. The MERGE question: should stance and guard v7 be ONE mechanic ("how he stands")?
**Answer: ONE page and one name for the player, THREE rules underneath, each on its own clock. Not one rule.**
1. They cannot be one rule, because probe 6 measured that a guard HELD for the bout is never right (Normal best in 12 of 12
   cells) and v7 exists because the guard is a reaction to a moment. The feet are the opposite: nobody changes his feet
   every 30 seconds. One rule would have to be either held (the guard fails) or momentary (the feet are false).
2. They should be one PAGE, because the player's question is one question: "how does he stand?". Feet = the camp (weeks,
   owned on the pads). Hands = the plan's WHEN-lines (v7). Weight = the corner's ONE CHANGE (a round).
3. INTERCONNECT (owner S534 free hand), three links, each small and from code that exists:
   - **The stance prices the guard lines.** Probe 8's failure is that a guard line is free. Give each guard line its grade
     pair from the stance as well: Hands High is done one grade better Squared (the shell needs both forearms in front)
     and one worse Bladed; Hands Loose the reverse (`LineGrade.DONE_WITH` 13-34 is where the pair lives). Then WHICH guard
     line a boxer should carry depends on his feet, and changing his feet for one opponent costs him his guard lines'
     grade. NOT MEASURED: it needs v7 in the probe; it is the next probe if this one is approved.
   - **The lean shares the corner's posture slot.** Elbows in, Gloves high, Sit down, Back foot: one slot, one choice a
     round (`Adaptation.offers`). The lean adds no corner row (the S528 lesson).
   - **REMOVE**: no separate "Hands" setting (v7 already cut it) and no separate "Posture" control.
4. What stays apart: the guard's wear and leak (`GuardState.after`) are about punches blocked, not about feet. A wide
   stance does not change them in this design.

## 5. Every menu the mechanic appears on
| Menu | Shows | Wired to | Status |
|---|---|---|---|
| Training tab / camp, "How he stands" | the 3 x 3 pad; his natural cell marked; each cell's chips as + / - with the attribute they move; "owned" or "N pad nights to own" | new `Stance.gd` (table, natural, apply); `PadWeek` for the nights | TO BUILD |
| Pad week board | a "Stance" card beside the move and step cards | `PadWeek.drill` 348, `run_week` 369; `StepMastery.nights_to_usable` 68 | TO BUILD |
| Fighter page, the header line ("Welterweight, 23, southpaw") | adds "wide, squared" | `scripts/ui/areas/FighterPage.gd` 63 | TO BUILD |
| Fight prep / tale of the tape | his stance against the opponent's, and which chip it costs or pays against this style | `scripts/ui/areas/BoutPage.gd` 71-73, `FightPrep.gd` | TO BUILD |
| Game plan chart | step and guard answers show the grade word after the stance (a wide boxer's Pivot out reads one word lower) | `StepEffect.grade_for` 298, `LineGrade.grade` 54 | CODE TODAY for the grade; the stance layer TO BUILD |
| Corner minute, ONE CHANGE | Sit down / On the back foot beside Elbows in / Gloves high, with what each moves | `Adaptation.offers` 31, `CallButtons.gd` 73, `BoutNight.corner_jobs` 154 | TO BUILD |
| 3D fight / fight night | the feet at the stance's width and angle; "feet coming in" on the corner's eye when the drift starts | section 6 | TO BUILD |
| Fight analysis / the Why | one line: "Wide stance: 2 knockdowns scored, lost 7 of 9 exchanges at range" | `FightWhy.read` 26-60 from the exchanges' place and tool (`rec["place"]`, `rec["a_best"]`, LiveRound 363-366) | TO BUILD |
| Opponent file / film night | "has seen this stance 3 times" on a pro's file; the rival's own stance as a tell | `ProReadWire.target` 20, `OppFile.tells` 71 | TO BUILD |

## 6. WATCHABLE: would the player see it in the 3D fight? (owner: "they really happening and player can watch it ?")
| Chip | What the v2 fight player would show | Exists in scripts/fight3d/v2 | New |
|---|---|---|---|
| Width | the feet further apart or closer in the guard, the steps and the wait | The stance is ONE fixed size today: `BoxerFootwork.STANCE_LEN` 0.50 m, `STANCE_WID` 0.32 m (BoxerFootwork.gd 48-49); the walking takes were refitted ONCE onto that stance at the bake (`StepClips.REFIT` 30, tools/step_bake.gd "THE REFIT"). `FootTake` pins a standing foot by its ball. | The refit run per width (three bakes of the same takes, or the refit moved to load time), and the guard pose's feet set from the cell. The biggest piece of work on this list. |
| Angle | hips and shoulders turned more side-on or square in the guard | The rear foot's turn-out is one number (`REAR_YAW_DEG` -45, BoxerFootwork.gd 63); `PairPlace.face` turns each man to the other. | A yaw offset on the guard per cell; the punch takes are captured from one angle, so a bladed hook is the same take (visible limit). |
| Step speed, pivots | a wide man's step lands late; his pivot turns less | Steps are captured takes played 0.75x to 1.5x of their speed (`StepPlay.RATE` 24, `TAKES` 22); circles are 20-30 degrees (`CIRCLE_M` 41). | The rate and the circle size read from the stance. Small. |
| Slips | more slips shown for the man who slips better | `ChoreoReact.defence` 140 picks the defence take; which punches miss comes from the settled exchange. | Nothing: more misses already play as more defence takes. |
| Rear power, stays up | bigger reactions, more knockdowns scored / fewer taken | `ChoreoReact.react` 9 sizes the reaction by the punch; knockdowns play from the sim. | Nothing. |
| Legs drain, the drift | the feet visibly closer in the late rounds | Nothing reads energy into the stance. | The guard's width eased toward narrow at the bell. Small once width exists. |
| The lean | weight on the front or back foot in the guard and the wait | The hips are the take's own; `PairPlace.place` adds travel only. | A hip offset along the fight line (a few cm) per lean. Small, but a new pose layer. |
| Reach | the jab lands from further | Distances hang on the take's own reach (`ChoreoGap`, `ChoreoRules` range in head distance). | A per-boxer offset on the punch's planned distance. Medium. |
Verdict: four chips are watchable with no new 3D work (their results already play). Width and angle - the thing the pad is
named for - are NOT watchable today: the body has one stance, baked in. That is FIGHTPLAYER2 work (the METHOD line: no new
layer in scripts/fight3d until v2 is built); none of it is in this task.

## 7. The probe
Full page: `docs/STANCEPROBE1_RESULT.md`. Population: five Data prospects (three women, two men, no two alike), five opponent
styles x amateur 3 rounds / pro 6 rounds = 10 cells, 40 seeds a cell, 200 bouts a stance and cell, every stance of a seed on the same dice.
Each bout is `BoutNight`'s own fight night, walked round by round so the stance can be re-set at the bell.
`RESULT: tools/stanceprobe1.gd -> FAIL` in both rounds, on one bar both times:
| Bar | Round 1 (3 attribute points a step) | Round 2 (the one resize: one exchange point a side) |
|---|---|---|
| Every effect moves the result | FAIL: 6 of 10 chips under 2 bouts in 100 | PASS: 2.2 to 6.1 in 100 |
| No stance best in more than 6 of 10 cells | 6 (but Squared in 10 of 10) | PASS: 4, five stances share the cells |
| 4 or more cells clear of the noise | FAIL: 1 | FAIL: 1 |
| Natural not always best | PASS: 2 of 5 boxers | PASS: 2 of 5 boxers |
| The lean moves a round | PASS | PASS (Back +1.9, Front -1.2 rounds in 100) |
- What holds: the plug of section 1 works (same bout as the game with the model off, no rebuilt attribute copy); the trades are
  real in both directions once sized from the duel's own weights; the stance fits the boxer.
- What fails: the best stance of a cell is only 0 to 4.5 wins in 100 above the second (3 to 9.7 above the worst) and a cell's noise is +- 3.5. As a fine tuner the pad is not a choice a
  player could feel against one opponent. The lean is one-sided (Back best against all five styles). The tape read (-7.0 wins in
  100) is larger than any stance and rests on an ESTIMATE.
- By the brief a second FAIL comes back to Claude: NO critic brief was written (`TASK_STANCE1CRIT.md` does not exist), nothing
  goes to the board as a design. The three ways on are at the foot of the result page.

## 8. Files opened (this session)
Whole: `scripts/state/LiveRound.gd`, `BoutNight.gd`, `RingDuel.gd`, `GuardState.gd`, `scripts/rules/Exchanges.gd`, `Duels.gd`, `Knockdowns.gd`, `Adaptation.gd`, `PlaceEdge.gd`, `PunchStart.gd`, `BodyFacts.gd`, `tools/weight2_probe.gd`,
`ops/research/DESIGN_GUARDDMG1_V7.md`, `topics/footwork.md`. In part: `Attrs.gd` (56-125, 226-420), `Combos.gd` (236-300), `Data.gd` (71-105,
136-300), `AttrGen.gd` (188-220), `BoutRules.gd` (203-243, 330-378, 466-475), `StepClips.gd` (1-42), `docs/GUARDPROBE8_RESULT.md` (1-30).
By outline only (function and constant lines, file heads): `StepEffect.gd`, `StepWire.gd`, `StepMastery.gd`, `PadWeek.gd`, `Knowledge.gd`, `ModeTells.gd`, `OppFile.gd`, `FilmNight.gd`, `ProReadWire.gd`, `ProRead.gd`, `FireLevel.gd`, `LineGrade.gd`,
`StepPlay.gd`, `FootCarry.gd`, `FootTake.gd`, `ChoreoReact.gd`, `PairPlace.gd`, `GuardHold.gd`, `ChoreoGap.gd`, `BoxerFootwork.gd` (grep). Not opened:
`GuardWear.gd`, `FightWhy.gd`, `CallButtons.gd` (one grep line each), nothing else. The mockup picture was opened: its % numbers are placeholders, its "his moves in this stance" chips (pivot out slower, body hook + power) are what the plan lines' grades would show from the layered attributes (`LineGrade.grade` 54), and its two "rare" corner cells were not modelled.
