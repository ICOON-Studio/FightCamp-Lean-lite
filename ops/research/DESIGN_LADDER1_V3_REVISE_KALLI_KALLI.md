# DESIGN_LADDER1_V3_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ175)

Brief: research/DESIGN_LADDER1_V3_REVISE_KALLI.md
Sent: 2026-11-15 13:10 | collected: 2026-11-15 13:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm writing LADDER1 v3 in full. It fixes the formula so reputation can't leak, gives challenges a real cost, makes the star the coach's opinion, adds the safety rule, uses one table per region and defines the season.

# LADDER1 v3: the season ladder, with reputation as the currency (S459, S475, S477, 2026-11-15)

Part 1 of 4

This is a full map. It replaces v2 (seat SQ169), and nothing outside this page stands.

**The critics on v2:**
- John (SQ170): depth 6, general design 6, play 6. Passes narrowly.
- Dola (SQ171): depth 7, general design 8, play 7.

v3 fixes John's five blockers:
1. The formula leaked reputation, so it's now zero-sum.
2. Accepting a challenge was nearly free, so it now costs a show date.
3. The star solved the choice, so it's now the coach's read, with error.
4. The novice safety rule was missing, so it's now in the table.
5. There were two tables for one region, so there's one now.

It also adds a season, plus Dola's rest, filter and hover asks.

**Not opened:** `ops/research/CRITIC_ACCESS.md`, the Miro board, the mockups and the owner's S475 sparring note. The owner's computer is offline. This map is checked against the critic pack, Claude's S477 code facts and the two critics.

**Owner rules kept, quoted**
- **S475:** the ladder "must reach 9/10: see the ladder, find an opponent, book", with REPUTATION as the currency, not fixed win counts.
- **S428 and S425:** amateur to the first pro fight; ONE regional ladder first; every fight shows the rank earned; wired and shown on the correct menus. The living world comes after the fight week is built and played.
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". Names in rows go to the owner (owner question 5).
- **S412:** any gym, any boxers, men or women. No fixed he or she.
- **Pack 4.5, agreed:** "a 'no' is a closed panel or an absent answer with its reason, never a random refusal".
- **Pack 7:**
  - only actionable information;
  - one word per concept;
  - nothing opens by itself;
  - screens only from agreed mockups, so the page waits for owner question 2.
- **Pack 1:** "the better-trained fighter usually wins; a good plan turns close fights".
- Classes in kg: women 57/60/65/70/75 (70 added in Q-S294-233), men 57.5/60/70/75. One ladder per sex and class, because females never fight males.
- "Gym" is the facility. Amateurs have a fight week, not a camp.

**Marks**
- **CODE:** in the code today (pack or S477).
- **DERIVED:** worked from this map's formulas.
- **GAME VALUE:** a fixed design number, not tuned.
- **ESTIMATE:** ours, gated by the probes in 7. Every reputation number is ESTIMATE.
- **NEW:** a rule this map adds. **CHECK:** someone must confirm.

**One word per concept**
- **Reputation** (0–100): a boxer's own currency. **Standing:** the gym's (CODE `Career`), renamed (owner question 1).
- **Ladder:** the regional table for one sex and one class, sorted by reputation. It's the same table World > Rankings shows (5).
- **Rank:** a position among ranked boxers, which means 4+ wins (CODE). v2's "place" is gone.
- **Ask:** your boxer asks for a named opponent. **Offer:** a bout that comes to you (CODE). **Challenge:** an offer from a lower-ranked boxer.
- **Chance:** the code's win band, shown at booking. **Expected:** what the ladder expects from the two reputations. **Coach's read:** the coach's guess of the chance, used only by the star.
- **Season:** 1 Jan to 31 Dec (3.3).

## 0. Every critic point answered

