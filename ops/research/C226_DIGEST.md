# C226 ST1 — stamina choices and in-round recovery
Raw basis: D65 raw, decisions table and §§1–4 (not a peer-reviewed recovery curve for short pauses); S131 §8. Population: 20 legal paired boxing bouts, seeds 226100–226119, three distinct style/stat/plan matchups.
| Round | OFF thrown/man | ON thrown/man | OFF jab/power | ON jab/power | OFF hold | ON hold | OFF bell stamina | ON bell stamina |
| 1 | 44.17 | 44.20 | 34.80/65.20% | 35.18/64.82% | 19.73% | 46.65% | 94.24 | 99.27 |
| 2 | 41.38 | 39.60 | 36.56/63.44% | 36.49/63.51% | 23.65% | 45.95% | 91.12 | 98.94 |
| 3 | 35.83 | 34.88 | 38.31/61.69% | 37.56/62.44% | 23.05% | 50.59% | 80.87 | 97.74 |
Outcomes: OFF 4/20 KO+TKO and 16/20 decisions; ON 5/20 KO+TKO and 15/20 decisions. ON late power share falls 64.82%→62.44%; jab share rises 35.18%→37.56%, below G99’s 40–44%.
ON hold rises but 46.65–50.59% misses D65’s 75–85% low-intensity anchor; pooled thrown 39.56/man misses G99’s 45–56.
`FightStamina._IN_ROUND_RECOVERY_HALF_TIME_S = 22.0` — DERIVED, D65 raw §1 / Harris et al. 1992 fast PCr half-time.
`FightStamina._TIRED_JAB_USAGE_BONUS = 0.50` — AUTHORED from D65 raw §4, tired shot choice shifts toward jabs/singles.
`FightIntent` rest bias uses 14.0 fatigue scaling, 2.5 hold weight, 0.75 circle weight — AUTHORED from D65 raw §§2,4; census tuning.
Recovery runs only on active hold ticks outside the commitment window and is capped at the stamina recorded at that round’s start.
OFF does not add the switch key to state; the seed-226100 control tripwire compares default and explicit OFF event logs/results.
Gates: parse CHECK total=4 fails=0; `run_tests.py --jobs 2 --only fight_stamina,fatigue_curve,fight_intent,boxing_output,fight_pace_anchor,fight_realtime,fight_in_round_recovery`: SUITE total=7 fails=0.
Acceptance remains explicit: output and hold-share anchors are not met by this bounded change.

## ST1b (S134b, Claude in the cloud, finishing Codex's C226b)
- Codex's C226b stopped on a fixture question and never committed; the operator pushed its census from the PC (f5c8a57).
- Fixture answer: the ST1b brief was wrong. `fight_pace_anchor_test` is MMA (J20 combined per minute), not a boxing
  anchor; Codex's census swap put mma_* plans in a boxing ruleset (not legal). The boxing anchor is
  `boxing_output_test` (G99 45-56 wanted, engine ceiling ~35-40, test band 33-58). Census keeps C226's three legal
  boxing matchups; Codex's D65 low-intensity measure kept (hold OR retreat OR circle <= 0.25 m/s).
- ONE constant tuned: FightIntent rest-bias scale 14 -> 70 (AUTHORED). Sweep 14/28/42/56/70, 20 seeds x 3 rounds,
  same seeds OFF vs ON:

| arm | low-intensity R1/R2/R3 | thrown/man R1/R2/R3 | finish |
|---|---|---|---|
| OFF | 56.3 / 57.7 / 56.2 % | 44.2 / 41.4 / 35.8 | 4/20 |
| ON 14 (C226) | 68.4 / 66.2 / 69.9 % | 44.2 / 39.6 / 34.9 | 5/20 |
| ON 42 | 73.3 / 73.7 / 75.7 % | 44.5 / 40.6 / 38.2 | 3/20 |
| ON 56 | 74.3 / 77.9 / 76.5 % | 44.6 / 43.5 / 39.6 | 2/20 |
| ON 70 (shipped) | 76.7 / 77.3 / 77.5 % | 44.8 / 41.5 / 36.8 | 3/20 |

- Open: stamina at the bell stays 98-99 with ON (recovery nearly erases in-round fatigue); late-round power share
  barely falls (64.8 -> 62.4%, D65 secondary wants ~40 -> 25-30%). Not tuned here (two-constant limit; the half-time
  is DERIVED from Harris 1992).
