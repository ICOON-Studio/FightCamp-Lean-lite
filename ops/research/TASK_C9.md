# TASK C9 — THE OFFICE + STAFF READ API (Codex)

Model: medium, effort medium, Fast off. Read-only projections, one commit.

## Why

R26 rebuilds OFFICE and STAFF as kit panels on Kalli's K12 study
(`research/K12_DIGEST.md`): OFFICE keeps its rail item with tabs THE
DESK / THE BOOKS, STAFF stays a rail item of its own, the weight-class move
is an action off a fighter, and PHONE stays out. `OfficeHub.gd` (5764 lines)
is DISCARDED, not migrated, so every number those modules drew has to come
from a projection instead. That projection is this task. R26 is blocked on
it and on nothing else.

Same shape as C4-C8: pure reads, no new save fields, no screens touched.

## Deliver, appended at the end of `Godot/scripts/GameState.gd`

1. `get_office_desk() -> Dictionary` — cash, `weekly_athlete_payroll`,
   `weekly_staff_payroll`, `weekly_upkeep`, `weekly_projection` (what next
   settle takes), `cash_next_week`, and `purse_on_the_books` (guaranteed
   purses plus bonuses of bouts already booked). The same arithmetic
   `get_save_summary()` does at `GameState.gd:2745-2800` and `_settle_billing`
   at `:4589` — read it, do not re-invent it, and do not let the two drift.
2. `get_office_books() -> Dictionary` — `contracts`: one row per roster
   athlete and per staff member with `weeks_left`
   (`_contract_remaining_weeks`, `:5825`), `weekly_salary`, `expiring`
   (your own threshold, name it in the digest) and the name/id; plus
   `objectives`: `get_weekly_objectives()` (`:3142`) shaped for drawing,
   each row carrying `claimable` and its cash/fame reward, so R26 can put
   ONE gold CLAIM on the board.
3. `get_staff_board() -> Dictionary` — `coaches` (id, name, role, wage,
   contract weeks, `technical_teaching`, `tactical_rating`,
   `youth_development`, rating), `capacity_used` / `capacity`
   (`get_coach_capacity`, `:3530`), `rating_average`
   (`get_coach_rating_average`, `:3537`), and `pairs`: for every roster
   fighter × coach the rapport score and band
   (`CoachRapport.get_rapport` / `.band`, `CoachRapport.gd:85` and `:114`),
   with `is_corner` set for the coach `_corner_coach_id()` (`:9732`) picks.
   Rapport has never been visible in the game; this read is what makes it so.
4. `get_weight_move_card(athlete_id) -> Dictionary` — a thin card over the
   existing `get_weight_move` (`:1445`), `get_weight_move_options` (`:1480`)
   and `_weight_move_blocker` (`:1461`): current class, the legal targets
   with their week counts and body cost, the move in progress if any, and
   the refusal in words when a target is illegal. Empty `{}` for an unknown
   id, like C7 and C8 do.

## Rules

- Every public read runs against a **disposable Career copy**
  (`var live := career; career = live.duplicate(true)` … restore), exactly
  as `get_scouting_board()` does at `GameState.gd:11229` — recruitment and
  objective getters populate state lazily and a read must never write.
- **No new save fields and no writes.** The assignment write K12's `assign_arm`
  needs is **C10**, assigned to you as well (`research/TASK_C10.md`) and
  to be done AFTER this one, since both live in `GameState.gd`. Here you only
  expose `corner_coach_id`, plus `assignable` and `assign_blocked_reason` per
  pair; C10 then makes those fields tell the truth about a real write.
- Empty ids and no-active-career return `{}` / `[]`, never a fabricated row.
- Money is real: no rounded-off "about" numbers, and no negative cash hidden
  behind a max().

## Owned files

- `Godot/scripts/GameState.gd` (append at the end only)
- NEW `Godot/tests/office_hub_api_test.gd`

Nothing else. R26 owns every screen and the kit.

## Parse gate, before any test run

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/office_hub_api_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/office_hub_api_test.gd
```

Then `smoke_test.gd`, then the full suite once before the commit (Git Bash,
from `Godot/`, `GODOT` = the console exe): `for f in tests/*.gd; do timeout
600 "$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo "FAIL
rc=$? $f"; done`.

You can run Godot again (user, 2026-09-05), so **the gate is yours**: parse,
focused test and full suite all pass before you push, and the digest says so.
One gotcha C8 exposed the hard way: a `--script` test cannot name a plain
script with a bare identifier - `WorldPopulation` and friends need a
`preload`. C8's test did not even load until R25 fixed that line; it passes
30/30 now.

## Finish

Check `git status -s` first, `git add -- <your files>` only, one commit, push
`master` if you can (else Claude pushes), then convert your `HANDOFF.md`
block to COMPLETE with the hash (max 8 lines) and write
`research/C9_DIGEST.md`.

`HANDOFF.md` has mixed line endings. Append your block without reformatting
anyone else's, and never rewrite another agent's block.
