# TASK Q34 — QWEN — ARE OUR METRES REAL? MEASURE THE POCKET.

Model: qwen (CLI, `--yolo`), medium effort.
Owner: qwen. Tier: **NEW TEST FILE ONLY** — parse gate plus this one test. Do
NOT run the full suite; it costs twenty minutes and a new test file cannot
break another test.

## Why this exists

You measured the beat stream in Q32 and reported **median strike distance
0.89 m**. Nobody has ever checked whether `FightRealtime`'s `separation` is a
physical quantity at all. Before we spend money on animation clips, we have to
know whether a scored punch happens at a distance a human arm could cover — if
our metres are wrong, every clip we buy will be the wrong length and we will
blame the clips.

**This is a MEASUREMENT, not research. Do not read the web. Do not form
opinions about boxing. Instrument the engine and print what it does.**

## What is already known (do not re-derive)

- `FightRealtime.gd:171` — `const STRIKE_RANGE := 1.1`. **This is a FLAT gate
  for every fighter.** It does not read `reach_cm` and it has never heard of
  `height_cm`.
- `FightRealtime.gd:520` — `separation(state)` is
  `RingSpace.distance(position_of(a), position_of(b))`, over `pos_x`/`pos_y`
  fixed-point integers.
- `FightIntent.gd:16` — `preferred_range(stats, reach_cm)` is
  `1.2 + (reach_cm-150)/50*0.3 + tech*0.2 - power*0.2`, clamped `0.4..2.0`.
  This is a PREFERENCE the intent picker steers toward; it is NOT the gate.
- `FightRealtime.gd:1192` — `if gap > STRIKE_RANGE:` is where the attempt dies.
- Every fighter carries `reach_cm` (default 180.0) at `FightRealtime.gd:430`.

## Owned files

- `Godot/tests/fight_metres_test.gd` — NEW, yours, the whole deliverable.
- `research/Q34_THE_METRES.md` — NEW, yours, the findings.

Touch nothing else. **Do not edit `FightRealtime.gd`.** If you believe the
engine is wrong, say so in the findings file; a measurement task that changes
the thing it is measuring has measured nothing.

## What to measure

Run **200 seeded bouts** the way Q32 did (reuse your own harness; boxing
ruleset is fine, and note in the findings which ruleset you used). For every
bout, record:

1. **The separation at the moment a strike is SCORED** — i.e. at the tick an
   impact is appended to the log, not at the decision tick. Report the FULL
   distribution, not the median: min, p05, p25, median, p75, p95, max, and a
   histogram in 0.1 m buckets from 0.0 to 1.2.
2. **The separation at the moment the attempt gate is EVALUATED** — same
   statistics, over every decision tick that reached line 1192, including the
   ones that failed the gate. This tells us how much of the fight is spent out
   of range.
3. **Separation against the thrower's `reach_cm`.** Bucket the scored-strike
   separations by the thrower's reach (`<170`, `170-184`, `185-199`, `>=200`)
   and give the median for each bucket. **The prediction to test: the medians
   are the SAME, because the gate is flat.** If they differ, say by how much
   and say why you think so.
4. **How much of the bout is spent inside `STRIKE_RANGE` at all** — the
   fraction of ticks where `separation(state) <= 1.1`.
5. **The floor.** What is the SMALLEST separation the engine ever produces in a
   standing exchange, and is there anything stopping two men occupying the same
   point? Report the number; do not add a clamp.

Do the same for **MMA** as a second ruleset and report whether the numbers
move. One paragraph is enough for the second ruleset.

## The gate, and the trap

- `python Godot/tools/check_scripts.py Godot/tests/fight_metres_test.gd`
- `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_metres_test.gd`
  (the exe is in `%LOCALAPPDATA%\Programs\Godot\`)

**rc=0 IS NOT A PASS (R75).** A GDScript runtime error leaves rc=0 and your
test will print `0 failure(s)` having never reached the counter. Read the
output.

**The trap specific to this task: do not assert an exact number.** You are
measuring, so the test's assertions are that the measurement OCCURRED and is
sane — `scored_strikes > 0`, every reported separation is finite and
`>= 0.0`, the histogram sums to the sample count. **Never gate on an exact
value or an exact zero**; a gate like "median == 0.89" turns a tuning change
into a false red. Print the numbers, assert only that they exist.

## Deliverable

`Q34_THE_METRES.md`: the tables above, then a section headed **VERDICT** with
one line answering *is `separation` a physical quantity we can hand to an
animator, yes or no*, and one line on whether the flat `STRIKE_RANGE` shows up
in the data as reach-blindness. If the answer is "the metres are wrong", say
which number is wrong and by roughly how much — do not fix it.

Commit, push to **master**, then one line:
`python Tools/agent_comms.py send --from qwen --to claude --subject Q34-done --body "<sha> bouts=N scored-median=X p05=Y p95=Z reach-buckets=A/B/C/D in-range-frac=F floor=M verdict=<one word>"`
Do not edit `HANDOFF.md`.
