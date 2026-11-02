# FightCamp - project cancelled by the operator (2026-10-23)

Operator, verbatim: "its very bad, the projects gets cancelled" / "Wind it down: stop Cursor #345 and the background jobs, delete
nothing."

Nothing was deleted: code, builds (Builds/FightCamp_Godot, S293 build), research, worktrees under E:\FightCamp\wt, agent branches and
history are all as they were. Last working commit before wind-down: 6e71f2db (S293).

## What was switched off (and how to switch it back on)
- Cursor GOLDREDS1: issue #345 unlabelled and closed; branch cursor/issue-345 kept. (`gh issue reopen 345`, re-add label `cursor`)
- GitHub workflows disabled: Nightly suite (03:00 UTC cron), cloud-agent, goose, opencode, xai-research, gemini-models.
  (`gh workflow enable "<name>"`; CI, Code gate CI, Cloud tests and the rest are push-triggered and were left enabled)
- Windows scheduled tasks stopped + disabled: FightCamp Board Reconcile, Heat Governor, Ops Board, PC Watchdog, RAM Trim
  (Nightly Suite was already disabled). (`Enable-ScheduledTask -TaskName "<name>"`, then `Start-ScheduledTask`)
- The hidden Ziva Godot editor (wt/ZIVA) was stopped by PID.

## Where it stood
S291-S293: the fighter's path (quick start -> walk-in signs -> coach -> training weeks -> booking -> camp -> fight night -> result ->
next goal) plays 10/10 in tests/golden_path_test.gd -- as_game, with Ludo's pace + money verdict built (S293_DIGEST.md). Open items
are in AgentComms/roadmap.json `now` and the S293 digest.
