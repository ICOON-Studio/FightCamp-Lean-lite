# Ziva (ziva.sh) for FightCamp - research S237 (2026-10-17)

Read-only research. Nothing installed, nothing run. Sources: ziva.sh docs and blogs (URL per claim), the
GitHub repo, and the plugin we downloaded (`E:\FightCamp\tmp\ziva_dl\x\addons\ziva_agent\`, manifest
`v3.3.0`, commit `835514c`). The tool list was taken by reading the bytes of `zivacode.exe` with a Python
script (no execution). Anything not confirmed by a doc page or by the plugin's own files is marked UNVERIFIED.

## 0. The answer in five lines
1. Over MCP (Claude Code + `ziva-godot`) on the free Hobby plan we get about 40 editor tools. The playtest tool
   among them is **`run_scene`**: it boots ONE scene, plays a timed list of inputs, and returns ONE final
   screenshot plus the console errors.
2. The turn-by-turn QA tools (`game_start`, `game_act`, `game_observe`, `game_watch`, `game_drive`,
   `game_stop`) are handed only to Ziva's own "Full Game Playtest" subagent. That subagent needs **Pro**. They
   are not in the MCP tool list.
3. Ziva has **no animation tools**: no AnimationPlayer, AnimationTree, keyframe or retarget tools. Animation work
   happens through general tools: editing text files, `execute_script`, `run_scene` stills, `view_image`.
4. Video capture (Devlog, playtest recordings) needs **Pro**. On Hobby we get still images only.
5. It needs a running Godot **editor** with the Ziva panel. `run_scene` plays the game inside the editor's Game
   tab. Its own `start_godot` tool would open a VISIBLE editor window, which breaks our no-popup rule. Each
   MCP tool call is cut off at **60 s** (issue #13).

## 1. Complete tool list

### 1a. Godot tools (definitions read from `zivacode.exe`; the Godot list `Hh6` holds 43 entries)
Each definition reads `{name:"x",label:"Y",description:...}`. The descriptions below are shortened from that text.

| Tool | What it does | Params (documented in the binary) |
|---|---|---|
| `get_scene_tree` | XML tree of nodes in a scene FILE (children_count, scripts, groups, instanced scenes); filters switch it to a flat list | file path, filters (e.g. by script path, `*`) |
| `get_project_info` | Info from project.godot and other sources | - |
| `get_godot_errors` | Script errors, runtime errors, stack traces, output log (print) | - |
| `clear_output_logs` | Clears the editor output log | - |
| `get_node_warnings` | Real configuration warnings for the open scene | - |
| `get_open_scripts` | Scripts open in the editor | - |
| `get_input_map` | Input actions (and events), paginated | offset, limit |
| `get_screenshot` | Screenshot of the EDITOR as it looks now | scale (and prompt/model in text-only mode) |
| `view_image` | Look at one project image (res:// path) or a chat attachment | path, prompt |
| `run_scene` | Runs a scene LIVE in the editor's Game tab; returns a screenshot of the final frame, plus console output and runtime errors | `scene_path`, `inputs[]`, `duration_ms` (needed on every call), `speed`, `target_fps`, `prompt`, `model` |
| `run_tests` | Runs GDScript tests | `path`, `filter`, `timeout` (1-300 s, default 30) |
| `execute_script` | Runs any GDScript in a HEADLESS Godot subprocess; returns its print output | code |
| `create_file` | Creates .gd/.cs/.gdshader/.tscn/.tres; checks scenes and resources after writing | path, content |
| `edit_file` | Text edit of a file | - |
| `read` | Reads a file (and opens scripts in the editor so the syntax check runs) | path, offset |
| `glob` / `grep_code` | Find files / ripgrep over the project | pattern |
| `mv` / `rm` | Move or rename / delete (only when asked) | - |
| `open_scene` | Opens a scene in the editor | - |
| `add_resource` | Adds a resource or sub-resource as a node property in a scene FILE | - |
| `duplicate_node` / `move_node` | Duplicate a node / reparent it in a scene FILE | file_path, node_path, new_parent_path, keep_global_transform |
| `update_project_setting` | Writes project.godot "from inside the editor, the only safe writer of that file" | - |
| `set_editor_setting` | Changes an EditorSettings key that already exists | - |
| `project_path_to_uid` / `uid_to_project_path` | Convert res:// to uid:// and back | - |
| `search_docs` | Godot class docs plus Ziva's own docs | query |
| `validate_physics_setup` | Checks collision masks, layers and shapes (2D focus) | file_path, character_nodes, platform_nodes |
| `configure_sprite_frames`, `animate_sprite` | AnimatedSprite2D SpriteFrames; AI-generated sprite sheets (2D only) | - |
| `configure_tileset_atlas`, `edit_tilemap`, `get_tilemap_layout`, `get_tilemap_state`, `get_tileset_info`, `validate_tilemap_structure` | TileMapLayer work (2D) | - |
| `generate_image` | AI image generation (needs approval; may cost money) | - |
| `setup_analytics`, `setup_multiplayer` | Ziva cloud services (need sign-in) | none |
| `web_search`, `web_fetch`, `ask_question`, `prepare_game_listing` | Ziva chat only - **removed on the MCP surface** (list `LI6` in the binary) | - |

The binary has **no** tool named `add_node`, `set_node_property`, `create_scene`, `delete_node`,
`connect_signal`, or any `animation_*`. A search of the bytes for those names found zero hits. Node edits go
through `.tscn` text edits, `add_resource`, `duplicate_node` and `move_node`.

### 1b. MCP-only bridge tool
- `start_godot`: "Open the current Godot project's editor. Use this when Godot isn't running yet." It spawns
  `godot -e --path <project>` detached (binary). Docs: https://ziva.sh/docs/ziva-mcp-server

### 1c. QA-session tools (Full Game Playtest subagent only - Pro)
In the binary they are built by `Lu6()` and returned only when the agent is `"full-game-playtest"`
(`h46`: `if($!==qD)return[]`). They are not in the MCP list.

| Tool | What it does (from its definition) |
|---|---|
| `game_start` | Launch a scene for a QA session; frozen from boot, frozen between ops; params `scene`, `goal` (shown on screen) |
| `game_act` | Unfreeze, deliver inputs, advance `advance_frames` or `until` an expression is true, freeze. Reports `probes_before/after`, `effect` (observed / world_only / none), `world_changed` (camera moved, focus, UI count), `foreign_input`, `decayed_after_release` |
| `game_observe` | Evaluate probe expressions on the frozen game; optional `screenshot` (PNG); optional `ledger` (recent ops) |
| `game_watch` | Tap signals (`node_path`, `signal`, up to 6 args); events ride on every reply |
| `game_drive` | Run a short GDScript body (up to 8000 chars) against an `api` (press/release/tap/drag/move_mouse/servo/eval/until/wait_physics/log) at frame speed |
| `game_stop` | End the game; write the evidence bundle under `.ziva/qa-runs/` |

Docs for the agent: https://ziva.sh/docs/playtest , https://ziva.sh/docs/subagents ,
https://ziva.sh/blogs/ai-agent-playtest-godot-game (shipped 3.1.4, recordings 3.1.6).

### 1d. Not Godot
The binary also holds Unity tools (`manage_play`, `execute_csharp`, ...), Unreal tools (`run_playtest`,
`capture_viewport`, ...) and the zivacode CLI's own tools (`bash`, `powershell`, `edit`, `find`, `grep`, `ls`,
`write`). They are not exposed for a Godot project.

## 2. What the plugin files show (ziva_input_harness.gd, 3,250 lines; devlog/*.gd)
- The harness is registered as autoload `ZivaPlaytestIO` before the game plays. It has two modes, picked by
  which sidecar file the tool wrote:
  - **batch** (`run_scene`): sidecar `res://.godot/ziva_playtest_inputs.json` with keys `results_path`,
    `results_tmp`, `report_path`, `started_path`, `duration_ms`, `inputs` (and optional `speed`). It replays the
    timed inputs, waits 5 frames, saves ONE PNG of the root viewport (longest edge capped at 1568 px, so our
    1920x1080 becomes about 1568x882), and writes a delivery report. The report gives the frame and ms of every
    edge, a list of undelivered inputs, `text_readback` for typed fields, and optional `speed` data (FPS,
    draw calls, node counts, profiler).
  - **session** (QA tools): sidecar `res://.godot/ziva_qa_session.json` `{port, token, path, record?,
    record_dir?, seat?, goal?}`. It dials `ws://127.0.0.1:<port>`, freezes the tree, and serves the ops
    `observe` / `act` / `watch` / `drive` / `stop`, one at a time, each within a 120 s deadline.
- **observe returns:** probe values (GDScript `Expression`s run against the current scene root, with `tree` and
  `root` bound; each value capped at 4096 chars), the physics frame, render facts, and an optional base64 PNG.
  A probe that changes game state "taints" the session, and every later op is then refused.
- **Input kinds:** `action` (InputEventAction), `key` (raw InputEventKey; send one entry per character; with
  `target` it clicks the LineEdit first), `mouse` (x, y in viewport pixels, left or right button), `target`
  (clicks the CENTRE of a Control found by node path, `.name` or exact `.text`), `motion` (dx, dy), plus `drag`
  and `servo` in sessions. Mouse clicks ARE supported, so Control buttons work. There is no scroll wheel, no
  middle button, and no hover-only input other than a drag or move_mouse in a session.
- **Real cursor:** in batch mode (`run_scene`) every click first calls `Input.warp_mouse`, so it moves the
  machine's real cursor (`_move_mouse`; the seated SubViewport mode that avoids this exists only in sessions).
- **Recording (session only):** JPEG frames every 2 physics ticks into `record_dir`, with `recording.json`
  `{frames, live_ms, stride, physics_hz}`, then encoded by the bundled ffmpeg into `playtest.mp4`.
- **Devlog** (`devlog/devlog_capture.gd`): an autoload added in memory, active only while
  `user://ziva/devlog/state.json` says it is enabled. It pipes frames to `bin-deps/.../ffmpeg.exe` as 10 s mp4
  segments, and it skips headless runs ("Ziva's run_tests and execute_script tools, CI"). Devlog is Pro
  (https://ziva.sh/docs/devlog ; the binary says "Devlog videos are part of Pro").
- Bundled executables: `ffmpeg.exe` (LGPL build, FFMPEG_NOTICE.md), `rg.exe`, `git.exe`, the 7.9 MB GDExtension
  DLL, and `zivacode.exe` (122 MB). LICENSE.md is proprietary ("No permission is granted to copy, modify,
  distribute ... or use this asset except as expressly authorized"). Do not commit the addon to our repo.

## 3. Plans: what Hobby gets
| Feature | Hobby (free) | Pro / Ultra | Source |
|---|---|---|---|
| Use our own Claude Code subscription | yes (must be signed in to Ziva) | yes | https://ziva.sh/docs/existing-subscriptions , https://ziva.sh/pricing |
| Ziva as MCP server (`ziva-godot`) | yes - plan limit not stated (UNVERIFIED that no limit applies) | yes | https://ziva.sh/docs/ziva-mcp-server |
| `run_scene` quick playtest (one final screenshot) | yes - "playtest tool" setting, on by default | yes | https://ziva.sh/docs/playtest |
| Find Lag (`run_scene speed:true`) | yes - "Available on every plan" | yes | https://ziva.sh/docs/game-speed |
| Full Game Playtest Agent (`game_*` tools, verdicts, `.ziva/qa-runs/`) | **no** | yes - Pro $50/mo per the blog | https://ziva.sh/docs/subagents , https://ziva.sh/blogs/ai-agent-playtest-godot-game |
| Playtest recording `playtest.mp4` | no (applies only to the Playtest Agent) | yes | https://ziva.sh/docs/playtest |
| Devlog video (ffmpeg) | no | yes | https://ziva.sh/docs/devlog |
| 3D Model Generator, web search | no | yes | https://ziva.sh/docs/3d-models , https://ziva.sh/docs/settings |
| Ziva-hosted free model | 50 msgs/day, 160k context | - | release v3.2.2, https://github.com/ziva-sh/ziva-agent-plugin-godot/releases |

UNVERIFIED: whether a Hobby account can enable the `game_*` tools in any other way. The code hides them from MCP
for every plan.

## 4. Animation: what is real and what is marketing
- **Documented:** nothing for 3D animation. The docs and blogs mention AnimatedSprite2D sprite sheets only
  (`configure_sprite_frames`, `animate_sprite`; https://ziva.sh/blogs/ziva-scene-tree-3d-tilemap-evidence). The
  3D generator makes `.blend` models, "says nothing about rigging or animation" (https://ziva.sh/docs/3d-models).
- **Marketing only:** the README says Ziva "understands ... every ... animation". No tool backs this.
- **What we can actually do with Ziva tools:**
  - Inspect: `execute_script` (headless) can load an `Animation` / `AnimationLibrary` / `.glb` and print the
    track paths, key counts, lengths and bone names. `get_scene_tree` shows the AnimationPlayer/AnimationTree
    nodes in a `.tscn`.
  - Edit: only text `.tres`/`.tscn` resources (`edit_file`), or a script run through `execute_script` that
    edits and `ResourceSaver.save`s. Imported `.glb` clips are edited through their `.import` settings, not
    directly. Retargeting means a BoneMap in the import settings, done by hand-written edits; Ziva has no tool
    for it.
  - Preview: `run_scene` on a small preview scene, with `duration_ms` choosing the moment, gives ONE still per
    call. For N poses, make N calls (each reboots the scene). No video on Hobby.
  - Review: `view_image` on stills we already make (still_framing.gd output). It is a vision check, not a gate.
- In short: Ziva adds nothing for animation that our record_room / still_framing / Cascadeur pipeline does
  not already do better. Its value here is a second pair of eyes on stills and a quick headless inspection of
  tracks.

## 5. Requirements and limits
| Question | Answer | Evidence |
|---|---|---|
| Needs the editor GUI? | Yes. "The editor must be running for the full tool set"; with the editor closed only `start_godot` shows | https://ziva.sh/docs/ziva-mcp-server ; https://ziva.sh/docs/installation |
| Visible desktop? | Not stated. `run_scene` plays inside the editor's Game tab. The harness warns that "A game embedded in the editor's Game tab stops drawing while that window is covered or minimized", and the capture then fails after 60 frames. Our hidden Win32 desktop draws (the GPU renders there), so it SHOULD work. **UNVERIFIED - needs one probe.** | harness `_capture_frame_raw` |
| `start_godot` | Spawns `godot -e --path` detached = a VISIBLE window. **Never use it.** Launch the editor ourselves through `Tools\godot_hidden.ps1 -e --path ...` | binary `PC6` |
| Cursor | `run_scene` clicks warp the real cursor. On the operator's desktop that steals his mouse. On the hidden desktop: UNVERIFIED | harness `_move_mouse` |
| Main scene boots a career shell? | Yes in principle: `run_scene` takes any `.tscn` (our `res://scenes/BootRoot.tscn`), and autoloads run. Editor runs have no `--script`, so `GameSwitches.in_game()` is true and GAME_ON features are ON. But every call REBOOTS the scene, so nothing carries over between calls unless the game saves | harness `_run`; `Godot/scripts/GameSwitches.gd:88` |
| Mouse on Control nodes? | Yes: `target` clicks the centre of a Control found by path, name or exact text; `mouse` clicks at x, y. A July note says CanvasLayer buttons could not be clicked (not re-tested) | binary `xk6`; https://ziva.sh/blogs/ai-agent-playtest-godot-game |
| 3D gym floor | Click by pixel only. The floor's agents need x, y from a still. No raycast picking helper in batch mode | harness |
| Headless? | Only `execute_script` and `run_tests` (headless subprocesses). `run_scene` needs drawn frames | devlog_capture.gd comment |
| Time limit | Every MCP tool call has a hard 60 s timeout (open issue #13). A `run_scene` must boot, play and capture inside that | https://github.com/ziva-sh/ziva-agent-plugin-godot/issues/13 |
| Concurrency | One QA session per editor ("A QA session is already live"). Sidecars live in `res://.godot/`, so one editor per project folder. Other Godot processes in OTHER folders are fine. Note: heat_governor suspends the NEWEST Godot process on RED - that may freeze Ziva's game mid-run | binary; CLAUDE.md s4 |
| Disk and heat | The editor opens the project = a full import unless the worktree is seeded (`seed_godot_cache.ps1`). Ziva's panel is a CEF web view (extra RAM) | CLAUDE.md s4/s8; release v3.2.1 "CEF" |
| Telemetry | PostHog (EU) plugin telemetry, on by default ("Basic + usage statistics"); set Settings > General > **"No telemetry"** = "nothing is sent". Telemetry never contains prompts, files, scenes or scripts. Code and chat go to the LLM provider | https://ziva.sh/privacy ; https://ziva.sh/docs/settings |
| Screenshots | Sent to the selected model. Over MCP that model is Claude Code itself (the MCP surface passes `modelSupportsVision:true`, so the PNG goes back to the client, with no Ziva vision subagent) | https://ziva.sh/docs/playtest ; binary `xq()` |
| Sign-in | Ziva account sign-in is required for existing subscriptions. UNVERIFIED for MCP-only use | https://ziva.sh/docs/existing-subscriptions |

## 6. Recommended workflow for FightCamp (Hobby + Claude Code)

### Setup (one time; the operator must OK installing a proprietary binary plugin = scope/money call)
1. Worktree `E:\FightCamp\wt\ZIVA` (it exists), branch `ziva/playtest`. Seed it: `Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\ZIVA`.
2. Copy `addons/ziva_agent` into the WORKTREE only. Add `Godot/addons/ziva_agent/`, `Godot/.ziva/` and
   `Godot/.godot/ziva_*` to that worktree's `.git/info/exclude`. Never commit them.
3. Launch the editor hidden: `Tools\godot_hidden.ps1 -e --path E:\FightCamp\wt\ZIVA\Godot` (watchdog first).
   The first time only, the plugin must be enabled and signed in through its panel. That panel is on the hidden
   desktop, so this step needs a plan (UNVERIFIED: whether settings can be set without seeing the panel).
4. Settings: telemetry "No telemetry"; playtest tool ON. Register `ziva-godot` in Claude Code (`claude mcp add`
   with the generated config). Start Claude Code from `E:\FightCamp\wt\ZIVA\Godot`.
5. Probe gate, before any real use: one `run_scene` of `BootRoot.tscn`, `duration_ms` 3000. Pass = a non-black
   PNG comes back, the run ends inside 60 s, no window shows on any monitor (`popup_probe.ps1`), and the
   operator's cursor does not move.

### (a) Playtest: title -> new career -> creation -> first floor day -> menu tour -> booking -> fight
Because every `run_scene` reboots and is capped near 60 s, the play-through becomes **segments**:
1. Claude writes small **checkpoint entry scenes** in the worktree (`res://tools/ziva/entry_<step>.tscn`).
   Each boots through the game's real code to a fixed state, for example a new career with a fixed seed, then
   creation done, then floor day 1. Each segment then tests only its own UI path. Mark them as test fixtures.
   They never ship.
2. Per segment, Claude runs `run_scene` with inputs that use `type:"target"` and the button's node path or
   visible text (best for our Control menus), `type:"key"` + `target` for the gym-name LineEdit, and `mouse`
   x, y for the 3D floor (coordinates read from the previous still). Set `duration_ms` to leave about 1 s after
   the last input.
3. After each call Claude reads: the screenshot; the delivery report (undelivered inputs = a wrong selector,
   not a game bug); the console errors. Then `get_godot_errors`. Each defect is logged as one line: segment,
   input, expected, seen, still path.
4. Order: Title -> New Career; creation (country, city, gym name); first floor day (Day Plan, one order, end
   day); menu tour (each top-level menu, Esc back); booking (offer -> accept); fight (enter, watch 30-40 s, end).
   The fight is longer than 60 s, so we capture at several `duration_ms` points rather than one run.
5. Speed: `run_scene speed:true` on the HOME/floor segments catches stutter (file:line profile).
Stills sent to the operator still go through still_framing.gd rules. A Ziva PNG is a QA artifact, not a review
still.

### (b) How fixes flow back
1. Claude (the developer) edits in `E:\FightCamp\wt\ZIVA` on `ziva/playtest`. Ziva tools are used to CHECK, not
   to write: `get_godot_errors`, `get_node_warnings`, `run_scene` again on the same segment. Ziva's own chat agent
   stays unused. On Hobby it would run on our Claude Code quota anyway, and it duplicates Claude.
2. Our gates in the worktree: `python Godot/tools/check_scripts.py <files>`, the focused test,
   `run_tests.py --only <x> --jobs 2`.
3. Commit on `ziva/playtest` with explicit `git add -- <files>` (never the addon, `.ziva/` or the entry scenes
   unless they are meant as tests). Then `python Tools/check_workflow.py branch ziva/playtest <task>`. Apply the
   DIFF to master (CLAUDE.md s7). Rerun the segment once on master's code before closing.
4. Retire or refresh the worktree after the merge (7 GB each).

### (c) Animation review with Ziva
- Track census: `execute_script` that loads each `mh_*.glb` / AnimationLibrary and prints the length, track
  count, bone tracks that are missing against the Skeleton3D, and key count per track. This is cheap and
  headless, and it catches missing or broken tracks after a retarget.
- Pose stills: a preview scene that plays one clip on a fighter under the broadcast camera. Call `run_scene` at
  2-3 `duration_ms` values (guard, mid-punch, recovery) and judge with the visual-gate checklist
  (gap/noses/wrists/feet). This is a SECOND opinion only. The closing gate stays `record_room ... as_game` +
  still_framing + the operator's OK (CLAUDE.md s2).
- Video review: not on Hobby. Keep our own capture pipeline.

### Decision notes (for the stage report)
- Hobby + MCP gives `run_scene` batch playtests and editor introspection. That is worth a one-session probe on
  the hidden desktop. It does NOT give the turn-by-turn agent the operator imagined ("fix everything").
- The turn-by-turn QA agent (`game_*`) costs Pro, about $50/mo (blog). It is a money call for the operator. Even
  then it "reports what it finds. It does not edit your project", and it always uses a Ziva-hosted model, not our
  Claude Code subscription (https://ziva.sh/blogs/ai-agent-playtest-godot-game ; https://ziva.sh/docs/playtest).
- Driving `ziva_input_harness.gd` ourselves (writing the session sidecar plus our own WebSocket server) is
  technically possible but forbidden by the plugin's proprietary licence. Not recommended. If we need frozen,
  turn-by-turn control, we build our own harness from scratch, with the same ideas: freeze between ops, probe
  purity check, target-by-text clicks.

## Pages read
Docs: /docs, /docs/ziva-mcp-server, /docs/playtest, /docs/existing-subscriptions, /docs/devlog, /docs/game-speed,
/docs/installation, /docs/subagents, /docs/settings, /docs/3d-models, /pricing, /privacy. Blogs (index lists 88
posts; read the ones on topic): ai-agent-playtest-godot-game, use-claude-or-chatgpt-with-godot,
ziva-scene-tree-3d-tilemap-evidence, ziva-vs-godot-mcp-pro. GitHub: releases page (v3.2.1-v3.3.0; v3.2.3+ have
no notes; v3.0-v3.2.0 not shown), issues list (#1-#13). NOT read (UNVERIFIED gaps): /docs/mcp-servers,
/docs/local-providers, /docs/usage-limit-best-practices, /docs/troubleshooting*, and the other ~84 blog posts.
