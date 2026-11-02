# J4 — The Desk and the Cut: Manager, Gym, and Where the Purse Stops

**Desk:** John (research)  
**Date:** 2026-09-06  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design. No second career mode (J2 §6.2). No manager-simulator.  
**Local snapshot used:** `real_organizations.json` (`snapshot_date` 2026-09-01); `J2_THE_FEDERATION_PATHWAY.md`; `J3_THE_DECISION_QUEUE.md`; `GameState.gd.excerpt.txt` (settlement around `:10200`); `FightContract.gd.excerpt.txt`; `BodyReadiness.gd.excerpt.txt`; `Sponsorship.gd.excerpt.txt`; `body_readiness_rules.json`. Line numbers for `GameState.gd:3385` / `:3815` (medical-hold accessor / refusal) are from TASK_J4; those spans are **not** in this workspace excerpt.

**Cite, do not re-litigate:** J1 (18 orgs, UNKNOWN policy, §4.1 brand). J2 (three **entry/money** pathways, money-flow table §2.6, D5 amateur→pro door, D6 / R40, §5.1 scenery, §6.2 unplayed-mode). J3 (Decisions D1–D16, Areas 1–3, D13/D14/D15, priority ruling). **Do not reopen R40 or J3 Areas 1–3.** `vacate_title`, rankings, and the title-bout flag stand as J3.

**UNKNOWN policy (same as J1/J2/J3):** a fee, a period, a percentage, a cap, or a formula that is not in a primary statute, regulation, commission form, or an organization’s own published page is **UNKNOWN**. Never invent one. Inherited ABC / commission / promotional practice is **INHERITED** or **CUSTOMARY**, not that body’s published rule. National overlays are **NATIONAL**. No real managers’, officials’, athletes’, or executives’ names as data.

**No fifth area.** After the four, a playable manager-agency career or a second-as-playable-mode is **scenery**, not a fifth research track. See E9 and the priority ruling.

---

## Corrections (cite once; do not restate J3 Area 2)

J3 was written without `GameState.gd`, `Sponsorship.gd`, and `WorldPopulation.gd` in that workspace. Two of its “absent” calls are wrong. The corrections make this study’s priority ruling **smaller**, not bigger.

1. **A post-KO medical hold already EXISTS.** `BodyReadiness.gd:34-43` persists `medical_hold_until_week` and `medical_hold_reason` on every athlete. `BodyReadiness.evaluate_competition_clearance()` (`:118`) emits a `medical_hold_active` refusal with `until_week`. TASK_J4: `GameState.gd:3385` is the accessor and `:3815` handles the refusal; `ManagementOverview.gd` and `ProfileRevampPanel.gd` already show it. `body_readiness_rules.json` authors `medical_hold_weeks` (**1** after decision, **4** after stoppage-nonloss, **8** after stoppage-loss). Those week counts are **invented durations** — exactly what J3 **D6** forbade as ABC. **Do not add a hold.** The open question is **what lifts one** (the clearance, and who pays it) — Area 3 / E12.
2. **`vacate_title`, rankings, and the title flag stand as J3.** Area 1 of J3 is untouched.

Neither correction reopens J3. The rest of this pack does not restate J3 Area 2.

---

## Why this exists

J2 answered *who puts you on the mat and who pays whom* (org → fighter). J3 answered *what we have to rule on next* and put pay-past-the-purse fourth, because inventing PPV points is worse than omitting them.

None of the three studies looked at **the desk the player is sitting at.** The game is a gym. The player signs athletes, pays coaches, and books fights — and when a bout settles, `GameState.gd:10200` does this:

```gdscript
gym["cash"] = int(gym.get("cash", 0)) + purse + win_bonus + performance_bonus + gate_share - expenses
```

**The gym banks one hundred percent of the fighter’s purse.** The athlete, whose name is on the contract and whose face took the damage, receives nothing as cash. `athlete["career_earnings"]` (`:10204`) is incremented by the same purse for Ambitions, but there is no fighter cash account and no `gym_cut` / `manager_cut` / `purse_share` anywhere in the settlement path. `FightContract.settlement_for` (`:215`–`:233`) computes a `net` and still hands it to the gym.

This is not a balance number that is slightly wrong. It is the **wrong party being paid**, and it is the player’s own role, so it outranks a fifth org-side system.

J2 §2.6 stopped at org → fighter. This study extends that table **one hop down**: promoter → **contestant named on the bout form** → (optional, capped) licensed manager. The gym is not on the bout form unless it is that manager.

---

## Decisions page (operator calls)

