# U194 digest — blind ground seat bands (cursor, S114)

Branch: `cursor/u194-ground-bands`. Test: `Godot/tests/fight_ground_bands_contract_test.gd`. Q209 not merged; **failing visit/style bands are expected** until visit log events land.

## Run (2026-09-27, pre-Q209)

`FIGHT_GROUND_BANDS FAILS=6` (135 MMA bouts + 16 non-MMA seeds). Mutant check: flipped `GRAPPLER_WIN_LO` to `0.99` locally → `FAILS=8` (two grappler-win bands that had passed now fail); mutant not committed.

## Band table (achieved vs wanted)

| Band | Wanted | Achieved | Pass? |
|---|---|---|---|
| Boxing/kickboxing ground-seat events | 0 | 0 | yes |
| Guard visit median (pooled) | 6–20 s | 0.0 s (n=0) | **no** |
| Half visit median | 5–18 s | 0.0 s (n=0) | **no** |
| Side visit median | 8–24 s | 0.0 s (n=0) | **no** |
| Mount visit median | 6–20 s | 0.0 s (n=0) | **no** |
| Submission bouts (all MMA pops) | 10–30% | 15.6% (21/135) | yes |
| BJJ vs striker — grappler (A) wins | 55–80% | 55.6% | yes |
| Wrestler vs striker — grappler (A) wins | 55–80% | 71.1% | yes |
| BJJ-primary winner sub share | > wrestler-primary | 27.7% vs 15.1% (47 vs 53 wins) | yes |
| Wrestler bottom: stand-ups > sweeps | stand > sweep | 0 vs 0 | **no** |
| BJJ bottom: sweeps+subs > stand-ups | sweep+sub > stand | 0 vs 0 | **no** |
| Visit pairing | every start has end or bout ends inside | 0 violations | yes |

## Populations (named)

1. **BJJ vs striker** — A: `discipline=bjj`, `mma_submission_grappler`, grapple 86; B: striker, grapple 35, `untrained` takedowns/subs.
2. **Wrestler vs BJJ** — A: `discipline=wrestling`, `mma_wrestle_gnp`, grapple 81; B: BJJ as above.
3. **Wrestler vs striker** — A: wrestler; B: striker (reach 188 cm).

## Exit vocabulary (seat_end `to`)

No `guard_end` / `half_end` / `side_end` / `mount_end` events in the log yet — empty `{}`. Style buckets when Q209 lands:

- **stand**: `standing`, `none`, `stand_up`, `stall`, `ref_stand`, `stands_clean`, `wall_walk`
- **sweep**: `sweep`, `reversal`
- **sub**: `submission`, `sub`, `choke`, `rnc`, `tap`

Unclassified exits are reported as `other:<raw>` in test output, not guessed.

## Gate

- `check_scripts.py`: pass
- One test: pass (exit 0; contract allows fails via `FIGHT_GROUND_BANDS FAILS=N`)
