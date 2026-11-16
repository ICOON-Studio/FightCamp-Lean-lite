# DESIGN_COACHSPEC1_R5_CRITIC_JOHN_JOHN - John answer (seat queue SQ200)

Brief: research/DESIGN_COACHSPEC1_R5_CRITIC_JOHN.md
Sent: 2026-11-16 00:10 | collected: 2026-11-16 00:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score COACHSPEC1 round 5 as a fresh critic, starting with a hand check of the member-cap money, the held-night injury sum and the class-night minutes. The owner's computer is still offline, so I can't open `CRITIC_ACCESS.md`, the mockups or the probes.

**Logic check.** I worked the round-5 numbers by hand. I couldn't run the probes because the owner's computer is offline.

**These hold:**
- **The dues arithmetic holds:** $35 a month is $8.08 a week, so 70 members bring in $566 and the 32 members of room bring in $259. The members needed are 13, 25, 26, 79 and 104, and 38 + 26 = 64.
- **The class-night minutes are right:** 285, 255, 225 and 195.
- **The ×0.85 tiredness gives 1.18 times the work before overreaching**, roughly one more Hard morning in six.
- **The held-night injury sums are right:** 2.6% × 50 ≈ 1.3 and 3.9% × 50 ≈ 2.0.
- **The corner numbers check out:** 58 sparring gives ×1.07, and the Ex-pro as second adds +0.03.

**What doesn't hold:**
1. **"Needs a bigger building" is false as a rule.** The full-time coach can be hired on day 0 in the game today. Wages are paid from all income (dues, the +$350 classes, the $250 sponsor, the $450 ticket cut a bout) and from start cash, not from dues alone. And the column counts each wage against gross dues, ignoring the rent ($415 a week) and the costs the club already carries. The honest line is what the hire does to the club's runway: weeks of cash left, before and after.
2. **The held night's load spike probably never fires.** The held boxer does 75 minutes instead of 25–45, which is 30–50 extra minutes. On a week of roughly 10 hours that's +5–8% acute load, so 1.3 becomes about 1.38, not 1.6. Unless the code counts one Hard evening as much more load (CHECK in the load rule), the cost doesn't bite and the held night is still about 20 to 1.
3. **An injury isn't −50 wins in 100.** A training injury before a bout gives the choice the game already has: pull out (the $300 empty slot and a lost $450 ticket cut, with no loss on the record) or fight hurt (−10 to −20 energy). So the injury price is smaller than the map says, which makes the held night still more dominant.
4. **Class nights are priced at a strange rate.** One class frees 30 pad minutes, but a class runs about an hour. On price: dropping a class costs $175 for 30 minutes ($5.8 a pad minute), while a second coach costs $380 for 225 minutes plus 2 mornings ($1.7 a minute). So 0 or 1 class nights only makes sense when there's no member room for a second coach. That's rare, though not empty.
5. **The coach's deal is already the best deal for stats.** It's greedy toward stat gain, so dragging a coin only loses stats unless the player wants something the deal doesn't count: a move, a rested boxer, or a group kept together. Today the drag fixes a mistake rather than being a decision.
6. **Pad nights are counted in two units.** The code counts 240 drill units per 75-minute night, so a 105- or 45-minute night needs the units scaled (336 and 144). The map doesn't say so.
7. **The second coach's money is half counted.** The fitness classes from the staff job bring income that the +$205 net leaves out, and the 4th roster place usually brings a $250 stipend that's also missing.
8. **The guest professor doesn't match how BJJ works (CHECK).** IBJJF black belts are normally awarded by the athlete's own professor of record, not a visitor after one class.
9. **The page kit breaks Look B.** Bebas Neue, IBM Plex Mono and gold for selection go against the owner's rule: Permanent Marker and Kalam, colour only for risk, one pulsing button.

**COACHSPEC1 round 5 scores 7 for DEPTH, 6 for GENERAL DESIGN and 7 for PLAY, so it fails the bar on general design.** It's close: two of the money and load rules contradict the game, and they need fixing before the second critic.

**DEPTH 7.** The hire is now a real decision on two axes, stats or moves, with the second coach and the S&C coach competing for the same 32 members of room. It touches premises, injuries, the fight-week taper, the corner and the no-gi belt career.

It isn't 8 because two of the weekly choices are weak:
- The held night is probably still dominant, because the spike doesn't fire and the injury is overpriced (points 2–3 above).
- The coin drag only undoes the coach's best deal.

**GENERAL DESIGN 6.**
- **Fixed since round 4:** the one-hire merge is clean, the member cap is honest, and the headroom reading of pads replaces the false "pads stop at week 10". Names and pronouns are fixed too.
- **Holding it at 6:**
  - "Needs a bigger building" contradicts the game, where the full-time coach is hireable on day 0.
  - The 30-minute class rate.
  - The unit scaling.
  - The second coach's money is half counted.
  - The page kit is off Look B.

