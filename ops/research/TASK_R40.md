# TASK R40 — THE ENTITY PATHWAYS: THE FEDERATIONS STOP SIGNING PEOPLE (Claude)

**Status: COMPLETE 2026-09-06.** The operator APPROVED **J2 D4 and D6**
exactly as John recommended them (`research/J2_THE_FEDERATION_PATHWAY.md`,
decisions page) - neither narrowed nor widened - so the scope below stands as
written and was built from it unchanged.

Model: Opus, effort high, Fast off. It is `GameState.gd` and it changes
behaviour six other systems can see.

## Why this exists

The second half of option A. The catalog is honest — 13 promotions, 4
federations, 1 tournament operator, each with a real definition in the
`entity_types` block — and the runtime ignores all of it. `entity_type` is
copied at `WorldPopulation.gd:254`, handed to sponsors at `Sponsorship.gd:224`,
and **nothing branches on it**.

So today the IJF signs you to an exclusive contract and pays you a purse
exactly like the UFC. So does World Taekwondo. So does IBJJF — an organization
you in reality *pay* to enter. And CMMAF pays an amateur a professional purse,
which in reality would **end** the amateur career the game is modelling
(J2 D5).

J2's ruling, and the operator's before it: this is a **behaviour** distinction,
not an identity one. **One organizations table, one `Sanctioning` resolver
(R39's, already on master), three pathways.**

## The one sentence this stage is scoped to

Stop emitting promotion bout contracts for non-promotions; keep one org table;
let `entity_type` choose the pathway.

## The pathways (J2 §0)

| Pathway | `entity_type` | Who puts the athlete on the mat | Money | Emit | Never emit |
|---------|---------------|---------------------------------|-------|------|------------|
| `signing` | `promotion` (the 13) | The promotion, by bout contract | org → fighter | `BoutOffer`, as today | — |
| `open_entry` | `tournament_operator` (`ibjjf`) | The athlete, by paying and making weight | fighter → operator; operator → fighter only where a prize table is authored | a calendar entry with a **published** fee debit | signing offer, purse, win bonus |
| `national_selection` | `federation` (`ijf`, `united_world_wrestling`, `world_taekwondo`, `cyprus_mmaf`) | The **national federation** | licences up; the living wage is national, not the IF's | a calendar node, prestige, ranking | signing offer, purse, win bonus, "opening card" |

## What to build (J2 §5.5, numbered as John wrote it)

1. **Derive the pathway** from the existing `entity_type` — `signing` /
   `open_entry` / `national_selection`. No new organizations table. No new data
   file. An explicit `pathway` field is a *later* option and is **not** needed
   to stop the lie.
2. **`GameState.get_promotion_bout_offer` (`:5492`)** — when the org's
   `entity_type` is not `promotion`, return **no offer**. Not a zero purse: no
   offer.
3. **`_promotion_purse_multiplier` (`:5483`)** is never called for those ids.
   S/A/B/C tier math is a promotion model; J2 §5.3 keeps `tier`/`reputation`
   as prestige labels and forbids them feeding a purse for these five.
4. **`accept_signing_offer` (`:5288`)** — refuses `ijf`,
   `united_world_wrestling`, `world_taekwondo`, `cyprus_mmaf`, `ibjjf`.
   Signing stays a thing that happens among the 13.
5. **`WorldPopulation.gd:174`** — a federation or tournament operator does not
   "receive its own opening event" as a promotional card. It gets a calendar
   node with no roster-signing requirement.
6. **IBJJF is `open_entry`**: a fee debit **only** where a published fee is
   authored, and a prize **only** where a `prize_table` is authored from a
   cited page. J2 §6.3's rule is load-bearing here — an unknown fee is
   **skipped and flagged**, never defaulted to a number, and never faked as a
   zero.
7. **The Olympic IFs are calendar events the NF enters.** Player-facing:
   prestige, a training conflict, and a later feeder. No purse. No
   player-owned Grand Slam slot.
8. **CMMAF is amateur** — J1 §1.7's inherited IMMAF ruleset, zero purse, and a
   sticky `turned_pro` flag set on a first promotion signing.
9. **`Sponsorship.gd:224`** gets its first legal branch on `entity_type`: an
   Olympic-federation calendar node is not sold a UFC fight-night sponsor.
10. **Tests** — J2 §6.4's P1-P15. The assertion that pays for the whole
    study: **no org with `entity_type` in `{federation, tournament_operator}`
    has `purse > 0` or a signing offer.**

## What NOT to do

- **No second career mode.** No Olympic-qualification simulation, no NF
  politics, no quota allocation, no ranking-point UI. J2 §6.2 is explicit that
  building the faithful national-team sim on top of a broken purse model is
  the unplayed-mode trap, and D4 refused it.
- No ranking formulas. J2 §4 cites the real ladders; **inventing** one is
  forbidden by §6.3.
- No belt-certificate fees, no GAL markup, no year budgets. Line items only,
  and only cited ones.
- **No Olympic properties in any shipped string** — J2 §6.1. The rings, the
  word, the emblems and the city-year lockups are among the most protected
  marks in sport. Internal comments may cite the qualification PDFs; the game
  may not print them. Test P11 asserts it.
- No re-litigating R38 or R39. The judges and the sanctioning spine stand.
- No UI. A later Kalli/Maria stage draws the calendar node.
- No edits to `real_organizations.json` identities.

## Anchors

- `research/J2_THE_FEDERATION_PATHWAY.md` — decisions page (D1-D6),
  §0 pathway map, §2.6 money-flow summary, §5.5 the ten changes, §6.4 the
  fifteen assertions. **Read the decisions page first.**
- `Godot/assets/data/real_organizations.json` — the `entity_types` block.
- `GameState.gd:585` (country-only org pool), `:5288`, `:5483`, `:5492`.
- `WorldPopulation.gd:174`, `:254`; `Sponsorship.gd:224`.
- `Godot/scripts/Sanctioning.gd` (R39) and `OrganizationRead.gd` (C24) — the
  spine and the read this branches behind. Do not duplicate either.

## Owned files

```
Godot/scripts/EntityPathway.gd
Godot/scripts/GameState.gd
Godot/scripts/PromotionSigning.gd
Godot/scripts/WorldPopulation.gd
Godot/scripts/Sponsorship.gd
Godot/tests/entity_pathways_test.gd
```

As built: `EntityPathway.gd` is new and holds the whole identity -> behaviour
edge. `GameState.gd` branches at the signing accept, the promotion bout offer,
the organization challenge offer, the event open slot and one `book_fight`
guard. `PromotionSigning.evaluate()` skips non-promotions (P13).
`WorldPopulation.gd` stores the pathway on the organization and the kind on
the event, and opens no slot where the manager cannot enter. `Sponsorship.gd`
takes the first legal `entity_type` branch. `entity_pathways_test.gd` is new.

Two seams beyond the four D6 named were gated for the same reason and are
listed here rather than left silent: `get_organization_fight_offer` (the
CHALLENGE a manager sends an org's fighter - it paid a federation purse
exactly like the bout offer did) and `get_event_open_slot_offer` (the slot
the player books on a world card). Both now refuse an international
federation outright and pay nothing on the other two pathways.

**Deferred, with reasons, not silently dropped:**
- **P9** (an IJF world-ranked athlete needs authorization for another sport's
  international) - the game carries no world ranking list and J2 6.3 forbids
  inventing one.
- **P15's technique half** - no ruleset authors an elbows/knees-to-the-head
  flag. `EntityPathway.ends_amateur_eligibility()` reads one if it ever
  exists; an absent flag is UNKNOWN and never turns a fighter pro.
- **The settlement-side `turned_pro`** - the flag is set on a promotion
  signing (this task's point 8). A paid bout taken off the generic offer
  board does not set it yet; that belongs with fight settlement, not here.

## Parse gate (before any test run)

```bash
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/WorldPopulation.gd Godot/scripts/Sponsorship.gd
```

## Tests

New `Godot/tests/entity_pathways_test.gd`, carrying J2's P1-P15. Then
`organization_read_test.gd`, `organization_fight_offer_test.gd`,
`real_organizations_test.gd` and `sanctioning_test.gd` must pass **unchanged**
— they are the systems this branches behind. Full suite once, in the
background, before the commit.

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/entity_pathways_test.gd
```
