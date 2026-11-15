# DESIGN_CLUBWEEK1_V9_CRITIC_JOHN_JOHN - John answer (seat queue SQ166)

Brief: research/DESIGN_CLUBWEEK1_V9_CRITIC_JOHN.md
Sent: 2026-11-15 07:40 | collected: 2026-11-15 08:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking CLUBWEEK1 v9's turn table, its money maths and its loyalty rules against the critic pack first, then I'll score it. The owner's computer is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open.

**Logic check.** I worked every row of the turn table under the one-turn-a-night rule, and the money and loyalty sums against the pack.

These hold up:
- **The turn table is right in every row,** with the sessional and the full-time coach. Examples: full class plus one fight week is SHORT 1 · BAG 3; short class plus one fight week is BAG 2, with nobody short; 4 boxers with two fight weeks is SHORT 1.
- **The DERIVED rates are right:**
  - each boxer has a bout in 27 of 100 show weeks (7 ÷ 26);
  - at least one of 3 boxers has a fight week in about 31 of 100 weeks (1 − 0.73³, halved);
  - two fight weeks together come in about 9 of 100 weeks;
  - three together, in about 1 of 100.
- **The coach factors are right:** Luke Reid 0.906, Marcus Hale 1.018.
- **The money sums are right:** +$6,084 a year in class money, +$1,680 in dues, −$2,080 for cover, and −$13,000 a year for one sponsorship.
- **The day job's −0.2 a week is right** (a morning is a fifth of the 1.0 pace).
- **The mornings sums are right:** +1.8 shared, +1.5 solo, +2.4 solo on a WEAK SPOT.
- **The 10% pro share is right** (25% minus the 15% manager part).
- **No names or fixed he or she** in any screen line. All 12 of John's v8 points are answered.

Thirteen things don't hold:

1. **The squeeze has free ways out, so the SHORT cost waits on one probe.**
   - **Rest up sets Need to 2,** so full class plus Rest up is never short. It keeps the full +$117 and costs only what TAPER1 might measure.
   - **A short class fixes the clash for $39.**
   - **If TAPER1 measures under 1.5 in 100,** the map cuts the fight-night cost, and with Rest up nobody is even short. The map's main collision then has no price.
2. **The rewards pay the money lever with loyalty.**
   - **Drift runs only in weeks when Want is met,** and a class week meets only Need. So a class-selling gym's loyalty never drifts.
   - **Fixing each clash with a short class or Rest up pays +2 to everyone** (the reward line), about 16 times a year.
   - **Sponsorship renewals add +2 every 4 weeks** with nothing pulling back.
   - **So the gym that sells most ends Loyal 70+,** and the talk never comes. Probe 1's target (the talk turns up 2–4 times a season in a class-selling gym) can only pass with a careless bot.
3. **Cover is dominated.** In a SHORT week caused by your own class, a full class plus cover nets −$13. A short class nets +$78 and Rest up +$117, with nobody short. On call ($50) also beats cover. So the "−$2,100 cover" line in the year sum follows the worst road.
4. **The volunteer plus a class is a near-free pump.** +$117 minus $120 is −$3 a week, but it keeps +4 on the member target (about +$1,700 a year). It needs only one night at 0.8 instead of three bag nights, and it removes every class-caused SHORT.
5. **A WEAK SPOT morning beats every other morning.** Solo on a WEAK SPOT (+2.4) beats shared (+1.8) on total and on focus. "Shared is the bigger total" holds only when no boxer has a WEAK SPOT.
6. **Pads in the morning has no rule for Need.** If a morning turn counts toward Need, it's a free fix that beats everything in point 1. If it doesn't, it's just a weaker evening turn.
7. **The later date can't fix a class clash.** In a gym that sells a class every week, the next show two weeks on lands on another class week. The button only helps with stacked bouts. It also leans on LADDER1's BOOKED and RESTING words, and LADDER1 v1 failed.
8. **One word means two things.** "Hold pads" names both the loyalty action (the holder gives up their turn) and the Old coach twist's answer (+3 turns).
9. **Two twists don't work as choices:**
   - **Photoshoot:** "Do it" takes a turn from the lowest row, which still meets Need, so +$150 always wins.
   - **Southpaw:** the sparring night costs $80 here, against $160 for the same outside partner in camp (CODE). There's no reason for the difference.
