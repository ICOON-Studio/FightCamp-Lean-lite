# J5 — The Gym's Own Ledger: What a Gym Is Actually Paid

**Desk:** John (research)  
**Date:** 2026-09-06  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design. No second career mode (J2 §6.2). No manager-simulator.  
**Local snapshot used:** `J2_THE_FEDERATION_PATHWAY.md`; `J3_THE_DECISION_QUEUE.md`; `J4_THE_DESK_AND_THE_CUT.md`; `GameState_billing.excerpt.txt` (settlement around `:10253`; `_settle_billing` around `:4658`; week advance around `:5108`); `Sponsorship.gd.excerpt.txt` (`:224` entity branch, weekly-cash offers). Line numbers for settlement / billing are from this workspace excerpt.

**Cite, do not re-litigate:** J1 (UNKNOWN policy, §4.1 brand). J2 (three **entry/money** pathways, money-flow table §2.6, D5 amateur→pro door, D6 / R40, §5.1 scenery, §6.2 unplayed-mode, §6.3 no invented numeric default). J3 (Decisions D1–D16, Areas 1–3, D13/D14/D15, priority ruling). J4 (E1–E18, file-level anchors, E23 default). **Do not reopen R40, J3 Areas 1–3, J4 E1–E3, or J3 D13–D15.** Caps, payee, and the 10% manager definition stand as J4.

**UNKNOWN policy (same as J1–J4):** a fee, a period, a percentage, a cap, or a formula that is not in a primary statute, regulation, commission form, or an organization’s own published page is **UNKNOWN**. Never invent one. Inherited practice is **INHERITED** / **CUSTOMARY**, not a published rule. National overlays are **NATIONAL**. A gym’s own posted rate is **primary for THAT gym**, not for the sport. No real gym’s, manager’s, official’s, athlete’s, or executive’s name as data.

**No fifth area.** After the four, a playable manager-agency career or a second-as-playable-mode is **scenery**, not a fifth research track. See G7 and the priority ruling. J2 §6.2 / J4 E9 stand.

---

## Why this exists

J4 **E1** ruled that the payee is the athlete. **R43** is building it: the purse stops landing in `gym["cash"]` at `GameState.gd:10253`. **E23** is the default that ships with it — no manager contract filed, the gym’s delta from that purse is `0`.

J4 refused to invent a gym cut of the purse (E3). That was correct and is **not reopened**. It left a hole this pack has to fill honestly:

The gym still pays weekly payroll and upkeep (`_settle_billing`, excerpt `:4658`; week advance `:5108`–`:5116`). After R43 the purses no longer feed it. **What is a combat-sports gym actually paid, and which of those revenue lines can be modelled without inventing a number?**

J2 §2.6 stopped at org → fighter. J4 extended one hop down: promoter → contestant named on the bout form → (optional, capped) licensed manager. This study is the **gym’s own ledger** — membership, a collectible manager share, corner work, and the gym as a sponsored entity — not a second cut of the bout agreement.

---

## Decisions page (operator calls)

This page is what the next research/build cuts from. One recommendation, one line why. Numbered **G1–G18** so nothing collides with J3 D1–D16 or J4 E1–E18.

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| **G1** | Sport-wide dues / membership number | **Do not author one.** A gym’s own posted rate is primary for **that** gym, not for MMA, boxing, or Muay Thai as a sport. Aggregated “typical monthly” figures are journalism. | No commission, ABC page, or catalog org publishes a gym-dues table. J2 §6.3: no invented numeric default. |
| **G2** | Do roster professionals pay dues, or trade them for a desk share? | **CUSTOMARY, not a rule.** Observed practices split: some gyms charge pros a floor fee; some waive dues for high-level names; some trade access for a coach/manager percentage. If the trade is ≥ 10% of a gross purse, that **is** a manager contract (J4 E3) and Area 2’s gates apply. Do **not** store “pros train free” or “pros pay X” as a default. | No retrieved statute assigns a professional a gym-dues obligation or a gym-of-purse substitute. |
| **G3** | What is the honest post-R43 floor? | **Gym-authored membership / training-floor fees**, with `evidence`, or **omit the line**. That is what a real gym lives on. It is not a cut of the bout agreement. | The game already runs payroll and upkeep and has never asked where the money in comes from except the wrong-party purse and an invented sponsor cheque. |
| **G4** | NGB / federation club fees vs gym dues | **Different objects.** USA Boxing 2026 **club** membership is **$205**/year (NGB → club). IBJJF entry is fighter → operator (J2). IMMAF/CMMAF is NF inscription (J2). Do **not** use any of those as FightCamp gym dues. | Collapsing an NGB fee into gym cash would be J2 D2 in another coat. |
| **G5** | California gymnasium licence — does it set dues? | **No.** It licenses a facility class. `4 CCR 208` still prints **$10**/year and cites `BPC 18685`; live `BPC 18685` is a **bond-equivalent** section, not a gymnasium definition. `BPC 18817` ceiling **$200**. Exact current dollar **UNKNOWN**. NV `467.012` has **no** separate gym class. | A licence fee is not a member-dues table. Do not debit $10 or $200 as rent. |
| **G6** | When is a filed manager share **collectible** as gym income? | Three gates, **all**: (1) a management contract **on file** and honored in the event jurisdiction, (2) the **combatant’s approval** to deduct (`NAC 467.137(3)`; NV bout form initials), (3) a **manager licence in the event state**. Missing any gate → **$0** of that purse at the table. | Caps (J4 E2) answer “how much may be taken.” Collectibility answers “whether the desk is paid at all.” |
| **G7** | What the desk loses when a gate is missing (J4 E9) | **The share is not deducted.** The combatant is paid in full on the bout agreement (E1). An unlicensed manager in NJ **must not deal** with a promoter (`13:46-6.10`). A suspended manager stops negotiating and, in NJ, stops the corner (E9). This is **not** a fighter medical hold. | The bout still happens. The gym does not get a silent fallback cut. |
| **G8** | Out-of-state contract vs event-state licence | **Recognition ≠ licence.** NY **may** give effect to an ABC-member contract (`19 NYCRR 209.2(b)(2)`). CA **may** recognize a non-form contract entered in another jurisdiction (`BPC 18855`; `4 CCR 220`). NV **may** honor a non-form contract if terms comply (`NAC 467.102(3)`). The manager still needs the **event-state** licence (`NRS 467.100`; `4 CCR 216`; NY `206.5`; NJ `13:46-5.8(a)`). | Reciprocity of **suspensions** is ABC-member (J3 D7). Reciprocity of **manager licences** is not automatic. |
| **G9** | Default manager % as gym revenue | **Do not author one.** Cite J4 E2. Store a **cap**, never 10 / 15 / 20 / 33 as the take. The filed number, if any, is the number. | Re-deriving the cap is forbidden. Inventing a default % is the 2am decision this desk exists to stop. |
| **G10** | Gym cut of purse as a second tax | **Do not add `gym_cut`.** Cite J4 E3. A gym taking ≥ 10% (NV/NJ) or > 10% (CA) of the gross purse **is** a manager. | No commission publishes a gym-of-purse table. The 10% definition is the tripwire. |
| **G11** | Is a gym **paid** for supplying corners? | **UNKNOWN as a published gym invoice.** J4 E4 stands: corner work is a **fighter/manager expense**, not a promoter statutory wage. UFC-shaped cutmen are often **promotion-provided**. Boxing “2–3% to the cutman” is **CUSTOMARY** journalism, not ABC. | No retrieved statute pays a gym for putting licensed seconds in a corner. |
| **G12** | Seconds vs the gym as payee | The **second’s licence is individual** (J4 E7 table). `NAC 467.635`: max **three** seconds, **four** if the Commission authorizes for a world title or special event. A gym that supplies licensed people is a private arrangement between fighter, coach, and gym. | Do not treat “the gym cornered” as a commission cheque to `gym["cash"]`. |
| **G13** | Corner-fee table for the 13 | **Do not author one.** PFL / ONE / GLORY / RIZIN / the regional nine: **UNKNOWN**. Keep E4. | Same discipline as J4 E13 (no 13-row camp-dollar table). |
| **G14** | Gym as a sponsored entity (signage, apparel, facility naming) | **CUSTOMARY / per-deal.** Press-release partnerships exist. Published **dollar** tables for independent combat gyms: **not retrieved**. Do **not** invent a naming-rights formula. | Not fighter-side outfitting (J3 D15). Not a manager share of remaining fighter-side money (J4 E17). |
| **G15** | D15 / E17 add-on | **Do not redo.** `house_kit` still strips fight-week patches. A filed manager share **may** claim remaining fighter-side money under `fighter_sponsors`. Off-cage endorsements **UNKNOWN** as inside the 33⅓% ring-earnings cap. | One sentence already. Not a second outfitting system. |
| **G16** | Live `Sponsorship.gd` weekly cash | **Already the gym-as-entity cheque.** Invented magnitude (`TIER_WEEKLY_CASH` default **250** + `(roll % 3) * 25`). Keep the object; **label it invented**; do not add a second naming-rights sim on top. | `:224` branches on `entity_type` (J2 P12). `Sponsorship.settle_week` already credits `gym["cash"]` (`:5114`–`:5116`). |
| **G17** | UFC Gym franchise / Performance Institute / promoter-owned gym | **Scenery.** A licensed fitness-chain or a promotion’s own facility is not the player’s desk. | J2 §6.2. A new product, not a missing settlement line. |
| **G18** | **Minimum change** (this study’s D16 / E18) | Four one-liners — see each area’s (d). Build order is the priority ruling, not a fifth system. | Stops the hole J4 named without a fabricated gym cut and without a manager-simulator. |

