# LOCOSLIDE2 - The Planted Foot Creep: Which Way, How Much, What Brings It Back

> CLAUDE'S READING (S408): no fault on the walking clips. Stretch by stretch, the game's planted foot ends at most 0.56 cm further from where it landed than the source's does (NET, largest on rk_loc_left), and on rk_loc_back it ends closer. Without the contact hold NET reaches 2.4 cm, so the hold is doing its job.
> The "worst stretch" at 79% is a six-frame stretch with 2 cm of body travel (2.2 cm of foot against 1.8 in the source): a foot finishing its step, not a slide. "rkxz has no effect" was seen only with the hold on; `rkxz` was not tried with the hold off.

**Date:** 2026-11-09
**Branch:** qwen/locoslide2
**Leg length (Godot GAME):** 0.8380 m
**Leg length (Blender SOURCE):** rk_loc_in=0.8422 m, others=0.8890 m
**Fixed fps:** 30 (deterministic: two runs of GAME produce identical numbers)
**Cycle measured:** second cycle of chained clip (or only cycle for rk_loc_in, cycles=1)

## Arms

- **SOURCE**: Blender raw FBX (tools/loco_slide_raw.py), one source window
- **GAME**: full game stack (contact hold on, rkxz=1.0)
- **NOCONTACT**: `-- rknocontact` (contact hold off, rkxz=1.0)
- **RKXZ_0.9**: `rkxz=0.9` (floor gain 0.9) — identical to GAME (contact hold overrides)
- **RKXZ_1.1**: `rkxz=1.1` (floor gain 1.1) — identical to GAME (contact hold overrides)

## Table: Per-Stretch Metrics (frames > 1 only)

For rk_loc_in (mirror=True): SOURCE left compares with GAME right, SOURCE right compares with GAME left.

### rk_loc_in (cycle=0, 47 frames, one_cycle=1.600s)

| Foot | Arm | Frame | t(s) | Frames | PATH(m) | NET(m) | ALONG(m) | BODY(m) | ALONG/BODY | path_leg | net_leg |
|------|-----|-------|------|--------|---------|--------|----------|---------|------------|----------|---------|
| right | SOURCE | 0 | 0.000 | 34 | 0.0411 | 0.0121 | 0.0026 | 0.2081 | 0.012 | 0.0488 | 0.0143 |
| left | GAME | 4 | 0.133 | 35 | 0.0266 | 0.0096 | 0.0094 | 0.2088 | 0.045 | 0.0318 | 0.0114 |
| left | NOCONTACT | 4 | 0.133 | 35 | 0.0325 | 0.0073 | 0.0071 | 0.2065 | 0.034 | 0.0388 | 0.0087 |
| left | SOURCE | 8 | 0.333 | 18 | 0.0160 | 0.0084 | 0.0012 | 0.0883 | 0.014 | 0.0190 | 0.0099 |
| right | GAME | 6 | 0.200 | 23 | 0.0201 | 0.0102 | 0.0084 | 0.0804 | 0.104 | 0.0240 | 0.0122 |
| right | NOCONTACT | 6 | 0.200 | 23 | 0.0284 | 0.0107 | 0.0038 | 0.0753 | 0.051 | 0.0339 | 0.0128 |
| right | GAME | 37 | 1.233 | 10 | 0.0128 | 0.0010 | 0.0001 | 0.1830 | 0.001 | 0.0153 | 0.0012 |
| right | NOCONTACT | 37 | 1.233 | 10 | 0.0200 | 0.0109 | -0.0109 | 0.1720 | -0.063 | 0.0238 | 0.0130 |

### rk_loc_back (cycle=1, 26 frames, one_cycle=0.850s)

