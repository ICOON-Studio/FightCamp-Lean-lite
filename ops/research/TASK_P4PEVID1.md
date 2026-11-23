# P4PEVID1 - the card ask's evidence went to 0 of 60 after today's merges: find which and fix (S540)

Kind: fix. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`). Godot only through
`python ops/Tools/godot_slot.py run --who P4PEVID1 -- <cmd>` (headless, Dummy audio), one run at a time. If the watchdog shows a game
of the owner's running (ArcheAgeChronicles), at most one Godot job at a time.

## The red
`tests/p4p_visit_test.gd` (green in the 2026-11-23 05:00 nightly at 3d72c6222) now fails:
`FAIL real bouts record evidence on some nights and not on all (0 of 60)` - CardAsk.evidence (scripts/rules/CardAsk.gd :36-70)
never qualifies, so no P4P visit happens (visits=0). Ruled out by Claude: the combo counter (still 0 of 60 with
ComboCounter.on = false). Suspect: the STEPPAY5 merge f31338cfa (StepWrong: RingDuel.step's `met` grades a met step "wrong",
StepWire.ride returns {} for a bare / sliding step, StepWrong.bias changes her game after a step). A diagnostic run showed, over 60
bouts on the own ropes: pivot_out planned + fit ok + won only 12 times, fit none 32, so a line rarely repeats REPEAT_MIN times in
one bout. Other commits in range: cc8c3789d (words), c9159faf2 (OppFile heading), 821ddfa63 (BoutRead cache key).

## Do
1. Prove the culprit: run the test at f31338cfa^ and at f31338cfa in a temp worktree (seed it with
   `ops\Tools\seed_godot_cache.ps1 -Worktree <wt>`), record with_evidence each time.
2. Decide the fix by design, not by loosening the test: the card ask (P4P visit) must stay reachable - a coach who escapes the
   ropes with a planned answer that works is what the other corner sees. If StepWrong now makes the escape wrong against most P4P
   opponents, either the evidence should also count a planned escape that WORKED against her (won), or StepWrong's "met" should
   not apply to an escape off her own ropes. Pick, write why in the code comment, keep both step_wrong_test and p4p_visit_test green.
3. Tests: p4p_visit_test, step_wrong_test, tape_clips_test, golden_path_test.


## Also in this run (NIGHTREDS1, ops/research/NIGHTREDS1_RESULT.md - Claude decided both)
4. plan_templates_test (red since 3a3cb3a08 STEPPAY3): the turn template (t_turn) lost its edge because the five step moments
   now dealt into every bout pay the starter plan and the turn template has no answers for them. DECIDED: give t_turn the
   moments' right answers (the template is built for a presser; a presser's moments are its job) - the bar "turn beats the
   starter v Maria" stays. Owns scripts/rules/PlanTemplates.gd (or wherever t_turn is defined).
5. matchmaking_bots_test (red since 68067e0ba DMGCLASS2, pro bouts lost the four-count limit): first re-run it with 360 careers a
   bot (120 is noisy: blind moved 2 places); if "scouting is worth it" still fails, the scouting read must price the pro
   stoppage risk (the opponent's power v your chin under pro rules) - DECIDED: fix the read, never the bar. Report numbers.
Tests for 4-5: plan_templates_test, matchmaking_bots_test (11 min, alone).

## Prior research
docs/STEPPAY4_RESULT.md (the gate), CardAsk.gd header, VisitWire.gd.

## What would a human do?
Find the commit, read what it changed in the exchange record, and make both features true at once.

## Prefab check
None.

## Contract
OWNS: scripts/rules/CardAsk.gd, scripts/rules/StepWrong.gd, scripts/state/RingDuel.gd
RED_TEST: tests/p4p_visit_test.gd
REGRESSION: tests/step_wrong_test.gd, tests/tape_clips_test.gd, tests/golden_path_test.gd
VISUAL: none
