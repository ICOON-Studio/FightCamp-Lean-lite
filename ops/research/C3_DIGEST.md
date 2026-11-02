# C3 DIGEST — deterministic developer jump harness

Status: complete on 2026-09-05. C3 adds no screen and changes no Career
schema. It prepares a real Career through public `GameState` operations and
names a `SceneRouter` route with navigation disabled for the setup call.

## Shipped API

`Godot/scripts/DevJump.gd` is an autoload-shaped `Node` with:

```gdscript
DevJump.seed({"route": "office_menu"})
DevJump.seed({"route": "events", "week": 12, "seed": 74001})
DevJump.seed({"route": "fight_night", "week": 6, "booked": true})
DevJump.routes()
DevJump.describe("fighter_card")
```

`seed()` always returns `{"ok", "route", "reason", "state"}`. Success state
reports the external developer slot, internal isolated storage slot, save
directory, requested seed, week/day, roster size, cash, prepared ids and route
arguments. Failure is explicit and carries a reason; a requested booked landing
never silently degrades to an unbooked one.

The harness performs the real lifecycle:

1. `begin_new_career()` and `finalize_new_career()` create the Career.
2. Optional roster growth uses the real recruitment market and signing APIs.
3. Optional booking searches all generated countries, obtains a real open event
   offer, and calls `book_fight()` with a real roster athlete.
4. Repeated real `advance_week()` calls reach the requested week.
5. C2's `get_event_broadcast()` verifies that a booked card contains exactly
   one player bout.
6. `SceneRouter.go()` names the requested built route while
   `navigation_enabled` is temporarily false, so headless setup does not swap
   scenes. The prior navigation flag is restored.

`routes()` and `describe()` delegate to `SceneRouter`; C3 does not create a
second route table. C3 adds only the contextual `needs` map for athlete, event,
booking, settled-result and champion prerequisites.

## Player-save safety

The task's external scratch slot defaults to 9 and accepts only 4–9. The
currently shipped `GameState.begin_new_career()` validates only slots 1–3, so
C3 maps each external developer slot to internal slot 1 under its own directory:

```text
user://fightcamp_dev_jump/dev_slot_9/career_slot_1.json
```

That is a namespace mapping, not a player slot. It never reads, rotates, writes
or deletes the normal slot 0–3 files. The focused test places byte sentinels in
all four paths and proves they remain unchanged through successful, failed and
repeated jumps.

## Shipped-code differences from the task note

- `advance_week()` and `advance_day()` currently take no overrides dictionary.
  Determinism therefore comes from the real world seed key: the requested seed
  is included in the generated gym identity, then the unchanged game systems
  use their existing stable career/week/day formulas. The same complete spec
  was replayed twice and produced identical week, roster size and cash.
- The starter Career has no public athlete-release action. C3 can grow a roster
  through real recruitment, but a requested roster smaller than the real
  starter roster fails with a named reason instead of editing the roster array.
- `fight_week` and `weigh_in` exist in `SceneRouter` but have no built scene, so
  the router refuses them and C3 returns that reason. `fight_result` and
  `crowning` need real settled/champion state for which there is no public setup
  action; C3 names the missing prerequisite rather than fabricating one.
- R20 did not add a `DevJump` line to `project.godot`. C3 obeyed its ownership
  rule and did not edit that file. The F9 picker/integration owner must register
  `res://scripts/DevJump.gd` as the `DevJump` autoload before runtime use.

## Verification

- Parse gate: `DevJump.gd` + `dev_jump_test.gd` — 2 checked, 0 failures.
- Focused test: `dev_jump_test.gd` — 129 checks, 0 failures.
- Full headless suite: 117 test scripts passed, 0 failed.

The focused contract covers deterministic replay, week 12, real booked-event
landing, exactly one player bout, impossible-week failure, every router id and
description, unknown route rejection, slot-range rejection, route bookkeeping,
and byte-identical player-save protection.
