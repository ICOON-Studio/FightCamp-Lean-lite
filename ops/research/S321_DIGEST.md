# S321 digest - the body as the track (design), Lean update 24 (2026-10-31)

Working commit: Lean 04110fe (pushed; reach fixes 34ecaee + 0fb54ed). 37/37 Lean tests. Update 24 exported; the exe runs the
fix (hit_gap_probe inside the exe: inside 0 of 13 far, all shown hits 4 % over 15 cm). Game repo f45f358b.
Board: Q-S294-36 (corner ice, superseded by 38), Q-S294-37 (ecorche buy: answered "Not yet" in chat), Q-S294-38 (core
mechanic "the body is the track"), Q-S294-39 (update 24). Review page S321 (anatomy previews, mockup, C148 before/after).

## Operator input this session (verbatim)
- Board: Q-S294-32 "Not yet (say what)"; Q-S294-33 "needs fine tuning i think"; Q-S294-34 "Build 1-3 now"; Q-S294-35 "Pages
  need work". C147 "wtf is this?" (old block figure's rib dots - superseded by update 23's real body); C148 "clipping ?".
- "the blood on the human on the side panel is animated and flowing the player selects where to ice in order to calm the
  fighter and gain condition ... can this become part of the game ? does it make sense and will it be fun for the player ?"
- "can you make a high quality movie-like relaistic human musclesceleton or should i go buy?"
- "make some previews and ask from others i know we have done prior again but nothing was good enough"
- "this is not what i described today, can you highlight the muscle part eg right biscep (what flows on the muscle that the
  corner should counteract ) it should be easy for you to make a lot of documentaries to techniques like that"
- "use outliners for each part on the body maybe ?"
- "yes but make it in a pc game sense , something that can be a core mechanice for the game ... like see the body as the
  track on MSM" (MSM = a racing manager: watch the track, manage tyres/fuel, call the pit stop)
- Pinterest reference: colour-coded muscle figure, each muscle its own shape (ref_muscle_colours_operator.jpg).
- Video link (Pinterest HLS): a fitness ad, "Day 1 -> Day 21" abs + 12 seated exercises x 30 s. "what do you need to make an
  anatomy model to be good enough for the game ?"
- Q-S294-37 (buy the anatomy models): "Not yet".

## Design (waits on Q-S294-38)
- research/BODY_TRACK_PLAN_S321.md: both bodies on screen, every part outlined; Burn (colour, partial refill each
  rest - J68: 55-65 % of fast fuel in 60 s), Tank (whole fight), Hurt (red outline). Shoulders burning = guard drops;
  legs = caught on the ropes; ribs hurt = slower recovery. Decisions: Pace Push/Steady/Save, Aim (tap her body), the
  corner as the pit stop (second works one part, cutman one hurt place, coach 1-2 instructions). Gym training lowers each
  part's Burn rate - the management and fight halves become one loop. Mockup: previews/s321/body_track_mockup.png.
- Real-world check: ice does NOT refill stamina (J68: no HR gain in 60 s; perceptual only); ice slows a swelling; pressure +
  adrenaline 1:1000 closes a cut (J55). Neck ice = composure, never condition.
- Look: the operator's colour-coded muscle reference, coloured by state. Needs a bought model with every muscle a SEPARATE
  mesh (ECORCHE_BUY_S321.md: $35 CGTrader female sculpted anatomy lists muscle groups; spec: 30-60 pieces, rigged to the
  MetaHuman skeleton by Claude in Blender 5.2, 20-40k tris, 2K, definition shape keys for training). He said "Not yet".
- Previews made: Ludo image generator x6 (dropped muscles/blood every time; x-ray retry had no ribs) - AI images cannot do
  anatomy. Our own glass x-ray body from the MetaHuman mesh works (Lean tools/preview_xray_figure.gd, preview_muscle_flow.gd,
  preview_body_track.gd: per-part outlined ellipsoids, tyre-temperature palette). fal: no FAL_KEY on this PC.
- Maria (SQ22, look of the figure) and Kalli (SQ23, is the corner ice choice fun) queued via seat_queue.

## Fixes (evidence: tools/hit_gap_probe.gd, 150 s of round 1, glove front to the landing point at the hit)
1. INSIDE PUNCHES SHORT (C148). Cause: Gloves.WRIST_STRAIGHT (S316) lays the glove 85 % along the forearm; PunchReach aimed
   along the bare hand, and its single solve turned the forearm under it. Fix: the same axis, 4 solve passes for the
   full-weight wrist, then eased by weight; ElbowClear fades out on the landing arm. Inside > 15 cm: 10/13 -> 0/13 (max
   0.24 -> 0.13 m). Control arms: `onepass`, `elbowsalways`, `bentwrist` (bentwrist alone also lands - it proved the cause).
   Disproved on the way (measured, reverted): the head clearance lean (`noheads` changed nothing); hit timing vs hit-stop.
2. HITS WITHOUT A PUNCH. FightStage.play numbers starts (play_id) and returns false when refused (hit-locked); the hit
   carries its punch's id; PunchRange.cut_off drops it if the punch never started or was replaced (a same-name restart
   fooled the name check). land() arms the reach at the beat's own contact (body hook 0.70 s, not 0.27 s).
   All shown hits > 15 cm: 54 % -> 8 % (editor), 4 % (exe). Stills: tools/contact_stills.gd at inside contacts (jab2_zoom.jpg).

## Traps
- `rtk grep` mangles grep flags (prints its own help): use `rtk proxy grep` for exact evidence lines.
- Reading a bone outside the modifier stack gives the pre-modifier pose (GloveClear note) - the glove nodes follow on
  skeleton_updated, so a modifier must aim with the SAME axis the glove uses, after every later modifier that moves the arm.
- A `--check-only` on one script does not catch a duplicate local in another function body: load it through a test
  (fight_feel_test loads FightStage) before a long probe.
- FightStage.gd is at 500 lines (Lean's limit): split it before the next feature lands there.

## Seat answers (collected 10:40, read)
- Kalli (K_CORNER_ICE_S321_KALLI.md): keep the plan with 3 changes - the corner works itself by default (the coach/cutman
  auto-picks the worst problem, "Coach iced the left eye."); the player taps ONLY when two problems compete for one pair of
  hands, and the tap is "what to leave untreated"; show the cost next round in words and 3D. Neck ice only when composure is
  low AND no wound needs the hands (else a free buff). Real choices ~1 corner in 4 in a hard fight (NOT COMPUTED). Fold into
  BODY_TRACK when Q-S294-38 is answered.
- Maria (M_ANATOMY_FIGURE_S321_MARIA.md): "skin first, muscle on damage" - her own skin, muscle shows only where hurt, from a
  bought ecorche rendered in Blender as layered PNGs per build. FLAG: running blood clashes with the accepted 2026-09-22 ruling
  (blood only at the doctor/stoppage class, never per punch) - the body-track plan needs no running blood; the operator must
  reopen that ruling before any blood animation.

## Left / next
- One step-in jab at a 0.95 m gap fires 0.26 s after its contact (clip at speed 1.67) - find who sets that speed.
- Referee drifts between the boxers in rest spells (Referee.gd keep-clear).
- Q-S294-35 "Pages need work" - no detail given; ask what (taste) with the round/result stills attached.
- Q-S294-38: on "Build it" - BodyLoad rules first (pure, Qwen/Arena), then guard/steps from Burn, then the body view.
- Split FightStage.gd (500 lines).
- Baked side-panel portraits show jagged vest shards at the armpits (bake_body_portraits rest pose) - fix with the next bake.
