# R55 pads v2 - critic review (head coach, shared pad hands, 20 years)

Read: CRITIC_PACK, CRITIC_ACCESS, R55_PADS_DESIGN_MAP, pads_rota_v2 (png+html). Scores at the end.

## 1. Is each decision real?
1. **Plan picks the card.** Real. Star plus "needs N weeks" is the best decision on the page: plan around what she owns, or buy the
   stronger answer. It is only real if the plan's need is uncertain. If the opponent is unscouted, "her plan needs it" is a guess;
   tape study / the $250 pro scout should decide which card is worth the pads. Today the screen states it as fact.
2. **Booking.** Real, and the right place. "Take it when one already owns the starred card, pass when both are learning" is a
   coach's actual thinking. Fine as written.
3. **The lay.** Mostly a lookup, not a decision:
   - *Nearer fight first / other first*: the screen prints "Danny a week late" and the card prints "14 fewer in 100" vs "9". Read the
     bigger number. Reid's pre-selected line is a trap you can see through at once. With 25 vs 27 days "nearer first" is a coin
     flip. Never right when the numbers are shown.
   - *Split the nights*: real (single move vs combo) but it is NOT on the screen. The screen's own case (Danny a single move,
     Lucy a combo) is exactly the case where split is interesting. The mock leaves the one free option out, so every lay costs
     something. It looks rigged.
   - *Both whole, no class*: $115 an evening with $18,700 in the till is nothing, and 9 + 14 wins in 100 is worth far more
     than $230 (a win is $450 + 8 members). ALWAYS RIGHT while cash is healthy = dead. Cancelling class costs nothing else:
     no members drift, no regulars lost. A real club loses members when the class is cancelled.
   - *Move a pad night to his free evening*: the screen shows a free Friday and no way to use it, and no reason it can't be
     used. Every coach asks "why not give Danny Friday?" first. Real only if it costs her rest/tiredness (the map says so; the
     screen doesn't show it).
4. **Hiring.** *Second coach $280* is the best buy in the game by the map's own numbers: +40 members at $35 a month is about
   $320 a week, so he pays for himself. DEAD (always right) the moment two boxers share a camp. *Hale* ($1,090): measured
   "how good hardly matters", so Hale buys only evenings; Reid + the second coach give six evenings for $730. Hale is DEAD for
   two boxers and near-dead for three. *Drop the class* needs the member cost above to be a decision. *Reid alone* only with one boxer.
5. **The boxer who goes without.** The best idea on the map: favouritism is the real small-club problem. Keep. The promise is real
   because you can't know whether next camp overlaps. The "next camp" overlap should be visible on Fights.
6. **After.** Fine, but it is a report, not a decision. Needs to feed the next Monday's lay.

Stake check: a one-week effect, a binary "ready or late", one wins-in-100 number. Option count is small and two of five are
dominated. The depth is in the links, not in the lay.

## 2. What is missing (real choices, where they go)
- **Clubmate/senior holds pads** (Fighters > Training + Club > People). This is how every small club actually shares one pair of
  hands. A senior boxer holds at lower hands, free, but spends his own evening. The map has it as "today's no-coach night" and
  never as a choice. Biggest hole.
- **Pad vs bag vs sparring for the other boxer.** The game already prices pads 2.1, bag 1.05, sparring 1.5 an hour. A boxer
  without Reid still learns the card on the bag at half rate. The map says the coach is worth "one week" yet treats no-Reid as zero.
- **The two boxers spar each other** (camp partner, saves the $160 outside mate, risks injury and tiredness). Sparring
  nights need the coach's eyes, not his hands. Screen: Training, Coach row.
- **Corner on a shared show.** Two bouts on one club Saturday are normal. Reid corners one, you the other: Reid's trust and
  rating apply to his boxer. Cut from the map as "no clash"; it is the most common one. Screen: fight night corner.
- **Fatigue.** The Friday fix lands on a boxer at 74 of 100 (overreach at 80: gains x0.6, injury x3). This is the real cost
  of "just add a night" and it is free of invention: tiredness exists. Screen: lay card.
- **Taper.** Fight week has no pads (TAPER). "Ready on the bell" is too late: ready by the START of taper. The v2 screen's
  "Ready week 4, on the bell" is not possible. Screen: bells timeline.
- **Scouting decides the stake** (Fight prep): unscouted opponent = the star may be wrong.
- **Class cancelled** must cost members/reputation, not only $115 (Money, People).

## 3. What is useless
- Hands 74 vs 58 vs 45 on the hire row: the measured result is that rating barely changes the week. A number that changes no
  decision. Either make it matter (a combo needs a minimum, singles do not: INVENTED, measure it) or cut it from the hire row.
- Hale's "two whole, class kept" while a second coach already covers more evenings cheaper.
- The class money strip as a permanent row of "+$115": no action until a lay is picked.
- "Fights in 25 / 27 days" chip repeated on both cards and the bell: three places for one fact.

## 3b. Wired and shown
- Fighters > Playbook (star, "needs N weeks"): right. Add who holds it.
- Fights > offer card overlap line: right. Add "your next camp overlaps" for the promise.
- Home > Monday needs ("both need Reid Mon + Wed"): right; the need must open the lay, not just People.
- Club > People: right place for the rota (it is the staff screen), but the player sets pad nights on the fighter Week.
  Fighters > Training must be able to do the whole fix without going to People, or the player edits in the wrong place.
- Fighters > Training Coach row: right and essential. Show denied nights here (see 4).
- Club > Money line: right, but make it say "class off Mon + Wed: -$230" only when chosen.
- Fighter > Overview "Feels second": right. Add the cause line "no Reid in 3 weeks".
- Missing: Fight prep needs a line "card ready before taper? yes/no". Missing: fight-night corner (shared show).
  Cut: the Why line "Reid was with Lucy" is fine but must name the choice (which lay) that caused it.

## 4. The screen, element by element
- **Rota rows/cells: CHANGE.** Shows only who GOT the night. Danny's denied Mon and Wed never appear, so the clash is invisible.
  Show both faces in a cell, one ghosted with a red cross.
- **Free Friday cell: CHANGE.** Make it a drag target with Danny's ghost and the tiredness cost beside it.
- **Class money strip: CUT as a row.** Fold "class $115" into the Reid cell or the lay.
- **Hire row: CHANGE.** Three "+" cells read as three separate hires. One button; hover paints the cells. "74 / 45" with an icon is a
  label that needs a manual: write "Hands 74".
- **Bells timeline: KEEP, CHANGE.** The hatched "late" bar is the best element. But both bars ending at one place at the bell look
  identical, and the Wk labels sit under the day columns, so they read as the same grid. Add the taper zone and end the bar at the START of taper.
- **Numbers disagree: CHANGE.** Cards say "26 of 30" (4 points, about one pad night) while the timeline says "ready week 4".
  A coach will catch that in one second.
- **Warning chip: CHANGE.** A warning with no action. It should say the free night.
- **Boxer cards and chips: KEEP.** "9 fewer wins in 100" is plain and good. Add tiredness. Drop the second repeated chip.
- **Coach's line: KEEP.** Good, short. The pre-selected default is the worse option; fine as a teaching trap if Reid is wrong visibly.
- **Four lays: CHANGE.** Right shape (name, tick, cross). Put the wins-in-100 number on the lay, not on the card. Add Split and
  Friday. Cost line must say what else it costs (tiredness, members), not only dollars.
- Hard fails: none (type 24 px or more, no blocks of text). Fixed names/pronouns in the mock ("Her plan", "His plan"): the
  sandbox rule says never a fixed he or she.

## 5. Scores (not rounded)
| Look | Clarity in 5 s | Depth | Realism |
|---|---|---|---|
| 6 | 6 | 4 | 5 |

Look: coherent slate and wood, big faces, readable. Loses for the Wk columns under the day columns, three rows of the same info
and a dead-looking class strip. Clarity: the red Danny row and chip read at once; the lays do not say why. Depth: the stake is one
week and the best lay is a lookup; second coach is always right; Hale and "no class" are dead. Realism: a coach would nod at the
rota and shake his head at cancelling class for two boxers and at "ready on the bell" in fight week.

## 6. To reach 10/10 (most important first)
1. Fix the dominated hire. Second coach: give a real cost (roster place, hands 45 can hold single moves only, a combo needs
   Reid: measure it) so Reid's combo night and the second coach's move night make a real rota. Cut Hale from two-boxer
   camps or give him the third boxer only.
2. Add the clubmate-holds option (free, hands 40, costs his own evening) and the pad-vs-bag fallback so "no Reid" is not zero.
3. Put the free option on the screen: Split and "Danny takes Friday", with the tiredness price (74 to 82 = overreached).
4. Put the wins-in-100 on every lay, and make the stake uncertain: unscouted opponent = a range until the tape study.
5. Ready by TAPER, not by the bell. Show the taper zone on the timeline; fight week has no pads.
6. Make cancelling class cost members and reputation, not only $115, so it is right only when cash is tight or the overlap is a week.
7. Show denied nights in the rota (ghost face, red cross); one hire button with a hover preview, not three "+".
8. Fix the numbers on the card to agree with the timeline (8 of 30 means weeks, 26 of 30 means a night).
9. Link the shared show: Reid corners one boxer, you the other; two bouts one Saturday.
10. Let the player fix the clash from Fighters > Training and from the Home need, not only on People.

Drawing: docs/mockups/s425/pads_v2_10_coach.html and .png.
