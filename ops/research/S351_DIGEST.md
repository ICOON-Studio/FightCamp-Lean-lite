# S351 DIGEST (2026-11-02) - update 52: training you plan, the Miro loop board, his Training Blueprint

Lean commit: adede0e (pushed, CI green). Game: roadmap, live runs, board_reconcile fix, TRAINPLAN2_DESIGN, this digest.

## Operator input this session (verbatim)
- Board Q-S294-73 (training board keep/change): "not that good for training," (comment, no option).
- Chat: "can you make a real miro board with the ingame screens from menus/submenus/modals/tooltips , it should help us see
  the big picture loop of what the player should expect".
- Chat picture: "FIGHTER TRAINING BLUEPRINT - combat sports periodization": macro blocks (weeks 1-2 accumulation, 3-5
  integration, 6-8 realization), micro weekly fatigue matrix (high CNS / technical low-impact / high metabolic day),
  logs (AM/PM split, RPE, weight + hydration).

## What now works (evidence)
1. Training you plan (`scripts/rules/TrainingPlan.gd`, 8/8 `training_plan_test`): every session has 0-6 blocks; the
   week's hours split by blocks; cards read real amounts (3-min rounds with a minute's rest, km at 6 min/km, min); a
   piecewise gain curve through the old focus/partner/other points (default week = the old numbers, all 7 foci, to
   1e-6), convex to a third of the week then concave; TOTAL_CAP: no plan builds more in total than the default week.
   Pad blocks set the new move / combo pace (0 = none, up to 2x). Board: - / + blocks per card, the amount in gold,
   Coach's week reset, picture tile per card (icons until pictures land), her own kit (BodyFigure.clay = 0).
   Real route (tools/training_still.gd, hidden desktop): 3 x More on the bag + Less on sparring -> bag 9 -> 33 rounds,
   sparring OFF, power +0.056 -> +0.470 a week, Coach's week button shows. Stills docs/playtest/S351/training/.
   Tests: training_plan, training_week, training_preview, injuries, move_mastery, combos, grey_reason, save_load,
   balance_harness, golden_path PASS.
2. The Miro loop board https://miro.com/app/board/uXjVETf7la4=/ : the loop at a glance (start -> the week ->
   review -> next week; an offer -> camp -> fight night -> result -> back to the week; the left-menu areas), then 9
   chapter strips of the 55 real screens (layout_snapshot on the hidden desktop + 5 S350 3D stills), each with a
   caption card and arrows in click order; plus the TRAINPLAN2 proposal frame. layout_snapshot gained the Playbook
   tabs, Mail, the Gear menu and two tooltips (hover in viewport coords).

## Decided (Claude, the developer)
- His "not that good for training" read as: the board did not let you TRAIN (only pick a main). Rounds per session are
  the training choice; the old focus rule became the coach's default week so balance did not move.
- His blueprint becomes TRAINPLAN2 (research/TRAINPLAN2_DESIGN.md): camp phases BUILD / SHARPEN / PEAK (+ BASE),
  the week as HARD / SKILL / ENGINE / REST days with a high-low rule, effort + weight logs; it feeds today's rounds rule.
  On the board as Q-S294-75 before building.
- TRAINCLIPS1 r4 (Cursor 15c4ace) FAILED the visual gate though its test passed: heavy-bag head cut off, posterised
  blobs, no ink outlines, no start ghosts, the pads picture a smear. Not merged; per the S350 plan it moves to Ziva.
- Gear menu and tooltips draw left of their control on the hidden desktop (its window scaling) - a capture artifact.
- board_reconcile read Lean runs as dead (looked for the worktree in this repo): now it reads the run's own worktree.
- Closed Lean PR #12 (SMOOTH2 r1, superseded by SMOOTH3).

## In flight
- SMOOTH3 r2 (Goose issue 18), CLINCH2 r4 (Goose #14) - fight-stills runs were in progress at wrap-up.

## Next (roadmap now.next_action)
Q-S294-75 + Q-S294-74 -> TRAINPLAN2 step 1 (the week as days); collect SMOOTH3 r2 / CLINCH2 r4; TRAINCLIPS1 to Ziva.

## HANDOFF
- Working commit: Lean adede0e (pushed); Game roadmap/digest commit of S351.
- Exact next action: `git pull && python Tools/agent_comms.py start`, then roadmap now.next_action (1).
