# PLAYBOOK - one page to work on her moves, combos, plans and escapes, and see every animation (S347)

Operator S347: "maybe add a planning page on the ui to work on the training moves and plans? where you can try
combos/transitions, escapes etc and see all the animations?"

## Verdict (Claude decides the design, you approve it)
Yes. A new menu entry, **Playbook**, beside Fighters / Fights / Gym, in the whiteboard look of the other menus. It is the
coach's whiteboard for one fighter at a time (pick her at the top). Most of it already exists as separate test screens:
the boxing move map (Test jump "strikemap"), the move player (verified on the GPU in S345), the plan board (on her page),
the flow view, the combo book, and the ground/tie-up browser (Test jump "grapple"). The Playbook puts them into the career
as one page.

## The page
- Left: **her map**. Positions as cards (long range, mid range, inside, on the ropes, in the corner, clinch), her moves as
  arrows between them. Lit = she can use it. Grey = she needs pad time first (the mastery we already track).
- Right: **the player**. Two women, head to feet, the camera inside the ropes. Click any arrow and it plays, with Replay and
  Slow motion buttons.
- Tabs over the map:
  1. **Moves**: every punch, step and defence she has.
  2. **Combos**: build your own. Chain single moves (jab, cross, hook, body hook, uppercut, slip, pivot, step in) and the
     player shows it. A chain that flows the way real boxers throw it (the weight shift carries into the next punch) is
     rated better than a clumsy one, so knowing boxing pays. Save it to her book.
  3. **Escapes**: getting off the ropes, out of the corner, tie-ups (slip and pivot, roll out, tie her up).
  4. **Plans**: the plan board you already have ("if she presses: ..."), each arrow plays its clip, and "See the flow".
  5. **Ground**: wrestling tie-ups and ground moves, only for an MMA fighter (waits on your Q-S294-70 answer).
- **Drill this** on any move, combo or escape puts it into her training week as pad work. She earns it in the gym, and it
  lights up on her map when it is usable in a fight.

## Why this way
- It is how real coaches work: moves, combos and plans are planned on a whiteboard, drilled on the pads, then used in the
  fight. The page joins all three, so a player sees why the gym work matters.
- It replaces the queued "move player in the move map's corner" job with a whole page, so no work is thrown away.
- Seeing every animation in one place is also how we QA them: every clip the agents make lands here.

## Build order (if approved)
1. The page, the Moves tab and the player (Claude: UI). The clips we have play from day one.
2. Plans tab: the plan board moves in, and every arrow plays its clip.
3. Combos: chaining rules in a pure rule module (Qwen, with a test from real punch sequences). The player plays the chain,
   and the agents make the joining clips (the animation seats).
4. Drill this -> her training week (pad work, mastery).
5. Escapes. Then Ground with the MMA update.
