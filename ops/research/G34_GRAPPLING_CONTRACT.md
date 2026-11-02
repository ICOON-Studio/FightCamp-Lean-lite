# G34 — Grappling contract for the real-time tick engine

Study only. No code. Written so the next build task can be specified from this
page. **Author: Grok, 2026-09-09**, assigned as G34 and driven in-session.
17 sources. Spliced in by Claude; Grok has no checkout.

Engine constraints this must fit: 20 Hz deterministic ticks, fixed-point
positions, named RNG streams, caller-owned rolls, one judge adapter that already
has empty counters `control_score`, `takedowns_round`, `position_points_round`,
`submission_attempts_round`, `throw_points_round`.

---

## 0. Recommendation in one paragraph

Model grappling as a small discrete state machine plus a handful of events, not
as a second analog minigame. Three layers of stance (`standing`, `clinch`,
`ground`) and five ground seats (`guard`, `half`, `side`, `mount`, `back`) are
enough to score judo, freestyle wrestling, IBJJF-style BJJ, and unified-rules
MMA from the same log. Control is a duration accumulated every control-cadence
tick while a fighter holds a dominant seat. Takedowns, throws, passes, sweeps,
exposures, step-outs and submission attempts are events. A submission *finish*
is a rare outcome of an attempt that has already been logged, not a separate
sport. This is closer to how UWW and IBJJF already think (named action + hold
time) than to EA UFC's analog transition stick, and it is the only shape that
will fill the five existing counters without carrying floats across 18,000 ticks.

Two approaches compared, then the rest of the page is the chosen one.

| Approach | What it represents | What it refuses | Fit for 20 Hz + seed |
|---|---|---|---|
| A. Analog transition (EA UFC, UFC 4 grounded) | Continuous struggle on a stick / meter | Named events; replay of a single moment is a slider not a fact | Poor. A float held across ticks was already ruled out. Adding a second analog channel perturbs timing and cannot emit integer counters. |
| B. Event + seat + duration (UWW / IBJJF / IJF as recorded by a scorer) | A position is a seat. A score is an event or a held count. | Finger-level grips, gi physics, full 3-D entanglement | Good. Events are discrete. Hold time is integer ticks. One roll per attempt, caller-owned. |

Choose **B**. Inference: the existing impact path (seven draws, named stream,
adapter fold) already is B for striking. Grappling should look like that, not
like a new genre.

---

## 1. Minimum event vocabulary

Eight events. Each is emitted at most once per resolution, never as per-tick spam.

| Event | Trigger | Counter it fills | Notes |
|---|---|---|---|
| `clinch_engage` | Standing pair close enough and a clinch attempt succeeds | none directly; opens control accrual | Needed so ground is not the only way to hold a man. |
| `clinch_break` | Separate or referee restart | stops clinch control | |
| `takedown` | Offensive fighter takes the other from `standing` or `clinch` to a ground seat and keeps top | `takedowns_round` += 1 | Quality lives on a `grade` field, not a second event. |
| `throw` | Takedown whose grade is high enough to be a throw (amplitude / back exposure on landing) | `throw_points_round` += grade points | Judo and UWW both distinguish "taken down" from "thrown". One event with a grade beats two taxonomies. |
| `position_change` | Seat changes and the new seat is held for a hold-threshold | `position_points_round` += table value | Pass, sweep, mount, back, knee-on-belly, reversal all collapse to this plus `from`/`to`/`kind`. |
| `exposure` | On the ground, defender's back is turned past the danger angle | `position_points_round` += 2 (UWW) | Wrestling-specific, cheap to emit, ignored by MMA/BJJ adapters. |
| `step_out` | A fighter's supporting feet leave the contest area while standing/clinch | `position_points_round` += 1 for the other man (UWW) | Same: emit always, score only under wrestling. |
| `submission_attempt` | A legal finishing hold is locked long enough to count as an attempt | `submission_attempts_round` += 1 | A later `submission_finish` is an *outcome flag on this attempt*, not a ninth event type. |

