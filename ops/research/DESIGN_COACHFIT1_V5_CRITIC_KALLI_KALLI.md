# DESIGN_COACHFIT1_V5_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ99)

Brief: research/DESIGN_COACHFIT1_V5_CRITIC_KALLI.md
Sent: 2026-11-14 04:11 | collected: 2026-11-14 04:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# COACHFIT1 v5: critic score (S459, fresh critic)

Part 1 of 3

**DEPTH 6, GENERAL DESIGN 4, PLAY 5. It is not designed yet: General design is under the bar.**

The idea is strong now. Who runs which area, a coach's energy, a slow bond and a raise you can refuse are real trade-offs that touch training, the corner and money. What sinks it is the build: the numbers contradict the pack in four places, it relies on a coach market and on tempers the game doesn't have, and the menu wiring table was cut off.

## DEPTH 6

**What works:**
- **Energy is a real budget.** Over budget borrows from next week, and the corner costs 3 of 11. Putting the coach in the corner competes with training, which is right.
- **Bond builds slowly from evenings and the corner only,** and it decays when a pair works apart. A swap "This week only" against "For good" is a real choice.
- **A raise is a closeable loop,** and Pay restores the teaches-up-to ceiling, so Say No has a price you can see.
- **Each mode changes one mechanic,** not a flat percentage. Drill sergeant PUSH against a Flat or Low fighter carries quarrel risk, so the mode depends on the fighter's state.

**What holds it at 6:**
- **Weakest stat match +10 always wins.** It's the biggest single part of fit, and nothing ever makes it wrong. Every row will chase the lowest stat, which takes away the player's focus choice.
- **Early on there's nothing to decide.** The club starts with one assistant and the head coach. Two coaches and one fighter make a 2-way choice per area, and the table only gets interesting with 3+ staff and 3+ fighters, which comes late.
- **The fit spread is small.** The multiplier runs ×0.84 to ×1.16, against training's 5 points = 72% wins (pack). FITPROBE1's 6.5–9 points over 26 weeks is meaningful, but the weekly cell shows +0.8 against +0.9, which a player won't feel.
- **Modes are mostly set-and-forget.** Steady hand is TAPER when a bout is close and PREPARE otherwise, so the calendar picks it. Motivator LIFT is right for every Flat fighter. Only Drill sergeant and Technician depend on the fighter's state.

## GENERAL DESIGN 4

**It contradicts the pack:**
1. **The head coach factor.** v5 uses 0.6 + rating × 0.004. The pack has coach factor = 0.5 + rating × 0.7% and no coach at all = 60%. The head coach has no rating in the game; the edge is one of four perks. "0.84 in background specialty (60)" invents a rating.
2. **"Sharp unlock at 80 rating" (Technician POLISH).** This puts a coach-rating gate on a tier the pack sets at 60 mastery for every move. It would lock Sharp for every club with a pads coach under 80.
3. **Calls heard.** The pack says "only two instructions per minute get through fully", and morale trust is 1.05 / 1.0 / 0.85 / 0.7. v5 multiplies morale × coachability × bond factor, capped at 1.10 with a floor of 0.5:
   - Coachability is a 0–100 value.
   - The bond factor has no number.
   - A "success rate" of 1.10 isn't a rate.
   - "About 2 of 3 calls heard a round" mixes the minute unit with the round (a round has six exchanges).
4. **The fighter's ask text** reads "Welterweight — 60kg". 60 kg is lightweight, and there's no amateur welterweight class in the code.

**It isn't buildable from what the game has:**
- **No market.** The game has two hire cards and staff jobs. The Market row (filters by area, temper, ceiling, wage) needs coach generation that doesn't exist, and the map doesn't list it as a system to build.
- **No tempers or schools.** Neither assistant has a temper, a school or per-area ratings beyond pads and conditioning. v5 doesn't say what temper each existing coach gets.
- **Coach Runs It** is AGREED, NOT BUILT. It sits in the top bar as if it were built.
- **"Film (folded into Pads on mobile)".** This is a PC game, and the owner ruled out mobile.

