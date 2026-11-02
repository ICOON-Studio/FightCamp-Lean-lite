# Codex toolkit (S211)
Operator S211: "make sure codex has access to all our tools needed to complete the animation correct and fast"; "codex needs always to
have access to everything". `Tools/codex_task.cmd` prepends a pointer to this page (Tools/codex_header.txt) to EVERY Codex prompt, turns
web search on and makes `E:\FightCamp` + the main checkout's `.git` writable on every run. Every path below was checked on this PC (S211).
Use what exists before building anything new.

## Launch (Claude)
`$env:CODEX_MODEL='gpt-6.1-sol'; $env:CODEX_EFFORT='high'; $env:CODEX_REPO='E:\FightCamp\wt\<ID>'` then
`Tools\agent_window.ps1 -Title ... -Command Tools\codex_task.cmd -ArgumentString "<prompt>|<out>"`. Always on: web search live
(CODEX_WEB=disabled opts out), writable E:\FightCamp + main .git (CODEX_ADD_DIR adds one more), this page in the prompt.

## Paths that differ inside Codex
- The launcher sets LOCALAPPDATA=E:\FightCamp\codex_localappdata, so `%LOCALAPPDATA%\Programs\Godot` is WRONG inside Codex. Godot:
  `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64.exe` (NEVER `_console.exe`: it opens a window on his monitor).
- Main checkout (read anything there): `C:\Users\user\OneDrive\Documents\ChatGPT\Game`. Your worktree: `E:\FightCamp\wt\<ID>`.
- ffmpeg: `C:\Python314\Lib\site-packages\imageio_ffmpeg\binaries\ffmpeg-win-x86_64-v7.1.exe` (frames from a video:
  `ffmpeg -i in.mp4 -vf fps=10 out_%03d.png`, then open the frames with your image tool). Python: `python` (3.14).

## Authoring
- Cascadeur 2026.2 (licence ends 2026-10-27): `C:\Program Files\Cascadeur\cascadeur.exe`. Start it ONLY with
  `python Tools/cascadeur/ensure_server.py --hidden` (hidden desktop `WinSta0\FightCampCascadeur`, scripting channel inside the GUI).
  How-to: `Tools/cascadeur/README.md`. MetaHuman pipeline (341 joints, Biped quick-rig, AutoPhysics, no retarget):
  `research/ANIMSOURCE1A_DIGEST.md`, then the 1B/1C/1D digests. Scripts: `Tools/cascadeur/animsource1/` (author_palette.py,
  produce_palette.py, animation_only_*.json, receipt_*.json, physics_1c.json), `Tools/cascadeur/apply_pose.py`, `apply_clip.py`.
- Blender 5.2: `C:\Program Files\Blender Foundation\Blender 5.2\blender.exe` (`--background --python <script>`; FBX export of the
  MetaHuman skeleton for Cascadeur). Helpers: `Tools/blender/`, `Tools/blender_moves/`.

## Measuring (gates that SEE the shape)
- `Godot/tools/move_shape_probe.gd` - per-move shape gates (straight_path, elbow_at_contact, elbow_height, no_wrap, pair_clearance,
  guard_shape once added); writes move_shape.json + sheets.
- `Godot/tools/c223_guard_probe.gd`, `measure_clip_shape.gd`, `measure_clip_punches.gd`, `probe_clip_keys.gd`, `probe_hand_pop.gd`
  (frame-to-frame hand jumps) - all in `Godot/tools/`.
