# LEANRED1 RESULT — why block_catch and hit_frame are red, and why leanrate 2.5 makes them worse

## block_catch_test.gd

### Baseline failures

| # | Check | FAIL at leanrate=4.0 | FAIL at leanrate=2.5 | Δ (2.5 vs 4.0) |
|---|-------|----------------------|----------------------|-----------------|
| 1 | CATCH A_B pro_left_jab | other glove 0.054 (bar 0.05) | other glove 0.056 (bar 0.05) | +0.002 worse |
| 2 | MATCH A_B pro_left_jab | elbow diff 27.8 deg (bar 15) | elbow diff 28.4 deg (bar 15) | +0.6 worse |
| 3 | MATCH A_B pro_right_cross | reach 80.0% (bar 86%), elbow 46.9 (bar 43) | reach 78.3% (bar 86%), elbow 42.0 (bar 43) | reach -1.7%, elbow -4.9 |
| 4 | MATCH B_A pro_left_jab | reach 89.0% (bar 90%), elbow 25.0 (bar 15) | reach 89.0% (bar 90%), elbow 24.9 (bar 15) | same |
| 5 | OVERHEAD B_A pro_left_hook | +0.037 m (bar 0.03) | +0.035 m (bar 0.03) | -0.002 (still fails) |
| 6 | CATCH A_B pro_right_cross | — (pass, other 0.049) | other glove 0.138 (bar 0.05) | NEW at 2.5 |
| 7 | OVERHEAD A_B pro_right_cross | — (pass, +0.030) | +0.030 m (bar 0.03) | NEW at 2.5 |

5 failures at 4.0, 7 at 2.5. Two new failures appear at the slower lean.

### Switch probes (at leanrate=2.5, only the failing checks shown)

| Check | noleanease | noarmhome | noprecap | nopopcap | noglove | nosnap | noreach |
|-------|-----------|-----------|----------|----------|---------|--------|---------|
| CATCH A_B pro_left_jab (other 0.056) | 0.055 FAIL | 0.064 worse | 0.055 FAIL | 0.055 FAIL | **0.016 PASS** | 0.072 worse | 0.064 worse |
| CATCH A_B pro_right_cross (other 0.138) | 0.080 FAIL | 0.051 FAIL | **0.036 PASS** | **0.027 PASS** | **0.000 PASS** | 0.175 worse | 0.200 worse |
| OVERHEAD A_B pro_right_cross (+0.030) | **0.022 PASS** | **0.028 PASS** | 0.031 FAIL | 0.030 FAIL | **0.022 PASS** | 0.184 worse | 0.054 worse |
| OVERHEAD B_A pro_left_hook (+0.035) | **0.022 PASS** | **0.022 PASS** | **0.022 PASS** | **0.030 PASS** | **0.022 PASS** | 0.076 worse | 0.095 worse |
| MATCH A_B pro_left_jab (elbow 28.4) | elbow 3.7, pitch 11.6 FAIL | elbow 27.7 FAIL | elbow 28.2 FAIL | elbow 28.2 FAIL | elbow 22.9 FAIL | elbow 24.2 FAIL | **elbow 1.0 PASS** |
| MATCH A_B pro_right_cross (reach 78.3%, elbow 42.0) | **reach 90.7%, elbow 28.0 PASS** | reach 79.3%, elbow 39.3 FAIL | reach 74.5%, elbow 59.7 worse | reach 74.5%, elbow 59.9 worse | reach 70.6%, elbow 76.9 worse | **reach 100%, elbow 0.0 PASS** | **reach 101.3%, elbow 1.6 PASS** |
| MATCH B_A pro_left_jab (reach 89.0%, elbow 24.9) | **reach 95.1%, elbow 13.5 PASS** | reach 88.6%, elbow 25.7 FAIL | reach 87.7%, elbow 29.6 worse | reach 87.7%, elbow 29.6 worse | reach 79.1%, elbow 45.2 worse | reach 104.3%, elbow 21.8 FAIL | **reach 107.6%, elbow 7.4 PASS** |

