# J16 — The Gym Floor Plan: What May We Use, and What Does Geometry Buy a Management Game?

**Desk:** John (research)  
**Date:** 2026-09-10  
**Status:** research only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF. No UI. No state machines. No floor-plan generator. No tracing. **Ripped assets never ship.**  
**Local snapshot used:** `TASK_J16.md`; `J16_PROMPT.txt`; `equipment_catalog.json` v2 (`footprint`, `station_capacity`, `category`); `J8_THE_MEMBERS.md` (2026-09-07 — **N8 / N9 / N10 / N18 / N22 cited, demand curve not reopened**).  
**Verification date for every live URL in this pack:** **2026-09-10**, except J8 citations already verified **2026-09-07** (marked).

**Grade key (this pack):** **DIRECT** = primary statute, regulation, commission/org rulebook, building code, Copyright Office circular, the organization’s own page. **INHERITED** = live game object, or customary industry practice restated from a named standards body without this pass retrieving the current edition’s table. **UNVERIFIED_SECONDARY** = vendor blog, FDD restatement, journalism, academic paper, CAD-library marketing. **UNKNOWN** = not found. **not found** is written as **not found**. A number wearing a citation it does not have is a lie.

**This is a management game.** The gym is a business. It is not an FPS map. Geometry is scenery unless it changes a ledger object (space, stations, upkeep, unlocks).

---

## DECISIONS (operator cut-sheet)

1. **Legal verdict.** Dual copyright: the *drawing* (pictorial/graphic/sculptural, including architectural plans) **and** the *building design* (architectural work: overall form **and** arrangement of spaces). Standard features, standard configurations, facts, and functional rules are **not** protected. **You may not trace these. You may use what they teach you.** Pinterest is an aggregator of unprovenanced raster; its in-platform licence is not a commercial extraction licence. Ripped plans never ship.
2. **Route: C.** Hand-author a **dozen** layouts that scale with the business (rooms and stations unlock; `used_space` / `total_space` already exist). Not A (extract PDFs). Not B as a *generator*. B’s constraint list is a **checklist for C**, not a pipeline.
3. **Numbers they should build to.** Keep catalog `station_capacity` and tile `footprint` as **invented gameplay** (honest count-shape — J8 N8/N10). Do **not** import IBC **50** gross sq ft/occupant as a membership roster (J8 N9). Combat-gym **sq-ft-per-member: UNKNOWN**. Competition cage **18–32 ft** / UFC interior **30 ft** and ring **16–20 ft** inside ropes are **sport rules for a bout**, not a gym floor. Size bands: labelled invention sitting on J8 member buckets (dozens to low hundreds) and vendor-observed **~2,000–4,000 sq ft** martial-arts schools — **not** as measured densities.
4. **“6-foot apron clearance” and “40 sq ft per training pair”:** **not found** as published combat-gym planning rules. Closest published objects are different (ring *apron* 18 in–2 ft / 85 cm; ACSM group-exercise 40–60 sq ft *per person*; BJJ vendor 50–75 sq ft *per student on the mat*). Do not mint those prompt examples as house law.
5. **PDF-to-geometry:** sceptical **no**. Pinterest is 236-px JPEG. Wild “plans” are mixed scan/vector. Automated recognition is residential-floorplan research with heavy post-process. If rules drive the layout, plans needed = **none**.
6. **What a floor plan buys.** For a management game: **unlock order, adjacency flavour, and a space ceiling** — objects a facilities list already almost is. Honest: **not much** beyond that. Do not build a walkable gym.
7. **Do-not-build.** No Pinterest scrape/trace; no ripped CAD; no UFC **Octagon®** as a branded asset; no IBC-as-dues; no generator; no demand-curve reopen of J8.

---

# §1 THE GATE — what may we actually use?

## 1.1 Pinterest as aggregator (the board named in the task)

The inspiration board is Pinterest’s *ideas* surface, not an architect’s filing cabinet: `https://www.pinterest.com/ideas/mma-gym-floor-plan/950830226557/` (verified 2026-09-10). Retrieved this pass: an **ideas** page titled “Mma gym floor plan,” “44 people searched this,” last updated “1d,” pins served as **236-px** `i.pinimg.com` JPEGs. No architect, no licence, no scale bar, no sheet number, no CAD layer. That is the realistic provenance of a Pinterest board: **user-saved, re-saved, cropped, watermarked, and unlabelled raster**, often screenshots of someone else’s CAD, a magazine spread, or a vendor’s marketing plan.

Pinterest’s own Terms (effective 2025-04-30; verified 2026-09-10, `https://policy.pinterest.com/en/terms-of-service`):

- Users **retain** rights in User Content; they must only post what they have rights to post.
- By posting, a user grants Pinterest **and other users** a licence to use, display, reproduce, save, modify, create derivative works, download, and distribute that content **on the Service** (repin / save inside Pinterest).
- The user licence to Pinterest is **not** a licence for a game studio to download a board and ship traced geometry.
- Pinterest **prohibits scraping** and unauthorized automated collection.
- Pinterest is a **neutral intermediary**; it does not warrant that pins are non-infringing.
- Pinterest operates a Content Claiming Portal for rights-holders (`https://help.pinterest.com/en/article/get-started-with-the-content-claiming-portal`, verified 2026-09-10) — evidence that the company treats pins as **other people’s copyrighted works**.

**Grade: DIRECT** as to Pinterest’s contract with *its* users. **UNKNOWN** as to the copyright owner of any given MMA-gym pin. **INHERITED** project rule: ripped assets never ship.

**Realistic provenance of a board image, in order of likelihood:** (1) a gym’s Instagram photo of its floor, (2) a vendor 3D marketing render, (3) a student/architect portfolio sheet, (4) a magazine or blog scan, (5) a permit drawing photographed at an angle, (6) another Pinterest pin with the source link dead. Metadata is often stripped (litigation record: Pinterest has, in periods, stripped IPTC on upload — *Davis v. Pinterest*, N.D. Cal., complaint restatement). Reverse-image-search is the only honest provenance method, and it still often dead-ends.

**Verdict on the board:** inspiration for *kinds of rooms*. Not a corpus. Not a licence. Not geometry.

## 1.2 Are architectural floor plans copyrightable? Drawing vs building vs arrangement

Three nested objects. Mixing them is how studios get sued.

### Object 1 — the DRAWING (lines on a sheet)

**DIRECT.** 17 U.S.C. § 102(a)(5) protects “pictorial, graphic, and sculptural works.” 17 U.S.C. § 101 defines those to include “diagrams, models, and technical drawings, **including architectural plans**.” (`https://www.law.cornell.edu/uscode/text/17/101`, `https://www.law.cornell.edu/uscode/text/17/102`, verified 2026-09-10.)

Copying a plan sheet — tracing walls, reproducing the graphic, ingesting the PDF as an asset — is reproduction of a PGS work. Pre-1990 case law already treated *plans* as graphic works even when the *building* was a useful article (*Baker v. Selden* use/explanation split; *Imperial Homes*; *Robert R. Jones Assoc. v. Nino Homes*). Tracing someone’s drawing and putting your name on it is the easy infringement (*Johnson v. Jones*, E.D. Mich. 1996: defendant admitted tracing, swapped the seal).

### Object 2 — the BUILDING (the constructed gym)

**DIRECT.** Architectural Works Copyright Protection Act of 1990 (Pub. L. 101-650, Title VII) added 17 U.S.C. § 102(a)(8) “architectural works.” Definition, 17 U.S.C. § 101:

> An “architectural work” is the design of a building as embodied in any tangible medium of expression, including a building, architectural plans, or drawings. The work includes the **overall form** as well as the **arrangement and composition of spaces and elements** in the design, but does not include **individual standard features**.

Copyright Office Circular 41 (retrieved 2026-09-10, `https://www.copyright.gov/circs/circ41.pdf`) and 37 C.F.R. § 202.11 (`https://www.law.cornell.edu/cfr/text/37/202.11`):

- Protects humanly habitable, permanent, stationary structures (houses, offices, churches, museums; a gymnasium used by people is a **building**).
- Authorship includes exterior form **and** “any arrangement and composition of walls or other permanent structures that divide the interior into separate rooms and spaces.”
- **Not protected:** individual standard features (windows, doors, staple components); **standard configurations of spaces** (square bathroom, one-room cabin); purely functional engineering; **interior design** (furniture, lighting, paint, similar items).
- Dual claim: technical drawings and the architectural work depicted in them must be registered **separately** (37 C.F.R. § 202.11(c)(3)).
- Pre-1 December 1990 published designs / constructed buildings: generally **out**.

Compendium of U.S. Copyright Office Practices, Third Edition, ch. 900 (visual art PDF, `https://www.copyright.gov/comp3/chap900/ch900-visual-art.pdf`, verified 2026-09-10): will refuse a motel that is “a central hall with uniformly shaped rectangular rooms” as a **standard configuration of space**. Functional elements “whose design or placement is dictated by utilitarian concerns” are not copyrightable.

### Object 3 — ARRANGEMENT OF SPACES (the layout as expression)

**DIRECT as the statutory text; THIN as case law.** Congress wrote “arrangement and composition of spaces” *into* the definition because architectural creativity often *is* the selection of unprotectable parts (H.R. Rep. 101-735). That does **not** mean every gym that puts a desk by the door has stolen a plan.

