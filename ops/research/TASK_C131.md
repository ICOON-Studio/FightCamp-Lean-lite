# TASK C131 — CODEX — A PUNCH AFTER A PUNCH: THE COMBINATION SPACING RULE'S CONTRACT TEST, WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch `master`.
Stage: S4a (SMOOTH THE JAB IN COMBOS).

**Test tier: A NEW TEST FILE ONLY, WRITTEN BLIND.** Do NOT run Godot (your sandbox cannot boot it), do not run the parse
gate, do not commit (your sandbox cannot write `.git`). Claude parses, runs and mutates it at collection. The module
function does not exist in your checkout yet: write the test from THIS contract, never look for an implementation.

## Owned files

- `Godot/tests/fight_combo_spacing_test.gd` - NEW, `extends SceneTree`, headless, prints `failures=N` and quits.

## Why this exists

Our fight engine can land one boxer's blows 0.1 s apart (39% of a fighter's consecutive blows in four seeded bouts). Two-man
footage of real boxers (`research/S4A_PAIRS/footage_two_men.json`, 36 combinations tracked with MediaPipe) says the
next punch of a combination starts at least 0.17 s after the previous punch's peak (p10; p50 0.35 s). Measured through the
same instrument, the live room starts follow-ups 0.07 s after the previous peak (p10), and 9 of the 18 authored jab pairs it
played were cut on the frame before their contact by the thrower's next punch. The operator chose "Smooth the jab in
combos". The fix is a PRESENTATION rule, never an engine change: the room shows a blow LATER than the engine resolved it
when it came too soon after the same man's previous blow, keeps every later action in order behind it, and lets idle
time between exchanges absorb the delay. This file is the rule's contract; your test is how we know it holds.

## The contract (pure; `Godot/scripts/FightLiveSchedule.gd`, `class_name FightLiveSchedule`)

Load it in the test with `load("res://scripts/FightLiveSchedule.gd")` inside `_initialize()` (no top-level preload), and
TYPE every value you take from it: `var t: float = Schedule.space_impact(...)`, `var s: Dictionary = Schedule.create()`.

Constants (read them from the script: `(Schedule as GDScript).get_script_constant_map()`):
- `ONSET_AFTER_PEAK_S := 0.17` - footage p10 of `combinations.all.peak_to_onset_s` (n = 36).
- `IDLE_CAP_S := 0.5` - while the room is behind the engine, each gap between two actions is shown at most this long.
- `MAX_LAG_S := 2.0` - the room never shows an action more than this long after the engine resolved it.

`static func create() -> Dictionary` - unchanged except that it now also holds `"spaced_last": {}` and `"spaced_throw_s": {}`.

`static func space_impact(schedule: Dictionary, side: String, engine_impact_s: float, extension_s: float,
latest_s: float = OPEN_BUDGET_S, onset_after_peak_s: float = ONSET_AFTER_PEAK_S, idle_cap_s: float = IDLE_CAP_S,
max_lag_s: float = MAX_LAG_S) -> float`

Returns the SHOWN impact second of one action and records it in `schedule`. `side` is the thrower (`"a"`/`"b"`), or `""`
for an action whose thrower plays no strike (it keeps order but is never spaced as a punch). `extension_s` is how long
the thrower's take takes from its first frame to its contact. `latest_s` is the end of the round the action belongs to.
In this exact order, with `e = engine_impact_s`:

1. `t = e`.
2. ORDER: when `schedule["spaced_last"]` is non-empty, `t = max(t, spaced_last.shown_s + clamp(e - spaced_last.engine_s, 0.0, idle_cap_s))`.
3. SPACING: when `side` is not empty and `schedule["spaced_throw_s"]` has `side`,
   `t = max(t, spaced_throw_s[side] + onset_after_peak_s + max(0.0, extension_s))`.
4. LAG CAP: `t = min(t, e + max(0.0, max_lag_s))`.
5. ROUND: `t = min(t, max(e, latest_s))` (never past the round's end, and never before the engine's own tick).
6. RECORD: `schedule["spaced_last"] = {"engine_s": e, "shown_s": t}`; when `side` is not empty,
   `schedule["spaced_throw_s"][side] = t`. Nothing else in `schedule` changes (`entries`, `seq`, `known_to_s`,
   `last_throw_s` stay exactly as they were).
7. Return `t`.

A schedule made before this change (a Dictionary with no `spaced_last` / `spaced_throw_s` keys) behaves as if both were
empty, and gains both keys.

## Worked examples (defaults unless named; compare floats within 1e-6)

One schedule, in sequence:
1. `space_impact(s, "a", 10.0, 0.2)` -> **10.0**. Then `spaced_last == {"engine_s": 10.0, "shown_s": 10.0}`, `spaced_throw_s == {"a": 10.0}`.
2. `space_impact(s, "a", 10.1, 0.2)` -> **10.37** (order 10.1; spacing 10.0 + 0.17 + 0.2).
3. `space_impact(s, "b", 10.15, 0.25)` -> **10.42** (order 10.37 + 0.05; b has thrown nothing).
4. `space_impact(s, "a", 10.35, 0.2)` -> **10.74** (order 10.42 + 0.2 = 10.62; spacing 10.37 + 0.37 = 10.74).
5. `space_impact(s, "b", 12.0, 0.25)` -> **12.0** (order 10.74 + min(1.65, 0.5) = 11.24; spacing 10.42 + 0.42 = 10.84).
   After 5: `spaced_throw_s == {"a": 10.74, "b": 12.0}`.

