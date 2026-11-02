# TASK GYM4C - People who walk into the club: WalkIns.gd + walk_ins.json + its test

Model: any strong coder. Owner: Arena (cloud; own `arena/` branch, open a PR into master, NEVER merge).
Tier: new script + new data + new test -> parse gate on the new files + the new test. Headless, pure, no UI.

## What it is
The operator wants the gym "like a living entity - people come and go outside and anyone can walk in" (design
`research/GYM4_REDESIGN_S178.md`). We read how the game Chef does it from its own code: a POOL per visitor type times a
time-of-day CURVE decides who arrives; visitors walk fixed waypoints (street -> door -> desk -> ...). Interviews happen AT THE
RECEPTION DESK (operator ruling). This task is the pure schedule: who arrives at which game minute, where they walk, when they
leave. No 3D, no navigation.

## Owned files (create; touch nothing else)
- `Godot/assets/data/walk_ins.json`:
  - `day_minutes` (600, the day runs from 08:00 = minute 0), `slots` (e.g. 20 slots of 30 min),
  - per kind (fighter_candidate, coach_candidate, member, promoter, reporter, passer_by): `base_per_day`, `fame_mult`
    (extra per fame point 0..100), `ads_mult` (extra when ads on), `curve` (one weight per slot - members peak early morning and
    evening, candidates mid-morning, passers-by all day), `stay_minutes` [min, max], `path` (waypoint ids, e.g.
    member: street_left, door_in, desk_front, locker_door, floor_entry, ..., exit; fighter_candidate: street_left, door_in,
    desk_front (INTERVIEW here), exit; passer_by: street_left, street_right - never enters),
  - `max_inside` (crowding cap; arrivals past it wait outside, then leave).
- `Godot/scripts/WalkIns.gd` - `extends RefCounted`, static, pure (no GameState, no autoload, no preload; the ONLY randomness is a
  RandomNumberGenerator built from the seed passed in):
  - `static func expected(kind: String, fame: int, ads: bool) -> float` = base_per_day * (1 + fame_mult*fame) * (ads? 1+ads_mult : 1).
  - `static func day_schedule(day_index: int, fame: int, ads: bool, seed: int) -> Array` -> arrivals sorted by minute:
    {id: "<kind>_<n>", kind, arrive_minute, leave_minute, path: Array[String], interview: bool}. Count per kind = a deterministic
    rounding of expected() (e.g. floor + a seeded draw on the fraction); each arrival's slot drawn from that kind's curve.
    interview true only for fighter_candidate / coach_candidate. leave = arrive + stay drawn in stay_minutes, clamped to day_minutes.
    Enforce max_inside: an arrival that would make inside > max_inside gets path [street_left, door_out, street_right] and
    leave = arrive + 2 ("turned away").
  - `static func inside_at(schedule: Array, minute: int) -> Array` -> ids inside the building at that minute (passers-by never).
- `Godot/tests/walk_ins_test.gd` - `extends SceneTree`, ok/FAIL lines, final `WALK INS PASS` or `WALK INS FAILS=<n>` + exit 1.

## Acceptance (numbers read from the data, never copied)
1. Determinism: same (day, fame, ads, seed) -> identical schedule; a different seed -> a different schedule (on a fixture with
   enough arrivals).
2. Sorted by arrive_minute; every arrive in [0, day_minutes), leave > arrive, leave <= day_minutes.
3. Over 200 seeded days, the mean count per kind is within 10% of expected(); fame 80 gives more candidates than fame 0; ads
   on gives more members than ads off.
4. The curve shapes arrivals: over 200 days, members' arrivals in their two peak slots beat their trough slots.
5. Candidates' path contains "desk_front" and interview == true; members never interview; passers-by never appear in inside_at.
6. max_inside is never exceeded by inside_at at any minute; turned-away visitors have the 3-point path.
7. Purity: the data cache is never mutated by callers; no global RNG used (call randi() before and after - same schedule).
MUTANTS (comment block at the bottom; run them if you can; each must turn the test red): ignore fame; drop the curve (uniform
slots); let passers-by into inside_at; skip the max_inside check.

## Parse gate + test
`python Godot/tools/check_scripts.py Godot/scripts/WalkIns.gd Godot/tests/walk_ins_test.gd`
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/walk_ins_test.gd`
No Godot in your sandbox? Say so in the PR body; do NOT build Godot from source.

## Prior research
GYM4_REDESIGN_S178.md "Chef, read from its own code" (CustomerGroupsGenerator pool x frequency/probability curves; StaticPositions
waypoints), D71 (living-building survey, raw), G74 (gym market demand pool + crowding), G88 (crowded floor numbers).

## What would a human do?
Copy Chef's proven shape (pool x day curve, fixed waypoints), keep every number in data, and prove the averages with many seeds.

## Prefab check
None: pure schedule. The 3D walkers come later from our own bodies.

## The one trap
Use a local `RandomNumberGenerator` seeded per call; never `randi()`/`randf()` (global state breaks determinism and other tests).
