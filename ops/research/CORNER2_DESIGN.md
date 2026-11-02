# CORNER2 - the corner, complete (S159, design D35 pillar 1)

The corner is the heart of the game (DESIGN_ON_PAPER_S159.md section 5). Today (DESIGN_GAP_S159.md): no towel, no
stamina/scorecard on the card, a 60 s clock that never pauses, and only the range half of a call reaches the engine.

## The player's minute

1. **The bell rings -> the fight clock PAUSES** while the corner card is open. The player reads at his own speed;
   "SEND HIM OUT" resumes the clock. (Real boxing has 60 s; the player is not a stopwatch test.)
2. **Read** (top of the card, from the engine's own corner record `FightRealtime._corner_read` - no new numbers):
   - TANK: stamina % and heart zone ("62% - hard").
   - DAMAGE: the worst mark in words ("cut over the left eye, bleeding") - already on the pit-stop card.
   - THE CARDS: the coach's card - rounds won / lost / level, from the per-round consensus the engine scores.
   - THE COACH SAYS: the advice line the engine already composes (`CornerAdvice.advise`).
3. **Choose** - three rows, one pick each:
   - **The plan for next round** (one of): Stick to the plan / Box and move / Pressure / Go to the body /
     Take a breather / Go for the finish.
   - **The cut man** (existing pit-stop jobs: close the cut, enswell, ice, water and survive).
   - **What you say**: Calm him down / Fire him up / Tell him the truth.
4. **The towel**: always on the card, red, with a confirm ("Stop the fight? He loses by TKO."). Ends the bout as
   a TKO for the opponent, stoppage cause `towel`. Available between rounds.

## What each call does in the engine (all multipliers on weights the engine already reads: no new random draws)

| Call | Pace (volume) | Distance | Targets |
|---|---|---|---|
| Stick to the plan | the plan's own curve | plan base | plan base |
| Box and move | balanced | +0.35 m | base |
| Pressure | aggressive | -0.35 m | base |
| Go to the body | balanced | -0.2 m | body x1.6, head x0.8 |
| Take a breather | cautious | +0.35 m | base |
| Go for the finish | aggressive | -0.35 m | head x1.3 |

| Words | Effect next round |
|---|---|
| Calm him down | volume x0.90 |
| Fire him up | volume x1.12 |
| Tell him the truth | behind on the cards: volume x1.12; level or ahead: x1.0 |

A call lasts until the next corner. The fighter's temper (personality) modifying the words is a follow-up slice.

## Switch and byte identity

Switch `corner_wired` (FightWorldLiveScreen, ON in the game, OFF headless = the control arm). OFF writes no key and
offers the original six instructions, so every existing test and the C223 gates are byte-identical. ON writes
`corner_pace`, `corner_volume`, `region_weights_base` only after a player call.

## Acceptance

- Paired test `corner_wired_test.gd`: two DIFFERENT fighters (stats, plans), same seed, two arms identical to the
  first bell, then one corner call apart. Pressure vs Take a breather: round-2 throw count higher under Pressure.
  Go to the body vs Stick to the plan: round-2 body share of landed strikes higher. Fire him up vs Calm him down:
  round-2 throws higher. Control: switch OFF, the same calls change no throw count (only range moves, as today).
- Towel: thrown at the first break -> result is TKO for the opponent, round 1, cause `towel`.
- Stills of the corner card opened before anything is sent to the operator.
