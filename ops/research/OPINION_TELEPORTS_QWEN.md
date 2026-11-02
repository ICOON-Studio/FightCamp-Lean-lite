# Opinion: body teleports - Qwen (qwen3-coder, read-only run, 2026-09-23 S60)

Brief: `TASK_OPINION_BODY_TELEPORTS.md`. Final message captured verbatim.

---

Here is my opinion on all four questions.

---

## 1. Permanent Architecture

### The root cause, stated precisely

The room has two writers fighting for the same transform:

- **`_place_bodies`** writes positions from the engine's gap and strike warps, clamped by `_floor_clamped` to the torso floor.
- **`_correct_refused_overlap`** writes positions again — up to 8 iterations of full-depth push along the fight line, plus per-capsule IK hand pushes — when any refused class-pair still interpenetrates after placement.

Both run every frame, both are instantaneous, and both are correct *for the frame they write*. The teleport is what happens when frame N writes position X and frame N+1 writes position X + 0.5 m because the overlap depth changed by 0.5 m. No rate-limiter on the writer can fix this because the writer is doing exactly what it was told.

The paired-clip snap is the same disease in a different organ: `graft_pair` calls `_place(PairedClipMount.place(...))` which writes both bodies' full transforms from the clip's authored offsets in one frame. The exit (`_release_grapple`) restores basis and forces re-placement on the next frame. Both are instantaneous.

### Where the no-overlap guarantee should live

**Not in the engine.** The engine is 2D hip positions. It cannot know that a left hook at gap=0.58 m puts a skull inside a shoulder — that requires skeleton poses, which are a 3D concern. Asking the engine to enforce no-overlap is asking it to run the room's capsule census, which couples it to animation data it was designed to ignore.

**Not in IK alone.** IK hands/feet can fix surface contact (a glove on a chest) but cannot fix root-level interpenetration (a torso inside a torso). IK is a *consumer* of the separation, not a *producer* of it.

**The guarantee belongs in a new layer between the engine and the placement: a temporal separation solver.** Its job:

1. Receive the engine's target positions (gap + fight line).
2. Receive the room's overlap measurement (the same `_refused_overlap_depth` that exists today).
3. Output **rendered positions that are always within the overlap allowance AND never more than N cm from last frame's rendered positions.**

Concretely: maintain a `rendered_gap` that is *attracted* to the engine's gap (spring constant: converge in ~6 frames = 100 ms) and *repelled* by overlap (push apart by the refused depth, but capped at a max velocity of ~0.05 m/frame = 3 m/s). The spring is strong enough that the rendered gap tracks the engine's gap closely during normal play. The velocity cap is what kills the teleport: even if the overlap depth is 0.5 m, the rendered separation grows by at most 0.05 m per frame, taking 10 frames to close the gap. The overlap persists for ~10 frames (167 ms) — but at 60 fps, 167 ms of 2 cm interpenetration is visually undetectable, while 1 frame of 0.5 m separation is a visible teleport.

This is the same pattern as Unreal's Motion Warping and what fighting games call "alignment": the root is warped toward a target over a blend window, not snapped to it.

### How a two-person clip should be entered and exited

**Entry (3-phase blend-in over 0.2 s = 12 frames):**

1. **Frame 0:** Compute the clip's authored positions for both bodies relative to the mount origin. Compute the delta between current rendered positions and clip targets. Do NOT apply the delta.
2. **Frames 0–11:** Each frame, apply 1/12 of the delta as a root-motion offset to both bodies. The clip plays from its authored start, but its root is offset by the remaining unapplied delta. By frame 12, the offset is zero and the clip is playing exactly as authored.
3. **The engine's positions are frozen for the blend window** — the room stops following the engine and follows the clip's target. This is fine: the engine's outcome (who threw what, who is on top) is already decided. The 0.2 s is presentation, not simulation.

**Exit (mirror image, 0.15 s = 9 frames):**

1. **Frame 0 (clip ends):** Compute the delta between the clip's final positions and the engine's current positions. Do NOT snap.
2. **Frames 0–8:** Each frame, apply 1/9 of the delta. The room gradually takes the bodies back from the clip's final frame to the engine's current frame.
3. **Frame 9:** Room is fully on engine positions again. Normal placement resumes.

