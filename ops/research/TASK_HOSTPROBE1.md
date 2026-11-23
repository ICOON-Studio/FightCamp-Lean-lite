# TASK HOSTPROBE1 - host your own club show: code check of map v4, then the greybox probe (S539)

Model: claude-opus-5-5 (Code Mode tab, owner's subscription; Fable allowance nearly spent). Discipline: boxing (demo). Board row
HOSTSHOW1. Nothing under scripts/ changes.

## Why
HOSTSHOW1 v4 (ops/research/DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI.md, S463) scored John 7/7 and Dola 8/8 - but it was written
from the critic pack, not the code, and the owner's S534 order is: probe the lever on a greybox FIRST, then two fresh critics at
8+ DEPTH and 8+ PLAY, then build (ops/research/DEPTH_SCOPE_S534.md: five maps passed at 7+ and failed when measured). The code has
moved since S463 (e.g. CoachMarket/CoachFit removed S538, favours, the ask door, the ladder).

## Do
1. CODE CHECK: open every **CODE** claim in the v4 map (ClubShow.EVERY_DAYS, member_limit, Region.rankings, Career.favours, the
   region show dates, BoutRead.band, ...) at today's tree; write a table in docs/HOSTPROBE1_RESULT.md: claim / file:line / true,
   partial, false, gone. A claim that is gone becomes NEW in the probe.
2. GREYBOX: tools/hostprobe1.gd (+ tools/hostprobe1_rules.gd scratch copy of what the map adds; the game's own rule modules for
   everything that exists: bouts, money, rank, members). Bots: one per route in map section 5, plus a lazy bot (Community hall, as it is,
   no reserves). Population: the TEST CLUB's boxers and the young / mid / grown clubs of section 9, many seeds, a bout's dice on the fight day.
   Bars: section 9 of the map, written into the result BEFORE the run and not loosened, plus the audit bars every probe now carries:
   no option the one answer in more than 6 of 10 cells; every option right in at least one cell; best beats laziest by $1,000 or 3
   reputation or 3 in 100 pro offer in at least half the cells. Choices worth less than the cut rule are listed as CUT.
3. Result: PASS/FAIL per bar, the decisions that are real, the ones that are solved or worthless (cut list), and what to change
   (FREE HAND, owner S534: remove, add, interconnect). If it passes, write ops/research/CRITIC_HOSTSHOW1_V5_BRIEF.md (opens with
   ops/research/CRITIC_PACK.md + CRITIC_ACCESS.md, never an earlier score; DEPTH / PLAY / GENERAL /10; reads the code and the probe;
   ordered list to reach 10 and a drawn 10/10 page via tools/render_mockup.py) and queue it to kalli and dola with
   `python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_HOSTSHOW1_V5_BRIEF.md`.

## Prior research
The v4 map and its critics (DESIGN_HOSTSHOW1_V4_CRITIC_*_*.md); docs/TURNPROBE14_RESULT.md (probe shape to copy);
`python ops/Tools/prior_research.py host club show favour hall`; memory feedback_probe_population_and_dice_s533.

## What would a human do?
A club secretary books the hall he can fill, asks the clubs that owe him, and keeps a spare boxer on the bench for the week of pull-outs.

## Prefab check
None (a probe of our own rules).

## Contract
OWNS: tools/hostprobe1.gd, tools/hostprobe1_rules.gd, docs/HOSTPROBE1_RESULT.md, ops/research/CRITIC_HOSTSHOW1_V5_BRIEF.md
RED_TEST: tools/hostprobe1.gd (a probe)
REGRESSION: none (no game file changes)
VISUAL: no

## Rules
Work in main. Godot ONLY via `python ops/Tools/godot_slot.py run --who hostprobe1 -- <godot> --headless --audio-driver Dummy
--path . --script res://tools/hostprobe1.gd -- ...`, one run at a time (other probes are running); long output to a file under
E:/FightCamp/tmp/hostprobe1/, wait on its done line (memory feedback_long_probe_output_to_file_s533). Read
ops/research/GDSCRIPT_TRAPS.md. No script over 500 lines. Commit only your paths (`git add -- <new>` then `git commit -m ... --
<paths>`), end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push. When done run
`python ops/Tools/idle_guard.py ok HOSTPROBE1-done`, report in two lines, stop.
