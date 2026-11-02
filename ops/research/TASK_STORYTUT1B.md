# TASK STORYTUT1B (S218) - install Kalli's first-hour recast (Mara Solano, Calder House) + keep every bench working

Model: cloud Cursor (label `cursor`). Branch `cursor/issue-<n>` from master. Never master.

## Why
The CEO approved Ludo round 52 (board Q-S212-12, "Approve - build it"; `research/LUDO_ROUND52_VERDICT_S217.md`): the story is
the tutorial, ONE cast - Leo Vance and "Anvil Street" are RETIRED; Mara "Wire" Solano (orthodox welterweight, a woman) at Calder House
Gym. Kalli (our game designer) wrote the recast; Claude reviewed it. Files to install (read all three first):
`research/STORYTUT1_KALLI/first_hour.json`, `.../ludo_cast.json`, `.../NOTES.md` (renamed ids/exit_flags + every Leo/Anvil
Street replacement + her NOT COMPUTED list).

## Prior research
`LUDO_ROUND52_VERDICT_S217.md` (16-beat mapping + Claude's 3 corrections), `STORY1_KALLI.md` (the story), `FirstHour.gd` (86 lines,
reads assets/data/first_hour.json), `LudoCast.gd` (reads assets/data/ludo_cast.json), `assets/data/tells.json`.
## What would a human do?
A studio swapping its tutorial protagonist changes the story data and every line that names the old hero, and moves the test
dummies the engineers fight with into their own fixture so the benches keep running.
## Prefab check
None - our own data files.

## Do
1. BENCH FIXTURE FIRST (Claude's decision): copy the CURRENT `assets/data/ludo_cast.json` men used by tools and tests - `leo_vance`,
   `ray_miller`, `malik_adebayo`, `damian_cross` and the current sparring partner - VERBATIM into a new
   `Godot/assets/data/bench_fighters.json` (same shape). Point every TOOL and TEST that fights them at it instead of ludo_cast.json:
   `tools/record_room.gd` (`_bench_fighter_from_cast` ~l.127-439), `tools/composure_still.gd`, `tools/doctor_still.gd`, and the tests
   `bench1_test`, `doctor_live_test`, `fight_stage_fatigue_switch_test`, `human1_test`, `human2_test` (grep `leo_vance|ray_miller`).
   Their fights must stay byte-identical (same fighters, same seeds) - this is a move of data, not a change.
2. Install Kalli's `first_hour.json` and `ludo_cast.json` into `Godot/assets/data/` exactly as delivered, then fix what her NOTES list:
   - `weight_class` "welter": use the code's existing welterweight enum value (grep how weight classes are spelled); fix the JSON if
     it differs, never the enum.
   - `card_names` (new block): keep it if `LudoCast.gd` ignores unknown keys; if it rejects them, teach LudoCast to read it as names
     only (Jace Vellin is a man and is never Mara's opponent).
   - `tells.json`: re-key the old opponents to the new ids (`tommy_perez` -> `elena_perez`, `ray_miller` -> `nadia_kerr`) keeping
     each tell's mechanics; update `tells_test`.
3. Update `first_hour_test.gd` and `ludo_cast_test.gd` to the new ids/exit_flags (NOTES "Renamed ids and exit_flags") - the same
   assertions on the new names; never delete an assertion.
4. New `Godot/tests/story_cast_unified_test.gd` (Ludo's test 7, unified_roster_names): `ludo_cast.json` + `first_hour.json` +
   `story_beats.json` contain no "Leo", "Vance" or "Anvil Street" (case-insensitive); every opponent Mara faces in the first hour is
   `sex`/gender female (or a female name if the cast has no sex key - then ADD `"sex": "female"` to each woman in ludo_cast.json);
   `bench_fighters.json` still holds leo_vance and ray_miller (the control arm: benches keep their men).
5. Run: parse gate on every touched .gd; the new test; then
   `python Godot/tools/run_tests.py --jobs 1 --only first_hour,ludo_cast,tells,bench1,doctor_live,fatigue_switch,human1,human2,story`.

## The one trap
Do not change any bench fight's fighters or seeds - those tests are the engine's control arm. Mara and the women are the STORY cast;
the men live on only in `bench_fighters.json`. Report in the PR every file you pointed at the bench fixture.
