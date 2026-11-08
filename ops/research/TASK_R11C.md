# TASK R11C - QWEN (qwen3-coder) - a standing count on the cards says what it cost

Status: OPEN (S405, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: mechanics row R11, "every random swing gets a readable reason" (ops/research/S400_REVIEW/MECHANICS_DECISION_S402.md), row 4 of docs/SWING_CENSUS.md. The census's line numbers for this row are stale: FightWhy.gd was rewritten, and this brief is written from today's code.

## Contract
OWNS: scripts/rules/FightWhy.gd, tests/fight_why_counts_test.gd
RED_TEST: tests/fight_why_counts_test.gd -> FIGHT_WHY_COUNTS failures=0
REGRESSION: fight_why_test, plain_words_test, no_pronoun_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py swing reason standing count`. Operator S398: nothing on screen unless the player can act on it. R11A (tests/injury_why_test.gd) and R11B (tests/membership_why_test.gd) are the two rows already done; follow their shape.

## What would a human do?
A coach reading the cards after a points loss says: "We lost it in the second. She took a count there and that round went wide." One short sentence, naming the round.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/state/BoutNight.gd about lines 218-256: each round dictionary carries `r["counts"]` (standing counts that round), `r["down"]` ("a" = the player's boxer, "b" = the opponent, "" = none) and `r["stopped"]` ("" unless the bout ended there).
- scripts/rules/FightWhy.gd `read(rounds, first, opp)` builds `out["plan"]`, `out["against"]`, `out["next"]`. scripts/ui/WhyCard.gd shows those strings, so no screen file changes.
- Today a bout that goes to the cards says nothing about a standing count, although a count widens that round on the cards.

## The rule
1. Add a pure `static func _count_line(rounds: Array, first: String, opp: String) -> String` to FightWhy.gd, and call it once from `read`.
2. If any round has a non-empty `stopped`, return "": the stoppage already explains the bout.
3. Otherwise add up the counts by side, keeping the round numbers (1-based: the round's position in `rounds`).
4. The player's boxer took counts: "%s took a standing count in round 2: that round went wide on the cards." With counts in several rounds: "in rounds 2 and 3". This line is appended to `out["against"]`, with one space before it.
5. Only the opponent took counts: "%s took a standing count in round 2: that round went wide your way." `%s` is the opponent's name. Appended to `out["plan"]`, with one space before it.
6. Both took counts: both lines, each in its own field.
7. No counts: "", and `read` returns exactly what it returns today.
8. Before writing the words, read how a count changes the round's score in BoutNight.gd and Knockdowns.gd. If a count does not widen the round on the cards, stop and say so in the PR body.

## Do
1. tests/fight_why_counts_test.gd FIRST (prints `FIGHT_WHY_COUNTS failures=<n>`). Run it on main: it must fail. Cover: no counts leaves every field unchanged; a count on each side; counts in two rounds; a stopped bout adds nothing.
2. Make it pass inside OWNS. FightWhy.gd is 206 lines; stay under 500.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/fight_why_counts_test.gd -> FIGHT_WHY_COUNTS failures=0`, plus one RESULT line per REGRESSION test.

## The one trap
No his/her in the words: no_pronoun_test reads them. Do not draw a random number: one more rng call shifts every later roll in a career. A round without the `counts` key (an old save, a test bout) counts as zero, so use `int(r.get("counts", 0))`.
