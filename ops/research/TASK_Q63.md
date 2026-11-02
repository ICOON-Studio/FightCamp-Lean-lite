# TASK Q63 — QWEN — THE THIRTEENTH FIGHTER: WHAT MADE THE TWELVE, AND WHAT A GI COSTS

Model: qwen3-coder, **medium effort**. Owner: qwen.
Test tier: **RESEARCH plus ONE THROWAWAY INSPECTION SCRIPT. NO SHIPPED `.gd` IS
EDITED, NO TEST IS TOUCHED.** Parse gate the script if you write GDScript; a
plain Python script needs no gate. **Do NOT run the full suite. Only one Godot at
a time in this checkout** — and prefer plain Python, which needs no Godot at all.

## Owned files

- `research/Q63_THE_THIRTEENTH_FIGHTER.md` — **NEW. Yours alone.**
- `Godot/tools/inspect_fighter_glb.py` — **OPTIONAL, NEW, yours alone.** Plain
  Python. A `.glb` is a 12-byte header, a JSON chunk and a binary chunk; you can
  read everything this task needs with `json` and `struct` and no engine.

Nothing else. Do **NOT** edit any `.glb`, any script under `Godot/scripts/`, any
test, or `HANDOFF.md`. `GameState.gd` is 12,938 lines — you do not need it,
never open it. **THIS TASK REPORTS. IT DOES NOT GENERATE OR IMPORT ANYTHING.**

## Why this exists

The operator wants a **karateka in a white gi** and a **muay thai fighter with
the cords** — the prajioud armbands and the mongkol headband. Neither exists.

The obvious answer was to buy a character pack. **Inspecting our own fighters
made that look second-best**, and this task is to establish whether the better
answer is real.

**What was found by parsing `f01_m_box_welter_rigged.glb`:** one mesh of ~11,400
vertices, **ONE material**, three 2048×2048 textures (`Color`, `ORM`,
`NormalGL`), 23 nodes, 1 skin — and the mesh and material are still named
`tripo_mesh_…` / `tripo_material_…`. **The twelve fighters were made with Tripo,
an AI 3D generator.**

Two consequences:

1. **There is no garment to swap.** Gloves, shorts and body are one object under
   one material, so clothing customisation has no seam to build on, and a gi
   cannot be painted on because a gi is a SHAPE — lapels, hanging sleeves, a
   knotted belt. M16 already measured that the whole-body silhouette is what
   survives at small scale while the face and gloves read as dead, so the
   silhouette IS the discipline signifier.
2. **But if the twelve were generated, a thirteenth can be.** That route needs no
   Unity — which matters, because Unity is **not installed** on this machine and
   the Asset Store offers only "Open in Unity"; we have already bought a pack
   whose file has never existed on our disk.

**Your job is to establish what generating a thirteenth fighter would actually
take. Not to generate one.**

## THE QUESTIONS - FIVE HERE, PLUS A SIXTH ADDED UNDER "RULES" BELOW

### 1. WHAT IS THE EXACT SHAPE OF THE TWELVE?

Parse all twelve `.glb` files in `res://assets/models/fighters/` and report, per
file: mesh count, material count, image count and their names and sizes, node
count, skin count, vertex and triangle count, and the names of the top-level
scene nodes. **Say whether all twelve share the same structure** — same bone
names, same node layout, same texture set — **or whether they differ**, and where.

This is the row that decides everything downstream: if all twelve are structurally
identical, a thirteenth has a template. If they drift, it does not.

### 2. WHAT IS THE SKELETON, EXACTLY?

List the bone names and the hierarchy from the `skins` and `nodes` arrays.
Compare against what the retarget path expects: `FightClipRetarget.UE4_TO_OURS`
maps the vendor's UE4 Mannequin rows onto ours. **Read
`Godot/scripts/FightClipRetarget.gd` — it is small enough to read whole — and
report our 22 mapped rows against the bones actually present in the `.glb`.**
Any bone the map names that a fighter does not have, or vice versa, is a finding.

### 3. WHAT DOES A NEW FIGHTER COST IN RETARGET WORK?

R111 recorded, standing: **"Corrections are PER FIGHTER, not per pack."** So a
thirteenth body needs its own correction set built against the vendor reference
pose before any bought clip plays on it.

