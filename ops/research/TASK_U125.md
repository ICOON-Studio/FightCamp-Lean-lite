# TASK_U125 — One weight-class list, loaded once

**Owner:** cursor
**Model:** `composer-2.5`, medium effort
**Launch:** `-p --force --trust --model composer-2.5 --workspace <worktree>`
**Test tier:** parse gate on every touched `.gd`, then `run_tests.py --only weight`,
SEPARATELY `--only rank`, `--only booking`, `--only athlete`. **`--only` DOES NOT
STACK** — one per invocation, and read `total=` to confirm how many ran.
**Then the FULL SUITE once at the end**, because this touches `GameState.gd`
which everything reads.

## The defect, found by Q127 and not yet verified by me

> `GameState.gd`'s `WEIGHT_CLASSES` has **four** entries; every other module that
> names weight classes has **eight, nine or ten**. The rankings board shows eight
> tabs; **four of them are permanently empty** for every fighter the career
> generator produces. This is silent, structural, and has been shipping.

**VERIFY IT FIRST AND SAY WHAT YOU FOUND.** Q127 was a read-only census by
another agent and I have not confirmed it. If the counts differ from what it
reported, report the real numbers and carry on — the fix is the same shape
either way. If the defect does NOT exist, say so and stop; that is a good
outcome, not a wasted task.

## The fix

**One source of truth: `weight_classes.json` (the authoritative data file).
Load it once. Delete every hardcoded list.**

Find every place that enumerates weight classes:

```bash
grep -rn "WEIGHT_CLASS\|weight_class" Godot/scripts/ Godot/scenes/ Godot/assets/data/ | grep -v "\.import"
```

For each one decide: does it need the full list (then read the data file), or is
it a genuine subset with a reason (then keep it and **comment why**, naming the
reason in the code). A subset with a stated reason is fine; a subset by accident
is the bug.

## The rule that governs this

**A gate that learns its allowed values from the thing it is grading cannot
fail.** This project has shipped that defect at least twice, and your own U124
census is about exactly it. So when you add a test here, **do not derive the
expected class list from `GameState`** — derive it from `weight_classes.json`
and assert `GameState` matches. The data file is the reference; the code is the
subject.

## What success looks like

- One enumeration, loaded from data.
- The rankings board shows a populated tab for every class the career generator
  can produce — **prove this with a number**, not an assertion: print how many
  classes have at least one ranked fighter after a generated career.
- A test that would have caught the original defect. Watch it FAIL against the
  old constant before you believe it.

## Owned files

- `Godot/scripts/GameState.gd` — **14,832 lines. NEVER OPEN IT WHOLE.** `grep -n`
  for `WEIGHT_CLASSES` and read `sed -n 'A,Bp'` windows around each hit.
- Whatever other scripts the grep implicates — list them in your digest.
- `Godot/tests/weight_class_unification_test.gd` — CREATE.
- `research/U125_DIGEST.md` — CREATE.
- **Do NOT touch** anything under `FightPoseSolver`, `PairedStagePlayer`,
  `FightWorldLive*` or `Fighter*` rigs — a 3D track is running in parallel and
  those are its files.

## Gate, as a CEILING never an exact count

Full suite **`fails=6` or better**, and the six are named: `athlete_development`,
`fight_pair_live` (PARKED on purpose), `fight_scoring`, `fight_stage_realism`,
`weight_cut` (PRE-EXISTING, controlled) and `fight_metres` (slow, times out
under `--jobs 6`, passes alone in ~9 min). **If you land lower than six, say so
and push** — over-delivery is never trapped here.

**The exit code alone is NOT a pass.** A GDScript runtime error leaves rc=0, so
read the output: `SCRIPT ERROR` lines, or your own `checks=` line missing, is a
failure regardless of rc. rc=124 is a hang — suspect a parse error.

Run the suite with `--jobs 6` (16 logical cores; the operator stopped a `--jobs 8`
run on thermals).

## When done

Commit and push your branch, write `U125_DIGEST.md`, and send one line:

```bash
python Tools/agent_comms.py send --from cursor --to claude --subject u125-ready --body "<one line>"
```

**Do NOT edit `HANDOFF.md`.** Stage explicit paths only; check `git status -s`
first — another agent's WIP may be pre-staged and a path-limited add can still
sweep it in.

## The trap specific to this task

**`weight_cut` is already a known-failing test and it is about weight.** Do not
"fix" it as part of this — it is pre-existing and controlled, and conflating the
two will make your result unreadable. If your change moves it either way, say so
explicitly and separately.