| Foot | Arm | Frame | t(s) | Frames | PATH(m) | NET(m) | ALONG(m) | BODY(m) | ALONG/BODY | path_leg | net_leg |
|------|-----|-------|------|--------|---------|--------|----------|---------|------------|----------|---------|
| left | SOURCE | 0 | 0.000 | 30 | 0.0095 | 0.0062 | -0.0020 | 0.3390 | -0.006 | 0.0106 | 0.0070 |
| left | GAME | 2 | 0.067 | 14 | 0.0221 | 0.0052 | -0.0037 | 0.2707 | -0.014 | 0.0264 | 0.0062 |
| left | NOCONTACT | 2 | 0.067 | 14 | 0.0255 | 0.0147 | -0.0139 | 0.2605 | -0.053 | 0.0305 | 0.0175 |
| right | SOURCE | 27 | 0.450 | 24 | 0.0138 | 0.0085 | -0.0084 | 0.2849 | -0.030 | 0.0155 | 0.0095 |
| right | GAME | 15 | 0.500 | 11 | 0.0124 | 0.0044 | -0.0029 | 0.2344 | -0.012 | 0.0148 | 0.0052 |
| right | NOCONTACT | 15 | 0.500 | 11 | 0.0270 | 0.0244 | -0.0244 | 0.2129 | -0.115 | 0.0323 | 0.0291 |

### rk_loc_left (cycle=1, 31 frames, one_cycle=1.033s)

| Foot | Arm | Frame | t(s) | Frames | PATH(m) | NET(m) | ALONG(m) | BODY(m) | ALONG/BODY | path_leg | net_leg |
|------|-----|-------|------|--------|---------|--------|----------|---------|------------|----------|---------|
| left | SOURCE | 0 | 0.000 | 6 | 0.0186 | 0.0178 | 0.0119 | 0.0245 | 0.484 | 0.0209 | 0.0200 |
| left | GAME | 0 | 0.000 | 6 | 0.0224 | 0.0223 | 0.0164 | 0.0207 | 0.791 | 0.0267 | 0.0266 |
| left | NOCONTACT | 0 | 0.000 | 6 | 0.0234 | 0.0234 | 0.0177 | 0.0213 | 0.832 | 0.0280 | 0.0279 |
| left | SOURCE | 14 | 0.467 | 16 | 0.0136 | 0.0104 | 0.0026 | 0.1078 | 0.024 | 0.0153 | 0.0117 |
| left | GAME | 13 | 0.433 | 18 | 0.0230 | 0.0160 | -0.0004 | 0.1156 | -0.004 | 0.0275 | 0.0190 |
| left | NOCONTACT | 13 | 0.433 | 18 | 0.0345 | 0.0211 | -0.0098 | 0.1058 | -0.093 | 0.0411 | 0.0252 |
| right | SOURCE | 0 | 0.000 | 21 | 0.0080 | 0.0043 | 0.0043 | 0.1956 | 0.022 | 0.0090 | 0.0049 |
| right | GAME | 0 | 0.000 | 21 | 0.0171 | 0.0070 | 0.0037 | 0.1827 | 0.020 | 0.0204 | 0.0083 |
| right | NOCONTACT | 0 | 0.000 | 21 | 0.0197 | 0.0122 | -0.0093 | 0.1696 | -0.055 | 0.0235 | 0.0146 |

### rk_loc_right (cycle=1, 31 frames, one_cycle=1.033s)

| Foot | Arm | Frame | t(s) | Frames | PATH(m) | NET(m) | ALONG(m) | BODY(m) | ALONG/BODY | path_leg | net_leg |
|------|-----|-------|------|--------|---------|--------|----------|---------|------------|----------|---------|
| left | SOURCE | 0 | 0.000 | 19 | 0.0140 | 0.0086 | 0.0040 | 0.2129 | 0.019 | 0.0158 | 0.0097 |
| left | GAME | 0 | 0.000 | 19 | 0.0150 | 0.0106 | 0.0008 | 0.2038 | 0.004 | 0.0179 | 0.0126 |
| left | NOCONTACT | 0 | 0.000 | 19 | 0.0283 | 0.0229 | -0.0182 | 0.1846 | -0.099 | 0.0338 | 0.0273 |
| right | SOURCE | 0 | 0.000 | 3 | 0.0071 | 0.0070 | -0.0070 | 0.0276 | -0.252 | 0.0080 | 0.0079 |
| right | GAME | 0 | 0.000 | 4 | 0.0118 | 0.0114 | -0.0111 | 0.0349 | -0.318 | 0.0141 | 0.0136 |
| right | NOCONTACT | 0 | 0.000 | 3 | 0.0095 | 0.0094 | -0.0093 | 0.0239 | -0.388 | 0.0113 | 0.0112 |
| right | SOURCE | 14 | 0.467 | 16 | 0.0076 | 0.0056 | -0.0001 | 0.1723 | -0.001 | 0.0086 | 0.0063 |
| right | GAME | 14 | 0.467 | 17 | 0.0094 | 0.0069 | 0.0009 | 0.1619 | 0.006 | 0.0112 | 0.0082 |
| right | NOCONTACT | 14 | 0.467 | 17 | 0.0211 | 0.0189 | -0.0111 | 0.1493 | -0.074 | 0.0252 | 0.0226 |

