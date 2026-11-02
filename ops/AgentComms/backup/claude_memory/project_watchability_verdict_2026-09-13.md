---
name: project_watchability_verdict_2026-09-13
description: Operator watched the real-time 3D fight and called it painful - watchability first; the live game must look like the recorded video; how to record and send a clip
metadata: 
  node_type: memory
  type: project
  originSessionId: 7ac8cef1-b75c-4a15-9261-764fed72e105
  modified: 2026-09-13T20:38:32.791Z
---

**2026-09-13 night the operator asked to SEE the 3D fight to decide on purchases, and was very disappointed:**
"painful to watch", "worse than 4 days ago", "no walking only teleporting", "feet do not move, the sprites
just slide", "the camera cuts their knees", "one is bare hands, the other wears gloves", "the seconds go by
much faster". Then: "what I am seeing in the video is much better than when you run it through the game" and
**"i want to have the same result in both - do measurements, make it happen"**.

**Why it looked bad (all found that night):** 24 of 33 actions played NO clip (the engine throws ~20 named
boxing techniques, only 3 had clips - R103's "named technique or nothing" rule left men standing); the room's
shell camera sits at floor height under the 1.27 m ring canvas (FightCameraRig never applied); FIGHTER_B f09 is
a bare-knuckle mesh; the readout clock redraws only on actions; the pace is ~1 action/s with no breathing gaps
(reads as fast-forward); the live run shared the CPU with four hung Cursor Godot tests. Months of realism gates
(joins, feet, R1-R5) never measured any of this.

**How to apply:** the next session's order is in AgentComms/roadmap.json (merge `claude/watchable-room`, then
live-run smoothness vs the video, fight pace, no sliding, knockdown in the count, the room's own camera, the free
Unity model tools the operator pointed at). At EVERY landing render the same bout and look at it before calling
anything done; gate the degraded share of actions. See [[feedback_assert_the_quantity_the_user_sees]] and
[[feedback_open_the_output_before_the_gate]].

**Recording a clip the operator can watch on the phone:** `tools/watch_live_room.gd` (branch
claude/watchable-room: walk-in, full-body camera from the head/toe bones, live clock, real-time stopwatch).
`Godot_v4.7.2-stable_win64.exe --path Godot --write-movie <repo>/Builds/Windows/previews/x.avi --fixed-fps 30
--quit-after 1650 --script tools/watch_live_room.gd -- seed=810039` (~35 s to render 55 s; seed 810039 has a
knockdown at 27.6 s). Write inside the repo (Builds/ is git-ignored) - shell writes outside it are overlay-only
([[project_shell_sandbox_split]]). Transcode with the installed `C:\Program Files\BlueStacks_nxt\ffmpeg.exe`
`-c:v h264_mf -b:v 3000k -pix_fmt yuv420p -movflags +faststart` (~20 MB; nvenc fails, no libx264), check frames
with `-ss N -frames:v 1`, then SendUserFile. Kill stray Godot processes first - they make everything crawl.

**Before/after clips, 2026-09-14:** tools/watch_live_room.gd takes `lock=off` and `join=dead`; record the same seed twice
(Builds/Windows/previews/record_s4a_*.cmd). The BlueStacks ffmpeg has NO drawtext filter - label and stack with cv2
(Builds/Windows/previews/side_by_side.py, feet_closeup.py; MSMF avc1 writes ~190-265 MB), then transcode h264_mf
4000k (~24-33 MB) and SendUserFile. Ask the verdict with AskUserQuestion options. See [[project_operator_verdict_foot_lock_2026-09-14]].
