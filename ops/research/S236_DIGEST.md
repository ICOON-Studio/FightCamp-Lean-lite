# S236 DIGEST (2026-10-17) - floor wiring collected, Day Plan rules in, rooms round 2 refused

## What now works (on master, pushed)
- FLOORWIRE1 (Grok Dev, 30ff15ee): Corner Rehearsal (PUSH/SWAP/ICE at every 60-min block end), the weekly Load Ledger (every block spends,
  over budget forces a niggle, the week rolls in GameState.advance_week) and ONE decision card for every floor decision (FIFO, the clock holds).
  Switches load_ledger / corner_rehearsal / decision_card in GAME_ON. collect.py ran 93 floor/club tests: 92 green, 1 red was a master defect.
- FloorDecisionCard (Ludo) called get_viewport_rect() outside the tree -> engine error in floor_decision_card_test on master; fixed (e5d95faa).
- LEDGERREAL1 (Qwen, 22b0aa64): Load Ledger station rates scaled to John's J62 real camp loads (peak week 140 -> ~85; heavy bag 9 -> 5/h,
  spar 14 -> 7.5/h). Qwen reported the old test's exact numbers locked the old rates; Claude updated load_ledger_test to the new rates
  (benchmark rule: real-world wins) and made its over-100 forecast a real 4-block overload day. 5 ledger/floor tests green.
- PARTNERPOOL1 (Arena PR #217, 03036b82): sparring-partner picker (safety first, mirror/level/cheapest). Arena CI green, guard 0.
- DAYPLAN (Dola DOLA_DAYPLAN1 + Ludo r101 panel, e5d95faa): rules/DayPlan.gd + DayPlanBoard.gd + 2 tests. Claude fixed 4 bugs (TYPE_REAL,
  `mod()` + minutes always :00, audible() clock from 06:00 vs day minute 0 so a past block was never refused, warn at 2 spars per the brief)
  and test fixtures (over-capacity fixture was not over; control arm added). DayPlanPanel now reads the 240-min coach (was hard 180).
- Research saved verbatim: J63_REFERENCE_JABS_REPLY.md (John: Ludo's 3 fights' facts right, his timestamps unconfirmed - a person must scrub
  them; the "retraction faster" claim is backwards; no source for the 15 ms heel drop; CMU subject 144 left punches = free jab mocap),
  K87_DECISION_PACING_REPLY.md (Kalli), M45_DOORS_CUTAWAY_REPLY.md (Maria), DOLA_DAYPLAN1_REPLY.md.

## Refused
- ROOMS3CD2 (Codex): stills fix the operator's marks (near walls cut to stubs = Maria M45, framed open doors, cabinet/CRT face the room, stool
  and bin apart, HUD hidden in rooms) BUT 4 tests green on master go red on the branch: equipment_store_props (door leaf seals routes),
  reception_club_props (street to hall 0 m, info plate), gym_floor_view (hall front wall not cut to a stub), room_info_hud (plate).
  Codex's own gate list was too narrow. The dark corridor strip measures 0.28 (physio) / 0.63 (reception) of the room floor vs Maria's ~0.8.
  -> ROOMS3CD3 running (Codex, pid 32976): regressions first, then the strip (#8C8780) and the door over the RECEPTION label.

## Decisions (Claude, developer)
- Load costs follow real camp loads; tests that pin constants move with a benchmarked change, never the other way.
- Dola's code is integrated only after review: 4 bugs here would have shipped as a parse error and a planner that never refuses a past block.
- Sparring wiring is split: Arena builds the pure SparringBlock combinator (no GymHall3D edits) while Grok Dev wires the Day Plan, so two seats
  never write the same file.

## Running (yours to collect next session)
- DAYPLANWIRE1 - Grok Dev (gbot dev), PR from grok/dayplanwire1. Brief TASK_DAYPLANWIRE1.md.
- SPARBLOCK1 - Arena chat 01a146e1 (arena.ai/agent/01a146e1-148a-784a-90d4-7c577bbee27a). Brief TASK_SPARBLOCK1.md.
- ROOMS3CD3 - Codex PC pid 32976, wt E:/FightCamp/wt/ROOMS3CD. Brief TASK_ROOMS3CD3.md. Collect with collect.py (all ~50 related tests).
- CURSOR201_R4 (from S235, on the board) - check its issue/branch.

## Waiting on the operator
- Q-S235-1 on the board: K87 floor decision pacing (6 cards a day, 2 an hour, coach decides the rest) - VERDICT_K87_FLOOR_DECISION_PACING.md.

## Next (decision)
Collect DAYPLANWIRE1 -> SPARBLOCK1 -> ROOMS3CD3 (then post the room stills for his OK); brief Grok Dev to wire SparringBlock on ring_spar blocks
(+ GameplanReadiness glow); build K87 pacing once he approves; then GYMLIFE floor stills on the game camera for his OK. Jab: a human must scrub
Ludo's 3 timestamps (J63) before ANIMSOURCE1; try CMU subject 144 left punches as the free reference.

## HANDOFF
Working commit: master 12e2cf74 (+ this digest). Evidence: collect logs AgentComms/collect_floorwire1.log, collect_rooms3cd2.log; test lines above.
