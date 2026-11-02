# TASK Q38 — QWEN — ARE OUR MEN MOVING LIKE BOXERS, OR JITTERING?

Model: qwen (CLI, `--yolo`), medium effort.
Owner: qwen. Tier: **NEW TEST FILE ONLY** — parse gate plus this one test. Do
NOT run the full suite.

## Why this exists — your Q37 produced two numbers that may be defects

Q37 (`6d01608`) is good work and its correction discipline was exactly right —
every figure carrying its denominator in the same row. Two of those figures now
need a second look, because **if either is what it appears to be, we would waste
real money buying locomotion clips for a body that cannot use them.**

**Number one: speed.** You measured a median of **1.60 m/s**, with a P05–P95 of
**1.38–1.61 m/s** — a strikingly narrow band, which you summarised as "the speed
is one number". But a separate desk (J18), citing Thomson's GPS study of real
boxers, gives a mean ring movement speed of **0.6 m/s**. **Ours may be about
2.7× a real boxer's.**

**Number two: direction changes.** You measured **29.2 per 10 seconds** — very
nearly **three reversals per second**. No human being does that. A boxer does
not change direction three times a second, and more to the point **an animation
system cannot show it**: a locomotion cycle blended three times a second is a
blur, and no clip we buy will survive it.

**Neither is yet established as a defect**, and that is the point of this task.
Both could be artefacts of the denominator — the exact trap Q36 fell into and
Q37 fixed. Settle it.

## What to settle, and the denominator is the whole job

Same 200 seeded boxing bouts, seeds 200000–200199.

### Part 1 — the speed comparison

1. **State precisely what your 1.60 m/s was the mean OF.** Was the denominator
   only ticks where displacement was non-zero, or every tick of the bout? Report
   **both** numbers this time, side by side, each labelled.
2. **Compute a whole-bout mean speed** — total path length walked by one fighter
   divided by total fight seconds, including every stationary moment and every
   rest period, and then again excluding rests. That is the quantity a GPS study
   of a real boxer measures, and it is the only one comparable to 0.6 m/s.
3. **Total distance travelled per fighter per round, in metres.** A real
   three-minute boxing round is a publishable distance; ours should be sane
   against a ring that is only a few metres across.
4. **Verdict on the comparison:** once the denominators match, are we near
   0.6 m/s or near 1.6? **If we are genuinely 2.7× too fast, say so plainly** —
   that is an engine defect with a direct animation consequence, and it is better
   found now than after we buy four cycles authored for a shuffle.

### Part 2 — what a "direction change" actually is

5. **How big are the reversals?** For each counted direction change, measure the
   displacement magnitude on either side. Report the distribution. **A reversal
   of half a centimetre is numerical jitter; a reversal of twenty centimetres is
   a man changing his mind.** Give the share of each.
6. **Re-count with a deadband.** Recount direction changes ignoring any
   displacement below 1 cm, then below 5 cm, per tick. **How does 29.2 per 10 s
   change?** If it collapses to something like two or three, the number was
   jitter and there is no defect — say so and close it.
7. **Is the intent oscillating, or only the position?** Count how often the
   engine's chosen `FightIntent` actually flips between consecutive decision
   ticks, separately from how often the displacement vector reverses. **These are
   different things and only one of them is a decision.** If intent is stable
   while position jitters, the fault is in the movement integration, not the
   brain.
8. **What would an animation system see?** Given a locomotion clip needs roughly
   0.2–0.3 s to read at all, count how often the movement direction is stable for
   at least 0.25 s, 0.5 s and 1.0 s. **That is the number that decides whether
   four locomotion cycles are buyable**, and it is the deliverable this whole
   task exists for.

## Owned files

- `Godot/tests/fight_movement_quality_test.gd` — NEW, yours.
- `research/Q38_MOVEMENT_QUALITY.md` — NEW, yours.

**Do not edit any script.** This is a measurement, and if it finds a defect the
fix is a separate deliberate decision — any change to movement moves every
seeded fight and every pinned card.

## Gate and traps

```
python Godot/tools/check_scripts.py Godot/tests/fight_movement_quality_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_movement_quality_test.gd
```

**rc=0 is NOT a pass (R75).** Read the output.

**Trap 1 — and it is the whole task: name the denominator in the same sentence
as every percentage and every average.** Q36's error was dividing by empty
windows instead of empty seconds, and both of the numbers you are re-examining
here may be the same error wearing different clothes.

**Trap 2: do not assume the numbers ARE wrong.** I am asking you to check them,
not to disprove them. If the whole-bout mean really is 1.6 m/s and the reversals
really are 20 cm apart, then we have a genuine engine defect and I need to know
that just as clearly. **Report what you find, not what the task expects.**

**Trap 3:** never gate on an exact value or an exact zero; `git status -s` before
committing and `git add -- <explicit paths>` only — several agents have work in
flight.

## Deliverable

`Q38_MOVEMENT_QUALITY.md`, ending in **VERDICT** with one line each on: whether
our movement speed is comparable to a real boxer's once denominators match, and
whether the direction is stable long enough for a locomotion clip to be worth
buying.

Commit, push **master**, then:
`python Tools/agent_comms.py send --from qwen --to claude --subject Q38-done --body "<sha> speed-moving-ticks=<a>m/s speed-whole-bout=<b>m/s dist-per-round=<c>m vs-thomson-0.6=<near/2.7x> reversals-raw=<n>/10s reversals-over-5cm=<n>/10s intent-flips=<n>/10s stable-0.25s=<p>% stable-0.5s=<q>% verdict=<buyable/not>"`
Do not edit `HANDOFF.md`.
