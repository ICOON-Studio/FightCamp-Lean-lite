# TASK U81 - CURSOR - THE TRIPTYCH: SOURCE, RETARGETED SKELETON, RETARGETED MESH

Model: Composer (`composer-2.5`), **medium effort**. Owner: cursor. Launched `-p --force --trust`.
Stage: S4a, "why the bought clips look bad" (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`).

**Test tier: A NEW TOOL. No shipped script is edited.** Parse gate on your tool, run it,
then the gate script. No test suite, no `run_tests.py`.

## Owned files

- `Godot/tools/capture_retarget_triptych.gd` - **NEW, yours.**
- `previews/s4a/<clip_stem>__<fighter>.png` - **NEW, yours** (18 sheets, names below).
- `research/U81_TRIPTYCH.md` - **NEW, yours.**

Do NOT edit any other file: no script, no test, no data, no `.import`, not `HANDOFF.md`, not
`AgentComms/roadmap.json`. Godot will write `.import` sidecars for your PNGs - do not commit
those. Stage explicit paths only.

## Why this exists

The operator watched the retargeted RamsterZ clips and said they look "pretty bad". There are
four possible causes with four different fixes (the brief's table), and they split cleanly
into two families that a picture separates at a glance:

- If the RETARGETED SKELETON already differs from the SOURCE skeleton, the retarget is wrong
  (an axis correction, the proportions, the root).
- If the retargeted skeleton matches the source but the MESH looks wrong, the skin is wrong
  (Tripo's auto-rig weights), and no clip purchase will ever fix it.

Nobody has put those three side by side. This task does, so the S4a session can LOOK.

## Where things are

- `Godot/tools/probe_clip_render.gd` - read it whole: a WINDOWED render of a vendor clip that
  saves PNG frames. Godot cannot render headless - a headless run of this is a black image.
- `Godot/tools/measure_r108_retarget.gd` - 576 lines. Read `sed -n '1,80p'` (the UE4 -> our bone
  map, `SEGMENTS`) and `sed -n '230,300p'` (how it composes global poses by hand).
- `Godot/scripts/FightClipRetarget.gd` - 432 lines. `sed -n '46,120p'` (map, `build_corrections`),
  `sed -n '140,245p'` (`retarget_clip`, `_source_frames` - global source bases keyed by OUR bone
  names, which is exactly what panel 1 draws), `sed -n '375,432p'`.
- `Godot/scripts/FightClipBinding.gd` - 818 lines, **do not open whole.** Each clip's content
  window is its binding's `start_s`/`end_s` (example: `sed -n '82,99p'`); read them from
  `FightClipBinding.BINDINGS` at run time.
- `Godot/scripts/FightWorldStage.gd:31` - `mount(world, glb_path, spawn_name, deck_y, kg, sex)`;
  `Godot/scripts/FightAnimLabScreen.gd` (253 lines, the Lab the operator used) shows a mount and a
  clip playing.

## The contract

One PNG sheet per (clip, fighter): **3 columns x 6 rows**, each cell at least 320 x 320 px.
Rows are six evenly spaced times across the binding's content window (first and last included).
Columns, left to right, each labelled in the image:

1. `SOURCE` - the RamsterZ clip's own skeleton at that time, drawn as sticks: the 22 mapped
   joints as small spheres, a stick per parent->child bone.
2. `RETARGET SKELETON` - the fighter's `Skeleton3D` posed by the retargeted clip at that time,
   drawn the same way, same colours. **Compose the joint positions down the parent chain from
   `get_bone_pose()` yourself** - do not trust `get_bone_global_pose()` (in a headless run it
   returns the REST pose; compose by hand in every mode so the two panels are computed alike).
3. `RETARGET MESH` - the fighter's skinned mesh playing the same retargeted clip at that time.

Same camera for all three columns: orthographic, front three-quarter (45 deg off the face
direction), chest height, each body scaled to the same on-screen height so the source and the
fighter compare by shape, not size. Each cell prints its time in seconds.

The 18 sheets, exactly these names:

- clips (stems): `H2H_JabInPlace`, `H2H_HitReaction01`, `H2H_StaggerMedium01`, `H2H_Idle`,
  `H2H_SlipLeft`, `H2H_KnockDown01`
- fighters: `f01_m_box_welter` (the Lab's body), `f02_m_box_heavy` (forearm/upper-arm 1.22 - the
  longest, C98), `f06_m_mma_lhw` (a 1.00 m mesh, C98)
- file: `previews/s4a/<clip stem>__<fighter>.png`, e.g.
  `H2H_JabInPlace__f01_m_box_welter.png`

`U81_TRIPTYCH.md` records: the exact command, the population, the camera, how each panel is
computed, and any sheet or panel that failed and why. Do not describe what the pictures show -
Claude looks at them.

## Gate - in this order

1. Parse gate: `python Godot/tools/check_scripts.py Godot/tools/capture_retarget_triptych.gd`
2. Run WINDOWED (not headless):
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/capture_retarget_triptych.gd`
   through a `.cmd` wrapper that redirects to a log file - the console exe piped into
   PowerShell deadlocks and prints nothing.
3. `python research/U81_check.py` - **must exit 0 before you commit.** It checks all 18
   sheets exist, have the grid size, and that no cell is blank.

## The trap specific to this task

**A blank or rest-pose panel looks like a result.** Two R108 runs reported identical numbers
because both were reading the rest pose, and a headless render is a black image that still
saves. So before the full run, render ONE sheet for `H2H_JabInPlace` on f01 and open the PNG:
the jab's arm must be visibly extended in at least one row of all three columns. If panel 2 or
3 never moves, the tool is reading the rest pose - fix that before rendering the rest.

## When you are done

`git add -- Godot/tools/capture_retarget_triptych.gd research/U81_TRIPTYCH.md` plus the 18
PNGs by path, commit with those paths on the commit line, `git show --stat HEAD` (exactly those
20 files), push your branch, then
`python Tools/agent_comms.py send --from cursor --to claude --topic U81 --body '<one line>'` and
commit that one mail file by path. Do NOT edit `HANDOFF.md`. Never `git stash`, `reset --hard`,
`checkout .` or `clean`.
