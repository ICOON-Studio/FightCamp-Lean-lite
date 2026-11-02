# TASK AWAYCIRCUIT1 - paid away fights for boxers whose country has no promoter (Arena)

Model: any. Seat: Arena (cloud). Tier: a new pure module + its new test.
Operator approved S231 (board Q-S225-12 "Yes, build it"); verdict: research/VERDICT_AWAYCIRCUIT_S231.md;
design + reference code: research/LUDO_ROUND91_REPLY_S230.txt (Ludo round 91, PART 1-3).

## What to build
1. `Godot/scripts/rules/AwayCircuit.gd` - `extends RefCounted`, static functions only, NO preloads of autoloads,
   NO randomness of its own (all randomness comes in as the `rolls` array). Start from Ludo's PART 2 code and keep its
   contract: `static func offers(ctx: Dictionary, rolls: Array) -> Array`, with
   ctx = {home_market, has_home_promoter, fighter {record_w, record_l, weight_class, ranking_points}, neighbours
   {market: [promoter display names]}, week}. Each offer = {market, promoter, weeks_out (3-6), travel_days (1-3),
   purse_band ("debut" | "prospect" | "contender"), rounds (4 | 6 | 10), away: true, line}.
   Fix while porting: (a) the band rule must be total and ordered - contender (wins >= 8 or ranking_points >= 100)
   is checked BEFORE prospect; (b) a duplicate promoter pick must not silently drop an offer when another promoter is
   free - take the next free pool entry; (c) store `rounds` as an int on the offer.
2. `static func away_judging_lean(close_round: bool, away: bool) -> float` - returns the home fighter's extra share of
   a CLOSE round's scoring when the visitor is away (0.0 when not away or the round is not close). Bounded, small:
   0.10. Clear rounds and stoppages are never touched (that is the caller's rule; document it).
3. `Godot/tests/away_circuit_test.gd` (extends SceneTree, prints `OK:`/`FAIL:` lines, quits with 1 on any FAIL):
   - control: has_home_promoter = true -> [] for every roll set (the control arm that cannot share a bug);
   - empty neighbours -> [];
   - count thresholds (<0.20 -> 0, <0.60 -> 1, <0.85 -> 2, else 3) on a pool of >= 3 promoters;
   - weeks_out always 3..6, travel_days always 1..3 across 200 deterministic roll sets;
   - bands: 0-0 -> debut/4, 3-0 -> prospect/6, 9-1 -> contender/10, 2-0 with 120 points -> contender;
   - no promoter appears twice in one call; a duplicate pick still yields the requested count when the pool allows;
   - determinism: the same ctx + rolls give byte-identical JSON twice;
   - the line names the promoter, the market, the rounds and the travel days;
   - away_judging_lean: 0.0 for (false, true), (true, false); 0.10 for (true, true).
   Use REAL promoter names only in fixtures (Matchroom Boxing, Queensberry Promotions, BOXXER - United Kingdom;
   Top Rank - United States of America). Never invent a promoter (Ludo's fixture "Spartan Ring Promotions" is banned).

## Acceptance
`godot --headless --path Godot --script tests/away_circuit_test.gd` -> 0 FAIL lines, exit 0. Only the two new files.
Never delete or weaken another test. Prove the test can read worse: temporarily break the control (return offers even
with a home promoter) and confirm the control check FAILs - say so in the PR body, then restore.

## Prior research
VERDICT_AWAYCIRCUIT_S231.md, LUDO_ROUND91_REPLY_S230.txt, real_organizations.json catalog v4 (e190dd3b).

## What would a human do?
Port the designer's pure function, fix its edge cases, pin it with a table-driven test.

## Prefab check
None - game rules.

## Trap
Typed GDScript: no `:=` on Variant returns (Dictionary.get) - declare the type. Headless runs keep switches OFF.
