---
name: feedback-cursor-cannot-see-images
description: Cursor's image tool is blocked in its environment - it describes stills it never saw; brief geometric checks and open the stills yourself
metadata:
  type: feedback
---
S194: Cursor (local cursor_task.cmd) reported "image read was blocked" and twice described GYMVIEW1 stills from intent - the office
still it called "office interior" showed the training floor behind an orange slab; its own frustum test passed with the walls on screen.

**Why:** a visual task closed on an agent's word ships a broken view (CLAUDE.md s2: visual fix done only on the game camera, opened).
**How to apply:** every Cursor visual brief demands checks it can compute (projected corners inside the HUD-free area, decal direction
vs camera right, AABBs inside the frame, the mesh covering screen centre) and a red-first run on the defect; Claude opens every still
before merge. Related: [[feedback-open-the-output-before-the-gate]].
