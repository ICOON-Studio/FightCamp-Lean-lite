# TASK C232 - the walkout plays in the bout's own venue, down an aisle to the ring steps (3D, Codex)
Model: gpt-6-astra, medium (3D). Owner: Codex. Worktree E:/FightCamp/wt/C232 (S139: E:, D: is failing), branch codex/c232-walkout-e (from master).
Operator 2026-10-01: "wire everything ... AAA game level ... reward the player for progressing" + "regional / national /
international" arenas. S137_LOOP_PLAN.md row L3.

## Why
`Godot/scripts/WalkoutShot.gd` (C207, 228 lines) films a 5 s front three-quarter walk on the OWNED MARPA MMA arena
(`MarpaArena`, `mma_cage_ufc_30ft` for MMA, the ring spec otherwise), opening a gate in its west barricade and fitting
its stairs. `FightNightIntro.walkout_enabled` is false: "OFF until the hall has a crowd and light" (S81). S137 made every
booked bout fight in its level's venue (`VenueLadder`, `FightNightScreen.bout_venue`, six G74 venues in
`assets/data/venue_specs.json`, built by `VenueRig.gd`, 1,654 lines) with crowds - so the walkout should walk into THAT hall,
not a different MMA arena.

## Prior research
C207 digest (`python Tools/prior_research.py walkout C207 aisle entrance`), WalkoutShot.gd whole, VenueRig.gd
(`grep -n "func \|door\|walkway" Godot/scripts/VenueRig.gd`), ArenaRig.gd `_add_ring_dressing` (S137: steps up the +X side at
z = -half*0.45 from the deck), FightNightIntro.gd ~30-90 (`walkout_enabled`, `_prepare_walkout`, spec keys).

## What would a human do?
Every boxing broadcast: the fighter appears at a lit entrance, walks a short aisle through the crowd with his corner,
climbs the steps; the camera tracks low from the front three-quarter. Bigger level = longer aisle, more light, more crowd.

## Owned files
- `Godot/scripts/WalkoutShot.gd`: build the bout's venue (VenueRig with the venue id + ArenaRig ring spec) instead of
  Marpa for boxing; the aisle runs from an entrance marker to the ring STEPS of ArenaRig's dressing; keep the existing
  retarget/foot-contact bake (C207) - only start/finish/path and the set change. MMA may keep Marpa.
- `Godot/scripts/VenueRig.gd`: an `entrance` marker per venue (and an aisle strip if the venue has none) - a few lines per venue.
- `Godot/scripts/FightNightIntro.gd`: pass the venue id into the walkout spec; turn `walkout_enabled` ON for booked bouts
  (stays OFF in tests/headless as now).
- `Godot/scripts/FightNightScreen.gd`: ONLY passing `bout_venue(...)` into the intro spec.
- NEW `Godot/tests/walkout_venue_test.gd` (windowed capture is not a test: assert the path endpoints - entrance -> steps -
  and that feet stay on the floor/step heights over the walk, as C207's own checks do).
- Stills: the walkout at 1 s / 3 s / 4.8 s in R1 Iron Parish, R3 The Cut Glass, R5 Northlight
  (`Tools\godot_hidden.ps1`) -> `previews/c232/`. OPEN THEM: feet on the floor, no walking through chairs.
  NEW `research/C232_DIGEST.md`. Never edit HANDOFF.md.

## Tests
Parse gate; the new test; `python Godot/tools/run_tests.py --jobs 2 --only walkout,fight_night,venue,arena_rig,smoke`.
Watchdog before heavy runs.

## The one trap
A headless run has no framebuffer and `WalkoutShot.available()` returns false headless - test the path maths, not the
render. Never kill Godot by image name.

## Finish
git add by explicit path, commit, git push -u origin codex/c232-walkout-e. Do not stop at "written".
