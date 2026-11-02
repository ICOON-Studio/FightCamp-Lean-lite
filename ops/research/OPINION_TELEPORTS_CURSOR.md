# Opinion: body teleports - Cursor (Composer, read-only run, 2026-09-23 S60)

Brief: `TASK_OPINION_BODY_TELEPORTS.md`. Final message captured verbatim.

---

# Opinion: stopping body teleports permanently

Based on `TASK_OPINION_BODY_TELEPORTS.md` and targeted reads of `FightWorldLiveScreen.gd` (`_place_bodies` → `_floor_clamped` / `_refused_overlap_depth`, frame order around `_update_grapple`, and the existing `_correct_refused_overlap` path).

---

## 1. Permanent fix (architecture, not tweaks)

### Diagnosis in one sentence

Teleports are **discontinuous writers**: overlap refusal applies the **full** refused depth to `_gap` in the same frame (`_floor_clamped` loop: `placed.x += depth + FLOOR_GUARD_M`), and paired grapple **re-poses both roots in one call** (`PairedStagePlayer.remount()` → `PairedClipMount.place` at `_mount_origin`). Rate-limiting gap follow was the wrong layer because the engine gap was never the problem.

The room already knows the right *ingredients*—capsule class thresholds, strike warp scaled before floor, Hermite gap easing for standing pairs (`_update_pair`), and a second pass that tries **hand push** before symmetric root push (`_correct_refused_overlap`). The bug is **which pass wins and that corrections are unbounded per frame**.

### Where the no-overlap guarantee should live

| Layer | Role |
|--------|------|
| **Engine (2D centers, outcomes)** | Stays authoritative for *who won the space* and bout logic. It already enforces a hip/torso floor; it should **not** own skull-vs-forearm mesh detail—that is presentation. |
| **Room: continuous contact budget** | **Primary owner** of “nothing visibly interpenetrates.” Not a boolean “refuse then jump,” but a **per-frame correction budget** applied in order: (1) local pose adjustment (hands, elbows, spine lean—what `ContactSolve` / `push_hand` already sketch), (2) shared separation along the fight line, (3) only if still over threshold, **partial** root separation—never the entire measured depth at once. |
| **IK / partial pose** | Not full fighting-game IK rigs on day one, but **contact-first partial IK**: push violating end-effectors and upper spine before moving hips. That preserves strike warp *intent* while stopping head-in-shoulder without a 0.5 m pair slide. |
| **Motion warping / alignment** | Right tool for **enter/exit** of paired and strike windows—not for every standing frame. Unreal-style root motion warping and fighting-game “alignment” are the same idea: **integrate error over time** toward a target transform with a cap. |

**Judgement:** A full rigid-body physics solver in the room is the wrong product (engine truth constraint, tuning hell). A **presentation contact solver with a hard max-Δ per frame** matches how shipped brawlers behave: Tekken-style pushback, Fight Night / UFC Undisputed-style strike alignment windows, For Honor-style warp-to-marker over a few frames—not one-frame pose snapping.

### Paired clip enter / exit without snap

**Enter (when `_play_grapple_film` / graft succeeds):**

1. **Do not** call instantaneous `remount()` placement on frame 0. Instead, treat mount as a **short alignment segment** (e.g. 80–150 ms at 60 Hz): target = `shared_origin(engine_mid, line_yaw) * retargeted_offsets`, start = current body transforms after retarget graft.
2. Drive both roots as **one rigid unit** (already the `PairedClipMount` model) while **interpolating the mount origin** (translation + yaw) from start to target, with Hermite or smoothstep—same family as `_update_pair` gap easing.
3. Optional **origin search** (cheap): over yaw ±15° and separation ±5 cm, pick the origin that minimizes `alignment_error` + retarget discontinuity so height/reach mismatch does not force a huge first-frame delta. Authored clip spacing will never match every fighter; **calibrated separation scale** (torso sum vs clip rest separation) belongs in metadata or one scalar per pair key, not a one-size snap.

**During grapple:** Keep today’s rule: while `_grapple` is non-empty, **do not** run `_place_bodies` / overlap refusal on roots—the film owns the pair. Penetration during the clip is fixed by **retarget + mount calibration**, not mid-clip gap inflation (which breaks the performance).

**Exit (`_release_grapple`):**

1. Sample **engine-consistent** placement target (centre + gap from track) at release time—not an instant handoff from clip space to `_placed`.
2. Over the next alignment window, **ramp** shared separation and facing from clip end pose to engine-driven `_place_bodies` targets while individual clips (`settle` / hold re-entry) start under paired_hold=false.
3. If mount hold re-enters (`_enter_ground_hold`), **cross-fade** mount origin updates when top side swaps instead of `_release_grapple(true)` → full remount snap.

**Industry (mixed fact and judgement):**

- **UFC / EA Sports MMA (historical Fight Night lineage):** heavy use of **paired sync animations** with **alignment windows** and root warping so feet and hips meet before the “real” frames play; exits often blend to locomotion, not pop.
- **Tekken / Street Fighter:** extreme **pushback** and **move distance** per move—corrections are **integrated over frames**, not one-frame world edits (judgement: same invariant as your probe).
- **EA FC paired celebrations/tackles:** **slot-based alignment** (predefined offset from a joint anchor); mismatch handled by warp duration, not instant teleport (judgement).
- **Sifu / action games:** motion warping to **markers** for hits; paired grabs warp both actors to a **shared root** over a fixed time.
- **For Honor:** attack phases warp toward target **before** damage frames—again time-distributed.

Your standing **pair gap easing** is already the right pattern for strikes; grapple needs the **same contract** applied to **mount origin**, not only to `_gap`.

