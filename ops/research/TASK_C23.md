# TASK C23 — THE POST-FIGHT READ API (Codex)

**Status: OPEN.**

Model: mid tier, effort medium, Fast off.

One read API for everything a finished bout has to say about itself: the
round-by-round cards, the decision, and the range aggregates M3's post-fight
range card needs and nobody has built. This is the surface the judges stage
will fill later; it is NOT that stage, and you decide nothing about judges.

## Why this exists

Two things are true after a bout today and neither is readable:

1. `fight_state["scorecards"]` holds one card per round and the decision
   sums it inline (`FightSimulation.gd:2682-2694`). No caller can ask for
   the card grid without re-deriving it.
2. The range system (R35–R37) writes a band on every logged action and a
   `range_owner` every exchange, but **nothing aggregates it.** Maria's M3
   pack designed a post-fight range card — per-round dominant band and
   whole-bout owner — and named the missing aggregation as the reason it
   cannot bind (`research/M3_RANGE_RAIL_PASS2.md`, "Engine gap").

You build the aggregation and the read. Everything you need is already in
`fight_state`: every logged event carries `round` (set at
`FightSimulation.gd:440`) and every action carries `range_band`
(`:1285-1286`), so **this is derivation, not new simulation.**

## The contract

New pure module `Godot/scripts/PostFightRead.gd`:

```gdscript
static func build(fight_state: Dictionary) -> Dictionary
```

plus a thin wrapper in `GameState.gd` next to the other read APIs:

```gdscript
func get_post_fight_read(fight_state: Dictionary) -> Dictionary
```

Keep the wrapper to a few lines — `GameState.gd` is 8k lines and another
stage may be in it; do not restructure anything around it.

Return:

```
{
  "cards": [ {round, a, b, score_a, score_b, knockdowns_a, knockdowns_b} ],
  "totals": {"a": int, "b": int},
  "decision": {"method": String, "winner_side": String, "scored": bool},
  "range": {
    "rounds": [ {"round": int, "band": String, "share": float, "owner": String} ],
    "bout_band": String,
    "bout_owner": String,
    "owner_share": {"a": float, "b": float},
    "exchanges": int,
    "standing_exchanges": int
  },
  "style": String,
  "complete": bool
}
```

Rules for it:

- **`cards` is an ARRAY and stays one.** Today the engine has exactly one
  omniscient judge, so the array holds one entry per round from
  `fight_state["scorecards"]`. That is the whole point of the shape: when
  the judges stage lands, more cards arrive without the contract changing.
  **Do not invent judges, judge names, per-judge variance or split/majority
  logic.** John's J1 study rules that model and it is not yours to pre-empt.
- **Per-round dominant band** is the most-thrown-from band of the round,
  read off the log's action events; `share` is its fraction of that round's
  banded actions. Ties break toward the band the round ENDED on. A round
  with no banded standing action reports `""` and a share of 0.0, never a
  guessed band.
- **Bout owner** is the side that held `range_owner` across the most
  exchanges; `owner_share` is each side's fraction. Contested exchanges
  with no winner belong to neither and must not be silently credited.
- Ground time is excluded from band aggregation — the engine never consults
  the band on the mat, so counting it would lie. Report
  `standing_exchanges` beside `exchanges` so a caller can say so honestly.
- An unfinished or empty `fight_state` returns the same keys with empty
  values and `complete: false`. Never half a dictionary.
- Pure and stateless, in the shape of the other read modules. No writes to
  `fight_state`, no RNG, no autoload identifier inside the module.

## Owned files

- `Godot/scripts/PostFightRead.gd` (new)
- `Godot/scripts/GameState.gd` (**the wrapper only** — one small function
  beside the other read APIs; anchor `get_ring_read_contract` at `:12399`)
- `Godot/tests/post_fight_read_test.gd` (new)

## Do not touch

`FightSimulation.gd`, `RoundScoring.gd`, `FightRange.gd`, `RangeRail.gd`,
`RingStagePanel.gd`, anything under `Godot/assets/data/`, and `HANDOFF.md`
(Claude writes your block). Changing how a bout is SCORED is out of scope in
both directions: you report what the engine already decided.

## Anchors

- The cards: `FightSimulation.gd` `_close_round` builds and appends at
  `:2543-2578` (append `:2570`); the decision sums them at `:2682-2694`;
  `fight_state["scorecards"]` is initialised at `:358`.
- The scoring style: `fight_state["scoring_profile"]` and
  `RoundScoring.style(profile)` / `uses_initiative(profile)`.
- The log: `fight_state["log"]`, appended at `:445`, every event stamped
  with `round` at `:440`. Action events carry `range_band` and
  `entered_range` (`:1285-1286`); chain events carry `range_from`,
  `range_walk`, `range_to` (`:1482-1484`).
- The band ladder: `FightRange.BANDS` (`FightRange.gd:44`);
  `fight_state["range_band"]` / `["range_owner"]` / `["range_event"]`
  (`:346-348`).
- Read-API precedent to match in shape and comment density:
  `GameState.gd:12399 get_ring_read_contract` (C15) and
  `GameState.gd:8562 get_fight_playback`.
- Who consumes this: `research/M3_RANGE_RAIL_PASS2.md` section D and
  its "Engine gap" note.

## Test

Build a real fight — `FightSimulation.begin_fight` then
`advance_exchange` to a finish or a decision — and assert the read against
the `fight_state` it came from: the card grid matches `scorecards` round for
round, the totals match the decision the sim reached, every per-round band
is one of `FightRange.BANDS` or empty, shares sit in 0..1, owner shares sum
to at most 1.0, and a ground-heavy fight does not report band coverage it
does not have. Include an empty-state case.

```
python Godot/tools/check_scripts.py Godot/scripts/PostFightRead.gd Godot/scripts/GameState.gd Godot/tests/post_fight_read_test.gd
```

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/post_fight_read_test.gd
```

Then `fight_simulation_test.gd`, `fight_scoring_test.gd`, `ring_api_test.gd`
and `smoke_test.gd`, and the full suite once before you push.
