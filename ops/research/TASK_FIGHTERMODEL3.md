# TASK FIGHTERMODEL3 - CURSOR (GPT-5.6 Sol High) - the fighter model to 8/10 built, rule 2 held again

Status: OPEN (S399, Claude main). The Menus and Money merges this gate waited for are on main (39ca1ac5, 1e737b39).
FIRST: merge origin/main into the branch (Menus, Money, BJJ v2, rank 5 landed since c534d646) and keep every touched test green
before any model change. Sim.gd is also owned by MONEYOD1 (Qwen, lines 300-340): do not edit that window.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.

## Contract
OWNS: scripts/rules/AttrGen.gd, scripts/rules/Attrs.gd, scripts/rules/BoutRead.gd, scripts/rules/BoutRules.gd, scripts/rules/ComboOdds.gd, scripts/rules/Duels.gd, scripts/rules/Exchanges.gd, scripts/rules/Knockdowns.gd, scripts/rules/Matchmaking.gd, scripts/rules/PadWeek.gd, scripts/rules/RoundStyle.gd, scripts/state/BoutNight.gd, scripts/state/LiveRead.gd, scripts/state/LiveRound.gd, scripts/state/ProLadder.gd, scripts/state/Region.gd, scripts/state/RingDuel.gd, scripts/state/Sim.gd, scripts/ui/AttrBoard.gd, scripts/ui/BoutCompare.gd, scripts/world/WorldBout.gd, scripts/world/WorldGen.gd, scripts/world/WorldSim.gd, tests/attr_board_test.gd, tests/balance_harness_test.gd, tests/bout_read_test.gd, tests/fighter_model_bars_test.gd, tests/fighter_model_test.gd, tests/matchmaking_bots_test.gd, tests/world_years_test.gd, tools/fighter_bars.gd, tools/round_reports.gd, scripts/rules/FightWords.gd
RED_TEST: tests/fighter_model_bars_test.gd -> FIGHTER_BARS failures=0
REGRESSION: fighter_model, matchmaking_bots, bout_read, world_years, attr_board, balance_harness, golden_path_test
VISUAL: no
BASE: claude/fighter-profiles-407aee

## Result lines (PR body)
RESULT: rule 2 smart median <x> vs hard <x>; scouting +<n> top-10; stoppage losses blind <x> scouted <x>
RESULT: bar 1 archetype swing <x> points (band 10-15); bars 1,3,4,6,7,8,9,11 <PASS/FAIL each>
RESULT: 6-0-1 pro ranked by week <n>
RESULT: regression <pass/fail per test>
The blind critics (gate 4) are run by Claude on the built branch - do not score your own work.


Branch: `claude/fighter-profiles-407aee` (worktree `E:/FightCamp/Lean/.claude/worktrees/fighter-profiles-407aee`), not
merged. Read first: `ops/research/FIGHTER_MODEL_S397.md` (design v2.1 as built, section 10 measured bars, 12 blind reader)
and `ops/research/FIGHTER_MODEL_REVIEW_S397.md` (every critic round and verdict; the last table is the v3 plan).
Discipline: boxing (demo). Seat: Cursor GPT-5.6 Sol High (S399: free seats build; Claude reviews and merges).

## Merge gate (S398 main session, operator S397 rule 2 "fix scouting first")
1. `tests/matchmaking_bots_test.gd` rule 2 HELD again: smart's median place beats hard's by >= 1; scouting buys >= 5 more
   top-10 finishes than blind; scouting buys fewer stoppage losses (today printed as OPEN - turn them back into `_bar`).
2. Bar 1 in band: at equal measured strength some archetype matchup moves the chance 10-15 points
   (`tests/fighter_model_bars_test.gd` `_open` -> `_check`; bar 11 too).
3. Touched tests green, one Godot job at a time (the main session runs a first-come Godot queue); merge origin/main
   again before reporting; Menus and Money merge first.
4. Two fresh blind critics score the BUILT v3 at 8/10 or more (designer/critic split: a designer seat - Dola/Qwen/agy,
   `ops/research/FREE_DESIGNERS_S397.md` - writes "the 8/10 version" of the duel table; critics never score their own).

## What to build (both built critics, S398; one structural change, measured together)
- Per-place defence answers (`scripts/rules/Duels.gd` TOOLS): long answered by footwork, foot speed, jab (+ reach);
  pocket by guard and head movement; inside by inside work and strength. Guard and head movement out of most other rows.
- Chin and body never decide whether a punch lands: power answer = head movement + guard + ring IQ; body answer = guard +
  inside. Chin/body act after the punch lands: damage, counts (`Knockdowns`), body drain (`Exchanges.BODY_COST`).
- Strength by measurement: the level at which a profile goes even against a reference field (`tools/fighter_bars.gd`
  `archetype_levels_quiet` is the start); first a value-weighted overall (`Attrs.overall` weights = bar 8 field moves),
  shapes and tilts centred on it (`AttrGen._centred`), the table rating and `ProLadder.night` on it. Then restore the
  nonlinearity (best tool ~0.6, knee ~6, convex 0.5) - tuning pass 1 flattened it to fix a level problem.
- The place un-muted: rounds 2+ open where the last ended (or at the better steerer's place); a two-step close on a big
  control gap; ring IQ picks the place that exposes the other's worst answer.
- Flaws drawn mostly from chin, body, engine, guard, footwork (`AttrGen.generate`); a world-path hurt term
  (`WorldBout.fast` / `quick_rows`) so recovery, heart, composure live; fade starts earlier (TIRED_AT 65?) - measure.
- Southpaw edge asymmetric (+1.5 straight for the lefty unless both are); rear-hand words by stance.
- Display: a Defence key on the tale of the tape (`Duels.keys`); `BoutRead.mismatch` on the public profile; flavour lines
  (`FightWords.round_lines`) read the fighter's own place/duel/signature (bar 5: the blind reader saw word-for-word the same
  rounds for two different boxers); `AttrGen.style_word` from the profile; "Work on" (`AttrBoard.glance`) by value.
- Owned now (main session S398): a 66-rated pro went 6-0-1 and stayed unranked - ranks seed by rating at the reviews.
  Decide: wins move the rating (Matchmaking.apply_result GROW_*) or the review seats a winning streak sooner; test it.

## Measure (numbers into FIGHTER_MODEL_S397.md section 10)
`tools/fighter_bars.gd -- quick` (about 4 min): bars 1, 3, 4, 6, 7, 8, 9, 11. `tools/round_reports.gd` + a fresh blind
reader (bar 5). `tests/bout_read_test.gd` (shown odds within 0.06 of real bouts; slow: run alone, timeout 1700).

## Traps found S398
- `Exchanges.next_mode` bias and `BoutRead._games(opp, bias)` must stay in step; BoutRead mirrors RingDuel exactly.
- Calls that steer the place: only long / lead / body / tie (forcing the pocket on every call made right answers cost).
- The world's fast path must stay within ~0.01 of `WorldBout.edges` (fighter_model_test holds 0.06).
- `tests/matchmaking_bots_test.gd` takes ~12 min alone; `run_tests.sh`'s per-test timeout kills it under load.
- Heredocs with `\\"` break the shell hook: write edit scripts to the scratchpad and run them.
