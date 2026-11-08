# TASK R11E - QWEN (qwen3-coder) - a shot in the clinch says why it landed

Status: OPEN (S405, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: mechanics row R11, "every random swing gets a readable reason" (ops/research/S400_REVIEW/MECHANICS_DECISION_S402.md), row 8 of docs/SWING_CENSUS.md. Claude read this row against today's code.

## Contract
OWNS: scripts/rules/ClinchRest.gd, scripts/state/LiveRound.gd, tests/clinch_why_test.gd
RED_TEST: tests/clinch_why_test.gd -> CLINCH_WHY failures=0
REGRESSION: clinch_rest_test, clinch_beats_test, plain_words_test, no_pronoun_test, save_load_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py clinch tie up reason`. Operator S398: nothing on screen unless the player can act on it, so the reason names what the player can train or plan around. R11A, R11B and R11D are the same kind of row.

## What would a human do?
A coach sees a fighter tie up and take a dig to the ribs. The next thought is either "that one lives in the clinch, stay out of there" or "the tie was loose, the technique is not there yet". One short clause.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/rules/ClinchRest.gd: `chance(opp_style, opp_rating, technique)` is BASE + the style's bonus + (rating - technique) / 100. `line(c, names)` writes the sentence, and it does not say why the shot landed.
- scripts/state/LiveRound.gd about lines 280-282 compute the roll from `opp` and `vals`. About line 357: `rec["clinch_line"] = ClinchRest.line(cl, names)`. FightNight shows that string, so no screen file changes.

## The rule
1. Add pure `static func why(opp_style: String, opp_rating: float, technique: float) -> String` to ClinchRest.gd. First match wins:
   - `opp_rating - technique >= 10.0`: "more technique keeps that hand quiet".
   - The style's bonus in STYLE is above 0: "a %s works in there", with the style in lower case.
   - Otherwise "".
2. `line(c, names, reason := "")` gains that optional third argument. When the shot landed and `reason` is not "", the sentence ends ": <reason>." instead of ".". A clinch with no shot reads exactly as today. Calling `line` with two arguments returns exactly what it returns today.
3. LiveRound passes `ClinchRest.why(...)`, using the same three values it already passes to `chance`.
4. Every number, chance and rule stays unchanged.

## Do
1. tests/clinch_why_test.gd FIRST (prints `CLINCH_WHY failures=<n>`). Run it on main: it must fail. Cover: each branch of rule 1; the technique reason winning when both apply; `line` with a landed shot, no shot, and two arguments; and a real exchange through LiveRound whose `clinch_line` carries the reason when the shot lands.
2. Make it pass inside OWNS. Check LiveRound.gd's line count first: files stay under 500 lines.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/clinch_why_test.gd -> CLINCH_WHY failures=0`, plus one RESULT line per REGRESSION test.

## The one trap
Do not draw a random number anywhere: one more rng call shifts every later roll in a career. No his/her in the words: no_pronoun_test reads them, and the clauses above are written without them.
