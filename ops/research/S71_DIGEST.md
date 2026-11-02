# S71 DIGEST - THE GYM MARKET slice two; feint decay recovers; five deliveries merged (2026-09-25)

## Built: GYM MARKET slice two (`996e3c11`), G74 4.3 + J47 + G88 - live, no switch, every magnitude labelled
- RIVALS THAT INVEST: `Membership.rival_invest(rival, week)`, called weekly for the player's city by
  `GameState._advance_rival_investment` BEFORE billing, so a refit moves the same week's target. Clock = 260 weeks (J47 PROXY:
  IHRSA/HFA 2016 ~5-year refresh; combat interval NOT FOUND) x ambition scale (World Title 0.25 ... Gym Loyalty 1.0, INVENTED),
  staggered by id; gated on financial_strength >= 40. Buys the discipline's kit type (ring / cage / mat), then a strength block,
  then +6 facility_quality to 95. News line per refit.
- KIT TYPES: `kit_types_from_items` (club_ring -> ring, combat mat/tatami -> mat, compact_weights -> strength; the catalogue has
  NO cage item, so cage is rival-only) scored by type never count (ring 40, cage 40, mat 30, strength 20; INVENTED) at weight 0.5.
  Every type together (score clamps at 100, A 50) pulls less than one coach (A 120) - J47's judgement, no head-to-head survey exists.
- TITLE SPIKE: a home title-fight win (`_apply_fight_result`) stamps `membership.title_week`; A x (1 + 0.30 x 0.5^(w-1)) for
  4 weeks, a defence half. J47: size and decay NOT FOUND (existence SOURCED); G91's Wild Card +300 after Pacquiao-De La Hoya is
  the only hard figure, an upper bound. It passes through the normal weekly walk.
- CROWDING ON A SHARED SLOT (G88): members load the team only when it trains in their evening slot - `floor.team_slot`
  "evening"/"day" if set, else a one-coach gym shares. Peak fraction 0.15 -> G88's 0.20 mean.
- Tests: `gym_market_slice_two_test` 53/0 and EIGHT module mutants each caught (rival never invests 10 fails, spike 0 -> 5, slot
  always shared -> 1, "day" ignored -> 3, kit_type unsummed -> 3, market read drops spike -> 3, yield ignores slot -> 1, kit
  counted per item -> 1). C194's blind test pinned the old 0.15 twice; moved to 0.20 with a note. S69's crowding test now sets
  `team_slot = "evening"`. NOT driven: the 5-line title hook inside `_apply_fight_result` (needs a live title bout) - that is
  Codex C197's item 11.

## Engine: feint decay recovers (`48c4809b`) - the S70/C196 finding fixed
At C196's real rates the unanswered count only fell on a landed real shot; boxing reaction share was 0.106. Now one unanswered
feint is forgiven per `RECOVERY_S` = 4.0 s without a feint of that family (INVENTED). s70_feint_probe: boxing 0.258, MMA 0.369,
kickboxing 0.305 (G86 live 0.25-0.45); k=2 still halves (0.17 vs 0.36). 8.0 s left boxing at 0.171. fight_feint_test 48/0 with a
recovery-off mutant caught (3 fails); blind 62/0. feint-ON path only.

## Collected (each merged + its focused tier)
- C195 blind feint test (62/0) and C196 feint RATE (boxing 50x / KB+MT 15x / MMA 12x; 6.05 / 4.02 / 3.22 per man per min) -
  C196's own copy of the blind test DROPPED, C195's kept.
- U167 schedule truth, U168 profile pay/record/result digits, U169 weigh-in fine to opponent + gym-mate refusals. Focused 22/23;
  `weight_cut_test` 2 reds are S70's pre-existing pair (U169's digest said so; verified on the S70 suite list) -> Cursor U170.
- Q170 trap reach (round 2 `abce4c8f`): untrapped mount subs at x0.25 finish under `trap_arm`; OFF 9/9 hashes identical here
  before/after the merge. `judge_panel_test` T11 re-pinned to boxing_677 -> GREEN (one of S70's eleven gone). Finding, REPORTED
  not tuned: pop A (grappler 82 v striker 34) runs 1.65 / 1.15 / 1.05 attempts per fighter-fight in OFF / graph / trap - above
  J20's 0.5-1.0 in every arm incl. OFF. Grok G92 asks whether that pairing is really unreal.
- J47 THE TITLE BUMP (John, 41 KB): title spike size/decay NOT FOUND; kit-vs-coach head-to-head NOT FOUND; refit PROXY 5y/10y.
- G91 FROM FIGHTER TO COACH (Grok, verbatim): no population share who coach; pedigree weakly transfers (Roach, D'Amato, Boxing
  Social 12/20); 10% full-camp cut, 5% corner, flat fee on huge purses; FM + TEW are the templates. Feeds S72.
- J48 WHO BECOMES A COACH (John, landed during S71): heavyweight champs 29% pro trainer / 61% any coaching (n=31), UFC champs
  44% / 69% (n=32), journeymen 6% / 34% (n=32); lag median 0 yrs, MMA coaches mostly start while fighting. Feeds S72's two tiers.

## Suite
SUITE total=399 fails=10 (`--jobs 4`, after every S71 merge): athlete_development, capsule_coverage_contract,
fight_body_overlap, fight_metres (contention hang), fight_pace_anchor (Qwen Q171), fight_pair_live (PARKED), fight_scoring,
fight_stage_realism, fighter_reachability_contract, weight_cut (Cursor U170) - S70's eleven minus judge_panel (T11, fixed by Q170).
No new red; the new tests (gym_market_slice_two, the moved blind pins) green.

## Codex model (operator 2026-09-25)
Default is now `gpt-6-luna` (low or medium); `gpt-6-astra` medium for 3D animation only. The CLI had to go 0.154 -> 0.156.1
(`npm install -g @openai/codex@0.156.1`): 0.154 refused gpt-6-luna as "not supported with a ChatGPT account".

## Running at handover
Codex C197 blind market-two test (incl. a live title win), Cursor U170 market on screen + weight_cut reds, Qwen Q171 pace
anchor D1, Grok G92 sub attempts by style (https://grok.com/c/68654a01-8a66-46a1-90ee-252aa18d0bce). Kalli / Maria / Dola hold their standing tasks.
