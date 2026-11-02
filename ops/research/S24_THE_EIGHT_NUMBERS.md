# S24 — THE EIGHT NUMBERS FINALLY HAVE A TARGET

**Stage:** R150's arc is spent (S19–S23 shipped all six stages). What it left
behind is the one thing R150 §8 said it could not give: *"How big a balance
break should be — the ruling gives shape, not magnitude."* Eight authored
numbers carried the whole feature against no target at all.

**Verdict: no number moved, and that is the finding.** Seven of the eight are
inside a sourced band once you read what they actually set; the eighth is the
only one that is not rare, and the measurement defended it against the obvious
cut. What S24 ships is the apparatus that makes all of that readable, and the
gate that stops the next session picking a ninth number off the wrong scale.

---

## 1. THE SCALE THEY WERE PICKED ON IS NOT THE SCALE THEY SET

Every magnitude was authored "inside the 5..15 band the technique catalogue
already uses for its own `balance_break` effect" (`FightRealtime:358`). True,
and not what the number does. A magnitude has exactly two effects:

```
normalized = magnitude / MAGNITUDE_CEILING      # the PEAK
duration   = lerpf(band_min, band_max, normalized)   # the SECONDS
```

and the bands are **G59's, per cause, sourced**. So a magnitude is a position in
a recovery band wearing a catalogue number's clothes. **Nobody had ever read the
seconds.** Read:

| event | magnitude | cause | band (G59) | carried | area |
| --- | --- | --- | --- | --- | --- |
| swept | 10.0 | `sweep` | 0.5–1.5 s (§1b, TTS) | **1.126 s** | 0.352 |
| stuffed shot | 8.0 | `stagger` | 0.5–2.0 s (§1d) | **1.251 s** | 0.313 |
| shock, across the line | 12.0 | `stagger` | 0.5–2.0 s | **1.626 s** | 0.610 |
| shock, down the line | 12.0 | `kuzushi` | 0.2–0.6 s (§1a) | **0.500 s** | 0.375 |
| scramble | 9.0 | `stuffed_shot` | 0.5–1.5 s (borrowed, S22) | **1.062 s** | 0.598 |

All five are **strictly inside their own band** and in G59's evidenced order
(a converted kuzushi shortest, a stagger longer). Five picks, five landings —
luck rather than derivation, but the landings are real and they are now pinned.

## 2. AREA IS THE QUANTITY, AND THREE STAGES ARGUED THE ORDER ON THE WRONG ONE

S22 set the scramble at 9.0 "sitting between the stuffed shot (8.0) and the
sweep (10.0) on purpose". **On seconds that inverts** — 1.062 s against the
stuffed shot's 1.251 s — because the two sit on different bands and a magnitude
ordering does not survive the crossing.

S22's intent is right anyway, and the reason is the CURVE. A handover is SQUARE;
a stagger RAMPS DOWN. On **carried kuzushi-seconds** — peak × time-under-curve,
which is what every consumer integrates — the scramble is 0.598 against the
stuffed shot's 0.313, nearly 2×. Same for S23: one magnitude, two curves, and
the strong line costs 0.375 against the weak line's 0.610.

**That is the quantity a future edit has to be judged on**, and it is now a test
(`fight_balance_state_wiring_test`, 11 new checks, 61 total).

## 3. THE REACH, MEASURED — AND THE CONDITIONAL NO CORPUS PUBLISHES

`_witness_takedown_base` (`FightRealtime`) buckets every takedown attempt by the
defender's base at the shot. Same shape as S21's `state["shocks"]`: no draw, no
replay drift, and it reads state that was already computed.

`tools/probe_balance_anchors.gd` — **240 MMA bouts, four pairings, eight men, no
two sharing a stat block, a frame or a plan, every one legal under MMA**, catalogue
`assets/data/technique_catalog.json` at head:

| defender's base at the shot | shots | share | landed |
| --- | --- | --- | --- |
| a real BREAK | 2 | **0.72%** | 50.0% |
| commitment only | 75 | **27.08%** | 64.0% |
| square | 200 | 72.20% | 52.0% |

