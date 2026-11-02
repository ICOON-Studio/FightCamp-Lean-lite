# TASK Q29 — QWEN — THE CLIP GRAFT EXISTS TWICE, AND IT IS GOING TO DRIFT

**Model: Qwen default, `--yolo`, medium effort.** Owner: Qwen.
Assigned 2026-09-10 by Claude, off his own R94.

Read this file and nothing else. Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest, and do not explore to "get oriented".

## The defect, and it is mine

R94 established this morning that a bought animation clip drops onto any of our
twelve rigged fighters with **no BoneMap** — the bone names already agree —
provided one thing is done: the clip carries **no skin**, so Godot imports its
bone hierarchy as plain `Node3D`s and its animation tracks address them by node
path (`Hips/RightUpperLeg`). Our fighters HAVE a skin, so their bones live in a
`Skeleton3D` and a track must read `Skeleton3D:RightUpperLeg`.

Rewriting those paths is the whole integration cost. It works. **But I wrote it
twice**, once in each of:

- `Godot/tools/probe_anim.gd` — the loop starting at the comment
  "THE ONE REAL INTEGRATION COST"
- `Godot/tests/fight_world_anim_test.gd` — the block under
  "THE SPIKE'S ACTUAL QUESTION"

Two copies of the same rule is a rule that will drift, and this one is going to
become production code the moment the 3D fight is built. **Make it one module.**

## What to build

A pure module in `Godot/scripts/` — statics only, **zero preloads** — that owns
the graft. At minimum it must be able to answer two things, and you choose the
exact names and argument order (you own the contract here, there is no blind
test waiting on it):

1. Given a source `Animation` and a `Skeleton3D`, return a **new** `Animation`
   whose tracks address that skeleton's bones — never mutating the source, which
   both current copies are careful about via `duplicate(true)`.
2. Report **what did not match**, because that is the number the whole spike
   turned on. A caller must be able to ask "did every track land on a bone this
   fighter has?" and get a straight answer, not infer it from a count.

Then **replace both copies with calls to it**, and confirm both still behave:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_anim.gd -- "C:/Users/user/Downloads/fighters_rigged/f01_m_box_welter_rigged.glb" "C:/Users/user/Downloads/fight_clips/combo_301222a4eb54bb4fc366fa054fc9a5a9_raw.glb"
```

must still print `tracks : 23, bones matched 23, unmatched names 0`,
`bones moved : 22 of 22` and `PROBE_ANIM PASS`.

## Owned files

- your new module in `Godot/scripts/` (new)
- its new test in `Godot/tests/` (new)
- `Godot/tools/probe_anim.gd` — 188 lines, read it whole
- `Godot/tests/fight_world_anim_test.gd` — 262 lines, read it whole
- `research/Q29_DIGEST.md` (new)

**Do NOT touch `FightRealtime.gd`** — Cursor is editing it right now — and do not
touch any `.glb`, `GrappleResolve.gd`, `combat_rulesets.json` (Codex is in it),
any pin file, or `HANDOFF.md`. Claude writes your block.

## Test tier — FOCUSED

```
python Godot/tools/check_scripts.py <your module> <your test> Godot/tools/probe_anim.gd Godot/tests/fight_world_anim_test.gd
python Godot/tools/run_tests.py --only <your test's substring>
python Godot/tools/run_tests.py --only fight_world
```

**Never pass `--godot`** — the runner already defaults to this project's engine,
and pointing it at the chocolatey binary makes every boot report `engine-error`,
which wasted a pass earlier today. `fight_world_anim_test` was **TOTAL=23
fails=0** before you started and must still be, with the same 23 checks. Ceiling
`fails=0` or better; if lower than expected, say so and push anyway.

## The assertion that makes your test worth having

Both existing copies only ever see a clip that matches **perfectly**. So neither
of them has ever exercised the interesting case. Your test must:

- assert the happy path (every track lands, nothing unmatched); **and**
- **construct a clip with a track naming a bone that does not exist** and assert
  the module reports it as unmatched rather than silently dropping it or
  crashing. That is the case a Mixamo clip will hit on day one — its skeleton is
  `mixamorig`-named, not ours — and it is the case neither current copy covers.

You can build that second Animation in code; you do not need a file for it.
Assert that the source Animation is unchanged afterwards, too.

## Land it

`git status -s` first — shared checkout. Explicit paths only, never `git add
-A`, never `git stash`, `reset --hard`, `checkout .` or `clean`. Commit, push
`master`, trailer `Co-Authored-By: Qwen Code <noreply@qwen.ai>`, write the
digest, then one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic Q29-done --body "<commit> <test> n/m, fight_world n/m — the module name and its two callers, and what it does with a track that names a bone the fighter does not have"
```

## The trap

**The last path segment is the bone name, and the separator matters.** A track
path can be `Hips/Spine/Chest` (node path, what the clip has) or
`Skeleton3D:Chest` (bone track, what we want) — so splitting on `/` alone is
wrong the moment you meet an already-grafted clip, and splitting on `:` alone is
wrong for the clip we actually buy. Both current copies split on `:` first and
then on `/`, in that order, for exactly that reason. Keep that, and make your
test prove a **re-graft is safe** — grafting an already-grafted animation must
not produce `Skeleton3D:Skeleton3D:Chest`.
