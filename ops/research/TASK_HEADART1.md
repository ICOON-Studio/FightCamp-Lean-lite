# TASK HEADART1 - where the head-movement animations come from (S559, research only)

Kind: research. Model: claude-opus-5-5. Discipline: boxing (demo path).
Seat: console worker. Estimate: 1 hour. NO downloads, NO sign-ins, NO Godot runs, NO purchases.

## Why
Owner S559, after the Boxing Movement Lab shorts (`ops/research/BML1_MOVEMENT_CATALOGUE.md`: 21 drills, our own words)
and the ghost step short: "do youthinkwe should add the head ?" then "Yes, measure it". `proto/twohands/head.html` adds four
head moves to Ring Switches - slip (his jab / cross miss), roll (under his hook / overhand; an uppercut catches it), lean back
(out of reach at Mid / Long), slip in (a step in with a slip) - and the ghost step (a gliding step: front foot slides first,
then the push off the back leg, no jump) is how our steps should travel. None of these has a picture yet.

## Find, for each move - slip left, slip right, roll under (bob and weave, both ways), duck, lean back (pull), slip in
## (step + slip), the ghost step in / out, a slip-counter (slip then cross) and a roll-counter (roll then hook):
1. Do we already have it? Lean `assets/anim` (rokoko_combat, af_retarget, metahuman, baked, mixamo_walk, entry - clip
   names; `scripts/fight3d/` clip tables such as BeatClips / FightClips / StepPlay TAKES for slips, rolls, ducks, pulls), the
   old repo on GitHub ICOON-Studio/FightCamp (`gh api` GETs: clip tables, `Godot/assets/anim/**`, the bought RamsterZ set,
   Motifect), E:\FightCamp\packs, E:\FightCamp_backup_D, C:\Users\user\Downloads (names only: KICKART1 found 1,031 Mixamo
   FBX there - list the dodge / slip / duck / bob / weave / lean ones).
2. Mixamo exact names (web) for slips, dodges, ducks, bob and weave, head movement.
3. What can be AUTHORED with our bake tools (`tools/pics2d_hold_bake.gd`, `tools/pics2d_bodycross_bake.gd`: a two-bone solve
   a key from the guard) - a slip and a lean back are spine + neck turns with the guard kept; a roll is a knee bend + a
   spine arc; say which need real motion and which a bake can make convincingly from the side camera raised 31 deg.
4. Our own studies on head movement: `python ops/Tools/prior_research.py slip roll head movement bob weave` (the old
   project measured slips and rolls: cite the findings).
Rules: MetaHuman bodies only (never MPFB / a generated body); ripped assets never ship; name every licence.

## Output
`ops/research/HEADART1_SOURCES.md`: a table - move | have it? | best source | licence | cost | how it reaches our body |
verdict - then the recommended route in five lines (what to make first for head.html's four moves + the ghost step).
Cite every claim (path or URL); NOT FOUND where it is. Commit ONLY that file by pathspec (`git commit -- <file>`; never a
folder sweep) and push.

## Contract
- OWNS: ops/research/HEADART1_SOURCES.md
- RED_TEST: none (research)
- REGRESSION: none (no code)
- VISUAL: none

## Prior research
ops/research/BML1_MOVEMENT_CATALOGUE.md; ops/research/KICKART1_SOURCES.md (same method, kicks); docs/RINGANIM1_RESULT.md.

## What would a human do?
An animation lead lists every dodge, checks the library and the archive, prices the gaps, and authors the simple ones.

## Prefab check
This task IS the prefab check.

## Feedback loops
None: research.
