# GUARDDMG1 V9 - the guard is set for the man in the other corner (S537, Fable console, from the code)

Brief: `ops/research/TASK_GUARDREV9.md` (owner S537, Q-299: "try v9"). Follows `docs/GUARDPROBE9_RESULT.md` (v8 FAIL twice: the feet's
price is real and the natural stance decides per boxer, but "High lines, one step wider" was best in 6-7 of 10 opponent cells, 1 cell
clear, because two of three High lines sat on the boxer's OWN trouble). v9 = probe 9's ways 1 + 3, read by boxer as well (2).
Probe: `tools/guardprobe10.gd`, result `docs/GUARDPROBE10_RESULT.md`. Nothing under scripts/ was edited.
Tags: **CODE** = I opened the file on 2026-11-22 (main at ef1522e90 plus the working tree) and the line is true. **V8** / **V7** / **ST1**
= taken from `DESIGN_GUARDDMG1_V8.md` / `_V7.md` / `DESIGN_STANCE1.md`'s own CODE tables, not re-opened. **PROBE10** = measured by
tools/guardprobe10.gd. **ESTIMATE** = a size or rule of mine. **TO BUILD** = not in the game.

## 0. The short version
- The coach sets ONE guard for the fight, for the man in the other corner, and says WHEN: **High guard WHEN he loads up** (against the
  loader / head-hunter), **Elbows in WHEN he presses** (against the presser who works the body), **Light guard WHEN he boxes at range**
  (against the out-boxer). One guard a plan, one WHEN-line.
- No guard line sits on your boxer's own trouble any more. "Cover up, she is hurt / tired" is the corner's SHOUT, which the game has.
- Each guard has its feet: High = Wide (planted), Elbows in = Shoulder, Light = Narrow. The boxer's NATURAL stance (a trait, v8) says
  which guard is cheap for him; out of its feet a guard keeps half or none of its plus and costs step speed or legs.
- New in v9: a stance moved a step on the pads is **not owned yet** on the night (slower feet, energy a round) until he has boxed N
  bouts in it. So moving his feet for one opponent is a real spend, and the natural stance is sometimes the answer.
- PROBE10: **FAIL twice, on one bar** (section 6). Five of six bars pass both runs: no pair is best in more than 3 of 10
  opponent cells (v8: 6-7), every boxer's best guard changes with the opponent beyond the noise (7 of 7), a guard line costs 4.0 to 4.6
  wins in 100 against free, the natural stance is best in some cells and beaten in others. What fails: only 1, then 2 of 10 pooled
  opponent cells have a best pair clear of every other (bar: 4), because against one opponent the right pair differs by the boxer's
  feet. It comes back to Claude; no critic brief was written.

## 1. What the code does today (CODE)
- **The moments.** An exchange's moment is `Exchanges.situation` (Exchanges.gd 194-199): your boxer hurt first, then tired under 35
  energy (`SHE_TIRED` 52), else the OPPONENT's game. The opponent's games are six: press, range, counter, loadup, tiring, hurt
  (`Exchanges.MODES` 124-131; words `FightFlow.WHEN_WORDS` FightFlow.gd 33). How often each comes is the opponent's style
  (`Exchanges.STYLE_MODES` 156-167): a Slugger loads up 0.45 of the time, a Pressure fighter presses 0.55, an Out-boxer boxes at range 0.6,
  a Counter-puncher waits to counter 0.55, a Volume puncher presses 0.45 and boxes at range 0.35.
- **"Throws to the body" is not a moment in the game.** The brief names it; the code has no such game. Body shots are a share of every
  landed punch (Exchanges.gd 33-36: a fifth, "a body-punching opponent a third") and "a presser walks onto body shots" (125-126). So v9
  puts the elbows-in guard on **the opponent presses**, the moment the body work comes in. A body moment of its own would be a new rule.
- **Your boxer's own trouble already has its answer in the corner's calls**: "Your fighter is tired" best = Calm, ok = Hands up;
  "Your fighter is hurt" best = Tie up, ok = Hands up (`Exchanges.MODES` 132-133; the call "Hands up, move your head" at 79).
- **The plan line and its exchange** (V8 1.1, re-checked where cited): the plan's line for the place and moment is picked at
  `LiveRound.gd` 241 (`PlanFight.choose`), its worth is `plan_edge` (249), graded by `LineGrade` (`DONE_WITH` LineGrade.gd 13, `PLUS` 40:
  x1.15 / 0.99 / 0.90) and `Exchanges.COMMIT` (32: x1.5 / 1.0 / 0.6), words at `GOOD_AT` 62 / `OK_AT` 50 (24, 25). A right line is +9, a
  wrong one -7 (`PlanFight.EDGE` PlanFight.gd 20). The line limit is 4 for a new coach (`PlanBoard.NEW_COACH` 10, `arrow_limit` 15,
  `validate` 27).
- **Where a guard line plugs in without a new fight rule** (V8 1.2): the round's standing edge `lv["base"]` (`LiveRound.open` 58, set at
  113, read into the exchange at 212); the round's energy `lv["cost"]` (113, taken off the tank at `LiveRound.close` 406-411; the tank is
  100, `Combos.TANK` Combos.gd 24; tired legs cost the feet under 65, `Duels.TIRED_AT` Duels.gd 71); the boxer's fight numbers are one dict
  (`Attrs.of` Attrs.gd 59), rebuilt only when a source changed (`_clean` 88) - a stance is a LAYER on the bout's copy, never stored.
