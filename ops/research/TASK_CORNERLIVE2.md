# TASK CORNERLIVE2 (S224) - the corner card runs on the real clock (cloud Cursor)

Model: cloud Cursor (label `cursor`), composer default. Branch cursor/issue-<n>; never master. Read `.github/CLOUD_AGENT.md` first.
Approved: operator Q-S221-5 "Approve, build it" on `research/LUDO_ROUND63_VERDICT_S224.md` (read it all; this is part G item 2).
Step 1 is merged: `Godot/scripts/rules/CornerClock.gd` (the engine; read its API: start / step / queue / cancel / reorder / set_pace /
set_speed / send_now / lanes / result / phase / time / done, static stool_bpm, auto_send_allowed, scale_effect) and its test
`Godot/tests/corner_clock_test.gd` (shows exact use).

## What exists
- `Godot/scripts/CornerPitStopPanel.gd` (641 lines): today's FROZEN card - `present()` ~190, job cards toggled `toggle_card` ~332,
  call `choose_instruction` ~350, `set_pace` ~367, tone `choose_words` ~454, towel `press_towel` ~470 (two clicks), `confirm()` ~419 =
  SEND HIM OUT -> `FightRealtime.apply_player_corner(state, side, picks, pace)` (FightRealtime.gd ~3063; never read that file whole).
- Hosted by `Godot/scripts/FightWorldLiveScreen.gd` ~5186 (`_pit_panel`); grep there, never read whole.
- Tests: corner_panel_test, corner_card_wired_test, corner_card_copy_test, corner_pit_stop_test, pit_stop_test.

## Do (switch `corner_live_clock` in GameSwitches.GAME_ON - ships ON, read with `GameSwitches.on()`; OFF = today's frozen card exactly)
1. On `present()`: build a CornerClock; default picks = today's auto plan (CornerPitStop.auto_plan) queued per lane; the camp's call
   pre-selected as today. Rolls: draw them ONCE from the fight's seeded RNG at corner start and give the SAME list to the clock and to
   `apply_player_corner` (add an optional `rolls: Array = []` parameter there; empty = today's behaviour) so the mistake the player sees
   on screen is the mistake the engine applies.
2. `_process(delta)`: `step(delta)` while the corner is open; show the clock (big "0:42"), the phase (WALKING TO THE STOOL / WORK /
   SECONDS OUT - red pulse, #C8102E), and per lane (CUTMAN / SECOND / CHIEF) the running job with a filling bar + seconds left and the
   queued jobs as chips. A job_done event flashes its chip green, a mistake red with its risk line.
3. Player actions while the clock runs: click a job card = queue it in its lane (refused after SECONDS OUT, refusal shown); right-click
   or x on a queued chip = cancel; drag a chip left/right in its lane = reorder; Z/X/C = pace (CAREFUL / NORMAL / RUSHED, slip shown
   2% / 8% / 25%); 1/2/3 = tone; Q/E = cycle the call; SPACE or SEND HIM OUT = `send_now()` (4x, the rest of the minute plays out);
   TAB = auto-send toggle (only from the 2nd corner, and only when `auto_send_allowed(ctx)` is ok - else the reason shows);
   THROW THE TOWEL = HOLD 0.6 s (a radial fill on the button), not two clicks; ESC never throws the towel.
4. At the bell (`done()`): call `confirm()` with the clock's `result()["done"]` jobs (the old SEND path); partial jobs are listed in the
   outcome as `"partial"` (their scaled effect is a later step - do NOT apply them now). The fight resumes as today.
5. Auto-send (corner 2+): the clock runs at 10x and the card shows only the clock, the lanes and "AUTO" for ~5 s; any auto_send_allowed
   stop rule turns it off for that corner with the reason.
6. Stool heart rate: the fighter's bpm number on the card ticks with `CornerClock.stool_bpm(bpm_at_bell, t)`.

## Gate
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- New `Godot/tests/corner_live_card_test.gd` (SceneTree; prints CORNER_LIVE_CARD PASS checks=N / FAIL): ON -> after present() the
  clock is at 0, default jobs queued; stepping 6 s shows WORK; queue/cancel/reorder through the panel's public methods change
  `lanes()`; after 50 s queue is refused; send at 20 s reaches the bell 10 s later; at the bell confirm() was called once with exactly
  the clock's done jobs; the same roll list gives the same mistake on screen and in the outcome; towel needs a 0.6 s hold (a 0.3 s hold
  does nothing); OFF -> the frozen card exactly as today (no clock node).
- Existing: `python Godot/tools/run_tests.py --jobs 2 --only corner,pit_stop,doctor_live`.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form)
Red first: a still of today's frozen card. Then stills at 1920x1080 and 1280x720 from the game's own fight (`-- as_game`): the corner at
~8 s (work starting), ~30 s (a job mid-bar, one done), 52 s (SECONDS OUT), and an auto-send corner. Per still: overlaps, clipped text,
what the player reads. Not accepted until Claude opens them and the operator closes it.

## Prior research
LUDO_ROUND63_REPLY_S224.txt (part B layout, part D keys), LUDO_ROUND62_VERDICT_S223.md B (camp call gold / amber), J68 (heart rate).

## What would a human do?
Motorsport Manager's pit stop: the crew bars fill in real time, you can still change the call, the stop ends when the slowest crew ends.

## Prefab check
None: our own panel + the merged engine.

## The one trap
Today's panel resolves everything in confirm(); keep that single exit (one call to apply_player_corner per corner) - the clock only
decides WHICH jobs reach it and WHEN. Plain --script tests keep the switch OFF (control arm).
