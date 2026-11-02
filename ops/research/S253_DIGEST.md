# S253 DIGEST - 2026-10-18 - FIGHTLINK steps 1-5 shipped; corner shouts learned in the gym and called in the bout

Model: Opus 5.5. Stage: FIGHTLINK (operator S248: "Go - build FIGHTLINK in that order").

## What now works
- **Punch mastery on the profile** (Cursor REPGRID1 #257, collected by diff): TECHNIQUES rows carry a tier badge ("SHP 71"),
  the inspector a line "SHP M71 windup -7% power +9% recovery -10% slipped -13%". 3bdff15f. Still: docs/previews/s253_repgrid1.
- **The chief second's three lines ON the corner card** (Ludo r118, LUDO_R118_VERDICT.md): one workspace shows the cutman JOBS or
  the TALK (HIM gold / YOU oxblood / GAS blue rows, ADOPT picks the line's order in the 8-order grid); TALK takes over at 20 s on
  the live clock with a typed reveal; towel in the header. 4fa81686. Stills: docs/previews/s253_corner/talk.png, jobs.png.
- **CornerLines recalibrated on our engine** (tools/corner_lines_probe.gd, probe20, 114 bells): opp whiff 0.40->0.14, whiff
  stamina 6->0.25, leak share 0.80->0.65, clean power 4->7, head drop 8->14. S2_HEAD 81/114 -> 37/114; whiff/leak/burn now fire
  4-15%. db52b93e. Research: CORNERLINES_PROBE20_S253.txt.
- **Camp sharpness = +10% execution speed** (Q-S249-2): gameplan_readiness -> faster recovery + smaller slip chance. b0cd1daf.
- **Learned corner shouts** (Q-S249-3, switch `corner_shouts` GAME_ON): a fighter with drilled bars answers a call by his bar
  (clean / late 3.5-5 s / ignored / blunder), 25 s rhythm, 3(+1) calls; the club day grows the bars per station (x1.35 coach),
  the week decays undrilled calls; the 7 new r117 calls move FightLink accuracy/evasion + counter-risk for their window.
  8b4e5a10, b4bf7371, 87a53077, 97f17aa7.
- **select_mult dropped** (decision on MoveMastery.effects, cc813170). **Ops board** core-flow chart capped (operator screenshot
  "???": one core tile filled the screen under load), 44ae6d91.

## Evidence
- REPGRID1: repertoire_rows_test failures=0, profile_techniques_uicards1 total=20 fails=0; still opened.
- Corner card: corner_card_wired_test r118 checks (three rows, ADOPT lights the grid, no overlaps in TALK and JOBS - this check
  would have caught the overlaps on the S253 "before" still); 8 corner tests green; stills opened.
- Sharpness: bout_wear_wire_test sharp arm red before, green after (149 -> 143 slipped, connect 40.4 -> 41.0%), control identical.
- Shouts: corner_shouts_wire_test (control identical, drilled clean, raw fails, 25 s rhythm, late lands 4.5 s, intent + window),
  shout_training_test (rules + game file_visit ON/OFF), corner_shouts_test; shout + fightlink suites green.

## Decided (Claude as developer)
- Ludo r118 built inside the approved feature; NOT built (new mechanics): crew AP, two orders 60/40, new auto-picks.
- Line -> order map keyed on CornerLines rule_id (CornerPitStopPanel.LINE_RULE_TO_ORDER).
- The whiff line names misses, not stamina (our misses cost 0.1-0.3 tank).
- Raw shout failure odds 20/50/30 -> 10/80/10: the verdict's own target (~2 blunders, 15-18 ignored per 30 Raw calls) measures
  2.0 / 16.3; the old split gave 4.0 / 10.3.
- An undrilled fighter keeps today's apron shout (control arm) - corner_shouts only acts on drilled bars.

## Defects fixed in passing
- Profile: the DEMO tag overprinted "needs ..." on every certified technique row.
- profile2_stills.gd hung for 4 h on a stale `TabBar` path (null -> script error); now find_child + mastery_seed.
- Corner card: coach line under the lane bars, towel/THE TRUTH over SEND HIM OUT, pace buttons bleeding through.
- FightRealtime `match "_":` (a STRING, never the wildcard) - unlevered shout effects never reached the event's intent.
- CornerShouts kept a second hand-made failure-boundary table that had drifted from FAILURE_ODDS (the HUD's odds).

## Traps found
- A headless Godot still job that hits a script error does not quit: always run with --log-file and a timeout.
- `is_visible_in_tree()` is false in headless SceneTree tests - walk `.visible` up to the panel instead.
- An unwrapped Label clamps its size to its one-line text: set autowrap BEFORE size.
- The joypad: Windows had the Logitech F310 DISABLED (code 22) - operator's to enable; the game has no controller support
  (operator S253: "No controller support for now").

## Remaining (roadmap now.next_action, S254)
1. Collect Cursor SHOUTDOCK1 (#259) + fight still of the dock.
2. Live-read ticker; 3. win-rate batch (Sharp calls vs silent corner, accept 60-65%); 4. film study pick; 5. pace/distance levers.

Delegation: Cursor REPGRID1 collected; Cursor SHOUTDOCK1 launched (#259). Engine wiring stayed with Claude (each needed this
session's trace of FightRealtime; a brief would have been as long as the code).

## HANDOFF
- last_working_commit: 781a2a2b
- in flight: Cursor SHOUTDOCK1 (issue #259, branch cursor/issue-259)
- next: roadmap now.next_action (S254)
