# TASK STANCEPROBE1 - probe the stance pad on a greybox before anything is built (owner S536 "yes both")

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S536, on his foot-width idea: "would it blend with other mechanics ... like a fine tuner for a fighter that can make in
some way unique ?", then asked whether the chips "really happen and the player can watch it", then "yes both" to this probe.
Bar (owner S534): a lever is PROBED on a greybox FIRST (pass: it moves the result, no pick best in more than 6 of 10 cells,
cells clear of the noise), then two fresh critics at 8+ DEPTH and 8+ PLAY, then build. Nothing under scripts/ in this task.

## The design to probe (mockup docs/mockups/s536/stance.png, Claude's call)
- Feet set in camp on a 3x3 pad: width Narrow / Shoulder / Wide x angle Squared / Half / Bladed. Every cell is a trade, never
  free stats (wide: rear power, slips, stays up + / step speed, pivots - and legs drain +; narrow: the reverse; squared: hooks,
  inside work + / body target bigger; bladed: jab reach, body hidden + / lead hook, rear power -).
- Weight lean Back / Centred / Front = a corner call between rounds (like Gloves high), not a camp setting.
- Each boxer has a NATURAL stance from his frame (height, leg length, style); other cells cost pad weeks to own and, until
  owned, extra stamina and slower steps. In the fight the feet move one step toward his natural only; tired legs and body
  shots pull a wide stance narrower over the rounds; a stance kept every fight is read on tape by rivals (Knowledge).

## Do
1. Read the code first and say where each effect would plug in (file:line): the footwork steps (StepEffect / PlaceEdge /
   StepWire - read only, STEPPAY2 is editing them), the exchange (punch power, slips, knockdowns), legs / stamina, the guard
   v7 WHEN-lines (ops/research/DESIGN_GUARDDMG1_V7.md), Knowledge (the film read). Write `ops/research/DESIGN_STANCE1.md`,
   a map FROM THE CODE: what exists, what is new, the menu table (camp screen, fight plan, corner, fight analysis line,
   the 3D feet), and the MERGE question: should stance and guard v7 be ONE mechanic ("how he stands")? Answer it with
   reasons; the owner allows remove / add / interconnect to reach 8.
2. Greybox probe `tools/stance_probe.gd` (scratch modifiers on a flagged local copy of the exchange inputs - the game's own
   BoutNight / fight night for every bout, as the weight probe does): the 9 cells x a population of real boxers (Data
   prospects, differing in stats - never identical fighters) x opponent styles (out-boxer, pressure, counter-puncher, volume)
   x amateur / pro; 40 seeds a cell, paired dice; print an error per cell and call ties inside the noise.
   PASS (all): every effect moves the result; no stance best in more than 6 of 10 (style x scale) cells; at least 4 cells clear;
   the natural stance is not always best (else the pad is decoration); the corner lean moves a round's result.
   Size each effect from real evidence where it exists (stance studies, coaching sources - tag SOURCED / ESTIMATE), never
   by tuning until it passes. `docs/STANCEPROBE1_RESULT.md`.
3. WATCHABLE (owner: "they really happening and player can watch it ?"): list for each chip what the 3D fight player v2 would
   show (feet spacing at the stance's width - the stance refit; a slow pivot visibly late; slips), and what already exists in
   scripts/fight3d/v2 (StepClips pivots, ChoreoReact slips) vs what is new. No 3D code.
4. PASS -> critic briefs (chat via `python ops/Tools/design_loop.py critic STANCE1 research/DESIGN_STANCE1.md --seat kalli`
   and a code-checked `ops/research/TASK_STANCE1CRIT.md`), not run by you. FAIL -> which effect broke; one resize; a second
   FAIL comes back to Claude.

## Prior research
python ops/Tools/prior_research.py stance footwork guard posture; research/topics/footwork.md; memory S528 (posture = the
corner's Adaptation, check before building a "new" control); DEPTH_AUDIT_S534.md; DESIGN_GUARDDMG1_V7.md; WEIGHT2 probes
(the probe pattern to copy).

## What would a human do?
A coach reads his boxer's natural feet, widens them against a brawler, narrows them against a mover, and in the corner tells
a tired man to sit down on his punches.

## Prefab check
None (a design probe).

## Contract
OWNS: ops/research/DESIGN_STANCE1.md, tools/stance_probe.gd, docs/STANCEPROBE1_RESULT.md, ops/research/TASK_STANCE1CRIT.md
RED_TEST: tools/stance_probe.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who stanceprobe1 -- <command>`. Never stage LineGrade.gd,
LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. Stage explicit paths, commit to main with the Co-Authored-By line, push,
report in two lines, stop.
