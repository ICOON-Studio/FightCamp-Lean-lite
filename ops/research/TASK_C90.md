# TASK C90 — CODEX — THE COLOURS THAT ESCAPED THE TOKENS

Model: gpt-5.6-luna, **medium effort — never high**. Owner: codex.
Test tier: **RESEARCH — no `.gd` file is touched.** NO parse gate, NO test, and
do NOT run the suite. `git status -s` before you stage is the whole check.

## Owned files

- `research/C90_COLOUR_ESCAPES.md` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit any `.gd` file, `HANDOFF.md`, or any other research
file.

## Why this exists

`Godot/scripts/UITokens.gd` opens by saying what it is for:

> ONE source of truth for colour, type and size. Every screen that copied colour
> constants from another screen is the reason quality drifted; from this stage on
> a screen reads these and nothing else.

A material and elevation layer has just landed in the kit, and it reaches a
screen only through the tokens. **A colour written as a literal in a screen
cannot inherit any of it** — it will not lift with its tier, it will not take the
rim, and it will sit at whatever it was typed as while everything around it
moves. Before we spend the ladder across the remaining screens we need to know
where those literals are.

This is a **counting and locating job, not a fixing job.** Change nothing.
Recommend nothing. Do not judge whether a given literal is justified — several
certainly are, and saying which is not your call here.

## What to find

Every colour literal in **`Godot/scripts/*.gd`**, in these forms:

- `Color("#rrggbb")` and `Color("#rrggbbaa")` — hex strings
- `Color(r, g, b)` and `Color(r, g, b, a)` — float components
- `Color.RED`, `Color.WHITE`, `Color.BLACK` and any other named Godot constant

**Exclude `Godot/scripts/UITokens.gd` itself** — that file is *supposed* to be
nothing but colour literals; that is the point of it. Count it separately and
report it on its own line so the exclusion is visible rather than silent.

## The deliverable

`research/C90_COLOUR_ESCAPES.md`, with four sections.

### 1. Method

State the exact patterns you matched, the raw match count and the filtered count.
A census whose method is not stated cannot be checked.

### 2. Per-file table

One row per script containing at least one literal:

| script | hex | float | named | TOTAL |

Sorted by TOTAL descending.

### 3. Every call site

One row per literal, across all files:

| script:line | form | the literal as written | the enclosing line, trimmed |

Copy verbatim. Do not evaluate, normalise, or convert between forms.

### 4. The near-misses

This is the part that matters most, and it is still mechanical. For each **hex**
literal, check whether that exact hex string also appears in `UITokens.gd`. List
every literal that does — those are places where a screen wrote out a colour the
tokens already define, by hand, and they are the clearest cases of the drift the
tokens exist to stop.

Give the count, and a table:

| script:line | the literal | the UITokens constant with the same value |

Do **not** attempt this matching for float-component or named forms — converting
between representations is where a mechanical audit starts inventing things.
Say plainly in the file that you did not, and why.

## The gate

None. No `.gd` file is touched, so there is no parse gate and no test to run.
**Do not run `python Godot/tools/run_tests.py`** — the suite takes twenty
minutes and nothing you do here can affect it.

## Definition of done

- The file exists with all four sections.
- `git add -- research/C90_COLOUR_ESCAPES.md`, commit, push.
- One line back:
  `python Tools/agent_comms.py send --from codex --to claude --subject C90-done --body "<sha> files=N literals=M exact_token_dupes=K"`

## The trap specific to C90

**`Color` appears in type annotations and parameter defaults far more often than
it appears as a literal.** `gym: Color = T.GYM_DEFAULT`, `-> Color`,
`var bg: Color = T.PANEL` are all references to a token and are NOT escapes —
counting them would drown the real finding in noise and make the whole census
useless. Match only a `Color(` that is immediately followed by a quote or a
digit, plus the `Color.NAME` constants. Show the raw-versus-filtered counts so
the size of that exclusion is visible.

Second trap: `UIKit.gd` is 7,400 lines. **Never open it whole.** Use `grep -n`
to find the lines and `sed -n 'A,Bp'` to window the ones you need to read.
