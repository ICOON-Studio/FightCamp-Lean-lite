# TASK Q22 — QWEN — GrappleAdapter.gd: THE FOLD, AND THE ONE RULESET IT REFUSES

Model: Qwen default, `--yolo`. Owner: Qwen. Base: `master` after C71.
Assigned 2026-09-10. **One task. Do it and stop.**

---

## Why this exists

Four agents built grappling from one contract and all of it is **inert** —
nothing calls `GrappleSeat.gd` or `GrappleResolve.gd`. R91 (Claude) wires them
into the live fight. The piece between the engine and the judges is the
**adapter fold**: the engine emits one neutral vocabulary, and each ruleset
reads it its own way.

`G37_THE_ADAPTER_FOLD.md` (Grok, 101 sources, current rulebooks) has already
done the research. **You are typing its tables into a pure module.** You are
not deciding what judo scores; G37 decided, from the IJF SOR.

## The contract — exact names, because an unseen test may call this

```gdscript
# Godot/scripts/GrappleAdapter.gd — statics only, ZERO preloads.
static func rulesets() -> Array                      # ["ijf","uww","ibjjf","abc"]
static func scores_grappling(ruleset: String) -> bool
static func award(ruleset: String, event: Dictionary) -> Dictionary
static func hold_gates_seconds(ruleset: String) -> Dictionary
static func advantage(ruleset: String, situation: Dictionary) -> int
static func stall(ruleset: String) -> Dictionary
static func submission_meaning(ruleset: String) -> String
```

* `award()` returns `{"kind": <String>, "points": <int>, "counter": <String>}`.
  **`points` is `-1` when the ruleset does not score that emission** — never
  `0`, which would claim "scored, worth nothing". `kind` is `"not_scored"`
  in that case.
* Unknown ruleset or unknown event: return the refusing shape, never crash.
* Discipline and event strings are lowercase snake_case, exactly as G34 lists
  them: events `clinch_engage`, `clinch_break`, `takedown`, `throw`,
  `position_change`, `exposure`, `step_out`, `submission_attempt`; seats
  `none`, `over_under`, `guard`, `half`, `side`, `mount`, `back`.

## What to build, all of it from G37

1. **The four conversion tables** — G37 §1.A judo, §1.B freestyle wrestling,
   §1.C BJJ, §1.D MMA. Type them as data, not as branching code.
2. **`hold_gates_seconds`** — G37 §2. `ijf` is `{"yuko":5,"waza_ari":10,
   "ippon":20}`; `ibjjf` is `{"score":3}`; **`uww` and `abc` are EMPTY
   dictionaries, because G37 found none published.**
3. **`advantage()` — IBJJF only.** G37 §3 gives the exact trigger: a scoring
   seat reached, the 60-tick gate NOT completed, and the sequence over. Plus
   a submission attempt that did not finish. Every other ruleset returns 0.
   **Do not add an advantage counter for anyone else.**
4. **`stall()`** — G37 §5. Per ruleset, seconds and consequence. `abc` has no
   published seconds; say so in the returned shape rather than inventing one.
5. **`submission_meaning()`** — G37 §6. Note UWW: freestyle has **no
   submissions at all**, so it must never return a finish.

## THE REFUSAL, and it is the point of this task

**`step_out` must return "not scored" for EVERY ruleset, including UWW.**

G37 §4 proves a 1-D ring cannot produce an honest UWW step-out: the engine
tracks a scalar separation, while a step-out is a 2-D boundary fact about who
crossed the line first. `separation > RING_RADIUS` is a **wall-walk**, which
fires when two men separate — the opposite of a wrestler being driven off the
circle.

UWW's rulebook does award 1 point for a step-out. **You are still refusing it**,
because we cannot detect it honestly, and a plausible-looking wrong number is
worse than an absent one. This is the same structural refuse R85 already
applied to taekwondo. **If you "helpfully" implement it, you have failed the
task** — put the reasoning in a comment so the next reader does not re-add it.

## Owned files

| File | Note |
| --- | --- |
| `Godot/scripts/GrappleAdapter.gd` | New. **ZERO preloads** — it must be testable standalone. |
| `Godot/tests/grapple_adapter_test.gd` | New. Yours, module and test together — you have the shell to run it. |
| `research/Q22_DIGEST.md` | New. Short. |

**Read `research/G37_THE_ADAPTER_FOLD.md` whole — it is your source.**
Read `G34_GRAPPLING_CONTRACT.md` §1, §2 and §8 only if you need the exact
vocabulary; `sed -n` those sections, do not read it whole.
**Do NOT read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest. **`GameState.gd` is 14,769 lines — never open it**; this task
does not touch it. **Do NOT touch** `FightRealtime.gd` (Claude, R91),
`GrappleSeat.gd` or `GrappleResolve.gd`.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/GrappleAdapter.gd Godot/tests/grapple_adapter_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_adapter_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`. Another agent may be running Godot
at the same time — a suite line claiming everything failed is contention, so
re-run rather than panic.

## Done

Commit, push `master`, write `research/Q22_DIGEST.md`, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic "Q22-done" --body "<commit> <suite line> <anything G37 left ambiguous>"
```

`agent_comms.py` writes the mail file but does **not** stage it — `git add` it
into your commit. Stage explicit paths only; this checkout is shared and other
agents are working in it. Do NOT edit `HANDOFF.md`.

## The trap specific to this task

**`points: 0` and `points: -1` are different claims and the tests will care.**
`-1` means "this ruleset does not score that emission at all"; `0` means "it
scored and was worth nothing". G37's tables are full of "not scored" entries —
every one of them is `-1`. The same discipline applies to `hold_gates_seconds`
for `uww` and `abc`: an **empty dictionary**, not a dictionary of zeros. This
is the identical rule that governs `MINIMUM_WEEKS` in `GradeLadder`, and it is
the third time it has come up: **absence is a finding, zero is a claim.**