- *Intervest Construction, Inc. v. Canterbury Estate Homes, Inc.*, 554 F.3d 914 (11th Cir. 2008): architectural works, at the level of arranging common rooms/doors/windows, receive **“thin”** compilation-style protection. Substantial similarity is judged only at the original coordination of those elements; two four-bedroom houses with the same *kinds* of rooms were **not** substantially similar. (`https://cases.justia.com/federal/appellate-courts/ca11/07-12596/200712596-2011-02-28.pdf`)
- *Home Design Services, Inc. v. Turner Heritage Homes*, 11th Cir. 2016: *Intervest* is **not** a licence to copy; it is a warning that **thin** is not **none**, but modest differences in arrangement defeat a claim when only standard parts were shared.
- *Feist Publications, Inc. v. Rural Telephone Service Co.*, 499 U.S. 340 (1991): facts are not copyrightable; compilation copyright is thin and covers only original selection/arrangement. (`https://www.law.cornell.edu/supremecourt/text/499/340`)
- *Designworks Homes, Inc. v. Columbia House of Brokers Realty, Inc.*, 8th Cir. 2021: § 120(a)’s pictorial-representation exception for **constructed buildings visible from a public place** does **not** let you generate and publish **floor plans** as “pictures.” Floor plans are technical drawings, not photographs of a façade. (Later 8th Cir. 2025 fair-use path for real-estate marketing sketches is a **different** use — informational listing, not a game asset.) (`https://www.ipupdate.com/2021/08/when-pictures-arent-pictures-real-estate-agent-generated-floor-plans-are-outside-copyright-infringement-exception-for-pictorial-representations/`)
- 17 U.S.C. § 120(a) (`https://www.law.cornell.edu/uscode/text/17/120`): you may photograph a constructed building visible from a public place. That is **not** a right to reconstruct its interior plan, and it is **not** a right to copy the architect’s sheets.
- *Leicester v. Warner Bros.*, 232 F.3d 1212 (9th Cir. 2000): § 120(a) covers pictorial representations of the architectural work as seen from a public place (here, towers treated as part of the building). Still not interior CAD.

**Pre-AWCPA reminder (so nobody “measures the gym from the street” and thinks they own the plan):** before 1990, buildings were largely useful articles; plans were still graphic works. After 1990, **both** the building design and the drawings are protected, with the § 120(a) photo exception for exteriors.

**Furniture and bags are not the architectural work.** Circular 41: interior design (selection and placement of furniture) is **not** the architectural work. A pictorial of a bag row might be a separate graphic work. The *idea* “hang bags along the long wall” is § 102(b).

## 1.3 FACTS free to use? (even if learned by reading a plan)

**Yes. DIRECT.** 17 U.S.C. § 102(b):

> In no case does copyright protection for an original work of authorship extend to any idea, procedure, process, system, method of operation, concept, principle, or **discovery**, regardless of the form in which it is described, explained, illustrated, or embodied in such work.

*Baker v. Selden*, 101 U.S. 99 (1879): the book is protected; the useful art it teaches is not (absent a patent). *Feist*: facts do not owe their origin to authorship.

So:

| Learned from a plan | Protected? | Grade |
|---------------------|------------|-------|
| “Reception sees the door” | **Idea / functional requirement.** Independent gyms and DoD fitness-center criteria both teach visual control of the entry. Using the *rule* is free. Copying *this* desk, *these* wall jogs, *this* soffit: not free. | **DIRECT** as § 102(b); DoD LOS is a **separate** primary (below) |
| “Bags need swing clearance” | **Physical fact / safety idea.** | **DIRECT** as fact; the *number of feet* still needs a source |
| “6-foot apron clearance” | **not found** as a published combat-gym planning rule this pass. Ring *apron* (canvas beyond ropes) is **18 inches–2 feet** (USA Boxing / many commissions) or **85 cm** (IBA). Do not treat the prompt’s example as evidenced. | **UNKNOWN** as that phrase |
| “40 sq ft per training pair” | **not found.** Closest published objects are different (ACSM 40–60 sq ft *per person* in group exercise; BJJ vendor 50–75 sq ft *per student on the mat*). | **UNKNOWN** as that phrase |
| IBC 50 gross sq ft/occupant, exercise rooms | **Code fact** (egress). Free to *know*. Forbidden to wear as a membership roster (J8 N9). | **DIRECT** as code; **wrong object** for dues |
| A specific architect’s wall file, column grid, and room names | **Expression.** | **DIRECT** — do not copy |

**Merger / scenes à faire (INHERITED doctrine, not a FightCamp invention):** when function dictates the arrangement (wet rooms stacked for plumbing; a cage needs a rectangle big enough for the cage plus gates; the desk faces the door because of theft and liability), those arrangements merge with the idea. A warehouse MMA gym that is “desk, then open floor, bags on the long wall, mats in the back, toilets on the wet wall” is **scenes à faire** of the building type. A distinctive mezzanine, a trademarked octagon graphic, a copied column grid from a named academy’s posted plan, is not.

**Trademark, separate from copyright.** UFC’s page: the octagonal competition mat and fenced-in design are **registered trademarks and/or trade dress**; “The Octagon®” is reserved; UFC-style octagon training is offered at UFC Performance Institute and most UFC GYM franchises (`https://www.ufc.com/octagon?language_content_entity=en`, verified 2026-09-10). An eight-sided training cage as a *kind* of equipment is a sport fact (Unified Rules allow six-or-more-sided or circular fences). Shipping a branded **Octagon®** with UFC livery is a trademark problem **even if** the dimensions are public. J5 **G17**: UFC Gym as player = scenery. This pack does not ingest the brand as a catalog row.

## 1.4 Public-domain / open / purchasable sources

| Source class | What it actually is | Safe for a *commercial game derivative*? | Grade |
|--------------|---------------------|------------------------------------------|-------|
| **U.S. government works** (17 U.S.C. § 105) | Works prepared by federal officers/employees as official duties: no U.S. copyright. DoD **UFC 4-740-02** *Fitness Centers* (3 Feb 2019, Change 1 30 May 2019) is a Unified Facilities Criteria document, public release, distribution unlimited (`https://www.wbdg.org/FFC/DOD/UFC/ufc_4_740_02_c1_2019.pdf` and WBDG/S3 copy retrieved 2026-09-10). It is a **fitness-center** program (basketball, cardio, locker rooms, optional martial arts / boxing as “structured activity”), **not** an MMA gym. **Facts and adjacency rules inside it are usable.** Tracing a sample floor *diagram* from the PDF as a game map is still a bad product idea (wrong building type) and the diagrams may include contractor expression — prefer the **text criteria**. | **Rules: yes. Tracing sample sheets as the player gym: no (wrong product + still not a combat gym).** | **DIRECT** (statute + UFC text) |
| **Older DoD / MIL-HDBK** fitness guidance | e.g. MIL-HDBK-1037/8 indoor fitness/rec (public-domain document copies circulate). Same: government **criteria**, optional combative/martial-arts room as a rec-center module. | Rules: yes. | **DIRECT** as government work if it is a U.S. Government work; confirm the specific edition’s status before ingesting drawings |
| **Building codes (IBC)** | ICC model codes are **copyrighted by ICC**; the *facts of the adopted law* in a jurisdiction that enacted them are usable as law. Do not scrape ICC’s paid HTML as an asset. Table 1004.5 **Exercise rooms = 50 gross** sq ft/occupant is the legal occupant-load factor in jurisdictions that adopted 2024 IBC. | The **number as code**: usable. The **ICC page as a copied table graphic**: don’t. | **DIRECT** as adopted code fact |
| **State athletic-commission rules** | Cage/ring dimensions in OAR, Fla. Admin. Code, 58 Pa. Code, Wis. SPS, R.I. Gen. Laws, ABC Unified Rules report: **law**. | Usable as sport rules. | **DIRECT** |
| **Sport-body rulebooks** | USA Boxing 2026 Rule 27 (ring); IBA Technical & Competition Rules § 42 (ring); IBJJF Rules (match area); NCAA Wrestling Rules (mat). | Usable as sport rules. Graphic diagrams in the PDF may be the org’s PGS work — take the **numbers**, not the plate. | **DIRECT** (text); diagrams: do not rip |
| **Municipal permit sets posted online** | Cities often post PDFs of rec-center / community-gym construction documents (e.g. Belmont, NC community recreation center SD set — retrieved as a public upload this pass). **Posting is not a licence.** Copyright typically remains with the architect unless the contract assigned it to the city **and** the city dedicated it. Many U.S. cities claim copyright in their publications; some do not. | **UNKNOWN per set.** Treat as **not licensed for game assets** unless the posting carries a dedicated public-domain / CC licence or is a U.S. Government work. **Learning** “gymnasium 7,552 sf; exercise studio 1,451 sf” from a labelled municipal sheet is a **fact about that project**, not a FightCamp default. | **UNVERIFIED_SECONDARY** as a corpus; **do not trace** |
| **University rec-center wayfinding PDFs** | e.g. Portland State ASRC plans (campus buildings site, 2024). University copyright / architect copyright. Useful as *kind* (a rec center is not an MMA gym). | Not a commercial-derivative corpus. | Same as municipal |
| **CAD libraries (Libreria CAD, DWGshare, free DWG sports centers)** | Marketing “free download” DWG of a 1,320 m² sports center, student rec, university gym. **Licence is the page’s terms**, often “reference / study,” often silent on game shipping, often the uploader is not the author. | **UNKNOWN / unsafe** as a default. Do not ingest. | **UNVERIFIED_SECONDARY** |
| **Paid plan libraries / stock CAD / BIM objects** | Sweets, BIMObject, vendor Revit families, paid floor-plan marketplaces. Some allow commercial use of the *block* (a toilet, a treadmill); almost none sell “copy this MMA academy and ship it.” Read the EULA. A **purchasable equipment family** is a prop, not a gym. | Possible for **props** if the EULA says commercial + derivative. Not a layout corpus. | **UNKNOWN** until a specific EULA is filed |
| **Architect/vendor sample boards** | Firms publish “sample MMA gym” marketing plans. Those are **advertisements**, copyrighted, often watermarked. Pinterest is where they go to die and lose their caption. | Look, don’t trace. | **DIRECT** as someone else’s PGS work |
| **Open licences (CC BY, CC0)** | **not found** this pass: a CC0 / public-domain **MMA gym construction set** of production quality. If one appears, CC BY requires attribution; CC BY-ND forbids the derivative a game needs; CC BY-NC forbids commercial shipping. | **not found** as a corpus. | **UNKNOWN** |
| **Facts measured in the wild** | A researcher standing in a public lobby may observe “the desk faces the door.” Measuring a private gym’s interior to reconstruct a plan for shipping is not this pack’s job and is not § 120(a). | Kinds: yes. Survey-as-asset: don’t. | — |

