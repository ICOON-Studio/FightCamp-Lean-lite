# TASK DAYLAP1A - the day lap: stamina spent across training stations (pure module + data + test)

Model: Arena (free coding worker), own branch arena/<chat-id>-fightcamp, PR into master, never merge.
Tier: new pure module + new data file + new test -> parse gate + that test.

Operator (S172, verbatim): "The loop is the day similar to a lap. [...] The fighter during the day has options to train on the heavy bug on
the different things while the time is, is running. Each thing gives specific benefits, but he loses stamina. So he, the loop is that he,
he needs to manage the stamina during each day." Design of record: `research/DAYLAP1_DESIGN.md`.

## Prior research
`python Tools/prior_research.py stamina training station fatigue` (the week planner and gains live in GameState; this slice does NOT touch
them). Reference watched S172: MMA Manager 2 trains one station at a time with an energy bar (`research/MMAM2_WATCH_S172.md`).

## What would a human do?
A coach watches the clock and the kid's breathing: treadmill while he is fresh, technique before he is too tired to do it clean, recovery
when he is empty. Pushing an empty fighter gains almost nothing and risks injury.

## Prefab check
None: a ~150-line pure static module. No GameState, no autoload, no RNG, no preload.

## Owned files (all new)
- `Godot/scripts/DayLap.gd` - `extends RefCounted`, statics only.
- `Godot/assets/data/day_lap_stations.json` - the station table (data, so tuning never touches code).
- `Godot/tests/day_lap_test.gd` - `extends SceneTree`, ok/FAIL lines, final `DAY LAP PASS` or `DAY LAP FAILS=<n>`, `quit(1)` on any fail.

## Build
1. Data `day_lap_stations.json`:
   - `"day_minutes": 600` (a training day, 10 h), `"block_minutes": 200` (three blocks: morning, afternoon, evening).
   - `"stations"`: treadmill, bike, weights, heavy_bag, speed_bag, pads, ring_sparring, defence_drill, recovery. Each:
     `{"label": "...", "trains": {"<stat>": <gain per fresh hour>}, "drain_per_hour": <stamina points>}`. Stats: conditioning, power,
     hand_speed, technique, defence, ring_iq. Recovery has a NEGATIVE drain (it refills, e.g. -25) and trains nothing.
     Sparring drains the most, recovery refills, technique stations sit in between. Pick sensible numbers; they are tuning, not contract.
   - `"min_efficiency": 0.1`, `"injury_risk_below": 15` (stamina under which every working minute adds injury risk).
2. `DayLap.gd`:
   - `static func stations() -> Dictionary` (reads the JSON once, cached).
   - `static func efficiency(stamina: float) -> float` - gain multiplier from stamina 0..100: 1.0 at 100, falling smoothly to
     `min_efficiency` at 0 (e.g. linear or a curve; monotonic non-decreasing in stamina).
   - `static func run_day(start_stamina: float, plan: Array) -> Dictionary` - `plan` is an ordered list of
     `{"station": id, "minutes": n}` that must sum to <= day_minutes (refuse otherwise: `{"ok": false, "reason": "..."}`).
     Simulate minute by minute: each working minute adds `trains[stat] / 60 * efficiency(stamina)` to that stat and drains
     `drain_per_hour / 60`; stamina clamps to 0..100; while stamina < injury_risk_below each working minute adds to `injury_risk`.
     Returns `{"ok": true, "gains": {stat: float}, "end_stamina": float, "injury_risk": float, "timeline": [ {minute, station, stamina} per
     station change ], "blocks": [stamina at the end of each block]}`.
   - `static func overnight(end_stamina: float) -> float` - recovery to the next morning (e.g. +60, clamp 100). Data-driven key
     `"overnight_recovery"`.
   - Never mutates its arguments.

## Acceptance (the one test) - `Godot/tests/day_lap_test.gd`
(a) **The operator's example**: a whole day on the treadmill gives MORE conditioning than any other one-station day, AND ends with stamina
    at or near 0 and injury_risk > 0;
(b) **rotation pays**: a day split treadmill 200 + recovery 100 + treadmill 300 ends with more stamina and less injury risk than 600 treadmill,
    and its conditioning is at least 70% of the all-day treadmill's (rest is not wasted);
(c) **diminishing returns**: conditioning gained in the last 100 minutes of an all-day treadmill is less than in the first 100;
(d) **specialisation costs**: an all-day heavy bag raises power more than a mixed day but leaves conditioning/defence at 0 gain;
(e) refusals: a plan over day_minutes is refused with a reason; an unknown station is refused; arguments are not mutated (deep compare);
(f) efficiency is 1.0 at 100, `min_efficiency` at 0, and never decreases as stamina rises (check 0..100 step 5);
(g) recovery refills (end stamina after 100 min recovery > start) and trains nothing;
(h) **the numbers come from the data**: the test reads `day_minutes` from the JSON and asserts 600.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/day_lap_test.gd` (NEVER `_console.exe`).

## The one trap
Gains must be computed with the stamina AT that minute (drain first or after - pick one and say which in a comment), or (c) passes for the
wrong reason. Do not wire this into GameState or any screen (Claude does that after the merge). Do not delete or weaken any test.
