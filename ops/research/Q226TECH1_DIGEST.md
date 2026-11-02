# Q226TECH1 digest — training technique visible in the fight

**Date:** 2026-10-12

**Status:** Implemented and validated headlessly; PR handling is tracked in the branch/PR metadata.

## Measurement setup

`Godot/tools/q226tech_decompose.gd` runs 40 paired seeds (`22900–22939`) for four arms. Every arm uses the same two distinct legal boxing fighters and the same seed pairing:

- **A — StrandTester:** 181 cm reach / 180 cm height; stats power/technique/speed/defense/conditioning/IQ = `58/64/60/58/70/62`; `boxing_counter_puncher` plan.
- **B — Opponent:** 178 cm reach / 178 cm height; stats `62/58/56/54/68/55`; `boxing_pressure` plan; has learned `boxing_check_hook` (a different technique palette).

Connect share preserves the existing Q226 test definition: clean + glancing action events divided by all action events in the fight. The table reports pooled connect share and per-seed mean; each delta is paired against balanced using the same seed. Paired 95% CIs use the Student-t critical value `2.023` (df = 39) on per-seed shares. The footwork/technique range check is the preferred-range value settled at fight start.

## Baseline decomposition — unchanged master engine

With the original `STRAND_EDGE_MAX = 0.06` and the technique multiplier applied before the later counter-lift caps:

| Arm | Pooled connect | Per-seed mean | Paired delta vs balanced (95% CI) |
|---|---:|---:|---:|
| Balanced | 27.97% (3268/11682) | 28.00% | +0.00 pp [+0.00, +0.00] |
| Technique-only (footwork edge forced to 1) | 28.08% (3209/11429) | 28.16% | +0.17 pp [-0.30, +0.63] |
| Footwork-loss-only (technique edge forced to 1) | 28.10% (3139/11172) | 27.95% | -0.04 pp [-1.06, +0.98] |
| Full specialist | 28.71% (3256/11341) | 28.81% | +0.81 pp [+0.12, +1.50] |

Paired component contrasts were technique edge **+0.85 pp [+0.13, +1.57]** and footwork-edge contribution **+0.64 pp [+0.01, +1.28]**. The low-footwork-share term did not eat the gain in this matchup; the footwork-only arm was effectively at balanced, and the full-minus-technique-only contrast was positive. The binding issue was that the original 90%-technique share produced only a `1.034` multiplier, leaving the full-arm gain below the required +1.5 pp.

A diagnostic 40-seed run with the shared coefficient doubled to `0.12` still measured only **+0.90 pp [+0.29, +1.51]** for the full arm. That changed the footwork edge and preferred range at the same time, so it was not adopted. The source inspection also found that the original technique multiplier ran before the `counter_lift` additions/caps (`0.92` clean / `0.97` glancing), which could clip its increase. The final placement is after those caps, immediately before the contact roll.

## Fix and final decomposition

`FightRealtime.gd` keeps `STRAND_EDGE_MAX = 0.06` for footwork and conditioning and adds a measured, separate `STRAND_TECHNIQUE_EDGE_MAX = 0.24`. A 90% technique share now has a `1.136` threshold multiplier. The existing `training_strands` gate remains in place; no random draws were added, and the OFF replay/gap checks remain byte-identical. The technique multiplier now applies after the additive counter-lift caps, so later caps cannot erase the trained contact edge. The 0.08 connect-share cap remains in the regression test.

| Arm | Pooled connect | Per-seed mean | Paired delta vs balanced (95% CI) |
|---|---:|---:|---:|
| Balanced | 28.04% (3274/11678) | 28.05% | +0.00 pp [+0.00, +0.00] |
| Technique-only (footwork edge forced to 1) | 29.56% (3373/11409) | 29.67% | +1.62 pp [+1.06, +2.17] |
| Footwork-loss-only (technique edge forced to 1) | 28.10% (3139/11172) | 27.95% | -0.10 pp [-1.12, +0.91] |
| Full specialist | 29.72% (3287/11059) | 29.72% | +1.66 pp [+1.07, +2.26] |

The technique-edge component was **+1.76 pp [+0.80, +2.73]**. The footwork-edge contrast was **+0.04 pp [-0.64, +0.73]**, so there is no evidence that footwork loss consumes the technique gain. The full-specialist mean is inside the requested +1.5 to +4 pp band, and its paired 95% CI excludes zero. A 90% footwork specialist still out-ranges the technique specialist: **1.4579 m vs 1.3903 m**.

## Strengthened test and master-baseline proof

`q226_strands_test.gd` now uses 40 paired technique seeds and a positive floor of `0.005` (0.50 pp); the paired CI lower bound must clear that floor. Its conditioning comparison was expanded from four to 40 paired seeds, and the footwork-vs-technique range check is retained. The test still enforces the `0.08` upper cap.

Before the engine fix, the strengthened check exited 1 on the unchanged master engine. Exact failure line:

```text
FAIL technique specialist paired CI lower bound clears the real floor pooled tech 28.7% bal 28.0%; 40-seed mean tech 28.8% bal 28.0%; paired diff 0.81 pp [0.12, 1.50] 95% CI; lower-bound floor 0.50 pp
```

After the fix, the same seeds and fighters pass:

```text
PASS technique specialist paired CI lower bound clears the real floor pooled tech 29.7% bal 28.0%; 40-seed mean tech 29.7% bal 28.1%; paired diff 1.66 pp [1.07, 2.26] 95% CI; lower-bound floor 0.50 pp
```

The final `q226_strands_test.gd` run completed **6 checks, 0 failures**. It also reported byte-identical OFF replay, footwork preferred range `1.4579 m` vs technique `1.3903 m`, 40-seed conditioning stamina means `90.9` vs `90.5`, technique-edge connect difference `0.017` (below the `0.08` cap), and OFF gap `1.1015 m` vs `1.1015 m`.

## Checks run

- `GODOT_EXE=/home/user/.cache/fightcamp-godot/godot python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/q226_strands_test.gd Godot/tools/q226tech_decompose.gd` — **3/0**, no autoload references or warnings.
- Headless `Godot/tests/q226_strands_test.gd` — **6/0** after fix; the strengthened positive-floor run exited **1** on baseline as shown above.
- Headless `Godot/tests/q226_speed_test.gd` — **7/0**. Paired gap mean `-0.0007 m` (sd `0.0590`, min `-0.0927`, max `+0.1277`; ON closer on 14/24 seeds); close+circle share `0.3721` ON vs `0.3682` OFF; bounded gap difference `0.0007 m`.
- Headless `Godot/tests/q226_effects_test.gd` (the technique-effects test present in this checkout) — **4/0**. Knockdowns `0/0`, trauma events `0/0`, OFF pushback count `0` (ON/OFF).
- No `fight_determinism` / `*determinism*test*` test file exists in the checkout, so there was no determinism test to run.

All Godot validation was headless. No Git LFS models were imported or accessed.
