# TASK_U126 — CURSOR — CENSUS EVERY SCREEN WE ALREADY HAVE, AGAINST UIKit

**Owner:** cursor
**Model:** `composer-2.5`, MEDIUM. Launch `-p --force --trust --workspace <wt>`.
**Test tier:** parse gate on anything you touch, then `run_tests.py --only ui`
and SEPARATELY `--only screen`. **`--only` DOES NOT STACK** — one per
invocation, and read `total=` to confirm how many actually ran. **No full
suite.** This is a census; it should change no behaviour.

## Why this exists, in the operator's own words

> *"i thought i told you on previous session to split agents so they can improve
> visuals menus mechanics etc, is this happening?"*

It was not happening. The whole roster has been on the 3D fight for a week and
the UI track has one unsent task. This is the first half of fixing that — and it
is the half that has to come first, because **you cannot apply a house style to a
codebase nobody has counted.**

The operator also said, plainly: *"i do not know how to give the prompts to make
the game feel unique and AAA standard."* Converting that into rules is Claude's
job. Supplying the inventory those rules have to land on is yours.

## What to deliver

`research/U126_SCREEN_CENSUS.md` — a MEASURED inventory, not an opinion
piece. For every screen script in `Godot/scripts/` that builds UI:

1. **Its name, its line count, and whether it is built from `UIKit.gd` or by
   hand.** The distinction that matters: does it call UIKit helpers, or does it
   construct `Label`/`Panel`/`Button` nodes directly with its own numbers?
2. **Every hard-coded layout number it contains** — font sizes, paddings,
   margins, row heights, panel widths, colours. Grep for bare numeric literals in
   `size`, `position`, `custom_minimum_size`, `add_theme_*_override` and colour
   constructors. **Count them and give the range per kind.** An unnamed literal
   has no handle: this list is what makes them findable.
3. **Which screens disagree with each other** on the same quantity. If three
   screens use row heights of 28, 30 and 34 px, that is the finding — say which
   three and which numbers.
4. **What UIKit already offers** that a hand-built screen is re-implementing.
   This is the cheapest win in the whole track and nobody has listed it.

## The one table the operator will actually read

A single ranked table: **screen, built-from (UIKit / hand / mixed), hard-coded
literal count, worst disagreement with its neighbours.** Ranked worst first. That
is the build order for the UI track.

## Owned files

- `research/U126_SCREEN_CENSUS.md` — CREATE.
- `Godot/tools/u126_screen_census.py` — CREATE. The census must be REGENERABLE,
  not typed. A hand-typed table goes stale the first time someone edits a screen.
- `research/U126_DIGEST.md` — CREATE.

**CHANGE NO SCREEN.** This task deliberately fixes nothing. Do NOT edit
`HANDOFF.md`.

## Where to look

`Godot/scripts/UIKit.gd` is the kit. Read it whole — it is the contract every
screen should be honouring.

The screens are `Godot/scripts/*Screen.gd` and `Godot/scripts/*Panel.gd`. There
are a lot of them; your census tool should discover them rather than take a list
from me, and it should print how many it found so a later reader can tell whether
it missed a naming convention.

**`GameState.gd` is about 13,000 lines — never open it whole.** You should not
need it at all for this. If you think you do, you have drifted out of scope.

## THE TRAP THAT WOULD MAKE THIS CENSUS WORTHLESS

**Counting the files is not counting the screens the player sees.** Some scripts
in `scripts/` are dead — the operator ruled on 2026-09-05 that legacy pre-kit
scenes are DISCARDED, not migrated, so a hand-built screen may be a corpse rather
than a defect. **Cross-check every screen against whether anything actually
routes to it** (grep for its name in the navigation/router and in `scenes/`), and
mark the dead ones DEAD in their own column.

A census that ranks a discarded screen as the worst offender sends the whole UI
track at a file nobody will ever see. Say how many you found, how many are live,
and how many are dead.

## Second trap

**A `.tscn` can carry layout numbers too**, and grepping only `.gd` misses them.
Say explicitly whether your tool reads `scenes/*.tscn` as well, and if it does
not, name that as a known gap rather than letting the counts read as complete.

## Gate

```
python Godot/tools/check_scripts.py <any .gd you touched>
python Godot/tools/u126_screen_census.py
```

The census tool must run clean and print its own totals (screens found, live,
dead, literals counted). Ceiling: the tool runs and the markdown it produced
matches its output. **If the tool and the table disagree, the table is wrong.**

## Deliver

Commit on a branch, push, write the digest, and send one line with
`python Tools/agent_comms.py send --from cursor --to claude --subject u126-ready`.

**Unstage `AgentComms/messages` before you commit** — another agent's mail may be
pre-staged in this shared index and a path-limited `git add` can still sweep it.
