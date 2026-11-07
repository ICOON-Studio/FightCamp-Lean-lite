# TASK HITSELL4 - QWEN (qwen3-coder) - a blocked head shot shows on the fight's own path, a landed one keeps its snap

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (the live 3D fight). Rounds 2 and 3 are NOT merged:
round 3 = branch qwen/hitsell3, commit 73bb5cb1 (read why below). START FROM IT:
`git checkout origin/qwen/hitsell3 -- tests/hit_sell_test.gd scripts/fight3d/HitSnap.gd`, then change what the list says.

## Contract
OWNS: scripts/fight3d/HitSnap.gd, scripts/fight3d/BeatFire.gd:192-212, tests/hit_sell_test.gd
RED_TEST: tests/hit_sell_test.gd -> HIT_SELL failures=0
REGRESSION: hit_snap_gain_test, hit_flash_test, fight_polish_test, counter_cut_test, body_keep_test, inside_beats_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/fight3d_film.gd -- E:/FightCamp/tmp/hitsell4 short

## Why round 3 is not kept (Claude read the diff)
1. `brace_head()` is never called by the game: the block branch is in BeatFire.gd (lines ~192-212, `elif d != "":`), which
   round 3 did not own. A blocked head shot in the game still plays only the defence clip. You own those lines now.
2. The test still drives HitSnap alone on a bare body and calls brace_head() itself, so "landed 40-73x blocked" compares
   two things the test chose, not what the fight shows.
3. RISE_S 0.035 -> 0.08 makes every LANDED head snap rise over 5 frames instead of 2: a softer snap, the opposite of the
   goal (blind judges S396: "hits do not sell", "a landed shot looks like a blocked one"). Keep RISE_S at 0.035-0.05.
   The 12 deg/frame pop bar applies to the TRUNK (fold and brace), not to the head snap (a real snap is fast).
Keep from round 3: the live guard bar, BRACE_ELBOW_DEG 10, FOLD_GAIN 3.5, GAIN_RATE 8 (fold under 12 deg/frame, 18.9 deg).

## Do
1. Test FIRST (tests/hit_sell_test.gd), a FIGHT-PATH section: FightStage with two real boxers (as tests/ring_feet_test.gd
   builds it; stage in the tree and processing so every skeleton modifier runs), at inside range (hips 0.55 m apart) and at
   punching range (1.0 m). For jab, cross, lead hook: fire it LANDED through the stage's own calls exactly as BeatFire does
   (`stage.land(who, clip, false, at, contact)` then `stage.hit(other, BeatClips.react(...), ...)` at contact), and BLOCKED
   as BeatFire does after your change (the defence clip via `stage.play(other, BeatClips.defence(...))` plus the new head
   brace at contact). Measure on the defender from the pose AS SHOWN, over 0.35 s from contact:
   - LIVE (guard): a landed cross moves the head > 0.03 m on main (if not, the harness is wrong);
   - a. head travel: landed >= 2.0x blocked, and blocked > 0.005 m (the block must show too: gloves pushed back into the
     face, the head a few cm) - print both per punch per range;
   - b. head turn speed in the first 0.10 s: landed >= 2.5x blocked;
   - c. the landed snap peaks within 0.06 s of contact (it reads as a hit, not a lean);
   - d. body (keep round 3's): landed fold >= 18 deg on gutshot_v3, blocked brace 3-10 deg, trunk <= 12 deg per frame.
   Print main's numbers in the PR body (LIVE passes on main; a's "blocked > 0.005" fails on main: the block shows nothing).
2. Make it green: wire the block branch in BeatFire.gd (only lines 192-212) to call the defender's snap.brace_head(...) at
   contact for a blocked HEAD punch (the body branch keeps snap.brace); HitSnap.brace_head pushes the head a few cm back
   along the punch and lets go like the snap (no trunk give). RISE_S back to 0.035-0.05.
3. Keep every REGRESSION test green. Do not touch BeatClips.gd, GloveClear.gd (INSIDE2), HitStun.gd, HitImpact.gd,
   FootPlant.gd, nor the fight model (scripts/rules/*, scripts/state/*, scripts/world/*: another session rebuilds it).

## Rules
- Real captures only. Bodies unchanged (men bare-chested, women in singlets, everyone in boots). Files under 500 lines.
- Headless only (`--headless --audio-driver Dummy`). Commit with clear messages. No edits to ops/ or gate files.

## Result lines (PR body)
RESULT: HIT_SELL main  live=.. a=<landed/blocked m per punch per range> b=.. c=.. d=..
RESULT: HIT_SELL after ...
RESULT: regression <pass/fail per test>

## Prior research
TASK_HITSELL2.md, TASK_HITSELL3.md; FIGHT_TESTS_S396.md; HitSnap.gd S305/S310/S371/S386 notes; BeatFire.gd S302/S305/S390.

## What would a human do?
On a broadcast a landed punch is read by the head (it snaps away fast, the face turns); a blocked one by the gloves (they
are knocked back into the face, the head moves a little, she stays square).

## Prefab check
No asset.
