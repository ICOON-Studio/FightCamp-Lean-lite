# Training map v4 (TRAINING_MAP_S432.md): a blind review by a sports management game reviewer

Reviewer: a reviewer of sports management games, hundreds of hours on Football Manager's training and development screens and
Out of the Park Baseball's player development. No earlier score or review was read. Read in full: CRITIC_PACK.md, CRITIC_ACCESS.md,
TRAINING_MAP_S432.md (585 lines), the drawing `training_v2.png`, CLUBWEEK_MAP_V41_S432.md (sections 1 to 5), and the code: WeekPlan.gd,
TrainingLoad.gd, PadWeek.gd, MoveMastery.gd, HabitFix.gd, BoutRules.gd, plus the files they lean on (Attrs.gd, Injuries.gd, Sim.gd
week_ctx and step_day, Recruit.ceiling, TrainingPreview.gd, Exchanges.gd, PerkRoad.gd, FighterGoal.gd, LiveRound.gd).

## DEPTH SCORE: 6.5 / 10

One line: the best-argued training design I have seen in a small sim, honest about what is built and what is a guess, but its
headline weekly choice barely moves anything you can see, and four of its code claims fail at the foundation it builds on.

## What is good (keep all of it)
- ONE RUN, EVERY PRICE (T24). Every option priced in the other panels' own terms from one simulated week, with a unit test that two
  runs diffed equal the printed price. That is the thing Football Manager never did well: FM tells you a rating moved, never what a
  choice bought. This rule alone makes the screen trustworthy.
- THE OPPONENT SORTS THE BOARD (T18). Worth of a point (Attrs.VALUE, measured) times what this opponent tests, shown as dots plus a
  multiplier column. This is a better "what to train" answer than FM's role-ability stars, because it is about the next night.
- ROOM TO GROW + NEXT LINE WITH ITS DAY (T16, T17). Whole points with dates, a ring consequence named for each line, and the after-the-bout
  tag with the price of bringing it forward (T2). This is how decimals become decisions. OOTP's development screen has nothing like it.
- FADE BY DOSE (T15) and the KEEPS column that reads the plan. Keeping a fighter sharp now costs sessions: a real trade, with real
  sources (Issurin, Bickel, Spiering) and a cap so fade never feels like punishment.
- HONEST TAGS (CODE / WEEK / NEW / ESTIMATE), a cut rule (under 1.5 in 100 and no season effect is cut), and the TRAINSEASON1 gate
  (careful player beats "Coach runs it" by 4+ in 100 or the map is cut back). Few designers write their own kill switch.
- The person in the week: the goal on the header (T25), the fighter's ask on the button it is about (T26), coachability on habit steps
  (T7), the coach's grade on each cell (T27). FM's "player complains about training" without the menus.

## Code claims checked (what holds, what does not)
HOLDS (read in the code):
- Injuries.week_hours = WeekPlan.hours(days_of, PadWeek.evenings(f, false), camp load, pad_share): correct. TrainingLoad.SETTINGS (3/6/10/15 h)
  and START_HOURS 10 still feed camp_default, a new fighter's usual (fresh_chronic) and the rest week (Injuries.end_week line 199): correct.
- BoutRules.stale_energy returns 0 when camp.protocol < 1: correct, no amateur bout without a camp pays for tiredness today.
- WeekPhase taper cuts intensity (Light) rather than volume: as described.
- Sim.week_ctx passes one `"pot": int(f["pot"])`; Recruit.ceiling is read only by RecruitPanel: correct, a real defect.
- fatigue_keep 0.87 - (recovery - 55) x 0.003, clamped 0.70 to 0.95; Recovery 50 keeps 0.885 (clears 11.5%, "12%" rounded): correct.
- Perk needs on the abilities (Explosiveness 70 Finisher, Accuracy 65 Stiff jab, Stamina 70 Second wind, Speed 70 Fast hands): correct.
- Call needs ("Draw the lead" = ring_iq + timing; "Let your hands go" = engine + hand_speed; Hands up = guard + head_movement, 0.65/0.35):
  correct. Counter-puncher weights 55/25/10/10: correct. MoveMastery decay -0.75 a week, Usable kept: correct. HABIT_COST 6: correct.

DOES NOT HOLD, OR IS MISSING (each changes what the screen would print):
1. REST DRAINS CARDIO IN THE CODE. Attrs.train: a rest (or rest-only) morning adds its gain to Recovery AND takes the same points off
   Stamina ("The same points come off stamina", Attrs.gd 329-332). Easy and Sharpen add rest mornings, so they silently cost Cardio,
   the very ability the drawn goal is on. T3 prints Rest as "Recovery + Flexibility · Fresh legs"; T15 counts Cardio as kept by a
   roadwork in 14 days. Neither is true while this line stands. Fix the code or price it.
