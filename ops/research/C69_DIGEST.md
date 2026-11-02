# C69 — THE GRADE ON THE SCREEN

Owner: Codex. Base `1fad418`.

The Development discipline frame now spends `get_grade_read()` once per
build. A real ladder shows the authored `words`, true `at + 1` of ladder size,
next rung, week count, visible evidence, and the read's fee. The action calls
`award_grade()`, re-reads the athlete, and rebuilds. An absent ladder draws
nothing. `pro_door` names the professional door and never creates an action.

## Fixed-frame measurement

Before the grade block, the mounted worst case (six disciplines, four MMA
blockers, outcome line) reached **y = 355.0**. The pinned footer begins at
**foot_y = 406.0**, leaving 51 px. The grade block derives its height from that
budget, clips its detail row first, and keeps a 4 px footer gap; the probe
measured `grade_bottom = 402.0`. Its caption always prints the true rung and
ladder position. `HowCaption` and all three notes retain non-zero sizes and sit
below the grade block.

## Gates

- Parse: `CHECK total=2 fails=0 autoload_refs=0 time=1s`
- UI: `development_panel_test: 54 checks, 0 failure(s)`
- R89: `GRADE PROGRESSION checks=87 failures=0`
- Full suite at the exact C69 commit, in an isolated initialized worktree:
  `SUITE total=215 fails=0`

The shared checkout's first run was contaminated by concurrent uncommitted
realtime work and reported `SUITE total=216 fails=1`; the isolated run above is
the release gate for C69.
