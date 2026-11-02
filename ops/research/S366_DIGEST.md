# S366 digest - one repo, the E: stall, animation previews (2026-11-02)

No game code changed. Lean commits: 901c057 / 0339f33 (move), e2848dc / 4aa8c46 (state out of git), acb2786 / 889088f
(clinch sources) - each on s365-bjj-side and main with identical ops/ content, so the branch merges clean.

## Why the PC froze (operator: "the start session used to be 10-20 seconds", "why pc is so slow")
- E: is a SanDisk SSD Plus 480 GB (DRAM-less SATA, ~49,000 power-on hours) and was 96% full (17 GB free).
- After the S365 restart a stale `.git/objects/maintenance.lock` (from 9/10) was deleted in the old repo. That lock had
  blocked auto-gc for two months, so 9.5 GB sat in 90,715 loose objects; with it gone every `git fetch` (start runs one)
  began a full repack. E: went to 0% idle, ~1 s per write, queue 6-11. No disk errors in the event log: a full,
  DRAM-less SSD with no free blocks, not a dying one.
- Fixes: packers killed and auto-gc off in the old repo (S365 session); `Optimize-Volume -ReTrim` trimmed 16.1 GB and
  writes returned to 0 ms; the old repo deleted (below): E: 19 -> 58 GB free.
- Never again: `ops/Tools/pc_watchdog.ps1` reads E: free % and write latency over 2 s and names any git packer -
  AMBER under 15% free or writes > 100 ms, RED under 5% free or writes > 250 ms with the disk never idle. RED blocks
  every Godot/test/agent start (rule_guard) and pauses Godot (heat governor). Lean's CLAUDE.md has the DISK rule.
- Still on E:: pagefile.sys 32 GB with 23 MB used (operator's Windows setting), Undisputed 18.7 GB (he plays the
  ESBC Revival mod; our S254 study is finished).

## One repo (operator: "why have 2 repos for 1 project?", "fix this make the workflow properly")
- Lean holds the game (root) and the workflow in `ops/` (`.gdignore`): `ops/Tools` = the 125 tool files the workflow
  uses (traced from the scheduled tasks, hooks, start, both CLAUDE.md files and the session logs since 10-28; the old
  game's other 695 stayed behind), `ops/AgentComms` (roadmap, questions, runs), `ops/research` (4,604 text files + 290
  linked images), `ops/previews` (board media, git-ignored), `ops/WORKFLOW.md` (the old CLAUDE.md, imported by Lean's).
- Path rewrite: `Godot/research` -> `research`, `Godot/docs/previews` -> `previews`; agent tools target
  ICOON-Studio/FightCamp-Lean `main`; the old FightCamp-lite push is off (the Lean mirror stays).
- Scheduled tasks (board, watchdog, heat governor, RAM trim, reconcile) run from `E:\FightCamp\Lean\ops`; the
  disabled old nightly task is removed. Hooks: `Lean/.claude/settings.json`. Memory copied to the Lean project folder.
- Defects found on the way: idle_guard had been a no-op since S138 (it only fired under a "ChatGPT" path) - it now fires
  for Lean sessions; rule_guard counted tests in `Godot/tests`; `start` listed the main checkout as an agent run;
  brief_contract would have flagged all 1,694 moved briefs (old repo dates frozen in `research/_contract_moved.json`);
  machine-written state (pc_health, reconcile/collect/suite/retire/relay json) no longer tracked.
- `start` from Lean: 7 s, no errors. Board test copy and the live board serve roadmap, PC and questions from ops/.
- The old repo `E:\FightCamp\Game` was deleted on the operator's answer "Delete whole old repo", after the list of what
  only it held (570 never-pushed old agent branches, ~680 untracked old-game models/animations, MetaHuman .mh4 build
  data 6 GB, old review media). Its master was fully pushed (GitHub ICOON-Studio/FightCamp). Before the delete the clinch
  baker's two Cascadeur clips moved to `tools/bake_src/`. A forwarding stub `E:\FightCamp\Game\Tools\rule_guard.py`
  stays only because this session ran from that folder; S367 removes the folder.

## Board animation previews (operator: "can you also work on the board animation previews")
- `ops/Tools/lean_anim_render.py` rendered every clip of `lean_anim_catalogue.py` (153: 123 in the fight, 30 never
  picked) with `tools/clip_orbit.gd` on the hidden desktop -> `ops/previews/lean_anim/<id>.mp4`, served at
  `/media/lean_anim/<id>.mp4` on 8787/animations. Checked: pro_idle contact sheet - the boxer alone on the grid, the
  camera circles once, head to boots in frame, boots on.

## Asked and answered
- Claude plan: a bigger plan buys more usage (Opus by default, longer/parallel sessions), not speed; today's slowness was
  the disk.
- animationshopee.com: $1 single boxing clips (~44: punches, hooks, blocks, guards, footwork, reactions; no jab/cross/
  uppercut/knockdown/clinch), FBX/BVH, licence agreement not published - a $1 test clip at most until it is in writing.
- jiujitsu-sekai.com: a BJJ sequence viewer web app, no downloads or licence - reference only.
- ESBC = Undisputed's pre-2022 name; the mod is "ESBC Revival" from a Discord (not downloaded: untrusted source).
