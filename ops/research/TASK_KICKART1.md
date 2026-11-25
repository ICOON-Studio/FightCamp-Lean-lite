# TASK KICKART1 - where the kick, knee and elbow animations come from (S559, research only)

Kind: research. Model: claude-opus-5-5. Discipline: kickboxing (owner S559 "Yes, kickboxer first").
Seat: console worker. Estimate: 1 hour. NO downloads, NO sign-ins, NO Godot runs, NO purchases.

## Why
Owner S559: "should we already start thinking on adding elbows and kicks ? but it has to be done properly by art". The
kickboxing rules page exists (`proto/twohands/kick.html`: teep, low kick, body kick, head kick, check; a caught kick) but
the Lean repo has NO kick, knee or elbow take (a search of assets/anim and assets/models found none). Every Ring Switches
picture is rendered from our 3D MetaHuman bodies (`tools/pics2d_anim.gd`), and a missing take can be AUTHORED offline
(`tools/pics2d_hold_bake.gd`, `tools/pics2d_bodycross_bake.gd`) or bought/generated.

## Find, for each action - teep (lead leg), low kick, body kick, head kick (rear leg), shin check, kick caught (both
## sides), and for later knee, elbow, Thai clinch:
1. Do we already have it? The old repo on GitHub ICOON-Studio/FightCamp (archived; use `gh api` GETs: trees, search) had
   MMA and kickboxing: find its kick/knee/elbow clip files and clip tables (names, source, licence). Also E:\FightCamp
   folders other than Lean and the wt worktrees, E:\FightCamp_backup_D, C:\Users\user\Downloads (names only).
2. Mixamo: the exact clip names for each action (web search; Mixamo's licence for a commercial game).
3. Ludo.ai animation (Griffin, Ignis; memory reference_ludo_griffin_ignis_s555.md), Tripo, Higgsfield (the owner S559:
   "you can use higgsfield for anything you need") - can any make a usable take on OUR skeleton, or only a reference video?
4. Marketplace packs (Fab/Unreal, Rokoko, ActorCore, Unity store) with Muay Thai / kickboxing motion: price, licence,
   retarget path to a MetaHuman / humanoid skeleton.
5. Authoring with our bake tools: which actions are simple enough to author like the holds (a check is a knee lift; a teep
   is a straight leg push), which need real motion capture.
Rule: MetaHuman bodies only, never MPFB or a generated body (memory). Assets ripped from games never ship.

## Output
`ops/research/KICKART1_SOURCES.md`: a table - action | have it? | best source | licence | cost | retarget path | verdict -
then the recommended route in five lines (what to get first for the first slice: teep, low kick, check). Cite every claim
(path or URL); NOT FOUND where it is. Commit it by pathspec and push.

## Contract
- OWNS: ops/research/KICKART1_SOURCES.md
- RED_TEST: none (research)
- REGRESSION: none (no code)
- VISUAL: none

## Prior research
`python ops/Tools/prior_research.py kick mixamo muay thai teep` first; ops/research/topics/kicks_legs.md; Q65_MUAY_THAI_TECHNIQUES.md.

## What would a human do?
An animation lead lists every move, checks the library and the archive, prices the gaps, and buys or authors the cheapest
route that looks right from the side camera.

## Prefab check
This task IS the prefab check.

## Feedback loops
None: research.
