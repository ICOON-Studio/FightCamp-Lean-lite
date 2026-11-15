# DESIGN_COACHSPEC1_CRITIC_JOHN_JOHN - John answer (seat queue SQ182)

Brief: research/DESIGN_COACHSPEC1_CRITIC_JOHN.md
Sent: 2026-11-15 17:40 | collected: 2026-11-15 18:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll recheck COACHSPEC1's probe numbers and the time model against the pack, then score it. The owner's computer is still offline, so `CRITIC_ACCESS.md`, the mockups and the probe script aren't open to me.

**Logic check.** I recomputed every probe number from the pack's formulas: coach factor 0.5 + 0.007 × rating, a morning is 0.2 × factor × headroom, and pads gain 2.1 an hour × (1 + 0.40 × pads rating ÷ 100) × (1 − mastery ÷ 100) on the code's 240 units a night.

All of these hold up:
- **The morning table** is right to within 0.001 (rounding of the headroom). For the lightweight: no coach 0.150; you 0.175; the sessional coach coaching 0.188; S&C B 0.190 / 0.216; S&C A 0.199 / 0.229; the full-time coach's programme 0.203 / 0.222.
- **The head coach lifts** are right: +30% / +16% at 40, and +48% / +22% at 55.
- **The price-per-point column** is right: $454, $633, $1,180 and $314. So are "59% of the points for 16% of the extra money" and the +12% and +26% lines.
- **The per-fighter rows** all scale by the same ×1.32 / ×1.37.
- **The Wednesday pads** check out on units: check hook 12 → 21.1 (75 min) and → 15.7 (30 min); uppercut → 28.0 (45 min with the sessional coach). The 30.2 for you at pads 40 comes out about 30.5 for me, which is close enough.
- **The BJJ numbers** are right: 9.4 weeks against 7.5, $225 a week, and $68 saved.
- **The phase** is right: BUILD 12 days out, FIGHT WEEK Mon 23 – Sat 28.

Twelve things don't hold:

1. **The S&C hire makes a club with the full-time coach worse.** "Every morning is rated at whoever runs it." His group morning at 66 and ×1.15 gives 0.199, but the full-time coach's own programme at 90 and ×1.00 already gives 0.203. Strength works out 0.229 against 0.222 and only just beats it, and B at 60/60 loses on both. With the top boxing coach hired, a paid S&C hire lowers Stamina on his days. The probe never ran "full-time coach + S&C".
2. **"Group ×1.15" is the pair bonus without a pair.** In CoachedMornings, ×1.15 is for two fighters on the same drill. The map gives it to every fighter on his day, even one fighter alone, with no cap at seven. Either it needs 2+ fighters, or call it his own number.
3. **No rule for overlap.** If you or the boxing coach coach a morning that falls on one of his days, who runs it, and do the ×1.25 and ×1.15 stack? It isn't written. The probe's greedy deal had to pick something.
4. **Taking a pad night yourself is likely the dominant use of your 4, and it isn't probed.** One night held yourself gave the lightweight +6.8 and the featherweight the coach's full 75 (+9.1), for 15.9 mastery in total. The coach's split gave 4.6 + 3.7 = 8.3. That's +7.6 mastery, close to a full tier, for one coached morning worth about +0.03 of a stat. Whenever two boxers share a night, the pad night wins every time. The map itself says "Not probed: pads mastery over 12 weeks".
5. **The "12-week club points" leave out pads.** That's the sessional coach's whole strength (+30% against +23%). The hire screen ranks the routes on morning stats only, so it's biased toward the full-time coach and the S&C.
6. **Mobility as priced is a useless option.** Training injury is about 1.3% a week; ×0.85 saves about 0.2 percentage points. Even with an injury costing about 3 weeks at a quarter of gains, that's worth roughly 0.01 points a week, against the 0.23 Power the map itself says it costs. Overreached (×3) it's still under 0.03. Players will drop the mobility morning, so making the cut conditional quietly removes it.
7. **The Ex-pro's 55 sparring is useless.** The head coach never runs a sparring night (the boxing coach referees), so that edge rating touches nothing. Old hand bag 55 and Amateur coach pads 55 both work. The Strength coach gets two areas *and* keeps its ×1.10, which counts its edge twice.
8. **The corner pick changes nothing.** The menu table lists "the boxing coach or you in the corner", with no rating or effect named. As written it's decoration.
9. **Two boxing coaches aren't defined.** The slots allow 2. Whose programme runs the unattended mornings, how do pad nights double, and does the capacity puzzle go away? None of it is written, and the second and third market coaches aren't wired.
10. **The BJJ promotion goes against the real rules.** The map has you, a boxing coach who never teaches the mat, making the belt call. The IBJJF requires an affiliated black-belt professor to sign promotions up to brown, and a black belt with 2+ certified degrees to sign a black belt (Art. 6.1–6.2). So a brown-belt coach can't take the athlete to black. That's missing depth, and the current wording is wrong.
11. **The hire screen's per-morning +32% overstates the hire.** That's the gain on one morning. The club gains +8.4% over 12 weeks (+2.64 on 31.44). The "On your fighters" before and after should be weekly or 12-week totals.
12. **SANDBOX and names.** "HER WEEK" is a screen label with a fixed she. "His days", "his 75 min" and "hold her pads" fix one gender on staff. The map's body names fighters and coaches throughout. The screens must say "this week", "your coach", "the S&C coach", and use faces.

