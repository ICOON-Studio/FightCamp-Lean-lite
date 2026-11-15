# DESIGN_TRAINGAME2_V2_KALLI_KALLI - Kalli answer (seat queue SQ176)

Brief: research/DESIGN_TRAINGAME2_V2_KALLI.md
Sent: 2026-11-15 14:10 | collected: 2026-11-15 14:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm checking whether the two critiques and the S484 numbers are on my computer before I write TRAINGAME2 v2.

I can't reach the four files yet. My copy of the repo is from 2 Nov and the git sign-in failed, so I'm trying the GitHub connector next.

The connector can't see the repo either, so I'm writing v2 from the v1 numbers and the critic pack text in your earlier TRAINGAME2 brief, my own critique, your S486 code facts and your summary of both critics. John's file is unread, and the map says so.

# TRAINGAME2 v2: the training week as a design map (Training K, S459, S484, S486, 2026-11-15)

Part 1 of 3

This is a full map. It replaces v1 (TRAINGAME2_REAL_NUMBERS_S484), and nothing outside this page stands.

**The critics on v1:**
- John: depth 5, general design 5, play 6.
- Kalli (fresh): depth 4, general design 5, play 4.

**Not opened:** `DESIGN_TRAINGAME2_CRITIC_JOHN_JOHN.md`, the live `CRITIC_PACK.md` and `CRITIC_ACCESS.md`. Neither git nor the GitHub connector could reach the repo. I've answered John through the brief's list of the critics' top items. This map uses the v1 numbers and the critic pack text in the TRAINGAME2 brief, Kalli's critique, and Claude's S486 code facts.

**Owner rules kept, quoted or cited**
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". The body says "your boxer".
- **S412:** any gym, any boxers, men or women. No fixed he or she.
- **S431 and S486, one vocabulary:** the ability is **Stamina**, and "Cardio" is only the body-chart group (Stamina plus Recovery). The word is **Fight IQ**, never Ring IQ. A morning names the ability it raises, from `Attrs.LABEL`.
- **Pack 7:** only actionable information; one word per concept; nothing opens by itself; screens only from agreed mockups.
- **Pack 1:** "the better-trained fighter usually wins; a good plan turns close fights".
- **The test body:** 70 kg, a women's amateur class (England Boxing and IBA; added in the game by Q-S294-233). It's cutting in peak week, with carried-in tiredness 40 and pad coach 58. The body says "the test fighter".
- **Kit:** gold on one thing per frame; green on Continue only. Coach's lines under 70 characters, with no numbers.

**Marks**
- **CODE:** Claude's S486 facts or the S484 measured numbers.
- **DERIVED:** worked from those numbers.
- **ESTIMATE:** ours, gated by a probe.
- **NEW:** a rule this map adds. **CHECK:** someone must confirm.

**Units.** Mastery runs 0 to 100. A pad night is 240 drill units (CODE `PadWeek.PAD_NIGHT_MINUTES`), the game's own scale. This map uses units only, never minutes.

## 0. Every critic point answered

