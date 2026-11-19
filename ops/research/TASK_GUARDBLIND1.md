# TASK GUARDBLIND1 - a blind contract test for the guard through a bout (guard damage v4), with mutants

Status: OPEN (S528, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write the
test, parse it with gdtoolkit; CI and Claude run it).

## Why
S524-S525 wired guard damage v4 into every bout (scripts/state/GuardState.gd on the rules in scripts/rules/GuardWear.gd):
each side's guard wears as it blocks, leaks damage through, comes back at the corner, and two shouts buy it back. The
author's test (tests/guard_state_test.gd) was written beside the code. A test written from the CONTRACT alone catches what
the author's test shares with the author's bugs (S490 ROPESCONTRACT1 and S524 PROCONTRACT1 each found one).

## The contract - write the test from THIS and from the HEADER COMMENTS (the `##` lines) of scripts/state/GuardState.gd
## and scripts/rules/GuardWear.gd. Do NOT read the function BODIES of those two files; do not read tests/guard_state_test.gd.
A bout keeps f["bout"]["guard"] = {"a": {g, max, clinch}, "b": {...}}; "a" is our boxer, "b" the opponent.
- GuardState.open(f, 1): both guards full. Full = GuardWear.max_guard(class, amateur): an amateur 70 whatever the class;
  a pro by the weight limit f["limit"]: up to 64 kg "light" 80, up to 81 kg "middle" 100, above "heavy" 120. clinch false.
- GuardState.open(f, n) for n > 1 (the corner minute): each guard gets GuardWear.corner(calls, false, false) back, never
  past its max: base +15; +5 more ("hands_up") when our boxer earned Hands up in the round before. The clinch flag and
  the Hands up flag reset.
- GuardState.after(f, landed, at, opp_attrs, call, n, opp_habits) after each exchange; landed = [ours, theirs].
  Punches that do not land are partly blocked; each block wears the blocking side's guard. So: more punches landed by the
  opponent (a bigger landed[1]) never leaves OUR guard higher; a guard never goes below 0 or above its max.
  at == "own_ropes" wears ours at least as much as "centre" for the same landed; "opp_ropes" does the same to theirs.
  An amateur bout (f["pro"] false) wears less than a pro bout for the same landed and the same max.
  A side the other barely threw at recovers a little (0 punches thrown at it: +4 amateur / +3 pro; 1-2: +1).
  Returns {"g": [ours, theirs], "blocked": [ints], "clinch": bool, "through": [floats >= 0], "share": [0..1, 0..1]}.
- call "tie" (the clinch): only when our guard is UNDER half its max and not yet used this round -> +10 guard (never past
  max), returned "clinch" true; a second "tie" in the same round gives nothing; at half or above it gives nothing.
  After open(f, n+1) a new round allows one again.
- call "hands": our boxer gets +5 at the NEXT corner (on top of the base); a round without it does not.
- GuardState.share(f, "a"|"b") = g / max in 0..1; -1 when the bout has no guard yet.
- GuardState.damage_on = false (the control arm): the guards still wear and show the same; only m["damage"] is untouched
  (you need not test LiveRound - test that after() returns the same "g" with damage_on true and false).
- GuardState.guard_habit(habits) = the first of ["slow_starter", "fades_late", "chases_stoppage"] in the array, "" when none.

## What to do
1. tests/guard_contract_test.gd (extends SceneTree; under 350 lines). Build a fighter with
   `Data.fighter_state(Data.lucy(), 1)` and give it f["bout"] = {} (see any test under tests/ for the shape); set f["pro"],
   f["limit"] for the class cases. opp_attrs = {"stamina": 55.0, "strength": 55.0}. Check every bullet above and the
   edges: limit 64.0 is light, 64.1 middle, 81.0 middle, 81.1 heavy; a tie at exactly half gives nothing; Hands up shouted
   twice in one round still gives +5 once; the corner never overfills a full guard. Print `ok  <what>` / `FAIL <what>` per
   check and `GUARD_CONTRACT PASS fails=0` or `GUARD_CONTRACT FAIL fails=<n>`, quit(0|1).
2. Five mutants in the PR body: for each, the one-line change your test must catch (e.g. CLINCH_THRESHOLD 0.5 -> 0.6;
   the clinch flag not reset at the corner; Hands up +5 given at once instead of the next corner; AMATEUR_SCALE equal to
   WEAR_SCALE; the 81 kg line moved to 80) and the check that catches it.

## Contract
OWNS: tests/guard_contract_test.gd
RED_TEST: tests/guard_contract_test.gd -> GUARD_CONTRACT PASS fails=0
REGRESSION: guard_state_test (never edit it)
VISUAL: no

## Prior research
ops/research/DESIGN_GUARDDMG1_V4.md; ops/research/GUARDWEAR_WIRE_S524.md; ops/research/TASK_PROCONTRACT1.md (the same kind).

## What would a human do?
A second programmer who never saw the code writes the test from the spec; where it disagrees with the code, one of the
two is wrong and that is the finding.

## Prefab check
None: a test file.

## Rules for this seat
Work on FightCamp-Lean-lite main, your own `arena/` branch, open a PR into main there; never merge, never touch another
file. A check that fails against the code is a FINDING - keep it and say in the PR body which bullet the code breaks;
never weaken it to go green. GDScript: typed vars, no `:=` on a Variant from a Dictionary, tabs; `trait` is a reserved
word in Godot 4.7.