2. "CARDIO 64: NO FADE FROM ROUND 3" IS NOT CARDIO. LiveRound 65 reads stats.conditioning, which Attrs.LEGACY makes the MEAN of Stamina and
   Recovery. A fighter with Stamina 64 and Recovery 50 (Samira's own Recovery) is at 57 and still fades. FighterGoal targets
   "conditioning" too (STAT_KEYS are the old seven), so the drawn goal "Cardio 64" is the same mean. The map calls Cardio "the stamina
   group" and prints Recovery as its own thing (T29): two words for one number, or one word for two. One word per concept is broken.
3. FOOTWORK, INSIDE AND FLEXIBILITY HAVE NO PARENT. T16 says "abilities read their parent stat's ceiling (Attrs.LEGACY)". LEGACY has no
   entry for footwork, inside or flexibility. Footwork is the top row of the drawing. And gains are computed on the LEGACY stat's
   headroom (preview_gain on "technique" for shadow), then spread: per-ability headroom needs per-ability gain, a bigger change than
   "pass ceil[stat]" in week_ctx.
4. THE DRAWN DATES ARE FASTER THAN THE GAIN RULE. A session gives 0.2 x intensity x coach factor (0.5 + 0.7 x rating%) x headroom. Footwork
   gets only OUTSIDE_SHARE 0.5 of a shadow session's technique gain: about 0.04 a session at Samira's numbers. "Footwork 62 · 30 Mar" (+5 in
   six weeks) needs every morning on Footwork at Hard and still falls short (about 0.6 a week). The map says the numbers were worked by
   hand; the one run (T24) will print later dates, many "not before Sat 28 at any load" and many "not this season". The feature that makes
   the board readable may read mostly as "never". A pace probe must come before pixels.
5. LEGS HALVES THE PROFESSIONAL'S TIREDNESS COST. stale_energy is 2 energy a point over 50 (at most 20); CLUBWEEK's Legs is 1 a point (at
   most 25 with weight and the last bout). "This map adds nothing to the bout" is not quite so: the professional's camp gets cheaper.
   Say it and measure it.
6. CEILINGS BARELY DIFFER. Recruit.ceiling is pot + 6 on one stat, pot - 6 on one, pot for the rest. So 12 of 14 abilities share one ceiling
   (68 in the drawing), and "room to grow" is mostly "how low it is now". FM's hidden potential is per attribute through the player's
   profile; OOTP has a potential per rating. Without a shaped ceiling per ability the FAST / SLOW / NEAR CAP word adds little.
7. THE MOVE CAP IS A HIDDEN LINK. MoveMastery.cap = 40 + 0.4 x Technique + 0.2 x Fight IQ: a fighter at Technique 58 tops out about 74 and
   can never reach Signature 85. The Accuracy and Timing rows should say "raises every move's top: Signature needs 83". The map never
   mentions it, yet it is the biggest reason to train a skill row.
8. Small: pad nights are 75 minutes for load and 240 game minutes for mastery (PAD_NIGHT_MINUTES); "habit:" tray cards are not drilled
   by PadWeek today (all of T5 is NEW, the map tags it so); the FAST line at "10+ points" vs headroom 0.4 is right, but NEAR CAP "under 4"
   is not the 0.10 floor (that starts at 2.5 points).

## Depth: why 6.5 and not 7
Depth in a training screen is: do the choices differ in ways the player can feel, now and over a season, and do they trade against
each other. The map has the trades. It does not yet have the size.
- THE HEADLINE CHOICE IS FLAT. The four loads for Samira read: Legs 100 / 99 / 94 / 100, injury under 1 / 1 / 4 / under 1, first whole
  point Thu / Wed / Tue / Fri. A weekly decision whose options move one ability's point by one day and Legs by six points (worth an
  unmeasured amount) is priced, not deep. The real reward of Hard (more points over a block, more safe hours) is a season effect, and
  the button only shows this week. FM's training intensity matters because a month of it shows in the attribute arrows; here the button
  never shows the month.
- MOST OF THE DEPTH IS ESTIMATE. Doses, Sharpen, the pattern, partner level, OppTests multipliers, habit steps, own tape, bouts teach: all
  guesses awaiting probes. That is honest and well ordered, but a 7 needs the foundations real, and two of them (Cardio's line, rest
  draining Stamina) are wrong in the very numbers the drawing prints.
- NO MID-WEEK DECISION. Every decision is B (Monday) or A (after). The clock runs day by day; nothing in the week can surprise you. A
  niggle that flares on Thursday after the sparring night, a session that went well ("it clicked: +1 pad place of value"), a fighter who
  skipped: FM's mid-week match reports and OOTP's in-season injuries are what make the schedule feel alive.
- NO TREND. The board shows now, the ceiling and the next line, never the last four weeks. A development game lives on the arrow.
- PERSONALITY TOUCHES TRAINING ONLY AT EDGES (coachability steps, discipline skips). Professionalism / work rate (FM's biggest development
  driver) is the discipline trait already in the data; it should scale every session, not only cause skips.
