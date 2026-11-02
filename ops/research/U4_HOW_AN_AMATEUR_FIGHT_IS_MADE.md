# U4 — How an amateur fight is actually made

**Desk:** Cursor  
**Date:** 2026-09-07  
**Status:** research and rulings only. No `Godot/scripts/` writes. No `HANDOFF.md`. No screen.  
**Consumers:** C39 (plumbing), R56 (surface). Cite D-numbers. Do not reopen R40, J2 D3/D5, R48, R49, R55, U1/U2/U3.

---

## Code, checked (not assumed)

| Claim in TASK_U4 | What the file actually does | Verdict |
|---|---|---|
| `FIGHT_TIERS` at `GameState.gd:155` | Three paid tiers (`local` $600 / `regional` $1400 / `featured` $3200) plus win bonus and reputation | Holds |
| `get_fight_offers()` at `:5300` invents opponents | Loop at `:5316-5334` seeds `"fight_offer\|<gym>\|<tier>\|<class>\|<week>"` and invents name, rating, `{wins,losses,draws}`. Purse from the tier table. Gate is `fame_required` only | Holds. **Addendum:** `:5335-5340` then appends rivalry, clause and superfight offers — those are real extra kinds, not ghosts. The ghost is the `FIGHT_TIERS` loop |
| `_promotion_opponent_pool()` at `:5718` is real people, signed-only | Same-discipline, same-sex, not retired, same class, never the roster, sorted by rating gap. Reached from `get_promotion_bouts()` which returns `[]` unless `is_athlete_signed` | Holds |
| `EntityPathway.gd` 203 lines | 205 lines this checkout. `is_amateur:117`, `entry_fee_cents:131`, `prize_cents:145`, `ends_amateur_eligibility:195` | Holds. Line count drifted by two |
| `ends_amateur_eligibility` has zero production callers | Grep: definition, five asserts at `tests/entity_pathways_test.gd:116-120`, research files. No `GameState.gd` call | Holds |
| `turned_pro` written only in `accept_signing_offer` `:5484` | Sole successful write. `:5488-5490` erase is save-failure rollback, not a second writer. **Read** at `book_fight` `:9904` already refuses an `is_amateur` org once the flag is true | Holds, with the read named |
| `GAME_DESIGN.md:72` | `"Amateur and professional records by ruleset."` | Holds |
| One unlabelled `record` | Settlement `:11129-11137` increments `athlete["record"]` only. Ranking seed `:1565` and `:11146` read that same dict | Holds |
| `_body_hold_read` `:7642` | Reads `body_state.medical_hold_until_week`. One clock | Holds |

`cyprus_mmaf` in `real_organizations.json:93-102` has **no** `entry_fee_cents` and **no** `prize_table`. `EntityPathway.entry_fee_cents` therefore returns `FEE_UNKNOWN` (`-1`). J2 already marked CMMAF domestic fees UNKNOWN.

`EntityPathway.is_amateur` is **not** “any unpaid contest”. It is `national_selection` minus the three Olympic IFs. Today that is CMMAF. IBJJF is `open_entry` and `is_amateur` is false — that is R40, held.

---

## Q1 — the channels

Not “how would a game do it”. How a bout actually reaches a fighter.

