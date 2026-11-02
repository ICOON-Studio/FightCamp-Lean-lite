# TASK FIGHTLINK4A - the post-fight "why" factors and the corner's three lines, as two pure rules modules (boxing)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY the four new files below, touch nothing else.

## Why
Operator S248 (verbatim): "Go - build FIGHTLINK in that order: evasion/chin/accuracy, move mastery, then the profile, fight notes,
corner report and post-fight why." Steps 1-2 are live: punches whiff on the defender's evasion vs the attacker's accuracy, the
chin decides knockdowns, per-punch mastery changes each punch. Step 4 tells the player WHY: three decisive factors after the
fight, three coach lines between rounds. Design: Ludo r116 Part B, verbatim in `research/ludo_rx/LUDO_R116_raw.txt`
(B1 ~:147-262, B2 ~:263-300) and `research/ludo_rx/LUDO_R116_cont_raw.txt` (B2 continued ~:1-230). Read those two files
first: every threshold, formula and wording template below comes from them. Claude wires the modules into the existing
`FightCausation.gd` (post-fight bullets) and `CornerAdvice.gd` (between rounds) afterwards - you only write the modules + tests.

## Files you create (only these)
1. `Godot/scripts/rules/FightWhy.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO scene access, no RNG.
2. `Godot/tests/fight_why_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
   `print("FIGHT_WHY failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.
3. `Godot/scripts/rules/CornerLines.gd` - same rules as file 1.
4. `Godot/tests/corner_lines_test.gd` - same shape, ends with `print("CORNER_LINES failures=%d" % failures)`.

## FightWhy.gd API
Input: plain summaries (Claude builds them from the fight log), one per side, keys (all numbers unless said):
`name` (String), `thrown`, `landed`, `clean`, `glance`, `slipped_by_opp` (his punches the OTHER man made miss), `counters_landed`,
`knockdowns_suffered`, `ko_loss` (bool), `chin`, `evasion`, `accuracy`, `stamina_on_whiffs`, `whiffs`, `gas_round` (int, 0 = never),
`torso_end` (0-100), `body_landed`, `clean_power_landed`. Plus `winner` ("a" / "b").
- `static func candidates(a: Dictionary, b: Dictionary, winner: String) -> Array` - all SEVEN Ludo factors (F_EVASION, F_ACCURACY,
  F_CHIN_KO, F_STAMINA_WHIFF, F_BODY_BREAK, F_CLEAN_POWER, F_VOLUME), each a Dictionary
  `{"id", "title", "impact" (clamped 0-100), "triggered" (bool), "line"}`. Trigger conditions and impact formulas EXACTLY as the B1
  table (LUDO_R116_raw.txt ~:178-186); rates as fractions 0-1 inside the formulas the way the table writes them (e.g. accuracy
  differential x 2.5 uses percentage POINTS - Ludo's example 54.8% vs 20.2% -> 86.5). Lines from the B1 templates (~:188-195) with every
  {TOKEN} filled, percentages to one decimal.
- `static func decisive(a: Dictionary, b: Dictionary, winner: String) -> Array` - EXACTLY three: the triggered factors by impact
  (high first), then - if fewer than three triggered - the untriggered ones by impact. Ties: the table order above.
- Put every threshold in a `const` at the top (Claude will recalibrate them against real bouts - our engine's whiff rate is ~8-15%,
  not Ludo's 45%, so the constants must be easy to change; the test must read the constants, not repeat the literals).

## CornerLines.gd API
Input: one round's summary per side (same keys as above, for the round just fought, plus `stamina_end` 0-100, `head_drop` (condition
points lost this round), `leg_condition` (0-100), `torso_condition`, `body_taken`, `clean_power_taken`, `cut_level` (int),
`jab_thrown`, `jab_landed`, `punch_rows` (Dictionary punch_name -> {"thrown", "landed"}) for the OTHER man's punches at us, and
`most_whiffed_punch` (String) + its `slipped`/`thrown` for the OTHER man).
- `static func lines(us: Dictionary, them: Dictionary) -> Array` - EXACTLY three Dictionaries, slot 1 OPPONENT EXPLOIT, slot 2 OUR RISK,
  slot 3 ENERGY & ECONOMY: `{"slot", "rule_id", "line", "order_id", "order_label"}`. Each slot walks ITS rules in Ludo's priority order
  (B2 Slot 1 ~:291 + cont ~:5-20, Slot 2 cont ~:21-43, Slot 3 cont ~:44-66); first rule whose data check passes wins; the slot's last
  rule (the "solid / maintain" line) is the fallback, so a slot is never empty. `order_id` = the action button's id in UPPER_SNAKE
  (e.g. "EXPLOIT_WHIFF_COUNTERS", "HIGH_SHELL_GUARD", "PUNCH_ON_CONFIRMATION"); `order_label` = the button text without brackets.
  Lines fill every {TOKEN}.
- Thresholds as `const`s at the top, same reason as above.

## The tests (from this contract, not from your code)
- FightWhy: Ludo's three worked examples (B1 ~:196-226) rebuilt as summaries -> `decisive` returns the same three factor ids in the
  same order, and the Example 3 accuracy impact is 86.5 (+-0.1); each factor's trigger flips exactly at its threshold (one test per
  factor, read the const); `decisive` always returns 3 even when nothing triggers; no line contains "{" or "}".
- CornerLines: for each slot, a round that hits the first rule picks it; a round hitting the 2nd but not the 1st picks the 2nd; a quiet
  round gives the fallback in all three slots; the line for Ludo's own example ("His jab is finding air - 9 of 14 slipped") carries
  9 and 14; never fewer or more than 3 lines; no "{" left.
- Mutants: say in the PR body which two thresholds you nudged by 1% and that the test went red.

## Prior research
searched: post-fight why corner report decisive factors (prior_research.py: nothing). Canonical page research/topics/plans_corner.md
(the corner minute, G137 "the corner changes the next round by ~+2"). Existing modules this feeds (do NOT edit): `scripts/FightCausation.gd`
(ranked post-fight bullets, MAX_BULLETS 5), `scripts/CornerAdvice.gd` (one between-round instruction), `scripts/CornerReport.gd`
(the result screen's CORNER tab - a different thing: what the corner DID).

## What would a human do?
A trainer after a fight names the two or three things that decided it with numbers ("he slipped half your jabs"); between rounds he says
one thing about the other man, one about you, one about the gas tank - and gives one instruction for each.

## Prefab check
No library computes boxing post-fight factors; CompuBox publishes the punch categories only. Pure GDScript, no assets.

## Contract
OWNS: Godot/scripts/rules/FightWhy.gd, Godot/tests/fight_why_test.gd, Godot/scripts/rules/CornerLines.gd, Godot/tests/corner_lines_test.gd
RED_TEST: Godot/tests/fight_why_test.gd -> FIGHT_WHY failures=0
REGRESSION: fight_why_test, corner_lines_test
VISUAL: no

## The trap
GDScript `:=` cannot infer a type from a Variant (Dictionary values, `.get(...)`) - type it explicitly (`var x: float = ...`).
Do not delete or weaken a check to go green; CI runs both tests. PR body: `RESULT: tests/fight_why_test.gd -> FIGHT_WHY failures=0`
and `RESULT: tests/corner_lines_test.gd -> CORNER_LINES failures=0`.
