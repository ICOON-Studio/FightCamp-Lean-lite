# C212 Mixamo training audition

**All four clips auditioned on the immutable f01 rig; all four are USABLE WITH EDIT, none is certified as-is.** Heavy bag is the strongest next cleanup candidate. Four MP4s and decoded contact sheets were inspected, with one commit per clip. No game binding or manifest changes.

| Clip | Verdict | Duration s | Slip p95 m/s | Pose seam degrees | Root velocity seam m/s | Root XZ drift m |
|---|---|---:|---:|---:|---:|---:|
| Punching Bag | USABLE WITH EDIT: planted-foot pinning and small hand-to-prop IK | 3.233333 | 0.063623 | 0.000457 | 0.013686 | 0 |

| Jumping Rope | USABLE WITH EDIT: contact-foot IK/height cleanup and velocity-aware seam blend | 2.566667 | 0.245759 | 0.002337 | 0.836142 | 0 |

| Boxing Warm Up | USABLE WITH EDIT: trim warm-up arm swings, contact cleanup, velocity-aware loop blend | 6.300000 | 0.332206 | 0.000181 | 0.704392 | 0 |

| Speedbag | USABLE WITH EDIT: hand-path IK to the fixed bag and support-foot cleanup | 6.633333 | 0.073613 | 0.000166 | 0.027868 | 0 |

[Heavy bag MP4](../docs/previews/c212/punching_bag.mp4), [decoded contact sheet](../docs/previews/c212/punching_bag_contact_sheet.jpg).

Reviewed decoded MP4 frames across the cycle and immediately before/after the wrap. The original f01 fighter, dark hanging cylinder and half-metre floor grid are visible from the fixed elevated side camera. Repeated straight punches return to guard, the body stays at its station, and the seam poses agree. Eight extended strikes fit one fixed cylinder with 0.018800 m p95 absolute wrist-sphere gap (range -0.018800 to +0.013865 m). This is a wrist-centred 6.5 cm sphere approximation, not skinned glove collision. Retargeted planted-foot motion remains; pin contacts before treating this as finished. No editing beyond net root detrending has been applied.

## Method and evidence

The immutable C200 f01 GLB hash is checked at runtime. Its mesh, skin weights, inverse binds, 22 bone rests and 1.85 m height remain unchanged. Explicit 22-row Mixamo map: original `mixamorig:` namespace becomes `mixamorig_` in Godot. All four source files were inspected: identical unanimated T hierarchies, straight horizontal arms, +Z toes and hips at 1.042749 m, distinct from the motion's first pose. Their own saved T hierarchy is therefore the measured rest reference; frame zero is never used as rest. `FightClipRetarget.build_silhouette_corrections` and `retarget_clip` perform per-bone orientation/proportion correction, with hip-height scaling 0.970242 into f01 metres. No production retargeter edits.

Raw resources preserve full authored XZ travel. Station resources subtract only the linear start-to-end XZ trend, retaining weight shifts and vertical hops. Both are measured; saved station `.res` resources are reloaded for measurements and rendering. Pose seam is maximum local shortest quaternion angle across 22 bones. Landmark seam is maximum world-joint gap. Root velocity seam compares first and last one-sided 30 Hz intervals. Drift includes both horizontal and 3D results in each JSON.

Mixamo has no supplied contact flags. Contacts are inferred from source foot/toe landmarks within 3 cm of their own minimum height and vertical speed <=0.35 m/s, sustained at both endpoints. Horizontal speed is deliberately not a filter. Slip measures retargeted horizontal landmark speed, pooled p95 with sample counts and per-foot p95 retained. This is not a skinned-sole test. C209 used supplied source flags and a 1.78 m mount, so its figures are context, not a controlled identical-contact comparison. C209 raw bag p95 was 0.274832/0.248767 m/s, pose seam 51.562832/176.029141 degrees; Mixamo's bag is materially more stationary and closes without a pose blend.

Prop placement uses only retargeted f01 hand paths: local reach maxima above 0.45 m for bag punches (guard peaks excluded), then least-squares fitting of a fixed cylinder. All strike rows and signed surface gaps are retained. No prop follows the hands.

## Reproduction and gates

```
python Godot/tools/check_scripts.py tools/c212_mixamo_audition.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c212_mixamo_audition.gd -- clip=punching_bag render
python previews/c212/package_review.py punching_bag
```

