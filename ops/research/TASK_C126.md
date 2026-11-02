# TASK C126 — CODEX — A STRIKE'S EXTENSION GIVEN ITS TIME: THE RETIME MODULE'S CONTRACT TEST, WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (operator, 2026-09-14: "Jerky moves").

**Test tier: A NEW TEST FILE ONLY, WRITTEN BLIND.** The module does not exist yet - Cursor is writing it in another
worktree from the SAME contract. You cannot run Godot in your sandbox and you do not need to: write the test from the
contract, send the mail, and Claude runs it against the module and against deliberate breaks of it. No commit (your
sandbox cannot write `.git`; Claude collects).

## Owned files

- `Godot/tests/fight_take_retime_test.gd` - NEW.

## The contract

`research/S4A_SMOOTH/RETIME_CONTRACT.md` - read it WHOLE; it is the only source. Read nothing else: not the module
(it is not there), not `FightStagePlayer.gd`, not HANDOFF.md or any digest.

## What the test must be

`extends SceneTree`; all work in `_initialize()`; `var Retime: Script = load("res://scripts/FightTakeRetime.gd")` there
(no top-level `preload`; call `Retime.remap(...)` etc.). Print `ok  <name>` or `FAIL <name>: <detail>` per check, then a
final `TOTAL=<n> failures=<m>` line, then `quit(1 if failures > 0 else 0)`.

**The two mistakes your last two blind tests made - do not repeat them:**
1. A GDScript lambda that does `checks += 1` on a captured local int changes a COPY: C124 printed `TOTAL=0 failures=0`
   and exited 0 while printing FAIL lines. Keep every counter in a Dictionary (`var tally := {"checks": 0, "fails": 0}`)
   or use a plain function that returns bools - never a counter captured by a lambda.
2. `var x := <a value from a load()ed script>` does not parse (C125). Type every such value explicitly:
   `var out: PackedFloat64Array = Retime.remap(...)`, `var t: float = Retime.map_time(...)`.

Compare floats with a tolerance (`absf(a - b) <= 1e-6`), never `==`. Build every input as `PackedFloat64Array([...])`.
**Derive every expected value BY HAND from the contract and write the arithmetic in a comment above the check** - the
worked example in the contract is one; add your own.

Cover, at least:
- `stretched`: the worked example (`[1]`); `cap_mps <= 0` -> empty; `travel_m` of the wrong size -> empty; one key only
  (n < 1) -> empty; a fast interval that is NOT a spike (fast, but under `spike_ratio` x its smaller neighbour) -> not
  stretched; the same with `spike_ratio = 0` -> stretched; a fast interval at index 0 (one neighbour) and at the last
  index; `n == 1` with a fast interval -> stretched; a zero-length interval (`h_k == 0`) -> never stretched; two
  stretched intervals -> both, ascending.
- `remap`: the worked example exactly; nothing stretched -> an unchanged copy; `out[0] == key_times[0]` when
  `key_times[0] != 0`; the `min_scale` floor (a hold compressed to exactly `s * h`); `min_scale` below 0.05 clamped to
  0.05 and above 1.0 clamped to 1.0 (1.0 absorbs nothing, so the take lengthens by the whole extra); the `absorb_s`
  window (a slow interval starting at or after `key_times[k + 1] + absorb_s` absorbs nothing); a slow-but-not-slow-enough
  interval (`travel/h >= hold_mps`) absorbs nothing; a later STRETCHED interval is never compressed; the extra that
  cannot be absorbed lengthens the take by exactly that much; no output key earlier than its input key.
- `map_time`: before the first key -> `t`; after the last -> shifted by the last difference; inside an interval ->
  the linear formula; on a key time; sizes differing or empty -> `t`.
- `apply`: build an `Animation` with a `TYPE_ROTATION_3D` track, a `TYPE_POSITION_3D` track and a `TYPE_VALUE` track,
  keys at the example's old times (use `rotation_track_insert_key`, `position_track_insert_key`, `track_insert_key`),
  `length` 0.4; after `apply` with the example's old/new times: every key's time equals `map_time` of its old time,
  every key count and value is unchanged, keys stay in ascending order, and `length` is `map_time(old, new, 0.4)`.

## Send

`python Tools/agent_comms.py send --from codex --to claude --topic C126-ready --body "test written, not run"`. Do not edit
any other file.

## The trap

A blind test that agrees with nothing is worthless, and one that cannot fail is worse: Claude will break the module 5-8
ways (drop the spike-ratio test, use the larger neighbour instead of the smaller, forget the `min_scale` clamp, absorb
from stretched intervals, ignore `absorb_s`, map keys but not `length`, shift `out[0]`) and every break must turn at least
one of your checks red.
