---
name: project-session-s77-2026-09-25
description: S77 - camera director + broadcast shot + hand flicker fix (operator "perfect"); fighters too mobile; UI too dense; power cut mid-session
metadata:
  type: project
---

S77 (2026-09-25). Shipped the live fight camera: `FightCameraDirector.gd` (torso midpoint, J51 half-lives, 25 deg/s cap, side-on orbit, no live hit cam), `broadcast` shot 2.6 m over the deck as career default (`standing` sat at top-rope height). Hand flicker: the contact clean-up's normal flips when a glove is deep in the other man; fixed by damping the arm CORRECTION (`FightStagePlayer.settle_hand_offsets`), never the clip. Instrument: `Godot/tools/s77_camera_probe.gd` (camera, hand buzz, overlap, footwork, per-stage attribution via `debug_stage_observer`).

Operator verdicts, verbatim: "the bottom view is perfect , congrats", "i could clearly see the hook and the dodge and it looked like real". Then: ropes annoying while rotating -> broadcast shot.

New direction: fighters move far too much (72-84% of frames, ~50 m/min boxing) - "they mostly stay in place and try to exchange", posture alive, feints, side steps, bursts -> G100/D22 research, Q176 engine, C204 stance. UI "pretty densed", placeholders, wants tooltips with how-it-works text, NOT LINKED flags, less text, a researched tutorial Claude plays in front of him (visible window) -> S78 menu clarity, J52/M32. Wants a rotating globe ("impress me"). "let me know when you have done a breakthrough" - report only real milestones.

A power cut killed Qwen/Codex and closed Grok Bot/Cici; Cici restarts WITHOUT its debug port after a reboot - kill Cici.exe and `cici.py launch`.

[[feedback-show-animation-as-video]] [[feedback-operator-is-the-playtester]] [[feedback-no-popups]]
