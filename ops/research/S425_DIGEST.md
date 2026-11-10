# S425 digest (2026-11-10) - mechanics must be deep: from one small map to a design for the week

## His words this session (verbatim)
- "i expect all new mechanics to be wired and shown properly on the correct menus and be deep enough for a critics +7/10"
- "can you assign a subagent to fix the boxing/grappling animation issues and using fable 5.2 , i want to start seeing
  animations on the board and grappling fights that make sens and make understand what is the action happening and how to
  react as a player"
- "maybe review combine old ideas to rise their depth to +7 and maybe come with new things ? can other free agents work on
  that , the focus needs to be for the player to have things to do during a week make him anticipate the changes and be
  more interactive with deicions/choices and rewarding for keep playing and progressing"
- He pasted an outside proposal (the playbook as the steering wheel: if-then rules, rule places by ring IQ, a plate when a
  rule fires) and asked "what do you think of this"; then "does this includes possible player actions during the week ?"

## What now works / exists
- Measured (tools/pads_for_two_probe.gd, 300 bouts a cell): the coach's hands = one week on a card; a plan answer she
  cannot do yet costs 2 to 14 wins in 100 (40.0% with all four; 26.3% without step back; 18.7% no plan); sharp over
  usable = 1 point.
- Measured (tools/read_back_probe.gd, READBACK1, Qwen, on main): her corner waiting for the best plan line costs 7.0
  points (41.3% -> 34.3%), 5 to 6 of them in round 2; drop +0.7, swap 0.0: no way back in today's rules.
- R55 "who gets the pads": map v1 and v2, four critic reviews, depth 4 each: too small alone. Not on his board.
- The week design: brief (WEEK_DEPTH_BRIEF_S425.md) -> two designer pages -> joined v1 (WEEK_DESIGN_V1_S425.md,
  docs/mockups/s425/week_v1.png): the coach's evenings, the film on you, the week board and Thursday call, the next
  fight's four prices -> two fresh critics: depth 5 each (dead days Tue/Sat/Sun, dead options, Home too full, reward 4,
  rests on an unmeasured way back).
- His outside proposal read against the game: PLAYBOOK_GAMBIT_IDEA_S425.md (take: state rules, drilled to fire, places
  by ring IQ, the plate; careful: sliders, write-once rules, clones, invented numbers).
- Rule in CLAUDE.md: every new mechanic wired, shown, critics 7+.

## In flight at the ship (all report into the S425 session)
- Lead designer (Fable subagent): WEEK_DESIGN_V2_S425.md + week_v2.png + week_v2_thursday.png, from both reviews, the
  playbook proposal and READBACK1.
- Qwen READBACK2 (branch qwen/readback2): set-up and wait-cost as switched-off rules in scripts/rules/ReadBack.gd, measured.
- Cursor DUESCARD1 (branch cursor/duescard1): the painted dues boards.
- ANIMFIX1 (Fable subagent): leg tremble on qwen/legtremble4 (PR 168), grappling on claude/grapplefix1, and the check +
  film of Cursor's KDFIX4 (PR 169, ten tests reported green, NOT merged).
- Kalli SQ35 (cutman v3 pasted), SQ36 (her week page); John SQ31/33/34.

## Evidence
Commits 5edde00a .. this one on main. No game code changed on main this session (tools, docs, ops only): no new export.

## Next
1. Week design v2 -> two FRESH critics -> 7+ -> his board with the pictures; under 7, another round.
2. READBACK2 decides the size of the plan-reading part (keep: within 2 points of the plain plan and 3 above waited).
3. Collect ANIMFIX1's branches and KDFIX4 after its films; DUESCARD1 render against docs/mockups/s424/dues_painted_v4.png.
4. Cutman v3 and the dues sums when the chat seats answer.