**Fifth area?** No. A playable agency / second career would be a new mode. It does not outrank an honest gym ledger after R43. Park it as scenery (priority ruling).

---

## File-level anchors (what is live vs this study)

| File / fact | Role | Live? | Honesty |
|-------------|------|-------|---------|
| **`GameState.gd:10253` settlement** | `gym["cash"] += purse + win_bonus + performance_bonus + gate_share - expenses` | LIVE (excerpt); **R43 changing** | **Wrong party paid** (J4 E1). After R43 this line must **not** credit the gym the bout-agreement money. First row of this study’s economy. |
| `GameState.gd:10257` `career_earnings` | Ambitions “Financial Security” counter | LIVE | **Counts** the purse onto the athlete; **does not pay** the athlete. Stays the fighter’s bout-agreement gross (J4 Area 1 issue 1). |
| **`_settle_billing` (`:4658`)** | Accrues `this_week_payroll` + `this_week_upkeep`; when the calendar month turns, `gym["cash"] -= billed` | LIVE | Honest **shape** of a monthly bill. Magnitudes of payroll/upkeep are **game-authored**. Never asks where the credit comes from. |
| Week advance `:5108`–`:5116` | `payroll = Σ athlete["weekly_salary"]`; `_settle_billing(payroll, upkeep, …)`; `Sponsorship.settle_week` → `gym["cash"] += sponsorship_income` | LIVE | **Two** live cash motions after a week: a **debit** (payroll/upkeep, billed monthly) and a **credit** (invented sponsor weekly). After R43 the purse credit at `:10253` goes away. |
| `athlete["weekly_salary"]` | Payroll input | LIVE | **Invented polarity.** Real roster professionals are not, as a published rule, gym employees drawing a weekly wage (J4 E14: classification contested; do not ship). The game pays athletes **out** of gym cash every week. |
| `gym_cut` / `manager_cut` / `purse_share` | — | **Absent** (J4) | Correct absence of a default %. The hole after R43 is **inflow**, not a missing tax. |
| Fighter cash / wallet | — | **Absent** | `career_earnings` is a counter. R43 must credit the athlete something spendable or the payee fix is cosmetic (J4 E20). |
| Membership / dues / drop-in / camp-fee object | — | **Absent** | The real-world gym floor. Never modelled. |
| Manager contract on file / combatant approval / event-state licence | — | **Absent** | Collectibility gates (G6). J4 E7 licence flag only if a share is paid. |
| Corner / seconds fee line to the gym | — | **Absent** | Honest omission of a non-rule (G11). |
| `Sponsorship.gd:224` | `entity_type` → template (J2 P12) | LIVE | J3 D15 adds `outfitting_policy`. This study does **not** redo that branch. |
| `Sponsorship` offer `weekly_cash` | `TIER_WEEKLY_CASH.get(tier, 250) + (roll % 3) * 25` | LIVE | **Invented** dollars. Honest **shape** as gym-as-entity income. G16: keep; do not stack a naming-rights sim. |
| `FightContract.settlement_for` | Fighter-shaped net, then `:10253` gave it to the gym | LIVE (J4) | Destination is R43. Do not skim a gym cut off `net`. |
| R40 / `get_promotion_bout_offer` | Federations still payable as promotions until R40 | LIVE (J2) | **Not this sprint.** J2 D6 stands. |
| Manager-simulator / second mode | — | **Absent** | Correct. Scenery (J2 §6.2, J4 E9). |

---

# Area 1 — Membership, dues, and the training floor

Fees a gym charges its own members and its own professionals. What is **published** (a gym’s own posted rates are primary for THAT gym, not for the sport), what is **CUSTOMARY**, and what is **UNKNOWN**. Whether a fighter on the roster pays dues at all, or trades them for the desk’s share.

## (a) Decisions coming (named as calls)

1. **Call: sport-wide dues number.** Store a monthly default, omit, or gym-author with evidence.
2. **Call: roster professionals.** Pay dues, train free, or trade access for a percentage.
3. **Call: NGB / federation fees vs gym dues.** Same ledger, or different objects.
4. **Call: gymnasium licence.** Does a commission gym licence set what members pay?

## (b) Evidence (cited) + UNKNOWN discipline

### No commission publishes a gym-dues table

**Nevada.** `NAC 467.012` (already J4 E7) lists combatant, manager, second, matchmaker, promoter. **No** gymnasium / club-dues class. `NRS 467.100`: contestants, promoters, managers, seconds, trainers, and ring officials must be licensed. A training gym that is not promoting a contest is **not** on that list as a dues-setting body.

**California.** Two different objects, easy to mash:

| Object | What is published | Sets member dues? |
|--------|-------------------|-------------------|
| **Professional trainer** `BPC 18653` (verified 2026-09-06) | No person shall **train** a professional boxer, kickboxer, or martial-arts athlete unless licensed. A professional trainer (five years) must be in the corner unless the commission/executive officer authorizes otherwise | **No.** Licence-in-the-corner (already J4 E4), not a fee schedule |
| **Gymnasium licence** `4 CCR 208` (Register 2026, No. 30, through 2026-07-24) | Application to conduct or operate a professional boxer’s gymnasium “within the meaning of Section 18685 of the code” accompanied by annual fee **$10.00**; expires midnight 31 Dec | **No.** A facility licence |
| **Gymnasium fee ceiling** `BPC 18817` | Application and renewal “shall not exceed **two hundred dollars ($200)**” | Ceiling, not a member rate |
| **Post the licence** `4 CCR 495` | Licensed professional boxers’ training gymnasiums shall post the licence in a conspicuous place | Display, not dues |

**Stale cross-reference (do not wire blindly).** Live `BPC 18685` (verified 2026-09-06) is in Article 5 **Bonds**: a certificate of deposit or assigned savings account is equivalent to a bond. It is **not** a gymnasium definition. `4 CCR 208` still points at “Section 18685 of the code” for the meaning of a professional boxer’s gymnasium. Historical `BPC 18653` text (older compilations) defined a “professional boxers’ training gymnasium” as a gymnasium whose **principal business** is training facilities for professional boxers **and** in which a fee is charged to professional boxers **or** to persons who view their training; “principal business” = more than 50% of annual gross income **or** of total use; a camp established by a boxer for his or her sole use was carved out. **Whether that definition still sits in a live BPC section under another number: UNKNOWN this pass.** Confirm at wiring. Do **not** invent the missing article.

**New Jersey / New York.** No retrieved gymnasium-dues chapter in `N.J.A.C. 13:46` or `19 NYCRR` 206–214 this pass. Seconds, managers, promoters, combatants are licensed. The gym as a **membership business** is private contract.

**Ruling on G5:** a CA gymnasium licence, if still a live class, is a **facility** flag and a small annual fee. It does not author what members pay. NV does not have the class in `467.012`. Do not debit $10 or $200 as FightCamp rent.

### A gym’s own posted rate is primary for THAT gym

Combat gyms **do** publish prices — on their own membership pages. Those pages are **primary for that gym**. They are **not** a sport-wide schedule.

This pass retrieved, without ingesting names as data:

- Secondary aggregators of named US MMA gyms’ **unlimited-membership** pages (2026 journalism) quote a cluster in the **low-to-mid hundreds of USD per month**, with drop-ins, single-discipline, and registration-fee variants. The cluster is **SECONDARY**. The underlying gym pages, if filed, are primary **for those gyms**. **Do not author $199, $150, or $265 as the sport.**
- Individual US boxing-gym membership pages retrieved this pass list adult unlimited / class-pack / youth tiers in a similar **low-hundreds USD/month** band, plus drop-in / day-pass prices. **That gym, that city.**
- A UK boxing club retrieved this pass publishes **pay-as-you-go session** prices (single-digit to low-tens of GBP) rather than a lock-in membership. **That club.**
- A Japan MMA gym retrieved this pass publishes yen monthly / visitor / “pro session” prices on its own site. **That gym.** A “pro session” price on one academy page is not Rajadamnern or ONE house law.

