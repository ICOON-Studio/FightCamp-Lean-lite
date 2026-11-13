**AS A GAME: 6/10. DEPTH: 5/10.**

Critic: Claude (fresh, S457). Judged: `docs/mockups/s457/training_h/training_scene_h.png` (+ its HTML) and `profile_training_tab_h.png`,
against `ops/research/CRITIC_PACK.md`, the camp plan `docs/mockups/s449/camp_v3/camp_plan_v3.png`, the Playbook pictures in
`assets/ui/moves/`, the session icons in `docs/mockups/s456/training_f/icons/`, and the rule code in `scripts/rules/` (WeekPlan,
WeekPhase, PadWeek, MoveMastery, FireLevel, FilmEdge, InjuryRoll, BoutRules). My 10/10: `docs/mockups/s457/training_h/critic_claude_h_10.png`.

## 1. Logic check

Numbers I re-worked from the code, and where the picture breaks them. Most important first.

1. **Sparring on Saturday does not move the win chance, yet the strip says "Win 55 -> 56.5%".** The drop takes both hooks from 32 to 34.
   Both stay inside Usable (30-59). The fight reads only the tier: FireLevel.share gives 0.5 anywhere in Usable, and
   BoutRules counts a weapon once it reaches 30. Going from 32 to 34 changes nothing on fight night. The only real gain is
   Fight IQ +0.08. The screen's one live decision is drawn with a made-up payoff.
2. **"Injury 1 -> 3 in 100" for that drop is not in the rules.** InjuryRoll.training_chance is 1.3% per 10 hours, times the
   load ratio, times the fatigue multiplier. The multiplier is x1 below 72, and Saturday peaks at 68. The night adds about half
   an hour. That gives about 1.1 to 1.4 in 100, not 3.
3. **"Hurt = no bout" is wrong, and the coach's note repeats it ("A knock now and there is no bout").** A fighter hurt before
   a bout gets a choice: pull out (the club pays for the empty slot) or fight hurt (10/15/20 less energy). See pack 4.10.
4. **The same sparring night shows two different gains.** On Thursday it is "+0.08 Fight IQ". On Saturday it is "+2 both
   hooks". In code a sparring night gives a share to every card at 30 or more (PadWeek, Combos.LEARN_AT). After Wednesday the
   body hook is at 32, so Thursday's sparring also drills it. The move totals (29 -> 32) leave that out, so the bars, the
   "Buys" line and the Thursday tile cannot all be true.
5. **The win chance appears in two forms.** The top box says a range, 53-55%. The drag strip starts from a single number,
   55, which is the top of that range.
