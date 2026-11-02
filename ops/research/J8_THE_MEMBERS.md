# J8 — The Members: Who Walks In, and What Makes Them

**Desk:** John (research)  
**Date:** 2026-09-07  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design. No second career mode (J2 §6.2). No fitness-chain sim. No manager-simulator.  
**Local snapshot used:** `TASK_J8.md`; `J5_THE_GYMS_OWN_LEDGER.md`; `gym_distribution.json` (country rows: `population`, `gdp_per_capita_usd`, `culture_tier`, `gym_count`); `equipment_catalog.json` v2 (`purchase_cost`, `weekly_upkeep`, `station_capacity`, `quality_tier`, `base_safety`, `footprint`); `GameState_fame.excerpt.txt` (`gym_reputation` `:2834`; `leading_athlete_fame` `:2844`); `GameState_creation.excerpt.txt` (`get_creation_city_board` `:12640`; `get_creation_gym_take` `:12670`). Line numbers are from this workspace excerpt.

**Cite, do not re-litigate:** J1 (UNKNOWN policy, §4.1 brand). J2 (three **entry/money** pathways, §5.1 scenery, §6.2 unplayed-mode, §6.3 no invented numeric default). J3 (D1–D16, Areas 1–3). J4 (**E1–E3 not reopened**; E23 default gym delta **0**). J5 (**G1–G18 cited, not reopened**; **G1 / G3 / G9 / G10 / G17 / G24**; **priority ruling** rank-2 membership object). J6 (**A15 / A16**: athlete-side dues are the same object; this pack does not outrank J5 rank 2). J7 (**P14**: classification of a shipped GAME RULE does not outrank membership). R40 / J2 D6. R43 payee stands. **Do not reopen J4 E1–E3, J5 G1–G18, or R40.**

**UNKNOWN policy (same as J1–J7):** a fee, a period, a percentage, a cap, a growth rate, an elasticity, or a formula that is not in a primary statute, regulation, commission form, an organization’s own published page, or a named industry-body table is **UNKNOWN**. Never invent one. Inherited practice is **INHERITED** / **CUSTOMARY**, not a published rule. National overlays are **NATIONAL**. A gym’s own posted rate is **primary for THAT gym**, not for the sport. No real gym’s, manager’s, official’s, athlete’s, or executive’s name as **data**. Named facilities appear in this pack only as a **product class** already ruled scenery (J5 **G17** UFC Gym / fitness-chain) or as a **kind** of source, never as a catalog row.

**Number marks (C27 ledger read + this pack):** every figure is **evidenced** / **customary** / **invented** / **UNKNOWN**. Game objects use C27’s `source ∈ {evidenced, invented, absent}`. An authored gameplay number is fine; an authored number wearing a citation is not (J5 **G24**). M8’s AUTHORED chip already consumes `invented`.

**No fifth area.** After the four, a playable fitness-chain / kids-program / PT-studio / ClassPass-aggregator career is **scenery**, not a fifth research track. J5 **G17** stands.

---

## Why this exists

J5 **G3** ruled the honest post-R43 floor: **a gym lives on its training floor, not on a cut of the purse.** J5 **G1** refused to author a sport-wide dues number. **G24** made that a hard constraint. R44 will ship the membership line as an **authored, labelled** weekly credit, because that is all J5 permits.

R44 alone gives the desk a **flat** number. The operator’s call (2026-09-07) is that the number should **move**: a gym with a famous fighter on the roster and a real floor of equipment in a big city should draw members that a back-room in a small town does not. That is a demand model. Nobody had researched whether any of it is **published**, **customary**, or **pure invention**.

This pack is that research. It does **not** reopen J4 E1–E3 or J5 G10: there is still no `gym_cut`, and members are not a way to smuggle one back in.

**The true answer is smaller than a demand-curve would like.** Fitness-industry bodies publish *why people exercise* and *where a health club sites*. Combat-gym software vendors publish *what their schools collect*. Nobody publishes a formula that maps `gym["reputation"]`, `leading_athlete_fame`, `quality_tier`, or country GDP onto a member count. **“The count may stay flat forever without lying” is an acceptable answer.** Movement, if wanted, is a **labelled invention** sitting on two honest objects (capacity ceiling; city catchment *direction*) and must not wear a citation.

---

## Decisions page (operator calls)

