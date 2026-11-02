# TASK FLOORCUTS1 - the gym floor's three cuts + PACE YOURSELF folded into rest (S235)

Model: Grok Dev (coding seat; own Linux box, Godot 4.7.2, no LFS). Branch `grok/floorcuts1`, open a PR to master. Claude reviews and merges by diff.
Owner of the gym floor this round (Codex is frozen except ROOMS3CD).

## Why (Ludo r97/r98, the lead designer; GYMFLOOR_MECHANICS_IDEAS_S234.md lines 151-155 and 216-235)
Ludo rated the floor decisions 3/10: "BEST and GOOD tell me what to click", "Station choice is solved by BEST", PACE YOURSELF "is the stamina
answer, not a choice", the station-ring "Upgrade" duplicates the office window, the walk-in "come back later" duplicates "send away".
Build order step 1 = these cuts. Operator approved the build order (S234).

## The four changes - all behind ONE new switch `floor_cuts` in `GameSwitches.GAME_ON` (read with `GameSwitches.on("floor_cuts")`)
Plain `--script` tests are the OFF control arm (switch reads false there); `-- as_game` turns it on. With the switch OFF nothing changes.

1. **BEST/GOOD -> deltas + prerequisites** - `Godot/scripts/rules/StationAdvice.gd` (235 lines). Add
   `static func deltas(stats: Dictionary, fatigue: float, levels: Dictionary, places: Array, cards: Array) -> Array` returning one row per
   place: `{"place_id", "adds": {stat: float} (what one block there adds, from the same numbers `rank` already uses), "prereq": String
   (the move card whose prerequisite this station feeds, "" if none; `cards` = [{"id", "needs": {stat: float}, "have": {stat: float}}]),
   "rest": bool}`. NO "BEST"/"GOOD" tag in it. Keep `rank` unchanged (OFF arm).
   `Godot/scripts/GymClub3D.gd` (2,775 lines) lines ~1548-1610 (`ADVICE_COLOURS`, `last_station_advice = StationAdvice.rank(...)`, the
   "BEST: " label): when the switch is on, pads get ONE neutral colour, REST keeps blue-grey, and each pad's label reads its top two deltas
   (e.g. "+POW 0.6  +TEC 0.3") plus "-> JAB" when it feeds a card prerequisite. No gold highlight, no "BEST"/"GOOD" text anywhere.
2. **Station upgrade off the floor ring** - `GymClub3D.gd` line ~50 menu table `"station": ["queue_next", "what_it_trains", "upgrade"]`:
   with the switch on, the station ring has no "upgrade"; the office window's "upgrades" (FloorActions `_resolve_office_upgrades`,
   GymHallPanel `_open_upgrades_panel`) stays the one place. Do not delete `_resolve_station_upgrade` (OFF arm).
3. **Walk-in: three options, no "come back later"** - `GymClub3D.gd` line ~51 `"walk_in": [...]`: with the switch on, drop
   `come_back_later`. Keep greet / trial_session / send_away. (The office walk-in POLICY is a later step - not in this task.)
4. **PACE YOURSELF folded into REST** - `Godot/scripts/ui/FormCueBar.gd` (329 lines, card `pace_yourself` at ~38, click at ~112) and
   `GymClub3D.gd` ~1037 (keys 1-3): with the switch on, the bar shows TWO cards (POWER THROUGH, CRISP FORM), key 3 does nothing on the bar,
   and the stamina advice lines in `Godot/scripts/rules/CueStrain.gd` (lines 30/34/38, "dial it to PACE YOURSELF") read
   "send him to REST" instead. REST on the ring menu is the stamina answer.

## Tests (red on master first - paste the red line in the PR body)
- New `Godot/tests/floor_cuts_test.gd` (`extends SceneTree`, `_initialize`, print `FLOOR_CUTS failures=N`, `quit(0 if failures == 0 else 1)`):
  forces the switch on the way the other GAME_ON tests do (grep `force_on` / `GameSwitches` in tests/ for the existing pattern), then asserts:
  StationAdvice.deltas has no "tag" key and a non-empty "adds" for a stats/fatigue fixture; a station feeding a card names it in "prereq";
  the station ring list has no "upgrade"; the walk-in list has exactly 3 and no "come_back_later"; FormCueBar built with the switch on
  has 2 cards; CueStrain advice text never contains "PACE YOURSELF". With the switch OFF: rank() still tags BEST (control arm).
- Must stay green: `station_advice_test.gd`, `floor_actions_test.gd`, `form_cue_bar_test.gd`, `walk_ins_test.gd`, `gym_upgrades_panel_test.gd`.
- Run each: `godot --headless --path Godot --script tests/<name>.gd`. Do NOT run `gym_club_3d_test.gd` if it needs LFS models (CI has no LFS) -
  say so in the PR; Claude runs it on the PC.
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.

## Prior research
GYMFLOOR_MECHANICS_IDEAS_S234.md (Ludo r96-r98 scores and cut list); research/ludo_rx/LUDO_R96_raw.txt; S229 FLOOR-PLAY (Ludo r81/r84 - why
BEST/GOOD and the cue bar were added); S234_DIGEST.md.

## What would a human do?
A designer removing autopilot shows the player the trade (what each station gives) and lets him decide; he removes duplicate buttons so
each choice lives in one place.

## Prefab check
None needed - edits to our own scripts.

## Rules
- GDScript traps: `research/GDSCRIPT_TRAPS.md` (typed `var x: float = float(d.get(...))`, never `:=` on a Variant, never `%%`).
- Do not read `GameState.gd` whole; you should not need to touch it.
- The one trap: every place that reads `row["tag"] == "BEST"` in GymClub3D must still work with the switch OFF - branch on the switch, do
  not rewrite the OFF path.
- No other files. No deleting tests. Push the branch, open the PR, comment "FLOORCUTS1 DONE" with the test lines.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip/scene: it must read RED on the defect; paste that number in your report.
2. Stills only via record_room.gd / club_room_still.gd -- as_game + still_framing.gd save_if_framed (game camera; never a feet-only or mat shot).
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies (room stills: clipping, floating, paths, dark zones, HUD).
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
