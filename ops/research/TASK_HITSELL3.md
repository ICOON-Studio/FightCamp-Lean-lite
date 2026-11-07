# TASK HITSELL3 - QWEN (qwen3-coder) - landed vs blocked measured on the fight's own path

Status: OPEN (S397, Claude, anim-chain session). Round 2 = PR #69, branch qwen/hitsell2, commit ddb54e90 (not merged yet;
its film is being judged). START FROM IT: `git checkout origin/qwen/hitsell2 -- tests/hit_sell_test.gd scripts/fight3d/HitSnap.gd`. Discipline: boxing (the live 3D fight, up close).

## Contract
OWNS: scripts/fight3d/HitSnap.gd, scripts/fight3d/HitStun.gd, scripts/fight3d/HitImpact.gd, tests/hit_sell_test.gd
RED_TEST: tests/hit_sell_test.gd -> HIT_SELL failures=0
REGRESSION: hit_snap_gain_test, hit_flash_test, fight_polish_test, counter_cut_test, body_keep_test, inside_beats_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/fight3d_film.gd -- E:/FightCamp/tmp/hitsell3 short

## Why round 2 is not enough (Claude read it)
- Its harness is live (a landed cross moves the head 0.103 m, a power shot turns it 37 deg): keep that.
- But it drives HitSnap alone on a bare body. "Blocked" returns 0.0 by construction (there is no brace_head), so "landed
  moves the head 2.5x a blocked one" cannot fail. The judges' fault is what the FIGHT shows up close: S396 "up close a landed
  shot looks like a blocked one ('READ IT! lead hook' is a tangle)".
- In the game the two paths differ already (BeatFire.gd ~168-212, HitImpact.gd ~50-78): a landed punch -> stage.land (glove
  carried onto the face), the hit-stop (HOLD_S), camera shake, HitSnap.snap / fold, a reaction clip (BeatClips.react); a
  blocked head shot -> a defence clip (BeatClips.defence) at 0.8 x the contact time and a block sound, nothing else. Round 2
  never ran either path.
- Round 2 set the fold to full gain on the hit frame (FOLD_GAIN 5, _gain_cur at once) and cut the brace (CRUNCH 9 -> 3.5,
  SIDE 6 -> 0.3); its worst frame step is 20.7 deg at 60 fps. S386 removed a 27 deg-in-two-frames fold as a pop on film.

## Do
1. Extend tests/hit_sell_test.gd (start from qwen/hitsell2's file) with a FIGHT-PATH section: FightStage with two real
   boxers at inside range (hips 0.55 m apart) AND at punching range (1.0 m), the stage processing so every skeleton modifier
   runs (HITSELL1 read 0 because they never ran). Fire the same punch twice through the game's own calls - once landed
   (stage.land + stage.hit as BeatFire does), once blocked (stage.play of BeatClips.defence(...) as BeatFire does) - for jab,
   cross, lead hook, body hook. Measure on the defender, from the pose AS SHOWN:
   - LIVE (guard, must pass on main): a landed cross moves the head > 0.03 m on main;
   - a. head travel over 0.35 s: landed >= 2.0x blocked for every head punch, at both ranges (print both numbers);
   - b. the glove: landed - the hitter's glove centre within 0.12 m of her face at contact; blocked - within 0.12 m of her
     glove or forearm and never nearer her face than 0.15 m;
   - c. the first 0.10 s after contact: landed head rotation speed >= 2.5x blocked (the "snap" the eye reads);
   - d. body: landed fold >= 18 deg of trunk on gutshot_v3 (S371 bar), blocked brace 3-10 deg (the elbow drops, she does
     not stand still), no bone turns more than 12 deg between two 60 fps frames (no pop; HitSnap BRACE_RISE_S note).
   Keep round 2's live HitSnap section as is.
2. Make it green in HitSnap / HitStun / HitImpact only: a blocked head shot gets a small brace of its own (gloves pushed back
   into the face a little, head a few cm, no snap); a landed one keeps the snap; the fold rises over >= 3 frames.
3. Keep every REGRESSION test green. Do not touch BeatFire.gd, BeatClips.gd, GloveClear.gd (INSIDE2 owns it), FootPlant.gd,
   nor the fight model (scripts/rules/*, scripts/state/*, scripts/world/*: another session is rebuilding it).

## Rules
- Real captures only. Bodies unchanged (men bare-chested, women in singlets, everyone in boots). Files under 500 lines.
- Headless only (`--headless --audio-driver Dummy`). Commit with clear messages. No edits to ops/ or gate files.

## Result lines (PR body)
RESULT: HIT_SELL main  live=.. a=<landed/blocked per punch per range> b=.. c=.. d=..
RESULT: HIT_SELL after ...
RESULT: regression <pass/fail per test>

## Prior research
TASK_HITSELL2.md; FIGHT_TESTS_S396.md; HitSnap.gd S305/S310/S371/S386 notes; BeatFire.gd S302/S305/S390/S395 notes.

## What would a human do?
On a broadcast a landed punch is read by the head: it snaps away fast and the face turns; a blocked punch is read by the
gloves: they are knocked back into the face, the head barely moves, she stays square.

## Prefab check
No asset.
