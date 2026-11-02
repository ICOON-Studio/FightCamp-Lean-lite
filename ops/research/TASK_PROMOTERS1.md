# PROMOTERS1 (S230) - the REAL professional boxing promoters of our 24 boxing markets (John, research)

FightCamp is a PC boxing-gym management sim. A gym's boxer earns PAID fights on promoters' cards; an amateur federation's
calendar has no paid slot. House rule: organisations are REAL (names only, no logos), fighters fictional; never invent a body,
a fee or a number - if a primary page does not state it, it is UNKNOWN.

## Why now (a defect)
`Godot/assets/data/real_organizations.json` (catalog v3, 45 bodies) has NO professional boxing promoter. Every boxing body in it
is a federation or a commission (BBBofC, England Boxing, USA Boxing, ABC, JBC, FFBoxe, CYABF ...). So in a fresh world a boxing
gym in Cyprus, the UK, Japan ... has no paid boxing card to book (nightly 10-16: weight_cut, offer_desk, short_notice reds).

## Prior research - build on it, do not redo it
- `real_organizations.json`: schema and the 45 rows (copy the `cyprus_mmaf` row's shape exactly: id, name, short_name,
  entity_type, headquarters_country, disciplines, discipline_weights, tier, reputation, official_url, evidence
  (DIRECT | INHERITED | UNKNOWN), authority, regulator_kind, note, source {url, verified_date, facts}) and `market_assignments`
  (24 markets: Cyprus, United States of America, Brazil, Japan, Thailand, Mexico, Netherlands, South Korea, China, Georgia, France,
  Philippines, United Kingdom, South Africa, Australia, Argentina, Russia, Kazakhstan, Uzbekistan, Germany, Italy, Spain, Poland, Canada).
- `J1_ORGANIZATION_RULES_AND_JUDGES.md`, `J2_THE_FEDERATION_PATHWAY.md`: grade vocabulary and the UNKNOWN policy.
- `J4_THE_DESK_AND_THE_CUT.md`, `J46_YOUR_OWN_PROMOTION.md`: promoter -> contestant money flow (already researched; cite).
- `COUNTRYDATA1` (S228) added the federations/commissions; tier/reputation there are game scale from BoxRec depth (A: UK/USA/
  Mexico/Japan, C: Cyprus, else B) - use the same scale.

## What would a human do?
A boxing manager in Manchester books his prospect on a Matchroom / Queensberry / BOXXER / small-hall show licensed by the BBBofC;
in Nicosia he looks for a local pro show or takes the fight abroad (Greece, the UK). Name the promoters a real manager would ring.

## Prefab check
BoxRec's promoter pages, each commission's licensed-promoter list (BBBofC, JBC, state commissions), promoters' own sites.

## Deliver (the longest complete answer you can give; one ```json block + notes)
1. Per market: 1-3 ACTIVE professional boxing promoters (2024-2026 shows), the biggest first and one small-hall promoter where a
   source exists, as `real_organizations.json` rows: entity_type "promotion", disciplines ["boxing"], discipline_weights
   {"boxing": 100}, official_url checked, evidence graded, `authority` = the commission that licenses its shows,
   source.facts = what the page states (shows per year, venue, TV deal) - no invented numbers.
2. `market_assignments` lines with the PROMOTER FIRST in each list (the game gives the first entry the market's generated
   promotion slot), then the existing federation ids in their current order.
3. Markets where no active pro boxing promoter can be sourced (Cyprus? Georgia? Uzbekistan?): say so per market, and name
   where that country's pros actually fight (the nearest market by sourced BoxRec records), so the game can offer those fights.
4. One paragraph: what could not be sourced.
