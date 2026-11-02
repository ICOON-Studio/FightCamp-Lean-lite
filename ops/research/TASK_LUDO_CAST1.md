# TASK LUDO-CAST1 - Ludo's first-run cast as data (pure loader + data) - cloud Qwen

Model: Qwen (cloud-agent workflow, label `qwen`). Branch qwen/issue-<n> (the workflow makes it). Write ONLY the three NEW files below.
Do not delete or weaken any existing test. Never open a window.

## Owned files
- `Godot/assets/data/ludo_cast.json` (NEW)
- `Godot/scripts/LudoCast.gd` (NEW, pure: extends RefCounted, static funcs, no autoload, no preload of game scripts)
- `Godot/tests/ludo_cast_test.gd` (NEW, extends SceneTree)

## Prior research
Design of record (approved D40 "use ludo's cast", D41 V13): `research/LUDO_CAST_S190.md` sections 1-3 - copy every number from there
EXACTLY. House style: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd` (JSON cached once, one _check per case with
the numbers in the message, prints `<NAME> FAILS=<n>`, quit(1) on any fail). The promoter's TV opponent (section 4) is ALREADY data in
`Godot/assets/data/promoter_trap.json` - do not duplicate him.

## What would a human do?
Transcribe the cast table into one JSON, give it a tiny loader, and test that every number survived the transcription.

## Prefab check
N/A - our own data.

## Spec
`ludo_cast.json`: {"prospects": [leo, malik, damian] (shortlist ORDER: Leo first - V13 "always leads with Leo Vance"),
"opponents": {"fight_1": perez, "fight_2": miller}, "sparring_partner": sal}. Each fighter: id (snake_case), name, nickname (if any),
age, weight_class ("super_welter"), weight_lb, height_cm, reach_cm, stance ("orthodox"/"southpaw"), style (as written: boxer_puncher,
out_boxer, slugger, swarmer), "stats": {power, speed, defense, conditioning, fight_iq, technique, chin} (0-100 as given), traits (names
as written, effect text in a parallel "trait_notes" dict), and where given: head_movement (Leo 14), potential (78/81/74), move_cards
(3 names), locked_chain {trigger, evasion, counter} (Leo only), tells (Perez/Miller: 3 each {kind "tell"|"exit", name, effect text}).
Sal: wage_per_week 50, never_booked true, mimic {slugger 0.85, swarmer 0.70, boxer_puncher 0.60, counter_puncher 0.40, out_boxer 0.25}.
`LudoCast.gd`: `shortlist() -> Array` (3 deep copies, Leo first), `prospect(id) -> Dictionary`, `opponent(slot: String) -> Dictionary`,
`sparring_partner() -> Dictionary`, `mimic(style: String) -> float` (0.0 for an unknown style). All return deep copies.

## Done = (tier: new files only - parse + this test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/ludo_cast_test.gd` (on Linux the Godot 4.7.2 headless binary from
Tools/cloud_setup.sh) -> `LUDO_CAST_TEST FAILS=0`, rc 0, no SCRIPT ERROR. The test checks EVERY stat of all 6 people against literal
numbers typed in the test (not read back from the JSON), Leo first in shortlist(), Leo's head_movement 14 and locked chain, Perez and
Miller have 3 tells each with the names from the doc, Sal's wage 50 and mimic slugger 0.85 / out_boxer 0.25 / unknown 0.0, and that
editing a returned dict does not change the next call. Report 3 mutants with FAIL counts: (a) Leo chin 82 -> 80, (b) shortlist order
Malik first, (c) Sal mimic slugger 0.85 -> 0.80.

## The one trap
The test's expected numbers must be typed from LUDO_CAST_S190.md, never loaded from ludo_cast.json - a test that reads its own data back
cannot catch a transcription error.
