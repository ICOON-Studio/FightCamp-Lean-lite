# J7 — The Scale and the Belt: What Is Actually Published

**Desk:** John (research)  
**Date:** 2026-09-07  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design. No second career mode (J2 §6.2). No second weigh-in mechanic. No federation's name on any number the game already ships.  
**Local snapshot used:** `TASK_J7.md`; `TASK_R42.md`; `R42_DIGEST.md` (shipped 2026-09-07); `championship_rules.json` (R41 notes; **no R42 knob**); `WeightCut_allowance.excerpt.txt` (`allowance_for` `:69`); `WeightCut_miss.excerpt.txt` (`weigh_in` `:164`–`:218`, `allowance_for` at `:187`, `miss` block at `:189`); `weight_classes.json` v2 (`allowance_kg`, `miss.fine_fraction` **0.2**, `catchweight_max_fraction` **0.03**); `J3_THE_DECISION_QUEUE.md`; `J5_THE_GYMS_OWN_LEDGER.md`; `J6_THE_ATHLETES_OWN_LEDGER.md`. Line numbers for `WeightCut.gd` are from this workspace excerpt.

**Cite, do not re-litigate:** J1 (UNKNOWN policy, §4.1 brand — a GAME RULE may be authored without a federation's name). J2 (three **entry/money** pathways, §5.1 scenery, §6.2 unplayed-mode, §6.3 no invented numeric default). J3 (D1–D16; **D10–D12 weigh-in cited, not reopened**; Areas 1–3; Q9 belt-on-a-miss). J4 (E1–E3). J5 (**priority ruling**, rank-2 membership). J6 (**A16**: this desk's last pack did not outrank J5 rank-2). R40 / J2 D6. **R42's shipped rule is not reopened.**

**UNKNOWN policy (same as J1–J6):** a fee, a period, a percentage, a hearing procedure, a rehydration ladder, or a formula that is not in a primary statute, regulation, commission form, or an organization's own published page is **UNKNOWN**. Never invent one. Inherited practice is **INHERITED** / **CUSTOMARY**, not a published rule. National overlays are **NATIONAL**. No real gym's, manager's, official's, athlete's, or executive's name as data.

**The trap (read this before the table).** R42 is **already shipped and correct as a GAME RULE** (J1 §4.1). This pack is not a review of it and must not recommend rewriting it because a citation is missing. What this pack is for: knowing which parts are backed, which parts are a body's own published condition the game may one day want to **name**, and which parts are the game's own honest invention. **"Nothing is published, ship nothing" is an acceptable answer here, exactly as it was in J5 and J6.**

**No fifth area.** After the four, a second-day weigh-in career, a hydration-testing RPG, or a commission-hearing sim is **scenery**, not a fifth research track. A second weigh-in is a new mode, not a fifth area (TASK).

---

## Why this exists

R42 shipped one rule the game now enforces: **a contestant who misses the contracted limit cannot win or retain the belt; the one who made weight still can.** A champion who misses and wins keeps the fight; the division goes `vacant`. When both miss, the belt does not move at all.

That rule was written the way R41's `interim_hold_weeks` was written — as a **GAME RULE with no federation's name on it**. It was shipped because it is the honest direction, not because a citation was in hand. J3 **D11** had already named the player-visible lie (belt fate) and pointed at GLORY / IBF / ONE as the *shape*. Nobody had then checked what is actually published, commission by commission and body by body, or what published text **argues otherwise** — especially on the both-miss case R42 called the smaller rule.

This pack does that check. It does not reopen R42.

---

## Decisions page (operator calls)

