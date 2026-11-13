# COACHFIT_CRITIC_S454_JOHN - John answer (seat queue SQ70)

Brief: research/COACHFIT_CRITIC_S454_BRIEF.md
Sent: 2026-11-13 17:40 | collected: 2026-11-13 18:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Reading COACHFIT1 v3 against the pack now. The full critic return follows.

# COACHFIT1 v3 (S454): critic

Depth **6/10**, play **6/10**. Assigning by area, coach energy as a two-week trade, weekly temper modes and a scheduled taught-out are the right parts. But the fit arithmetic can't reach its own top word, taught-out compares numbers on two different scales, and morning training gets a silent cut of about 40%. Until those are fixed, the probe bars can't be met as written.

I couldn't open `office_a.png` (it's on your computer, which is offline), so I judged from the text.

## 1. Logic check

**The fit:**
- **TOP FIT can never appear.** The parts run from −36 to +20: temper −10 to +8, load 0 to −14, bond −6 to +6, taught out −6 to 0, weakest stat +6. With 50 as the neutral point, the best possible pair is 50 + 8 + 0 + 6 + 0 + 6 = 70.
  - TOP FIT (80+) never shows, and real gains run from about ×0.86 to ×1.08. That's almost the spread v2 was criticised for.
  - The FITPROBE1 bar ("TOP FIT against RISKY ≥ 0.5 a week") can't be tested.
