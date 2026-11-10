# TASK FIGHTDISPLAY1 - CURSOR (Grok 4.7 High) - the live fight's corner bar, NOW! plate and scorebug from the veteran's drawing

Status: OPEN (S423, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator picked the management-sim veteran's 10/10 drawing for the fight display (Q-S294-174: "Use the veteran's
drawing"). He chose it over Claude's "hint, not a grade" proposal, so THE CALLS ARE GRADED as drawn (Beats it / Works / Wrong).
This is part 1 of 2: the bottom corner bar, the NOW! plate and the scorebug. Part 2 (FIGHTDISPLAY2) is the two side panels.

## Contract
OWNS: scripts/fight3d/CornerBar.gd, scripts/fight3d/NowPlate.gd, scripts/fight3d/ScoreBug.gd, scripts/fight3d/ShoutBar.gd, scripts/fight3d/FightHud.gd, scripts/fight3d/FightView.gd, tests/corner_bar_test.gd
(CornerBar, NowPlate, ScoreBug and the test are new. FightView.gd is 498 lines: change only the lines that build or call the
old shout bar / scorebug, and it must end at 500 or fewer; move code out into CornerBar.gd if needed.)
RED_TEST: tests/corner_bar_test.gd -> CORNER_BAR failures=0
REGRESSION: hud_shown_test, hit_flash_test, holo_live_test, fight_flow_test, golden_path_test, file_limits_test, words_on_screens_test
VISUAL: yes (Claude renders the live round and judges it; you cannot see images)

## The picture
docs/mockups/s422/fight_10_simvet.png (THE LAYOUT) and docs/mockups/s422/fight_10_simvet.html (real words, sizes, colours,
positions in px at 1920x1080). The critic's reasoning: docs/mockups/s422/fight_critic_simvet.md sections 3, 5 and 7.

## What to build (1920x1080, all numbers from the HTML)
1. THE CORNER BAR (new CornerBar.gd), a wooden plank across the bottom (y 935-1075), on screen the WHOLE time a round plays
   (today ShoutBar pops up only at each 30-second exchange; the bar replaces that pop-up). Left to right:
   - PACE: Push / Steady / Save; AIM: Head / Body (the aims LiveRound.preview()["aims"] offers). Move ShoutBar's `_set_pace` /
     `_set_aim` logic here: same action strings, same effect, they stay in force between exchanges as they do today.
   - The call timer: a ring with the seconds left until the next exchange's call ("0:14"), gold when 5 s or fewer are left.
   - The last call: its words ("To the body") and a tick or a cross for each of the last three exchanges fought under it
     (`rec["call"]`, `rec["won"]` in the round's `ex` array; a call with fewer exchanges shows fewer marks).
   - THREE CALL BUTTONS = LiveRound.preview()["offers"], big (title 30 px). Under each its GRADE from
     Exchanges.fit(call, preview["sit"]): "good" -> "Beats it" (green chip), "ok" -> "Works" (amber), "bad" -> "Wrong" (red);
     then a bolt and arrows for Exchanges.CALLS[call]["cost"]: up arrows (1 per 0.75 of cost, at most 3) when it costs energy,
     one down arrow when the cost is 0 or less (it rests her). The call in force has the gold frame.
   - SAY NOTHING (a smaller button). Then 2x and skip-round (the existing FightHud.draw_buttons actions, restyled).
   At each exchange boundary the ring still slows and the player still has ShoutBar.SHOW_S real seconds to pick, no pick =
   say nothing, exactly as today: only the presentation changes, never the rule. While the calls wait, their row pulses.
2. THE NOW! PLATE (new NowPlate.gd): only while preview()["now"] is not empty. A gold plate beside the OPPONENT (x 1180-1510,
   y 640-760): "NOW! " + the combination as digits (jab 1, cross 2, lead hook 3, rear hook 4, lead uppercut 5, rear uppercut 6;
   any other move by its word), "gap open 0:03" counting down the same pick window, the bolt and cost arrows. A click = the
   shout "now" (the same as today's NOW button). It pulses; no dotted line across the ring.
3. THE SCOREBUG (new ScoreBug.gd, replaces FightHud's round box): "ROUND 2 / 3", the clock, a big red number (exchanges red won
   this round) at the left and a big blue one at the right, and six dots, one per exchange: the winner's colour, the live one an
   open ring, the ones to come dark. Tooltip on each number: "Exchanges won this round". Under it the CARDS strip: R1 R2 R3
   chips, a closed round in the colour of its judges' winner (the rounds array FightView already passes to round_line), the
   live round outlined dashed in the colour of whoever leads the exchanges, a round to come grey.

## Data (checked by Claude in code, S423)
preview(): offers, sit, now, pace, aim, aims, at, i. rec per exchange: call, won, shout, fit. Exchanges.fit(call, sit) gives
good/ok/bad. Exchanges.CALLS[k]["cost"] (can be negative). Change NO rule module and NO number; if a value you need is not
there, stop and say so in the PR body instead of inventing one.

## tests/corner_bar_test.gd (write it first, red on main)
Headless, modelled on tests/hud_shown_test.gd: start a live 3D round the way it does, run to the first call. Print and check:
- a CornerBar node exists while the round plays (before the first call too), its rect inside y 900-1080;
- it holds exactly preview()["offers"].size() call buttons + one Say nothing, and each call's grade chip text equals the word
  mapped from Exchanges.fit(call, sit) for that call (compute it in the test from the same preview);
- pressing Push sets the live round's pace to "push" (read m["live"]["pace"]);
- with a set-up whose gap is open (build the bout so preview()["now"] is not empty, as the existing NOW test does: grep "now"
  in tests/), a NowPlate is visible and its click fights the exchange with the shout "now";
- the scorebug's six dots: after one exchange the first dot has the winner's colour;
- every Label/Button on the bar is >= 20 px, the call titles >= 30 px, and no Label is clipped.
Print `CORNER_BAR failures=N`. Run each check once against main and say in the PR body which went red.

## Prior research
ops/research/FIGHT_DISPLAY_DECISION_S419.md (section 7, the data check), docs/mockups/s422/FIGHT_CRITICS_VERDICT_S422.md,
ops/research/CRITIC_PACK.md (the calls, pace and aim), scripts/fight3d/ShoutBar.gd and FightHud.gd headers,
ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Put the corner's standing orders and its three shouts where the thumb rests, the way Motorsport Manager's pit wall keeps
tyres, fuel mode and the next call at the bottom, and make the rare gap pop next to the opponent who opened it.

## Prefab check
None: our own pieces (WoodKit planks and buttons, UI.button, the existing shout logic).

## Rules
Look: WoodKit pieces and colours only (WoodKit.INK, SOFT, HEAD, UI.GREEN / RED / AMBER, red #e2483d, blue #3a7ce0). Nothing
under 20 px. No file over 500 lines. Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe>
--headless --audio-driver Dummy --path . --script <script>`. Never "he" or "she" in text: the boxer's name or "the boxer".

## The one trap
The pick window is counted in REAL seconds while the ring is slowed (ShoutBar._left), not in round seconds. The bar's timer,
the NOW! countdown and the pulse must read that one counter, or they drift apart at 2x.

## Result lines (PR body)
RESULT: tests/corner_bar_test.gd -> CORNER_BAR failures=0
RESULT: tests/hud_shown_test.gd -> the test's own pass line
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
