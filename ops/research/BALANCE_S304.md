# Balance choice S304: more upsets, and a round 3 that tires the unfit

Measured with the balancing harness (Lean BALANCE1-3 + tools/balance_options.gd): thousands of simulated amateur bouts
through the game's own round code. Your fighter vs Maria Ortega (fades after round 2) and Priya Nair (steady).

## What we found
1. **A bout is decided almost entirely by the ratings.** Today a boxer 5 points better wins about 100%, 5 points worse
   about 0%, 3 points better about 98%. Almost no upsets. Real boxing has more (exact real numbers: John is
   researching favourite win rates; they set the final value).
2. **Round 3 is not harder, even for an unfit boxer.** Tiredness only costs her when energy falls under 20, and in three
   rounds it never does. Against a steady opponent an unfit boxer (conditioning 50) wins round 1 63% and round 3 63%.

## Real boxing (John, J_UPSETS1_JOHN.md, S305)
- Pro boxing: the betting favourite wins 86% of decided fights (4,536 fights, boxoddsstats). UFC by odds band (7,187
  fights): a slight favourite wins 54-60%, a clear one 69%, a big one 80-89%.
- Amateurs with no favourite: red corner 50.5% (6,589 Olympic/World bouts) - a coin flip.
- His target for our 3-round amateur bout: the favourite wins ~60% at a slight edge, ~75% clear, ~88% big, never above ~95%.

## What I propose (my call as developer; you approve or not)
1. **More luck per round** (round randomness 6 -> **27**, S305 update: 14 was still too certain against John's numbers).
   Measured with the game's real rounds (Lean tools/balance_targets.gd, 800 bouts a row, vs Priya, a steady opponent):

   | Her edge in rating | Today wins the bout | With 14 (first proposal) | **With 27 (proposed)** | Real target (John) |
   | --- | --- | --- | --- | --- |
   | 8 points worse | 0% | 3% | **16%** | - |
   | 5 points worse | 0% | 13% | **27%** | - |
   | even | ~60% | 60% | **57%** | ~50% |
   | 3 points better | 97% | 78% | **66%** | ~60% (slight) |
   | 5 points better | 100% | 91% | **78%** | ~75% (clear) |
   | 8 points better | 100% | 98% | **86%** | ~88% (big) |
   | 13 points better | 100% | 100% | **95%** | never above ~95% |

   Training, the camp, the film study and the corner call still clearly tip it - just not to a certainty. A real
   underdog (5 points worse) wins about 1 in 4.
2. **Tiredness grows from the start instead of hitting a wall at 20:** the less energy left, the weaker the punches,
   up to 6 points when empty. An unfit boxer against a steady opponent: round 1 65% -> round 3 52% (today 63% -> 63%).
   A fit boxer (conditioning 80) barely notices. So conditioning becomes something you train for.

## What it changes in play
More bouts you can lose on a bad night (and win as the underdog), and the corner card's "she's tired, calm her down"
starts to matter in round 3. Nothing else changes: money, rankings and the 3D film read the same results.
