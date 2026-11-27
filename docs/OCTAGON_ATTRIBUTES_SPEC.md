# Octagon Tactics (boxing) - fighter ATTRIBUTES, a pool of eight fighters, a draft, then the cup (S570, v4)

Owner S570: "we need to add atrributes that itneract with stats and see how that feels, can you spec that and design the
rules and then a everyone drifts his favorite fighter and compete in the cup ?"

## The seven attributes (1 to 10, 5 = average)
| attribute | what it changes in a fight |
|---|---|
| POWER | damage of every Attack: 1-3 -1, 4-6 +0, 7-8 +1, 9-10 +2 |
| HAND SPEED | speed of every Attack: 1-3 -1, 4-6 +0, 7-8 +1, 9-10 +2 (a speed tie goes to the higher Hand Speed, then Reach) |
| REACH | 7+: +1 speed at Long and +1 damage on the Step-In Jab; 1-3 (a short man): +1 speed at Close |
| CHIN | head health = the class's health base + Chin; ROCKED by (3 + half the Chin, rounded up) head damage in one exchange (Chin 4: 5, Chin 8: 7) |
| BODY | body health = the class's health base + Body; his maximum stamina drops 2 for every (3 + a third of Body, rounded up) body damage |
| CARDIO | maximum stamina = the class's stamina base + Cardio; between rounds 2 + half the Cardio comes back |
| RING IQ | 7+: +1 damage on a Counter; Read Tendencies shows 1 + a quarter of Ring IQ of his cards (rounded down); a counter-against-counter tie goes to the higher Ring IQ |
Every fighter has 42 points across the seven (an average of 6): no fighter is simply better - each is a different shape.
Health keeps v3's x1.1. The v3.1 rules stay (Hold Ground, a counter that answers nothing costs 2, a combo after a block
goes on at half, a Defend straight after a Defend costs 1 more).

## Weight classes (owner S570: "each weight category will have differnet limits/trehesholds")
Bouts are booked inside one class only. Each class sets the CAPS (no attribute above its cap; 42 points still) and the
THRESHOLDS the fight runs on. Grounded on our corpus (ops/research/J20_THE_VALIDATION_CORPUS.md, 8,375 UFC fights, the
nearest published split by class): lighter men land ~36% more strikes a round than heavyweights; knockdowns a fight
rise 0.46 light -> 0.55 middle -> 0.60 heavy; heavyweights finish about half their fights, the lightest go to the cards
about two thirds of the time; heavyweights are the most accurate.
| class | POWER cap | SPEED cap | CARDIO cap | punch weight (every Attack) | health base (head / body = base + Chin / Body) | stamina base (+ Cardio) | target finish rate (bots) |
|---|---|---|---|---|---|---|---|
| Lightweight | 7 | 10 | 10 | +0 | 9 | 11 | 25-35% |
| Welterweight | 8 | 9 | 9 | +0 | 10 | 10 | 30-40% |
| Middleweight | 9 | 8 | 8 | +1 | 10 (was 11: bots finished 31%) | 10 | 40-50% |
| Heavyweight | 10 | 7 | 7 | +1 (and the 9-10 POWER bonus is +3) | 12 | 9 | 50-60% |
The ROCKED line (3 + half the Chin) is the same in every class: heavier men hit harder, so they reach it more often.
THE FIRST CUP is a MIDDLEWEIGHT cup: the eight pool fighters below are middleweights (inside the caps: Jake Brennan's
Cardio 9 became 8 and his Chin 6 became 7). Each class gets its own pool of eight after this one.

## The style decks (20 cards each, from his 52-card database)
- OUT-FIGHTER: v3's Out-Fighter deck (jabs, straights, counters, circle out).
- PRESSURE: v3's Pressure deck (hooks, Overhand, Liver Hook, Cut the Cage).
- COUNTER-PUNCHER (new): Slip & Cross 2, Pull Counter Cross 2, Check Hook 1, Shoulder Roll & Feint 2, Snap Jab 3,
  Straight Cross 2, Lead Left Hook 1, Ripping Liver Hook 1, Tight High Guard 2, Circle Out 1, Read Tendencies 1,
  Step-In Jab 1, Cut the Cage 1.

## The pool (fictional fighters; 42 points each)
| fighter | style | POW | SPD | REA | CHIN | BODY | CAR | IQ | the shape |
|---|---|---|---|---|---|---|---|---|---|
| Diego "The Metronome" Ruiz | Out | 4 | 7 | 9 | 5 | 5 | 7 | 5 | long, quick jab, never tired |
| Ray "Silk" Okafor | Out | 5 | 8 | 8 | 4 | 4 | 7 | 6 | fastest hands, glass chin |
| Jake "Long Night" Brennan | Out | 5 | 7 | 7 | 6 | 6 | 8 | 3 | the 12-round engine, little craft |
| "Iron" Ike Mbeki | Pressure | 8 | 5 | 4 | 8 | 7 | 6 | 4 | walks through anything |
| Tomas "The Truck" Kowal | Pressure | 9 | 4 | 5 | 7 | 8 | 5 | 4 | one punch, slow hands |
| Marco "Body Shop" Duarte | Pressure | 6 | 6 | 4 | 6 | 6 | 8 | 6 | digs to the body all night |
| Sonny "Snapshot" Vale | Counter | 6 | 8 | 5 | 5 | 5 | 5 | 8 | the reader, fragile |
| Lin "Ghost" Hayes | Counter | 5 | 7 | 6 | 5 | 5 | 6 | 8 | slips and makes you pay |

## The draft
Four seats - Claude, John, Kalli, Maria (Gemma sits out: the local model needs 9 GB). A snake draft in a random order
(1-2-3-4-4-3-2-1): each seat picks the fighter it wants to be, with its reason; the second pick is the reserve. Every
seat sees the whole pool card above and the picks so far.

## The cup
A round robin of the four drafted fighters (6 bouts), each seat on its first pick; win 3, draw 1. Each bout ends with
the four scores (FUN / DEPTH / CLARITY / VARIETY) and what would make it 10. Target: FUN 8, DEPTH 7.

## Balance before the draft (bots)
Every pool fighter against every other, reader bots, both corners: each fighter's win rate inside 40-60%; a fighter out
of that band gets one attribute point moved (never a card number changed). Measured on the PC once the owner's game
is closed (it held 7 GB and the PC at 98% RAM).

## Feedback loops
None between bouts (no progression yet). Inside a bout: Body damage -> smaller stamina cap -> fewer cards: capped by
the BODY step and the 4-stamina floor; Chin low -> rocked often -> more damage: capped by Cover Up (halves) while rocked.

## Balance, measured (S570, reader bots that use Hold Ground only when nothing else is legal; 2,240 bouts)
- v3.1's Hold Ground with +1 stamina paid the Pressure decks (bots 61-66%): it gives no stamina now, and a hand whose only
  legal card is Hold Ground / Cover Up still counts as dead and is swapped. v3.1 then: 49-37 / 39-46 / 43-43.
- A jab takes the class's punch weight but not POWER.
- Moved points (never a card number): Body Shop POWER 7->6, IQ 5->6; Long Night POWER 6->5, CHIN 7->6, SPEED 5->7;
  Snapshot IQ 9->8, CHIN 4->5. Middleweight health base 11 -> 10.
- Result: every fighter 42-59% (Iron 59, Body Shop 56, Truck 55, Silk 51, Long Night 47, Ghost 46, Snapshot 44,
  Metronome 42); finishes 38%; comebacks 22%.
