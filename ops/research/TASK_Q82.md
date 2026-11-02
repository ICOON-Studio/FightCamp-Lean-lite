# TASK Q82 - QWEN - GODOT'S OWN RETARGETER, AND WHETHER WE REBUILT IT

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`, prompt on stdin.
Stage: S4a, "why the bought clips look bad" (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`).

**Test tier: RESEARCH. No `.gd` is edited.** No parse gate, no test. The gate is
`python research/Q82_check.py`, and it must exit 0 before you commit.

## Owned files

- `research/Q82_GODOT_RETARGET_VS_OURS.md` - **NEW, yours.**
- `research/Q82_retarget_options.json` - **NEW, yours.**

Do NOT edit any other file. **Never touch a `.import` file** - the clips are Git LFS binaries
and their import settings are shared by every scene that uses them. Do not commit Godot's source
code into the repo; fetch it to a temporary folder outside the repo.

## Why this exists

The operator watched our retargeted RamsterZ clips and said they look "pretty bad". We retarget
with our own code: `FightClipRetarget.gd` (432 lines) builds a per-bone rest correction through
`BoneRestFixer.gd` (89 lines) and bakes every frame onto our fighter's skeleton, rotations only.

**Godot 4 ships its own humanoid retargeter at import time**: a `BoneMap` onto
`SkeletonProfileHumanoid`, plus `retarget/*` import options - a rest fixer, an axis overwrite, a
silhouette fixer, position-track normalisation, track removal. If ours re-implements part of
that and leaves out the part that matters, that is the cheapest possible fix. Nobody on this
project has compared the two.

## What to do

1. **Fetch Godot's source for the engine version we run, 4.7.2** (tag `4.7.2-stable`; if that tag
   does not exist, the nearest 4.7 tag - say which). Find the files with the GitHub API
   (`https://api.github.com/repos/godotengine/godot/git/trees/<tag>?recursive=1`) and fetch them
   raw from `https://raw.githubusercontent.com/godotengine/godot/<tag>/<path>`. At least: every
   `post_import_plugin_skeleton_*.cpp` under `editor/import/`, and `skeleton_profile.cpp` and
   `bone_map.cpp` under `scene/resources/`. Use `curl -sL` into a temporary folder.
2. **List every `retarget/...` import option** those files register: exact key, type, default,
   and what the C++ does with it - each with a `source_ref` of `<file name>.cpp:<line>` where the
   key's string appears.
3. **Read ours whole**: `Godot/scripts/FightClipRetarget.gd` and `Godot/scripts/BoneRestFixer.gd`.
   For each step ours takes - the bone-name map, building the rest correction, applying it per
   frame, composing globals, what happens to position tracks and the root - give the engine's
   equivalent option, or `NONE`. Cite ours as `Godot/scripts/<file>.gd:<line>` plus a token that
   appears on that line.
4. **What the engine does that ours does not.** For each, say which of the brief's four causes it
   bears on (1 axis correction, 2 proportions, 3 root/position, 4 skinning).
5. **The A/B recipe.** The exact import settings (the `.import` keys and values) and the
   `BoneMap` needed to import `H2H_JabInPlace.FBX` through the engine's retargeter onto
   `SkeletonProfileHumanoid`, so the S4a session can play both versions on f01 side by side.
   Written into the markdown and the JSON only - do not apply it.
6. **Verdict**, one paragraph: is ours a re-implementation, and which missing engine piece most
   plausibly explains "looks bad". Label it.

Label every claim **SOURCED** (a file:line you fetched or read) or **INFERENCE** (your
reasoning, and from what). "NOT FOUND" is a good answer when the source genuinely does not say.

## JSON, exactly this shape

```json
{
  "godot_ref": "4.7.2-stable",
  "sources": [{"file": "editor/import/3d/post_import_plugin_skeleton_rest_fixer.cpp",
               "url": "https://raw.githubusercontent.com/godotengine/godot/4.7.2-stable/editor/import/3d/post_import_plugin_skeleton_rest_fixer.cpp"}],
  "options": [{"key": "retarget/rest_fixer/fix_silhouette/enable", "type": "bool", "default": "false",
               "what": "...", "source_ref": "post_import_plugin_skeleton_rest_fixer.cpp:123"}],
  "ours": [{"step": "rest correction", "our_ref": "Godot/scripts/BoneRestFixer.gd:40", "our_token": "pose_frame",
            "engine_equivalent": "retarget/rest_fixer/overwrite_axis", "label": "SOURCED", "note": "..."}],
  "engine_only": [{"option": "retarget/rest_fixer/fix_silhouette/enable", "cause": 1, "label": "INFERENCE", "note": "..."}],
  "recipe": {"clip": "H2H_JabInPlace.FBX", "import_keys": {"retarget/bone_map": "..."}, "bone_map": "..."},
  "verdict": "..."
}
```

The paths and line numbers above are placeholders to show the shape - use the real ones.
The markdown has these sections, in this order: `DECISIONS`, `OPTIONS`, `OURS VS ENGINE`,
`RECIPE`, `VERDICT`.

## The trap specific to this task

**Answer the question asked, from the source, not from memory of an older Godot.** The retarget
options moved and changed between Godot 4.0 and 4.7; a key that existed in a 4.1 tutorial may not
exist in 4.7.2, and the gate fetches the files you cite and checks that every key you list is
really on the line you name. And do not stop at "ours is similar" - the useful finding is the
DIFFERENCE, with the line on each side that proves it.

## When you are done

Run `python research/Q82_check.py` until it exits 0. Then
`git add -- research/Q82_GODOT_RETARGET_VS_OURS.md research/Q82_retarget_options.json`,
commit with those paths on the commit line, `git show --stat HEAD` (exactly those two files),
push your branch, `python Tools/agent_comms.py send --from qwen --to claude --topic Q82 --body "<one line>"`,
and commit that one mail file by path. Do NOT edit `HANDOFF.md`. Never `git stash`,
`reset --hard`, `checkout .` or `clean`.
