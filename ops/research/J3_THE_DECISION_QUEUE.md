# J3 — The Decision Queue: What We Have To Rule On Next

**Desk:** John (research)  
**Date:** 2026-09-06  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design. No second career mode (J2 §6.2).  
**Local snapshot used:** `real_organizations.json` (`snapshot_date` 2026-09-01); `J1_ORGANIZATION_RULES_AND_JUDGES.md`; `J2_THE_FEDERATION_PATHWAY.md`; `weight_classes.json` v2 (J1 workspace copy); HANDOFF / CURRENT_STATUS / K15 / K20 as engine facts. `GameState.gd` / `Sponsorship.gd` / `WorldPopulation.gd` were **not** in this workspace — line numbers below are from TASK_J3, J2, K15, and HANDOFF, labelled as such.

**Cite, do not re-litigate:** J1 (18 orgs, rules, judges, UNKNOWN policy, §4.1 brand). J2 (three **entry/money** pathways, money-flow table §2.6, D6 minimum change, §5.1 scenery for Olympic IFs, §6.2 unplayed-mode).

**UNKNOWN policy (same as J1/J2):** a fee, a period, a percentage, a bonus figure, or a ranking formula that is not in a primary PDF / commission regulation / promotion athlete page is **UNKNOWN**. Never invent one. Inherited ABC / commission / promotional practice is labelled **INHERITED** or **CUSTOMARY**, not claimed as that org’s published rule. National overlays are **NATIONAL**. No real officials’, athletes’, or executives’ names as data.

**No fifth area.** After the four, the thing that would have been a fifth (a playable boxing-alphabet career) is **scenery**, not a fifth research track. See D4 and the priority ruling.

---

## Decisions page (operator calls)

This page is what the next research/build cuts from. One recommendation, one line why.

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| **D1** | What makes a bout a title bout | A title bout is a **flag on the bout**, not “whoever is #1 fights the holder.” House promotions (the 13) own one belt per `discipline\|weight_class\|sex`. Rankings inform booking; they do not auto-mandate. | UFC/ONE/PFL/GLORY title shots are promotional. Boxing alphabet mandatories are a different animal and are not in the catalog. |
| **D2** | Interim titles | Add `title_status ∈ {vacant, champion, interim}`. Create interim only when the holder is **unavailable** (injury / legal / other hold) past a data-authored window. On return: unification bout; interim is not a second belt to keep. | WBC Rule 1.27 / IBF Rule 17 / UFC practice all treat interim as a placeholder, not a second championship. The game has **no** interim state. |
| **D3** | Unification / undisputed / two-division | **Do not** ship boxing four-belt undisputed as a playable object. Two-division: G4’s clock is the honest UFC-shaped rule (hold two, defend or give one up). Unification inside a **house** promotion is just “one belt, two claimants” (champ vs interim). | Catalog has no WBA/WBC/IBF/WBO. UFC two-division is case-by-case, not a published day-count bylaw. |
| **D4** | Boxing alphabet: fourth **pathway** or not | **Not a fourth J2 pathway.** Alphabet orgs are a **title-authority overlay on signing**: they rank and sanction someone else’s card, collect a sanctioning fee, do not promote, do not pay a purse. Variant of J2 **signing**, plus a new `entity_type` **only if** boxing world titles ever ship. Do not add them to the 18. | J2’s three pathways answer “who puts you on the mat / who pays whom.” Alphabet answers “whose belt is on the card.” Different question. |
| **D5** | Rankings: published formula vs discretion | Store `ranking_mode ∈ {discretionary, published_criteria, mixed}`. **Do not invent a formula.** UFC media panel = discretionary vote. Meta UFC Rankings (2026) = qualitative model, **formula UNKNOWN**. IBF has written criteria **and** an exceptions clause. GLORY: published discretion. | Reverse-engineering a ranking from results is the lie this desk exists to stop. |
| **D6** | Medical hold after KO/TKO/cut | `book_fight` refuses an athlete with `medical_hold`. After KO/TKO (and after a doctor-stop cut), set the hold. Lift by **clearance**, not by an invented day count. Optional DIRECT overlay: Nevada MMA rest `NAC 467.472` (4 days × rounds officially begun) is a **successive-bout** rule, not a KO schedule. | There is **no** published ABC MMA KO/TKO table. Nevada `NAC 467.562` is physician-fitness. CSAC issues 7-day rest + injury-specific terms in practice. Inventing “KO = 60 days” would be the third delay. |
| **D7** | Commission vs self-regulating | One org field `regulator_kind ∈ {athletic_commission, house_plus_officials, national_sport_authority, unknown}`. US UFC/PFL/Karate Combat cards: commission. RIZIN: JMOC + promotion medical (not a state commission). ONE: house rules + host overlay. ARES: FMMAF/FFBoxe. URCC: GAB. Jungle: CABMMA. CMMAF: KOA/IMMAF amateur. Reciprocity of suspensions is **ABC-member**, not global. | The game ships orgs in both worlds. A Nevada hold is not automatically a Saitama hold. |
| **D8** | Overturned result / No Contest | Add result types `no_contest` and `technical_decision` (R38 already has UD/SD/MD). Accidental-foul NC before half the scheduled rounds + 1 second; technical decision after (ABC Unified MMA). Anti-doping: Nevada `NAC 467.579` **may** flip a win/draw to NC. Do not auto-flip on every positive. | R38 can split a decision. It cannot yet write a NC. That is the next honest result. |
| **D9** | Drug testing | Commission overlay, **not** a second career. US: promoter program + commission (UFC Anti-Doping / PI; Nevada WADA list). ONE: IDTM/DFSI from Aug 2022 (ONE page). RIZIN: in-house medical/doping desk. Violation cost in **time**: UNKNOWN as a single number; bout fate: commission discretion (NC possible). | A “failed test” already exists as an R3 pull-out **weight** (15). That is invented cause-mix, not a testing program. |
| **D10** | Weigh-in calendar | Keep D2’s **day-before** as the house default (UFC-shaped). Same-day is the exception (amateur / some stadium / some commissions). ONE: combined hydration + weigh-in **24–48 hours** before the event (ONE page). Do not rebuild D2. | TASK_J3 said “no weigh-in.” That is stale. D2 shipped. The hole is **honesty**, not absence. |
| **D11** | Missed weight: % and belt | Do **not** change the live 20% fine to 25% as a global. Nevada `NAC 467.522` is **25% to the opponent** (or a lesser amount set by the Director) unless ≤1 lb. 20% is **CUSTOMARY** on many US MMA cards, not ABC text. **Belt:** a title does not change hands unless both made the contracted class (GLORY 2026 §2.01; IBF championship rules; ONE title misses). | The game’s 20% and 3% catchweight window are invented. Belt-fate is the player-visible lie. |
| **D12** | Catchweight / rehydration / health | Catchweight = both camps + promoter (+ regulator if commissioned) agree. ONE published: within **105%** of each other’s hydrated weight; the misser’s purse **percentage is UNKNOWN** on the ONE page (“a percentage”). Rehydration **enforced**: ONE USG ≤1.025; IBF second-day cap table (not unification, not heavyweight). UFC day-before: **not** a rehydration cap. Health: cite ACSM 2021 and ISSN 2025; **do not** turn them into a mechanic (TASK). CSAC 15% fight-day cancel: voted 2019; **current 4 CCR force UNKNOWN**. | Health positions are contested. Shipping a “safe cut %” as physics is a mechanic recommendation this desk is forbidden to make. |
| **D13** | Show / win / bonuses | Keep purse + win bonus as the two live numbers. Where a commission **discloses** (California), show and win are separate. Fight-night bonuses: **promotion-authored**, not a commission. UFC: $50,000 FOTN/POTN until UFC 324 (Jan 2026), then **$100,000** plus **$25,000** finish consolation (SBJ 2026-01-24). PFL 2025 tournament winner **$500,000** (PFL 15 Jan 2025 + 2025 World Tournament Rules PDF). R6’s $2,500 × hype is **invented**. | Do not replace R6 with UFC $100k as a silent default for Jungle/LUX/URCC. |
| **D14** | PPV participation | **UNKNOWN as a number.** Do not store a %. California BPC 18824 is a **promoter tax report** on gate and broadcast rights, not a fighter PPV-point table. Nevada stopped public purse lists (~2020 confidentiality statute). Reported “points” stay in journalism; they are not bout-contract data. | Brutal boundary: disclosed ≠ earned. Inventing 1% of PPV is the 2am decision this study exists to stop. |
| **D15** | Outfitting / `Sponsorship.gd:224` | First legal branch: `outfitting_policy ∈ {house_kit, fighter_sponsors}`. UFC: house kit (Venum through 2029) + Promotional Guidelines Compliance pay (tier table, secondary-confirmed 2026). Other 12: **UNKNOWN** as a published kit ban unless a primary is filed; default `fighter_sponsors`. | `:224` already receives `entity_type` and branches on nothing (J2). This is the evidence that lets it. |
| **D16** | **Minimum change** (this study’s D6) | Four one-liners, not a range — see each area’s (d). Build order is the priority ruling, not a fifth system. | Stops the next 2am invention without a second career mode. |

