# S466 handover (written 2026-11-14 at the end of S465; S464's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S466`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item. Our own windowed renders keep the PC off
  GREEN, which holds Qwen's launch (S355): batch renders, then let the dispatcher launch.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> integrate first.
- S461 greybox: each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).
- Q-220 (S465): R58 a fighter leaves: "Yes, build after the fight week".

## FIRST
1. His board: Q-224 (club show map) and Q-225 (push/tank map) - his answers to "Show me the map first". His review-board
   comments on the C388 tiles, the glove clash strip and the landed cross (LANDREACH1 step 1).
2. CARDFIX1 (Qwen, ops/research/TASK_CARDFIX1.md, dispatch queue): collect, RERUN on main, diff the page; then make the card
   table design call (PlanFight.GAME_CARD / ANSWERS) from its arms and wire it with plan_bout_test + fire_level_test.
3. GLOVE CLASH shipped (97ca0023, GloveClear._clear_arms); closes on his OK of docs/mockups/s465/clash_compare.png. If he still
   sees a glove inside a glove, film it from the side (hit_frame_film _side_cam) before touching the numbers.
4. LANDREACH1 step 2: clip pro_right_cross_c holds contact 0.400 at 16.5 cm off the face (ReachLimit / ReachDrive).
5. Seat answers: SQ91 (John, resent), SQ96/98/104 (John), SQ109 (Dola coach fit v6, cici send failed - retried), SQ111 (Dola
   Knowledge v3), SQ113/114 (TURNPRO1 v2). Update ops/research/DESIGN_LOOP_S459.md as each lands.
6. Export a build.

## NOTES
- Miro P0: NOW cards now_9 / now_10 (ids 3458764690416594183-186) were not confirmed by Miro twice in S465. If the next redraw
  fails on them again, remove those ids from ops/AgentComms/where_we_are_miro.json so they are recreated.
- hit_carry_test is red on main (34-38 failures, run-to-run noise of ~5) and block_meet 9: both predate S465 (LANDREACH1).
- Qwen CARDFIX1 launched 10:04 (runner pid 48828, wt LEAN_CARDFIX1); estimate done ~11:30 (CARDVISIT1 took ~10 min for one arm).
