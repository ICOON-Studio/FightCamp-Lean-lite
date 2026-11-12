# The uppercut's range against an opponent (S439)

Owner: "the uppercut i think it aims too short , check it again an opponent how close the have to be to connect". Measured by one reader, re-measured and challenged by a second (this is the second's corrected version).

## Verdict

You're right: the uppercut is short. I re-measured it with my own script on two new pairs of boxers, and the earlier analysis holds in substance, with some corrections. The plain lead (left) uppercut only brings the glove level with the other boxer's face when the two bodies are 0.61-0.65 m apart, centre to centre (the earlier reader said 0.59-0.60). The plain rear (right) uppercut needs 0.68-0.70 m (earlier: 0.65), and it only gets within 8 cm of the face at 0.75 m or closer. The fight throws them from 0.84-0.97 m, usually 0.92-0.94 m. On their own, the gloves would stop about 0.25-0.30 m short (lead) and 0.20-0.25 m short (rear), almost all of it in depth. The game hides the gap by straightening the arm. In the bout log, 5 of 7 lead and 5 of 7 rear uppercuts land with the elbow at 148 degrees or more. The 165-166 degree reading is exactly the arm-bending code's own limit: it can't straighten an arm further than that, so it is fully locked out, not a separate cap. The animation itself lands with the elbow at 102 degrees (lead) and 131 (rear). So the player sees a long, locked-arm scoop, not a short punch up under the chin. Three causes are confirmed. (1) The plain uppercut animations were recorded very close in, and no punch animation moves the body forward: in every clip I measured, the hips stay put. The lead uppercut is worse than reported: the thrower leans her head 12 cm BACK by the moment of contact. Its follow-through then curls up and back over her own body, peaking at 1.87-1.95 m, 0.35 m above her own head (the earlier "half a metre" is wrong). (2) The fight keeps the bodies at least 0.82-0.84 m apart, a limit added because bodies went through each other. (3) The lead uppercut is not on the list of close-in punches, so outside close-in spells it is thrown from full jab distance. New finding: in close-in spells the game normally trims each punch to its last 15-30 cm. That trimming works from a measured glove path, and the lead uppercut's measured path is broken (it reads 0.0). So the lead uppercut plays its whole long wind-up even chest to chest. A correction on the real world: our research does have rough figures. One inference puts close range at about 0.70-0.90 m, and two critics put hooks and uppercuts at 0.65-0.85 m and 0.7-0.9 m. Neither is measured. So the fight's 0.84-0.94 m sits at the far edge of real inside range, and our plain clips (0.61-0.70 m) are a little closer than real. The fault is the mismatch between the two, not a wildly wrong fight distance. Several uppercut variants already fit the fight's distance with a bent arm. The lead "hurt" take reaches at about 0.88-0.93 m with the elbow at 106-110 degrees, and the switched-off lead stepping take reaches at 0.86 m with the elbow at 112.

## Each punch's true range

My own probe, C:\Users\user\AppData\Local\Temp\claude\0194c5f48bcc79b7\36b2998a-964b-4430-951c-f98b1232a4f8\scratchpad\refute_range.gd. How it differs from the earlier one: both bodies are placed in the world, every arm and body correction on the skeleton is switched off, the glove front is read from the game's real glove, the whole clip is sampled 60 times a second, and four moments of the target's guard are used. The target is the game's face point, 0.09 m in front of and 0.07 m above the head bone, at the clip's own contact time.
Pair 1: mh_boxer_14 (size 1.00) hits mh_boxer_17 (0.97), the game's jab distance 0.946 m.
Pair 2: mh_boxer_20 (1.04) hits mh_boxer_12 (1.00), jab distance 0.981 m.
Columns: LEVEL = the body-to-body distance (centre to centre) at which the glove front comes level with the face at contact, pair 1 / pair 2. OFF = height and side error there. 8CM = the furthest distance at which the glove gets within 8 cm of the face, ±0.25 s around contact (- = never). MISS 0.90 / 0.86 = straight-line miss at those distances, pair 1 / pair 2. ELBOW = elbow angle at contact (180 = straight).
Logs: refute_p1b.out, refute_p2.out, refute_ft.out, all in the same scratchpad folder.

pro_left_uppercut: LEVEL 0.61 / 0.65 (earlier reader 0.59: CONFIRMED within 0.06) | OFF +0.05 up, 0.07 side | 8CM - / 0.70 | MISS 0.27/0.26, 0.24/0.22, almost all of it short | ELBOW 102 (CONFIRMED)
pro_right_uppercut: LEVEL 0.68 / 0.70 (earlier 0.65: slightly WRONG, it reaches 3-5 cm further) | OFF 0.08-0.11 side | 8CM 0.75 / - | MISS 0.23/0.22, 0.19/0.19 | ELBOW 131 (CONFIRMED)
Variants the fight can pick:
pro_left_uppercut_hard: LEVEL 0.88 / 0.92 | ELBOW 164 | MISS at 0.86 0.12/0.12, all side
pro_left_uppercut_hurt: LEVEL 0.88 / 0.92 | 8CM 0.93 / - | ELBOW 106
pro_right_uppercut_hurt: LEVEL 0.87 / 0.91 | 8CM - / 0.95 | ELBOW 123
Switched off (OFF_TAKES):
pro_left_uppercut_ft: LEVEL 0.78 | 8CM 0.86 | ELBOW 112
pro_left_uppercut_hard_ft: LEVEL 0.86 | 8CM 0.89 | ELBOW 156
pro_right_uppercut_ft: LEVEL 0.73, but 0.21 m off to the side
pro_right_uppercut_hard: LEVEL 0.56 | ELBOW 79
Straight punches (all longer than the jab distance):
pro_left_jab: LEVEL 1.05 / 1.09, 0.18 / 0.29 low | MISS 0.09/0.16, 0.07/0.16 | ELBOW 170
pro_left_jab_a: 0.91 / 0.95, 0.13 side
pro_left_jab_b: 0.97 / 1.01
pro_left_jab_c: 0.93 / 0.98, 0.19-0.21 side, never within 8 cm
pro_right_cross: LEVEL 1.07 / 1.11, 0.16 / 0.27 low | ELBOW 164
pro_right_cross_a: 0.98 / 1.02
pro_right_cross_b: 0.93 / 0.97, 0.09-0.11 side
pro_right_cross_c: 0.97 / 1.01, 0.13-0.15 side
Hooks and body punches:
pro_left_hook: LEVEL 1.01 / 1.05, 0.20 / 0.32 low
pro_left_hook_v2: LEVEL 0.76 / 0.80, 0.06-0.17 low and 0.21-0.23 side | ELBOW 122
pro_right_hook: LEVEL 0.86 / 0.90, 0.13-0.24 low and 0.14-0.16 side | ELBOW 113
pro_body_shot (aimed at the ribs): LEVEL 1.07 / 1.12, 0.21-0.27 high
pro_kidney_shot: LEVEL 0.86 / 0.90, 0.23-0.25 side | 8CM - / 0.92
Bodies at the uppercut's own distance: lead uppercut at 0.70 m (pair 2), heads 0.74 m apart and lead toes 0.37 m apart. Rear uppercut at 0.75 m (pair 1), heads 0.70 m and lead toes 0.26 m apart. Nothing goes through anything (CONFIRMED).
Lead uppercut path against the chin (my chin point: 0.05 m below and 0.10 m in front of the head bone), at 0.67 m: at 0.70 s the glove is 0.03 m past the chin and 0.20 m under it; at 0.75 s it is 0.14 m short and 0.31 m above. At the fight's 0.86 m it never comes nearer than about 0.16 m short of the chin.
Lead uppercut peak: glove 1.87 / 1.95 m high at 0.88 s. Her own head is at 1.52 / 1.58 m then, so the glove is 0.35-0.37 m over her own head (earlier "0.4-0.6 m": WRONG, that figure compared against her crouched head at the start of the swing), and it sits 0.01 m in front of her own hips: it comes back over herself. Her head goes from 0.04 m forward of her hips to 0.08 m behind them by contact, a 12 cm lean back.
Rear uppercut: peak 1.56 / 1.63 m at 1.20 s, about her own head height; her head leans 6 cm forward.
Hips: in every clip measured, the stepping takes included, the hips do not move forward at all (z stays at 0.012-0.025 m).
Changing the moment of the target's guard (four moments of pro_idle) moved the results by 0.03 m or less. (rk_guard does not exist on these bodies.)

## In the played fight

Code claims, all opened:
- RangeBreath.gd:63-70 want_m: CONFIRMED.
- INSIDE_M 0.12 at line 23, INSIDE = ["lead_hook", "body_hook", "rear_uppercut"] at line 24: CONFIRMED. lead_uppercut is missing, and so is rear_hook.
- INSIDE_SPELL_M 0.92 at line 34: CONFIRMED.
- RingPlace.gd:16-18 MIN_GAP_M / INSIDE_FLOOR_M 0.84: CONFIRMED. The earlier analysis left out a third limit, BODY_KEEP_M 0.82 at line 23: the bodies as shown on screen are also held 0.82 m apart. Any fix has to move that one too, plus FOLD_ROOM_M 0.22 (line 28) while a boxer folds over a body shot.
- FightStage.gd:139-143 land(): need = shown distance - jab distance, lunge = clamp(need - 0.06, 0, 0.26), carry only when more than 0.03 is left over. CONFIRMED: at or inside the jab distance there is no lunge and no carry, so the arm makes up everything.
- PunchRange.gd:13-14 and 21 (floors 0.96 / 0.86) and 35: CONFIRMED.
- _jab_gap at FightStage.gd:409-417: CONFIRMED. It gave 0.946 and 0.981 m for my two pairs.
- PunchReach.gd:196 and 245: the arm is never allowed past its length minus 4 mm. For these arms (0.274 + 0.249 m and 0.290 + 0.273 m) that is an elbow of 165.8-166.3 degrees. So the 165-166 cluster means the arm is fully locked out. This settles one of the earlier reader's open doubts. Past that, the chest lean takes over (LEAN_MAX 0.30 rad, line 17).

NEW: BeatFire.gd:134-138 trims a punch thrown in a close-in spell so the glove only travels its last 15-30 cm (ShortPunch.gd:10, lead_uppercut 0.20 m). It reads the glove path stored in clip_travel.json. That file holds [[0,0]] for pro_left_uppercut, travel_m 0.0. ShortPunch.skip (ShortPunch.gd:49-55) then returns 0. So in close-in spells the lead uppercut plays its whole 0.73 s wind-up while every other punch is trimmed. The earlier reader called this file "a fault in the travel measurement", and it is (CONFIRMED). Note that the file holds the glove's path relative to the hips, not body travel.

Played-fight numbers: I did not re-run a bout. I re-checked the earlier reader's raw rows in upper_probe.log and upper_probe2.log (bodies mh_boxer_11 against mh_boxer_13, jab distance 0.949):
- Natural bout, one uppercut: rear, 0.91 m, miss 0.030, elbow 84, glove rising 0.24 m over the face. CONFIRMED.
- Lead uppercut, 7 landed: distance median 0.94 (0.84-1.44), elbow median 165 (120-166), PunchReach weight 1.00, five within 0.03 m, one 0.295 m off at 0.92 m (0.25 low, 0.15 short), one 0.257 m off from 1.42 m in the rest phase: all CONFIRMED. "Glove rising 0.19-0.36 m in 4 of 7" is WRONG: it is 5 of 7 (+0.36, +0.35, +0.29, +0.30, +0.19).
- Rear uppercut, 7 landed: median 0.92 (0.84-0.97), elbow median 165 (88-166, five of seven at 148 or more), one 0.18 short. CONFIRMED.
- Cross elbows: the natural bout has a median of 51 (46-72), the altered bout 58-79. "51-79" mixes the two runs.
- Jab, not reported before: the jabs land 0.07-0.10 m off (median), up to 0.27 m.

What the player sees: most uppercuts register as hits, but the arm is locked straight from about 0.92 m. The lead one keeps rising 0.2-0.36 m past the face and comes back over the thrower's own head. Inside a spell it also swings from its full wind-up. About 1 in 7 stops visibly short under the chin.

## Real world

Quotes checked:
- K50_SPACING_AND_REACH.md:29: close range is d < 0.5 x arm length "(infighting / uppercuts)", marked DOCUMENTED. CONFIRMED.
- K50:31 and K50:39: close is about 0.70-0.90 m between the feet midpoints, marked INFERENCE. CONFIRMED.
- G47_PUNCH_REACH_AND_THE_POCKET.md:35: rear uppercut "NOT PUBLISHED". CONFIRMED.
- G47:49: "no metres". CONFIRMED.
- J_INSIDE2_JOHN.md:33: inside punches travel 15-30 cm. CONFIRMED.
- J_INSIDE2:35: elbow about 60-90 degrees, John's own ESTIMATE. CONFIRMED.
- "Elbows glued to the ribs" is at J_INSIDE2:27, not 26 (26 is the heading). WRONG line number only.
- RangeBreath.gd:31-33: a coach's inside range is lead toes 45-55 cm apart. CONFIRMED.
- topics/striking.md has no uppercut line. CONFIRMED.
Missed by the earlier reader: two design opinions in our research, not measurements. CLIPREVIEW1_KALLI.md:57 says "Hook and uppercut range: 0.65-0.85 m". CLIPREVIEW1_MARIA.md:128 says 0.7 to 0.9 m.
So there is still no measured metre figure for a real uppercut. Our own sources agree on roughly 0.65-0.90 m body to body. The fight's 0.84-0.94 m is at the far edge of that, and our plain clips (0.61-0.70 m) are at or just below its near edge. The earlier claim that the clip "is close to the real thing" and the fight "is not" is too strong. The real fault is the 0.2-0.3 m mismatch between the two, plus the locked-out arm (165 degrees against John's estimated 60-90).

