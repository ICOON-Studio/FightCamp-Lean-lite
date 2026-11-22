# S539 handover (written 2026-11-23 ~01:30, end of S538 - Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page.

## METHOD lines - quote all of them in your first message
- MECHANICS NEED 8 (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe; under 8 -> his cut-or-keep.
- FREE HAND (owner S534): remove / add / interconnect to reach 8, then report.
- WORKERS ON HIS SUBSCRIPTION = CODE MODE TABS (owner S538 "yes thats what i mean why you do not use that ?"): the $200 API credit
  is SPENT (log $160+; ~$45 of it had billed the subscription). Start each worker job with run_in_terminal:
  `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_cm.ps1 --model claude-fable-5-2 --permission-mode auto "<brief>"`
  (Opus allowed there "if needed"), never Agent subagents. Brief ends with `python ops/Tools/idle_guard.py ok <ID>-done`.
  At most 3 Godot jobs at once; close a finished tab (stop_terminal_tab close).
- A QUESTION IS A QUESTION (owner S538 "a question is a fucking question"): when he asks what uses the PC, ANSWER; stop or pause
  jobs only when he says so or reports lag. When he plays (ArcheAge) and says it lags: suspend Godot first, then stop jobs.
- FREE SEATS: Kalli, John, Dola for critics and research (`seat_queue.py add`, then `SEAT_QUIET_MIN=3 python ops/Tools/seat_queue.py
  drain` by hand - never wait for the 30-min job; a bot that keeps posting parts resets the quiet timer). Never code to chat seats.
- FIGHT ANIMATION: v2 only, no new correction layer. The CROSS IS CLOSED as shipped (owner C476 "lets move on ... stuck 3 days");
  his C472 leg jump rides with the ActionForge batch for the other punch takes. Fab pack: he buys it next week (Q-300).
- BOARD QUESTIONS: 20 words max. GIT: commit only your paths (`git commit -m ... -- <paths>`). JSON board files: keep their own
  indent and LF (S538 rewrote media_comments with indent 1 + CRLF by accident; fixed).

## Still running at handover (collect first; files on disk if a run died)
- TURNPRO15 (turning pro v15: favour backwards, card honesty, name-chaser) - subagent; output in tools/turnprobe15*, E:/FightCamp/tmp/turnpro15/.
- CARDSCOPE5 (card round 5, SEVEN arts: kickboxing added) - subagent; proto/cardscope5/.
- STEPPAY4 (footwork wrong-style leg) - Code Mode tab; worktree E:/FightCamp/wt/s538_steppay4 (branch s538/steppay4, merge after reading).
- LEDGERPROBE1 LANDED 6dffd110f: FAIL (the books do not predict keep/cut/release) -> LEDGER1 dropped by its brief's rule; tell the owner.
If a run is gone with no commit: relaunch it in a Code Mode tab with "earlier run stopped midway, reuse the files on disk".

## Next, in order
1. Collect the three still running (TURNPRO15, CARDSCOPE5, STEPPAY4); then `agent_comms.py ship` (S538 ship was refused only because TURNPRO15's DESIGN_TURNPRO1_V15.md was still being written).
2. PLANREADSHOW1 (brief written): show the silent "opponents adjust" rule (PlanRead ADJUST) - feed line, Plan tab, chart warning.
3. CARDSCOPE6: round 5's result + ops/research/JOHN_CARDGAME_MARKET_S538_JOHN.md (sourced; Dola's copy is unverified ideas) +
   the owner's S538 asks in OWNER_CARDGAME_INTERVIEW_S537.md: ladder with visible rungs + title shots + defences, fighters learn
   skills (belt paths), a training turn with a visible cost, rivals who return, positions for the grappling arts; Expedition 33
   style timing only as an OPTIONAL bonus on the picked guard, probed against no timing. Then Kalli + Dola critics (free).
4. KNOW_STAKES1 v7 from Kalli (6/4/5, code-checked: answer leaks via Roster.scouted_range, hype unwired, trial jumps to exact)
   and Dola (7/7/8) - wait for Q-305 (rival gym deadline on prospects).
5. Board triage rows: HOSTSHOW1 and PUSHTANK1 greybox probes; DEPTH1 build the passed prices.
6. MOTIONRULERS1: bisect the 3 animation reds (rokoko_clips, human_feet, head_aim).

## Done in S538 (evidence)
Result page v2 4497f9201 (+ button fix c71d5f5d9); office goals + sheets b4abaff50 (+ hint fix); plan chart bet/uses/save-load
1b2976832, repeat-read FAIL docs/REPEATREAD1_RESULT.md; body report without names; diet tooltip one line; nightly tips/words
4184a29c5; misread sized 370528621 (keep 0.5); coach hire FAIL cc6a5589f -> CoachMarket/CoachFit removed; card round 4 e43791485
(FAIL 5/7, wind beats limbs); knowledge v6 map 92d8eecbd + critics; card reference read e187dfb19; mockups c998c7b17.
Owner answers: Q-300 buy next week, Q-301 plan chart yes + repeat idea, Q-302 office goals + sheets, Q-303 result page graphics,
Q-304 "Yes, build them". Open: Q-305 rival deadline.

## Model for S539
Opus 5.5, medium effort, Fast off: collecting four results and writing card round 6 is design work; workers run on Fable in Code Mode tabs.