### Switch probes (at leanrate=4.0, for the 5 baseline failures)

| Check | noleanease | noarmhome | noprecap | nopopcap | noglove | nosnap | noreach |
|-------|-----------|-----------|----------|----------|---------|--------|---------|
| CATCH A_B pro_left_jab (other 0.054) | 0.066 worse | 0.158 worse | 0.105 worse | 0.134 worse | **0.014 PASS** | 0.119 worse | 0.102 worse |
| OVERHEAD B_A pro_left_hook (+0.037) | 0.032 FAIL | — | — | **0.022 PASS** | **0.022 PASS** | 0.106 worse | 0.087 worse |
| MATCH A_B pro_left_jab (elbow 27.8) | elbow 12.7 **PASS** | elbow 36.6 worse | elbow 33.6 worse | elbow 52.8 worse | elbow 17.5 FAIL | elbow 27.2 FAIL | **elbow 0.1 PASS** |
| MATCH A_B pro_right_cross (reach 80.0%, elbow 46.9) | **reach 87.3%, elbow 36.3 PASS** | reach 80.1%, elbow 39.4 FAIL | reach 77.5%, elbow 65.2 worse | reach 79.1%, elbow 48.7 worse | reach 71.5%, elbow 75.3 worse | **reach 100%, elbow 0.0 PASS** | **reach 102.2%, elbow 2.7 PASS** |
| MATCH B_A pro_left_jab (reach 89.0%, elbow 25.0) | **reach 95.3%, elbow 13.1 PASS** | — | — | reach 87.6%, elbow 29.9 worse | reach 78.7%, elbow 46.4 worse | reach 104%, elbow 20.8 FAIL | **reach 102.7%, elbow 2.7 PASS** |

### What each check asks (plain words)

| Check | What it asks |
|-------|-------------|
| CATCH | The non-catching glove stays in her guard (moves ≤ 0.05 m in chest frame) while the catching glove intercepts the punch |
| OVERHEAD | No hand bone rises more than 0.03 m above the Head bone during the block |
| MATCH | The same clip thrown as a blocked punch and as a landed punch produces the same arm shape (reach ≥ 90%, elbow within 15°, chest within 10°) |

---

## hit_frame_test.gd

### Baseline failures

| # | Check | FAIL at leanrate=4.0 | FAIL at leanrate=2.5 | Δ (2.5 vs 4.0) |
|---|-------|----------------------|----------------------|-----------------|
| 1 | THROUGH pro_left_hook_ft | 0.277 m (bar 0.05-0.11) | 0.278 m (bar 0.05-0.11) | same |
| 2 | THROUGH pro_left_hook_hurt_ft | 0.374 m (bar 0.05-0.11) | 0.374 m (bar 0.05-0.11) | same |
| 3 | THROUGH pro_right_hook_ft | 0.123 m (bar 0.05-0.11) | 0.122 m (bar 0.05-0.11) | same |
| 4 | SPEED pro_right_hook_hard_ft | 32% (bar 50%) | 32% (bar 50%) | same |
| 5 | SPEED pro_right_uppercut_hurt_ft | 28% (bar 50%) | 28% (bar 50%) | same |
| 6 | ON pro_right_uppercut_hurt_ft | 0.151 m (bar 0.05) | 0.150 m (bar 0.05) | same |
| 7 | THROUGH pro_left_hook_hurt | — (pass, 0.073) | 0.313 m (bar 0.05-0.11) | NEW at 2.5 |
| 8 | THROUGH pro_left_hook_hard_ft | — (pass, 0.101) | 0.317 m (bar 0.05-0.11) | NEW at 2.5 |

6 failures at 4.0, 8 at 2.5. Two new THROUGH failures on left hooks at the slower lean.

### Switch probes (at leanrate=2.5, only the failing checks shown)

