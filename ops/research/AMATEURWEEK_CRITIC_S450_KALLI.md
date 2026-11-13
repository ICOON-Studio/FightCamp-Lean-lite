# AMATEURWEEK_CRITIC_S450_KALLI - Kalli answer (seat queue SQ60)

Brief: research/AMATEURWEEK_CRITIC_S450_BRIEF.md
Sent: 2026-11-13 14:10 | collected: 2026-11-13 14:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring AMATEUR FIGHT WEEK v4 on this brief only. The critic will follow as text in parts.

Part 1 of 3

# AMATEURWEEK1 v4, the amateur fight week: critic (S450, Kalli)

Judged on this brief only. I couldn't find `camp_plan_v3.png` on my computer. The Miro board, the real screens and `FIGHTWEEKPROBE1_RESULT.md` weren't opened. The probe numbers are judged as the map quotes them.

**Verdict:** Depth 5/10, Play 6/10.

Section 4b is honest, and it's right that a week mustn't outweigh training. But it moves the weight of the choice to the season, and then shows the player only fight-night numbers that sit inside the noise. The season half isn't measured yet (FIGHTWEEKPROBE3 hasn't run) and isn't shown on the box.

On top of that:
- Home wins on nearly every line, because 9 wins at any rank already brings the pro offer.
- The trips buy stat gains for a single week, which are too small to see.
- The kilo ask buys 5 tank points on the flat part of the curve, where they are worth nothing.

As written, the week becomes a formality by bout ten.

## 1. Logic check

**1. The stoppage rest: 8 weeks or 30 days?** The map quotes `Matchmaking.STOP_REST_WEEKS` = 8 weeks and calls it "unchanged". The pack says a stoppage loss is a 30-day suspension, longer for repeats. The sheet's rhythm, the RISK line and the season cap all hang on this. CHECK (Claude).

**2. TAPER "never ran for an amateur bout".** The pack says phases are counted back from any booked bout, with TAPER in the fight week (light, three rest days, no sparring), not only inside a camp. If the pack is right, the load slider and the sparring slider fight with WeekPhase every fight week. CHECK (Claude): whether WeekPhase sets TAPER for an amateur booking with no camp.

**3. Three cards need more shows than the game has.** Code has a club show every other Saturday. Three bouts 1 to 3 weeks out, split home and away, need several clubs' shows in the same fortnight. The map needs a regional show calendar (how many shows a week, which clubs). Otherwise the sheet will often hold one card.

**4. Home is nearly always right.** The pro offer comes at 7 wins with a top-3 rank, or at 9 wins at any rank. Home cards draw names below the boxer, so they are easier wins, and they also bring $450, +8 members and +5 reputation. A player who only boxes at home still reaches 9 wins, so the climb buys only a slightly earlier pro offer. Away is only worth it for the facts and the favour, which do very little (points 9 and 10).

**5. The trips' buffs act on a week's gains.** "Stamina gains x1.25" applies to the banked part of one week, which the map caps at a full week of pace 1.0 (x coach factor x headroom). That's about 0.25 of a stat point for $575 to $1,000. The owner's line was "the buffs need to be real and reflect in the fight". These can't reach the 4-in-100 cap the map sets, or anything a player can see. City club stay-over ($1,000 for one extra sparring night over the $150 commute) is dominated.

**6. The ON FIGHT NIGHT box can't show the choice.** By 4b, every load stop is within about 3 wins in 100 on fight night, inside the probe's noise (400 bouts gives about ±2.5). The win band won't visibly move when a slider moves, so the player learns the sliders don't matter. The banked part, which is where the map says the weight is, has no row on the box.

**7. Tick over's credit isn't built.** "+1 plan line ready" means nothing while FireLevel is off: lines fire every time. Until FIRELEVEL3, Tick over is the same as Rest up minus the flat round 1. The map says so for film, but not for the load table.

**8. Train through's season cost has no mechanism.** The season target expects always-Train-through to lose "2-5 more stoppages or injuries". The only carried cost is +1 tiredness on a 0-100 scale, and tank loss starts only past 50. Nothing in the map raises injury risk or damage for Train through. Without it, FIGHTWEEKPROBE3 will find no such loss.

**9. Ask for a kilo buys nothing.** The opponent's +5 tank sits in the 0-8 band that 4b measures as inside the noise. The kilo also replaces an Eat less of at most 1 kg, which costs up to 10 tank points, also mostly on the flat part. A favour spent for no visible effect is an option nobody should take.

**10. Favours do almost nothing.** At 0 a club still offers ranked names on away cards and only refuses a kilo, which is worth nothing (point 9). So the count never costs the player anything. Earning one (an away novice bout, a late replacement) has no payoff either.

