# DESIGN_COACHSPEC1_R5_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ190)

Brief: research/DESIGN_COACHSPEC1_R5_REVISE_KALLI.md
Sent: 2026-11-15 21:10 | collected: 2026-11-15 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm writing round 5 as section 13. It'll answer all of John's points and keep everything Dola scored high.

## 13. Round 5 (S494): each point John found in round 4, and what was done

Part 1 of 4. Round 4 scored depth 8 / general 8 / play 7 from Dola and 7 / 6 / 6 from John, so John's list sets the work. Where this section changes an earlier rule, this section replaces it, and the earlier text is void.

Marks: (P) is proposed and untested, CODE is in the game today, ESTIMATE is worked by hand (the probe decides), and CHECK is for Claude to confirm.

**Kept from round 4 (what Dola scored):**
- the two hire routes, more stats or faster moves;
- class nights trading money against pad minutes;
- the mat coach's belt as a ceiling;
- the wins-in-100 figure printed on every choice, where the choice is made. This was Dola's top 10/10 item, and 13.10 lists each place.

### 13.1 Which second coach (replaces R7 in 3.2 and the "two second coaches")
**One hire, not two.** R7's second boxing coach and the code's **Second club coach** staff job become the same slot.
- **What the slot keeps from the staff job (CODE):** +1 roster place, +40 to the member target, and the job's fitness classes.
- **What the slot gains:** area ratings. It becomes a coach record, like the S&C coach in 3.3.
- **Who fills it:** the two `CoachMarket` candidates at their code wages, $380 and $520 (areas per `CoachMarket.gd:12-17`).
- **What happens to the old wage:** the job's flat $280 wage is retired. CHECK what else reads it.

**What the second coach teaches:**
- 75 pad minutes on every pad night, so two coaches give 150 a night;
- 2 coached mornings a week (sessional);
- the programme takes the better rating of the two coaches per area (as in R7);
- the second coach's own class nights, under 13.2's rule.

**What the second coach doesn't do:**
- work the corner (13.8);
- set the programme's plan (the head boxing coach does);
- take the mat.

**Why merge:** the staff job already adds the roster place that brings in the fourth boxer. The roster break point in section 12 says that's exactly when one coach runs out of pad minutes. So one hire is both the fix and its cause, which makes it a single decision.

### 13.2 How class nights split pad minutes (replaces R13)
**Today stays the default.** A boxing coach's week is 3 pad nights at 75 min each plus 2 class nights for +$350 (CODE, decided numbers). The 75 is what's left of the coach's paid hours after those two classes. Nothing is taken away silently.

**The choice, per boxing coach:** 0, 1, 2 or 3 class nights. Each class is $175 (P), which is $350 ÷ 2.

| Class nights | Money a week | Pad minutes a week (one coach) | Where the minutes go |
|---|---|---|---|
| 0 | $0 | 285 | +30 on two pad nights (105 / 105 / 75) |
| 1 | $175 | 255 | +30 on one night (105 / 75 / 75) |
| **2 (default, today)** | **$350** | **225** | 75 / 75 / 75 |
| 3 | $525 | 195 | −30 on one night (75 / 75 / 45) |

**The limits:**
- The player picks which pad night gains or loses the 30.
- A pad night is never over 105 or under 45 minutes.
- Sparring Thursday is never touched.

**Two coaches share one hall (P):**
- The gym runs at most one class a night and at most 3 class nights a week, whoever teaches them.
- So a second coach adds at most one extra class night (+$175) on top of the default two, and that night costs 30 of their own 75.
- Class income can't double. The hall and the members are the limit (13.4).

**The week review** shows "Classes: +$350 · Pads: 225 min". The class pill on the coach card shows "+$175 · −30 pad min" before the click.

