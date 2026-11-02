# TASK U12 — THE ORGANIZATION SAYS WHAT KIND OF THING IT IS (cursor)

Model: top tier, effort **high**, Fast off. One session. **Runs now.**

## Why this exists

Three organization-level fields have now been researched, sourced and
recommended — and not one of them exists in the repository. `grep` finds
`ranking_mode`, `regulator_kind` and `outfitting_policy` nowhere.

- **`ranking_mode`** (C47 / J3 D5) — `discretionary` | `published_criteria` |
  `mixed`. **Never a formula.** UFC's Meta weights are UNKNOWN, PFL and ONE
  publish panel methods, IBJJF/UWW/IJF/WT publish criteria, and most smaller
  promotions are UNKNOWN. Reverse-engineering a ranking from results is the lie
  the research desk exists to stop.
- **`regulator_kind`** (C49 / J3 D7) — `athletic_commission` |
  `house_plus_officials` | `national_sport_authority` | `unknown`. Known only
  where J3 named the authority: US UFC / PFL / Karate Combat under commissions,
  RIZIN house plus JMOC, ONE house plus host overlay, ARES under FMMAF-FFBoxe,
  Jungle CABMMA, URCC GAB, CMMAF KOA-IMMAF.
- **`outfitting_policy`** (C49 / J3 D15) — `house_kit` | `fighter_sponsors`.
  **UFC is the only sourced `house_kit`.** The other twelve promotions are
  `fighter_sponsors` with UNKNOWN kit evidence, and that is the correct answer,
  not a gap to be filled in.

`Godot/scripts/Sponsorship.gd:224` already receives `entity_type` and branches
on nothing. That is the seam `outfitting_policy` was researched to feed.

## What to build

1. **The three fields in `real_organizations.json`**, per C47's and C49's
   tables. Where the research says UNKNOWN, write the unknown value — do not
   improve on it. Twelve UNKNOWNs is a correct outcome.
2. **A default for a generated market organization**, which has no catalogue
   entry: `unknown` regulator, `fighter_sponsors` outfitting,
   `discretionary` ranking. Say in the digest that these are defaults, not
   findings.
3. **`Sponsorship.gd` branches on `outfitting_policy`** instead of receiving a
   type it ignores. No logos, no numeric kit payment — the standing rule is
   `brand_assets_policy: "text_name_only"` and a kit deal is a POLICY field.
4. **One read exposes all three** so a screen can say them without three
   lookups, in the shape `OrganizationRead` already uses.

## Out of scope

The EVENT-level effective regulator override C49 recommends (a promotion
running cards in three countries is regulated three ways) and the medical
hold's missing jurisdiction. Both are C51, queued behind this task because they
need `regulator_kind` to exist first.

## Owned files

```
Godot/assets/data/real_organizations.json
Godot/scripts/Sponsorship.gd
Godot/scripts/OrganizationRead.gd
Godot/scripts/EntityPathway.gd
Godot/tests/sponsorship_test.gd
Godot/tests/organization_read_test.gd
research/U12_DIGEST.md
```

**Not owned, do not edit:** `Godot/scripts/GameState.gd`,
`Godot/scripts/WorldPopulation.gd` — Claude owns those under R70 and both run
at once. R70 also edits `real_organizations.json`; it is adding a
belt-eligibility fact and not touching your three fields, so **rebase and merge
rather than reverting**, and say in your mail if you hit a real conflict.

`Sponsorship.gd` is 252 lines and `EntityPathway.gd` 211 — read both whole.
`OrganizationRead.gd`: find your seam with `grep -n`, it is bigger.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/Sponsorship.gd Godot/scripts/OrganizationRead.gd Godot/scripts/EntityPathway.gd Godot/tests/sponsorship_test.gd Godot/tests/organization_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/organization_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/sponsorship_test.gd
```

Then the full suite once in the background before the commit. Fails=0 or better
— **if it comes back lower than you expected, say so and push anyway.**

## The one trap

**`unknown` is a value, not a hole.** The temptation on a table with twelve
UNKNOWNs is to reason from a promotion's size to its regulator, or from its
country to its kit deal. C49's whole finding is that the sources do not support
that. A sourced `unknown` is worth more than a plausible invention, because the
invention is what the next build would ship as fact.

Push your branch and **name it in the first line of your mail** — your
environment cannot push `master` and that is understood, not a fault.
