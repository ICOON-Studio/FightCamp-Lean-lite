# TASK C25 — THE SCORECARD READ API (Codex)

**Status: OPEN, UNBLOCKED 2026-09-06. Depends on R38, which is on `master`** — `JudgePanel.gd` and
the `cards` array exist; read the contract below against the real files before
you start.

Model: Sonnet, effort medium, Fast off. This is the C4 / C7 / C19 / C20 / C23 /
C24 pattern for the seventh time: one read, no writes, no UI, honest empties.

## Why this exists

R38 seated three judges. `FightSimulation._close_round()` now appends a `cards`
array to every round dict — one `{judge, a, b}` per judge — and `_finish_fight()`
writes a `decision_type` (`unanimous` / `majority` / `split`, the three draws,
or a plain `decision` for a one-judge ruleset) into the result.

**Nothing can ask for it.** `FightResultPanel.gd:148,317` still reads one card
per round because that is all there was. A screen that wants to say "split
decision, and here is the round judge 2 saw differently" would have to walk
`result.scorecards`, group by judge id, re-sum per judge, work out which rounds
disagreed and translate three scoring styles into one shape — in a scene
script, every time.

One read, the way C23 did it for the post-fight screen. **It never re-scores
anything**: every number it returns is already in `fight_state["result"]`.

## What to build

In `Godot/scripts/GameState.gd`, in the read-API region alongside the other
`get_*_read` functions:

```gdscript
func get_scorecard_read(result: Dictionary) -> Dictionary
```

It takes a fight result dict (the same one `get_post_fight_read` already
takes — see `PostFightRead.gd:17` for how C23 sourced it) and returns:

| Key | Type | Meaning |
|-----|------|---------|
| `style` | String | `ten_point_must` / `points` / `ippon`, from the bout's scoring profile. A boxing card and a judo card come out of the same read. |
| `decision_type` | String | Straight from `result.decision_type`. `""` when the bout did not go to the cards. |
| `decision_label` | String | The line a screen prints: `"Split decision"`, `"Unanimous decision"`, `"Majority draw"`, `"Decision"`. Never invent one for `""` — return `""`. |
| `judge_count` | int | How many judges actually turned in cards. `1` for every federation ruleset and every bout saved before R38. |
| `judges` | Array | One row per judge: `{"id", "label", "total_a", "total_b", "winner_side", "rounds": [{"round", "a", "b"}]}`. `label` is `"Judge 1"` — **never a name**, and never a real official's name (J1 §4.1). |
| `rounds` | Array | One row per round: `{"round", "a", "b", "knockdowns_a", "knockdowns_b", "score_a", "score_b", "split": bool}`. `a`/`b` are the consensus (median) card the engine already stored. `split` is true when the judges did not all card that round the same way. |
| `disagreement_rounds` | Array[int] | The round numbers where `split` is true. Empty for a one-judge bout — never null. |
| `swing_round` | int | The single round that, flipped, would change the decision; `0` when there is none or the bout was not a decision. Computed from the totals that are already there. |
| `is_draw` | bool | |
| `winner_side` | String | `"a"` / `"b"` / `""`. Copied, never re-derived. |

Plus a paired list read if it costs you nothing:

```gdscript
func get_scorecards_read(results: Array) -> Array
```

## Rules

- **Read only.** No writes to `GameState`, no mutation of the dict handed in,
  no RNG, no re-scoring. If a number is not already in the result, it is either
  arithmetic over what is (a sum, a comparison) or it is not returned.
- **Honest empties.** A first-round knockout has no cards: return
  `judges: []`, `rounds: []`, `decision_type: ""`, `decision_label: ""`,
  `swing_round: 0`. Not nulls, not a fake 10-9.
- **Legacy saves are the main case, not an edge case.** Every bout already in
  a player's save has round dicts with **no `cards` key** and a result with no
  `decision_type`. Those must come back as `judge_count: 1`, one judge row
  built from the round `a`/`b` values, `decision_type: "decision"`,
  `disagreement_rounds: []`. Do not retitle them unanimous — that is J1's T7
  and R38 already refused it in the engine.
- **Three styles, one shape.** `points` and `ippon` rounds carry raw points in
  `a`/`b`, not 10-9. Do not normalise them, do not label a judo `3` as a round
  win. `style` is how a screen knows which it is holding.
- No UI. No changes to `FightResultPanel.gd` or any other scene script. M5 is
  drawing this and a later Claude stage spends it.
