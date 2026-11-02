# R80 digest — The burst under the named technique, and the stance that matters

- **The burst is on every action event and it is a contract.** Each
  `type == "action"` event now carries `event["burst"] = {thrown: int, landed:
  int, jab_share: float, defense_used: int, steps: int}` — the five names U19
  is being written against without seeing this code. Chain events carry no
  burst of their own (they are not actions), but **every action nested in a
  chain's `links`** does, which is where a combination's volume actually
  lives. `event["reaction_event"]` is the same Dictionary as one of those
  links, so it is stamped by the same walk.
- **The hard gate holds: the burst cannot move a fight.** It is drawn from
  `_burst_rng`, its own generator seeded `seed + BURST_SEED_OFFSET`, exactly
  the way R38 gave the judge panel one — pulling even a single number out of
  `_rng` would move the outcome of every seeded fight in the game. It is also
  written *after* `_resolve_exchange` has already decided the outcome, and it
  is never read back. `_test_burst_never_moves_the_fight` proves it on four
  seeds: `run_to_completion(..., {"seed": N})` and the same seed with
  `{"burst": false}` produce an identical exchange-by-exchange signature
  (type, actor, outcome, landed, damage to six decimals) and an identical
  winner and method. `options.burst = false` is the suppression switch that
  test flips; nothing else uses it.
- **Magnitudes land on U18 D1, and the band is what moves them.** Measured
  over 50 boxing fights (n=4,662 action events, all of them fought at POCKET):
  `thrown=6.50 landed=1.83 defense_used=0.99 steps=9.03`. The baselines are
  the per-exchange division of Davis 2015 — 4.7 thrown, 0.6 defensive acts,
  11 footwork atoms per 14 fight-seconds — and POCKET multiplies volume 1.35×
  while cutting footwork to 0.8×, so 6.5 in the pocket is 4.9 at MID. Drive
  comes off the actor's `conditioning` and `speed` plus the gas he has left;
  the defensive count comes off the target's `defense` and `speed` and can
  never exceed `thrown`. **No eighth attribute** — U18 refused one and none
  was added.
- **Stance is now read by the fight.** `event["stance_matchup"]` is `"closed"`
  (same stance) or `"open"` (orthodox vs southpaw), settled once at the bell
  because it is a property of the pairing, and stamped on action *and* chain
  events. `_build_fighter_state` carries `stance` in from the athlete for the
  first time, defaulting to `ORTHODOX` the way `TaleOfTape.gd:204` already
  does, so a bare fixture is a closed matchup rather than a silent third
  state.
- **U18 D3 applied as a weighting, not a damage multiplier.** In
  `_weighted_choice` a `stance_fit` factor sits beside `range_fit`: an OPEN
  matchup frees the rear hand and the body kick to the open side (×1.08) and
  makes the jab a cross-body reach (×0.94). Hand/kick families are matched on
  id/name the way `KICK_MARKERS` already is, because the catalog carries no
  per-move hand tag. Measured effect on the share: closed `jab_share=0.468`,
  open `0.306`. **No switch-hitting third stance and no guard height** — both
  are out of scope per U18.
- **The whole stance delta is expressed on the OPEN side, deliberately.** The
  first cut also weighted the closed matchup (jab ×1.08, body kick ×0.94) and
  `judge_panel_test.gd` caught it: `PRE_R38_CARDS` pins ten seeded bouts
  card-for-card, and `boxing_11` went from a two-round to a three-round fight.
  Closed is the posture every fixture and every tuning baseline in this engine
  already assumes — both men leading with the same foot — so it is the 1.0,
  and open is the deviation. U18 D3's effect stays exactly as relative as U18
  wrote it, nobody's pinned snapshot moves, and closed's own half of the
  ruling (jab-and-step) lives in the burst's jab share, which is where U18 put
  it. This is also the closer reading of the brief: its open bullet names a
  mechanical edge, its closed bullet names only a `jab_share` change.
- **A paused chain gets nothing.** The stamp sits below `advance_exchange`'s
  paused early-return, so a chain still waiting on the defending corner
  carries neither a burst nor a matchup, on the event or on any link it has
  thrown so far; both appear on the resumed event once it resolves.
  `_test_paused_chain_event_carries_no_burst` drives the real pause through
  `force_chain` (a 90-tactical coached corner reading `boxing_liver_combo` at
  link 1), then resumes it and checks every action link is stamped.
- Owned files: `Godot/scripts/FightSimulation.gd` (2,954 → 3,197 lines),
  `Godot/tests/fight_simulation_test.gd` (734 → 954, four new tests: 235 → 252
  checks), this digest, and the R80 block in `HANDOFF.md`. `:231`
  (`ANIMATION_FAMILY_BY_ROLE`, C59's) was not touched, nor were
  `RingStagePanel.gd` or `AthleteDevelopment.gd`.
- **Follow-up, named and stopped at:** the camp's own jab share. The burst's
  `jab_share` is driven by stance, band and the technique thrown — it does not
  read `technique_progress` (`AthleteDevelopment.gd:83`), so a fighter who
  drilled the jab all camp throws the same share as one who did not. That is
  the next slice, not this one.
- Verify: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot
  --script tests/fight_simulation_test.gd` → `252 checks, 0 failures`.
