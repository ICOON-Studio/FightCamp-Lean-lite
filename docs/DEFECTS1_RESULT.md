# DEFECTS1 result (branch claude/defects1)

Five seen defects. Four are fixed on the branch, one commit each, each with a test that was red on the old code first.
The fifth (the guard knee) is stopped for the lead: the measurement says an approved change moved it, see the last part.

| # | Defect | State | Commit |
|---|---|---|---|
| 1 | Amateur corner says "No cut, no swollen eye" over a cut eye | fixed | 2b40ab38 |
| 2 | Face summary used the code's band names ("critical", "doctor") | fixed | 2d7f97af |
| 3 | Result page: "Tank", and round chips that look like scores | fixed | 288adc12 |
| 4 | Five word sets for the same bands | fixed: one table | e51d6f15 |
| 5a | block_meet_test red (rear hook into the blocking glove) | fixed in the game | 027abe97 |
| 5b | guard_knee_test red (rear knee off the source take) | STOPPED for the lead | none |

## 1. The amateur corner's face line

What the player saw: in an amateur bout's corner, under her figure, "No cut, no swollen eye: the cutman waits." even
when she was cut and her eye was closing. An amateur corner has no cutman jobs, so the "nothing to do" line ran every
time.

Now the line says what her face shows, in the same words as the result page:
"Cut over the left eye, left eye badly hurt, right eye sore." An amateur corner names no cutman at all; a clean amateur
face reads "No cut, no swollen eye." A pro corner is unchanged: with a cut or a swollen eye the CUTMAN jobs show, and a
clean pro face still reads "No cut, no swollen eye: the cutman waits."

Where: `scripts/rules/FaceMark3D.gd` `corner_line()`, read by `scripts/fight3d/CornerOverlay.gd` (403 lines).
Test: `tests/corner_face_line_test.gd` builds the real corner card for two different boxers' maps. Old code: 7 failures
(it printed "No cut, no swollen eye: the cutman waits." over the cut). Now 0.

## 2. The face summary's words

`FaceMark3D.summary()` printed "Left eye shut, cut over the right eye, right eye critical, nose hurt" and "Nose doctor".
It now reads the result page's words through `BandWords.word()`: "right eye badly hurt, nose sore". The damage tile
(`Aftermath.gd`) and the result page's pinned cards (`ResultMarks.gd`) read the same function, so they cannot drift.
Test: `tests/face_mark3d_test.gd` now asserts against `BandWords.word()` and that no summary contains "critical" or
"doctor". Old code: 11 failures. Now 0.

## 3. The result page's top

- "Tank at the last bell" is now "Energy left at the last bell" (`scripts/rules/FightStats.gd`).
- The round chips ("1   20-22") sat under the tag "ROUNDS" and read like scores. The tag is now "PUNCHES LANDED"
  (`scripts/ui/MatchStats.gd`; the same strip is on the corner card's "The fight so far" tab). The chip's hover says
  "energy left at the bell" instead of "tanks".
- Test: `tests/fight_stats_test.gd` (3 failures on the old words, now 0). `plain_words_test` and `words_on_screens_test`
  green; neither of them visits the result page, so they could not have caught this.
- Not checked with a picture: the longer tag ("PUNCHES LANDED" for "ROUNDS") on the corner card with many rounds. A
  10-round strip may be tight inside the card; a 3 or 4 round amateur or debut bout is not.

## 4. The band words: five sets, now one table

Before (on main):

| Where | File and line | fine | hurt band | critical band | doctor band |
|---|---|---|---|---|---|
| Hover tip on a body place | scripts/ui/BodyTip.gd:15 | fine | hurt | badly hurt | the doctor may stop it |
| Head close-up line | scripts/ui/CalloutLine.gd:19 | holding up | hurt | badly hurt | doctor may stop it |
| Rib / liver close-up line | scripts/ui/CalloutLine.gd:17 | costs gas | gas drains faster | badly hurt, gas going | doctor may stop it |
| Damage tile on the result page | scripts/rules/Aftermath.gd:103, 112 | (not shown) | sore | badly hurt | badly hurt |
| Pinned cards on the result page | scripts/ui/ResultMarks.gd:19 | fine | sore | badly hurt | badly hurt |
| Also: face summary | scripts/rules/FaceMark3D.gd:156, 161 | (not shown) | hurt | critical | doctor |
| Also: holo legend (hover) | scripts/fight3d/BodyPanels.gd:23 | "Fine: fresh. Hurt: sore. Critical: badly hurt." |||

So during a fight a place was "hurt"; after it, the same place at the same number was "sore". The legend used the
code's own names.

Now: ONE table, `scripts/rules/BandWords.gd`, read by all of them.

| Band (code name) | word (after a fight) | live (during a fight) | body (ribs / liver, during a fight) |
|---|---|---|---|
| fine (above 55) | fine | fine | costs gas |
| hurt (36 to 55) | sore | sore | gas drains faster |
| critical (16 to 35) | badly hurt | badly hurt | badly hurt, gas going |
| doctor (15 and under) | badly hurt | doctor may stop it | doctor may stop it |

What the player will notice: the middle band reads "sore" everywhere (it was "hurt" during the fight); a fine head
close-up reads "fine" (was "holding up"); the hover tip's last band drops "the"; the holo legend reads "Each place reads
fine, then sore, then badly hurt, then doctor may stop it." The rib words stay what they were (they say what the band
does to her gas, which is the point of that line).

