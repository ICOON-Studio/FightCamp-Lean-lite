# C168 - side control contact fix

**PASS: all six declared contacts are below 30%; worst is 15% (14.8173% at the
stronger all-sample check), down from 133%. Both controls are unchanged.**
The independent source knee-authoring defect is also corrected: attacker knee
centres are now 4.84 cm above the mat instead of about 31 cm. This is source
support evidence, not a claim of target skin/mat visual certification.

## Before / after, unchanged authored contract

| Contact | Authored m | Before drift | Final mean m | Final drift |
|---|---:|---:|---:|---:|
| Attacker left hand -> victim neck | .067218 | 40% | .067 | 0% |
| Attacker right hand -> victim hip | .107919 | 15% | .109 | 1% |
| Victim left hand -> attacker neck | .067150 | 133% | .067 | 0% |
| Victim right hand -> attacker hip | .069579 | 66% | .071 | 2% |
| Chest -> chest | .196900 | 15% | .226 | 15% |
| Hip -> hip | .421600 | 7% | .449 | 7% |

No contact was removed or redefined. No source hand pose was tuned to compensate
for retargeting. The original six-field bjj_side_control binding remains in
PAIRED_STRIKE_BINDINGS, as corrected by the operator; it is a technique-keyed
Side Control, control role, legal in ground_top, not a grapple-event ID.

## Diagnosis before engine edits

The operator expanded ownership to FightClipRetarget.gd, PairedStagePlayer.gd
and focused tests, explicitly refusing FightPoseSolver.gd. That solver remains
unread and untouched. Before editing either allowed engine file, the new stage
witness compared all 121 frames after source sampling, direct retarget,
registration with mounting suppressed, and shared mounting after tree entry.

The victim neck frame changed **.067230228 -> .156139068 m at retarget**.
Graft registration changed it by **zero**, and identity mounting changed it by
**zero**; maximum differences across all six contacts/all frames were both
0.000000000000 m. Other rows are in C168_SIDE_CONTROL.md. Target lengths differ
while directions survive: the victim forearm grows .23082 -> .29114 m and the
upper arm shrinks .26369 -> .23875 m. Contact loss is in independent retargets,
not an extra displacement introduced by graft or mount.

## Repair

A paired-retarget pass now opts in only for bjj_side_control, before registration.
It obtains each animated source's **signed** hand-to-neck/hip vector, then solves
the two target arm bones with their own lengths to preserve that vector. Wrist
orientation is retained. It changes rotation keys, never target bone lengths,
source hand poses, authored contract values, body placement or the one-mount
invariant. RamsterZ and the clinch do not opt in. This is a narrow contact
specification in the live paired path, not a blanket change to every clip.

The final stage witness separates this paired-retarget correction from
registration. Victim neck-frame means: source .067230328, independent retarget
.156138549, paired retarget .067230327, registered .067230321, mounted .067230321 m.
Independent repeats differ by at most .000000230968 m; mounting still adds zero.

Separately, the generator wrote calf_LimbDir while excluding calf_MainPoint.
Cascadeur re-solved that direction point and left the knees high. Writing knee
MainPoint while excluding its solver-owned direction/additional point gives
4.84 cm knee centres, with the feet still at 11.72 cm and all reported upper-body
source contacts unchanged. This leg repair addresses the source authoring defect;
it was not used to improve the retarget contact score. Both single-actor GLBs
were re-exported and committed immediately.

## Final gates on the re-exported assets

| Check | Result |
|---|---|
| Parse changed engine scripts and focused tests | total=4 fails=0; later diagnostic-only revision total=1 fails=0 |
| Stronger endpoint contract | 7,720 checks, zero failures |
| --only clip | **SUITE total=10 fails=0** |
| --only pair | **SUITE total=7 fails=1**, only parked fight_pair_live_test.gd |
| --only grapple | **SUITE total=10 fails=0** |
| RamsterZ | **0.302639 / 0.304671**, full PAIRGAP line byte-identical to baseline |
| Clinch att_lhand_to_vic_neck | **15%**, full contact line byte-identical to baseline |

Each subset used one --only. No full suite; no intentional reachability-test
change. The endpoint contract samples 241 times (keys plus midpoints), tests two
actual rigs, unequal body scales 0.93/1.08 and a rotated/translated mount,
asserts all six ceilings on the original pair, signed hand offsets, unchanged
limb lengths, breathing occurrence and one shared mount. Final maximum signed
error .000000485 m; limb-length error .000000179 m; worst per-sample drift
14.8173%. These tests run after tree entry with no engine errors.

The original s31_contact_probe still has its inherited out-of-tree transform
warnings (108 side-control / 90 clinch); its calculation was not changed.
Independent after-tree-entry tests reproduce and strengthen the result. No game
render or recorded bout was visually reviewed. A new source screenshot attempt
did not capture Cascadeur and is not counted as validation. Signed joints do not
prove absence of mesh penetration or ideal elbow bend direction.

## Checkpoints

- 17e39da4: original authored clip exported and committed before binding.
- c0726226 / 19f7c4b3: original binding, measured negative and digest.
- 1d6edb1b: stage-isolation evidence before engine edits.
- 967fd4fc: contact-preserving retarget plus focused endpoint contract.
- de782119: corrected knee controllers and re-exported pair.

All commits use explicit paths. Concurrent FighterCapsules.gd edits and staged
AgentComms work were left alone. No fetch/rebase, stash/reset/clean, HANDOFF edit
or broad context exploration. The task-specific rules superseded general
startup/handoff instructions. Detail and reproduction: C168_SIDE_CONTROL.md.

## Cost and strongest objection

The initial failed delivery had a recorded lower bound of **17.3 minutes**.
The recorded end-to-end wall-clock span for this one four-second pair is now
**35.7 minutes**, from 22:46:11 to 23:21:51 on 2026-09-22 (Asia/Nicosia).
That includes the follow-up, user clarification/waiting, diagnostics, repair,
re-export and checks; it is not billed model-compute time. Initial startup before
the first recorded timestamp and final commit/push/message overhead are excluded.
No token or monetary cost is exposed. One pair now passes the numerical contact
gate; zero visually certified in-game holds were delivered in this run.

**Arguing against myself:** hand-authoring one hold per session still does not
establish a viable way to close 376 missing clips. Even mechanically multiplying
this measured wall time gives about 223 hours, before entries, escapes,
submissions, releases, more body shapes, skin-contact review and revisions.
376 weekly sessions are 7.2 years; rework can make that a decade. That is a
cadence scenario, not a throughput forecast. This session makes one hold's
contacts work and provides a reusable endpoint primitive, not a batch plan.

**My weakest point remains visual and physical validity:** the body-depth proxy,
elbow bend plane and knee surface support were not certified in a game render.
Distance and signed-joint tests are necessary but cannot make those claims.
The honest scale-up is either to cut the catalogue to motions we can actually
show, or generate held positions from explicit contact/support specifications
and validate their transitions across bodies. A single successful numerical
fixture cannot substitute for that work.