**11. Pass double-counts.** Code already has "a month without a fight -6" for morale. The pass's -3 and ring rust at 6 weeks sit on top. A pass then costs -3 now and -6 later, plus a flat round 1 worth about 1 to 4 in 100. Say which applies.

**12. Who pays: loyalty does nothing yet.** The pack says loyalty exists but isn't shown, and that a broken goal making a fighter leave is AGREED, NOT BUILT. "+1 Loyalty" for the boxer paying therefore has no effect. Savings come from "the stipend's leftover", but John says club boxers get no stipend beyond the club's, and the code's stipend is optional ($250, Pay or Stop). A boxer with the stipend stopped has no savings, and the boxer-pays option is greyed for good. Half of a $575 cottage ($288) is 4 to 11 weeks of savings, so in practice the boxer can only pay the $150 commute.

**13. The coach's pick has the wrong coach on it.** "The head coach's face, how sure the coach is, grows with the coach's rating." The head coach is the player. The pick should come from your assistant, with the assistant's rating. With no assistant, there's no pick, or a plain default.

**14. Words that aren't the game's.** "Cardio", "Legs" and "Power" as training shares don't match the attributes: Stamina, Strength, Explosiveness and so on, with Power read from them and not a number of its own. One word per concept.

**15. The ticket cut at a board-run show.** The club keeps $450 from a show the regional board runs, and gets nothing away. A club taking a cut from a show it doesn't host needs a source. CHECK (John): whether a club gets a share of tickets its own boxer sells at a board show. Real club boxers usually sell tickets for any show they're on.

**16. Weight and the class limits.** "2.5 kg at 57-65" is quoted as the category width, but the game's women's classes are 57, 60 and 65 (widths 3 and 5). CHECK (John): the 2026 rule 2.7.8 categories against the game's four classes. The regional table "stays per class" while matching ignores the class: say which class a boxer's win counts in when the agreed weight crosses a limit.

**17. A screen not in the pack.** "Office desktop (OFFICE1)" is in the menu table, but it isn't one of the agreed menus or the screens in the pack. Either cite the owner's OK, or move its row to Home, which is where needs live today.

**18. Names.** The map keeps names out of rows, and its examples ("two weeks: Uppercut Usable", "rating 58") are clean. Two lines to watch on screen: the corner line in two-show nights must name the role ("your assistant"), and the free facts at away shows will list other boxers. Those are opponents in a list, so show them as portraits with class and record and the name in the card header only.

Part 2 of 3

## 2. Depth: 5/10

I went through each choice over a season with four boxers.

**Which bout:** a lookup. Home is easier, pays, and grows members, and 9 wins at home bring the pro offer (logic 4). Away only matters for a boxer chasing the 7-win top-3 route, which is two bouts sooner.

**Novice home or away:** a lookup too. $450 against a free fact and a favour that buys nothing.

**Date:** partly real. Two weeks gives "Uppercut Usable" when a move is near a line, which is visible and good. The trips it opens are worth nothing (logic 5).

**Where to train:** nobody takes them. The only one with a visible effect is the seaside's mood +3, which costs $590 against the club paying +3 mood for any trip, including the $150 commute. The commute (+1 plan test per sparring night) is the only trip with a use.

**Load:** inside the noise on fight night. It's a real choice only over the season through the banked part, and the player doesn't see that part (logic 6). With the banked rows shown, it becomes the best decision in the map. A full week against a fifth, over about 10 fight weeks a season, is about 8 focused weeks of training. By the pack's own measure (5 stat points is worth about 72%), that's worth more than the map's 4-8 target, so FIGHTWEEKPROBE3 may need to make Rest up cheaper, not dearer.

**Sparring:** close to always 2. The 3 tank points a night on a one-week bout sit on the flat part, and every night adds a plan test. John's "last sparring 7+ days out" has no price in the game.

**Weight:** trivial alone. It's real only when stacked: Train through (12) plus Eat less 1 kg (10) is 22 off, which reaches the steep part of the curve (about 8 to 16 in 100). That combination is the one real fight-night trade in the map, and the box doesn't call it out.

**Film:** real. One pad night for one habit group, confirmed in round 1, once FIRELEVEL3 is on. Until then the 90% line doesn't exist, and film only opens a tell, as today.

**Who pays:** the club pays whenever there's cash (logic 12).

**Kilo and favours:** do nothing (logic 9, 10).

