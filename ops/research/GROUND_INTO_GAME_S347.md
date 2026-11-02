# Ground moves into the game (S347, operator: "what happened with this? how we implement this into the game?")

## What the film is
`grapple_walk.mp4` (S335, 2026-11-01 06:44): GrappleMap (public domain: 601 positions, 1,485 moves) played on our two
MetaHuman women. A test screen walks the move map by itself: 10 moves, a pause on each position.
You said: "the video looks amazing, can still be improved", and asked for the same for boxing.

## What happened after it
- S336: hands curl into grips when they touch the other body. Each move keeps its own speed (no flat 0.5 s).
- S337: bodies pushed out where they sank into each other (local push, grips pinned).
- S337-S338: wrestling tie-ups tab (6 tie-ups, 30 answers, each plays a GrappleMap clip) and the coach's plan arrows on it.
- S340/S344: the plan shows as a flow ("See the flow"), wrestling included.
- S342: a clean re-film of a 6-move chain (docs/playtest/S342/our_grapple_chain.mp4, 28 s).
- The film left the review board by itself after 24 h (the board auto-clears).

## Where it is today
A separate test screen (`scenes/dev/GrappleBrowser.tscn`), opened only with the test jump `jump=grapple`. It is NOT in
the career: no boxer of yours ever goes to the ground, because the career is boxing only (Lean scope, release order:
boxing v1, then MMA as the first update).

## How it goes into the game (same pattern as the boxing fight)
1. The fight decides on paper first (a rule module, like boxing's Exchanges): positions are states (standing, clinch,
   guard, half guard, side control, mount, back), moves are arrows with odds from her attributes (wrestling,
   jiu-jitsu, strength, gas tank). Odds come from real fight stats (takedown and escape rates), researched first.
2. Your coaching steers it: the plan board you already have for tie-ups ("if she leans in on the tie: Snapdown")
   extends to the ground ("in half guard: pass to side control"), plus corner calls between rounds.
3. The 3D shows the settled exchange, never decides it: when a beat is a ground move, the same two bodies switch from
   the boxing stage to the GrappleMap player and play the shortest clip chain between the two positions the paper fight
   chose (takedowns from GrappleMap's 16 throws, 42 single legs, 27 double legs).
4. The gym trains it: a ground move she drills becomes usable (the move mastery we have for punches), lit on her map.
5. Needed beside it: MMA rules per ruleset (legal moves, amateur MMA), MMA kit (rash guard, shorts, 4 oz gloves), MMA
   opponents with grappling numbers, a position strip on the fight HUD.

## In training too (operator S347: "can we use it also in training besides in the fight itself?") - yes
The same clips and the same move map serve the gym, which is how real grappling is taught:
- Drilling a move: on her training page you pick the move to drill on the move map, and the two women play it (the boxing
  move player does this for punches). A drilled move gains mastery and becomes usable in fights (step 4).
- Positional sparring (the real gym's staple): a session starts in one position (e.g. "bottom of side control") and
  plays out on the paper rules for a few minutes. The result is what she learned: escapes found, where she got stuck.
  The film shows the chain she actually took.
- Tie-up drills for the boxers now: the clinch tie-ups (already in) can be a pad-work-style drill in boxing training.
- The 3D gym (later): members on the mat drill with the same clips, so the gym floor gets two-body grappling for free.

## The decision (scope - yours)
- After the boxing career is playable, as the MMA update (as agreed). Claude's pick: the boxing career is closer,
  and the ground work is not lost - the screen, grips, timing and tie-up plans all carry over.
- Now: MMA moves ahead of the boxing demo. Steps 1-5 above, about 3-4 weeks of builds, the boxing career waits.
