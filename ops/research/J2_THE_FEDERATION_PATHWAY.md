# J2 — The Federation Pathway: How You Get In, and Who Pays

**Desk:** John (research)  
**Date:** 2026-09-06  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design.  
**Local snapshot used:** `real_organizations.json` (`snapshot_date` 2026-09-01). Rules/judges already stand in `J1_ORGANIZATION_RULES_AND_JUDGES.md` — cite J1 §1.7 CMMAF, §1.9 IBJJF, §1.14 UWW, §1.15 IJF, §1.16 WT; do not restate scoring.  
**Engine fact (from assignment, not re-read in this workspace):** `entity_type` is copied (`WorldPopulation.gd:254`) and seen by sponsors (`Sponsorship.gd:224`) and **never branched**. Org pool is country-only (`GameState.gd:585`). Every merged org “receives its own opening event” (`WorldPopulation.gd:174`). `get_promotion_bout_offer` (`GameState.gd:5492`) builds a purse and a win bonus for **any** organization id. `_promotion_purse_multiplier` (`GameState.gd:5483`) and `accept_signing_offer` (`GameState.gd:5288`) treat IJF / WT / IBJJF / UWW / CMMAF as if they were UFC.

**Operator ruling (2026-09-06):** this is a **behaviour** distinction, not an identity one. One organizations table, one `Sanctioning` resolver, **three pathways**.

**UNKNOWN policy:** if a primary federation page / fee schedule / Olympic qualification PDF / ranking bylaw does not state a fact, the cell is **UNKNOWN**. Never invent a fee, a stipend, a ranking formula, a qualification quota, or a real official’s/athlete’s name as data. Inherited national-body overlays are labelled **NATIONAL**, not claimed as the IF’s published purse.

---

## Decisions page (operator calls)

This page is what R40 is cut from.

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| **D1** | Bind **pathway**, not a second org table | Keep one `organizations` catalog. Derive (or store) `pathway ∈ {signing, open_entry, national_selection}` from `entity_type`. One `Sanctioning` resolver already from J1 D1; three **entry/money** behaviours. | Catalog already defines the three `entity_types`. The lie is that nothing reads them. |
| **D2** | Reverse the money polarity for non-promotions | `get_promotion_bout_offer` must **not** emit purse + win bonus for `federation` or `tournament_operator`. Promotions: org pays fighter. IBJJF: fighter pays operator. Olympic IFs: NF/NOC funds the trip; IF prize is a medal table, not a bout contract. CMMAF/IMMAF: athlete (via NF) pays championship fees. | Today IJF “signs” you like UFC. That is the lie. |
| **D3** | Split the gate: who puts the athlete on the mat | **Signing** (13 promotions): exclusive contract. **Open entry** (`ibjjf`): membership + fee + (black-belt majors) ranking-point floor. **National selection** (`ijf`, `united_world_wrestling`, `world_taekwondo`, `cyprus_mmaf`): the **national federation** enters the athlete; the manager does not. | Olympic quota is allocated to the NOC (wrestling, taekwondo) or to the athlete-by-name with an NF override when two are top-17 (judo). A manager with one fighter does not own that slot. |
| **D4** | Playable vs scenery — do **not** ship a second career mode | **Playable as-is with D2/D3:** IBJJF (pay-to-enter circuit) and CMMAF (amateur feeder → promotions). **Scenery + feeder, not a mode:** IJF / UWW / WT Olympic cycles. Prestige, ranking, a possible later cross into promotions. No Olympic-qualification sim as MVP. | J1 D4 already parked federation scoring at P5. Building an Olympic-cycle manager on top of a broken purse model is the unplayed-mode trap. |
| **D5** | Amateur → pro is a **one-way door** | CMMAF/IMMAF eligibility dies on a Unified-Rules pro bout, a contracted purse, a published pro record, or (from 2025) any MMA bout that allowed elbows and/or knees to the head. IBJJF tournament prize money does **not** make you pro for IMMAF; a **contracted** BJJ purse does. Olympic IF ranking is not “amateur” in the IMMAF sense — it is a different sport. | The game currently pays CMMAF a UFC purse, which would, in reality, **end** the amateur career it is modelling. |
| **D6** | **Minimum change** (R40 scope line) | Gate `get_promotion_bout_offer` (`GameState.gd:5492`), `_promotion_purse_multiplier` (`:5483`), `accept_signing_offer` (`:5288`), and `WorldPopulation.gd:174` opening events on `entity_type`. Promotions unchanged. Federations/tournament_operator: **no signing, no purse, no “opening card.”** IBJJF becomes a calendar `open_entry` with a published fee debit and an optional prize table at black-belt majors. Olympic IFs become calendar ranking events the NF, not the player, enters. CMMAF becomes amateur (IMMAF inheritance from J1 §1.7) with a `turned_pro` flag. | Stops the lie without a second career mode. Everything else (ranking formulas, Olympic quotas, NF politics) is data later. |

---

## File-level anchors (what is live vs this study)

| File | Role | Live? | Gap this doc cares about |
|------|------|-------|--------------------------|
| `real_organizations.json` | 18 identities, `entity_type`, HQ, disciplines, gameplay tier/reputation, `official_url`, text-names-only brand policy | catalog identity | `entity_types` block is honest; **runtime never branches**. No `pathway`, no `money_flow`, no `entry_gate`. |
| `GameState.gd:585` | Org pool | LIVE | **Country only.** A Cyprus fighter can be “signed” by IJF because Georgia/France/Japan list `ijf` in `market_assignments`, not because judo works that way. |
| `GameState.gd:5492` | `get_promotion_bout_offer` | LIVE | Purse + win bonus for **any** org id. |
| `GameState.gd:5483` | `_promotion_purse_multiplier` | LIVE | S/A/B/C tier math applied to federations. |
| `GameState.gd:5288` | `accept_signing_offer` | LIVE | Exclusive-contract accept path for federation ids. |
| `WorldPopulation.gd:174` | Every merged org gets an opening event | LIVE | IJF/WT/UWW/IBJJF/CMMAF spawn as if they ran cards. |
| `WorldPopulation.gd:254` | Copies `entity_type` | LIVE | Copied, never read. |
| `Sponsorship.gd:224` | Sees `entity_type` | LIVE | Copied, never branched. |
| J1 | Rules, judges, weights, legality | research | **Do not re-score here.** Pathway and money only. |

**Catalog `entity_types` (verbatim):**

| Type | Catalog definition | In-scope ids |
|------|--------------------|--------------|
| `promotion` | “A commercial or professional event promoter/league.” | the 13 (baseline; contrast only) |
| `federation` | “A governing or member federation that develops or regulates a sport.” | `ijf`, `united_world_wrestling`, `world_taekwondo`, `cyprus_mmaf` |
| `tournament_operator` | “An organization primarily represented by its recurring competition circuit or championships.” | `ibjjf` |

---

## 0. Three pathways (the behaviour map)

| Pathway | `entity_type` | Who puts the athlete on the mat | Who pays whom | Exclusivity | Game object to emit | Do **not** emit |
|---------|---------------|----------------------------------|---------------|-------------|---------------------|-----------------|
| **signing** | `promotion` | The promotion, via bout contract | Org → fighter (purse, win bonus, some prize seasons) | Usually exclusive (house contract) | `BoutOffer` as today | — |
| **open_entry** | `tournament_operator` | The athlete, by paying and making weight | Fighter → operator (membership + entry). Operator → fighter **only** if a published prize table exists (IBJJF black-belt majors / season awards) | None from the operator. A **promotion** (UFC BJJ, ONE) may overlay exclusivity | `TournamentEntry` (fee debit, bracket, ranking points, optional prize) | `SigningOffer`, purse, win bonus |
| **national_selection** | `federation` | The **national federation** (and, for Olympics, the NOC). The athlete competes **for a country** | Mixed: athlete/NF pay licences and engagement fees **up** to the IF; IF may pay a **medal prize**; the living wage is **NATIONAL** (NOC/NF stipend, Operation Gold, medal funds) — not an IF purse | IF-level: usually not a promotional exclusive. IJF WRL athletes need IF **authorization** for other combat-sport internationals. IMMAF: turning pro closes the door | `CalendarEvent` + `SelectionDecision` (NF-owned). Ranking points as prestige | `SigningOffer`, purse, win bonus, “opening card” |

**Ruling:** `tier` / `reputation` / `_promotion_purse_multiplier` are a **promotion** model. They do not mean “IJF pays S-tier UFC money.” For federations, replace purse multiplier with: ranking-event grade, NF quota, and (Olympic IFs) a four-year cycle flag. For IBJJF, replace it with championship-weight × season-weight on ranking points, and a published prize table used **only** where IBJJF itself publishes one.

---

# Section 1 — How a fighter gets in

Per organization: the gate, who controls it, how far in advance it is decided, and whether the athlete competes for a country.

---

## 1.1 `ijf` — International Judo Federation

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | federation, HQ Hungary, `{judo:100}`, S/98, https://www.ijf.org/ | `real_organizations.json` |
| Rules (do not restate) | J1 §1.15. SOR + yuko reinstated 2026–28 | J1 |
| Gate | **National federation inscription in Judobase.** Individuals cannot enter an IJF World Judo Tour event. | IJF SOR §4.2 (2024 PDF, still the last retrieved entry rule): “Only entries from member national judo federations will be accepted.” All delegates need a Judobase profile and a valid **IJF card**, inscribed by the NF by the event deadline. |
| Who controls it | The member **national judo federation**. When two athletes from one country are both live for the same Grand Slam/Grand Prix slot, the NF (not IJF, not the athlete, not a manager) picks. When two are both top-17 in an Olympic weight, the **NOC/NF decides who takes the quota**. | IJF.org 2026-06-19: “the final decision then belongs to the national federation.” LA28 judo QS (IOC, 12 May 2026): quota is by name **except** when an NOC has more than one athlete in the top 17 of a weight — then the NOC chooses. |
| How far in advance | Event inscription closes on a published Judobase deadline (typically on the order of **10 days** before the event; NF card processing is advertised as ~14 working days). Olympic qualification is a **two-year window** that **started at the Ulaanbaatar Grand Slam 2026**. Final Olympic WRL of the qualification period: IJF publishes **by 15 June 2028**; NOCs confirm by **22 June 2028**. | IJF.org 2026-01-19 (ranking season); IJF.org 2026-06-19 (qualification start); LA28 JUD QS PDF. Polish Judo: Judobase closes ~10 days out; IJF card ~14 working days. |
| For a country? | **Yes.** The athlete competes under an NF flag (or IJF/neutral/refugee authorisation). Ranking points accrue to the **athlete** and are also the NF/NOC’s Olympic currency. | IJF 2026 ranking explainer; LA28 QS. |
| Quotas at events | Grand Prix / Grand Slam: **maximum 2 athletes per weight per country** (host may differ — **UNKNOWN** current host extras in the 2026 SOR; 2024 SOR and USA Judo 2026 selection PDF both state 2). Continental Opens: **no per-country cap** in the 2024 SOR table. World Championships Seniors: 2024 SOR — athletes ranked **1–100** on the Senior WRL (plus Juniors 1–16), NF entries up to 9 women / equivalent men with **max 2 per category**. **Confirm in current SOR before wiring the 1–100 floor.** | 2024 SOR PDF; USA Judo *2026 July–December IJF World Tour Event Selection Procedure* PDF (max 2 per country per GP/GS). |
| IJF card | Two types: **international card** (renewable every two years) for WJT including senior worlds; **veterans/kata card** (life) for those events only. Fee is charged by the **NF**, not published as a single IJF athlete price in the Financial Rules. Published NF pass-throughs: British Judo **£65** (one-off veterans/kata vs two-year renewal — form text); Polski Związek Judo **70 EUR / two calendar years**. **IJF’s own unit price: UNKNOWN.** | 2024 SOR §4.2; britishjudo.org.uk/judobase-registration/; pzjudo.pl 2025-12-16. |
| Manager implication | The player does **not** enter Paris GS. The player’s national judo federation does — or does not. A one-fighter manager in a deep judo country (Japan, France, Georgia — the catalog’s `market_assignments` for `ijf`) is competing with **other national-team candidates** for two slots. | IJF.org 2026-06-19 names Japan, Georgia, France as countries where several athletes may earn qualification positions in the same category. |

