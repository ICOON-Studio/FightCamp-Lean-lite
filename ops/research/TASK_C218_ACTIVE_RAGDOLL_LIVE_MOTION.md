# TASK C218 - CODEX - ACTIVE RAGDOLL: PASS THE LIVE-MOTION GATE (S103)
Owner: codex. Assigned 2026-09-27 (S103). Model: `gpt-6-astra` MEDIUM (`CODEX_MODEL=gpt-6-astra`; 3D animation lane,
operator rule 2026-09-25), `CODEX_WEB=live`. Branch `codex/c218-ragdoll-live-motion` from `origin/codex/c217-active-ragdoll`
(NOT master - C217 is not merged), own worktree (`Temp/FightCamp-Q164` holds C217; reuse it). Claude merges.
**Launch when a shell slot frees (Qwen Q206 and Cursor U191 hold both now).**

## Why
C217 (`research/C217_DIGEST.md`) delivered an OFF-by-default Kickback prototype on an isolated Jolt project:
200/200 controlled reactions on f01, f02 and MPFB, engine hash identical ON/OFF. It is NOT integration-ready: in the
moving seed-77321 bout, forced critical reactions exceed the 0.75 m tracking bound (1.15 m, five bodies on the first
reaction), and MPFB's knee does not reach the floor. The prototype cannot ship until a reacting man keeps up with a man
who is MOVING.

## What would a human do?
A game animator on a physics-driven character (Euphoria, NaturalMotion, Unreal's Physical Animation component) never
lets the ragdoll chase a pose it snapshotted at the hit: the motors track the LIVE animated pose every physics tick, the
root is driven by the animation (only the limbs go soft), and a stagger that would leave the support polygon triggers a
catch step instead of a fall. Blend weight on the hit chain rises and decays; the rest of the body stays kinematic.

## Prefab check
Kickback (MIT, pinned `1d2c5ae3`) is already vendored - read its `physics_rig_sync.gd` and spring resolver before
writing anything. Also look at Unreal 5.8's PhysicalAnimationComponent defaults (source on this PC, see
`reference_unreal_source_on_pc`) and Godot's `PhysicalBoneSimulator3D` partial simulation. Name what you reuse.

## Do
1. Make the motor targets follow the live animated pose every physics tick (not the pose at hit time), with only the
   struck chain softened; keep the root under the animation.
2. Re-run C217's live-motion probe (`tools/c217_engine_trial.gd inject=1` on seed 77321, moving bout): max target error
   under 0.75 m on every accepted reaction, over at least 45 reactions; report p50/p95/max per rig.
3. MPFB knee: reach within 0.03 m of the original ankle-height reference, or explain why the rig cannot.
4. Keep every C217 guarantee: OFF creates nothing, `Godot/project.godot` byte-unchanged, engine log SHA identical ON/OFF,
   OFF pixel hashes identical. Render a before/after MP4 of a MOVING reaction (not idle), via `Tools\godot_hidden.ps1`.

## Gate
Parse gate on owned files; `python Godot/tools/run_tests.py --jobs 2 --only fight_world_live,fight_room` no worse than
C217's (fight_room_walkout fails on master too). Never the full suite. PC check first:
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## Owned files
`Godot/scripts/FightActiveRagdoll.gd` (290 lines, read whole), `Godot/tools/c217_*.gd`, `Godot/tools/c218_*.gd`,
`previews/c218/`, `research/C218_DIGEST.md`. `Godot/addons/kickback/` stays byte-identical to the pin.

## Deliver
Commit and push as you go; digest; `python Tools/agent_comms.py send --from codex --to claude --topic C218 --body "..."`.
Do NOT edit HANDOFF.md. **Trap:** a guard that latches refusal makes a failing run look quiet - count ACCEPTED reactions
and print that count beside the error, or a 0-reaction run reads as a pass.
