# COACHSPEC1_R6 - CRITIC ASSESSMENT (Goose, second critic)

**Discipline:** Sports management-sim design  
**Date:** 2026-11-17  
**Role:** Independent second critic (does not reference Dola's or John's scores)

---

## SCORES

SCORE depth=7 general=7 play=7

---

## DEPTH: 7/10

**What works:**

The two-axis hire decision (stats vs moves) is the strongest element. The sessional coach, S&C coaches, second boxing coach, and full-time coach form a clean ladder where each step costs more per point but buys something different. The second coach and S&C coach competing for the same 32 members of room at the Unit premises creates genuine strategic tension - you can't have both without moving premises, which is a real decision.

The Week Priority switch (Stats/Moves/Freshness) is a meaningful addition. It transforms the coach's Monday deal from "the best deal whether you want it or not" into "the best deal for what you need this week." The display of what the deal gave up when you drag a coin is good feedback.

The held night has real trade-offs: load spike (1.3 → 1.38), injury risk multiplier (×1.4), fight week restriction, and the cost of 2 coached mornings. The decision box showing load before/after, mastery gain, and wins/100 is clear.

Class nights create a genuine money vs pad minutes trade: 0-3 classes per coach, with each class worth $175 but costing 60 pad minutes ($2.9/minute). The second coach at $1.7/minute is better value long-term, but the immediate cash from classes matters when runway is tight.

The BJJ belt as a career ceiling is elegant. A brown-belt coach caps the athlete at purple; you need a black belt (or Academy Month) to go further. This makes the hire a long-term decision, not just a weekly cost.

The corner edge from sparring rating (×1.00 floor, +0.004 per point over 40) is a nice touch that makes the Ex-pro background matter and rewards hiring a coach with high sparring.

**What's missing or weak:**

The Week Priority's "Freshness" option is underdeveloped. What does it mechanically DO beyond "minimize fatigue spikes"? The map says the coach optimizes toward this, but doesn't specify the algorithm. Does it reduce Hard mornings? Skip the held night? Prioritize rest evenings? Without clear mechanics, it's a label, not a choice.

The half-night hold (40 minutes, costs 1 morning) is marked "optional" but should be a real design decision. If it's a genuine middle step between "full night with high risk" and "no night with no gain," it needs to be designed, probed, and either kept or cut. Marking it optional is a cop-out.

The held night's injury cost is still borderline. The load spike from 1.3 to 1.38 is a +7% increase, which gives a ×1.4 injury risk multiplier. At 1.3% base training injury, that's 1.82% that week. The expected cost over 12 weeks is −0.3 to −0.8 wins/100, against the +2.0 to +2.5 wins/100 gain. That's still a 3:1 to 8:1 reward-to-risk ratio, which makes the held night strongly favorable when a bout is in the next 4 weeks. The ±20% probe pass line is tight - if the held night still dominates, the cost needs to rise to 3 mornings or the load spike needs to be larger.

No long-term coach development or relationship mechanics. Coaches are hired, they do their job, they leave if idle for 4 weeks. There's no sense of coach-boxer chemistry, no coach improving over time, no mentorship, no loyalty. In real gyms, the relationship between coach and fighter matters as much as the coach's rating. This is a missed opportunity for depth.

The second coach's net cost calculation ($130/wk) is ESTIMATE and depends on multiple assumptions (fitness classes +$350, stipend offset +$100). If these assumptions are wrong, the route table changes. The design should either prove these numbers or mark the route table as provisional.

**What each option changes:**

- Sessional coach alone: baseline, no special effects
- +S&C A ($100/wk): +2.64 stat points/12wk, +0.6 wins/100 per boxer, load reduction (×0.85 tiredness), fight-week taper (−3 at bell)
- +S&C B ($200/wk): +3.79 stat points/12wk, +0.9 wins/100, more days but lower rating
- +Second coach ($380/wk, net +$130): +1.01 stat points, first Sharp in week 5 instead of 10, +2.8 wins/100 in weeks 5-9, 4th roster spot
- Full-time coach ($1,090/wk): +6.51 stat points, +1.6 wins/100, slower pad mastery (pads 58 vs 74)
- Full-time + S&C B: +8.75 stat points, +2.1 wins/100, best stats but most expensive

---

## GENERAL DESIGN: 7/10

**What works:**

The runway calculation replacing "needs a bigger building" is a major improvement. Showing "Runway: 14 → 9 weeks" on every hire card is honest and actionable. The member cap as a repayment ceiling (not a gate) is correct - the game never blocks hiring the full-time coach on day 0, but the warning is clear.

Look B compliance is now explicit and specific: Permanent Marker headings, Kalam body text, minimum 14px, colour only for risk (amber 6-8 weeks runway, red <6 weeks), one pulsing button per card. This is buildable.

