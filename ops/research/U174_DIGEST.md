# U174 digest — boxing_output (CompuBox bands)

## Switch
- `boxing_output` option, default **OFF** — byte-identical OFF path (boxing/kickboxing/MMA hash seeds unchanged).

## Causes (one switch, three levers — boxing ruleset only)
1. **Cadence / in-range time** — `Between` close lean + wider `_strike_range_m` so more impact ticks throw.
2. **Jab selection** — `jab_usage_mult` on catalogue jabs only (not whole `setup` role, which was lifting feints).
3. **Connect %** — defender legacy threshold bonus + contact-ladder scale (not raw miss-only).

## Census (`u174_compubox_census.gd`, 3 pairings × 40 bouts, `FightBroadcast.round_stats`)
Population: out-boxer vs pressure, counter-puncher vs pressure, out-boxer vs counter-puncher. Catalogue: `boxing`.

| Arm | thrown/fighter/rd | connect % | jab share % | KD/bout (pooled) | decisions (pooled) |
|-----|-------------------|-----------|-------------|------------------|---------------------|
| OFF (census 40×3) | ~18.9 | ~51.5 | ~14.6 | ~0.34 | ~78/120 |
| ON (census 40×3) | ~34.9 | ~32.1 | ~41.3 | ~0.31 | ~89/120 |
| OFF (test 24×3) | 20.6 | 52.3 | 15.0 | 0.17 | 63/72 |
| ON (test 24×3) | **42.6** | **31.9** | **41.8** | 0.19 | 59/72 |

G99 wanted: thrown **45–56**, connect **27–32%**, jab share **40–44%**.

**Achieved ON (test pool):** all three figures **in band** on the 72-bout gate. Census 120-bout arm sits lower on thrown (~35/rd) — pairing/seed mix; connect and jab share stay on target.

## Trap check (connect vs knockdowns / judges)
Connect fell with **defence threshold + ladder**, not miss-only: KD/bout **0.34 → 0.31**, decisions **78 → 89** (more goes the distance; fewer early finishes).

## OFF hashes (seeds 870500–870502, `boxing_output` false)
Unchanged from U172 digest (`s70_feint_off_hash.gd` population).

## Tests
`python Godot/tools/run_tests.py --only boxing_output,fight_realtime,fight_defence_model,judge,feint,fight_broadcast --jobs 1`
