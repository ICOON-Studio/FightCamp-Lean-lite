# TASK NIGHTLY8 - the seven nightly reds NIGHTLY7 did not cover, one small PR each (S242, Grok Dev)

Seat: Grok Dev (cloud coding seat, Godot 4.7.2). Model: Grok Dev default. Discipline: BOXING (demo) - every one of these is the
boxing fight or the day loop; anything that turns out to be MMA-only (a kick, a takedown) you skip with one line.
One branch + PR per test: `grok/nightly8-<test stem>`, PR to master; Claude merges by diff. Same method as NIGHTLY7 (thank you -
#234/#235/#238/#240/#242 all collected S242).

## The reds (nightly 2026-10-17 @5b92bef2, SUITE total=885 fails=16), in this order
1. `tests/decision_pacing_test.gd` - hang (timeout). Suspect S238 LOOPOFF1 (story/tutorial/decision cards OFF): the pacing path it
   waits for never fires. If the test's ON arm needs `decision_cards` ON, the test must turn that switch on itself (its ON arm) -
   the game keeps it OFF (LOOP1 verdict, commit 687ad8d6).
2. `tests/corner_instruction_contract_test.gd` - rc=1 (history: CORNERCONTRACT1 rejected S231, CORNERCONTRACT2 Arena).
3. `tests/switch_gate_hands_smooth_in_whole_test.gd` - rc=1.
4. `tests/fight_identity_test.gd` - rc=1.
5. `tests/fight_clip_slice_test.gd` - rc=1.
6. `tests/fight_stage_realism_test.gd` - rc=1.
7. `tests/fight_realtime_test.gd` - hang (timeout). Run it alone with a 900 s timeout first: a heat-governor pause on our nightly
   box counts as time (runner fixed 44cf0d3b) - if it completes green alone, say so and skip it.
Not yours: fight_pair_live (PAIRLIVE1), fight_contact_stop (MMA kick, parked), asset_manifest (Claude).

## Do, per test
1. Run it alone on master: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd` - paste its FAIL / SCRIPT ERROR line.
2. Find WHY with `git log -p --since=2026-10-08 -- <the files the failing check reads>` - name the commit that broke it.
3. Fix the GAME (or fixture data the commit made stale) - never delete, skip or weaken an assertion. If the expectation is
   genuinely obsolete because a newer operator-approved design replaced it, name that commit/design in the PR and change only
   that expectation (flag it at the top of the PR like #240 did).
4. Green: the test alone prints its pass line; parse gate `python Godot/tools/check_scripts.py <touched .gd>`; plus
   `python Godot/tools/run_tests.py --only <the touched system's substring> --jobs 2` unchanged-or-better vs master (both SUITE lines).
5. PR body: `RESULT: tests/<name>.gd -> <exact pass line>`.
If a test fails only because an LFS asset is missing on your box, one PR comment line and move on.

## Rules
research/GDSCRIPT_TRAPS.md. GameState.gd, GymHall3D.gd, FightRealtime.gd are huge - grep + sed -n windows, never whole.
New features ship ON (GameSwitches.GAME_ON); plain --script tests are the OFF control arm. Never test identical fighters.
THE ONE TRAP: never delete or weaken a test to go green - a red test that is right stays red and you report it.

## Prior research
roadmap NIGHTLY1 row (history of each red), S238_DIGEST.md (LOOPOFF1), S241_DIGEST.md (LOOP1 switch audit 687ad8d6),
TASK_NIGHTLY7.md, AgentComms/nightly/latest.txt.

## What would a human do?
Bisect each red to the commit that broke it, fix the cause in the game, prove it with the test alone, ship small PRs.

## Prefab check
None - regressions in our own code.
