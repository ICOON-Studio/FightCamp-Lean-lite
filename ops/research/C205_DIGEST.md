# C205 - Marpa MMA Arena

Status: arena adapter and approved configure metadata line implemented. Default OFF; MMA uses the fitted cage, boxing/kickboxing retain ArenaRig inside the hall.

## Delivered locally

- Only worktree `C:/Users/user/AppData/Local/Temp/FightCamp-C203`, branch `codex/c205-mma-arena`.
- Source package SHA-256 `e03c420b1fb4ca8d49215ec83b39cd931727373885522f5e11dc637f123702b5`.
- All 31 FBX meshes, 29 reconstructed StandardMaterial3D materials, 1,443 Unity prefab placements and six native floor planes. Shared native `.res` resources; no whole-project import and no `.godot` files to stage.
- PNG-derived albedo, normal, AO/roughness/metallic and available emission. Cutout fence/seats and alpha glass. Mipmapped lossless texture storage, at most 2K. Height/parallax maps and Unity-only baked lighting/shaders omitted; no mesh pieces dropped.
- Approximately 44.04 MB of native assets, converter scripts, receipt and scene before final media; under the 120 MB limit.
- `MarpaArena.gd` fits measured source bounds once, aligns the source hall floor to ground, keeps cage hidden for rings, and calls unchanged `ArenaRig.build` for boxing/kickboxing geometry.
- Licence row and approved asset-manifest entry record the task's explicit authorization. Source and native-byte roster retained in `receipt.json`.

## Geometry evidence

FBXDocument correctly decodes the ASCII FBX centimetres/pre-rotation into upright metre geometry. Unity prefab pivots replace FBX object pivots. The source demo hall's ground is -2.23 m; one hall translation aligns it to the game.

The runtime reports the cage's opposing flat mesh bounding envelope (not a claim about clear space inside post padding):

| Preset | Measured X/Z span | Spec contest | Fence / spec | Canvas top / spec |
|---|---|---|---|---|
| mma_cage_ufc_30ft | 9.144000 / 9.144000 m | 9.144000 m | 1.828800 / 1.828800 m | 1.025400 / 1.025400 m |
| mma_cage_ufc_25ft | 7.620000 / 7.620000 m | 7.620000 m | 1.828800 / 1.828800 m | 1.025400 / 1.025400 m |
| mma_cage_gym_6m | 6.000000 / 6.000000 m | 6.000000 m | 2.000000 / 2.000000 m | 0.130000 / 0.130000 m |

No spec, simulation, RNG, fighter or camera behaviour changed. Visual review is preliminary: a standalone hall render was inspected; final live ON footage remains required.

## Checks so far

Parse gate passed for runtime, wiring, converter and test scripts. Requested subset: `SUITE total=17 fails=1`. The one failure is `fight_stage_realism_test.gd`, reporting fighter motion/spacing/guard/overlap/contact failures; the untouched HEAD live-screen baseline independently returned `SUITE total=1 fails=1` for the same test. This is a verified baseline failure; the requested subset is not wholly green.

`VENUE_ART_TEST checks=49 failures=0`. The geometry assertions read mesh bounds, not advertised metadata. A separate mutant reducing X span by 10% produced `checks=46 failures=3`, one named span failure on each cage preset. Production source was never mutated for that check.

## Resume delivery and visual review

The S78/S80 scope exception authorizes exactly one line in configure(options): `set_meta("venue_art", bool(options.get("venue_art", false)))`. Other screen edits remain in the original 836-870 wiring seam. No HANDOFF edits. The resume instruction replaces the original six-still request with 2-4 stills.

Personally inspected both 1920x1080 live ON images (seed 5150, frame 60):
- `previews/c205/mma_on_broadcast.png`
- `previews/c205/boxing_on_broadcast.png`

The fighters appear to stand on the canvas at plausible human-to-fence/ring scale; no gross floating, sinking or giant/tiny fighter mismatch is visible. This is a visual assessment, not foot-contact tracking. The boxing frame has a pale polygonal patch on the foreground canvas and seating has harsh white edges/dark surfaces. These are visible quality limitations; this delivery is not a claim of finished arena lighting/material polish. Both stills show the opening exchange state, not a complete bout review.

All windowed runs used `Tools/godot_hidden.ps1`. A first relative movie path failed to open; captures were regenerated with absolute output paths. Two matched-rule OFF/ON pairs (seed 5150, broadcast, 150 frames/30 fps) are retained under `Godot/assets/venues/mma_arena/evidence/`:

| File | MD5 |
|---|---|
| boxing_off.mp4 | 2c9c2a984f7d10ffa2e1059b02e71cfd |
| boxing_on.mp4 | 5b1938daab21cf0d5cb74c2990a50b47 |
| mma_off.mp4 | 0df4938e65e9faed4357c5ea8dfb12d8 |
| mma_on.mp4 | 6dc3203102de4e9c0ca87de00ab61e12 |

OFF videos come from the prior C205 run; ON videos were produced in this resume before rebasing. The round-clock update on master is retained at integration; these captures predate that UI change.

Raw `.c205_source/` measured 259,590,794 bytes before new captures and is excluded from git. Native asset receipt remains 144 files / 44,038,163 bytes before evidence media; no raw vendor package, `.godot` cache or HANDOFF file is committed.

Resume parse gate: `CHECK total=5 fails=0` (MarpaArena, FightWorldLiveScreen, venue_art_test, build_arena and preview). Focused venue rerun: `SUITE total=1 fails=0`.

Receipt reverified during resume: 144 files, zero size/hash mismatches. Arena directory including evidence: 60,895,116 bytes; two PNGs: 2,567,946 bytes. Native assets plus review media: 63,463,062 bytes (63.46 MB), below 120 MB.

Final pre-rebase subset: `SUITE total=17 fails=1`, only `fight_stage_realism_test.gd` (8 failed realism rules), within the approved ceiling. Rebased cleanly onto `db65d12e` (origin/master); retained S79 RoundClock build/update calls and all upstream screen changes. Only the original wiring seam and authorized configure line differ from master. A scoped C205 stash preserved work to honor the resume instruction to rebase before committing; this superseded the general commit-before-rebase preference. Post-rebase parse: `CHECK total=5 fails=0`.

Scoped asset `.gitattributes` retains LF for materials/scenes/JSON so Git Windows checkout conversion cannot invalidate the byte receipt. The 29 material files were normalized back to their original LF bytes after stash restoration.

Post-rebase focused integration: `SUITE total=6 fails=0` (venue_art, arena, fight_world_live). Receipt final verification: 144/144 exact matches. Staged payload before this final digest note: 63710381 bytes across 166 owned files; no blob over 50 MB.
