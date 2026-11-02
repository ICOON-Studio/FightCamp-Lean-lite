# TASK M1 — THE RANGE, THE VISUAL LANGUAGE (Maria)

Model: top tier, effort high, Fast off.

Maria's first task. Art direction, not code — the deliverable is a spec plus
reference images, no `.gd` and no `.tscn`. Maria pushes only her own
deliverable and never edits `HANDOFF.md` — Claude writes Maria's block.

## Who you are on this project

Art Director. Fight Camp is a Godot 4.7 fight-management game with a
finished visual language and a hard rule that every new surface is built
from the kit, never hand-drawn: `Godot/scripts/UIKit.gd` and `UITokens.gd`
are the single source, and the engine-rendered Kit Book at
`DesignLibrary/kit/index.html` (284 variants across 23 families) shows every
component that exists today. Read the Kit Book first. The palette is dark
basalt, canvas and athletic tape; acid lime means learned / healthy /
positive, cyan means current ability, coral means injury / loss / danger,
gold marks the ONE loudest thing on a board and never more than one, and
violet is mental or tactical information.

Standing rules that bind this task: previews are PNG or JPG; one figure once
per screen; art ripped from other games never ships and stays in the session
scratchpad.

## Why this exists

R35 gave the fight simulation a distance model. The standing fight is played
on a contested band — `OUT / LONG / MID / POCKET / CLINCH` — and the two
fighters argue about it every exchange. The longer fighter wants it long,
the shorter one has to cross the longer man's range and pays a toll on the
way in. It is, mechanically, the most legible thing in the whole simulation
and right now it has no visual form at all.

Kalli's K22 is deciding, in parallel, WHAT the player should be told and in
what words. **You are deciding what it LOOKS like.** The two land together
and Claude builds from both, so do not wait for K22 and do not duplicate it —
if you need a ruling it owns, note the dependency and design both readings.

## What to deliver

1. **The range indicator itself.** The band is one shared value with two
   fighters wanting different parts of it — that asymmetry is the whole
   subject and a plain 5-segment progress bar throws it away. Design the
   mark that shows: where the fight IS, where each fighter WANTS it, and who
   is currently getting his way. Give it a resting state, a contested state,
   a "he is being dragged" state and a clinch state.
2. **Where it sits.** Place it in the fight surface. The screen already
   carries two health bars, two stamina bars, the round clock and a scrolling
   exchange log; you are adding a reading, not a second HUD. Show the
   placement at 1920x1080 with the existing furniture drawn around it.
3. **Motion.** The band moves at most one step per exchange and the exchange
   cadence is roughly one every 14 seconds of fight time. Specify the
   transition — duration, easing, and what happens on the entry toll, which
   is the one moment in the system that deserves a real beat.
4. **The tale-of-the-tape treatment.** Before the bout the two reach figures
   are printed as bare numbers. Design the pre-fight reading of the SAME
   geometry: who is longer, by how much, and what that means for where the
   fight wants to happen.
5. **Iconography.** Five band glyphs, code-drawable, in the house pictogram
   idiom (`Godot/scripts/TechniqueGlyphs.gd` is the existing precedent — every
   technique already has a code-drawn pictogram, no imported art). These have
   to read at 16px.

## Constraints

- Every colour is a token from `UITokens.gd`. If you need a value the tokens
  do not have, propose the token — name, role, hex — rather than using a
  loose hex.
- Nothing here may claim the gold. Gold on the fight surface belongs to the
  loudest thing on the board and distance is never it.
- It must survive the log scrolling underneath it and must not move when the
  band does — the mark changes, the layout does not.
- Code-drawable is a hard requirement, not a preference: no imported bitmaps
  in the indicator or the glyphs.

## Deliverable

`research/M1_RANGE_VISUAL.md` plus images under
`DesignLibrary/screens/range/` (PNG or JPG). The markdown carries the specs —
sizes, tokens, states, timings — and references each image by filename. Keep
the prose short; the images and the token table are the deliverable.

## Anchors

- The model, and the states you are drawing:
  `Godot/scripts/FightRange.gd` — read the file header, it is the entire
  design in 40 lines.
- What the engine emits per exchange: `fight_state["range_band"]`,
  `["range_owner"]`, `["range_event"]` (`from`, `winner`, `mover`,
  `entered`, `contested`).
- The kit and its tokens: `Godot/scripts/UIKit.gd`, `UITokens.gd`,
  `DesignLibrary/kit/index.html`.
- The surfaces: `Godot/scripts/FightNightScreen.gd`,
  `Godot/scripts/RingStagePanel.gd`.
- Existing code-drawn pictograms: `Godot/scripts/TechniqueGlyphs.gd`.
- House renders to match the bar of: `DesignLibrary/screens/profile_revamp/`
  and `DesignLibrary/screens/day/`.

## No parse gate, no test

This task ships no `.gd`. Claude runs the gate when the design is built.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/TechniqueGlyphs.gd
research/M1_RANGE_VISUAL.md
```
