# TASK C125 — CODEX — THE REACTION STARTS ON THE VISIBLE HIT: THE LIVE SCHEDULE'S RECEIVER LEAD, A CONTRACT TEST WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (the operator, 2026-09-14: "reactions need syncing").

**Test tier: A NEW TEST FILE ONLY.** You cannot run Godot or write `.git`: write the test, then STOP. Claude runs it and
proves it against deliberate breaks of the module. Do not open `Godot/scripts/FightLiveSchedule.gd` or its existing test
`Godot/tests/fight_live_schedule_test.gd` - this test is written from THIS contract, blind.

## Owned files

- `Godot/tests/fight_live_schedule_receiver_lead_test.gd` - NEW. `extends SceneTree`; all work in `_initialize()`;
  `load("res://scripts/FightLiveSchedule.gd")` there; print `ok  <name>` / `FAIL <name>: <detail>` per check, then
  `TOTAL=<n> fails=<m>` and `quit(1 if m > 0 else 0)`. At least 25 checks. KEEP THE COUNTERS IN A DICTIONARY: a GDScript
  lambda that does `checks += 1` on a local int changes a COPY - your C124 test printed `TOTAL=0 fails=0` whatever failed.

## The contract (`FightLiveSchedule.gd`, static functions on a schedule Dictionary)

- `create() -> Dictionary` - an empty schedule.
- `add_action(schedule, beat: Dictionary, impact_s: float, lead_s: float, target_lead_s: float = 0.0) -> void`. Only a
  beat whose `type` is `"action"` is added (anything else adds nothing). `beat.actor_side` and `beat.target_side` are
  `"a"` / `"b"` (either may be `""`, which adds no part for that side).
  - The ACTOR part: `{"side": actor, "part": "actor", "start_s": impact_s - max(0, lead_s), "seek_s": 0.0,
    "impact_s": impact_s, "beat": beat}` - except when this actor's previous throw's impact (`last_throw_s[actor]`, kept in
    the schedule) is later than that start: then `seek_s = min(max(0, lead_s), last_throw - start_s)` and `start_s` moves
    forward by `seek_s`. Every added actor part sets `last_throw_s[actor] = impact_s`.
  - The TARGET part (NEW): `{"side": target, "part": "target", "start_s": T, "impact_s": impact_s, "beat": beat}` where
    `T = impact_s - target_lead_s`, then, when the beat has an actor, `T = max(T, impact_s - max(0, lead_s))` - never
    before the actor's UNSEEKED start. A negative `target_lead_s` makes the target start AFTER the impact.
    With `target_lead_s` omitted the target starts exactly at `impact_s`.
- `take_due(schedule, now_s: float, lead_cap_s: float) -> Array` - every entry whose `start_s <= now_s`, REMOVED from
  the schedule, in start order (entries with equal starts keep the order they were added), each a copy carrying
  `budget_s`.
- `is_empty(schedule) -> bool`.

## What the test must cover (exact expected numbers, tolerance 1e-6)

Default target lead (omitted) = impact; `target_lead_s` 0.17 with `lead_s` 0.40 -> target at impact - 0.17; a lead bigger
than the actor's (`target_lead_s` 0.5, `lead_s` 0.3) clamps to the actor's start; a negative target lead (-0.033) starts
after the impact; `lead_s` negative behaves as 0 for both the actor and the clamp; a beat with no actor (actor_side "")
is not clamped; a non-action beat adds nothing; the actor's seek on a fast second throw does NOT move the target's clamp
(the clamp uses the unseeked start); `take_due` returns entries in start order across beats (add beat 1 with impact 2.0 / lead 0.3 / target lead 0, then
beat 2 (same actor) with impact 2.1 / lead 0.3 / target lead 0.25 - beat 2's target (1.85, clamped against the UNSEEKED
actor start 1.8) comes out before beat 1's target (2.0); beat 2's actor is seeked to 2.0 and comes out after beat 1's target)
and in added order on a tie; entries come out removed
(`is_empty` true after taking everything); `budget_s` exists on every taken entry.

## Send

`python Tools/agent_comms.py send --from codex --to claude --topic "C125 ready" --body "test written, not run"`. Do not
edit any other file. Do not run Godot.

## The trap

Write every expected `start_s` by hand from the formulas above; never compute it by calling the module. Claude will run
your test against deliberate breaks (the target not clamped, clamped to the SEEKED start, the target lead ignored, the
sign of the target lead flipped, `lead_s` negative not treated as 0); each must fail at least one check.

## CORRECTION 2026-09-14 (Claude, after collection)

The contract above was WRONG in one rule: the target clamps to the actor's SEEKED start, not the unseeked one. Clamped
to the unseeked start, a fast second throw's receiver began reacting before that punch had started and before his
reaction to the punch still landing (the ordering case put beat 2's target at 1.85 s, ahead of beat 1's at 2.0 s). The
live room showed it as 31 clips played against 35 by 44 s on seed 94301. `FightLiveSchedule.add_action` and the test's
seek and ordering cases were corrected together; the old clamp, run as a mutant, fails the corrected checks.
