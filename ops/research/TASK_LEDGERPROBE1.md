# TASK LEDGERPROBE1 - contract tab: is keep / cut the stipend / release a real choice? Probe before any sixth map (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo). Board row LEDGER1.

## Why
LEDGER1 (what a boxer has been worth, and what to do with him) went through five design maps, never probed; v5 critics Arena
depth 7 / general 5 / play 6 (ops/research/DESIGN_LEDGER1_V5_CRITIC_ARENA.md), under the owner's S534 bar (8 depth, 8 play).
Owner S534 order: probe the lever on a greybox FIRST. FREE HAND: FAIL = drop it; PASS = v6 to critics.
The decision the tab exists for (DESIGN_LEDGER1_V5.md): per boxer, keep him as he is / cut his $250 stipend (he may take a
day job or leave) / release him (a pro's new manager pays a release fee, Leaving.gd :93, against the share he brings per bout,
StarDeal.gym_net).

## Do
1. Read DESIGN_LEDGER1_V5.md (sections 1 and the choice), the Arena critic, scripts/rules/Leaving.gd, StarDeal.gd, the stipend
   price result docs/DEPTHPRICE1B* (stipend thin PASS) and ops/research/DEPTH_SCOPE_S534.md.
2. Greybox probe (tools/ledgerprobe1.gd, flagged local copies, nothing under scripts/ changed): careers of 60+ boxers who all
   differ, at the moment the tab would be opened (after a loss run, a pro offer, a cash squeeze). Arms: keep / cut stipend /
   release, and a bot that READS the ledger (what he has been worth) against one that does not. Measure gym cash, wins and
   reputation at +26 and +52 weeks. Bars fixed BEFORE the run: (a) no arm best in every cell, (b) the ledger-reading bot beats
   the blind one by more than its error, (c) the best arm flips on something the tab shows.
3. docs/LEDGERPROBE1_RESULT.md with the table and a one-line verdict.
   - PASS: write ops/research/DESIGN_LEDGER1_V6.md (v5 + what the probe says matters, Arena's 10/10 list answered) and
     ops/research/CRITIC_LEDGER1_V6_BRIEF.md (opens with CRITIC_PACK.md + CRITIC_ACCESS.md; depth and play /10; the list to reach
     10; one critic code-checked); queue `python ops/Tools/seat_queue.py add --seat kalli --brief research/CRITIC_LEDGER1_V6_BRIEF.md`.
   - FAIL: say what would have to be true for the choice to exist; no v6.

## Prior research
ops/research/DESIGN_LEDGER1_V5.md, DESIGN_LEDGER1_V5_CRITIC_ARENA.md, docs/DEPTHPRICE1B_RESULT.md (or git show a2ee323f1),
`python ops/Tools/prior_research.py ledger contract stipend release`.

## What would a human do?
A club owner looks at what a kid has cost and brought in before he cuts him loose - but sentiment and a hunch about the kid
matter too; the books are one voice.

## Prefab check
None.

## Contract
OWNS: tools/ledgerprobe1.gd (new), docs/LEDGERPROBE1_RESULT.md, ops/research/DESIGN_LEDGER1_V6.md,
ops/research/CRITIC_LEDGER1_V6_BRIEF.md
RED_TEST: none (measurement)
REGRESSION: none (nothing under scripts/ changes)
VISUAL: no

## Rules
Work in main (read-only on scripts/). Godot ONLY through `python ops/Tools/godot_slot.py run --who ledgerprobe1 -- <godot.exe>
--headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/ledgerprobe1.gd`; long output to a file. No
script over 500 lines. Commit only your paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
