# Q39 — Our Engine's Outputs, in UFC Units

**Measured at commit:** `6d2038e8ab68`
**Test:** `Godot/tests/fight_ufc_units_test.gd`
**Seeds:** 200000–200199 (200 bouts per ruleset), same fighter pair as Q34–Q38
**Rulesets:** MMA primary, boxing secondary
**NOTE:** Claude is rewriting `_run_movement` for the Q38 speed defect. These
numbers are PRE-REWRITE. They will move when that lands.

---

## 1. Strikes Landed and Absorbed per Minute

### MMA (denom: 2881.67 min of total fight-time across 200 bouts, both fighters)

| Metric | Fighter A | Fighter B | Both (combined) | Per fighter |
|--------|-----------|-----------|-----------------|-------------|
| Landed/min | 15.75 | 15.34 | 31.09 | ~15.5 |
| Attempted/min | 27.06 | 27.41 | 54.46 | ~27.2 |

### Boxing (denom: 3114.56 min of total fight-time across 200 bouts, both fighters)

| Metric | Fighter A | Fighter B | Both (combined) | Per fighter |
|--------|-----------|-----------|-----------------|-------------|
| Landed/min | 13.86 | 13.36 | 27.23 | ~13.6 |
| Attempted/min | 23.74 | 23.92 | 47.66 | ~23.8 |

**Definition:** "Landed" = contact is `clean`, `glancing` or `absorbed` — any
strike that caused wear to the target's body condition. "Attempted" = every
`action` event in the log (the range gate at `FightRealtime.gd:1192` has
already rejected out-of-range attempts before they reach the log).

**Caveat:** This is ALL strikes, not "significant strikes." The engine does not
distinguish significant from non-significant. Every landed blow counts,
including light glancing shots that a real scorekeeper might exclude.

---

## 2. Striking Accuracy

### MMA (denom: 156,945 attempts, both fighters)

| Fighter | Landed | Attempted | Accuracy |
|---------|--------|-----------|----------|
| A | 45,379 | 77,972 | 58.2% |
| B | 44,207 | 78,973 | 56.0% |
| Both | 89,586 | 156,945 | 57.1% |

### Boxing (denom: 148,431 attempts, both fighters)

| Fighter | Landed | Attempted | Accuracy |
|---------|--------|-----------|----------|
| A | 43,178 | 73,945 | 58.4% |
| B | 41,623 | 74,486 | 55.9% |
| Both | 84,801 | 148,431 | 57.1% |

**Definition:** Landed (clean + glancing + absorbed) divided by attempted (all
action events in the log). The range gate has already filtered attempts that
were out of striking distance.

---

## 3. Target Distribution

### MMA (denom: 89,586 landed strikes, both fighters)

| Region | Count | Share of landed |
|--------|-------|-----------------|
| Head/neck | 53,739 | 60.0% |
| Torso/core | 24,981 | 27.9% |
| Legs (L+R) | 10,866 | 12.1% |
| Arms (L+R) | 0 | 0.0% |

### Boxing (denom: 84,801 landed strikes, both fighters)

| Region | Count | Share of landed |
|--------|-------|-----------------|
| Head/neck | 50,811 | 59.9% |
| Torso/core | 23,729 | 28.0% |
| Legs (L+R) | 10,261 | 12.1% |
| Arms (L+R) | 0 | 0.0% |

**DEFECT — Boxing has 12.1% leg strikes.** Boxing should have zero. The
`TARGET_WEIGHTS` table in `FightRealtime.gd:311` is a single table shared
across all rulesets, with `left_leg: 0.06` and `right_leg: 0.06`. There is no
ruleset override. Arms are 0.00 for all rulesets — no arm strikes are possible
in any ruleset.

Q32 measured 65.3 / 28.2 / 3.2 / 0 on a different seed set. The head share
has dropped from 65% to 60% and legs have risen from 3.2% to 12.1%. The Q32
seed set and fighter pair may differ; the TARGET_WEIGHTS table itself has not
changed (it has always been 60/28/6/6/0/0).

---

## 4. Position Split

