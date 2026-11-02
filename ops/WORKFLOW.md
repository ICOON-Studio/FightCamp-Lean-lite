# FightCamp - workflow gates (carried from the old repo E:\FightCamp\Game in S366; ONE repo now)

This page was the old repo's CLAUDE.md. Since S366 the workflow (ops board, agent tools, roadmap, research) lives in
`E:\FightCamp\Lean\ops` and Lean's CLAUDE.md imports this page. Where they disagree, LEAN'S CLAUDE.md WINS. Paths like
`Godot/scripts`, `Godot/tests`, `run_tests.py`, C223 and GameState.gd describe the OLD game (archived on GitHub
ICOON-Studio/FightCamp); the Lean game is the repo root (`scripts/`, `tests/`, `sh tools/run_tests.sh`).

Godot 4.7.2 GDScript game in `Godot/`; this folder is the repo root. Operator = the user (CEO, playtester, 40 years of games).
Rewritten S127 (2026-09-29) on the operator's brief: "SHRINK THE RULES, KEEP THE GATES." No gate script is weakened.
Where this page and older text disagree, this page wins. Order (S218, operator PDFs): gates first, history last. Incident stories and retired rules live in RULES_HISTORY.md.


## 0. Gates at a glance (S218 order: gates first, then how to work, history last; section numbers are stable IDs)
- PC: watchdog `ops\Tools\pc_watchdog.ps1 -Once` before every heavy job; RED (84 C held 2 min, 88 C at once, 80% CPU, commit < 4 GB) = do not start (s4). rule_guard + heat_governor enforce it.
- SCREENS: nothing opens on the operator's monitors - file tools only, windowed Godot only via `ops\Tools\godot_hidden.ps1` (s4).
- VISUAL: `.claude/skills/visual-gate/SKILL.md` - red on the shipped clip first, game-camera stills via still_framing, gap/noses/wrists/feet per still, the operator closes it (s2).
- TESTS: parse gate first; `run_tests.py` only with `--jobs 2|3|4` (4 = idle GREEN PC); never the full suite in a session; exit code alone is not a pass (s6).
- GIT: explicit `git add -- <files>`; never bare stash/reset --hard/checkout ./clean/add -A; agent branches by DIFF (s7).
- AGENTS: launch through `ops\Tools\agent_window.ps1` (Idle, hidden), seeded worktree, live_runs.json at launch and landing; `ops/Tools/board_reconcile.py` marks dead runs every 30 min (s8).
- OPERATOR: ask only money/taste/scope; every question on the board with `--attach`; never end a turn mid-stage (s2, s3).

## 4. Safety (PC, processes, disk)
- PC LIMITS (operator 2026-10-02): CPU temperature never above 84 C (raised from 80 the same day: "you can go upt to 84C"); CPU load low enough that he can use the PC. The
  watchdog goes RED at 84 C HELD 2 MIN or 88 C at once (operator S249: "RED at 84 C only when held 2 minutes, instant stop at 88 C", to let more work run), 80% CPU or commit < 4 GB (amber 74 C / 60%); live meters on the ops board top strip (/api/pc).
- Before ANY heavy job (Godot test/suite, render, agent launch, big download, model install):
  `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` - exit 1 (RED) means do not start;
  tell the operator what is RED and what to close. Never scan a whole drive.
- Drives: C: NVMe (Windows - keep free, nothing new), E: SATA SSD (hot data + agent worktrees under `E:\FightCamp\wt`,
  operator S138; S249 "auto-retire worktrees and gate clones from now on": the 30-min reconcile runs ops/Tools/worktree_retire.py - clean,
  pushed, 24 h idle worktrees go (untracked files to E:\FightCamp\wt_salvage), dirty/unpushed ones are HELD and printed by `start`,
  ZIVA never; branch-gate clones older than 6 h go; log ops/AgentComms/retire.log), D: HDD FAILING (WD15EARS, 758 read errors, 11 controller resets in 2 weeks = the PC freezes): OFFLINE since S190
  (operator: "remove the drive so windows cannot see it" - Set-Disk 1 -IsOffline; back with Set-Disk 1 -IsOffline $false) until replaced; backup of its irreplaceable folders in `E:\FightCamp_backup_D`. Nothing new on D:.