`control_score` is **not an event**. It is the integral of dominance (section 2).

That is the whole vocabulary. Do not add "single-leg", "double-leg",
"body-lock", "arm-drag" as events. Those are flavours of `takedown` for
presentation. Inference: the judge adapter already wants counters, not a
technique encyclopedia.

### Event payload (proposed)

```
{
  kind: String,          # one of the eight names above
  actor: int,            # fighter id
  target: int,
  from_seat: String,     # see section 2
  to_seat: String,
  grade: int,            # 1/2/4 for throws and takedowns; 0 otherwise
  held_ticks: int,       # ticks of stability after the change
  finished: bool         # only meaningful on submission_attempt
}
```

Fixed-point only. No floats on the log line.

---

## 2. State: seats, not a pose graph

### Layers

```
stance:  standing | clinch | ground
seat:    none | over_under | guard | half | side | mount | back
top:     fighter_id | -1
```

- `standing` + `seat=none` + `top=-1`
- `clinch` + `seat=over_under` + `top` = who has the better lock (or -1 if even)
- `ground` + one of `guard|half|side|mount|back` + `top` = the man not on his
  back / not in guard

Is standing/clinch/ground enough by itself? **No.** IBJJF will not score without
distinguishing guard from mount. UWW will not score without a way to mark
danger/back. Five ground seats are the minimum that maps to those rulesets.
Knee-on-belly is `side` with a flag, not a sixth seat — IBJJF gives it 2 points
after a 3-second hold, which is a `position_change` kind, not a stance.

### What a transition costs

Every legal edge is one attempt, one caller roll, one stamina debit.

| From → to | Typical cost (stamina units, cond 50) | Hold-threshold before it scores |
|---|---|---|
| standing → clinch | low | 10 ticks (0.5 s) |
| clinch → standing (break) | low | none |
| standing/clinch → ground (`takedown`/`throw`) | high | 20 ticks (1.0 s) for "kept top" |
| guard → half / half → side (`pass`) | medium | 60 ticks (3.0 s) — IBJJF three-second rule |
| any bottom → top (`sweep`/`reversal`) | medium-high | 60 ticks |
| side → mount, mount → back | medium | 60 ticks |
| any ground → standing | medium | none |

Hold-threshold is counted in ticks at 20 Hz so we never store a float clock.
3.0 s = 60 ticks is the IBJJF number; use it as the universal stability gate.
Judo osaekomi uses a longer gate (10 s / 20 s) applied by the *adapter*, not by
the engine: the engine only emits "held in `side|mount` with `top=X` for N
ticks". Inference: one stability gate in the engine, ruleset-specific conversion
in the adapter, matches how the impact log already works.

### How control is held over time

`control_score` is duration of a dominant seat.

Each tick on the existing scoring cadence (TickBudget `scoring` = every 20 ticks
at 20 Hz, i.e. 1 Hz of scoring):

- if stance is `clinch` and `top` is set: add 1 control unit to `top`
- if stance is `ground` and seat is `side|mount|back`: add 2
- if stance is `ground` and seat is `half`: add 1
- if stance is `ground` and seat is `guard`: add 0 to the man in guard, 0 to the
  man on top (guard is not control for MMA or wrestling; BJJ does not give
  control points for holding guard either)
- standing: add 0

Units are integers. A three-minute round of mount is 180 scoring ticks × 2 = 360
control units. The adapter can rescale per ruleset. This is the only honest way
to fill `control_score` — it is a duration, so it must be ticked, not evented.

Do not store a float "control meter" on the fighter. The log + the per-round
counter is the meter.

---

## 3. Resolving a takedown from attributes we already have

House pattern: the module is pure, the caller passes `roll: float` in 0..1.

Proposed signature (next build, not this file):