### 13.3 Who owns the deal (replaces R3's last sentence)
**The coach deals and the player decides.**
- **Each Monday the coach proposes a week.** That means the coached mornings placed where each adds most (`CoachedMornings.deal`, greedy) and the group sessions on the S&C coach's days.
- **The player can then change anything.** Drag your coin or the boxing coach's coin onto any morning, or off one. A dragged coin belongs to the player, stays there until the player moves it, and wins over the coach's proposal.
- **Each morning has one runner (R3 still holds).** A coached coin on an S&C day takes that morning off the group: x1.25 for that boxer, no x1.15 group bonus. If a group drops to one boxer, the board warns "group x1.00: alone".
- **The board shows the result, not the rule:** each tile is tinted by its runner and shows that runner's coin.

Dola's "assign a coach to a fighter" wish is the same drag, so it needs no extra screen.

Part 2 of 4

### 13.4 Members never exceed the building (replaces the MEMBERS column in section 12)
**The rule (CODE, from the pack):**
- Members drift up to 6 a week toward a target set by reputation, dues, premises and coaches.
- **Members are capped by the premises.** The Unit holds **70**. The figure is in the pack and lives in the premises data (CHECK the file).
- The player can't buy members, and a coach's lift to the target helps the club reach the cap sooner, never pass it.

**What the Unit can pay:**
- At 70 members, dues are 70 × $8.08 = **$566 a week**, which is the most the Unit's dues can ever bring in.
- At the stand-in 38 members, the room left is 32 members, or **$259 a week**, and filling it takes at least 6 weeks at 6 a week.

