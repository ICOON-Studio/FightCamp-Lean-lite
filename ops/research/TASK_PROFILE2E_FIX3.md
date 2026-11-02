# TASK PROFILE2E_FIX3 (S210) - review round 4 of cursor/profile2e (a93b95a9)

Model: Cursor (local), same worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e. First `git merge origin/master`.
Claude opened the round-3 stills. FIXED: division label, wear labels (career vs regional), overview right column, timeline fits.
TWO REGRESSIONS and one fix that did not land. You cannot see images - so this round adds checks you CAN measure.

## Prior research
TASK_PROFILE2E_FIX.md, TASK_PROFILE2E_FIX2.md, PROFILE2E_DIGEST.md.
## What would a human do?
Look at the face box: a face must be in it.
## Prefab check
None.

## Defects
1. THE FACE IS GONE (regression): `2_profile_overview.jpg` portrait (left top box) and `2_tab3_medical_bio_*.jpg` FACE & CUT TISSUE
   show only a few dark hair strands on the background - no head, no face, no skin. Round 3's "hair/low-body meshes hidden in
   portrait mode" hid the HEAD/FACE mesh too (MetaHuman GLBs split head, body, hair/groom, eyes, teeth into separate MeshInstance3Ds -
   print every MeshInstance3D name + its AABB height range in the portrait and keep every mesh whose AABB overlaps the head bone
   +/- 15 cm; hide only meshes entirely below the collarbone). Also the round-2 crop (crown cut) must stay fixed.
   MEASURABLE CHECK (add to profile_stage_test or the stills tool, and print it): render the portrait SubViewport, read its Image, and
   count pixels that differ from the clear colour by > 0.1 in any channel: >= 25% of the box must be covered, and the covered
   pixels' bounding box must touch neither the top nor the bottom edge by more than 2 px of hair (headroom). Print
   `PORTRAIT_COVERAGE <athlete> <pct> bbox=<x,y,w,h>` for Bruno and Niko in the stills run. It must FAIL on a93b95a9 (prove it).
2. WEEKLY SCHEDULE STILL ALL REST: `2_tab2_performance_camp.jpg` shows REST Mon-Sun for Bruno although the digest says the stills
   seed a week via `set_week_program_day`. Either the stills tool writes to a different athlete/week than the tab reads, or the tab
   reads another key. Print `WEEK_READ <athlete_id> <7 day values>` from the TAB's own read in the stills run; the still must show
   ring/bags/cardio/strength on the days you set, REST only on rest days. Also "LAST 3 WEEKS: Training load: REST" must read the same.
3. OLD BAND NAME: overview "Composure: SHAKEN". COMPOSEBANDS1 (merged on master 2ca27b9f) renamed the bands: Shaken -> Rattled,
   Rattled -> Settled. After merging master, every composure label must come from `FighterReadout.composure_band()` /
   `Composure.band()` - no hard-coded band names in profile code (grep your files for SHAKEN/Shaken and remove them).
4. Re-shoot every still, run `python Godot/tools/run_tests.py --jobs 1 --only profile`, add a "round 4" section to
   PROFILE2E_DIGEST.md with the PORTRAIT_COVERAGE and WEEK_READ lines, commit, push cursor/profile2e. Never master.

## Owned files
- `Godot/scripts/ui/ProfileStage.gd`, `Godot/scripts/ui/ProfileOverview.gd`, `Godot/scripts/ui/ProfileMedical.gd`,
  `Godot/scripts/ui/ProfileTabHost.gd`, `Godot/scripts/ui/ProfilePerformance*.gd` (if it exists)
- `Godot/tools/profile2_stills.gd`, `Godot/tests/profile_stage_test.gd`, `Godot/tests/profile_*_test.gd`
- `previews/profile2e/`, `research/PROFILE2E_DIGEST.md`

## Rules
Parse gate on touched .gd; watchdog before every Godot run; windowed runs only via Tools\godot_hidden.ps1; never open image
viewers/browsers; never master.
