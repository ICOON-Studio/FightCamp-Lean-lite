<!-- S177: the CLOUD S176 session's digest (branch claude/walk-clip-gym-hall-3d-meqiti), kept beside master's S176_DIGEST (BUYER1). Code merged e89949b4. -->
# S176 DIGEST (cloud session, Sonnet 5.5, 2026-10-06/07) - the walk clip, the ring stairs, and the cloud control plane

Request: roadmap now (2) WALK CLIP in the 3D gym hall + stills + 30 s video; then (operator, same session) control every agent from the cloud, add parallel runners, fix what he saw in the video.

## Shipped on the branch `claude/walk-clip-gym-hall-3d-meqiti` (NOT merged; operator OK pending)
- `GymHall3D.gd`: walk clip (c207 walk.glb retargeted as WalkoutShot does; frames 43..65 @20 fps; hips XZ drift removed; cached per fighter id; "floor/walk" in the
  body's Clip player; speed_scale = 1.4 / measured ground speed; the take walks IN PLACE so the speed is the planted left foot's slide: 1.11 m/s -> 1.257).
  `_stop_walk_clip` on arrival (he no longer walks on the spot while preparing). Ring stairs (`_build_ring_steps`, 4 steps) + rope gap; `_place_on_route` uses
  `HallLayout.height_at`. `GymHallLayout.gd`: route climbs/descends `steps`; `gym_hall.json` ring `steps`.
- Tests (PC runner, green): `gym_hall_walk_clip_test` 10, `gym_hall_ring_steps_test` 10 (control: old straight leg jumps 0.95 m), gym_hall_3d 29, gym_hall_panel 6,
  daylap_splice 20, day_lap 81, gym_hall_layout (all). Video `tools/gym_hall_video.gd` (mp4 sent to the operator twice). 1,091 pending untracked import/texture files committed on the branch.
- Operator verdict on the second video: "not bad, needs some fixing" -> `TASK_GYM3D1_SMOOTH.md` (the next session's job).

## Master (infra, all pushed)
pc.yml: tests/windowed/agent jobs; stderr captured; `$parts` @() bug (every test ran `tests/g.gd`!); Godot import once per work folder (the runner had never imported: fonts missing,
every test hung); LFS pull + out folder; guard `Tools/pc_guard.ps1` (time limit, idle priority, heat stop by PID); heat WAIT instead of refuse; per-run concurrency (no cancelled queue);
.avi -> .mp4 compress; `agent` job (cici / grokbots / arena, TASK files only). `Tools/pc_add_runner.ps1` (extra runners), `Tools/arena/arena.py` (UNVERIFIED selectors),
cloud-agent.yml: openrouter + cline seats + key-first check. Commits: 3d4719b0 10aa6458 80821601 1926d310 d1298922 39972b43 d4ae0b14 218b2ac2 e6ba7cb2 3de815f7 460eb4fd 51efae28 16df1971 eedc4cfe 736c295e.

## State of the agents (read before delegating)
- PC runners: `fightcamp-pc` (E:\actions-runner-fightcamp) + `fightcamp-pc-2`; they do NOT autostart: start with PSExecutionPolicyPreference=Bypass (AGENT_TOOLS.md). The 4 other runners on the PC are the SPACE project's: never touch.
- Dola: up on 9333 (started by hand with the flag). Grok bots: up on 9222. Both only while the apps run with the debug port. John J63 (TASK_J63_WATCHABLE_WALKING.md) was sent twice (first run died on --wait; second: run 37552270209, transcript NOT yet collected - check its pc-out).
- Cloud seats: secrets present CURSOR_API_KEY, GEMINI_API_KEY, QWEN_API_KEY (Qwen quota returns ~2026-10-07 16:00 UTC; a reminder was scheduled). Missing: OPENROUTER_API_KEY (openrouter + cline seats), XAI_API_KEY (grok). Goose on #33 and Cursor on #36 were launched 23:57/23:59 UTC: results NOT read. Issue #56 already done on master (69c2245d); remove its stray `openrouter` label.
- Codex: issue #59 (MH3a) tagged `@codex`, no answer: the Codex GitHub app is not connected to the repo (chatgpt.com/codex). 9% quota, resets in ~3 days. Antigravity CLI (`agy`, headless) is a possible new seat, not built.
- Arena: driver written, Chrome never launched (arena.py launch + Google sign-in), selectors unverified: run `arena send --dry-run` first.
- Actions budget: operator allows $10 (cloud seats run); the key check now fails in seconds.

## Operator rules learned
Every command for his PC starts at `C:\Users\user` in cmd (wrap PowerShell: `powershell -NoProfile -Command "..."`); his PC heat limit stays (jobs wait, never refuse); never touch the space project (ICOON-Studio/space-strategy, read-only look done).

## Backlog noticed (not done)
Name tag stays "ON THE MOVE" during prepare; coach is much bigger than the fighter; fighters are barefoot (no boxing boots); `images` subcommand of the agent job needs --out; Antigravity seat; a coach/mount-ropes animation (generated, costs money).

Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_hall_ring_steps_test.gd`
