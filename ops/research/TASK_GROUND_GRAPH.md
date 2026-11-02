# TASK_GROUND_GRAPH — THE GROUND GAME HAS AN ESCALATOR AND NO DECISION. HOW FAR DO WE TAKE IT?

**This is a JUDGEMENT task, not a build task.** No code, no tests, no gate. Read
this file and nothing else. Do NOT explore the repo to "get oriented"; every
fact you need is quoted below, and I have quoted the code rather than described
it so you can argue with the code and not with me.

**You are one of four agents being asked the same question, independently and
blind to each other.** Do not try to guess what the others said. The operator
will read all four before deciding.

---

## THE SITUATION, FROM THE CODE

We have a fight engine (Godot 4 / GDScript) with a working stand-up game and a
ground game that has just started to get real authored 3D animation. Three
paired ground holds are now authored, bound and visually verified: **side
control**, **half guard** and **back control**. The operator looked at side
control and asked the question behind this task:

> *"i want to see the transition and sequence to other moves from that position
> there must be a logic and planning from the fighter to execute the moves"*

He is right that there is almost nothing there. Here is exactly what exists.

### 1. The whole ground progression is a hardcoded one-way ladder

`scripts/GrappleResolve.gd`:

```gdscript
static func position_resolve(
        attacker: Dictionary, defender: Dictionary, from_seat: String,
        fatigue_atk: float, fatigue_def: float, roll: float) -> Dictionary:
    var p: float = _success_probability(attacker, defender, fatigue_atk,
        fatigue_def, STANDING_OFF_WEIGHTS)
    var success: bool = roll < p
    var to_seat: String = from_seat
    var points: int = 0
    if success:
        match from_seat:
            "guard", "half":
                to_seat = "side"
                points = position_points("pass", "side")
            "side":
                to_seat = "mount"
                points = position_points("mount", "mount")
            "mount":
                to_seat = "back"
                points = position_points("back", "back")
            "none", "over_under":
                to_seat = "guard"
                points = 0
    return {"success": success, "to_seat": to_seat, "points": points}
```

**One destination per position. No choice is made anywhere.** A man in side
control can do exactly one thing: attempt mount.

### 2. The success roll does not know which transition it is

`p` comes from `_success_probability(... STANDING_OFF_WEIGHTS)` — the same
stat-weighted roll, the same `PROB_SCALE = 0.012`, the same
`PROB_BASE = 0.50`, whatever the edge. **Passing a closed guard and taking
mount from side control are the same coin flip.**

### 3. There is no adjacency data at all

`scripts/GrappleSeat.gd`:

```gdscript
const SEATS := ["none", "over_under", "guard", "half", "side", "mount", "back"]

static func is_legal(from_stance: String, from_seat: String,
        to_stance: String, to_seat: String) -> bool:
    return _pair_valid(from_stance, from_seat) and _pair_valid(to_stance, to_seat)
```

**`is_legal` ignores `from` entirely.** It validates that both ends are known
strings and returns true. `side -> back` is as legal as `side -> mount`, and
`side -> standing` is legal too. Nothing in the codebase says which positions
border which.

### 4. The technique catalogue has no from/to either

The real catalogue node, verbatim:

```json
{
 "id": "bjj_side_control",
 "name": "Side Control",
 "kind": "skill", "tier": 1, "branch": "positions",
 "discipline": "brazilian_jiu_jitsu",
 "requires": {
   "discipline": 12,
   "attributes": {"technique": 38, "fight_iq": 36},
   "prerequisites": ["bjj_guard"],
   "reps": 90
 },
 "match": {
   "role": "control",
   "phases": ["ground_top"],
   "effects": {"control": 8, "submission_setup": 4},
   "range_delta": 0
 },
 "grade": "white belt"
}
```

`prerequisites: ["bjj_guard"]` is a **SKILL-TREE** prerequisite — what the
fighter must have trained to unlock this — **not** a positional one. The
catalogue answers *what the sim may do and what it costs*. It does not answer
*what this position leads to*.

### 5. What DOES exist, so you do not propose building it twice

- Seven seats, and a `stance` of `standing` / `clinch` / `ground`.
- `hold_ticks`: a dominant ground seat must be held 60 ticks (20 Hz) to score.
- `control_units` per scoring tick, and `is_dominant` (side, mount, back are;
  guard is not).
