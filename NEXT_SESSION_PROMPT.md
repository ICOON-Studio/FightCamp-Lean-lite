# S482 handover (written 2026-11-15 at the end of S481; S480's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S482`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310-330k.
- Godot jobs through `python ops/Tools/godot_slot.py run --who s482 -- <cmd>`; wrap a test in `timeout 400` (a script error
  in a SceneTree test never quits - S481 lost 10 min to one). hidden_desktop takes `--log=<path>`.
- Tests run as tools/run_tests.sh does: `--headless --audio-driver Dummy --fixed-fps 60` (block_meet: 30).
- Never `cd` into a worktree. Never type the Godot terminal-build's file name in a Bash command: rule_guard blocks the
  whole command even inside a heredoc (write such text with the file tool).
- A Python heredoc that writes GDScript: a "\\n" in a normal string lands as a literal \n (S481 broke Bouts.gd that way).
- Arena: pure modules only (no Godot in its sandbox); lite mirror `python ops/Tools/lite_mirror.py --lean push`.
- Goose by hand: `cd ops/Tools && python -c "import seat_dispatch as s; print(s.launch_goose({'task':'<ID>','source':'...'}))"`.
- Qwen by hand: `python ops/Tools/seat_dispatch.py --task <ID> --seat qwen --act` (contract OWNS must be real paths).

## WHAT S481 DID (ops/research/S481_DIGEST.md)
- THE FIGHT WEEK IS BUILT AND ON: FightWeekPlan + Frame A + Frame B, lock writes the bout; golden path
  tests/fight_week_screen_test.gd; stills on his board. Club shows weigh within the gap; no camp for club shows.
- COACHFIT2 collected; STYLE1 FAIL -> STYLE2 (Goose #302); CLASH5 finding -> CLASH6 (Qwen); Q-239 -> Q-240 drawing.
- His "why the nightly didnt run ?": it ran; start's line was the dead cloud check (fixed).

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen CLASH6 (branch qwen/clash6, wt E:/FightCamp/wt/LEAN_CLASH6, ETA ~10:30): merge bar in ops/research/TASK_CLASH6.md
  (08_jab and 09_jab 0 frames > 2 cm on seed 4242, no new CLASH frame on 4242/77, OWN 0, regression FAIL sets = main). Diff only.
- Goose PARTNERPROBE1 (#300) and STYLE2 (#302): PRs or "could not open a PR" -> fetch goose/issue-<n>.
- Seats SQ161-SQ168 (ladder critics, women's 70 kg, weight M1, coaches M1, club week v9 critics, training K spec).

## FIRST
0. Miro P0 was NOT redrawn at S481's end (context): the cards are saved in where_we_are; `roll S482`, then redraw
   (svg -> canvas_update_from_svg; 4 surplus widgets are marked deleted - the frame's own stale slots).
1. get_usage. BUILD THE PLAN FLOWCHART - his Q-240 answer in chat: "Yes, build it". One Game plan page (the list goes),
   docs/mockups/s481/plan_flowchart_v2.png, map ops/research/DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI.md; four clicks a line
   (bell box, + Add an IF from the opponent's file, pick the answer, test it); the arrows stay f["arrows"] (no second plan
   system); a golden-path test walks it. His play of the fight week is still the gate for FIGHTWEEK3.
2. Collect PARTNERPROBE1 (gate: CLOSE beats LOOSE by 3-5 in 100; miss -> tune PartnerMatch LINES/EDGE), STYLE2, CLASH6.
3. FIGHTWEEK3 (the leftovers): pull-out roll + fall-through card, Train it off / Ask a kilo, favours earned, win band.
4. Seat answers as they land.
