# CONTRACT — `Godot/scripts/FightTakeRetime.gd` (shared by TASK_U101 and TASK_C126, 2026-09-14)

Why: the bought RamsterZ jab (`H2H_JabInPlace.FBX`) is keyed at 30 fps and its lead hand travels ~39 cm between the keys at
0.200 and 0.233 s (5.5 cm per 1/60 s before, 2 cm after) - its whole extension in one 33 ms interval. In the live room
that is a one-frame jump on every jab, 130-140 a bout (`tools/probe_spikes.gd`, `tools/probe_clip_keys.gd`). The cross
has a 48 cm interval at 0.267-0.300 s next to a near-stop. Real jabs extend over 0.07-0.40 s, median 0.17 s
(`research/V1_BOXING_FROM_VIDEO.md`, 31 jabs). The fix RETIMES such an interval: it is given more time, taken back
from the near-still hold that follows. A smooth fast swing (a hook's 19, 40, 50, 36 cm) is not a spike and is left alone.

The module: `extends RefCounted`, **no `class_name`**, **zero preloads**, static functions only. Every time and
distance array is a `PackedFloat64Array`. Callers `load("res://scripts/FightTakeRetime.gd")`.

## 1. `static func stretched(key_times: PackedFloat64Array, travel_m: PackedFloat64Array, cap_mps: float, spike_ratio: float) -> PackedInt32Array`

`n = key_times.size() - 1` intervals; interval `k` runs from `key_times[k]` to `key_times[k + 1]`, `h_k` its length.
Returns an EMPTY array when `cap_mps <= 0.0`, when `n < 1`, or when `travel_m.size() != n`. Otherwise the ascending
indices `k` for which ALL hold:
- `h_k > 0.0`;
- `travel_m[k] / h_k > cap_mps`;
- `spike_ratio <= 0.0`, OR `travel_m[k] > spike_ratio * m_k`, where `m_k` is the SMALLER of `travel_m[k - 1]` (when
  `k > 0`) and `travel_m[k + 1]` (when `k < n - 1`); an interval with no neighbour (`n == 1`) passes this test.

## 2. `static func remap(key_times: PackedFloat64Array, travel_m: PackedFloat64Array, cap_mps: float, spike_ratio: float, hold_mps: float, min_scale: float, absorb_s: float) -> PackedFloat64Array`

Returns the NEW key times, the same size as `key_times`, with `out[0] == key_times[0]`. When `stretched(...)` is empty
it returns an unchanged copy of `key_times`. Otherwise, with `s = clampf(min_scale, 0.05, 1.0)`:
1. `d_k = h_k` for every interval; then for every stretched `k`: `d_k = travel_m[k] / cap_mps`.
2. For each stretched `k` in ascending order: `extra = d_k - h_k`; then for `j = k + 1, k + 2, ...` while `extra > 0.0`
   and `j < n` and `key_times[j] < key_times[k + 1] + absorb_s`: if `j` is NOT stretched and `h_j > 0.0` and
   `travel_m[j] / h_j < hold_mps`, then `take = minf(extra, d_j - s * h_j)`, and if `take > 0.0`: `d_j -= take` and
   `extra -= take`. Whatever `extra` is left lengthens the take.
3. `out[i + 1] = out[i] + d_i`.

No key ever moves EARLIER than its old time (every absorbed second was added by an earlier stretch).

## 3. `static func map_time(old_times: PackedFloat64Array, new_times: PackedFloat64Array, t: float) -> float`

- `old_times.size() != new_times.size()`, or either is empty: returns `t`.
- `t <= old_times[0]`: returns `t`.
- `t >= old_times[last]`: returns `t + (new_times[last] - old_times[last])`.
- otherwise, with `i` such that `old_times[i] <= t < old_times[i + 1]`: when `old_times[i + 1] - old_times[i] <= 0.0`
  returns `new_times[i]`, else `new_times[i] + (t - old_times[i]) * (new_times[i + 1] - new_times[i]) / (old_times[i + 1] - old_times[i])`.

## 4. `static func apply(anim: Animation, old_times: PackedFloat64Array, new_times: PackedFloat64Array) -> void`

Every key of every track of `anim` moves to `map_time(old_times, new_times, <its time>)`; each track keeps its key
count, its key order, and every key's value and transition; then `anim.length = map_time(old_times, new_times,
anim.length)`. (Implementation note: since no key moves earlier, moving keys from the LAST to the FIRST with
`track_set_key_time` never lets one key pass another.)

## A worked example (use it)

`key_times = [0.0, 0.1, 0.2, 0.3, 0.4]`, `travel_m = [0.05, 0.60, 0.02, 0.02]`, `cap_mps = 3.0`, `spike_ratio = 2.5`,
`hold_mps = 1.5`, `min_scale = 0.5`, `absorb_s = 0.30`:
- speeds 0.5, 6.0, 0.2, 0.2 m/s; interval 1: 6.0 > 3.0 and 0.60 > 2.5 x min(0.05, 0.02) = 0.05 -> `stretched = [1]`;
- `d_1 = 0.60 / 3.0 = 0.2`, `extra = 0.1`; `j = 2`: 0.2 < 0.2 + 0.3, speed 0.2 < 1.5, take = min(0.1, 0.1 - 0.05) = 0.05
  -> `d_2 = 0.05`, extra 0.05; `j = 3`: 0.3 < 0.5, take = 0.05 -> `d_3 = 0.05`, extra 0.0;
- `remap = [0.0, 0.1, 0.3, 0.35, 0.4]`; `map_time(old, new, 0.15) = 0.2`; `map_time(old, new, 0.45) = 0.45`.
