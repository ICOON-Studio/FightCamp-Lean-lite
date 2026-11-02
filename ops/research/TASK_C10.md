# TASK C10 — THE COACH ASSIGNMENT WRITE (Codex)

Model: medium, effort medium, Fast off. One commit.
**Run C9 first** (`research/TASK_C9.md`) — both tasks live in
`GameState.gd`, and doing them in order avoids conflicting with yourself.

## Why

K12's STAFF board (`research/K12_DIGEST.md`) has an ASSIGN FIGHTER
action: click-arm-click, coach → fighter. The game has nothing to call. Today
a fighter's coach is implicit — `athlete["technique_training_coach"]` is set
only as a side effect of assigning training (`GameState.gd:3883`, `:3958`,
`:4031`), and `_corner_coach_id()` (`:9732`) falls back to whoever teaches
best. Capacity is a gym-wide pool: `get_coach_capacity()` (`:3530`) sums each
staff member's own `capacity`, and load is counted per training day across
the roster (`_program_coach_load_on_day`, `:4373`), never per coach.

So an explicit assignment is genuinely new state. This task adds it, and
nothing else.

## Deliver

1. A new save field `athlete["coach_id"]` — absent or `""` means unassigned.
   Old saves have no such key: treat missing as unassigned everywhere and
   never migrate on read.
2. `assign_coach(athlete_id, coach_id) -> Dictionary` — `{ok, reason}`, the
   house shape. Refuse, each in its own words: no active career, unknown
   fighter, unknown coach, coach not on staff, and **coach at capacity**
   (fighters already carrying that `coach_id` >= that member's own
   `capacity`). Saves through `save_current_career()` and rolls back the
   field if the save fails, the way `shortlist_add` does (`:11326`).
3. `clear_coach(athlete_id) -> Dictionary` — same shape; refusing when the
   fighter has no coach is fine, but say so.
4. `_corner_coach_id()` prefers the explicit `coach_id` when it names a coach
   still on staff, then falls back to today's rules unchanged. This is a
   surgical edit inside an existing function — the one exception to
   append-only in this task.
5. Releasing or losing a coach must clear the assignments that point at them,
   the way C8 clears a signed candidate off the shortlist
   (`_shortlist_remove_signed`, `:11365`). Find every path that removes a
   staff member and cover it.
6. C9's `get_staff_board()` reports the truth of all this: `coach_id` per
   fighter, `assigned_fighters` per coach, and `assignable` /
   `assign_blocked_reason` per pair computed by the SAME rule
   `assign_coach()` enforces — a board that offers an action the write then
   refuses is the bug this bullet exists to prevent.

## Hard rule: do not touch the training math

Training gains, rapport growth and the corner all read a coach today
(`CoachRapport.apply_training_session`, `CoachRapport.gd:167`). Crediting the
newly assigned coach instead of the current one is a BALANCE change, and the
user has not asked for it. Leave every existing calculation exactly as it is:
this task adds an assignment and points the corner at it, full stop. If you
believe the training credit should follow the assignment, say so in your
digest and let Claude take it to the user.

## Owned files

- `Godot/scripts/GameState.gd` — the two writes appended at the end, the
  `_corner_coach_id()` edit, the release-path cleanup, and C9's
  `get_staff_board()` fields
- NEW `Godot/tests/coach_assignment_test.gd`

Nothing else. R26 owns every screen and the kit.

## What the test has to prove

Assignment persists across a save/reload; capacity refuses the one over the
line with a named reason; `_corner_coach_id()` follows the assignment and
still falls back correctly when the coach leaves; releasing a coach clears
their fighters; a save with no `coach_id` key at all still reads and plays;
and `get_staff_board()`'s `assignable` agrees with `assign_coach()` on every
pair.

## Parse gate, before any test run

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/coach_assignment_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/coach_assignment_test.gd
```

Then `office_hub_api_test`, `training_gain_test`, `coach_rapport_test`,
`smoke_test`, and the full suite once before the commit (Git Bash, from
`Godot/`, `GODOT` = the console exe): `for f in tests/*.gd; do timeout 600
"$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo "FAIL
rc=$? $f"; done`. You can run Godot again, so the gate is yours and the
digest says it passed. A `--script` test needs a `preload` for a plain
script like `WorldPopulation` — that is what stopped C8's test loading.

## Finish

Check `git status -s` first, `git add -- <your files>` only, one commit, push
`master`, then convert your `HANDOFF.md` block to COMPLETE with the hash
(max 8 lines) and write `research/C10_DIGEST.md`.

`HANDOFF.md` has mixed line endings. Append your block without reformatting
anyone else's, and never rewrite another agent's block.
