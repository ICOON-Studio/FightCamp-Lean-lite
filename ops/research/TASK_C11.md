# TASK C11 — THE SET-PIECE READ API (Codex)

Model: medium, effort medium, Fast off. Read-only projections, one commit.

## Why

R27 (Claude, next stage) rebuilds the five set-pieces on Kalli's approved K7
frame (`research/K7_DIGEST.md`, `SETPIECE_FRAME_K7.html`):
`fight_week`, `weigh_in`, `fight_night`, `fight_result`, `crowning`. Two of
those five have **no scene at all** — `SceneRouter.gd:85-86` registers
`fight_week` and `weigh_in` with an empty `"scene"` — and the two that exist,
`FightResultScreen.gd` (387 lines) and `DoubleChampCrowning.gd` (285), are
pre-kit and are DISCARDED, not migrated, under the user's 2026-09-05 rule.

Those two screens are also the reason this task exists. They do not read the
game; they are handed a `payload` Dictionary by whoever pushed them
(`FightResultScreen.present()` at `:29`, `DoubleChampCrowning.present()` at
`:36`) and they compute display text by hand — `_record_line()` at
`FightResultScreen.gd:132` rebuilds a fighter's record from scratch. A rebuilt
set-piece must ask GameState instead. That projection is this task. R27 is
blocked on it and on nothing else.

Same shape as C4-C10: pure reads, no new save fields, no screens touched.

## Deliver, appended at the end of `Godot/scripts/GameState.gd`

1. `get_fight_week_card(athlete_id) -> Dictionary` — the FIGHT WEEK board:
   opponent name and record, the stakes (title bout / ranking / neither),
   the event and venue, `weeks_out` and `days_out`
   (`get_booked_fight_due_week`, `:2485`; `get_booked_fight_due_day`,
   `:2465`), the ruleset the bout is fought under, the camp state from
   `get_fight_camp_options` (`:797`) — booked or not, weeks available,
   focus, protocol, partners — and the weight line from `get_weight_status`
   (`:1359`). Empty `{}` when the fighter has no booked fight.
2. `get_weigh_in_card(athlete_id) -> Dictionary` — the WEIGH-IN board:
   class limit, current weight, the chosen cut action, the scheduled slot
   (`_weigh_in_slot`, `:1349`), and, once `athlete["weigh_in"]` exists, the
   resolved record with the miss fraction and the fine it costs
   (the settle arithmetic is at `:9940-9963` — read it, do not re-invent it).
   Before resolution, say what is at stake in words: making it, the fine
   band if missed, and the cancellation case.
   **`_resolve_weigh_ins` (`:1696`) is the writer and this read must never
   reach it.**
3. `get_fight_result_card(athlete_id) -> Dictionary` — a projection over
   `athlete["pending_fight_result"]` (written at `:9796`): result, method,
   scorecards, final health, knockdowns, duration, rounds completed and the
   frozen `ruleset_id`. Add the two things the old screen computed for
   itself: the **record line after this fight** and the **purse and bonus
   actually paid**. **This read must not consume or settle the result** —
   settlement happens once, inside `advance_week()` (`:9896`).
4. `get_crowning_card() -> Dictionary` — a card over the existing
   `get_pending_crowning()` (immediately above `consume_pending_crowning` at
   `:9478`): the fighter, both belts, the window, and the record. Note that
   `get_pending_crowning()` **erases a stale entry** as it reads; run it on
   the disposable copy so this card can never destroy a live crowning.
   `consume_pending_crowning()` stays the one consuming call and stays
   R27's to make, once, on the real career.

## Rules

- Every public read runs against a **disposable Career copy**
  (`var live := career; career = live.duplicate(true)` … restore), exactly
  as `get_scouting_board()` does at `GameState.gd:11229`. Rule 4 is the
  reason this is not optional here.
- **No new save fields and no writes.** No settlement, no consumption, no
  weigh-in resolution. If R27 turns out to need a write, that is a separate
  task and it comes to you.
- Empty ids, no active career and no booked fight return `{}`, never a
  fabricated row.
- Money is real: the purse and the fine are the numbers the game will
  actually move, not rounded display values.
- Do not touch the K7 timings. Milliseconds are R27's problem; you supply
  the data the frame draws.

## Owned files

- `Godot/scripts/GameState.gd` (append at the end only)
- NEW `Godot/tests/setpiece_api_test.gd`

Nothing else. R27 owns every screen, the router and the kit. Claude is live
in this repo on R26 (OFFICE + STAFF) but owns screens and the kit there, not
`GameState.gd` — still, check `git status -s` before you stage.

## Parse gate, before any test run

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/setpiece_api_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/setpiece_api_test.gd
```

Then `smoke_test.gd`, then the full suite once before the commit (Git Bash,
from `Godot/`, `GODOT` = the console exe): `for f in tests/*.gd; do timeout
600 "$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo "FAIL
rc=$? $f"; done`.

The gate is yours (user, 2026-09-05): parse, focused test and full suite all
pass before you push, and the digest says so. Two gotchas that have each cost
a cycle: a `--script` test cannot name a plain script with a bare identifier
(`WorldPopulation` and friends need a `preload` — C8's test did not load at
all until R25 fixed that), and `var x := <call>` fails when the call returns
Variant, so write the type.

Getting a fighter to a settled result inside a test means driving a real
booking through `advance_week()`; `DevJump` (C3, `Godot/scripts/DevJump.gd`)
exists for exactly this and does real booking on isolated slots 4-9. Use it
rather than hand-building a `pending_fight_result`, or the card will pass a
test against a shape the game never produces.

## Finish

Check `git status -s` first, `git add -- <your files>` only, one commit, push
`master` if you can (else Claude pushes), then convert your `HANDOFF.md`
block to COMPLETE with the hash (max 8 lines) and write
`research/C11_DIGEST.md`.

`HANDOFF.md` has mixed line endings. Append your block without reformatting
anyone else's, and never rewrite another agent's block.
