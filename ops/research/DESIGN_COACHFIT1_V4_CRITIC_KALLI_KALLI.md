# DESIGN_COACHFIT1_V4_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ81)

Brief: research/DESIGN_COACHFIT1_V4_CRITIC_KALLI.md
Sent: 2026-11-13 22:10 | collected: 2026-11-13 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring COACHFIT1 v4 now. The critique follows in parts.

Part 1 of 3

# COACHFIT1 v4: critic (S459, Kalli)

**Depth 6/10, General design 4/10, Play 6/10.** It doesn't pass the S459 bar yet, because General design is under 6.

I judged from the map's text and the pack. I didn't open CRITIC_ACCESS, the Miro board, the screens or the code, and the map names no mockup.

**What v4 fixes:**
- The fit now reaches its top word.
- The flat +5% modes are gone.
- Turning down a raise now costs more each time.
- "Best swap" is removed.
- Film gets its own column.
- Swapping for good keeps the bond.
- The fighter's ask fires only when it means something.
- The player always shouts, and stacked call multipliers are capped.

**What still breaks it:**
- Two bond tables disagree.
- The mornings rule contradicts itself and still cuts today's training.
- The probe targets contradict each other and can't be met.
- One shared pad night for every fighter breaks the energy limit.
- The map stops partway through section 13.

## 1. Logic check

**The fit**

1. **The bond table appears twice with different numbers.** Section 2.1 gives Stranger −8, Working 0, Trusted +6, Corner +12. Section 6.1 gives ±0, +6, +10, +12. The fit's range, the tier words and both probes depend on which is right.
2. **Average fit now cuts tiredness for everyone.** Tiredness = 1.15 − fit/200 gives ×0.90 at the neutral 50, not ×1.00. v3 had ×1.00 at 50. Every session in the game gets 10% less tiredness from this alone. That moves overreach (80+) and the load-spike rule without anyone choosing it.
3. **The tier table doesn't match the formula.** The fit can't go below 10, so the lowest gain is ×0.84, not the ×0.80 printed for RISKY.
4. **The probe targets contradict each other.** "0.45-0.65 a week" times 26 weeks is 12 to 17 points, not "3.5-5.0 over 26 weeks". The reachable spread is about TOP FIT 80 (×1.12) against RISKY 25 (×0.90). On a focused week of about 0.9 points, that's roughly 0.2 a week, so the weekly target fails and the season target only just holds. Pick the season target.
5. **"Whole numbers, not hundredths" sits next to "+0.4 Strength".** One session is about a fifth of a week's gain (about 0.2), so the row can't show a whole point. The table in section 10 says "weekly gain", but section 2.2 says "every session row". Settle on a weekly total per area.

**Mornings and the head coach**

6. **Section 3.1 and section 7 give different rules.**
   - 3.1: an unassigned morning trains at 0.80 × the head coach factor.
   - 7: an unassigned session trains at 0.60, and the head coach factor applies only when assigned.

   Under both rules, a club with a 74-rated assistant drops from today's 1.02 on mornings to 0.65-0.74 or 0.60. "Today's training numbers remain intact" is false. CHECK (Claude): which coach factor CoachAreas gives a morning today.
7. **The head coach's factor is kept at 0.92 / 0.815.** John's sized version (0.84 / 0.78) wasn't taken, and section 7 doesn't say why. The first hire still only adds 0.10 over the head coach.
8. **The head coach in the corner hears "100% what you say".** That breaks the pack: morale trust reaches the corner whoever stands there (Low 0.7), and a Low fighter stops listening. The cap formula has to apply to the head coach too.
9. **Corner cost against the office.** The head coach has 5 energy, 1 goes to the office and 3 to a corner night, which leaves 1. The map prints "loses 1 session slot", but it's 3. Change the text.

**Energy**

10. **A shared pad night costs 1 energy whoever comes.** Nothing caps how many fighters share it or splits the 240 units (PadWeek). Four fighters on one pad night is then 1 energy, and the energy limit disappears. Today PadWeek splits a night's units over its cards.
11. **Normal and Light mornings cost 0.5 when assigned.** That's a new cost, which is fine, but with point 6 the player pays energy just to get back today's numbers.
12. **The second club coach.** "+40 members, +$280/week" reads as income. In the pack, $280 is that coach's wage. "−5 from the member growth target that week" doesn't fit a target that moves at most 6 a week. Say whether it's the target or one week's change.

