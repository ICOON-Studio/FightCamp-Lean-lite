# Q143 — CONTROL RESOLUTION CENSUS

**Read-only investigation. No `.gd` file was edited.**

## How I searched

1. `grep control_units` across `Godot/` — 134 hits. Most are documentation, research digests, or the task file itself.
2. `grep "kind".*"control"` — found every emitter and test fixture that writes a control event.
3. `grep "units"` inside `Godot/scripts/` — found the four engine scripts that read the `units` field off a log event.
4. `grep control_score`, `grep control_owner`, `grep .get\(.control_units.` — traced the accumulated value downstream into scorecards, causation bullets, and post-fight reads.
5. Read `GrappleSeat.gd` whole, `GroundGraph.gd` windows around `control_units_decayed`, `RealtimeRoundStats.gd` around the fold, `BroadcastRead.gd` around the grapple fold, `PostFightRead.gd` around the grapple read, `FightCausation.gd` around the control bullet, and every test file that hardcodes `units`.

## The value's path

```
GrappleSeat.control_units(stance, seat, has_top) -> int     # returns 0, 1 or 2
        │
        ▼
FightRealtime.gd:4620   units = Graph.control_units_decayed(units, ...)
        │                 (integer decay, floor 1)
        ├── state["control_units"] += units        (witness counter, line 4625)
        └── log event: {"kind":"control", "units": units}   (line 4627)
                │
                ├── RealtimeRoundStats.gd:162   units / 80.0 → control_score (float)
                ├── RealtimeRoundStats.gd:179   same, ABC-only path
                ├── BroadcastRead.gd:208        _as_int(units) → row sum (int)
                ├── s58_ground_arms.gd:188      int(units) → per-seat sum
                ├── s56_ground_exits.gd:191     int(units) → per-seat sum
                └── q142_training_record.gd:231 float(units) → float sum
```

Downstream of the broadcast accumulation:

```
BroadcastRead row["control_units"] (int)
        │
        ├── BroadcastRead.gd:236   str(int(row)) → printed["control_units"]
        │       │
        │       ├── PostFightRead.gd:122   int(side.get("control_units")) → comparison
        │       ├── PostFightRead.gd:167   str(printed.get("control_units"))
        │       └── FightCausation.gd:240  int(...) → diff vs CONTROL_UNITS_DIFF_MIN=3
        │
        └── (state["control_units"] is a witness; nothing reads it from the final state)
```

`control_score` (the float, already divided by 80):

```
RealtimeRoundStats stats["control_score"] (float)
        │
        ├── FightRealtime.gd:1699   detail["control_a"] → judges
        └── RoundScoring.gd:84      w["control"] * control_score → round points
```

---

## 1. WHO READS IT

### Engine scripts

| File:line | What it does | Int/float | Scale-sensitive? |
|---|---|---|---|
| `FightRealtime.gd:4625` | `state["control_units"] = int(...) + units` | int accum | No (witness only, never read back) |
| `FightRealtime.gd:4627` | Emits `"units": units` on log event | int payload | Yes (all downstream reads this) |
| `RealtimeRoundStats.gd:162` | `float(event.get("units",0)) / 80.0` → `control_score` | float | **YES** — 10x units = 10x control_score |
| `RealtimeRoundStats.gd:179` | Same formula, ABC adapter path only | float | **YES** — same |
| `BroadcastRead.gd:208` | `int(row) + _as_int(event.get("units",0))` | int | **YES** — `_as_int` truncates floats |
| `BroadcastRead.gd:236` | `str(int(row["control_units"]))` → printed | int→str | Truncates |
| `PostFightRead.gd:122-123` | `int(side.get("control_units",0))` → owner comparison | int | Comparison safe; magnitude wrong |
| `PostFightRead.gd:167` | `str(printed.get("control_units", dash))` | str pass-through | Inherits truncation |
| `FightCausation.gd:240-242` | `int(...)` → diff vs `CONTROL_UNITS_DIFF_MIN = 3` | int | **YES** — threshold assumes scale |
| `FightCausation.gd:246` | `"%d control units to %s's %d"` | %d format | Prints wrong magnitude |
| `RoundScoring.gd:84` | `w["control"] * control_score` → round points | float | **YES** — inherits 10x from RRS |
| `GroundGraph.gd:271` | `control_units_decayed(2, ...)` — literal `2` | int | **YES** — hardcoded flat value |

### Tools (measurement scripts, not engine)

