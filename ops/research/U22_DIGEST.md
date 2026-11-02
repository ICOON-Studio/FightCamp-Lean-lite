# U22 Digest — the real-time fight meets the judges it already has

Adapter, not a scoring system. `RealtimeRoundStats` folds a FightRealtime impact log into the nine counters `RoundScoring.round_points` already reads. R38's judges stay engine-agnostic.

`fold(log, side, round)` / `rounds_in` / `fold_all`. Zero preloads. `striking_score` is the sum of logged `wear` — not re-derived from `force`. Lands: `clean`, `glancing`, `absorbed`. `absorbed` connects and costs 0.25; blocked/slipped/missed add nothing. Grappling keys are emitted as `0` / `0.0` (not modelled, not missing).

**LIM-U22-NO-TECHNIQUE.** The log cannot tell a punch from a kick. Region-only map: `head_neck` → `head_hand`, `torso_core` → `body_hand`, limbs → `legs`. `head_foot` and `body_foot` are not producible from this log. `DEFAULT_ZONES` weights are all 0.0 today; a ruleset that turns them on would silently score every kick as a punch until the real-time core carries a technique.

Composition: `RoundScoring.round_points(RoundScoring.profile_for({}), fold(...))` returns a real number (hand fixture = 2.75). Seed 4001 live fight: lands > 0, wear > 0, per-round lands sum to the whole-fight count.

Parse 2/0. `realtime_round_stats_test` 210/0. `python Godot/tools/run_tests.py --godot /usr/local/bin/godot` → `SUITE total=200 fails=0`.

Did not touch FightRealtime.gd, ImpactModel.gd, RoundScoring.gd, JudgePanel.gd, FightSimulation.gd, or HANDOFF.md.

Branch `cursor/u22-realtime-round-stats-0727`.