```
static func takedown_resolve(
	attacker: Dictionary,   # grapple, power, technique, speed, fight_iq, conditioning
	defender: Dictionary,   # grapple, defense, speed, fight_iq, conditioning
	from_stance: String,    # standing | clinch
	fatigue_atk: float,     # 0 fresh .. 1 empty, from FatigueCurve
	fatigue_def: float,
	roll: float
) -> Dictionary             # { success: bool, grade: int, to_seat: String }
```

Suggested arithmetic (tunable; this is a recommendation, not a citation):

```
off = 0.45*grapple + 0.20*power + 0.15*speed + 0.10*technique + 0.10*fight_iq
def = 0.40*grapple + 0.30*defense + 0.15*speed + 0.15*fight_iq
off *= FatigueCurve.technique_multiplier(fatigue_atk)   # inference: takedowns fail with sloppy feet first
def *= FatigueCurve.defense_multiplier(fatigue_def)
p   = clamp(0.50 + 0.012*(off - def), 0.08, 0.88)
success = roll < p
```

Grade when successful:

- `roll` in the hardest third of the success band, or `power` clearly higher →
  `grade = 4` (throw / feet-to-back)
- otherwise `grade = 2` (plain takedown)

`to_seat` defaults to `guard` on a contested shot, `half` or `side` on a
high-grade throw. Inference: most MMA takedowns land in guard; most judo throws
that score ippon never need a ground seat because the throw itself ended the
exchange — the engine still lands them in `side` so MMA can continue.

Clinch entries use the same function with a lower power weight and a higher
grapple weight. Same roll contract.

One named RNG stream, e.g. `grapple`, so striking's seven-draw impact stream is
untouched.

---

## 4. What grappling costs

A round of being held is not a round of being punched. It is also not free.

Recommendations, all in the same units FightStamina already uses (positive
drain, `apply` owns the sign):

| Situation | Drain shape | Attrition |
|---|---|---|
| Driving a takedown | ≈ `strike_drain` of force 0.6 per attempt | none on miss; body wear on the shooter if stuffed |
| Sprawl / stuff | ≈ `strike_drain` of force 0.4 | body |
| Holding mount/back (top) | low per scoring tick, higher than `hold` movement | pressure into chest/ribs of the man underneath |
| Stuck under mount/back | medium per scoring tick — isometric | body_condition on torso + a slow leak on head_neck from posture, **not** a punch |
| Locked in a submission attempt | high on both men | none until a finish; then the finish ends the fight |
| Clinch stall | ≈ `circle` movement | none |

Do not convert control time into head_neck damage. That is how we would quietly
grow a second damage model, which G32 already refused. Body-condition drip from
*pressure* is allowed because it is the thing that makes a held man look slower
in the next stand-up, and it is still the existing body channel.

Conditioning already scales FightStamina drains. Do not invent a second
conditioning term.

---

## 5. Submissions: attempt vs finish

An **attempt** is a hold that has been locked long enough that a referee or a
commentary box would name it. Proposed gate: 20 ticks (1.0 s) in `mount` or
`back` (or a front headlock from `clinch`) with the attacker choosing a
submission. That emits `submission_attempt` and increments
`submission_attempts_round` once.

A **finish** is the attempt reaching a tap/out. It sets `finished=true` on that
attempt and ends the contest. It does not increment the attempt counter a second
time.

Progress is an integer 0..100 on the attempt, advanced on the scoring cadence,
not every movement tick.

```
advance = (atk.grapple + atk.technique + atk.fight_iq)
        / (def.defense + def.grapple + def.fight_iq),
          then scaled by FatigueCurve.defense_multiplier on the defender
          and FightStamina tank on both
finish  = progress >= 100 AND roll < finish_p
```

`finish_p` must be small even at 100 progress. Target:

- **About 19–20% of MMA fights end by submission.** GrapplerHQ's 8,591-bout UFC
  set: 1,659 submissions = 19.3%. Fightomic all-UFC: 19.55%. Fares et al. on
  numbered PPVs UFC 1–294: 19.8% of 3,123 fights. Treat **one fight in five** as
  the fight-level ceiling, not the attempt-level rate.
