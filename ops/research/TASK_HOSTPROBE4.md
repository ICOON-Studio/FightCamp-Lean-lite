# HOSTPROBE4 - club show v7: section 7 of HOSTPROBE3, then probe (S540)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`) and push them.
Godot only through `python ops/Tools/godot_slot.py run --who HOSTPROBE4 -- <cmd>` (headless, Dummy audio), one run at a time,
output to a file, wait on its done line.

## Why
v6 (`ops/research/DESIGN_HOSTSHOW1_V6.md`) FAILED 5 of 9 (`docs/HOSTPROBE3_RESULT.md`; v4 2/10, v5 3/9). Broken: the pro points
line (B8, a seed that boxers never reach in this zero-sum ladder); thin: the card's lead over the lazy ask (A3). The favour rate
stays the game's own (~3 a year, owner Q-308 "Yes, keep it").

## Do
1. `ops/research/DESIGN_HOSTSHOW1_V7.md`: HOSTPROBE3 section 7 items, in order - the pro line calibrated from the game's own
   careers (the ladder points boxers hold at the built call in TURNPROBE15's careers, tools/turnprobe15*), or the weighted-win
   count; the hall read averaged over the range of nights with "close - your call" under $300; the favour's yes +2 in 10; a
   refused ask up costs time (the name above's "no" can miss the posters). Anything else in section 7 too.
2. Bars as HOSTPROBE3, written BEFORE the run, not loosened; B8 measured in the TURNPROBE15 harness (boxers who grow, newcomers),
   not the closed pool. Result `docs/HOSTPROBE4_RESULT.md`.
3. PASS -> `ops/research/CRITIC_HOSTSHOW1_V7_BRIEF.md` (built like CRITIC_TURNPRO1_V15_BRIEF.md) queued for kalli and dola
   (`python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_HOSTSHOW1_V7_BRIEF.md`). FAIL -> what to change.
4. HOSTPROBE3 also says "the game's win chance never changes with a boxer's mood". S539 MOODREAD1 (fe72931fd) made the WIN READ
   move with mood; check in the code whether the fight itself reads mood, and write one line on it in the result (no fix here).

## Prior research
HOSTPROBE1/2/3 results, DESIGN_HOSTSHOW1_V4-V6, LadderRep.gd, ClubShow.gd.

## What would a human do?
A promoter asks the bigger name first because the poster sells, and books the hall from how the last few nights went - not
from one guess.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_HOSTSHOW1_V7.md, tools/hostprobe4.gd, tools/hostprobe4_rules.gd, docs/HOSTPROBE4_RESULT.md, ops/research/CRITIC_HOSTSHOW1_V7_BRIEF.md
RED_TEST: tools/hostprobe4.gd
REGRESSION: none
VISUAL: none
