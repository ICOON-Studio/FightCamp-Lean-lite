# Training depth: a club head coach's review (S432, blind critic)

Seat: head coach of an English amateur club with national champions; plans a squad's weeks around bouts, sparring and day jobs.
Read: CRITIC_PACK.md, CRITIC_ACCESS.md, the rule modules (WeekPlan, WeekPhase, TrainingPreview, TrainingPlan, TrainingLoad, PadWeek,
PadEdit, PadReview, MoveMastery, HabitFix, CoachAreas, PerkRoad, Recruit, FighterGoal, WeekTwist, WeekCoach, WeekActual, WeekCause,
WeekRead, PeakCamp, SparNights, SkillAwards, InjuryRoll, Knowledge, BjjSide), the screens (WeekBoard, WeekTired, WeekEditors, WeekTiles),
the real Training tab (`docs/mockups/s432/trainingb2_23e_real.png`), the club week map v4.1, the RPG layer map v3 and the R55 pads map.
No other critic's file was opened.

## Score
**Depth 5 / 10 as built. 6.5 / 10 if the club week map v4.1 and the RPG layer are built as written.**
One line: the engine under the week is a real coach's engine (phases, load, fatigue, weight, injury), but the player plans one fighter at
a time, with nothing scarce to share between the four, and each edit is worth about a tenth of a point.

## What really happens in a week (traced in the code)
- The coach writes the week from the phase (BASE, BUILD 3+ weeks out, PEAK 2 weeks out, TAPER fight week; WeekPhase). The player
  changes exceptions: a morning session (roadwork, intervals, heavy bag, strength, speed bag, slip rope, shadow, neck, mobility, rest)
  at Light / Normal / Hard, an evening (pads, sparring, film, rest), the drill cards on pad nights, and the diet (Hold / Cut 500 kcal)
  when a bout is booked.
- A morning is a fifth of a focused week: about +0.08 / +0.13 / +0.17 of one stat (the real screen shows exactly that). A focused
  week moves the main stat about 1 point with a coach; 5 points of stat wins about 72 in 100. So the CHOICE OF STAT over a camp is
  worth a lot; a single edit is worth almost nothing, and the screen shows it in decimals.
- Tiredness: each night keeps 87% (better with Recovery); 80 is overreached (gains x0.6, injury x3). Load against the boxer's usual
  (a 42-day average) at 1.5 doubles to quadruples training injury. Real research, done properly.
- Pads: a pad night drills up to two cards (50/50, 70/30, 30/70); mastery climbs to Usable 30 (a weapon), Sharp 60, Signature 85,
  capped by Technique and Fight IQ; undrilled moves fade 0.75 a week but never below Usable.
- Every boxer gets the hired coach's full rating on every pad night, however many boxers there are (R55 found this; still true).
- Peak camp: weight made, the camp stat on target, never overreached = +1 to every stat on the night. Perks open at stat lines.
  Twist card once a week with two priced answers. Monday review: planned against actual, the sessions behind each gain, the
  next whole point's date.
- Habits: trained out only once, at signing (Recruit "Fix the habit", 4 weeks). In the week there is no way to work on one; the
  corner minute patches it for a round.
- Ana (no-gi): 3 classes a week that drill the move nearest to owned; the stripe call. Almost no weekly choice.

## What is good
1. The sport science is honest and sourced: Banister-style fatigue, acute against usual load (Gabbett), kcal from MET values, a 500 kcal
   cut at about 0.5 kg a week, taper volume down and sparring stopped in fight week. A real coach would recognise every number.
2. Periodisation is built in, not bolted on: the camp writes itself backward from fight night and the player only edits. That is how a
   club coach actually works ("same as last week, except...").
3. Cause and effect after the week is well done: "+1 Technique: pads Tue + Thu", planned against actual with one reason, the date of the
   next whole point, the weekly tiredness curve with the 80 line named.
