# U40 DIGEST — three punches sliced from combo_jab_cross_hook

## Windows (from the curve, not equal thirds)
Virtual FK on the clip's Node3D rest locals; peaks on RightHand→Hips reach,
cut on retractions. **3 windows found** (not forced):

| name | start_s | end_s | length_s | reach_m (fwd XZ) | peak_t | hand |
| --- | --- | --- | --- | --- | --- | --- |
| jab | 0.00 | 0.64 | 0.64 | **0.744** | 0.54 | RightHand |
| cross | 0.64 | 1.04 | 0.40 | **0.926** | 0.86 | RightHand |
| hook_rear | 1.04 | 1.68 | 0.64 | **0.772** | 1.30 | RightHand |

All three peaks were **RightHand** → hook named `hook_rear` (not lead).
Two weaker late bumps (~1.68 / ~2.06) failed the forward floor (0.60 m) — settle,
not punches. Reported, not forced into the set.

## Finding for Claude / J17
Individual `reach_m` differ: jab 0.744 ≈ R94's combined 0.747; **cross 0.926** is
longer; hook_rear 0.772 sits between. A jab and a cross are not interchangeable
against the engine's 0.885 m median / [1.0, 1.1) mode.

## Shipped
- `FightClipSlice.gd` — `slice`, `punch_windows` (pure, zero preloads)
- `FightClipBinding.gd` — jab/cross/hook_rear + strike_head kept whole
- `FightStagePlayer.gd` — grafts slices; head-strike beat prefers `jab`
- `fight_clip_slice_test.gd` — 22/0

## Gate
own 22/0; U39 playback 25/0; world 5/0; fight 45/0. combo-trap=closed.
