# U142 digest — bottom-man ground chooser

**Branch:** `cursor/u142-bottom-man`  
**Change:** `# 4. THE BOTTOM MAN.` in `_grapple_ground` calls `_choose_ground_edge_for_actor(..., "bottom", ...)` when `_ground_graph_on`; rescales the existing bottom gate roll (no fifth draw); `position_resolve` with `p_mod`; ladder fallback when no legal edge; edge tally matches top chooser. Guard stand-ups and half sweeps still use the shipped ladder (no bottom edges from those seats).

## Gates

- `check_scripts.py` FightRealtime.gd: fails=0
- `run_tests.py --only ground_arm_wiring`: fails=0
- `run_tests.py --only ground_graph`: fails=0
- `run_tests.py --only grapple`: fails=0

## S58 (`tools/s58_ground_arms.gd`) — before (master FightRealtime) vs after (U142)

**Control arm (`current`) — MATCH line (verbatim, both runs):**

```
   MATCH, integer for integer: seat ticks, control units, exits, methods, side entries, the gate and the spells.
```

`current` / `decay` seat shares and spell exits are byte-identical before and after (e.g. ground_t 140158; guard 27.34%; stand_up 71; stall 6).

### Seat share (ground ticks)

| arm | ground_t | guard | half | side | mount | back |
|-----|----------|-------|------|------|-------|------|
| current | 140158 | 27.34% | 6.45% | 28.23% | 37.86% | 0.11% |
| decay | 140158 | 27.34% | 6.45% | 28.23% | 37.86% | 0.11% |
| graph (before) | 153381 | 29.36% | 8.81% | 30.15% | 29.21% | 2.47% |
| graph (after) | 134896 | 28.37% | 8.94% | 28.70% | 32.43% | 1.57% |
| both (after) | 134896 | 28.37% | 8.94% | 28.70% | 32.43% | 1.57% |

### Edge tally (graph arm)

**Before:** 9 top edges only (613 decisions); no `mount_escape` / `side_escape`.

**After:** 11 edges, 882 decisions; bottom-actor edges appear:

- `mount_escape` 209 (23.7%)
- `side_escape` 169 (19.2%)

### How a ground spell ends

| arm | before | after |
|-----|--------|-------|
| current | round_or_bout_end 67, stand_up 71, stall 6 | unchanged |
| graph | stand_up 83, round_or_bout_end 59, stall 5 | stand_up **77**, round_or_bout_end 59, stall **6** |

`stand_up` on the control arm did **not** collapse (still 71). Graph-arm `stand_up` dropped 83→77 because mount/side escapes now route through the chooser (`p_mod` on success) instead of only the ladder; guard wall-walks are unchanged (still ladder-only).

## Honest finding

With today’s authored bottom edges (`mount_escape`, `side_escape` → guard), the bottom man **chooses** on mount and side only; guard/half/back still have no bottom edges, so behaviour there remains the ladder. The meaningful movement is in graph/both tallies and ground dynamics, not in manufacturing new edges.
