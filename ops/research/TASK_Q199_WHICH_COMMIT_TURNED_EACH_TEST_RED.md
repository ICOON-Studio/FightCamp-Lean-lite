# TASK Q199 - QWEN - WHICH COMMIT TURNED EACH TEST RED (S98)
Owner: qwen. Assigned 2026-09-27 (S98). Model: qwen3-coder medium, `--yolo`. Workspace: the worktree you are
started in, on a NEW branch `qwen/q199-red-triage` from `origin/master`. Research + one digest; NO fix commits to
scripts unless the task says so below. Claude merges.

## Why
The nightly suite went from 13 fails (2026-09-26, at 9847dd13) to 24 fails (2026-09-27, at 40bec39e). Seventeen tests
turned red between the two runs; about 60 commits landed in between (S82-S97, U178B, Q183-Q196, C213). Before the game
can turn any new engine switch on by default, each red must be named: a PIN that a deliberate change moved (update the
pin, cite the change), or a real DEFECT (name the commit and the symptom).

NEWLY RED (17): boxing_output, daily_progression, fight_between_exchanges, fight_contact_stop, fight_defence_model,
fight_grapple_seam, fight_ring_position, fight_room_walkout, fight_separation, fight_stage_presenter_contract,
fight_stage_technique_fidelity, fight_strike_whole, fight_world_live, grapple_naming_contract, judge_panel,
result_screen_why, smoke (all `<name>_test.gd`). The nightly's captured logs are in
`%TEMP%\fightcamp_test_logs\<name>_test.gd.log` - READ THEM FIRST; each names its failing check.
Known already (do not re-derive): smoke fails only "menu music is missing or not loop-enabled" (S94/S95 moved music to
Ogg playlists). S97 (83d14a63) engine changes are all behind `state.has("limb_damage")` - suspect it last.

## What would a human do?
A build engineer bisects: for each red test, `git bisect` between the last green nightly commit and the first red one,
running ONLY that test at each step, then reads the culprit commit's message and diff to say whether the change was
meant to move that number. They group tests by culprit so one decision covers several.

## Do
1. For each red test: `git bisect start 40bec39e 9847dd13` then `git bisect run` with a script that runs
   `python Godot/tools/run_tests.py --jobs 1 --only <name>_test` and exits 0/1 on its SUITE line. Skip commits that do
   not touch `Godot/scripts`, `Godot/tests` or `Godot/assets/data` (`git bisect skip`). Stop bisecting a test after 8
   steps; say so.
2. Group by culprit commit. For each group, read the culprit's message + its digest in `research/` and decide:
   PIN MOVED BY INTENT (the commit meant to change that quantity - quote the line) or DEFECT (it did not).
3. For PIN MOVED BY INTENT only: you MAY update the pinned value in the test, on your branch, one commit per test, the
   message citing the culprit. Never loosen a check to a range to make it pass; re-pin the exact value the commit's own
   digest reports. For DEFECT: do not fix; describe it.

## Gate (a CEILING)
Every one of the 17 named: culprit commit (or "not found in 8 steps"), PIN or DEFECT, one line of evidence. Re-pinned
tests run green with `--only`. Parse gate on any test you touch: `python Godot/tools/check_scripts.py <file>`.
Test tier: `--only` per test, `--jobs 1`, NEVER the full suite. The PC rule: at most one Godot at a time from you.

## Owned files
`Godot/tests/<the 17 tests>` (pins only), `Godot/tools/q199_*.py`, `research/Q199_DIGEST.md`.
`GameState.gd` is ~13k lines and `FightRealtime.gd` ~4k: never open whole, `sed -n 'A,Bp'` windows from grep hits.

## Deliver
Commit explicit paths on `qwen/q199-red-triage`, push the branch, write `research/Q199_DIGEST.md` (a table:
test | culprit | PIN/DEFECT | evidence | re-pinned?), then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q199 --body "<N pins, M defects, branch>"`.
Do NOT edit HANDOFF.md. All research is open: RESEARCH_INDEX.md.
**Trap:** several engine commits landed as merge commits (`Merge Q186`, `Merge U178B`); bisect lands on the merge -
test its second parent too before naming it.

## Q199B - continuation (S98 end)
Your first pass (e877af90) named 13 of 17. Finish the other FOUR - daily_progression, fight_stage_presenter_contract,
fight_stage_technique_fidelity, fight_world_live - which pass at Q186 (14c1955f) and fail at C213 (6c798572): bisect
between those two commits, same rules. THEN, for every test you called PIN MOVED BY INTENT, quote the culprit
digest's line that says the change MEANT to move that quantity. If no such line exists, call it DEFECT instead.
A body passing through the other body (fight_body_overlap), a man below the floor for 25 ticks (fight_separation) or
off his mounted height (fight_room_walkout) is a defect unless a digest says otherwise. Rebase your branch onto
origin/master first (your base 70ab2917 predates the S98 engine repair). Append to Q199_DIGEST.md; same deliver step.
