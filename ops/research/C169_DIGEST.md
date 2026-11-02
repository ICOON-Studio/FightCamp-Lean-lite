# C169 â€” per-hold results

## Closed guard â€” skipped (2026-09-22)

`bjj_closed_guard` is absent from `Godot/assets/data/technique_catalog.json`.
Per C169 step 1, no substitute ID, clip, or binding was invented.
The existing s31 probe represents each endpoint as bone plus actor (`a`/`b`),
so a same-body ankle pair is expressible without changing its schema.
No contact measurements or controls were run: there is no eligible clip.
Authoring elapsed: 0 seconds (not attempted); catalogue/probe inspection time
was not separately instrumented and is not an authoring-cost measurement.
C169's restricted reads and no-fetch/no-rebase/no-HANDOFF rules override the
AGENTS entry workflow. No solver changes.

## Half guard — contact gate PASS

`bjj_half_guard` exists, was unbound, and has ground_bottom/control semantics.
_Att is the bottom guard player with the active frame; _Vic is the top passer.
Declared before authoring in `c169_hold_contact_test.gd`: top left knee to both
bottom upper-leg joints, bottom same-body foot clamp, top cross-face, bottom frame.
Expected overlaps: bottom legs around the top left leg; chest pressure and
cross-face around the bottom head/neck. These are not generic penetration failures.
The thigh measurements are joint-centre distances, not skin clearance tests.

| Contact | Source mean m | Before target m | After target m | Before worst drift | After worst drift |
|---|---:|---:|---:|---:|---:|
| Trapped knee / left thigh | .656746199 | .685614715 | .685614715 | 4.441856% | 4.441856% |
| Trapped knee / right thigh | .590776320 | .616419776 | .616419776 | 4.383746% | 4.383746% |
| Same-body foot clamp | .076138020 | .092783439 | .092783439 | 21.879022% | 21.879022% |
| Top cross-face | .070704116 | .110143847 | .070704122 | 55.889203% | .000499% |
| Bottom frame | .070719429 | .076013272 | .070719423 | 7.584634% | .000434% |

241 samples, including interpolation midpoints; every declared contact <=30%.
Diagnosis: C168 correction only opts in bjj_side_control, and its solver handles
arms only, with anchor actor fixed to the other body. The probe itself already
supports same-body pairs. One fix pass enabled the existing arm correction for
the two half-guard hand contacts. Leg-clamp drift passed without a leg correction;
this is not evidence that the arm solver supports legs. No retarget or solver edit.

Required controls (fresh measurements):
```
RamsterZ control              0.302639 / 0.304671   exact printed match
clinch att_lhand_to_vic_neck  15% (existing rounded probe output)
side control                14.8173%, 7720 checks, failures=0
--only clip                 SUITE total=10 fails=0
--only grapple              SUITE total=10 fails=0
--only pair                 SUITE total=7 fails=1 (fight_pair_live_test only)
```
Parse: 3 touched scripts, no failures. First sandboxed measurements emitted log
and certificate errors; the final probe and controls ran outside that restriction.
Visual limitation: the Cascadeur screenshot is obscured by rig controls; no
in-game visual acceptance is claimed. Contact preservation is the passed gate.
Authoring/gating elapsed from fresh scene setup to this report: 552.4 s
(9.21 min), excludes initial API discovery and final push latency.
Reproducible source: build_half_guard.py, rest RIG.json, CLIP.json and
HalfGuard_authored.casc; paired exports are in CASCADEUR_DIR.

## Back control — contact gate PASS

`bjj_back_control` exists, was unbound, and has ground_top/control semantics.
The current catalogue says tier 2 (the task's tier-1 aside is stale).
_Att is the fighter behind, applying the hooks and seat-belt; _Vic is in front.
The probe contract was declared before authoring: each foot to the corresponding
opponent knee, each seat-belt hand to the opponent chest, and same-body hand clasp.
Expected overlaps: hooks enter the inner-thigh region; arms wrap the chest with
one elbow routed over a shoulder and the other below the armpit. Joint-centre
measurements do not constitute skin clearance or collision validation.

| Contact | Before source m | Before target m | Before worst drift | Final source m | Final target m | Final worst drift |
|---|---:|---:|---:|---:|---:|---:|
| left_hook | 0.266910595 | 0.256663365 | 3.852429% | 0.191631312 | 0.225171181 | 17.520353% |
| right_hook | 0.266913091 | 0.254249403 | 4.800743% | 0.191633578 | 0.224264632 | 17.034969% |
| over_shoulder_hand | 0.155900604 | 0.178169279 | 14.355457% | 0.155897270 | 0.179248238 | 15.060124% |
| under_arm_hand | 0.155619008 | 0.162495742 | 4.557423% | 0.155590235 | 0.162874687 | 4.833804% |
| seatbelt_clasp | 0.084827570 | 0.096491064 | 13.776385% | 0.084827516 | 0.096491010 | 13.776295% |

241 samples, every declared contact below 30%; final worst **17.520353%**.
First authoring already passed at 14.355457%. Mesh-only visual diagnosis exposed
a raised/suspended base (hip controllers at 35 cm). The ONE fix pass lowered both
hip origins to 10 cm and rebuilt/re-exported the hold. This improved the seated
base while increasing worst drift to 17.520353%, still below the ceiling.
No contact-correction code was added: the direct rotation retarget sufficed for
this authored geometry. C168's correction remains arm-only and cross-body-only;
its lack of leg/same-body correction support is confirmed by inspection, not
mistakenly claimed solved because these contacts happen to pass.

Required controls repeated after final exports:
```
RamsterZ control              0.302639 / 0.304671   exact printed match
clinch att_lhand_to_vic_neck  15% (existing rounded probe output)
side control                14.8173%, 7720 checks, failures=0
half guard                  21.879022%, failures=0
--only clip                 SUITE total=10 fails=0
--only grapple              SUITE total=10 fails=0
--only pair                 SUITE total=7 fails=1 (fight_pair_live_test only)
```
Parse gate: binding and expanded C169 probe both pass. No full suite was run.
Measured elapsed, start of this hold through final validation/report:
**494.1 s (8.24 min)**, excluding final commit/push latency.
Includes the source visual correction and the repeated filtered suites.

Sources: build_back_control.py, RIG.json, CLIP.json, BackControl_authored.casc.
Visual evidence: source.png (before), source_after.png (after) beside the sources.
A later read-only mesh review of the already-pushed half guard is recorded as
c169_half_guard/source_mesh.png. The earlier obscured-screenshot limitation is
resolved for source review only. Neither hold has in-game visual acceptance;
the numerical contact gate is measured on the actual grafted fighter animations.
The task's per-hold stop rule is honored: half guard one correction; back control
one correction; no further refinement attempted. FightPoseSolver.gd stayed closed.

Final disposition: closed guard skipped (absent exact catalogue ID); half guard
and back control authored, exported, bound, measured, and separately committed.
