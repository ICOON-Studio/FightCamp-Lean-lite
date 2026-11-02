# Q150 DIGEST — U143 collected against Q147 blind test

Branch: `qwen/q150-u143-check` (octopus merge of `origin/cursor/u143-name-the-control` + `origin/qwen/q147-named-and-legal` onto `origin/master`)

## BEFORE / AFTER table

| Metric | BEFORE (master+q147) | AFTER (+U143) | Delta |
|---|---|---|---|
| **Clause 1** coverage pass (>=85%) | 1/7 (mma only) | 3/7 (bjj, sambo, mma) | +2 rulesets |
| judo | 12.2% | 78.9% | +66.7pp |
| freestyle_wrestling | 51.7% | 1.6% | **-50.1pp** |
| greco_roman | 54.4% | 1.1% | **-53.3pp** |
| bjj | 49.4% | 94.6% | +45.2pp |
| sambo | 64.5% | 89.4% | +24.9pp |
| muay_thai | 0.0% | 65.7% | +65.7pp |
| mma | 97.6% | 97.1% | -0.5pp |
| **Clause 2** learned | PASS (0) | PASS (0) | — |
| **Clause 3** legal ruleset | PASS (0) | PASS (0) | — |
| **Clause 4** phase violations | 205 | 43 | -162 |
| **Clause 5** stalls unnamed | PASS (0) | PASS (0) | — |

## Q148 verdict split BEFORE vs AFTER

| Verdict | BEFORE | AFTER |
|---|---|---|
| A (stale phase / engine) | 69 | **0** |
| B (wrong field) | 0 | 0 |
| C (catalogue error) | 136 | **43** |
| Total | 205 | 43 |

## Q148 tool group-sum check (AFTER)

- Takedown group: 27
- Throw group: 16
- **Sum: 43 = total 43. Match: true.**

## Collisions (test vs U143 disagree)

**Clause 1 — freestyle_wrestling and greco_roman collapsed.** U143's naming changes
fixed bjj/sambo/judo/muay_thai coverage but destroyed freestyle (51.7% -> 1.6%) and
greco (54.4% -> 1.1%). The new names U143 added do not cover the techniques those
rulesets fire. Neither branch broke the other — the test was blind before, and U143's
names are ruleset-scoped; the collision is that freestyle/greco were already below 85%
in the blind test and U143 made them much worse.

**Clause 4 — 43 verdict-C violations remain.** All 43 are catalogue errors: techniques
tagged `standing`/`clinch` only, fired on ground-phase events (takedowns and throws
landing). Zero verdict-A (stale phase) remain — U143's FightRealtime.gd changes fixed
all 69 engine-defect violations. The remaining 43 are not an engine fix; they need
catalogue `phases` arrays to include `"ground"` for takedown/throw entries, or the
test's phase-inference logic needs adjusting for takedown-to-ground transitions.

## Filtered suite (AFTER)

- `--only grapple`: 11 total, 1 fail (contract test — expected, clauses 1+4 fail)
- `--only name`: 1 total, 0 fails
- `--only room`: 3 total, 0 fails

## Parse gate

`check_scripts.py` on FightRealtime.gd + grapple_naming_contract_test.gd: **0 fails**.
