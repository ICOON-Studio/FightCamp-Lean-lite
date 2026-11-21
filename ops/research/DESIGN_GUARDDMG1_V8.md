# GUARDDMG1 V8 - the guard line is paid for by the feet; the natural stance is a trait (S536, Fable console, from the code)

Brief: `ops/research/TASK_GUARDREV8.md` (owner S536, on merging the stance into the guard: "Yes, merge it"). Follows two verdicts:
`docs/GUARDPROBE8_RESULT.md` (v7 FAIL: a guard line costs no move line, "the slot is free") and `docs/STANCEPROBE1_RESULT.md` (the 9-cell
stance pad FAIL twice: 1 of 10 cells clear; its own way out: "the feet grade the guard lines"). Probe: `tools/guardprobe9.gd`, result
`docs/GUARDPROBE9_RESULT.md`. Nothing under scripts/ was edited.
Tags: **CODE** = I opened the file on 2026-11-22 (main at bbc410f96 plus the working tree) and the line is true. **V7** / **ST1** = taken from
`DESIGN_GUARDDMG1_V7.md` / `DESIGN_STANCE1.md`'s own CODE tables, not re-opened. **PROBE9** = measured by tools/guardprobe9.gd.
**ESTIMATE** = a size or rule of mine. **TO BUILD** = not in the game.

## 0. The short version
- v7 stays: the guard is a WHEN-line of the fight plan ("IF the opponent loads up -> Hands High"). v8 changes what it COSTS: not a plan
  slot (probe 8: free), but the FEET. Hands High wants planted feet (a Wide stance); Hands Loose wants light feet (a Narrow stance).
- Every boxer has a NATURAL stance width, a trait from his frame: Narrow, Shoulder or Wide. Pad weeks move it ONE step. Nothing else of
  the stance pad is kept: the angle and the weight lean are dropped (section 4).
- In the 30 seconds a guard line fires: in its feet it is v7's line; a step off it keeps part of its plus and costs step speed (High) or
  legs (Loose); two steps off it is worth little or nothing and costs twice.
- So choosing a guard line is choosing how he stands, and the natural stance says which lines are cheap for THIS boxer.
- PROBE9: **FAIL twice** (section 6). What holds: a guard line now costs something measurable (5.1 wins in 100 against the same line free,
  7.3 after the resize, in 10 of 10 cells: probe 8's bar), every effect moves the result, and the trait decides clearly for each boxer.
  What fails: pooled over boxers one pair ("High lines, one step wider") is best in 6 then 7 of 10 cells, and only 1 of 10 cells has a
  best that is clear of every other pair. It comes back to Claude; no critic brief was written. The ways on are in section 7.

## 1. What the code does today (CODE)

### 1.1 The plan line and the exchange it lands in
- The eight moments a WHEN-line can sit on and their words: `FightFlow.WHEN_WORDS` (FightFlow.gd 33). The moment of an exchange:
  `Exchanges.situation` (Exchanges.gd 194-199): your boxer hurt, then tired under 35 energy (`SHE_TIRED` 52), else the opponent's game.
  How often each game comes, by the opponent's style: `Exchanges.STYLE_MODES` (156-167: a Slugger loads up 0.45, an Out-boxer boxes at
  range 0.6).
- Each exchange picks the plan's line for the place and the moment (`LiveRound.gd` 239-240, `PlanFight.choose` PlanFight.gd 101), may not
  fire it (`LiveRound.gd` 242), and adds its worth to the exchange's sum before the dice: `plan_edge` at 248, into `d` at 265, settled at
  287 (`Exchanges.settle` 356). The plan's true effect is kept (290, the same dice without it).
- A line is graded by how this boxer does it: two attributes a move (`LineGrade.DONE_WITH` LineGrade.gd 13), a plus x 1.15 / 0.99 / 0.90
  (`LineGrade.PLUS` 40), a minus x 1.5 / 1.0 / 0.6 (`Exchanges.COMMIT` Exchanges.gd 32), the words at 62 and 50 (`GOOD_AT` 24, `OK_AT` 25).
