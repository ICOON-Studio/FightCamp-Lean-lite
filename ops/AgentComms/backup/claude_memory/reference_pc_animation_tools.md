---
name: reference_pc_animation_tools
description: "Animation tools installed on the operator's PC (Blender 5.2.1 + Retarget add-on, Cascadeur Pro trial, Unreal 5.8, Rokoko Studio) and how Claude drives each one headless - including Cascadeur's in-app script server on 127.0.0.1:8765, found 2026-09-21"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 839eab8a-0776-4509-9c61-f7630dfbe338
  modified: 2026-09-14T00:00:57.842Z
---

Installed or found on 2026-09-14, for the S4a retarget bake-off. The scripts are in the repo at
`Tools/blender_bakeoff/`, and the result is `research/BAKEOFF_BLENDER_RETARGET.md`.

**Blender 5.2.1 LTS - TWO copies (confirmed on disk 2026-09-14).**
- Claude's portable build: `D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe`, with its config in its own
  `portable/` folder. **The Retarget add-on is installed ONLY here**, so use this one for scripts.
- The operator's normal install: `C:/Program Files/Blender Foundation/Blender 5.2/`, user config under
  `%APPDATA%/Blender Foundation/Blender/`. No retarget add-on in it.
- Run either headless with `--background --python x.py -- args`.
- **Retarget extension v5.2.0** (KBS-DEV, GPL) is installed and enabled at
  `portable/extensions/user_default/retarget/`. It registers 158 operators; the retarget core is `armature.retarget_*`.
- **Trap 1:** a RamsterZ FBX imports as 68 EMPTIES, not an armature. Rebuild an armature from `T_pose.fbx`, aim the
  bones joint-to-child, and bake the clip through a constant per-bone offset.
- **Trap 2:** "Bind to Active Armature" constrains the SELECTED rig to the ACTIVE one, so the clip-carrying rig must
  be active.
- **Trap 3:** called from a script, the bind needs the class default `current_m` set, and the add-on's own bake makes
  no action while reporting FINISHED - bake with `nla.bake(visual_keying=True, clear_constraints=True)` instead.
- **Trap 4:** import our Tripo GLBs with `bone_heuristic="TEMPERANCE"`. The default leaves arm bones sideways and leg
  bones pointing UP.
- **Trap 5 (Blender 5 API):** `Bone.select` is gone; use `bpy.ops.pose.select_all`.
- Verdict: it loses to our retarget (joints 9-15 deg against our 0.15). Use Blender for rendering and inspection, not
  for retargeting.

