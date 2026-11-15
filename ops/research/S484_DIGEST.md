# S484 digest (2026-11-15, Claude)

## Collected
- Arena MORNINGS1 (#306): scripts/rules/CoachedMornings.gd + tests/coached_mornings_test.gd; Arena has no Godot, the test was
  run here: COACHED_MORNINGS PASS fails=0. Not wired yet (club week build).
- Qwen FOURMONEY1 (new brief this session): tests/four_money_probe_test.gd, docs/FOURMONEY1_RESULT.md, FOURMONEY PASS fails=0.
  Four stipends: week costs $1,321 -> $2,072; a fresh start on today's $17,200 lasts 9 weeks (3 months for four needs
  $26,900). Dues only - classes (+$350/week) and ticket cuts ($450/bout) are not counted (note added).
- Goose STYLE3 (#305, branch pushed, no PR): tools/style3_probe.gd + docs/STYLE3_RESULT.md merged. Lever table: Slugger
  (knockdown x1.1: read 8, applied 1), Boxer-puncher (mid_edge) and Counter-puncher (counter_edge) are DEAD - their conditions
  are rarely true. The EFFECTS retune was NOT merged: both gates fail (Volume puncher best vs all four) and deltas are inside
  the noise at 20 bouts a cell. -> STYLE4 brief to Kalli (SQ174): one lever per dead style the bout reads most exchanges.

## Failed
- Qwen CLASH6 round 2 (commit 32ac0f42, local branch qwen/clash6-r2, never pushed): seed 4242 08_jab 0.051 m, 09_jab 0.062 m
  (bar: 0 frames > 0.02 m); 01_rear_uppercut +2 frames, 04_lead_uppercut +1; seed 77 08_jab 0.055 m. Two red rounds -> Claude
  code audit next (TASK_CLASH6.md "Round 2 result").

## Built
- TRAINGAME2: docs/mockups/s483/training_k.html carries the game's numbers from tools/training_k_numbers.gd (WeekPlan.full_day,
  PadWeek.drill at 240 drill minutes a night, FireLevel.GAME_SHARES). Mornings +0.06 to +0.17, kg -0.04 to -0.09 on the cut,
  rest -8 tiredness; Check hook 12 -> 20.7 -> 28.2 (1.8 short Friday, Usable Monday of fight week), Body hook 29 -> 35.4;
  Stamina -> Cardio. Finding: "five more minutes" cannot ready a move (~0.03 mastery a minute); the lever is a night.
  Not verified: the tiredness line (needs the carried-in value). ops/research/TRAINGAME2_REAL_NUMBERS_S484.md; review board.

## Queued (seat answers next session)
SQ170 John / SQ171 Dola: ladder v2 critics. SQ172 John / SQ173 Kalli: training K critics. SQ174 Kalli: STYLE4 levers.

## Waiting on the owner
Q-242..245 (club week: pad hours, day job, leaving, loyalty display) - ClubDeal v9 waits on Q-242.
