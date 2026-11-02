# C46 — The Belt's Owner, Discipline by Discipline

**Decision date:** 2026-09-08  
**Scope:** research only; no runtime or data changes.  
**Rule:** a federation or tournament operator can own a championship event without owning a standing belt. The game must not call an event medal a belt.

## Decisions page

| Discipline | Call | Recommendation | Why |
|---|---|---|---|
| MMA | Promotion-owned | Keep a house belt, but only under the promotion that stages the title bout. | UFC, PFL and ONE publish promotion-branded world titles; this is a defended championship object, not an Olympic selection event. |
| Boxing | Sanctioning-body-owned in the real sport; absent in this catalogue | Do not assign a boxing belt to a generated market association. Keep the alphabet bodies out of the catalogue as J3 D4 requires. | The Ali Act treats a sanctioning organization as the ratings/sanctioning authority, separate from the promoter; no such body is present here. |
| Kickboxing | Promotion-owned for a house title | Keep only a named promotion's title (for example ONE or GLORY); do not create a universal kickboxing crown. | ONE lists discipline-specific world champions and GLORY calls its division title a GLORY World Championship. |
| Muay Thai | Promotion-owned for a house title; sanctioning-body-owned for an alphabet title | Keep RWS/ONE-style house titles only where the promotion explicitly owns the title; do not turn a generic belt into a WBC MuayThai belt. | ONE and RWS are event/promotion products, while WBC MuayThai explicitly sanctions its own championship contests and belts. |
| Wrestling | Federation-owned event | Do not seed a standing belt. UWW World Championships are a scheduled championship event and selection pathway. | UWW describes Worlds as its flagship event across freestyle, women's and Greco-Roman wrestling, not a defended promotion belt. |
| Judo | Federation-owned event | Do not seed a standing belt. A judo World Championship is an IJF event won on the tournament date, not a belt carried into a defence. | IJF calls Worlds its flagship event, with athletes competing in weight categories for the championship and ranking points. |
| Brazilian jiu-jitsu | Tournament-operator/federation event | Do not seed an IBJJF-style standing belt. Keep any future ONE submission-grappling title distinct from an IBJJF BJJ Worlds result. | IBJJF publishes World Championship brackets, medals and seasonal ranking points; ONE's page labels its relevant title “submission grappling,” not an IBJJF belt. |
| Karate | Promotion-owned for Karate Combat; federation-owned event for WKF karate | The catalogue's `karate_combat` belt may be a promotion belt; never merge it with a WKF World Championship. | Karate Combat explicitly records its World Champion and title fights; WKF describes Worlds as its foremost sport-karate event. |
| Taekwondo | Federation-owned event | Do not seed a standing belt. WT World Championships are federation-promoted competitions in the Olympic pathway. | WT's official event rules enumerate World Taekwondo Championships among WT-promoted championships. |
| Sanda (if present) | Federation-owned event | Do not seed a standing belt until an explicit professional promotion is catalogued. | IWUF describes the World Wushu Championships as the official world championship event, including sanda. |
| Sambo (if present) | Federation-owned event | Do not seed a standing belt until an explicit professional promotion is catalogued. | FIAS publishes World SAMBO Championships regulations with national delegations, medals and tournament formats. |

The operative answer is therefore not “federations are lower-tier promotions.” A judo, wrestling, taekwondo, BJJ, sanda or sambo World Championship is an event result. It does not create a champion who carries a belt and defends it in the next promotion card.

## Evidence

### Promotion-owned titles

ONE's official World Champions page has separate MMA, Muay Thai, kickboxing and submission-grappling champion entries, including interim titles. That is direct evidence of promotion-owned house championships, not evidence that ONE is the governing federation for those sports: [ONE World Champions](https://www.onefc.com/world-champions/). ONE also describes a featherweight MMA interim-title unification as a ONE World Title bout: [ONE 166 title unification](https://www.onefc.com/news/tang-kai-unifies-featherweight-mma-world-title-with-third-round-tko-of-thanh-le-at-one-166-qatar/).

