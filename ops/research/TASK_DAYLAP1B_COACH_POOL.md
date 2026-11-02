# TASK DAYLAP1B - the coach pool and station buff (pure module + data + test)

Model: medium. Seat: Antigravity (`agy`, free tier, PC) or Arena (own branch `arena/<chat-id>-fightcamp`, PR into master, never merge).
Tier: new pure module + new data file + new test -> parse gate + that test. Do NOT edit DayLap.gd, GameState.gd or any scene.

Operator (S172, verbatim): "the coach can buff the station when he is present with the fighter [...] the coach has a pool that
drains between training sessions [...] player needs to keep balance during a week so that he will not drain the coach and not tire or
injure the fighter". Design of record: `research/DAYLAP1_DESIGN.md` (section "S172 OPERATOR - stations, coach pool").

## Prior research
`python Tools/prior_research.py coach pool buff stamina` before you start. DayLap.gd (194 lines, DAYLAP1A, merged) is the model: pure
statics, data in JSON, read-only arguments. Read `Godot/scripts/DayLap.gd:34-60` (stations(), efficiency()) and its header comment.

## What would a human do?
A coach has a tank. Each session he is present for costs some of it; stood at a station he sharpens the fighter's gains there. An
empty coach gives no buff and a tired one a weak buff, so the player rations him across the week (one coach-heavy session a day, not six).

## Prefab check
None: ~100-line pure static module.

## Owned files (all new)
- `Godot/scripts/CoachPool.gd` - `extends RefCounted`, statics only, no GameState, no RNG, no preload, never mutates arguments.
- `Godot/assets/data/coach_pool.json` - tuning: `pool_max` 100, `drain_per_session_hour` per station id (sparring and pads drain most,
  treadmill/bike least), `buff_at_full` 0.30 (gain multiplier bonus at a full pool), `buff_floor_pool` 10 (below it, no buff),
  `weekly_recovery` per rest day, `skill_scale` (coach skill 1-20 scales buff, e.g. skill/20).
- `Godot/tests/coach_pool_test.gd` - `extends SceneTree`, ok/FAIL lines, final `COACH POOL PASS` or `COACH POOL FAILS=<n>`, `quit(1)` on fail.

## Build (`CoachPool.gd`)
- `static func buff(pool: float, coach_skill: float, present: bool) -> float` - extra gain multiplier (0.0 when not present or pool <
  buff_floor_pool; otherwise buff_at_full * (pool/pool_max) * skill_scale; monotonic non-decreasing in pool and in skill).
- `static func drain(station: String, minutes: int) -> float` - pool points spent; unknown station -> 0.0 and the caller checks `known()`.
- `static func run_session(pool: float, coach_skill: float, station: String, minutes: int) -> Dictionary` ->
  `{"ok": true, "buff_avg": float, "end_pool": float}`; minute by minute, buff read from the pool the coach ENTERS the minute with, drain
  applied after (same clock rule as DayLap.gd header); pool clamps 0..pool_max; unknown station -> `{"ok": false, "reason": ...}`.
- `static func rest_day(pool: float) -> float` - weekly recovery, clamp to pool_max.

## Acceptance (the one test)
(a) a full-pool skill-20 coach gives a bigger buff than a half-pool one, which gives more than a below-floor one (0.0);
(b) not present -> 0.0 whatever the pool;
(c) **ration**: over a 6-session week (3 h each at pads), coach present every session ends with LESS total buff in sessions 4-6 than
    sessions 1-3 (the pool drained); present in alternating sessions delivers a higher average buff per present session;
(d) skill monotonic: skill 20 > skill 10 > skill 1 at equal pool;
(e) end_pool never below 0 or above pool_max; rest_day refills but clamps;
(f) unknown station refused with a reason; arguments not mutated (deep compare of any Array/Dictionary passed);
(g) numbers come from the data: test reads `pool_max` from the JSON and asserts it equals CoachPool's behaviour (e.g. rest_day(0) <= it);
(h) control arm: with `drain_per_session_hour` forced to 0 in a copy of the table, the (c) ration effect disappears (sessions 4-6 equal 1-3).
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/CoachPool.gd Godot/tests/coach_pool_test.gd`
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/coach_pool_test.gd` (NEVER `_console.exe`).

## The one trap
Clock rule: buff for minute n reads the pool at the START of minute n; drain after. Reading it after the drain makes (c) pass for the wrong reason.
Fixtures: two different coaches in every comparison are fine only where the test says; never test identical fighters/coaches across arms except the control (h).
