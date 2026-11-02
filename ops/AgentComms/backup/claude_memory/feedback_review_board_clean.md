---
name: feedback-review-board-clean
description: "S226 operator cleared the review board (\"a mesh\") - new versions replace old posts via --supersedes, one post per thing"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8233a0c3-47f2-4615-8181-0727c0565e0a
  modified: 2026-10-15T18:40:41.441Z
---

S226 (2026-10-15) operator: "stills and videos on board are a mesh can you remove and start over from now". All 30 posts moved to
E:/FightCamp/review/_removed (Removed tab restores them); review_filter.json allow_folders emptied.

**Why:** every round added a new post beside the old ones (globe v1/v2/v3, ANIMFIX before/after, rooms), so he could not tell which
picture is current.

**How to apply:** one post per thing he judges; a new version of the same thing uses `python Tools/review_add.py ... --supersedes
<old batch prefix>` and then the board's "keep latest" removes the old one; captions say what changed. Never post a still nobody needs
him to judge (contact sheets, debug crops go to SendUserFile or stay local). Related: [[feedback_questions_for_operator_go_on_the_board]].
