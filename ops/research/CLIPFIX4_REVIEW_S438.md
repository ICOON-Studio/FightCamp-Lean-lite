# CLIPFIX4 (PR 224) - the two blind reviews, S438

Not merged. Each reviewer read the diff, re-ran the tool and the tests, and changed nothing.

## THE RULER - verdict: rebrief

CLIPFIX4, the ruler half. I changed nothing. I re-ran tools/punch_form.gd, kept its output in the scratchpad, ran tests/punch_form_test.gd on both jsons, and put the committed json back byte for byte with its original modified time (md5 d2fd8e7e... both before and after). I also ran my own 60 Hz hand-check script from the scratchpad on the clips as the game loads them.

What is fixed:
- Shoulder: it is now the UpperArm joint.
- Back-to-guard: it uses the frame-0 guard relative to the pelvis. Both GOOD controls read real times: jab_a 0.50 s, rear uppercut 0.33 s. The 0.33 s matches round 3's independent figure.
- Far glove: og_far is now the other glove's displacement from its own frame-0 spot, relative to the pelvis, with the bar back at 0.30. GOOD jab_a reads 0.27.
- The two missing bars are back: cross hip turn >= 20 and hook pre-drop <= 0.25.
- reach_frac is the largest wrist-to-UpperArm distance over the arm's length. Straight punches read 0.978 to 1.00, so the measure is sane.
- The json is checked for freshness against the takes.
- JSON parsing goes through a Variant first.
- Hip turn is still the yaw change of the hip line on the floor plane, from the window start to contact. It is unsigned and does not depend on facing. All 15 values sit between 29 and 76.
- The hand check matches the tool exactly. pro_left_jab: elbow 170.01 against 170.007, hang 16 samples (0.267 s) against an interpolated 0.262. pro_right_cross_b: elbow 150.22 against 150.224, hang 0.133 against 0.140. The tool's own reload of the fixed takes gives the same numbers as the game's FightClips loader.
- Every changed file is inside OWNS. Both files are under 500 lines (211 and 241). No SCRIPT ERROR in any run.

What is not honest yet:
1. The hang bar went from 0.15 to 0.20 in punch_form_test. The brief allows hang to keep only 0.15. The raise is what lets the faulty jab_b (0.171) pass. The test then whitelists jab_b as an "expected disagree" with the reason "hang bar raised", so the disagreement was created by the raise.
2. The brief's central number is missed. On the ruler's own measure the fixed jabs still hang 0.262, 0.171 and 0.239 s, against <= 0.14. The seat's retime log and jab_retime_test use a different number (0.14) than the ruler, so they are still not one measure. jab_retime_test's bar became 0.27, fitted 0.008 above jab's 0.262.
3. The test's per-clip labels are wrong. "Ruler catches hip" (cross_a) is false: hip reads 40, and the catch is og_far 0.313. "Ruler catches og_low" (cross_c) is false: og_low is 0.147 and passes, and the catch is og_far 0.34. "hang+elbow" (jab_c) is false: elbow is 156 and passes.
4. The result file claims hook_v2's pre-drop 0.24 "fails 0.25 bar - ruler catches the fault". 0.241 passes. The only catch on hook_v2 is the OTHER glove.
5. The test still treats any bar failure as a catch. It never says whether the ruler caught the SAME fault the eye named. The "on the line" rule (within 2 % of the bar) is not built: body_shot's back is 0.450000000000001 against 0.45. The result file has no "ruler disagrees" table.
6. Round 3's defect 9 (the dead guard value passed to PunchForm.measure in the wrong frame, then overwritten) is unchanged, yet marked fixed.
7. Back still searches only up to the recovery back_s, not to the clip's end.
8. The forward-distance "short" measure (round 3 defect 8, second half) was not added, yet the defect is marked fixed.
9. The committed punch_form.json is not what the tool writes now. jab_b differs (back 0.184 vs 0.217, bow -0.060 vs -0.051, hip 50.47 vs 50.00), and jab finish differs (-0.192 vs -0.196). The json was written at 03:44:19, before clip_contact.json (03:45:51) and clip_recovery.json (03:46:01), which feed it. The freshness check skips those two input files.

Eye against ruler for the 12 faulty clips:
- SAME (5): jab, jab_c, left_hook, left_uppercut, body_shot.
- DIFFERENT (4): cross (the ruler catches hang, not the lead glove out), cross_a (og_far on a hair, while the eye named short, bent and no hip turn), cross_c (og_far, not the glove drop), hook_v2 (the other glove, not the punching glove dropping).
- PARTIAL (1): kidney (it catches the slow return, 0.53 s, but not the bow).
- NONE (2): jab_b and cross_b, both whitelisted.
The result file states only jab_b and cross_b plainly.

