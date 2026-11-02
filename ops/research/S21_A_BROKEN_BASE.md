# S21 — A broken base delivers less force and absorbs impact worse

**2026-09-19. R150 stage 2, and the last of the operator's three outputs for
balance.** The ruling gives balance three jobs — "deliver maximal force, absorb
impact, and prevent takedowns". S19 wired the third and built the state; S20 put
a man's own throw on his base. This is the other two.

Both are read in `FightRealtime._run_impact`, and neither adds a draw or a
subsystem. It is the state that was already on every fighter, read in two more
places.

| | seam | before | after |
| --- | --- | --- | --- |
| deliver maximal force | `FightRealtime.gd:2715-2716` | `FORCE_BASE + FORCE_POWER_SPAN * power` | `... * power * (1.0 - BROKEN_BASE_FORCE_LOSS * thrower_break)` |
| absorb impact | `FightRealtime.gd:2908-2910` | `Impact.shock_chance(impact, head_remaining)` | `... * (1.0 + BROKEN_BASE_SHOCK_GAIN * victim_break)`, clamped to 1.0 |

`BROKEN_BASE_FORCE_LOSS` is 0.50 and `BROKEN_BASE_SHOCK_GAIN` is 0.60. Both are
**AUTHORED AND NOT CALIBRATED**, like the five balance magnitudes already in the
file. The ruling gives the shape and no number.

---

## 1. THE BRIEF NAMED THE WRONG QUANTITY, ON BOTH SIDES

R150 put force delivery in `FightSimulation` — `kuzushi` does not exist there.
The roadmap corrected that to `FightRealtime._run_impact` and both line numbers
checked out on disk. What it did **not** correct is which quantity to read, and
that was the whole decision this stage turned on.

`fighter["kuzushi"]` is the LARGER of a decaying break and a flat
`COMMITTED_BALANCE_KUZUSHI` (0.20) carried through a man's own commitment window
(S20). The man computing force is **by definition mid-throw**. So the gate
measurement was: how often is a thrower's field actually above zero?

`Godot/tools/probe_balance_at_impact.gd`, 12,138 strikes over 12 MMA bouts,
grappler vs striker, MMA catalogue:

```
  THROWER   kuzushi FIELD > 0 on   4489/ 12138 =  36.98%   mean 0.204
            real BREAK   > 0 on    104/ 12138 =   0.86%   mean 0.383
  VICTIM    kuzushi FIELD > 0 on   1957/ 12138 =  16.12%   mean 0.220
            real BREAK   > 0 on    177/ 12138 =   1.46%   mean 0.418
  action strikes only, thrower side:
    thrown off the FIELD       37.20%
    thrown on a real BREAK      0.86%
```

**Reading the field on the thrower side would have been a standing ~5% tax on
37% of every strike in the game** — a silent global nerf, not the ruling's
"seamless". So force reads `Balance.kuzushi_at(balance_state, seconds)`: a REAL
break, 0.86% of strikes, mean 0.383. Rare and deep.

**AND THE VICTIM SIDE HAD THE SAME DEFECT, WHICH THE BRIEF DID NOT EXPECT.**
The roadmap said to take `:2811` "as specified — it is clean", on the premise it
would fire on the 0.74% of ticks where someone is genuinely broken. The victim's
field reads **16.12%**, because a counter lands on a man who is himself
mid-punch. And commitment already costs him there: `FightRealtime.gd:2717`
suppresses his entire defence channel while his window is open. Charging it
again into how well he absorbs the blow is the same cost twice.

So both seams read a real break. **That is six-for-six on this arc's briefs
being wrong about something**, and the measurement is the only reason it was
caught.

### What the probe's number is worth

The reconstruction is exact but for one gap, and the gap points one way. A
grapple break landing earlier in the SAME tick (`:3313`/`:3613`) is not in the
probe's snapshot, so the break-at-impact shares are a **floor**, never an
overestimate. Real breaks occupy 0.74% of ticks in total, so the gap is small —
and a bias whose direction you have measured is a bound rather than doubt (S14).

---

## 2. THE EXPOSURE PROBE: THE COLUMN THAT SHOULD NOT HAVE MOVED, AND DID NOT

`tools/probe_balance_exposure.gd`, 12 bouts. Control is both constants at 0.0,
which reproduces master's arithmetic exactly (`x * 1.0`) rather than being a
second build of it — run through `tools/s21_control_run.py`, which restores the
engine in `finally` and verifies the restore by hash.

| | control | S21 |
| --- | --- | --- |
| fighter-ticks | 345,400 | 384,286 |
| breaks | 82 (stagger 81, sweep 1) | 92 (stagger 90, sweep 2) |
| EXPOSURE, any kuzushi | 13.22% | 13.16% |
| of which a real BREAK | 0.74% | 0.75% |
| committed (own throw) | 12.57% | 12.50% |
| mean kuzushi while broken | 0.210, peak 0.750 | 0.211, peak 0.750 |
| **takedown bite, 101 rolls** | **35 / 39 / 39 / 50** | **35 / 39 / 39 / 50** |

The control column reproduces S19/S20's published 0.74% to the digit, which is
what makes it a control.

**The takedown bite row is byte-identical and that is the point** (S20's
lesson: keep the column that should not move). S21 touches force and shock and
never `GrappleResolve`, so a move there would have been a bug. Real-break
exposure held at ~0.75%, which also says the shock → stagger → easier-to-shock
feedback did **not** spiral.

