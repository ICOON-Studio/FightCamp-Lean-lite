# POWER1 step 2 - the hit lands while the glove is moving (review round 1)

Written last, from the final runs on branch claude/power1 (code commit d258cab0, main 9cecef87 merged in). The 3D fight
still decides nothing: no file under scripts/rules or scripts/state changed.

## What the blind review found, and what was wrong underneath

The reviewer saw a landed jab's glove "pop" 8-17 cm within two frames of the hit in the played fight. A new ruler that
plays the punch the way the fight does (tests/hit_carry_test.gd, below) found three causes:

1. **The jab's glove had already gone past her face before the hit fired.** The fight aims at her face as the stage
   SHOWS it (her head leans 18-20 cm forward of the raw head bone in her guard). clip_contact.gd measured against the
   raw head bone, so the plain jab's contact (0.367 s) came 60-100 ms after its glove had passed 9 cm beyond her face
   (beside her head). PunchReach then dragged it back onto the face and "carried" it backwards.
2. **The carry ran in one frame.** It lasted 2 x 8 cm / speed = 14-32 ms of clip time; after the hit-stop the clip
   also sped up 2-3x (the fast way back started at the new, earlier contact), so all 8-10 cm came in one frame.
3. **The way back went out, back and out again.** The release followed the clip's glove, which is still travelling
   out there, and settle() (GloveClear) re-aimed at the carry's end with a different weight.

## The fixes

- **Contact rule (tools/clip_contact.gd), stated plainly:** the stage first settles a second with both guards held,
  so her face is the face the fight aims at; the glove front includes the hips' own forward travel (PunchWeight). From
  the frame the glove first moves at half its top speed (top speed = plain glove speed, not speed "toward her": most
  clips pass her face 10-50 cm to the side, so that number stayed tiny), contact is the first frame the glove front is
  within 5 cm of her face point, or - a jab or a cross - level with her face (as deep as her face along the
  thrower's front, any side: the reach covers the side); otherwise the nearest the glove comes in its drive (hooks,
  uppercuts, short gloves). The old "shoulder within arm's reach" test is gone (review, low finding). A 0 contact or 0
  travel still fails the run. Tables regenerated: contact, recovery, travel three passes (the stage gap reads the jab's
  row), then punch_form.json. Contact times are a fixed point; reach_m moves by 1 mm between runs (her settled face
  differs by 2 mm).
