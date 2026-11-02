# S326 digest - Lean update 29 part A: the weekly load choice (2026-10-31, same session as S325, operator "Keep going here")

## What now works (Lean e92b91d, pushed; NOT exported yet)
- Bouts.gd split at the 500-line cap: fight night -> scripts/state/BoutNight.gd (305 lines), Bouts keeps offers/camp/weigh-in
  (262) with one-line delegates (no caller changed). 9 fight-path tests green.
- Training page "Load" row per fighter: Rest / Light / Normal / Hard (hours 3/6/10/15, gains x0.25/0.6/1.0/1.3), the gauge
  "Load 1.5x her usual - injury risk 3x" coloured green/amber/red; disabled while injured. Stored f["load_setting"]; a camp
  starts Hard (the plan: "the risk is the point"), Normal again after the fight. Injuries.setting/ratio read it; Sim's gains
  multiply by it.
- Defect caught before shipping: the act was named "load", which Main already uses to load a saved career - renamed
  "trainload" (the harness had been reloading the save every stop).
- Qwen CHAMPDRAW1 collected (CHAMP_DRAW 0; in run_tests.sh). Qwen BOUTBURN1 running (per-round part burn from the settled
  exchanges through BodyLoad, for the body report). John J-PRODEBUT1 answered (committed; sourced debut costs).

## Evidence
- Harness n=40 x 26 weeks (careless gets hard_weeks at p=0.5; sensible trains Normal, rests the week after a bout, comes back
  through Light): careless injured 50 %, sensible 60 %. Always-Hard alone barely moves it (10/19 vs 10/21): the 4-week average
  catches up and the ratio returns to 1.0.
- The model defect: a rest week (3 h) drags the 4-week average down, so the Normal weeks after it read as a spike (10 / 7.25 =
  1.38) and resting RAISES injuries - against the plan's "a rest week brings the ratio down". Next session decides how
  "her usual" is counted (EWMA chronic load or a floor) from the ACWR literature, then reruns the bounds.

## Decisions (Claude, developer)
- Update 29 split into part A (choice + gauge, this commit) and part B (body report) - part B needs BoutBurn (Qwen).
- The load model fix waits for evidence, not a tweak to hit the bounds.