This page is what the next research/build cuts from. One recommendation, one line why. Numbered **E1–E18** so nothing collides with J3 D1–D16.

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| **E1** | Who is the contracted party on a professional bout? | The **athlete (contestant)**. The promoter pays the contestant named on the commission bout-agreement form. The gym is not the payee unless it is also the filed manager, in which case it takes a **share of the contestant’s purse**, not the purse. | Nevada Official Bout Agreement is Promoter ↔ Contestant; `NAC 467.112` / `NAC 467.137(1)`: combatant paid in full on the bout agreement. ABC model bout contract: Promoter pays Boxer. |
| **E2** | Manager percentage — statutory cap vs CUSTOMARY | Store a **cap**, never a default %. NV: **33 1/3%** of ring earnings (`NAC 467.102(6)`). CA boxing rules: **33 1/3%** of gross ring earnings (`4 CCR 221(b)`). NJ boxing: **33 1/3%** (`N.J.A.C. 13:46-6.4`). NY: combatant must actually receive **≥ 50%** of ring earnings after authorized deductions (`19 NYCRR 209.12`) — a **floor for the fighter**, not a 33% manager cap. Do **not** author 10%, 15%, 20%, or 33% as the game’s manager take. | Caps are published. The customary MMA “10–20%” is journalism, not a rule. Inventing a default % is the 2am decision this desk exists to stop. |
| **E3** | Gym cut vs manager | They are **different things**. A gym taking **10% or more of the gross purse** **is** a manager under NV (`NAC 467.0028` / `NRS 467.01037`), CA (`BPC 18628(c)`), and NJ (`N.J.A.C. 13:46-1.1`) definitions, and must be licensed as one. Monthly dues / training fees are **private contract**, unpublished. Do **not** add `gym_cut` as a second purse tax. | No commission publishes a gym-of-purse table. The 10% definition is the honest tripwire. |
| **E4** | Who pays the corner (cutman / seconds / coaches) | **Fighter / manager expense**, not a promoter statutory obligation, except that a promoter may cover travel/lodging as a bout-agreement term. NV: manager may work as second **without** a second’s licence (`NAC 467.057`). CA: same (`4 CCR 215`). NJ: manager **may not** work as second unless licensed as one (`N.J.A.C. 13:46-6.2`). NY: manager may second **their** combatant; needs a second licence for anyone else (`19 NYCRR 207.9`). | No retrieved statute says the promoter must pay the cutman. `FightContract` already negotiates travel/accommodation coverage. |
| **E5** | What comes out of a purse before anyone is paid | Split **statutory** vs **CUSTOMARY**. Statutory: manager share **only if** the combatant approves and a valid management contract is on file (`NAC 467.137(3)`); promoter may withhold **≤ 10%** of purse for the combatant’s expenses, reconciled in 5 working days (`NAC 467.142(4)`); CA deductions only if **itemized on the bout contract** (`4 CCR 230(c)`). Promoter **licence taxes** (NV `NRS 467.107` **8% of gate**; CA `BPC 18824` 5% admissions, already J3 D14) are **promoter-side**, not a fighter deduction. Drug-test collection: NV promoter pays (`NRS 467.107(4)` credit; NSAC promoter checklist). Event medical insurance: **promoter** (E11). Licence fees: each licensee pays their own (E7). **Do not** skim commission/drug/insurance off the fighter as a silent global. | The game already deducts uncovered travel (`FightContract:220-224`). It must not also invent a “commission cut.” |
| **E6** | Ali Act 15 U.S.C. § 6308 — does it touch the catalog? | **No.** § 6308 is **boxing-only**. `15 U.S.C. § 6301(8)` defines a “professional boxing match” as a **boxing** contest for compensation. The firewall (promoter may not manage a boxer; manager may not have a promotional interest; applies to bouts of **10 rounds or more**) does not reach MMA, kickboxing, Muay Thai, or karate. The 18 catalog orgs are not boxing promoters. State **unarmed-combat** analogues (NV `NAC 467.104`) still apply on NV cards. The 2026 Ali **Revival** / UBO bills are boxing legislation, **not enacted** as of this verification, and are scenery. | J3 already used § 6307c as contrast. This is the sister section. Do not write an Ali-Act overlay onto UFC/PFL/ONE. |
| **E7** | What licence the player’s desk needs (NV/CA/NJ/NY) | If the gym **directs the career** or takes **≥ 10% of a purse**, it needs a **manager** licence in the event state. Second/cornerman is a **separate** licence except where a manager may second without one (NV/CA). Matchmaker is the **promoter’s** licence, not the gym’s, unless the player stages cards. Promoter licence is **not** the desk. Fees are small and **calendar/fiscal-year** (table in Area 2). Do **not** build a licence-exam career. | The game has never asked whether the player is licensed to do what they do. A flag is enough. A simulator is scenery (J2 §6.2). |
| **E8** | Can gym + manager + promoter be one entity? | **Not on a commissioned pro card, as a default.** NV: combatant may not have the promoter (or its stockholders/matchmakers) act as manager or hold a financial interest in management/earnings (`NAC 467.104`). CA: promoter may not have a proprietary interest in a fighter competing on the promoter’s premises **without written CSAC approval** (`BPC 18849`). NY: manager forbidden to act as matchmaker (`19 NYCRR 208.19`); matchmaker forbidden to act as manager (`208.23`). Ali Act § 6308 is the **boxing** federal version. Catalog **promotions** are promoters; the **player is the gym/manager**. Do not merge the desks. | UFC/PFL exclusive promotional contracts are **promoter** contracts, not manager contracts. That is legal for MMA because Ali Act does not apply; NV `467.104` still forbids the *promoter* from being the *manager* on a Nevada card. |
| **E9** | What a desk (manager) suspension does | **The desk stops negotiating and, in NJ, stops working the corner.** CA: manager licence revoked or suspended **≥ 60 days** → contracts void on day 30 unless stayed (`4 CCR 221(a)`); shorter suspension → contracts **voidable by the boxer**. NJ: suspended manager must not work a corner or negotiate (`N.J.A.C. 13:46-6.6`); unrenewed/revoked manager licence → contract may not be recognized (`13:46-6.3`). NV form: permanent manager suspension → contestant may terminate for NV contests. This is **not** a fighter medical hold (already exists). A full “licence RPG” is scenery. | Player-facing if we ever take a manager cut. Until then, a one-line refusal: suspended manager cannot book. |
| **E10** | Amateur vs pro — who licenses the desk | **Cite J2 D5; do not re-derive.** A contracted purse is what **ends** IMMAF amateur eligibility (J2 §2.4, IMMAF eligibility page). Amateur cards use amateur sanctioning bodies (NV amateur MMA: commission-recognized amateur orgs, amateur promoter **$25**/year vs pro **$750**). The player training amateurs is a **gym**, not a pro manager of record. Do not pay a CMMAF purse (J2 D2/D6 / R40 — not reopened). | The current gym-banks-the-purse lie would, on a CMMAF fighter, also be an eligibility lie. |
| **E11** | Medical insurance at a sanctioned event | **Promoter carries it. Fighter does not.** NV: promoter provides **$50,000+** medical per licensed contestant, **no deductible** to the contestant (`NAC 467.149`; `NRS 467.125` authorizes). Amateur NV: **$25,000**. NY: promoter **$50,000** medical + **$50,000** death + **$1,000,000** life-threatening brain injury (`19 NYCRR 208.15`). CA: promoter short-term medical program, promoter pays the deductible (`4 CCR 290`; CSAC promoter form **$50,000** for pro boxers **and** martial-arts fighters). Duration: **the contest**, not year-round health insurance. | Honest counterpart to the hold that already exists. Do not debit the fighter a premium. |
| **E12** | Who pays the clearance that **lifts** a hold | **UNKNOWN as a single dollar and a single payer.** Fight-night injury claims: promoter insurance (NV: fighter must file the claim; promoter pays deductible). Licensing / post-KO neuro, MRI, ophthalmology: mixed. NY: “certain costs and fees for medical testing be borne by the promoter” (NYSAC Medical Manual 2024); ABC page: NY blood work scheduled through the Commission billed to the promoter. CA `BPC 18711(c)`: neurological-exam costs paid from **assessments on promoters, managers, and/or athletes** — rate set by CSAC. NV licensing MRI is a **combatant** filing requirement; who writes the cheque is **UNKNOWN** as a statute. **Do not invent an MRI price.** Lift by a `clearance` action (J3 D6). The week table in `body_readiness_rules.json` stays labelled **invented**. | This is the missing half of J3 D6. The hold is shipped. The cost is not. |
| **E13** | Camp / travel / corner: promoter vs fighter, for the 13 | **Do not author a 13-row dollar table.** Published: almost nothing. `FightContract.opening_terms` already opens with `travel_covered` and `accommodation_covered` **true** (promoter-shaped). Camp costs are **fighter/gym**, unpublished. UFC leaked promotional contracts (SECONDARY, 2013 PACER) have Zuffa paying reasonable travel/hotel/meals for **promotional appearances**; bout-camp cost **UNKNOWN** as a 2026 UFC primary. PFL / ONE / GLORY / RIZIN / the regional nine: **UNKNOWN**. Keep the live travel toggle. Do not invent camp line-items. | J2 §6.3: no invented numeric default. Same discipline. |
| **E14** | Employee vs independent contractor | **Flag as contested. Do not ship a classification.** UFC treats fighters as independent contractors (reported; TKO filings discuss antitrust, not a reclassification). The Zuffa Sherman Act class settlement (**$375 million**, D. Nev. 2:15-cv-1045, approved 2025-02-06, TKO 10-Q) is **not** an employee ruling. No retrieved 2026 order reclassifies catalog fighters as employees. | A labour-law sim is a second mode (J2 §6.2). |
| **E15** | Multi-bout, exclusivity, champion clauses, matching rights, options | **Do not author numbers.** UFC-shaped exclusivity, a champion’s **extension**, and a post-term **matching right** exist in **leaked** promotional agreements (SECONDARY, PACER exhibits in D. Nev. 2:15-cv-1045, including a 2013 form). Current UFC / PFL / ONE / GLORY primary PDFs of those clauses: **not retrieved**. PFL 2025 World Tournament Rules PDF is a **bracket + $500,000 winner bonus** (already J3 D13), not a multi-bout exclusive. Ali Act `15 U.S.C. § 6307b` limits **coercive boxing** promotional options to **12 months** — boxing-only, not catalog. CA `4 CCR 230(d)`: blanket contracts / options on a boxer’s services unrecognized without commission approval. | Inventing “8 fights or 40 months” as a game default would be the PPV-% mistake in another coat. |
| **E16** | What ends a contract | **Honestly modellable:** (1) term expiry, (2) mutual release, (3) **manager-licence loss** (CA `4 CCR 221`; NJ `13:46-6.3`). **Not honest without a primary:** automatic extension for injury / failed test / licence suspension of the **fighter** (reported in leaked UFC/Zuffa Boxing contracts — SECONDARY). Retirement: negotiated, **UNKNOWN** as a universal. Failed test: commission may NC the bout (J3 D8/D9); promotional-term fate **UNKNOWN**. | The game negotiates one bout (`FightContract.gd`) and stops. Ending a bout-agreement is “the card happened.” Ending a **promotional** term is Area 4, later. |
| **E17** | Sponsorship conflicts on top of J3 D15 | **Do not redo D15.** `Sponsorship.gd:224` already branches on `entity_type` (J2 P12) and J3 D15 adds `outfitting_policy ∈ {house_kit, fighter_sponsors}`. Manager/gym add-on: a filed manager contract **may** claim a share of remaining **fighter-side** sponsorships. Whether the 33 1/3% **ring-earnings** cap covers sponsorships: NV form text is “earnings from all contests, exhibitions and performances of unarmed combat” — **bout** earnings. Off-cage endorsements: **UNKNOWN** as inside the cap. `house_kit` (UFC) already removes fight-week patches, so there is nothing for a manager to cut **there**. | One sentence on top of D15. Not a second outfitting system. |
| **E18** | **Minimum change** (this study’s D16) | Four one-liners — see each area’s (d). Build order is the priority ruling, not a fifth system. | Stops `GameState.gd:10200` paying the wrong party without a manager-simulator. |

**Fifth area?** No. A playable agency / second career would be a new mode. It does not outrank paying the person named on the bout form. Park it as scenery (priority ruling).

---

## File-level anchors (what is live vs this study)

| File / fact | Role | Live? | Honesty |
|-------------|------|-------|---------|
| **`GameState.gd:10200` settlement** | `gym["cash"] += purse + win_bonus + performance_bonus + gate_share - expenses` | LIVE (excerpt) | **Wrong party paid.** Gym banks 100% of the fighter purse. First row of this study. |
| `GameState.gd:10204` `career_earnings` | Ambitions “Financial Security” counter | LIVE | **Counts** the purse onto the athlete; **does not pay** the athlete. Additive from 2026-09-03. |
| `FightContract.gd:94` `money_on_table` | show + win + performance | LIVE | Honest **shape** of a bout package (J3 D13). |
| `FightContract.gd:147` `opening_terms` | `show_purse`, `win_bonus`, `performance_bonus=0`, `travel_covered=true`, `accommodation_covered=true` | LIVE | Promoter opens covering travel/hotel. **Invented** `TRAVEL_COST` / `ACCOMMODATION_COST` magnitudes. |
| `FightContract.gd:199` `package_value` | Promoter money axis | LIVE | Honest as a **negotiation** axis. |
| `FightContract.gd:215-233` `settlement_for` | `net = show + win + perf + gate_share - expenses` | LIVE | Computes a fighter-shaped net, then `:10200` **gives it to the gym**. |
| `gym_cut` / `manager_cut` / `purse_share` | — | **Absent** (TASK_J4: nowhere in `Godot/scripts/`) | The hole. |
| `BodyReadiness.gd:34-43` | `medical_hold_until_week` / `medical_hold_reason` | LIVE | **Honest object.** Existence is not in dispute (correction 1). |
| `BodyReadiness.gd:118` `evaluate_competition_clearance` | Time gate; cannot be waived by region recovery | LIVE | Honest **verb-shape** (refuse while held). Lift is still a week count. |
| `body_readiness_rules.json` `medical_hold_weeks` | 1 / 4 / 8 by fight profile | LIVE | **Invented duration.** J3 D6 forbade authoring this as ABC. |
| `GameState.gd:3385` / `:3815` | Hold accessor / booking refusal | LIVE per TASK_J4 | Not in this excerpt; do not re-derive. |
| `Sponsorship.gd:224` | First legal branch: `entity_type` → template | LIVE (J2) | J3 D15 adds `outfitting_policy`. This study adds only a manager-share **question** on remaining fighter-side money (E17). |
| `get_promotion_bout_offer` / `_promotion_purse_multiplier` | Org → fighter purse | LIVE (J2) | Honest **shape** for the 13. Still pays federations (J2 D2 / R40 — **not this sprint**). |
| R6 gate points / `gate_share` | Clause on the bout | LIVE | **Invented** magnitude (J3). Still paid to the gym at `:10200`. |
| Weight-miss `fine_fraction` | D2 / J3 D11 | LIVE | Fine comes **off the purse** before `:10200`. Still lands in gym cash. |
| Manager / second / matchmaker licence | — | **Absent** | The desk has never been asked. |
| Fighter cash account | — | **Absent** | `career_earnings` is a counter, not a wallet. |
| Promotional (multi-bout) contract object | — | **Absent** | Game is one-bout `FightContract`. |
| Employee / IC flag | — | **Absent** | Correct omission (E14). |