- Submissions exist on a **separate branch** in `FightRealtime`, gated on
  `seat != "back"` and a `GROUND_WORK_P` probability gate, with a
  `submission_advance` progress model (0..100, then a ~1/7 finish chance).
- Sweeps, escapes and stand-ups exist as their own transitions to `guard` or
  `standing`.
- ~534 playable techniques in the catalogue, of which 82 are `sequence` nodes.
- Fighters have `technique`, `fight_iq` and per-technique training progress, and
  there is a fight-plan concept the player sets.

So the raw materials are there. **What is missing is the graph and the
chooser.**

---

## THE QUESTION

**How far should we take this, and what exactly should be built first?**

Three shapes are on the table. Pick ONE as your recommendation. You may propose
a fourth if you genuinely think all three are wrong, but say so explicitly
rather than blending them into mush.

**SHAPE 1 — the position graph, data only.**
Author, per position, what it borders: the edges out of it, what each costs,
what each risks. Replace the hardcoded `match` with a lookup, and add a chooser
that weights each legal edge by the fighter's own trained skill in that
technique, his fight plan, and the seat's reward. Submissions and escapes stay
where they are, on their existing separate branch.

**SHAPE 2 — the graph, plus submissions and escapes as edges on it.**
Same graph, but the edge set also includes attacks and escapes, so from side
control the top man chooses between advancing to mount, attacking a kimura, and
simply holding for control points — and the bottom man chooses between escaping
to guard and conceding his back. Both men choose every tick, from one mechanism.

**SHAPE 3 — the motion layer first.**
Leave the logic alone. Give every technique an explicit `archetype` id so 3D
clips bind to motion families rather than by name similarity. (Context you need
to judge this: we have 534 techniques needing motion, 159 currently bound, and
**111 of those 159 bindings are marked `near`** — they were matched by name
resemblance, not by any declared motion identity. One known example from a
previous audit: a technique called "double jab" was bound to a clip containing a
SINGLE jab, and nobody noticed for weeks.) The argument for doing this first is
that it is what makes any transition VISIBLE once it happens.

---

## WHAT I WANT BACK

Keep it tight — a page or two, not a survey. Answer these, in order:

1. **Your pick, in one sentence, first.** Then the reasoning.
2. **What is the smallest first slice** that would prove or kill your pick?
   Name something we could build in a day or two that produces a number or a
   behaviour we could look at.
3. **What does the graph's data actually need to carry per edge?** Be concrete —
   field names and what each is for. If you think an edge needs something we
   have no way to author or measure, say which, and say what we would do
   instead.
4. **Where should the CHOICE live?** Options include: weights baked into the
   catalogue, a utility score computed per tick, a behaviour tree, a learned or
   tuned policy, or something else. Say what you would do and what it costs to
   debug when a fighter does something stupid on camera.
5. **What breaks?** Name the thing your pick makes worse, not just what it
   improves. Consider at minimum: determinism and replay, the existing scoring
   and the 60-tick hold rule, save compatibility, and whether a viewer can tell
   what just happened.

6. **NOW ARGUE AGAINST YOURSELF.** Take your own recommendation and attack it as
   hard as you can. What is the strongest case that your pick is the wrong one,
   and what evidence would change your mind? **This section has decided more of
   this project's rulings than the recommendation sections have** — the
   converged answer has repeatedly turned out better than any of the three
   options as offered, and it came out of this half of the brief. Do not skip it
   and do not make it a token paragraph.

7. **What you are least sure about, and what fact you would need to settle it.**

---

## TRAPS, SO YOU DO NOT SPEND THE PASS ON THEM

- **Do not re-litigate the collision geometry.** Whether the body is fifteen
  capsules or something else is a separate, active question. Assume the bodies
  can be placed.
- **Do not design the animation blending.** How two clips join is being handled
  elsewhere. Assume a transition can be shown, badly, today.
- **This is a REAL fight sim, not a BJJ tutorial.** Positions must be reachable
  in an MMA bout with strikes, a cage, and a referee standing people up.
- **Do not propose per-technique hand authoring of 534 rows without pricing it.**
  If your answer needs a lot of data authored, say roughly how much and how you
  would generate most of it.
- Female fighters never fight males; the facility is a "gym", never a "camp".
