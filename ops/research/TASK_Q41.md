# TASK Q41 — QWEN — MAKE "DOES SKILL BUY OUTPUT?" MEASURABLE

Model: Qwen, `--yolo`, **medium** effort.
Owner: qwen. Deliverable: `research/Q41_SKILL_AND_OUTPUT.md` plus the
harness change that produced it.

Tier: **YOUR OWN TOOL AND A DELIVERABLE, NO SCRIPT EDITED.** Parse gate on what
you touch, then run your own harness. **Do NOT run the full suite** — it is
twenty minutes and it is Claude's at integration. If you find yourself editing a
`.gd` under `Godot/scripts/`, you have left the task: stop and report it.

## Why this exists — your own Q40 created it, and it was the right call

Q40 (`86373c0`) is accepted in full. It confirmed all three of G49's predicted
symptoms with matched denominators, and it **refused** the fourth honestly:

> **NOT DERIVABLE from this harness.** Both fighters have fixed attributes across
> all 200 bouts. The attribute difference is constant, so Pearson r has zero
> variance in the x-axis and is undefined (0/0). The correlation reads 0.0000,
> **which is the correct output for a degenerate input, not a measurement.**

**That refusal is why this task exists rather than a correction.** You did not
dress a degenerate 0.0000 as a finding, and the distinction you drew is exactly
right.

**But it leaves R101 unable to prove its central claim.** R101 replaces the coin
flip so that a better striker throws more often than the man he is beating.
Right now we can measure that neither before **nor after** — so the stage could
land, work perfectly, and have no number to show for it. G49's own words: *"skill
does not buy output — a far better striker throws exactly as often as the man he
is beating."* We need that as a measured `r`, twice.

## What to do

**Vary the fighters across bouts so the x-axis has variance**, and report the
skill-versus-output correlation as a real number.

1. **Vary attributes, not technique.** The house harness varies `fight_iq`; you
   need a spread in whatever attribute actually drives striking output — Q40 used
   `strike_composite`, so start there and **say which field you varied and why**.
2. **Sweep, do not randomise blindly.** A spread wide enough that a real effect
   would show, and **state the range**. If a 60-vs-55 gap is too narrow to
   resolve anything, widen it and say so — but remember the 2026-09-10 lesson
   that **240 bouts at 70-v-55 produced ZERO splits**: a gap that is too wide
   stops being a fight. Report the range you chose and what it cost.
3. **Report Pearson r with its n and its denominator**, plus a scatter or a
   binned table so a reader can see the shape rather than trust one coefficient.
4. **The expected answer is r ≈ 0 and you should report it anyway.** This is the
   before-picture. A number near zero here, *with real variance in the x-axis*,
   is the thing R101 gets to move. **Say explicitly that the x-axis now has
   variance** — that is the whole difference from Q40.
5. **Also report output ASYMMETRY against the skill gap**: does the bout's volume
   split widen at all as the attribute gap widens? Under a fair coin it cannot,
   and showing that directly is stronger than a correlation coefficient.

## The rules that govern it

- **Measure, do not fix.** `Godot/scripts/` is off-limits; R101 owns the fix.
- **NAME THE DENOMINATOR IN THE SAME SENTENCE AS EVERY PERCENTAGE**, as you did
  throughout Q40 — that discipline is why Q40 was accepted without a re-run.
- **Label anything you choose as AUTHORED**, as you did with the 40-tick burst
  threshold.
- **Report `measured-at=<sha>`**, as you did.
- **Reuse `Godot/tools/measure_exchange.gd`** — extend it, do not fork it. One
  harness, so the before and after are the same instrument.
- Keep it MMA, for the same reason Q40 did: C85 is moving boxing's weights.
- Ceilings and floors, never an exact count, in any assertion.

## The trap

**A SEED IS ONLY MEANINGFUL WITH THE EXACT FIGHTER THAT PRODUCED IT** — and this
task deliberately changes the fighter, which is precisely when that rule bites.
Q40's seeds 200000–200199 produced their numbers with Q34's fixed pair. **Your
numbers are NOT comparable to Q40's bout-for-bout**, and you must say so rather
than presenting a delta. What carries over is the method, not the values.

Second trap: if you widen the skill gap far enough, bouts start ending early and
your impact counts fall — **which is a change in the DENOMINATOR, not in the
correlation.** Watch for it and report bout length alongside.

Third: `rc=0` is **not** a pass. Never pass `--godot` to `run_tests.py`.

## Anchors

- `Godot/tools/measure_exchange.gd` — your own harness, extend it.
- `research/Q40_THE_EXCHANGE_WE_HAVE.md` — your own before-picture.
- `research/G49_THE_EXCHANGE.md` — the claim being tested.
- `Godot/scripts/FightRealtime.gd` is 2,177 lines. **Never open it whole.**

## Deliverable shape

`Q41_SKILL_AND_OUTPUT.md`, **NUMBERS** first: the attribute varied, its range,
n, Pearson r, the binned table, the volume-split-versus-gap table, and bout
length. Then prose, then **NOT DERIVABLE** if anything remains so.

Commit, push **master** (`git rev-parse --abbrev-ref HEAD` first), write the
digest, send one line with `python Tools/agent_comms.py send`. **Do not edit
`HANDOFF.md`** — Claude writes your block.