---

# Area 1 — Where the purse actually stops

## (a) Decisions coming (named as calls)

1. **Call: contracted party.** Athlete, manager, or gym — whose name is on the bout form, and who the promoter’s cheque is written to.
2. **Call: manager %.** Statutory cap vs CUSTOMARY take. Do we store a number?
3. **Call: gym cut.** Training fee, corner percentage, purse percentage, or nothing published.
4. **Call: who pays the corner.**
5. **Call: deductions** before anyone is paid — commission, licence, drug, insurance — statutory vs CUSTOMARY.
6. **Call: Ali Act § 6308.** What it does, what it does not, whether it touches the 18.

## (b) Evidence (cited) + UNKNOWN discipline

### Who the bout form names

**Nevada (primary).** `NAC 467.112` (verified 2026-09-06): the bout agreement is **between a promoter and an unarmed combatant**, on a Commission form. A bout agreement that has the combatant pay for the opponent is prohibited. The NSAC **Official Bout Agreement** (form `O-460`, boxing.nv.gov) is captioned Promoter ↔ Contestant. Compensation clause: “The Promoter will pay the Contestant…”. Manager’s share is a **separate, optional** deduction: only if the contestant initials it, the manager is licensed, a valid management contract is on file, and the amount **does not exceed one-third** of the compensation.

`NAC 467.137(1)` (verified 2026-09-06): an unarmed combatant **must be paid in full according to his or her bout agreement**; no part returned through the manager to a matchmaker or promoter except as that section allows. `NAC 467.137(3)`: a manager’s share **may**, with the combatant’s approval, be deducted and paid to the manager if the management contract complies with `NAC 467.102`.

`NAC 467.102(5)`: a manager may not sign for a combatant who is not under contract to that manager. **An unarmed combatant who does not have a licensed manager must sign for his or her own contest and sign the receipt for his or her own purse.**

`NRS 467.120`: every contestant is entitled to a copy of a written contract binding the licensee to pay the contestant a certain fixed fee or percentage of the gate; the inspector may impound gate receipts to pay contestants.

**California (primary).** `4 CCR 230(a)`: only the commission’s official form. `4 CCR 221(b)` last sentences: no manager may negotiate or sign for a boxer not under contract; **any boxer not having a contract with a licensed manager shall sign for his own contests and receipt for his full purse.** `BPC 18855`: the commission recognizes and enforces contracts between boxers **or martial arts fighters** and managers, and between those athletes and licensed clubs, on printed commission forms.

**ABC model (primary-adjacent).** ABC “Boxer and bout sample contracts” page (verified 2026-09-06): **Model Bout Contract** is Promoter ↔ Boxer. “Promoter shall pay Boxer, and Boxer shall accept, a purse… All purse amounts shall be made immediately after the conclusion of the bout **directly to the Boxer**, unless otherwise agreed to in writing.” Deductions only if the boxer agrees and they are itemized.

**New York (primary).** `19 NYCRR 209.13` (NYSAC compilation, verified via dos.ny.gov 19 NYCRR parts 206–214 PDF, 2026-09-06): all compensation to licensed professional boxers or mixed martial artists **shall be paid by the promoter by check payable to the participating combatant**, who shall sign receipts, unless otherwise directed by the Commission.

**Ruling on E1:** the contracted party is the **athlete**. The player’s gym is not on that form. J2 §2.6’s “org → fighter” is the correct polarity **and it does not stop at the gym**.

### Manager percentage — statutory caps vs CUSTOMARY

| Jurisdiction | What is published | Applies to MMA? | Kind |
|--------------|-------------------|-----------------|------|
| **Nevada** `NAC 467.102(6)` | Manager(s) may not participate separately or collectively in more than **33 1/3%** of the earnings of the unarmed combatant **in the ring**. Commission will not honor a manager contract **> 4 years** (`467.102(4)`). NSAC boxer/manager form restates both. | **Yes** — NAC 467 is unarmed combat (boxing, MMA, kickboxing). | **STATUTORY cap** |
| **California** `4 CCR 221(b)` | No manager or group of managers shall participate in more than **33 1/3%** of the **gross ring earnings of the boxer**. | Text sits in Professional **Boxing** Rules. CSAC has used the same fighter–manager **forms** for martial-arts fighters (`BPC 18855`; CSAC arbitration practice). **MMA-specific 4 CCR restatement of the 33 1/3% cap: not retrieved.** Treat the cap as **INHERITED CSAC practice** for MMA until an MMA article is in hand. | Boxing: **STATUTORY**. MMA: **INHERITED** |
| **New Jersey** `N.J.A.C. 13:46-6.4` | Manager entitled to **no more than 33 1/3%** of the ring earnings of any **boxer** with a properly filed boxer-manager contract. | Subchapter 6 is boxing-titled. NJSACB licenses managers for combative sports including MMA (licensing page). **MMA-specific % section: UNKNOWN.** | Boxing: **STATUTORY**. MMA: **UNKNOWN** |
| **New York** `19 NYCRR 209.12` | No licensed professional boxer or mixed martial artist shall actually receive **less than 50%** of ring earnings after all authorized purse deductions, unless the Commission directs otherwise. | **Yes** — names MMA. | **STATUTORY fighter floor**, not a manager cap |
| **CUSTOMARY MMA journalism** | “Managers make 5–20%” | Not a rule | **CUSTOMARY / SECONDARY**. Do not carry as a default |

**Trigger for needing a manager licence at all (not a cap):** NV `NAC 467.0028` / `NRS 467.01037`, CA `BPC 18628`, NJ `N.J.A.C. 13:46-1.1` — a person who receives or is entitled to receive **10% or more** of the gross purse (CA: **more than 10%**) for services relating to the contest **is a manager** and must be licensed. Attorneys acting only as counsel are carved out.

**Do not** store 20% as “typical.” **Do not** store 33 1/3% as the take — that is the **ceiling**. Filed contracts retrieved in CSAC arbitrations (SECONDARY, not data) have used 16 2/3%, 18%, 25%, 30% — all **below** the cap. That distribution is not a formula.

### Gym cut vs manager

**No retrieved commission chapter taxes a “gym” a percentage of the purse.** Gyms charge dues, camp fees, or private “team” arrangements. Those are **private contract**.

The honest tripwire is the **10% definition**. If the gym takes ≥ 10% (NV/NJ) or > 10% (CA) of the gross purse for services relating to the bout, the gym **is** a manager and the E2 cap applies. Below that, it is dues/fees, unpublished.

**UNKNOWN (do not invent):** a published “gym gets 10% of the purse” table for any of the 13 promotions; whether a monthly membership is creditable against a purse; Muay Thai gym traditional cuts in Thailand (RWS) as a numbered rule.

Bangkok Post 2026-07-23 (SECONDARY) notes a named Muay Thai gym receiving a cut of a star’s ONE purses — **reported private arrangement**, not a Rajadamnern or ONE bylaw. Do not author it.

### Who pays the corner

| Item | Who pays | Evidence |
|------|----------|----------|
| Second / cornerman **licence** | The second (or the manager, where a manager licence covers it) | NV `NAC 467.012(8)(g)` second **$50**; CA `BPC 18811` trainer/chief second/second **$50**; NJ `13:46-4.25` second **$25**; NY boxing second **$10**, MMA second **$40** (dos.ny.gov fee schedule / DOS-2047) |
| Second’s **work** on the night | **CUSTOMARY:** fighter or manager, from the purse or a side agreement | No retrieved statute requires the promoter to pay the cutman a wage |
| Manager working the corner | NV `NAC 467.057` / CA `4 CCR 215`: manager **may** second without a second’s licence. NJ `13:46-6.2`: manager **may not** unless also licensed as a second. NY `207.9`: own fighter only | Statutory |
| Travel of fighter + limited cornermen | Bout-agreement term. Game: promoter opens covering travel/hotel | `FightContract.gd:168-172`. UFC leaked contracts (SECONDARY) sometimes specify economy tickets for fighter + one cornerman — **not** a 2026 primary |
| Cutman fee as a % of purse | **UNKNOWN** as a commission number. Boxing journalism “3%” is **CUSTOMARY**, not ABC | Do not author |

CA `BPC 18653` (verified 2026-09-06): no person shall **train** a professional boxer, kickboxer, or martial-arts athlete unless licensed. A **professional trainer** (five years’ experience) must be in the corner unless the commission/executive officer authorizes otherwise. That is a **licence-in-the-corner** rule, not a who-pays-the-trainer rule.

### Deductions — statutory vs CUSTOMARY vs promoter-side

| Deduction | Who it hits | Kind | Cite |
|-----------|-------------|------|------|
| Manager share | Combatant’s purse, **if** combatant approves and contract is valid | **STATUTORY mechanism**, % is the filed number up to the cap | `NAC 467.137(3)`; NV bout form §7 |
| Promoter withhold for combatant expenses | ≤ **10%** of purse, reconciled in 5 working days with combatant approval | **STATUTORY** (NV) | `NAC 467.142(4)` |
| Itemized bout-contract deductions | Only if specified on the club–boxer contract; CSAC may disallow | **STATUTORY** (CA) | `4 CCR 230(c)` |
| Weight-miss forfeit | Combatant’s purse → opponent (NV **25%** unless Director sets less; game **20%** CUSTOMARY) | Already J3 D11 | `NAC 467.522`; do not reopen |
| Promoter gate tax | **Promoter**, not the purse | **STATUTORY** | NV `NRS 467.107`: **8%** of gross admission receipts, no deduction for purses. CA `BPC 18824` (J3 D14): promoter report / 5% admissions |
| Drug-testing program | **Promoter** pays; may take a **credit against** the NV 8% | **STATUTORY** | `NRS 467.107(4)`; `NAC 467.588`–`.589`. NSAC promoter checklist: fight-night testing is the promoter’s cost |
| Event medical insurance premium | **Promoter** | **STATUTORY** | E11 |
| Combatant / manager / second licence fee | That licensee | **STATUTORY** | E7 table |
| Alphabet sanctioning fee | Boxing, **not in catalog** | Contrast only | Ali Act requires sanctioning orgs to file a fee **schedule**; exact % **UNKNOWN** unless the current FTC filing is in hand (J3 D4) |
| “Commission cut of the purse” as a fighter line-item | — | **Not retrieved** as a global | Do not invent |

