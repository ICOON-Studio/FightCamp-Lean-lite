---
name: project-session-s222
description: "S222 (2026-10-14) delegation sweep - lessons on cloud-agent PRs, Codex launch args, Ludo one-image limit, gbot still broken"
metadata:
  node_type: memory
  type: project
  originSessionId: 3a24f803-fc57-4b09-ab94-7ae28b4c0659
  modified: 2026-10-13T23:02:35.751Z
---

S222 lessons (operator: "delegate as much work as possible ... we need a playable version soon with all mechanics on", see [[feedback-delegate-max-s222]]):
- cloud-agent.yml (cursor/goose labels) pushes the branch but CANNOT open the PR ("GitHub Actions is not permitted to create ... pull requests").
  Open it yourself with `gh pr create --head cursor/issue-<n>` - CI then runs the changed tests in the cloud, which is how to collect while
  the watchdog is AMBER beside PC agents (no local test run then).
- `agent_window.ps1 -ArgumentString` splits on `|` - a space-joined string made codex_task.cmd die instantly. A "running" live_runs entry
  can be a run that never started (S221 FIX5: Codex got a blank task) - check the out file / process before trusting it.
- Ask Ludo accepts ONE image per message ("Too many files"): join pictures side by side with PIL first. Chrome-extension JS reads cap
  ~1,000 chars; save replies via the built-in pane + `Tools/arena_rx.py <outdir>` receiver.
- gbot still fails (render-failed: no agents directory) - Kalli/Grok Dev reached through the Grok Bot app with computer-use
  (write_clipboard + ctrl+v + Return). Kalli writes its reply file to the repo within a minute.
- `Godot/scripts/FirstHour.gd` (Ludo's 16 beats) is read by NO script - dead data until FIRSTHOUR1B wires it.
- The S221 every-flag-ON sweep also switched on a DEV VIEW: `club_capacity` (ClubCapacityView greybox catalogue over the hall) covered the
  operator's approved round-6 floor - he asked "did you ruin the gymfloor we had ?". Now DEFAULT_OFF as a dev view. Before calling a flag a
  "feature", read its script header; A/B a suspect with `name=0` on tools/gymlook3a_stills.gd (the round-6 still tool).
- A switch's STATE must never share the switch's key in `career` (sandbox_parity crashed every read once its state dict was written).
- Godot Color("#RRGGBBAA") - Ludo gives ARGB (#F51E1713); the station card drew a 7% red panel.
- Board: Tools/board_reconcile.py (every 30 min) marks a PC run "stale" unless its `branch` is a REAL worktree branch or it has a
  `match` string found in a live process command line - give every PC run `match: "<id>_out"` (S222 ANIMCHAIN vanished from the board).
  Timers (S222 operator ask) read the leading "YYYY-MM-DD HH:MM" of `started`/`ended`.
- ONE Godot-heavy agent on the PC at a time: S222 ran Codex FIX5 (37-test batch + solo gates) beside the ANIMCHAIN - the chain's PAIRLIVE1
  never got the single Godot slot and launched zero tests. "2 PC agents max" is not enough when both are test-heavy; queue them.
