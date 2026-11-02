# TASK AWAYCIRCUIT2 - a Cyprus pro boxer gets paid away offers on the offer board (Arena)

Model: any. Seat: Arena (cloud). Tier: a script edited -> parse + the new test + the listed --only set.
Operator approved the away circuit (board Q-S225-12 "Yes, build it"). The pure rules module is merged:
`Godot/scripts/rules/AwayCircuit.gd` (offers(ctx, rolls), away_judging_lean) + `Godot/tests/away_circuit_test.gd`.
Verdict: `research/VERDICT_AWAYCIRCUIT_S231.md`.

## The route the GAME runs (traced, not guessed)
The offer board reads `GameState.get_fight_offers()` - `Godot/scripts/GameState.gd` line ~8839 (the file is ~21,000
lines: NEVER read it whole; `grep -n "func get_fight_offers"` and read lines 8839-8990). It builds one generated offer
per tier per weight class on the roster (seeded `fight_offer|gym|tier|class|week`), then the women's board, rivalries.
Each offer dict: id, tier_id, label, opponent_name, opponent_rating, opponent_record, weight_class, purse, win_bonus,
reputation_reward, fame_required, channel.

## What to build
1. `Godot/assets/data/away_circuit.json`: `{"version": 1, "neighbours": {"Cyprus": {"United Kingdom": ["Matchroom Boxing",
   "Queensberry Promotions", "BOXXER"]}}}` - ONLY this row (the other promoter-less markets get a neighbour when a
   second source confirms one; never invent).
2. In `get_fight_offers()`, AFTER the existing men's and women's loops and BEFORE rivalries: for each boxer on the
   roster (primary discipline boxing) whose home market (`career` country / `selected_country`) has NO promotion that
   runs boxing in `real_organizations.json` `market_assignments` (an organization with `entity_type == "promotion"`
   and "boxing" in `disciplines`), call `AwayCircuit.offers(ctx, rolls)` with ctx from that boxer (record_w/record_l
   from his record, ranking_points, weight_class), neighbours from away_circuit.json, and rolls from a
   RandomNumberGenerator seeded `"away_offer|%s|%s|%d" % [selected_gym, athlete_id, career_week]` (8 rolls). Map each
   away offer onto the existing offer dict shape: id `away_<promoter slug>_<athlete_id>_<week>`, tier_id "away",
   label = the offer's `line`, opponent_name drawn from the same name lists as the tier offers (own-name collision
   rule kept), purse/win_bonus from the existing tier table by band (debut -> the lowest pro tier, prospect -> the
   next, contender -> the next; read `_offer_tiers_for_class` to find them), plus fields `away: true`,
   `travel_days`, `weeks_out`, `rounds`, `promoter`, `market`, `athlete_id`. A UK/USA boxer gets NO away offer
   (control). Existing offers must stay byte-identical (no shared RNG draw).
3. New test `Godot/tests/away_offer_board_test.gd` (extends SceneTree; walk the real GameState like
   `Godot/tests/offer_desk_test.gd` does for Cyprus): a Cyprus career with a pro boxer -> >= 1 offer with away=true
   whose promoter is one of the three UK names and whose line names it; a United Kingdom career -> 0 away offers;
   the non-away offers of the Cyprus board are identical with and without the feature (compare ids+opponent names
   against a run with away_circuit.json neighbours emptied). Prints OK:/FAIL:, quits 1 on any FAIL. It must be RED on
   master (no away offers exist) - say so in the PR body.

## Acceptance
`godot --headless --path Godot --script tests/away_offer_board_test.gd` 0 FAIL; and these stay as they are on master
(do not make any of them worse): offer_desk_test, short_notice_test, offer_card_test, offer_opponent_words_test,
organization_fight_offer_test, real_organizations_test. Only GameState.gd (the one block), the new json and the new
test change. Never delete or weaken a test.

## Prior research
VERDICT_AWAYCIRCUIT_S231.md, LUDO_ROUND91_REPLY_S230.txt (PART 4 hook), PROMOTERS1B_JOHN_S231.txt, catalog v4 e190dd3b.

## What would a human do?
Add one block at the end of the offer builder, seeded on its own stream, gated by "no home promoter".

## Prefab check
None - game rules.

## Trap
GameState.gd typed GDScript: no `:=` on Variant (Dictionary.get) returns. Plain --script runs keep GAME switches OFF:
the away offers are not behind a switch (operator ruling: new features ship ON), so the test needs no as_game.
