# TASK R86 — CLAUDE — THE TIRED MAN FIGHTS WORSE, AND TWELVE ROUNDS STOP BEING A MASSACRE

Model: Opus, high effort, Fast off. Owner: Claude. **Fresh session — do not
start this inside the R84 session.** Depends on G31 (`FatigueCurve.gd`, Grok)
and G31T (its test, Qwen). Base: `deb625a`, `SUITE total=201 fails=0`.

---

## Two things, and they are related

### A. Fatigue reaches the fight (the operator's question, 2026-09-09)

R84 wired `FightStamina` so a man's tank actually empties — he finishes a 3x5
at 57–66. But **nothing reads it except his choice of what to do.**
`FightIntent.decide` redistributes CLOSE weight as he tires; `_run_impact`
reads `technique`, `power` and `defense` **raw**. So a man at 5 stamina punches
exactly as hard, lands exactly as cleanly and defends exactly as well as a
fresh one.

`FightStamina.fatigue_fraction()` — built for precisely this — has **zero
consumers outside its own test.** That is the fifth piece of correct,
tested, unreachable code this area has produced.

Wire `FatigueCurve` (G31) into `_run_impact`:

* `technique` → scaled by `technique_multiplier(f)` before it picks the contact
  word (`FightRealtime.gd`, the contact ladder).
* `power` → scaled by `power_multiplier(f)` before `FORCE_BASE + FORCE_POWER_SPAN * power`.
* `defense` → scaled by `defense_multiplier(f)` before the `DEFENSE_BASE +
  DEFENSE_SPAN * defense` roll.
* `output_multiplier(f)` → scales the `rng.randf() > 0.35` attempt gate, so a
  gassed man throws less. **This one changes the number of impacts in a fight**,
  so check the effect on the measured rates before accepting it.

`f` is `Stamina.fatigue_fraction(float(fighter["stamina"]))`. The ACTOR's
fatigue drives technique/power/output; the TARGET's drives defense.

**Draw discipline is unchanged and non-negotiable.** None of the above adds a
draw: every one scales a number that is already computed before an existing
roll. `_rng_impact` must still take **exactly seven** draws per impact. If you
find yourself adding a draw, stop and reconsider the design.

### B. The twelve-round massacre (R84 finding 1)

A 12-round fight is stopped **100% of the time** — 22 KO, 18 doctor, zero
decisions over 40 fights. The head loses about 34 points per three rounds, so
it cannot survive twelve. **This is the WEAR rate, not the stoppage rules**
(`ImpactModel.WEAR_SCALE`, and the impact cadence that produces 812 impacts a
fight).

Fix it so a championship distance produces a believable spread — real
championship boxing goes to a decision roughly half the time. **Measure, do not
guess**: the R84 probe method is in `R84_DIGEST.md`, and the target is a
stoppage rate that is high but not total over 12, while the 3x5 stays at
roughly the 23% it is now.

**A leads into B.** Wiring output and technique decay REDUCES the damage a
tired man does, which is itself part of why twelve rounds currently annihilate
everyone. Do A first, re-measure, and only then decide how much of B is left to
fix. It is entirely possible A closes most of the gap on its own — and if it
does, say so rather than tuning `WEAR_SCALE` on top of it.

---

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/FightRealtime.gd` | 909 | Owned. **Never open it whole.** `advance_tick` `:344`, `_run_movement` `:643`, `_run_impact` `:697`. Inside `_run_impact`: the attempt gate `:702`, the contact ladder `:714`, the force floor `:747`, the defence roll `:768`. |
| `Godot/tests/fight_realtime_test.gd` | 624 | Owned. Harness `_check` `:22`, roster helpers `:33`, R84 gates in the last third. |
| `Godot/scripts/ImpactModel.gd` | 128 | Owned for part B only. Small, read whole. `WEAR_SCALE` at `:39`. |
| `Godot/tests/impact_model_test.gd` | — | Owned if `WEAR_SCALE` moves; its expectations will move with it. |

Read-only: `Godot/scripts/FatigueCurve.gd` (G31, small),
`Godot/scripts/FightStamina.gd` (125). Take the HANDOFF slice, never the file.

## Gates — assert the feature OCCURS, as R84 did

1. **The R82 replay gate, unmoved**, including scorecards, result and stoppage.
2. **`_rng_impact` still takes seven draws per impact.** Assert it, do not
   assume it.
3. **A tired man measurably fights worse.** Compare the same fighter's
   round-one and round-three clean-land rate and mean force across a sweep. A
   test that only checks `technique_multiplier` was called is the test that
   passed while nothing could run.
4. **A 12-round fight is no longer always stopped.** At least one decision
   across a championship sweep, and the 3x5 stoppage rate stays in a
   believable band.
5. Existing R84 gates all still green.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/fight_realtime_test.gd
```

## Tests

Focused first, then the consumers, then the full suite ONCE in the background:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 202 (201 plus
G31T's `fatigue_curve_test.gd`). If the total differs, say so and push.

## The trap specific to this task

**Do not let the output multiplier quietly rewrite the whole fight.** Scaling
the 0.35 attempt gate changes how many impacts a bout contains, which moves
every rate R84 measured — stoppage %, shocks/fight, knockdowns/fight, the
end-of-fight head. Re-run the R84 sweep after wiring it and put the new numbers
in the digest beside the old ones. If the stoppage rate moves outside roughly
15–30% for a 3x5, that is a regression to fix, not a new baseline to accept.