10. **Weight classes can't tell two boxers apart.** "The 65 kg boxer" points to nobody when two boxers share a class, and the map has no fallback.
11. **A quiet week takes two clicks** ("Coach deals it", then Continue, plus a gold Start week). The pack says a quiet week is one click, and the page has two forward buttons.
12. **The units don't match:**
    - COACHFIT1's "8 and 12" adds turns (20 coach minutes each) to mornings (whole sessions), so 6 + 2 adds two different things.
    - The grappler's day job takes 1 of 3 mat classes (a third of her mat time), but a boxer loses 1 of 7 mornings.
    - A turn is worth a 240-unit night in an ordinary week but 120 units in a fight week. That's fine as a taper, but unstated.
13. **Three claims have no source:**
    - **"Females never fight or spar males"** is not in the pack. It's a new hard rule, and it touches Hold pads and the visiting pro.
    - **The taper evidence is half right.** As I recall Bosquet et al. 2007, the best result came from a 2-week taper that cut volume 41–60% and kept intensity and frequency unchanged. The "80%+ frequency" figure is closer to Mujika & Padilla 2003. Both are from memory and weren't reread this pass.
    - **Rest up (2 sessions, 240 of 720 units) cuts volume 67%,** outside the evidence band; Tick over's 50% sits inside it. So the evidence already points against Rest up.

I didn't verify "about 20 minutes of pads per boxer on a real club night" this pass. It stays a CHECK.

I score CLUBWEEK1 v9 at depth 6, general design 6 and play 6, so it meets the owner's bar, but only just, and it has to stay there through the build. Before code, three fixes keep it there: a short fight week has to cost something the game already has, loyalty drift has to run every week, and the cover and volunteer prices have to stop being free ways out. I judged it from the pack, v8's critic and the map only. `CRITIC_ACCESS.md`, the board and the mockups are on the owner's computer, which is offline.

## Scores

**Depth 6.** Five Monday choices are real, with prices on both sides:
- **Selling a pad hour as a class:** money and members against bag nights at half mastery.
- **Full or short class:** $39 against one bag night.
- **The sponsorship against the day job:** $13,000 a year against about 10 points a year on lost mornings.
- **The talk's three answers.**
- **The fight-week load stop.**