- Most fights that contain grappling contain more than one look at a neck or a
  limb. Inference (not in those papers): a committed attempt finishes on the
  order of **1 in 6 to 1 in 8**. If a typical MMA bout logs 0–2 attempts, that
  reproduces ~20% fight-level finishes without turning every mount into a tap.
- Judo and IBJJF finishes are allowed to be more common *when the ruleset is a
  grappling match*, because the adapter can raise `finish_p`. The engine still
  emits the same attempt.

Rarity lives in `finish_p` and in how rarely an attempt is allowed to start
(must already be in `mount`/`back`/`clinch` with a headlock), not in a hidden
extra roll the module draws itself.

---

## 6. Ruleset map

The engine emits the vocabulary in section 1. Each adapter reads it. Damage
stays at 0.0 weight for the three sports that do not score punches.

### Judo (IJF)

Needs: ippon, waza-ari, osaekomi time. Does not need guard passes.

| IJF thing | Our event / state |
|---|---|
| Throw, control + force + back | `throw` with `grade=4` → ippon |
| Near-ippon throw | `throw` with `grade=2` → waza-ari |
| Two waza-ari | adapter sums, not the engine |
| Osaekomi | held `side` or `mount` with `top` set; 10 s = 200 ticks → waza-ari, 20 s = 400 ticks → ippon |
| Submission | `submission_attempt` + `finished` → ippon |
| Shido / passivity | **refuse** (section 7) |

### Freestyle wrestling (UWW)

Needs: takedown 2, feet-to-back 4, exposure 2, reversal 1, step-out 1, fall.

| UWW thing | Our event / state |
|---|---|
| Takedown, 3 points of contact, pass behind | `takedown` `grade=2` |
| Feet-to-back / high-amplitude throw | `throw` `grade=4` |
| Exposure, back past 90° | `exposure` |
| Reversal | `position_change` kind=`reversal` |
| Step-out | `step_out` — already have a 1-D line; a fighter past the ring/mat edge is a step-out |
| Fall / pin | held exposure long enough; adapter, not a ninth event |
| Activity / passivity clock | **refuse** |

### BJJ (IBJJF)

Needs: the point table and the 3-second rule. Advantages optional.

| IBJJF thing | Our event / state |
|---|---|
| Takedown 2, held 3 s | `takedown` + 60-tick hold |
| Sweep 2, held 3 s | `position_change` kind=`sweep` |
| Guard pass 3, held 3 s | `position_change` `from=guard\|half` `to=side` |
| Knee on belly 2 | `position_change` kind=`knee_on_belly` (seat stays `side`) |
| Mount 4 / back 4 | `position_change` `to=mount` or `to=back` |
| Advantages | adapter may count failed `position_change` that passed 20 ticks but not 60 |
| Submission win | `submission_attempt.finished` |

### MMA (Unified / ABC)

Needs no point table. Needs the five counters filled so the existing profile
(`control 0.9`, `takedowns 3.0`, `positions 1.0`, `submissions 1.5`) has numbers.

| Unified criterion | Our fill |
|---|---|
| Effective grappling | `takedowns_round` + `position_points_round` + `submission_attempts_round` |
| Control of the fighting area | `control_score` from section 2 |
| Submission threat | attempts, not only finishes |
| Cage/fence rides | map onto `clinch` with `top` set; do not add a fence state |

### Taekwondo (WT) — not grappling

The brief names taekwondo next to judo and wrestling because its profile also
weights `damage` at 0.0. That is a **striking-classification** hole, not a
grappling hole. WT scores punch-to-body 1, kick-to-body 2, kick-to-head 3,
turning extras on top. The impact record already has a target region and a
contact word. Filling TKD means tagging `contact` as `punch|kick` and reading
the region, which is a different module. Do not pretend a head kick is a
`throw`. Out of this contract; listed so the next task does not "solve" TKD by
adding a clinch.

