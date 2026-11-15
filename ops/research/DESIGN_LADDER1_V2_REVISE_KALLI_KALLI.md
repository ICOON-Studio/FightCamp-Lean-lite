# DESIGN_LADDER1_V2_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ169)

Brief: research/DESIGN_LADDER1_V2_REVISE_KALLI.md
Sent: 2026-11-15 10:10 | collected: 2026-11-15 10:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing LADDER1 v2 in full now. It moves to opponent-based (Elo) reputation, seeds and drains the top of the ladder, merges the two refusal words into one, and answers every point from John and Dola.

# LADDER1 v2: the season ladder, with reputation as the currency (S459, S475, S477, 2026-11-15)

Part 1 of 4

This is a full map. It replaces v1 (seat SQ153), and nothing outside this page stands.

**What decides this version:**
- John's critic (SQ161): depth 5, general design 5, play 6. Fails.
- Dola's critic (SQ162): depth 7, general design 8, play 7. Passes.

v2 takes John's core fix:
- Reputation is paid by **who you beat**, compared with what the ladder expected, not by the shown chance.
- The top of the ladder is **seeded and drained**.
- The two refusal words become one.

**Not opened this pass:** `ops/research/CRITIC_ACCESS.md`, the Miro board, the mockups, John's full research file and the owner's S475 sparring note. The owner's computer is offline. This map is checked against the critic pack, Claude's S477 code facts, John's research summary and the two critics.

**Owner rules kept, quoted**
- **S475:** the ladder "must reach 9/10: see the ladder, find an opponent, book", with REPUTATION as the currency, not fixed win counts.
- **S428 and S425:** amateur to the first pro fight; ONE regional ladder first; every fight shows the rank earned; wired and shown on the correct menus. The living world comes after the fight week is built and played.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Names in ladder rows go to the owner (owner question 5).
- **S412:** any gym, any boxers, men or women. No fixed he or she.
- **Pack 4.5, agreed:** "a 'no' is a closed panel or an absent answer with its reason, never a random refusal".
- **Pack 7:**
  - only actionable information;
  - one word per concept;
  - nothing opens by itself;
  - screens only from agreed mockups, so the page waits for the owner's OK (owner question 2).
- **Pack 1:** "the better-trained fighter usually wins; a good plan turns close fights". The currency must reward both (1.1).
- Classes in kg: women 57/60/65/75, men 57.5/60/70/75. The women's 70 kg class (K_WOMEN70) gets its own ladder when it lands. Females never fight males: one ladder per sex and class.
- "Gym" is the facility. Amateurs have a fight week, not a camp.

**Marks**
- **REAL:** a real rule or source, as John reported it.
- **CODE:** in the code today (S477).
- **DERIVED:** worked from this map's formulas.
- **GAME VALUE:** a fixed design number, not tuned.
- **ESTIMATE:** ours, gated by the probes in 6. Every reputation number is ESTIMATE.
- **NEW:** a rule this map adds. **CHECK:** someone must confirm. **v2:** later.

**One word per concept**
- **Reputation** (0–100, never below 0): a boxer's own currency.
- **Standing:** the gym's reputation (CODE `Career`), renamed (owner question 1).
- **Ladder:** the regional table for one sex and one class (CODE `Region.gd`), sorted by reputation. **Place** is a position on it.
- **Ask:** your boxer asks for a named opponent. **Offer:** a bout that comes to you (CODE). **Challenge:** an offer from a ladder boxer below yours.
- **Chance:** the win chance shown at booking (CODE band). **Expected:** what the ladder expects from the two reputations (1.1). The two are kept apart on purpose.

## 0. Every critic point answered