**Kickbacks back to the promoter are the thing the statutes exist to stop** (`NAC 467.137(1)`; Ali Act `15 U.S.C. § 6307e` disclosures of any portion of the boxer’s purse the promoter will receive — boxing-only).

### Ali Act 15 U.S.C. § 6308 — what it does and does not reach

**Text (verified 2026-09-06, LII):**

- **§ 6308(a)** — regulatory personnel (commission members/employees, ABC members) may not contract with or take compensation from a promoter or have a financial interest in an active registered boxer.
- **§ 6308(b) firewall.** Unlawful for (A) a **promoter** to have a direct or indirect financial interest in the **management** of a boxer; or (B) a **manager** to have a direct or indirect financial interest in the **promotion** of a boxer, or to be employed by / receive benefits from a promoter except amounts under the manager’s contract with the boxer.
- **Exceptions:** a boxer may act as his own promoter or manager; the firewall **only applies to boxers participating in a boxing match of 10 rounds or more**.
- **§ 6308(c)** — sanctioning-organization officers may not take gifts from promoter/boxer/manager except published sanctioning fees.

**Definitions (`15 U.S.C. § 6301`, verified 2026-09-06):** “boxer” = individual who fights in a **professional boxing match**; “professional boxing match” = a **boxing contest** in the United States for compensation. MMA, kickboxing, Muay Thai, karate are **outside** the chapter.

**Sister contracting sections (boxing-only, contrast):**

- `§ 6307b` — coercive promotional rights granted **as a condition of taking a fight** unenforceable if **> 12 months**; no future promotional rights as a condition of a **mandatory** sanctioning-org bout.
- `§ 6307e` — promoter must disclose to the commission **and** to the boxer all fees/charges/expenses assessed on the boxer, including any portion of the purse the promoter will receive, and training expenses.

**Catalog test:**

| org id | Discipline (catalog) | Ali Act § 6308? |
|--------|----------------------|-----------------|
| `ufc` `pfl` `jungle_fight` `lux_fight_league` `road_fc` `ares_fighting_championship` `urcc` | MMA | **Does not apply** |
| `one_championship` | MMA / Muay Thai / kickboxing / BJJ | **Does not apply** |
| `rizin` | MMA / kickboxing | **Does not apply** |
| `glory` `kunlun_fight` | kickboxing | **Does not apply** |
| `karate_combat` | karate | **Does not apply** |
| `rajadamnern_world_series` | Muay Thai | **Does not apply** |
| `ibjjf` `ijf` `united_world_wrestling` `world_taekwondo` `cyprus_mmaf` | J2 pathways | **Does not apply** |

**Nevada’s analogue for this catalog:** `NAC 467.104` (unarmed combat, so MMA **does** apply on NV cards): a combatant may not have a promoter or its members, stockholders, officials, matchmakers or assistant matchmakers (1) act directly or indirectly as manager, or (2) hold any financial interest in the combatant’s management or earnings.

**2026 Ali Revival / UBO legislation** (House activity 2026; The Athletic 2026-03-24; Congress.gov H.R. 4624): would create a “unified boxing organization” pathway that critics say weakens the § 6308 firewall **for boxing**. **Not retrieved as enacted law** on 2026-09-06. Boxing-only. **Scenery** for this catalog.

**Ruling on E6:** Ali Act § 6308 does **not** touch the 18. Do not build a federal boxing firewall into UFC booking. Do **use** `NAC 467.104` / `BPC 18849` / NY matchmaker-manager split when a card is tagged to those states.

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| Who is paid the purse | Gym, `GameState.gd:10200` | **Wrong party.** The bout form’s contestant is unpaid as cash |
| Fighter-facing number | `career_earnings` += same purse (`:10204`) | **Counter, not a wallet.** Ambitions can read it; the athlete cannot spend it |
| `FightContract` net | show + win + perf + gate − uncovered travel/hotel | Honest **computation**; dishonest **destination** |
| Manager % | none | **Absent** (and must not be invented as a default) |
| Gym cut of purse | 100% | **Lie.** There is no published 100% gym entitlement |
| Corner pay | none as a line | **Absent.** Travel toggle exists |
| Commission / drug / insurance skim off purse | none | **Honest omission** of a non-rule. Do not add one |
| Ali Act overlay | none | **Honest omission** (does not apply) |

## (d) Minimum change (one concrete recommendation)

**Stop crediting `gym["cash"]` with the contracted purse. Credit the athlete the bout-agreement money (`show_purse + win_bonus + performance_bonus + gate_share - expenses`). If and only if a filed manager contract exists, credit the gym the filed manager share, never above the statutory cap of the event jurisdiction, and never a made-up default percentage. No manager contract → gym receives $0 of that purse. Gym operating costs stay gym costs.**

Do not add `gym_cut`. Do not author 20% or 33% as a simulation default. Do not skim NRS 467.107 / BPC 18824 off the fighter.

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — Ambitions “Financial Security” currently reads `career_earnings`, which is the full purse.** If the gym no longer banks it, the counter must stay the **fighter’s contracted purse** (bout-form money), not the gym’s leftover.  
**Solution:** keep `career_earnings` as the athlete’s bout-agreement gross (before a manager share). The manager share is a separate gym credit. Do not retune the $50k ambition threshold in this sprint.

**Issue 2 — Temptation to “fix” it with a 20% manager take.**  
**Solution:** E2. Cap ≠ default. UNKNOWN policy.

**Issue 3 — Player fantasy: “I own the fighter, I take the purse.”**  
**Solution:** That is the lie. The player owns a **gym** and, if licensed, may be a **manager**. Those are not promoter rights and not a 100% assignment of the bout agreement.

**Issue 4 — Brand / commission forms.** NSAC O-460, CSAC bout forms, ABC model contracts are real.  
**Solution:** J1 §4.1. Text names in research. Do not ship photographed official forms as UI art.

**Issue 5 — Thailand / Japan / Singapore cards have no NAC 467.**  
**Solution:** Default polarity is still promoter → contestant (J2 §2.6). Manager-cap overlays are **jurisdiction-tagged**. Do not export 33 1/3% onto RIZIN or RWS as if it were house law.

**Issue 6 — Unplayed manager-agency mode.**  
**Solution:** J2 §6.2. E18 is a settlement split, not a new career.

---

# Area 2 — The licence the player’s own desk needs

## (a) Decisions coming (named as calls)

1. **Call: which licences** (manager / second / cornerman / matchmaker) the four open jurisdictions require, what they cost, what they bar.
2. **Call: can one entity be gym, manager, and promoter.**
3. **Call: what a desk suspension does** (not a fighter hold).
4. **Call: amateur vs pro** for the desk (cite J2).

## (b) Evidence + UNKNOWN

### Licence table — NV / CA / NJ / NY (professional)

Fees verified 2026-09-06 from the cited primary. **Term** is as published; do not invent a “per bout” duration where the text is calendar/fiscal year.

| Role | Nevada | California | New Jersey | New York |
|------|--------|------------|------------|----------|
| **Combatant** | **$50**, remainder of calendar year (`NAC 467.012(8)(a)–(d)`, `(9)`) | **$60** (`BPC 18809`) | **$5** (`N.J.A.C. 13:46-4.25(b)`), fiscal year 1 Jul–30 Jun | Boxing **$10** expires Oct 1; MMA combatant fee **UNKNOWN as a single current GBL line this pass** (schedule page lists boxing combatant $10; MMA block lists manager/second/matchmaker separately) |
| **Manager** | **$100** / calendar remainder (`467.012(8)(f)`) | **$150** (`BPC 18810`); written exam (`4 CCR 218(a)`), waivable if licensed elsewhere without discipline | **$25** / fiscal year (`13:46-4.25(a)(4)`) | Boxing **$30** until Sep 30 / Oct 1 (GBL / dos.ny.gov schedule). MMA manager **$50**, 1 year from issuance (same schedule, `GBL § 1007(3)(b)`) |
| **Second** (incl. trainer in NV) | **$50** (`467.012(8)(g)`). **Manager may second without this** (`NAC 467.057`) | **$50** (`BPC 18811`). **Manager may second without this** (`4 CCR 215`). Exam + demonstration (`4 CCR 218(b)`) | **$25** (`13:46-4.25(a)(6)`). **Manager may not second unless also licensed as second** (`13:46-6.2`) | Boxing **$10**; MMA **$40** (DOS-2047 / fee schedule). Manager may second **their** combatant; needs second licence for others (`19 NYCRR 207.9`) |
| **Matchmaker** | **$100** (`467.012(8)(e)`) | **$200** (`BPC 18806`); assistant also **$200** (`18807`) | **$100** (`13:46-4.25(a)(9)`) | Boxing **$50**; MMA **$100** |
| **Promoter** | **$750**/year (`NAC 467.052(4)`); amateur boxing promoter **$25** | **$1,000** pro (`BPC 18804`); amateur **$250** (`18805`); **$50,000** liquid assets + **$50,000** bond (`4 CCR 213`) | **$300** (`13:46-4.25(a)(1)`) | Seating-capacity scale (e.g. first-class city not more than 2,500 → **$450**, up to **$2,500** for >25,000) — dos.ny.gov schedule |
| **Pro trainer / gym** | No separate “gym” class in `467.012` | `BPC 18653`: cannot **train** a pro without a licence. Gymnasium licence fee **shall not exceed $200** (`BPC 18817`); `4 CCR 208` still prints **$10** — **current dollar UNKNOWN** between those two texts | — | — |

**What you may not do without the licence.** NV `NRS 467.100`: no person may participate, directly or indirectly, in a professional contest unless licensed. NY `19 NYCRR 206.5` / `207.1`: no boxer, MMA athlete, promoter, manager, second/trainer, matchmaker, referee, judge, or timekeeper without the appropriate licence. CA `BPC 18642` / `18641`: licence required to participate or serve as manager/second/etc. NJ `13:46-4` general licensing.

