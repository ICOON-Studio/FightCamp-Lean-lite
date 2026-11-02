# TASK U212 - the in-game tale of the tape becomes the operator's pick: option 3 (FightCamp)

Model: gpt-6-luna, medium. Owner: Codex (first free seat; Cursor is out of credits). Worktree `E:/FightCamp/wt/U212`,
branch `codex/u212-tott-option3` from master.

## Why (operator, verbatim, S143)
Shown three animated layouts (U208): "option 3".

## The reference (primary source - open it first, with your file tool)
`previews/u208/variant_3_fightcamp_surpass.mp4` + `.png` (1920x1080, 10 s). It is rendered by
`Godot/tools/u208_tott_previews.gd` (`_draw_fightcamp`, `_camp_rows`, `_draw_camp_row`, `_build_fighter_rig`,
`_frame_full_height_camera`, `_portrait_lights`) - that tool is the spec in code: GROUND/PANEL/SODIUM/ICE colours,
title + red/blue names + weight class, 12 rows (record, age, height, reach, weight, stance, rank, KO %, last-5 pips,
weigh-in fitness, camp grade, game plan), rows filling in one by one, full-height 3D fighters left/right in guard idle,
trunks in CORNER colours (red corner red, blue corner blue), Bebas/Plex/Inter fonts at the S143 sizes.

## Build
`Godot/scripts/TaleOfTheTape.gd` (452 lines - the screen the player actually sees before BEGIN) gets option 3:
- Keep its contract EXACTLY: signals `begin_pressed`, `sim_pressed`, `back_pressed`, the BEGIN / SIM / BACK buttons,
  and its data from `TaleOfTape.get_tale_of_the_tape(a, b)` (real athletes, not U208's demo dictionaries).
- Rows the game has no data for (weigh-in fitness, camp grade, game plan): read them from the real camp/fight-plan
  state if it exists (`grep -n "camp_grade\|game_plan\|weigh" Godot/scripts/GameState.gd` - never read GameState whole);
  if a value does not exist, HIDE that row - never print a placeholder.
- The fighters: the same generated bodies the fight uses (FightWorldStage.model_for_skin "generator" + apply_identity,
  as `_build_fighter_rig` and FightWorldLiveScreen do), guard idle through FightStagePlayer, gloves via CCFighterSkin
  (keep a live reference - the RefCounted overlay trap in U208/MH1 digests).
- Reuse U208's code by moving the shared drawing into a small module both the tool and the screen call, rather than
  copying it.

## Acceptance
- Stills of the real screen in a career booking (two different fighters, records, faces), rows animate in, buttons work.
- Corner trunks right; no row with an invented value; text readable at 1280x720.
- `run_tests.py --only tale,tott,fight_night,portrait --jobs 2` green; a 10 s silent MP4 of the real screen, frames opened.

## Owned files
`Godot/scripts/TaleOfTheTape.gd`, a new shared draw module under `Godot/scripts/`, `Godot/tools/u208_tott_previews.gd`
(only to call the shared module), `Godot/tests/tale_of_the_tape_option3_test.gd` (new), `research/U212_DIGEST.md`.

## Prior research
U208_DIGEST.md (the three layouts, the head-crop and frozen-glove send-backs), MH1_DIGEST.md (RefCounted glove overlay
trap), S141_DIGEST.md s7. `python Tools/prior_research.py tale tape broadcast`.

## What would a human do?
A UI programmer takes the approved animatic and rebuilds it on live data, hiding fields the data cannot fill.

## Prefab check
None needed - the approved layout already exists in-house (u208_tott_previews.gd).

## Test (tier: script edited)
Parse gate on every touched .gd; focused test; then the run_tests line above. Watchdog before each heavy run; windowed
renders only through `Tools\godot_hidden.ps1` (Idle priority since S143).

## The one trap
The U208 tool draws on a fixed 1920x1080 canvas with absolute pixel positions; the real screen is a Control that must
lay out at any window size - convert positions to the control's size (anchors/containers), or the 720p screen clips.

Rules: never open a viewer or window on the operator's screens; git add explicit paths; commit; push the branch.
Never edit HANDOFF.md. Do not stop at written.