They reach mastery, steps, money, members, morale (and through it the corner's trust), the pro share and the bout offer.

What holds depth at 6:
- every collision has a free or near-free fix (Rest up, the short class, the volunteer);
- a WEAK SPOT morning beats the other morning choices;
- cover is never the right answer;
- with 3 boxers, a gym that sells no class meets no squeeze at all, which the map admits.

**General design 6.** This is the step up from v8. The turn table now holds in every row, the words are fixed (pad turn, bag night, film session, the load-stop names), Lock is gone, and the later date follows the no-roll rule.

The rest is strong too:
- the wiring list;
- the cut rule;
- the probes with pass lines;
- the honest "not measured yet" line;
- the CODE / ESTIMATE marks;
- clean names.

It doesn't go higher because:
- loyalty rewards the lever it should tax;
- three options are dominated (cover, the photoshoot's Decline, the later date in a class clash);
- "Hold pads" means two things;
- weight classes can't tell two boxers apart;
- a quiet week is two clicks;
- the mornings and turns budget adds two different units;
- the male/female sparring rule has no source.

**Play 6.** The NEXT WEEK line gives two weeks' warning of a collision, and the collision line on the bout page turns Accept into a real moment. The Monday board is a puzzle with prices on it. "−5: short of a pad turn this week" makes the cost personal.

What holds play at 6:
- the best play (a class every week, Rest up or a short class on a clash) is learnable and then automatic;
- the reward the player feels (+2 loyalty) piles up into a club where nobody ever wants a word.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Coach deals it | Deals turns by fight week, then row order | Keep; it should be the Continue press itself |
| Drag row order / hours | Who keeps the third turn; which night | Keep as plain editing |
| PADS / short CLASS / CLASS | +$0 / +$78 and 2 turns / +$117 and 3 turns, with the member target | Keep; the core lever |
| Cover $130 | +3 turns on a free night, only at SHORT | **Useless as priced:** beaten by a short class, Rest up and on call |
| Pads volunteer $120 a week | +3 turns every week at 0.8 | **Too cheap:** with a class it costs −$3 a week, keeps the member gain and ends class-caused SHORT |
| On call $50 | The same, fight weeks only | Keep; it's the honest fix |
| Rest week | Need 0, morale +4 | Keep |
| Tick over / Rest up / Train through | Fight-week volume and Need | **Rest up is a free fix** until it costs something |
| Solo / WEAK SPOT / shared / morning pads | The morning multipliers | **WEAK SPOT dominates;** morning pads has no Need rule |
| Sponsorship actions | The day job; loyalty | Keep; **renew +2 is a pump** |
| Talk: turn back / promise / straight | Loyalty with a price | Keep |
| Later date | Moves the bout 2 weeks, by rule | Keep for stacked bouts; **useless against a weekly class** |
| Twists | | Heating, Night off, Partner ill, Old coach and Visiting pro are real. **Photoshoot's Decline never wins.** Southpaw's price breaks the camp price |
| Hold pads (loyalty) | Holder to bag, team-mate at 0.85, +3 loyalty | Keep; rename the twist that shares its name |
| Let go | Frees a roster place, −5 to team-mates | Keep |

**Missing options**
- **"No class this week" on the collision line itself.** It's the plainest answer to a class clash and costs exactly $117, but the line lists only short class, cover, Rest up and the later date.
- **A plan rehearsal when there's no tape.** An opponent with no bouts has no tape (pack 4.6), so the fight week's film session opens nothing. Offer "Walk the plan" instead, which drills the plan lines (the pack says an undrilled plan works less well).
- **A senior member holds pads.** Real club nights often pair a novice with a senior member on the pads. That's the club's own volunteer, paid in loyalty or membership rather than cash. It may belong in v2.
- **A boxer marker that isn't a name,** so two boxers in one weight class can be told apart (a portrait chip, or the row number).

## To reach 10/10
1. **Give a short fight week a cost from a hook the game already has, so it doesn't wait on TAPER1.**
   - A fight-week session is plan rehearsal: each missing session cuts the "plan drilled" factor for that bout by a third (pack 4.7: an undrilled plan works less well).
   - Rest up keeps Need 3 but runs 2 sessions plus a tiredness benefit (−15 tiredness on fight night, ESTIMATE). So Rest up is a trade: fresher, but the plan is one-third less drilled.
   - TAPER1 then measures a cost that exists, instead of deciding whether one exists. The taper evidence favours Tick over's 50% cut over Rest up's 67%.
2. **Fix loyalty.**
   - Drift 1 toward 60 every week, whatever is met. A Need-only week also takes −1 when the boxer is above 50.
   - Cut renew to 0.
   - The "nobody short" reward pays +2 once per boxer a season (or becomes a review line only).
   - Then the talk turns up in class-selling gyms, as probe 1 wants.
3. **Price the fixes against each other** (ESTIMATE, COVER1 checks):
   - cover $90, and offered only for a SHORT that your own class didn't cause (bout stacks, heating);
   - the volunteer $150 a week;
   - on call $70.
   - Then a class with a fix is never free.
4. **Balance the mornings:** shared on a pull both boxers hold runs ×1.2 each. Morning pads doesn't count toward Need: write that.
5. **Make the collision line honest:** "No class that week (−$117)" always shows. The later date shows only when the clash comes from bouts. Take BOOKED and RESTING from the code's offer state, not LADDER1, until LADDER1 passes.
6. **One click for a quiet week:** Continue on Monday applies the coach's deal. Cut the Start week button, so the page has one pulsing button (S442).
7. **Words and twists:**
   - Rename the Old coach answer "Old coach takes the pads".
   - The photoshoot takes the turn from the top row, or from a fight-week row if there is one.
   - Southpaw costs $160, the camp price (or say why it's cheaper).
8. **Tell boxers apart without names:** lines carry the boxer's portrait chip beside the weight class. Two boxers in one class read "65 kg (row 2)".
9. **One budget unit with COACHFIT1:** count coach time in minutes (a turn 20, a coached morning 60, a film session 45, all ESTIMATE). Then 8 and 12 mean something.
10. **Make the grappler's day job equal:** 1 mat class every other week (1 in 6), close to a boxer's 1 in 7.
11. **Source the male/female sparring rule or ask the owner.** England Boxing's rules on mixed sparring are a CHECK for John.
12. **Run CHECKs 1 and 2, then probes 1, 3, 4, 7 and 8** with the fixes above, and paste the tables before the page is drawn.

## The 10/10 page (1920×1080, Look B; FIGHTERS, CLUB WEEK)

**Shell (0–64):** dark top bar. CONTINUE is the one pulsing button: "Coach's deal, to Mon 16 Feb". No other forward button exists.

**Header (64–110):** "CLUB WEEK: WEEK 6", with the club crest. No fighter names here; names sit in the row header cells.

**Counter strip (110–200):** five magnets.
- **PAD TURNS:** "Asked 9 · Need 7 · Owned 6 · SHORT 1 · BAG 3". Hover shows the per-night rule.
- **FILM:** "1 of 2".
- **COACH TIME:** "Mornings 6: solo 3 · shared 3". Hover gives minutes.
- **SPONSORSHIP:** "2 of 3 · 1 on WORK".
- **RUNWAY:** "11 weeks".

**Collision line (200–240), red marker, only when it costs:** "NEXT WEEK: fight week on Thursday's class: one session short, the plan one-third less drilled. No class (−$117) · Short class (−$39) · On call ($70) · Rest up (fresher, plan less drilled)".

**Left (40–460), THE COACH'S WEEK:** nights as columns, 3 turn chips each, with portrait chips. Each hour flips PADS, SHORT CLASS (+$78) or CLASS (+$117, +4 members). Friday blank in weigh-in weeks. On call and volunteer slots are greyed until bought.

**Centre (480–1480), THE SQUAD:** one row per boxer.
- The header cell holds the portrait, the name once and the weight class.
- Morale word; loyalty word or bar, with its last cause.
- Up to two stickies (WEAK SPOT, WEAPON).
- Seven morning cells: coached ones carry a face, WORK greyed.
- Evening magnets: PADS solid, BAG hatched, FIGHT WEEK as 3 session magnets plus FILM or WALK THE PLAN.
- The Tick over / Rest up / Train through switch, with its fight-night line on hover.
- The grappler's row last, with SPONSORSHIP and SATURDAY CORNER only.

**Right (1520–1880):** the twist with 2 priced answers; the talk card ("listens: usually") with its three answers; PROMISES OPEN with dates.

**Bottom (990–1060):** "Back to the coach's deal" in plain ink, and the week's forecast line: "This week: +$117 class, 3 bag nights, nobody short".

**Stress state (the default drawing):** a full class on Thursday plus one fight week. The SHORT 1 is shown on the counter, the collision line is red, and a second panel shows the board after "Short class": BAG 2, nobody short.

## Sources
No new outside sources this pass. Every figure is DERIVED from the critic pack and the map's own numbers. The taper studies (Bosquet et al. 2007; Mujika & Padilla 2003) are cited from memory and weren't reread this pass. The England Boxing mixed-sparring rule and the real club-night pad time are both NOT FOUND this pass.
