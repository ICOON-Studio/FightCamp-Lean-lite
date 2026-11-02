# TASK C128 — CODEX — ONE CLOCK FOR BOTH FIGHTERS: THE MOVE SCRIPT'S PAIR SCHEDULE, A CONTRACT TEST WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (THE MOVE SCRIPT).

**Test tier: A NEW TEST FILE ONLY.** You write the test BLIND from the contract below - the module
`Godot/scripts/FightMoveScript.gd` is being written by Claude at the same time and is NOT on disk for you to read.
Parse gate only (`python Godot/tools/check_scripts.py Godot/tests/fight_move_script_test.gd`; the "could not preload
FightMoveScript.gd" error is expected while the module is missing - every other parse error is yours). Do not run
Godot, do not commit (your sandbox cannot write `.git`); Claude runs the test against the module and against deliberate
breaks of it.

## Owned file

- `Godot/tests/fight_move_script_test.gd` - NEW, `extends SceneTree`.

## Why this exists

Our 3D boxing room plays the thrower's punch and the receiver's reaction as two clips started on two clocks, then
patches each body part on its own timer; the operator's verdict: "There is no cohesion between animations and
reactions". The fix: an exchange (a jab landing on the head) is ONE PAIR ASSET for both fighters on ONE clock, authored
in Blender. Unreal 5.8's Contextual Animation does the same (C127): pick the pair whose distance range fits where the
men stand, warp both bodies to the pair's start over an entry window, start both animations at one start time. This
module is that schedule for our room. It is pure arithmetic, so a blind test pins it exactly.

## The contract (the module is `preload("res://scripts/FightMoveScript.gd")`; every function is `static`)

A PAIR is a Dictionary:
`{"id": String, "length_s": float, "contact_s": float, "entry_s": float, "start_gap_m": float, "min_gap_m": float,
"max_gap_m": float, "end_travel_m": {"thrower": float, "receiver": float}}`
- `length_s` - the pair asset's length on its own clock (pair time 0 = the first frame of both fighters' takes).
- `contact_s` - the pair time the glove meets the target.
- `entry_s` - the pair time by which both bodies must stand at `start_gap_m` (the alignment window's end).
- `start_gap_m` - the hips-to-hips gap along the fight line the asset was authored at.
- `min_gap_m`, `max_gap_m` - the INCLUSIVE gap range this pair is selected for.
- `end_travel_m` - each body's net travel along the fight line over the pair, + = toward the other man.

1. `select_variant(variants: Array, gap_m: float) -> int` - the index of the FIRST pair (array order) with
   `min_gap_m <= gap_m <= max_gap_m`. If none passes: the index of the pair whose range is NEAREST (`min_gap_m - gap_m`
   when the gap is below the range, `gap_m - max_gap_m` when above), ties to the lower index. An empty array: `-1`.
2. `schedule_pair(pair: Dictionary, impact_s: float, last_impact_s: float) -> Dictionary` - where the pair sits on the
   room's show clock when the engine resolves its impact at `impact_s`. `origin_s = impact_s - contact_s` (where pair
   time 0 falls). `seek_s = 0.0`, except when `last_impact_s >= 0.0` and `origin_s < last_impact_s`: then
   `seek_s = min(contact_s, last_impact_s - origin_s)` (a combination punch does not start before the previous one
   lands - it starts on that impact, `seek_s` into the pair, and its contact stays on its own impact).
   `start_s = origin_s + seek_s`, `end_s = origin_s + length_s`. Returns
   `{"origin_s", "start_s", "seek_s", "impact_s", "end_s", "length_s"}` (`length_s` copied from the pair).
3. `pair_time(schedule: Dictionary, show_s: float) -> float` - `-1.0` when `show_s < start_s`; otherwise
   `min(show_s - origin_s, length_s)`. Both fighters' takes are sampled at this ONE time.
4. `align_weight(pair: Dictionary, schedule: Dictionary, show_s: float) -> float` - `0.0` when `pair_time < 0`;
   `1.0` when `seek_s >= entry_s`; otherwise `a = clamp((pair_time - seek_s) / (entry_s - seek_s), 0, 1)` and the
   result is `3a^2 - 2a^3` (Unreal's HermiteCubic).
5. `gap_at(pair: Dictionary, schedule: Dictionary, from_gap_m: float, show_s: float) -> float` -
   `from_gap_m + (start_gap_m - from_gap_m) * align_weight(pair, schedule, show_s)`.
6. `end_gap_m(pair: Dictionary) -> float` - `start_gap_m - end_travel_m.thrower - end_travel_m.receiver`.
7. `validate_pair(pair: Dictionary) -> PackedStringArray` - one message per problem, EMPTY for a valid pair. Each
   message CONTAINS the offending key's name. Problems: a missing key (any of the eight top-level keys, or `thrower` /
   `receiver` inside `end_travel_m` - message names that inner key); `length_s <= 0`; `contact_s < 0` or
   `contact_s > length_s` (message names `contact_s`); `entry_s < 0` or `entry_s > contact_s` (names `entry_s`);
   `min_gap_m > max_gap_m` (names `min_gap_m`); `start_gap_m` outside `[min_gap_m, max_gap_m]` (names `start_gap_m`).
   Values are read as numbers; a missing key is reported and its range checks are skipped (no crash).

## Worked examples - walk each one; they are the real situations the room meets

