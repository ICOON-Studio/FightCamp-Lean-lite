# TASK_Q133 - QWEN - WIRE EVERY CLIP WE ALREADY OWN TO A TECHNIQUE ID

**Owner:** qwen
**Model:** `qwen3-coder`, MEDIUM. `--yolo` (NEVER `auto`), stdin, from your own
worktree.
**Test tier:** parse gate, then `python Godot/tools/run_tests.py --only clip`,
then SEPARATELY `--only playback`. `--only` DOES NOT STACK - one substring per
invocation, read `total=` to confirm how many ran. Do NOT run the full suite.

## Why this, and it is the operator's own instruction

**Operator, 2026-09-22, verbatim: "wire everything that we own already".**

The skill trees hold **696 technique nodes** across 15 disciplines. 162 are
`kind: skill` and passive - they need no clip at all. **534 are `move` or
`sequence` and need motion.** Exactly **15** of them resolve to a clip by their
own id today.

Meanwhile there are **105 RamsterZ `.FBX` clips** in
`Godot/assets/anim/audition/ramsterz_h2h/` and about **20 Motifect `.glb`**
martial-arts clips in
`Godot/assets/anim/audition/motifect/unpacked/Motifect_martial_arts_v1_0/GLB/`.
`FightClipBinding.gd` has 51 keys and 40 with a real path - **and most are
addressed by ROLE** (`jab`, `block`, `idle`, `react_head`, `loc_advance`)
rather than by technique id.

**So we own clips that no technique can find.** That is free coverage sitting on
disk, and closing it is a measurement plus a mechanical pass, which is your
strongest shape of work - Q131 and Q132 both landed clean.

## The question, and it comes before the wiring

**How many of the 534 motion techniques can be served by a clip we ALREADY
OWN?** Answer it with a table before you change anything:

1. Read every catalogue node from `Godot/assets/data/technique_catalog.json`
   (`disciplines[].nodes[]`, fields `id`, `name`, `kind`, `branch`).
2. Read every clip on disk in the two directories above, plus every existing
   key and path in `Godot/scripts/FightClipBinding.gd`.
3. For each of the 534, decide: **EXACT** (a clip plainly is this technique),
   **NEAR** (a clip is the same motion under another name - `H2H_HookPunch`
   for `boxing_lead_hook`), or **NONE**.
4. Print the counts and the per-discipline breakdown.

**NAME YOUR RULE.** Whatever decides EXACT vs NEAR vs NONE must be written down
in the digest and applied the same way to every node. "I looked at them" is not
a rule and cannot be checked or re-run.

## Then wire it

Add the EXACT and NEAR bindings to `FightClipBinding.gd`, keyed by the
technique id, following the shape the existing entries already use (`path`,
`reach_m`, optional `start_s`/`end_s`). **Mark every NEAR entry as NEAR in the
entry itself** - a field, not a comment - so a later reader can tell a clip that
IS the technique from one that merely resembles it. A modal that silently shows
a hook for a check hook and says nothing is the kind of quiet lie this project
refuses.

**Do NOT invent a substitute for a NONE.** `FightClipBinding`'s own header says
"This module never invents a substitute" and that rule holds. A NONE stays
unbound and is counted.

## Owned files

- `Godot/scripts/FightClipBinding.gd` - yours for this task.
- `Godot/tools/q133_clip_coverage.gd` - NEW, the census tool.
- `research/Q133_DIGEST.md` - NEW.
- Nothing else. Do NOT touch `FighterCapsules.gd`, `FightPoseSolver.gd` or
  `s47_contact_offsets.gd` - Claude owns all three under S48/S49.

**BIG FILE WARNING:** `FightClipBinding.gd` is ~1,350 lines. Do not read it
whole in one go; `grep -n '^\s\+"[a-z_0-9]\+"\s*:\s*{'` lists every key, then
read `sed -n` windows. `Godot/scripts/GameState.gd` is ~12,900 lines and this
task does not need it at all.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightClipBinding.gd Godot/tools/q133_clip_coverage.gd
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only playback
```
Both subsets must stay at their current fails count or better. **The exit code
alone is NOT a pass** - a GDScript runtime error still exits 0. Read the printed
`SUITE total=N fails=M` line.

## Delivery

Cut a FRESH branch off `origin/master` first - your worktree sits on
`qwen/q132-capsule-census`, already merged. `git add -- <files>` only, never
`git add -A`, never `git stash` / `reset --hard` / `checkout .` / `clean`. Push
YOUR BRANCH, not master. Then:
```
python Tools/agent_comms.py send --from qwen --to claude --subject q133-ready --body "..."
```
Do NOT edit `HANDOFF.md`.

## WHAT ALREADY EXISTS - READ BEFORE YOU START (operator rule 2026-09-22)

**"The agents should have all available information on existing researches and
tools."** This checkout holds **789 research documents, 220 Godot tools and 116
drivers**, and until today no task file told you they were there.

`RESEARCH_INDEX.md` at the repo root is the generated list - one line per
artefact, with what it is. **GREP IT, DO NOT READ IT WHOLE** (it is 213 KB;
reading it costs more than the exploration it replaces):

```
grep -in '<your topic>' RESEARCH_INDEX.md
```

Worth a grep here: `clip`, `binding`, `retarget`, `ramsterz`, `motifect`, `technique`.

Then read the two or three that match, and nothing else. **A research document
is a FINDING, not an instruction** - it reports what was true when it was
written. If it names a file, a function or a flag, check that still exists
before building on it.

**AND A NEGATIVE RESULT IS A RESULT.** Several documents record that something
does NOT work - paired clip generation, a purchasable grappling pack, a numbered
referee break clock. Those are the most expensive findings in the set, and
re-running one wastes your whole pass.

**If the index shows something already answers part of your task, SAY SO in
your digest and build on it** rather than deriving it again. If it shows
something that CONTRADICTS your result, say that too - a contradiction found
early is worth more than a clean number found late.

## THE ONE TRAP FOR THIS TASK

**A BINDING THAT RESOLVES IS NOT A CLIP THAT PLAYS.** `ready=true` from a
resolver only proves a path matched a string. Two of these 125 files are
`.FBX` on a path that also contains `.import` siblings, and the RamsterZ FBX
set is mesh-free and walks NODES while a skinned glTF exposes its bones on a
`Skeleton3D` - `FightClipBinding`'s consumers already dispatch on that and you
must not assume one shape. **For at least five bindings you add, actually LOAD
the clip and print its track count and duration**, and say in the digest which
five you proved rather than implying all of them were checked.
