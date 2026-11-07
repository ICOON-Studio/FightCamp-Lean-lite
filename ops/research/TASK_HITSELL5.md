# TASK HITSELL5 - QWEN (qwen3-coder) - find where a landed punch's reaction is lost in the played fight, then fix it there

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (the live 3D fight, up close and mid range).
HITSELL2-4 are NOT merged (PRs #69, #72): each tuned HitSnap on a bare body and the films did not change.

## Contract
OWNS: tools/head_react_probe.gd, scripts/fight3d/HitSnap.gd, scripts/fight3d/HitImpact.gd, scripts/fight3d/BeatFire.gd:160-212
RED_TEST: tools/head_react_probe.gd
REGRESSION: hit_snap_gain_test, hit_flash_test, fight_polish_test, counter_cut_test, body_keep_test, inside_beats_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/fight3d_film.gd -- E:/FightCamp/tmp/hitsell5 short

## Why (a fresh blind critic, S397, main vs HITSELL4, fight3d_film short, same seed)
Main 3.5 vs HITSELL4 3 on hit reading: the two films are ~95% the same - HITSELL4's HitSnap changes barely reach the screen.
In BOTH films, up close, a landed and a blocked punch look the same: punches end glove-on-glove or glove-on-face and the head
barely moves (0:12.3, 0:16.4-17.25, 0:20.3-21.4, 0:25.4, 0:29.1-29.9); a "big jab" gets almost no reaction (0:49.0-49.6).
The one clear head snap is in the slow close-up (0:34.6-34.9). So HitSnap can move a head (a bare-body test reads 0.10 m, 37 deg),
but in the played fight the reaction is lost or never fired. Find where before tuning anything.
(The film's fast-forward stretch in round 1, ~0:30-0:44, is the film tool skipping time - not a game fault.)

## Do
1. Write tools/head_react_probe.gd on the model of tools/body_react_probe.gd (three LIVE rounds through the tools/fight3d_play.gd
   flow, bodies as SHOWN via tools/pose_tap.gd, contacts from FightStage.hit_gaps / PunchRange.record). For EVERY head punch that
   shows (not cut off), landed and blocked: the defender's head bone rotation (deg) and travel (m) over 0.35 s from contact, its
   peak time, the reaction clip she played, the HitSnap degrees that HitImpact asked for (deg after SNAP_DEG, BIG_SNAP, the
   burning-arm power), the hit-stop held, and the gap between the boxers (stage._gap()). Summary line:
   `HEAD_REACT landed n=.. turn_med=.. travel_med=.. | blocked n=.. turn_med=.. travel_med=.. | ratio_turn=.. ratio_travel=..`
   plus a breakdown by punch (jab / cross / hook / uppercut) and by range (inside vs mid). Run it like body_react_probe (the
   never-shown desktop via tools/hidden_desktop.py, --fixed-fps 30, --audio-driver Dummy). Write main's numbers in the PR body.
2. From those numbers say in the PR body WHERE the reaction is lost (examples to check, not guesses to act on: SNAP_DEG too small
   for short inside punches; the hit-stop freezing the head through the snap's rise; GloveClear/GuardTuck/HitStun overwriting the
   head after HitSnap; the reaction clip's own head motion fighting the snap; landed punches up close reported as blocked).
3. Fix it at that place, inside OWNS (if the cause sits in a file you do not own, stop and write it in the PR body instead).
   Bars on the probe (main must FAIL them): landed head turn median >= 15 deg and >= 2.5x the blocked median; landed travel median
   >= 0.04 m; blocked turn median <= 6 deg; every landed peak within 0.08 s of contact; no bone > 30 deg in one frame.
4. Keep every REGRESSION test green. Do not touch BeatClips.gd, GloveClear.gd, HitStun.gd unless step 2 proves the cause there
   (then stop and report), FootPlant.gd, nor the fight model (scripts/rules, scripts/state, scripts/world). Files under 500 lines.

## Result lines (PR body)
RESULT: HEAD_REACT main  landed n=.. turn_med=.. travel_med=.. | blocked ... | ratio ...
RESULT: HEAD_REACT after ...
RESULT: lost at <file:function> because <one line>
RESULT: regression <pass/fail per test>

## Prior research
TASK_HITSELL2-4.md; PRs #69 #72 (comments); FIGHT_TESTS_S396.md; tools/body_react_probe.gd (S370 BODYREACT1, the same method for
body shots); HitSnap.gd / HitImpact.gd / BeatFire.gd S302-S396 notes.

## What would a human do?
Frame-step the real fight at the moment a punch lands and see whether the head was asked to move and did not, or was never asked.

## Prefab check
No asset.
