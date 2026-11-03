# TASK KALLINUMS1 - QWEN - Kalli's numbers for own combinations + the graded card's "more combos in round 3" (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean. Launched unattended by
ops/Tools/seat_dispatch.py: your worktree E:\FightCamp\wt\LEAN_KALLINUMS1, branch qwen/kallinums1. Commit there; do
not push (the dispatcher pushes and opens the PR).

## Why
Kalli (our numbers seat) reviewed two S373-S375 mechanics (answers in gbot thread Kalli, K_GRADED2 + K_COMBOPLAN1):
1. A boxer's OWN combinations (scripts/rules/OwnCombos.gd): worth in an even exchange = drilled 3 (PlanFight.EDGE "ok")
   + FLOW_EDGE 2 when it flows + SIG_EDGE 5 as a signature; it decides USE_SHARE 0.33 of a round's exchanges.
   Kalli: keep +5; CAP the combination's part at 10 an exchange; a 4+ punch signature is the GAMBLE - it lands whole
   less often (58 % vs 64 % for a 2-3 punch signature) but counts +1 more when it does; the share drops to 0.25 once
   energy is under 40, rises to 0.40 when the fight plan names the combination, never above 0.40.
2. Graded punches (scripts/rules/SkillAwards.gd ECONOMY, 8 % a grade, Gold 12 %) save ~3.6 tank points by round 3 -
   "a 3-point gap on a 100 tank reads as nothing". Show it as COMBINATIONS: "about 4 more combos in round 3"
   (the saving / 0.9, the gas of a 3-punch chain).

## The job
1. `scripts/rules/OwnCombos.gd`
   - `const COMBO_CAP := 10.0` - `worth(f, e)` returns `minf(w, COMBO_CAP)`.
   - `const LONG_AT := 4` (punches) and `const LONG_EXTRA := 1.0`; `static func long_signature(f, e) -> bool` =
     signature(f, e) and punches(e.chain).size() >= LONG_AT.
   - `lands_whole(f, e)`: for a long signature use `ComboOdds.win_odds(LONG_ODDS_WORTH)` with
     `const LONG_ODDS_WORTH := 5.5` (win_odds(10) = 0.640, win_odds(5.5) = 0.580 - check both in the test).
   - Shares: `const TIRED_SHARE := 0.25`, `const TIRED_AT := 40.0`, `const NAMED_SHARE := 0.40` (the most it ever is).
     `static func use_share(energy: float, named: bool = false) -> float` = NAMED_SHARE if named, else TIRED_SHARE when
     energy < TIRED_AT, else USE_SHARE.
   - `ring_edge(f, energy, named := false)`: per usable combination, edge = (worth - EDGE ok) ; for a long signature
     edge = (worth - EDGE ok + LONG_EXTRA) * lands_whole(long) / ComboOdds.win_odds(COMBO_CAP) (the gamble: +1 when it
     lands, landing less); best of them x use_share(energy, named). It REPLACES the Combos.energy_scale factor (the
     tired share is Kalli's tiredness). The one caller (scripts/state/BoutNight.gd:291) passes no `named` - leave it.
   - Update the header comment block's lines for these numbers ("Kalli K_COMBOPLAN1, S376").
2. `scripts/rules/SkillAwards.gd`: `static func extra_combos_r3(f: Dictionary) -> int` - run three rounds with
   `Combos.after_round(energy, debt, Combos.round_spend(f.get("combos", {}), "", cond, econ), cond)` twice (econ =
   `bout_economy(f, RoundStyle.SHARE)` and econ = 1.0; cond = f.stats.conditioning, default 55; start energy Combos.TANK,
   debt 0, carry `next` / `debt` like OwnCombos.whole_by_round does), take the round-3 `bell` difference, return
   `roundi(diff / 0.9)` (`const CHAIN3_GAS := 0.9`). 0 for an ungraded boxer.
3. `scripts/ui/ComboStrip.gd` (~line 89-94, the "Graded" chip): on the FIRST graded card of a strip only, add a TINY
   gold label named "GradedCombos": "+%d combos by round 3" with extra_combos_r3(f) (skip it when that is 0). Keep the chip
   and its tooltip; add to the tooltip "- about N more three-punch combinations left in round 3 than ungraded".
4. Tests (extend, keep every existing check passing):
   - `tests/combo_plan_test.gd`: worth never above 10; a 4-punch signature lands whole 0.58 +- 0.01 and a 3-punch
     signature 0.64 +- 0.01; use_share(100) == 0.33, use_share(35) == 0.25, use_share(100, true) == 0.40;
     ring_edge(f, 35) < ring_edge(f, 100).
   - `tests/skill_awards_test.gd`: extra_combos_r3 of an ungraded boxer == 0; of a fully graded (Gold) boxer at
     conditioning 50 between 2 and 6; the strip of a graded boxer has exactly one node named "GradedCombos".

## Acceptance (the dispatcher runs these on your branch, headless)
- `tests/combo_plan_test.gd` and `tests/skill_awards_test.gd` pass with failures=0, exit 0, no SCRIPT ERROR.
- `golden_path_test` and `no_pronoun_test` still pass.
- No pronouns in UI text (no_pronoun_test fails on she/her/he/his in labels).
- Your tools cannot open the game: use only GDScript 4 methods that exist on that exact type, and check each call's
  argument count against the function you call. No script over 500 lines.

## Contract
OWNS: scripts/rules/OwnCombos.gd, scripts/rules/SkillAwards.gd, scripts/ui/ComboStrip.gd, tests/combo_plan_test.gd, tests/skill_awards_test.gd
RED_TEST: tests/combo_plan_test.gd -> COMBO_PLAN failures=0
REGRESSION: skill_awards_test, golden_path_test, no_pronoun_test
VISUAL: no

## Prior research
Kalli's answers (summarised above); OwnCombos.gd header (S375 COMBOPLAN1); SkillAwards.gd S373 block (ECONOMY,
bout_economy); Combos.gd after_round / round_spend; ComboOdds.win_odds.

## What would a human do?
Read OwnCombos.worth / ring_edge / lands_whole and SkillAwards.bout_economy, change the numbers, add the two small
functions, put one label on the strip, extend the two tests.
