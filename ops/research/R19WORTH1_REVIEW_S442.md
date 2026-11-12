# R19WORTH1 blind review (REVIEW3, 2026-11-12) - PR 236, branch qwen/r19worth1 @ 09c86214

Verdict: **COLLECT WITH FIXES** - the module was nearly right; the TEST could not catch either mutant the brief names.
Fixes are uncommitted in this worktree. Seat: the brief named Arena; the dispatcher gave it to Qwen (qwen3-coder).
(`ops/research/TASK_R19WORTH1.md` shows as modified here: line endings only, not the seat's change.)

## a. Brief items (as delivered)
| Item | Status | Where (TellWorth.gd) |
|---|---|---|
| 1 candidates(kind) from the tables, "" included; kind_of | DONE | :20-42 |
| 2 worth_a_use: best usable PlanLines.options edge, floored, 0 for "" | DONE | :46-57 |
| 3 uses_a_bout: share x EXCHANGES x rounds for the four games, OTHER_USES otherwise (LEVERS1 named) | WRONG (edge case) | :62-67: a game situation for a style the table does not know fell to OTHER_USES (6 a bout) instead of a 0 share |
| 4 range_of known lo == hi (tell_sit of the real tell), hidden min/max over candidates | DONE | :71-96 |
| 5 next_film: first of OppFile.hidden, {} without tape or hidden | DONE | :100-114 |
| 6 file(): range_of for every "tape" tell in order | DONE | :118-123 |
OppFile.tape is never called. 131 lines (133 fixed) < 220.

| Required assert | Status (delivered test) |
|---|---|
| candidates == sets built in the test (weapon, weakness, habit) | DONE |
| hidden weapon lo <= exact <= hi; open -> lo == hi == exact | WRONG: the "exact" worth was computed with TW.worth_a_use / TW.uses_a_bout (the module's own functions; the brief's trap) |
| worth_a_use == recomputed best edge; 0 when the boxer can throw no answer | half: the recomputation is real; the "0" case MISSING |
| uses_a_bout press on Pressure fighter; tiring == OTHER_USES | DONE |
| next_film first id; after opening, the NEXT id; no tape -> {} | WEAK: after opening it asserted only "not weapon" |
| range_of / next_film never change the opponent (deep compare) | WEAK: compared file_found only |
| better-drilled hi >= the other's | DONE |
| MUTANTS fail the SAME asserts | WRONG: the leak "mutant" hard-coded sit "counter" (Maria's real weapon answers "press"); the no-floor "mutant" compared a typed -5.0 with the real value, a check that cannot fail |

## c. Mutants on the DELIVERED source
leak (range_of returns the real situation while hidden): **NOT caught** (failures=0).
no floor: **NOT caught**. worth counting unusable options: not caught. next_film on the last hidden: caught.
uses_a_bout without rounds: caught. range_of writing to the opponent: **NOT caught**.
On the FIXED source: leak caught (5 fails), opponent written caught, next-is-last caught, unknown style caught.
Two mutants are EQUIVALENT on today's tables, and the test now says so instead of faking a catch:
- no floor: PlanLines rates each option against PlanFight.card_mean of the moves the boxer CAN throw, so the best usable
  edge is never below 0 and the floor is unreachable (probed every situation, raw and drilled). The test prints
  `MUTANT equivalent: no floor ...` and reports `MUTANT caught` the day the floor starts to matter.
- counting unusable options: PlanLines already gives them edge 0.
So the brief's "worth 0 when the boxer can throw no answer" cannot happen at any place today (every place has a usable
single punch); the test asserts the reachable case: a raw boxer against pressure (mid range) is worth exactly 0.

## d. Words
No built player-facing string besides next_film's `what` (OppFile's own "Best weapon" / "Habit" / "Weakness"). No pronoun.

## e. Files
Only the two OWNS files changed; no test deleted.

## Fixes made (uncommitted)
scripts/rules/TellWorth.gd :60-67 uses_a_bout - before:
`if modes.has(sit): return share x EXCHANGES x rounds` / else OTHER_USES; after: a situation that is a game of ANY
STYLE_MODES row returns `modes.get(sit, 0.0) x EXCHANGES x rounds` (0 for an unknown style), others OTHER_USES.
tests/tell_worth_test.gd sections 5-11 rewritten ("REVIEW3" comments):
- `_worth_here`, `_uses_here`, `_real_sit_here`, `_range_here`: the test's own recomputation from PlanLines.options,
  Exchanges.STYLE_MODES / EXCHANGES and OppFile.tells; the hidden range must EQUAL it (catches the leak), the exact
  worth comes from it, and the hidden range must be a real range (lo < hi).
- 5b the one trap: a second Pressure fighter whose weapon answers "range" shows the same hidden range; every weapon and
  weakness row's real situation is a candidate of its kind.
- 5c raw boxer vs pressure: worth 0 (recomputed and module).
- next_film after opening = OppFile.hidden's second id exactly; next_film carries the hidden range; the no-tape case is
  a real opponent with a 0-0 record.
- deep compare: var_to_str of the whole opponent before/after range_of, next_film and file.
- drilled hi strictly above raw hi; Priya's hidden range recomputed; an unknown style presses 0 times.
- mutants: the leak copy fails `_range_ok` (the same assert the module passes); the no-floor copy is run on every
  situation for both boxers (see c).

## Test runs (fixed worktree)
- parse clean; tell_worth_test: `TELL_WORTH failures=0`, `MUTANT caught: leak`, `MUTANT equivalent: no floor ...`.
- regression: `OPP_FILE failures=0`, `PLAN_LINES PASS`, `TAPE ROOM PASS (0 failures)` (only RID/leak lines at exit, no SCRIPT ERROR), `FILE_LIMITS failures=0`. The dispatcher's PR body printed
  `RESULT: tests/tape_room_test.gd ->    at: clear (core/io/resource.cpp:822)`, not a pass line; it was re-run here.
