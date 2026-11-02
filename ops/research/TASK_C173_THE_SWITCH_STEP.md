# TASK_C173 — THE SWITCH STEP: AUTHOR THE STANCE SWITCH IN CASCADEUR

**Owner: codex. Model: `gpt-6-astra`, medium** (3D animation, operator ruling 2026-09-21).
Assigned S59, 2026-09-23. Operator: *"the 3D fight has no switch-step animation - i want this fixed right now"*.

## Owned files

- `Tools/cascadeur/build_switch_step.py` (new) and any helper under `Tools/cascadeur/`.
- `Godot/assets/anim/audition/cascadeur/Cascy_Switch_*.glb` (new exports).
- `Godot/tools/switch_step_probe.gd` (new) - the gate below.
- `research/C173_DIGEST.md` (new), appended per clip.

## WHY CASCADEUR AND NOT GENERATION - measured, do not retry it

Higgsfield text-to-motion (`Tools/higgsfield/t2m_stance_switch.py`) was asked for a switch **16 times**,
with the stance named and then with the feet spelled out by body part. **0 of 16 switched**: every clip starts
AND ends left-foot-forward (lead L-R foot +44..+70 cm along the root heading, validated on the known orthodox
jab clip at +61.5 cm). The model cannot produce a right-foot-forward stance. Do not spend credits on it.

## THE THREE CLIPS

| clip | start | move | end | notes |
|---|---|---|---|---|
| `Cascy_Switch_O2S` | orthodox guard | small in-place hop or shuffle, feet swap, hands stay up | southpaw guard | ~0.35-0.5 s of motion, root travels < 15 cm |
| `Cascy_Switch_S2O` | southpaw guard | the same, reversed | orthodox guard | author it by MIRRORING O2S, do not re-pose it |
| `Cascy_StepThrough_O2S` | orthodox guard | rear (right) foot steps THROUGH past the lead foot and lands in front, hips turn | southpaw guard | the attacking switch; root travels forward 40-70 cm |

Each clip holds ~0.3 s on its start pose and ~0.3 s on its end pose so the engine can blend in and out.

**THE SOUTHPAW GUARD IS THE EXACT MIRROR OF THE ORTHODOX GUARD** (swap left/right bones, flip the lateral axis).
Build the end pose by mirroring the start pose, never by eye - that makes "is he really southpaw" true by
construction. Source the orthodox guard from an existing idle/guard clip in the tree rather than inventing one:
`Godot/assets/anim/` has `idle_A.fbx` and `muay_thai_guard_stance.*`; say which you used.

## GATE - `Godot/tools/switch_step_probe.gd`, written by you, a CEILING

For each exported clip, sampled over its first and last 0.25 s, on the retargeted rig in Godot:
- **lead-foot sign flips**: (LFoot - RFoot) along the body's facing is > +0.15 m at the start of an O2S clip and
  < -0.15 m at the end (the reverse for S2O). Facing comes from the hips/shoulders line, not a hard-coded axis.
- **end pose mirrors start pose**: per-bone mirrored angle difference <= 5 degrees on the legs and trunk.
- **root travel** within the table's range.
- **the hands stay up**: both hands above the sternum on every sampled frame.
Print every number beside its threshold. **Prove the probe with two mutants** (feed it an un-mirrored end pose
and a clip that never switches) and show both go red.

Parse gate first; then the probe; then `run_tests.py --only clip` (must stay 10/0 or better). NEVER the full suite.

## RENDER AND LOOK

Render each clip from the side and from the front (`Godot/tools/render_paired_hold.gd` patterns, or a one-body
variant you add) and say in one sentence per clip whether a boxing coach would call it a switch step.

## WHAT THIS TASK DOES NOT DO

It does not make the engine switch stance - there is no switch decision yet (operator ruling 2026-09-23: a switch
is a TACTIC prepared in the fight camp, not a rate; that is the next engine stage). Do not edit `FightRealtime.gd`,
`FightStance.gd` or the technique catalogue. Export, gate, render, commit - one clip, one commit, push master, one
`agent_comms.py send --from codex --to claude --subject C173` line per clip. Do not fetch or rebase. Do not edit
HANDOFF.md.

## LEFTOVER FROM C172 - DO IT AFTER THE THREE CLIPS

Closed guard (`1dce3989`) passes its contacts but the top man lies FLAT; the reference video
`research/_captures/ground_video/closed_guard_locked.mp4` shows him KNEELING with both knees on the canvas
under his hips. Re-pose toward the kneeling shape, keep the staggered ankle crossing, same C171/C172 gate, both
sheets side by side in `C172_DIGEST.md`. If kneeling cannot hold the ankle lock under 30%, keep `1dce3989` and say so.
