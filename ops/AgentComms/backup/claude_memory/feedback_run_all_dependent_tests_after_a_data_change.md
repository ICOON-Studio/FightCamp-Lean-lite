---
name: feedback-run-all-dependent-tests-after-a-data-change
description: S199 - a gym_club.json repack passed club_fill_test but broke club_zones_test and gym_look2_props_test; run every test that reads the file
metadata:
  type: feedback
---
S199: I merged Cursor's unfinished GYMFILL2 `gym_club.json` after running only club_fill_test; it broke club_zones_test (zone rects/materials) and gym_look2_props_test (items on chalk props). Found only when another gate failed, then repaired by restoring rects and packing by footprint.

**Why:** shared data files (gym_club.json, gym_look2.json) are read by ~8 tests; the agent's own test is the weakest proof.
**How to apply:** `grep -l "<file>.json" Godot/tests/*.gd` and run all of them (club_fill, club_zones, gym_look2_props, gym_club_3d, layout, clearance, floor_pick_station, gym_hall_3d, ludo_camera). Run Godot from the REPO ROOT (`--path Godot`); from inside Godot/ it prints nothing and looks like a pass. A "Identifier not found: <ClassName>" for an existing class = stale cache: `Godot --headless --path Godot --import`. Also never take a dead agent's uncommitted work as finished. See [[feedback_defects_live_where_agents_meet]].
