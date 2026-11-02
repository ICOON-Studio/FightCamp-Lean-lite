# TASK C213 - CODEX - TWO GENERATED FIGHTERS IN THE FIGHT ROOM
Owner: codex. Assigned 2026-09-27 (S93). HELD until a shell slot frees (max two shell agents; Cursor U187 and Qwen
Q195 hold them at assignment). Model: gpt-6-astra via CODEX_MODEL (spatial: placement, scale, rig lift), high effort.
Read the Codex meter before launch.

## Why
S93 proved the MPFB generator pilot (`res://assets/models/generator/mpfb_male_pilot.glb`: 52 bones, Hips is the root,
TRUE metres, origin at the soles) plays our clips: `tools/s93_pilot_retarget_probe.gd` matches the source clips to
0.7-0.95 deg mean (f01: 0.6). `FighterLook.gd` turns an athlete id into blend weights + a CC0 skin;
`FighterPortrait.gd` renders his card from the same id. Nothing in the GAME uses the pilot yet.

## What would a human do?
A technical animator adding a new body type to a shipped fight game adds it as one more rig profile beside the old
ones - its own lift, its own scale - and proves old and new rigs both still play every clip before switching anyone
over. They never special-case one scene.

## Do
1. Find where the fight room picks a fighter model and applies `BODY_LIFT_M` (grep `BODY_LIFT_M`, `MALE_MODELS`,
   `skin=` in FightWorldLiveScreen.gd, TrainingFloor3D.gd, CCFighterSkin.gd). Add the pilot as a RIG PROFILE with its
   own lift (0.0 m - measured S93: feet at 0.006 m while clips play) and scale 1.0 (it IS metres; FighterPhysique
   still scales height).
2. Behind a switch (`skin=generator`, like `skin=cc`), a male fighter uses the pilot with `FighterLook.apply` +
   `apply_skin` from his athlete id; clips go through `FightClipRetarget` at load (baked `.res` station clips are
   f01-rest-specific and will NOT play on this rig - retarget them).
3. Render a 10 s clip of a bout with two generated fighters (different ids) through `Tools\godot_hidden.ps1`.

## Owned files
The fighter-model selection code you find in step 1 (name it in the digest), `Godot/tools/c213_*.gd`,
`research/C213_DIGEST.md`, `previews/c213/`. `FightWorldLiveScreen.gd` and `FightStagePlayer.gd`
are thousands of lines - never open whole; grep then `sed -n` windows. `FighterLook.gd`/`FighterPortrait.gd` are small.

## Gate (a CEILING)
- Switch OFF: behaviour unchanged - `python Godot/tools/run_tests.py --jobs 2 --only fight_stage,fight_world,retarget,floor`
  no worse than master; print both SUITE lines.
- Switch ON: both fighters' soles within 0.05 m of the canvas over the clip (print min/max); no limb segment more than
  20 deg off the same clip on f01 (the S93 probe's method); the video in docs/previews/c213/.
- Two DIFFERENT ids (NEVER TEST IDENTICAL FIGHTERS) in a legal matchup for the ruleset.

## Deliver
Commit (explicit paths), push `codex/c213-generated-in-room`, digest, one `agent_comms.py send` line. Do NOT edit
HANDOFF.md. Research is open: RESEARCH_INDEX.md (G126-G128, S93 commits 2268d484).
**Trap:** f01 needs lift 0.925 because its baked hips sit at the origin; the pilot needs 0. A global lift change sinks
or floats every old fighter.
