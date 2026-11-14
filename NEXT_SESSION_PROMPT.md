# S465 handover (written 2026-11-14 at the end of S464; S463's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S465`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item. The watchdog went RED on RAM most of S464
  (his game, 8+ GB): no new Godot job on RED; the heat governor pauses running ones.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> integrate first.
- S461 greybox: each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).

## FIRST
1. TREEVALUE1: the last S464 run (any-time sweep) may have finished after the handover - read
   ops/AgentComms/treevalue1_s464.log. Each swept node is planned with no "when" there; a node still reading the same at 0 and
   70 sits on a card bouts never reach. docs/TREEVALUE1_RESULT.md is written by that run; commit tools/treevalue_probe.gd +
   the page (both uncommitted on main). Earlier runs: treevalue1_s464_floor / _shared_when / _own_when .log.
   Herd/Push off merge (PROGRESSION_MAP line 96) is NOT decided until CARDVISIT1 says which cards are reached.
2. CARDVISIT1 (Qwen, ops/research/TASK_CARDVISIT1.md, dispatch queue, launches when the watchdog leaves RED): collect,
   RERUN on the same seeds, diff the page. Cards never reached -> the card chain / answer table is the design question.
3. LANDREACH1 (ops/research/TASK_LANDREACH1.md): red since the POWER1 merge 74a910de; step 1 = the rear glove on the game
   camera (tools/hit_frame_film.gd). Worktree E:/FightCamp/wt/LEAN_BISECT (detached) is free for it - put it on main first.
4. Seat answers: SQ96 fight week v8, SQ98 club week v5, SQ104 weight r2 (John) - each is DESIGNED if John gives 6+/6+ (Dola /
   Kalli already did). SQ106-107 TURNPRO1 v1 critics, SQ108 Knowledge v3 (Kalli), SQ109 coach fit v6 (Dola).
5. His board: Q-220 R58, Q-222 HOSTSHOW1, Q-223 PUSHTANK (all designed, build after the fight week).
6. Export a build (S464 exported none).

## DONE IN S464 (ops/research/S464_DIGEST.md)
- STEPPLAN1 fixed: CoachPlan skips steps under Usable; plan tests use drilled bars (31d00e44).
- TREEVALUE1 probe made valid (calibration, full fighters, mutant arm); 7 nodes never consulted - the card + when rule.
- LANDREACH1 bisected; PUSHTANK v2 designed (Q-223); traits never move (TraitLine.crossed has nothing to wire).
