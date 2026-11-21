# STEPS PAYOFF SCOPE (S533) - a step must pay where it takes you, or no number can make it worth learning

## The finding (docs/TREEVALUE9_RESULT.md S533 TREEVALUE11-13)
cut_off measured with each effect off (none is the cost), x5 (worse), and x5 benefits with no cost (still loses). Its payoffs -
the opponent drained, her range game cut, the ropes count - do not reach the result; the exchange it spends does. In the code a
place (own_ropes, opp_ropes, corner, inside, ...) changes an exchange only by which plan line fires, the card's mean at that
place and a style multiplier; being on the ropes is not an edge in itself. So sizing StepEffect.TABLE (the plan since S528)
is the wrong method: a number on an effect the round does not read is a guess (CLAUDE.md item 8).

## What real boxing says (the design rule to build)
A boxer with his back on the ropes cannot use distance: no step back, no range game, his guard takes more, and the man in
front of him throws his power shots. A cut-off ring is paid for by the next exchanges, not by the step. Tying up, stepping
out, rolling out are paid by what they deny (the exchange the opponent loses), not by a number on themselves.

## Phases (each measured with tools/treevalue_probe.gd before the next; control arm = the place not read)
1. AUDIT (no game change): for each of the 8 places and each of the 10 steps, list what the exchange reads at that place
   today (code refs) and what the step costs (the exchange it spends). One table. Measure the win share of an exchange that
   starts at each place, both corners, 400 bouts.
2. THE PLACE PAYS: an exchange that starts at opp_ropes / corner gives the one who put her there a bounded edge read in ONE
   place (the exchange odds), and takes the trapped boxer's range moves away (they cannot fire there); own_ropes the mirror.
   Size from phase 1's measured place shares, never guessed. Probe: cut_off FOR Out-boxer reaches +1.5..+5.
3. THE STEP SPENDS LESS WHEN IT IS RIGHT: a planned step in its BEST situation costs no exchange (it happens with the next
   punch line) - real footwork is part of the punch; in a WRONG situation it costs the exchange as today.
4. Re-run the gate for all 10 steps (StepValue targets); only then any TABLE sizing that is still needed.
Each phase: one commit, its probe result in docs/TREEVALUE9_RESULT.md, the owner sees the gate table.

## Not in scope
No fight3d change (METHOD). No new step. The owner's "three in a round on your count = the next exchange is on the ropes"
(Q-S294-231) stays as the way ropes happen; this scope makes being there matter.