G59 went looking for this conditional in the literature and could not find it:
*"NOT FOUND: … they store attempts, completions, TDD% and control time — not a
conditional clock."* The engine can now count what no corpus publishes.

**The 64.0% is nine-tenths SELECTION.** With the bite alone zeroed
(`s24_control_run.py --set bite`) the committed bucket still reads 55.4% against
a square 53.9%. The +3 points S20's comment claimed survives; a conditional read
without its own control would have called this a ten-point global buff and cut
`COMMITTED_BALANCE_KUZUSHI` for it. **That is the fourth stage running saved by
measuring the share before scaling by it.**

## 4. AGAINST J20 — THE ARC IS WORTH ONE POINT, AND THE ANCHORS IT MISSES ARE NOT ITS

`tools/s24_control_run.py` zeroes all eight (every magnitude to 0 normalises to
0, so no break is ever carried; the three scalars multiply by 1.0) — master's
pre-R150 arithmetic exactly.

| J20 DECISION | control (all eight zeroed) | live | J20 anchor |
| --- | --- | --- | --- |
| **D6** takedown accuracy | 49.8% | **51.3%** | 35.3–39.6% (§D) |
| **D5** bouts with ≥1 KD | 80.8% | **84.2%** | 35.1% (§F) |
| **D5** combined KD / fight | 1.637 | **1.704** | 0.41–0.52 |
| **D4** decision / KO+TKO / sub | 59 / 27 / 14 | **57 / 31 / 12** | ~47 / ~33 / ~19 |

**The whole eight-number arc is worth +1.4 points of takedown accuracy and +3.3
points of knockdown incidence — inside a 240-bout sample's own noise.** That is
what a rare-event feature should be worth.

**And every anchor it misses, the control misses too.** Takedown accuracy is
eleven points over J20's ceiling with the bite at 0.25 and nine points over with
it at 0.0; knockdowns are 3.3× the anchor with the arc on and 3.2× with it off.
So no balance number caused a miss and none can close one. The takedown gap is
`GrappleResolve`'s `PROB_BASE` / `PROB_SCALE` / weights; the knockdown gap is
`KNOCKDOWN_FROM_SHOCK_BASE` and the shock rolls. **Neither is S24's, and moving a
balance number to pay for either is precisely the silent global nerf S21, S22 and
S23 were each saved from.**

## 5. WHAT S24 CHANGED

- `FightRealtime._witness_takedown_base` — permanent instrumentation. An
  invisible failure and an absent feature look identical.
- `BalanceState` — all four causes named (`CAUSE_SWEEP`, `CAUSE_STUFFED_SHOT`
  were strings in `VALID_CAUSES` and nowhere else).
- `fight_balance_state_wiring_test` — 11 checks: every magnitude strictly inside
  its band, the carried-cost order, and the commitment cost under the
  catalogue's 5.0 floor.
- `tools/probe_balance_anchors.gd`, `tools/s24_control_run.py` — reusable.
- Four comment blocks corrected where prose the measurement contradicts had
  hardened into fact.

## 6. WHAT IS STILL OPEN, AND WHO OWNS IT

- **Takedown VOLUME is the bigger miss and nobody has logged it.** 0.58 attempts
  per fighter-fight against J20 §D's 3.69–7.49. The engine shoots about a tenth
  as often as the real thing. `GRAPPLE_ATTEMPT_BASE`, not balance.
- **Knockdowns are 3.3× the anchor** (1.70 a fight against 0.41–0.52, 84% of
  bouts against 35.1%). `KNOCKDOWN_FROM_SHOCK_BASE` / `KNOCKDOWN_FROM_SHOCK_WEAR`.
- **A real break reaches 0.72% of shots**, so the four magnitudes cannot be
  calibrated from the takedown seam at any sample this project can afford. The
  band check in §1 is the strongest gate available and it is now in place.
- Still open from S23: the stuffed shooter's `unmodelled` direction
  (`FightRealtime:3507`) and a kick naming no line at all.

## 7. TEST COMMAND

```
python Godot/tools/run_tests.py --only balance
```