**Do not** turn any of those pages into a catalog row. **Do not** average them. J2 §6.3: author a line item from a cited schedule, or omit.

**UFC Gym** (licensed fitness-chain) location pages publish promotional monthly rates in a **different** product (weights / group fitness / some martial-arts add-ons). That is **not** the player’s combat gym. G17: scenery.

### Do roster professionals pay dues?

**No retrieved statute says they must, and none says they must not.**

CUSTOMARY practice, labelled as such, from **secondary** interviews this pass (do **not** use the named coaches, gyms, or athletes as data):

| Practice | What was described | Kind | Usable as a default? |
|----------|--------------------|------|----------------------|
| Floor fee, no purse cut to the **gym** | A 2025 coach interview: house policy that professionals pay a **flat monthly gym fee** for full access; coach percentages are a **separate** negotiation with the coach, not a gym-of-purse | **CUSTOMARY**, one gym’s policy | **No** |
| Waive dues for high-level names; coaches take a private % | A 2025 secondary interview with a named high-level MMA head coach: high-level fighters “train for free” at the gym; they pay the **instructors who train them**, not the gym as such | **CUSTOMARY**, one gym’s policy | **No** |
| Trade access for a percentage | Journalism and coach-advice videos describe 5% / 10% / 20% “to the coach” depending on camp + corner + whether the coach is also managing | **CUSTOMARY**. If the take is ≥ 10% of the **gross purse** for services relating to the contest, J4 **E3** / `NAC 467.0028` / `BPC 18628` / NJ manager definition: that person **is a manager** and Area 2 applies | **No** — and the 10% tripwire is statutory, not a dues rule |

**UNKNOWN (do not invent):** a published “pros pay N% of purse to the gym” table for any of the 13 promotions; whether a monthly membership is creditable against a purse; Muay Thai gym traditional cuts in Thailand as a numbered Rajadamnern or ONE bylaw (already J4: Bangkok Post 2026-07-23 is a **reported private arrangement**).

**Amateur / recreational members** are the gym’s ordinary cash register. That is the business. It is almost entirely **private contract**. Commissions regulate **contests**, not the front-desk till.

### NGB / federation fees are not gym dues (G4)

| Fee | Who pays whom | Published 2026 figure | FightCamp object? |
|-----|----------------|------------------------|-------------------|
| **USA Boxing club** membership | Club → USA Boxing | **$205**/year from the 2026 rate card (was $180; announced 2025-11-07, effective 2025-11-13) | **NGB overlay**, amateur boxing, **not in the 18**. Do not use as gym dues |
| USA Boxing **athlete** membership | Athlete → USA Boxing | Age-banded **$60–$95**/year on the same card | Amateur athlete licence, not gym cash |
| USA Boxing **fitness** membership | Member → USA Boxing; gym receives **$5** of the fee | Youth **$25** / adult **$35** (USA Boxing fitness-membership page, verified 2026-09-06) | NGB product. The $5 club credit is **that** NGB’s rule, not a combat-gym dues formula |
| **IBJJF** membership + event entry | Athlete → operator | J2: published per packet; UNKNOWN if packet missing | J2 `open_entry`. **Not** gym dues. Academy *promotion* charges are gym-level, **UNKNOWN** as an IBJJF number (J2) |
| **IJF card / UWW licence / WT GAL** | NF → IF (athlete cannot buy) | J2 §1–§2 | J2 `national_selection`. **Not** gym dues |
| **CMMAF** domestic membership | — | **UNKNOWN** (J2 §1.4) | Do not invent |

**Ruling on G4:** keep NGB/IF fees on their J2 pathway. A USA Boxing club cheque is not `gym["cash"]`. An IBJJF entry debit is not a monthly membership.

### The game already pays athletes **out** of the gym

Excerpt `:5108`–`:5110`: payroll is the sum of `athlete["weekly_salary"]`. J3 noted the retention market salary as `250 + rating×22` (+fame/4) — **invented**. Real roster professionals are typically independent contractors (J4 E14: contested; store nothing). The live game therefore has:

- **Out:** weekly salary to every roster athlete, accrued and billed monthly with upkeep.
- **In (today):** 100% of the bout-agreement purse at `:10253` (wrong party — R43).
- **In (today):** `Sponsorship.settle_week` weekly cash (invented).
- **In (absent):** membership, drop-in, camp fee, merch, privates.

After R43 the first **in** dies. The **out** does not. That is the hole. The honest floor is membership (G3), not a fabricated gym cut (G10 / J4 E3).

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| Gym cash in from purses | 100% at `:10253` | **Lie.** R43 / E1 / E23 |
| Gym cash in from membership / dues | none | **Absent** — the real-world floor |
| Gym cash in from sponsorship | `Sponsorship.settle_week` weekly | **Invented** magnitude; honest **shape** as gym-entity income |
| Gym cash out payroll | `Σ weekly_salary`, monthly bill | **Invented polarity and magnitude**; honest as a **cost** object |
| Gym cash out upkeep | accrued weekly, billed monthly | **Game-authored** cost. Source of the offsetting credit: never asked |
| Pro dues vs free vs % trade | none | **Absent** (and must not be invented as a default) |
| CA gymnasium / NV gym class | none | **Absent** — correct as MVP. A $10 flag is scenery |
| NGB club fee as gym income | none | **Honest omission** |

## (d) Minimum change (one concrete recommendation)

**Do not author a sport-wide dues percentage or a default monthly dollar. If the gym needs an honest inflow after R43, add a gym-authored `membership` / training-floor line that credits `gym["cash"]` only when a rate is filed with `evidence` (that gym’s posted page, or an explicitly labelled `INVENTED` gameplay fee). If no rate is filed, omit the debit-and-credit pair — do not invent USD 0 as a fake fee (J2 §6.3). Do not treat roster-pro access as a purse tax. Do not import USA Boxing $205 or IBJJF entry as gym dues.**

Payroll and upkeep stay gym costs. If the remaining live credit is less than those costs, **say so in the priority ruling** and retune the **economy**, not the bout-agreement payee.

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — Temptation to ship “$150/month, that’s what a coach said.”**  
**Solution:** G1. CUSTOMARY interview ≠ a rule. UNKNOWN policy.

**Issue 2 — Temptation to waive dues and take 20% of the purse instead, “because that’s the gym.”**  
**Solution:** G2 + G10 + J4 E3. ≥ 10% of gross purse **is** a manager. Collectibility is Area 2. No silent `gym_cut`.

**Issue 3 — Named gyms’ membership pages as catalog data.**  
**Solution:** Standing rule. Cite the *kind* (posted monthly / drop-in / class-pack). Do not ingest gym names, coach names, or a scraped price table as `assets/data`.

**Issue 4 — UFC Gym / chain fitness pricing looking like combat-gym dues.**  
**Solution:** G17. Different product. Scenery.

**Issue 5 — Brand / USA Boxing, IBJJF, CSAC gymnasium certificates.**  
**Solution:** J1 §4.1. Text names in research. No seals, no photographed licences, no named operators as data.

**Issue 6 — Player fantasy: “I own the fighter, I don’t need members.”**  
**Solution:** After R43 that fantasy is an empty till plus a monthly payroll. The desk is a **gym**. Gyms live on the floor.

---

# Area 2 — The manager share, as a revenue line rather than a deduction

J4 **E2/E3** ruled the cap side (NV/CA/NJ 33⅓% of ring earnings; NY ≥ 50% floor to the combatant; a gym taking ≥ 10% of a gross purse **is** a manager and must be licensed as one). **Do not re-derive those.** The open question is the other direction: when a filed manager share is the gym’s **income**, what is required for it to be **collectible**, and what the desk loses when any gate is missing (J4 **E9**).

## (a) Decisions coming (named as calls)

1. **Call: collectibility gates.** Contract on file, combatant approval, event-state licence — which are required, in which jurisdiction.
2. **Call: what missing a gate costs the desk.**
3. **Call: out-of-state contract vs event-state licence.**
4. **Call: default % as revenue.** Cite E2; do not re-derive.

## (b) Evidence + UNKNOWN

### The three gates (G6)

A manager share becomes gym income **at the commission table** only if the event jurisdiction will **honor the deduction**. Caps (E2) are the ceiling **after** that. The gates:

