# DESIGN_WEIGHT1_R3_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ116)

Brief: research/DESIGN_WEIGHT1_R3_REVISE_KALLI.md
Sent: 2026-11-14 16:40 | collected: 2026-11-14 17:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: writing WEIGHT1 round 4 in full now, answering every point from both critics.

# WEIGHT1 round 4: the weight mechanic, design map (S459, 2026-11-14)

Part 1 of 4

Roadmap row WEIGHT1. Designer seat: Kalli. Status: ROUND 4, for two fresh critics. This round answers both round-2 critics, John (7/5/6) and Kalli (8/6/7), against the round-3 map. The bar is 6+ DEPTH and 6+ GENERAL DESIGN (S459), not 7+.

**Owner rules this map keeps, quoted**
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Round 3's rule ("Names on every line, never he or she") was the opposite. It's withdrawn. Rows, buttons, lines, tooltips and news say your boxer, the fighter, the opponent, your coach, or "your 65 kg boxer". The worked examples name a fighter only in their section header.
- **S412:** "the player runs any gym with any boxers, men or women." No fixed he or she: "Her way = heard" becomes "the fighter's way = heard". The code's plan situation text "she tires" is flagged for "the opponent tires" (CHECK, Claude).
- **S425:** the table of every menu and its wiring is section 9.
- **S459:** the bar above; ESTIMATEs marked; buildable from what the game has.
- **Pack section 7:**
  - only information the player can act on;
  - one word per concept;
  - screens only from agreed mockups;
  - classes in kg: women 57/60/65/75, men 57.5/60/70/75. Round 3's "Welterweight 65.0" is withdrawn.
  - Scouting means opponents; the facility is a gym; camp is only pre-bout preparation; money in USD.
- **Kept from round 3:** B0 SAVECAP1 before anything else; Watch tape 2 is free; the goal is judged after the bout.

**Marks**
- **CODE** is in the game today (file:line or constant).
- **REAL** is real practice, with its source.
- **GAME VALUE** is ours by design, with no real source behind it.
- **ESTIMATE** is ours, to be set by a probe.
- **NEW** must be built.
- **CHECK (John)** or **CHECK (Claude)** is open.

No probe has run on round 4. Every price below is ESTIMATE until section 10 runs.

## 0. How round 4 answers the critics

