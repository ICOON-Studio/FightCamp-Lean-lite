# TASK COACHHIRE1 - is hiring a better pads coach a real choice? Probe, then wire it or delete it (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo). Board row PROGBUILD1.

## Why
docs/SIGPACE1_RESULT.md: with today's pads coach no boxer reaches a Signature move in two seasons (0/60); with a pads-75
coach 15-20% do, median week 52. scripts/rules/CoachMarket.gd (127 lines) and CoachFit.gd (216) exist but no other script
calls them (unwired). Owner S534 FREE HAND: a mechanic stays only if it can reach 8 depth / 8 play; Claude may remove, add
or interconnect. Owner S534 order: probe the lever on a greybox FIRST, then critics, then build.

## Do
1. Read CoachMarket.gd, CoachFit.gd, docs/SIGPACE1_RESULT.md, docs/HOLD1_RESULT.md, ops/research/DEPTH_SCOPE_S534.md and how
   the game pays coaches today (scripts/state/GymBills.gd, the first coach $450/week in CLAUDE.md "Decided numbers").
2. Greybox probe (tools/coachhire1_probe.gd, a flagged local copy of the hire rule, nothing under scripts/ changed):
   three arms over two seasons, 60+ careers each, fighters all differ: keep today's coach / hire a pads-75 coach at a real
   wage (find the wage in CoachMarket or research/topics; say where it came from) / hire later (week 26). Measure gym cash at
   week 104, Signature share, wins, members. Bars fixed BEFORE the run: the hire is a choice when no arm wins on every
   measure in every cell (gym size small / full), the cash gap is larger than its error, and the timing matters.
3. Verdict in docs/COACHHIRE1_RESULT.md:
   - PASS: write the wiring plan (which screen hires, which numbers show, a table of menus and what each is wired to) as
     ops/research/DESIGN_COACHHIRE1.md, plus ops/research/CRITIC_COACHHIRE1_BRIEF.md (opens with ops/research/CRITIC_PACK.md +
     CRITIC_ACCESS.md; depth and play /10; the list to reach 10). Queue it: `python ops/Tools/seat_queue.py add --seat kalli
     --brief research/CRITIC_COACHHIRE1_BRIEF.md`. Do NOT wire it.
   - FAIL: say so; the result page lists the deletion (CoachMarket.gd, CoachFit.gd and their tests) as the next step for
     Claude. Do not delete them yourself.

## Prior research
docs/SIGPACE1_RESULT.md, docs/HOLD1_RESULT.md, ops/research/DEPTH_SCOPE_S534.md; `python ops/Tools/prior_research.py coach hire pads`.

## What would a human do?
A small club owner hires a better pads coach when he has a boxer worth the money, and not a week before.

## Prefab check
None.

## Contract
OWNS: tools/coachhire1_probe.gd (new), docs/COACHHIRE1_RESULT.md, ops/research/DESIGN_COACHHIRE1.md,
ops/research/CRITIC_COACHHIRE1_BRIEF.md
RED_TEST: none (measurement)
REGRESSION: none (nothing under scripts/ changes)
VISUAL: no

## Rules
Work in main (read-only on scripts/). Godot ONLY through `python ops/Tools/godot_slot.py run --who coachhire1 -- <godot.exe>
--headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/coachhire1_probe.gd`; long output to a file. No
script over 500 lines. Commit only your paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
