# C167 - The arms must arrive

**DELIVERED: att_lhand_to_vic_neck error 15% (ceiling 30%), mean 0.062 m against authored 0.073 m. RamsterZ control unchanged at 0.302639 / 0.304671. No clip authoring started.**

## Step 1 - remove the synthetic UpperChest global

Base: master 14111bb2. Made `_inherit_upper_chest` a no-op, without changing source assets, the name maps, root separation, or authored lean.

The existing probe reports:

```text
S31CONTACT att_lhand_to_vic_neck        0.073    0.109    0.140    0.124      70%
S31CONTACT att_rhand_to_vic_neck        0.097    0.131    0.161    0.146      50%
S31CONTACT vic_rhand_to_att_larm        0.083    0.060    0.073    0.067      19%
S31CONTACT head_to_head                 0.216    0.178    0.196    0.186      14%
S31CONTACT hip_to_hip                   0.746    0.754    0.802    0.778       4%
PAIRGAP key=grapple_control table=grapple frames=51 min_gap_m=0.302639 max_gap_m=0.304671 mean_gap_m=0.303635
```

Left-hand error improves from the supplied S31 baseline of 545% to 70%; this is not yet the <=30% gate. The copied global is implicated, but this does not establish that it ate a 28-degree local lean.

Probe limitation: `_point` emits `!is_inside_tree()` errors on `body.global_transform`, which returns identity. Numbers above are the existing instrument's actual output, not an assertion of error-free execution. Contact definitions and measurement code are unchanged.

Parse: total=1 fails=0. Clip subset: total=10 fails=0. Pair subset: total=7 fails=1 (`fight_pair_live_test.gd`, operator-parked). Grapple subset: total=10 fails=0. RamsterZ control unchanged exactly.

The stale shipped-stage guard required its documented `FIGHTCAMP_STAGE_GATE=off` override for this newly assigned task. Installed Godot required execution outside the filesystem sandbox. No fetch/rebase, full suite, GUI, authoring, HANDOFF edit, or asset edit. Task-specific read/ownership instructions supersede general startup/handoff rules.

## Step 2 - local rotations, not an assumed missing 28 degrees

The probe now prints source and target LOCAL Euler rotations (degrees, Godot convention) and deltas from each rig's own rest at t=0. It does not reopen the separate rest-reference asset or change contact sampling.

| Actor / bone | Source local xyz | Target local xyz |
|---|---|---|
| Attacker Hips | -27.753, -179.939, 0.017 | 33.698, 0.067, 0.110 |
| Attacker Spine | -0.786, 0.080, 3.874 | 4.825, -0.612, -3.902 |
| Attacker Chest | -6.199, 7.132, -1.268 | 14.495, 7.085, 0.010 |
| Attacker UpperChest | absent | 0, 0, 0 (undriven rest) |
| Victim Hips | -27.769, 0.068, -0.056 | 29.749, -179.931, -0.019 |
| Victim Spine | -0.768, 0.073, 4.018 | 8.771, -0.625, -4.084 |
| Victim Chest | -6.388, 6.939, -1.332 | 14.656, 6.971, 0.114 |
| Victim UpperChest | absent | 0, 0, 0 (undriven rest) |

The source's roughly 28-degree component is on the pelvis, not a 28-degree local rotation disappearing from one of the three named spine bones. Target pelvis pitch remains substantial. Source and target local coordinate frames differ, so subtracting these Euler angles would not measure motion fidelity. The source Spine and Chest rest-relative x components are approximately -14.6 and -14.3 degrees; these are different from the raw locals above. This evidence does not support simply adding 28 degrees to a spine bone. With the no-op, head separation is already smaller than authored (0.186 versus 0.216 m), not the excessive separation in the original diagnosis.

Contact result unchanged: left-hand mean 0.124 m, error **70%**. Parse total=2 fails=0; control still exactly 0.302639 / 0.304671. Step 2 subset reruns completed: clip total=10 fails=0; pair total=7 fails=1 (parked fight_pair_live); grapple total=10 fails=0. Existing out-of-tree probe errors persist (90); no SCRIPT ERROR or parse error was emitted. Next investigate arm segment directions and lengths, rather than forcing a missing-lean explanation.

## Step 3 - the arm directions survive; the missing torso segment did not

With the no-op, every measured clavicle, upper-arm and forearm direction on BOTH actors at t=0 agrees with source within 0.0004 degrees. Hips->Spine and Spine->Chest agree within 0.0001 degrees. The remaining discrepancy is Chest->Neck: **8.622709 degrees attacker, 8.622684 degrees victim**. Thus the lower spine carries the source lean, and the arms are not losing their authored direction. The upper torso is over-leaning relative to the source, not missing the source's 28-degree pelvis lean.

