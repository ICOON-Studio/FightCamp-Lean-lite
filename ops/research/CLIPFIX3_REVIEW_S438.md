# CLIPFIX3 (PR 223) - the two blind reviews, S438

Not merged. Round 4 (TASK_CLIPFIX4.md) fixes every defect below. Each reviewer read the diff, re-ran the tool and the tests, and changed nothing.

## THE RULER - verdict: rebrief

CLIPFIX3, my half (the punch ruler). Nothing was changed: I re-ran tools/punch_form.gd, saved its output to the scratchpad, ran the test, and restored the committed json byte for byte. Of the four faults, only the hip turn is fixed. (1) HIP TURN is fixed: it is now the yaw of the line between the two hip joints, on the floor plane, from the start of the strike window to contact. My own sampling gives the same numbers (jab 55.9 vs 55.9; cross_b 31 vs 28.9, the gap from sample timing). All 15 clips read 29 to 76 degrees, and the shoulder line turns about as much. (2) BACK is NOT fixed. The guard reference is the wrist at the start of the strike window (contact minus 0.4 s), relative to the pelvis. The brief asked for the clip's FIRST frame. At that window start the GOOD rear uppercut's wrist is already 0.238 m into its wind-up, so the GOOD control still reads -1. Measured from frame 0 against the pelvis, she is back in guard 0.33 s after contact (closest distance 0.012 m). The result file wrongly says the uppercut "genuinely" never returns. (3) FITTED BARS are NOT fixed. The far-glove bar is 0.35 for jab and cross. The brief set 0.30 and allowed raising only hang and pre-drop held. The cross bar went from 0.30 in round one to 0.35, which clears the GOOD jab_a at 0.323. The cross hip-turn bar (>= 20) and the hook pre-drop bar (<= 0.25) were dropped without a word. Three catches sit on a hair: cross_c fails the elbow bar by 0.03 degrees and passes the low-glove bar by 0.003 m; body_shot fails back at 0.450000000000001 against 0.45. (4) REACH is half done. reach_frac is wrist-to-shoulder distance over arm length, taken at the sample of greatest forward reach rather than at the greatest distance. The "shoulder" in the tool is the LeftShoulder/RightShoulder bone, which is the collarbone, not the shoulder joint. That collarbone point also feeds the elbow angle: measured from the real shoulder joint (UpperArm), cross_b's elbow is 155.6 degrees, not 149.2, and jab_a's is 156.0. So the ruler's only catch on cross_b, and probably on cross_c, comes from the wrong point. The committed punch_form.json is STALE. It was written at 03:02; the retimed takes were written at 03:13. Its three jab rows measure the old takes (hang 0.28/0.21/0.23). Re-run now, with fixed/ loaded the way the fight loads it, the tool gives 0.157/0.154/0.155, all above its own 0.15 bar. This contradicts the result file's 0.13/0.15/0.15. The test has no check for a json older than the clips, though the brief requires one. The test passes (PUNCH_FORM failures=0, no SCRIPT ERROR) on both jsons. Because every faulty clip that clears all bars is labelled "RULER DISAGREES" by the test itself, the test cannot go red on a faulty row. Files are within OWNS, every script is under 500 lines, and only the three jab rows changed in clip_contact, clip_recovery and clip_travel. Round three is needed.

### Defects
1. [high] `tools/punch_form.gd` line 130: Back-to-guard reference is the punching wrist at the start of the strike window (contact - 0.4 s), not at the clip's first frame as the brief requires. The GOOD rear uppercut is already 0.238 m into its wind-up there, so it reads back_s = -1. From frame 0, relative to the pelvis, she is back 0.33 s after contact (closest 0.012 m). The result file calls the GOOD control a clip that 'genuinely' never returns. pro_left_hook, pro_left_uppercut, pro_kidney_shot and pro_right_hook (-1) may be the same artefact.
   FIX: In _back_s_relative and in the guard_wrist passed to measure, take guard = wrist(t=0) - hips(t=0) from a separate sample at clip time 0, not samples[0]. Search for the return to clip end (not just recovery back_s). Print back_s for both GOOD controls and require a real number in the test.
