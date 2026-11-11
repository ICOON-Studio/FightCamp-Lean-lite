# Training map v5: a blind review (tr5, a lead designer of training and development in a long-running sports management series)

Read whole: CRITIC_PACK.md, CRITIC_ACCESS.md, TRAINING_MAP_S432.md (695 lines), the drawing training_v2.png. Read in the code:
Attrs.gd (train, apply_session, SESSION_ATTRS, LEGACY, VALUE), WeekPlan.gd (SESSIONS, INTENSITY, EVENINGS, COACH_WEEK, day, hours),
Recruit.ceiling, Injuries.week_hours / ratio, InjuryRoll (TRAIN_BASE_10H, training_chance, KO_DAYS), TrainingLoad (SETTINGS,
START_HOURS), BoutRules (PROTOCOLS, stale_energy, FADE_CONDITIONING, NIGHT_LINES, play_round), LiveRound 65, BoutRead 325,
FighterGoal.STAT_KEYS, MoveMastery.cap, WeekPhase.WEEKS, Sim.gd 120 / 210-213. No other critic's file was opened.

## Score: depth 7 / 10

One line: a real training game with real trade-offs (load against injury, tiredness and the season; dose against fade; the opponent
against the season), and its code claims are true. It stops at 7 because the professional's camp is still a second, free "Hard"
button beside the new load. Every reward is also a step at a line, and nothing in it grows a fighter's identity or ceiling over a
career.

## The code claims, checked (all hold)
| Map claim | What the code does | Verdict |
|---|---|---|
| F1 rest drains Stamina | Attrs.train: when the session has no old stat and names recovery, `out["stamina"] = -out["recovery"]` ("The same points come off stamina"). WeekPlan.day gives rest an `attr_gain` on conditioning's headroom; Sim 213 hands it in | TRUE. Every taper rest day turns Stamina into Recovery |
| F2a one ceiling | Recruit.ceiling: pot +6 on the class strength, -6 on its gap, never under now + 2, old stats only; WeekPlan passes one `pot` | TRUE |
| F2b gain on the old stat | WeekPlan.day: preview_gain on `s["stat"]` (power, technique...) against `pot`, then Attrs.train splits it among LEGACY children | TRUE |
| F3 Cardio is a mean | LiveRound 65, BoutRules 208, BoutRead 325 all read `stats.conditioning` against FADE_CONDITIONING 64; FighterGoal.STAT_KEYS are the old seven | TRUE |
| F4 hours ignore effort | WeekPlan.hours = minutes x the pace's load, evenings at face value; InjuryRoll.training_chance = 1.3% x hours / 10; TrainingLoad.START_HOURS 10 | TRUE |
| F5 no Legs without a camp | BoutRules.stale_energy returns 0 when `protocol < 1` | TRUE |
| F6 no stand-down | only InjuryRoll.ko_days after a stoppage | TRUE |
| Coach's base week 2,607 effort-minutes, 7.97 h | COACH_WEEK + 3 pad nights + 1 sparring, worked from SESSIONS and EVENINGS: 1,272 + 1,335 = 2,607; 478 minutes | TRUE |
| T1 Normal week: 1,959 = work 75, 6 h 15 | rebuilt cell by cell: 120 + 150 + 360 + 225 + 72 + 72 + 375 + 375 + 210 = 1,959; 375 minutes | TRUE |
| Move ceiling 40 + 0.4 Technique + 0.2 Fight IQ | MoveMastery.cap | TRUE |
The foundations F1 to F6 are named as tasks with owned files and red tests, so they count as handled.

## What makes it deep (why it reaches 7)
1. ONE LOAD WITH TWO HORIZONS. Easy, Normal, Hard and Sharpen each print this week and the block to the next target. The block is
   what matters: a Hard block buys "Cardio 64, no round-3 fade" at the regional, and one week cannot buy it. That is the right
   decision unit: the series I worked on learned that weekly sliders are noise, and a block with a payoff date is a plan.
2. THE PRICE IS IN THE OTHER PANEL'S TERMS (T24, one run). Rest the hand = the habit stays HALF FIXED, -2 to -4 in 100 against this
   opponent. Most sports management games show a cost in a meter. This one shows it as what it does to Saturday.
