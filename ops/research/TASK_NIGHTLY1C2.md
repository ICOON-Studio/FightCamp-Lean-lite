# TASK NIGHTLY1C2 - the two MMA band tests, without moving any pinned seed

Model: any. Owner: Arena (cloud, own `arena/` branch, PR only, never merge). Tier: a script edited -> parse gate + the focused tests
+ the six neighbours.

## Prior research
`TASK_NIGHTLY1C.md` is the full brief (rules, bands, owned files) - this is its second round. Round 1 (PR #47, REVERTED): footwork
speed 0.86 -> 0.93 and RNC weight 0.085 -> 0.095 fixed both tests but moved the shared RNG sequence, so four pinned-seed tests
broke: `fight_contact_stop_test`, `grapple_naming_contract_test`, `judge_panel_test`, `result_screen_why_test`.

## What would a human do?
Change the mechanism without changing how many random draws happen per tick for the other rulesets and seeds: gate the change on
the MMA ruleset (and on the wrestler-vs-BJJ pairing for the finish share) so a boxing or kickboxing bout draws the identical
sequence as before; or move a continuous value (a speed multiplier) rather than a branch that adds a draw.

## Prefab check
None (our own engine tuning).

## Rules (hard) - same as TASK_NIGHTLY1C.md, plus
- NO test file, band constant, fixture or pinned seed changes. A CI guard fails a deleted or gutted test.
- Before opening the PR, run the SIX neighbours and paste their last lines into the PR description:
  `fight_contact_stop_test`, `grapple_naming_contract_test`, `judge_panel_test`, `result_screen_why_test`, `fight_ring_position_test`,
  `fight_strike_whole_test` - each must print the SAME result as on master (run them on master first, then on your branch).
  Note: on master today these six are already red in the nightly - "unchanged" means the same FAIL lines, not green.
- Print before/after numbers for footwork m/min (mma, boxing, kickboxing) and the sub-finish share.

## Acceptance (exact)
```
python Godot/tools/check_scripts.py <each touched .gd>
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_footwork_economy_test.gd      # no FAIL line
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_back_bands_contract_test.gd    # no FAIL line
```
plus the six neighbour runs unchanged versus master (output pasted). Owned files: `Godot/scripts/FightRealtime.gd` (never read whole;
`sed -n` windows only) and the MMA ruleset footwork economy data if that is where the value lives.

## The one trap
A new dictionary key or an extra RNG draw breaks a pinned-seed test even when its value is zero. Gate by ruleset so the other
rulesets' tick is byte-identical.
