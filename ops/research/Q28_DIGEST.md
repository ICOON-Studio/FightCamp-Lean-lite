# Q28 DIGEST — `half` HAS A WRITER, AND THE SWEEP FIRES

## Grade→seat map

`GrappleResolve._takedown_grade` now returns three grades instead of two, and
`takedown_resolve` maps them to three seats:

- **grade 4 → side** (top third of success range, roll ≥ p×2/3)
- **grade 3 → half** (middle third, p×1/3 ≤ roll < p×2/3, OR power advantage)
- **grade 2 → guard** (bottom third, roll < p×1/3)

The arithmetic is clean thirds of the success probability range. A clear power
advantage (attacker power ≥ defender defense + 15) lifts the floor from grade 2
to grade 3 rather than forcing grade 4 — this keeps half guard reachable even
against a weak defender, because a power advantage alone does not produce the
cleanest landing.

**Why this map:** `side` for the best takedown and `guard` for the weakest were
already the endpoints; `half` belongs between them. No published source says a
grade-3 takedown lands in half guard; this is the engine's own arithmetic,
labelled AUTHORED in the code the way `FightRealtime.gd:1815` labels its own
three outcomes.

## Seeds where half is occupied and the sweep fires

Searched 93000..93199 with grappler-vs-fish (3 rounds):
- **82 of 200 seeds occupied half** (41%)
- **5 of 200 seeds produced a sweep** (2.5%): 93033, 93037, 93143, 93160, 93178

Pinned the first three sweep seeds (93033, 93037, 93143) in the test. The sweep
is rarer than half occupation because it requires the bottom man to succeed on
`position_resolve` from half AND the 60-tick gate to be met.

## Before and after

**Before:** `half` was in the seat vocabulary at `GrappleSeat.gd:7`, read in
four places, but nothing wrote it. Every successful takedown landed in either
`side` (grade 4) or `guard` (grade 2). The sweep branch at
`FightRealtime.gd:1828` could never run.

**After:** Grade 3 takedowns land in `half`. The sweep fires. The test asserts
that `half` is actually occupied in a real fight and that the sweep event
appears in the log — not just that `takedown_resolve` *can return* `half`,
which is the test that would have let this bug live.

## Verdict on FightRealtime.gd:1684

The zero gate on the clinch break path is **correct, not a defect**. The call
is `_move_seat(..., "clinch_break", {}, 0)` with empty scoring `{}` and zero
gate ticks. Inside `_move_seat`, the `gate_ticks` parameter is only used when
`scoring` is non-empty:

```gdscript
if not scoring.is_empty():
    var pending: Dictionary = scoring.duplicate(true)
    pending["due_tick"] = tick + gate_ticks
```

A clinch break scores nothing and has nothing to gate, so the zero is dead
code in effect. The value is harmless and changing it would not fix anything.

## Test results

- **grapple_resolve_test:** 7/7 PASS (29 checks, added grade→seat map test)
- **judge_panel_test:** 1/1 PASS
- **fight_realtime_test:** FAIL — pre-existing U34 work in `FightRealtime.gd`
  (another agent's incomplete judo contest board) causes parse errors at
  runtime: `_judo_decide_at_bell()` and `_judo_on_grapple()` not found. This
  is NOT caused by Q28 changes. The grapple and judge_panel tests pass; the
  realtime test failure is a separate task.

## Files touched

- `Godot/scripts/GrappleResolve.gd` — grade→seat map
- `Godot/tests/grapple_resolve_test.gd` — grade→seat map test
- `Godot/tests/fight_realtime_test.gd` — half occupation and sweep test