2. [high] `tests/punch_form_test.gd` line 59: Far-glove bar is 0.35 for jab and cross. The brief set 0.30 from how a punch is thrown and allowed only hang and pre-drop held to move. The cross bar was 0.30 in round one and was raised to clear GOOD jab_a (0.323). Every clip reads 0.30 to 0.42, so the measure does not separate the eye's 'lead glove left out' (cross 0.329) from the GOOD jab (0.323).
   FIX: Restore og_far_max 0.30. Re-define the measure as the other glove's displacement from its OWN frame-0 guard position, relative to the pelvis, not its distance from a point under the head bone. Where the GOOD control still fails, report it in the result file with the numbers instead of moving the bar.
3. [medium] `tests/punch_form_test.gd` line 60: Two bars removed silently since round one: cross hip_turn >= 20 (a brief starting bar) and hook pre_drop_depth <= 0.25 (a brief starting bar). Neither removal is mentioned in the result file.
   FIX: Put both bars back. cross_a reads hip 40 against the eye's 'almost no hip turn', and hook_v2 reads pre_drop 0.20 against the eye's 'drops to the hip'. List both as 'ruler disagrees' with their numbers.
4. [high] `tools/punch_form.gd` line 107: The tool's 'shoulder' is the LeftShoulder/RightShoulder bone, which is the collarbone. LeftUpperArm/RightUpperArm (the real shoulder joint) is sampled but never used. This skews the elbow angle, reach_frac and pre-drop. From the real joint: cross_b elbow 155.6 (the ruler says 149.2 and calls it a fault), jab_a 156.0 (ruler 152.6), right uppercut 124.9 (ruler 112.0). The elbow catches on cross_b (0.8 degrees under the bar) and cross_c (0.03 degrees under) are artefacts.
   FIX: shoulder = p["LeftUpperArm"/"RightUpperArm"]. Re-measure all 15. Accept that cross_b and cross_c then likely clear the elbow bar and become 'ruler disagrees'.
5. [high] `assets/data/punch_form.json`: The committed punch_form.json is stale: written 03:02, before the fixed/ takes (03:13) and the FightClips lookup. Its three jab rows measure the original takes. Re-run now, the tool writes hang 0.157 / 0.154 / 0.155 for jab / jab_b / jab_c, all above the ruler's own 0.15 bar, while the result file says 0.13 / 0.15 / 0.15 after the retime.
   FIX: Re-run tools/punch_form.gd after the retime and commit its output. Make jab_retime_test use PunchForm.hang_s on the same window so the two hang numbers are one number, or say in the result file why they differ. Retime to <= 0.14 on the ruler's measure.
6. [medium] `tests/punch_form_test.gd` line 13: The test does not check that punch_form.json is newer than the clips, although the brief requires it. That is why the stale json passed.
   FIX: Compare FileAccess.get_modified_time of punch_form.json with that of every baked and fixed take of the 15 clips (or with a hash of their paths stored in the json), and FAIL if the json is older.
7. [medium] `tests/punch_form_test.gd` line 157: The test labels every faulty clip that clears all bars 'RULER DISAGREES', so no faulty row can ever turn it red (a check that can only pass). The result file lists only cross_a as disagreeing, though the ruler also misses the eye's named fault on cross (glove left out; it catches hang instead), cross_b (short), cross_c (glove drops; it catches only the elbow artefact), hook_v2 (punching glove drops to the hip; it catches the OTHER glove) and kidney (bow).
   FIX: Keep the 'ruler disagrees' rows as a short list in the result file with the eye's fault and the measured numbers, and have the test fail when a clip outside that list clears all bars. For each faulty row, print whether the ruler caught the SAME fault the eye named.
