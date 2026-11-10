# TASK FIGHTDISPLAY2 - CURSOR (Grok 4.7 High) - the live fight's two side panels from the veteran's drawing

Status: OPEN (S423, Claude main), queued AFTER FIGHTDISPLAY1 (same view; base your branch on main once FIGHTDISPLAY1 is merged).
Discipline: boxing. Model: grok-4.7-high.
Source: the operator picked the management-sim veteran's 10/10 drawing (Q-S294-174: "Use the veteran's drawing"). Part 2 of 2:
each boxer's panel at the side of the ring. Part 1 (FIGHTDISPLAY1) built the corner bar, the NOW! plate and the scorebug.

## Contract
OWNS: scripts/fight3d/SidePanel.gd, scripts/rules/EnergyForecast.gd, tests/side_panel_test.gd, tests/energy_forecast_test.gd, scripts/fight3d/FightHud.gd, scripts/fight3d/BodyPanels.gd, scripts/fight3d/CornerBar.gd, tests/corner_bar_test.gd
(SidePanel, EnergyForecast and both tests are new. FightHud.gd: only build the panels instead of HudBars' rings. BodyPanels.gd,
163 lines, moves INTO the panel, see 3. HudBars.gd is 500 lines: do NOT add a line to it; stop building it from FightHud and
leave the file, another task deletes it.)
RED_TEST: tests/side_panel_test.gd -> SIDE_PANEL failures=0
REGRESSION: hud_shown_test, holo_live_test, hit_flash_test, corner_bar_test, fight_flow_test, golden_path_test, file_limits_test
VISUAL: yes (Claude renders and judges; you cannot see images)

## The picture
docs/mockups/s422/fight_10_simvet.png and .html (left panel x 16-384, right 1536-1904, y 120-910). Critic's reasoning:
docs/mockups/s422/fight_critic_simvet.md sections 3 and 7.

## Two fixes on the corner bar (part 1, collected S424 in f3883134; Claude's look at the windowed render)
1. Before the round's first call the last-call box is an empty frame with a lone tick. Show "No call yet" in its words
   colour and no tick until a call is made.
2. The drawing (docs/mockups/s422/fight_10_simvet.png) puts the call that BEATS the opponent's game first and frames it in
   gold; today the calls keep the plan's order (a "Wrong" call first) and none is framed. Order: Beats it, Works, Wrong;
   gold frame on the first. Add both to tests/corner_bar_test.gd (each red on main first).

## What to build
1. OUR BOXER (left panel, wooden frame, WoodKit.slate):
   - the name (34 px) and the plan chip ("Plan: work the body", the round's plan words the fight already shows);
   - the figure (see 3) with ONE tag on the worst place ("EYE x", "RIBS", "NOSE"), red when that place is critical;
   - three VERTICAL bars, energy (yellow), legs (green), guard (blue), each with its number under it (30 px) and its word under
     that (20 px); the same values HudBars reads today (FightMeters); a dashed mark on the energy bar = after the call in force;
   - the key: fine / hurt / critical squares (the band colours);
   - "lasts to": a strip R1 R2 R3 with the energy line running out, from EnergyForecast (4) - the round it reaches 20 is red;
   - an ear and two pips "heard": the ear lit when CornerTrust.lands(f) (the boxer still takes the corner's word), a pip
     filled for each of the last two shouts that got through (`rec["shout"]`).
2. THE OPPONENT (right panel, mirrored): the name; the habit chip = Exchanges.MODES[mode]["label"] of the game she keeps
   playing (`rec["mode"]`, NOT rec["habit"]: that is OUR boxer's own habit, FIGHT_DISPLAY_DECISION_S419.md section 7);
   the three bars, energy as the RANGE the corner can see (e.g. "22-38", the same "?" rule HudBars uses for unscouted values:
   legs and guard "?" with a hatched bar until scouted); the figure (seen damage only); the habit card: the mode's icon,
   an arrow, a glove, and "3x" = how many exchanges this fight she played that mode; it flashes for 1 s when she plays it
   again (never a held line across the ring).
3. THE FIGURE is the S405 holo (BodyPanels.gd: the operator's own rule, "put the holo on each side and blink the area that
   gets hit"), moved INSIDE each panel at the drawing's figure place, keeping all its blinks, organ pops and colours. The flat
   bust in the drawing is the painter's stand-in for it.
4. EnergyForecast.gd, pure static, no preloads beyond rule modules, no randomness:
   `rounds_left(energy: float, drain_per_ex: Array, pace: String, ex_left: int, rounds_after: int) -> Dictionary`
   -> {"by_round": [energy at the end of this round, of the next, ...], "out_round": the first round it is below 20 (0 = it
   lasts)}. Drain per exchange = the mean of the last two exchanges' drain (or PaceAim.spend(pace) x the plan's base cost when
   fewer than two), times PaceAim.spend(pace) / spend of the pace those exchanges were fought at; between rounds add the corner
   minute's recovery the fight uses today (grep the corner minute's energy back in LiveRound / CornerMinute; use that number,
   do not invent one). Test it with 5 cases, numbers printed: steady stays, push runs out a round sooner, save lasts longer,
   zero exchanges left, energy already under 20.

## tests/side_panel_test.gd (red on main)
Modelled on tests/hud_shown_test.gd and tests/holo_live_test.gd: a live 3D round; print and check: two SidePanel nodes, left
inside x < 400, right inside x > 1520; the left energy number equals the live round's her_energy for this exchange (rounded);
the opponent's legs read "?" in a bout with no film study and a number with full study; the habit card's count equals the
number of exchanges so far with that mode; a BodyPanels holo is a child of each panel; the worst-place tag names the place with
the lowest band; every Label >= 20 px, none clipped. Print `SIDE_PANEL failures=N`; run each check once on main and say which
went red.

## Prior research
FIGHT_DISPLAY_DECISION_S419.md section 7, docs/mockups/s422/FIGHT_CRITICS_VERDICT_S422.md, scripts/fight3d/HudBars.gd header
(FightMeters, the "?" rule), BodyPanels.gd header, scripts/rules/CornerTrust.gd, scripts/rules/PaceAim.gd, GDSCRIPT_TRAPS.md.

## What would a human do?
Give each boxer one card, like a driver's car panel in a race manager: body, tank, and how long the tank lasts.

## Prefab check
None: our own pieces.

## Rules
WoodKit pieces and colours only. Nothing under 20 px. No file over 500 lines. Change no rule module except the new
EnergyForecast. Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver
Dummy --path . --script <script>`. Never "he" or "she" in text.

## The one trap
The opponent's numbers are what the CORNER can see, never her true values: a range or "?" until the scouting rule says the
corner knows. Read the value the old HudBars showed, never the bout's raw dictionary.

## Result lines (PR body)
RESULT: tests/side_panel_test.gd -> SIDE_PANEL failures=0
RESULT: tests/energy_forecast_test.gd -> ENERGY_FORECAST failures=0
RESULT: tests/holo_live_test.gd -> the test's own pass line
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