3. FADE BY DOSE, KEPT-BY COLUMN. Sessions now have two jobs, building and keeping, so a seven-slot morning plan has an opportunity cost.
   Real, and rarely modelled.
4. THE OPPONENT SORTS THE BOARD. The worth of a point (Attrs.VALUE) times what this opponent tests turns "train your weakest stat"
   into "train what Saturday asks". That is the core of a sports-management training screen.
5. THE BODY HAS A VOICE: niggles from your own load, the stand-down after contact, the fighter's ask on the Hard button, injury
   chance with tiredness and spikes. The gym feels like people, not a spreadsheet.
6. HONESTY: every size waits for a probe; TRAINSEASON1 is a real gate (4+ in 100 or the season target 4 weeks sooner, else the map is
   cut back). A cut rule for small choices. Few design documents in the genre bind themselves like this.

## What holds it at 7
1. THE PROFESSIONAL HAS TWO "HARD" BUTTONS (a design hole, not in the map's foundations). BoutRules.PROTOCOLS: camp Light, Standard
   and Hard cost $0, and Hard gives focus x1.35, a fight-night edge +1.0 and 5 nights. Its `level` mirrors into the load setting.
   Map 8b keeps "the camp's intensity (CODE) on the camp card" beside Easy / Normal / Hard / Sharpen. So for Lucy's camp weeks there
   are two controls for the same weeks, and one of them is free with a flat edge. A free Hard camp with +1.0 is the dominant pick, and
   it bypasses the injury and tiredness prices the whole map builds. The camp must BECOME the load blocks (Build Hard, Peak Hard,
   Taper as Sharpen), with the edge earned from the block's real numbers (PEAK CAMP's three lines), not paid out by a label.
2. REWARDS ARE STEPS AT LINES. Almost every payoff is a threshold: Cardio 64 or a fade (OWN_FADE 1.0), Good at 62, a perk at 70.
   Cardio 63.9 is worth nothing on the night; 64.0 is worth the whole fade. Lines read well, but a block that ends at 63.8 feels
   cheated, and LINES1 has not yet priced a single crossing. The worth dots (Attrs.VALUE) carry the smooth part, but the tab never
   says that a point below a line still buys something.
3. NO CAREER ARC. Ceilings are fixed for life (F2a shapes them once). Nothing in the map raises a ceiling, nothing reshapes a style,
   and age and decline are left for later. A management series lives on "the unknown who became more than the scout said", and that
   is the game's own pitch ("raising an unknown into a champion"). Today the only ceiling change is "Raise the ceiling +5" at signing.
   A training system with a fixed ceiling becomes a solved fill-the-bar job by the second season.
4. NO DEVELOPMENT AIM. Training chases the next opponent and the season target. A player cannot say "make this out-boxer a
   ring-cutting pressure fighter by next year". The style word does not move with training anywhere in the map. Long-term identity
   building is the deepest layer in the genre's best training screens, and it is missing here.
5. ANA IS THIN. Three class kinds, a stripe date and open prep at +1 a class. Beside the boxers' fourteen abilities, horizons, doses and
   sorting, the fourth fighter's training is a single choice. The scope (four fighters, one in BJJ) puts Ana a quarter into the week.
6. ONE ROW, ONE NUMBER IS BENT. Defence prints "62 Hands up", which reads 0.65 Defence + 0.35 Flexibility. Timing's "Draw the lead"
   reads Timing and Fight IQ, Speed's "Let your hands go" reads Cardio and Speed, and Inside's "Tie up" reads Inside and Heart. The map
   works each line's threshold out at today's other number (64 for Samira at Fight IQ 60), but that line moves when the other row
   moves. The tab must say which other row it leans on.
7. DRAWING READS. Hard prints "Defence 52 Mon" and Normal "Defence 52 Thu". On a Monday, "Mon" reads as today and makes Hard look
   slower than Normal. Most cells are 18 px on a dense tab: the reveal order helps, but at full reveal it is about 120 numbers.

