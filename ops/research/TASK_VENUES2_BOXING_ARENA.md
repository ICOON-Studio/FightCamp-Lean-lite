# VENUES2 - the Marpa "Boxing Arena - Game Level" as the boxing hall

Model: Claude (Opus 5.5) next session - Codex is out (operator S154), Cline's free model hit its daily limit (ends 10-05).
Worktree: the main checkout is fine (art + one adapter); nothing opens on the operator's screen (file tool only, windowed
Godot only via `Tools\godot_hidden.ps1`).

## Why (operator, 2026-10-03, verbatim)
"i thought this was the same as the mma rena we have , can we use it ?" -> yes, a different pack from the same studio;
then "downloaded it". S152 had closed VENUES2 ("we already have the boxing arena nevermind") on the belief that the
shipped Marpa MMA Arena was this pack. It is not: we ship Marpa's MMA ARENA (cage hall, C205/C206); boxing bouts today
draw ArenaRig's ring inside that cage hall (C205: "boxing/kickboxing retain ArenaRig inside the hall").

## The source (on disk, owned by the operator)
`%APPDATA%\Unity\Asset Store-5.x\Marpa Studio\3D ModelsEnvironments\Boxing Arena - Game Level.unitypackage`
491.4 MB, sha256 `7472f679fe57f679e217525837e6c2e1da9ac8abb402e86f71a547a9535ceb5`, purchased (free) 2026-10-03, organisation
koxar13 (Personal). Unity Asset Store EULA - same terms as the MMA Arena we ship (`assets/venues/LICENCES.md`).
Contents per PREFAB2_UNITY_PACKS.md: 40 FBX (RingFloor, RingPillarsBase, Rope, Corner, Floor, Stage, EntranceStage,
EntranceField, two seat tiers + barricades, BigScreen, ScoreBoard, TopFloorScreen, Truss, lamps, curtains, banners, ad
boards, stairs, windows), Built-in prefabs + URP/HDRP sub-packages, Unity 2022.3.8.

## Prior research
C205_DIGEST.md + TASK_C205_MMA_ARENA.md (the import pipeline), C206_DIGEST.md (fit + hall exposure, `venue_art` switch),
C232_DIGEST.md (walkout builds VenueRig with the booked venue), PREFAB2_UNITY_PACKS.md (verdict USE), G74_THE_VENUES.md /
M39 (the venue ladder), topics/camera_broadcast.md.

## What would a human do?
Import the vendor's hall once, keep its source scene intact, and fit only its ring to the game's ring spec (22 ft ring,
S141) so every fight number stays the same; judge it from broadcast-camera stills.

## Prefab check
The pack IS the prefab. The pipeline exists: `assets/venues/mma_arena/build/` (extract_package.py 24 l., decode_unity.py
55, prepare_maps.py 19, build_arena.gd 150, preview.gd 31) + `scripts/MarpaArena.gd` (156; `build`, `fit_cage` l.96).

## Spec, in order
1. Copy the build folder to `assets/venues/boxing_arena/build/`, point `extract_package.py` at this package and its sha256,
   scratch dir `.venues2_source/` (never committed). Run extract -> decode -> prepare_maps -> build_arena (headless) ->
   `boxing_arena.tscn` + receipt.json. Read decode_unity's prefab roster; check the URP/HDRP sub-packages are skipped
   (Built-in only, like C205).
2. `MarpaArena.gd`: a `fit_ring` beside `fit_cage` - measure the pack's RingFloor/ropes/posts, scale to the boxing spec's
   contest + apron and `surface_y` (ArenaRig.surface_y), print measured beside spec. Boxing routes to it under the same
   `venue_art` switch C205/C206 use; MMA keeps the cage hall. ArenaRig's own ring stays the OFF arm.
3. Stills from the broadcast camera (preview.gd / C206's capture_fit.gd), boxing ON vs OFF, opened by you, then sent to
   the operator (attach). Walkout (C232) through the new hall: one still.
4. Receipt + licence line; keep asset files light (2K max textures as C205).

## Owned files
`Godot/assets/venues/boxing_arena/**` (new), `Godot/scripts/MarpaArena.gd` (156), the boxing route line in
`ArenaSurface.gd` only if the switch needs it, `research/VENUES2_DIGEST.md`.

## Gate (the one test)
Parse gate on every touched .gd; `python Godot/tools/run_tests.py --only arena,venue,marpa --jobs 2`; the fit print shows
ring span and deck within 1 cm of the spec; stills opened.

## The one trap
The hall must not move the fight: ring size, deck height and spawn points come from the spec, never from the pack. C205
shifted the whole hall so its floor sits at ground - a ring deck that ends up at the pack's height instead of
`surface_y` lifts every fighter.
