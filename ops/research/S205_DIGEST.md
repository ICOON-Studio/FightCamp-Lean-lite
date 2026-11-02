# S205 digest (2026-10-11) - full-screen UI, Ludo's V3 HUD built, profile fixed, Ludo knows the real game

## What now works (evidence opened by Claude on the game's own screens)
- FULL-SCREEN INNER PAGES (operator: "make it full screen why you left the edges like that"): schedule, office, scouting, staff,
  rankings, training, gym hub run from the icon rail to the right edge (HOSTED_SHIFT -312, WIDTH 1794, SIDE_X follows LIST_W).
  Stills docs/previews/s205_fullscreen; tests 37/0 + 11/0. Profile panels left to PROFILE2 (widening them broke 2 tests - reverted).
- LUDO V3 HUD behind switch `hud_v3` (OFF; board Q-S204-2 asks to make it default): money | net/wk | runway top-left; time bar
  (date, speed, club, mail) top-centre; ADVANCE hub top-right (bout status + CONTINUE); dock at y=120 with settings/handbook under
  it; BACK = page breadcrumb; goals left; fighter cards + day-feed strip bottom (feed on the gym floor only). Codex luna drafted
  (HUDV3); Claude fixed double apply_hud2, plates, overlaps, draw order, then applied Ludo r39 s2 audit (V3.1). hud_v3_layout_test
  39/39; --only systems 24/0. Stills docs/previews/s205_hudv3.
- PROFILE2B (Cursor) + PROFILE2B_FIX (Cursor + Claude): the full profile overview (switch profile2) now covers the screen, body
  diagram rows fit, empty centre shows a state, floor HUD hidden under it. profile_overview 154/0. Still docs/previews/s205_profile2.
  Remaining (Ludo r40, approved-pending Q-S204-3): right column + centre content, trait chips, bout dossier, empty states.
- COLLECTED: NIGHTLY3 (playable_loop T1-T9 PASS; run_tests as_game injection dropped - suite keeps switches OFF; T8 no longer
  hard-codes a loss), SCOUTFID1 (PR #117, 62/0), WEEKGRIDPANEL1 (PR #116 + fit fix, 1434/0).
- OPS BOARD: live heat meter (/api/pc/live reads LibreHardwareMonitor every 2 s, no subprocess); MARKUP BOARD built in (/markup,
  "✎ Mark areas" under every question picture and review still; saves -> Feedback/<id>/ + a media_comments line `start` prints).
- DISK: 36 finished worktrees removed after salvage (E:\FightCamp\wt_salvage); E: 6.7 -> 164 GB free.
- CODEX: local CLI = ChatGPT plan (auth_mode chatgpt, no API key). Sandbox works once the Codex desktop app is closed AND
  codex_task.cmd's LOCALAPPDATA override is used; Codex's own intake (git fetch / agent_comms brief) fails in the sandbox - every
  Codex prompt now says to skip it. (CODEXSANDBOX1 done.)

## Ludo
- r39 (3 replies, 27.9k + 29.6k + 21.1k): s1 the producer's 3D "loadout" profile -> ADAPT (drawer = quick look, full profile = 3
  columns: biometrics | 3D stage | technique tree, 3 decisions); s2 V3 HUD audit (taken, except amber runway - M10); s3 animation
  (fatigue, state machine, scene tree, floor plan) for ANIMSCURVE/BALANCE/FATIGUE.
- r40 (27.7k): profile content per tab + empty states, on OUR 54-node tree. Mockup (2 image rounds): docs/previews/s205_ludo_profile.
- ROOT FIX (operator: "why ludo is not aware of what stats we use in game"): Tools/ludo_facts.py writes LUDO_GAME_FACTS.txt from the
  data files (stat keys, 9 bars, 54-node boxing tree, certified moves, regions, tiers) - pasted atop every Ludo ask from now on.

## Decided (Claude, developer)
- hud_v3 is a separate switch layered on hud2 (no rewrite of S186 nodes; walk tools keep their names).
- Still tools give the hosted panel the canvas size like CareerRoot (a 0x0 panel hid the backdrop and fooled the check).
- Tests read real drawing bounds (silhouette rects = polygon bounds; label text width measured).

## In flight at handover
Arena ANIMBUS1 (chat 01a12c0f, intent bus pure module, TASK_ANIMBUS1.md). Delegated this session: Codex (HUDV3), Cursor (PROFILE2B
collect, PROFILE2B_FIX), Arena (ANIMBUS1; PR #116/#117 collected), Ludo (r39, r40, 2 mockups).

## HANDOFF
Next action = roadmap now.next_action (S205). Last working code commit: the HUD V3.1 commit on master.
