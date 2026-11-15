# S495 handover (written 2026-11-15 at the end of S494)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S495`.

## FIRST - ANIMATION ITEM: BODYLOOK1 runs in its own Fable session
Session "BODYLOOK1 on Fable: body seams, shoulders, walk" (local_43234449-27fa-4767-ae29-8f567b15015c, branch
claude/confident-chaplygin-6b0d8f, PR 320 open). Collect from ITS PR; open every before/after still yourself (game camera).

## WAITING ON HIM
- Q-255 Training K v5 (his Q-252 mark 1 done: no opponent / win % on the Training screen): docs/mockups/s494/training_k/
  training_k_v5.png. On "Build it": build Training K (WeekCards.gd is the current week board, 552 lines: the build replaces or
  splits it). The win chance moves to the fighter's own page.
- His answer on a fight-analysis page for our fights (his Reddit video: strike log + click to seek, landed/thrown, combos,
  vulnerabilities; our sim already logs every punch). If yes: design map first (critics 7+), then mockup.

## SEAT ANSWERS TO COLLECT
- SQ188 Dola + SQ189 John: LADDER1 v4 critics. Both depth 7+ and general 7+ -> his board with the map (`ask --attach`); else
  v5 to Kalli with both critiques inlined (the seats cannot read the repo: inline everything, see DESIGN_COACHSPEC1_R5_REVISE_KALLI.md).
- SQ190 Kalli: COACHSPEC1 round 5 (John 7/6/6's four points) -> two fresh critics.

## AGENTS
- Qwen CLASH10 (glove clipping, worktree E:/FightCamp/wt/LEAN_CLASH10, ETA 22:32 on 11-15): open every still before any merge.

## ONELOOK1 - THE PALETTE SWEEP (his "do it and i will judge")
palette_guard_test is in the suite: the raw-colour count may only fall (649 now). After each file: run it with `-- write`.
Worst first: HudRegroup 27 + HudBars 26 (fight HUD: stills via tools/fight3d_play.gd on the hidden desktop), RosterCards 22,
ReadPanel 18, MatMap 16, MatchupCards 15, WhiteboardKit 13 (~10 screens switch ink by WoodKit.on_dark - change + stills
together). WeekCards 33 waits for Training K. Before/after stills to him + review_add.py.
UI.gd 41 and WoodKit.gd 34 are the kits themselves - leave for last.

## KNOWN GAP
- His text size is Largest. TextScale.overflow checks words against boxes, not a page against 1920: the Overview ran to
  2111 px unseen. Add a page-width check (any visible Control ending past x 1920) to the layout_snapshot audit at text=3.

## USAGE RULES (kept)
- get_usage first; wrap up from ~310k, hand over by 420k. Godot through `python ops/Tools/godot_slot.py run --who s495 --`.
  Repo-root .tmp_s495_*.sh runners (Write tool), deleted after. Windowed renders: tools/hidden_desktop.py with --log=<file>.
- New tests go into tools/run_tests.sh's list.

## Known reds (NIGHTLY1): block_meet B_A pro_left_hook control row.
