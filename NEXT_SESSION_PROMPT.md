# S462 handover (written 2026-11-13 at the end of S461; S460's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S462`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> INTEGRATE1 first; no menu design.
- S461 (he asked, Claude answered yes): "Greybox mechanics go on existing screens first, with the final menus locked afterward. do that"
  -> each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons; final menus after.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).
- S459 "do not remove the holos yet" -> side holos stay.

## FIRST
0. plan_bout_test is RED ON MAIN from before S461 (control run on 3d0cc9b3 code: "the branch arrows are thrown in the bouts (1 times
   over 80 bouts)"). Suspect the same as result_defects 2: the branch lines are combos at mastery 0, which never fire since S450
   FIRELEVEL3 - check the fixture's combos first; fix the fixture, not the fire rule.
1. (S461 closed result_tabs: green, re-pinned to FixLab's rule.)
2. Collect LOYAL1 (Qwen, qwen/loyal1, ops/research/TASK_LOYAL1.md) and KNOWBOTS1 (Antigravity, agy/knowbots1, TASK_KNOWBOTS1.md).
   RERUN EACH PROBE YOURSELF before trusting its page: READ1's page (agy) did not match its own probe (rerun A 29.3% vs page 44.8%,
   probe line pass=no; a perfectly linear table was the tell) - docs/READ1_RESULT.md is Claude's rerun.
3. Then wire: LOYAL1 pass -> #11 ClubDeal + #6 Loyalty together; #5 ProRead at READ_EDGE 6 (LiveRound 469/470 - fold into an existing
   line or move a helper out); KNOWBOTS1 pass -> #10 Knowledge step 3. Tracker: ops/research/INTEGRATION_S459.md.
4. Seat answers SQ77-84 (LIVERRIBS1 x2, fight week v7, coach fit v4, ...) -> design_loop.py next rounds. READ1 finding for the loop:
   a split or a feint covers only part of the read (2.5 / 3.3 in 100 lost at READ_EDGE 6); only changing the plan answers it.
5. POWER1E rear uppercut tail. PRs 259/260/261 stale (collected) - `gh pr close` is blocked: ask him to allow it or close by hand.

## DONE IN S461 (ops/research/S461_DIGEST.md)
- #4 Towel (TowelWire + TowelStrip, both corners, Fight prep line; towel_wire_test). #2 LineGrade (GRADE1 + grade word on plan lines;
  grade_wire_test). #8 TrainRead (roster Coach cell; train_wire_test). fight_why bar -> 2 in 3 (design call, reason in the test).
- Hang trap fixed: "corner:" (empty call) must still open the round (BoutNight: `if stopped(m) == ""`).

## TRAPS (S459, kept)
- LiveRound.gd has a TIGHT 470-line cap (file_limits): fold changes into existing lines.
- A seat-test or film run with `sharedholo` fails fight3d_play (the tool checks the side holos) - mockup only.
- Control runs: copy the touched files aside, `git show HEAD:<f> > <f>`, run, copy back (never a bare stash).
- S460: `gh pr close` is refused by the auto-mode permission check. Seat dispatch: `python ops/Tools/seat_dispatch.py --task <ID> --seat qwen`
  (dry run) then `--act`; OWNS must be bare paths (notes in parentheses on the next line).
- S461: a seat's probe page can be invented: rerun the probe (same seeds) and compare before using a number.
- S461: a control run that loads scripts BEFORE a fix keeps the old code for its whole run - kill and rerun it after the fix.