| Channel | What it is | Source | Desk? |
|---|---|---|---|
| Coach ↔ matchmaker / club | The coach (not a promoter offering a purse) puts names forward. USA Boxing: matched bouts are made **with both coaches’ discretion**, final approval by the official in charge; clubs talk to other clubs months out | USA Boxing Rule Book Rev. 1.1.2024 §9.1.6; USA Boxing *Guide to hosting a successful sanction* (“Talk with coaches from other Clubs”) | **Yes — incoming CONFIRM** |
| Gym-to-gym (“my 145er for your 145er”) | The default amateur boxing make. Weights, ages and experience compared; passbooks checked at the show | The Glowing Edge, *How Amateur Boxing Matches are REALLY Made*; USA Boxing COO Manual “Making Local Matched Bouts” | **Yes — incoming or outgoing CONFIRM** |
| Open registration card | Fighter/gym enters a published event and is paired at weigh-in. USA Boxing now lists sanctioned events online | The Glowing Edge; USA Boxing events listing described there | **Yes — ENTER** |
| Interclub / smoker | In-house or loosely run. Often no official record, sometimes no ambulance, sold like a real show | Zebra Athletics, *Selling Tickets & Fighting on the Local Circuit* (smoker vs sanctioned contrast) | **No. Noise. Never a bout** |
| Ticket quota (“sell 20 and you’re on”) | Real local-circuit practice. Promoters make the card out of people who can fill seats. No sourced statute that *requires* a fighter to sell N tickets; N is house policy | Zebra Athletics; Nextreme MMA fighter registration (commission-on-tickets, not a purse); BKFC 85 public row is **pro** ticket-pay, cited only as the same practice leaking upward | **Condition flag only.** Never a fake N |
| Short-notice (opponent fell out) | The most common way a bout appears this week. Incoming ask to the coach | Practice, widely reported; no single governing PDF. Treat as a channel, not a number | **Yes — incoming CONFIRM**, flagged short-notice |
| Tournament (pay, maybe three times in a day) | IMMAF championships: the **national federation** enters the athlete (J2 D3). IBJJF: the athlete pays and enters (R40 `open_entry`). USA Boxing opens/championships: club enters, pairing by draw | IMMAF eligibility page; J2 D3; USA Boxing nationals on BoxRec amateur cards | **Yes — ENTER.** IMMAF/CMMAF is NF-shaped; IBJJF is not this circuit |

**What the player’s DESK sees:** the five yes-rows. **What happens to them with no verb:** nothing we model. A smoker the gym ran in the back room is training-floor, not a fight.

---

## Q2 — who is the agent of the booking

In the pro game the promotion offers and the manager accepts. In the amateur game the person doing the work is the **coach**, and the fighter’s willingness to take a bad match is a constraint, not the verb.

This game’s player **is the gym** (R46’s desk). That maps onto the coach, not onto the fighter and not onto a promoter paying a purse.

| Options | Why not |
|---|---|
| Player hunts like a free-agent reading a paid board | That is `get_fight_offers()` + `FIGHT_TIERS`. It is the lie this pass exists to stop |
| Player is told after the fact | Not a management game |
| Player **CONFIRMs** incoming matches and **ENTERs** published cards | Matches the USA Boxing coach-discretion rule and the IMMAF NF-entry rule |

The amateur board is **not** an offer list in the promotion sense. C39 may still emit a list of real people (plumbing). R56’s buttons are CONFIRM and ENTER, never ACCEPT, never a purse.

The fighter can still refuse through gates that already exist (`book_fight` strike at `:9889`, sanctioning, hold). Do not add a second “willingness” system.

---

## Q3 — the record

**What it is in the world.** Amateur boxing’s official artefact is the **passbook**, updated at the show. BoxRec’s amateur database exists and BoxRec itself calls it **incomplete** (FAQ: send dates, opponents, rounds to amateur@boxrec.com; passbook scans are often unreadable). Amateur MMA is logged separately on Tapology as “Amateur MMA Record”, not mixed into the pro line. IMMAF screens records through databases, footage and social media, and treats a **published professional combat-sports record anywhere** as disqualifying.

**What “3-1 amateur” means next to “3-1 pro”.** Different currency. Promoters and IMMAF both keep them apart. An amateur loss is expected; a pro loss moves ranking and market.

**GAME_DESIGN.md:72** already promised both, “by ruleset”. The engine has one unlabelled `record`. By-ruleset (boxing amateur vs MMA amateur) is a later split — we do not have a sourced layout for mixed-discipline amateur columns, and R53’s FIGHT RECORD tab is not reopened here.

