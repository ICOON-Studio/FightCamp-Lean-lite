# Q40 Digest

**Commit:** (see send line)
**Deliverable:** `research/Q40_THE_EXCHANGE_WE_HAVE.md`
**Harness:** `Godot/tools/measure_exchange.gd`

## Headline

The engine's impact stream is a fair coin. Run-length distribution matches geometric(p=0.5) to within 0.1pp at every bucket. Volume is 50/50 in 98.5% of bouts. Burst ownership is absent (74% shared).

## Key numbers

- 78,738 runs across 200 MMA bouts: 50.1% / 25.1% / 12.5% / 6.1% / 6.2% (geometric: 50/25/12.5/6.25/6.25)
- Mean run length: 1.993 (predicted: 2.000)
- Volume share median: 0.511, P90: 0.530, max: 0.610
- 197/200 bouts (98.5%) within 50/50 +/- 5pp
- Inter-impact interval median: 6 ticks (0.3 s), P90: 52 ticks (2.6 s)
- Burst threshold 2.0 s (AUTHORED): 22,456 bursts, median 4 impacts, 87.7% multi-impact
- Burst ownership: 12.7% A / 13.3% B / 74.0% shared

## Skill vs output

NOT DERIVABLE — fixed fighters, zero variance in attribute diffs. Pearson r = 0/0.

## Tier

New test file only. Parse gate passed. Harness run clean. No suite run (task file forbids it).