### Olympic pathway (LA28) — the actual ladder, not a belt

Source: [LA28 Judo Qualification System](https://stillmed.olympics.com/media/Documents/Olympic-Games/LA28/JUD-LA28-Qualification-System.pdf), version 12 May 2026, verified 2026-09-06.

| Layer | What it is | Numbers (do not invent extras) |
|-------|------------|--------------------------------|
| Field | 7 men’s + 7 women’s weights + mixed team | Men −60/−66/−73/−81/−90/−100/+100; women −48/−52/−57/−63/−70/−78/+78 |
| Header **TOTAL** | **372** (186+186) | QS header, version 12 May 2026 |
| Direct WRL | Top **17** per weight on the **Olympic-qualification-period WRL**, max **1 per NOC per weight** | 119 M + 119 W = **238** (D.1.1) |
| Continental WRL | Additional athletes from a continental ranking built off the same WRL; **max 1 per NOC across all weights and genders** via this path | Africa 12+12, Europe 13+13, Asia 12+12, Oceania 4+4, Americas 11+11 = **104** (D.1.2). 238+104 = **342** |
| Host | USA: 7+7 | **14** |
| Mixed-team invitation | 5 continents + 1 from mixed-team WRL for a country missing one mixed-team slot. Invitees also enter individual | **6 athletes** (D.1.3 body: “6 total athletes”) |
| Universality | Tripartite; NOC request deadline 15 Jan 2028 | **10+10** |
| Confirmation | IJF publishes qualification WRL **by 15 June 2028**; NOCs confirm **by 22 June 2028** | — |
| Age | Born on or before **31 December 2013** | QS C.1 |

**Arithmetic note:** 342+14+20+6 = 382, which is **not** the header TOTAL 372. Mixed-team invitees “qualify automatically for both the individual and the mixed team event,” so they may be counted inside another bucket. **Do not invent a reconciliation.** Wire from the PDF; treat the residual as **UNKNOWN / OCR-vs-body**. The operational gates (top 17, 1 per NOC per weight, continental 1 per NOC, NF chooses if two are top-17) are unambiguous.

Qualification **started** at Ulaanbaatar Grand Slam 2026 (IJF.org 2026-06-19). First year = large fields (IJF: 454 judoka / 58 NFs at that GS). Second year = NF shortlists harden.

**UNKNOWN:** current SOR numeric WRL table in the live `sor.ijf.org` HTML (2024 PDF is stale for continental-championship points — see §4.1). Current World Championships 1–100 floor. Exact host extras at a given Grand Slam.

---

## 1.2 `united_world_wrestling` — United World Wrestling

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | federation, HQ Switzerland, `{wrestling:100}`, S/98, https://uww.org/ | `real_organizations.json` |
| Rules (do not restate) | J1 §1.14. UWW International Wrestling Rules Jan 2026 | J1 |
| Gate | **National federation** buys the athlete’s **UWW licence** on Athena and enters the athlete. No individual buy. “No Licence may be requested or granted on competition sites.” | UWW Licence Regulations; uww.org licences page. Constitution Art. 9: wrestlers in international competition (more than five countries) shall hold a valid Federation licence and be entered by their affiliated NF. |
| Who controls it | The affiliated NF. Ranking Series: NF may enter a **maximum of 2 per weight** during the LA28 qualification cycle (UWW circular 2 Feb 2026). Ranking Rule Book (Jan 2026) still says **3** for “UWW Select Ranking Series” with organizer extras — **CONFLICTING; use the LA28 circular for the qualification cycle (2), flag the Rule Book 3 as the non-Olympic-cycle text until UWW unifies.** | `cdn.uww.org/2026-02/01_qs_la28.pdf`; `cdn.uww.org/2025-12/uww_ranking_rule_book.pdf` (dated Corsier-sur-Vevey, January 2026). |
| How far in advance | Licence: NF upload → UWW validates documents → NF pays; confirmation within ~7 days of payment. Engagement fees due by final registration, **one month** before the competition (Worlds, senior continentals, Olympic qualifiers, U23 Worlds, etc.). Olympic cycle: first Ranking Series **15–21 Feb 2027**; 2027 Worlds **11–19 Sep 2027**; ranking quotas allocated after 2028 African Championships; then continental qualifiers; then World Olympic Qualifier. | uww.org licences; uww.org engagement-fees page; uww.org 2026-05-01 calendar article. |
| For a country? | **Yes.** Quota places for LA28 are allocated to the **NOC**, not the wrestler. A country may replace the qualified wrestler for the Games and **keep the Olympic seed**; at all other events the seed belongs to the wrestler. | LA28 WRE QS (13 Aug 2026); UWW circular 2 Feb 2026. |
| Licence prices (published) | U15: **free**. U17 (cadet): **CHF 50**. U20 / U23 / Senior / Veteran: **CHF 100**. Valid to 31 Dec of the year (licences bought 1 Nov–31 Dec valid through next year). | UWW Financial Regulations 2026; uww.org licences (FR page, 2026-09-02). |
| Engagement (entry) fee | **CHF 100 per wrestler** at cadet/junior Worlds, World Cups, senior continental championships, Olympic qualifying tournaments, U23 continental/world, non-Olympic-category Worlds. **No** engagement fee for associated-style events, cadet/junior continentals, veterans, or the Olympic Games themselves. | https://cms.uww.org/about-events/participate/licenses-fees/engagement-fees verified 2026-09-06. |
| Manager implication | Same as judo: the player does not “sign with UWW.” The NF enters. A US wrestler’s real next decision is often **NCAA remaining eligibility vs UWW senior vs leaving for MMA** — three different gates, none of which is a UWW purse contract. | NCAA amateurism is a **national/collegiate** overlay, not a UWW rule. UWW does not pay a UFC-style show purse. |

### Olympic pathway (LA28)

Sources: UWW circular 2 Feb 2026 (`cdn.uww.org/2026-02/01_qs_la28.pdf`); [LA28 Wrestling QS](https://stillmed.olympics.com/media/Documents/Olympic-Games/LA28/WRE-LA28-Qualification-System.pdf) version 13 August 2026; uww.org 2026-05-01 calendar. Verified 2026-09-06.

| Phase | What | Quotas per Olympic weight | Total (18 weights) |
|-------|------|---------------------------|--------------------|
| 1 | 2027 Senior World Championships — **medallists** (gold, silver, two bronzes). Prerequisite: NF competed at 2027 Senior Continental Championships | 4 | 72 |
| 2 | UWW Rankings — first **3** athletes in the ranking **whose NOC is not already qualified** in that weight. Ranking events: 2027 continentals, 3× 2027 Ranking Series, 2027 Worlds, 1× 2028 Ranking Series, 2028 continentals. **Best 5 results** count. Max **2** per NF per weight at Ranking Series; **2 kg** tolerance at Ranking Series only | 3 | 54 |
| 3 | 2028 Continental Qualification Tournaments — **finalists**. Europe / Asia / Pan-America / **Africa+Oceania joint**. NOCs already qualified in that weight stay out (except other style) | 8 (2 per continental grouping) | 144 |
| 4 | 2028 World Olympic Qualifier — **gold only**. Only NOCs with **no** quota yet, **max 2 athletes across all styles** | 1 | 18 |
| **Total** | | **16 per weight** | **288** |
| Host / universality | **None** as direct quota. Universality may appear only in unused-quota reallocation | 0 | 0 |

Age: born on or before **31 December 2010** (at least 18 in 2028). Eligibility: valid NF licence, recorded in UWW’s database.

**Seeding (qualification cycle):** 4 seeds at continentals / continental qualifiers / World Qualifier; 8 seeds at Ranking Series / Worlds / Olympic Games. Olympic seed belongs to the **country**.

**UNKNOWN:** the revised Ranking Series **point table** for the LA28 cycle. Circular: “the current point system must be reviewed.” Until that review publishes, do **not** wire the January 2026 Rule Book Level A/B/C table as the Olympic-ranking formula. The Rule Book table is citable for **non-cycle** Athlete-of-the-Year / seeding (see §4.2).

---

## 1.3 `world_taekwondo` — World Taekwondo

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | federation, HQ South Korea, `{taekwondo:100}`, S/98, https://www.worldtaekwondo.org/ | `real_organizations.json` |
| Rules (do not restate) | J1 §1.16. WT Competition Rules in force 2026-06-01 | J1 |
| Gate | **Member National Association (MNA)** registers the athlete. A **WT Global Athlete Licence (GAL)** is required for WT-promoted/recognized events. Applicant must hold citizenship and/or residence of the MNA they apply through. | WT GMS Bylaws V7 (in force 1 June 2023) Arts. 2.2, 8.2. British Taekwondo / FITA pass-through pages. |
| Who controls it | The MNA (and, for Olympics, the NOC). GP Series: **maximum 32 athletes per weight**; event grade **G-6** (Roma 2026 outline). Olympic quota is allocated to the **NOC**; the NOC picks the athlete subject to ranking windows. | Roma 2026 WT GP Official Outline (SimplyCompete PDF, quoted in live search 2026-09-06): max 32, G-6, single elimination. LA28 TKW QS (12 May 2026). |
| How far in advance | GAL: MNA verification; British Taekwondo asks **two weeks** before event deadlines. Olympic ranking window: **1 July 2026 – 30 June 2028**. Ranking for automatic Olympic places: **January 2028** list (includes 2027 GP Final). | GMS Bylaws; britishtaekwondo.org.uk GAL pages; LA28 TKW QS. |
| For a country? | **Yes.** Quota → NOC. If the quota came via WT Olympic Ranking, the NOC may only enter an athlete who was **top 20** of that ranking at some point in 1 Jul 2026–30 Jun 2028. | LA28 TKW QS C.3. |
| GAL price | WT Global Licence **USD 35 per year per member**, plus MNA markup **not exceeding USD 5**. Some MNAs waived by GDP. Published MNA pass-throughs: British club shop **£45** (includes WT + admin); FITA **€40** (or €45 with card print) from 4 Feb 2025. | GMS Bylaws V7 Art. 7.1 (https://www.worldtaekwondo.org/att_file/documents/WT%20Global%20Membership%20System%20(GMS)%20Bylaws%20(V7)%E2%80%93%20English%20(as%20of%20June%201st%202023).pdf). |
| Extra Olympic eligibility | Kukkiwon **Dan** certificate + GAL. Age: born on or before **31 December 2011** (at least 17). | LA28 TKW QS C.1–C.2 |
| Manager implication | Same national-team logic as judo/wrestling. GP fields are capped at 32 — this is **not** an open. The player does not buy a WT slot the way they buy an IBJJF Open. | Roma 2026 outline. |

### Olympic pathway (LA28)

Source: [LA28 Taekwondo Qualification System](https://stillmed.olympics.com/media/Documents/Olympic-Games/LA28/TKW-LA28-Qualification-System.pdf), version 12 May 2026, verified 2026-09-06.

| Layer | What | Numbers |
|-------|------|---------|
| Events | 4 men’s + 4 women’s Olympic weights | M −58/−68/−80/+80; W −49/−57/−67/+67 |
| Per event | **16** athletes | — |
| Total | 128 | 120 quota + 4 host + 4 universality |
| Max per NOC | 4 men + 4 women, **one per event** | 8 |
| Ranking path | Highest **5** in each weight on the WT Olympic Ranking published **January 2028** (includes 2027 GP Final) | 20 M + 20 W = **40** |
| Grand Slam Champions Series | Highest ranked in each weight on 2027 GS merit standings (reallocate once to 2nd if already ranking-qualified; no further) | 4 M + 4 W = **8** |
| Continental qualification | Only NOCs with **fewer than 2 quotas per gender** from ranking/GS. **Five** Continental Qualification Tournaments. D.3 heading: **36 men + 36 women**. Listed rows: Asia / Europe / Pan-America **two highest per weight**; Oceania **highest per weight**. Africa’s row was dropped in the retrieved parse | **72**. Identity check: 4 Olympic weights × (2+2+2+2+1) = 36 per gender if Africa is also two-per-weight — **INFERRED from the 36+36 heading + four listed continents, not a quoted Africa cell.** Re-read the PDF at wiring |
| Host | 2+2 | 4 |
| Universality | 2+2 | 4 |
| Check | 40+8+72+4+4 | **128** (matches header TOTAL) |
| Quota type | Allocated to the **NOC** | NOC selects, subject to C.3–C.5 windows |

**Grade hierarchy for ranking ties** (QS): G20 Olympic Games → G14 Worlds → G10 GP Final → G6 GP Series / YOG → G4 continentals (2-year) / continental multi-sport (4-year) / Women’s Open / Junior Worlds / U21 / World University Games → G3 President’s Cup → G2 / GP Challenge / CISM / continental juniors / GS Challenge → G1 / World University Champs / other multi-sport / World Military.

**2026 GP calendar** (WT Council allocation, insidethegames 2025-05-09; Italian WP 2026 series page): Series 1 Rome 5–7 Jun; Series 2 Muju 5–7 Sep; Series 3 Paris 9–11 Oct; Final Astana 28–29 Nov.

**UNKNOWN / INFERRED:** Africa’s CQT quota cell (see table). 2026 GP Final prize table (Series prize is published — §2.3). Confirm GP Final grade G-10 from the event outline, not only the bylaw.

---

## 1.4 `cyprus_mmaf` — Cyprus Mixed Martial Arts Federation

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | federation, HQ Cyprus, `{mma:100}`, **C/58**, https://cyprusmixedmartialartsfederation.com/ | `real_organizations.json` |
| Rules (do not restate) | J1 §1.7. IMMAF amateur **INHERITED**. No CMMAF scoring PDF | J1 |
| Official site (re-verified 2026-09-06) | Founded Limassol **2014**, recognized by **K.O.A.** (Cyprus Sports Organisation) **2016**, “under the auspices of **IMMAF**.” Mission: promote/develop MMA in Cyprus; create opportunities to compete internationally. Volunteer coaches. **No** rules PDF, **no** fee schedule, **no** national-championships page, **no** selection policy. | https://cyprusmixedmartialartsfederation.com/ |
| IMMAF membership | Cyprus Mixed Martial Arts Federation listed as IMMAF member | Wikipedia IMMAF members (secondary); IMMAF is the amateur IF |
| Gate to **international** amateur | CMMAF, as the IMMAF member NF, enters a **national team**. Athletes must be nationals of the country they represent (passport). IMMAF Championships are **amateur only**. | IMMAF nationality rules; IMMAF athlete-eligibility page |
| Gate to **domestic** | **UNKNOWN.** No published national-championships qualifier, membership fee, or licence on the CMMAF homepage. | CMMAF site 2026-09-06 |
| Who controls it | CMMAF (international). K.O.A. recognition is the national-sport-authority overlay, not a published athlete-entry rule. | CMMAF about text |
| How far in advance | IMMAF 2026 Worlds (Tbilisi, 1–7 Nov 2026): first-pick windows from **13 Jul 2026**; remaining places to **1 Sep 2026**. Teams pay **in bulk**. | immaf.smoothcomp.com/en/event/33657 |
| For a country? | **Yes**, at IMMAF Championships. The athlete represents Cyprus. Dual-nationality switches: once, with cooling-off; IMMAF nationality PDF. | IMMAF nationality rules |
| Manager implication | CMMAF is a **feeder**, not a promotion. The honest loop is: amateur bouts under IMMAF-legal rules → CMMAF selects for IMMAF Europeans/Worlds → **turn pro** into the 13 promotions (or stay amateur). Paying this fighter a UFC purse is the current lie **and** would, under IMMAF rules, **end** the amateur career. | IMMAF eligibility (below) |

**Do not list CMMAF council/coach names as data.** They appear on the public homepage; they are not a game table.

**UNKNOWN:** CMMAF domestic membership fee, national championships format, how many athletes per IMMAF weight CMMAF is allocated, whether CMMAF runs any professional cards, K.O.A. stipend.

---

## 1.5 `ibjjf` — International Brazilian Jiu-Jitsu Federation

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | **tournament_operator** (not a federation in this catalog), HQ USA, `{brazilian_jiu_jitsu:100}`, S/95, https://ibjjf.com/ | `real_organizations.json`; market_assignments Brazil |
| Rules (do not restate) | J1 §1.9. Rules Book v6.1 Jun 2024 | J1 |
| Gate | **Open, paid, individual.** (1) IBJJF account. (2) **Active membership** on event day. (3) Academy affiliation (gym registered; professor approves). (4) Event registration + fee. (5) Make weight (gi: weigh-in **in the gi**). Adult black belts additionally need **ranking points** for specified majors, unless exempt. | help.ibjjf.com/membership/; ibjjf.com/athlete-ranking-info |
| Who controls it | The athlete (and the professor who must approve membership). IBJJF does not select a national team. Brackets fill; popular classes close. | IBJJF help desk |
| How far in advance | Event packets publish affiliation / registration / correction / check-day deadlines. Example: 2026 World Master (Las Vegas, 3–5 Sep) — affiliation 13 Aug, registration 23 Aug, check-day 28 Aug (FloGrappling 2026-08-12). 2026 Worlds (Long Beach) registration windows closed 17 May 2026 (Rollbook recap). | Event-specific; do not invent a universal lead time |
| For a country? | **No.** The athlete competes for an **academy**, not a country. Ranking is individual, by age × belt × gi/no-gi. Points survive an academy change. | ibjjf.com/athlete-ranking-info |
| Black-belt major floors (published) | BJJ Pro: **10** pts. Pan / European / Brasileiro (gi): **40**. Worlds (gi): **95**. Worlds no-gi: **30**. Exemptions: former black-belt World / World No-Gi champions; previous-season adult brown-belt World champions (gi or no-gi). | https://ibjjf.com/athlete-ranking-info verified 2026-09-06 |
| Membership prices | Official membership page (live search 2026-09-06): new **USD 45.00**/year; minor **USD 30.00**; renewal **USD 40.00**; early-renewal discount, **minimum USD 15.00**. Cookie-walled HTML fetch this pass did not return the price block — **cite the official URL; treat the search extract as the 2026-09-06 live figure; re-fetch at wiring.** | https://ibjjf.com/athletes/become-a-member |
| Belt certificate (not membership) | First black-belt certificate **USD 400**; each degree renewal **USD 150**. Not annual. Separate from membership. | https://help.ibjjf.com/black-belt-certification/ verified 2026-09-06 |
| Academy registration | JBJJF (Japan affiliate) publishes IBJJF academy **new/change USD 70**. **Confirm on ibjjf.com academy page before wiring as global.** | jbjjf.com/registration/academy/ |
| Manager implication | This is the **one** in-scope org a manager actually **enters week to week**: pick the event, pay the fee, pick weight, accept the bracket. No contract. No country quota. The cost is the point. | — |

**Graduation (time-in-rank, for the belt ladder — not match scoring):** IBJJF General System of Graduation June 2026. Adult/masters common table (secondary recap of the official chart; **use the June 2026 PDF at wiring**): purple requires 2 years as blue; brown 1.5 years as purple; black 1 year as brown; age floors blue 16 / brown 18 / black 19, with World-champion waivers. Do not invent stripe fees — academy promotion charges are gym-level, **UNKNOWN** as an IBJJF number.

---

# Section 2 — Money: which direction it flows

**Polarity first.** Promotions: money flows **to** the fighter (purse, win bonus; PFL tournament prize is still org→fighter). Federations and IBJJF: the fighter (or the NF) **pays to appear**. Prize money, where it exists, is a **medal table**, not a bout contract. Living costs are travel, camps, and **national** stipends — almost never an IF salary.

Figures below are **published**. Year totals that are not published are **UNKNOWN**. Do not invent a “realistic year.”

---

## 2.0 Contrast: what the 13 promotions already model

| Flow | Promotions (baseline) | Federations / IBJJF |
|------|----------------------|---------------------|
| Show money | Purse (`get_promotion_bout_offer`) | **None** as a bout contract |
| Win bonus | Yes (same function) | **None** |
| Prize | Some (PFL tournament; Jungle Fight do Milhão is a GP overlay — J1 §1.8) | Medal tables at specified events (below) |
| Entry | Promotion pays the fighter to take the fight | Fighter/NF pays the organizer |
| Exclusive signing | `accept_signing_offer` | **Not this object** |

PFL 2025 World Tournament prize **USD 500,000** (was USD 1,000,000) is a **promotion** prize — J1 §1.2. Do not copy it onto IBJJF Worlds.

---

## 2.1 `ijf` — prize down, fees up, salary is national

### Prize money (IJF → medallists)

Source: [IJF Financial Rules 2025](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2025/08/IJF_Financial_Rules_2025-17544-1754474721.pdf), updated 1 January 2025, verified 2026-09-06. Amounts **USD**. Event outlines may pay in EUR at the same headline numbers (Tashkent GS 2025 outline: gold **5,000 euro**, of which judoka 4,000 / coach 1,000 — 20% to coach).

| Event | 1st | 2nd | 3rd |
|-------|-----|-----|-----|
| World Championships **Senior** individual | 26,000 | 15,000 | 8,000 |
| World Championships **Junior** individual | 2,000 | 1,400 | 800 |
| World Championships **Cadet** individual | 1,700 | 850 | 350 |
| World Championships **OPEN** individual | 100,000 | 50,000 | 25,000 (5th 10,000; 7th 5,000; best 16 2,500) |
| **Grand Slam** individual | 5,000 | 3,000 | 1,500 |
| **Grand Prix** individual | 3,000 | 2,000 | 1,000 |
| World Championships Senior **team** | 90,000 | 60,000 | 25,000 |
| World Championships Junior **team** | 8,000 | 5,600 | 3,200 |
| World Masters | 6,000 | 4,000 | 2,000 |

**Masters row caveat:** that 6,000/4,000/2,000 block sits on the team-competitions page of the 2025 Financial Rules (after junior teams). **UNKNOWN whether it is individual Masters or team Masters.** Historical individual Masters prizes were in this band. Do not wire as a team prize without re-reading p.26 of the PDF.

Tashkent GS 2025 outline (primary event packet): prize paid only if the medallist attends the ceremony with passport + tax number; athlete is responsible for passing **20% to the coach**. **Do not assume every 2026 GS outline is EUR-not-USD** — Financial Rules say USD; outlines may convert. **UNKNOWN** whether 2026 outlines still split 80/20.

**No purse. No win bonus. No payment for a first-round loss** (unlike a UFC show purse). Continental Opens: Financial Rules do not list a prize; Japanese WP notes Opens generally have none unless the host NF adds one — treat Open prize as **UNKNOWN / host-optional**.

### Fees (NF / athlete → IJF or LOC)

| Item | Published figure | Source |
|------|------------------|--------|
| World Championships **inscription** (if IJF introduces it) | **USD 100** per entry per category | Financial Rules §3.10 (“In case the IJF decides the following inscription fees **may** be introduced”) — **conditional**, not a standing athlete invoice |
| Junior Worlds inscription (same clause) | USD 50 | same |
| Cancellation after deadline | USD 100 | same |
| Extra team-official accreditation | USD 100 to LOC | 2024 SOR |
| Lost accreditation | USD 50 to IJF | 2024 SOR |
| IJF international card | **UNKNOWN at IJF**; NF pass-through examples £65 / 70 EUR / 2 years | §1.1 |
| National licence (France, Japan, USA Judo, etc.) | **UNKNOWN** as a single number; each NF publishes its own | do not invent |
| Hotels / full board at WJT | LOC packages; cancellation often **100% from ~13 days out** (Tashkent GS 2025 outline) | event outlines |

### National funding (not IJF)

IJF does not publish a salary. High-performance money is **NATIONAL**:

| Overlay | Published figure | Label |
|---------|------------------|-------|
| USOPC Operation Gold (any Olympic sport) | Gold **USD 37,500** / silver **22,500** / bronze **15,000** per medal (unchanged through Milano Cortina 2026 reporting) | **NATIONAL** (USOPC), not IJF |
| USA Judo / USOPC grants | USOPC 2024 Form 990 lists a grant line to United States Judo, Inc. **USD 693,900** — that is an NGB grant, **not** an athlete stipend | NATIONAL |
| Other NOCs | USA TODAY 2024 survey: 25 NOCs averaged ~USD 95k gold; range is wide. **Do not invent Cyprus/Georgia/Japan/France judo bonuses.** | UNKNOWN per country unless a primary NF/NOC page is filed |

**Year cost vs pay (honest bound, not a fake budget):** a non-medallist on the WJT has **negative cash from IJF** (prize is podium-only). Travel/hotels are NF or self-funded — **UNKNOWN** as a year total. A Grand Slam gold is USD 5,000 (minus coach share if the outline says so). A senior World gold is USD 26,000. That is not a UFC contract.

---

## 2.2 `united_world_wrestling` — licence up, prize small or **removed in the Olympic cycle**

### Fees (NF → UWW)

| Item | Amount | Source |
|------|--------|--------|
| Athlete licence U15 | CHF 0 | Financial Regulations 2026; uww.org licences |
| Athlete licence U17 | CHF 50 | same |
| Athlete licence U20/U23/Senior/Veteran | CHF 100 | same |
| Engagement fee (listed championships/qualifiers) | CHF 100 per wrestler | engagement-fees page |
| NF annual membership (affiliated) | CHF 2,000 | Financial Regulations |
| NF annual (associated) | CHF 500 | same |
| Ranking Series org fee (per style) | CHF 1,000 | same |
| Change of sporting nationality (scale) | from CHF 10,000 floor; Olympic/World gold **CHF 300,000** (host NF) | Change of Nationality Regulation Oct 2024 |

Licence includes competition-accident insurance under UWW’s described conditions. Individuals **cannot** buy a licence.

### Prize money (UWW → wrestlers)

| Programme | Published | Status for 2026–28 |
|-----------|-----------|---------------------|
| Ranking Series 2023 | Gold **CHF 1,500** / silver **750** / two bronzes **500** each; total pot CHF 390,000 across four events | **2023 primary** (uww.org 2023-01-18). **Do not assume it is 2026.** |
| Best wrestler of the year 2023 | CHF 150,000 pot; 30 wrestlers (10 per style); “three first athletes per weight category will receive a prize money, **which is defined at the beginning of each year**” (Rule Book Jan 2026) | Year-by-year amount **UNKNOWN** unless that year’s circular is filed |
| LA28 qualification cycle | UWW circular 2 Feb 2026: “the use of the prize money awarded at the Ranking Series events **will be removed during the qualification phase**. This money will be used to provide additional support to the developing countries.” | **Removed at Ranking Series during the qualifying phase** (Ranking Series 2027+). 2026 Ranking Series prize: **UNKNOWN** (cycle starts Feb 2027) |
| World Championships individual prize | **UNKNOWN** in the Financial Regulations pages retrieved (org fees and engagement fees are listed; an athlete prize table for Worlds is **not** in the excerpts pulled) | UNKNOWN |

### National overlays (not UWW)

| Overlay | Figure | Label |
|---------|--------|-------|
| USA Wrestling **Living the Dream Medal Fund** | Olympic: gold **USD 250,000** / silver **50,000** / bronze **25,000**. Senior Worlds: gold **50,000** / silver **25,000** / bronze **15,000**. USD 6.08M distributed since 2009 | **NATIONAL / private fund**, not UWW |
| USOPC Operation Gold | USD 37,500 / 22,500 / 15,000 | NATIONAL |
| USA Wrestling 2026 funding schedule (USOPC Enhanced Operation Gold) | Monthly World-Team amounts in a 2026 PDF (e.g. 2025 Worlds gold **USD 2,250**/month in named windows) — **cite the PDF, do not re-invent the whole grid here** | NATIONAL |
| UWW development: Technical Assistance for Competitions | 252 athletes/coaches supported to continentals/worlds in 2025 (UWW 2025 report) — **not a published per-athlete stipend** | UNKNOWN unit amount |

**Year cost vs pay:** a senior licence is CHF 100; a Worlds engagement is CHF 100; travel is NF. Ranking Series gold in 2023 was CHF 1,500 — **less than many IBJJF black-belt World prizes, and scheduled to vanish in the Olympic qualification phase.** Living wage is national-team funding, **UNKNOWN** as a UWW number.

---

## 2.3 `world_taekwondo` — GAL up, GP prize published, Olympic money is national

### Fees (athlete/MNA → WT)

| Item | Amount | Source |
|------|--------|--------|
| WT Global Licence | **USD 35**/year + MNA markup **≤ USD 5** | GMS Bylaws V7 Art. 7.1 (1 June 2023) |
| Free-MNA waiver | GDP-based; those MNAs cannot add markup | same |
| Published MNA pass-through | UK club **£45**; FITA **€40** (€45 with card) | Total Taekwondo; taekwondoitalia.it 2025-02-04 |

Event entry fees for a given GP/Worlds: **UNKNOWN** as a global WT athlete price (MNA/outline specific). Roma 2026 outline retrieved via search quotes medals + prize, not an athlete entry fee in the excerpt.

### Prize money (WT / LOC → medallists)

Roma 2026 World Taekwondo Grand Prix **Official Outline** (SimplyCompete event document, quoted in live search 2026-09-06):

| Place | Prize | Also |
|-------|-------|------|
| 1st | **USD 5,000** | gold medal + certificate |
| 2nd | **USD 3,000** | silver + certificate |
| 3rd (each) | **USD 1,000** | bronze + certificate |

Event grade **G-6**. Ranking points in the same outline: 1st **60.0** / 2nd **36.0** / 3rd **21.6** / 5th **12.96** / 9th **9.07** / 17th **6.35** — matches WT Ranking Bylaw G6 column (30 Sep 2024).

**GP Final prize: UNKNOWN** this pass (do not copy Series numbers onto the Final). World Championships prize: **UNKNOWN** this pass.

### National overlays

| Overlay | Figure | Label |
|---------|--------|-------|
| USOPC Operation Gold | USD 37,500 / 22,500 / 15,000 | NATIONAL |
| USA Taekwondo “Stevens Financial Security Award” (USOPC Foundation gift) | **USD 100,000** deferred (20 years after Games or age 45) + **USD 100,000** beneficiary support, described as **USD 200,000 per Games** competed — from USA Taekwondo 2025-03-06 | NATIONAL / donor, **not WT** |
| Other NOC taekwondo bonuses | UNKNOWN unless a primary page is filed | UNKNOWN |

**Year cost vs pay:** GAL is tens of dollars. A GP gold is USD 5,000. Travel/camps are MNA. Year total **UNKNOWN**. Not a WT salary.

---

## 2.4 `cyprus_mmaf` / IMMAF — the fighter pays, and a purse would **disqualify** them

| Item | Figure | Source |
|------|--------|--------|
| CMMAF membership / national licence | **UNKNOWN** (not on homepage) | cyprusmixedmartialartsfederation.com 2026-09-06 |
| IMMAF 2026 World Championships athlete fee | **EUR 650** (seniors and juniors) | immaf.smoothcomp.com/en/event/33657 — Tbilisi, 1–7 Nov 2026 |
| IMMAF 2026 Worlds coaches / team leaders | **EUR 350** | same |
| IMMAF prize money | **UNKNOWN** (amateur championships; do not invent a podium purse) | — |
| Allowed amateur money | Prize money, sponsorships, and **up to USD 1,000** (or equivalent) in paid expenses from a promoter — above that, or a **contracted purse**, = professional | https://immaf.org/athletes/athlete-eligibility/ verified 2026-09-06 |
| CMMAF/IMMAF **show purse** | **Must be zero** in the IMMAF sense. A UFC-style purse is exactly the thing that ends eligibility | same |

**Year cost vs pay:** a Cyprus amateur who goes to IMMAF Worlds pays **EUR 650** plus travel (NF may or may not cover — **UNKNOWN**). Pay from CMMAF: **UNKNOWN**, almost certainly **not a purse**. The honest year is cost-positive for the athlete.

---

## 2.5 `ibjjf` — the operator the catalog already called a tournament_operator

**Direction: athlete → IBJJF**, except at published black-belt prize tables.

### What the athlete pays

| Item | Published | Source |
|------|-----------|--------|
| Membership, new | **USD 45**/year | ibjjf.com/athletes/become-a-member (live search 2026-09-06; re-fetch at wiring) |
| Membership, renewal | **USD 40**/year (early-renewal discount, min USD 15) | same |
| Membership, minor | **USD 30**/year | same |
| Black-belt certificate | **USD 400** first; **USD 150** per later degree | help.ibjjf.com/black-belt-certification/ |
| Academy registration | USD 70 new/change (JBJJF-published IBJJF figure) | jbjjf.com — confirm global |
| Event registration | **Event-specific, rising by window.** 2026 Worlds (Long Beach) recap: early **USD 153** / extended **186** / final **204** (Rollbook). 2025 Worlds: **148 / 180 / 198** (JiuJitsu News). 2026 World Master: **143 / 175 / 184** (FloGrappling). Opens: typically lower; secondary guides quote ~USD 90–150. **Do not invent a universal Open fee — use the event packet.** | event pages / reputable recaps of packets |
| Brasileiro 2026 entry (BRL) | Secondary: **R$264–R$302** (~USD 52–60) | BJJ Problems 2026-05-07 — **secondary**; use IBJJF packet if wiring |
| Refunds | Membership: generally **not refunded** if you then fail to register for the event. Event fees: generally **not refundable** | help.ibjjf.com/membership/; secondary registration guides |

### What IBJJF pays (published prize tables — black belt only unless stated)

**World Championship black-belt adult** (Rollbook recap of 2026 packet; JiuJitsu News 2025 packet similar):

| Division size | 1st place |
|---------------|-----------|
| 2–8 athletes | USD 7,000 |
| 9–16 | USD 8,000 |
| 17–32 | USD 9,000 |
| 33+ | USD 10,000 |
| Open class (absolute) | **USD 18,000** |

**Confirm on the live Worlds packet before wiring** — these are recaps of IBJJF prize copy, not the PDF itself. Taxes: IBJJF ranking-awards page states USA federal/state tax treatment; athlete is responsible.

**Adult Black Belt League ranking awards, end of season 2026/27** (official ranking page):

| Place | Amount |
|-------|--------|
| 1st | **USD 20,000** |
| 2nd | **USD 6,000** |
| 3rd | **USD 3,000** |

Source: https://ibjjf.com/athlete-ranking-info verified 2026-09-06.

**Most divisions at most events pay USD 0.** White/blue/purple/brown, masters, kids: compete for medals and ranking points. Brasileiro 2026 secondary: black-belt weight winner ~**R$13,750** (~USD 2,700) vs ~8,000 paying athletes — **secondary math; do not treat the USD conversion as IBJJF’s**.

### Year cost vs pay (bounded, not invented)

A hobbyist: membership ~USD 40–45 + 1–2 Opens ~USD 90–150 each + gym dues (**UNKNOWN**, gym-level). Prize: **USD 0**.

An adult black belt chasing Worlds: membership + multiple Opens to bank **95 gi ranking points** + Worlds entry **USD 153–204** + Long Beach travel (**UNKNOWN**). Prize: **USD 0 unless they win a black-belt adult division**. A World absolute winner takes USD 18,000 **once**. Season ranking 1st takes USD 20,000 **once**. The median IBJJF year is **the athlete paying IBJJF**.

That is the opposite of `get_promotion_bout_offer`.

---

## 2.6 Money-flow summary (wire this, not a purse multiplier)

| org id | entity | Bout purse | Win bonus | Published prize | Athlete/NF fees | National stipend / medal bonus |
|--------|--------|------------|-----------|-----------------|-----------------|--------------------------------|
| 13 promotions | promotion | YES (already modelled) | YES | some overlays | no entry fee to the promotion | n/a |
| `ijf` | federation | **NO** | **NO** | GS/GP/Worlds/Masters tables (USD, §2.1) | IJF card (NF), possible USD 100 Worlds inscription, LOC hotels | NATIONAL, UNKNOWN per country; USOPC Operation Gold if US Olympian |
| `united_world_wrestling` | federation | **NO** | **NO** | Ranking Series prize **removed in LA28 qual phase**; 2023 CHF 1,500 gold is historical | CHF 100 senior licence; CHF 100 engagement at listed events | NATIONAL (e.g. USA Wrestling LDMF); UWW does not publish a salary |
| `world_taekwondo` | federation | **NO** | **NO** | Roma 2026 GP USD 5,000/3,000/1,000; Final/Worlds **UNKNOWN** | GAL USD 35 + ≤5 MNA | NATIONAL |
| `cyprus_mmaf` | federation | **NO** (and a purse would be disqualifying) | **NO** | **UNKNOWN** (no prize table on the CMMAF homepage) | IMMAF Worlds **EUR 650**; CMMAF domestic **UNKNOWN** | UNKNOWN |
| `ibjjf` | tournament_operator | **NO** | **NO** | Worlds black-belt table; 2026/27 ranking awards USD 20k/6k/3k; most events **USD 0** | membership USD 40–45; event USD ~90–204; black-belt cert USD 400 | n/a (academy sport, not NOC) |

---

# Section 3 — Exclusivity / amateur-pro / real vs fake combinations

Promotional contracts are usually exclusive. Federation competition usually is not. The exceptions that **do** close a door are eligibility rules, not “signed with IJF.”

## 3.1 Combination matrix (in-scope orgs × the 13 promotions)

| Combination | Real? | Why | Game ruling |
|-------------|-------|-----|-------------|
| UFC/PFL/ONE/RIZIN/Jungle/LUX/ARES/URCC/ROAD **exclusive contract** + another **promotion** | Usually **not**, by contract (already the signing model) | House exclusive | Keep `accept_signing_offer` exclusive **among promotions** |
| **IBJJF** + any grappling promotion (ONE grappling, UFC BJJ, ADCC) | **IBJJF itself does not forbid it.** The **promotion** may. UFC BJJ executives have stated exclusivity vs ADCC going forward (MMA Mania 2026-02-26) — that is a **promotion** overlay, not an IBJJF rule | IBJJF = open_entry. If the fighter later **signs** UFC BJJ/ONE, exclusivity is the promotion’s | `ibjjf` never sets `exclusive`. A later `signing` offer may |
| **IBJJF** + local MMA amateur | Real and common. IMMAF FAQ: traditional tournament BJJ **even with prize money** is **amateur**; **contracted and paid** BJJ is professional | IMMAF eligibility FAQ | IBJJF prize ≠ `turned_pro`. A contracted BJJ purse **does** |
| **IBJJF** + UFC/PFL MMA contract | Real as a **crossover after** (or instead of) the circuit. The MMA exclusive then constrains other **promotions**, not IBJJF entry, unless the contract says so (**UNKNOWN** per promotion — do not invent a UFC-vs-IBJJF clause) | — | Don’t auto-ban IBJJF on MMA signing unless a contract flag is authored |
| **IJF WRL athlete** + international MMA / wrestling / sambo / other combat IF | **Not without IJF authorization.** SOR Art. 4.1 (as published by British Judo 2019-04-04, quoting IJF): “An athlete classified in any IJF WRL (cadet, junior or senior) is **not authorized** to take part in an international competition of any combat sport, other than judo, unless authorization has been given by the IJF.” Sanctions: 1st **2 months** suspension; 2nd **2 years**. Appeal does not delay | https://www.britishjudo.org.uk/ijf-release-participation-of-judoka-in-other-combat-sports-international-competition/ | `ijf` pathway: `if_authorization` for other-combat internationals while on any WRL. Do **not** silently let a ranked judoka take a UFC fight |
| **IJF** + domestic judo | That’s the sport | — | Allowed |
| **UWW** + NCAA (US) | Real **until** the athlete takes a professional MMA fight / endorsement that breaks NCAA amateurism. UWW itself is not a pro league | NCAA amateurism is **NATIONAL/collegiate**, not a UWW exclusive | Don’t model NCAA unless a US amateur flag is in scope. Turning **pro MMA** is the one-way |
| **UWW** + UFC/PFL/RIZIN MMA | **Real as a leave.** High-level wrestlers historically move into MMA promotions. It is typically **leaving** the senior World/Olympic path, not dual-wielding a UFC camp and a World-Championship peak in the same week | Practice, not a UWW ban document retrieved this pass. UWW exclusive-vs-MMA clause: **UNKNOWN** (do not invent one) | Treat as a **feeder out**: `national_selection` → `signing`. Do not pay UWW purses on the way |
| **WT** + MMA | Occurs; not the WT product. WT GAL does not read as a promotional exclusive. Olympic-year NOC programmes may **practically** forbid it — **UNKNOWN** as a WT bylaw | GMS Bylaws retrieved: licence + nationality, not MMA exclusivity | Don’t invent a WT-vs-UFC ban |
| **CMMAF/IMMAF amateur** + **any** professional MMA (UFC, PFL, ONE, Jungle, LUX, ARES, URCC, ROAD, RIZIN) | **Closes IMMAF.** One Unified-Rules (or equivalent) pro MMA bout, a contracted purse, a published pro record, **or** (from 2025) any MMA bout allowing **elbows and/or knees to the head** | immaf.org/athletes/athlete-eligibility/ | `turned_pro = 1` is sticky. CMMAF pathway ends |
| **CMMAF** + IBJJF | Real. IMMAF: tournament BJJ with prize ≠ pro | IMMAF FAQ | Allowed |
| **CMMAF** + A-class Muay Thai | IMMAF: A-class Muay Thai **ends** IMMAF eligibility; N/C/B limited-rule variations are amateur | IMMAF FAQ | Don’t silently allow RWS/ONE Muay Thai + IMMAF |
| Olympic IF athlete + **Olympic marks as a personal brand** | Not the athlete’s to license | §6.1 | Text names of sports, not rings/“Olympic” as a mode title |

## 3.2 Amateur / professional boundaries (the doors)

| Boundary | What closes it | What does **not** close it |
|----------|----------------|----------------------------|
| **IMMAF amateur** (CMMAF’s international gate) | Pro MMA (Unified or equivalent); contracted purse; published pro combat record; 2025+ elbows and/or knees to the head in **any** MMA bout; A-class Muay Thai; contracted (not tournament) BJJ | Tournament BJJ with prize; sponsorships; ≤ USD 1,000 promoter expenses; limited-rule Muay Thai N/C/B |
| **NCAA amateur** (US wrestling overlay) | Professional contracts / prohibited pay under NCAA rules | UWW licence and senior international wrestling as such — **NCAA’s own rulebook is the authority; UNKNOWN details not retrieved this pass.** Do not invent a dollar threshold |
| **IJF WRL** | Other-combat **international** without authorization | Domestic judo; authorized exceptions |
| **Olympic eligibility** | IOC/NOC nationality, anti-doping, age, IF licence/GAL/Judobase; for WT also Kukkiwon Dan | IBJJF medals, IMMAF medals, UFC contracts — different sports. A judoka who takes unauthorized MMA may lose **IJF** access, which is the Olympic path |
| **IBJJF** | Unpaid membership, missed weight, belt/age mismatch, black-belt point floor at majors | Being paid MMA/BJJ elsewhere — IBJJF does not run an amateur-status police in the IMMAF sense |

**Ruling:** the game’s current purse-on-CMMAF is not only economically false; it is **eligibility-false**. The minimum change (D6) must set `cyprus_mmaf` bouts as amateur (J1 §1.7 `mma_immaf_amateur`) with **no purse**. Accepting a promotion signing flips `turned_pro` and removes IMMAF/CMMAF international eligibility.

---

# Section 4 — What a win is worth

A promotion win moves you up a **promotion ranking toward a belt**. Federation/IBJJF wins move you along a **cycle**: ranking points, seeding, NF selection, Olympic quota, a medal, a belt promotion, a season award. They do **not** pay a show purse.

Do not restate J1 scoring. A “win” here means **match victory → ranking/selection/money consequence**.

---

## 4.1 `ijf` — 24-month WRL, 2-year Olympic window, annual Worlds

**Decay (IJF.org 19 Jan 2026, citing SOR):** 12 months at **100%**; then **50%**; after **24 months** expire. Week-number based (Monday start). Continental championships treated as the **same week** across continents.

**Best-results cap:** 2024 SOR stated **5+1 best** in the 100% period and **5+1** in the 50% period. 2026 IJF ranking article describes decay but **does not restate the cap**. **UNKNOWN whether 5+1 still binds** until current `sor.ijf.org` is filed. Do not invent a cap.

**Point values, 2025–28 cycle (reconstructed from live 2026 WRL rows + Wikipedia 2025–2028 table; live checks: GP participation 6, GP 1/16 112, GS participation 10, GS 1/16 160, continental championship 5th 288).** 2024 SOR PDF had continental championships **= Grand Prix 700** — **stale**.

| Result | Olympic Games | World Championships | World Masters | Grand Slam | Continental Champs | Grand Prix | World Juniors | Continental Open |
|--------|---------------|---------------------|---------------|------------|--------------------|------------|---------------|------------------|
| 1st | 2,200 | 2,000 | 1,800 | 1,000 | 800 | 700 | 700 | 100 |
| 2nd | 1,540 | 1,400 | 1,260 | 700 | 560 | 490 | 490 | 70 |
| 3rd | 1,100 | 1,000 | 900 | 500 | 400 | 350 | 350 | 50 |
| 5th | 792 | 720 | 648 | 360 | 288 | 252 | 252 | 36 |
| 7th | 572 | 520 | 468 | 260 | 208 | 182 | 182 | 26 |
| 1/16 | 352 | 320 | 288 | 160 | 128 | 112 | 112 | 16 |
| 1/32 | 264 | 240 | 216 | 120 | 96 | 84 | 84 | 12 |
| 1 contest won | — | 200 | — | 100 | 80 | 70 | 70 | 10 |
| Participation | — | 20 | 100 | 10 | 6 | 6 | 6 | 0* |

\*2024 SOR: Continental Open needs **minimum one contest won** to score; participation alone = 0.

**Tiebreak (IJF.org 2026):** sum of current Worlds points → sum of GP+GS+Masters → highest single-event score, then second, etc. Olympic-qualification ties: **IJF Executive Committee**.

**Calendar, not cards:** annual World Championships (including Olympic years); Masters (invitation from WRL — 2019+ top 36, Wikipedia; **confirm current Masters field in SOR**); a series of Grand Slams and Grand Prix; continental championships and Opens (continental unions, still WRL events). Olympic Games sit on the WRL but are **IOC-owned**, not WJT.

**What a win is worth, in order:** (1) WRL points toward seeding and Olympic top-17. (2) NF attention vs the other domestic candidate for the 2-per-country GS slot. (3) Medal prize (§2.1) if you podium. (4) National bonus **if** the NOC pays one. **Not** a UFC ranking notch.

---

## 4.2 `united_world_wrestling` — yearly ranking reset except Worlds/OG; Olympic quotas in four phases

**Non-cycle Ranking Rule Book (January 2026)** — use for Athlete-of-the-Year / ordinary seeding **until** the LA28 point-system review publishes:

Levels: **A** Olympic Games + Senior Worlds; **B** Senior Continental Championships; **C** Ranking Series + continental/regional games under UWW agreement.

| Place | Level A | Level B | Level C |
|-------|---------|---------|---------|
| 1st | 40,000 | 10,000 | 8,000 |
| 2nd | 32,000 | 8,000 | 6,400 |
| 3rd | 26,000 | 6,500 | 5,200 |
| 4th* | 23,200 | 5,800 | 4,640 |
| 5th | 20,000 | 5,000 | 4,000 |
| 6th** | 18,800 | 4,700 | 3,760 |
| 7th | 13,200 | 4,400 | 3,520 |
| 8th | 12,000 | 4,000 | 3,200 |
| … | … | … | … |
| 16th | 400 | 100 | 13 |

\*one-bronze systems. \*\*one 5th (e.g. doping). 1 participant = 0 points; 2–5 participants = half points, top 3 only. 1 Jan: **wipe all except Worlds and/or Olympic points**.

Olympic-year extra if OG and Senior Worlds coincide: OG gold **+8,000** / silver **+6,400** / bronze **+5,200**.

**LA28 ranking (QS):** best **5** of 7 listed events; Ranking Series prize **removed**; point table **under review** — **do not ship the table above as the Olympic formula**.

**Calendar:** Ranking Series (4 in a normal year; **2 in 2028** — Zagreb + Budapest per 2024 host stamp; 2027 has 3 in the QS). Senior continentals (spring). Senior Worlds (Sep 2027 Las Vegas window in UWW calendar article). Then 2028 continentals → ranking quotas → continental qualifiers → World Qualifier. Age-group Worlds (U17/U20/U23) are a **separate** ladder.

**What a win is worth:** (1) ranking points / seeds. (2) a **quota for the NOC** if it is a 2027 Worlds medal or a ranking/qualifier slot. (3) national medal funds (USA LDMF, etc.). (4) historically a small Ranking Series cheque, **off during qualification**. **Not** a UWW belt.

---

## 4.3 `world_taekwondo` — G-grade points, 2-year Olympic ranking, 16-person Olympic weights

**WT Ranking Bylaw (30 Sep 2024)** gold points:

| Grade | Typical event | 1st | 2nd | 3rd |
|-------|---------------|-----|-----|-----|
| G1 | WT-sanctioned opens | 10 | 6 | 3.60 |
| G2 | (incl. GP Challenge special column) | 20 | 12 | 7.20 |
| G3 | President’s Cup (QS hierarchy) | 30 | 18 | 10.80 |
| G4 | Continentals (2-year), some multi-sport | 40 | 24 | 14.40 |
| G6 | **GP Series** | **60** | **36** | **21.60** |
| G10 | **GP Final** | 100 | 60 | 36 |
| G14 | World Championships | 140 | 84 | 50.40 |
| G20 | Olympic Games | 200 | 120 | 72 (repechage table differs) |

Roma 2026 GP outline G-6 column matches. G-1/G-2/G-3: must **win at least one match**; bye/DSQ is not a win.

**Two-year ranking cycle** (WT news + bylaw): non-Olympic ranking period **1 Jun 2024 – 31 May 2026**; Olympic ranking period **1 Jun 2026 – 31 May 2028**. Points from the first period **zero out** when the second begins (they still matter for GP **eligibility/seeding** into the second period). Weight-category change window **1–25 May**; selected Olympic weight locked **1 Jun–31 May**.

G1–G4 **point caps** per Olympic-weight for the cycle are tabulated in the bylaw (e.g. 2025 calendar year cap 40; 1 Jan–31 May 2026 cap 20, etc.). **Do not invent a cap for a year not in the table.**

**Calendar:** World Championships (non-Olympic weights too); GP Series (3) + GP Final; GP Challenge; continentals; Women’s Open; Grand Slam Champions Series (Olympic-quota path, 8 places). Best-of-three vs cumulative-3 is an **event-packet** choice (J1 §1.16) — not a ranking rule.

**What a win is worth:** G-points toward January 2028 Olympic ranking (top 5 per weight = NOC quota) and GP seeding; USD 5,000 if it is a GP Series gold; national Olympic bonuses. **Not** a WT salary. Olympic field is **16**, not an open.

---

## 4.4 `cyprus_mmaf` — national team, then a one-way pro door

There is **no CMMAF ranking PDF**. The international ladder is IMMAF’s:

1. Club / domestic amateur (format **UNKNOWN**).  
2. CMMAF selects a Cyprus team.  
3. IMMAF championships (Europeans, Worlds, Youth). 2026 Worlds: Tbilisi, NF bulk entry, EUR 650, first-pick windows by **team ranking**.  
4. Medal at IMMAF ≠ IF ranking points in the IJF/UWW/WT sense; it is amateur pedigree.  
5. **Turn pro** → the 13 promotions. That step **ends** IMMAF eligibility.

**What a win is worth:** selection, IMMAF seeding/team ranking (IMMAF publishes senior/junior **team** rankings on the Worlds page), then a promotional contract. **Not** a CMMAF purse. **Not** an Olympic quota (MMA is not on the Olympic programme).

---

## 4.5 `ibjjf` — season weights, championship weights, belts

Official ranking page (verified 2026-09-06): points for **1st / 2nd / 3rd only**. Valid **three seasons** (current ×3, previous ×2, two-ago ×1 in the worked examples). **Non-transferable** across age, belt, gi/no-gi. Academy change does **not** reset points. Belt promotion **does** (athlete leaves the old belt ranking).

**Standings value:** weight division 1st **9** / 2nd **3** / 3rd **1**. Open class 1.5× (examples use 13.5 / 4.5 / 1.5).

**Championship weight (adult gi, from the official table + examples):**

| Championship | Weight |
|--------------|--------|
| World Championship | **7** |
| European / Pan / Brasileiro | **4** |
| Asian Championship | **3** (table grouping) |
| American Nationals / BJJ Pro / Pan Pacific / South American / Jiu-Jitsu Con | **2** |
| Nationals listed (British, German, Ireland, Japanese, Spanish, Portugal Open) / International Open / Novice / Jiu-Jitsu Con Novice | **1** |

Example on the official page: 1st Medium-Heavy **Worlds 2022** = 9 × 7 × 2 = **126** (that season was weight 2 in the example’s then-timeline).

**Grand Slam** (Worlds, Euros, Pans, Brasileiro) is a **separate** rolling four-event ranking.

**Belt ladder (worth of a win, distinct from match points in J1 §1.9):** medals at the current belt → ranking points → (black) qualification into Pans/Euros/Worlds → World title can **waive** time-in-rank for the next belt. Black-belt certificate is a **USD 400** paperwork event, not a match.

**Calendar:** IBJJF season is **event-defined**, not a 4-year Olympic cycle. Worlds (gi, Long Beach in recent years, May/June); World No-Gi; Pans; Euros; Brasileiro; Master Worlds (Las Vegas 2026, 3–5 Sep); year-round Opens. Kids ranking **resets 1 Jan**.

**What a win is worth:** ranking points, seeding, major-entry floors, medals, **sometimes** cash at black-belt Worlds / season awards. **Not** a promotional ranking toward a UFC-style belt.

---

## 4.6 Progression vs the game’s `tier` / `reputation`

| Model | Promotions (live) | Olympic IFs | IBJJF | CMMAF |
|-------|-------------------|-------------|-------|-------|
| What a win buys | Rank inside the promotion; title shot | WRL/G-points; NF selection; Olympic quota | Ranking points; belt time; major access | IMMAF pedigree; then a **pro signing** |
| Cycle | Cards / seasons | **2–4 year Olympic** | **Season** (3-year decay) | Annual championships |
| S/A/B/C purse multiplier | Fits | **Does not fit** | **Does not fit** (money is fees) | **Does not fit** (must be unpaid) |
| Replacement | — | `event_grade` + `nf_quota` + `cycle_flag` | championship_weight × season_weight | `amateur_eligible` + `turned_pro` |

---

# Section 5 — Manager-game implications

This is the R40-scope section. J1 D4 already refused to ship federation scoring before 3-judge splits exist. This section refuses to ship a second career mode to paper over a purse bug.

## 5.1 Is a federation career playable in FightCamp’s manager frame?

| Org | Playable without a new mode? | What the player actually decides | What the player does **not** decide |
|-----|------------------------------|----------------------------------|-------------------------------------|
| `ibjjf` | **Yes.** It is a manager sport: pick events, pay, manage weight, chase points, time belt promotions | Which Open/major to enter; whether to pay late-window fees; gi vs no-gi; whether to hunt the 95-point Worlds floor or skip | Opponent (bracket); IBJJF calendar |
| `cyprus_mmaf` | **Yes, as a feeder.** Short amateur loop, then a **signing** into a promotion | Whether to stay amateur (IMMAF path) or take a pro offer (one-way) | IMMAF bracket; CMMAF’s unpublished selection |
| `ijf` / `united_world_wrestling` / `world_taekwondo` | **Not as a signing career.** Playable only as **prestige + NF calendar + later feeder** (especially wrestling → MMA) | Training block vs a domestic camp; whether to **leave** the Olympic path for a promotion; which country the fighter represents (already a character fact) | Grand Slam slots, Olympic quota, who else the NF puts in the two-person GS pair |
| 13 promotions | Already playable | Accept/decline offers, camps vs cards | — |

**Defend scenery for the Olympic IFs:** FightCamp is a **manager of fighters**, not a national-team coach. The real gate at IJF/UWW/WT is an NF/NOC. Simulating that honestly means the player is **lobbying a gate they do not own**. That is a different game (a federation-director mode). Wiring it as UFC-with-tatami is the current lie. Wiring a full Olympic-qualification sim is the unplayed-mode risk (§6.2).

**Defend playable IBJJF:** the catalog already tagged it `tournament_operator`. The player’s week is real: spend money to enter, get ranking points or a rare prize, build a black-belt résumé that can later sell to ONE grappling / UFC BJJ / MMA. That is manager gameplay. It does not need a second mode. It needs **D2** (stop the purse) and an `open_entry` object.

## 5.2 Week-to-week decisions (if we keep these orgs on the map)

| Decision | IBJJF | CMMAF | Olympic IFs |
|----------|-------|-------|-------------|
| Enter an event | **Yes** (pay fee) | Domestic: UNKNOWN schedule; IMMAF: NF enters | **No** — NF enters. Player can only **request** |
| Pay a fee | **Yes** | IMMAF Worlds EUR 650 (NF bulk) | Licence/GAL/card via NF |
| Choose qualification path | Points toward Pans/Worlds vs skipping | Amateur vs turn pro | Stay on WRL vs leave for promotions |
| Camp instead of a card | Yes (skip an Open) | Yes | Yes — and this is the honest Olympic-IF week: **train**, don’t “take a fight” for a purse |
| Sign a contract | Only if a **promotion** offers one | Turning pro **is** the signing | Same — leaving the IF path |

## 5.3 Does `tier` / `reputation` / purse-multiplier fit?

**No** for the five. Catalog gameplay values (IJF/UWW/WT **S/98**, IBJJF **S/95**, CMMAF **C/58**) can stay as **prestige labels** for sponsors (`Sponsorship.gd:224` already sees `entity_type` and could finally **use** it). They must **not** feed `_promotion_purse_multiplier`.

Replace, when a number is required:

| Need | Use | Do not use |
|------|-----|------------|
| How much the fighter is paid for this bout | Promotion purse table | S-tier multiplier on IJF |
| How much this event costs | IBJJF event packet / UWW CHF 100 / GAL USD 35 / IMMAF EUR 650 | Negative purse hacks |
| How much a win moves the needle | Ranking-point tables in §4 (cite, don’t invent) | `reputation += UFC_delta` |
| How prestigious the org is for sponsors | existing `reputation` **gated by entity_type** (Olympic IF ≠ fight-night sponsor) | Same sponsor template as UFC |

## 5.4 Amateur-to-professional / feeder into the 13

| From | To promotions? | How | One-way? |
|------|----------------|-----|----------|
| CMMAF / IMMAF | **Yes — this is the point** | Amateur record → `signing` offer. IMMAF even lists UFC as a partner on the eligibility page footer | **Yes.** Pro bout / purse / 2025 elbow-knee rule |
| IBJJF | **Yes, optional** | Grappling résumé → ONE grappling / UFC BJJ / MMA. IBJJF stays enterable unless a promotion exclusive says otherwise | Only if the **promotion** exclusive fires |
| UWW | **Yes, historically the fattest feeder into MMA promotions** | Leave the senior/Olympic path; sign. Do not dual-wield a UFC camp and a World-Championship peak as the default | Practically yes at the elite week-to-week level |
| IJF | **Rare, and gated** | WRL athletes need IJF authorization for other-combat internationals | Authorization + likely NF/NOC career suicide. Default **blocked** |
| WT | **Possible, not the product** | No WT exclusive retrieved | Don’t invent a ban; don’t invent a pipeline |

**Should the game let a fighter cross?** Yes for CMMAF→promotions (required for honesty), UWW→promotions (real feeder), IBJJF→promotions (real). Default **no** for IJF WRL→MMA without an authorization flag. WT: allowed but not a designed pipeline.

## 5.5 The minimum change (R40 scopes from this line)

**One sentence:** Stop emitting promotion bout contracts for non-promotions; keep one org table; let `entity_type` choose the pathway.

**Concrete, not a range:**

1. **Do not add a second career mode, a new org table, or Olympic-qualification AI.**  
2. **Derive pathway** from existing `entity_type` (`signing` / `open_entry` / `national_selection`). Optional explicit field later; not required to stop the lie.  
3. **`GameState.get_promotion_bout_offer` (`:5492`)** — if `entity_type != promotion`, return **no offer** (or a non-purse `CalendarNotice`). Never call `_promotion_purse_multiplier` (`:5483`) for those ids.  
4. **`accept_signing_offer` (`:5288`)** — refuse `ijf`, `united_world_wrestling`, `world_taekwondo`, `cyprus_mmaf`, `ibjjf`. Signing remains **among the 13 promotions**.  
5. **`WorldPopulation.gd:174`** — do **not** give federations/tournament_operator a promotional “opening event” card. Emit a **calendar node** (IBJJF Open / WJT weekend / Ranking Series / IMMAF championship) with no roster-signing requirement.  
6. **IBJJF:** `open_entry` — debit a **published** membership + event fee (data from event packet; UNKNOWN if packet missing). Optional prize **only** if `prize_table` is authored from a cited IBJJF page. Ranking points as an integer using §4.5 weights — **cite the official page, don’t invent a formula**.  
7. **Olympic IFs:** calendar events the **NF** enters. Player-facing: prestige, training conflict, later feeder. No purse. No player-owned Grand Slam slot.  
8. **CMMAF:** amateur ruleset from J1 §1.7; **zero purse**; `turned_pro` sticky flag on first promotion signing or any IMMAF-disqualifying bout.  
9. **`Sponsorship.gd:224`** — first legal branch on `entity_type`: do not sell UFC-style fight-night sponsors against an IJF calendar node.  
10. **Tests:** see §6.4. The assertion that pays for this whole study: **no org with `entity_type` in {federation, tournament_operator} has `purse > 0` or a `SigningOffer`.**

That is the whole of R40 if R40 is “stop the lie.” Ranking-point UIs, Olympic-quota sim, NF politics, IBJJF belt-certificate USD 400, GAL markup — **out of R40**. They are data and later modes.

---

# Section 6 — Issues, each with a solution

Same discipline as J1 §4.

## 6.1 Brand / licensing — federation names and Olympic marks

**Issue:** IJF, UWW, WT, IBJJF, IMMAF, CMMAF, **and the Olympic rings / “Olympic” / “Olympiad” / Games emblems** are among the most protected marks in sport. Nairobi Treaty (1981): member states must refuse/invalidate marks consisting of or containing the Olympic symbol and prohibit unauthorized **commercial** use. IOC Olympic Properties page: commercial or promotional use is reserved for the IOC, TOP partners, and the Olympic family. National statutes (UK Olympic Symbol etc. (Protection) Act 1995; US Ted Stevens Act; French Sports Code L. 141-5) add **sui generis** rights beyond ordinary trademark confusion. Catalog already: *“Text names only. No organization logos, belts, posters, event photography or other brand artwork.”* J1 §4.1 stands.

**Solution:**

| Safe | Not safe |
|------|----------|
| Text names: International Judo Federation, United World Wrestling, World Taekwondo, IBJJF, CMMAF, IMMAF | Rings, Agitos, LA28 emblem, torch, “Olympic”, “Olympiad”, “Games of the Olympiad”, city-year lockups, mascots |
| Describing a “four-year championship cycle” / “qualification ranking” in plain language | A mode, belt, or sponsor called “Olympic” / “Road to LA” / “Team USA” |
| Citing public regulatory PDFs (SOR, UWW rules, WT bylaws, IBJJF rules, IOC QS PDFs as **research**) | Reproducing those PDFs in-game as branded manuals; shipping PSS/judogi **trade dress** |
| Fictionalizing later via the same `pathway` schema (J1 §4.1 skinning) | Using living athletes’ or officials’ names as data (this desk’s standing rule) |

**Ruling:** R40 may say “Olympic qualification ranking” in **internal/design** docs. The **shipped game** must not use Olympic properties. Prefer “World Games quota” / “four-year cycle ranking” in UI copy **when UI exists** — this desk does not write UI; it flags the constraint.

CMMAF homepage names of officers: **do not ingest as game data.**

## 6.2 Unplayed-mode risk

**Issue:** A faithful IJF/UWW/WT career is a **national-team sim** (NF selection, 24-month ranking decay, 2-year Olympic window, 16-person taekwondo brackets). FightCamp’s loop is **sign, camp, fight, purse**. If R40 builds the faithful sim, nobody with a UFC fighter plays it. If R40 keeps the purse, the catalog is a lie.

**Solution:** D4 + D6. **Play** IBJJF and CMMAF-as-feeder. **Show** Olympic IFs as calendar prestige and a wrestling→MMA door. **Do not** simulate 372 judo quota negotiations. J1 already delayed federation **scoring** to P5; this study delays federation **career depth** until the money polarity is honest. An unplayed honest calendar node is better than a played dishonest purse.

## 6.3 UNKNOWN economics must not become invented ones

**Issue:** Temptation to fill “year cost,” CMMAF dues, WT Worlds prize, 2026 UWW Ranking Series cheques, IJF card’s true IJF unit price, French/Japanese stipends, Cyprus KOA grants.

**Solution:** same as J1 §4.3.

| Field | Rule |
|-------|------|
| Fee | Only from a cited schedule/outline. Else **UNKNOWN** and **no debit** (don’t invent USD 0 as a fake fee either — omit the line) |
| Prize | Only from Financial Rules / event outline / IBJJF ranking page. Else **UNKNOWN** and **prize_table empty** |
| Stipend / medal bonus | Label **NATIONAL**; never store as IF income. USOPC Operation Gold and USA Wrestling LDMF are **US-only overlays**, not defaults for Georgia/France/Cyprus |
| Ranking formula | Cite the bylaw/QS. UWW LA28 points “to be reviewed” → **do not ship the January 2026 table as Olympic ranking** |
| Year budget | **Do not author a year total.** Author line items |

Runtime: `money_evidence: DIRECT | NATIONAL | UNKNOWN`. Tests assert **no invented numeric default** on UNKNOWN prize/fee fields (parallel to J1 `rules_fallback=1`).

## 6.4 Test assertions (contracts for a later PR — not written this pass)

| ID | Assertion |
|----|-----------|
| **P1** | For every org with `entity_type` in `{federation, tournament_operator}`, `get_promotion_bout_offer` returns no `purse` and no `win_bonus`. |
| **P2** | `accept_signing_offer` on `ijf` / `united_world_wrestling` / `world_taekwondo` / `cyprus_mmaf` / `ibjjf` **fails**. |
| **P3** | `_promotion_purse_multiplier` is **not** invoked for those five ids. |
| **P4** | `WorldPopulation` does **not** spawn a promotional opening **card** for those five; a calendar node is allowed. |
| **P5** | `cyprus_mmaf` bout records have `purse == 0` and `amateur_eligible == true` until `turned_pro`. |
| **P6** | After a `promotion` signing, `turned_pro == true` and CMMAF/IMMAF international entry is refused. |
| **P7** | IBJJF `open_entry` debits a fee **only** if `entry_fee_cents` is authored from a cited packet; otherwise the debit is skipped and `fee_unknown=1` is stored. |
| **P8** | IBJJF prize is **0** unless `prize_table` is authored; Worlds black-belt table cannot leak onto a blue-belt Open. |
| **P9** | An `ijf` athlete with `wrl_classified=true` cannot accept a non-judo combat **international** without `ijf_authorization=true`. |
| **P10** | No test fixture uses a real official’s or athlete’s name as data. |
| **P11** | No shipped string in the five orgs’ event titles contains `Olympic`, `Olympiad`, or rings unicode. Internal comments may cite LA28 QS URLs. |
| **P12** | `Sponsorship` templates for `entity_type=federation` are not the UFC fight-night template (branch the copy that `:224` already receives). |
| **P13** | Country-only pool (`GameState.gd:585`) cannot assign a `judo` fighter a `ufc`-style **signing** with `ijf` merely because `market_assignments` lists `ijf` for Japan/France/Georgia. |
| **P14** | UWW Ranking Series during the authored LA28 qualification window has **empty** prize_table (circular: prize removed). |
| **P15** | IMMAF-disqualifying technique flags (elbows / knees to the head) on a CMMAF athlete’s **non-IMMAF** bout set `turned_pro` even if the other org called it amateur. |

---

## Source list (live verification 2026-09-06)

Primary / official (preferred):

- `real_organizations.json` (`snapshot_date` 2026-09-01), `entity_types` block  
- J1 — `J1_ORGANIZATION_RULES_AND_JUDGES.md` §1.7, §1.9, §1.14, §1.15, §1.16, §4  
- IJF.org ranking season: https://www.ijf.org/news/show/understanding-the-2026-ijf-world-ranking-season  
- IJF.org qualification start: https://www.ijf.org/news/show/the-art-of-qualification-two-years-to-reach-the-olympic-games  
- IJF Financial Rules 2025: https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2025/08/IJF_Financial_Rules_2025-17544-1754474721.pdf  
- IJF SOR 2024 PDF (entry/card; ranking table partly stale): https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2024/04/IJF_Sport_and_Organisation_Rul-1712049108.pdf  
- IJF SOR live: https://sor.ijf.org  
- British Judo, IJF other-combat-sports release (SOR 4.1 quote): https://www.britishjudo.org.uk/ijf-release-participation-of-judoka-in-other-combat-sports-international-competition/  
- LA28 Judo QS (12 May 2026): https://stillmed.olympics.com/media/Documents/Olympic-Games/LA28/JUD-LA28-Qualification-System.pdf  
- Tashkent GS 2025 outlines (prize split): https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2025/02/Tashkent_GS_2025_Outlines_vers-1740054321.pdf  
- USA Judo 2026 H2 World Tour selection PDF (2-per-country): https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/bltb4115d3b1335a911/6a0794ddb915674a8a11704f/2026_IJF_World_Tour_Selection_Procedure_(Second_Half).pdf  
- UWW new Olympic qualification: https://uww.org/article/uww-announces-new-olympic-qualification-process-la-2028  
- UWW circular 2 Feb 2026: https://cdn.uww.org/2026-02/01_qs_la28.pdf  
- UWW Ranking Rule Book Jan 2026: https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf  
- UWW Financial Regulations 2026: https://cdn.uww.org/2026-02/uww_reglement_financier_anglais_2026_v1_1.pdf  
- UWW licences: https://cms.uww.org/fa/node/1011 and https://uww.org/fr/governance/licences-des-lutteurs-assurance  
- UWW engagement fees: https://cms.uww.org/about-events/participate/licenses-fees/engagement-fees  
- UWW 2023 Ranking Series prize (historical): https://cms.uww.org/article/uww-award-prize-money-ranking-series-winners  
- UWW LA28 calendar: https://uww.org/article/uww-announces-la-2028-olympic-qualification-calendar  
- LA28 Wrestling QS (13 Aug 2026): https://stillmed.olympics.com/media/Documents/Olympic-Games/LA28/WRE-LA28-Qualification-System.pdf  
- WT GMS Bylaws V7 (1 Jun 2023): https://www.worldtaekwondo.org/att_file/documents/WT%20Global%20Membership%20System%20(GMS)%20Bylaws%20(V7)%E2%80%93%20English%20(as%20of%20June%201st%202023).pdf  
- WT Ranking Bylaw (30 Sep 2024): https://www.worldtaekwondo.org/att_file/documents/WT%20Ranking%20Bylaw%20(September%2030,%202024_Chuncheon%20Council%20Meeting).pdf  
- LA28 Taekwondo QS (12 May 2026): https://stillmed.olympics.com/media/Documents/Olympic-Games/LA28/TKW-LA28-Qualification-System.pdf  
- Roma 2026 WT GP Official Outline (SimplyCompete): https://worldtkd.simplycompete.com/files/eventDocuments/038cd7b1-1da4-4b9a-9d73-8d73e4af725b.pdf  
- IMMAF athlete eligibility: https://immaf.org/athletes/athlete-eligibility/  
- IMMAF 2026 Worlds (Smoothcomp): https://immaf.smoothcomp.com/en/event/33657  
- CMMAF: https://cyprusmixedmartialartsfederation.com/  
- IBJJF membership: https://ibjjf.com/athletes/become-a-member  
- IBJJF ranking: https://ibjjf.com/athlete-ranking-info  
- IBJJF membership help: https://help.ibjjf.com/membership/  
- IBJJF black-belt certification help: https://help.ibjjf.com/black-belt-certification/  
- IBJJF ranking help: https://help.ibjjf.com/ranking/  
- IOC Olympic Properties: https://www.olympics.com/ioc/olympic-properties  

Secondary (labelled in body):

- Wikipedia *IJF World Tour* 2025–2028 points table (cross-checked against live 2026 WRL rows)  
- USA TODAY / Sports Business Journal Operation Gold amounts  
- USA Wrestling Living the Dream Medal Fund (themat.com 2025-12-03)  
- USA Taekwondo Stevens award page (2025-03-06)  
- FloGrappling World Master 2026 fees; Rollbook / JiuJitsu News Worlds fee/prize recaps  
- MMA Mania UFC BJJ vs ADCC exclusivity (2026-02-26)  
- insidethegames WT 2026 GP allocations  

**Not retrieved / do not fake:** current `sor.ijf.org` HTML ranking table; CMMAF fee schedule; 2026 UWW Ranking Series prize circular; WT World Championships prize table; GP Final prize table; Africa row OCR on TKW QS continental table; IJF’s own card unit price.

---

*End of J2. R40 cuts from the Decisions page and from §5.5.*
