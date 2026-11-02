# C43 digest — GRAPPLE, the seventh attribute

Implemented `grapple` as the seventh 0-100 athlete attribute. It is present in
the central GameState rating/generation seams, AthleteStatModel help/order,
AthleteDevelopment training/migration, world and opponent generation, Aging,
Retention, FightCamp, DevelopmentPanel and ProfileRevampPanel. Grappling mats,
tatami and grappling dummies now train it through the existing stat-gain path.

The full pre-change audit found 12 production/data canonical six-stat sites:
11 were updated; FightSimulation.gd remains intentionally six-stat because
C43 forbids simulation rebalance. It also found three explicit six-stat test
contracts, all updated, plus the six-entry `technique_catalog.json` attribute
list. Featured and saved world athletes receive GRAPPLE as the deterministic
average of their existing stats, so legacy rows never silently become zero.

Migration is additive and idempotent: AthleteDevelopment version 1/old rows
move to version 2 and default GRAPPLE to the old six-stat average. Discipline
generation gives grappling arts the same existing authored weighting pattern;
no new combat consumer was added.

Rating changes: the average denominator changes from 6 to 7 everywhere that
owns the athlete rating. The opponent-generator test changed its explicit
mean denominator from `6.0` to `7.0`; no other fixed rating expectation moved.
Migrated six-stat saves preserve their prior rating when GRAPPLE equals the
old average; newly generated athletes use all seven generated values.

Verification: parse gate 15/15 and final full suite 169/169 tests passed.