Pad unit conversion is unified: 1 minute = 3.2 drill units everywhere. The table shows both minutes and units, so there's no confusion.

Academy Month replaces the unrealistic guest professor. Sending the athlete to an affiliated black-belt academy for one month ($450, away 4 weeks) is more plausible than a visitor signing a promotion after one class. The CHECK on IBJJF time-in-grade is honest.

The route table with full income accounting (fitness classes, stipend offset) is much better than R5's half-counted numbers. The net cost of the second coach (+$130/wk) is now realistic.

Names only in headers, role words in body ("the sessional coach," "the women's lightweight") follows the owner's S448 rule.

Clear marking of ESTIMATE, CHECK, CODE, (P) throughout. The design is honest about what's proven and what's not.

**What's missing or weak:**

Too many critical numbers are still ESTIMATE or CHECK. The second coach's net income calculation is TBD. The held night's load spike is ESTIMATE. The Academy Month needs IBJJF confirmation. England Boxing corner rules need confirmation. The design isn't fully proven - it's a strong proposal, but not a finished design.

The half-night hold is "optional" but should be a real design decision. Either design it (probe the load, injury, and mastery gain) or cut it. Marking it optional leaves a gap in the choice space.

The Week Priority's "Freshness" option needs mechanical definition. What does the coach's deal do differently when Freshness is selected? Without this, it's not a real option.

Some CHECKs are critical and unresolved:
- IBJJF time-in-grade requirements (Academy Month depends on this)
- England Boxing corner rules (chief second + one assistant)
- UK grading fees (Academy Month $450 - is this realistic?)
- Training injury length (affects held night cost)

The probe pass line (±20%) is tight. What happens if the held night's net win value is outside ±20% of two coached mornings? The map says "if still >+20%, cost rises to 3 mornings; if <−20%, reverts to 1 morning." But this is reactive - the design should be proactive and either prove the held night is balanced or adjust the cost now.

The BJJ side feels disconnected from the boxing side. The mat coach, belt progression, and Academy Month are a separate track with no interaction with the boxing coaches, the week priority, or the fight plan. In a real gym, the boxing coach might cross-train in BJJ, or the BJJ athlete might benefit from the S&C coach. This crossover is mentioned in the critic pack but not designed here.

**What each option changes:**

- Runway before→after: replaces the false "needs a bigger building" with the real money cost
- Member cap as repayment ceiling: shows how far dues can go, not a hard limit
- Pad unit conversion: 1 min = 3.2 units, no confusion
- Academy Month: realistic promotion path, but 4 weeks away is a big cost
- Look B compliance: buildable screen spec
- Full income accounting: honest net costs

---

## PLAY: 7/10

**What works:**

The Monday deal with the Week Priority switch gives weekly agency. You pick what the week optimizes for (Stats/Moves/Freshness), the coach proposes a deal, you can drag coins to override and see what you gave up. This is a good weekly ritual.

The held night decision box is engaging: load before/after, injury risk, mastery gain, wins/100 if bout in next 4 weeks, fight week restriction. The half-night option (if designed) would add a middle step.

"You held the pads on Wednesday: the uppercut turned Usable" in the week review is a great moment. It connects your weekly choice to a tangible outcome.

"The uppercut from Wednesday's pads landed 3 times" in the fight log is even better. It connects training to fighting, which is the core fantasy of the game.

The no-work warning ("the coach has had no work for 3 weeks") a week before the coach asks to leave is good feedback.

Class nights create a real money vs moves tension every week. Do you take the $350 from classes, or keep the pad minutes for the next bout?

The hire decision with runway impact is meaningful. "Runway: 14 → 9 weeks" is a clear cost.

The corner edge from sparring rating makes the hire matter on fight night, not just in training.

**What's missing or weak:**

The hire itself is a one-off decision that's never revisited. You hire a coach, they do their job, they leave if idle. There's no sense of coach development, no relationship with the boxer, no loyalty, no mentorship. In real gyms, the coach-boxer relationship is as important as the coach's rating. This is a missed opportunity for ongoing play.

The Week Priority switch doesn't create enough weekly tension once set. You pick Stats/Moves/Freshness, the coach handles it, you can drag coins to override. But the priority itself doesn't change week to week based on the boxer's needs, the bout timing, or the club's situation. It's a set-and-forget choice, not a weekly decision.

No coach personality or relationship mechanics. Coaches are numbers, not people. There's no sense of coach-boxer chemistry, no coach who's great with one boxer but poor with another, no coach who develops a signature style. This is a missed opportunity for depth and play.

The BJJ side feels disconnected from the boxing side. The mat coach, belt progression, and Academy Month are a separate track with no interaction with the boxing coaches or the week priority. The BJJ athlete's journey (belt progression, Academy Month) is interesting but isolated.

