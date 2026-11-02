# TASK_C144 — CODEX — THE BLIND TEST THAT A POSE'S LEAN SURVIVES THE RETARGET

**Agent:** Codex · **Model:** `gpt-6-astra` · **Effort:** medium · **Fast:** off
**Launch:** from PowerShell, with Windows paths:

```
$env:CODEX_MODEL = "gpt-6-astra"
$env:CODEX_EFFORT = "medium"
Tools\codex_task.cmd C:\Users\user\OneDrive\Documents\ChatGPT\Game\research\TASK_C144.md
```

**THIS IS THE FIRST TASK UNDER THE OPERATOR'S 2026-09-21 RULING**, verbatim: *"so only use
astra for 3d animation design and use luna for other tasks."* This is 3D animation design, so
it gets Astra. The `gpt-5.6-luna` default is unchanged for everything else.

**Branch:** master, main checkout. **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

**Test tier — you ADD one `.gd` test file and edit no script:** parse gate
(`python Godot/tools/check_scripts.py Godot/tests/fight_lean_survives_test.gd`) then **that ONE
test**, direct. **NO full suite, no `--only` subsets.** A new test file cannot break another.

---

## THIS IS A BLIND CONTRACT TEST. DO NOT LOOK AT THE FIX.

Cursor is repairing `FightClipRetarget.gd` **right now, in a parallel worktree**, so that an
authored pose's forward lean survives the retarget. You are writing the test for that repair
**from the contract below and from nothing else.**

**Specifically forbidden:** reading any `cursor/` branch, reading Cursor's working tree, or
`git diff`ing to see what is being built. You may read `FightClipRetarget.gd` **on master as it
stands today** — that is the public surface, not the answer.

This split has paid three times running (C142, C143, and S31's binding). Repeat it.

## THE PROBLEM, IN ONE PARAGRAPH

S31 authored a collar-and-elbow clinch in Cascadeur with a **28-degree forward lean** and bound
it to `mma_dirty_boxing`. After retargeting, the two fighters stand **straighter** than they
were authored: the authored head-to-head of 0.216 m should arrive at ~0.226 m on our 1.047x
bodies and instead arrives at 0.318 m, while the hips are correct to 4%. The error grows up the
chain and the hands end 0.47 m from where they belong.

## THE CONTRACT

Write `Godot/tests/fight_lean_survives_test.gd`. It must assert, on the BOUND clinch
(`FightClipBinding.paired_strike_metadata_for("mma_dirty_boxing")`):

1. **The bound pair still exists and still points at Cascadeur `.glb` halves.** If
   `mma_dirty_boxing` is absent, **SKIP GREEN** (print a SKIP line, `failures=0`, exit 0).
2. **The retargeted attacker leans.** Measure the angle, in degrees, between world UP and the
   attacker's spine axis — the vector from the `Hips` bone origin to the `Neck` bone origin —
   at t = 0 of the bound window. **Assert it is at least 12 degrees.** Today's straightened
   pose is the failure this catches; a man standing upright reads near 0.
3. **The victim leans too.** Same measure on the victim's skeleton, same bound.
4. **The two men lean TOWARD each other, not the same way.** In a clinch both spines tilt
   inward. Assert the two spine axes are not parallel in the horizontal plane: the angle
   between their horizontal projections is **greater than 90 degrees**. Two men leaning the
   same direction is a stack, not a clinch.
5. **The lean is not achieved by falling over.** Both fighters' `Hips` bones stay between
   0.6 m and 1.3 m above the world origin's Y across the window.
6. **Nothing about the bought pack changed.** `FightClipBinding.PAIRED_BINDINGS` still has
   exactly the ten grapple keys it has today, and `grapple_control` still names
   `Paired_FullMount_Takedown_BodyLock_Loop`. Read the current key count off master and pin it
   as a literal.

**SAMPLE AT LEAST 5 POINTS** across the bound window, not just t=0, and assert the bounds hold
at every one. Report the min and max lean in degrees for both men in the test's own output —
a bound with no measured number beside it is what this project keeps getting wrong.

## HOW TO READ A POSE — THE ONE THING THAT WILL SILENTLY RUIN THIS

**`Skeleton3D.get_bone_global_pose()` returns the REST pose on a headless skeleton.** Every
angle comes out constant and wrong while looking perfectly fine. Use
`FightPoseBridge.globals_at(skel, anim, t)`. Both `Godot/tools/s31_contact_probe.gd` and
`Godot/tools/pair_gap_report.gd` read poses that way — **copy that pattern, do not invent a
second one**, and read those two files for how to graft the pair and get the animations.

## PROVE IT WITH MUTANTS — AT LEAST FOUR, IN A SCRATCH COPY

A contract test nobody has tried to break is a green light with no bulb. In your scratchpad,
break things and confirm the test goes RED each time. Table the four results in the digest:

1. Lower the lean bound to 0 degrees — assert 2 and 3 stop being able to fail (shows the bound
   is what is doing the work, not the plumbing).
2. Point both men's spine axes the same way — must fail on 4.
3. Raise the hips bound floor to 1.5 m — must fail on 5.
4. Change the pinned grapple key count by one — must fail on 6.

If the retarget has not been repaired when you run, the test will legitimately FAIL on 2 — that
is correct and expected. **Say so in the digest and commit it anyway**; it turns green when
Cursor's fix lands. Do NOT weaken a bound to make it pass today.

## OWNED FILES

- `Godot/tests/fight_lean_survives_test.gd` (new)
- `research/C144_LEAN_CONTRACT.md` (new, under 60 lines)

**Touch NOTHING else.** Do not edit `FightClipRetarget.gd` — Cursor is inside it.

## THE ONE TRAP

**`var x := <call>` fails when the call returns Variant**, and `Dictionary.get()` on an untyped
value is exactly that. Write the type on everything you pull out of a Dictionary:
`var meta: Dictionary = ...`, `var start: float = float(meta["start_s"])`. A parse error does
not fail a headless test — it HANGS it until the timeout.

`FightClipBinding`, `FightClipRetarget` and `FightPoseBridge` are scripts, not autoloads.
`load()` them inside `_initialize()`; no top-level `preload` into `smoke_test.gd`.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push master, then one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic c144-ready --body "<one line>"
```

The CLI takes `--topic`, not `--subject`. Do NOT edit `HANDOFF.md`. Check `git status -s`
before staging; `AgentComms/messages` must be unstaged on any commit that is not the mail.
