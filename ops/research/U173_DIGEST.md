# U173 digest — defender model slice 2 (anticipate + counter)

**Population:** U172 MMA grappler vs striker, boxing out-boxer vs pressure, plus boxing counter-puncher vs pressure (legal, non-identical). Switch: `defence_model` (default OFF).

## Built
- **Anticipate:** `_dm_opp_leads` ring buffer (class+role); after **5** trailing reps (S48), `preempt_chance` rises with fight IQ; pre-empt movement starts outside the reactive `last_throw` window; match → `preempt_defend`, mismatch → `preempt_wrong`, feint vs pre-empt → `preempt_feint_bite` (feint `feint` option unchanged when OFF).
- **Counter:** opening after evade or timed block; `boost_role_weights_for_counter` + `counter_contact_lift`; tallies `counter_thrown` / `counter_landed` / `counter_window`.

## Anchors (64 bouts/arm, model ON)
| Arm | def_rate | D1/min | preempt try/def/wrong/feint_bite | counter throw/land |
|-----|----------|--------|--------------------------------|-------------------|
| MMA | 0.474 | 6.88 | 5 / 1 / 0 / 0 | 11 / 7 |
| Boxing out vs press | 0.477 | 6.36 | 249 / 86 / 4 / 14 | 104 / 81 |
| Boxing ctr vs press | 0.477 | 6.52 | 299 / 108 / 7 / 13 | 90 / 74 |

Counters are a minority of sig landed (e.g. boxing ON ~81 land vs thousands of sig attempts). Counter-puncher ordering: test `ctr=641 press=66` landed counter roles over 64 bouts.

## Feint OFF
`s70_feint_off_hash.gd` md5 lines unchanged vs `origin/master` scripts (e.g. boxing 870500 `c819a94e7da6421f93d9d1f8fd638561`).

## Suite
`run_tests.py --only fight_defence_model,fight_realtime,feint,judge,fight_pace,fight_hit` → **7/8** (`fight_pace_anchor` D1 **5.79**/min, same pre-existing miss on master).

## Constants
All new `FightDefenceModel` constants tagged SOURCED (J50 §6 S48, §7, §8 S37, §5) or PROXY/AUTHORED in source.

## Trap
Pre-empt without feint bite would inflate defence; `preempt_feint_bite` is the honesty wire.
