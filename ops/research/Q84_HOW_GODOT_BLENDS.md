# Q84 — How Godot 4.7.2 blends

## DECISIONS

| # | Answer | Source | Measured |
|---|--------|--------|----------|
| Q1 | Weight is **linear**; per-bone rotation is a **slerp** via `interpolate_via_rest`. | `animation_player.cpp:293`, `animation_mixer.cpp:1508`, `animation.h:539` | +60→-60 in 0.50 s: mid-blend angle 0° at t=0.25 s (exact); settled at -60° by t=0.50 s. |
| Q2 | Outgoing clip **keeps advancing** during the blend. | `animation_player.cpp:300` | RAMP at +15° then play H15(0.25): peak deviation +6° from +15 (21° at t=0.133 s). |
| Q3 | Second `play()` mid-blend does **NOT snap**. | `animation_player.cpp:500-505` | Largest step after second call ≈3.3° vs before ≈8.6°; ratio < 2. |
| Q4 | `seek(t, true)` right after `play()` does **NOT snap**. | `animation_player.cpp:712-714` | First sample after seek = 60.0° (unchanged from pre-call). |
| Q5 | `speed_scale` **stretches** the blend inversely. | `animation_player.cpp:293` | At speed 0.5 the blend completes at 1.00 s (= 0.50 / 0.5). |
| Q6 | Capture blending does **not** apply to `TYPE_ROTATION_3D` bone tracks. | `animation_mixer.cpp:1018`, `animation_mixer.cpp:1508` | Source-only: capture path (`_blend_capture`) is separate from the transform-track blend path. |
| Q7 | **No inertialization** in 4.7.2. | Searched `animation_mixer.cpp`, `animation_player.cpp`, `animation_blend_tree.cpp`, `animation_node_state_machine.cpp` | Source-only: no match for `inertiali[sz]ation` in any of the four files. |

## WHAT THIS MEANS FOR FightStagePlayer

1. **Linear weight is safe for S4a's 0.20–0.25 s crossfades.** The current uniform 0.10 s
   (`BLEND_S`, line 205) can be raised without surprise: the bone traverses intermediate
   angles at a constant rate, so a longer blend is visibly proportional.

2. **The outgoing clip keeps moving.** A strike that finishes in guard and blends into
   stance will see the strike clip's last frames continue to advance under the blend —
   the guard pose is not frozen at the instant of `play()`. S4a must make sure the
   outgoing clip's final frames already show the guard; the blend will not hold them.

3. **A second `play()` mid-blend is smooth.** When a beat fires a new clip while the
   previous blend is still running, the old outgoing animation drops out of the blend
   stack gracefully — the new clip inherits the current weight and there is no visible
   snap. This is exactly what fast beat schedules need.

4. **`seek()` after `play()` is safe.** `FightStagePlayer.gd:270` calls
   `_ap.seek(_loop_phase * clip.length, true)` right after `play()`. The probe shows
   this does not snap the pose — the blend continues from the pre-seek angle.

5. **`speed_scale` stretches the blend.** The 0.85–1.15 per-clip tempo range
   (`FightStagePlayer.gd:263`) changes the effective blend duration by ±15 %. At
   `BLEND_S = 0.10` the visible range is 0.087–0.118 s — imperceptible. At the S4a
   target of 0.20–0.25 s the range widens to 0.174–0.294 s, which is noticeable.
   S4a should either reset `speed_scale` to 1.0 before the blend or accept the
   variation as a natural feel difference between fast and slow fighters.

6. **No capture blending on bone rotation tracks.** `play_with_capture` and
   `playback_auto_capture` do not reach `TYPE_ROTATION_3D` skeleton bone tracks.
   If S4a wants a "capture the current pose and ease out of it" transition on bone
   rotations, it must be implemented in GDScript (e.g. a one-shot additive clip),
   not via the built-in capture API.

7. **No inertialization available.** Godot 4.7.2 has no built-in inertialization in
   `AnimationMixer`, `AnimationPlayer`, `AnimationBlendTree`, or
   `AnimationNodeTransition`. If S4a wants velocity-preserving transitions (the
   "inertialize" technique from the animation research literature), it must be
   implemented manually — either as a post-process on the bone poses or as a
   custom `AnimationNode` in an `AnimationTree`.
