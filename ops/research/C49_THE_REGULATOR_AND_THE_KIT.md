# C49 — The Regulator and the Kit

**Study status:** research and proposal only. No `.gd`, `.json`, scene, or
`HANDOFF.md` changes were made.

## Decisions page

| Call | Recommendation | Why |
|---|---|---|
| Effective regulator | Store the catalog's `regulator_kind` as an organization default, but resolve the effective value on the EVENT and allow an event override. | A promotion can run cards in several countries; a Nevada commission hold is not automatically a Saitama hold. |
| Outfitting policy | Store `outfitting_policy` on the organization; use an event override only for an exceptional card. | The UFC kit restriction follows the promotion, while a card-level exception is cheap to represent later. |
| UFC kit | `house_kit`. Personal fight-week/cage patches are not available; any compliance payment is a separate, cited promotion term. | J3 D15 records the Venum deal through 2029 and Promotional Guidelines Compliance pay. |
| Other 12 promotions | `fighter_sponsors` as the build default; evidence remains `UNKNOWN` until a primary kit rule is filed. | J3 D15 explicitly says this is the honest default. It is not evidence that every promotion permits patches. |
| Federations and tournament operator | Keep the same enum-shaped default only as a non-card fallback; do not create fight-night sponsor income for them. | EntityPathway already routes them to `programme_support` / calendar nodes, not promotion cards. |
| Suspension reciprocity | Do not make it global. Apply a hold across an explicitly authored commission family only. | J3 D7 says reciprocity is ABC-member, not worldwide. |

## The 18-row decision table

`Reg grade/source` and `Kit grade/source` are separate because the two fields
have different evidence. `DIRECT` is a sourced policy call. `DOC` means the
named authority or non-card pathway is documented, but this pass does not have
an event-specific primary rule. `UNKNOWN` means no primary filing supports a
more specific claim. `fighter_sponsors` on a non-card row is a safe runtime
default, not a claim that the entity sells a fight-night sponsorship.