| File:line | What it does | Int/float | Scale-sensitive? |
|---|---|---|---|
| `s58_ground_arms.gd:188` | `int(event.get("units",0))` → per-seat sum | int | **YES** — truncates floats |
| `s58_ground_arms.gd:495` | `var u: int = _total(...)` → `%d` print | int | Truncates |
| `s56_ground_exits.gd:191` | `int(event.get("units",0))` → per-seat sum | int | **YES** — truncates floats |
| `q142_training_record.gd:231` | `float(event.get("units",0.0))` → float sum | **float** | **Safe** — already float-ready |
| `q142_training_record.gd:309` | `"%12.0f"` display | float fmt | Safe |

### Tests with hardcoded values

| File:line | What it hardcodes | Would break? |
|---|---|---|
| `grapple_seat_test.gd:93-103` | `== 1`, `== 2`, `== 0` on `control_units()` return | **YES** if return type changes |
| `grapple_contract_test.gd:76-88` | Same assertions | **YES** |
| `ground_graph_contract_test.gd:87` | `typeof(...) != TYPE_INT` | **YES** if return becomes float |
| `ground_graph_contract_test.gd:70-93` | `flat: int = 100`, integer comparisons throughout | **YES** if decay goes float |
| `post_fight_read_test.gd:123` | `str(g["b"]["control_units"]) == "4"` | **YES** — string match on magnitude |
| `post_fight_read_test.gd:109-110` | Fixture `"units": 2` | Fixture data, not an assertion — but the expected `"4"` above depends on it |
| `post_fight_read_test.gd:135` | Fixture `"units": 3` | Same |
| `post_fight_read_test.gd:154-155` | Fixtures `"units": 5`, `"units": 1` | Same |
| `fight_beat_grapple_test.gd:151` | Fixture `"units": 2` | No assertion on magnitude — safe |
| `fight_causation_test.gd:89-90` | Fixture `"units": 4` | No assertion on control magnitude — safe |
| `fight_causation_test.gd:145-146` | Fixture `"units": 5` | Same — safe |

### JSON regression fixtures

| File | What it stores | Would break? |
|---|---|---|
| `S58_ground_arms.json` | Per-seat control totals (e.g. `"mount": 2948`) | **YES** — `s58_ground_arms.gd:267` compares arm vs recorded integer-for-integer |
| `S56_ground_exits.json` | Per-seat control totals | **YES** — same comparison pattern |

### Adapter tariff (not a numeric consumer)

| File:line | What it does | Scale-sensitive? |
|---|---|---|
| `GrappleAdapter.gd:51` | `"control_units": "not_scored"` | No — this is a label, not a number |

---

## 2. WHICH READERS ASSUME AN INTEGER

Every reader in the engine path assumes int except `q142_training_record.gd`:

- **`_as_int()` cast**: `BroadcastRead.gd:280` — `return int(value)`. Truncates any fractional part.
- **`int()` cast**: `PostFightRead.gd:122-123`, `FightCausation.gd:240-241`, `s58_ground_arms.gd:188`, `s56_ground_exits.gd:191`.
- **`%d` format**: `FightCausation.gd:246`, `s58_ground_arms.gd:495`.
- **`str(int(...))` chain**: `BroadcastRead.gd:236`.
- **`TYPE_INT` assertion**: `ground_graph_contract_test.gd:87`.
- **`== N` literal comparisons**: `grapple_seat_test.gd:93-103`, `grapple_contract_test.gd:76-88`.
- **String equality on printed value**: `post_fight_read_test.gd:123` — `== "4"`.
- **Accumulator typed `int`**: `s58_ground_arms.gd:495` (`var u: int`), `BroadcastRead.gd:179` (`"control_units": 0`).

The one reader that is already float-safe: `q142_training_record.gd:166,231` — declares `control_units: float`, accumulates with `float()`, prints with `%12.0f`.

---

## 3. WHICH READERS ASSUME A SCALE

These break even if the value stays an integer but becomes 10x larger:

| Reader | Why scale matters |
|---|---|
| `RealtimeRoundStats.gd:162,179` | Divides by `CONTROL_UNITS_PER_POINT = 80.0`. 10x units → 10x `control_score` → 10x contribution to round points via `RoundScoring.gd:84`. A minute of mount goes from 4.5 pts to 45 pts. |
| `FightCausation.gd:242` | `CONTROL_UNITS_DIFF_MIN = 3`. At 10x resolution a 3-unit gap (1.5 seconds of mount) is trivial noise, not floor ownership. |
| `GroundGraph.gd:271` | `control_units_decayed(2, ...)` passes literal `2`. At 10x resolution the flat value for mount is 20, not 2. The decay curve and `hold_value = float(decayed) / 2.0` normalisation both break. |
| `s58_ground_arms.gd:267` | Compares arm output to `S58_ground_arms.json` recorded values integer-for-integer. Every recorded number is at the old scale. |
| `S56_ground_exits.gd` | Same pattern — compares to `S56_ground_exits.json`. |
| `post_fight_read_test.gd:123` | `str(...) == "4"` — the expected string is at the old scale. |

