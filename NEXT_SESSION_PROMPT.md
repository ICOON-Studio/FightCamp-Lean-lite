# S464 handover (written 2026-11-14 at the end of S463; S462's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S464`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> integrate first; no menu design.
- S461 greybox: each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons; final menus after.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).
- S463 Q-221 "Yes, greybox it": the what-to-learn-next pick is built (below).

## FIRST
1. Collect TREEVALUE1 (Qwen, qwen/treevalue1, ops/research/TASK_TREEVALUE1.md, launched 03:53, ETA ~05:15). RERUN on the same seeds
   (worktree E:/FightCamp/wt/LEAN_TREEVALUE1, `--path` it through godot_slot) and diff the page before reading. Check its bouts have
   NO fire_level key and its probe_off control shows no step value. Nodes under 1.5 in 100 against every style (Herd, Push off are the
   suspects) -> PROGRESSION_MAP line 96 says they merge into Cut off / Tie up; he approved that map, so a merge is built, then reported.
2. Seat answers -> design_loop.py next rounds: SQ91 LIVERRIBS v2 (John), SQ93-94 Knowledge v2 (Dola, Maria), SQ95-96 fight week v8,
   SQ97-98 club week v5, SQ99-100 coach fit v5 (cut at section 12 - flagged), SQ101-102 push/tank v2, SQ103-104 weight r2, SQ105 Kalli
   writes TURNPRO1 v1 (then two critics). Two critics 6+/6+ = DESIGNED -> his board with --attach.
   Knowledge DESIGNED -> build step 3 (reads and exposure into training, bouts, week; greybox on existing screens).
   Club week DESIGNED -> re-measure tools/loyal1_probe.gd before wiring Loyalty (#6) + ClubDeal (#11).
3. His board: Q-220 R58 (a fighter leaves), Q-222 HOSTSHOW1 (both designed; build after the fight week), POWER1E look.
4. Watch: new boxers' step_back/pivot/tie_up start at 0 and never fire until studied (the gate). If his play says early plans feel
   dead, StepMastery.start_values is the lever, not the gate.
5. PRs 259-266 stale/collected - `gh pr close` is blocked: he closes them or allows it.

## DONE IN S463 (ops/research/S463_DIGEST.md)
- LEARNPICK1: StudyWeek.gd + WHAT TO LEARN NEXT on her page + study act + DrillWeek study slot; study_week_test, study_pick_walk_test.
- STEPMASTERY1 gate on (FireLevel reads step bars); MoveBook shows step tiers; plan_bout/fight_why/phase_wire fixtures updated.
- KNOWBOTS2 VOID -> KNOWBOTS3 PASS (rerun identical). NODEREAD1 collected. HOSTSHOW1 v4 designed. Build exported, WHAT_TO_TRY S463.
