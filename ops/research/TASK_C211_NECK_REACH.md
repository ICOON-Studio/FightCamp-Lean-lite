# TASK C211 - CODEX - THE NECK GRIP HAS NO USABLE APPROACH ON EITHER SHIPPED RIG
Owner: codex. Assigned S82, 2026-09-26. QUEUED: launch after C210 lands (one Codex run at a time).
Model: `gpt-6-astra` at MEDIUM (`CODEX_MODEL=gpt-6-astra`) - spatial / 3D reach work. Branch `codex/c211-neck-reach`.

## Why
`Godot/tests/fighter_reachability_contract_test.gd` (C158's blind directional witness) has been red since 2026-09-22 and
is one of the seven unowned reds in the 2026-09-26 nightly: `f01_m_box_welter` and `f02_m_box_heavy` both report
`neck 0.15` and `neck 0.50` with **0 of 128 usable approaches** (every other grip spot has approaches). C158_DIGEST.md
records it as intentionally red. A clinch or a choke that cannot reach the neck cannot be authored or solved.

## What would a human do?
A rigger asked "why can no hand reach the neck" checks, in order: is the target point where the anatomy is (inside the
neck volume, not inside the head or chest collision)? Is the collision proxy around the neck/head/shoulders fatter than
the body so every approach ray is blocked? Is the approach test's clearance larger than the real gap between chin and
shoulder? They fix the proxy or the target, never the test's threshold.

## The work
1. Read `fighter_reachability_contract_test.gd` whole (172 lines) and `C158_DIGEST.md`; print, for one neck spot on f01,
   the dominant blocker per rejected approach (the test already names it) and the capsule/proxy that blocks.
2. Diagnose: target placement vs collision proxy vs clearance. Measure the chin-to-shoulder gap on the posed mesh (not
   the rest box) and the proxy radii around neck/head/upper chest.
3. Fix the defect where it is (proxy or target definition), for both rigs. Do NOT lower the test's clearance or its
   "five usable approaches" floor. The capsule code lives in `Godot/scripts/CapsuleCoverage.gd` (S82, contract-tested) and
   the body capsule sources the test reads - follow its loads.
4. Re-run the witness: both neck spots on both rigs >= 5 usable approaches, no other spot losing approaches.

## Owned files
`research/C211_DIGEST.md` and the rig/proxy data or script you change (name them in the digest). Not the test.

## Tier
Parse gate on touched .gd, then `fighter_reachability_contract_test.gd`, then
`python Godot/tools/run_tests.py --only capsule,reach,fight_pose,fight_hold --jobs 2`. No full suite. Commit after each step.
Renders only through `Tools\godot_hidden.ps1`.

## Research
Open to all: root `RESEARCH_INDEX.md`. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit, push your branch,
`python Tools/agent_comms.py send --from codex --to claude --topic C211 --body "<cause + usable approaches before->after per rig>"`.

## The trap
Moving the neck target outward until rays clear it makes the test pass and puts the grip in the air beside the neck.
Report where the target sits relative to the posed skin, before and after.

## S94 UPDATE - J56 SETS THE NECK FLOOR (read `J56_WHERE_THE_HAND_GOES_ON_THE_NECK.md`)
**KEEP the five-of-128 floor. Do NOT lower it. MOVE THE GRIP POINTS instead:** collar tie -> nape/occiput
junction (C0-C2), 20 deg off centre toward the gripping side; plum -> occiput/crown on the midline, hands stacked;
front headlock -> under the chin / anterolateral C1 on the wrapping side. Mid-neck (C4-C6) reads 3/128 because no
coach puts the palm there - the point was wrong, not the floor.
