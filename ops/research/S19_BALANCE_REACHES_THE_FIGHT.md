# S19 — BALANCE REACHES THE FIGHT (R150 stages 0 and 1)

Claude, 2026-09-19. Operator greenlit: *"go, do 0+1"*. Built on `19e585ed`.

R150 designed six stages from the operator's definition of balance. This ships
the first two. **Stages 2–5 are deliberately not built** and are listed in §7.

---

## 1. STAGE 0 — THE READ, AND IT KILLED ITS OWN CANDIDATE

R150 made stage 0 *"read `counter_open`'s real direction"*, because the whole
self-inflicted-balance design (stage 3) hung on whether the catalogue already
had a vocabulary for a man exposing himself.

**It does not. `counter_open` is a BENEFIT, not a cost.** Measured over its 54
carriers:

- **41 of 54 are `role: defense`** — `boxing_slip`, `boxing_parry`,
  `boxing_shoulder_roll`, `boxing_pull` — and they carry it *alongside*
  `evasion` or `block`.
- 7 more are `role: counter` (`boxing_slip_counter`, `boxing_pull_counter`).

So `counter_open` means **"this move opens a counter FOR ME"**. It is the payoff
for a successful defensive move, not a penalty for over-committing. The
suspicion R150 recorded — that `FightMoves` treats sibling `*_open` words as
striking *setup* — was right.

**Consequence, and it is the useful half of stage 0:** the catalogue has **140
distinct effect keys over 696 techniques and not one of them is the attacker's
own balance cost.** The operator's over-commitment and single-leg clauses cannot
be derived from existing data. **Stage 3 needs new authoring, and
`counter_open` must not be repurposed for it** — doing so would invert the
meaning of 41 defensive techniques.

## 2. STAGE 0 — THE TAG, ANSWERED AND ITS REASONING KEPT

`balance` now maps to **`speed`**, and the reasoning is in the code beside the
key because the two obvious answers were both wrong:

- R147 proposed `grapple`. R149 measured that `grapple`, `defense` **and**
  `technique` are every one of them **inert** — gains de-duplicate by canonical
  stat and `judo_tatami_area`, the only station carrying `balance`, already
  carries all three.
- The operator then ruled balance is *"dynamic control of your center of gravity
  over a **shifting base** of support"*. A shifting base is footwork, and the
  standing footwork ruling already makes footwork *"the catalyst in transitioning
  **defined by speed**"*.

So `speed` is the one mapping consistent with both rulings, and the only one
that is not decorative. `judo_tatami_area` now captions and trains
**technique, speed, defense, grapple** — four stats, up from three.
`AWAITING_OPERATOR_RULING` in the map test is now **empty**.

## 3. STAGE 1 — WHAT WAS WIRED

`BalanceState.gd` had **zero production callers** since it was written. It has
three now.

**Every fighter carries two fields** (`FightRealtime._build_fighter`):
`balance_state` (the module's own record) and `kuzushi` (that state **sampled at
the current tick**). The sample exists so `GrappleResolve` can read a plain
float and keep its "one preload" property — it owns arithmetic and has no clock.
`advance_tick` refreshes both men once per tick, before anything reads them.

**Three causes are wired, each to an event the engine already produced:**

| trigger | who pays | cause | the ruling's clause |
|---|---|---|---|
| a shocked (hurt) man | the man hit | `stagger` | **"absorb impact"** |
| a stuffed takedown | **the shooter** | `stagger` | **"over-committing … exposes the fighter to takedowns"** |
| a sweep from half guard | the man who was on top | `sweep` | **"disruption … manipulating their center of pressure"** |

**And `GrappleResolve` reads it** — the line its own header specified:

```gdscript
def_score *= (1.0 - KUZUSHI_DEFENCE_BITE * _kuzushi(defender))
```

### 3a. THE CAUSE TRAP THIS STEPPED AROUND

The obvious cause for a failed takedown is `stuffed_shot`. **It is the wrong
one, and using it would have been a bug that no test would have caught for
months.** `kuzushi_at` does **not decay** a `stuffed_shot` — it returns full
value until something consumes it, because the module built that cause for a
**position handover** (`is_position_handover()` exists for exactly that). A
stuffed shot in this engine hands over nothing: both men stay standing. The
shooter would have been left off-balance **for the rest of the bout**.

`stagger` decays over 0.5–2.0 s, which is the real thing.
`fight_balance_state_wiring_test` pins **both halves** — that `stagger` decays
to zero, and that `stuffed_shot` still does not — so the trap is documented by a
failing assertion rather than a comment.

## 4. WHERE THIS DEVIATES FROM THE SPEC, AND WHY

`BalanceState.gd:12` specifies the raw form: *"multiply defender resistance by
`(1.0 - kuzushi_at(...))`"*. **Shipped with a coefficient instead, and the
deviation is deliberate.**

Measured before choosing: `def_score` is a weighted stat sum sitting near 50 and
`PROB_SCALE` is 0.012, so a **raw** kuzushi of 0.75 moves takedown success
probability by about **0.30**. One shocked man would go from a coin flip to
near-certain — which is not the *"seamless balance adjustment"* the ruling
describes.