Read `FightClipRetarget.build_corrections` and say, in plain terms: what inputs
it needs, what it produces, and **whether a new fighter with the same skeleton
would need anything beyond running that function** — or whether a gi's different
proportions (bulkier torso, sleeves) would break the assumptions. Label it
DOCUMENTED where the code says so and INFERENCE where you are reasoning.

### 4. IS THERE ANY RECORD OF HOW THE TWELVE WERE GENERATED?

Search `research/` for the pipeline: prompts, settings, a tool, a task file,
a digest. `R76`, `R77`, `R78` and `C58_THE_TWELVE_SEEN.md` are known to touch the
fighters; **`R78_RETEXTURE.md` documents re-baking one fighter's surface and is
the closest thing to a worked pipeline we have.** Report what is actually
recorded — the generator's name, any prompt or setting, the export format, the
rigging step — and what is **NOT FOUND**. Do not infer a pipeline that is not
written down.

### 5. WHAT WOULD THE GI AND THE CORDS ACTUALLY NEED?

Given questions 1–4, say what a karateka in a white gi requires as GEOMETRY, and
what muay thai prajioud armbands and a mongkol require. **These are different
sizes of problem** — a gi changes the whole silhouette; armbands and a headband
are small additions — and the report should say so plainly rather than treating
them as one ask. State whether the small ones could be separate meshes parented
to existing bones (which the rig may already allow) or whether they too need to
be part of the single generated mesh.

## RULES FOR THE ANSWER

**LABEL EVERY CLAIM**: `MEASURED` for anything your script printed, `DOCUMENTED`
for anything the repo or the engine documentation states, `INFERENCE` for your
reasoning, `NOT FOUND` for what you could not determine. You did this correctly
on Q54–Q58 and it is why this task is yours.

**DO NOT GENERATE ANYTHING AND DO NOT CALL ANY EXTERNAL SERVICE.** The report
says what it would take; somebody else spends the credits.

**TRIPO ACCESS IS CONFIRMED AND IT HAS A CLOCK ON IT (operator screenshot,
2026-09-11): the account holds 200 credits on the Free plan, and they EXPIRE
2026-10-01.** Two loads of +200 are on record, 2026-08-30 and 2026-09-11. So this
is no longer a conditional route — it is a live one with a twenty-day fuse, and
it expires AFTER the 2026-09-14 Unity sale, so both options are open at once.

**THEREFORE ADD A SIXTH QUESTION, AND IT IS NOW THE ONE THAT DECIDES THE
SPEND: WHAT DOES ONE FIGHTER COST IN CREDITS?** Search the repo record
(`research/`, `R76`, `R77`, `R78`, `C58_THE_TWELVE_SEEN.md`) and Tripo's
own published pricing for the credit cost of one generate-plus-rig at the quality
the twelve were made at. Then say plainly: **how many fighters do 200 credits
buy, and is that enough for a karateka AND a muay thai fighter?** If the per-model
cost is not recorded anywhere, say **NOT FOUND** and say what it would take to
find out — do not estimate a number that a spending decision would rest on.

**AND THE Q61 LESSON, WHICH IS YOURS AND IS NOW A RULE.** Q61 was told that if
its control clips disagreed with their known answer the instrument was wrong and
every other row was worthless — report it and stop. The control failed, you found
and named the root cause correctly, **and then drew a verdict from the broken
instrument anyway.** That verdict could not be used. **A failed check voids the
finding; it does not caveat it.** Here the equivalent is question 1: if the twelve
are NOT structurally identical, say so and say what that breaks, rather than
reporting a template that does not exist.

## Done means

- `research/Q63_THE_THIRTEENTH_FIGHTER.md` written, with the twelve-file
  structure table first.
- `git status -s` FIRST (another agent's WIP may be pre-staged), then
  `git add --` your explicit paths only. Never `audio_exports/`, never a `.glb`.
- Commit ending `Co-Authored-By: Qwen <noreply@qwen.ai>`, then
  `git push origin master`.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q63-done --body "<hash> fighters=12 identical=<yes|no> bones=<n> pipeline_recorded=<yes|no|partial>"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## GDScript traps, if you write any

- `var x := <call>` fails when the call returns Variant — write the type.
- A `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error even across
  separate `if`/`for` blocks.
- Parse gate BEFORE any run; a parse error HANGS a headless run for 600 s.
- Use only
  `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe`.
  **But prefer plain Python for this task — none of it needs an engine.**
