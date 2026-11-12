# Animations we are missing, compared with Undisputed and Blood & Canvas (S439)

Owner's question: "so the helpers will also tell us exactly what animations we are missing compared to them?" Yes. This is that list.

Sources. For our side I read the fight's own clip tables (`scripts/fight3d/BeatClips.gd`, `FightClips.gd`, `MoveClips.gd`, `RkClips.gd`, `GuardLife.gd`, `SideStep.gd`, `KnockdownCount.gd`, `Referee.gd`, `CornerMinute.gd`), the 169 clip ids from `ops/Tools/lean_anim_catalogue.py --ids`, everything under `assets/anim`, the owned raw files on disk (`E:/FightCamp/packs`, `C:/Users/user/Downloads`), and this session's studies (CLIP_CRITICS_S439, CROSS_POWER_S439, UPPERCUT_RANGE_S439, REFERENCE_DISTANCES_S439). For their side I used the two read-only inventories made today: clip families, counts and lengths only, nothing of theirs copied. We never take another game's clips. Every source named below is one we own, a pack we would license, or our own capture.

CHECKED (second pass, S439): every "we have" line was re-read in the code and on disk, and every "they have" line against the two inventories. Corrections are folded in below; the ones that change a decision are listed in "What the check changed" at the end.

## The short answer

- **Undisputed**: one fighter has about 270 clips in a fight. Their punches come in 3 ranges plus stepping versions. They have 36 hit reactions (18 snap-backs and 6 stumbles by zone and strength, plus 12 counter-hit ones), 32-40 knockdowns, 13 clinch clips and about 57 long footwork takes.
- **Blood & Canvas (demo)**: about 130 fight clips. Punches come in 4-6 forms, with 20 flinches by punch and height, 9 stumbles and 9 knockouts plus one downed loop. There is no get-up, no clinch and no slips.
- **Us**: the catalogue lists 169 clip ids; the fight body loads every baked Punch PRO file (about 145) plus the Starter, old and staff clips. In a fight it picks from about 63 punch clips (19 of them switched off on score), 24 hit reactions, 6 dodges and weaves, 1 head cover-up, 3 knockdown counts, 7 knockouts, 7 wins (played only after a stoppage), about 9 guard and fidget loops, 4 tired idles, 4 old footwork loops and 1 two-person clinch. On top of the clips, code layers already do some of what they use clips for: the arm reaching the target, a head snap in the punch's direction, an elbow brace on a blocked body shot, a tucked inside guard, a weave between punches, a tired slump and shorter tired steps.
- **Where we are already level or ahead**: a tired version of 5 of the 6 punches (Undisputed has no tired punch clips at all, only slower playback); stepping versions of jab, cross and both hooks (the stepping uppercuts exist but are switched off on score, so here we are level, not ahead); 4 tired idles, a procedural tired slump and shorter tired steps; win celebrations; an entrance through the ropes; the standing boxer walking to the neutral corner during a count; a corner minute with water, ice, the coach face to face and the cutman's hand at the cheek (pro bouts). NOT ahead: missed punches. Only 1 of our 6 miss takes plays (the other 5 are off on score); neither reference has miss clips either, so it is not a gap against them.
- **The biggest gaps**, in order (for a management game seen from one broadcast camera):
  1. Punches that fit the distance and carry the body.
  2. The hurt state: a dazed idle (owned, never played) and staggers.
  3. The result: a loser's reaction, and any celebration at all on a points decision.
  4. A body punch for each hand.
  5. Body knockdowns (to a knee).
  6. Reactions by body side and for uppercuts.
  7. Head blocks by side.
