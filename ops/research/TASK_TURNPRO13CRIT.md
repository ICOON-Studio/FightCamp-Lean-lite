# TURNPRO13CRIT - a code-checked critic of the turning pro map v13 (S536)

Kind: research. Model: Fable console in this checkout. Commit to main, push; touch only your file. RESEARCH ONLY - no game code
changes, do not run Godot.

## Your job
Read `ops/research/DESIGN_TURNPRO1_V13_CRITIC_JOHN.md` - it is the full critic brief (the game's critic pack, then the design
map TURNPRO1 v13). Do exactly what it asks (scores for DEPTH / GENERAL DESIGN / PLAY, missing / useless options, "To reach 10/10"
list, your 10/10 page described), with THREE additions no chat critic can do:

1. CHECK EVERY "CODE" CLAIM in the map (`ops/research/DESIGN_TURNPRO1_V13.md` sections 1, 3, 4, 5 and 7: every `File.gd` :line)
   against the repo (scripts/rules, scripts/state, scripts/ui). For each claim: TRUE (file + function + line) / FALSE (what the
   code really does) / NOT FOUND. The map says the line numbers of `rules/Matchmaking.gd` and `state/ProLadder.gd` were moved
   by hand after those files changed: check those first. A map whose CODE lines are false cannot be built as written - say
   which. Do not cite by line the files that carry other sessions' uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd,
   MHRig.gd, Player2.gd, BoutPage.gd).
2. CHECK THE PROBE against the map: read `tools/turnprobe13_rules.gd` (card, repick, sign, after_debut, last_seat, road,
   after_fight), `tools/turnprobe13.gd` (_cell, _career, _day, _stage_a), `tools/turnprobe13_sum.py` (beats, verdict, the bars)
   and `docs/TURNPROBE13_RESULT.md`. Does the probe's model do what sections 3 to 5 say (the tune-up win at +2 and only on
   rows booked as tune-ups, the card's two added terms, the guarantee aim at 78, the name by seats, the table's last seat, the
   rebuild flag, the firm road)? Is the "flat" arm a fair control for the tune-up rule? Name anything the probe makes true by
   construction - above all bar 10 and bar 15 (the rule takes reputation from the guarantee road; does that alone pass them?),
   and bars 7, 8 and 11 now that only two options are left.
3. CHECK THE RESULT'S OWN LIMITS (its section 2): two options, a bot that does not read the +2 / +5 line, the ticket house
   never the one answer, 28 debut wins in 100 given away, the gyms that close. Say for each whether it lowers the score, and
   whether the mechanic the PLAYER gets is one decision or a road of decisions. Score what is measured, not what is promised.

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V13_CRITIC_FABLE.md`: the scores (the bar is 8 DEPTH and 8 PLAY, owner S534), the
code-claim table, the probe check, the limits check, the 10/10 list (most important first, specific enough to build). At the end
of the file: the list of code files you opened.

## Prior research
`docs/TURNPROBE11_RESULT.md` and `docs/TURNPROBE12_RESULT.md` (two FAILs and why), `ops/research/DESIGN_TURNPRO1_V12.md`,
`DESIGN_DMGCLASS1_V3_CRITIC_FABLE.md` (the form of this review), `DEPTH_AUDIT_S534.md` (five maps passed critics and failed
when measured).

## What would a human do?
Open every cited line before believing a sentence about it, and ask whether a manager would ever pick the hard road at these
numbers - not whether the table has a PASS on it.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V13_CRITIC_FABLE.md
RED_TEST: none (research). REGRESSION: none. VISUAL: no