- **PunchReach:** the carry eases out over 0.10 s of clip time (first frame at most ~4 cm at 1.7x) and the reach holds
  full weight to its end; the carry starts from where the glove IS on the hit frame; the hit frame is taken up to
  0.011 s before contact (HitImpact leaves the clip there); on the way back the glove never goes further along the
  punch line than it already is; settle() lands on the exact point and weight the frame's solve used; a disarm fades
  from there; the top-speed reading ignores the hit's seek. The line and the start are taken from the last solve of
  the drawn frame (HitImpact's hand-run solve on the bare pose no longer sets them).
- **BeatClips.recovery:** the fast way back starts at far_s again (as before the hit moved earlier).
- **tests/hit_frame_test.gd** (the step's own ruler) now stages like the game: her shown face, the hips' travel
  (PunchWeight) and the stack's settle() each frame. Bars unchanged.
- **tools/hit_frame_film.gd:** `seed=<n>` - the same career, bout and exchanges on every run.

## Numbers (final runs)

**tests/hit_carry_test.gd** (new; the whole stage running, glove front as drawn, 60 fps, mh_boxer_12 v 07; 37 punches;
bars: arrives >= 50 % of top speed, within 0.05 m of her face, carries 0.05-0.11 m, never more than 0.06 m in one
frame while carrying, at most one change of direction):
- On a7b785d3 (the reviewed code): `HIT_CARRY failures=64`. Plain jab: glove 9 cm past her face plane 67 ms before
  the hit; after the hit-stop 9.5 cm in one frame, then 11 cm, back 4 cm, back 3 cm (`biggest carry step 0.095`).
- Now: `HIT_CARRY failures=36`, carry median 0.080 m. Jabs and crosses: 14 of 16 clean, e.g.
  `pro_right_cross ... on her 0.001 m, carry 0.080 m, biggest carry step 0.024 m, turns 1`,
  `pro_left_jab_hard ... carry 0.078 m, step 0.031 m, turns 1`. Uppercuts 6 of 8 clean, kidney shot clean.
- STILL FAILING (reported, not fitted): most hooks (left_hook_v2, _ft, _hurt_ft, _hard, _hard_ft, right_hook_ft,
  _hard, _hard_ft: the glove runs 0.13-0.7 m on round her head, 3-5 turns - the reach's line for a hook is its
  sideways arrival, and the solve cannot hold it there); pro_left_uppercut (carry 0.34 m, the range problem of
  UPPERCUT_RANGE_S439); pro_right_cross_hurt and pro_right_uppercut_hurt (her previous reaction still moving);
  pro_body_shot (arrives at 24 %). The plain jab passed in four runs and failed in the last one (`on the hit frame
  33%, carry 0.000`): the ruler runs in real time and the PC was RED most of the session; it is timing-sensitive.
- **tests/hit_frame_test.gd:** `HIT_FRAME failures=12` (share at contact lowest 0.50, median 0.91). All 12 are hooks'
  THROUGH (carry 0-0.04 m) plus pro_left_jab_a (0.047) and pro_left_jab_hard (0.016) and kidney SPEED at exactly
  50 %. The two plain uppercuts that kept the step red now PASS (her shown face is 18-20 cm nearer than the raw head
  bone the test used). So the step's own test is still red, on hooks.

## Films (same seed 4242, the same exchanges; main 9cecef87 before, this branch after)

Frames and sheets in the scratchpad p2 folder (film_before3/, film_after3/, before_01_jab.png, after_01_jab.png,
before_00_cross.png, after_00_cross.png). Exchange 01, pro_left_jab, t = 16 s:
- before: 5.5, 3.9, 2.4 m/s into the hit, 0.3 on the hit frame (it lands as it stops); rests on her face 5 frames.
- after: 4.1, 4.5, 4.8 m/s into the hit, 0.012 m from her face; the hit-stop; then 1.2, 1.6, 1.1, 0.7, 0.2 m/s
  through her - 7 cm on - and home. No jump: no frame after the hit moves more than 5.2 m/s (8.7 cm) until it is on
  its way back.
- Exchange 00 (pro_right_cross_b, close in): both films show single frames of 11-42 m/s around the hit: they are in
  main too (before: 11.3, 12.1, 41.7 m/s), so not from this step. Not chased (camera behind the pair, heads overlapping).

## Other tests (run one at a time after the code commit)

- PASS: beat_clips `BEATCLIPS failures=0`, head_aim `HEAD_AIM failures=0`, fight_feel `FIGHT_FEEL failures=0`,
  punch_weight `PUNCH_WEIGHT_TEST failures=0`, beat_tally `BEAT_TALLY_TEST failures=0`, jab_retime
  `JAB_RETIME failures=0`, short_punch `SHORT_PUNCH failures=0`, punch_form `PUNCH_FORM failures=0` (after
  punch_form.gd was re-run last; jab_c stays STILL FAULTY by R12).
- guard_knee `GUARD_KNEE failures=2` - red on main already (rear knee -0.069 / -0.067 v 0.029); not this step.
- **block_meet `BLOCK_MEET failures=11` - this step MOVED it red** (green at a7b785d3). All 11 are the LANDED control
  row (the ruler's own check that a landed punch reads <= 0.021 m from her face): the landed glove now reads 0.068-0.230
  m from her face (contact-frame read 0.094-0.256). Likely cause, not proven: the new contact times (earlier for most
  takes) put the paused contact-frame read and the 30 fps reads in the carry, or before the glove reaches her, on this
  ruler's pairs. Not fitted; next round.
- Not run this session (the PC was RED for most of it): sound_sync, ring_feet, boxer_footwork, cam_line,
  knockdown_still, rokoko_clips.

## Not done (for the lead)

- Hooks: the carry along a hook's arrival line does not hold; a hook needs its own carry (round her head, not along a
  line) - next round.
- block_meet: BLOCK_SURFACE_M still equals the ruler's 4 cm. The glove mesh measures 0.073 m from its axis (median of
  its fist vertices), but the block target is the blocking WRIST, not the fist's centre, and the ruler reads to the
  wrist too, so taking the mesh number alone would move the reading, not the truth. Needs the lead: move the target
  and the ruler to the fist centre together.
- The control-row change in block_meet (a paused read on the contact frame) still needs the lead's word.