**Fifth area?** No. A playable WBA/WBC/IBF/WBO ladder would be a new catalog and a new Ali-Act overlay. It does not outrank a KO hold, a title-bout flag, or belt-fate on the scale. Park it as scenery (priority ruling).

---

## File-level anchors (what is live vs this study)

| File / fact | Role | Live? | Honesty |
|-------------|------|-------|---------|
| `real_organizations.json` | 18 identities, 13 `promotion` + 4 `federation` + 1 `tournament_operator` | catalog | Honest identity. **No** `pathway` (J2), **no** `regulator_kind`, **no** `outfitting_policy`, **no** title-authority type |
| `population["championships"]` keyed `discipline\|weight_class\|sex` | One holder per key | LIVE (HANDOFF G4) | **Invented house belts.** No interim, no sanctioning body, no mandatory |
| `WorldPopulation.apply_title_logic` | Moves a belt on a title bout | LIVE | Title bout is “vs the holder,” not a sanctioned object |
| `WorldPopulation.vacate_title` (~:918) | Hands a surrendered belt to best remaining contender | LIVE (R7) | Honest as a vacancy fill; **invented** “best contender” |
| `GameState.get_athlete_title` | First belt found | LIVE (G4: callers assume one) | Breaks two-division |
| `get_division_rankings` (`:9235`) / `get_p4p_rankings` (`:9240`) / `get_championships` (`:9223`) / `get_champion_superfight_offers` (`:9289`) | Rankings APIs (K15) | LIVE | Rankings exist (R30). Formula is **gameplay points**, not a published org method |
| G4 DOUBLE CHAMPS | Adjacent-class superfight + sanctioning window | **ASSIGNED** 2026-09-03; ship-state **UNKNOWN in this workspace** | Do not assume it landed |
| `WeightCut.gd` + `weight_classes.json` `miss.fine_fraction` **0.2**, `catchweight_max_fraction` **0.03**, weigh-in **day before** | D2 | LIVE (`cf06610`) | **Invented** numbers; calendar is UFC-shaped |
| `pre_fight_medicals_test` | Fight-day medicals gate | LIVE (HANDOFF) | A medical **gate** exists. A post-KO **hold** does not |
| R3 pull-out weights | injured 50, missed weight 20, **failed test 15**, illness 10, visa 5 | LIVE | **Invented** mix. “Failed test” is a short-notice cause, not USADA/IDTM |
| `get_promotion_bout_offer` (`:5492`) / `_promotion_purse_multiplier` (`:5483`) / `accept_signing_offer` (`:5288`) | Purse + win bonus; S×4 / A×2.5 / B×1.6 / C×1.2 / D×1 | LIVE (J2; HANDOFF `fe8052a`) | Honest **shape** for promotions; **invented** multipliers; still pays federations (J2 D2) |
| `FightAwards.gd` | POTN / FOTN **$2,500** × hype, world cards only | LIVE (R6) | **Invented** size and rule (longest distance = FOTN) |
| `Sponsorship.gd:224` | Sees `entity_type` | LIVE (J2) | Copied, **never branched** |
| `WorldPopulation.gd:174` | Every merged org gets an opening event | LIVE (J2) | Lie for the five non-promotions (R40 / J2 D6) |
| R38 `JudgePanel.gd` | N=3, UD/SD/MD | LIVE (TASK_J3) | Honest ABC decision types. **No** NC / technical decision |
| R33 booking | Offers, class gate, clauses | LIVE | Booking exists. It does not ask “is this a title” or “are they suspended” |

---

# Area 1 — The championship picture

## (a) Decisions coming (named as calls)

1. **Call: title-bout flag.** Is a fight a title fight because the opponent is the holder, because the contract says so, or because a sanctioning body put a belt on it?
2. **Call: mandatory vs discretionary challenger.** Does #1 get the shot, or does the promotion book whom it wants?
3. **Call: how long a champion may sit.** Vacate on inactivity? After how long? Whose clock?
4. **Call: interim.** When created, what it is worth, what happens when the champion returns.
5. **Call: two-division.** Simultaneous hold, sequential two-division, or forced vacate first?
6. **Call: unification / undisputed.** House one-belt vs boxing four-belt. Is undisputed even a game object?
7. **Call: alphabet as pathway.** Fourth J2 pathway, or title overlay on signing?
8. **Call: ranking method.** Published formula, media vote, promotional discretion, or mixed — and do we **ship a number**?

## (b) Evidence (cited) + UNKNOWN discipline

### What a title fight is

**House promotions (UFC, PFL, ONE, GLORY, RIZIN, and the catalog’s other eight promotions).** The belt is the promotion’s. A title fight is a bout the promotion designates, usually five rounds (J1 §1.1 UFC 5×5 championship; ONE page: World Championship MMA 5×5, striking 5×3). There is **no** published UFC bylaw that says “the #1 ranked fighter is the mandatory challenger.” UFC.com rankings text (verified 2026-09-06): champion and interim champion sit atop the division and **are not eligible for voting by weight class**; a fighter **can** appear in more than one division. That is a ranking rule, not a mandatory-challenger rule.

**Boxing alphabet (WBA / WBC / IBF / WBO) — not in the 18, contrast only.** These bodies **do not promote**. They rate boxers and **sanction** a title onto a promoter’s card. The Muhammad Ali Boxing Reform Act, 15 U.S.C. § 6307c (verified 2026-09-06): a “sanctioning organization” is one that ranks boxers or sanctions matches; it must file ratings criteria, bylaws, appeals, and a **general sanctioning fee schedule** with the FTC/ABC annually; a top-10 ratings change needs a public explanation. ABC Ratings Criteria (adopted 2000, amended 2002, still posted): ratings “must be based solely on win/loss records, level of competition and activity”; no boxer rated in more than one division; activity floors. **Sense of Congress**, not a private right of action that auto-rewrites WBC ratings.

IBF *Ratings Criterion* (June 2025 PDF, verified 2026-09-06): no boxer rated in more than one division; other orgs’ world champions off the numerical list (unification only); top-15 must compete every 12 months within 6 lb of rated weight; #1/#2 must beat a top-five. **Clause 13: “All ratings criteria are subject to exception by the Ratings Committee.”** So: published criteria, **discretionary exception**. That is `mixed`.

WBC Championship Rules (2009 PDF still circulated; 2015 amendment PDF): a mandatory defence at least yearly; **the No. 1 rated boxer is not necessarily the official mandatory challenger**; designation needs Board of Governors majority. Interim (Rule 1.27 / 3.22): champion temporarily inactive **> 6 months** (medical / legal / cause beyond control); if inactivity estimated **> 1 year**, title vacant; on return, undisputed bout with the interim. Purse-offer split in older WBC text: 70/30 champion/challenger — **confirm current PDF before wiring; do not treat 2009 as 2026 fee law.**

IBF Championship Contest Rules (June 2025 PDF): unification with WBA/WBC/WBO “elite contenders” may take priority over a mandatory; champion boxing another org without approval risks the belt. Rule 17 (interim when a unified/undisputed champion’s mandatory is delayed): #1 vs #2 (or next available); winner becomes mandatory to the unified champion; interim term **not longer than 18 months** subject to committee/president. Champion **misses weight**: title forfeited on the scale; bout may proceed for the vacant title; if the ex-champion wins, title stays vacant. Challenger misses: champion keeps the belt win or lose.

**Ruling on D4:** this is **not** J2’s fourth entry pathway. Who puts the boxer on the mat? A **promoter** (signing). Who pays the boxer? The promoter. Who is paid a sanctioning fee? The alphabet org, from promoter/fighter per that org’s schedule (**exact %: UNKNOWN unless the current FTC filing is in hand**). J2’s three pathways stay. If boxing world titles ever ship, add `entity_type: sanctioning_body` as a **belt overlay**, not a place you sign.

### Interim, in MMA house promotions

UFC practice (secondary + UFC.com ranking text treating “interim champion” as a top position): interim when the undisputed holder is out (injury, dispute, personal). Two top contenders fight; unification on return; or the promotion **elevates** the interim if the holder is stripped/retires. **Published UFC inactivity clock in days: UNKNOWN.** A 2025-02-23 MMA Junkie report of a UFC executive Q&A: two-division simultaneous holds are **case-by-case**, with an activity expectation — not a numbered bylaw. A 2025-02-21 secondary (challenger interview) claimed the promotion would force a vacate-first leap; that **conflicts** with the executive Q&A. **Do not ship either sentence as a rule.** G4’s authored clock is the honest game object.

ONE: house World Championships per discipline × class; interim exists in ONE title history (Wikipedia list of missed-weight/hydration title fights, secondary). **ONE published interim bylaw: UNKNOWN** on the martial-arts page retrieved 2026-09-06.

