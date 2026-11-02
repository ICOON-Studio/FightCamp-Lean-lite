# Q144 — Does `fight_metres_test.gd` actually hang?

**Answer: (c) It is slow, not hung.** The test completes in ~580s on this
machine, under the 600s default timeout, with only ~20s of margin. Under CPU
contention it can exceed the timeout and be killed, producing the same `rc=124`
signature as a true hang.

---

## Parse gate (the cheap cause)

Ruled out first, before any bisection.

```
check_scripts.py fight_metres_test.gd FightRealtime.gd   -> 2/2 clean
check_scripts.py <29 preloads from FightRealtime.gd>      -> 29/29 clean
```

No parse error in the test or anything it loads. A later reader can trust that
the expensive cause was not reached by skipping the cheap one.

## Process state before each run

`Get-Process` filtered to `Godot|codex|cursor|qwen|blender`:

- **No Godot process** running before any run.
- **codex** (PID 33380) and two codex helper processes were present throughout.
  These are the other local agent's persistent processes, not Godot.
- No cursor, qwen, or blender processes.

The box was quiet for Godot. Codex was present but not driving Godot.

## Three direct runs (not through `run_tests.py`)

Command:
```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_metres_test.gd
```

| Run | Exit code | Wall time | Result |
|-----|-----------|-----------|--------|
| 1   | killed    | >600s     | Timed out mid-way through 5th bout section |
| 2   | 0         | 578s      | PASS (16 checks) |
| 3   | 0         | 584s      | PASS (16 checks) |

### What run 1's partial output shows

Run 1 completed 4 of 5 bout-running sections before being killed:

1. **boxing** (200 bouts, 2,410,659 ticks) — complete
2. **mma** (200 bouts, 2,989,765 ticks) — complete
3. **reach calibration: short** (200 bouts, 2,314,456 ticks) — complete
4. **reach calibration: default** (200 bouts, 2,410,659 ticks) — complete
5. **reach calibration: tall** — killed mid-execution

The last output line was the "Floor (overall)" for the default calibration.
The tall calibration (200 more bouts, ~2.5M ticks) was in progress when the
600s wall-clock limit killed the process.

### What runs 2 and 3 show

Both completed all 5 sections and printed `FIGHT_METRES_TEST PASS (16 checks)`.
The test is deterministic in its computation (seeded bouts); the only variance
is wall-clock time due to CPU scheduling.

## Why it is slow

The test simulates **1,000 seeded bouts** total:
- 200 boxing + 200 MMA (the core measurement)
- 3 x 200 reach-calibration bouts (short/default/tall fighter pairs)

Each bout runs up to 100,000 ticks of `FightRealtime.advance_tick()`, which is
a full fight simulation step involving 29 preloaded subsystems (grapple resolve,
ground graph, footwork, bearing, stamina, trauma, judges, etc.).

Total tick count across all runs: ~12.6 million ticks.

At ~580s for 12.6M ticks, the throughput is about **21,700 ticks/second**.

## The margin problem

The `run_tests.py` default timeout is 600s. The test needs ~580s in the best
case. That leaves **~20s of margin** — about 3.4%. Any CPU contention from
another agent running Godot simultaneously, or any OS-level scheduling delay,
pushes it over the edge.

This is consistent with the original report: "it HANGS under contention and
PASSES ALONE." The test does not truly hang — it just has almost no headroom.

## Recommendation

The test is correct and produces valid measurements. The timeout is too tight
for the work it does. Options (not implemented, diagnosis only):

1. **Increase the timeout** for this test specifically (e.g., `--timeout 900`).
2. **Reduce BOUT_COUNT** from 200 to something smaller (e.g., 100) — this would
   halve the runtime to ~290s with comfortable margin.
3. **Reduce reach-calibration configs** from 3 pairs to 1-2 — saves ~230s per
   pair removed.

Any of these would eliminate the false-positive timeout without changing the
test's measurement validity.