### John's To reach 10/10 (14 points)
| # | Point | Round 4 |
|---|---|---|
| 1 | Names out of every row | **Done.** Rule rewritten above; every row, label, Why line and news line rewritten. The examples carry names in headers only |
| 2 | Club show against championship | **Done (section 4).** A club show uses an AGREED WEIGHT with a 2 kg matched gap, a scale 1 hour before, and only the meal back by the bell. A championship uses the class limit, a morning scale and refuel |
| 3 | Size edge on real stats | **Done (4.4).** A flat dice edge in the inside and clinch places only, named in the Why. Power is gone |
| 4 | Tiredness share as a function | **Done (5.3).** The Energy price of carried tiredness is `stale_energy`(tiredness at the bell after the TAPER week), the CODE formula extended to every booked bout (NEW). Example rows are re-printed from it |
| 5 | The club's cash on every money line | **Done.** Every price prints what lands in the cash tin, pro purse lines included (× 25%) |
| 6 | BBBofC for pros | **Done (7).** The California forced move and the Nevada 25% are gone; the remaining pro penalties are tagged GAME VALUE |
| 7 | Nutritionist does one thing | **Done.** Asks × 0.5, $100 a week. The Old hand edge is unchanged (CODE +120 kcal a day), so the owner has nothing to OK |
| 8 | Fog holds | **Done.** No refusal prints a weight; every WIN on an offer is a band |
| 9 | Price AGGRESSIVE refuel | **Done.** Renamed FULL: −2 live Energy in round 1. The injury ×1.1 is not added: no source, and one price is enough |
| 10 | Plan table opens on need | **Done (5.5).** The coach's row plus one alternative. The full table opens only at a miss risk of 5 in 100+ or a WIN spread of 3+. The gamble row was already cut in round 3, so no favour row remains |
| 11 | Missing options | **Done.** Withdraw at any point once the forecast miss passes 1 in 3; the class at signing; the championship refuel; the no-gi class up (TO SOURCE, waits on John's B14) |
| 12 | One word list across maps | **Done (section 3).** Energy (the bell), tiredness (the week), Stamina (the ability); mood words from the pack only; favours owned by AMATEURWEEK1; promoter trust is the CODE "two ducks" rule. CLUBWEEK1 v7 changes its "tank" to Energy |
| 13 | Owner first: two classes; men's 57.5 | **Done (section 12).** Both are owner questions |
| 14 | John's sourcing (B14) | **Kept as B13.** No-gi scale rules, UK meal-prep and nutritionist prices, the EB club allowance and championship weigh-in hour |

**John's logic points not in the list:**
- **"The size edge is dead at a same-day scale."** Withdrawn. At a club show the matched gap is the size edge (4.4).
- **"Same kilos counted twice":** fixed. At a club show nothing comes back but the meal, so the trim's Energy price stands in full and the size counts the meal only. At a championship the refuel gives back part of the trim's price and part of the weight, from one rule (4.3).
- **Amateur "box them":** gone. For amateurs, the opponent over the gap is the opponent's walkover (EB 10.7.2).
- **Promoter trust, "Mood Good+", favours:** a missed Monday check counts as one duck (CODE: a promoter refuses after two). Mood words are Fired up / Steady / Flat / Low. Favours are AMATEURWEEK1's regional pool.

### Kalli's To reach 10/10 (14 points)
| # | Point | Round 4 |
|---|---|---|
| 1 | Names out | **Done**, as John 1 |
| 2 | EB amateur scale, with a re-weigh | **Done (4.2).** Same day, 1 hour before (EB 7.1.3); matched within the gap (EB 2.7.8, club practice 2 kg); one re-weigh inside the session (ESTIMATE 30 minutes, CHECK John). Amateur catchweight and ASK A KILO are cut. The favour becomes "ask the matchmaker for another name" |
| 3 | Classes in kg only | **Done** |
| 4 | One energy word | **Done.** Energy, kept because the code's word is Energy (BoutNight._energy) and the fight-night screens already show it. FATIGUE is dropped and tiredness kept |
| 5 | Size edge on Attrs | **Not done.** Adding to Strength and Durability for one bout would move the radar and the training targets. A place-limited dice edge is how size works, and the Why can name it |
| 6 | Price the gamble | **Moot.** The gamble row has been gone since round 3. No weight option spends a favour except asking for another name |
| 7 | Fold rows | **Done (5.5)** |
| 8 | A first release | **Done (section 8).** Release 1 is the amateur core; release 2 is pro and no-gi |
| 9 | Pull out before the scale | **Done (5.4).** A Home need once the forecast miss passes 1 in 3, from the offer to the scale: $300 slot, no walkover, mood 0 (the same rule as the CODE injury pull-out; one rule, not two) |
| 10 | Roster clash option | **Done (6, D7).** When two of the club's boxers share a class: "Share shows" or "One moves" |
| 11 | Cycle band | **Cut.** It changed nothing the player acts on (pack section 7) |
| 12 | Office desktop | **Done.** Row M18 |
| 13 | Loop alignment | **Done.** The bar is 6+; owners are Claude or the seat Claude names; USD only |
| 14 | Spread probes first | **Done.** P1 (spread), P2 (size edge) and P3 (gap risk) run first, after B0 |

**Kalli's missing options:** the re-weigh (done); the release cut (done); pull out (done); the coach-pick trust line (done: a hover on the coach's row, "the coach's row was best in n of your last m bouts", read from the Why history, NEW); two boxers in one class (done).

**Kalli's useless options:** amateur catchweight (cut); ASK A KILO (replaced); MATCHED as a separate option (it's the club-show default, not an option); cycle band (cut); second-day clause (release 2).

**Kalli's menus:** the CLASS card ask reads "your boxer asks to move up"; news says "your 65 kg boxer"; the Office desktop row is added.

Part 2 of 4

## 1. The idea in six lines
1. Every fighter walks above the weight they box at. How far, and what it costs, depends on the bout: a **club show** is matched by weight, a **championship** by the class limit, and a **pro** bout by a contract.
2. At a club show the decision is the **agreed weight** on the offer: give away size and box safe, or keep size and risk being outside the gap.
3. When there's weight to lose (a championship, a pro limit, or a tight agreed weight), three priced levers shape the cut. Which mornings to burn (a stat or the goal); how to answer the fighter's ask to eat (Energy, mood or cash); what runs if the Monday check reads over (Energy, room, or pull out).
4. Energy at the bell, for both corners, sets **the window**: the exchanges where the opponent tires and your boxer is still fresh enough to punish it.
5. Pace per round and the plan's "when the opponent tires" line are bought against that window, so weight, pace and the plan are one budget.
6. What runs for months (the walk, between-fights eating, the class) lives on the fighter's Body and class tab and the CLASS card.