4. Peak camp is a lovely three-line target (weight, the stat, never overreached) and is exactly what a good camp is.
5. The move ladder (New, Learning, Usable, Sharp, Signature) with a ceiling set by Technique and Fight IQ ties the evening to the fight
   plan: a plan line the boxer cannot throw does not work.
6. Skills awards (graded tests on the pads and a bleep test) exist and give a boxer who is not fighting something to train toward;
   graded moves cost less gas. That is real club life.
7. "Train X next week" from the body report after a bout links the fight back to the week.

## What is missing (options a coach expects and the player cannot reach)
1. A SQUAD VIEW. Four fighters are planned on four separate tabs. Nothing is shared or short: my time on the pads, my coached mornings,
   the ring, sparring partners. In a real club that scarcity IS the job. (The club week map v4.1 answers this; it is not built.)
2. SPARRING PARTNER AND SETTING for amateurs: who spars whom (weight, stance, style) and how hard (hard, technical, body only,
   situational: "start on the ropes", "southpaw rounds"). Only a pro camp's partner can be picked today. (The map adds pair and setting.)
3. HABIT WORK IN THE WEEK: a habit card on my pad places over several weeks, half-fixed states, and the habit coming back when the boxer
   is tired or flat. Today a habit is fixed once at signing or patched for one round in the corner.
4. A SEASON PLAN THE PLAYER CAN SHAPE: the phases exist but only as the coach's four words. No strip of the next 12 weeks per fighter,
   no deload week every fourth week, no "extend the base" or "rest two weeks after that war". (Map: season target and Rest after a bout.)
