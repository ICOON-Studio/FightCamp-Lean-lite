# TASK C89 — CODEX — THE SURFACE CENSUS

Model: gpt-5.6-luna, **medium effort — never high**. Owner: codex.
Test tier: **RESEARCH — no `.gd` file is touched.** NO parse gate, NO test, and
do NOT run the suite. `git status -s` before you stage is the whole check.

## Owned files

- `research/C89_SURFACE_CENSUS.md` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit any `.gd` file, `HANDOFF.md`, or any other research
file.

## Why this exists

An elevation ladder just landed in the interface kit: five tiers, `SUNK`,
`FLUSH`, `RESTING`, `LIFTED`, `HERO`. The rule we are applying is the one every
commercial dashboard follows — **one hero per screen, a few supports, everything
else quiet.**

Right now almost every surface in the game sits at the default tier, which is
what made twelve cards weigh the same. Before we can spend the ladder across the
other screens we need to know what is actually there. **This is a counting job,
not a design job.** Do not propose tiers, do not change anything, do not
editorialise about what looks good. Count.

## What to count

Every call to these six kit factories, across **every `.gd` file in
`Godot/scripts/`**:

- `UIKit.block(` / `K.block(`
- `UIKit.surface(` / `K.surface(`
- `UIKit.frame(` / `K.frame(`
- `UIKit.track(` / `K.track(`
- `UIKit.raised_style(` / `K.raised_style(`
- `UIKit.modal(` / `K.modal(`

Note the kit calls several of these unqualified from inside `UIKit.gd` itself
(`block(`, `raised_style(`) — count those too, and mark that file separately,
because a call inside the kit reaches every screen rather than one.

## The deliverable

`research/C89_SURFACE_CENSUS.md`, containing exactly three things.

### 1. The per-file table

One row per script that calls any of them. Columns:

| script | block | surface | frame | track | raised_style | modal | TOTAL |

Sorted by TOTAL, descending. This tells us which screens are surface-heavy and
therefore where the flatness is worst.

### 2. The per-call-site table for the TOP TEN files only

For each of the ten heaviest files, one row per call site:

| script:line | factory | size argument as written | colour argument as written | tier argument if any |

Copy the arguments **verbatim from the source**, including expressions like
`Vector2(WIDTH, HERO_H)` or `T.PANEL_GLASS`. Do not evaluate them, do not
normalise them, do not guess what a constant resolves to. If a call spans
several lines, give the line the call starts on.

### 3. Three counts, stated plainly

- How many total surface call sites exist across the whole tree.
- How many of them pass an explicit `level` / tier argument (the last positional
  argument on `block`, or the third on `surface`).
- How many pass an explicit `light` value rather than leaving the default.

## The gate

None. No `.gd` file is touched, so there is no parse gate and no test to run.
**Do not run `python Godot/tools/run_tests.py`** — the suite takes twenty
minutes and nothing you do here can affect it.

## Definition of done

- The file exists with all three sections.
- `git add -- research/C89_SURFACE_CENSUS.md`, commit, push.
- One line back:
  `python Tools/agent_comms.py send --from codex --to claude --subject C89-done --body "<sha> files=N sites=M with_tier=K"`

## The trap specific to C89

**A grep for `block(` also matches `_build_block(`, `unblock(`, and any local
function whose name ends in `block`.** Anchor on the qualified forms
(`UIKit.block(`, `K.block(`) plus, inside `UIKit.gd` only, a call at the start of
an expression. Say in the file which pattern you used, and give the raw match
count alongside the filtered one so the difference is visible. A census whose
method is not stated cannot be checked, and this one exists precisely so that
somebody can check it.