- No new data file, no edits under `Godot/assets/data/`.
- Do not touch `JudgePanel.gd`, `RoundScoring.gd` or `FightSimulation.gd`. If
  you believe the read needs something the engine does not emit, **stop and
  say so in the mailbox** rather than adding it.

## Anchors

- `Godot/scripts/JudgePanel.gd` — `decision()` returns
  `{winner_side, decision_type, totals}`; `median_card()` explains what the
  round's `a`/`b` are. Read it, do not re-implement it; if the sums you need
  are exactly `decision()`'s, call it.
- `Godot/scripts/FightSimulation.gd` — `_close_round()` appends the round dict
  with its `cards` array; `_finish_fight()` writes `decision_type` into
  `fight_state["result"]` next to `winner_side`, and `result.scorecards` is
  the duplicated array a save holds.
- `Godot/scripts/RoundScoring.gd` — `style()`, and `profile_for()` for
  `judge_count`.
- `Godot/scripts/PostFightRead.gd:17` and `GameState.gd` `get_post_fight_read`
  — C23's shape is the one to mirror, including how it sources the result.
- `Godot/tests/judge_panel_test.gd` — the contracts R38 already froze. Your
  read must agree with them; it must not restate them.

## Owned files

```
Godot/scripts/ScorecardRead.gd        (new, if you follow C23's module split)
Godot/scripts/GameState.gd            (the two accessors only)
Godot/tests/scorecard_read_test.gd    (new)
```

Nothing else. Do not edit `HANDOFF.md`; write your own block only, after the
push, exactly as with C23 and C24.

## Parse gate (before any test run)

```bash
python Godot/tools/check_scripts.py Godot/scripts/ScorecardRead.gd Godot/scripts/GameState.gd
```

## Tests

New `Godot/tests/scorecard_read_test.gd`:

| ID | Assertion |
|----|-----------|
| S1 | A seeded three-judge boxing bout returns `judge_count == 3`, three judge rows, and per-judge totals that sum the same rounds the engine stored |
| S2 | A legacy result (round dicts with no `cards`, result with no `decision_type`) returns one judge, `decision_type == "decision"`, and empty `disagreement_rounds` |
| S3 | A first-round knockout returns honest empties and `swing_round == 0` |
| S4 | A judo bout comes back `style == "ippon"` with raw points in `a`/`b`, not a 10-9 |
| S5 | `disagreement_rounds` names exactly the rounds whose `cards` are not all equal |
| S6 | `swing_round` flips a genuine split and is `0` for a sweep |
| S7 | The read never mutates the result dict it was handed (compare a deep copy before and after) |
| S8 | No judge label anywhere is a real person's name; they are `Judge N` |

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scorecard_read_test.gd
```

Then `judge_panel_test.gd`, `fight_scoring_test.gd` and `post_fight_read_test.gd`
must pass **unchanged**. Full suite once, in the background, before the commit.

---

## UNBLOCK 2026-09-06 (Claude, producer fix) — READ THIS FIRST

You were right: `_finish_fight()`'s result carried the cards and not the style
they were scored under, so `style` could not be answered honestly from a result
alone. Fixed at the producer, not in your read.

`FightSimulation._finish_fight()` now stamps one extra key into
`fight_state["result"]` (`FightSimulation.gd:2775`):

```gdscript
"scoring_style": RoundScoring.style(fight_state.get("scoring_profile", {})),
```

- Key name is **`scoring_style`**, not `style` — a result dict already talks
  about fighters, and `style` there would read as a fighting style. Your read
  still returns it under the key `style`, exactly as the table above says.
- Value is the bare style string: `ten_point_must` / `points` / `ippon`.
- The full `scoring_profile` is deliberately NOT stamped: weights, zones and
  throw bands in every saved bout is save bloat, and the read never re-scores,
  so it needs nothing else from the profile.
- **Legacy saves have no `scoring_style`.** Fall back to `"ten_point_must"` —
  that is what every reader already assumed, so the fallback retitles nothing.
  Do not guess a style from the card values.
- `judge_count` still comes from the cards actually filed, as specced. Nothing
  about the panel is stamped.

The contract is frozen by a test that is already on `master`, in
`Godot/tests/fight_scoring_test.gd` — a boxing result comes back
`ten_point_must`, a judo result `ippon`. **That file is not yours; do not edit
it.** Your S4 can now assert `ippon` against a real judo bout instead of a
guess.

Nothing else changed. `FightSimulation.gd`, `JudgePanel.gd` and
`RoundScoring.gd` stay off your owned-files list. If the read needs anything
further out of the engine, stop and say so in the mailbox again — that call
was correct and cost nothing.
