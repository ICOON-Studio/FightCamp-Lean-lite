# TASK ATTRWIRE1 - every attribute reaches the fight: KO leverage, damage mitigation, trauma threshold wired + an end-to-end proof

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo).

## Why (operator S274: "we need to wire all the attributes to the training fighter body/profile and the fight, this is a
## priority for the engine"; his S256 board answer Q-S256-1: "add them all, wire them properly to training and fight")
The 11 attributes (Godot/scripts/rules/Attributes.gd ATTRS) train on the floor (AttributeTraining.CLUB_TO_LUDO, apply_day) and
the bout receives them all (AttributeTraining.fight_stats -> FightRealtime fl_stats -> FightLink.derive_stats). Claude S274
grep audit: of Attributes.derived()'s five numbers, `accuracy` and `evasion` are READ (FightLink miss chance) but
`ko_leverage` (power .70 + technique .30), `damage_mitigation` (guard .65 + composure .20 + technique .15) and
`trauma_threshold` (chin .60 + composure .25 + conditioning .15) are read by NOTHING in FightRealtime.gd / FightLink.gd. So a
boxer who trains power or guard does not hit harder or take less damage through those numbers.

## What to do
1. AUDIT FIRST (report table in the PR body): for each of the 11 attributes, the exact lines where (a) training raises it,
   (b) the bout reads it or a number derived from it, (c) the profile shows it (Godot/scripts/ProfileRevampPanel.gd). Mark
   anything missing. FightRealtime.gd is 10,231 lines - grep -n + sed -n windows only.
2. WIRE the three numbers where the bout already computes the same thing from older stats (find them - damage dealt per landed
   punch, damage taken, knockdown / stagger threshold). Rule: a fighter whose attributes are all 50 must give a BYTE-IDENTICAL
   bout to master (each factor is exactly 1.0 at 50; e.g. mult = 1 + k * (value - 50) / 50 with k from Ludo's section 1 if it
   names one, else the smallest k that moves the A/B outside noise - say which). No new RNG draw. Boxing only.
   Another Arena task (FIGHTLINK2B) edits FightRealtime's PUNCH CHOICE (FightMoves.select weights) at the same time - keep
   your edits to the damage / knockdown code so the two diffs do not overlap.
3. If (1) finds another attribute with no path to the fight, wire it the same way or explain in the PR why it already acts
   (e.g. through a stat of the same name).

## The proof (tests - pure sim, no LFS, CI runs them)
- NEW `Godot/tests/attribute_wiring_e2e_test.gd`, RED on master: for EACH trainable attribute, two DIFFERENT fighters (stats
  differ - CLAUDE.md s5; name the population in the output) are identical except that attribute at 40 vs 75 (the control arm
  shares everything else). Over >= 200 seeded boxing bouts each, the metric that attribute must move moves in the right
  direction outside noise (bounded, never an exact count): hand_speed/technique/fight_iq -> landed %; head_movement/footwork
  -> opponent's landed %; power -> knockdowns dealt + damage dealt; guard -> damage taken; composure -> damage taken under
  pressure / late-round output; conditioning -> late-round output; chin -> knockdowns suffered; recovery -> stamina
  between rounds. An attribute whose metric does not move = FAIL with its numbers.
- A second block: AttributeTraining.apply_day with 300 minutes at each attribute's station raises that attribute (the
  training side of the chain), and chin does not train (innate).
- Regression: mastery_wire_test, fightlink_wire_test, bout_wear_wire_test, attribute_wire_test (if present), plain + as_game.
Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. PR body: the audit table, the A/B numbers per attribute,
`RESULT: tests/attribute_wiring_e2e_test.gd -> ATTR_WIRING failures=0`.

## Owned files
Godot/scripts/FightRealtime.gd (damage / knockdown sites only), Godot/scripts/rules/FightLink.gd, Godot/scripts/rules/Attributes.gd
(only if a factor helper belongs there), Godot/tests/attribute_wiring_e2e_test.gd (new).

## Prior research
Ludo S259 attributes design (section 1 derived numbers, section 2 growth), S260 ATTRIB wiring (e948b77c), S267 recovery
-> recovery_rate (18f63f3e), FIGHTLINK verdicts (S249-S253), LUDO_R_S270_VERDICT item 10 (training must read in the bout).

## What would a human do?
A boxing analyst: take two identical fighters, make one stronger only, have them fight 200 times, and check he wins more
knockdowns - then do the same for every attribute.

## Prefab check
n/a.

## The one trap
Never tune a factor until a test passes by luck of one seed - the A/B runs over hundreds of seeds and reports the margin; an
all-50 fighter's bout stays byte-identical.

## Contract
OWNS: Godot/tests/attribute_wiring_e2e_test.gd, Godot/scripts/rules/FightLink.gd
RED_TEST: Godot/tests/attribute_wiring_e2e_test.gd -> ATTR_WIRING failures=0
REGRESSION: fightlink_wire_test
VISUAL: no

## S276 correction (sent to Arena in its chat)
200 bouts x 11 attributes made a 1-2 h test. The TEST runs 40 seeded bouts per arm per attribute and asserts only the direction
(with a control arm whose |diff| sits under the margin); the >= 200-bout A/B per attribute is `Godot/tools/measure_attribute_reach.gd`
(a tool, not a test) and its table goes in the PR body. Setup cost measured first; catalogue loads may be cached behind a static once
(no behaviour change, determinism hash unchanged).