| Gate | Nevada | California | New Jersey | New York |
|------|--------|------------|------------|----------|
| **1. Contract on file / honored** | `NAC 467.102(1)` (verified 2026-09-06): Commission **may refuse to honor** unless filed **at least 72 hours** before the contest and it complies with this section. Electronic filing permitted at Commission discretion (`467.102(8)`). Non-form contracts **may** be honored if terms comply; terms over the limitations honored **only to the extent** of those limitations (`467.102(3)`). Term **> 4 years**: will **not** honor beyond 4 (`467.102(4)`) | `4 CCR 221(a)`: original on file at approval. `4 CCR 222` (verified 2026-09-06): **not valid** unless both parties appear at the same time before the commission or a representative **and** it receives **written approval**, unless otherwise directed. Max **5 years**; **no option** to extend. `4 CCR 220` / `BPC 18855`: commission form; **may** recognize a contract not on the printed form if **entered into in another jurisdiction**; **no other** contract recognized | `N.J.A.C. 13:46-5.5`: all boxer-manager contracts and written agreements **must be filed**. First time boxing in NJ: sign NJ forms in triplicate before a notary or Commission official. `13:46-6.4`: manager entitled to no more than 33⅓% of ring earnings of a boxer with a **properly filed** contract | `19 NYCRR 209.2(b)(1)` (verified 2026-09-06): executed **in person before the Commission** on approved forms unless otherwise authorized; **approved by and filed with** the Commission. `209.4`: shall **not exceed three years** unless the Commission authorizes. First-time parties: either **may cancel** without penalty by written notice before the **11th month** |
| **2. Combatant approval to deduct** | `NAC 467.137(3)` (verified 2026-09-06): a manager’s share **may, with the approval of the unarmed combatant**, be deducted and paid to the manager **if** the management contract so specifies **and** complies with `NAC 467.102`. NSAC Official Bout Agreement **O-460** §7 (four conditions, **all**): (a) Manager **licensed by the Commission**, (b) **valid contract on file**, (c) amount **does not exceed one-third** of the compensation, (d) Contestant **specify and initial** the amount | `4 CCR 221(b)` last sentences: any boxer **not** having a contract with a **licensed** manager shall sign for his own contests and **receipt for his full purse**. Deduction is the filed contract, not a silent gym default | `13:46-6.4(b)`: if the boxer performs **without** the manager’s permission, the manager **may request** the Commissioner to hold ⅓ of the purse — the inverse case, still a **filed** relationship | `19 NYCRR 209.13` (verified 2026-09-06): promoter pays **by cheque payable to the participating combatant**, who signs receipts, unless otherwise directed. **No payment shall be made to any person or party other than as set forth herein unless the Commission has approved the transaction.** NYSAC MMA bout form (DOS 2072-F): optional third-party distributions, combatant remains solely responsible for manager fees — **Commission-approved** path, not a gym self-help |
| **3. Licence in the event state** | `NRS 467.100`: no person may participate, directly or indirectly, unless licensed **by the Commission**. NSAC boxer/manager notes: **both** must be licensed for the **current year**; contract **cannot** be signed outside the commission office | `4 CCR 216` (verified 2026-09-06): boxers and managers **licensed in other jurisdictions** signing a contract with a promoter to box in this state **shall have made application** for a licence with **this** commission, and the **boxer shall have been issued** a licence **prior to signing any contract**. Exam **may** be waived if licensed elsewhere without discipline (J4 E7) — that is a **waiver of the exam**, not a skip of the CA licence. `4 CCR 221(a)`: contract becomes null/void if the manager, after notice, is **not licensed** | `13:46-5.8(a)` (verified 2026-09-06): **both parties** to a boxer-manager contract **must be licensed** by the State Athletic Commission **or the same shall not become effective**. `13:46-6.10`: **no unlicensed manager shall deal with any promoter or matchmaker**. `13:46-6.3`: unrenewed or revoked → contract **may not be recognized** | `19 NYCRR 206.5(a)` (verified 2026-09-06): no manager shall engage, directly or indirectly, unless first procuring the appropriate licence. `207.1` sister. `209.2(b)(2)` may give **effect** to an ABC-member contract **to the extent** it does not conflict with federal / NY law and Commission rules — **not** a substitute for a NY manager licence to **act** in NY |

**Self-signing if no licensed manager (already J4 E1, restated as collectibility):** `NAC 467.102(5)`; `4 CCR 221(b)`. The combatant signs and receipts **the full purse**. There is no residual gym share.

**Assignment** is a **fourth** paper, not a shortcut around the gates. NV `NAC 467.137(5)`: assignment of monetary interest on a Commission-approved form. `NAC 467.102(7)`: non-monetary interest may not be assigned unless written assignment signed by both is submitted **and** the Chair (or designee) approves. CA `4 CCR 221(b)`: no assignment of a filed contract interest without Commission consent.

**Dispute:** NV `NAC 467.137(4)` — if arbitration is pending before the Commission or the contract is in litigation, the Commission **may withhold** the amount in dispute or deposit it with the court clerk. That is **escrow**, not a gym win.

**CA books:** `BPC 18851` (verified 2026-09-06, applies to boxers **or martial arts fighters**): a manager shall keep an annual record of (a) training expenses, (b) amount actually paid the contestant, (c) amount the manager received **from the purse**, (d) amount owed to the manager, supported by documentation, available to the fighter and the commission, kept **five years**. That is **accounting after** a collectible share, not a licence to take one.

### What the desk loses when a gate is missing (G7 / E9)

| Missing | What happens to the purse | What happens to the desk |
|---------|---------------------------|--------------------------|
| **No contract on file / not honored** | Combatant paid in full on the bout agreement (NV `467.137(1)`; NY `209.13`; CA `221(b)` self-sign path) | **$0** of that purse as a commission deduction. Private IOU, if any, is **not** this game’s object and is **UNKNOWN** as a collectible default |
| **Contract on file, combatant does not approve the deduction** | NV `467.137(3)` is permission, not a levy. O-460 requires **initials**. NY pays the combatant unless the Commission approved a third-party payment | **$0** at the table |
| **Unlicensed in the event state** | Same self-sign / full-purse path. NJ: unlicensed manager **shall not deal** with promoter or matchmaker (`13:46-6.10`) | Cannot negotiate the bout (NJ explicit; NV/CA/NY licence-required to act). **$0** share |
| **Licence suspended / revoked / unrenewed** | J4 **E9** stands. CA `4 CCR 221(a)`: revoked or suspended **≥ 60 days** → contracts void on **day 30** unless stayed; shorter suspension → **voidable by the boxer**. NJ `13:46-6.3`: contract **may not be recognized**. NJ `13:46-6.6`: must **not** work a corner or negotiate. NV form: permanent suspension → contestant **may terminate** as to NV contests; manager takes **no percentage** of earnings the contestant books during a non-permanent suspension | Booking refusal. **Not** a `medical_hold`. Full “licence RPG” is scenery (J4 E9) |
| **Arbitration / litigation** | NV may **withhold** the disputed amount | Gym does not bank the disputed dollars pending resolution |

**The bout still happens.** Missing a collectibility gate does **not** cancel the card, strip the fighter, or move a belt. It zeros the **desk’s** take of that purse. E23 is the honest default: no filed contract → gym delta **0**.

**MMA-specific restatements (already J4, not re-derived):** CA 33⅓% sits in Professional **Boxing** Rules; CSAC uses the same fighter–manager forms for martial-arts fighters (`BPC 18855`). NJ `13:46-6.4` is boxing-titled; MMA-specific % section **UNKNOWN**. NY 209-series **names** mixed martial artists. Treat collectibility **mechanisms** (file, approve, licence) as the modellable object; do not export boxing-chapter % onto a Singapore ONE card as house law (J4 Area 1 issue 5).

### Out-of-state contract ≠ event-state licence (G8)

| What can travel | What cannot |
|-----------------|-------------|
| CA `BPC 18855` / `4 CCR 220`: a contract **entered in another jurisdiction**, not on the CA printed form, **may** be recognized | Acting as manager on a CA card without a CA licence (`4 CCR 216`, `BPC 18642`) |
| NY `209.2(b)(2)`: ABC-member-state contract, valid, on file, approved there — given effect **to the extent** it does not conflict with federal / NY / Commission rules; Commission **may** honor only the complying part | Acting as manager in NY without a NY licence (`206.5`) |
| NV `467.102(3)`: non-form contract may be honored if terms comply; over-cap terms trimmed to the cap | Participating directly or indirectly without an NSAC licence (`NRS 467.100`) |
| NJ `13:46-5.8(b)`: Commissioner **may** recognize contracts on file with governmental agencies in other jurisdictions **provided they comply with the rules of the Commissioner** | Effectiveness of a boxer-manager contract without **both** parties licensed in NJ (`13:46-5.8(a)`) |

