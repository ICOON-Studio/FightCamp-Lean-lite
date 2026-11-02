# AGENT TOOLS - how each agent is launched and what it can use (verified S131, 2026-09-30)

Operator 2026-09-30: "make sure their tools are recorded for you to know and that all agents can work 100% with the
required tools for their tasks". Live state (in rotation, notes): `AgentComms/roster.json` / ops board 127.0.0.1:8787.
Rules: as many shell agents as the PC takes - the watchdog GREEN before EACH launch is the only gate (operator 09-30 "they can run if the pc can take it"; D11), IDLE priority; consoles start HIDDEN (operator 09-30, no windows);
one worktree per agent on D:\FightCamp\wt\<ID>; read the out-file + worktree, never the rc.

## Shared toolkit every SHELL agent has (verified S131 in the agents' environment)
- Godot 4.7.2: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe`; windowed renders ONLY via
  `Tools\godot_hidden.ps1` (off-screen, no popup); parse gate `python Godot/tools/check_scripts.py <file>`.
- Blender 5.2.1 LTS headless: `"C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" --background --python x.py`
  - probe S131: ran and exported a GLB under Cursor's shim HOME.
- Python 3.14 + PIL 12.3 + numpy 2.5; git; ffmpeg via imageio_ffmpeg.
- Assets: `Godot/assets/models/props/kenney/` (36 CC0), `props/gym/` (Tripo, ours), fighters; concept art for every
  room/scene `previews/concepts/` (+ CONCEPT_ART_INDEX.md); research `research/` (+ RESEARCH_INDEX.md at the repo root,
  `python Tools/prior_research.py <terms>`). AGENTS.md at the repo root points at all of it.
- No downloads, no purchases, no web images in room/art tasks.

## Worktree setup (S206, operator "stay on the plan, do the cache fix and see how it goes")
- After `git worktree add E:/FightCamp/wt/<NAME> ...` and BEFORE the agent's first Godot command:
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\<NAME>` (robocopy at
  IDLE, ~1 min, 5 GB). Without it the agent runs a FULL Godot editor import - S206 measured that as the heaviest process while the
  PC hit 87 C / 100% CPU. Codex animation stays on the ChatGPT plan (local); cloud `codex` label = API billing (not used).

