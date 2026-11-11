# Training depth, a fresh and blind critic (a long-time Football Manager and Boxing Manager player), S432

Scored: the training map `ops/research/TRAINING_MAP_S432.md` with its drawing `docs/mockups/s432/training_v2.png`, laid on top of the
training as built (WeekPlan, TrainingPreview, TrainingLoad, PadWeek, PadEdit, MoveMastery, HabitFix, Recruit, PushBack, the Training tab
`trainingb2_23e_real.png`), plus the Club week map v4.1 and the RPG layer map v3 where they feed training.

## Score: 7 / 10 for the design (the training as built today: about 4)

One line: the map turns training from 28 small intensity picks into a handful of priced weekly calls (load, habit card, diet, deload,
who coaches) that reach the fight. It just reaches 7. What keeps it from 9 is that the fighter's ceilings do not shape what to train, an
injury is a dice roll rather than a training choice, and skills that fade are never shown as a cost.

## What I traced in the code (what really happens in a week)
- A morning gives a fifth of a focused week: 1.0 x coach factor x headroom, times Light 0.6, Normal 1.0 or Hard 1.3, and times 0.6 when
  tiredness is 80 or more. Real sizes are about 0.1 to 0.25 of a point a morning. The screen shows them as "+0.13" (as built), which nobody
  can feel. The map's change to whole points with a day ("Defence 52 Wed") is right.
