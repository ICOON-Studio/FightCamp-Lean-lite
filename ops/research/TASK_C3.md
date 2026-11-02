# TASK C3 — CODEX — the dev jump harness

Self-contained. Read this file and nothing else. Do not read
`HANDOFF_ARCHIVE.md`; do not read `GameState.gd` whole (~10k lines) —
use the anchors below. START WHENEVER YOU HAVE CREDITS: not gated on a
date, and R20 does not block you (the route table is fixed below). One
session: when it ships, end it.

## Why this exists

Stage R20 ("The Spine") turns the game into a persistent career root with
a router. The point of it is TESTING: the user must be able to land on
any screen, at any career week, with a plausible roster, in seconds —
instead of playing eighteen simulated weeks to reach a fight. That lander
is yours. It is pure logic, it is headless-testable, and it touches no
screen.

## What to build

`Godot/scripts/DevJump.gd`, an autoload-shaped node (Claude adds the
autoload line to `project.godot` in R20 — do NOT edit `project.godot`).

    ## The whole API.
    func seed(spec: Dictionary) -> Dictionary
    func routes() -> Array
    func describe(route_id: String) -> Dictionary

`seed(spec)` builds a deterministic career and returns
`{"ok": bool, "route": String, "reason": String, "state": Dictionary}`.

    spec = {"slot": int (default 9, the scratch slot — NEVER 0-3),
            "route": String (one of the table below),
            "week": int (career week to land on, default 1),
            "seed": int (default 20260904, feeds every rng override),
            "roster": int (fighters to start with, default whatever
                           begin_new_career gives — do not invent a
                           second roster generator),
            "booked": bool (default false; when true the landing week
                            must contain one booked player bout)}

Rules that matter more than the shape:

- Seed by REPLAYING the real game, never by hand-writing a save
  dictionary. `begin_new_career(slot)`, then `advance_week()` with the
  deterministic `overrides` dict until `week` is reached. A save you
  hand-assemble drifts from the real one the first time a system changes;
  a replayed one cannot.
- Deterministic: the same spec twice produces the same career. Assert
  this in the test, do not assume it.
- `booked: true` must fail LOUDLY (`ok: false` and a reason naming why)
  if no bookable bout exists in that week. Never silently land unbooked —
  a lander that lies is worse than no lander.
- `routes()` returns the table below with a one-line label each, so the
  F9 picker Claude builds can render it without a second source.
- Add NOTHING to `GameState.gd`. Call what is already there. If you need
  a value that is not exposed, say so in the digest and return it empty.

## R20 STEP 1 HAS SHIPPED (commit 1fb4257) — two things you need

1. `SceneRouter` is live as an autoload and already owns the route table.
   Read `research/R20_DIGEST.md` (short) instead of re-deriving it.
   Three ids were ADDED to the career tier since this file was written:
   `today`, `fight_test`, `live_fight`. Purely additive.
2. `SceneRouter.navigation_enabled = false` does every piece of routing
   bookkeeping and skips only the scene swap. YOU WANT THIS: it is how
   DevJump names a route without navigating, and it is the only way a
   headless test can exercise routing at all — `change_scene_to_file()`
   detaches the autoloads mid-run in a --script SceneTree.

## The route table (the contract — R20 builds against this same list)

    boot:      splash, main_menu
    creation:  country_map, city, gym_pick
    career:    day_feed, gym_floor, roster, fighter_card, training,
               calendar, events, event_detail, scouting, rankings,
               office_menu, staff, contracts, finances, objectives,
               phone, weight_class
    set-piece: fight_week, weigh_in, fight_night, fight_result, crowning

`describe(route_id)` returns `{"tier", "label", "needs"}` where `needs`
names what the route requires to be meaningful — e.g. `fighter_card`
needs an athlete id, `fight_night` needs a booked bout. DevJump does not
navigate; it only prepares state and names the route. Claude's
SceneRouter does the going.

## Anchors (grep from these, do not scan)

- `Godot/scripts/GameState.gd:2673` `load_career(slot)` — slot lifecycle.
- `MainMenu.gd:586` `GameState.begin_new_career(slot)` — the real entry.
- `GameState.gd:4624` `advance_day()`, `:4766` `advance_week()` — both
  take an `overrides` dict; that dict is how determinism is bought.
- `GameState.gd:3299` `get_roster()`.
- `GameState.gd:1966` `get_event_open_slot_offer` — reaching an event's
  `bouts` array, for `booked: true`.
- Your own `get_event_broadcast` (C2) is the shape to imitate: read what
  is stored, never run a second simulation.

## Test

`Godot/tests/dev_jump_test.gd`:
- the same spec twice → identical career week, roster size and cash;
- `week: 12` lands on career week 12;
- `booked: true` returns a week whose card holds exactly one player bout;
- `booked: true` with an impossible week → `ok: false` and a non-empty
  `reason`;
- every id in `routes()` returns a non-empty `describe()`;
- an unknown route id → `ok: false`, and slot 9 only — assert slots 0-3
  are untouched.

## Rules

- Parse gate BEFORE any test: `python Godot/tools/check_scripts.py <files>`.
  A parse error hangs a headless test until the timeout instead of failing.
- Then the stage test, then the full suite ONCE before the commit:
  `for f in tests/*.gd; do timeout 600 "$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`
- Owned files, nothing else: new `Godot/scripts/DevJump.gd`, new
  `Godot/tests/dev_jump_test.gd`, `research/C3_DIGEST.md`, and your
  own block in `HANDOFF.md` (max 8 lines; never touch another agent's
  block). NOT `project.godot`, NOT `GameState.gd`, NOT any screen.
- `var x := <call>` fails when the call returns Variant — write the type.
- Commit with your Co-Authored-By line, push `master`, then END the session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/DevJump.gd
research/C3_DIGEST.md
```
