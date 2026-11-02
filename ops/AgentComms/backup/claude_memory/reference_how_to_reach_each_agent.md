---
name: reference_how_to_reach_each_agent
description: "S224 operator \"save it in your memory how you use each agent\" - the exact working channel per agent (verified 2026-10-14), roles, traps"
metadata:
  node_type: memory
  type: reference
  originSessionId: 38843fd0-0b48-4c09-a2fe-8dc8e3813f16
  modified: 2026-10-14T11:46:00.136Z
---

One line per seat: ROLE | HOW TO LAUNCH | HOW TO COLLECT. Verified live S224 unless marked. Roles = operator S178 ([[feedback-agent-roles-s178]]).

- CODEX (big multi-file code, our tools; PC) | PowerShell: `$env:CODEX_MODEL='gpt-6-astra'; $env:CODEX_EFFORT='high';
  $env:CODEX_REPO='E:\FightCamp\wt\<NAME>'` then `Tools\agent_window.ps1 -Title <T> -Command Tools\codex_task.cmd -ArgumentString
  "<prompt.txt>|<out.txt>"`; watchdog first; seed the worktree (seed_godot_cache.ps1). Verify the codex.exe cmdline shows `-C E:\...\<NAME>`.
  | read the out file + worktree git log + its *_DIGEST.md; merge by diff. Trap: a run can die silently (S224 ANIMCHAIN2 died at 13:19,
  no out file) - check the PID + last commit time, relaunch with a RESTART note appended to the prompt. The 2 codex.exe "app-server/
  exec-server" processes are the operator's DESKTOP app, not a run.
- ARENA (pure modules + tests; cloud, free, first choice) | BUILT-IN pane: navigate https://arena.ai/agent (repo ICOON-Studio/FightCamp
  + master pre-selected), execCommand('insertText') into [contenteditable=true], click button aria-label /send/; a short prompt pointing
  at a committed TASK file works; NEW chat per task | PR from arena/<chat-id>-fightcamp: read CI log yourself (`gh run view --log`,
  grep the test's PASS line), `ci_arena.py guard <pr>`, apply diff to master, close PR. Never its Merge button. See [[reference_arena_agent]].
- CLOUD CURSOR (Godot UI/gameplay) | commit TASK_X.md, `gh issue create --label cursor --body-file TASK_X.md` | branch cursor/issue-<n>.
- GOOSE (long cloud jobs) | `gh issue create --label goose --body-file ...` | branch goose/issue-<n>. Trap S224: its last commit on
  #184 reverted 439 files (stale tree) - take only its own small commits by diff.
- QWEN / GROK DEV / CLINE / OPENROUTER (cloud) | label `qwen` / `grok` / `cline` / `openrouter` on an issue (cloud-agent.yml).
- GROK BOTS JOHN (research) / KALLI (design only) / MARIA (art) | S224: VIA xAI API, not gbot: `gh workflow run xai-research.yml
  --repo ICOON-Studio/FightCamp -f task=<TASK file> -f bot=john|kalli|maria -f out=research/<X>_XAI.md` (secret XAI_API_KEY;
  Tools/xai_ask.py, Responses API + web_search, picks the newest grok-4.x; ~1 min) | `git fetch origin xai/<out stem>` and
  `git show origin/xai/<stem>:<out>` > the file, commit to master. gbot (`Tools/gbot.py`) is BROKEN since S222: the Grok Bot app
  keeps its roster on its cloud pod ("Could not find a Grok Bot agents directory").
- DOLA (fresh eyes, research #2) | `python Tools/cici/cici.py status`; if "No CDP on 9333" the app was auto-started at login without
  the port: stop Cici.exe by PID (the --launch_from=auto_run one) and `cici.py launch` (operator S224 said the window may open), then
  `cici.py send --new --file <brief> --wait 5` | `cici.py read --out <file>`. Verify her sources (fast mode is shallow).
- LUDO (lead game + art designer; operator approves verdicts) | Claude-in-Chrome (Brave), app.ludo.ai/assistant, All Chats ->
  "Gym Management Screen"; insert with execCommand into [placeholder="Type a question or request here..."], send button | save:
  `python Tools/arena_rx.py <dir>` in the background, inject an `<a target=_blank href="http://127.0.0.1:8799/?name=X.txt&d=...">` and
  click it with the computer tool (never navigate the Ludo tab there). Ludo cannot read GitHub: give it LUDO_CONTEXT_PACK.txt
  (Tools/ludo_context_pack.py, LUDOCTX1) + uploaded stills. See [[reference_ludo_ai]].
  LIMITS (S224): ONE image per message, images only (an mp4 is refused) -> for a video: `E:\FightCamp\tools\npm\ludo.cmd files upload <mp4>`,
  put the printed URL in the text + attach a frame grid (ffmpeg = C:\Python314\Lib\site-packages\imageio_ffmpeg\binaries\ffmpeg-win-x86_64-v7.1.exe,
  tile=3x2). Send with the arrow AFTER scrolling the page so the box is fully visible - a click near the box hit a SUGGESTION CHIP twice.
- ANTIGRAVITY (agy; PC, file tools only) | see [[feedback_agy_file_tools_only]].
Every launch/landing -> AgentComms/live_runs.json; every brief has Prior research / What would a human do? / Prefab check.

