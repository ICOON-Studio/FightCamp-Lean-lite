# TASK TIPFIX1 - bring the broken tooltips down: 43 -> 20 or fewer, each rewritten to the house standard

Kind: code
Status: OPEN (S533, Claude main). Discipline: boxing. Model: Grok Dev. Branch `grok/tipfix1`, a PR into main; never merge.

## Why
The owner approved the tooltip standard (Q-S294-282 "Yes, build it"; two critics 7+: Dola 8/8/8, Maria 7/7/6). Build 1 is in:
every tooltip is drawn as the house card, and `tests/tooltip_standard_test.gd` walks the real screens and counts the tooltips
that break the standard. The ratchet `FAULTS_AT_MOST` is 42; today it reads 43 of 168 (one over - find which and fix it first).
The owner's complaint that started this: "your tooltips do not explain things"; "why you repeat the description in the
tooltip ? the tooltip should display explaining information".

## Read first
- `ops/research/GUIDETIPS1_STANDARD.md` sections 2 (the card: WHAT / NOW / WHAT MOVES IT / YOUR MOVE, SHORT vs FULL, limits).
- `scripts/ui/Tip.gd` (the one way to write a card: `Tip.explain`, `Tip.short`, `Tip.button`; `Tip.faults` = the rules the test
  applies), `scripts/ui/TipCards.gd` (worked full cards), `scripts/rules/Glossary.gd`.
- Run the test with `-- list`: it prints each broken tooltip, its screen, its text and its fault (repeat / short / long / line /
  piled / jargon / no_what / keys / name).

## What to do
1. Run `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/tooltip_standard_test.gd -- list`.
2. For each broken tooltip, find where it is set (grep its text) and rewrite it through `Tip.short` / `Tip.explain` so it
   EXPLAINS: what the thing is, why it has this value, what moves it, what the player can do (or SHORT when the player cannot
   act on it). Every number in a card is read from the rule's constant, never typed into the text. No fighter names and no
   "she/her" in card text (say "your boxer", "the opponent"). Plain game words. The meter is called **Fatigue** (owner S533).
3. Lower `FAULTS_AT_MOST` in the test to the new count (it only goes down). Target 20 or fewer.
4. Run the test again and the tests of every screen file you touched.

## Rules
- Do not touch scripts/fight3d (animation session) or StepEffect / RingDuel / tools/treevalue_probe.gd (main session).
- Do not change what a number IS - only how it is explained. If a rule's value looks wrong, write it in the PR body; do not fix it.
- Small files: no script over 500 lines.

## Deliverable
A PR on `grok/tipfix1`. In its body: `RESULT: tests/tooltip_standard_test.gd -> TOOLTIP_STANDARD tooltips=<n> broken=<m>`
plus one line per other test you ran, and a before/after table of 5 rewritten tooltips (text before, text after).

## Contract
OWNS: scripts/ui/ (the files that set the broken tooltips), tests/tooltip_standard_test.gd
RED_TEST: tests/tooltip_standard_test.gd
REGRESSION: tests/tooltip_standard_test.gd, tests/tips_test.gd, tests/tip_notes_test.gd, tests/guide_explore_test.gd
VISUAL: no

## Prior research
GUIDETIPS1_STANDARD.md; J52_TOOLTIPS_AND_TUTORIAL.md; J90_TOOLTIPS_PRAISED.md; GUIDETIPS1_V2_CRITIC_DOLA_MARIA.md (her points
on YOUR MOVE naming a page or button).
## What would a human do?
A UX writer opens each screen, hovers every number, and rewrites each card until a new player could act on it.
## Prefab check
None (our own card helper).