This page is what the next research/build cuts from. One recommendation, one line why. Numbered **P1–P16** so nothing collides with J3 D1–D16, J4 E1–E34, J5 G1–G34, or J6 A1–A18.

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| **P1** | Championship vs ordinary **allowance** — whose object? | **ABC Unified MMA does not publish a title/non-title 1 lb split.** The 1 lb non-title cushion is an ABC MMA *committee custom* (“only if provided for in the written bout contract or by regulation”), plus some **commission** regs and **body** conditions. Zero-allowance on a title is a **body's published condition** and some state regs, not Unified MMA. | Aug 2026 Unified MMA: “no allowance restrictions if both combatants weigh-in within the same contracted division.” Committee report: unwritten custom. |
| **P2** | Where does `WeightCut.gd:69` `allowance_for` sit? | **Family-wide, not title-keyed.** Live: boxing **0.0** kg, mma **0.45** kg (~1 lb), kg **0.0**. Applied at `:187` on every weigh-in, including a title bout. Do **not** add a championship knob. | MMA 0.45 on a title bout is the *ordinary* custom applied to championships. Boxing 0.0 on a non-title bout is the *championship* shape applied to ordinary. Label it; do not “fix” it into a title table. |
| **P3** | Author a title-keyed allowance? | **Do not.** No ABC Unified MMA number exists to store. J2 §6.3. | Inventing “title = 0, non-title = 1 lb” as a global would put a federation-shaped split on a GAME file. |
| **P4** | Is *“missed weight cannot win the title”* a **statute**? | **Not ABC Unified MMA, not `NAC 467.522`.** Nevada's published miss rule is a **purse forfeit**, not a belt. One retrieved **commission** (Oregon `OAR 230-030-0150(2)(h)(C)`) does publish ineligibility. Several **bodies** publish it as their own championship condition (GLORY, IBF, WBO, WBC championship-fight text, PFL 2025 Finals). UFC: **CUSTOMARY** journalism; **UNKNOWN as a single UFC bylaw**. | If statute, body, and journalism disagree, mark UNKNOWN rather than picking a favourite. They disagree on *who owns the sentence*, not on the usual direction. |
| **P5** | UFC house law? | **UNKNOWN as a published UFC rule.** Consistently reported practice: challenger miss → cannot win the belt; champion miss → stripped / vacant if they still fight and win. No UFC PDF retrieved this pass that writes it. | J3 D11 already. Do not ship “UFC Rule X.” R42 does not name UFC. |
| **P6** | Champion misses, wins the fight → **vacant** | **Backed as a body's published condition** (GLORY 2026 §5.04.C.2; IBF Rule 1.A.1; WBO §4(c)(1); WBC 2016 championship-fight synthesis (a); ABC boxing *ratings criteria* second-day). R42 already ships this shape. **Do not rewrite R42.** Do not invent a hearing. | Vacate-on-the-scale is the published move. No retrieved statute runs a commission hearing to get there. |
| **P7** | Challenger misses, champion makes it | **Champion keeps the belt win or lose** — GLORY §5.04.C.3; IBF Rule 1.A.2; WBO §4(c)(2) (and if the champion *loses* that overweight fight, WBO **vacates** — see Area 3). R42: belt does not move. **Do not rewrite R42.** | R42's challenger-miss case matches GLORY/IBF. WBO's extra vacate-if-champ-loses is a body overlay the game may one day **name**, not a reason to reopen the GAME RULE. |
| **P8** | Both miss | **R42's smaller rule (belt does not move) stands as the GAME RULE.** Published text that **argues otherwise** exists: GLORY §5.04.C.4 and WBO §4(c)(3) **vacate**; WBC 2016 (c) **vacant**. IBF Rule 1.A.4 withdraws sanction only for a **vacant-title / elimination** both-miss, and does **not** number a champion-defence both-miss. **Do not rewrite R42 for want of a citation, and do not rewrite it because GLORY disagrees.** | Classification, not a patch. If the game one day names GLORY, that body's condition is vacant-after-the-match. |
| **P9** | Hearing / stripping ceremony / time to make weight again | **Scenery.** Scale-vacate in the retrieved body texts is **on the scale**, not after a board. IBF/WBO give **two hours** (or the local commission's time) to make the *prescribed* weight — that is the weigh-in window, not a later hearing. | R42 already: no ceremony, no press cycle, no commission hearing. Published agrees with the absence. |
| **P10** | Purse forfeit **20%** (`weight_classes.json` `miss.fine_fraction`) | **Keep. Do not change to 25% as a global** (J3 **D11**, not reopened). 20% is **CUSTOMARY** US MMA and **invented** as a game default. Nevada `NAC 467.522` is **25% to the opponent** (or lesser, unless ≤1 lb). Oregon **20%**. PFL 2025 tournament **20%** of show purse (body). GLORY **up to 20% / 30%** by kg, discretionary. ONE page: **“a percentage”** — **UNKNOWN**. ABC boxing ratings criteria: **minimum 10%** either day, championship boxing. | Cite D11. A Nevada-tagged overlay is optional later and is **not** this pack. |
| **P11** | Catchweight approval | **Already invented** (`catchweight_max_fraction` **0.03**, else “opponent refused”). Who agrees, in the published texts: both camps + promoter + (commission cards) the regulator. ONE adds **105%** of each other's official hydrated weight. WA: **5%** of upper limit then hard cancel. **Do not ship an approval-office sim.** | D12 stands. The 3% window is invented. Do not retune it here. |
| **P12** | Second-day / day-of weigh-ins and hydration testing | **Scenery. Do not ship a second weigh-in mechanic** (TASK: that is a new mode). IBF second-day cap table is a **body's published condition** (waived HW / unification). ONE USG **≤ 1.025**, 24–48 h, is a **body's published condition**. ABC boxing ratings criteria: championship follow-up, **10%** of contract weight. CSAC **15% fight-day cancel**: voted 2019; **current 4 CCR force UNKNOWN**. `4 CCR 299` is oral rehydrate + optional USG, **not** a 15% cancel. UFC/NSAC day-before: **no** rehydration cap retrieved. | D10's day-before house default stands. Do not rebuild D2. |
| **P13** | Add a knob to `championship_rules.json`? | **Do not.** R42 deliberately did not. The code never argued for a dial. Labelling the GAME RULE in research is enough. | Same chair as R41's `interim_hold_weeks` *would* have been if the belt-on-the-scale needed a number. It did not. |
| **P14** | Does any of this outrank J5 rank-2 membership? | **No.** See priority ruling. Classification of a shipped GAME RULE is not a new system. Hydration / second-day / 25% overlay / GLORY both-miss vacate are scenery or “do not rewrite R42.” | J5's priority is not reopened. J6 **A16** already said no for the athlete ledger. |
| **P15** | **Minimum change** (this study's D16 / E18 / G18 / A18) | **Ship nothing.** Four one-liners — see each area's (d). Build order is the priority ruling, not a fifth system. | The belt-on-the-scale already shipped. This pack names what is backed. |
| **P16** | Federation / IBJJF / Olympic-IF scales | **Not this pack.** D2 is a promotion-MMA object (J3 Issue 6). Gi scale, IJF random weigh-in, UWW 2 kg Ranking Series tolerance stay on J2's calendar nodes. | Do not force day-before onto IBJJF. |

**Fifth area?** No. A playable second-day / hydration / commission-hearing career would be a new mode. It does not outrank J5's membership object, and it does not outrank leaving R42's GAME RULE labelled. Park it as scenery (priority ruling).

---

## File-level anchors (what is live vs this study)

| File / fact | Role | Live? | Honesty |
|-------------|------|-------|---------|
| **R42 `resolve_title_bout` / `made_weight`** | Belt cannot move to a misser; champion-miss+win → `vacant`; both miss → belt untouched | LIVE (`R42_DIGEST.md`, 2026-09-07) | **GAME RULE**, no federation name. Direction is the honest one. Both-miss “does not move” is the **smaller** rule and is the game's own invention where GLORY/WBO/WBC **vacate**. **Do not rewrite.** |
| **`championship_rules.json`** | R41: `interim_hold_weeks` **8**, labelled GAME RULE. R42 **did not add a knob** | LIVE (this workspace: `version` 1, notes “R41, 2026-09-06”; no miss/allowance/belt-scale key) | **Honest absence of a dial.** P13: keep it absent. Do not hang a GLORY-vs-IBF both-miss enum on this file. |
| **`WeightCut.gd:69` `allowance_for(family)`** | `document().allowance_kg[family]`, default **0.0** | LIVE | **Family-keyed, not title-keyed.** See P2. |
| **`WeightCut.gd:187`** | `over_by := actual - limit - allowance_for(family)` | LIVE | Title bouts get the same family cushion as prelims. |
| **`WeightCut.gd:189` `miss` block** | Reads `weight_classes.json` `miss`; if over-by/limit ≤ `catchweight_max_fraction` → catchweight + `fine_fraction`; else `bout_off` | LIVE | **Invented** 3% window and 20% fine. Honest **shape** of “miss, then maybe catchweight, then maybe off.” |
| **`weight_classes.json` `allowance_kg`** | boxing **0.0**, mma **0.45**, kg **0.0** | LIVE (v2, D2) | MMA 0.45 kg ≈ 1 lb **CUSTOMARY** non-title. Boxing 0.0 is **stricter than** the 1 lb non-title custom. Kickboxing family maps to **mma**, so GLORY-shaped cards inherit 0.45 kg even though GLORY titles are at-or-under. |
| **`weight_classes.json` `miss.fine_fraction` `0.2`** | Purse slice on a made catchweight | LIVE | **CUSTOMARY / invented.** Not Nevada 25%, not ONE's unpublished %, not ABC Unified. J3 D11: do not silently “fix” to 25%. J6: already comes off `purse` before `payee_split`. **Not this pack's money work.** |
| **`weight_classes.json` `miss.catchweight_max_fraction` `0.03`** | Catchweight vs bout-off | LIVE | **Invented.** ONE is 105% of each other; WA is 5% of class upper. |
| Weigh-in calendar | Day before (D2 / D10) | LIVE | **Honest** for UFC-shaped pro. NJ print (`13:46-1A.3` via MMA `24B.5`) is **day-of by 13:00** — **NATIONAL print**, not the house default. D10 stands. |
| Rehydration cap / second-day / USG | — | **Absent** | **Honest for UFC-shaped default.** **Missing** as an overlay for ONE / IBF. P12: scenery, not a fifth area. |
| Title-keyed allowance | — | **Absent** | **Honest omission of a non-Unified-MMA-rule.** P3. |
| `championship_rules.json` miss/belt keys | — | **Absent** | R42 on purpose. P13. |
| Commission-hearing / strip-ceremony object | — | **Absent** | **Honest omission.** P9. |
| Hydration test (USG) | — | **Absent** | Honest for the house default. ONE overlay = scenery unless `one_championship` is later tagged with `evidence`. |
| R40 / `get_promotion_bout_offer` | Federations still payable as promotions until R40 | LIVE (J2) | **Not this sprint.** J2 D6 stands. |
| J5 rank-2 membership object | Gym floor after R43 | **Absent** (J5) | **Not outranked** by anything in this pack (P14). |

---

# Area 1 — The championship weight itself

What commissions and the Unified Rules publish about the weight **allowance** for a championship bout as against an ordinary one. Is the zero-allowance championship limit a regulation, an ABC recommendation, or a sanctioning body's own condition? Where does `WeightCut.gd:69` `allowance_for` sit against it?

## (a) Decisions coming (named as calls)

1. **Call: whose object is the 1 lb / 0 lb split?** Unified MMA, ABC custom, commission regulation, or a body's championship condition.
2. **Call: `allowance_for`.** Family-wide as live, or title-keyed.
3. **Call: author a championship allowance?** Store 0 on title bouts, omit, or leave the family default.

## (b) Evidence (cited) + UNKNOWN discipline

### ABC Unified Rules of MMA — no title/non-title allowance split

**ABC Unified Rules of MMA** (PDF “AMENDED WITH RULE CHANGES AUGUST 5, 2026, REQUESTED IMPLEMENTATION DATE OF NOVEMBER 2027,” retrieved 2026-09-07 from abcboxing.com):

Weight classes are listed (atomweight through super heavyweight) as **limits**. Then:

- **(a) Allowances within Division:** “there are no allowance restrictions if both combatants weigh-in within the same contracted division.”
- **(b) Weight Miss Catch Weight:** if a person misses the contracted weight and the two competitors are in different weight classes, the heavier opponent shall not exceed **five (5) lbs** of the lower weighing fighter.
- **(c) Contracted Catch Weight(s):** no weight-spread allowance between contracted catch-weight fighters so long as both are below the contracted weight. Commissions **may deny** catch-weight fights if the differential is a safety disparity.

**No championship row. No 1 lb. No 0 lb.** Older ABC MMA PDFs (2018/2019) print the same (a)(b)(c) and mark italic/underlined items as **Procedural Recommendations** rather than Unified Rules. The 2026 PDF still does not write a title/non-title cushion.

**ABC Committee Report on Unified Rules for MMA** (live abcboxing.com page, verified 2026-09-07):

> “It is recommended that the **unwritten custom** of the one pound allowance for non-title bouts be continued, **but only if provided for in the written bout contract or by regulation**.”

That is the honest origin of “non-title 1 lb, title 0.” It is **CUSTOMARY**, recommended, contract-or-regulation-gated — **not** Unified MMA text.

Journalism that says “the Unified Rules build in a 1-pound cushion that disappears for championships” is **wrong as a citation of Unified MMA**. It is restating the custom. Label it **CUSTOMARY journalism**.

### Commissions that *did* write a title/non-title split

| Jurisdiction | What is published (verified 2026-09-07) | Title vs ordinary? | Belt? |
|--------------|-----------------------------------------|--------------------|-------|
| **Wisconsin `SPS 192.43`** (MMA weigh-in) | **One-pound** variance “for all weight classes for all bouts **except title bouts and catch-weight bouts**.” Weight allowances **between** classes “do not apply to contestants in a title bout.” Department representative has sole discretion to cancel if a contestant does not make weight | **Yes — regulation** | **No** belt sentence in this section |
| **Oregon `OAR 230-030-0150(2)(g)–(h)`** (accessed May 2025 compiler; still the live rule page this pass) | Professional miss → **20%** of purse to opponent if still over after **two hours**, unless ≤1 lb. **“The 1 pound allowance set forth in this section does not apply to championship or title bouts.”** Title: “must be at or below the agreed upon weight.” Title miss: that competitor “is **not eligible to win the title**,” the one who made weight “is eligible” | **Yes — regulation** | **Yes — commission ineligibility** |
| **Nevada `NAC 467.522`** (Cornell LII + nv.us chapter rev. listed 2026-04-13) | **25%** of purse to the **opponent** (or lesser set by Executive Director / Commission), unless the difference is **1 lb or less**. One hour after weigh-in to make it or be within 1 lb | **No title split in this section** | **No** |
| **Nevada `NAC 467.476` / `467.514` / `467.7956`** | Cornell LII: **Repealed** by R089-22A, eff. 2022-12-29 (weight classes, weigh-in procedure, MMA classes / post-weigh-in loss). The 2026-04-13 nv.us HTML chapter **still lists** those section numbers in the TOC and still prints `467.7956` class text. `467.522(3)` on nv.us still *cross-references* the repealed pair | **UNKNOWN which text is live** for class tables / procedure | — |
| **California `4 CCR 297`** | Contestants weighed **within 30 hours** of the scheduled match (Westlaw: current through Register 2026, No. 35, 2026-08-28) | **No** 1 lb title split in 297 | — |
| **California `4 CCR 298`** | Boxing **between-class** difference schedule (3–12 lb / no limit HW), not a 1 lb championship cushion | Between-class, not title/non-title | — |
| **California `4 CCR 299`** | Rehydrate **orally** only; IV rehydrate → cannot compete. Contestants **may** be required to submit urine for USG “to verify proper hydration” | Hydration permission, **not** a % cap | — |
| **New Jersey `N.J.A.C. 13:46-1A.2`** | Boxing **between-class** difference schedule | Between-class | — |
| **New Jersey `13:46-1A.3` / MMA `13:46-24B.5`** | Boxers weighed **not later than 13:00 on the day of the show**. MMA weighing “in accordance with” 1A.3. No more than **1%** body-weight loss on the day of the contest in an attempt to make contract weight | **Day-of print** for NJ MMA, inherited from boxing. **No** 1 lb title split retrieved | **No** belt sentence retrieved. Championship-match subchapter **8A** is rounds/fouls, not scale-and-belt |
| **Colorado 4 CCR 740-1** (Office of Combative Sports) | Boxing **between-class** allowance table by pound class; MMA adopts ABC Unified MMA by reference (2022/2024 PDF URLs in the CCR) | Between-class boxing; MMA → ABC | ABC MMA has no belt rule |

**Nevada print vs live (do not wire blindly).** R089-22 (approved 2022-12-29) repealed a large block of NAC 467, including 467.009 (adoption of ABC Unified Championship / Unified MMA), 467.476, 467.514, 467.7956, and the MMA judging/foul cluster, intending a “NRUC” restatement. Cornell labels those sections Repealed. The official chapter HTML retrieved 2026-09-07 still prints them. **`NAC 467.522` was amended, not repealed**, and is the live miss-weight **money** rule. Do not treat repealed class tables as 2026 Nevada MMA law.

### Bodies' own championship conditions (zero on the title scale)

These are **not** ABC Unified MMA and **not** a commission purse rule. They are the body's published condition for *its* belt.

| Body | Allowance on a title scale | Evidence (verified 2026-09-07) |
|------|----------------------------|--------------------------------|
| **GLORY Rules 2026 v2** (effective 2026-03-16) | Titles with a maximum weight “can only be won or defended if **both Athletes are at or under the weight limit**.” No 1 lb. Weigh-ins **the day before** | PDF §5.04.C.1; §2.02.A |
| **IBF Championship Contest Rules** (posted 2025-08-13; amendments through 2025-04-30) | Prescribed division weight on the official weigh-in; **two hours** (or local commission time) to make it. Second-day cap table (not a 1 lb). Waived for **heavyweight** and **unification** | Rule 1 + 1.A / 1.B |
| **WBO Regulations** (Jan 2024 PDF this pass) | Prescribed weight; **two hours**. Championship “may not be won at the scales” | §4 |
| **WBC** (2016 championship-fight synthesis PDF still circulated; 2015 Rules & Regulations PDF) | Two hours; champion over → loses the title on the scales | 2016 synthesis (a)–(c) |
| **PFL 2025 World Tournament Rules** (effective 2025-03-01, live pflmma.com/wtrules) | First round / semis: **one-pound overage**, subject to commission approval. **Finals: no allowance** — “meet the upper limit of the division” | §§1.3, 2.3, 3.2 |
| **ONE** martial-arts page | Contracted class or catchweight; **no** 1 lb title/non-title split on the page. Hydration first (USG ≤ 1.025), then the scale | onefc.com/martial-arts |

### Where `allowance_for` sits

Live (`weight_classes.json` + `WeightCut.gd:69` / `:187`):

```
over_by := actual - limit - allowance_for(family)
made   := over_by <= 0.0001
```

| Family | Live allowance | Against published |
|--------|----------------|-------------------|
| `mma` (also kickboxing, muay_thai, sanda, savate via `families`) | **0.45 kg** (~0.99 lb) | Matches the **unwritten non-title custom**, applied to **every** MMA/kick weigh-in, **including** a title bout. GLORY titles want at-or-under. PFL finals want at-or-under. Oregon titles want at-or-under. The game does **not** know a title flag at the scale |
| `boxing` | **0.0** | Matches **championship** boxing (IBF/WBO/WBC prescribed weight) and is **stricter than** the 1 lb non-title custom. Applied to ordinary boxing too |
| `kg` | **0.0** | Federation/kg-named classes. Not this pack (P16) |

R42's belt rule reads `made_weight`. It does **not** re-derive allowance. A title MMA athlete 0.4 kg over the class limit still **makes** under the live family cushion, and can take the belt. That is the GAME default, not a published championship condition.

**Do not retune 0.45 or 0.0 in this pack.** Do not add `allowance_kg_title`. J2 §6.3.

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| `allowance_for(family)` | boxing 0 / mma 0.45 / kg 0 | **Invented as a family default.** MMA 0.45 is CUSTOMARY-shaped for *ordinary* US MMA. Boxing 0 is championship-shaped for *all* boxing |
| Title-keyed allowance | none | **Honest omission of a non-Unified-MMA-rule** |
| 1 lb only on non-title | none | Absent. The custom is not in the file |
| GLORY at-or-under on title | none as an overlay | Kickboxing family inherits MMA 0.45 |
| PFL finals zero-allowance | none as an overlay | — |
| Catchweight 5 lb different-class (ABC MMA (b)) | none; game uses **3% of limit** | **Invented** window vs ABC's 5 lb *different-class* miss rule |

## (d) Minimum change (one concrete recommendation)

**Do not author a championship-vs-ordinary allowance. Leave `allowance_for` family-keyed. Label MMA 0.45 kg as the ordinary 1 lb custom applied even on title bouts, and boxing 0.0 as the championship shape applied even on ordinary bouts. Do not add a key to `championship_rules.json`. Do not retune 0.45 or 0.0.**

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — Temptation to “fix” title MMA to 0 kg “because that's what championships do.”**  
**Solution:** P1–P3. ABC Unified MMA does not say so. The custom is contract-or-regulation. R42 already decides belt fate from `made`. Tightening the cushion would change who `made`, which is a new number, not a citation.

**Issue 2 — Temptation to put `title_allowance_kg: 0` next to `interim_hold_weeks`.**  
**Solution:** P13. R42 did not add a knob because the code did not argue for a dial. A 0 would be a federation-shaped number with a GAME label — the thing J1 §4.1 exists to avoid *naming*, not to invent.

**Issue 3 — Brand / ABC Unified MMA PDF, GLORY rules PDF, IBF belt.**  
**Solution:** J1 §4.1. Text names in research. No seals, no photographed belts, no official-form UI art.

**Issue 4 — Exporting Oregon or Wisconsin onto a Saitama card.**  
**Solution:** Jurisdiction-tagged. Default remains the family cushion. Host-nation overlays: UNKNOWN unless filed with `evidence`.

---

# Area 2 — Who is ineligible, and who says so

Is *“a contestant who missed weight cannot win the title”* a published rule of anyone — a state commission, the ABC, a sanctioning body's own championship regulations — or contractual / promotional practice recorded case by case? Distinguish a **statute** from a **body's own published condition** from **CUSTOMARY journalism**. If the three disagree, say so and mark UNKNOWN rather than picking a favourite.

## (a) Decisions coming (named as calls)

1. **Call: statute?** Which commission, if any, writes ineligibility.
2. **Call: ABC?** Unified MMA vs ratings-criteria vs committee custom.
3. **Call: body's published condition?** Which of the catalog bodies print it.
4. **Call: UFC / US MMA journalism.** Rule, or CUSTOMARY.

## (b) Evidence (cited) + UNKNOWN discipline

### Three kinds, not one sentence

| Kind | What it can do | What it cannot do |
|------|----------------|-------------------|
| **Statute / commission regulation** | Fine a purse, cancel a bout, refuse a catchweight, (rarely) say who is eligible for *a* title the commission is willing to recognise | Own a UFC/ONE/GLORY belt. ABC-member commissions regulate the **contest**, not the promotion's property |
| **Body's published condition** | Condition *its* championship on the scale | Bind a Nevada purse, or bind a different body's belt |
| **CUSTOMARY journalism** | Report what happened last Saturday | Be stored as a bylaw |

### Statute / commission — almost never the belt

**ABC Unified MMA (Aug 2026 PDF):** no title, no ineligibility, no purse %. Catch-weight **permission** (b)(c) only.

**Nevada `NAC 467.522`:** purse **25% to the opponent** (or lesser). **Not** a belt. Live (Cornell + nv.us).

**Wisconsin `SPS 192.43`:** 1 lb except title/catchweight; cancel discretion. **Not** “cannot win the title.”

**Oregon `OAR 230-030-0150(2)(h)(C)`** (verified this pass against oregon.public.law; source oard 230-030-0150):

> “If a title bout is scheduled and one competitor does not make the agreed upon weight, that competitor is **not eligible to win the title**, but the opponent who made the agreed upon weight is eligible [to] win the title.”

That is the only retrieved **commission** sentence that writes ineligibility. It is **NATIONAL / Oregon**. It does not say what happens if **both** miss. It does not name a hearing. Do not export it onto the 13 as house law.

**New Jersey, New York, California 4 CCR:** no retrieved “cannot win the title” section this pass. NJ championship-match rules (`13:46-8A`) are boxing *how the match is fought*, not scale-and-belt.

**Western Australia Combat Sports Commission — Weight Classes and Missed Weight Policy** (page reviewed 2025-07-01, retrieved 2026-09-07): miss ≤ **5%** of upper limit → bout **may** proceed on mutual agreement (two opponents, trainers, promoter). Miss **> 5%** → bout **cannot** proceed (health and safety; permit may be suspended). Post-contest conditions (dietician, class restriction) after a **reasonable opportunity to be heard**. **No belt sentence.** The hearing language here is about *post-contest conditions on a misser*, not about vacating a championship.

### ABC boxing ratings criteria — championship boxing, second day, recommendation-shaped

Live ABC Ratings Criteria page (verified 2026-09-07). Under **RECOMMENDATIONS**, after “Extreme Weight Cutting is Cheating”:

Any 8, 10, or 12 round **championship** bout: follow-up weigh-in; boxers cannot exceed **10%** of bout-contract weight. If the boxer misses at this second-day weigh-in: the bout continues as a title fight **only for the boxer that has made weight**; the over-weight boxer **cannot claim the title**; if the champion is the over-weight boxer and wins, **the title becomes vacant**. Minimum fine **10%** of the offender's purse to the other boxer, either day. “If adopted this proposal will take effect on January 1, 2019.”

**Kind:** ABC **ratings-criteria recommendation** for **championship boxing**, still printed on the live page. **Not** Unified MMA. **Not** a commission statute unless a commission adopted it. Do not store 10% as MMA house law.

### Bodies' own published conditions (the sentence R42 authored as a GAME RULE)

| Body | Published ineligibility? | Kind |
|------|--------------------------|------|
| **GLORY 2026 §5.04.C** | Yes. Both must be at or under. Champion miss → forfeits; challenger win → new champion; champion win → vacant. Challenger miss → champion remains regardless of outcome | **Body's published condition.** Catalog org |
| **IBF Rule 1.A** | Yes. Champion miss → title **forfeited on the scale**; may be staged as vacant-title fight; challenger who made weight and wins takes vacant; former champion wins → remains vacant. Challenger miss (champion made it) → champion retains **whether he wins or loses**. Vacant-title / elimination misser who wins is **not** declared the winner | **Body's published condition.** Not in the 18; contrast only (J3 D4) |
| **WBO §4(c)** | Yes. Champion miss → loses title at the scales, vacant whether or not the challenger makes weight; championship **may not be won at the scales**; challenger who made weight and wins succeeds; prior champion wins → remains vacant. Challenger miss, fight goes as overweight: challenger **not eligible**; if the champion **loses**, championship **vacated** | **Body's published condition.** Contrast only |
| **WBC 2016 championship-fight synthesis** | Yes. Champion over after two hours → loses title on the scales; challenger in weight who wins is champion; ex-champion wins → vacant. Challenger over → champion retains; option of non-title bout. **Both** over → title or eliminatory position **declared or remain vacant** | **Body's published condition.** Contrast. Confirm current WBC PDF before any later overlay; 2009/2015/2016 texts still circulate |
| **PFL 2025 Finals §3.2** | Yes. Misser: bout may proceed at PFL discretion; **not** a championship fight for the misser; **20%** of show purse to opponent; if the misser wins they are **not** declared Champion, **no** belt, **no** champion bonus | **Body's published condition.** Catalog org. Tournament object, not a house linear belt |
| **ONE martial-arts page** | **Not on that page.** Hydration + catchweight + “a percentage” of purse. Title-miss **ineligibility** appears in **event press / secondary lists**, not in the retrieved Global Ruleset block | **UNKNOWN as a ONE bylaw.** CUSTOMARY / event-by-event on the belt; **published** on hydration and 105% |
| **UFC** | No UFC.com / athlete-page / promotional-agreement **primary** retrieved this pass that writes ineligibility | **CUSTOMARY journalism**, consistently reported in the same direction as GLORY/IBF for a **challenger** miss; champion miss **case-by-case in the reporting**. J3 D11: **UNKNOWN as a single UFC rule** |

### Do they disagree?

**On the usual direction (a misser does not take the belt):** bodies that publish a condition agree. Oregon agrees. Journalism about US MMA title cards agrees for the **challenger**.

**On who has the authority to say it:** they disagree.

- ABC Unified MMA: **silent**.
- Nevada: **purse**, not belt.
- Oregon: **commission ineligibility**.
- GLORY / IBF / WBO / WBC / PFL finals: **the body's belt**.
- UFC: **not retrieved as a bylaw**.

**On the champion who misses and still wins:** GLORY, IBF, WBO, WBC, ABC boxing ratings-criteria (second day), and R42: **vacant**. UFC journalism usually reports a strip. **UNKNOWN as UFC house law.**

**On both miss:** they **disagree**. See Area 3. That disagreement is **UNKNOWN as a universal**, not a reason to pick GLORY over R42.

**Ruling on P4 / P5.** Do not flatten this into “everyone says R42.” Do not flatten it into “nothing is published.” The GAME RULE is allowed to exist without a federation's name (J1 §4.1). The **backed** parts are body conditions + one state regulation. The **UFC** cell stays UNKNOWN.

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| Misser cannot take the belt | R42 `blocked_by_weight` | **GAME RULE.** Direction matches GLORY/IBF/WBO/PFL-finals/Oregon. Not ABC Unified MMA. Not `NAC 467.522` |
| Federation name on that rule | none | **Honest** (J1 §4.1, R42 digest) |
| UFC-as-bylaw flag | none | **Honest omission of an UNKNOWN** |
| Oregon overlay | none | Correct as MVP |

## (d) Minimum change

**Do not rewrite R42. Do not attach ABC, Nevada, UFC, or GLORY's name to the live rule. In research, label: GAME RULE; backed as a body's condition (GLORY/IBF/WBO/PFL finals) and as Oregon regulation; not Unified MMA; UFC UNKNOWN. If a later overlay names a body, that overlay needs `evidence` pointing at that body's current PDF — never as a silent global.**

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — Temptation to write `source: "ABC Unified Rules"` on R42.**  
**Solution:** Unified MMA does not contain the sentence. That would be a lie.

**Issue 2 — Temptation to write `source: "NAC 467.522"`.**  
**Solution:** That section is **25% of purse**. Different object (Area 4).

**Issue 3 — Temptation to treat a 2022 UFC title-miss report as a bylaw.**  
**Solution:** P5. CUSTOMARY journalism. No athlete name as data.

**Issue 4 — Brand / IBF, WBC, WBO, GLORY, PFL PDFs.**  
**Solution:** J1 §4.1. Contrast only for alphabet (J3 D4). Catalog bodies may be **named in research**. No belt artwork.

---

# Area 3 — What happens to the belt

When the ineligible contestant wins anyway, what is published — vacancy, a stripping procedure, a hearing, a period to make weight again? **And when both contestants miss?** R42 shipped “the belt does not move” as the smaller rule. This is the single most decision-shaped question in the pack.

## (a) Decisions coming (named as calls)

1. **Call: ineligible wins.** Vacant, strip-hearing, or still champion.
2. **Call: both miss.** Vacate, or do not move.
3. **Call: does any published text argue against R42's both-miss?**
4. **Call: rewrite R42?** (The answer must be no — trap. Classification only.)

## (b) Evidence + UNKNOWN

### Ineligible wins — vacant on the scale, not after a hearing

Retrieved body texts vacate **on the scale** / treat the bout as a vacant-title fight. None retrieved this pass require a commission hearing, a 30-day window, or a rehydration-then-keep ladder to finish the vacancy.

| Source | Champion misses, still wins | Challenger misses, still wins | Extra |
|--------|-----------------------------|-------------------------------|-------|
| **R42 (GAME RULE)** | Division **vacant**. He keeps the win, not the belt | Belt **does not move** (champion made weight) | No ceremony |
| **GLORY §5.04.C.2–.3** | Title **becomes vacant** | Defending champion **remains** regardless of outcome | — |
| **IBF Rule 1.A.1–.2** | Title **forfeited on the scale**; if staged as vacant-title and former champion wins, **remains vacant** | Champion **retains whether he wins or loses** | Two hours (or commission time) **before** forfeiture, not after |
| **WBO §4(c)(1)–(2)** | Vacant at the scales; if prior champion wins, **remains vacant** | Challenger not eligible; **if the champion loses the overweight fight, championship vacated** | WBO is harsher on a champion who *loses* to a misser |
| **WBC 2016 synthesis (a)–(b)** | Ex-champion wins → **vacant** | Champion retains; option of non-title bout | — |
| **ABC boxing ratings criteria (second day)** | Champion over-weight and wins → **title becomes vacant** | Over-weight boxer cannot claim the title | Boxing championship follow-up; 10% cap |
| **PFL 2025 Finals §3.2** | Misser who wins is **not** Champion, no belt, no bonus | Same (finals are not champ-vs-challenger; both are finalists) | 20% show purse |
| **Oregon OAR 230-030-0150(2)(h)(C)** | Misser **not eligible**; the one who made weight **is** | Same one-line ineligibility | **Both-miss unstated** |
| **ABC Unified MMA / `NAC 467.522`** | **Silent** on the belt | Silent | — |

**WBO's extra:** if the champion **made weight**, the challenger missed, the fight goes as overweight, and the **champion loses**, WBO **vacates**. R42 does **not**: the champion made weight, so a challenger-miss + challenger-win leaves the belt with the champion. That is a **published argument otherwise** on *that one cell*, not on both-miss. **Do not rewrite R42.** A later WBO-named overlay would need `evidence`. Alphabet is scenery (J3 D4).

**Hearing.** WA's “reasonable opportunity to be heard” is for *post-contest conditions on a misser* (dietician, class lock), not for belt title. IBF/WBO two hours are the **weigh-in window**. Do not invent a board.

### Both miss — published text that argues otherwise

R42: **the belt does not move.** Digest: “nothing in a bout the champion did not lose to an eligible opponent knows a reason to strip him.”

| Source | Both miss | Argues otherwise than R42? |
|--------|-----------|----------------------------|
| **R42 GAME RULE** | Untouched | — |
| **GLORY §5.04.C.4** | “If both Athletes fail to weigh equal or less than the official weight limit, **the title will be vacant after the Match.**” | **Yes. Vacate.** |
| **WBO §4(c)(3)** | “If both the Champion and the challenger fail to make weight, the Championship **shall be vacated at the scale** and the fight will go forward as a nontitle fight.” | **Yes. Vacate at the scale.** |
| **WBC 2016 synthesis (c)** | “If both boxers do not make the weight after weighing in within the prescribed two (2) hour period, the title or eliminatory position at stake **shall be declared or remain vacant.**” | **Yes. Vacant.** |
| **IBF Rule 1.A.4** | “In the event both contestants in a **vacant title or elimination bout** fail to make the prescribed weight, **the sanction of the bout will be withdrawn.**” Same for second-day (1.B.4) | **Different object** (vacant/elimination, withdraw sanction). **Champion-defence both-miss is not numbered.** Reading 1.A.1 alone (champion miss → forfeited on the scale, unconditioned on the challenger) **could** vacate a defence both-miss; that reading is **not written as a both-miss case**. **UNKNOWN** as IBF champion-defence both-miss |
| **PFL 2025 Finals** | Not numbered as both-miss. A misser cannot be champion; a draw/NC/walkover awards **no** title (§3.4) | Not the same fact pattern |
| **ONE page** | Not numbered | UNKNOWN |
| **Oregon** | Not numbered | UNKNOWN |
| **UFC journalism** | Not retrieved as a both-miss title bylaw this pass. A 2026 UFC *non-title* both-miss report: bout proceeded catchweight, **no purse penalty** in that write-up — **not a title rule** | UNKNOWN as title law |

**Ruling on P8.** Published championship conditions that **vacate** on both-miss exist (GLORY, WBO, WBC 2016). R42's smaller rule **does not vacate**. That is a real disagreement. It is **not** a defect in R42. J1 §4.1 exists so the game may keep the smaller rule without GLORY's name on it. **Do not rewrite R42.** Label both-miss as the game's **honest invention** of the smaller rule. If a later overlay names GLORY, that overlay's condition is vacant-after-the-match, with `evidence` pointing at the current GLORY PDF.

**IBF vacant-title both-miss** (withdraw the sanction) is a third shape: not “vacate after the match,” not “do not move,” but **do not run it as an IBF vacant-title fight**. Scenery. Do not author a sanction-withdrawal verb.

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| Champion miss + win → vacant | R42 `_vacate_on_the_scale` | **GAME RULE.** Backed as a body's condition. Honest **shape**. No ceremony (honest omission) |
| Challenger miss + win → belt stays | R42 | **GAME RULE.** Matches GLORY/IBF. WBO would vacate — **not shipped**, correct as MVP |
| Both miss → does not move | R42 | **GAME RULE / honest invention of the smaller rule.** GLORY/WBO/WBC argue **vacate** |
| Hearing / 30-day make-weight-again | none | **Honest omission of a non-rule** |
| IBF “withdraw sanction” | none | Honest. Alphabet overlay is scenery (D4) |

## (d) Minimum change

**Do not rewrite R42. Do not add a both-miss vacate because GLORY published one. Do not add a WBO “champion loses to a misser → vacant” branch. Do not invent a hearing. In the digest and in this pack, say plainly: champion-miss+win vacant is backed as a body's condition; both-miss does-not-move is the game's smaller invention; published texts that vacate on both-miss exist and are not shipped.**

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — “GLORY vacates both-miss, so R42 is wrong.”**  
**Solution:** P8. Wrong object. R42 is a GAME RULE. GLORY is a body the game may one day name.

**Issue 2 — Temptation to add `both_miss: vacant` to `championship_rules.json`.**  
**Solution:** P13. That *would* be a knob. R42's code argued against a dial. Putting GLORY's answer in a GAME file without GLORY's name is the 2am decision.

**Issue 3 — WBO champion-loses-to-a-misser.**  
**Solution:** P7. Contrast. Alphabet overlay is J3 D4 scenery. Do not patch R42.

**Issue 4 — Inventing a 30-day “make weight again to keep it.”**  
**Solution:** P9. Not retrieved. IBF two hours are *at the scale*.

---

# Area 4 — The purse, the catchweight, and the day after

The game already forfeits **20%** and converts the bout to a catchweight (`WeightCut.gd:189` reading `weight_classes.json` `miss`). What is published about the forfeit percentage, about who approves a bout going ahead after a miss, and about second-day / day-of weigh-ins and hydration testing? **Say plainly whether any of it is shippable or whether it is scenery.**

Cite J3 **D10–D12**; do not re-litigate.

## (a) Decisions coming (named as calls)

1. **Call: forfeit %.** Keep 20, overlay 25, or omit.
2. **Call: who approves catchweight.**
3. **Call: second-day / day-of.**
4. **Call: hydration testing.**
5. **Call: shippable, or scenery?**

## (b) Evidence + UNKNOWN

### Forfeit percentage — published scatter, no ABC MMA number

| Source | Published % | Paid to | Kind | Shippable as a global? |
|--------|-------------|---------|------|------------------------|
| **Game D2** | **20%**; catchweight if ≤ **3%** of limit | Settlement slice off `purse` (J6) | **Invented / CUSTOMARY-shaped** | Already ships. **Do not retune** (D11) |
| **Nevada `NAC 467.522`** | **25%**, or lesser; unless ≤1 lb; 1-hour window | **Opponent** (current text) | **Statute** | Optional **NV-tagged** overlay later. **Not** a global fix |
| **Oregon `OAR 230-030-0150(2)(g)`** | **20%** after two hours, unless ≤1 lb | Opponent | **Statute** | Same: tag, don't globalise |
| **GLORY §2.02.D** | ≤1 kg: **up to 20%**; >1 kg: **up to 30%**; GLORY's **discretion**. Bout continues only with GLORY + opponent + Regulator | Opponent | **Body condition** | Do not author 20/30 as ABC |
| **PFL 2025 §§2.3 / 3.2** | **20%** of **show** purse (first/semis and finals) | Opponent | **Body condition** (tournament) | PFL overlay, not Jungle/LUX |
| **ONE page** | “Surrender **a percentage** of his or her purse” | Opponent | **Body condition, % UNKNOWN** | Do **not** invent the missing percentage (D11). Event press releases this pass have printed **25%** and **30%** as *that card's* figure — **not** a bylaw. Do not average them |
| **ABC boxing ratings criteria** | **Minimum 10%** either day, championship boxing | Other boxer | ABC **recommendation** | Boxing championship overlay; not MMA 20% |
| **ABC Unified MMA** | **None** | — | Silent | Do not invent |
| **UFC / many US MMA cards** | **20%** often reported; sometimes 30%; sometimes extra | Opponent | **CUSTOMARY journalism** | Keep 20 as CUSTOMARY default |
| **CSAC miss penalty** | 2019–practice often **20%**. A **2026-03-09 CSAC meeting** discussed raising the miss penalty from **20% to 30%** with a stated **2026-07-01** start, plus fight-day rechecks / USG / class-on-the-physical. **Whether that is live 4 CCR: UNKNOWN this pass.** Tracking fight-night weights (UFC Sacramento 2026 journalism) ≠ a published % | — | Meeting / journalism | **UNKNOWN as 4 CCR.** Do not ship 30 |

**20% is not ABC Unified text.** D11 stands.

**Who the fine is paid to.** Nevada / Oregon / GLORY / PFL / ONE page: **opponent**. The game slices `fine_fraction` off `purse` at settlement (J6 excerpt: weight-fine already off `purse` before `payee_split`). Whether that slice is *credited to the opponent* as a published transfer: **the live settlement path was not re-read as a payee-to-opponent in this workspace.** Do not invent an opponent-credit in this pack. R42's out-of-scope already: no new purse arithmetic.

### Who approves a bout going ahead after a miss

| Source | Who must agree | Hard stop |
|--------|----------------|-----------|
| **ABC Unified MMA (c)** | Commissions **may deny** catchweight if the differential is a safety disparity | Commission discretion |
| **GLORY §2.02.D** | **GLORY + opponent + Regulator** (if applicable) | Without that consent, not approved |
| **ONE page** | Catchweight negotiable if both within **105%** of each other's official **hydrated** weight; after the 3-hour window | 105% band |
| **WA policy** | Mutual agreement (two opponents, trainers, promoter) if miss ≤ **5%** of upper limit | **> 5%: cannot proceed** |
| **Oregon** | Professional competitor agrees to fight the misser; **authorized representative of the superintendent** approves; bout agreement amended | 5% over agreed weight at appearance **may** disqualify (`0150(2)(e)`) |
| **Wisconsin `SPS 192.43(5)`** | After communicating with the promoter, **commissioner or department representative** has sole discretion to cancel | Discretion |
| **PFL 2025** | **PFL's sole discretion** (subject to commission) | League + commission |
| **Game D2** | If over-by/limit ≤ 3%: catchweight + fine. Else: “the opponent refused the catchweight, bout off” | **Invented** 3% and a canned “opponent refused” |

**Shippable?** The **shape** (miss → maybe catchweight → maybe off) already ships. A three-party approval office is **scenery**. Do not retune 3%. Do not author ONE's 105% as a global.

### Second-day / day-of / hydration — scenery

**D10 stands:** house default is **day-before** (UFC-shaped). Same-day is the exception.

| Setting | When | Hydration / rehydration cap | Kind | Shippable? |
|---------|------|-----------------------------|------|------------|
| **Game D2 / D10** | Day before (Sunday for Monday) | None | UFC-shaped house | **Already ships.** Do not rebuild |
| **ONE page** | Combined hydration + weigh-in **24–48 hours** before the event; 3-hour window; catchweight path after | USG **≤ 1.025**; no scale until hydrated; must pass hydration and make weight **consecutively** | **Body's published condition** | **Org overlay** for `one_championship` if ever tagged with `evidence`. **Not a global rewrite.** Scenery until then |
| **IBF Rule 1.B + 2nd-day guidelines** (guidelines effective after 2021-01-19; **not unification**; championship rules also waive **heavyweight**) | Official weigh-in 20–30 h before first bout (or commission time). Second weigh-in **08:00–10:00 event morning** | **Cap table** (use the PDF; e.g. welter official **147** → second day **158** lb / 71.668 kg in the 2025 championship-rules table **and** the 2021 guidelines PDF). **Do not retype from memory at wiring.** Two hours (or commission) to make the *second-day* cap | **Body's published condition.** Alphabet | **Scenery.** Second weigh-in is a new mode (TASK) |
| **ABC boxing ratings criteria** | Championship 8/10/12-round follow-up at commission's time | **10%** of contract weight; **no** cutting at that weigh-in | ABC recommendation | Scenery |
| **CSAC 15% fight-day cancel** | Voted Oct 2019, 5–0 (ESPN). Aimed at extreme rehydration | **Whether 4 CCR currently in force: UNKNOWN.** Live `4 CCR 299` is oral-only rehydrate + **optional** USG, **not** a 15% cancel. 2026 CSAC has been **publishing fight-night weights** (secondary) — tracking ≠ cancel. 2026-03-09 meeting discussed fight-day rechecks / USG / 20→30% miss penalty from 2026-07-01 — **meeting, not retrieved 4 CCR** | Vote / meeting / journalism | **UNKNOWN as regulation. Do not ship.** |
| **UFC / NSAC day-before** | ~30–36 h typical | **No** rehydration cap retrieved | CUSTOMARY / house | Honest absence |
| **NJ `13:46-1A.3` via MMA `24B.5`** | **Not later than 13:00 on the day of the show** (print). ≤ **1%** body-weight loss that day to make contract | Day-of **print** | **NATIONAL print.** UFC-shaped NJ cards in practice are day-before — **CUSTOMARY overlay vs print** | Do not flip D10 to day-of because NJ boxing print says 13:00 |
| **Illinois JCAR 68 Ill. Adm. Code 1370.1400** (retrieved this pass as a contrast) | Title bouts: contestants may weigh **no more than 10 lb heavier on the day of the bout** than at the weigh-in | Day-of cap **10 lb** | **NATIONAL** | Scenery. Do not author 10 lb as house |
| **ACSM 2021 / ISSN 2025** | Position stands, not commission rules | ISSN: suitable losses **6.7 / 5.7 / 4.4%** BM at 72/48/24 h; acute water **~2–4%** last 24 h; long-term **unknown** (point 16) | Medical society | **Cite; do not mechanic** (D12, TASK) |
| **CSAC physical (advisory)** | Recommendation: do not attempt to lose **more than 10%** of walking weight | Recommendation on a form | Advisory | Do not turn into stamina physics |

**Contested (D12, not reopened):** commissions treat large cuts as safety; ISSN/ACSM describe how athletes cut and mark long-term harm unknown; promotions treat day-before as infrastructure. This desk does not pick a winner.

**Shippable?** **No new mechanic.** Day-before and the 20% fine already ship. Second-day, USG, 15%, 10% ABC boxing, Illinois 10 lb, ONE 1.025 are **scenery** unless a later org overlay is filed with `evidence` — and even then, a second weigh-in is a **new mode**, not a patch on D2.

## (c) What the game does today — honest / invented / absent

| Object | Today | Honesty |
|--------|-------|---------|
| Miss fine 20% | `miss.fine_fraction` 0.2 | **CUSTOMARY / invented.** D11: keep |
| Catchweight window 3% | `catchweight_max_fraction` 0.03 | **Invented** |
| Opponent-refused / bout off | canned when over 3% | **Invented** as a hard stop (WA's 5% is a different hard stop) |
| Fine paid *to opponent* as a transfer | slice off misser's `purse`; opponent credit **not verified** in this excerpt | Do not invent the credit here |
| Day-before calendar | D2 | **Honest** UFC-shaped |
| Second-day / IBF table | none | **Honest for UFC default**; missing for IBF overlay |
| ONE USG 1.025 / 105% | none | **Honest for UFC default**; missing for ONE overlay |
| CSAC 15% cancel | none | **Honest** — current 4 CCR force UNKNOWN |
| Hydration RPG | none | **Correct absence** |

## (d) Minimum change

**Keep D2's day-before calendar and the 20% fine. Do not retune 20%, 3%, or night-cost. Do not add a second weigh-in, a USG test, a 15% fight-day cancel, or a 25% Nevada global. Do not author ONE's missing percentage. Optional later, still scenery-ranked: a jurisdiction or org overlay with `evidence` (NV 25%, ONE USG, IBF second-day table copied from the PDF — never from memory). A second weigh-in remains a new mode.**

## (e) Issues, each with a solution (incl. brand)

**Issue 1 — Temptation to “fix” 20% → 25% because Nevada is primary.**  
**Solution:** D11 / P10. That would mis-label Jungle / ONE / GLORY.

**Issue 2 — Temptation to ship ONE 105% / USG 1.025 as physics.**  
**Solution:** P12. Body overlay. New mode if it is a second test.

**Issue 3 — Temptation to ship CSAC 15% because the 2019 vote was 5–0.**  
**Solution:** Current 4 CCR force UNKNOWN. Tracking ≠ cancelling. Do not ship.

**Issue 4 — Temptation to author a rehydration ladder from the IBF table.**  
**Solution:** TASK forbids it. Cite the PDF. Do not retype at wiring. Do not turn 147→158 into stamina.

**Issue 5 — Brand / IBF table, ONE Medical, CSAC physical, ABC ratings page.**  
**Solution:** J1 §4.1. Cite in research. No seals. No athlete names as data. Do not name the physicians on ONE's page as data.

**Issue 6 — IBJJF / federations (J3 Issue 6, restated).**  
**Solution:** P16. D2 is promotion-MMA. Do not force day-before onto IBJJF.

---

# Priority ruling

**Does any of this outrank J5's rank-2 membership object?**

**Plain words.** R42 already shipped the belt-on-the-scale as a GAME RULE. This pack's job was to **classify** that rule against published text: which parts are backed as a body's condition, which parts are a commission's, which parts are CUSTOMARY journalism, and which parts are the game's own invention. The true answer is smaller than a weigh-in expansion would like.

- **Champion misses and wins → vacant** is the GAME RULE **and** a body's published condition (GLORY, IBF, WBO, WBC, ABC boxing ratings-criteria second-day). Oregon writes ineligibility as regulation. ABC Unified MMA is silent. Nevada writes a **purse**, not a belt.
- **Challenger misses → champion keeps** is the GAME RULE **and** GLORY/IBF. WBO would vacate if that champion then **loses** — not shipped, not a reason to reopen R42.
- **Both miss → belt does not move** is the GAME RULE **and** the game's **honest invention of the smaller rule**. GLORY, WBO, and WBC 2016 **vacate**. That disagreement is the finding. It is not a patch list.
- **20% / 3% / day-before / family allowance** already shipped in D2. None of them become more true by adding a second scale.
- **Second-day, USG, 15%, 25% as a global, a hearing, a rehydration ladder:** either UNKNOWN, body-specific, or scenery.

**Does any of it outrank J5's rank-2 membership object?** **No.** J5's priority is not reopened. J6 **A16** already said no for the athlete ledger. This pack is **classification of a rule that already shipped**. It does not consume the slot J5 reserved for the gym's floor after R43. A hydration career, a 25% Nevada overlay, or a GLORY both-miss rewrite would be a new object, and a worse one, if it delayed membership.

**Order, next twelve months:**

| Rank | Area | Research or build? | Wait a year? | Scenery? |
|------|------|--------------------|--------------|----------|
| **1** | **Leave R42's GAME RULE in place** (this pack's honesty pass) | **Do not rewrite.** Label: backed as a body's condition on champ-miss+win; both-miss is the smaller invention; no federation name | No — it already shipped | Rewriting R42 for a citation = **scenery-as-lie** |
| **2** | **J5 rank-2 membership / training-floor object** | **Unchanged.** This pack **does not outrank it** | No — J5 already ranked this | Sport-wide $150/month = **scenery-as-lie** (G1/G24) |
| **3** | **Optional org/jurisdiction overlay with `evidence`** (ONE USG, NV 25% on NV-tagged cards, IBF table on an alphabet overlay if boxing world titles ever ship) | **Wait.** Default remains D2 + R42. Overlays are data later, never a silent global | Yes, except a one-line `evidence` tag if an org file is already being touched for another reason | ONE 105% as house physics = **scenery**. Alphabet overlay = **scenery** (D4) |
| **4** | **Second-day weigh-in, hydration RPG, CSAC 15%, hearing, rehydration ladder** | **Wait. Prefer never as MVP.** P12: scenery. TASK: second weigh-in is a new mode | Yes | Second scale / USG career = **scenery** (J2 §6.2) |

### Defend

**This pack's rank 1 does not beat J5's rank 2.** Leaving R42 labelled is **not a new system**. It is the honesty pass on a rule that already ships. It does not consume the slot J5 reserved for membership. **J5 rank 2 stands.**

**J5 rank 2 still beats a 25% Nevada overlay and a second scale.** Nevada 25% is real and small and **jurisdiction-tagged**. A gym without members is still how this desk goes broke after R43 (J5 plain words). Do not skip membership to build a weigh-in office.

**Why “ship nothing” is allowed to be the answer.** Publishable is not the same as shippable. GLORY both-miss vacate is publishable **and** the wrong shape for a GAME RULE that already chose the smaller fork. CSAC 15% is a 2019 vote with UNKNOWN current force. ONE's purse % is still “a percentage.” J2 §6.3 / J3 D11: inventing a number because a PDF is loud is the 2am decision.

**Why this does not reopen J5's priority, R40, J3 Areas 1–3, J4 E1–E3, or R42's shipped rule.** Payee stays the athlete. Caps stay stored. No `gym_cut`. Federations still wait on R40. Title-bout flag, interim, and belt-on-the-scale stay as shipped. D10–D12 are cited, not re-derived. This pack only names what the scale already does, and refuses to invent the rest.

### What is scenery (as plainly as J2 §5.1)

| Object | Playable without a new mode? | What the player actually decides | What the player does **not** decide |
|--------|------------------------------|----------------------------------|-------------------------------------|
| R42 belt-on-the-scale | **Already playable.** The scale already binds the belt | Cut, miss, accept catchweight, withdraw (D2 verbs) | Commission hearings, IBF second-day, ONE's refractometer |
| D2 day-before + 20% | **Already playable** | Same | Nevada 25% vs ONE “a percentage” vs GLORY up-to-30 |
| ONE USG / 105% | **Not as house law.** Playable later only as an org overlay with `evidence` | Whether to book a ONE card (already an org choice) | The refractometer; the 3-hour window |
| IBF second-day table | **Not.** Alphabet overlay is J3 D4 scenery | — | 08:00–10:00 event-morning cap |
| CSAC 15% / fight-day cancel | **Not.** UNKNOWN current force | — | A 15% physics cancel |
| Commission-hearing / strip ceremony | **Not** | — | The NSAC lobby |
| Hydration-testing career | **Not.** New mode (J2 §6.2) | — | Weekly USG, walking-weight licences |

**Defend scenery for second-day / USG / 15%:** FightCamp is a **manager of fighters**, not a commission physician and not an IBF supervisor. Simulating those honestly means the player is **lobbying a gate they do not own**. Wiring IBF's table as UFC-with-a-second-scale is the current kind of lie D2 was written to stop repeating. Wiring a full hydration RPG is the unplayed-mode risk (J2 §6.2).

**Defend leaving R42 playable as-is:** the player's week is real: make the contracted limit or don't; the belt follows. That is manager gameplay. It does not need GLORY's name, and it does not need a both-miss vacate because a PDF has one.

Also scenery, restated from prior packs, not reopened:

- **A tax-withholding sim.** Already scenery (J6 A6).
- **Trainer 10% / cutman 2–3% as defaults.** Already scenery (J6 A10 / J4 E4).
- **Manager-simulator / second-as-playable-mode.** Already scenery (J2 §6.2, J4 E9, J5).
- **Invented `gym_cut`.** Already scenery-as-lie (J4 E3, J5 G10).
- **PPV points, Ali Act overlay, Olympic IF careers.** Already scenery.
- **Playable WBA/WBC/IBF/WBO ladder.** Already scenery (J3 D4). An IBF second-day overlay **rides that**, it does not outrank it.
- **Rewriting R42 because GLORY vacates both-miss.** Scenery-as-lie. The GAME RULE is allowed to be smaller.

**No fifth area outranks these four.** The closest miss — “should we model ONE USG because it is the one clean hydration number?” — is a **new product** and walks into P12. Not MVP.

---

## Test assertions (contracts for a later PR — not written this pass)

Numbered **P17–P32** so they do not collide with operator calls P1–P16, J6 A1–A34, J5 G1–G34, J4 E1–E34, or J3 D1–D16 / Q1–Q13.

| ID | Assertion |
|----|-----------|
| **P17** | `championship_rules.json` still has **no** miss / allowance / both-miss / belt-scale key. R42 added none. A later PR does not add one without an operator call that reopens P13. |
| **P18** | `WeightCut.allowance_for` remains **family-keyed** (`allowance_kg.boxing` 0.0, `mma` 0.45, `kg` 0.0). It is not read from a title flag. |
| **P19** | `WeightCut.weigh_in` still computes `over_by` as `actual - limit - allowance_for(family)` (`:187` in this excerpt). |
| **P20** | `weight_classes.json` `miss.fine_fraction` remains **0.2** unless a later file adds a **tagged** overlay with `evidence` (e.g. NV `NAC 467.522`). No silent global 25 / 30 / 10. |
| **P21** | `weight_classes.json` `miss.catchweight_max_fraction` remains **0.03**. No silent global 0.05 (WA) or 1.05 (ONE). |
| **P22** | R42: champion misses, challenger makes weight, champion wins → division **vacant**; champion keeps the fight result. |
| **P23** | R42: challenger misses, champion makes weight → belt **does not move**, including when the challenger wins. |
| **P24** | R42: both miss → belt **does not move**. No test requires a GLORY/WBO/WBC vacate on that cell. |
| **P25** | R42: a winner who missed contracted weight does not bank `title_wins`; `title_fights` still counts; the bout is not flattened into “not a title bout.” |
| **P26** | No data file stores `source: "ABC Unified Rules of MMA"` (or equivalent) as the citation for R42's belt rule. Unified MMA does not contain that rule. |
| **P27** | No data file stores `NAC 467.522` as a **belt** rule. That section is a purse forfeit. |
| **P28** | No data file contains a sport-wide `rehydration_cap_pct` / `usg_limit` / `fight_day_cancel_pct` / `second_day_cap` without `evidence` pointing at **that body's or commission's** current page. |
| **P29** | No data file contains a hearing / strip-ceremony / “days to make weight again” procedure for a scale miss. |
| **P30** | Weigh-in calendar remains **day-before** as the house default (J3 **D10**). NJ `13:46-1A.3` day-of print is not silently applied as global. |
| **P31** | J2 P1–P3 still hold (federations: no purse, no signing). R40 is not reopened. J3 Areas 1–3, J4 E1–E3, J5's priority ruling, and R42's shipped rule are not reopened by any P-test. |
| **P32** | No test fixture uses a real gym's, manager's, official's, athlete's, or executive's name as data (J6 **A34** / J5 **G34** / J4 **E34**). |

---

## Source list (live verification 2026-09-07)

**Primary / official (preferred):**

- `TASK_J7.md`; `TASK_R42.md`; `R42_DIGEST.md` (shipped 2026-09-07)
- `championship_rules.json` (this workspace; R41 notes; no R42 knob)
- `WeightCut_allowance.excerpt.txt` (`allowance_for` `:69`); `WeightCut_miss.excerpt.txt` (`weigh_in` `:164`–`:218`)
- `weight_classes.json` v2 (`allowance_kg`, `miss`)
- `J3_THE_DECISION_QUEUE.md` (D10–D12, Areas 1–3, Q9 — **cited, not reopened**)
- `J5_THE_GYMS_OWN_LEDGER.md` (**priority ruling** — **cited, not reopened**)
- `J6_THE_ATHLETES_OWN_LEDGER.md` (A16 — **cited, not reopened**)
- ABC Unified Rules of MMA (amended 2026-08-05, requested implementation Nov 2027): https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf
- ABC Unified Rules index: https://www.abcboxing.com/unified-rules/
- ABC Committee Report on Unified Rules for MMA (1 lb non-title **custom**, contract or regulation): https://www.abcboxing.com/committee-report-on-unified-rules-for-mma/
- ABC Ratings Criteria (championship boxing second-day **10%**; ineligible / vacant language; min **10%** fine): https://www.abcboxing.com/abc-ratings-criteria/
- ABC Unified Boxing Rules (no 1 lb title split in the unified boxing list): https://www.abcboxing.com/unified-rules-boxing/
- Nevada NAC 467 chapter (rev. listed 2026-04-13): https://www.leg.state.nv.us/nac/NAC-467.html
- `NAC 467.522` Forfeiture for failure to make weight (**25%** to opponent; Cornell LII, amendments through R089-22A): https://www.law.cornell.edu/regulations/nevada/NAC-467-522
- `NAC 467.476` / `467.514` / `467.7956` (Cornell: **Repealed** R089-22A, 2022-12-29): https://www.law.cornell.edu/regulations/nevada/NAC-467-476
- Nevada Register R089-22 approved PDF (repeal list including 467.009, 467.476, 467.514, 467.7956): https://www.leg.state.nv.us/Register/2022Register/R089-22AP.pdf
- Wisconsin `SPS 192.43` (1 lb except title and catchweight): https://docs.legis.wisconsin.gov/code/admin_code/sps/professional_services/190/192
- Oregon `OAR 230-030-0150` (20%; 1 lb not on title bouts; misser not eligible to win the title): https://oregon.public.law/rules/oar_230-030-0150 and https://secure.sos.state.or.us/oard/view.action?ruleNumber=230-030-0150
- California `4 CCR 297` Weighing Time (within 30 hours; Westlaw through Register 2026 No. 35): https://www.law.cornell.edu/regulations/california/4-CCR-297
- California `4 CCR 298` Weights and Classes (between-class boxing allowances): https://www.law.cornell.edu/regulations/california/4-CCR-298
- California `4 CCR 299` Dehydration and Rehydration (oral only; optional USG): https://www.law.cornell.edu/regulations/california/4-CCR-299
- New Jersey `N.J.A.C. 13:46-1A.2` weight differences; `13:46-1A.3` weighing of boxers (day-of by 13:00; ≤1% day-of cut); `13:46-24B.5` MMA weighing inherits 1A.3; `13:46-5.12` failure to appear for weigh-in: https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-1A-3
- GLORY Official Rules 2026 v2 (effective 2026-03-16): https://glory.pinkyellow.network/assets/rules/glory-rules-2026-v2.pdf
- IBF Rules Governing Championship Contests (posted 2025-08-13): https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf
- IBF 2nd Day Weigh-In Guidelines (after 2021-01-19; not unification): https://www.ibf-usba-boxing.com/wp-content/uploads/2nd-Day-Weigh-In-Guidlines-Updated-1.pdf
- WBO Regulations (Jan 2024 PDF): https://www.wboboxing.com/wp-content/uploads/2024/01/WBO-Regulations-jan-2024.pdf
- WBC Rules for Championship Fights synthesized 2016: https://wbcboxing.com/downloads/WBC_RULES_FOR_CHAMPIONSHIP_FIGHTS_SYNTHESIZED-2016.pdf
- ONE Championship martial-arts page (weight classes; USG ≤1.025; 24–48 h; 105%; “a percentage”): https://www.onefc.com/martial-arts/
- PFL 2025 World Tournament Rules (effective 2025-03-01): https://pflmma.com/wtrules
- Western Australia Combat Sports Commission, Weight Classes and Missed Weight Policy (page reviewed 2025-07-01): https://www.cits.wa.gov.au/department/publications/publication/weight-classes-and-missed-weight-policy
- CSAC professional physical form (advisory: do not attempt >10% of walking weight): https://www.dca.ca.gov/csac/forms_pubs/forms/physical.pdf

**Secondary (labelled in body):**

- ABC MMA Unified Rules 2018 PDF (same (a)(b)(c) allowance language; italic = procedural recommendation): https://www.abcboxing.com/wp-content/uploads/2019/01/abc-unified-rules-MMA-08012018.pdf
- Ringside Report / other 2025–2026 MMA explainers stating Unified Rules “build in” a 1 lb non-title cushion — **CUSTOMARY journalism, not Unified MMA text**
- ESPN 2019-10-15 CSAC 15% fight-day cancel vote (5–0)
- 2026 CSAC fight-night weight tracking (UFC Sacramento coverage) — tracking ≠ 15% cancel
- CSAC public meeting 2026-03-09 (video): discussion of 20%→30% miss penalty from 2026-07-01, fight-day rechecks, USG — **meeting, not retrieved 4 CCR**
- ONE event press releases printing **25%** / **30%** purse surrenders on named cards — **event figures, not the martial-arts-page bylaw** (do not ingest athlete names as data)
- 2026 UFC non-title both-miss weigh-in report (bout proceeded catchweight) — **not a title rule**
- Sporting News / Fightomic / Fighters Weekly UFC-miss explainers — **CUSTOMARY journalism**; UFC bylaw **not retrieved**
- ISSN 2025 position stand (JISSN 22:2467909) and ACSM 2021 — **position, not a commission rule** (already J3 D12)

**Not retrieved / do not fake:**

- A **UFC primary** (athlete agreement, posted bylaw, or ufc.com rule page) that writes “missed weight cannot win the title”
- ABC Unified MMA **1 lb title/non-title** split (it is not in the 2026 PDF)
- Current **4 CCR** text of a CSAC **15%** fight-day cancel, or of a **30%** miss penalty as regulation (2026-03-09 meeting ≠ 4 CCR)
- ONE miss-weight **percentage** as house law (the page still says “a percentage”)
- IBF **champion-defence both-miss** as a numbered case (1.A.4 is vacant/elimination)
- Current **WBC 2026** championship-fight PDF (2016 synthesis and 2015 Rules & Regulations still circulate; confirm before any overlay)
- Whether Nevada `NAC 467.476` / `467.514` / `467.7956` / `467.009` are **live** or **repealed** — Cornell vs 2026-04-13 nv.us HTML **disagree**
- A **hearing procedure** that vacates a belt after a scale miss (WA's hearing is post-contest conditions on a misser)
- A **rehydration ladder** or day-of-weight **mechanic** as ABC MMA
- A published both-miss title rule for **UFC** or **ONE**
- Host-nation (Singapore / Japan / Thailand / Netherlands) contestant miss-weight statutes as house law of ONE / RIZIN / RWS / GLORY — default **off**
- IBJJF / IJF / UWW / WT weigh-in as a promotion-MMA object (J2 / J3 Issue 6)
- Any number invented to fill a silence (TASK)

---

*End of J7. Cut from the Decisions page and from the priority ruling. R42 is a GAME RULE and stays. Champion-miss-and-win vacant is backed as a body's published condition. Both-miss does-not-move is the smaller invention; GLORY, WBO, and WBC 2016 vacate, and that disagreement is the finding, not a patch. ABC Unified MMA is silent on the belt and silent on a 1 lb championship cushion. Nevada publishes a purse forfeit, not a belt. Oregon publishes ineligibility. 20% stays CUSTOMARY. Second-day, USG, and 15% are scenery. None of this outranks J5's membership object. R40 remains J2 D6. J3 Areas 1–3, J4 E1–E3, J5's priority, and R42's shipped rule are not reopened. No second weigh-in. No hearing. No invented percentage.*
