---
name: project-session-s130-2026-09-30
description: "S130 - rear-hook clipping = KNEE TO KNEE on the centre line (placement, not clips); stance offset asked; SW1 fixed; ops-board Animations page; Higgsfield 1136 cr spent"
metadata:
  node_type: memory
  type: project
  originSessionId: cb0bd429-55b4-4fa6-87ea-d6064db845b1
  modified: 2026-09-29T22:59:40.017Z
---

S130 (2026-09-30, 00:14-02:30), digest `research/S130_DIGEST.md`.

- **Rear hooks:** every source (Mixamo, RamsterZ, Meshy library, QuickMagic T2M) clipped thigh-thigh; q213 `worst_where`
  showed sa=1.00 sb=1.00 = knee to knee, both lead knees within 4 cm of the centre line. Gate probe `lateral=0.16` (~10 cm
  real, opponent toward his lead side) -> rear_hook + rear_hook_body pass every measured row 4/4; rear foot still lifts
  mid-punch (needs a rear-foot plant); shovel still fails. **Queue SO1 asked the operator** (stand fighters off-line in room +
  gate, re-certify the palette). Do not re-try clip swaps / ankle offsets / hip yaw for this - measured dead ends.
- **SW1 done** (e0caa490): bisect -> 3e66fc46 adds two result keys; events byte-identical.
- **Ops board /animations** (operator asked to see every animation + ready/not): `Tools/anim_catalogue.py` +
  `Tools/anim_previews.py`; gate `render video` without `phase` for walks/reactions (phase needs a matched guard ->
  SCRIPT ERROR 'entry_s').
- **Credits:** Higgsfield subscription 136 + free reset 1,000 all spent (manifest D:/FightCamp/meshy_lib/jobs.json):
  45 Meshy library clips (D:/FightCamp/sources/meshy), 15 single-boxer + 7 suit grappling Seedance videos. Meshy GLBs are
  cm under a 0.01 armature - adapter `glb=1` scales. QuickMagic 143 left.
- **Two-person QuickMagic test** on Grapplearts footage: detection is on the FIRST frame only - separated start = 2 people,
  wrapped start = 1 merged person. Pick clips that START apart.

Related: [[project_two_body_motion_workflow]], [[feedback_copyright_irrelevant_for_references]], [[reference_quickmagic]].

**RESUME (operator: 'continue exactly from here'):** S131 opens by asking his two open answers - (1) 'yes download' the QuickMagic two-person result QM2P_1_guard_pass, then run both FBX through the adapter and check the pair in shared space; (2) 'offset yes/no' for SO1. The full recipe is in roadmap now.detail / handover.in_flight.
