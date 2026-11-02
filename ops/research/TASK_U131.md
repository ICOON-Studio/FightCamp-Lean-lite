# TASK_U131 - CURSOR - THE TECHNIQUE PREVIEW MODAL

**Owner:** cursor
**Model:** `composer-2.5`, MEDIUM. `-p --force --trust --workspace <worktree>`
**Test tier:** parse gate on every touched `.gd`, then
`python Godot/tools/run_tests.py --only ui`, then SEPARATELY `--only skills`.
`--only` DOES NOT STACK - one substring per invocation, read `total=` to
confirm how many ran. Do NOT run the full suite.

## Why this, and it is the operator's own request

**Operator, 2026-09-22, verbatim: "when you move over a technique/skill i want a
modal to display the actual animation of the move".**

`SkillsMovesPanel.gd` already draws a skill tree per discipline with a node
schematic for the selected technique. What it has never had is **motion**. This
task adds the modal.

## The honest state of the catalogue, because the modal must handle it

- **696** technique nodes across 15 disciplines.
- **162** are `kind: skill` - passive attributes like distance read, coverage,
  mobility. **These have no motion and never will.** The modal must not show
  them an empty clip slot; it shows what the skill DOES.
- **534** are `kind: move` or `kind: sequence` and want motion.
- **15** resolve to a clip by their own technique id today. Qwen's Q133 is
  wiring the ~125 clips already on disk as you work, and Higgsfield generation
  is filling the rest, so **your coverage number will rise under you. Do not
  hard-code it and do not gate on it.**

**So there are FOUR states and the modal must distinguish all four:**

1. **PLAYING** - a clip bound to this technique id, playing.
2. **NEAR** - a clip is bound but marked NEAR, i.e. the same motion under
   another name. **It must say so on the face.** A hook shown for a check hook
   with no label is a quiet lie and this project refuses those.
3. **NO CLIP YET** - a `move`/`sequence` with no binding. Say that, and say
   nothing else - do not invent a substitute, do not fall back to a sibling.
4. **NO MOTION** - a `kind: skill`. Not an error, not an empty slot: this
   technique is an attribute, and the modal shows its effects instead.

## What to build

### `UIKit.technique_preview(...)`

A modal panel. Your geometry decision, but it obeys the kit: 1920x1080 frame,
type scale 12/14/18/28, spacing base 8, and it must not cover the tree node the
pointer is on.

Contents: the technique name and discipline, the **viewport** (state 1/2) or the
state card (3/4), and the node's existing schematic summary underneath. Reuse
`TechniqueGlyphs` for the pictogram - do not draw a new one.

### The playback

`FightClipBinding` resolves a clip path by key. `FightWorldPreview.tscn` and the
existing stage-player path are how a clip gets onto a rig; **find how
`FightStagePlayer` grafts a retargeted clip and reuse it rather than writing a
second path.** A clip loops while the modal is open and stops when it closes.

### The hover

`SkillsMovesPanel` has `select_node(technique_id)`. Add hover without breaking
selection - they are different gestures and the modal opens on hover.

**HOVER NEEDS A DWELL DELAY OR IT IS UNUSABLE.** A tree with up to 173 nodes in
one discipline (karate) will flicker a modal on every mouse transit. Pick a
dwell (150-300 ms is the usual band), make it a named constant with its reason
beside it, and cancel it on exit.

## Owned files

`Godot/scripts/UIKit.gd`, `Godot/scripts/SkillsMovesPanel.gd`,
`Godot/scripts/UITokens.gd` if a token is genuinely missing, the kit-book
entries, and a new `Godot/tests/ui_technique_preview_test.gd`.

**DO NOT EDIT** `Godot/scripts/FightClipBinding.gd` - Qwen owns it under Q133
right now and you will collide. READ it, call it, do not change it.

**BIG FILE WARNING:** `UIKit.gd` is large - do not read it whole. `grep -n "func
region_panel\|func scored_card" Godot/scripts/UIKit.gd` and read `sed -n`
windows; both are the shape of this job. `SkillsMovesPanel.gd` is 596 lines and
IS small enough to read whole. `GameState.gd` is ~12,900 lines and this task
does not need it.

**SCENE-SCRIPT TRAP, and it will bite here:** `SkillsMovesPanel` is mounted by
the profile scene, which compiles BEFORE the autoloads. Never use the bare
`GameState` identifier - `get_node_or_null("/root/GameState")` plus
`has_method`. The file's own header says so.

## Gate

```
python Godot/tools/check_scripts.py <every touched .gd>
python Godot/tools/run_tests.py --only ui
python Godot/tools/run_tests.py --only skills
```
`--only ui` is **total=15 fails=0** today and must stay there. It includes
`ui_kit_book_test` at **317 variants / 317 renders / 0 failures**.

**EVERY NEW PUBLIC `UIKit` FACTORY NEEDS A KIT-BOOK ENTRY, THEN ITS PNG.**
After adding the entry run `tools/render_kit.gd` **WITHOUT `--headless`**:
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --path Godot --script tools/render_kit.gd
```
and commit the new PNGs under `DesignLibrary/kit/renders`. That gate went red
twice this week for exactly this omission.

**The exit code alone is NOT a pass** - a GDScript runtime error still exits 0.

## Delivery

Cut a FRESH branch off `origin/master` first. `git add -- <files>` only, never
`git add -A`. Push YOUR BRANCH, not master. Write
`research/U131_DIGEST.md` and send:
```
python Tools/agent_comms.py send --from cursor --to claude --subject u131-ready --body "..."
```
Your mail must be ON THE BRANCH YOU PUSH. Do NOT edit `HANDOFF.md`.

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

Worth a grep here: `clip`, `retarget`, `binding`, `technique`, `skill`, `UIKit`.

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

**A MODAL THAT RESOLVES A PATH IS NOT A MODAL THAT PLAYS A CLIP.** `ready=true`
from a binding lookup only proves a string matched. A retargeted clip names its
tracks with a BARE BONE NAME - `NodePath("Hips")`, `get_subname_count()` is
ZERO - and is only rewritten to `<skel_path>:<bone>` once a player grafts it.
Any code that reads `get_subname(0)` on a fresh retarget gets `""`,
`find_bone("")` is -1, EVERY track is skipped, and the rig composes to its REST
pose - which on screen is a man standing still, looking exactly like a clip
with no motion in it. **Handle both track forms, and prove one clip actually
moves by asserting a bone's position CHANGES between two frames.** A screenshot
of a T-pose is not a passing test.
