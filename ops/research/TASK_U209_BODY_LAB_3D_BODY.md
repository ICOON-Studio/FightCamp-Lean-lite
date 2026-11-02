# TASK U209 - the Body Lab shows the fighter's own 3D body, each region glowing by its condition (UI + 3D, Cursor)
Model: Cursor default. Owner: Cursor (after U208 - it reuses U208's fixed portrait studio). Worktree E:/FightCamp/wt/U209,
branch cursor/u209-body-lab-3d (from master after U208 is merged).
Operator 2026-10-01: asked "is the human body from kalli or maria in the fighters profile yet ?" - answer: no, the Body
Lab draws six flat polygons (BodyMapFigure.gd, S68). Proposal accepted, verbatim: "ok go for that" (the fighter's own 3D
body, each region glowing by condition, matching the MetaHuman route - D29).

## What the player gets
On the profile's BODY LAB tab: the fighter's OWN body (same seeded model as his portrait and the man in the ring),
standing in a soft studio light, slowly turnable (drag) - each of the six BodyReadiness regions (head_neck, torso_core,
left/right arm, left/right leg) tinted and glowing by its band (green >= 80, amber >= 60, red below; injured regions
pulse), hover a region = highlight + the same tooltip the polygons give today (InjuryWords / RecoveryWords). References:
UFC 5's damage regions, FIFA/FM medical centre bodies.

## How
- Fighter: `FighterLook` + the U208-fixed `FighterPortrait` studio, full body framing, 3/4 then turnable, SubViewport with
  transparent background and msaa_3d on, inside the Body Lab rect (`ProfileRevampPanel._draw_body_figure`, ~line 2941;
  keep `BodyMapFigure` as the fallback when 3D is unavailable, e.g. Compatibility renderer).
- Region glow: a per-region mask on the skin - bone-weight based (vertex colour from the dominant bone -> region id) or
  six emissive overlay meshes; emission strength by band; no change to the fight's materials.
- Swappable body: when D29's MetaHuman lands the same code must take that model - name the one seam.

## Owned files
`Godot/scripts/BodyLab3D.gd` (new), `Godot/scripts/ProfileRevampPanel.gd` (the Body Lab mount only), `Godot/tests/
body_lab_3d_test.gd`, `Godot/tools/u209_stills.gd`, `previews/u209/*`, `research/U209_DIGEST.md`.

## Prior research
S68 (BodyMapFigure), U3/U10 body regions, G128 portrait, S138_AAA_VISUAL_GAP.md.

## What would a human do?
A UI artist on a sports game: render the athlete, light him, colour the hurt parts, make it touchable.

## Prefab check
Our own fighters and shaders; no purchases.

## Tests
Parse gate; the new test (a fighter with a hurt right arm -> the right-arm region is red/pulsing, the others green;
control: a sound fighter -> no red); `python Godot/tools/run_tests.py --jobs 2 --only profile_revamp,body,smoke`.
Stills + a 5 s turn video (silent) via Tools\godot_hidden.ps1 - OPEN them.

## The one trap
A SubViewport does not inherit project AA; headless draws nothing (render through godot_hidden).

## Finish
git add by explicit path, commit, git push -u origin cursor/u209-body-lab-3d. Never edit HANDOFF.md. Do not stop at written.
