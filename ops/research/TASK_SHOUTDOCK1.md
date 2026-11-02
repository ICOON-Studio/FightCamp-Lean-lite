# TASK SHOUTDOCK1 - the learned corner shouts on the fight HUD (FIGHTLINK shouts part 2c, boxing)

THIS IS THE TASK. Model: Cursor (cloud). Discipline: BOXING (demo).

## Why
Operator Q-S249-3 (board, verbatim): "Build it" - corner shouts the fighter LEARNS (verdict
`research/CORNER_SHOUTS_VERDICT_S250.md`, design Ludo r117 `research/ludo_rx/LUDO_R117_raw.txt` section 6, lines 280-340).
The engine is LIVE on master (switch `corner_shouts`, GAME_ON): the club day grows `athlete["shout_mastery"][<SHOUT_ID>]` (0-100) and
in the bout `FightRealtime.shout()` resolves a call by that bar (clean / delayed / ignored / blunder) on a 25 s rhythm
(`rules/CornerShouts.gd`: `SHOUTS`, `tier`, `cooldown_s`, `max_per_round`, `blunder_odds`, `exec_chance`). The player still sees the
OLD 3-button apron bar (`scripts/LudoShoutBar.gd`, 209 lines) with the apron table's 22 s / 3 calls - wrong numbers, no bars, no risk.

## The route the game runs (traced)
`scripts/FightWorldLiveScreen.gd` (6,661 lines - never read whole; `sed -n 5340,5400p`): `_sync_shout_bar()` (:5362) builds
`LudoShoutBar` on `_corner_layer` when `fight.has("ludo_shouts")` and the player has a corner, then `set_state(used, max, cooldown_left)`
from the APRON table; `_on_shout(id)` (:5390) calls `FightRealtime.shout(fight, side, id)` and `show_result(result)`.
The fighter dict in the bout is `fight[side]`; it carries `shout_mastery` (Dictionary) when he has drilled bars, `coach_trust`,
`coach_rating`, and composure (`fight[side]["composure"]` when `ludo_composure`).

## Files you own
1. EDIT `Godot/scripts/LudoShoutBar.gd` - becomes the r117 dock WHEN `fight` has `corner_shouts` and the player's fighter has a non-empty
   `shout_mastery`; otherwise it stays exactly today's 3-button bar (the control arm). Dock:
   - 6 loadout buttons = the fighter's six HIGHEST bars (ties: `CornerShouts.SHOUTS` order), keys 1-6 fire them (today's bar uses keys too
     - read `_unhandled_input` :188 and keep its pattern). Button 220 x 108, gap 12, square corners. Inside: key pip "[n]", the shout id
     words in caps (STAY BEHIND JAB), the call text (`CornerShouts.SHOUTS[id]["text"]`), a 22 px footer bar filled to the mastery with
     the tier colour - RAW #DC2626, USABLE #F59E0B, SHARP #3B82F6, DRILLED-IN #10B981 (tier from `CornerShouts.tier`) - and "SHARP 74%".
   - A RAW button shows a red "(!)" and its tooltip reads the failure odds from `CornerShouts.blunder_odds(m)`:
     "RISK: 20% BLUNDER / 50% IGNORE / 30% LATE".
   - Top status row 26 px: cooldown gauge 220 x 8 + "COOLDOWN: 14.2s" (blue #3B82F6) or "READY TO SHOUT" (green #22C55E); right side the
     calls-left pips (12 x 12 squares, `CornerShouts.max_per_round(coach_rating, composure)` of them, filled = left).
   - While cooling: every button darkened (#000 at 65%) and disabled.
   - Frame 1400 x 146, #090B0E at 95%, 2 px #1E2530 outline, bottom-centre, ABOVE the scorebug - no overlap with any existing fight HUD
     node (see acceptance).
2. EDIT `Godot/scripts/FightWorldLiveScreen.gd` `_sync_shout_bar` ONLY (:5362-5388): when `fight.has("corner_shouts")`, take
   cooldown = `CornerShouts.cooldown_s(composure)` and max = `CornerShouts.max_per_round(coach_rating, composure)` instead of the apron
   table, and pass the fighter's `shout_mastery` to the bar (new method `set_bars(bars: Dictionary)`). Nothing else in that file.
3. NEW `Godot/tests/shout_dock_test.gd` (extends SceneTree, OK/FAIL lines, ends `print("SHOUT_DOCK failures=%d" % failures)`).

## Acceptance (numbers - you cannot see images)
- `shout_dock_test.gd`: build `LudoShoutBar` under a 1920 x 1080 Control, `set_bars({"STAY_BEHIND_JAB": 74.0, "OFF_THE_ROPES": 22.0,
  "GO_TO_THE_BODY": 91.0, "TIE_HIM_UP": 46.0, "TIME_THE_COUNTER": 55.0, "STEP_ON_THE_GAS": 68.0, "KILL_THE_CLOCK": 5.0})`:
  six buttons exist in bar order 91 / 74 / 68 / 55 / 46 / 22 (KILL_THE_CLOCK, the lowest, is left out); the 22 button text has "(!)"
  and its tooltip contains "BLUNDER"; the 91 footer says "DRILLED"; every button rect lies inside the 1400 x 146 frame and no two
  intersect; `set_state(1, 4, 10.0)` disables all six and shows "COOLDOWN"; `set_state(1, 4, 0.0)` enables them and shows 3 of 4 pips
  filled; pressing key 2 emits `shout_pressed("STAY_BEHIND_JAB")`.
- CONTROL: with no `set_bars` call (or an empty dict) the bar has today's three buttons (OFF_THE_ROPES / GO_TO_THE_BODY / TIE_HIM_UP)
  - the existing `tests/shout_bar_test.gd` must stay green unchanged.
- Run: `tests/shout_bar_test.gd`, `tests/shout_live_test.gd`, `tests/shout_dock_test.gd` - all pass. Parse gate:
  `python Godot/tools/check_scripts.py <every .gd you touched>`.
- PR body lines: `RESULT: tests/shout_dock_test.gd -> SHOUT_DOCK failures=0` and the two existing tests' pass lines.

## Prior research
`python Tools/prior_research.py shout dock HUD`: CORNER_SHOUTS_VERDICT_S250.md (the verdict), K_HUD2_KALLI.md (HUD principles: related
values together, never over the primary action). Plain `--script` tests are the OFF control arm (as_game turns switches on).

## What would a human do?
A trainer on the apron has a handful of calls his fighter actually knows; the player wants to see at a glance which calls are drilled in
(green) and which are a gamble (red, with the odds), and whether he can call again yet.

## Prefab check
Godot UI from the project's own UIKit/UITokens (read `scripts/UIKit.gd` `button`, `block`, `label`); no asset, no library.

## Contract
OWNS: Godot/scripts/LudoShoutBar.gd, Godot/scripts/FightWorldLiveScreen.gd (_sync_shout_bar only), Godot/tests/shout_dock_test.gd
RED_TEST: Godot/tests/shout_dock_test.gd -> SHOUT_DOCK failures=0 (fails on master: no set_bars)
REGRESSION: shout_bar_test, shout_live_test
VISUAL: yes - Claude takes the fight still (still_framing, as_game) and the operator closes it

## The trap
GDScript `:=` cannot infer from a Variant (Dictionary values) - type it. Read GDSCRIPT_TRAPS.md. Never delete or weaken a test check.
Never `_console.exe`. Work on branch cursor/issue-<n>, open a PR, never merge.
