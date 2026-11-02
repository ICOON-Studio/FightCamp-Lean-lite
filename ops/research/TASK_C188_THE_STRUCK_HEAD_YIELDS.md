# TASK_C188 - the struck head yields: a physics spring on head/neck/chest when a blow lands (Codex, full branch)

Model: gpt-6-astra, medium (motion on a skeleton - CODEX_MODEL=gpt-6-astra). Owner: codex. Queued S65 behind C187, 2026-09-24.

## Why (read first: `research/G86_PHYSICS_HIT_REACTIONS.md`, Grok, 109 sources)
The operator asked "do we have physics and ik?". IK: yes (arm, leg, contact solver, anchor). Physics: none - two clips
meet with no shared force axis, which is part of "abrupt". G86: shipped fight games keep the DECISION in rules and
clips and use physics as a short overlay on the struck segment (UFC 2009, Ueno GDC 2010; UFC 6 knockdown blend).
Godot 4.7 does the slice officially: `PhysicalBoneSimulator3D.physical_bones_start_simulation([bones])` + `influence`.
**Physics does NOT fix clipping** (that is the contact solver) and must NEVER move the root.

## The slice - exactly G86 section 3, nothing more
On an impact the room ALREADY presents as landed (`AIM_LANDED_CONTACTS` clean/glancing/absorbed in
`FightStagePlayer.gd`; the engine's force and direction): on the STRUCK fighter only, simulate Head, Neck and ONE
upper-spine/chest bone; apply an impulse along the blow's direction scaled by its force; hold ~0.15-0.20 s; tween
`influence` 1 -> 0 over 0.20-0.40 s; stop; reset influence to 1. Physical bones on their own collision layer with
exceptions against the other fighter, the floor and self. Arms, hips, root and legs stay animated (arm IK, leg IK,
the 20 Hz balance model own them). Behind a room switch `hit_physics`, default OFF until the operator's A/B verdict.
Know the traps G86 names: influence is global to the simulator; mid-range influence glitches the step; start()
adds bones and does not stop others.

## Measure it - "looks better", not "it runs" (G86's own list)
Seed 92012, same camera, switch OFF vs ON, 10-20 landed head/body blows: (a) head linear/angular velocity aligned
with the punch direction on frames 1-8 after contact, both arms; (b) time for head/torso to return to the clip's
pose (target <= 0.4 s, no hang); (c) mesh-mesh penetration at contact frames must NOT get worse (if it does, fail
the slice); (d) frame time for two fighters, no drop below 60 fps. Then an A/B side-by-side video of the SAME 10 s
(`research/_captures/watch_loop/c188_hit_physics_ab.mp4`, MP4 <50 MB) for the operator's eye - that is the gate.

## Owned files
`scripts/FightStagePlayer.gd` (a new hit-physics section; keep clear of C187's root/hand functions),
`scripts/FightWorldLiveScreen.gd` (the switch and the call site only), a new `scripts/FightHitPhysics.gd`,
a new `tests/fight_hit_physics_test.gd` (the root never moves; influence returns to 1; switch OFF = byte-identical pose),
a new `Godot/tools/c188_hit_physics_ab.gd`, the mp4, `research/C188_DIGEST.md`.

## Gate (tier: scripts edited)
Parse gate on touched .gd; `fight_hit_physics_test` green with mutants (root allowed to move; influence left at 0)
caught; then `python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,fight_hit`.
`fight_stage_realism_test` is red at baseline with 8 fails - a CEILING. Windowed runs through `Tools\godot_hidden.ps1`.
Branch `codex/c188-hit-physics`, worktree off `origin/master` (after C187 merges), `--headless --import` once first.
Commit, push, one `agent_comms.py send --from codex --to claude --topic C188` per part. Do NOT edit HANDOFF.md.
Trap: a spring you can only see in a metric is not the deliverable - the A/B video is.