---

## 4. SMALLEST CHANGE THAT WOULD WORK

### Option (b): integers ten times larger, display divided at the edge

This is the smaller diff. `GrappleSeat.control_units` returns 10/20 instead of 1/2, `GroundGraph.control_units_decayed` stays integer throughout, and every reader that *displays* or *compares* the value divides by 10 at the edge.

**Files touched (engine only):**

1. `GrappleSeat.gd` — return 10/20 instead of 1/2
2. `GroundGraph.gd` — `CONTROL_FLOOR` from 1 to 10; `score_edge` literal `2` → `20`; `hold_value` divisor `2.0` → `20.0`
3. `RealtimeRoundStats.gd` — `CONTROL_UNITS_PER_POINT` from 80.0 to 800.0
4. `BroadcastRead.gd` — no change needed (int accumulation still works; the printed number is 10x bigger but that is the point)
5. `PostFightRead.gd` — `int()` casts still work; comparison (`>`) still works; `_grapple_line` receives 10x ints but only uses them for comparison, not display
6. `FightCausation.gd` — `CONTROL_UNITS_DIFF_MIN` from 3 to 30; `%d` prints 10x numbers (cosmetic)

**Files touched (tools):**

7. `s58_ground_arms.gd` — no code change; re-run to regenerate JSON
8. `s56_ground_exits.gd` — no code change; re-run to regenerate JSON
9. `q142_training_record.gd` — no change (already float)

**Files touched (tests):**

10. `grapple_seat_test.gd` — update 11 assertions
11. `grapple_contract_test.gd` — update assertions
12. `ground_graph_contract_test.gd` — `flat: int = 100` → `1000`; `TYPE_INT` assertion still passes
13. `post_fight_read_test.gd` — update fixture `units` values and expected string `"4"` → `"40"`

**Riskiest file: `GroundGraph.gd`.** It is the one place where the flat value is hardcoded as a literal (`2` at line 271) AND the decay arithmetic AND the normalisation divisor (`/ 2.0`) all live in the same function. Missing one of the three silently changes the edge-selection curve.

### Option (a): floats all the way through

Larger diff. Every `int()` cast, every `TYPE_INT` assertion, every `%d` format, every `int` accumulator must change. The `control_units_decayed` return type changes from `int` to `float`, which ripples through `GroundGraph.score_edge` and every test that asserts `TYPE_INT`. The advantage is that fractional decay steps become expressible; the cost is touching ~25 sites instead of ~10.

### Option (c): document the cliff as intended

The resolution change is not free. The census shows 6 scale-sensitive readers in the engine, 2 JSON regression fixtures that must be regenerated, and 4 test files with hardcoded magnitudes. If the product ruling is that the cliff is acceptable — that half-guard simply cannot decay and dominant seats step from full to floor at a known gate — then the cheapest path is to **add a comment on `CONTROL_FLOOR` and `control_units_decayed` naming the arithmetic constraint** (the two-integers-between-value-and-floor problem from the task file) and leave the resolution alone.

That is a legitimate answer. The cliff is measurable, the step point is reproducible, and every reader in the codebase is consistent at the current scale. The cost of changing it is real and the benefit is one extra gradation step on a counter the judges already see as a single number.

---

## What I might have missed

- **`FightSimulation.gd`** has its own `control_score` accumulation (lines 2247, 2263) but it uses `magnitude * execution_quality`, not `GrappleSeat.control_units`. It is a parallel code path (Stage A simulation, not the realtime engine) and does not consume the same value. I did not trace it further because it is not on the `control_units` data path.
- **`FightHudPanel.gd`** does not display control units at all — it shows heart rate, knockdowns, regions, trauma, submissions. No control read.
- **`GameState.gd`** was not searched beyond grep hits. At 14,000+ lines I read only the grep match at line 10327 (a text template, not a numeric consumer).
- **UI panels and result screens** that might display `control_units` from the broadcast were not exhaustively enumerated. `PostFightRead.gd` is the known consumer; if any panel reads the broadcast's `printed["control_units"]` directly it inherits the `str(int(...))` truncation from `BroadcastRead.gd:236`.
- **The `control_units` field on `state` in FightRealtime** (line 1061, 4625) appears to be a witness counter only — no reader was found that pulls it from the final state. If something reads it that I missed, it would hit the same `int()` truncation as every other reader.
