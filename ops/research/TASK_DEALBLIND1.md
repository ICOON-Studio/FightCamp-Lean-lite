# TASK DEALBLIND1 - a blind contract test for the club week's coached-morning deal (CoachedMornings), with mutants

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write the
test, parse it with gdtoolkit; CI and Claude run it).

## Why
S519 built the club week (owner Q-S294-272 "Yes, build it"): with two or more boxers the coach deals the club's coached
mornings each week (scripts/rules/CoachedMornings.gd, read by scripts/state/MorningWire.gd, shown on the Training tiles).
Its own tests (coached_mornings_test, morning_deal_test, club_deal_test) were written by the author. A test written from
the CONTRACT alone has found a shared blind spot three times (ROPESCONTRACT1, PROCONTRACT1, GUARDBLIND1). Coach fit, if
built, will multiply exactly these mornings, so the deal must be pinned first.

## The contract - write the test from THIS, from the `##` HEADER COMMENTS of scripts/rules/CoachedMornings.gd and from its
## CONSTANTS (SOLO, SOLO_WEAK, SHARED, YOU_OWNED, COACH_OWNED, FIGHT_ABILITIES, WEAK_GAP, WORDS - data, read freely).
## Do NOT read the function BODIES of CoachedMornings.gd; do not read tests/coached_mornings_test.gd,
## tests/morning_deal_test.gd, tests/club_deal_test.gd or scripts/state/MorningWire.gd.
A row is {id: String, stats: {the six FIGHT_ABILITIES: float}, days: Array of 7 Strings} - each day the ability that
morning trains, "" for rest / work / mobility. Rows are in deal order (fight-week boxers first).

week_deal(rows, coach_kind) -> Dictionary:
- Fewer than 2 rows: returns {} (one boxer = the week as before).
- Otherwise returns {id: {dow_string: {use, mult, ability, mate}}} with a key for EVERY row id (an empty {} when she got
  nothing); dow keys are Strings "0".."6".
- Slots: the total number of coached MORNINGS dealt never exceeds owned(coach_kind) = YOU_OWNED + COACH_OWNED[kind]
  (4 + 2 sessional, 4 + 3 full_time, 4 + 0 none). A SHARED morning is ONE slot for two boxers. When the boxers have
  enough trained mornings, every slot is used.
- Only a trained morning is dealt: never a "" day, and the dealt "ability" equals that row's days[dow].
- No boxer is dealt twice on the same day.
- Shared: two boxers who train the SAME ability on the SAME day may share it: use "shared", mult SHARED (1.15), each
  names the other in "mate", same ability on both. At most ONE shared morning per boxer per week. Among the possible
  pairs, the one whose ability is the pair's shared_focus is taken before any other.
- Solo: use "solo", mate "", mult SOLO (1.25), or SOLO_WEAK (1.4) when the ability is weak_spot(her stats). Solos go round
  the row order one boxer a turn; each boxer's solo goes on her LOWEST-RANKED trained morning still free (rank inside
  her own six abilities).
- Deterministic: the same rows give the same deal.

shared_focus(stats_a, stats_b) -> {ability, a, b}: the ONE ability the two boxers both rank lowest (lowest summed rank
inside each one's own six; ties by the lower summed value); a and b are each one's value. {} when either has no stats.

weak_spot(stats) -> String: her lowest fight ability when it is at least WEAK_GAP (3.0) below her six-ability mean, else "".

day_mult(coached, dow, ability) -> float: the dealt morning's mult when the deal coached day dow on THIS ability; 1.0 when
the day was not dealt or was dealt on another ability. (coached = one boxer's entry of week_deal.)

tile_word(m): "Coached 1-to-1: Power (x1.25)" / "Shared: Stamina (x1.15)" (WORDS for the ability name), "" for {}.

## Deliverable
`tests/deal_contract_test.gd` (extends SceneTree, under 400 lines; no randomness needed), printing `ok <what>` /
`FAIL <what>` per check and `DEAL_CONTRACT PASS fails=0` or `DEAL_CONTRACT FAIL fails=<n>`, then quit(0|1). Build rows by
hand (two, three and four boxers; sessional, full_time, none; a boxer with a weak spot, one without; days with and
without overlaps). Parse it with gdtoolkit. Work on your own arena/ branch of ICOON-Studio/FightCamp-Lean-lite, a PR into
main there that adds ONLY that file; never merge.
In the PR body: five mutants (one-line changes) and the check that catches each, e.g. a shared morning costs two slots;
two shared mornings for one boxer; SOLO_WEAK never applied; the solo goes on her highest-ranked morning; a "" day dealt.
A check that fails against the code is a FINDING: keep it and say so in the PR body.

## Contract
OWNS: tests/deal_contract_test.gd
RED_TEST: tests/deal_contract_test.gd -> DEAL_CONTRACT PASS fails=0
REGRESSION: coached_mornings_test, morning_deal_test, club_deal_test
VISUAL: no

## Prior research
ops/research/TASK_STEPBLIND1.md and TASK_GUARDBLIND1.md (the same shape of task); scripts/rules/CoachedMornings.gd headers.
## What would a human do?
A head coach with six free mornings and four boxers: pair two who need the same work, then give each the session on the
thing she is worst at - and never book the same boxer twice in one morning.
## Prefab check
None: our own test.