- The line limit: 4 for a new coach (`PlanBoard.NEW_COACH` PlanBoard.gd 10, `arrow_limit` 15), refused on the plan screen
  (`GamePlan.gd` 369 "The plan is full", `PlanBoard.validate` 27). PROBE8 measured that this slot costs nothing.
- No guard line exists in the game: no `HandsLine.gd`, no `Stance.gd` under scripts/rules (listed today). "Stance" in the game is the word
  orthodox / southpaw on the fighter page header (`FighterPage.gd` 63) and the tale of the tape (`BoutPage.gd` 71, 73).

### 1.2 Where the feet's price can plug in without a new fight rule
- **The exchange's sum.** The round's standing edge is `lv["base"]` (`LiveRound.open` 58, written at 113), read into `d` at 212. A guard
  line's points, its fit and High's step price are one number added there. PROBE9 did exactly that around `LiveRound.exchange` (156).
- **The legs.** Your boxer's energy in a round is the bell-to-bell line less `lv["cost"]` (`RingDuel.her_energy` RingDuel.gd 332-335); the
  round's `cost` is taken off the tank at the bell (`LiveRound.close` 405, 410, 423). Loose out of its feet adds to that same `cost`:
  no new energy rule. The tank is 100 (`Combos.TANK` Combos.gd 24, `BoutNight._energy` BoutNight.gd 319-341). Tired legs already cost the
  feet 12 points under 65 energy (`Duels.TIRED_AT` Duels.gd 71, `effective` 127), and under 35 the moment becomes "your boxer is tired".
- **A shifted stance.** The boxer's fight numbers are one dict (`Attrs.of` Attrs.gd 59), rebuilt only when a source changed (`_clean`
  88-109). A stance is a LAYER on it where the bout copies the boxer in (`LiveRound.open` 104, `BoutNight.count_sides` 236, `_energy`
  328), never written into the stored attributes (ST1 1.1). PROBE9 layered it at every bell: 0 copies rebuilt in 70,160 bouts.
- **The frame.** Height and reach exist for every boxer (`BodyFacts.fill` BodyFacts.gd 11); Power and Speed are stats (`Data.PROSPECTS`
  Data.gd 221, `fighter_state` 254). The game has no stance width: the natural-stance rule is new (2.1).

## 2. The rule (TO BUILD; every size ESTIMATE unless tagged)

### 2.1 The natural stance, a trait
- Width only: **Narrow / Shoulder / Wide**. From the frame: (Power - Speed) / 4 at +2 or more = Wide, -2 or less = Narrow, else Shoulder
  (ST1's rule, ESTIMATE). Of the five Data prospects: Kira Narrow, Samira Wide, Tess, Danny and Josh Shoulder (PROBE9 section 1).
- **Pad weeks move it one step**, and it stays on the pad (a Narrow boxer can become Shoulder, never Wide in one go). A drillable card
  "Stance: a step wider / narrower" with a mastery bar, owned at Usable like a step (`PadWeek.drillable` PadWeek.gd 249, `drill` 348,
  `run_week` 369; `StepMastery.shadow_gain` StepMastery.gd 63, `nights_to_usable` 68). The price of a shift is those pad nights.
- A shifted stance also changes the boxer a little (ST1 round 2, the width column, measured there): a step wider = power, head movement
  and chin +5, footwork and foot speed -3, 1.5 energy a round; a step narrower the reverse. PROBE9: off / on changes 6.8 bouts in 100.
- A new pure module `scripts/rules/Stance.gd`: `natural(f)`, `width(f)` (natural + the owned shift), `steps(width, hands)`, `layer(attrs, dw)`.

### 2.2 The guard line and its feet
- A guard line is v7's: `{"hands": "high" | "loose", "when": <moment>}`, one a moment at most, v7's table of points (V7 2.2), graded
  as a plan line (High with Defence and Composure, Loose with Speed and Stamina, V7 2.2), v7's after-the-settle rules (V7 2.3).
- **Its stance**: Hands High = Wide (planted). Hands Loose = Narrow (light). steps = how far the boxer's stance is from it (0, 1 or 2).
| Steps from the line's stance | The plus kept (run 1 / run 2) | Hands High pays | Hands Loose pays |
|---|---|---|---|
| 0 (in his feet) | all of it / all of it | nothing | nothing |
| 1 | x0.6 / x0.5 | STEP SPEED: 2.5 / 4.0 points off that exchange | LEGS: 2.0 / 4.0 energy after that exchange |
| 2 | x0.25 / x0 | 5.0 / 8.0 points | 4.0 / 8.0 energy |
- Why these two prices: a shell on feet that are not planted has to stop and set (he is late to every step for those 30 seconds); loose
  hands on a wide base means bouncing a stance that does not bounce (the legs pay). Directions from coaching, no study sizes either (ST1 3).
- Where it plugs in: `HandsLine.points(...)` x `Stance.fit(steps)` - High's step price into `plan_edge` beside `LiveRound.gd` 248 (so
  the Why's swing at 290 counts it as the plan's); Loose's legs into `lv["cost"]` after the exchange (1.2).
