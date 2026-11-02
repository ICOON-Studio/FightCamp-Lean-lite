# LADDER1 - the career level ladder replaces the fame gate (operator D32: "go with 5 and 7")

Model: Cline (free OpenRouter seat), worktree E:/FightCamp/wt/CLINE, branch cline/seat (rebase on origin/master first).

## Why (operator 2026-10-03, verbatim)
"the fighter needs 3 wins to be able to access the national tournaments each loss brings him back a bit at the
rankings, then another 3 wins in national (same logic applies with losses), and then he can get offers from low tier
to higher tier international tournaments depending on his ranking". Ruled numbers (D32): **5 net wins at REGIONAL ->
NATIONAL, 7 more net wins at NATIONAL -> INTERNATIONAL**. Full design: `research/S148_SCHEDULE_TUTORIAL_DESIGN.md`
lines 57-85 (read that window first).

## Prior research
G101 (amateur grade ladders: England Boxing ~5 contests, DBV class C < 7 wins, B <= 14) anchors 5 and 7; J59 (15
games' ladders); the S148 Explore map in the design doc above. Today the gate is FAME only and fame never falls.

## What would a human do?
A designer would keep ONE data file with the numbers, add one per-fighter counter settled where the fight result is
already settled, and show the player "3/5 wins to NATIONAL" wherever the fighter's level is shown.

## Prefab check
None - this is our own career rule on our own data; no library applies.

## Owned files
- `Godot/scripts/GameState.gd`
- `Godot/scripts/FightGate.gd`
- `Godot/scripts/VenueLadder.gd`
- `Godot/assets/data/career_ladder.json`
- `Godot/tests/career_ladder_test.gd`

GameState.gd is 18,275 lines - NEVER read it whole. Use `sed -n` windows around these anchors only:
`const FIGHT_TIERS` l.213, `static func empty_gym_start` l.4525, `func get_fight_offers` l.7964 (offers loop l.8000-8060),
`func get_fight_tier_fame_requirement` l.8065, `func book_fight` l.13656, `func get_amateur_read` l.14432, and the
ranking settle `athlete["ranking_points"] ... + 24` at l.15578 (and its sibling at l.12153). FightGate.gd (253 lines):
the fame check l.36-40. VenueLadder.gd (55 lines): `level_for` l.26.

## Spec
1. `career_ladder.json`: `{"regional_to_national": 5, "national_to_international": 7, "loss_progress": -1,
   "loss_ranking_points": -12, "_source": "operator D32 2026-10-03; G101 anchors"}`. Read it once (cache).
2. Switch `career.level_ladder`: default = `empty_gym_start()`'s value pattern (ON in the game, OFF in plain --script
   runs). OFF must leave every code path byte-identical to today (fame gate, ranking -6, offers).
3. ON: each fighter carries `career_level` ("regional" | "national" | "international", default "regional") and
   `level_points` (int, floor 0). Settle beside the ranking update at l.15578: win at or above own level +1, loss -1
   (floor 0); reaching the threshold promotes and resets `level_points` to 0. A loss also costs -12 ranking points
   (instead of -6). Amateur bouts count.
4. ON: the gate is the level, not fame - `get_fight_offers` offers only tiers at or below the fighter's level; the
   FightGate fame reason is replaced by "NEEDS NATIONAL LEVEL - 3/5 WINS" style text. Fame still drives purse/sponsors.
5. ON: INTERNATIONAL fighters get international offers by division rank: #11-15 low tier, #6-10 mid, top 5 major
   (add an international row to FIGHT_TIERS only if needed; VenueLadder.level_for already names the level).
6. ON: `get_amateur_read` (and whatever the fighter card reads from it) returns `ladder: {level, points, needed,
   next}` so the UI can show "3/5 wins to NATIONAL". Do NOT edit UI scripts - the data is the deliverable.

## The test (write it FIRST, watch it fail, then build) - `Godot/tests/career_ladder_test.gd`
Two DIFFERENT fighters (different stats/frames; never identical). ON arm: 4 net wins -> still regional, national
offers absent; 5th win -> national, national offers present; a loss -> points drop by 1 and ranking by 12; a national
fighter needs 7 more. OFF arm (control): the same sequence keeps today's fame gate and -6 (assert the OFF offers list
equals the pre-change list - capture it from the old code first). Print the population and the numbers it measured.

## Gates
Parse: `python Godot/tools/check_scripts.py <each touched .gd>`. Test: `Godot_v4.7.2-stable_win64_console.exe
--headless --path Godot --script tests/career_ladder_test.gd` (exe in %LOCALAPPDATA%\Programs\Godot\). Then
`python Godot/tools/run_tests.py --only offer,amateur,fight_gate,grade_ladder,first_job,first_months --jobs 2`.
Watchdog before each Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`
(RED = wait). Never commit *.import. Nothing opens on screen. Commit + `git push origin cline/seat`.

## The one trap
Fame is still read for MONEY in many places (purse, sponsors, members) - only the GATE moves. Grep `fame_required`
(l.2976, 8021, 8049, 13499) and change the gate meaning only behind the switch; leave every other fame read alone.
