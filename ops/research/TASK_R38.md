# TASK R38 — THE JUDGES: THREE CARDS, AND ONE SCORING PATH (Claude)

**Status: OPEN.**

Model: Opus, effort high, Fast off.

This is **P0 of the RULES AND JUDGES arc**, cut from J1's decisions page
(`research/J1_ORGANIZATION_RULES_AND_JUDGES.md`, D2 and D4). It is the
engine half. The org→ruleset binding half (D1) is **R39** and is not in this
stage; nothing here needs it, and R39 needs this.

## Why this exists

The game has one omniscient judge. `FightSimulation.gd` `_close_round()`
appends **one** scorecard per round and `_finish_fight()` sums that single
card, so the sim can never produce a split or a majority — even though the
UI already prints the words (`ProfileRevampPanel.gd:33`, `FightLog.gd:123-127`).
J1's D2 rules that the fix is N judges → an array of cards.

There is a second problem J1 did not catch, and it has to be fixed first or
the panel is built on sand. **Boxing is scored twice.** `_close_round()` calls
`RoundScoring.card()` and then, at `:2563-2574`, throws part of that card away
under a hardcoded `if is_boxing:` branch that re-derives the round from
knockdowns and floors it at 10-7 via `BOXING_MIN_ROUND_SCORE`. So:

- `RoundScoring.gd` is not actually the scoring authority it is documented to
  be — one discipline's knockdown rule lives in the simulation instead.
- A `JudgePanel` that wraps `RoundScoring.card()` (J1 §3.2, steps 1-5) would
  produce three boxing cards that all **skip** the knockdown rule, or would
  have the sim apply it identically to all three afterwards — and knockdowns
  are exactly the thing boxing judges are supposed to be able to weigh
  differently.

One scoring path, then three judges on it.

---

## Stage 1 — one scoring path (the boxing fix)

Move the knockdown rule out of the simulation and into the profile, so
`RoundScoring.card()` is the only thing that turns points into a card.

**`RoundScoring.gd` — `profile_for()`** (`:27-52`): read two more keys off
`scoring_profile`, defaulted so no existing ruleset moves.

| Key | Type | Default | Meaning |
|-----|------|---------|---------|
| `knockdown_round_penalty` | int | `0` | points off the loser's round per knockdown of edge |
| `min_round_score` | int | `8` | floor for the loser's round score |

**`RoundScoring.gd` — `card()`** (`:76-86`): widen the signature with an
optional detail dict so every existing 3-arg call site and test is untouched.

```gdscript
static func card(profile: Dictionary, points_a: float, points_b: float, detail := {}) -> Dictionary:
```

`detail` may carry `knockdowns_a`, `knockdowns_b`, `damage_a`, `damage_b`.
After the existing margin mapping, when `knockdown_round_penalty > 0` and the
knockdown counts differ, apply the same arithmetic the sim does today: the
side with more knockdowns is set to 10, the other is
`maxi(min_round_score, other - knockdown_round_penalty * edge)`.

**`combat_rulesets.json`** — add to `boxing.scoring_profile` only:
`"knockdown_round_penalty": 1, "min_round_score": 7`. Every other ruleset
keeps the defaults (`0` / `8`), which is what they do today.

**`FightSimulation.gd`** — delete the `if is_boxing:` scoring branch at
`:2563-2574` and the two constants `BOXING_KNOCKDOWN_ROUND_PENALTY` (`:309`)
and `BOXING_MIN_ROUND_SCORE` (`:310`). **Keep** the local `is_boxing` at
`:2542` — it is used again at `:2633` for the doctor stoppage — and keep
`BOXING_RULESET_ID` (`:248`), used at `:705`, `:2146`, `:2202`, `:2339`, `:2827`.

**The invariant this must not break:** `fight_scoring_test.gd:58-62` asserts
that in every boxing card one side holds exactly 10 and the other is in
`[10, 9, 8, 7]`. The move is a refactor — cards for a fixed seed must come out
byte-identical.

---

## Stage 2 — `JudgePanel.gd` (new, pure, stateless)

New file `Godot/scripts/JudgePanel.gd`, in the shape of `RoundScoring.gd`:
`extends RefCounted`, static functions only, no node access, no RNG of its own.

```
Judge { id: String, bias: String, weight_delta: Dictionary }
```

- `panel(profile: Dictionary, rng: RandomNumberGenerator) -> Array` — builds
  `judge_count` judges once. Bias tags are drawn from `["striker_eye",
  "grappler_eye", "center_control"]`; each judge's `weight_delta` is a
  multiplier per **secondary** weight only (`volume`, `control`, `takedowns`,
  `positions`, `submissions`, and the `zones`) of `1.0 + rng.randfn(0.0, judge_sigma)`,
  plus a fixed nudge from the bias tag (`striker_eye` up-weights `volume`,
  `grappler_eye` up-weights `control` and `positions`, `center_control` is
  neutral in P0 and becomes the `area_control` reader in a later phase).
  **`damage` and `knockdowns` are never perturbed** — J1 §3.2: primary ABC
  damage has to agree often, or the panel is a coin flip.
