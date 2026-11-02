# TASK Q47 — QWEN — THE INVENTORY OF EVERY CLIP WE ACTUALLY OWN

**Agent:** qwen
**Model:** default, medium effort, `--yolo`
**Test tier:** **NEW HARNESS IN `Godot/tools/` ONLY — no script under
`Godot/scripts/` is edited, no test file is created.** Parse gate on your own
new `.gd`, then run your own harness. **NO suite run. NO `run_tests.py`.**

---

## Why this exists

We now own **161 FBX animation files** and we have never counted what is in
them. R106 and R107 each read a *sample* and a store page. Every decision from
here — which clip gets retargeted next, which of R103's 95 degraded beats can be
filled, whether a clip is even usable — is being made against filenames.

**A LABEL IS NOT THE CONTENT.** That lesson has now cut in both directions on
this exact vendor: R105 found a store page that oversold, R106 found one that
UNDERSOLD by half. Read the files.

Your job is the machine-readable manifest. Not judgement — **measurement**.

---

## Owned files

| file | you may |
|---|---|
| `Godot/tools/inventory_owned_clips.gd` | **CREATE.** Yours alone. |
| `research/Q47_THE_OWNED_INVENTORY.md` | **CREATE.** Yours alone. |

Nothing else. Do **not** edit `HANDOFF.md`. Do **not** touch anything under
`Godot/scripts/`, `Godot/tests/`, or any other tool.

---

## The two folders

```
Godot/assets/anim/audition/ramsterz/       37 FBX  (Full Mount Attacks, paired)
Godot/assets/anim/audition/ramsterz_h2h/  124 FBX  (Hand to Hand Set, solo)
```

Both are **gitignored** — the FBX files never get committed. Your `.gd` and your
`.md` do.

---

## READ THIS BEFORE YOU WRITE A LINE — the trap that nearly produced a false R106

**These clips are MESH-FREE.** Godot imports them as a plain `Node3D` tree, **not
a `Skeleton3D`.** `get_bone_count()` returns **0** and that number **MEANS
NOTHING**. You must walk the node tree for bone names.

`Godot/tools/audit_ramsterz_paired.gd` already solves every mechanical problem
you have: loading an FBX at runtime (`_load_fbx` via `FBXDocument`), walking the
node tree for names (`_skel_names` / `_walk_names`), finding the
`AnimationPlayer` (`_find`), pulling the first Animation (`_anim_of`), and
sampling a position track (`_root_motion`). **Read that file and reuse its
shapes.** It is 260 lines. Read it whole — it is the one file you should read in
full.

It also carries the confirmed **22-row `UE4_TO_OURS` map**. Copy that constant
into your harness; do not re-derive it.

---

## What to measure, per FBX

One row per file. Every column is a number or a plain string — no prose.

| column | meaning |
|---|---|
| `file` | filename, no path |
| `pack` | `full_mount` or `h2h` |
| `clip` | the Animation's own name inside the file (may differ from the filename — **report both**) |
| `length_s` | `Animation.length`, 2 decimals |
| `tracks` | `get_track_count()` |
| `nodes` | node names found by walking the tree |
| `map_covers` | how many of the 22 map rows are present as nodes, `N/22` |
| `has_root_pos` | `1` / `0` — is there a POSITION_3D track on `root/pelvis`? |
| `root_span_m` | the `(hi-lo).length()` of that track over 9 samples, 3 decimals; `0.000` if absent |
| `pos_tracks` | count of `TYPE_POSITION_3D` tracks |
| `rot_tracks` | count of `TYPE_ROTATION_3D` tracks |
| `scl_tracks` | count of `TYPE_SCALE_3D` tracks |

**If a file fails to load or has no AnimationPlayer, emit the row anyway with
the failure named in a `note` column.** A silently skipped file is how an
inventory lies. Count and report the failures explicitly.

---

## The four questions the document must answer with numbers

1. **How many of the 161 loaded at all?** Name every file that did not, and why.
2. **Is `map_covers` 22/22 for EVERY file in BOTH packs, or does it vary?**
   R107 asserted one BoneMap serves every RamsterZ pack from a sample. **Prove
   it across all 161, or find the exception.** If any file differs, that file is
   the headline of your report.
3. **Which clips carry root motion and which are in-place?** Give the count each
   way per pack, and list every clip with `root_span_m > 0.1`. An in-place clip
   and a travelling clip are used completely differently.
4. **Duration distribution.** Min, median, max per pack, and the full sorted list
   of every clip under 1.5 s (those are the single-beat units — the thing a
   fight presenter can actually fire per action beat; `JabInPlace` at 0.83 s is
   the known example).

---

## Also emit a machine-readable file

Write the full table as **`research/Q47_INVENTORY.csv`** alongside the
`.md` (header row, comma-separated, no quoting needed if you keep notes free of
commas — replace any comma in a note with `;`). The `.md` carries the analysis
and the notable rows; the CSV carries all 161. Commit both.

---

## Gate

```bash
python Godot/tools/check_scripts.py Godot/tools/inventory_owned_clips.gd
```

then run your own harness and nothing else:

```bash
"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tools/inventory_owned_clips.gd
```

**Do NOT run `run_tests.py`. Do NOT run the suite.** No script under
`Godot/scripts/` is being edited, so nothing you do can move a test.

Last line of your harness must be:

```
Q47_INVENTORY files=<N> loaded=<L> failed=<F> map22=<M> rootmotion=<R>
```

---

## Then

1. `git status -s` first — another agent may have staged work.
2. `git add -- Godot/tools/inventory_owned_clips.gd research/Q47_THE_OWNED_INVENTORY.md research/Q47_INVENTORY.csv`
3. Commit (ends `Co-Authored-By: Qwen <noreply@qwen.ai>`), push `master`.
4. `python Tools/agent_comms.py send --from qwen --to claude --subject Q47-done
   --body "<hash> files=N loaded=L failed=F map22=M rootmotion=R under1.5s=K ..."`
5. Do **not** edit `HANDOFF.md`.

---

## THE ONE TRAP

**`get_bone_count()` is 0 and it is not a finding.** If your harness reports
`bones=0` for all 161 files, you have read a `Skeleton3D` that does not exist
instead of walking the `Node3D` tree. Walk the tree. This nearly produced a
false R106 and it is the single most likely way this task goes wrong.