### 0.1 John (SQ170): To reach 10/10
| # | Point | v3 |
|---|---|---|
| 1 | Balanced formula; fix the ±10 draws and the 5-2 seed | **Done (1.1).** The loser loses exactly what the winner gains, win weight included. Stoppage is +2 to the winner and −2 to the loser. The floor shortfall is logged, not paid. Draws at ±10 are now −3 and +3. The 5-2 seed is 27 |
| 2 | Real cost for a challenge; a third answer | **Done (2.2).** Accepting takes the next free show date and cancels any ask pending for it. New answer: **Not this show** (0, a later date). Pass stays at −2 |
| 3 | Star = the coach's opinion | **Done (4.2).** It ranks the coach's read, whose error follows the coach rating. It ignores habits not yet found, and its hover says what it doesn't know. Pass line 1: PLAN beats COACH by 15%+ |
| 4 | The code's band, never "Unknown" | **Done.** The star ranks the coach's read of the band's middle |
| 5 | One table per region; one word, rank | **Done (5).** World > Rankings and the Ladder are one table sorted by reputation. Boxers under 4 wins are greyed below a line, which keeps the code's 4-win rank rule. "Rank" everywhere |
| 6 | NOT SAFE; WRONG CLASS as a chip; AT THE NATIONALS | **Done (3).** WRONG CLASS becomes a Weight at risk chip with Start a cut or Later date. It refuses (TOO HEAVY) only above about 1 kg a week to the weigh-in (ESTIMATE, CHECK 10) |
| 7 | Fix the clock | **Done (1.2)**, with one change. A refused ask stops the clock only when **every** row inside your gap line says no. Otherwise one hopeless ask a week (to someone far above) would freeze the clock. Nationals weeks aren't free. Rivals lose reputation on the same clock |
| 8 | Define the season | **Done (3.3)** |
| 9 | Fix the probes; draws | **Done (7).** GRIND is the lowest YES row. New line 13 tests staying amateur. Draws: the code has them (pack 4.8), so the rule stays and the owner decides whether amateur draws should exist (owner question 6) |
| 10 | Correct the tab name; owner chooses where | **Done.** There's no Training tab. Owner question 2 offers Fights under the offers (recommended, where the agreed map puts Ask for a fight) or a Ladder tab on the fighter page |
| 11 | CHECK 2 before the star or PLAN probes | **Done (7, step 0).** If the chance includes the plan, the band stays at its pre-plan width until the plan is written, and the card shows the plan's rating as a separate line |
| 12 | Run the probes, then draw | **Not done here:** I design and don't run code. It's the build order (8) |

### 0.2 John's missing options
| Option | v3 |
|---|---|
| NOT SAFE word | Done (3) |
| Pick a date | Done: **Ask: first free date** and **Ask: the one after**, both printed |
| Season end | Done (3.3) |
| Not this show (challenge) | Done (2.2) |
| Ask from Rankings and the rival file | Done: one table, so every row opens the same card |

His verdicts are answered by these changes:
- The star now carries error.
- Passing a challenge now has a reason: the challenge takes your date.
- Staying amateur gets a second way back (2.5) and probe 13.
- WRONG CLASS is a chip.
- The draw column stays only while the code has draws.

### 0.3 Dola (SQ171): To reach 10/10
| # | Point | v3 |
|---|---|---|
| 1 | Run the 12 probes | **Not done here** (no code). Now 15 lines, first in the build order |
| 2 | Owner questions | **Done:** now 6 questions (9) |
| 3 | S475 note; CHECKs 2, 7, 9 | **The S475 note:** still unread, because it's on the offline computer (CHECK 8). **CHECK 2:** answered by step 0. **CHECK 9:** answered from the pack, the code has draws. **CHECK 7:** class change is NOT ESTABLISHED in code. Her "Move class: −5 and a 4-week wait" is kept for later, because the game can't move a boxer's class yet |
| 4a | Voluntary rest | **Done (1.2):** **Rest until <date>**, up to 4 weeks, once a season. The clock is paused, and no offers or asks come |
| 4b | Milestone bouts | **Done with what exists:** the London regional stage and the national draw (CODE) are the milestone bouts. The strip shows them with their +5 and +10. There's no new "regional final" flag, because it would duplicate the code's bracket |
| 4c | Style filter | **Done (4.2):** Show: All / Same stance / Same style. That's one row of three toggles |
| 5 | Show the why | **Done:** the result line's hover reads "Beat 28% expected · unanimous · gap +10 · +11". The star's hover gives the coach's read, what's expected and what isn't known |

