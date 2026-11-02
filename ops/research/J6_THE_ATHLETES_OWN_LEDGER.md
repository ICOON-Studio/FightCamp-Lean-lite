# J6 — The Athlete's Own Ledger: What Comes Out of the Purse

**Desk:** John (research)  
**Date:** 2026-09-06  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design. No second career mode (J2 §6.2). No manager-simulator. No tax sim.  
**Local snapshot used:** `J3_THE_DECISION_QUEUE.md`; `J4_THE_DESK_AND_THE_CUT.md`; `J5_THE_GYMS_OWN_LEDGER.md`; `GameState_settlement.excerpt.txt` (R43 payee at `:10363`–`:10364`; `get_athlete_cash()` at `:10275`; TASK/J5 still name the settlement *site* as `:10253`); `FightContract.full.txt` (`TRAVEL_COST` / `ACCOMMODATION_COST` `:59`–`:60`; `settlement_for` `:219`–`:239`; `payee_split` `:305`–`:337`). Line numbers are from this workspace excerpt.

**Cite, do not re-litigate:** J1 (UNKNOWN policy, §4.1 brand). J2 (three **entry/money** pathways, money-flow table §2.6, D5 amateur→pro door, D6 / R40, §5.1 scenery, §6.2 unplayed-mode, §6.3 no invented numeric default). J3 (Decisions D1–D16, Areas 1–3, D13/D14/D15, priority ruling). J4 (E1–E18, E23 default, E2 caps, E4 corner payer, E5 statutory-vs-CUSTOMARY deductions, E25 promoter-side taxes). J5 (G1–G18, G24 no sport-wide dollar, G11–G13 gym is not a published corner payee, **priority ruling**). **Do not reopen R40, J3 Areas 1–3, J4 E1–E3, or J5’s priority ruling.** Caps, payee, the 10% manager definition, and “the gym lives on the floor, not the purse” stand.

**UNKNOWN policy (same as J1–J5):** a fee, a period, a percentage, a cap, or a formula that is not in a primary statute, regulation, commission form, or an organization’s own published page is **UNKNOWN**. Never invent one. Inherited practice is **INHERITED** / **CUSTOMARY**, not a published rule. National overlays are **NATIONAL**. A gym’s own posted rate is **primary for THAT gym**, not for the sport. No real gym’s, manager’s, official’s, athlete’s, or executive’s name as data.

**No fifth area.** After the four, a playable tax-withholding career, a licence-exam RPG, or a trainer-percentage simulator is **scenery**, not a fifth research track. See A6 / A12 and the priority ruling. J2 §6.2 / J4 E7 / J4 E9 / J5 G7 stand.

---

## Why this exists

R43 shipped J4’s rank 1: the payee is the athlete. The bout-agreement money — show purse, win bonus, performance bonus, gate share — now lands in `athlete["cash"]` instead of the gym’s account (`GameState` excerpt `:10363`–`:10364`). J5 then answered the other half, what the *gym* lives on, and refused to invent a `gym_cut` to fill the hole.

That leaves one question nobody has asked: **the athlete now holds the money, so what comes out of it before it is theirs, and which of those deductions is published anywhere?**

Today the settlement subtracts a single opaque `expenses` integer and calls it done. If that term is a silent commission cut, a silent tax, or a silent trainer take, the game is lying in a new place — the same defect J4 found on the gym side, moved one seat over.

This pack names that integer, then asks four honest questions about everything else that might come off a combatant’s purse: what the commission itself takes at the event, whether anyone withholds tax at the table, what fighter-side people are paid from the same purse and in what order, and what the athlete pays *between* bouts.

**The true answer is smaller than a manager game would like.** Most of the deduction side is unpublishable. “Nothing is published, ship nothing” is acceptable here, exactly as it was in J5.

---

## Decisions page (operator calls)

This page is what the next research/build cuts from. One recommendation, one line why. Numbered **A1–A18** so nothing collides with J3 D1–D16, J4 E1–E34, or J5 G1–G34.

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| **A1** | What is the live opaque `expenses` term? | **Uncovered travel + uncovered accommodation.** `FightContract.settlement_for` builds it from `travel_cost` / `accommodation_cost` when the coverage flags are false. Defaults `TRAVEL_COST` **450** and `ACCOMMODATION_COST` **300** (invented). The file’s own comment at `:302` names it. It is **not** a commission take, a tax, a trainer cut, or a gym cut. | Pre-read confirmed against `FightContract.full.txt`. The most valuable line in this pack. |
| **A2** | Contestant licence as a settlement skim? | **Do not skim it off the purse as a silent global.** Licence fees are paid **by the licensee**, on a calendar / twelve-month / fiscal-year card, not as a published per-bout tax. A NY rider *may* recoup that year’s fee from that purse if the box is checked and initialled — that is optional itemization, not a commission levy. | NV `NAC 467.012(8)` remainder of calendar year; CA `BPC 18809` + `18822` twelve months; NJ `13:46-4.25(b)` $5; NY boxing $10 / MMA $50. E7 table, restated as *payer*, not re-derived as a cap. |
| **A3** | Per-bout contestant fee? | **Not retrieved** in NV / CA / NJ / NY as a second charge on top of the annual/term licence. Officials’ per-event fees are **promoter-side** (NYSAC officials’ schedule; NJ inspector/announcer notes). Do not author a per-bout combatant tax. | Four-jurisdiction search this pass: licence is a *card*, not a ticket stub. |
| **A4** | Does the commission withhold its own cut from the purse? | **No published global.** Combatant is paid **in full on the bout agreement** (NV `467.137(1)`; CA `4 CCR 232`; NJ `13:46-5.11`; NY cheque to the combatant `209.13`). What *may* come off is **itemized and approved**, not a commission percentage of purse. Promoter gate/broadcast taxes are **promoter-side** (E25). | The thing the statutes exist to stop is a kickback back to the promoter (`467.137(1)`; CA `232`). Inventing a “commission cut” would be that kickback under a new name. |
| **A5** | Licence dollars — print vs live | **Cite the live section. Mark UNKNOWN where print and live disagree** (same call as J5 G5). Combatant: NV **$50** calendar remainder; CA **$60** twelve months; NJ **$5**; NY boxing **$10**, MMA **$50**. NY boxing *term*: fee-schedule page still says expires 1 Oct; `19 NYCRR 207.4` says licences after 1 Sep 2018 expire one year after issuance — **term UNKNOWN** between those two texts. | J4 left NY MMA combatant as UNKNOWN. Live `dos.ny.gov` schedule + combative-sport-professional page both print **$50** / one year from issuance (`GBL § 1007(3)(b)`). That UNKNOWN is now a number. |
| **A6** | Tax withholding at the event — ship a %? | **Show nothing as a settlement line.** A tax model is **scenery**. CA **7%** nonresident withholding is real (`R&TC 18662`; `18 CCR 18662-6` names boxers) and is a **promoter / venue withholding-agent** duty, not a CSAC levy. NV has **no** state income tax. NY / NJ state withholding on an independent-contractor combatant is **not** a clean commission table. Federal **30%** NRA is IRS, residency-gated, treaty-reducible. | Inventing a flat 20–30% “tax” is the manager-game lie this desk exists to stop. Publishable ≠ shippable. |
| **A7** | Flat % in other manager games | **Do not author one.** Those percentages are gameplay, not ABC, not NAC, not CSAC, not IRS. | Same discipline as J4 E2 (cap ≠ default) and J3 D14 (PPV %). |
| **A8** | Resident vs nonresident | **If ever shown, it is a flag, not a sim.** CA 7% applies to **nonresidents** above **$1,500**/year California-source; residents are carved out (`18 CCR 18662-6(c)`). Building a residency / duty-day / treaty engine is a second product (J2 §6.2). | Duty-day rules retrieved this pass (`20 NYCRR 132.22`; `N.J.A.C. 18:35-5.1`) are for **team** athletes, not a commission bout form. |
| **A9** | Order when manager + trainer + state hit one purse | **Statutory first, CUSTOMARY never stacked as a default.** Bout-agreement gross → authorized / itemized deductions (only if on the form) → filed manager share (E2 cap, G6 gates) → combatant receives the rest, subject to NY **≥ 50%** floor (`209.12`) and NY **$150** minimum (`209.11`) / CA **$100**/round (`4 CCR 232(b)`). Trainer / cutman / seconds are **private** unless itemized. | No retrieved statute sequences “manager 33% then trainer 10% then cutman 3% then tax 7%.” |
| **A10** | Ceiling on that stack | **Store the published floors and caps. Do not author a trainer %.** A trainer taking ≥ 10% (NV/NJ) or > 10% (CA) of the **gross purse** for contest-related services **is a manager** (J4 E3) and Area 2 of J5 applies. CUSTOMARY “10% trainer / 2–3% cutman” is journalism. | Stacking invented percentages would blow the NY 50% floor. That is information, not a reason to invent the stack. |
| **A11** | Corner / seconds / cutman as a purse line | **Do not reopen J4 E4 or J5 G11–G13.** Payer is fighter/manager, not a promoter statutory wage. Gym is not a published payee. Do not author 2%, 3%, or 10%. | Already ruled. This pack asks *order and ceiling*, not who the gym invoices. |
| **A12** | Licence renewal between bouts | **Requirement is real; a licence-RPG is scenery** (J4 E7). If a later data file debits `athlete["cash"]` for a tagged event-state card, it needs `evidence` pointing at that state’s live fee. Do not invent a sport-wide annual. | Fees are small and calendar-shaped. They do not outrank J5’s membership object. |
| **A13** | Mandated medicals — requirement vs price | **Store the requirement. Do not author a price.** Blood / dilated eye / MRI-or-MRA / EKG / physical are **published as tests**. Commission pages do **not** publish a dollar. J5 **G24** holds: no sport-wide dollar without `evidence`. | J4 E12 already: do not invent an MRI invoice. Boxing Insider $500–$1,500 is SECONDARY. |
| **A14** | Who pays those medicals | **Mixed; do not invent a single payer.** NV NSAC MRI/MRA order form is captioned **“Patient Responsible for Payment.”** NY Medical Manual 2024: certain testing costs **borne by the promoter**; ABC page: NY blood work billed to the promoter. CA neurological exams funded by a **promoter ticket assessment** of **0.25%** of gross ticket sales (`4 CCR 280(i)`; `BPC 18711`). | Requirement ≠ invoice. Payer field, if ever authored, needs `evidence`. |
| **A15** | Gym membership from the athlete’s side | **Mirror J5 G1 / G3 / G24.** After R43 the athlete has a wallet, so a gym-authored membership line *could* debit `athlete["cash"]` and credit `gym["cash"]` — **only** with `evidence`, or omit. Do not author a sport-wide monthly. | Same object as J5 rank 2, other face. Not a new deduction system. |
| **A16** | Does any of this outrank J5 rank-2 membership? | **No.** See priority ruling. The expenses rename is a one-line honesty pass on an existing object. Commission / tax / trainer skims do not ship. Athlete-side dues *are* J5 rank 2. | J5’s priority is not reopened. The gym still has to live on something after R43. |
| **A17** | Should `expenses` survive? | **Survive as a named logistics debit** (uncovered travel / accommodation), labelled **invented magnitude**, promoter opens covering (so sign-as-offered nets **0**). **Do not** survive as an opaque bucket that looks like a commission cut. **Do not** replace it with a fake commission % or a fake tax %. | Honest **shape** (J4 E5 / E13). Dishonest **label**. The dollars were always invented. |
| **A18** | **Minimum change** (this study’s D16 / E18 / G18) | Four one-liners — see each area’s (d). Build order is the priority ruling, not a fifth system. | Stops the new lie (opaque `expenses`) without a tax sim and without inventing trainer percentages. |