Repeat with `jumping_rope`, `boxing_warm_up`, `speedbag`. Each MP4 contains two complete cycles at 30 fps; sheets are decoded from the MP4 including the wrap. Intermediate PNGs are locally retained and ignored. Parse gate: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`. No suite, per task tier. Godot emits `Reading less data than requested` FBX buffer warnings but completes all mapped tracks and saves/reloads the animation; these warnings are not hidden. Optional game-dev CLI is absent; task-authorized Godot pipeline used directly. All windowed renders use the required hidden launcher.

C212's research-only/no-HANDOFF rule overrides the general HANDOFF block instruction. No forbidden status/handoff files were read or edited.

## Jumping Rope review

[MP4](../docs/previews/c212/jumping_rope.mp4), [decoded contact sheet](../docs/previews/c212/jumping_rope_contact_sheet.jpg). Reviewed distributed decoded frames and the four seam frames: recognizable repeated small hops and alternating arm/hand cycles, in a fixed patch of the grid; no rope is claimed. The body does not walk away. End poses match, but the 30 Hz root-velocity difference is 0.836142 m/s, so position agreement is insufficient. Toe landmarks range -0.0134..0.0846 m left and -0.0167..0.0902 m right, revealing slight ground penetration. Contact slip p95 0.245759 m/s over 43 inferred sustained intervals needs contact IK and height cleanup while preserving the airborne phase, plus a velocity-aware seam blend. Verdict is **USABLE WITH EDIT**, not ready as-is or a certified rope-prop interaction.

C209 raw skipping slip was 0.128181/0.280195 m/s and seams 10.903650/24.250427 degrees. Its edited candidate achieved zero pose seam, 0.184514 m/s slip (only 10 flagged samples) and 0.573998 m/s 30 Hz velocity seam. Mixamo improves raw pose closure but does NOT beat that candidate's reported slip/velocity numbers; contact definitions and stature differ as documented above.

## Boxing Warm Up review

[MP4](../docs/previews/c212/boxing_warm_up.mp4), [decoded contact sheet](../docs/previews/c212/boxing_warm_up_contact_sheet.jpg). The full source starts with loose bouncing and broad arm swings, then raises guard and throws air punches with upper-body movement before returning to its opening stance. The floor grid shows bounded movement, not C209's walk-away. This is a warm-up sequence rather than a finished continuous shadowboxing drill. **USABLE WITH EDIT**: trim the opening arm-swing section if used as shadowboxing, choose a compatible guard-to-guard loop, blend velocity at that new seam, and correct support-foot drift. No such trim is silently applied here: the MP4 is the whole 6.3 s source repeated twice.

Slip p95 is 0.332206 m/s (370 inferred sustained intervals); max per-landmark p95 is 0.379386 m/s at the left toe. Root velocity mismatch is 0.704392 m/s despite near-identical endpoint poses. C209 raw shadowboxing slip was 0.157060/0.401123 m/s with pose seams 15.886048/96.427071 degrees and velocity seams 0.012714/0.531086 m/s. Mixamo gives a complete bounded motion and closes its pose, but the full-clip slip is between those takes and velocity seam is worse. Do not label it production-ready from pose closure alone.

## Speedbag review

[MP4](../docs/previews/c212/speedbag.mp4), [decoded contact sheet](../docs/previews/c212/speedbag_contact_sheet.jpg). The small dark cylinder is at head height, with the fighter's hands cycling around it while his stance stays in the same floor-grid patch. Both hands do not consistently meet this one stationary prop after retargeting: the 16 automatic reach maxima have signed wrist-sphere gaps from -0.0602 to +0.1508 m, p95 absolute 0.150831 m. The head-height cylinder center is (0.008740, 1.636484, 0.466276) m, radius 0.075 m and height 0.22 m. Speed-bag circular recovery motion means reach maxima are **candidate events**, not manually certified impacts; these residuals describe the sampled path against the fixed prop, not a count of 16 missed hits. No moving-bag physics is faked to hide the mismatch.

**USABLE WITH EDIT**: establish actual impact phases, align/IK those hand paths to the bag and animate the bag response, then pin support contacts. Pose and station closure are strong, but neither proves prop contact. Slip is 0.073613 m/s over 796 inferred sustained intervals, velocity seam 0.027868 m/s. There is no speed-bag C209 baseline, so none is invented.

## Delivery notes

The raw source loops already return horizontally: removed net XZ drift is below 0.000001 m for every clip. Thus root detrending is numerically negligible; it is not responsible for hiding travel or achieving the verdicts. Raw/station comparisons, per-foot values, source hashes and all source rest transforms are in each `measurement.json`; per-frame f01 world landmarks and inferred flags are in `landmarks.json`. The `.res` assets contain only canonical rotations and hip positions and are addressed by bone name for offline playback, not wired into any game station. Use `FightClipRetarget.address_tracks` if later binding is separately approved.

Visual review here means direct inspection of decoded MP4 frames across each full cycle and immediately around each wrap; it is not a claim of a human sign-off or validated rope/bag simulation. The animated props remain simple fixed audition stand-ins. Existing f01 gloves are retained even for the no-rope skipping audition.