This page is what the next research/build cuts from. One recommendation, one line why. Numbered **N1–N22** so nothing collides with J3 D1–D16, J4 E1–E34, J5 G1–G34, J6 A1–A18, or J7 P1–P16.

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| **N1** | Sport-wide dues / membership dollar | **Do not author one.** Cite J5 **G1 / G24**. A gym’s own posted rate is primary for **that** gym. Aggregated “typical monthly” (vendor ~$100 collected; fitness-club medians) is **not** MMA / boxing / Muay Thai as a sport. | No commission, ABC page, or catalog org publishes a gym-dues table. J2 §6.3. |
| **N2** | What R44 ships now | **A flat authored weekly membership credit**, labelled `source: invented` (or `evidence` pointing at **that gym’s** posted page). Member **count** is a constant. Dollar = count × authored weekly rate, both labelled. If no rate is filed, **omit the line** — do not invent USD 0 as a fake fee. | J5 G3 / G18 rank 2. R44 is the object. This pack does not invent the magnitude. |
| **N3** | Does the count move in R44? | **No.** R44 is the **flat** labelled credit. Movement is R45, and only after the gates in N21. | Operator asked the number to move. Research found no published coefficient. Flat is honest. |
| **N4** | Operator’s three hypotheses vs evidence rank | **Evidence ranks them differently.** Combat-gym demand, as published and as customary, is **coach + class structure + community first**; **city catchment / income / rivals** second (direction published for *health clubs*, not a combat-gym elasticity); **equipment as a capacity ceiling** third; **gym reputation** customary and unmeasured; **famous-athlete halo** customary marketing, **UNKNOWN as a number**. | The operator guessed fame / equipment / city as co-equal movers. Coach is the missing lead. Fame is the weakest of the three as evidence. |
| **N5** | Gym fame — `gym["reputation"]` / `gym_reputation` (`:2834`) | **CUSTOMARY brand talk, not a published demand function.** Do **not** wire `reputation → members` as evidenced. If R45 ever uses it, it is **invented** scenery on an already-live game object, labelled as such. | HFA/IHRSA tables do not publish “club reputation → join rate.” Franchise brand is a different product (G17). |
| **N6** | Famous athlete on roster — `leading_athlete_fame` (`:2844`) | **CUSTOMARY marketing (“a champion trains here”), UNKNOWN as an elasticity.** Journalism reports inquiry spikes around fights and films; no trade-body table maps fighter fame onto recreational headcount. Do **not** ship `fame × k` wearing a citation. | Halo is a *kind*. Coefficient is invention. Named athletes are not data (G34). |
| **N7** | Coach quality | **The strongest combat-gym demand *kind* in the retrieved record, and still UNKNOWN as a number.** Recreational members pay for instruction, a class that starts on time, and a room that knows their name. Rank coach **above** gym fame and athlete fame. Do **not** author a coach→members %. | Qualitative papers and operator copy agree on the *kind*. No IHRSA/HFA/FDD row publishes the coefficient. |
| **N8** | Equipment: capacity vs attraction | **Honest model = capacity + upkeep. Attraction is authored scenery.** `station_capacity` already counts how many can train at a station. `quality_tier` does **not** systematically raise capacity in the live catalog. Do **not** ship “better bags pull members from the gym across town” as evidenced. | IBC **50** gross sq ft/occupant is egress, not a join curve. Crowding causes *cancels* (retention), which is not the same as attraction (acquisition). |
| **N9** | Floor-area-per-member | **Two different objects. Do not mash.** IBC 2024 Table 1004.5 **Exercise rooms = 50 gross sq ft per occupant** (**evidenced**, egress). A 2019 IHRSA capacity article restates a consultant roster-density of **2.5 members / m²** ≈ **10.76 sq ft / member** (**customary**, commercial-club build, not combat-gym, not code). Combat-gym sq-ft-per-member as a sport table: **UNKNOWN**. | Code caps simultaneous bodies. Consultant density is a *kind* of commercial-club planning. Neither is a FightCamp default. |
| **N10** | Occupancy / utilisation / station ratios | **Capacity is countable; utilisation is UNKNOWN as a combat-gym published %.** Catalog copy already: a heavy bag supports **one** athlete in a scheduled session (`station_capacity`: **1**, **evidenced** as the game’s own authored fact, not as a sport rule). Peak-hour wait as a cancel reason is **customary** health-club retention talk. Do **not** author an occupancy %. | Utilisation without a study is a 2am decision. Station count is already honest. |
| **N11** | Equipment spend per member | **UNKNOWN as a combat-gym published figure.** IHRSA’s equipment report (2015 sample: clubs spent an average **$84,000** that year — **evidenced as that survey, stale**) is health-club cardio/strength, vendor-sponsored, not a bag-and-ring schedule. Live catalog already authors `purchase_cost` / `weekly_upkeep` as **invented** gameplay. Keep them; do not retune from this pack. | G24: no sport-wide dollar. Catalog costs stay labelled invented. |
| **N12** | Which of the four `gym_distribution.json` fields may drive membership demand | **None as evidenced coefficients. Two as labelled *direction* if ever, and only at the right geographic grain.** `population` and `gdp_per_capita_usd` are **country** rows; published demand is **trade-area / household**. `gym_count` is country-level; published saturation is **city rivals** (already on the creation board). `culture_tier` is **invented**. See N13–N16. | Country GDP is not a city’s catchment. Creation already picked the city. |
| **N13** | Catchment / `population` | **Country population must not drive gym membership.** Published health-club siting: **≥ 60,000**, preferably **100,000+** people *in close proximity*; primary trade area **8 minutes**, secondary **12**; “upwards of **80%** of members from within 12 minutes” (IHRSA/HFA site-selection pages — **evidenced as that published claim**). Mini-facilities can succeed smaller. Combat-gym catchment as a numbered table: **UNKNOWN**. If R45 moves on location, key off **city** (creation already has cities and `rival_gyms`), labelled invented magnitude. | China 1.4 billion vs a five-million-person country is a category error at the front desk. |
| **N14** | Income / `gdp_per_capita_usd` | **Direction is published for health-club *penetration*; country GDP is a crude proxy; coefficient UNKNOWN.** IHRSA/HFA: household income correlates with membership; a published older claim is that below **$25,000** HHI, **7.2%** (1 in 14) are members (**evidenced as that page; threshold is stale**). HFA 2026: penetration rose across **every** income bracket in 2025 (**evidenced as direction**, bands **not retrieved** this pass). Do **not** map country `gdp_per_capita_usd` onto a member dollar. Optional later: an authored **affordability** flag, labelled invented. | Income is why a city can *support* dues. It is not a headcount formula. |
| **N15** | `culture_tier` / `combat_popularity` / `talent_depth` | **Invented game fields. Do not cite them as evidenced demand.** `WorldPopulation` already derives `talent_depth` and `combat_popularity` from the country row. Those are honest as **talent / culture scenery**. They are not a published “people join gyms here” table. If R45 uses `combat_popularity` as a labelled invented modifier for *combat-gym* vs general-fitness demand, say so on the chip. | Culture_tier is the game’s own ladder (S/A/B/C). Membership is not talent_depth. |
| **N16** | Saturation — `gym_count` as competitors | **Direction is real at the *city* grain; country `gym_count` is the wrong object.** More clubs in a trade area cap growth — **customary** site-selection / franchise-territory practice; HFA 2025 notes independent clubs under **$1.5M** grow slowest (**evidenced as that report’s size split**, not a combat-gym density law). Creation already exposes `rival_gyms.count` per city (`:12666`). If R45 saturates, use **city rivals**, labelled invented, never country `gym_count` as a member divisor. | `gym_count` in this file is how many gyms the game *authored for the country*, not how many competitors sit on the same street. |
| **N17** | Rent / creation as economic trade-off | **Cost, not demand. Direction of the trade-off is customary; dollars UNKNOWN as a sport table.** Cheap small-town rent + few members vs expensive city + many is how operators talk, and it matches IHRSA catchment. HFA 2025: high-profit clubs have **lower occupancy costs** (**evidenced as that split**); occupancy-cost **% of revenue** in the full report **not retrieved** this pass. Live game already authors `weekly_upkeep` and starter `used_space` / `total_space` on the take (`:12684`). Do **not** invent a rent line or a rent→members curve. Creation-as-trade-off, if shown, is **authored + labelled**: upkeep vs (later) a labelled member credit — not a sourced rent table. | Rent is the other side of `_settle_billing`. It does not pull walk-ins. |
| **N18** | Headcount ceiling — when this becomes a fitness-chain sim | **A combat gym is dozens to low hundreds of members, not thousands.** Vendor-observed martial-arts schools (Gymdesk 2026, 4,594 gyms) bucket **under 50 / 50–99 / 100–199 / 200+**. A licensed MMA-oriented **fitness chain** FDD discloses **thousands** of members on **30,000–45,000** sq ft boxes — that is J5 **G17 scenery**, not the player’s desk. **Refuse** chain occupancy-management, franchise territory, kids-program-as-second-career, PT-studio career, merch-shop sim, ClassPass. | The moment the member count looks like a Signature box, FightCamp has left the building. |
| **N19** | Churn / retention | **Real as a *kind*; do not author a default %.** HFA 2025 Benchmarking: **66.4%** annual member retention, 175 companies / 17,000+ facilities, 2024 data (**evidenced for health/fitness clubs, not combat gyms**). Gymdesk 2026 martial-arts: rare attenders cancel **44.2%** over 24 months vs **23.2%** at 3+ visits/week; ~**1 in 5** new members quit inside 90 days; then a drip of **2–3.5%** a month (**vendor-observed / secondary**, not a sport rule). Do **not** ship 33.6% churn or 2% monthly as a game default (J5 **G9**). | Retention is why a flat credit is stabler than a growth loop. A churn % is a default percentage. |
| **N20** | Seasonality | **Direction published; coefficient UNKNOWN; do not ship a seasonal %.** HFA 2025: net growth concentrated in **January and Q1**; attrition pressure **late summer / early fall**. Gymdesk martial-arts: a **January** cancel spike among resolution joiners. Combat-gym seasonal curve as a numbered table: **UNKNOWN**. R44 is weekly and **flat**. A January bump is scenery unless labelled invented. | Seasonality is a fitness-industry fact. It is not a FightCamp default. |
| **N21** | Dues vs class-packs / PT / merch — share of revenue | **Dues (or tuition) are the majority *kind*. Do not author a split %.** HFA 2025: membership dues **76.5%** of revenue worldwide, non-dues **23.5%** (PT, wellness, ancillary); US non-dues **29.5%** (**evidenced for responding fitness clubs**). Gymdesk martial-arts: monthly plan is about **63%** of enrolled; almost **90%** of gyms run more than one price kind (monthly + drop-in + trial) (**vendor-observed**). Combat-gym PT / merch **share: UNKNOWN** as a published table. Class-packs and drop-ins are **customary** product shapes (J5 Area 1). R44 ships **one** weekly credit, not a four-line till. | A second career in privates and gis is G17 in a shop coat. |
| **N22** | **Minimum change** (this study’s D16 / E18 / G18 / A18 / P15) | **R44: flat labelled weekly credit, no moving count. R45: count may move only as labelled invention on (1) a capacity *ceiling* from `station_capacity` and (2) city catchment / rivals *direction* — never as evidenced fame or equipment-attraction.** Four one-liners in each area’s (d). If the operator would rather the count **never** move, that is the more honest reading of the published record. | Stops a demand-curve lie without reopening G1 or G10. |

**Fifth area?** No. A playable fitness-chain / kids-program / PT / merch career would be a new mode. It does not outrank shipping the membership *object* as J5 ranked it. Park it as scenery (priority ruling).

---

## File-level anchors (what is live vs this study)

| File / fact | Role | Live? | Honesty (`source`) |
|-------------|------|-------|-------------------|
| Membership / dues / drop-in object | Gym inflow after R43 | **Absent** | **absent** — the real-world floor (J5). R44 ships the object. |
| Sport-wide `membership_usd_per_month` | — | **Absent** | **Honest absence** (G1 / G24). Keep it absent. |
| Member **count** | — | **Absent** | **absent**. R44 may author a **flat** count, labelled **invented**. |
| Member-growth **%** | — | **Absent** | **Honest absence** (G9). Do not add one. |
| `gym["reputation"]` / `gym_reputation` `:2834` | Office summary | LIVE | Game object. **Not** a published demand driver (N5). |
| `leading_athlete_fame` `:2844` | Office summary | LIVE | Game object. **Not** a published elasticity (N6). |
| Staff / `coach_count` `:2830` | Office summary | LIVE | People exist. Coach→members **%** is **absent** (N7). |
| `equipment_catalog.json` v2 | Floor items | LIVE | `purchase_cost` / `weekly_upkeep` **invented** gameplay; `station_capacity` **invented** as magnitude, **honest as a count-shape**; `quality_tier` **invented** scenery unless used as safety/training, **not** as member-pull. |
| `gym_distribution.json` | Country row | LIVE | `population` / `gdp_per_capita_usd` look like statistics; they are **not** a gym catchment. `culture_tier` **invented**. `gym_count` is authored world-gen, **not** street-level competitors. |
| `WorldPopulation` `talent_depth` / `combat_popularity` | Derived from country row | LIVE (creation board `:12630`–`:12631`) | **Invented** culture/talent scenery. Not membership. |
| `get_creation_city_board` `:12640` | Country → cities, `rival_gyms` | LIVE | Honest **shape** of a city competitive set. No member credit on the board. |
| `get_creation_gym_take` `:12670` | Starter floor, roster silhouettes, `weekly_upkeep`, space | LIVE | Honest **cost** preview. No membership inflow preview. |
| `_settle_billing` | Payroll + upkeep debit | LIVE (J5) | Honest **shape** of a monthly bill. Magnitudes **invented**. Credit side still the hole R44 fills. |
| `Sponsorship.settle_week` | Gym-entity cheque | LIVE (J5 G16) | **invented** magnitude; honest **shape**. Do not retune here. |
| `gym_cut` | — | **Absent** | **Honest absence** (E3 / G10). Not reopened. |
| UFC Gym / PI / promoter-owned gym as the player | — | **Absent** | **Honest** (G17 scenery). |

---

# Area 1 — Demand: what actually draws a member to a combat gym

