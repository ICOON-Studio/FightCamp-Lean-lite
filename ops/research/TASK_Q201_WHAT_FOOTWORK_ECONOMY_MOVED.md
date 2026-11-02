# TASK Q201 - QWEN - WHAT DID FOOTWORK ECONOMY ACTUALLY MOVE? (S98)
Owner: qwen. Assigned 2026-09-27 (S98). Model: qwen3-coder medium, `--yolo`. Branch `qwen/q201-footwork-evidence` from
`origin/master`. Research + a digest; no script changes. Claude decides.

## Why
Q199 traced ten newly red tests to Q183 (4f789137, `footwork_economy` default ON for every ruleset) and called all ten
"pin moved by intent" - but quoted only the failing check. Claude must decide per test: re-pin (the flip meant it) or
defect (the flip broke something real). That needs numbers, not a label.

## What would a human do?
Run each test's measurement with the switch OFF and ON on today's master and put the two numbers side by side, then read
Q183's own digest (`research/Q183_DIGEST.md` or the Q183 commit message) for what it said it would change.

## Do
For each of: fight_defence_model, grapple_naming_contract, judge_panel, result_screen_why, fight_between_exchanges,
fight_contact_stop, fight_grapple_seam, fight_room_walkout, fight_separation, fight_strike_whole (`<name>_test.gd`):
1. Find where the test builds its engine options; run it with `footwork_economy: false` forced (a TEMPORARY local edit
   of the test only, never committed) and as-is. Record each failing quantity OFF vs ON (e.g. "penetration worst 0.00 m
   OFF vs 0.20 m ON").
2. Say whether Q183's digest names that quantity (quote the line) - INTENT - or not - SIDE EFFECT.
3. Flag any ON value that is physically wrong on its face (bodies interpenetrating, a man below the floor, a fighter off
   his mounted height) as DEFECT regardless.

## Gate (a CEILING)
A table for all ten: test | quantity | OFF | ON | Q183 line or none | INTENT / SIDE EFFECT / DEFECT. Tier: `--only <name>`
per run, `--jobs 1`. Revert every temporary edit (`git diff` must be empty on tests at the end).

## Owned files
`research/Q201_DIGEST.md` only (plus temporary uncommitted edits to the ten tests).

## Deliver
Commit the digest on the branch, push, `python Tools/agent_comms.py send --from qwen --to claude --topic Q201 --body
"<n intent / n side effect / n defect>"`. Do NOT edit HANDOFF.md.
**Trap:** some tests build fixtures through FightNightScreen, where S98 also made `limb_damage` default ON - force
`limb_damage: false` in the same temporary edit so you measure footwork economy alone.