5. LIFE AROUND THE GYM: jobs, shifts, exams, the boxer who skips when nobody is watching. (Map: job rota, mood rate alone.)
6. WEIGHT AS A SEASON LINE: walking weight against the class, a gentle option between Hold and Cut, and the amateur's walking-weight gap
   (the map's 1.0 kg gap). Today the diet only appears once a bout is booked.
7. THE SIZE OF A CHOICE IN FIGHT TERMS: the Training tab shows +0.13; it never says "by fight night: Defence 58 to 61, about +3 in 100".
8. ANA'S WEEK: drilling against positional sparring against hard rolling, and prep for an open.
9. A FOCUS FOR THE MONTH per fighter (Football Manager's individual focus): one pick that tilts the coach's week, instead of 14 small
   edits.

## Useless or weak options on the screen today
1. Light / Normal / Hard on every one of 7 mornings for each of 4 fighters: 28 near-identical picks a week, each worth hundredths.
   Set intensity per WEEK (with exceptions) instead.
2. Pairs that do the same thing with no printed difference: roadwork and intervals (both conditioning), heavy bag and strength
   (both power). The difference (more tiredness, more kcal) is real but is not shown at the moment of choice, so they read as duplicates.
3. Film as an evening with no bout booked: no opponent to study.
4. "240 min tonight" on a pad night: a game unit. The night is 75 minutes; say "75 min: about 12 rounds on the pads".
5. The pad split cycle (50/50, 70/30, 30/70): fine-grained work that a "first card / both" choice would cover.
6. "Leave" beside "Do it" means "back to the coach's week": the word reads as "ignore the advice".
7. The "Combo" bar button on the pads editor has no words on what it does.
8. Personal twist cards per fighter (to be replaced by the map's club twist: agree).

## Defects seen on the real Training tab (fix now)
- The goal line ("Stamina 64.2 to 64.6 +0.40") is half under the coach portrait; the coach's change ("Mo...") is hidden behind the
  guide bubble, so "Do it" applies a change the player cannot read.
- The fight date, the phase name, the camp lines and the weight sit in a hidden "Legacy" panel (WeekBoard._build); with no bout booked
  the tab shows no goal, no date, no phase.
- The day tiles are icons only (target, fist, heart, bolt): no words for the session.
- Tiredness starts the week at 78, two under the line, and nothing on the tab says why (carried in from last week) or offers a lighter week.

## Does a season of training tell a story?
Partly. The perk road, the tier words, goals with deadlines, peak camp and the skills awards give milestones. But nothing ties them into
one line per fighter: there is no season target, no record of "the camp where the defence came good", and the weeks look alike. The map's
season target and the RPG layer's moments would give it a spine.

## To reach 10/10 (most important first, each buildable)
1. BUILD THE SQUAD BOARD as the Training page (the map's Club week): four rows, one per fighter, seven days each, with the shared
   counters on top in one unit (Coach's pad places 8, your coached mornings 6, asked against covered). Fix the "every boxer gets the
   full coach every night" rule so going short is real. The per-fighter Training tab becomes the drill-down (pad cards, the curve).
2. ONE FOCUS A MONTH PER FIGHTER (weak spot, weapon, goal, ahead), shown as a chip with its size as a range on the next booked bout
   ("Defence: +3 to +5 in 100 on 21 Feb") and in points by fight night ("Defence 58 to 61"). The coach rewrites the week from it.
   Intensity becomes one setting per week (Light / Normal / Hard) plus exceptions.
3. SPARRING ON EVERY SPARRING EVENING: the pair (by weight, stance, style) and the setting (Hard, Technical, Body only, and one
   situational round: Ropes or Southpaw), each priced in gain, tiredness and cut risk. A sparring night can reveal a habit into the
   Coach's notes ("Coach saw: drops the right after the jab").
4. HABITS TRAINED IN THE WEEK: a habit card on your own pad places, 6 pad places to train out, a half-fixed state that holds in the
   fight at 50%, and a relapse when tiredness passes 70 or mood is Flat. The fight's habit cost reads that state.
5. THE SEASON STRIP: 12 weeks per fighter on one strip (Base, Build, Peak, Taper, Fight, Rest blocks; bouts, opens, the nationals'
   entry date). The player can drag one block: a deload week, extend the base, two weeks' rest after a hard bout; the load ratio and
   injury price show before the drop.
6. SIZES IN FIGHT TERMS ON START WEEK: "Your week against Coach's: +2 to +4 in 100 on booked bouts; peak tiredness 71; training injury
   1.4 in 100." Decimals only in hover.
7. LIFE IN THE WEEK: the job rota (shifts, college, exams) blocks mornings; a boxer training alone works at the mood rate
   (0.8 / 0.6 / 0.4); a low-discipline boxer skips one alone session in three unless a team-mate is in the room; the review names each skip.
8. WEIGHT AS A SEASON LINE on every boxer's row: walking weight, class limit, three diets (Hold, Lean -250 kcal, Cut -500), the date
   the line lands, and the amateur's 1.0 kg walking-weight gap.
9. TESTS AS STORY BEATS: the skills award assessment and a bleep test every 6 to 8 weeks on the strip; passing gives the grade's gas
   saving and narrows what you know of that fighter (Known).
10. ANA'S MAT WEEK: three class kinds (drill, positional sparring, hard rolls) with their own price in tiredness and mat time; open prep
   (two weeks of hard rolls) against stripe progress.
11. FIX THE SCREEN NOW: the coach's change readable (move the guide bubble off the bar), the goal line clear of the portrait, words on the
   day tiles, "Leave" renamed "Coach's week", "240 min" replaced by real minutes, and the fight date and phase visible again.

## Complete?
With the list applied: yes, for this version (four fighters, amateur to a first professional fight). The squad board, sparring
settings, habit work, the season strip and weight cover what a club coach decides each week; the professional camp already exists. Without
items 1 to 4, no: the player would be tuning one fighter's decimals while the real decisions (who gets the pads, who spars whom, which fault
to fix) are never asked.

## My 10/10 drawing
`docs/mockups/s432/critics/train_coach_10.html` rendered to `train_coach_10.png`: the Training page as a squad board for week 6, the
season strip on top, four rows (professional in camp, two amateurs, the grappler), shared counters, the focus chips with sizes, sparring
pairs and settings, habit cards, weight lines, and Start week with "your week against Coach's".