`KUZUSHI_DEFENCE_BITE := 0.25` is therefore **AUTHORED and deliberately
conservative**, labelled as such in the source. It is precisely the calibration
R150 §8 records as not supplied by the ruling, and it is the first number to
move when this is tuned against a real target.

## 5. THE MEASUREMENT — TWO NUMBERS, BECAUSE THEY MULTIPLY

A large effect that fires almost never is nothing; a small one that fires
constantly is a rebalance nobody asked for. `tools/probe_balance_exposure.gd`,
**12 MMA bouts, 3 rounds, grappler vs striker** (differentiated in every stat,
both legal under MMA), **344,904 fighter-ticks**:

| | value |
|---|---|
| breaks | **85** (`stagger` 83, `sweep` 2) — about **7 per bout** |
| **EXPOSURE** — share of standing ticks with a broken base | **0.78%** |
| mean kuzushi while broken | **0.378** (peak 0.750) |

And the bite, on the real arithmetic at the values actually observed rather than
at a hypothetical 1.0 nobody reaches — same two men, 101 evenly spaced rolls:

| defender | kuzushi | takedowns landing |
|---|---|---|
| square | 0.000 | **35 / 101** |
| mean break | 0.378 | **42 / 101** |
| peak break | 0.750 | **50 / 101** |

**Read together: a man's base is broken for well under 1% of the fight, about
seven times a bout, and while a window is open a takedown on him goes from 35%
to 42–50%.** That is a real, occasional opening rather than a new dominant
mechanic — which is what the ruling's "seamless" asks for.

**The honest caveat: `sweep` fired only twice in 12 bouts.** Nearly all the
exposure is `stagger` off shocked men. The sweep path is wired and proven live
by the test, but it is rare enough that its contribution is not measured here.

## 6. WHY THE EXISTING SEEDED BOUTS SURVIVE

- **`FightSimulation` does not use `GrappleResolve` at all** (zero references),
  so the atomic seeded engine and every test resting on its byte-identical
  replay are outside the blast radius entirely.
- **No RNG draw was added anywhere.** `apply_break` and `kuzushi_at` are pure,
  so no stream's position moves and R82's byte-exact replay is untouched by the
  existence of the calls.
- **The multiplication is exactly 1.0 for an unbroken man**, and the test pins
  that a fighter with no `kuzushi` field resolves identically to one with
  `kuzushi: 0.0` across 101 rolls.

## 7. WHAT IS NOT BUILT

- **Stage 2** — balance scaling **force delivery** and **impact absorption**.
  Two of the ruling's three outputs. Stage 1 delivers only "prevent takedowns"
  plus the state the other two will read.
- **Stage 3** — self-inflicted balance cost. **Blocked on new authoring**, per
  §1, plus `technique_class` missing on 403 of 696 nodes.
- **Stage 4** — phase-change cost on scrambles.
- **Stage 5** — direction / weak lines off `FightStance`.
- **Calibration** of all four magnitudes against a target.

## 8. FILES

- `Godot/scripts/GrappleResolve.gd` — `KUZUSHI_DEFENCE_BITE`, `_kuzushi()`, one
  multiplication in `_success_probability`.
- `Godot/scripts/FightRealtime.gd` — `Balance` preload, three authored
  magnitudes, `balance_state`/`kuzushi` on every fighter, `_break_balance()`,
  `_refresh_balance()`, three wirings.
- `Godot/scripts/AthleteStatModel.gd` — `balance` → `speed`.
- `Godot/tests/training_modifier_map_test.gd` — exemption cleared, tatami
  caption pinned to all four stats.
- new `Godot/tests/fight_balance_state_wiring_test.gd` — 9 checks.
- new `Godot/tools/probe_balance_exposure.gd` — the measurement.

## 9. TEST COMMAND

```
python Godot/tools/run_tests.py --only balance
```

---

## 10. AFTER-THE-FACT FINDING — STAGE 3 IS TEN LINES, NOT AN AUTHORING PASS

Asked how to fix the missing self-cost vocabulary, and the answer turned out to
be that it is not missing. **`FightCommitment.gd` (151 lines, live in
`FightRealtime`, footage-measured) is the model**, and its J24 sourcing states
the operator's clause almost verbatim — *"the attacker's guard opens, their
weight shifts, and they are momentarily committed"* (Honour & Glory Boxing,
Freddie Roach, Teddy Atlas). `COMMIT_S` 0.267 s is Q110's p50 over 423
lead-hand moves; `Commit.is_committed()` is the trigger; `commit_until_tick` is
set on every throw at `FightRealtime:2529`.

So §1's conclusion — that the over-commitment clause needs new authoring — is
**superseded**, and `R150_BALANCE_DESIGN.md` now carries the correction. The
wiring is: while a man is inside his own throw he carries a standing kuzushi,
and `_refresh_balance` takes the larger of that and any decaying break. It does
NOT double-count: `is_committed` today suppresses only his STRIKING defence, so
he cannot slip a punch but sprawls at full strength — and the takedown channel
is precisely what the ruling says over-extension should cost him.

Only the **single-leg** half stays blocked, on U110 (PC-only; the rear-hand and
kick commitment figure `FightCommitment`'s own header says is not measured) and
on `technique_class` missing from 403 of 696 nodes.

**NOT BUILT — offered to the operator and awaiting their word.**
