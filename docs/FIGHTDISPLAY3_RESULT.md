# FIGHTDISPLAY3 result

Brought the two wooden side panels from PR 177 onto today's main, then fixed what the windowed run showed. CornerBar.gd was left as S427 rebuilt it.

## 1. What came across

From `refs/pull/177/head`, and nothing else: `SidePanel.gd`, `EnergyForecast.gd`, `tests/side_panel_test.gd`, `tests/energy_forecast_test.gd`, and that branch's edits to `FightHud.gd` and `BodyPanels.gd`. The gold "best call first" corner-bar change stayed out.

## 2. The script error

A windowed round printed, twice: `SCRIPT ERROR: Invalid call. Nonexistent function 'stamina' in base 'Node (Host)'`.

The call is `FightCast._bell_energy` (lines 171-175). At the bell it does `view.bars.stamina(side)`. On main, `HudBars.stamina` (lines 218-220) was that function: the stamina fill from `FightMeters.bars`, times 100, or -1 before the first paint. `FightHud.build` now sets `view.bars` to SidePanel's host, which had no `stamina`.

Read for what the view actually offers:

- `FightView.play_round` (from line 208) and `FightView._queue` (from line 258). The view has no `stamina`, `legs` or `guard` function. Energy is `_profiles["a"/"b"]["energy"]` and `energy_end`, lerped across the exchange from the live round.
- `HudBars._source` (from line 245) is where legs and guard come from: body-map places plus BodyBurn, passed through `FightMeters.bars`. Stamina's fill is that same source's energy.

The host now keeps the stamina fill the panel just painted (`FightMeters.bars(...)["stamina"]["fill"] * 100`, -1 before the first paint) and `stamina(side)` returns it. The corner reads the number the panel is showing. `tests/side_panel_test.gd` boots the real FightView (not a stub), calls `view.bars.stamina` on that host, and checks both sides against `LiveRound.her_energy` / `opp_energy`.

The hidden-desktop still of `tools/fight3d_play.gd` (the path that reaches the bell) printed no `SCRIPT ERROR` and no `FAIL`. `FIGHT3D_PLAY failures=0`.

## 3. The overlap

On the left panel, "critical" sat on the same rows as "lasts to". Each has its own row now: the key, then "lasts to", then R1 R2 R3, then the heard line. The test rejects any two visible panel labels whose rects intersect. The holo's own picture is not part of that check.

## 4. Symbols

The opponent's gold card was a target, an arrow, a fist and "1x". It is now one line, the game and how often she has played it: "Waiting to counter, 1 time". The card still flashes for a second when that count goes up.

The dots beside "heard" now read in words. Three dots, and "Heard 0 of 3" (the count of the last three shouts that got through). The ear is still the "does she take the corner's word" mark, with that sentence as its tooltip.

The test requires every icon outside the holo to have a label beside it or a tooltip.

## 5. The name

The name stays on the top plate, 34 px, with the corner colour as the stripe. Under it, one line. His boxer: the plan in the game's own words ("Her own game", or "Jab and move" when that is the plan). No "Plan:" prefix. The opponent: "4 wins, 2 losses" until the tape is studied, then the game the tape shows ("Pressing", "Waiting to counter").

## 6. The intention chip

`scripts/fight3d/IntentChip.gd` puts a word over each head. It uses `Camera3D.unproject_position` of the Head bone, hides when that point is behind the lens or off the view, and clamps into the open middle between the panels. It is up only while the scorebug is up, it does not take a click, the type is 22 px on a dark plate with the corner colour as the edge, and a word that just changed gets `Halo.ring` for one second.

Over her: `Exchanges.MODES[sit]["label"]` for `LiveRound.preview`'s sit (Pressing, Boxing at range, Waiting to counter, Loading up, and the rest of the modes). Over him: "Hurt" or "Tired" when `Exchanges.situation` says so, otherwise the call in force's label, otherwise nothing.

The round board's "<name> NOW" column is gone. Its width went to Landed and Your calls. `round_board_test` matches that.

## 7. The stale holo check

`tools/fight3d_play.gd` had two checks. "S382 no holo figure is built in the live round" failed on main (count 2). "S405 the side holos follow the scorebug" is the rule that holds, and it passed. The S382 line is deleted. The S405 check stays. The still log shows S405 passing at every still, and does not print the old S382 line.

## 8. The still, round 1 open, 1920x1080

Left panel at (16, 120), size 368x770:

| Label | Text | Rect |
|---|---|---|
| Name | LUCY JACKSON | (26, 138) 348x46 |
| PlanChip | Her own game | (26, 184) 348x32 |
| WorstTag | HEAD | (86, 216) 120x34 |
| EnergyNum | 100 | (148, 466) 88x40 |
| EnergyWord | energy | (148, 506) 88x28 |
| LegsNum | 100 | (240, 466) 70x40 |
| LegsWord | legs | (240, 506) 70x28 |
| GuardNum | 100 | (312, 466) 68x40 |
| GuardWord | guard | (312, 506) 68x28 |
| KeyFine | fine | (56, 544) 110x28 |
| KeyHurt | hurt | (56, 576) 110x28 |
| KeyCritical | critical | (56, 608) 110x28 |
| LastsTo | lasts to | (28, 644) 160x28 |
| LastsR1 | R1 | (28, 680) 104x32 |
| LastsR2 | R2 | (142, 680) 104x32 |
| LastsR3 | R3 | (256, 680) 104x32 |
| Heard | Heard 0 of 3 | (166, 736) 200x28 |

Right panel at (1536, 120), size 368x770:

| Label | Text | Rect |
|---|---|---|
| Name | PRIYA NAIR | (1546, 138) 348x46 |
| HabitChip | Waiting to counter | (1546, 184) 348x32 |
| WorstTag | HEAD | (1766, 216) 120x34 |
| EnergyNum | 96-100 | (1544, 466) 104x40 |
| EnergyWord | energy | (1544, 506) 104x28 |
| LegsNum | 100 | (1652, 466) 72x40 |
| LegsWord | legs | (1652, 506) 72x28 |
| GuardNum | 100 | (1728, 466) 74x40 |
| GuardWord | guard | (1728, 506) 74x28 |
| HabitCount | Waiting to counter, 1 time | (1552, 652) 336x48 |

"critical" ends at y 636. "lasts to" starts at y 644. They do not meet.

## 9. From the drawing, not built

The glove pictures, the arrow and the "3x" are words now, because a symbol the player has to decode was the thing to remove. The "Plan: work the body" chip is the plan's own words, without the "Plan:" label. The bolt beside "lasts to", and the little pictures over the three tanks in the mockup, are not on the panel: the words energy, legs and guard sit under the numbers. The drawing's two heard dots are three dots plus "Heard N of 3". The eye that was meant to pop over a glove in the ring (the old decision's hint 5) was not part of this round.

The meters themselves (Tank, Ear, Pip) live at the bottom of `BodyPanels.gd` so `SidePanel.gd` stays under 500 lines (465).