- **What closes most of it**: many fixes need no new capture. They come from clips we already own and do not use: about 30 Punch PRO takes, 2 Rokoko knockout takes, 7 long owned takes and about 100 boxing-related Mixamo files in Downloads. The planned Fab Boxing Animation Pack (Personal, EUR 69.23, the owner's buy at month end) covers parries, body punches, guard styles and slips that keep facing the opponent.

Note for every "owned Mixamo" line: those files are generic single-actor clips of mixed quality. Each one goes through the same eye check and critic score as S381/S383 before it plays (S381 dropped several on sight). Mixamo clips may ship inside the game but never as loose files.

## The gap list, most needed first

### 1. Punches and their variants

**1a. Punches that fit the fight's distance, with the body travelling into them. MUST.**
- They have: Undisputed gives every punch an inside version (body moves 1-3 cm), a normal version (7-16 cm) and a power version, 36 in all, plus 17 stepping punches (stepping in travels 35-63 cm). Arm IK closes the last 0.3 m. Blood & Canvas has head, body, power and step-in forms of all 6 punches (its step-in forms may never play in the demo: the distance flag has no writer).
- We have: one to four plain takes per punch, and every take is played with the hips pinned in place (0 cm forward against a real 28 cm); the stepping (`_ft`) takes are pinned too, because their names carry no travel word. Our own arm reach (`PunchReach`) already does what their arm IK does on a landed punch, and leans the chest when the arm is short. Our plain uppercuts only reach at 0.61-0.70 m but are thrown from 0.84-0.94 m, so the arm locks straight. Jabs and crosses reach further than the stance, so the arm folds. Critics scored our 15 punches 2.0-5.0 out of 10.
- Why it matters in our fight: every exchange is made of these. The owner has already flagged both of these on film: "the punches do not feel like they have power" and "the uppercut aims too short". A management player judges his fighter's power and style by them.
- Clips needed: about 12. That is an inside version of the 2 uppercuts and 2 hooks (4), and a "normal range with a step of weight" version of jab, cross, both hooks and both uppercuts (6), plus 2 power takes that load visibly.
- How to get it: first, a variant made from ours. Let the hips carry 10-18 cm into landed power punches and pick the take by distance (CROSS_POWER fixes 1-3, UPPERCUT_RANGE fixes 1-4). Next, owned Mixamo short, medium and long jab and hook sets (Short/Med/Long_Head_Jab, Short/Mid_Hook_Punch_To_The_Head, Boxing_Lead_Hand_Uppercut, Standing_Left_Uppercut_Punch). Then the Fab pack. New capture only if all of those fail the critics.

**1b. A body punch for each hand. MUST.**
- They have: Undisputed has every punch to the body in 3 ranges (18 clips). Blood & Canvas has a body form of all 6 punches.
- We have: 2 body punches: `pro_body_shot` (the body hook) and `pro_kidney_shot` (the round's big body shot). There is no body jab, no body cross, no rear body hook and no body uppercut.
- Why it matters in our fight: body work is a real tactic in our sim (body damage, folding, cardio). The owner said "body shots do not seem to have any impact" (S305). One body punch makes every boxer look the same downstairs, and head against body is easy to read from the broadcast camera.
- Clips needed: 5 (body jab, body cross, lead and rear body hook, a body uppercut).
- How to get it: owned Mixamo files Short/Mid/Long_Body_Jab, Short/Mid/Long_Hook_Punch_To_The_Body and Boxing_Body_Jab_Cross_Short/Medium/Long. The Fab pack has a body version of every punch.

**1c. Punch that lands on the guard (the attacker's side). LATER (was SHOULD).**
- They have: Undisputed has a jab and a straight that stop on the gloves (2). Blood & Canvas has none.
- We have: no clip, but the arm does NOT pass through the guard. Our punch clips were authored at bag range, so at the fight's gap the glove falls short onto the raised gloves; a blocked punch is never armed by the reach code, and the block lifts the defender's gloves to meet it (BLOCKMEET2). What is missing is the arm's recoil off the gloves.
- Why it matters in our fight: blocked punches are common, but they already read as "on the gloves" from the broadcast camera.
- Clips needed: 2 (jab, cross).
- How to get it: a variant made from ours (cut at guard contact, a short recoil). No capture needed.

**1d. Counter-hit and "caught open" reactions. LATER.**
- They have: Undisputed has 12 (stun when hit while throwing, punish when hit after a miss; both meanings INFERRED from names). Blood & Canvas has none.
- We have: no clip of our own. A counter that lands plays a normal reaction; a counter that beats the other punch cuts that punch off (S393 CounterCut).
- Why it matters in our fight: counters are already shown as a tactic, and a bigger reaction would sell them. The normal reactions are enough until the basics land.
- Clips needed: 2-4.
- How to get it: a variant made from ours (the punch cut off mid-way, blended into one of the long reactions we own but do not use).

**1e. Missed punches. LATER (ours, not a gap against them).**
- They have: neither game has a miss or overreach clip.
- We have: 6 miss takes; 5 are switched off on score (only `pro_right_hook_miss` plays), so a missed jab, cross, lead hook or uppercut plays its plain take.
- Clips needed: 0 new; re-score or fix the 5 owned takes when the punch work (1a) is done.

### 2. Defence

**2a. Head blocks by height and side. SHOULD (was MUST).**
- They have: Undisputed has 6 guard flinches (high or low, left, centre or right; shared by every style), plus held guard poses. Blood & Canvas has a high and a low guard steered by direction.
- We have: one head cover-up (`mc_to_block`, gloves lifted to face height by BlockGloveLift). A blocked body shot is NOT a high cover: since S305 the elbow on the punched side drops onto the ribs (HitSnap.brace, a code layer, side-correct). The 3 Punch PRO "block straight hit" takes and the Starter one are owned but not played, because the rear glove rises over the head (S304).
- Why it matters in our fight: the block is the sim's most common defence, and every head block looks the same. The body block and the glove height are already right, so this is smaller than it looked.
- Clips needed: 3-4 (high left, high right, high centre; one braced body block if the code brace fails the critics).
- How to get it:
  - Clips we own: Punch PRO block_straight_hit v1-v3, with the glove held down by the existing `BlockGloveLift`/guard code.
  - Owned Mixamo: High_Left/Right/Center_Block, Low_Left/Right/Center_Block, Body_Block, Standing_Block_React_Large, Standing_Block_Start/End.

**2b. Ducks, forward slips and inside dodges. SHOULD.**
- They have: Undisputed has 4 slips (left, right, back, down/forward), 8 dodges (including diagonal forward under the punch and 2 close-range ones) and a 12-way weave blend.
- We have: in the fight, a dodge to each side and one back, and a left, right and quick weave (6), picked by the punch's side; each dodge or weave then steps her to a new angle (SideStep); a code weave (GuardWeave) moves the trunk between punches. `pro_back_weave` is owned and timed but not in the fight's rotation. There is no duck straight down, no step forward under a punch and no inside dodge. Our slips turn her back (S434 answer).
- Why it matters in our fight: head movement is a style trait the player trains and pays for. Today the defensive styles look alike.
- Clips needed: 4 (duck, slip forward-left, slip forward-right, inside dodge).
- How to get it: owned `pro_back_weave` first; owned Mixamo Standing_Dodge_Forward/Left/Right/Backward, Edge_Slip, Slipping, Corkscrew_Evade and Boxing_Dodge_Advance/Retreat. The Fab pack has slips that stay facing the opponent.

**2c. Parries. LATER.**
- They have: neither game has parry clips.
- We have: none.
- Why it matters in our fight: it is a nice style marker but not needed to read the fight, and neither reference has it.
- Clips needed: 2-4.
- How to get it: the Fab pack (8 parries).

### 3. Hit reactions

**3a. Reactions by body side, and for uppercuts. MUST (narrowed).**
- They have: Undisputed has 18 snap-backs in 6 zones (left, centre or right, at head and body) by strength (neutral, harmful, critical), shared by every style. Blood & Canvas has 20, by punch and height (it has no uppercut body flinch either: it reuses the hook one).
- We have: 24 takes in play, chosen by punch type (5 jab, 3 cross, 4 hook, 1 uppercut, 3 body, 5 for the hurt boxer, 4 big head snaps). The head already turns the way the punch drives it, back for a straight and round for a hook (HitSnap, a code layer), so the head side is partly covered. The body has 3 gut-shot folds with no side (liver against right ribs), there is no body-uppercut reaction, and only one head-uppercut reaction (both uppercuts share it).
- Why it matters in our fight: the sim knows which side and zone each punch hit, and the body map shows it. The reaction should match what the menus say.
- Clips needed: 5-6 (liver, right ribs, body uppercut, 2 head uppercuts, one more side head snap).
- How to get it: owned Mixamo Receiving_A_Hit_To_The_Liver, Big_Rib_Hit, Receive_Stomach_Uppercut, Receiving_A_Hit_To_The_Body_By_A_Uppercut, Receive_Uppercut_To_The_Face, Getting_Rocked_By_A_Big_Uppercut and Big_Hit_To_Head (from left, right or straight). Also the long Punch PRO reactions we own but do not use (hook v2/v6/v7/v8, cross v2/v4, jab v1/v2/v4/v5, gutshot v1).

**3b. Staggers (the feet move, into a hurt state). MUST.**
- They have: Undisputed has 6 stumbles of 0.7-2.2 s. Blood & Canvas has 9, by punch and height.
- We have: none. Every reaction is played with the hips pinned, so a hurt boxer snaps and comes back to the guard on the spot.
- Why it matters in our fight: "hurt" is one of the sim's biggest moments (it sets up stoppages and knockdowns). A stagger is how the cheap seats read "he's hurt" before the menus say it.
- Clips needed: 4 (back, back-left, back-right, a forward fold).
- How to get it: owned Mixamo Stumble_Backwards, Injured_Stumble_Idle and Shove_Reaction, plus the two long combination reactions (`pro_hit_by_combo_v1/v2`, not used) with their hip travel kept. A variant made from ours: a reaction plus a planted step back. (Mixamo "Stunned" is a knockdown from a punch, not a stagger: see 4a.)

### 4. Knockdowns and get-ups

**4a. Body knockdown (taking a knee) and falls by direction. MUST.**
- They have: Undisputed has 32-40 knockdowns per fighter by zone and strength (body ones sink to a knee) plus 6 flash knockouts. Blood & Canvas has 9 short knockout clips by punch (a fall it seems to finish with physics) and no get-up.
- We have: 3 knockdowns that get up (`pro_knockout_countdown_v1-3`) and 7 knockouts. None is a body knockdown, and none picks the fall by the side the punch came from.
- Why it matters in our fight: a body-shot knockdown is a different story (cardio, body damage), and our sim produces them. Every fight shows the result and the rank earned, so the knockdown is the most replayed moment (it has its own slow-motion replay).
- Clips needed: 3-4 (body knockdown to one knee, forward fall, side fall).
- How to get it:
  - Clips we own: `pro_knockout_v6` (it gets back up, so it is a fourth count; owned, never played).
  - Owned Mixamo: Kneeling_Down (standing to one knee), Kneeling_On_One_Knee_Idle, Knocked_Down_To_Stomach, Stunned (knocked down from a punch), Falling_From_Losing_Balance.
  - Owned Rokoko: KnockOut_Loser (on disk, not loaded by the game).

**4b. Failed get-up, standing count with no fall, voluntary knee. SHOULD.**
- They have: Undisputed has 89 names (about 35 of them rig or weight tracks): get-up stages, failing at each stage, a voluntary knee, the standing count, and the other boxer walking off. Blood & Canvas has no get-up at all.
- We have: 3 get-ups (inside the count clips) and the mandatory eight after every knockdown, with the "stopped" ending. The standing boxer already backs off to the far neutral corner on the step-back loop and waits there (KnockdownCount), so the "walk-away" is covered. There is no attempt that fails, no voluntary knee and no count over a boxer still on his feet.
- Why it matters in our fight: the early game is amateur bouts. "Beats the count" against "tries and fails" is a real story for a manager's fighter.
- Clips needed: 3 (failed rise, standing-count guard loop, voluntary knee).
- How to get it:
  - Owned Mixamo: Getting_Up_From_Being_Knocked_Down_On_The_Ground, Standing_Up_From_A_Kneeling_Position, Kneeling_Idle.
  - A variant made from ours: a count clip reversed part-way for the failed rise.
  - Clips we own: the standing count can be the hurt idle we own (`pro_idle_hurt_v1-3`) held while the count runs.

### 5. Clinch

**5a. Clinch entry, hold variety, punches inside and the shove-off. SHOULD.**
- They have: Undisputed has 13 (an enter, exit and hold loop for each role, a punch given and taken, short, mid and long pushes). Blood & Canvas has none.
- We have: one two-person clinch clip (`clinch_att`/`clinch_vic`, authored in Cascadeur), block-pose holds (`pro_block_loop`), a push-off, and the referee's break: he steps in, calls "Break!" and parts them with both hands (`af_push`, Referee.gd), then steps out.
- Why it matters in our fight: the sim clinches (a tired or hurt fighter ties up). Today it is one loop that looks the same every time.
- Clips needed: 4-5 (enter, a hold loop for each role, a short punch inside, a push-off reaction). The break already exists; a better referee break is optional.
- How to get it:
  - Owned Mixamo: Shove_Reaction, Restrain.
  - New capture from the two Creative Commons clinch films downloaded in S434, through video-to-mocap (credits line required).

### 6. Footwork

**6a. Pivot and angled-step clips, step sizes. SHOULD.**
- They have:
  - Undisputed: about 57 long footwork takes per fighter (35-62 minutes), cut live: circling, cutting corners, stops and starts. It has no separate step or pivot clips.
  - Blood & Canvas: 8-way walk cycles.
- We have:
  - Four old loops (advance, retreat, strafe left and right), moved by the planted foot (StepRoot) so the feet do not slide. The code already circles, rocks in and out of range, makes an entry lunge and pivots 70 degrees out of the inside (Footwork), all on those four loops; the dodges step to a new angle (SideStep).
  - The captured steps and Mixamo side-steps are switched off since S432 (the owner chose the older stepping route).
  - No clip that shows a pivot on the lead foot, no diagonal and no short against long step.
- Why it matters in our fight: ring control (cutting off, circling off the ropes) is a tactic the player picks in the sim, and the camera shows the whole ring.
- Clips needed: 6-8 (pivot left and right, short and long step in and out, two diagonals).
- How to get it:
  - Owned Mixamo: Short/Medium/Long_Boxing_Step_Forward/Backward, Short/Medium/Long Left/Right Boxing_Side_Step, High/Low Left/Right Boxing_Pivot, Boxing_Advancing_Forward.
  - Clips we own: the 7 long owned takes (CMU 13_17, 13_18, 14_01, 14_02 and Rokoko boxing and shadowboxing) for cutting windows.

**6b. Long footwork database for live matching. NOT FOR OUR GAME.**
- They have: Undisputed has 35-62 minutes per style with motion matching every 0.05 s.
- We have: none.
- Why it does not fit our game: they need it because a player steers the stick. Our sim decides each step, so a set of chosen step clips does the job.
- Clips needed: 0.

### 7. Stance and idle

**7a. Guard styles (high guard, Philly shell, peekaboo, hands low). SHOULD.**
- They have: Undisputed has about 35 styles, each with its own idle, punches, slips and footwork (but shared reactions, blocks and knockdowns). Blood & Canvas has 1 base idle plus 5 alternate idles and 1 long idle, for the player's fighter only.
- We have: one guard (the Punch PRO guard; the Rokoko guard is switched off) with about 8 fidget loops (6 Punch PRO, 2 owned Mixamo), drawn in to the face by GuardTuck.
- Why it matters in our fight: a boxer's style is what the player builds. The owner wants "fighters to stop looking alike" (S434), and a style a menu names should be visible in the ring.
- Clips needed: 3-4 guard loops (1 each).
- How to get it: the Fab pack (5 guard styles). A variant made from ours: the guard code can lower or cross the hands on our loop for "hands low" and "Philly" as a first step. Owned Mixamo Bouncing_Fight_Idle_With_Guard_Up for a bouncier style.

**7b. Inside (close-range) idle. LATER (was SHOULD): mostly covered by code.**
- They have: Undisputed has 1 per set.
- We have: no clip, but since S315 the inside guard is drawn by code: elbows on the ribs, gloves to the cheeks, as the boxers close in (GuardTuck, from Footwork's inside weight).
- Clips needed: 0-1, only if the critics say the code guard does not read.

**7c. Mid-fight stance switch and the charge. LATER.**
- They have: Undisputed has 2 switches and a short forward charge.
- We have: no switch; the entry lunge is code (Footwork). Southpaw boxers use a mirrored set.
- Why it matters in our fight: only if the sim gets switch-hitters.
- Clips needed: 2.
- How to get it: new capture or the Fab pack.

**7d. Authored southpaw copies. NOT FOR OUR GAME.**
- They have: Undisputed authors every take twice.
- We have: a mirror of every clip.
- Why it does not fit our game: from one broadcast camera, a mirrored clip reads the same.

**7e. In-fight taunts. LATER.**
- They have: Undisputed has 16-22 per set. Blood & Canvas has 12 for the intro.
- We have: none in the fight (the intro has warm-ups, bounces and a raised arm).
- Why it matters in our fight: it could show a "showboat" trait, but nothing in our sim asks for it yet.
- Clips needed: 2-3.
- How to get it: owned Mixamo Boxing_Taunt, Taunt_Gesture and Taunt.

### 8. Tired and hurt

**8a. Hurt idle while dazed. MUST (no new clips).**
- They have: Undisputed has a dazed idle per set (4 different ones in the game). Blood & Canvas has none.
- We have: 3 hurt idles owned (`pro_idle_hurt_v1-3`), loaded on every body and never played (no script names them).
- Why it matters in our fight: a dazed fighter stands like a fresh one between punches, from the broadcast camera the cheapest "he's hurt" signal there is.
- Clips needed: 0 new.
- How to get it: clips we own. Wire the three into the hurt state.

**8b. Tired and hurt movement (flat-footed, dragging). LATER (was SHOULD).**
- They have:
  - Undisputed: flat-footed and dazed footwork takes (about 7 and 13 per set).
  - Blood & Canvas: a whole tired walk set that swaps in.
- We have:
  - Tired idles (4), tired punch takes and the procedural slump (TiredSag).
  - Footwork does NOT stay fresh: since S322 burning legs give shorter, slower steps (Footwork). What is missing is a flat-footed, dragging look in the step itself.
- Why it matters in our fight: cardio is a stat the player trains. The slump and the slower steps already show it; a dragged step would add to it.
- Clips needed: 2-4 (tired step in, out and to each side).
- How to get it:
  - Owned Mixamo: Male Injured Walk (E:/FightCamp/packs/mixamo_walks) and Injured_Stumble_Idle.
  - A variant made from ours: the step loops slowed, with shorter steps and the slump on.

### 9. Between rounds, entrance, result

**9a. The result: a loser's reaction, and a winner's on a points decision. MUST.**
- They have:
  - Undisputed: win and loss reactions for each corner, belts and the referee's raised hand (about 55 ceremony names).
  - Blood & Canvas: wins only (5 celebrations and a long triumph).
- We have:
  - 7 wins, 0 losses. A win plays only after a knockout or stoppage (KnockdownCount); on a points decision the ring freezes under the result screen and nobody reacts. The beaten boxer stands in guard.
- Why it matters in our fight: every fight ends on the result screen, most amateur bouts go to points, and half the time it is our fighter who lost.
- Clips needed: 2 (points loss, after being stopped), and wiring the 7 wins into the decision.
- How to get it:
  - Clips we own: the 7 Punch PRO wins for the decision winner (no new clip).
  - Owned Mixamo: Defeat_From_A_Boxing_Loss, Defeated, Defeat_Idle; and Victory_From_A_Boxing_Win, Victory__Celebrating_After_A_Win for more winners.
  - Owned Rokoko: KnockOut_Winner and KnockOut_Loser (a two-person knockout take, on disk, not loaded).

**9b. Referee: the count, the winner's raised hand, the wave-off. SHOULD.**
- They have:
  - Undisputed: 66 (a clip per count number, the break, point deductions, winner left or right, its own small footwork set).
  - Blood & Canvas: none.
- We have:
  - The referee walks with the boxers and fades in for a clinch, where he breaks them with both hands (generic `af_walk`, `af_idle`, `af_push`).
  - He is not on screen for a knockdown (the count is a big number on screen) or the result. No count gestures, no hand-raise, no wave-off.
- Why it matters in our fight: the result needs the hand raised; a referee counting over the downed boxer sells the knockdown.
- Clips needed: 3 (count loop, raise the hand as a pair, wave-off).
- How to get it:
  - A variant made from ours for the hand-raise (arm lifted on af_idle with the existing arm IK).
  - New capture or a licensed pack for the count. The owned packs have no referee clips.

**9c. Corner work: the cutman's own motion. LATER (was SHOULD).**
- They have:
  - Undisputed: 23 (boxer by round mood, trainer, cutman, cut check).
  - Blood & Canvas: a seated clip only (one marked temporary).
- We have:
  - A full corner minute (CornerMinute): walk to the corner and sit, water (the coach holds the bottle to her lips by arm IK), ice on the neck, the coach crouched face to face while the player picks the call, the cutman's fingers on her cheekbone in pro bouts (arm IK, CornerIK), and the other corner's coach talking. Built on generic staff clips (`af_sit_*`, `af_crouch_idle`, `af_talk`).
  - Missing: a dedicated cutman working motion (pressing, swabbing) and the boxer's mood on the stool.
- Why it matters in our fight: the cutman is a staff role, and the scene already shows him at work; a better motion is polish.
- Clips needed: 1-2 (cutman working the brow, trainer instructing with hands).
- How to get it: a variant made from ours (`af_interact`, owned and unused, aimed at the face by CornerIK); new capture later.

**9d. Ring-walk moods and belt ceremonies. LATER.**
- They have:
  - Undisputed: about 65 ring-walk and about 55 ceremony names.
  - Blood & Canvas: 9 walk-ups (plus 1 empty placeholder).
- We have:
  - An entry through the ropes, intro warm-ups (shadowboxing from the owned long takes, bounce, fidgets, a raised arm) and 7 wins.
- Why it matters in our fight: belts and TV come after the small living world (scope S425/S428).
- Clips needed: 3-4 when promotion is built.
- How to get it:
  - Owned Mixamo: Walking With A Swagger, Male Strut Walk (both in E:/FightCamp/packs/mixamo_walks), Boxing_Warm_Up_Exercise.
  - Clips we own: entry_entering_from_ring_corner (owned, not loaded by the game).

**9e. Fouls (headbutt, low blow and the reactions). LATER.**
- They have: Undisputed has 4. Blood & Canvas has none.
- We have: none.
- Why it matters in our fight: only if the sim gets fouls and point deductions.
- Clips needed: 2-4.
- How to get it: owned Mixamo Illegal_Headbutt and Illegal_Elbow_Punch. The low blow needs a variant (a body jab aimed low).

### 10. Not for our game

These need no clips:
- The 12-way analogue weave blend (our GuardWeave code already does its job), the get-up button mini-game and the long motion-matching footwork databases. All three exist because a player steers by hand.
- Signature styles of named real fighters.
- Authored southpaw copies.
- The crowd and hub walking clips, which are outside the fight.
- Not compared: our fourth fighter is a BJJ fighter. Neither boxing game has ground clips, so this list says nothing about BJJ animation.

## What we own and do not use

In the game folder (`assets/anim`), loaded on every body but never picked by the fight:
- **Punch PRO**:
  - `pro_idle_hurt_v1-3` (hurt idles)
  - `pro_knockout_v6` (a knockdown with a get-up)
  - `pro_block_straight_hit_v1-3` (off: glove over the head) and the Starter's `mc_block_hit`
  - `pro_idle_to_block`, `pro_block_to_idle` and the Starter's `mc_from_block` (`pro_block_loop` IS used, in the clinch and push-off)
  - `pro_back_weave` (timed for the Playbook, not in the fight's defence pool)
  - `pro_combo_lh_ru` and `pro_combo_punch` (combo_punch is used only by gym tools)
  - the long reactions `pro_hit_by_jab_v1/v2/v4/v5`, `cross_v2/v4`, `hook_v2/v6/v7/v8`, `combo_v1/v2`, `gutshot_v1` and `_v1_short` (the `_short` cuts of hook v6/v7/v8 and combo v1/v2 ARE used)
  - `pro_hit_by_kidneyshot_v1` (retired S371)
  - `pro_idle_fidget_v5` (`fidget_v4` is used in the intro)
- **Punch PRO, switched off on score** (OFF_TAKES): 19 stepping, special, hard, miss and hurt punch takes, including both stepping uppercuts and 5 of the 6 miss takes.
- **Rokoko**:
  - KnockOut_Winner and KnockOut_Loser (a two-person knockout; on disk, not loaded)
  - the captured jab, cross, guard and steps (`rk_*`, off since S432; `-- rokoko` turns them back on)
- **Long owned takes**: `assets/anim/baked/owned` (CMU 13_17, 13_18, 14_01, 14_02, rk_boxing, rk_shadowboxing_a/b). Used only in corner warm-ups and intros, never in the fight's footwork.
- **Other**: `entry_entering_from_ring_corner.res` (a second ring entry), `mh_guard_pose.glb`, `af_interact`, `af_pickup`, `af_drink`; the three native MetaHuman punches and the old baked clips are only fallbacks.

On disk outside the game:
- **Mixamo, in `C:/Users/user/Downloads`**: 487 FBX files, about 100 of them boxing-related. Every name cited above was found there by name. This list is the main source for gaps 1a, 1b, 2a, 2b, 3a, 3b, 4a, 4b, 6a, 8b, 9a and 9e:
  - steps, pivots, slips and dodges
  - body jabs and hooks in 3 ranges
  - blocks by height
  - liver, rib and uppercut reactions
  - stumbles, knockdowns, kneels and get-ups
  - defeat and victory
  - taunts and fouls
- **Mixamo walks** in `E:/FightCamp/packs/mixamo_walks`: Male Injured Walk, female walks, swagger and strut.
- **CMU trials**: 15_04, 15_05, 79_08 and 80_10 are downloaded but never baked; their contents were not checked. 14_03, 15_13 and 17_10 were baked and then dropped on sight (S383).
- **The Ailive Fab pack**: footwork, duck and sway, dropped on sight (S381).
- **Two Creative Commons clinch films** (S434), waiting for video-to-mocap.

Planned, not yet owned: the Fab Boxing Animation Pack (EUR 69.23) for parries, body punches, guard styles and slips that face the opponent. The owner said he would buy it near month end.

## What the check changed

- We have MORE than the first draft said: the body block is an elbow brace by side (not a high cover); a blocked punch already stops on the gloves; the head snaps the way the punch drives it; the referee does break the clinch; the corner already shows water, ice, the coach and the cutman at the cheek; tired legs already take shorter, slower steps; the inside guard is drawn by code; the standing boxer already walks to the neutral corner during a count. So 1c, 7b, 8b and 9c drop to LATER and 2a to SHOULD.
- We have LESS than it said: the stepping uppercuts and 5 of the 6 miss takes are switched off, so "a stepping and a missed version of every punch" was wrong; the wins play only after a stoppage, so a points decision ends with no reaction at all (added to 9a, which stays MUST); `pro_back_weave` is not in the fight.
- Ranking moved for the broadcast camera: the hurt state (8a hurt idle, owned and free, plus 3b staggers) goes up to second; body-side reactions (3a) go below body punches and body knockdowns.
- Mixamo "Stunned" is a knockdown, not a stagger (moved from 3b to 4a). Swagger and strut walks are in `packs/mixamo_walks`, not Downloads.
- Their side: Undisputed's 24 reactions are 18 snap-backs plus 6 stumbles (the 3b stumbles are the same 6, not extra); Blood & Canvas has 9 knockouts plus a downed loop, and 9 real walk-ups.

## How sure this is

- Our side was read in the code and on disk (both passes).
- Their side comes from the two inventories made today: names, counts and lengths, with some purposes INFERRED from names.
- The Mixamo files were matched by name only. Whether each one is good enough is decided by the eye check and the critics, the same as every clip before it.
- Clip counts are the smallest set that closes each gap from one camera. They are not a target to match their totals.
