---
name: project-session-s88-2026-09-26
description: "S88 - tiers 3-4 + build-a-wing (GymWing.gd), G121 presets, wing doors, hired sparring partner; Q190 had 3 defects its fake mutants hid"
metadata:
  node_type: memory
  type: project
  originSessionId: 350f4aae-4151-4e92-9ab8-2c2a5a7f101c
  modified: 2026-09-26T14:06:44.920Z
---

S88 (2026-09-26) shipped 227e2841: `GymWing.gd` (tier 3 academy 14x10 cells, tier 4 team HQ 18x14; a wing = G118 $55/sq ft
+ used pieces, 6/10 weeks, capacity x0.8, floor grows and kit re-hung by `apply_floor_preset`); `expand_floor` refuses past
tier 2; members bonus/cap; wing doors (mat room -> FINANCE, staff room, physio); hired partner via `get_spar_partner_offers`
/ `hire_spar_partner`, a spar-only row in `career.spar_partners` read by `_spar_body` ("partner|" ids).

Q190's "mutants" inspected hand-built dicts, never the module - its test could not fail. Real mutants found three defects
(one palette per level, male partners with female first names, class names off the game ladder). See
[[feedback_prove_contract_tests_with_mutants]].

**Why:** S89 builds on these names; Q191 decides whether the HIRE card's "fights like him" claim is true.
**How to apply:** S89 = visiting pro + open-spar night (G120 s6) reusing `career.spar_partners`; collect U183/Q191/D34/G122.