What is **published** (industry association data, franchise disclosure, operator surveys, trade bodies such as IHRSA/HFA, municipal filings) about why people join a boxing / MMA / Muay Thai gym, and in what proportion. Separate a **published figure** from **CUSTOMARY** trade journalism from **UNKNOWN**. Test the operator’s three hypotheses as their own calls: gym fame, a famous athlete on the roster, the coach.

## (a) Decisions coming (named as calls)

1. **Call: published vs customary vs unknown motives.** Why a recreational adult walks into a combat gym.
2. **Call: gym fame** (`gym["reputation"]`).
3. **Call: famous athlete** (`leading_athlete_fame`).
4. **Call: coach quality.** Rank against the operator’s guess.

## (b) Evidence (cited) + UNKNOWN discipline

### Fitness-industry bodies publish *exercise*, not *this gym*

HFA (formerly IHRSA) is the trade body for health clubs, studios, and fitness facilities. It is **not** a combat-sports commission and **not** a martial-arts school association. Its tables are the best published demand record this pass retrieved. They describe **why Americans use fitness facilities**, not why they pick a striking gym over the club down the street.

| Claim | Figure | Kind | Usable as a FightCamp default? |
|-------|--------|------|--------------------------------|
| US fitness-facility members, 2024 | **77 million**; **24.9%** of Americans aged 6+; ~**96 million** including non-member users (**31.0%**) | **evidenced** — HFA 2025 US Health & Fitness Consumer Report: Headline Trends (2025-04-07) | **No.** Population penetration is not a gym’s headcount. |
| US fitness-facility members, 2025 | **81 million** (**+5.2%** vs 2024); **26.1%** penetration; **>100 million** including non-members; ~**7 billion** visits; unused-membership share **4.6%** | **evidenced** — HFA 2026 Consumer Report: Headline Trends (2026-04-09); ~18,000-resident survey with Sports Marketing Surveys USA / PAC | **No.** Do **not** ship **5.2%** as a member-growth default (G9). |
| 2024 membership growth vs 2023 | **+5.6%** (after **+5.8%** in 2023) | **evidenced** — HFA 2025 Expanded Insights / Headline Trends | **No.** Same G9 ban. |
| Why facilities matter to resolvers | **88%** of fitness-focused New Year resolvers say access to a facility is important; **61%** “very important”; **58%** keep an existing membership; **23%** plan to join a new one; cost is a top barrier for nearly **one-third** | **evidenced** — HFA New Year resolutions survey, 2025-01-07 | Direction only. Not a combat-gym motive table. |
| Latin America active consumers (metro survey) | Facilities as primary location **55%**; valued for effectiveness **35%**, convenience **32%**, equipment access **29%**; motives: general health **44%**, mental well-being **40%**, self-confidence **36%** | **evidenced** — HFA / ABC Fitness 2024 Latin America Fitness Consumer Survey (2024-12-04) | **Not** US combat gyms. Motive *kinds* (health, mental, confidence) match qualitative combat papers. |
| HFA 2025 in-club mix | **23%** of members used a PT in 2024; **32%** small-group; **>25%** belong to more than one facility; **>75%** of studio users hold another membership | **evidenced** — HFA 2025 Expanded Insights (2025-10-30), 18,000-resident survey | Multi-membership is a health-club fact. Do not model a second-club career. |

**UNKNOWN (do not invent):** a published IHRSA/HFA row that splits “joined because of gym fame / a champion on the wall / the head coach / the bags” in any proportion. That table was **not retrieved** and is not assumed to exist.

### Combat-gym motives: qualitative and customary, not a % table

Retrieved academic and trade copy, labelled:

| Motive *kind* | What the record actually is | Kind |
|---------------|-----------------------------|------|
| Fitness / a hard class that is programmed for you | Boxing and MMA operator copy, and qualitative interviews, contrast a combat class (coach, rounds, someone watching) with a 24-hour gym (equipment access, you are on your own) | **CUSTOMARY** product distinction. Not a survey % |
| Self-defence, confidence, discipline | Recurring in martial-arts motive papers (e.g. karate/judo/taekwondo motive inventories: self-defence and physical exercise at the top of rated items) and in 2025 Australian MA&CS qualitative work (resilience, confidence, community) | **CUSTOMARY / academic qualitative.** Not a US MMA join-share |
| Community / belonging | Same qualitative cluster; combat classes force partners | **CUSTOMARY.** HFA also talks “community” for fitness clubs — the *kind* is shared, the *mechanism* (a class that needs a partner) is combat-shaped |
| “A champion trains here” | Marketing pages, gym-rank listicles, celebrity-clientele features | **CUSTOMARY marketing.** Inquiry-spike journalism around boxing films (secondary 2023: some gyms reported **30–50%** more *inquiries* — **not** retained members, **not** a trade-body table, **do not wire**) |
| Equipment quality as the reason they joined | Combat-gym copy more often says the opposite: instruction beats a shiny floor | **CUSTOMARY**, and it **cuts against** equipment-as-attraction |

**Do not** turn any named academy’s coaches page into a catalog row. **Do not** average gym websites.

### Test 1 — gym fame (`gym["reputation"]`)

**Published elasticity: not retrieved.**

HFA’s consumer and benchmarking reports break members by age, gender, income, facility *type* (fitness-only, multipurpose, studio, non-profit), dues band, and chain vs independent. They do **not** publish a reputation score, a Google-star coefficient, or “famous gym → +N joins.”

What exists instead:

- **Franchise brand** as a siting/marketing asset — that is a licensed fitness-chain product. J5 **G17**: scenery. A 2025 FDD for an MMA-oriented fitness chain reports **thousands** of members per Signature/FIT box (see Area 4). That is brand-as-chain, not `gym["reputation"]` as the player’s independent desk.
- **Independent combat-gym “name”** — customary. Fighters migrate to rooms with a reputation for producing killers. That is **fighter** talent flow (the game already has `talent_depth`), not recreational **member** demand. Mixing the two is how a gym sim becomes a prospect-factory.

**Ruling on N5:** `gym_reputation` may stay on the office summary as flavour. It is **not** evidenced demand. R45 may not raise the member count from it without an `invented` label.

### Test 2 — a famous athlete on the roster (`leading_athlete_fame`)

**Published elasticity: not retrieved.**

The halo is a real *marketing sentence*. It is not a measured join curve.

- Secondary features of named high-level rooms describe recreational memberships in the **hundreds** beside a professional roster (one 2019 secondary tour of a named European MMA gym: **500** general members, **200** under 18, plus a handful of listed-promotion athletes). That is **one gym, one year, secondary**. **Do not** author 500. **Do not** ingest the names.
- Film / celebrity-bout journalism (2023 secondary) reported **inquiry** spikes, not audited retained members. Inquiries are not dues.
- A fighter opening or lending a name to a gym is **customary** as a press event. Resulting headcount: **UNKNOWN**.

**Ruling on N6:** `leading_athlete_fame` is a true game object and a true marketing *kind*. It is **UNKNOWN as a number**. Shipping `members += fame / k` as if HFA measured it would be G24 in a halo coat.

### Test 3 — the coach

**Published coefficient: not retrieved. Rank: above the other two.**

The retrieved combat-gym record, such as it is, talks about **instruction** the way a health club talks about **equipment**.

- Martial-arts operator copy (customary): the membership buys coaching, a curriculum, a standing appointment, and a skill — not a room of machines. Regular gyms sell access; combat gyms sell a person who corrects you.
- Qualitative MA&CS research (2025, Australia; earlier US boxing ethnography): coaches and experienced peers as the mechanism of confidence and belonging; join stories start as “a good workout / self-defence / a challenge,” and stay for the room.
- HFA 2025 Expanded Insights: members blend equipment, formats, and **coaching**; **23%** used a PT, **32%** small-group — **evidenced for US fitness members**, which is the closest published “instruction matters” row, and it is still not a combat-gym coach ranking.

The game already has staff with quality. That is the right *object*. A coach→members percentage would be G9.

**Ruling on N7:** If the three hypotheses must be ranked for R45 flavour, rank **coach (kind, no %) > city catchment (direction, no %) > gym reputation (customary, unmeasured) ≈ famous athlete (customary halo, unmeasured)**. Equipment is Area 2 and is a **ceiling**, not a magnet. **Say so to the operator: the evidence does not match the guess.**

### Franchise disclosure is the wrong product

FTC Franchise Rule Item 19 is **primary for that franchise system**, not for an independent combat gym.

This pass retrieved, without ingesting operator names as data:

- An MMA-oriented **fitness-chain** FDD (Signature/FIT model): member counts in the **thousands** per box, dues a large but not exclusive share of revenue, **30,000–45,000** sq ft. **G17 scenery.** Cited in Area 4 as the ceiling, not as the player.
- Boutique **boxing-fitness** / kickboxing-circuit FDD Item 19s: annual gross in the **low-to-mid hundreds of thousands USD** per studio (one boxing-fitness system: franchised 2024 average gross **$422,065**, median **$406,183**, n = 88 studios open ≥ 10 months — **evidenced as that FDD restatement**). That is a **class-fitness** product, closer to Orangetheory than to a fight gym.
- At least one kickboxing-circuit FDD: Item 19 **absent** in a 2025 filing (secondary franchise databases). Absence is information.

