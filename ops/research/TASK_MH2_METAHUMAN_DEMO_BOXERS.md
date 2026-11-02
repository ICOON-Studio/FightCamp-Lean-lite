# TASK MH2 - the demo boxers become MetaHumans (in the game, not a pilot tool)

Model: gpt-6-astra, medium (3D). Owner: Codex. Worktree `E:/FightCamp/wt/MH2`, branch `codex/mh2-metahuman-boxers` (from master).

## Why (operator, verbatim)
S140: "metahuman model is better" (MH1 pilot passed its D29 look gate, merged 78f5a32e).
S143: "I want to see the new video working with everything on. With a new character models."

## The problem (primary source)
MH1 proved ONE MetaHuman (`Godot/assets/models/metahuman/mh_pilot_02.glb`, preset Victor, 61.7k tris, 341 joints)
plays our certified jab through the production FightStagePlayer - but ONLY inside `Godot/tools/mh1_pilot.gd`.
`grep -rln MetaHumanRig Godot/scripts Godot/tests` returns nothing: the game never loads a MetaHuman. Every fight
(live room, training floor, portraits) still mounts the MPFB generator man via `FightWorldStage.model_for_skin`
(`Godot/scripts/FightWorldStage.gd`, 168 lines, line 27). Read `research/MH1_DIGEST.md` IN FULL first - every
command, the bone map, and the traps are there.

## Build
1. **Four distinct men.** With the MH1 pass-2 scripts (`Tools/metahuman/mh_build_pilot02.py`, `bl_exr2npy.py`,
   `make_textures02.py`, `bl_build_glb02.py`) parametrised by preset + body, build FOUR male MetaHumans from four
   DIFFERENT male presets of the 29 under `/MetaHumanCharacter/Optional/Presets` (list them with the commandlet;
   Victor may be one), each with his own groom and a different body (height 170-190 cm, chest/waist spread across a
   lean lightweight to a heavy build). Never two identical fighters. Output
   `Godot/assets/models/metahuman/mh_boxer_0{1..4}.glb`, each <= 6 MB.
2. **Wire them in behind one switch.** `metahuman_bodies` (game ON via the same `demo_switches_on()` pattern
   FightWorldLiveScreen uses, `--script` OFF): `FightWorldStage.model_for_skin` returns an MH glb for a MALE athlete,
   chosen deterministically from `athlete_id` (hash -> 1..4), and the two corners never get the same glb. Women stay on
   their current bodies (MH2 is men only). `rig_profile` gets an `"metahuman"` entry; `mount` calls
   `MetaHumanRig.load_fighter`/`dress` for those paths. Trunks and gloves must still attach through the existing
   overlay contract - do NOT edit `CCFighterSkin.gd` (Codex C241 owns it right now, replacing the glove mesh).
3. **The certified moves must still be certified on these bodies.** Limb lengths change every contact:
   run `python Tools/c223_parallel.py production -- metahuman_bodies=1 report=mh2_c223.json` (add the option read if
   the gate does not pass options through) and report every row. A failing row is a finding for the digest, not
   something to tune away here.

## Acceptance
- 4 glbs, each loads headless with 341 bones, 0 missing (the mh1_pilot.gd probe with `glb=` each).
- Switch OFF: existing body tests byte-identical (`run_tests.py --only fight_world_stage,fighter_physique,fight_world_live --jobs 2` same result as master).
- Switch ON: a 20 s silent live-room MP4, seed 92012, `as_game`, two DIFFERENT MetaHumans, gloves + trunks on,
  `tools/record_room.gd` through `Tools\godot_hidden.ps1` -> `previews/mh2/live_room.mp4`. Open 6+ frames
  with your FILE tool; say what you see (seams, hair, glove attachment, feet on the canvas).
- Perf on an idle PC (watchdog GREEN, no other Godot/UE job): two MH boxers + venue at 1920x1080, avg frame ms vs the
  MPFB control arm (MH1 measured 5.02 vs 4.56 ms without hair cards).
- `mh2_c223.json` rows reported.

## Owned files
`Tools/metahuman/*` (new parametrised copies, do not break the pass-2 scripts), `Godot/assets/models/metahuman/mh_boxer_*`,
`Godot/scripts/FightWorldStage.gd`, `Godot/scripts/MetaHumanRig.gd` (220 lines), one switch line in
`Godot/scripts/FightWorldLiveScreen.gd` (5,911 lines - NEVER read whole; add beside `_shuffle_from_bell` ~753; the
skin call is at ~1154), `Godot/tests/mh2_bodies_test.gd` (new), `research/MH2_DIGEST.md`.

## Prior research
`python Tools/prior_research.py metahuman MH2` -> MH1_DIGEST.md (the whole pipeline), S140_DIGEST.md, DECISION_LEDGER D29,
S138_AAA_VISUAL_GAP (licence: MetaHuman in a non-Unreal engine is allowed under the 2025+ EULA - MH1 recorded it).

## What would a human do?
A character TD builds a small cast from presets with varied bodies, runs every gameplay animation on each body to catch
contact/penetration changes, and only then swaps the cast into the build behind a toggle.

## Prefab check
ibrews/MetaHumanGodot ships only the Godot loader; MH1's scripts are the UE->Godot automation. Reuse them.

## Test (tier: script edited, new assets)
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightWorldStage.gd Godot/scripts/MetaHumanRig.gd Godot/tests/mh2_bodies_test.gd`.
Focused: `mh2_bodies_test.gd`; then `python Godot/tools/run_tests.py --only fight_world_stage,fighter_physique,fight_world_live --jobs 2`.
New binary assets need one headless `--import` pass before tests see them.

## The one trap
**The PC FROZE on MH1's build**: the preset carries Outfits = WI_DefaultGarment and `spawn_meta_human_actor` compiles
4K/8K clothing textures (~4.3 GB). CLEAR THE OUTFITS SLOT BEFORE ANY SPAWN. Run
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` before EVERY UE/Blender/Godot run
(exit 1 = wait). The watchdog GREEN/AMBER is the ONLY gate (operator rule) - other agents' Godot jobs running is NOT a reason to stop; never run two UE builds of your own at once, and for the UE spawn/export step also require RAM < 80% in the reading (it needs ~4 GB headroom). Asset work lives on E: (`E:/FightCamp/metahuman_pilot`), never D:.

Rules: never open a viewer or window (file tool only); git add explicit paths; commit; `git push -u origin codex/mh2-metahuman-boxers`.
Never edit HANDOFF.md. Do not stop at written.