**UNKNOWN (do not invent):** 2026 CA gymnasium **exact** dollar (statute ceiling $200 vs CCR $10); NY MMA **combatant** fee if different from boxing $10; whether a Nevada manager licence is accepted as-is in California (typically **re-licence in the event state** — same hole J3 already flagged for fighters); Texas / other catalog-event states.

### Gym + manager + promoter as one entity

| Rule | What it forbids | Catalog consequence |
|------|-----------------|---------------------|
| Ali Act `15 U.S.C. § 6308(b)` | Promoter managing a boxer / manager promoting a boxer (10+ rounds) | **Does not apply** to the 18 |
| NV `NAC 467.104` | Promoter (and its stockholders, officials, matchmakers) acting as manager or holding a financial interest in management/earnings | **Applies** to UFC/PFL/Karate Combat **Nevada** cards |
| CA `BPC 18849` | Promoter (or person with proprietary interest in the promoter) having proprietary interest in a fighter competing on premises the promoter owns/leases/rents, **without written CSAC approval** | **Applies** to California cards |
| NY `19 NYCRR 208.19` / `208.23` | Manager acting as matchmaker; matchmaker (or its principals) acting as manager | **Applies** to NY cards |
| CA promoter form | Asks whether any boxer/manager has a financial interest in the club | Disclosure, not a permission |

**The 13 promotions** already occupy the **promoter** chair. They sign exclusive **promotional** agreements (house model). That is **not** the same as being the fighter’s licensed manager. Fighters still (may) have managers. The **player** occupies the gym / (if they take a cut) manager chair. **Do not let the player also be the promoter of a catalog org’s card.**

**Self-promoting boxer** is an Ali Act exception (`§ 6308(b)(2)(A)`). A fighter acting as their own manager is also explicitly allowed in NV (`467.102(5)` — sign for yourself) and CA (`4 CCR 221(b)`). That is the athlete, not the gym-as-UFC.

### Desk suspension (not the fighter hold)

| Jurisdiction | If the **manager** licence dies | Corner? |
|--------------|----------------------------------|---------|
| CA `4 CCR 221(a)` | Revoked or suspended **≥ 60 days**: contracts void on **day 30** unless a court stays. Suspended **< 60 days**: contracts **voidable by the boxer** during the suspension if the boxer gives written notice | Manager-as-second falls with the manager licence |
| NJ `13:46-6.3` | Unrenewed or revoked: commission **may** refuse to recognize the boxer-manager contract | `13:46-6.6`: suspended manager **must not** work a corner or negotiate with a promoter/matchmaker |
| NV bout/manager form | Permanent suspension: contestant **may terminate** as to NV contests. Non-permanent: contestant may contract individually during the suspension; manager takes **no percentage** of those earnings | `NAC 467.057` privilege is for a **licensed** manager |
| NY | Licence required to act (`206.5`). Exact void-the-contract clock: **not retrieved** as a 209-series analogue of CA 221 this pass | Manager-as-second limited to own fighter even when licensed |

This is **orthogonal** to `medical_hold_until_week`. Do not overload the hold object.

A playable “keep your manager licence clean” career is **scenery** (J2 §6.2). Minimum, if we ever take a manager share: a suspended-desk flag refuses booking.

### Amateur vs pro (cite J2, do not re-derive)

J2 **D5**: amateur → pro is a **one-way door**. IMMAF eligibility dies on a Unified-Rules pro bout, a **contracted purse**, a published pro record, or (from 2025) any MMA bout that allowed elbows and/or knees to the head. IMMAF allows prize money, sponsorships, and **up to USD 1,000** in paid expenses from a promoter; above that, or a contracted purse, = professional (immaf.org/athletes/athlete-eligibility/, already J2).

**Desk implication:** the player’s gym may train amateurs without being a **professional** manager of record. Nevada amateur promoters are a **different** licence (**$25**/year vs **$750**). Amateur medical insurance is **$25,000** not **$50,000** (`NAC 467.149(4)`). Do not put a pro manager contract, or a pro purse, on a `cyprus_mmaf` athlete (J2 D2/D6). R40 remains J2 D6 — **not reopened**.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Manager licence | none | **Absent** |
| Second licence | none | **Absent** |
| Matchmaker licence | none | **Absent** (and the player should not need one) |
| Promoter licence | none | **Absent** (correct — the 13 are the promoters) |
| Gymnasium / pro-trainer licence (CA) | none | **Absent** |
| Desk suspension | none | **Absent** |
| Amateur desk vs pro desk | CMMAF currently paid as a promotion (J2 lie) | **Lie** — R40 / J2 D6, not this sprint |

## (d) Minimum change

**Do not build a licence-exam career. If E18 pays the gym a manager share at all, gate that share on a `manager_licensed` flag for US-commission cards (`ufc` / `pfl` / `karate_combat` when tagged NV/CA/NJ/NY). Unlicensed gym taking a purse share is the thing `BPC 18628` / `NAC 467.0028` exist to catch. Matchmaker and promoter licences stay off the player. Amateur CMMAF stays J2 D6 (no purse).**

Optional later, still small: a desk-suspension flag that refuses booking. Not MVP.

## (e) Issues + solutions

**Issue 1 — Four-jurisdiction fee table becomes a tax sim.**  
**Solution:** fees are **$25–$150** for the desk roles. Do not make the player grind renewals. If a fee is ever debited, use the primary dollar and the primary term, labelled `evidence`.

**Issue 2 — Player-as-UFC (gym + promoter + manager).**  
**Solution:** E8. The 13 promotions already have the promoter chair. Ali Act is not the reason for MMA; `NAC 467.104` / `BPC 18849` / NY 208.19 are.

**Issue 3 — Brand / licence certificates.**  
**Solution:** J1 §4.1. No seals, no photographed licences, no named officials as data.

**Issue 4 — Exporting NV licences onto RIZIN.**  
**Solution:** Same as J3 D7. Licence is **event-state**. A Singapore ONE card does not ask for an NSAC manager card unless we author that the host does — **UNKNOWN**, default off.

**Issue 5 — Unplayed second/cornerman mode.**  
**Solution:** scenery. The player may *be* a licensed second on paper. They do not play a cutman.

---

# Area 3 — What a fighter is owed that is not a purse

Not bonuses — J3 D13 settled those. The obligations. The hold already exists (correction 1); this area is insurance, clearance cost, camp/travel, and labour status.

## (a) Decisions coming (named as calls)

1. **Call: who must carry medical insurance** at a sanctioned event, for what, for how long after the bell.
2. **Call: who pays the clearance** that lifts a hold (neuro, MRI, ophthalmology).
3. **Call: camp, travel, cornermen** — promoter vs fighter, for the 13.
4. **Call: employee vs independent contractor**, and what that would change.

## (b) Evidence + UNKNOWN

### Insurance at the sanctioned event

| Jurisdiction | Who carries | Amount | Deductible | How long |
|--------------|-------------|--------|------------|----------|
| **Nevada** `NAC 467.149` / `NRS 467.125` (verified 2026-09-06) | **Promoter** | **$50,000+** medical per licensed contestant. Amateur: **$25,000** | **Contestant pays none.** If the contestant paid the bill, insurance reimburses the contestant | Injuries **while engaged in a contest or exhibition**. Not year-round health insurance. NSAC insurance memo: fighter must **file a claim**; promoter pays deductible |
| **New York** `19 NYCRR 208.15` (verified 2026-09-06) | **Promoter** | **$50,000** medical; **$50,000** death benefit; **$1,000,000** life-threatening brain injury (symptoms within 24 h, diagnosis within 48 h) | Expense-incurred; may be primary or secondary to other insurance | “Continuously” **during participation** in the program. TBI rider is event-causal, not a health plan |
| **California** `4 CCR 290` + CSAC promoter application | **Promoter** | Short-term medical program approved by CSAC. Promoter form: **$50,000** for events involving professional boxers **and martial arts fighters**; secured ≥ 48 h before the event | **Promoter pays the deductible** (`4 CCR 290(a)`) | “Injuries incurred **during a boxing contest**” in the CCR text; CSAC form extends the program to martial arts. **Not** year-round |
| **ABC / other states** | Varies | **UNKNOWN** as a universal. AZ statute (out of J3’s four) publishes $20,000 medical / $50,000 life — **NATIONAL**, do not copy onto NSAC | — | — |
| **13 promotions on non-US soil** | Host / house | **UNKNOWN** as a published ONE/RIZIN/GLORY/RWS insurance schedule this pass | — | — |

**GAO-03-699 (secondary, historical):** commissions required promoters to secure health insurance **during** matches; none of the sampled commissions required health and life insurance **before and after** fights. That 2003 finding still matches the 2026 statutes retrieved: **event accident cover**, not a fighter health plan.

**Do not** debit the athlete an insurance premium. **Do not** treat $50,000 as a payout the gym banks.

### Who pays the clearance that lifts a hold

The hold is a **time gate** (`evaluate_competition_clearance`). J3 D6: lift by **clearance**, not by an invented day count. The JSON already invented the days. This study does not add a second hold.

| Cost | Who the primary assigns it to | Enough to wire a dollar? |
|------|-------------------------------|---------------------------|
| Fight-night ER / surgery for a bout injury | Promoter’s event policy (E11). NV: fighter files the claim or may become responsible | Amount = policy limit, not a game fee |
| NY pre-licensure blood work scheduled through NYSAC | **Promoter**, billed at the State rate (ABC medical-requirements page; NYSAC Medical Manual: “State Law requires that certain costs and fees for medical testing be borne by the promoter”) | Rate **UNKNOWN** as a 2026 published table this pass |
| CA neurological examinations (`BPC 18711(c)`, verified 2026-09-06) | Assessments on **any one or more of** promoters, managers, and professional athletes. Rate set by CSAC. `4 CCR 280(i)`: commission collects **one quarter of one percent of gross ticket sales** from each licensed promoter of professional matches into the Neurological Examination Account | That 0.25% is a **promoter ticket assessment**, not an MRI invoice to the gym |
| NV licensing MRI / physical | Combatant **must file** the packet (`NAC` medical-application family; NSAC PHYSICAL-2025). Who writes the cheque: **UNKNOWN** as a statute (CUSTOMARY: fighter or camp) | Do not invent $N |
| Post-KO neurological clearance (NY `19 NYCRR 208.11` — already J3) | Required for return. **Payer UNKNOWN** as a dedicated post-KO invoice rule | Clearance is the verb |
| Ophthalmology, follow-up MRI after a hold | **UNKNOWN** payer as a universal | — |

