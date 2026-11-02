# C231B - inside uppercut: source elbow repair and a paired production witness

The overhead arm was the **red-shorts attacker, generator_welter_a**, not the blue receiver (generator_welter_b). The earlier C231 digest's receiver attribution was wrong. The move remains **withheld**; this task does not put it back in `certified_moves.json`. Operator video approval is still required.

## Cause and repair

The original native Cascy source already raises the **right/rear elbow**: first above the head joint at source 0.100 s, maximum 8.56 cm above that joint and 22.81 cm above its shoulder. The retargeted source first crosses the head joint at 0.100 s too (maximum 6.72 cm). Runtime before contact correction reaches 6.76 cm above the head joint, and the glove pin reaches 8.97 cm. Receiver elbows stay below their head. These are head-JOINT comparisons; the new mechanical check uses the capsule head TOP as well as the shoulder, rather than pretending the joint is the top of the skull.

Evidence: `../docs/previews/c231b/source_retarget_before.json`, `source_retarget_final.json`, `source_retarget_heights.txt`; `../docs/previews/c223/c231b_before.json` traces both fighters before/after the contact writer. The opened game-camera frames identify the red attacker by the same moving lead/rear arm poses. The native-Cascy retarget mapping was correct and is unchanged.

The author put the Cascadeur forearm LimbDir target on the elbow joint. That is an ambiguous pole near the solve axis. Both arm poles now sit 50 cm beyond the desired elbow along a downward bend direction; the actual Cascadeur solver supplies all joint motion. The lead arc has no extra upward wrist offset and is capped at 90% of anatomical arm reach, leaving a bent elbow for a compact rising punch. Feet, timing warp, and engine mapping are unchanged. The rest GLB re-export is byte-identical to the prior rest.

Instructional reference inspected: Tony Jeffries, **How to Throw Lead Uppercut in Boxing**, https://www.youtube.com/watch?v=zl2bZwxM_ws (setup and compact rising lead-fist demonstration). Reference only; no video content was copied into the asset.

Reproduce with `python Tools/cascadeur/ensure_server.py`, then `python Tools/cascadeur/build_c231_inside_uppercut.py`. The author now writes a hash-specific completion receipt so an HTTP idle timeout cannot silently skip packaging a successful native export. `audit_c231b.py` verifies all 67 nodes, skin joints, and every retained animation sampler byte against the actual raw Cascadeur export. Hashes and authoring settings are in `Tools/cascadeur/c231_inside_uppercut/receipt.json`.

## The paired gate and video

The old harness held the receiver in a frozen guard and rendered only the attacker's recorded poses. C231B advances the production receiver and starts `play_role("react_head", 0.0, "up")` on the measured contact tick. Production selection currently falls back to an available backward reaction; this is not an invented upward animation. Both fighters' final post-contact poses and root transforms are now recorded and replayed in the uppercut video. The camera is the existing game broadcast camera, 1280x720, 30 fps, with one second of guard before and after the whole move.

Spacing is authored once, before the run, from the whole source body envelope with a 7 cm clearance target. Neither root chases the fist per frame. The final animated clearance is measured separately against the moving receiver. This is a paired audition setting, not an assertion that a withheld move has been admitted to live fight selection. The old gate's bound source/reference labels also incorrectly named its legacy Mixamo candidate; the report now names the actual binding it played.

New mechanical failures cover both fighters: elbow above head top at any time; elbow above shoulder during the strike/contact window; hand above head top outside that window; glove/head penetration; and negative moving-body gap. Position comparisons allow 1 mm numerical/contact residual, not visible head penetration. The original clip fails `arm_height` in `c231b_old_rejected.json`, first at runtime 0.100 s. Raised-arm and glove-inside-head mutants are rejected on all four rigs. No existing threshold was loosened.

| Attacker | Fixed root spacing cm | Minimum moving body gap cm | Minimum torso gap cm | Peak fist m/s | Onset-impact ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| welter_a | 68.91 | 0.671 | 5.771 | 8.253 | 383.3 |
| welter_b | 68.30 | 1.013 | 5.530 | 9.019 | 366.7 |
| heavy_c | 74.42 | 0.684 | 5.874 | 9.062 | 383.3 |
| heavy_d | 73.38 | 0.911 | 5.069 | 9.475 | 383.3 |

`c231b_inside_uppercut.json`: four candidate rows have `mechanical_failures=[]`, both mutants rejected, G147 passing, zero ordinary/pin pops. Maximum glove/head residual is 0.52 mm (welter_a and heavy_c are zero). The runner reports `rigs=4 jobs=2 rows=8 errors=0`; the other four rows are reference jabs, not uppercut certificates.

## Validation and scope

- Parse: `CHECK total=2 fails=0` for the gate and source/retarget probe; Python author/audit syntax checked.
- Required focused suite: `SUITE total=11 fails=0`.
- Final video: `../docs/previews/anim/boxing_inside_uppercut.mp4`, 117 frames at 30 fps (3.9 s), 1280x720. Opened final frames at 0.350, 0.450, 0.617 and 1.117 s of the move; copies are in `../docs/previews/c231b/`. Red keeps the rear elbow down, the lead fist rises from the body, and blue visibly recoils. `c231b_render_final.json` also has no candidate mechanical failures. This is agent visual review, not operator approval.
- Host watchdog checked before heavy work; valid host readings stayed GREEN. The initial sandbox CIM reading was denied and was not used as a health result.
- Import cache existed. One import refreshed the re-export and resource cache; importer-only sidecar changes were restored/removed. No unrelated asset metadata is included.
- The explicit task supersedes unrelated mailbox assignments and the general HANDOFF workflow. HANDOFF.md is untouched. The game-asset-production skill was consulted; its optional CLI was unavailable, so the task-authorized local Cascadeur/Godot pipeline was used.