**Do not** average FDD AUVs into a FightCamp dues number. **Do not** use chain member counts as the player’s headcount.

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| Why a member joins | none | **absent** |
| `gym_reputation` as a member magnet | exported on the office summary; not wired to cash | Live **flavour**. Demand function **absent** (correct) |
| `leading_athlete_fame` as a member magnet | exported; not wired to cash | Same |
| Coach quality → members | staff exist; no join curve | **absent** (correct as a %) |
| Membership credit | none | **absent** — R44 |

## (d) Minimum change

**Do not author a demand ranking as numbers. If R44 needs flavour copy, the honest sentence is: people pay this gym for a class and a coach, not for a purse cut and not for a reputation score. Do not raise `gym_reputation` or `leading_athlete_fame` into a join formula. Do not author a coach %. Rank coach above fame in any later labelled invention.**

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — “HFA says membership grew 5.2%, so we ship 5.2%.”**  
**Solution:** N1 / N22 / G9. That is industry penetration, 2025 vs 2024, United States, all facilities. It is **evidenced** as a headline and **forbidden** as a default.

**Issue 2 — “A champion trains here, +X members.”**  
**Solution:** N6. Halo is customary. Coefficient is UNKNOWN. Named fighters are not data.

**Issue 3 — Operator guess vs evidence rank.**  
**Solution:** N4 / N7. Tell the operator. Coach is the lead *kind*; fame is the weakest evidenced of the three.

**Issue 4 — UFC Gym / boxing-fitness FDD looking like combat-gym demand.**  
**Solution:** G17 / N18. Different product.

**Issue 5 — Brand / named gyms’ coaches pages.**  
**Solution:** J1 §4.1 / G34. Cite the *kind*. No names in `assets/data`.

---

# Area 2 — Equipment: attraction, or capacity?

`equipment_catalog.json` v2 already carries `purchase_cost`, `weekly_upkeep`, `station_capacity`, `quality_tier`, `base_safety`, and `footprint`. The question is which of two mechanics the evidence supports: **capacity** (how many the floor can hold) or **attraction** (better gear pulls members from rivals). This is the most decision-shaped question in the pack.

## (a) Decisions coming (named as calls)

1. **Call: capacity vs attraction.**
2. **Call: floor-area-per-member / IBC occupant load.**
3. **Call: station ratios and occupancy %.**
4. **Call: equipment spend.**

## (b) Evidence + UNKNOWN

### The live catalog is already a capacity object

Every item authors `station_capacity` and `footprint`. The heavy-bag row states the design intent in plain words: “Every bag supports one athlete in a scheduled session.” `station_capacity`: **1**. That is the game’s own honest count-shape (**invented** as a sport rule, **honest** as a station).

`quality_tier` (1–3) does **not** move `station_capacity` in lockstep. A quality-1 heavy bag is 1 station; a quality-3 rehab pool is 3 stations because it is a **pool**, not because it is “nicer.” Attraction-from-tier is not in the file. Do not add it from this pack.

`weekly_upkeep` is already the cost side of owning the station. J5: the gym pays upkeep. Membership, if it exists, is the offsetting credit — not a quality multiplier.

### Occupant load is code, not a join curve

**IBC 2024 Table 1004.5**, function **Exercise rooms**: occupant load factor **50 gross** sq ft per occupant (**evidenced**, ICC 2024 IBC §1004.5 / Table 1004.5, verified 2026-09-07). This sizes **means of egress** for people **in the room at once**. It is not “how many memberships a combat gym sells.”

A 2019 IHRSA capacity-management article restates a consultant (GCB) new-build roster benchmark of **2.5 members per m²** (≈ **10.76 sq ft per member on the roster**) (**customary**, commercial club, one consultant’s clients). Same article: **5.5%** of members on average felt their club was overcrowded; of those, **55%** blamed cardio (treadmills), **47%** group fitness, **38%** the gym floor. That is **health-club crowding as a satisfaction complaint**, not a combat-gym attraction function.

**UNKNOWN:** combat-gym published sq-ft-per-member; published bag-to-member ratio; published ring-to-member ratio; published peak occupancy % for independent MMA / boxing / Muay Thai schools.

### Crowding is retention, not acquisition

Health-club retention copy (IHRSA/HFA and vendor blogs repeating it) treats peak-hour waits as a **cancel** reason. One 2025 vendor restatement claims **41%** of cancellations cite overcrowding as primary or contributing and attributes it to “IHRSA Consumer Report, 2024” — **the underlying HFA table was not retrieved as a primary this pass**; treat **41%** as **UNKNOWN / unverified**, not as evidenced. The *kind* (waits make people leave) is **customary**.

That kind, if modelled at all, is a **ceiling / dissatisfaction** on an already-joined member, not a magnet that steals the rival’s pipeline. Attraction (“our new rower made them join”) is the claim equipment vendors sell. IHRSA’s own equipment report (Precor-sponsored, 2015 sample, **$84,000** average equipment spend that year; cardio **45.9%** of equipment spend) says quality “plays a significant role in attracting and retaining members” — that is **sponsor-adjacent customary**, **stale**, and **not a coefficient**.

### Station ratios in commercial gyms are the wrong sport

Vendor “rules of thumb” (one treadmill per 25–40 members, one squat rack per 80–120) are **customary commercial-gym** planning. A combat gym’s bottleneck is bags, a ring or mat, and **a coach**. The catalog already encodes the first two as `station_capacity`. The coach is staff. None of those vendor ratios is a combat-gym publication.

**Ruling on N8:** ship **capacity + upkeep**. `Σ station_capacity` (and floor `footprint` / `used_space`) may later **cap** concurrent training and, if the operator insists on movement, cap the **authored** member count from above. `quality_tier` does not pull members. Attraction copy may exist as flavour (a nicer ring in the room). It does not move the credit.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| `station_capacity` | LIVE per item | **invented** magnitude; honest **count-shape** |
| `weekly_upkeep` / `purchase_cost` | LIVE | **invented** dollars (G24) |
| `quality_tier` | LIVE 1–3 | **invented** scenery unless used for safety/training mods already on the item |
| `footprint` / `used_space` / `total_space` | LIVE on the take | Honest **space** object |
| Equipment → member attraction | none | **absent** — correct |
| Occupancy % | none | **absent** — correct |
| IBC 50 sq ft cap | none | **absent** — correct as MVP; do not silently import code as a join curve |

## (d) Minimum change

**Do not add an equipment-quality attraction multiplier. Keep `station_capacity` and `weekly_upkeep` as they are. If R45 is allowed to move the count, the equipment contribution is a ceiling (`members_cap` from stations and/or floor area), labelled invented as a gameplay cap, never as IBC or IHRSA. Attraction stays authored scenery.**

## (e) Issues + solutions

**Issue 1 — “Better gear, more members, that’s obvious.”**  
**Solution:** N8. Obvious is not published. Capacity is countable. Attraction is a vendor sentence.

**Issue 2 — Importing IBC 50 as a membership roster.**  
**Solution:** N9. Egress occupants ≠ members on a dues list. A gym can have 150 members and 20 people on the floor.

**Issue 3 — Importing treadmill-per-member ratios onto bags.**  
**Solution:** Wrong sport. Catalog already says one bag, one athlete in session.

**Issue 4 — Retuning catalog dollars from a 2015 IHRSA average.**  
**Solution:** Stale, wrong product, G24. Leave `purchase_cost` invented.

---

# Area 3 — Location, and the screen that already asks for it

Career creation already makes the player pick **country → city → gym**. `gym_distribution.json` authors, per country, `population`, `gdp_per_capita_usd`, `culture_tier`, `gym_count`. `WorldPopulation` derives `talent_depth` and `combat_popularity`. The creation city board already shows `rival_gyms`.

## (a) Decisions coming (named as calls)

1. **Call: which of the four country fields may drive membership.**
2. **Call: catchment vs country population.**
3. **Call: income vs country GDP.**
4. **Call: saturation — `gym_count` vs city rivals.**
5. **Call: rent, and whether creation is an economic trade-off.**

## (b) Evidence + UNKNOWN

### What is published about *where a health club goes*

IHRSA/HFA site-selection pages (“Will They Come? 4 Factors…”; restated on “Finding Success as a Small-market Health Club”), verified 2026-09-07:

| Factor | Published claim | Kind | Grain |
|--------|-----------------|------|-------|
| Population density | Site where **at least 60,000**, preferably **100,000+**, people are in close proximity. Mini-facilities can succeed in smaller markets | **evidenced** as that IHRSA/HFA published claim | **Trade area**, not country |
| Travel time | Suburban competitive: primary **8 minutes**, secondary **12**; “upwards of **80%** of members from within 12 minutes”; urban: 8 / 12 **minute walk/commute** | **evidenced** as that claim | **Minutes**, not miles, not GDP |
| Household income | “Strong correlation” with membership; older published line: HHI below **$25,000** → **7.2%** (1 in 14) are members; higher-income penetration “often approaches **30%**” | **evidenced** as that page; **$25,000 / 7.2% is stale** as a 2026 band | **Household**, not country GDP |
| Educational attainment | Higher attainment, higher penetration | **evidenced** as that claim | Community, not `culture_tier` |

HFA 2026 Consumer Report: 2025 penetration rose across **every** demographic tracked, including **income brackets** (**evidenced** as direction). Exact current penetration-by-income table: **not retrieved** this pass (full report gated).

