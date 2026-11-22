# TASK KNOWSTAKES6 - knowledge stakes map v6 from the code, then critics (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo). Map only: nothing
under scripts/ changes. Board row KNOWLEDGE1.

## Why
KNOW_STAKES1 v5 (ops/research/DESIGN_KNOW_STAKES1_V5.md) critics: Arena 7/7/7, Dola (see its file) - under the owner's S534 bar
(8 depth, 8 play). The lever is now measured: docs/KNOWMISREAD2_RESULT.md - on a paired ruler knowing the truth is worth +12.1%
more top-10 boxers [5.3..19.6], cash +3.7% [2.2..5.4], bout wins not told from zero; the share is a weak lever (stays 0.5).
Owner S534 FREE HAND: remove, add or interconnect to reach 8.

## Do
1. Read v5, both v5 critics' "to reach 10" lists, docs/KNOWMISREAD1_RESULT.md + KNOWMISREAD2_RESULT.md, and the code the map
   names (scripts/rules/Knowledge.gd, KnowReads.gd, KnowWire.gd, the screens that show ranges). Every CODE claim cites
   file:line read today (memory: Dola maps carried false code claims - S531).
2. Write ops/research/DESIGN_KNOW_STAKES1_V6.md: v5 + the measured numbers + each critic item answered (done / changed /
   refused with why). Where the reads' value is thin (bout wins), interconnect: e.g. the same shared misread on the
   OPPONENT's file so a $250 scout pays (KNOWMISREAD1 Next 3) - name it as a probe the build must pass, with its bar. Keep the
   table of every menu it appears on and what each is wired to.
3. Write ops/research/CRITIC_KNOW_STAKES1_V6_BRIEF.md (opens with ops/research/CRITIC_PACK.md + CRITIC_ACCESS.md, never an earlier
   score; DEPTH / PLAY / GENERAL /10; reads the code; ends with the ordered list to reach 10 and a drawn 10/10 page via
   tools/render_mockup.py). Queue it: `python ops/Tools/seat_queue.py add --seat kalli --brief research/CRITIC_KNOW_STAKES1_V6_BRIEF.md`.
   Do not score your own map.

## Prior research
The files above; `python ops/Tools/prior_research.py knowledge scout misread`.

## What would a human do?
A manager who has watched a kid twice signs on a hunch; the one who paid a scout signs on evidence and is less often fooled.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_KNOW_STAKES1_V6.md, ops/research/CRITIC_KNOW_STAKES1_V6_BRIEF.md
RED_TEST: none (map)
REGRESSION: none
VISUAL: no

## Rules
No Godot needed. Commit only your paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
