# GUARDDMG1 V9 - code-checked critic (S537, Fable, brief `ops/research/TASK_GUARD9CRIT.md`)

Fresh critic. Read: the critic brief, the map `DESIGN_GUARDDMG1_V9.md`, `tools/guardprobe10.gd` whole, `docs/GUARDPROBE10_RESULT.md`
(both runs' summary, cost, by-boxer and effect tables), and every code line the map cites. Kalli's answer was not opened.
Nothing under scripts/ was edited; Godot was not run. Scores are for what is MEASURED, not what the map promises.

## Scores (bar: 8 DEPTH and 8 PLAY, owner S534)
| | Score | In one line |
|---|---|---|
| DEPTH | **5 / 10** | A wrong guard cannot lose points in the probe, so the pick is "the guard his feet have, or the one built for this opponent": a look-up with one constraint. The one real spend (moving the stance) is priced for one night only and never measured over a run of bouts. |
| GENERAL DESIGN | **6 / 10** | Honest map, true to the code, buildable. But the WHEN choice is empty, the High guard line doubles the "Hands up" shout, the word "stance" already means orthodox / southpaw, and whether the guard takes one of the four plan lines is not said. |
| PLAY | **5 / 10** | Amateur: a right guard is worth +5 to +10 wins in 100, felt. Pro: +1 to +5, inside the noise in 4 of 5 pro cells. Nothing on a screen today shows the boxer's side of the read. |

**Verdict: below the bar on both. Do not build v9 as mapped ("way 1"). One more greybox round with the changes in "To reach 10/10" items 1 to 3; they are small changes to the probe, not a new design.**

## 1. The code claims (section 1 and 5 of the map)
Opened 2026-11-22 on the working tree. LineGrade.gd, LiveRound.gd are confirmed by function / constant name only (other sessions' uncommitted edits), as the brief asks.

| Claim in the map | Verdict | What the code has |
|---|---|---|
| `Exchanges.situation` 194-199: hurt first, then tired, else the opponent's game | TRUE | Exchanges.gd `situation` 194-199 |
| `SHE_TIRED` 35 at line 52 | TRUE | Exchanges.gd 52 |
| Six opponent games, `MODES` 124-131 | TRUE | `MODES` opens at 124; the six games are 126-131 |
| `FightFlow.WHEN_WORDS` 33 | TRUE | FightFlow.gd 33 |
| `STYLE_MODES` 156-167 and the five shares quoted (Slugger loads up 0.45, Pressure presses 0.55, Out-boxer range 0.6, Counter-puncher 0.55, Volume 0.45 / 0.35) | TRUE | Exchanges.gd 156-168. Left out by the map: the Slugger also PRESSES 0.35, which is why Elbows in ties High against him in the probe |
| Body shots are a share of landed punches (33-36), "a presser walks onto body shots" (125-126); no body moment exists | TRUE | Exchanges.gd 33-36, 125-126 |
| Own trouble has corner answers: tired best Calm / ok Hands up; hurt best Tie up / ok Hands up (132-133); the call "Hands up, move your head" at 79 | TRUE | Exchanges.gd 132-133, 79. NOT SAID by the map: the same "hands" call is the BEST answer to "loadup" (`MODES` 129) and its own `when` text is "When they load up" (80) |
| Plan line picked by `PlanFight.choose` in LiveRound, worth `plan_edge` | TRUE | `PlanFight.choose` (PlanFight.gd 114) is called in `LiveRound.exchange`; `plan_edge` comes from `LineGrade.edge` there |
| `LineGrade.DONE_WITH`, `PLUS` x1.15 / 0.99 / 0.90 | TRUE | both exist in LineGrade.gd with those three values |
| `Exchanges.COMMIT` 32: x1.5 / 1.0 / 0.6; `GOOD_AT` 62 / `OK_AT` 50 at 24, 25 | TRUE | Exchanges.gd 32, 24, 25 |
| A right line +9, a wrong one -7, `PlanFight.EDGE` 20 | TRUE | PlanFight.gd 20 |
| `PlanBoard.NEW_COACH` 10 (= 4), `arrow_limit` 15, `validate` 27 | TRUE | PlanBoard.gd 10, 15, 27 |
| The round's standing edge `lv["base"]` set in `LiveRound.open`, read into the exchange | TRUE | set in `open`'s dict, read in `exchange` (`var d := float(lv["base"]) + ...`) |
| The round's energy `lv["cost"]`, taken off in `LiveRound.close` | TRUE | `close` reads `lv["cost"]` |
| `Combos.TANK` 100 at 24; `Duels.TIRED_AT` 65 at 71 | TRUE | Combos.gd 24, Duels.gd 71 |
| `Attrs.of` 59, `_clean` 88 | TRUE | Attrs.gd 59, 88 |
| No guard line, stance width or "not owned" in the game | TRUE | no `Stance.gd` / `HandsLine.gd` under scripts/rules |
| "Stance" today is orthodox / southpaw: `FighterPage.gd` 63, `BoutPage.gd` 71, 73 | TRUE | both lines print `f["stance"]` / `opp["stance"]` |
| `TraitLine.LINES` 20 | TRUE | TraitLine.gd 20 |
| `PadWeek.drillable` 249, `drill` 348, `run_week` 369 | TRUE | PadWeek.gd 249, 348, 369 |
| `StepMastery.shadow_gain` 63, `nights_to_usable` 68 | TRUE | StepMastery.gd 63, 68 |
| `scripts/ui/PlanChart.gd` is at 499 lines | TRUE | 499 |
| `PlanFight.corner_change` 197, `corner_options` 207 | TRUE, with a catch | both there. `corner_change` takes a MOVE id and returns the old plan when `StrikeMap.move(id)` is empty, and `PlanBoard.validate` checks moves. A guard line `{"hands","when"}` cannot live inside the arrows list: it needs its own field and its own corner option. The map's "wired to" is a new path, not a hook |
| `PlanRecord.WHY_ANSWER` 21, `rates` 79, `verdict` 108, `line_state` 124, `line_why` 136 | TRUE | PlanRecord.gd, those lines |
| `FightWhy.read` 26 | TRUE | FightWhy.gd 26 |
| `BoxerFootwork.STANCE_LEN` 0.50, `STANCE_WID` 0.32 at 48-49 | TRUE | BoxerFootwork.gd 48-49 |

34 claims: all TRUE. None FALSE, none NOT FOUND. Three things the code says that the map does not (they change the design):
1. **The High guard line is the "Hands up" shout again.** "Hands up, move your head" is already the best corner call when the opponent loads up (worth 15, `PlanFight.gd` 18's comment), and it already works on the guard (`GuardState.gd` 47: "Hands up +5 at the corner"). The map only names it as the answer to your own boxer's trouble. High guard WHEN he loads up stacks a +9 on the same moment with the same words; the stacking rule is not written.
2. **The opponent's side of the read is on screen today.** The opponent's file prints "Game: <style>: <main game>" at booking and "Plan an arrow for 'If the opponent presses'" (`OppFile.tells`, OppFile.gd 76-79), the other games open with film (`ModeTells`), and the plan screen reads `OppFile.main_game` (GamePlan.gd 100, 143). The boxer's side (his natural width) is on no screen.
3. **A style's games are flatter in a fight than the table** (BoutRead.gd 276: `MAX_RUN` makes them flatter than `STYLE_MODES`). The "0.45 of the time" numbers overstate how often a guard's moment comes.

## 2. The probe (`tools/guardprobe10.gd`)
**What it models as the map says**
- Guard lines only on the opponent's moments: yes. The line is looked up by `Exchanges.situation` (`_ex`), which returns the boxer's own hurt / tired first, and the three line sets hold only loadup / press / range.
- Three guards with their feet, plus kept x1 / 0.5 / 0, step speed off the exchange for High and Elbows in, energy for Light: yes (`_points`, `_steps`, the `leg` lines in `_ex`).
- The moved stance and "not owned yet": yes (`_stance`: the width layer on the bout's copy, footwork and foot speed -4 more, 2 energy a round more).
- The instrument is sound: all arms of a seed on the same dice; with every size off it reproduces the game's own bout 42 of 42; the copied guard walk differs by 0.000000; opponents re-rated to the boxer and height / reach levelled, so only style differs; no two fighters identical.

**Where it does not model the map, or the result is true by construction**
1. **A wrong guard cannot lose points. 15 of the table's 18 cells never run.** A line fires only on its own WHEN, and each guard is only ever tried on the one moment where its number is positive. The -10 for Light when he loads up, the -8 for High at range, the whole counter row: read by no bout. The only way a guard loses in the probe is through its feet. So against the Counter-puncher, where the map says "the answer is no guard line", the probe's pooled best is a guard in both runs (inside the noise of no line). The map's table is a design on paper; the probe measured three numbers of it.
2. **Bar 3 and bar 5 pass largely by construction.** Each guard fires on one moment; each style has a different commonest moment; so "the best guard changes with the opponent" follows from `STYLE_MODES` by arithmetic (share of the moment x the plus). What the bars really show is the weaker thing: the feet's price does not drown that arithmetic.
3. **Bar 5's "beyond the noise" is flattered twice**: the best of up to 7 pairs is chosen on 80 bouts, then the largest of up to 20 style-against-style swings is tested at two standard errors. In run 1 three of seven boxers pass at 2.3 to 3.0 standard errors after that double pick (Leon, Kira, Danny): not safe. Four of seven (Tess, Josh, Marcus, Samira-borderline) are real.
4. **The guard line is free of plan cost.** The boxer keeps all four move lines and gets the guard on top. In the game a new coach has four lines; if the guard takes one (v7 did), the probe overstates every guard; if it does not, a guard in his feet is a free plus he should always take. The map does not say which.
5. **Run 2 is not pre-registered.** The header says sizes are set "never on the test's seeds", but run 2's resize was chosen after run 1 on the same 40 seeds. Read run 1 as the result and run 2 as a sensitivity check.
6. **No shouts.** Every exchange is called with no corner shout. In the game the player shouts "Hands up" at the load-up; with it, High guard's own +9 lands on an exchange that already has +15 (see section 1).
7. **"Not owned" is one night.** The pad weeks a move costs, what else those weeks would have bought, and the three bouts to own it are not in the measure. The decision the map calls new in v9 is priced only as "-3.5 wins tonight".
8. **Light's leg price is out of scale.** Against the Out-boxer (amateur, its own man) Light is +12.1 free and -3.6 paid: a step off its feet turns the right guard into a loss (-15.7 +- 2.2). It fires about ten times a bout at 4 energy each. As sized, Light is "Narrow boxers only, or move the stance".

Controls fair? The free twin, the effect switches and the paired dice are fair. The missing control is the important one: **a guard on the wrong man** (point 1).

## 3. Bar 4: real depth or noise dressed up?
**Partly real, mostly thinner than the reading claims.**
- The reading "by boxer 7 of 7 are clear" is not what was measured. Bar 5 says each boxer's best guard differs between SOME two styles. It never counts how many boxer x style cells have a clear best. The nearest honest number is in the result's own stance x style table (boxers of a stance pooled, 160 to 240 bouts): **5 of 15 clear in run 1, 6 of 15 in run 2.** Splitting by stance, the fix the reading proposes, still leaves 60% of the cells with no clear answer.
- What is real: against the man a guard is built for, in the amateurs, a boxer whose feet fit gains +11 to +17 wins in 100 (Kira Light against the Out-boxer, Tess Elbows in against the Pressure fighter, Marcus High against the Slugger). Those are 3 to 5 standard errors and survive any correction.
- What is thin: the boxer's own feet decide more than the opponent does. **The guard already in his feet (or no line) is the best pick in 25 of 35 boxer x style cells in run 1 and 22 of 35 in run 2.** A Narrow boxer's answer is Light against three or four of five styles; a Wide boxer's is High or nothing. The player who never opens the opponent's file and always sets "his" guard is right about two times in three, and the probe does not say how little he loses the other third. That is closer to a default than to a read.
- Pro bouts, where the career is heading: the best pair is +1.1 to +3.6 over no line in run 1 and no pro cell is clear. Whatever the cause, the mechanic fades as the game goes on.
- Does the player have the information? The opponent's half: yes, today (opponent's file, section 1 point 2). The boxer's half: no; it is five TO BUILD rows. And the natural width is (Power - Speed) / 4, so it is his style said again: both Narrow boxers are Out-boxers, both Wide ones Sluggers. It tells the player little he did not know, and the map does not say whether it is fixed at signing: Tess and Josh sit at +1.75, one point of Power from turning Wide by training.

**Verdict on the bar:** do not waive it and do not re-cut the cells until it passes. Bar 4 is doing its job: it says the guards are not yet different enough in outcome for one answer to stand out, because nothing punishes the wrong one. Fix that (below), then measure by natural stance x style with the bar "8 of 15 clear, and the in-his-feet default is best in under half".

## 4. Options: missing, useless, what each changes
| Option | Verdict | What it changes |
|---|---|---|
| Pick the guard (High / Elbows in / Light / none) | KEEP | measured: +5 to +17 on the right man in the amateurs, about 0 to +3 elsewhere |
| Pick the guard's WHEN among six moments | **USELESS** | each guard has one positive moment (Light has a small second one, not probed). Every other WHEN is a loss anyone can see. It is a second click with one right answer |
| Move the stance on the pads | KEEP, unproven | measured only as tonight's price. It is best in 7 to 10 of 35 boxer x style cells, almost all the three Shoulder boxers |
| Swap the guard at the corner minute | UNPROVEN | not in the probe; with a guard that cannot be wrong there is nothing to swap away from |
| "No guard line" | USELESS as built | never the clear answer; meant to be the answer to the Counter-puncher but is not (section 2 point 1) |
| MISSING: a guard that can be wrong | - | see 10/10 item 1 |
| MISSING: what the guard costs the plan | - | a line slot, or nothing? Decide and say |
| MISSING: the opponent answering the guard | - | a Slugger who sees High all night goes to the body. Without it the pick is made once per opponent and never again |
| MISSING: the read of the opponent's SECOND game | - | the Slugger presses 0.35; film opens the second game (`ModeTells`). The guard choice should reward having watched |

## To reach 10/10 (most important first)
1. **Make the guard a standing guard for the fight, so the whole table runs.** The coach sets ONE guard; it scores on EVERY opponent moment by the map's 2.2 table, not only on one WHEN. Drop the WHEN pick. The table as written already balances when summed over a style's games (share x points, per exchange): against the Slugger High +1.6, Elbows in +1.1, Light -5.6; Pressure fighter -1.7 / +3.1 / -4.1; Out-boxer -4.9 / -3.6 / +1.7; Volume puncher -4.0 / +1.4 / -0.4; Counter-puncher -3.2 / -2.3 / -3.7. One right guard per man, a close second against the Slugger, wrong guards that cost, and "no guard" as the true answer to the Counter-puncher: everything the map says in words and the probe did not test. Probe it first (one constant and the look-up in `_ex`; the rest of guardprobe10 stands).
2. **Give the corner minute its job.** With a guard that can be wrong, "swap the guard" matters: the opponent who is losing the load-up exchanges switches to pressing in round 2 (he already changes game after `MAX_RUN`). Put the swap arm in the probe: swap at the bell against keep. Bar: the swap is right in some cells and wrong in others.
3. **Settle the stance as an investment, measured over a run.** A five-bout ladder arm: stay natural / move and own it after three. Count the pad weeks against what they would have bought (a move line to mastery 30 in 2 to 3 weeks). If moving never pays over five bouts, cut the moved stance and keep the natural one as a trait only (the map's "cheap build").
4. **Say what the guard costs the plan.** Recommended: it is its own row, free of the line limit, because item 1 already makes it losable. Then the probe's arm matches the game.
5. **One rule for High guard and the "Hands up" shout.** Recommended: they do not stack; with High guard set, "Hands up" at the load-up is worth its ok value, and the shout stays the answer when no guard is set. One line in the map, one arm in the probe (with the shout on).
6. **Halve Light's leg price** (4 energy to 2 a firing a step off) or cap it per round, so a Shoulder boxer can box Light against the Out-boxer at a price instead of at a loss.
7. **Call it "base" or "feet", not "stance".** The fighter header and the tape already print stance = orthodox / southpaw on the very lines the map wants to add to. Fix the natural width at signing (never recomputed from trained Power and Speed) and say so.
8. **Fix the fade in the pros.** Find why six rounds give the guard less than three (the probe says the line fires about as often; check `fired` per bout by scale) and scale the standing guard by rounds.
9. **Re-run with bars that cannot pass by construction:** (a) 8 of 15 natural-stance x style cells clear; (b) the in-his-feet guard is best in under half of the boxer x style cells; (c) a wrong guard is 3+ wins in 100 under no line in 6+ of 10 cells; (d) run 1 sizes only, new seeds for any resize.
10. **Show the boxer's half before anything else is built**: one line on the plan chart's guard row, "<guard>: built for <opponent's main game>. His feet: in them / a step off / two steps off", fed by the opponent's file line that exists today.
11. Ask John for the real numbers behind stance width and guard choice (the map itself says no size has a study).

## My 10/10 page (1920x1080, the fight plan chart's guard row opened; described, not drawn)
- **Top band (full width, 120 px):** the tale of the tape in one line. Left: your boxer's face, "Base: shoulder width (his own)". Right: the opponent's face, style and, from the file, his games as a four-part bar ("presses 55 / loads up 20 / counters 15 / range 10"; the parts not yet filmed are grey with "watch film").
- **Middle (three cards side by side, 560 px wide each, plus a slim "No guard" card):** High guard, Elbows in, Light guard. Each card: the guard pose drawing; "Built for: the man who loads up"; under it the SAME four-part bar of this opponent with each part coloured green / grey / red by what this guard does on that game, and one sum line in words: "Good on 45 of his fight, bad on 35". Then "His feet: a step off. Keeps half, slower feet" in amber. The card his feet own has a small "his own" tag. One click sets the guard; there is no WHEN.
- **Right rail (320 px):** "If he changes": what the corner can swap to at the bell and what it would cost; "Hands up" shown as covered by High guard when High is set.
- **Bottom band (160 px):** the record. "Light guard against out-boxers: 3 fights, won 2" from the playbook, and, when a base move is in the pads, "Base a step wider: 2 of 3 bouts to own it. Tonight: slower feet."
- No number the player cannot act on; every colour has its word beside it.

## Files opened
Whole: `ops/research/TASK_GUARD9CRIT.md`, `ops/research/DESIGN_GUARDDMG1_V9.md`, `tools/guardprobe10.gd`. In part: `ops/research/DESIGN_GUARDDMG1_V9_CRITIC_KALLI.md`
(1-25, the brief; the critic pack below it by its headings only), `docs/GUARDPROBE10_RESULT.md` (run 1: 86-97, 176-190, 210-295; run 2: 435-520),
`ops/research/DEPTH_AUDIT_S534.md` (headings). Code, the cited lines and their neighbours: `scripts/rules/Exchanges.gd` (22-36, 48-52, 60-63, 77-80,
122-134, 154-168, 190-200), `FightFlow.gd` (31-34), `PlanFight.gd` (18-21, 195-209), `PlanBoard.gd` (8-28), `Attrs.gd` (57-60, 86-89), `Combos.gd`
(23-25), `Duels.gd` (70-72), `TraitLine.gd` (19-21), `PadWeek.gd` (248-250, 347-349, 368-370), `StepMastery.gd` (62-69), `PlanRecord.gd` (20-22,
78-80, 107-109, 123-125, 135-137), `FightWhy.gd` (25-27), `OppFile.gd` (70-90), `scripts/ui/areas/FighterPage.gd` (61-64), `BoutPage.gd` (69-74),
`scripts/fight3d/BoxerFootwork.gd` (47-50), `scripts/ui/PlanChart.gd` (line count). By grep, names only: `scripts/rules/LineGrade.gd`,
`scripts/state/LiveRound.gd`, `scripts/state/GuardState.gd`, `scripts/ui/GamePlan.gd`, `scripts/rules/BoutRead.gd`.
Not opened: `docs/GUARDPROBE9_RESULT.md`, the V7 / V8 maps, `DESIGN_STANCE1.md`, Kalli's answer, the critic pack's body (this critic judged from the
code and the probe; a claim about the wider game here rests on the lines listed above).