Test: `tests/band_words_test.gd` reads every place at values on both sides of each band edge and checks each file keeps
no word dictionary of its own. Old code: 11 failures. Now 0. `body_tip_test` had two lines expecting "Head: hurt"; they
now read the table. Green after the change: band_words, body_tip, callout_pop, result_marks, face_mark3d,
corner_face_line, fight_stats, holo_live.

## 5a. block_meet_test: the rear hook went into the blocking glove (fixed)

Nightly: rows A_B and A_A, pro_right_hook, touch -0.034 and -0.031 (bar: no more than 0.03 m inside the glove).
My run on the branch before the fix: -0.032 and -0.032.

When: the rows were first all read on 2026-11-11 by 6091c364 (S436: before it, the ruler read 1 row of 21 on the
stepping route). Its own message already shows the rear hook at 3.3 cm. The test joined the nightly list with 4b5c03ab
(S435), so 2026-11-12 was its first nightly.

Why, measured:
- The game aims a blocked punch's glove FRONT at the blocking glove's mount point, the same point the ruler calls the
  glove's centre. So every blocked punch was aimed about 4 cm inside the glove, and a row passed only when the reach
  fell short. S426 had patched the straight right (cross) alone with a 1.5 cm stand-off.
- On the stepping route the footwork rig (the game's default since 79665239, his "Older stepping route") lets the rear
  hook fall short by under 1 cm. With the rig switched off in a probe, the rear hook reads -1.6 / -0.3 / -0.9 cm (passes).
  On the captured route (`-- rokoko`) it reads -1.0 / -2.1 / -0.9 cm.

The fix (the game, not the bar): the front now stops at the glove's surface, the mount point plus 0.04 m toward the
puncher, for every punch (`scripts/fight3d/FightStage.gd` `BLOCK_SURFACE_M`, which replaces the cross-only patch).
0.04 m is the ruler's own glove radius, not a number fitted to these readings.

| | rows read | failures | touch, lowest to highest |
|---|---|---|---|
| before (main code) | 27 of 27 | 2 | -3.2 to +1.0 cm |
| after (final run) | 27 of 27 | 0 | -1.2 to +2.1 cm |

The landed-punch control rows (CTRL_LANDED) still land: 0.4 to 1.7 cm from the face before, 0.5 to 2.0 cm after (bar 5 cm). head_aim_test green.
Not done: a still on the game's camera. The 3D view only shows the result, but this changes how a blocked punch looks
(it stops on the glove instead of a few cm into it): the lead should look at one before it goes to main.
Note for the lead: the test's A_A setup puts the same body (mh_boxer_10) on both sides; the house rule is to never test
identical fighters. I did not change the test.

## 5b. guard_knee_test: the rear knee (STOPPED for the lead)

Nightly: both boxers' rear knee mean -0.067 and -0.070 against the source take's +0.029 (bar 0.03). My run: the same
(-0.0666, -0.0700).

When: 79665239 (2026-11-11 12:57, S432, "the stepping route is the game's default"). The nightly of 2026-11-11 05:00
passed on the commit before it; the 2026-11-12 nightly is the first after it.

Why, measured on the branch (each one full run of the test):

| Run | boxer 0 rear | boxer 1 rear | passes |
|---|---|---|---|
| as the game plays (stepping route) | -0.0666 | -0.0700 | no |
| FootLock off (`-- nofootlock`) | -0.0666 | -0.0702 | no |
| FloorStand off (`-- nofloorstand`) | -0.0664 | -0.0700 | no |
| both off | -0.0666 | -0.0700 | no |
| captured route (`-- rokoko`) | +0.0182 | -0.0003 | yes |
| footwork rig let go (probe, not kept) | +0.0261 | +0.0266 | yes |

So it is not FootLock or FloorStand (the planned KNEE1 files): it is the footwork rig's own leg solve
(`scripts/fight3d/BoxerFootworkRig.gd` `_solve`, S391: "the knee over its own foot's line", added after judges saw
caved-in knees). When the stepping route became the default, the rig took the legs in the guard, and its rule puts the
rear knee about 7% of the leg length outward from the clip's own knee.

The test was written (S408) while the captured route was the default and the rig had let go of the legs, so its
expectation (the clip's own knee) never met the rig's rule. Two approved things now disagree:
- the rig's rule (knee over the turned-out rear foot), approved with the stepping route (Q-S294-183), or
- the test's rule (the guard knee stays on the source take).

The right expectation is the lead's call, so I moved nothing. If the take's knee is right, the fix belongs in the rig's
solve in the guard (and KNEE1 should point there, not at FootLock / FloorStand). If the rig's knee is right, the test
should measure the rig's own rule instead of the take.

## Not run

The full suite (by rule). No windowed or hidden-desktop job was needed; every run was headless through godot_slot.
