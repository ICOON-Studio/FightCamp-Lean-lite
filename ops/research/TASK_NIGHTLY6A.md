# TASK NIGHTLY6A (S218) - three gym-floor tests went red after EQUIPSLOTS1A (find the cause, fix it, never the tests' numbers)

Model: cloud Qwen (label `qwen`). Branch `qwen/issue-<n>` from master. Never master.

## Why
The 2026-10-13 nightly (master b7685559) has three NEW reds that were green on 2026-10-12. All three touch the gym floor and
equipment slots, and EQUIPSLOTS1A (commit c7ab1ea1, "authored equipment slots per zone") landed between the two nightlies:
1. `Godot/tests/smoke_test.gd`: `FAIL: full floor accepted equipment: {"ok": true, "instance_id": "heavy_bag_001",
   "slot_id": "bag_line_west_1", "message": "Basic Heavy Bag PURCHASED"}` - a FULL floor must refuse a purchase.
2. `Godot/tests/training_floor_3d_test.gd`: `FAIL: tier 2: no two use zones overlap [["club_ring_001", "double_end_bag_001"]]`.
3. `Godot/tests/creation_api_test.gd`: `C14 FAIL: preview floor exactly matches final Career floor`.

## Do
1. For each test: `git show c7ab1ea1 --stat` and read the diff; find the FIRST place where the test's expectation and the new slot
   code disagree (e.g. a full-floor check that now counts slots instead of footprint; a slot whose use zone overlaps the ring; the
   preview path and the final career path choosing slots differently). If c7ab1ea1 is not the cause, bisect between 2ff... (10-12
   nightly) and b7685559 with `git log --since="2026-10-12 05:00" --until="2026-10-13 05:00" -- Godot/scripts Godot/assets/data`.
2. Fix the CAUSE in the game code or data (slot positions, the capacity check, the preview path) - never a test's expectation,
   never a switch in the harness. Keep EQUIPSLOTS1A's behaviour (authored slots per zone) intact.
3. Run the three tests + `python Godot/tools/run_tests.py --jobs 1 --only equip,slot,floor,club,creation,smoke`. If a test cannot run in
   the cloud because a .glb is LFS-only, say so in the PR and show the logic fix with a focused check instead.

## Prior research
`research/TASK_EQUIPSLOTS1A.md` (the slot design), `AgentComms/nightly/suite_2026-10-13.log`.
## What would a human do?
A gym owner whose floor is full is told "no space" by the shop; two machines are never bolted into the same walking space.
## Prefab check
None - a regression in our own code.
## The one trap
Do not loosen `no two use zones overlap` or the full-floor check to make them pass: the tests are right, the slot data or check is wrong.
Report in the PR: the cause (file:line), the fix, and each test's own PASS line.
