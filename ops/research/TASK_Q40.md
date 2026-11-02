# TASK Q40 — QWEN — MEASURE THE EXCHANGE WE HAVE, BEFORE WE REPLACE IT

Model: Qwen, `--yolo`, **medium** effort.
Owner: qwen. Deliverable: `research/Q40_THE_EXCHANGE_WE_HAVE.md` plus the
harness that produced it.

Tier: **A NEW TEST FILE ONLY, NO SCRIPT EDITED.** Parse gate on your new file,
then run **that one test**. A new test file cannot break another test — **do NOT
run the full suite**, it costs twenty minutes and buys nothing here. If you find
yourself editing a `.gd` under `Godot/scripts/`, you have left the task: stop and
report it instead.

## Why this exists

R101 is about to replace the line that decides who throws the next strike:

> `FightRealtime.gd:1287` — `rng.randf() < 0.5`, an unweighted coin flip,
> re-rolled on every single impact.

Grok's G49 study (`research/G49_THE_EXCHANGE.md`, **read it first, it is
short and it is the brief behind this task**) ruled that a material defect, and
named the symptoms it must produce:

- **no combinations** — a man throws twice in a row only by luck;
- **no volume asymmetry** — a far better striker throws exactly as often as the
  man he is beating;
- **no burst ownership** — output should cluster, and cannot.

**Those are predictions about our engine's output, and nobody has measured them.**
R101 will change this line and will then have to say what moved. **Without a
before, it cannot.** That is what you are producing: the honest baseline.

**This is the same discipline as R100's rebaseline and Q38's speed defect.** Q38
is the model to copy — it found a real defect and gave it a number with matched
denominators.

## MEASURE MMA BOUTS, AND SAY WHICH COMMIT YOU MEASURED AT

**This is a sequencing constraint, not a preference.** C85 (Codex) is running
right now and it changes the target-weight table **for BOXING only** - MMA's
weights are a ruling and C85 is forbidden from touching them. If you measure
boxing you will produce a baseline that R101 cannot be compared against, because
the ground will have moved underneath it.

**So: measure MMA.** And report `measured-at=<commit sha>` in the deliverable and
in your mailbox line, exactly as Q39 did. If your numbers ever need re-taking,
that one field is what makes it possible.

## What to measure

Over a decent sample of seeded bouts (**200 is the house size**; use the same
harness shape Q38/Q39 used — copy it verbatim rather than building a fighter of
your own, see the trap below), report:

1. **Run-length distribution — the combination proxy.** Walk the ordered stream
   of impacts in a bout. A "run" is a maximal sequence of consecutive impacts
   thrown by the same fighter. Report the full histogram: what share of runs are
   length 1, 2, 3, 4, 5+. **Also report the mean run length.**
   - G49's comparison point: in elite amateur boxing, combinations are roughly
     **half of offensive actions**. Our engine's expected run-length
     distribution under a fair coin is geometric with p=0.5 — 50% singles, 25%
     twos, 12.5% threes. **Say explicitly whether the measurement matches that
     geometric prediction**, because if it does not, something else is already
     influencing the stream and that is a finding on its own.
2. **Volume share.** Per bout, the share of impacts belonging to the fighter who
   threw more. Report the distribution — median, p90, max — **and how often the
   split is within a few points of 50/50.** G49: real fight volume is emphatically
   not 50/50; Mayweather–Marquez was 493 v 583 thrown and 290 v 69 landed.
3. **Does skill buy output?** This is the sharpest question here. Correlate each
   fighter's volume share against his own attributes — **and say which attributes
   you used and why.** Under a fair coin the correlation must be approximately
   zero. **Report the number even though the answer is predictable**, because it
   is the one line that proves the defect end to end rather than by reading the
   source.
4. **Inter-impact interval.** Distribution of the gap in ticks (and seconds, at
   20 Hz) between consecutive impacts. Report median and the tail. G49's
   comparison: a real 4-punch combination runs ~1.05 s contact-to-contact, and
   high-intensity efforts cluster in 6–36 s bursts.
5. **Burst structure.** Using whatever gap threshold you judge sensible — **name
   it and justify it in one line, and label it AUTHORED** — how long is a burst,
   how many impacts are in one, and does either man own a burst more often than
   chance?

## The rules that govern it

- **Measure, do not fix.** You are forbidden from changing `FightRealtime.gd` or
  any script under `Godot/scripts/`. R101 owns the fix. If you see the fix while
  measuring, write it in the deliverable as a finding — that is welcome — but do
  not implement it.
- **NAME THE DENOMINATOR IN THE SAME SENTENCE AS EVERY PERCENTAGE.** This is the
  trap that cost real time on 2026-09-10: Q36 reported an 8.8% gap by dividing
  empty *windows* instead of empty *seconds*; the true figure was 83.9%. Say
  "X% of runs", "X% of bouts", "X% of impacts" — never a bare percentage.
- **Two numbers in the same column must be the same quantity.** The other half of
  the same lesson: hand travel was compared against centre-to-centre separation
  and invented a crisis that did not exist.
- **Report MEASURED vs NOT DERIVABLE**, as Q39 did. If the impact stream does not
  record something you need, say so plainly rather than approximating it. Q39's
  "not derivable" list is the most useful thing it produced.
- Ceilings and floors, never an exact count, in any assertion you write.

## The trap

**A SEED IS ONLY MEANINGFUL WITH THE EXACT FIGHTER THAT PRODUCED IT.** On
2026-09-10 a seed scan using a fighter of the agent's own construction called a
bout a split; the real harness — which varies `fight_iq`, not technique — made
it a KO. **Copy the existing harness verbatim** from Q38/Q39 rather than
constructing fighters yourself, and say in the deliverable which harness you
copied and from which file.

Second trap: `rc=0` is **not** a pass. A GDScript runtime error leaves rc=0 and
still prints "0 failures". Read your own output. **Never pass `--godot` to
`run_tests.py`.**

## Anchors — read WINDOWS, never a whole file

`FightRealtime.gd` is ~2100 lines. **Never open it whole.**
- `sed -n '1280,1300p' Godot/scripts/FightRealtime.gd` — the coin flip itself.
- `grep -n "func advance_tick\|impacts\|_run_impact" Godot/scripts/FightRealtime.gd | head -20`
- `research/G49_THE_EXCHANGE.md` — read this whole; it is short and it is
  the brief.
- Your own Q38/Q39 harnesses — the sampling shape to copy.

## Deliverable shape

`Q40_THE_EXCHANGE_WE_HAVE.md`, with a **NUMBERS** section at the top: the
run-length histogram, mean run length, volume-share distribution, the
skill-versus-output correlation, and the interval median — each with its
denominator named. Then the prose, then a **NOT DERIVABLE** section.

Commit the harness and the deliverable, push to **master** (check
`git rev-parse --abbrev-ref HEAD` first — an agent that branched may have left
you on its branch), write the digest, and send one line with
`python Tools/agent_comms.py send`. **Do not edit `HANDOFF.md`** — Claude writes
your block.