### Unify overlap policy (structural)

Today overlap is fought twice: **`_floor_clamped`** (pre-placement, can add full depth to gap) and **`_correct_refused_overlap`** (post-advance, hands then roots). Permanent fix: **one pipeline**, one budget:

- Pre-placement: only **warp scale** + **torso floor** (keep S4k lean scaling).
- Post-pose: **all** refused overlap goes through the budgeted solver (hands → spine → capped root), with `_gap` updated by **at most** `STEP_MPS * delta` (you already cap gap steps in `_step_gap`; refusal should inherit the same cap).

That removes the class of events where rendered separation jumps 0.76 m → 1.27 m while engine distance moves millimetres.

---

## 2. Measurable gate

Hold shipping presentation to probe-compatible metrics (same 60 Hz probe definitions):

| Metric | Gate (suggested) |
|--------|---------------------|
| **Body teleports** | **≤ 5 per round** (boxing and MMA), defined as today: root Δ > 0.10 m or yaw Δ > 15° in one 1/60 s frame. Current ~73 / ~45–61 is the baseline to beat. |
| **Writer attribution** | **Zero** events tagged `OVERLAP REFUSAL` with single-frame gap Δ > 0.05 m; **zero** `PAIRED CLIP MOUNT` events with Δ > 0.10 m on enter **or** exit (split enter/exit in probe if not already). |
| **Penetration** | No increase in **head∩head** or **head∩torso** frames over allowance table; maintain U119 intent: skull violations **0** visible frames at probe resolution. |
| **Engine fidelity** | Engine center distance vs rendered hip midpoint: **p95 ≤ 0.05 m** outside paired windows; inside paired windows, **authored relative separation** error ≤ 0.03 m (use `PairedClipMount.alignment_error`). |
| **Gameplay lie** | No new failures in `fight_room_ring_bounds_test` class (rope clamp); grapple hold coverage stats (`hold_s`, cut rate) **no worse than ±10%** vs current—so fixes are not “hide grappling.” |

Regression: keep the existing transition probe on fixed seeds; add a **paired-beat-only** slice and a **clinch-heavy** MMA seed to the gate set.

---

## 3. First this week vs later

**This week (80% path, low risk):**

1. **Cap overlap refusal in `_floor_clamped`**: replace `placed.x += depth + FLOOR_GUARD_M` with “apply min(depth, cap)” and carry **residual depth** in state, shedding it over subsequent frames via `_correct_refused_overlap` (or merge loops entirely). Reuse `STEP_MPS` / same cap as `_step_gap`. *Expected:* most OVERLAP REFUSAL teleports gone without new systems.
2. **Route all refusal through hand-first path**: disable or narrow the pre-placement gap inflation loop to **torso floor + warp scale only**; let post-advance `_correct_refused_overlap` own class-pair fixes (already iterates with `push_hand`).
3. **Grapple enter: 6–10 frame mount-origin ease** on first `play_pair` after graft (not on hold replay `remount()` if origin unchanged). Measure enter-only teleports.
4. **Probe dashboard**: split writers, print max single-frame Δ for gap vs root—so each change proves which bucket moved.

**Later (full architecture):**

- Mount **origin search** + per-pair separation scale for physique mismatch.
- Grapple **exit ramp** synced to engine track sampling.
- Richer partial IK (spine lean cap) shared with strike contact phase.
- Optional engine export of **minimum center distance envelope** per pose class for booking—only if presentation-only solver still fights the sim in edge cases.

---

## 4. Argue against myself

**Strongest case that this plan is wrong or too expensive**

- **Caps hide penetration:** If you spread 0.5 m refusal over 25 frames, the player may see **10–15 frames of illegal overlap** the operator already rejected. Budgeted correction trades **teleport visibility** for **sustained interpenetration**—possibly worse for trust.
- **Paired alignment windows lie about timing:** Easing mount origin over 100 ms **desyncs** the film from the engine beat that scored the takedown at a specific tick; judges and strike stats assume the picture matches the sim clock. Fighting games accept that; a **management sim with faithful replay** may not.
- **Dual solver complexity:** Merging `_floor_clamped` refusal with `_correct_refused_overlap` plus mount warping creates **ordering bugs** (feet lock, `_aim_strikes`, rope clamp last-write) and is easy to get wrong in a 3k-line screen—months of seam work for a team that is not Ubisoft.
- **IK is a tar pit:** Partial hand push that fails on extreme reach mismatch will still fall back to root push; you rebuild a worse physics engine in GDScript.
- **Height mismatch is fundamental:** Paired mocap is one morphology; retarget + scale fixes (S6c comments) mean **perfect no-snap enter** may be impossible without per-fighter re-authored pairs—alignment windows only soften an uncorrectable error.

**Cheapest 80% benefit**

1. **Single rule:** No presentation system may move a root or `_gap` by more than **`STEP_MPS * delta` (or a fixed 2 cm/frame)** in one frame—apply to `_floor_clamped` refusal, `_correct_refused_overlap` root half-push, and grapple mount translation/yaw on enter/exit.
2. **Delete duplicate writer:** Stop increasing `_gap` in `_floor_clamped` for class-pair refusal; rely on `_correct_refused_overlap` only (already hand-first).
3. **Grapple:** On enter, if alignment delta > threshold, **delay film start 2–3 frames** and ease mount origin only (no new IK)—cheap mirror of `_update_pair`.

That trio does not require engine changes, new assets, or a full motion-warp framework—only **stateful caps and reordering**—and directly targets the two probe writers named in the brief, at the cost of possibly allowing brief, shallow overlap instead of instant separation.
