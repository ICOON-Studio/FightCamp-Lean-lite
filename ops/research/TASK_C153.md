# TASK_C153 - the capsule set for the contact solver

Model: **gpt-6-astra**, MEDIUM effort. You own C153. This file is
self-contained: read it and the files it names, nothing else. Do NOT read
`HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do
not explore the repo to "get oriented".

**THIS IS A DESIGN TASK AND YOU WRITE NO `.gd` FILE.** One markdown deliverable.
You cannot boot Godot in this environment and you do not need to.

## WHY YOU

This is procedural assembly and structural alignment: two humanoid assemblies
that must be positioned against each other so declared parts touch and no part
interpenetrates, at real-world scale. That is the task, stated in your terms.

## WHAT EXISTS

`Godot/scripts/FightPoseSolver.gd` (~280 lines, read it whole) solves a
two-body pose. It is done and tested. It consumes **capsules**:

    {"name": String, "p0": Vector3, "p1": Vector3, "r": float}   # metres

and a body is `{"caps": Array, "cap_map": Dictionary}`. Contacts are
`{"a": <capsule on body 0>, "b": <capsule on body 1>, "off": <wanted SURFACE
gap, metres>, "w": <weight>}`. Its bounds are `pen <= 0.006 m`,
`touch <= 0.012 m`, `mat <= 0.012 m`.

**Nobody has decided what the capsules ARE.** That is this task.

## THE RIG

22 humanoid bones. Read the exact names off the VALUES of
`FightClipRetarget.UE4_TO_OURS` and off `SILHOUETTE_SEGMENTS`
(`Godot/scripts/FightClipRetarget.gd`, around lines 224-260 for the segment
list) - do not invent or assume names, and do not read the rest of that file.

`Godot/scripts/FighterPhysique.gd` holds `reference_height_m(limit_kg, sex)`
and `height_scale(mesh_h, target_h)`. Read it whole; it is small.

## DELIVERABLE

**ONE new file, `research/C153_CAPSULE_SET.md`, 120 lines at most.**

### 1. The capsule table

One row per capsule. Columns exactly:

    capsule | p0 bone | p1 bone | radius (fraction of stature) | why

- A capsule spans **two bones** (`p0` at one joint, `p1` at the next), except
  where you justify otherwise - the head has no distal bone, so say what you do
  about it.
- **Radius MUST be expressed as a fraction of STATURE, never as an absolute.**
  Two fighters at 165 cm and 191 cm are both mounted through
  `FighterPhysique.height_scale()`, so a fixed radius is wrong for one of them.
  Give the fraction and the resulting centimetres at 175 cm.
- Ground every radius in published anthropometry and **cite the source and the
  number**. A radius you invented is worse than one you left out.
- Say explicitly which of the 22 bones get **no** capsule and why. Fewer,
  well-chosen capsules beat all 22: the solver compares every A-capsule against
  every B-capsule, so cost is quadratic in the count.

### 2. The scale proof - THIS IS THE ONE THAT SINKS THE STAGE IF IT IS WRONG

**The rigs are NOT in metres.** Tripo exports at arbitrary scale and only
`height_scale()` makes them metric. Every bound in the solver is metres, so a
capsule set built in the mesh's native units converges beautifully and means
nothing.

Specify a **check that runs before any solve** and that FAILS LOUDLY: name the
bone pair to measure, the expected value in metres, and the tolerance. Pick a
segment whose real length is well published and which is unambiguous on a
skeleton. State what the check reads if the scale is out by a factor of 100,
so a reader can recognise the failure rather than just see a number.

### 3. The clinch contract

The first hold to be solved is a **standing clinch** - both men upright, in
contact. Give the `contacts` array for it: which capsule pairs, what surface
gap, what weight. Justify each pair from what a clinch physically is.

- `off` is a **SURFACE** gap. `off: 0.0` means touching. **Do not author a
  centre-to-centre distance** - a draft that did this asked for 0.23 m of
  interpenetration and its solver "succeeded" by burying one man in the other.
- Name any pair that must be EXCLUDED from the penetration term because a real
  clinch legitimately compresses it, and say how you would express that.

### 4. Risks

At most five lines. What would make this capsule set wrong, and what would show
it.

## POPULATION - THE PROJECT RULE THAT BINDS EVERY FIXTURE

**NEVER TEST IDENTICAL FIGHTERS.** Any example you work must be two DIFFERENT
bodies - different stature and different mass. Use the two the instruments
already use: `f01_m_box_welter_rigged` and `f02_m_box_heavy_rigged`. State
their stature in your own worked numbers.

## TEST TIER - NONE

You touch no `.gd`, so there is **no parse gate and no test**. `git status -s`
before staging is the whole check. Do NOT run `run_tests.py` - it costs forty
minutes, and a stage gate is currently active in this checkout that will refuse
it anyway.

## OWNED FILES

- `research/C153_CAPSULE_SET.md` (new)

Nothing else. If a second file changes you have gone outside the task.

## FINISH

You are on the MAIN checkout, which is shared: run `git status -s` FIRST,
another session's work may be pre-staged. Stage explicit paths only
(`git add -- <file>`), never `git add .`, and never stage anything under
`AgentComms/` or `audio_exports/`. Push `master`. Then ONE line:

    python Tools/agent_comms.py send --from codex --to claude --topic c153-ready --body "<hash>, <n> capsules, scale check = <one phrase>"

Do NOT edit `HANDOFF.md`.

## THE ONE TRAP SPECIFIC TO THIS TASK

**A radius is not a bone length.** The solver's capsule is a swept sphere: `r`
is the limb's half-THICKNESS, and the segment `p0->p1` is its centre line. If
you give a radius derived from limb length, every gap in the game is wrong and
every pose will read as interpenetrating no matter what the solver does.
