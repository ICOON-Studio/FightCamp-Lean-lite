# TASK DEBUTPICK1 - the promoter picks the debut opponent to fit each boxer (owner Q-S294-286 "Pick to each boxer")

Kind: code
Status: DONE (S534 check: on main)

## Why
`docs/TURNPRO6_RESULT.md` (read it whole): with one fixed opponent strength per promoter (the gap: Bow Lane 3.0, Harrow & Finch
6.0, `DebutOpp.make`), the same debut wins anywhere from about 30 to 90 in 100 depending on the boxer. A real matchmaker picks the
opponent to the boxer: the safe promoter finds a soft touch for THIS boxer, the bigger-gate promoter a real test. The owner
answered on the board: **"Pick to each boxer"**. The offer's win read (BoutRead, fixed in TURNPRO6) is now good enough to aim with:
57 of 60 cells within 5 points of the real bouts.

## Build
1. Each promoter has a TARGET win chance for its debut, not a fixed gap: the safer promoter about 75 in 100, the bigger-gate one
   about 60 in 100 (TURNPRO6's measured averages - keep them unless your measurement says otherwise, and say so). Bounded,
   seeded noise so it is never exact (a matchmaker misjudges: a few points either way, never certain).
2. `DebutOpp.make` (or a small new pure rule beside it) finds the opponent rating whose read win chance for THIS boxer hits the
   target: search the gap through the same BoutRead the offer shows (never a second model of the fight). Cache per boxer + day.
3. The offer card keeps showing the read (TURNPRO6 put it there); its words say the promoter picked the opponent for your boxer
   ("Picked to give your boxer a winnable first night" / "Picked to test your boxer"), no names in text, Tip.gd card ~25 words.
4. Measure: on TURNPRO6's population (10 different boxers, `tools/turn_gap_probe.gd`), the real debut win share per promoter per
   boxer now sits in a band around the target (say the band; a fixed-gap control arm shows the old 30..90 spread; a green
   measurement must be able to read worse). Determinism: same seed, same pick.
5. Tests: a unit test of the pick (red on main), the offer card test, the golden path. Save/load keeps a picked opponent.

## Keep
- The 3D fight never decides. Amateur bouts unchanged (Matchmaking.gd books amateur offers - not this route).
- Fighters in every measurement differ; name the population. New behaviour ships ON (GameSwitches.GAME_ON) if it has a switch.
- Pro offer rules otherwise as decided (offer at 7 wins + top-3 or 9 wins, 4-round debut, purse numbers in the code).

## Other work in this checkout - do NOT edit
P4PBUILD1 Fable session: LiveRound, BoutFinish, CardAsk, CoachRead, PlanRecord, RingMap, RingTopDown, OfferCard, Interview,
RosterActs, ResultPage, FightNight, FightOptions. STEPPAY2 Fable session: RingDuel, Exchanges, LineGrade, PlanFight, StepEffect,
StepWire, StrikeMap, tools/treevalue_*. Grok Dev TIPFIX3: tooltips in scripts/ui. If the offer's words live in OfferCard.gd, put
the sentence in your rule (a function OfferCard already calls, or a new one) and list the one-line OfferCard hook in your final
message for Claude to wire. Pull (`git pull --rebase`) before each commit; stage explicit paths only - never another session's file.

## Rules
- Godot ONLY via `python ops/Tools/godot_slot.py run --who debutpick -- <godot.exe> --headless --audio-driver Dummy --fixed-fps 60
  --path . --script res://...`. The PC is short of memory while the owner plays: one probe at a time, never two.
- Small files (no script over 500 lines). Read ops/research/GDSCRIPT_TRAPS.md. Tests only those you touch + golden_path_test.
- Commit to main, end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Deliverable
Commits, `docs/DEBUTPICK1_RESULT.md` (per promoter: target, the measured band per boxer, the control arm), a line in roadmap.json
`plan` (row DEBUTPICK1). Final message: what changed, the numbers, the tests with their pass lines.

## Contract
OWNS: scripts/rules/DebutOpp.gd, new scripts/rules/DebutPick.gd (if needed), BoutRead.gd (read only unless a bug), ProOffer*.gd,
tools/turn_gap_probe.gd, tests/debut_*_test.gd, docs/DEBUTPICK1_RESULT.md
RED_TEST: tests/debut_pick_test.gd
REGRESSION: debut_read_test, the pro offer tests, golden_path_test

## Prior research
TURNPRO6_RESULT.md; DESIGN_TURNPRO1_V9.md (its numbers are superseded); Kalli K-PROLINE1 (the pro line numbers).
## What would a human do?
A matchmaker watches the kid spar and books him someone he should beat - or, for the TV promoter, someone who makes a show.
## Prefab check
None (our own rule).
