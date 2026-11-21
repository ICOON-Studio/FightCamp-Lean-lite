# TASK DEPTHAUDIT1 - how strategically deep is FightCamp today? (owner S534: "do you think we should go deeper into the
# strategy aspect of the game ? how strategically deep is our game")

Kind: research. Model: Fable console in this checkout. RESEARCH ONLY - no game code changes, no Godot.

## The question, answered from evidence
Write ONE file `ops/research/DEPTH_AUDIT_S534.md` (plain words, the owner reads it; a 10-line summary at the top):
1. THE PLAYER'S DECISIONS, from the code: list every decision a player makes in a normal week and in a fight week (training
   plan, camp, bookings, offers, the fight plan and corner calls, money, staff, signing, turning pro, the club). For each:
   what it changes (the number it moves, file + function), how often it comes up, and whether it has a dominant answer.
2. WHAT THE MEASUREMENTS ALREADY SAY (read them, do not re-run): docs/*_RESULT.md, ops/research/*PROBE*, the critics' depth
   scores in ops/research/DESIGN_*_CRITIC_*_*.md and ops/research/DESIGN_LOOP_S459.md. The pattern to check: a lever built
   but its effect never reaches the result (STEPPAY1: no ring place was an edge; GUARD v5: the guard acts after settle;
   COACHFIT: a fit barely felt; turning pro v10: one ask decides the fork; DMGCLASS v2: class adds no choice). Count how
   many built choices are real (move a result, no dominant answer) vs cosmetic or one-answer.
3. COMPARE with the genre's references in our own words (Football Manager, Out of the Park, Boxing Manager, Two Point
   Hospital, Punch Club, World Championship Boxing Manager): where their strategy lives (long-term planning, trade-offs
   between resources, information under uncertainty, opponents who adapt) and where ours does or does not.
4. VERDICT: wide or deep? The 3-5 changes that would add the most strategic depth for the least build, most important first,
   each naming the existing system it deepens (not new systems - owner rule: new systems only when the last build feels
   right). Say plainly if the answer is "make existing choices matter" rather than "add more".

## Rules
Touch ONLY that file. Other sessions have uncommitted edits - never stage anything else. `git add -- ops/research/DEPTH_AUDIT_S534.md`,
commit to main, push, report in two lines, then stop.