- Scope is wide for one tab: 23 numbered mechanics, a 150-number drawing. The reveal order (risks section) is the right answer; it must be a
  rule of the build, not a note.

## To reach 10/10 (most important first, each buildable)
1. FIX THE TWO WRONG FOUNDATIONS BEFORE ANYTHING IS DRAWN AGAIN. (a) Rest stops taking Stamina: Attrs.train keeps conditioning moving with
   Recovery (or the legacy stat is dropped for these two), unit test REST1: an Easy week never lowers Stamina. (b) One word, one number:
   either the round-3 fade and the goal read Stamina (LiveRound and FighterGoal move to the abilities) or the row is named "Condition
   (Stamina + Recovery)" with both parts shown. Test FADE1: a fighter at Stamina 64, Recovery 50 does what the screen says.
2. A PACE PROBE BEFORE PIXELS (PACE1). Run the one run (T24) on all four fighters for 12 weeks at Coach's week and at a focused week; the next
   line must land inside the season for at least 3 of the 8 top rows at a focused load. If not, raise per-session gains for the named
   ability (Footwork drills at full, not OUTSIDE_SHARE 0.5) until it does. Redraw every date from the run.
3. TWO HORIZONS ON EVERY LOAD BUTTON. Each load prints the next bout (Legs, injury, the goal) AND the season target ("by Sat 11 Apr final:
   +4.6 points, safe 10.6 h, Footwork 62 lands 9 Apr"), from the run carried forward with Coach's weeks after. This makes Hard worth
   something you can read and makes the choice deep rather than priced.
4. PER-ABILITY CEILINGS WITH A SHAPE. Build `ceil` for all 14 abilities (Footwork, Inside, Flexibility included) from the fighter's
   archetype tilt (AttrGen.tilt_of) plus the class bias, spread about +/-8 around pot; compute gain per ability on its own headroom. CEILING1
   must cover a non-LEGACY ability.
5. A TREND COLUMN AND A COACH'S REPORT. Each ability row shows its last 4 weeks (up, level, down with the number) from season_src; one
   panel gives Coach's report in three plain sentences (ahead / behind / near the top) whose accuracy follows the coach's area rating:
   a weak conditioning coach misjudges the Cardio line by a point (shown as a range). That makes the coach's grade matter on the board,
   not only on cells.
6. ONE MID-WEEK STOP. After the sparring night the clock stops once if something happened: a niggle flares (rest Friday or push), a
   session clicked (a pad card past a tier early: move a place onto the next card), or a skipped morning (talk or let it go). Each priced
   by the one run. Max one a week, none in quiet weeks.
7. SHOW THE MOVE CAP ON THE SKILL ROWS. Accuracy and Timing rows print "every move's top: 74 now; Signature needs 83" (MoveMastery.cap).
   The pad card at its top says "capped by Technique: train Accuracy or Timing".
8. DISCIPLINE SCALES EVERY SESSION. Discipline (data, today only a skip line) multiplies session gain 0.85 to 1.15; shown in the header
   beside Recovery ("Discipline 80: trains at 1.1"). Coachability keeps the habit steps.
9. MENTORING ON THE PAIR PICKER. The professional sparring an amateur teaches Composure +0.1 a session and lifts the amateur's Timing x1.2
   (T4's partner level), at the cost of the professional's own pad place (Club week). Shown on both fighters' boards.
10. SAY THE LEGS CHANGE FOR THE PROFESSIONAL and measure it in FITLEGS1 (stale 2 a point vs Legs 1 a point); if the professional's camp gets
    cheaper by more than 1 in 100, keep 2 a point for the professional or say why not.
11. GOALS ON ABILITIES. FighterGoal's STAT_KEYS move to the 14 abilities so a goal can be "Footwork 60", which the opponent sort can pin.
12. MAKE THE REVEAL ORDER A BUILD RULE: week 1 shows the load, the strip and room to grow only; each later panel arrives with its first
    event, with a golden-path step per reveal. Keep "Show all 14" folded until week 3.

## Complete for this version?
YES, with the list applied. Four fighters, amateur to a first professional fight: the amateur fight week (Sharpen, Legs on every bout,
the weigh-in hour), the professional's camp (8b, Cardio line, PEAK CAMP), Ana's class kinds and the season strip with the nationals all
have a place. Two things must still land: the 8b frames for the professional and Ana drawn and probed (Ana's mat is thin: class kinds
and a dose only), and items 1 and 2 above, without which the screen would print numbers the game does not do.

## My 10/10 drawing
`docs/mockups/s432/critics/tr4_reviewer_10.html` and its render `tr4_reviewer_10.png`: the Training tab for Samira with two horizons on
each load, the trend column, shaped ceilings, the honest Condition row, the move cap on the skill rows, Coach's report and the
mid-week stop.
