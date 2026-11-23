# TASK KNOWSTAKES7 - knowledge stakes map v7: both critics' lists + the rival deadline (S539)

Model: claude-fable-5-2 (Code Mode tab on the owner's subscription). Discipline: boxing (demo). Map only: nothing under
scripts/ changes. Board row KNOWLEDGE1.

## Why
v6 (ops/research/DESIGN_KNOW_STAKES1_V6.md) critics: Dola 7/7/8 (ops/research/CRITIC_KNOW_STAKES1_V6_BRIEF_DOLA.md), Kalli
6/4/5 code-checked (ops/research/CRITIC_KNOW_STAKES1_V6_BRIEF_KALLI.md: the answer leaks via Roster.scouted_range, hype is
unwired, the trial jumps the range to exact). Bar (owner S534): 8 DEPTH and 8 PLAY from two fresh critics.
Owner Q-S294-305, asked "Prospects: a rival gym signs them in 1-3 weeks unless you decide?", answered: "Yes, add the deadline".
So a prospect now has a clock: a rival gym signs them in 1 to 3 weeks unless the player decides. Scouting, a trial and
waiting each cost days on that clock.

## Do
1. Read v6, both critics' "to reach 10" lists, and the code each Kalli finding names (open Roster.gd scouted_range, the hype
   path, the trial path; cite file:line read today - S531: maps carried false code claims).
2. Write ops/research/DESIGN_KNOW_STAKES1_V7.md: v6 + every critic item answered (done / changed / refused with why), the three
   Kalli code defects fixed in the design (no leak, hype wired or cut, the trial narrows but never jumps to exact), and the
   rival deadline: how long (1-3 weeks, what sets it), what each read costs on the clock, what the player sees (a line on the
   prospect card, a hover that explains), what happens when it runs out (the rival signs them; they can appear later as an
   opponent if that is cheap). FREE HAND (owner S534): cut, add or interconnect. Keep the table of every menu it appears on
   and what each is wired to. Name the probe the build must pass, with its bar (sign-on-hunch vs scout vs wait must each be
   right sometimes).
3. Write ops/research/CRITIC_KNOW_STAKES1_V7_BRIEF.md (opens with ops/research/CRITIC_PACK.md + CRITIC_ACCESS.md, never an
   earlier score; DEPTH / PLAY / GENERAL /10; reads the code; ends with the ordered list to reach 10 and a drawn 10/10 page via
   tools/render_mockup.py). Queue BOTH: `python ops/Tools/seat_queue.py add --seat kalli --brief research/CRITIC_KNOW_STAKES1_V7_BRIEF.md`
   and the same with `--seat dola`. Do not score your own map.

## Prior research
The files above; `python ops/Tools/prior_research.py knowledge scout prospect deadline`; docs/KNOWMISREAD2_RESULT.md.

## What would a human do?
A good amateur is seen by three gyms; the manager who dithers loses him to the one down the road.

## Prefab check
None (design map).

## Contract
OWNS: ops/research/DESIGN_KNOW_STAKES1_V7.md, ops/research/CRITIC_KNOW_STAKES1_V7_BRIEF.md
RED_TEST: none (map)
REGRESSION: none
VISUAL: no

## Rules
No Godot. Commit only your paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
