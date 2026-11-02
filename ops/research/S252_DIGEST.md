# S252 DIGEST - 2026-10-18 - FIGHTLINK4A: the post-fight "why" wired, the corner's three lines computed

Model: Opus 5.5. Stage: FIGHTLINK (operator S248: "Go - build FIGHTLINK in that order: evasion/chin/accuracy,
move mastery, then the profile, fight notes, corner report and post-fight why.")

## What now works
- **The result screen says why he won.** `FightCausation.from_read` pushes FightWhy's TRIGGERED decisive factors
  (accuracy chasm, chin collapse, torso attrition, volume, clean-power gap, slip & counter, whiff exhaustion) at
  priority 980/979/978, between the knockdown count (990) and the stop method (960). An untriggered factor is never
  shown. fight_link OFF = no `fl_sides` = bullets unchanged (control arm). a92b359c.
- **The corner's three lines exist at every bell** (CornerLines slot 1 his weakness, slot 2 our leak, slot 3 the
  tank) on `minute[side]["lines"]`, behind the new GAME_ON switch `corner_lines` (boxing + fight_link). dad774db.
  NOT ON SCREEN: the pit-stop reads label is 570x44 and holds two lines; three lines need Ludo's layout first.

## Evidence
- Arena #258 (pure FightWhy + CornerLines + tests) collected by `auto_collect.py --merge` after CI green, 5629f8e3.
- `tests/fight_why_wired_test.gd` red on master (no `fl_sides_from_fight`), green after: summaries equal
  FightBroadcast.round_stats thrown/landed, slips equal whiff events, untriggered factors never shown, OFF arm clean.
- `tests/corner_lines_wired_test.gd`: 3 bouts on the game's boxing ruleset, 3 ordered non-empty lines per side per
  bell, round folds sum to the fight; OFF and no-fight_link arms carry no lines.
- Focused regression 21/21 (game_switches_test needed its engine-switch registry += corner_lines, the S251 convention).

## Decided (Claude as developer)
- **Calibration rule:** each FightWhy factor fires in about the top quarter of our bouts (threshold ~ our p75), a
  p90 bout reads ~85 impact. Measured with `Godot/tools/fight_why_probe.gd` (population probe20: 20 different pairs,
  seeded stats 40-82, 4 boxing plans, DEMO_SWITCHES). Output: AgentComms/fight_why_probe20_cal.txt.
  New consts: evasion 0.11 slip rate + 1 counter (base 0.06, x800, +10/counter); accuracy 10 pp x5.5; chin max 50;
  torso < 60; clean share 0.58 x350; whiff stamina min 5 x10 (silent: our engine's max is 1.45 units).
- **Chin rule changed:** Ludo's "KO OR chin <= 55" fired in 15 of 20 bouts and blamed an 85 chin for every stoppage.
  Now: 2 knockdowns, or a chin <= 50 that went down or was stopped.
- The stamina line drops "entering round 0" when no gas-out round is measured; "clean body hooks" -> "body shots"
  (the count is every landed torso punch).
- One fold for both callers: `rules/FightWhyFold.gd` (pure). Body = torso_core only; jab = id contains "jab".

## Traps found
- **A bare `{"id": "boxing"}` ruleset turns grappling ON**: RoundScoring.profile_for falls back to DEFAULT_WEIGHTS,
  which score takedowns, so `_scores_grappling` is true - the first probe20 had a rear-naked choke "in boxing" and
  0 decisions in 20. The game's ruleset (combat_rulesets.json) scores none: no game defect, but every boxing test
  that builds its own ruleset dict is fighting with grappling on. Probes/tests that measure boxing load the real one.
- `rounds_completed` leaves out the round a stoppage ended in - sum rounds from the log's own `round` field.
- PowerShell here-strings break `git commit -m` on embedded quotes: commit with `-F <file>`.

## Remaining (roadmap now.next_action, S253)
1. Collect Cursor REPGRID1 (issue #257, branch cursor/issue-257; contract fixed) + still on the profile screen.
2. Corner lines on screen: Ludo layout (upload the pit-stop still) -> build -> still; per-round CornerLines recalibration.
3. Camp sharpness +10% (Q-S249-2). 4. Shouts wiring (Q-S249-3). 5. select_mult.

Delegation: Arena's FIGHTLINK4A collected and wired; Cursor REPGRID1 still running. No new seat launched - the
wiring needed this session's trace of the log and corner minute (a brief would have been as long as the code).

## HANDOFF
- last_working_commit: dad774db
- in flight: Cursor REPGRID1 (issue #257)
- next: roadmap now.next_action (S253)
