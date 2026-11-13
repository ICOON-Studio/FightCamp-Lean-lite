# S460 digest (2026-11-13)

## Operator input this session
- Q-S294-219 answered: "Yes: liver = stamina drain + a knockdown chance when hurt, ribs = the injury place (cracked rib, weeks out).
  Design map + critics first" -> ops/research/LIVERRIBS_MAP_S460.md v1; critics SQ77 (Dola), SQ78 (John).
- C385 / C386 on p06e_round2_live: "numbers do not match with holo"; "number is not visible , need to change collour" -> fixed (a2e21f70).
- C387 on office_real (16:20 still): "money is shown on top , maybe show something else here" -> already the Club panel since S459 (20:23 still).

## Built (evidence)
- a2e21f70 LANDED = BodyLive.round_hits (the holos' tally at contact); FightSeam.landed_ex. holo_live_test row (red on the old code: an
  empty beat list counted 0). Lit call card stamina cell + number dark (HudRegroup.Cell.lit). Still: review board 2026-11-13_2152.
- 98916635 INTEGRATE1 #3 PlanPhase: LiveRound pick via PlanFile.arrows_for, last-round pace (PlanFile.pace_for), BoutRead forecast,
  Plan screen rounds pill + "R3 BY THE SCORE" row. phase_wire_test: tagged late 0/0/22 planned exchanges vs untagged 17/9/22.
- 20bd3e74 INTEGRATE1 #7 TraitLine on AttrBoard (code lines only; hover next line + per-point effect). trait_wire_test.
- Tests green: holo_live, round_board, corner_bar, hud_shown, phase_wire, plan_phase, game_plan, plan_screen, bout_read, file_limits,
  golden_path, fight_flow, trait_wire, attr_board, trait_line. Export Builds/FightCamp.exe 21:53.

## Delegated
- GRADE1 (Qwen, qwen/grade1, TASK_GRADE1.md) running. Critic rounds SQ77/SQ78 queued; SQ73-76 still with the seats.

## Not done / next
- INTEGRATE1 #4 Towel first in S461 (TowelWire.gd; BoutNight 487/500), then #5 ProRead, #6 Loyalty, #8 TrainRead, #10-12.
- PRs 259/260 stale (collected S458); gh pr close refused by the permission check.
- POWER1E (animation) not progressed this session.