- **Nothing of this exists in the game**: no guard line, no stance width, no "not owned" (V8 1.1). "Stance" today is orthodox / southpaw
  on the fighter page header (`scripts/ui/areas/FighterPage.gd` 63) and the tale of the tape (`scripts/ui/areas/BoutPage.gd` 71, 73).

## 2. The rule (TO BUILD; every size ESTIMATE unless tagged)

### 2.1 One guard a fight, on the opponent's moment
- A guard line is `{"hands": "high" | "tight" | "loose", "when": <one of the opponent's six moments>}`. A plan carries ONE guard line
  (v8: three lines of any guard; v7: any number, each taking a move line's slot). Its WHEN can only be an opponent's moment: the two
  "your boxer is hurt / tired" moments are not offered for a guard line.
- Covering up when your own boxer is in trouble stays where the game has it: the corner's shout (1, third point). v7 2.1's two guard
  shouts are kept as they are; they are not part of the plan and cost no feet.
- The corner minute's ONE change may swap the guard line (another guard or another moment), as v7 2.5.

### 2.2 Three guards, each for one kind of opponent
Points into the exchange's sum when the line fires (graded as a plan line, section 1):
| The opponent... | High guard | Elbows in | Light guard | Tag |
|---|---|---|---|---|
| loads up | **+9** | -2 | -10 | High, Light: V7 (PROBE7). Elbows in: ESTIMATE |
| presses | -4 | **+8** | -3 | High: V7. Elbows in: ESTIMATE. Light: v7 had +3; ESTIMATE down (light hands get walked down) |
| boxes at range | -8 | -5 | **+8** | High: V7. Light: v7 had +4; ESTIMATE up (its own moment). Elbows in: ESTIMATE |
| waits to counter | -3 | -3 | -8 | V7; Elbows in ESTIMATE. No guard beats the counter-puncher: against him the answer is no guard line |
| is tiring / is hurt | -9 | -4 | +5 | High: V7. Light: v7 had +9 / +8; ESTIMATE down so Light is not the answer to everyone. NOT IN PROBE 10 |
- Built for: High guard = the Slugger (loads up 0.45). Elbows in = the Pressure fighter and the Volume puncher (press 0.55 / 0.45).
  Light guard = the Out-boxer (range 0.6). The Counter-puncher: none.
- Done with (the grade word, `LineGrade` style): High = Defence + Composure, Light = Speed + Stamina (V7 2.2); Elbows in = Defence +
  Strength (ESTIMATE: holding the elbows in under body shots).
- After the exchange settles: High and Light keep v7's rules (V7 2.3: High blocks more, lands less and tires the puncher; Light lands one
  more, is hurt more). Elbows in has none (ESTIMATE, kept small on purpose).