PFL 2025: World Tournament is a **bracket**, not an alphabet mandatory. Winner is tournament champion; prize **$500,000** (PFL 15 Jan 2025; 2025 World Tournament Rules PDF effective 2025-03-01, already cited in J1 §1.2). That is a season object, not an interim.

GLORY Rules 2026 v2 (PDF retrieved 2026-09-06): title matches 5×3 unless tournament; **titles with a maximum weight can only be won or defended if both are at or under the limit**; defending champion misses → **forfeits the title**; if the challenger wins they are champion; if the champion wins, **title vacant**. Rankings: “GLORY has the **discretion** to determine rankings based on a variety of judging points.” That is `discretionary`, and they **published the discretion**.

### Two-division / undisputed

UFC simultaneous two-division holds have occurred; they are rare and promotional. There is **no** UFC PDF that says “90 days then vacate.” G4’s “defend either inside a data-authored window or the least-recently-defended belt is vacated” is the right **shape** (forced choice, not a free double reign). Boxing “undisputed” = holding WBA+WBC+IBF+WBO in one weight. **Not a catalog object.** Do not invent a four-belt UI.

### Rankings: published vs discretionary (do not reverse-engineer)

| Org | What is published | Formula? | Mode |
|-----|-------------------|----------|------|
| UFC (media panel) | Vote of named outlets; active UFC only; champ/interim not voted in-division; multi-division allowed | **No** | `discretionary` |
| UFC (Meta Rankings, announced 2026-06-22; both still on ufc.com 2026-09-06) | “Mathematical model — not a chatbot.” Who you faced, how you won, when; recency decay; inactivity penalty | **UNKNOWN** (no published table) | `published_criteria` with **UNKNOWN weights** — do not invent them |
| IBF | June 2025 Ratings Criterion PDF | Criteria yes; **exceptions clause** | `mixed` |
| WBC | Ratings committee; #1 ≠ mandatory | **UNKNOWN** points table | `discretionary` (committee) |
| ABC (boxing, Ali Act) | Win/loss, competition, activity guidelines | Guidelines, not a solver | `published_criteria` (floor) |
| GLORY 2026 | Discretion, may count outside fights | **No** | `discretionary` |
| ONE / PFL / RIZIN / Jungle / LUX / ROAD / Kunlun / ARES / URCC / RWS / Karate Combat | Rankings pages or none | **UNKNOWN** | default `discretionary` until a primary |
| IBJJF | Official ranking page: 1st/2nd/3rd only; championship_weight × season_weight (J2 §4.5) | **Published** | `published_criteria` (already J2) |
| IJF / UWW / WT | WRL / Ranking Rule Book / G-grade (J2 §4) | Published with **UNKNOWN** cells as flagged in J2 | federation ranking, not a promotional belt |

**Do not** wire Meta UFC Rankings as a computable sim. The 2026-06-22 UFC release names outcome probability, win type, trajectory, weight-class sensitivity — **not** coefficients.

### Vacate / sit

| Trigger | Published? |
|---------|------------|
| Champion misses contracted title weight | IBF: forfeited on scale. GLORY: forfeited. ONE: stripped / non-title (secondary list + ONE catchweight text). UFC: **CUSTOMARY** strip of the **challenger’s** eligibility; champion miss is case-by-case — **UNKNOWN as a single UFC rule** |
| Inactivity | WBC interim >6 months, vacant >1 year (older championship rules). IBF interim cap 18 months in Rule 17. UFC: **UNKNOWN days** |
| Weight-class move | Game R7 already vacates the belt left behind. Honest for a **move**. Two-division is the **exception** (G4) |
| Failed drug test / DQ | Commission may change the result (`NAC 467.579` NC **may**); belt fate **UNKNOWN** as a universal |

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| A belt | `championships[discipline\|weight_class\|sex] = {holder_id, holder_name}` | **Invented house belt.** One per class. No org-scoped belt (UFC vs PFL lightweight are the same key if they share discipline/class) |
| Title fight | `apply_title_logic` when the opponent is the holder (HANDOFF R4: even a GP bracket bout vs the champion **moves the belt**) | **Invented / too eager.** A Grand Prix fight against a champion should not silently be a title fight |
| Interim | none | **Absent** |
| Unification / undisputed | none | **Absent** (and should stay absent for alphabet) |
| Two-division | G4 assigned: superfight in adjacent class without `weight_move`; window then vacate | **Assigned, ship-state UNKNOWN here.** Live `get_athlete_title` returns the **first** belt (G4 brief) |
| Mandatory #1 | Title-shot **clause** for top-5 (`title_available` / `title_rank`, R6) and request TITLE SHOT for top-3 (`get_division_rankings`) | **Invented** rank floors (5 / 3). Not a UFC mandatory |
| Rankings | Points, P4P, movement (K15 wants ↑↓). R7 carry 0.45 up / 0.55 down | **Invented formula.** UFC is a vote or an unpublished model |
| Alphabet orgs | not in catalog | **Absent** — correct for MVP |
| Vacate on class leave | R7 `vacate_title` → best remaining contender | **Invented successor** (no published “best contender” rule) |

TASK_J3’s line “the game has rankings (R30) and booking (R33), and no theory of a title” is **half-right**: there is a holder, there is no theory (interim, mandatory, belt-on-the-scale, org-scoped belts).

## (d) Minimum change (one concrete recommendation)

**Add `is_title_bout` on the bout and `title_status ∈ {vacant, champion, interim}` on the championship key. `apply_title_logic` runs only if `is_title_bout` and both athletes made the contracted class. Interim is created only by an unavailability flag, and is consumed by a unification bout or an elevation. Do not add alphabet orgs. Do not ship a ranking formula.**

That is the whole of a title-picture sprint. G4’s two-division clock, if not yet landed, stays the two-division rule. Ranking boards keep gameplay points, labelled **gameplay**, not “UFC official.”

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — Brand / belts.** Catalog: text names only; no belt artwork. Real UFC/ONE/GLORY belt **trade dress** is not ours (J1 §4.1).  
**Solution:** Generic championship object. Text: “UFC lightweight championship” as a **string** if the publisher keeps real names; otherwise “S-tier house lightweight.” Do not ship photographed belts.

**Issue 2 — Org-scoped belts.** One global `discipline|class|sex` key means a Jungle Fight win can take “the” lightweight belt.  
**Solution:** Key becomes `org_id|discipline|weight_class|sex` for **promotions**. Federations do not get this object (J2: a win is ranking/selection, not a UFC-style belt).

**Issue 3 — Alphabet temptation.** Boxing undisputed is culturally loud.  
**Solution:** D4. Scenery. If a later boxing mode exists, `sanctioning_body` overlays a **signing** card. Not a fourth pathway, not MVP.

**Issue 4 — Ranking formula temptation (Meta 2026).**  
**Solution:** Store `ranking_mode`. If `published_criteria` and the formula is UNKNOWN, **do not simulate the model**. Keep gameplay points. A “Meta” skin that pretends to be the 2026 UFC solver would be a lie.

**Issue 5 — G4 vs vacate-first rumour.**  
**Solution:** G4’s clock is the mechanic. Do not encode a 2025 interview as a bylaw.

**Issue 6 — GP vs title.** HANDOFF already notes a GP bout against the champion moves the belt.  
**Solution:** `is_title_bout=false` on tournament bouts unless the event record says otherwise. A GP winner may **earn** a later title shot; they do not take the belt in the bracket unless flagged.

---

# Area 2 — The commission layer

## (a) Decisions coming (named as calls)

1. **Call: who licenses a fighter, and for how long.**
2. **Call: what a medical hold is after KO / TKO / cut, and how clearance lifts it.**
3. **Call: who tests for drugs, what a violation costs in time, and what happens to the bout result.**
4. **Call: when a win becomes NC or is overturned, and what the record shows.**
5. **Call: athletic commission vs self-regulating host, for each of the 18.**
6. **Call: does a hold in Nevada bind a card in Saitama?**

## (b) Evidence + UNKNOWN

### Licensing

**Nevada (`NAC 467.012`, LII, verified 2026-09-06).** Written application, identity, drug-testing acknowledgement. Fee: professional boxer / MMA / kickboxer / other unarmed combatant **$50**. Valid for the **remainder of the calendar year** unless limited shorter. This is **per jurisdiction, per calendar year**, not per bout. Bout agreements are a separate filing (`NAC 467.112`–`.117`).

**Nevada physical / debut (NSAC PHYSICAL-2025 form).** Separate medical packet (CBC, RPR, electrolytes, etc.). Pro debut fee also listed **$50** on that form. Exact current lab panel: use the form, do not invent tests.

**California.** CSAC licenses fighters under the Boxing Act (BPC 18600 et seq.). Minimum purse **$200 per round** (BPC 18704, verified 2026-09-06). Time between bouts: CSAC martial-arts manual §515 — **seven days** unless written approval (2020 manual PDF; **confirm current 4 CCR before wiring**). Fighter equipment and costume approval: §513.

