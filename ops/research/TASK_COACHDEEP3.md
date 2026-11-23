# COACHDEEP3 - deep coaches v3: amateur bouts pay by rank, then the coach map again (S540)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`). Godot only through
`python ops/Tools/godot_slot.py run --who COACHDEEP3 -- <cmd>` (headless, Dummy audio), one run at a time, output to a file.

## The owner's answer
COACHDEEP2 failed on money (`docs/COACHDEEP2_RESULT.md` section 5): an amateur on the club's $250 stipend returns $112 a week,
so every coaching rule that lets boxers go wins. Board Q-S294-311 "An amateur costs $250/week, earns the club $112. Which fixes
it?" -> **"Bouts pay by rank"**: an amateur's bouts pay the club by her regional ladder rank.

## Do
1. Price it from real numbers (England Boxing / club-show ticket cuts; `python ops/Tools/prior_research.py amateur ticket`) and
   the game's ladder (the regional ladder already ranks her): a bout pays the club by her rank band, so a ranked amateur roughly
   pays her stipend and an unranked novice does not. Write the numbers and their sources in `ops/research/DESIGN_COACHDEEP3.md`.
   The stipend stays $250 (decided number); only the bout pay changes.
2. Then COACHDEEP2 section 5 items 2-5 in order: class nights with falling returns, a coached evening worth more than a stat
   decimal (measure it in wins first), area weights that follow the boxer so no one coach is best, chemistry resized.
   The owner's 24 grilling answers (`ops/research/COACHDEEP_GRILL_S539.md`) stay binding.
3. Probe: COACHDEEP2's bars unchanged (tools/coachdeep2* as the base, new tools/coachdeep3*), plus one money bar: the best plan
   keeps its ranked boxers in at least 8 of 10 cells. Result `docs/COACHDEEP3_RESULT.md`.
4. PASS -> `ops/research/CRITIC_COACHDEEP3_BRIEF.md` (built like CRITIC_COACHDEEP1_BRIEF.md) queued for kalli and dola with
   `python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_COACHDEEP3_BRIEF.md`. FAIL -> what to change, stop.

## Prior research
COACHDEEP1 (PASS 5/5), COACHDEEP2 (FAIL), Kalli/Dola on v1 (CRITIC_COACHDEEP1_BRIEF_KALLI.md / _DOLA.md), GymBills.gd, BoutRules.gd.

## What would a human do?
A club pays to keep the kid who wins medals because medals fill the hall and bring sponsors; the novice trains on dues.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_COACHDEEP3.md, tools/coachdeep3.gd, tools/coachdeep3_rules.gd, docs/COACHDEEP3_RESULT.md, ops/research/CRITIC_COACHDEEP3_BRIEF.md
RED_TEST: tools/coachdeep3.gd
REGRESSION: none
VISUAL: none
