# TASK HOSTPROBE2 - club show map v5 from HOSTPROBE1's section 7, then probe it again (S539)

Model: claude-opus-5-5 (Code Mode tab, owner's subscription). Discipline: boxing (demo). Board row HOSTSHOW1. Nothing under
scripts/ changes.

## Why
HOSTPROBE1 (docs/HOSTPROBE1_RESULT.md, d893ce13d) FAILED map v4 at 2 of 10 bars: the Town hall, Harder week and the outside
novice are always right; the promise has no price; the weight section answers a rule amateur shows no longer use; the printed
rank number ignores stoppages; 2 of 3 classes have no legal name above at the pro chase. Owner (typed in the HOSTPROBE1 tab,
S539): "Apply the section 7 changes and run HOSTPROBE2". Bar (owner S534): probe first, then two fresh critics at 8+ DEPTH and
8+ PLAY. FREE HAND (S534): remove, add, interconnect.
Reference worth reading (owner pasted MMA Empire's new patch notes, S539): its official weigh-ins (a miss -> the opponent
accepts, asks a replacement or cancels) and backup fighters (reserved at booking, step in after an injury or one missed weight
if eligible). Compare, in our own words, with the map's reserves and pull-outs; take an idea only if the probe says it is a
real choice.

## Do
1. Write ops/research/DESIGN_HOSTSHOW1_V5.md: v4 with every section 7 item of HOSTPROBE1 done (one built favour; the promise
   priced by the delayed pro call and shown on the tile; hall reach on the club part only; weight section cut; skills bout,
   door price, move down, ladder swap cut; boxers-sell priced from PadWeek; a legal name above via Newcomers or the tile drops;
   rank printed with stoppages or as a band). Every CODE claim with file:line read today. Keep the table of every menu and what
   it is wired to.
2. tools/hostprobe2.gd (+ rules copy) from tools/hostprobe1*: same population, dice and bars as HOSTPROBE1 section 9 plus the
   audit bars, written in the result BEFORE the run, not loosened. Use the game's built pull-out rate (FightWeekEvents.gd:5).
3. docs/HOSTPROBE2_RESULT.md. PASS -> write ops/research/CRITIC_HOSTSHOW1_V5_BRIEF.md (opens with CRITIC_PACK.md + CRITIC_ACCESS.md,
   never an earlier score; DEPTH / PLAY / GENERAL /10; reads the code and the probe; ordered list to reach 10 + a drawn 10/10 page
   via tools/render_mockup.py) and queue kalli and dola (`python ops/Tools/seat_queue.py add --seat <seat> --brief
   research/CRITIC_HOSTSHOW1_V5_BRIEF.md`). FAIL -> section "what to change" and stop.

## Prior research
docs/HOSTPROBE1_RESULT.md (all of it), ops/research/DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI.md, tools/hostprobe1*.

## What would a human do?
Book the hall the club can fill, ask the clubs that owe it, keep a spare boxer on the bench.

## Prefab check
None (a probe of our own rules).

## Contract
OWNS: ops/research/DESIGN_HOSTSHOW1_V5.md, tools/hostprobe2.gd, tools/hostprobe2_rules.gd, docs/HOSTPROBE2_RESULT.md,
ops/research/CRITIC_HOSTSHOW1_V5_BRIEF.md
RED_TEST: tools/hostprobe2.gd (a probe)
REGRESSION: none (no game file changes)
VISUAL: no

## Rules
Work in main. Godot ONLY via `python ops/Tools/godot_slot.py run --who hostprobe2 -- <godot> --headless --audio-driver Dummy
--path . --script res://tools/hostprobe2.gd -- ...`, one run at a time; long output to E:/FightCamp/tmp/hostprobe2/, wait on its
done line. Read ops/research/GDSCRIPT_TRAPS.md. No script over 500 lines. Commit only your paths, push. When done run
`python ops/Tools/idle_guard.py ok HOSTPROBE2-done`, report in two lines, stop.
