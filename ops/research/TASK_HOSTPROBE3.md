# HOSTPROBE3 - club show v6 map + probe (owner Q-S294-308 "Yes, keep it": the game's own favour rate, ~3 a year) (S540)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`). Godot only through
`python ops/Tools/godot_slot.py run --who HOSTPROBE3 -- <cmd>` (headless, Dummy audio); long probes write to a file and you wait
on its done line.

## Job
1. Write `ops/research/DESIGN_HOSTSHOW1_V6.md` from v5 (`DESIGN_HOSTSHOW1_V5.md`) and `docs/HOSTPROBE2_RESULT.md` section 7
   ("What to change"): pro call on ladder points, the hall as a read, cut sell / leave-off, reserves as the coach's default. The
   favour target is the game's own rate (about 3 a year) - owner answer, do not move it.
2. Probe it like HOSTPROBE2 (its tools/hostprobe2 files as the base, new tools/hostprobe3 files), bars written BEFORE the run and
   not loosened; result `docs/HOSTPROBE3_RESULT.md` with the verdict and, if FAIL, what to change.
3. PASS -> write `ops/research/CRITIC_HOSTSHOW1_V6_BRIEF.md` (opens with CRITIC_PACK.md + CRITIC_ACCESS.md, built the way
   `CRITIC_TURNPRO1_V15_BRIEF.md` is) and queue it:
   `python ops/Tools/seat_queue.py add --seat kalli --brief research/CRITIC_HOSTSHOW1_V6_BRIEF.md`, the same for dola.

## Prior research
HOSTPROBE1 (FAIL 2/10), HOSTPROBE2 (FAIL 3/9), `python ops/Tools/prior_research.py club show`.

## What would a human do?
A small-club promoter fills the hall with local names, keeps reserves on the card in case of a pull-out, and asks the regional
body for a favour a few times a year - not every month.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_HOSTSHOW1_V6.md, tools/hostprobe3.gd, tools/hostprobe3_rules.gd, docs/HOSTPROBE3_RESULT.md, ops/research/CRITIC_HOSTSHOW1_V6_BRIEF.md
RED_TEST: tools/hostprobe3.gd
REGRESSION: none
VISUAL: none
