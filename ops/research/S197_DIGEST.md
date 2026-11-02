# S197 DIGEST (2026-10-11 00:25 -> 02:10, Claude Opus 5.5) - "playable by tomorrow": the loop push, the full gym, Ludo in the right chat

Operator S197 (verbatim): "delegate huge tasks i want the project to be playable by tomorrow"; "mass push work to finish to have playable loop
by tomorrow"; "keep this loop assign task merging until 450k tokens then go next session and use ludo i want the next stills tobe beautiful";
"let me see the UI when everything is wired in a proper way to make sense for me to play" (no partial UI pictures - next show = the wired build).

## Merged on master (all behind switches; tests run on master by Claude)
- EQUIP2B (cloud Codex, issue #101): every catalogue item has a day-lap row (95/95), 67 training items have per-discipline fit rows; originals
  unchanged. equipment_training_rows 3560/0 + a mutant caught; fit 8/0, day_lap 81/0, catalogue full 0 failures.
- GYMFILL1 + GYMFILL1B (Cursor): the club floor zones tile the hall and are packed with catalogue equipment (coverage 1.00, east half 0.47 -
  the operator's "half the gym is empty"), behind `club_zones`. club_ 14/0, gym_ 29/0. The first pass broke GYMLOOK1A's club_zones_test
  (overlapping patches, station outside its patch, materials) and was sent back. GAME-CAMERA STILLS OWED (PC was hot all session).
- TICKER1 (Cursor): Ludo r31 Part 2 - the morning card is a one-line ticker + gold STEP IN in the top time bar, skip via the ... menu,
  fight-week tab 36x180 with a countdown; switch `morning_ticker` (ON as_game, OFF headless). morning_ticker 12/0, morning 4/0, gym_hall 6/0.
- NIGHTLY2B (Qwen): FightWorldLiveScreen read /root/GameState outside the tree -> guarded; fight_world_live 24/0.
- GYMLOOK2 (Claude): Ludo r31 Part 3 + r32 Part 1.3 lighting/environment (cool skylight key, 6 fills, 4 warm brick grazers, ACES, AO/IL, glow,
  dust haze, colour grading) in scripts/club_look/GymLook2.gd + assets/data/gym_look2.json, switch `gym_look2` (OFF). Stills owed.
- Stills: tools/still_clean.gd hides the morning card and the calendar rail before every gym still (operator "remove those fromall stills").
- Ops board: E: free meter, temperature bands 74/84, the watchdog starts LibreHardwareMonitor when its feed is down ("heat meter shows null").

## Findings
- The 8 fight "hangs" of the 10-10 nightly reproduced ONLY in agent worktrees without `.godot/imported` (class_name registry incomplete ->
  parse errors -> hang). EVERY new agent worktree must run `godot --headless --path Godot -e --quit` once first (now in the briefs).
  Whether master itself hangs is NOT yet proven: run fight_realtime_test alone on master when the PC is GREEN (next session, first item).
- PLAYABLE1 (Codex, running): a booked amateur bout had no way into fight week (the dated row sent you to the month view) - Codex added a
  dated Fight Week action; its walk reaches the weigh-in. Still running at handover; it has only uncommitted edits (GameState.gd + the test).
- Goose cannot run (its model provider account); the Cline cloud seat has no key set - both are the operator's accounts, not chased.
- Arena's repo picker would not load a third parallel chat - two Arena chats max at once.

## Ludo (Pro since S197) - the chat is "Gym Management Screen"
- MISTAKE: FightCamp rounds (S196 round 30 and S197's first round 31) went into "Multi-Hub Space Strategy" = the operator's Nullspace game.
  Support request drafted (AgentComms/LUDO_SUPPORT_REQUEST_S197.txt). Rule: read the chat title before every send.
- Round 31 (interface, morning card, gym look) saved LUDO_ROUND31_S197.txt; round 32 + continuation LUDO_ROUND32_S197.txt (gym look rest,
  fighter readout, training-area wear, members, 30 events, fight week, skip rule, last spar, interface).
- Operator approved: Q-S196-1 "approve all" (round 31), Q-S196-2 "amazing, approve all and use 0-100 for band as ludo says" (round 32 A-C).
  OPEN: Q-S196-3 (round 32 D-H: fight week grid, last spar, skip rule, interface reference).
- Saving a reply: Chrome JS `navigator.clipboard.writeText` + PowerShell `Get-Clipboard -Raw` (one step); pictures may be attached (operator).

## Runs in flight at handover (collect, do not relaunch)
Codex PLAYABLE1 (wt E:/FightCamp/wt/PLAYABLE1, codex/playable1, uncommitted), Cursor GYMLOOK2B (wt GYMLOOK2B, cursor/gymlook2b),
Qwen EVENTS1A (wt NIGHTLY2, qwen/events1a), cloud Codex ATTRITION1A #104, STATS1A #105, MEMBERS1A #106,
Arena CUTSCAR1A (chat 01a127d3-558f-73f4-bc4d-3271a16f79de), DRAWER1 (chat 01a127df-bc95-7292-8bc1-e26b662e1bf6) - Arena cannot push to
ICOON-Studio: copy its files from the diff view (AGENT_TOOLS.md "Arena").

## Rules added (CLAUDE.md s4 + memory)
Restart the ops board / watchdog only via their scheduled tasks (a pythonw restart flashed a cmd window per git call); reuse open browser tabs,
check Chrome first; read the Ludo chat title before every send; confirm a send by the box emptying + "Generating", never by the click.
