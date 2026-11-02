# S333 digest (2026-11-01) - update 35: whiteboard look, THE READ, blended faces

## His answers acted on
- Q-S294-52 "B Gym whiteboard": built. Q-S294-54 fonts: in (S332). Q-S294-47 "Right", Q-S294-51 "Yes, soon enough": kept.
- Q-S294-53 "Still off - I'll mark it": waiting for his marks.
- "make them all hotter": Erin, Dana and a new Sophie built as face blends.
- THE READ (S332 "Yes, build it", "make it look as good and how UFC would make it"): built.

## Done (Lean)
- adc37a8: UI.gd = whiteboard palette (wall #CFE0EA, board white, marker blue primary, red/green/amber, yellow stickies),
  marker/hand fonts; HomeBoard.gd = the coach's board (polaroid crop of her baked portrait, marker notes, week columns with
  magnets, sticky-note needs, cash tin). TV.gd keeps the old dark palette for every graphic over the 3D fight.
- 391c550 + effa1fe: TheRead.gd (pure) + LiveRound wiring: read meter per opponent habit (press/range/counter/loadup),
  looks needed from Ring IQ (5 at IQ 85 = Milazzo 2016, 16 at 40), film study x0.8 and a 0.2 head start on her main game;
  trigger from discipline vs temper+confidence (patient/steady/gambler); WAIT FOR IT / TAKE IT NOW; lands on read x
  (0.5 + 0.5 mastery); punished twice the opponent drops the habit. ReadPanel.gd = the broadcast slab on the shout bar and
  fight night; ExchangeBeats plays her habit + the counter ("READ IT!" close-up).
- 7ec2980: faces. Tools/metahuman/mh2_build.py face_blend (weighted face-model coefficients, set + commit_face_state).
  Erin = Celeste .4 Jelena .35 Aera .25; Dana = Tuya .5 Aera .3 Celeste .2; Sophie (18, new) = Celeste .45 Aera .3 Jelena .25
  on Jelena. Faces.CAST Sophie -> mh_boxer_18.
- Update 35 exported, export.sh 53/53.

## Found
- Blending moves only the face SHAPE; the skin is the base preset's. Grace's skin is old: Sophie came out aged (caught
  in the lineup, rebuilt on Jelena). Pick a young base preset.
- UE hung at "Waiting for skinned assets (MH_Groom_Head)" under memory pressure: the groom head export is now skipped
  when it exists (mh2_build.py).
- Balance: THE READ first swamped the corner's tools (habit fix +0.02 vs bound 0.03; set-up +0.01 vs 0.02). Measured
  with it off (fix +0.05, set-up +0.05). Fixed by design, not by loosening gates: one counter per habit a round, edge 7,
  no head damage; no counter while her own unfixed habit is punished or a set-up is armed for the gap; a set-up fired on
  a read habit carries the read's edge. Now fix +0.04, set-up +0.02, base 0.72 -> 0.76 with film study.

## Not verified
- THE READ's "READ IT" beat not seen on camera yet (still shows the panel only). Look B on GYM/MONEY/FIGHTS/WORLD seen only
  through the palette (fighter page still opened, others not). Miro map not updated this session.

## Next (S334)
Board Q-S294-55/56/57; the cloud animation pipeline he asked for (fight-stills CI on Lean + measurable briefs to
Goose/Arena); Q-S294-53 after his marks; look B polish per page.