**Small:** B's Speed rising 3.37 → 4.09 must come from your coached mornings moving off Stamina, so say so. B is cheaper per day *and* rated lower, which reads as arbitrary unless the card says why: a fitness instructor against an accredited S&C coach (UKSCA accreditation exists in the UK).

I score COACHSPEC1 at depth 6, general design 5 and play 5, so it fails the owner's bar on general design. The structure is right: four roles on the five areas the code already has, one time model, and a probe that actually changed the numbers. But four rules break it as written:
- the S&C hire lowers Stamina when the full-time coach is hired;
- holding a pad night yourself likely beats every other use of your 4;
- the mobility trade is priced so nobody takes it;
- the Ex-pro's sparring edge and the corner pick change nothing.

It also falls short of the map's own S425 gate of depth 7 from two critics.

I judged it from the pack and the map. `CRITIC_ACCESS.md`, the two mockups and `probe_coachspec.py` are on the owner's computer, which is offline, so I recomputed the numbers by hand.

## Scores

**Depth 6.** The decisions are real and tied to the rest of the game:
- which days the S&C coach gets, against each fighter's phase (a FIGHT WEEK with three rest days wastes his day);
- your 4 as coached mornings or a pad night, which links to sparring, because a move that turns Usable by Wednesday gets drilled on Thursday and fires 1 in 2;
- a hire ladder where each dearer route buys more at a worse price;
- the full-time coach's pads cost against his fitness gains.

What holds it at 6:
- the pad night is probably dominant;
- mobility isn't a real trade;
- the BJJ belt is a one-off two-option pick with no ceiling attached;
- two boxing coaches, the obvious late-game question, are undefined.

**General design 5.**
- **What's good:** every rule points at a file and line; it reconciles the three time models into two; it keeps one word (Stamina); it plans for later sports as data rows; it orders the build after CoachedMornings and training_k; it marks the real-world claims it hasn't checked.
- **What holds it at 5:**
  - a paid hire that makes the top route worse;
  - ×1.15 borrowed from the pair rule;
  - no overlap rule;
  - a useless edge and a corner pick with no effect;
  - hire screen points that leave out pads;
  - a per-morning +32% shown as if it were the hire's effect;
  - "HER WEEK" and fixed staff pronouns;
  - a BJJ promotion rule that contradicts the IBJJF.

**Play 5.** The best moment is the Wednesday call: "Hold the pads yourself: Usable Wednesday, so Thursday's sparring drills it." That's a choice with a visible payoff two days later. Most of the rest is +0.03 a morning, which the player won't feel week to week. The Monday lines ("Stamina +0.198 on the S&C morning") are too small to anticipate. Nothing about staff builds over months: no coach improves, leaves, or opens something new.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Hire the sessional boxing coach | Pads +30%, 2 coached mornings, sets the programme | Keep |
| Hire the full-time boxing coach | Fitness programme 90/84, pads +23%, 3 coached mornings | Keep; show the pads loss in points |
| Second boxing coach | Undefined | **Missing:** define it or drop the slot |
| S&C A (2 days, $100) | Stamina/strength mornings on his days at 66/68, ×1.15 | Keep, but it must never lower a morning (rule: better of the two) |
| S&C B (4 days, $200) | Same at 60/60 on 4 days | Keep, with a stated reason it rates lower |
| Pick the S&C days | Which mornings he runs, for the whole club | Keep; the best weekly decision here |
| Your 4: a coached morning | ×1.25 at your rating | Weak next to the pad night; needs a probe |
| Your 4: a pad night | 75 min at your pads rating, frees the coach's minutes | **Likely dominant:** limit it to 1 a week or give it a cost |
| A mobility morning | Keeps the ×0.85 injury cut | **Useless as priced:** make the cut bigger or the morning cheaper |
| Brown or black BJJ coach | +3.2 or +4.0 a week | Keep, and tie it to promotions (below) |
| Athlete teaches beginners | Saves $68, costs a class | Keep (code) |
| Corner: you or the boxing coach | Nothing defined | **Useless:** give it an effect or drop it |
| Ex-pro edge, sparring 55 | Nothing (you never run sparring) | **Useless:** move it to the corner |

**Missing options**
- A second boxing coach: what they run and who sets the programme.
- A corner choice that changes the corner calls.
- A ceiling on the mat: who can sign which belt.
- Any growth for staff over time.

