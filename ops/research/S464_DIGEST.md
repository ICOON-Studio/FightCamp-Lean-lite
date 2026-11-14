# S464 digest (2026-11-14, Claude Opus 5.5)

## Collected / decided
- TREEVALUE1 (Qwen, qwen/treevalue1, 81ba131c): VOID as delivered - each cell ran 3 bouts on fighters 0-2 only (not 60), the
  console divided by 3 and the page by 180 (a "pass" was one win), the mutant control was "skipped ... assumed OK", and the
  shipped opponents beat these fighters 83-100%. Fixed in-house on main (tools/treevalue_probe.gd): every fighter in every
  cell (2 bouts each, 120 a cell), each style's rating CALIBRATED so the base plan wins ~50 in 100 (51.4-53.3 vs shipped
  61.5-72.0), a real mutant arm (FireLevel.probe_off, every step VALUE 0.0 = the gate is what makes steps read), the answers
  arm varies only steps (punches at BASE), 45 = BASE. Runs kept: ops/AgentComms/treevalue1_s464_floor.log (uncalibrated),
  _shared_when.log, _own_when.log, treevalue1_s464.log (any-time sweep).
  Calibrated result: punches VALUE 9-21 in 100, pivot_out 5.8, tie_up 7.5, step_back 1.7 read; step_in, step_out, roll_out,
  feint, cut_off, herd, push_off read EXACTLY the same at bar 0 and 70 = never consulted.
  Cause traced: an arrow fires only on its own card (StrikeMap "from") at its when (PlanBoard.pick); a situation is fought on
  PlanFight.GAME_CARD[sit] and the card chains by where_next. "range" is fought on "long", step_in starts from "outside", so
  "step_in when range" can never fire; "outside" is entered only through step_out / feint. Static table in TASK_CARDVISIT1.
  The Herd / Push off merge (PROGRESSION_MAP line 96) is NOT decided on this: the probe cannot tell a dead move from an
  unreachable card. CARDVISIT1 (Qwen, queued) measures where bouts are fought.
- STEPPLAN1 (nightly red: a coach's plan worth no more than none since the S463 gate): the approved map starts a new signing's
  step_back / pivot_out / tie_up at 0, so the game keeps it; CoachPlan skips a step under Usable (her bars) and writes the
  next best answer; plan_bots / plan_test_it grade the plan with drilled bars. 31d00e44, eight plan tests green.
- LANDREACH1 (nightly red: block_meet CTRL_LANDED, rear hand 15-19 cm short): bisect in wt/LEAN_BISECT - 5769c501 0 failures,
  74a910de (the POWER1 merge, S446) 12. Not the block work. Staging the control at RangeTable.clip_m made it worse (11):
  rejected and reverted. Next step: the game camera (brief updated, contract valid).
- Design loop: 10 seat answers in. PUSHTANK v2 DESIGNED (Dola 8/7, Maria 7/6) -> his board Q-223. Knowledge v2 Dola 8/7,
  Maria 7/5 -> Kalli v3 (SQ108). Coach fit v5 Kalli 6/4, Maria 6/4 -> Dola v6 (SQ109). TURNPRO1 v1 (Kalli) -> Dola + Maria
  (SQ106-107). Fight week v8 Dola 8/8, club week v5 Dola 8/8, weight r2 Kalli 8/6: each waits on John (SQ96, SQ98, SQ104).
- Q-221 closed on the board (answered in chat S463, built).
- INTEGRATION_S459: the towel line is on Fight prep already (S461); TraitLine.crossed cannot be wired - nothing in scripts/
  writes a personality trait after signing, so the profile's "N points away" names a line no action reaches.

## Not done
- No build exported this session (watchdog RED most of the session: the operator's game held 8+ GB, RAM 93-96%).
- GLOVECLASH1 has no seat (Grok Dev not ticked); LANDREACH1 comes first anyway.
- Worktree E:/FightCamp/wt/LEAN_BISECT (detached, seeded) is still there for the LANDREACH1 game-camera step.

## Post-ship: the any-time sweep (treevalue1_s464.log, docs/TREEVALUE1_RESULT.md from that run)
TREEVALUE pass=10 fail=step_in,step_out,roll_out,feint,herd,push_off best_everywhere=none mutant_ok=yes. Planned any time,
cut_off (+1.7) and step_out (+0.8) start to read; step_in, feint (outside), herd (opp_ropes), push_off (clinch) still never
consulted - their cards look unreached; roll_out shares "inside" with the any-time tie_up arrow earlier in the plan, which
PlanBoard.pick takes first (a probe-plan conflict, not proof). CARDVISIT1 decides; no merge before it.