**Fifth area?** No. A playable withholding / licence / trainer-cut career would be a new mode. It does not outrank naming what `expenses` already is, and it does not outrank J5’s membership object. Park it as scenery (priority ruling).

---

## File-level anchors (what is live vs this study)

| File / fact | Role | Live? | Honesty |
|-------------|------|-------|---------|
| **`GameState.gd:10253` (TASK / J5 site)** | Outer-function return; settlement *key* in this excerpt | LIVE (excerpt) | Line numbers moved when R43 comments landed. The **payee assignment** in this excerpt is `:10363`–`:10364`, not `:10253`. Cite both. |
| **`GameState.gd:10363` `payee_split(...)`** | `FightContract.payee_split(purse + win_bonus + performance_bonus + gate_share, expenses, _manager_contract_for(athlete))` | LIVE (excerpt, R43) | Honest **destination** (E1). `expenses` is still an opaque int on this line. |
| **`athlete["cash"]` `:10364`** | Wallet credit `+= payee["athlete"]` | LIVE (R43) | Honest **payee**. What was subtracted to get there is this pack. |
| **`get_athlete_cash()` `:10275`** | Accessor; missing field reads **0** | LIVE (R43) | Additive; old saves do not re-split history. |
| **`gym["cash"]` `:10365`–`:10366`** | Credits only `payee["gym"]` if nonzero | LIVE (R43) | E23 default: no filed manager contract → **0**. Do not reopen. |
| **`career_earnings` `:10372`** | `+= purse + win_bonus + performance_bonus + gate_share` (**not** minus `expenses`) | LIVE | Honest as a **lifetime counter of bout-agreement money**. It is not the wallet (R43 comment). Weight-fine already came off `purse` at `:10334`. |
| **`FightContract.settlement_for` `:219`–`:239`** | Builds `expenses` from uncovered travel + accommodation; returns `net = show + win + perf + gate − expenses` | LIVE | **This is the opaque term.** Honest **object** (logistics). Invented **magnitude**. Dishonest **name** at the GameState call site, where it reads as a mysterious skim. |
| **`TRAVEL_COST` `:59` = 450; `ACCOMMODATION_COST` `:60` = 300** | Defaults when terms omit a number | LIVE | **Invented.** File comment `:52`–`:58`: promoter opens covering both so sign-as-offered “nets exactly the purse… with no new hidden tax.” |
| **`travel_covered` / `accommodation_covered`** | Opening **true** (`opening_terms` `:174`–`:175`) | LIVE | Honest **shape** of a bout-agreement logistics clause (E4 / E13). Coverage clawed back only if the player pushes the money axis. |
| **`payee_split` `:305`–`:337`** | Manager share off **gross**; then `athlete = gross − manager_share − expenses`; NY floor uses `gross − expenses − keep_min` | LIVE | Caps stored, not re-derived (E2). Expenses come off the **athlete**, not the gym. No promoter-side tax (E25, comment `:303`–`:304`). |
| **`_manager_contract_for` `:10264`** | Filed contract or `{}` | LIVE | E23 seam. Nothing in the game files one yet. |
| **Weight-miss `fine_fraction`** | Comes **off `purse`** before `payee_split` (`:10334`–`:10335`) | LIVE | Already J3 D11. Not this pack. |
| **Contestant licence fee debit** | — | **Absent** | Honest omission of a small, separate, calendar-year payment — **unless** a later file authors it with `evidence`. Do not invent a skim. |
| **Commission % of purse** | — | **Absent** | **Honest omission of a non-rule** (A4). Do not add one. |
| **Tax withholding line** | — | **Absent** | **Honest omission.** A6: keep it absent. |
| **Trainer / cutman / seconds %** | — | **Absent** | **Honest omission of CUSTOMARY journalism** (A10 / E4 / G11). |
| **Between-bout medical invoice** | — | **Absent** | Honest. Requirement exists in the world; price is UNKNOWN (E12 / A13). |
| **Athlete-side membership debit** | — | **Absent** | J5 rank 2, other face. No sport-wide dollar (G24). |
| R40 / `get_promotion_bout_offer` | Federations still payable as promotions until R40 | LIVE (J2) | **Not this sprint.** J2 D6 stands. |

### The most valuable line in this pack

**The live `expenses` integer is the fighter’s own uncovered travel and accommodation. It is not a commission take.**

Where it comes from:

1. `FightContract.opening_terms` sets `travel_covered = true`, `accommodation_covered = true`, `travel_cost = TRAVEL_COST` (**450**), `accommodation_cost = ACCOMMODATION_COST` (**300**).
2. `settlement_for` (`:225`–`:229`) starts `expenses` at **0**. If `travel_covered` is false, it adds `travel_cost` (default 450). If `accommodation_covered` is false, it adds `accommodation_cost` (default 300).
3. `GameState._apply_fight_result` (`:10309`, `:10318`) reads that int. Bouts **without** signed terms leave `expenses = 0`.
4. `payee_split` (`:335`) returns `"athlete": gross - manager_share - expenses`.
5. The comment at `FightContract` `:301`–`:304` already says this: *“`expenses` is the fighter’s own uncovered travel and accommodation, which come off the fighter’s side (J4 E5). No promoter-side tax is deducted here; none exists, and none may be invented (E25).”*

What published thing backs the **object**: a bout-agreement logistics clause. Promoters covering travel/hotel is the opening shape of this game and of CUSTOMARY commissioned cards (E13). The NYSAC Official Bout Contract Rider for professional MMA (DOS-2072-f, Rev. 10/20, verified 2026-09-06) has an optional, initialled line **“Airfare/Travel Expenses.”** NV `NAC 467.142(4)` lets a *promoter* withhold ≤ **10%** of purse for the combatant’s expenses and reconcile in five working days — a **different** object (promoter float, not a game debit of 450+300).

What published thing backs the **dollars 450 and 300**: **nothing.** They are game-authored. J2 §6.3.

**Should it survive?** The **object** yes — named, labelled invented, promoter-opens-covering so the economy’s sign-as-offered path still nets the purse. The **opaque name** no — at `:10363` it reads as the new lie (a mystery skim). Do not replace it with a commission %, a tax %, or a trainer %. Do not treat `NAC 467.142(4)`’s 10% as a default take; that section is a *ceiling on a promoter float*, with combatant approval or a detailed reconciliation, not a 10% tax.

---

# Area 1 — What the commission itself takes at the event

Contestant licence fees, any per-bout fee, and whether anything is withheld from the purse **by the commission** rather than paid separately. NV `NRS`/`NAC 467`, CA `BPC` / `4 CCR`, NJ `N.J.A.C. 13:46`, NY `19 NYCRR`. Mark dollars UNKNOWN where print and live disagree (J5 G5).

## (a) Decisions coming (named as calls)

1. **Call: contestant licence at the table.** Annual/term card paid by the licensee, or a silent purse skim.
2. **Call: per-bout contestant fee.** Exists in the four jurisdictions, or not retrieved.
3. **Call: commission withhold of its own cut.** Global percentage, itemized-only, or none.
4. **Call: print vs live dollars.** Which figures are live; which are UNKNOWN between texts.

## (b) Evidence (cited) + UNKNOWN discipline

### Licence fees — combatant pays the commission for a *card*, not for a *bout*

Re-verified 2026-09-06. Term is as published. Do not invent a “per bout” duration where the text is calendar / twelve-month / fiscal year. **J4 E7 table is cited, not re-derived as a manager-desk question;** this pack restates the **combatant** row as an *athlete-ledger* cost.