## To reach 10/10
1. **A morning is rated at the best person who runs it.** The S&C coach's group rating is max(his area, the programme's area) × 1.15, so he never lowers a morning. Re-probe "full-time coach + S&C A/B" and show it on the ladder. The S&C should still add something on top of the full-time coach, or the screen should say "adds nothing to the full-time coach's mornings: buys days and the injury cut".
2. **Rename and limit the group bonus.** "S&C group" is ×1.15 only with 2 or more fighters on the morning, and ×1.00 for one fighter alone. Cap the group at 6, as a real S&C group session would be.
3. **Write the overlap rule.** On an S&C day, a morning that you or the boxing coach have coached is run by that coach at ×1.25 and gets no group bonus; the screen shows which one wins. Bonuses never stack.
4. **Probe pads mastery over 12 weeks per route and per use of your 4,** and add mastery to the hire screen's points as its own column. If the pad night beats a coached morning by over 2 to 1 in value, limit it to 1 a week, or make a self-held night cost 2 of your 4.
5. **Price mobility so it's a real choice.** Either the cut is large enough to matter (×0.6 for that week, and the overreached ×3 drops to ×2), or the mobility morning keeps half its stat gain. Probe injuries over 12 weeks; each choice should win in at least 30% of fighter-weeks.
6. **Fix the head coach's edges.** The Ex-pro's 55 goes to the corner, and the corner becomes real: the corner's rating sets how well the corner calls land, e.g. calls at 0.8 + rating × 0.004, with Ring general on top. The Strength coach gets 55 in one area (strength), or drops its ×1.10.
7. **Define two boxing coaches.** Each has a pad night capacity of 3 × 75 min. The unattended programme takes the better rating per area. The capacity puzzle then loosens, which is the reward for paying for the second wage.
8. **Tie the BJJ coach to promotion, as the IBJJF does.** A brown-belt coach can stripe and promote up to purple. The athlete's brown and black belts need a black-belt coach, and the black belt needs one of 2nd degree (a dearer third candidate, or a guest professor for a fee). That turns the belt choice into a career decision, not a one-off.
9. **Show the hire as weekly and 12-week totals,** not the gain on one morning: "Club +2.6 points in 12 weeks; Stamina +1.7, strength +0.9".
10. **Fix the SANDBOX and names faults:** "THIS WEEK", "your coach", "the S&C coach", faces on the coach row, and no names on tiles, rows or the decision box.
11. **Give staff something that builds over months,** if the owner wants it: a coach's area rises +1 per 12 weeks running that area, up to a cap. A coach who isn't used asks to leave. That gives the player a reason to come back and to plan who coaches whom.
12. **Run the probe again** with items 1–5, publish the table, then send it to two fresh critics for the depth 7 gate.

## The 10/10 page (1920×1080, Look B: Fighter Week, the training whiteboard)

**Shell (0–64):** dark top bar. CONTINUE is the only pulsing button.

**Header (64–170):** your boxer's portrait and name once, "BUILD WEEK · Club show Sat 28 · 12 days", and the tiredness meter.

**Coach row (170–260), on cream paper:**
- **Faces:** a coin for each staff face — you in gold, the boxing coach in blue, the S&C coach in teal — with "Your 4: 3 left" as 4 sun pips.
- **S&C days:** teal chips on the day headers, Tue and Thu.
- **Pad minutes per night,** by face: "Mon 45 / 30 · Wed 75 + you 75 · Fri 45 / 30".

**Board (260–760):** 7 columns.
- **Mornings:** magnets tinted by who runs them, with the coin. A hover gives the rating, the bonus and the gain ("Group 2 fighters ×1.15, Stamina +0.199").
- **Evenings:** pad and sparring magnets with the pad holder's coin and the Usable 30 line on the move bar.

**Decision box (Wednesday):** two cards side by side.
- "You hold the pads: uppercut 23.4 → 30.5, Usable Wed · the other fighter gets 75 min, check hook 12 → 21.1 · costs 1 sun".
- "Your coach splits 45/30: uppercut 28.0, Usable Fri · check hook 15.7".

**Right column (1500–1880), THIS WEEK:**
- what the staff buy this week, in totals: "+0.7 Stamina, +0.5 strength, +15.9 mastery, injury risk 1.3% → 0.8% (mobility Thu)";
- the coach's one change with Do it.

**Bottom strip (980–1060):** the hire ladder as five magnets, each with $/week and 12-week stat points plus mastery: "Sessional +31 / +62 mastery".

**Stress state (the default drawing):**
- two boxers sharing a pad night;
- one in FIGHT WEEK, with the S&C Thursday landing on a rest day (amber);
- one mobility morning;
- the full-time coach hired, with the S&C card reading "adds days, not rating".

## Sources
- [IBJJF graduation system](https://ibjjf.com/graduation-system) (OFFICIAL), read 2026-11-15 through [Martial Arts Professional's summary of Art. 6](https://www.martialartsprofessional.com/ibjjf-belt-rank-rules-academy-owners/) and [Gracie Laval's summary of the 2026 rules](https://www.gracielaval.com/blog/ibjjf-graduation-system-explained). Promotions up to brown are signed by an affiliated black-belt professor; a black belt is signed only by a black belt with 2+ certified degrees.
- [Project BJJ on promotions](https://projectbjj.com/what-you-should-know-about-jiu-jitsu-promotions/), read 2026-11-15. A brown belt may promote to purple where black belts are scarce (Art. 6.3).
- **CHECK, from memory:** England Boxing's coach levels and seconds rules; the UKSCA as the UK S&C accrediting body.
- Every game number above is DERIVED from the pack's and the map's formulas.
