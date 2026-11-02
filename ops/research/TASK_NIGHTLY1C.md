# TASK NIGHTLY1C - two MMA band tests that went red (fix the engine, never the band)

Model: any. Owner: Arena (cloud). Tier: a script edited -> parse gate + the two focused tests.

## Prior research
searched: footwork economy m/min MMA (nothing); canonical page `research/topics/footwork.md`. History: commits 18d2de1d
(Q182 per-ruleset footwork_economy default) and 4f789137 (Q183 all rulesets ON, 540-bout census).

## What would a human do?
A coach would look at WHY MMA bouts now move 11.2 m/min (band 12-33) and wrestler-vs-BJJ fights end by submission 11.8% of the
time (band 12-32%): find the recent change that pushed each number just under its floor and nudge that mechanism back inside the
band. Nobody widens the band to make a test pass.

## Prefab check
None applicable: this is tuning of our own engine against published bands (G100 footwork bands, Fightnomics finish shares).

## The two failures (from the nightly 2026-10-04, master c55d3946)
1. `Godot/tests/fight_footwork_economy_test.gd` (351 lines) line ~103-105: `FAIL: mma ON m/min >= 12 (got 11.2)`.
2. `Godot/tests/fight_back_bands_contract_test.gd` (355 lines) line ~238-255: `FAIL wrestler vs BJJ player sub-finish share 11.8% not in 12-32%`.
Both tests print `achieved` beside `wanted`. Both exit 0 after printing FAIL, so read the output, not the exit code.

## Rules (hard)
- Do NOT change either test file, any band constant (`SUB_SHARE_LO/HI`, the 12/33 m/min bounds) or any fixture. A CI guard fails a
  deleted or gutted test. Fix the ENGINE value that moved (find it with `git log -p` on the scripts the tests exercise:
  `Godot/scripts/FightFootwork*.gd`, the MMA ruleset footwork economy, and the submission/finish weights).
- Fix each with the smallest change; give each a control arm that cannot share the bug (the other ruleset's numbers must not move:
  boxing m/min must stay 32-48 in the same test, kickboxing unchanged).
- A zero-change fix is not allowed: print before and after numbers for both tests in the PR description.
- Do not read `GameState.gd` or `FightRealtime.gd` whole; use `sed -n` windows. CI has no LFS: both tests load no LFS models.

## Acceptance (exact)
```
python Godot/tools/check_scripts.py <each touched .gd>
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_footwork_economy_test.gd      # no FAIL line
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_back_bands_contract_test.gd    # no FAIL line
```
Both print no `FAIL`, and the boxing/kickboxing lines in the footwork test are unchanged. Work on your own `arena/` branch, open a
PR, never merge.

## Owned files
- `Godot/scripts/FightRealtime.gd` (never read whole; `sed -n` windows around the `fe_speed_mult` block ~1700-1720 and the `BACK_B_*` constants ~700)
- No test file, band constant or fixture may change.
