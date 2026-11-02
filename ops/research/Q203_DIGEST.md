# Q203 DIGEST — Three realism reds that are not pins

## Red 1: boxing_output_test — jab share 20.4% → 37.6% (PASS)
**Culprit:** Q192/Q194 plan separation (ROLE_PRIORITY_RULESETS=["boxing"])
**Root cause:** The two-stage ROLE_PRIORITY selection picks the role first by role_weights, then technique within the role. The jab (role="setup") was starved because setup is SECONDARY (weight 1.0) vs damage PRIMARY (weight 3.0) in the pressure plan, so setup was picked only ~22% of the time. The jab_usage_mult=4.0 only applied within stage 2, not to the role selection in stage 1.
**Fix:** FightMoves.gd stage 1 — when `jab_usage_mult` is active (boxing_output ON), boost the role weight by jab_usage_mult if the role contains jab techniques. This restores the jab's effective weight that the single-stage path had implicitly.
**Before:** jab share 20.4% (band 35-52 with tolerance)
**After:** jab share 37.6% (IN band)
**Trap honoured:** Plan separation preserved (6/6 distinct plans unchanged). The jab boost only fires when boxing_output is ON.

## Red 2: fight_ring_position_test — R16 cut_off_closes_the_gap — ALREADY GREEN
**Status:** PASS on this branch. Q202 (wall-aware separation push) fixed it.
**Measured:** ring -0.084 → -0.152 m/s (n=6117/5819); cage -0.047 → -0.061 m/s (n=11001/6650)

## Red 3: fight_defence_model_test — landing order head < body < legs — 0.485/0.518/0.519 (PASS)
**Culprit:** Pre-Q183 (found in Q199/Q201 investigation). The defence model's timing thresholds and read bonus conspired to flatten the landing-order gradient.
**Root cause (three compounding effects):**
1. **Head read bonus (+0.18 in choose_block_height):** Only head got the bonus, making wrong-height rare for head (23%) but not legs (41%). This counteracted the timing differentiation.
2. **Timing thresholds (head 0.80, body 0.62, legs 0.32):** Made blocks fail MORE on legs and LESS on head — backwards. Legs are the least-defended target.
3. **Zone-dependent read quality:** Head attacks (mostly jabs, tell ~405ms) produce READ_LATE nearly every time (spare time 125ms < EARLY threshold 120ms), making blocks fail 80% of the time. Leg attacks (kicks, tell ~560ms) produce READ_NORMAL, making blocks succeed.
**Fix (FightDefenceModel.gd, three changes):**
1. Uniform read bonus: +0.18 applied to ALL heights (not just head), equalizing wrong_height rates.
2. Zone-dependent tell adjustment: head +120ms (defenders drill head defence, read it faster), legs -60ms (low targets harder to pick up). This equalizes the READ_LATE rate across heights.
3. Timing thresholds swapped: head 0.70 (blocks succeed more), body 0.55, legs 0.40 (blocks fail more).
**Before:** head=0.530, body=0.535, legs=0.526 (FAIL — flat, no ordering)
**After:** head=0.485, body=0.518, legs=0.519 (PASS — head < body < legs)
**Defence rate:** 0.469 → 0.498 (IN 0.45-0.65 band)
**D1:** 6.88 → 6.47 (IN 6.0-8.0 band)

## Pre-existing failure (not mine)
- feint+model produces preempt feint bites: bites=0. Task says this is Cursor's U191.

## Gate
- boxing_output_test: 17/17 PASS
- fight_ring_position_test: 3/3 PASS
- fight_defence_model_test: 22/23 PASS (1 failure is U191's feint bites)
- fight_plans_test: 0 failures
- fight_realtime_test: exit 0 (no failures)
- Parse gate: 0 fails on both modified scripts

## Files changed
- Godot/scripts/FightMoves.gd (jab role boost in stage 1)
- Godot/scripts/FightDefenceModel.gd (uniform read bonus, zone tell adjustment, timing thresholds)