**New Jersey.** Boxing TKO: **minimum 30-day** suspension (`N.J.A.C. 13:46-12A.12`). Six consecutive losses / one-year inactivity: exam before reinstatement (`13:46-12B.3`). MMA injuries/results: `13:46-24A.16`–`.17` (legal-maneuver TKO; accidental foul NC before 2 of 3 or 3 of 5 rounds). **MMA-specific KO day table: UNKNOWN** in the sections retrieved; 2026 NJSACB UFC cards issue **event-specific** holds (indefinite + scan, 90/60 KO, 45/30 hard bout) as **practice**, not a published schedule.

**New York 19 NYCRR 208.11.** Combatant KO/TKO/submission with head trauma: **minimum 30 days** no contact **and** neurological clearance; physician may go longer; petition to reduce with proof.

**ABC.** Member commissions honour each other’s **medical and disciplinary** suspensions via the registries (ABC MMA registry criteria page; Ali Act misconduct reciprocity). That is **US/ABC-member**, not Japan/Thailand/Singapore.

**UNKNOWN (do not invent):** California / New Jersey / Texas fighter licence **dollar** fees for 2026; whether a Nevada licence is accepted as-is in California (typically **re-license in the event state**); amateur vs pro licence split outside NSAC’s debut form.

### Medical suspensions after KO / TKO / cut — the gameplay object

**There is no ABC Unified MMA table that says “KO = N days.”** The August 2026 Unified Rules PDF (already J1) defines KO/TKO **results**, not rest periods.

**Nevada `NAC 467.562` (verified 2026-09-06):** a person a physician finds unfit is suspended **until shown fit**. A combatant suspended **30 days for medical protection** shall take an exam as directed (EEG if indicated). That is **fitness**, not a KO schedule.

**Nevada `NAC 467.472` (verified 2026-09-06):** without special permission, MMA: **4 days × number of rounds officially begun** since the last MMA contest. Boxing/kickboxing: 4/7/14/21/30 days by round length. This is a **successive-contest** floor, **orthogonal** to a post-KO hold. A three-round win still needs 12 days in Nevada even with no knockdown.

**Western Australia** (Combat Sports Commission contest rules / RMP guide): consecutive KOs **30 / 60 / 90 days** minimum, physician may lengthen. **NATIONAL / that commission.** Do not copy onto NSAC.

**CSAC practice (2026 event lists, secondary):** a **7-day mandatory** rest appears on almost every fighter; KO/TKO/hard bout add **45 days with 30 no-contact** or similar; fractures **180 days unless cleared**; brutal KO **indefinite pending neuro**. That pattern is **CUSTOMARY CSAC paperwork**, not a numbered 4 CCR table retrieved this pass.

**Clearance:** every jurisdiction retrieved lets a physician **lift or lengthen**. The honest game verb is `clearance`, not `wait_n_days`.

**Cuts:** no published “stitches = N days” table. CSAC lists “60 days unless cleared for laceration.” **UNKNOWN** as a universal.

### Drug testing

| Jurisdiction / org | Who runs it | Violation → time | Bout result |
|--------------------|-------------|------------------|-------------|
| Nevada | Commission may test any time (`NAC 467.570`); promoter pays; WADA *Prohibited List* adopted (`NAC 467.011`); promoter programs may be sanctioned (`NAC 467.584`) | Ineligibility periods exist in `NAC 467.574`–`.578` (prompt admission reductions, second/third violation). **Exact first-violation days: read those sections at wiring; do not invent here** | `NAC 467.579`: Commission **may** change a win/draw to **no contest**; note on the record |
| UFC US cards | UFC Anti-Doping (in-house PI after the USADA era). Stricter than ABC floor (J1 §1.1 UFC page) | **UNKNOWN** as a single UFC number this pass | Commission owns the official result |
| ONE | IDTM/DFSI collect; WADA-accredited lab (ONE martial-arts page, verified 2026-09-06), since Aug 2022 | **UNKNOWN** | **UNKNOWN** house vs host |
| RIZIN | In-house medical/doping desk; random urine; WADA-flavoured description (2024 RIZIN medical briefing, secondary) | **UNKNOWN** | **UNKNOWN** |
| PFL / others on US cards | Event commission + any promoter program | Commission | Commission |

**Do not** name a 1-year / 2-year default.

### Overturned results and No Contest

**ABC Unified MMA (Aug 2026 PDF, J1; restated on commission sites):** accidental foul, bout stopped **before** one-half of scheduled rounds **plus one second** → **No Contest** (or DQ if the foul path says so). **After** that threshold → **technical decision** to the fighter ahead; incomplete rounds **must be scored**. Intentional foul that ends it immediately → DQ. Intentional foul, bout continues, later stoppage → technical decision / technical draw depending on cards.

**Nevada `NAC 467.770`:** will **not** change a decision unless collusion, scorecard compilation error, or misapplication of a rule. Anti-doping NC is the **separate** `467.579` door.

**Record:** NC is a **result**, not a win and not a loss. A later overturn (doping, collusion) **replaces** the result and is annotated (`467.579` “note in the record”).

R38 ships UD/SD/MD. **NC and technical decision are absent.**

### Athletic commission vs self-regulating, mapped to the 18

| org id | HQ (catalog) | Typical event regulator | Kind |
|--------|--------------|-------------------------|------|
| `ufc` | USA | Event-state athletic commission (NSAC, CSAC, NJSACB, Texas, …). **Not** self-sanction on US soil. 2026 White House card: UFC self-regulate with **ABC as third party** (Sports Business Journal 2026-03-19 / 2026-09-06 page) — **exception**, not the default | `athletic_commission` |
| `pfl` | USA | Same | `athletic_commission` |
| `karate_combat` | USA | Same (US cards) | `athletic_commission` |
| `one_championship` | Singapore | House Global Ruleset + **host** overlay. Hydration/weigh-in and IDTM are **house**. Singapore has no US-style state AC for this product | `house_plus_officials` + host |
| `rizin` | Japan | **No** prefectural athletic commission equivalent retrieved. **JMOC** (Japan MMA Officials) is a **private** officials body (CSAC/CAMO-inspired). RIZIN medical department = promotion physicians. ABC holds are **not** automatically binding (2024 NJ-suspended boxer on a RIZIN exhibition — secondary; illustrates the gap) | `house_plus_officials` |
| `glory` | Netherlands | House rules 2026 + “Regulator” in the miss-weight clause. Dutch/host commission when one exists; **UNKNOWN** as a single Dutch MMA/kickboxing statute this pass | `house_plus_officials` + host |
| `jungle_fight` | Brazil | **CABMMA** (J1) | `national_sport_authority` |
| `lux_fight_league` | Mexico | **UNKNOWN** primary. Unified-rules secondary only (J1) | `unknown` |
| `road_fc` | South Korea | **UNKNOWN** primary (KMGAU / similar not retrieved) | `unknown` |
| `kunlun_fight` | China | **UNKNOWN** | `unknown` |
| `ares_fighting_championship` | France | **FMMAF / FFBoxe** (J1 §1.17) | `national_sport_authority` |
| `urcc` | Philippines | **Games and Amusements Board (GAB)** (J1 §1.18) | `national_sport_authority` |
| `rajadamnern_world_series` | Thailand | Rajadamnern Stadium / stadium authority (J1) | `house_plus_officials` / stadium |
| `ibjjf` | USA | Tournament operator; **not** an athletic commission sport in the ABC sense (J2 open_entry) | n/a (J2) |
| `ijf` / `united_world_wrestling` / `world_taekwondo` | — | IF + NF (J2 national_selection) | n/a (J2) |
| `cyprus_mmaf` | Cyprus | **K.O.A.** recognition + IMMAF international (J1 §1.7, J2 §1.4). Pro cards in Cyprus: **UNKNOWN** | amateur NF |

**Reciprocity:** ABC registry is the US/Canada glue. A CSAC hold should block a Nevada booking. It should **not** silently block a RIZIN or RWS booking unless the **host** honours it. That is the self-regulating hole.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Licence | none | **Absent** |
| Fight-day medicals | gate exists (`pre_fight_medicals_test`; camp injury ≥24 → injured, medicals judge on fight day) | **Invented gate**, right **shape** |
| Post-KO / TKO / cut hold | none. A KO on Saturday can be booked next week | **Absent** — this is the hole TASK named |
| Successive-bout rest (`467.472`) | none | **Absent** |
| Drug program | R3 “failed test” = 15% of pull-outs | **Invented cause**, not a test |
| NC / technical decision / overturn | R38: UD/SD/MD only | **Absent** NC |
| Commission vs house | none | **Absent** |
| Cross-border hold | none | **Absent** |

## (d) Minimum change

**After a KO or TKO (and after a doctor-stop for a cut), set `medical_hold=true` on the athlete. `book_fight` refuses while the hold is on. Lift only via a `clearance` action (physician), not via an invented N-day table. Do not author 30/60/90 as ABC.**

