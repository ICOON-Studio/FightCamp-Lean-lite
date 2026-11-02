# C167 — THE AUTHORED CLINCH'S ARMS DO NOT ARRIVE, AND EVERY CASCADEUR CLIP WE EVER MAKE INHERITS THAT

**Owner:** codex. **Model: `gpt-6-astra`** (operator ruling 2026-09-21 — astra
for 3D animation work, which this is: its product is motion on a skeleton).
**Effort: MEDIUM.** Set with `CODEX_MODEL=gpt-6-astra CODEX_EFFORT=medium`.

**Tier: parse gate on every touched `.gd`, then `s31_contact_probe.gd`, then
`--only clip`, `--only pair`, `--only grapple`, then the control arm below.
NO FULL SUITE** — it is Claude's, once, at integration.

## WHY THIS IS THE TASK, WHEN THE ASK WAS "ALL THE MISSING CLIPS"

**The operator's objective is to author the 376 missing clips in Cascadeur.**
Q133's census: of **534 motion techniques, 376 have no clip on disk at all** —
29.6% coverage. Cascadeur Pro is kept and paid for precisely so we can author
what cannot be bought.

**The chain already works end to end and it produces a clip with the wrong
arms.** S31 authored a collar-and-elbow clinch in Cascadeur, gave it four
seconds of measured life, exported two single-actor GLBs, retargeted them onto
our fighters and bound them to `mma_dirty_boxing`. The hips land **within 4% of
the authored separation**. The hands land **0.47 m from the other man's neck
against 0.073 m authored — 545% out**.

| contact | authored m | retargeted m | error |
|---|---:|---:|---:|
| `att_lhand_to_vic_neck` | 0.073 | 0.447 | **545%** |
| `att_rhand_to_vic_neck` | 0.097 | 0.447 | **387%** |

**So the hold is real, its distance is right, its breathing is right, and its
collar tie is not a collar tie.** Author 376 clips through this pipeline today
and you get 376 clips whose arms are half a metre from where they were posed.
**This defect is the gate on the whole objective, and it is why it is the first
task rather than the batch.** Fix it, prove it with the number, and the batch
becomes a loop instead of 376 separate problems.

**YOU DO NOT NEED CASCADEUR FOR THIS.** The authored source is already on disk
and the whole investigation is headless Godot. Do not open the GUI, do not start
the script server, do not touch `Tools/cascadeur/`.