- `judge_profile(profile: Dictionary, judge: Dictionary) -> Dictionary` — a
  copy of the profile with the delta applied. Pure.
- `score_round(profile, judges, fighter_a, fighter_b, detail) -> Array` — one
  `{judge, a, b}` per judge, each produced by
  `RoundScoring.round_points()` + `RoundScoring.card()` on that judge's
  profile. **All judges read the same counters**; they do not re-simulate.
- `decision(scorecards: Array) -> Dictionary` — `{winner_side, decision_type,
  totals}` from the per-judge sums, per the table in Stage 4.

**Two new profile keys** in `profile_for()`:

| Key | Type | Default | Notes |
|-----|------|---------|-------|
| `judge_count` | int | `3` when `style == "ten_point_must"`, else `1` | |
| `judge_sigma` | float | `0.06` | `0.0` makes all judges identical |

That default is the whole regression story: **only the four ten-point-must
disciplines get a panel in this stage.** Judo, BJJ, taekwondo, karate, sambo
and both wrestlings resolve to `judge_count == 1` and must produce
byte-identical cards to today. Their real officiating (advantages, yuko, PSS)
is P5, not here.

**Determinism.** Build the panel once in `begin_fight()` (`:326-376`) from a
**dedicated** `RandomNumberGenerator` seeded off the bout seed — store it as
`fight_state["_judge_rng"]` next to `_rng` at `:376`. Do **not** draw judge
noise from `fight_state["_rng"]`: that stream drives every exchange, and
pulling extra numbers out of it would shift every seeded fight outcome in the
game. With a separate generator the exchange stream stays byte-identical and
only the cards change. Judging after that point is pure arithmetic — no RNG
call inside `_close_round()`.

---

## Stage 3 — the card shape (additive; do not break six consumers)

J1 §3.2 proposes appending an array in place of the dict. **Do not.**
`scorecards` is read by `ContenderSeries.gd:102,135-138`,
`FightResultPanel.gd:148,317`, `GameState.gd:9945,9951`, `PlanCoach.gd:101`,
`PostFightRead.gd:17` and a dozen tests, all of which index `card["a"]` /
`card["b"]` per round. Replacing the dict breaks every one of them for no gain.

Keep the round dict at `:2576-2584` exactly as it is and **add one key**:

```gdscript
"cards": [{"judge": "judge_1", "a": 10, "b": 9}, ...]
```

`a` and `b` on the round dict become the **median** judge's card (with
`judge_count == 1`, the only card — so nothing moves for the federations, and
nothing moves for a fixed-seed boxing bout with `judge_sigma` at 0). Every
existing consumer keeps working unchanged and now reads the consensus round,
which is the right thing for a round summary, a sweep check
(`ContenderSeries._won_every_round`) and the coach's read (`PlanCoach`).

---

## Stage 4 — the decision

`_finish_fight()` (`:2688-2701`) currently sums `card["a"]` across rounds.
Replace with: if the round dicts carry `cards`, delegate to
`JudgePanel.decision()`, which sums **per judge** and types the result.

| Per-judge winners | `decision_type` |
|-------------------|-----------------|
| 3-0 | `unanimous` |
| 2-0 with one level card | `majority` |
| 2-1 | `split` |
| 0-0 (all level) | `unanimous_draw` |
| 1-0 with two level | `majority_draw` |
| 1-1 with one level | `split_draw` |

`judge_count == 1` returns `decision_type = "decision"` — **not**
`"unanimous"`. J1's T7: a one-judge bout, and every bout already in a player's
save, must not be retroactively printed as a unanimous decision.

**The fallback is load-bearing and also a test requirement.** When a round
dict has no `cards` key, fall back to the current sum verbatim. Legacy saves
need it, and `fight_scoring_test.gd:99` and `:104` inject bare
`[{"round": 1, "a": 4, "b": 4}]` straight into `fight_state` and call
`_finish_fight()` — the senshu and no-senshu-in-boxing assertions must still
pass untouched. Keep the `RoundScoring.uses_initiative()` senshu branch at
`:2698` where it is; it runs after the totals, whichever path produced them.

Write `decision_type` into `fight_state["result"]` alongside `winner_side`.
Do not touch the UI in this stage — R39 or a later Kalli/Maria stage spends it.

---

## Stage 5 — the ABC 2025 gates on the MMA profile

Two profile keys, both off by default, both set on `mma` only.

**`ten_eight_requires_damage`** (bool, default `false`). Today a 10-8 is a
pure margin call: `margin_wide` is 6.0 and a takedown is worth 3.0, so two
takedowns and some control produce a 10-8 with **zero** damage. The 2025 ABC
clarification says positional control alone does not earn a 10-8. When this
key is true, `card()` may only widen to 8 if the winner also leads on damage —
add a small pure helper `RoundScoring.damage_points(profile, fighter)`
returning `weights.damage * striking_score + weights.knockdowns * knockdowns_round`,
pass both sides in via `detail`, and require the winner's lead to clear a new
`ten_eight_damage_bar` (float, default `0.0`) or hold a knockdown edge.
Otherwise the round is 10-9.