**Is 4b convincing?** The finding is convincing: a fight week sharpens, it doesn't build. The answer isn't finished. The map moves the decision to the season and keeps a fight-night box as the only thing the player reads. Unless the box shows the banked work and the season cost, the week is a formality, and "The coach runs this week" becomes the right answer every time.

**Chore by the tenth bout:**
- Four boxers mean about 40 sheets a season, and "Coach picks the bout" saves most of them.
- 25 in 100 fall-throughs mean about 10 stops a season across the club, each one choice. That's acceptable.
- Two-show nights add a few more.

## 3. Play: 6/10

**It pulls me on:**
- Three cards with a "Coach picks" escape.
- "Wins to the table: n" for novices.
- "Two weeks: Uppercut Usable".
- The fall-through choice.
- The season line on the tab.
- The result page's sizes.

**What holds it at 6:**
- Fight nights look the same whatever the week was, by 4b's own numbers.
- The trips are pictures with no effect.
- The climb isn't needed.
- Nothing in the week grows over a season: the fifteenth fight week has the same five places and three sliders.
- The film confirm, the most exciting moment, waits on FIRELEVEL3.

## 4. Options

**Missing:**
- **A BANKED row on ON FIGHT NIGHT**, with the stat points this week adds ("+0.6 Technique, +0.3 Stamina"), and the season line under it.
- **A combined warning** when tank losses stack past 12 (load + sparring + Eat less), with its price in wins.
- **A price on late sparring** (inside 7 days): a cut or training-injury risk for that week.
- **A regional show calendar**, so three cards are possible.
- **A rule for a bout 3 weeks out:** what week 3 holds on the screen.
- **A savings source** when the stipend is stopped, or no savings at all.
- **A use for favours** at 0 that costs something.

**Useless as written:**
- City club stay-over.
- Hill cottage and seaside as one-week gain multipliers.
- Ask for a kilo (+5 tank).
- Half each.
- +1 Loyalty.
- +1 tiredness carried.
- Tick over's "+1 line ready" until FIRELEVEL3.

**The menus:**

