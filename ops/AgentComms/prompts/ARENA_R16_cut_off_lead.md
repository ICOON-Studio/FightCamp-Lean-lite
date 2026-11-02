Task R16 (engine fix + keep every test honest). Repository: Godot 4.7.2 GDScript game, project folder `Godot/`.

WORKFLOW: create your own branch `arena/<this-chat-id>-FightCamp` from master, commit there, push, open a pull request into master. Never push to master, never merge the PR yourself. Do not delete or weaken any existing test.

SETUP: `bash Tools/cloud_setup.sh` (Godot 4.7.2 to /opt/godot, sets GODOT_EXE). If the sandbox cannot download it, build Godot 4.7.2-stable from source (a previous Arena chat did this successfully), then `$GODOT_EXE --headless --path Godot --import` once. This test loads NO 3D models (pure engine simulation).

PROBLEM: `Godot/tests/fight_ring_position_test.gd` (449 lines) is red: `RULE R16 cut_off_closes_the_gap | GATED S4e | FAIL`. Read its comment block above `_rule_cut_off` (lines 313-345): it already names the cause. When a fighter cuts off a retreating man, `FightRealtime._run_movement` aims at `toward + _other_velocity(other) * _cut_off_lead(fighter)` (FightRealtime.gd line ~4161; `_cut_off_lead` at line 4033; `CUT_OFF_LEAD_S := 0.45` at line 255). `toward` is the raw displacement, so its length IS the gap; a FIXED lead time added to it rotates the aim further off the direct line the closer the two men stand. A later unit correction moved the gap distribution closer, so cutting off now opens the gap faster than plain pursuit in the cage.

TASK: fix the CAUSE, not the number. Do NOT pick a new value for CUT_OFF_LEAD_S until the test goes green (the test comment forbids exactly that). Make the lead time follow from the geometry: the standard pursuit-intercept lead, i.e. the time to close the current gap at the chaser's own speed (gap / chaser_speed, from values the engine already has), scaled by the existing fight_iq factor, and capped by the existing constant so it never exceeds today's lead. Keep it a pure function with a short comment saying it is DERIVED. FightRealtime.gd is 8239 lines: grep and read windows only, never the whole file.

ACCEPTANCE:
- `$GODOT_EXE --headless --path Godot --script tests/fight_ring_position_test.gd` ends `FIGHT_RING_POSITION_TEST FAILS=0`, with the R16 line printing the ring and cage gap rates (paste before and after lines).
- Boxing unchanged in spirit: `python3 Godot/tools/run_tests.py --only fight_ring,fight_footwork,fight_movement,fight_band --jobs 2` reports fails=0 except tests that were already red on master (run it on master first and paste both summaries).
- `python3 Godot/tools/check_scripts.py scripts/FightRealtime.gd` passes.
- If a test asserts the exact old numbers of cutting off, do not edit it - explain in the PR.
Paste all outputs in the PR. CI must be green; never fix CI by editing a test's assertions.
