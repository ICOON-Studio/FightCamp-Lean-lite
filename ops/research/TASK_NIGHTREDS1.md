# TASK NIGHTREDS1 - GROK DEV - which merge turned plan_templates and matchmaking_bots red (a measurement, no fix)

Status: OPEN (nightly review 2026-11-23, Claude). Discipline: boxing. Model: Grok Dev default.
Source: nightly 2026-11-23 (commit 3d72c6222): both tests red; both green on 2026-11-22 (commit 4088bfc83).

## The failures
1. tests/plan_templates_test.gd (about 30 s):
   `FAIL t_turn answers Maria better than the starter plan` - "Vs a presser: make the punches miss and turn" vs Maria
   Ortega won 0.438 (edge +0.23) against the starter plan's 0.445 (edge +0.25). Every other check passes.
2. tests/matchmaking_bots_test.gd (about 11 minutes; run it alone):
   `FAIL smart's median place beats hard's by >= 1 (+0.5)` (smart 13.0, hard 13.5) and
   `FAIL scouting is worth it: fewer stoppage losses than blind (+0.14)` (smart 0.91 stopped, blind 0.77).

## Likely causes (not proved)
- matchmaking_bots: 68067e0ba (S535 DMGCLASS2, merged in e93158da7): WorldBout passes `rounds >= PRO_FROM` to
  Knockdowns.round_counts, so pro world bouts lose the amateur four-count limit - more stoppages; its own message says
  "tests pending".
- plan_templates: 3a3cb3a08 / da4af6772 (S537 STEPPAY3, merged in 8625bd763): PlanFight.ANSWERS adds the five step
  moments and grades roll_out / push_off wrong on a tiring or hurt opponent.
- Also in range: fe72931fd (MOODREAD1, the win read's caches carry mood), 78cff7ff2 (pro weigh-in miss).

## Contract
OWNS: nothing in the game. A result file: ops/research/NIGHTREDS1_RESULT.md
RED_TEST: tests/plan_templates_test.gd, tests/matchmaking_bots_test.gd
VISUAL: no

## Do
1. In a seeded worktree, run each test at 4088bfc83, at e93158da7^1 / e93158da7, 8625bd763^1 / 8625bd763, and at
   fe72931fd^ / fe72931fd (bisect inside a merge's branch if the merge is the step).
2. Write each run's printed numbers (t_turn won/edge vs starter; the four bots' median place and stopped) and the first
   commit where each check goes red.
3. Say for each whether the drop is the change doing what it meant (a design result: the bar or the bots' taste needs the
   main session's look) or a side effect (a bug: name the line).
Do not change any number or threshold in the tests or the rules. STEPPAY5 (branch s538/steppay4) is in flight on the same
rules: do not touch that branch.

## Prior research
`python ops/Tools/prior_research.py plan templates matchmaking bots dmgclass steppay`. REALPLANS_S341.md section 3,
docs/STRUCTURE_DESIGN_S395.md 5.3a (the bot test's rule).

## What would a human do?
Play a pro career with the smart bot's habits and see whether scouting still saves the boxer from stoppages.

## Prefab check
None.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who grok -- ...`, headless, `--audio-driver Dummy`, one run at a time.
Never a checkout in the main checkout. PR body: `RESULT: ops/research/NIGHTREDS1_RESULT.md -> plan_templates first red: <hash>; matchmaking_bots first red: <hash>`.

## The one trap
t_turn's gap is 0.007 on 40 bouts: run the 40 bouts as the test does (same days), never fewer, and compare printed numbers, not pass/fail alone.