| Role (combatant) | Nevada | California | New Jersey | New York |
|------------------|--------|------------|------------|----------|
| **Fee** | **$50** professional boxer / MMA / kickboxer / other unarmed combatant (`NAC 467.012(8)(a)–(d)`, live NV legislature chapter rev. listed 2026-04-13; Cornell LII same) | **$60** professional boxer, kickboxer, or martial-arts fighter (`BPC 18809`, still $60 on 2026-09-06; CSAC professional-athlete application prints Application Fee: $60) | **$5** boxer’s licence or mixed martial artist’s licence (`N.J.A.C. 13:46-4.25(b)`) | Boxing **$10** (`GBL § 1007(3)(a)` / Uncons. Laws § 8910; `dos.ny.gov` fee schedule). MMA **$50** (`GBL § 1007(3)(b)`; same schedule; combative-sport-professional page, verified 2026-09-06: “$50.00 Mixed Martial Artist License application fee”) |
| **Term** | Remainder of the **calendar year** unless the Commission limits it shorter (`467.012(9)`). Full renewal fee even if limited (`467.012(10)`); no second fee in the same calendar year if the limitation is later removed | **12 months** from issuance, last day of the 12th month (`BPC 18822(b)`, licences on or after 1 Jan 2007). Renewal needs the medicals | Subsection **(a)** licences (manager, second, promoter, …) are **fiscal year** 1 Jul–30 Jun. Subsection **(b)** states the $5 combatant fee and does **not** restate the period in the same sentence. J4 treated combatant as fiscal. **Do not invent a per-bout.** | Boxing: fee-schedule page still prints **Expires Oct. 1st**. `19 NYCRR 207.4(a)`: licences issued prior to 1 Sep 2018 expired 30 Sep; **thereafter annual, expire one year after issuance**. MMA: **1 year from issuance** (`207.4(b)`; schedule agrees). **Boxing term UNKNOWN** between the schedule page and `207.4` — same discipline as J5 G5 |

**An archived `NAC 467.012` still circulating online prints combatant $25.** Live chapter (nv.us, 2026-04-13) prints **$50**. Use live. Do not wire $25.

**Federal / national ID** (ABC boxing federal ID; MMA national ID) is a **registration card**, not a state licence, and NSAC issues the boxing federal ID at **no cost** on the 2026 contestant page (boxing.nv.gov/licensing/Boxer). Not a purse skim.

**Second / manager licences** remain E7 / J5 Area 2 (the *desk*). They are not this athlete’s settlement line unless a NY-style rider recoups them (below).

### No retrieved per-bout contestant fee

What *is* per-event in these jurisdictions is **officials’ compensation**, paid **by the promoter** (NYSAC combative-sports-officials fee schedule, boxing and MMA combined-purse tables; NJ SACB promoter package: inspector fee noted as $70, announcer negotiated). That is promoter cost, not a combatant debit.

**UNKNOWN (do not invent):** a per-bout contestant levy in NV / CA / NJ / NY on top of the term licence; Texas / other catalog-event states; host-nation per-bout fees on ONE / RIZIN / RWS / GLORY cards.

### What may come off the purse — itemized, not a commission percentage

The four jurisdictions pay the **contestant named on the bout form**. Deductions are a **permission structure**, not a commission tax.

| Jurisdiction | Paid in full? | What may be withheld / deducted | Who holds the pen |
|--------------|---------------|---------------------------------|-------------------|
| **Nevada** | `NAC 467.137(1)` (verified 2026-09-06): paid in full on the bout agreement; no part returned through the manager to a matchmaker or promoter except as that section allows | (1) Promoter advances under `467.127`. (2) Promoter may withhold **≤ 10%** of purse for the combatant’s expenses; reconciliation to the Commission in **5 working days**, with combatant written approval **or** a sufficiently detailed explanation; Chair may extend ≤ 30 days (`467.142(4)`). (3) Manager share **with combatant approval** if the contract specifies it and complies with `467.102` (`467.137(3)`). (4) Dispute: Commission may withhold the amount in dispute or deposit it with the court (`467.137(4)`). (5) **Disciplinary** retain: a Commissioner may specify an amount transferred from promoter to Commission pending `NRS 467.158` penalty (`467.147`) — **not a fee schedule** | Promoter (expense float); Commission (dispute / discipline); combatant initials (manager) |
| **California** | `4 CCR 232(a)` (verified 2026-09-06): paid in full according to contract; no part withheld except by order of a commission representative; no kickback to matchmaker / club official. Floor: contracted purse **not less than $100 per round** (`232(b)`) | Deductions **only if** the amount is **clearly specified and itemized** in the club–boxer contract; commission may **disallow** if not specific enough (`4 CCR 230(c)`). Assignment of a share needs commission approval, written request **≥ 72 hours** before (`232(a)`). Self-sign / full purse if no licensed manager (`4 CCR 221(b)`) | Itemized on the bout contract, or not at all |
| **New Jersey** | `N.J.A.C. 13:46-5.11` (verified 2026-09-06): “A promoter shall pay the boxer the **full purse** specified in the contract.” | Manager ≤ **33⅓%** of ring earnings with a **properly filed** contract (`13:46-6.4`) — already E2, not re-derived. No retrieved “commission % of purse” section this pass | Promoter pays the contracted purse |
| **New York** | `19 NYCRR 209.13` (verified 2026-09-06): promoter pays **by cheque payable to the participating combatant**; no third-party payment unless the Commission approved the transaction. `209.11`: minimum **$150** after **approved** purse deductions. `209.12`: combatant actually receives **≥ 50%** of ring earnings after **authorized** purse deductions | **Optional, initialled, Commission-approved rider.** MMA form DOS-2072-f (Rev. 10/20, verified 2026-09-06) §5: purse minus authorized deductions and distributions, paid to the combatant, **unless** on a Rider signed by the parties **and approved by the Commission**. Rider §2 “PURSE DEDUCTIONS BY PROMOTER **(OPTIONAL)**”: Combatant’s Licence **($50.00)**; Seconds’ Licences/Permits **($40.00/Licence)**; Manager’s Licence/Permit **($50.00/Licence)**; Medicals — Annual Physical / Blood Work / Drug Testing / Other **(TBD)**; Training Expenses; Taxes/Federal Withholdings **(Must Be Checked for Foreign Combatant)**; Airfare/Travel Expenses; Other. Combatant **remains solely responsible** for manager fees; third-party distributions are a separate optional block | Rider + Commission approval. Blanks are not defaults |

**Ruling on A2 / A3 / A4.** A contestant licence is a **small term fee the athlete (or someone recouping on a rider) pays the commission.** It is not a percentage of purse. A NY rider *may* take that year’s $50 MMA / $10 boxing off *that* purse if both parties initial it — recoupment of a published fee, not a new tax. Medical lines on that rider are **TBD**: the form publishes the *slot*, not the dollar (A13). Travel on that rider is the same *kind* as the game’s `expenses` object.

**Kickbacks remain forbidden.** `NAC 467.137(1)`; CA `4 CCR 232(a)`; Ali Act `15 U.S.C. § 6307e` (boxing-only disclosures — E6, not reopened).

### Promoter-side event taxes — not a fighter deduction (E25, restated)

These are **the promoter’s licence / admissions tax**, already J3 D14 / J4 E25. They do **not** come out of `athlete["cash"]`.

| Tax | Who pays | Published figure (verified 2026-09-06) |
|-----|----------|----------------------------------------|
| NV promoter licence fee on **gate** | Promoter | `NRS 467.107(1)`: **8%** of gross admission receipts, **without deduction for contestants’ purses**. Drug-testing credit against that fee (`467.107(4)`). Additional per-ticket fee exists (`NRS 467.108`) — **promoter/ticket**, not purse |
| CA admissions / broadcast | Promoter (“person who conducts a contest”) | `BPC 18824` (text current through a 2026-07-13 update on the compiler used this pass): **5%** of amount paid for admission, **not to exceed $200,000** per contest; broadcast/TV fee **up to 5%**, not less than $1,000, not more than $50,000, rate by regulation. Complimentary-ticket rule at 33%. **Not a fighter line** |
| NY authorized combative sports tax | Promoter | Tax Law § 452 / tax.ny.gov “Authorized combative sports tax”: boxing/sparring/wrestling **3%** of ticket gross, **max $50,000**; **3%** of broadcasting gross, **max $50,000**. Kickboxing / single-discipline / MMA: **3%** of ticket gross (**no** maximum after 1 Dec 2024) + **3%** of broadcast+streaming with a **$50,000** cap on that prong. **Promoter report**, not a purse withhold |
| NJ event tax | Promoter | `N.J.S.A. 5:2A-20(c)`: on ticket gross + face of comps, **3%** of first $25,000, **4%** of next $50,000, **5%** of next $125,000, **6%** over $200,000, **cap $100,000** per event; separate graduated tax on TV/radio/film rights, also **cap $100,000**. “Shall not be subject to any reduction or allowance of any kind.” **Promoter**, not combatant |

CA boxer **pension** (`BPC 18881` et seq.; `4 CCR` 400-series) is funded by a **ticket assessment** (statute: **$1**/ticket up to **$10,000** per boxing contest; older `4 CCR 403` text retrieved this pass still discusses a cents-per-ticket promoter contribution). It is **boxing**, **promoter/ticket**, **not in the 18**, and **not** a published MMA-purse skim. Do not debit it from an MMA athlete.

### UNKNOWN (do not invent)

- A sport-wide “commission cut of the purse” percentage (ABC, NSAC, CSAC, NJSACB, NYSAC, or any of the 13).
- A per-bout contestant fee in the four jurisdictions.
- Exact current dollar of any host-nation (Singapore / Japan / Thailand / Netherlands) contestant levy as house law of ONE / RIZIN / RWS / GLORY.
- Whether a NY boxing licence issued in 2026 expires next 1 Oct or one year from issuance (`207.4` vs the fee-schedule page).
- MMA-specific restatement of CA `4 CCR` 230/232 (boxing chapter; CSAC uses fighter–club forms for martial arts under `BPC 18855` — already J4).

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| Opaque `expenses` at settlement | Uncovered travel + hotel, default 450+300 | **Honest object, invented dollars, dishonest name** |
| Coverage flags | Promoter opens covering | Honest **shape** (E13) |
| Contestant licence debit | none | **Absent** — correct as MVP. A $50/$60/$5/$10-or-$50 flag is scenery unless tagged with `evidence` |
| Per-bout contestant fee | none | **Honest omission of a non-rule** |
| Commission % of purse | none | **Honest omission of a non-rule** |
| Promoter gate/broadcast tax off the fighter | none | **Honest omission** (E25). Keep |
| NV ≤10% promoter expense withhold | none as a 10% take | **Correct not to ship 10% as a default.** The live object is uncovered travel/hotel, not a 10% float |
| NY rider itemization | none | **Absent.** Do not build a rider-office sim. The live travel toggle is the honest subset |
| Disciplinary purse retain (`467.147`) | none | **Absent** — scenery (J4 E9 licence RPG’s cousin) |

