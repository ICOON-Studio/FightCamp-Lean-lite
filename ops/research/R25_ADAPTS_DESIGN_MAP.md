# R25 The opponent adapts - design map (S423)

One of the seven mechanics he chose (S402: "R25 Opponent adapts to your plan by round 2"). Measured BEFORE it was written
(S406's lesson: "test any fight-choice mechanic on the harness before writing it up"). Probes: tools/adapt_probe.gd and
tools/cover_probe.gd, through the game's real bout; the hook is `bout.covered` in LiveRound (default empty = the game today).

## What the measurements say
1. **An opponent who switches GAMES between rounds changes nothing** (adapt_probe, 300 bouts a cell, three styles, three
   corners): every cell within 3 points of win share, inside the noise. The corner's shouts already answer each game as it
   comes. So "she starts pressing instead of countering" is not a mechanic.
2. **Your plan is the lever**: Lucy against a presser wins 20.3% with no plan, 41.3% with a good one (400 bouts). The
   plan's top line earns 64% of round 1's planned edge.
3. **Covering your best line is not enough**: her corner halving it next round costs 0.5 points; erasing it, 2.5.
4. **Waiting for it is**: when she waits for your best line (using it counts as a wrong answer and hands HER the read),
   you lose **6.5 points** (41.3% -> 34.8%). Dropping the line does not win it back (35.0%).
5. **Swapping the line for another right answer does NOT win it back yet**: 34.3% (swapped into slip 2-3, a combination
   Lucy had not drilled), and 34.5% with slip 2-3 drilled to 50 like her others. So in today's fight model, once she
   waits for the line the bout is 6.5 points worse whatever the corner does. OPEN, measure before asking him: why a
   fresh right answer is not worth what the waited line was (its card/situation? the round's lost reads?), and which
   counter (a feint first, the line with a different set-up, film study to see it coming) gives the player a real way
   back. A mechanic that only takes points away is not worth his approval.

## The decision the player makes
In the corner minute after round 1 (round 2 in a 3-round bout is the last chance), the corner card says, in one line,
"Maria's corner has read your 1-1 on her pressing: she is waiting for it." The player chooses:
- **Keep it** (her read stands: the line now loses its exchanges), or
- **Swap it** for another right answer to that game, from the boxer's own moves (the corner's "change one plan arrow",
  already built: this gives it a reason), or
- **Leave the corner's one change for something else** (a habit fix, recover), accepting the cost.
The other corner reads the line only if it was used enough to be read (PlanRead's FREE_USES: 2 uses a round), so a plan
with more than one strong line is harder to read: variety becomes worth training.

## Where it happens
- **Corner minute** (the corner card's top line, 14 words at most, MENU_STRUCTURE_S402): the read line named, the plan arrow
  that answers it pre-marked as the one to change (it is a suggestion, the player confirms).
- **Live fight** (FIGHTDISPLAY2 opponent panel, the habit card): from round 2, "Waits for your 1-1" with an eye icon.
- **After the bout**: The Why: "Maria's corner read your 1-1 after round 1; you kept it: 4 exchanges lost to it."
- **Playbook / plan screen**: a line that got read in a bout carries a small "read by Maria" mark for the rematch.

## Numbers
| What | Number | Source |
|---|---|---|
| Which line she reads | the one with the most planned edge so far, if used 2+ times | PlanRead FREE_USES |
| Waiting for it | the line's edge x -0.5 and it counts as a wrong answer for the round's reads | measured: -6.5 points |
| How often | by her ring IQ: about 1 in 3 bouts at 50, most at 80 (the opponent's ring_iq, RingDuel.mode_bias uses it) | invented |
| The other corner too | the player's corner reads hers the same way (film study helps) | later |

## Status
NOT ASKED (S423): the cost is real, the counterplay is not proven. Next: a Qwen probe task on tools/cover_probe.gd.