**PLAY 7.** The week has a story:
- the Monday deal;
- the held night;
- "You held the pads on Wednesday: the uppercut turned Usable";
- "landed 3 times" in the fight log;
- the no-work warning a week ahead.

That's anticipation and a reward the player feels. It isn't 8 because the hire itself is a one-off that's never revisited.

**Options**

| Option | Verdict | What it changes |
|---|---|---|
| A goal for the coach's deal: stats, moves or fresh | **Missing** | Turns the coin drag into a decision; the deal then shows what it gave up |
| Runway before and after on every hire | **Missing** | Replaces the false "needs a bigger building" with the real money cost |
| Letting the main boxing coach go (NOT ESTABLISHED in code) | **Missing** | Without it, hiring the full-time coach can never be undone |
| A held half night (40 minutes, costs 1) | Missing, optional | A cheaper middle step, if the full night stays the only big trade |
| 0 or 1 class nights | Weak | Worth it only with no member room for a second coach; keep, but print $ per pad minute on the pill |
| Guest professor at $450 | Weak and unrealistic (CHECK) | Make it "your athlete trains a month at a black-belt academy": a cost plus a month of classes elsewhere |
| S&C A and S&C B | Keep | Each costs more per point, a clean ladder |
| The Ex-pro as second | Keep | Brings the background back to life (England Boxing allows a chief second plus one second; CHECK) |
| Merging the second coach into the staff job | Keep | One decision, cause and fix together |

**To reach 10/10**
1. **Replace "needs a bigger building" with a runway line on the hire card:** "Runway 14 → 6 weeks". Use all income and all costs from `GameMoney`. Show the member cap as the ceiling on what dues can repay, not as a gate.
2. **Measure the held night's load with the code's own acute-load rule** for the three test boxers on a BUILD week.
   - If 75 minutes can't push the ratio past 1.5, change the cost: either it takes the boxer's next rest evening (a Hard evening followed by no rest), or it costs 3.
   - Value an injury as the game does: pull out ($300 + $450 + the morale hit) or fight hurt (−10 to −20 energy, measured in wins).
   - Then apply the ±30% test.
3. **Give the coach's deal a goal switch (stats, moves or fresh),** with "the deal gave up 0.4 stat points for the uppercut" on the board. That makes the drag mean something.
4. **Set a class at its real length:** 60 coach minutes, so dropping one frees 60 pad minutes for $175. Re-check that 0 or 1 class nights then wins in some clubs (a bout in 2 weeks with a move at 26).
5. **Scale the pad units to the minutes** (105 minutes = 336 units, 45 = 144), and add a probe case.
6. **Count the second coach's fitness-class income and the 4th boxer's stipend** in the net, then redo 13.4's table.
7. **Re-run both probes** with a full pad card over 12 and 24 weeks, fill the FRESHNESS column from 400 bouts a cell, and read the corner edge over a bout.
8. **Replace the guest professor with a month at a black-belt academy,** pending the IBJJF CHECK on who may promote.
9. **Redraw `staff_hire` and `evening_plan` in Look B,** then send to two fresh critics.

**The 10/10 page (1920×1080, Club > People > Staff, Look B)**
- **Dark top bar:** the gym name once; cash and runway with hover cards.
- **Left, on the whiteboard (x 40–1000):**
  - five role cards pinned as polaroids (you, boxing coach, second coach, S&C coach, mat coach);
  - under each, what it runs (sun, moon, stool, mat, each with its word), five area meters with words, and the coins a week;
  - the class pill reads "3rd class: +$175 · −60 pad min ($2.9 a minute)".
- **Right, the hire chart (x 1040–1880):**
  - stats wins in 100 across, first Sharp week up, one dot per route;
  - beside each dot, "Runway 14 → 9 weeks", with the line in red only under 8 weeks;
  - a faint line at the Unit's 70 members marks how far dues can go.
- **Bottom strip (y 900–1040):**
  - the coach's deal switch: stats, moves or fresh;
  - the held-night box reads "Load 1.3 → 1.6 · injury ×3", in red only past 1.5, beside "+2.8 wins in 100 before the club show".
- **Type and buttons:** Permanent Marker headings, Kalam text, nothing under 14 px, and one pulsing button: "Hire" on the selected card.

**Sources:** the arithmetic is DERIVED from the map and the pack. England Boxing's corner seconds, UKSCA and IBJJF promotion authority are CHECK, from memory. The acute-load size of a held night is NOT FOUND; it's the test in fix 2. I couldn't open `CRITIC_ACCESS.md`, the mockups or the probes while the owner's computer is offline.