HFA 2025 Benchmarking (SGB 2025-10-14 restatement of the report, cross-checked against HFA’s own 2025-09-30 release):

| Claim | Figure | Kind |
|-------|--------|------|
| Median revenue growth 2024 | **9.9%** | **evidenced** (175 companies, 17,000+ facilities, 27 countries) — **not** a member-growth default |
| Net membership growth | **5.5%** | **evidenced** for those operators — **forbidden as a game default (G9)** |
| Member retention | **66.4%** (median/average as reported; SGB also prints median **66%**, top performers **>75%**) | **evidenced** for those operators |
| Dues vs non-dues | Dues **76.5%** of revenue (all respondents); non-dues **23.5%**; US non-dues **29.5%** | **evidenced** |
| Payroll | Median **38.4%** of revenue | **evidenced** — cost, not demand |
| Revenue per club | Median **$2.0M** all respondents; US near **$3.0M** | **evidenced** for those clubs — **wrong product scale** for an independent combat gym |
| Seasonality | Growth **January / Q1**; attrition pressure **late summer / early fall** | **evidenced** as that report’s qualitative finding |
| High-profit vs low-profit | High-profit: **lower occupancy costs**, dues-weighted mix, reinvestment ~**9.5%**; low-profit: higher payroll and occupancy costs, more non-dues, EBITDA **13%** vs **32%** | **evidenced** as that split. Occupancy cost is a **profit** lever, not a demand driver |
| Small US clubs | Under **$1.5M** revenue: weakest growth (**4.3%**) | **evidenced** as size split — not a saturation law |

**Occupancy-cost % of revenue** as a single HFA 2025 number: **not retrieved** (the full benchmarking PDF is gated). Secondary underwriting copy repeats “rent **10–15%** of revenue” as an industry band — **customary / secondary**, do not wire.

### The four fields, one by one

**`population` (country).** The US row in this workspace is **328,239,523**; China **1,397,715,000**; Ireland **4,941,444**. Using that integer as a gym’s member magnet is a category error. Published demand is people **within 8–12 minutes**. Creation already picked a **city**. Country population may continue to feed `talent_depth` as it does today. It must **not** feed membership.

**`gdp_per_capita_usd` (country).** Direction: richer households join health clubs at higher rates (**evidenced** as IHRSA/HFA correlation). Country GDP per capita is a **blunt** proxy (oil states, city/rural splits, combat gyms in poor boxing towns). It may, at most, justify a labelled invented **affordability / dues-band** flag. It must not mint members.

**`culture_tier` (S/A/B/C).** Game-authored. `combat_popularity` / `talent_depth` are derived scenery for *who becomes a fighter*, not *who pays dues*. A labelled invented “this country likes combat sports” modifier is gameplay, not research.

**`gym_count` (country).** In this file it is how many gyms world-gen placed in the country (US **87**, etc.). Published saturation is **competitors in the trade area**. The live creation board already lists `rival_gyms.count` and up to three names for **that city** (`:12654`–`:12666`). That is the honest saturation object. Country `gym_count` as a member divisor would punish a player for the game having authored a deep US scene.

### Creation as an economic trade-off

**Sourced as a *shape*; not as a curve.**

The honest sentence: a small town has a smaller catchment (IHRSA: mini-facilities *can* work; big boxes chase 60k–100k+). A city has more people and more rivals and, usually, more rent. High-profit health clubs, in HFA 2025, win partly by **lower occupancy cost** — so “expensive city is always better” is **not** even the fitness-club finding.

The live take already shows `weekly_upkeep` and space. What it does **not** show is a member credit. R44’s flat labelled credit can sit on every gym the same. If the operator wants the **trade-off** visible at creation, R45 may show an authored labelled preview: **this city, this many rivals, this upkeep** — and a labelled invented member band — without pretending country GDP did the math.

Rent as a **new** ledger line: **do not add** from this pack. Upkeep already stands in. A municipal commercial-rent table for combat gyms: **UNKNOWN**.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Country → city → gym pick | LIVE | Honest **shape** of a location choice |
| Country `population` / `gdp_per_capita_usd` | LIVE | Look like statistics; **not** a gym catchment |
| `culture_tier` → `talent_depth` / `combat_popularity` | LIVE | **invented** talent/culture scenery |
| Country `gym_count` | LIVE | World-gen density, **not** street competitors |
| City `rival_gyms` | LIVE on the board | Honest **competitive set** |
| Rent | none (upkeep stands in) | **absent** as rent; upkeep is **invented** cost |
| Location → membership credit | none | **absent** |

## (d) Minimum change

**Do not drive membership from country `population`, country `gdp_per_capita_usd`, `culture_tier`, or country `gym_count`. If R45 moves on location, the only live object with the right grain is the city’s `rival_gyms` plus the fact of the city pick — labelled invented magnitude, direction (more people nearby / fewer rivals → more room for members) taken from IHRSA/HFA siting *kinds*, not from a coefficient. Do not add a rent line. Do not pretend creation is a sourced NPV.**

## (e) Issues + solutions

**Issue 1 — Wiring country population because the field exists.**  
**Solution:** N13. Wrong grain. Creation already has cities.

**Issue 2 — “GDP per capita, that’s income.”**  
**Solution:** N14. Household income ≠ country GDP. Direction only, labelled if used.

**Issue 3 — `gym_count` as a competitor ratio.**  
**Solution:** N16. Use city rivals already on the board.

**Issue 4 — Inventing a rent $ to make the trade-off “real.”**  
**Solution:** G24 / N17. Upkeep is the live cost. Rent dollars are UNKNOWN.

---

# Area 4 — The shape of the number, and the ceiling

Members are a recurring revenue line, so the study ends with the shape: how many members a gym of this size plausibly holds, what churn does, whether joining is seasonal, and whether dues are the majority of a combat gym’s revenue. Then: **at what point does this stop being FightCamp and become a fitness-chain sim?**

## (a) Decisions coming (named as calls)

1. **Call: headcount ceiling / product identity.**
2. **Call: churn / retention as a mechanic.**
3. **Call: seasonality.**
4. **Call: dues vs class-packs / PT / merch.**
5. **Call: what must be refused.**

## (b) Evidence + UNKNOWN

### How many members

Three products, do not mash:

| Product | Published / observed scale | Kind | FightCamp? |
|---------|----------------------------|------|------------|
| Independent martial-arts / combat school | Gymdesk Benchmark 2026: **4,594** active gyms (large majority martial arts / combat); size buckets **under 50** (n=1,258, avg monthly revenue **$2,632**, revenue/member **$102**), **50–99** (**$6,905** / **$92**), **100–199** (**$13,311** / **$92**), **200+** (n=786, **$26,821** / **$66**). Typical collected ~**$100**/month; list ~**$165**, family/kids discounts pull the average down. Monthly plan ~**63%** of enrolled. **78%** run a kids program (those gyms average ~**237** members vs ~**107** adults-only) | **vendor-observed / secondary.** Not a commission table. **Do not author $100 or 200 as the sport** | The *kind* (dozens to low hundreds; tuition; kids as a common engine) is the player’s world. Kids-program-as-mode is **scenery** |
| Boutique boxing-fitness franchise | One 2024 Item 19 restatement: average gross **$422,065**, median **$406,183**, n=88 (high **$947,442**, low **$113,861**) | **evidenced as that FDD class** | Class-fitness. Not a fight gym |
| MMA-oriented fitness chain (Signature/FIT) | 2025 FDD Item 19 (Signature/FIT, managed cohort): member counts in the **thousands** (franchisee-owned high year-end 2024 member count **8,081** on **45,388** sq ft in one restated row; medians in the **5,000s** on **~35,000** sq ft). Dues are a large share of revenue, not all of it. A 2026 FDD restatement of a 2025-year managed cohort prints median 2025 revenue **$4.09M**, median members **6,204** | **evidenced as that FDD class** | **G17 scenery.** This is the ceiling: when the number looks like this, stop |

Gymdesk’s own caveat, worth keeping: a 200-member school earns on the order of **10×** a sub-50 school in **total** revenue because of headcount, while revenue **per** member **falls** (family/kids). That is vendor-observed economics, **not** a growth % to ship.

**UNKNOWN:** a published independent-boxing-gym or independent-MMA-gym census of headcount from IHRSA/HFA (those bodies do not break combat schools out in the public summaries retrieved this pass). IBISWorld boxing-gym market-size dollars cited in 2023 secondary journalism: **not retrieved as a primary this pass**, do not wire.

### Churn

| Source | Figure | Kind | Ship as default? |
|--------|--------|------|------------------|
| HFA 2025 Benchmarking | **66.4%** annual retention (≈ **33.6%** annual attrition) for responding fitness operators | **evidenced** for that sample | **No** (G9) |
| HFA 2026 Consumer Report | Unused-membership share **4.6%** in 2025 (down from ~**10%** pre-pandemic); visits ~**7 billion** | **evidenced** | **No.** Ghost-member % is not combat-gym churn |
| Gymdesk 2026 (801,000 memberships at gyms that track attendance) | Cancel share over 24 months: rare visit **44.2%**, ~1×/week **34.1%**, ~2×/week **26.5%**, 3+/week **23.2%**. ~**1 in 5** new members quit inside 90 days; ended memberships typically lasted **three months**; then **2–3.5%**/month with a **January** spike | **vendor-observed** | **No.** Attendance→retention is a *kind*. The percents are not house law |
| HFA 2019 Profiles of Success (stale, for contrast) | Independent clubs **73.2%** retention vs chains **62.3%** (2018 data, 98 firms) | **evidenced as that older survey** | **No.** Stale, wrong product mix |

