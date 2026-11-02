# S22 — A scramble costs the man who was put on the floor

**2026-09-20. R150 stage 4.** The ruling's transitions clause — *"MMA needs
seamless adjustment between upright and grounded positions"* — and the one cause
`BalanceState` has always owned and nothing has ever been able to use.

`stuffed_shot` returns its full value from `kuzushi_at` and never fades, because
the module built it for a **position handover** that consumes it. Nothing in the
game was ever that consumer, which is why `FightRealtime:3425` had to apply a
*stagger* for a stuffed shot and spend six lines of comment saying so. S22 builds
the consumer, and then the cause has a use.

| | seam | before | after |
| --- | --- | --- | --- |
| a scramble is paid | `FightRealtime._move_seat` | a stance change moved the position and cost nobody their base | the man put on the floor carries a `stuffed_shot` |
| a scramble ends | `FightRealtime._refresh_balance` | — | the window runs out, or the next stance change consumes it |
| the window itself | `BalanceState.handover_window_s` | — | the sweep band, scaled — no new duration |

Nothing new reads it. The `kuzushi` field already feeds takedown defence (S19)
and a real break already feeds force delivery and impact absorption (S21), so a
scramble pays into all three of the operator's outputs through seams that were
already there.

---

## 1. THE BRIEF WOULD HAVE SHIPPED A 34x GLOBAL NERF — SEVEN-FOR-SEVEN

The roadmap's words were *"the man who lost the exchange carries it until it
is [consumed]"*, with the next phase change as the consumer. That is the module's
own sentence and it sounds exactly right. **It is a 34x global nerf.**

`Godot/tools/probe_scramble_census.gd` ran the engine as it stood, changed
nothing, and measured what "until the next phase change" is actually worth over
12 MMA bouts of the S19 fixture:

```
  handovers by via (n / of which change STANCE):
    clinch_break     35 /   35     clinch_engage    43 /   43
    escape           12 /    0     mount             8 /    0
    pass             10 /    0     stall             1 /    1
    stand_up          8 /    8     sweep             2 /    0
    takedown          5 /    5     throw             7 /    7
  gap to the next STANCE change  n=88  p50 15.50 s  p90 230.00 s  max 703.00 s
  gap to the next SEAT change    n=120 p50 10.00 s  p90 199.00 s  max 703.00 s
  WHAT A NON-DECAYING CARRY WOULD COST
    STANCE reading: 25.80% of fighter-ticks carry a real break
    SEAT   reading: 25.01% of fighter-ticks carry a real break
```

**S21 measured the current real-break share at 0.75%, and wired the force and
shock seams to exactly that number** on the grounds that it is rare and deep. A
p90 gap of 230 seconds means a man swept in round one is still delivering less
force and absorbing impact worse four minutes later, in a different round, on his
feet. 25.80% is not a rare event. It is the *silent global nerf* S21 refused on
the striking side, arrived at from the other direction.

**That is seven-for-seven on this arc's briefs being wrong about something, and
the measurement is again the only reason it was caught.** The pattern is now
stable enough to state as a rule: on this feature, measure the share of events
that would carry a state before scaling anything by it.

---

## 2. THE FIX IS A SQUARE, AND THE SQUARE IS THE FEATURE

A decay curve would have worked and would have been wrong — `stagger` already is
one, and stage 4 would then be S19 with a new label.

**A staggered man recovers gradually, so `stagger` ramps down. A man whose base
has been taken is fully off it right up until he lands — and what he is then is
in a BAD POSITION, not an off-balance one.** So a scramble holds at full value
and ends at once. That is the shape `kuzushi_at` already gives `stuffed_shot`
for free; all it was missing was an end.

**The end is not a new authored number.** `BalanceState.handover_window_s` reuses
`SWEEP_DECAY_MIN_S..MAX_S`, which are BORROWED time-to-stabilisation figures
(G59 §1b) — how long a man takes to get back over his base once it has gone,
which is the same physical quantity the window needs. At
`SCRAMBLE_BALANCE_MAGNITUDE` it comes out at **1.062 s**.

`kuzushi_at` is untouched and still does not fade a handover by one tick. The
window is something a CALLER consumes at, and the engine is the caller:

- `_move_seat` — any stance change clears an outstanding handover before it
  hands over a new one. This is the consumer the module was written for.
- `_refresh_balance` — the window runs out. It runs before `advance_tick` tests
  `is_resting`, so a window straddling the bell expires on the stool and nobody
  comes out for the next round still scrambling.

---

## 3. WHAT IS A SCRAMBLE, AND WHAT IS ONLY A POSITION CHANGE

**A scramble is a stance handover in which one man put the other on the floor,
and the man on the floor carries it.** That is `takedown` and `throw`.

The census is what shortened the list, because "the man who lost the exchange"
turns out to name several men whose base was never touched:

| via | n (stance) | ruling |
| --- | --- | --- |
| `takedown` | 5 | **pays** — his base was taken and he is on the floor |
| `throw` | 7 | **pays** — the same event from the clinch |
| `sweep` | 0 | already a scramble in this engine, already wearing its own cause (`:3725`, S19) |
| `clinch_break` | 35 | a DISENGAGEMENT. Nobody's centre of pressure was moved — and it is 64% of all stance handovers, so paying it would have made this stage mostly about clinch breaks |
| `stand_up` | 8 | the man underneath is already on the floor and stays there; he lost position, not his base |
| `pass`/`mount`/`back` | 0 | ground advances, and a man on his back has no base to take. They change SEAT, never stance |
| `clinch_engage`/`stall`/`count` | 44 | a tie-up and two referee resets: they consume, and start nothing |

