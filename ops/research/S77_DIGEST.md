# S77 digest - 2026-09-25 - the fight camera and the flickering hands

## Shipped (master, pushed)
- 1722e6a7, 662a3a34, 8d25f644 - THE CAMERA OPERATOR. `scripts/FightCameraDirector.gd` (pure): aim at a pre-filtered,
  dead-zoned, critically damped midpoint of the two men's hips+chest (never limbs); J51 numbers (aim 0.30 s / zoom
  1.0 s half-lives, 25 deg/s pan cap, 15%/s zoom, 20% zoom hysteresis as fill 0.84/0.68/0.50); orbits to stay side-on
  to the fighters (1.5 s half-life, 30 deg dead zone, never crosses the line); no live hit cam (J51 6.8). New
  `broadcast` shot (lens 2.6 m over the deck, ~27 deg down - `standing` sat at top-rope height, 1.35 vs 1.37 m) is
  the career default via `camera_default_shot` (a view saved with C still wins). Switch: `camera_director`.
- HAND FLICKER, cause named from frames: the contact clean-up (solver push + refused-overlap passes) re-derived a
  contact normal that flips when a glove is deep in the other man, toggling the lead hand 10-30 cm on alternate
  frames. Fix `FightStagePlayer.settle_hand_offsets`: the arm CORRECTION (not the clip) is critically damped
  (0.05 s) and capped (3.5 m/s) in skeleton space. Switches: `hand_offset_smooth`, `push_flip_guard`.
- 85b0e41b UIKit technique preview: `get_meta(key, null)` errors on a missing key in Godot 4 -> guarded (operator's
  console flood on hover). Agent windows launch minimized (operator: "stop those popups").
- Exe rebuilt (Builds/FightCamp_Godot, pck 213 MB); WHAT_TO_TRY updated.

## Measured (tools/s77_camera_probe.gd, seed 4242, boxing, room default A/B pair, C198 glove meshes, 20 s, 30 fps)
| | old | new |
|---|---|---|
| camera turn p99 / max deg/s | 41.8 / 323.8 | 24.4 / 24.5 |
| camera pan max m/s | 15.3 | 1.3 |
| both men head+hips on screen | 81.8% (standing), 15-20% (establishing) | 100% |
| hand reversals (all 4 hands, rel. hips) | 135 | 35 |
| worst hand toggle amplitude | 30 cm | 6 cm |
| refused overlap p99 / max | 8.3 / 12.7 cm | 7.9 / 12.4 cm |
| frames with > 1 cm overlap | 22 | 92 (shallow; the cost) |
| body root reversal max | 2.8 cm | 3.3 cm (more frequent - follow-up) |
MP4: `research/_captures/watch_loop/s77_camera_before_after.mp4` md5 604a48874cd007982ed5da3c831c3c29
(before.avi 51931454..., after.avi 7fa5903f...). OPERATOR VERDICT: "the bottom view is perfect, congrats" and
"i could clearly see the hook and the dodge and it looked like real". Then: ropes annoying while it rotates ->
broadcast shot (8d25f644).

## Tests
Focused subsets on master: 22 (camera, hit cam, live room, fight night, room_, contact_, pose solver hands, body
layers, paired stage, schedules, c168/c169, foot contacts) fails=0; camera+night+live 4 fails=0; skills/preview 2
fails=0. NIGHTLY: no `AgentComms/nightly/latest.txt` exists yet - no nightly number to cite.

## Collected
J51 (John, camera craft - built on), G99 (Grok, CompuBox: ~50 thrown / ~15 landed / 41% jabs per round; our card
~25 / 50-60% / ~20% - U174's target), D21 (Dola, UFC round averages, raw). Q175 pass 3 LANDED 00612582 (floor
unreachable, keeps 0.0050) - NOT merged yet: re-run its pooled numbers first.

## New operator direction (all S78+)
- "fighters are a lot more static ... they mostly stay in place and try to exchange" + "side stepping faking ... while
  their body doesnt move much the posture is changing". Measured: boxing 72-84% of frames moving, ~50 m/min.
  -> G100 (Grok, time-motion), Q176 (Qwen, footwork economy, RUNNING), C204 (Codex, alive-in-place stance, QUEUED).
- UI: "the whole ui is pretty densed ... how blizzard, EA, Sega make their menus perfect", tooltips with short "how it
  works" text, show things NOT LINKED in tooltips, remove unnecessary text, a tutorial built from research that Claude
  can play in front of him. -> J52 (John), M32 (Maria), S78 = MENU CLARITY.
- Rotating globe for the world screen: wanted ("impress me") - after the menu stage.

## Follow-ups
- Root nudges more frequent with hand smoothing (placement reads last frame's pose).
- Orbit can briefly let one man hide the other (30 deg dead zone + lag).
