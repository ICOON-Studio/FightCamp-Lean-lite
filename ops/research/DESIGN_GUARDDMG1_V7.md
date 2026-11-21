# GUARDDMG1 V7 - the guard is a WHEN-line of the fight plan (S535, Fable console, from the code)

Brief: `ops/research/TASK_GUARDREV7.md`. Follows the verdict of `docs/GUARDPROBE6_RESULT.md` (v6 FAIL): a Hands setting held for
the bout is never right (NORMAL best in 12 of 12 cells); the same two actions used only in their moment win 5 to 6 more
exchanges in 100 and cost 5 to 13 when used in the wrong one. That is a METHOD finding: the guard is not a setting, it is
a reaction. Claude's decision (owner S534 free hand: "you can remove,add from scratch or interconnect current and current
with needed mechanics"): REMOVE the Hands setting, INTERCONNECT the guard with the fight plan's WHEN-lines.
Tags: **CODE** = I opened the file today (2026-11-21, working tree on main at 3cf9afc2d) and the line is true. **V6** = taken
from the v6 map's own CODE table, not re-opened. **DERIVED** = my sum from CODE numbers. **ESTIMATE** = a size the probe
set or must still set. **PROBE7** = measured by `tools/guardprobe7.gd`, `docs/GUARDPROBE7_RESULT.md`.
`scripts/rules/LineGrade.gd` and `scripts/state/LiveRound.gd` carry another session's uncommitted STEPPAY2 edits
(LineGrade 86-89 `ride_edge`, LiveRound 245-246 `StepWire.ride`): read as they are, line numbers are the working tree's.

## 0. The short version
- The plan already has WHEN-lines: "IF the opponent presses -> Step back" (`PlanBoard.gd` 4-7, `PlanChart.gd` 4-6). v7
  adds two more answers an IF can carry: **Hands High** and **Hands Loose**.
- A guard line fires only in the 30 seconds fought in its moment. In the right moment it is worth about as much as a
  best plan line; in the wrong moment it loses the exchange about as often.
- There is no Hands button to hold any more. Reading the opponent before the bout (which moments will come), reading
  your own boxer (who covers well, who lets the hands go well) and changing one line at the corner minute are the skill.
- A guard line takes one of the coach's plan lines (a new coach holds 4, `PlanBoard.gd` 10, 15-16). So it is paid for
  with a move line, and which moment gets it changes with the opponent and the length of the bout.
- Probe v7: **PASS** (200 bouts a cell, 12 cells). The right three lines beat no guard line by 5+ wins in 100 in 10 of 12
  cells (+2.0 to +11.0); three lines on the wrong moments lose 5+ in 11 of 12 (-4.5 to -12.5); a boxer who reads the moment
  right only 70 times in 100 still wins more in 12 of 12 (+1.5 to +7.5); no single line is best in more than 7 of 12 cells
  (exactly 7: the bar is met with nothing to spare).

## 1. What the code does today (CODE)

### 1.1 The plan's WHEN-lines
- A plan is an array of lines `{"move": id, "when": situation}`; `when` is the opponent's game or your boxer's own
  trouble, "" = any time (`PlanBoard.gd` 4-7). The eight moments and their words: `FightFlow.WHEN_WORDS` 33-35.
