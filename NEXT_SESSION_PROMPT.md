# S453 handover (written 2026-11-13 at the end of S452; S451's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S453`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 300k context. At most TWO helper sessions.

## LATE S452 (after the first handover)
- He approved deleting the 16 stale cards on the P0 frame ("yes delete the 16 stale miro cards"). Miro's server errored on EVERY call
  (update, delete-only, board_show) while the connector read "connected": send the full wwa.svg WITH its data-deleted lines first thing.
- STEPMASTERY1A collected (a8b46b2e, StepMastery.gd + test green). Next: wire it (STEPMASTERY1, below).
- Kalli SQ61 on COACHFIT1 v1: Depth 5 / Play 5 -> below 7 -> write v2 from her "To reach 10/10" list (ops/research/COACHFIT_CRITIC_S450_KALLI.md).
- He: "use dola more its free". Dola (Cici) relaunched with its debug port (it was auto-started without it). SQ43 dropped (stale);
  SQ66 (fight week v5) sent, SQ67 (COACHFIT1) queued. Keep Dola on every critic round as the free third critic.
- Maria: no stills to her until there is a public link (Miro); queue the S452 HUD stills to her then.
- He asked "why did you stop so early?": S452 wound down at ~240k of the 300k cap. Use the cap fully; wrap-up needs ~25k.

## FIRST: Miro
He reconnected the Miro connector in S452, but every canvas_update_from_svg still returned "The connector's server returned an error",
even a one-line legend update. Try once: `python ops/Tools/where_we_are.py svg > E:/FightCamp/tmp/wwa.svg`, strip the
data-deleted="true" elements (16 surplus widgets - deleting needs his OK), send the rest inline. If it still errors, tell him once.

## RUNNING (collect first)
- (COLLECTED) **Qwen STEPMASTERY1A** (wt/LEAN_STEPMASTERY1A, branch qwen/stepmastery1a, ops/research/TASK_STEPMASTERY1A.md): StepMastery.gd pure
  rules + tests/step_mastery_test.gd. Collect by diff + parse + that test (fast lane if only those two files). Note gain() returns the NEW
  mastery, not a delta - check shadow_gain. Then wire it (STEPMASTERY1, Claude): FireLevel.mastery_of reads StepMastery.fire_mastery,
  start values at signing, old-save migration, the plan screen's greyed "learning, n pad nights" line.
- **Grok Dev BLOCKLOOK5** (ops/research/TASK_BLOCKLOOK5.md, sent 15:24, ETA ~21:30): PR from grok/blocklook5. Bars: MATCH for the 4
  straights; block_meet <= 10, block_absorb 0, hit_carry <= 40. Collect by diff, then render the block reel and post it.
- **Critics**: SQ61/63 (COACHFIT1 v1), SQ64/65 (fight week v5) queued at Kalli/John. 7+ -> fix -> his board --attach; below 7 -> next version.

## NEXT (Claude)
1. POWER1D, the lead uppercut's tail, in-house: bars in TASK_POWER1C.md (OVER_HEAD, ELBOW, FOLLOW, BACK <= 9.6 m/s, PATH). Qwen's PR 253
   (closed) has a usable test skeleton (tests/uppercut_tail_test.gd on qwen/power1c) - its fix did not work. Approach: cut the clip's tail
   after the drive through the chin and blend home elbow-down; no fourth reach-solve variant. Film seed 4242 + 3 seeds on the game camera.
2. PROGPROBE1R3 to Goose.

## WAITING ON HIM
- His look: the S452 fight HUD (review board), the office desktop, the block reel round 3, camp v3, the result tabs.
- His ear: the voices, the PA mix.

## TRAPS (S452)
- Still runs hide parse errors: pass `--log=<file>` to tools/hidden_desktop.py and grep SCRIPT ERROR before judging a still.
- gbot `--file` is relative to ops/ (research/TASK_x.md).
- rule_guard sends every Godot job through `python ops/Tools/godot_slot.py run --who <session> -- <cmd>`.
