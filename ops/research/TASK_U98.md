# TASK U98 — CURSOR — OUR PUNCH CLIPS, MEASURED THE WAY THE VIDEO STUDY MEASURES REAL BOXERS

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u98-clip-punch-metrics` - Claude creates it from
`master` before launch. Push the BRANCH. Stage: S4a (the operator's "punches look fake").

**Test tier: A NEW TOOL ONLY, NO PRODUCTION SCRIPT EDITED.** Parse gate on the new `.gd`; the tool run; no
`run_tests.py`. `python research/U98_check.py` must exit 0 before you commit - if it cannot, do not commit: send
`--topic "U98 BLOCKED"` with its FAIL lines. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_clip_punches.gd` - NEW.
- `research/U98_clip_punches.json`, `research/U98_CLIPS_VS_VIDEO.md` (25 lines at most) - NEW.

## Why this exists

The operator, 2026-09-14: "watch YouTube videos and learn the moves". Claude tracked real boxers frame by frame with
MediaPipe and measured each punch in TORSO LENGTHS (T = shoulder midpoint to hip midpoint). To know what our bought
clips get wrong we need the SAME numbers from our clips, on our bodies. The video numbers (Tony Jeffries, 31 jabs):
extension (onset to peak) 0.07-0.37 s, median ~0.17 s; return (peak to back) ~0.1-0.3 s; elbow at peak 141-164 deg;
wrist at peak 0.05-0.6 T below the nose; body travel onset to peak: IN PLACE (two thirds) hips <= 0.13 T, head
<= 0.2 T, feet ~0; PUSHED off the rear foot hips 0.10-0.16 T, rear ankle 0.16-0.21 T; STEPPED hips 0.20-0.28 T, front
ankle 0.14-0.32 T.

## What to measure (these definitions are the video study's - mirror them exactly)

For each fighter mesh f01 (`FightWorldLiveScreen.FIGHTER_A`) and f09 (`FIGHTER_B`), bind a production
`FightStagePlayer` on a still body (no room, no warp) exactly as `tools/probe_take_skate.gd` does, call
`take_animation_clock()`, and for EVERY key of the player's `_contact_s` whose role (take name before `#`) is one of
`jab`, `jab_lead`, `cross`, `cross_lead`, `hook_lead`, `hook_rear`, `uppercut`, `strike_head`, `strike_body`: play it
from idle (`play_role(role)` until that take is current) and step `advance(1/30)` to the take's end, composing bone
positions from the CURRENT pose each frame (`_pose_global`-style: headless-safe, never `get_bone_global_pose`), then:
- `T` = distance between the midpoint of LeftUpperArm/RightUpperArm and the midpoint of LeftUpperLeg/RightUpperLeg at
  REST, composed from `get_bone_global_rest` through the skeleton's world transform (on f01 it is ~0.50-0.53 m).
- per frame, for each hand: `reach = |Hand - its UpperArm| / T`; smooth with a 3-frame moving average; the PEAK is the
  frame of the hand with the larger rise (peak minus its minimum over the take's first half); `onset` = the last frame
  before the peak with reach <= min + 0.2 x rise; `back` = the first frame after the peak with reach <= min + 0.5 x rise
  (none if it never falls back).
- `forward` = the skeleton's world +Z, flattened and normalised. Travel along it, in T, onset->peak and onset->min(end,
  peak + 0.5 s): hip midpoint (LeftUpperLeg/RightUpperLeg), `Head`, FRONT ankle and REAR ankle (`LeftFoot`/`RightFoot`,
  front = farther along `forward` at onset).
- `elbow_deg_peak` = angle UpperArm-LowerArm-Hand at the peak (180 = straight); `wrist_below_head_T` = (Head.y -
  Hand.y) / T at the peak; `contact_s` = `_contact_s[take]`.

`U98_clip_punches.json`: `{"population": {"meshes": ["f01_m_box_welter", "f09_m_bare_welter"], "fps": 30,
"definitions": "U98 = the video study's"}, "takes": [{"mesh", "take", "role", "hand", "T_m", "onset_s", "peak_s",
"back_s", "contact_s", "onset_to_peak_s", "peak_to_back_s", "reach_rise_T", "elbow_deg_peak", "wrist_below_head_T",
"hip_to_peak_T", "head_to_peak_T", "front_ankle_to_peak_T", "rear_ankle_to_peak_T", "hip_to_half_s_T",
"front_ankle_to_half_s_T", "rear_ankle_to_half_s_T"}, ...]}`.

`U98_CLIPS_VS_VIDEO.md` opens with `## DECISIONS`: a table - role -> our extension s, return s, elbow, wrist below
head, hips / head / front / rear ankle to peak (T), and which of the video's three patterns (in place / pushed /
stepped) the clip is; then one line per finding where a clip is outside the video's range.

## Commit

`git status -s` first. Commit ONLY the owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u98-clip-punch-metrics`; `python Tools/agent_comms.py send --from cursor --to claude --topic
U98-ready --body <hash>`. Do not edit HANDOFF.md or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`,
`clean`, `rebase` or `merge`.

## The trap

A take played on the player's own clock only advances when YOU call `advance`; and `get_bone_global_pose` answers from
a cache headless (it returns REST) - every number would then be the rest pose and every take would read "in place".
The check pins each take's peak to the player's own `_contact_s` (farthest reach) within 3 frames, which a rest-pose
reading cannot pass.
