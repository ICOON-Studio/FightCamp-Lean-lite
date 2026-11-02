# S198 DIGEST - 2026-10-11 - collect + merge, Ludo round 33, gym fixes

## What now works (merged on master, each test run on master)
- PLAYABLE1 (Codex, 29bcd668): the first-hour boxer career plays end to end through the UI with `-- as_game` and completes a second
  booked bout: amateur bouts use the regional level gate, FIGHT WEEK opens from the schedule, SIM TO RESULT skips broadcast-only
  sampling. playable_loop 9/0 + SECOND BOUT PASS; career 11/0, first_hour/demo_slice/fight_world_live 1/0.
- Body wear by training area (operator's Darkest Dungeon idea), all behind switch `area_wear` (OFF): AreaWear pure (cloud #104, 231/0);
  DayLap.run_day sums it minute by minute (ATTRITION1B, Claude, 12/0, 2 mutants red); saved on the fighter with an 8/night heal and
  shown in FighterReadout regions (ATTRITION1C, Codex, area_wear_persist 10/0, red 4 on master).
- Pure modules (no UI yet): FighterReadout (#105, 81/0, 0-100 scale), Members (#106, 95/0), GymEvents (Qwen, 30/0), CutScar (Arena #103,
  35/0), SkipDay (Qwen, 33/0), FightWeekPhysiology + fight_week_schedule.json in kg (Qwen, 51/0, Claude's 3 mutants red), CampFocus
  (Qwen, 53/0), LastSpar (Arena #108, 220/0), DrawerHost UI (Arena #107, 40/0).
- GYMLOOK2B (Cursor): Ludo palette, props, posters, dust, bag sway behind gym_look2 (props 957 checks). HEADERS1 census (Qwen): 116
  player-visible headers, 97 wired / 11 partial / 8 unwired (research/HEADERS1_CENSUS.md, 7 evidence lines spot-checked).
- Exe builds: Builds/FightCamp_Godot/FightCamp.exe (pck 525 MB) - NOT sent yet (gym repack pending).

## Defects found and fixed
- gym_look2 volumetric fog 0.012 hazed the whole management view and greyed the void -> 0.003 + sky_affect 0 (stills
  docs/previews/gym_look2_s198 vs _off vs s198b).
- GYMFILL1 met its fill gate with 29 focus_mitts_lockers (1.8 m) as filler in strength/stretch/sled zones -> club_fill_test now checks
  zone kind, <= 2 lockers, >= 3 distinct items per strength zone; RED on master on purpose; GYMFILL2 (Cursor) repacks.
- Zone items never used the 14 real prop models (always greybox) -> ClubZoneFloor calls TrainingFloor3D._place_model first (operator
  asked "what are these grey boxes").
- station_info_card_test hung on pass (never quit(0)). fight_realtime_test PASS alone on master (378 checks, 37 s) -> the 10-10 nightly
  hangs were load/worktree.
- Launched an agent at RED twice in this project's history (S192, S198) -> Tools/agent_window.ps1 refuses on RED (exit 3), proven with
  a fake RED/AMBER watchdog; trap: `| Select-Object -First 1` turns $LASTEXITCODE into -1.

## Ludo round 33 (LUDO_ROUND33_S198.txt, verdict LUDO_ROUND33_VERDICT_S198.md)
- Operator asked: Ludo 3D models for the fighters? NO - Ludo outputs unrigged static meshes; "A different mesh will NOT fix these issues";
  fix blending / foot-plant IK / arm limits (ANIM-SMOOTH3 running, ANIMPROOF1 queued).
- Approved (Q-S196-4 "approved with your recommendation"): gym art pass, 11 header mechanics, first-hour order. Q-S196-5 "yes ludos
  camera" (CAMERA2). Q-S196-6 fonts downloaded (Chakra Petch, JetBrains Mono, OFL).
- Ludo reply ceiling measured: ~27-30k chars per reply, stops mid-sentence, no continue marker (rule in CLAUDE.md s8 + memory).
- CORRECTED BY THE OPERATOR mid-session: the readout scale is 0-100 (Q-S196-2 verbatim "use 0-100 for band as ludo says"); the S197
  verdict's 1-20 note is marked overruled; READOUTPANEL1 restarted on 0-100.

## Decisions taken by Claude (developer)
- Merges by diff only; HANDOFF and agent message files excluded. A brief without `## Owned files` fails the gate - added to 3 briefs.
- ANIM-SMOOTH3 = diagnose the layer behind each of SMOOTH2B's 3 spikes before tuning (endpoint clamp, idle pre-switch spike, cross->idle
  remainder). FightStagePlayer.gd is 6,132 lines - structural debt, split queued behind the animation work.

## In flight at handover
Cursor GYMFILL2, Codex ANIM-SMOOTH3 (sol), Qwen MATCHMAKE1A, Arena READOUTPANEL1 + LASTSPARPANEL1 (see roster.json / roadmap now).