## (d) Minimum change (one concrete recommendation)

**Rename the settlement `expenses` int as uncovered travel / accommodation (the object `FightContract` already computes). Keep the invented magnitudes labelled invented. Promoter still opens covering both. Do not add a contestant-licence skim, a per-bout combatant fee, a commission % of purse, or a promoter-gate tax to `athlete["cash"]`. Do not treat `NAC 467.142(4)`’s 10% as a default deduction.**

If a later data file authors an event-state licence debit, it is a **tagged term fee with `evidence`**, paid from the wallet **between bouts** (Area 4) or recouped only when a rider-like itemization exists — never as a silent global at `:10363`.

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — Temptation to ship “3% commission, that’s what the other games do.”**  
**Solution:** A4. Not retrieved as a global. E25’s promoter taxes stay promoter-side.

**Issue 2 — Temptation to debit NV $50 / CA $60 at every settlement “so the licence exists as money.”**  
**Solution:** A2 / A12. The licence is a **card**. Debiting it every bout would over-charge a fighter who has four fights in a Nevada calendar year.

**Issue 3 — Reading `NAC 467.142(4)` as “the game should take 10%.”**  
**Solution:** That subsection is a **ceiling on a promoter float**, reconciled in five days. The game already has the honest subset (uncovered travel/hotel). 10% as a default would be a new lie.

**Issue 4 — NY rider’s $50 licence line looking like a per-bout tax.**  
**Solution:** Optional, initialled, Commission-approved recoupment of the **annual** MMA fee. Not a second levy. Do not author it as always-on.

**Issue 5 — Brand / O-460, DOS-2072-f, CSAC bout forms.**  
**Solution:** J1 §4.1. Text names in research. Do not ship photographed official forms as UI art.

**Issue 6 — Exporting NV/CA/NJ/NY table onto a Saitama or Kallang card.**  
**Solution:** Jurisdiction-tagged. Default polarity remains promoter → contestant (J2 §2.6). Host-nation levies: UNKNOWN. Do not export.

---

# Area 2 — Tax withholding at the event

Whether a combatant’s purse is withheld against at source, for residents and for non-residents, and whether this is a commission function at all or a promoter / state-revenue one. Manager games invent a flat percentage here. Say plainly whether any figure is publishable and whether it belongs in this game **at all**.

## (a) Decisions coming (named as calls)

1. **Call: is tax withholding a commission function?**
2. **Call: resident vs nonresident, which published rates.**
3. **Call: does a publishable rate belong in FightCamp at all?**
4. **Call: the flat % other games ship.**

## (b) Evidence + UNKNOWN

### This is not a commission chapter

Athletic-commission statutes retrieved this pass regulate **who is paid the purse** and **what itemized deductions the bout form may carry**. They do not set a state income-tax rate. Where a bout form mentions tax, it points at **federal NRA withholding** (NYSAC DOS-2072-f §6 and Rider §2 “Taxes/Federal Withholdings (Must Be Checked for Foreign Combatant)”) or at “federal, state or local government taxes” as the *only* pre-purse take a club may lift from gate receipts before a percentage fighter is paid (CA `4 CCR 230(c)` — that sentence is about **gate**, not a fighter W-2).

**Withholding agents**, where they exist, are **promoters, venues, or payers** under **revenue** codes, not the athletic commission as tax collector.

### What is publishable (and still may not belong)

| Layer | Who withholds | Published rule (verified 2026-09-06) | On a FightCamp settlement line? |
|-------|---------------|--------------------------------------|----------------------------------|
| **Nevada state income tax** | Nobody | Nevada imposes **no** individual state income tax (constitutional ban; employer-withholding guides 2026: withhold **not required**). Visiting combatants are not hit with a NV “jock tax” because there is no tax to withhold | **Show nothing.** A 0% line would be theatre |
| **California nonresident withholding** | **Withholding agent** (FTB examples include **promoter** and **venue**), **not CSAC** | `R&TC 18662`; `18 CCR 18662-6` (verified 2026-09-06) **names boxers** in the “entertainers, athletes, and speakers” list. **7%** of California-source payments to nonresidents when calendar-year payments exceed **$1,500**. Residents / CA business entities carved out. Withholding required **even if the contract says no withholding**. Gross payment, not net after commissions, unless FTB Form 588/589 waiver or reduction is approved **before** payment (reduced-expense base cannot exceed 50% of gross on Form 589). Backup withholding also **7%** in the FTB backup-withholding chapter when a TIN is missing | **Publishable. Still scenery for MVP.** Requires a residency flag, a $1,500 YTD counter, and a waiver object. That is a tax sim (J2 §6.2) |
| **New York state — event tax** | Promoter | Tax Law § 452 / authorized combative sports tax: **3% of promoter gross receipts** (see Area 1 table). **Not** a combatant withhold | **E25.** Not a fighter line |
| **New York state — combatant income tax** | **Not retrieved as a NYSAC table.** Historical 1921 journalism (clubs withhold from nonresident boxers) is **not** current law. `20 NYCRR 132.22` is **team-athlete duty-day** sourcing (baseball/basketball/football/soccer/hockey). Independent-contractor combatants: NY income tax may be due on NY-source personal services; a **flat bout-night % on the NYSAC form is not retrieved** this pass. The live bout form’s tax line is **federal NRA** | **Do not author a NY %.** Duty-day team rules are the wrong sport |
| **New Jersey GIT** | Employer withholding via NJ-WT where an **employer** exists; nonresidents taxed on NJ-source personal services with **no de minimis** (Division of Taxation “Nonresident Athletes, Entertainers, and Performers,” last updated 2025-11-18, verified 2026-09-06) | `N.J.A.C. 18:35-5.1` duty-day rules are for **members of a professional athletic team** (baseball/basketball/football/soccer/hockey). A published **flat % for an IC MMA purse** was **not retrieved** this pass. GIT/REP forms are **real-property** withholding, not bout forms | **Do not invent a NJ fighter %.** Liability may exist; a table does not |
| **Federal — US person** | Generally **none at source** on nonemployee compensation if a W-9/TIN is on file | Form **1099-NEC** reporting (Instructions for Forms 1099-MISC and 1099-NEC, 12/2026: file for each person paid at least **$2,000** in nonemployee compensation in 2026; prior-year threshold was $600). Backup withholding **24%** if no TIN. Classification as employee vs IC is **contested** (J4 E14: do not ship) | **Reporting, not a FightCamp debit.** Do not withhold 24% as a default |
| **Federal — nonresident alien athlete/entertainer** | Withholding agent (promoter / payer) | IRC § 1441; IRS Pub. 515 (2026 PDF this pass **explicitly lists “Purses paid to nonresident alien boxers for prize fights in the United States”** as withholdable). Statutory **30%** of gross unless a treaty / Form 8233 / **Central Withholding Agreement** reduces it. Form 1042-S, not 1099. NYSAC MMA contract §6 requires the promoter to **notice** the NRA amount or % on the rider | **Publishable as federal NRA.** Still scenery: needs alienage, treaty, and CWA objects |

**CA 7% is the one clean *state* number a manager game always wants.** It is real. It is also **residency-gated**, **threshold-gated**, **waiver-gated**, and **not a CSAC function**. Shipping 7% on every California card, including to residents, would be a lie. Shipping 7% only to a `nonresident` flag is the smallest honest version and is still a tax product.

**IRS 30% is the other clean number.** It applies to **foreign** persons on US-source purses, not to a Nevada resident on a Las Vegas card. Shipping 30% as “the tax” would be the 2am decision.

### Ruling on A6 / A7 / A8

**A tax model is scenery. Show nothing on the settlement line.**

That is the right call, not a dodge:

- The publishable state rate (CA 7%) is the wrong shape for a gym game (residency + YTD + FTB waiver).
- The publishable federal rate (30% NRA) is the wrong population (most roster athletes are not modelled as nonresident aliens, and the game has no alienage flag).
- NV, the catalog’s spiritual home, withholds **0%** state tax.
- NY / NJ **event** taxes are promoter gross-receipts taxes (E25).
- NY / NJ **combatant** withholding as a flat bout-night % is **not retrieved**.
- J4 E14 already refused to ship employee vs IC. A withholding engine would have to assume one.

Label the absence: **not “fighters pay no tax in the real world.”** They file. The **game does not model the Internal Revenue Code.** Same sentence J5 used for gym dues: omit the line rather than invent USD 0 as a fake fee — here, omit the withhold rather than invent 20%.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| State tax withhold at settlement | none | **Honest omission.** Keep (A6) |
| Federal NRA 30% | none | **Honest omission** unless a later `nra` flag is filed with `evidence` |
| CA 7% nonresident | none | **Honest omission** of a real rule that needs residency |
| Promoter event tax off the fighter | none | **Honest** (E25) |
| `payee_split` comment | “No promoter-side tax is deducted here; none exists, and none may be invented (E25)” | Honest **as to promoter-side.** Do not smuggle income tax in through `expenses` |

## (d) Minimum change

**Do not add a tax-withholding term to `payee_split` or to `athlete["cash"]`. Do not author 7, 20, 24, or 30 as a global. E25 stands. Optional later, still small and still scenery-ranked: a `nonresident` flag that is allowed to debit CA 7% only when the event is tagged California and `evidence` points at `R&TC 18662` — default off.**

## (e) Issues + solutions

**Issue 1 — “Every other manager sim takes 30%, players expect it.”**  
**Solution:** A7. Players expecting a lie is not evidence. NV is 0% state. US persons on 1099 do not have 30% withheld.

**Issue 2 — CA 7% looking like the one honest number we should ship to “do tax.”**  
**Solution:** A8. Without residency it is a lie. With residency it is a new product.

**Issue 3 — NYSAC rider “Taxes/Federal Withholdings” looking like NY state tax.**  
**Solution:** The form’s own §6 is **NRA / IRS**. Do not mash it into Tax Law § 452 (promoter 3%).

