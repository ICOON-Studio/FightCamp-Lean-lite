# Training map v6.1 (TRAINING_MAP_S432.md): blind critic tr6_2_1

Seat: a lead systems designer of player-development and training mechanics in a long-running sports management game. Fresh and blind:
no earlier score or other critic's file read. Read whole: CRITIC_PACK.md, CRITIC_ACCESS.md, TRAINING_MAP_S432.md (744 lines), the
drawing `docs/mockups/s432/training_v2.png`.

## Depth score: 7 / 10
One line: a real training game is designed here, with one priced load choice a week, blocks that build on each other, two
fitness engines that each reach a fight number, and fighters who respond differently. But the measured stakes are small and still
unproven (all twelve probes are pending), two of the four rules are always on, and the bout offer, the biggest outside shock to a
training plan, never shows what it costs the block.

## Code claims checked (read-only, on main at 844fb023)
| Claim | Found | Verdict |
|---|---|---|
| WeekPlan.INTENSITY: gain Light 0.6 / Normal 1.0 / Hard 1.3, load 0.6 / 1.0 / 1.5; SESSION_SHARE 0.2; FATIGUE_KEEP 0.87; 44 a point; 80 overreached; TIRED_GAIN 0.6 | WeekPlan.gd 45-78 | true |
| Today's shares (roadwork and intervals both Stamina only; heavy bag Strength + Explosiveness; rest Recovery) | Attrs.SESSION_ATTRS 280-282 | true |
| F1: rest drains Stamina | Attrs.train ~329: comment "Rest adds Recovery and nothing else (S433 REST1)"; commit 6fa2b52b | STALE: already fixed on main. Section 0 still calls it the code "today" with a test "red on main", and section 3 still lists REST as a DEFECT |
| F2a: one ceiling, old seven only | Recruit.ceiling 57-61: pot + class bias, clamped to now + 2 | true |
| F3: fade a cliff on old conditioning; spend_factor and refill on conditioning | LiveRound 65 (`conditioning < FADE_CONDITIONING`, OWN_FADE 1.0); Combos.spend_factor 262, refill 267 | true |
| F3: FighterGoal writes a trust_delta | FighterGoal 168, 173 | true |
| F4: TrainingLoad SETTINGS and START_HOURS 10 | TrainingLoad.gd 11, 26 | true |
| F5: stale_energy 0 with no camp | BoutRules.stale_energy 165-168 (`protocol < 1` returns 0) | true |
| F9: PROTOCOLS all $0, focus 1.1 / 1.2 / 1.35, edge 0.25 / 0.6 / 1.0 | BoutRules 25-30 | true |
| F9: turn_pro leaves day_job | no `day_job` in Roster.gd; GymSpend 90 reads it | true |
| F10: grade steps Good 1.0 / OK 0.6 / Poor 0.3, Good at 62 | Exchanges 24-26 | true |
| Knowledge called by no script | no `Knowledge.` call outside its own file | true |
| NoGi: DRILL_GAIN 3.2, BODY_CEIL 90, no class kinds | NoGi 19, 26, 200-219 | true |
| Line counts (LiveRound 456, BoutRead 497, WeekPlan 347, NoGi 312, Exchanges 372, Recruit 123) | wc -l | true |
| Style word moves with training | `style` is a fixed field set at signing; nothing in rules recomputes it | not claimed by the map; noted below as a gap |
All other claims checked hold. The one stale row (F1) is a bookkeeping slip, not a design defect. The foundation tasks F2a to F10 are
named with owned files and a red test each, so I count those defects as handled.

