# TASK ROPESCONTRACT1 - a blind contract test for the ropes count (STEPVALUE1), with mutants

Status: OPEN (S490, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write
the test, parse it with gdtoolkit, Claude runs it on the PC).

## Why
S489-S490 built the ROPES COUNT (scripts/state/StepWire.gd, called from LiveRound.exchange) and its two lines (the corner
card's HURT row, the Why's AGAINST YOU line). Claude's own tests (tests/step_ropes_test.gd, tests/ropes_lines_test.gd)
were written beside the code. A blind test written from the CONTRACT alone catches what the author's test shares with the
author's bugs.

## The contract (write the test from THIS and from ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md sections 2 and 7 - do
not read the function BODIES of StepWire.gd, CornerCard.gd or FightWhy.gd; their header comments are part of the contract)
- StepWire.after(lv, rec, arrow, planned) is called once per exchange with the exchange's planned move (arrow) and whether
  the plan fired it (planned). It always sets rec["ropes_put"] ("" when nothing happened).
- Only a PLANNED step counts. planned == false, or an arrow that is not a step (a punch or a combination id), changes no
  count.
- A planned "step_back" adds 1 to lv["ropes"]. A planned "pivot_out" or "step_out" sets lv["ropes"] back to 0.
- A planned "cut_off" or "herd" adds 1 to lv["opp_ropes"] (StepEffect row "opp_ropes").
- When lv["ropes"] reaches StepEffect.ROPES_AT (3): lv["at"] becomes "own_ropes", lv["ropes"] goes back to 0,
  lv["ropes_times"] grows by 1 and rec["ropes_put"] is "own". The own count is checked before the opponent's.
- When lv["opp_ropes"] reaches 3 (and the own count did not): lv["at"] becomes "opp_ropes", lv["opp_ropes"] goes back to
  0 and rec["ropes_put"] is "opp"; ropes_times does not move.
- StepWire.times(lv) == lv["ropes_times"] (0 when absent).
- A closed round (LiveRound.close) carries "ropes" = that round's ropes_times.
- CornerCard.card(summary, energy, names, ropes): ropes 0 -> the "hurt" text has no "ropes"; ropes 1 -> "Put on the
  ropes once"; ropes n >= 2 -> "Put on the ropes n times". The "call" and "why" do not change with ropes.
- FightWhy.read(rounds, first, opp)["against"] ends with "On the ropes N times with no way off." when the rounds' "ropes"
  sum to N > 0 ("On the ropes once with no way off." for one, "On the ropes 3 times ..." for three), and
  has no "ropes" at all when the sum is 0. The line names nobody (no first name in it).

## What to do
1. tests/ropes_contract_test.gd (extends SceneTree; under 300 lines): build lv/rec dictionaries by hand for StepWire, call
   CornerCard.card with CornerCard.summarize([]), call FightWhy.read with hand-built rounds
   ([{"exchanges": [{"won": false}], "won": false, "ropes": n}, ...] - see tests/fight_why_counts_test.gd for the shape).
   Check every bullet above, including: two step backs then a pivot out then two step backs = never on the ropes; three
   step backs across exchanges where the middle one was NOT planned = not on the ropes; six planned step backs =
   ropes_times 2. Print `ok  <what>` / `FAIL <what>` per check and `ROPES_CONTRACT PASS fails=0` or `FAIL fails=<n>`,
   quit(0|1).
2. Five mutants in the PR body: for each, the one-line change your test must catch and the check that catches it (e.g.
   pivot_out not clearing, ROPES_AT off by one, the planned flag ignored, ropes_times not reset per round, the corner card
   line shown at 0).
3. Parse the file with gdtoolkit (gdparse) before the PR.

## Pass lines
RESULT: tests/ropes_contract_test.gd -> ROPES_CONTRACT PASS fails=0 (Claude runs it)
RESULT: mutants -> 5 of 5 caught (Claude runs them)

## Contract
OWNS: tests/ropes_contract_test.gd
RED_TEST: tests/ropes_contract_test.gd -> ROPES_CONTRACT PASS fails=0 (no such file on main)
REGRESSION: tests/step_ropes_test.gd, tests/ropes_lines_test.gd, tests/step_effect_test.gd
VISUAL: no
NOT YOURS: every other file.

## Prior research
ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md (s2 ROPES row, s7 the lines table); tests/fight_why_counts_test.gd
(round shape); scripts/rules/StepEffect.gd (the rows are data, read them).

## What would a human do?
A QA tester reads the rule sheet ("three step backs in a round with no pivot out puts you on the ropes") and tries the
edges: two, three, a clear in the middle, an unplanned step.

## Prefab check
None: our own rules.
