# TASK C68 — CODEX — THE CUT IS PRICED WHEN THE BOUT IS ACCEPTED, NOT AFTER

Model: GPT-5, high effort, Fast off. Owner: Codex. Base: `a54b3ff`,
`SUITE total=210 fails=1` — the one is **your own C67**, red by design until
`GrappleSeat.gd` and `GrappleResolve.gd` land. It is not yours to fix here.

---

## Why this exists

The operator ruled the career flow on 2026-09-10: a bout contract is arranged,
the fighter chooses camp or gym, and **then** weight-cut options are offered.
Read literally that is one step out of order — **the weight class is fixed the
moment the contract is accepted**, so a player can accept a fight his man
cannot make and find out at the weigh-in, when the only remaining answers are
`emergency`, `accept_miss` and `withdraw`.

The arithmetic already exists and is already composed correctly — **once**.
`DoubleChamp.can_make_limit` (`scripts/DoubleChamp.gd:62`) folds
`WeightCut.limit_for` + `WeightCut.status` + `WeightCut.projection` into a
yes/no for a superfight, and it is the **only** place in the game that
composition happens. Every ordinary bout goes through `book_fight`
(`GameState.gd:10285`) and asks the scale nothing at all.

## What to build

**A READ, NOT A REFUSAL.** One new GameState function, and `book_fight`
carrying its verdict on the dictionary it already returns.

```gdscript
func get_weight_read(athlete_id: String, weight_class: String, family: String, weeks_out: int) -> Dictionary
```

Contract — exact names, an unseen test will call it:

```
{
  "limit": float,           # WeightCut.limit_for, 0.0 when the class is unknown
  "walk": float,            # his walk-around weight
  "weight": float,          # what he is now
  "over_by": float,         # weight - limit, never negative; 0.0 when already under
  "makes_it": bool,         # the default plan's projection reaches the limit
  "plans": Array,           # one row per WeightCut.diet_plan_ids():
                            #   {"id": String, "projected": float, "makes_it": bool}
  "weeks_out": int,         # as passed, floored at 1 the way can_make_limit floors it
  "band": String,           # "under" | "routine" | "hard" | "dangerous" | "impossible"
  "evidence": String,       # "sourced" | "unknown" - never invent a figure
}
```

`book_fight` gains one key on its existing return — `"weight_read"` — and
**changes no other behaviour whatsoever**.

The five bands are yours to author off `over_by` as a fraction of `limit`, and
the digest must state the cut points and say they are authored. `WeightCut`
already carries `night_penalty(cut_fraction)`; use its shape as the anchor for
where "dangerous" begins rather than inventing a second opinion about the same
fraction.

## The three traps, in order of how much they would cost

1. **DO NOT FORK A SECOND COMPOSITION.** `can_make_limit` does this arithmetic
   today. Lift the shared part into one place and have `DoubleChamp` keep
   answering **exactly** what it answers now — its superfight behaviour is
   wired into `GameState.gd:11116`-`11164` and must not move by a gram. If the
   cleanest lift changes a `DoubleChamp` answer anywhere, stop and report it
   rather than accepting the new number.
2. **DO NOT REFUSE THE BOUT.** This is R72's lesson and it cost a stage:
   C51 made `book_fight` refuse on an unknown-provenance medical hold, unknown
   turned out to be nearly every hold, and it repealed the whole commission
   model in one commit. A read a screen can show is the deliverable. **Whether
   a bout is ever refused for weight is the operator's call and is not in this
   task.**
3. **A missing walk weight is UNKNOWN, not 0.0.** `evidence` is the field that
   says so. A fighter with no walk figure must come back `"unknown"` with
   `makes_it` false, never a confident projection off a zero.

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/GameState.gd` | 14,386 | Owned. **NEVER whole.** `book_fight` `:10285`; the superfight caller `:11116`–`:11164` for context only. |
| `Godot/scripts/WeightCut.gd` | 248 | Owned for this task. Read whole — it is small. |
| `Godot/scripts/DoubleChamp.gd` | ~90 | Owned for this task. Read whole — it is small. |
| `Godot/tests/weight_read_test.gd` | new | Yours. |
| `research/C68_DIGEST.md` | new | Yours. Short. |

**Do NOT touch** `FightContractScreen.gd` or `OfficeHubPanel.gd` — Cursor holds
both under U27, queued behind U26. **Do NOT read** `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore to
get oriented.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/WeightCut.gd Godot/scripts/DoubleChamp.gd Godot/tests/weight_read_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/weight_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/double_champ_test.gd
python Godot/tools/run_tests.py
```

`double_champ_test.gd` is the one that proves trap 1 held.

**CEILING, NOT AN EXACT COUNT.** `fails=1 or better` — the one being C67's
until its two modules exist. **If it is better than that, say so and push.**
The exit code alone is not a pass (R75): read the runner's own `SUITE` line.

## Done

Commit, push `master`, write `C68_DIGEST.md` — the band cut points, that they
are authored, and anything `WeightCut` left genuinely ambiguous — then send one
line:

```
python Tools/agent_comms.py send --from codex --to claude --topic "C68-done" --body "<commit> <suite line> <band cut points> <did the DoubleChamp lift move anything>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

**Report ambiguities rather than resolving them silently.**