**Boxing Insider 2026-03-30 (SECONDARY):** a brain MRI “can cost $500 to $1,500.” That is journalism, **not** a commission fee schedule. **Do not author it.**

**Ruling on E12:** the lift is `clearance` (physician). The debit is **UNKNOWN**. Prefer **no invented MRI line-item**. If a later data file authors a cost, it needs `evidence` and a payer field (`promoter` / `athlete` / `manager` / `assessment`). The existing 1/4/8 week table remains **invented** and is not ABC.

### Camp / travel / corner for the 13 promotions

| org id | What is published on camp / travel / corner pay | Status |
|--------|--------------------------------------------------|--------|
| `ufc` | No 2026 UFC.com purse-travel primary retrieved. Leaked promotional agreements (SECONDARY, PACER): Zuffa arranges/pays reasonable travel, hotel, meals for **promotional appearances**; bout-camp cost not a published bylaw | **CUSTOMARY** promoter-covers-fight-week-travel on numbered cards; camp **UNKNOWN** |
| `pfl` | 2025 World Tournament Rules PDF: competitive rules, miss-weight **20% of show purse**, $500,000 champion bonus (J3). **No** camp/travel schedule in that PDF | **UNKNOWN** |
| `one_championship` | Martial-arts page is hydration/anti-doping/title rounds (J3). Contract travel: **UNKNOWN** as primary. Journalism of salaried deals is **reported, not disclosed** (J3) | **UNKNOWN** |
| `glory` | Rules 2026 v2: miss-weight / titles / rankings discretion (J3). Travel: **UNKNOWN** | **UNKNOWN** |
| `rizin` `karate_combat` `jungle_fight` `lux_fight_league` `road_fc` `kunlun_fight` `ares_fighting_championship` `urcc` `rajadamnern_world_series` | **UNKNOWN** | **UNKNOWN** |

**Game today:** `FightContract.opening_terms` sets `travel_covered: true` and `accommodation_covered: true`. Uncovered costs come off `net` (`:220-224`). That is an honest **UFC-shaped default** and a real negotiation lever. **Keep it.** Do not add a camp-cost table.

### Employee vs independent contractor

**Contested. Not settled.**

- UFC / Zuffa **classifies** fighters as independent contractors (reported throughout the D. Nev. 2:15-cv-1045 record; TKO 10-Q 2026 discusses **antitrust** follow-ons, not a reclassification order).
- Zuffa antitrust class action, D. Nev. No. 2:15-cv-1045: Sherman Act monopsony / exclusive-dealing case. TKO Form 10-Q for the quarter ended 2026-03-31: updated settlement **$375.0 million**, district court approved **2025-02-06**, payment completed June 2025. **Not** an FLSA / NLRA employee determination.
- Follow-on antitrust complaints (2025–2026, same district) remain litigation. **Do not treat filings as rules.**
- NLRB independent-contractor tests have moved (*Atlanta Opera*, 2023) and remain politically contingent. **No retrieved 2026 Board decision** reclassifies UFC fighters.
- If they **were** employees: minimum wage, workers’ compensation, NLRA bargaining — a different game. **Scenery.**

**Ruling on E14:** store nothing. A comment in research is enough. Do not add `employment_status`.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Event accident insurance | none | **Absent** (promoter-side; fighter should not pay) |
| Medical hold | **Exists** as week count | **Invented duration**; honest **object** |
| Clearance as a paid action | none — hold lifts when `current_week >= hold_until` | **Missing verb** (J3 D6). Cost **UNKNOWN** |
| Travel / hotel | Promoter opens covering; uncovered comes off net | **Honest shape**; invented dollars |
| Camp cost | none | **Honest omission** (UNKNOWN) |
| Employee / IC | none | **Honest omission** |

## (d) Minimum change

**Do not add a hold. Add a `clearance` action that lifts `medical_hold` when a physician flag is set. Do not author an MRI dollar. Do not debit the fighter an insurance premium — that premium is the promoter’s. Keep `FightContract` travel/accommodation as the only camp-adjacent money already in the game.**

If insurance is ever shown, it is a **promoter compliance** flag on the event (`insurance_on_file`), not a gym invoice.

## (e) Issues + solutions

**Issue 1 — Inventing $1,200 MRI to “give the hold teeth.”**  
**Solution:** UNKNOWN policy. The hold already has teeth (`evaluate_competition_clearance`). Teeth ≠ a fake invoice.

**Issue 2 — $50,000 insurance looking like a purse.**  
**Solution:** It is medical cover with a policy limit. It is not paid to the gym. Do not add it to `:10200`.

**Issue 3 — Copying NY’s $1,000,000 TBI rider onto Jungle Fight.**  
**Solution:** Jurisdiction overlay, same as J3 D7. Default: promoter-carries-event-cover, amount **UNKNOWN** outside NV/NY/CA.

**Issue 4 — Labour classification as a difficulty slider.**  
**Solution:** E14. Contested. Scenery.

**Issue 5 — Brand / insurers.** Gagliardi / Cole names on the CSAC promoter form are real vendors.  
**Solution:** Do not ship vendor names as data (standing rule).

---

# Area 4 — The contract terms that outlive one bout

The game negotiates a purse (`FightContract.gd`) and stops there. This area is promotional **term**, not the bout form.

## (a) Decisions coming (named as calls)

1. **Call: multi-bout / exclusivity / champion’s clause / matching rights / options** — published org rules vs reported contracts.
2. **Call: what ends a contract.**
3. **Call: sponsorship conflicts** as an add-on to J3 D15 only.

## (b) Evidence + UNKNOWN

### What is published vs what is only reported

**PFL 2025 World Tournament Rules PDF** (effective 2025-03-01, already J3): single-elimination brackets, 8 weight classes, finals 5×5, miss-weight on a finals bout: **20% of show purse** to the opponent and no title / no champion bonus if the misser wins. Failed drug test after finals → NC, no title, no bonus. That is a **season object**, not an exclusive multi-year promotional term. **PFL exclusive-term length: UNKNOWN** as a primary.

**GLORY Rules 2026 v2** (already J3): title both-make-weight; rankings discretionary. **GLORY promotional-term length: UNKNOWN.**

**IBF Championship Contest Rules / WBC Championship Rules** (already J3): alphabet **mandatories**, interim clocks, purse-offer procedures. **Not in the catalog.** Contrast only. Do not import as house UFC law.

**ONE Championship:** official pages retrieved for this desk (martial-arts / about) do **not** publish a champion-clause duration. Secondary 2023 contract analysis claimed a 24-month / four-fight champion extension and surviving-death image rights — **SECONDARY, not a 2026 ONE primary.** Do not author.

**UFC promotional agreements (SECONDARY, PACER exhibits in D. Nev. 2:15-cv-1045, including a 2013 form and later exhibits):**

- Exclusive worldwide promotional rights during the term.
- Term often structured as **the earlier of** a month-count **or** a bout-count (the widely circulated 2013 form: **40 months after the first bout or 8 bouts**, whichever first). **Do not treat 8/40 as 2026 UFC law.** Current form: **UNKNOWN** as primary.
- **Champion’s clause:** if champion at expiration, term extends until the **later of** one year **or** three additional Zuffa bouts (2013 form).
- **Matching right:** a post-term window in which Zuffa may match a third-party offer (one exhibit: 15 business days to match during a one-year matching period). Exact current days: **UNKNOWN**.
- Exclusive negotiation window after term: reported **60 days** in secondary commentary on those exhibits — **SECONDARY**.

**Zuffa Boxing 2026 contracts** (The Guardian 2026-01-28, SECONDARY): champion extension one year or three bouts; matching six months; medicals “ALL COSTS … PAID BY FIGHTER”; California-training restriction. **Boxing, not catalog.** Scenery, and still not a primary PDF.

**Ali Act `15 U.S.C. § 6307b` (boxing):** coercive option granted **as a condition of taking a fight** unenforceable if **> 12 months**. **Does not cap** freely negotiated multi-year promotional deals that were not a condition of a specific match. **Does not apply to MMA.**

**CA `4 CCR 230(d)`:** “Blanket contracts” or options on a boxer’s services shall not be recognized unless written approval is obtained from the commission.

**NV `NAC 467.102(2)`:** a manager may not contract for a contest **after the management contract expires**. `467.102(4)`: commission will not honor a **manager** contract **> 4 years**. That is the **manager** term, not the promotional term.

### What ends a contract

| End | Published? | Game-honest? |
|-----|------------|--------------|
| Bout-agreement performance (the fight happens / is cancelled per the form) | Yes — that is the bout form | **Yes.** This is what `FightContract` already is |
| Manager-contract expiry | NV max 4 years honored; CA forms have used 3- and 5-year terms in arbitrations (SECONDARY examples, not a cap except 33 1/3%) | **Yes**, if we ever store a manager contract |
| Manager-licence loss | CA `4 CCR 221`; NJ `13:46-6.3`; NV form | **Yes** (E9) |
| Mutual release | Commission practice (CSAC arbitrations) | **Yes** |
| Fighter retirement | **UNKNOWN** as a universal auto-end | Later |
| Failed drug test | Bout result may NC (J3 D9). Promotional-term extension/termination: **UNKNOWN** | Do not auto-extend |
| Fighter licence suspension / injury | Leaked UFC/Zuffa Boxing forms **auto-extend** the term (SECONDARY) | **Do not author** without a primary |
| Champion’s clause | SECONDARY leaked forms | **Do not author** as a default |

### Sponsorship add-on to J3 D15 (do not redo D15)