**ABC model boxer/manager contract** (abcboxing.com, verified 2026-09-06): the **percentage is a blank**. Both parties licensed with the commission where filed, or apply within **10 days**. That is a **template**, not a default take, and it is **boxing-model**. Do not ship the blank as 33⅓%.

**UNKNOWN (do not invent):** whether a Nevada manager licence is accepted **as-is** in California (practice is **re-licence in the event state** — J3 already flagged the fighter analogue); Texas / other catalog-event states; host-nation manager rules on ONE / RIZIN / RWS / GLORY cards; whether NY MMA manager licence is issued as a matter of course on an ABC-member filing without a separate NY card.

### Do not re-derive E2 / E3 (G9 / G10)

Caps remain: NV `NAC 467.102(6)` **33⅓%** of ring earnings; CA `4 CCR 221(b)` **33⅓%** of gross ring earnings (boxing chapter; MMA **INHERITED** CSAC practice until an MMA article is in hand); NJ `13:46-6.4` **33⅓%** (boxing-titled; MMA % **UNKNOWN**); NY `209.12` combatant actually receives **≥ 50%** after authorized deductions. Trigger for needing a manager licence at all: NV/NJ **10% or more** of gross purse; CA **more than 10%** (`BPC 18628`).

**This study adds only:** those numbers are **not income** unless G6’s gates pass. A cap with no filed contract is a ceiling over an empty room.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Manager share as gym credit | none (gym currently takes 100% — the lie R43 removes) | After R43: **E23 = 0**. Correct default |
| Collectibility gates | none | **Absent** |
| Event-state manager licence | none | **Absent** (J4 E7: flag only if a share is paid) |
| Combatant initials / approval | none | **Absent** |
| 72-hour / in-person filing | none | **Absent** — do not build a filing-office sim |
| Default `manager_cut` % | none | **Honest absence.** Keep it |

## (d) Minimum change

**If and only if a filed manager contract exists, credit the gym the filed share, never above the event-jurisdiction cap (E2), and only when G6’s three gates pass. Missing any gate → gym receives $0 of that purse (E23). Do not author a default percentage. Do not add `gym_cut`. Do not build a licence-exam career (J4 E7). A `manager_licensed` + `contract_on_file` + `combatant_approved` triple on US-commission cards is the whole of collectibility for MVP.**

Amateur CMMAF stays J2 D6 (no purse, so no share). Export of NV/CA/NJ/NY gates onto RIZIN / ONE / RWS: **default off** (UNKNOWN host rule).

## (e) Issues + solutions

**Issue 1 — “We’ll just take 20% so the gym doesn’t go broke after R43.”**  
**Solution:** G9 / G10 / priority ruling. Broke is an **economy** problem. A fabricated cut is a **payee** lie on top of the one R43 is fixing.

**Issue 2 — Filing-office RPG (72 hours, in-person, notary).**  
**Solution:** Collapse to flags. The 72-hour / appear-together rules are real; simulating the NSAC lobby is scenery (J2 §6.2).

**Issue 3 — Reciprocity looking like a passport.**  
**Solution:** G8. Recognition of a **contract** is not a licence to **act**. Event-state flag.

**Issue 4 — Brand / bout forms (O-460, DOS 2072-F, CSAC manager form).**  
**Solution:** J1 §4.1. Text names in research. Do not ship photographed official forms as UI art.

**Issue 5 — Unplayed manager-agency mode.**  
**Solution:** J2 §6.2. G18 is a settlement gate, not a new career.

---

# Area 3 — Corner work, seconds, and whether the gym is paid

J4 **E4** ruled the **payer** (fighter/manager expense, not a promoter statutory obligation) and the licensing (NV/CA a manager may second without a second’s licence; NJ may not; NY may second their own). **Do not re-derive those.** The open question is whether a gym **supplying** corners is **paid** for it, by whom, and whether any of it is published.

## (a) Decisions coming (named as calls)

1. **Call: is the gym a payee for corner work?**
2. **Call: seconds as people vs the gym as an entity.**
3. **Call: a corner-fee table for the 13.**

## (b) Evidence + UNKNOWN

**Expect large UNKNOWN. Say so.**

### Who the statute pays (already E4, restated as gym-income)

No retrieved NV / CA / NJ / NY section requires the **promoter** to pay a cutman or cornerman a wage. Licence fees are paid **by the licensee** (J4 E7 table: NV second **$50**; CA **$50**; NJ **$25**; NY boxing **$10** / MMA **$40**). That is a **cost to the person in the corner**, not a cheque **to the gym**.

`NAC 467.635` (verified 2026-09-06 via chapter + `nvrules.elaws.us` text): no unarmed combatant may have more than **three** seconds except that in a contest for a **world title** or a **special event** the Commission may authorize **four**. Only **one** of the seconds may be inside the ring ropes during rest. That is a **count**, not a fee.

Indiana `68 IAC 24-4-7` (out of the four-jurisdiction set; **NATIONAL**, do not copy onto NSAC): corner men must hold a second, manager, or trainer licence; max three, four for championship/main event. Again a **licence-and-count** rule, not a gym invoice.

CA `BPC 18653`: a licensed **professional trainer** shall be present in the corner unless authorized otherwise. **Who writes that trainer a cheque: UNKNOWN as a statute.**

### CUSTOMARY journalism (do not wire)

| Claim | Source kind | Status |
|-------|-------------|--------|
| Cutman takes **2–3%** of the fighter’s prize | Wikipedia *Cutman* (verified 2026-09-06), citing 2004 secondary; 2026 boxing-finance explainers repeat **~3%** “corner/cutman” as a planning line | **CUSTOMARY / SECONDARY.** Not ABC. Not a commission fee schedule. **Do not author 3%** |
| Trainer takes **~10%** of the purse | Same explainers; coach-advice videos (5% corner-only / 10% camp+corner / 20% if also managing) | **CUSTOMARY.** 20% of gross purse for bout-related services **is** a manager under E3. **Do not author 10%** as a gym line |
| On smaller shows, corners work for **expenses or nothing** | Secondary explainers | **CUSTOMARY.** Matches “UNKNOWN as a published gym invoice” |
| **UFC-shaped cutmen are promotion-provided**, paid per event as independent contractors, assigned to corners, often barely speaking to the fighter; boxing cutmen are typically part of a specific fighter’s team | *The Athletic* 2019-07-03 (SECONDARY); Wikipedia *Cutman* (MMA “generally provided by the promotion” to prevent “greasing”) | **CUSTOMARY for that promotion’s practice**, not a 2026 UFC.com bylaw retrieved this pass. **Gym is not the payee** |
| Grounded MMA “UFC cutman makes 2% or a flat fee” | SECONDARY 2022, mixed with invented year-salary arithmetic | **Do not wire.** The Athletic’s named cutmen **declined to disclose** the UFC per-event number |

**Catalog 13, camp/corner pay:** already J4 E13. UFC 2026 primary: **not retrieved**. PFL 2025 World Tournament Rules PDF: **no** camp/travel/corner schedule. ONE / GLORY / RIZIN / the regional nine: **UNKNOWN**.

**Game today:** `FightContract.opening_terms` covers travel/hotel (promoter-shaped, invented dollars). No corner-fee line. **Keep that omission** as to gym income.

### Is the gym paid?

**Published commission answer: no.**  
**Published promotion answer: not retrieved as a gym invoice.**  
**CUSTOMARY answer: the fighter or manager pays coaches/cutmen by private agreement, or the promotion staffs cutmen, or nobody is paid on the small show.** None of those is “the gym invoices the commission.”

A gym that **employs** licensed seconds and then invoices the fighter is running a **private** payroll. That contract is **UNKNOWN** as a published schedule. It is also easy to confuse with G2 (dues vs % trade) and with E3 (10% tripwire). Do not merge them.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Corner wage to gym | none | **Honest omission** of a non-rule |
| Second licence | none | **Absent** (J4). Flag later, not a fee table |
| Number of seconds | none | **Absent.** `NAC 467.635` is a count if ever shown |
| Travel/hotel | promoter opens covering | **Honest shape** (E4 / E13). Keep |
| UFC-style promotion cutman | none | **Absent.** Promoter-side. Do not credit the gym |

## (d) Minimum change

**Do not add a corner-fee or cutman-% line to `gym["cash"]`. Do not author 2%, 3%, or 10%. E4’s payer stands. If a later data file authors a fighter-side corner expense, it needs `evidence` and a payer field (`athlete` / `manager` / `promoter`) — and the payee is that person, not the gym, unless a private contract is filed, which this pass does not have.**

## (e) Issues + solutions

**Issue 1 — Inventing 3% “so the corner exists as money.”**  
**Solution:** UNKNOWN policy. The corner already **exists** as licensed people and as E4. Money ≠ existence.