- **The line limit**: a guard line no longer takes a move line's slot (PROBE8: the slot was free and the trade did not exist). Guard
  lines have their own small limit, three, one a moment. The feet are the price.

### 2.3 What the player does with it
- Before the bout: read which moments this opponent brings (V7 2.5, the opponent's file), look at his own boxer's stance, and write the
  guard lines his feet can pay for - or spend pad weeks to move the stance a step for the lines this run of opponents asks for.
- A Narrow boxer told to cover up loses more than he gains; a Wide boxer told to let his hands go the same (PROBE9, section 6 below).
- The corner minute's ONE change may add, swap or drop a guard line (V7 2.5); the stance cannot change in the corner.

## 3. Sizes and where they come from
| Size | Run 1 | Run 2 | Tag |
|---|---|---|---|
| v7's table of points, the grade pairs, the after-the-settle rules | as V7 2.2-2.3, step s1 | same | V7 (PROBE7 PASS) |
| The plus kept at 0 / 1 / 2 steps | 1.0 / 0.6 / 0.25 | 1.0 / 0.5 / 0.0 | ESTIMATE |
| High out of its feet, a step | 2.5 points | 4.0 | ESTIMATE (a wrong plan line is -7, `PlanFight.EDGE` PlanFight.gd 19: a step off stays under it) |
| Loose out of its feet, a step | 2.0 energy | 4.0 | ESTIMATE (ST1's wide stance costs 1.5 a round) |
| A shifted stance, a step | power / head movement / chin 5, feet 3, 1.5 energy a round | same | ST1 round 2 (its effects all moved) |
| Natural width | (Power - Speed) / 4, +-2 | same | ESTIMATE (ST1) |
No size here has a study behind it (ST1 3: stance width has none). John should be asked before a build.

## 4. What v8 takes from v7 and STANCE1, changes or cuts
| From | v8 |
|---|---|
| v7: the guard as a WHEN-line, its table, grades, after-the-settle rules, the two shouts | KEPT |
| v7: "a guard line takes one of the coach's plan lines" | **CUT** (PROBE8: free). Replaced by the feet's price and a limit of three guard lines. |
| STANCE1: the 3 x 3 pad set per fight | **CUT** (probe: too close to feel). The stance is a trait, moved one step by pad weeks. |
| STANCE1: the angle (Squared / Half / Bladed) | **CUT.** Round 1: Squared won 10 of 10 cells; round 2 folded three of its chips. Not a choice. |
| STANCE1: the weight lean (Front / Back) as a corner change | **DROPPED.** Probe 1: Back was best against all five styles; I found no new trade for it, so it is not in v8 and not in probe 9. |
| STANCE1: tired legs pull the feet in (the drift) | NOT IN V8 (kept small). It would make High lose its feet late in a bout; a later probe. |
| STANCE1: "not owned yet" (slower steps, energy until owned) | NOT IN V8's probe: a shifted stance is owned once the pad weeks are done. Section 7 way 3 brings it back. |
| STANCE1: the stance read on the rival's tape | FLAVOUR ONLY here: both stances show on the tale of the tape (section 5); no read penalty (its size was an ESTIMATE bigger than any stance). |

## 5. Every menu the mechanic appears on
| Menu | Shows | Wired to | Status |
|---|---|---|---|
| Fighter page, the header line ("Welterweight, 23, southpaw") | adds the natural stance: "wide stance"; on its hover: "Hands High is in his feet; Hands Loose costs him legs" | `FighterPage.gd` 63; `Stance.natural` | TO BUILD |
| Fighter page / attribute board, the traits | "Wide stance" as a trait row beside the five personality traits, with its up and its down | `TraitLine.LINES` (TraitLine.gd, read by `AttrBoard.gd`) | TO BUILD (a new row kind: those five are personality) |
| Camp / pad week board | a card "Stance: a step wider" / "a step narrower", its nights to own, and what it makes cheap and dear | `PadWeek.drillable` 249, `drill` 348, `run_week` 369; `StepMastery.nights_to_usable` 68 | TO BUILD |
| Game plan chart, an IF's answers | Hands High / Hands Loose rows with v7's fit word and grade, plus the FOOT COST: "in his feet", "a step off: keeps half, slow feet" , "two steps off: do not" | `scripts/ui/PlanChart.gd` is at 499 lines: the rows go in a new `PlanChartHands.gd`; `Stance.steps`, `HandsLine.points` | TO BUILD |
| Game plan chart, the checks | "three guard lines at most"; a warning on a guard line two steps from his feet | `PlanBoard.validate` 27 | TO BUILD |
| Fight prep / tale of the tape | his stance against the opponent's, beside "Age, stance" | `BoutPage.gd` 71, 73 | TO BUILD |
| Corner minute, ONE CHANGE | add / swap / drop a guard line, each with its foot cost for this boxer | `PlanFight.corner_options` PlanFight.gd 194, `corner_change` 184 | TO BUILD |
| Fight night, the corner's eye | "Hands High: worked" / "Hands High: slow feet, lost it" | `PlanRecord.line_state` PlanRecord.gd 124, `line_why` 136 | TO BUILD for guard |
| Fight analysis / the Why | one line a guard line: "Hands Loose when she tired: won 2 of 3, cost 8 energy in the legs. A step narrower and it is free." | `FightWhy.read` FightWhy.gd 26; `PlanRecord.WHY_ANSWER` 21; `scripts/ui/FightAnalysis*.gd` | TO BUILD |
| Playbook, the lines' record | works / fails for each guard line over bouts | `PlanRecord.rates` 79, `verdict` 108 | TO BUILD for guard |
| The 3D feet | the guard's feet at the boxer's width; planted or light in the 30 seconds a guard line fires | the body has ONE stance today: `BoxerFootwork.STANCE_LEN` 0.50 m, `STANCE_WID` 0.32 m (scripts/fight3d/BoxerFootwork.gd 48-49), the takes refitted to it once at the bake (ST1 6) | TO BUILD, and only inside FIGHTPLAYER2 (the METHOD line: no new layer in scripts/fight3d). Until then the feet's price is read on the corner's eye and the Why, not seen. |

## 6. The probe (GUARDPROBE9, `tools/guardprobe9.gd` -> `docs/GUARDPROBE9_RESULT.md`)
- Population: STANCEPROBE1's (five Data prospects, three women and two men, never two alike; Data's region opponents by style and sex,
  re-rated so today's game wins about half; 5 opponent styles x amateur 3 / pro 6 rounds = 10 cells; 40 seeds; 200 bouts a pair and
  cell, every arm of a seed on the same dice). The walk: GUARDPROBE8's, exchange by exchange around the game's own fight night.
- Pairs (what a player can choose, 10): no guard line / the High lines (loads up, your boxer hurt, your boxer tired) / the Loose lines
  (tiring, hurt, at range) / High + Loose (probe 7's right three), each on the natural stance and on the shifted stances not plainly
  wrong for it. Beside them: the same line sets FREE (v7's rule), and each effect switched off.
- Not measured: the pad weeks a shift costs, a guard line read at the wrong moment (read share 1.00, as probe 8), the corner's guard
  change, the shouts, the 3D feet.
| Bar | Run 1 | Run 2 (the one resize: wrong feet lose more) |
|---|---|---|
| Every effect moves the result | PASS: 3.8 to 6.8 bouts in 100 | PASS: 3.8 to 7.0 |
| A guard line costs something measurable | PASS: -5.1 +- 0.3 wins in 100 against free, 10 of 10 cells | PASS: -7.3 +- 0.4, 10 of 10 |
| No pair best in more than 6 of 10 cells | PASS at 6 | FAIL: 7 (High lines, one step wider) |
| 4 or more cells clear of the noise | FAIL: 1 | FAIL: 1 |
| The natural stance is not always the answer | PASS: 3 of 5 boxers | PASS: 3 of 5 |
- The trait by boxer (PROBE9, run 1, wins in 100 against no guard line, five styles pooled): Kira (Narrow) Loose lines +7.0 / +5.8
  (amateur / pro), High lines -3.5 / -11.5. Samira (Wide) High lines +10.0 / +5.0, Loose lines -9.5 / -5.5. The three Shoulder boxers on
  the natural stance: High +2.2 / -3.3, Loose -0.7 / -2.3; a step wider with High +6.7 / +6.9; a step narrower with Loose +6.0 / +2.2.
- Why bar 3 and 4 fail: two of the three High lines sit on the boxer's own trouble (tired, hurt), which comes against every opponent:
  the High lines fire 16 to 21 times a pro bout, the Loose lines 2 to 8. So High-and-wider is the answer against four of five styles, and
  the pairs next to it (the same lines in the mixed set) are 0 to 4 wins in 100 behind with a paired error of 1.2 to 2.8.

## 7. Verdict and the ways on
`RESULT: tools/guardprobe9.gd -> FAIL` twice. By the brief it comes back to Claude: `ops/research/TASK_GUARD8CRIT.md` was NOT written and no
critic was briefed. v8 fixes what probe 8 found (the line now has a price) and gives each boxer a clear, different answer; it does not
yet give a different answer per opponent.
1. Guard lines only on the OPPONENT's moments; "cover when your boxer is tired / hurt" goes back to the corner's shout (V7 2.1).
2. Read the next probe by boxer as well as by opponent (cells = natural stance x style; it needs more Narrow and Wide boxers).
3. A shifted stance pays on the night until it is bedded in (ST1's "not owned yet"), so the natural stance is sometimes the answer.
4. The cheap build: v7's line with the natural stance as its grade word only (in his feet Good, a step off OK, two steps Poor).
Recommendation: 1 and 3 in one probe 10, read as 2. Nothing of v8 is built before that.

## 8. Files opened (this session)
Whole: `tools/guardprobe8.gd`, `tools/stanceprobe1.gd`, `ops/research/DESIGN_STANCE1.md`, `ops/research/TASK_GUARDREV8.md`. In part:
`scripts/state/LiveRound.gd` (1-300, 405-425), `BoutNight.gd` (68-123, 136-252, 319-346), `RingDuel.gd` (332-350), `scripts/rules/Exchanges.gd`
(156-206), `Attrs.gd` (88-110), `TraitLine.gd` (1-30), `tools/guard_probe.gd` (head, PLANS), `DESIGN_GUARDDMG1_V7.md` (0-2.5, 4-6),
`docs/GUARDPROBE8_RESULT.md` (head, foot), `docs/STANCEPROBE1_RESULT.md` (head, round 1 tables). By grep only (the line cited and nothing else):
`PlanBoard.gd`, `LineGrade.gd`, `PlanFight.gd`, `PlanRecord.gd`, `FightWhy.gd`, `FightFlow.gd`, `Duels.gd`, `Combos.gd`, `BodyFacts.gd`, `Data.gd`,
`PadWeek.gd`, `StepMastery.gd`, `GamePlan.gd`, `FighterPage.gd`, `BoutPage.gd`, `scripts/fight3d/BoxerFootwork.gd`; `scripts/ui/PlanChart.gd` by its
line count. Not opened: `docs/GUARDPROBE7_RESULT.md`, `docs/mockups/s536/stance.png`, `research/topics/footwork.md`, memory S531 (their
conclusions were taken from the V7 and ST1 maps, which cite them).
