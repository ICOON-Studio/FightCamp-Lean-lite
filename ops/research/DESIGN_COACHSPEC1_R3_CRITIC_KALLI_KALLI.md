# DESIGN_COACHSPEC1_R3_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ183)

Brief: research/DESIGN_COACHSPEC1_R3_CRITIC_KALLI.md
Sent: 2026-11-15 19:10 | collected: 2026-11-15 19:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm scoring COACHSPEC1 round 3 from the pack and the map you pasted. The repo is still out of reach, so I couldn't open CRITIC_ACCESS.md, the two mockups or the probe scripts.

# COACHSPEC1 round 3: critic score (Kalli, fresh, S459)

**Depth 6 · General design 5 · Play 5.** Depth clears the bar, general design doesn't. That's three fixable faults plus a set of rules nobody has probed, not a broken idea.

**What I read:** the critic pack and the map. **Not opened:** `CRITIC_ACCESS.md`, `staff_hire`, `evening_plan` and the probe scripts. I couldn't reach the repo, so the probe tables are taken as printed.

## DEPTH 6
**What earns it**
- **Two axes, priced.** Stats (an S&C coach, the full-time coach) and moves (a second boxing coach) are separate ladders, and each dearer step buys more at a worse price. Reid + Price ($830) gets the first Sharp move in week 5 against week 10, for only +1.0 stat points. Hale ($1,090) gets +6.5 stat points but a lower pad rate. Neither one wins outright.
- **Your 4 is a real trade.** Holding one pad night (cost 2) loses 1.9% of stats for a Sharp move three weeks sooner. The cost-1 version was near dominant, the probe caught it, and the price changed. That's the loop working.
- **R1–R3 close round 2's exploits.** An S&C hire can no longer lower a morning, a group bonus needs a group, and coached mornings don't stack.
- **The BJJ belt as a career ceiling** (R8) is a decision that matters years later, not just a drill rate.

**What holds it at 6**
1. **No common currency.** Stat points and first-Sharp weeks never turn into wins. The pack gives the conversions: 5 stat points is about 72% wins, and Sharp over Usable is +2.8 wins in 100 per line. Without a wins column, the player can't tell whether $830 for moves beats $1,090 for stats, and nor can a critic. So "no dominant pick" isn't shown yet.
2. **No money pressure.** Routes are priced per week but never set against the club's cash. $1,090 against $450 is a huge step for a club living on dues (rent $1,800 a month, runway warnings at 8 weeks), and the map never shows when a club can afford a route.
3. **The S&C coach ignores tiredness and load.** In real boxing, that's the core of the job: managing load, keeping a camp from overreaching. The game already has fatigue 0–100, overreach at 80 and the 1.5× load jump, and this coach touches none of them. The richest interaction with the existing week is missing.
4. **Three rules have no probe:** R6 (corner), R7's staff growth in 3.7, and the BJJ ceiling over a career. The map says so itself.

## GENERAL DESIGN 5
**What earns it**
- One time model: CoachFit's units are gone, and CoachedMornings plus the training_k minutes are reconciled.
- Built from what exists: CoachAreas, `WeekPlan.coach_for`, `MoveMastery.gain`, StaffRoles, BjjSide.
- A useless option was cut honestly: the mobility choice was priced and dropped.
- The S425 menu table is complete. The sequencing risk (wire CoachedMornings and the training_k split first) is stated.

**Faults**
1. **The corner rule is false to the sport.** At an amateur club show, bouts run one after another, and the same club coach works every corner for that club. Club mates are never matched against each other. "One coach per corner on a two-boxer card" only holds if a club has boxers at two venues on the same night. As written, R6's "real choice" doesn't exist. (General knowledge of England Boxing shows; not verified this session.)
2. **R6 weakens the game as it stands.** Today a good call's edge is ×1.0. Under R6, you at 40 get ×0.96, so every no-coach club, and every club whose coach is busy, gets a worse corner than it has now. Nobody has probed that. Either 1.0 is the floor, or the change needs a probe.
3. **Fixed he for coaches (S412).** The map calls every coach "he": "his 75 min", "he is near his potential", "his days". Rosa Mendez is in the coach market, so the text is wrong on its own data.
4. **Names in body text (S448).** Lucy, Kira, Josh, Reid, Hale and Price appear in rules, rows and worked examples ("Reid's programme", "you take Lucy"). The worked example should say "the women's lightweight", "the boxing coach", "the full-time coach".
5. **Words (S486).** The probe columns say **Power**, which isn't an Attrs word: the morning raises **Strength**. Mobility gives "a small conditioning gain". The Attrs word is **Flexibility**, which is also the round-2 fix the training map already made.
6. **Section order:** 3.6 and 3.7 come before 3.5. Small, but critics quote by number.

