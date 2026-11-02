# S27 — the damage half: what the pace calibration needs beside it

**Claude · 2026-09-20 · engine stage, ENGINE FIRST arc · continues S26**

## WHY THIS EXISTS

S26 calibrated the fight's pace to J20's D1 anchor — 38.37 → 7.00 combined significant strikes
landed per minute against 6.85 — and its own suite then refused to ship it: **311/10 against a
ceiling of 5, six occurrence floors red and not one of them a stale pin.** The diagnosis was that
the engine's per-strike damage had been implicitly calibrated against 6.9× the strike volume, so at
the correct volume nothing accumulates. The operator directed this half to be done immediately
("do the damage half now"), so the calibrated pace ships as a switchable default until it lands.

**This document is the measurement. It does not change a shipped default.** Every figure is
reproducible with `tools/s27_damage_sweep.py`, which sets the pace to `THROW_GATE_CALIBRATED` for
every run and verifies from the run's own output that it did.

## THE POPULATION

240 bouts unless stated (4 MMA pairings × 60), three rounds, ruleset `mma` from
`assets/data/combat_rulesets.json`, half-width 3.0 m, seeds `9_000_000 + pairing*1000 + index`.
Eight distinct men, no two alike and every one legal under MMA: wrestler vs out-striker, pressure
vs counter, sub-grappler vs top-game, clinch-boxer vs kicker. S24/S25/S26's population exactly, so
every figure here is comparable to theirs.

## THE CHAIN, WRITTEN OUT, BECAUSE TWO LEVERS TURNED OUT TO BE THE WRONG ONES

```
wear      = force · contact_coeff · region_coeff · WEAR_SCALE            (ImpactModel:106)
shock     = clamp(HEAD_SHOCK_BASE · force² · (1 + head_wear), 0, 2·BASE) (ImpactModel:119)
knockdown = roll < KNOCKDOWN_FROM_SHOCK_BASE + _WEAR · head_wear         (FightRealtime:3188)
recovered = roll < clamp(F + (C − F) · mix, F, C)                        (FightRealtime:1858)
            mix = 0.4·conditioning + 0.3·fight_iq + 0.3·head
```

## FINDING 1 — `WEAR_SCALE` IS INERT ON SHOCKS, AND THE CLAMP IS WHY

| WEAR_SCALE | 0.6 | 1.8 | 3.0 | 4.5 |
|---|---|---|---|---|
| shocks / fight | 1.083 | 1.083 | 1.125 | 1.125 |
| KD per power head % | 0.79 | 0.92 | 1.13 | 0.94 |
| implied KO/TKO % | 8.33 | 8.33 | 8.33 | 12.50 |
| landed/min *(control)* | 6.85 | 6.75 | 7.12 | 6.93 |
| accuracy % *(control)* | 47.93 | 47.50 | 47.97 | 47.83 |
| head share % *(control)* | 50.8 | 49.2 | 51.0 | 50.6 |

**A 7.5× change in all damage moves shocks by 4%.** `HEAD_SHOCK_MAX` is *defined* as
`HEAD_SHOCK_BASE * 2.0`, so the `(1 + head_wear)` term saturates at 2.0 — wear can at most double
the shock chance, and only on a head that is already destroyed, which a bout ends before reaching.
The control rows held throughout, so the constant is wired correctly; it simply has no authority
over this quantity. **It is not a useless constant — see finding 4.**

## FINDING 2 — THE CONDITIONAL FINISH WAS CAPPED AT 45% BY AN UNSOURCED FLOOR

`RECOVERY_FLOOR := 0.55` / `RECOVERY_CEILING := 0.92`, and the comment above them is the whole
provenance: *"Beating the count, off conditioning, fight IQ and what is left of the head. Bounded
at both ends: never certain, never impossible."* **That is a design principle, not a measurement —
the only constant in this chain with no number behind it.** And J20 section 3.4 has carried its
anchor all along: **"Conditional: KD occurred → ends KO/TKO: 63.5%"**, glossed *"KD should raise
finish probability, not guarantee it"*.