---

## 7. Refuse

Out of scope, with reasons.

- **Gi vs no-gi clothing physics.** Two rulesets, not two engines. A `gi: bool`
  on the ruleset profile is enough if we ever need grip advantage; cloth is not
  a tick object.
- **Finger-level grips, underhooks as entities, wrist rides.** Presentation
  flavour. They do not fill a counter.
- **Analog transition meters / stick minigames.** Ruled out by the
  float-across-ticks ban and by replay.
- **Passivity, stalling, shido, activity clocks.** Referee personality, not
  fighter physics. They make the sim feel officiated rather than fought, and
  they need a second AI.
- **Cage as a third spatial axis.** We have a 1-D line. Clinch-against-the-edge
  is `clinch` plus RingPlace, which already exists.
- **Healing or bleeding of grappling damage.** G32 already refused a second
  trauma model.
- **Converting control time into head_neck punch damage.** Same reason.
- **Technique names as events** (uchi-mata, double-leg, kimura). Log `kind` +
  `grade` + `to_seat`. Name them in the broadcast layer later.
- **Taekwondo as grappling.** Section 6.
- **A second fight engine.** The point of this study is to retire the atomic
  engine for the three bouts it still owns, not to grow a third.

---

## 8. Proposed contract the next build can type in

**States** (exact strings):

```
STANCES := ["standing", "clinch", "ground"]
SEATS   := ["none", "over_under", "guard", "half", "side", "mount", "back"]
```

**Events** (exact strings):

```
EVENTS := [
	"clinch_engage", "clinch_break",
	"takedown", "throw",
	"position_change", "exposure", "step_out",
	"submission_attempt"
]
```

**Counters** (already exist; this is who writes them):

| Counter | Writer |
|---|---|
| `takedowns_round` | each successful `takedown` or `throw` |
| `throw_points_round` | `throw.grade` (2 or 4) |
| `position_points_round` | table below |
| `submission_attempts_round` | each `submission_attempt` |
| `control_score` | scoring-cadence integral, section 2 |

**Position point table** (engine units; adapters may rescale):

| kind / to_seat | points |
|---|---|
| pass → `side` | 3 |
| sweep / reversal | 2 |
| → `mount` | 4 |
| → `back` | 4 |
| knee_on_belly | 2 |
| exposure | 2 |
| step_out (awarded to the other man) | 1 |

**Module shape** (next task, not this one):

- `GrappleSeat.gd` — pure seat + legal edges + hold-threshold in ticks. No
  preload of the fight core.
- `GrappleResolve.gd` — `takedown_resolve` / `position_resolve` /
  `submission_advance`. Caller passes `roll`.
- Adapter fold only: map the event log onto the five counters. Do not resolve
  attempts inside the adapter.

Cadence: resolve attempts on TickBudget `decision` (every 10 ticks at 20 Hz).
Accrue control on `scoring` (every 20). Movement and impact streams stay
untouched.

---

## 9. Open questions for the operator

Only two. Everything else on this page is a decision.

1. **Do we score IBJJF advantages?** They are the official tie-break and they
   are cheap (a `position_change` that died between 20 and 60 ticks). They are
   also the thing most likely to make a BJJ exhibition look noisy. Default
   recommendation: emit them as `grade=0` position changes and let the BJJ
   adapter count them; MMA/judo/wrestling ignore `grade=0`.
2. **Is a 1-D line enough for UWW step-out?** RingPlace already has CENTRE /
   ROPES / CORNER. Mapping ROPES+ to step-out pressure and a failed circle at
   the edge to `step_out` is consistent and costs no new spatial model. If the
   operator wants a circular mat with a real out-of-bounds radius, that is a
   different task and it blocks wrestling only, not MMA.

No third question. TKD is not this contract. Gi cloth is not this contract. The
atomic engine is retired for a bout once this log can fill the five counters
that bout's profile actually reads.
