# TASK U21 — CURSOR — BroadcastRead STOPS ASSUMING FOURTEEN SECONDS

**Model:** your strongest available · medium effort. Module and test.

## Why you, and why now

**You and Codex independently named the same casualty.** C62: "`BroadcastRead`
needs 14-second aggregate rows or an additive tick-span/duration field because
it currently assumes 14 seconds per event." U20, yours: "U19's `* 14 / 60`
becomes `count / fight_seconds * 60` when C62/G28 stop promising 14."

You wrote U19, so you own its one hardcoded assumption. **This lands BEFORE the
real-time core** and must keep working against today's atomic engine — it is a
strict improvement either way, not a migration step that waits.

## What is true today

`Godot/scripts/BroadcastRead.gd` scales its per-minute figures
`measured * 14 / 60`, because every action event is worth exactly
`AVG_SECONDS_PER_EXCHANGE` (14) fight-seconds. Under the real-time core that is
false: events will carry their own span. `broadcast_read_test.gd` is 75 checks
and builds its fixtures by hand.

## The contract

1. **An event may carry its own duration.** Read a per-event span field if it
   is present and use it; **fall back to 14.0 when it is absent**, so a log
   written by today's engine reads exactly as it does now. Name the field once
   as a `const` in `BroadcastRead.gd` and say in a comment that R82 will write
   it — do not invent a second name.
2. **Per-minute figures derive from measured fight-seconds**, not from an event
   count times a constant. The sum of the spans of the events you actually
   measured is the denominator.
3. **`ImpactModel.per_minute(count, fight_seconds)` is the one implementation**
   of that arithmetic — Codex is shipping it under C63. Call it rather than
   writing the division twice. If C63 has not landed when you get there, write
   the division inline **exactly as C63 specifies it** and say so in your
   digest; Claude reconciles.
4. **Every existing behaviour survives.** The em dash for a missing burst, a
   zero-throw actor and an empty log; the eight reads; THE READ beside THE
   RANGE. A pre-R80 log with no burst at all still prints dashes.

## Owned files

- `Godot/scripts/BroadcastRead.gd`
- `Godot/tests/broadcast_read_test.gd`
- `research/U21_DIGEST.md` — new, short.

**Do NOT touch** `FightSimulation.gd` (Claude, R82), `ImpactModel.gd` (Codex,
C63), `RingSpace.gd` (Qwen, Q13), or `HANDOFF.md` — Claude writes your block.

## The trap

**The fallback is the whole task.** A change that makes real-time logs read
correctly but silently shifts today's numbers is a regression, because today's
engine is what ships right now and will keep shipping until R82 lands. Add a
test that a log with **no** span field produces byte-identical output to what
`broadcast_read_test.gd` asserts today — that assertion is the gate, and it
must be written before the change, not after.

## Gate

Parse gate, your own test, then the full suite in the background:
`python Godot/tools/run_tests.py` → **`fails=0` or better** (it reads
`total=193 fails=0` now). Push to a branch and **name the branch in your mail**
— the master inbox cannot see branch mail.