### MMA (denom: 152,680.1 s of active fight-time, both fighters)

| Position | Seconds | Share of fight-time |
|----------|---------|---------------------|
| Distance (standing) | 143,522.8 | 94.0% |
| Clinch | 2,631.1 | 1.7% |
| Ground | 6,526.3 | 4.3% |

**Control time** (ground, dominant seat — side/mount/back at full weight, half
at half weight): 4,277.4 s = **71.3 min** total across 200 bouts = **0.36 min
per bout**.

### Boxing (denom: 164,973.5 s of active fight-time, both fighters)

| Position | Seconds | Share of fight-time |
|----------|---------|---------------------|
| Distance (standing) | 164,973.5 | 100.0% |
| Clinch | 0.0 | 0.0% |
| Ground | 0.0 | 0.0% |

Boxing is 100% standing as expected — the grappling module is disabled for
non-grappling rulesets.

---

## 5. Takedowns and Submissions

### MMA (denom: 192.11 x 15-min fights)

| Metric | Count | Rate |
|--------|-------|------|
| Takedown attempts | 159 | 0.83 per 15 min |
| Takedowns landed | 82 | 51.6% accuracy |
| Throws landed | 0 | — |
| Submission attempts | 88 | 0.46 per 15 min |

**Definition:** A "takedown attempt" is a shot from standing (both the failed
shots logged as `takedown_attempt` and the successful ones logged as
`takedown` after the hold gate clears). "Takedowns landed" = successful shots
that passed the 20-tick hold gate. "Throws" = takedowns from the clinch (via
`throw`); zero in this seed set. "Submission attempts" = submission openings
from a dominant ground seat.

### Boxing

Zero takedowns, zero submissions — correct for the ruleset.

---

## 6. Outcomes

### MMA (denom: 200 bouts)

| Outcome | Count | Share of bouts |
|---------|-------|----------------|
| **Finish** | 65 | 32.5% |
| — KO/TKO | 41 | 20.5% |
| — Submission | 24 | 12.0% |
| — Doctor stoppage | 0 | 0.0% |
| **Decision** | 135 | 67.5% |

**Decision type (denom: 135 decisions):**

| Type | Count | Share |
|------|-------|-------|
| Unanimous | 120 | 88.9% |
| Split | 2 | 1.5% |
| Majority | 2 | 1.5% |
| Draw | 0 | 0.0% |

**Finish by round (denom: 65 finishes):**

| Round | Count | Share |
|-------|-------|-------|
| 1 | 22 | 33.8% |
| 2 | 19 | 29.2% |
| 3 | 24 | 36.9% |

### Boxing (denom: 200 bouts)

| Outcome | Count | Share of bouts |
|---------|-------|----------------|
| **Finish** | 34 | 17.0% |
| — KO/TKO | 34 | 17.0% |
| — Submission | 0 | 0.0% |
| **Decision** | 166 | 83.0% |

**Decision type (denom: 166 decisions):**

| Type | Count | Share |
|------|-------|-------|
| Unanimous | 152 | 91.6% |
| Split | 0 | 0.0% |
| Majority | 3 | 1.8% |
| Draw | 0 | 0.0% |

**Finish by round (denom: 34 finishes):**

| Round | Count | Share |
|-------|-------|-------|
| 1 | 12 | 35.3% |
| 2 | 11 | 32.4% |
| 3 | 11 | 32.4% |

---

## 7. Knockdowns

### MMA (denom: 200 bouts, 172,900.1 s fight-time = 192.11 x 15-min)

| Metric | Value |
|--------|-------|
| Total knockdowns | 110 |
| Per fight | 0.550 |
| Per 15 min | 0.57 |
| Bouts with ≥ 1 KD | 85 / 200 (42.5%) |

### Boxing (denom: 200 bouts, 186,873.5 s fight-time = 207.64 x 15-min)

| Metric | Value |
|--------|-------|
| Total knockdowns | 92 |
| Per fight | 0.460 |
| Per 15 min | 0.44 |
| Bouts with ≥ 1 KD | 79 / 200 (39.5%) |

