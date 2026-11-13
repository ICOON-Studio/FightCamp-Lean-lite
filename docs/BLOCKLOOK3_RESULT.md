# BLOCKLOOK3 result (Grok Dev)

Owner marks 1-4 on a blocked punch: the blocked arm folded short onto the glove (1-3), and the front sank into the
catching glove (4). Plus the absorb: a blocked punch should knock the catching glove back and give the head and trunk.

## What shipped
- `scripts/fight3d/BlockCatch.gd` (315 lines): the ABSORB. On contact the catching glove is knocked back along her facing
  (KNOCK_M by punch kind, jab 2.5 cm to cross 3.4 cm) on HitSnap's envelope, never closer than FACE_KEEP_M 0.09 m to her
  face; her head gets a small HitSnap.snap (HEAD_DEG 3-4 deg); a blocked body hook's elbow brace (HitSnap.brace, called
  by BeatFire) gives her Spine/Chest back BRACE_GIVE_DEG 9 deg on the give envelope. `give_left()` reports what is left.
- `scripts/fight3d/FightStage.gd` arm_block (476 lines): BLOCK_SURFACE_M 0.04 -> 0.045, so the front stops just outside
  the glove (mark 4); the body is the same logic written compactly.
- `tests/block_absorb_test.gd` (new) and `tests/block_catch_test.gd` (GAP + MATCH rulers).

## Final runs (branch)
```
BLOCK_ABSORB failures=0
BLOCK_CATCH failures=9
BLOCK_CATCH failures=9
BLOCK_SET failures=0
BLOCK_MEET failures=10
HIT_CARRY failures=49
BEATCLIPS failures=0
FILE_LIMITS failures=0
```
Main with the same tests: BLOCK_ABSORB 12, BLOCK_CATCH 8-10 (MEETS B_A pro_left_hook flakes on main: to_face 0.048 one run,
0.187 the next), BLOCK_SET 0, BLOCK_MEET 10 (all CTRL_LANDED), HIT_CARRY 49, BEATCLIPS 0.
Branch BLOCK_MEET failures are the same 10 CTRL_LANDED rows as main. HIT_CARRY is landed-only and its failing set moves run
to run on both trees; the count is the same.

## ABSORB (branch; bars glove 0.03-0.06, head 0.01-0.03, to_face >= 0.08, back <= 0.5 s, body torso 0.01-0.03)
| row | glove_back | head_back | to_face_min | back_in_guard_by | torso_give |
|---|---|---|---|---|---|
| A_B jab | 0.035 | 0.016 | 0.110 | 0.38 | 0.013 |
| A_B cross | 0.052 | 0.027 | 0.103 | 0.42 | 0.022 |
| A_B lead hook | 0.045 | 0.024 | 0.136 | 0.42 | 0.018 |
| A_B rear hook | 0.048 | 0.024 | 0.105 | 0.43 | 0.017 |
| A_B body shot | - | - | - | 0.35 | 0.018 |
| B_A jab | 0.035 | 0.016 | 0.110 | 0.38 | 0.012 |
| B_A cross | 0.043 | 0.015 | 0.103 | 0.42 | 0.011 |
| B_A lead hook | 0.037 | 0.015 | 0.090 | 0.42 | 0.011 |
| B_A rear hook | 0.046 | 0.022 | 0.113 | 0.43 | 0.017 |
| B_A body shot | - | - | - | 0.35 | 0.016 |
SCALE: cross and rear hook glove_back > jab on both sides. Main: glove_back 0.000-0.008, head 0.000-0.010, body torso 0.000.
Close margins: jab glove 0.035 (bar 0.03), B_A cross / lead hook head 0.015, B_A lead hook to_face 0.090 (bar 0.08).

## GAP (mark 4; bar >= -0.005 m at contact)
Branch B_A jab -0.000 at contact, deepest -0.006/-0.007 over the next 0.10 s; main -0.003/-0.005 at contact, deepest
-0.021/-0.030. All 8 rows pass on both; the sink after contact is what the surface move fixes.

## MATCH (marks 1-3; bars reach >= 90% of the landed twin, elbow diff <= 15 deg, chest <= 10 deg, shoulder drop <= 0.04)
LEFT RED. Branch numbers (main is within a few % on every row):
| row | reach | elbow diff | chest diff (yaw/pitch) |
|---|---|---|---|
| A_B jab | 69.3% | 68.8 | 12.8 / 27.6 |
| A_B cross | 57.4% | 91.6 | 7.2 / 7.9 |
| A_B lead hook | 74.0% | 30.7 | 5.1 / 9.3 |
| A_B rear hook | 62.7% | 42.4 | 0.6 / 10.3 |
| B_A jab | 61.7% | 63.6 | 18.0 / 35.2 |
| B_A cross | 36.4% | 105.9 | 18.0 / 35.3 |
| B_A lead hook | 73.6% | 31.1 | 3.8 / 9.4 |
| B_A rear hook | 64.6% | 37.2 | 0.1 / 31.9 |

Why: a blocked punch is armed with a carry of 0 (no PunchReach drive, no chest lean, no relunge), so the arm IK folds to
reach a glove 0.12-0.14 m in front of her face. Tried and NOT shipped:
- Arming blocked straights as the landed reach (through_m 1 mm): jab MATCH passed both sides, cross 88% / 71%, but
  block_meet went 10 -> 13 (A_B fight jab TOUCH 0.041, A_B fight cross TOUCH 0.057, A_A preview jab GY -0.091).
- Jab-only thru: block_meet 12; landed controls A_A jab / lead hook after it went to 0.056.
- Hooks with thru: A_B hooks stop 0.15-0.21 m short (PunchReach CORR_M 0.30 cap off a clip glove 0.52 m off her face).
- Lunge / step-in and weight carry on blocked punches: no help or worse.
The landed hook twins do not land either at this stand: front off the face A_B lead 0.670, A_B rear 0.398, B_A lead 0.290.

## Unowned bugs (not fixed)
- PunchReach CORR_M cap / RangeTable clip range: landed hooks from the block stand miss the face by 0.29-0.67 m.
- BeatFire's blocked body punch does not create BlockCatch, so the brace give only shows after a head block has made it
  (a one-line `BlockCatch.on(stage, blocker)` in that branch).
- block_meet runs at 30 Hz and seek-steps the clip, so PunchReach's drive behaves differently there; its 10 CTRL_LANDED rows
  are red on main.
- block_catch MEETS B_A pro_left_hook flakes on main (to_face 0.048 / 0.187) and is red on the branch (0.050-0.057); it is
  not the knock (lead hook knock 0 still gives 0.055).

## VISUAL
Claude films `tools/fight3d_gallery.gd only=block`: the catching glove should snap back about 3.5-5 cm and return within
0.45 s, the head nods 1.5-3 cm, the front sits on the glove, not in it; the body hook shows a small trunk give.
