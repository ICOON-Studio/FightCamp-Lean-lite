# TASK TURNPRO6 - the pro debut's opponent gap: a curve we can trust, a read that tells the truth, then the gaps

Kind: code + probe
Status: OPEN (S533, Claude main; the owner asked for a hard task for the Fable side console). Discipline: boxing.
Model: Fable (claude-fable-5-2), Code Mode terminal session. No browser.

## Why
TURNGAP1 (`docs/TURNGAP1_RESULT.md`, probe `tools/turn_gap_probe.gd`, 20 boxers x 8 gaps x 10 seeds) measured the debut win
share against the opponent gap (your boxer's rating minus the opponent's). Three things in it look wrong and nothing has been
set from it yet:
1. A CLIFF, then a FLAT: -2 -> 41.0 %, -1 -> 67.0 %, then 0 / +1 / +2 all 78.5-79.0 %. A rating gap should move the win share
   smoothly. Either the bout sim is insensitive to rating between 0 and +2 (a real defect in the fight rules), or the probe
   reads it wrong (seeds that are not independent - S531 already found one seed bug where every seed was the same night -, a
   clamp, an integer rating, a matchmaking floor that swaps the opponent).
2. Per-boxer p10..p90 is 29 %..90 % at EVERY gap from -1 to +2: the same boxers win and lose regardless of the gap. That
   points at something else deciding the bout (the boxer's style, a fixed opponent template, the seed).
3. THE OFFER LIES: BoutRead at signing (what the offer screen tells the player) says 50.5 % at gap 0, while the real bouts win
   78.5 %; at -1 it says 45.3 % against 67.0 % real. The owner's rule: the screen shows the truth (operator S398 "only
   actionable info", and every number the player reads must be what the game does).

## Your job (in this order; stop and write up if a step shows the next one is wrong)
1. Read the probe and the route the GAME takes for a debut (trace it, never guess): `tools/turn_gap_probe.gd`, the offer
   (`scripts/rules/ProCall.gd`, `ProOffer*.gd`, `ProDebut.gd`, `ProOfferWire.gd`), matchmaking (`Matchmaking.gd`), the bout
   (`BoutRules.gd`, `Exchanges.gd`, `Sim.gd`) and the read (`BoutRead` - find it). Say in the result which function the game runs.
2. Find the cause of the cliff + flat and of the identical p10/p90. Prove it with a control arm that cannot share the bug
   (e.g. two boxers who differ ONLY in rating, many seeds, independent nights). If it is the probe: fix the probe. If it is the
   game: name the rule, show the numbers, fix it in the rule module with a unit test that goes red on main first.
3. Rerun the curve (more seeds if the noise needs it; name the population in the output: who, which styles, which seeds).
4. Make the offer's read match the real bouts within the read's own band (the read uses the same rule the bout uses, or is
   calibrated against it - say which and why). A test: the read at gaps -2, 0, +2 sits within 5 points of the measured share.
5. Only then set the two houses' debut gaps: the owner's agreed shape is a debut the boxer is expected to win but can lose -
   target about 70-80 % for the safer house and 55-65 % for the bigger-purse house (ESTIMATE from the TURNPRO maps; if the
   measured curve makes one of these impossible, say so and propose the closest). Put the numbers where the game reads them.

## Rules
- Godot ONLY through the queue: `python ops/Tools/godot_slot.py run --who turnpro6 -- <godot.exe> --headless --audio-driver
  Dummy --fixed-fps 60 --path . --script res://...`. Never `_console.exe`, nothing on the owner's screens. Slots may be busy
  with another session's footwork probes for ~1 h: wait in the queue, do not kill other jobs.
- Never two identical fighters in a measurement; a measurement names its population. Bound values, never an exact count.
- No new correction layer anywhere in scripts/fight3d (METHOD line). This task is rules + probe + the offer read only.
- Small files (no script over 500 lines). Stage explicit paths, commit to main, end messages with the Co-Authored-By line.
  Another session works in this checkout (main session: footwork steps in StepEffect/RingDuel/tools/treevalue_probe.gd; the
  word Fatigue rename in scripts/ui) - do not touch those files; `git pull --rebase` before you push.
- Tests: only the ones your change touches (`TESTS="a_test b_test" JOBS=2 sh tools/run_tests.sh`), never the full suite.

## Deliverable
`docs/TURNPRO6_RESULT.md` (cause, proof, the new curve, the read vs real table, the gaps chosen and why), the fixes with
their tests, and one line in roadmap.json `plan` row TURNPRO6. Report back to the main session in your final message:
cause in one sentence, the new curve, the gaps set, the tests run.

## Contract
OWNS: tools/turn_gap_probe.gd, docs/TURNPRO6_RESULT.md, scripts/rules/ (only the debut / offer / read modules the trace names),
tests/ (new or the touched tests)
RED_TEST: a new tests/*_test.gd that fails on main (the read vs real check)
REGRESSION: the tests of every rule module you change
VISUAL: no

## Prior research
TURNGAP1 (docs/TURNGAP1_RESULT.md); TURNPRO1 maps v3-v8 and their critics (ops/research/DESIGN_TURNPRO1_V*.md); run
`python ops/Tools/prior_research.py debut gap win chance` first.
## What would a human do?
A matchmaker checks the record and the film before he trusts a number, then picks an opponent his boxer should beat.
## Prefab check
None (our own rules).
