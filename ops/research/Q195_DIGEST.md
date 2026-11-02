# Q195 Digest - Who Moved the Pinned Bouts?

**Branch:** `qwen/q195-pin-drift`
**Model:** qwen3-coder, medium

## What Q195 found

**First bad commit: `4f789137` (Q183)** — footwork_economy default ON all rulesets.

Q183 flipped `FightRealtime.gd:959` from `bool(options.get("footwork_economy", false and _rs_id_q182 == "mma"))` to `bool(options.get("footwork_economy", true))`. This changed the default behavior for ALL rulesets — fighters now use footwork economy (less movement, more holding still) in every bout unless explicitly disabled.

## Bisect log

```
git bisect start
git bisect bad e6690fe8
git bisect good 9847dd13
# Steps: f312c42a BAD → bfe57c62 BAD → 2b0dac71 BAD → 822d97fe BAD → ed8aa786 GOOD → 5558cc0d BAD → 4f789137 BAD
# First bad: 4f789137 (Q183)
```

7 steps, probe = `judge_panel_test.gd` exit code.

## Verdict per test

### judge_panel_test.gd — INTENDED drift, RE-PINNED

Q183's footwork_economy flip changes how fighters move standing, which changes the RNG draw order and every seeded bout's trajectory. This is the intended effect of the change — the census showed it improves m/min for all three rulesets.

**T4/T8R:** All 12 failing bouts re-pinned from the test's own printed actual. The T4/T8R reproducibility check (runs each bout twice, compares) confirms the new values are stable.

Bouts that moved:
- boxing_11: unanimous → unanimous_draw (round 4 flipped)
- boxing_7: KO/5 → DECISION/unanimous/8 (fight went the distance)
- boxing_9: DECISION/unanimous/8 → TKO/5 (fight now stops earlier)
- boxing_20: DECISION/unanimous/8 → KO/5 (fight now stops earlier)
- mma_11: round 3 score 8-10 → 9-10
- mma_5: KO/2 → DECISION/unanimous/3 (fight went the distance)
- kickboxing_13: DECISION/unanimous/3 → TKO/2
- kickboxing_14: DECISION/unanimous/3 → KO/1 (now a round-1 KO)
- kickboxing_186: KO/1 → TKO/2 (now goes to round 2)
- boxing_300: KO/3 → DECISION/unanimous/8 (fight went the full distance)
- kickboxing_19: round 1 score 10-9 → 10-8
- muay_thai_17: rounds 1,2,5 flipped

**T11:** kickboxing seed 40 no longer a SPLIT, boxing seed 677 no longer a MAJORITY. Sweep running (stride-5 over 1..2000 on the 62-v-64 fixture). New seeds will be found and the test updated. The test has a long history of re-finding these seeds when the engine moves — this is the 20th+ re-find.

### grapple_adapter_test.gd — INTENDED drift, RE-PINNED

Same cause: Q183's footwork_economy flip changes the standing exchanges that feed into the muay thai adapter's striking scores. The MT witness seed 93003's six per-round striking values all moved, and the card moved from 29-26 to 30-25. Both re-pinned from the test's own printed actual.

### fight_realtime_test.gd — SIDE EFFECT, needs separate investigation

6 failures in R91 (submission rate), R92 (judo throw scoring), R93 (judo ippon seeds):
- R91: 0 submissions in 40 boxer-v-wrestler bouts (was > 0)
- R92: 0 judo throw-point rounds in 24 bouts (was > 0)
- R93: seed 94018 moved from ippon to hansoku_make_shido (2/3 ippon seeds survive)

These are NOT from Q188 (spar intensity, defaults to "" = bout, byte-identical) or Q189 (sharp_edge, defaults to 0.0, byte-identical). Both modes are properly scoped.

The R91/R92 zeros are suspicious — footwork_economy reduces movement but should not eliminate all submissions or judo throws. The R92 judo adapter processes rounds (mma_control=89, bjj_paid=59) but judo-specific throw scoring is zero. This may be a separate issue with how the judo adapter classifies throws under the new movement patterns, not just a pin drift.

**Recommendation:** investigate R91/R92/R93 as a separate task. The fight_realtime_test also has a pre-existing parse error (`FightMoves` not declared at line 478) that prevents it from loading in worktrees without a populated `.godot` cache — this is a Godot class_name resolution issue, not a code defect.

## Files changed

- `Godot/tests/judge_panel_test.gd` — T4/T8R re-pin (12 bouts), T11 re-find pending
- `Godot/tests/grapple_adapter_test.gd` — MT striking values + card totals re-pin
- `Godot/tools/q195_find_t11_seeds.gd` — new sweep tool for T11
- `research/Q195_DIGEST.md` — this file

## Population

The pinned bouts use these fighters and rulesets:
- **judge_panel_test T4/T8R:** `_realtime_fighter` with ratings from the `specs` dict (ta/tb = 55-70), rulesets = boxing/mma/kickboxing/muay_thai from `combat_rulesets.json`
- **judge_panel_test T11:** `_realtime_fighter` ta=62 tb=64, boxing and kickboxing
- **grapple_adapter_test:** `_grappler()` vs `_fish()` on muay_thai, seed 93003
- **fight_realtime_test R91:** boxer vs wrestler, 40 default seeds, 3x5 rounds
- **fight_realtime_test R92:** grappler vs fish, 24 bouts, judo ruleset
- **fight_realtime_test R93:** grappler vs fish, seeds 94017/94018/94039, judo ruleset

Co-Authored-By: Qwen Code <noreply@qwen.ai>