GLORY's own release says its tournament champions become the division's champion and receive an opportunity to defend the title in single fights: [GLORY title release](https://glorykickboxing.com/news/rico-verhoeven-vacates-glory-heavyweight-title). Karate Combat's fighter record explicitly calls its award the Karate Combat Heavyweight World Championship and labels the athlete Heavyweight Champion: [Karate Combat champion record](https://www.karate.com/fighters/sam-alvey). Those are the correct shape for a standing promotion belt.

Muay Thai is not one universal ownership system. WBC MuayThai says it rates fighters and sanctions WBC MuayThai title events, and its profile describes a WBC MuayThai championship belt: [WBC MuayThai overview](https://wbcboxing.com/en/about-wbc-muay-thai/), [WBC MuayThai profile](https://wbcboxing.com/en/wbc-muay-thai-profile/). That supports a sanctioning-body-owned title when that body is actually in the catalogue. It does not authorize assigning a WBC belt to RWS, ONE, or a generated national association.

### Event-owned federation and tournament championships

The IJF calls the World Judo Championships its flagship event and describes the competition as fourteen individual weight categories whose results provide ranking points: [IJF World Judo Championships](https://www.ijf.org/news/show/baku-set-to-host-the-2026-world-judo-championships). UWW calls Senior Worlds its flagship event and lists freestyle, women's and Greco-Roman competition: [UWW World Championships](https://cms.uww.org/about-events/world-championships?base_route_name=entity.node.canonical&overridden_route_name=entity.node.canonical&page_manager_page=node_view&page_manager_page_variant=node_view-panels_variant-5&page_manager_page_variant_weight=-5). WT's event-operations rules enumerate World Taekwondo Championships among WT-promoted championships: [WT Event Operations Rules](https://www.worldtaekwondo.org/att_file/documents/WT%20Event%20Operations%20Rules%20as%20of%20September%2030%2C%202024.pdf).

IBJJF's official Worlds material is event language: athletes win gold in named divisions and receive medals, and the ranking page assigns points for placing at Worlds: [IBJJF 2026 Worlds recap](https://ibjjf.com/news/2026-world-championship-black-belt-recap), [IBJJF ranking information](https://ibjjf.com/athlete-ranking-info). This is why the table says tournament-operator/federation event rather than a belt.

For the conditional disciplines, IWUF describes the World Wushu Championships as the official world championship event and specifically includes sanda: [IWUF World Wushu Championships guidelines](https://www.iwuf.org/jscss/wp-content/uploads/pdf/F-16th-WWC-Media-Registration-Guidelines.pdf). FIAS publishes World SAMBO Championship regulations with national delegations and medals in sport, combat and blind sambo: [FIAS 2026 World SAMBO Championships](https://sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda/).

### Boxing boundary

The Muhammad Ali Boxing Reform Act requires a sanctioning organization to disclose its ratings criteria, bylaws, appeals process and general sanctioning-fee schedule; that is a title-authority overlay, not a promotion or signing pathway: [15 U.S.C. § 6307c](https://www.law.cornell.edu/uscode/text/15/6307c). J3 D4 therefore remains unchanged: WBA/WBC/IBF/WBO are not added to this catalogue, and a boxing belt cannot silently become a generated promotion belt.

## What the game does today

### Runtime contract in the permitted `WorldPopulation.gd` window

- `ensure_championships` at `WorldPopulation.gd:1040` groups every athlete by `discipline|weight_class|sex`, requires at least three contenders, chooses the highest `ranking_points` holder, and seeds `title_status = champion`. It does not filter to professional promotion disciplines.
- `organization_disciplines` at `:1137` trusts a named `disciplines` list; otherwise it derives disciplines from positive `discipline_weights`. A generated market association therefore advertises a discipline merely by having a positive local weight.
- `promotions_by_standing` at `:1155` excludes every organization whose `entity_type` is not `promotion`. This explicitly excludes IJF, UWW, WT and CMMAF federations; a tournament operator such as IBJJF is excluded too. A missing `entity_type` defaults to promotion, so generated market organizations are eligible.
- `sanctioning_organization_id` at `:1184` walks that tier/reputation/id ordering and returns the first eligible organization with an exact discipline match, or `""` when none exists.
- `ensure_championships` calls `_migrate_championship_organizations`; the visible migration contract at `:1197-1200` says the stamp is written once, is never overwritten by later catalogue changes, and uses the empty string when no promotion is found.

This means **no belt currently lands on a federation**. The code intentionally rejects them. The current categories are:

| Discipline | Catalogue entries that can be selected | Current landing category |
|---|---|---|
| MMA | UFC, PFL, ONE, RIZIN, Jungle Fight, LUX, ROAD FC, ARES FC, URCC; CMMAF is excluded | Promotion (UFC is first when the full real catalogue is present: S-tier, reputation 99) |
| Boxing | No named catalogue organization | Generated market association if its positive `discipline_weights` includes boxing; otherwise `organization_id = ""` |
| Kickboxing | ONE, GLORY, RIZIN, Kunlun; no federation | Promotion (ONE is first when present) |
| Muay Thai | ONE, RWS; no federation | Promotion (ONE is first when present) |
| Wrestling | UWW only, and UWW is excluded | Generated market association if available; otherwise empty |
| Judo | IJF only, and IJF is excluded | Generated market association if available; otherwise empty |
| Brazilian jiu-jitsu | ONE is a promotion; IBJJF is a tournament operator and is excluded | Promotion (ONE when present), but this is not evidence of an IBJJF-style belt |
| Karate | `karate_combat`, a promotion | Promotion (Karate Combat) |
| Taekwondo | WT only, and WT is excluded | Generated market association if available; otherwise empty |
| Sanda / sambo | No named catalogue organization | Generated market association if available; otherwise empty |

The data correction matters: the task premise's “four federations” is not true for this JSON. `karate_combat` is `entity_type: "promotion"`; `ijf`, `united_world_wrestling` and `world_taekwondo` are the federation entries. `ibjjf` is `tournament_operator`. The runtime nevertheless still misrepresents event disciplines whenever a generated market organization supplies the fallback.

The actual generated fallback id is population-dependent and is not present in the two permitted source files. The invariant that can be stated exactly from this window is stronger and safer: **federations never receive a belt; a generated market association receives one only when its positive weights match; no match is preserved as empty.**

## Minimum change — build order, not a new system

1. Define belt eligibility as a catalogue fact: promotion-owned belts for MMA, kickboxing, Muay Thai and Karate Combat; no generic belt for federation/tournament disciplines. Keep boxing alphabets out.
2. Stop creating or retaining a standing belt for judo, wrestling, taekwondo and IBJJF-style BJJ; do the same for sanda/sambo if they appear. Do not substitute the first generated association. Their real result is an event/championship result, not a defended belt.
3. For the surviving house belts, make the authority promotion-specific before any new save writes them. The current global key can make a Jungle or ONE win look like the same world belt; an eventual `org_id|discipline|weight_class|sex` key is the honest shape.
4. Add a save migration version that retires or marks existing event-discipline belts as legacy/event-only and prefixes surviving stamped promotion belts with their existing authority. Because the current stamp is write-once, a catalogue correction will not repair old saves by itself.

## Migration cost by option

| Option | Existing saves | Cost / risk |
|---|---|---|
| Leave global belts as-is | No migration | Cheapest code path, but keeps a generated association as a fake world champion and leaves event sports wrong. Reject. |
| Stop seeding event disciplines | Existing judo/wrestling/taekwondo/BJJ belts need an explicit migration decision; do not silently hand them to a federation | Smallest honest change, but old belt reads need a legacy/event-only outcome and save fixtures need coverage. |
| Make surviving belts promotion-scoped | Prefix existing non-empty promotion stamps with the old authority; resolve collisions and update every read/write of the key | Medium migration: key shape changes and old global keys must remain readable during one migration. The write-once stamp means this is additive, not a fresh resort. |
| Add a federation championship-event object | Existing belts still need retirement; event results need a separate schema and calendar/result migration | Largest option and outside the belt fix. It is a second competition object, not a justification for keeping the belt. |

## Explicit non-decisions

- No WBA/WBC/IBF/WBO catalogue expansion.
- No universal Muay Thai or kickboxing belt.
- No claim that ONE's submission-grappling title is an IBJJF title.
- No generated “national world champion” for an Olympic/federation discipline.
- No belt artwork or brand assets; the repository's text-only brand policy remains the right boundary.

