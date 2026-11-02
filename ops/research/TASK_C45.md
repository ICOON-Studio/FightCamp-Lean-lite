# TASK C45 — CODEX — THE ASSETS NOBODY IMPORTED

Model: mid tier, effort **medium**, Fast off. One session. Infrastructure.

## Why this exists

R63 tried to draw a body figure on the BODY LAB and drew nothing. The art was
there — Kalli shipped `Godot/assets/ui/body_muscle_map_front.png` and six
region cut-outs on 2026-09-06 in `f7109d5`. The reason nothing appeared is
that **`Godot/assets/ui` had never been imported**. No `.import` file existed
for any of it, so `load("res://assets/ui/...")` returns `null` at runtime and
every caller silently gets nothing.

That is very likely why the art was never used: someone tried, got nothing, and
moved on. It is a trap with no error message.

Running `godot --headless --path Godot --import` generates them — **about 1,150
files**, currently sitting untracked in the working copy. R63 committed exactly
one, the cut-out it needed. The rest are undecided, and undecided is the worst
state: the next person either commits 1,150 files in a stray `git add -A` or
hits the same silent null.

## Your job is the decision, then the follow-through

1. **Audit.** How many assets under `Godot/assets` have no `.import`, by
   folder and type? Which of them are actually referenced from a `.gd` or
   `.tscn`, and which are unreferenced files nobody loads? A referenced asset
   with no import is a live bug; an unreferenced one is only clutter.
2. **Decide, and write the decision down** in
   `research/C45_ASSET_IMPORT_POLICY.md`: are `.import` files committed
   (Godot's own default, and 36 of them already are), or regenerated, with the
   regeneration step documented where a new agent will actually read it? Give
   the reasoning, not just the verdict. `Godot/.gitignore` currently ignores
   `.godot/` only, so the tracked-`.import` reading is the one the repo is
   already half living with.
3. **Land it.** Whatever you decide, leave the repo in that state — including
   whatever `.gitignore` change it implies. If the answer is "commit them",
   stage them deliberately, not with `git add -A`.
4. **Make the failure loud.** Add a check to `Godot/tools/check_scripts.py`, or
   a small sibling tool, that scans `.gd` and `.tscn` for `res://assets/...`
   string literals and reports any that do not resolve to a file with an
   `.import` beside it where one is required. A silent `null` at runtime should
   become a line of output before anyone runs the game.

## Owned files

- `research/C45_ASSET_IMPORT_POLICY.md` (new)
- `Godot/tools/check_scripts.py` (111 lines) or a new tool beside it
- `Godot/.gitignore`
- Whatever `.import` files your decision commits

## NOT yours

- **`Godot/scripts/ProfileRevampPanel.gd` — Cursor holds it under U10.**
- Any `.gd` under `Godot/scripts`. This is a pipeline task; if you find a
  script whose asset path is wrong, **report it, do not fix it.**
- `Godot/assets/**` content. Do not re-export, re-compress or delete art.
  `body_muscle_map_front_cutout.png` is R63's derived cut-out and is correct.

## Refusals

- **No asset deleted** because it looks unreferenced. `TechniqueGlyphs`,
  `IconKit` and `UIKit` build paths at runtime, so a grep for a literal path
  will miss real callers. Anything you cannot prove is unused is `UNKNOWN` and
  stays.
- **No new art.**
- **No `git add -A`.** The whole point of this task is that 1,150 untracked
  files are one careless stage away from the history.

## Gate, then tests

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd
```

(and your new check against itself — it must not fire on a clean tree)

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

Then the full suite ONCE in the background before the commit. **Ceiling, not a
target: 175/175 or better; if it is better, say so and push.**

## The one trap

`Godot/assets` is large and the repo is 1.7 GB. **Do not commit a binary you
generated** — the only new files this task may add are `.import` text files, a
markdown policy, and tool code. If your audit wants to record a list, record it
in the markdown, not as a dumped file.

## Done means

Committed and pushed, `C45_ASSET_IMPORT_POLICY.md` written, one line back with
`agent_comms.py send`, and **no `HANDOFF.md` edit** — Claude writes your block.