A ceiling sweep returned **byte-identical columns** for 0.92 and 0.75, which is the tell:

| RECOVERY_CEILING | 0.92 | 0.75 | 0.60 |
|---|---|---|---|
| KD→KO/TKO % | 18.18 | 18.18 | 27.27 |
| KD / fight | 0.250 | 0.250 | 0.250 |

Two reasons, and the second is structural. The sample was too small — 48 bouts gives 11 with a
knockdown, so one bout moves the conditional 9 points, and that is noise rather than a measurement.
**And the ceiling cannot be the lever anyway:** at the calibrated pace there are 0.25 knockdowns a
fight spread over 22.9% of bouts, so a bout that has one has *exactly* one, the conditional is
therefore ≈ `1 − recovery`, and **a floor of 0.55 caps it at 45%**. J20's 63.5% is unreachable by
the ceiling at any value. The two constants bracket one `clamp` and must move together.

### DERIVED, THEN VERIFIED ONCE AT A REAL POPULATION

`recovery = F + (C − F)·mix`, and `mix ≈ 0.76` for this population (conditioning ~0.70, fight_iq
~0.60, head fresh ~1.0 at the calibrated pace). Landing 63.5% needs recovery ≈ 0.365, which gives
**FLOOR 0.05 / CEILING 0.45** — predicted conditional 64.6%.

**Measured at 240 bouts: 66.18% against 63.5% — 1.04×.**

| | shipped | FLOOR 0.05 / CEILING 0.45 | J20 |
|---|---|---|---|
| **KD → KO/TKO** | 16.7% | **66.18%** | **63.5%** |
| implied KO/TKO share | 4.17% | **18.75%** | ~32–34% |
| bouts with ≥1 KD | 22.9% | 28.33% | 35.1% |
| KD / fight | 0.250 | 0.308 | 0.41–0.52 |
| landed/min *(control)* | 6.93 | **6.97** | 6.85 |
| accuracy % *(control)* | 47.05 | **47.99** | 44.2 |
| head share % *(control)* | 51.2 | **51.5** | — |
| method mix (of 240) | — | DEC 158 / KO 45 / SUB 37 | ~47 / ~33 / ~19 |

**And the residual arithmetic is exact: 28.33% × 66.18% = 18.75%**, the implied share measured. So
the remaining distance to J20's ~32–34% decomposes cleanly and is NOT a recovery problem.

**A physical note, because this is a large move on a stoppage constant.** The old band said a man
whose head is destroyed still beats the count 55% of the time. The new one says he beats it 5% of
the time and a fresh-headed man beats it about half the time. That keeps the design intent — never
certain, never impossible — while putting the average where the sport's own number is, and it keeps
a real gradient rather than flattening it.

## FINDING 3 — WHAT IS STILL MISSING IS INCIDENCE AND ACCUMULATION, NOT THE FINISH

Reality reaches ~32–34% KO/TKO as **35.1% incidence × 63.5% conditional = 22.3%, PLUS the
stoppages that come from accumulation rather than from a knockdown** — doctor stoppages and TKOs on
a man who was never dropped. The engine at the calibrated pace records **zero** of those (the
probe prints the row: "stopped with NO knockdown"). So:

| gap | engine | J20 | lever |
|---|---|---|---|
| KD incidence | 28.33% | 35.1% | `HEAD_SHOCK_BASE` (0.08), ×1.24 ⇒ ~0.10 |
| conditional finish | **66.18%** | 63.5% | **DONE** — recovery band |
| accumulation stoppages | **0** | ~10% of bouts | `WEAR_SCALE`, via `DOCTOR_HEAD_CONDITION = 15.0` |

## FINDING 4 — EVERY ROAD LEADS BACK TO WEAR, AND I MEASURED IT FIRST AND WRONG

**A combined run exposed the real gate, and it is the one finding 1 dismissed.** With the recovery
band fixed AND `HEAD_SHOCK_BASE` raised to 0.10 (240 bouts, calibrated pace):