**Growth and raises**

13. **Pay "narrows the ceiling upward by +2" needs plain words.** Write it as "teaches up to +2".
14. **The raise doesn't come back.** A second refusal only happens at the next 5-point raise, about 9 weeks later at 15 sessions a point, so "within 12 weeks" just works. Without John's repeat ask, a coach who's turned down once stops asking until they grow again. Also unstated: what the next raise asks for, and whether a refused raise carries over.
15. **The permanent −3 energy.** When the rival gym isn't built, the third refusal leaves the coach on −3 energy for good. That's 27% of an assistant forever, and you can't undo it by paying later. Add "Pay now ends it".

**Tempers**

16. **The quarrel is gone.** v3's FRICTION rule (1 in 6, −15 bond, −5 mood) isn't in v4, yet EASE still says "no friction risk" and the warning tags still list FRICTION.
17. **PUSH now gives −8 only with Low.** v3 also applied it with Flat. With the quarrel gone, PUSH has no cost with a Flat fighter.
18. **SHIELD barely does anything.** Twist cards come once a week and only some carry a mood cost, so "−2 less" is about 1 mood a week. LIFT gives +3 a week to every Flat or Low fighter, so SHIELD loses whenever anyone is Flat.
19. **PREPARE's 1.7 limit has no clear target.** The load ratio belongs to the fighter, not the coach. Say it reads "the fighter's ratio this week, when this coach runs the Hard sessions".
20. **The modes can still be picked by a rule.** TAPER under 14 days, otherwise PREPARE. John's point 10 (give each mode a fact the auto-pick doesn't weigh) isn't answered, and MODEPROBE1 states the hope as a target without a mechanism.

**Schools**

21. **"Outside school ×0.75" is a new cut.** v3 cut only Signature work outside the school, to ×0.5. Now most moves learn 25% slower than today's pads rate of 2.1 an hour.
22. **Stacking and invented moves.**
   - School ×1.15 times POLISH ×1.15 is ×1.32 with no cap.
   - "Heavy combinations" and "Tight defence" aren't moves in the game.
   - "Step-back" is a StrikeMap arrow with no mastery until STEPMASTERY1.
   - "1-2" is a book combination, which is allowed.

**Bond**

23. **Bond is still not scarce.** +1 for every coached session, including mornings, with thresholds 10/45/90. One pads coach on four fighters gets all four to Trusted in about 12 weeks. That breaks BONDPROBE1's own "≤1-2 Trusted pairs a coach".
24. **A loss still pays more than a win (+10 against +6).** It's also unstated whether the bout bonus goes to every coach on that fighter or only the corner.
25. **"−15 for 3 weeks" after a swap.** It doesn't say whether that's bond points or fit. It also falls on the new pair, not on the coach who lost the area.

**The corner**

26. **"Calls heard ~5 of 6" still has no unit.** The pack lets two instructions a minute through fully. Use "about 2 of 3 a round".
27. **Wrong word and invented number.**
   - "Win edge +2.8%": the game says "in 100".
   - "Cutman reduces cut severity by 40%": the pack says the cutman halves post-bout layoffs.
   - A cutman toggle on an amateur bout doesn't exist, because the cutman is pro nights only.

**Words and rules**