## PLAY 5
- The weekly puzzle is real (three boxers, one coach's 225 minutes), but it's a spreadsheet problem with no moment.
- The best felt moment on offer ("you held her pads, the uppercut turned Usable on Wednesday, Thursday's sparring drilled it") isn't paid off anywhere. Nothing on the week review or in the fight log says "you did this".
- Staff growth (+1 per 12 weeks, up to +8) is too slow to feel. The leaving rule is a punishment with no warning shown.

## What each option changes, and what's missing or useless (S403)
| Option | What it changes | Verdict |
|---|---|---|
| Hire a boxing coach (Reid / Hale / Price / Mendez) | Every area's rating, pad rate, coached mornings 2 or 3 | Keep: the core |
| Second boxing coach (R7) | 150 pad minutes a night; first Sharp in week 5 against week 10 | Keep: the moves route |
| S&C A ($100, 2 days, 66/68) | +2.64 stat points in 12 weeks over Reid alone | Keep |
| S&C B ($200, 4 days, 60/60) | +3.79 stat points | Keep. The A against B choice is thin but real (days against rating) |
| Pick the S&C days | Lines up group mornings | Keep |
| Your 4: mornings or a held night (R4) | −1.9% stats against Sharp 3 weeks sooner | Keep: the best decision in the map |
| BJJ coach belt | +0.8 mastery a week; promotion ceiling | Keep the ceiling. The rate alone is marginal |
| Corner pick (R6) | ×0.96 to ×1.09 on a good call's edge | **Useless as written:** the choice almost never exists, and the range is likely under 1 win in 100 (not probed) |
| Staff growth (3.7) | +1 a quarter | **Useless at this rate.** Cut it, or make it faster and visible |
| Athlete teaches beginners | Saves $68, costs her a class | Keep (exists) |

**Missing**
1. **S&C on load:** an S&C day lowers that morning's tiredness or the load-jump multiplier. That's the real job, and it touches the week.
2. **A wins column:** probe each route's 12-week output into fight wins with the pack's conversions.
3. **Coach time against money:** the boxing coach already earns +$350 a week from evening classes. Each class night could cost pad minutes, which is the honest trade every real club makes.
4. **A coach running the fight week,** when the S&C coach plans the taper.
5. **A cap where the roster outgrows the coach:** three fighters at 75 minutes a night is fine, five is not. Section 6 should show the break point.

## To reach 10/10
1. **Rewrite R6.** The corner man is whoever you assign for the whole show, at your rating or theirs, with ×1.0 as the floor so no club gets a worse corner than today. Keep the two-corner clash only for two venues on the same date. Probe the wins difference over 400 bouts, and cut the rule if it's under 1 in 100.
2. **Add a wins column to both probe tables:** 12-week stat points and the first Sharp week turned into wins in 100 against a fixed opponent, using the pack's 5 points ≈ 72% and the measured +2.8. Prove no route is best in every state with a bot probe (stats bot, moves bot, cheap bot) across 3 club sizes and 3 cash starts.
3. **Give the S&C coach a load job.** On his days, Hard mornings cost a third less tiredness (ESTIMATE), and the 1.5× jump multiplier drops by one step. Probe it against overreach weeks.
4. **Fix the words and people.** No fixed he (each coach uses that coach's own pronoun, or none), roles instead of names in body text, Strength instead of Power, Flexibility for mobility. Renumber the sections.
5. **Put the cash runway on the hire card:** "Runway 14 weeks → 9 weeks with this hire", from the existing runway rule.
6. **Pay off the held night.** The week review shows "Uppercut Usable Wed, with you on the pads". The fight log tags fires of moves you made ready yourself.
7. **Fix or cut staff growth.** Make it +2 every 6 weeks, shown on the coach card ("+2 Pads in 3 weeks"), with a notice flag two weeks before an idle coach leaves. Or cut it.
8. **Close the CHECKs:** IBJJF Articles 6.1–6.3 and UKSCA opened and cited by date, and England Boxing coach levels verified.
9. **Show the roster break point:** the pad minutes per boxer at 3, 5 and 7 fighters with one coach and with two.

## The 10/10 page (1920×1080): Club > People > Staff, hire view
- **Header:** the gym name only.
- **Left two-thirds, four role columns:** you, boxing coach, S&C, BJJ (BJJ only with an athlete).
  - Each card has a portrait, a role badge, and the run icons (Mornings, Pads, Corner, Mat), each with its word. Below are five area meters, each with its word, and the weekly count (4 / 2 + 3).
  - Empty slots show two or three candidate cards.
- **Right third, THE ROUTES table.** Columns:
  - $ a week;
  - runway after the hire, in weeks;
  - club stat points in 12 weeks;
  - first Sharp week;
  - overreach weeks prevented;
  - **wins in 100.**

  The row you're hovering lights the card it adds. **Gold** goes on the coach's recommended route only, with a reason under 70 characters and no numbers.
- **Under the table, ON YOUR FIGHTERS:** one row per boxer showing portrait, class, 12-week before → after for the ability that's raised most, and the moves reaching a tier. The rows show no names.
- **Bottom:** "Back" on the left; **Continue** on the right in green.
- **Fonts:** Bebas Neue for headings, IBM Plex Mono for numbers, nothing under 12. Every number hovers to its rule and probe.