**DoD UFC 4-740-02, usable *rules* (DIRECT, military fitness center, wrong product scale, right *kinds*):**

- Control desk / reception: “focal point for safety”; attendants must have **direct line-of-sight** over main entrance, free-weight area, gymnasium entrance, locker-room entrance; CCTV where LOS fails. Visual control of the facility from the desk.
- Unit PT / group exercise: rectangular, partitionable; **10 ft** min ceiling; **12 ft** min for facilities with **large martial arts programs**; method of fastening **wall padding** for combative sports; **acoustical separation** from the rest of the facility; some visual connection to other modules; storage for bags/steps/padding; free-standing heavy bag and speed bag **if a boxing program is included**.
- Structured activity space: “climbing wall, indoor cycling, volleyball, **martial arts/boxing**, other… or rolled into other functional areas.”
- Noisy spaces (do not put next to offices): mechanical/laundry, selectorized and free weights, cardio, gymnasium, unit PT/group exercise.
- Optional storage for additional program equipment “**(i.e. boxing ring)**,” usually at receiving/repair.
- Locker/dressing: separate men’s/women’s; showers exhausted from the wet side; unisex/family changing as an extra module.
- This UFC does **not** publish an MMA-cage diameter, a bag-swing radius, or a combat-gym member density. **not found** in this document.

## 1.5 Clear verdict

**Safe:**

- Sport-rule dimensions (cage, ring, competition mat) as **equipment facts**.
- Building-code occupant load as **egress**, never as a dues roster.
- Functional rules: desk sees the door; wet stacked; noisy away from office; mats need wall pads if you throw people; bags need a swing envelope; storage next to the floor.
- Independently authored layouts that use those rules.
- Government **criteria text** (DoD UFC 4-740-02) as a checklist of *kinds*.
- The live catalog’s `station_capacity` / `footprint` as **gameplay**.

**Not safe:**

- Tracing Pinterest, magazine scans, vendor “sample plans,” student CAD, or permit sheets into `assets/`.
- Shipping a substantially similar copy of a particular architect’s original arrangement (the distinctive plan, not the warehouse cliché).
- UFC **Octagon®** branding / trade dress.
- Calling a ripped plan “reference data” and generating from it.

**The sentence the operator asked for, plainly:**

> **You may not trace these. You may use what they teach you.**

---

# §2 What is actually in an MMA gym (rules, not pictures)

Most of the effort belongs here. This is a **facilities list with constraints**, which is what a management game already is.

Local catalog (`equipment_catalog.json` v2) already authors stations, not rooms: `club_ring` footprint `[4,3]` cap **4**; `heavy_bag` `[1,2]` cap **1**; `modular_combat_mat` `[2,2]` cap **4**; `judo_tatami_area` `[2,2]` cap **3**; strength/cardio/recovery rows. Those footprints are **invented tiles**, not metres (**INHERITED** as game objects; **invented** as magnitude — J8). This pack does not retune them. There is **no cage row** in the retrieved catalog.

## 2.1 Spaces — essential / optional / “serious”

“Essential” = an independent combat gym can hardly sell the product without it. “Optional” = common, not required to open. “Serious” = the jump from a warehouse club to a destination / pro-adjacent room. Not a franchise Signature box (J8 N18 / J5 G17).

| Space | Independent MMA / combat school | Why | Grade of the *kind* |
|-------|----------------------------------|-----|---------------------|
| **Training floor (open)** | **Essential** | Classes, warm-up, mitt work, shadow. The product is a coached hour, not a machine row (J8 N7). | **CUSTOMARY** / J8 |
| **Mat (grappling)** | **Essential for MMA / BJJ / wrestling**; optional for a pure boxing gym | Ground work is the MMA differentiator. BJJ gyms *are* the mat. | **CUSTOMARY**; competition sizes **DIRECT** (below) |
| **Heavy-bag row / striking stations** | **Essential for striking-led rooms**; reduced in a pure BJJ academy | Catalog already: one bag, one athlete in a scheduled session. | **INHERITED** (catalog); **CUSTOMARY** as a zone |
| **Cage** | **Optional** at small; **serious** at MMA-forward mid/flagship | Unified Rules allow a **ring or a fenced area** for bouts. A *gym* can teach MMA on mats + a ring. A cage is a capital and space hog. Training cages are often smaller than a show cage — **no published gym-cage table this pass**. | Sport: **DIRECT**. Gym-must-have: **CUSTOMARY**, not a rule |
| **Ring** | **Essential for a boxing gym**; **optional** for BJJ; **serious** for MMA if no cage | Boxing’s identity object. Takes a permanent rectangle. Folding/roll-out rings exist as a space-economy *kind* (vendor). | Sport: **DIRECT**. Permanence: **CUSTOMARY** |
| **Strength** | **Optional** small; **serious** mid+ | Catalog has compact racks. S&C is a zone, not the sport. NSCA space rules are **weight-room** rules, not MMA. | **INHERITED** catalog; NSCA **INHERITED** (below) |
| **Cardio** | **Optional** | Bikes / air-bikes / jump-rope floor. Combat conditioning is often the open floor. | **INHERITED** catalog |
| **Reception / control desk** | **Essential** as a **business** | Waivers, dues, eyes on the door, emergency focal point. DoD: desk is the safety hub with LOS. | **DIRECT** (DoD UFC 4-740-02 *kind*); combat-gym: **CUSTOMARY** |
| **Office** | **Essential** as a business (can be a closet) | Membership, coaches, bills. J5: the gym lives on the training floor, not the purse — the office still exists. | **CUSTOMARY** |
| **Changing / lockers** | **Essential** at any serious public gym; a tiny club can open with a restroom only | Wet/dry split. DoD programs full locker modules; independent schools often have a bench and hooks. | **CUSTOMARY**; DoD module **DIRECT** as military rec, not player default |
| **Showers** | **Optional** small; **serious** mid+ | Members notice. Plumbing is expensive. | **CUSTOMARY** |
| **Storage** | **Essential** | Mats, bags, pads, cleaning. DoD: storage with access to the group-exercise room; optional ring storage at receiving. | **DIRECT** *kind* (DoD); **CUSTOMARY** |
| **Physio / treatment** | **Optional**; **serious** for a fight-team room | Catalog has `physio_table`, `first_aid`. Full benefit needs a person (catalog copy). | **INHERITED** catalog |
| **Sauna / recovery wet** | **Optional**; **serious**/flagship amenity | Catalog has recovery tub / pool at higher tier. Not a combat-sport rule. | **INHERITED** catalog; sport-required: **not found** |
| **Pro-shop** | **Optional** | Gloves, wraps, gis. J8 N21: dues are the majority *kind*; merch share **UNKNOWN**. Do not become a shop sim (G17). | **CUSTOMARY** as a glass case |
| **Spectator / parents’ bench** | **Optional** | Kids programs drive this (Gymdesk: **78%** of martial-arts schools run kids — J8, **vendor-observed**, scenery as a *mode*). Independent fight gyms: a wall of chairs. Show gyms: bleachers. Missouri professional-ring rule: spectator seats **not closer than 8 ft** from the apron — **bout site**, not a school. | **CUSTOMARY**; 8 ft: **DIRECT** as that state’s bout rule only |
| **Toilets** | **Essential** (code) | Fixture counts follow occupancy, not sport. | **DIRECT** as plumbing/building code *kind*; combat-gym fixture table: **not found** |

**A pure boxing gym** can omit the cage and most of the mat. **A pure BJJ academy** can omit the ring, the cage, and most bags. **An MMA gym** is the expensive union: mat + striking + (ring or cage) + enough strength to not send fighters to a second membership.

## 2.2 Numbers with sources (no invented densities)

Every linear/area figure below is **what the source published**. It is **not** a FightCamp default. Gameplay numbers stay labelled invented (J5 G24 / J8).

### Cage (competition / Unified Rules) — DIRECT as a **bout** enclosure

