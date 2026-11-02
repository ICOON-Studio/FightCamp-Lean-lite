Q69 pairs=23 safe=14 needs_merge=0 not_a_duplicate=5
Q69 colliding_nodes=0 magnitude_at_risk=0.0
Q69 unread_keys_before=52 unread_keys_after=42

Measured against the v6 catalog (696 nodes with effects, 139 distinct keys).
All counts derived by `Godot/tools/_q69_measure_collisions.py` reusing the
same `collect_catalog_effects` walk as `audit_technique_effects.py`.

## Collisions

**None.** Zero of the 19 surviving rename pairs has a single node that carries
both the old key and the new key. `nodes_with_both` is 0 for every row. The
operator's ruling — "no behaviour change, no verdict movement" — holds as
stated for the 14 SAFE pairs.

`magnitude_at_risk` is 0.0. No technique loses magnitude from a naive rename.

## Four keys already gone

`close_range`, `counter_risk`, `followup_open` and `return_damage` from U59's
original 23 are no longer in the catalog. They were removed during the S1
catalogue merge (v5 → v6, 272 → 696 nodes). Their rows read
`nodes_with_old=0` and verdict `SAFE` — there is nothing to rename and nothing
to collide. They are counted in the 14 SAFE.

## Five pairs that are NOT duplicates

U59's triage is a starting point. Five of the 23 pairs map old keys onto new
keys that do not mean the same thing. They should NOT be renamed onto their
proposed targets:

1. **`body_score` → `control_score`** (1 node: `tkd_apchagi`). Body score is
   point-scoring with body techniques in a TKD ruleset. Control score is
   dominance and pace. Different ideas — one is a hit, the other is a fight
   pattern.

2. **`counter_score` → `control_score`** (1 node: `sanda_inside_sweep`).
   Counter score is point-scoring with a counter action. Same reasoning as
   above — scoring with a counter is not the same as controlling the fight.

3. **`distance_reset` → `distance_read`** (1 node: `tkd_cut_kick`). Distance
   reset is an ACTION — re-establishing range after an exchange. Distance read
   is PERCEPTION — reading the opponent's range. One is doing, the other is
   seeing. Different attributes feed them.

4. **`kick_ready` → `check_readiness`** (1 node: `tkd_stance`). Kick ready
   means the stance is loaded to launch kicks. Check readiness means the
   stance is loaded to check (verify or defend). Different readiness targets.

5. **`kick_speed` → `entry_speed`** (1 node: `tkd_dollyochagi`). Kick speed is
   the velocity of the kick technique itself. Entry speed is the velocity of
   closing distance. A fast kick from a static stance is not the same thing as
   fast footwork entering range.

These five keep their current keys. They remain in the unread set and need
their own operator ruling — either a correct rename target or a wiring into a
new mechanic.

## The 14 SAFE pairs, in application order

Order does not matter for correctness — every pair is key-disjoint on the
target side (no node carries the new key AND the old key simultaneously, so no
rename can create a second collision). The safe application order is
alphabetical by old_key, which is also the order in the CSV:

1. `angle_read` → `angle_attack` (1 node)
2. `angle_reset` → `angle_exit` (1 node)
3. `boundary_score` → `boundary_control` (1 node)
4. `close_damage` → `clinch_damage` (1 node)
5. `combo_accuracy` → `accuracy` (2 nodes)
6. `counter_accuracy` → `accuracy` (2 nodes)
7. `distance_mastery` → `distance_read` (1 node)
8. `kick_accuracy` → `accuracy` (31 nodes)
9. `precision` → `accuracy` (3 nodes)
10. `return_angle` → `angle_exit` (2 nodes)
11. `rhythm_setup` → `rhythm` (1 node)
12. `straight_damage` → `damage` (32 nodes)
13. `tempo` → `rhythm` (2 nodes)
14. `turning_bonus` → `turn` (1 node)

Four old keys that U59 named (`close_range`, `counter_risk`, `followup_open`,
`return_damage`) are already absent from the v6 catalog — no action needed.

## Multiple old keys sharing one new key

Five new keys receive more than one old key. This is safe (no collisions) but
worth noting for the rename script:

- `accuracy` ← `combo_accuracy`, `counter_accuracy`, `kick_accuracy`, `precision`
- `angle_exit` ← `angle_reset`, `return_angle`
- `control_score` ← (both old keys are NOT_A_DUPLICATE, so no rename applies)
- `distance_read` ← `distance_mastery` (distance_reset is NOT_A_DUPLICATE)
- `rhythm` ← `rhythm_setup`, `tempo`

No node carries more than one of the old keys that map to the same new key,
so the renames are all one-to-one in practice.
