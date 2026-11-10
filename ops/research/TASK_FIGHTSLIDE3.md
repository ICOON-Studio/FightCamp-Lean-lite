# TASK FIGHTSLIDE3 - QWEN (qwen3-coder) - the fighters slide: switch off the five writers FIGHTSLIDE2 skipped. Measure only

Status: OPEN (S422, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator, playing S419's build: "the fighters are sliding a lot in the fight". FIGHTSLIDE2 (on main, c6d4f0ed) gave
a working ruler (CTRL1 1.33 cm, CTRL2 50.38 cm) and a baseline of about 2.7 m slide per boxer-round, and showed the rig weight is
NOT the cause (held at 1.0: 2.89 m, 8% more). The other five writers were never switched off.

## Contract
OWNS: tools/fight_slide_probe.gd, docs/FIGHTSLIDE1_RESULT.md
RED_TEST: tools/fight_slide_probe.gd -> CTRL2 about 50 cm (measure only; change no game file)
REGRESSION: beat_clips_test (the probe changes no game file; this proves the fight still loads)
VISUAL: no

## The job
1. Keep the ruler as it is. Print CTRL1 and CTRL2 first; if CTRL2 is not 45-55 cm or CTRL1 is over 2 cm, stop and write why.
2. Match A only (mh_boxer_10 vs mh_boxer_12), 3 rounds: the baseline, then ONE writer switched off at a time:
   Footwork.walk, PunchRange.close_in, SideStep.tick, Clinch._process, PushOff.step. Read each function first and grep
   cmdline_user_args in its file for an existing switch; where none exists, switch it off from the probe (set the boxer field
   it reads, or replace the call through a probe-only subclass/flag) - never edit the game file. Write in the result which way
   each was switched off.
3. The lead to test: per rk_ clip (rk_jab, rk_cross and every other rk_ clip the fight plays), the clip's own hip travel in the
   skeleton frame while one of its feet is planted (by the same local-stillness ruler). A table: clip -> frames played, hip
   travel cm per planted second, slide cm it carries in the fight.
4. A table: cause -> m slid per boxer-round with it on and off, the difference, and the share (difference / baseline). The six
   rows include the rig row from FIGHTSLIDE2. Bound each share, never claim one exact number.
5. Five sentences under "Round 3" in docs/FIGHTSLIDE1_RESULT.md (keep Round 2 as it is): the biggest cause with its measured
   share, and the one change that would remove it. If no writer's share is over 20%, say so and name the rk_ clip table's top
   three as the lead.

## Prior research
docs/FIGHTSLIDE1_RESULT.md (rounds 1 and 2), tools/fight_slide_probe.gd header, ops/research/GDSCRIPT_TRAPS.md.
FIGHTSLIDE2's trap: it ran out of time after one cause - run the five switched-off matches before writing any sentence.

## What would a human do?
Freeze a planted foot and watch whether the ground moves under it; then turn off each thing that moves the body, one at a time.

## Prefab check
None: our own probe.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines (the probe is 431: move the rk_ clip table into a second file tools/fight_slide_clips.gd if needed, and
add it to OWNS in your PR body). No fixed he or she in text.

## Result lines (PR body)
RESULT: tools/fight_slide_probe.gd -> CTRL1 <cm> CTRL2 <cm> BIGGEST <cause> <share range>
