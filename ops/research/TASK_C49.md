# TASK C49 — THE REGULATOR AND THE KIT: TWO FIELDS J3 ALREADY WON (codex)

Model: gpt-5.6-luna, effort **medium**, Fast off. One session. Research only —
**no `.gd`, no `.json`, no scene.**

## Why this exists

Two of J3's calls arrived with the evidence already gathered and a one-field
recommendation attached, and neither was ever built. `grep` finds
`regulator_kind` and `outfitting_policy` nowhere in the repository.

- **J3 D7** — `regulator_kind ∈ {athletic_commission, house_plus_officials,
  national_sport_authority, unknown}`. US UFC/PFL/Karate Combat cards run under
  a state commission; RIZIN under JMOC plus promotion medical; ONE under house
  rules with a host overlay; ARES under FMMAF/FFBoxe; URCC under GAB; Jungle
  under CABMMA; CMMAF under KOA/IMMAF amateur. **Suspension reciprocity is
  ABC-member, not global — a Nevada hold is not automatically a Saitama hold.**
- **J3 D15** — `outfitting_policy ∈ {house_kit, fighter_sponsors}`. UFC is a
  house kit (Venum through 2029) plus Promotional Guidelines Compliance pay;
  the other twelve default to `fighter_sponsors` unless a primary source says
  otherwise. `Godot/scripts/Sponsorship.gd:224` already RECEIVES `entity_type`
  and branches on nothing.

This is the study that lets both fields be filled in with evidence instead of a
guess, and it plays to what you are for: an audit that has to read a lot of
code and a lot of catalogue.

## What to answer

1. **A filled table, one row per organization** in
   `Godot/assets/data/real_organizations.json` (there are 18), with
   `regulator_kind`, `outfitting_policy`, the evidence grade J3 uses
   (DIRECT / CLAUSE / DOC / UNKNOWN) and the source. **UNKNOWN is a correct
   answer** and is expected for most of the twelve smaller promotions.
2. **What each field would change, with `file:line`.** The half that needs your
   shell:
   - `regulator_kind`: find every place a medical hold, suspension or licence
     is read or written, and say which of them are jurisdiction-blind today.
     Start from `Godot/scripts/BodyReadiness.gd`, `Godot/scripts/Sanctioning.gd`,
     `Godot/scripts/EntityPathway.gd`, and `medical_hold_until_week` in
     `Godot/scripts/GameState.gd` (**13,900+ lines, never open it whole** —
     `grep -n medical_hold` and read only those windows).
   - `outfitting_policy`: `Godot/scripts/Sponsorship.gd` around `:224`, and
     every caller of it.
3. **Whether the two fields belong on the organization or on the EVENT.** A
   promotion that runs cards in three countries is regulated differently in
   each. Say which, and what it costs either way.
4. **The minimum change**, as a build order. Two one-line data additions plus
   the seams that read them, or something smaller.

## What to deliver

`research/C49_THE_REGULATOR_AND_THE_KIT.md` in J3's shape — decisions
page, the 18-row table, cited evidence with UNKNOWN kept as UNKNOWN, what the
game does today, minimum change — plus `research/C49_DIGEST.md`, short.

## Do NOT

- Do not edit any `.gd` or `.json`. Do not edit `HANDOFF.md`.
- Do not invent a regulator for a promotion whose cards you cannot source. J3
  D7's own fourth value is `unknown` and it is there to be used.
- Do not turn brand facts into shippable assets. The standing rule is
  `brand_assets_policy: "text_name_only"` — a kit deal is a POLICY field, never
  a logo.
- Do not read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
  digest. Read this file, `research/J3_THE_DECISION_QUEUE.md`, and the
  code and data you audit.

## Owned files

```
research/C49_THE_REGULATOR_AND_THE_KIT.md
research/C49_DIGEST.md
```

## Parse gate

None — this task owns no script.

## Test

None. Research task.

## The one trap

**Twelve UNKNOWNs is a successful study.** J3 D15 says so in as many words: the
other twelve default to `fighter_sponsors` unless a primary is filed. Do not
pad the table to look complete — a sourced `unknown` is worth more than a
plausible invention, and the invention is what the next build would ship.
