# TASK_Q217 - Close-range boxing moves certified under G147 (Qwen, STANDING animation task)

Model: qwen3-coder, medium (pinned in Tools/qwen_task.cmd). Owner: qwen. Assigned S125 2026-09-29 (operator: "who can work on
animation constantly?" -> Qwen, go-ahead given). STANDING: when one move lands, take the next on the list; Claude re-cuts it each
session. Active milestone: PLAYABLE WITH A BOXER - the .exe is allowed only at 36/36 boxing under C223 (D3).

## Why
S125 put the G147 clipping row and a pin-pop row INSIDE both C223 gates (commit 9fcea29b). At the certified spacings, with the
game's glove pin (contact_stop), 6 single moves pass every row on 4 legal pairs (jab, cross, rear_uppercut, jab_body, body_hook,
cross_body) plus slip/pull/catch. Q213 clips mode (pin=1) still FAILS these close-range moves on REAL overlap - not glove
overshoot, the pin already removes that:

| move | Q213 pin=1 worst | class |
| --- | --- | --- |
| boxing_lead_uppercut | 17.7 cm | ARM (UpperChest-Neck > LeftHand) |
| boxing_inside_uppercut | 18.75 cm | LEG (thigh through thigh) |
| boxing_rear_hook | 11.9 cm | HEAD>HEAD 2.6 cm + arm |
| boxing_rear_hook_body | 12.0 cm | |
| boxing_shovel_hook | 13.5 cm | |
| boxing_lead_hook | 6.3 cm | |

They were certified at 0.70-0.73 m root gap - inside the other man's body. Your job: a spacing AND placement where each lands its
target line with no G147 failure and no pin pop, on all four rigs, then a rebind. One move at a time, in the order above.

## What would a human do?
A boxing coach: hooks and uppercuts are thrown from the INSIDE, but the heads are not stacked - the puncher's head goes to the
side (outside the opponent's lead shoulder), the lead feet are staggered past each other, so legs never share space. An animator
building a paired close-range exchange places the two bodies first (relative offset + facing), then keys the arm to the target;
they never let the clip decide the distance. So: solve the ROOT placement (gap AND a lateral offset / yaw) where bodies clear,
then make the fist reach from there - a layer solved by target (S124 `s124_catch_solve.gd` style), never a longer arm.

## Prior research (primary studies - read the relevant sections)
- `research/S124_DIGEST.md` (the clipping re-judge, the catch solved by target) and `research/G147_CLIPPING_RULE_AND_SMOOTHING.md`
  (the limits: head >1 cm >1 f, torso >2 cm >3 f, arm 3 cm/3 f, leg 2 cm/3 f, foot 4 cm/5 f).
- `research/C223_DIGEST.md` S119-S121 sections: how hooks/uppercuts were strike-warped into band (RUN9_WARPS, VARIANTS).
- `research/Q214_DIGEST.md` (your own G147 remedies in the live room) and `research/Q213_DIGEST.md`.
- `research/topics/striking.md` for the hook/uppercut ranges.

## Prefab check
None: this re-places and re-certifies our own clips with our own gate; the source clips (RamsterZ/Mixamo) are already bought or free.

## Build (per move, in order)
1. Measure: `tools/q213_clip_gate.gd` `mode=clips pin=1` (windowed) and the production gate row for the move:
   `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/c223_production_gate.gd -- bound live_contact clips=<candidate id> report=q217_<move>.json`
   Read `mechanical_failures`, `g147`, `g147_pin_pops`, `opponent_root_gap_m` per rig.
2. Find the placement where the bodies clear (G147 row passes) - gap first; if the fist can no longer reach, a lateral offset/yaw
   for the RECEIVER placement, then a pose layer solved by target (FightClipPoseLayer, 107 lines - read whole) to bring the fist
   to the target line. Print achieved beside wanted for every candidate.
3. Certify: every C223 row on all 4 rigs, INCLUDING g147_clipping and g147_pin_pop, report file `s1NN`-style name
   `q217_<move>_bound.json` only when all 4 rows are empty of failures (Q213's certificate lookup reads `*bound*.json`).
4. Rebind in `FightClipBinding.gd` for that move only, then re-run Q213 `mode=clips pin=1` - the move must read PASS there too.
5. Stills: `render stills_only` from the GAME camera and `yaw=90` side, for Claude's eye.

## Tools you have
- Higgsfield MCP servers in your own settings (S125, operator: "make sure qwen have access to higgsfield blender mcp"):
  `higgsfield` (https://mcp.higgsfield.ai/mcp - generation) and `higgsfield_blender` (https://bridge.higgsfield.ai/mcp - drives the
  signed-in Blender through the Higgsfield plugin: bl_get_skill first, then bl_* tools). If `/mcp` shows them Disconnected, say so
  in your send and carry on without them - the sign-in is the operator's.
- Blender 5.2.1 portable `D:/Tools/Blender/blender-5.2.1-windows-x64` (headless `--background --python`, run from Bash).
- CREDITS: Higgsfield has ~137 credits to 10-14. ZERO spend without Claude's written OK in your prompt; `bl_*` scene/pose/render
  tools are free, `generate_*` / `bl_generate_*` / `bl_image_to_3d` spend. This task needs none - it re-places clips we own.

## Gate (tier: script edited)
Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <files>`. Focused tests only:
`python Godot/tools/run_tests.py --only clip_phases_data` and `--only boxing_idle_binding`. Never the full suite (nightly).
Every WINDOWED Godot run through `Tools\godot_hidden.ps1`. Before any Godot run: `powershell -NoProfile -ExecutionPolicy Bypass
-File Tools\pc_watchdog.ps1 -Once` - exit 1 (RED) means wait.

## Owned files
- `Godot/tools/c223_production_gate.gd` - ONLY new rows in `TAKES` (:41) / `VARIANTS` (:23) / `RUN9_WARPS` (:11) for these moves;
  never the gate logic, the limits or the G147/pin-pop rows (759 lines; read `sed -n` windows).
- `Godot/scripts/FightClipBinding.gd` - ONLY the binding entries of the six moves above (3,110 lines; anchors :36 lead_hook,
  :43 rear_hook, :50 lead_uppercut, :62 inside_uppercut, :1040 rear_hook_body, :1059 shovel_hook). Never open it whole.
- New: `Godot/tools/c223_layers/q217_*.json`, `Godot/assets/anim/c223/q217/*`, `previews/c223/q217_*`,
  `research/Q217_DIGEST.md`.

## Deliver
Commit per certified move on branch `qwen/q217-close-range` (never master), push, add the move's rows to `Q217_DIGEST.md`
(before/after table per rig: gap, offset, worst G147 cm, pin pops, target line), then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q217 "<move> certified 4/4 | or: blocked on <row>"`.
Do NOT edit HANDOFF.md. Merge bar (Claude): `python Tools/check_workflow.py branch qwen/q217-close-range Q217`.

## Trap
A gate row that passes by moving the men APART is a miss that looks clean: the target_line and onset rows must still pass, and
the gap must be one a hook is thrown from. Never widen a G147 limit, never drop a rig, never touch the pin or the gate code.
