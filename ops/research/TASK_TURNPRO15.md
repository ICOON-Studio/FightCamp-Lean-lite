# TASK TURNPRO15 - map v15: fix the three bars v14 failed (S537)

Model: claude-fable-5-2 (headless on the API credit). Discipline: boxing (demo). Measurement + map only: nothing under scripts/.
Base: ops/research/DESIGN_TURNPRO1_V14.md, docs/TURNPROBE14_RESULT.md (PASS 14/17), tools/turnprobe14*.

## Do
1. Copy the map to ops/research/DESIGN_TURNPRO1_V15.md and the probe to tools/turnprobe15*.gd/.py. Change only what fixes:
   - Bar 15 (the favour works BACKWARDS): the rebel ends +$1,036..1,383 better under the favour; the keeper gains nothing (at
     the ticket house it takes no title shot once favour is 8). Make favour a real trade: high favour must open something the
     keeper takes (title shot / better purse it actually uses), low favour must cost the rebel (worse dates, not a forced kind
     that helps him). Keep it plain, what a real promoter does.
   - Bar 4 (card honesty, worst boxer -8.4..-12.1 from own nights): the debut card must read the boxer's own nights.
   - Bar 10 (name-chaser lead 2.3..2.8, bar 3+): small number change, not a new layer.
   Bars and their lines are fixed BEFORE the run, the same 17 (do not loosen any).
2. Run the probe ONE batch at a time through `python ops/Tools/godot_slot.py run --who turnpro15 -- <cmd>`, output to a file.
3. docs/TURNPROBE15_RESULT.md in the v14 page's shape. If PASS with every audit bar: write ops/research/CRITIC_TURNPRO1_V15_BRIEF.md
   (opens with ops/research/CRITIC_PACK.md + CRITIC_ACCESS.md; depth and play /10; the list to reach 10; one critic code-checked)
   and queue it for Kalli: `python ops/Tools/seat_queue.py add --seat kalli --brief research/CRITIC_TURNPRO1_V15_BRIEF.md`.

## Prior research
docs/TURNPROBE14_RESULT.md sections 1, 2, stage F, The bars; ops/research/DESIGN_TURNPRO1_V14.md.

## What would a human do?
A promoter rewards the trainer who takes his fights with the better nights, and freezes out the one who refuses.

## Prefab check
None.

## Rules
Godot only through godot_slot. No script over 500 lines. Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd,
tools/export.sh. `git add -- <new>` then `git commit -m ... -- <your paths>` with `Co-Authored-By: Claude Opus 5.5
<noreply@anthropic.com>`, push, report in two lines, stop.