**Issue 4 — Team duty-day “jock tax” articles looking like a bout-form table.**  
**Solution:** `20 NYCRR 132.22` / `N.J.A.C. 18:35-5.1` list baseball, basketball, football, soccer, hockey. MMA as a team-duty-day object: **not retrieved.**

**Issue 5 — Brand / FTB, IRS, CSAC.**  
**Solution:** J1 §4.1. No seals, no 1042-S as UI art, no named fighters as data.

---

# Area 3 — Fighter-side people paid from the purse

Trainer, cutman, seconds, and the manager share. **Do not reopen J4 E4** (payer is fighter/manager, not a promoter statutory wage) **or J5 G11–G13** (gym is not a published payee for supplying corners). The open question is **order and ceiling** when a filed manager share, a trainer’s cut, and the state’s own deductions all point at one purse.

J4 **E2** caps are stored and are **not re-derived.**

## (a) Decisions coming (named as calls)

1. **Call: published order** of manager / trainer / cutman / state / expenses.
2. **Call: published ceiling** when they collide.
3. **Call: CUSTOMARY 10% / 2–3%** — store, or omit.
4. **Call: relation to live `payee_split`.**

## (b) Evidence + UNKNOWN

### What the published record sequences

There is **no** retrieved statute that says: take manager 33⅓%, then trainer 10%, then cutman 3%, then tax, then the fighter keeps the rest.

What *is* published is a **payment polarity** and a **permission to deduct**:

| Step | Nevada | California | New Jersey | New York |
|------|--------|------------|------------|----------|
| **1. Bout-agreement gross** | Promoter ↔ contestant (`467.112`); paid in full (`467.137(1)`) | Club–boxer official form (`230(a)`); paid in full (`232(a)`); **≥ $100/round** (`232(b)`) | Full purse specified in the contract (`13:46-5.11`) | Cheque to the combatant (`209.13`); **≥ $150** after approved deductions (`209.11`); all payments specified in the contracts |
| **2. Authorized / itemized deductions** | Promoter advances; ≤ **10%** expense withhold reconciled in 5 days (`467.142(4)`); **not** a trainer schedule | Only if **itemized** on the contract; commission may disallow (`230(c)`) | Not retrieved as an itemization chapter this pass beyond the full-purse rule | Optional rider, both parties initial, Commission approves (DOS-2072-f). Training expenses and travel are **slots**, dollars blank or TBD |
| **3. Manager share** | **May**, with combatant **approval**, if the contract specifies it and complies with `467.102` (`467.137(3)`). O-460 §7: licensed + on file + ≤ ⅓ + contestant **initials** — **all four**. Cap **33⅓%** of ring earnings (`467.102(6)`) — E2, not re-derived | Filed contract; 33⅓% of gross ring earnings (`4 CCR 221(b)`, boxing chapter; MMA **INHERITED** CSAC practice — J4). Self-sign **full purse** if no licensed manager | ≤ 33⅓% of ring earnings with a **properly filed** contract (`13:46-6.4`, boxing-titled; MMA % **UNKNOWN** — J4). Unlicensed manager shall not deal with a promoter (`13:46-6.10`) | Combatant **≥ 50% after authorized deductions** (`209.12`) — a **floor**, not a 33% cap. Third-party (manager) distributions only if Commission-approved (`209.13`; rider §3). Combatant **remains solely responsible** for manager fees even when a third-party cheque is cut (DOS-2072-f rider §3) |
| **4. Trainer / cutman / seconds as a statutory take** | **Not retrieved as a %.** Second’s *licence* is $50 (`467.012(8)(g)`). Manager may second without a second’s licence (`467.057`) — E4 | **Not retrieved as a %.** Trainer/chief second/second licence **$50** (`BPC 18811`). `BPC 18653`: licensed professional trainer in the corner — **licence-in-the-corner, not a who-pays-% rule** (E4) | **Not retrieved as a %.** Second licence **$25**. Manager **may not** second unless licensed as one (`13:46-6.2`) | **Not retrieved as a %.** Boxing second **$10**; MMA second **$40**. Rider may recoup those **licence** dollars if checked |
| **5. Dispute / discipline** | Withhold disputed manager amount (`467.137(4)`); disciplinary retain (`467.147`) | Commission representative may order a withhold (`232(a)`) | — | Commission may forfeit compensation for collusion / failed licensing / unfitness (DOS-2072-f §7–§8) — **not a fee** |

**ABC model boxer/manager contract** (abcboxing.com, already J5): the **percentage is a blank**. Do not ship the blank as 33⅓%, and do not ship it as 10% trainer.

### CUSTOMARY journalism (do not wire) — already J5 G11, restated as *order*

| Claim | Kind | Usable as a default? |
|-------|------|----------------------|
| Trainer takes **~10%** of the purse | SECONDARY boxing-finance explainers; coach-advice videos (5% corner-only / 10% camp+corner / 20% if also managing) — already J5 | **No.** 20% of gross purse for bout-related services **is a manager** under E3 / `NAC 467.0028` / `BPC 18628` / NJ `13:46-1.1` |
| Cutman takes **2–3%** | Wikipedia *Cutman*; 2026 explainers — already J5 | **No.** Not ABC. Not a commission schedule |
| On smaller shows, corners work for expenses or nothing | SECONDARY | **CUSTOMARY.** Matches “UNKNOWN as a published invoice” |
| UFC-shaped cutmen are **promotion-provided** | *The Athletic* 2019 (SECONDARY); not a 2026 UFC.com bylaw this pass | **Gym is not the payee** (G11). Promoter-side if ever shown |

**Ceiling when they collide, in published words rather than invented arithmetic:**

- **New York `209.12`:** whatever else is authorized, the combatant **actually receives ≥ 50%** of ring earnings after those authorized deductions. A stack that would leave the combatant at 40% is **unlawful in NY** unless the Commission directs otherwise. Live `payee_split` already implements this as `min_combatant_percent` against `gross − expenses − keep_min`.
- **New York `209.11`:** **$150** after approved deductions (unless the Commission directs otherwise).
- **California `232(b)`:** **$100 per round** contracted floor.
- **Nevada:** combatant paid **in full on the bout agreement**; manager share is an **approved deduction up to 33⅓%**, not a second tax on top of an unpublished trainer %.
- **The 10% tripwire (E3):** anyone entitled to ≥ 10% (NV/NJ) or > 10% (CA) of the **gross purse** for services relating to the contest **is a manager** and must be licensed as one. A “trainer cut” of 10% of gross is not a loophole around E2/E3. Collectibility is J5 G6.

**There is no published remainder formula** of the kind `purse × (1 − 0.333 − 0.10 − 0.03 − 0.07)`. Inventing one would be D14 (PPV %) in a corner coat, and it would break `209.12`.

### What live `payee_split` already does (do not “fix” it with a trainer %)

```
manager_share = floor(gross × applied_cap_percent / 100)   # 0 if no filed contract
# NY: manager_share = min(manager_share, max(0, gross − expenses − keep_min))
athlete = gross − manager_share − expenses
gym    = manager_share
```

Order in code: **manager % of gross, then uncovered travel/hotel off the athlete, NY floor protecting the combatant after both.** That is a defensible reading of `209.12` (“after all authorized purse deductions”) plus J4 E5 (fighter’s own uncovered travel comes off the fighter’s side). It is **not** a trainer schedule and must not grow one.

**Do not reopen E2.** Caps stay: NV/CA/NJ 33⅓%; NY ≥ 50% floor. Store a cap, never a default take (G9).

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Manager share | Seam exists; default **0** (E23) | Honest default |
| Order: manager off gross, then expenses | LIVE in `payee_split` | Honest **as far as published objects go** |
| NY 50% floor after expenses | LIVE | Honest reading of `209.12` |
| Trainer % | none | **Honest omission** |
| Cutman % | none | **Honest omission** |
| Seconds’ wage | none | **Honest omission** (E4 / G11) |
| Stacking formula | none | **Honest omission of a non-rule** |

## (d) Minimum change

**Do not add a trainer, cutman, or seconds percentage to `payee_split`. Do not author 10 / 3 / 2. Keep E4 and G11–G13. Keep E2 caps stored, not re-derived. Keep the live order (filed manager share off gross, then named uncovered travel/hotel, NY floor). If a later data file authors a fighter-side corner expense, it needs `evidence` and a payer field — and a take ≥ 10% of gross purse for contest-related services is a manager contract (E3), not a “trainer line.”**

## (e) Issues + solutions

**Issue 1 — “We’ll just take 10% for the coach so the corner exists as money.”**  
**Solution:** A10 / E3. 10% of gross **is** the manager definition. Collectibility is G6. CUSTOMARY ≠ a rule.

**Issue 2 — Stacking 33 + 10 + 3 + 7 because a spreadsheet went red.**  
**Solution:** A9. NY `209.12` exists specifically so that cannot happen as law. The red spreadsheet is an **economy** problem (J5 already said this about payroll). Do not tax the bout agreement to paper over it.

**Issue 3 — Named cutmen / trainers as data.**  
**Solution:** Standing rule (G34 / E34). Cite the practice class.

**Issue 4 — Unplayed second / cutman / trainer-agency mode.**  
**Solution:** Scenery. J2 §6.2 / J4 E9.

---

# Area 4 — What the athlete pays between bouts

Annual / biennial licence renewal, the medicals a licence requires (bloodwork, eye exam, MRI/MRA where a commission mandates one), and gym membership from the athlete’s side — the mirror of J5 Area 1, now with a payer who has a wallet. A commission that *mandates* a medical without publishing a price gives you the requirement, not the number. J5 **G24** holds.

## (a) Decisions coming (named as calls)

1. **Call: licence renewal as a wallet debit.**
2. **Call: medicals — requirement vs price vs payer.**
3. **Call: gym membership from `athlete["cash"]`.**
4. **Call: does any of this outrank J5 membership?**

## (b) Evidence + UNKNOWN

### Licence renewal — published fee, scenery as a career

Area 1’s table **is** the renewal fee. NV calendar remainder; CA twelve months (`BPC 18822(b)`, and a boxer/martial-arts contestant renewal “shall also be accompanied by the required medical examinations and test results”); NJ $5; NY boxing $10 / MMA $50.