| | recovery only | recovery + HEAD_SHOCK_BASE 0.10 |
|---|---|---|
| bouts with ≥1 KD | 28.33% (68 of 240) | **32.50%** (78 of 240) |
| KD → KO/TKO | 66.18% | **57.69%** |
| **KOs, absolute** | **45** | **45** |

**The numerator did not move by one bout.** Ten more bouts got a knockdown and every one of them
went to a decision, so the conditional FELL. The cause is a gate nothing in this stage had looked
at:

```
is_flash_knockdown(shock, head) = shock >= FLASH_SHOCK_FLOOR and head >= FLASH_HEALTHY_HEAD_FLOOR
                               = shock >= 0.07            and head >= 80.0
```

and a flash knockdown is passed `free = true`, which sets `recovered = free` **unconditionally** —
no count, no roll, no KO. **At the calibrated pace a head stays above 80 for nearly the whole
fight, so nearly every knockdown is a flash knockdown and is free.** Raising the shock rate
manufactures more free knockdowns and converts none of them.

So the three symptoms are one cause. Head condition gates:

- **the flash floor (80.0)** — above it a knockdown cannot end a fight at all;
- **the doctor threshold (`DOCTOR_HEAD_CONDITION = 15.0`)** — below it the doctor stops the fight,
  which is the accumulation path the engine records ZERO of;
- **the recovery `mix`** — `0.3 · head`, so a fresh head also recovers near the ceiling.

And head condition is driven by exactly one constant: `WEAR_SCALE`.

**THE ORDER OF THIS STAGE IS THEREFORE WEAR FIRST, AND MY MEASUREMENTS WERE DONE IN THE WRONG
ORDER.** Finding 1 swept `WEAR_SCALE` against shocks per fight, found it inert, and moved on — true
of that observable and irrelevant to the stage, because wear's job is not to make shocks more
likely but to make heads worse, and everything that converts a shock into a finish reads head
condition. **Sweeping a constant against the observable it does not drive, and concluding it has no
authority, is the mistake to carry forward from here.** The right first question was "what reads
`head_neck`?", not "what moves shocks?".

## FINDING 4b — THE ORIGINAL FINDING 4, WHICH STILL HOLDS AS FAR AS IT GOES

