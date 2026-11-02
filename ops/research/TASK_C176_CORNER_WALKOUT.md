# TASK_C176 - the fight starts in the corners (Codex)

Model: gpt-5.6-luna, MEDIUM (room presentation, not 3D animation design). Owner: codex. Assigned S60, 2026-09-23.

## What the operator asked, verbatim
> "i want to see the fighters standing at opposing corners at the start of the fight and then walk towards each other"

Today both men appear already at fighting distance in mid-ring.

## Owned files
- `Godot/scripts/FightWorldLiveScreen.gd` - ONLY a new prelude block (see below) and its option.
- `Godot/tests/fight_room_walkout_test.gd` (NEW).
- `research/C176_DIGEST.md` (NEW).

## Spec
1. A PRESENTATION prelude before the first engine tick. The engine is NOT changed: its start
   positions, seed and every beat stay byte-identical (the prelude only delays `_show_s`).
2. At setup each man stands in HIS corner: diagonal opposite corners of the drawn canvas,
   `_arena_half_m` (already computed from `ArenaRig` meta `contest`) inset by 0.6 m on
   both axes, facing the ring centre. For a cage (octagon shape) use the two opposite
   vertices on the fight line, inset the same.
3. Hold 1.5 s (touch of the corner), then both walk to their engine start positions at a
   walking pace of 1.2 m/s using the existing locomotion (`_walk_at_body_speed` at :2441
   and the U84 direction table - the walk clip must match the heading, not slide).
   They turn to face each other as they arrive. Then the engine clock starts.
4. Option `walkout` in `configure()`, default **true** in the game, and **false whenever
   `OS.get_cmdline_args()` has `--script`** unless the option says otherwise - every
   existing test and recording tool must see the room exactly as today.
5. The ropes: `_rope_clamp_pair()` (end of `_process`) already keeps both centres inside;
   the corner positions must already satisfy it (assert it).

## Anchors (FightWorldLiveScreen.gd is ~2,900 lines - never open it whole)
`configure(` :578, `setup(` :643, mounts :720 (`Stage.mount ... "SpawnA"`), `_process` :938,
`_pump_to` :988, `_walk_at_body_speed` :2441, `_rope_clamp_pair` (grep). Read `sed -n` windows.

## Gate (tier: a script edited)
- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightWorldLiveScreen.gd Godot/tests/fight_room_walkout_test.gd`
- New test asserts, with `walkout=true` passed explicitly: frame 0 both men within 0.05 m of
  their corner points; during the walk each man's speed <= 1.5 m/s and he never leaves the
  canvas; on arrival the gap equals the engine's start gap within 0.05 m; the engine's beat
  list for the seed is IDENTICAL with walkout on and off (determinism - same seed twice is the
  one legitimate same-fixture comparison). Population: the room's own boxing pair (f01
  out-boxer vs f09 pressure puncher, male welterweights) and its MMA pair; name them in output.
- Then `python Godot/tools/run_tests.py --only room`, `--only world`, and
  `tests/fight_room_ring_bounds_test.gd`. No full suite.
- One render: `Godot_v4.7.2-stable_win64_console.exe --path Godot --position -3000,-3000 --script tools/record_room.gd`
  is movie-mode; instead capture 3 stills (t=0, mid-walk, arrival) with a tiny tool and put them
  in `previews/walkout/`. OPEN them.
- Commit explicit paths, push to master from the main checkout, digest, then
  `python Tools/agent_comms.py send --from codex --to claude --task C176 --body "..."`. Do NOT edit HANDOFF.md.

## Trap
Do not move the engine's start positions to the corners. The engine fights from its own
start; the corners are presentation. Moving the engine changes every seeded bout in the suite.