### 0.1 The brief's top items (both critics)
| # | Point | v2 |
|---|---|---|
| 1 | The cost side: extra pad nights and Hard mornings shown in tiredness and injury risk | **Done (2.3, 3).** Every card carries a tiredness chip, and the week line is redrawn by the rule as cards move. Overreach at 80 shows gains ×0.6 and injury ×3. A load jump of 1.5× shows injury ×2–4 |
| 2 | Dominant-pick test: always padding the move nearest Usable must not always win | **Done (4).** It's a bot, NEAREST, in 6 starting states. Section 4 shows by worked case where it loses: carried-in tiredness 60+, a camp's first week, and the wrong move for the opponent's style. Probe P1 must confirm it loses in at least 30% of states |
| 3 | Readiness forecast on each night card | **Done (2.2).** Each card shows "+7.5 mastery", plus the move's tier by Friday and by fight night. Forecasting comes from `PadWeek.project` (CODE). New UI: the chip on the card, the live redraw, and the "by fight night" line |
| 4 | What readiness buys, from a probe | **Done (2.4).** Sharp over Usable is +2.8 wins in 100 (the pack's measured figure). Usable over not ready is NOT MEASURED, so the card shows "fires 1 in 2" until probe P2 gives a wins figure. No drawn +1.5% |
| 5 | The play: anticipation across the week, a reward felt | **Done (5).** Owner question 1 recommends that fight week only sharpens moves that are already Usable, so Friday's night decides the next Saturday's fight. Crossing 30 gets a stamp on the week review and a line in the fight log |

### 0.2 Kalli (fresh): To reach 10/10
| # | Point | v2 |
|---|---|---|
| 1 | Build the page around the week's trade | **Done (2.1).** THE TRADE: body hook or check hook ready, unless the player pays for a fourth night or a better pad coach |
| 2 | A real tiredness line | **Done.** It's the rule's line from 40 (47, 45, 51, 49, 54, 48, 40, CODE), and every change is redrawn by the same rule. The drawn v1 line is gone |
| 3 | Decide the split | **Done.** The 70/30 and 30/70 pills are cut, because a night is the unit. Two choices stay, Whole night and Half and half, each with its forecast |
| 4 | Rule on learning in fight week | **Owner question 1**, with a recommendation |
| 5 | The pad coach as a lever | **Done (2.1 E),** gated on CHECK 3 |
| 6 | Words | **Done:** Stamina, Fight IQ, and Attrs words for every morning (2.5) |
| 7 | Rings to the next tier | **Done:** 30 under Usable, 60 under Sharp, 85 under Signature |
| 8 | Weekly sums and whole points | **Done (2.5)** |
| 9 | Verify or cut the unproven tiles | **Done.** Neck is cut (not in Attrs). Mobility becomes **Flexibility** (in Attrs). The win share is replaced (item 4 in 0.1). Injury risk is shown as the pack's multipliers. The coach's-week row is kept, because it's `PadWeek.project` on `PadWeek.defaults` (CODE) |
| 10 | A bot probe for dominance | **Done (4)** |
| 11 | Names and class | **Done:** "your boxer" and "the test fighter". 70 kg is confirmed as a women's class. The pack's section 4.4 needs the 70 kg line (CHECK 7) |

### 0.3 Options: what each changes, kept or cut (S403)
| Option | What it changes | Verdict |
|---|---|---|
| Night card (move on a pad night) | +6 to +9 mastery a whole night at 12–30 (CODE) | **Keep: the main lever** |
| Whole night / Half and half | Half gives about +3 to +4.5 each (ESTIMATE, half the units) | Keep. Useful only when a move sits within about 4 of a tier |
| 70/30, 30/70 | About ±1.5 mastery (DERIVED) | **Cut** |
| Swap a sparring night for pads | A fourth pad night; loses Fight IQ +0.12 and the drill of moves at 30+ | **New, keep** |
| Add a pad night on a rest evening | A fourth pad night; adds tiredness and load | **New, keep** |
| Pad coach on the night | Gains ×1.12 with pads 74 over 58 (ESTIMATE, CHECK 3) | **New, keep** if CHECK 3 holds |
| Morning session and Light / Normal / Hard | One ability, ×0.6 / ×1 / ×1.3; Hard adds tiredness | Keep, with weekly sums |
| Diet: Hold / Cut 500 | −0.04 to −0.09 kg a morning on the cut (CODE) | Keep |
| Sparring night | Fight IQ +0.12; drills only moves at 30+ (CODE) | Keep |
| Sunday rest | Tiredness −8 (CODE) | Keep |
| Neck tile | Not in Attrs | **Cut** |
| Mobility tile | Becomes Flexibility | Keep, renamed |

Part 2 of 3

## 1. The week in one paragraph
The coach fills every night the player leaves empty (CODE `PadWeek.defaults`): 3 pad nights and 1 sparring night between fights, and 3 and 2 in a camp at Hard. The player's job is to change that week only where it pays. Each change is shown at once in three places:
- **mastery and tier** on the card, by Friday and by fight night;
- **tiredness** on the week line;
- **injury risk** as a multiplier chip.

The coach's week stays on screen as a ghost row, so every change reads as better or worse than it.

## 2. The decisions, in order

### 2.1 The trade: which move gets ready (the test fighter, peak week)
The v1 week is a camp at Hard, with pad nights Mon, Wed and Fri. Starting mastery is check hook 12 and body hook 29.

| Option | Nights | Check hook by Fri 20 | Body hook by Fri 20 | Cost |
|---|---|---|---|---|
| **A. The coach's week** (v1) | Mon check, Wed body, Fri check | 28.2, not ready (CODE) | 35.4, Usable (CODE) | None beyond the week |
| **B. All on the check hook** | Mon, Wed, Fri check | About 34.6, Usable (ESTIMATE: +6.4 at 28, like the body hook's night at 29) | 29, not ready | The body hook waits a week |
| **C. Swap Thu sparring for pads** | Mon check, Wed body, Thu check, Fri check | About 34.6, Usable (ESTIMATE) | 35.4, Usable | No Thu sparring: Fight IQ −0.12 and no sparring drill for the body hook. Tiredness change is pads against sparring (CHECK 1) |
| **D. Add Sat 21 on pads** | A, plus Sat check | About 34.6 Sat 21, Usable (ESTIMATE) | 35.4 | One more night: tiredness and load (2.3) |
| **E. Pads-74 coach on the nights** | A's nights | About 30.1, Usable, just (ESTIMATE ×1.12) | About 36.2 | The coach's wage or time (CHECK 3) |

**Why there's no free answer.**
- A and B each make one move ready. Which is better depends on the opponent: the Playbook's Rate against says whether a body hook or a check hook beats that style (CODE).
- C buys both moves with the sparring night.
- D buys both with tiredness.
- E buys both with money, if the pad rating feeds the gain (CHECK 3).

### 2.2 The readiness forecast (NEW UI on `PadWeek.project`)
**Each night card shows:**
- "+7.5 mastery" (or "+3.7" for a half);
- the move's ring, filling toward its next tier;
- one tier line, for example "Usable Fri 20", "Usable Mon 23" or "Not ready by fight night".

**The re-forecast:** dragging a card redraws every card, the tiredness line and the injury chip before the drop. Nothing changes until the drop, and nothing opens by itself.

**The fight-night line** depends on owner question 1:
- **(a, recommended)** Fight-week pads only sharpen moves already at 30+, so a move under 30 on Fri 20 reads "Not ready by fight night".
- **(b)** Fight-week pads teach at the taper's half units. Then A's check hook reads "Usable Mon 23" (about 31.4, ESTIMATE: a half night at 28.2).

### 2.3 The cost side (every number from the rule; redrawn live)
**Tiredness**
- The coach's week from 40 (CODE): Mon 47, Tue 45, Wed 51, Thu 49, Fri 54, Sat 48, Sun 40.
- **D from 40:** Sat about 55 instead of 48, and Sun about 47 (ESTIMATE: a pad evening costs what Mon, Wed and Fri cost, CHECK 1). Fight week starts 7 higher. No overreach.
- **D from a carried-in 60:** Fri 74, Sat about 81, which is **overreached** on the night itself. The Sat gain drops to ×0.6 (about +3.8, check hook about 32.0), and injury risk is ×3 for Sat and Sun (pack).
- **The coach's week from 70:** Fri reaches 84, so Friday's own night is already at ×0.6. That's the case where cutting a night beats adding one.

**Load jump**
- If last week had 4 nights (Standard) and this week has 6 (D in a camp), that's 1.5×, so injury risk is ×2–4 (pack).
- Week load here is the night count (ESTIMATE, CHECK 2: the code's own load measure).
- In a camp's first week, D always crosses that line. In a camp's second week, it doesn't (6 against 5 is 1.2×).

**Hard mornings:** gains ×1.3, with tiredness per morning taken from the rule (CHECK 1). Each Hard morning's chip shows its tiredness, and the line redraws.

**The injury chip** reads "Injury risk ×1", "×3 (overreached)" or "×2–4 (load jump)". There's no percentage until the base rate is shown in the pack (CHECK 4).

### 2.4 What readiness buys
| Tier | Fires (CODE `FireLevel.GAME_SHARES`) | Worth |
|---|---|---|
| Under 30 | Never | — |
| Usable 30–59 | 1 in 2 | Against not ready: NOT MEASURED (probe P2) |
| Sharp 60–84 | 3 in 4 | Against Usable: +2.8 wins in 100 (pack, measured) |
| Signature 85+ | Always | Against Sharp: NOT MEASURED |

The card shows "fires 1 in 2" until P2 gives a wins figure, and then it shows "about +n wins in 100". A Playbook line that uses a move which turned Usable this week gets a small "fires 1 in 2" tag (NEW).

**The long trade.** A move at 35 needs about 25 more to reach Sharp, about 4 whole nights (ESTIMATE). Spreading nights to make more moves Usable trades against pushing one to Sharp. Probe P2 prices both, and the coach's pick follows the result (owner question 3).

### 2.5 Mornings: the ability by name, weekly sums
| Session | Ability (Attrs) | Normal | Light ×0.6 / Hard ×1.3 |
|---|---|---|---|
| Roadwork | Stamina | +0.11 | +0.07 / +0.14 |
| Intervals | Stamina (CHECK 5: or Recovery) | +0.11 | +0.07 / +0.14 |
| Heavy bag | Strength (v1 "Power", CHECK 5) | +0.12 | +0.07 / +0.16 |
| Strength | Strength (CHECK 5: or Explosiveness) | +0.12 | +0.07 / +0.16 |
| Speed bag | Speed | +0.10 | +0.06 / +0.13 |
| Slip rope | Defence | +0.13 | +0.08 / +0.17 |
| Shadow | Accuracy (v1 "Technique", CHECK 5) | +0.12 | +0.07 / +0.16 |

The normal gains are CODE; the Light and Hard columns are DERIVED.

**THIS WEEK BUYS** sums each ability: "Stamina +0.22 this week · next whole point in about 3 weeks". The countdown uses the boxer's stored decimal (CHECK 6). Per-morning decimals show on hover only.

Part 3 of 3

## 3. The decisions this creates
1. **Which move gets ready this week,** read against the opponent's style (A or B).
2. **Whether to buy both:** with the sparring night (C), with tiredness (D) or with the pad coach (E).
3. **Breadth or depth:** more Usable moves, or one move toward Sharp (2.4).
4. **Hard or Normal mornings** against the week line and the overreach band.
5. **When to cut a night:** carried-in tiredness of 70+ makes fewer nights worth more.

## 4. The dominant-pick test (bot probe P1)
**The bots** (each one writes its week and leaves the rest to `PadWeek.defaults`):
- **COACH:** the coach's week as it is.
- **NEAREST:** every pad night on the move nearest Usable, and a fourth night added whenever the forecast stays under 80.
- **SWAP:** option C every camp week.
- **PLAN:** pads the move the Playbook rates Beats it against the booked style, and adds no nights.

**The states,** 6 starting cases × 6 opponent styles × 200 seeds:
- carried-in tiredness 40 or 60;
- last week Standard (camp's first week) or Hard;
- pad coach 58 or 74.

**What's measured:** wins in 100 on fight night, injuries in 100 weeks, moves Usable by fight night, tiredness at the first bell.

**Pass lines**
- NEAREST beats COACH, after its injury weeks are counted, in **at most 70%** of states.
- No bot is best in every state.
- Each of COACH, NEAREST, SWAP and PLAN is best in at least 10% of states.

**Where NEAREST should lose** (worked cases above, to be confirmed):
- carried-in 60 with D, which overreaches on Sat;
- a camp's first week, where the load jump hits;
- a style where the nearest move is rated Walks into it.

If NEAREST wins everywhere, the fixes are, in order:
1. raise the pad evening's tiredness;
2. move the overreach band to 75;
3. make fight-week pads sharpen only (owner question 1).

## 5. The play: anticipation and the reward
- **Friday decides the fight.** Under owner question 1 (a), the top strip reads "Check hook: 28.2 of 30 · last night to make it: Fri 20". That's the week's question, answered on one night.
- **The reward when it lands:** the week review stamps "CHECK HOOK: USABLE". Its ring turns to the Sharp target, and the coach's line reads "That hook's ready. Now we sharpen it."
- **The payoff on fight night:** each fire of a move made ready this week logs "Check hook: drilled Fri 20" (fight log line, CHECK 8). It's tallied on the result: "New moves fired 3 times".
- **The miss:** "Not ready by fight night" shows in grey on the booking confirm. The plan writer greys that move's lines, so the choice has a visible price.

## 6. Every menu it appears on (S425)
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter > Week | Seven day columns, night cards with forecast chips, THE TRADE card, tiredness line with the 80 band, injury chip, coach's ghost row, THIS WEEK BUYS | `PadWeek.project`, `PadWeek.defaults`, `PadWeek.drill`, `WeekPlan.full_day`, tiredness rule (CHECK 1) |
| Fighter > Overview | NEXT STEP: "Check hook 28.2 of 30 · Fri 20"; tiredness and injury chip | `PadWeek.project`, tiredness rule |
| Fighter > Fight prep | Each move's tier by fight night; "Not ready by fight night" greys | `PadWeek.project`, `FireLevel.GAME_SHARES` |
| Fighter > Playbook | "Fires 1 in 2" tag on lines using a move made Usable this week | `FireLevel.GAME_SHARES` |
| Booking confirm | Moves ready by the date; tiredness at weigh-in | `PadWeek.project`, tiredness rule |
| Gym > Staff (CHECK 9) | The pad coach's rating, with "Usable Fri 20" if moved to the night | Coach factor (CHECK 3) |
| Week review | Tier stamps, ability sums, injuries and overreach nights | `PadWeek.drill`, ability ledger (CHECK 6) |
| Fight result and fight log | Fires of moves made ready this week, with the night drilled | Fight log (CHECK 8) |

## 7. Owner questions
1. In fight week, do taper pads **(a) only sharpen moves already at 30+** (recommended: real-world "nothing new in fight week", and it makes Friday decide the fight), or **(b) teach at half units?**
2. Rest evenings: may the player add a pad night on one (option D), or only swap a sparring night (C)?
3. The coach's pick: once P2 measures Usable against not ready, should it follow the winning answer (breadth or depth) per opponent style?

## 8. CHECKs
1. Tiredness cost of a pad evening, a sparring evening and a Hard morning, from the rule. The day steps (+7, −2, +6, −2, +5, −6, −8) mix mornings and nights.
2. The code's weekly load measure: night count, or units?
3. Does the pad coach's pad rating feed the gain (0.5 + rating × 0.7%)? Is the 74 coach assignable to one boxer's night?
4. Base injury rate, so the chip can show a percentage.
5. The ability raised by Intervals, Heavy bag, Strength and Shadow (v1 used Power and Technique, which aren't Attrs words).
6. The stored decimal behind "next whole point".
7. Add women's 70 kg to the pack's section 4.4.
8. Does the fight log have a line for one move firing?
9. Where the pad coach is assigned (Gym > Staff, or the night card).

## 9. Self-score (fresh critics decide)
- **Depth 6–7:** a real trade (which move, or pay for both in three different currencies), an overreach band that turns adding nights into a loss when carried-in tiredness is high, breadth against depth, and a dominant-pick probe with pass lines.
- **General design 7:** one vocabulary, a night as the unit, drawn numbers replaced by the rule or cut, every tile with its wire, and the S425 menu table.
- **Play 6:** Friday's question and the stamp, until P1 and P2 run and the page is drawn.

## To reach 10/10
1. Close CHECKs 1–3, then run P1 and P2 and publish the numbers. Tune the pad evening's tiredness until NEAREST loses in at least 30% of states.
2. Get the owner's ruling on question 1, because the fight-night forecast and the Friday tension depend on it.
3. Put P2's Usable-against-not-ready wins figure on every card in place of "fires 1 in 2".
4. Build the forecast chip and the live redraw on `PadWeek.project`, and probe that every chip matches the week review to 0.1.
5. Close CHECKs 5–9, rename the mornings, and add the fight log line for a drilled move.
6. Draw the page below from the kit, then run a critic pass on the drawing.

## 10. The 10/10 page (1920×1080)
- **Header:** portrait, name, "70 kg · Fight Sat 28 · weigh-in Fri 27". This is the only name on the page.
- **Top strip:** "Check hook: 28.2 of 30 · last night to make it: Fri 20", with the ring filling to 30.
- **Centre:** seven day columns.
  - Mornings show the session, intensity, and the ability with its weekly sum.
  - Evenings show night cards, each with "+7.5 mastery" and a tier line.
  - The coach's week sits as a faint ghost row under the player's.
- **Under the columns:** the tiredness line from the rule, with the band above 80 shaded and any overreached night marked. The injury chip sits at its right end.
- **Right column, THE TRADE:** five option cards, A to E, each with both hooks' tiers by fight night and its cost in one line. **Gold** goes on the coach's pick only, with a reason under 70 characters and no numbers.
- **THIS WEEK BUYS:** ability sums with the whole-point countdown, weight on the day against 70.0, and moves reaching a tier.
- **Bottom:** "Back to the coach's week" on the left; **Continue** on the right in green.
- **Fonts:** Bebas Neue for headings, IBM Plex Mono for numbers, nothing under 12. Every number hovers to its rule.