## Fixes

1. **Let the uppercuts be thrown from closer in. Add lead_uppercut (and rear_hook) to RangeBreath.INSIDE and give both uppercuts their own wanted distance of about 0.70-0.74 m. At 0.72 m my clips miss by only 0.05-0.14 m, and at 0.68 m by 0.02-0.11 m. Let the carry, the 0.84 floor AND the 0.82 shown-body limit (BODY_KEEP_M) go down to about 0.70 m for an armed uppercut only. Guard it with the real bodies: heads at least 0.55 m apart and lead toes at least 0.25 m apart (measured at those distances: heads 0.70-0.74 m, toes 0.26-0.37 m).** [medium] Where: scripts/fight3d/RangeBreath.gd:23-24, 63-70; scripts/fight3d/PunchRange.gd:13-21 (an uppercut floor); scripts/fight3d/RingPlace.gd:16-23 (MIN_GAP_M, INSIDE_FLOOR_M, BODY_KEEP_M while an uppercut is armed) Risk: These limits were added after 'they walk through each other'. The live poses (the head lean that keeps heads apart, the close-in guard, a boxer folding over a body shot) can come closer than the animation alone. It needs a film from the fight camera and the guard check before it's called done.
2. **Quick win while fix 1 is built: pick the uppercut take that fits the distance. The lead 'hurt' take reaches at 0.88-0.93 m with the elbow at 106-110 degrees, and the rear 'hurt' take at 0.87-0.91 m with 123. The switched-off lead stepping take (pro_left_uppercut_ft) reaches at 0.86 m with 112. So at the fight's 0.84-0.94 m, play one of these instead of the plain take, which needs 0.61-0.70 m.** [small] Where: scripts/fight3d/BeatClips.gd:34-50 (the PUNCH variants and the OFF_TAKES list) and punch() Risk: The hurt takes are meant to look tired, and the stepping take scored under 6 in S390. Score them again on the game's camera before turning one on.
3. **Trim the lead uppercut inside close-in spells like every other punch. Re-measure pro_left_uppercut in clip_travel.json, which holds [[0,0]] today, so it plays only its last 0.20 m and not its whole 0.73 s wind-up.** [small] Where: tools/clip_travel.gd; assets/data/clip_travel.json; read by scripts/fight3d/BeatFire.gd:134-138 via scripts/rules/ShortPunch.gd:49-55 Risk: Low. The new data also changes when the punch's contact falls; re-run the tests that read the travel data.
4. **Stop PunchReach locking the arm straight for uppercuts. Cap the elbow at about 120 degrees and cover the rest with the chest lean and the lunge, even at jab distance, where land() lunges 0 today. Count a landed uppercut still more than 0.15 m off as a miss.** [small] Where: scripts/fight3d/PunchReach.gd:196-200 (limit l1 + l2 - 0.004 for uppercuts); scripts/fight3d/FightStage.gd:139-143 Risk: Without fix 1 or 2, more uppercuts will stop visibly short, and the lunge slides the body with no step.
5. **Cut the lead uppercut's follow-through. After contact it rises 0.35 m over the thrower's own head and comes back over her own body, peaking at 0.88 s. Hand it back to the guard right after contact (its recovery cut), or reshape the clip after 0.75 s. The 12 cm lean back is in the clip and needs the reshape.** [small] Where: assets/data/clip_recovery.json and BeatClips.recovery for pro_left_uppercut; or the clip itself Risk: Low. A faster hand-back can jerk the glove, so check it in a film.
6. **Aim uppercuts at the underside of the chin, about 0.12 m below today's face point, so the glove meets the jaw going up.** [small] Where: scripts/fight3d/FightStage.gd:237-250 target_point (an uppercut variant) and its call in land() Risk: Low. It doesn't change the distance problem.
7. **Real body travel into the punch. No punch clip moves the hips forward as the game plays it, the stepping takes included, so re-enabling them does not add a step. The earlier claim that the _ft / _hard takes 'drive 0.2-0.3 m forward' is WRONG for _hard and UNPROVEN for _ft. Either bake a real step into new uppercut clips, or move the body with the code's existing carry.** [large] Where: new or re-baked clips; scripts/fight3d/PunchRange.close_in Risk: Medium to high: animation work and another clip score.
8. **Make the measuring tools honest. clip_contact measures the bare wrist against her own head height; it should measure the glove front against the other boxer's face. Add a check that fails when a punch's travel or contact reads 0.** [small] Where: tools/clip_contact.gd; tools/clip_travel.gd Risk: Low. Rewritten data files change hit timing, so re-run the dependent tests.

