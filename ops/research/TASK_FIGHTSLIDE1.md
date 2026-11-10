# TASK FIGHTSLIDE1 - QWEN (qwen3-coder) - the boxers slide in the fight: measure where and what moves them. Measure only

Status: OPEN (S419, Claude main). Discipline: boxing. Model: qwen3-coder. Animation item (operator S401).
Source: the operator after watching a fight, 2026-11-10: "the fighters are sliding a lot in the fight, i am assuming there are missing animations like sidestep etc ?". This task answers that with numbers. It changes NO game code.

## Contract
OWNS: tools/fight_slide_probe.gd, docs/FIGHTSLIDE1_RESULT.md
RED_TEST: tests/ring_feet_test.gd -> (its pass line; no game file changes, this stays green)
REGRESSION: ring_feet_test, boxer_footwork_test, foot_plant_test
VISUAL: no

## Prior research
- docs/ANIM_REBUILD_DESIGN.md section 1.2, pairs 13 to 16: FIVE systems write a boxer's floor position (Footwork.walk, PunchRange.close_in, SideStep.tick, Clinch._process, PushOff.step), RingPlace composes and pushes it out, and PunchReach adds a lunge; BoxerFootworkRig, FootPlant and KneeTrack all solve the legs. Read the note at the top of that file: its line numbers are from 11-07, check them.
- scripts/fight3d/SideStep.gd header: an earlier probe (tools/sidestep_probe.gd) found the game's short strafe slid planted feet 2.3 m in 0.6 s.
- tools/owned_mocap_measure.gd: the rule for a planted foot (the ball within 2.5 cm of the floor, slower than 0.25 m/s, at least 0.2 s) and tools/owned_mocap_jitter.gd's SLIDE read. Reuse them.
- Step clips that exist: advance, retreat, strafe_left, strafe_right, rk_step_in, rk_step_back, rk_loc_in / back / left / right, rk_walk_*. So "missing animations" is one hypothesis; "the root is moved while a foot is planted" is the other.
- ops/research/GDSCRIPT_TRAPS.md. tests/head_aim_test.gd for how a FightStage is built headless and read on Skeleton3D.skeleton_updated.

## What would a human do?
Watch one foot. While it is flat on the canvas it must not travel. When it does, look at what the body was doing: stepping (a clip with a step in it), being carried without a step, or between two clips. Count the metres in each case.

## Prefab check
None: our own stage.

## The job: tools/fight_slide_probe.gd
Headless. Play three full rounds of a live fight the way the game plays them (the game's own beat list through BeatFire, switches as_game; two different legal boxers, mh_boxer_10 against mh_boxer_12, then swapped), 30 fps, final pose read on skeleton_updated.
1. THE RULER FIRST, two controls that must read as expected or the rest is void: a boxer standing in guard with no beats for 10 s reads under 1 cm of slide per plant; the same boxer with the root moved 0.5 m sideways by hand over 0.5 s, feet untouched, reads about 0.5 m.
2. For every plant of each foot: how far the ball of the foot travelled over the canvas while planted. Per round and per boxer: plants, metres slid in total, the worst single plant, the share of plants over 3 cm and over 10 cm.
3. ATTRIBUTE every slid centimetre. On each frame of a sliding plant record: the clip playing and its time, which writer changed the boxer's floor position that frame and by how much (instrument by reading each system's own output, or by switching them off one at a time with the game's switches in separate runs), and whether a leg solver (FootPlant, BoxerFootworkRig) was holding that foot.
4. THE TABLE the operator's question needs, slide in metres per round, by cause:
   - a step clip is playing and the foot still slides (the clip's stride does not match the distance covered: say the clip's own travel against the distance asked);
   - the root moves with NO step clip playing (carried in guard, in a punch, in a reaction, in a clinch, in a push-off, on the rope clamp): which system, how many metres;
   - at a join between two clips (the first 0.3 s after a cut);
   - sideways movement in particular: how many metres of sideways travel happen per round, and how many of them are covered by a sideways step clip.
5. docs/FIGHTSLIDE1_RESULT.md: the two controls, the tables, then five plain sentences: how many metres a boxer slides in a round, the three biggest causes with their share, whether sideways travel has a clip, which single change would remove the most slide, and what was NOT measured. No fix.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/fight_slide_probe.gd` (never the console build). No file over 500 lines. scripts/ and tests/ are out of bounds. No he or she in the result text.

## The one trap
A plant read before the leg solvers have run is not what is drawn: read on skeleton_updated, and print for each control what it read. S411: a "half the travel is lost" finding was a probe reading outside skeleton_updated.

## Result lines (PR body)
RESULT: tests/ring_feet_test.gd -> (its pass line)
RESULT: tests/foot_plant_test.gd -> (its pass line)