**This is not a sport-wide annual debit.** A fighter licensed only in the event state, only in the year they fight there, pays **that** state’s card. Reciprocity of **suspensions** is ABC-member (J3 D7). Reciprocity of **licences** is not automatic (J5 G8). Building “keep four licences clean” is the licence RPG J4 E7 already ranked scenery.

**Minimum honest object, if ever built:** `licence_in_event_state` as a **flag** (already J4 rank 3, gated on a manager share). A dollar debit only with `evidence` pointing at that state’s live section. Default: omit.

### Mandated medicals — requirement is published; price is not

**Do not invent an MRI dollar.** J4 E12 stands. Boxing Insider 2026-03-30 “$500 to $1,500” is SECONDARY.

| Jurisdiction | What is required (primary this pass) | Interval (as published) | Price | Payer |
|--------------|--------------------------------------|-------------------------|-------|-------|
| **Nevada** `NAC 467.027` (verified 2026-09-06) + NSAC PHYSICAL-2025 instructions | Physician exam **≥ 7 days** before the first bout of the licence year; **dilated ophthalmologic** exam by MD/DO ophthalmologist (not optometrist), **≥ 7 days** before that bout; **brain MRI** if none in the prior **5 years**; **cerebral MRA** the **first** time licensed (not on later renewals); **CBC** + tests showing not infected with **HIV** or **hepatitis**, lab **not earlier than 30 days** before the application. NSAC form also lists EKG, urinalysis, HBV surface antigen, HCV antibody, RPR, electrolytes on the physical packet | MRI **every 5 years** (NSAC form + `467.027(1)(c)`). MRA **once** unless otherwise ordered. Serology **30 days** | **UNKNOWN** as a commission fee schedule | NSAC MRI/MRA order form (boxing.nv.gov, verified 2026-09-06) is captioned **“Test request (Patient Responsible for Payment).”** That is **primary for NSAC’s own order**. It is still not a dollar. J4 E12’s “UNKNOWN as a statute” stands for the *NAC text*; the **form** names the patient |
| **California** `4 CCR 280` (operative 2022-07-01; verified 2026-09-06) + CSAC athlete-application instructions | Neurological exam by neurology/neurosurgery specialist; **MRI** with GRE or SWI, read by neurologist/neurosurgeon/neuroradiologist; **EKG** (once unless good cause); physical; **ophthalmologist** eye exam (`4 CCR 282`); blood within **30 days** of application: **HIV antibody, HBsAg, HCV antibody**, CLIA lab | Neuro **12 months** (`280(c)(1)`). MRI **36 months** (`280(c)(2)`). Physical / eye **12 months**. Blood **6 months**. EKG once unless required again | **UNKNOWN** as a CSAC invoice | Neurological *exam costs* are paid from assessments on **promoters, managers, and/or athletes** (`BPC 18711`); the live collection mechanism is **one quarter of one percent of gross ticket sales from each licensed promoter** into the Neurological Examination Account (`4 CCR 280(i)`), re-examined if the account falls below **$100,000**. That 0.25% is a **promoter ticket assessment**, not an MRI invoice to the athlete (already J4 E12) |
| **New Jersey** `N.J.A.C. 13:46-12A.3` (verified 2026-09-06) | Thorough exam: **CT/MRI brain without contrast** within **3 years**; EKG; ophthalmological dilation; annual gyn/breast for women; serum pregnancy; history and physical; CBC for bleeding/coagulation **initial licensure only**; **HBV, HCV, HIV** no earlier than **180 days** prior to each scheduled competition; urinalysis; high-risk questionnaire | CT/MRI **3 years**. Blood **180 days** per competition. Physical timing in `12A.2`: exam no earlier than **30 days** and no later than **one day** prior to licensure/renewal, except the 180-day blood rule | **UNKNOWN** | **UNKNOWN** as a statute. ABC aggregator (SECONDARY) restates the tests; it does not publish a NJ price list |
| **New York** NYSAC Medical Manual (May 2024 PDF) + combative-sport-professional checklist (verified 2026-09-06) | **Brain MRI** 1.5T+ with listed sequences (SWI, T1, T2, FLAIR, DWI, GRE); **12-lead EKG**; **dilated eye exam by ophthalmologist** (MD/DO); **HIV, HBV surface antigen, HCV antibody, CBC with platelets**; pregnancy test for females **within 30 days of each event**; physician physical | MRI **every 3 years** (or as CMO requires); EKG / eye / blood **every 12 months** (checklist: MRI dated within 3 years; others within 1 year; pregnancy 30 days) | Medicals on the bout **rider** are **TBD**. No retrieved 2026 NYSAC dollar table for MRI / blood / eye this pass | NYSAC Medical Manual: “State Law requires that **certain costs and fees for medical testing be borne by the promoter**.” ABC medical-requirements page (already J4): NY blood work scheduled through the Commission **billed to the promoter**. **Not** a universal “fighter pays MRI” rule |

**ABC “Medical Requirements by Commission”** is a **useful aggregator**, not a fee schedule. Prefer the NAC / CCR / N.J.A.C. / NYSAC manual.

**Ali Revival / UBO medical cost-shift** (promoters/UBOs covering tests): **not enacted** as of 2026-09-06 (already J4). Boxing-only. **Scenery.**

**Ruling on A13 / A14.** Store **tests and intervals** if a clearance verb needs them (J4 rank 2 / J3 D6). Do **not** store `$mri = 1200`. Payer is **not a single rule**: NV form says patient; NY says certain tests promoter; CA neuro account is a promoter ticket assessment. If a later file authors a cost, it needs `evidence` **and** a payer field (`athlete` / `promoter` / `assessment`).

### Gym membership from the athlete’s side — J5 Area 1, other face

J5 **G1**: do not author a sport-wide dues number. **G3**: the honest post-R43 floor for the *gym* is a gym-authored membership / training-floor fee with `evidence`, or omit. **G24**: no sport-wide `membership_usd_per_month` without `evidence` pointing at **that gym’s** posted rate or an explicit `INVENTED` gameplay tag.

After R43 the athlete has `athlete["cash"]`. The same object, from this side, is: **if** a gym-authored rate is filed, the debit can land on the athlete and the credit on the gym. That is **not** a purse tax (G10 / E3). It is **not** USA Boxing club $205 (G4). It is **not** “pros train free” as a default (G2).

**CUSTOMARY** practices (pros pay a floor fee; high-level names waived; access traded for a %) remain **CUSTOMARY, one house, not a default** — already J5. A trade of ≥ 10% of gross purse **is a manager contract**.

**Do not reopen J5’s priority.** This is the same rank-2 object.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Athlete wallet | LIVE (`athlete["cash"]`) | Honest **payee**. Empty of between-bout debits |
| Licence-renewal debit | none | **Absent** — correct as MVP |
| Medical invoice | none | **Absent** — correct (price UNKNOWN) |
| `medical_hold` week table | LIVE (`body_readiness_rules.json` 1/4/8) | **Invented duration** (J3 D6 / J4). Existence of the hold is not in dispute |
| `clearance` verb that lifts the hold | proposed J4 rank 2 | **Do not invent a dollar to give it teeth** (E12 / E28) |
| Membership debit from athlete | none | **Absent** — J5 rank 2, other face |
| Invented `weekly_salary` **to** the athlete from the gym | LIVE (J5) | **Invented polarity.** Real roster professionals are not, as a published rule, gym employees (E14). Not this pack to retune, but it is why the athlete ledger and the gym ledger cannot both pretend to be “realistic payroll” without an evidenced dues object |

## (d) Minimum change

**Do not author a sport-wide licence-renewal dollar, an MRI invoice, or a monthly dues number. If J5’s membership object is built, the payer after R43 is the athlete’s wallet and the payee is the gym — same `evidence` rule, no default USD. Medicals stay a clearance **requirement**, not a price. Licence flags stay J4 rank 3 (gated on a share), not a four-jurisdiction tax sim.**

## (e) Issues + solutions

**Issue 1 — “Give the hold teeth with a $1,200 MRI.”**  
**Solution:** A13 / E12 / E28. Requirement ≠ invoice. Inventing the dollar is the 2am decision.

**Issue 2 — Sport-wide $150/month dues now that the athlete can pay.**  
**Solution:** A15 / G1 / G24. A wallet is not evidence.

**Issue 3 — Debiting NV $50 every January as flavour.**  
**Solution:** A12. Flavour that over-charges a one-fight visitor is a lie. Flag, or omit.

**Issue 4 — Brand / MRI films, CSAC neurological certificates, NYSAC Medical Manual.**  
**Solution:** J1 §4.1. Text in research. No scanned medical records as UI art. No named physicians as data.

**Issue 5 — Player fantasy: “I banked the purse, I don’t pay dues or medicals.”**  
**Solution:** In the real world they do, on **private** and **UNKNOWN-priced** terms. The game may show the **requirement** (licence, clearance) without inventing the till.

---

# Priority ruling

**After R43, what does a fighter actually keep, how much of the deduction side ships without inventing a number, and does any of it outrank J5’s rank-2 membership object?**

**Plain words.** After R43 the bout-agreement money stops in `athlete["cash"]`. What the live game subtracts is **one thing**: uncovered travel and accommodation, and only when the coverage flags are false (promoter opens covering, so the balanced path subtracts **0**). A filed manager share, if one ever exists, comes off next, never above the stored cap, default **0** (E23). That is what a fighter **keeps** in this build: **the contracted purse, minus uncovered logistics if any, minus a collectible manager share if any.**

Everything else this pack studied is either:

- **published and small and separate** (term licence fees of $5 / $10 / $50 / $60 — paid for a *card*, not as a purse tax),
- **published as a requirement without a price** (blood, eye, MRI/MRA),
- **published as someone else’s tax** (promoter 8% / 5% / 3% / NJ graduated; CA 7% nonresident on the *payer*, not CSAC),
- or **CUSTOMARY journalism** (trainer 10%, cutman 2–3%).

