# HOSTPROBE5 - club show v8: section 7 of HOSTPROBE4, then probe (S541)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`) and push them.
Godot only through `python ops/Tools/godot_slot.py run --who HOSTPROBE5 -- <cmd>` (headless, Dummy audio), one run at a time,
output to a file, wait on its done line.

## Why
v7 (`ops/research/DESIGN_HOSTSHOW1_V7.md`) FAILED 5 of 9 (`docs/HOSTPROBE4_RESULT.md`): B8 (Lucy called at bout 6 v 9), B9 and
B3 (chase cells already over 34, below best in 20 of 36), A3 (8 of 36). v4 2/10, v5 3/9, v6 5/9.

## Do
1. `ops/research/DESIGN_HOSTSHOW1_V8.md`: every item of HOSTPROBE4 section 7, in order (weighted wins at the built count, a less
   safe name below, main event posters tied to the hall, and the rest). FREE HAND (owner S534): remove, add or interconnect to
   reach the bars; say what you changed and why.
2. Same bars as HOSTPROBE4, written BEFORE the run, never loosened. Probe `tools/hostprobe5.gd`. Result `docs/HOSTPROBE5_RESULT.md`.
3. PASS -> `ops/research/CRITIC_HOSTSHOW1_V8_BRIEF.md` (built like CRITIC_TURNPRO1_V15_BRIEF.md, opening with CRITIC_PACK.md)
   queued for kalli and dola (`python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_HOSTSHOW1_V8_BRIEF.md`).
   FAIL -> section "what to change" and stop.
4. If this is the 3rd FAIL in a row at 5/9, say in the result whether the mechanic can reach 8 at all (owner: under 8 -> his
   cut-or-keep call).

## Prior research
HOSTPROBE1-4 results, DESIGN_HOSTSHOW1_V4-V7, LadderRep.gd, ClubShow.gd, tools/hostprobe4*.gd.

## What would a human do?
A promoter books the poster name the hall can sell, and takes a less safe name below when the safe one says no.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_HOSTSHOW1_V8.md, tools/hostprobe5.gd, tools/hostprobe5_rules.gd, docs/HOSTPROBE5_RESULT.md, ops/research/CRITIC_HOSTSHOW1_V8_BRIEF.md
RED_TEST: tools/hostprobe5.gd
REGRESSION: none
VISUAL: none
