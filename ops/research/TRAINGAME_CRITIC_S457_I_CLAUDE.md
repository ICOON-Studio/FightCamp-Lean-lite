**AS A GAME: 6/10. DEPTH: 5/10.**

# Training scene I (S457): a fresh critic (Claude)

I judged `docs/mockups/s457/training_h/training_scene_i.png` (source `training_scene_i.html`) and `profile_training_tab_h.png`.
For the look I compared them with `docs/mockups/s449/camp_v3/camp_plan_v3.png` and `assets/ui/moves/body_hook.png`. I checked the
numbers against `scripts/rules/` (WeekPlan, PadWeek, MoveMastery, FilmEdge, InjuryRoll, BoutRules, WeekPhase, FireLevel, Combos.LEARN_AT).
I did not open GameState.gd or FightRealtime.gd, and I read no other critic file.

Most of the numbers check out. Kwame's own week matches the code to half a point:
- Each day's tiredness: Mon 68, Tue 64, Wed 70, Thu 67, Fri 70, Sat 63, Sun 55. With Sat sparring, Sat 68 and Sun 59.
- Each morning's gain, including Light x0.6 on Thu.
- The check hook's path: 12, then 21 (Mon), 25 (Wed), 32 (Fri).
- Thu sparring gives the body hook a share and gives the check hook nothing (it is under 30, `Combos.LEARN_AT`).
- Hold against Cut: 70.5 kg against 69.6 kg.
- The 51% grows by one weapon past four (+0.3 power).

The screen is carefully traced. Its defects come from the parts drawn without the code: the coach's week, the shared night, and the
week that follows.

## 1. Logic check

The most serious defects come first.

1. **The coach's week and the NIGHTS chips do not follow the rules, and this hides the screen's best decision.**
   - The coach's Hard week had Tue pads ("was: Pads"). WeekPlan keeps 87% of tiredness each night and adds load / 44. A pad night is
     5 x 75 / 44 = 8.5 points. So the coach's week runs Tue 73, Wed 78, Thu 74, Fri 76, with a peak of 78.
   - The screen shows Tue "coach 68", Wed "coach 71", "HARD (COACH) 71" and "peak 70 Wed (coach 71)".
   - At 78, InjuryRoll.fatigue_mult is about x2.4. Injury for the coach's week is then about 2.7 in 100, against 1.0 for the
     player's week.
   - The chips are also off. Light (pads Mon and Wed) and Standard (pads Mon, Wed and Fri) both peak at **70 on Wednesday**, the same
     as YOURS, because film carries no load. The code gives a flat 70 / 70 / 70 and then a cliff at 78, not the screen's
     62 / 68 / 70 / 71.
   - The real story is that the player's Tuesday film keeps the boxer under the injury line. The screen erases it.