**Cascadeur 2026.2.2** at `C:/Program Files/Cascadeur`; the operator started the Pro trial on 2026-09-14.
- **BILLING (operator's account screenshot, 2026-09-14):** Monthly Pro trial started 2026-09-13 and CHARGES 37.66 EUR a
  month on **2026-09-27** unless the operator unsubscribes - their decision, flag it before that date. Pro allows commercial
  use, FBX export and retargeting (K41); whether trial-made exports carry commercial rights is undocumented (re-export
  a keeper after the first paid month). Proposed before the charge: ONE ~25 cm boxing step clip keyed from two poses of
  H2H_Idle, measured through our retarget and probes. Not for runtime joins (they start from any pose).
- **THE GUI ROUTE IS OPEN - PROVEN 2026-09-21, AND TWO THINGS HID IT FOR A WEEK.** C135 recorded "no documented
  API for setting ML controller targets or a paired pose solve" and marked the GUI UN-ATTEMPTED. It was right.
  (a) Cascadeur is **SINGLE-INSTANCE**: a leftover headless process (the scripting runs leave them) silently
  swallows every `Start-Process` and you get `MainWindowHandle = 0` forever. (b) The tell is `EnumWindows`
  filtered to its PID returning **ZERO top-level windows** - not hidden, none. **KILL the squatter, then launch.**
  The GUI came up at once. Driving loop, all demonstrated through PowerShell P/Invoke: `ShowWindow`(3)/
  `SetForegroundWindow`, `Graphics.CopyFromScreen` over the window rect, `SetCursorPos` + `mouse_event` clicks,
  then Read the PNG. **`auto_posing (0)` is a live scene object of type `Tool` in the Outliner** - the subsystem
  the scripting API would not expose. REACHABILITY proven; CAPABILITY (can it author a PAIRED contact pose?) NOT.
  Full recipe: `research/S29_CASCADEUR_GUI_REACHED.md`.
- **THE REAL AUTOMATION CHANNEL, FOUND 2026-09-21 (S30), AND IT SUPERSEDES THE MOUSE ROUTE ABOVE:**
  **`Scripts > MCP > Start script server`** runs an HTTP server at **127.0.0.1:8765** inside the live GUI.
  `POST /run {"code": ...}` executes Python IN the running app with `scene`, `csc` and `app` in scope.
  Docs ship with the install: `resources/scripts/python/scripts/mcp/script_server/README.md`, an `AGENTS.md`
  written for agents, a `.mcp.json` declaring it as an MCP server, and `samples/api_document.py` (5,413 lines,
  the full class reference). **C135's "no documented API" was true of HEADLESS exec mode only.** Toolkit and
  traps: `Tools/cascadeur/` + its README. Digest: `research/S30_THE_PAIRED_POSE.md`.
- **A PAIRED CONTACT POSE IS PROVEN (S30):** two rigged Cascy characters in a collar-and-elbow clinch, closest
  joint pair 0.054 m, reproducing from a cold start to four decimals. **AutoPosing itself did NOT do it** -
  a 37.2 cm hand drag moved the shoulder 2.8 cm and the pelvis 0.00 cm on both sides of its toggle, and
  `ap.update(session)` silently discards a controller written in the same modify block. The rig's own IK plus
  exact controller positions did, which is better: the pose is a FILE, not a sequence of drags.
- **Three traps that each cost an hour:** (a) relocate a character by its **CONTROLLERS only** (the 47 `Point`
  and `Limb Direction` objects) - writing the joints or the mesh transform tears the skin into arms stretched
  across the room; (b) do NOT write a controller the rig solves (set `hand_MainPoint_*` and the elbow, its
  additional point and its limb direction follow); (c) `dsm.close_scene()` on a NON-current tab from the script
  server CRASHED the whole application.
- Two characters in one scene: `File > Import > Import Scene To Current...`; the second copy is namespaced
  `character1:` on all 289 of its objects.
- **BILLING DATE CORRECTED 2026-09-21: the Paddle portal says 2026-09-28, not the 27th.** The portal wins.
- Also works, but slower: `cascadeur.exe --run-python-code "exec(open(r'<file>').read())"` forwards code to the
  open instance (`--run-script` did nothing).
- The `csc` API has `csc.glb` import/export and an `FbxSceneLoader`. `app.get_data_source_manager().load_scene()`
  opens a `.casc`; `app.current_scene().save(path)` writes one; `active_viewport().domain_viewport()` sets the
  camera (`SphericalCameraStruct`) and the overlay mode (`ViewportMode.View` for a clean render).
- The Retargeting, FixFoot and AutoPhysics tools expose only `editor`/`name` to Python, and the action manager has
  only `call_action` with no list of names. **Unbound GUI actions can be reached by binding a hotkey in
  `Settings > Hotkeys Window` and pressing it** - the app log confirms which action fired.
- The Free plan is non-commercial and saves `.casc` only; Indie exports FBX; retargeting is Pro-only (K41). Its AI runs
  locally and, per Nekki, does not train on imports.

**Unreal Engine 5.8** at `C:/Program Files/Epic Games/UE_5.8` (already present). The IK Retargeter is scriptable in
Python. K41: an export of our own mesh and licensed clips ships in Godot as a royalty-free Non-Engine Product, provided
no Epic mannequin assets are inside.

**Rokoko Studio 2.6.2.2 (desktop)** was installed by the operator at `C:/Program Files (x86)/Rokoko Electronics ApS/Rokoko Studio/`. Its free Starter plan cannot import a custom character and
syncs to Rokoko's cloud. The Blender plugin v1.4.3 breaks on Blender 5 stable and needs an in-Blender login (K42).
- **Basic plan** ($12/month monthly, $10/month annual; the operator tried to subscribe on 2026-09-14 and the PAYMENT FAILED -
  NOT subscribed; check which plan is active before relying on it) is the cheapest with custom-character import, retargeting to it, foot-locking
  cleanup, FBX export and commercial use (rokoko.com/pricing).
- **Licence checked:** Studio EULA v2 has no AI-training clause; clause 5.1 covers technical and usage data only, and
  Rokoko claims no ownership of user content. Cloud sync is not training, so the Unity store clause is not triggered.
  Rokoko Vision and Create (the AI tools) have separate terms - keep store clips out of them.
- **Best use:** foot locking on the residual 0.12-0.17 m/s slide AFTER our hip-travel fix, and a second outside retarget
  in the bake-off.

Related: [[project-agent-host-capabilities]], [[project_retarget_quality_is_the_bottleneck]],
[[feedback_find_the_automation_channel]].

**2026-09-14 (later): Blender's job changes.** The operator asked "Why you don't use tools like blender ?" after the
runtime per-part fixes lost cohesion ([[feedback-one-clock-move-script]]). Plan: AUTHOR each scripted exchange in Blender
- both fighters in one scene, one timeline, glove on the head at the contact frame, reaction starting there, distance
set - bake whole-body at 60 fps and export the synced pair to Godot. Retargeting stays in Godot (the bake-off verdict).

**2026-09-14 (afternoon): the pair pipeline works, and its traps.** `Tools/blender_moves/` (bridge.py, author_pair.py,
specs/) authors a two-fighter exchange from Godot bridge exports; the operator judged the first one "Right is clearly
better". Traps: (1) the glTF importer leaves OBJECTS in QUATERNION rotation mode - `rotation_euler` is silently ignored;
set `rotation_mode = "XYZ"` first. (2) An IK constraint drives the bone's TAIL; TEMPERANCE puts the lower-leg tail ~6 cm
from the ankle joint - offset targets by (tail - joint). (3) Blender 5.2 actions are layered: no `action.fcurves`; use
`action.fcurve_ensure_for_datablock(obj, path, index=i)` and `keyframe_points.foreach_set`. (4) NLA strip influence only
applies with `use_animated_influence = True`. (5) Workbench renders headless fine; evaluate a deformed mesh with
`obj.evaluated_get(depsgraph).to_mesh()` (then `to_mesh_clear()`). Run: `blender --background --factory-startup --python
Tools/blender_moves/author_pair.py -- <spec.json>`.
