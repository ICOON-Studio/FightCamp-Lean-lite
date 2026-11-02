# Fight night script: the intro and the breaks between rounds (S306, for the operator's approval)

Operator S306: "write the script properly for intro and for in between rounds walk from the corner each time make them sit?
is this a bad idea?"

## Verdict: a good idea, kept short
Real boxing does exactly this, and today the game does not: the round starts with both already in guard in the middle,
and at the bell they freeze where they stand while the corner card draws over them. Week 5 (Kalli K-FIGHT3D1) left the
3D corner out only on cost ("new animation, new cameras and new staging"). The fight works now, so this is the next thing
that makes it look like a real fight night. The one real risk is time: a real rest is 60 seconds, and nobody wants to
watch that ten times. So every part below is a few seconds, and one click skips it.

## How it is done for real (amateur and pro boxing)
- Before round 1: both boxers in their corners; the announcer names each one, and she steps out and raises a glove; the
  referee calls them to the centre for instructions and they touch gloves; back to the corners; "seconds out", the bell,
  and they walk out to meet in the middle.
- At the bell: they stop punching, turn and walk to their own corner (guard down, a normal walk). The stool comes through
  the ropes, she sits, her coach crouches in front of her and talks; a second gives water and a sponge. One minute.
- "Seconds out" 10 seconds before the bell: she stands, the stool goes out, the bell rings, she walks out to the centre and
  puts her guard up.

## The game's script (seconds at 1x; SKIP jumps to the next part)

### Intro (once a fight, about 9 s)
| # | What you see | Camera | Time |
|---|---|---|---|
| 1 | Both boxers in their corners, bouncing in place | wide, the whole ring | 1.5 s |
| 2 | Red is named: she steps forward a pace and raises a glove (caption: her name and record) | close on red's corner | 2.5 s |
| 3 | Blue the same | close on blue's corner | 2.5 s |
| 4 | Both walk to the centre and touch gloves | broadcast | 2 s |
| 5 | They step back into guard, the bell, ROUND 1 | broadcast | 0.5 s |

### Between rounds (each break, about 5 s plus the time you take on the corner card)
| # | What you see | Camera | Time |
|---|---|---|---|
| 1 | The bell: both drop their hands, turn and walk to their own corner | broadcast, following the pair apart | 2.5 s |
| 2 | The stool is there: she sits down; across the ring, the other sits too | wide on her corner | 1 s |
| 3 | The corner card (your call, as today) over her sitting in her corner, breathing harder when she is tired | close on her corner | your choice |
| 4 | "Seconds out": she stands, walks out to the centre; the other comes out too | broadcast | 2 s |
| 5 | Guard up, the bell, ROUND n; the round opens on your call's beats (as today) | broadcast | - |

After a stoppage there is no walk to the corner: the winner celebrates, as today.
In Highlights mode the walks are cut (a quick fade from the bell to her sitting, and from standing to the guard).

## What it needs
1. Clips: sit down, sit (looping), stand up, and an ordinary walk. We have all four free to use: ActionForge (Quaternius
   library, CC0 public domain) sitting_enter / sitting_idle_loop / sitting_exit / walk_loop, already on the UE5 skeleton
   the MetaHumans use. They get baked onto our boxers like the punch clips were.
2. A corner stool: a simple low stool in each corner (made in the game from basic shapes; a nicer model later).
3. A way to walk anywhere: today the two boxers always face each other; the walk to the corner needs them to turn their
   backs and walk (the planted-feet fix from this session keeps the feet from skating).
4. Camera shots: wide on a corner and close on a corner (two new camera positions; the broadcast camera stays).

## Later, not in this first version
- Her coach in front of her on the stool, the second with water and sponge (a person model in a club tee).
- The referee (in the ring all fight; instructions at the centre in the intro).
- The ring announcer's voice and the crowd noise.

## Acceptance (how it closes)
A film of one 3-round fight on the game camera: the intro plays once; at each bell both walk to their own corner with
no foot sliding (tools/sidestep_probe.gd numbers on the walk), sit on the stool with their hips on the seat (a still of
each corner), the corner card shows over the sitting shot, and both walk out to the centre before the bell. Then your eye.