- Each exchange the bout works out the moment (`Exchanges.situation` 194-199: your boxer hurt, then tired under 35
  energy, else the opponent's game) and asks the plan for the line at this place and this moment
  (`LiveRound.gd` 239-240 -> `PlanFight.choose` 101-110 -> `PlanBoard.pick` 74-86: the moment's line beats the any-time line).
- The line's worth joins the exchange's sum BEFORE the dice: `plan_edge` at `LiveRound.gd` 248, added at 265,
  settled at 287 (`Exchanges.settle` 356-361). A best answer is +9, a wrong one -7 (`PlanFight.EDGE` 19).
- It is graded by how this boxer does it: a plus x 1.15 / 0.99 / 0.90 (Good / OK / Poor, `LineGrade.PLUS` 40), a minus
  x 1.5 / 1.0 / 0.6 (`Exchanges.COMMIT` 32: a wrong thing done well costs more); two attributes a move (`LineGrade.DONE_WITH` 13-34).
- A line does not always come off: half the time at Usable, three in four at Sharp, always at Signature
  (`FireLevel.GAME_SHARES` 24, `LiveRound.gd` 242). A wrong line may be held by a boxer who reads it (`LiveRound.gd` 258-262).
- How many lines: 4 for a new coach to 9 (`PlanBoard.arrow_limit` 15-16: 4 + (rating - 30) / 12), checked at
  `PlanBoard.validate` 31-32; a named style adds one, to 7 at most (`StyleName.limit` 114-115, `MAX_LINES` 9).
- The corner minute changes ONE line a round (`PlanFight.corner_change` 184-188, `corner_options` 194-216).
- The plan's true effect is already counted: the same dice without the plan's edge (`LiveRound.gd` 290 `plan_swing`),
  read by the Why (`FightWhy.read` 49-52). Each line's fate is kept: worked / lost / held / not ready
  (`PlanRecord.line_state` 124-131) with its cause and its answer (`line_why` 136-147, `WHY_ANSWER` 21-23).

### 1.2 The guard today
- Nothing of the guard is in the exchange's sum except the corner call "Hands up, move your head": +17 x grade when the
  opponent loads up, +5 when your boxer is tired or hurt, 0 elsewhere (`Exchanges.MODES` 126-133, `EDGE` 18, `CALLS` 79-81).
- Blocks, wear, the leak and the tie-up's refill run AFTER the settle (`LiveRound.gd` 354-359, `GuardState.after`) and
  feed only the knockdown rule (V6 1.3-1.4). The simmed corner never calls "Hands up": it calls "Jab and move" or "Go to
  the body" (`BoutRules.auto_corner` 377-378).
- None of v6's section 2 was built (no `HandsEdge.gd` in `scripts/`): there is nothing to remove from the game, only from the design.

### 1.3 What probe 6 measured (the reason for v7)
| The moment | exchanges in 100 | High against no setting | Loose against no setting |
|---|---|---|---|
| The opponent loads up | 11 | **+4.7** | -9.8 |
| The opponent presses | 19 | -4.6 | +1.9 |
| The opponent boxes at range | 11 | -9.0 | +2.7 |
| The opponent waits to counter | 13 | -2.8 | -6.4 |
| The opponent is tiring | 9 | -12.9 | **+5.8** |
| The opponent is hurt | 3 | -12.2 | **+4.5** |
| Your boxer is tired | 30 | -0.5 | -6.0 |
| Your boxer is hurt | 4 | **+5.9** | -12.0 |
(`docs/GUARDPROBE6_RESULT.md` as read at 17:34 on 2026-11-21, the S534 run of 976 s - the file is untracked on main and
another session has a re-run queued; "One exchange"; shares are its exchange counts over their sum, 57,180.) High or Loose
held all bout pays in one or two rows and loses in the rest: -1.5 to -11.5 wins in 100 in every cell.

## 2. The change (TO BUILD; sizes from the ladder of section 6)

### 2.1 A guard line
- A plan line `{"hands": "high" | "loose", "when": <one of the eight moments>}`. No place and no move: it holds wherever
  the 30 seconds are fought. One guard line a moment at most. It lives in the same `fighter.arrows` the bout already
  reads, and it counts in the coach's line limit (1.1): a new coach's four lines are four choices, and a guard line is one.
- Drawn on the plan chart as an answer of an IF diamond (`PlanChart.gd` 4-6, `_answers` 354): the list of answers to "IF
  the opponent loads up" gains two rows, **Hands High** and **Hands Loose**, each rated with the words the move rows
  use (Beats it / Works / Walks into it, `PlanLines.FIT_WORDS` 24) and your boxer's grade.
- New pure module `scripts/rules/HandsLine.gd` (the table of 2.2, `points`, `fit`, `read_share`) and
  `PlanBoard.hands_for(plan, when)`. In `LiveRound.exchange`, beside line 248: `plan_edge += HandsLine.points(...)`,
  so it is settled at 287 with the rest and the Why's swing (290) counts it as the plan's.
- The corner shouts keep their meaning for one exchange: "Hands up, move your head" = High for those 30 seconds, "Let
  your hands go" = Loose (V6 2.1). A shout beats the line. NOT MEASURED by probe 7 (the simmed corner never shouts them, 1.2).

### 2.2 The points, by the moment (power points into the exchange's sum; step s1, the smallest of the ladder)
| The moment | Hands High | Hands Loose | The read |
|---|---|---|---|
| The opponent loads up | **+9** Beats it | -10 Walks into it | cover the big single shots |
| The opponent presses | -4 Walks into it | +3 Works | a shell on the ropes gives the round away |
| The opponent boxes at range | -8 Walks into it | +4 Works | covering against a jab is not punching |
| The opponent waits to counter | -3 | -8 Walks into it | neither: leave the hands alone, feint (a trap for both lines) |
| The opponent is tiring | -9 Walks into it | **+9** Beats it | covering lets a tired boxer rest: open up |
| The opponent is hurt | -9 Walks into it | **+8** Beats it | same |
| Your boxer is tired | +4 Works | -8 Walks into it | survive the 30 seconds |
| Your boxer is hurt | **+8** Beats it | -12 Walks into it | survive the 30 seconds |
- Grading, as every plan line (1.1): a plus x `LineGrade.PLUS`, a minus x `Exchanges.COMMIT`. **High is done with
  Defence and Composure, Loose with Speed and Stamina** (ESTIMATE pairs, in `LineGrade.DONE_WITH`'s form). So the same
  line is worth more on one boxer than another, and a boxer who is Good at covering loses more when told to cover at the wrong time.
- DERIVED from `Exchanges.settle` (two dice of +/-33): from an even exchange +9 wins 13 more in 100, +12 wins 16, +15
  wins 20; -8 loses 11, -10 loses 14, -12 loses 16. A best corner call done well is +17 (22 in 100): a guard line stays under it.
- Why bigger than v6's +5 / +6: v6 graded the plus by the corner call's rule (x0.6 at OK, `Exchanges.GRADE` 28) and the
  after-settle costs below took part of it back; measured, that left 0.5 to 4 wins in 100 for a perfect read.

### 2.3 After the settle (V6 2.3-2.5, kept, but only in the exchange the line fires)
| | Hands High | Hands Loose |
|---|---|---|
| The opponent's landed | 1 in 3 becomes a block | +1 when the opponent won the exchange |
| Your boxer's landed | x0.75 | +1 when your boxer won it |
| Blocked share of the misses (0.60 today) | 0.75 | 0.45 |
| Wear of each block | +8% | no change |
| Chance your boxer is hurt losing big | x0.7 | x1.3 |
| Head damage | only the leak | +2.0 for the extra clean punch |
- A worn guard costs its owner 2 points under half, 4 under a quarter (V6 2.3). High against pressing or loading up
  drains the opponent 1 energy an exchange (V6 2.4). Both ran in every arm of probe 7.

### 2.4 Reading the moment (the boxer's part)
- A guard line fires when the boxer READS the moment. `HandsLine.read_share` (ESTIMATE): 0.55 + (Fight IQ - 50) / 100,
  +0.10 when the moment is on the opponent's file (2.5), kept between 0.50 and 0.95. On a miss the boxer takes the moment
  for another one, and the plan's line for THAT moment fires if there is one.
- So more guard lines are not free on a boxer who reads badly: each extra line is one more thing to do at the wrong time.
- PROBE7 measured two points of it: read share 1.00 (RIGHT) and 0.70 (NOISY). At 0.70 the three lines keep about
  half of their worth (+1.5 to +7.5 wins in 100 against +2.0 to +11.0) and never fall under no line at all.

### 2.5 How the player learns which moment is which
| When | What shows it | Code |
|---|---|---|
| Before the bout: which moments will come | The opponent's file: the style's main game is known free; film shows each other game as often / some / rare. Filed film claims say "put a line on it". The chart's "+ Add an IF" list is that file. | `ModeTells.free_mode` 41, `band` 27; `FilmNight.rows_of` 94-103; `PlanChart.gd` 5-6, `_add_list` 393 - CODE TODAY |
| Before: how long the bout is | Tiring comes late: 3 exchanges a bout over 3 amateur rounds, 9 over 6 pro rounds against a heavy presser. The Loose-when-tiring row says so on its hover. | `docs/GUARDPROBE6_RESULT.md` "tiring exchanges a bout" - TO BUILD (the hover) |
| Before: how your boxer does it | The grade word on the answer row (Good / OK / Poor) from Defence + Composure or Speed + Stamina, shown as a range while the attribute is not yet known ("OK to Good"). Composure narrows in bouts and hard sparring. | `Knowledge.shown` 251, `range_of` 174, groups 9-11, `bout` 136, `hard_spar` 124 - CODE TODAY; the row TO BUILD |
| During: the moment on show | The clue line each exchange ("mouth is open; the hands come back slow"); without full film the corner sees the game of the exchange before. | `Exchanges.CLUES` 137-153, `LivePreview.preview` 39-42 - CODE TODAY |
| During: what the line did | The corner's eye: the plan's line this exchange and worked / lost / held; a guard line shows the same way, with "read it late" on a miss. | `PlanRecord.line_state` 124-131, `LiveRound.gd` 374-375 - CODE TODAY for moves; guard TO BUILD |
| The corner minute | ONE change: add, swap or drop a guard line. The coach's read of the last three exchanges names the game. | `PlanFight.corner_options` 194-216, `Exchanges.read` 410-431 - CODE TODAY for moves; guard TO BUILD |
| After: the Why | "Hands High when the opponent boxed at range: cost 3 exchanges. Plan it for another moment." One row a moment: times it came up, your line, exchanges won with it, the swing. | `LiveRound.gd` 290, `FightWhy.read` 49-52, `PlanRecord.WHY_ANSWER` 21-23 - CODE TODAY for moves; guard TO BUILD |
| After: next time | The Playbook keeps each line's record over bouts (works / fails / too early on 6+ uses). | `PlanRecord.rates` 79, `verdict` 108, `MIN_USED` 14 - CODE TODAY for moves; guard TO BUILD |

## 3. Does one line win everything? (the depth claim; section 6 measures it)
- Each line pays only as often as its moment comes, and the moments differ by opponent and by format (`Exchanges.STYLE_MODES`
  156-167: a Slugger loads up 45 in 100, an Out-boxer 10; tiring needs a long bout or body work).
- PROBE7, one line alone: High WHEN loading up is best or joint best in 7 of 12 cells, Loose WHEN tiring in 5, High WHEN
  your boxer is tired in 2 (the two long bouts against a counter-puncher). One line alone is worth 0 to +5 wins in 100; the
  three together +2 to +11: the worth is in the set, and the set differs by opponent. CAUTION: one line's worth is the size
  of the noise at 200 bouts (about 2.5), so "which single line is best" is a weak read; the bar passes at exactly 7.
- The choice is real three times: which moments get a line (limit), whether THIS boxer should carry it (grade, read
  share), and which line to give up for it (a move line answers one place; a guard line answers one moment everywhere).
- The trap rows: "waits to counter" punishes both actions; "your boxer is tired" pays High only +4 and is 30 in 100 of
  all exchanges, so a tired boxer told to let the hands go loses the most often of all.

## 4. What v7 takes from v6, changes or cuts
| v6 | v7 |
|---|---|
| 2.1 Hands: High / Normal / Loose, a standing setting beside Pace and Aim | **CUT.** Probe 6: never right held. No Hands row on the corner bar or the shout bar. |
| 2.1 the two shouts = High / Loose for one exchange | KEPT (2.1 here). |
| 2.2 the table | KEPT in sign, resized by the ladder (2.2), graded as a plan line instead of a corner call. |
| 2.3 worn guard, 2.4 the drain, 2.5 after the settle | KEPT, firing with the line (2.3). |
| 2.4 "High, then Loose" against a heavy presser over 6 rounds (ROPE: -4.5, FAIL) | REPLACED by two lines: High WHEN loading up + Loose WHEN tiring. The switch is the plan's, not a button's. |
| 3 point 6 "the round row carries Hands" on the plan page | CUT with the setting. The plan carries guard lines instead. |
| 3 points 2, 5, 7, 8, 9 (heavy hands, the week's links, "Through the guard" aim, the referee's gauge, fixes) | NOT IN V7'S PROBE. They stand as v6 wrote them and wait for their own probe; none is needed for the guard line. |
| Section 5 rows "HANDS" on the corner bar, shout bar, plan round rows | CUT. Replaced by section 5 here. |

## 5. Every menu the mechanic appears on
| Menu | Shows | Wired to | Status |
|---|---|---|---|
| Game plan chart, an IF's answers | Hands High / Hands Loose rows: fit word, your boxer's grade (a range until known), "takes a plan line" | `HandsLine.fit`, `points`; `PlanChart._answers` 354 | TO BUILD (PlanChart.gd is at 500 lines: the rows go in `PlanChartShapes.gd` or a new `PlanChartHands.gd`) |
| Game plan chart, the diamond | "IF the opponent loads up -> Hands High" drawn like a move answer, a glove icon | `PlanChart._answer` 315 | TO BUILD |
| Game plan chart, the checks | "Two guard lines for one moment"; "N lines - this coach can hold M" | `PlanBoard.validate` 31-32, 56-67 | CODE TODAY for the limit; the guard check TO BUILD |
| Game plan chart, the plan's worth | guard lines in the worth against the opponent's main game | `PlanLines.strength` 132 | TO BUILD |
| Fight prep, WHAT YOUR PLAN SHOULD ANSWER | filed claims with "put a line on it"; a loading-up or fading claim offers the guard line | `FilmNight.prep_rows` 89-90, `rows_of` 94-103 | CODE TODAY for moves; guard TO BUILD |
| Opponent file | the games by how often (often / some / rare) | `ModeTells.band` 27 | CODE TODAY |
| 3D fight / fight night, the corner's eye | the line of this exchange and what became of it; a fired guard line reads "Hands High: worked" | `PlanRecord.line_state` 124-131 | TO BUILD for guard |
| 3D fight HUD, guard arc | fill, hover | V6 section 5 | CODE TODAY (V6) |
| Shout bar, the eight calls | "Hands up" = High for 30 s, "Let your hands go" = Loose for 30 s, said on the hover | `Exchanges.CALLS` 79-84 | TO BUILD (the words) |
| Corner minute, ONE CHANGE | add / swap / drop a guard line, with the coach's read of the last three exchanges | `PlanFight.corner_options` 194-216 | TO BUILD for guard |
| Result page, the plan lit up | each guard line: fired N, won M | `PlanFight.tally` 165-179, `FightFlow.lit` | TO BUILD for guard |
| The Why | one row a moment and the NEXT line ("Plan it for another moment.") | `FightWhy.read` 26-60, `PlanRecord.WHY_ANSWER` 21-23 | TO BUILD for guard |
| Playbook, the lines' record | works / fails / too early for each guard line | `PlanRecord.rates` 79, `verdict` 108 | TO BUILD for guard |
| Training tab | "Hands High: OK (Defence 58, Composure 55)" beside the move grades | `LineGrade.words` 179-190 | TO BUILD for guard |
The 3D fight shows the settled round; the hands' height on screen is FIGHTPLAYER2's work (METHOD line). No layer in `scripts/fight3d`.

## 6. The probe (GUARDPROBE7, `tools/guardprobe7.gd` -> `docs/GUARDPROBE7_RESULT.md`)
- Probe 6's population, seeds and walk of the bout, copied in as they stood for the v6 result (self-contained:
  `tools/guardprobe6.gd` is untracked on main and another session is editing it): 3 boxers of ours, 4 opponent types x 3 generated opponents, amateur 3 / pro 4 /
  pro 6 rounds, 200 bouts a cell, seeds 6000-6199, the same seeds for every arm. Never two identical fighters.
- Arms: CONTROL (today's game), NORMAL (no guard line), **RIGHT** (High WHEN loading up, Loose WHEN tiring, High WHEN
  your boxer is hurt: the corner's sentence of the brief plus "cover when hurt"; three lines = what a rating-60 coach has
  free beside a four-move plan), **WRONG** (High WHEN at range, High WHEN tiring, Loose WHEN loading up), **NOISY**
  (RIGHT read right 70 times in 100, 2.4), FULL (all seven plus rows), RIGHT0 (the table zeroed: the instrument's
  control), and five single lines.
- The sizes were NOT picked on the test's seeds: a ladder of three steps (the four big plus rows at 9/9/8/8, 12/12/10/11,
  15/15/12/14) is run first on seeds 9000-9099 and the smallest step with RIGHT 5+ up in 9 of 12 cells is taken.
- Bars: RIGHT beats NORMAL by 5+ wins in 100 in 8 of 12 cells; WRONG loses 5+ in 8 of 12; NOISY beats NORMAL in 6+ of
  12; no single line best in more than 7 of 12 cells.
- Not measured: the shouts as High / Loose (2.1), the read share's own formula (two points of it only), the corner
  minute's guard change, a line-limit trade against a move line (RIGHT's three lines are ADDED to the four-move plans),
  12-round bouts (the game has none).