**It contradicts itself:**
- Over budget is allowed and borrowed from next week (3.3), but the Monday line says "12/11, one session will run unassigned" (10.2).
- A swap "For good" puts −15 bond on the losing coach's side. That pair no longer trains together, so the penalty bites nothing, and it decays anyway.
- **Columns don't match sessions.** The table has Pads, Sparring, Film, Cond., Strength and Bag. The game's mornings are roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow and neck work, and the stats are the 14 Attrs. There's no mapping from session to column to stat.
- The energy table names three coach kinds but leaves out the S&C staff job ($100) and the physio, and doesn't say whether they take sessions.
- Raises have no ceiling. +1 rating every 15 sessions with ~9 sessions a week gives a raise about every 8 weeks, which is +$300 a week after a year (ESTIMATE from the map's own numbers). Ratings also climb past 90 with nothing to stop them.
- **Double ceiling.** Teaches-up-to (40 + rating × 0.4) sits on top of the fighter's potential headroom clamp. The map doesn't say which binds first.

**Names and words:**
- **S448 breach:** "Sharp unlock above Luke's 74" is a name outside a header.
- The emoji (🟢🟡) and "Mode A / Mode B" aren't game words.
- Every section ends "✅ Answers Kalli #…", and none of it can be checked here.

**The menu wiring table (S425) is missing,** cut at section 12. This counts against the score.

## PLAY 5

- **Good:** Monday lines like "Trusted with your lightweight" and "Pads coach reaches 70" are rewards a player feels. A quarrel at 1 in 6 a week is a story beat.
- **Weak:**
  - It's a 5×N grid to fill every week, and the gain per cell is a tenth of a point.
  - The anticipation (a bond to Corner in 22–28 weeks) is too far away for the first season.
  - The fight-night payoff, "+X in 100 fights", is only an example number.

Part 2 of 3

## Logic check (the numbers run)

| Claim | Check | Result |
|---|---|---|
| Neutral fit 50 gives ×1.00 gain and ×1.00 tiredness | 0.80 + 50/250 = 1.00; 1.15 − 0.15 = 1.00 | holds |
| TOP vs RISKY 0.25–0.35 points a week | the gap is ×0.32; a focused week ≈ 1.0 × coach factor (≈1.0 at rating 74) | holds only for the one focused area; the other areas get a fifth of that |
| Corner bond in 22–28 weeks | about 4 bond a week (3 evenings + corner) plus win/loss +4 | 110 / 4 ≈ 27 weeks, so it holds; but a 3-fighter club shares pad nights, two to a night, and bond per pair needs per-fighter counting (not stated) |
| Assistant budget 11 | 3 fighters × (3 pads shared + 1 spar) ≈ 1.5×3 + 1.5×3 = 9, plus corner 3 = 12 | over budget in any week with a bout and 3 fighters, so the "full" line is the normal state |
| Head coach 4 sessions | 1 lost to the office, corner 3 | a bout week leaves 1 session; that should be shown as the price |
| Teaches up to | rating 58 → 63; fighters sit 55–65 | the existing sessional coach is taught out for half the starting roster at once |
| Calls heard | 1.05 × coachability(0–100?) × bond(?) | can't be computed |

## Missing options

1. **Choose the fighter's focus area against the weakest stat.** Today the +10 makes the choice for the player.
2. **A coach's day off or rest week.** Over budget can only be paid back by the next week, with no deliberate rest.
3. **Who covers a sick or away coach.** Fight-week trips and twist cards take coaches away, and the map has no cover rule.
4. **Promote the second club coach to an assistant role,** or train a member up. That would be the cheap way to a third coach in an amateur club, which is common in UK clubs, where volunteer coaches work toward England Boxing coach awards.
5. **Asking the coach which area to take.** Bond at Trusted could let the coach request an area, as the fighter's ask does.
6. **A coach market cadence:** when new coaches appear and how many. Without it the Market is empty.

## Useless or harmful options

- **Copy Last Week.** The coach already repeats the week (pack 4.1), so this duplicates it.
- **Lock cell.** Nothing auto-moves cells except Coach Runs It, which isn't built. Cut it until that exists.
- **Steady hand mode toggle.** The calendar decides it. Make it automatic or give it a real fork.
- **The −15 bond on the coach being swapped out.** It hits a pair that no longer works together.
- **Cutman line.** Pro only, and already a staff job. It's fine as a line, but not as a "corner option".

## What each option changes

| Option | Changes |
|---|---|
| Assign coach to an area cell | that area's weekly gain (fit ×0.84–1.16), tiredness ×0.88–1.12, bond (evenings only), coach energy |
| Assign a coach to a Normal/Light morning | +fit on that morning for 0.5 energy |
| Mode toggle | one mechanic: loss mood hit, twist mood cost, sparring mastery and fatigue, learning by tier, taper tiredness, load limit |
| Swap This week / For good | that week's fit −2 with bond paused / the new pair starts at its own bond, and the old side −15 |
| Corner pick | calls heard, coach energy −3, bond +1 |
| Pay / Say No on a raise | +$50 a week and +2 ceiling / −1 or −2 energy and bond losses for 4–8 weeks |
| Hear / Overrule the fighter's ask | +5 / −5 mood and that week's coach |
| FRICTION answers (Switch to EASE / Move area / Keep going) | quarrel risk against PUSH's ×1.25 sparring mastery |
| Hire / Let go | wage, energy available, schools; one week's pay to let go |
| 2nd club coach on a conditioning morning | +coach on the morning, −5 member growth target that week |

## Menus (what v5 implies; its own table is missing)

| Menu | What should be there | Wired to | v5 says |
|---|---|---|---|
| Office Desktop, Staff app | the full assignment table | Desktop (built), Staff app (AGREED, NOT BUILT) | yes (10.1) |
| Fighter page > Week | which coach runs each session, fit word on the card | WeekPlan, TrainingLoad | not mentioned |
| Fighter page > Playbook move bars | "+10% learning, in the pads coach's school" | Mastery | yes (9) |
| Club > People | coach cards, raise, Let go, hire | Staff | not mentioned (it moves to the Staff app?) |
| Home needs / Monday review | raise, bond step, ask, energy warning, quarrel | Needs, WeekReview | yes (10.2) |
| Fight prep / Fight night corner | who is in the corner, calls heard | FightNight trust | yes (8), units wrong |
| Money | wage changes from raises | GymBills | not mentioned |
| Top bar flags | raise or quarrel waiting | Shell flags | not mentioned |

Part 3 of 3

## To reach 10/10 (most important first)

1. **Write the menu wiring table in full** (S425): every menu above, plus the Week tab and Club > People, with what each shows, what you can press, and the system it's wired to.
2. **Use the pack's coach factor.** Coach factor = 0.5 + rating × 0.7%, and no coach = 60%. Fit multiplies on top of that. Give the head coach no rating: their four edges stay as they are, and in sessions they run at the factor of the best assistant in that area × 0.9 (ESTIMATE), or 60% with none. Delete 0.6 + rating × 0.004.
3. **Fix calls heard to the pack's units.** Two instructions a minute get through fully, and trust is 1.05 / 1.0 / 0.85 / 0.7. The corner coach's bond adds a step: Stranger −0.05, Working 0, Trusted +0.05, Corner +0.10, with the total capped at 1.10 trust. Show "your corner's word taken in: 95%", and drop "2 of 3 a round".
4. **Delete the Sharp gate at rating 80.** Technician POLISH becomes "Usable and Sharp moves learn ×1.15".
5. **Turn Weakest stat match into Focus match.** +10 when the session's area is the fighter's chosen focus (the player picks one per fighter on the Week tab). The weakest stat is only the coach's suggestion.
6. **Give the existing staff their tempers, schools and area ratings in one table.** List both hire cards and the second club coach, using only stats the code has. Pads 74 / rating 58 and conditioning 90 / rating 74 come from the pack; anything else is an ESTIMATE.
7. **Specify the coach market or cut it.** If kept: 1 new coach card every 4 weeks (ESTIMATE), at most 3 shown, rating 45–80 by club reputation, with temper and school rolled from the four lists. List it in the build order as a new system.
8. **Map sessions to columns to stats.** Pads covers Accuracy and Timing; Sparring covers Defence and Inside fighting; Conditioning covers roadwork and intervals for Stamina and Recovery; Strength covers weights and neck work for Strength, Explosiveness and Durability; Bag covers heavy bag, speed bag, slip rope and shadow for Speed and Footwork. Film goes into the Pads column, without the mobile note. CHECK (Claude) against Attrs.
9. **One over-budget rule.** Over is allowed and borrowed. Delete "one session will run unassigned".
10. **Fix the energy budget to the real case.** Show that a 3-fighter bout week costs about 12. Either raise the budget to 13 or make "corner costs 3" the visible trade with a one-line price ("corner this Saturday: two Normal mornings go uncoached").
11. **Put a ceiling on growth and raises.** Area rating caps at 90, raises stop at the cap, and growth slows to +1 per 25 sessions above 80. Show the raise schedule on the card ("next ask at 70").
12. **Say which ceiling binds:** teaches-up-to or the fighter's potential, whichever is lower, with the hover naming which one.
13. **Swap For good:** drop the −15 on the old side. The cost is that the new pair starts at its own bond and the old bond decays at −1 a week.
14. **Missing options:** cover for an away coach (the head coach covers, or 60%); a coach rest week (+3 energy next week); promote the second club coach (wage +$170, takes sessions, the fitness classes stop).
15. **Make Steady hand automatic** (TAPER within 14 days), or replace PREPARE with a real fork.
16. **Cut Copy Last Week and Lock cell** until Coach Runs It is built, and mark Coach Runs It AGREED, NOT BUILT.
17. **Words and names:** fix "Welterweight — 60kg" to "60 kg"; remove "Luke's 74"; drop the emoji and "Mode A/B" (use LIFT / SHIELD and so on); give the ✅ answer lists the critic's text, not numbers.
18. **Run the probes** (FITPROBE1, BONDPROBE1, RAISEPROBE1, MODEPROBE1, BOTSUITE) and print measured numbers in place of "+X in 100 [EXAMPLE]" before build.
19. **Play: give the first season a payoff.** Working arrives in 2–3 weeks, Trusted around week 12, and a quarrel or an ask in the first 8 weeks (ESTIMATE). The Monday line names the stat point the fit won ("Accuracy 63 → 64, a week early: good fit").

## The 10/10 page at 1920×1080 (Office Desktop, Staff app, Look B)

- **Dark top bar (64 px):** week, the next bout circled, "coach energy 9 of 11", and one red **Lock the week**. Green is used only for Continue.
- **Left column (480 px), coach cards on the whiteboard:**
  - A polaroid portrait with the name in the card header only.
  - Role, temper word with a two-pill mode (LIFT / SHIELD).
  - Energy pips with "borrowed 1 from next week".
  - Area ratings with "teaches Accuracy up to 70".
  - Growth tick "next +1 in 6 sessions".
  - School chips (game moves only), wage, a raise sticky when asked (Pay +$50 / Say no, with the price on hover), and Let go (one week's pay).
- **Centre (960 px), the assignment board:**
  - One row per fighter: portrait, class in kg, record and the chosen FOCUS pill.
  - Five columns: Pads, Sparring, Conditioning, Strength, Bag.
  - Each cell holds a coach magnet, a fit word with a bar, "+0.9 Accuracy this week", bond pips (hollow when apart) and one red tag at most (QUARREL RISK, TAUGHT OUT IN 4 WKS, OVER BUDGET).
  - Click: This week / For good.
  - Hover: every fit part with its number and the binding ceiling.
- **Right (480 px), ON MONDAY preview:** each fighter's focus stat now and after the week; bond steps crossing; coach growth; next week's energy; risks in red. One gold frame, the week's best gain, is the only gold.
- **Fight week strip (bottom of centre, 120 px, a bout within 14 days):** two corner magnets, "your corner's word taken in: 95%" from measured numbers, "costs 3 energy: two mornings uncoached", and the cutman line on pro nights only.
- **Bottom (96 px):** the coach market strip, a maximum of 3 cards with Hire (greyed with its reason). Your assistant's note gives one suggestion and never the answer.
- Names appear only in the headers of the cards and polaroids. Rows say your boxer, your assistant and the opponent.
