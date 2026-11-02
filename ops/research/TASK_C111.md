# TASK C111 — CODEX — HOW TO DRIVE BLENDER'S "RETARGET" ADD-ON WITHOUT ITS WINDOW

Model: `gpt-5.6-luna`, medium (the only setting). Owner: codex. Main checkout, launched by Claude through
`Tools/codex_task.cmd`. Stage: S4a (retarget quality) - forecast research for Claude's retarget bake-off.

**Test tier: RESEARCH. No Godot, no Blender run, no commit** (your sandbox cannot write `.git`; Claude commits).
`python research/C111_check.py` must exit 0 when you finish.

## Owned files

- `research/C111_retarget_addon_api.json` - NEW, yours.
- `research/C111_RETARGET_ADDON_API.md` - NEW, yours, 40 lines at most.

## Why this exists

Our fight clips (RamsterZ FBX, Unity-store licensed) look bad after our own GDScript retarget onto our Tripo
fighters. The operator installed **Blender 5.2.1 LTS** (portable) and the free official extension **Retarget v5.2.0**
(KBS-DEV, GPL-3.0-or-later) for a head-to-head test. Claude will run Blender headless
(`blender.exe --background --python script.py`), so we need to know how to call the add-on from a script. That means
which operators and functions exist, what context each needs, and the smallest sequence that maps a source armature
to a target armature and bakes the result.

## What to read - ONLY these (read-only, outside the repo)

- The add-on source: `D:/Tools/Blender/blender-5.2.1-windows-x64/portable/extensions/user_default/retarget/` - start
  at `__init__.py`, then follow only the modules it registers. Find every operator with
  `grep -rn "bl_idname" <that folder>` (158 operators - most are keyframe helpers), and read each RETARGET-CORE operator class whole.
- Its manifest `blender_manifest.toml` in the same folder.

## What to write

`C111_retarget_addon_api.json`:
- `"operators"`: one row for each retarget-core operator (the check derives the list: every `armature.*` operator plus the mapping, preset, offset, rest-pose and IK ones - 22 in v5.2.0); rows for other operators are optional:
  - `idname`, `file` (path relative to the add-on folder), `line`, and `quote` (a short exact piece of that line);
  - `poll` (one sentence: what `poll()` requires, or `"none"`);
  - `context_needs`: a list naming what `execute`/`invoke` reads from `context`, such as `active_object`, `scene`,
    `area.type` or `selected_objects`;
  - `what` (one sentence).
- `"properties"`: the scene or object properties the add-on stores its settings in (for example a source/target
  armature pointer, a bone-mapping collection or a preset name): `path`, `file`, `line`, `quote`, `what`.
- `"presets"`: the bone-map presets it ships (name and file), and whether any matches a Unreal/Mixamo-style source or
  a Rigify-style target.
- `"headless_sequence"`: the ordered list of calls a background script would make to retarget one action from source
  armature S to target armature T and bake it onto T. Each step gives `call` and `why`, and names any step that
  needs a `bpy.context.temp_override(...)` because its operator reads a UI area.

The digest opens with `## DECISIONS`:
- can the add-on retarget and bake with no window (YES / NO / YES WITH OVERRIDES);
- the 3 to 6 calls of the headless sequence;
- the biggest risk (an operator that needs a real 3D viewport, a modal operator, or a preset that does not fit our
  bone names).

Our source bones are RamsterZ's Unreal-style names (`pelvis`, `spine_01`, `upperarm_l`, and so on). Our targets are
Godot humanoid names (`Hips`, `Spine`, `Chest`, `LeftUpperArm`, and so on).

## When done

`python research/C111_check.py` exits 0. Then
`python Tools/agent_comms.py send --from codex --to claude --topic "C111 ready" --body "check exit 0"`. Do not edit
`HANDOFF.md`.
