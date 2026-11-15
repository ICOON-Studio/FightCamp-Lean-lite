# S482 digest (2026-11-15)

## Built
- **The Game plan is one chart page** (PLANFLOW1 stage 1, his Q-240 "Yes, build it"). `scripts/ui/PlanChart.gd` extends
  GamePlan (its pick / save / rating / file / test logic; `fighter.arrows` unchanged - no second plan system), drawn parts in
  `scripts/ui/PlanChartShapes.gd`. Bell box = the place lines; a diamond per IF (a situation line) with an arrow to its
  answer; dashed "+ Add an IF" whose list puts the opponent's game and found tells first; the answer list opens under its
  IF with each answer's FireLevel stamp; the opponent's file in a narrow column (`_file_compact`); checks with fixes.
  Golden path `tests/plan_chart_test.gd` walks the four clicks. Stills `docs/mockups/s482/plan_chart*.png` (review board).
- **Your coach rewrites it / Start from last bout** (map P6): `scripts/rules/PlanAuto.gd` + `tests/plan_auto_test.gd`.
- **Defects fixed on the way:** the coach's starter (One-two, Step back, Tie up, Pivot off) was 4 lines a new boxer never
  fires (all under Usable) and the first changed line saved them - `PlanAuto.suggestion` swaps each for a fireable one;
  the file's "Answer it" offered never-firing lines; "1 LINES".
- **Partner edge** (PARTNERPROBE1, Goose #300): Goose's arms each fought different dice (seed included the arm) - paired,
  the night was worth ~0 (close vs loose -0.7). Now `bout.spar_edge` (BoutRules.spar_edge, rounds 1-2) holds the partner,
  `bout.r1_edge` only the flat round; PartnerMatch.EDGE CLOSE 2.5 / PART 1.25 / LOOSE 0 (+3.7 / +5.3 in 100 on seeds
  4801/4802). Table in docs/PARTNERPROBE1_RESULT.md.
- **Women's 70 kg class** (Q-233, Kalli SQ163): Data.DIVISIONS `wlm` + six rivals; Kalli's sentences mapped onto the
  threat/weak words the bout reads (it parses "Fades", "walks in", "body"); clashing first names renamed.

## Collected / failed
- CLASH6 (Qwen) FAIL: never ran its red test; on the hidden desktop the film crashes (signal 11) in GloveClear.clash_pair,
  which writes the PEER skeleton from this skeleton's modifier. Round 2 at the bottom of TASK_CLASH6.md.
- Qwen ran the film windowed WITHOUT hidden_desktop -> a "FightCamp (DEBUG) not responding" window on his monitor ("is game
  crashed ?"). seat_dispatch.prompt_text now says: a --windowed Godot only through the brief's hidden_desktop line.
- Seat answers: ladder v1 John 5/5/6, Dola 7/8/7 -> Kalli v2 (SQ169); club week v9 John 6/6/6, Maria 7/6/6 -> Q-241;
  Maria weight M1 drawing rendered (review board).

## Running
- Qwen MODETELLS1 (mode share bands + tape order; qwen/modetells1). Goose STYLE2 (#302). Kalli SQ169.

## Lessons
- A probe's arms must share dice: check the seed line for anything arm-dependent before reading a delta.
- A probe arm key must be copied into the bout it builds (spar_edge ran three empty arms before that was seen).
- Godot slot + `timeout` inside: Git Bash resolved `timeout` to Windows TIMEOUT.EXE inside godot_slot; put timeout outside.
- The S425 bar note: a stamp that reads LEARNING everywhere was right - check the rule before calling a display wrong.