Optional, still minimum: honour **ABC-member** holds across US-commission orgs (`ufc`, `pfl`, `karate_combat`). Do not auto-export them onto `rizin` / `one_championship` / `rajadamnern_world_series`.

Nevada `467.472` rest may be a **later** DIRECT overlay on Nevada-tagged cards. It is not the MVP hold.

## (e) Issues + solutions

**Issue 1 — Invented day counts.** The temptation is “KO=60, TKO=30, cut=45.” That is Fightomic-blog customary, not ABC.  
**Solution:** UNKNOWN policy. Clearance is the verb. If a later data file authors CSAC-practice defaults, label `evidence: CUSTOMARY` and never call them Unified Rules.

**Issue 2 — Brand / commission names.** NSAC, CSAC, NJSACB, GAB, JMOC, CABMMA, FMMAF are real.  
**Solution:** J1 §4.1. Text names in research and, if shipped, text-only. No seals, no badges, no named physicians (this desk’s standing rule).

**Issue 3 — White House / federal-land exception.** 2026 UFC card self-regulated with ABC assist.  
**Solution:** `regulator_kind` can be overridden **per event**. Do not rewrite UFC as self-sanctioning.

**Issue 4 — Japan / Thailand / Singapore cards vs ABC registry.**  
**Solution:** D7. Self-regulating hosts do not read the ABC database unless we author that they do. Reciprocity is a **flag**, default off outside ABC-member.

**Issue 5 — NC vs R38.**  
**Solution:** Result enum grows by two (`no_contest`, `technical_decision`). Scoring path already has three cards; the half-rounds-plus-one-second gate is a **clock check**, not a new judge.

**Issue 6 — Unplayed testing career.** A full USADA/PI whereabouts sim is a second mode (J2 §6.2).  
**Solution:** Random in-competition flag + a `violation` object that **may** NC the bout. No out-of-competition RPG.

---

# Area 3 — The weigh-in

## (a) Decisions coming

1. **Call: when the scale happens** relative to the bell (day-before, 24–48h, same-day).
2. **Call: missed-weight penalty** — % of which purse, paid to whom, published vs customary.
3. **Call: bout fate** — fight at catchweight, cancelled, or champion-keeps.
4. **Call: belt fate** on a miss.
5. **Call: who agrees a catchweight.**
6. **Call: rehydration** — discussed, or actually enforced.
7. **Call: health positions** — cite them; **do not** mechanic them (TASK).

## (b) Evidence + UNKNOWN

### Calendar

