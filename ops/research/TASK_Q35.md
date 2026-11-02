# TASK Q35 — QWEN — WHAT DOES A COLLISION FLOOR COST THE FIGHT?

Model: qwen (CLI, `--yolo`), medium effort.
Owner: qwen. Tier: **NEW TEST FILE ONLY** — parse gate plus this one test. Do
NOT run the full suite.

## Why this exists — your own finding from Q34

You measured that **the smallest separation the engine ever produces is
0.000 m**, and that it is not an edge case: **779 of 148,232 scored strikes
(0.5%) land inside 0.1 m**. Two men can occupy the same point. There is no
collision body, no minimum-distance clamp and no pushback;
`RingSpace.clamp_to_floor` keeps a man inside the ropes and nothing keeps the
two apart.

The simulation does not care — it is scoring forces, not rendering bodies. **The
3D stage cares a great deal**, because two rendered fighters at the same
coordinate interpenetrate, and no animation clip or camera angle hides it.

So we will probably add a floor. **Before we do, measure what it costs.** The
engine is byte-exact-replay by design (R82) and every seeded fight in the suite
is pinned against it; a clamp that quietly moves outcomes would break pinned
cards, and R85's rule is that nobody re-pins a red card to make it green.

## What is already known — do not re-derive

- `FightRealtime.gd:520` — `separation(state)`.
- `FightRealtime.gd:171` — `const STRIKE_RANGE := 1.1`, flat.
- `RingSpace.gd:9` `clamp_to_floor`, `:17` `step` — the step is where a
  position actually moves, and it is the only place a floor could be applied.
- Your Q34 numbers: boxing median 0.885, P05 0.329, mode `[1.0,1.1)` 27.5%.

## Owned files

- `Godot/tests/fight_collision_floor_test.gd` — NEW, yours.
- `research/Q35_THE_COLLISION_FLOOR.md` — NEW, yours.

**Do NOT edit `FightRealtime.gd` or `RingSpace.gd`.** This is a costing, not a
change. Model the clamp **inside your test** — run the bouts, and separately
compute what a floor WOULD have done — or, if you cannot do it without touching
the engine, say so plainly in the findings and deliver the measurement you can.

## What to measure

For candidate floors of **0.30 m, 0.45 m and 0.60 m**, over 200 seeded boxing
bouts (reuse your Q34 harness, same seeds so the two studies are comparable):

1. **How often would the floor bind?** The fraction of ticks, and the fraction
   of scored strikes, whose separation is below each candidate.
2. **Which part of the fight does it touch?** Are sub-floor separations spread
   through the bout, or concentrated — in the clinch, against the ropes, in a
   corner, on the ground? Use `RingSpace.place_of` and the grapple seat to say
   where. **If almost all of them are the clinch or the ground, the floor is
   nearly free**, because the stage will present those seats with their own
   clips anyway and two men ARE touching in a clinch.
3. **What would it cost the fight?** For each candidate, how many scored
   strikes happen below the floor — i.e. how many landed blows would have been
   pushed out of range had the floor existed. Give it as a count and a share.
4. **A standing-only figure, separately.** Exclude every tick where the men are
   in a clinch or on the ground and report 1–3 again. **This is the number that
   actually matters**, because it is the only case where a floor would change a
   free-standing exchange.
5. **The recommendation.** One floor value, or none, with the reason. If the
   honest answer is "the floor binds almost only in the clinch, so pick 0.45 and
   it costs nothing", say exactly that.

## The gate, and the traps

- `python Godot/tools/check_scripts.py Godot/tests/fight_collision_floor_test.gd`
- `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_collision_floor_test.gd`

**rc=0 IS NOT A PASS (R75).** A runtime error leaves rc=0 and prints
`0 failure(s)` having never reached the counter. Read the output.

**Trap 1: do not assert an exact number.** Same as Q34 — gate that the
measurement occurred and is sane, never on a value. **And never gate on an
exact zero**; assert that sub-floor separations OCCUR and print the count.

**Trap 2, and it is the one that would waste the task: do not "fix" anything.**
If you find the floor is cheap, the temptation is to go and add it. Don't. A
clamp in `RingSpace.step` moves every seeded fight in the suite and re-pinning
is a separate, deliberate decision that Claude makes at integration.

## Deliverable

`Q35_THE_COLLISION_FLOOR.md`: the tables above, then **VERDICT** — one line
naming the floor you recommend (or none), and one line on whether it can be
added without moving a pinned card.

Commit, push **master**, then:
`python Tools/agent_comms.py send --from qwen --to claude --subject Q35-done --body "<sha> floors=0.30/0.45/0.60 bind-tick-frac=A/B/C strikes-below=D/E/F standing-only=G/H/I clinch-share=J% recommend=<value-or-none> moves-pins=<yes/no>"`
Do not edit `HANDOFF.md`.
