---
name: feedback_camera_can_fake_a_pose_defect
description: "S161 - a \"fold to hands and knees\" and \"ball gloves\" were a ~75 deg top-down camera; re-shoot from the side before fixing a pose"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3eee0c1d-28da-4baa-ac69-6e8cc1425396
  modified: 2026-10-04T14:51:44.533Z
---

Before fixing a body/pose defect the operator saw in a recording, re-record the same seed from a second camera (`record_room shot=low_mat`) and read the shadows. S161: TASK_CROUCH said fighter A "folds to hands and knees" and TASK_GLOVES2 said gloves look like balls with a bare hand beside them. Both were the keep-pair camera lofted to ~75 deg down in a corner; from the side A stood in guard and the gloves were fine (glove_handedness_test 30/0 on MPFB + MetaHuman).

**Why:** the pose log (hips 0.76 m over the deck) and the shadow (a standing figure) already said "standing" - the briefs had bucketed it as a clip/reaction problem from one overhead frame.

**How to apply:** a pose defect seen in one camera = side view + pose_log first; if the instruments say standing, suspect the camera (pitch, foreshortening). Related: [[feedback_bucket_defect_by_clip]], [[feedback_check_videos_before_sending]].
