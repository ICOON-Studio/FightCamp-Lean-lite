# U110 — Rear-Hand and Kick Commitment Window

**Headline (away_s = extension_s + return_s, p50):**

| limb | p50 (s) | n | population |
|---|---|---|---|
| lead hand (Q110) | 0.267 | 117 | 16 boxing, planted |
| rear hand | 0.267 | 263 | 10 boxing videos |
| kick | 0.067 | 413 | 10 boxing videos |

UFC round 1 (separate population): rear_hand n=41, kick n=72.

## Population

17 tracks: 16 boxing/sparring videos plus the kept UFC round-1 track (126.8 s of a 300 s round).
**Six of the sixteen boxing videos contain no two-man footage** (segments=[], punches=[]):
`2m1Ftv_l_Xc`, `7pIskYcLKVw`, `LfpNJ5fIYA4`, `cyXGrr7YTeg`, `isLkzN3d7rA`, `HFSZxKUUE98` (slow motion).
They contribute nothing and are excluded from the pool. The real population is **ten boxing videos plus the UFC round**.

Total usable seconds (10 boxing): 516.5 s (8.6 min). UFC: 125.7 s (2.1 min).

## Per-limb detail (boxing pool)

**rear_hand** (n=263, 263/8.6 = 30.6/min):
- away_s: p10=0.147, p50=0.267, p90=0.462
- extension_s: p50=0.133, return_s: p50=0.134
- e: p50=0.78, hips_out_T: p50=0.08
- reacted_share=0.31, matched_share=0.12

**kick** (n=413, 413/8.6 = 48.0/min):
- away_s: p10=0.033, p50=0.067, p90=0.113
- extension_s: p50=0.033, return_s: p50=0.034
- e: p50=0.12, hips_out_T: p50=0.05
- reacted_share=0.08, matched_share=0.02

## Open

**The kick numbers are not reliably measurable from this footage.** The detector (ankle rise ≥ 0.15 T above 1 s rolling median, opposite hip within 0.10 T) picks up footwork noise: 413 "kicks" in 8.6 minutes is 48/min, or nearly one per second. A real kick takes 0.3–0.5 s; the p50 of 0.067 s (67 ms) is faster than a blink and physically impossible for a committed kick. The rolling median adapts to normal footwork cadence, so ordinary stepping produces ankle lifts that pass the threshold. The stance-hip stability check does not separate steps from kicks in active movement where both hips bounce. **These numbers are an upper bound on ankle-rise events, not a measurement of kick commitment.** A kick detector that survives contact with real footage needs a horizontal-reach component or a higher vertical threshold tuned against manually labeled frames — neither exists in this repo yet.

**rear_hand p50 matches lead_hand p50 exactly (0.267 s).** This is either a real finding (rear hands commit for the same duration as lead hands when measured by wrist-reach return) or an artifact of the detector finding the same events classified differently by stance. The matched_punch share for rear_hand (0.12) is lower than Q110's lead-hand matched share, suggesting some rear-hand events are not captured in the events-file punch list (which only records punches with rise ≥ 0.35 T).

**e for kick is ankle rise as share of leg length**, the exact analogue of jab_types.py's arm-length share. A value of 0.12 means the ankle rose 12% of leg length — consistent with a step, not a kick.

**MediaPipe left/right label swaps** when a fighter turns edge-on. If any rear_hand or kick event has the wrong `side`, it is a tracking artifact, not a stance change. The per-segment lead/rear rule handles stance switches correctly, but limb-side labels may be inverted in edge-on segments.

## Method

`Tools/footage/limb_types.py` — same identity/segment detection as `pair_events.py` and `jab_types.py`. Rear hand: non-lead wrist, rise ≥ 0.12 T (same threshold as jab_types, filtered for the hand opposite the lead foot). Kick: either ankle, rise ≥ 0.15 T above 1 s rolling median, opposite hip within 0.10 T of its median. `reacted` and `matched_punch` use jab_types.py's exact definitions (nose ≥ 0.15 T within -0.1..+0.6 s; events-file punch within ±0.1 s).

`Tools/footage/fold_limb_types.py` — pools the 10 boxing videos separately from the UFC round. p90 suppressed when n < 30.

Branch: `qwen/u110-commit-window`.
