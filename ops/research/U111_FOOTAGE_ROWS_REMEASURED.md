# U111 — Two rows U109 and U110 got wrong, re-measured

## ROW 1 — Kick `away_s` (U110)

### What the 413 boxing “kicks” actually are

**Population:** 10 boxing videos with usable two-man time (same pool U110 used): `-vPZqptk8jo`, `FCM7m6TJWUQ`, `HL261oRyURE`, `vOFmsN3JROs`, `yg_N42n_Jdk`, `xaXXD-w45b0`, `wzUWvsviqTM`, `kuABaA2PY0U`, `XIja1S9SXI4` — **boxing discipline, n=413**.

The ankle-rise detector (≥ 0.15 T above a 1 s rolling median, opposite hip within 0.10 T) fires on **footwork**, not kicks:

| classification | n | share | meaning |
|---|---|---|---|
| in_place_foot_lift | 172 | 42% | `away_s` < 0.10 s and `hips_out_T` < 0.02 T — ankle lifts while hips stay planted |
| short_step | 135 | 33% | `away_s` < 0.15 s — weight shift / step cadence |
| other | 106 | 25% | longer ankle lifts still without kick-like hip travel |

Pooled boxing false positives: `away_s` p50 **0.067 s**, `extension_s` p50 **0.033 s** (≈2 frames at 60 fps), `hips_out_T` p50 **0.000 T**, `matched_punch_share` **5.6%**. Rate **48/min** across 8.6 usable minutes — physically impossible for committed kicks.

**Verdict:** 0.067 s is **NOT FOUND as kick commitment** — it measures in-place foot lifts and short steps in boxing footage. **Do not bind.**

### Re-measured kick commitment (footage with kicks)

| population | video | discipline | usable s | kick n | away_s p50 (s) | away_s p90 (s) |
|---|---|---|---|---|---|---|
| UFC round 1 | `_mkFV2H2oCk_r1` | MMA broadcast | 125.7 | 72 | 0.167 | 0.330 |
| Muay Thai sparring (new) | `_Fc7QLzbQlQ` | muay_thai gym | 14.6 | 42 | 0.100 | 0.200 |
| **Pooled** | both above | MMA + Muay Thai | — | **114** | **0.134** | **0.267** |

Sixteen boxing tracks were **not** included. Six of sixteen boxing ids still carry no two-man segments (`2m1Ftv_l_Xc`, `7pIskYcLKVw`, `HFSZxKUUE98`, `LfpNJ5fIYA4`, `cyXGrr7YTeg`, `isLkzN3d7rA`).

**Verdict:** Kick `away_s` p50 **0.134 s** over **n=114** from MMA + Muay Thai. Boxing pool rejected. UFC alone (n=72) was not used as the headline; Muay Thai track added per task (`_Fc7QLzbQlQ`, downloaded h264 360p, tracked 2026-09-20).

### Unchanged from U110

Rear-hand `away_s` p50 **0.267 s**, n=263, 10 boxing videos — **keep; engine may bind.**

---

## ROW 2 — `turn_yaw_deg_s` (U109)

### What produced max 10 577 deg/s

MediaPipe **exchanges L/R hip labels** between adjacent frames even when shoulder/hip width stays above the collapse gate. At frame 22353 of `xaXXD-w45b0` (amateur boxing, three-quarter camera): L hip jumps to the previous R position (distance 1.7 px vs 54.5 px to its own previous label). The hip-line normal flips ≈180° in one frame → **179.9° × 59.8 fps ≈ 10 760 deg/s**. Not a human turn.

### Fix (`Tools/footage/between_events.py`)

1. **Hip label unswap:** minimum-assignment correction when `(d_lr + d_rl) < (d_ll + d_rr)` before computing facing.
2. **Geometric exclusions kept:** shoulder/hip width collapse gates (edge-on body has no measurable line).
3. **Unresolved facing:** adjacent pairs with `|d_yaw| ≥ 60°` after unswap excluded (measurement failure, not a rate cap).
4. **Excluded share reported** per video; max never used for binding.

### Re-measured turn rate

**Population:** same 10 boxing videos with usable time + UFC round 1 `_mkFV2H2oCk_r1` (measured separately, never averaged).

| pool | n samples | p50 (deg/s) | p90 (deg/s) | max (deg/s) | excluded share |
|---|---|---|---|---|---|
| boxing (10 videos) | 30 265 | **36.3** | **150.0** | 2 768 | 19.1% mean |
| UFC round 1 | 4 031 | **27.8** | **81.2** | 1 067 | 25.4% |

**Verdict:** p50 and p90 are **MEASURED (footage)**. **Max remains artefact-dominated** (residual 60–90°/frame spikes after unswap; do not bind `FightBearing.TURN_BASE_DEG_S` from max). U109’s other between-punch rates are unchanged.

---

## Method notes

- Kick analysis: `Tools/footage/kick_population.py`
- Turn re-run: `Tools/footage/batch_u111_between.py` over `FightCamp-footage/between/`
- Muay Thai source: YouTube `_Fc7QLzbQlQ`, format 134 (h264 360p) + ffmpeg merge; AV1 398 avoided