## Analysis

### On each clip, does the planted foot creep with the walk or against it?

- **rk_loc_in**: ALONG/BODY is **positive** (0.045 game left, 0.104 game right main stretch) — the planted foot creeps **with** the walk direction. The foot moves forward about 5-10% of how much the body moves.

- **rk_loc_back**: ALONG/BODY is **negative** (-0.014 game left, -0.012 game right) — the planted foot creeps **against** the walk direction. The foot drifts backward slightly while the body walks backward.

- **rk_loc_left**: **Mixed** — the first stretch (push-off phase) has very high positive ALONG/BODY (0.791 game left), meaning the foot creeps strongly with the walk. The second stretch has near-zero or slightly negative ALONG/BODY (-0.004).

- **rk_loc_right**: **Mixed** — the first stretch has negative ALONG/BODY (-0.318 game right), meaning the foot creeps against the walk. The second stretch has near-zero ALONG/BODY (0.006).

### Is ALONG/BODY about the same on every clip (one wrong scale) or different (something else)?

**Different.** The ALONG/BODY values vary widely across clips:
- rk_loc_back: consistently around -0.01 (small, against)
- rk_loc_in: around 0.05-0.10 (small, with)
- rk_loc_left: 0.791 on first stretch (very high, with), -0.004 on second
- rk_loc_right: -0.318 on first stretch (high, against), 0.006 on second

This is **not one wrong scale**. If it were a single scale error (e.g., body travel too large or too small), ALONG/BODY would be similar across all clips. Instead, each clip has its own pattern, suggesting the issue is in how the retargeting handles each clip's specific footwork.

### Which arm comes closest to SOURCE?

**GAME (with contact hold) comes closest to SOURCE** for most clips:

- **rk_loc_back**: SOURCE along_body=-0.006 to -0.030, GAME=-0.012 to -0.014, NOCONTACT=-0.053 to -0.115. GAME is closer.
- **rk_loc_left** (first stretch): SOURCE=0.484, GAME=0.791, NOCONTACT=0.832. GAME is closer (but still 63% higher than source).
- **rk_loc_right** (first stretch): SOURCE=-0.252, GAME=-0.318, NOCONTACT=-0.388. GAME is closer.

**rkxz=0.9 and rkxz=1.1 produce identical results to GAME** — the contact hold overrides the floor gain change. The xz_gain knob has no effect when the contact hold is active.

**NOCONTACT makes things worse** — turning off the contact hold increases the gap between game and source on most clips.

### Worst stretch for a still

**Worst stretch:** rk_loc_left, left foot, frame=0, t=0.000s
- GAME: along_body=0.791, path_leg=0.0267 (foot creeps 79% of body travel)
- SOURCE: along_body=0.484, path_leg=0.0209 (foot creeps 48% of body travel)
- The game shows 63% more creep than the source on this stretch.

This is the push-off phase of the side step, where the foot is planted but the body moves significantly. The source also shows high creep here (0.484), but the game amplifies it to 0.791.

## Summary

The planted foot creeps **with** the walk on rk_loc_in and rk_loc_left (push-off phase), and **against** the walk on rk_loc_back and rk_loc_right (first stretch). The ALONG/BODY ratio is **different on every clip**, not a single wrong scale. The **GAME arm (with contact hold) comes closest to SOURCE**, and the **rkxz knob has no effect** because the contact hold overrides it. The **NOCONTACT arm makes things worse**. The worst stretch is rk_loc_left left foot at frame 0, where the game shows 79% creep vs the source's 48%.
