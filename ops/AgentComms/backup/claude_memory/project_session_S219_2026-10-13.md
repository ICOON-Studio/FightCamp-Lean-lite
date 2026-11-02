---
name: project_session_S219_2026-10-13
description: "S219 2026-10-13 - jabs back (NOJAB1), New Career finished + Ludo-approved, Codex web access + Ludo CLI, station wear B/C, gym r6; lessons"
metadata:
  type: project
---
Built: NOJAB1 (FightMoves stage-2 draw made the head jab unreachable - 0 jabs per fight); NEWCAREER2+2B (Ludo r53/r55, warm brown D47,
story start = Mara, sandbox = S144 empty gym, legacy fixture kept for tests); STATIONWEAR1B+1C (Grok Dev); gym r6 on cursor/gymlook3a
(waits operator OK); Codex browser + ludo CLI. Digest research/S219_DIGEST.md.

Lessons:
- Read the board answers BEFORE saying "waiting on you" ([[feedback_check_board_before_waiting]]).
- The Claude desktop app is an MSIX package: npm -g installs from Claude's shell land in its private AppData; install tools for other
  programs under E:\FightCamp\tools ([[reference_ludo_cli]]).
- A Codex run can hang with its cmd alive: judge by ~/.codex/sessions rollout LastWriteTime.
- A change to the shared new-career path touches ~200 tests: keep the legacy default and add the new behaviour behind a named option.
- UI renders: wait for entry tweens before capture; open every render - the first NEWCAREER2 render looked broken only from timing.
- Stale .git/index.lock appeared 3x with no git alive - remove after checking processes; source not found yet.
Related: [[project_session_S218_2026-10-13]].
