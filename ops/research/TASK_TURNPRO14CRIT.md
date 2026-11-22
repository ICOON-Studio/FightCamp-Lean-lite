# TURNPRO14CRIT - a code-checked critic of the turning pro map v14 (S537)

Kind: research. Model: Fable console in this checkout. Commit to main, push; touch only your file. RESEARCH ONLY - no game code
changes, do not run Godot.

## Your job
Read `ops/research/DESIGN_TURNPRO1_V14_CRITIC_KALLI.md` - it is the full critic brief (the game's critic pack, then the design
map TURNPRO1 v14). Do exactly what it asks (scores for DEPTH / GENERAL DESIGN / PLAY, missing / useless options, "To reach 10/10"
list, your 10/10 page described), with THREE additions no chat critic can do:

1. CHECK EVERY "CODE" CLAIM in the map (`ops/research/DESIGN_TURNPRO1_V14.md` sections 1, 3, 4, 5 and 7: every `File.gd` :line)
   against the repo (scripts/rules, scripts/state, scripts/ui). For each claim: TRUE (file + function + line) / FALSE (what the
   code really does) / NOT FOUND. Check first the lines v14 builds on (section 1, "The lines v14 builds on"): `ProLadder.book`
   writing the kind into `f["bout"]`, `BoutFinish` paying +5 / +2 from it, `ProFights` drawing the chip, DebutPick's search
   giving two debutants a house, and what became of the v13 critic's FALSE claim (`FighterProfile.gd` month_no_fight) and of
   the per-house DebutOpp styles. A map whose CODE lines are false cannot be built as written - say which. Do not cite by line
   the files that carry other sessions' uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd).
2. CHECK THE PROBE against the map: read `tools/turnprobe14_rules.gd` (sign, after_debut, road, choose, booked, favour,
   after_fight), `tools/turnprobe14.gd` (_cell, _career, _day, _stage_a), `tools/turnprobe14_sum.py` (beats, the three pass
   rules, the bars) and `docs/TURNPROBE14_RESULT.md`. Does the probe's model do what sections 3 to 5 say (both kinds on every
   road set, the tune-up win at +2, favour +1 / -1 on the house's kind, the title shot at favour 8 after 4 wins at the ticket
   house, +$300 a purse at the guarantee house, the kind taken back under 3, the two debutants)? Are "flat" and "nofav" fair
   controls? Name anything the probe makes true by construction - above all bars 7, 8, 11, 13 and 17 (three bots with fixed
   rules must book different kinds: does that alone pass them?) and bar 15 (does the favour move the result through the
   player's choice, or only through the +$300 and the title row?).
3. CHECK THE RESULT'S OWN LIMITS (its section 2): the two bars that failed (4, the card boxer by boxer; 10, the name-chaser's
   lead under 3 reputation), the win-chaser being the one answer in a third of the boxer cells, the keeper and the name-chaser
   reading the same at the ticket house, the full gym where the guarantee house beats everything, the gyms that close. Say for
   each whether it lowers the score, and whether the PLAYER gets three decisions (house, night, the kind of each fight) or one
   decision and two habits. Score what is measured, not what is promised.

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V14_CRITIC_FABLE.md`: the scores (the bar is 8 DEPTH and 8 PLAY, owner S534), the
code-claim table, the probe check, the limits check, the 10/10 list (most important first, specific enough to build). At the end
of the file: the list of code files you opened.

## Prior research
`docs/TURNPROBE13_RESULT.md` (PASS 14 of 15) and both v13 critics (`DESIGN_TURNPRO1_V13_CRITIC_ARENA.md`,
`DESIGN_TURNPRO1_V13_CRITIC_JOHN_JOHN.md`: 5 / 7 / 5, "the road plays itself"), `docs/TURNPROBE11_RESULT.md` and
`docs/TURNPROBE12_RESULT.md` (two FAILs and why), `DEPTH_AUDIT_S534.md` (five maps passed critics and failed when measured).

## What would a human do?
Open every cited line before believing a sentence about it, and ask whether a manager would ever book the step up, or refuse
the house, at these numbers - not whether the table has a PASS on it.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V14_CRITIC_FABLE.md
RED_TEST: none (research). REGRESSION: none. VISUAL: no
