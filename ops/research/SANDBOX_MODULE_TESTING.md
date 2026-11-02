# Testing a pure module with Godot but no repo (Grok / Kalli / Maria / John)

**Standing reference, written 2026-09-07 after an API-side agent reported it
could not run FightCamp's tests: the repo is private, its `.git` is 1.7 GB,
and the sandbox has no git token.** All three of that report's workarounds —
a file-by-file GitHub API checkout, the operator dropping a zip, the operator
running the suite and pasting the log — are real, and none of them is needed
for the work these agents are actually given.

## The rule

**An API-side agent is never handed a task that requires the repo to test.**
If a task file hands you a `--path Godot --script tests/...` command, that is
a mistake in the task file — say so and use the recipe below instead.

- **Grok** gets pure modules only: one new `.gd` under `Godot/scripts/` and
  its test. A pure module has **no `preload`, no autoload identifier, no
  scene, no `GameState`** — so it needs nothing from the repo but itself.
- **Kalli, Maria and John** write documents and boards. Nothing to run.
- **Claude runs the parse gate and the full 149-file suite** after the push,
  and reports the result back. That has been the standing arrangement since
  Grok's first task; it is not a favour and you are not expected to wait for
  it or poll for it.

## The recipe: a throwaway Godot project holding only your two files

Anywhere writable in the sandbox — `/home/workdir/kit` will do:

```bash
mkdir -p ~/kit/scripts ~/kit/tests
cd ~/kit
cat > project.godot <<'EOF'
config_version=5

[application]

config/name="kit"
config/features=PackedStringArray("4.7", "GL Compatibility")
EOF
```

Drop your module in `~/kit/scripts/` and your test in `~/kit/tests/`, then:

```bash
godot --headless --path ~/kit --script tests/<your_test>.gd
```

**Verified 2026-09-07 on Godot 4.7.2** with exactly the `project.godot`
above, one `extends RefCounted` module and one `extends SceneTree` test:
runs clean, `res://` resolves, exit code 0.

That is the same command the repo uses, against a project that holds nothing
but your work. `res://scripts/<Module>.gd` resolves exactly as it will in the
real project, so a `load()` or `preload()` path you write here is the path
that ships.

**No autoloads.** The kit project deliberately declares none. If your module
needs one, it is not a pure module and the task is wrong — say so rather than
working around it.

## Copying in a second file you genuinely need

Only if the task names it. The dependency-free modules today are
`Godot/scripts/Sanctioning.gd`, `Godot/scripts/FightRecordStats.gd` (169
lines) and `Godot/scripts/PromotionsBoard.gd` is NOT one (it preloads the
kit). Prefer the contract that avoids the copy: **take the other module's
figures as an argument** and let the caller pass them in. A module with zero
preloads is testable everywhere, forever.

## What this recipe does not solve

- **Running the real suite.** `smoke_test.gd` and the 148 others need the
  whole project, the autoloads and the save fixtures. That is Claude's job on
  the Windows box, and it stays there.
- **A vanishing Godot install.** The container overlay is not durable. Record
  your own install recipe at the bottom of this file on your next push so it
  survives the next fresh sandbox — nobody else can write it for you.
- **Getting the repo into the sandbox.** That needs either a token or a drop
  from the operator, and it is the operator's decision, not an agent's. Do
  not ask for a token in a task report; ask the operator directly and say
  what you would do with it.

## Install recipe (fill this in)

_Empty. The agent that installs Godot in the bot environment writes the exact
steps here on its next push._