**How much of the deduction side ships without inventing a number?** Almost none, beyond **naming** the logistics object that already ships. “Less than you’d think, and most of it unpublishable” is the true answer.

**Does any of it outrank J5’s rank-2 membership object?** **No.** J5’s priority is not reopened. The gym still pays payroll and upkeep; purses no longer feed it; membership is what a real gym lives on. Athlete-side dues are that **same object**. Commission skims, tax sims, and trainer percentages are **not** a reason to delay it, and they are **not** a reason to put a `gym_cut` back on the purse.

**Order, next twelve months:**

| Rank | Area | Research or build? | Wait a year? | Scenery? |
|------|------|--------------------|--------------|----------|
| **1** | **Name the live `expenses` int** (this pack’s honesty pass) | **Build** as a rename / label on an object that already ships: uncovered travel + accommodation, invented magnitude, promoter opens covering. Do **not** replace it with a commission % | No — it is a one-line pass on R43’s settlement | Opaque `expenses` as a mystery skim = **scenery-as-lie**. Do not ship the name; ship the object |
| **2** | **J5 rank-2 membership / training-floor object** | **Unchanged.** Build the line-item with `evidence`; do not author a default dollar. After R43 the **payer can be `athlete["cash"]`** | No — J5 already ranked this. This pack **does not outrank it** | Sport-wide $150/month = **scenery-as-lie**. NGB club fees as dues = **scenery** (G4) |
| **3** | **Commission licence / medical *requirement* as flags** | **Wait**, except J4’s `clearance` verb (already J4 rank 2) and J4’s `manager_licensed` triple **if** a share is ever paid (already J5 rank 3). Do **not** invent MRI / blood / eye dollars | Yes, for dollar debits | Licence-exam career / four-state tax sim = **scenery** (E7) |
| **4** | **Tax withholding and trainer/cutman percentages** | **Wait. Prefer never.** A6: show nothing. A10: do not author 10/3/2. CA 7% and IRS 30% NRA stay in the source list as **real rules the game does not model** | Yes | Flat 20–30% “tax” = **scenery-as-lie**. Trainer-agency mode = **scenery** (J2 §6.2) |

### Defend

**This pack’s rank 1 does not beat J5’s rank 2.** Naming `expenses` is **not a new system**. It is the honesty pass on the integer R43 already subtracts. It can ride on any settlement PR. It does not consume the slot J5 reserved for membership. **J5 rank 2 stands.**

**J5 rank 2 still beats athlete-side licence dollars.** A $50 Nevada card is real and small. A gym without members is still how this desk goes broke after R43 (J5 plain words). Do not skip membership to build a four-jurisdiction cashier.

**Licence/medical flags still beat tax and trainer %.** Tests and term cards are **statutory**. CA 7% is statutory **and** the wrong shape. Trainer 10% is **CUSTOMARY**. Inventing the latter two would be J3 D14 in a different coat.

**Why “show nothing” on tax is allowed to be the answer.** Publishable is not the same as shippable. CA 7% without residency is a lie; with residency it is a product. NV 0% makes a global 30% an even louder lie. J2 §6.3 / J4 E2: inventing a number because the other games have one is the 2am decision.

**Why this does not reopen E1–E3 or J5’s priority.** Payee stays the athlete. Caps stay stored. No `gym_cut`. Gym still lives on the floor plus a collectible share plus the invented sponsor cheque. This pack only names what already comes out of the athlete, and refuses to invent the rest.

### What is scenery (as plainly as J2 §5.1)

- **A tax-withholding sim** (residency, duty days, treaties, CWAs, FTB 588/589, 1042-S). Real law. **Not this game. Show nothing. Build nothing.**
- **A flat 7 / 20 / 24 / 30 percent “tax” on every purse.** Invented as a global. **Omit.**
- **Trainer 10% / cutman 2–3% as authored defaults.** CUSTOMARY journalism. **Omit.**
- **Licence-exam / four-state cashier career.** Real cards. **Scenery** (E7).
- **MRI / blood / eye invoices without `evidence`.** UNKNOWN. **Omit.**
- **Manager-simulator / agency / second-as-playable-mode.** Already scenery (J2 §6.2, J4 E9, J5).
- **Invented `gym_cut`.** Already scenery-as-lie (J4 E3, J5 G10). Not reopened.
- **PPV points, Ali Act overlay, Olympic IF careers, employee classification.** Already scenery. Not reopened.
- **Filing-office / rider-office RPG.** Collapse to flags if ever needed. NY’s optional rider is real; simulating the DOS lobby is not MVP.

**No fifth area outranks these four.** The closest miss — “should we model CA 7% because it is the one clean number?” — is a **new product** and walks into A6. Not MVP.

---

## Test assertions (contracts for a later PR — not written this pass)

Numbered **A19–A34** so they do not collide with operator calls A1–A18, J5 G1–G34, J4 E1–E34, or J3 D1–D16 / Q1–Q13.

| ID | Assertion |
|----|-----------|
| **A19** | After R43, bout-agreement money (`show_purse + win_bonus + performance_bonus + gate_share`) credits `athlete["cash"]` (via `payee_split`’s `athlete` field), not `gym["cash"]` as a 100% take. (Same polarity as J4 E19 / J5 G19; assignment in this excerpt is `:10363`–`:10364`.) |
| **A20** | `get_athlete_cash()` (`:10275`) reads `athlete["cash"]` and returns **0** when the field is absent. |
| **A21** | `FightContract.settlement_for` builds `expenses` **only** from uncovered `travel_cost` and/or `accommodation_cost`. It does not add a commission %, a tax %, a trainer %, or a licence fee. |
| **A22** | When `travel_covered` and `accommodation_covered` are both true, `expenses == 0`. Sign-as-offered (opening terms) therefore nets no logistics debit. |
| **A23** | `TRAVEL_COST` / `ACCOMMODATION_COST` (live **450** / **300**) are not written into a data file as a commission or ABC figure. If they remain, they are labelled **invented** gameplay magnitudes. |
| **A24** | `payee_split` subtracts `expenses` from the **athlete**, not from a promoter-side tax line. No `NRS 467.107` / `BPC 18824` / NY Tax Law § 452 / `N.J.S.A. 5:2A-20` amount is deducted from the fighter purse (J4 **E25**). |
| **A25** | If no manager contract is filed, `payee["gym"] == 0` (J4 **E23** / J5 **G20**). |
| **A26** | No data file contains a default `commission_cut` / `tax_pct` / `trainer_cut` / `cutman_pct` / `licence_per_bout` **percentage or dollar** without an `evidence` field. |
| **A27** | No data file contains a sport-wide `membership_usd_per_month` without `evidence` pointing at **that gym’s** posted rate or an explicit `INVENTED` gameplay tag (J5 **G24**). If membership is ever debited, the payer after R43 is `athlete["cash"]` and the payee is `gym["cash"]`, not a purse skim. |
| **A28** | No data file contains an `mri_cost_usd` / `bloodwork_usd` / `eye_exam_usd` constant without `evidence` (J4 **E28**). A `clearance` path may exist without a price. |
| **A29** | A trainer / coach / cutman take of ≥ 10% (NV/NJ) or > 10% (CA) of **gross purse** for contest-related services is treated as a **manager** contract (J4 **E24** / E3), not as a second silent cut beside E2. |
| **A30** | NY-tagged settlements still honour `min_combatant_percent` so the combatant actually receives ≥ **50%** of ring earnings after authorized deductions (`19 NYCRR 209.12`). Stacking unpublished trainer/tax percentages must not be added in a way that violates that floor. |
| **A31** | Contestant licence fees, if ever authored, are **term** fees with `evidence` pointing at the event-state section (NV `467.012`; CA `BPC 18809`; NJ `13:46-4.25(b)`; NY schedule / `GBL § 1007`), **not** a per-bout global. |
| **A32** | `career_earnings` remains a **counter** of bout-agreement money and is not decremented by `expenses` in lieu of the wallet (`:10372`). Ambitions do not spend the counter. |
| **A33** | J2 P1–P3 still hold (federations: no purse, no signing). R40 is not reopened. J3 Areas 1–3, J4 E1–E3, and J5’s priority ruling are not reopened by any A-test. |
| **A34** | No test fixture uses a real gym’s, manager’s, official’s, athlete’s, or executive’s name as data (J5 **G34** / J4 **E34**). |

---

## Source list (live verification 2026-09-06)

**Primary / official (preferred):**