### 2.3 The feet (v8's rule, three guards now)
- The natural stance is a trait: Narrow / Shoulder / Wide from (Power - Speed) / 4 at +-2 (V8 2.1, ST1).
- Each guard's stance: High = Wide, Elbows in = Shoulder, Light = Narrow. steps = how far the boxer's stance is from it.
| Steps from the guard's stance | The plus kept | High, Elbows in pay | Light pays |
|---|---|---|---|
| 0 (in his feet) | all of it | nothing | nothing |
| 1 | x0.5 | STEP SPEED: 4 points off that exchange | LEGS: 4 energy after that exchange |
| 2 | x0 | 8 points | 8 energy |
  (probe 9 run 2's sizes; PROBE9 measured them at -7.3 wins in 100 against free.)
- So a Shoulder boxer has Elbows in for free and the other two a step off; a Narrow boxer has Light for free and High two steps off (do
  not); a Wide boxer the mirror.

### 2.4 Moving the stance, and owning it (NEW in v9)
- Pad weeks move the stance ONE step (V8 2.1: a drillable card with a mastery bar; `PadWeek.drillable` PadWeek.gd 249, `drill` 348,
  `run_week` 369; `StepMastery.shadow_gain` StepMastery.gd 63, `nights_to_usable` 68).
- A moved stance changes the boxer (V8 2.1, ST1 round 2): a step wider = power, head movement, chin +5, footwork and foot speed -3, 1.5
  energy a round; a step narrower the reverse.
- **Not owned yet**: until he has boxed N bouts in the moved stance (N = 3, ESTIMATE), it also costs footwork and foot speed -4 and 2
  energy a round on the night (ST1 2: -2 / -2 / 2; the feet price doubled, ESTIMATE). After N bouts it is his stance; moving back is
  free (the natural stance is never forgotten).
- The choice this makes: for THIS opponent, is the right guard worth boxing a night on feet that are not his yet? Against the man the
  guard is built for it should be; against the others the natural stance and its cheap guard (or no line) should win.

### 2.5 What the player does with it
- Reads the opponent's file (which game he plays most), looks at his own boxer's stance, and picks: the guard built for that opponent
  if his feet can pay for it; the guard his feet have for free if it is not wrong for this man; no guard line; or pad weeks to move the
  stance a step, knowing the first N bouts in it are paid for.
- A run of similar opponents (a division full of pressers) makes owning the moved stance worth it; one odd opponent does not.

## 3. Sizes and where they come from
| Size | Value | Tag |
|---|---|---|
| The table (2.2) | as written | V7 for High and Light at loadup / counter; the rest ESTIMATE |
| The plus kept at 0 / 1 / 2 steps | 1.0 / 0.5 / 0.0 | PROBE9 run 2 |
| High, Elbows in out of their feet, a step | 4 points off the exchange | PROBE9 run 2 (High) |
| Light out of its feet, a step | 4 energy after the exchange | PROBE9 run 2 |
| A moved stance, a step | power / head movement / chin 5, feet 3, 1.5 energy a round | ST1 round 2 |
| Not owned yet | footwork and foot speed -4, 2 energy a round, for 3 bouts | ESTIMATE (ST1: -2, -2, 2) |
| Natural width | (Power - Speed) / 4, +-2 | ESTIMATE (ST1) |
No size here has a study behind it (ST1 3: stance width has none). John should be asked before a build.

## 4. What v9 takes from v8, changes or cuts
| From v8 | v9 |
|---|---|
| The guard as a WHEN-line paid for by the feet; the natural stance as a trait; pad weeks move it one step | KEPT |
| Guard lines on "your boxer is hurt / tired" | **CUT** from the plan (PROBE9: they fire against everyone, 16-21 times a pro bout). The corner's shout has them. |
| Two guards (High, Loose), three line sets | **CHANGED**: three guards (High, Elbows in, Light), each built for one opponent kind and with its own feet |
| Three guard lines a plan | **CHANGED**: ONE guard line a plan (the coach sets a guard for the man in front of him) |
| A moved stance is free on the night once the pad weeks are done | **CHANGED**: not owned yet for N bouts (slower feet, energy) |
| Light on "tiring" +9 / "hurt" +8, "press" +3, "range" +4 | **RESIZED** (2.2) so Light is the out-boxer's answer, not everyone's |
| The angle, the weight lean, the drift, the stance read on the tape | still out (V8 4) |

## 5. Every menu the mechanic appears on
| Menu | Shows | Wired to | Status |
|---|---|---|---|
| Fighter page, the header line | adds the natural stance ("wide stance") and, when moved, "moved a step narrower: 1 of 3 bouts to own it"; hover: which guard is in his feet | `scripts/ui/areas/FighterPage.gd` 63; new `scripts/rules/Stance.gd` (`natural`, `width`, `owned`, `steps`, `layer`) | TO BUILD |
| Fighter page / attribute board, the traits | a "Wide stance" row with its up (High guard is free) and its down (Light guard: do not) | `TraitLine.LINES` (TraitLine.gd 20) | TO BUILD |
| Camp / pad week board | a card "Stance: a step wider / narrower", its nights, what it makes cheap and dear, and "not owned for 3 bouts" | `PadWeek.drillable` 249, `drill` 348, `run_week` 369; `StepMastery.nights_to_usable` 68 | TO BUILD |
| Fight plan chart, the guard row | ONE guard line: pick the guard and its WHEN (the opponent's six moments only); each guard shows who it is built for, its grade word and its FOOT COST for this boxer ("in his feet" / "a step off: keeps half, slow feet" / "two steps off: do not") | `scripts/ui/PlanChart.gd` is at 499 lines: a new `PlanChartHands.gd`; new `scripts/rules/HandsLine.gd` (`points`), `Stance.steps` | TO BUILD |
| Fight plan chart, the checks | "one guard line"; a warning on a guard two steps from his feet; "his stance is not owned yet: slower feet tonight" | `PlanBoard.validate` 27 | TO BUILD |
| Fight prep / tale of the tape | his stance against the opponent's, and the opponent's main game beside it (the reason for the guard) | `scripts/ui/areas/BoutPage.gd` 71, 73; `Exchanges.STYLE_MODES` 156 | TO BUILD |
| Corner minute, ONE CHANGE | swap the guard line (guard or moment), each option with its foot cost; the two cover-up SHOUTS stay shouts | `PlanFight.corner_options` PlanFight.gd 207, `corner_change` 197; `Exchanges.MODES` 132-133 | TO BUILD (shouts exist) |
| Fight night, the corner's eye | "Elbows in: worked" / "High guard: slow feet, lost it" | `PlanRecord.line_state` PlanRecord.gd 124, `line_why` 136 | TO BUILD for guard |
| Fight analysis line / the Why | one line: "Light guard when he boxed at range: won 3 of 4. A step off his feet: cost 12 energy in the legs." and, on a moved stance, "Not his stance yet: slower feet all night (2 of 3 bouts to own it)" | `FightWhy.read` FightWhy.gd 26; `PlanRecord.WHY_ANSWER` 21 | TO BUILD |
| Playbook, the lines' record | works / fails for each guard by opponent style | `PlanRecord.rates` 79, `verdict` 108 | TO BUILD for guard |
| The 3D feet | the feet at the boxer's width; planted or light in the 30 seconds the guard fires; elbows in / gloves high / hands low as the guard pose | one stance today: `BoxerFootwork.STANCE_LEN` 0.50, `STANCE_WID` 0.32 (scripts/fight3d/BoxerFootwork.gd 48-49) | TO BUILD, only inside FIGHTPLAYER2 (the METHOD line: no new layer in scripts/fight3d). Until then it is read on the corner's eye and the Why. |

## 6. The probe (GUARDPROBE10, `tools/guardprobe10.gd` -> `docs/GUARDPROBE10_RESULT.md`)
- Instrument: GUARDPROBE9's (the exchange-by-exchange walk around the game's own fight night; Data's region opponents by style and sex,
  re-rated so today's game wins about half; 5 opponent styles x amateur 3 / pro 6 rounds = 10 cells; 40 seeds; every arm of a seed on the
  same dice) and its self-checks.
- Population: the five Data prospects + two generated boxers (Leon Ward, a Narrow out-boxer on Danny's sheet; Marcus Doyle, a Wide
  slugger on Josh's sheet; own stats, never a copy), so Narrow has 2 boxers (a woman, a man), Wide 2, Shoulder 3. 280 bouts a pair and cell.
- Pairs (7): no guard line; each guard (its one line) on the natural stance; each guard with the stance moved a step toward it, not
  owned. Beside them: the same lines FREE (v7's rule), and each of the five effects switched off.
- Read two ways: by opponent cell (all boxers pooled) and by boxer x style (and natural stance x style).
- Not measured: the pad weeks a move costs, an owned moved stance against the natural one over a run of bouts, a guard line read at the
  wrong moment, Light on "tiring / hurt", the corner's guard swap, the shouts, the 3D feet.
| Bar | Run 1 | Run 2 (the one resize: the guard's plus x 1.5) |
|---|---|---|
| 1 Every effect moves the result | PASS: 2.4 to 7.1 bouts in 100 | PASS: 2.3 to 7.4 |
| 2 A guard line costs something measurable | PASS: -4.0 +- 0.2 against free, 10 of 10 cells | PASS: -4.6 +- 0.2, 10 of 10 |
| 3 No pair best in more than 5 of 10 opponent cells | PASS: 3 | PASS: 3 |
| 4 Four or more opponent cells clear of the noise | FAIL: 1 | FAIL: 2 |
| 5 The best guard changes with the opponent for every boxer | PASS: 7 of 7, all beyond two standard errors | PASS: 7 of 7 |
| 6 The natural stance is best in some cells, beaten in others | PASS: 4 and 6 of 10 | PASS: 3 and 7 |
- By boxer (PROBE10 run 2, wins in 100 over no guard line): Tess (Shoulder) Light on a moved stance against the Out-boxer +14.4, Elbows
  in against the Pressure fighter +16.9, High on a moved stance against the Slugger +17.5. Kira (Narrow) Light +15.6 against the
  Out-boxer, Elbows in on a moved stance against the Slugger. Marcus (Wide) High +17.5 against the Slugger, Elbows in against the pressers.
- The best pair is on the natural stance in 28 of 35 boxer x style cases (run 1; 25 in run 2) and on a moved stance in the rest; the
  not-owned price alone is worth 3.5 wins in 100 on the night.
- Why bar 4 fails: pooled over seven boxers of three stances, the best pair's neighbour (the same guard on the other stance) is 1 to 3
  wins behind. By natural stance x style 5, then 6 of 15 cells are clear. Pro cells are close (+1 to +5): the line fires about as often
  in six rounds as in three.

## 7. Verdict
`RESULT: tools/guardprobe10.gd -> FAIL` twice (bar 4 only). By the brief it comes back to Claude with the cheap build costed
(`docs/GUARDPROBE10_RESULT.md`, "The cheap build, costed": two small pure modules, one chart row, about 15 lines of wiring, one session);
`ops/research/TASK_GUARD9CRIT.md` was NOT written and no critic was briefed.
1. Build v9 as mapped and judge it by boxer (the failed bar asks for one answer per opponent for all boxers, which this mechanic by
   design does not have): Claude's call on the bar.
2. The cheap build: the stance only sets the guard line's grade word; no moved stance.
3. One more probe with cells = natural stance x style and more generated boxers, if way 1 needs the proof.
Recommendation: way 1 at run 2's sizes (the table's plus x 1.5: High +13.5, Elbows in +12, Light +12), then the two critics.

## 8. Files opened (this session)
Whole: `tools/guardprobe9.gd`, `docs/GUARDPROBE9_RESULT.md`, `ops/research/DESIGN_GUARDDMG1_V8.md`, `ops/research/TASK_GUARDREV9.md`. In part:
`scripts/rules/Exchanges.gd` (33-36, 124-134, 150-206), `scripts/state/Data.gd` (215-275). By grep only (the line cited and nothing else):
`FightFlow.gd`, `LineGrade.gd`, `LiveRound.gd`, `PlanFight.gd`, `PlanBoard.gd`, `PlanRecord.gd`, `PadWeek.gd`, `StepMastery.gd`, `FightWhy.gd`,
`TraitLine.gd`, `Attrs.gd`, `Combos.gd`, `Duels.gd`, `RingDuel.gd`, `scripts/ui/areas/FighterPage.gd`, `BoutPage.gd`,
`scripts/fight3d/BoxerFootwork.gd`; `scripts/ui/PlanChart.gd` by its line count. Not opened: `DESIGN_GUARDDMG1_V7.md`, `DESIGN_STANCE1.md`,
`docs/STANCEPROBE1_RESULT.md`, memory S531 (their conclusions were taken from the V8 map and probe 9's page, which cite them).