### 0.1 John (SQ161): To reach 10/10
| # | John's point | v2 |
|---|---|---|
| 1 | Pay by opponent (Elo), not by odds; drop the anti-grind table and the scalp; chance shown for information | **Done (1.1).** Elo with a width of 25, as John wrote it. The win and loss sizes are 16, not 12, so a climb fits the season (ESTIMATE). The anti-grind table, the places-below rules and the scalp are gone. Chance stays on screen. Probes 1, 2 and 9 re-run (6) |
| 2 | Seed and drain the top | **Done (1.3).** Rivals are seeded from their record, so the top 5 sit about 40–65. A rival at 55+ for 8 weeks turns pro and leaves. This is a counted rule, not a roll: the row shows "Pro talk: 3 weeks". A new rival enters each quarter |
| 3 | Merge the two gates into NOT ENOUGH IN IT at 10 + reputation ÷ 5 | **Done (3).** Reach in places is dropped |
| 4 | Make defending real: passing costs, accepting pays Elo | **Done (2.2)**, with a flat −2 for a pass instead of half the loss. Half the loss (−4 to −6) made accepting always right, which is no choice either. Now pass and accept each win in a band of cases (probe 11) |
| 5 | Fix the clock; mark RESTING NEW, or let asks through after 30 days | **Done (1.2).** A booked bout, a suspension and the 8-week rest all stop the clock. Asks open after the 30-day suspension, with the earliest date 8 weeks after the stoppage. RESTING is marked NEW: it mirrors the code's offer rule |
| 6 | Leave pros alone | **Done (2.5).** Starting pro fans stay at today's count (CHECK 4). Reputation shows only on the Pro offer's ticket line (CHECK 5) |
| 7 | Small fixes | **All done.** The split cell is gone with the new table, and majority wins are in it. Reputation floors at 0, and the seed takes the larger of 0 and its result. The draw is the Elo draw (16 × (0.5 − expected)), with no win weight. The short-notice +2 is cut. There's a clubmate rule. Pass lines 1 and 2 are rewritten as given, and the bots write plans. "Tickets she sells" is CHECK 6 for Claude: it's code text and I don't edit code |
| 8 | Rematch, coach's pick, rival file on the card | **All three done (4.3)** |
| 9 | Ask the owner the names question with the drawn page | **Owner question 5** |
| 10 | Run BASE0 and the probes, then draw | **Not done here:** I design and don't run code. They're first in the build order (7), and the page is drawn in the next board session |

### 0.2 John's missing options
| Option | v2 |
|---|---|
| Rematch | Done: an ask on a boxer who beat yours, at most twice a season against one opponent |
| The opponent's file on the card | Done: WHAT WE KNOW, from the rival file |
| The coach's pick | Done: a star on one YES row, with its reason |
| Clubmate rule | Done: never offered, never asked, word CLUBMATE |
| Stay amateur at 55 | Done (2.5): "Stay amateur: keep climbing; the offer returns at reputation 65" |

