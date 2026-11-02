# TASK C241 - a real boxing glove mesh, not two stretched primitives (Codex)

Model: gpt-6-astra, medium (3D). Owner: Codex (free seat S141 - C240b landed, not merge-ready, parked).
Worktree E:/FightCamp/wt/C241, branch codex/c241-glove-asset (from master).

## Why (operator, verbatim, on a sent preview, S141)
Operator saw the U208 tale-of-the-tape preview (after a separate freeze-bug fix made the gloves track the
hands correctly for the first time): "the gloves look terrible make another asset for the gloves."

## The problem (primary source)
`Godot/scripts/CCFighterSkin.gd:_build_glove` (~line 349) builds the WORN glove every fighter in the game
wears - boxing, MMA, mitts - from **two stretched primitives**: a `SphereMesh` scaled non-uniformly for the
fist (`sphere.scale = Vector3(wide, along, deep)`) and a `CylinderMesh` for the cuff, two separate materials,
no thumb, no seams, no padding silhouette. This is a placeholder that shipped everywhere by construction - it
was never meant to be final geometry. It is used by every fighter in the live ring, every portrait/tale-of-
the-tape render, everywhere `mount_procedural_gloves`/`mount` is called. This is NOT a U208-only bug.

## Build
1. Read `research/G80_GLOVE_DIMENSIONS.md` first - real dimensions per weight class are already
   researched and cited (10 oz boxing ≈0.26×0.11×0.10 m, cuff 0.15; 4 oz MMA ≈0.19×0.10×0.06, cuff 0.08;
   Muay Thai ≈0.28×0.12×0.11, cuff 0.10; WKF mitt ≈0.16×0.10×0.055). `_STYLE_TO_SPEC` in `CCFighterSkin.gd`
   already encodes these as the current primitive's scale/position constants - your new mesh must fit the
   SAME real-world envelope, so the hand-bone attachment math (`_hand_idx`, `sync()`, `_pose_glove`) does not
   need to change, only what's rendered.
2. Prefab check first (house rule, CLAUDE.md product rules): look for a CC0 or permissively-licensed low-poly
   boxing glove model (Sketchfab CC0, Fab free, itch.io, Mixamo accessories) that matches the real silhouette
   (closed fist shape, thumb notch, separated cuff, knuckle padding read) and fits the triangle budget (a worn
   accessory on a fighter rendered at distance - a few hundred tris per glove is plenty, this is not a hero
   prop). Name the exact source and licence in the digest. If nothing fits cleanly, author one yourself in
   Blender 5.2.1 headless (`C:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe`) - a real glove silhouette
   (rounded fist mass, a distinct thumb, a cuff that reads as wrapped material, not a bare cylinder), one mesh
   per style (boxing/MMA/muay_thai/mitt) OR one parametric mesh if the silhouette generalizes across styles
   with the existing per-style scale factors.
3. Wire the new mesh(es) into `_build_glove` in place of the sphere+cylinder, keeping the function's existing
   contract (returns a `Node3D` named `"Glove_" + side`, same `spec` dict inputs for colour/scale/position) so
   every caller (the live ring, portraits, U208's preview) picks it up with zero changes elsewhere.
4. Render BEFORE (today's master, primitive gloves) vs AFTER (your mesh) on the same fighter, same camera, same
   pose (a guard idle frame is enough - gloves read clearly there) for boxing AND MMA at minimum. Open both
   stills with the file tool before calling this done - this is exactly the kind of visual regression a green
   test suite cannot catch (see `[[feedback_open_the_output_before_the_gate]]`).

## Acceptance
- Stills opened, boxing + MMA, before/after: the new glove reads as an actual boxing/MMA glove silhouette
  (rounded mass, distinct thumb, a cuff that looks wrapped, not two primitives glued together) at both
  close and broadcast-camera distance.
- Triangle count stays reasonable for a worn accessory (report the number; a few hundred tris per glove, not
  thousands - this renders on every fighter, every frame).
- `mount_procedural_gloves`'s existing hand-bone tracking still works unmodified - prove it with a short clip
  or a few frames across an animated clip (reuse U208's or the live room's existing render path), not just a
  static pose, since a glove that tracks correctly but was authored with the wrong pivot/orientation can look
  fine held still and wrong the instant the wrist rotates.
- No licence violation: if a prefab was used, the exact source + licence is named in the digest; if authored,
  say so and that it is original geometry.

## Owned files
`Godot/scripts/CCFighterSkin.gd` (`_build_glove` and any new mesh-loading helper only - do not touch
`_hand_idx`, `sync()`, `_pose_glove`, or the style spec dictionaries' numeric values unless a dimension is
provably wrong against G80), new glove mesh/texture assets under `Godot/assets/models/gloves/` (or similar,
name it), `research/C241_DIGEST.md`.
S146 run 4 widened (Claude): `Godot/scripts/FighterFist.gd` (thumb fold), `Godot/tests/cc_skin_contract_test.gd` and
`Godot/tests/fight_cc_skin_test.gd` (one-mesh glove has no `Fist` child), `Godot/assets/asset_manifest.json` (glove folder claim),
`previews/c241/*` (review stills).

## Prior research
`python Tools/prior_research.py boxing glove asset mesh dimensions`: G80_GLOVE_DIMENSIONS.md (the sizes),
G129_DRESSING_THE_GENERATED_FIGHTER.md (how worn items attach), C213_DIGEST.md (the generated fighter rig).

## What would a human do?
A character artist would never ship a stretched sphere as a worn prop in a boxing game - they'd model the
actual silhouette once, at the real dimensions already researched, and reuse it everywhere the rig already
knows how to attach it.

## Prefab check
Required, see Build step 2 - name the source and licence, or say "authored, original geometry" if none fit.

## Test (tier: script edited, new assets)
Parse gate on `CCFighterSkin.gd` first. Affected:
`python Godot/tools/run_tests.py --only ccfighter,glove,fight_stage,portrait --jobs 2` (never serial).
Visual gate (not a script test): the before/after stills named in Acceptance, opened with the file tool.

## The one trap
`CCFighterSkin` is `RefCounted` - whatever test/render harness you use to prove the hand-tracking still works
must keep a live reference to the mounting object for the whole render, or the gloves will freeze at mount
time (exactly the bug a sibling fix just found and fixed in `u208_tott_previews.gd` this session - read that
diff, `git log -p -- Godot/tools/u208_tott_previews.gd` on `cursor/u208-tott-previews`, before you build your
own test harness so you don't reintroduce the same trap).
