# TASK ATTRITION1C - the day's body wear reaches the save and the fighter readout (switch area_wear, OFF) (S198)
Model: Codex (luna). Worktree E:/FightCamp/wt/PLAYABLE1 (reuse: imports built). NEW branch codex/attrition1c:
`git fetch && git checkout -B codex/attrition1c origin/master` (codex/playable1 is merged; nothing of yours is left there).

## Owned files
- `Godot/scripts/DayLapSplice.gd`
- `Godot/scripts/GymHall3D.gd`
- `Godot/scripts/GameState.gd`
- `Godot/scripts/rules/FighterReadout.gd`
- `Godot/tests/area_wear_persist_test.gd` (NEW)

## Background (approved by the operator: Ludo round 32 "B. each training area works the body differently", board Q-S196-2)
Pure parts are on master: `rules/AreaWear.gd` + `assets/data/area_wear.json` (8 areas -> 6 regions, coach roles, bands with
output_mult), and S198 `DayLap.run_day(start, plan, discipline, fit, area_wear_on := false, coach_roles := [])` which returns
`"area_wear": {region: wear added}` only when area_wear_on (OFF = byte-identical, no key; `tests/day_lap_area_wear_test.gd`).
Nothing carries it further yet: the club visit's `lived` dict (GymHall3D.gd ~695 `visit_ended.emit({...})`) has no wear, and
`GameState.file_visit` (~19056) never stores it.

## Do (all behind ONE switch `area_wear`: career key `career["area_wear"]` or user arg `area_wear`; default OFF; follow how
`GymLook2.switch_on()` / `FLOORGAIN` switches read career key then user arg - grep one and copy the pattern)
1. DayLapSplice.run: pass `bool(ctx.get("area_wear", false))` and `ctx.get("coach_roles", [])` into DayLap.run_day, and carry
   `area_wear` into its result (sum over the spliced legs when it runs per leg ~line 101). OFF: result unchanged.
2. GymHall3D: when the switch is on, put the coach roles of the staff on the floor into the ctx (map our staff records to the
   AreaWear role ids `pad_man, technical_specialist, head_coach, conditioning_coach, strength_and_conditioning,
   physical_therapist` - grep how staff role/discipline is stored, write the mapping as one named const dict with a comment),
   and add `"area_wear"` to the `visit_ended` lived dict.
3. GameState.file_visit: when on, `athlete["area_wear"] = AreaWear.apply(athlete.get("area_wear", {}), lived["area_wear"])`,
   then the overnight heal: every region -OVERNIGHT_HEAL (named const = 8.0, comment "S198 placeholder until Ludo round 33
   tunes it"), clamped at 0. OFF: no `area_wear` key is ever written (old saves and OFF arms stay byte-identical).
4. FighterReadout.regions(athlete): when `athlete.area_wear` exists, it is the wear source for the 6 regions (band + colour from
   AreaWear.band_of); otherwise the current behaviour.

## Test - `Godot/tests/area_wear_persist_test.gd` (new; extends SceneTree; prints `AREAWEAR_PERSIST total=N fails=M`; quit(1) on fail)
Real GameState (`root.get_node_or_null("GameState")`), `save_dir_override = "user://test_area_wear_persist"`, a new career with one
boxer (copy the setup of `tests/station_info_card_test.gd` `_prep`). Cases: (a) OFF: a lived day with 60 min heavy_bag through
file_visit -> athlete has NO `area_wear` key; (b) ON: same day -> left_arm == 3.5 - 8.0 clamped = 0.0 and torso_core 0 (overnight
heal ate it) - so ALSO (c) ON with 240 min heavy_bag starting at 100 stamina -> left_arm > 0 and equals the DayLap sum minus 8;
(d) two such days stack (day 2 > day 1); (e) FighterReadout.regions on that athlete shows the wear band name from AreaWear.band_of;
(f) a pad_man on staff lowers the left_arm wear vs no pad man. Prove (a)-(f) red on master first (paste it), then green.

## Gates
- Parse: `python Godot/tools/check_scripts.py <every .gd touched>`
- `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/area_wear_persist_test.gd`
  (NEVER _console.exe) -> exit 0, no FAIL, no SCRIPT ERROR.
- `python Godot/tools/run_tests.py --only day_lap --jobs 2`, `--only floor_gain --jobs 2`, `--only playable_loop --jobs 2`,
  `--only fighter_readout --jobs 2`, `--only area_wear --jobs 2`: no new red.

## Prior research
research/LUDO_ROUND32_S197.txt PART 3 (the areas), LUDO_ROUND32_VERDICT_S197.md B, S197_DIGEST.md, tests/day_lap_area_wear_test.gd.
## What would a human do?
A strength coach logs each athlete's sore spots after every session and checks the log before planning tomorrow.
## Prefab check
None - our own save data.

## The one trap
GameState.gd is 19,179 lines - NEVER read it whole: grep, then `sed -n` windows of <= 200 lines. And the OFF arm must not gain a key
(feedback rule "a new key breaks a hash even at zero"). Commit on codex/attrition1c, push; never master; never open a window or
image viewer. Final message: red output on master, green output, files changed.
