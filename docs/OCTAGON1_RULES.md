# OCTAGON1 - the rule calls for the boxing cup (S570)

The owner's design: ops/research/octagon/Octagon_Tactics_Official_Rulebook.pdf and ..._Complete_MMA_Card_Game.pdf.
Owner S570: "fix whaever you think and make a small cup between agents including you and then revweiw and report how
fun it was and how to get better". The engine: proto/octagon/engine.mjs (pure), versus_oct.mjs (two sealed players),
sim.mjs (bots). Boxing only (one art first, S549): the 9 boxing cards + Cut the Cage, Circle Out, Read Tendency, Second Wind.

## Contradictions between the two PDFs - how each was settled
| | rulebook | card deck | the cup uses |
|---|---|---|---|
| exchanges a round | 7 | 6 | 6 (shorter bouts for agents) |
| Defend v Feint | "RESET: Defender +2, Feinter controls range" | "Defend loses to Feints" | the rulebook: the defender recovers, the feinter's own step happens |
| a card that says "Beats X" against the triangle (Level-Change Fake beats Defend) | - | - | not in the boxing set; rule kept for later: a card's own text wins over the triangle |

## Changed because it was broken (measured or impossible)
- **Check Hook could never answer anything**: it was Mid-only and it answers a man stepping in, but the only stepping
  attacks (Step-In Jab, Cut the Cage) are played from Long. Now Long or Mid. Same for Slip & Cross (it answers the jab).
- **Defend covers one zone** (owner S570: "defend is up or down right ? body punch cna break high guard"): High Shell
  and Philly Shell stop HEAD attacks only - the Liver Shot goes under both. Philly Shell no longer "negates all boxing
  attacks", and no longer gives +1 speed; it recovers 1 (High Shell 2, was 3; High Shell keeps its 1 chip damage).
- **A Counter beats only the attacks its card names** (Slip & Cross: straight punches; Pull Counter: hooks and
  uppercuts; Check Hook: a man stepping in). Against another attack it whiffs (-2 stamina) and the attack lands. This is
  the read the triangle needs - it was in his card texts already.
- **Health x1.5** (bots, 300 bouts a pairing): at the PDF's 14-16 health 66-91% of bouts ended by KO in round 1-2
  and the Pressure Boxer won 58-60% of random bouts; at x1.5 KOs are 22-25% and the two styles 44-45% each (reader v
  reader). x2 left almost no KOs (0-2%).
- Out-Fighter "Move Out cards cost 0" -> 1 less (min 0): at 0 his Pawing Jab, Check Hook and Circle Out were free.
- Circle Out: halves an attack (it is footwork, not a guard). Second Wind: blocks nothing (you are breathing).
- Read Tendency (no hand peeking in a card game played by message otherwise): you see his hand next exchange, he cannot
  repeat the card he just played, you draw 1.

## Kept exactly as he wrote it
The triangle, the Lead (+2 speed, combos, lost on a block / counter / Defend / round end), Combo Bursts (up to 3 cards,
+1 speed and +1 stamina each, a finisher +2), Rocked at 4+ head damage (Pressure Boxer 5+, his Iron chin), body damage
lowering the stamina cap, cage space and the fence, the Liver Shot cap drop, the 10-point must judging.