## Other punches thrown from too far

- pro_left_hook_v2: reaches at 0.76-0.80 m (earlier 0.73, CONFIRMED roughly), thrown at 0.84-0.94 m, so 0.07-0.15 m short in depth, and it also sits 0.21-0.23 m to the side. In the bout, some landed with the arm locked out at 166 degrees.
- pro_right_hook: reaches at 0.86-0.90 m, so at the fight's distance it is NOT short (WRONG in the earlier analysis). Its miss is height, 0.13-0.24 m low, plus 0.14-0.16 m to the side.
- pro_kidney_shot: reaches at 0.86-0.90 m and within 8 cm at 0.92 m for pair 2, so it is not short (WRONG). Its error is 0.23-0.25 m to the side.
- Straight punches are the opposite: every jab and cross take reaches at 0.91-1.11 m, beyond the jab distance of 0.95-0.98, so in the fight the arm folds (jab elbow median 76-77, cross 51-79). Even so, jabs land 0.07-0.10 m off (median), up to 0.27 m, in the bout logs. The plain jab and cross also arrive 0.16-0.29 m low; jab_c is 0.19-0.21 m and cross_c 0.13-0.15 m to the side.
- pro_left_hook (plain): reaches at 1.01-1.05 m but 0.20-0.32 m low. It is a height fault, not range (CONFIRMED).
- pro_body_shot: reaches the ribs' depth at 1.07-1.12 m but 0.21-0.27 m high (CONFIRMED).

## Unsure

- I did not play a new bout. The fight numbers come from the earlier reader's own raw log rows (one pair, mh_boxer_11 against mh_boxer_13). In the altered run, half of the head punches were turned into uppercuts.
- The chin point (0.05 m below and 0.10 m in front of the head bone) is an estimate; the skeleton has no jaw bone. I did not check which part of the face the game's own target (0.07 m above the head bone) falls on.
- The target boxer was frozen in pro_idle; rk_guard does not exist on these bodies. Four moments of that guard changed the ranges by 0.03 m or less, but the live head lean and the close-in guard were not measured.
- Two pairs of bodies only (sizes 0.97-1.04). The lead uppercut's distance moved 0.04 m between them, so other body sizes will shift every number by a few centimetres.
- The hips never move forward in any clip, so either the game's loader strips the movement or the captures had none. I did not check which, or whether that is deliberate.
- I did not measure how often the fight picks each uppercut take (plain, hard, hurt), so I don't know how many uppercuts on screen are the short plain ones.
- One bout landed only one natural uppercut, so how often uppercuts come up in a normal fight is unknown.