Association of Boxing Commissions, Committee Report on Unified Rules for MMA (`https://www.abcboxing.com/committee-report-on-unified-rules-for-mma/`, verified 2026-09-10):

- **Rings (MMA):** no smaller than **20 ft square** and no larger than **32 ft square** within the ropes; floor extends at least **18 inches** beyond the ropes.
- **Cages / fenced area:** fighting-area canvas no smaller than **18 ft × 18 ft** and no larger than **32 ft × 32 ft**; ≥ **1 inch** foam padding; platform not more than **4 ft** above the building floor; fence (e.g. vinyl-coated chain link); **two** entries.

State restatements (same family, small local deltas):

| Jurisdiction | Fenced-area width | Grade |
|--------------|-------------------|-------|
| ABC Unified Rules report (cages) | 18–32 ft (canvas) | **DIRECT** |
| Oregon OAR 230-070-0025 | Circular or ≥ 6 sides; **at least 18 ft** and **no larger than 32 ft** wide | **DIRECT** `https://oregon.public.law/rules/oar_230-070-0025` |
| Pennsylvania 58 Pa. Code § 29.4 | ≥ 6 sides; **at least 20 ft** and **no larger than 32 ft** wide | **DIRECT** `https://www.law.cornell.edu/regulations/pennsylvania/58-Pa-Code-SS-29-4` |
| Rhode Island R.I. Gen. Laws § 41-5.2-9 | Canvas **18×18 to 32×32 ft** | **DIRECT** `https://webserver.rilegislature.gov/Statutes/TITLE41/41-5.2/41-5.2-9.htm` |
| Wisconsin SPS 192.50 | Floor **18–36 ft diameter**; MMA bouts **may not** be in a ring | **DIRECT** `https://www.law.cornell.edu/regulations/wisconsin/Wis-Admin-Code-SS-SPS-192-50` |
| Nevada-style ABC PDF circulating as Unified Rules (UFC media copy) | Fenced area **20–32 ft** wide | **DIRECT** as that text `https://media.ufc.tv/discover-ufc/Unified_Rules_MMA.pdf` |

**UFC show cage (branded, not a gym rule).** UFC’s own Octagon page historically published, and secondary UFC properties still restate: exterior **38 ft** (11.5 m) diameter; interior fighting space **30 ft** (9.1 m) across; walkway **4 ft**; gates **3 ft** wide; canvas **4 ft** off the ground; fence about **5 ft 9 in** (`https://www.ufc.com/octagon?language_content_entity=en` — 2026-09-10 fetch of the live page was a stub/header; dimensions confirmed on UFC’s own archived “Get Inside” page and widely restated. Treat live UFC.com body as **partially retrieved** this pass; **30 ft interior / 38 ft exterior** is the figure UFC has published as Octagon® details). Smaller show cage **25 ft** across is customary for Apex/smaller venues (**UNVERIFIED_SECONDARY** as to when it is used; Wikipedia/trade restatement).

**Contest area (approx.):** a regular octagon 30 ft across is on the order of **~750 sq ft / ~70 m²** fighting space (UFC marketing and dimensions.com restatement). That is the **inside**. The **building rectangle** that holds a 38 ft exterior plus stairs, corners, and a coach path is **larger**. A published “gym must allocate X m² for a training cage including clearance” table: **not found**.

**Training-cage diameters sold to gyms (4.5–6.0 m, etc.):** vendor copy (**UNVERIFIED_SECONDARY**). Not a commission rule.

**Do not ship Octagon® branding.** Eight-sided is a Unified Rules–compatible *kind*.

### Ring — DIRECT as a **bout / amateur contest** object

**USA Boxing National Rule Book, Rule 27, effective 1 January 2026** (`https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt5ff28f6e78e9624d/695ed2d8b45570d8a64b74b9/USA_Boxing_Rule_Book_Revisions_-_1.1.2026.pdf`, verified 2026-09-10):

- Not less than **16** and not more than **20 feet** square **within the ropes**.
- **Apron** of the ring floor extends beyond the ropes **not less than two feet**.
- Not more than **four feet** above the floor; three sets of steps.

**IBA Technical and Competition Rules § 42** (2023 PDF, `https://www.iba.sport/wp-content/uploads/2022/02/20230209-IBA-Technical-Competition-Rules.pdf`):

- **6.10 m** inside the ropes on all four sides.
- Apron **85 cm** outside the line of the ropes (including extra canvas to tighten).
- Platform **7.80 m × 7.80 m**; **100 cm** from the ground.

**Florida** (boxing/kickboxing/MMA ring, Fla. Admin. Code r. 61K1-3.019): ring **18–22 ft** square inside the ropes; apron **≥ 18 inches**; platform **≤ 4 ft**; **≥ 12 ft** from platform to ceiling. (`https://www.law.cornell.edu/regulations/florida/Fla-Admin-Code-Ann-R-61K1-3-019`)

**New York** professional boxing (19 NYCRR 210.24): **18–22 ft** square; apron **not less than two feet** unless the Commission directs otherwise.

**Missouri** (20 CSR 2040-6.010): ring **16–20 ft** inside ropes; apron **≥ 2 ft**; spectator seats **not closer than 8 ft** from the outside edge of the apron.

**“6-foot apron clearance”:** **not found.** Do not confuse (a) the **apron** (canvas beyond the ropes, 18 in–2 ft / 85 cm) with (b) a **working margin around the whole platform** for coaches, stairs, and people walking past. Vendor combat-gym copy this pass (Compound Fitness AU): “minimum **1.5–2.0 m** on all sides for corner access” around a ring — **UNVERIFIED_SECONDARY**, not a code. A 16×16 ft (4.9 m) inside-ropes ring on a ~20×20 ft platform plus 1.5–2 m all around is a **large rectangle**. Exact gym-planning total: **UNKNOWN**.

### Mats — DIRECT as **competition**; gym practice sizes are CUSTOMARY / vendor

**IBJJF Rules (English, June 2024 restatement circulating as 2024JUN IBJJF Rules EN; Japanese federation PDF matches the numbers)** (`https://cdn.shopify.com/s/files/1/0727/9715/9746/files/2024JUN_IBJJF_Rules_EN.pdf`; `https://www.jbjjf.com/wp-content/uploads/2024/11/JP_IBJJF_RulesBook_JUN2024_1.pdf`):

- Match area = combat area + safety area, distinguished by colour.
- **Minimum 64 m²** total: **36 m²** combat + **28 m²** safety.
- **Maximum 100 m²** total: **64 m²** combat + **36 m²** safety.
- 2×1 m tatami: 64 m² uses 18 combat + 14 safety segments; 100 m² uses 32 combat + 18 safety.

That is a **tournament match**. A class of 20 people is not 20 match areas. **Sq ft per rolling pair in a school: not found as an IBJJF figure.**

Vendor / operator restatement (Member Solutions, “How to Open a BJJ Gym,” 2025): “**Rule of thumb: 50–75 square feet per student on the mat at the same time.** Peak class of 20 → 1,000–1,500 sq ft of mat; plus changing/reception/storage/circulation → **2,000–4,000 sq ft** total for a small-to-mid academy.” **UNVERIFIED_SECONDARY.** Do not author 50–75 as house law. The *kind* (rolling needs more room than a kata line) is real.

**Wrestling (competition):**

- NFHS high school (vendor/rules restatements consistent this pass; confirm in the current NFHS book before construction): **38×38 ft** mat, **28 ft** wrestling circle, **5 ft** protection. **~1,444 sq ft** (134 m²) for the sheet.
- NCAA men’s wrestling: competition circle **32–42 ft** diameter; matted area **≥ 5 ft** all around; no obstruction closer than **5 ft** (recommend **8 ft**) from the edge of the competition circle; dual mats: **≥ 5 ft** matted between circles. Championship host ops: **42×42 ft** mats. NCAA 2017–19 rules PDF (still the cited art. 1 language in circulating books): `https://soconsports.com/api/media/file/9692cbf7-8bb3-41db-be53-a34a2a36b074-2017-18_20__202018-19_20WRESTLING_20Rules_and_Interpretations.pdf`. Current NCAA men’s wrestling rules landing: `https://www.ncaa.org/championships/playing-rules/mens-wrestling-playing-rules/` (verified 2026-09-10). **42×42 ft = 1,764 sq ft ≈ 164 m².**
- A high-school or college **wrestling room** is often wall-to-wall mats plus wall pads — a different building type from a striking gym.

**Practice mats in a garage / small academy:** vendors sell **10×10 ft** (100 sq ft) home mats. That is a product SKU, not a class-capacity law.

### Heavy bags — swing envelope **UNKNOWN as a published combat-gym standard**; vendor rules of thumb exist

**not found:** a commission, ACSM, NSCA, or IBC table titled “minimum radius around a hanging heavy bag in an MMA gym.”

What exists:

| Claim | Figure | Kind | Use? |
|-------|--------|------|------|
| Catalog | One bag, one athlete in a scheduled session; footprint `[1,2]` | **INHERITED** gameplay | Yes, as the game’s station |
| Century / CMFIT (cardio bag **class**, freestanding) | “**1 bag per 100 sq ft**”; 2,000 sq ft → 20 bags → up to 40 people at two per bag | **UNVERIFIED_SECONDARY** vendor; **wrong format** (mobile bags, fitness class) | *Kind* only |
| Century “How do I fit a cardio bag class” | Named fitness clubs using “about **100 sq ft per two-person bag**” | **UNVERIFIED_SECONDARY** | No |
| Ligum Fight Gear (vendor blog) | Hang bags **1–1.5 m** apart, full movement, off walls | **UNVERIFIED_SECONDARY** | No |
| Home-gym blogs | “roughly a **6-foot radius**” around a bag | **UNVERIFIED_SECONDARY**; this is the prompt’s number’s **cousin**, still not a standard | Do not mint |
| Physics | A hanging bag **swings**. The envelope is bag diameter + chain travel + the striker’s step-off, not the shell. | **Fact / idea** | Designers of C think in envelopes; do not fake a radius |

