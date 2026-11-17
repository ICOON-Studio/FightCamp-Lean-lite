# FIGHTPLAYER2 phase 1: the clip census (S512, 2026-11-17)

Every owned fight take measured AS BOUGHT on our body: its own hip travel kept, the untouched bake (no retime), every
fight layer off. Table: `assets/data/clip_db.json` (183 takes, 94 of them played by today's fight). Tool:
`tools/clip_census.gd` (headless, ~20 s). Rules (which takes play, families, drop bars): `scripts/fight3d/v2/ClipCensus.gd`.
Test: `tests/clip_db_test.gd` (every Punch PRO file on disk has a row, every played take has a row, the drop lists are
the rules'; it goes red when a pool or a bar changes without a re-run). Tables below: `python tools/clip_census_report.py`.
Nothing the shipped fight plays changed: `FightClips.as_bought` is off by default (the control arm).

## What it says, in plain words
1. **Every punch we own lands from close.** Pelvis to pelvis at contact: jabs 0.59-1.03 m, crosses 0.53-1.02 m, hooks
   0.76-0.90 m, uppercuts 0.53-0.86 m. Nothing we own lands from 1.2 m or more. This agrees with two older measures
   made another way (`RangeTable.gd`: straights 0.91-1.11 m, uppercuts 0.61-0.70 m).
2. **We own no real stepping punch.** The takes named `_FT` carry the body 2-7 cm at contact, like the plain ones
   (jab +7, jab_ft +6, cross_ft +2). Only three takes travel: the kidney shot (+52 cm), the hard stepping rear hook
   (+20 cm) and the rear uppercut (+10 to +18 cm). So in v2 the FEET must close the distance before a punch (a step the
   viewer can count, from the 1.6 m rest to about 0.9 m), until stepping takes are bought. Both scope critics put
   stepping punches in their top two rows to buy; the census agrees.
3. **The bought hooks and uppercuts are thrown from a crouch and pass under an upright man's chin.** The puncher's own
   head drops 9-14 cm during a hook; the glove travels at his own chin height, which is the neck or shoulder of a man
   standing in the bought guard. Lead hook: the plain take passes 17 cm under the head (dropped); `v2` and `hard_ft`
   land. Rear hook: four of five land 9-11 cm low, only `hard_ft` is on the head. This is the old "lead hook from the
   hip" defect, and it is in the clip. Today the reach layer lifts the arm to hide it. In v2 it needs one of: the hit
   man in a lower guard, a small lift on hooks, or better takes (a row for the buy list).
4. **Light reactions exist; the jab-named ones are the bad ones.** 13 light reactions may play (head travel 7-14 cm),
   8 medium (21-28 cm), 5 heavy (32-59 cm): enough to order jab < cross < hook as the critics ask. But 7 of the 10
   takes recorded for a jab tip the face up 27-51 degrees (the "face to the lights" the coach flagged) and are dropped.
   The scope's gap row "few light ones" becomes: enough light ones, few that go straight BACK without tipping the face.
5. **The gut-shot reactions carry real travel**: 34-50 cm backwards. Pinned today (10 cm). They are ready for v2 as
   whole-body reactions.
6. **The dodges are real slips with a step**: 60-70 cm sideways, the chest never turns more than 40 degrees from the
   other man. The older note that they "turn the back" is not what the numbers show.
7. **One block flinch may play today**: `block_straight_hit_v2` (the head rocks 10 cm). The other two put a glove over
   the crown for 17-23 frames (dropped).
8. **The hand comes home late in every take**: 0.30-0.70 s after contact for straights, 0.47-1.40 s for hooks
   (Undisputed hands control back at 0.11-0.17 s). v2 cuts to the next action; it never waits for the tail.
9. **The jab's tail is back**: v2 loads the bought 1.07 s jab; the shipped player keeps its 0.84 s retime.
10. **59 Punch PRO punch takes** in all (two of them combinations): 19 are switched off on score (16 of those pass
    the census's own bars), 2 more cannot land (the plain lead hook and its tired take), 38 may play.

## How each number is measured
- The frame: the thrower as the stage puts him, facing the other man; everything from his hips on the take's first frame.
  The other man is the staged defender on the first frame of the guard (face point at eye height 1.57 m, chin 17 cm lower).
- **Contact gap** (a punch): how deep the glove front gets while it is on the other man's line sideways, carried to his
  face (ribs for a body shot). For a hook or an uppercut: at the frame it is nearest the target's height. For a straight:
  its deepest frame (the arm IK finishes the height).
- **Miss**: how far outside the head (chin to brow, half a head wide) or the trunk the glove is then. Over 15 cm (a
  straight: over 30 cm, the IK budget) = dropped. 6-15 cm = flagged "lands low / high".
- **Hips travel**: how far the hips move across the canvas inside the take. **Hand home**: from contact until the
  punching hand is back within 8 cm of where it started, over the hips.
- **Reaction size**: the head's furthest point from where it started, with the body's travel. Light up to 15 cm, medium
  up to 30, heavy above.
- **Posture flags**: face tipped up more than 15 degrees from the take's first frame; a hand 10 cm over the head bone for
  3 frames or more; the pelvis turned more than 100 degrees from the other man. They DROP a reaction, a block, a defence
  or an idle; on a punch they are kept as flags for the eye check (an uppercut lifts the chin by its nature).
- NOT yet checked by eye: the 15 degree face bar may be too strict for a straight-back snap. Phase 4 looks at stills of
  the dropped reactions before the pools are final.

### Punches that may play (pro_ takes; gap = pelvis to pelvis at contact, m)
| punch | takes that may play | their contact gaps | gap range | hips travel at contact (cm) | hand home after contact (s) |
|---|---|---|---|---|---|
| jab | 8 | hurt 0.59, hurt_ft 0.78, a 0.86, c 0.87, ft 0.89, b 0.92, hard 0.96, plain 1.03 | 0.59-1.03 | +4, +4, +2, +0, +6, +4, +4, +7 | 0.30-0.70 |
| cross | 8 | hurt 0.53, c 0.64, hurt_ft 0.83, b 0.86, a 0.90, ft 0.97, hard_ft 1.00, plain 1.02 | 0.53-1.02 | +1, +3, -0, +0, -0, +2, +6, +3 | 0.32-0.60 |
| lead_hook | 5 | v2 0.76, hurt_ft 0.77*, hard_ft 0.79, ft 0.81*, hard 0.87* | 0.76-0.87 | +6, +3, +6, +3, +11 | 0.47-1.03 |
| rear_hook | 5 | ft 0.80*, miss 0.81*, hard 0.89*, plain 0.89*, hard_ft 0.90* | 0.80-0.90 | +11, +15, +5, +11, +20 | 0.83-1.40 |
| lead_uppercut | 5 | hard_ft 0.53*, plain 0.66*, hurt_ft 0.76*, hurt 0.81, hard 0.86* | 0.53-0.86 | -4, +7, +2, +0, +4 | 0.52-0.75 |
| rear_uppercut | 3 | plain 0.69*, hurt_ft 0.70*, hurt 0.82* | 0.69-0.82 | +10, +18, +2 | 0.42-0.52 |
| body_hook | 2 | plain 0.71, plain 1.27 | 0.71-1.27 | -4, +52 | 0.53-0.88 |

(* = a posture flag for the eye check: lands low / face tips up / glove over the crown / pelvis turned.)

### Reactions by size (head travel with the body's own travel)
| size | takes that may play | dropped |
|---|---|---|
| light | 13: combo_v1 14 cm, cross_v1 10 cm, cross_v1_short 12 cm, cross_v2 7 cm, cross_v2_short 7 cm, gutshot_v1 7 cm, gutshot_v1_short 7 cm, hook_v1 12 cm, hook_v1_short 12 cm, hook_v2 11 cm, hook_v2_short 14 cm, jab_v1 14 cm, jab_v3 9 cm | 7: combo_v1_short (face tips up 24 deg), jab_v2 (face tips up 34 deg), jab_v2_short (face tips up 27 deg), jab_v4 (face tips up 51 deg), jab_v4_short (face tips up 41 deg), jab_v5 (face tips up 35 deg), jab_v5_short (face tips up 32 deg) |
| medium | 8: combo_v2_short 25 cm (hips 19), gutshot_v2 28 cm (hips 50), gutshot_v2_short 26 cm (hips 46), gutshot_v3 23 cm (hips 34), hook_v3 22 cm, hook_v5 23 cm, hook_v6 21 cm, hook_v6_short 22 cm | 3: combo_v2 (face tips up 20 deg), hook_v3_short (face tips up 16 deg), jab_v1_short (face tips up 17 deg) |
| heavy | 5: hook_v7 57 cm (hips 18), hook_v7_short 59 cm (hips 20), hook_v8 48 cm, hook_v8_short 48 cm, kidneyshot_v1 32 cm (hips 27) | 3: cross_v3 (face tips up 29 deg), cross_v4 (face tips up 29 deg), uppercut_v1 (face tips up 49 deg; glove over the crown 11 frames) |

### Defence and blocks
| take | head travel (cm) | hips travel (cm) | direction (back, his left, up) | verdict |
|---|---|---|---|---|
| pro_back_dodge | 54 | 51 | [0.97, -0.16, -0.18] | may play |
| pro_back_weave | 35 | 9 | [0.91, 0.0, -0.42] | face tips up 27 deg |
| pro_block_loop | 5 | 5 | [0.23, -0.96, -0.14] | may play |
| pro_block_straight_hit_v1 | 21 | 18 | [0.95, 0.3, 0.0] | glove over the crown 17 frames |
| pro_block_straight_hit_v2 | 10 | 5 | [0.99, -0.17, 0.0] | may play |
| pro_block_straight_hit_v3 | 30 | 20 | [0.99, -0.04, -0.12] | glove over the crown 23 frames |
| pro_block_to_idle | 6 | 1 | [0.98, -0.03, 0.2] | face tips up 22 deg |
| pro_idle_to_block | 6 | 1 | [-0.92, -0.01, -0.39] | may play |
| pro_left_dodge | 69 | 62 | [-0.12, 0.97, -0.23] | may play |
| pro_left_weave | 40 | 9 | [-0.26, 0.88, -0.41] | may play |
| pro_quick_weave | 32 | 12 | [0.61, -0.76, -0.24] | may play |
| pro_right_dodge | 70 | 60 | [0.02, -0.94, -0.33] | may play |
| pro_right_weave | 40 | 12 | [0.31, -0.79, -0.54] | may play |

### Played today, dropped by the census
- pro_hit_by_combo_v1_short: face tips up 24 deg
- pro_hit_by_hook_v3_short: face tips up 16 deg
- pro_hit_by_jab_v4_short: face tips up 41 deg
- pro_hit_by_jab_v5_short: face tips up 32 deg
- pro_hit_by_uppercut_v1: face tips up 49 deg; glove over the crown 11 frames
- pro_left_hook: cannot land: the glove passes 17 cm outside the head (34 cm under the aim point)
- pro_left_hook_hurt: cannot land: the glove passes 22 cm outside the head (39 cm under the aim point)

### Played today, flagged for the eye check
- pro_left_hook_ft: back to the other man (pelvis 104 deg)
- pro_left_hook_hard: lands low: 9 cm outside the head
- pro_left_hook_hurt_ft: back to the other man (pelvis 104 deg); lands low: 15 cm outside the head
- pro_left_uppercut: face tips up 30 deg; glove over the crown 15 frames; back to the other man (pelvis 133 deg)
- pro_left_uppercut_hard: face tips up 29 deg
- pro_left_uppercut_hard_ft: face tips up 31 deg; lands low: 10 cm outside the head
- pro_left_uppercut_hurt_ft: face tips up 40 deg
- pro_right_hook: lands low: 9 cm outside the head
- pro_right_hook_ft: lands low: 10 cm outside the head
- pro_right_hook_hard: lands low: 11 cm outside the head
- pro_right_hook_hard_ft: face tips up 22 deg
- pro_right_hook_miss: lands low: 10 cm outside the head
- pro_right_uppercut: face tips up 38 deg
- pro_right_uppercut_hurt: face tips up 23 deg
- pro_right_uppercut_hurt_ft: face tips up 45 deg; glove over the crown 9 frames; lands high: 9 cm outside the head

Totals: 183 takes measured, 94 played today, 48 dropped (block 4/10, defence 3/11, idle 1/20, knockdown 0/13, other 0/1, punch 23/70, reaction 17/45, step 0/5, win 0/8).

## What changes in the plan
- Phase 2 (the choreographer) plans a visible step-in before every punch thrown from rest distance; no owned take
  reaches from there.
- Phase 3: hooks need a decision on height (lower guard for the hit man, a small lift, or only the takes that land).
- Phase 4: the reaction pools come from the table by size and direction; the jab pool loses its face-up takes.
- The buy list (scope section 4), in this order: stepping punches; hooks at head height; straight-back light reactions;
  longer uppercuts.