**`even_round`** (`"allowed"` | `"discouraged"`, default `"allowed"`). On
`"discouraged"`, an exactly-level round resolves to 10-9 for the side that
leads on **that judge's** primary metric (`striker_eye` → damage,
`grappler_eye` → control), and stays 10-10 only when that is level too. No
RNG, no coin flip — this is why the bias tag exists.

Set `mma.scoring_profile` to `"ten_eight_requires_damage": true`,
`"even_round": "discouraged"`. Leave boxing, kickboxing and muay thai on the
defaults: their 10-8 conventions are GLORY/RWS/stadium work, which is P3/P4.

---

## What NOT to do

- **No org→ruleset binding.** No new data file, no `default_ruleset_id`, no
  edits to `real_organizations.json`. That is R39.
- No ONE whole-bout style, no RIZIN legality, no GLORY N=5 or open scoring, no
  federation advantages/yuko/PSS. J1 P1-P5.
- No named judges, no judge persistence across a career, no reputation. J1 §4.1
  is explicit: no real officials' names anywhere, including test fixtures.
- No `aggressiveness` / `area_control` weights and no `range_owner` feed. J1 D6
  gates those behind an even Plan A and they need the criteria-priority gate
  that does not exist yet.
- No UI. `FightResultPanel` renders whatever `scorecards` holds; do not add a
  three-card layout in this stage.
- Do not change any live `scoring_profile` **number** except the two additive
  boxing keys and the two additive mma gates.

---

## Anchors

- The single card: `Godot/scripts/FightSimulation.gd` `_close_round()`
  `:2538-2584`; the append is `:2576`; the boxing branch to remove is
  `:2563-2574`; the constants are `:309-310`.
- The decision: `_finish_fight()` `:2688-2701`; the senshu branch `:2698`;
  the result dict `:2718-2733`.
- Fight state construction: `:326-376` (`_rng` at `:376`,
  `"scoring_profile": RoundScoring.profile_for(ruleset)` at `:372`,
  `"scorecards": []` at `:358`).
- The judge that exists: `Godot/scripts/RoundScoring.gd` — whole file, ~120
  lines, pure. `profile_for` `:27`, `round_points` `:54`, `card` `:76`.
- Consumers that must not break: `ContenderSeries.gd:102,135`,
  `FightResultPanel.gd:148,317`, `GameState.gd:9945,9951`, `PlanCoach.gd:101`,
  `PostFightRead.gd:17`.
- Data: `Godot/assets/data/combat_rulesets.json` — `boxing.scoring_profile`
  and `mma.scoring_profile`.
- The ruling this implements: `research/J1_ORGANIZATION_RULES_AND_JUDGES.md`
  decisions D2, D3, D4, and the test contracts T1-T7 in its §4.4.

## Owned files

```
Godot/scripts/JudgePanel.gd          (new)
Godot/scripts/RoundScoring.gd
Godot/scripts/FightSimulation.gd     (_close_round, _finish_fight, begin_fight, :309-310 only)
Godot/assets/data/combat_rulesets.json  (boxing + mma scoring_profile keys only)
Godot/tests/judge_panel_test.gd      (new)
```

Nothing else. No `HANDOFF.md` rewrite beyond this stage's own block.

## Parse gate (before any test run)

```bash
python Godot/tools/check_scripts.py Godot/scripts/JudgePanel.gd Godot/scripts/RoundScoring.gd Godot/scripts/FightSimulation.gd
```

## Tests

New `Godot/tests/judge_panel_test.gd`, asserting J1's contracts:

| ID | Assertion |
|----|-----------|
| T1 | `RoundScoring.card()` stays deterministic and pure for a fixed profile + points; the 3-arg call still returns the historic 10-8 at a 6.0 margin |
| T2 | `judge_sigma = 0.0`, N=3 → all three cards equal the single card the sim produced before this stage |
| T3 | `judge_sigma > 0` on a fixture bout can emit `split` and `majority`; `judge_count == 1` emits `decision`, never `unanimous` |
| T4 | Boxing refactor: a seeded bout's cards are byte-identical to the pre-R38 run, and one side still holds exactly 10 (the `fight_scoring_test.gd:58` invariant), including the two-knockdown 10-7 |
| T5 | `mma`: high `control` + `takedowns` with **zero** damage and no knockdown does **not** produce a 10-8 |
| T6 | `mma`: damage alone **can** produce a 10-8 without a knockdown |
| T7 | A round dict with no `cards` key still scores through `_finish_fight()` (legacy saves; the senshu fixtures at `fight_scoring_test.gd:99,104`) |
| T8 | Federations unchanged: judo / bjj / taekwondo / wrestling produce `judge_count == 1` and byte-identical seeded cards |
| T9 | No fixture in this file contains a real judge's name |

One test:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
```

Then the systems this touches, before the full suite:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_scoring_test.gd
```

`fight_scoring_test.gd`, `fight_simulation_test.gd`, `contender_series_test.gd`,
`fight_camp_test.gd` and `fight_plans_test.gd` must all pass **unchanged** —
if any of them needs editing, the additive contract in Stage 3 or the fallback
in Stage 4 has been broken. Full suite once, in the background, before the
commit.
