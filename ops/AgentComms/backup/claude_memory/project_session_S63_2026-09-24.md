---
name: project-session-s63-2026-09-24
description: "S63 - C168's grip solve never ran in the game (binding id vs Cascy key); HOLD_GRIPS for 11 holds incl. legs; suite 375/9; operator split lanes (agents engine+motion, Claude management+GUI)"
metadata:
  node_type: memory
  type: project
  originSessionId: 66f5d21e-ef90-4f2f-9b7d-6ce74aaf1c26
  modified: 2026-09-24T00:18:14.220Z
---

S63 (2026-09-24). The live room grafts paired holds with `meta.pair_key` ("Cascy_SideControl") but
C168's grip preservation was gated on the BINDING id ("bjj_side_control"), so it never ran in the game -
only in the probe and tests. Fixed with `PairedStagePlayer.HOLD_GRIPS` keyed by the clip's own pair name,
arm AND leg chains, same-body rows (crossed ankles), room switch `pair_grip_solve` (default ON; NOT
`contact_solve`, which is S4a's glove push). Live key OFF->ON: side control 133%->2%, closed-guard ankle
23.8%->0.0003%. `FightPoseSolver.refine_hands` (roots frozen) + Cursor's blind contract. Suite 375/9.

On screen the change is centimetres - the operator saw a before/after clip
(`previews/s63_grips_before_after.mp4`) and then asked what to prioritise ->
[[project_watch_loop_2026-09-24]]: agents own engine+motion, Claude owns management+GUI.

Traps paid: the u145 probe REWRITES `research/U145_DIGEST.md` every run (restore it); the overlap
rise (0.200 s) is NOT S63 (control arm identical) -> Cursor U154; Qwen's Q162 "both men at the same
position" was a probable x10 unit mismatch (source /100 assumes Cascadeur cm) -> Q163; Dola cannot
restore an archived chat and invents a plausible one when asked (D9 closed as lost); `render_paired_hold`
now has film mode (frames=, view=, grips=off, tag=). Grok Bot weekly usage hit 98% (resets ~09-25).
J45: MakeHuman/MPFB2 assets CC0 and shippable, code not; SMPL blocked.
Related: [[project_session_S62_2026-09-24]], [[project_contact_solver]].
