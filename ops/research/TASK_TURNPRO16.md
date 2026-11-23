# TURNPRO16 - turning pro v16: map + probe to reach 8 (S540)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`). Godot only through
`python ops/Tools/godot_slot.py run --who TURNPRO16 -- <cmd>` (headless, Dummy audio), ONE run at a time; long runs write to a
file and you wait on the done line (memory: a killed waiter leaves Godot running - check processes by PID, never by name).

## Why
v15 passed its probe 17/17 (`docs/TURNPROBE15_RESULT.md`) but the code-checked critic scored it 6/6/6
(`ops/research/DESIGN_TURNPRO1_V15_CRITIC_OPUS.md`): "obey the house is never wrong", each of the three choices alive at only
one house or one gym size, bars 4/7/8/11/13/17 pass by construction. Kalli and Dola score v15 too: if
`ops/research/CRITIC_TURNPRO1_V15_BRIEF_KALLI.md` / `..._DOLA.md` exist when you start (or land before your probe), fold their
"To reach 10/10" lists in; say which items you took.

## Do
1. `ops/research/DESIGN_TURNPRO1_V16.md`: one clean document (fix F1-F3, the moved lines, every stale "+2" / "4 days" text).
   Take the critic's list in order (FREE HAND, owner S534: remove, add or interconnect): spendable favour, a reason for the
   ticket house's tune-up, the guarantee house's test night rewarded or cut, a big-gym choice, the two rewards on screens.
2. Bars BEFORE the run, with the critic's fixes to the bars: no bar true by construction; 7/8/11 re-read without the record
   axis; a READER bot that must beat every fixed bot by a line in half the cells (the depth bar); bar 16 per house; stage F
   keeper v name-chaser at the guarantee house, favour on/off.
3. Probe (base: tools/turnprobe15*.{gd,py} -> new tools/turnprobe16*), result `docs/TURNPROBE16_RESULT.md`. Size the run so it
   finishes in under 3 hours on one Godot slot (time one cell first).
4. PASS -> build `ops/research/CRITIC_TURNPRO1_V16_BRIEF.md` the way the v15 brief is built and queue kalli + dola
   (`python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_TURNPRO1_V16_BRIEF.md`).

## Prior research
TURNPROBE13/14/15 results and critics; DEPTH_AUDIT_S534.md (five maps passed at 7+ and failed when measured).

## What would a human do?
A manager trades the promoter's goodwill for something concrete - a title shot, a better name, a better date - and sometimes
refuses the house's pick because the boxer needs a different fight. Obeying the house must cost something.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V16.md, tools/turnprobe16.gd, tools/turnprobe16_rules.gd, tools/turnprobe16_sum.py, docs/TURNPROBE16_RESULT.md, ops/research/CRITIC_TURNPRO1_V16_BRIEF.md
RED_TEST: tools/turnprobe16.gd
REGRESSION: none
VISUAL: none
