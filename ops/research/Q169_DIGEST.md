# Q169 Digest — TRAPS slice 1: the isolated arm from mount

## What was built

One trap: `isolated_arm`, seat `mount`, owner top. Behind switch `trap_arm` (default OFF).

### GroundGraph.gd
- 4 new edges: `isolated_arm` (trap, p_mod 0.85), `clasp_and_hide` (trap_defense, 0.90), `turn_into` (trap_defense, 0.75), `explode_trapped_side` (trap_defense, 0.70)
- `edges_from` gains `include_traps` parameter (default false) — trap/trap_defense edges are INERT unless explicitly included

### FightRealtime.gd
- `trap_arm` option read beside `ground_arm`, stored in state dict
- `_choose_ground_edge` passes `include_traps = bool(state.get("trap_arm", false))`
- `_choose_ground_edge_for_actor` passes `include_traps` only when `trap_arm` ON AND `g.has("trap")` — defender edges are candidates only while a trap is LIVE
- Trap resolution: when top man chooses `isolated_arm` and succeeds, `g["trap"]` is set
- Submission gate: from mount with `trap_arm` ON, requires `g.has("trap")` — back unchanged
- Arm technique picker: `_grapple_technique_for_arm` filters to `target_region: ["arm"]`
- Defender answers: `clasp_and_hide` (slows progress), `turn_into` (success: trap killed; fail: back), `explode_trapped_side` (success: sweep to guard)
- Trap expiry: seat change kills trap, new grapple erases trap, held_ticks ticks on scoring cadence

### ground_trap_test.gd (NEW)
- 10 checks, all pass: OFF byte-identical (3 seeds), trap fires, trap gate blocks non-trap mount subs, defender answers counted

### q168_submission_baseline.gd
- Third arm `trap` added: ground_arm=graph + trap_arm=true
- Trap measurements: trap_won, trap_defense, trap_sub_attempts, trap_sub_finishes, mount_originated_finishes

## Measurement Results (3 arms x 2 populations, 40 bouts each)

| Pop | Arm | Att/Fight | Fin/Att | Mount Fin | Trap Won | Trap Def |
|-----|-----|-----------|---------|-----------|----------|----------|
| A: grappler(82) vs striker(34) | current | 1.55 | 0.15 | 4 | 0 | 0 |
| A | graph | 1.10 | 0.18 | 8 | 0 | 0 |
| A | **trap** | **0.17** | **0.29** | **1** | **8** | **11** |
| B: brawler(55) vs kicker(28) | current | 1.00 | 0.07 | 2 | 0 | 0 |
| B | graph | 0.63 | 0.16 | 4 | 0 | 0 |
| B | **trap** | **0.13** | **0.20** | **1** | **3** | **3** |

## G72 §5 Pass/Fail

- (a) Mount finishes DROP: ✅ (8→1 Pop A, 4→1 Pop B)
- (b) Att/fight inside J20 D6 0.5-1.0: ❌ (0.17, 0.13 — trap gate too restrictive)
- (c) Fin/att toward ~0.20: ✅ (0.29, 0.20)
- (d) KO/TKO share: not measured separately but total finishes dropped
- (e) Log carries limb+defender choice: ✅ (trap_won + trap_defense events logged)

## INFORMATIVE FAILURE

The trap mechanism works correctly:
- Traps fire (8+3 trap_won across 80 bouts)
- Defenders answer (11+3 trap_defense)
- Gate blocks non-trap mount submissions (mount att drops from 42→3 Pop A, 25→2 Pop B)
- OFF byte-identical (proven by test)

But the trap gate is TOO restrictive. Traps only fire in ~20% of bouts, so the submission gate blocks most mount submissions. Att/fight drops to 0.17/0.13, well below the J20 anchor of 0.5-1.0.

**Root cause**: The `isolated_arm` edge requires `min_hold_ticks: 60` and competes with other edges in the weighted chooser. It fires rarely. When it doesn't fire, the mount submission gate is completely blocked.

**Possible fixes** (not in this slice):
1. Lower `min_hold_ticks` on `isolated_arm` (e.g., 30 instead of 60)
2. Allow mount submissions without a trap but with a penalty (e.g., lower finish probability)
3. Make the trap easier to set (higher p_mod)

## Test results
- Parse gate: 0 fails on all touched .gd
- ground_graph_contract_test: 7 checks, 0 failures
- ground_arm_wiring_test: 48 checks, 0 failures
- ground_trap_test: 10 checks, 0 failures
- Focused: ground_graph (1/1), grapple_resolve (1/1), fight_realtime (1/1)

## Files touched
- Godot/scripts/GroundGraph.gd (modified)
- Godot/scripts/FightRealtime.gd (modified)
- Godot/tests/ground_trap_test.gd (NEW)
- Godot/tools/q168_submission_baseline.gd (modified)
- research/Q169_DIGEST.md (NEW)