## What earns the 7
- ONE decision a week that carries real prices on both sides: Easy, Normal, Hard on an aim, or Sharpen. Each card prints the aim at the
  target, injury in 100 and the Tank at the first bell, all from one run of the week (T24's "every price is the diff of two runs").
  That is the right core for a management game: one input, honest outputs, no hidden dice on the gain.
- The training reaches the ring through named numbers, not a vague "power": Stamina sets each round's cost and the round-3 fade
  (as a slope after F3), Recovery sets the minute's refill and the night's clearance, Footwork and the jab grade Jab and move. Every
  row says the next line it crosses and what the points under it already buy (T17). That closes the loop most sports games leave open.
- A season shape: BASE then SPECIFIC blocks, with a base earning x1.2 on the specific weeks after it, and Strength holding the
  Explosiveness ceiling. The player plans in blocks, not only weeks.
- Fighters differ in how they take training (a hidden slow / normal / quick word per Known group, shown as a range until your own
  sessions reveal it), and age bends the gain. A signing becomes a bet the sessions settle.
- The body talks back from your own load: niggles from hand days, a stand-down after a bout, head contact counted over 8 weeks that
  can lower Durability's ceiling. Each has two priced answers.
- A real camp for the professional that is the load (BUILD BASE, PEAK SPECIFIC, TAPER Sharpen) instead of three free labels, and the
  edge has to be earned by PEAK CAMP's three lines.
- Discipline: a gate table with a pass bar and a named cut for every new rule, before any pixel. Most designs never write this.
- The menu table (section 8) names every menu each mechanic appears on and what it is wired to; the golden path walks it.

## What holds it at 7
1. THE STAKES ARE SMALL AND UNPROVEN. By the map's own hand sums, Hard on the best row against Normal is +2 whole points by the
   target; the base's x1.2 is +0.3 Footwork; Hard on Stamina is +1 and the energy part of the two engines is "small". The pack says
   5 points of stats is about 72 wins in 100, so 2 points on one row is a modest edge. Every probe that would prove a choice matters
   (PACE1, DOSE1, BLOCKORDER1, SEASON1 and eight more) reads "pending". Depth on paper is not depth yet.
2. TWO OF THE FOUR MORNING RULES ARE NOT CHOICES. The map's own "right when" column says "rules 1-3 on". A toggle with one right
   answer is a setting, not a decision. Rule 4 (mood Low runs Easy) almost never fires on a Steady fighter.
3. A STACK OF PASSIVE MULTIPLIERS. Hard 1.6 x dose 1.3 x base 1.2 x response 1.2 x age 1.1 is 3.3 times a plain morning (the map
   says so in Risks). Age changes nothing the player decides after signing; the dose x1.3 is folded into Hard's lay. Each extra
   multiplier makes the forecast harder to read without adding a choice.
4. THE OFFER IS NOT PRICED IN TRAINING. Accepting a bout two to four weeks out turns a SPECIFIC block into a fight week and costs
   points, the goal's band and the base's x1.2. That is the most common shock to a plan in this game, and section 8 has no row for
   Fights > the offer card. The cross-system choice is there in the rules but never shown where it is made.
5. TRAINING DOES NOT SHAPE WHO THE FIGHTER BECOMES. The style word is fixed at signing in the code; the build direction (C22) is a
   x1.10 tilt. A season of Inside work should be able to turn an out-boxer into a boxer-puncher, with what that changes in the ring.
   Long-horizon player development in the best sports games is "who this person becomes", not only "how many points".
6. THE PLAYER'S BEST MOVE IS PRINTED FOR THEM. The default aim is the argmax of worth x test x room x response, and WHERE HARD PAYS
   MOST lists it in order. Good for clarity, but it leaves the real trade (the goal's mood against the opponent's test against the
   injury in 100) as the only judgement. The squad trade (pad places, Lucy going short) lives on Club week, which this map leans on.
7. NOT YET DRAWN: Lucy's camp (8b), Ana's mat week (8c) and the week-1 quiet state are text only. Ana's four class kinds are all new
   code with no picture. The operator's bar is "shown on the correct menus"; two of the four fighters have no screen yet.
8. STALE: F1 REST1 is already on main (commit 6fa2b52b). Section 0's "red on main" and section 3's "REST (DEFECT)" should say merged.

## To reach 10/10 (most important first)
1. FILL THE GATE TABLE BEFORE ANY MORE DESIGN. Run PACE1, DOSE1, BLOCKORDER1 and SEASON1 on the fixed engine (F1 to F10 merged) and
   write each result into section 10. Cut every row that fails its bar in the same commit. A careful player against "Coach runs it"
   must show 4+ wins in 100 or a target 4+ weeks sooner, or the tab shrinks to the load, the chart and the abilities.
2. PRICE THE CHOICES IN EXCHANGES, NOT POINTS. Land LEVERS1 so every load card prints its worth in exchanges a bout ("Hard on
   Footwork: +1.4 exchanges at the regional"). Target: Hard on the best FAST row crosses one fight line per 4-week block. If 2
   points cannot reach that, raise the named shares (PACE1's fallback) rather than add a multiplier.
3. PUT THE TRAINING COST ON THE BOUT OFFER. On Fights > the offer card and its full report, add one line from the one run: "Accept:
   9 Mar SPECIFIC becomes a fight week; Footwork at the regional 60 to 59; goal close to short (mood -5)". Add Fights > offer to
   section 8's menu table and to the golden path.
4. MAKE EVERY MORNING RULE A REAL CHOICE OR REMOVE ITS TOGGLE. On the rules line, print what each rule cost and saved over the last 4
   weeks ("fired 2x: Footwork -0.2, injury -1 in 100"). Keep a toggle only where MORNRULES1 finds OFF is right in at least 1 week in
   5 (for example rule 1 OFF in a SPECIFIC block when the peak sits under 76). Rules that are always right become Coach's defaults
   with no switch.
5. LET TRAINING CHANGE THE STYLE WORD. Recompute the style word from the abilities at each Monday review (the style already reads
   Exchanges.STYLE_MODES); show on the strip and the header "Becoming: Boxer-puncher at Inside 60", with a hover saying what the new
   style changes in the ring (its mode weights). Tie the perk road in the same panel ("Fast hands at Speed 70, 1 point").
6. CUT THE PASSIVE STACK FROM THE TAB. Keep Hard's 1.6, the response (it changes the aim) and the base's x1.2 only if BLOCKORDER1
   passes. Fold the dose x1.3 into Hard's number. Show age only on Find a fighter and the trial card, where it is a decision.
7. ADD "YOU AGAINST COACH" AS A SEASON LEDGER. One panel and one Monday-review line: exchanges a bout your weeks earned against
   Coach's weeks, weeks gained on the target, injuries taken in each. This makes mastery visible and is the proof SEASON1 measures.
8. DRAW THE OTHER THREE STATES before the Cursor brief: the week-1 tab, Lucy's 6-week camp (8b) and Ana's mat week with the four class
   kinds feeding mat-plan lines (8c). Each at 1920x1080, text 20 px or more, every cell checked for clipping.
9. KEEP THE WEEKLY TOUCH SHORT. With four fighters, a quiet week must be set in under 30 seconds from Club week (load and aim per
   row); the Training tab is for a change, never required every Monday. Say so in section 4 and test it in the golden path.
10. FIX THE STALE ROWS: F1 REST1 merged on main (6fa2b52b); STANDDOWN1 in flight. Update section 0, section 3 and section 10's first
   row so the map matches the code.

## Complete?
No, not for building. As a depth design it clears 7 for me: the load, blocks, engines, response and the body's answers are linked and
reach the ring. It is not complete because every probe in the gate table is pending, the professional's camp and Ana's mat week are
not drawn, the bout offer's cost to the plan has no menu, and one foundation row is stale.

## My 10/10 drawing
`docs/mockups/s433/critics/tr6_2_1_10.html`, rendered to `docs/mockups/s433/critics/tr6_2_1_10.png` (1920x1080, text 20 px or more).
It shows: the four loads priced in exchanges a bout; the bout offer's cost to the season strip at the top; the morning rules with what
each cost and saved over 4 weeks; the 13 days to the bell with the rule's dot and both Tanks; abilities sorted by what the opponent
tests with each next line; "You against Coach" this season; and "Who Samira becomes" (the style change and the next perk).
