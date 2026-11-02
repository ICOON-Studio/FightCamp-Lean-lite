# Q179 — Hub Display Evaluation (Qwen lens: training-clip census)

Qwen, 2026-09-26. Branch `qwen/q179-hub-eval`. Model: qwen3-coder.

## What would a human do?

A management-game UI lead decides the hub's look from three questions: what the
player must read at a glance, what must visibly change as the business grows, and
what the team can afford to keep in sync. For FightCamp the answer to the first
question is already decided by the existing screens: the player reads fighter
cards, condition bars, the next-fight alert, and the floor's station occupancy.
The second question — what must *visibly change* — is where the three options
diverge. The third question is where my lens bites: I measured what we actually
own on disk, and the answer is the real cost of option C.

## Current state: what works, what does not

The S80 stills (M34 direction A, brass and leather) read as a coherent gym. The
pins on real objects give the player spatial orientation. What does not work is
the operator's own observation: the picture is the same at 3 fighters and at 30,
after an upgrade and before one. The floor data already tracks `used`/`capacity`
and every station's `condition` — the game *knows* the gym has changed, but the
picture does not. A player who books a fighter to the heavy bag sees the bag's
condition drop on the pin label but the bag in the picture never moves.

## The census: what is on disk

The tool `Godot/tools/q179_training_clip_census.gd` walked every `.glb`, `.fbx`
and `.gltf` under `assets/anim/` and `assets/models/fighters/anim/`. Result:

| Category | Count |
|---|---|
| **Training clips** | **0** |
| Fighting / combat clips | 207 |
| Walkout clips | 25 |
| Rest / idle clips | 13 |
| Other (swords, staff, weapons, get-ups, runs) | 106 |
| **Total** | **351** |

The equipment catalogue (`assets/data/equipment_catalog.json`) has **25 station
types**. Of those, **18 need visible fighter training motion** (bags, ring,
weights, cardio machines, combat mat, tatami, dummy, ladder, plyo rig,
footwork grid, roda, arnis kit, striking locker, ergometer, air bike, exercise
bike). **7 do not** (recovery/medical/analysis: focus-mitt locker, first-aid,
physio table, mobility station, cold tub, rehab pool, sports-medicine room).

**Gap: 18 stations, 0 training clips.** Every single station that would show a
fighter working out in option C needs newly authored motion.

The 207 fighting clips are all combat: RamsterZ H2H punches/kicks/blocks/
dodges/staggers/knockdowns, Cascadeur-authored grappling holds (closed guard,
side control, mount, back control, half guard, open guard, north-south, front
headlock, cage clinch, 50/50, turtle), Motifect martial-arts strikes and
throws, CMU paired rest/fight motions, and one jab-cross-hook combo. None of
them show a fighter *training* — hitting a bag, skipping rope, lifting weights,
working the speed bag, running the ergometer.

The 13 rest/idle clips are T-poses, standing idles, and the Cascadeur rest
reference. They are usable as a neutral pose but not as training motion.

## Option A — Stills (today)

**Gives the player:** immediate spatial orientation, a consistent art direction,
zero runtime cost. The pins carry all the dynamic information (condition,
occupancy, alerts).

**Costs us:** ~54 credits already spent on Higgsfield generations. Tier variants
as the gym grows are more generations — the operator rejected "abandoned gym"
compositions twice, so each tier needs a fresh generation that passes his eye.

**Scales with the gym:** poorly. The picture is static; only the pins change.
At 30 fighters the same four pins on the same picture read as a lie.

**Risk:** low. It ships today. The only risk is the operator's tolerance for
the static picture wearing thin as the gym grows.

## Option B — 2.5D animated rooms (Mad Games Tycoon, Two Point)

**Gives the player:** visible change as the gym grows — rooms appear, sprites
move, the space fills up. The player reads "my gym is bigger" without reading a
number.

**Costs us:** a tilemap/sprite pipeline we do not have. Every station needs a
sprite (or a small sprite sheet for the working animation). The sprites must
match direction A's brass-and-leather palette, which no existing asset pack
does. Cursor's lens covers the Godot tilemap cost; my census does not touch it.

**Scales with the gym:** well — rooms and sprites add linearly.

**Risk:** medium. The sprite art direction must stay consistent with the 3D
fight scenes and the still hubs. A mismatch reads as two different games.

## Option C — Our own 3D engine

**Gives the player:** the most honest representation — the real fighters, on the
real stations, doing the real work. The gym grows visibly because the floor
data already drives station placement. The player sees *their* fighter skipping
rope on *their* cardio floor.

**Costs us:** **18 station-specific training animation sets**, each retargeted
to our 22-bone fighter rig. The census shows we have 0 of 18. We own the rigs
(f01–f12, male and female, multiple weight classes), the RamsterZ and Cascadeur
pipeline, the Marpa arena, and a camera director — but none of that produces
training motion without the clips. Each station needs at minimum an idle loop
and a working loop; the cardio machines and the ring need more (the ergometer
has a distinct motion from the air bike, the ring has sparring vs shadow-boxing
vs pad work).

**Scales with the gym:** perfectly — the floor data already places equipment on
a grid; adding a station adds its animation instance.

**Risk:** high, entirely on the animation gap. The engine can render it; the
clips do not exist. The 351 clips on disk are all combat, walkout, rest, or
weapons — none are training.

## Recommendation

**Start with A, grow into C.** The stills ship today and carry all the dynamic
information through pins. The first slice toward C is one station, one fighter,
one loop: the heavy bag. It is the most iconic training image, the simplest
motion (a repeating punch cycle against a static target), and it proves the
pipeline — rig, retarget, station anchor, camera — without committing to 18
stations. If the heavy bag works in one session, the other 17 are a production
queue, not a technical risk. If it does not work, A carries the game.

**What would prove it right:** one fighter, one heavy bag, one looping punch
cycle, rendered in the hub at the bag's grid position, with the bag's condition
visible on the pin. The player sees their fighter training.

**What would prove it wrong:** the retarget from RamsterZ/Cascadeur to our
fighter rig produces visible foot slide or hand miss on the bag at normal
camera distance. That is a pipeline problem, not a design problem, but it
blocks C until solved.

## Numbers

- Total animation clips on disk: **351** (measured by `q179_training_clip_census.gd`)
- Training clips: **0** (measured)
- Fighting/combat clips: **207** (measured)
- Station types in catalogue: **25** (measured)
- Stations needing training motion: **18** (measured)
- Stations not needing training motion: **7** (measured)
- Gap: **18 stations, 0 clips** (measured)