**Held:** R49 — `decision_type` still writes on the bout, amateur or pro. R53 — print the second record on the surfaces that already print the first; do not redesign the tab.

---

## Q4 — what gates a bout

Real gates:

| Gate | Source | Ship? |
|---|---|---|
| Same sex, same weight class | Already law. USA Boxing §9.1; user rule 2026-09-01 / 2026-09-03 | **Yes — already live in `book_fight`** |
| Medical hold after stoppage | ABC Regulatory Guidelines: TKO (head) **30 days** min, KO **60 days** min, physician may extend; 7-day rest after any bout. Oregon amateur MMA: amateurs **must not compete while on the ABC registry**. Texas Combative Sports (amateur MMA in scope): TKO 30 / KO 60 | **Yes — the existing hold.** Same object |
| Amateur eligibility (`turned_pro`) | IMMAF eligibility page; already refused at `:9904` once the flag is set | **Yes** |
| Registration / licence with a sanctioning body | USA Boxing membership; IMMAF via NF. Catalog has no authored amateur licence fee for CMMAF | **UNKNOWN. Never gates. Never invent a fee** |
| Annual physical / blood work | Real at sanctioned shows. No sourced cadence that is true for both USA Boxing club shows and IMMAF Worlds | **UNKNOWN. Refuse the errand** |
| Passbook / record book as an item | Real in amateur boxing. Not an IMMAF artefact in the same form | **Refuse as inventory.** The record *is* `amateur_record` |

A gate you cannot source is UNKNOWN and UNKNOWN never gates anything (J2 6.3, held).

**Amateur suspension vs pro suspension.** Commissions that regulate amateur MMA write the same KO/TKO days onto the same ABC registry the pros use (Oregon). The engine already has one clock: `body_state.medical_hold_until_week` via `_body_hold_read` (`:7642`). R48’s HELD badge and R55’s six regions sit on that object. A second amateur clock would split a fact the commissions do not split.

ABC’s 30/60 *day* figures are not converted into weeks here. The existing hold already fires from fight damage. Do not author a parallel amateur table this pass.

---

## Q5 — the money, and the honest empties

