# TASK FIGHTSLIDE2 - QWEN (qwen3-coder) - the fighters slide: measure each cause by switching it off. Measure only

Status: OPEN (S420, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator, playing S419's build: "the fighters are sliding a lot in the fight". Round 1 (FIGHTSLIDE1, on main:
tools/fight_slide_probe.gd, docs/FIGHTSLIDE1_RESULT.md) measured about 1.5 m of foot slide per boxer per round, but its causes
are guesses and its ruler cannot see a fast slide.

## Contract
OWNS: tools/fight_slide_probe.gd, docs/FIGHTSLIDE1_RESULT.md
RED_TEST: tools/fight_slide_probe.gd -> CTRL2 about 50 cm (measure only; change no game file)
REGRESSION: beat_clips_test (the probe changes no game file; this proves the fight still loads)
VISUAL: no

## The job
1. THE RULER: a planted foot is one the ANIMATION plants (the clip's own foot, measured in the clip's local frame by FK, near
   still), not one whose world speed is low. Slide = how far that foot moves in the world while the clip holds it planted.
   Control 2 (root pushed 0.5 m sideways in 0.5 s while the clip holds the guard) must now read about 50 cm; control 1
   (guard only) under 2 cm. Print both; if either misses, stop and write why.
2. Same two matches, 3 rounds, as round 1. Then the same with ONE writer switched off at a time (Footwork.walk,
   PunchRange.close_in, SideStep.tick, Clinch._process, PushOff.step, and the rig weight held at 1.0 on rk_ clips): read the
   code for an existing switch first (grep cmdline_user_args in each); add a probe-only flag where none exists, in the probe.
3. A table: cause -> metres slid per boxer-round with it on and off, and the difference. The share column comes from that
   difference, not from a guess.
4. Five sentences under "Round 2" in docs/FIGHTSLIDE1_RESULT.md: the biggest cause with its measured share, and the one
   change that would remove it.

## Prior research
docs/FIGHTSLIDE1_RESULT.md, tools/fight_slide_probe.gd header, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Freeze a planted foot and watch whether the ground moves under it; then turn off each thing that moves the body, one at a time.

## Prefab check
None: our own probe.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines (the probe is 371). No fixed he or she in text.

## Result lines (PR body)
RESULT: tools/fight_slide_probe.gd -> CTRL1 <cm> CTRL2 <cm>