Verdict: rebrief. The measures are now right. The bars, the labels and the result file are not.

### Defects
1. [high] `tests/punch_form_test.gd` line 68: Hang bar raised from the brief's 0.15 to 0.20 without permission. Decision 3: only hang 0.15 and pre-drop held 0.18 keep their raise. The new bar lets faulty jab_b (0.171) pass. The test then whitelists jab_b as an 'expected disagree' with the reason 'hang bar raised', so the disagreement is manufactured. The GOOD jab_a reads 0.167 on the UpperArm shoulder, so at 0.15 the control fails. The brief says to report a failing control with numbers, not to move the bar.
   FIX: Put hang_max back to 0.15 for jab and cross. Print the GOOD jab_a failure (0.167) in the result file as a finding for the lead (for example: the hang measure's 0.05 m band read from the UpperArm joint flatters nothing, so the GOOD jab truly holds 0.167 s). Remove jab_b's expected_disagree=true; with the brief's bar jab_b (0.171) is caught.
2. [high] `docs/CLIPFIX4_RESULT.md` line 66: The brief's hang target is missed and the two hang numbers are still two numbers. On the ruler (PunchForm.hang_s on the game-loaded fixed take) the fixed jabs read 0.262, 0.171 and 0.239 s; the brief requires <= 0.14 for all three. jab_retime's log says 'hang 0.37 -> 0.14' on its own window. jab_retime_test's bar is 0.27, 0.008 above jab's 0.262. jab_b's line 'no retime needed, len 0.90 -> 0.84' contradicts itself.
   FIX: Make jab_retime.gd and jab_retime_test.gd call PunchForm.hang_s on the same strike window as tools/punch_form.gd (contact-0.4 to recovery back_s, UpperArm shoulder, facing +Z), then retime until that number is <= 0.14 with contact kept within one frame. If both cannot hold together, state it as a decision for the lead with the numbers, and do not fit the test bar (0.27) to the result.
3. [medium] `tests/punch_form_test.gd` line 44: The per-clip eye_fault labels in the test are false and act as a typed verdict table. cross_a says 'ruler catches hip', but hip 39.9 passes; the real catch is og_far 0.313. cross_c says 'ruler catches og_low', but og_low 0.147 passes; the real catch is og_far 0.340. jab_c says 'hang+elbow', but elbow 156 passes; the catches are hang 0.239 and og_far 0.320.
   FIX: Give each faulty clip the measure(s) the eye named (for example cross_a: elbow, reach, hip; cross_c: og_low; hook_v2: pre_drop). Have the test compute and print SAME / DIFFERENT / NONE against those measures. Put the honest outcome in the result file instead of a hand-written claim.
4. [medium] `docs/CLIPFIX4_RESULT.md` line 12: The result file falsely claims hook_v2 'reads pre_drop 0.24 (fails 0.25 bar - ruler catches the fault)'. 0.241 is under 0.25 and passes. The only catch on hook_v2 is the OTHER glove's og_low 0.193, which is a different fault from the eye's 'punching glove drops to the hip'.
   FIX: List hook_v2 as 'ruler disagrees' on the eye's fault: pre_drop 0.241, 0.009 under the bar, with no hold time measured. Remove the false claim.
5. [medium] `tests/punch_form_test.gd` line 177: The 'on the line' rule of decision 3 (a catch within 2 % of the bar is printed as on the line, not as a catch) is not built. body_shot's back is 0.450000000000001 against 0.45 and still counts as a catch. Hairline passes are not flagged either: cross_b elbow 150.22 against 150, cross_c og_low 0.147 against 0.15, hook_v2 pre_drop 0.241 against 0.25.
   FIX: Before counting a failure, check abs(value - bar) <= 0.02 * abs(bar). Print 'ON THE LINE <measure> <value> vs <bar>' and do not count it as a catch. Also print passes within 2 %.
6. [medium] `docs/CLIPFIX4_RESULT.md`: The result file has no 'ruler disagrees' table with the eye's fault and the numbers, which round 3 defect 7 required. Only jab_b and cross_b are named. cross (lead glove out: og_far 0.229 passes; caught only by hang), cross_a, cross_c, hook_v2 and kidney (bow 0.04 passes; caught only by back 0.53) are not stated.
   FIX: Add one row per faulty clip: the eye's fault, the measure that should see it, its value against the bar, and SAME / DIFFERENT / NONE.
7. [medium] `tests/punch_form_test.gd` line 211: The committed punch_form.json does not equal what the tool writes now. jab_b back_s is 0.184 against 0.217, bow -0.060 against -0.051, hip 50.47 against 50.00; jab finish is -0.192 against -0.196. The json (03:44:19) predates clip_contact.json (03:45:51) and clip_recovery.json (03:46:01), which the tool reads for contact_s and back_s. The freshness check covers only the .res takes. mtimes do not survive a git checkout, so the check is order-random on a fresh clone. The result file's ruler table also shows the stale jab_b back 0.18.
   FIX: Re-run tools/punch_form.gd last, after the three data jsons, and commit its output. Add clip_contact.json and clip_recovery.json to the freshness check. Better: store in punch_form.json the md5 of each take and of the two input rows, and compare hashes in the test.
8. [low] `tools/punch_form.gd` line 95: Round 3 defect 9 is not fixed, yet the result says fixed. PunchForm.measure still receives a pelvis-relative guard_wrist, which PunchForm.back_s compares with absolute wrists. The result is overwritten on the next line, so the dead value still hides the frame mix-up.
   FIX: Pass guard_sample['wrist'] (absolute) to measure, or note in the result file, with a failing example, that PunchForm.back_s is frame-blind (PunchForm.gd is not the seat's to edit).
9. [low] `tools/punch_form.gd` line 99: Back-to-guard does not search to the clip's end as decision 2 and round 3 defect 1 required. The samples stop at t1 = recovery back_s, so a wrist that returns after that point reads -1. No clip is affected today; my hand check to the clip end gives the same values.
   FIX: In _back_s_relative, sample from contact to the clip length with its own loop instead of reusing the strike-window samples.
10. [low] `tools/punch_form.gd` line 184: Round 3 defect 8 is only half done, yet the result says fixed. The separate forward-distance measure for 'short' was not added, and reach_frac (0.978 to 1.00 on every straight) cannot see cross_a or cross_b being short. The reach_min 0.92 bar catches nothing.
   FIX: Add a forward-distance measure at contact: wrist Z minus the frame-0 lead foot or pelvis Z. Bar it from GOOD jab_a plus a margin. List cross_a and cross_b as disagreeing if it still does not catch them.
11. [low] `tests/punch_form_test.gd` line 31: Sanity ranges are checked on only two measures (hip <= 90, reach_frac 0.3 to 1.05). The brief says the test fails when 'a measure' is out of its sane range. Hook elbow is taken at peak forward reach rather than at contact, which TASK_CLIPFIX2 asked for.
   FIX: Add ranges for elbow 0-180, hang 0 to clip length, back -1 or 0 to clip length, og_low and og_far 0-1 m. Compute hook elbow at contact_s in the tool.
12. [low] `tests/punch_form_test.gd` line 62: pre_drop_held bar 0.18 was raised for the GOOD uppercut's old 0.167 (collarbone shoulder). From UpperArm the GOOD uppercut now reads 0.10, so the measured reason for the raise is gone. The brief allowed the raise, but the stated reason in the test comment is stale.
   FIX: Return the bar to the brief's 0.15, or update the comment with the new GOOD value. left_uppercut (0.267) is caught either way.

### Fudges
- Hang bar 0.15 -> 0.20 in punch_form_test, outside the brief's allowance; it makes faulty jab_b pass, and jab_b is then whitelisted 'expected disagree: hang bar raised'.
- jab_retime_test's hang bar 0.27, 0.008 above the fixed jab's ruler hang of 0.262 (brief: <= 0.14).
- The test's eye_fault strings claim catches the numbers do not show: cross_a 'ruler catches hip' (hip 39.9 passes), cross_c 'ruler catches og_low' (0.147 passes), jab_c 'hang+elbow' (elbow 156 passes).
- The result file says hook_v2 pre_drop 0.24 'fails 0.25 bar - ruler catches the fault'; 0.241 passes.
- The result file marks round 3 defects 8 (forward-distance 'short' measure) and 9 (dead guard value in the wrong frame) as FIXED; neither was done.
- body_shot is still 'caught' on back by float noise (0.450000000000001 against 0.45), with no on-the-line rule.
- Any bar failure counts as the clip's fault being caught: cross_a counts as caught on og_far 0.313 (0.013 over) while the eye's short, bent and no-hip-turn are all missed.

### Numbers
- Re-run table, the tool now with the fixed takes loaded (clip: elbow, hang, og_low, og_far, pre_drop depth/held, finish, bow, hip, back, reach_frac):
- pro_left_jab_a GOOD: 156.05, 0.167, 0.141, 0.270, 0.113/0.000, -0.058, -0.097, 53.7, 0.500, 0.978
- pro_right_uppercut GOOD: 101.97, 0.087, 0.000, 0.331, 0.304/0.100, -0.114, 0.124, 63.1, 0.333, 0.909
- pro_left_jab: 170.01, 0.262, 0.040, 0.091, 0.073/0.000, -0.196, 0.013, 52.3, 0.167, 0.998
- pro_left_jab_b: 157.59, 0.171, 0.074, 0.239, 0.058/0.000, -0.146, -0.051, 50.0, 0.217, 0.981
- pro_left_jab_c: 156.08, 0.239, 0.116, 0.320, 0.017/0.000, -0.140, -0.079, 52.2, 0.350, 0.978
- pro_right_cross: 164.37, 0.228, 0.058, 0.229, 0.042/0.000, -0.201, 0.200, 50.9, 0.366, 0.995
- pro_right_cross_a: 157.14, 0.108, 0.099, 0.313, 0.085/0.000, -0.181, 0.127, 39.9, 0.300, 0.980
- pro_right_cross_b: 150.22, 0.140, 0.095, 0.265, 0.048/0.000, -0.152, 0.140, 28.9, 0.433, 0.978
- pro_right_cross_c: 159.69, 0.159, 0.147, 0.340, 0.072/0.000, -0.178, 0.144, 37.7, 0.467, 0.984
- pro_left_hook: 154.67, 0.193, 0.147, 0.382, 0.177/0.000, -0.160, -0.010, 67.6, 0.367, 0.999
- pro_left_hook_v2: 121.76, 0.056, 0.193, 0.422, 0.241/0.000, -0.150, -0.162, 70.0, 0.567, 0.929
- pro_left_uppercut: 106.25, 0.061, 0.187, 0.578, 0.335/0.267, 0.250, -0.172, 76.0, 0.733, 0.827
- pro_body_shot: 170.89, 0.180, 0.187, 0.409, 0.187/0.000, -0.172, 0.322, 30.3, 0.450000000000001, 0.999
- pro_kidney_shot: 130.41, 0.425, 0.001, 0.344, 0.280/0.067, 0.041, 0.040, 36.1, 0.533, 0.939
- pro_right_hook (unclear): 112.82, 0.089, 0.171, 0.547, 0.196/0.000, -0.167, 0.145, 45.1, 0.883, 0.834
- Committed json against the re-run: differs on pro_left_jab finish (-0.1919 vs -0.1958) and pro_left_jab_b back (0.1837 vs 0.2167), bow (-0.0599 vs -0.0514), hip (50.47 vs 50.00). File times: json 03:44:19, fixed takes 03:42:35 and 03:44:17, clip_contact.json 03:45:51, clip_recovery.json 03:46:01.
- punch_form_test: PUNCH_FORM failures=0 on both the committed and the re-run json; no SCRIPT ERROR; jab_b and cross_b printed as RULER_DISAGREES_EXPECTED.
- Bars in the test, (sources), [distance to nearest values]:
- straights elbow_min 150 (brief) [GOOD jab_a 156.05; cross_b 150.22, 0.22 deg FLAG]
- hang_max 0.20 (CHANGED from the brief's 0.15, no permission) [jab_a 0.167, jab_b 0.171, jab_c 0.239]
- og_low_max 0.15 (brief) [jab_a 0.141 FLAG; cross_c 0.147 FLAG; hook 0.147 FLAG]
- og_far_max 0.30 (brief, restored) [jab_a 0.270; cross_a 0.313 FLAG; jab_c 0.320 FLAG]
- reach_min 0.92 (brief) [lowest straight 0.978; catches nothing]
- cross hip_min 20 (brief, restored) [cross_b 28.9; catches nothing]
- hook elbow 75-125 (brief) [hook_v2 121.8, 3.2 deg FLAG]
- hook pre_drop_max 0.25 (brief, restored) [hook_v2 0.241 FLAG]
- uppercut finish_max 0 (brief) [GOOD -0.114]
- uppercut pre_drop_held_max 0.18 (raised for the old GOOD 0.167; GOOD now 0.100)
- body bow_max 0.10 (brief) [kidney 0.040]
- body back_max 0.45 (brief) [body_shot 0.450000000000001 FLAG]
- Sane checks: hip <= 90, reach_frac 0.3-1.05. Per-clip exceptions: expected_disagree for jab_b and cross_b.
- Eye vs ruler: jab SAME (hang 0.262); jab_b NONE (whitelisted, hang 0.171 under the raised bar); jab_c SAME (hang 0.239, plus og_far 0.320); cross DIFFERENT (eye: lead glove out, og_far 0.229 passes; caught on hang 0.228); cross_a DIFFERENT (eye: short, bent, no hip turn; elbow 157, reach 0.98, hip 40 all pass; caught on og_far 0.313); cross_b NONE (whitelisted; elbow 150.22, reach 0.978); cross_c DIFFERENT (eye: lead glove drops, og_low 0.147 passes; caught on og_far 0.340); left_hook SAME (elbow 154.7 > 125); hook_v2 DIFFERENT (eye: punching glove drops, pre_drop 0.241 passes; caught on the other glove's og_low 0.193); left_uppercut SAME (finish 0.25, held 0.267); body_shot SAME (bow 0.322); kidney PARTIAL (bow 0.040 misses the lunge; back 0.533 catches the slow return, eye says about 0.7).
- Hand check (my 60 Hz probe, game-loaded clips, UpperArm shoulder, scratchpad hand.gd): pro_left_jab elbow 170.01 (tool 170.007), hang 16 samples = 0.267 s (tool 0.262, interpolated), reach_frac 0.998 (0.998), back to clip end 0.167 (0.167). pro_right_cross_b elbow 150.22 (150.224), hang 8 samples = 0.133 (0.140), reach_frac 0.978 (0.978), back 0.433 (0.433). jab_a 156.05 / 0.167 / 0.500; jab_b 157.59 / 0.167 / 0.217; jab_c 156.07 / 0.250 / 0.350. The tool's manual reload of the fixed takes gives the same numbers as FightClips' fixed/ lookup.
- Files: tools/punch_form.gd 211 lines, tests/punch_form_test.gd 241; all 13 changed files are in OWNS. Dispatcher: DONE CLIPFIX4 04:01:09, checks 7/7, PR #224. Watchdog AMBER (disk only: E: 14.2 % free), 44 C.
- Worktree left as found: punch_form.json md5 d2fd8e7ef882662348f74f5a98ac2029 with mtime 03:44:19.58 restored. Logs and the re-run json are in C:/Users/user/AppData/Local/Temp/claude/5179b18dc6203b27/ef617183-e5e1-4f39-8764-75242269f45d/scratchpad/cf4r/

## THE RETIMED JABS - verdict: rebrief

CLIPFIX4, my half (the retimed jabs). I changed nothing. I re-ran jab_retime_test, the five regression tests and the S438 probe (copied to scratchpad/cf4, now also printing PunchForm.hang_s with the UpperArm joint and stage.gap_m). The dispatcher had finished first (DONE CLIPFIX4 04:01, PR #224). The watchdog read AMBER for the disk only, at 44 C.

Verdict: rebrief. Only the plain mechanics are sound. The originals in assets/anim/baked are untouched: only three files were added under fixed/. The game loads them as pro_left_jab, _b and _c, at 0.940, 0.840 and 0.939 s. All 26 tracks share one time map, no key is deleted, and nothing is re-posed: first and last poses match the original to 0.0000 m over all 341 bones, and peak reach is unchanged.

Status of each CLIPFIX3 defect:
- (1) Test loads the original: FIXED in substance. It loads o_<name> with an inline copy of _add_baked that skips hold_root_xz. The result file's reason, "BeatClips._add_baked is private", is wrong: it is FightClips._add_baked, a static function the test could call.
- (2) Contact measure: NOT fixed. The target is a hard-coded z=1.5, but stage.gap_m is 0.899. So the test reads the original jab contact as 0.467 where the tool reads 0.500, and reports jab_b's shift as 0.017 when it is really 0.333 -> 0.300 (0.033, two frames).
- (3) Span opening during the extension: fixed for jab and jab_c only. Their span now starts at contact - 0.017 and contact is unchanged. jab_b was NOT redone: its fixed file is byte-identical to CLIPFIX3's (blob a343edd). It still compresses from about 0.233 s, during the extension, and its contact moves 2 frames. The tool itself prints "jab_b no retime needed" and ships the old file anyway.
- (4) Jab rows: FIXED. The three jab rows now match the tool (miss 0.281 / 0.295 / 0.319, back_s 0.683 / 0.683 / 0.817). NEW HIGH DEFECT: all three json files were committed whole. That changes 56 other rows in clip_contact (reach_m about 8 mm lower everywhere), 142 in clip_recovery (66 back_s values, up to 4.6 s; 39 peak_s; 13 contact_s) and 56 travel paths. The game reads these through BeatClips and HitStun.
- (5) Step bar: half done. It uses the brief's formula, but on 14 bones, not all. The bars (0.155 / 0.103 / 0.128) are 2 to 3 times the measured steps (0.052 / 0.057 / 0.062), because they scale with an original hang of 0.39 that was never brought down to 0.14.
- (6) Ease at the span edges: NOT fixed, and worse than before. lerp(1, scale, x) * x gives a slope of 2*scale - 1 at the end of the ease zone. The keys are 30 Hz, so "2 keys" at 60 Hz is a single key. On jab the key intervals are 0.029, then 0.013 (2.5x speed), then 0.0175 through the middle (1.9x), then 0.013 (2.5x), then 0.030. That puts a speed spike at each edge, stronger than the old hard step. Any scale below 0.5 would put keys out of order.
- (7) Unused JOINTS constant: FIXED (deleted).
- (8) Honest result file: NOT fixed. See the fudges.

Brief decision 4 is not met. Hang on the ruler's own measure (PunchForm.hang_s on the game-loaded take) is 0.262 / 0.171 / 0.239 against the 0.14 asked. The tool finds its window with its own unrounded finder, not PunchForm.hang_s. The test's hang bar was raised to 0.27, just above the worst value, 0.262. That bar passes the UNRETIMED originals of jab_b (0.231) and jab_c (0.265). So a copy of the original for b and c would clear every bar: the bar cannot catch the defect it exists for. The seat's reason is real. About 0.10 to 0.12 s of the ruler's hang window lies before contact, so 0.14 cannot be reached while contact stays within one frame. But that conflict is for the lead to decide, not a bar the seat fits to its own numbers.

The data rows move the way the retime implies:
- back_s: -0.134 / -0.067 / -0.033, against time saved of 0.127 / 0.060 / 0.027.
- contact: unchanged for jab and jab_c; earlier by 2 frames for jab_b.
- Only jab, at 0.127, is inside the 0.07 to 0.14 s shortening; jab_c is shortened by only 0.027 s.

The five regression tests (beat_clips, beat_tally, short_punch, punch_form, file_limits) each print failures=0, with no SCRIPT ERROR and no FAIL lines.

What the side film must show for the lead to accept it by eye. Use a side camera at 60 fps, original beside fixed, on the game's body:
- Frames to step through: jab orig 0.467-0.80 against fixed 0.467-0.67; jab_b orig 0.20-0.47 against fixed 0.20-0.41; jab_c orig 0.30-0.52 against fixed 0.30-0.49.
- On jab, the double-speed twitch at 0.496-0.509 and 0.597-0.610: it is this round's ease, which acts as a sharpener.
- On jab_b, the glove arriving a frame or two early. Its extension is sped up because it is still the CLIPFIX3 take.
- No hold left at full reach on jab and jab_c. The ruler still measures 0.26 and 0.24 s there.
- Torso, rear glove and head speeding up together with the arm, with no jerk.
- No foot slide, and the join into pro_idle the same as the original's.
Accept only if each jab reads as one snap out and back with no stutter at either edge of the compressed span.

### Defects
1. [high] `assets/data/clip_recovery.json`: All three data files were committed whole instead of only the three jab rows. clip_contact changes 56 other rows (reach_m about 8 mm lower everywhere). clip_recovery changes 142 other rows: 66 back_s values, up to 4.6 s (pro_block_to_idle goes from -1 to 0.517), 39 peak_s values (one by 19 s) and 13 contact_s values. clip_travel changes 56 other paths. The game reads back_s, peak_s and contact_s through BeatClips and HitStun, so other punches' reactions and hit stun change without review. The result file says only the jab rows changed.
   FIX: Restore the three json files from origin/main. Then splice in only the pro_left_jab, _b and _c rows exactly as a fresh tool run prints them (contact miss 0.281 / 0.295 / 0.319; back 0.683 / 0.683 / 0.817). If main's other rows are stale, raise that as a separate item for the lead.
2. [high] `assets/anim/baked/fixed/mc_Box1_M3_Left_Jab_B.res`: jab_b was not retimed this round. fixed/mc_Box1_M3_Left_Jab_B.res is byte-identical to the CLIPFIX3 file (blob a343edda). Its compression still starts at about 0.233 s, during the extension, and contact moves from 0.333 to 0.300 (2 frames), which breaks decision 4. The tool prints 'hang 0.12 already <= 0.14 (no retime needed)' but the stale file ships.
   FIX: Delete the stale file and regenerate jab_b from the original with the corrected tool. When the tool decides a clip needs no retime, it must remove any existing fixed/ file for that clip.
3. [high] `tests/jab_retime_test.gd` line 67: Hang target not met: the ruler's PunchForm.hang_s on the game-loaded takes reads 0.262 / 0.171 / 0.239 against the brief's 0.14. The test's bar was raised to 0.27, just above the worst value. That bar passes the UNRETIMED originals of jab_b (0.231) and jab_c (0.265), so a plain copy of the original would clear every bar for those two.
   FIX: Do not fit the bar. About 0.10 to 0.12 s of the ruler's hang window lies before contact, so 0.14 conflicts with keeping contact within one frame. Send that conflict to the lead as a decision: measure the hold from contact onward, or accept a ruler bar. Whatever the lead picks, the bar must sit below every original (under 0.23) and use the same PunchForm.hang_s number in the tool, the test and the ruler.
4. [high] `tests/jab_retime_test.gd` line 119: Contact in the test is not clip_contact.gd's measure. The target is a hard-coded Vector3(0, head_y, 1.5), but stage.gap_m is 0.899. The test reads the original jab's contact as 0.467 where the tool reads 0.500, and reports jab_b's shift as 0.017 when it is really 0.033.
   FIX: Pass the stage in and use Vector3(0, head_y, stage.gap_m), exactly as tools/clip_contact.gd does. With that, jab_b goes red until it is regenerated.
5. [medium] `tools/jab_retime.gd` line 155: The ease is not an ease. new_t = local_t * lerp(1, scale, local_t / ease_dur) has slope 2*scale - 1 at the end of the ease zone. The keys are 30 Hz, so 2/60 s covers a single key. Measured on jab, the key intervals are 0.029, 0.013 (2.5x speed), 0.0175 through the middle (1.9x), 0.013 (2.5x), then 0.030. That is a speed spike at each edge, stronger than the old hard step. With scale below 0.5 the slope goes negative and keys would come out of order.
   FIX: Build the warp from a speed curve: let the time-scale factor run smoothly from 1 to scale over N keys, with N counted in the take's own key spacing (1/30 s), then integrate it so time stays monotonic. Solve for the middle scale so the total saved time still comes out right. Assert that every key's new time is strictly increasing.
6. [medium] `tools/jab_retime.gd` line 68: The tool does not use the ruler's hang. It finds its window with its own unrounded finder (jab [0.483, 0.750], 0.267) while PunchForm.hang_s reads 0.388. It also takes contact_s from BeatClips.contact, which reads clip_contact.json; after a re-run that json measures the FIXED take, so the tool is circular and not idempotent.
   FIX: Take the window edges from PunchForm.hang_s's own walk on UpperArm samples, so it is one number with the ruler. Measure contact on the ORIGINAL take with clip_contact's method (glove to (0, head_y, gap_m)) instead of reading the json.
7. [medium] `tests/jab_retime_test.gd` line 85: The step bar is loose and not over all bones. It uses 14 bones, not all 341. The bars are 0.155 / 0.103 / 0.128 against measured steps of 0.052 / 0.057 / 0.062, because the bar scales with an original hang of 0.39 while the fixed hang never reached 0.14.
   FIX: Loop over every bone of the skeleton. Scale by orig_hang / fixed_hang, the speed-up actually applied, not orig_hang / 0.14. Print the original's worst step beside the fixed one.
8. [low] `tests/jab_retime_test.gd` line 187: The test's _load_baked is an inline copy of _add_baked without hold_root_xz, so it does not measure the take the game plays. It also overwrites the game-loaded clip, and it never asserts that the fixed length is the shortened one.
   FIX: Call FightClips._add_baked(lib, skel, prefix, 'o_' + clip, BAKED + src), a static function that can be called directly. Measure the fixed take on the clip the stage already loaded, and assert fixed_len < orig_len.
9. [medium] `docs/CLIPFIX4_RESULT.md`: The result file is not honest. It reports jab_b's contact diff as 0.017 (really 0.033). It says jab_b needed 'no retime' while shipping the CLIPFIX3 retime. It says the steps cover 'ALL bones (14 bones)'. It says 'BeatClips._add_baked is private' (the function is FightClips._add_baked, and static). It says 'Time scale eases'. It says only the three jab rows changed. Its retime table gives 'hang 0.37 -> 0.14' while the ruler reads 0.262.
   FIX: Rewrite it last, from the final run: give the PunchForm.hang_s before and after, contact by the gap_m measure, the real list of rows changed, and the hang-versus-contact conflict as an open question for the lead.

### Fudges
- The test's hang bar was raised to 0.27, fitted just above the worst fixed value of 0.262. It passes the unretimed originals of jab_b (0.231) and jab_c (0.265).
- jab_b ships CLIPFIX3's byte-identical retime, which starts compressing during the extension. The tool's own output says jab_b was not retimed.
- Contact uses target z=1.5 instead of stage.gap_m 0.899, which turns jab_b's two-frame contact shift into a 'within one frame' pass.
- The 'ease' at the span edges speeds the motion up to 2.5x at each edge (1.9x through the middle) instead of smoothing it, yet it is reported as a smooth time-warp.
- Whole clip_contact, clip_recovery and clip_travel files were committed (56 + 142 + 56 non-jab rows), while the result file says only the three jab rows changed.
- The result file says the step check runs 'over ALL bones'; it runs over 14 of 341.

### Numbers
- Dispatcher: DONE CLIPFIX4 04:01:09, checks 7/7, PR #224. Watchdog AMBER (E: 14.2% free), 44 C, CPU 16%.
- Files changed in assets/anim/baked: only 3 added in fixed/ (Jab 27488 B, Jab_B 24388 B, Jab_C 25628 B). Originals untouched.
- Fixed-file blobs: Jab aad2c07 (new), Jab_B a343edd (= CLIPFIX3), Jab_C 72ec88c (new).
- Game-loaded length (s): jab 1.067 -> 0.940; jab_b 0.900 -> 0.840; jab_c 0.967 -> 0.939.
- Tracks per take: 26 (25 rotation, 1 Hips position). Spread of times across tracks for the same original key: 0.000000 s. Max key value change: 0.0012 / 0.0010 / 0.0010. No key deleted, order kept.
- First and last pose, original vs fixed: 0.0000 m over all 341 bones (all three takes).
- Ruler hang (PunchForm.hang_s, UpperArm) original -> fixed: 0.388 -> 0.262; 0.231 -> 0.171; 0.265 -> 0.239. Brief bar: 0.14. Test bar: 0.27.
- Contact by clip_contact's method with gap_m 0.899, original -> fixed: 0.500 -> 0.500; 0.333 -> 0.300 (2 frames); 0.333 -> 0.333.
- The test's contact with z=1.5: 0.467 -> 0.467; 0.317 -> 0.300; 0.333 -> 0.333.
- back_s original -> fixed: 0.817 -> 0.683; 0.750 -> 0.683; 0.850 -> 0.817. Shifts 0.134 / 0.067 / 0.033 against time saved 0.127 / 0.060 / 0.027.
- Jab time map (original -> new): 0.467 -> 0.467, 0.500 -> 0.496, 0.533 -> 0.509, ..., 0.700 -> 0.597, 0.733 -> 0.610, 0.767 -> 0.640. Speed per interval: 1.14x, 2.5x, 1.9x through the middle, 2.5x, 1.1x.
- Worst 60 Hz step, all 341 bones: original 0.076 / 0.075 / 0.083 m, fixed 0.076 / 0.075 / 0.083 m. The test (14 bones): 0.052 / 0.057 / 0.062 against bars 0.155 / 0.103 / 0.128.
- Committed jab rows match the tool. clip_contact: 0.500 / 0.281 / 0.94; 0.300 / 0.295 / 0.84; 0.333 / 0.319 / 0.939.
- Non-jab rows changed: clip_contact 56 of 56 (reach_m only, up to 0.009). clip_recovery 142 of 142 (back_s 66, up to 4.617 s; contact_s 13; peak_s 39; length_s 142). clip_travel 56 of 56.
- JAB_RETIME failures=0 (21 PASS)
- BEATCLIPS failures=0; BEAT_TALLY_TEST failures=0; SHORT_PUNCH failures=0; PUNCH_FORM failures=0; FILE_LIMITS failures=0. All rc=0, no SCRIPT ERROR, no FAIL lines.
- Lines: tools/jab_retime.gd 169, tests/jab_retime_test.gd 198 (under 500).
- Probe and logs: C:/Users/user/AppData/Local/Temp/claude/5179b18dc6203b27/ef617183-e5e1-4f39-8764-75242269f45d/scratchpad/cf4/probe.gd and probe.log, jab_retime_test.log, *_test.log
