# C46 digest

C46 rules that the belt object is promotion-owned only for named house titles: MMA, kickboxing, Muay Thai and Karate Combat. Judo, wrestling and taekwondo World Championships are federation events, not defended belts. IBJJF Worlds is a tournament event; ONE's related entry is submission grappling, not an IBJJF belt. Boxing remains a sanctioning-body overlay and stays out of the catalogue; sanda/sambo are federation-event disciplines if seeded.

The permitted `WorldPopulation.gd` window shows why the bug exists: `promotions_by_standing` excludes federations and tournament operators, then `sanctioning_organization_id` falls through to a generated market association or `""`. Therefore no federation receives a belt, but judo/wrestling/taekwondo (and possibly BJJ, boxing, sanda or sambo) can receive a generated association or empty stamp. The migration contract is write-once, so old event-discipline belts require an explicit save migration; do not reassign them to a federation.

Minimum build order: stop seeding event disciplines, preserve an explicit legacy/event-only migration outcome, then scope surviving house belts by promotion authority. No `.gd`, `.json`, `.tscn`, test, or `HANDOFF.md` was changed.
