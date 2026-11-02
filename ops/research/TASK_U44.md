# TASK U44 — CURSOR — FOOTWORK THAT READS THE OTHER MAN

Model: cursor-agent, **medium** effort. Owner: cursor.

**Tier: ONE SCRIPT EDITED + ITS OWN TEST.** Parse gate, then
`python Godot/tools/run_tests.py --only intent`. **DO NOT RUN THE FULL SUITE** —
Claude runs it once at R102 integration. A suite run here costs twenty minutes
and buys nothing.

## The operator's ruling this closes

> "movement should be able to be measured, distance judgement before executing
> is fundamental"

## The defect, and it is one line

`Godot/scripts/FightIntent.gd:29`:

```gdscript
static func decide(stats, distance, preferred, stamina, place, roll) -> String
```

**There is no opponent anywhere in it.** A fighter picks CLOSE / HOLD / RETREAT
/ CIRCLE from his own preferred range, his own stamina, and whether his back is
to the ropes. He does not know he is standing inside a longer man's jab. And
`preferred_range(stats, reach_cm)` at `:16` reads **only his own reach**.

Kiting and cutting off the ring exist in the catalogue as named techniques
(`muay_thai_ringcraft_walk`, `boxing_cutoff_ring`, `kickboxing_teep_stop`,
`boxing_pivot_footwork`) and the engine's footwork is blind to the other man, so
none of them can mean anything.

## READ THIS BEFORE YOU DESIGN ANYTHING — G54 IS A REFUSAL AND IT BINDS YOU

Read `research/G54_WHAT_IS_DEFENCE.md` **section 4 only**.

> **Kiting is the same class of thing as pressure: not a published column.**

Distance covered, direction changes, time on the back foot, circling vs squared
— **NOT PUBLISHED** by UFC Stats or CompuBox. FightMetric tracked location
internally in a 2015 prototype and never shipped a column. G50 already refused
*pressure* outright.

**Therefore: every coefficient you write in this task is AUTHORED, and must
carry that word in a comment beside it.** Do not cite a study for a magnitude.
Do not imply the shape is validated. This project has a standing rule that a
guessed constant presented as a finding is the worst outcome available — R101
nearly shipped a guessed 1.2 s combination window and called its consequence
realism.

**What you MAY lean on**, and only for SHAPE, is `J21_THE_MOVE_PALETTE.md`
§1.1 and §2.1 (Hristovski, Davids, Araújo & Button, *J Sports Sci Med* 2006),
graded DIRECT:

- scaled distance **D = separation ÷ arm length** is the control parameter;
- **boxers spend time at D ≈ 1.2, the jab-reach edge, because that is where the
  OPPONENT's action diversity is minimised.**

That second line is the whole idea of kiting stated as a measured coordination
result, and it is what your work should reproduce: **holding the gap at the edge
of your own reach and outside his is a real tactic, not a stat.**

`FightMoves.scaled_distance(separation_m, reach_cm)` already computes D
(`FightMoves.gd:220`). **Use it. Do not write a second one.**

## What to build — and the API is a CONTRACT

**Append an OPTIONAL parameter. Do not change the existing signature's first
six arguments, do not reorder them, and do not change any existing return
value.** Claude is editing `FightRealtime.gd` in parallel and will wire the call
site at integration; if your change is not backward compatible, the engine stops
compiling in someone else's session.

```gdscript
static func decide(stats: Dictionary, distance: float, preferred: float,
        stamina: float, place: String, roll: float,
        opponent: Dictionary = {}) -> String
```

`opponent` is `{"reach_cm": float, "preferred": float, "stamina": float}`.
**An EMPTY `opponent` must reproduce today's behaviour EXACTLY, verbatim, for
every input.** That is a test you must write and it is the most important one in
the file.

Also add:

```gdscript
static func contested_range(own_preferred: float, own_reach_cm: float,
        opponent_reach_cm: float) -> Dictionary
```

returning `{"edge": float, "inside_his": bool, "reach_deficit_cm": float}` —
where `edge` is the gap, **in the fighter's own arm lengths**, at which he is
still in range and the longer man is not. **If he is the shorter man there is no
such gap**, and the honest answer is that `edge` collapses to his own preferred
range and `inside_his` decides everything. Say so in a comment rather than
inventing a number that pretends a short man can kite a long one.

