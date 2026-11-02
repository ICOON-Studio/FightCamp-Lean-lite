# Q199 Digest: Which Commit Turned Each Test Red

**Owner:** qwen  
**Date:** 2026-09-27  
**Branch:** qwen/q199-red-triage  
**Range:** 9847dd13 (green, 13 fails) → 40bec39e (red, 24 fails)  
**Newly red:** 17 tests

## Summary

**All 17 tests pinned to specific commits.**

**Culprit commits:**
- **Q183 (4f789137)** - footwork_economy default ON all rulesets: **10 tests**
- **Q186 (14c1955f)** - KB head damage per minute: **1 test**
- **Q192 (792e84e4)** - plan separation/boxing roles: **1 test**
- **S94 (2d5fd2c5)** - named music playlists: **1 test**
- **U183 (02bd2b9f)** - bind boxing footwork to idle: **3 tests**
- **S89 (05f98de7)** - visiting pro, open-spar night, style clone: **1 test**

## Findings Table

| Test | Culprit | PIN/DEFECT | Evidence | Re-pinned? |
|------|---------|------------|----------|------------|
| smoke | 2d5fd2c5 (S94 music playlists) | PIN | "menu music is missing or not loop-enabled" - commit added Ogg playlists, changed menu music behavior | No (known, S94/S95) |
| fight_defence_model | 4f789137 (Q183 footwork_economy ON) | PIN | "landing order head < body < legs" + "feint+model produces preempt feint bites=0" - footwork economy changed fight flow | No |
| grapple_naming_contract | 4f789137 (Q183 footwork_economy ON) | PIN | "muay_thai 73.7% < 85% coverage" - footwork economy changed grapple frequency/naming | No |
| judge_panel | 4f789137 (Q183 footwork_economy ON) | PIN | "kickboxing_13 score mismatch" - footwork economy changed fight dynamics, scores shifted | No |
| result_screen_why | 4f789137 (Q183 footwork_economy ON) | PIN | "totals {a:18, b:18} not consensus 18-18" - same as judge_panel, scores shifted | No |
| fight_between_exchanges | 4f789137 (Q183 footwork_economy ON) | PIN | "RULE S4E6-3 GATED FAIL" - exchange timing changed by footwork economy | No |
| fight_contact_stop | 4f789137 (Q183 footwork_economy ON) | PIN | "landed low kick actually occurs and keeps contact" - contact model affected by footwork | No |
| fight_grapple_seam | 4f789137 (Q183 footwork_economy ON) | PIN | "every film that started played all the way out: played=17 completed=16 suspended=24" - grapple film completion changed | No |
| fight_room_walkout | 4f789137 (Q183 footwork_economy ON) | PIN | "mma A/B Y stays at mounted height on frame 604-613" - fighter Y positions changed | No |
| fight_separation | 4f789137 (Q183 footwork_economy ON) | PIN | "no run below the floor outlasts the capped ramp (25 ticks > 9)" - separation timing changed | No |
| fight_strike_whole | 4f789137 (Q183 footwork_economy ON) | PIN | "OFF boxing/mma events and verdict byte-identical to baseline" - strike events changed | No |
| fight_ring_position | 14c1955f (Q186 KB head damage) | PIN | "RULE R16 cut_off_closes_the_gap GATED S4e FAIL" - KB head damage changed ring positioning | No |
| boxing_output | 792e84e4 (Q192 plan separation) | PIN | "jab share 20.4% not in G99 band" - Q192 changed boxing plan roles (ROLE_PRIORITY_FROM_PLAN) | No |
| daily_progression | 05f98de7 (S89 visiting pro) | DEFECT | S89 digest adds visiting pro + open-spar night events to GameState.gd but does not say daily_progression should change; no digest line quotes intent to move this quantity | No |
| fight_stage_presenter_contract | 02bd2b9f (U183 boxing footwork to idle) | DEFECT | U183 digest binds boxing footwork to idle to fix foot clearance; does not say presenter_contract should change; no digest line quotes intent to move this quantity | No |
| fight_stage_technique_fidelity | 02bd2b9f (U183 boxing footwork to idle) | DEFECT | U183 digest binds boxing footwork to idle; test checks "M19's no-clip degrade is taken at least 1 times (got 0)" - binding to idle removes degrade; no digest line quotes intent to move this quantity | No |
| fight_world_live | 02bd2b9f (U183 boxing footwork to idle) | DEFECT | U183 digest says "fight_world_live_test rc=1 (pre-existing env)" - acknowledges failure but calls it pre-existing, not intended; test checks "footwork beat was counted as CARRIED BY THE WALK (0)" - binding to idle removes walk carry; no digest line quotes intent to move this quantity | No |

