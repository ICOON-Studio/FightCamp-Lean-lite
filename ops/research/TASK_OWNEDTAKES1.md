# TASK OWNEDTAKES1 - the owned mocap takes play: boxers shadowbox in their corner before the bell (S392, agy)

Model: gemini-3.8-flash-high. FILE TOOLS ONLY: no shell, no git, no Godot. Discipline: boxing.

## Why
Board Q-S294-109, operator: "Yes" to using the 7 owned takes in assets/anim/baked/owned (ops/research/OWNED_MOCAP_S381.md). Nothing plays them. They are long shadowboxing and guard takes, wrong for the bout itself, which plays exchange clips. Right for the wait before the bell: today boxers stand idle in their corner.

## What to build (owned files ONLY)
1. `scripts/fight3d/CornerWarm.gd` (new, pure static where it can be): `pick(seed: int, has: Callable) -> String` picks one of `rk_shadowboxing_a`, `rk_shadowboxing_b`, `rk_boxing`, `cmu_13_17`, `cmu_13_18`, `cmu_14_01`, `cmu_14_02` that the player has, and `window(clip_len: float, seed: int, want_s: float) -> Vector2` picks a start and end inside the take.
2. `scripts/fight3d/FightIntro.gd`: in `cue_corners`, while a boxer waits in the corner, loop that take's window. Everything that follows (`cue_tape`, `cue_walk`, the rig taking the legs) must find the boxer in the guard as before: return to guard at the next cue. A `-- nowarm` argument keeps today's idle as the control arm.
3. If `FightClips.gd` does not load `assets/anim/baked/owned`, add that folder to its loader.
4. `tests/corner_warm_test.gd` (new): `pick` is stable for a seed, never returns a clip `has` refuses, `window` stays inside the take and is `want_s` long or the whole take.

Keep the feet honest: RingFeet and FootPlant own the legs, so read how `CornerCrew.play` starts a clip and use it. Do not touch BoxerFootwork, RingFeet or RingPlace.

## Contract
OWNS: scripts/fight3d/CornerWarm.gd, scripts/fight3d/FightIntro.gd, scripts/fight3d/FightClips.gd, tests/corner_warm_test.gd
RED_TEST: tests/corner_warm_test.gd
REGRESSION: corner_lens_test, fight_flow_test, ring_feet_test
VISUAL: yes
