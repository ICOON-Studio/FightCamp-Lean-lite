# TASK THURSDAY1 - QWEN (qwen3-coder) - how many real problems does a camp week throw up by Thursday? Measure only

Status: OPEN (S425, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the week design (ops/research/WEEK_DESIGN_V2_S425.md) gives the player ONE change on Thursday, picked among the
problems the week has shown him (something the tape opened on the opponent, a habit seen in sparring, the weight off its
line). Both critics: this only works "if most camp weeks open at least two real, non-obvious problems"; otherwise it is a
lookup or an empty stop. Nobody has counted. This task counts, in the game as it is. It changes no game file.

## Contract
OWNS: tools/thursday_probe.gd, docs/THURSDAY1_RESULT.md
RED_TEST: tools/thursday_probe.gd -> THURSDAY camps=40 (measure only; change no game file)
REGRESSION: golden_path_test (the probe changes no game file; this proves the career still runs)
VISUAL: no

## The job
1. Read tests/golden_path_test.gd for how a career is started, a bout booked, a camp run day by day and a fight played
   headless (Career.quick_start, Sim.step_day, Bouts). Reuse those calls; invent no shortcut that skips the week.
2. Run 40 camps (different seeds; Lucy from the quick start; the coach's default week; Standard camp; the bouts the game
   offers). On every THURSDAY of a camp week (and of the two weeks before the first camp, as "quiet weeks") record:
   a) TAPE: did film / tape study open a tell on the opponent this week, and does she already own (mastery 30+) the plan
      answer that tell calls for? A problem = a tell opened whose answer she does not own.
   b) HABIT: does she carry a habit the coach could work on (HabitFix / habits on the fighter), and was it seen this week
      (a sparring night ran)? A problem = a habit present and a sparring night this week.
   c) WEIGHT: her weight against the line the cut needs for the weigh-in. A problem = more than 0.3 kg behind the line.
   d) TIREDNESS: the week's peak against the overtired line. A problem = within 5 of it.
   e) CARD: a drill card that will not be usable by the start of taper at this week's pace. A problem = at least one.
   For each, read how the game computes it (grep the rule module; say in the result which function you read). Where the
   game has no such thing, write "the game has no <x>" in the result and count it as never.
3. Print one line per Thursday: `THU camp=<n> week=<k> days_to_bell=<d> tape=<0/1> habit=<0/1> weight=<0/1> tired=<0/1> card=<0/1> open=<sum>`.
4. docs/THURSDAY1_RESULT.md: the table of how many Thursdays had 0, 1, 2, 3+ problems open, for camp weeks and for quiet
   weeks separately; which problem appears most and which never; how often the SAME problem is the only one open (a
   lookup); then five sentences: is "one change on Thursday" a real choice in today's game (two or more open in at least
   half the camp weeks), what would have to exist for the quiet week, and what you could not measure.
   Never bend a threshold to get a nicer table; report the thresholds above.

## Prior research
ops/research/WEEK_DESIGN_V2_S425.md (the Thursday section), tests/golden_path_test.gd, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach on Thursday looks at four things: what the tape showed, what sparring showed, the scale, and how tired she is.
The probe looks at the same four plus the cards.

## Prefab check
No asset or library applies: a count on the game's own career.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tools/thursday_probe.gd -- 40` (never the _console.exe).
RESULT lines for the PR body: `RESULT: tools/thursday_probe.gd -> THURSDAY camps=40 camp weeks with 2+ open <x>%`.