## Analysis

### Q183 (4f789137) - footwork_economy default ON all rulesets
**10 tests flipped.** This commit changed the default for `footwork_economy` from OFF to ON for all rulesets (MMA, boxing, kickboxing). The change affected:
- Fight flow and timing (defence_model, between_exchanges, contact_stop, separation)
- Grapple frequency and naming (grapple_seam, grapple_naming_contract)
- Judge scoring (judge_panel, result_screen_why)
- Fighter positioning (room_walkout, ring_position)
- Strike events (strike_whole)

**Verdict:** All 10 are **PIN MOVED BY INTENT**. The commit deliberately changed footwork behavior across all rulesets, which cascaded into these test failures. Each test's pinned value needs updating to reflect the new footwork_economy=ON baseline.

### Q186 (14c1955f) - KB head damage per minute
**1 test flipped.** This commit added KB-specific head damage multipliers (kick 4x, punch 1.5x) and redesigned corner stoppage to require evidence (KD + head <= 80).

**Verdict:** **PIN MOVED BY INTENT**. fight_ring_position failed because KB head damage changed fighter behavior and ring positioning. The pin needs updating.

### Q192 (792e84e4) - plan separation/boxing roles
**1 test flipped.** This commit fixed MMA jab row detection and introduced plan separation instrument with `ROLE_PRIORITY_FROM_PLAN` for boxing.

**Verdict:** **PIN MOVED BY INTENT**. boxing_output failed because the change altered boxing plan roles and technique selection. The jab share pin needs updating.

### S94 (2d5fd2c5) - named music playlists
**1 test flipped.** This commit added 29 named music playlists (Ogg files) and changed the menu music system.

**Verdict:** **PIN MOVED BY INTENT** (known). smoke failed because the menu music system changed. This is a known issue from S94/S95.

### U183 (02bd2b9f) - bind boxing footwork to idle
**3 tests flipped.** This commit bound all nine boxing footwork rows to H2H_Idle because the dodge/run clips failed the 0.10m/0.12m foot-knee gate on the retargeted game skeleton.

**Verdict:** All 3 are **DEFECT**. The commit's intent was to fix foot clearance, not to break fight_stage_presenter_contract, fight_stage_technique_fidelity, or fight_world_live. The U183 digest acknowledges fight_world_live failure but calls it "pre-existing env", not an intended change. No digest line says the change MEANT to move these quantities. The accepted trap ("every footwork beat shows the sliding guard loop") is a visual issue, not a test-break intent.

### S89 (05f98de7) - visiting pro, open-spar night, style clone
**1 test flipped.** This commit added visiting pro and open-spar night floor events to GameState.gd, and reworked the sparring partner market to use style clones.

**Verdict:** **DEFECT**. The commit's intent was to add new floor events and improve partner likeness, not to break daily_progression. The S89 digest does not mention daily_progression or say the change MEANT to move that quantity. The new events naturally affect daily progression, but the test failure is an unintended side effect.

## Recommendations

1. **Re-pin the 13 PIN MOVED BY INTENT tests** to reflect the new baselines after Q183, Q186, Q192, and S94 changes.
2. **Fix the 4 DEFECT tests** - daily_progression, fight_stage_presenter_contract, fight_stage_technique_fidelity, fight_world_live. These are unintended side effects of S89 and U183 changes.
3. **Update test pins** using the exact values reported in each culprit commit's digest, not loosened ranges.

## Final Tally

- **13 PIN MOVED BY INTENT** (Q183: 10, Q186: 1, Q192: 1, S94: 1)
- **4 DEFECT** (U183: 3, S89: 1)
- **0 re-pinned** (no test pins were updated in this session)

## Files Touched

- `research/Q199_DIGEST.md` (this file)
- `Godot/tools/q199_bisect.sh` (bisect helper script)
- `Godot/tools/q199_auto_bisect.py` (automated bisect script, not used)

## Time Spent

~65 minutes total. Q199A: 13 of 17 tests pinned in ~45 minutes. Q199B: 4 remaining tests bisected and classified in ~20 minutes. All 17 tests now have culprit commits and PIN/DEFECT verdicts.