Separate schedules (build each by setting the two keys on `create()` directly):
6. PARTIAL DECAY: `spaced_last = {"engine_s": 20.0, "shown_s": 21.0}`, no throws; `space_impact(s, "a", 20.8, 0.0)` -> **21.5**.
7. LAG CAP: `spaced_last = {"engine_s": 30.0, "shown_s": 31.9}`, `spaced_throw_s = {"a": 31.9}`;
   `space_impact(s, "a", 30.05, 0.3)` -> **32.05** (order 31.95, spacing 32.37, cap 30.05 + 2.0).
8. ROUND END: `spaced_last = {"engine_s": 179.8, "shown_s": 180.1}`, `spaced_throw_s = {"b": 180.1}`;
   `space_impact(s, "b", 179.9, 0.2, 180.0)` -> **180.0**.
9. ROUND END BEFORE THE TICK: fresh `create()`; `space_impact(s, "a", 185.0, 0.2, 180.0)` -> **185.0**.
10. NO THROWER: fresh; `space_impact(s, "a", 10.0, 0.2)` -> 10.0; `space_impact(s, "", 10.05, 0.2)` -> **10.05** and
    `spaced_throw_s` still has exactly one key, `"a"`; then `space_impact(s, "a", 10.1, 0.2)` -> **10.37**.
11. NEGATIVE EXTENSION: fresh; `space_impact(s, "a", 10.0, 0.2)`; `space_impact(s, "a", 10.1, -0.5)` -> **10.17**.
12. OUT OF ORDER: `spaced_last = {"engine_s": 10.0, "shown_s": 10.3}`, no throws; `space_impact(s, "b", 9.9, 0.0)` -> **10.3**.
13. CUSTOM RULES: fresh; `space_impact(s, "a", 5.0, 0.2, 1.0e6, 0.3, 1.0, 0.1)` -> 5.0;
    `space_impact(s, "a", 5.05, 0.2, 1.0e6, 0.3, 1.0, 0.1)` -> **5.15** (spacing 5.5, capped at 5.05 + 0.1).
14. LEGACY SCHEDULE: `var s: Dictionary = {"entries": [], "seq": 0, "known_to_s": 0.0, "last_throw_s": {}}`;
    `space_impact(s, "a", 3.0, 0.2)` -> **3.0**, and `s` now has both `spaced_last` and `spaced_throw_s`.
15. UNTOUCHED: on a `create()` schedule with one `add_action` already inserted (any action beat `{"type": "action",
    "actor_side": "a", "target_side": "b"}` at impact 1.0, lead 0.2), take a `.duplicate(true)` of `entries`, `seq`,
    `known_to_s` and `last_throw_s`, call `space_impact(s, "b", 2.0, 0.3)`, and check all four are equal to the copies.

Also check, from the constant map: `ONSET_AFTER_PEAK_S`, `IDLE_CAP_S`, `MAX_LAG_S` exist with the values above, and that
`ONSET_AFTER_PEAK_S` equals (within 1e-6) the p10 read at test time from
`res://research/S4A_PAIRS/footage_two_men.json` -> `combinations` -> `all` -> `peak_to_onset_s` -> `p10` (read it with
`FileAccess.get_file_as_string` + `JSON.parse_string`; the constant must be DERIVED from that file, so a drift fails).
And one PROPERTY sweep: a seeded `RandomNumberGenerator` (seed 131), 400 calls on one schedule with `side` drawn from
`["a", "b", ""]`, engine times increasing by a random 0.0-1.5 s, extensions 0.0-0.6 s: every returned `t` is >= its `e`,
<= `e + MAX_LAG_S`, and >= the previous call's returned `t` (order kept - with the default `latest_s`).

## Rules for the file

- Counters live in a Dictionary (`var r := {"checks": 0, "failures": 0}`): a GDScript lambda cannot change a captured int.
- Print one `FAIL <what> expected <x> got <y>` line per failure, then `C131 checks=<n> failures=<n>`, then
  `failures=<n>`, then `quit(1 if failures else 0)`.
- No `class_name`, no top-level `preload` of any script.

## Deliver

Write the one owned file. Re-read it once against the numbered steps and each worked example by hand. Then
`python Tools/agent_comms.py send --from codex --to claude --topic "C131 ready" --body "tests/fight_combo_spacing_test.gd, <n> checks, blind"`.
Do not commit, do not edit HANDOFF.md.

## The trap

Worked example 5 is where most wrong versions agree with the right one on examples 1-4: the ORDER term uses the idle cap
as a MINIMUM of the engine gap, never a maximum, and the spacing term reads the SAME man's last SHOWN impact, never the
engine's and never the other man's. Compute each expected value from the steps before you write it down.
