# TASK R59 — CLAUDE — THE INJURY IN THE SAVE

Model: Opus, effort **high**, Fast off. One session, one stage.

**Consumes Q2** (Qwen's `Injury.gd`). If Q2 has landed, splice it and build on
it. If Q2 has not landed when this task starts, write the module yourself from
`research/TASK_Q2.md` — that file is a complete spec — and say so in the
digest. Do not stall this stage on a relay agent.

**Ordering: land after U8.** Cursor's U8 edits `GameState.gd` at `:12300-12430`
only (`get_fighter_card`). Your seams are `:7550`, `:7654-7800`, `:11400-11470`
and `:11760-11830` — disjoint, so a rebase is clean. Commit your own paths and
rebase; **never a bare `git stash`** in this shared checkout.

## Why this exists

J13 (landed 2026-09-08) ruled that a region must carry **a number and, when
tissue is actually injured, a named injury that owns the timeline** (DA1). The
game has the number and nothing else, and the seams show exactly how much that
costs:

- `BodyReadiness.gd:259` and `:327` write the hold's reason as a synthesized
  string, `"%s after %s" % [profile_id, method]` — a damage *profile* id and a
  finish method, not a diagnosis.
- `GameState.gd:7732 _body_hold_read()` cannot say WHERE the hold is, so it
  walks `fight_history` to guess the region (`_body_hold_region`, `:7748`) and
  honestly reports `region_known: false` when the record cannot say. C37 ruled
  that "not known" is the right answer there. **That fallback stays.** What is
  wrong is that there was never anything to know in the first place.
- `GameState.gd:11826` renders the hold by string-mangling that same reason:
  `.replace("_nonloss", "").replace("_", " ").to_upper()`.

So a torn knee ligament, a broken hand and a bruised thigh are all "a lower
number plus a mangled string". This stage gives the body a name.

## Owned files

Nobody else is in these this cycle.

- `Godot/scripts/BodyReadiness.gd` — 433 lines, read whole. Anchors:
  `migrate_athlete:16` (the `body_state` shape, `CURRENT_VERSION:8`),
  `region_ids:52`, `get_regions:57`, `evaluate_competition_clearance:143`
  (the hold read at `:153-158`), `apply_fight_damage:214` (hold write `:257`,
  reason `:259`), `apply_real_fight_damage:282` (hold write `:325`, reason
  `:327`), `forecast_weeks_to_training:341`.
- `Godot/scripts/GameState.gd` — **13,774 lines, NEVER open it whole.** Read
  only `sed -n '7540,7560p'`, `sed -n '7650,7700p'`, `sed -n '7724,7775p'`,
  `sed -n '11430,11470p'`, `sed -n '11760,11835p'`. Anchors: the fight-facts
  hold at `:7550`, `get_body_read:7654`, `_body_read:7665`,
  `_body_hold_read:7732`, `_body_hold_region:7748`, the two damage calls at
  `:11442` / `:11444`, the request-side injury dict at `:11769`, the hold words
  at `:11826`, the booking hold check at `:12861`.
- `Godot/scripts/Injury.gd` + `Godot/tests/injury_test.gd` — Q2's two files,
  spliced by you. Do not redesign the module: if it is wrong, fix it and record
  what you changed in Qwen's HANDOFF block, which is yours to write.
- `Godot/tests/body_readiness_test.gd`, `Godot/tests/body_read_test.gd`,
  `Godot/tests/body_readiness_integration_test.gd`.

## The work

**1. Splice Q2 and gate it.** Parse gate both files, run `injury_test.gd`, and
only then start. A module that does not parse hangs every later test.

**2. The save learns the word.** `body_state` gains `injuries` — a dictionary
keyed by region holding **at most one primary injury per region** (Q2's rule
4). Bump `CURRENT_VERSION` to 2 and migrate: an existing save keeps its regions
and its hold untouched, and gets `injuries: {}`. **A hold with no name stays a
hold with no name** — never invent an injury to explain an old save's hold. An
absent `injuries` key must read exactly like an empty one everywhere.

**3. One producer, two paths.** The hold is written in two places
(`apply_fight_damage:257` and `apply_real_fight_damage:325`) because a simmed
bout and a played bout take different routes into the same body. **Both must
name the injury identically**, or the same fight produces two different
fighters depending on whether the player watched it. Put the naming in one
private helper both call.

The type is **derived from what the bout already says** — the finish method,
the hotspot region the damage pass just picked, and the fighter's discipline
family (`Injury.family_for`). **No RNG, no draw table**: J13 leaves the odds
explicitly UNKNOWN and Q2 forbids weights. Where the bout's facts do not
support a name — a decision with no hotspot, a generic profile — the region
keeps its number and **gets no injury**. Soreness with no diagnosis is a legal,
common, correct outcome; a default `contusion` on every bout is not.

`medical_hold_until_week` keeps its meaning and stays the **one** clock: when a
named injury sets a hold, the hold is `maxi(existing, injury.hold_until_week)`.
Never a second clock, never a parallel tissue timer (DA3/DA4). Keep writing
`medical_hold_reason` for save compatibility, sourced from the injury's
`type_id` when one exists.

**4. The week resolves it.** Where the weekly pass already advances the body,
an injury whose `compete_week` has arrived leaves the region: clear the primary
and **append the finished injury to a durable list** on the athlete
(`body_state.injury_log`, newest-first, the house order). That list is G16's
input and the only record that a fighter was ever hurt — nothing else in the
save remembers. Follow the house pattern for weekly helpers: an `overrides`
dictionary so the test is deterministic.

**5. The reads carry it.** `_body_read()` (`:7665`) gains the region's injury
on each row and nothing else changes shape. `_body_hold_read()` (`:7732`)
prefers the **stored** injury's region — `region_known: true`, because now it
really is known — and keeps `_body_hold_region()`'s derivation as the fallback
for a hold with no name. The booking check at `:12861` keeps reading the one
hold week; it does not learn about injuries.

**6. Tests.** Extend the three body tests: the migration leaves an old save's
hold intact and names nothing; both damage paths name the same injury from the
same bout; a decision with no hotspot produces no injury; a second hit on an
injured region resolves through `Injury.resolve_on_region` rather than
stacking; the hold is the max of the two ladders; an injury that runs out
leaves the region and lands in `injury_log`; `get_body_read` carries the name;
`_body_hold_read` says `region_known: true` off the stored injury and still
falls back for an unnamed hold.

## Refusals

- **No age anywhere in healing.** J12/J13 bind: healing is age-blind. R54's
  clearance flags at age+mileage already exist and are not touched here.
- **No second medical clock.** One `medical_hold_until_week`.
- **No invented citations.** Q2's three `DIRECT` numbers are the only ones.
  Everything else is `AUTHORED` or `UNKNOWN`, and the grades ride along.
- **No RNG in the naming.** If you cannot derive the type from the bout, do not
  name one.
- **No `FightSimulation.gd`.** Its damage model is not this stage's business;
  you name what it already reports.
- **No screen work.** The BODY LAB and the schedule are U9's, and touching
  `ProfileRevampPanel.gd` here collides with U8.
- **No diet, no calories, no chin stat, no second potential axis** (DB1/DC4).

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/Injury.gd Godot/scripts/BodyReadiness.gd Godot/scripts/GameState.gd
```

Then, from `Godot/`:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/injury_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/body_readiness_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/body_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/smoke_test.gd
```

then the full suite once in the background before the commit. Every file in
`Godot/tests/` must exit 0.

## The one trap

`body_state` is migrated in place by `migrate_athlete()`, and it runs against
**every athlete in the world**, not only the gym's roster — `regions` is
defaulted to 100 per region for tens of thousands of people on load. Adding a
per-region injury dictionary that is *populated* at migration time, rather than
left empty, multiplies the save. `injuries: {}` costs nothing; `injuries:
{"head_neck": {...}, ...}` × six regions × the world population is a save-size
regression that will not show up in any focused test.
