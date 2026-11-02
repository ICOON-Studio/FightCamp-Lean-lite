# TASK Q213C (+ Q213D) - honest clipping coverage and the three palette combinations

Model: Codex gpt-6-astra, medium effort. Written S151 from the two launch prompts
(`AgentComms/prompts/Q213C.txt`, `AgentComms/prompts/Q213D.txt`), which are the authoritative
brief; this file exists so `check_workflow.py branch` can check ownership (the launch skipped it).

## Spec
Q213C: the gate admits the existing certificates its filename filter excluded (inside uppercut,
liver combo, one-two-hook, six-punch combo) without changing any of the 22 measured moves'
selections; an unmeasured move FAILS; summary prints `measured=N/26`; per-move table on 26 moves.
Q213D (approved by Claude S148): sequence playback applies opt-in per-binding corrections
(pose_layer / knee_swivel) only where a sequence binding opts in; non-opted sequences and the 23
passing moves byte-identical before/after; fix the three failing combinations.

## Owned files
- `Godot/tools/q213_clip_gate.gd` (selection + reporting only, not thresholds)
- `Godot/scripts/FightClipBinding.gd` (only boxing_liver_combo, boxing_one_two_hook, boxing_six_punch_combo)
- `Godot/scripts/FightStagePlayer.gd` (sequence path only)
- `Godot/scripts/FightClipFootPlant.gd` (only if a fix needs it)
- new `Godot/tools/q213c_*.gd`, `Godot/tools/q213d_*.gd`
- `research/Q213C_DIGEST.md`

## Test
`Godot/tools/q213_clip_gate.gd -- mode=clips pin=1 pair=N` for N=0..3 (tier: script edited -> parse,
the pinned gate, `run_tests.py --only q213_clip_gate_contract,fight_stage_playback`).

## The one trap
A correction on a SHARED component (jab, cross) changes every move that uses it - corrections must
live in private per-combination takes.

## Prior research
Q213_DIGEST.md, Q213B_DIGEST.md, C223_DIGEST.md, S136 certificates.

## What would a human do?
An animator fixes the combination's own key poses, never the shared single-move clip.

## Prefab check
None needed - in-engine pose layers on owned clips.