### 0.3 Dola (SQ162): To reach 10/10
| # | Dola's point | v2 |
|---|---|---|
| 1 | Run probes, freeze numbers; answer the owner questions | **Not done here** (I don't run code), but first in the build order. The owner questions are 1–5 in 8. Her "SAFE needs 50+ bouts" line is replaced by the Elo grind line (6, line 9) |
| 2a | A harsher inactivity rule | **Done (1.2):** −1 every 2 free weeks after 8, counted only on free weeks. A separate place drop isn't needed, because places follow reputation |
| 2b | Show the gap as reputation and wins | **Done (3):** "Needs 6 more: about one win above you" |
| 2c | One unlock per band (tournaments at 30, eliminators at 45) | **Not done:** neither exists, and eliminators are out of scope (S428). The bands are milestones on the week review and in Records, and "1st, nobody above" has its own line (4.3) |
| 2d | Defending matters: swap places, +2 defence bonus | **Done through Elo (2.2):** a win changes both boxers' reputation, so places swap by themselves. A passed challenge costs −2 |
| 3a | Integrate the S475 sparring note | **Not done:** the note is on the offline computer. The stub stays and is marked CHECK (2.5) |
| 3b | One-line rival tags | **Done (4.3):** the row keeps the style word (CODE). The card's WHAT WE KNOW lists found habits ("slow starter"). Hidden ones stay hidden until tape finds them (pack 4.6) |
| 3c | Decline memory | **Done (2.2):** a challenger passed twice sends no challenge for 8 weeks |

### 0.4 Dola's other gaps and missing options
| Point | v2 |
|---|---|
| Inactivity too soft | 2a above |
| The same rival forever | At most twice a season against one opponent; a third gives the word TWICE THIS SEASON |
| How far the gap is | 2b above |
| Table size | CHECK 1 |
| The ladder feels optional | The coach's star makes the best ask one click. Offers still arrive (CODE), so a quiet player isn't forced |
| No mid-season rewards | 2c above |
| No rival personality | 3b above. Fuller rivalries come with the living world (S428) |
| Drop a class or pause | v2: whether a boxer can change class in code is NOT ESTABLISHED (CHECK 7) |
| Filter by style or stance | Every column sorts (style and stance included). That's one control, not more filters |
| Who fights on which dates | The card's date line and the BOOKED word show the opponent's dates |
| A target opponent | Done: **Pin as target** on the card, shown on Overview's NEXT STEP |
| Mobile layout | Not done: PC only (pack 1) |

Part 2 of 4

## 1. Reputation: how it's earned

### 1.1 Paid by who you beat (NEW, the Elo method John cites; all numbers ESTIMATE)

$$ \text{expected} = \frac{1}{1 + 10^{(\text{opp} - \text{you})/25}} $$

- **Win:** 16 × (1 − expected) × the win weight.
- **Points loss:** −16 × expected. **Stopped:** a further −2.
- **Draw:** 16 × (0.5 − expected), with no win weight.
- **Rounding:** to the nearest whole number. **Floor:** 0.

**Win weights.** These are John's BoxRec ratios (REAL), rescaled so a unanimous win is 1 (GAME VALUE):

| Win | Weight |
|---|---|
| Stoppage | 1.15 |
| Unanimous | 1.0 |
| Majority | 0.65 |
| Split | 0.5 |

**What one bout pays** (DERIVED from the formula). "Gap" is the opponent's reputation minus yours:

| Gap | Expected | Stoppage win | Unanimous | Majority | Split | Draw | Points loss | Stopped |
|---|---|---|---|---|---|---|---|---|
| −20 | 86% | +3 | +2 | +1 | +1 | −6 | −14 | −16 |
| −10 | 72% | +5 | +5 | +3 | +2 | −4 | −11 | −13 |
| 0 | 50% | +9 | +8 | +5 | +4 | 0 | −8 | −10 |
| +10 | 28% | +13 | +11 | +7 | +6 | +4 | −5 | −7 |
| +20 | 14% | +16 | +14 | +9 | +7 | +6 | −2 | −4 |

**Why this beats v1 (DERIVED).** At weight 1, a bout's average gain is

$$ 16 \times (\text{real chance} - \text{expected}) $$

So reputation grows only where your boxer is **better than the ladder thinks**. That has three effects:
- **Training pays everywhere.** It lifts the real chance against every opponent, while expected moves only as reputation moves. This answers John's "reputation taxes training".
- **The plan pays.** The shown chance excludes the plan (CHECK 2), so a plan that beats an opponent's style is value the player can see and the ladder can't.
- **The grind dies by arithmetic.** At a gap of −40, expected is 97.5%, so even a sure win pays about +0.4, and one loss costs 16. No anti-grind table is needed.

**The strategy table, redone** (DERIVED; "real" is a probe figure, not a promise):

| Road | Real chance vs expected | Average per bout | The catch |
|---|---|---|---|
| Far below (gap −40) | 99% vs 97.5% | +0.2 | One loss costs 16; stalls |
| Safe below (gap −20) | 90% vs 86% | +0.6 | Slow; a loss costs 14 |
| Even, with a training edge | 60% vs 50% | +1.6 | Steady |
| Above, plan beats their style (gap +20) | 35% vs 14% | +3.4 | Stoppage risk; needs the plan and the tape |
| Sitting free 8+ weeks | — | −1 every 2 weeks | Falls |

The best road is where the edge is largest, and finding it is the scouting and Playbook game. That's the depth.

### 1.2 The clock (NEW)
- A week is **free** when the boxer has no booked bout, isn't suspended, isn't inside the 8-week rest after a stoppage (CODE `STOP_REST_WEEKS`), and isn't injured (CODE).
- After 8 free weeks in a row: −1 reputation every 2 free weeks. Booking a bout resets the count.
- **RESTING (NEW):** asks open once the 30-day suspension ends (CODE). The earliest date offered is 8 weeks after the stoppage, the same as the code's rule for offers. The Ask button reads "Ask: from 12 Apr".

### 1.3 Seeding, draining and entry (NEW, ESTIMATE)
- **Seed for rivals:** the larger of 0 and (8 + 4 × net wins + 1 × bouts), capped at 65.

  | Record | Seed |
  |---|---|
  | 8-2 | 42 |
  | 5-2 | 23 |
  | 16-4 | capped at 65 |

  Probe 8 checks that the top 5 land at about 40–65.
- **Seed for your gym's boxers:** walk-ins start at 0. Signed prospects use the same formula, capped at 30 (a signing doesn't skip the road).
- **Rivals move by the same formula** when they box each other at shows (CODE results). The ladder lives without your boxer in it.
- **Drain:** a rival who holds 55+ for 8 weeks turns pro and leaves. The countdown is counted, not rolled, and the row shows **Pro talk: n weeks**. A rival with no bout for 52 weeks also leaves.
- **Entry:** on the first Monday of each quarter, one new rival enters each ladder from the opponent pool (CODE rows), at their seed.
- **1st place never stalls:** the top keeps being refilled by seeding, and entry and drain keep it moving (probe 8).

