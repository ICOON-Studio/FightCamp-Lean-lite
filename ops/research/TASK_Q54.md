# TASK Q54 — QWEN — HOW TWO SKELETONS SHARE ONE PERFORMANCE

Model: qwen, medium effort. Owner: qwen.
Test tier: **RESEARCH — no `.gd` file is touched.** NO parse gate, NO test, and
do NOT run the suite. `git status -s` before you stage is the whole check.

## Owned files

- `research/Q54_PAIRED_IN_GODOT.md` — **NEW. Yours alone.**

Nothing else.

## Why this exists

We own eight **paired** two-body grappling clips and we are putting the first one
on screen. A paired clip is one performance danced by two bodies: the two halves
were authored together in a single shared space, and the value of the pack is
entirely in the alignment between them. Mount the halves carelessly and you get
two people miming a grapple a foot apart.

We have proved the alignment survives import. What we do not have is the
documented Godot-side practice for keeping it. **Label every answer `DOCUMENTED`,
`INFERENCE` or `NOT FOUND`**, with a source URL on anything DOCUMENTED — the same
method you used for Q47, Q50, Q51 and Q52.

## Q1 — Two `Skeleton3D`s, one rigid pair

In **Godot 4.7** (answer for 4.3+ and note if 4.7 differs):

- What is the documented way to keep two animated `Skeleton3D`s in a fixed
  relative pose? Is the intended structure two skeletons under one shared parent
  `Node3D`, two `AnimationPlayer`s driven by one `AnimationTree`, or something
  else?
- If two `AnimationPlayer`s play the two halves, **what synchronises them?** Is
  there a documented way to guarantee both advance on the same frame, and what
  happens to the pair if one is `.seek()`ed or the game drops a frame?
- Does Godot document anything at all under the words **paired**, **interaction**,
  **synced** or **two-character** animation? If the answer is that it does not,
  say `NOT FOUND` plainly — that is a useful answer and we would rather have it
  than a plausible invention.

## Q2 — Root motion on BOTH halves at once

Our pack's clips carry root motion on each half separately.

- What does `RootMotionView` / `AnimationMixer.root_motion_track` do when TWO
  players each produce root motion that is supposed to be relative to a SHARED
  origin? Is applying both a documented error?
- Is the documented practice to **strip** root motion from the halves and drive
  the pair's shared node instead, or to apply one half's motion to the pair and
  let the other ride along? Give the reasoning each source gives.

## Q3 — The rest-pose correction, still unmeasured

R106 listed this as the top open question and it has never been answered:

- The UE4 Mannequin ships in an **A-pose**; `SkeletonProfileHumanoid`'s rest is a
  **T-pose**. `T_pose.fbx` ships inside the pack as the reference.
- What exactly does Godot's importer option **`retarget/rest_fixer`** do? Document
  its sub-options (`apply_node_transforms`, `overwrite_axis`,
  `fix_silhouette`...), what each one changes, and which combination is documented
  for an A-pose source against a T-pose profile.
- **The catch we already know about:** FBX import is an EDITOR path. Anything that
  depends on it cannot run in an exported build — that is why our title screen
  bakes its animations ahead of time. So also answer: **is `rest_fixer` an
  import-time transformation baked into the saved resource, or a runtime one?**
  If it is import-time, we can use it and ship the result; if runtime, we cannot.
  This is the question that decides the shape of the whole feature.

## Q4 — What everyone else does

Briefly, and clearly marked as a different class of source: how do other engines
document paired/interaction animation — Unity's humanoid + "match target",
Unreal's paired montages / motion warping? We are not copying an implementation;
we want to know which problems they found worth solving, because those are the
ones we are about to meet.

## The deliverable

`research/Q54_PAIRED_IN_GODOT.md`. Tables where they fit. Finish with
**"THE ROUTE WE SHOULD TAKE"**: the node structure, what drives the two players,
what happens to root motion, and whether `rest_fixer` is usable in a shipped
build. INFERENCE is allowed there; say so.

Under 250 lines.

## Definition of done

- Every answer labelled, Q3 answered without hedging.
- `git add -- research/Q54_PAIRED_IN_GODOT.md`, commit, push.
- One line back:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q54-done --body "<sha> rest_fixer=<import-time|runtime|NOT FOUND> <node structure in five words>"`

## The trap specific to Q54

**Q3 decides whether this feature can ship, so do not guess it.** "Probably
import-time" is worth nothing here: if `rest_fixer` turns out to be an editor-only
transformation that does not survive into an exported build, we must bake the
paired clips the way the title screen bakes its idles, and finding that out after
the code is written costs a stage. Find the documentation, quote it, and link it.
If you cannot find it, write `NOT FOUND` in those words and say what experiment
would settle it.
