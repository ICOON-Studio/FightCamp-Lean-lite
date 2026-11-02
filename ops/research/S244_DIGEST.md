# S244 DIGEST (2026-10-17) - placement cleanup on the iso camera, PLACEMENT1 slices A+B, PADPAIR1 clips green on game playback

## Operator this session (verbatim)
- Board Q-S242-1 PLACEMENT1: "Approve and also I want to see the kudos doc 24 perspective" (= Ludo r110 C1, perspective FOV 24).
- Board Q-S242-2 ISOWALL1: "It looks ok for now" -> closed.
- Chat: "Can you please check the placement of the objects?" (boxing-floor crop) / "Also use ziva if you think it will help" /
  "This is a mess what have you done ?!" (6 crops: floating bars over ring/bench/medicine balls, white bars on the back wall,
  a black panel by the timing bags).

## What now works (evidence)
- PLACEMENT CLEANUP 9bb1390c: none of the cropped pieces came from S244 - all were in the shipped build (S243 isowall stills and the
  pre-edit FOV stills show them). Found by measuring every object on the game's camera (tools/placement_audit.gd, tools/screen_pick.gd):
  ceiling lamp housings (y 5.4, above 3.6 m walls) + bag-line tubes + trusses + wall caps now hide on the iso camera at every floor
  zoom (floor_view was missed; GymLook2Shell's per-frame sync re-showed caps IsoWallShell had cut); mirror + glove rack go with a cut
  wall (ClubRoomBase._apply_mesh_fade forced visible=true); unrigged floor double-end bags removed; fan/kitbags/crate/rower out of
  aisles; stray office fame frame + chalk box removed. Tests: iso_ceiling_fixtures_test red(12/12 lamps at floor_view)->green,
  c78_boxing_floor_decor_test red->green (no unrigged hanging gear), iso_wall_rotation 0, --only gym/iso 20/0. Before/after stills
  docs/previews/s244_cleanup + board review. Left: the strip tubes' fill lights still make two bright spots on the boxing floor.
- FOV 24 stills (tools/fov24_stills.gd, docs/previews/s244_fov24) on the board as Q-S242-3 (keep ortho or switch). FOV 24 blows the
  OFFICE PC label up (sized for ortho) - a fix if chosen.
- PLACEMENT1: brief TASK_PLACEMENT1.md. Slice A PlacementRules.gd (Arena #249, 6ac02938, 40 checks), slice B saved place moves in
  GymClubLayout (Cursor #248, 6bd4be44, + point lists like the rope follow; CLUB_PLACE_MOVES 16/0). Slice C (build-mode UI: B key,
  ghost green/red + reason, buy, pause; Ludo look first) not briefed yet.
- PADPAIR1 clips f9ef8531: mh_pads_fighter_loop.glb + mh_pads_coach_loop.glb (240 f, loop seam 0.0 cm), native MH rig, two Cascadeur
  runs in one world frame (Tools/cascadeur/padpair1/author_padpair.py + produce_pair.py), coach keyed from the fighter's post-physics
  fists + 2 measured correction passes (coach_corrections.json). Gate 2 on the GAME's playback (tools/padpair_contact_probe.gd via
  MetaHumanRig.load_fighter + FightClipNativeMH.load_animation): 6 punch contacts <= 1 mm, taps 2.5/0.0 cm, bodies >= 0.81 m.
  Wiring -> Cursor #250 (TASK_PADPAIR1W.md, switch pad_pair) RUNNING. Visual gate (game-camera stills guard/42/96 + operator OK) after.
- Collected: NIGHTLY8 #246/#247 (c9848f0e; fight_identity 1 red left: "rivalry heat costs stamina" cold 90.7 = hot 90.7 - heat
  does nothing, not a coin flip), ASSETAUDIT1 part A (f5c825cc, Qwen; Windows as_posix fix; 4 SWAP: compact_weights,
  exercise_bike, heavy_bag, treadmill -> GYMPACK).
- FLOATERS1 SUPERSEDED (not collected): the floor already shows r105 D4 via the S231 gain bubbles + PROGSIGNS2 milestones.
- board_reconcile 04a0b8ab: an issue run lands as its <agent>/issue-<n> branch (Actions may not open PRs here).

## Decisions (developer calls)
- FLOATERS1 dropped as a duplicate layer. Ceiling/caps hide on the iso camera (roofless cutaway, Two Point). Ring stays fixed in
  build mode (demo). Coach mitt targets corrected on the coach body's own playback, not in Cascadeur.

## Traps
- A `git add` glob that matches an ignored file aborts the && chain - the commit silently did not happen and Cursor's first run
  checked out the commit before the clips (cancelled + relaunched on f9ef8531).
- In a SceneTree `_initialize`, global transforms and Skeleton3D globals are stale: compute bone world positions from local poses.
- Cline seat cannot run: repo secret OPENROUTER_API_KEY not set (the operator's).

## HANDOFF
- Working commit: f5c825cc + this digest. Pushed.
- In flight: Cursor #250 PADPAIR1W (run 39043111631), Grok Dev NIGHTLY8 (5 tests left).
- Next action: roadmap now.next_action.
- Awaiting operator: Q-S242-3 (ortho vs FOV 24); his look at the S244 cleanup before/after on 8787/review.
