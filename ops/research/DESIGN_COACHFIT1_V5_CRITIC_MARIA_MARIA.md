# DESIGN_COACHFIT1_V5_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ100)

Brief: research/DESIGN_COACHFIT1_V5_CRITIC_MARIA.md
Sent: 2026-11-14 05:11 | collected: 2026-11-14 05:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give COACHFIT1 v5 **DEPTH 6, GENERAL DESIGN 4, PLAY 5**, so it still doesn't reach the owner's bar. The weekly coach-to-fighter choice now has a real price and a real long-term payoff. General design fails because several numbers contradict the game or each other, a big part of the map is missing, and the coach market it depends on doesn't exist.

## Scores

**1. DEPTH: 6/10**
There are real choices here:
- **Energy.** One coach can't run everything, so you have to decide which fighter gets the best pads coach this week. Going over budget borrows from next week.
- **Bond against fit.** A pair that has worked together for months is worth keeping even when a newer coach teaches the stat better. That matches real boxing: fighters do switch trainers to fix a hole, as Anthony Joshua did when he went from Rob McCracken to Robert Garcia and then Derrick James. Switching gives up years of corner trust.
- **Raises.** Pay, or say no and take an energy and bond hit.
- **Long-term effect.** TOP FIT against RISKY over 26 weeks is worth 6.5 to 9 stat points, and the pack says 5 points of stats wins about 72%. Over a season, the choice changes who wins.

What holds it back:
- **Too small to feel from week to week.** 0.25 to 0.35 points a week is below what the week review shows as a whole-point fill. The player chooses every week but sees the effect only every few months.
- **The pad-night cap rewards sharing.** One energy covers two fighters on the same pad night, so sharing is almost always the right pick. It costs only half the drill units, which the fighter loses anyway when there's one coach.
- **The trade-offs never fight each other.** A Motivator is best with a Low fighter, and a Drill Sergeant is worst with one, so the temper choice follows straight from mood. Each mode is the right pick in an obvious situation.
- **Nothing ties it to the fight plan or the Why.** Coaches change gains and the share of calls heard, but not the plan lines a coach can teach. Today, coach rating sets how many plan lines a fighter gets.

**2. GENERAL DESIGN: 4/10**
v5 gives one morning rule (Normal and Light mornings keep today's factor, so there's no hidden nerf), one bond table, and keeps the cutman pro-only. What fails:
- **The taught-out ceiling hits on day one.** "Teaches up to" is 40 + rating × 0.4, which gives about 70 for the pads coach (74). Amateur lightweights sit at 55 to 65, so most fighters are already within 10 of that ceiling. They'd take the −4 to −12 taught-out penalty from the first week, and the warning would show everywhere. The map never says what happens above the ceiling: is it a hard stop, or just the gradient?
- **The calls-heard unit is wrong.** "About 2 of 3 calls heard a round" doesn't match the game. A round is six 30-second exchanges, and two instructions a minute get through fully, so a round has six shout chances. The formula multiplies coachability, a 0–100 personality value, with no scale given. It also ignores the Ring general perk (+25% corner calls) and the existing trust factors (Fired up 1.05 down to Low 0.7). The map says it reuses them, but the formula doesn't show it.
- **The head coach formula is new and unsourced.** "0.6 + rating × 0.004" isn't the game's coach factor, which is 0.5 + rating × 0.7%, and the head coach (you) has no rating in the game. "Loyalty used as bond" relies on a value the game doesn't show on the board.
- **The temper range doesn't add up.** The table promises −14 to +12, but the listed values are +6, −8, +4 and +4. Nothing reaches −14 or +12.
- **Some effects aren't defined.**
  - "Sharp unlock at 80 rating" and "Sharp unlock above Luke's 74" mean nothing: moves turn Sharp at 60 mastery, not by coach rating.
  - PREPARE "raises the load limit 1.5 → 1.7", but in the game 1.5 is where risk starts rising, not a hard limit.
