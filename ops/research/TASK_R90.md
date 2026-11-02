# TASK R90 — CLAUDE — THE GRAPPLE ARC CONVERGES: MERGE U26 AND LET THE BLIND TEST RUN

Model: **Opus, high effort, Fast mode off.** Owner: Claude. Base: `master` at
`a7b4efc`, `SUITE total=213 fails=1`.

---

## Why this exists

Four agents built grappling from one contract without reading each other's
code, and tonight all four halves exist for the first time:

* `G34_GRAPPLING_CONTRACT.md` — Grok, the contract everything was typed from.
* `Godot/scripts/GrappleSeat.gd` + `grapple_seat_test.gd` — Qwen (Q19), on
  master at `6e76cff`, 99 checks passing.
* `Godot/scripts/GrappleResolve.gd` + `grapple_resolve_test.gd` — Cursor
  (U26), **on the branch `cursor/u26-grapple-resolve-fb05` at `e5f5f41`**,
  not on master.
* `Godot/tests/grapple_contract_test.gd` — Codex (C67), written blind, red by
  design because `GrappleResolve.gd` is absent.
* `G35_REFEREE_AND_METHODS.md` — Grok, the fifth method and the stall clock,
  landed 2026-09-10.

**The blind contract test has never actually run.** The moment U26 is merged
it stops being a placeholder and becomes the gate on all of it, and whatever
it says then is the most informative single fact available about this arc.

## What to do

1. **Merge `cursor/u26-grapple-resolve-fb05` into master.** Cursor pushed to a
   branch again and the mail rode the branch, so nothing about this arrived in
   the master inbox — check `git branch -r` and `agent_comms.py triage`, never
   the inbox alone, for anything else of Cursor's sitting unmerged.
   Audit the branch **blob by blob**, never by ancestry: the branch's own
   `grapple_contract_test.gd` may be a stale copy of Codex's file, and merging
   Cursor's version over a newer one would silently revert C70.
2. **Run `grapple_contract_test.gd` for real** and report exactly what it says.
3. **Reconcile the disagreements**, and *reconcile* is the operative word.
   A blind test that disagrees with a module is evidence about **one of the
   two**, and which one is a judgement that comes from `G34`, never from
   whichever file is easier to change. **Never "fix" a red assertion by
   retuning it to match the module** — that is the R85 lesson about re-pinning
   a card, one level up.
4. **Two disagreements are already known and neither is yours to assume away:**
   * Qwen resolved the `half` hold-ticks ambiguity to **60**, not the 20 the
     Q19 task table implies, and reported it "aligned with C67's blind test."
     Decide it from G34 §2 and say which reading is right.
   * `grapple_contract_test.gd:92` has a precedence defect
     (`not X == false`) that makes its clinch/over_under dominance assertion
     untestable. **Codex owns that file as C70 and is repairing it in
     parallel** — do not edit it. If C70 has already landed, say so and run
     what it left.
5. **Report the arc's state honestly**, including what the contract test could
   NOT exercise.

## What is explicitly NOT in this stage

**Do not wire grappling into `FightRealtime.gd`.** The engine integration —
seats advancing per tick, control units reaching the judges, the stall clock,
`METHOD_SUBMISSION` — is the next stage and it is big. This stage ends with
the modules on master, the blind test green or honestly explained, and the
integration specified rather than started. Starting it here would put a
half-integrated engine behind a stage that was supposed to be a merge.

**Do not touch `grapple_contract_test.gd`** (C70, Codex) or
`ProfileRevampPanel.gd` (U27, Cursor).

## Owned files

| File | Note |
| --- | --- |
| the merge itself | Yours. |
| `Godot/scripts/GrappleSeat.gd`, `GrappleResolve.gd` | Yours to CORRECT only where G34 proves them wrong, with the reason recorded. |
| `research/R90_DIGEST.md` | New. |

`GameState.gd` is **14,766 lines** and this stage should not need it at all —
never open it whole.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py <every .gd you touched>
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_seat_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_resolve_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0` is the target now that the missing
module has landed. If it comes back higher, that is a real contract
disagreement and the finding is the deliverable — report it, do not tune it
away. Run the full suite ONCE, in the background, before the commit, and read
the runner's own `SUITE` line: the exit code alone is not a pass (R75).

## Done

Commit, push `master`, write `research/R90_DIGEST.md` — short, and
carrying the blind test's verdict plus every disagreement and which side G34
decided for. Write the Claude, Cursor and Codex `HANDOFF.md` blocks, regenerate
`TASKS.md`, and end the session with the report.