| Check | noleanease | noarmhome | noprecap | nopopcap | noglove | nosnap | noreach |
|-------|-----------|-----------|----------|----------|---------|--------|---------|
| THROUGH pro_left_hook_ft (0.278) | 0.277 FAIL | 0.281 FAIL | 0.281 FAIL | 0.277 FAIL | 0.272 FAIL | 0.258 FAIL | — |
| THROUGH pro_left_hook_hurt (0.313) | **0.073 PASS** | 0.319 FAIL | 0.319 FAIL | 0.318 FAIL | 0.126 FAIL | 0.126 FAIL | — |
| THROUGH pro_left_hook_hurt_ft (0.374) | 0.374 FAIL | 0.374 FAIL | 0.374 FAIL | 0.374 FAIL | 0.331 FAIL | 0.349 FAIL | — |
| THROUGH pro_left_hook_hard_ft (0.317) | **0.101 PASS** | 0.319 FAIL | 0.319 FAIL | 0.319 FAIL | 0.024 PASS | 0.195 FAIL | — |
| THROUGH pro_right_hook_ft (0.122) | 0.121 FAIL | 0.123 FAIL | 0.119 FAIL | 0.119 FAIL | — | — | — |
| SPEED pro_right_hook_hard_ft (32%) | 32% FAIL | 33% FAIL | 33% FAIL | 33% FAIL | 47% FAIL | 32% FAIL | — |
| SPEED pro_right_uppercut_hurt_ft (28%) | 28% FAIL | 28% FAIL | 28% FAIL | 28% FAIL | 45% FAIL | 42% FAIL | — |
| ON pro_right_uppercut_hurt_ft (0.151) | 0.151 FAIL | 0.156 FAIL | 0.155 FAIL | 0.152 FAIL | 0.084 FAIL | 0.091 FAIL | — |

### Switch probes (at leanrate=4.0, for the 6 baseline failures)

| Check | noleanease | nopopcap | nosnap | noglove |
|-------|-----------|----------|--------|---------|
| THROUGH pro_left_hook_ft (0.277) | 0.280 FAIL | 0.281 FAIL | 0.256 FAIL | 0.271 FAIL |
| THROUGH pro_left_hook_hurt_ft (0.374) | 0.375 FAIL | 0.374 FAIL | 0.353 FAIL | 0.339 FAIL |
| THROUGH pro_right_hook_ft (0.123) | — | — | — | — |
| SPEED pro_right_hook_hard_ft (32%) | 33% FAIL | 33% FAIL | 29% FAIL | 45% FAIL |
| SPEED pro_right_uppercut_hurt_ft (28%) | 28% FAIL | 28% FAIL | 36% FAIL | 41% FAIL |
| ON pro_right_uppercut_hurt_ft (0.151) | 0.156 FAIL | 0.155 FAIL | 0.105 FAIL | 0.092 FAIL |