**Issue 2 — UFC promotion cutmen looking like gym income.**  
**Solution:** Opposite polarity. If ever shown, it is a **promoter compliance** object (like event insurance, J4 E11), not `gym["cash"]`.

**Issue 3 — Named cutmen as data.**  
**Solution:** Standing rule. Cite the practice class, not the names.

**Issue 4 — Unplayed second/cutman mode.**  
**Solution:** Scenery. J4 E9 / J2 §6.2.

---

# Area 4 — Sponsorship and the gym as an entity

`Sponsorship.gd:224` already branches on `entity_type` (J2 P12) and J3 **D15** adds `outfitting_policy ∈ {house_kit, fighter_sponsors}`. J4 **E17** added one sentence about a manager share of remaining fighter-side money. **Do not redo D15 or E17.** The open question is the **gym** as a sponsored entity in its own right — signage, an apparel deal, a facility naming deal — and whether anything about that is published or is entirely CUSTOMARY.

## (a) Decisions coming (named as calls)

1. **Call: gym-level signage / apparel / facility naming** — published vs CUSTOMARY vs UNKNOWN dollars.
2. **Call: relation to live `Sponsorship.gd` weekly cash.**
3. **Call: UFC Gym / PI / promoter-owned gym** — playable, or scenery.

## (b) Evidence + UNKNOWN

### Three different sponsorship objects (keep them un-mashed)

| Object | Who is paid | Status in prior packs | This study |
|--------|-------------|----------------------|------------|
| **Fighter-side fight-week kit** | Fighter (or, under `house_kit`, **nobody** — compliance cheque is promotion-authored) | J3 **D15**. UFC `house_kit` (Venum through 2029, SECONDARY-confirmed). Other 12: default `fighter_sponsors` | **Do not redo** |
| **Manager share of remaining fighter-side money** | Filed manager, if any | J4 **E17**. Ring-earnings cap language is **bout** money; off-cage **UNKNOWN** as inside the cap | **Do not redo** |
| **Gym as sponsored entity** (wall signage, apparel on the **facility**, naming of the room / gym) | The **gym** | Not previously studied | **This area** |

### What is published

**Independent combat gyms.** Gyms post “sponsor us” menus on their own sites (banner, gi patch, social tags, annual tiers). Those pages are **primary for that gym**. Dollar examples retrieved this pass (a Japan academy’s published yen ranks; regional fight-night canvas/naming menus) are **that seller’s rate card**, not a sport schedule. **Do not author them as catalog.**

**Apparel brands × gyms.** Press-release partnerships exist: a brand stocks the shop, wraps bags and ring aprons, outfits the team. A 2023 Top Rank / Venum release (PR Newswire 2023-11-13) announced Venum as corporate sponsor of **Top Rank Gym** with branded equipment — a **promoter-owned** boxing gym, **not in the 18**, dollars **unpublished**. Other gym–brand announcements retrieved this pass are the same shape: **copy, no cheque**. Wholesale programs (gym buys gear, resells under MAP) are **merch margin**, not a naming-rights formula.

**Facility naming rights as a sports-business product.** SBJ’s Sports Facility Naming Rights Directory (page dated 2026-09-06) covers stadiums, arenas, college and practice facilities — **hundreds of deals, terms often unpublished**. It is **not** an MMA-gym schedule. No retrieved row in that class is “independent combat gym, published annual dollar.”

**Catalog promotions’ own facilities / kits.** UFC outfitting is D15 (fighter kit, **not** gym naming). Monster / Crypto.com / octagon-mat branding are **promotion** inventory (SBJ 2025-02-19 QuikTrip-via-Monster; ESPN Crypto.com kit rights) — **promoter-side**, not the player gym. PFL sponsor agreements in litigation exhibits (SECONDARY) are **league** deals. **Do not** credit those to `gym["cash"]`.

**UFC Gym (fitness chain) / Performance Institute.** Licensed brand / promotion facility. **Not** the player’s desk. G17: scenery.

### What is CUSTOMARY / UNKNOWN

| Item | Kind |
|------|------|
| A local business paying a combat gym for a wall banner or a kids-class title | **CUSTOMARY.** Dollars **UNKNOWN** as a universal |
| Team apparel deal (brand gives kit, gym gives photos and a shop shelf) | **CUSTOMARY.** Value **UNKNOWN** as a 2026 primary table |
| Naming the facility after a sponsor | **CUSTOMARY** at the independent-gym scale; **published** at the stadium scale (not this product) |
| A formula mapping gym reputation → weekly sponsor dollars | **Invented** — and it is what `Sponsorship.gd` **already does** (`TIER_WEEKLY_CASH`, default 250 + 0–50) |

**Ruling on G14 / G16:** gym-level sponsorship **exists as a kind**. Published **sport-wide dollars** do not. The live `Sponsorship.settle_week` cheque **already occupies this chair** as an invented gym-entity inflow. Adding a second naming-rights object with invented dollars would be D14 (PPV %) in a facility coat.

## (c) What the game does today

| Object | Today | Honesty |
|--------|-------|---------|
| Gym-entity weekly sponsor cash | LIVE (`settle_week` → `gym["cash"]`) | **Invented** magnitude; honest **shape** |
| `entity_type` branch | LIVE (`:224`, J2 P12) | Honest **gate**. D15 outfitting sits on top |
| `outfitting_policy` | Proposed J3 D15 | **Do not redo** |
| Manager share of fighter-side leftovers | Proposed J4 E17 | **Do not redo** |
| Facility naming / wall signage as a distinct deal | none | **Absent** — correct until a cited deal. Do not invent |
| UFC Gym franchise | none | **Absent** — correct (scenery) |

## (d) Minimum change

**Do not add a gym naming-rights or apparel-deal dollar table. Keep `Sponsorship.settle_week` as the gym-as-entity cheque and label the magnitude `evidence: invented`. Do not retune `TIER_WEEKLY_CASH` in this pack. D15 and E17 stand as one-liners. Optional later, still small: a `facility_sponsor` flag that requires `evidence` before it credits cash — same J2 §6.3 rule as membership.**

## (e) Issues + solutions

**Issue 1 — “Sponsor the gym” looking like fighter patches.**  
**Solution:** Three objects (table above). `house_kit` still cannot attach a fighter patch on fight week (J3 Q10 / J4 E32). A gym wall banner is not a Venum short.

**Issue 2 — Inventing a naming-rights ladder so the gym survives R43.**  
**Solution:** Priority ruling. The live invented cheque already exists. A second invented cheque is not honesty.

**Issue 3 — Brand / Venum, Hayabusa, UFC Gym, PI.**  
**Solution:** J1 §4.1. Text in research. No kit art, no photographed gym interiors, no named athletes as data.

**Issue 4 — Promoter-owned gym (Top Rank Gym class) as the player.**  
**Solution:** E8 / G17. The 13 promotions already have the promoter chair. The player is the gym/manager. Do not merge.

---

# Priority ruling

**After R43, what does the gym live on, and how much of it can we ship without inventing a number?**

**Plain words.** After R43 the bout-agreement money stops in the athlete’s pocket (E1 / E23). The gym still pays payroll and upkeep every month (`_settle_billing`). What is left that is **real**:

1. **Membership / the training floor** — what gyms actually live on. **No sport-wide number exists.** Ship the **object** (a gym-authored fee with `evidence`) or **omit the line**. Do not invent $150/month or 10% of purse as dues.
2. **A collectible manager share** — real when G6’s three gates pass, **zero** when they don’t. Ship the **gates**, not a default %. E23 remains the default.
3. **Corner work** — the gym is **not** a published payee. Ship **nothing**.
4. **Gym as a sponsored entity** — real as a *kind*; dollars unpublished. The game **already** pays this chair with an **invented** `Sponsorship` weekly cheque. Keep it; label it; do not invent a second one.

**Is that less than payroll costs?** **Yes, for a roster gym, as the live objects sit today.** Payroll is `Σ weekly_salary` (invented polarity and magnitude) plus upkeep, billed monthly. The remaining **live** credit after R43 is `Sponsorship.settle_week` (default band **250–300** per active deal, invented) plus **$0** from purses. That does not cover a multi-athlete payroll. **The fix is the game’s economy** (payroll polarity/magnitudes, cadence, an evidenced dues line, honesty labels on the sponsor cheque) — **not a fabricated gym cut of the purse.** J4 refused that cut. This pack refuses it again.

**Order, next twelve months:**

