# S73 DIGEST - gym heat, a gate that reads hype, and "what would a human do?" (2026-09-25)

## Shipped (master)
- **GYM HEAT** `e70fc2bc` - `Godot/scripts/GymHeat.gd` (pure): a gym-pair war 0-100 on career["gym_heat"], stoked by
  booking a rival gym's fighter (+6), a poach (+20), a result between the gyms (+10 decision / +7 finish), cooling 1 a
  week. It reaches bout HYPE (`PressConferences.base_hype`, gym_heat_scale 0.3) and a purse premium (0.15%/heat) -
  **never the sim** (G89 5.1c: pair heat already drives aggression). Read: `GameState.get_gym_rivalries()`.
- **A GATE THAT READS HYPE** - `FightContract.gate_for` = house x attendance fill x ticket price, from the bout's hype
  plus a hometown draw. No-comments are resolved BEFORE the gate is read, so a dead presser leaves seats empty. The
  fight log carries `gate`, `attendance_fill`, `gym_heat`, `gym_heat_bonus`, `rival_gym`; the settlement ledger prints
  "GATE $X · N% FULL".
- **G94 recalibrated it** `198a965c`: fill floor 0.35 INVENTED -> **0.60** (NSAC: UFC 116 61.7%, UFC 222 60.2%);
  price is the main lever (UFC 229 vs 226: 1.14x heads, 2.65x ticket) so a full draw fetches 3x. Hometown +15 INVENTED.
- `tests/gym_heat_test.gd`: two rival gyms, two DIFFERENT opponents (named in its POPULATION line); **15 mutants, all
  caught** (the two first survivors - POACH and a finish counting as a decision - were tautologies; fixed).
- **Q171 merged at the DERIVED 0.311**, not Qwen's tuned 0.40 - D1 5.79/min, split 76.7/5.3/18.0; the gap is clinch
  volume -> Q172.
- **G93**: coach cut cap 50k INVENTED -> 800k DERIVED (10% of Roach's $8M). Retention NOT FOUND.
- **U171 pass 1 merged, verified with a control** on master: att_lhand 15%->0%, vic_rhand 13%->2%; worst contact on
  mma_dirty_boxing is now head_to_head 8%. Its before/after MP4s were BYTE-IDENTICAL (filmed audition GLBs) and its
  20/20 "parse error" was a missing import cache - both written into pass 2.
- **C199 passes 1+2 merged** (research only): lifting did not work yet (next: mutually exclusive C180 masks); hand-keyed guard in the live Blender plays
  in Godot but Claude's read is **not yet a closed guard** (far leg straight out, loop barely moves). Sent to operator.
- **J49** (John): how the industry joins mechanics, animation and UI - 55 sources, gates G1-G17. Sent to operator.

## Operator rulings this session (verbatim)
- "in all researches i want this questioned and answered : what a human would do ?" -> CLAUDE.md + a RESEARCH DEFECT
  check in `agent_comms.py start` (`missing_human_question()`), section in every open brief.
- "full access to all researches for everyone" -> agents read `RESEARCH_INDEX.md` and any study; logs stay closed.
- "why you do not copy the whole technique that the real animators do" -> C199 pass 3 is the six-row studio chain
  (calibrate, calibrated views, joint markers, SMPL-X two-person solve, cleanup, retarget) + a REAL-footage control arm
  ("we also have the youtube footage"); "make it from start right".
- Subscriptions: keep both; Higgsfield checkpoint = the free row-2 view-agreement test, cancel before ~14 Oct if it fails.

## Suite
`SUITE total=403 fails=13` raw (`--jobs 4`); four were S73's new purse term in old exact-value checks (fight_contract,
promotion_matchmaking, tournaments, watched_status) - fixed and green one by one. **Real state: 9, the same nine S72
named** (athlete_development, capsule_coverage_contract, fight_body_overlap, fight_metres = contention hang,
fight_pace_anchor = Q172, fight_pair_live PARKED, fight_scoring, fight_stage_realism, fighter_reachability_contract).
After G94's recalibration the 11 gate-touching tests re-ran 11/0.

## In flight at handover
Qwen Q172 clinch volume (worktree Temp/FightCamp-Q164). Codex C199 pass 3 (astra, live Blender) and C198 pass 2.
Cursor U171 pass 2. Grok G94 follow-up (promoter levers: comps, scaling the house, pricing, club shows).

Test: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/gym_heat_test.gd`
