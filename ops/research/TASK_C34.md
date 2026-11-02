# TASK C34 — THE GENERATIONS: THE WORLD AGES, AND REFILLS (Codex)

**Status: ASSIGNED 2026-09-07.** The second stage of THE YEARS.

Model: top tier, effort high, Fast off. One session.

**UNBLOCKED 2026-09-07: `Godot/scripts/Aging.gd` is on `master`.** You
stopped on its absence and you were right to - there is one age curve in this
project and it is not yours to author. It landed as R51a ahead of the pass
that consumes it, precisely so this task could start. Rebase and go.

The statics you call are `birth_week_for(id)`, `has_birthday(id, week)`,
`peak_window(discipline)`, `band_for(age, discipline)`,
`year_step(athlete, new_age)` and `retirement_pressure(athlete, career_week)`;
`Godot/tests/aging_test.gd` (35 checks) is the worked example of each. Two
things worth knowing before you lean on it: **every constant in that file is
authored and UNSOURCED** pending J10, so do not present its numbers to anyone
as fact; and `retirement_pressure` deliberately contributes NOTHING for an
input the athlete dictionary does not carry, rather than defaulting - keep
that property when you feed world athletes to it.

## Why this exists

R51 gives the player's roster a birthday, a decline and a retirement. If the
WORLD does not age with it, the game breaks in the opposite direction: the
player's fighters get old and retire while every opponent, every ranked
contender and every champion stays 24 forever. Worse, `status: "retired"` is
read at `GameState.gd:5519` and `:5691` when picking opponents — a branch
that has been dead since it landed — so the moment anything writes it, the
matchmaker starts skipping people and nothing refills the divisions.

## Owned files

- `Godot/scripts/WorldPopulation.gd` — 1,598 lines. Small enough to read
  whole; read it once.
- `Godot/tests/world_generations_test.gd` — new.

**Do not touch:** `GameState.gd` and `Aging.gd` (R51's, this cycle),
`CareerEpilogue.gd` (G9's), any `*Panel.gd`, any `assets/data/*.json`.

## Anchors in `WorldPopulation.gd`

| line | what |
| --- | --- |
| `104` | `generate(seed_key, player_country, player_city, ...)` |
| `152` | `population["rankings"] = _build_rankings(...)` |
| `369` | `advance_world(population, target_week, target_day)` — the world's own clock, where this belongs |
| `526` | `_generate_athlete(population, gym, culture, profile, athlete_index, rng)` — `"age": rng.randi_range(18, 31)`, `"status": "active"` |
| `595` | `ensure_event_pipeline(population, current_week)` |
| `638` | `_ranked_pairs(population, country, rotation, exclude_ids)` |

## What to build

1. **World athletes age on their own birth week**, through
   `Aging.birth_week_for(id)` and `Aging.year_step(athlete, new_age)` —
   the same call R51 makes for the roster. No second curve, no second table.
2. **They retire.** `Aging.retirement_pressure(athlete, career_week)` over
   the line writes `status = "retired"`, and a retired athlete leaves the
   rankings and the matchmaking pools rather than being deleted — the record
   stays readable, the person stops fighting.
3. **The gyms take in the young.** Each career year, every detailed market
   gains new athletes so a division never thins out. Reuse
   `_generate_athlete` with the existing seeded RNG — deterministic for the
   same seed and week, which the test must prove.
4. **Nobody is generated old.** An intake athlete is at the young end of
   `Aging.peak_window` for their discipline; the world must not paper over
   retirements by spawning 30-year-olds.

## Settled

- **Deterministic.** Same `seed_key` + same week = the same world, exactly
  as `generate()` and `ensure_event_pipeline()` already promise. A test that
  cannot reproduce a world twice has found a bug, not a flake.
- **Pure module rules still apply** to `WorldPopulation.gd`: statics only,
  no node access, no autoload identifier.
- **No outcome change to an existing save's scheduled cards.** Ageing runs
  on the world's own pass; a card already on the calendar keeps its bouts.
- The featured real athletes (`merge_featured_athletes:160`) and the real
  organizations (`merge_real_organizations:212`) are sourced records. A
  featured athlete ages like anyone else but **must not be deleted or
  replaced by a generated one** — their catalog identity survives.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/WorldPopulation.gd
```

## Tests

```
--script tests/world_generations_test.gd
```

Then everything that draws on the world's people:
`promotion_matchmaking_test.gd`, `rankings_api_test.gd`,
`titles_rankings_test.gd`, `sex_matchmaking_test.gd`,
`weight_class_matchmaking_test.gd`, `contender_series_test.gd`,
`tournaments_test.gd`, `featured_real_athletes_test.gd`,
`starter_roster_mix_test.gd`, `world_management_ui_test.gd`. Then the full
suite ONCE in the background before the commit.

## The one trap

`_ranked_pairs` and the event pipeline build cards from the world's athlete
pool. Retire people without removing them from the ranking and pairing pools
and the world will book bouts for fighters who have stopped fighting — the
card looks normal and the fight never makes sense. Prove in the test that a
retired athlete appears in NO scheduled bout after the pass.

## Done

Commit and push `master`, write `research/C34_DIGEST.md` (short), send
one line with `python Tools/agent_comms.py send`, and do NOT edit
`HANDOFF.md` — Claude writes your block.