### The four intents, with the opponent in them

- **CIRCLE** — changing the ANGLE rather than the distance. Should rise when he
  is cornered (already does) **and** when he is inside a longer man's range with
  nowhere back.
- **RETREAT** — should rise when he is inside the opponent's effective range and
  outside his own, which is the one situation today's code cannot see at all.
- **HOLD** — should rise near his own `contested_range.edge`, which is the
  D ≈ 1.2 result: the longer-reach fighter should *want* to sit there.
- **CLOSE** — should rise when he is the SHORTER man, because the short man's
  only answer to reach is to get inside it. Today a short fighter and a long one
  behave identically at the same gap and that is plainly wrong.

**Fatigue still suppresses CLOSE** — do not remove or weaken that; it is R86's
wire and the reason a gassed man stops pressing.

## Owned files

- `Godot/scripts/FightIntent.gd` — 75 lines, **read it whole**, it is small.
- `Godot/tests/fight_intent_test.gd` — yours; extend it.

**DO NOT TOUCH** `FightRealtime.gd`, `FightMoves.gd`, `ImpactModel.gd`,
`fight_realtime_test.gd`, or `HANDOFF.md`. Claude is in the first two right now.
`FightRealtime.gd` is **2,376 lines** — you have no reason to open it at all for
this task, and no reason to open it whole ever.

## What the test must assert — BY OCCURRENCE, NOT BY PERMISSION

This project has shipped **six** pieces of correct, tested, unreachable code in
this exact area. `absorbed` and `slipped` were unproducible for a stage.
Stamina was never drained. A knockdown was arithmetically impossible behind a
green suite. **Every one survived because the tests asked whether a thing was
permitted, never whether it could occur.**

So:

1. **BACKWARD COMPATIBILITY, EXHAUSTIVELY.** Sweep distance, stamina, place and
   roll across a grid and assert `decide(...)` with no `opponent` returns the
   byte-identical intent to the six-argument call, at every point.
2. **THE SHORT MAN CLOSES MORE.** Same stats, same gap, same roll — give him a
   10 cm reach deficit and assert CLOSE occurs strictly more often across a roll
   sweep. Assert the count, not the possibility.
3. **THE LONG MAN HOLDS THE EDGE.** Give him a 10 cm advantage and assert HOLD
   rises near his `contested_range.edge`.
4. **RETREAT OCCURS FROM INSIDE HIS RANGE.** Construct the case the old code
   could not see — inside the opponent's range, outside his own — and assert
   RETREAT actually comes out, at a non-zero rate.
5. **`contested_range` FOR THE SHORTER MAN IS HONEST.** Assert the documented
   collapse, so the next person cannot read a kite that is not there.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightIntent.gd Godot/tests/fight_intent_test.gd
```

then

```
python Godot/tools/run_tests.py --only intent
```

**Ceiling, not an exact count: `fails=0` on `--only intent`, or better. If a
test outside `intent` is already red for a reason you did not cause, say so and
push anyway.** Never gate on an exact failure number — TASK_C43F did that and
forbade Codex from pushing a BETTER result than it asked for.

## Report

Commit, push **`master`** — not a branch. Then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --subject U44-done
```

Do **not** edit `HANDOFF.md`; Claude writes your block.

## The two traps specific to this task

1. **YOU LEFT THE SHARED CHECKOUT ON A BRANCH LAST TIME.** `cursor/u34-...` took
   six commits that never reached master, and `git push origin master` answered
   "Everything up-to-date" while nothing had landed. **Run
   `git rev-parse --abbrev-ref HEAD` before you believe any commit landed**, and
   push to `master`.
2. **DO NOT LET FOOTWORK BECOME A DAMAGE MODEL.** `decide` returns one of four
   words and nothing else. It does not price a blow, it does not touch stamina,
   it does not read `body_condition`, and it draws no RNG — it takes `roll` as
   an argument and that stays true. C63's ruling stands: **one module prices
   every blow**, and it is `ImpactModel`.