2. **The shared Wednesday night is not applied to his gains.**
   - The strip says "Wed 60/40". Yet "+4 / +3" is exactly a full 240-unit night split 55/45. A full night is 2.1 x 4 h x 1.296
     (Luke's pads 74) = 10.89 points. Check hook: 10.89 x 0.55 x (1 - 21/72) = 4.2. Body hook: 10.89 x 0.45 x (1 - 29/72) = 2.9.
   - On 60% of the night he would get +2.5 / +1.8. On 40% he would get +1.7 / +1.2.
   - "The other boxer's jab +5, not +9" implies that the other boxer had about 60% of the night. So either his numbers or the share
     is wrong.
   - "Coach's night: all on check hook 21 -> 28" is 28.7 in the code, which shows as 29 under the screen's own rounding.
3. **The body hook has two values.** THIS WEEK BUYS says 29 -> **34**. Its bar fill ends at 32 (44% of 72), the Wednesday card says
   29 -> **32** Usable, and the profile tab says 29 -> **32**.
4. **The coach's week is not this week's coach week in code.**
   - Twelve days before the bout, WeekPhase.phase returns PEAK. That means sparring twice (Tue and Thu), and PadWeek.lay puts the Hard
     pads on Mon, Wed, Fri and Sat. The PEAK mornings start with Hard intervals on Monday.
   - The screen gives the coach Tue pads, one sparring night, an open Saturday and different mornings.
   - If the S428 amateur "no camp" week needs its own template, WeekPhase must change, and the screen should say which week the coach
     wrote.
5. **The film evening outside a camp is not a rule today.**
   - WeekPhase.film_night exists only in the first week of a Build-phase camp.
   - WeekPhase.edit_eve takes only rest, pads or sparring.
   - Dragging Film onto Tuesday of a no-camp peak week needs a rule (and an answer on tape when there is no camp).
6. **Saturday 21 is the other boxer's fight night.**
   - The club's one coach is in her corner that evening. Kwame's Saturday sparring drop shows no clash.
   - "RUN THE WEEK" cannot run the week: the clock stops for her fight night (pack 5.0: the big button is CONTINUE "to <date>,
     <reason>").
7. **The weigh-in is "Fri 27", but the code weighs amateurs on the day.** BoutRules.tank_parts_for uses same_day for non-pros
   (CLUBWEEK 4), so the weigh-in is Sat 28.
8. **"Injury this week 1.1 -> 1.4 in 100" for one sparring night is three to four times too high.**
   - InjuryRoll.training_chance = 0.013 x hours/10 x multipliers. Thirty more minutes adds about 0.07 in 100, with the peak still 70
     (under 72) and the load ratio almost unchanged. So 1.1 -> 1.2 at most.
   - Training injuries are hand, ribs or strain. "A knock" is a bout injury word.
   - The profile tab says "1 in 100".
9. **"Tank at the first bell 39" looks too low.**
   - With no camp, PadWeek.pad_share keeps the fight week's three pad nights at full minutes (half minutes apply only in camp).
   - Starting from Sun 55, my reading of WeekPlan gives Mon 60, Tue 54, Wed 55, Thu 50, Fri 55, and about **48 at the first bell**.
     With Saturday's sparring it is about 50: on BoutRules.FRESH_FATIGUE, where each point over the line costs 2 energy.
   - If that holds, the Saturday choice is not free. The screen shows it as free.
10. **"Rest -8 tiredness" is the nightly 13% decay, which happens after any morning.**
    - Rest's own effect is only the load it skips: about -1.6 against a Light speed bag and -5 against Normal roadwork.
    - "Mobility: recovers" and "Rest night: recovers" carry no number, which breaks the rule of one number a tile.
11. **The Stamina goal's warning has no fight stake.**
    - BoutRules.FADE_STAMINA is 60. At 60.3 he does not fade, so missing 60.4 costs only morale. The screen never says so, but
      ON FIGHT NIGHT flags it with the amber "!".
    - "Roadwork on Sat closes it" adds +0.09 to 60.28. Whether that reaches 60.4 is a rounding call.
12. **One word and two lines clash.**
    - The screen has two 72s: the move cap and the tiredness line.
    - The camp plan screen draws tiredness "of 80" (WeekPlan.OVERREACHED). This one draws only 72 (InjuryRoll.FATIGUE_RISK_FROM). Show
      both lines, each with its effect.
    - "Tank" means tiredness here, where higher is worse. In the code, "tank" is the energy off at the first bell. A tank reads full =
      good, so the metaphor is inverted.
13. **"One coach, four fighters" is not what the rules say.**
    - Rosa is no-gi. Her classes are taught by the no-gi coach (pack 4.15), and she never uses boxing pad nights.
    - Danny, the one with no bout, appears nowhere on the strip. Thursday and Saturday are missing from it.
    - The agreed pad-night sharing is "only while two are in camp" (pack 4.2 and 6). Nobody is in camp here.
    - Three boxers at 3-4 pad nights each need 9-12 nights, but the club has 6. The strip shows four.
14. **Small items.**
    - The Friday tile says "+7 Usable" without naming the move.
    - Rosa's class reads "-64 kg" while the others read "Welter 70 kg".
    - Kwame's tag "YOUR WEEK" and Mara's tag "FIGHT WEEK" mix who wrote the week with the phase in one slot.
    - The profile tab says "nights: Hard", but his nights are YOURS (3 pads, film, 1 spar).
15. **Names.** They appear only in headers: the fighter cards and "vs Jade Okoro" on the bout card. Rows and notes say "the other
    boxer" and "your coach". This passes.

## 2. As a game: 6/10

**Five-second test: partly fails.**
- The eye lands on 14 picture tiles and 7 tanks, then on four information panels.
- The verb (drag a session onto a day) is a 15 px grey line in the bottom tray.
- The ways to change the week sit in five places: the L/N/H toggles on each tile, the NIGHTS chips, Undo / Coach's, the clicked
  card's split, and the tray.
- About 230 numbers and labels are on screen. The owner asked for "little text".
- What each option improves is shown, by how much, on every tile. That is the screen's real strength: one number a tile, in stat
  colours.

**Art.**
- It matches the game. The tile photos are the camp plan's painted gym (same light, same 3D look).
- The session icons are the Playbook's ink: red figures, a blue sparring partner, gold motion arrows, in stat-coloured rings.
- But the photos sit behind text and repeat (the gloves photo three times in one row), and the ink icon is only about 50 px inside a
  tile. On the day board the art is wallpaper, not the thing you read.
- The coach's handwritten note is the best piece on the screen.

**Planning a week for four fighters.**
- You plan one fighter at a time. Nothing shows the club's week at a glance.
- The one decision that only a four-fighter club has (who gets the coach) is a single strip with one red line.

**Compared with other games.**
- Football Manager's schedule shows the same grid with less noise, and puts the outcome in a separate panel.
- Punch Club shows one choice at a time with its bars, readable in a second.
- Motorsport Manager draws tyres and fuel as curves with a projection to the flag. The 7 separate tanks here want to be that one
  curve to the first bell.

It is a competent, honest planner. It is not yet a screen you enjoy, because what matters and what is decoration have the same size.

## 3. Depth: 5/10

What moves this bout in the code:
- **Moves past 30:** +0.3 power each past four, about +1.5% each.
- **An answered tell:** +0.4 power, about +2%.
- **First-bell tiredness over 50:** 2 energy a point.
- **Training injury:** x2 by 76 and x3 from 80.
- **Weight:** pass or fail.

What does not move it: the mornings. A morning adds about 0.1 to one of six stats, so the whole week's +0.6 is about +0.5% on this
bout. The screen gives the mornings seven big tiles and a stats panel, and gives the levers a corner.

For this fighter and this bout there is one right plan:
1. Get both hooks past 30.
2. Film on Tuesday.
3. Stay under 72.
4. Rest Saturday.

The coach's advice button states it. The example drop (Saturday sparring) changes nothing on fight night by the screen's own numbers
("win +0"), and the code puts its injury cost at +0.07 in 100. A trade-off with no stakes is not a decision.

Trade-offs that would change from week to week, and are thin or absent here:
- **The coach's minutes shared across fighters.** This is zero-sum, and it changes with each fighter's calendar.
- **The fight week**, where pad time costs first-bell freshness.
- **The season:** potential headroom, Specialty holding 60+ moves, mornings compounding.
- **Weight:** Cut has no cost in the code, so Hold against Cut has one answer.

The depth is in the rules (the tiredness cliff at Hard, the 29.9-versus-30 knife edge on a split), but the screen's own numbers flatten
it.

## 4. Options: missing, useless, the profile tab

**Missing**
- **Drill cards for the evenings.** These are the moves, combinations and own combinations of pack 4.2, "Learn on the pads". A pad
  night says "+9 a move", but there is nothing to pick which move or combination it drills. This is the evening planner the owner
  called a core mechanic (S354).
- **A club row for the coach's minutes.**
  - Each night is 75 minutes, split by fighter and draggable, with every fighter's minutes against what his nights want.
  - A night is locked when the coach is in a corner.
  - This changes who gets ready by fight night, and it is the reason four fighters are fun.
- **The fight week.**
  - WeekPhase.ahead_view already lets the weekend plan the next week. The first bell is set in the fight week, and this screen stops
    at Sunday.
  - Adding it changes the tiredness at the bell and whether this week's extra pads cost the bout.
- **The picked fighter's twist card.** Pack 4.1 says one is drawn every week. Only Danny's card is flagged, and it cannot be answered
  here.
- **The no-gi fighter's board.** Clicking Rosa should switch to three classes, the syllabus move she is closest to owning, and the
  stripe call. Nothing shows how the board changes for BJJ.
- **A partner or stance option** when the opponent is a southpaw (BoutRules.NEVER_FACED). Today it is a camp-only option, and amateur
  bouts no longer have camps.
- **The cost of a missed goal** (morale), shown on the goal row.

**Useless or redundant**
- **Three ways to go back.** The Undo arrow, "Coach's" and "Take the advice" overlap. Keep the advice button plus one Undo.
- **The STATS panel at full size** for changes of 0.05-0.18. Fold it into one season line.
- **THE OPPONENT panel.** It repeats the film note in the right column. Keep the tells once, beside the film.
- **The seven separate tanks.** One curve says more.
- **The Saturday drop strip.** As drawn it buys "+0, no new tier". A preview should appear big only when a fight-night line moves.

**The profile tab**
- A read-only summary with one button is the right idea. This one disagrees with the scene: "nights: Hard", body hook 32 against 34,
  injury 1 against 1.1.
- Half its area is empty or a designer's note. Four portraits of other fighters on one fighter's profile are out of place.
- It should show:
  - the win chance with its parts
  - the moves crossing 30
  - the tiredness curve to the first bell
  - weight
  - the unanswered card
  - the coach's minutes he gets this week against what his nights want
  - Open in Training

## To reach 10/10

The most important come first.

1. **Every number from the rules, and the same number everywhere.**
   - Coach's Hard week: Tue 73, Wed 78, peak 78, injury about 2.7 in 100. Light and Standard 70.
   - Apply the shared night's share to his gains, or remove the share.
   - One body hook value.
   - Injury from InjuryRoll (+0.07 for a sparring night).
   - Amateur weigh-in on the day.
   - The first bell from the real fight week.
   - Make the screen read WeekPlan, PadWeek and InjuryRoll for its numbers, plus one test that loads a fixture and checks the drawn
     values against the rules.
2. **The coach's minutes as a club row at the top of the board.**
   - Each evening is 75 minutes, drawn as a bar stacked by fighter (portrait chips), with the split dragged on the bar.
   - Each fighter card shows his minutes this week.
   - The evening is locked when the coach is in a corner.
   - The no-gi fighter is off the row: she has her own coach.
   - The game cannot do this today. Pad sharing is AGREED, NOT BUILT, and only "in camp". It needs PadWeek nights to carry shares
     by fighter, and the owner's yes to use it outside camp.
3. **Lead with what moves the bout.** Top right, the win chance as a stack:
   - today's value
   - each move crossing 30 (+1.5)
   - an answered tell (0 to +2)
   - first-bell tiredness over 50 (minus its cost)
   - the coach's own week as a reference mark

   Shrink the mornings to one "season" strip with "this bout +0.5%, ten weeks like it +5%".
4. **One tiredness curve** across this week and the fight week, to the first bell.
   - The 72 line (injury x2 by 76), the 80 line (gains x0.6) and the 50 fresh line on fight night.
   - The coach's week as a grey ghost, and a dragged card as a second ghost.
   - Rename "tank" to tiredness: the pack's word, and higher reads worse.
5. **Plan the fight week here**, as a column right of Sunday that can be opened. It sets the first bell.
6. **Restore the drill-card tray for the evenings** (moves, combinations, own combinations).
   - A pad night shows its card or cards and minutes.
   - Crossing 30 flashes READY on the tile and in the win stack.
   - Show the knife edge: "60 min: 29.9, not ready / 65 min: 30.4, ready".
7. **Calendar truth.**
   - CONTINUE "to Sat 21, fight night".
   - A Saturday evening locked while the coach is in a corner.
   - The fight-week tag as a phase, and "your week" or "the coach's week" as a separate small mark.
8. **Give Cut a cost** (for example, a slower recovery while cutting), or show weight as a single forced line. Today it is a checkbox
   with one answer. This needs a rule.
9. **Honest numbers on Rest, Mobility and Rest night**: tiredness saved against a light session, and the Recovery or Flexibility gain
   (WeekPlan computes attr_gain).
10. **A no-gi board for the BJJ fighter**: three classes, the syllabus move she is closest to owning, the stripe call, and the open's
    date.
11. **Bigger ink, fewer photos.** Make the ink icon the tile's hero (64-72 px), with the photo as a dim band. Never repeat a photo in
    one row. Keep the camp plan's painted look for the tile backs and the Playbook's ink for the icons.
12. **Cut the redundant panels**: the opponent panel (merge it with film), the drop strip when nothing on fight night changes, and the
    extra Undo / Coach's.
13. **Rebuild the profile tab as a true summary**: the win stack, the five fight-night lines, the curve, the coach's minutes, the
    flags and Open in Training, with no designer note and no other fighters' portraits.

## My 10/10 drawing

`docs/mockups/s457/training_h/critic_claude_i_10.html` -> `critic_claude_i_10.png` (rendered and checked).

My drawing uses code-derived numbers:
- Tiredness for each day from WeekPlan.
- Pad gains from MoveMastery: a full night is 10.89 x (1 - m/72).
- Each move past four adds +0.3 power, about +1.5%.
- The fight week runs as my reading above (first bell 48).

Panel by panel:
- **Top bar.** The club, back to the gym floor, the date, money, and **CONTINUE to Sat 21, fight night**, because the clock stops
  there.
- **Fighters strip.** Four cards: the name as the header, class and sport, the next event, a phase tag (PEAK WEEK / CARD / FIGHT
  WEEK / MAT WEEK), and the coach's minutes each gets this week (185 / 65 / 50). The no-gi fighter reads "no-gi coach, 3 classes".
- **COACH row (top of the board).** Each evening is a 75-minute bar stacked by fighter with portrait chips:
  - Mon: all his.
  - Tue: the two others.
  - Wed: 45 / 30.
  - Thu: sparring night, with the coach refereeing.
  - Fri: 65 / 10, selected, "drag the split".
  - Sat: IN THE CORNER, locked.
  - Sun: closed.

  This is the four-fighter decision, in plain view.
- **MORNING / EVENING rows.** Seven columns of picture tiles with the ink icon in its stat ring, one number and one line:
  - Light / Normal / Hard on the morning tiles.
  - "was:" tags on changed tiles.
  - Rest shows "-3 tiredness vs light", not the nightly decay.
  - Saturday evening is a locked tile.
- **FIGHT WEEK column.** Mon 23 to Sat 28: the coach's taper (3 pad nights, no sparring), the weigh-in on the day, and first-bell
  tiredness 48 under the 50 line.
- **TIREDNESS curve.** One line from Monday to the first bell, with:
  - the 80 overreached band, labelled "gains x0.6"
  - the 72 dashed line, labelled "injury x2 by 76"
  - the 50 fresh line on fight night
  - the coach's Hard nights as a grey ghost peaking at "78 with Hard nights", so the injury cliff the player avoided is visible
- **THIS WEEK BUYS.**
  - Check hook 12 -> 30, READY Fri. Body hook 29 -> 31, READY Wed. Bars to his cap 72, with the Usable line.
  - Ready to throw 4 -> 6, each one past four +1.5% to win.
  - Beside them, MORNINGS as a season line: six stat gains, "this bout +0.5%, ten weeks like it +5%", and the Stamina goal with its
    trade (Sat Roadwork for Shadow: goal met, Technique -0.12).
- **SESSIONS tray.** Mornings left and evenings right, as round ink icons with one number each at Normal.
- **53-55% TO WIN (top right).** The bout header (club show, Sat 28, the opponent) and a stacked bar: TODAY 50% + body hook ready
  +1.5 + check hook ready +1.5 + the second tell 0 to +2. The coach's own week sits as a reference (52%).
- **ON FIGHT NIGHT.**
  - Weight on Cut, 69.6 of 70.0 (Hold lands 70.5: the bout is off, $300).
  - First bell 48, under the 50 line.
  - Peak 70 Wed, under the 72 line.
  - Training injury 1.0 in 100.
  - Stamina goal 60.3 of 60.4, with what missing costs (morale -5).
- **FRI EVENING (the clicked night).** The 65 / 10 split bar with its handle. "Check hook at 60 min: 24 -> 29.9, not ready." "At
  65 min: 24 -> 30.4, READY, +1.5%." "The other boxer (fights Sat): jab -0.3, stays Usable, win +0." This is the knife edge that
  makes a split a real choice.
- **Coach's pick.** The handwritten note on paper with the coach's face: five more minutes Friday makes the hook ready, the other
  boxer only needs to stay loose, and the coach is in that corner Saturday night. 85% SURE.
- **TAKE THE ADVICE: FRI 65 / 10**, with win 53-55% and peak 70.

Rules this drawing needs that the game does not have today:
- Coach minutes split by fighter on one night, outside camp.
- A film evening outside a camp.
- A Saturday evening locked by a club-show corner.
- A cost for Cut.
