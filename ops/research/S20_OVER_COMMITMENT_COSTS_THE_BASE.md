# S20 — A MAN INSIDE HIS OWN THROW IS ON A BROKEN BASE (R150 stage 3)

Claude, 2026-09-19. Operator: *"First, finish wire over commitment into
balance."* Built on `e6b9cec8`.

This completes the **striking half** of the operator's balance ruling. S19
delivered "prevent takedowns" off breaks the opponent inflicts; this delivers
*"over-committing … exposes the fighter to takedowns"* — the cost a man pays
himself.

---

## 1. IT NEEDED NO AUTHORING, AND R150 SAID IT DID

R150 §3 concluded this clause needed a new per-technique field, because the
catalogue's 140 effect keys contain no self-cost. **That was true of the
catalogue and false of the game**, and R150 now carries a correction block
saying so.

`Godot/scripts/FightCommitment.gd` — 151 lines, already live in
`FightRealtime`, already footage-measured — **is** the model. Its own J24
sourcing (Honour & Glory Boxing, Freddie Roach, Teddy Atlas) states the
operator's clause almost verbatim:

> *"Throwing a punch creates vulnerability. The attacker's guard opens,
> **their weight shifts**, and they are momentarily committed."*

Everything needed was already there and already calibrated:

| piece | where |
|---|---|
| the window length | `COMMIT_S := 0.267` — Q110/U107 p50 of extension + return over **423 lead-hand moves**, 16 videos |
| the trigger | `Commit.is_committed(fighter, tick)` |
| the state | `commit_until_tick`, set on every throw at `FightRealtime:2529` |

## 2. WHAT WAS WIRED — THREE EDITS

```gdscript
const COMMITTED_BALANCE_KUZUSHI := 0.20

static func _committed_kuzushi(state, fighter, tick) -> float:
    if not bool(state.get("commitment_window", true)):
        return 0.0
    return COMMITTED_BALANCE_KUZUSHI if Commit.is_committed(fighter, tick) else 0.0

# in _refresh_balance:
fighter["kuzushi"] = maxf(decayed, _committed_kuzushi(state, fighter, tick))
```

**A kuzushi value, not a magnitude, and that is the design point.** A break
goes through `BalanceState.apply_break` and gets a decay curve. A commitment
does not need one: **the window IS the duration**, and it clears itself when
`commit_until_tick` expires. Putting a second decay on top would have modelled
the same clock twice.

**LARGER, not summed.** They are two readings of one quantity — how far this
man's centre of gravity is from over his base — and a staggered man mid-jab is
not twice off-balance.

**It honours `commitment_window`.** A caller who switches commitment off gets
no balance cost from it either, so the two halves cannot disagree about whether
the feature is on. Pinned by a test.

## 3. THE NUMBER, AND WHY IT IS THE SMALLEST OF THE FOUR

`COMMITTED_BALANCE_KUZUSHI := 0.20` against S19's break values of 0.5–0.75.
Being mid-punch is **exposure, not a stagger**. At `KUZUSHI_DEFENCE_BITE`
(0.25) that is about a **5% cut to takedown defence**, roughly **+4 points** of
takedown success.

**It fires on every throw**, which is exactly why it must be small: this is the
one value where a big number would not be a feature but a silent rebalance of
every fight in the game.

**ONE VALUE FOR EVERY THROW**, and that is `COMMIT_S`'s own precedent rather
than a shortcut. Q110's instrument tracked the **lead hand only**, so
`FightCommitment` itself applies one window to every throw *"for want of a
second figure"*. A rear hand and a kick commit harder; **TASK_U110 is the
assigned research** and it is PC-only. A feint gets a shorter window already
and is deliberately **not** scaled down further here, for the same reason.

## 4. THE MEASUREMENT — AND THE SPLIT IS THE POINT

`tools/probe_balance_exposure.gd` now splits exposure, because one total would
hide the whole story: a break is **rare and deep**, a commitment is **constant
and shallow**, and adding them into one percentage says nothing about either.

12 MMA bouts, 3 rounds, grappler vs striker, **345,400 fighter-ticks**:

| | S19 | S20 |
|---|---|---|
| EXPOSURE, any kuzushi | 0.78% | **13.22%** |
| …of which a real BREAK | 0.78% | **0.74%** |
| …committed (own throw) | — | **12.57%** |
| mean kuzushi while broken | 0.378 | 0.210 |
| peak | 0.750 | 0.750 |

Takedown success, same two men, 101 evenly spaced rolls:

| defender | kuzushi | landing |
|---|---|---|
| square | 0.000 | **35 / 101** |
| **committed (mid-throw)** | 0.200 | **39 / 101** |
| peak break | 0.750 | 50 / 101 |