- **Taught-out compares two scales.** A coach's ceiling is an area rating (58–90). A fighter's stat is on the fighter scale (amateur women's lightweights sit 55–65).
  - Luke's pads are 74 and a 60-Technique fighter is already within 14. A ceiling range of 62–74 puts most club boxers within 10 from day one.
  - So −2 to −6 is on almost every row from week one, and "taught out in about N weeks" is meaningless.

**Mornings:**
- **They get a hidden cut.** The pack's rule is that every morning gets the coach factor; with the 74-rated coach that's about 1.02. v3 makes Light and Normal mornings "train alone (0.6)" unless assigned. Most mornings are Normal, so a club with a good assistant loses about 40% of its morning gains.
  - The measured balance (5 stat points is about 72% to win) was built on today's training. It needs re-measuring, or this rule goes.
- **The head coach breaks the 60% rule.** A rating of 60 in the background's area and 45 elsewhere gives a coach factor of 0.92 or 0.82. A club with no assistant then trains at 82–92%, not the pack's 60%, and the first hire loses most of its pull. The map flags `HeadCoach.gd` but not this effect.

**Energy:**
- **The arithmetic doesn't add up.** "A list is 8 normal sessions with room for a corner night" is 8 + 3 = 11, against an energy of 10.
- **"+2 energy at that area's rating 80+" is unclear.** Energy belongs to the coach, not to an area. Does the 90-conditioning coach get 12 for every area?
- **"A Hard session costs 1.5" is unclear for evenings.** Is sparring Hard? Is an evening ever Hard?
- **The demand count is low.** Four boxers × (3 pads + 1 sparring + 1–2 Hard mornings) is 20–24 sessions, not 16–22, before film.
  - Supply is 5 (head coach) + 10 (one assistant) = 15, or 25 with two.
  - So one assistant is always over and two never are. The weekly decision exists only with exactly one assistant and four boxers, which is the Bigger unit.
- **Film is a coached session that belongs to none of the five areas.** Which coach runs it, and what fit does it use?

**Tempers:**
- **Two modes are flat-percentage training perks.** Motivator DRILL (gains ×1.05) and Steady hand BUILD (×1.05 on conditioning) are what the map's rule forbids.
- **"Low mood (under 40)" is wrong.** The pack's bands are Low under 30, Flat 30–49.
- **Technician POLISH "Sharp too from rating 65" doesn't say which rating** (the overall 58 or the pads 74).
- **Drill sergeant PUSH's "plan tests" still have no fight value.**

**Raises:**
- **Say no is always right.** Refusing costs 1 energy a week for 4 weeks, about 4 sessions once. Paying costs $50 a week forever, about $2,600 a year. Nothing says the coach asks again or leaves.

**Bond:**
- **The thresholds don't match the stated timings.** At +1 a session, a pair with 3–4 sessions a week reaches 35 in about 9–10 weeks and 90 in about 25. The map says Trusted at about 6 weeks and Corner at "half a season" in section 6 but "~13 weeks" in section 11.
- **A loss still pays more than a win.** A loss gives +10 plus the corner's +6; a win gives +6.
- **Camps no longer exist for amateurs.** "−20 when moved mid-camp" and the fighter's ask "for the camp" need the fight week, since amateur bouts have no camp.

**The corner:**
- **The player's shouts still aren't settled.** The player is the head coach and makes every shout. The map never says what happens to the player's shouts when an assistant is picked. My reading is that the second passes them on, and the second's bond multiplies them. Say it.
- **"About 4 of 6 calls heard" has no unit.** A bout has 18 exchanges, and the pack lets two instructions a minute through fully.

**Names, pronouns and stat names:**
- **Names on the corner pick break S448.** "Name in the card's header" puts two or three names on one screen. Use portraits and roles ("the pads coach") on the cards, with the fighter's name once in the bout card's header.
- **The fixed pronouns are gone.** "The fighter" and roles are used throughout.
- **"+0.26 Power" uses the summary stat.** Power is read from `Attrs.gd` and isn't trained directly (S448). Use Strength, Explosiveness or Accuracy.

## 2. Depth: 6/10

**Real on paper:**
- **Triage when energy is short.** Who goes "alone" this week, and is going over worth a tired coach next week?
- **The weekly mode.** For example, the Steady hand's TAPER when a bout is inside 14 days.
- **Moving an area before a coach is taught out.**
- **Saying no to a raise.**

**Where it breaks:**
- **The screen solves the week for you.** "Best swap: +0.4" on every row, plus Coach runs it, means the right answer is printed. By week 10, Monday is "press the best swap, Continue". The player can only beat it with what lasts beyond this week (bond by the next bout, growth, taught-out timing), and the table shows that only as a cell label.
- **A spread that's still small.** The real fit range is ×0.86 to ×1.08, so the gains per row differ by tenths of a point.
- **Taught-out is always on** because of the scale mismatch, so it stops carrying information.
- **Load binds only at one assistant with four boxers.** At the starting Unit with 3 boxers, demand is 15–18 against 15, so it barely binds. With two assistants it never binds.
- **Saying no to a raise is always right.**
- **Weekly modes become a habit.** TAPER inside 14 days and BUILD otherwise is a rule the auto pick can follow, so after a month nobody touches the toggle.
- **The bond does matter now.** It's in the fit and in the corner pick, so the "bond never matters" problem from v1 is fixed, as long as the corner rule above is settled.

## 3. Play: 6/10

Growth lines ("62 to 63 in 4 sessions"), a quarrel risk you can see, and a fighter asking for a coach give reasons to look at Monday. But the printed best swap and gains of tenths make the table a chore to approve, not a puzzle.

## 4. Options and menus

| Menu | Verdict |
|---|---|
| Week board rows | Keep the fit word and predicted gain. Use Attrs stat names. "Alone" on every Normal morning is a nerf to today's training. |
| Staff card | Keep. Show the ceiling in fighter-stat units so taught-out reads true. Show energy as "8 of 10". |
| Mode toggle | Keep. Cut DRILL and BUILD as written (flat percentages). |
| Table: "best swap: +0.4" | Remove it. It hands over this week's answer. |
| **Table: missing** | A forward view per cell: weeks until taught out, bond step by the next bout, coach growth ticks this week. |
| Swap this week or for good | Keep. |
| Lock and Copy last week | Keep. |
| Coach runs it | Keep. It must not see the forward columns, so a planning player can beat it. |
| Monday raise (Pay or Say no) | Say no is always right. Needs a repeat ask and a growing cost. |
| Fighter's ask | Keep. Tie it to the fight week, not a camp. |
| Corner pick | Needs the shout rule stated and a unit for "calls heard". Use portraits and roles, not names. |
| Desktop "energy short next week" | Keep. |
| Market filters | Keep. |
| Result page "the unheard call cost about 3 in 100" | Keep, measured by BONDPROBE1. |

## 5. To reach 10/10 (mechanics, most important first)

1. **Make the fit reach its words.** Base 50. Parts: temper and mode −14 to +12; load 0, −8 (1 over), −18 (2+ over); bond −8, 0, +6, +12; taught out −4, −8, −12; weakest stat +10.
   - The best real pair (Corner bond, right mode, weakest stat, in budget) is about 84, so TOP FIT exists.
   - A stranger in the wrong mode while over budget is about 10.
   - Keep gains at ×0.80 to ×1.20 and tiredness at ×1.15 to ×0.85.
   - FITPROBE1 re-sizes all the parts.
2. **Put the ceiling on the fighter's scale.** A coach can teach an area up to a fighter stat of 40 + area rating × 0.4 (ESTIMATE): pads 74 teaches to 70, conditioning 90 to 76, pads 58 to 63. Taught-out is graded against that number, the card shows it ("teaches Accuracy up to 70"), and growth raises it.
3. **Keep today's mornings.** Light and Normal mornings take the head coach's supervision factor. Only evenings and Hard mornings are coached sessions that get the pair's fit. Re-run the 5-point-gap test after the change.
4. **Size the head coach to the 60% rule.** The head coach's sessions use factor 0.6 + 0.004 × (background area rating 60, else 45): 0.84 in the background area and 0.78 elsewhere. A no-assistant club's mornings stay at 0.6, so the first hire still matters.
5. **Fix energy.**
   - A list is 10. A session costs 1; a sparring night or a Hard morning costs 1.5; a corner night costs 3.
   - +2 energy only if the coach's best area is 80+, on the card.
   - Film is a pads-area session at 1.
   - The probe target for one assistant with three boxers at the Unit is 1–2 over in a fight week. The decision has to exist at the start, not only at the Bigger unit.
6. **Settle the corner.** The player always shouts. The chosen second passes the calls on. A call lands at coachability × the morale trust number × the second's bond step.
   - Show "calls heard per round: about 2 of 3".
   - The head coach as second costs 3 of 5 energy, so in a fight week the player chooses between running sessions and working the corner.
7. **Remove "best swap" and add forward columns.** Each cell shows weeks until taught out, the bond step by the next booked bout, and growth ticks this week. Coach runs it optimises this week only. FITPROBE1 bar: a season-planning bot beats Coach runs it by 3+ wins in 100, or the table is cut to a monthly decision.
8. **Make Say no cost more each time.** The coach asks again every 4 weeks until paid. Each refusal adds −1 energy for 4 weeks (stacking) and −2 bond with every fighter on the list. After the third refusal the card shows "will leave at the next offer" (needs the rival gym's offer, AGREED, NOT BUILT).
9. **Replace the flat modes.**
   - Motivator DRILL: a twist card with a mood cost costs 2 less this week.
   - Steady hand BUILD: conditioning sessions don't count in the load ratio this week.
   - Neither changes gains.
10. **Fix the bond rates.** Thresholds 0, 6, 25, 60 at +1 a session, so a pair with 3–4 sessions a week reaches Working in about 2 weeks, Trusted in about 7 and Corner in about 17. Then +6 per corner, +4 for a loss together, −1 a week apart. "Mid-camp" and the ask "for the camp" become "inside the fight week".
11. **Make modes harder to auto-pick.** Each mode reads one fact the auto pick doesn't weigh: the Drill sergeant's PUSH pays +2 mastery on a move one night from crossing a tier. That leaves the player a reason to flip it by hand.
12. **Small fixes:** Low mood is under 30; predicted gains use Attrs names; the Technician's Sharp unlock reads the pads rating; corner cards use portraits and roles with no names.

## The 10/10 Staff app at 1920×1080 (office desktop, full screen)

- **Window title bar, 56 px:** "Staff" with the club name once. Energy across the club ("31 of 35 this week, 28 next"). Copy last week and Coach runs it. The one pulsing button is Confirm the week.
- **Left column, 480 px: THE COACHES.** One card each, by portrait and role:
  - Energy pips ("9 of 10", and "tired: 8 next week" in amber).
  - Area bars, each with "teaches up to 70" and growth progress.
  - The temper word and the A or B mode toggle, with this week's effect in one line.
  - School chips. Wage, with a raise flag when one is asked.
  - The head coach's card on top: 5 pips, the background area, no wage.
- **Centre, 960 px: WHO RUNS WHAT.** Fighter rows (portrait and class) by five area columns, plus a FILM cell.
  - Each cell: coach portrait, a FIT bar with its word, predicted gain ("+0.3 Accuracy"), bond pips, and one tag (FRICTION, TAUGHT OUT IN 3 WKS, or ALONE).
  - A lock icon on each cell.
  - Under each row: weeks until taught out for the soonest area, and the bond step by the next bout.
  - Drag to swap. The ghost shows the new fit, energy, the bond effect, and This week only or For good.
- **Right column, 400 px: WHAT THIS WEEK COSTS AND BUILDS.**
  - Per fighter: the focus gain against Coach runs it.
  - Per coach: growth ticks and energy left.
  - Bonds that cross a step this week.
  - Risks in red: over budget, a 1-in-6 quarrel, taught out inside 2 weeks.
  - On a fight week, the corner pick: the second's portrait and role, calls heard per round, the win swing, and the energy price.
- **Bottom strip, 140 px: THE MARKET.** Four candidate cards (portrait, role, temper, "teaches up to", energy, wage, ceiling range), filters for area, temper, ceiling and wage, and Hire. A greyed card gives its reason.