## 2. What is built today (CODE, unchanged from round 3)
| Part | What runs | Where |
|---|---|---|
| One weight a fighter | daily kcal sum, no walking weight | Sim.gd:207-209; WeekPlan.day :241-270 |
| Sessions burn and train | MET × kg × min; gain 0.2 × intensity × headroom × coach | WeekPlan SESSIONS :31-41, INTENSITY :45-49 |
| The coach's week by phase | PEAK 2 weeks out; TAPER in the fight week, from any booked bout | WeekPhase.WEEKS :25-34, phase :43-47 |
| Diets | HOLD (+300), CUT −500 (Old hand −620) | WeekPlan ALLOWANCE, CUT_DEFICIT |
| The scale | made at limit + 0.05, the day before | BoutRules WEIGH_TOLERANCE, made_weight :171 |
| A miss | bout off, $300 slot, next offer 6 days later, no loss | Bouts.weigh :327-347 |
| Energy at the first bell | 100 − hurt − stale; the opponent always 100 | BoutNight._energy :300-306 |
| Stale | 2 a tiredness point over 50, at most 20, only after a camp | BoutRules.stale_energy :165-168 |
| Round spend, power fade | ROUND_COST 18 + punches × spend_factor; tired_penalty from round-end Energy, both corners | Combos :26-38, :272-285 |
| Your boxer tired, the opponent tiring | under 35 / under 45 (Tiring 3 exchanges in 4) | Exchanges.SHE_TIRED, OPP_TIRED, next_mode |
| Pace, round pace, round tells | Push / Steady / Save; f.round_pace; tape round_hints | PaceAim; PlanFile :113-133 |
| Plan lines | best 9, ok 3, wrong −7; undrilled × 0.8 | PlanFight.EDGE; PlanBoard.UNDRILLED |
| The fighter's asks | rate lerp(0.6, 0.2, coachability); heard +5, overruled −5 | PushBack; FighterProfile.MORALE_EVENTS |
| Mood is trust | 1.05 / 1.0 / 0.85 / 0.7 | FighterProfile.trust |
| After the bout | result morale, then the goal | BoutNight._finish :423-432 |
| Club prices | win +8 members +5 reputation; loss −1 / −2; $450 ticket cut every bout | BoutRules |
| Places in a fight | outside, long, mid, inside, clinch, ropes | Exchanges places |

The four round-3 code findings stand: Save refills past the top (B0), pace doesn't change its own round's fade, the goal's mood lands after the bout, and an amateur bout 12 days out still asks for a camp until AMATEURWEEK1 lands.

## 3. The words (one set on every screen, and in CLUBWEEK1 and AMATEURWEEK1)
| Word | Means | Never |
|---|---|---|
| Walking weight ("walks 66.8 kg") | where the body settles when nobody cuts | natural weight |
| Class ("65 kg") | the class, by its kg | Welterweight, division |
| Agreed weight ("agreed 65.5 kg, gap 2 kg") | a club show's matched weight on the offer | catchweight (amateurs) |
| The gap | the most the two boxers may differ on the scale | allowance, grace |
| The scale ("Sat 28, 4 pm") | the official weigh-in, day and hour | weigh-in check |
| Re-weigh | one more step on the scale inside the session | |
| Burn morning | a training morning swapped for Hard roadwork | cardio day |
| Trim | the last 3 days' light eating, at most 2% of the limit | water cut (amateurs) |
| The fighter's ask | the fighter asks to break the diet one weekend | cheat day, slip |
| Meal prep | the club pays for this bout's meals | |
| Refuel | eating between a morning scale and the bell | |
| Energy | fight-night fuel, 100 at a fresh first bell | tank, gas |
| Tiredness | the week's wear, 0–100 (the code's "Week tiredness") | fatigue |
| The window | exchanges where the opponent is tiring and your boxer isn't tired | |
| Stamina | the ability (Attrs.gd) | cardio, engine |

## 4. Three kinds of bout, three scales

### 4.1 Which scale applies
| Bout | Weight rule | Scale | Back by the bell | Tag |
|---|---|---|---|---|
| Amateur club show | AGREED WEIGHT on the offer; the two boxers within the gap | same day, 1 hour before | the meal only, at most +0.3 kg | EB 7.1.3 REAL; gap 2 kg REAL (Stevenage ABC, club practice); EB 2.7.8 caps it at the smaller boxer's category width |
| Amateur championship (the regional, the nationals) | the class limit | same day, morning (hour CHECK John) | refuel (4.3) | EB 7.1.3 REAL; hour TO SOURCE |
| Professional | the contract weight | the day before, about 30 hours out | water and refuel (release 2) | BBBofC 3.2.2 REAL |

The weigh-in on the day replaces today's day-before scale for amateurs: a code change, shared with AMATEURWEEK1 (B5).

### 4.2 The club show: the agreed weight (D0, on the offer)
- **On the offer:** the opponent's declared weight (on the offer, as on real club-show cards) and the gap (2 kg).
- **Fog:** the opponent's weight on the day is a range until tape is watched (amateurs can't scout before accepting, S410). The risk is printed as a band.
- **Your boxer's three answers**, set on the offer and changeable until the Monday of the fight week:

