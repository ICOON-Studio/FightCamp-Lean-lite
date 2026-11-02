# Fight night script v2: the intro and the corner minute (S306, for the operator's approval)

Operator S306: "write the script properly for intro and for in between rounds walk from the corner each time make them sit?
is this a bad idea?" then "can you make the whole corner come in through the ropes holding the stool and having real time to
act, can you make it as close to real movie clip?"

## Verdict
Yes. Real boxing has a full minute between rounds and the broadcast films it like a short scene: the corner climbs in,
the stool goes down, the coach talks into her face, water, ice, then "seconds out". Here that minute is real time, and it
is also YOUR minute: the corner card is what the coach says, so you pick the call while the minute runs, like a real coach
(no pick by "seconds out" = the coach says his own default). One click skips to the bell for anyone who has seen enough.

## The corner (who comes in)
- Amateur bouts (most of her career): the coach and one second (amateur rules allow two in the corner, one in the ring).
- Pro bouts: the coach, the cutman and the second.
- Bodies: the old project's clothed MetaHuman staff - mh_staff_coach (1-3), mh_staff_cutman_1, mh_staff_trainer (as second).
  Her coach is the gym's coach you hired (his look follows the coach card when we have more bodies).

## The script (seconds of real time; camera in brackets)

### Intro, once a fight (about 15 s; SKIP jumps to the first bell)
1. (Wide, slow push-in) Both boxers in their corners, bouncing, the corner teams on the apron behind them. 2 s.
2. (Medium on red's corner, low angle) The announcer names her - caption: name, club, record. She steps out and raises a
   glove; her coach slaps her shoulder. 3 s.
3. (Medium on blue's corner) The same for the opponent. 3 s.
4. (Broadcast) Both walk to the centre; (close two-shot) they touch gloves. 3 s.
5. (Wide) Back a step to their corners, the corners climb out with the stools. "Seconds out." 2 s.
6. The bell; they walk out to the centre and take up the guard. ROUND 1. 2 s.

### The corner minute, after every round that is not stopped (60 s real time)
| Clock | What happens | Camera |
|---|---|---|
| 0:00 | The bell. Both drop their hands, turn away from each other and walk to their own corners. | Broadcast, pulling wide as they part |
| 0:02 | Her second climbs the corner steps, slides the stool through under the middle rope and sets it in the corner; the coach steps through the ropes. | Tracking behind her as she walks into the corner |
| 0:04 | She sits. | Medium from outside the ropes, low angle, the ropes in the foreground |
| 0:05 | The second squirts water into her mouth, she spits into the bucket; ice pack on the back of her neck; he pulls her waistband out so she can breathe. | Close inserts, 1-2 s each, shallow focus |
| 0:08 | The coach crouches in front of her, face to face. THE CORNER CARD comes up (the call you choose). The clock runs on screen. | Over the coach's shoulder onto her face, shallow focus; reverse on the coach when he speaks |
| your pick | The coach's line for your call, as a caption, then a second line from her round card ("You won that round", "She's tiring - go to the body"). | The same two shots, cutting on each line |
| 0:30 | The cutman works on her face if she was hit clean (Vaseline on the cheekbones, cold iron under the eye). Pro bouts only. | Close on her face |
| 0:40 | Cut-away: the other corner, her coach shouting at her, 3 s. | Wide on the other corner, long lens |
| 0:50 | "Seconds out!" The corner climbs out, the stool is lifted out through the ropes. She stands, rolls her shoulders. | Medium, slow push-in on her face |
| 0:58 | She walks out; guard up; the bell. ROUND n (the round opens on your call's beats, as today). | Broadcast |

Tired boxers breathe hard on the stool (chest heaving, mouth open); a boxer who lost the round looks down; one who won
nods along. After a stoppage there is no corner: the winner celebrates, the loser's corner comes in to her.

### Film look for the intro and the corner minute
- Letterbox bars (2.39:1) while the scene plays; they open back to the full broadcast frame at the bell.
- Shallow depth of field on the close shots; slow camera drift on every shot (nothing locked off); cuts on the action
  (she sits, the coach speaks, the bottle goes up).
- The crowd stays in focus only on the wide shots.

## What it needs (in build order)
1. Clips on our bodies: walk, walk carrying (the stool), sit down / sit / stand up, crouch, talk, hand-over (bottle, ice),
   nod - all from ActionForge (Quaternius library, CC0 public domain), baked onto the MetaHuman rig.
2. The corner bodies: the old project's MetaHuman coach, cutman and trainer copied into this game.
3. Props: stool, water bottle, spit bucket, ice pack, towel, the cutman's iron (simple models first).
4. Free walking: the boxers stop facing each other between rounds, walk to their corner, turn and sit.
5. The hands meet what they reach: bottle to her mouth, ice to her neck, the cutman's hand to her cheek (the same reach as
   the punches use).
6. The scene director: the shot list above as data, the letterbox and focus, the corner card on the 0:08 shot.
7. The intro.

## Honest limits of the first version
- No mocap of climbing through the ropes exists in our libraries: the second reaches through the ropes from the apron and
  slides the stool in; the coach steps in with a crouch. It will read right from the camera angles above, not in a close-up
  of the feet on the rope.
- The faces do not move (no lip sync, no expressions): the shots keep faces at three-quarter or over the shoulder, never a
  long straight-on close-up while someone talks.
- Sound (announcer, crowd, coach's voice) comes later.

## Acceptance
A film of one 3-round fight on the game camera: the intro once; each corner minute in real time with the corner card on
the 0:08 shot; stool in through the ropes; hips on the seat (a still of each corner); bottle at her mouth; nobody walks
through the ropes or a post; no foot sliding on the walks (tools/sidestep_probe.gd numbers). Then your eye.