---

## 3. WHAT IT DOES TO FIGHTS

Three unselected populations, because the pinned tests are a SELECTED sample and
cannot measure a base rate.

**`tools/probe_balance_outcome_shift.gd`, 24 MMA bouts, grappler vs striker:**

| | control | S21 |
| --- | --- | --- |
| methods | KO 5, DECISION 14, SUBMISSION 5 | KO 6, DECISION 12, TKO 1, SUBMISSION 5 |
| grapple attempts | 22 | 21 |

**2 of 24 bouts (8.3%) changed method**, both from a decision to a stoppage. The
same order as S20's ~8%. Submissions unchanged at 5.

**The MT witness sweep, 400 unselected muay thai bouts** (`tools/find_r102_seeds.gd -- mt`):

| | S4m (2026-09-17) | S21 |
| --- | --- | --- |
| SUBMISSION | 186 | 181 |
| DECISION | 155 | 144 |
| KO | 59 | 71 |
| TKO | — | 4 |

**Twelve more knockouts, eleven fewer decisions.** The submission share barely
moves — again the column that should not have moved.

**The T11 panel sweep, 600 boxing and 600 kickboxing bouts.** Boxing splits have
now thinned twice running over the same range: 5 (S4f) → 2 (S4m) → 1. Same
direction: a fight that ends early hands in no card for three judges to disagree
over.

---

## 4. THE THREE TRIPWIRES, AND WHAT EACH COST

None was relaxed and no constant was moved to put an old result back.

**`grapple_adapter_test.gd` — the MT witness, re-found a FIFTEENTH time.** Seed
93014 stopped landing its one throw. The same sweep over the same 93000..93399
found eighteen; 93003 is the first ascending, and its striking totals are pinned
from the sweep's own printed numbers. **Its card is 30-24 unanimous — five
witness seeds running without a digit moving**, and this one through a change
that put twelve more knockouts into the same 400 bouts. The card is a property
of the matchup.

**`judge_panel_test.gd` — nine of the thirteen cards.** Parsed out of the test's
own printed actual by `tools/s21_repin_judge_cards.py`, never transcribed, and
each required to reproduce across TWO runs before it was written. The FAIL line
prints `key ACTUAL != EXPECTED` and reading it the other way round silently
re-pins the old card. `boxing_11`, `boxing_20`, `kickboxing_14` and `boxing_300`
did not move.

**`judge_panel_test.gd` T11 — the split half only.** Boxing 436 hands in a
unanimous draw now. The same widened sweep, re-run unchanged, gives boxing 1
split (535) and kickboxing 5 splits and 4 majorities — **kickboxing 396 survived
as the majority**, so only the split was re-found and the pair is still a SPLIT
and a MAJORITY, one ruleset each, each the first hit ascending.

---

## 5. THE TEST

`Godot/tests/fight_balance_state_wiring_test.gd` goes from 12 checks to 25.
The five new ones:

8. **Neither constant can invert anything** — walked over the whole kuzushi
   range, not spot-sampled. Force multiplier stays in 0..1 and falls; shock
   multiplier never drops below 1.0, so being off balance never PROTECTS a man.
9. **A blow that cannot shock still cannot shock** — asserted against the real
   `ImpactModel.shock_chance` for four impacts it returns zero for. Zero times
   any gain is zero: the region rules belong to `ImpactModel` and a caller-side
   multiplier must not overrule them.
10. **"Deliver maximal force", end to end** — the same seeded bouts run twice,
    one man held on a deep break throughout. **Mean force 0.5512 against
    0.6223.**
11. **"Absorb impact", end to end, normalised** — shocks per *shockable strike
    received*, not shocks, because a broken base also changes how long a man
    stays standing. **0.0609 against 0.0545.**
12. **The decision, pinned** — 93.8% of every kuzushi-positive fighter-tick is a
    man inside his own throw rather than a break, and no man without a live
    break carries more than the commitment cost (0 of 15,014 over it). With 10
    and 11 establishing that the seams move with a real break, that is the
    guard. Neither half is one on its own.

A `shocks` witness counter was added to `state` alongside `impacts_built` and
`feints_thrown` — shock was the one channel with no counter, which made
"balance made this man easier to hurt" a claim nothing could measure. It costs
no draw and gives R84's "5.43 shocks a fight" a way to be re-measured.

### Two things the checks got wrong first, recorded because both are cheap traps

**A `balance_state` KEEPS its cause after the break has fully decayed.** Check
12 first discriminated on `cause == ""`, which throws away every man who has been
staggered once at any point in the bout — it reported 16.0% where the exposure
probe says ~94%. **A state is not still broken because it remembers being.**

**`_refresh_balance` samples at the top of a tick and a test reads at the end of
it.** 28 of 15,014 ticks showed a man carrying a decayed stagger's last 50 ms
instead of the commitment floor exactly. The assertion that actually guards the
seam is at-or-below, not equal: what must never happen is the field being LARGER
than the commitment cost while no break is live.

---

## 6. WHAT IS LEFT

R150 stage 4 (phase-change cost on scrambles, using the non-decaying
`stuffed_shot` cause built for exactly that), then stage 5 (direction / weak
lines off `FightStance`). Stage 3's single-leg half stays blocked on U110.

**All five balance magnitudes are AUTHORED and not one is calibrated against a
target.** S21 adds two more of the same kind. That is now seven authored numbers
carrying the whole feature, and it is the obvious next thing to be wrong about.
