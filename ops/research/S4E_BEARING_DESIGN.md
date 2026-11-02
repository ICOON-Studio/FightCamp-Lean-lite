# S4e (4) — BEARING: WHICH WAY A FIGHTER IS FACING, AND WHY IT IS THE PIECE THAT TIES THE THREE PIPELINES TOGETHER

Claude, 2026-09-15. Operator: *"The main focus of each fighter should be to face his opponent 'always', right? So this
maybe solves the bearing issue but you need to do it properly having in mind that the plan is to everything mix
together using higgsfield, engine, blender plugin."*

**This is a design with options and it needs a ruling before it is built.** No code has been written.

## WHAT EXISTS TODAY: NOTHING

`rg -n "facing|bearing|yaw" Godot/scripts/FightRealtime.gd FightIntent.gd FightFootwork.gd RingSpace.gd` returns **one
hit, and it is the phrase "load-bearing" in a comment**. A fighter carries `pos_x`, `pos_y`, `vel_x`, `vel_y` and now
`stance` — and no orientation of any kind. The room's only rotation code (`FightStagePlayer.gd:2218 _global_rotation`)
is per-bone retarget maths, not an actor facing.

So the room has always had to *invent* which way a man points. That is the same hole the operator already saw from the
other end: **"head, torso and feet facing differently"**, and C103 then measured the head at 31.9 deg mean off.

## THE OPERATOR IS RIGHT AS A DEFAULT AND IT MUST NOT BE THE IMPLEMENTATION

"Face him always" is the correct *intent*. Implemented as *facing = the line to the opponent, recomputed every tick*,
it quietly destroys three things this stage has just built:

1. **A turn costs time, and that is what makes an angle worth anything.** If facing snaps, nobody is ever caught square
   or caught turning — and S4e (1) taught `close` to cut a man off. Cutting off buys nothing if the man being cut off
   is already facing you by the time he is cut off.
2. **A fighter is BLADED, not squared.** An orthodox man's chest does not point at his opponent; his lead shoulder
   does. S4e (3) put `stance` and `stance_matchup` into the engine on 2026-09-15, so the offset is available now — and
   an open matchup (one orthodox, one southpaw) blades the two men *differently*, which is exactly the lead-hand
   geometry U18 D3 already prices.
3. **Every clip was authored in a facing.** Higgsfield/ARDY generates ONE actor facing its own axis; the Blender pair
   tool authors two actors on one clock at a fixed relative angle. If the engine has no bearing, the assembler has to
   guess the rotation — which is the invention the operator's eye keeps catching.

## THE THREE OPTIONS

| | what it is | cost | what it buys |
|---|---|---|---|
| **A — derived** | facing is computed from positions wherever it is needed; nothing is stored | nothing; no new state, no seeded fight moves | the room stops inventing. Nothing else: turning is free, nobody is ever out of position |
| **B — carried, with a turn rate** (RECOMMENDED) | `facing` is a fixed-point angle beside `pos_x/pos_y`, turned toward the opponent each movement tick at a capped rate that reads the man | new carried state; every seeded fight moves, so it needs its own switch and a re-baseline | being caught turning; angles that mean something; ONE authoritative number the room and both clip pipelines read |
| **C — B plus the blade and an off-line penalty** | facing carries the stance offset, and a blow arriving outside the defender's facing arc is harder to answer | B, plus it touches the impact ladder and the defence roll | cutting a man off finally PAYS — the reason to do it at all |

**Recommended: build B now as its own slice, then C as a separate one.** That is exactly the shape S4e (3) proved:
one model, one switch, the whole delta on the new side, the old behaviour left at the identity, and a checksum A/B
rather than an argument. Folding C into B would move the seeded pins twice for one stage and make neither attributable.

## THE INTEGRATION CONTRACT — this is the half the operator asked for

Bearing is only worth building if all four consumers read the SAME number. They do not today.

- **ENGINE (authoritative).** `facing` is quantised through `Quantise` like every other position value, carried across
  ticks, and deterministic — no new RNG stream, no new draw. `_run_movement` turns it; nothing else writes it.
- **ROOM (Godot).** `FightStagePlayer` rotates the actor root from the event's facing instead of guessing. The
  action event already carries `place`, `band` and `stance_matchup`; `facing` and `relative_bearing` join them.
- **BLENDER PAIR TOOL.** A pair is authored at a fixed relative angle, and today the record does not say which.
  **`min_gap_m` / `max_gap_m` already gate a pair on DISTANCE — bearing gets exactly the same treatment**: the pair
  record gains `authored_bearing_deg` and a tolerance, and `_present_pair` refuses a pair whose authored angle does not
  hold where the men are standing, the same way it already refuses one that is out of range. That is the whole
  mechanism, reusing a path that is already written and already tested.
- **HIGGSFIELD.** A generated clip is one actor facing its own axis. Bearing is what tells the assembler how far to
  rotate that clip's root before it is composited onto the pair clock — and it is why a single-actor catalog can be
  assembled at all.

## THE REALISM RULE, AND WHAT HAS NO STUDY

**The turn rate has NO STUDY.** No published figure gives a fighter's degrees per second, and inventing one is the
defect U84's "boxing step 0.2-0.8 m" was removed for.

**It is measurable with the instrument already built.** The 17 MediaPipe tracks hold both shoulders every frame, and the
normal of the shoulder line IS the facing. `TASK_U109` already measures direction changes from those tracks; extending
it with a *shoulder-line yaw rate* (deg/s, p50 and p90, per fighter per segment) bounds this number from real footage
instead of from a guess. **That extension should be written into U109 before it is launched** — it is the same pass over
the same files.

Until it lands, B ships with the rate labelled AUTHORED and the gate is a geometry one, as S4e (1)'s was: a man's
facing must converge on the line to his opponent, must never overshoot it, and must be byte-identical to HEAD with the
switch off.

## WHAT IT MOVES

Every seeded fight, because movement changes. S4e (1) moved four recorded sweeps and ten judge cards; S4e (2) moved
thirteen. Budget the re-sweeps, re-find each pin from the test's own printed actual, and never tune a constant to put an
old number back.