So the engine already had **one** of the three base-taken events wired before
this stage, and S22 adds the other two. Twelve scrambles over twelve bouts.

**`sweep` was deliberately not converted to `stuffed_shot`.** It has the right
cause, it is pinned, and churning a shipped behaviour to make a stage look bigger
is not a reason.

---

## 4. BEFORE AND AFTER, AGAINST A ZEROED CONTROL

`tools/s22_control_run.py` empties `SCRAMBLE_VIAS`, which makes both consumers
inert and reproduces master's arithmetic exactly rather than rebuilding it; it
restores the engine in `finally` and verifies the restore by hash. **The control
reproduced S21's published exposure figures to the digit** (384,286 ticks, 92
breaks, 0.75%, 13.16%), which is the check that the control is a control.

### `probe_balance_exposure.gd`, 12 bouts

| | control | S22 |
| --- | --- | --- |
| fighter-ticks | 384,286 | 374,262 |
| breaks | 92 (stagger 90, sweep 2) | 102 (stagger 90, **stuffed_shot 10**, sweep 2) |
| EXPOSURE, any kuzushi | 13.16% | 13.08% |
| **of which a real BREAK** | **0.75%** | **0.82%** |
| committed (own throw) | 12.50% | 12.37% |
| mean kuzushi while broken | 0.211, peak 0.750 | 0.213, peak 0.750 |

**The stagger and sweep counts are unchanged at 90 and 2.** S22 adds a cause and
moves neither of the two that were there.

### `probe_balance_at_impact.gd`, 12 bouts — the gate

| | control | S22 |
| --- | --- | --- |
| THROWER, `kuzushi` FIELD > 0 | 36.72% | 37.13% |
| **THROWER, a real BREAK** | **0.86%** | **0.97%** |
| VICTIM, `kuzushi` FIELD > 0 | 16.09% | 15.75% |
| **VICTIM, a real BREAK** | **1.44%** | **1.48%** |

**0.86% -> 0.97% is what stage 4 is worth at the seam S21 built**, against the
25.80% the brief's reading would have put there. Rare and deep, as designed.

### `probe_balance_outcome_shift.gd`, 24 bouts

| | control | S22 |
| --- | --- | --- |
| methods | KO 6, TKO 1, DECISION 12, SUBMISSION 5 | KO 4, DECISION 14, SUBMISSION 6 |
| grapple attempts | 21 | 20 |

**These are moves, not findings.** At n=24 a swing of two knockouts is inside the
noise, and this probe is a tripwire for a column that should not have moved
rather than a population measurement. The one thing worth reading is the
direction of the submission column (+1): a man briefly off-balance after being
put down is easier to advance on, which is `GrappleResolve` reading the new break
through S19's seam.

---

## 5. THE RE-PINS

Two, both verified byte-identical across two runs before being written.

- **`judge_panel_test.gd`** — three of the nine seeded cards moved (`mma_5`,
  `mma_11`, `muay_thai_17`). Re-pinned with `tools/s21_repin_judge_cards.py`,
  which parses the cards out of the test's own printed ACTUAL and refuses any
  that will not reproduce. Two MMA bouts that finished early now go to a card;
  at n=9 that is trajectory divergence, not a claim about finish rates.
- **`grapple_adapter_test.gd`** — the R102 MT witness. **No seed hunt was needed
  this time**, which is the informative part: seed 93003 still lands its throw
  and the throw still folds to zero points, which is what the witness is for.
  Three of its six striking numbers moved and three did not — and the three that
  moved are rounds *after* the throw, where a scramble can reach, while round one
  for both men is untouched, where it cannot.

`fight_realtime_test`'s ground seed did NOT need re-finding (`--only realtime`
came back 3/3) and neither did T11's pair.

---

## 6. WHAT IS STILL OPEN

**Eight authored magnitudes now carry this feature and not one is calibrated
against a target** — the seven S19/S20/S21 left, plus `SCRAMBLE_BALANCE_MAGNITUDE`
(9.0). It sits between the stuffed shot (8.0) and the sweep (10.0) on the
argument that being put on the floor is the sweep's event seen from the other
side, and heavier than being stuffed on a shot you were driving yourself. That is
a reason, not a calibration.

**One value covers both vias**, which is `FightCommitment`'s own precedent ("for
want of a second figure") rather than a shortcut. A slam and a trip do not cost a
base the same. Splitting them is the obvious next calibration and would have
added a ninth uncalibrated number to pay for it here.

**The window is sourced and the magnitude is not**, so the honest summary is that
S22 knows how long a scramble lasts and is guessing how deep it is.

---

## 7. TEST COMMAND

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_balance_state_wiring_test.gd
```

36 checks. Checks 13-16 are S22's: the window is square and then expires, the
consumer cannot reach a decaying cause, a scramble fires on the man who was put
down, and **no man ever carries one longer than its window** — which is the
regression pin for the 25.80% this stage nearly shipped.