- Shell agents (Codex/Cursor/Qwen/Grok CLI): as many as the PC takes (operator 2026-09-30: "they can run if the pc can
  take it") - the watchdog before EACH launch is the ONLY gate: GREEN or AMBER launches, RED does not (operator
  2026-10-02: "launch with amber"; the nightly suite is not a blocker), all at IDLE priority
  (launchers do it - never remove that), consoles HIDDEN; `ops/Tools/agent_window.ps1` itself refuses a launch on RED (exit 3, S198); no daytime test run of yours beside them when the watchdog is
  not GREEN. Browser agents cost the PC nothing.
- NOTHING OPENS ON THE OPERATOR'S SCREENS (operator 2026-10-02: "stop the windows popping up on my other monitor",
  "wtf are all these photos popping up"): agents and Claude view images/videos with their FILE tool only - never
  start / Invoke-Item / os.startfile / explorer / a browser pane; every brief says so. `Tools
o_popups.ps1` (started by
  agent_window.ps1, hidden) closes any Photos/Paint window opened after it began - PAUSED while `ops/AgentComms/allow_viewers.flag` exists
  (operator S187: it closed HIS Photos; "allow" it - never delete that flag). Previews reach him as SendUserFile attach.
- OPS BOARD / WATCHDOG RESTART (S197 cmd-window flashes): only `Start-ScheduledTask -TaskName "FightCamp Ops Board"` / `"FightCamp PC Watchdog"`
  after stopping the PID; never pythonw/Start-Process a git/python spawner; diff the process list 20 s after.
  Every scheduled task starts `conhost.exe --headless powershell.exe ...` (S336 "terminals popping up": a bare powershell.exe
  task is handed to Windows Terminal, which ignores -WindowStyle Hidden).
