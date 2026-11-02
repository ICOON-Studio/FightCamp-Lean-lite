---
name: feedback_judge_the_whole_frame
description: "S160 operator - gloves looked abnormal at normal size in a scorebug video; judge the WHOLE frame like a player, not only the feature being shown"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 5bfe34df-c5b4-433a-b900-c885d797d5da
  modified: 2026-10-04T13:24:07.009Z
---

When sending any video/still, look at the whole picture at normal size as a player would, not only the feature it was made for. S160: I sent a scorebug video; the operator saw at a glance that the gloves look abnormal (ball-like, float off the hand, bare hand visible) - "you do not need to zoom, i didnt zoom either, its so obvious".

**Why:** a "fixed" item (S155 gloves) is not proof it still looks right; the operator judges the frame, not the feature.

**How to apply:** before SendUserFile on a fight clip, list what a player sees (bodies, gloves, hands, feet, floor contact, overlays) and name any oddity; if one exists, fix or flag it before sending. Related: [[feedback_check_videos_before_sending]], [[feedback_gloves_show_a_still_early]].