### 1.4 One-offs (ESTIMATE)
| Result | Reputation |
|---|---|
| Regional stage won | +5 |
| National title | +10 |
| Headline win at a hosted show | +3 |

The short-notice +2 is cut.

## 2. Answers and offers

### 2.1 The ask (CODE `AskAnswer`, made deterministic)
An ask gets **YES** only when every row of the refusal table (3) passes. Otherwise it gets the word and its reason. Nothing is rolled.

A YES offers the date printed on the button: the opponent's first free show date that's at least 2 weeks ahead (CODE `CAMP_WEEKS` 2).

### 2.2 Challenges and defending (NEW)
- When your boxer is free, a ladder boxer 1–15 below may send a **challenge** through the normal offer list, at most one every 4 weeks.
- **Accept:** the bout is booked and pays by 1.1.
- **Pass:** −2 reputation, with the reason shown on the offer: "Passing costs 2".
- **Memory:** a challenger passed twice sends no challenge for 8 weeks. The offer row says so: "No more challenges from this boxer until 3 May".

Worked case at a gap of −10, where accepting pays +5 or costs −11 (DERIVED):

| Real chance | Accepting averages | Better choice |
|---|---|---|
| 80% | +1.8 | Accept |
| 55% | −2.2 | Pass (−2), unless a weight cut or fight week already blocks it |

### 2.3 Clubmates (NEW)
Two boxers from one gym are never offered against each other and never asked. The word is **CLUBMATE**.

### 2.4 The rematch (NEW)
- After a loss, the card on the boxer who won offers **Ask for a rematch**.
- One opponent at most twice a season. A third ask gives **TWICE THIS SEASON** (opens 1 Jan, CHECK 3).
- A rematch pays by 1.1, the same as any bout.

### 2.5 Pros, and staying amateur
- **Pro offer** at 55 (CODE `ProGate`, which replaces the win count). The modal's buttons:
  - **Turn pro:** starting pro fans stay at today's count (CHECK 4). Reputation appears only on the ticket line: "Ticket draw: Contender" (CHECK 5).
  - **Stay amateur:** "Stay amateur: keep climbing; the offer returns at reputation 65". The regional stage (+5) and the national title (+10) remain.
- **Sparring (S475):** the owner's note wasn't readable this pass (CHECK 8). The stub: WHAT WE KNOW names the opponent's stance and style, and the sparring screen already lists partners by stance (CODE). Nothing more is drawn until the note is read.

Part 3 of 4

## 3. The refusal table: every "no" has a word and a way to a yes

The gap line is 10 + your reputation ÷ 5, rounded down:

| Your reputation | The opponent may be at most this far above |
|---|---|
| 0 | 10 |
| 30 | 16 |
| 55 | 21 |

| Word | When | Line under it | To get a yes |
|---|---|---|---|
| **NOT ENOUGH IN IT** | Opponent above your gap line | "Needs 6 more: about one win above you" | Win; or host a show (owner question 3: a hosted show headliner may ask up to 15 beyond the line) |
| **BOOKED** | Opponent has a bout before the earliest date | "Booked until 22 Mar" | Wait. The date shows |
| **RESTING** (NEW) | Inside the 8-week rest after a stoppage, either boxer | "From 12 Apr" | Wait |
| **TWICE THIS SEASON** | Third ask of one opponent | "Opens 1 Jan" | Wait |
| **CLUBMATE** | Same gym | "Clubmates don't box each other" | None |
| **WRONG CLASS** | Over the limit at the weigh-in date | "Needs 2.1 kg off by Fri" | Fight week, Train through (CLUBWEEK1) |
| **CAP REACHED** | Season bout cap (CODE 18) | "Cap: 18 of 18" | Next season |