**Ruling on N19:** churn is why a **flat** credit is stabler than a simulated join/leave loop. A join/leave loop needs a default %. J5 G9 forbids it. R44 does not churn. R45 does not churn unless the operator later files an invented labelled rate — and this pack recommends **not**.

### Seasonality

HFA 2025: growth concentrated **January and Q1**; retention pressure **late summer / early fall** (**evidenced** as that report). Gymdesk: January cancel spike (**vendor-observed**). HFA 2025 New Year survey: fitness is the top resolution theme; cost blocks nearly a third.

Combat-gym seasonal **coefficients**: **UNKNOWN**. Muay Thai tourist-season effects, kids’ school-year effects: **UNKNOWN** as a published table (kids are **78%** of Gymdesk gyms — a different product).

**Ruling on N20:** R44 is a weekly flat. No January multiplier.

### Dues vs everything else

HFA 2025: dues **76.5%** / non-dues **23.5%** worldwide; US non-dues **29.5%** (**evidenced**, responding clubs). High-profit clubs are **more** dues-weighted; low-profit clubs lean on non-dues and do **not** convert that into better margins.

Gymdesk martial-arts: monthly membership is the **engine** (~**63%** of enrolled); drop-ins and trials sit beside it; almost **90%** of gyms run more than one price kind. Collected ~**$100**/month is **not** G24-legal as a sport default.

Combat-gym **PT share**, **merch share**, **class-pack share** as published %: **UNKNOWN**. Aggregator market-research pages that print a PT share for “the MMA gym market” were **not** treated as primary this pass.

J5 Area 1 already: gyms post unlimited / class-pack / drop-in / youth tiers. Those pages are primary **for that gym**. R44 ships **one** weekly credit, not a till with four drawers.

Life Time 2025 10-K (public company, **wrong product**): membership dues and enrollment **$2.11B** vs in-center **$0.80B** on **$2.91B** center revenue — dues still the majority at a luxury chain. Planet Fitness 2025: **>90%** of corporate-owned and franchise revenues described as recurring dues/royalties/annual fees (**wrong product**, HVLP). Both confirm the *kind* (recurring dues dominate) at scales FightCamp must refuse.

### The ceiling — when it stops being FightCamp

J5 **G17** already: UFC Gym franchise / Performance Institute / promoter-owned gym = **scenery**.

This pack names the tripwires so R45 cannot walk into a second career:

| If you are modelling… | You have become… | Ruling |
|-----------------------|------------------|--------|
| Thousands of members, 30,000+ sq ft, HVLP or Signature pricing tiers, childcare, pickleball | A **fitness chain** | **Refuse.** G17 |
| Franchise territory, Item 19 AUV, royalty % | A **franchise tycoon** | **Refuse** |
| Kids program as the engine (Gymdesk **78%**) | A **youth-school sim** | **Scenery.** A flag later, not MVP |
| PT book, merch SKUs, ClassPass mix | A **studio operator career** | **Refuse** as mode. Non-dues stay off the till |
| Occupancy management, off-peak pricing, 2.5 members/m² | A **club-ops sim** | **Refuse.** Capacity ceiling only |
| `reputation` and `leading_athlete_fame` as evidenced join elasticities | A **demand-curve liar** | **Refuse** as evidenced; optional **invented** flavour |
| Member-growth **%** so the till tracks payroll | The **2am decision** J5 existed to stop | **Refuse** (G9) |
| Membership as a % of purse | `gym_cut` in a tracksuit | **Refuse** (E3 / G10) |

**What must be refused (plain list):** see **Do not build** below.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Member headcount | none | **absent** |
| Churn / retention loop | none | **absent** — correct |
| Seasonality | none | **absent** — correct |
| Dues / class-pack / PT / merch split | none | **absent** — correct as MVP |
| Weekly membership credit | none | **absent** — R44 |
| Fitness-chain member counts | none | **absent** — correct (G17) |

## (d) Minimum change

**R44 authors one labelled weekly credit and a flat count. It does not churn, does not season, does not split PT/merch, and does not grow by a %. The plausible independent-gym *kind* is dozens to low hundreds of members, never thousands. Do not author 50 or 200 or $100 as the sport. If the count never moves after R44, that is allowed.**

## (e) Issues + solutions

**Issue 1 — Shipping Gymdesk $100 because it is “martial arts.”**  
**Solution:** N1 / G24. Vendor-observed, family-discounted, not a sport. Label or omit.

**Issue 2 — Shipping HFA 5.5% net growth so the gym “climbs.”**  
**Solution:** G9 / N22. Forbidden default percentage.

**Issue 3 — UFC Gym FDD thousands looking like a win state.**  
**Solution:** N18 / G17. That win state is a different game.

**Issue 4 — Kids program, because 78% of vendor gyms have one.**  
**Solution:** Scenery. FightCamp is a pro desk, not a after-school belt factory.

**Issue 5 — Brand / FDD / vendor gym names.**  
**Solution:** Product class in research. No names as data.

---

# Do not build

Same shape as J4 / J5. Show nothing. Build nothing.

- **`gym_cut` / purse skim as membership.** J4 **E3**, J5 **G10**. Not reopened.
- **A sport-wide dues dollar or monthly default** (`$100`, `$150`, `$199`, FDD AUV, Gymdesk collected average). J5 **G1 / G24**.
- **A default member-growth %, churn %, occupancy %, coach %, fame elasticity, or seasonal multiplier.** J5 **G9**.
- **R44 moving the count.** Flat only.
- **`gym["reputation"]` or `leading_athlete_fame` as an evidenced join formula.**
- **Equipment `quality_tier` as member attraction.** Capacity ceiling only, later, labelled.
- **Country `population`, country `gdp_per_capita_usd`, `culture_tier`, or country `gym_count` as a member formula.**
- **A rent / lease dollar table.**
- **UFC Gym / Performance Institute / promoter-owned gym as the player; Signature-box headcounts as a win state.** G17.
- **Fitness-chain occupancy-management, franchise territory, Item 19 AUV career.**
- **Kids-program mode, PT-studio mode, merch-shop mode, ClassPass / aggregator mix.**
- **NGB club fees as gym dues** (USA Boxing **$205** club, etc.). J5 **G4**.
- **Scraped named-gym price catalog** as `assets/data`.
- **A join/leave sim that exists to paper over payroll.** Fix the economy (J5 priority), not a fabricated demand curve.
- **Manager-simulator / second career / tax sim / licence RPG.** Already scenery (J2 §6.2, J4 E9, J5, J6).
- **R40 / J3 Areas 1–3 / J4 E1–E3 / J5 G1–G18 reopeners.**

---

# Priority ruling

**What does R44 ship now as a flat authored member credit, what does R45 need before the count may move, and if the count should never move, say so.**

**Plain words.** After R43 the gym does not live on the purse (J5). R44 is the membership *object* J5 ranked 2nd: a gym-authored, labelled weekly credit, or omit. This pack was asked whether that number should **move** with fame, equipment, and city.

**Published:** people join fitness facilities for health, mental well-being, convenience, coaching-shaped classes, and community; they join them **near where they live or work**, in numbers that rise with **household income**; they **cancel** when they stop showing up and, in health clubs, when the floor feels crowded; **dues** are the majority of club revenue; **January** is the join season. Independent combat schools, in one vendor’s 2026 observed set, live at **dozens to low hundreds** of members, not thousands.

**Not published:** a formula that turns `gym["reputation"]`, `leading_athlete_fame`, `quality_tier`, country GDP, or country `gym_count` into a headcount. A sport-wide dues dollar. A member-growth %. A combat-gym occupancy %. A famous-fighter halo coefficient.

**Customary:** the coach and the class are why a combat gym is not a Planet Fitness; “a champion trains here” is a poster; better gear is a brochure; small-town vs city is a rent-and-catchment trade-off.

### R44 ships now

| Ship | Do not ship |
|------|-------------|
| The **object**: a weekly membership credit to `gym["cash"]` | A sport-wide dollar |
| A **flat** authored count × authored weekly rate, both `source: invented` (or `evidence` for **that gym**) | A moving count |
| An AUTHORED / invented chip (M8 already) | A citation on an invented number |
| Omit the line if no rate is filed | USD 0 as a fake fee |
| | Churn, seasonality, PT, merch, kids, fame, equipment-attraction |

R44 does **not** wait on this pack’s demand curve. J5 already ranked the object. J6 A16 and J7 P14 already refused to outrank it. This pack **does not outrank it either**. It only refuses to let R44 wear a moving number it cannot evidence.

### R45 — gates before the count may move

The count **may** move only if **all** of these are true. If any is missing, **keep it flat**.

