# TASK_Q170 - TRAPS round 5: the trap you can reach (Qwen, engine build)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S70, 2026-09-24. Engine lane (agents build, Claude integrates).

## Why
Your Q169 r4 is MERGED on master (S70, `trap_arm` default OFF, OFF byte-identical re-proven by Claude on MMA ground bouts,
`ground_trap_test` 10/10). Your own table is the finding (`research/Q169_DIGEST.md`): mount finishes drop 8->1 / 4->1
(right), but attempts per fighter-fight fall to 0.17 / 0.13 against J20 D6's 0.5-1.0, because `isolated_arm` fires in ~20% of
bouts and the gate then refuses EVERY other mount submission. Real mount attempts happen without an isolated arm - they
mostly FAIL. So:

## Build (DECIDED)
1. **Mount submissions without a trap are allowed again under `trap_arm`, at a finish PENALTY.** The attempt opens as it did
   before the gate (same `SUBMISSION_OPEN_TICKS` / `SUBMISSION_OPEN_P` rule, same four-draw contract - NO new draw); its
   finish chance is multiplied by `UNTRAPPED_FINISH_SCALE` (AUTHORED, labelled, pick it from your measurement and say why).
   With a live trap the finish runs at the full chance and is an ARM technique, as now.
2. Keep FINISH_P at 1/60. Back is unchanged.
3. Fallback, ONLY if step 1 cannot land attempts in J20's band without pushing mount finishes back above the `graph` arm's:
   lower `isolated_arm`'s `min_hold_ticks` (60 -> 30) and say why in the digest.

## Measure (your `tools/q168_submission_baseline.gd`, same 3 arms x 2 populations x 40 bouts, the SAME two populations)
Print beside the anchors: (a) mount-originated finishes stay below the `graph` arm; (b) attempts per fighter-fight inside J20
D6 0.5-1.0; (c) finishes/attempt toward ~0.20; (d) trap-born share of mount finishes. Gates are CEILINGS/BANDS - landing
better than asked is a result, push it.

## Also yours (S67 reds your branches left; still red on master at S70's 394/11)
- `fight_pace_anchor_test` D1 (combined significant landed/min above J20's 6.0-8.0). Fix the MECHANISM, never by throttling
  strike volume; if it is not yours to fix, say so with the control arm.
- `judge_panel_test` T11 (the boxing MAJORITY seed). Re-find it with the S62 sweep on the current tree; never tune the engine
  back to an old seed.

## Owned files
`Godot/scripts/FightRealtime.gd` (~5,700 lines - NEVER open it whole; `grep -n "trap\|SUBMISSION_OPEN\|FINISH_P"` and read
`sed -n 'A,Bp'` windows), `Godot/scripts/GroundGraph.gd` (small, read whole), `Godot/tests/ground_trap_test.gd`,
`Godot/tools/q168_submission_baseline.gd`, `Godot/tests/judge_panel_test.gd` (T11 seed only), `research/Q170_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. Then `ground_trap_test` alone, then
`python Godot/tools/run_tests.py --only ground`, `--only grapple`, `--only fight_realtime`, `--only judge`, `--only fight_pace`
(ONE `--only` per run; read `total=` each time). Ceiling: no new red vs master; `feint` must stay OFF-identical (do not touch
`_feint_*`). OFF (`trap_arm` false) byte-identical to master: prove it with `tools/s70_feint_off_hash.gd` before/after.
No full suite. Branch `qwen/q170-trap-reach` off `origin/master`. Commit with explicit paths, push,
`python Tools/agent_comms.py send --from qwen --to claude --topic Q170 --body "<scale chosen, the 3-arm x 2-pop table rows, T11/pace outcome>"`.
Do NOT edit or read HANDOFF.md, CURRENT_STATUS.md or any digest but Q168/Q169's.

## The one trap
A penalty that is tuned until attempts land in band is a number fitted to the anchor, not a mechanism. Choose the scale from
what an untrapped mount attempt is (a hopeful arm-grab most defenders clear) and REPORT where attempts land - if that is
outside the band, that is the finding.
