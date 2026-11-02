---
name: feedback_no_feet_only_stills
description: S191 operator furious at feet-only fight stills - stills go through still_framing.gd; mat shots never for standing fights
metadata:
  node_type: memory
  type: feedback
  originSessionId: fe303029-85b2-4be6-8131-da16524e6bd5
  modified: 2026-10-09T22:19:29.040Z
---

Operator S191 (2026-10-10): "the stills are useless there is only feet showing, fix the fucking camera once and for all i do not want
to see any more pictures with feet only".

**Why:** agent still tools passed `camera_shot: "establishing"` + `camera_follow: false` (Q55's mat-pair shot that FightCameraRig itself
says "cuts both heads off" standing men). Eleven tools did. The stills were never the game's camera (`broadcast` + follow, set by
FightNightScreen), so "closed on the game camera" was false, and Claude's own review said "opening the stills" without first checking
which camera made them.

**How to apply:** before opening any fight still, check the tool's camera options. Stills save only via
`Godot/tools/still_framing.gd` `save_if_framed` (refuses unless both men are head-to-feet in frame). FightWorldLiveScreen forces
`broadcast` + follow for windowed boxing runs (`standing_shot_for`; opt-out `allow_mat_shot` only for ground work).
`tools/camera_framing_check.gd -- as_game` is the proof run. Every still brief names this. Related: [[feedback_judge_the_whole_frame]],
[[feedback_open_the_output_before_the_gate]].
