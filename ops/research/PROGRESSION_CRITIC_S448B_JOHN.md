# PROGRESSION_CRITIC_S448B_JOHN - John answer (seat queue SQ52)

Brief: research/PROGRESSION_CRITIC_S448B_BRIEF.md
Sent: 2026-11-13 10:45 | collected: 2026-11-13 11:03 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# PROGRESSION v2 (S448): critic

Depth **6/10**, play **7/10**. Holding moves gives each fighter an identity and the professional read gives the pro stage its own problem. I'd defend that much of the design to the owner. Depth stays at 6 because the minutes that the whole holding budget is built on contradict the pack, and two of the style sets and one of the coach hires can be picked without thinking.

## 1. Logic check

- **The pad night is 75 minutes, not 240.** Pack 4.2 says "A pad night is 75 minutes split over its cards". M3 builds the holding budget on 240-minute pad nights and 180-minute sparring nights, so the claim that a fighter can hold "about 4 to 5 Sharp moves and 1 to 2 Signatures and still learn" doesn't follow. At 75 minutes, the club's 8 nights come to 600 minutes for four fighters, about 150 each. Holding 4 Sharp moves and 1 Signature at the map's rates costs 120 of those minutes. That leaves about 30 minutes a week for the learning slot, so a move takes months to reach Usable. The pick cadence in PROGPROBE1 then fails. The 180-minute sparring pool is also not in the pack. Read `PadWeek.spar_pool` before trusting it.
- **Two style sets are free on day 0.** Volume puncher is Jab, Cross and Step out, and Boxer-puncher is Cross, Lead hook and Step in. All of those are row-1 moves the fighter starts with at 30 to 51. Every fighter gets close to one of these styles, and its extra plan line, just by drilling starter moves to 60. So "which style" is a lookup: whichever is cheapest. Slugger, a style word in the code, has no set at all.
- **The Feint is taken away from amateurs.** The S448 code check lists `feint` as a built `StrikeMap` plan arrow that works in full today. Gating it until turning pro removes a built plan answer. Round 1 had the same problem with own chains, and v2 kept those open.
- **Old saves set steps to 30.** That drops every running fighter from full strength to "fires 1 in 2" overnight once FireLevel is on, so a save loaded mid-camp gets worse with no warning.
- **The coach market has an easy pick.** The young pads coach (pads 64, +16, $380) reaches 65 after 10 pad sessions, which is under two weeks. After that the young coach is cheaper than Reid ($450), gives the same second slot, and grows to 80. So Reid is only right for the first fortnight. The old trainer (pads 80) caps the Signature rate at 1, the same as anyone from pads 75. The extra 5 points buy nothing.
- **The visiting-pro answer has no price.** Pack 4.1 says a twist card's two answers each carry a visible price. "Teach the slot's move, x2" doesn't say what it costs.
- **Veterans teaching depends on a "sparring pair" (C17)** that isn't in the pack. Treat it as not established until C17 is built.
- **The read's logic is one-sided.** "Club opponents have no tape on them" doesn't hold up, because the player's own tape study reads amateur opponents' tells. That's fine as a design rule, but call it a rule, not a fact.
- **Week 6 doesn't add up.** Samira's Body hook gets from below 60 to 60 on 3 pad nights. That needs more mastery than about 3 nights of 75 minutes give (roughly 3 to 4 a night at Reid's rating, with diminishing returns near the cap). The example works only with 240-minute nights.
- **Pronouns remain.** The map's prose still uses "she holds" and "her plan" in section 6. Game text is covered by SITWORDS1, but the mockups drawn from this map will copy the prose.

## 2. Depth: 6/10

**The pick is now a real choice.** Rows open by how many moves are Usable, the cards carry reasons that change with the next opponent's style word, and no card is pre-marked. PICKSPREAD1's bar (coach's first card best under 5 in 10) is the right test.

**Holding is the career choice.** Choosing what to hold and paying for it every week is the depth the game was missing, but only once the minutes are true (see above).

**Easy picks:** the two starter styles, the young coach, and old saves.

**Nodes nobody takes:** Herd (it needs Cut off and does the same job), and Push off beside Tie up. Both must clear TREEVALUE1, and the map rightly says they merge if they fail.

**Chores:** with 75-minute nights, holding will crowd out learning, and the Week becomes upkeep. The fix is a pricing change, not a different screen.

**What shows on fight night:** the fire share (with FireLevel on), the grade (with GRADE1), the steps in the 3D, the style's extra line and the read. FIGHT-PROVEN's +3 is small but tied to a line the player can see. There are no invisible +1s left.

## 3. Play: 7/10

There's always a next thing with a date on all three clocks, and the first pick arrives in week 1. Amateurs build a style, pros get read and have to cover their specialty, and veterans teach. That is a real arc, and the professional stage now has its own problem to solve.

It's not a 10 because the season clock leans on awards, which mean nothing after turning pro. The pro season needs its own named milestone that isn't a belt, for example covering the read on two lines. And the novice still has nothing tied to a date that the player chose.

## 4. Options and menus

| Place | Verdict |
|---|---|
| Profile, NEXT UNLOCKS | Keep. Hide the award chip after turning pro. |
| Playbook > Moves, the tree with the Specialty board | Right place. Hold and Drop must be the same control as the pad tray: Hold puts a minute card on the tray, and Drop removes it. Otherwise there are two ways to do one thing. |
| Combos and the Game plan greyed lines | Keep. |
| Week pad tray, "Hold: 60 min this week" | Keep. Here is where the hold actually gets paid. |
| Monday review | Keep. |
| Home: A MOVE TO PICK (steel), A SIGNATURE FADING (amber) | Keep. A fading Sharp move gets no need, which is right. |
| Fighters cards: style and award | Keep the style. Hide the award for pros. |
| Bout card from the style word, then Fight prep after a tell | Correct order now. |
| Fight night grade on hover | Fine. |
| The Why: NEXT plus "your Jab line was read" | Keep. |
| Club > People market | Keep, after fixing the prices. |
| Pro offer, the Feint and the read | Keep the read line. Drop the Feint gate. |
| **Missing: the club's pad-night board** | Holding and learning both spend the club's 8 nights, but the agreed "Coach's pad nights" row appears only when two fighters are in camp. With holding, it's needed every week for any club with 2+ fighters. Put it as the top row of the Week, or the trade-off can't be seen. |
| **Missing: the read before the bout** | For a pro, Fight prep must say which line the other corner will wait for, with Write a line on it. Otherwise the read only shows up in the Why, after the bout. |

The coach side is deep enough now: a market, growth, a rate instead of a cliff, and the head coach's own pads. It doesn't need more, it needs pricing.

## To reach 10/10 (mechanics, most important first)

1. **Re-price holding on 75-minute nights.** A starting point is Sharp 10 minutes a week and Signature 20. Sparring credits a fixed number of minutes to each plan move, read from `PadWeek` instead of an assumed 180. HOLD1 must show that a careful player holds 4 Sharp moves and 1 Signature and still gets a move to Usable within 4 weeks.
2. **Make every style set cost something.** Each set needs at least two nodes from row 2 or higher. For example, Volume puncher becomes Jab, Step out and Roll out, and Boxer-puncher becomes Cross, Lead hook and Pivot. Add a Slugger set (Body hook, Uppercut, Tie up), or retire the word. HOLD1 also needs to check that no style is named in more than 1 in 3 careers.
3. **Gate the Feint by mastery, not by turning pro.** Put it in row 3 with Jab 60. The read gives pros their reason to want it.
4. **Make the read visible before the bout.** Fight prep names the line the corner will wait for and offers Write a line or Swap. READ1 then measures with a player who answers it beforehand, not only one who learns about it in the Why.
5. **Show the club's pad-night board every week** for 2+ fighters, as the top row of the Week, showing holds and learning by fighter. This is the AGREED R55 row, made unconditional.
6. **Price the coach market by growth.** Young coaches grow slowly at first (+1 per 20 sessions until 70). Reid is the only one ready for Signature work in season 1. Above pads 75, the extra rating pays as mastery speed, not as the Signature rate. COACHMARKET1 checks wage per useful point.
7. **Map old saves fairly.** Steps start at the FireLevel tier that matches today's behaviour (Sharp 60 for any arrow already in a plan, 30 otherwise), with a Monday line explaining it.
8. **Give the visiting-pro answer a price.** For example, the week's sparring night is lost, or $120.
9. **Give pros a season milestone that isn't a belt.** "Covered": a pro whose two most-fired lines both stay above the read's cost for two bouts. That gives the pro season a dated goal.
10. **Build C17 sparring pairs before veteran teaching.** List it as a dependency in the build order.

## The 10/10 tree page at 1920×1080

- **Rail (96 px) and dark top bar (64 px):** as they are now.
- **Header, full width, 120 px:** the comic portrait, name, class, record and rank, height and reach, the style named (or "2 of 3 for Pressure fighter: Tie up"), and the award chip for amateurs only.
- **Tree whiteboard, left, 1080 × 700:** four columns of magnets (Lead hand, Rear hand, Footwork, Defence and inside) in four rows. A By branch / By place in the ring toggle sits top right.
  - Each magnet has a bar with ticks at 30, 60 and 85, a grade letter, and a gold pin when the move is FIGHT-PROVEN.
  - A ring marks the moves in the slots.
  - Held moves have a small clock showing their minutes this week. Fading moves have a red date.
  - Locked moves are chalk outlines showing the line they wait for. The cap is shown on the bar ("cap 75: Technique 66 for Signature").
- **Right column, 640 px wide, three panels:**
  - **Top (280 px):** the slot. Either the coach's three cards side by side (weeks to Usable, opponent modes it answers, what it opens, grade, what waits, Pick), or the move in the slot with days to 30 and Swap with its price.
  - **Middle (260 px):** the Specialty board. Held moves with minutes due, how they're covered (sparring or pads), the style they count toward, and Hold or Drop, which writes the pad tray. For a pro, a "Read on: Jab 1-2" line with its answer status.
  - **Bottom (160 px):** a selected node's detail, with Watch, Drill, the plan answers it gives and the combinations it opens.
- **Clocks strip, full width, 120 px:**
  - **Week:** the nearest line and its day.
  - **Season:** the next award or style move with an estimated week (for a pro, "Covered" progress).
  - **Career:** the pro offer's distance, or the next Signature with its Technique need, or the coach gate ("Young coach: 6 sessions to 65").
- **Pad-night strip, along the bottom edge, 80 px:** the club's 8 nights as magnets per fighter, split into learning and holding, plus the $75 overtime night.

**Bottom line:** v2 fixes the round-1 breaks. Re-price holding on 75-minute nights, re-cut the two starter styles, and stop gating the Feint to pros, then run HOLD1. If HOLD1 passes, this is the tree to draw.
