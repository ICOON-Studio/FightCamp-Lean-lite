# TASK STEPBLIND1 - a blind contract test for the footwork steps inside a round (StepWire), with mutants

Status: OPEN (S529, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write the
test, parse it with gdtoolkit; CI and Claude run it).

## Why
S525-S528 wired what a planned footwork step does in a live round (scripts/state/StepWire.gd on the data in
scripts/rules/StepEffect.gd): the ropes count, the opening a step makes for the next punch, the punches it denies, the
tank it drains, and (S528) the cost of a step thrown where it is the wrong answer. STEPTUNE3 will size these numbers next;
first a test written from the CONTRACT alone checks the wiring (S490 ROPESCONTRACT1, S524 PROCONTRACT1 and S528 GUARDBLIND1
each found something the author's test shared with the code).

## The contract - write the test from THIS, from the `##` HEADER COMMENTS of scripts/state/StepWire.gd, and from the
## constants of scripts/rules/StepEffect.gd (STEPS, GRADE_MULT, ROPES_AT, TABLE - data, read it freely) and
## Exchanges.EDGE / Exchanges.BODY_COST. Do NOT read the function BODIES of StepWire.gd; do not read tests/step_levers_test.gd,
## tests/step_ropes_test.gd or tests/ropes_contract_test.gd.
`lv` is the live round's dictionary (start each case from {}); `s` is one exchange {"landed": [ours, theirs]}; an arrow is a
plan line id - use the plain ids ("step_back", "jab"). A STEP is an id in StepEffect.TABLE; a PUNCH is any other line id.
`StepWire.levers_on` (static) is the control arm: true in the game; tests set it false and back.

open_edge(lv, arrow, planned) -> float, called BEFORE an exchange settles:
- A planned STEP with levers on: returns 0.0 and leaves lv["open"] as it was (the opening waits for the punch after it).
- A planned PUNCH: returns lv["open"] x Exchanges.EDGE["best"] and sets lv["open"] to 0.
- Any unplanned pick: returns 0.0 and sets lv["open"] to 0 (her instinct wastes it).
- levers_on false: returns 0.0 and sets lv["open"] to 0, whatever the arrow.
- So: open 0.5, then planned step_back, then planned jab -> the jab gets 0.5 x 17 = 8.5.

levers(lv, s, arrow, planned, grade, rng, fit := "") -> Dictionary, called AFTER the exchange settles:
- Returns {} and changes nothing when levers_on is false, the line was not planned, or the arrow is not a STEP.
- Otherwise returns {"denied": int, "drain": float, "extra": int}.
- fit == "wrong": the opponent's landed s["landed"][1] grows by out["extra"]. The cost share is the step's row
  "wrong_extra_damage" when above 0, else StepWire.WRONG_COST (0.2). extra is floor(max(1, theirs) x cost + a random 0..1),
  so it is floor(x) or floor(x)+1, and over 2,000 seeds its mean is within 0.03 x max(1, theirs) of max(1, theirs) x cost -
  a wrong step costs something even when she landed nothing. Any other fit ("best", "ok", "none", ""): extra 0.
- Denying: s["landed"][1] never goes below 0 and never rises from denying; out["denied"] = the punches removed.
  Identity: landed after = landed before + extra - denied.
- A step whose graded deny is 0 denies nothing.
- Drain: out["drain"] = the graded row "drain" x Exchanges.BODY_COST, and lv["opp_drain"] adds it up over calls.
- The step's own tank: lv["cost"] grows by the row's "tank" on every step except tie_up (its refill is elsewhere).
- The opening: lv["open"] becomes max(its old value, the graded row "open") - two steps in a row give the bigger, not the sum.
- Grades: scaled by StepEffect.GRADE_MULT (good 1.2 > ok 0.85 > poor 0.35); with the same rng seed a "good" step never
  denies fewer, drains less or opens less than a "poor" one.

after(lv, rec, arrow, planned) - the ropes count (rec is a {} you pass in):
- rec["ropes_put"] is "" unless the count put someone on the ropes this exchange.
- Unplanned, or not a STEP: lv's counts unchanged.
- A planned step adds its row "ropes" to lv["ropes"]; a row with "clears_ropes" true sets it to 0. At StepEffect.ROPES_AT
  (3): lv["at"] = "own_ropes", lv["ropes"] back to 0, lv["ropes_times"] + 1, rec["ropes_put"] = "own".
- A planned step adds its row "opp_ropes" to lv["opp_ropes"]; at ROPES_AT: lv["at"] = "opp_ropes", lv["opp_ropes"] back to
  0, rec["ropes_put"] = "opp". times(lv) = lv["ropes_times"] (0 on a fresh lv).
- So: three planned step_back in a row put your boxer on the ropes on the third; a pivot_out between them clears the count.

## Deliverable
`tests/step_contract_test.gd` (extends SceneTree, under 400 lines; seed every RandomNumberGenerator), printing `ok <what>` /
`FAIL <what>` per check and `STEP_CONTRACT PASS fails=0` or `STEP_CONTRACT FAIL fails=<n>`, then quit(0|1). Put
`StepWire.levers_on = true` back before quitting. Parse it with gdtoolkit. Work on your own arena/ branch of
ICOON-Studio/FightCamp-Lean-lite, a PR into main there that adds ONLY that file; never merge.
In the PR body: five mutants (one-line changes) and the check that catches each, e.g. a planned step spends the opening;
WRONG_COST applied on fit "ok"; open summed instead of max; tie_up charged its tank; ROPES_AT 3 -> 4.
A check that fails against the code is a FINDING: keep it and say so in the PR body.
RESULT: tests/step_contract_test.gd -> STEP_CONTRACT PASS fails=0

## Contract
OWNS: tests/step_contract_test.gd
RED_TEST: tests/step_contract_test.gd -> STEP_CONTRACT PASS fails=0
REGRESSION: step_levers_test, step_ropes_test, ropes_contract_test
VISUAL: no

## Prior research
ops/research/STEPS_SCOPE_S528.md (phase 1), TASK_GUARDBLIND1.md (the same method), DESIGN_STEPVALUE1_V1_KALLI_KALLI.md s2-s4.
## What would a human do?
A coach checks a footwork drill against what it is meant to do, not against the fighter's own idea of it.
## Prefab check
None: our own test.