Amateurs are not paid a **contracted purse**. IMMAF is explicit: a contracted purse is professional. Amateurs **may** receive prize money, sponsorships, and **up to USD 1,000** (or equivalent) in paid expenses from a promoter ([IMMAF Athlete Eligibility](https://immaf.org/athletes/athlete-eligibility/)). Traditional tournament BJJ prize money is amateur; a **contracted** BJJ purse is professional (same page; J2 D5, held).

What moves instead:

| Kind | Rule | Honest empty |
|---|---|---|
| Purse / win bonus | Always 0 on an `is_amateur` card (J2 D2, P5) | Do not print $0 as if it were a found fee — print no purse |
| Entry fee | `EntityPathway.entry_fee_cents`. CMMAF has none authored → `FEE_UNKNOWN`. Debit nothing, flag it (P7) | Never invent a number; never dress UNKNOWN as free |
| Prize | `prize_cents` only where `prize_table` names the division (P8). CMMAF table empty | 0 is “no authored table”, not “we looked up CMMAF and they pay nothing” |
| Travel / corner | R46 desk: gym `corner_fees` is already `SOURCE_ABSENT`. Fighter-side logistics is “the fighter’s own uncovered travel” (J6 A1) and is not a gym cut | Stay ABSENT until a cited packet authors a number |
| Ticket quota | Authored flag or absent. Count UNKNOWN unless authored | UNKNOWN never blocks the bout |
| IMMAF ≤$1000 expenses | Allowed in the real rule. No authored packet for CMMAF domestic | UNKNOWN. Never print as a purse |
| FIGHT_TIERS reputation | That table is a professional local-show model | Amateur bouts do not carry it |

---

## Q6 — the door

**P15 wins.** The helper already states the rule at `EntityPathway.gd:188-203`. Production never calls it. `accept_signing_offer` sets `turned_pro` as if signing were the only door. That is the contradiction.

IMMAF (any one closes amateur MMA):

1. A professional MMA match (Unified Rules or equivalent).
2. A contracted purse (prize money and ≤$1000 expenses do **not**).
3. From 2025: any MMA bout that allowed elbows and/or knees to the head.
4. A published professional combat-sports record.
5. (2021 PDF, still on national-federation pages) a pro licence, a pro promotional contract, a pro-level bout even unpaid, or competing against an opponent who already had a pro MMA record.

The engine already encodes (1) as `pathway == SIGNING`, (2) as `purse_cents > 0`, (3) as authored `elbows_to_head` / `knees_to_head`. (4) follows once the pro record increments. (5)’s extra licence-without-a-bout is UNKNOWN as a game object and must not invent a licence item; a promotional contract is already (1).

IBJJF tournament prize does **not** fire the door (J2 D5, IMMAF FAQ). `is_amateur` is already false for IBJJF.

**Warning:** the player is told **before** the irreversible step, not after settlement. R56 draws the copy. C39 ships `_turn_pro` and stores cause + week. Signing (`"promotion_contract"`) and a bout that actually paid (`"paid_bout"`) are the two production callers C39 already named; a ruleset that authors elbows/knees is the third cause the helper already knows — store it, do not drop it.

**At the moment the door shuts:** `turned_pro` sticks (R40 / J2 D5). Amateur record **freezes** (no further increments) and **remains displayed**. The hold clock is the same object, so it continues. Amateur orgs refuse at `:9904`.

---

## D-list

Voice of J2 D5: one sentence another agent can obey without the prose. If it cannot be written as “the game does X, never Y”, it is not here.

| # | Ruling |
|---|---|
| **D1** | The amateur circuit is `EntityPathway.is_amateur` only (today: CMMAF). The game never calls IBJJF or any `open_entry` org amateur. R40 pathways stay. |
| **D2** | While `turned_pro` is falsy, the fighter never sees a `FIGHT_TIERS` ghost. `get_fight_offers()` stays the free-agent professional board (rivalries/clauses/superfights included) and is not rewritten this cycle. |
| **D3** | An amateur opponent is a world athlete. The pool mirrors `_promotion_opponent_pool` (`:5718`) plus “candidate has not turned pro”. The game never invents a name, rating or record for an amateur bout. |
| **D4** | The amateur desk verbs are **CONFIRM** (incoming matchmaker / gym-to-gym / short-notice) and **ENTER** (open card / tournament). The game never labels an amateur row ACCEPT and never puts a purse on it. |
| **D5** | The player is the gym. An amateur bout does not land without a desk verb. The fighter may refuse only through gates `book_fight` already has (strike, hold, sanctioning, same-sex, class). |
| **D6** | Interclub / smoker is never a bout, never writes `amateur_record`, and never appears on the desk. |
| **D7** | A ticket quota is an authored flag or it is absent. The game never invents a ticket count. An UNKNOWN quota never blocks. |
| **D8** | Two records, forever: `athlete["amateur_record"]` and `athlete["record"]` (pro). Turning pro does not delete the amateur line. R53’s FIGHT RECORD tab is not redesigned; it gains the second line. By-ruleset columns are later, never this pass. |
| **D9** | An amateur result never seeds or moves `ranking_points` (`:1565`, `:11146-11151`). An amateur loss is not a pro loss. R49 `decision_type` still writes on the bout. |
| **D10** | Amateur medical suspension is `body_state.medical_hold_until_week`, read through `_body_hold_read`. The game never adds a second clock. R48’s badge and R55’s six regions stay on that object. |
| **D11** | Gates that ship: same-sex, weight class, the hold, `turned_pro` vs `is_amateur`, an authored entry-fee debit. Gates that do not: passbook inventory, physical/blood-work errand, invented licence fee. UNKNOWN never gates (J2 6.3). |
| **D12** | On an amateur card, `purse` is 0 and `win_bonus` is 0. `entry_fee_cents` / `FEE_UNKNOWN` ride unchanged. `prize_cents` pays only from an authored `prize_table`. Gym `corner_fees` and travel stay ABSENT until authored. IMMAF ≤USD 1000 expenses are never printed as a purse. FIGHT_TIERS reputation never rides an amateur bout. |
| **D13** | **P15 wins.** `turned_pro` becomes true when `EntityPathway.ends_amateur_eligibility(org, purse_cents, ruleset)` is true: SIGNING, `purse_cents > 0`, or authored `elbows_to_head` / `knees_to_head`. `accept_signing_offer` is sufficient, not necessary. IBJJF tournament prize is not a purse. The flag is sticky. |
| **D14** | The player is warned **before** the door shuts. Cause and week are stored. The amateur record freezes and remains displayed. The hold clock continues. |

C39 ships D1–D3, D8–D10, D12–D13 (state, pool, settlement, door). R56 draws D4–D8, D11–D12, D14 (verbs, warning, honest empties, the second record line). G14 ranks D3’s pool; this pass does not sort it.

---

## Refusals (stops re-proposal)

1. **Amateur FIGHT_TIERS.** Paid ghosts in week one.
2. **Second career mode.** J2 D4 / R40, held.
3. **IBJJF as amateur MMA.** Different pathway, different door.
4. **Smokers as fights.** No official record.
5. **Invented ticket N, entry fee, licence fee, travel, corner, CMMAF prize, expense cap as purse.**
6. **A second medical clock labelled amateur.**
7. **Passbook / blood-work / annual physical as playable errands.**
8. **Deleting `amateur_record` at the door.**
9. **Feeding ranking_points from amateur W-L.**
10. **Reopening R48 / R49 / R53 / R55 / U2 / U3 to win an argument on this pack.**
11. **Designing the screen.** R56 draws it.
12. **Silent door.** Warning is before, not after.

---

## Sources

- IMMAF Athlete Eligibility, https://immaf.org/athletes/athlete-eligibility/ (purse, prize vs purse, ≤USD 1000 expenses, 2025 elbows/knees, published pro record, BJJ prize vs contracted BJJ, A-class Muay Thai)
- IMMAF 2021 Eligibility PDF (licence, unpaid pro-level bout, opponent-already-pro) https://immaf.org/wp-content/uploads/2021/03/2021-Amateur-MMA-Eligibility-to-Compete.pdf
- USA Boxing Rule Book Rev. 1.1.2024 §9.1 (matched bouts, both coaches’ discretion, official in charge)
- USA Boxing, *Guide to hosting a successful sanction* (club-to-club)
- USA Boxing COO Manual Feb 2020 (local matched bouts)
- The Glowing Edge, *How Amateur Boxing Matches are REALLY Made* (passbooks, pairing at the show, event listing)
- BoxRec FAQ (amateur database incomplete)
- ABC Regulatory Guidelines (TKO 30 / KO 60 / 7-day rest)
- Oregon OAR amateur unarmed combat (ABC registry binds amateurs)
- TDLR Combative Sports at a Glance (amateur MMA in Texas scope; TKO 30 / KO 60)
- Zebra Athletics, *Selling Tickets & Fighting on the Local Circuit* (ticket selling; smoker vs sanctioned)
- J2 D3/D5/6.3, R40, P5–P8/P15, `EntityPathway.gd`, `GAME_DESIGN.md:72`

**UNKNOWN, and what would settle it:** CMMAF domestic entry fee (a cited CMMAF/IMMAF national-championship fee schedule); CMMAF prize table (same); amateur licence fee for this gym’s jurisdiction; a ticket count (a cited house policy for a catalogued amateur card); whether USA Boxing 7-day rest and ABC 30/60 map onto the engine’s existing hold lengths (a later medical pass — not this one).