**Hanging vs freestanding:** hanging needs dedicated overhead structure and a permanent footprint; freestanding is how fitness clubs fake boxing after yoga. Combat gyms that *are* boxing gyms hang bags. That is **CUSTOMARY**.

### Strength / cardio / circulation — health-club and S&C standards (wrong sport, right *kind* of clearance)

| Source | Figure | Grade | Combat gym? |
|--------|--------|-------|-------------|
| **IBC 2024 Table 1004.5** | **Exercise rooms: 50 gross sq ft/occupant** (4.65 m²). Occupant load for **egress**, people **in the room at once**. `https://codes.iccsafe.org/s/IBC2024V2.0/chapter-10-means-of-egress/IBC2024V2.0-Ch10-Sec1004.5` | **DIRECT** | **Not a membership roster** (J8 N9) |
| **ACSM Health/Fitness Facility Standards** (4th ed. 2012 as restated by IDEA 2013 and Athletic Business; 5th ed. 2019 exists, **table not retrieved as primary this pass**) | **10–14 sq ft per member** (roster planning); **40–60 sq ft per piece of equipment**; **40–60 sq ft per user** in group exercise; **3-foot** buffer around equipment; circulation **≥ 36 in**, adjacent to (not through) activity zones | **INHERITED** (4th ed. restatements); 5th ed. current numbers: **UNKNOWN this pass** | Health club, not MMA |
| **IHRSA/HFA 2019 overcrowding article** (J8) | Consultant GCB **2.5 members / m²** ≈ **10.76 sq ft / member on the roster** | **CUSTOMARY** commercial club (J8) | **Not combat-gym** |
| **NSCA** S&C professional standards (2017 *SCJ* restatement of the task-force guideline) | **100 ft² (9 m²) per participant** during peak; staff ratios 1:10 / 1:15 / 1:20 by school level; up to **3** participants per barbell/station | **INHERITED** (NSCA S&C, not MMA) `https://journals.lww.com/nsca-scj/fulltext/2017/12000/nsca_strength_and_conditioning_professional.1.aspx` | Weight room |
| **NSCA / textbook restatements** | **2–3 ft** between machines; **3 ft** between free-weight and machine areas; Olympic lifting area often cited **36 sq ft**; walkways **3–4 ft**; ceiling **12–14 ft** | **INHERITED** / textbook | Clearance *kind* |
| **DoD UFC 4-740-02** | Gymnasium courts: **12 ft** min / **14 ft** preferred side-to-side language appears in court module; group-exercise **10 / 12 ft** ceilings as above | **DIRECT** military rec | Ceiling *kind* for throwing/bags |
| **ASTM F2115** (treadmill clearance; home-gym restatements) | **78 in** behind a treadmill | **INHERITED** as that standard’s *kind* | Almost irrelevant to a fight gym |

**Combat-gym published sq-ft-per-member, bag-to-member, ring-to-member, peak occupancy %:** **UNKNOWN** (J8 N9/N10, reconfirmed 2026-09-10). Do not invent them.

### Locker / shower / toilet

**not found:** a combat-sport table of lockers per member or showers per peak class.

Usable *kinds*:

- Plumbing fixture counts follow **occupant load** (IBC/IPC), which for an exercise room starts from Table 1004.5 — again, **bodies present**, not the dues list.
- DoD UFC 4-740-02: full wet/dry locker program sized to **installation population**, not to a 2,500 sq ft warehouse club.
- Independent schools: a restroom + hooks is how many actually open (**CUSTOMARY**). Showers are a “serious” upgrade.

### Physio / sauna / pro-shop / spectator

No sport-wide square-footage. Catalog already authors physio as a station. Sauna is a health-club amenity. Pro-shop is a glass case until someone builds G17. Spectator at a school is benches; at a show is a commission floor plan (Florida’s rule is literally titled in part “Floor Plan and Apron Seating”).

## 2.3 Adjacencies — must-next-to / must-never / sightlines / noise

These are **rules**. They are what C should encode as tags, not as CAD.

**Must-next-to (kinds, with sources):**

| Pair | Why | Grade |
|------|-----|-------|
| Reception **sees the entry door** | Theft, waivers, emergency, “who is in the building.” DoD: control desk has **direct LOS** to the main entrance; alarm when the door opens. ACSM guideline: open-access circulation, no blind corners. | **DIRECT** (DoD); **INHERITED** (ACSM 4th restatement) |
| Reception **sees as much of the floor as the plan allows** | Safety / coaching / kids. DoD: LOS or CCTV to weights, cardio, structured activity, locker entrance. | **DIRECT** (DoD *kind*) |
| Changing **next to** showers; dry locker **before** wet | Moisture, privacy, HVAC exhaust from wet (DoD: supply from dry, exhaust from wet). | **DIRECT** (DoD); plumbing **CUSTOMARY** |
| Storage **on the training floor** (or with a door onto it) | Mats and pads move every class. DoD: storage with access to group-exercise. | **DIRECT** *kind* |
| Wall padding **on the mat’s hard edges** | Throws, shots to the wall. DoD: “method of fastening padding on walls for use during combative sports.” Wrestling rooms: wall mats are standard. | **DIRECT** (DoD); wrestling **CUSTOMARY** |
| Physio **off the training floor**, not through public lobby if possible | Injured athlete, privacy. | **CUSTOMARY** |
| Ring/cage **not in the only circulation path** | The object is a permanent island. People still have to reach bags and toilets. | **CUSTOMARY** / obvious function |

**Must-never (kinds):**

| Pair | Why | Grade |
|------|-----|-------|
| Office / reception **sharing air and sound** with plate-loaded strength and a stereo-led class | DoD explicitly lists weights, cardio, gymnasium, group exercise as **noisy**. | **DIRECT** (DoD) |
| Hanging bags **swinging into the mat / into the ring apron / into a walkway** | Safety. Envelope, not shell. | **Fact** |
| Wet showers **back-to-back with electrical bag mounts** without a wet-rated wall | Moisture vs electrics. | **CUSTOMARY** building |
| Spectators **inside the striking radius** | Bout rules put seats off the apron (e.g. Missouri **8 ft**). A school bench against a bag line is a lawsuit *kind*. | **DIRECT** as bout rule; school: **CUSTOMARY** caution |
| Cage/ring **under a low ceiling** | Florida: **12 ft** platform-to-ceiling for the ring. DoD: **12 ft** for large martial-arts programs. Bags and throws need height. | **DIRECT** (FL bout; DoD program) |
| Strength platforms **on a floor not rated for dropped weight** if you allow drops | NSCA restatements: **100 psf** load talk for S&C above grade. | **INHERITED** S&C; gym-specific: **UNKNOWN** |

**Sightlines.** The honest combat-gym version of DoD’s control desk: the person who takes your money can see who walked in, and a coach can see the mat and the bags without entering a blind studio. Glass on the office, a desk on a low riser, no maze of partitions on the floor. **CUSTOMARY**, supported by DoD/ACSM *kinds*.

**Noise.** Striking (bags, music, coaches yelling) vs BJJ (less impact noise, still music) vs wrestling (bodies, less chain-rattle) vs S&C (plates). If one building holds all four, the mat and the bag line are the two loud/dangerous cores; the office is the quiet exception. DoD’s acoustical separation for the martial-arts-capable group-exercise room is the closest **DIRECT** sentence.

## 2.4 Total size bands — m² **and** members served

**Do not mash products.** J8 N18 already: independent combat school = dozens to low hundreds of members; MMA-oriented **fitness chain** Signature/FIT = **thousands** of members on **30,000–45,000 sq ft**. The second is **G17 scenery**.