The S&C coach's taper contribution is invisible until fight week. For 11 weeks, the S&C coach reduces load and builds fitness, but you don't see the payoff until the fight week taper (−3 tiredness at the bell). This is a long feedback loop. The design should show the buildup: "Hard mornings before overreached: 5 → 6" is good, but it's not enough.

No coach-boxer fit or specialty. In real gyms, some coaches are great with beginners, others with pros; some are technical, others motivational; some specialize in certain styles or weight classes. This design treats all coaches as interchangeable except for their area ratings. This is a missed opportunity for depth and play.

**What each option changes:**

- Monday deal with priority: weekly agency, choose what the week optimizes for
- Held night decision: engaging trade-off, connects training to fighting
- "Landed 3 times" in fight log: connects training to fighting, core fantasy
- No-work warning: good feedback, prevents surprise
- Class nights: weekly money vs moves tension
- Hire with runway impact: meaningful cost
- Corner edge: hire matters on fight night

---

## OPTIONS: MISSING, USELESS, AND WHAT EACH CHANGES

| Option | Verdict | What it changes |
|--------|---------|-----------------|
| Week Priority: Stats/Moves/Freshness | **Missing mechanical definition for Freshness** | Without clear mechanics, Freshness is a label, not a choice. Define what the coach's deal does differently when Freshness is selected. |
| Half-night hold (40 min, costs 1) | **Optional but should be designed or cut** | If it's a genuine middle step, probe the load, injury, and mastery gain. If it's not balanced, cut it. Don't leave it optional. |
| Held night injury cost | **Still borderline** | The 3:1 to 8:1 reward-to-risk ratio makes the held night strongly favorable. Either prove the ±20% pass line holds, or adjust the cost now (3 mornings or larger load spike). |
| Second coach net income | **ESTIMATE, needs proof** | The $130/wk net cost depends on fitness classes +$350 and stipend offset +$100. If these are wrong, the route table changes. Either prove these numbers or mark the route table as provisional. |
| Coach-boxer relationship/chemistry | **Missing** | No sense of coach-boxer fit, no coach who's great with one boxer but poor with another. This is a missed opportunity for depth and play. |
| Coach development over time | **Missing** | Coaches are hired, they do their job, they leave if idle. No coach improvement, no mentorship, no loyalty. This is a missed opportunity for ongoing play. |
| BJJ-boxing crossover | **Missing** | The BJJ side is disconnected from the boxing side. No crossover training, no shared benefits. This is a missed opportunity for depth. |
| S&C coach visible buildup | **Weak** | The taper payoff is invisible until fight week. Show the buildup: "Hard mornings before overreached: 5 → 6" is good, but not enough. |
| 0 or 1 class nights | **Weak** | Worth it only when there's no member room for a second coach. Keep, but print $ per pad minute on the pill ($2.9/min) so the trade is clear. |
| Academy Month | **Keep, but CHECK IBJJF** | More realistic than guest professor, but 4 weeks away is a big cost. Confirm IBJJF time-in-grade and affiliate model before shipping. |
| S&C A and S&C B | **Keep** | Clean ladder, each costs more per point. |
| Ex-pro as second in corner | **Keep** | Brings the background back to life. |
| Merging second coach into staff job | **Keep** | One decision, cause and fix together. |
| Letting the main coach go | **NOT ESTABLISHED, scope decision** | Without it, hiring the full-time coach can never be undone. Flag to owner. |

---

## TO REACH 10/10

**Most important first, each specific enough to build:**

1. **Define the Week Priority's "Freshness" option mechanically.** Specify what the coach's deal does differently when Freshness is selected. Does it reduce Hard mornings by 1? Skip the held night? Prioritize rest evenings? Add a rule: "When Freshness is selected, the coach's deal reduces Hard mornings by 1 and never proposes a held night." Probe the effect on load and injury risk.

2. **Design or cut the half-night hold.** If keeping it: probe the load spike (40 min vs 75 min), injury risk, and mastery gain (53% of full night). Add it to the route table. If cutting it: remove the option and the "optional" mark. Don't leave it half-designed.

3. **Prove the held night is balanced or adjust the cost now.** Run the 400-bout Monte Carlo probe. If the held night's net win value is >+20% of two coached mornings, raise the cost to 3 mornings. If it's <-20%, lower the cost to 1 morning. Don't wait for the probe to fail - design the adjustment now.

4. **Prove the second coach's net income or mark the route table as provisional.** Run the full GameMoney calculation with fitness classes +$350 and stipend offset +$100. If the net cost is different from $130/wk, update the route table. Mark the route table as "ESTIMATE until GameMoney probe confirms" if the numbers aren't proven.