## THE INSTRUMENT, WHICH ALREADY EXISTS

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
```

It prints `S31CONTACT <pair> <authored> <min> <max> <mean> <error%>` per contact.
**Drive `att_lhand_to_vic_neck` down.**

## THE GATE — A CEILING, NOT A TARGET

**`att_lhand_to_vic_neck` error must read 30% or better. If you land lower, say
so and push — do not hold back a better result.** (A task on this project once
forbade its own agent from pushing an over-delivery; never again.)

**DO NOT GATE ON `hip_to_hip`.** It already passes, and it is exactly what made
this defect invisible for an hour — a fighter with his arms over his head while
every number in the gate read green.

**If you cannot reach 30%, that is still a delivery.** Commit the instrument
output, name the number you reached, and say which of the three hypotheses below
it eliminated. **A measured negative result with the cause narrowed is worth far
more than a guess that reaches the number.**

## THE ORDER OF ATTACK — CHEAPEST FIRST, AND IT IS ALREADY DIAGNOSED

S31 left the hypothesis ranked. Work them in this order and **report the
measurement after each one, even when it does not help**:

1. **Make `_inherit_upper_chest` a no-op and re-measure.**
   `Godot/scripts/FightClipRetarget.gd:1017`, called at `:1005`. It copies
   Chest's global `Transform3D` onto `UpperChest` — the same global pose rather
   than a separate rotation drive. **This is one line and it is the whole
   hypothesis:** the pose depends on a **28° lean** (see below), and if that
   lean is being eaten anywhere, this is the most likely place.
2. **Print the retargeted vs source LOCAL rotation for `Spine`, `Chest` and
   `UpperChest` at `t=0`, and find which one loses the 28°.** Not the global
   pose — the local rotation, on both sides, side by side.
3. **Only then consider the arms themselves.** If the spine chain carries its
   full lean and the hands are still out, the defect is in the arm chain and
   that is a different fix. Say so rather than forcing step 1 or 2 to be the
   answer.

## THE 28° LEAN IS LOAD-BEARING AND IT IS DERIVED, NOT CHOSEN

Understand this before you change anything, because a "fix" that flattens the
lean will make the probe worse and look like progress on some other number.

S30 authored the clinch at **0.557 m** hip-to-hip. Q115 measured real footage at
**0.719 m** (p50, 57 frames) against a range control of 1.050 m, p10 0.709 m —
so S30's number sat 0.15 m below the closest approach anyone has observed, and
it was retired. **At the real 0.75 m the collar tie is 55.2 cm from the
attacker's shoulder and the rig's own arm is 26.4 + 23.1 = 49.5 cm. The arms
physically cannot reach.** The repair was not a tighter clinch, it was a deeper
lean: **18° → 28°**, at which the same tie is 41.0 cm away and all four arms are
inside reach **on all 121 frames**. Hips back, heads together — which is what a
clinch is. **The lean is derived from the rig's own reach.** Do not "fix" the
distance back to 0.557 m; that is a retired number and it disagrees with
footage.

## THE CONTROL ARM — NON-NEGOTIABLE

**Eleven bound films already work and a repair that moves them has broken more
than it fixed.** After any change:

```
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only pair
python Godot/tools/run_tests.py --only grapple
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/pair_gap_report.gd -- grapple_control
```

**The bought RamsterZ pack reads `0.302639` / `0.304671` and must still read
it.** If your change moves those numbers, it is not a fix — report it and stop.
`--only` does **NOT** stack: one per invocation, and read the `total=` to
confirm how many actually ran.

Known-red and NOT yours: `fight_pair_live` is **PARKED by the operator**, and
`fighter_reachability_contract` is **red on purpose**. Do not repair either.

## Owned files

- `Godot/scripts/FightClipRetarget.gd` (the retarget path — this is the one you
  are here to change)
- `Godot/tools/s31_contact_probe.gd` (only if the instrument needs a column it
  does not print; do not change what it measures)
- `research/C167_DIGEST.md`

**You own NOTHING else.** Do **not** touch `Tools/cascadeur/`, do not re-export
or re-author anything, do not edit `FighterCapsules.gd`, `CapsuleShape.gd`,
`ApproachBand.gd` or `FightPoseSolver.gd`, and **do not re-author the pose to
make the number pass** — that is fixing the fixture instead of the engine.

## Read these and nothing else

- `research/S31_THE_AUTHORED_CLINCH.md` — the defect, the pose, the
  numbers, and "HOW TO CHASE IT, NEXT SESSION" at the bottom, which is this task.
- `research/U114_CASCADEUR_RETARGET.md` — how the Cascadeur path was made
  to work at all, including `_inherit_upper_chest`'s own origin.
- `Godot/scripts/FightClipRetarget.gd` — **read `sed -n '100,130p'` for the
  doc comment on `_inherit_upper_chest` and `sed -n '995,1040p'` for the
  function and its caller.** Do not open the file whole first.

Do **NOT** read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest, and do not explore to "get oriented".

`RESEARCH_INDEX.md` is 231 KB, 790 research documents and 220 tools, one line
each — **GREP IT, NEVER READ IT WHOLE.** Worth running:
`grep -i 'cascadeur' RESEARCH_INDEX.md`, `grep -i 'retarget' RESEARCH_INDEX.md`,
`grep -i 'upper_chest\|upperchest' RESEARCH_INDEX.md`.
**A negative result is a result** — say so in the digest.

## THE TRAPS SPECIFIC TO THIS TASK

- **A SKINNED glTF PUTS ITS BONES ON A `Skeleton3D`, NOT ON LOOSE `Node3D`s.**
  `FightClipRetarget` has BOTH paths — `_index_walk` for the RamsterZ mesh-free
  FBX and `_index_skel`/`_local_at` for a Cascadeur export. **Both must stay; do
  not "simplify" them into one.** A two-character glTF also prefixes its joint
  names (`character1:`), which is what `_strip_namespace` is for.
- **`Cascy_rest_reference.glb` IS A REST POSE, NOT A T-POSE, and that is
  settled.** `build_silhouette_corrections` reads the file's BIND/REST hierarchy
  through `_local_at(index, null, 0.0)` and never inspects an arm angle. Do not
  rename it, do not assume a T-pose is required, and do not reopen it.
- **`UE4_TO_OURS` IS READ BUT NEVER REDEFINED** by the Cascadeur path —
  `cascy_to_ours()` chains `CASCY_TO_UE4` through it. **Keep it that way**: the
  RamsterZ path rides on `UE4_TO_OURS` and eleven bound films with it.
- **rc=0 IS NOT A PASS.** A GDScript runtime error exits 0, and a parse error
  HANGS a headless run for 600 s instead of failing it. Parse gate first, always,
  and read the probe's actual numbers rather than its exit code.
- **A test that prints the runner's failure vocabulary is condemned by the runner
  even when it passes** (`run_tests.py:136-140`: any line starting
  `FAIL`/`FAILED`, any `failures=N` with N>0, any `N failure(s)`). If you print a
  deliberate diagnostic, use `checks_failed=`.
- **`var x := <call>` fails when the call returns Variant** — write the type.
  **`%` in a format string must be `%%`.** **Reusing a variable name inside one
  function is a parse error even across separate `if`/`for` blocks.**
- **A PATCH SCRIPT MUST DETECT THE LINE ENDING** — this repo mixes them in one
  directory. `NL = "\r\n" if "\r\n" in text else "\n"`.

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current at master, and a
  rebase here refuses over the untracked `.uid` / `.import` / scratch files this
  checkout always carries. You stopped at exactly that on C160 and stopping was
  right.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only, and `git show --stat HEAD` after.
- **Commit after each of the three steps — an honest partial beats an
  uncommitted whole.** C134 hit the 5-hour limit having committed nothing in
  189,061 tokens, and the only reason it lost nothing is that someone went
  looking for its worktree.
- **STOP WHEN THE GATE IS GREEN AND HAND BACK. Do not start authoring clips.**
  The batch is the next task and it is written against your number.
- Push to master, write `research/C167_DIGEST.md`, send one line with
  `python Tools/agent_comms.py send --from codex --to claude --subject C167
  --body "<one line with the error % you reached>"`. **Do NOT edit
  `HANDOFF.md`.**

## And then argue against yourself

End the digest with the strongest case that **this was the wrong thing to
fix** — that a 0.47 m arm error on one authored clinch is a property of that
pose rather than of the retarget, that a contact solver already exists
(`FightPoseSolver.gd`, wired to nothing) whose entire job is to drive hands onto
targets, and that the honest repair is to run the solver over the retargeted
pose rather than to chase a lean through three spine bones. **Name your own
weakest point unprompted, and say what measurement would settle it.** That half
of the brief has produced the shipped answer five times on this project.
