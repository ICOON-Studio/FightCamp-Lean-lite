# TASK Q125 — QWEN — WHAT UNREAL DOES WHEN THE SOURCE SKELETON IS NOT THE TARGET'S SHAPE

**Model: qwen (its own CLI, `--yolo`, from the repo root). Effort: default. Research only — no `.gd` is edited, so NO parse gate and NO Godot test.**

## THE QUESTION

Our retarget copies rotations from a capture skeleton onto a fighter rig whose
bones are **different lengths**. When two captured men grip each other at
0.099 m, our rig holds the same two hands 0.461 m apart. A rotation-only
retarget cannot do better than that: if the source's upper arm and forearm are
not the same fraction of its height as ours are, the hand MUST land somewhere
else.

Unreal Engine 5.8 ships a production retargeter that solves exactly this, and
its **source is on this PC**. Read it and report what it actually does — the
mechanism, the parameter names, and every shipped default number.

**DOCUMENTED, NOT REMEMBERED.** Every claim in your digest cites
`<path>:<line>` and quotes the line. A claim you cannot cite does not go in.

## WHERE TO READ (and nowhere else)

Root: `C:/Program Files/Epic Games/UE_5.8/Engine/Plugins/Animation/IKRig/Source/IKRig/`

Read these, `Public/Retargeter/` first for the UPROPERTY defaults and their
comments, then the matching `Private/Retargeter/` for the maths:

1. `Public/Retargeter/RetargetOps/FKChainsOp.h` + `Private/.../FKChainsOp.cpp`
   — **this is the core answer.** Find the translation mode and scale mode
   enumerations, list EVERY enumerator with its comment, and say which is the
   default. Then in the `.cpp` find where a bone's translation is produced and
   write out, in words plus the expression, how each mode computes it.
2. `Public/Retargeter/RetargetOps/StretchChainOp.h` + its `.cpp` — how a chain
   is lengthened or shortened to reach, and what bounds it.
3. `Public/Retargeter/RetargetOps/ScaleSourceOp.h` and `ScaleGoalsOp.h` (+ `.cpp`)
   — what exactly is scaled, by what, and against which reference measurement.
4. `Public/Retargeter/RetargetOps/IKChainsOp.h` + its `.cpp` — how the goal
   position is derived from the source, and what happens when the target chain
   cannot reach it.
5. `Public/Retargeter/RetargetOps/PelvisMotionOp.h` + its `.cpp` — how the root
   height difference between two differently-sized skeletons is handled.
6. `Private/Rig/Solvers/LimbSolver.cpp` — the reach/extension clamp only.

Ignore the editor module, the deprecated header, and anything under `Editor/`.

## THE FIVE ANSWERS, IN THIS ORDER

**A1. Does UE copy translation at all, or only rotation?** Name the modes and
the default. If translation is scaled, give the EXACT ratio it is scaled by —
what is in the numerator and what is in the denominator, and whether it is a
single whole-body scalar or per-chain.

**A2. What reference length is that ratio taken from?** A bone length? A chain
length? A height? Where is it measured — retarget pose or current pose?

**A3. What does UE do when the target limb is too short to reach the goal?**
The clamp, its constant, and whether the chain is allowed to stretch past it.

**A4. Every shipped default number** you saw, as a table: parameter, value,
unit, file:line. Do not convert units — report UE's own (cm, degrees).

**A5. WHICH ONE THING WOULD FIX A HAND THAT LANDS 0.36 m TOO FAR OUT?** One
paragraph, your own judgement, naming the op and the mode. Say what it costs:
does it need an IK solve, or is it a scalar applied to a translation track?

## FALSIFIABLE CONTROL

Two of the five files above are expected to say **nothing** about proportion
mismatch. Name which two and say so explicitly. A digest where every file
conveniently answers the question is a digest that was written from the
question rather than from the source.

## OWNED FILES — create these, touch nothing else

- `research/Q125_UNREAL_PROPORTION_RETARGET.md` — the digest, at most 120 lines.
  Every numeric claim carries `path:line` and the quoted line.
- `research/Q125_claims.json` — a JSON list; one object per cited claim:
  `{"file": "<absolute path>", "line": <int>, "quote": "<the line, verbatim, trimmed>"}`.
  At least 12 entries, and they must span at least four different files.

## GATE — run it, it must exit 0

```bash
python research/check_source_claims.py research/Q125_claims.json
```

It re-opens every cited file at every cited line and requires your quote to be
there. It is the whole gate: there is no Godot test and no parse gate, because
you are not editing a `.gd`.

## DELIVER

`git add -- research/Q125_UNREAL_PROPORTION_RETARGET.md research/Q125_claims.json`
(explicit paths only — never `git add -A`; another agent's work may be staged),
commit, push to `master`, then one line:

```bash
python Tools/agent_comms.py send --from qwen --to claude --subject q125-ready --body "<one line: A1's answer and A5's op in a dozen words, plus the check's exit code>"
```

Do NOT edit `HANDOFF.md`, `CURRENT_STATUS.md`, or any roadmap file.

## THE TRAP SPECIFIC TO THIS TASK

**UE calls things by names that sound like ours and are not.** "Retarget pose"
is not our rest pose; "IK" in `IKChainsOp` runs on GOALS derived from the
source, not on a hand-to-hand contact like ours. Report what the code does,
not what the name suggests. And do not copy Unreal's code into this repo —
quote lines in the digest, cite names and numbers, nothing more.