**Definition:** A knockdown is the engine's `knockdown` flag on an action
event — a shock roll that passed the `KNOCKDOWN_FROM_SHOCK_BASE + wear` gate
at `FightRealtime.gd:132-135`. This is a knockdown that actually happened,
not just a "hurt" state (which is `shocked`, a separate and more common flag).

R84 measured 41.5% of bouts with a knockdown. This measurement finds 42.5%
(MMA) and 39.5% (boxing) — comparable, on a different seed set and with the
engine having changed since R84.

---

## 8. Round-by-Round Decay

### MMA

| Round | Landed | Attempted | Accuracy |
|-------|--------|-----------|----------|
| 1 | 38,112 | 66,311 | 57.5% |
| 2 | 28,577 | 50,132 | 57.0% |
| 3 | 22,897 | 40,502 | 56.5% |

**Decay ratio (R3 / R1): 0.60** — Round 3 output is 60% of Round 1.

### Boxing

| Round | Landed | Attempted | Accuracy |
|-------|--------|-----------|----------|
| 1 | 33,626 | 58,423 | 57.6% |
| 2 | 27,581 | 48,331 | 57.1% |
| 3 | 23,594 | 41,677 | 56.6% |

**Decay ratio (R3 / R1): 0.70** — Round 3 output is 70% of Round 1.

**Fatigue decay IS visible in the output.** R86 wired `FatigueCurve` into
output, defence and power. The landed-strike count falls ~40% (MMA) to ~30%
(boxing) from R1 to R3. Accuracy falls only ~1 percentage point, so the decay
is primarily in RATE (fewer strikes thrown) rather than accuracy.

---

## NOT DERIVABLE

Things a real UFC statistic would want that our engine cannot currently produce:

1. **Significant strikes vs total strikes.** The engine counts every landed blow
   equally. There is no "significant" filter. Real UFC stats exclude
   non-significant strikes (light touches, non-damaging contact). Our "landed"
   includes everything that caused wear, which is broader than significant
   strikes but narrower than "every swing" (since the range gate filters
   distance).

2. **Strike type breakdown.** The engine has no punch/kick/knee/elbow
   distinction. Every strike is the same abstract event with a region and a
   force. You cannot separate jabs from crosses from leg kicks.

3. **Arm strikes.** `TARGET_WEIGHTS` has `left_arm: 0.00` and `right_arm: 0.00`
   for all rulesets. No strike ever targets the arms. Real fights do have arm
   strikes (body hooks that catch the guard, etc.) but they are a small share.

4. **Boxing leg strikes.** The same `TARGET_WEIGHTS` table gives legs 12% in
   boxing, where they should be 0%. There is no ruleset-specific override.

5. **Control time by position.** We can measure total control time (dominant
   ground seat), but the engine does not expose a breakdown by mount vs side
   control vs back control as separate durations. The `grapple` state has the
   current seat but we would need to tick-count each seat separately.

6. **Strikes absorbed per minute (defensive stat).** We can compute this
   (fighter A's landed-on-B divided by fight time), but the engine's log
   records `actor` and `target` per event, so it IS derivable — it just was
   not broken out per-target in this measurement. The per-fighter landed/min
   figures above are each fighter's OFFENSIVE output; the defensive counterpart
   (what he absorbed) is the other fighter's landed count.

7. **Time of stoppage distribution.** We record which round a finish happened
   in but not the exact fight-second within the round. The `stoppage` dict on
   the state has `t_s` but the test did not extract it.

8. **Knockdown-to-finish conversion.** We know how many knockdowns happened
   and how many fights ended by KO/TKO, but we do not track whether a specific
   knockdown CAUSED the stoppage or whether the fight continued after a
   knockdown.

9. **Strike force distribution.** The engine computes a `force` value per
   impact (0.0–1.0) but the test did not histogram it. The distribution of
   landing forces — how many are heavy vs light — is derivable from the log
   but was not measured here.

10. **Damage per strike.** Related to force but distinct: the actual
    body-condition wear per landed strike, which depends on the contact type,
    force, and region wear coefficients. Derivable from the log's `wear` field
    but not measured here.