- HEADROOM USES ONE POTENTIAL FOR EVERY ABILITY. `Sim.week_ctx` passes `"pot": int(f["pot"])` and `WeekPlan.day` reads only that.
  `Recruit.ceiling(f, stat)` (potential +6 on the class's strength, -6 on its gap) is read ONLY by the signing card (RecruitPanel). So the
  ceilings the player is shown when signing a fighter do nothing in training. In Football Manager, deciding where a player can still grow
  is the main individual-training decision. Here it is drawn on the card and never wired. This is a defect in the build, not a matter of
  taste.
- Coachability, discipline and mood do not touch the week's gains (the map is right about this). PushBack does use discipline and
  coachability, but only to decide whether the fighter asks for something that week.
- Habits: one is fixed at signing (gone in 4 weeks), or patched for a single round in the corner. There is no habit work in the week.
- Injury in training: about 1.3 in 100 in a normal week, worse after a spike or at 80+ tiredness. When it lands, the fighter is out and
  trains at a quarter. The player cannot train around it.
- Undrilled moves fade slowly (MoveMastery decay), but nothing on the Training tab warns that a move is fading.
- The old block plan (TrainingPlan) still feeds one read alongside the seven mornings (the map retires it, rightly).

## What is good
- One load a week (Easy / Normal / Hard), each button showing its price for this fighter this week: tiredness peak, injury in 100, the day a
  whole point lands, and Legs on bout day. This is the right decision at the right size, and it is worked out by the same code that runs the
  week, so the button cannot lie.
- Habits as training work: There, Half fixed, Gone, paid for with your own pad places. They slip back when the fighter is worn down (three
  weeks over 70 tired, or under 30 energy in a bout), and each one shows what it is worth against the next opponent. This joins training,
  the corner, the fight and the Why, and it is the best mechanic in the map.
- The season strip: deload and rest weeks you place yourself, Legs at the bell on every bout day, award and bleep-test dates. This is real
  periodisation that a player can see and change.
- A sparring setting decides WHAT is trained and what is found (Hard reveals traits, Technical trains timing and defence). The choice is
  about kind as well as amount.
- Weight is always on screen: Hold, Lean or Cut, and Cut costs training quality. The weigh-in that counts is named with its date.
- The person matters: coachability changes what coached sessions give, mood changes what sessions alone give, and low discipline skips
  sessions unless a team-mate trains in the room. Choosing whom you coach becomes a decision about people.
- "Coach runs this fighter's week" shows what it gives up in wins in 100. With four fighters, this is the right tool against
  micromanagement.
- Every number is tagged as coming from the code or an ESTIMATE, and each mechanic has a probe and a rule for cutting it. This is honest.
- Ana gets three class kinds and open prep. It is thin, but it is a real choice with a stripe date on it.

## Missing options (what a Football Manager or Boxing Manager player looks for and does not find)
1. Ceilings for each ability, wired and shown: "room to grow" for each ability, so that "which morning" is a real decision (Strength near
   its cap gives a fifth as much as Defence far from it).
2. Train around an injury or a sore spot. The six body places and the bout damage already exist. A sore hand should turn off the bag and
   pads. Train around it (slower, safe) or train through it (full week, injury odds shown) is a coach's weekly call. Today an injury is a
   roll you cannot answer.
3. Skills that fade, shown as a cost: "Uppercut drops to Learning by 9 Mar". Keeping a repertoire then competes with learning a new move
   for the same scarce pad places. The decay is in the code and invisible on screen.
4. A season ledger: whole points since the season started and what made them (sessions, pad places, bouts), plus what was lost. The map
   rejects a progress chart because it is on the "held back" list. A short ledger of lines is not a chart, and it is what lets a season of
   training tell a story.
5. Bouts that teach: a fought bout (a step-up most of all) should add a little Composure and Fight IQ, more than a sparring night. This
   ties booking to training. It is NOT ESTABLISHED in the code; the Cardio line in my drawing assumes it.
6. "Keep my changes next week" on the Training tab itself (Club week has it). Without it, the morning exceptions have to be done again
   every Monday.

## Useless or weak options
- The morning exception at its own Light / Normal / Hard: keep it in the popover only, as the map says. It is worth hundredths.
- Picking which of ten mornings goes on which day, once the load and the pulls are dealt. Unless a team-mate in the room, a sore hand or a
  weigh-in is involved, the day order changes nothing. The map should let the coach place the mornings from the pulls, and leave the
  player only the exceptions that carry a reason. As drawn, all 14 cells look like decisions.
- Film of your own sparring that always finds a habit "for sure". Once a fighter has no hidden habits left, it becomes a trait reveal for
  two pad places. Make it 1 in 2, or show "nothing left to find on tape".
- The "Silver test" award date on the strip is fine. The bleep test reading every 6 weeks is information only: either let a good level
  open something (a Second wind path) or put it in hover.

## To reach 10/10 (most important first, each buildable)
1. Wire each ability's ceiling into the gain rule: `WeekPlan.day` reads `Recruit.ceiling(f, stat)` per stat instead of the one `pot`. Show
   ROOM TO GROW on the Training tab: a bar for each ability, the ceiling as a range until Known opens it, and a fast / slow / near-cap word.
   The weak-spot pull on Club week weighs headroom. Test: two fighters with the same stats and different class biases gain differently
   over 8 weeks on the same morning.
2. Train around injuries and sore spots. A new small rule (`TrainAround.gd`) reads bout damage by body place and training injuries, and
   turns sessions off by body place (hand: bag and pads; ribs: sparring and body work; legs: roadwork and footwork). It offers TRAIN
   AROUND IT (the turned-off sessions swap to the nearest safe one, healing on time) or TRAIN THROUGH IT (full week, the injury odds for
   that place shown, for example 8 in 100). It shows on the Training tab, on the Club week row as a red chip, and in the Monday review.
   Probe: through-it should be right only within 7 days of a bout.
3. Show fading as a cost. On PAD PLACES, any move or combination that will drop a tier within 4 weeks gets a "fading" row with the date
   it drops ("loses Sharp 16 Mar"). Club week's Ahead and weapon pulls count a "keep it" pad place. A maintenance pad place stops the fade
   for 3 weeks.
4. A SEASON SO FAR ledger on the Training tab and in the Monday review: each whole point since the season target was set, with its
   causes counted (slip rope 6 mornings, Technical sparring 4, bouts), and losses in red. These are lines, never a chart.
5. Let the coach place the mornings. The player sets the load, the pulls (Club week) and the exceptions. Each day-cell shows the coach's
   reason ("Slip rope: weak spot"). A cell the player changes keeps a gold edge and its reason, and "Keep my changes next week" carries it
   forward.
6. Bouts teach: a fought bout adds Composure and Fight IQ (more for a step-up or a loss on points). Show it in SEASON SO FAR and on the
   bout sheet ("a step-up teaches about twice as much"). Probe it so it never outweighs a month of training.
7. Every size on screen comes from a probe or is not printed. That is the map's rule; I am repeating it because the load buttons, the habit
   card and "yours against Coach's" all depend on LOADDIAL1, HABITWEEK1 and FIRELEVEL2. Run those three before the screen is built. If
   LOADDIAL1 comes back flat, re-price Hard (for example x1.4 gains, x1.6 load) before the dial is cut.
8. Make own-tape film honest: a found habit 1 in 2, "nothing left to find" when the file is empty, and the cost in pad places on the
   button.
9. Ana: a fourth class kind is not needed. Show the stripe date for each choice on her page the way the boxers' Defence date is shown,
   and let her mood change mat gains the way it does for the boxers.
10. Take the tiredness curve off the Training tab and put it on Condition. The load buttons already show the peak, and the strip shows
    Legs on bout days. That frees room for ROOM TO GROW and BODY (see the drawing).

## Complete for this version?
YES, with the list applied. Four fighters going from amateur to a first professional fight need: a weekly load with a price; a choice
of what to grow, shaped by ceilings; habits worked out over weeks; weight against a named weigh-in; periodisation to the bout days; a
way to handle injuries; a reason to keep old skills sharp; and a season that reads as a story. The map covers six of these eight. Items
1 to 4 cover the other two (ceilings and injuries) and make the season readable. Further depth, such as age curves, scars and moving up
a class, really is for later.

## My 10/10 drawing
`docs/mockups/s432/critics/tr2_player_10.html`, rendered to `tr2_player_10.png` (1920x1080). It keeps the map's season strip, load
buttons, week grid, pad places, habit, weight and the person, and adds ROOM TO GROW (ceilings), BODY (train around it), fading rows on
the pads, SEASON SO FAR, a THIS WEEK BUYS line and "Keep my changes next week". The tiredness curve moves to Condition.
