# U30 digest — Ops Board

Local web ops board in `Tools/opsboard/`. Stdlib Python server on
`0.0.0.0:8787`, one responsive page, auto-refresh every 5s.

## Real data

| Field | Source |
| --- | --- |
| NOW open tasks | `python Tools/agent_comms.py board` (parsed, not reimplemented) |
| Process up | Windows `tasklist` for qwen / codex / cursor; Claude best-effort |
| Grok process | labelled **browser, not detectable** |
| Elapsed / turnaround / idle / median / longest | assignment mail or task `Assigned` date + git commit timestamps |
| History | `### AGENT - ID: … (COMPLETE …)` in HANDOFF (+ archive tail) + `git log --grep` |
| Diff / tests added | `git show --numstat` / `--diff-filter=A` (newest two finished tasks per agent) |
| Suite | latest `SUITE total=N fails=M` in digests or done-mail |
| Attention | board UNREAD + `triage --no-fetch` |
| Switches | `AgentComms/roster.json` intent only |

## Cost

- **Codex:** measured when a run log exists — literal `tokens used` if present, else latest session `total_tokens` from `~/.codex/sessions`.
- **Qwen, Grok, Cursor, Claude:** **UNKNOWN**. No estimate, no price×tokens.

## Gate

`python Tools/opsboard/server.py --selftest` → PASS.

Godot suite run before commit: `SUITE total=216 fails=1`
(`realtime_round_stats_test.gd` — grappling zeros vs live scores; not U30;
U30 touches no `Godot/scripts/` / `Godot/tests/`).

## Phone

`python Tools/opsboard/server.py` → `http://192.168.178.115:8787/` on this LAN
(printed at startup; IP varies by machine).