Each word is a closed panel with its reason, never a random refusal (pack 4.5). The table replaces v1's OUT OF REACH and its places rule. The gap line shows the value as reputation and as about how many wins: one win ≈ the unanimous win at a gap of 0 (+8).

## 4. The page: LADDER (screen waits for owner question 2)

### 4.1 Where it sits
The **LADDER** tab sits inside the fighter area of ShellChrome, beside Overview and Training (CODE tabs). It opens only when clicked (pack 7). Every column sorts.

### 4.2 The table (one row per boxer in that sex and class)
- **Columns:**
  - place;
  - name cell (owner question 5);
  - club;
  - record;
  - stance;
  - style word;
  - reputation number with its band word (owner question 4);
  - **Win / Loss** (the 1.1 values against your boxer: "+11 / −5");
  - **Chance** (the CODE band, or "Unknown" without tape);
  - the answer word.
- **Your boxer's row:** slate highlight. **Pro talk:** a short tag on the row.
- **The coach's star:** a star on one YES row only. It goes on the largest of chance minus expected among YES rows, using the shown chance. Hover reads "Best value: 60% chance, the ladder expects 40%".
- **Gold:** the selected row's Ask button only (kit: gold on one thing per frame).

**Bands**
| Reputation | Band |
|---|---|
| 0–14 | Unknown |
| 15–29 | Known locally |
| 30–44 | Rated |
| 45–54 | Contender |
| 55+ | Pro-ready |

Each band reached is a line on the week review and in Records. It unlocks nothing (0.3, 2c).

### 4.3 The card (on row click)
- Header: the opponent's name and portrait (S448: the name only here).
- **WIN / LOSS:** each outcome with its value. Hover breaks it down: "Expected 28%, win weight 1.0, 16 × 0.72 = +11".
- **WHAT WE KNOW:** found habits from the rival file (CODE), e.g. "slow starter, drops the right after the jab". Without tape: "No tape yet". Style and stance always show.
- **Dates:** the opponent's booked dates and first free date.
- **Buttons:**
  - **Ask: 29 Mar** (gold);
  - **Ask for a rematch** (only after a loss);
  - **Pin as target**: Overview's NEXT STEP then reads "Target: 3rd place, free from 28 Mar", and only one boxer can be pinned.
- **1st, nobody above:** "Top of the ladder. New entry 1 Apr; regional stage +5."

### 4.4 Where reputation shows elsewhere (one word: reputation)
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter Overview | Number and band, NEXT STEP target, clock line "Free 9 weeks: −1 every 2" | `RepLedger`, `Ladder.pin` |
| LADDER tab | Table and card (4.2–4.3) | `Ladder`, `RepRules`, `AskAnswer` |
| Offers list | Win / Loss on each offer, challenge rows with "Passing costs 2" | `RepRules`, `Challenge` |
| Booking confirm | Win / Loss and chance | `RepRules` |
| Fight result | "+11 reputation, now 3rd" (S428: every fight shows the rank earned) | `RepLedger`, `Ladder` |
| Week review | Changes, bands reached, Pro talk departures, new entry | `RepLedger`, `Ladder.drain/entry` |
| Pro offer modal | Turn pro / Stay amateur, ticket line | `ProGate` (CHECK 5, 6) |
| Records | Band milestones | `RepLedger` |
| World > Rankings | Unchanged (CODE); the precedent for owner question 5 | none |

## 5. The decisions this creates
1. **Who to ask:** where your edge over expected is largest, with the star as the quiet default.
2. **When to ask up:** after tape and a plan that beats that style.
3. **Accept or pass** a challenge.
4. **Keep active or rest:** the clock against the stoppage risk.
5. **Turn pro or stay amateur** at 55.
6. **Rematch** or move on.
7. **Pin a target** and plan the weeks toward the date.

Part 4 of 4

## 6. Probes (headless; Claude builds and runs; numbers freeze only on a pass)

**The bots.** Every bot writes a plan:
- PLAN writes the best-rated lines from Playbook's "Rate against" for the opponent's style.
- The other bots use the assistant's default plan (CODE).

