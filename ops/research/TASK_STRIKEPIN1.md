# STRIKEPIN1 (S230) - fight_strike_whole_test: 2 hash pins red on master - find the commit that moved them (Grok Dev)

Seat: Grok Dev (its own Linux box, Godot 4.7.2, clone WITHOUT LFS). Branch `grok/strikepin1` + PR into master; never merge,
never push master. Never delete or loosen a test. Plain `--script` tests are the OFF control arm.

## The red (read on master bcc4d269, S230, also on every nightly since 10-14)
`godot --headless --path Godot --script tests/fight_strike_whole_test.gd` ->
`FAIL: OFF boxing events and verdict byte-identical to baseline` and `FAIL: R16 ON boxing hashes the S159 R16 pin`
(`3675 checks, 2 failure(s)`). FightRealtime.gd is ~6,600 lines: read it in windows only (`sed -n a,bp`).

## Do
1. Bisect: `git bisect` between a commit where the test was green (try 4fb47d80's parents back to ~2026-10-12; the nightly
   10-13 at b7685559 already shows it red, so start earlier) and master, running ONLY this test at each step. Name the first
   bad commit and paste its subject.
2. Read that commit's diff. Decide which case it is and say so in the PR:
   (a) a deliberate engine change whose new OFF/ON output is intended -> re-pin the two hashes to master's values, and in the
       test write one comment line naming the commit and why the pin moved;
   (b) an accidental change to the OFF arm (an OFF fight must be byte-identical to the pre-switch engine) -> fix the code so
       OFF is identical again, and keep the pins.
3. Never re-pin case (b). If the first bad commit is a merge of several things, narrow to the hunk.

## Acceptance
`fight_strike_whole_test.gd` -> `0 failure(s)`, and these stay green: fight_pair_live_test is already red (do not chase it);
corner_call_effect_test, corner_pit_stop_test, fight_realtime_test (long - run it once at the end). Paste the PASS lines + the
bisect log in the PR.

## Prior research
NIGHTLY1 row in AgentComms/roadmap.json (history of this red). S159 R16 pin notes in the test header.
## What would a human do?
git bisect with the one failing test, then read the culprit diff before touching a pin.
## Prefab check
git bisect run.
## The one trap
Re-pinning to make it green hides a real OFF-arm regression. Pins move only for a deliberate, named engine change.
