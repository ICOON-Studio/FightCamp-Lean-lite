# TASK U54 — CURSOR — THE HERO BAND RAN OUT OF ROOM

Model: Composer, medium effort. Owner: cursor.
Test tier: **A SCRIPT IS EDITED** — parse gate, then the focused test, then the
named subset. Do NOT run the full suite; it is Claude's, once, at integration.

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd
python Godot/tools/run_tests.py --only profile_revamp
python Godot/tools/run_tests.py --only athlete_profile
python Godot/tools/run_tests.py --only office_nav_and_profile_overlay
```

## Owned files

- `Godot/scripts/ProfileRevampPanel.gd` — yours for this task.

Nothing else. Do not edit `UIKit.gd`, `UITokens.gd`, `HANDOFF.md`, or any test.

## Why this exists

The fighter profile's hero band has **two text collisions on screen right now**,
in a build the operator can run. They are not a style opinion — glyphs are drawn
on top of other glyphs and the result is unreadable.

They are a CAPACITY regression, not a styling one. The band was laid out on
2026-09-05 and read cleanly then (`DesignLibrary/screens/profile_revamp/overview.png`
is that render, and it is clean). Content has been added to those lines since —
a form-trend chip, the fighter's city, a seventh attribute, a peak-years line —
and the absolutely-positioned Labels and chips now run into each other. This
codebase positions UI explicitly rather than with containers, so nothing pushed
anything aside; they simply overlap.

**Reproduce it yourself before you change anything.** Render the screen and look:

```
Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/render_profile_revamp.gd -- "../previews/u54/before"
```

That is WINDOWED, not headless — do not add `--headless`, the tool needs a real
viewport to capture. The `--` argument is an output directory; use it. **Never
render into `DesignLibrary/screens/profile_revamp/`** — that is the approved
reference this work is judged against, and overwriting it destroys the only
thing that shows what "clean" looked like.

## The two defects

### 1. The identity line collides with the trend chip and the points chip

In the render, reading the band under the fighter's name:

- The `RISING` chip is drawn **on top of** the `AGE 25  ·  LIGHTWEIGHT  ·  ...`
  line, covering the separator between the age and the division.
- `172 CM` on the line below is **partly hidden behind** the `55 PTS` chip.

### 2. The form captions are drawn on top of each other

Under the three form pips (W / L / W) in the hero band, the three result
captions render as a single unreadable run — `SUBMISSIONKO` — because `SUB`,
`UD` and `KO` are being placed at x positions that overlap. **The same defect
appears a second time** in the SHAPE & FORM panel lower on the screen, under
`FORM · LAST FIVE`. Fix both; they are likely the same helper.

## What a fix looks like

Find where each of these is positioned and give the line the room it needs. The
judgement is yours, but two rules bound it:

- **Do not shrink type to make it fit.** There is a standing ruling in this
  codebase that fonts must always be clearly readable, and `UIKit.label` enforces
  a floor — text under `UITokens.SIZE_MIN` does not exist here. Solve it with
  position, with width, with wrapping onto the line below, or by moving a chip,
  never by going smaller.
- **Do not change what the band SAYS.** Every one of those figures is there
  because someone asked for it. Re-flow them; do not delete a field to make room.

Note that a `Label` outside a Container does not autowrap reliably in this
codebase — break lines with an explicit `\n` rather than trusting
`autowrap_mode`.

## Definition of done

- Render again into `../previews/u54/after` and confirm by looking
  that both collisions are gone and nothing new overlaps.
- The three named tests pass. `failures=0` is a **ceiling, not an exact count**:
  if you find and fix something else that was failing, say so and push the better
  result.
- Commit the script. You may also commit the `after` render.
- One line back:
  `python Tools/agent_comms.py send --from cursor --to claude --subject U54-done --body "<sha> collisions fixed=N tests=pass"`

## The trap specific to U54

**The hero band has two layouts, not one.** The panel collapses the hero to a
56 px identity strip on the SKILLS & MOVES and DEVELOPMENT tabs so the work gets
the height. A fix that only moves things in the tall layout will leave the strip
broken, or vice versa. The render tool writes nine views — check `skills.png` and
`development.png` as well as `overview.png`, and say in your report that you did.
