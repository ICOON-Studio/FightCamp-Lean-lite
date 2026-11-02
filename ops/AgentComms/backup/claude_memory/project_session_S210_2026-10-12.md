---
name: project-session-s210
description: "S210 2026-10-12 - operator body comments (no fat people, attractive women, chest fold), UAL walker belly fixed, retarget trap, check_workflow owned-files trap"
metadata:
  node_type: memory
  type: project
  originSessionId: 7e86c188-e26f-4dff-85f1-dfd2721b6364
  modified: 2026-10-12T08:19:52.987Z
---

S210 (2026-10-12): operator C41 "coaches needs to be slim , do not put fat people in the game , make the women hot" + chest fold
(C42/C46) -> TASK_MH5_CAST_LOOK.md (Codex, next seat). C44/C45 walker pot belly FIXED a36ab18d. Digest research/S210_DIGEST.md.

Lessons:
- Retargeting onto MetaHumans: never re-aim the TORSO segments at a source skeleton's absolute rest aim (UE4 mannequin lumbar 14 deg
  forward vs MH 4 deg back -> pelvis tipped 14-18 deg = fat-looking belly). Numbers-only cast audits PASS while bodies look fat in motion.
- Headless pose probes: AnimationPlayer.seek does nothing headless; set bone poses from tracks and compose globals by hand.
- check_workflow `## Owned files` needs backticked paths or `- path` bullets; a comma list reads as "no path" and refuses a clean branch.
- Cursor "fixes" that hide meshes can blank a portrait; give it measurable pixel-coverage checks (it cannot see images).
- Arena can run two chats at once (STRESSTIP1 + NIGHTLY4); a short prompt pointing at the committed TASK file works.

Related: [[feedback-metahuman-only-no-mpfb]] [[feedback-cursor-cannot-see-images]]
