# The body is the track (S321 core-mechanic plan, for the operator's OK)

Operator S321: "make it in a pc game sense, something that can be a core mechanic for the game - like see the body as the track
on MSM"; "use outliners for each part on the body"; reference: a colour-coded muscle figure (each muscle its own shape, clean seams)
- previews/s321/ref_muscle_colours_operator.jpg. Mockup: previews/s321/body_track_mockup.png.
This plan replaces the narrower corner-ice plan (Q-S294-36) and folds in Q-S294-34 parts 2-3 (aim + Push/Steady/Save).

## The idea in one line
In a racing manager you never drive: you watch the track, read tyre wear and fuel, choose the driver's mode and call the pit stop.
Here you never punch: you watch both boxers' BODIES, every muscle group outlined and coloured by how worked it is, choose her pace,
choose where she aims, and use the 60-second corner as the pit stop.

## What the body shows (each part: shoulders, arms, chest, core/ribs, legs, head - left and right where it matters)
- **Burn** (colour, blue fresh -> green -> yellow -> red): short-term fatigue. Rises with the work that part does (punching = shoulders
  and arms, moving = legs, holding in the clinch = chest/arms). Comes back part of the way in each minute's rest - our J68 numbers:
  about 55-65 % of the fast fuel returns in 60 s, the acid only slowly, so it never fully resets.
- **Tank** (the gauge under the figure): whole-fight energy. Only goes down round after round. Push spends it faster.
- **Hurt** (red outline, pulses): damage from punches. Stays all fight. The cutman can only stop a cut or slow a swelling.

## What each part does in the fight (what the player SEES in the 3D fight, not only a number)
- **Shoulders burning:** her hands drop - the guard sits lower and her punches come slower. (Every boxing coach's first sign of a
  tired fighter; our fight already has a guard height to drive.)
- **Arms:** less power, shorter combinations.
- **Legs:** fewer steps, she gets caught on the ropes, punches from too far stop stepping in (PunchRange).
- **Core / ribs hurt:** she breathes harder - her Burn comes back slower everywhere (why boxers "go to the body").
- **Head hurt:** more chance to be rocked or dropped; eyes: a cut or swelling makes her miss more on that side.

## The player's decisions (few, visible, with a cost)
1. **Pace: Push / Steady / Save** (driver mode). Push = more punches and pressure, Burn and Tank go faster. Save = she cools down,
   throws less, gives rounds away. The trade: win this round, or have hands up in round 9.
2. **Aim: tap HER body** (the rival's tyre wear). You see her legs going orange, so you aim at the body to finish them, or her R ribs
   are hurt so you go there. The shout bar says it in words ("Go to the ribs!").
3. **The corner = the pit stop** (limited hands, the clock runs): the second works ONE part (ice and shake-out the burning shoulder:
   that part's Burn comes back faster - modest, it is what corners really do); the cutman fixes ONE hurt place; the coach gives 1-2
   instructions. Amateur bouts have one person in the ring, so working a cut costs an instruction.

### S322 operator rulings (board)
- Q-S294-38 "Build it". Q-S294-36 "Change it": "the cut should be handled by the cutman, nothing to do for the player here."
  So the cutman works cuts and swellings by himself every corner; the player never taps a cut. The second works the most
  burning part by default (Kalli SQ23: the corner works itself); the player may move the second to another part. The
  coach's instructions stay the player's call. No running blood (Maria SQ22: the 2026-09-22 blood ruling stands).
- Build order: BodyLoad rules (TASK_BODYLOAD1, Qwen) -> guard height / steps / power in the 3D -> the body view.

## Why it is a CORE mechanic, not a screen
- **The gym feeds it.** Training targets body parts: bag rounds lower the shoulders' Burn rate, roadwork the legs', sparring builds
  the head's resistance. Every gym decision shows up on the body in the fight - the management half and the fight half are one game.
- **Every boxer is a different car.** Build, weight and attributes set each part's Burn rate and Tank; a pressure fighter burns arms,
  an out-boxer burns legs. Scouting = reading the other body before the bell.
- **It makes the fight readable at a glance** - the thing the operator asked for since the body map (S316): where she is tired,
  where she is hurt, what to do about it.

## The look (operator's reference)
Each muscle a separate solid shape with clean seams (his reference), coloured by Burn instead of by muscle, a red outline when hurt,
her own skin tone/build kept by fitting it to her MetaHuman body. Production: buy ONE female + ONE male anatomy model whose
muscles are SEPARATE meshes/groups (must-have; e.g. CGTrader "Highly Detailed Female Sculpted Anatomy" $35 lists individual muscle
groups as FBX), colour each piece live in Godot. AI image tools cannot do it (6 Ludo tries, S321). The glass-body previews
(body_track_mockup.png) are the stand-in until the model is bought.

## Size and order
1. Rules first (pure, testable): BodyLoad per part (Burn/Tank/Hurt), driven by the bout's beats; Pace and Aim change its rates.
2. Fight view: guard height from shoulder Burn, steps from leg Burn (the 3D already has both knobs).
3. The body view: the bought model, parts coloured live, tap to aim, corner pit stop taps.
4. Gym link: training lowers Burn rates per part.
About 2-3 sessions for 1-3; 4 after.