| Setting | When | Evidence |
|---------|------|----------|
| UFC / typical ABC pro MMA & boxing | **Day before** (often ~30–36 h). Game D2 already: day before; previous Sunday for a Monday bout | UFC weigh-in shows; NAC weigh-in procedure exists (`NAC 467.514`); D2 HANDOFF |
| ONE | Combined hydration + weigh-in **24 to 48 hours before the event** | [ONE Championship martial-arts page](https://www.onefc.com/martial-arts/) verified 2026-09-06 |
| IBF championship | Official weigh-in + **second-day weigh-in 8:00–10:00 on event morning** (waived for heavyweight and unification) | IBF *2nd Day Weigh-In Guidelines* PDF, retrieved 2026-09-06 |
| IBJJF | Same-day, **in the gi** for gi (J2 §1.5) | J2 |
| Amateur / some stadium | Same-day common | **CUSTOMARY**; do not universalise |
| GLORY 2026 | Official weigh-ins; time limit to make weight set by GLORY or the Regulator | GLORY Rules 2026 v2 PDF |

Nevada: after weigh-in, weight loss **> 2 lb not permitted**, and not later than **1 hour** after the initial weigh-in (`NAC 467` weight-loss clause in the chapter index / 467.476 family). **1-hour** window to make weight or be within 1 lb (`NAC 467.522(3)`).

### Missing weight — published vs customary

| Source | Penalty | Paid to | Bout | Belt |
|--------|---------|---------|------|------|
| **Nevada `NAC 467.522`** (verified 2026-09-06) | **25%** of purse, or a **lesser** amount set by the Executive Director and approved by the Commission, **unless the difference is 1 lb or less** | **Opponent** (current text: “must be paid to the opponent”) | Not automatically cancelled by this section | Not in this section |
| **GLORY 2026 §2.01 D** | ≤1 kg: **up to 20%** of fight purse to opponent, GLORY’s discretion. **>1 kg: up to 30%** | Opponent | Continues only with GLORY + opponent + Regulator consent | Titles: both must make; champ miss → title forfeited; champ-win → vacant |
| **ONE page** | “Surrender **a percentage** of his or her purse” | Opponent | Catchweight if both within **105%** of each other’s official hydrated weight | Title misses: stripped / non-title (secondary list; house practice) |
| **IBF championship rules** | Commission time (typically **two hours**) to make weight | — | Champion miss: vacant-title bout possible. Challenger miss: champ keeps win or lose | Forfeited on the scale (champion) |
| **UFC / many US MMA cards** | **20%** often reported; sometimes 30%; sometimes extra pound-for-pound | Opponent, **CUSTOMARY** | Catchweight if opponent agrees; title shot usually off for the misser | Challenger miss: **cannot win the belt** (CUSTOMARY / consistently reported). Champion miss: **UNKNOWN as a single UFC rule** |
| **Game D2** | **20%**; catchweight if within **3%** of limit, else opponent refuses | Fine at settlement | Catchweight or bout off | **No belt rule** |
| **Western Australia** | Miss ≤**5%** of upper limit: may proceed by mutual agreement. **>5%: bout cannot proceed** | — | Hard cancel above 5% | — |

**20% is not ABC Unified text.** It is customary US MMA and the game’s invented default. Nevada’s **published** number is **25% to the opponent**. Do not silently “fix” 20% → 25% as a global: that would mis-label Jungle/ONE/GLORY.

**Who agrees a catchweight:** both athletes, the promoter, and (commission cards) the regulator. ONE adds the **105% hydrated** band. WA adds a **5%** hard stop.

### Rehydration — enforced vs discussed

| Body | Enforced? | What |
|------|-----------|------|
| **ONE** | **Yes** | USG **≤ 1.025**; no weigh-in until hydrated; 3-hour window; catchweight path after | 
| **IBF** | **Yes** (championships except HW / unification) | Second-day cap table (e.g. welter 147 → 160 lb second day — **use the PDF table, do not retype from memory at wiring**) |
| **CSAC 15% fight-day cancel** | Voted Oct 2019 (ESPN; 5–0). Aimed at extreme rehydration. **Whether 4 CCR currently in force: UNKNOWN this pass.** 2026 CSAC **has been publishing fight-night weights** (UFC Sacramento 2026 coverage) — tracking ≠ the 15% cancel |
| **UFC / NSAC day-before** | **No** rehydration cap retrieved | Fighters routinely gain 10–20+ lb overnight (2026 CSAC fight-night weights, secondary) |
| **ACSM 2021 Expert Consensus** | Position, not a commission rule | Weight-category sports; acute making-weight is common; deaths have occurred; recovery advice ~150% of fluid deficit |
| **ISSN 2025 position stand** (open access, *JISSN* 22:2467909, PMC11894756) | Position, not a commission rule | Suitable losses **6.7% / 5.7% / 4.4%** of BM at 72/48/24 h; acute water loss **~2–4%** in last 24 h with supervision; long-term effects of frequent cuts **unknown** (point 16) |
| **CSAC medical advisory (pro MMA physical form)** | **Recommendation** | Do not attempt to lose **more than 10%** of walking weight to compete |

**Contested:** commissions (CSAC, ONE) treat large cuts as a **safety and fairness** problem. ISSN/ACSM describe **how** athletes cut and set **upper bounds they consider suitable**, while stating long-term harm is under-studied. Fighters and promotions treat the day-before window as competitive infrastructure. **This desk does not pick a winner. Do not ship a “safe %” as stamina physics beyond D2’s already-invented night cost.**

### Health picture (not a mechanic)

- **ACSM 2021** (*Curr Sports Med Rep*): consensus on weight-category sports; replaces 1996 wrestling stand; documents fatalities in several combat sports; recovery tables.  
- **ISSN 2025**: 16-point combat-sport stand; point 16 explicitly **unknown** long-term.  
- **ONE**: policy adopted after a 2015 dehydration death (secondary; Wikipedia ONE page). House medical page is the primary for the **test**, not the history.  
- **CSAC**: 10% walking-weight **recommendation** on the physical; 15% fight-day proposal/vote 2019.  
- **ABC Unified MMA**: no weight-cut medical chapter in the scoring/fouls PDF.

Where evidence is contested: whether day-before + ad-libitum rehydration is “the sport” or “sanctioned cheating” (CSAC executive language, 2019). Both sentences are **positions**. The game already has a night-cost (invented). Do not add a morality slider.

## (c) What the game does today

D2 is **live** (`WeightCut.gd`, `weight_classes.json` v2). TASK_J3’s “the game has weight classes and no weigh-in” is **stale**. Honest inventory:

| D2 object | Value | Honesty |
|-----------|-------|---------|
| Calendar | Day before (Sunday for Monday) | **Honest** for UFC-shaped pro |
| Allowance | MMA 0.45 kg; boxing 0 | **Honest-ish** vs common 1 lb non-title |
| Walk | 5–10% over limit | **Invented** band |
| Diet | none / moderate 0.6%/wk / aggressive 1.1%/wk | **Invented** |
| Night cost | 4 stamina + 1 chin per % past 3, caps 20 / 5 | **Invented** |
| Miss fine | **20%** | **CUSTOMARY**, not Nevada 25%, not ONE’s unpublished % |
| Catchweight window | **3%** of limit, else opponent refuses | **Invented** (ONE is 105% of each other; WA is 5% of class) |
| Emergency cut | +3% at 6%/point hospital chance | **Invented** |
| Withdraw | −5 reputation | **Invented** |
| AI opponent | Always makes weight | **Lie** |
| Rehydration cap | none | **Honest for UFC**; **missing for ONE/IBF** |
| Same-day | none | **Honest for UFC default** |
| **Belt on a miss** | **none** | **The hole** |
| Health positions | none (correct — not a mechanic) | — |

HANDOFF honest notes already: no rehydration clause; no same-day; walking weight static; a standard cut **always** makes weight because max cut 11% and walk ≤10%.

## (d) Minimum change

**Keep D2’s day-before calendar and the 20% fine. Add one rule: if `is_title_bout` and either athlete missed the contracted class, the belt does not change hands under the GLORY/IBF shape (challenger miss → champion keeps; champion miss → title vacant if they still fight and win, challenger may win vacant). Do not retune 20%, 3%, or night-cost in this sprint. Do not add a health mechanic.**

ONE hydration (USG 1.025, 24–48 h, 105%) is an **org overlay** for `one_championship`, not a global rewrite.

## (e) Issues + solutions

**Issue 1 — Stale task vs live D2.** Building a second weigh-in would duplicate D2.  
**Solution:** Honesty pass, not a new system. J2 D6 discipline.

**Issue 2 — 20% vs 25%.**  
**Solution:** Keep 20% as `CUSTOMARY` default. Nevada-tagged cards may overlay `NAC 467.522` 25% to opponent. ONE: do **not** invent the missing percentage; if the bout is ONE and the page still says “a percentage,” store `fine_unknown=1` or keep 20% labelled **INHERITED customary, not ONE**.

**Issue 3 — CSAC 15%.** Tempting rehydration mechanic.  
**Solution:** UNKNOWN current force. Tracking fight-night weight ≠ cancelling the bout. Do not ship.

**Issue 4 — Health → stamina.** ISSN 4.4% last-24h vs D2’s 11% water cut.  
**Solution:** TASK forbids a mechanic recommendation. Cite both. Leave D2’s invented night-cost until a later honesty pass that **labels** it invented.

**Issue 5 — Brand / medical orgs.** ACSM, ISSN, CSAC, ONE Medical.  
**Solution:** Cite in research. Do not ship ACSM/ISSN logos. Do not name the physicians on ONE’s page as data (standing rule).

**Issue 6 — IBJJF / federations.** Gi scale, IJF random weigh-in, UWW 2 kg Ranking Series tolerance (J2) are **other sports**.  
**Solution:** D2 is a promotion-MMA object. Federation weigh-ins stay on J2’s calendar nodes. Do not force day-before onto IBJJF.

---

# Area 4 — Fighter pay past the purse (the 13 promotions)

J2 did the five non-promotions (money-flow table §2.6). This is the other half. The live purse is **one number plus a win bonus**, scaled by letter tier. Reality is show / win / bonuses / (sometimes) PPV / (sometimes) a kit cheque.

## (a) Decisions coming

1. **Call: is the purse one number or show + win?**
2. **Call: fight-night bonuses — which orgs, what size, authored by whom?**
3. **Call: PPV points — store a %, or refuse?**
4. **Call: who controls what a fighter wears, and what that replaced.**
5. **Call: what a mid-card year is, versus `get_promotion_bout_offer` / `_promotion_purse_multiplier`.**

## (b) Evidence + UNKNOWN

### Show / win — disclosed by law vs reported

**Disclosed (commission):** California still releases fighter purses after events. Nevada **stopped** public purse lists (NRS 467.1005 confidentiality; ~2020). So: a Sacramento UFC/PFL card is a **primary-adjacent** window (CSAC → journalists). A Las Vegas UFC 300 is **not**.

**What CSAC lists:** contracted **show** and, when present, **win**. It does **not** list PPV points, locker-room bonuses, or sponsorship. UFC 311 (Jan 2025) coverage already warned the CSAC sheet can show a champion **below** a supporting fighter — because the champion’s real money is **off the sheet**. Treat CSAC as **floor disclosed**, not earnings.

**California BPC 18824** (verified 2026-09-06): promoter files, within 72 hours, gross receipts (capped in statute) and broadcast-rights price, plus a 5% admission fee (capped) and a broadcast fee band. This is a **tax on the promoter**, not a fighter PPV statement.

**California BPC 18704:** minimum **$200 per round** for a licensed professional fighter.

**Show/win structure (CUSTOMARY US MMA, visible on CSAC sheets 2025–2026):** many contracts are **equal show/win** (e.g. $12,000 / $12,000). Some are **flat** (no win bonus). Debut undercards on a 2026 UFC California card cluster around **$12,000–$24,000** disclosed total if they win; veterans on the same sheet run to mid-six figures disclosed. **Do not** turn one card into a wage table. **Do not** name the athletes as data.

**PFL San Diego 2026 (CSAC, secondary):** headliner disclosed **$100,000 flat**; opposite **$10,000**; another main-card name **$50k/$50k**. Tournament **winner** prize is separate: **$500,000** (PFL official 2025-01-15; Rules PDF 2025-03-01). 2018–2024 season $1,000,000 is **historical** (J1).

### Fight-night bonuses — published vs authored

| Promotion | Published? | Size | Notes |
|-----------|------------|------|-------|
| **UFC** | Promotion announces per card; not a commission rule | **$50,000** FOTN (both) + two POTN until Jan 2026. From **UFC 324** (Paramount era): **$100,000** those awards, plus **$25,000** to any KO/sub not already awarded (Sports Business Journal 2026-01-24; Wikipedia bonus list citing the same). One-off White House / numbered cards have gone higher — **event overlay, not the default** | Discretionary who gets them |
| **PFL** | Tournament prize **$500,000** official. Fight-night POTN: **UNKNOWN** as a standing published figure | Do not invent $50k PFL bonuses | Season vs tournament already J1 |
| **ONE** | **UNKNOWN** as a published fight-night bonus table this pass | — | Salaries historically reported as **salaried** in journalism — **reported, not disclosed** |
| **GLORY** | Tournament purses sometimes announced (e.g. a 2026 GP **$100,000** to the winner — **secondary**). House KO bonuses: **UNKNOWN** standing table. Rules allow fines up to 100% of purse | Use event packet or UNKNOWN | Rankings discretionary |
| **RIZIN** | **UNKNOWN** published bonus table | — | Miss-weight house overlay (points / NC) is **policy**, not pay |
| Jungle / LUX / ROAD / Kunlun / ARES / URCC / RWS / Karate Combat | **UNKNOWN** | **UNKNOWN** | Do not inherit UFC $100k |

**Game R6:** POTN = fastest finish; FOTN = longest distance bout; **$2,500** × (1+hype); world cards only. That is **invented twice**: size, and the “longest fight = FOTN” rule (UFC FOTN is discretionary excitement, not duration).

### PPV participation — known vs reported

| Claim | Status |
|-------|--------|
| Some UFC main-event contracts include PPV “points” | **Reported** endlessly; **no** primary UFC contract in this pass |
| A percentage of PPV buys | **UNKNOWN** |
| CSAC / BPC 18824 discloses PPV points to the public | **False.** Gate + broadcast **rights price** to the commission, not fighter points |
| Nevada public purse = full pay | **False** since confidentiality |
| ONE / RIZIN / GLORY PPV points | **UNKNOWN**; several are not PPV businesses in the US sense |

**Ruling:** the game must **not** store a PPV %. A later `ppv_participation: UNKNOWN` flag on S-tier main events is honest. A `0.01 * buys` formula is a lie.

### Outfitting / sponsorship — what `:224` should branch on

**UFC (DIRECT enough for a policy flag, numbers secondary):** exclusive kit since Reebok (2015) then **Venum** (2021), extended **through 2029** (UFC / SBJ 2024-03-07; still current 2026-09-06). Fighters **cannot** wear personal sponsors in the cage or in official fight-week kit. Replacement pay = **Promotional Guidelines Compliance** (formerly Athlete Outfitting Policy), funded from the kit deal, **tiered by UFC bout count**, plus extra for champion / challenger.

2026 MMA Junkie (UFC Paris, 2026-09-06) restates the live tier band:

| UFC appearances (incl. some Zuffa-era WEC/Strikeforce) | Compliance pay / appearance |
|----------------------------------------------------------|-----------------------------|
| 1–3 | $4,000 |
| 4–5 | $4,500 |
| 6–10 | $6,000 |
| 11–15 | $11,000 |
| 16–20 | $16,000 |
| 21+ | $21,000 |
| Title challenger | $32,000 |
| Champion | $42,000 |

**Primary UFC PDF of that table: not retrieved.** Treat as **SECONDARY-CONFIRMED 2026 journalism repeating UFC’s own tier sheet.** Do not invent a different ladder. Merchandise royalties “20–30%” (same articles) = **UNKNOWN as a contract clause** until a primary.

**What it replaced:** pre-2015, fighters sold cage-side patches (sometimes six figures for stars — **reported**). The kit deal **banned** those logos and substituted a **flat** cheque. Many veterans called the substitution a pay cut. That is the **policy** `Sponsorship.gd:224` needs: `house_kit` vs `fighter_sponsors`.

**Other 12 promotions:** no primary 2026 kit-exclusivity PDF retrieved. Default **`fighter_sponsors`**. ONE/GLORY/RIZIN may have house marks on trunks in practice — **UNKNOWN as a ban on third-party patches**. Do not copy Venum onto Jungle Fight.

**J2 already:** `:224` must not sell UFC fight-night sponsors against an IJF calendar node. This study adds the **promotion** branch: UFC-shaped `house_kit` does not take a Monster patch; a LUX card might.

### Mid-card year vs what the game pays

**Reality (bounded, not a year total — J2 §6.3):**

- A UFC mid-carder typically fights **2–3 times a year** (reported cadence, **not** a UFC bylaw).  
- CSAC snapshots: undercard disclosed **~$12k–$24k** to win a Fight Night; plus compliance **$4k–$11k**; plus a **chance** of $100k POTN (from 2026) or $25k finish. **No** disclosed PPV.  
- A year is **those cards**, not 13 weekly `promo|` bouts.  
- PFL: show/win on CSAC **plus** a $500k if they win the tournament. A first-round loser has the show/win only.  
- ONE: **UNKNOWN** salary grid.  
- GLORY: event/tournament packets; **UNKNOWN** annual.  
- Regional 9 (Jungle, LUX, ROAD, Kunlun, ARES, URCC, RWS, KC, and the rest of the 13 not named above): **UNKNOWN**. Do not author a year total.

**Game today (HANDOFF `fe8052a`, J2):**

- Signed fighter: weekly slate of **`PROMOTION_BOUTS_PER_CYCLE` (3)** offers.  
- `_promotion_purse_multiplier`: **S×4 / A×2.5 / B×1.6 / C×1.2 / D×1** (authored simulation).  
- Featured-tier win at ×1.2 verified **+6720** (HANDOFF).  
- Grand Prix base **800 / 1,800 / 4,000** by tier; round purse ×1 / ×1.5 / ×3; champion bonus 2× base.  
- R6 awards **$2,500** × hype.  
- Ambitions “Financial Security” = **$50k** own career purses.  
- Market salary (retention): `250 + rating×22` (+fame/4).

The **shape** error is cadence: three promotional bouts **per cycle** (read: a short window, not a year) vs two or three **per year** at UFC. The **number** error is the multiplier applied to federations (J2 D2) and the invented $2,500 bonus. The **honesty** error is treating CSAC-undisclosed PPV as zero **and** as a modelled %. Both are wrong; **omit PPV**.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Show money | `get_promotion_bout_offer` purse (`:5492`) | **Invented** size; **honest shape** (org pays fighter) for the 13 |
| Win bonus | Yes, same function | **Honest shape**; equal-to-show is not enforced |
| Tier multiplier | `:5483` S×4 … D×1 | **Invented** |
| Cadence | 3-bout slate per cycle | **Invented / too dense** vs a real UFC year |
| Fight-night bonus | R6 $2,500, duration/fastest rules | **Invented** |
| Gate points | R6 formula 15k/40k/120k/200k | **Invented** (honest as a **clause**, not as ticketing) |
| PPV | none | **Honest omission** (UNKNOWN) |
| Kit / compliance pay | none | **Absent** |
| `Sponsorship.gd:224` | sees `entity_type`, no branch | **Absent branch** (J2 + this) |
| Federations paid as UFC | still (J2) | **Lie** — R40 / J2 D6, not this sprint |

## (d) Minimum change

**Do not retune `_promotion_purse_multiplier`. Split nothing that is not already split. (1) Branch `Sponsorship.gd:224` on `outfitting_policy`: `ufc` → `house_kit` (no fight-night patch income; optional compliance cheque **only** if the Venum-tier table is authored from a cited UFC/journalism sheet); all other promotions → `fighter_sponsors`. (2) Tag R6 $2,500 as `evidence: invented`. (3) Never emit a PPV line.**

Cadence (3 bouts/cycle vs 2–3/year) is a later economy pass, not this minimum. J2 D6 still gates federations off this function entirely.

## (e) Issues + solutions

**Issue 1 — CSAC sheet as “what fighters make.”**  
**Solution:** `money_evidence: DISCLOSED_COMMISSION | REPORTED | UNKNOWN | INVENTED`. CSAC show/win = disclosed floor. PPV = UNKNOWN. R6 = invented.

**Issue 2 — Copying UFC $100k bonuses onto URCC.**  
**Solution:** Bonus table is **per org**. Default empty. UFC authored 2026 values only on `ufc` events, labelled promotion-authored.

**Issue 3 — Venum tier table has no UFC.com PDF in this pass.**  
**Solution:** May author as `SECONDARY_CONFIRMED` with the 2026-09-06 MMA Junkie URL, or leave `UNKNOWN` and **omit the cheque** (J2 §6.3: no invented numeric default). Prefer omit until a UFC primary, **except** the **policy** branch (`house_kit`) which does not need the dollar table.

**Issue 4 — Brand / kit.** Venum, Reebok, UFC kits are trade dress.  
**Solution:** J1 §4.1. Text policy, no kit art. “House kit” as a flag, not a photographed short.

**Issue 5 — Mid-card year total.**  
**Solution:** J2 §6.3. Do not author a year total. Author line items. Tests: no invented PPV %; no federation purse (J2 P1).

**Issue 6 — Unplayed pay-sim.** A full PPV-buy / Paramount-split career is a second mode.  
**Solution:** J2 §6.2. Show, win, optional bonus, optional kit cheque. Stop.

---

# Priority ruling

**Order, next twelve months:**

| Rank | Area | Research or build? | Wait a year? | Scenery? |
|------|------|--------------------|--------------|----------|
| **1** | **Commission — medical hold after KO/TKO** | **Build** the minimum (D16 / area 2(d)) | No | No |
| **2** | **Championship picture — title-bout flag + interim + belt-on-the-scale** | **Build** the minimum (area 1(d)); **research** later: org-scoped keys, G4 if unshipped | No | Alphabet pathway = **scenery** |
| **3** | **Weigh-in honesty** | **Build** belt fate only. Do not rebuild D2 | Research on ONE overlay / CSAC 15% can wait | Health positions = **scenery as mechanics** (cite only) |
| **4** | **Pay past the purse** | **Build** `Sponsorship.gd:224` outfitting branch (cheap, unblocks J2 P12). **Wait a year** on PPV, Venum dollar table, cadence retune, R6 $100k | Yes, except the branch | **PPV participation = scenery** (UNKNOWN) |

### Defend

**1 beats 2.** TASK said medical suspensions are the most gameplay-relevant object in the study. That survives contact with the code: D2, camp, and booking all assume the body is available next week. A KO on Saturday and a booking on Monday is the lie a player **feels**. Rankings and belts already exist as fantasy objects; a title-bout flag is a correctness fix, not a missing verb. A medical hold **is** a missing verb. The camp system (D1) currently has no reason to exist as recovery if the commission layer never sits anyone down.

**2 beats 3.** Titles are the career (ambitions: Local Champion / World Title). `apply_title_logic` already moves a belt when you merely share a cage with the holder — including a Grand Prix. Interim is a real published object (WBC, IBF, UFC practice) with **zero** game state. That is a theory hole, not a missing animation. Weigh-in, contrary to the task brief, **already shipped** (D2). Its 20% fine is even in the customary band. The remaining player-visible lie is **belt fate**, which is a one-rule patch **on top of** D1’s title flag — hence 2 then 3, not 3 then 2.

**3 beats 4.** D2’s invented night-cost and 3% catchweight are wrong in the way **simulation numbers** are wrong. Players already see a WEIGH-IN on the calendar. Pay past the purse is wrong in the way **spreadsheets** are wrong: the live game already pays a purse and a win bonus, which is the real US MMA **shape**. PPV is UNKNOWN; inventing it would be worse than omitting it. R6’s $2,500 is small and invented; replacing it with UFC’s $100,000 as a global would be a bigger lie for the other twelve promotions.

**Why pay waits a year (except `:224`).** J2 D6 / R40 still has to **stop paying federations**. That is a bigger money lie than “mid-card isn’t on PPV points.” Cadence (3 bouts a cycle vs 2–3 a year) is an economy retune that will fight Retention, Ambitions ($50k), and the slate. Do it after R40, not as a fifth economy. The outfitting branch is the exception because the hook already exists and J2 already demanded a federation branch on the same line.

### What is scenery (as plainly as J2 §5.1)

- **Boxing alphabet as a pathway.** Real, loud, Ali-Act-regulated — and **not in the catalog**. A fourth `entity_type` without WBA/WBC/IBF/WBO orgs is empty. A full four-belt undisputed sim is the unplayed-mode trap. **Show nothing. Build nothing.** If boxing house titles ever ship (UBO / Zuffa-shaped), they are J2 **signing** plus D1 house belts.  
- **PPV points.** Real in some contracts; **UNKNOWN** as numbers; undisclosed in the jurisdictions that matter. Storing 0 is a lie; storing 1% is a lie. **Omit.**  
- **Health-position mechanics.** ACSM/ISSN are real and contested. TASK forbade a mechanic. **Cite, do not code.**  
- **Olympic IF careers.** Already scenery (J2 §5.1). Not reopened.  
- **Full PI/USADA whereabouts.** A testing career. J2 §6.2. Random in-competition + possible NC is enough.

**No fifth area outranks these four.** The closest miss — org-scoped belts vs one global lightweight crown — is a **sub-call of area 1**, not a fifth study.

---

## Test assertions (contracts for a later PR — not written this pass)

| ID | Assertion |
|----|-----------|
| **Q1** | `apply_title_logic` does not move a belt unless `is_title_bout` and both made contracted weight. |
| **Q2** | A Grand Prix bout against a champion does **not** set `is_title_bout` by default. |
| **Q3** | `title_status=interim` is consumed by unification or elevation; it is not a second keepable belt. |
| **Q4** | No ranking function claims to implement Meta UFC Rankings coefficients. |
| **Q5** | `book_fight` refuses `medical_hold=true`. |
| **Q6** | No default `ko_days=60` (or any invented KO table) exists in data without `evidence`. |
| **Q7** | ABC-member hold blocks `ufc`/`pfl`/`karate_combat` bookings; it does **not** automatically block `rizin`. |
| **Q8** | Accidental-foul stop before half scheduled rounds + 1s → `no_contest`. After → `technical_decision` from R38 cards. |
| **Q9** | Title miss: belt does not go to a misser. Champion miss + win → vacant (GLORY/IBF shape). |
| **Q10** | `Sponsorship` templates: `outfitting_policy=house_kit` cannot attach a fighter patch on fight week. |
| **Q11** | No bout record contains a `ppv_percent` number. |
| **Q12** | No test fixture uses a real official’s, athlete’s, or executive’s name as data. |
| **Q13** | J2 P1–P3 still hold (federations: no purse, no signing). |

---

## Source list (live verification 2026-09-06)

**Primary / official (preferred):**

- `real_organizations.json` (`snapshot_date` 2026-09-01)  
- J1 — `J1_ORGANIZATION_RULES_AND_JUDGES.md` (ABC Unified MMA 8.2026, org map, §4.1 brand)  
- J2 — `J2_THE_FEDERATION_PATHWAY.md` (pathways, §2.6 money-flow, §5.1 scenery, §6.2 unplayed-mode)  
- ABC Unified Rules index: https://www.abcboxing.com/unified-rules/  
- ABC Unified Rules of MMA (Aug 2026 PDF): https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf  
- ABC Ratings Criteria: https://www.abcboxing.com/abc-ratings-criteria/  
- 15 U.S.C. § 6307c (Ali Act, sanctioning organizations): https://www.law.cornell.edu/uscode/text/15/6307c  
- Nevada NAC 467 (chapter, rev. 4/13/2026): https://www.leg.state.nv.us/nac/NAC-467.html  
- NAC 467.012 (licence $50, calendar year): https://www.law.cornell.edu/regulations/nevada/NAC-467-012  
- NAC 467.472 (successive-bout rest): https://www.law.cornell.edu/regulations/nevada/NAC-467-472  
- NAC 467.522 (25% weight forfeit to opponent): https://www.law.cornell.edu/regulations/nevada/NAC-467-522  
- NAC 467.562 (medical suspension until fit): https://www.law.cornell.edu/regulations/nevada/NAC-467-562  
- NAC 467.579 (doping → possible NC): https://www.law.cornell.edu/regulations/nevada/NAC-467-579  
- NAC 467.770 (when a decision may be changed): https://www.law.cornell.edu/regulations/nevada/NAC-467-770  
- NSAC medical/physical packet 2025: https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/PHYSICAL-2025_W-INSTR.pdf  
- N.J.A.C. 13:46-12A.12 (boxing TKO 30 days): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-12A-12  
- N.J.A.C. 13:46-24A.16 (MMA injuries / NC threshold): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-24A-16  
- 19 NYCRR 208.11 (NY KO/TKO 30 days + neuro): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-208.11  
- California BPC 18704 ($200/round minimum): https://california.public.law/codes/business_and_professions_code_section_18704  
- California BPC 18824 (promoter report / fees): https://california.public.law/codes/business_and_professions_code_section_18824  
- CSAC pro MMA physical (10% walking-weight **recommendation**): https://www.dca.ca.gov/csac/forms_pubs/forms/mma_pro_physical.pdf  
- UFC rankings (media + Meta copy): https://www.ufc.com/rankings  
- UFC / Meta rankings announcement: https://www.ufc.com/news/ufc-and-meta-unveil-meta-ufc-rankings  
- ONE martial arts / hydration / anti-doping / title rounds: https://www.onefc.com/martial-arts/  
- PFL 2025 World Tournament announcement: https://pflmma.com/news/pfl-announces-2025-world-tournament  
- PFL 2025 World Tournament Rules PDF (3 Mar 2025): https://pflmma-prod.s3.us-east-1.amazonaws.com/assets/rules/2025_PFL_World_Tournament_Rules_and_Regulations_as_of_3_1_2025.pdf  
- IBF Championship Contest Rules (June 2025): https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf  
- IBF Ratings Criterion (June 2025): https://www.ibf-usba-boxing.com/wp-content/uploads/RatingsCriteriawithJune2025Amendment.pdf  
- IBF second-day weigh-in guidelines: https://www.ibf-usba-boxing.com/wp-content/uploads/2nd-Day-Weigh-In-Guidlines-Updated-1.pdf  
- WBC Championship Rules (2009 PDF, interim 1.27): https://www.wbcboxing.com/downloads/NEW_RULES_AND_REGULATIONS_WEB_FINAL_2009.pdf  
- GLORY Rules 2026 v2 (miss weight / titles / rankings discretion): https://glory.pinkyellow.network/assets/rules/glory-rules-2026-v2.pdf  
- ISSN 2025 position stand (PMC): https://pmc.ncbi.nlm.nih.gov/articles/PMC11894756/  
- ACSM 2021 Expert Consensus (weight-category sports): https://journals.lww.com/acsm-csmr/fulltext/2021/04000/acsm_expert_consensus_statement_on_weight_loss_in.7.aspx  
- WA Combat Sports missed-weight 5%: https://www.cits.wa.gov.au/department/publications/publication/weight-classes-and-missed-weight-policy  
- WA consecutive-KO 30/60/90: https://www.dlgsc.wa.gov.au/department/publications/publication/role-of-the-medical-practitioner-in-combat-sports  

**Secondary (labelled in body):**

- Sports Business Journal 2026-01-24 (UFC bonuses $100k / $25k finish)  
- Sports Business Journal 2026-03-19 (UFC White House self-regulate + ABC)  
- MMA Junkie 2026-09-06 (UFC Promotional Guidelines Compliance tiers)  
- MMA Junkie / MMA Fighting 2026 CSAC purse and medical-suspension lists (disclosed floors; **not** year totals)  
- ESPN 2019-10-15 (CSAC 15% fight-day vote)  
- MMA Junkie 2025-02-23 (UFC two-division Q&A, case-by-case)  
- Wikipedia *List of UFC bonus award recipients* (bonus history; not a bylaw)  
- JMOC explainers (private officials body, not a state commission)

**Not retrieved / do not fake:** current 4 CCR text of a CSAC 15% fight-day cancel; Nevada first-violation anti-doping **day count** (read `NAC 467.574`–`.578` at wiring); ONE miss-weight **percentage**; UFC PPV point %; Venum contract primary PDF; Jungle/LUX/ROAD/Kunlun/ARES/URCC/RWS/Karate Combat bonus or purse tables; KMGAU / Mexican commission primary; Cyprus pro-card rules; Meta UFC Rankings coefficients.

---

*End of J3. Cut from the Decisions page and from the priority ruling. R40 remains J2 D6 (stop paying federations). This study does not reopen it.*
