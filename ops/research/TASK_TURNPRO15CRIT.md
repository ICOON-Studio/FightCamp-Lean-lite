# TURNPRO15CRIT - a code-checked critic of the turning pro map v15 (S540)

Kind: research. Model: claude-opus-5-5 (Code Mode tab). Commit to main with a pathspec (`git commit -- <your file>`), push; touch
only your file. RESEARCH ONLY - no game code changes, do not run Godot.

## Your job
Read `ops/research/CRITIC_TURNPRO1_V15_BRIEF.md` - the full critic brief (critic pack, the v15 map, the probe's bars). Do exactly
what it asks (SCORE depth/play/general, missing / useless options, "To reach 10/10", your 10/10 page as one HTML code block), plus
what a chat critic cannot do:
1. CHECK EVERY "CODE" CLAIM in `ops/research/DESIGN_TURNPRO1_V15.md` against scripts/rules, scripts/state, scripts/ui: TRUE (file +
   function + line) / FALSE (what the code does) / NOT FOUND.
2. CHECK THE PROBE: `tools/turnprobe15.gd`, its rules file, `tools/turnprobe15_sum.py`, `docs/TURNPROBE15_RESULT.md` (PASS 17/17).
   Does the probe model what the map says? Which bars could pass by construction (fixed-rule bots booking different kinds)? Are
   the controls fair? The v14 critic (`DESIGN_TURNPRO1_V14_CRITIC_FABLE.md`) found "one decision and two habits" - is that fixed?
3. Score what is measured, not what is promised. Bar: 8 DEPTH and 8 PLAY (owner S534).

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V15_CRITIC_OPUS.md`, ending with the list of code files you opened.

## Prior research
TURNPROBE13/14 results and their critics (`ls ops/research | grep TURNPRO1_V1`), `DEPTH_AUDIT_S534.md`.

## What would a human do?
Open every cited line before believing it; ask whether a manager would ever refuse the house or book the step up at these numbers.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V15_CRITIC_OPUS.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: none
