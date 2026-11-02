# TASK C215 - CODEX - FOOTWORK THAT IS SEEN AGAIN (S99)
Owner: codex. Assigned 2026-09-27 (S99). Model: `gpt-6-astra` MEDIUM (3D animation; `CODEX_MODEL=gpt-6-astra`).
Branch `codex/c215-footwork-seen` from `origin/master`, own worktree. Claude merges. **Launch when a shell slot frees.**

## Why
U183 bound all nine boxing footwork ids to `idle` in `FightClipBinding.STRIKE_FAMILY_BINDINGS` to fix foot clearance.
Q200 (`Q200_DIGEST.md`) found the cost: `fight_world_live_test` can never reach its "carried"/"stanced" footwork path.
A movement beat never presents without a clip, so the man stands in idle while the engine moves him. Stepping, sliding
and pivoting are part of how a fight looks.

## What would a human do?
An animator gives locomotion its own layer: a short step/shuffle cycle driven by the root's actual travel (distance and
direction per beat), with the feet planted between steps, blended under the upper body. That is how fighting games drive
footwork: from root motion, not from a baked "footwork clip". U183's clearance fix stays; the step goes on top of it.

## Do
1. Read U183's digest and the `FightClipBinding.gd` bindings for `boxing_*` footwork. Read how `FightStagePlayer` carries
   the root (grep `presented_thrower_footwork` in `FightWorldLiveScreen.gd`).
2. Make a movement beat present as footwork (carried + stanced) without bringing back U183's clearance fault.
3. Render 5 s in the production room through `Tools\godot_hidden.ps1` and put an mp4 in `docs/previews/c215/`.

## Gate (a CEILING)
`fight_world_live_test` green; `boxing_footwork_clearance_test` still green;
`python Godot/tools/run_tests.py --jobs 2 --only fight_world_live,boxing_footwork,fight_stage,fight_clip` no worse than
master. Parse gate. Never the full suite. Every windowed Godot run goes through `Tools\godot_hidden.ps1`.

## Owned files
`Godot/scripts/FightClipBinding.gd` and `Godot/scripts/FightStagePlayer.gd` (both large: grep, then read `sed -n` windows),
`Godot/tools/c215_*.gd`, `previews/c215/`, `research/C215_DIGEST.md`.

## Deliver
Commit explicit paths, push the branch, write `C215_DIGEST.md`, then run
`python Tools/agent_comms.py send --from codex --to claude --topic C215 --body "<tests, preview path>"`.
Do NOT edit HANDOFF.md. All research is open: RESEARCH_INDEX.md.
**Trap:** a test that passes because a synthetic beat was injected proves the code path, not the look. This one must be
reached by a real seeded bout.
