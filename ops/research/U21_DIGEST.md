# U21 Digest — BroadcastRead stops assuming fourteen seconds

Per-minute figures are `count / fight_seconds * 60`. Fight-seconds are the sum of per-event `span` on measured (burst) actions. Field is `BroadcastRead.SPAN_KEY` (`"span"`); R82 will write it. Absent span falls back to `EXCHANGE_SECONDS` (14.0), so today's atomic engine is unchanged.

**Gate:** a log with no span field is byte-identical to U19's fixture string. Written in the test before the module changed. `span=14` on every event matches that string; `span=7` moves the rates (`16/21*60` → 45.7) and leaves connect / time-at-band / range owned as event share.

**C63:** `ImpactModel.gd` was not on master. `_per_minute` is inlined exactly as TASK_C63 specifies (`0.0` when `fight_seconds <= 0.0`). Claude reconciles to `ImpactModel.per_minute` when C63 lands. No preload.

Parse 2/0. broadcast_read_test 88/0 (was 75). `python Godot/tools/run_tests.py --godot /usr/local/bin/godot` → `SUITE total=195 fails=0`.

Did not touch FightSimulation.gd, ImpactModel.gd, RingSpace.gd, or HANDOFF.md.

Branch `cursor/u21-broadcast-read-span-d1bc`.