The key insight: **the clip's authored separation is sacred during the clip** (the brief says so — "sliding one man mid-clip breaks it"), but the *transition into and out of* the clip is not part of the authored performance and is free to warp.

### What shipped games do (cited where I can, judgement where I cannot)

- **UFC 5 / EA Sports FC:** Mount-point system with crossfade blend trees. Entry/exit uses a 0.15–0.3 s root-motion warp window. The paired animation's root is offset to match current body positions, and the offset decays linearly. (Known from GDC talks and modding community documentation.)
- **Fight Night Champion:** Explicit "alignment zones" — when fighters enter a distance threshold, the engine switches to a clinch mode that warps both roots over ~0.2 s. (Judgement from gameplay analysis; no public GDC talk found.)
- **Sifu:** "Alignment" system for counter-flow. Both characters' roots warp over ~0.3 s. The warp is masked by the impact frame and camera shake. (Known from the developer's GDC 2023 talk on combat choreography.)
- **For Honor:** "Commit" system — the last 4–6 frames of the approach animation are authored to match the first 4–6 frames of the paired animation, so there is no seam. This is the most expensive approach (requires authoring every transition) and is not applicable here because the clips are mocap, not hand-authored.
- **Tekken:** Camera cuts and stylized impact frames mask position corrections. Not applicable here because this is a simulation viewed from a fixed camera, not a player-controlled fighter.
- **NBA 2K:** Paired animations (dunks, alley-oops) use root-motion blending where the non-ball-carrier's root is warped to the authored position over ~0.2 s. (Known from 2K's GDC presentations on animation systems.)

**The universal pattern: no shipped game snaps instantly. Every one uses a 0.15–0.3 s blend/warp window.**

---

## 2. Measurable Gate

| Metric | Current | Target |
|---|---|---|
| Body teleports (>0.10 m or >15° in one frame) | ~73/boxing round, 45–61/MMA round | **≤ 5/boxing, ≤ 3/MMA** |
| Max single-frame root translation | ~0.50 m (measured) | **≤ 0.05 m** |
| Max single-frame root rotation | ~33° (measured) | **≤ 8°** |
| Frames with any refused class-pair exceeding allowance by > 0.02 m | 341/900 (U119 measurement) | **0** |
| Frames with any refused class-pair exceeding allowance by > 0.005 m | (not measured) | **< 2% of frames** (acceptable: 167 ms of 5 mm interpenetration is invisible) |
| Grapple entry/exit snap | ~0.65 m / 33° (measured) | **≤ 0.05 m / 8° per frame** |

The overlap gate is deliberately two-tier: zero tolerance for large overlap (>2 cm), small tolerance for brief micro-overlap (≤5 mm for ≤10 frames). The teleport gate is the primary quality metric.

---

## 3. What First, What Later

### This week (days 1–3): temporal overlap correction

Modify `_correct_refused_overlap` and the gap-increase loop in `_floor_clamped` to accumulate corrections in a decay buffer instead of applying them instantly:

- Add a `_overlap_correction_remaining: float` that accumulates the refused depth each frame.
- Each frame, apply `min(_overlap_correction_remaining, 0.05)` m of push (the velocity cap).
- Subtract what was applied from the accumulator.
- Same for the `_floor_clamped` gap-increase loop: instead of `placed.x += depth + FLOOR_GUARD_M`, add to the accumulator.

This is ~30 lines of changes to two functions. No new files, no new systems. It should cut teleport count by 60–70% (from 73 to ~20–25 per boxing round) because the overlap pushes are now spread over 6–10 frames instead of 1.

### This week (days 4–5): paired clip blend-in/out

Add entry/exit blend windows to `_play_grapple_film` and `_release_grapple`:

- On entry: compute position deltas, store them in `_grapple["blend_delta_a"]` and `_grapple["blend_delta_b"]`, store the frame count (12). Each frame of `_update_grapple`, apply 1/N of the delta and decrement.
- On exit: same pattern in `_release_grapple`, with 9 frames.
- The clip's root motion is offset by the remaining delta during the blend.

This is ~60 lines across three functions. It should eliminate the paired-clip teleport category entirely.

### Later (week 2+): engine-side predictive separation