| Band | Floor area as published *somewhere* | Members as published *somewhere* | What it is | Grade | FightCamp? |
|------|--------------------------------------|----------------------------------|------------|-------|------------|
| **Lean BJJ / tiny club** | Member Solutions: first+last rent on **1,500–3,000 sq ft** (139–279 m²); Elite Sports “standard BJJ” **400–900 sq ft** (37–84 m²) as a **minimum training** claim | Peak class sized from mat rule-of-thumb, not a census | Start-up copy | **UNVERIFIED_SECONDARY** | Flavour of “too small,” not a default |
| **Martial-arts school (Gymdesk cost guide)** | **2,000–4,000 sq ft** (186–372 m²) space line for a martial-arts school | J8 Gymdesk Benchmark 2026 **size buckets: under 50 / 50–99 / 100–199 / 200+** members (4,594 gyms) — **not** tied by Gymdesk to a sq-ft column in the tables J8 retrieved | Closest **observed** independent-school world | **vendor-observed** (J8) | **The player’s world.** Do not author a sq-ft-per-member from it |
| **Boxing gym (operator 2026 guide)** | **2,000–4,000 sq ft** single-format; **3,500–5,000** if fitness + competitive | One sample P&L assumes ramp **60 → 220** members in a 3,500 sq ft box — **that article’s invention** | Trade blog | **UNVERIFIED_SECONDARY** | Do not wire 220 |
| **“Average MMA gym” vendor blogs** | RDX: “typically around **3,000 to 5,000 sq ft**” (279–465 m²); Dubai contractor: small **1,500–2,500**, mid **3,000–5,000**, professional **5,000–10,000+**; Sheets.Market: **2,500–6,000** | Sheets.Market sample: **200** members on **4,000 sq ft** — **spreadsheet marketing** | Vendor | **UNVERIFIED_SECONDARY** | **not** a measurement |
| **Boutique boxing-fitness franchise** | UFC GYM “CLASS” franchise page: **2,000–3,000 sq ft** | Class-fitness product | Franchise marketing | **UNVERIFIED_SECONDARY** / G17-adjacent | **Wrong product** |
| **MMA-oriented fitness chain (Signature/FIT)** | J8: **30,000–45,000 sq ft** (2,787–4,181 m²); one restated row **45,388 sq ft** with year-end members **8,081** | Thousands (J8: medians in the **5,000s** on ~**35,000** sq ft; 2025-year restatement median members **6,204**) | FDD Item 19 class | **evidenced as that FDD class** (J8) | **Refuse.** G17 |
| **UFC PI / HQ training** | Sports Business Journal 2017: UFC HQ **184,000 sq ft**; athlete training complex **30,000 sq ft**; first-floor S&C/rehab **13,000 sq ft**; upstairs traditional MMA room with octagon, ring, grappling mats, **15** sliding heavy bags | Not a membership business | Journalism | **UNVERIFIED_SECONDARY** | Scenery. Not the player |

**Combat-gym sq-ft-per-member as a sport table: UNKNOWN.** Do not divide 3,000 sq ft by 100 members and call it research.

**If C needs labelled invented bands for the player gym** (not evidenced, **invented**, sitting on J8’s member buckets and vendor *kinds*):

| Labelled band (invented gameplay) | Members (J8 buckets, not a formula) | Floor *kind* |
|-----------------------------------|-------------------------------------|--------------|
| Small | under 50 to ~99 | One room: mat + bags, desk, toilet. Ring folding or absent. No cage. |
| Mid | 100–199 | Mat zone + bag wall + a ring **or** a cage, small S&C, changing, office, storage. |
| Flagship independent | 200+ still **low hundreds**, not thousands | Both ring and cage, proper changing/showers, physio, maybe recovery. Still not 30,000 sq ft. |

Those bands are **authored**. They do not wear a citation.

**IBC check, so nobody “codes” the roster:** a 3,000 sq ft (279 m²) exercise room at 50 gross sq ft/occupant is an occupant load of **60 people in the room at once**. A gym can have 150 members and 25 people on the floor. J8 N9 stands.

## 2.5 Discipline differences (rooms, not pictures)

| Discipline | Identity object | Floor implications | What you can omit |
|------------|-----------------|--------------------|-------------------|
| **Boxing** | Ring + bags + open floor | Ceiling for bags; ring is a permanent (or fold-out) rectangle; little mat unless they teach clinch/wrestling. Music and bag noise. | Cage, wall-to-wall tatami |
| **MMA** | Mat **and** striking **and** (cage or ring) | Most expensive union. Separate dirty/wet from the mat. Cage/ring is a status object and a space tax. | Sauna, shop, bleachers |
| **BJJ** | Wall-to-wall mat | The academy *is* the mat. Reception and shoes-off line. Throws need wall pads if takedowns are live. Bags optional. | Ring, cage, heavy S&C |
| **Wrestling** | Dedicated mat room, wall pads, often school-sized sheets | NFHS/NCAA sheets are **38–42 ft**. A real wrestling room looks like a padded box, not a bag gym. Hosting duals needs the 5–8 ft obstruction rule. | Ring, cage, bag row |
| **Muay Thai / kickboxing** | Bags (including long/Thai bags) + open floor; ring optional/serious | Thai bags are longer; ceiling and neighbour-swing matter more. | Cage; deep BJJ mat |
| **Judo** | Tatami + crash area | Catalog already has a tatami row. Throws dominate; wall pads and ceiling. | Cage |
| **Fitness-chain “MMA”** | Group-fitness studio + optional octagon photo-op | 2,000–3,000 sq ft CLASS box or 30k Signature. | **The player’s desk** (G17) |

**Do not** average these into one “MMA floor plan” and call it research. C’s dozen should include **boxing-led**, **BJJ-led**, and **MMA-union** variants, not twelve clones of a Pinterest octagon.

---

# §3 Is PDF-to-geometry plausible? (sceptical)

## 3.1 What is actually in the wild

| Artifact | Typical encoding | Scale? | Labels? | Licence? |
|----------|------------------|--------|---------|----------|
| Architect’s CAD PDF (construction set) | Often **true vector** (paths, sometimes layers) **or** a flattened plotter PDF | Yes, if not exploded | Room names, door swings, sometimes | Architect’s copyright |
| Scanned as-builts / permit scans | **Raster** (sometimes a vector wrapper around an image) | Distorted | Hand notes | Same |
| University / municipal “plans” for wayfinding | Mixed; often a simplified raster export | Sometimes | Room numbers | Institution/architect |
| Vendor 3D “floor plan” marketing | Raster render or Illustrator art | Decorative | Marketing | Vendor |
| **Pinterest MMA board** | **236-px JPEG**, screenshots, watermarks, no sheet | **No** | **No** | **No** |

Pinterest is the worst possible corpus for geometry. Anyone pitching “we’ll scrape the board and get polygons” has not opened the board.

Even **good** architectural PDFs are not game data. A construction set is walls, doors, grids, notes, hatches, furniture blocks, and a hundred layers named by a person who left the firm. There is no layer called `mma_cage_clearance`.

## 3.2 Vector extraction

Tools exist: `pdf2svg`, `mutool draw`, Inkscape, Adobe Illustrator, AutoCAD PDF import, QCAD, `pypdf` path dumps.

**What you get:** unlabelled polylines. Walls as double lines or as hatches. Doors as arcs. Title blocks. The architect’s logo. Furniture as exploded junk. Text as a separate encoding (sometimes outlines, sometimes a font).

**What you do not get:** “this polygon is the mat; this radius is a bag.” That is **manual classification**, per plan, by someone who understands gyms.

**Cost:** hours to days **per sheet** to turn soup into a clean, snapped, labelled plan. A dozen real construction sets is a small architecture contract, not a data-science weekend.

**Legal:** extracting geometry from a copyrighted drawing to ship as a game layout is making a **derivative** of Object 1 (the drawing) and likely of Object 2 (the arrangement). See §1. **Do not.**

## 3.3 Raster automated floor-plan recognition

This is a real research field. It is **not** a gym-layout pipeline.

- **CubiCasa5K** (Kalervo et al., 2019, arXiv:1904.01920, `https://arxiv.org/html/1904.01920`): **5,000** mostly **Finnish residential** floorplan images, **80+** classes (rooms, icons, walls), SVG polygon labels. Baseline multi-task CNN. **Raw** segmentation beats **polygonized** output because **missed junctions mean no polygon** — the paper’s own warning. Class IoUs for many icons/rooms sit in ranges that would be unacceptable as shipped game geometry (e.g. polygonized test IoU for several classes in the teens to 60s; walls/rooms better, still not “trace this gym”). Dataset is **apartments**, not MMA gyms. **No heavy bag, no cage, no ring** as classes.
- **Liu et al., Raster-to-Vector** (ICCV 2017): the breakthrough paper; **<1,000** plans; junction + segmentation + integer programming. CubiCasa authors still needed heavy post-process.
- Later work (MitUNet 2025, inverse algorithmic design 2025, semantic 3D from 2D 2023): still **walls / doors / rooms / residential icons**. Still **post-process**. Still **not gym equipment**.

**Quality vs effort:** even SOTA residential parsers need a human to fix walls, infer scale, and label purpose. A gym scan from Pinterest has **no consistent scale**, **no wall convention**, and **equipment drawn as cartoons**. Automated recognition of *that* is **UNKNOWN as a working system** and, on the published evidence, **not plausible at shipping quality**.

**Effort cost:** a research engineer + a labelled corpus of **thousands** of **gym** plans that you **do not have** and **may not copy**. CubiCasa was a byproduct of a commercial vectorization pipeline with human annotators taking **5–120 minutes per image**. That is the real cost, and those images were licensed to CubiCasa.

## 3.4 How many plans needed?

**If the generator is driven by rules (route B as generation): none.**

The constraints in §2 are not learned by PCA on 400 traced gyms. They are sport rules, code, and a short adjacency list. Tracing 40 Pinterest JPEGs would add **copyright exposure** and **zero** reliable radii.

**If the goal is a walkable 3D gym:** you need art direction, not a corpus. That is still not this game.

**If the goal is statistical “realism” of layout variety:** **not found** that anyone has a licensed, labelled, combat-gym plan dataset. Building one legally means commissioning it (which is C) or licensing it (which is still C, paid).

---

# §4 Compare honestly A / B / C

Do not endorse the operator’s framing that “of course we extract real plans.” The honest comparison is cost, legality, and **what the game is**.