| Rank | Area | Research or build? | Wait a year? | Scenery? |
|------|------|--------------------|--------------|----------|
| **1** | **Purse destination stands; do not back-fill with a gym cut** | **Build** R43 / J4 E18 as already assigned. This pack **does not reopen E1–E3**. Default gym delta from purse = **0** (E23) unless G6 gates pass | No | Invented `gym_cut` % = **scenery-as-lie**. Do not ship |
| **2** | **Membership / training-floor object** | **Build** the line-item (credit `gym["cash"]` only with `evidence`). **Do not** author a default dollar. **Research later:** per-gym posted pages as data, labelled as that gym | Research on a scraped “typical MMA dues” table must **not** happen — that table is the invention | NGB club fees as gym income = **scenery** (wrong object). UFC Gym franchise = **scenery** |
| **3** | **Manager-share collectibility gates** | **Build** only if rank 1 ever pays the gym a filed share (the triple: `contract_on_file`, `combatant_approved`, `manager_licensed` in event state). **Otherwise wait** — E23 already zeros it | Yes, except that triple | Licence-exam / agency career / second mode = **scenery** (J2 §6.2, J4 E9) |
| **4** | **Corner fees and gym naming-rights dollars** | **Wait.** Keep E4. Keep live `Sponsorship.settle_week` as the invented gym-entity cheque (G16). Do not add a cutman % or a facility-naming ladder | Yes | Promotion-provided cutman as gym income = **scenery**. PI / promoter-owned gym as the player = **scenery** |

### Defend

**1 beats 2.** TASK said this study is the honest revenue answer **after** R43, not a way to undo R43. Putting a `gym_cut` back on `:10253` would re-pay the wrong party under a new name. Membership is the real floor, but it is **UNKNOWN as a number**. Shipping the **object** without a default dollar is the honest build; it does not outrank finishing the payee fix.

**2 beats 3.** A gym without members and without a filed manager contract is how most real gyms **start**, and how this game’s desk **is**. Collectibility gates only matter once a share exists. E23 ships with R43: no contract → $0. The licence triple waits on that, exactly as J4 rank 3 waited on rank 1.

**3 beats 4.** Collectibility is **statutory** (file, initials, event-state licence). Corner pay and gym naming-rights dollars are **CUSTOMARY / UNKNOWN**. Inventing 3% cutman or a naming-rights ladder would be J3 D14 (PPV %) in a different coat. Live `Sponsorship.gd` already stands in for gym-entity sponsorship, invented, labelled.

**Why this outranks a fifth org-side system.** A fifth championship widget, a fourth J2 pathway, or an alphabet overlay would still settle into a gym that **pays payroll and no longer banks purses**. Until the gym’s **inflow** is honest — membership with evidence, manager share only when collectible, no fabricated cut — org-side work is decorating the wrong ledger. J4 said the same about `:10200`. R43 moves the line to `:10253` and does not fill the till.

**Why “less than payroll” is allowed to be the answer.** J2 §6.3 / J4 E2: inventing a number because the spreadsheet is red is the 2am decision. The red spreadsheet is information. Retune `weekly_salary` polarity, upkeep, cadence, or file a dues line with `evidence`. Do **not** tax the bout agreement to paper over it.

### What is scenery (as plainly as J2 §5.1)

- **Manager-simulator / agency career / second-as-playable-mode.** Real jobs. Not this game. J2 §6.2. **Show nothing. Build nothing.**
- **Invented gym-cut / dues / cutman percentages.** UNKNOWN. **Omit.**
- **UFC Gym franchise, Performance Institute, promoter-owned training gym as the player.** Real facilities. **Not this desk.**
- **NGB club fees as gym income.** Wrong object (G4).
- **PPV points, Ali Act overlay, Olympic IF careers, employee classification.** Already scenery (J3 D14, J4 E6/E14, J2 §5.1). Not reopened.
- **Filing-office RPG** (72-hour drop-off, notary, appear-together). Collapse to flags.

**No fifth area outranks these four.** The closest miss — “should the gym be a promoter of its own local cards?” — is a **new product** and walks into J4 E8’s firewall. Not MVP.

---

## Test assertions (contracts for a later PR — not written this pass)

Numbered **G19–G34** so they do not collide with operator calls G1–G18, J4 E1–E34, or J3 D1–D16 / Q1–Q13.

| ID | Assertion |
|----|-----------|
| **G19** | After R43, a bout settlement does **not** increase `gym["cash"]` by the contracted `show_purse + win_bonus + performance_bonus + gate_share`. (Same polarity as J4 E19; line is `:10253` in this excerpt.) |
| **G20** | If no manager contract is filed, the gym’s delta from that purse is **0** (J4 E23). |
| **G21** | A manager share credits `gym["cash"]` only if `contract_on_file`, `combatant_approved`, and `manager_licensed` for the **event state** are all true. |
| **G22** | Missing any G21 gate, the combatant still receives the bout-agreement money (J4 E1 / E20) and the gym’s purse delta remains **0**. |
| **G23** | No data file contains a default `manager_cut` / `gym_cut` / `purse_share` / `dues_pct` **percentage** without an `evidence` field. |
| **G24** | No data file contains a sport-wide `membership_usd_per_month` (or equivalent) without `evidence` pointing at **that gym’s** posted rate or an explicit `INVENTED` gameplay tag. |
| **G25** | `_settle_billing` still accrues payroll + upkeep and still debits `gym["cash"]` when the calendar month turns. |
| **G26** | `Sponsorship.settle_week` may still credit `gym["cash"]`. Any such credit is **not** labelled as a purse cut. |
| **G27** | No corner / cutman / seconds **percentage** of purse is authored as gym income without `evidence`. |
| **G28** | No gym naming-rights / facility-apparel **dollar** is authored without `evidence`. |
| **G29** | A gym taking ≥ 10% (NV/NJ) or > 10% (CA) of gross purse is treated as a **manager** (J4 E24), not as a second “gym cut,” and G21 gates apply. |
| **G30** | An out-of-state management contract, even if marked recognizable (NY `209.2(b)(2)` / CA `BPC 18855` / NV `467.102(3)` / NJ `13:46-5.8(b)`), does **not** by itself set `manager_licensed` for a different event state. |
| **G31** | USA Boxing club / athlete / fitness fees, IBJJF entry, IJF/UWW/WT licences are **not** written to `gym["cash"]` as membership. |
| **G32** | `Sponsorship` `outfitting_policy=house_kit` still cannot attach a fighter patch on fight week (J3 Q10 / J4 E32). G14 gym-entity deals do not punch a hole in that ban. |
| **G33** | J2 P1–P3 still hold (federations: no purse, no signing). R40 is not reopened. J3 Areas 1–3 and J4 E1–E3 are not reopened by any G-test. |
| **G34** | No test fixture uses a real gym’s, manager’s, official’s, athlete’s, or executive’s name as data. |

---

## Source list (live verification 2026-09-06)

**Primary / official (preferred):**