J3 D15: `outfitting_policy ∈ {house_kit, fighter_sponsors}`. UFC = house kit (Venum through 2029, SECONDARY-confirmed 2026) + Promotional Guidelines Compliance pay. Other 12 promotions: default `fighter_sponsors` unless a primary ban is filed. `Sponsorship.gd:224` is the branch.

**Manager/gym add-on only:**

- Under `house_kit`, there is **no** fight-week patch income for a manager to cut. Compliance pay, if ever authored, is promotion-authored (J3: prefer omit dollars until a UFC primary).
- Under `fighter_sponsors`, a filed manager contract **may** claim a share of those deals. Whether that share sits inside the 33 1/3% **ring-earnings** cap: NV form language is contest/exhibition/performance earnings — **bout** money. Off-cage endorsements **UNKNOWN** as inside the cap.
- Do **not** invent a 20% “sponsor commission.”
- Federation path still: J2 P12 — a governing body does not sell a fight-night package against a card it never promotes.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Bout terms | `FightContract` one card | **Honest as a bout form.** Not a promotional term |
| Title-guarantee clause | 12 weeks (`TITLE_GUARANTEE_WEEKS`) | **Invented** duration (R6); not a champion’s promotional extension |
| Rematch clause | 8 weeks | **Invented** duration |
| Exclusive multi-bout | none | **Absent** — correct for MVP |
| Champion’s clause / matching rights | none | **Absent** — keep absent until a primary |
| Options / blanket contracts | none | **Absent** — CA would not recognize them without approval anyway |
| D15 outfitting | `entity_type` seen; policy flag proposed in J3 | Not this sprint to redo |

## (d) Minimum change

**Do not add a multi-bout / champion-clause / matching-right object. Keep `FightContract` as a one-bout form. On D15 only: if `outfitting_policy=fighter_sponsors` and a filed manager share exists, that share may apply to remaining fighter-side sponsorship cash; if `house_kit`, it does not. Do not invent the %.**

## (e) Issues + solutions

**Issue 1 — “Everyone knows UFC is 8 fights.”**  
**Solution:** 2013 PACER form is **SECONDARY** and **old**. Current primary: UNKNOWN. Do not ship 8/40.

**Issue 2 — Champion’s clause looks like G4’s two-division clock.**  
**Solution:** Different objects. G4 is belt-holding. Champion’s clause is **promotional term**. Do not overload G4.

**Issue 3 — Ali Act 12-month option looking like an MMA rule.**  
**Solution:** E6. Boxing, and only **coercive** options tied to taking a specific fight.

**Issue 4 — Unplayed free-agency career.**  
**Solution:** J2 §6.2. Matching rights without a published duration are scenery.

**Issue 5 — Brand / leaked contracts.** Named athletes on PACER exhibits are real.  
**Solution:** Cite the exhibit class, not the names, as data. Standing rule.

---

# Priority ruling

**Order, next twelve months:**

| Rank | Area | Research or build? | Wait a year? | Scenery? |
|------|------|--------------------|--------------|----------|
| **1** | **Purse destination — athlete is the payee** | **Build** the minimum (E18 / area 1(d)) | No | Manager-agency career = **scenery** |
| **2** | **Clearance that lifts the hold** | **Build** the `clearance` **verb**. **Do not** invent a dollar. **Research later:** payer overlays (NY promoter-billed labs; CA 0.25% ticket assessment) | Research on MRI invoices can wait | Insurance **premium** as a gym debit = **scenery** (it is the promoter’s) |
| **3** | **Desk licence as a flag** | **Build** only if rank 1 pays the gym a manager share (gate the share). **Otherwise wait.** | Yes, except that gate | Licence-exam / second mode = **scenery** |
| **4** | **Promotional terms past one bout** | **Wait a year.** Keep `FightContract` as a bout form. D15 add-on is a one-line share, not a new system | Yes | Champion’s clause / matching rights / Ali Revival UBO = **scenery** |

### Defend

**1 beats 2.** TASK said this is the player’s own role and it outranks a fifth org-side system. That survives contact with the code: `:10200` pays the gym the whole purse. J3 ranked medical hold first because a KO on Saturday and a booking on Monday was the lie the player **felt** — and that hold **already shipped** (correction 1), as a week count. The remaining lie the player feels every settlement is **who got paid**. A clearance verb without a fake MRI invoice is small and honest; it does not outrank paying the person named on the bout form.

**2 beats 3.** The hold exists; J3 D6 already named clearance as the lift. That is a missing **verb** on an object the UI already shows. A manager licence is a missing **flag** that only matters once the gym takes a cut. If rank 1 ships with “no manager contract → gym gets $0 of the purse,” the licence flag can wait — the gym is not taking a cut yet. If rank 1 lets the gym take a filed share, the flag becomes the 10% definition and ships with it.

**3 beats 4.** A licence flag is a primary (NV/CA/NJ/NY publish the classes and the dollars). Multi-bout terms are **reported** (leaked UFC forms, 2013–) and **UNKNOWN** as 2026 primaries for the 13. Inventing an 8-fight champion’s clause would be J3 D14 (PPV %) in a different coat. `FightContract` is already the honest bout form.

**Why promotional terms wait a year.** J2 D6 / R40 still has to **stop paying federations**. That is a bigger money lie than “we have not modelled matching rights.” Cadence (3 bouts a cycle vs 2–3 a year) is still J3’s later economy pass. Champion’s clauses fight G4, Retention, and Ambitions. Do them after the purse lands in the right wallet.

**Why this outranks a fifth org-side system.** A fifth championship widget, a fourth J2 pathway, or an alphabet overlay would still settle into `:10200` and pay the gym. Until that line is honest, org-side work is decorating the wrong ledger.

### What is scenery (as plainly as J2 §5.1)

- **Manager-simulator / agency career / second-as-playable-mode.** Real jobs. Not this game. J2 §6.2. **Show nothing. Build nothing.**
- **Ali Act § 6308 overlay on the catalog.** Real federal law — **for boxing**. The 18 are not boxing promoters. **Omit.**
- **Ali Revival / UBO / Zuffa Boxing.** 2026 legislation, boxing, not enacted as retrieved. **Omit.**
- **Employee classification.** Contested. D. Nev. 2:15-cv-1045 is antitrust. **Cite, do not code.**
- **PPV points.** Already scenery (J3 D14). Not reopened.
- **Olympic IF careers.** Already scenery (J2 §5.1). Not reopened.
- **Invented MRI / camp / gym-cut percentages.** UNKNOWN. **Omit.**

**No fifth area outranks these four.** The closest miss — “should the gym be a promoter of its own local cards?” — is a **new product**, not a missing settlement line. If it ever exists, it takes a **promoter** licence and walks into E8’s firewall. Not MVP.

---

## Test assertions (contracts for a later PR — not written this pass)

Numbered **E19–E34** so they do not collide with operator calls E1–E18 or with J3 D1–D16 / Q1–Q13.

| ID | Assertion |
|----|-----------|
| **E19** | After a bout settles, `gym["cash"]` does **not** increase by the contracted `show_purse + win_bonus + performance_bonus + gate_share`. |
| **E20** | The athlete’s wallet / `career_earnings` receives the bout-agreement money (gross to the contestant named on the form). |
| **E21** | No data file contains a default `manager_cut` / `gym_cut` / `purse_share` **percentage** without an `evidence` field. |
| **E22** | If a manager share is paid, it is **≤** the statutory cap of the tagged jurisdiction (NV/CA: 33 1/3% of ring earnings; NY: combatant still receives ≥ 50% after authorized deductions). |
| **E23** | If no manager contract is filed, the gym’s delta from that purse is **0**. |
| **E24** | A gym taking ≥ 10% (NV/NJ) or > 10% (CA) of gross purse is treated as a **manager**, not as a second “gym cut.” |
| **E25** | Promoter-side taxes (`NRS 467.107` 8% gate, `BPC 18824`) are **not** deducted from the fighter purse. |
| **E26** | No bout record applies Ali Act `§ 6308` to an MMA / kickboxing / Muay Thai / karate org in the 18. |
| **E27** | `medical_hold` still refuses booking while `current_week < medical_hold_until_week`. No second hold object is added. |
| **E28** | A `clearance` path can lift the hold. No `mri_cost_usd=` invented constant exists without `evidence`. |
| **E29** | Event insurance, if present, is a promoter/event flag and is **not** added to `gym["cash"]`. |
| **E30** | No `employment_status` mechanic changes purse polarity. |
| **E31** | No champion-clause month/bout extension and no matching-right day count exist in data without a primary cite. |
| **E32** | `Sponsorship` `outfitting_policy=house_kit` still cannot attach a fighter patch on fight week (J3 Q10). A manager share cannot attach to a patch that D15 already forbids. |
| **E33** | J2 P1–P3 still hold (federations: no purse, no signing). R40 is not reopened. |
| **E34** | No test fixture uses a real manager’s, official’s, athlete’s, or executive’s name as data. |

---

## Source list (live verification 2026-09-06)

**Primary / official (preferred):**

