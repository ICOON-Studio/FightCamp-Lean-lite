# TASK NIGHTLYPARK1 - the nightly suite stops reporting what the demo does not use, and every asset folder has an owner
Status: DONE (S256 collected 82e26f37; tooling task - run_tests.py is never machine-merged)

THIS IS THE TASK. Model: Arena (cloud). Discipline: BOXING demo housekeeping (no gameplay code).

## Why
Nightly 2026-10-17 (885 tests) had 16 reds; Qwen labelled them in `research/NIGHTLY_LABELS_S255.md`. Operator S249: "do not
test mechanics we do not use maybe until we actually implement them" and S255 Q-S249-7 (the demo is BOXING only: no MMA, no
kickboxing, no promotions). Two reds are OFF-DEMO and must leave the nightly; one GYM-DEMO red (`asset_manifest`) is missing entries.

## Part A - a parked-tests list the runner honours
1. NEW `Godot/tests/parked_tests.json`: `{"_doc": "...", "parked": [{"test": "<name without _test.gd>", "why": "...", "ruling": "...",
   "since": "2026-10-18"}]}` with exactly two entries:
   - `fight_contact_stop` - why: runs `"discipline": "mma"` and gates `kickboxing_low_kick` contact depth (1.14 m); ruling: operator
     S255 Q-S249-7 boxing-only demo.
   - `promotions_board` - why: exercises the promotions board; ruling: S255 Q-S249-7 no promotions in the demo.
2. EDIT `Godot/tools/run_tests.py` (610 lines; read `main()` from line 398 and the test-discovery function it calls - `grep -n "def "`):
   - the FULL suite (no `--only`) skips every parked test and prints ONE line per parked test: `PARKED <name> - <why>`, and the summary
     line gains ` parked=<n>`;
   - `--only <exact name>` still runs a parked test when named explicitly (so it can be revived) and prints `PARKED-RUN <name>`;
   - new flag `--include-parked` runs them in the full suite too.
   - Nothing else in the runner changes (gate logic, timeouts, jobs, report files untouched).
3. NEW `Godot/tools/test_parked_list.py` (plain Python unittest, no Godot): imports run_tests' discovery/selection function and asserts:
   the full selection excludes both parked names; `--only fight_contact_stop` includes it; `--include-parked` includes both; a parked
   entry naming a test file that does not exist makes the selection raise/print an error (a typo must not silently park nothing).
   Write it RED FIRST against master's run_tests.py (it fails: no parking) and put that failing output in the PR body.

## Part B - asset_manifest entries
`Godot/tests/asset_manifest_test.gd` fails: `[FAIL] asset folder res://assets/anim/actionforge/ is claimed by a manifest entry` and
others (30 unclaimed folders/references - office, physio, c78floor, anim). EDIT `Godot/assets/asset_manifest.json` ONLY (`packs` array):
add one entry per unclaimed folder with `id`, `name`, `source`, `licence`, `status`, `godot_path` (shape: copy an existing entry). Take
source/licence from the folder's own `CREDITS.md` / `LICENSE*` / README if present (e.g. `Godot/assets/anim/actionforge/CREDITS.md`);
when none exists, write `"licence": "NOT RECORDED - <folder> (S256 NIGHTLYPARK1)"` with `status` = the manifest's status for
unreviewed packs (read `statuses`) - NEVER invent a licence. List every such NOT RECORDED folder in the PR body.
Run the test locally if you have Godot (`--headless --path Godot --script tests/asset_manifest_test.gd`); it lists the folders on
files alone - no LFS content is loaded. If you have no Godot, list the folders yourself: every directory under each `managed_roots`
entry holding at least one file must be under some pack's `godot_path`.

## Files you own
`Godot/tests/parked_tests.json` (NEW), `Godot/tools/run_tests.py` (EDIT, selection only), `Godot/tools/test_parked_list.py` (NEW),
`Godot/assets/asset_manifest.json` (EDIT, `packs` only). Touch nothing else. Never delete or weaken a test.

## Acceptance (PR body lines)
- `RESULT: Godot/tools/test_parked_list.py -> OK` (python -m unittest output) + its red-first output on master.
- `RESULT: tests/asset_manifest_test.gd -> <its pass line>` (or the folder census if no Godot).
- The list of NOT RECORDED licences.

## Prior research
`python Tools/prior_research.py nightly park asset manifest`: NIGHTLY_LABELS_S255.md (the 16 labels), operator S249 "only what we use".
## What would a human do?
Keep one honest list of switched-off tests with the ruling that switched them off, so the nightly report shows only demo work - and
make any asset nobody can account for show up as "licence not recorded", not silently pass.
## Prefab check
None - a JSON list + 30 lines of runner code. Python stdlib only.
