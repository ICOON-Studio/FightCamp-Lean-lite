# DESIGN PLANIMPACT1 - three levers that could make the written fight plan matter (S548)

Written and committed BEFORE any run (task ops/research/TASK_PLANIMPACT1.md). Probe only: every rule below lives in
`tools/planimpact1_rules.gd` behind a switch; nothing under scripts/ or tests/ changes. No constant here is tuned after a run.

## What the code does today (read first, cited)

- **Which line fires (lever 1).** `LiveRound.exchange` (scripts/state/LiveRound.gd l.231-235) calls `PlanFight.choose(plan_now, at,
  moves, sit)` -> `PlanBoard.pick` (scripts/rules/PlanBoard.gd l.74-87): on the card she stands on (`at`) a `when` line for this
  situation wins, else the card's any-time line, else her instinct. `PlanBoard.validate` (l.27-66) refuses two lines on one place
  (card + when: "Two arrows from mid - pick one"). So **today a situation on a card has exactly one planned answer and she never
  alternates**. Two lines meet the same moment only from two different cards (a lost exchange moves her, `PlanFight.where_next`),
  and those are already counted apart by the counter (`ComboCounter.throw` counts by move id, l.95-112). Nothing of lever 1 is
  true today.
- **The counter.** `ComboCounter` (S540): a plan line thrown READ_AT = 2 times (1 against rating 65+) is read; each further throw
  is countered with chance 0.35 (x1.75 = 0.61 against a Counter-puncher): the exchange is lost. Counts fade by 1 at each bell.
- **The corner's commands (lever 2).** The eight commands are a greybox (`tools/cornercmd2_rules.gd` CMD, l.40-58); nothing in
  scripts/ has them. Each command is carried out at her grade (`cgrade`: Poor / OK / Good from the mean of two of her values;
  GRADES2 mult Good 1.25, OK 0.6 rising to 1.25 over the spread, Poor 0.25; a wrong moment costs x COMMIT2 Good 1.5 / OK 1 /
  Poor 1). The plan plays no part in it.
- **When the corner may speak (lever 3).** In the game a round opens by fighting its first 30 s on the plan
  (`BoutNight._open` l.207 `_shout(c, f, m, "")`); round 1 opens on call "" (`fight_step("start")`, l.77). From the second
  exchange of round 1 the shout bar takes calls (`LiveRound.exchange` reads `shout` every exchange; `CornerBar._shout`). The
  CORNERBASE1 reader (`R.decide`) commands from round 1 exchange 2. So **today the live corner already coaches five of round 1's
  six exchanges**: lever 3 is not true today.

## Lever 1 - VARIETY BEATS THE COUNTER

Study it follows: REPEATBITE1/COMBOCOUNTER1 (docs/REPEATBITE1_RESULT.md - a spread plan read in 17 bouts of 100, a spammed one in
34) and the brief's boxing reason: a counter-puncher times what he has seen twice; a camp gives two looks for the same moment.

**Rule.** A place (card + when) may hold TWO lines. When she stands on that place and the plan fires there, she throws the one
the opponent has counted fewer times (`bout["cc"]`, the bell fade included); on a tie, the one written first. The counter counts
each line on its own, exactly as today. A second line costs one line of the coach's limit (6 with the gym's coach): the line limit
does not change. **Half strength (the slope):** she alternates only on every second time the place fires (her own dice, a probe
stream that touches no ring roll); otherwise she throws the first line.

Wiring in the probe: the full plan (with twins) is held by the probe; before every exchange (and before each round's opening
exchange, on the bell-faded counts) the probe writes onto `bout["arrows"]` the plan with ONE line per place, the chosen twin. The
ring is the game's, unchanged. With no twin in a plan the filter is the identity, so every arm without twins is the game.

**Arms (PLANWORTH1's harness: ten types, 30 files a type, 30 paired dice k = 0..29, debut 4 rounds, gym's coach 58):**
- A (no plan), B58 (coach's plan), C (PLANWORTH1's style plan, frozen `E:/FightCamp/tmp/planread2/plans.json`), D (PLANWORTH1's
  one line: C2's first), E (careless): reused from PLANWORTH1 bout for bout IF the control reproduces them (else re-played).
- V = C re-chosen with second answers: one greedy step on bouts from C, over (a) C plus one twin of any of C's places (any
  throwable any-time move on the same card, `PlanLines.options(place, "")` with no "why"), when C is under the limit, and (b) C
  with its last-chosen line (the greedy's weakest) replaced by one twin. Chosen on SEPARATE dice (k = 1000..1019, 3 of the 5
  files of the cell), kept only if it beats C there; else V = C. Then played on the evaluation dice.