## To reach 10/10 (most important first, each buildable)
1. MERGE THE PROFESSIONAL'S CAMP INTO THE LOAD. Retire PROTOCOLS' Light / Standard / Hard as a separate pick: a camp is the strip's
   BUILD / PEAK / TAPER blocks, each with a load (default Build Hard, Peak Hard, Taper Sharpen). The fight-night edge is paid only by
   PEAK CAMP's three met lines and the block's real Legs. Keep the outside partner and the film on the camp card. Test: CAMPLOAD1, a
   free camp label no longer changes a bout; two camps with the same weeks give the same edge.
2. SMOOTH EACH LINE. Keep the line as the headline, but give each point under it a share: a fade of OWN_FADE x (64 - Stamina) / 4,
   held 0 to 1, in place of all or nothing; the call edge from x0.6 to x1.0 across 56 to 62 in place of one step. Print "63.8: 95% of
   the fade gone". Then a block that falls just short still buys something visible. LINES1 measures both.
3. CEILINGS THAT MOVE. Add a small, earned ceiling change: +1 to +3 on a group after a "breakthrough" (a step-up win, a camp with
   PEAK CAMP met, a season of the right dose under a coach rated 70+ in that area), -1 to -3 after a stoppage loss or age 31+. The
   ceiling always shows as a range until Known, so a rise reads as a scout's surprise. One rule module (CeilingShift.gd) and one line
   on the Week review: "Footwork ceiling 72 -> 74: the Kayleigh camp".
4. A DEVELOPMENT AIM PER FIGHTER. Pick one of the style words (Out-boxer, Pressure fighter, Counter-puncher...) as a 6-to-12-month aim.
   The aim names three abilities and three lines; Coach's week leans a third toward it when no bout is booked. When all three lines are
   met, the style word changes and the fight's mode weights (Exchanges.STYLE_MODES) follow it. Shown as "Aim: Ring-cutter, 2 of 3" on
   the header, the Profile, and the Week review.
5. GIVE ANA THE SAME FRAME. Ana's six abilities with doses and ceilings; class kinds priced in the same one run; two horizons to the
   next open (positional rounds to own a sweep vs hard rolls for the open); a mat niggle. Same panels, mat words.
6. NAME THE SECOND NUMBER ON A SHARED LINE. "62 Hands up (with Flexibility 55)", and the line's day recomputed when the other row
   moves. Or move the line to the row it mostly reads and print only a word on the other.
7. DATES THAT CANNOT BE MISREAD. A same-day date says "today"; any date in the next 7 days names the weekday and the date ("Mon 23").
   On a load card, the ability date goes in a column so Easy, Normal and Hard compare at a glance.
8. GRAPHICS, NOT COLUMNS. Draw each ability as a track: now, by the bout, by the target under the chosen load (a ghost), the lines as
   ticks and the ceiling as a hatched wall (see the drawing). It replaces four text columns with one picture and lets text be 20 px.
9. A PATTERN LINE THAT IS A CHOICE. Monotony x1.5 is fine; also show it on the load card so a player sees VARIED / ALL ALIKE before
   picking, not only on the week grid.
10. RUN TRAINSEASON1 BEFORE ANY PIXEL. If a careful player does not beat "Coach runs it" by 4 in 100 over a season, every panel above is
    decoration. The map says so; hold it to that.

## Complete?
No. The depth reaches 7 and the wiring table names every menu each mechanic shows on. But two things are still open. First, the
professional's camp intensity is a second, free control for the same weeks as the new load, and the map keeps both (8b). Second,
Lucy's camp and Ana's mat are specified as a table (8b) but not drawn, and Ana's training is one choice deep. Fix point 1 of the list
and draw 8b, and the map is ready for the board.

## My 10/10 drawing
`docs/mockups/s432/critics/tr5_series_10.png` (from `tr5_series_10.html`): the load cards print this week and the block on two bars
each. The abilities are tracks with line ticks, a ghost to the target and the ceiling wall. A development AIM sits on the header. The
13-day chart has the Hard ghost. Weight shows the scale's hour. All text is 20 px or larger.
