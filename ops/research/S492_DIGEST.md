# S492 digest (2026-11-15)

## What changed
- **WHYGRADE1 closed (fight_why green).** Qwen measured the drop (good plan GOOD 375 -> 278 of 540 since CARDFIX1) and
  pointed at the missing outside answer to a counter-puncher. Claude's probe rounds (`tools/why_fires_probe.gd -- <plan>`,
  now takes `move:when` lines) found the real cause: the test plan's lines had NO WHEN, so since situations happen where
  the boxer stands they fire on every situation at their place. Biggest loss: any-time tie up on a merely TIRING opponent
  inside, 36% won against 49% with no plan (-64 exchanges). Grades of 540: old plan 278; feint for pivot_out 214 (an
  any-time feint fires on pressure too); without step_back 18; tie up only when she is tired 326; + feint when she counters
  333; + body-head hook when she tires inside 411 (5 lines without feint 400). The test's GOOD is now that 6-line plan (a
  first hired coach holds 6 lines: Reid 58 -> PlanBoard.arrow_limit), 3b-3 drilled like the 1-1. Result 411 / bad 2.
  Why the 05:00 review's feint try changed nothing: feint is a step and the test never drilled it.
- **ROPESCONTRACT1 collected** (Arena PR 317 closed, test on main as is): PASS on main; 5 of 5 mutants red (ROPES_AT 4: 13
  fails; pivot_out not clearing: 2; planned ignored: 6; close drops the count: 2; corner line at 0: 1). In run_tests.sh.
- **COACHSPEC1 round 3** (`ops/research/COACHSPEC1_MAP_S490.md` s11, probe `docs/mockups/s490/coach_spec/probe_coachspec_r3.py`):
  John's 12 faults each answered - better-of S&C rating (Hale + S&C now +1.4 / +2.2, never lower), group x1.15 needs 2-6,
  one runner per morning, your held pad night costs 2 of your 4 and max 1 a week (cost 1 was near free: -1% stats for a Sharp
  move 3 weeks sooner; at 2 it is -1.9%), mobility cut as a choice (worth 0.009-0.021 vs 0.099 a fighter-week; the injury cut
  stays automatic), corner reads the corner man's sparring rating, two boxing coaches defined (the moves route: first Sharp
  week 5 not 10 for +$380), BJJ promotion follows the IBJJF (brown-belt coach caps the athlete at purple; sources CHECK).
  Fresh critics queued: SQ183 Kalli, SQ184 Maria (no earlier scores in their briefs).
- **Ziva on BODYLOOK1** (his defects 6-7). Its worktree sat on an old commit: dirty project.godot parked on local branch
  wip/ziva-s492, moved to origin/main d61c6d0d, editor started hidden. TASK_BODYLOOK1.md got its missing Contract block.

## Lessons
- Ziva's chat dropped a long FIRST message in a new chat (the title came from it, the model never saw it: "I don't see a
  BODYLOOK1 brief"). Send a short first message naming the brief's absolute path; details as a follow-up.
- Windows: an output file name with ":" writes to an NTFS stream - sanitize probe arguments in file names.
- Never queue a mutant job (it edits scripts) while a probe pair that loads those scripts may still start.
- The operator's game (ArcheAge, ~8 GB) turns the watchdog RED on commit memory; godot_slot waits silently.

## Not done / open
- Miro P0 redraw: the svg (16 surplus card slots marked deleted) waits on his yes to delete them.
- Board Q-248..251 unanswered. No game code changed this session (tests, tools, docs only): no export, WHAT_TO_TRY unchanged.
- No Arena pure module launched this session (budget went to the probe rounds).
