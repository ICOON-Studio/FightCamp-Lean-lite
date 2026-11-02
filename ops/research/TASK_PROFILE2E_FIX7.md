# TASK PROFILE2E_FIX7 (S215) - round 8: finish FIX6 - the headshot gate must go GREEN at the real panel size

Model: Cursor (composer). Worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e. Never master.
Read first: research/TASK_PROFILE2E_FIX6.md (the full spec - still the spec) and `git diff` in the worktree (round 7's UNCOMMITTED edits to
ProfileStage.gd + profile_stage_test.gd: keep what is good, finish it).

## State at S215 (primary source: Claude ran tests/profile_stage_test.gd in the worktree)
- Test builds the face at 460x440 and 420x440 (good). Bruno: top=14.7% eyes=43.8% chin=76.9% sh=107% pitch=-4.7 head_pitch=10.5 -> ok=false.
- Failing limits: chin must be <= 72% (is 76.9), head pitch |.| <= 5 deg (is 10.5 - the idle pose tilts the head down), crown 6-14% (14.7 - just out).
- The run hit the 170 s timeout (rc=124): the test builds 4 fighters x 3 sizes; keep it under ~120 s (share one rig per fighter, resize the viewport only).
- A line `bruno_moreau_chest_proof top=-166.9%` also prints (a different debug path) - make sure it is not the one gated.
- FBX "Reading less data than requested" warnings are harmless noise.

## Do
1. Portrait pose only: lift/level the head (neck/head bone pitch to <= 5 deg, portrait only, never the fight animation), frame so crown 6-14%,
   eyes 35-42%, chin <= 72%, shoulders visible. All 4 cast fighters (Bruno, Niko, Phuket, Rafael) pass at 420x440, 460x440 and the panel size.
2. Red first: the test must already be red on the current tree (it is) and go green after.
3. Re-shoot the 3 profile stills (overview, medical, techniques) for 2 fighters on the game's own screen; open each with your FILE tool and
   describe hair top, eyes line, chin, shoulders in PROFILE2E_DIGEST.md.
4. `python Godot/tools/check_scripts.py <touched .gd>`, then `python Godot/tools/run_tests.py --jobs 2 --only profile,readout`; nothing green goes red.
5. Commit (stage explicit paths; not .test_out*.txt) and push cursor/profile2e. Update the HANDOFF line.

## Owned files
ProfileStage.gd, profile_stage_test.gd, tools/profile2_stills.gd, docs/previews/profile2e/, PROFILE2E_DIGEST.md. Not ProfileOverview.gd.

## Rules
Watchdog before each Godot run (RED = wait); windowed Godot only via Tools\godot_hidden.ps1; headless Godot_v4.7.2-stable_win64.exe only
(never _console.exe); no image viewers/start/explorer - file tool only. Meters you touch animate.

## Prior research / What would a human do? / Prefab check
Prior: FIX5/FIX6 briefs, PROFILE2E_DIGEST.md. Human: a portrait photographer frames ~10% headroom, eyes at the upper third, level head, checks at print size.
Prefab: none needed - existing MetaHuman rig and ProfileStage.build_face.

## The one trap
Face SubViewport size comes from `parent.size` at build time; build the test the same way, never at a size nobody sees.
