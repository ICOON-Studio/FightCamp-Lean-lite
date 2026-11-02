# TASK U179 - CURSOR - WHICH 3D PROP SHOWS EACH CATALOGUE STATION (queued; launch after U178 is collected)
Owner: cursor. Assigned 2026-09-26 (post-S82). Model: Composer, medium, `-p --force --trust`. Branch `cursor/u179-prop-census`.

## Why
Operator, 2026-09-26: "i want the equipment that you buy be accurately shown on the floor". The training floor design
(`research/TRAINING_LOOP_DESIGN.md`; page https://claude.ai/artifact/EvCjFQjxSKjyMiRuUaDd5P) draws every item the
player owns at its floor-grid cell. `Godot/assets/data/equipment_catalog.json` has 25 items with footprints and no 3D
model. We own `Godot/assets/vendor/polyronin_old_school_gym/old-school-gym-equipment-1.fbx` (27 props on one palette,
manifest status placeholder) and the Marpa arena ring and cage (`Godot/assets/venues/mma_arena/`, approved).

## What would a human do?
A technical artist handed a catalogue and an asset pack opens the pack, lists every mesh with its real size, and pairs each
catalogue line with a mesh of the right thing and footprint - marking honestly which lines have no match, which could have
a quality-tier variant (worn vs new) and which only look right from far away.

## The work
1. Load the FBX headless, list every mesh node with its bounding box in metres (check the unit - some packs are not in
   metres).
2. Table: catalogue id, footprint (cells), matched mesh (or NONE), mesh size vs footprint, verdict (FITS / RESCALE / NO
   MATCH), and whether a tier variant is possible from the pack.
3. Render one contact sheet of the matched props on a 1 m grid through `Tools\godot_hidden.ps1`.
4. For each NO MATCH item, suggest a CC0 source (Poly Haven, ambientCG, Kenney, Quaternius) - links only, download nothing.

## Owned files
`Godot/tools/u179_prop_census.gd`, `research/U179_PROP_CENSUS.md`, `previews/u179/`. No game code.

## Tier
Parse gate on the tool; no tests. Commit after each step.

## Research
All research is open: root `RESEARCH_INDEX.md`. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit, push, `python Tools/agent_comms.py send --from cursor --to claude --topic U179 --body "<FITS n / RESCALE n / NO MATCH n>"`.

## The trap
A mesh that fits the footprint but is the wrong thing (a bench standing in for a physio table) is NO MATCH, not FITS.
