# DESIGN PLANIMPACT2 - the plan sharpens the corner only where it was drilled for THIS opponent (S550)

Written and committed BEFORE any bout run (task `ops/research/TASK_PLANIMPACT2.md`). Probe only: the rule lives in
`tools/planimpact2_rules.gd` behind one switch (STRENGTH); `tools/planimpact2_probe.gd` extends PLANIMPACT1's probe; nothing
under scripts/ or tests/ changes. No constant is tuned after a run. The paper count below was printed by the probe's `paper`
stage (no bouts; `E:/FightCamp/tmp/planimpact2/paper.jsonl`), not counted by hand.

## METHOD followed
- MECHANICS NEED 8, PROBE FIRST: one rule, greybox only.
- Code read first (below). CONTROL FIRST: with STRENGTH 0 the probe must reproduce PLANIMPACT1's lever-off CB arms
  (`E:/FightCamp/tmp/planimpact1/cb_L3a/b`, `cb_L6a-d`) bout for bout: reader:none, reader:coach, reader:C, reader:E, file:none,
  file:coach, file:C, reader:K (PLANIMPACT1's K, narrowed).
- THE WRITTEN PLAN STAYS: nothing here proposes shrinking it.
- NO BALANCING NUMBER: the rule at full strength (one grade, PLANIMPACT1's raise) plus a half-strength arm.
- NOT IDENTICAL FIGHTERS: CORNERBASE1/PLANIMPACT1's five women (Lucy Jackson, Samira Khan, Tess Reilly from the ten TELLPLAY1
  types at week 4; Cara Bello raw week 0; Jade Yates all-round week 80), each with her stats printed in the run's first line,
  against CORNERCMD2's ten opponent cells. The paper count also covers PLANIMPACT1's ten types. The corner lives only in the CB
  harness, so the bouts are the five women: "6 of 10 types" reads as **3 of 5 boxers** (PLANIMPACT1's reading).

## What the code does (read first)
- `CoachPlan.cards(style)` (scripts/rules/CoachPlan.gd l.38-56): for each card the style's games land on
  (`PlanFight.GAME_CARD`, plus `LOST_CARD` press/loadup -> own_ropes at ROPES_SHARE 0.5), the game brought there most, cards
  ordered by weight (`Exchanges.STYLE_MODES`).
- Corner commands: `tools/cornercmd2_rules.gd` CMD (l.40-58), FIGHT order body, levels, let_go, first, sit, hands, reset, get_out;
  carried out at her grade (`cgrade`, GRADE2 Good 1.25 / OK 0.6 / Poor 0.25; COMMIT2 on a wrong moment).
- PLANIMPACT1's lever 2 (`tools/planimpact1_rules.gd` prepared l.66, raise l.83): a command is prepared by any best answer to
  one of its moments (narrowed: thrown from that moment's GAME_CARD) - the opponent's style plays no part. That is why the
  careless plan got the bonus.
- The careless plan (`planimpact1_rules.gd` careless, PLANWORTH1's rule): her highest-mastery throwable lines, one a card,
  skipping any line that is a best answer to `cards(style)`'s game on its card.

## The rule
**A live corner command is PREPARED only by a plan line that answers that moment on the card where THIS opponent's style
fights it.** Exactly: the line is thrown from card c; [c, g] is in `CoachPlan.cards(opponent style)`; g is one of the command's
best moments (CMD.best); the line is a best answer to g (`PlanFight.fit`), or a "when g" line on c that is not wrong. A prepared
command is carried out one grade higher (Poor -> OK -> Good; Good commits x1.5 on a wrong moment, she does what she drilled);
every other command at her own grade, as today. The reader sees the raised grades (as in PLANIMPACT1). **Half strength:** the
multiplier half way, the old word. The plan is fixed at the first bell; the coach's plan (empty board) is the one he writes then.
Boxing reason: a camp drills for the man you are going to meet, not for every fight.

## Paper count (from the code, before any run)

### The six styles' cards (`CoachPlan.cards`) and the lines that prepare each command
- **Pressure fighter**: mid / press, own_ropes / press, outside / counter, long / range.
- **Counter-puncher**: outside / counter, long / range, mid / press, own_ropes / press.
- **Volume puncher**: mid / press, long / range, own_ropes / press, outside / counter.
- **Boxer-puncher**: mid / loadup, long / range, own_ropes / loadup, outside / counter.
- **Out-boxer**: long / range, outside / counter, mid / loadup, own_ropes / loadup.
- **Slugger**: mid / loadup, own_ropes / loadup, outside / counter, long / range.

| Command | prepared against Pressure / Counter-puncher / Volume (mid and own_ropes = press) | against Boxer-puncher / Out-boxer / Slugger (mid and own_ropes = loadup) |
|---|---|---|
| Go to the body | long/range: 1-2, 2-3, 1-2-3b, cut_off | same |
| Change levels | outside/counter: 1-1-2, feint | same |
| Get out of there | mid/press: slip 2-3, step_back; own_ropes/press: pivot_out, slip 2-3@own_ropes | never |
| Be first | never | mid/loadup: slip 2-3, step_back; own_ropes/loadup: tie_up@own_ropes, slip 2-3@own_ropes |
| Hands up | never | as Be first |
| Let your hands go | never (tiring is fought on inside; no style's cards include inside) | never |
| Sit down on your shots | never (same) | never |
| Reset | never (she_tired inside, she_hurt own_ropes: never a style's top game there) | never |

(Only lines her StrikeMap card offers: e.g. 1-1 is a best answer to press and loadup but is thrown from long/outside, not mid.)

### How many lines prepare anything, per opponent style (72 cells: 12 boxers x 6 styles)
C = the best written plan (PLANWORTH1's frozen style plan; the read greedy for Cara and Jade); E = careless; coach = the coach
58's plan as fought; K2 = the plan written FOR the corner under this rule (`planimpact2_rules.gd` corner_plan); D2 = K2's first line.

| Opponent style | C | E (careless) | coach | K2 | D2 |
|---|---|---|---|---|---|
| Pressure fighter | 20 of 48 lines, 1.3 cmds | 0 of 66 lines, 0.0 cmds | 12 of 12 lines, 1.0 cmds | 17 of 17 lines, 1.4 cmds | 12 of 12 lines, 1.0 cmds |
| Counter-puncher | 20 of 47 lines, 1.3 cmds | 0 of 66 lines, 0.0 cmds | 12 of 12 lines, 1.0 cmds | 17 of 17 lines, 1.4 cmds | 12 of 12 lines, 1.0 cmds |
| Volume puncher | 19 of 48 lines, 1.3 cmds | 0 of 66 lines, 0.0 cmds | 12 of 12 lines, 1.0 cmds | 17 of 17 lines, 1.4 cmds | 12 of 12 lines, 1.0 cmds |
| Boxer-puncher | 14 of 47 lines, 1.3 cmds | 0 of 72 lines, 0.0 cmds | 12 of 12 lines, 1.5 cmds | 22 of 22 lines, 2.8 cmds | 12 of 12 lines, 1.3 cmds |
| Out-boxer | 19 of 48 lines, 1.9 cmds | 0 of 72 lines, 0.0 cmds | 12 of 12 lines, 1.0 cmds | 22 of 22 lines, 2.8 cmds | 12 of 12 lines, 1.3 cmds |
| Slugger | 14 of 46 lines, 1.3 cmds | 0 of 72 lines, 0.0 cmds | 11 of 12 lines, 1.8 cmds | 22 of 22 lines, 2.8 cmds | 12 of 12 lines, 1.9 cmds |

Over all (after the trial amendment below): **C 106 of 284 lines prepare 103 commands; E 0 of 414 lines prepare 0**; coach 71 of
72 lines, 88 commands; K2 117 of 117 lines, 150 commands; D2 72 lines, 89 commands. (Before the amendment: C 155 of 284 / 152;
coach 72 / 90; K2 174 / 210 - lines she cannot throw were counted.)

### The five women's plans (what each prepares against the style it was written for)
| Boxer | Style | C -> prepared | K2 -> prepared | coach -> prepared | E |
|---|---|---|---|---|---|
| Lucy Jackson | Pressure fighter | tie_up, 1-1, step_back, pivot_out, 1-1-2 -> get_out, levels | step_back -> get_out | step_back -> get_out | 0 of 5 |
| Lucy Jackson | Counter-puncher | 1-1, tie_up, step_back, 1-1-2, pivot_out -> get_out, levels | step_back -> get_out | 1-1-2 -> levels | 0 of 5 |
| Lucy Jackson | Volume puncher | 1-1, tie_up, step_back, pivot_out, 1-1-2 -> get_out, levels | step_back -> get_out | step_back -> get_out | 0 of 5 |
| Lucy Jackson | Boxer-puncher | 1-1, tie_up, step_back, pivot_out, 1-1-2 -> first, hands, levels | step_back -> first, hands | step_back -> first, hands | 0 of 6 |
| Lucy Jackson | Out-boxer | 1-2, tie_up, step_back, 1-1-2, pivot_out -> body, first, hands, levels | step_back -> first, hands | 1-2 -> body | 0 of 6 |
| Lucy Jackson | Slugger | tie_up, 1-1, step_back, pivot_out, 1-1-2 -> first, hands, levels | step_back -> first, hands | step_back -> first, hands | 0 of 6 |
| Samira Khan | Pressure fighter | tie_up, 1-2, pivot_out, step_back -> body | 2-3 -> body | 1-2 -> body | 0 of 6 |
| Samira Khan | Counter-puncher | tie_up, 1-2, step_back, pivot_out -> body | 2-3 -> body | 1-2 -> body | 0 of 6 |
| Samira Khan | Volume puncher | tie_up, 1-2, step_back, pivot_out -> body | 2-3 -> body | 1-2 -> body | 0 of 6 |
| Samira Khan | Boxer-puncher | tie_up, 1-2, step_back, pivot_out -> body | 2-3, tie_up@own_ropes -> body, first, hands | 1-2 -> body | 0 of 6 |
| Samira Khan | Out-boxer | tie_up, 1-2, step_back, pivot_out -> body | 2-3, tie_up@own_ropes -> body, first, hands | 1-2 -> body | 0 of 6 |
| Samira Khan | Slugger | tie_up, pivot_out, 1-2, step_back -> body | tie_up@own_ropes, 2-3 -> first, hands, body | tie_up@own_ropes -> first, hands | 0 of 6 |
| Tess Reilly | Pressure fighter | tie_up, 1-2, step_back, pivot_out -> body | cut_off -> body | 1-2 -> body | 0 of 6 |
| Tess Reilly | Counter-puncher | tie_up, 1-2, step_back, pivot_out -> body | cut_off -> body | 1-2 -> body | 0 of 6 |
| Tess Reilly | Volume puncher | tie_up, 1-2, step_back, pivot_out -> body | cut_off -> body | 1-2 -> body | 0 of 6 |
| Tess Reilly | Boxer-puncher | tie_up, 1-2, step_back, pivot_out -> body | cut_off, tie_up@own_ropes -> body, first, hands | 1-2 -> body | 0 of 6 |
| Tess Reilly | Out-boxer | tie_up, 1-2, step_back, pivot_out -> body | cut_off, tie_up@own_ropes -> body, first, hands | 1-2 -> body | 0 of 6 |
| Tess Reilly | Slugger | tie_up, pivot_out, 1-2, step_back -> body | tie_up@own_ropes, cut_off -> first, hands, body | tie_up@own_ropes -> first, hands | 0 of 6 |
| Cara Bello | Pressure fighter | 1-1, step_back, pivot_out, feint, roll_out -> get_out, levels | step_back, 1-2 -> get_out, body | step_back -> get_out | 0 of 5 |
| Cara Bello | Counter-puncher | step_back, 1-1-2, pivot_out -> get_out, levels | step_back, 1-2 -> get_out, body | 1-1-2 -> levels | 0 of 5 |
| Cara Bello | Volume puncher | 1-1, pivot_out, 1-1-2 -> get_out, levels | step_back, 1-2 -> get_out, body | step_back -> get_out | 0 of 5 |
| Cara Bello | Boxer-puncher | 1-1, pivot_out, 1-1-2 -> levels | 1-2, step_back -> body, first, hands | step_back -> first, hands | 0 of 6 |
| Cara Bello | Out-boxer | step_back, 1-1-2, pivot_out -> first, hands, levels | 1-2, step_back -> body, first, hands | 1-2 -> body | 0 of 6 |
| Cara Bello | Slugger | 1-1, pivot_out, 1-1-2 -> levels | step_back, 1-2 -> first, hands, body | step_back -> first, hands | 0 of 6 |
| Jade Yates | Pressure fighter | 1-2, pivot_out -> body | cut_off -> body | 1-2 -> body | 0 of 6 |
| Jade Yates | Counter-puncher | 1-2-3b, 3b-3, tie_up@own_ropes -> body | cut_off -> body | 1-2 -> body | 0 of 6 |
| Jade Yates | Volume puncher | 1-2, 3b-3, pivot_out, feint -> body | cut_off -> body | 1-2 -> body | 0 of 6 |
| Jade Yates | Boxer-puncher | 1-2, feint, pivot_out -> body | cut_off, tie_up@own_ropes -> body, first, hands | 1-2 -> body | 0 of 6 |
| Jade Yates | Out-boxer | cut_off, 3b-3@inside, 1-2@opp_ropes, pivot_out -> body | cut_off, tie_up@own_ropes -> body, first, hands | 1-2 -> body | 0 of 6 |
| Jade Yates | Slugger | 1-2, pivot_out -> body | tie_up@own_ropes, cut_off -> first, hands, body | tie_up@own_ropes -> first, hands | 0 of 6 |

### What the paper says before the run
1. **Bar 1 gate: the careless plan prepares 0% of what the best plan prepares** (the bar's stop was "more than a fifth"). By
   construction: the careless rule skips exactly the lines this rule rewards. Bar 1 is not ruled out; the run goes ahead.
   E with the rule on must equal E with it off bout for bout (an identity, not a wiring fault).
2. **Bar 2 risk (now the main one):** the coach's one line is by definition the best answer on the style's most-fought card,
   so his plan is always prepared (1-2 commands). With the fire test, the best plan C of the five women prepares exactly the
   coach's set in 15 of 30 boxer x style cells (Samira, Tess and Jade: C prepares only Go to the body, as the coach's 1-2 does).
   Bar 2 is likely to fail for C; K2 adds Be first / Hands up against loadup styles only.
3. **Bar 4 risk (one plan for all):** all six styles fight on the same four cards; long is always range and outside always
   counter; mid and own_ropes differ (press or loadup), but step_back and slip 2-3 answer both. A plan written for any style
   prepares nearly the same commands against every style (Samira, Tess, Jade: K2 differs only step_back <-> tie_up@own_ropes;
   Lucy's K2 is step_back alone for all six). Bar 4 is likely to fail for K2 and C.
4. Three of the eight commands (Let your hands go, Sit down, Reset) can never be prepared: the share of the reader's commands
   raised will sit well under PLANIMPACT1's 69-75% for C.
Cross-play is played whether bar 4 or bar 2 looks lost or not (bouts cost about 1 minute per 3,000).

## Amendment after the one-rep trial (taken once, before the full run)
The trial showed Samira's K2/D2 line step_back fired 0 times in 40 bouts (pl = 0): her step bar is under Usable, so the ring
never throws it - yet the rule as first written counted it as preparing Get out of there. A line she cannot throw is not
drilled. **Amendment: a line prepares only if it fires** - the game's own test (`CoachReadWire` l.38, `PlanAuto` l.20): she can
do it (`PlanFight.can_do`), at full rate (`PlanFight.rate` >= 1), and `FireLevel.mastery_of(f, line) >= FireLevel.USABLE_AT` (30).
K2 picks only lines that fire. No number changed; the trial is re-run on the amended rule before the full run.

Re-run trial (Lucy, Samira x presser, loader, 40 dice, 3 rounds; `trial2.jsonl`): control again 160 of 160 identical for every
strength-0 arm. Raised share of the reader's commands: C 24%, K2 30%, coach 29%, D2 29%, E 0% - inside the 10-80% band. Identities
explained, not wiring: E on = E off (prepares nothing, by construction); D2 = coach (D2 is the coach's own line in three of the
four rows; in the fourth, 2-3 v 1-2, no bout of 40 flips); C half = C full (the raised commands are mostly already Good, below).
**Why the rule moves little (from the code, before the full run):** her own grades (`new_state` at the first bell, the paper
stage's "grades" rows) show the commands a firing plan line prepares are mostly ones she already does at Good - Samira and Tess
Go to the body Good 1.25, Lucy Get out of there Good 1.25, Jade Good in 7 of 8. A Good command cannot be raised. The lines she
can throw well and the commands she carries out well read the same skills, so "drilled" adds little where it is allowed.
Trial control (strength 0 v PLANIMPACT1, 160 bouts an arm): reader none / coach / C / E / K and file none / coach / C all
**160 of 160 identical**.

## Arms (CB harness: five women x ten cells x 40 paired dice, day 70000 + 7k, 3 and 6 rounds, reader_nr; file = skill58)
Plans none / coach / C / K2 / E / D2 ("one sensible line alone"). Reader with the rule at 0, 0.5 and 1 (none: 0 only; E: 0 and 1
- its half is the identity). File corner (the rule does not touch it): none, coach, C, K2. Control arms: the 0-strength
none/coach/C/E and file none/coach/C, plus PLANIMPACT1's K at 0, against PLANIMPACT1's strings.
Cross-play (bar 4): each boxer's six C plans and six K2 plans, rule on, against the six style cells (presser, mover, counter,
loader, fader, slow), 3 rounds, 40 dice.

## Bars (the task's, written before any run; wins in 100, +-2 SE paired)
Best plan = max(C, K2) per boxer and length, rule on (PLANIMPACT1's reading). A bar passes only if it passes at 3 AND 6 rounds.
1. CHOOSING WELL PAYS: best - E (both rule on) >= 6 in 3 of 5 boxers.
2. THE PLAN PAYS: best - coach (both rule on) >= 6 in 3 of 5 boxers.
3. THE CORNER IS NOT JUST BUFFED: reader - file over all five, same plan (the family with the higher reader-on total), rule on:
   between +6 and +15. Over +15 = FAIL.
4. NOT ONE PLAN: per boxer, no plan best in more than 3 of the 6 style cells; pass in 3 of 5 boxers (the family bar 3 uses).
   Plans with the same lines count as one plan; a tie credits every tied plan.
5. A CARELESS PLAN COSTS: E - coach (rule on) <= -3 over all.
6. NO TRAP: D2 - coach (rule on) >= -2 over all, and no boxer more than 2 under beyond its 2 SE.
7. THE CARD CAN SAY IT: read lines named, not built.
A rule that passes 2 and fails 1 or 3 is a FAIL.

## Stops and the trial
- One-rep trial before the full run: Lucy and Samira x presser and loader x 40 dice, 3 rounds, every arm. Stop if the control
  arms do not match PLANIMPACT1 bout for bout, or if two arms that should differ print identical strings (E on = E off is
  expected).
- One Godot at a time through `ops/Tools/godot_slot.py`; watchdog before each job; slices of 20 minutes or less, output to
  `E:/FightCamp/tmp/planimpact2/`.

## Feedback loops
- Plan -> grade -> the reader's calls win more -> nothing feeds back into the plan inside a bout (fixed at the first bell). One
  grade is the cap. Printed per arm and opponent style: the share of the reader's commands raised. Over 80% under the best plan
  = the mapping is too wide; under 10% = too narrow to move anything: said before the full run (no re-mapping: this task's rule
  is the narrowing).
- The corner's worth -> "is the plan or the corner the game": capped by bar 3.

## Kalli's change (a) (the corner coach's tactics = how well the boxer hears the call)
Same lever (a command's grade), different owner. Answered in the result page from the numbers.