- **It relies on things the game doesn't have.**
  - The game has two assistants (Luke Reid and Marcus Hale), not a coach market with tempers and schools. "Bottom: Market" needs a coach pool that isn't built.
  - "Coach Runs It" is agreed but not built.
  - "Week lock" isn't a game concept. The clock stops on Mondays.
- **Some changes do nothing.**
  - The swap-for-good penalty lands on "the losing coach's side", but that pair no longer exists.
  - "Seeking other work" is a state the player can't see.
- **Words and rules broken.**
  - "Welterweight, 60 kg" is wrong: 60 kg is lightweight, and welterweight is 65 (women) or 70 (men).
  - "Folded into Pads on mobile": the game isn't on mobile.
  - "Confirm Week (1 pulsing button)" is a continuous pulse.
  - The modes are shown by green and yellow dots, which is state by colour alone.
  - "Mood" sits alongside the game's word "morale"; one word per concept.
- **Section 12 (menu wiring) and everything after it is missing,** so there's no build order, no held-back list and no open questions. No probe has run either; every target is a guess.

**3. PLAY: 5/10**
The best moments:
- A Monday line saying a pair has reached Trusted.
- The fighter asking for the pads coach in fight week.
- A raise asked for with a real cost either way.

These are about people, which fits the "fighters are people" pillar. But the weekly job is a table of fighters × five areas × coaches, with fit words that move by 1 to 4 points. That's a spreadsheet chore, and "Copy last week" will be the usual click. The quarrel (1 in 6 a week under PUSH with a Low fighter) is the only surprise, and it's a punishment.

## Options: missing, useless, and what each changes

**Missing**
- Hiring from a real coach pool: who arrives, when, and how much each costs.
- What a coach changes in the fight plan, such as lines taught.
- What happens to a fighter above the coach's ceiling.
- Corner choice on amateur nights. The energy cost is shown, but is there a reason to pick anyone other than the highest bond?
- The menu wiring, the build order and the held-back list.

**Useless as written**
- **Swap for good's penalty** on a pair that no longer exists.
- **The hidden "Seeking other work" flag.**
- **The Film column** as its own area. It already "counts as Pads".
- **Technician "Sharp unlock"**, because the effect is undefined.

**What each option changes**
- **Assign a coach to a cell:** the fit word, so gains go ×0.84 to ×1.16 and tiredness goes ×1.12 to ×0.88. It costs energy (evenings 1 to 1.5, Hard mornings 1.5, optional Normal mornings 0.5) and builds bond on evenings.
- **Swap this week:** −2 fit that week, and the bond pauses.
- **Swap for good:** the bond carries over, plus a penalty to a pair that no longer exists.
- **The mode toggle:**
  - LIFT or SHIELD: smaller morale losses.
  - PUSH: ×1.25 sparring mastery, +3 fatigue, quarrel risk.
  - EASE: no quarrel, softer bond losses.
  - POLISH or TEACH: faster learning by tier.
  - TAPER: ×0.85 tiredness inside 14 days.
  - PREPARE: a higher load-spike limit.
- **Pay the raise:** +$50 a week and +2 to teaches-up-to.
- **Say no:** −1 or −2 energy and −3 or −6 bond, repeating until paid.
- **Hear or overrule the fighter's ask:** +5 or −5 morale, plus a reassignment for one week.
- **The corner pick:** the share of calls heard, and 3 energy.
- **Let go:** a week's pay.

## To reach 10/10

