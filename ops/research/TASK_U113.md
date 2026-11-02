# TASK_U113 — CURSOR — CAN OUR PIPELINE EAT A CASCADEUR EXPORT? THE GO/NO-GO FOR S31

**Agent:** Cursor · **Model:** composer-2.5 · **Effort:** medium · **Fast:** off
**Launch:** `Tools\cursor_task.cmd <this file> <workspace>` — NEVER `cursor-agent` directly.
**Branch:** `cursor/u113-cascadeur-export` · **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not
explore to "get oriented".

**Test tier: a NEW analysis tool plus its own check script. NO full suite. NO Godot boot is
needed for the measurement itself.** If you touch a `.gd` at all — you should not need to —
parse-gate it with `python Godot/tools/check_scripts.py <file>` and say so.

---

## WHY THIS EXISTS, AND WHY IT IS URGENT RATHER THAN INTERESTING

S30 authored a two-fighter contact pose in Cascadeur and the operator has ruled we keep the tool
and author five held positions with it. S31 takes the first one — a clinch — from that pose into
the game. **Step 4 of that chain is "retarget onto our fighters and bind", and NOBODY HAS EVER
PUT A CASCADEUR EXPORT THROUGH OUR RETARGET.** If the skeleton does not map, S31 stalls on a
question that takes a day to answer mid-build. Answer it now, before the build reaches it.

**This is a GO/NO-GO, and a NO is a completely acceptable result** as long as it says precisely
what fails and what the cheapest repair is. Do not try to make it pass.

## THE FILES, ALREADY EXPORTED FOR YOU

Claude exported these from the live Cascadeur session on 2026-09-21 with
`csc.glb.process_export`. **They exist; do not re-export and do not launch Cascadeur.**

```
C:/Users/user/AppData/Local/Temp/FightCamp-cascadeur-export/S30_CLINCH_pair.glb   5,809,664 B
C:/Users/user/AppData/Local/Temp/FightCamp-cascadeur-export/S30_CLINCH_A.glb      2,904,324 B
C:/Users/user/AppData/Local/Temp/FightCamp-cascadeur-export/S30_CLINCH_B.glb      2,905,068 B
```

`_pair` is both fighters in one file. `_A` and `_B` are the same scene exported one fighter at a
time, which is the shape S31 actually needs: **a held position binds as TWO single-actor clips.**

The source rig is Cascadeur's own sample character `Cascy`: 66 joints named `pelvis`, `stomach`,
`chest`, `neck`, `head`, `clavicle_l/r`, `arm_l/r`, `arm_twist_l/r`, `forearm_l/r`, `hand_l/r`,
`thigh_l/r`, `calf_l/r`, `foot_l/r`, `toe_l/r`, four fingers x four bones per hand, plus `hair`
and `weapon_l/r`. In the `_B` file every name carries the prefix `character1:`.

## WHAT TO ANSWER, IN THIS ORDER

**1. What is actually in the box.** For each of the three files, report: node/bone count, the
bone hierarchy as a tree (roots and depth, not all 66 lines), whether a skinned mesh is present,
whether an animation track is present and how long it is, and the up-axis and unit scale. Say
plainly whether `_A` and `_B` really contain ONE body each or whether the exporter wrote both and
merely hid one.

**2. Does it map onto our fighters?** Our rigged fighters are the Tripo GLBs in
`Godot/assets/models/fighters/` (`f01_m_box_welter_rigged.glb` and friends). Produce a
**bone-by-bone correspondence table**: Cascy bone -> our bone, or NO MATCH. Count the matches and
name every gap in both directions. State whether the gap is a naming problem (cheap: a rename
map) or a topology problem (expensive: different joint counts or a different chain shape).

**3. What does our own retarget do with it?** `Godot/scripts/FightClipRetarget.gd` is the
retargeter. Read what it requires of a source clip, and say — from the code plus your table —
whether it would accept this skeleton, and if not, the single smallest change that would let it.
**Do not modify it.** If you can measure a per-joint error without booting Godot, do; if you
cannot, say so rather than inventing a number.

**4. Format.** Our paired clips are bound as `.fbx`
(`Godot/scripts/FightClipBinding.gd:882`, `PAIRED_BINDINGS`, the `att` and `vic` fields point at
`PAIRED_DIR + "..._Att.fbx"`). We exported GLB. Say whether the binding path is format-agnostic
or whether S31 must obtain FBX out of Cascadeur, and if the latter, name the route you found in
the code — not a guess.

## THE GATE

Write `research/U113_check.py`, and **it must exit 0 on a real run**. It re-derives, from
the three GLB files on disk, at least: the per-file bone count, the match count against our
fighter rig, and one degenerate-input tripwire of your own choosing that would FAIL if the files
were empty or identical. Print one `U113_CHECK ...` line per fact and `U113_CHECK PASS` at the
end. **A gate that learns its expected values from the thing it is checking is not a gate** —
pin at least one number as a literal.

## DELIVERABLES

- `research/U113_CASCADEUR_EXPORT.md` — the four answers, the correspondence table, and a
  one-line **GO** or **NO-GO** verdict at the top with the reason.
- `research/U113_check.py` — exits 0.
- Any small tool you wrote under `Tools/footage/` or `Tools/cascadeur/`.

Commit with explicit paths (`git add -- <files>`), push `cursor/u113-cascadeur-export`, then send
one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic u113-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`.

## THE TRAP SPECIFIC TO THIS TASK

**A GLB's node list is not its skeleton.** Cascadeur writes its rig controllers, its collision
boxes and its centre-of-mass object as scene nodes too — the source scene has 289 objects and only
66 of them are joints. If you count nodes and call it a bone count you will report a 289-bone rig
and every conclusion after that is wrong. Read the **skin's joint array**, not the node array, and
say in your digest which one you used.

Second, smaller: the `_B` file's bones all carry the `character1:` prefix. Strip it before
comparing names, and say that you did — otherwise you will report zero matches for fighter B and
conclude the export is broken when it is fine.
