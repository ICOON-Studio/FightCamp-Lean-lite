# TASK HOTBLIND1 - a blind contract test for "on a run" and ducked / owed (HotStreak + RivalOffer), with mutants

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write the
test, parse it with gdtoolkit; CI and Claude run it).

## Why
S518 built "your heat" (map DESIGN_LADDER1_V6_DOLA.md R6): a boxer ON A RUN makes rival corners just above her lean No,
such a No marks the rival DUCKED, and two ducks make the next ask OWED (they must say yes). scripts/state/HotStreak.gd and
scripts/rules/RivalOffer.gd were tested by their author only (tests/hot_streak_test.gd). A test written from the CONTRACT
alone has found a shared blind spot three times (ROPESCONTRACT1, PROCONTRACT1, GUARDBLIND1).

## The contract - write the test from THIS, the `##` HEADER COMMENTS of scripts/state/HotStreak.gd and the constants of
## HotStreak.gd (WINS, POINTS, WEEKS, GAP) and RivalOffer.gd (OWED_SCORE, OWED_PAY, DUCK_WINDOW, DUCK_RANK_GAP).
## Do NOT read the function BODIES of HotStreak.gd or RivalOffer.gd; do not read tests/hot_streak_test.gd.
Build a Career with `Career.new()`; set `c.day` and `c.results` directly. A result is {fid, win: bool, d: day, pts: int,
pro: bool}; c.results is NEWEST FIRST. A boxer f is {id, rep (her ladder points), ...}; a rival opp is {name, rep}.

hot(c, f) -> bool: true when BOTH hold, reading only HER amateur results (fid == f.id, pro false):
- her newest WINS (3) results are all wins (the run breaks at the first non-win, newest first), and
- the "pts" of her results dated within the last WEEKS (8) weeks (c.day - d <= 56) add up to POINTS (8) or more.
- Another boxer's results, and her pro results, never count. Results older than 8 weeks add no points but still count
  toward the run of wins.

words(c, f) -> "" when not hot; else exactly "On a run: <run> wins, +<pts> points in 8 weeks." with run = her current
unbroken win count (may be more than 3) and pts = the 8-week sum.

would_duck(c, f, opp, said_no) -> bool: true only when said_no AND hot(c, f) AND the rival is 0..DUCK_RANK_GAP (8) ladder
points ABOVE her (opp.rep - f.rep in 0..8 inclusive). Below her, or 9+ above, never a duck.

duck(c, f, name): records a duck in the week int(c.day / 7) under f["ducks"][name] (creates f["ducks"] when missing).
Asking twice in the same week is ONE duck (never an instant owed). Ducks older than the window are dropped when a new one
is recorded.
ducks_of(c, f, name) -> Array: the duck weeks w with 0 <= week - w < DUCK_WINDOW (8).
is_owed(c, f, name) -> bool: 2 or more ducks inside that window. One duck: false. Two ducks 8+ weeks apart: false.
clear(f, name): removes that rival's ducks (the owed bout is booked); another rival's ducks stay.

RivalOffer.owed_answer(owed_now, score) -> {score, no_pays}: owed -> {OWED_SCORE (95), OWED_PAY (3)}; not owed ->
{score as given, 0}.

## Deliverable
`tests/hot_contract_test.gd` (extends SceneTree, under 400 lines), printing `ok <what>` / `FAIL <what>` per check and
`HOT_CONTRACT PASS fails=0` or `HOT_CONTRACT FAIL fails=<n>`, then quit(0|1). Parse it with gdtoolkit. Work on your own
arena/ branch of ICOON-Studio/FightCamp-Lean-lite, a PR into main there that adds ONLY that file; never merge.
In the PR body: five mutants (one-line changes) and the check that catches each, e.g. POINTS read as 15; a draw does not
break the run; another boxer's results counted; a rival 9 above still ducks; two ducks in one week make owed.
A check that fails against the code is a FINDING: keep it and say so in the PR body.

## Contract
OWNS: tests/hot_contract_test.gd
RED_TEST: tests/hot_contract_test.gd -> HOT_CONTRACT PASS fails=0
REGRESSION: hot_streak_test, rival_offer_test, rival_offer_wire_test
VISUAL: no

## Prior research
ops/research/TASK_STEPBLIND1.md, TASK_DEALBLIND1.md (the same shape); the HotStreak.gd header.
## What would a human do?
A promoter whose boxer is on a three-fight winning run and climbing notices which corners suddenly stop picking up the
phone - and after the second refusal, everyone in the region knows they owe the fight.
## Prefab check
None: our own test.