`SILHOUETTE_SEGMENTS` asks for Chest->UpperChest. Cascy has no UpperChest. Removing the synthetic joint makes that alignment skip; retaining it supplied a zero-length source segment and an extra rotation drive outside the name map's parent chain. For Cascadeur references lacking UpperChest only, use the real Chest->Neck span in the virtual-rest correction instead. The extra target UpperChest remains at rest. This is a source-derived segment correspondence, with no pose-specific angle, hand target, distance adjustment, or tuned constant. The source files, 28-degree authored lean, root sway and separation are unchanged. UE4_TO_OURS, the loose-node and Skeleton3D indexing paths, and the RamsterZ correction path are unchanged.

Final t=0 segment-direction evidence:

```text
C167SEG actor=att segment=Hips->Spine direction_error_deg=0.000011
C167SEG actor=att segment=Spine->Chest direction_error_deg=0.000007
C167SEG actor=att segment=Chest->Neck direction_error_deg=0.000023
C167SEG actor=att segment=LeftUpperArm->LeftLowerArm direction_error_deg=0.000055
C167SEG actor=att segment=LeftLowerArm->LeftHand direction_error_deg=0.000087
C167SEG actor=vic segment=Chest->Neck direction_error_deg=0.000051
```

The added diagnostic labels source length `source_units`, not metres: raw imported Cascy upper-arm/forearm lengths are 26.368895 / 23.081907, matching the authored 26.4 / 23.1 cm. Target attacker lengths are 0.260658 / 0.243247 m; the victim's left lengths are 0.238750 / 0.291141 m. Retargeting preserves directions but cannot make these different proportions identical.

Final original contact instrument output (nine samples across four seconds):

```text
S31CONTACT measure                   authored      min      max     mean    drift
S31CONTACT att_lhand_to_vic_neck        0.073    0.050    0.075    0.062      15%
S31CONTACT att_rhand_to_vic_neck        0.097    0.091    0.111    0.100       4%
S31CONTACT vic_rhand_to_att_larm        0.083    0.048    0.060    0.055      34%
S31CONTACT head_to_head                 0.216    0.221    0.250    0.234       8%
S31CONTACT hip_to_hip                   0.746    0.754    0.802    0.778       4%
S31CONTACT worst=vic_rhand_to_att_larm 34%
PAIRGAP key=grapple_control table=grapple frames=51 min_gap_m=0.302639 max_gap_m=0.304671 mean_gap_m=0.303635
```

The requested LEFT-HAND gate passes at 15%; not all contacts are within 30% (victim right hand is 34% closer than the authored distance). No hip-gap gate was substituted. No further tuning after the left-hand gate passed.

Final parse: total=2 fails=0. Final subsets: **clip total=10 fails=0; pair total=7 fails=1 (only the operator-parked fight_pair_live_test.gd); grapple total=10 fails=0.** No full suite was run, and the intentional fighter_reachability_contract red was not changed. The contact probe still emits its 90 existing out-of-tree transform errors; its identity fallback is consistent with the explicitly identity-mounted paired setup, but this delivery does not claim an error-free probe or visual/live-bout validation. Measurement logic was deliberately left unchanged under the task's ownership constraint. No runtime SCRIPT ERROR or parse error was present in the contact output.

Reproduce with the installed Godot 4.7.2 console executable:

```text
python Godot/tools/check_scripts.py Godot/scripts/FightClipRetarget.gd Godot/tools/s31_contact_probe.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only pair
python Godot/tools/run_tests.py --only grapple
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/pair_gap_report.gd -- grapple_control
```

Step commits: `27dc2ae7` (no-op, 70%), `a6a45ed8` (local rotations, still 70%), followed by the step-3 source-span correction and final results. Only the three owned paths are included; concurrent edits to AgentComms/roadmap.json and Tools/agent_comms.py belong to others and were not staged.

## Strongest objection and weakest point

The strongest case against this work is that 0.47 m of error on ONE authored clinch does not prove that every Cascadeur clip has the same defect. This pose sits close to reach limits, and different clavicle widths, torso lengths and forearm proportions can move a contact even when ALL segment directions are correct. The final arm-direction measurements support that objection: forcing hand distances further through spine changes would corrupt a now-faithful direction transfer. `FightPoseSolver.gd` already exists, wired to nothing, and driving hand targets after retargeting may be the honest contact-preserving solution across bodies. It was neither read nor changed here.

My weakest point is generalization from one clip, two bodies and t=0 direction diagnostics, compounded by the existing probe's out-of-tree transform warnings. The 15% contact result uses nine samples, not an all-frame contact bound, and an unsigned distance can pass while a hand approaches the wrong side of the neck. To settle it, measure source versus target segment directions and signed hand-to-neck vectors across all 121 frames, on several authored holds and fighter proportions, with transforms read after tree entry; compare the same outputs with and without the existing pose solver. If directions stay correct while contact error scales with body proportions and the solver removes it without corrupting motion, the next repair belongs in contact solving, not more spine correction.
