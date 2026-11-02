# Q85 — THE FIVE PLAYBACK MECHANICS S4a's TRANSITIONS STAND ON

## DECISIONS

**Q8 (custom_speed):** A 0.25s blend with `custom_speed=0.5` completes at **0.25s**, not 0.50s. `custom_speed` scales the clip playback but not the blend weight transition. Source: `animation_player.cpp:427` (custom_blend), `:453` (custom_speed). Measured: settles at -60° at t=0.25s.

**Q9 (queue):** When P60_SHORT (0.30s, non-looping) ends and Z0_LOOP is queued with `default_blend_time=0.25`, there are **0 freeze frames** and Z0_LOOP arrives with a **0.25s blend** (not a cut). Source: `animation_player.cpp:365-370` (queue), `:258-260` (queue processing). Measured: reaches 0° at t=0.55s.

**Q10 (pair blend):** With `default_blend_time=0.10` and `set_blend_time("P60","M60",0.40)`, `play("M60")` with no custom blend takes **0.40s**. The pair blend overrides the default. Source: `animation_player.cpp:426-442`. Measured: settles at -60° at t=0.40s.

**Q11 (outgoing ends mid-blend):** When P60_SHORT ends at t=0.10s during a 0.25s blend, it **holds its last frame** (+60°). The blend continues smoothly toward M60 with **no jump**. Source: `animation_player.cpp:226`. Measured: max step-jump during (0.10,0.25] is 8.57°, same as before 0.10s.

**Q12 (animation_finished under advance):** With only `advance(1/60)` stepping, the signal **fires** at t=0.30s (step 18), exactly when the 0.30s clip reaches its end. Source: `animation_player.cpp:258,272`. Measured: fires at t=0.30s.

## WHAT THIS MEANS FOR FightStagePlayer

### How to slow a walk without stretching blends

Q8 shows that `custom_speed` does NOT stretch blends. The blend duration is controlled by `custom_blend` (or the configured blend times), not by the animation's playback speed. This means you can use `play("walk", custom_blend, custom_speed=0.17)` to slow the walk to 0.17x (for a planted foot) without making the 0.25s blend into or out of it take 1.5s. The blend stays at 0.25s; only the clip playback slows.

This is critical: Q84 measured that `speed_scale` (the player-wide property) DOES stretch blends (a 0.50s blend took 1.00s at 0.5x). But `custom_speed` (the per-play parameter) does not. So the walk should use `custom_speed`, not `speed_scale`, to avoid stretching every blend.

### How to return a finished clip to stance with no frozen frame

Q9 and Q12 together show the path: when a non-looping strike clip ends, the `animation_finished` signal fires (Q12). Connect to it and call `play("stance")` (or `queue("stance")` before the clip starts). The queued stance arrives with a blend (Q9), not a cut, and there are no freeze frames — the bone does not hold the clip's last pose before blending.

The realism test (fight_stage_realism_test.gd) found fighters frozen on 26-29% of frames: a non-looping clip ended and the body held its last frame until the next beat. Q9 shows that with `queue()` and a configured blend time, the transition is smooth. The key is to queue the return-to-stance animation BEFORE the strike starts, or connect to `animation_finished` and play the stance immediately.

### Whether per-pair blend times can carry "blend longer when the poses differ"

Q10 shows that `set_blend_time(from, to, sec)` overrides the default. You can set a short default (0.10s) for most transitions and a longer pair blend (0.40s) for specific pairs that need it (e.g., a big pose change like guard-to-hit). The pair blend is used when `play()` is called with no custom blend.

This means the presenter can encode "blend longer when the poses differ" by setting pair blend times for the large transitions (guard-to-knockdown, knockdown-to-getup) and leaving the default short for similar poses (guard-to-guard, idle-to-idle). The blend time is a property of the (from, to) pair, not the clip, so it can be tuned per-transition without changing the clips.

### The outgoing clip holds its last frame — no inertialization, no snap

Q11 shows that when an outgoing clip ends mid-blend, it holds its last frame. The blend weight continues to transition, so the angle moves smoothly toward the incoming clip. There is no jump, no snap, no inertialization.

This is the same behavior Q84 measured for looping clips: the outgoing clip keeps advancing during the blend. For non-looping clips, "advancing" means holding the last frame when the clip ends. The blend is a linear slerp between the outgoing and incoming poses, weighted by `blend_left` (which decrements based on time, not on the clip's playback position).

This means the S4a transitions can rely on smooth blends even when the outgoing clip is shorter than the blend duration. The outgoing holds its last frame, the blend continues, and there's no discontinuity.

## SUMMARY

The five mechanics are:
1. **custom_speed** scales clip playback, not blend duration — use it to slow walks without stretching blends.
2. **queue()** with a configured blend time gives smooth transitions from finished clips, no freeze frames.
3. **set_blend_time()** overrides the default per-pair — encode "blend longer when poses differ" in the pair table.
4. **Outgoing clips hold their last frame** when they end mid-blend — no snap, no jump, smooth slerp.
5. **animation_finished fires under advance()** — connect to it for return-to-stance, or queue the stance before the strike.

All five are measured, not guessed. The S4a transitions can stand on them.
