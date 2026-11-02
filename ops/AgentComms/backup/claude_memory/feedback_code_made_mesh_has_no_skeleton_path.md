---
name: feedback_code_made_mesh_has_no_skeleton_path
description: "S162 - a MeshInstance3D.new() has an EMPTY skeleton path; unresolved it draws unskinned at rest. Test the renderer's binding, not only the maths."
metadata:
  node_type: memory
  type: feedback
  originSessionId: ef226e6f-51ac-4a70-bcfe-2389853dd7c5
  modified: 2026-10-04T16:36:07.240Z
---

S162 (2026-10-04): the skinned glove's hand-computed geometry was right in every headless test, yet the first
game-camera render drew four gloves at hip height. `MeshInstance3D.new()` carries an EMPTY `skeleton` NodePath (the
".." default is the editor's), so Godot drew the mesh unskinned at its rest vertices, riding the fighter's root.

**Why:** a test that re-implements the skinning formula cannot see what the renderer binds; the only witnesses are the
render itself and the node state (`mi.get_node_or_null(mi.skeleton) == skel`, bind count, surface format bones+weights).

**How to apply:** set `mi.skeleton = NodePath("..")` on every code-made skinned mesh; in any test of a runtime-built
skinned mesh assert the path RESOLVES and the binds name the intended bones (mutant: empty path); open a still from the
game's camera before calling it done ([[feedback_open_the_output_before_the_gate]], CLAUDE.md s2 visual-fix rule).
Companion trap: a pumped live room never re-fires `skeleton_updated`, so anything posed on that signal freezes - pose it
per sample in the test ([[feedback_a_control_that_cannot_move]]).
