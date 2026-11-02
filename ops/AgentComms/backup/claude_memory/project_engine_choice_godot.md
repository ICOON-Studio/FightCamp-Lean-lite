---
name: project_engine_choice_godot
description: "Operator asked 2026-09-14 'should we use unity for the fight?' - answered: stay in Godot (NO ruling yet); every measured defect is logic, not engine; only a bounded UNREAL bake-off if root motion + foot lock + layering still read floaty"
metadata: 
  node_type: memory
  type: project
  originSessionId: 58c40d2b-b056-47b5-8b4e-b0b3ee3f8341
  modified: 2026-09-14T00:01:14.781Z
---

**Asked 2026-09-14 (night) after the operator pasted an article** (AI cannot make AAA martial-arts motion; the polish is
engine-side - motion matching, runtime IK, layering). Claude's answer, recorded in HANDOFF's note block: **stay in
Godot.** It is a recommendation, not a ruling - if the operator rules, quote them verbatim ([[feedback_quote_rulings_verbatim]]).

**Why:** every defect measured so far was logic an engine switch would carry over:
- foot skate was dropped hip travel, and the strike carry cut R3 21%;
- the room slides bodies below walking speed and under their own reactions (U89 TRACE 3);
- walks are clean at 0.03 m/s when driven right;
- strikes land 0.1-0.35 s apart in the engine (Q94B).

Unity has no built-in motion matching (Kinematica was dropped); Godot 4.6+ has `TwoBoneIK3D`, AnimationTree
filters and root motion (K44, K45). A port means C# for the sim, UI and ~280 tests, or a two-engine hybrid. The
article's specific claims were partly off: its tools are Unreal's, and Tekken's moves are authored frame-exact
animations, not motion matching. Motion matching needs a big continuous mocap library, and motion CAPTURE is ruled out.

**How to apply:** do not re-derive or re-litigate this. What would change it: root motion, the foot lock and
layering are all in and the operator still finds the fight floaty. Then run a BOUNDED Unreal bake-off of the same
bout (UE 5.8 is installed; K41 says exports ship royalty-free) before any port - never Unity. Related:
[[project_retarget_quality_is_the_bottleneck]], [[reference_pc_animation_tools]].