| Answer | What your boxer weighs in at | Price | Best when |
|---|---|---|---|
| **Box near the walk** (Hold) | the walk minus the coach's taper drift | the risk of being outside the gap if the opponent comes in light (band); keeps the size edge | your boxer fights inside (Slugger, Pressure fighter), the opponent's range is narrow |
| **Meet the declared weight** (the coach's: Lean) | within 1 kg of the declared weight | little size edge; rarely outside the gap | the opponent's range is wide or unknown |
| **Come in light** (Lean + a small trim) | at or under the declared weight | the trim's Energy price; gives the size to the opponent | your boxer fights at range and the bout is about Energy, not size |

- **Outside the gap at the scale:**
  1. One **re-weigh** inside the session (ESTIMATE 30 minutes, CHECK John), sweating at −2 Energy a 0.1 kg, up to 0.3 kg.
  2. If still outside, **ask the matchmaker for another name:** 1 favour from AMATEURWEEK1's regional pool. A boxer within the gap is found about 1 time in 2 (ESTIMATE).
  3. Else a **walkover loss** for the boxer outside the gap (EB 10.7.2): the CODE loss path (−12 mood, −1 member, −2 reputation, the record), and the $450 ticket cut not earned. CHECK (John): whether a club show calls the bout off instead (Stevenage says it does).
- **The opponent outside the gap:** your boxer's walkover win (+8 members, +5 reputation, CODE win path; $450 paid, NEW). No "box them" choice for amateurs.

### 4.3 Refuel at a championship (D-R, a standing answer)
| Answer | Energy back by the bell | Weight back | Price |
|---|---|---|---|
| **Light** (the coach's) | a quarter of the trim's Energy price | +0.3 kg | none |
| **Full** | half of the trim's Energy price | women +1.5%, men +2.1% of the limit (REAL, Reale 2017, championship study) | −2 live Energy in round 1 (gut weight) |

All ESTIMATE except the regain. One rule gives both the Energy back and the weight back, so no kilo is counted twice.

### 4.4 The size edge (NEW, ESTIMATE; probe P2)
- **The edge:** +1 on the exchange dice, in the **inside and clinch places only**, per kg of the scale gap past 1 kg, at most +3. Weights are read after what comes back by the bell.
- **Why it isn't an ability:** the Why names it: "Size: +1 inside (1.8 kg heavier)".
- **Where it matters:** at a club show the gap is up to 2 kg, so the edge is 0 to +1. At a championship both boxers are near one limit, so it's usually 0, unless one corner refuels Full. That's the real trade.

Part 3 of 4

## 5. The cut: levers, each priced (shown only when there's weight to lose)
The levers open when the forecast at the scale is over the target. The target is the class limit (championship), the agreed weight's line (club show), or the contract (pro). A club show boxer near the declared weight sees only D0 and the line to the scale.

### 5.1 The price of a kilo (ESTIMATE, B1)
- **Trim:** −1 Energy a 0.1 kg up to 0.5, −2 a 0.1 from 0.5 to 1.0, −3 a 0.1 past 1.0; the cap is 2% of the limit in 3 days (REAL.md 7). Lean is −250 kcal a day, about 0.03 kg a day.
- **What a point of Energy buys:** the window (section 6) and the round's power (CODE tired_penalty). As a win chance it's 0.4 in 100 a point (ESTIMATE, P10).

### 5.2 D1. Burn mornings (pick 0 to 3), from round 3
- **Source:** the coach's real PEAK week (CODE WeekPhase.WEEKS["peak"]). A picked morning becomes Hard roadwork, priced with WeekPlan.day (CODE).
- **What's offered:** only mornings that don't already burn. The fight week is the coach's taper and isn't offered.
- **The goal price** shows only on mornings that feed the goal; the rest cost their own stat.
- **Not a lookup:** the answer turns on the trim's tier, the goal, and which stat each morning feeds (worked in section 6).

### 5.3 Tiredness at the bell, as a function (answers John 4)
- **The rule:** Energy price = 2 × (tiredness at the first bell − 50), at least 0, at most 20. That's CODE stale_energy, extended from "after a camp" to every booked bout (NEW, B6).
- **Tiredness at the bell** = tiredness on Monday of the fight week + the fight week's sessions − the TAPER's rest days. The code's rest-day recovery is used as written (CHECK Claude: the per-day value).
- **What each answer adds:** Cut adds +1.5 tiredness a day (ESTIMATE), a burn morning +4 (Hard, CODE load 1.5).
- **Re-printed for three starting points** (fight-week Monday tiredness; ESTIMATE until the rest-day value is read):

| Fight-week Monday | Trust the trim | Cut 5 days | One burn morning in PEAK, then trust |
|---|---|---|---|
| 40 (fresh) | 0 | 0 | 0 |
| 55 | 0 | 0 if the taper drains 8+, else 2–4 | 0 |
| 70 (worn) | 6–10 | 14–18 | 8–12 |

So a Cut is cheap for a fresh fighter and dear for a worn one. The tiredness bar on the plan row shows which applies.

### 5.4 D2. If the fighter asks to eat (a standing answer, and meal prep)
- **The ask (NEW B7):** a weekend ask beside the weekly card, built on CODE PushBack. The fighter has a reason when a diet runs and discipline is under 50. The rate is lerp(0.6, 0.2, coachability/100) of those weekends. A fighter with discipline 50+ never asks, and that boxer's panel has no D2.
- **The three answers:**

| Answer | kg (ESTIMATE) | Mood (CODE apply_morale) | Best when |
|---|---|---|---|
| **Let the fighter eat** | +0.5 | heard, +5 | Flat near Steady (lifts trust to 1.0 for the night) and the trim has room |
| **Half a plate** | +0.2 | 0 | mood near a band edge and the trim near a tier |
| **No** (the coach's) | 0; under discipline 50 the fighter eats anyway (50 − discipline) in 100 (ESTIMATE) | overruled, −5 | mood well inside a band, trim near the cap |

- **Meal prep:** $25 a day for this bout's days (ESTIMATE, TO SOURCE B13). The card prints "−$300 from the club's cash, 12 days". **One effect: a "No" always holds.**
- **Nutritionist** (Club > People, $100 a week, one effect): asks × 0.5 for every fighter on a diet.

### 5.5 What the player sees: the coach's row, folded (answers John 10, Kalli 7)
- **The coach's row** in the one gold frame, with Energy as a stacked bar: tiredness at the bell, trim, sweat. It also shows the scale result, the miss risk, the WIN band, and the hover "the coach's row was best in n of your last m bouts" (NEW, from the Why history).
- **One alternative row** under it: the best row that differs in one lever.
- **"All plans"** opens the full table. It opens itself only when the miss risk is 5 in 100+ or the WIN spread is 3+ (P1).

### 5.6 D3. If the Monday check reads over (Monday of the fight week; a standing answer)
| Answer | Price | Best when |
|---|---|---|
| **Trust the trim** (the coach's) | the trim's Energy price; less room under the cap | the trim stays under 1.0 |
| **Cut 5 days** | −0.16 kg (CODE CUT_DEFICIT); its price is the tiredness function in 5.3 | the trim passes 1.0 and the fighter is fresh |
| **Pull out now** | "−$300 from the club (empty slot); the $450 ticket cut not earned"; no loss; next offer 6 days later (CODE). At a championship it ends the run (CODE) | the forecast trim is near the cap |

**Miss chance by room under the cap** (ESTIMATE, B1): 1 in 100 at 0.4 kg, 4 at 0.27, 8 at 0.2, 20 at 0.1.

**Pull out before the scale (answers Kalli 9, John 11):** from the offer to the scale, whenever the forecast miss passes 1 in 3, a Home need offers **Pull out** with the same prices. Mood 0, as the CODE injury pull-out, so it's one rule.

### 5.7 D4. The pace of each round, and D5. Write it (from round 3, reworded)
- **D4.** Push / Steady / Save for R1, R2 and R3, written to f.round_pace (CODE), with the tape's round tell when found. Every pace card prints the window and how many exchanges your boxer is tired. Win changes per pace wait for P16, after B0.
- **D5. Write it:** "When the opponent tires → 1-2-3", replacing the weakest line when the plan is full. One unit, edge × exchanges it fires:
  - the window × 3/4 (CODE OPP_TIRED) × 9 (best) × 0.8 (undrilled under 30), against the replaced line's fires × its edge.
  - Pad nights on the 1-2-3 (the **Week** tab) move it.

### 5.8 Past the cap (Home need, stops the clock)
When the forecast trim passes the cap: **Pull out** (5.6), or **Go to the scale** (up to 0.3 kg sweated at −2 Energy a 0.1, one re-weigh). Past that, the club-show or championship rule in 4.2: a walkover loss through the CODE loss path. No walkover can come without this need shown first, unless the ask came in the last 3 days (B5 test).

## 6. The class, the walk, and the class at signing (D7, Body and class tab and the CLASS card)
- **The walk** drifts back when nobody cuts: half in week 1, the rest over 3 weeks (B3; REAL 3.5–4.8% a week of what was lost). Between fights the coach runs Lean while over the limit and able to take offers, and Hold when hurt or at the limit, with its reason shown.
- **The CLASS card** opens when two classes are in reach: no more than 9.5% under the walk, 4 kg over. Its columns are DOWN / STAY / UP, priced in cut per camp, Energy, size, ladder place (CODE: a move leaves the regional table), offers in the last 8 weeks, and team-mates in the class. Its options:
  - **Test the weight** (championships and pros only, because club shows are matched anyway).
  - **Move now** or **Move after the next bout.**
  - The fighter's ask, "your boxer asks to move up": **Hear** (+5) or **Overrule** (−5, CODE).
- **Two of the club's boxers in one class (answers Kalli 10):**
  - **Share shows:** the one waiting longer gets the next offer.
  - **One moves:** opens DOWN or UP for one of them.
- **The class at signing (answers John 11):** the Interview and Trial card shows the walk and the classes in reach, and the player picks the class there (NEW).
- **No-gi:** enter a bracket one class up, as an option on the open card. TO SOURCE (IBJJF/ADCC rules, B13); release 2.

## 7. The professional (release 2)
- **Scale:** the day before, about 30 hours out (BBBofC 3.2.2 REAL).
- **Water:** the last day's water, 0 to 3%, buys size at an Energy price (GAME VALUE).
- **Refuel:** Light or Full, as 4.3 (Full −2 in round 1).
- **Catchweight +1 / +2 kg** (GAME VALUE): the other side asks 10% / 15% of your boxer's purse. The row prints the club's cash: "Catchweight +1: −$95 to the club (10% of a $3,800 purse × your 25%)".
- **The opponent misses** (GAME VALUE): **Box** (the opponent pays 25% of their purse to your boxer: "+$x to the club at your 25%") or **Refuse** (no bout, no slot fee).
- **Repeat misses:** after 2 misses in 12 months the promoter offers only the class up (GAME VALUE, replacing the California rule).
- **Promoter trust:** a missed Monday check counts as one duck, and two ducks mean the promoter refuses (CODE).
- **A pro camp:** its stale Energy (CODE) prices every burn morning in tiredness too.

Part 4 of 4

## 8. Worked examples (names in headers only)

### 8.1 Example: Samira Khan (Data.gd:210-213), London regional, 65 kg, 12 days out
- **The boxer:** 65.9 kg, walks 66.8 (ESTIMATE), discipline 34, coachability 52, heart 70, mood 54 Steady, goal Defence 50.8 (example), Week tiredness 45 on the fight-week Monday (ESTIMATE). Coach rating 58. The scale is on the day, in the morning; your boxer's refuel is Light.
- **The coach's row:** Lean −0.36, trim 0.59, price 6.8. Energy at the scale 93; Light refuel +1.7, so **95 at the bell**. Tiredness at the bell under 50, so 0.
- **D1:**
  - Tue and Thu feed the goal (Defence 50.86 drops to 50.64 / 50.72: missed, −19.9 mood after the bout).
  - Sat costs Technique 0.12 and buys +1 Energy. The player burns Sat: trim 0.53, **96 at the bell.**
- **D2:** the ask comes about 2 weekends in 5. "No" would put your boxer at 49.6, Flat, 2 times in 5. The player sets **Half a plate** (if asked, trim 0.73, **92 at the bell**, mood holds). No meal prep: it would buy about 0.8 Energy for $300.
- **D3:** Trust the trim. The fold opens on the alternative row only: the WIN spread is 2 and the miss risk is 2 in 100.
- **Full refuel instead?** +3.4 at the bell, but −2 live in round 1, and +1.4 kg back gives a size edge of 0 to +1 against an opponent on Light. The alternative row shows it; P20 decides.

**Opponent (the drawn opponent, NEW B6):** 86 at the bell. The window under Steady is 5.
**D5:** 5 × 3/4 × 9 × 0.8 = 27, against 21 for the pressing line. The player writes it.

| Plan | Energy at the bell, clean / if asked | Mood on the night if asked | Window | WIN band (ESTIMATE) | Costs |
|---|---|---|---|---|---|
| Coach's | 95 / 95 (84 if eats anyway) | Flat 2 in 5 | 5 (3) | 47–61 | Flat risk |
| Yours: Sat burned, Half a plate | 96 / 92 | Steady | 5 / 4 | 48–62 | Technique −0.12 |
| Sat burned, Let eat, meal prep | 96 / 86 | Steady | 5 / 3 | 48–62 | −$300 from the club |
| All three burned | 98 / 94 | Steady | 5 | 49–63 | goal missed (−19.9 after), Technique −0.12 |

The middles differ by 1–2, inside the band. The screen says "too close to call", and the choice rests on the tails: Flat on the night, the goal, the cash.

### 8.2 Example: the same boxer at a club show
- **The offer:** opponent declared 65.0 kg, gap 2 kg, range 64.5–66.5 until tape.
- **Box near the walk:** about 66.3 at the scale; outside the gap if the opponent comes in under 64.3, so 5–12 in 100 (band). Gap about 1.3 kg after the meal, so +0 to +1 inside: worth it for a Slugger.
- **Meet the declared weight** (the coach's): about 65.5; outside 1 in 100; no edge; Energy 100.
- **Come in light:** 65.0 at a trim of 0.5, so Energy 95; gives the size away. Rarely right for this style.
- **After tape 2** the range narrows to ±0.5 and the band with it.

### 8.3 Example: Kira Mensah (57 kg, discipline 64)
No ask (discipline 50+), so there's no D2 row. The trim is 0.94, in the −2 tier near −3, so all three mornings are worth 3.4 Energy. Fresh on the fight-week Monday, so a Cut costs 0. The best set differs from 8.1.

## 9. Every menu it appears on, and what each is wired to (S425)
| # | Menu | What it shows | Wired to today (CODE) | New wiring |
|---|---|---|---|---|
| M1 | Fighter > Fight prep > THE WEIGHT | D0 or the cut levers by bout kind; the coach's row and one alternative; All plans on need; Energy round by round with pace per round, both corners' lines and the window; the other corner (tape 2 link, Write it) | FightPrep.gd:34-74; Sim.weigh_forecast; PlanFile.set_pace; TapeRoom | WeightRules.*; EnergyCurve; PlanLines.add |
| M2 | Fighter > Body and class | walk and drift, between-fights eating with its reason, ask rate, last 6 scales, CLASS card | FighterPage.gd:29-30 | TAB_ORDER; BodyClass |
| M3 | Fighter > **Week** (renamed) | a burned morning reads "Hard roadwork, for the weight" | WeekBoard.gd:402-416 | f.week_edits |
| M4 | Fights > bout offer | club show: declared weight, gap, the three D0 answers, outside-gap band; championship/pro: the scale's day and hour; every WIN a band | VersusPanel.gd:159-196; BoutPage.gd:44-56 | WeightRules.agreed_rows / coach_plan |
| M5 | Home > needs | Pull out (forecast miss past 1 in 3); past the cap | Needs.gd:75-76 | WeighDay.pull_out, past_cap |
| M6 | Weigh-in modal | the hour, the reading, re-weigh, another name (1 favour), made / sweated / walkover | WeighIn.gd:13-28; Bouts.weigh | WeighDay.weigh, reweigh |
| M7 | Tale of the tape + 3D intro | weights at the scale and at the bell | TapeRows.gd:64-80; TaleOfTape.gd:24-29 | OppWeight (the two formulas go) |
| M8 | Fight night | first card "Energy 92: trim −7, refuel +2" for both corners; round pace; "Size: +1 inside" | BoutNight.gd:306 | WeightRules.energy_sum; size edge in Exchanges |
| M9 | Result > the Why | "Weight: Energy 92 at the bell; the window 4; your tires line fired 3 times; size +1 inside" | WhyCard.gd | WeightRules.why_line |
| M10 | Week review | the ask and its answer, the Monday answer that ran, planned vs actual | WeekReview.gd:413-414; WeekActual.gd:82-91 | WeighDay.check; EatAsk.log |
| M11 | Home fighter row, Coming up | "0.83 kg to lose · scale Sat 9 am" | HomeRows.gd:195-201; Fixtures.gd:19 | WeighDay.hour |
| M12 | Fighters > Roster | weight against the target; amber when the Monday answer ran, red past the cap | RosterCards.gd:213-220 | f.plan state |
| M13 | Club > People | nutritionist (asks × 0.5, $100) | StaffRoles.gd:7-21 | + "nutritionist" |
| M14 | Club > Money | "Meal prep, your 65 kg boxer, 12 days, −$300"; pro purse lines at 25% | c.pay | WeightRules.buy_meal_prep |
| M15 | World > News | "Your 65 kg boxer asked to eat: half a plate"; made / re-weighed / walkover | c.add_news (Bouts.gd:339) | WeighDay, EatAsk |
| M16 | Playbook > Game plan | round pace; the Write it line "from the weight plan" and what it replaced | GamePlanRows.gd:20-32 | PlanLines.add(source, replaces) |
| M17 | Interview / Trial | the walk, the classes in reach, the class pick | Interview modal | Classes.in_reach |
| M18 | Office desktop (S451) | next four weeks: scale day and hour; the Monday check as a need | Office Desktop | WeighDay.hour, check |
| M19 | No-gi athlete page | scale at the mat; class up (release 2) | NoGi.gd:74 | TO SOURCE |

## 10. Build, in two releases (each file under 500 lines, test red first; owners Claude or the seat Claude names; nothing builds before fresh critics score 6+ / 6+)
**Release 1, the amateur core**

| # | Task | Test red first |
|---|---|---|
| B0 | SAVECAP1: Save +1 an exchange, the next round never above this round's start, live Energy ≤ 100 | Save R1 from 90 reads 111 live today |
| B1 | WEIGHTRULES1: trim price, cap, burn-morning prices, ask rows, Monday rows, miss by room, Energy sum, window | the 8.1 numbers |
| B2 | OPPWEIGHT1: opponent walk, declared weight, fog by tape | one weight on tape and intro |
| B3 | WALKWEIGHT1: walk in the save, drift | Hold drifts back |
| B4 | DIETS1: Lean; Cut as a Monday answer | Lean −0.03 kg a day |
| B5 | WEIGHDAY1: amateurs on the day, the gap, re-weigh, another name, walkover through the loss path, pull out, past cap (with AMATEURWEEK1) | an amateur outside the gap after a re-weigh writes a loss |
| B6 | NIGHTENERGY1: Energy sum for both corners; stale_energy for every booked bout; size edge inside and clinch; the Why line | trim 1.0 starts at 85; size +1 inside at 1.8 kg |
| B7 | EATASK1: ask, three answers, eats anyway, meal prep, nutritionist | discipline 34 asks 35–43 in 100 weekends |
| B8 | CLASSES1: in reach, signing pick, roster clash | two boxers in one class get both options |
| B9 | WEIGHTPANEL1 (M1) | panel = WeightRules |
| B10 | BODYCLASS1 (M2) | tab shows |
| B11 | WEIGHTSHOW1 (M3–M18) | each menu shows its line |
| B12 | WEIGHTGOLDEN1: club show near the walk → re-weigh → made; regional → Sat burned → half a plate → Light refuel → the window in the Why; second run: outside the gap → another name fails → walkover loss | red until B0–B11 |
| B13 | John: no-gi scale, meal-prep and nutritionist prices, EB club gap, championship weigh-in hour, club-show call-off | – |

**Release 2:** pro scale, water, refuel for pros, catchweight, the opponent's miss, repeat misses, short notice, second-day clause, no-gi class up.

## 11. Probes (after B0; headless; P1–P3 first)
- **P1:** the spread between the best and worst sensible plans is 3+ in 100 in 60 of 100 bouts, or the screen leads with the tails.
- **P2:** the size edge at 1.8 kg is worth 1–3 in 100 for an inside style and under 1 for an out-boxer.
- **P3:** "Box near the walk" is outside the gap in 3–12 in 100 club shows, and each D0 answer is best in 20–60 in 100.
- **P10:** the win chance per point of start Energy (the 0.4).
- **P14:** across four starters × three cash levels × goal due or not, no D1 set and no D2 answer is best in more than 60 in 100.
- **P16:** Save R1 + the worst plan beats Steady + the best plan in under 1 bout in 3.
- **P17:** Flat on the night against Steady (the −2).
- **P18:** the window's forecast against the tires line's real fires.
- **P20:** Light against Full refuel: each best in 30–70 in 100 championship bouts.

## 12. Owner questions (scope only)
1. Add women's 70 kg and men's 65 kg (World Boxing classes)? Without them, UP and DOWN are thin for a 65 kg woman.
2. The men's 57.5 kg class isn't a World Boxing class (the nearest is 55). Keep it or change it?

**CHECK (John):** the championship weigh-in hour; the re-weigh window; whether a club show calls the bout off or gives a walkover.
**CHECK (Claude):** the TAPER rest-day recovery value; the plan text "she tires".

## 13. Risks
- B0 changes every fight number, so the 59 / 45 / 41 balance must be re-measured.
- The plan middles differ by 1–2 in 100. P1 decides whether the screen leads with WIN or with the tails.
- Opponent Energy under 100 (B6) is what makes the window real; without it the window is mostly 0–2.
- The club-show walkover may be a call-off in real practice. If John's CHECK says so, M6's last line changes to "bout off, $300 to the club over the gap".

## 14. Self-score
**DEPTH 7, GENERAL DESIGN 7, PLAY 6.**

**To reach 10/10:**
1. Run P1–P3 and print the measured spread and gap risk.
2. John's B13 sourcing, especially the call-off rule.
3. Owner questions 1 and 2.
4. Draw M1 at 1920×1080 in two states:
   - **Club show:** D0's three magnets and the line to the scale.
   - **Regional:** the coach's row in gold, one alternative, the Energy curve with the window, the other corner.
5. CLUBWEEK1 v7 and AMATEURWEEK1 adopt this map's scale, gap and Energy word.
