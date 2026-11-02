# TASK Q18 — QWEN — FightHudRead: ONE FOLD BETWEEN THE FIGHT AND THE SCREEN

Model: default CLI, high effort, Fast off. Owner: Qwen. Base: `c885c5f`,
`SUITE total=204 fails=0`.

You own `Godot/scripts/FightHudRead.gd` (new) and
`Godot/tests/fight_hud_read_test.gd` (new). **Module AND test — you have a shell
and you run the test yourself.**

---

## Why this module exists

The fight state dictionary is the engine's internal shape: fixed-point
positions, RNG streams, an impact log. A screen that reaches into it couples the
UI to engine internals, and every later engine change breaks the screen. This is
**one pure fold**: state in, everything a broadcast HUD needs out, nothing else.

Two modules it must call are already shipped and are **currently INERT** —
`Cardio.gd` (a heart rate, not a bar) and `FightTrauma.gd` (cuts and swelling in
discrete pips). This module is part of giving them a consumer.

## THE CONTRACT — exact names, exact shapes

An unseen test and an unseen screen are both written against this. Do not rename
a key, do not reorder arguments, do not "improve" a spelling.

```
static func fold(state: Dictionary) -> Dictionary
```

Returns:

```
{
  "round": int,              # live round number, 1-based
  "rounds_total": int,
  "seconds_elapsed": float,
  "resting": bool,
  "over": bool,
  "a": <side read>,
  "b": <side read>,
  "score": {"a": int, "b": int, "rounds_scored": int},
}
```

`score` sums the CONSENSUS card of every closed round (`state["scorecards"]`
entries carry `{"round", "cards", "consensus"}` — use `consensus`). Before any
round has closed it is `{"a": 0, "b": 0, "rounds_scored": 0}`.

`<side read>`:

```
{
  "id": String, "name": String,
  "heart_rate": int,        # roundi(Cardio.from_stamina(stamina, conditioning, age_years))
  "zone": String,           # Cardio.zone(that bpm as float, age_years)
  "stamina": float,
  "condition": {"head_neck": float, "torso_core": float,
                "left_arm": float, "right_arm": float,
                "left_leg": float, "right_leg": float},
  "trauma": {<site>: {"cut": int, "swelling": int}},   # FightTrauma.fresh() shape
  "worst_trauma": {"site": String, "kind": String, "pips": int, "words": String},
  "total_pips": int,
  "knockdowns_round": int, "knockdowns_total": int,
}
```

`worst_trauma` is `FightTrauma.worst(trauma)` plus a `"words"` field from
`FightTrauma.words(pips)`. `total_pips` is `FightTrauma.total_pips(trauma)`.

**Tolerate an absent field, because R87 has not landed yet.** The engine does
not carry `trauma` or `age_years` on a fighter today; R87 (Claude) is adding
both in parallel. So default `trauma` to `FightTrauma.fresh()` and `age_years`
to `28.0` when the key is missing. Your module must work **before and after**
R87, and that is a real requirement, not defensive padding.

`fold` is PURE: it never mutates `state`, and calling it twice on the same state
returns equal dictionaries.

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/FightHudRead.gd` | new | Yours. Statics only. `const` preloads of `Cardio.gd` and `FightTrauma.gd` are fine — you have a shell and run the suite. |
| `Godot/tests/fight_hud_read_test.gd` | new | Yours. Build SYNTHETIC state dictionaries; do not run `FightRealtime` — this is a fold, and a test that boots the engine tests the engine. |

Read whole (both small): `Godot/scripts/Cardio.gd` (122 — `from_stamina` `:83`,
`zone` `:106`), `Godot/scripts/FightTrauma.gd` (158 — `SITES` `:16`, `fresh`
`:22`, `worst` `:64`, `total_pips` `:79`, `words` `:88`).
Read only these anchors of `Godot/scripts/FightRealtime.gd` (940 — **never
whole**) to learn the state shape: `begin` `:181`, `_build_fighter` `:~240`,
`_close_round` `:475`. **Never open `GameState.gd` (12,900+ lines).**

## Gates

1. `fold` never mutates the state handed to it — assert the input is unchanged.
2. Two `fold` calls on one state return equal dictionaries.
3. A state with no `trauma` and no `age_years` still folds, with a fresh face.
4. A state with several closed rounds sums the CONSENSUS cards, not the
   individual judges' cards.
5. Every key in the contract above is present on both sides, always.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightHudRead.gd Godot/tests/fight_hud_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_hud_read_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 205. If it is
higher because a sibling task landed, say so and push.

## The trap specific to this task

**`var x := <call>` fails when the call returns Variant.** `state.get("a", {})`
is Variant, and so is `.size()` on it — write the type: `var side: Dictionary =
state.get("a", {})`. This costs a fix cycle every time it is forgotten. Also:
`FightTrauma.worst` returns a dictionary you must not mutate into your output
without copying, and a shallow `.duplicate()` shares the inner per-site
dictionaries.