1. **R44 has shipped** the labelled object. No movement on a line that does not exist.
2. **Capacity is a ceiling, not a magnet.** `Σ station_capacity` and/or floor space may **cap** the authored count. `quality_tier` does not raise demand. Occupancy % is not authored as a default.
3. **Location is city grain, labelled invented.** City pick + `rival_gyms` may shift an authored band. Country `population` / `gdp_per_capita_usd` / `culture_tier` / `gym_count` may not. No rent table.
4. **Fame and athlete fame, if used at all, are invented flavour** with the AUTHORED chip — never `evidenced`. Coach, if used, is the same: invented flavour, and if the three are shown, coach ranks first.
5. **No default %.** No growth, churn, seasonal, or elasticity percent. A later invented table of **bands** (small / medium / large city) is a table of authored integers, not a rate.
6. **Headcount stays in the independent-gym *kind*.** Dozens to low hundreds. Never chain-scale thousands. G17 holds.
7. **The operator has answered the question at the end of this pack.** Movement is a gameplay want. Research does not require it.

### If the count should never move

**Say so: it may never move, and that is the more honest reading of the published record.**

Nothing retrieved this pass *requires* a moving count. A flat labelled credit already does the only honest job — the gym lives on the floor. Movement is how a management game feels. Feeling is not evidence. If R45 is never scheduled, R44 still stands.

### Order, next twelve months

| Rank | Area | Research or build? | Wait a year? | Scenery? |
|------|------|--------------------|--------------|----------|
| **1** | **R44 flat labelled weekly membership credit** | **Build** as J5 rank 2 already ordered. This pack **does not** add a default dollar or a moving count | No | Sport-wide $ / growth % = **scenery-as-lie** |
| **2** | **Capacity ceiling (optional, R45)** | **Build only if** the operator wants the count to move **and** accepts it as a cap from `station_capacity` / floor, labelled invented | Yes, unless the operator answers “move it” | Equipment-attraction multiplier = **scenery-as-lie** |
| **3** | **City catchment / rivals as labelled invented bands (optional, R45)** | **Build only after** rank 2’s ceiling exists, so a big city cannot author 8,000 members on three bags. Use creation’s city + `rival_gyms`, not country fields | Yes | Country-GDP member formula = **scenery-as-lie**. UFC Gym scale = **scenery** (G17) |
| **4** | **Fame / athlete fame / coach as join flavour** | **Wait. Prefer never as numbers.** If ever, invented chip, coach first. No elasticity | Yes | “Champion trains here → +N” as evidenced = **scenery-as-lie** |
| **5** | **Churn / seasonality / PT / merch / kids / rent table** | **Wait. Prefer never.** Kinds may appear as copy. Percents and second tills do not | Yes | Fitness-chain ops / kids school / PT career = **scenery** |

### Defend

**R44 flat beats R45 movement.** J5 already: ship the object without a default dollar. This pack found no published coefficient. Putting a moving number on R44 would ship invention wearing the clothes of research.

**Capacity ceiling beats catchment, and both beat fame.** Stations are countable in a file the game already ships. Catchment *direction* is published for health clubs at the trade-area grain. Fame is a poster. Inventing from the poster first is the wrong order.

**Catchment at city grain beats country fields.** IHRSA’s own four factors are proximity, minutes, household income, education — not national population and not `culture_tier`.

**“Never move” is allowed to be the answer.** Same discipline as J5 (“omit the line”) and J6 (“show nothing on tax”). Publishable kinds are not shippable formulas.

**Why this does not reopen E1–E3 or G10.** Membership credits `gym["cash"]` from the **floor**, not from the bout agreement. After R43 the payer *can* be `athlete["cash"]` (J6 A15) when a rate is filed. That is still not a purse tax.

**Why this does not outrank J5 rank 2.** It *is* J5 rank 2, with the moving-number question answered.

### What is scenery (as plainly as J2 §5.1)

- **Fitness-chain / UFC Gym / PI / promoter-owned gym as the player.** Real facilities. **Not this desk.** G17.
- **Kids-program career, PT career, merch-shop, ClassPass.** Real income lines. **Not this mode.**
- **Evidenced fame/equipment-attraction elasticities.** Not retrieved. **Omit**, or label invented.
- **Default growth / churn / occupancy percents.** G9. **Omit.**
- **Sport-wide dues dollar.** G1 / G24. **Omit.**
- **`gym_cut`.** E3 / G10. **Omit.**
- **Manager-simulator / tax sim / licence RPG / second weigh-in.** Already scenery.
- **NGB club fees as gym income.** G4.

**No fifth area outranks these four.** The closest miss — “should we become a gym-ops game because HFA published 66.4% retention?” — is a **new product**. Not MVP.

---

## Test assertions (contracts for a later PR — not written this pass)

Numbered **N23–N38** so they do not collide with operator calls N1–N22, J7 P1–P16, J6 A1–A34, J5 G1–G34, J4 E1–E34, or J3 D1–D16.

| ID | Assertion |
|----|-----------|
| **N23** | No data file contains a sport-wide `membership_usd_per_month` / `dues_usd` / `member_weekly_credit` without `evidence` pointing at **that gym’s** posted rate or an explicit `INVENTED` / `source: invented` tag (J5 **G24**). |
| **N24** | No data file contains a default `member_growth_pct` / `churn_pct` / `occupancy_pct` / `fame_elasticity` / `coach_draw_pct` / `equipment_attraction_pct` / `seasonal_join_pct` (J5 **G9**). |
| **N25** | R44’s membership credit, if present, is a **flat** authored weekly amount (count constant × rate) and does not read `gym["reputation"]`, `leading_athlete_fame`, `quality_tier`, country `population`, `gdp_per_capita_usd`, `culture_tier`, or country `gym_count` to change the amount. |
| **N26** | Membership credits `gym["cash"]` and is **not** a function of `show_purse` / `win_bonus` / `performance_bonus` / `gate_share`. No `gym_cut` (J4 **E3** / J5 **G10**). |
| **N27** | If a membership debit is ever taken from an athlete, the payer is `athlete["cash"]` and the payee is `gym["cash"]` (J6 **A15 / A27**), only with `evidence` or an `INVENTED` tag. |
| **N28** | `equipment_catalog.json` items still expose `station_capacity`, `weekly_upkeep`, `purchase_cost`, `quality_tier`, `footprint`, `base_safety`. R44 does not add an attraction field. |
| **N29** | If R45 caps members from equipment, the cap is derived from `station_capacity` and/or floor space, labelled **invented**, and does **not** treat `quality_tier` as a demand multiplier. |
| **N30** | Country `gym_distribution.json` fields `population`, `gdp_per_capita_usd`, `culture_tier`, `gym_count` do not write a membership credit. City `rival_gyms` may only do so in R45 with an `invented` tag. |
| **N31** | No UFC Gym / fitness-chain Item 19 member count (thousands) is stored as the player gym’s headcount. G17 scenery stays scenery. |
| **N32** | `_settle_billing` still accrues payroll + upkeep (J5 **G25**). Membership, if present, is a **credit**, not a reason to invent a purse tax when the credit is smaller than payroll. |
| **N33** | `Sponsorship.settle_week` may still credit `gym["cash"]` and remains labelled **invented** (J5 **G16 / G26**). It is not retuned as a membership substitute. |
| **N34** | USA Boxing club / athlete / fitness fees, IBJJF entry, IJF/UWW/WT licences are **not** written to `gym["cash"]` as membership (J5 **G31**). |
| **N35** | J2 P1–P3 still hold. R40 is not reopened. J4 E1–E3, J5 G1–G18, and J5’s priority ranking of the membership **object** are not reopened by any N-test. |
| **N36** | After R43, bout-agreement money still does not increase `gym["cash"]` by the contracted purse (J5 **G19** / J4 **E19**). Membership is not a back-fill of that line. |
| **N37** | If no membership rate is filed (no `evidence`, no `INVENTED` tag), the membership credit is omitted — not authored as **$0** pretending to be a fee (J2 §6.3 / J5 G3). |
| **N38** | No test fixture uses a real gym’s, manager’s, official’s, athlete’s, or executive’s name as data (J5 **G34**). |

---

## One question for the operator

R44 can ship a flat labelled weekly membership credit without inventing a sport-wide dollar — that much J5 already allowed. Nothing published will give you a clean formula that moves that credit with gym fame, a famous athlete, or nicer bags; those are posters and brochures. What *is* honest to move later, if you still want movement, is a **ceiling** from the stations already on the floor and a **labelled invented** city-size / rivals band, with the coach ranked ahead of fame if flavour must pick a lead.

**Do you want the member count to stay flat forever (the more honest reading), or may R45 move it as labelled invention on capacity + city — never as evidenced fame or equipment-attraction?**

---

## Source list (live verification 2026-09-07)

**Primary / official / trade-body (preferred):**

