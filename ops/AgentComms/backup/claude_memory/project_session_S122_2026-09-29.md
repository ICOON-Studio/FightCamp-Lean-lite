---
name: project-session-s122-2026-09-29
description: "S122 - hip-drop foot drag fixed, footwork stopped landing as punches (+ retune), Q215/Q216 collected, nightly reds, C: freed 93 GB, Kimi set up, release map; KM1 + U196 in flight"
metadata:
  node_type: memory
  type: project
  originSessionId: d799320e-f0b6-4f10-84f3-7b7759c7f6d7
  modified: 2026-09-29T01:40:27.932Z
---

S122 (2026-09-29, night): S122_DIGEST.md is the record. Carry forward:
- **Hip-drop foot drag**: cause = the drop lowered the feet and the plant bake flattened a real 2.6 cm step -> one long
  plant -> foot lock glide. Fix in FightClipFootPlant (keep each sole's pre-drop clearance). A first fix in
  `_plants_for` made it WORSE (23-52 cm) and was reverted.
- **Footwork landed as punches** (25-33% of thrown/landed in game config): every `setup`-role catalogue node became a
  strike. Now `FightCommitment.is_movement_only` -> `footwork` event, behind switch `footwork_no_contact` (game ON,
  tests OFF - seeded pins stay byte-identical). Retune: JAB_USAGE_MULT 2.6, CONTACT_LADDER 0.58, FOOTWORK_MULT 0.25.
  Operator approved "fix + retune". The room does not yet schedule `footwork` events (footwork clips need that).
- **Traps found**: a bound witness without `live_contact` reads the fist through the target (fake 14-16 m/s);
  sequence certificates for one_two/double_jab = run8_bound + run10_jab_bound (later file wins); a missing cert key
  hangs c223_sequence_gate. `--script` runs keep switches OFF - a "switch caused it" claim for a test is usually false.
- **Qwen**: two wrong causes in one delivery again (S122 blamed; a suite-record commit cited) - verify every cause.
- **Operator decisions**: Cascadeur cancelled (ends 10-27); Higgsfield kept, review before 10-14; Kimi = pay-per-use
  Moonshot key (recharged); Luma judged not useful now; the Van stance short -> D64 springy-stance modifier (backlog).
- In flight at handover: U196 (Cursor), KM1 (Kimi trial). See [[project_kimi_agent]], [[feedback_worktrees_on_d]].
