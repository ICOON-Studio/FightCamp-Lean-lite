# TASK Q55 — QWEN — HOW YOU FRAME TWO MEN ON THE GROUND

Model: your default, medium effort. Owner: qwen.
Test tier: **RESEARCH — NO `.gd` TOUCHED, SO NO GATE AT ALL.** Not the parse
gate, not a test, not the suite. `git status -s` before staging is the whole
check. **Do NOT launch Godot** — another Godot is running and only one may run
at a time.

## Owned files

- `research/Q55_THE_GROUND_CAMERA.md` — **NEW. Yours alone.**

Nothing else. Do not edit `HANDOFF.md`, `CURRENT_STATUS.md`, `TASKS.md`, any
`.gd` file, or any other research doc.

## Why this exists

We own sixteen **paired** two-body grappling clips — one performance danced by
two bodies, both halves authored in one shared space. R106 proved the relative
alignment survives the trip into Godot. The stage now running is to put **one
pair on screen**, and the machinery for that is being built in parallel.

**Nobody has asked how it is framed.** Every camera this project owns was built
for a man who is STANDING. The title screen's is the only 3D camera we ship:

```
Godot/scripts/BootStage3D.gd:86-88
const FIGHTER_POS := Vector3(-0.40, 0.0, 0.0)
const LOOK_AT     := Vector3(0.0, 1.16, 0.0)   # chest height of a standing man
const CAM_BASE    := Vector3(1.28, 1.36, 3.45) # ~3.7 m out, at his chest
cam.fov = 32.0                                  # BootStage3D.gd:242
```

Point that at a full mount and you get an empty frame with two men in the bottom
eighth of it. **A ground fight happens between 0.0 m and roughly 0.9 m off the
floor and is about 1.6 m long.** From R106's own sampling, in the source's Z-up
metres: the attacker's pelvis sits at **0.411** and the victim's at **0.127**,
and in `Reversal` they swap — 0.411 → 0.127 while the other goes 0.127 → 0.411.

So the subject is short, wide, low, and the thing that must read is **which man
is on top and what he is doing to the other one.**

## THE QUESTION, IN FOUR PARTS

### Q1 — How does broadcast MMA actually shoot ground work? (DOCUMENTED)

Not "what looks nice". What the real production does, with numbers where numbers
are published: camera height off the canvas, distance from the pair, lens/focal
length, and whether the shot is from **outside the cage looking slightly down**,
**at mat level**, or **overhead**. UFC/PFL/ONE broadcast-manual material,
cinematography breakdowns, and published camera plots are all fair sources.

**Say specifically what happens when the fight goes to the ground** — the cut
that broadcast makes at that moment is the whole answer, and it is a different
camera from the standing one.

### Q2 — Convert it to Godot `Camera3D` numbers. (INFERENCE, clearly labelled)

Give me a table I can paste into a script. Assume the pair is mounted at world
origin with **Y up** (our engine; the source clips are Z-up and get rotated),
the floor at `y = 0`, and the pair's long axis along **X**.

| shot | `position` | `look_at` | `fov` | what it is for |
|---|---|---|---|---|

Cover at least: **the establishing ground shot** (the one that reads position),
**the tight one** (the finish — a choke or an armbar, where the face matters),
and **the low mat-level one** if the research says broadcast uses it. Give the
real focal length each `fov` corresponds to at 16:9, and show the arithmetic
once so I can check it.

### Q3 — What does a low camera do to a floor that is a plane? (DOCUMENTED)

The title screen's room is a dark gym with a back wall at `y = 6.0, z = -7.5`
and no real floor geometry to speak of. Drop the camera to 0.4 m and a floor
plane meets the horizon. What do you need — a floor with actual extent, a
horizon-line trick, fog, a mat texture with scale? Answer from Godot 4.x docs
and from how 3D fighting games handle a mat. **Name the Godot node and property,
not just the idea.**

### Q4 — Does the pair need a shadow to sit on the floor, and what kind?

Two bodies in contact on a mat. What makes them look like they are ON the floor
rather than floating a few centimetres above it — and what is the cheapest thing
that achieves it in Godot 4.x (`DirectionalLight3D` shadow, a blob decal,
`Decal` node, SSAO, contact shadows)? **This is the single most common tell of a
fake ground scene, so answer it concretely.**

Note the renderer is **`forward_plus`** project-wide as of 2026-09-11, so
effects that are silent no-ops under Compatibility are available to you.

## HOW TO ANSWER

Label every claim **DOCUMENTED** (with the source), **INFERENCE** (your
reasoning, marked as yours) or **NOT FOUND**. Your Q50/Q51/Q54 labelling was
exactly right and it is why those studies were usable — keep it.

**A NOT FOUND is a real answer and is worth more than a guess dressed up.** Q54's
two NOT FOUNDs (no engine two-player sync, no documented paired root motion)
changed what is being built. Do not pad.

Keep it under ~150 lines. The table in Q2 is the deliverable; the prose is
support.

## Definition of done

- `research/Q55_THE_GROUND_CAMERA.md` exists and answers Q1-Q4.
- `git add -- research/Q55_THE_GROUND_CAMERA.md`, commit, push to master.
- Send one line:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q55-done --body "<sha> <one line: the establishing shot's position/look_at/fov>"`

## The traps specific to Q55

1. **Do not run Godot.** Another Godot process is running and concurrent Godot
   produces false all-failed results. This task needs none.
2. **Do not read `HANDOFF.md`, `CURRENT_STATUS.md` or any digest.** This file is
   self-contained. `BootStage3D.gd` is 350 lines and you may read it whole if you
   want the camera context; nothing else in the repo is needed.
3. **Y is up in our engine, Z is up in the source clips.** Every number you give
   me must be in **our** Y-up frame. Say so explicitly in the table's caption.
4. **Metres, always.** Not "a bit further back". If a source gives feet, convert
   and show both.