### 6.1 Result
`RESULT: tools/guardprobe7.gd -> sizes=s1 right=PASS(10/12) wrong=PASS(11/12) noisy=PASS(12/12) single=PASS(7/12) -> PASS`
(run of 1,989 s on 2026-11-21, through `godot_slot.py`.)
- Self-checks: the probe's walk with every guard size off = `BoutNight.play_out` in 120 of 120 bouts; the copied guard
  walk differs from the game's by 0.000000; NORMAL's twelve win rates and its exchange counts are the same as probe 6's
  NORMAL column to the decimal (54.5, 61.0, 37.5, 53.0, 19.0, 29.0, 16.5, 31.0, 44.5, 55.0, 24.0, 49.0).
- The ladder (seeds 9000-9099, 100 bouts a cell): s1 9 of 12 cells (mean +7.4), s2 10 (+10.0), s3 12 (+12.1). s1 taken.
| Cell | no line | RIGHT | WRONG | NOISY (70) | FULL (7 lines) | RIGHT lines fired a bout |
|---|---|---|---|---|---|---|
| amateur 3, light presser | 54.5 | **+10.0** | -8.0 | +7.5 | +13.0 | 5.8 |
| amateur 3, heavy presser | 61.0 | **+7.0** | -8.5 | +4.5 | +10.5 | 6.9 |
| amateur 3, counter-puncher | 37.5 | **+6.5** | -9.0 | +3.5 | +9.0 | 5.2 |
| amateur 3, volume puncher | 53.0 | **+8.0** | -12.5 | +4.0 | +12.5 | 3.6 |
| pro 4, light presser | 19.0 | **+6.5** | -5.0 | +4.5 | +12.5 | 5.1 |
| pro 4, heavy presser | 29.0 | **+7.0** | -4.5 | +6.0 | +13.0 | 6.7 |
| pro 4, counter-puncher | 16.5 | +3.5 | -5.5 | +1.5 | +9.0 | 4.4 |
| pro 4, volume puncher | 31.0 | +2.0 | -6.5 | +1.5 | +13.0 | 3.1 |
| pro 6, light presser | 44.5 | **+11.0** | -8.0 | +5.0 | +19.5 | 9.2 |
| pro 6, heavy presser | 55.0 | **+9.5** | -8.0 | +6.5 | +20.0 | 9.4 |
| pro 6, counter-puncher | 24.0 | **+7.0** | -8.5 | +4.5 | +14.5 | 7.5 |
| pro 6, volume puncher | 49.0 | **+6.0** | -12.5 | +3.5 | +10.5 | 5.9 |
(Wins in 100 bouts; the arms' columns are the difference to "no line". One win rate is +/- 3.5 at 200 bouts; the arms share seeds.)
- One exchange, all cells pooled: High WHEN loading up wins 11.5 more in 100 (48.5 -> 60.1), Loose WHEN tiring 11.4 more
  (52.4 -> 63.8), High WHEN your boxer is hurt 12.0 more (36.5 -> 48.5). Wrong: Loose WHEN loading up -11.8, High WHEN at
  range -9.8, High WHEN tiring -13.0. The moments with no line do not move (within 1). DERIVED said +13 / -11 to -14: it holds.
- The instrument can read worse: the table zeroed (RIGHT0) reaches +5 in 0 of 12 cells. NORMAL against today's game: 1.5 apart at worst.
- What the result does NOT show, said plainly:
  1. Two cells miss the +5 (pro 4 rounds against the counter-puncher +3.5 and the volume puncher +2.0): there the three
     lines fire only 3 to 4 times a bout. Against those two the right plan is other lines (FULL: +9.0 and +13.0).
  2. FULL (all seven plus rows) is 9 to 20 wins up: with a top coach's line count the guard would be the strongest single
     system in the plan. The line limit is what keeps it a choice, and the probe did not measure the trade (lines were ADDED).
     Before the build: a probe arm where each guard line REPLACES one of the plan's four move lines.
  3. Bar 4 passes at exactly 7 of 12, with ties counted for both lines, on differences the size of the noise.
  4. The result table's last column "a line fired in 100" is NOISY's (77 in its own moments, 12 to 14 elsewhere = the misreads).

## 7. Rulings kept
- Mechanics need 8 on DEPTH and 8 on PLAY, probe first (owner S534): this map goes to two fresh critics only now that probe 7 has passed (one code-checked), with this page and the result page; the open risk they must judge is 6.1 point 2.
- The 3D fight never decides: the line's points are in the sum before `Exchanges.settle` (`LiveRound.gd` 287).
- Names only in headers: every new string says "your boxer" / "the opponent" (`Exchanges.roles` 107-121).
- Only actionable information: each new line names what to do about it (the Why's "Plan it for another moment").
- New features ship ON; plain `--script` tests stay the control arm.
- Build order when approved: `HandsLine.gd` + unit test (pure: a cloud seat), `PlanBoard.hands_for` and the validate
  check (every reader of `arrow["move"]` must skip a guard line: `PlanBoard.pick` 77, `validate` 37, `coverage` 110,
  `PlanLines.lines`, `FightFlow.build`), the LiveRound line, then section 5's screens; one golden-path test writes a
  guard line, plays a round and reads the Why's row. Regression: `tests/golden_path_test.gd`, `tests/guard_wear_test.gd`.

## 8. Code files opened (this session)
Whole: `scripts/rules/Exchanges.gd`, `LineGrade.gd`, `PlanFight.gd`, `scripts/state/LiveRound.gd`, `tools/guardprobe6.gd`.
In part: `scripts/rules/PlanBoard.gd` (1-113), `FightFlow.gd` (1-38), `PlanLines.gd` (1-36, 150-158), `StyleName.gd` (1-14,
86-118), `PlanRecord.gd` (1-32, 120-150), `FireLevel.gd` (1-60), `BoutRules.gd` (370-392), `CoachPlan.gd` (1-36),
`scripts/state/FilmNight.gd` (1-30, 84-125), `LivePreview.gd` (1-60), `scripts/ui/PlanChart.gd` (1-22), `tools/guard_probe.gd`
(24-56). By outline only (function and constant lines): `ModeTells.gd`, `Knowledge.gd`, `FightWhy.gd` (and 26-60),
`PlanChart.gd`, `Attrs.gd`. Not opened: `GuardState.gd`, `GuardWear.gd`, `RingDuel.gd`, `StepWire.gd` (their claims are tagged V6).
Results read whole: `docs/GUARDPROBE6_RESULT.md`. The v6 map read whole; its critics' pages were not re-read.
