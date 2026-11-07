# Fight tests, S396: fight polish from the S395 5.5 review

Blind, one fresh judge per round (general-purpose, Opus 5.5, eyes on the video), control arm = the S395 film (hud15), key hidden, neutral names. Short films (`tools/fight3d_film.gd short`: round 1 fast, the bell, the whole corner minute, round 2 opens), E:/FightCamp/tmp/s396/film/. Nothing shown to the operator: under 7.

| Change | Commit | Measured / seen on film | State |
|---|---|---|---|
| Corner joins named no target: the join smoother waited for the last fight clip, so every corner join on a boxer was a cut | cab927e3 | smoother state ready, blend clock 0 to 0.8 s on ow_walk (was never ready); film: guard drops over ~0.5 s on camera (was one frame) | merged |
| Guard into the walk: join 0.22/0.8 s, ground speed eases in with it; walks carry on through waypoints | 1734190e | corner_film feet planted, failures 0 | merged |
| Corner card fades in 0.5 s after the cut (was on the cut) | 1734190e | film: cut 0:45.1, card from 0:45.5; judge: "fades in on a held shot, no ghost frame" | merged |
| Beside the card, two-shots frame her face (the mid-point left her under the card) | 1734190e | film: her face stays left of the card | merged |
| Near depth-of-field blur off on corner lenses | 1734190e | no change to the "see-through" second (not the cause) | merged, harmless |
| Big-shot slow motion skipped when the thrower blocks the sight line | 1734190e | fight_polish_test geometry 3/0; not seen on film (no blocked big shot in this seed) | merged |
| "See-through" second: tried far blur and no motion blur, neither changed it; crop showed opaque clothes, a near-black shirt melting into the dark hall behind faded ropes. Seconds wear their corner's colour, muted | cab927e3 | judge round 2: "not see-through", reads in red | merged |
| Hands come down 0.5 s after the bell (both stood frozen in guard 2.6 s) | 04ff1b8d | film: guard down by bell + 1.4 s | merged |
| Sitting shot aims between seat and face (cropped her head while she stood); wide corner shot 0.8 -> 1.0 m, fov 30 -> 35 (second's head cut) | 04ff1b8d | film: heads in frame; judge 2 still calls the walk into the corner tight (coach's head) | merged |

## Blind scores (overall, glance, stamina, transitions, action, walking)

| Round | Control (S395) | New | Preferred |
|---|---|---|---|
| 1 (film p5) | 5 / 5 / 5 / 4.5 / 5 / 5 | 5.5 / 5 / 5 / 5.5 / 5 / 5.5 | new, by ~0.5 |
| 2 (film p6) | 5 / 5 / 5 / 5 / 4 / 5 | 5.5 / 5 / 5 / 5.5 / 5 / 5 | new, by ~0.5 |

Transitions 4.5-5 -> 5.5. Overall 5 -> 5.5 on both rounds. Stopped here: both judges' remaining faults are bigger than polish.

## What holds the fight under 7 (both judges)
- Hits do not sell: no hit reaction strong enough to read a blow; up close a landed shot looks like a blocked one ("READ IT! lead hook" is a tangle).
- Corner card: a wall of small text over two-thirds of the frame.
- HUD: "MARIA ORTEGA AHEAD" is tiny; red 62 vs blue 65 does not say who is winning; the corner's top strip is unreadable.
- The coach stands with folded arms and does no work on her.
- The walk into the corner (`behind` shot) is tight: the coach's head leaves the top of the frame.

## Traps
- A hand-height probe read from `_process` sees the clip's pose before the skeleton modifiers: it showed a one-frame drop even after the smoother was blending. Read the smoother's own state, or the film.
- The PC crashed a render on memory at exit (RAM 95%, a game of his at 9.5 GB); the film itself was complete.
- The cloud film (`-f only=film`) gave 4.7 s in 45 min on the software GPU: unusable, review films stay on the PC.
