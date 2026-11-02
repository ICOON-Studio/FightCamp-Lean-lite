# TASK_C158 - CODEX - THE REACHABILITY CONTRACT, WRITTEN BLIND

**Owner:** codex
**Model:** `gpt-5.6-luna`, MEDIUM. (Not astra - a contract test is not 3D
animation design.)
**Test tier:** parse gate, then YOUR ONE NEW TEST ONLY. A new test file cannot
break another test; do NOT run the suite.

## Why you, and why blind

**RE-SCOPED 2026-09-22 AFTER A CONTROL PROVED THE FIRST VERSION WRONG.** This
task originally asked you to assert that `neck` exposure is above zero. Then
S47B ran the same test on the Perchance build's rig - a working implementation
of the same solver - and **its neck reads 0.0% too**, buried 0.0750 m inside its
own chest, on a rig that already splits the trunk three ways with slim authored
radii. **A neck is buried in a chest on every capsule humanoid, and that is
anatomically correct: you reach a neck from above and from the side, never from
below or from inside it.** The original assertion was false on every rig in
existence, including the one that ships.

So the question changes from **"can a hand reach this target from anywhere on
its whole surface"** to **"can a hand reach the SPOT a grip actually names, from
the direction the hold uses"**. That is the quantity the solver depends on and
it is the one worth a witness.

Claude is repairing the torso radius and the penetration term under S48 in a way
you cannot see. **You write the witness from the contract below.**

**Do not read `Godot/scripts/FighterCapsules.gd`, `Godot/tools/s47_contact_offsets.gd`,
`research/S47_THE_CONTACT_OFFSETS.md`, or any S48 file.** A test written
against an implementation only ever agrees with it.

## Owned files

- `Godot/tests/fighter_reachability_contract_test.gd` - NEW, yours alone.
- Nothing else. Do not edit `FighterCapsules.gd`.

## The contract

Add a test that, for the two shipped rigs
`res://assets/models/fighters/f01_m_box_welter_rigged.glb` (target height 1.78)
and `f02_m_box_heavy_rigged.glb` (1.88):

1. Builds capsules with `FighterCapsules.build(skel, scale)` then `.ground(...)`,
   scale from `FighterPhysique.height_scale(raw_height, target)`.
2. For each **(target capsule, blend)** pair below - these are the spots the
   thirteen-pose corpus actually grips - computes the **grip spot**, which is
   the point `blend` of the way along that capsule's segment, exactly as
   `FightPoseSolver.grip_gap` does:

       neck 0.15 | neck 0.50 | head 0.50 | thorax 0.65 | thorax 0.70
       thorax 0.80 | pelvis 0.50 | pelvis 0.60 | femur_r 0.25 | femur_r 0.40

3. Samples **at least 128 approach directions** spread over the sphere around
   that spot. For each one, places a hand of radius `r_hand` (the OTHER rig's
   `forearm_r` radius) touching the spot from that direction - its centre at
   `spot + dir * (r_target + r_hand)`.
4. Counts a direction as USABLE when the hand centre is outside every OTHER
   capsule of the same body, i.e. point-to-segment distance `>= (r_other +
   r_hand)`.
5. **ASSERTS: every one of those grip spots has at least one usable approach
   direction**, and separately that **`neck` at blend 0.15 and 0.50 each have at
   least 5 usable directions out of 128** - a spot a hand can be brought to from
   more than a single knife-edge angle.
6. Prints a table: target, blend, usable directions out of the total, the
   **mean elevation of the usable set in degrees** (it should be well above the
   horizontal for a neck - that is the over-the-shoulder approach, and it is the
   number that says the test is measuring the right thing), and the capsule that
   blocks the most directions.

**WHY THIS ONE CAN FAIL AND THE OLD ONE COULD NOT PASS.** 360-degree exposure is
zero for a neck on every rig, so asserting it is above zero is asserting
something false. Directional reachability at a named spot is a real property
that a too-fat torso genuinely destroys and a correct one genuinely preserves.

`FightPoseSolver.segment_distance(p, p, q0, q1)` gives point-to-segment distance
with a degenerate first segment; use it rather than writing your own.

## SKIP CLEANLY IF THE SUBJECT IS ABSENT

If either `.glb` fails to load, print `SKIP - rig absent`, then
`checks=0 failures=0`, and `quit()` with 0. A test that hard-fails on a missing
asset is a test nobody can run.

## THE MUTANT PASS - NOT OPTIONAL

Copy `FighterCapsules.gd` to `/tmp/mutant_capsules.gd`, break it four ways, and
prove your test goes RED on each. Accept a `--capsules=res://...` command-line
override so you can point the test at the mutant. **The override must NOT sit
behind a `--` separator** - `OS.get_cmdline_args()` does not return user args, so
a mutant behind `--` passes green and proves nothing. This cost S47 a run.

Four mutants, at least: thorax radius forced to 0.25 (must kill the neck's
usable directions); thorax radius forced to 0.02 (must NOT - a thin torso is not
a defect this test should report); neck segment collapsed to zero length; the
`ground` offset removed. **The second one matters most: a test that goes red on
any change at all is not measuring reachability, it is measuring that something
moved.**

## Gate

`python Godot/tools/check_scripts.py Godot/tests/fighter_reachability_contract_test.gd`
then
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fighter_reachability_contract_test.gd`

Report `checks=N failures=M`. **IT MAY WELL BE RED ON THE CURRENT TREE** - the
thorax is 0.1909 m on a 0.3054 m segment where an independent build uses 0.130,
and the repair is S48's, not yours. **A red that names the numbers is a fine
deliverable; do not weaken the assertion to make it green.** If it comes back
GREEN, say so plainly and give the usable-direction counts - that is also a real
answer and it would mean the neck grips fail for the other reason S47B names
(the penetration term punishing the hold), not for reachability.

## Deliver

Commit and push to master with explicit paths, message ending
`Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`. Write
`research/C158_DIGEST.md`. Send one line with
`python Tools/agent_comms.py send --from codex --to claude --subject c158-ready --body "<one line>"`.
Do NOT edit `HANDOFF.md`.