5. **Resolve the critical CHECKs before shipping.** Confirm IBJJF time-in-grade requirements for Academy Month. Confirm England Boxing corner rules (chief second + one assistant). Confirm UK grading fees (is $450 realistic for an Academy Month?). Confirm training injury length (affects held night cost). These are not optional - the design depends on them.

6. **Add coach-boxer fit or chemistry.** Not a full relationship system, but a simple rule: "A coach's rating is +5 with boxers of the same style, −5 with boxers of a different style." Or: "A coach who has worked with a boxer for 12+ weeks gains +3 rating with that boxer." This adds depth and play without a lot of code.

7. **Add coach development over time.** Not a full progression system, but a simple rule: "A coach who has worked with 3+ boxers gains +1 to their top area." Or: "A coach who has cornered 5+ bouts gains +2 sparring." This adds depth and play without a lot of code.

8. **Add BJJ-boxing crossover.** Not a full crossover system, but a simple rule: "A BJJ athlete who trains with the S&C coach gains +10% to their Strength and Stamina classes." Or: "A boxer who trains with the BJJ coach gains +5% to their Flexibility mornings." This adds depth and connects the two sides of the gym.

9. **Make the S&C coach's buildup visible.** Add a line to the week review: "S&C coach: 6 Hard mornings before overreached (was 5)." Add a line to the fighter page: "Fresher at the bell: +n wins/100 (S&C coach)." This makes the S&C coach's value visible before fight week.

10. **Redraw staff_hire and evening_plan in Look B, then send to two fresh critics for the depth-7 gate.** The page kit is specified, but the mockups need to be redrawn with the new elements (runway, priority switch, half-night, load line). Then send to two fresh critics to confirm the depth-7 gate is met.

---

## THE 10/10 PAGE (1920×1080, Club > People > Staff, Look B)

**Top bar:** Dark shell; gym name centered; cash + runway right (hover shows full breakdown).

**Left 40% (x 40–720):** Five role cards pinned as polaroids on the whiteboard:
- You (head coach): face + role badge, sun/moon/stool lit, area meters with words, "4 mornings + 1 held night/wk"
- Boxing coach: face + role badge, sun/moon/stool lit, area meters with words, "2-3 mornings + 3 pad nights/wk"
- Second coach: face + role badge, sun/moon/stool lit, area meters with words, "2 mornings + 3 pad nights/wk + classes"
- S&C coach: face + role badge, sun lit, Stamina + Strength meters, "2-4 group mornings/wk"
- Mat coach: face + role badge, mat lit, belt + drill rate, "3 classes/wk · promotes up to: purple"

Each card shows:
- Class pill: "3rd class: +$175 · −60 pad min ($2.9/min)"
- Runway line: "Runway: 14 → 9 weeks" (red if <8 weeks)
- Member line: "Dues can repay $X/wk; 32 member slots remaining"
- One pulsing button: "Hire" on the selected card

**Right 60% (x 760–1880):** The hire chart:
- Stats wins/100 across (x-axis)
- First Sharp week up (y-axis)
- One dot per route, with the route name and net cost
- Faint line at the Unit's 70 members marks how far dues can go
- Red warning only when runway after < 8 weeks

**Bottom strip (y 900–1040):**
- Week Priority switch: Optimise: Stats · Moves · Freshness
- Held-night box: "Load 1.3 → 1.38 · injury ×1.4" (red only past 1.5), beside "+2.0 to +2.5 wins/100 if bout in next 4 weeks"
- Half-night option (if designed): "Hold 40 min · costs 1 morning · +53% mastery"

**Type and buttons:**
- Permanent Marker headings, Kalam body text, minimum 14px
- Colour only for risk: amber 6-8 weeks runway, red <6 weeks / load >1.5
- Teal: S&C sessions; Gold: your coached sessions; Blue: boxing coach
- One pulsing button per card: "Hire" / "Confirm Week" / "Start Academy Month"
- No gold text on selections. No IBM Plex Mono. No Bebas Neue.

---

## RESULT

This design is solid. It's been through six rounds of iteration and addresses most of the critics' points. The scores are all 7s, which meets the bar (7+ on DEPTH and 7+ on GENERAL DESIGN). It's not yet 8+ because too many numbers are unproven, some design decisions are incomplete (half-night, Freshness), and there are missed opportunities for depth and play (coach-boxer relationship, coach development, BJJ-boxing crossover).

The design is ready for the next step: prove the numbers, resolve the CHECKs, complete the incomplete decisions, and send to two fresh critics for the depth-7 gate.

**RESULT: ops/research/DESIGN_COACHSPEC1_R6_CRITIC_GOOSE.md -> SCORE depth=7 general=7 play=7**