1. **Fix the ceiling scale.** Make "teaches up to" 55 + rating × 0.35. That gives the pads coach (74) a ceiling of 81, and conditioning (90) 86 (EXAMPLE). The warning starts at 5 below. Above the ceiling, gains run at ×0.5, never a hard stop. Probe: under 15% of rows tagged taught-out in week 1.
2. **Use the game's numbers for calls.** Calls heard = the existing trust factor (morale 0.7 to 1.05) × coachability (0.8 at 0, 1.1 at 100) × bond (Stranger 0.9 up to Corner 1.1), capped at 1.1. Ring general stays ×1.25 on top. Show it as "about 5 of 6 shouts land fully this round".
3. **Give the head coach a rating from the edge chosen at new career.** For example, Ex-pro 60 on pads and 45 elsewhere (EXAMPLE), run through the existing coach formula. Bond starts at Working and builds from sessions together, not from Loyalty.
4. **Make the week's choice big enough to feel.**
   - Widen fit to ×0.75 to ×1.25 (EXAMPLE).
   - Add one visible weekly payoff: a Trusted or Corner pair teaches 1 extra plan line in camp.
   - Probe: TOP against RISKY is worth 10 to 13 points over 26 weeks, and a hand-made table beats Coach Runs It by 3+ wins in 100.
5. **Price shared pad nights.** Two fighters on one night cost 1.5 energy and split 240 units 60/40, with the player choosing who gets 60. Show the cost on the Coach's pad nights row the game already agreed.
6. **Write the coach pool.**
   - 2 candidates show each month, so 6 a season.
   - Each has a temper, a school, a rating per area and a wage band ($450 to $1,300 a week, EXAMPLE).
   - Signing costs $1,000, as today.
   - The day-one choice stays Luke or Marcus.
7. **Rebuild the tempers so no choice follows from mood alone.**
   - Use the full −14 to +12 range.
   - Each mode costs something: LIFT −0.5 energy, PUSH quarrel, POLISH slower Raw moves, TAPER −10% gains.
   - Cut "Sharp unlock".
   - Change PREPARE to "load-spike risk ×2 instead of ×3".
8. **Fix the swap rules.**
   - Swap for good: the new pair starts at half the old pair's bond, capped at Trusted.
   - The old coach loses 1 energy for 2 weeks.
   - Show "Seeking other work" as a Monday line with Pay or Let go, or cut it.
9. **Fix the words and UI.** Write "60 kg lightweight", "morale", and one Confirm week button without a pulse. Show modes as a word and an icon, not colour alone. Remove the mobile note. Replace "week lock" with "Monday".
10. **Finish sections 12 to 15.** Wire it to every screen:
    - Office Staff app.
    - Fighter Week (fit word on each card).
    - Fight prep (the corner pick).
    - The corner minute (calls heard).
    - Week review (growth, bond, raise).
    - Club > People.
    - Then the build order, the held-back list and the open questions.
    - Run FITPROBE1, BONDPROBE1 and the bot suite before v6.

**My 10/10: the Office Staff app's Coaches this week, 1920×1080**
- **Header (100 px):** week and dates, the fight date circled, total coach energy "18 of 22", Copy last week, Coach runs it, and one Confirm week button.
- **Left column (480 px), YOUR COACHES:** one card per coach.
  - The name in the card header only.
  - Portrait, temper, and a mode switch with words.
  - Energy pips.
  - Teaches up to, per area.
  - School chips.
  - Wage, and a raise note with Pay and Say no when one is due.
- **Centre (960 px), WHO RUNS WHAT:** fighter rows × five areas (Pads, Sparring, Strength, Conditioning, Bag). Each cell shows:
  - the coach's face
  - the fit word (Top fit, Good, Mixed, Risky) with an icon
  - the weekly gain ("+1.2 Accuracy")
  - bond pips with the step's word
  - at most one tag (Over budget, Taught out in 5 weeks, Friction risk)
  - hover lists every part of fit, with its points.
- **Right column (480 px), WHAT THIS WEEK BUYS:** for each fighter, the focus stat by fight night compared with Coach runs it, any bond reaching the next step, the plan lines a coach will teach in camp, and risks in words.
- **Fight week strip (only within 14 days of a bout):** two corner choices, each with "about 5 of 6 shouts land fully", energy cost and bond step. The cutman shows on pro nights only.
- **Bottom strip (140 px), COACHES LOOKING FOR WORK:** this month's two candidates with temper, school, ratings, wage and Hire (greyed with the reason).
