# DESIGN_COACHFIT1_V4_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ82)

Brief: research/DESIGN_COACHFIT1_V4_CRITIC_MARIA.md
Sent: 2026-11-13 22:10 | collected: 2026-11-13 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give COACHFIT1 v4 **DEPTH 6, GENERAL DESIGN 4, PLAY 5**, so it doesn't reach the owner's bar. General design fails because the map is cut off and contradicts itself in several places. Three times it says a critic's point is answered when the numbers show it isn't.

## Scores

**1. DEPTH: 6/10**
The weekly triage is real. One assistant can't cover four boxers, so some sessions go uncoached or the coach goes over budget, and over budget is a trade between this week and next. Taught-out is now measured on the fighter's own scale, so the warning means something. Removing "best swap" and adding the row footer (weeks until taught out, bond step by the next bout) gives a planning player an edge over Coach runs it. Paying or refusing a raise is now a real choice.

What keeps it at 6:
- **TOP FIT is only reachable late in a season.** The fit table allows temper and mode from −14 to +12. But the temper table never gives more than +6 (Motivator) or less than −8. So the best real pair is 50 + 6 (temper) + 12 (Corner bond) + 10 (weakest stat) = 78. With Trusted bond it's 50 + 4 + 6 + 10 = 70 at most, which is GOOD. TOP FIT shows only for Corner pairs, about 20 to 28 weeks in by the map's own timing. The probe target of TOP FIT on 20% of rows can't be met.
- **Bond isn't scarce.** It still builds +1 from every coached session, so one pads coach with four fighters at 3 sessions each brings all four to Trusted at the same pace. The probe target of 1 or 2 Trusted pairs per coach fails by design. Kalli's fix (bond only from pads, sparring and corner nights) wasn't taken.
- **Three of the four tempers give the auto pick an obvious answer.** Drill sergeant EASE is just "PUSH off". Steady hand is TAPER inside 14 days and PREPARE otherwise. Technician depends on the fighter's moves. John's fix (a mode that pays on a fact the auto pick doesn't weigh) was skipped, and the map gives no reason.
- **Shared pad nights may stop energy from ever running short.** If one pad night costs the coach 1 energy however many fighters are on it, then 3 pad nights for the whole gym cost 3, and one assistant almost never runs out. If not, four boxers need 24 to 30 energy against 15 (head coach plus one assistant), and someone is always short. The map needs a cap on fighters per session (for example 2) to put the decision in between.

**2. GENERAL DESIGN: 4/10**
- **The map is unfinished.** It stops in the middle of the build order (step 2 ends with "**"). The not-built list and the open questions are missing. The text also still carries the chat app's screen clutter (sidebar, "Chat / Create Videos / Homework"). It can't go to a builder like this.
- **Two morning rules contradict each other.** Section 3.1 says an uncoached morning trains at 0.80 × the head coach's factor. Section 7 says an unassigned session trains at 0.60. Neither one is today's game: the pack gives every morning the assistant's coach factor (0.91 with Luke Reid, 1.02 with Marcus Hale). 0.80 × 0.92 is about 0.74, so the cut Kalli and John flagged is still there. The map's "no silent 0.6 nerf" claim is false.
- **The tiredness formula changes today's balance.** 1.15 − fit ÷ 200 gives 0.90 at the neutral fit of 50, not 1.00. Every ordinary pair gets 10% less tired than today, and a fit of 90 gives ×0.70, beyond the agreed ×0.85. The gain formula also can't reach its own bottom: at the clamped minimum of 10 it gives ×0.84, not the ×0.80 the RISKY row prints.
- **Bond values are in the map twice, with different numbers.** Section 2.1 says −8 / 0 / +6 / +12. Section 6.1 says ±0 / +6 / +10 / +12.
- **The probe numbers don't add up.** 0.45 to 0.65 points a week over 26 weeks is 11.7 to 16.9 points, not the 3.5 to 5.0 the map writes. The weekly target also can't be reached. A fully focused week adds about 0.9 points (pack 4.1), and ×1.16 against ×0.84 is a gap of about 0.29. The bar was lowered from 0.5 to 0.45 and is still out of reach.
- **New silent cuts.** Moves outside a coach's school now learn at ×0.75, so most pad work runs below today's rate. v3 cut only Signature work outside the school. The second club coach is listed as "+$280/week", but that's a cost, not income.
- **Invented or wrong game facts:**
  - The cutman "reduces cut severity by 40%". The pack's cutman halves post-bout layoffs.
  - "Heavy combinations", "Step-back" and "Tight defence" appear as school moves. None is a move in the game, and step arrows have no mastery yet (S448).
  - "Win edge +2.8%" and "cost ~2.7 in 100" are printed as facts before the bond probe exists. Mark them EXAMPLE.
- **Breaks the owner's rules:**
  - "She works best with the pads coach" is a fixed pronoun, against the sandbox rule (S412).
  - "Seeking other work" and "leaves at next month-end if rival offer system is built" put the rival gym's offer on screen. v3 had agreed nothing would mention it until it's built.
  - The header aims at "Depth ≥7, Play ≥7", but the owner's bar is DEPTH and GENERAL DESIGN 6+.
- **Smaller contradictions:**
  - The table has a separate Film column, but section 3.2 puts film under the pads area.
  - "Whole numbers, not hundredths" sits next to "+0.4 Strength".
  - The head coach in the corner is "100% what you say", which breaks the map's own heard-calls formula (coachability and morale still apply).
  - Paying a raise "narrows the ceiling upward by +2", and nobody can say what that means.
  - The menu table dropped the learning-slot cards (SLOTS1) that v3 listed.

**3. PLAY: 5/10**
Reasons to come back: a "taught out in ~4 weeks" countdown, a raise that gets harsher each time you refuse, the corner pick in a fight week, and a fighter asking for a coach. Against that, it's 24 cells and up to four mode toggles every Monday, gains in tenths, and the headline word TOP FIT almost never appears. The third refusal ("−3 energy permanently") is punishment with no way out. That's a dead end, not a story.

## Options: missing, useless, and what each changes

**Missing**
- A cap on fighters per pad night, which decides whether energy ever runs short.
- One morning rule, matching today's numbers.
- A way to repair a refused raise (pay late, after the "Seeking other work" flag), so the third refusal isn't permanent.
- A mode the auto pick can't follow.
- The not-built list, the open questions and the rest of the build order.
- What "−15 for 3 weeks" after a For Good swap is counted in: bond points or fit.

**Useless as written**
- **TOP FIT** before Corner bond: it can't appear.
- **Drill sergeant EASE**: it only switches PUSH off.
- **"Seeking other work"**: it points at a system that doesn't exist.
- **The cutman toggle with "−40% severity"**: the number isn't the game's.
- **The separate Film column**: it contradicts film being part of pads.

**What each option changes**
- **Swap, This week only:** the bond pauses, and the fit is −2 that week.
- **Swap, For good:** the bond carries over, with a 3-week penalty whose unit isn't given.
- **Lock:** Coach runs it skips that cell.
- **Copy last week:** repeats last week's assignments.
- **Coach runs it:** fills this week's best table without looking ahead.
- **Mode toggle:** changes the effect of every session that coach runs that week.
- **Pay:** +$50 a week for good, plus an unclear ceiling gain.
- **Say no:** −1 energy for 4 weeks and −3 bond with every fighter that coach trains. A second refusal makes it −2 for 8 weeks and −6.
- **Hear the ask:** +5 mood and the area moves to that coach. **Overrule:** −5 mood.
- **Corner pick:** changes how many shouts land, and the head coach working the corner costs 3 of their 5 energy.
- **Hire:** adds a coach card and their energy.

## To reach 10/10

1. **Finish the map and clean it.** Strip the chat app's clutter, complete the build order, and restore the not-built list (the Staff app OFFICE2, coach asks after AMATEURWEEK1, STEPMASTERY1, the rival gym's offer) and the open questions. Retarget the header to DEPTH 6+ and GENERAL DESIGN 6+.
2. **One morning rule, equal to today.** An unassigned Light or Normal morning keeps the best staff coach's factor in that area, which is today's number. Assigning a coach adds the fit on top and costs 0.5 energy. The 0.60 applies only with no assistant at all. Delete the 0.80 rule.
3. **Make neutral fit mean "today".** Gain is 0.80 + 0.004 × fit, so ×1.00 at 50, ×0.84 at 10 and ×1.16 at 90. Tiredness is 1.15 − 0.003 × fit, so 1.00 at 50 and 0.88 at 90. Print the word table from those formulas.
4. **Give tempers the range the fit table promises.** Each temper's best case is +12 (right mode and right fighter state) and its worst is −14 (wrong mode on a Flat or Low fighter). Then a Trusted pair in the right mode reaches 50 + 12 + 6 + 10 = 78, so TOP FIT shows by mid-season, not only at Corner bond. Keep one bond table: −8 / 0 / +6 / +12.
5. **Cap a pad night at 2 fighters** (1 energy per night, counted once for growth). This puts four boxers at about 18 to 22 energy against 15 or 26, so the triage exists with one assistant and eases with two.
6. **Make bond scarce.** Bond grows only from pads, sparring and corner nights. Thresholds go to 0 / 10 / 50 / 110. A loss together gives +6, the same as a win, not +10. Probe target: at most 2 Trusted pairs per coach by week 26.
7. **Fix the probe targets so they add up.** TOP FIT against RISKY is worth 0.25 to 0.35 points a week on a fully coached focus area, so 6.5 to 9 points over 26 weeks. TOP FIT shows on 20%+ of rows from week 12 onward. A season-planning bot beats Coach runs it by 3+ wins in 100. If it can't, the table becomes a monthly decision.
8. **Restore school learning outside the school** to ×1.0 for every move, with ×0.5 only on Signature work (v3's rule), and in-school ×1.1. Remove the non-moves from school lists. Step and defence answers join only when STEPMASTERY1 gives them mastery.
9. **Give each temper a mode the auto pick can't read.** Drill sergeant EASE: after a quarrel this week, bond losses are halved and the coach-swap price is waived. Technician TEACH: +2 mastery on a move one pad night from crossing a tier. Steady hand PREPARE: a second Hard morning costs no extra energy. Each pays on a fact the player sees and the auto pick doesn't weigh.
10. **Give raises a way out.** A refused coach can be paid late at any time, which clears the energy penalty after 2 weeks. The third refusal leaves the coach on −2 energy until paid, not permanently. Nothing on screen mentions leaving until the rival gym's offer is built.
11. **Use only the game's numbers.** The cutman is "$150 a pro night, half the post-bout layoffs". Every win swing is marked EXAMPLE until the bond probe measures it. Corner calls are shown per round ("about 2 of 3"). The head coach in the corner uses the same formula, with bond at Corner.
12. **Words and rules.** Replace "She works best..." with "Works best with the pads coach". Fold Film into the pads column. Express Pay's gain as "teaches up to +2". Express the For Good penalty as "−15 bond points for 3 weeks". Restore the SLOTS1 line in the menu table. Show the second club coach as a cost of $280 a week.

These need things the game can't do yet: the office Staff app, per-area coaches on mornings, coach asks, step mastery, and the rival gym's offer.

**My 10/10: the Staff app, 1920×1080, whiteboard style under the dark top bar**
- **Header strip (90 px):** "Staff" and the week, with the only names on the page being on the coach cards. It shows energy used against what's available this week and next ("21 of 26, next week 24"), sessions running alone, and the next fight date circled. Buttons: Copy last week, Coach runs it, and the one pulsing Confirm the week.
- **Left column (460 px), the coaches:** one card each, with the name in the card header and a comic portrait. Each card has:
  - energy pips with a red line past the budget
  - "teaches Accuracy up to 70" with growth ("64 → 65 in 6 sessions")
  - the temper word and a mode toggle, with this week's effect in one line
  - school chips and the wage
  - any raise as a sticky note (Pay / Say no, each with its price)
  - the head coach's card on top: 5 pips, office −1, no wage
- **Centre (1000 px), who runs what:** fighter rows (portrait, class and record) by five area columns.
  - Each cell has a coach magnet, a fit word with a bar, the week's gain in that area ("+0.9 Stamina this week"), bond pips with an "apart" state, and one chip: TAUGHT OUT IN 3 WKS, FRICTION, ALONE or OVER BUDGET.
  - Under each row: the soonest taught-out week and the bond step by the next bout.
  - Clicking a cell opens the swap card with This week only and For good, each with its price.
- **Right column (460 px), what this week costs and builds:**
  - each fighter's focus gain against what Coach runs it would give
  - each coach's growth this week and energy left
  - bonds crossing a step
  - risks marked in red with a symbol: over budget, a 1-in-6 quarrel, taught out within 2 weeks
- **Fight-week strip (bottom left, 200 px, gold frame), only when a bout is within 14 days:** corner candidates by portrait and role, calls heard per round, the win swing marked EXAMPLE until measured, and the energy each gives up. On pro nights the cutman sits beside them as a staff job.
- **Market (bottom right, 200 px):** filters for area, temper, "teaches up to" and wage, and three cards with Hire, greyed with the reason when cash or roster places block it.
