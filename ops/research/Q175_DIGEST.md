# Q175 DIGEST — LAND THE CLINCH WORK (Q173 + Q174)

## Pass 3: landing order settled with pooled 4-seed-set sample

### Decision: floor UNREACHABLE without breaking defence_model landing order

Pooled landing-rate measurement over 4 disjoint seed sets (64 bouts each = 256 total),
same population as fight_defence_model_test (mma_grappler vs mma_striker), defence_model ON.

#### At CLINCH_ENGAGE_BASE = 0.0050 (current)
```
POOLED  att h=24834 b=17291 l=1817  land h=13016 b=9236 l=968
POOLED  head_lr=0.5241  body_lr=0.5342  leg_lr=0.5327
POOLED  leg_lr - body_lr = -0.0014  95%% CI [-0.0255, 0.0227]
VERDICT  CI straddles zero
```
Time share: 10.07%% (below 10.36%% floor)
Test at 64 bouts (seeds 172000-172063): FAIL — head 0.525 < body 0.540 > leg 0.534

#### At CLINCH_ENGAGE_BASE = 0.0055
```
POOLED  att h=25075 b=17185 l=1819  land h=13155 b=9144 l=972
POOLED  head_lr=0.5246  body_lr=0.5321  leg_lr=0.5344
POOLED  leg_lr - body_lr = 0.0023  95%% CI [-0.0218, 0.0264]
VERDICT  CI straddles zero
```
Time share: 10.78%% (above 10.36%% floor)
Test at 64 bouts (seeds 172000-172063): FAIL — head 0.523 < body 0.541 > leg 0.539

#### Root cause
U173 defender slice 2 (commit a080c40b) changed FightDefenceModel.gd and FightRealtime.gd
(anticipate/pre-empt + counter windows). This flattened the landing rates:
- origin/master (0.0020): test PASSES — head 0.529 < body 0.536 < leg 0.543
- My branch (0.0050): test FAILS — head 0.525 < body 0.540 > leg 0.534

The higher engage rate (0.0050 vs 0.0020) combined with the U173 slice 2 changes breaks
the landing order. More clinch entries = less distance time = fewer leg attempts = leg LR
regresses toward body LR.

#### Test seed range probe (4 sets at 172000+)
At 0.0050: leg_lr - body_lr = -0.0135, CI [-0.0372, 0.0101] — all 4 sets show leg <= body
At 0.0055: leg_lr - body_lr = -0.0125, CI [-0.0369, 0.0118] — all 4 sets show leg <= body

### What shipped
- CLINCH_ENGAGE_BASE kept at 0.0050 (from pass 2)
- Measurement tool committed: q175_landing_rate_pooled.gd
- Test NOT modified (assertion kept as-is per task instruction)

### Tests
- fight_defence_model_test: FAIL (landing order — regression from U173 slice 2 + engage rate)
- fight_realtime: PASS
- judge: PASS
- fight_pace: PASS
- feint: PASS
- grapple: pre-existing FBX asset FAIL (unrelated)

---

## Pass 1 + pass 2 (accepted findings)

1. **Boxing/kickboxing hold behind `boxing_hold` option (default OFF)**. With it OFF,
   boxing and kickboxing hashes are byte-identical to origin/master. MMA hashes differ
   (Q173 clinch duration changes).

2. **Leg floor re-pinned 6%%->4.5%%**. Denominator-only drop (leg/min distance 0.75->0.73, -2.7%%).

3. **CLINCH_SIG_RATIO 0.80 labeled PROXY** (J21 D5 FightMetric).

4. **Bell-break fix** (pass 2): boxing hold 6.78s -> 5.02s (K38 4-7s band).

5. **Measurement tools committed**: q175_measure_hold.gd, q175_landing_rate_pooled.gd.

### Hold measurement (pass 2: non-identical population, 20 bouts)
| Ruleset | OFF holds/bout | ON holds/bout | ON mean hold |
|---------|---------------|--------------|-------------|
| Boxing | 0.00 | 9.65 | 5.02s (K38 4-7s band) |
| Kickboxing | 0.00 | 3.70 | 3.00s (one-strike rule) |
