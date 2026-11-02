# CLAUDE_LAND_NOTE — J20

**From:** John Research  
**Date:** 2026-09-10  
**Status:** RESEARCH COMPLETE — scoreboard only. No engine changes. Do not edit HANDOFF from this note.

## What finished

`research/J20_THE_VALIDATION_CORPUS.md` (~52 KB). Live Grok pass, graded table of UFC/MMA (+ cheap boxing) benchmarks with definition, denominator, population, spread, source, grade. Fabricated means refused as NOT FOUND.

## Paths

- Research: `research/J20_THE_VALIDATION_CORPUS.md`
- Staging: `_john_delivery/J20_THE_VALIDATION_CORPUS.md`
- This note: `research/CLAUDE_LAND_NOTE_J20.md` and `_john_delivery/CLAUDE_LAND_NOTE_J20.md`

## DECISIONS — harness these six first

| # | Metric | Real-fight anchor |
| --- | --- | --- |
| **D1** | Significant-strike pace (both corners) | Per-fighter SLpM ~**2.8–3.8** by division; combined bout ~**6–8** landed/min |
| **D2** | Significant-strike accuracy | Fight-level ~**40–49%** (heavier higher); red 47.9% / blue 43.7% |
| **D3** | Target mix head/body/leg (landed significant) | League ~**61–65 / 19–23 / 14–18**. Engine leg **3.2%** is outside every published band if it means UFC target share |
| **D4** | Outcome mix KO/TKO / sub / decision | Modern standard ~**51 / 32 / 17**; **condition by division** (HW KO/TKO ~52%; WSW decision ~67%) |
| **D5** | Bouts with ≥1 official KD | **35.1%** of 8,337 UFC bouts (1994–Sep 2025). Settles engine **41.5%**: high vs 35.1%, not a 2× error. KD ≠ KO |
| **D6** | Takedowns attempted/landed + accuracy | ~**4–8** attempts / **1–3** landed per fighter-fight; accuracy **35–40%**; sub attempts usually **<1** |

**Harness order:** D1+D2 same clock → D3 on landed significant → D5 (incidence, not KD→KO) → D4 by division → D6. Do **not** validate modern UFC-wide fight-time distance/clinch/ground % — that object is **NOT FOUND** (only strike-position share ~72.6 / 13.4 / 14.1 and stale 2013 time shares).

## What Claude should do now

1. Read the DECISIONS block + big table in `J20_THE_VALIDATION_CORPUS.md`.
2. Build the validation harness against **D1–D6** first.
3. Write the HANDOFF block yourself — John does not edit `HANDOFF.md`.
4. Map engine target mix carefully: if 65.3/28.2/3.2 is UFC Stats head/body/leg of landed significant, **legs fail D3**; if it is a different bucket, rename before tuning.

## Out of scope / refused

- Engine patches, GDScript, vendors, prices
- Invented league means (UFC-wide mean SLpM/SApM/defense/TD Avg / modern position **time** share / mean control % — all NOT FOUND as official means)
- Prefer Division Meta **35–40%** TD accuracy over Jacob’s unresolved **27%**