| | **A — Extract real plans from PDFs as data** | **B — Learn rules from plans → generate from constraints** | **C — Hand-authored dozen that scale with the business** |
|--|----------------------------------------------|-----------------------------------------------------------|----------------------------------------------------------|
| **What it is** | Ingest construction PDFs / Pinterest / municipal sets; vectorize; label; ship as layout data or as seeds | Read plans (or §2) until you have constraints; write a generator that packs stations into a rectangle | Design ~12 layouts (small boxing, small BJJ, small MMA, mid union, flagship independent, maybe a bad warehouse). Unlock rooms/stations as the business grows |
| **Legal** | **Fails the gate** unless every sheet is licensed or government text-as-rules. Tracing is the *Johnson v. Jones* fact pattern. Pinterest is the worst case. | **Passes the gate** if the generator uses **facts and independently authored** packing, not a traced seed. Fails if “learn” means “overfit to stolen plans.” | **Passes.** Original compilation of unprotectable parts. Thin-copyright case law is on *your* side if you did not copy a particular distinctive plan. |
| **Technical** | Vector soup + raster research models trained on **flats**, not gyms. Manual cleanup dominates. | Generators need a complete constraint set **and** still produce junk (cages in corridors, bags in showers) without a lot of handmade rules — which **are C**. | A producer and a spreadsheet. Matches `used_space` / `total_space` / catalog footprints already live. |
| **Cost** | High (legal review + labelling + engineering) for a management game that will not walk the floor | Medium-high (generator + constraint debugging). Looks like “systems” while delivering wallpaper | **Low.** Dozen layouts, tagged rooms, unlocks |
| **Failure mode** | Lawsuit; unlabelled geometry; Pinterest 236-px “data”; wrong product (rec centers, Signature boxes) | Generator looks clever in a pitch, then every gym is a rectangle with a cage in the middle; you spend the C budget on a generator anyway | Dozen is not infinity; players see repeats. **Mitigation:** unlocks and station placement *inside* a layout, which the catalog already is |
| **Fits a management game?** | No. Extracts an FPS map from someone else’s CAD. | Only the **constraint list** fits. The **generator** is a different game (Prison Architect / Two Point Campus). FightCamp has not chosen to be that. | **Yes.** Business upgrades = new room / new station / more `total_space`. |

### Pick: **C**, with B’s constraints as the **authoring checklist**

**Why not A.** The legal gate is not a vibe. Dual copyright + Pinterest provenance + “ripped assets never ship” is a complete veto. Even a *licensed* municipal rec-center PDF is the wrong building. Extraction quality is poor. The output is geometry a management game does not simulate.

**Why not B-as-generator.** A constraint generator is the right *engineering* answer to a *different* question (“can we make infinite walkable gyms?”). This pack’s question is whether a **management** gym needs that. It does not. B’s failure mode is paying for a generator whose constraint file is just C in YAML, then shipping worse layouts than a producer would draw in a week. If the operator later wants Two Point Campus, **reopen** with a new task; do not smuggle it through “we learned from plans.”

**Why C.** It is original expression you own. It uses §2 rules (desk sees the door; mat ≠ bag swing; wet stacked; noisy off the office). It scales with the **business** (the actual game): more members / more coaches / more disciplines unlock a second room, a ring, a cage, showers, physio. It does not pretend IBC 50 is a dues formula. It does not need a corpus.

**Cost of C:** a layout pass on paper (or tiles matching catalog `footprint` units), not metres-as-truth. **Failure mode:** twelve similar warehouses. **Fix:** discipline variants (§2.5), not more stolen plans.

**What B still contributes:** the adjacency table and the sport-rule **station sizes** as **caps** (“you cannot claim a regulation cage in a room whose tile footprint is smaller than the cage plus gates”). That is a **checklist**, not a generator.

---

# §5 What would we actually see?

**The gym today is numbers, not a room.** Live objects (J8 file-level anchors, not reopened): `station_capacity`, `footprint`, `used_space` / `total_space` on the creation take, `weekly_upkeep`, quality/safety. Membership, if it ships, is a **credit** (R44 flat). Nobody walks a mesh.

**What a floor plan adds that a facilities list does not:**

| Possible add | Honest value | Already have it? |
|--------------|--------------|------------------|
| Which stations exist | High | **Catalog** |
| How many can train at once | High | **`station_capacity`** |
| How much space is used vs owned | Medium | **`used_space` / `total_space`** |
| Unlock order (“you built showers”) | Medium — flavour + a cost sink | Facilities list with flags |
| Adjacency complaints (“bags next to physio”) | Low–medium flavour | A tag on the facilities list |
| Sightlines / safety as a mechanic | Low unless you simulate accidents | **Don’t**, unless a later pack files it |
| Walkable geometry, pathing, pretty CAD | **High cost, near-zero management-game value** | No, and should not |
| Member density from plan area | **Lie** if evidenced; **invented cap** if labelled (J8 N22) | Do not wear IBC |

**A floor plan buys a management game:**

1. A **picture** of the business (optional UI).
2. An **unlock graph** of rooms (reception always; cage is a mid-game capital object; sauna is vanity).
3. A **space budget** so the player cannot stack ten rings in a closet (catalog footprints already almost do this).

**It does not buy:** a demand curve, a realistic construction set, or the right to someone else’s CAD.

**Honest sentence:** **not much**, if the facilities list is complete and footprints already cap stations. Spend the art budget on a dozen authored diagrams and on **not** lying about square footage. Spend the design budget on the membership object J8 already specified. Do not spend it on a floor-plan neural net.

If the operator wants the player to *feel* a gym, C’s dozen plus station icons is enough. If the operator wants the player to *place every bag*, that is a different game, and it still does not require extracted real plans.

---

# Local findings cited (not reopened)

From **J8_THE_MEMBERS.md** (2026-09-07), capacity only:

- **N8:** Equipment is a **capacity ceiling + upkeep**, not an attraction magnet.
- **N9:** IBC 2024 Table 1004.5 **Exercise rooms = 50 gross sq ft/occupant** = **egress**. IHRSA/GCB **2.5 members/m²** = **commercial-club roster customary**. Combat-gym sq-ft-per-member = **UNKNOWN**.
- **N10:** Utilisation % **UNKNOWN**. Catalog: one bag, one athlete in session.
- **N18:** Independent martial-arts school = **dozens to low hundreds** (Gymdesk buckets). Chain **30,000–45,000 sq ft** / thousands of members = **G17 scenery**.
- **N22:** If count ever moves, cap from `station_capacity` and/or floor, **labelled invented**.

From **`equipment_catalog.json` v2:** stations already have `footprint` tiles and `station_capacity`. **No cage item.** Ring/mat items exist as **invented** footprints. This pack does not retune costs or caps.

---

# § UNKNOWN (do not fill)

- Combat-gym **sq-ft-per-member** (roster) as a published table.
- Combat-gym **peak occupancy %**, bag-to-member, ring-to-member, cage-to-member ratios.
- A published **training-cage** size table (as opposed to Unified Rules **bout** cages).
- A published **hanging-bag swing radius** from ACSM / NSCA / IBC / a commission.
- **“6-foot apron clearance”** as a gym-planning rule.
- **“40 sq ft per training pair”** as a gym-planning rule.
- ACSM **5th edition** current numeric table (4th ed. restatements used; 5th not retrieved as primary).
- A **CC0 / licensed MMA-gym construction-document corpus** usable for commercial game derivatives.
- Copyright status of any **particular** municipal/university PDF (varies by contract).
- Independent-combat-gym **locker/shower fixture** schedule.
- Combat-gym **rent $/sq ft** (J8 N17: UNKNOWN as a sport table).
- How many of the Pinterest board’s pins are copyrighted architectural works vs photos of interiors vs vendor renders — **per-pin UNKNOWN**; treat **all** as unlicensed.
- Whether a given CAD-library “free DWG” is actually owned by the uploader.
- A published **generator quality** metric for combat-gym layouts (field does not exist).

---

# Do-not-build

1. **No tracing Pinterest.** No board scrape, no 236-px JPEG as geometry, no “reference mesh” from a pin.
2. **No ripped assets.** No permit-set walls, no architect’s title block, no vendor sample plan, no UFC Octagon® livery, no named academy’s posted CAD. Standing project rule.
3. **No PDF-to-mesh pipeline** as a shipping dependency.
4. **No layout generator** unless a later task explicitly changes FightCamp into a tycoon that *is* about placing rooms — and even then, generate from **C’s rules**, not from stolen seeds.
5. **No IBC 50** as a membership roster. No ACSM 10–14 sq ft/member as MMA. No 2.5 members/m² as combat-gym law.
6. **No invented radii** presented as measured (bag swing, station density, pair area) wearing a fake citation.
7. **No demand-curve reopen** of J8. Floor area may later **cap** an authored count (N22). It does not pull members.
8. **No fitness-chain occupancy sim**, franchise territory, merch-shop career, kids-program-as-mode (J8 N18 / G17).
9. **No code, no state machines, no `assets/data` writes** from this pack.
10. **No real gym’s, architect’s, or fighter’s name as catalog data.** Named facilities appear only as a **product class** (G17) or a **kind of source**.

---

# Sources

**Legal (DIRECT unless noted):**