- C223 production gate, ~3.5x faster in parallel: `python Tools/c223_parallel.py production -- <gate args> report=<x>.json`.
- Contact sheets: `Tools/paired_contact_sheet.py`, `Tools/compose_before_after.py`; clip inventory `python Tools/clip_status.py new-anims`.
- Live-fight stills: ONLY through `Godot/tools/still_framing.gd` `save_if_framed` (both men head to feet; never a feet-only still).
- Windowed Godot only via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>` (hidden desktop);
  headless with the absolute Godot path above. Tests: `python Godot/tools/check_scripts.py <files>` (parse gate first - a parse error
  hangs a headless test), then `python Godot/tools/run_tests.py --jobs 1 --only <one,comma,list>`.

## What correct looks like (research + real footage already in the repo)
- Guard as numbers: `research/D64_GUARD_STYLES.md` s6.1. Orthodox classic: lead glove at CHEEK height ~0.15 m in front of the
  face, rear glove at the JAW, elbow flare 15-30 deg fresh (45 max), chin tuck 0.8, weight 55% front. Never above the brow.
- Punch research (sourced numbers), all in `research/`: `K52_WHERE_A_PUNCH_LANDS.md` (point on the head, the arm at impact,
  glove travel), `K53_BODY_TRAVEL_PER_PUNCH.md` (distance each punch is thrown from), `K54_THE_TIMELINE_OF_A_PUNCH.md` (when feet, hips,
  shoulders and fist move), `K49_TORSO_IN_A_HOOK.md`, `K50_SPACING_AND_REACH.md` (how far apart boxers stand), `G75_STRIKE_SPEEDS.md`,
  `J21_THE_MOVE_PALETTE.md`, `J50_HOW_A_DEFENDER_DEFENDS.md`.
- REAL MOTION REFERENCE VIDEOS: `previews/c209/shadowboxing_take1_raw.mp4` + `shadowboxing_take2_raw.mp4` (7.9 s each), each
  with extracted pose `landmarks.json`, `measurement.json` and `sheet.jpg` in the folder of the same name (see C209_DIGEST.md);
  heavy-bag takes `E:/FightCamp/refs/gym4/heavy_bag_take1_raw.mp4`, `heavy_bag_take2_raw.mp4`; boxing pair in mocap suits
  `research/_captures/ground_video/s116_mocap_boxing_suits_v2_720p.mp4` (S116_MOCAP_SUIT_PRACTICE.md).
  NOT reference: `previews/anim/*.mp4` are OUR clips and show the current defects.
- Ludo (lead animation designer) rulings: `LUDO_ANIMATION_BRIEF_S196.md` (chin-to-sternum 14-19 cm in high guard; elbows pinch first on
  guard changes), `LUDO_ROUND38_ANIMATION_S204.md` + reply files + `LUDO_ROUND38_VERDICT_S204.md` (fatigue sag, inside uppercut at
  0.9-1.1 m), `LUDO_ANIMATION_R12_S192.md`, `LUDO_ANIMATION_R13_S193.md`.
- Older work on anything: `python Tools/prior_research.py <terms>`; settled decisions `research/DECISION_LEDGER.md`.

## Seeing your own output
Open every sheet/still/frame with your image tool and say in the digest what you SEE (glove vs the face, elbow vs the ribs). Compare
side by side with a frame of the real reference video. A number that passes on a wrong-looking sheet is a broken gate - fix the gate.

## Ludo - lead game/art/animation designer (S219, operator: "give web acess to codex")
- ASK LUDO (design chat): your `browser` MCP tool (Playwright, HEADLESS Brave, its own profile E:\FightCamp\codex_browser_profile,
  signed in to the operator's Ludo). Open https://app.ludo.ai/assistant and pick the chat "Gym Management Screen" (project FightCamp -
  read the chat header; another chat has none of the game's context). Send the whole question as ONE message: set it with
  `document.execCommand('insertText')` into `[placeholder="Type a question or request here..."]`, then press Return once (typed
  newlines cut it at ~400 chars; a click near the box can hit a suggestion chip and send that instead). Ask for the longest complete
  answer with numbers; give it our real measurements. Wait until the reply stops growing, read it with JS in slices, save it VERBATIM
  to `research/LUDO_<TASK>_R<n>.txt` with its char count. Limit 30 requests / 5 min: one big batched ask, then "continue".
- Ludo's numbers are a draft - your gates and the visual gate still decide. Animation-technique answers you may apply directly; a
  change to design, mechanics or the look goes to Claude for a verdict and the operator's approval before it is built.
- LUDO GENERATORS: the `ludo` CLI (E:\FightCamp\tools\npm\ludo.cmd). Read `ludo agent-help` first. 3D: `ludo model animate`
  (0.2 credits, 4 candidate clips; `--mode rot_only` to retarget onto the MetaHuman skeleton), `ludo model rig`, `animate-preset`.
  Always set a budget (`max_credits` in .ludo.json); exit 11 = stop and report. Trial brief: research/TASK_LUDOANIM1.md.
- If Ludo shows a sign-in page: stop and report "Ludo browser profile not signed in". Never type a password, never open a window.

## Safety
Watchdog before every heavy step: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (exit 1 = RED,
wait). One Cascadeur at a time. Nothing opens on the operator's screens (no image viewers, no visible browser - your browser tool is
headless). Commit + push your branch after each batch - a run that dies uncommitted loses hours. Never master.
Ask Claude (in your digest or AgentComms/messages) for: fal.ai generations (`Tools/gen/fal_generate.py`, paid) or anything that needs
the operator.
