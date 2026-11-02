# TASK PACE1 - a station switch costs 5 game minutes, not a walk across the clock; the coach's walk is free (S238, LOOP1)

Seat: Grok Dev (gbot `--to dev`). Branch `grok/pace1`, PR to master; Claude merges by diff. Model: Grok Dev default.
Discipline: BOXING (the demo).

Why (measured S238 on master 0478e0c4): `DayLap.switch_minutes` prices the walk as metres / walk_speed_mps (1.4) / real_s_per_min (0.2):
a 26 m cross-floor walk = 93 GAME minutes of a 600-minute day - every station switch eats ~15% of the day, a 4-station plan loses half
of it to walking. Lead designer Ludo r104 (research/ludo_rx/LUDO_R104_PACING.txt), verbatim:
"Cost: 5 game minutes flat per station switch (covers 45 seconds of walking plus wiping sweat, sipping water, adjusting wraps, and
touching gloves). Clock Sync: Decouple them completely. The visual walk should take 3 to 4 real seconds at a brisk, purposeful stride
(1.8 m/s). During those 3–4 seconds, the game clock simply ticks forward by that fixed 5-minute transition allotment. Never let physical
path distance dictate training time lost." and "Coach Walk Cost: FREE TIME (Zero training day cost). [...] While the coach is en route,
the fighter earns base uncoached gains (1.0x). The moment the coach reaches the work point [...] the coached multiplier instantly kicks
in. The clock never stops or drains waiting for the coach." Day length stays (600 game min x 0.2 s = 120 real s - inside Ludo's 90-120).
Operator ruling for the loop (Q-S237-1): "the loop , animations,workout,feeling of progrsession and improvement from training these are
what matters for now".

## What is on master (read with `sed -n` windows; GymHall3D.gd is ~4,100 lines - never whole)
- `Godot/scripts/DayLap.gd` ~line 206 `switch_minutes(from, to, metres)` = walk + prepare_minutes (8) + glove_minutes (4 when gloves
  change); data in `Godot/assets/data/day_lap_stations.json` (real_s_per_min 0.2, walk_speed_mps 1.4).
- `Godot/scripts/GymHall3D.gd`: `send_to(place)` prices the switch and walks `_route_points` over `_walk_total` game minutes (the
  visual walk is tied to game minutes); the coach walk (your COACHWALK1) ticks `_coach_walk_done/_coach_walk_total` from
  `advance_minutes` and is smoothed in `_process` with `per_min := real_s_per_min` (~line 3485).

## Do (switch `pace_flat_switch`, add it to GameSwitches.GAME_ON - new features ship ON; plain --script tests stay the OFF control arm)
1. Data: `switch_flat_minutes: 5`, `walk_visual_mps: 1.8`, `walk_visual_min_s: 2.5`, `walk_visual_max_s: 5.0` in day_lap_stations.json.
2. `DayLap.switch_minutes`: with the switch ON (pass it in as a parameter or read a flag the caller sets - DayLap is a rules file, keep
   it free of GameSwitches if it is today) a switch costs `switch_flat_minutes` whatever the distance; same station / "" unchanged.
   OFF: today's formula, byte-identical.
3. The fighter's visual walk: with the switch ON, the walk animation covers the route in clamp(metres / walk_visual_mps,
   walk_visual_min_s, walk_visual_max_s) REAL seconds while the clock advances exactly the 5 switch minutes (the clock runs slower during
   the walk, then back to 0.2 s/min). In headless tests (`advance_minutes`) the 5 minutes pass at once and he arrives.
4. The coach: with the switch ON his walk costs the day NOTHING - it runs on real seconds (same 1.8 m/s, clamped 2.5-5 s), not game
   minutes; the block is coached from his arrival (keep COACHWALK1's rule). In headless `advance_minutes`, he arrives after 1 game minute.
5. Nothing else changes (day_minutes, real_s_per_min, gains, the meters).

## Tests (red on master first - paste the red lines in the PR body)
New `Godot/tests/pace_flat_switch_test.gd` (model it on tests/coach_walk_test.gd). Population printed: a male welterweight boxer and coach
"Ray Holl". Assert with the switch ON (user arg or career key): a cross-floor send_to costs 5 game minutes (and a near station 5 too);
the 600-minute day with 4 switches loses 20 minutes, not ~300; the coach arrives within 1-2 game minutes of coach_to and the block is
coached from then; OFF: the old prices exactly (the 26 m walk still 93). Then run the floor tests that know walk minutes:
`python Godot/tools/run_tests.py --jobs 2 --only coach_walk,day_plan,daylap,floor_gain,spar_block_floor,training_meters_floor,walk_ins`
and paste the SUITE line + any FAIL's own line. Parse gate first: `python Godot/tools/check_scripts.py <every touched .gd>`.

## Rules
GDSCRIPT_TRAPS.md (`signal` is a keyword - never a variable name). THE ONE TRAP: a test that pinned the old walk minutes runs as the OFF
control arm or gets the ON value with a comment citing Ludo r104 - never a deleted assertion.

## Prior research
LUDO_R104_PACING.txt, LUDO_R102_LOOP1_raw.txt (coach section D), TASK_COACHWALK1.md, DAYPLANWIRE1 notes ("a cross-floor walk costs ~85
game minutes" - the defect this fixes).

## What would a human do?
The fighter unwraps, takes a sip and is on the next bag in a couple of minutes; the coach strolls over while he is already working.

## Prefab check
None - our own clock and routes.