8. [low] `tools/punch_form.gd` line 147: reach_frac is taken at the sample of greatest forward reach, not as the greatest wrist-to-shoulder distance the brief asked for, and it does not see 'short' (cross_a 0.976, cross_b 0.965). The eye's 'short' is more likely distance toward the target than arm extension.
   FIX: Take the max over samples of |wrist - UpperArm| / arm length. Add a separate forward-distance measure (wrist forward of the starting lead foot or pelvis at contact) for 'short', with a bar from the GOOD jab plus margin, and list cross_a and cross_b as disagreeing if it still does not catch them.
9. [low] `tools/punch_form.gd` line 70: measure() is called with a pelvis-relative guard_wrist that PunchForm.back_s compares with absolute wrists. The result is wrong but is overwritten one line later, so the dead value hides the frame mix-up.
   FIX: Pass the guard in the same frame PunchForm expects, or drop the overwrite and report the PunchForm limitation in the result file with a failing example (PunchForm.gd is not the seat's to edit).
10. [low] `tests/punch_form_test.gd` line 18: data = JSON.parse_string(...) is assigned to a typed Dictionary before the 'is Dictionary' check. Bad JSON gives a runtime error instead of the BAD JSON message.
   FIX: var parsed: Variant = JSON.parse_string(...); if not parsed is Dictionary: fail; data = parsed.

### Fudges
- Far-glove bar kept at 0.35 (cross raised from 0.30 to 0.35) to clear GOOD jab_a 0.323. The brief allowed only hang and pre-drop held to move; the result file calls it 'with margin, same pattern'.
- Cross hip-turn >= 20 and hook pre-drop <= 0.25 bars dropped silently.
- The GOOD rear uppercut reads back -1 and the result file explains it as 'genuinely never returns to guard'. From the clip's first frame she is back 0.33 s after contact.
- The result file's hang after the retime (0.13/0.15/0.15) does not match the ruler's hang on the fixed takes loaded the way the fight loads them (0.157/0.154/0.155, all above the 0.15 bar). The committed json still shows the pre-retime takes.
- The elbow catches on cross_b (0.83 degrees under 150) and cross_c (0.03 degrees under) come from using the collarbone as the shoulder. From the real joint, cross_b is 155.6.
- The test auto-labels any faulty clip that clears all bars as 'ruler disagrees', so it cannot fail on a faulty row. The result file names only cross_a as disagreeing.
- body_shot fails the 0.45 back bar only by float noise (0.450000000000001).

### Numbers
- Re-run table (tool now, with fixed/ takes): clip elbow hang og_low og_far pre_drop(depth/held) finish bow hip back reach_frac
- pro_left_jab_a GOOD: 153 0.14 0.14 0.32 0.09/0.00 -0.06 -0.10 54 0.48 0.97
- pro_right_uppercut GOOD: 112 0.17 0.00 0.37 0.38/0.17 -0.11 0.12 63 -1.00 0.83
- pro_left_jab: 171 0.16 0.04 0.33 0.03/0.00 -0.19 0.02 56 0.22 1.00 (committed json: elbow 168.6 hang 0.28 back 0.30 hip 53 = original take)
- pro_left_jab_b: 155 0.15(0.154) 0.07 0.33 0.03/0.00 -0.15 -0.06 50 0.20 0.98 (committed: hang 0.21 back 0.23)
- pro_left_jab_c: 144 0.16(0.155) 0.12 0.33 0.02/0.00 -0.14 -0.08 53 0.33 0.95 (committed: hang 0.23 back 0.38)
- pro_right_cross: 158 0.18 0.06 0.33 0.04/0.00 -0.20 0.20 51 0.37 0.98
- pro_right_cross_a: 154 0.10 0.10 0.33 0.05/0.00 -0.18 0.13 40 0.28 0.98
- pro_right_cross_b: 149 0.12 0.09 0.31 0.03/0.00 -0.15 0.14 29 0.37 0.96
- pro_right_cross_c: 150(149.97) 0.14 0.15(0.147) 0.32 0.05/0.00 -0.18 0.14 38 0.47 0.97
- pro_left_hook: 144 0.16 0.15(0.147) 0.31 0.15/0.00 -0.16 -0.01 68 -1.00 0.95
- pro_left_hook_v2: 115 0.06 0.19 0.33 0.20/0.00 -0.15 -0.16 70 0.58 0.85
- pro_left_uppercut: 100 0.06 0.19 0.34 0.39/0.30 0.25 -0.17 76 -1.00 0.78
- pro_body_shot: 160 0.15 0.19 0.34 0.18/0.00 -0.17 0.32 30 0.45 0.99
- pro_kidney_shot: 108 0.09 0.00 0.42 0.30/0.08 0.04 0.04 36 -1.00 0.82
- pro_right_hook (unclear): 101 0.08 0.17 0.30 0.19/0.00 -0.17 0.15 45 -1.00 0.78
- Committed json vs tool now: differs on the 3 jab rows only (stale). punch_form_test on both: PUNCH_FORM failures=0, no SCRIPT ERROR.
- Bars: straights elbow>=150 (brief; jab_a 152.6, margin 2.6 deg - FLAG); hang<=0.15 (raised from 0.13 for jab_a 0.141, allowed, margin 0.009); og_low<=0.15 (brief; jab_a 0.141, cross_c 0.147, hook 0.147 - FLAG); og_far<=0.35 (brief says 0.30; raised for jab_a 0.323 - NOT allowed); reach>=0.92 (brief). Hook elbow 75-125 (brief), hook og_low<=0.15 (carried from round one). Uppercut finish<=0 (brief), pre_drop_held<=0.18 (raised from 0.15 for GOOD 0.167, allowed, margin 0.013). Body bow<=0.10, back<=0.45 (brief; body_shot 0.450000000000001). REMOVED: cross hip>=20, hook pre_drop<=0.25.
- Eye vs ruler: jab SAME (hang); jab_b SAME (hang); jab_c SAME (hang, plus elbow); cross DIFFERENT (eye: lead glove out; ruler: hang 0.18; og_far 0.329 passes); cross_a NONE (ruler disagrees, stated; also hip 40 vs eye's 'almost no hip turn', not stated); cross_b partial/artefact (elbow 149.2 by collarbone, 155.6 by real shoulder; reach 0.965 does not see 'short'; not stated); cross_c DIFFERENT (elbow 149.97 artefact; glove drop og_low 0.147 passes by 0.003; not stated); left_hook SAME (elbow 144); hook_v2 DIFFERENT (other glove low 0.19 vs eye's punching glove drop; not stated); left_uppercut SAME (finish 0.25, held 0.30); body_shot SAME (bow 0.32); kidney partial (back -1 matches slow return, bow 0.04 misses the lunge; not stated).
- Hand check (reviewer's own 60 Hz sampling, scratchpad script): pro_left_jab (fixed take) elbow 170.9 vs tool 170.86, hang 9 samples = 0.150 s vs tool 0.157 (interpolated), reach_frac 0.997 vs 0.997, hip turn 55.9 vs 55.9. pro_right_cross_b elbow 149.2 vs 149.17, hang 7 samples = 0.117 vs 0.120, reach_frac 0.965 vs 0.965, hip 31 vs 28.9. Real-shoulder elbow: cross_b 155.6, jab_a 156.0, cross_a 157.1, uppercut 124.9.
- Back from clip frame 0 (pelvis-relative): GOOD uppercut 0.33 s (tool -1), jab_a 0.50 (tool 0.48), cross_a 0.30 (tool 0.28), cross_b 0.43 (tool 0.37). Uppercut guard at window start is 0.238 m from frame-0 guard.
- Files: punch_form.gd 163, punch_form_test.gd 176, jab_retime.gd 143, jab_retime_test.gd 199, FightClips.gd 156 lines; all 13 changed files inside OWNS; clip_contact, clip_recovery, clip_travel: only the 3 jab rows changed. Dispatcher: DONE CLIPFIX3 03:23, PR #223. Watchdog AMBER (disk only), 44 C.

## THE RETIMED JABS - verdict: collect_with_fixes

The retimed jabs are what the game now plays, and the retime itself is clean. The test that guards it is mostly hollow, and the committed contact rows were not produced from the shipped takes.

(1) Game path. FightClips.load_into builds BAKED_DIR+stem.res for every pro stem, swaps it for FIXED_DIR when ResourceLoader.exists, then calls _add_baked, which does the same re-path, hips rest offset and hold_root_xz as before. Only the three files in fixed/ take over: pro_left_jab, _b, _c. Game-loaded lengths are 0.940 / 0.840 / 0.890 (originals 1.067 / 0.900 / 0.967). `git diff --stat origin/main...HEAD -- assets/anim/baked` shows only the three added files in fixed/; no original was changed.

(2) jab_retime.gd. All 26 tracks are retimed with one time map: 25 rotation tracks plus 1 position track (Hips), no scale tracks and no non-bone tracks. Keys at the same original time land at the same new time on every track (spread 0.000000 s). Key counts, paths and interpolation are unchanged and order is kept. Key values move by at most 0.0012 (float noise; nothing re-posed or smoothed). Keys before the window keep their times, keys inside are scaled, keys after shift by time_saved, and the length shrinks by the same amount. No key is deleted.

DESIGN FAULT: the window opens 0.05 m BEFORE the peak, during the extension. Peak and contact therefore move earlier: contact goes from 0.500 to 0.450, 0.333 to 0.300 and 0.333 to 0.300. That is 3, 2 and 2 frames, about 10%, which fails the brief's own "contact within 5%" bar when measured honestly.

(3) jab_retime_test (my run): 18 PASS, `JAB_RETIME failures=0`. Only the hang bar is real. The test never loads the original take: stage.setup already loaded the FIXED clip under the name pro_left_jab, and every "orig" measure calls pose_point on that same name. Contact, reach and both pose checks compare the fixed clip to itself, which is why every error prints 0.0%. Its "contact" is the wrist's minimum distance to the origin (0.15 to 0.20 s, the guard), not the punch. Red on main only because the fixed files are missing. The 0.6 m step bar is 8x the measured worst step (fixed 0.065 / 0.057 / 0.062 m over 6 bones; originals 0.076 / 0.075 / 0.083 m over all 341 bones), so it would pass a badly torn clip.

My own probe compared each original, loaded through FightClips._add_baked as o_<name>, with the game-loaded fixed clip. It found:
- first and last poses identical over all 341 bones (0.0000 m);
- peak reach unchanged (0.596 to 0.595, 0.567, 0.572);
- largest 60 Hz step unchanged (0.076 to 0.077, 0.075, 0.083 m);
- hang 0.267 to 0.133, 0.200 to 0.150, 0.217 to 0.150.

(4) Data rows. Only the three jab rows changed in each json. The large line counts in the diff are reformatting; checked key by key.
- clip_recovery: back_s 0.80 to 0.683, 0.767 to 0.683, 0.85 to 0.767. My probe's originals read 0.817 / 0.750 / 0.850, so back_s moved earlier by 0.133 / 0.067 / 0.083 s, matching time_saved of 0.127 / 0.06 / 0.077 s. Main's recovery rows were stale (length_s 1.4 / 1.267 / 1.333 is not these takes), so the json before/after is not a like-for-like pair.
- clip_contact: the committed rows do not match a re-run of tools/clip_contact.gd on the shipped takes (run as a scratch copy writing outside the worktree). reach_m is committed 0.249 / 0.255 / 0.280 but measures 0.284 / 0.300 / 0.326, and jab_b contact_s is committed 0.317 but measures 0.300. The 8 untouched jab clips reproduce within 3 to 4 mm. PadWork.gd:196 reads reach_m, so the wrong rows move pad placement by about 4 cm and claim a closer landing that the retime cannot create.
- clip_travel: travel_m 0.485 to 0.499, 0.386 to 0.42, 0.432 to 0.449. Consistent with more of the curve now coming before contact.

(5) The tests that play these clips, all rc=0, no SCRIPT ERROR: `BEATCLIPS failures=0`, `BEAT_TALLY_TEST failures=0`, `SHORT_PUNCH failures=0`, `PUNCH_FORM failures=0`, `FILE_LIMITS failures=0`.

(6) Side film for the lead's eye. Use a side camera, original and fixed side by side at 60 fps, on the game's body.
- Frames to step through:
  - jab A: original 0.38 to 0.70 s against fixed 0.38 to 0.57 s;
  - jab B: original 0.22 to 0.45 s against fixed 0.22 to 0.40 s;
  - jab C: original 0.23 to 0.48 s against fixed 0.23 to 0.42 s.
- What to look for:
  - no visible hold at full reach;
  - no hitch or pop where the window opens (0.400 / 0.233 / 0.250 s) or closes (fixed 0.533 / 0.383 / 0.400 s). Speed jumps by 1.9x, 1.43x and 1.55x there because the time scale is a hard step;
  - the whole body is sped up in that window (shoulder turn, rear glove, head and hips together), so watch for a jerky torso or a twitching rear guard;
  - the glove still reaches full extension (peak reach unchanged), with no foot slide (root X/Z held);
  - the retraction and the join into pro_idle look exactly like the original's.

The lead accepts if the punch reads as one snap out and back with no stutter at either edge.

### Defects
1. [high] `tests/jab_retime_test.gd` line 66: jab_retime_test never loads the original take: stage.setup already put the FIXED clip under pro_left_jab (FightClips fixed/ lookup), and every 'orig' measure (contact, peak reach, first/last pose) samples that same name. The checks compare the fixed clip to itself; hence err=0.0% on every row.
   FIX: Load the original with FightClips._add_baked(lib, skel, prefix, 'o_'+clip, BAKED+src) and measure orig on 'o_'+clip. Assert hang on the original > 0.15 so the test prints its own red 'before'. Drop the duplicate manual load of the fixed file (use the game-loaded clip and assert its length is the shortened one).
2. [high] `tests/jab_retime_test.gd` line 127: The test's 'contact' is the minimum of wrist.length() (distance to the body origin), not the glove-to-target contact; it picks 0.15-0.20 s, the guard.
   FIX: Use clip_contact.gd's measure (glove distance to (0, head_y, stage.gap_m) from 0.15 s to 75% of the length) on both o_ and fixed clips.
3. [high] `tools/jab_retime.gd` line 65: The retime window opens 0.05 m before the peak (during the extension), so peak and contact move earlier: contact 0.500->0.450, 0.333->0.300, 0.333->0.300 (3/2/2 frames, about 10%). That fails the brief's own 'contact within 5%' bar, which the tautological test hid.
   FIX: Start the compressed span at max(t_start, contact_s of the original), or at the peak sample, so only the hold after reach is cut. Re-run; contact_s should stay within one frame (16.7 ms). If the lead prefers the faster extension, it must be written as a decision and the bar changed openly.
4. [medium] `assets/data/clip_contact.json`: The committed clip_contact rows for the three jabs are not what tools/clip_contact.gd measures on the shipped takes: reach_m is committed 0.249/0.255/0.280 but measures 0.284/0.300/0.326; jab_b contact_s is committed 0.317 but measures 0.300. The untouched jab clips reproduce within 3-4 mm. PadWork.gd:196 reads reach_m.
   FIX: Re-run tools/clip_contact.gd (prefix=pro_left_jab) after the final takes, then clip_travel.gd and clip_recovery.gd, and commit only the three rows that tool output gives.
5. [medium] `tests/jab_retime_test.gd` line 181: The max-step bar (0.6 m between 60 Hz samples, 6 bones) is about 8x the measured worst step (fixed 0.057-0.065 m; originals 0.075-0.083 m over all 341 bones), so it would pass a clip torn by tens of centimetres.
   FIX: Compare per bone with the original: the fixed clip's worst step must be no more than the original's worst step x (orig_hang/0.14) + 0.01 m (the speed-up inside the window), over all bones. Or bar at 0.15 m with the original's value printed beside it.
6. [low] `tools/jab_retime.gd` line 136: The time scale is a hard step at both window edges (speed x1.9, x1.43, x1.55), so the whole body changes speed abruptly at 0.400/0.233/0.250 s and again at the window end. No test can see it.
   FIX: Optional: ease the scale over 2 keys at each edge (a smooth time-warp). Judge it on the side film before acting.
7. [low] `tests/jab_retime_test.gd` line 14: Unused const JOINTS (with a wrong bone name, LeftElbow) left beside BONES.
   FIX: Delete it.
8. [medium] `docs/CLIPFIX3_RESULT.md`: The result file claims 'contact within 5% ✓', 'pose first/last matches original ✓' and quotes contact 0.33->0.32 for jab_b; none of these were measured against the original.
   FIX: Replace these with the honest before/after numbers from the fixed test, and say plainly that contact moved about 10%.

### Fudges
- jab_retime_test compares the fixed clip with itself for contact, reach and first/last pose (every error is 0.0%), so three of its four bars can only pass.
- The test's contact measure (closest approach of the wrist to the body origin) is not a contact; it reads the guard at 0.15-0.20 s.
- The committed clip_contact rows for the three jabs (reach_m 0.249/0.255/0.280, jab_b contact 0.317) do not come from the tool run on the shipped takes; a re-run gives 0.284/0.300/0.326 and 0.300.
- The 0.6 m joint-step bar is about 8x the measured worst step, so it is loose enough to pass a broken clip.
- 'Red on main' holds only because the fixed files are missing on main; the test prints no 'before' measure of the original.

### Numbers
- Game-loaded length: pro_left_jab 1.067->0.940, _b 0.900->0.840, _c 0.967->0.890 s (fixed/ wins, only these 3)
- Hang (wrist within 0.05 m of peak forward reach): 0.267->0.133, 0.200->0.150, 0.217->0.150 s; windows [0.400-0.667], [0.233-0.433], [0.250-0.467]
- Tracks: 26 per clip (25 rotation, 1 Hips position), same key counts, same-time spread across tracks 0.000000 s, max key value change <= 0.0012
- First and last pose vs original: 0.0000 m max over all 341 bones (all three)
- Peak wrist-shoulder distance: 0.596->0.595, 0.567->0.567, 0.572->0.572 m
- Max 60 Hz joint step, all bones: orig 0.076/0.075/0.083 m, fixed 0.077/0.075/0.083 m; seat test (6 bones) 0.065/0.057/0.062 m vs bar 0.6
- Contact (clip_contact method): 0.500->0.450, 0.333->0.300, 0.333->0.300 s (-10%, brief bar 5%)
- Contact miss reach_m re-measured on the fixed takes 0.284/0.300/0.326 vs committed 0.249/0.255/0.280; main's 0.286/0.303/0.328
- back_s (recovery method): orig 0.817/0.750/0.850 -> fixed 0.683/0.683/0.767 (shift 0.133/0.067/0.083 vs time_saved 0.127/0.06/0.077)
- clip_travel travel_m 0.485->0.499, 0.386->0.42, 0.432->0.449
- JAB_RETIME failures=0 (18 PASS, three of the four bar types tautological)
- BEATCLIPS failures=0; BEAT_TALLY_TEST failures=0; SHORT_PUNCH failures=0; PUNCH_FORM failures=0; FILE_LIMITS failures=0
- Probe script (scratch, read-only): C:/Users/user/AppData/Local/Temp/claude/5179b18dc6203b27/ef617183-e5e1-4f39-8764-75242269f45d/scratchpad/cf3/probe.gd; test logs in the same folder