| Menu | Right place? | Found? | Can't act on or wrong |
|---|---|---|---|
| Boxer page, Fights tab | Yes | Yes | Home dominates the cards (logic 4); three cards need a show calendar |
| Fights rail list | Yes | Yes | Nothing |
| Bout card | Yes | Yes | RISK quotes a rest length that may be wrong (logic 1); the kilo option buys nothing |
| Fight week screen | Yes | From the card | No banked row; trips with no visible effect; coach's pick from the head coach |
| Week board | Yes | Yes | Clash with TAPER if it runs (logic 2) |
| Office desktop | Not in the pack | Unclear | Cite the OK or move it to Home |
| Boxer card (Roster) | Yes | Yes | Nothing |
| Tape room | Yes | Yes | SEEN / CONFIRMED waits on FIRELEVEL3 |
| Playbook | Yes | Yes | Per cent waits on FIRELEVEL3 |
| Region, favours | Yes | Hard | The count changes nothing (logic 10) |
| Continue | Yes | Yes | Nothing |
| Fight night, two shows | Yes | Yes | Role, not name, in the corner line |
| Corner minute | Yes | Yes | Waits on FIRELEVEL3 |
| Result | Yes | Yes | Add the banked work and the season line |
| Money | Yes | Yes | The home cut needs a source (logic 15) |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Run FIGHTWEEKPROBE3 before the build and put the season on the box.**
   - ON FIGHT NIGHT gets a BANKED row (stat points this week, from WeekPlan's pace) and a SEASON row: "Rest up every bout this season: about n wins in 100 behind".
   - Size the banked fifth, half and full from the probe. If a full week over 10 bouts is worth more than 8 in 100, raise Rest up's banked share instead of hiding it.
2. **Make home and away a real trade by changing what the climb buys.**
   - The pro offer at any rank needs 9 wins with at least 3 over ranked names (away).
   - Home cards draw names within 3 places below or level, not far below.
   - An away win over a name above gives +2 reputation on top of the place.

   Now a home-only boxer never turns pro without going away.
3. **Make trips act on what the fight reads.**
   - City club commute: +1 plan test a sparring night and one opponent-style partner (the camp's $160 southpaw rule: removes the round-1 penalty).
   - Hill cottage: 6 tiredness cleared and the week fully banked at Tick over's tank cost.
   - Seaside: tiredness to 30 and mood +5, banked a half.
   - Cut the city stay-over.

   Each trip must show a fight-night or banked number on the box, and CAMPPLACE1 must measure each one at 1 to 4 in 100 across a season.
4. **Price the stacked tank.** The box sums load, sparring and Eat less into one tank figure, with its wins price from 4b's curve ("22 off: about 9 in 100 at even"). This is the one real fight-night trade. Make it visible.
5. **Price late sparring.** A sparring night inside 7 days of the bell sets the training injury chance for that week at x1.5, and adds a cut risk at the next bout's damage roll. A two-week bout's week-1 sparring is free. Now 0, 1 and 2 are each right somewhere.
6. **Give Train through a carried cost that exists.**
   - +6 tiredness into the next week, not +1.
   - The training-load spike rule (ratio 1.5+) is counted on the fight week, so back-to-back Train through raises injury risk 2x. That's the code's own rule.
7. **Make favours matter.**
   - At 0, a club offers no ranked names for 4 weeks, then resets to 1. The lock is bounded, and the count costs something.
   - Ask for a kilo moves the agreed weight by 1 kg, so the boxer skips Eat less, instead of handing the opponent 5 tank points.
   - A host can call in a favour: a late replacement ask you can refuse for -1.
8. **Settle who pays.**
   - Savings come only from a stipend being paid. If it's stopped, the boxer can't pay, and the screen says so.
   - Drop Loyalty until the leaving rule (AGREED, NOT BUILT) exists.
   - Keep Half each only if it has its own effect: mood +2 and half the cost.
9. **Fix the code facts.**
   - The stoppage rest (8 weeks or 30 days): CHECK Claude.
   - Whether TAPER runs for an amateur booking: CHECK Claude. If it does, the load slider replaces it by name.
   - Pass morale versus "a month without a fight -6": one rule.
10. **A regional show calendar** (shows per week per club in the region) so three cards are possible. Show "no third card this fortnight" when there isn't one.
11. **The coach's pick comes from your assistant,** sureness from the assistant's rating. With no assistant, the default week with no sureness.
12. **The game's own words:** Stamina for Cardio; Strength or Explosiveness for Power; no "Legs".
13. **Week 3:** a bout 3 weeks out shows week 1 as a normal Week (BUILD) and weeks 2 and 3 on the fight-week screen.
14. **Probe order:** FIGHTWEEKPROBE3 (season), CAMPPLACE1 (season, not one night), BudgetProbe, the favour test, the bout count under the cap.

These need things the game can't do yet: FIRELEVEL3 (the 90% film line, the confirm, Tick over's line), savings, Favours, CampPlace, the regional show calendar, and the bout-day weigh-in.

### The 10/10 fight-week screen at 1920×1080

The shell stays: dark top bar, left rail. The content is the WarmKit whiteboard. The boxer's name appears once, in the header.

- **Header** (full width, about 110 px): comic portrait, name, class, record, walking weight against the gap, wins to the table or the place, and the bout: the opponent's portrait, home or away, days to the bell, and the favours with that club.
- **Where to train** (left, about 520 x 480 px): three or four polaroid cards (home, city commute, cottage, seaside). Each shows its cost, ONE effect in numbers ("tiredness -6", "+1 plan test a night"), and why it's locked when it is.
- **How hard** (centre, about 800 x 480 px): load, sparring and weight sliders with picture stops. Under each stop, its tank and banked numbers. A stacked tank bar under all three, with its wins price at the right of the bar, turns marker-red past 12 off.
- **ON FIGHT NIGHT** (right, about 560 x 760 px, the one gold frame), with two halves:
  - TONIGHT: tank at the bell, sharp or flat, lines ready, scale margin, win band.
  - BANKED: stat points this week, the move that crosses a line ("Uppercut Usable"), tiredness carried, and the season line ("this habit costs about n in 100 by May").

  Each row shows its change from the assistant's default.
- **Film and the file** (left, under the trips, about 520 x 280 px): the five groups SEEN / CONFIRMED / UNKNOWN, Film on one of the boxer's own pad nights (shows which), and free facts waiting at an away show. Greyed with "no bouts, no tape" for a debutant.
- **Who pays and your assistant's pick** (centre, under the sliders, about 800 x 280 px): Club or Boxer with cash and mood (the Boxer option greyed with its reason), and the assistant's note with a one-line reason, sureness, and Use the pick.
- **Season strip** (full width, bottom, about 120 px): home and away so far, money, places climbed, away wins over ranked names against the pro-offer need, bouts of 11, the next sheet's date, and Continue's next stop.

There's no score and no best-week badge. Hovering any number shows its rule.

CHECK (Claude): `Matchmaking.STOP_REST_WEEKS` against the 30-day suspension; WeekPhase TAPER for an amateur booking; how the stipend feeds savings.
CHECK (John): a club's ticket share at a board-run show; the 2026 categories against the game's classes; real late-sparring injury evidence.
