# S237 DIGEST (2026-10-17) - collects, the operator's playtest defects, Ziva, the LOOP1 scope call

## Collected / merged
- DAYPLANWIRE1 (Grok Dev, PR #219 closed) 9ff2216b - Morning Day Plan runs the floor day (switch day_plan). First collect RED:
  DayPlanPanel row HBoxContainer unnamed -> "HBoxContainer/CoachedCheck" lookups failed; fixed 1e4a5504; 58 tests green.
- SPARRINGBLOCK1 (Arena, PR #220 closed) af6060a8 - pure SparringBlock.gd + test, 4 tests green.

## In flight at handover
- PACING1 (Arena chat 01a146fb) - K87 decision budget, pure DecisionPacing.gd (operator Q-S235-1 "Approve"). TASK_PACING1.md.
- SPARWIRE1 (Grok Dev) - wire SparringBlock on ring_spar blocks + gameplan glow. TASK_SPARWIRE1.md.
- ROOMS3CD3 (Codex, wt E:/FightCamp/wt/ROOMS3CD) - process EXITED ~03:05 with UNCOMMITTED edits (GymClub3D, ClubRoomBase, 3 tests) +
  new rooms_corridor_strip_test.gd. NOT collected: read the worktree diff + ROOMS3CD_DIGEST, then collect.py.
- Qwen LEDGERREAL1 (wt WALKINPOLICY2).
- Paul review of LOOP1 (pm_bot P12, run 38986089496) and Ludo's LOOP1 answer (Ask Ludo FightCamp chat, sent 03:25) - collect both.

## Operator playtest defects - fixed (c025d2e2)
- "every menu i open it loads": HOME rebuilt the whole 3D gym on every return (6.6-8 s). CareerRoot parks the gym and takes it back
  (0.13-0.17 s); rebuilt only when day/roster/booking changed or a room route opens.
- "the training menu pops up again" / "i cant move mara": guide/story-card changes rebuilt the gym (day restarted). Now money refresh only.
- "i cant get rid of the training menu": Day Plan gets "I'LL RUN THE DAY MYSELF" + Esc, opens once per career day, his own station
  order pauses the plan (PLAN/D resumes).
- Creation: gym-name typing rebuilt the club per key and wiped zone edits -> one rebuild 0.8 s after typing, edits kept.

## Ziva (operator "use ziva to playtest"; Q-S235-2 "Free Hobby plugin first"; "continue with ziva on your hidden desktop from now on")
- Plugin v3.3.0 only in E:/FightCamp/wt/ZIVA; MCP ziva-godot http://127.0.0.1:7012/api/mcp (registered, local scope); Tools/ziva_mcp.py.
  Telemetry OFF. Research ZIVA_RESEARCH_S237.md: run_scene is the Hobby playtest tool (30 s cap per run); turn-by-turn QA + video = Pro;
  no 3D animation tools. Editor STOPPED at handover (operator: "dont start it now, continue on the next session").
- Saves of the Ziva copy go to user://saves_ziva (fightcamp/dev/save_dir) - his slots never touched.
- Fixed from the playtest (ZIVA_PLAYTEST_LOG_S237.md): "1 fighters"; slot board REPLACE; New career froze 9-12 s (club built behind the
  globe) -> 2.3 s; globe over the market list; "1 HUBS"; read-out plate on the city step.
- Club build = 4-5 s per screen (rooms 1.65 s, GymLook2 dressing 1.0-1.65 s, zones 0.65 s; `-- profile_build`). City step still freezes
  ~6.5 s. OPEN on the gym step: grey 3D preview; ADVANCED over OPEN SANDBOX; bottom bar "FLOOR USED 333/45 M2" over another label (card
  says 36/45); Mara's stats cut off; market "Top 5" #1 8-8-0, #5 0-0-0. Ziva trap: key+target -> debugger break; click then keys.

## LOOP1 - operator scope call
Full words + draft keep/off table: research/LOOP1_SCOPE_S237.md. Claude's opinion: agree - a `core_loop` switch preset (nothing
deleted; story, tutorial guide card, random floor events off), build the two missing pieces (goal-with-deadline card, gains/attrition
meters), and make the club build cheap so the loop feels light. Verdict goes on the board after Ludo + Paul answer.