### 0.4 Dola's other gaps and missing options
| Point | v3 |
|---|---|
| Opaque formula | Every value hovers to its sum |
| Slow at the top | Zero-sum plus the +2 stoppage share pays more at the top (DERIVED: about +11 for an even stoppage win). Probe 3 times the climb |
| Drain feels unfair | The Pro talk countdown shows the weeks left, so the player can ask before the rival leaves. Pinning the rival puts the countdown on NEXT STEP |
| Short-notice boost | Not done: it pays for skipping the fight week CLUBWEEK1 is built on. The sooner date is its own reward |
| Change class | Later; NOT ESTABLISHED (CHECK 7) |
| Mobile | Not done: PC only (pack 1) |

Part 2 of 4

## 1. Reputation: how it's earned

### 1.1 Paid by who you beat, zero-sum (NEW; every number ESTIMATE)

$$ \text{expected} = \frac{1}{1 + 10^{(\text{opp} - \text{you})/25}} $$

- **The winner gains:** 16 × (1 − winner's expected) × win weight. On a stoppage, the winner gains 2 more.
- **The loser loses exactly that amount.** The win weight applies to both sides, and a stoppage costs the loser the matching 2.
- **Draw:** each side gets 16 × (0.5 − its expected), which is zero-sum by itself.
- **Rounding:** the exact amount is rounded once, and the same whole number goes to both sides. A 0.4 rounds to 0.
- **Floor at 0:** if the loser can't pay all of it, the winner still gains in full. The shortfall is logged on the week review ("Ladder top-up: 3"). Probe 8 watches the total.

**Win weights** (BoxRec ratios rescaled so unanimous = 1, GAME VALUE):

| Win | Weight |
|---|---|
| Stoppage | 1.15 |
| Unanimous | 1.0 |
| Majority | 0.65 |
| Split | 0.5 |

**What one bout pays your boxer** (DERIVED; gap = opponent's reputation minus yours):

| Gap | Expected | Stoppage win | Unanimous | Majority | Split | Draw | Lose on split | Lose unanimous | Stopped |
|---|---|---|---|---|---|---|---|---|---|
| −40 | 97.5% | +2 | 0 | 0 | 0 | −8 | −8 | −16 | −20 |
| −20 | 86% | +5 | +2 | +1 | +1 | −6 | −7 | −14 | −18 |
| −10 | 72% | +7 | +5 | +3 | +2 | −3 | −6 | −11 | −15 |
| 0 | 50% | +11 | +8 | +5 | +4 | 0 | −4 | −8 | −11 |
| +10 | 28% | +15 | +11 | +7 | +6 | +3 | −2 | −5 | −7 |
| +20 | 14% | +18 | +14 | +9 | +7 | +6 | −1 | −2 | −5 |

**Why it doesn't leak.** Every point one boxer gains, another loses. The ladder's total moves only through entry, drain and the logged floor top-ups. Probe 8 checks this: the total stays within ±5% across a season, with no entry or drain.

**Average gain, unanimous results only** (DERIVED):

$$ 16 \times (\text{real chance} - \text{expected}) $$

Mixed results average out, because majority and split weights now apply to both sides of each result.

**The roads** (DERIVED; "real" is a probe figure, not a promise; unanimous results):

| Road | Real vs expected | Average a bout | The catch |
|---|---|---|---|
| Far below (gap −40) | 99% vs 97.5% | About 0 (a win rounds to 0) | One loss costs 16. Dead |
| Safe below (gap −20) | 95% vs 86% | +1.2 | Slow. One loss costs 14 |
| Even, with a training edge | 60% vs 50% | +1.6 | Steady |
| Above, plan beats their style (gap +20) | 35% vs 14% | +3.6 | Stoppage risk; needs tape and a plan |
| Free 8+ weeks | — | −1 every 2 weeks | Falls |

The +1.2 on the safe road is John's grind figure. It's slower than a scouted ask, and it reaches zero once the boxer outgrows the bottom of the ladder. Probe 9 tests that.

### 1.2 The clock (NEW)
A week is **free** only when all of these are true:
- no booked bout;
- not suspended, not inside the 8-week rest after a stoppage (CODE `STOP_REST_WEEKS`), not injured (CODE);
- not in a nationals run (CODE: no offers come during one);
- not resting by choice (below);
- at least one row inside the gap line answers YES. If every reachable row says no, the player can't act, so the week isn't counted.

The rules:
- **The fall:** after 8 free weeks in a row, −1 reputation every 2 free weeks. A booking resets the count. The Overview line reads "Free 9 weeks: −1 every 2".
- **Rest until <date> (NEW):** up to 4 weeks, once a season. No offers, no asks, the clock paused. The card's button shows the date. This answers Dola's "a needed break shouldn't be punished".
- **RESTING:** asks open when the 30-day suspension ends (CODE). The earliest date is 8 weeks after the stoppage, matching the code's offer rule.
- **Rivals** use the same clock, so a rival who sits out falls too. A rival with no bout for 52 weeks leaves.

### 1.3 Seeding, draining and entry (NEW; ESTIMATE)
**Seed for rivals:** the larger of 0 and (8 + 4 × net wins + bouts), capped at 65.

| Record | Seed |
|---|---|
| 8-2 | 42 |
| 5-2 | 27 |
| 16-4 | 65 (capped) |

**Your gym's boxers:** walk-ins start at 0. Signed prospects use the same formula, capped at 30.

**How the ladder moves:**
- Rivals box each other at shows (CODE results), paid by 1.1.
- **Drain:** a rival who holds 55+ for 8 weeks turns pro and leaves. This is counted, not rolled, and the row shows "Pro talk: n weeks".
- **Entry:** on the first Monday of each quarter, one new rival enters each ladder at their seed. Probe 8 checks the top 5 sit at 40–75.

### 1.4 One-offs (ESTIMATE; paid from outside the ladder, logged)
| Result | Reputation |
|---|---|
| Regional stage won | +5 |
| National title | +10 |
| Headline win at a hosted show | +3 |

## 2. Answers and offers

### 2.1 The ask (CODE `AskAnswer`, made deterministic)
- An ask gets **YES** only when every row of the refusal table (3) passes. Otherwise it gets the word, its reason and the way to a yes. Nothing is rolled.
- A YES shows two buttons, each with its date:
  - **Ask: <first free show>**, which is the opponent's first free show date at least 2 weeks out (CODE `CAMP_WEEKS` 2);
  - **Ask: <the one after>**, which lets the player keep clear of a fight-week clash.

### 2.2 Challenges: three answers (NEW)
When your boxer is free, a lower-ranked boxer up to 15 below may challenge through the offer list, at most once every 4 weeks.

| Answer | What it costs | What it keeps |
|---|---|---|
| **Accept** | Takes your next free show date. Any ask pending for that date is cancelled, and the row names it | Pays by 1.1 |
| **Not this show** | 0. The challenger takes their next free date after yours | Your pending ask stays |
| **Pass** | −2 reputation | Your date and your risk. Passed twice, a challenger sends none for 8 weeks |

**Worked case** (DERIVED; gap −10, real chance 75%):
- Accepting averages 0.75 × 5 − 0.25 × 11 = +1.0.
- If it cancels a pending ask averaging +3.6 (the "above, plan" road), **Not this show** is better.
- Pass is right when the date is wanted and the challenger would come back at a bad time, for example inside a weight cut.

Probe 11 checks that each answer is the best one in at least 15% of challenges.

### 2.3 Clubmates (NEW)
Two boxers from one gym are never offered against each other and never asked. The word is **CLUBMATE**.

### 2.4 The rematch (NEW)
- After a loss, the winner's card shows **Ask for a rematch**.
- One opponent at most twice a season. A third ask gets **TWICE THIS SEASON**.
- A rematch pays by 1.1.

### 2.5 Pros, and staying amateur
- **Pro offer** at reputation 55 (CODE `ProGate`, replacing the win count).
- **Turn pro:** starting pro fans stay at today's count (CHECK 4). Reputation shows only on the ticket line: "Ticket draw: Pro-ready" (CHECK 5).
- **Stay amateur:** the offer returns at **65, or after a regional stage win or a national title, whichever comes first** (NEW). John showed 65 alone may be out of reach once the drain empties the top. Probe 13 tests it.
- **Sparring (S475):** the note is unread (CHECK 8). For now, WHAT WE KNOW names stance and style, and the sparring screen already lists partners by stance (CODE).

### 2.6 The season (NEW)
- **Dates:** 1 Jan to 31 Dec, unless the code has a season date (CHECK 3).
- **Season end,** on the first Monday of January:
  - the final table goes to Records, with a line for each of the top 3;
  - the 18-bout cap (CODE) and the rematch counts reset;
  - reputation carries over (a reset would erase the climb S475 asks for);
  - the week review gets one line: "Season ends: ranked 4th, reputation 38".
- **During the season,** the strip shows "Season ends 4 Jan · bouts 7 of 18".

Part 3 of 4

## 3. The refusal table: every "no" has a word and a way to a yes

**The gap line** is 10 + your reputation ÷ 5, rounded down. That's 10 above at reputation 0, 16 at 30 and 21 at 55.

| Word | When | Line under it | To get a yes |
|---|---|---|---|
| **NOT ENOUGH IN IT** | Opponent above your gap line | "Needs 6 more: about one win above you" | Win; or headline a hosted show (owner question 3: up to 15 beyond the line) |
| **NOT SAFE** (CODE rule) | A novice (0–10 bouts) asks an open boxer, or the reverse | "Not safe: novice against an open boxer" | "Opens after 3 more bouts" (CHECK 11: the code's line for "open") |
| **BOOKED** | The opponent has a bout before the earliest date | "Booked until 22 Mar" | The later date shows |
| **RESTING** | Inside the 8-week rest after a stoppage, either boxer | "From 12 Apr" | Wait |
| **AT THE NATIONALS** | Either boxer is in a nationals run | "From <the date the run ends>" | Wait |
| **TWICE THIS SEASON** | A third ask of one opponent | "Opens 4 Jan" | The next season |
| **CLUBMATE** | Same gym | "Clubmates don't box each other" | None |
| **TOO HEAVY** | The cut to the weigh-in needs more than about 1 kg a week (ESTIMATE, CHECK 10) | "Needs 4.2 kg in 3 weeks" | Ask the later date, or start a cut |
| **CAP REACHED** | Season bout cap (CODE 18) | "Cap: 18 of 18" | Opens 4 Jan |

**Weight below the TOO HEAVY line** is not a refusal. The ask shows the code's **Weight at risk** chip with the forecast ("1.4 kg to go by Fri") and two buttons, Start a cut and Later date. Weight stays the player's choice (pack 4.4).

Each word is a closed panel with its reason (pack 4.5). Nothing is rolled.

## 4. The page: the ladder (owner question 2 places it)

### 4.1 Where it sits
There are two choices for the owner:
- **(a, recommended) Fights, under the offers,** where the agreed map puts Ask for a fight (pack 6).
- **(b) A Ladder tab on the fighter page,** beside Overview, Week, Fight prep, Playbook and History.

Either way, it opens only when clicked (pack 7).

World > Rankings shows **the same table**, read-only apart from opening the card. One table per region, sorted by reputation (5).

### 4.2 The table (one row per boxer in that sex and class)
- **Columns:**
  - rank, with an arrow for last week's move;
  - portrait;
  - name cell (owner question 5);
  - club;
  - record;
  - stance;
  - style word;
  - reputation with its band word (owner question 4);
  - **Win / Loss** (unanimous values against your boxer, for example "+11 / −5");
  - **Chance** (the code's band, for example "40–70" when unscouted; never "Unknown");
  - the answer stamp (YES or the refusal word).
- **The ranked line:** boxers under 4 wins sit greyed below a dotted line labelled "Not ranked yet: 4 wins" (CODE rule). They can still be asked.
- **Your boxer's row:** slate. **Your reach:** a dotted line under the last row inside the gap line, labelled "Your reach: up to 16 above".
- **Show:** All / Same stance / Same style. Three toggles, and every column sorts.
- **Pro talk:** a tag on the row ("Pro talk: 3 weeks").
- **Gold:** the selected row's first Ask button only.

**The coach's star (NEW):** a star on one YES row.
- **What it ranks:** the coach's read minus expected, where the coach's read is the middle of the band, off by up to ±(25 − coach rating ÷ 5) points (ESTIMATE):

  | Coach | Rating | Read off by up to |
  |---|---|---|
  | Luke Reid | 58 | ±13 |
  | Marcus Hale | 74 | ±10 |
  | No coach | — | ±25 |

  The error is fixed for each opponent for each week, so it doesn't change between clicks.
- **What it uses:** found habits only. It never sees your plan.
- **Hover:** "Coach's read: about 60. The ladder expects 40. No tape: a guess."
- **Why:** the player who scouts and writes a plan can beat the star (pass line 1).

**Bands** (milestones on the week review and in Records; they unlock nothing):

| Reputation | Band |
|---|---|
| 0–14 | Unknown |
| 15–29 | Known locally |
| 30–44 | Rated |
| 45–54 | Contender |
| 55+ | Pro-ready |

### 4.3 The card (on row click, from the ladder or World > Rankings)
- **Header:** the opponent's portrait and name. This is the only place the name appears (S448).
- **WIN / LOSS:** the four results with values. Hover gives the sum: "Expected 28% · unanimous · 16 × 0.72 = +11".
- **YOUR PLAN:** the Playbook's rating against this style, Beats it / Works / Walks into it (CODE). Without a plan: "No plan written". This is the plan's value, kept apart from Chance.
- **WHAT WE KNOW:** style, stance and found habits (CODE rival file). Locked lines say "Tape study opens this".
- **Dates:** booked until, first free show and the one after. Pro talk countdown if any.
- **Buttons:**
  - **Ask: 29 Mar** (gold);
  - **Ask: 12 Apr**;
  - **Pin as target**: one at a time, and Overview's NEXT STEP reads "Target: ranked 3rd, free from 28 Mar";
  - **Ask for a rematch**, only after a loss to this boxer.
- **On a refusal:** the word, its line and its way to a yes, with the Ask buttons dimmed.
- **Your own row's card:** Rest until <date> (1.2).
- **Ranked 1st:** "Top of the ladder. New entry 1 Apr; regional stage +5 on <date>."

### 4.4 The strip above the table
- **CLOCK:** "Free 5 weeks: falls from week 8".
- **PRO OFFER:** "At 55: needs 24, about 3 wins above you".
- **SEASON:** "Ends 4 Jan · bouts 7 of 18".
- **TARGET:** "Ranked 3rd · free from 28 Mar".
- **NEXT STAGE:** "London regional: +5" (CODE dates).

**The challenge strip below the table** appears only while a challenge is open: "Challenge from ranked 9th: Accept / Not this show / Pass (−2)", with the line "Accepting cancels your ask for 29 Mar".

## 5. Every menu it appears on (S425)
| Menu | What it shows | Wired to |
|---|---|---|
| Fights (or fighter tab: owner question 2) | Table, strip, card, challenge strip (4) | `Ladder`, `RepRules`, `AskAnswer`, `Challenge`, `CoachRead` |
| World > Rankings | The same table, sorted by reputation; a row opens the card | `Ladder` (replaces the separate results-only ranking) |
| Fighter Overview | Reputation and band, NEXT STEP target, clock line, Rest until | `RepLedger`, `Ladder.pin`, `Clock` |
| Offers list | Win / Loss on each offer; challenge rows with three answers | `RepRules`, `Challenge` |
| Booking confirm | Win / Loss, chance, the weight chip | `RepRules`, weight forecast (CODE) |
| Fight result | "+11 reputation, now ranked 3rd" (S428), with hover "Beat 28% expected · unanimous · gap +10" | `RepLedger`, `Ladder` |
| Week review | Changes, bands reached, Pro talk departures, new entry, floor top-ups, season end | `RepLedger`, `Ladder.drain/entry`, `Season` |
| Pro offer modal | Turn pro / Stay amateur with its two returns; ticket line | `ProGate` (CHECK 5, 6) |
| Records | Band milestones, the final table each season with top-3 lines | `RepLedger`, `Season` |

## 6. The decisions this creates
1. **Who to ask:** scout and plan to beat the coach's star, or follow it.
2. **When to ask up:** after tape and a plan rated Beats it.
3. **Which date:** the first free show or the one after, against the weight forecast and fight week.
4. **A challenge:** accept, push it back, or pay 2 to keep the date.
5. **Active or rest:** the clock, the stoppage risk, and one rest of up to 4 weeks a season.
6. **Turn pro or stay amateur** at 55, with two ways back.
7. **Rematch or move on;** pin a target and plan weeks toward the date.

Part 4 of 4

## 7. Probes (headless; Claude builds and runs; numbers freeze only on a pass)

**The bots.** Every bot writes a plan:
- PLAN writes the best-rated lines from the Playbook's Rate against for that style.
- The others use the assistant's default plan (CODE).

**The other bots:**
- **SAFE:** the highest-chance YES row.
- **ASKUP:** the highest-reputation YES row.
- **COACH:** the starred row.
- **WAIT:** offers only.
- **GRIND:** the lowest-reputation YES row.

**Pass lines** (each over 200 seeds of 2 seasons; **BASE0** is the code's current pro-offer pace):

| # | Line |
|---|---|
| 1 | PLAN reaches 55 fastest, 15–35% faster than COACH. COACH is within 10% of the best non-PLAN bot. SAFE and ASKUP are each 15%+ slower than COACH |
| 2 | COACH with the 74 coach reaches 55 at least 5% faster than COACH with the 58 coach (the star's error matters) |
| 3 | COACH's time to 55 is within ±25% of BASE0 |
| 4 | ASKUP takes 1.5× or more SAFE's stoppage losses |
| 5 | WAIT leaves the top 3 within 16 free weeks in 60%+ of seeds |
| 6 | COACH's ask beats the best offer that week by 1.5+ reputation a bout |
| 7 | 70%+ of refusals become a yes within 8 weeks |
| 8 | Top 5 at week 52 sit between 40 and 75, never with 3+ rivals above 55 for more than 8 weeks. The ladder's total, not counting entry, drain and one-offs, stays within ±5% a season. Floor top-ups stay under 3% of all points moved |
| 9 | GRIND reaches 55 in under 10% of seeds, and averages under +0.5 a bout above reputation 35 |
| 10 | Hover parts sum to the shown value in every case |
| 11 | Accept, Not this show and Pass are each the better answer in 15%+ of challenges |
| 12 | A boxer +5 on stats reaches 55 at least 25% faster than one at par |
| 13 | Staying amateur at 55 with +5 stats: the offer returns within 2 seasons in 40–80% of seeds |
| 14 | A boxer whose player asks every week loses reputation to the clock in under 10% of seeds |
| 15 | One Rest until (4 weeks) changes the time to 55 by under 10% |

## 8. Build order (each step after the one before passes)
0. **Answer CHECK 2:** does the shown chance include the plan? If it does, the band stays at its pre-plan width until the plan is written, and the card's YOUR PLAN line carries the plan's value.
1. **`RepRules`** (zero-sum formula and table), **`RepLedger`** (floor and top-up log) and **`Clock`**. Run line 10.
2. **`Ladder`:** seed, rivals moving, drain and entry, plus **`Season`**. Run line 8.
3. **`AskAnswer`** (the full refusal table, two dates) and **`Challenge`** (three answers). Run lines 7, 11 and 14.
4. **`CoachRead`** and the bots. Run BASE0, then lines 1–6, 9, 12, 13 and 15. Freeze the numbers.
5. **`ProGate`** at 55, Stay amateur with its two returns, starting pro fans unchanged.
6. **One table:** World > Rankings reads `Ladder` (CHECK 12).
7. **The page** (4), from the agreed mockup only, after owner questions 2, 4 and 5.

## 9. Owner questions and checks

**Owner questions**
1. Rename the gym's CODE `Career` reputation to **Standing**, so "reputation" means a boxer only?
2. Where does the ladder sit: **(a) Fights, under the offers** (recommended), or **(b) a Ladder tab** on the fighter page? And OK the page (4.2–4.4) as the next board?
3. May a hosted show's headliner ask up to 15 beyond the gap line, at about $150 travel for the guest (ESTIMATE)?
4. Show the reputation number on rows, or the band word only?
5. Do rows carry the opponent's name, as World > Rankings does today? If not, rows show portrait, club and record, and the name sits in the card header only (S448).
6. The code has draws (pack 4.8). Keep amateur draws, or should every amateur bout have a winner? The formula handles both.

**CHECKs**
1. Ladder size per class (`Region.gd`).
2. Does the shown chance include the plan? (Step 0.)
3. The code's season date, the 18-bout cap and the rematch reset.
4. Starting pro fan count in code today.
5. Can the Pro offer modal show a ticket line?
6. "Tickets she sells" in the modal breaks S412. Claude to make it "tickets the boxer sells".
7. Can a boxer change class? (Dola's "Move class: −5, 4 weeks" waits on it.)
8. The owner's S475 sparring note, unread.
9. **Closed:** the code has draws, which is now owner question 6.
10. The TOO HEAVY line (about 1 kg a week) against the code's cut model.
11. The code's novice and open bout counts for NOT SAFE.
12. Does anything else read the 4-win ranking (nationals entry, the pro gate's old top-3 rule) before World > Rankings switches to `Ladder`?

**Later:** class change and its reputation carry; a national ladder; rivalries with the living world (S428).

## 10. Risks
- **The star's error can feel unfair.** Its hover says "a guess", and tape narrows the band it reads.
- **Floor top-ups can inflate the bottom of the ladder.** Line 8 caps them at 3%.
- **Three challenge answers add a click.** Line 11 must show that each one earns its place, or Not this show is cut.
- **One table touches World code.** CHECK 12 comes first.
- **16, 25, −2 and ±(25 − rating ÷ 5)** are untested. Steps 1 and 4 freeze or change them.

## 11. Self-score (fresh critics decide)
- **Depth 7:**
  - a zero-sum currency paid for beating the ladder's expectation, tied to training, tape and the plan;
  - a star the player can outplay;
  - challenges that cost a date;
  - a season with an end;
  - two roads back for staying amateur.
- **General design 7:**
  - one table per region and one word, rank;
  - every "no" has a word, a date and a way to a yes, including NOT SAFE and the weight chip;
  - the S425 menu table is kept;
  - the formula is balanced;
  - the probes test what they claim.
- **Play 6:** until the probes run and the page is drawn.

## To reach 10/10
1. Run step 0, then steps 1–4, and publish all 15 lines with numbers. Change any number a line fails on.
2. Get the owner's answers to questions 1–6, especially 2 (where it sits) and 5 (names in rows).
3. Read the S475 sparring note and wire it into WHAT WE KNOW and the sparring screen.
4. Draw the ladder page at 1920×1080 from the kit, in the stress state:
   - ranked 6th;
   - a challenge that would cancel the starred ask;
   - Pro talk on the boxer ranked 1st;
   - one NOT SAFE row;
   - one Weight at risk chip.

   Then a critic pass on the drawing.
5. Close CHECKs 1–12, CHECK 12 before World > Rankings changes.
6. If line 11 fails, cut Not this show. If line 13 fails, lower the stay-amateur return to 62. If line 2 fails, widen the star's error.
