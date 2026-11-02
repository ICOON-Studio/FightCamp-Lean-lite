# TASK_C151 — CODEX — THE BLIND CONTRACT TEST FOR THE CLIP BAKE RATE

**Owner: Codex.  Model: `gpt-6-astra`, MEDIUM effort.**
Set it per-task: `CODEX_MODEL=gpt-6-astra CODEX_EFFORT=medium`. This is
retargeting and clip-loading work — motion on a skeleton — so it is astra's by
the operator's 2026-09-21 domain split. `Tools/codex_task.cmd` honours both
variables and the luna default is untouched.

**Test tier: ONE NEW TEST FILE. Parse gate it, run it alone, stop.** A new test
file cannot break another test, so a full suite run here buys nothing and costs
twenty-five minutes. **DO NOT RUN THE FULL SUITE.**

**Owned files (yours, nobody else touches them this run):**
- `Godot/tests/fight_clip_bake_rate_test.gd`  (NEW — you create it)
- `research/C151_BAKE_RATE_CONTRACT.md`  (NEW — your digest)

**You own NOTHING else.** In particular you must not edit
`Godot/scripts/FightClipRetarget.gd`. If the contract below appears not to hold,
that is a finding for your digest, not a fix.

---

## WHY THIS TEST EXISTS — READ THIS, IT IS THE WHOLE POINT

`GLTFDocument.generate_scene()` and `FBXDocument.generate_scene()` resample every
animation curve onto a `bake_fps` grid, and **the engine default is 30**. A 120 Hz
motion-capture clip loaded without saying otherwise therefore arrives with three
of every four frames interpolated back in from a 30 Hz bake. The caller gets the
sample COUNT it asked for and not the detail.

This cost the project two stages. The CMU paired grip probe asked for 120 Hz,
received a 30 Hz resample, and reported the closest approach in 18/19_05 as
**0.1455 m against the capture's true 0.1407 m** — 4.8 mm, sitting directly on
the one figure that fixture is validated by. On the sustained grip in 22/23_17 the
same resample costs nothing to four decimals (0.0987 m either way), which is
exactly why it hid: **a resample destroys single-frame extrema and leaves
distributions alone.**

S39 added a `bake_fps` parameter. You are writing the test that pins it.

---

## YOU ARE WRITING THIS BLIND, AND THAT IS THE POINT

The implementation is already on master, but **you must not read it.** Do not
open `Godot/scripts/FightClipRetarget.gd`, do not grep it, do not read the S39
digest or `HANDOFF.md`. Write every assertion from the contract below and from
the clips on disk.

A test written against an implementation only ever agrees with it. Two halves
written from one contract are evidence. This split has now paid off three times
in three days — C142's blind `CASCY_TO_UE4` test SKIPped green before the map
existed and passed for real, all four mutants intact, the moment Cursor landed it.

**SO THE TEST MUST SKIP CLEANLY IF ITS SUBJECT IS ABSENT**, which makes it
committable and green from the first minute:

```gdscript
var Retarget := load("res://scripts/FightClipRetarget.gd")
if Retarget == null:
    print("SKIP: FightClipRetarget.gd not present; contract test is inert.")
    print("checks=0 checks_failed=0")
    quit(0)
    return
```

---

## THE CONTRACT — THIS IS THE WHOLE SPEC. DO NOT INFER BEYOND IT.

### 1. The loader takes a bake rate, and its default is 30

```
FightClipRetarget._load_fbx(res_path: String, bake_fps: float = 30.0) -> Node
```

- Called with ONE argument it must behave exactly as it always did: a 30 Hz bake.
  **The default is load-bearing** — every shipped caller relies on it.
- Called with a second argument it bakes at that rate instead.
- It returns a `Node` (the generated scene) or `null` if the file is missing.

### 2. The rate reaches the animation

Load one of the CMU paired captures below at 30 and again at 120. The
`Animation` reachable from the returned scene's `AnimationPlayer` must carry
**more keys at 120 than at 30**, on the same track. Read the track count with
`Animation.track_get_key_count(track_idx)`; pick a track that is actually driven
(a rotation track on a limb bone), not the first track blindly.

### 3. The rate changes an EXTREMUM and leaves a DISTRIBUTION alone

This is the assertion that matters and the one a naive test omits.

Using `cmu_18_05.glb` and `cmu_19_05.glb` (see the fixture section), compose each
subject's world joint positions per frame and take, per frame, the **closest
distance between one man's hand node and the other man's elbow node, in either
direction**. Then over the clip:

- at **120 Hz** the minimum must be **≤ 0.142 m**
- at **30 Hz** the minimum must be **≥ 0.144 m**
- the **median** of the two series must agree within **0.004 m**