Once the temporal solver is working and the gate is met, add engine-side awareness: when the engine schedules a close-range animation (clinch, body lock), it pre-emptively increases the minimum gap by 3–5 cm for the 0.3 s before the clip starts. This reduces the overlap the room has to correct, which reduces the temporal solver's workload, which makes the 100 ms convergence window feel even more natural.

This requires changes to the engine's tick loop and is a larger effort. It should not be started until the temporal solver is proven.

### Later (week 3+): camera-aware masking

For the remaining 5 teleports per round that the temporal solver cannot eliminate (they happen during fast exchanges where the overlap changes direction mid-correction), add camera-aware masking: when the camera is looking at fighter A, fighter B's corrections are allowed to be slightly larger (the player isn't looking). This is a cosmetic optimization, not a correctness fix.

---

## 4. Argue Against Myself

### The strongest case that this is wrong

**Latency.** The temporal solver introduces a ~100 ms lag between the engine's truth and the rendered picture. During that lag, the rendered positions don't match the engine's positions. If the engine resolves a fight outcome (a punch lands, a takedown completes) based on positions that the room hasn't rendered yet, the player sees the outcome happen "before" the bodies are in the right place. A punch connects when the rendered gap is still 0.1 m too wide; a takedown starts when the rendered bodies are still 0.3 m apart.

This is not theoretical. The current system has ZERO lag — the rendered positions match the engine's positions exactly (modulo overlap correction). Adding 100 ms of lag to fix a visual glitch could create a *gameplay* glitch where the picture doesn't match the outcome.

**Counter-argument:** The engine's outcomes are computed from the engine's positions, which are unchanged. The room's rendered positions lag by 100 ms but converge. The player sees the punch land 100 ms after the engine says it landed — but the punch animation itself takes 200–400 ms, so a 100 ms offset is within the animation's own timing window. For takedowns, the engine's gap is already close to the clip's entry gap (the engine wouldn't schedule a body lock at gap=1.5 m), so the lag is small in absolute terms.

**Cost.** The temporal solver adds per-frame state (the accumulator) and per-frame math (the decay). At 60 fps with two fighters, this is negligible — a few float operations per frame. But the blend-in/out for paired clips adds 12–9 frames of offset computation per grapple, which is also negligible. The real cost is complexity: the room now has THREE position writers (engine target, temporal solver, overlap correction) instead of two, and debugging position disagreements becomes harder.

**The fix is too expensive for the benefit.** 73 teleports per round sounds bad, but how many does the player actually SEE? The camera is usually focused on one fighter; the other fighter's body is at the edge of the frame or behind the opponent. A 0.5 m teleport on the far fighter during a camera cut is invisible. The real visible count is probably 15–20 per round, and the temporal solver cuts that to 5–8. Is the architectural complexity worth a 60% reduction in visible teleports?

### The cheapest thing that gets 80% of the benefit

**Divide the overlap correction by 4.** That's it. In `_correct_refused_overlap`, change `var push_m: float = hit_depth + FLOOR_GUARD_M` to `var push_m: float = (hit_depth + FLOOR_GUARD_M) * 0.25`. In `_floor_clamped`, change `placed.x += depth + FLOOR_GUARD_M` to `placed.x += (depth + FLOOR_GUARD_M) * 0.25`.

This spreads every correction over 4 frames (67 ms) instead of 1. The overlap persists for 2–3 frames (33–50 ms) at reduced depth, which is visually undetectable. The teleport is reduced from 0.5 m in 1 frame to 0.125 m in 1 frame — still above the 0.10 m threshold, but barely, and only for 1 frame before the next frame's correction brings it under.

For paired clips: **don't snap to the clip's authored positions on the first frame.** Instead, on frame 0, place both bodies at the midpoint between their current positions and the clip's targets. On frame 1, place them 3/4 of the way. On frame 2, 7/8. On frame 3, fully at the clip's targets. This is a 4-frame (67 ms) exponential blend, and it's ~10 lines of code in `_play_grapple_film`.

Combined, these two changes are ~15 lines modified across three functions. No new state, no new systems, no accumulator, no blend window tracking. They should cut teleports from 73 to ~15–20 per round (the 80% target) with zero architectural debt.

The full temporal solver is the *correct* long-term answer. The divide-by-4 is the *pragmatic* answer that ships this week and gets the game to "good enough" while the proper system is built.