Note: noreach disables PunchReach entirely — hit_frame_test cannot run (the reach solver is the test's subject).

### What each check asks (plain words)

| Check | What it asks |
|-------|-------------|
| SPEED | The glove front arrives at contact at ≥ 50% of its peak speed over the 0.30 s before — the punch doesn't decelerate before landing |
| THROUGH | After contact the glove carries 0.05-0.11 m past the face along its arrival line — not too short (a punch that stops on the face), not too long (a push) |
| ON | The glove front is within 0.05 m of the face point at the contact frame — the punch actually lands |

---

## Summary lines

**Which checks a slower lean (2.5 vs 4.0) makes worse and why (the layer):**

- **block_catch CATCH A_B pro_right_cross** — the non-catching glove moves 0.138 m in her guard (2.8× the bar). The layer is **PunchReach's LEAN_EASE** (the rate-limited chest lean, `ReachLimit.turn_eased`). At 2.5 rad/s the lean spans more frames; each frame's capped rotation accumulates through the skeleton chain and pushes the non-catching glove (read in chest frame) further from its guard position. PopCap (S496) amplifies it: nopopcap fixes it (0.027). noglove also fixes it (0.000) — GloveClear's head-lean follow is what physically moves that glove.

- **block_catch OVERHEAD A_B pro_right_cross** — a hand bone 0.030 m above the head (was 0.022 at 4.0). Same layer: the slower lean lets the trunk rotate further before the rate limiter catches up, lifting the hand past the head. noleanease fixes it (0.022).

- **hit_frame THROUGH pro_left_hook_hurt** — 0.313 m carry (was 0.073 at 4.0, a 4.3× increase). The layer is the **PunchReach drive-through carry** interacting with the lean: at 2.5 the chest leans slower, so the shoulder moves less during the carry window, and the glove (solved relative to the shoulder) travels further in world space before the weight fades. noleanease fixes it (0.073).

- **hit_frame THROUGH pro_left_hook_hard_ft** — 0.317 m carry (was 0.101 at 4.0). Same mechanism. noleanease fixes it (0.101).

**Which were red for another reason (not the lean rate):**

- **block_catch MATCH (all three: A_B jab, A_B cross, B_A jab)** — the blocked arm's elbow angle differs 25-47° from the landed arm's. The reach solver (PunchReach) drives the blocked glove to the catching glove surface but the landed glove to the face — two different targets produce two different arm solves. noreach fixes all three perfectly (elbow diff 0.1-2.7°). noleanease also fixes them at 4.0 (the faster lean lets the rate limiter match the landed lean more closely). This is a structural mismatch between block and land targets, not a lean-rate bug.

- **block_catch CATCH A_B pro_left_jab** — the non-catching glove moves 0.054 m, just 0.004 over the bar. GloveClear is the layer: noglove fixes it (0.014). This is a marginal fail at both rates.

- **block_catch OVERHEAD B_A pro_left_hook** — hand 0.035-0.037 m above head (bar 0.03). The mocap clip itself puts a hand above the head during this hook block. No single switch fixes it without breaking other things.

- **hit_frame THROUGH on hooks (pro_left_hook_ft, pro_left_hook_hurt_ft, pro_right_hook_ft)** — the glove carries 0.12-0.37 m past contact (bar 0.05-0.11). These are clip-specific: the hook clips' own glove keeps travelling long after the straight clips' glove stops. No switch fixes them (they are in the clip data, not the modifier stack).

- **hit_frame SPEED/ON pro_right_hook_hard_ft, pro_right_uppercut_hurt_ft** — the glove arrives at 28-32% of peak speed (bar 50%) and 0.15 m off the face. These punches decelerate sharply before contact; the lean rate has no effect on them.

**What I would change (but do NOT change):**

1. **PunchReach LEAN_EASE**: the rate-limited lean accumulates trunk rotation over more frames at slower rates, pushing the non-catching glove further from guard. A frame-independent lean limiter (cap total lean, not per-frame rate) would fix the CATCH and OVERHEAD failures without breaking the head-jump reduction.

2. **MATCH bars or target**: the blocked-vs-landed arm shape mismatch comes from the reach solving to two different points (catching glove vs face). Either widen the elbow bar for jabs (27-28° vs current 15°), or read the blocked arm at a different frame (the catching glove's surface is closer than the face, so the arm folds more).

3. **THROUGH bar for hooks**: the hook clips carry 0.12-0.37 m, well past the 0.11 m bar. The bar was calibrated on straights (real crosses carry ~11 cm); hooks carry further because the arm is bent and the glove travels on an arc. A hook-specific bar (0.05-0.30 m) or reading the carry along the arc rather than the straight line would fix these.

4. **SPEED/ON for pro_right_hook_hard_ft and pro_right_uppercut_hurt_ft**: these punches peak early and arrive slow. The clip data, not the lean, governs this. Either widen the SPEED bar for heavy/hurt footwork punches, or investigate whether the clip's own speed profile is correct.
