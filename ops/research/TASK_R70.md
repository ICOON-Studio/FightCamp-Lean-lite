# TASK R70 — THE BELT THAT SHOULD NOT EXIST (claude)

Model: top tier, effort **high**, Fast off. One session. **Runs now.**

## Why this exists

R68 gave every belt the highest-standing promotion that runs its discipline.
C46 read the sources and ruled that **the model is right for four disciplines
and wrong for the rest**: a federation or tournament operator owns a
championship EVENT, not a standing belt somebody carries and defends.

- **Promotion-owned, keep:** mma, kickboxing, muay_thai, karate (Karate Combat).
- **Event disciplines, must not seed a belt at all:** judo, wrestling,
  taekwondo, brazilian_jiu_jitsu, and sanda / sambo if they appear. An IJF or
  UWW world championship is won on a date and does not create a champion who
  defends it on the next card.
- **Boxing:** the alphabet bodies stay out of the catalogue (J3 D4), and a
  boxing belt must **never** fall to a generated market association — which is
  what ships today.

C46 also corrects the premise I wrote into its own brief: the federation
entries are `ijf`, `united_world_wrestling` and `world_taekwondo`;
`karate_combat` is a `promotion` and `ibjjf` is a `tournament_operator`.

## What ships today (C46's audit, verified anchors)

`ensure_championships` (`WorldPopulation.gd:1040`) groups every athlete by
`discipline|weight_class|sex`, needs three contenders, and seeds a champion.
**It does not filter to professional promotion disciplines.**
`organization_disciplines` (`:1137`) derives a discipline from any positive
`discipline_weights` entry, so a generated market association advertises judo
merely by having local weight for it. `promotions_by_standing` (`:1155`)
correctly excludes federations and tournament operators — so **no belt lands on
a federation** — but a missing `entity_type` defaults to promotion, so the
generated association is eligible and catches the fallback.
`sanctioning_organization_id` (`:1184`) returns it; `""` only when nothing
matches at all.

## What to build — C46's build order, items 1, 2 and 4

1. **Belt eligibility as a catalogue fact.** A closed list of belt-bearing
   disciplines, in data, not inline. Everything else seeds no belt.
2. **Stop seeding event-discipline belts** in `ensure_championships`, and do
   **not** substitute the first generated association for boxing.
3. **A save migration** that retires existing event-discipline belts as
   legacy / event-only rather than deleting them silently. R68's stamp is
   write-once, so a catalogue correction does not repair an old save by itself.
   Bump `SCHEMA_VERSION` (`WorldPopulation.gd:5`, currently 1) or add an
   explicit championship migration version beside it — decide which and say why
   in the digest.

**Out of scope, deliberately:** C46's item 3, the `org_id|discipline|weight_class|sex`
key reshape. It changes every division key in the game and every save that
holds one; it is its own stage and must not ride along inside a migration that
is already retiring belts.

## Owned files

```
Godot/scripts/WorldPopulation.gd
Godot/scripts/GameState.gd
Godot/assets/data/real_organizations.json
Godot/tests/championship_read_test.gd
Godot/tests/titles_rankings_test.gd
research/R70_DIGEST.md
```

**Not owned:** `Godot/scripts/Sponsorship.gd` and the organization catalogue
fields `ranking_mode` / `regulator_kind` / `outfitting_policy` — Cursor owns
those under U12 and both run at once. If U12 has already landed on
`real_organizations.json`, rebase and merge rather than reverting its fields.

`GameState.gd` is **14,072 lines — never open it whole.** The championship
seams are one window: `sed -n '10430,10620p'`.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/WorldPopulation.gd Godot/scripts/GameState.gd Godot/tests/championship_read_test.gd Godot/tests/titles_rankings_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/titles_rankings_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd
```

Then the full suite once in the background before the commit. Fails=0 or better.

## The one trap

**A retired belt is not a deleted belt.** A save where a fighter has held the
judo world title for forty weeks is a save where that happened; the migration
must leave a readable record of it and stop it being defended, not erase a
career. And the CHAMPIONS board must not show an empty discipline chip for a
division that no longer bears a belt — R68's chips are built from the belts
themselves, so removing the belts removes the chip, and that wants asserting
rather than assuming.
