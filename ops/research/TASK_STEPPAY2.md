# TASK STEPPAY2 - phases 2-4 of the steps payoff scope: the place pays, the right step costs less, then the gate

Kind: code
Status: OPEN (S533, Claude main). Owner's yes: Q-S294-285, in chat "Yes, build it". Discipline: boxing. Model: Fable
(claude-fable-5-2), Code Mode terminal session.

## Read first
- `ops/research/STEPS_PAYOFF_SCOPE_S533.md` - the plan (phases 2, 3, 4) and the real-boxing rule it builds.
- `docs/STEPPAY1_RESULT.md` - phase 1 (Grok Dev, on main): no place is an edge today (-3.0..+3.2 against the control, the noise);
  Table 2 lists EVERY rule that reads the place; the opponent's range game (`Exchanges.next_mode` via `RingDuel.settle`
  L385-386) takes no place; `corner` is read by nothing but the plan pick and the words. Its probe `tools/place_value_probe.gd`
  is your instrument and its CONTROL row is the floor.
- `docs/TREEVALUE9_RESULT.md` S533 TREEVALUE11-13: cut_off loses with any effect off, x5, or x5 with no cost.
- CLAUDE.md item 8 (METHOD): no StepEffect TABLE sizing by guess. Sizes come from measurements.

## Build, in order, each measured before the next
2. THE PLACE PAYS. One new pure rule (e.g. `scripts/rules/PlaceEdge.gd` + `tests/place_edge_test.gd`) read in ONE place of the
   exchange odds: an exchange that starts at opp_ropes / corner gives the boxer who put the opponent there a bounded edge, and
   the trapped boxer's range game is taken away (her `next_mode` cannot be "range" / its range moves cannot fire there);
   own_ropes is the mirror (the opponent gets it against your boxer). Size it from STEPPAY1's table, not a guess; corner a bit
   more than opp_ropes. Gate: `place_value_probe` shows opp_ropes/corner above CONTROL and own_ropes below by a bounded amount
   (name it), and the CONTROL arm with the rule off still reproduces the game. Then treevalue: cut_off FOR Out-boxer +1.5..+5.
3. THE STEP SPENDS LESS WHEN IT IS RIGHT. A planned step in its BEST situation (StepEffect.is_best) costs no exchange: it
   happens with the next punch line. In a WRONG situation it costs the exchange as today. Measure again.
4. THE GATE. Re-run the StepValue gate for all 10 steps (`tools/treevalue_probe.gd`, StepValue targets) and write the table.
   Only then size any StepEffect TABLE number still off, each with its measurement.
Each phase: one commit to main, its numbers appended to `docs/TREEVALUE9_RESULT.md` (S533 STEPPAY2 phase n), and a short
`docs/STEPPAY2_PHASE<n>.md` with the gate table the owner will see.

## Owner rulings to keep
- "three in a round on your count = the next exchange is on the ropes" (Q-S294-231) stays the way ropes happen.
- The 3D fight never decides; no change in scripts/fight3d (METHOD: no new correction layer until fight player v2).
- Amateur vs pro differences stay. Game words, no jargon, in any text a player sees.
- New rules ship ON (GameSwitches.GAME_ON) with plain `--script` tests as the OFF control arm where the rule has a switch.

## Other work in this checkout - do NOT edit
- The P4PBUILD1 Fable console owns `scripts/state/LiveRound.gd`, BoutFinish, CardAsk, CoachRead, PlanRecord, RingMap,
  RingTopDown, OfferCard, Interview, RosterActs. If phase 3 truly needs LiveRound, keep the change to a few lines around the
  arrow (L238-239), `git pull --rebase` right before, and say so in the commit message.
- Grok Dev's TIPFIX2 (tooltips in scripts/ui, Tip.gd, TipCards.gd). Pull before each commit.
- You own: scripts/state/RingDuel.gd, scripts/rules/Exchanges.gd, scripts/rules/LineGrade.gd, scripts/rules/PlanFight.gd,
  scripts/rules/StepEffect.gd, scripts/rules/StepWire.gd, scripts/rules/StrikeMap.gd, new PlaceEdge files, tools/place_value_probe.gd,
  tools/treevalue_*.gd, docs/STEPPAY2_*, docs/TREEVALUE9_RESULT.md. Fix `StyleName.plan_mult`'s dead `mid_edge`/`counter_edge`
  read if you touch it (STEPPAY1 "seen, not fixed").

## Rules
- Godot ONLY through `python ops/Tools/godot_slot.py run --who steppay2 -- <godot.exe> --headless --audio-driver Dummy
  --fixed-fps 60 --path . --script res://...` (exe `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe`, never
  `_console.exe`). The watchdog may read RED while the owner plays a game: the slot waits; never bypass it. Probes are long:
  one at a time.
- Small files (no script over 500 lines; RingDuel is 388 - put the rule in its own file). Read ops/research/GDSCRIPT_TRAPS.md.
- Tests: only those your change touches (`TESTS="a_test b_test" JOBS=2 sh tools/run_tests.sh`) + `golden_path_test`; never
  the full suite. Fighters in every measurement differ (never identical); name the population.
- Commit with explicit paths, `git pull --rebase` before push, end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Deliverable
Per phase: the commit, the result doc, a line in roadmap.json `plan` (row STEPPAY2). Final message: per phase one sentence, the
gate numbers, the tests run with their pass lines.

## Contract
OWNS: scripts/rules/LineGrade.gd, scripts/state/LiveRound.gd, scripts/state/StepWire.gd, tests/place_edge_test.gd, tools/place_value_probe.gd (and the other files listed above)
RED_TEST: tests/place_edge_test.gd (phase 2), red on main
REGRESSION: tests/golden_path_test.gd, tests/step_effect_test.gd (plus the tests of every module touched and the plan_fight tests)
VISUAL: no (the ring map already shows places; Claude checks a still after phase 2)

## Prior research
STEPPAY1_RESULT; TREEVALUE2-13; STEPVALUE1 maps; Q-S294-231.
## What would a human do?
A coach knows a boxer pinned on the ropes cannot box at range, so he teaches cutting the ring for what the next exchanges pay.
## Prefab check
None (our own rule).
