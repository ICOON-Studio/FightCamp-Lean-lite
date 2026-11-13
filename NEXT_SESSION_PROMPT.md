# S463 handover (written 2026-11-13 at the end of S462; S461's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S463`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> INTEGRATE1 first; no menu design.
- S461 greybox: each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons; final menus after.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).

## FIRST
1. Collect KNOWBOTS2 (Qwen, qwen/knowbots2, ops/research/TASK_KNOWBOTS2.md, launched 23:22, ETA ~00:50). RERUN the probe on the same
   seeds before reading its page (worktree E:/FightCamp/wt/LEAN_KNOWBOTS2, `--path` the worktree through godot_slot). Pass -> design
   Knowledge step 3 (reads wired on existing screens); fail again -> Knowledge redesign to the design loop with both results.
2. Seat answers SQ79-87 -> design_loop.py next rounds. SQ85 LIVERRIBS1 v2 (Kalli), SQ86 COACHFIT1 v5 (Dola), SQ87 CLUBWEEK1 v5 (Kalli,
   the LOYAL1 fix: need 2 / want 3). When CLUBWEEK v5 lands: re-measure with tools/loyal1_probe.gd (on main) before wiring #6 + #11.
3. POWER1E is on the review board (docs/mockups/s462/power1e). If he flags the inside snap (shot 03, seed 4242, f24->f25: the glove
   drops ~0.15 m in one frame when _quick_back hands her to the guard at close range), smooth that handoff in HitImpact._quick_back.
4. INTEGRATE1 state (ops/research/INTEGRATION_S459.md): 1-5, 7-9 done; 6 + 11 wait CLUBWEEK v5; 10 stopped (KNOWBOTS); 12 waits
   COACHFIT1; 13 waits AMATEURWEEK1; 14 waits the BJJ plan screen. Nothing else wireable without a new menu.
5. PRs 259/260/261 stale (collected) - `gh pr close` is blocked: he closes them or allows it.

## DONE IN S462 (ops/research/S462_DIGEST.md)
- plan_bout_test green (fixture combos at Sharp). #5 ProRead wired (ProReadWire, proread_wire_test). #9 TellWorth on the camp Film
  hover (tell_wire_test). POWER1E rear uppercut tail (uppercut_tail 0). KNOWBOTS1 rejected (invented page, rerun fails). LOYAL1 rerun
  honest, fails structurally. Build exported with WHAT_TO_TRY S462.

## TRAPS (S459, kept)
- LiveRound.gd has a TIGHT 470-line cap (file_limits): fold changes into existing lines.
- A seat-test or film run with `sharedholo` fails fight3d_play (the tool checks the side holos) - mockup only.
- Control runs: copy the touched files aside, `git show HEAD:<f> > <f>`, run, copy back (never a bare stash).
- S460: `gh pr close` is refused by the auto-mode permission check. Seat dispatch: `python ops/Tools/seat_dispatch.py --task <ID> --seat qwen`
  (dry run) then `--act`; OWNS must be bare paths (notes in parentheses on the next line).
- S461: a seat's probe page can be invented: rerun the probe (same seeds) and compare before using a number.
- S461: a control run that loads scripts BEFORE a fix keeps the old code for its whole run - kill and rerun it after the fix.
- S462: Antigravity's result pages are not to be trusted (two invented); give it only work proven by a test Claude reruns.
- S462: a brief must name a source that exists (KNOWBOTS1 named "Recruit.gd prospects" - the game has no prospect pool).
