# S251 digest (2026-10-18) - FIGHTLINK 1b: the week walks into the bout; corner shouts module in

## Operator answers acted on
- Q-S249-2 (board): "build it  and add that : Ludo's "+10% execution speed from camp sharpness"" -> wear + readiness BUILT
  (below). The +10% sharpness speed is NOT live yet: two levers were tried and measured, and neither moved the bout (see Open).
- Q-S249-3 (board): "Build it" -> TASK_SHOUTS1 brief (40e0369f) -> Arena PR #256 -> COLLECTED 80e7c21f (fast lane, CI green,
  guard green, mutants TIER_SHARP / COOLDOWN_S proven red): rules/CornerShouts.gd (12 shouts, learning bars, risky calls,
  25 s rhythm, 4 live reads; no crit lever) + tests/corner_shouts_test.gd.

## What now works (this commit)
- rules/BoutWear.gd (pure, Claude): Ludo r116 Part A as the verdict kept it.
  - Overnight healing by the kind of day: training x0.75-4, light x0.55-10, rest x0.35-18. Light = under 60 training minutes.
  - Ring condition = clamp(100 - 0.75 x wear, 70, 100).
  - Stamina from readiness (100 - strain): Ludo's table, exact.
  - Levers: legs -> evasion, head -> chin, arms -> accuracy. Plus the pre-bell status line.
- Wired behind `bout_wear` (GAME_ON + DEMO_SWITCHES, boxing, needs fight_link):
  - GameState.file_visit heals area_wear by BoutWear.overnight(day_kind). The old flat 8 stays for OFF.
  - skip_morning = a rest night (before S251 a skipped morning healed nothing).
  - FightRealtime.begin scales fl_stats by the region conditions. It sets start stamina and a stamina cap; the cap is held every tick.
- Weekly mastery rust (step 4 leftover), behind `move_mastery`:
  - MasteryTraining.drilled / week_end.
  - GameState records the week's drilled punches on every visit.
  - The week roll decays the undrilled ones (MoveMastery.decay_week, USABLE kept).
- Evidence (tests/bout_wear_wire_test.gd, tests/mastery_week_test.gd, 16 bouts per arm):
  - Worn 70% man: evasion 70 -> 61.6, chin 54 -> 49.1, accuracy 70 -> 64.8. He slips 240 -> 198 punches, is hit 27.5% -> 28.5%,
    and lands 40.4% -> 37.2%.
  - Readiness 50: starts at 83.25 gas, never above 90; throws 1603 vs 1894 fresh.
  - Camp from the gym's own wear table (rest Fri / spar Fri / taper / hard spar Thu+Fri):
    - rest Friday enters 100% everywhere; a sensible taper enters 100%.
    - Friday sparring enters with the head at 95% (the verdict kept today's wear amounts, so one spar costs little).
    - Hard sparring Thursday + Friday enters at 81.9% head (red).
  - Controls: a fresh man ON == OFF byte for byte; OFF ignores wear and strain; rest Friday == no wear.
  - Day loop: a rest morning heals 40 -> 0; a training night x0.75-4 (6.50 = 6.50).
  - Rust: undrilled uppercut 50 -> 49.25, drilled jab kept, OFF writes nothing.

## Open (measured, not shipped)
- Camp sharpness +10% execution speed (operator Q-S249-2): BoutWear.recovery_mult exists, but the two places it was tried did nothing.
  - The commit window: at 20 Hz a throw commits ~5 ticks, so x0.91 rounds back to 5.
  - The `since_s` clock in _throw_context: 1894 = 1894 throws.
  - Next: trace what actually gates the throw rate (FightMoves.throw_share inputs) and apply sharpness there, red test first.
- select_mult (sharper punch chosen more): Moves.select's boxing path picks the ROLE first. A per-punch weight inside the role moved
  the jab share 25.4% (M15) / 27.9% (M90) / 29.0% (M45), i.e. noise. Next: weight the role stage, or drop select_mult (MoveMastery
  already changes the punch itself).

## Agents
- Arena FIGHTLINK4A: the S250 chat (01a14cda) never answered and pushed no branch -> relaunched in a new chat
  https://arena.ai/agent/01a14d0c-d8e2-7c0d-8096-90084efebe8c (branch arena/4efebe8c-fightcamp), RUNNING.
- Cursor REPGRID1 (FIGHTLINK step 3, profile punch mastery badge + inspector line): issue #257, TASK_REPGRID1.md, RUNNING.
- Arena SHOUTS1: collected (above).

## Decisions taken (developer calls)
- Camp sharpness = athlete `gameplan_readiness` (sparring against the booked style). It is the only "tactical familiarity" number
  the gym keeps, and nothing in the bout read it.
- Readiness R = 100 - day strain. The strain is the CNS load the gym already tracks; Ludo defines R from CNS strain.
- Two unproven levers were taken OUT before the commit, not left in: a lever that does nothing is a lie on the switch list.
