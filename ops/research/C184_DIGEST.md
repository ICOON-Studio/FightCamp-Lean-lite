# C184 digest — watch loop take one

## Part 1 — accepted seed

Seed `92012` is the first screened candidate that reaches all three requested
phases in the 60-second fixed-clock recording. The recording used
`discipline=mma`, `--fixed-fps 30`, `--resolution 1280x720`, and
`--quit-after 1800`, with the room defaults unchanged. The recorder completed
1800 frames / 60 seconds. The room HUD is present in every frame and reports
the round clock, active pair key, clip key, gap, and played count.

Phase timeline from one-second room-frame checks:

| Seconds | Phase | Evidence / room pair keys |
| --- | --- | --- |
| 00–16 | standing | Upright room state; `hook_lead`, `kickboxing_roundhouse` and other standing exchanges |
| 17–18 | ground | One fighter is down on the mat in the room state during the transition; the HUD remains on the same fixed-clock exchange |
| 19–24 | clinch | Both fighters return upright in close torso contact; `boxing_one_two`, `kickboxing_axe_kick` |
| 25–34 | standing | Upright separated exchanges; `kickboxing_clinch_knee`, `muay_thai_push_kick` |
| 35–44 | standing | Upright separated exchanges; `boxing_one_two`, `muay_thai_round_kick` |
| 45–54 | standing | Upright separated exchanges; `muay_thai_round_kick` |
| 55–59 | clinch | Close upright contact returns; HUD shows the active pair exchange |

The 12-tile sheet samples seconds 0, 5, 10, …, 55 and labels each tile with
the room-state phase at that checkpoint. The brief ground interval falls
between the 15-second and 20-second sheet checkpoints, so it is represented
in the digest timeline rather than by a 5-second tile.

Rejected search seeds `92000`–`92005` stayed upright in their 60-second
recordings. Seeds `92006`–`92012` were screened with 20-second recordings;
`92012` was then re-recorded at the required 1800 frames.

## Part 2 — deliverables

- MP4: `research/_captures/watch_loop/take1_seed92012.mp4` (7,791,694 bytes; under 50 MB)
- Contact sheet: `previews/watch_loop_take1_sheet.png`
- Sheet generator: `Godot/tools/watch_loop_sheet.py`