- BRAVE FOR ANY LOGGED-IN SITE (operator S215: "use the fucking brave browser"): Mixamo, Fab, itch, Ludo and every site that needs his sign-in go through the Claude-in-Chrome tools (`tabs_context_mcp`, `browser_batch`; they drive his Brave, already signed in). The built-in pane is ~415x241 and resets its size: use it only for localhost previews, never for downloads.
- DOWNLOADS ARE DONE, NOT DESCRIBED (operator S215: "stop being lazy", "download everything"): once a batch is approved (his yes on the board) do the WHOLE batch in one run - search, click, download, move the files into the project, list them - without stopping to ask him to resize a pane or click for you. Mixamo flow: search, click the clip, DOWNLOAD, DOWNLOAD (FBX Binary, With Skin, 30 fps); the file lands in C:\Users\user\Downloads. Check what is already on disk BEFORE downloading (operator S215: "check if we have those downloads already first"). Rejected by Ludo or licence-blocked (ViCoS, QuickMagic, Harmony4D) stays out.
- BROWSER TABS (S197, operator: "first check chrome then take control"): `tabs_context` first, REUSE the tab on that site, close what you opened.
- Windowed Godot ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\godot_hidden.ps1 <godot args>`
  (Dummy audio - the operator wants no sounds, no popups). Since S161 it runs the job on a hidden Win32 desktop
  (`ops\Tools\godot_desktop.ps1`; operator 2026-10-04: "run the test in a virtual windows environment so i do not see the
  popups") - nothing reaches a monitor, the GPU still renders. Never kill Godot by image name - by PID/command line only.
- One blocking wait per thing you wait for; kill a waiter before deleting what it watches; absolute paths in redirects.
- ENFORCED, NOT REMEMBERED (S217, after two 84-88 C spikes): `ops/Tools/rule_guard.py` (PreToolUse hook, Bash+PowerShell) blocks
  _console.exe, run_tests without --jobs 2|3|4, bare stash/reset --hard/checkout ./clean/add -A, and any Godot/test/agent start on
  RED. `ops/Tools/heat_governor.ps1` (hidden loop) SUSPENDS the newest Godot process on RED, resumes on GREEN; log
  ops/AgentComms/heat_governor.log; manual pause: `ops/Tools/proc_pause.ps1 -Id <pid> -Action suspend|resume`. Pure PRs collect by
  diff + parse + test - `check_workflow branch` runs a full editor import (88 C).

## 6. Tests
- Parse gate before any test: `python Godot/tools/check_scripts.py <touched .gd>` (a parse error hangs a headless test).
- Tiers: research only - no gate; a new test file only - parse + that test; a script edited - parse, the focused test,
  then `python Godot/tools/run_tests.py --only <exact test names>` for the systems it touches. Never the full suite in a session.
  ONLY WHAT WE USE (operator S249: "do not test mechanics we do not use maybe until we actually implement them"): a switched-off
  mechanic's test cannot see the change - run the tests that play the game path the diff touches. rule_guard blocks an --only
  matching > 40 tests or none (S249: `--only fight_` = 185 tests, 70+ min).
- `run_tests.py` is NEVER run serial (it defaults to `--jobs 1`): `--jobs 4` on an idle GREEN PC, `--jobs 2` while agents
  run (operator 2026-10-02 "use jobs 2 or 3"; S336 after his cooling fix, "the heat fixed": 4, never 5). Wait on the runner's own exit, never on a string in its output
  (S132: a waiter keyed on "SUITE total=" sat 2 h - the output never had it - and no test ran).
- One test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd` (NEVER `_console.exe`: Win11 hands it
  to Windows Terminal = a black window on the operator's monitor, S166; `ops/Tools/popup_probe.ps1 -Command` proves a launcher silent)
  (exe in `%LOCALAPPDATA%\Programs\Godot\`). The exit code alone is NOT a pass: the runner also fails a test on a SCRIPT
  ERROR, its own FAIL line, or no output. rc=124 = hang (suspect a parse error). RID/resource leak lines are not failures.
- Headless runs keep the game switches OFF (tests are the control arm); `-- as_game` plays the game the player gets.
- C223 gates: `python ops/Tools/c223_parallel.py production|sequence -- <gate args> report=<x>.json` (one rig per process,
  ~3.5x faster, same report). Stills stay one windowed run. The exported .exe walks via `FIGHTCAMP_GODOT_EXE` (S127_DIGEST s2).

## 5. Fixtures and measurements (operator rules, no exceptions)
- NEVER TEST IDENTICAL FIGHTERS: two fighters differ in stats (check the key is `stats`), techniques, frame, plan. A
  measurement names its population (and its catalogue) in its own output. Only the determinism tripwire reuses a seed.
- A FIGHTER IS LEGAL FOR HIS RULESET: differentiate by style and attributes INSIDE the ruleset, never by removing
  techniques it permits. Females never fight males; booking matches weight class.
- Ground realism tests in real studies first; bound values, never gate an exact count or an extremum; give every fix a
  control arm that cannot share the bug; a green instrument must be able to read worse.

## 7. Commits and git
- REPO = `ICOON-Studio/FightCamp` (moved from Guru-Meditation S178, operator: "do it move it to the icoon studio org"; own 2,000
  Actions minutes; secrets, variables, runners, PRs moved with it; old URLs redirect). Arena/OpenHands pick ICOON-Studio/FightCamp.
- Stage explicit paths (`git add -- <files>`); check `git status -s` first (another agent's work may be staged). Never
  `audio_exports/`. Never a bare `git stash` / `reset --hard` / `checkout .` / `clean` in this shared checkout.
- Commit messages end with the Co-Authored-By line the harness gives. Push `master` on every completed task.
- FAST LANE (S240, operator: "do the rest that you suggested" after the Scion video - review intent, not lines): an agent PR that only
  ADDS a pure module + its test under scripts/rules, tests, research goes through `python ops/Tools/auto_collect.py <pr>` (dry run: ELIGIBLE
  or why not + the PR body; `--merge` copies the new files onto master, commits, closes the PR) once its CI is green. Claude reads the
  body against the brief (intent); no hand diff/parse/test for those. Everything else takes the normal route below.
  UNATTENDED (S249): the 30-min reconcile runs `ops/Tools/collect_ready.py --apply` - an ELIGIBLE PR whose added files EQUAL its brief's
  owned files (TASK_<id>.md) merges by itself through the same `--merge` path ONCE ARMED (operator S249 "Push, merge off": until
  `code_gate.py arm --operator-said` it only records WOULD MERGE; log ops/AgentComms/auto_collect.log); every other open PR
  is a packet `start` prints as READY TO COLLECT. Runs whose PR closed / branch is on master archive themselves.
- Merge an agent branch only after `python ops/Tools/check_workflow.py branch <branch> <task>` passes, and apply the DIFF -
  never take whole files from a branch. Other sessions may be alive: check `git log` before assuming the tree is yours.

## 1. Objective and the current goal
- OBJECTIVE (operator S115, verbatim in `roadmap.json` `objective`): finish the agreed release - the WHOLE game (Steam EA
  $19.99, v1 stand-up, MMA first update, 1.0 $24.99). Resume from the recorded next action; judge progress by verified
  playable milestones; never create a new roadmap or reopen a settled decision without new evidence.
- GOAL NOW (operator working brief 2026-09-29): "the playable boxing demo .exe [...] Judge every hour by one
  question: does this put a watchable boxer career in my hands sooner?" NO DATE: operator 2026-10-03 (S151), "chill
  with the demo remove the deadline" - the 2026-10-06 date is gone; quality over the calendar.
- DEMO SCOPE (D27): the demo ships with the boxer's fight palette restricted to C223-CERTIFIED moves
  (`assets/data/certified_moves.json`, switch `certified_palette`); the rest join the day they pass.
- Settled decisions: `ops/research/DECISION_LEDGER.md` (SETTLED table, each with its reopen evidence) and
  `ops/AgentComms/route_decisions.json` (ROUTE STATUS - quote it, never describe a route from memory).

## 2. How to work
- Carry on from `roadmap.json` `now.next_action` without asking. Ask the operator ONLY about money, taste (he watches a
  video or plays the .exe) or scope (changing the engine, visual direction, agreed scope, invalidating finished work).
- CLAUDE IS THE DEVELOPER (operator S194, after being asked a code-structure question: "i have no clue on game development [...]
  you are the developer"; "DO WHATEVER IS NEEDED FOR THE PROPER AND FASTER DEVELOPMENT OF THE GAME"): code structure, refactors,
  module splits, tooling, test strategy and agent workflow are DECIDED and done, never asked; say what was decided and why in the
  stage report. Never hand him a technical choice dressed as a question. Spot structural debt yourself (a file every task must
  edit, a script past ~1,500 lines) and queue the fix before it costs a session.
- PACE: no mid-stage reports. One short report at the end of a stage: what now works, the evidence, what's next.
- NEVER IDLE (operator 2026-09-30: "make sure this idleness cannot happen again"): a turn does not end mid-stage;
  every in-rotation shell agent holds a running task (brief + launch in the first hour, re-task the moment one lands).
  Enforced by the Stop hook `ops/Tools/idle_guard.py`; `python ops/Tools/idle_guard.py ok "<reason>"` only before asking the
  operator money/taste/scope. An agent on the ops board is usable; its account is the operator's business (S197).
- NO REPORT BEFORE THE NEXT ITEM (operator 2026-10-06, S170: "I kept ending my turns with a report instead of starting the next item"):
  finishing an item is never a reason to end the turn. A turn ends ONLY when `now.next_action` and the queue are empty, or
  the single next item needs the operator's money/taste/scope. Otherwise the very next tool call after a commit is the first
  step of the next queued item (roadmap `now.next_action` order). The "queue + handover block" message is the LAST message of
  a stage that is genuinely finished (CLAUDE.md s3 HANDOVER) - never a pause after one item, and context budget (s3: ~330k)
  is the only other reason to stop. Before writing any closing message, ask: "is there a queued item I could start now?" - if
  yes, start it.
- A defect you notice, you fix NOW, even off-milestone. The backlog is for features and cleanup, never for a seen defect.
- Only work that advances the ACTIVE milestone; everything else waits in `queue.backlog`.
- FOCUS CAP (operator S220: "act on this tighten the scope"): at most 14 FOCUS rows in the queue (`queue.focus_rule`,
  ops/research/SCOPE_S220.md), each on the demo path or a defect he has seen; a new row enters only when one leaves; the rest
  is PARKED (`start` hides it, `--full` shows it). A brief, agent launch or Ludo round for a PARKED row needs his call first.
- PRIMARY SOURCE BEFORE ACTION: before you write a task, stop a route, merge or discard a branch, or tell the operator what
  exists, open the primary source (digest body, delivered files, branch diff, live tool state) and say which you read.
  A summary is a pointer, never evidence. Open the output (stills, renders, logs) before trusting a gate.
- A VISUAL FIX IS DONE ONLY ON THE GAME'S CAMERA (S161: 8 glove sessions closed on checks that could not see the
  defect - rest pose, idle close-ups - while the operator saw it at once): a body/glove/animation task closes only on a
  still from the live fight's own camera (`record_room ... as_game`) in the poses the game shows (guard AND mid-move),
  opened by you, plus the operator's OK. A test closes nothing visual alone; it must first go red on the shipped tree. NO FEET-ONLY STILLS (operator S191: "fix the fucking camera once and for all i do not want to see any more pictures with feet only"): a fight still is saved ONLY through `Godot/tools/still_framing.gd` `save_if_framed` (both men head to feet in frame, else STILL_FRAMING FAIL); never pass a mat shot (`establishing`/`tight`/`low_mat`) for a standing fight - windowed boxing runs force the game's `broadcast` + follow anyway; every still brief says so.
  NO GYM STILL WITH THE DAY PLAN OR A DRAWER OPEN (operator S275, asked 4 times): a career-screen still is saved ONLY through
  `Godot/tools/clean_view.gd` `save_if_clean` after `CleanView.clear` (STILL_CLEAN FAIL on a visible Day Plan / calendar drawer / pop-up;
  `ui=1` only when the still is ABOUT that UI).
- NO DEFAULTS WITHOUT DIRECTION (operator S213: "do not fall to defaults/averages when you have no conclusive direction, use your
  skills or communicate with ludo and other agents"): an open design/number/look question goes to research, real-world numbers, an agent or a skill first (Ludo only for a still to judge, S299).
- RESEARCH IS MEMORY: `python ops/Tools/prior_research.py <terms>` before any brief or new study; every brief carries
  `## Prior research`, `## What would a human do?` and `## Prefab check` (`start` flags briefs missing them).
- Be concise. Spell decisions out in plain words (no option letters). Quote operator rulings verbatim.

## 3. Session start and end
- CLAUDE USAGE BUDGET (operator 2026-10-02, Pro plan, "switch to the cheaper mode"): default model Sonnet at medium
  effort (~/.claude/settings.json); the operator picks Opus in the model menu only for a hard problem. Run `start` ONCE.
  ONE stage per session: hand over when the stage ships or the context passes ~330k tokens (get_usage; operator S201: "move handover to 330k" - a session already starts at ~90k), whichever
  comes first. Connectors Higgsfield, Higgsfield Blender and Claude Docs are OFF by default; enable one only for a task
  that needs it. Read big files in windows, never whole.
- ROUTED START (operator S215: desktop sessions bypass the Jev router; he wants no approval clicks): open a terminal tab running `jev` (ops/Tools/jev_claude.ps1) and continue the work there with `run_in_terminal`; the desktop session only reads/answers. Never type into a tab that holds a Claude session.
- START: `git pull && python ops/Tools/agent_comms.py start` from the repo root - the whole orientation. State the queue to the
  operator in the first message (operator rule), then work `now`. `start` shows runs in flight - they are YOURS: do not
  relaunch, collect them when they land. Never ask what to work on; if `now` is unclear, take the likely reading and say so.
- PENDING ISSUES, EVERY SESSION START (operator 2026-10-09, S181: "always ask for pending issues at start of new session and also add option to answer pending questions on theopsboard"): the first message asks EVERY open question `start` lists (QUESTIONS STILL OPEN) and every roadmap `awaiting_operator` item, beside the queue - never only the queue. A question for him goes on the board (`python ops/Tools/agent_comms.py ask "<text>" --options "a|b"`) so he can answer it at 8787/ (main page, "Questions for you"); `start` prints his board answers once - QUOTE each in the first message and act on it (operator S182: "check answers on opsboard , always check that at session start"). An approval question carries what he approves (operator S191: "when i need to approve something i want to be able to see it on the opsboard"): `ask ... --attach <doc.md|still.png>` - the board shows it under the question; `ask` refuses an approval without it.
- AGENT SWEEP, EVERY SESSION (operator 2026-10-05, S164: "a regular check which agents are available and use them, especially Arena which is free"): in the first 15 minutes, before own
  build work, read `start`'s AGENTS block + the ops board and launch every free seat on a self-contained queue item (Arena first). `ship` is refused unless live_runs.json shows what
  was delegated this session or a one-line reason why nothing fit. Do not do alone what an idle seat could do (S164 wrote all of STORY3 alone while Arena sat idle).
- Read `ops/AgentComms/nightly/latest.txt` and diff its failing set against the last check recorded in roadmap `NIGHTLY1`; report it
  ONLY when a NEW test went red or a fix landed (operator S159: "why you keep repeating this every session"), and write each
  check into `NIGHTLY1` so it is never redone. The full suite runs ONLY nightly, on GitHub runners (S259: `nightly-suite.yml` 03:00 UTC, 16 shards; `start` fetches latest.txt via `ops/Tools/nightly_fetch.py`; the PC task "FightCamp Nightly Suite" is DISABLED).
- A stage ships whole: digest `ops/research/S<n>_DIGEST.md` committed, roadmap `now` rewritten as a DECISION (never a
  menu), `queue`, the board `plan` (roadmap.json, the ops board main page) and `route_decisions.json` current, memory updated, then `python ops/Tools/agent_comms.py ship`. More than one
  stage per session is allowed when safe: `start` again mints a fresh id. `check_scripts.py`/`run_tests.py` refuse after
  `ship` for the same id; `FIGHTCAMP_STAGE_GATE=off` only for work that is part of the shipped stage, said out loud.
- OPS BOARD AT EVERY WRAP-UP (operator 2026-10-08, S178: "always update opsboard when wraping up a session"; "remove unecessary
  items and obsolete"): before `ship`, the board's `plan` (working_now/next/parked/done_recently/titles), `live_runs.json` (finished runs
  out to live_runs_archive.json, running ones in) and the queue (DONE/SUPERSEDED tasks prefixed so `start` shows only live work); then
  check 127.0.0.1:8787/api/roadmap serves it.
- `blocked_on_operator` holds only what the operator alone can supply. Name every run still in flight in `roster.json`'s
  note and roadmap `now`.
- HANDOVER (last message): the queue as it now stands, ONE line proposing the next session's model + effort (+ Fast on/off)
  with the reason (operator 2026-10-04: "always propose a model/effort with the prompt of new session"), then ONE `bash` block and nothing else:
  `git pull && python ops/Tools/agent_comms.py start`. Emit it only when the stage is genuinely finished (pushed, digest,
  roadmap current, no stray waiters). The GO to clear and the block come in the same message.
- If an animation changed, send it with SendUserFile at the end (`python ops/Tools/clip_status.py new-anims`).
- EVERY STILL/VIDEO SENT GOES ON THE BOARD (operator S192: "i want to be able to see those on the opsboard to make comments"):
  `python ops/Tools/review_add.py --stage S<n> --title "<what it shows>" <file>[="caption"] ...` beside SendUserFile; he comments at
  8787/review and `start` prints his unseen comments (quote each in the first message, open the file, act).

## 8. Agents
- The OPS BOARD (127.0.0.1:8787) is the roster authority; if an agent is on the board it is usable. Details per agent:
  `ops/AgentComms/roster.json` + the SETTINGS block `start` prints (models, flags).
- DELEGATE AS MUCH AS POSSIBLE, EVERY SESSION (operator S222: "delegate as much work as possible to code,arena,goose,ludo,grokbots
  etc, this should be in your rules for every session . we need a playable version soon with all mechanics on"): every queue row that
  an agent can do goes to Codex/Arena/Goose/Ludo/Grok bots/Qwen/Cursor in the first hour; Claude keeps only briefing, review, merge and
  the operator's taste calls. Target: a playable build with ALL mechanics ON (GAME_ON).
- PRODUCTION SPEED (operator S226: "how can you speed up production ?"): the PC holds only GPU work (stills, Cascadeur, windowed
  Godot) - every headless job (pure code, tests, UI scripts, research) goes to a CLOUD seat, several at once (no heat cap there).
  Batch asset generation up front (all of a feature's models in one run, then each build run only places/wires). Every brief names
  the exact function the GAME runs (trace the route, not a guess) and starts with a test red on master. Collect + relaunch in the
  same turn a run lands - never an idle turn while a seat is free.
- DELEGATE BY DEFAULT (usage budget, operator 2026-10-02): implementation, renders, censuses and probes go to the
  shell agents (Codex/Qwen/Cursor/Grok); Claude briefs, reviews, merges and judges. Claude writes
  code itself only when the spec would be as long as the code or no agent seat is free. No Claude subagents (Agent
  tool) for searches a single grep answers.
- Give each agent only demo-path work with an exact acceptance test; collect and merge the SAME session it lands.
- MACHINE-SPEED HAND-OFFS (S240, operator: "is there anything on our workflow built so that is based on human speed"): every brief asks
  for `RESULT: tests/<x>_test.gd -> <exact pass line>` lines in the PR body (auto_collect checks each against the PR's CI log); while
  Claude waits on agents it arms the Monitor tool on `python -u ops/Tools/agent_events.py 60 quiet` (timeout 30 min, RE-ARM on every expiry)
  after one `python ops/Tools/agent_events.py 60 once` at session start (lists every open-issue agent branch with no PR). It reads GitHub only:
  RUN_DONE (any conclusion) / PUSH / PR_OPEN / PR_CLOSED / GH_ERROR lines, flushed (operator S281 "the watcher missed them - this happens
  too often": agent_watch.py trusted hand-typed live_runs stamps and printed nothing; never type a 'started' time by hand) - never poll by hand.
- CHAT SEATS BETWEEN SESSIONS (S249): `python ops/Tools/seat_queue.py add --seat john|kalli|maria|dola --brief <file>` - the 30-min job sends
  it (hidden; an unreachable app is skipped and retried, Dola is never launched) and saves the answer to ops/research/<stem>.md;
  `start` prints SEAT ANSWERS. Queue research there instead of waiting on a chat in-session.
- CODE ONLY TO SEATS THAT PUSH A BRANCH (S240): Arena, Cursor, Grok Dev, Qwen, Goose, Cline. Chat-only seats (grok.com Expert, Dola, John,
  Kalli, Maria, Ask Ludo) get questions, research and design - their page text loses code indentation, so their code costs a retype.
- ROLES (operator S178, all four recommendations taken): Arena = pure modules + tests (cloud, free, first choice); Codex = big
  multi-file code + our tools; Cursor = Godot UI/gameplay scripts; Qwen = small pure modules; Goose/OpenCode = long cloud jobs; John =
  deep research; Dola = fresh eyes + research #2; Kalli = GAME DESIGN, never research ("you should not assign kali for reasearch");
  Maria = art direction. LUDO (Ludo.ai, his Chrome, project FightCamp) = ASSET MAKER + SECOND EYES, no longer the design gate (operator
  S299, D39 superseded by D49: "Yes, change the rule" to "Claude decides design and mechanics, he approves; Ludo for assets and a second
  opinion on stills"). Design/mechanics/art: Claude decides from real-world evidence, writes the why, the operator approves the verdict
  before anything is built. Ludo: generate images/3D/rigs/animation/audio, and judge an uploaded still when fresh eyes help. When asked,
  MAX OUT the ask (operator S198): longest complete answer, then "continue". PICTURES ARE UPLOADED, NEVER DESCRIBED
  (operator S220: "when i ask youto show a picture to ludo i excpect you to upload the image not write the description of the image
  in  code"): Ask Ludo's picture icon -> unhide `input[type=file]` -> `file_upload` (memory reference_ludo_ai); if it fails, tell him. `role` per agent in roster.json. Never call a seat out or idle it on a quota/credit note:
  seat accounts are the operator's (S197: "remove every reference to quotas of other agents i am handling this") - launch and read the run.
- A task is `ops/research/TASK_<id>.md` (self-contained: spec, owned files + line counts + anchors, parse gate, the one
  test command and its tier, a `Model:` line, a `Discipline:` line - boxing = demo, anything else waits for his call (S235: an MMA
  kick ran 3 agent rounds as demo work) - the one trap). Big files: name line count and `sed -n` windows
  (`GameState.gd` and `FightRealtime.gd` are never read whole).
- Launch shell agents only through `ops\Tools\agent_window.ps1 -Title <t> -Command ops\Tools\<agent>_task.cmd -ArgumentString
  "prompt|workspace|out"` (Qwen `qwen_task.cmd` = qwen3-coder --yolo; Cursor `cursor_task.cmd`; Codex `codex_task.cmd`).
  At every launch and landing update `ops/AgentComms/live_runs.json` (title in plain words, started, ETA, status) - the
  operator watches who works on what at 127.0.0.1:8787/agents (S144). At most 3 shell agents at once (operator S144, PC heat). PC agents: 3 when the watchdog is GREEN/AMBER (operator S226 Q-S225-5 "I'll keep fewer browsers open"; was 2 since S218).
  One worktree per agent on E:, SEEDED before launch with `ops\Tools\seed_godot_cache.ps1 -Worktree <wt>` (copies the 4.4 GB import
  cache; operator S206 "do the cache fix" - an agent's full editor import drove the PC to 87 C). Agents run tests `--jobs 1` when
  the watchdog is not GREEN. Read the transcript, never the rc. Drive each to a pushed commit you verified.
- A blind contract test is written from the contract, never from the implementation; prove it with mutants.
- Shell-less agents (Grok bots, Dola, John, Kalli, Maria) get pure modules with zero preloads or research; never a repo
  test command.
- CLOUD FIRST (operator 2026-10-03: "use arena.ai nonstop", "use john for research task if you need"): headless work (code,
  tests, C223 gates, probes) -> ARENA, re-tasked the moment its PR lands; research -> DOLA/JOHN (`python ops/Tools/gbot.py`, never bare
  gbot) after `prior_research.py`. The PC keeps window/GPU work and merging. Never Agent `isolation: "remote"` (S156: it fell back to C:).
- CLOUD SEATS (S157): Arena, OpenHands, OpenCode (`/oc`), Goose (label `goose`, long tasks) - how-to in AGENT_TOOLS.md. WATCHABLE
  (operator: "always open cloud agents on your sidebar"): one browser-pane tab per running cloud agent + `branch`/`gh_run`/`issue` in live_runs.json.
- ARENA (operator ruling 2026-10-03): works on the code-only mirror ICOON-Studio/FightCamp-lite (S264, clone failures; `ops/Tools/lite_mirror.py push` before a launch, its PRs relay to arena/* PRs here every 30 min); its own `arena/<chat-id>-<repo>` branch and PR; Claude reviews and merges - NEVER Arena's "Merge
  PR" button, never master. Self-contained tasks, exact acceptance test, no LFS-loading tests (CI has no LFS). Everything sent is PUBLIC.
  A NEW chat per task and per review round. It deletes tests to go green: read the CI log yourself, `ops/Tools/ci_arena.py guard`. AGENT_TOOLS.md "Arena".

## 10. Product rules
- TWO POINT ALIGNMENT (operator S244: "Make sure every agent is aligned with 2point museum perspective and item integration per room"):
  gym camera, rooms, items and build mode follow `ops/research/TWOPOINT_ALIGNMENT.md` (measured TPM numbers + per-room required
  item slots); every such brief cites it; AGENTS.md carries the same line for the code seats.
- NEW FEATURES SHIP ON (operator S221: "everything new built i want it defualted to on"): every built feature goes in
  `GameSwitches.GAME_ON` and is read with `GameSwitches.on()` - never a raw `cmdline_user_args().has()` opt-in, never DEFAULT_OFF.
  Plain `--script` tests stay the OFF control arm (as_game turns them on); every brief says so.
- The facility is a "gym"; a fight camp is only the pre-bout preparation. Organisations/tournaments real; fighters fictional.
- Assets ripped from other games stay in the scratchpad, never ship. Keep asset files light. Gym art is bright and alive.
- Check for prefabs (Asset Library, GitHub, itch, Fab, Mixamo, datasets) before building anything new; name the licence.

## 9. GDScript traps that cost a fix cycle
- Read `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript (Variant `:=`, `%%`, reused names, Label sizing, autoload order, callv).

## 11. History
- Incident stories, retired rules and the reasons behind each rule: `ops/research/RULES_HISTORY.md`; per-session lessons in the memory index.