- `J3_THE_DECISION_QUEUE.md` (D1–D16, Areas 1–3, D13/D14/D15 — **cited, not reopened**)
- `J4_THE_DESK_AND_THE_CUT.md` (E1–E18, E23, E2 caps, E4, E5, E7 table, E12, E25 — **cited; E1–E3 not re-derived**)
- `J5_THE_GYMS_OWN_LEDGER.md` (G1–G18, G24, G11–G13, **priority ruling** — **cited, not reopened**)
- `GameState_settlement.excerpt.txt` (`get_athlete_cash` `:10275`; R43 `payee_split` `:10363`–`:10366`; `career_earnings` `:10372`; TASK/J5 site `:10253`)
- `FightContract.full.txt` (`TRAVEL_COST` 450 / `ACCOMMODATION_COST` 300 `:59`–`:60`; `opening_terms` coverage `:174`–`:177`; `settlement_for` `:219`–`:239`; `payee_split` `:305`–`:337`; comment `:301`–`:304`)
- Nevada NAC 467 chapter (rev. listed 2026-04-13): https://www.leg.state.nv.us/nac/NAC-467.html
- NAC 467.012 (combatant **$50**; manager $100; second $50; calendar remainder): https://www.law.cornell.edu/regulations/nevada/NAC-467-012
- NAC 467.027 (physical ≥ 7 days; dilated ophthalmologic; MRI 5-year; MRA first licence; HIV/hepatitis labs ≤ 30 days): https://www.law.cornell.edu/regulations/nevada/NAC-467-027
- NAC 467.137 (pay in full; manager share with approval; dispute withhold): https://www.law.cornell.edu/regulations/nevada/NAC-467-137
- NAC 467.142 (purse immediately after; ≤ **10%** expense withhold, 5-working-day reconciliation): https://www.law.cornell.edu/regulations/nevada/NAC-467-142
- NAC 467.147 (disciplinary purse retain to the Commission): https://www.law.cornell.edu/regulations/nevada/NAC-467-147
- NRS 467.100 (licence required to participate): https://www.leg.state.nv.us/Nrs/NRS-467.html
- NRS 467.107 (promoter **8%** of gross admissions; no deduction for purses; drug-testing credit): https://www.leg.state.nv.us/Nrs/NRS-467.html
- NSAC Official Bout Agreement (O-460) §7 manager-share conditions: https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/Renewal/O-460_BOUT_AGREEMENT.pdf
- NSAC PHYSICAL-2025 medical packet (licence fee $50; MRI every 5 years; MRA one-time): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/PHYSICAL-2025_W-INSTR.pdf
- NSAC MRI/MRA order form (“Patient Responsible for Payment”): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/MRI-MRAorder-web.pdf
- NSAC professional contestant requirements: https://boxing.nv.gov/Licensing/Professional_Contestant/
- California `BPC 18809` (fighter licence **$60**): https://leginfo.legislature.ca.gov/faces/codes_displaySection.xhtml?lawCode=BPC&sectionNum=18809
- California `BPC 18822` (licence term **12 months** from issuance): https://california.public.law/codes/business_and_professions_code_section_18822
- California `BPC 18824` (promoter **5%** admissions, $200,000 cap; broadcast fee band): https://california.public.law/codes/business_and_professions_code_section_18824
- California `BPC 18711` (neurological exams; costs from assessments on promoters/managers/athletes)
- California `4 CCR 230` (official form; itemized deductions; blanket contracts): https://www.law.cornell.edu/regulations/california/4-CCR-230
- California `4 CCR 232` (paid in full; **$100**/round floor): https://www.law.cornell.edu/regulations/california/4-CCR-232
- California `4 CCR 280` (neuro 12 months; MRI 36 months; blood 6 months; promoter **0.25%** ticket assessment into Neurological Examination Account): https://www.law.cornell.edu/regulations/california/4-CCR-280
- CSAC professional-athlete application (fee $60): https://www.dca.ca.gov/csac/forms_pubs/forms/app_boxing.pdf
- CSAC athlete application instructions (MRI 3 years; blood 180 days; eye/physical 1 year): https://www.dca.ca.gov/csac/forms_pubs/forms/athleteappinstr.pdf
- `18 CCR 18662-6` (nonresident withholding; **boxers** named; **7%**; $1,500 threshold; waivers): https://www.law.cornell.edu/regulations/california/18-CCR-18662-6
- California `R&TC 18662` (nonresident withholding statute) — FTB withholding-on-nonresidents page (search-verified 2026-09-06; full HTML fetch denied this pass): https://www.ftb.ca.gov/pay/withholding/withholding-on-nonresidents.html
- N.J.A.C. 13:46-4.25 (combatant **$5**; manager $25; second $25; fiscal year for (a) classes): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-4-25
- N.J.A.C. 13:46-5.11 (promoter pays the boxer the **full purse** specified): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-5-11
- N.J.A.C. 13:46-6.4 (≤ 33⅓%; already J4)
- N.J.A.C. 13:46-12A.2 / 12A.3 (pre-licensure exam; CT/MRI 3 years; 180-day blood): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-12A-3
- `N.J.S.A. 5:2A-20` (promoter ticket tax 3–6%, cap $100,000; TV-rights tax, cap $100,000): https://law.justia.com/codes/new-jersey/title-5/section-5-2a-20/
- NJ Division of Taxation, Nonresident Athletes, Entertainers, and Performers (updated 2025-11-18): https://www.nj.gov/treasury/taxation/individuals/nonresident-athletes.shtml
- N.J.A.C. 18:35-5.1 (team-athlete duty days — baseball/basketball/football/soccer/hockey)
- `19 NYCRR 207.4` (licence duration; boxing after 1 Sep 2018 one year from issuance; MMA one year): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-207.4
- `19 NYCRR 209.11` (minimum **$150** after approved deductions; 50% on no-fault cancellation): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-209.11
- `19 NYCRR 209.12` (combatant ≥ **50%** after authorized deductions)
- `19 NYCRR 209.13` (cheque to the combatant; no third-party unless Commission approved): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-209.13
- NYSAC licence fee and term schedule (boxing combatant **$10**; MMA combatant **$50**): https://dos.ny.gov/license-fee-and-term-schedule-new-york-state-athletic-commission
- NYSAC combative-sport professional licence checklist (boxing $10 / MMA $50; MRI 3 years; blood/eye/EKG 1 year): https://dos.ny.gov/combative-sport-professional-professional-boxer-or-mixed-martial-artist-license
- NYSAC Official Bout Contract for Professional MMA, DOS-2072-f Rev. 10/20 (purse minus authorized deductions; optional rider: licence $50, seconds $40, manager $50, medicals TBD, travel, NRA tax): https://dos.ny.gov/system/files/documents/2021/04/2072-f-official-bout-contract-for-professional-mixed-martial-arts-mma.pdf
- NYSAC Medical Manual (May 2024): promoter bears certain medical-testing costs; MRI 3 years: https://dos.ny.gov/system/files/documents/2024/05/nysac-medical-manual-5-8-2484.pdf
- NY Tax Law § 452 (authorized combative sports tax on **promoter** gross receipts)
- `20 NYCRR 132.22` (nonresident **team** athletes — duty days; not a bout-form table)
- IRS Publication 515 (2026): purses paid to **nonresident alien boxers** for US prize fights are withholdable; statutory **30%** unless treaty/CWA: https://www.irs.gov/pub/irs-prior/p515--2026.pdf
- IRS, federal income tax withholding on U.S.-source income of NRAs (athletes & entertainers **30%** / treaty / 1042-S): https://www.irs.gov/individuals/international-taxpayers/federal-income-tax-withholding-and-reporting-on-other-kinds-of-us-source-income-paid-to-nonresident-aliens
- IRS Instructions for Forms 1099-MISC and 1099-NEC (12/2026): 1099-NEC at **$2,000** nonemployee compensation: https://www.irs.gov/instructions/i1099mec
- ABC model boxer/manager and bout contracts (blank manager %): https://www.abcboxing.com/boxer-and-bout-sample-contracts/
- ABC medical requirements by commission (aggregator; not a price list): https://www.abcboxing.com/medical-requirements-by-commission/

**Secondary (labelled in body):**

- FTB Publication 1017 / withholding-on-nonresidents overview (7%, $1,500, promoter as example withholding agent) — search-verified 2026-09-06; full ftb.ca.gov HTML **access denied** this pass; regulation text retrieved from Cornell LII
- NYSAC boxing bout-contract rider (sister of DOS-2072-f): Boxer’s Licence **$10**; medicals TBD; NRA withholding — retrieved via dos.ny.gov search snippet 2026-09-06
- Wikipedia *Cutman* (2–3%; MMA cutmen generally promotion-provided) — **not a fee schedule**; already J5
- *The Athletic* 2019-07-03 (UFC cutmen work for the promotion; declined to disclose the dollar) — already J5
- 2026 boxing-finance explainers (manager ~33%, trainer ~10%, corner/cutman ~2–4%) — **CUSTOMARY planning copy, do not wire**; already J5
- Boxing Insider 2026-03-30 (MRI cost ranges $500–$1,500) — **not a fee schedule**; already J4
- 1921 *New York Times* “State Will Tax Visiting Boxers” — **historical**, not current NYSAC withholding
- Apostle Sports / AARP / Tax Foundation 2026 explainers: Nevada **0%** individual income tax — **secondary restatements of a constitutional fact**; primary is the absence of a NV personal income-tax withhold chapter
- Association of Ringside Physicians neuroimaging consensus (commission MRI-interval table) — **medical society**, not a fee schedule

**Not retrieved / do not fake:**

- A sport-wide **commission cut of the purse** (ABC, NSAC, CSAC, NJSACB, NYSAC, or any of the 13)
- A **per-bout** contestant fee in NV / CA / NJ / NY on top of the term licence
- Current **exact dollar** of CA gymnasium licence (`BPC 18817` ceiling $200 vs `4 CCR 208` $10) — already J5 G5
- NY boxing licence **term** where `dos.ny.gov` “Expires Oct. 1st” and `19 NYCRR 207.4` “one year after issuance” disagree — **UNKNOWN** between those two texts
- A published **trainer %** or **cutman %** in NV / CA / NJ / NY
- A published **stacking formula** for manager + trainer + cutman + tax on one purse
- A NY or NJ **flat bout-night income-tax %** for independent-contractor combatants (team duty-day rules are the wrong sport)
- FTB HTML page body (access denied this pass) — regulation `18 CCR 18662-6` **was** retrieved
- A 2026 UFC / PFL / ONE / GLORY / RIZIN **primary** camp / tax / corner schedule
- Host-nation contestant levies as house law of ONE (Singapore), RIZIN (Japan), RWS (Thailand), GLORY (Netherlands) — default **off**
- Post-KO **MRI invoice** as a single NV/CA/NJ/NY dollar
- Ali Revival / UBO **enacted** text as of 2026-09-06 (already J4)
- UFC PPV point % (already J3: do not fake)
- Venum / UFC outfitting **primary PDF** (already J3: do not fake)
- A 2026 UFC promotional-agreement **primary PDF** (already J4)

---

*End of J6. Cut from the Decisions page and from the priority ruling. After R43 the fighter keeps the contracted purse, minus uncovered travel and accommodation if the coverage flags are false, minus a collectible manager share if one is ever filed. The opaque `expenses` term is that logistics debit — invented dollars, real object, dishonest name. Almost everything else that looks like a deduction is unpublishable or someone else’s tax. Do not invent a commission cut, a flat tax, or a trainer percentage to fill the silence. None of this outranks J5’s membership object. R40 remains J2 D6. J3 Areas 1–3, J4 E1–E3, and J5’s priority are not reopened. No tax sim. No manager-simulator.*
