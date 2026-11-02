# TASK_C152 - a BLIND contract test for the silhouette segment list

Model: gpt-5.6-luna, MEDIUM effort. You own C152. This file is self-contained:
read it and the files it names, nothing else. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore to
"get oriented".

## THIS IS A BLIND TEST. DO NOT READ THE IMPLEMENTATION'S NEW STATE.

Claude is editing `FightClipRetarget.SILHOUETTE_SEGMENTS` in this same repo,
right now, on master. **You write the test from the CONTRACT below and from
nothing else.** Do not wait for that edit, do not read Claude's branch, and do
not shape an assertion around whatever the constant happens to say when you look
at it. A test written against an implementation only ever agrees with it.

You may read `Godot/scripts/FightClipRetarget.gd` for the DOC COMMENT on
`silhouette_rest` (around line 255-275) - the rule you are encoding is stated
there in prose. You may not copy the segment list into your assertions.

## THE CONTRACT, IN FULL

`FightClipRetarget.SILHOUETTE_SEGMENTS` is an `Array` of `Array`s. Each entry is
`[start_bone: String, end_bone: String]` or
`[start_bone: String, end_bone: String, "keep_end"]`.

`silhouette_rest(skel, source_rest, segments)` walks that array in order and, for
each pair, re-aims the START bone so the line from start to end points where the
source rest's matching line points. Three properties follow, and all three are
what this test must assert:

1. **EVERY START BONE IS UNIQUE.** Aiming a bone twice makes the two pairs fight
   over it and the last one wins. This was MEASURED: listing both
   `UpperChest->LeftShoulder` and `UpperChest->RightShoulder` sent the right arm
   to 0.03 deg and the LEFT to 51.43 deg, worse than the 34.66 it started at.
   So: no bone name may appear as `pair[0]` more than once in the array.

2. **A START BONE MUST HAVE EXACTLY ONE MAPPED CHILD IN THE LIST.** The deeper
   form of (1): a bone that branches cannot be aimed at one of its children.
   Assert it structurally - for every pair, the start bone must not be the start
   of any other pair AND must not be an ancestor, in the skeleton, of any other
   pair's start bone unless that other pair appears LATER in the array. (The
   ancestor test needs a real skeleton; see "THE FIXTURE".)

3. **PARENT SEGMENTS COME FIRST.** If start bone A is an ancestor of start bone
   B in the skeleton, A's pair must appear at a LOWER index than B's pair. A
   parent re-aimed after its child swings the child off its aim.

Also assert, cheaply:

4. Every entry has size 2 or 3; a size-3 entry's third element is exactly the
   string `"keep_end"` and nothing else.
5. Every bone named - start or end - is a real bone on the fixture skeleton
   (`skel.find_bone(name) >= 0`).
6. `end_bone` is a CHILD of `start_bone` on the fixture skeleton. A segment
   spanning two joints is not a segment.

**DO NOT assert the list's exact length, and do not assert that any particular
bone pair is present or absent.** Those are the fossils that break the moment
the list legitimately grows. `fight_clip_retarget_test.gd:476` already asserts a
size floor; leave that file alone.

## THE FIXTURE

Use the rigged fighter GLB the other retarget tests use:
`res://assets/models/fighters/f01_m_box_welter_rigged.glb`. Load it, find its
`Skeleton3D`, and read parentage with `get_bone_parent()` / `find_bone()`.

**A SKINNED glTF PUTS ITS BONES ON A `Skeleton3D`, NOT ON LOOSE `Node3D`s** -
find the `Skeleton3D` node, do not walk for `Node3D` children.

If the GLB will not load, print a LOUD SKIP (see "THE RUNNER READS YOUR WORDS")
and exit with `failures=0`. A skip is an acceptable delivery; a green test that
measured nothing silently is not.

## NON-VACUITY - THIS IS NOT OPTIONAL

A derivation that reads nothing prints a confident 0.000 and looks like a
measurement. Before any assertion runs, print and assert a denominator:

    the segment array is non-empty, AND at least 10 pairs resolved BOTH bones on
    the fixture skeleton

If fewer than 10 resolved, that is a FAILURE, not a pass.

## PROVE IT WITH MUTANTS - AT LEAST FIVE, AND THEY GO IN A SCRATCH COPY

Do not believe a green contract test. Copy the constant into a scratch array
inside a throwaway script, mutate it, and confirm each mutant goes RED:

1. duplicate a start bone (e.g. add a second pair starting at `Chest`)
2. put a child's pair BEFORE its parent's pair
3. name a bone that does not exist on the skeleton
4. make `end_bone` a grandchild rather than a child
5. a size-3 entry whose third element is `"keepend"` (a typo, not the token)

Report each mutant and whether it went red. **A mutant that stays green means the
assertion for it is missing - add it.** Delete the scratch file before you
commit; nothing scratch is staged.

## THE RUNNER READS YOUR WORDS, NOT YOUR EXIT CODE

`run_tests.py` fails a test on any of: a real script error, its own `FAIL` or
`failures=N` line while exiting 0, no output of its own, or rc != 0.

So: if your test deliberately prints diagnostics about a mutant or a skip, those
lines must NOT contain the runner's words (`FAIL`, `failures=`). Use different
wording for anything that is not a genuine failure. End the run with exactly one
`failures=N` line, and make N real.

## TEST TIER

Parse gate FIRST:

    python Godot/tools/check_scripts.py Godot/tests/fight_silhouette_segments_test.gd

(about a second; the autoload-identifier compile errors it prints are expected
and filtered.) Then that ONE test, directly:

    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot \
        --script tests/fight_silhouette_segments_test.gd

**A NEW TEST FILE CANNOT BREAK ANOTHER TEST, so DO NOT RUN THE SUITE.** It costs
forty minutes and buys nothing here. Do not run `run_tests.py` at all.

## OWNED FILES

- `Godot/tests/fight_silhouette_segments_test.gd` (new)
- `research/C152_SILHOUETTE_SEGMENT_CONTRACT.md` (new, 40 lines at most:
  the six properties, the mutant table, the non-vacuity denominator you got)

Nothing else. **Do not touch `Godot/scripts/FightClipRetarget.gd`** - Claude is
editing it and a concurrent write loses one of you.

## FINISH

Commit with explicit paths (`git add -- <files>`). You are on the MAIN checkout,
so run `git status -s` FIRST: another session's WIP may be pre-staged, and a
path-limited add can still sweep it. Never stage `AgentComms/` or
`audio_exports/`. Push `master`. Then ONE line:

    python Tools/agent_comms.py send --from codex --to claude --topic c152-ready --body "<hash>, failures=N, M of 5 mutants red"

Do NOT edit `HANDOFF.md`.

## THE ONE TRAP SPECIFIC TO THIS TASK

**The list is about to get LONGER and your test must still pass.** Three segments
are being added to it today. If any assertion you write encodes the current
count, the current membership, or the current index of a pair, you will hand back
a test that goes red on a correct change - which is worse than no test. Assert
the RULE, never the CONTENTS.
