# S528 digest (2026-11-19, Opus)

## Decisions
- Guard posture = the corner's existing Gloves high / Elbows in (S406 Adaptation). GUARDPROBE4 (her aim persists,
  N=2 S=0.25): high guard best in amateurs, switching best in every pro cell. No posture dropdown, no defence tab.
- Footwork steps: METHOD finding (Qwen STEPTUNE2: no TABLE number can pass the gate) -> STEPS_SCOPE_S528. Phase 1: the
  opening passes through a step line; a wrong-fit step lets WRONG_COST 0.2 more punches in. Phase 3: StepValue.TARGET
  follows PlanFight.ANSWERS. Phase 2 = Qwen TREEVALUE5.
- Coach fit: METHOD finding (Arena 5/4 after nine map rounds) -> COACHFIT_SCOPE_S528: a numeric sheet from CoachFit.gd
  (built, called by nothing) joined to four existing levers before any more map rounds.
- The coach takes a day at 76+ tiredness down (WeekCoach.INJURY_HOT) instead of "leave it".

## Evidence
- docs/GUARDPROBE3_RESULT.md, docs/GUARDPROBE4_RESULT.md (200 bouts a cell), docs/STEPTUNE2_RESULT.md.
- Critics: LEDGER1 v2 Dola 8/8, Goose 6/5; v3 Arena 7/6; COACHFIT1 v9 Arena 5/4.
- Render: ops/previews/s528/training_injury_risk.png (review board) - found the coach's "leave it" beside x2.4.
- Tests green: peak_camp, ask_wire, bout_stoppage, training_k, club_week_walk, step_levers, step_effect, step_value,
  step_why, study_pick_walk, week_coach, train_read, week_opp, first_week, golden_path (x3).

## Delegated
Goose LEDGERREV3 (#399, landed), Arena GUARDBLIND1 + LEDGERCRITIC4 (landed) + COACHCRITIC9 (landed), Qwen TREEVALUE5
(running), Dola SQ237/SQ238 critics + SQ235/SQ236 (queued), Ludo injury icon (1.5 credits).
