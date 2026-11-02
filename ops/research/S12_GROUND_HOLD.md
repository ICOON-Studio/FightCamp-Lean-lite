# S12 — the ground hold, and where the fight actually is when it is on the floor

**Claude, 2026-09-18.** Greenlit as OPTION 3 off S6c's three ways on. Stage is
built and green; **the measurement is the larger half of the result** and it
resizes the ground work that follows.

## Population, named because a fixture is not a finding

The live room's own `MMA_STYLES` — wrestle-grappler against striker, R133's
fixture, the pair that replaced R132's two identical generic men. Shipped
technique catalogue, RamsterZ paired pack, MMA rules, 3 rounds. **Two seeds,
77321 and 810039**, measured to 300 s of show time each by
`Godot/tools/measure_ground_occupancy.gd`.

## 1. The defect, and it is fixed for one position

`_release_grapple` called `settle`, which queues `ROLE_IDLE` — the standing
stance — so both men stood up the frame a ground film ended while the engine
still had them on the floor. S6c made it fire far more often by routing
`mma_guard_gnp` down the same path.

The room now re-enters `grapple_control`
(`Paired_FullMount_Takedown_BodyLock_Loop`, already bound, S6b watched it:
"nothing advances, two men, mount held") as a **resting state** and replays it
while the mount holds. A real beat preempts it rather than being refused.

## 2. THE PREMISE WAS WRONG TWICE, AND BOTH WERE ONE GREP AWAY

**A man's `phase` is not a ground phase.** The obvious reading — the room
already samples `man["phase"]`, and `FightRange.GROUND_PHASES` names
`ground_top`/`ground_bottom` — opens the hold **exactly zero times**. Measured
over 3,601 frames, `phase` takes three values and no others: `measure` (240),
`engage` (4,260), `reset` (2,700). It is the standing RHYTHM word. The
catalogue's ground phases gate which TECHNIQUE may be thrown; where the two men
ARE is `FightRealtime.grapple_of` — `stance`, `seat`, `top`. Same family as
S10's threshold and S8b's premise: **the name that counts a thing is not the
line that does it.**

**And the bought pack is one position.** Every paired film in
`assets/anim/audition/ramsterz/` is `Paired_FullMount_*` — sixteen of them,
all full mount. There is no side-control film, no guard film, no back film.

## 3. WHERE THE FIGHT ACTUALLY IS, AND IT IS NOT MOUNT

Seat occupancy in show seconds, seed 77321, 300 s:

| seat | seconds | of bout | of ground time |
| --- | ---: | ---: | ---: |
| standing / none | 271.5 | 90.5% | — |
| clinch / over_under | 5.5 | 1.8% | — |
| **ground / side** | **14.5** | 4.8% | **63.0%** |
| ground / guard | 4.5 | 1.5% | 19.6% |
| **ground / mount** | **3.5** | **1.2%** | **15.2%** |
| ground / half | 0.5 | 0.2% | 2.2% |

Ground time is 23.0 s, **7.7% of the bout — which lands on S8's 7.3%** and is
the one number here that was already known. Seed 810039 never reached the floor
at all in 300 s (0 ground seconds, 0 grapple events), which is S8's "5 of 40
bouts that never got there" showing up in a two-seed sample.

**MOUNT IS 15.2% OF GROUND TIME, NOT THE MAJORITY.** S8's "mount holds 44.3% of
scored CONTROL TIME" is a scoring weight, not wall-clock occupancy, and the two
were being read as the same thing. **Side control is 63.0%** and the room owns
no film for it.

## 4. WHAT THE HOLD THEREFORE COVERS — the honest number

`hold_entered=3, replayed=0, preempted=3, hold_s=0.40` over 300 s on seed
77321: **0.40 s of the 3.5 s of mount time (11.4%), and 1.7% of ground time.**

It is right where it fires and it fires seldom. Held seconds are counted rather
than entries on purpose (S6b's rule): three entries read identically whether
every hold was taken by the next beat after two frames — which is what happened,
`replayed=0` — or the men lay in a mount for half a round.

**The other 84.8% of ground time still stands both men up**, because holding a
full-mount film through a side control or a guard is M19's lie in a new costume.
Those seats keep today's behaviour and are recorded, not papered over.

## 5. WHAT THIS RESIZES

- **The ground purchase list is a SIDE CONTROL film first, then guard.** S6c's
  Option 2 named `mma_dirty_boxing`/`cage_clinch` as "the first ground-side
  purchase" at 1.93% of action beats. By occupancy, **side control is four times
  the mount's share of floor time and has no film at all.** Rank the buy by what
  the engine actually produces, not by the degrade queue alone — the degrade
  queue counts BEATS, and a held position produces few beats and a lot of
  seconds.
- **`mma_guard_gnp` is bound to a mount film.** S6c bound
  `Paired_FullMount_H2H_Punches` to "Posture and Ground-and-Pound from **Guard**"
  off a watched sheet. The film is a mount. S6c refused `mma_dirty_boxing` on
  exactly this ground ("refused on position"); the same test applied here says
  this binding is a position mismatch. **Flagged, not unbound** — that is a
  content call for whoever watched the sheet, and it is not this stage's to make.
- **`already_playing` was not the bottleneck it looked like.** 68 of 79 routed
  ground strikes are still handed back, unchanged by the hold: they are refused
  against REAL films, not against the resting one. S6c's reading that the hold
  "eats" them does not survive the measurement.

## Reproduce

```
godot --headless --path Godot --script tools/measure_ground_occupancy.gd
godot --headless --path Godot --script tests/fight_grapple_seam_test.gd
```
