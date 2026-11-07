# HUD tired read (S395): proposal, nothing built

## The fault
Blind review, S394: the HUD scores 5/10. Each boxer's rings carry six small numbers, so 12 are on screen (10-12 in the review). Nobody can tell who is tired in 2 seconds.

## What he asked for
S369, on the ring: "also add numbers here?". The code comment records the purpose: the corner can read who is more tired without judging arc lengths. So the need is the tired read. Six numbers per boxer was how it was met, and it no longer meets it.

## Options
| | On screen | Keeps every number | Cost |
|---|---|---|---|
| A. Add only | A big stamina number in each ring's centre, all small numbers stay | Yes | Solves the read, the clutter stays |
| B. Recommended | A big stamina number in the centre, the other five numbers only when that part is low | On hover, and whenever they matter | A fresh boxer shows one number, a worn one shows what is worn |
| C. Stamina only | A big stamina number, no others on the ring | Hover only | Cleanest, but head and legs lose their number in a bad moment |

## Details for B
- Centre number takes the stamina band colour. HURT takes the centre while she is hurt, because it matters more for those seconds.
- "Low" means the arc's own band change, which already pulses, so no new rule is needed.
- The corner card keeps its table, so every number is still there between rounds.
- Touches the fight HUD only (`HudBars.gd`, the ring draw). No menu or shared bar changes.

## Test before he sees it
Short film, one round and the corner. Blind reviewer answers "who is more tired?" from stills at 2 seconds each, with the rings' true values hidden from the reviewer. Bar: 7/10, and the right answer on every still where the gap is 10 points or more.
