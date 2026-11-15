# S494 handover (written 2026-11-15 at the end of S493)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S494`.

## FIRST - ANIMATION ITEM: BODYLOOK1 runs in its own Fable session
Session "BODYLOOK1 on Fable: body seams, shoulders, walk" (local_43234449-27fa-4767-ae29-8f567b15015c, worktree
.claude/worktrees/judges1-830186, branch claude/confident-chaplygin-6b0d8f). It was waiting on a Godot slot at S493's end
(the PC was RED: his ArcheAge game held the memory). Collect from ITS PR, open every before/after still yourself.

## BOARD QUESTIONS WAITING ON HIM (quote his answers, act)
- Q-252 Training K v4 (his 3 marks done) - build it as drawn? docs/mockups/s493/training_k/training_k_v4.png
- Q-253 rival club card, option C made simpler - build it? docs/mockups/s493/overview/overview_C2.png
- Q-254 may the Miro P0 redraw delete its 16 empty card slots? If yes: `python ops/Tools/where_we_are.py svg` -> one
  canvas_update_from_svg (the cards were updated in S493, the canvas was NOT redrawn).

## SEAT ANSWERS TO COLLECT (start prints them)
- SQ185 Dola + SQ186 John: COACHSPEC1 round 4 (map ops/research/COACHSPEC1_MAP_S490.md section 12). Both depth 7+ and
  general 7+ -> his board with the map (`ask --attach`); else round 5.
- SQ187 Kalli: LADDER1 v4 (his Q-250 "make it so player can deicde whos the best opponent ... and apply rules") -> then two
  fresh critics (7+) before his board.

## QWEN (queued; launches when the watchdog is not RED)
- PALETTEGUARD1: tests/palette_guard_test.gd + baseline. At collect, add `palette_guard_test` to tools/run_tests.sh.
- CLASH10: glove-on-glove cleared on the drawn axis, re-read after each push, inside the clash pass (from main). Open stills.
- STYLE5 (launched S490 era, branch qwen/style5): check its PR.

## ONELOOK1 - THE PALETTE SWEEP (his Q-251 "do it and i will judge")
Done S493: scripts/ui/Palette.gd; UI.gd, WoodKit.gd, TV.gd read it; zero loose colours in areas/Office.gd, HeadlineCard,
CornerSwapCards, TapeVersus, ResultTabs, CallButtons, ApproachCard, RecoverCards, BodyTip, SwapLink, AftermathTiles,
MatchStats, Tally, DarkOverview, BodyFigure, Tips + the native tooltip. Words on slate in fill green/red take the word colours.
Left, worst first: WhiteboardKit (about 10 screens use WB.INK / WB.PENCIL and GaugeRow switches by WoodKit.on_dark - move
the board to slate and its inks to TEXT / MUTED in ONE change with stills), WeekCards 34 (552 lines - split it too),
HudRegroup 27, HudBars 26, RosterCards 22, ReadPanel 18, MatchupCards 16 (hex strings typed as String params), MatMap 16,
GrapplerPage 13, RoundGraphics 12, HomeNeeds 12, DrillCard 12. Then before/after stills of the gym, Office, Overview, result
page, Training to him (render on the hidden desktop: tools/layout_snapshot.gd) + review_add.py.

## TESTS (S493)
Wave 1 (Palette/UI/WoodKit/Office): 14 pass, wood_kit_test's red-word check updated to the new rule. Waves 2-3 and
plan_bots: see the S493 commit message; any red there is the first thing to fix.

## USAGE RULES (kept)
- get_usage first; wrap up from ~310k, hand over by 420k. Godot through `python ops/Tools/godot_slot.py run --who s494 --`.
  Write repo-root .tmp_s494_*.sh runners with the Write tool (rule_guard blocks a heredoc holding the Godot command); delete after.
- His game on the PC makes the watchdog RED on memory: Godot jobs wait in godot_slot and the heat governor pauses them.
- New tests go into tools/run_tests.sh's list.

## Known reds (NIGHTLY1): block_meet B_A pro_left_hook control row. plan_bots: fixed S493 if its line below says so.
