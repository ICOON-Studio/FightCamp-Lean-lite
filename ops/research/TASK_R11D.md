# TASK R11D - QWEN (qwen3-coder) - when a fighter pushes back, the card says why

Status: OPEN (S405, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: mechanics row R11, "every random swing gets a readable reason" (ops/research/S400_REVIEW/MECHANICS_DECISION_S402.md), row 7 of docs/SWING_CENSUS.md. Claude read this row against today's code.

## Contract
OWNS: scripts/rules/PushBack.gd, scripts/ui/TwistCard.gd, tests/push_back_why_test.gd
RED_TEST: tests/push_back_why_test.gd -> PUSH_BACK_WHY failures=0
REGRESSION: push_back_test, week_twist_test, plain_words_test, no_pronoun_test, save_load_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py push back ask twist reason`. Operator S398: nothing on screen unless the player can act on it, so the reason names something the player can change or plan around. R11A (tests/injury_why_test.gd) and R11B (tests/membership_why_test.gd) are the same kind of row.

## What would a human do?
A fighter says "give me a day off". The coach wants to know where that came from: last week was too hard, or this is just who the fighter is. One short clause.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/rules/PushBack.gd: `reasons(f, days, evs, peak)` lists the asks a fighter has a reason for. `pick(...)` draws one. Nothing records which condition caused the ask.
- scripts/ui/TwistCard.gd about line 41: when `t.get("ask", false)` is true, the card adds the `AskTrust` label (mood and morale) and nothing on why this ask came up.
- The last week's fatigue peak is `f.get("week_peak", 0.0)`.

## The rule
1. Add pure `static func why(id: String, f: Dictionary, peak: float) -> String` to PushBack.gd. It returns one plain clause, and "" for an unknown id. It reads the same conditions and constants as `reasons`, in this order, first match wins:
   - ask_rest: "last week's fatigue peaked at %d".
   - ask_easy: peak >= PEAK_EASY: "last week's fatigue peaked at %d". Otherwise discipline below LOW_DISCIPLINE: "not one for hard mornings".
   - ask_spar: confidence >= HIGH_TRAIT: "confident and wants rounds". Temper >= HIGH_TRAIT: "hot-headed and wants rounds". A habit in SPAR_HABITS: "likes a scrap".
   - ask_road: a habit in ROAD_HABITS: "fades late in fights".
   - ask_bag: a style in BAG_STYLES: "a %s wants the bag", with the style in lower case. A habit in BAG_HABITS: "wants more power work".
2. TwistCard shows it on its own label named `AskWhy`, directly above `AskTrust`, only on an ask card: "Why: last week's fatigue peaked at 78." When `why` returns "", the label is not added.
3. Every number, chance and rule stays unchanged.

## Do
1. tests/push_back_why_test.gd FIRST (prints `PUSH_BACK_WHY failures=<n>`). Run it on main: it must fail. Cover each branch of rule 1, an unknown id, that every ask `reasons` can return gets a non-empty clause for that fighter, and a built TwistCard on an ask week containing `AskWhy` above `AskTrust`.
2. Make it pass inside OWNS. Files stay under 500 lines.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/push_back_why_test.gd -> PUSH_BACK_WHY failures=0`, plus one RESULT line per REGRESSION test.

## The one trap
Do not draw a random number anywhere: one more rng call shifts every later roll in a career. No his/her in the words: no_pronoun_test reads them, and the clauses above are written without them.
