# TASK R91 — CLAUDE — THE GRAPPLE REACHES THE FIGHT

Model: **Opus, high effort, Fast mode off.** Owner: Claude. Base: `master`
after R90, C70 and U27.

---

## Why this exists

Four agents built grappling from one contract and all four halves are on
master. **Every one of them is inert.** Nothing in `FightRealtime.gd` calls
`GrappleSeat.gd` or `GrappleResolve.gd`; the five counters G34 §8 specifies
have writers named and no writer.

This is the tenth piece of unreachable code this area has shipped, and the
project has a standing lesson about exactly that: **three separate defects were
once found that were all code which was correct, tested, and could never run.**
Assert that a feature OCCURS, not that it is permitted.

R91 is the stage that makes it occur.

## What to do

1. **Seats advance on the tick.** `advance_tick` (`FightRealtime.gd:439`)
   already dispatches through `TickBudget.due_on()` (`:465`). Grapple attempts
   resolve on the `decision` cadence (every 10 ticks at 20 Hz) and control
   accrues on `scoring` (every 20) — G34 §8's closing lines, not a new cadence.
   **Do not add a fifth stream to the RNG.** Determinism is proven by a replay
   test and seven draws per built impact is asserted; adding an unbudgeted draw
   silently breaks byte-for-byte replay.
2. **Control units reach the judges.** `U22`'s `RealtimeRoundStats` is the
   existing adapter onto R38's judges; the five counters
   (`takedowns_round`, `throw_points_round`, `position_points_round`,
   `submission_attempts_round`, `control_score`) fold in there, not in the core.
   `_close_round` is `:570`.
3. **The stall clock**, per `G35_REFEREE_AND_METHODS.md`.
4. **`METHOD_SUBMISSION`** joins the four existing stoppage methods
   (`:135-138`) and `result()` (`:523`) must be able to return it.
5. **Prove it occurs.** Every new path needs a test that shows it FIRING in a
   real bout — a submission that finishes, a control_score that is non-zero at
   a round's close, a stall warning that is issued. A test that only proves the
   function returns the right number when called by hand is the exact pattern
   that shipped three unreachable features.

## The research this stage depends on — ALREADY LANDED

**`G37_THE_ADAPTER_FOLD.md` HAS LANDED (2026-09-10, `f422d3e`) and is the
input to step 2.** Read it before starting step 2; it is not a dependency you
are waiting on any more. Two of its answers change this stage:

* **BJJ advantages need no new event.** Its §3 gives the exact trigger — a
  scoring seat reached, the 60-tick gate not completed, the sequence over —
  and says keep advantages **adapter-local**, not a counter on the engine.
* **UWW step-out is REFUSED and you must not implement one.** Its §4 proves a
  1-D ring cannot produce an honest step-out: `separation > RING_RADIUS` is a
  wall-walk, which fires when two men separate — the opposite of a wrestler
  driven off the circle. Write `step_out` → not scored for every ruleset. Do
  not "improve" on this; the refusal is the sourced finding.

Also from G37, so you do not reintroduce them: there is **no published UWW +1
at 5 s of held exposure** (primers repeat it; the Jan 2026 bands do not carry
it), and **ABC publishes no event-to-point table at all** — the five counters
reach the MMA judges as evidence, never as points.

It answered both questions this stage could not invent: an IBJJF advantage IS
derivable from the emitted vocabulary, and a 1-D ring CANNOT produce an honest
step-out. **That second answer is a finding to respect, not a gap to paper
over** — R85 set the precedent by leaving taekwondo on the atomic engine rather
than shipping plausible numbers that were wrong.

## What is explicitly NOT in this stage

* **No new grappling module.** The four halves are written. If one is wrong,
  correct it where G34 proves it wrong and record the reason.
* **No re-pinning of the nine bouts R85 pinned.** Wiring grappling WILL move
  seeded fights that use grappling rulesets. **Re-run before assuming a
  defect, and never "fix" a red card by re-pinning it.** If a pinned card
  moves, that is a finding to report with the numbers, and the re-pin is a
  separate decision.
* **No `is_dominant`.** R90 ruled it out of the contract and C70 removed it
  from the blind test, independently reaching the same conclusion. Control is
  the 0/1/2 integral, never a flag.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/FightRealtime.gd` | 1,282 | **Never open whole.** Anchors: `advance_tick` `:439`, budget dispatch `:465`, `_run_impact` call `:480`, `result` `:523`, `_close_round` `:570`, methods `:135-138`. |
| `Godot/tests/fight_realtime_test.gd` | 1,363 | **Never open whole.** Add at the end; read `sed -n` windows only. |
| `Godot/scripts/GrappleSeat.gd` (89), `GrappleResolve.gd` (149) | | Correct ONLY where G34 proves them wrong, reason recorded. |
| `research/R91_DIGEST.md` | new | |

**`GameState.gd` is 14,766 lines** and this stage should not need it.

**Do NOT touch** `GradeLadder.gd` / `grade_progression_test.gd` (Qwen, Q21),
`grade_ladder_sourced_test.gd` (Codex, C71), `FightHudPanel.gd` (Cursor, U28),
or `grapple_contract_test.gd` (Codex) — **that last one is now the gate on this
work and must stay green without being edited.**

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py <every .gd you touched>
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_cards_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`. If a pinned card moves, report the
numbers and the seed rather than re-pinning inside this stage.

## Done

Commit, push `master`, write `research/R91_DIGEST.md`, write the HANDOFF
blocks, regenerate `TASKS.md`, end the session with the report.

## The trap specific to this task

**The replay test is the thing that will break, and it will break silently.**
`FightRealtime` proves byte-for-byte determinism by replaying a seeded stream,
and the assertion counts draws per built impact. Grappling adds decisions on a
cadence that already exists — so the moment a grapple attempt consumes a draw
from a stream the replay test does not know about, the fight still runs, the
suite still passes the parts that look at outcomes, and the replay guarantee is
gone. **Budget the draws explicitly and extend the replay assertion in the same
commit that adds them**, never afterwards.