6. **The NIGHTS preset no longer describes the week.** HARD "3 pads · 2 spar" is lit, but Tuesday's sparring became film,
   so the week is 3 pads + 1 spar + film. HARD also says "peak 70", which is the player's edited week. The coach's Hard week
   peaks at 74 on the same screen (Wednesday tank, the USE COACH'S PICK button). So Hard has two peaks on one screen.
7. **The coach's own week crosses the red line he warns about.** His week peaks at 74, above the 72 injury line, while his
   note warns against a knock. "USE COACH'S PICK" (51%, peak 74) is just the coach's week again, which the "Coach's week"
   button already does. It is not his advice ("I'd rest"), which is already true in his week (Saturday evening is a rest
   night there). That makes two buttons for one action, and one of them is mislabelled.
8. **The mornings are not the coach's peak week, yet none is marked YOURS.** WeekPhase.WEEKS.peak is: Mon Hard intervals,
   Tue the camp's focus session, Wed roadwork, Thu Light slip rope, Fri intervals, Sat Light shadow, Sun rest. The picture
   shows the base week's shape (roadwork, heavy bag, intervals, Light speed bag...), all Normal.
9. **"No bout booked · build" (the lightweight's card) is wrong.** With no bout the phase is Base (WeekPhase.phase). Build
   only happens 3 or more weeks before a booked bout.
10. **The Stamina goal ignores fight week.** "60.1 -> 60.3, 0.1 short" is the end of THIS week. The taper week still has two
    Light roadwork mornings (WeekPhase.WEEKS.taper), about +0.1. On its own numbers, the goal is met by fight night with no
    change, so "Roadwork on Sat closes it" (which only reaches 60.39) is a fake problem. A 0.1 Stamina goal also means
    nothing to the player. Goals should be lines the fight reads (BoutRules has captions such as "Stamina 60: no fade from
    round 3").
11. **"On fight night" lists numbers that are not fight-night numbers.** This week's tiredness peak and this week's injury
    chance belong to this week. The fight-night tiredness is the tank at the first bell (BoutRules.FRESH_FATIGUE 50; each
    point over costs 2 energy). It appears only as tiny text, "taper -> 39", in Sunday's tank.
12. **Two different 72s.** "Bar end = the cap 72" is a move's mastery cap (MoveMastery.cap). The red tank line 72 is the
    tiredness level where injury risk starts to rise (InjuryRoll.FATIGUE_RISK_FROM). They share a number and a colour logic
    on one screen. The player will read them as the same thing.
13. **Scope S428 against the nights table.** S428 says an amateur club-show bout needs no camp: "a light fight week, 1 to 2
    weeks out". This welterweight's club show runs camp nights (Light/Standard/Hard = 2+1 / 2+2 / 3+2, PadWeek.NIGHTS.camp)
    and a "peak week". Between fights, the nights table is 2+1 / 3+1 / 4+1. Either this bout has a camp, which contradicts
    S428, or the presets are the wrong table. The peak phase itself is fine (S451: phases come from any booked bout).
14. **One morning tile and one evening tile each hide a gain.** A plain pad night also trains Technique (WeekPlan.EVENINGS
    pads, at a session's share); the tile shows only the move. Rest trains Recovery and Mobility trains Flexibility (S434);
    the tiles say "-8 tiredness" and "recovers", which breaks the one-number rule.
15. **Smaller items.**
    - The coach's Wednesday night "21 -> 28" works out to 28.7 under the rule, so 29.
    - Peak "70 Wed" is shared with Friday (70).
    - The stat list mixes the old summary stats (Power, Technique) with the new abilities (Stamina, Speed, Fight IQ).
    - The fighter is 8-1 and #2 regional. Under the rules a pro offer has already come (7 wins + top 3). That is fine if he
      said no, but the screen gives no hint of it.
16. **Names.** No name sits in a row, option or button. The four names are on the selector cards (headers), and the opponent
    is named once in the bout box, which works as a header. The profile tab's dashed note ("his Q-S294-217...") is designer
    text and must not ship.

## 2. As a game: 6/10

What works:
- **The drag preview** is the best game moment in any training screen this project has drawn. While the card is held, a
  strip names what the drop buys and costs, and the tank shows the amber rise.
- **The tanks under each day**, with the coach's week as a grey ghost mark. You see at once whether you are working harder
  or easier than the coach. That is the Motorsport Manager tyre-and-fuel feel the owner asked for in S442.
- **The coach's handwritten note** and the dark panels match the camp plan screen. The painted tile pictures are the camp
  plan's own style.

What stops it:
- **Five-second test: fail.** I count about 90 numbers and three legends ("bar end = the cap 72 · green line = Usable ·
  grey = the coach's week"; the pads/mornings rule sentence; "numbers at Normal · hover a ring for its stat"). A legend
  means the encoding is not self-evident.
  - The moves strip, the stats strip, the opponent strip and the fight-night card all report the same week four ways.
  - Each 180x100 tile holds a photo, an icon ring, an L/N/H pill, a name, a number and a stat word. The photo behind the
    icon competes with the icon.
- **It is not a four-fighter screen.** The strip picks one fighter, and each board is planned on its own. Nothing on the
  screen makes the four compete for anything: the coach's pad nights, sparring partners, the ring. Planning four boards
  side by side is four times the clicks without a fourth of the decisions. Football Manager solves this with unit schedules
  plus individual focus. Here the fighters share a coach (pack 4.2, "Coach's pad nights", agreed R55), and the screen does
  not use it.
- **Mornings are cosmetic and the screen says so itself** ("a week moves tenths"). Seven slots and ten sessions, each worth
  0.05 to 0.12, are a lot of dragging for numbers the player cannot feel. Punch Club made stat training matter by making
  each session visibly move a bar toward an unlock. Here nothing on the morning side crosses a line the fight reads.
- **Icons match the Playbook only halfway.**
  - Pads, sparring, speed bag, slip rope, shadow, heavy bag and neck use the Playbook's dithered ink (red against blue, the
    gold arrow).
  - Film, rest, rest night, mobility, strength, intervals and roadwork are a smoother painted-ink family with grey skin and
    soft shading. Side by side in the tray, the two families show.
  - Rest and Rest night are almost the same picture (a man on a bench with a bottle).
  - Neck shows a high guard, not neck work.
  - Several crops cut the head off at the ring edge (speed bag, slip rope, neck, shadow).
- **The pad nights cannot be fed from this screen.** The tray offers one generic "Pads +9 a move". There is no row of move
  and combination cards (the "Learn on the pads" tray in pack 4.2 / 5.5) to drag onto a night. Choosing WHICH move to drill
  is the evening's real decision, and here it is hidden in the clicked-card panel.

## 3. Depth: 5/10

Once you read the rules, the week has one right answer:
- **Film beats everything.** It costs no tiredness (zero load) and is worth 0 to +2.5. Always take it, then write the
  answer.
- **The split pad night beats the coach's single move.** It turns a second move Usable (+1 weapon, +0.3 power) and leaves
  the first one Usable too.
- **Saturday sparring buys nothing for this bout** (see logic 1), so rest is right, and the coach already says so.
- **Hold vs Cut is not a choice.** Hold misses weight and calls the bout off.
- **Hard nights show no cost** that the other presets avoid ("peak 70", under the line, 1 in 100), so Hard dominates.
- **Mornings decide nothing** (tenths).

The trade-offs are drawn, but under the real rules they collapse. The game's core rule says "every week costs something",
and nothing here costs the player anything they would miss. Depth comes from three things this screen lacks:
- a shared resource across the four fighters (the coach's nights, sparring partners);
- thresholds the fight reads (stat lines, tier dates before fight night);
- a cost that lands later (fight-night tank, injury that forces "pull out or fight hurt", a move that fades when it is not
  drilled).

## 4. Options: missing, useless, profile tab

Missing, each with what it changes:
- **Pad cards tray** (moves, combinations, own combos, habit fixes), each card with its mastery bar and tier lines. Dragging
  one onto a night shows the gain and the tier date. It decides which weapons exist on fight night.
- **Coach's pad nights across the club** (agreed R55). Two boxers on one night share it. Moving one fighter's pads off a
  night gives another a full night. This is the four-fighter decision.
- **Sparring partner.** Sparring needs a club mate near the weight or an outside mate ($40 a visit, a southpaw mate removes
  the round-1 penalty). It tires the partner too, and a fighter in fight week cannot spar. This makes sparring a club
  choice, not a free toggle.
- **The weekly card answered in the strip** (the lightweight's unanswered card). Unanswered, the coach picks on Monday. Today
  the player has to leave the screen to answer it.
- **Fight week preview**: one strip showing next week's tank on the first bell and when each move crosses a tier. It tells
  the player whether this week's extra work arrives fresh.
- **The BJJ fighter's board.** Picking her should swap the board to 3 mat classes and syllabus move cards (pack 4.15), run by
  the no-gi coach. The picture never shows what happens when you click her.
- **"Coach runs it" per fighter** (agreed, not built). Fighters you do not want to plan keep the coach's week and drop out of
  RUN THE WEEK's checks.

Useless or misleading:
- The NIGHTS presets with no visible cost. Show the injury chance and peak on each, and switch to CUSTOM once edited.
- "Coach's week" and USE COACH'S PICK doing the same thing.
- "80% SURE" with no basis on screen.
- The Hold option drawn as a choice when it loses the bout. Show it as a fact.
- The legend line under the moves.
- The pads/mornings rule sentence (move it to hover).
- The STATS strip, whose tenths duplicate the tiles.

Profile tab: mostly the right summary: the week in one row, what it buys, fight night, one button. Changes:
- Cut the "other three fighters" picker. A profile is one fighter's page, and the Training scene's strip already does this.
- Cut the dashed designer note.
- Move the chance to win to Fight prep, where it already lives.
- Add last week's planned-vs-actual row: the week review's job, folded in.
- Add the weeks to fight night as a line (this week, fight week, the bout) with the tank on the first bell.

## To reach 10/10

Most important first. Each item is specific enough to build.

1. **Make every number come from the rules** (fixes logic 1-14).
   - The drag preview computes its win change through FireLevel and BoutRules: a tier crossed or not, weapons counted. When
     no tier is crossed it says "+0, no new tier".
   - The injury change comes from InjuryRoll.training_chance (hours, ratio, peak).
   - "If hurt" says "pull out or fight hurt", in the strip and in the coach's note.
   - Sparring nights show their move shares wherever they happen.
   - One win format: a range everywhere.
   - The fighter strip's state comes from WeekPhase.phase.
   - The mornings come from WeekPhase.WEEKS[phase], with the player's changes marked YOURS.
2. **Add the coach's pad nights row above the week** (the agreed R55 rule, now for all four fighters).
   - Six evening cells (Mon-Sat), each showing the faces of the boxers on it and each one's share (one boxer 100%; two share,
     for example 70/30 when one is on a taper half night).
   - A red tag names the cost to the other fighter ("-2 for her").
   - A separate dashed cell for the no-gi coach's mat classes.
   - Dragging a fighter's pad night to a free evening is the four-fighter decision. NOT BUILT: PadWeek runs one fighter at a
     time today; this needs a club-level night allocator.
3. **Add a pad cards tray: the Playbook's own ink pictures as cards.**
   - Check hook, body hook, the combination that unlocks when the body hook is Usable (1-2-3b), a held combination that fades
     when not drilled, and the fighter's own habit fix.
   - Each card has a mastery bar with Usable 30 and Sharp 60 marks, and "12 -> 30 Fri, 2 full nights".
   - The evening tile then shows the move's own ink picture, not a generic pads icon.
4. **Tie the mornings to lines the fight reads.**
   - Replace "Stamina goal 60.4" with BoutRules' real lines ("Stamina 60: no fade from round 3"), shown as marks on the stat
     and as "met Fri / coach's week: Sun" on fight night.
   - A morning tile that crosses a line gets a green line-chip. Mornings then matter at the thresholds and stay quiet
     elsewhere.
   - If no line is in reach this week, the board says so and the mornings collapse to the coach's week (one click less).
5. **Make the fight-night card read fight night.**
   - Show the tank at the first bell (fresh under 50, energy lost above).
   - Show weight as a fact with the cut on.
   - Show the stat lines met, and moves ready (with "each past 4: +1 in 100").
   - Show the tape's tell, "+0 now, +X when written", with a WRITE IT button straight into the Playbook line.
   - Keep this week's injury chance as its own row, labelled "this week".
6. **Make sparring a club choice.** Pick the partner (a club mate within the weight band, or an outside mate at $40, a
   southpaw mate when the opponent is one). The partner's tank rises too. No sparring 7 days or less before a bout without
   the coach's warning.
7. **One ink family for every session icon.**
   - Redraw film, rest, rest night, mobility, strength, intervals and roadwork in the Playbook's dithered ink: red fighter,
     blue partner when there is one, gold motion arrow.
   - Make rest (bench, towel) and rest night (dark, a moon or a closed door) clearly different.
   - Make neck show a neck harness or a bridge.
   - Keep the whole head inside the ring.
   - Drop the photo behind the icon in a tile, or dim it to 35% behind a left-to-right fade, so the icon reads first.
8. **Cut the text by half.**
   - Remove the legends and the rule sentence (hover them).
   - Remove the separate STATS and THIS WEEK BUYS strips. Their content lives on the tiles, the pad cards and the
     fight-night card.
   - One number per tile, always a gain in the tile's colour.
9. **Presets with costs.** Each NIGHTS preset shows peak and injury chance ("3+2 · 74 · 2%"). It switches to CUSTOM the
   moment the player edits a night. Use the between-fights or fight-week table for an amateur club show (S428).
10. **One coach button.** "Take the coach's pick" applies the advice in the note (here: rest Saturday, move the lightweight's
    pads off Monday) and shows its result ("53-57%"). "Coach's week" stays in the board header as the reset.
11. **The weekly card on the strip.** A pulsing "CARD: answer" chip on the fighter who has one, opening its two answers in
    place. RUN THE WEEK says "1 card to answer" until it is answered.
12. **The BJJ board.** Clicking the BJJ fighter swaps the seven columns for her 3 classes with syllabus move cards and the
    stripe call. The strip says "3 mat classes" so the player knows before clicking.
13. **The profile tab** as in section 4: one fighter, last week planned vs actual, the road to fight night, Open in Training.

## My 10/10 drawing, panel by panel

`docs/mockups/s457/training_h/critic_claude_h_10.html` -> `critic_claude_h_10.png` (1920x1080).

- **Top bar.** Gym, Gym floor / Training, date, cash, RUN THE WEEK with "1 card to answer" under it.
- **Fighters strip.**
  - Four cards: portrait, weight class and sport, state chip (YOUR WEEK / COACH'S / FIGHT WEEK), next event in red when
    booked.
  - A thin tank at the right of each card: the fighter's tiredness against the red line.
  - The lightweight's card carries a pulsing "CARD: answer" chip.
  - The BJJ card says "3 mat classes".
- **Coach's pad nights (new row).**
  - Six evening cells, each with the faces on it and their share. Monday is shared 70/30 with the feather in fight week,
    tagged red "-2 for her". Thursday is sparring with the club mate as partner.
  - A dashed MAT cell for the no-gi coach's Tue/Thu/Sat classes.
  - No names: faces only.
- **This week.**
  - Header: peak week, fight week next. NIGHTS presets each with peak and injury chance; CUSTOM lit once edited. Undo,
    Coach's week.
  - Seven columns. The morning tile has a big ink icon ring, one big number in the stat's colour, the session and the stat
    under it, and an L/N/H corner pill. Friday's roadwork carries the "60.0" line chip: the Stamina line is met.
  - The evening tile shows the move's own Playbook picture when it is a pad night ("+7 Check hook, shared night"; Wednesday
    "+4 / +3 Split night" with a USABLE chip; Friday "+7, 23 -> 30" with USABLE). Thursday sparring reads "+0.08, Fight IQ ·
    body hook +2". Tuesday film reads "1 tell, was: sparring".
  - The tank under each day, with the coach's ghost mark. Sunday reads "52, bout day 38".
  - The drag preview strip for Saturday sparring tells the truth: buys Fight IQ +0.08 and hooks +2 with no new tier; win
    "+0 (no tier crossed)"; the partner, a 10 kg lighter club mate, tires too; cost tank 60 -> 65 and injury 1 -> 1.4 in 100;
    if hurt, "pull out or fight hurt".
- **Pad cards.** Five cards in the Playbook's ink pictures, each with a mastery bar (Usable and Sharp marks) and its date:
  - Check hook 12 -> 30 Fri;
  - Body hook 29 -> 32 Wed;
  - 1-2-3b locked until Wednesday (needs the body hook);
  - Slip 2-3 Usable, fades 1 a week undrilled;
  - the fighter's own habit "Left hangs", 2 of 3 nights done.
  - The check hook uses the lead hook picture until a check hook is drawn.
- **Mornings.** The ten session icons in a 5x2 grid, each with its one number at Normal.
- **Right column.**
  - The bout box (the opponent named once as the header, 12 days).
  - ON FIGHT NIGHT: 52-56% to win against the coach's 51%. Weight 69.6 of 70.0 with HOLD shown as "off" and CUT on. Tank at
    the first bell 38, fresh. Stamina line 60 met Friday (coach's week: Sunday). Moves ready 6 (4 now). The tape's tell
    "+0 now", WRITE IT, "+1.5 when written". Injury this week 1 in 100, peak 68, red line 72.
  - The coach's handwritten note: "Rest Saturday: seven days out, sparring buys nothing now. Move the lightweight's pads off
    Monday and the hook gets a full night."
  - The clicked Wednesday split card (55/45, body hook 29 -> 32 Usable, check hook 19 -> 23, a full night 26).
  - One button: TAKE THE COACH'S PICK, "rest Sat · pads off Mon · 53-57%".
- **Two limits of the drawing.** The 70/30 share and the club-night allocator are agreed but not built. The numbers in my
  drawing are worked to stay consistent with each other, not run through the code.