**The column, corrected (net of each route's own income, against the cap):**

| Route | Wage change | Income it brings | Net a week | Members needed | At the Unit (38 now, 70 max) |
|---|---|---|---|---|---|
| + S&C A | +$100 | none | +$100 | 13 | Fits (51) |
| + S&C B | +$200 | none | +$200 | 25 | Fits (63) |
| + second coach, $380 candidate (13.1) | +$380 | 3rd class night +$175 (13.2); target +40, capped | +$205 | 26 | Fits (64), with almost no room left |
| Full-time instead of sessional | +$640 | none (same number of coaches, same classes) | +$640 | 79 | **Needs a bigger building**: more than the whole Unit |
| Full-time + S&C B | +$840 | none | +$840 | 104 | **Needs a bigger building** |

**Reading:**
- At the Unit, the second coach and the S&C coach compete for the same 32 members of room. A club can afford one comfortably, not both.
- The full-time coach can't be paid from Unit dues at any membership. So hiring that coach and moving premises are one decision.
- The hire card shows the red line "needs a bigger building" and links to premises. The bigger building's capacity is a CHECK.

### 13.5 What extra pad minutes buy, and where the gain stops (replaces "pads saturate" in sections 6 and 12)
**Pads never saturate across a club.** Round 4's probe drilled one move per boxer, so every move hit Sharp and the line went flat. That came from the probe, not the game.

**Under the game's own rule (`MoveMastery.gd:62-79`):**
- Each pad minute adds mastery to the move being drilled: 2.1 an hour × (1 + 0.40 × the pad holder's rating ÷ 100) × (1 − mastery ÷ the move's cap).
- The (1 − mastery ÷ cap) part is the headroom clamp. Each minute buys less as the move nears its cap, and nothing at the cap.

**The lines a move crosses:**
- **Usable at 30:** the move can fire.
- **Sharp at 60:** +2.8 wins in 100 over Usable, from the pack.
- **Signature at 85:** a further +2.7 wins in 100.

**The gain stops in two places only:**
1. **Per move,** at that boxer's cap for that move. The minutes then go to the next move on the coach's pad card.
2. **Per boxer,** when every move in the boxer's plan sits at its cap. There are 6 punches, the book's combinations, the boxer's own combinations and 10 steps, so in a 12- or 24-week window that's rare.

**Stats use the same clamp:** a pace of 1.0 per focused week × headroom. So a better coach gets a boxer to their potential sooner, never higher. Both routes end at the same ceiling, and what a hire buys is speed.

**Corrected reading of the two routes:**
- The moves route keeps paying after week 10: the next move to Usable, then Sharp, then a Signature line.
- It stops only when the boxer runs out of moves below their caps.
- The round-4 line "the stats routes last a career, the moves route stops at week 10" is withdrawn.
- What's left is a difference in kind:
  - **Stats** raise every exchange a little.
  - **Moves** raise the lines the plan uses.
  - **Both** stop at the boxer's potential.

**The re-probe (13.11 item 2)** drills the full pad card over 12 and 24 weeks, toward Signature, and reports Sharp lines and Signature lines per boxer, converted at +2.8 and +2.7 wins in 100.

Part 3 of 4

### 13.6 The held pad night gets a real cost (replaces R4)
John's sum stands. At a cost of 2 coached mornings (about 0.59 stat points, or 0.14 wins in 100), a Sharp line 3 weeks sooner (+2.8 wins in 100 a bout) wins about 20 to 1 whenever a bout falls in the window. So the cost has to be paid in something that matters in wins: the boxer's load and health. Real clubs know this cost. A full hour on the pads with the head coach is the hardest evening of a boxer's week.

**The rule (P):**
1. **It still costs 2 of your 4,** at most once a week.
2. **The held boxer works the whole 75 minutes,** against a usual share of 25–45. That evening counts as a Hard session in the boxer's acute load. The game's load-spike rule applies unchanged (CODE): a ratio of 1.5+ gives 2–4× injury risk.
3. **Never in a FIGHT WEEK.** The taper belongs to the S&C coach (R12), or to the boxing coach when there's no S&C hire. The button is greyed, and hovering it gives the reason.
4. **The decision box shows the boxer's load before and after.** For example, "Load 1.3 → 1.6 · injury risk ×3", shown in red past 1.5. The move gain and its wins figure sit beside it.

**Why it's no longer always right (ESTIMATE):**
- **On a calm week** (load ratio stays under 1.5), it costs only the two mornings. It's the right pick when a move sits just under a line before a bout.
- **On a heavy week** (ratio pushed past 1.5), training injury goes from 1.3% to 2.6–3.9% that week.
  - An injury costs the booked bout. That's about 50 wins in 100 of an even bout, plus the weeks out (CHECK how long a training injury lasts).
  - 2.6% × 50 ≈ **1.3 wins in 100,** and 3.9% × 50 ≈ **2.0,** against the +2.8 it buys.
  - The pick now depends on the boxer's week. The player has to read the load, not just tick the box.
- **The rival choice is real:** hold the night, or keep the boxer's week under the spike and spend the 2 on mornings.
- **It links to the S&C hire:** S&C mornings cost ×0.85 tiredness (R12) and lower the acute load the same way. That makes room to hold a night safely, which is part of what the S&C hire is worth.

**Pass line for the re-probe:**
- Averaged over a season with the pack's bout spacing, the held night's value in wins, net of injury, must sit within ±30% of two coached mornings (R12 included).
- If it's still above, the cost becomes 3. If it's then below, it goes back to 2.

### 13.7 R12 priced in wins (replaces R12's "unpriced")
**What the S&C coach's load work buys (ESTIMATE until the probe):**
- **×0.85 tiredness on the S&C coach's mornings** means 1 ÷ 0.85 = 1.18× as much training before fatigue reaches 80 (overreached: gains ×0.6, injury ×3). That's about one more Hard morning for every six before overreaching.
- **The same ×0.85 lowers acute load** in the spike ratio (CODE rule, unchanged). John's small point is answered here.
- **The taper:** −3 tiredness at the first bell.

**The probe (S427 method):**
- Run 400 bouts a cell, at par and at −3 tiredness, and report wins in 100.
- If the result is under 1 win in 100, raise the taper to −6, or the cut to ×0.75.

**The hire card adds two lines next to the stat totals:**
- "Hard mornings before overreached: 5 → 6";
- "Fresher at the bell: +n wins in 100".

The route table in 13.10 gets a FRESHNESS column filled by the probe. Until then it reads "probe", never a guess.

### 13.8 John's other points
- **The Ex-pro's 55 is dead after the first hire.** Fix: you work the corner as the second second, beside the head boxing coach, who stays chief second.
  - **Effect:** the Ex-pro adds +0.002 a point of sparring over 40 to a good call (55 gives +0.03), on top of the chief second's edge (P).
  - **Other backgrounds** sit at 40 and add nothing, so this is the Ex-pro's own edge.
  - **CHECK** that England Boxing allows a chief second plus one second in an amateur corner.
- **The women's-coach candidate at 72 sparring** has no source in the code, so it's dropped. The corner list is 40 → ×1.00, 55 → ×1.06, 58 → ×1.07, 66 → ×1.10.
- **The guest professor (R8)** is a one-off fee for each black-belt promotion: $450 (P). CHECK real UK grading and seminar fees.
  - Book it one week ahead. The guest takes one class, and the promotion happens that week if the athlete meets the IBJJF minimum time in belt (CHECK).
  - The no-gi page shows "Black belt needs: a 2nd-degree black belt · your mat coach, or a guest ($450)".
- **Who presses Promote (3.4):** you promote the athlete, within the mat coach's ceiling. The coach's belt sets the ceiling, and the button is yours.
- **Section 4.4's cross-reference** now points to 3.7 for the leaving rule.

### 13.9 Names and fixed pronouns out of the body (S448, S412)
Names stay only in card headers. The body uses role and class words: your boxer, the coach, the women's lightweight, the featherweight, the welterweight, the S&C coach, their days.

| Where | Was | Now |
|---|---|---|
| Section 1, coach rows | Candidate names with wages | "the sessional candidate (`Data.gd:34`)", "the full-time candidate (`Data.gd:37`)", "the `CoachMarket` candidates" |
| 3.0 | "his GROUP session" | "their group session" |
| 3.1 | "Lucy's Normal Stamina morning" | "The women's lightweight's Normal Stamina morning" |
| 3.1, 3.2 | "always Reid", "'Pads' Reid" | "always the sessional coach", "the role badge reads the top area: Pads" |
| 3.2 | "Mon Lucy 45 / Josh 30; Wed Kira 75 (you take Lucy); Fri Josh 45 / Lucy 30" | "Mon lightweight 45 / welterweight 30; Wed featherweight 75 (you take the lightweight); Fri welterweight 45 / lightweight 30" |
| 3.2, section 6 | "Reid + Price", "Hale" | "sessional + second coach", "full-time coach" |
| Section 4 | "hold her pads", "costs her one class", "her promotions" | "hold the pads", "costs the athlete one class", "the athlete's promotions" |
| Section 5 | "his days", "out-rates him", "You held her pads", "her ceiling" | "their days", "out-rates them", "You held the pads", "the athlete's ceiling" |
| Section 6 | "Hale stays the most points" | "the full-time coach stays the most points" |

The probe scripts keep their own labels, and no screen reads from them.

Part 4 of 4

### 13.10 The route table as the hire card shows it (replaces section 12's table)
Each route below is compared with the sessional coach alone. Stats are from section 6's probe, converted at 4.4 wins in 100 a point, spread over 3 boxers and 6 stats.

| Route | Net a week (13.4) | Stats: wins in 100, each boxer, 12 wk | Moves: first Sharp | Freshness (R12) | At the Unit |
|---|---|---|---|---|---|
| Sessional alone | — | — | week 10 | — | — |
| + S&C A | +$100 | +0.6 | week 10 | probe | Fits |
| + S&C B | +$200 | +0.9 | week 10 | probe | Fits |
| + second coach | +$205 | +0.2 | **week 5**; keeps paying past week 10 (13.5) | — | Fits, no room left |
| Full-time | +$640 | +1.6 | week 10 (pads 58, slower) | — | Needs a bigger building |
| Full-time + S&C B | +$840 | +2.1 | week 10 | probe | Needs a bigger building |

**Where the wins-in-100 figure is printed, at the choice:**
- each hire candidate's card;
- the class-night pill;
- the held-night decision box, with the load line from 13.6;
- the S&C day chips, as "+n wins in 100 this block".

**Dola's other wishes:**
- **Coach to fighter:** this is the 13.3 drag.
- **R12 visible:** done in 13.7.
- **The leaving warning:** kept (3.7).
- **Visiting coaches, coach traits, short contracts:** not added. They're new content, and this round fixes what's undefined. They go under Later.

### 13.11 Every menu the coach roles appear on (S425; replaces section 5)
| Menu | What shows | Wired to | Exists? |
|---|---|---|---|
| Club > People > Staff | Role cards: you, boxing coach, second coach, S&C coach, mat coach. Each shows what it runs, area meters with their words, the coin count, the class-night pill (+$175 / −30 pad min), the route table (13.10) and the red "needs a bigger building" line | `Data.COACHES`, `CoachMarket` (+ role), `StaffRoles` (the second coach and S&C become coach records), `BjjSide` (+ belt), premises cap | Page exists; roles NEW |
| Fighter Week (training board) | S&C day chips, the coach's minutes by face, tiles tinted by runner, draggable coins (13.3), the held-night box with load before and after (13.6), "group x1.00: alone" warning, THIS WEEK totals | `WeekPlan.coach_for` per slot, `CoachedMornings.deal`, `PadWeek` nights per boxer, load-spike rule | Board exists; roles NEW |
| No-gi athlete page | The mat coach's belt and drill rate, "can promote up to", the guest professor ($450), your Promote button | `NoGi.DRILL_GAIN` × belt, `BjjSide.coach_week`, R8 ceiling | Page exists; belt NEW |
| Premises | The member cap (the Unit: 70), "a full-time coach needs a bigger building" | Premises data, members drift (CODE) | Exists; link NEW |
| Money | Wages grouped by role; class-night income per coach | `StaffRoles.wages`, `GameMoney`, `BjjSide.money` | Exists; grouping NEW |
| Week review | "Classes: +$350 · Pads: 225 min", the S&C morning gains, "You held the pads on Wednesday: the uppercut turned Usable", the no-work warning | `WeekPlan` results by slot, `MoveMastery` tier change | Exists; lines NEW |
| Fight log / result | "The uppercut from Wednesday's pads landed 3 times" | `FightStats` by move + the slot record | NEW |
| Fight-night corner | Chief second (head boxing coach) and, for the Ex-pro, you as second; "+7% on a good call" | `Exchanges.call_edge` × R10 (+ 13.8) | Partly; effect NEW |

### Open questions for the owner (taste and scope)
1. Merge the second boxing coach into the Second club coach job (13.1), or keep them as two hires?
2. Should holding a night carry injury risk (13.6), or would you rather keep the cost in your 4 only (cost 3)?
3. Cap the gym at 3 class nights (13.2), or let a bigger building run more?
4. Guest professor at a flat fee, or only through a hired black-belt coach?

### To reach 10/10
1. Re-run both probes with 13.2, 13.6 and 13.7 on, using a full pad card over 12 and 24 weeks. Fill the FRESHNESS column, and test the held night's season value against the ±30% line.
2. CHECKs:
   - the premises file and the bigger building's cap;
   - the staff job's fitness-class income and what reads its $280;
   - `CoachMarket` areas;
   - training injury length;
   - England Boxing's rule on seconds;
   - UK grading fees;
   - IBJJF time in belt.
3. Redraw `staff_hire` and `evening_plan` with 13.9's words, the drag coins, the load line and the cap line.
4. Send to two fresh critics for the depth-7 gate.

### The 10/10 page (1920×1080, Club > People > Staff)
- **Top bar:** dark shell; the gym name once in the header.
- **Left:** five role cards with portraits, meters and pills.
- **Right:** the hire chart, with stats wins across, moves up and the red cap line.
- **Bottom:** the held-night box, showing "Load 1.3 → 1.6 · injury ×3" beside "+2.8 wins in 100 before Sat 28".
- **Kit:** gold only on the selected hire, green only on Continue. Bebas Neue and IBM Plex Mono, nothing under 12.