28. **Fixed pronoun.** "She works best with the pads coach" breaks S412.
29. **Class words.** "Welterweight wants the pads coach" and "Trusted with your lightweight": welterweight isn't an amateur class here. Use the class in kg.
30. **"Reassign for camp?"** Amateur bouts have no camp. Use "for the fight week".
31. **Missing from the map:**
   - No owner rule is quoted (S448 and S412 aren't in the map).
   - Many numbers have no ESTIMATE mark: school ×1.15 / ×0.75, the bond bout values, the raise penalties, the 0.80 supervision factor.
   - It uses emoji and claim ticks ("✅ Answers Kalli #7") whose numbers don't match: my #7 was the flat modes, not bond.
32. **The map is cut off.** Section 13 stops at step 2. "Held back / not built" and "Open questions" are in the contents but missing.
33. **Names.** None found outside headers, apart from the pronoun in point 28. Corner cards use portrait and role, which is right.

Part 2 of 3

## 2. Depth: 6/10

I tested it with four boxers at the Bigger unit, the head coach and one assistant.

**Real choices now:**
- **Energy triage.** Demand is 3 pads + sparring (1.5) + 1-2 Hard mornings (1.5) per boxer, about 6-7.5 each and 24-30 for four, against a supply of 15-17. Someone trains unassigned, or someone goes over budget and pays next week. With three boxers at the starting Unit it still binds (18-22 against 15-17). That fixes John's point that it only bound at one size.
- **Raises.** Paying ($2,600 a year) against compounding refusals (energy, bond, permanent −3) is close enough to need judgement.
- **Drill sergeant PUSH or EASE**, read from the fighter's mood and discipline.
- **Technician POLISH or TEACH**, read from the move tiers.
- **Moving an area before it's taught out.** Now meaningful, because the ceiling is on the fighter's scale ("teaches up to 70").
- **Who works the corner** against the head coach's energy in fight week.

**What holds it at 6:**
- The shared pad night (logic 10) solves energy for free once a player finds it.
- Bond still makes almost every pad pair Trusted, so it stops telling pairs apart.
- TAPER / PREPARE and LIFT / SHIELD each follow a rule, so two of the four mode toggles are automatic.
- The weekly gap between TOP FIT and RISKY is still about 0.2 of a point, so it's felt over a season, not a week.

## 3. General design: 4/10

The parts are mostly the game's own (CoachAreas, PadWeek, StaffRoles, twist cards, the load ratio), so it's buildable. But it breaks itself or the game in about a dozen places:
- The two bond tables.
- The two morning rules.
- Tiredness at neutral fit.
- Probe targets that disagree.
- A head coach who hears 100%.
- The ×0.75 cut outside a coach's school.
- Invented moves and an invented cutman number.
- A fixed pronoun and a pro class word.
- No owner rules quoted.
- A map cut off at section 13.

## 4. Play: 6/10

**It pulls me on:**
- "Teaches Accuracy up to 70" and "taught out in about 5 weeks".
- A coach reaching 80 so the Technician's Sharp line opens, about 11 weeks in.
- A raise that bites either way.
- The corner pick with its energy price.
- Comparing the week against Coach runs it.

**Holds it at 6:** four buttons in the top bar, up to 24 cells a week, and two modes that are automatic.

## 5. Options

**Missing:**
- A cap on fighters per shared pad night, with how the 240 units split across them.
- A repeat raise ask, and "Pay now" to end working to rule.
- Let go on a coach card. The pack's staff jobs cost a week's pay to let go, and the main assistant is NOT ESTABLISHED.
- The quarrel row and its three answers (switch to EASE, move the area, keep going).
- A unit for calls heard ("about 2 of 3 a round").
- A season bar for Coach runs it (John: a planning bot beats it by 3+ in 100).
- Section 14 (what's not built) and section 15 (open for the owner).

**Useless as written:**
- "View contract": coaches have no contract system.
- The cutman toggle on amateur bouts.
- SHIELD (about 1 mood a week).
- "Lock All" beside per-cell locks and Copy last week: it adds a fourth button and duplicates them.
- "Head coach 100% heard": that choice always wins until it's fixed.

**What each option changes:**

| Option | Changes |
|---|---|
| Swap, this week only | the pair for one week; bond paused; −2 fit |
| Swap, for good | the area's coach; bond kept; −15 (unclear what) for 3 weeks |
| Lock cell | Coach runs it skips the cell |
| Copy last week | refills the table |
| Coach runs it | best table for this week only |
| Mode toggle | one effect per temper for the week |
| Pay / Say no | wage +$50 and teaches-up-to +2 / energy and bond penalties, compounding |
| Corner pick | calls heard, against energy |
| Fighter's ask: hear / overrule | +5 mood and reassign / −5 mood |
| Hire (market) | a new coach card |

**The menus:**

| Menu | Right place? | Wired? | Can't act on or wrong |
|---|---|---|---|
| Week board, Training | Yes | CoachFit, CoachEnergy, PadWeek, WeekPlan | per-session "+0.4" against weekly; tiredness at neutral |
| Staff app, coach cards | Yes | CoachEnergy, CoachGrowth, CoachSchool, StaffRoles | View contract useless; no Let go |
| Staff app, table | Yes | CoachFit, Bond, CoachEnergy, WeekPlan | shared pad night unpriced; FRICTION tag has no rule |
| Staff app, market | Yes | StaffRoles, CoachSchool | fine |
| Office desktop | Yes | OfficeDesk, "Notifications" (no such system named in the pack) | wire it to Needs |
| Fighter page, Training | Yes | CoachFit, Bond | fine; show "apart" |
| Fighter page, moves | Yes | CoachSchool, MoveMastery | the ×0.75 cut shows on most bars |
| Monday review | Yes | CoachGrowth, Bond, WeekCoach | "Welterweight" and "lightweight"; "for camp" |
| Bout card, fight week | Yes | Bond, CoachEnergy, FightCorner | cutman toggle on amateur nights; "%" |
| Fight night, shouts | Yes | Exchanges, Bond | head coach at 100% |
| Result page, the Why | Yes | FightWhy | "2.7 in 100" needs BONDPROBE1 first |

Part 3 of 3

## 6. To reach 10/10

Most important first.

1. **Finish the map and use one table for each thing.**
   - One bond table. I'd keep 2.1's: Stranger −8, Working 0, Trusted +6, Corner +12.
   - One morning rule.
   - Restore sections 13-15 in full.
   - Quote S448 and S412 at the top.
   - Mark every new number ESTIMATE.
   - Drop the emoji and the "Answers #n" ticks, and put a two-column table of critic point against change in their place.
2. **Price the shared pad night.** Up to 2 fighters share a pad night for 1 energy, and each gets 120 of the 240 units (PadWeek's split). A third fighter needs a second night. FITPROBE1 checks that sharing never beats separate nights on mastery.
3. **Keep today's mornings.**
   - An unassigned Normal or Light morning trains at today's factor: the best coach on staff in that area, or 0.6 with no assistant.
   - Assigning a coach (0.5 energy) adds the fit on top.
   - Delete section 7's "unassigned = 0.60" line.
   - Re-run the 5-point-gap test (5 points ≈ 72% to win).
   - CHECK (Claude): CoachAreas' morning factor today.
4. **Make neutral fit neutral.** Tiredness = 1.15 − 0.003 × fit, which gives ×1.00 at 50 and ×0.88 at 90. Gains stay 0.80 + fit/250, and the RISKY floor is printed as ×0.84.
5. **One probe target that can be met.** TOP FIT against RISKY is worth 3.5-5.0 points in a focused area over 26 weeks. Drop the weekly figure. Rows print the week's total per area ("pads this week +0.9 Accuracy"), not per session.
6. **Make bond scarce.**
   - Only pads, sparring and corner nights build it (+1 each). Mornings don't.
   - Thresholds 0 / 10 / 45 / 110.
   - Bout bonus only to the corner coach: +4 win, +4 loss.
   - The −20 falls on the coach losing the area for good, not on the new pair.
   - Target: one pads coach reaches Trusted with 1-2 of four fighters in a season.
7. **Every voice in the corner goes through the cap.** Calls heard = coachability × morale trust × bond, capped at 1.10 with a floor of 0.5, for the head coach too, whose bond is the Loyalty "known" level. Print "about 2 of 3 calls heard a round" and "+n in 100". The corner costs the head coach 3 of the 4 sessions left after the office, and the text says 3.
8. **Bring the quarrel back.** PUSH with a Flat or Low fighter shows FRICTION. Each week at friction there's a 1 in 6 chance of a quarrel (−15 bond, −5 mood) (ESTIMATE). The row offers three answers: EASE, move the area, keep going.
9. **Two modes the auto-pick can't solve.**
   - Motivator SHIELD becomes TALK: the next corner TALK from this coach's fighters lands one step better (calm to fire up), so it reads the fight calendar against mood.
   - Steady hand PREPARE: +2 mastery on any move one session from a tier, which the auto-pick doesn't weigh.
   - MODEPROBE1 bar: the hand-set mode beats the rule pick in 1 week in 4.
10. **Schools without a cut.**
    - Outside the school, today's rate (×1.00).
    - In the school ×1.10.
    - School and POLISH capped at ×1.20 together.
    - Head coach schools use only game moves and book combinations (Old hand: Jab, Lead hook, Check hook, 1-2).
    - Step-back joins after STEPMASTERY1.
11. **Close the raise loop.**
    - The coach asks again every 4 weeks until paid.
    - Paying ends working to rule at once.
    - The permanent −3 energy only applies once the rival gym exists. Until then a third refusal gives −2 energy for 8 weeks again.
    - RAISEPROBE1: Pay chosen 40-60% of the time.
12. **A season bar for Coach runs it.** A planning bot beats it by 3+ in 100 over a season, or the table becomes a four-weekly decision.
13. **The head coach's factor.** Take John's sizing: 0.6 + 0.004 × rating, which gives 0.84 in the background area and 0.78 elsewhere. A no-assistant club stays at 0.6 on unassigned sessions, so the first hire matters.
14. **Small fixes:**
    - The second club coach costs $280 a week; drop "+$280".
    - Use member target −5 while assigned.
    - Cutman: halves post-bout layoffs, pro nights only, no toggle on amateur bouts.
    - Classes in kg.
    - "For the fight week", not "for camp".
    - No "She".
    - Cut View contract and Lock All.
    - Add Let go (a week's pay).
    - "Notifications" becomes the Needs pin.
15. **Not built yet:**
    - The Staff app (OFFICE2).
    - Per-area morning coaches.
    - The asks mechanic for coaches (after AMATEURWEEK1).
    - STEPMASTERY1.
    - The rival gym's offer.

## 7. The 10/10 Staff app at 1920×1080

**Frame:** the shell (dark top bar, left rail), with a full-screen office desktop window in Look B: a whiteboard, marker and magnets. The only names on screen are in each coach card's header.

**Window bar (64 px):**
- "Staff, week n".
- Energy for the club: "used 26 of 30, next week 28".
- Sessions unassigned this week.
- Next fight week.
- Copy last week and Coach runs it.
- One pulsing button: Confirm the week.

**Left, coaches (460 px):** one stacked card each. The head coach is on top (4 pips after the office, background area, no wage). Each card has:
- Comic portrait with the name in the header.
- Temper word and the A / B mode toggle, with this week's effect in one line.
- Energy pips ("9 of 11", red past the line, "tired: 9 next week" in amber).
- Area bars with "teaches Accuracy up to 70" and "64 to 65 in 8 sessions".
- School chips, wage, a raise flag (Pay / Say no, each with its cost), and Let go.

**Centre, who runs what (980 px):** fighter rows (portrait, class in kg, record) by six columns: Pads, Sparring, Film, Conditioning, Strength, Bag.
- **Each cell:** a coach magnet, the fit word and bar, the week's points for that area, bond pips (hollow when apart), one tag (FRICTION, TAUGHT OUT IN 3 WKS, OVER BUDGET), and a lock.
- **Pad cells:** a shared night shows "2 of 2" sharing.
- **Under each row:** the soonest taught-out and the bond step by the next bout.
- **Swapping:** drag a magnet to swap. The ghost shows the new fit, energy, bond, and This week only / For good.

**Right, what this week builds (480 px):**
- Each fighter's focus gain against Coach runs it.
- Each coach's growth ticks and energy left.
- Bonds crossing a step.
- Risks in red: over budget, a quarrel chance, taught out inside 2 weeks.

**Bottom-left, fight week strip (only with a bout within 14 days; the one gold frame):**
- Corner candidates by portrait and role.
- "About 2 of 3 calls heard a round", "+n in 100", and the energy each gives up.
- On pro nights, the cutman card beside them.

**Bottom-right, market (480 × 200 px):**
- Filters for area, temper, teaches-up-to and wage.
- Three cards, each with Hire (greyed with its reason).

There's no fit total and no best-table badge. Hovering any number shows its parts. Green is used only for Continue.

**CHECKs:**
- CHECK (Claude): CoachAreas' morning factor and the "no coach" case; how PadWeek splits a shared night.
- CHECK (John): amateur corner seconds, and whether the head coach may stand behind an assistant.
