# TASK MONEYFOUR1 - QWEN (qwen3-coder) - what four fighters cost the club in a year. Measure only

Status: OPEN (S429, Claude main). Discipline: boxing (the fourth fighter is a BJJ fighter; for money she is one more amateur).
Model: qwen3-coder.
Source: the operator's S428 scope change (ops/research/SCOPE_FOUR_FIGHTERS_S428.md): a career now STARTS with four fighters.
Every money number in the game was set for ONE fighter: start cash = 3 months of costs with one $250 stipend
(Career.start_cash), Reid at $450 a week, 30 members. Nobody has measured a year with four. This task measures it in the game
as it is. It changes NO game file.

## Contract
OWNS: tools/money_four_probe.gd, docs/MONEYFOUR1_RESULT.md
RED_TEST: tools/money_four_probe.gd -> MONEYFOUR1 careers=<n> (measure only)
REGRESSION: golden_path_test
VISUAL: no

## The job
1. Read tools/career_harness.gd (on main) for the harness: it plays careers through the real game (Main.act) with a
   "sensible" player (`_decide`), and tools/harness_money.gd (`sample`, `finish`, `report`: where the cash came from and
   went, cash at each quarter as months of costs) and tools/harness_spend.gd (`_stipends`: `main.act("stipend",
   "<fid>|on|off")` puts a fighter on the club stipend or on a day job). Reuse them by preload; do not edit them.
   Population rule (the harness's own): each career jitters the walk-in's stats by +-4 and the reputation by +-3 from its
   seed; the same seeds in every cell. Fewer than 10 careers per cell = VOID.
2. Your probe plays the SENSIBLE player for 52 weeks, n=10 careers per cell, with FOUR fighters from week 1: the walk-in
   (signed as the harness does) and three more signed in the first week. Sign them the way the game does: either
   `main.act("invite", id)` -> `main.act("trial", id)` -> `main.act("signprospect")` on three entries of
   `c.prospects` (Data.PROSPECTS) as soon as the game allows, or, if the game makes that take longer than 2 weeks, call
   `Roster.sign_fighter(c, raw, picks)` (scripts/state/Roster.gd) directly on day 1 with three Data.PROSPECTS rows and
   their default cards. SAY which route you used and on which day each of the four was on the roster. Pick three prospects
   in three different weight classes if Data.PROSPECTS has them; say which you picked and their classes.
3. Cells (same seeds in each):
   (a) ONE: the game as it is, one fighter all year (the control arm);
   (b) FOUR_ALL: four fighters, all four on the $250 stipend;
   (c) FOUR_TWO: four fighters, the two best on the stipend, two on a day job;
   (d) FOUR_ONE: four fighters, the best one on the stipend, three on a day job;
   (e) FOUR_NONE: four fighters, all on a day job.
   Hold the stipend choice fixed for the whole career in (b) to (e): do not call harness_spend's `_stipends` rule there
   (it would change the cell); the rest of the sensible player stays as the harness plays it.
   Start cash: as the game gives it (Career.start_cash, one stipend). ALSO run cell (b) and (d) a second time with start
   cash raised by 3 months of the extra stipends that cell pays (set `c.cash` right after `main.act("quick")`; say the number).
4. Print one line per career and cell:
   `MONEYFOUR cell=<id> career=<i> closed=<0|1> close_week=<n|-> cash_w13=<$> cash_w26=<$> cash_w39=<$> cash_w52=<$>
   bouts=<n> ticket_income=<$> stipends_paid=<$> weeks_below_zero=<n>`
   and at the end `MONEYFOUR1 careers=<n> (measure only)`.
5. docs/MONEYFOUR1_RESULT.md (plain words, no jargon): the population; a table per cell of careers closed, the median close
   week, the median cash at weeks 13, 26, 39, 52 in dollars AND in months of that cell's weekly costs, the median number of
   bouts a year for the whole club and the ticket income they brought, the stipends paid. Then six sentences:
   - how many weeks does today's start cash last with four fighters on the stipend, and with one?
   - which cell keeps the median cash between 1 and 4 months of costs through the year (the design's target band)?
   - how much does a day job slow a fighter (GymSpend.DAY_JOB_GAIN: quote the number from the code) and did the day-job
     fighters still win bouts?
   - do four fighters bring more ticket income than one (bouts a year x the $450 ticket cut), and does it cover a stipend?
   - what start cash would give cell (d) three months of runway? what would cell (b) need?
   - what could you not measure? (The amateur lead is still 2 to 4 weeks and camps still run: say so.)
   Bend no threshold. If a cell cannot be set from the code, say why and print it as VOID, do not fake it.

## Prior research
ops/research/SCOPE_FOUR_FIGHTERS_S428.md (the scope), ops/research/MONEY_BITES_S397.md sections 5 and 9 (the money
harness and its bounds), tools/career_harness.gd header (bounds measured at 104 weeks), CLAUDE.md "Decided numbers",
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A real amateur club pays almost nobody: most boxers work or study and train in the evening, and the club backs one or two
prospects so they can train full time. An owner taking on three more boxers asks first what each one costs a week and how
many weeks the bank lasts.

## Prefab check
The harness exists (tools/career_harness.gd, harness_money.gd, harness_spend.gd). No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tools/money_four_probe.gd` (the plain win64 exe, never the console one). Parse first:
`<godot.exe> --headless --audio-driver Dummy --path . --check-only --script res://tools/money_four_probe.gd` through the same
queue. Headless only; nothing opens on a monitor.
RESULT lines for the PR body: `RESULT: tools/money_four_probe.gd -> MONEYFOUR1 careers=<n> (measure only)`.