- `J2_THE_FEDERATION_PATHWAY.md` (§2.6 money-flow, D5, D6 / R40, §5.1 scenery, §6.2 unplayed-mode, §6.3 no invented numeric default)
- `J3_THE_DECISION_QUEUE.md` (D1–D16, Areas 1–3, D13/D14/D15 — **cited, not reopened**)
- `J4_THE_DESK_AND_THE_CUT.md` (E1–E18, E23, file-level anchors, E9, E4, E17 — **cited; E1–E3 not re-derived**)
- `GameState_billing.excerpt.txt` (`:10253` settlement R43 is changing; `:10257` `career_earnings`; `_settle_billing` `:4658`; week advance `:5108`–`:5116`)
- `Sponsorship.gd.excerpt.txt` (`:224` entity branch; `weekly_cash` offer construction; `TIER_WEEKLY_CASH` default 250)
- Nevada NAC 467 chapter (rev. listed 2026-04-13): https://www.leg.state.nv.us/nac/NAC-467.html
- NAC 467.102 (file 72 hours; honor limits; 4-year; 33⅓% cap; self-signing): https://www.law.cornell.edu/regulations/nevada/NAC-467-102
- NAC 467.137 (pay combatant in full; manager share only with combatant approval and 467.102-compliant contract; dispute withhold; assignment): https://www.law.cornell.edu/regulations/nevada/NAC-467-137
- NAC 467.012 / 467.057 / 467.104 / 467.112 / 467.142 (already J4; licence table, manager-as-second, promoter-as-manager ban, bout form, expense withhold)
- NAC 467.635 (max three seconds; four if authorized for world title or special event): https://nvrules.elaws.us/nac/467.635
- NRS 467.100 (licence required to participate, including managers): https://www.leg.state.nv.us/Nrs/NRS-467.html
- NRS 467.01037 (manager defined, including 10% of gross purse): https://www.leg.state.nv.us/Nrs/NRS-467.html
- NSAC Official Bout Agreement (O-460) §7 manager-share conditions: https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/Renewal/O-460_BOUT_AGREEMENT.pdf
- NSAC boxer/manager contract notes (both licensed current year; in-office signing; max 4 years; max 33⅓%): https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/faq/Boxer-Mgr_contract_web.pdf
- California `4 CCR 208` (gymnasium licence fee **$10**; expires 31 Dec; cites BPC 18685): https://govt.westlaw.com/calregs/Document/I8EDDFFC3543B11ECAE2D000D3A7C4BC3 (Register 2026, No. 30, through 2026-07-24)
- California `4 CCR 216` (out-of-state boxer/manager must apply; boxer issued licence before signing): https://www.law.cornell.edu/regulations/california/4-CCR-216
- California `4 CCR 220` (form of contract; other-jurisdiction recognition)
- California `4 CCR 221` (file at approval; licence-loss voiding; 33⅓%; self-sign full purse): https://www.law.cornell.edu/regulations/california/4-CCR-221
- California `4 CCR 222` (both parties appear; written approval; max 5 years; no option): https://www.law.cornell.edu/regulations/california/4-CCR-222
- California `4 CCR 495` (post gymnasium licence)
- BPC 18628 (manager definition, **> 10%** of gross purse): https://california.public.law/codes/business_and_professions_code_section_18628
- BPC 18653 (pro trainer licence; trainer in the corner): https://california.public.law/codes/business_and_professions_code_section_18653
- BPC 18685 (live text: **bond equivalent**, not a gymnasium definition): https://california.public.law/codes/business_and_professions_code_section_18685
- BPC 18817 (gymnasium application/renewal shall not exceed **$200**)
- BPC 18851 (manager annual record: training expenses, paid to contestant, received from purse, owed): https://california.public.law/codes/business_and_professions_code_section_18851
- BPC 18855 (recognize/enforce boxer **or martial arts fighter**–manager contracts; other-jurisdiction forms; no other contract): https://california.public.law/codes/business_and_professions_code_section_18855
- CSAC manager application (fee $150; `4 CCR 216` reprinted on the form): https://www.dca.ca.gov/csac/forms_pubs/forms/manager_app.pdf
- N.J.A.C. 13:46-5.5 (boxer-manager contract forms; all agreements filed): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-5-5
- N.J.A.C. 13:46-5.8 (both parties licensed or contract not effective; may recognize other-jurisdiction contracts that comply): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-5-8
- N.J.A.C. 13:46-6.3 (loss of manager licence / contract recognition): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-6-3
- N.J.A.C. 13:46-6.4 (≤ 33⅓%; hold ⅓ if boxer fights without permission): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-6-4
- N.J.A.C. 13:46-6.6 (suspended manager: no corner, no negotiating): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-6-6
- N.J.A.C. 13:46-6.10 (no unlicensed manager shall deal with promoter or matchmaker): https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-6-10
- 19 NYCRR 206.5 (licences required, including manager; purse defined): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-206.5
- 19 NYCRR 207.8 / 207.9 (manager licensing standards; manager as second of own combatant)
- 19 NYCRR 209.2 (bout and management contract form; ABC-member recognition): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-209.2
- 19 NYCRR 209.3 (licensees must perform contracts)
- 19 NYCRR 209.4 (management contracts ≤ 3 years unless authorized; 11th-month cancel): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-209.4
- 19 NYCRR 209.11 (minimum $150 after approved deductions)
- 19 NYCRR 209.12 (combatant receives ≥ 50% after authorized deductions)
- 19 NYCRR 209.13 (cheque to the participating combatant; no third-party payment unless Commission approved): https://www.law.cornell.edu/regulations/new-york/19-NYCRR-209.13
- NYSAC Official Bout Contract for Professional MMA (DOS 2072-F) (purse minus authorized deductions to combatant; optional third-party distributions): https://dos.ny.gov/system/files/documents/2021/04/2072-f-official-bout-contract-for-professional-mixed-martial-arts-mma.pdf
- NYSAC licence fee schedule: https://dos.ny.gov/license-fee-and-term-schedule-new-york-state-athletic-commission
- ABC model boxer/manager and bout contracts (blank manager %; licensure clause): https://www.abcboxing.com/boxer-and-bout-sample-contracts/
- USA Boxing 2026 member rate card (club **$205**; athlete age bands; announced 2025-11-07): https://www.usaboxing.org/news/2025/november/07/2026-usa-boxing-member-rate-adjustment-announcement
- USA Boxing fitness membership (youth $25 / adult $35; $5 to the registered gym): https://www.usaboxing.org/fitness-membership
- IMMAF athlete eligibility (already J2): https://immaf.org/athletes/athlete-eligibility/

**Secondary (labelled in body):**

- Individual combat-gym membership pages retrieved 2026-09-06 (US MMA unlimited, US boxing unlimited/class-pack, UK session, Japan yen monthly) — **primary for those gyms, not for the sport**; **do not ingest names or prices as catalog data**
- 2026 secondary aggregators of named US MMA gyms’ posted unlimited-membership rates (low-to-mid hundreds USD/month cluster) — **journalism, do not wire as a default**
- 2025 coach-interview video on whether professionals pay gym fees vs a purse percentage — **CUSTOMARY, one house policy, do not wire; do not use names as data**
- 2025 secondary interview with a named high-level MMA head coach on waiving gym fees for high-level fighters — **CUSTOMARY, one house policy, do not wire; do not use names as data**
- Wikipedia *Cutman* (verified 2026-09-06): compensation “generally 2–3% of the fighter’s prize money”; MMA cutmen “generally provided by the promotion” — **not a fee schedule**; named cutmen **not data**
- *The Athletic* 2019-07-03 (UFC cutmen work for the promotion, per event, IC; declined to disclose the dollar) — **SECONDARY practice, not a 2026 UFC primary**
- 2026 boxing-finance explainers (manager ~33%, trainer ~10%, corner/cutman ~2–4%) — **CUSTOMARY planning copy, do not wire**
- Grounded MMA “How Much Do UFC Cutman Make” (2022) — **SECONDARY, arithmetic not a primary**
- Fightomic 2025-12-15 (corners usually paid by the fighter; split varies; small shows often unpaid) — **CUSTOMARY**
- PR Newswire 2023-11-13 (Top Rank / Venum: apparel line + corporate sponsor of Top Rank Gym; dollars unpublished) — promoter-owned boxing gym, **not catalog**
- SBJ Sports Facility Naming Rights Directory (page 2026-09-06) — stadiums/arenas/practice facilities; **not** independent MMA-gym deals
- SBJ 2025-02-19 (QuikTrip octagon-mat via Monster pass-through) — **promotion** inventory
- ESPN Crypto.com UFC kit-rights (2021) — **promotion** inventory
- CSAC arbitration PDFs (filed manager % examples below the cap) — **case-specific, not a default**; **do not use named parties as data** (already J4)
- Bangkok Post 2026-07-23 (gym cut of a ONE purse) — **reported private arrangement** (already J4)
- Senate CA Athletic Commission background paper 2024 (manager exam waivable if licensed in another state without discipline) — already J4 E7

**Not retrieved / do not fake:**

- A sport-wide **gym dues** percentage or monthly dollar (ABC, NSAC, CSAC, NJSACB, NYSAC, or any of the 13)
- A published “professionals pay N, amateurs pay M” rule
- Live BPC **gymnasium-operator definition** replacing the stale `4 CCR 208` → `18685` cross-reference (`18685` is now bonds)
- Current CA gymnasium licence **exact** dollar (`BPC 18817` ceiling $200 vs `4 CCR 208` $10) — already J4
- MMA-specific **4 CCR** restatement of the 33⅓% cap (already J4)
- MMA-specific **N.J.A.C.** manager % (already J4)
- A 2026 UFC / PFL / ONE / GLORY / RIZIN **primary** that pays a **gym** for supplying corners
- A published cutman or cornerman **wage table** (UFC per-event dollar; the Athletic’s sources declined to disclose)
- Independent-combat-gym **naming-rights** dollar tables
- Venum / Hayabusa / other apparel **gym-partnership** cheque amounts as primaries
- Host-nation manager-licence rules for ONE (Singapore), RIZIN (Japan), RWS (Thailand), GLORY (Netherlands) — default **off**
- Ali Revival / UBO **enacted** text as of 2026-09-06 (already J4)
- UFC PPV point % (already J3: do not fake)
- Venum / UFC outfitting **primary PDF** (already J3: do not fake)
- A 2026 UFC promotional-agreement **primary PDF** (already J4)

---

*End of J5. Cut from the Decisions page and from the priority ruling. After R43 the gym does not live on the purse. It lives on the floor, on a collectible manager share when the gates pass, and on whatever invented sponsor cheque the game already pays. If that is less than payroll, the fix is the economy, not a fabricated cut. R40 remains J2 D6. J3 Areas 1–3 and J4 E1–E3 are not reopened. No manager-simulator.*