Pair JAB: `length_s 1.6, contact_s 0.6, entry_s 0.35, start_gap_m 1.23, min_gap_m 1.1, max_gap_m 1.36,
end_travel_m {thrower 0.05, receiver -0.08}`.
- A lone jab, impact at 10.0 s, nothing before it (`last_impact_s -1.0`): origin 9.4, seek 0, start 9.4, end 11.0.
  `pair_time` at 9.3 is -1; at 9.4 is 0; at 10.0 is 0.6 (= contact on the impact); at 12.0 is 1.6.
  `align_weight` at 9.575 (pair time 0.175, a = 0.5) is 0.5; at 9.4 is 0; at 10.2 is 1.
  `gap_at` from 1.43 at 9.575 is 1.33; `end_gap_m` is 1.26.
- The second punch of a combination: the previous punch landed at 9.7. Origin 9.4 < 9.7, so seek = min(0.6, 0.3) = 0.3,
  start 9.7, end 11.0; `pair_time` at 9.65 is -1, at 9.7 is 0.3, at 10.0 is still 0.6. `align_weight` at 9.725
  (pair time 0.325: a = 0.025 / 0.05 = 0.5) is 0.5.
- A very late combination: previous impact 9.95 -> seek = min(0.6, 0.55) = 0.55 >= entry 0.35 -> `align_weight` is 1.0
  from the start.
- Selection over three authored distances, in this order: LONG `[1.30, 1.50]`, MID `[1.10, 1.35]`, SHORT `[0.90, 1.15]`:
  gap 1.32 -> 0 (LONG and MID both pass; LONG is first); 1.20 -> 1; 1.12 -> 1 (MID before SHORT); 0.80 -> 2 (SHORT is
  0.10 away, MID 0.30); 1.70 -> 0 (LONG is 0.20 away); 1.10 exactly with MID's literal `min_gap_m` 1.10 -> 1
  (inclusive). Equal distances: ranges `[1.0, 1.1]` then `[1.3, 1.4]` at gap 1.2 -> 0 - but build this one from exactly
  representable binary values instead (ranges `[1.0, 1.25]` and `[1.75, 2.0]` at gap 1.5) so a double rounding never
  decides the tie.

## The test

- `const MoveScript := preload("res://scripts/FightMoveScript.gd")`; type every value you read back
  (`var w: float = MoveScript.align_weight(...)`, `var s: Dictionary = MoveScript.schedule_pair(...)`).
- Counters live in a Dictionary (`var c := {"checks": 0, "fails": 0}`) - a GDScript lambda cannot increment a
  captured int, and last time's TOTAL=0 came from exactly that.
- Compare floats within 1e-6. **Keep every expected value clear of a strict comparison's boundary** - never assert a
  result that a 1e-12 rounding would flip (the inclusive-boundary case above uses the same literal on both sides, and
  the tie case uses exact binary values). Every check must be able to FAIL: for each check, know which wrong
  implementation it catches (seek not clamped to `contact_s`; `end_s` from `start_s` instead of `origin_s`;
  `pair_time` measured from `start_s`; a linear instead of Hermite weight; `seek_s >= entry_s` not short-circuited;
  selection taking the NEAREST even when a range passes; a tie going to the higher index; `validate_pair` passing an
  `entry_s` after `contact_s`; `end_gap_m` adding the travels).
- At least 30 checks, covering all seven functions and every worked example above, plus: `validate_pair` of the JAB pair
  is empty; each problem listed in 7 produces a message naming its key; a pair with `end_travel_m` missing `receiver`
  names `receiver` and does not crash.
- Each failure prints `FAIL <what> got <x> want <y>`. The last line:
  `print("FIGHT_MOVE_SCRIPT_TEST checks=%d failures=%d" % [c["checks"], c["fails"]])`, then `quit()`.

## Send

`python Tools/agent_comms.py send --from codex --to claude --topic "C128 ready" --body "test written, <N> checks, parse gate: <result>"`.
Do not edit any other file.

## The trap

`schedule_pair` has two times that look alike: `origin_s` (where pair time 0 falls - it may be BEFORE anything is shown)
and `start_s` (when the pair is first shown). `end_s` and `pair_time` both count from `origin_s`, never from `start_s`,
so a seeked combination punch still makes contact on its own impact and still ends where the unseeked one would.

## SEND-BACK 1 (Claude, 2026-09-14) - 47 CHECKS GREEN, 7 OF 10 MUTANTS KILLED; ADD THE THREE CASES THAT KILL THE REST

Claude ran your test against the module (47/47) and against ten deliberate breaks. Seven turned it red. Three survived,
and each is the CONTRACT'S fault - its worked examples could not tell them apart - so add these checks (keep all 47):

1. **The seek clamp must bind once.** JAB, impact 10.0, `last_impact_s` 10.25: origin 9.4, `last - origin` is 0.85,
   so `seek_s = min(0.6, 0.85) = 0.6` and `start_s` is 10.0 (the impact itself). An unclamped seek gives 0.85 / 10.25.
2. **The weight must be Hermite away from a = 0.5.** HermiteCubic at a = 0.5 is 0.5 - the same as linear - so the
   only midpoint check could not catch a linear weight. Lone JAB (seek 0, entry 0.35) at show 9.4875: pair time 0.0875,
   a = 0.25, weight `3(0.25)^2 - 2(0.25)^3 = 0.15625` (linear would give 0.25). And at show 9.6625: pair time 0.2625,
   a = 0.75, weight 0.84375.
3. **A passing range beats a nearer one.** Ranges in this order: `[1.40, 1.50]`, then `[1.00, 2.00]`; gap 1.45 -> 0.
   Also the other order, `[1.00, 2.00]` then `[1.40, 1.50]`, gap 1.45 -> 0 (the first passing range wins even though
   the second is tighter).

Same rules as before: Dictionary counters, floats within 1e-6, every expected value clear of a strict comparison's
boundary. Parse gate, then send `--topic "C128 ready" --body "send-back 1: <N> checks, parse gate: <result>"`.