- 17 U.S.C. § 101 (architectural work; PGS includes architectural plans): https://www.law.cornell.edu/uscode/text/17/101
- 17 U.S.C. § 102(a)(5), (a)(8), (b) (PGS; architectural works; ideas/facts/systems): https://www.law.cornell.edu/uscode/text/17/102
- 17 U.S.C. § 105 (U.S. Government works): https://www.law.cornell.edu/uscode/text/17/105
- 17 U.S.C. § 120(a)–(b) (pictorial representations of constructed buildings; alteration/destruction): https://www.law.cornell.edu/uscode/text/17/120
- 37 C.F.R. § 202.11 (architectural works registration; standard features excluded): https://www.law.cornell.edu/cfr/text/37/202.11
- U.S. Copyright Office Circular 41: https://www.copyright.gov/circs/circ41.pdf
- Compendium, Third Edition, Chapter 900 (visual art / architectural works): https://www.copyright.gov/comp3/chap900/ch900-visual-art.pdf
- *Baker v. Selden*, 101 U.S. 99 (1879): https://en.wikipedia.org/wiki/Baker_v._Selden (case text widely available; Wikipedia used as locator 2026-09-10)
- *Feist Publications, Inc. v. Rural Telephone Service Co.*, 499 U.S. 340 (1991): https://www.law.cornell.edu/supremecourt/text/499/340
- *Intervest Construction, Inc. v. Canterbury Estate Homes, Inc.*, 554 F.3d 914 (11th Cir. 2008): https://cases.justia.com/federal/appellate-courts/ca11/07-12596/200712596-2011-02-28.pdf
- *Designworks Homes* 8th Cir. 2021 (floor plans ≠ § 120(a) pictures): https://www.ipupdate.com/2021/08/when-pictures-arent-pictures-real-estate-agent-generated-floor-plans-are-outside-copyright-infringement-exception-for-pictorial-representations/
- *Leicester v. Warner Bros.*, 232 F.3d 1212 (9th Cir. 2000): https://scholar.google.com/scholar_case?case=6364679535330779349
- Pinterest Terms of Service (effective 2025-04-30): https://policy.pinterest.com/en/terms-of-service
- Pinterest Content Claiming Portal: https://help.pinterest.com/en/article/get-started-with-the-content-claiming-portal
- Task inspiration board (aggregator, not a source of rights): https://www.pinterest.com/ideas/mma-gym-floor-plan/950830226557/

**Sport rules — cage / ring / mat (DIRECT):**

- ABC, Committee Report on Unified Rules for MMA: https://www.abcboxing.com/committee-report-on-unified-rules-for-mma/
- Unified Rules PDF (UFC media copy of ABC text): https://media.ufc.tv/discover-ufc/Unified_Rules_MMA.pdf
- OAR 230-070-0025: https://oregon.public.law/rules/oar_230-070-0025
- 58 Pa. Code § 29.4: https://www.law.cornell.edu/regulations/pennsylvania/58-Pa-Code-SS-29-4
- R.I. Gen. Laws § 41-5.2-9: https://webserver.rilegislature.gov/Statutes/TITLE41/41-5.2/41-5.2-9.htm
- Wis. Admin. Code SPS 192.50: https://www.law.cornell.edu/regulations/wisconsin/Wis-Admin-Code-SS-SPS-192-50
- Fla. Admin. Code r. 61K1-3.019 (ring, apron, ceiling): https://www.law.cornell.edu/regulations/florida/Fla-Admin-Code-Ann-R-61K1-3-019
- 19 NYCRR 210.24 (NY professional boxing ring): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-210.24
- 20 CSR 2040-6.010 (MO ring + 8 ft spectator): https://www.law.cornell.edu/regulations/missouri/20-CSR-2040-6-010
- USA Boxing Rule 27 (2026): https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt5ff28f6e78e9624d/695ed2d8b45570d8a64b74b9/USA_Boxing_Rule_Book_Revisions_-_1.1.2026.pdf
- IBA Technical & Competition Rules § 42: https://www.iba.sport/wp-content/uploads/2022/02/20230209-IBA-Technical-Competition-Rules.pdf
- IBJJF Rules (EN June 2024 file): https://cdn.shopify.com/s/files/1/0727/9715/9746/files/2024JUN_IBJJF_Rules_EN.pdf
- IBJJF Rules (JP 2024, same 64/100 m²): https://www.jbjjf.com/wp-content/uploads/2024/11/JP_IBJJF_RulesBook_JUN2024_1.pdf
- NCAA Men’s Wrestling playing rules landing: https://www.ncaa.org/championships/playing-rules/mens-wrestling-playing-rules/
- NCAA wrestling rules (circulating 2017–19 text, mat arts. 1–3): https://soconsports.com/api/media/file/9692cbf7-8bb3-41db-be53-a34a2a36b074-2017-18_20__202018-19_20WRESTLING_20Rules_and_Interpretations.pdf
- NCAA D1 host ops (42×42 mats): https://ncaaorg.s3.amazonaws.com/championships/sports/wrestling/d1/men/2025-26D1MWR_HostOpsManual.pdf

**UFC Octagon® (branded show cage; trademark warning):**

- https://www.ufc.com/octagon?language_content_entity=en
- Archived UFC “Get Inside” Octagon page (30 ft / ~750 sq ft): https://web.archive.org/web/20180828035729/http://www.ufc.com/discover/sport/octagon

**Code / facilities criteria:**

- IBC 2024 § 1004.5 / Table 1004.5 (Exercise rooms = 50 gross): https://codes.iccsafe.org/s/IBC2024V2.0/chapter-10-means-of-egress/IBC2024V2.0-Ch10-Sec1004.5
- IBC 2024 Chapter 10: https://codes.iccsafe.org/content/IBC2024P1/chapter-10-means-of-egress
- DoD UFC 4-740-02 Fitness Centers (3 Feb 2019, Ch. 1 30 May 2019): https://www.wbdg.org/FFC/DOD/UFC/ufc_4_740_02_c1_2019.pdf (S3 copy retrieved 2026-09-10)

**Health-club / S&C space (INHERITED / J8; not combat-gym defaults):**

- J8 pack, N8–N10, N18, N22 (IHRSA/HFA 2.5 members/m²; Gymdesk buckets; IBC 50): local `J8_THE_MEMBERS.md`
- HFA overcrowding / 2.5 members/m² (2019): https://www.healthandfitness.org/solve-overcrowding-at-your-gym-with-this-simple-equation/
- ACSM book landing (5th ed. exists; numbers from 4th-ed restatements): https://acsm.org/education-resources/books/facility-standards-guidelines/
- IDEA restatement of ACSM 2012 10–14 / 40–60: https://www.ideafit.com/facility-design-and-construction-101-part-one/
- Athletic Business restatement of ACSM space recs: https://www.athleticbusiness.com/facilities/fitness/article/15142854/the-issue-is-facility-design
- NSCA S&C professional standards (100 ft²/participant): https://journals.lww.com/nsca-scj/fulltext/2017/12000/nsca_strength_and_conditioning_professional.1.aspx

**Vendor / secondary gym-size and bag-spacing (UNVERIFIED_SECONDARY — labelled in body):**

- Gymdesk, cost to open a gym (martial arts **2,000–4,000 sq ft**): https://gymdesk.com/blog/how-much-does-it-cost-to-open-a-gym
- Member Solutions, open a BJJ gym (50–75 sq ft/student on mat; 2,000–4,000 total): https://membersolutions.com/blog/open-bjj-gym-guide/
- Century / CMFIT, 1 bag per 100 sq ft (cardio class): https://cdn2.hubspot.net/hubfs/2264894/Downloadable-PDF/CMFIT/180803-15551-cmfit-bags-for-my-program-pdf-lr.pdf
- Century, fit a cardio bag class: https://wholesale.centurymartialarts.com/blogs/century-kickboxing-gym-owner-blog/how-do-i-fit-a-cardio-bag-class-into-my-gym
- Compound Fitness AU, ring/cage/facility bands: https://compoundfitness.com.au/blogs/news/boxing-combat-sports-gym-equipment
- RDX, “average” MMA gym 3,000–5,000 sq ft: https://wholesale.rdxsports.com/blog/boxing-mma-gym-design-layouts-examples/
- UFC GYM CLASS franchise 2,000–3,000 sq ft: https://ufcgymfranchise.com/ufc-gym-jiu-jitsu-franchise-opportunity/
- Sports Business Journal, UFC HQ / PI 2017: https://www.sportsbusinessjournal.com/Journal/Issues/2017/04/24/In-Depth/UFC-HQ/
- Sports Business Journal, UFC Gym 2014 (30k+ boxes / 5k franchise): https://www.sportsbusinessjournal.com/Journal/Issues/2014/04/21/In-Depth/UFC/

**PDF / recognition (sceptical):**

- Kalervo et al., CubiCasa5K, arXiv:1904.01920: https://arxiv.org/html/1904.01920
- Liu et al., Raster-to-Vector (ICCV 2017) — cited inside CubiCasa5K
- CubiCasa product background: https://www.cubi.casa/introduction-property-data-automation/

**Local:**

- `equipment_catalog.json` v2
- `J8_THE_MEMBERS.md`
- `TASK_J16.md`

---

*End of J16. Cut from the Decisions lines. Legal gate first: you may not trace these; you may use what they teach you. Route C. Numbers they should build to are catalog stations, sport-rule equipment as kinds, J8 member buckets, and labelled invented size bands — not IBC-as-dues, not Pinterest polygons, not invented radii. The gym is a business. A floor plan is a facilities list with a picture. Ripped assets never ship. J8’s demand curve is not reopened.*