- `J5_THE_GYMS_OWN_LEDGER.md` (G1–G18, G24, G9, G10, G17, priority ruling — **cited, not reopened**)
- `J6_THE_ATHLETES_OWN_LEDGER.md` (A15 / A16 / A27 — membership as the same object, other face)
- `J7_THE_SCALE_AND_THE_BELT.md` (P14 — does not outrank J5 rank 2)
- `J4_THE_DESK_AND_THE_CUT.md` (E1–E3, E23 — **cited, not re-derived**)
- `equipment_catalog.json` v2 (this workspace)
- `gym_distribution.json` (this workspace)
- `GameState_fame.excerpt.txt` (`gym_reputation` `:2834`; `leading_athlete_fame` `:2844`)
- `GameState_creation.excerpt.txt` (`get_creation_city_board` `:12640`; `get_creation_gym_take` `:12670`; `rival_gyms`; `talent_depth` / `combat_popularity`)
- HFA, “81 Million Americans Were Members of a Fitness Facility in 2025” (2026-04-09): https://www.healthandfitness.org/81-million-americans-were-members-of-a-fitness-facility-in-2025-new-hfa-report-finds/
- HFA, “One in Four Americans Belonged to a Gym in 2024” (2025-04-07): https://www.healthandfitness.org/one-in-four-americans-belonged-to-a-gym-in-2024/
- HFA, “New HFA Data Shows How 77 Million US Fitness Facility Members Work Out” / 2025 Expanded Insights (2025-10-30/31): https://www.healthandfitness.org/new-hfa-data-shows-how-77-million-us-fitness-facility-members-work-out/
- HFA, 2025 US Health & Fitness Consumer Report: Expanded Insights landing: https://www.healthandfitness.org/2025-u-s-health-fitness-consumer-report/
- HFA, “HFA Releases 2025 Fitness Industry Benchmarking Report” (2025-09-30): https://www.healthandfitness.org/hfa-releases-2025-fitness-industry-benchmarking-report/
- HFA, 2025 Fitness Industry Benchmarking Report landing: https://www.healthandfitness.org/2025-fitness-industry-benchmarking-report/
- HFA press release, same report: https://www.healthandfitness.org/about/media-center/press-releases/health-fitness-association-releases-2025-fitness-industry-benchmarking-report
- HFA, “Health, Exercise, and Fitness Dominate Americans’ New Year’s Resolutions” (2025-01-07): https://www.healthandfitness.org/about/media-center/press-releases/health-exercise-and-fitness-dominate-americans-new-years-resolutions/
- HFA / ABC Fitness, 2024 Latin America Fitness Consumer Survey (2024-12-04): https://www.healthandfitness.org/latin-americans-embrace-fitness-facilities-as-key-to-an-active-lifestyle/
- HFA, “Will They Come? 4 Factors that Matter Most in Calculating Health Club Demand”: https://www.healthandfitness.org/improve-your-club/will-they-come-4-factors-that-matter-most-in-calculating-health-club-demand/
- HFA, “Finding Success as a Small-market Health Club” (restates the four factors, including HHI **$25,000** → **7.2%**): https://www.healthandfitness.org/improve-your-club/finding-success-as-a-small-market-health-club/
- HFA, “Solve Overcrowding at Your Gym with This Simple Equation” (2019-05-22; GCB **2.5 members/m²**; crowding complaint split): https://www.healthandfitness.org/solve-overcrowding-at-your-gym-with-this-simple-equation/
- HFA, IHRSA Health Club Equipment Report landing (2015 sample **$84,000**; cardio **45.9%** of equipment spend — **stale**): https://www.healthandfitness.org/publications/the-ihrsa-health-club-equipment-report-spending-utilization-programming-trends/
- HFA, “The Equipment Checklist” (cardio **45.9%** / strength **12.6%** of equipment spend; start-up equipment **$100,000–$500,000** from the IHRSA Handbook — **stale / handbook**): https://www.healthandfitness.org/improve-your-club/the-equipment-checklist-what-to-ask-before-you-stock-your-gym/
- HFA, 2019 IHRSA Profiles of Success landing (independent **73.2%** vs chain **62.3%** retention — **stale**): https://www.healthandfitness.org/ihrsa-2019-profiles-of-success/
- 2024 International Building Code Table 1004.5, **Exercise rooms = 50 gross** sq ft/occupant: https://codes.iccsafe.org/s/IBC2024V2.0/chapter-10-means-of-egress/IBC2024V2.0-Ch10-Sec1004.5
- 2024 IBC Chapter 10 (same table): https://codes.iccsafe.org/content/IBC2024P1/chapter-10-means-of-egress
- USA Boxing 2026 club **$205** (already J5 G4 — **not gym dues**): https://www.usaboxing.org/news/2025/november/07/2026-usa-boxing-member-rate-adjustment-announcement

**Secondary (labelled in body):**

- SGB Executive, 2025-10-14, restatement of HFA 2025 Benchmarking (dues **76.5%** / non-dues **23.5%**; US non-dues **29.5%**; payroll **38.4%**; revenue per club; seasonality; high-profit occupancy-cost split): https://sgbonline.com/exec-study-finds-fitness-clubs-delivering-profitable-growth-post-pandemic/
- Club Insider Online, 2025-10-01, HFA benchmarking snapshot: http://www.clubinsideronline.com/news/ihrsa/hfa-releases-2025-fitness-industry-benchmarking-report/
- Athletic Business, 2026-04-09, 81 million members restatement: https://www.athleticbusiness.com/facilities/fitness/article/15821794/hfa-report-reveals-81m-americans-were-fitness-club-members-in-2025
- Gymdesk Benchmark 2026 (observed **4,594** gyms; billing/retention/size buckets; ~**$100**/month collected; attendance→cancel **44.2% / 23.2%**; January spike; kids **78%**): https://gymdesk.com/ja/gym-benchmark-report (published June 2026; re-run after internal audit)
- Gymdesk, “50+ Martial Arts Industry Statistics for 2026” (2026-08-21): https://gymdesk.com/blog/martial-arts-industry-statistics
- Gymdesk, “Gym Owner Statistics 2026” (HFA 66.4% restated; 4.6% no-show): https://gymdesk.com/blog/gym-owner-statistics
- Gymdesk, “How to Start a Boxing Gym” (100–300 members as a profitability *kind*, internal benchmark — **do not wire as a default**): https://gymdesk.com/blog/how-to-start-your-own-boxing-gym
- Franchise Chatter / FDD restatements of an MMA-oriented fitness-chain Item 19 (Signature/FIT member counts in the thousands, sq ft, dues — **G17 product class**, not player data): https://www.franchisechatter.com/2026/03/17/ufc-gym-franchise-review-2026-costs-fees-news-average-revenues-and-or-profits/
- FDD Exchange, 2025 UFC GYM FDD summary (Item 19 limited to Signature/FIT; system size): https://fddexchange.com/fdd/ufc-gym-2025/
- Franchise Chatter, Title Boxing Club 2025 review (2024 franchised average gross **$422,065**, median **$406,183**, n=88 — **boxing-fitness class**, not a fight gym): https://www.franchisechatter.com/2025/11/07/title-boxing-club-franchise-review-2025-costs-fees-news-average-revenues-and-or-profits/
- Healey et al., 2025, *Journal of Community & Applied Social Psychology* (Australian MA&CS qualitative: resilience, confidence, community): https://onlinelibrary.wiley.com/doi/full/10.1002/casp.70035
- Abramson & Modzelewski, 2010, *Qualitative Sociology* “Caged Morality” (middle-class cage-fighting subculture — community/merit, not a join %)
- Fox Business, 2023-04-13 (Creed III / celebrity-bout **inquiry** spikes **30–50%** — journalism, not retained members): https://www.foxbusiness.com/lifestyle/boxing-movie-creed-iii-jake-paul-bring-attention-sport-are-boxing-gyms-benefiting
- Life Time Group Holdings FY2025 revenue note (dues vs in-center — **wrong product**, dues-majority *kind*): https://www.sec.gov/Archives/edgar/data/1869198/000186919826000010/R15.htm
- Combat-gym and martial-arts operator copy retrieved 2026-09-07 on coaching vs equipment (US/UK academy blogs) — **CUSTOMARY, one house’s page, do not ingest names or prices as catalog**
- IHRSA equipment-quality “attracting and retaining” sentence on the equipment-report landing — **sponsor-adjacent customary, stale**

**Not retrieved / do not fake:**

- A sport-wide **gym dues** dollar or percentage (ABC, NSAC, CSAC, NJSACB, NYSAC, HFA combat-school breakout, or any of the 13)
- A published **member-growth %** for independent combat gyms
- A published **fame → members** or **champion-on-the-roster → members** elasticity
- A published **coach-quality → members** coefficient
- A published **equipment-quality attraction** multiplier for combat gyms
- A combat-gym **floor-area-per-member** table (IBC 50 is egress, not that table)
- A combat-gym **occupancy / utilisation %** or bag-to-member ratio from a trade body
- Current HFA 2025 Benchmarking **occupancy-cost % of revenue** (full PDF gated this pass)
- Current HFA 2026 **penetration-by-income-band** table (headline says every bracket rose; bands not retrieved)
- Independent-combat-gym **naming-rights** or **PT/merch share** as a primary table
- IBISWorld boxing-gym market size as a primary (2023 secondary mention only)
- A municipal **rent** schedule for combat gyms
- Host-nation gym-economics as house law of ONE / RIZIN / RWS / GLORY
- Kids-program economics as a FightCamp default
- Any number invented to fill a silence so the count can move (TASK)

---

*End of J8. Cut from the Decisions page and from the priority ruling. R44 ships a flat labelled weekly membership credit, or omits the line. The count does not move on evidence, because the evidence is kinds and directions, not coefficients. Fame and nicer bags are posters. Capacity is a ceiling. City catchment is a labelled invention waiting on an operator yes. If that yes never comes, the flat credit is still the honest floor J5 named. No sport-wide dollar. No growth %. No gym_cut. R40 remains J2 D6. J4 E1–E3 and J5 G1–G18 are not reopened. No fitness-chain sim.*