**Read it as two regimes.** A man is mid-throw **12.57%** of the time and pays
about four points of takedown defence for it — constant background texture. He
is genuinely broken **0.74%** of the time and pays up to fifteen — the real
opening. The break figure is **unchanged from S19** (0.74% vs 0.78%, 82 breaks
vs 85), which is the control: adding the commitment cost did not disturb the
break path.

### 4a. A PROBE BUG CAUGHT BY THAT CONTROL, WORTH RECORDING

The first S20 run reported break exposure at **2.95%** — four times S19's
figure for the same break count, which is impossible. The cause was in the
probe, not the engine: it inferred "is this a real break" by comparing kuzushi
against the commitment floor, which miscounts every tick where the two
coincide. Measuring the break **directly** off `balance_state` gave 0.74%.

**The lesson is the reason the S19 column is in the table at all:** a figure
that should not have moved is the cheapest bug detector available, and it only
works if you print it.

## 5. ONE TICK OF LAG, STATED BECAUSE IT IS REAL

`_refresh_balance` runs at the **top** of `advance_tick`, and a throw later in
the same tick sets `commit_until_tick` after it. So the cost appears on the
**next** tick — 50 ms at 20 Hz. The test measures it rather than hiding it:
**82.7%** of committed fighter-ticks carry the cost, which is exactly a
one-tick lag on a ~5-tick window.

Refreshing after the impact pass instead would swap that for a stale read on
everything resolving *before* it, which is worse.

## 6. WHAT THIS DOES NOT DO

- **It does not double-count with existing commitment.** `is_committed` today
  suppresses only the thrower's **striking** defence — he cannot slip a punch,
  but until now he sprawled at full strength. The takedown channel is exactly
  what the ruling says over-extension should cost him.
- **It does not add an RNG draw**, so no stream position moves and R82's
  byte-exact replay is untouched.
- **It does not do the single-leg clause.** Blocked on U110 (PC-only) for the
  kick commitment figure, and on `technique_class` missing from 403 of 696
  catalogue nodes for the scope.
- **It does not touch `FightSimulation`**, which never references
  `GrappleResolve`.

## 6a. IT MOVED A PINNED FIGHT, AND THE TRIPWIRE CAUGHT IT

The first full suite came back **310/7** — the baseline six plus
`judge_panel_test.gd`, which pins nine seeded bouts card for card. One of the
nine moved:

```
mma_5  ["1:9-10/kd1-0", "2:9-10/kd0-0"]/TKO/
    != ["1:9-10/kd1-0", "2:9-10/kd0-0", "3:10-9/kd0-0"]/DECISION/unanimous
```

**The bout now STOPS**: a three-round unanimous decision became a round-2 TKO.
That test exists to catch exactly this and it did its job.

**A re-pin was the right answer, but only after measuring what was being
accepted.** Re-pinning a scorecard to make your own change pass is the kind of
move that needs a number behind it, so `tools/probe_balance_outcome_shift.gd`
ran 24 MMA bouts on one fixture with the constant as the only thing changed:

| | `0.0` (control) | `0.20` (shipped) |
|---|---|---|
| KO / DECISION / SUBMISSION | 6 / 12 / 6 | **5 / 14 / 5** |
| grapple attempts | 21 | 22 |

**About 8% of bouts change method, with no directional bias** — it produced
*more* decisions, not fewer, which is the opposite of the `mma_5` flip. That is
the "seamless" the ruling asks for rather than a rebalance, so the pin was
updated with a dated `S20 RE-PIN` comment carrying this measurement, following
the convention every prior engine change in that file used (S4e (5), the
commitment stage itself, re-pinned the same way).

Reproducibility was not assumed: the test's own
*"every re-pinned bout is REPRODUCIBLE — two runs of each agree card for card"*
check passes, and it is what gates the new value.

**One observation left for someone else, because it is not S20's to fix:** the
`mma_5` fixture is `{"ta": 60, "tb": 60}`, and several others in that table are
too. If those are talent figures for the two men, that brushes the standing
"never test identical fighters" rule. It predates this stage by a long way and
was not touched here — but it is worth a look.

## 7. STILL NOT BUILT (R150)

- **Stage 2** — balance scaling force delivery and impact absorption.
- **Stage 3's single-leg half** — above.
- **Stage 4** — phase-change cost on scrambles, using the non-decaying
  `stuffed_shot` cause built for exactly that.
- **Stage 5** — direction / weak lines off `FightStance`.
- **Calibration** of all five magnitudes against a target.

## 8. FILES

- `Godot/scripts/FightRealtime.gd` — `COMMITTED_BALANCE_KUZUSHI`,
  `_committed_kuzushi()`, `_refresh_balance()` takes `tick` and maxes.
- `Godot/tests/fight_balance_state_wiring_test.gd` — extended to 12 checks.
- `Godot/tools/probe_balance_exposure.gd` — exposure split, break measured
  directly.

## 9. TEST COMMAND

```
python Godot/tools/run_tests.py --only balance
```