Finding 1 says wear is inert on shocks. Finding 3 says accumulation stoppages are missing entirely.
Those are the same constant doing two different jobs, and only one of them is blocked by the
`2×BASE` clamp: **the doctor's threshold is an absolute head condition (`DOCTOR_HEAD_CONDITION =
15.0`), not a rate, so it is reached by total accumulated wear and `WEAR_SCALE` drives it
directly.** A fight that never drives a head below 15.0 can never be stopped by the doctor, and at
the calibrated pace with `WEAR_SCALE = 0.6` no fight does. **Do not conclude from finding 1 that
the constant is dead — conclude that it was measured against the wrong observable.**

## FINDING 5 — A CONSTANT CALIBRATED AGAINST A NUMBER THAT NO LONGER EXISTS

`KNOCKDOWN_FROM_SHOCK_BASE := 0.09` and `KNOCKDOWN_FROM_SHOCK_WEAR := 0.12` carry an honest header:
*"R84 STOPPAGE, AUTHORED AGAINST MEASURED OUTPUT, NOT AGAINST A GUESS. 40 whole fights … emit: 812
impacts, 5.15 SHOCKS, and a head_neck that ends between 58.7 and 75.3. Those three figures are what
these constants are set against."*

**They were set against the engine's own output at the 6.9× pace. Shocks are now 1.27 a fight, not
5.15.** The authoring was sound practice and the number it was sound against is gone. This is the
"gates must derive, never copy" family one level up: a constant calibrated against a *measurement
of ourselves* rots the moment the thing measured changes. It is not obviously wrong now — 24.26% of
shocks becoming knockdowns is plausible — but it is no longer anchored to anything, and it should be
re-derived against the 3.9% figure R151 confirmed rather than left as a fossil of R84's population.

## WHAT THIS STAGE CHANGED ON DISK

- `tools/probe_balance_anchors.gd` — prints J20 3.4's **conditional finish** beside the incidence it
  qualifies, plus stoppages with no knockdown and the implied KO/TKO share. A submission is a finish
  but is NOT in J20's numerator ("ends KO/TKO"), so a man who taps after being dropped is excluded.
- `tools/s27_damage_sweep.py` — **new.** Sweeps any named constant in any script against S27's
  anchors, holds a paired constant with `--hold NAME=VALUE`, sets the pace to
  `THROW_GATE_CALIBRATED` by default and **verifies from each run's own output that it did**.
- **No engine constant's shipped value was changed.** The verified values are recorded here and in
  the roadmap for the stage that lands them as a set.

## THREE TRAPS THIS STAGE PAID FOR

**1. TWO PATCHES IN ONE FILE DID NOT COMPOSE, AND THE TABLE COULD NOT SHOW IT.** When the swept
constant lives in `FightRealtime.gd` — as both recovery constants do — the per-value write was built
from the *original* text and silently discarded the pace patch written before the loop. The sweep
ran at the legacy pace and answered a question nobody asked. **The fix is not just composition: the
tool now reads the pace back out of each run's own output** (legacy lands ~38 strikes a minute,
calibrated ~7, never ambiguous) and refuses rather than printing rows nobody should trust.

**2. A FORCE-KILL SKIPS THE `finally` RESTORE.** Killing the bad sweep with `Stop-Process -Force`
bypassed the restore that exists precisely for this, and could have left a patched constant on disk
for the next reader to attribute to the engine. It happened to land between writes and the tree was
verified clean. **Check the tree after killing any patch-run-restore harness.**

**3. SWEEPING ONE HALF OF A BRACKETED PAIR MEASURES THE OTHER HALF'S CLAMP.** `RECOVERY_FLOOR` and
`RECOVERY_CEILING` bracket one `clamp`, so a ceiling sweep produced byte-identical columns and read
as "this constant does nothing". It does; the floor was holding it. **Before concluding a constant
is inert, check whether another constant is clamping the expression it appears in** — and prefer the
paper derivation, which took one run to confirm where the sweep took four to mislead.

## THE COMPLETE VERIFIED SPEC, AND WHAT IT DOES

All four values were derived, then confirmed together at 180 bouts at the calibrated pace, with
landed/min, accuracy and the head share held as control rows throughout:

| constant | file | shipped | **verified** |
|---|---|---|---|
| `WEAR_SCALE` | ImpactModel | 0.6 | **3.0** |
| `HEAD_SHOCK_BASE` | ImpactModel | 0.08 | **0.10** |
| `RECOVERY_FLOOR` | FightRealtime | 0.55 | **0.05** |
| `RECOVERY_CEILING` | FightRealtime | 0.92 | **0.45** |
| `throw_gate_base` | FightRealtime | `THROW_GATE_LEGACY` | **`THROW_GATE_CALIBRATED`** |

| anchor | shipped | **all four live** | J20 |
|---|---|---|---|
| bouts with >=1 KD | 22.9% | **35.00%** | **35.1%** |
| KD -> KO/TKO | 16.7% | **65.08%** | **63.5%** |
| implied KO/TKO share | 4.17% | **22.78%** | ~32-34% |
| landed/min *(control)* | - | 7.04 | 6.85 |
| accuracy % *(control)* | - | 47.92 | 44.2 |

**Both factors of the knockdown path are now on their anchors** and the residual is exact:
35.00% x 65.08% = 22.78%, against reality's own knockdown-driven share of 35.1% x 63.5% = 22.3%.
**The remaining ~10 points to ~32% is accumulation stoppages alone** - doctor stoppages and TKOs on
a man never dropped - a separate mechanism the engine still records almost none of.

`tools/s27_apply_damage_half.py` applies all five and reverts them with `--revert`.

## IT IS NOT SHIPPED, AND HERE IS EXACTLY WHAT STOPS IT

Applied for real, `fight_realtime_test` went from **8 failures to 2** - doctor stoppages, hurt-man
corner advice, corner re-grading, judo throw points and the yuko all came back. **Four floor
failures remain across three tests, and they are now a small specified job rather than an open
question:**

**1. THE ROUND-THREE FADE ASSERTION CONTRADICTS J20 AND SHOULD BE CORRECTED, NOT CHASED.**
`fight_realtime_test` asserts `thrown[3] < thrown[1]`. J20 section A, verbatim: total strikes landed
per fighter per round are **"21.0 (R1) - 26.8 (R5); roughly 21-27 and flat by round"** - reality is
flat-to-RISING. The engine now gives 1004 (R3) against 967 (R1), +3.8%, which AGREES with the
corpus. The assertion passed for the life of the project only because 6.9x the volume manufactured
exaggerated fatigue. **Fix the test against the source and quote the row in it.** Do not add a
fatigue fade the sport does not show.

**2. THE MEAN GAP IS 1% UNDER A SOURCED FLOOR.** 1.059 m against Schortgen's 1.07-1.39 m - improved
from S26's 1.038 m but still out. This is a SPACING consequence of the pace, not of damage: men who
throw less spend more time closing. It is a real miss against a real source and it needs its own
look; do not widen the band.

**3. "THREE KNOCKDOWNS IN A ROUND ACTUALLY STOP A FIGHT" (0 of 3 seeds).** At 0.378 knockdowns a
fight, three in one round is very rare in the normal population - this test uses its own extreme
fixture, so check what that fixture is before touching a constant.

**4. `may_ask` OCCURS IN AT LEAST 10% OF SEEDED BOUTS.** Still red, and it did NOT improve with the
damage raise, which is itself informative - the referee's asking is gated on something other than
head condition. Find what.

## WHAT IS OPEN, IN ORDER

1. **`HEAD_SHOCK_BASE` 0.08 → ~0.10** for KD incidence 28.33% → 35.1%. Note the coupling: a
   tightened recovery band ends bouts earlier, so incidence measured at the OLD band is slightly
   overstated. **Measure it with the recovery pair held, and confirm all three together.**
2. **`WEAR_SCALE` for the accumulation path**, against `DOCTOR_HEAD_CONDITION = 15.0` and an
   accumulation-stoppage share of roughly 10% of bouts. Sweep it and print what else moves — wear
   feeds cuts, swelling and the corner, so it is not a free dial.
3. **THE SIX OCCURRENCE FLOORS ARE THE ACCEPTANCE GATE**, not these anchors: three knockdowns in a
   round stopping a fight, the doctor stopping one, a hurt man told to protect his head, round three
   throwing fewer punches than round one, the commitment kuzushi share, and the mean gap inside
   Schortgen's band. All six must be green **with the calibrated pace live**. Only then flip
   `throw_gate_base` to `THROW_GATE_CALIBRATED` and delete the set/restore in
   `tests/fight_pace_anchor_test.gd`.
4. **Re-derive `KNOCKDOWN_FROM_SHOCK_BASE/_WEAR`** against R151's 3.9% rather than R84's own
   5.15 shocks a fight.
5. **THE ROLE MIX still bounds the per-strike rate.** 1.01% KD per landed distance power-head strike
   against 3.9%, and 30.5 such strikes a fight against the 10.5–13.3 the anchor implies. Those two
   cannot both be right while 83.2% of landed standing head strikes are in a POWER role where J20's
   arithmetic implies ~26% — the engine throws far too few jabs. **Do not chase the 3.9% by moving a
   knockdown constant; the denominator is what is wrong.**

## HOW TO REPRODUCE

```
python Godot/tools/s27_damage_sweep.py --file FightRealtime.gd \
    --const RECOVERY_FLOOR --hold RECOVERY_CEILING=0.45 0.05 -- 60
python Godot/tools/s27_damage_sweep.py --const WEAR_SCALE 0.6 1.8 3.0 4.5 -- 6
python Godot/tools/s27_damage_sweep.py --file ImpactModel.gd --const HEAD_SHOCK_BASE 0.08 0.10 -- 45
```

`-- 60` is 240 bouts, about six minutes. Every run restores by hash in `finally` and prints the
pace it actually ran at.