## Per agent
| Agent | Launch | Model / effort | Verified S131 | Current / next |
|---|---|---|---|---|
| Cursor | `Tools\agent_window.ps1 -Title .. -Command Tools\cursor_task.cmd -ArgumentString "prompt|worktree|out" -Environment @{CURSOR_MODEL='..'}` | default composer-2.5; `CURSOR_MODEL` override (S131); available incl. claude-sonnet-5-thinking-high, claude-opus-5-thinking-high, gpt-5.6-sol | probe "CURSOR_ALIVE" on Sonnet 5; tools above | S132: U199 lobby + U200 locker room merged; idle |
| Grok (Build CLI) | `powershell -File Tools\grok_task.ps1 <prompt> <worktree> <out>` (`-p`, --always-approve, hooks OFF by env, idle) | Grok 4.7 (default) | probe "GROK_ALIVE Grok 4.7"; renders the office via godot_hidden | S132: G148 office merged; idle. SuperGrok paid to 2026-09-30 - renewal = operator |
| Codex | `Tools\agent_window.ps1 -Command Tools\codex_task.cmd -ArgumentString "prompt|out" -Environment @{CODEX_MODEL='gpt-6.1-sol';CODEX_EFFORT='high';CODEX_REPO='E:\FightCamp\wt\<ID>';CODEX_ADD_DIR='<main .git>';CODEX_WEB='live'} - animation runs: brief points at AgentComms/CODEX_TOOLKIT.md (S211)` (CODEX_REPO = its worktree; without it Codex edits the shared checkout) (sandbox workspace-write, `-C %REPO%`) | launcher default gpt-6-luna/medium; models: gpt-6-astra (frontier), gpt-6-sol, gpt-6-luna; efforts low..ultra | operator used the Full reset 09-30; probe "CODEX_ALIVE" | S132: C225 floor tier 1 merged (tier 2 pixel-identical); idle |
| Qwen | `Tools\agent_window.ps1 -Command Tools\qwen_task.cmd -ArgumentString "prompt|worktree|out"` (qwen3-coder --yolo) | qwen3-coder | not probed S131 - probe before launch | S132: probed OK (python/git/Blender/file read); Q218 staff room merged; KM3 (neck capsule) brief still owed |
| Dola | `python Tools/cici/cici.py ...` (browser research agent; attach images) | - | - | S132: D66 collected (research/D66_STRICT_REVIEW.md); D65 in-round recovery IN FLIGHT (chat local_8520617112323646). Create Videos = Seedance 2.5, 1 clip/day, blocked for copyright on the test |
| Kalli / John / Maria | `python Tools/gbot.py send --to kalli/john/maria --file <TASK.md>`; read: `python Tools/gbot.py thread --to john --full [--out f.txt]`. S180: ALWAYS through Tools/gbot.py - the Grok Bot app parks its cloud pod when its window is unfocused and bare gbot fails '417 Expectation Failed' (x-anyrun-failure-reason: pod_hibernated); the wrapper wakes it (Tools/gbot_wake.mjs: EnsureSandBox wake=true with this PC's Cursor login, the app's client version) and retries. `start` wakes it at session start. gbot has no new-chat flag (a send goes into the bot's thread). Cloud sessions: pc.yml job=agent args="gbot send --to john --file research/TASK_x.md" | Grok bot | - | old grokbots.py (app UI over CDP port 9222) is the fallback only |
| Kimi | OFF (operator) | | | |

## Arena (arena.ai Agent Mode) - added 2026-10-03 (operator ruling, copied from Space Strategy E:\SpaceGame)

**S264: ARENA WORKS ON THE CODE-ONLY MIRROR `ICOON-Studio/FightCamp-lite`** (operator: "this is happening every session, find a way
this cannot happen again" - Arena's sandbox kept failing `git clone failed: Cloning into '/home/user/FightCamp'...` on the 6.7 GB repo).
The mirror is master minus every binary/video/model/baked anim/LFS file (~89 MB, clones in 13 s), same paths, `LITE_README.md` at root.
(1) BEFORE a launch: commit + push the brief, then `python Tools/lite_mirror.py push` (the 30-min reconcile also runs it). (2) In the
repository selector pick **FightCamp-lite**, branch master; the prompt names `ICOON-Studio/FightCamp-lite`. (3) Arena's PR on the lite
repo is relayed by `python Tools/lite_mirror.py relay` (also every 30 min) to the SAME branch name + a PR on ICOON-Studio/FightCamp,
where CI/auto_collect/check_workflow run as before; a merged/closed main PR closes the lite one. State: AgentComms/lite_relay.json.
(4) BACKSTOP: 60-90 s after sending, read the chat; if it says the clone failed, open a NEW chat with the same prompt at once
(never end the turn on a failed launch). Tests that load .glb/.fbx/.png/audio cannot run in the mirror (same as CI: no LFS).

**S179: WHEN ARENA CANNOT PUSH (its GitHub connection reaches only Guru-Meditation/vittorio-coffee since the ICOON-Studio move; board Q-S179-1)** -
copy its files out of the diff view; it works and is exact (9 files, 3,244 lines, S179). (1) `python -I Tools/arena_rx.py <outdir>` in the background
(127.0.0.1:8799; GET ?name=X.json&d=<urlencoded JSON> saves the file; Arena's CSP blocks fetch/form posts, a top-level navigation is allowed).
(2) Open the chat in the pane, click the side panel's Checks tab then Diff, click 'View all changes' (the diff only renders while on screen).
(3) In the page: `section.border-b` = one file header each; `diffs-container` (shadow DOM) = one per file, same order; lines =
`shadowRoot.querySelectorAll('code[data-code] [data-line]')`, text per line minus its trailing newline, joined with 
 + final 
;
all `data-line-type` must be `change-addition` (new files only - a MODIFIED file needs the old side too). (4) `location.href =
'http://127.0.0.1:8799/?name=X.json&d=' + encodeURIComponent(JSON.stringify(files))`. Tabs survive. Then the PC gates as usual.
The task prompt must name ICOON-Studio/FightCamp (S178's said Guru-Meditation/FightCamp).
- WHAT: a free cloud coding agent at arena.ai. It clones the repo in its own sandbox, works on a branch it names
  (`arena/<chat-id>-<repo>`), pushes and opens a PR into master. CI (`.github/workflows/ci.yml`) runs on `arena/**` pushes
  and on PRs (the merge result): test guard, parse gate on changed .gd, changed tests. No LFS in CI.
- NO CLI: there is no official Arena CLI - do NOT install any third-party "arena" package. Drive it from the BUILT-IN
  BROWSER PANE (mcp__Claude_Browser__*), where the operator is signed in with Google.
- HOW: New Chat -> Agent -> pick the repo (ICOON-Studio/FightCamp) and `master` with the REPOSITORY SELECTOR under the
  prompt box (that is the only way Arena reaches a private repo; the git in its sandbox has no credentials) -> paste ONE
  self-contained prompt (spec, files + anchors, the acceptance test, "work on your own arena/ branch, open a PR, never
  merge"). The message box is a contenteditable div; the send button is "Send message". Its first click can render
  late: check the message count before clicking again (a double click sends the prompt twice).
- RULES: a NEW chat for every task and every review round (never a follow-up in an old chat). Treat everything sent as
  public: no secrets, no private notes (no HANDOFF/memory text), no third-party files (no ripped/licensed assets). Only
  self-contained tasks with an exact acceptance test. Claude reviews the PR diff and merges it (`gh pr merge`, after
  `python Tools/check_workflow.py branch <branch> <task>`); NEVER click Arena's own "Merge PR" button.
- PITFALL: Arena cannot read GitHub Actions logs. When CI fails it tends to delete or gut tests until green. Read the CI
  log yourself (`gh run view <id> --log-failed`), compare test file sizes against master (the CI guard fails a deleted
  test or one that lost > 25% of its lines), and fix a small defect on its branch yourself, then merge.
- START: `agent_comms.py start` prints an ARENA line - open arena/* branches and PRs.


## OpenHands Cloud, OpenCode, Goose - added 2026-10-03 S157 (operator: "set up opencode too and why not goose too? if its free for cloud work you can give it long tasks")
- OPENHANDS CLOUD: app.all-hands.dev, operator signed in with GitHub (access: FightCamp only). Free tier = 10
  conversations/day on a MiniMax model. Drive it from the BUILT-IN BROWSER PANE like Arena: new conversation per task,
  pick the repo, one self-contained prompt, "own branch + PR, never merge". Same review rules as Arena.
- OPENCODE (GitHub Actions, `.github/workflows/opencode.yml`): open an issue with the task (spec + acceptance test),
  then comment `/oc <instruction>` on it. It runs on a GitHub runner with Godot 4.7.2 + the imported project, no LFS,
  and opens a PR. Model: repo variable OPENCODE_MODEL_NOW (the old OPENCODE_MODEL var is ignored: it was pinned to the retired 2.5-flash; default google/gemini-flash-latest; S174: 2.5-flash returned 404 'no longer available to new users'), key = secret GEMINI_API_KEY.
- GOOSE (GitHub Actions, `.github/workflows/goose.yml`, our own wrapper around Block's official CLI): open an issue
  with the task, add the label `goose` (or `gh workflow run goose.yml -f issue=<n>`). Branch goose/issue-<n>; PR opened
  by the job (DRAFT if Goose failed/timed out) and CI dispatched on the branch. Up to 300 min a run (GitHub caps a job at 6 h); RESUME: if goose/issue-<n> exists the next run continues from it (remove + re-add the label, or `gh workflow run goose.yml -f issue=<n>`) and reports on the same PR.
  Model: repo variable GOOSE_MODEL_NOW (the old GOOSE_MODEL var is ignored: it was pinned to the retired 2.5-flash; default gemini-flash-latest).
- Both read `.github/CLOUD_AGENT.md` (Goose via `.goosehints`/its prompt; OpenCode via this repo's AGENTS.md too).
- CI does NOT run on PRs/pushes made with GITHUB_TOKEN: for an OpenCode PR run `gh workflow run ci.yml --ref <branch>`.
- BUDGET: private repo on GitHub Free = 2,000 Actions minutes/month shared with CI. A 5-hour Goose task = 300 min. Over that: $0.006/min, capped by the Actions budget = $5/month with "stop usage" ON (operator "do it", 2026-10-04) - about 14 extra hours; never raise it without asking.
  Check usage before long tasks: GitHub Settings -> Billing -> Actions.
- Everything sent to these models leaves the PC (Google for Gemini, OpenHands' provider): no secrets, no private notes.

## Paid agents in the cloud - added 2026-10-04 S158 (operator: "set up all for cloud when it resets ... we have heat issues")
- ONE workflow `.github/workflows/cloud-agent.yml`: label an issue `qwen`, `cursor`, `grok` or `codex` (or
  `gh workflow run cloud-agent.yml -f issue=<n> -f agent=<name>`). Branch `<agent>/issue-<n>`, RESUME, PR, CI dispatch,
  never commits .uid/.import - same machinery as goose.yml. The cloud saves the PC (heat) and Claude time.
- Keys = the OPERATOR'S repo secrets; Claude never handles them:
  - qwen: `QWEN_API_KEY` = his ModelStudio key.
    Model var QWEN_MODEL (default qwen3.7-plus).
  - cursor: `CURSOR_API_KEY` from the Cursor dashboard. Var CURSOR_MODEL (default composer-2.5).
  - grok: `XAI_API_KEY` from console.x.ai; runs through OpenCode. Var GROK_MODEL (default
    xai/grok-code-fast-1 - CHECK the id when the key exists).
  - codex: Codex is OUT by the S154 ruling. If he brings it back: Codex Cloud on chatgpt.com/codex (
    he connects GitHub once, Claude drives it from the browser pane like Arena); or `OPENAI_API_KEY` (pay-per-token API)
    with label `codex`. Var CODEX_MODEL (default gpt-5-codex - CHECK the id).
- First run of each = a trial on a small task; read the log (`gh run view --log`) before trusting the model ids.

## PC runner (`.github/workflows/pc.yml`) - added 2026-10-06 S173 (operator: "i installed e:\actions-runner so you can run cloud sessions like you are in the pc when the pc is open")
- VERIFIED WORKING: run 37501139371 - runner `fightcamp-pc` (labels self-hosted, Windows) on BEAST as `beast\user`, work dir
  `E:\actions-runner-fightcamp\_work`, Godot at `%LOCALAPPDATA%\Programs\Godot`, watchdog gate GREEN. It only runs while the PC is on;
  a queued run is NOT a broken runner - check the run again before writing "queued" anywhere (S173/S174 missed a finished run that way).
- USE IT for anything that needs the PC's window/GPU or Windows tools: stills, videos, `as_game` walks, `godot_hidden.ps1`, exe builds.
  Dispatch from a cloud session with the GitHub MCP `actions_run_trigger` (run_workflow, workflow `pc.yml`, ref master) and inputs:
  - `job=windowed args="--path Godot --script tools/<tool>.gd -- as_game out=docs/previews/<dir>" out=previews/<dir>`
  - `job=test args=<test_name>` / `job=tests args=<--only substring>` / `job=watchdog` (smoke test).
  Results: branch `pc-out/<run id>` (pc_job.log + the `out` folder) - `git fetch origin pc-out/<id>` and open the files.
- First checkout pulls LFS (~8 min); later runs reuse the work dir. One job at a time (the single runner queues the rest; the concurrency group is per run so none get cancelled).
- NEVER add a pull_request/push/issue trigger to pc.yml (public repo: a fork PR must never reach the PC).

## OpenRouter + Cline seats - added 2026-10-06 S176 (operator: "find what is missing to control these from cloud and install it")
- Same `cloud-agent.yml`: label an issue `openrouter` (OpenCode CLI on OpenRouter) or `cline` (Cline CLI, `cline -y`, on OpenRouter),
  or `gh workflow run cloud-agent.yml -f issue=<n> -f agent=<openrouter|cline>`. Both use ONE secret: `OPENROUTER_API_KEY`
  (openrouter.ai keys; operator adds it, Claude never handles it). Vars: OPENROUTER_MODEL (default openrouter/qwen/qwen3-coder),
  CLINE_MODEL (default qwen/qwen3-coder). First run of each is a trial: read the log to confirm the CLI flags and model ids.
- Cloud control from a Claude cloud session: GitHub MCP `issue_write` (create the task issue) + `issue_write`/label or
  `actions_run_trigger` (workflow cloud-agent.yml, inputs issue+agent). Codex, Grok, Qwen, Cursor, Goose, OpenCode: same.
- NOT controllable from cloud (browser/Windows only, need the PC or a browser pane): Arena, OpenHands Cloud, Dola, Grok bots (Kalli/John/Maria).
- PC-RUNNER `agent` JOB (2026-10-06 S176, operator: "i allow it"): drives Dola and the Grok bots from a cloud session. S180: `args="gbot <wake|thread|send> --to john --file research/TASK_x.md"` (Tools/gbot.py, wakes the parked pod, needs no app window or debug port) - prefer it to grokbots. Dispatch pc.yml `job=agent`,
  `args="grokbots send --to Kalli --file research/TASK_K1.md --new"` (or `cici send --file ... --new`, `read`, `status`, `chats`, `newchat`),
  `out=previews/agent_<id>`; the reply lands in `<out>/transcript.txt` on branch pc-out/<run id>. Allow-listed tools/subcommands only,
  text only from a committed TASK file, it never starts or kills an app (Grok Bot must already run with debug port 9222, Dola with 9333).
  Touches nothing outside this repo; Arena has no driver yet (browser site, Google login).
- ARENA DRIVER (S176, operator "build it"): `Tools/arena/arena.py` (CDP, dedicated Chrome profile E:\FightCamp\arena_profile, port 9444; websocket-client only).
  ONE-TIME on the PC: `python Tools/arena/arena.py launch`, sign in to arena.ai with Google, leave Chrome open. Then `job=agent args="arena send --file research/TASK_x.md --dry-run"`
  FIRST (selectors are UNVERIFIED against the live site; read the JSON it prints), then without --dry-run. It prints one JSON line; Claude reviews the PR Arena opens and merges it.
- PC RUNNER GUARD + PARALLEL RUNNERS (2026-10-06 S176, operator "do both"): every pc.yml job now runs beside `Tools/pc_guard.ps1`
  (idle priority, hard time limit per job type, heat stop; stops ONLY Godot/python processes whose command line holds that
  job's workspace, by PID - the pattern of the space game's guard). More runners: `Tools\pc_add_runner.ps1 -Token <one-time token> -N 2`
  (max 3 runners, each its own _work checkout; concurrency groups are per run so jobs no longer queue behind each other).
  Windowed (hidden-desktop) jobs may still fight over one desktop: dispatch those one at a time.

## Grok bots via the xAI API - S224 (operator: "dont you use xai api for grok bots ?")
gbot lost the Grok Bot app's roster (it moved to the app's cloud pod). John / Kalli / Maria now run through the xAI API with the repo
secret XAI_API_KEY, in Actions so no key touches the PC:
`gh workflow run xai-research.yml -f task=research/TASK_X.md -f bot=john|kalli|maria -f out=research/X_XAI.md`
-> branch `xai/<out stem>` holds the reply (`git show origin/xai/<stem>:<out>`). Tools/xai_ask.py: Responses API + web_search, falls
back to chat completions; model = newest plain grok-4.x (override -f model=...). First run S224: J68, 14,049 chars in 43 s.