- V-half = V at half strength. C-off = C with `ComboCounter.on = false` (the ceiling: no counter at all). V-off = V, counter off.
- Countered share per arm is printed (countered exchanges / plan exchanges). If V's reaches 0, stop: the lever is C-off in disguise.

The cost shows: (b) spends a line; (a) spends a spare slot a later line could have used (the 6-line limit).

## Lever 2 - THE PLAN IS WHAT SHE DRILLED: IT SHARPENS THE CORNER

Study it follows: `ops/research/J55_THE_CORNER_BETWEEN_ROUNDS.md` (one or two things to act on; health, breath, then the work-on) and
John's CORNERREAL1 (`ops/research/CORNERREAL1_JOHN_JOHN.md` if on disk; CORNERBASE1 found only its brief) - a boxer acts on what
camp rehearsed.

**Rule.** A live corner command is PREPARED when the written plan (as fought, the bout's arrows at the first bell) holds a line
that is a `best` answer (`PlanFight.ANSWERS`) in one of the command's own best moments (`CMD[c]["best"]`). A prepared command is
carried out one grade higher: Poor -> OK (mult 0.6), OK -> Good (mult 1.25), Good stays Good. Its commit on a wrong moment
follows the new word (Good commits harder: x1.5 - she does what she drilled, fully). An unprepared command: her own grade, as
today. The reader sees the raised grades (the corner bar would show them), so the plan also changes which command he picks.
"The same call" adds nothing: a plan line is a move, not a call. **Half strength:** mult halfway between the old and the raised
grade's, commit of the old word.

The mapping (moment -> the card it is fought on, `PlanFight.GAME_CARD`):

| Command | its best moment(s) | plan lines that prepare it (fit rule) | narrowed (the line is thrown from that moment's card) |
|---|---|---|---|
| Go to the body | range (long) | step_in, 1-1-2, 2-3, 1-2-3b, 3b-3, cut_off, 1-2 | 2-3, 1-2-3b, cut_off, 1-2 |
| Change levels | counter (outside) | feint, 1-1, 1-1-2 | feint, 1-1-2 |
| Let your hands go | tiring (inside) | 1-2-3-2, 1-2-3, 3b-3, cut_off, herd | 3b-3@inside |
| Be first | loadup (mid) | slip 2-3, roll_out, step_back, 1-1, tie_up | slip 2-3, step_back |
| Sit down on your shots | tiring (inside) | as Let your hands go | 3b-3@inside |
| Hands up | loadup (mid) | as Be first | slip 2-3, step_back |
| Reset | she_tired (inside), she_hurt (own_ropes) | tie_up, step_back, step_out, 1-1, pivot_out, roll_out | tie_up, roll_out (inside); pivot_out, tie_up@own_ropes (own_ropes) |
| Get out of there | press (mid) | step_back, pivot_out, slip 2-3, roll_out, 1-1 | step_back, slip 2-3 |

(A move id with "@card" answers as its base, `PlanFight.base_id`. A `when` line for the moment always prepares.)
**Feedback guard:** if over 80% of the reader's commands are raised under the C plan in the one-rep trial, the fit rule is too wide
(any jab-and-step plan prepares everything) and the NARROWED column replaces it once, before the full run. Reason, written now:
"drilled for that moment" means drilled on the card the moment is fought on, not any move that would also answer it somewhere.

**Arms (CORNERBASE1's harness: five women Lucy, Samira, Tess, Cara (raw, week 0), Jade (all-round, week 80); its ten cells; 3 and
6 rounds; paired dice day 70000 + 7k; the reader = `reader_nr`):**
plans P in {none (no coach writes: plan-writer rating `Sim.NO_COACH_RATING`), coach (empty board, coach 58 writes - CORNERBASE1's
own setup), C (the style plan: plans.json for Lucy / Samira / Tess, the same read-greedy chooser for Cara and Jade), K (the
corner plan, below), E (careless, PLANWORTH1's rule), D (K's first line alone)};
corners: FILE58 (`skill58`, untouched by the lever - its calls are the game's calls, not commands) and READER, each with the lever
off and on; READER half strength on C. The corner's tactics stay 58 in every arm.
**The corner plan K** (a plan written FOR the corner): for the cell's style, the reader's command in each moment
(`R.best_for` at her own grades) weighted by `Exchanges.STYLE_MODES[style]` (+ she_tired and she_hurt at 0.1 each); commands in
order of weight; for each, the highest-mastery throwable line that prepares it (one line a place, a moment's own card first), until
the limit; no filler line.

## Lever 3 - ROUND ONE BELONGS TO THE PLAN

Study: J55 (the corner speaks between rounds; round one is the camp's) and the brief.
**Rule.** No live corner command in round 1: the reader says nothing in round 1 (the round opens on the same call as today's arm,
`BoutRules.auto_corner`); his first command is set at the round-1 corner (the corner step opens round 2 on it), as in every later
round. The FILE coach is unchanged (his round-1 call is given on the stool before the bell, which the rule allows).
Strength: whole round 1. **Half strength:** the reader holds only round 1's first three exchanges (speaks from exchange 4).
**Arms (CORNERBASE1's harness):** READER with and without the rule (and half), crossed with plan none / C; FILE58 with none / C.

## Combined

The levers that pass alone, together, on the harness each needs (lever 1 + 2 on CORNERBASE1's harness with V plans for the five
boxers; V for Cara and Jade chosen by the same one-step greedy on PLANWORTH1's harness).

## Bars (from the task, written before any run; real bouts, wins in 100, +-2 SE; per type and over all)

1. THE PLAN PAYS: the best written plan beats the coach's (B58) by 6+, in 6 of 10 types. Lever 1: the plan with second answers, V
   (it is C where no twin helped). V - B58 >= 6 in 6 of 10
   types. Lever 2 (five boxers): max(C, K) - coach >= 6 under READER + lever, in 3 of 5 boxers (the same 60%), per length.
2. THE CORNER STILL PAYS: lever on, READER - FILE58 (same plan) >= 6 over all five boxers (CORNERBASE1 table (a): +9.8 / +10.7).
   Measured with the best plan of the lever (V for lever 1, K or C for lever 2 - the one bar 1 used, C for lever 3).
3. NOT ONE PLAN: each type's six style plans (V, lever 1; K, lever 2) cross-played against the six styles: no single plan is the
   best (highest wins) in more than 3 of the 6 style cells of a type, for 6 of 10 types (lever 2: 3 of 5).
4. A CARELESS PLAN COSTS: E - B58 <= -3 over all types (lever 1: PLANWORTH1's E; lever 2: E - coach under READER + lever).
5. NO TRAP: one sensible line alone is never more than 2 under the coach's plan over all, and in no type by more than 2 beyond
   its 2 SE (lever 1: D; lever 2: D = K's first line).
6. THE CHOICE IS A TRADE (lever 1): pooled over the ten types per opponent style, V - C > 0 in 2+ styles AND C - V > 0 in 2+ styles.
   Also counted per type x style. (For lever 2 the same test on K v C is reported, not barred.)
7. THE CARD CAN SAY IT: for each passing lever, the read lines that would have to follow (`PlanReadFit.gd`, `BoutRead.gd`) and
   whether `tests/plan_read_fit_test.gd` would go red. Not built.
A lever that passes 1 and fails 2 is a FAIL.

## Stops

- CONTROL FIRST: every lever off, types 0 (Lucy Jackson) and 5 (Danny Osei), all 30 files, arms A, B58, C, 30 dice: the outcome
  strings must equal PLANWORTH1's (`full_a.jsonl` / `b58_a.jsonl` for Lucy, `full_b.jsonl` for Danny) bout for bout. If not,
  find the commit that moved the ring and say so; the old strings are then not reused (every arm re-played).
  CORNERBASE1's harness control: lever off, reader_nr and skill58, Lucy and Samira, presser, 3 rounds, 70 bouts = its `full_L3`.
- ONE-REP TRIAL before every full run: two types x two styles (lever 1) / two boxers x two cells (levers 2, 3), 40 paired bouts an
  arm, all arms. Stop if two arms print identical outcome strings where the rule should differ (an arm not wired), or if the
  control does not match.
- One Godot process at a time through `ops/Tools/godot_slot.py`, slices of 20 minutes or less, watchdog before each.

## Feedback loops

- Lever 1: variety -> fewer countered exchanges -> more won exchanges -> her card moves -> other situations -> other lines fire.
  Capped by the counter's chance (0.35 / 0.61) and the line limit (6). Countered share printed per arm; 0 = stop.
- Lever 2: plan -> grade -> the reader's calls win more; nothing feeds back into the plan inside a bout (fixed at the first bell).
  One grade is the cap; share of raised commands printed; > 80% under C = narrow once (above).
- Lever 3: none inside a bout (it removes calls).
- The card's read follows the plan (`BoutRead`): not touched; named in bar 7.