- `real_organizations.json` (`snapshot_date` 2026-09-01)
- J1 — `J1_ORGANIZATION_RULES_AND_JUDGES.md` (cited, not re-litigated)
- J2 — `J2_THE_FEDERATION_PATHWAY.md` (§2.6 money-flow, D5 amateur door, D6 / R40, §5.1 scenery, §6.2 unplayed-mode)
- J3 — `J3_THE_DECISION_QUEUE.md` (D1–D16, Areas 1–3, D13/D14/D15, source list reused where still current)
- `GameState.gd.excerpt.txt` (`:10200` settlement, `:10204` career_earnings)
- `FightContract.gd.excerpt.txt` (`:94`, `:147`, `:199`, `:215-233`)
- `BodyReadiness.gd.excerpt.txt` (`:34-43`, `:118`)
- `Sponsorship.gd.excerpt.txt` (`:224`)
- `body_readiness_rules.json` (`medical_hold_weeks`)
- 15 U.S.C. § 6301 (definitions — boxing match): https://www.law.cornell.edu/uscode/text/15/6301
- 15 U.S.C. § 6307b (coercive contracts, boxing): https://www.law.cornell.edu/uscode/text/15/6307b
- 15 U.S.C. § 6307e (promoter disclosures, boxing): https://www.law.cornell.edu/uscode/text/15/6307e
- 15 U.S.C. § 6308 (conflicts / promoter–manager firewall, boxing): https://www.law.cornell.edu/uscode/text/15/6308
- Nevada NAC 467 chapter (rev. listed 2026-04-13): https://www.leg.state.nv.us/nac/NAC-467.html
- NAC 467.012 (licence fees; manager $100, second $50, matchmaker $100, combatant $50; calendar remainder): https://www.law.cornell.edu/regulations/nevada/NAC-467-012
- NAC 467.052 (promoter $750 / amateur boxing promoter $25): https://www.leg.state.nv.us/nac/NAC-467.html
- NAC 467.057 (manager may act as second without a second’s licence)
- NAC 467.102 (manager contract; 4-year honor limit; **33 1/3%** ring-earnings cap; self-signing if no manager): https://www.law.cornell.edu/regulations/nevada/NAC-467-102
- NAC 467.104 (promoter may not act as manager / hold management interest): https://www.law.cornell.edu/regulations/nevada/NAC-467-104
- NAC 467.112 (bout agreement promoter ↔ unarmed combatant): https://www.law.cornell.edu/regulations/nevada/NAC-467-112
- NAC 467.137 (pay combatant in full; manager share only with approval): https://www.law.cornell.edu/regulations/nevada/NAC-467-137
- NAC 467.142 (purse immediately after; ≤ **10%** expense withhold): https://www.law.cornell.edu/regulations/nevada/NAC-467-142
- NAC 467.149 (promoter insurance **$50,000** / amateur **$25,000**; no contestant deductible): https://www.law.cornell.edu/regulations/nevada/NAC-467-149
- NRS 467.107 (promoter **8%** of gross admissions; drug-testing credit): https://www.leg.state.nv.us/Nrs/NRS-467.html
- NRS 467.120 (contestant entitled to written contract; impound gate)
- NRS 467.125 (commission may require **$50,000+** medical insurance): https://nevada.public.law/statutes/nrs_467.125
- NSAC Official Bout Agreement (O-460): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/Renewal/O-460_BOUT_AGREEMENT.pdf
- NSAC boxer/manager contract notes (max 4 years; max 33 1/3%): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/faq/Boxer-Mgr_contract_web.pdf
- NSAC promoter checklist (insurance $50,000; promoter pays deductible; drug testing promoter cost): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/Renewal/PROMLISTWEB1-COVID_41822.pdf
- NSAC insurance memo (fighter files the claim): https://boxing.nv.gov/hottopics/insurance_memo
- California `4 CCR 215` (manager acting as second): https://www.law.cornell.edu/regulations/california/4-CCR-215
- California `4 CCR 218` (manager/second exam)
- California `4 CCR 221` (contracts; **33 1/3%** cap; licence-loss voiding): https://www.law.cornell.edu/regulations/california/4-CCR-221
- California `4 CCR 230` (official form; itemized deductions; blanket contracts/options need approval): https://www.law.cornell.edu/regulations/california/4-CCR-230
- California `4 CCR 290` (promoter short-term medical insurance; promoter pays deductible): https://www.law.cornell.edu/regulations/california/4-CCR-290
- California `4 CCR 213` (promoter $50,000 liquid assets / bond; Rule 290 compliance)
- BPC 18628 (manager definition, **> 10%** of gross purse): https://california.public.law/codes/business_and_professions_code_section_18628
- BPC 18653 (pro trainer licence; trainer in the corner): https://california.public.law/codes/business_and_professions_code_section_18653
- BPC 18711 (neurological exams; costs from assessments on promoters/managers/athletes): https://california.public.law/codes/business_and_professions_code_section_18711
- BPC 18804 / 18806 / 18809 / 18810 / 18811 / 18817 (promoter $1,000; matchmaker $200; fighter $60; manager $150; second $50; gymnasium fee shall not exceed $200)
- BPC 18849 (promoter interest in a fighter; written CSAC approval): https://california.public.law/codes/business_and_professions_code_section_18849
- CSAC manager application (fee $150; financial-interest question): https://www.dca.ca.gov/csac/forms_pubs/forms/manager_app.pdf
- CSAC promoter application (medical insurance $50,000 boxers and martial arts; promoter pays deductible): https://www.dca.ca.gov/csac/forms_pubs/forms/promoter.pdf
- N.J.A.C. 13:46-4.25 (licence fees: manager $25, second $25, matchmaker $100, promoter $300, combatant $5): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-4-25
- N.J.A.C. 13:46-6.2 (manager may not second unless licensed as second)
- N.J.A.C. 13:46-6.3 (loss of manager licence / contract recognition)
- N.J.A.C. 13:46-6.4 (manager **≤ 33 1/3%** of boxer’s ring earnings): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-6-4
- N.J.A.C. 13:46-6.6 (suspended manager: no corner, no negotiating): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-6-6
- NJSACB licensing page (manager/second applications; bout and boxer-manager agreement blanks): https://www.njoag.gov/about/divisions-and-offices/state-athletic-control-board-home/licensing/
- 19 NYCRR 206.5 (licences required): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-206.5
- 19 NYCRR 207.9 (licensed managers as seconds — own combatant)
- 19 NYCRR 208.15 (promoter insurance $50k / $50k death / $1M TBI): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-208.15
- 19 NYCRR 208.19 (manager forbidden to act as matchmaker): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-208.19
- 19 NYCRR 208.23 (matchmaker not to act as manager): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-208.23
- 19 NYCRR 209.12 (combatant receives ≥ 50% of ring earnings after authorized deductions)
- 19 NYCRR 209.13 (promoter pays the combatant by cheque)
- NYSAC licence fee schedule: https://dos.ny.gov/license-fee-and-term-schedule-new-york-state-athletic-commission
- NYSAC second/trainer or matchmaker: https://dos.ny.gov/professional-combative-sport-secondtrainer-or-matchmaker
- NYSAC Medical Manual (May 2024): promoter bears certain medical-testing costs: https://dos.ny.gov/system/files/documents/2024/05/nysac-medical-manual-5-8-2484.pdf
- ABC model bout / boxer-manager contracts: https://www.abcboxing.com/boxer-and-bout-sample-contracts/
- ABC medical requirements by commission: https://abcboxing.com/medical-requirements-by-commission/
- PFL 2025 World Tournament Rules PDF (already J3): https://pflmma-prod.s3.us-east-1.amazonaws.com/assets/rules/2025_PFL_World_Tournament_Rules_and_Regulations_as_of_3_1_2025.pdf
- PFL 2025 World Tournament announcement: https://pflmma.com/news/pfl-announces-2025-world-tournament
- IMMAF athlete eligibility (already J2): https://immaf.org/athletes/athlete-eligibility/
- GLORY Rules 2026 v2 (already J3): https://glory.pinkyellow.network/assets/rules/glory-rules-2026-v2.pdf
- IBF Championship Contest Rules June 2025 (already J3): https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf

**Secondary (labelled in body):**

- TKO Group Holdings Form 10-Q (period ended 2026-03-31): https://www.sec.gov/Archives/edgar/data/1973266/000119312526208992/tko-20260331.htm — D. Nev. 2:15-cv-1045 $375 million settlement approved 2025-02-06, paid by June 2025; follow-on antitrust dockets — **antitrust, not employee classification**
- PACER exhibits in D. Nev. 2:15-cv-1045 and 2013 promotional-agreement text (exclusive term, champion’s clause, matching right) — **leaked / filed contracts, not a 2026 UFC.com bylaw**
- The Guardian 2026-01-28 (Zuffa Boxing contract terms; medicals paid by fighter) — boxing, not catalog
- The Athletic 2026-03-24 (Ali Revival Act explainer)
- Sports Business Journal 2025-06-03 / 2026 coverage of follow-on UFC antitrust filings
- MMA Fight Bible 2026-05-18 “How UFC Fighter Contracts Work” — **CUSTOMARY journalism, do not wire**
- Grounded MMA “How Much Do MMA Managers Make” — **CUSTOMARY 5–20%, do not wire**
- Bangkok Post 2026-07-23 (gym cut of a ONE purse) — **reported private arrangement**
- Boxing Insider 2026-03-30 (MRI cost ranges) — **not a fee schedule**
- CSAC arbitration PDFs (commission-form manager % examples: 16 2/3, 18, 25, 30) — **case-specific, not a default**, and **do not use the named parties as data**

**Not retrieved / do not fake:**

- A 2026 UFC promotional-agreement **primary PDF** (bout count, champion’s clause, matching days)
- ONE / GLORY / RIZIN / Jungle / LUX / ROAD / Kunlun / ARES / URCC / RWS / Karate Combat **exclusive-term** or **camp-cost** tables
- MMA-specific **4 CCR** restatement of the 33 1/3% manager cap (boxing chapter retrieved; MMA article not)
- MMA-specific **N.J.A.C.** manager % (boxing `13:46-6.4` retrieved; MMA subchapter restatement not)
- NY MMA **combatant** licence dollar if different from boxing $10
- Current CA gymnasium licence **exact** dollar (`BPC 18817` ceiling $200 vs `4 CCR 208` $10)
- Post-KO **MRI / neuro invoice** payer as a single NV/CA/NJ/NY rule
- Event-insurance schedules for ONE / RIZIN / GLORY / RWS
- A published **gym-of-purse** percentage for any catalog org
- Ali Revival / UBO **enacted** text as of 2026-09-06 (bills and reports retrieved; enactment **UNKNOWN**)
- Venum / UFC outfitting **primary PDF** (already J3: do not fake)
- UFC PPV point % (already J3: do not fake)

---

*End of J4. Cut from the Decisions page and from the priority ruling. R40 remains J2 D6 (stop paying federations). J3 Areas 1–3 are not reopened. The hold already exists; do not add another. Pay the person named on the bout form.*