| ID | Organization / entity | `regulator_kind` | Reg grade / source | `outfitting_policy` | Kit grade / source |
|---|---|---|---|---|---|
| `ufc` | Ultimate Fighting Championship / promotion | `athletic_commission` | DIRECT — J3 D7; US state athletic commissions; [Nevada NAC 467](https://www.leg.state.nv.us/nac/NAC-467.html) | `house_kit` | DIRECT — J3 D15; UFC/Venum through 2029 and Promotional Guidelines Compliance |
| `pfl` | Professional Fighters League / promotion | `athletic_commission` | DIRECT — J3 D7; US state athletic commissions | `fighter_sponsors` | UNKNOWN — J3 D15 default for the other 12 promotions |
| `one_championship` | ONE Championship / promotion | `house_plus_officials` | DOC — J3 D7; ONE house rules with host overlay; [ONE martial-arts rules page](https://www.onefc.com/martial-arts/) | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `rizin` | RIZIN Fighting Federation / promotion | `house_plus_officials` | DOC — J3 D7; JMOC plus promotion medical | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `glory` | GLORY Kickboxing / promotion | `unknown` | UNKNOWN — J3 D7 does not file a regulator for GLORY | `fighter_sponsors` | UNKNOWN — J3 D15; house marks in practice are not a sourced third-party patch ban |
| `karate_combat` | Karate Combat / promotion | `athletic_commission` | DIRECT — J3 D7; US state athletic commissions | `fighter_sponsors` | UNKNOWN — J3 D15 default |
| `cyprus_mmaf` | Cyprus Mixed Martial Arts Federation / federation | `national_sport_authority` | DOC — J3 D7; KOA/IMMAF amateur frame; professional Cyprus rules remain UNKNOWN | `fighter_sponsors` *(non-card fallback)* | DOC — `EntityPathway.gd:183-193`; federation is a programme/calendar path, not a fight-night kit contract |
| `jungle_fight` | Jungle Fight / promotion | `national_sport_authority` | DOC — J3 D7; CABMMA | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `ibjjf` | International Brazilian Jiu-Jitsu Federation / tournament operator | `unknown` | UNKNOWN — no professional regulator is established by J3 D7 | `fighter_sponsors` *(non-card fallback)* | DOC — `EntityPathway.gd:183-193`; open-entry tournament path, not a fight-night kit contract |
| `rajadamnern_world_series` | Rajadamnern World Series / promotion | `unknown` | UNKNOWN — J3 D7 does not file a regulator | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `lux_fight_league` | LUX Fight League / promotion | `unknown` | UNKNOWN — J3 D7 does not file a regulator | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `road_fc` | ROAD Fighting Championship / promotion | `unknown` | UNKNOWN — J3 D7 does not file a regulator | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `kunlun_fight` | Kunlun Fight / promotion | `unknown` | UNKNOWN — J3 D7 does not file a regulator | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `united_world_wrestling` | United World Wrestling / federation | `unknown` | UNKNOWN — international federation governance is not a sourced professional-card regulator here | `fighter_sponsors` *(non-card fallback)* | DOC — `EntityPathway.gd:183-193`; national-selection/calendar path, not a fight-night kit contract |
| `ijf` | International Judo Federation / federation | `unknown` | UNKNOWN — international federation governance is not a sourced professional-card regulator here | `fighter_sponsors` *(non-card fallback)* | DOC — `EntityPathway.gd:183-193`; national-selection/calendar path, not a fight-night kit contract |
| `world_taekwondo` | World Taekwondo / federation | `unknown` | UNKNOWN — international federation governance is not a sourced professional-card regulator here | `fighter_sponsors` *(non-card fallback)* | DOC — `EntityPathway.gd:183-193`; national-selection/calendar path, not a fight-night kit contract |
| `ares_fighting_championship` | ARES Fighting Championship / promotion | `national_sport_authority` | DOC — J3 D7; FMMAF/FFBoxe | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |
| `urcc` | Universal Reality Combat Championship / promotion | `national_sport_authority` | DOC — J3 D7; Games and Amusements Board | `fighter_sponsors` | UNKNOWN — J3 D15; no primary kit-ban filing retrieved |

The **12 UNKNOWN kit rows are exactly the 12 promotions other than UFC**:
PFL, ONE, RIZIN, GLORY, Karate Combat, Jungle Fight, RWS, LUX, ROAD FC,
Kunlun Fight, ARES, and URCC. They are not padded with invented brand rules.
The five non-promotion rows are explicitly labelled non-card fallbacks and do
not create fight-night sponsor income.

## Evidence and boundaries

J3 D7 establishes the four-value regulator vocabulary:
`athletic_commission`, `house_plus_officials`, `national_sport_authority`, and
`unknown`. Its sourced calls are US UFC/PFL/Karate Combat cards under a state
commission; RIZIN under JMOC plus promotion medical; ONE under house rules with
a host overlay; ARES under FMMAF/FFBoxe; URCC under GAB; Jungle under CABMMA;
and CMMAF under KOA/IMMAF amateur. J3 also explicitly warns that ABC-member
reciprocity is not global.

J3 D15 establishes the two-value kit vocabulary. UFC's house kit is the only
direct policy call in this catalog pass: Venum is documented through 2029 and
the replacement payment is called Promotional Guidelines Compliance pay. The
numeric tier table is secondary-confirmed, not a primary UFC PDF; this study
therefore recommends the policy branch but does not add a dollar amount.

For the remaining twelve promotions, J3 says no primary 2026 kit-exclusivity
PDF was retrieved. Their `fighter_sponsors` values are implementation defaults
with `UNKNOWN` evidence. A house mark visible in a photograph or article is not
enough to assert a ban on third-party patches. No logo, kit image, or brand
asset is implied: the catalog's standing rule is
`brand_assets_policy: "text_name_only"`.

The catalog itself supplies the 18 identities and entity types in
[`real_organizations.json`](../assets/data/real_organizations.json), with the
snapshot dated 2026-09-01. It has no `regulator_kind` or `outfitting_policy`
field today. `EntityPathway.gd:95-113` makes promotions the signing/purse path,
federations the national-selection path, and the tournament operator the
open-entry path. `EntityPathway.gd:183-193` calls the non-signing outputs
`calendar_node` and `programme_support`; that is why the non-promotion table
rows do not mean “pay this entity for a fight-night kit.”

## What the game does today

### Regulator / medical hold

The hold is currently a single athlete body clock, with no organization,
event, jurisdiction, commission, or reciprocity dimension.

| Seam | Current behavior | Honesty |
|---|---|---|
| `BodyReadiness.gd:18-75` | Migration creates `body_state.medical_hold_until_week` and `medical_hold_reason` additively; absent data stays a default clock. | Honest compatibility migration, but not jurisdiction-aware. |
| `BodyReadiness.gd:183-206` | Competition clearance blocks while `current_week < medical_hold_until_week`, alongside region, injury, and fatigue gates. | Honest body gate; it cannot know which regulator owns the event. |
| `BodyReadiness.gd:251-310` | `apply_fight_damage` chooses an authored profile and writes/extends the hold from `medical_hold_weeks` or a context override. | Hold length is a body/profile context, not a commission rule. |
| `BodyReadiness.gd:325-381` | The played-fight path applies the real final regions, then writes/extends the same one clock. | Same jurisdiction-blind behavior on the played path. |
| `BodyReadiness.gd:486-535` | A named injury can extend that same clock; the injury supplies a reason and region, not a regulator. | Medical attribution improved, regulator attribution absent. |
| `BodyReadiness.gd:609-636` | Injury resolution removes due injuries but deliberately does not touch the separate hold clock. | Correct separation of injury course and medical hold; no commission scope. |
| `GameState.gd:3950-3973` | Turns `medical_hold_active` into generic “MEDICAL FIGHT HOLD” copy. | No event or jurisdiction is displayed. |
| `GameState.gd:5292-5296` | Advances injury timing and documents the hold convention: a hold to week 14 expires when week 14 begins. | Clock semantics are authored and global. |
| `GameState.gd:7633-7641` | Former-fighter projection copies a real `medical_hold` bool or derives it from the body clock. | Historical read is not tied to the event that imposed the hold. |
| `GameState.gd:7850-7880`, `7901-7912` | Reads the held/until/reason fields and derives a region from a named injury or the first relevant fight-history hotspot. | Region may be UNKNOWN; regulator is always absent. |
| `GameState.gd:11955-11958`, `12039-12042` | Dashboard counts an athlete injured when status is injured or the hold week is still future, and exposes weeks left/reason. | Useful projection, jurisdiction-blind. |
| `GameState.gd:12088-12100` | Profile flags expose a red `medical_hold` row with hold week/reason. | No commission scope or reciprocity. |
| `GameState.gd:13158-13161` | Calendar emits a medical-clearance item when the hold week equals the cell week. | Calendar event has no regulator/effective authority. |

A search for `medical_hold` found no direct GameState write of the clock. The
writes are in BodyReadiness's damage/injury paths; GameState reads and projects
the result. The current model therefore cannot answer “cleared for which
event?” or “does this hold travel to that promotion?”

`Sanctioning.gd:44-81` already resolves rules by organization, discipline, and
optional overrides, and `Sanctioning.gd:89-121` stamps and reads an event/bout
ruleset. Its `overrides` hook is explicitly per-event, but it currently carries
ruleset/evidence/authority fields only; it does not resolve medical holds or
regulator reciprocity. `EntityPathway.gd:95-113` distinguishes signing,
open-entry, and national-selection behavior, but it likewise has no regulator
field.

### Outfitting / sponsorship

`Sponsorship.gd:210-239` is the live offer seam. It calls
`EntityPathway.sponsorship_template` at `:213`, chooses `fight_night` versus
`programme_support` through `EntityPathway.gd:190-193`, and copies
`entity_type` at `Sponsorship.gd:230`. There is no `outfitting_policy` branch:
the organization identity is received, but house kit versus fighter sponsors
is unread.

Direct production callers found by repository search are:

- `GameState.gd:39` preloads the module; `:284-306` exposes ensure, summary,
  offer, and accept reads/writes.
- `GameState.gd:2735`, `:2752`, `:2808`, and `:5290` ensure sponsorship state;
  `:5275` settles the weekly payment; `:11574` records a fight card.
- `GymLedgerRead.gd:7` preloads the module and `:99` reads the active condition.
- `ManagementOverview.gd:96-97` and `:332-333` consume materialized active
  sponsorship/condition data; they do not resolve kit policy.
- `EntityPathway.gd:190-193` is the template resolver used by offer generation.

The offer already carries `entity_type`, `pathway`, and `template`, so the
cheapest future read is to add the policy to the offer and branch only where a
fight-night sponsor benefit would be created. Programme support remains on its
existing non-card path.

## Organization versus event

The honest ownership is split:

1. `outfitting_policy` belongs on the organization by default. It describes a
   promotion's normal commercial kit policy. The event may override it later
   for a one-off venue or co-promoted card.
2. The **effective** `regulator_kind` belongs on the event. A catalog-level
   organization value is still useful as a default and evidence record, but
   it cannot be the final truth for a promotion that crosses borders.

An organization-only regulator field is the cheapest implementation but makes a
cross-border card silently wrong. An event-only field is more accurate but
requires every event producer and old-save reader to populate or resolve it.
The minimum honest design is therefore organization default plus event override:
old events resolve through the organization default, and an event with no
known authority remains `unknown` rather than inheriting a foreign commission.

This also preserves the existing stamp principle in `Sanctioning.gd:89-107`:
the effective authority should be written once with the event, not silently
reinterpreted after a save is made. The body clock remains on the athlete, while
the event carries the authority/scope needed to decide whether that clock is
recognized for this card.

## Minimum change — build order

1. Add `regulator_kind` and `outfitting_policy` to organization definitions.
   UFC is the only `house_kit` call. Keep the 12 other promotions at
   `fighter_sponsors` with an explicit UNKNOWN evidence note. Keep the five
   non-promotion rows on their programme/calendar path.
2. Extend the event stamp/resolver beside `Sanctioning.gd:51-80` and
   `:94-107` with an effective regulator and an optional event override. Old
   unstamped events resolve from the organization default; unresolved authority
   is `unknown`.
3. Thread event context into the competition-clearance/booking seam without
   replacing `medical_hold_until_week`. Add an authored reciprocity scope (for
   example, an ABC-member family) and default it off outside that family. Do
   not add a global “all commissions honor all holds” rule.
4. Branch `Sponsorship.gd:225-239` on `outfitting_policy` for fight-night
   offers. `house_kit` suppresses personal fight-week/cage patch income;
   `fighter_sponsors` preserves the existing sponsor path. Do not add logos or
   a numeric compliance cheque until a primary table is filed; the policy flag
   is sufficient for this first build.
5. Add focused contract coverage later: a Nevada/ABC hold blocks the explicit
   ABC-member family, does not auto-block RIZIN/ONE, and a house-kit offer does
   not attach a fighter patch. No code or tests are changed in this research
   task.

The smallest shippable first slice is the two catalog fields plus the
Sponsorship branch. The regulator field needs the event-resolution slice before
it can honestly change booking behavior; merely adding it to JSON would be
decorative metadata.

## Sources

- `research/J3_THE_DECISION_QUEUE.md`, decisions D7 and D15, the source
  list, and the “Not retrieved / do not fake” boundary.
- [`Godot/assets/data/real_organizations.json`](../assets/data/real_organizations.json),
  snapshot 2026-09-01; 18 identities, entity types, and text-only brand policy.
- [Nevada NAC 467](https://www.leg.state.nv.us/nac/NAC-467.html), cited by J3
  for commission medical/suspension authority.
- [ONE martial-arts rules page](https://www.onefc.com/martial-arts/), cited by
  J3 for ONE's house rules, host overlays, and medical/testing context.
- The named FMMAF/FFBoxe, GAB, CABMMA, KOA, IMMAF, and JMOC authorities are
  retained exactly as J3 D7 records them. No additional regulator is inferred
  for an organization whose primary card authority was not filed.
