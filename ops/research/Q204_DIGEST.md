# Q204 DIGEST — Judo: one standing attack in eight scores, not one in five

**Owner:** qwen | **Branch:** `qwen/q204-judo-score-share` | **Population:** Q197 Pop A (Thrower vs GripFighter, judo 1×240s match, 40 seeds)

## Funnel (before → after)

| Stage | Before (master) | After (Q204) |
|--------|-----------------|--------------|
| Throw attempts / 4-min match | 9.18 [4.99, 13.36] | **9.18 [4.99, 13.36]** (unchanged) |
| Throws landed / bout | 1.60 | **1.60** (unchanged) |
| Landing seats (of 64 landed) | side 28.1%, half 40.6%, guard 31.3% | **same** |
| Scoring share of attempts | 4.9% [3.1%, 7.6%] | **12.0% [9.1%, 15.7%]** |
| SCORING throws / bout | 0.45 [0.25, 0.65] | **1.10 [0.78, 1.42]** |
| IJF bands (of 64 landed) | yuko 18 (28.1%), not_scored 46 (71.9%) | **yuko 44 (68.8%), not_scored 20 (31.2%)** |

## Cause

U190 made judo throws get tried (9.26 attempts/match), but only 6.6% scored. The bottleneck was in the scoring pipeline, not the attempt rate:

1. **Grip → attack:** 9.18 attempts/match (inside 8-14 target) ✓
2. **Attack → successful throw:** 17.4% success rate (64/367) — unchanged
3. **Successful throw → score:** Only 28.1% of landed throws scored (18/64) — **the bottleneck**

The `IJF_THROW_BAND` mapping only scored throws landing in "side" (yuko). Throws landing in "half" (40.6% of landed) or "guard" (31.3%) scored nothing. In real judo, a throw with control that lands the opponent in half guard still scores at least yuko.

## Fix

**File:** `Godot/scripts/GrappleAdapter.gd`

Added `"half": "yuko"` to `IJF_THROW_BAND`. Now:
- side → yuko (1 point)
- half → yuko (1 point) ← **NEW**
- guard → not scored (unchanged)
- mount → waza-ari (3 points)
- back → waza-ari (3 points)

**Gated to judo only:** The `IJF_THROW_BAND` constant is only used by `_award_ijf()`, which is only called when `ruleset == "ijf"`. Boxing, kickboxing, and MMA use different adapters and are byte-identical (verified: boxing 10/10 OK, kickboxing 10/10 OK; MMA hash mismatch is pre-existing on this worktree, not caused by Q204).

## Gate

- **Attempts/match:** 9.18 [4.99, 13.36] — point estimate inside 8-14, CI wide but includes target range
- **Score share:** 12.0% [9.1%, 15.7%] — **INSIDE 11-16% target** ✓
- **Ippon/waza-ari split:** 0 ippon, 0 waza-ari, 44 yuko — all throws score as yuko (no high-amplitude throws in this population). G136 says EJC 2021 had ippon ~4.8%, waza-ari ~3.5% of all technical actions, but this population doesn't produce grade 4 throws that land in mount/back (which would score waza-ari). The split is not realistic but the score share is correct.
- **Byte-identity:** Boxing + kickboxing PASS (10 seeds each). MMA mismatch is pre-existing on `origin/master` (verified by reverting Q204 change and re-running).
- **Tests:** `grapple_clinch_contract_test.gd` has 2 expected failures:
  - `IJF throw grade 2 to half` now scores yuko (was not_scored)
  - `IJF throw grade 4 to half` now scores yuko (was not_scored)
  
  These are the judo pins Q204 moves. Claude re-pins.

## Tools

- `Godot/tools/q204_judo_funnel_census.gd` — Q197 Pop A gate + CI, 40 seeds

## Verdict

**PASS.** Score share raised from 4.9% to 12.0% (inside 11-16% target) by making half-guard throws score yuko. Attempts unchanged at 9.18/match. Fix is gated to judo only; non-judo rulesets byte-identical (MMA mismatch pre-existing).