Those are a CEILING and a FLOOR, not exact equalities — if your run lands lower
at 120 or higher at 30, say so in the digest and pass. Never gate on an exact
figure; over-delivery must not be trapped.

### 4. The node naming convention, because it will bite you

**A glTF node sits at its bone's PROXIMAL end.** In these captures that means
the node named `lwrist` is the **elbow**, and the wrist is one node further out
at `lhand`. So for check 3:

- the **hand** nodes are `lhand` and `rhand`
- the **elbow** nodes are `lwrist` and `rwrist`

Do not "correct" this. It is the convention, it is verifiable from the
hierarchy — `lhand`'s parent is `lwrist`, whose parent is `lradius`, whose
parent is `lhumerus` — and reading it the other way is what cost the two stages
described above.

---

## THE FIXTURE — NAME IT IN YOUR OWN OUTPUT

`Godot/assets/anim/audition/cmu_paired/` holds CMU subjects 18, 19, 22 and 23.

Use **18/19_05**: 438 frames at 120 Hz, subject 18 against subject 19, "A pulls B
by the elbow; B resists". **Two DIFFERENT bodies** — their bone lengths differ
(lfemur 0.420 vs 0.423 m, ltibia 0.429 vs 0.461 m), verified by Q122. Never test
identical fighters; print the population line in your test's own output so a
later reader can tell a finding from a fixture.

`cmu_18_05.glb` and `cmu_19_05.glb` are the motion. Ignore the `_rest.glb` files —
this task does not retarget anything, it only loads and composes.

---

## MUTANTS — BREAK IT BEFORE YOU BELIEVE IT

A green contract test proves nothing until you have watched it go red. Copy
`FightClipRetarget.gd` to **`/tmp/mutant_retarget.gd`** — an absolute path
outside the repo, NOT "your worktree", because you are pinned to the main
checkout and a scratch file at the real path lands exactly where the real
implementation lives (this happened on C150). Point your test at the copy via a
`MUTANT=` command-line argument, or inline the mutation in a scratch harness.

Prove all five go RED:
1. `bake_fps` ignored — always bakes at 30.
2. `bake_fps` default changed from 30 to 120.
3. `bake_fps` passed to the glTF branch only, not the FBX branch.
4. Hand and elbow node names swapped (`lwrist`/`rwrist` as hands).
5. The 120 Hz minimum assertion loosened to `≤ 0.146` — must then FAIL to
   distinguish the two rates, proving the band is tight enough to be evidence.

**DO NOT COMMIT THE MUTANT OR THE SCRATCH HARNESS.** `git status -s` before you
stage, and stage explicit paths only.

---

## THE RUNNER READS YOUR LOG — MIND YOUR VOCABULARY

`Godot/tools/run_tests.py` fails a test on any line starting `FAIL`/`FAILED`, any
`failures=N` with N>0, and any `N failure(s)` — **even when the test exits 0 and
its own final line says it passed.** C141 and C142 were both condemned for
printing caught mutants in exactly that vocabulary.

So your mutant diagnostics must use **`checks_failed=`** and a `mutant_mode`
flag, never the runner's words. Final line of a passing run:

```
checks=<n> checks_failed=0
```

---

## GATE — RUN EXACTLY THIS, IN THIS ORDER

```
python Godot/tools/check_scripts.py Godot/tests/fight_clip_bake_rate_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_bake_rate_test.gd
```

The parse gate is about one second and a parse error that reaches a headless test
HANGS it until the timeout instead of failing. Run it first, every time.

Pass condition: `checks_failed=0`, at least 6 checks, and all five mutants
verified red. **Ceiling, not equality** — more checks is better, say so.

---

## WHEN YOU ARE DONE

1. Write `research/C151_BAKE_RATE_CONTRACT.md`: the checks, the two
   minima you measured at 30 and 120, the median agreement, the five mutant
   results, and the fixture's population line. Short.
2. `git add --` your two files by explicit path. Check `git status -s` first;
   another agent's WIP may be pre-staged, and `AgentComms/messages` must be
   unstaged before you commit.
3. Commit, ending the message with
   `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`, and push.
4. One line back: `python Tools/agent_comms.py send --from codex --to claude
   --subject c151-ready --body "<sha>, checks=N checks_failed=0, mutants 5/5 red"`
5. **Do NOT edit `HANDOFF.md`.** Claude writes your block.

---

## THE ONE TRAP SPECIFIC TO THIS TASK

**A 30 Hz bake and a 120 Hz bake give the SAME median and a different minimum.**
If you write the test around an average, a p50 or a mean, it will pass at both
rates and prove nothing — that is precisely how this defect survived. The test
must turn on an extremum. If your assertions still pass with mutant 1 applied,
you have measured a distribution and not the thing.
