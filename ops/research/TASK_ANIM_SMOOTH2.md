# TASK ANIM-SMOOTH2 - smooth fight animation, Ludo steps 3-4: no bodies through bodies, no snap between moves

Model: Codex gpt-6.1-sol. START ONLY AFTER ANIM-SMOOTH1 IS MERGED ON MASTER (same files; its `smooth_log` + `Tools/smooth_metrics.py`
are your instrument). Worktree E:/FightCamp/wt/ANIMSMOOTH2, branch codex/anim-smooth2 from master. Push the branch; never master.
Never open a window, viewer, video player or browser; windowed Godot only via `Tools\godot_hidden.ps1`; frames with your file tool.

Operator S192: "the animations are not feeling smooth , use ludo which is expert in 3d animation to solve our animations with the
help of codex on that". Spec of record: `research/LUDO_ANIMATION_S192.md` - round 9 B4 (separation) + B2 (inertialization)
and ROUND 10's transition table (blend type, duration, earliest exit, chaining for every pair). Read the whole file first.

## Carried from ANIM-SMOOTH1 (merged 6d864968; read research/ANIM_SMOOTH1_REVIEW.md)
- Baseline on seed 94400 is in ANIM_SMOOTH1_BASELINE.txt / _AFTER.txt. SMOOTH1 left join p95 UP 10% (34,667 -> 38,239 deg/s2)
  with alive_breath ON - measure your joins with alive_breath ON as well as OFF and bring p95 below the SMOOTH1 baseline.
- Pelvis minimum is 44.5 cm with 6 frames under 55 cm - that is your separation baseline.
- If cloud Qwen's ANIM-INERT1 (issue #85: FightInertialize.gd + anim_transitions.json) is on master when you start, USE it
  (do not write a second one); if not, write them yourself to the API in TASK_ANIM_INERT1.md.

## Owned files
- `Godot/scripts/FightStagePlayer.gd` (5,850 lines - windows only): where a clip change happens (grep `play_role`, `_crossfade`,
  `blend`, `custom_blend`, `seek`) - the join.
- `Godot/scripts/FightWorldLiveScreen.gd` (6,350 lines - windows only): where both bodies are placed each frame (`_update_pair`,
  `_rope_clamp_pair`, `_finish_root_frame`, the 3 cm / 10 deg root cap) - the separation.
- `Godot/scripts/FightInertialize.gd` (NEW, pure: per-bone offset + velocity decay, half-life input; zero preloads).
- `Godot/assets/data/anim_transitions.json` (NEW: Ludo's round-10 table as data, state classes -> {blend, duration_s, exit_frac, chain}).
- `Godot/tests/anim_smooth2_test.gd` (NEW).

## Prior research
- `research/topics/playback_blend.md` (canonical) - G147 numbers, Q84 "how Godot blends" (linear weight, per-bone slerp),
  U99 (88% of top-1% jerk is at joins), OPINION_TELEPORTS_SYNTHESIS (root write cap), C119_UE_JOINS (Unreal dead blending source).
- Body radii come from the meshes' skin weights: `FightBodyRadius.gd` (S4) and the engine's `FightSeparation.gd` - use them for the
  minimum gap (Ludo's 58 cm is his placeholder; round-9 verdict 4).
- `python Tools/prior_research.py inertialization dead blending` and `... separation overlap torso` before writing.

## What would a human do?
At every clip change, keep the body's current motion and let it decay into the new clip (inertialization) with Ludo's per-pair
durations, and when the two men's torsos would overlap, push the drawn bodies apart on a critically damped spring - then measure the
join spikes and the overlap before and after on the same seed.

## Prefab check
Godot 4.7 AnimationTree has no inertialization node (Unreal does: "Inertialization" / dead blending, Holden 2023 - public, see
C119). Write the pure offset-decay module; it is ~80 lines.

## Spec
1. SEPARATION, room switch `body_spacing` (default OFF in --script runs): when pelvis-to-pelvis distance < the sum of the two torso
   radii (measured, print them), a critically damped spring (zeta 1.0) pushes the DRAWN roots apart along the line between them;
   never write the engine state; the root write cap (3 cm / 10 deg per frame) still applies. In a clinch, add Ludo's upper-arm flare
   (up to +35 deg roll when distance < 72 cm) so gloves rest on the guard instead of through it.
2. JOINS, room switch `inertial_joins` (default OFF): at a clip change, FightInertialize captures each bone's offset (old pose -
   new pose) and its velocity, then adds a decaying offset to the new clip (half-life 0.05 s, total length = the table's duration for
   that pair). Pairs come from anim_transitions.json; Cut = no offset; an unknown pair falls back to today's crossfade and is counted
   (print the count). Earliest-exit fractions: only where our scheduler already lets a clip be cut early - do not change WHEN the
   sim's actions happen (the clip owns a committed strike's timing - playback_blend.md "Settled").
3. Measure on seed 94400 (NOT 94301) with smooth_metrics: (3) min pelvis distance + frames under the torso-radii sum, (4) join
   angular-acceleration median + p95, before (switches OFF) vs after (both ON); camera/idle/feet within +-10%. Two silent mp4s
   before/after in E:/FightCamp/tmp/anim_smooth2/, 6 frames of each opened (both men head to feet).

## Done = (tier: script edited)
- Parse gate on every touched .gd. `anim_smooth2_test.gd`: FightInertialize decays a 30 deg offset to < 1 deg within 4 half-lives,
  carries the initial velocity (no dead stop at t=0+), Cut = zero offset; the table loads and every Ludo row is present; the spacing
  spring never lets the drawn pelvis distance fall below the radii sum in a scripted overlap. RED first on master (paste the count).
- `run_tests.py --only fight_stage --jobs 2`, `--only alive --jobs 2`, `--only camera --jobs 2` -> 0 fails.
- Switches OFF = byte-identical CSV to master on the same seed (one OFF re-record).
Commit + push codex/anim-smooth2. Final message: red count, green results, before/after numbers, mp4 paths.

## The one trap
Inertialization ADDS a decaying offset to the NEW clip - it must never evaluate the old clip any more (that is a crossfade), and the
gloves/hand-contact layers read the final pose, so apply the offset before them, not after.