**The other bots:**
- **SAFE:** the highest-chance YES row.
- **ASKUP:** the highest-reputation YES row.
- **COACH:** the starred row.
- **WAIT:** offers only.
- **GRIND:** only opponents 20+ below.

**Pass lines** (each over 200 seeds of 2 seasons; **BASE0** is the code's current pro-offer pace):

| # | Line |
|---|---|
| 1 | PLAN reaches 55 fastest. COACH within 10% of the best non-PLAN bot. SAFE and ASKUP each 15%+ slower than COACH |
| 2 | PLAN 10–25% faster than COACH |
| 3 | COACH's time to 55 within ±25% of BASE0 |
| 4 | ASKUP takes 1.5× or more SAFE's stoppage losses |
| 5 | WAIT leaves the top 3 within 16 free weeks in 60%+ of seeds |
| 6 | An ask by COACH beats the best offer that week by 1.5+ reputation a bout on average |
| 7 | 70%+ of refusals become a yes within 8 weeks |
| 8 | Top 5 at week 52 sit between 40 and 75; never 3+ rivals above 55 for more than 8 weeks |
| 9 | GRIND reaches 55 in 0 seeds |
| 10 | Hover parts sum to the shown value in every case |
| 11 | Pass and accept are each the better choice in 30–70% of challenges |
| 12 | A boxer +5 on stats over rivals reaches 55 at least 25% faster than one at par (John 3) |

## 7. Build order (each step after the one before passes)
1. `RepRules` (1.1 formula and table) and `RepLedger` (floor, clock). Run lines 9 and 10.
2. `Ladder`: seed, rivals moving, drain, entry. Run line 8.
3. `AskAnswer` (refusal table, deterministic date) and `Challenge`. Run lines 7 and 11.
4. Bots with plans. Run BASE0 and lines 1–6 and 12. Freeze the numbers.
5. `ProGate` at 55, Stay amateur, and starting pro fans unchanged.
6. The page (4), from the agreed mockup only, after owner questions 2, 4 and 5.

## 8. Owner questions and checks

**Owner questions**
1. Rename the gym's CODE `Career` reputation to **Standing**, so "reputation" means a boxer only?
2. OK the LADDER tab page (4.2–4.3) as the board to draw next?
3. May a hosted show's headliner ask up to 15 beyond the gap line, at about $150 travel for the guest (ESTIMATE)?
4. Show the reputation number on rows, or the band word only?
5. Ladder rows carry the opponent's name in the name cell, as World > Rankings does today. If no, rows show portrait, club and record, with the name only in the card header (S448).

**CHECKs**
1. Ladder size per class, from `Region.gd`.
2. Whether the shown chance excludes the plan.
3. Season start date for TWICE THIS SEASON and the cap.
4. Starting pro fan count in code today.
5. Whether the Pro offer modal can show a ticket line.
6. The modal's code text "tickets she sells" breaks S412: Claude to make it "tickets the boxer sells".
7. Whether a boxer can change class in code (for v2).
8. The owner's S475 sparring note, unread.
9. Do amateur bouts in code allow draws? John believes amateur bouts always have a winner. The draw rule is kept in case code allows them.

**v2:** class change and its reputation carry; the national ladder; rivalries with the living world (S428).

## 9. Risks
- **Elo can feel stingy at the top** (+2 for a safe win). The star and the edge line show why.
- **The drain could empty a small ladder.** Line 8 guards it, and the quarter entry refills it.
- **The pass cost (−2) is one number** and line 11 is its only test.
- **16 and 25 are untested.** Steps 1 and 4 freeze or change them.

## 10. Self-score (fresh critics decide)
- **Depth 7:** an edge-over-expected currency tied to training, plan and tape; real defending; a living top.
- **General design 7:** one refusal word for reach, every "no" with a way to a yes, the S425 menu table kept.
- **Play 6:** until the probes run.

**To reach 10/10**
1. Run steps 1–4 and publish the 12 lines with numbers.
2. Answer the 5 owner questions.
3. Read the S475 sparring note and wire it into WHAT WE KNOW and the sparring screen.
4. Draw the LADDER page at 1920×1080 from the kit, then a critic pass on the drawing.
5. Close CHECKs 1–9, especially 2 (chance and plan) and 9 (draws).
