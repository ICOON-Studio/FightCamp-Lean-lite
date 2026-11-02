# C170 - rejected closed-guard revision, 2026-09-24

**Not delivered.** Stopped under the task's instruction to report suspected contact loss in the retarget/mount path without editing FightPoseSolver, FightClipRetarget, or PairedStagePlayer. The exact faulty function is not established; none of those implementations was opened or changed. No rejected GLB is admitted by this commit.

## Scope and baseline

Worked alone on codex/c170-closed-guard, created from origin/master using the operator's requested startup command. The current baseline already contained both Cascy_ClosedGuard GLBs and the bjj_guard entry, despite the task describing them as new. Did not read any digest, HANDOFF, CURRENT_STATUS, or HANDOFF_ARCHIVE. The operator's startup/read instructions superseded AGENTS.md brief/inbox and HANDOFF workflow. The task's stop instruction supersedes completing a new binding with a failing candidate.

Opened the accepted closed_guard_locked_sheet.png and the generated four-angle sheet. The baseline sheet was nearly static and did not show the reference's broken-down, posture, punch sequence. Its existing probe passed at 23.765509% worst drift while both supposed collar contacts were about 0.494 m from the neck: preservation of a miss, not a grip.

## Authored candidate and declared contacts

Bottom fighter is Att: he owns the closed guard and ankle lock. Original controller targets were applied inside Cascadeur 2026.2 via its live script server. 121 frames at 30 fps, 4 seconds, with a broken-down top fighter, posture change, two short punches, and a return to the held position. Dimensions, timing, and amplitudes are artistic choices informed by the accepted image, not measurements from footage. The top fighter's right wrist is held by the bottom fighter's left hand.

The owned-file list excludes s31_contact_probe.gd although the prose requires declaring contacts there. Requested clarification, left that repository file untouched, and declared the exact contacts in a temporary copy BEFORE applying the controller animation:

- att_lfoot_to_att_rfoot: LeftFoot/a to RightFoot/a (same body).
- att_lknee_to_vic_torso: LeftLowerLeg/a to Spine/b.
- att_rknee_to_vic_torso: RightLowerLeg/a to Spine/b.
- att_lhand_to_vic_rwrist: LeftHand/a to RightHand/b.

The inherited native scene initially solved knees away from their requested targets. A second controller-only update sets each calf direction from its desired knee plane after the body/foot solve. This corrected the kneeling base and bottom knee wrap. No joints or mesh vertices were directly posed. Exported each actor separately with animation enabled; removed the character1: prefix from Vic node names without altering its binary geometry or animation buffer. No role was inferred using an Att substring.

## Rejection evidence

Final temporary-contract probe, 241 samples:

| Contact | Mean source m | Mean target m | Worst drift % |
|---|---:|---:|---:|
| Same-body ankle lock | 0.089997730 | 0.137118932 | 52.359104 |
| Left knee / torso | 0.272708697 | 0.280813558 | 5.043183 |
| Right knee / torso | 0.261601213 | 0.268711008 | 5.139592 |
| Left hand / right wrist | 0.084859054 | 0.190174445 | 128.591813 |

At frame zero the wrist separation vector changes from (-0.060000, 0.060000, -0.000001) m in the exported source to (0.025449, 0.058580, -0.178757) m in-game. Both knee-to-torso vectors acquire approximately 0.197 m of depth difference even though their scalar distance ratios pass. This is evidence of source-to-game contact loss; a precise implementation diagnosis needs a separately authorized read/edit scope. Did not compensate by widening thresholds or moving authored contacts apart merely to improve a ratio.

RENDER total=1 fails=0 and SHEET total=1 fails=0, all 24 tiles populated. Opened the final sheet: two fighters, top kneeling inside bottom's wrapped legs, visible ankle crossing in high/side views, and a visible posture change. The wrist grip is not convincing and the ankle lock is not accepted as maintained skin contact. The six sampled moments do not independently establish the full punch trajectory. A populated render is not acceptance. This candidate fails the required <=30% contact ceiling.

Local rejected artifacts (not admitted to the repository): C:/Users/user/AppData/Local/Temp/c170-authoring/ contains build.py, CLIP.json, apply_clip.py, ClosedGuard_authored.casc, both candidate GLBs, contact_probe.gd, contact.log, render.log, and rejected_sheet.png. The authored source and failed evidence remain available for a bounded follow-up.

## Validation and disposition

- Parse gate before execution: FightClipBinding.gd CHECK total=1 fails=0; temporary contact_probe.gd CHECK total=1 fails=0. No repository .gd was edited.
- --only clip: SUITE total=10 fails=0.
- --only grapple: SUITE total=11 fails=2. grapple_adapter_test has 8 assertions concerning the seeded Muay Thai throw witness, striking totals, and scorecard; grapple_naming_contract_test reports Muay Thai coverage 96/119 = 80.7%, below 85%. These were reproduced individually. No simulation source was edited; no baseline rerun is claimed.
- --only pair: SUITE total=7 fails=1, fight_pair_live_test (operator-parked expected red).
- --only technique_id: SUITE total=1 fails=0.
- Exact repository tools/s31_contact_probe.gd -- bjj_guard also rejects the candidate: 52.359104% worst drift, failures=1. Its collar labels are not a suitable wrist-grip contract.
- Unchanged clinch control: printed left-hand drift 15%; unchanged side-control control: printed chest drift 15% (probe rounds to integers). The exact 14.8173% side-control number and RamsterZ 0.302639 / 0.304671 were not independently remeasured in this run. No control asset or retarget/mount code change remains, so no numerical regression claim is made from those rounded values.
- Initial tests failed on the expected TitleHonours and missing-import errors. Ran the prescribed headless --import; its process eventually exited 1, but the class/font cache populated and the retry passed technique-ID and clip gates. Generated import metadata was removed/restored after testing.
- No full suite. Rejected GLBs were copied into the temporary evidence directory, then restored byte-for-byte to HEAD. Existing binding, repository probe, and all control source files are unchanged. Only this rejection report is committed.

Follow-up needs a bounded authorization to investigate source-to-game contact preservation in the currently excluded retarget/mount files, plus resolution of the probe-owned-file conflict. Do not mark C170 complete from this report or its passing render/sheet counters.
