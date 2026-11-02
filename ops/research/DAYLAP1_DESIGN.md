# DAYLAP1 - the training week you watch (design on paper, S172, 2026-10-06)

Operator ruling, verbatim (S172): "we are not making a copy of motor sport wtf are you talking about there will be no such thing. the
week should be the equivalent of the 10 laps or something bu tit will not be displaying like a running car, every week the trainging is
set and you watch the fighter do it you watch him and intervene when you want to press him harder or easy him etc"

This SUPERSEDES the S171 "day lap" framing (fighter walking a 6-slot route, lap pauses, whole-gym laps) and the parts of
DAYLAP_OPINIONS_S171.md built on it. Motorsport Manager is NOT the model. Only one idea is kept from that comparison: the week is the
practice run before the race, and what you see while it runs tells you what to change.

## The loop in one line
**Set the week -> watch him train in the 3D gym -> push him or ease him when you judge it -> the week review shows what that did ->
the fight shows what the camp built.**

## 1. Set the week (TO BE REBUILT)
Operator S172 on the current planner: "it is terrible as it is now in the game it will need to change completely". The TRAIN2 table
(filters, presets, LOAD/READY/COND columns, small OFF cells) is NOT the week screen of this loop. Proposed replacement (mock shown in
chat S172, awaiting his reaction): ONE fighter at a time; his goal line on top (opponent, weeks out, the coach's one-sentence read);
seven BIG day cards (icon, session, what it trains, an effort chip Easy/Normal/Hard/All-out); six session tiles (bag, pads, spar,
strength, roadwork, rest); "what this week does" in plain words (gas tank up, jab sharper, tired by Saturday); "Let the coach plan it";
one gold START THE WEEK. Effort set here is the default you then change live by watching.

## 2. Watch him do it (the new part)
- Press play: the days run on the 3D gym floor. He trains at the station of the day, with his coach beside him (the floor exists:
  TRAIN1B drill loop, reps bar).
- Speed: 1x (a day is about a minute), 4x, skip to Sunday. Clicking him pauses. Nothing forces you to watch; skipping trains him
  as planned at normal effort.
- **What you read by watching** (readability beats realism, D35 s10):
  - his effort: punch pace on the bag, how sharp the combinations look;
  - his tiredness: hands drop, slower punches, breathing; one small meter over his head: EFFORT and FATIGUE;
  - a one-line coach remark when something changes: "he's coasting", "he's gassed", "this is his best session all week".
  These are the reasons to intervene. The player decides; the game never stops on its own for a normal session.

## 3. Intervene (the only verbs)
Click him: two big buttons, icons with tooltips.
- **PUSH HIM** - one step harder (Easy -> Normal -> Hard -> All-out).
- **EASE OFF** - one step softer.
- (later, if needed) **PULL HIM** - end the session, he rests.
The effect is immediate and visible: the punch pace changes, the meter moves, the coach reacts.

## 4. What a push or an ease costs
- Harder = more gain this session, more fatigue; injury risk rises with fatigue, not with effort alone.
- Easier = less gain, he recovers.
- His temperament changes the answer: a lazy fighter coasts unless pushed; a hothead overtrains on his own and needs easing;
  pushing a gassed fighter costs morale ("he's had enough of you today").
- Gains bank toward the camp plan against the opponent.

## 5. The week review shows what you did
Monday's review names your interventions and their result, in words: "You pushed him Thursday: jab +1, but he was sore Friday."
"You eased him Tuesday: fresh for sparring, the sparring went well."

## 6. The fight shows what the camp built
Fight week and the fight must show the camp (today it reads "CAMP BUILT OVR 49 -> 49" - finding 1 of DEMO_DESIGN_REVIEW_S172):
what was drilled, how fresh he is, and in the fight the drilled weapon lands more. A pushed camp and an eased camp must look
different on fight night, or the whole loop is decoration.

## What it is NOT
No car, no laps on screen, no fighter walking a route of slots, no lap pauses, no "watch the whole gym" camera. You watch your
fighter train; with more fighters you click the one you want to watch, and the others train as planned.

## Build slices
1. **Effort per session** in the training engine (Easy/Normal/Hard/All-out -> gain, fatigue, injury risk, temperament), with a
   headless test: a pushed week gains more and tires more than an eased week, with a control arm at Normal = today's numbers.
2. **PUSH / EASE on the floor**: click him, two buttons, the effort changes live (punch pace, meter, coach line).
3. **Week review lines** naming the interventions.
4. **The camp on fight night** (fight week + the fight show what was built).
Each slice is judged on the game camera; slice 2 goes to the operator as a video before it is switched on.

## Pass bar
Watching tells you when to push or ease (a tired fighter LOOKS tired). A pushed week and an eased week differ visibly in the week review
AND on fight night.

## S172 update - the interventions (operator: "1-3 is fine" after rejecting PUSH/EASE as the core)
Effort harder/easier stays only as a setting. The three interventions and how they are SHOWN (wireframe shown in chat S172):
- One screen: the 3D gym, camera on his station; timeline on top; fighter strip top-left (fatigue, fight countdown); the coach's
  NOTEBOOK down the right (habits spotted / combos drilled / corner calls, 3 pips each); one context strip at the bottom.
1. **Spot his habits**: tells live in his animation (left glove drops after the jab, chin up when tired, squares up on the ropes),
   unannounced. Click him during the tell: a short freeze, a chalk circle on the glove, the label ("Left drops after the jab"), and that
   freeze-frame becomes the notebook entry's picture. Wrong moment: "nothing there". REPLAY 5 s rewinds in slow motion to catch one.
   Proof it worked: as the habit is drilled (pips fill) the tell shows less often in his animation.
2. **Call the drill** (pads days): bottom strip = 4 combo cards in punch numbers (1-1-2, 1-2-hook, slip-2-body, uppercut-hook). Click one:
   Holl shouts it (bubble), Torres throws it on the pads; a clean rep = a sharp pad pop, a sloppy one = dull. Reps fill the card's ring.
   Fight night: when a drilled combo lands, the scorebug flashes its card icon, "drilled in camp".
3. **Train the corner** (spar days): after each spar round the bottom strip becomes the SAME stool card as fight night, small. You call;
   the next round shows whether he does it. Each call earns rehearsal pips; on fight night the corner card shows the same pips and a
   rehearsed call takes hold within seconds, an unrehearsed one only half.

## S172 OPERATOR DESIGN (verbatim, voice transcript) - this is the design of record for training and the game's main screen
"So this is how the training will work and the whole game design. Three D gym as a landscape, as the main picture, as the main setup,
right? There are bikes and runners, conditioning runners and weights and all this shit. You pick the fighter. The time is running during
the day. If you if you pick the fighter to go do conditioning on the on the running screen, for example, and you let him all day, he will
get exhausted. He will get a good benefit though for conditioning, but he will get exhausted. So you have to change them during the day
between the training stations. Heavy bag, quick bag, and all this shit. Each of these. Trainings will have impact and improve the fighter.
When you go to practice the moves, it's the same logic. You train one move a lot, you, you perfect it, but you lose time and you stay back
on other things. Like you have to, on the training, you have to. Go for defense practice. You have to go for boxing practice and all the I
don't know all the different techniques that you do when you make do the skills. But you break that down into a couple of maybe three
stages, and during the day the player can choose to to move or give an order. To the fighter to do something else."
Claude's reading (to confirm with him): the 3D gym is the main screen; the day clock runs; you pick a fighter and send him to a station
(treadmill, bike, weights, heavy bag, speed bag, pads, ring, defence drill); every minute there trains that station's thing and tires him,
gains fall as he tires, so you rotate him; move practice works the same (one move a lot = perfected, the rest left behind); the day is
split into about three blocks where you re-assign, and you can also give an order any time.

## S172 OPERATOR CLARIFICATION (verbatim) - THE CORE LOOP
"The loop is the day similar to a lap. This is the analogy. The fighter during the day has options to train on the heavy bug on the
different things while the time is, is running. Each thing gives specific benefits, but he loses stamina. So he, the loop is that he, he
needs to manage the stamina during each day. Is that clear ?"
=> THE CORE LOOP: one day = one lap. The resource managed inside the lap is the fighter's STAMINA. Every station gives its own benefit
and drains stamina while the clock runs; the player's job is to spend the day's stamina well across the stations. (Like fuel/tyres over
a race lap - the analogy only, nothing else from racing.)

## S172 OPERATOR (verbatim): "There will be no fast forward once the fighter is practising during the day , find something clever to do during Resting on analogy for the pit stop"
=> NO fast-forward while he trains (the day plays in real time, so a day must be short and watching is the game). REST = THE PIT STOP.
Proposal (Claude, awaiting his OK): the recovery corner is the pit box. A rest break is a short fixed window; a few SERVICES fit in it,
each costs seconds of the window and fixes one thing, done on screen by the staff (the pit crew):
- REFUEL (shake / food): refills the stamina pool. = fuel.
- FRESH LEGS / FRESH ARMS (ice bath, massage): clears SORENESS of the body part the last block wore out (treadmill -> legs, heavy bag
  -> shoulders/hands); sore parts make that kind of training give less. = tyres (wear by where he worked).
- PATCH UP (physio tape, check a niggle): lowers injury risk. = repairs.
- THE TALK (coach): sets his head for the next block - fire him up (bigger gains, faster drain) or calm him (efficient). = driver instruction.
- THE TAPE (phone footage of the last block): review it to note the habit you spotted -> it gets drilled. = telemetry.
Timing like an undercut: resting early, while still half full, buys a better next block; resting late refills more but wastes the empty
minutes. Staff quality = pit crew speed (a good physio does PATCH UP in half the time).

## S172 OPERATOR (verbatim) - stations, coach pool, move cards
"so while the day runs the player clicks on the stations he wants to train the fighter (fighter moves to the station and starts training) ,
the coach can buff the station when he is present with the fighter, when player clicks to change the station the fighter needs to walk and
prepare  for next session this consumes some more time and the coach has a pool that drains between training sessions  , player needs to
keep balance during a week so that he will not drain the coach and not tire or injure the fighter, same logic with the moves fighter and
coach on the ring the player decides which skills to train (available skills per discipline coach knowledge etc are shown on the screen
maybe like cards) and for how long since he can click on another skill , there will be threshold that he needs to spend time on each move
to at least be usable and  then can unlock other moves and combos . what do you think of this idea"
Mechanics this sets: (1) click a station -> he walks there, PREPARES (switch cost in time), trains; (2) the COACH buffs the station he
stands at; the coach has his own POOL that drains per session and must last the WEEK; (3) three things to balance over the week: fighter
stamina, fighter injury risk, coach pool; (4) MOVES: on the ring, move CARDS limited by discipline and the coach's knowledge; time on a card
fills it; past a USABLE threshold the move can be used in fights and unlocks follow-up moves and combos.


## S172 Operator S172 (verbatim): "keep other scenes as expansion of the gym scene"
The rooms built S105-S154 stay; each opens from its place in the one gym (door, desk, film corner), as an expansion of that scene.
