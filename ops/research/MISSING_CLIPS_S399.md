# Boxing clips: what we have, what is rated, what is missing (S399)

Operator S399: "its also all other move animations we are missing too, and those we have, have they been rated".
Source of HAVE: ops/Tools/lean_anim_catalogue.py (read from the game's scripts). Ratings: clip_rate_batch.py (Ollama
gemma4, LOW TRUST, ranks only) + older checks in AgentComms/clip_verdicts.json. Nothing is VERIFIED (bar: his OK or a
9/10 judge): 0 of 153.

## Have (in the fight: 122; in the library, never picked: 31)
| group | in game | what it is |
|---|---|---|
| Guard and footwork | 15 | 1 guard idle, 6 fidgets, 4 tired idles, 4 locomotion loops (advance, retreat, strafe L/R) |
| Punches | 57 | jab, cross, lead/rear hook, lead/rear uppercut, body shots - each plain / a-b-c / hard / hurt / miss / special |
| Defence | 6 | to-block, slip L/R, weave L/R, pull back |
| Getting hit | 24 | head hits by jab/cross/hook/uppercut, gut shots, combos |
| Knockdowns, knockouts, wins | 17 | 3 count-downs, 8 knockouts, 7 wins |
| Clinch and ring entry | 3 | one clinch pair, the ring entry |

## Missing, by what the player sees (first = most seen)
1. FOOTWORK (every second of every round): real step-in / step-out / lateral steps / pivots / circling as captured clips
   (we have 4 loops + a procedural rig - WALK1 measures it squashed and gliding), a cut-off step, the bounce-to-flat change,
   stepping back to the ropes, turning off the ropes. Walk to the corner and back (the corner walks are af_walk, a street
   walk). No captured pivot at all.
2. DEFENCE beyond 6: parry (catch the jab), high guard / cover-up under a flurry, shoulder roll, roll under a hook, step-back,
   duck, block body shot with the elbow; a counter off each (slip-cross, roll-hook, pull-counter).
3. HURT AND TIRED: wobble / legs buckle (not down), holding on, arms dropping from fatigue between exchanges, a stumble into
   the ropes, back to the ropes taking shots, getting up from a knockdown (we have the count, not the rise).
4. PUNCHES we lack: feints (jab feint, shoulder feint), double jab, overhand, check hook, body jab, shovel hook as its own,
   punches thrown while moving (step-in jab, pivot hook), a punch caught on the gloves (the shooter's side of a block).
5. PAIRED (two people captured together - none exists in any library, S399 Dola research): clinch entry / tie-up / referee
   break / push-off, a glove touch, the referee separating.
6. RING RITUALS: glove touch, named-in-the-ring raise, the referee's instructions stance, the walk back to the corner,
   sitting on and rising from the stool (we have ActionForge sit clips, judged as staff motion).

## Where clips come from (S399, ops/research/DOLA_INTROCLIPS_S399.md - to verify)
MoCap Online Punch PRO (what the fight plays now), Rokoko library, ActionForge, Mixamo (free; capture origin unclear), Fab
boxing packs. Paired two-person moves: our own capture day (~$2.5-3.5k studio, Dola estimate) - his call, after the
rebuild design passes its critics. Order of work: footwork first (operator S399), then defence and hurt, then the rest.
