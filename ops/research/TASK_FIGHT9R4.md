# TASK FIGHT9R4 - CURSOR (composer, Antigravity out of quota until ~11-10) - the live fight to 9/10 on Argon's own judging, round by round

Status: OPEN (S371, Claude; S372 rewritten after round 1 failed to compile). Operator S371: "gemini4 review the fight with the fixes and rate it again", "and then tell
gemini to reach to 9/10", "let argon do all the fixes until its 9/10". Main scored 3/10 (verdict below).

## How the loop works
- You are one ROUND. You fix the costliest defects in the "Last verdict" below that are yours (see "Not yours"), one or
  two per round - a real fix, not a tweak of a number to fool a camera.
- The dispatcher then commits your files, runs the checks headless, films the same fight (tools/judge_film.gd, the walk-in
  and 90 s of round 1 at real speed) and Gemini 4 Argon judges it. If the score is at least the last one and every check is
  green, your branch becomes the next round's BASE; otherwise the next round starts from the round before and reads why.
  The next round's brief is this one with the new verdict. It stops at 9/10 (or 12 rounds); a Claude session merges.
- You cannot run anything (file tools only). So read the code that plays the fight before you change it: the fight view
  is scripts/fight3d/ (FightView, FightStage, MovePlayer, BeatFire, BeatClips, HitImpact, HitSnap, Footwork, FootPlant,
  PunchRange, RingPlace, CornerCrew, the camera files), the clip timing data assets/data/clip_contact.json,
  clip_recovery.json, clip_travel.json. Keep every script under 500 lines.
- Every fix gets a measured bar in tools/fight9_probe.gd (extends SceneTree, plays a live round headless like
  tools/knee_probe.gd / tools/judge_film.gd do, prints PASS/FAIL lines and "FIGHT9 failures=<n>", quit(1) on failure).
  Keep the earlier rounds' bars; add yours (e.g. a jab's extension time from start to full reach, feet travel per planted
  step, the camera never jumping across the line). A headless pose probe must `await process_frame` after loading clips or
  every seek reads the rest pose (S370 trap). Inert-modifier trap (Ziva S362): a SkeletonModifier3D may not reach the shown
  pose - change what is drawn, and measure the drawn bones.

## Not yours (other seats own them right now - do not edit those parts)
- (The REFEREE is YOURS now - S371: Qwen's NOREF1 crashed its own probe and left frozen clinches, PR #23 closed. The
  operator's call stands (S369: no referee - both boxers push each other off slowly, hands on, guard up). Read Qwen's try
  in ops/research/noref1_qwen/ (PushOff.gd.txt, push_off_probe.gd.txt, hooks.diff.txt = its Clinch/BeatFire/FightCast edits) and take
  what works; the clinch must end in a push-off that never freezes and never passes through a body.)
- Body-shot hit reactions: Ziva's BODYREACT1 (HitSnap / BeatClips / BeatFire body-shot paths). Head-shot snap and punch
  timing in those files are yours; the body-shot reaction code is hers.
- Tired legs: scripts/fight3d/BodyBurn.gd's tank lines (TANK_POWER, the legs/power from an empty tank) are Claude's
  S373 work on main - leave BodyBurn.gd alone this round.
- Knees: your own KNEETRACK1 (scripts/fight3d/KneeTrack.gd) - build on it if it is in your base, do not fight it.

## Clinches are rare now (operator, S374) - do not bring them back
"to lower clinches ... clinch happen only when a fighter is desperate to break opponents combo but get risk of getting hit,
that should be pretty rare and i dont care about the real stats". scripts/rules/ClinchBeats.gd (not yours) now places a
clinch only right after a combination lands on the holder, ~0.16 a round, often with the attacker's entry shot landing
0.30 s before the tie-up (beat key "entry": true). Your push-off still has to be right for the few that happen.

## Body folds must hold (S374, from merging main into agy/fight9r1) - read before touching punch timing
Main now has Ziva's BODYREACT1 (tools/body_react_probe.gd -- show3d: every shown body shot folds >= 18 deg within 0.15 s
and HOLDS >= 0.35 s; main reads 25.9 deg / 0.43 s). Merged with your round 1 it read react 39/39, curl 22 deg OK, but held
0.20 s - your faster combos (BeatClips.COMBO_LAND_S 0.28 / COMBO_SAME_HAND_S 0.36, main 0.35 / 0.45) land the follow-up
inside the fold. Keep the quicker hands, but a follow-up aimed at a boxer still folded (HitSnap _bt < 0.51, _gain > 1.5 -
BeatFire._folded) waits for the fold, the way BODYREACT1 already makes her own next punch wait. Body-shot reaction code
itself stays Ziva's. When your branch is collected, body_react_probe must PASS.

## Operator's own note first (S372, comment C218 on the KNEETRACK1 after-film at 24 s) - TOP PRIORITY
"when legs move its akward something is wrong, when doesnt move looks ok". Claude looked at the frames (19-24 s): standing
still the legs are fine; the moment she steps, the knees cave inward toward each other, the feet turn out away from the
knees, and the rear heel lifts with the foot twisted. The stance goes knock-kneed for a beat on every step, slip and
crouch. Fix the MOVING legs (stepping, slips, crouches): knees over the toes WHILE the feet travel, feet pointing where the
knee points, heel lifts on the line of the foot. Your KneeTrack.gd (KNEETRACK1, merged) holds the still pose; the moving
pose is where it breaks. Add a bar in tools/fight9_probe.gd: knee-over-toe angle during steps (not only at rest).

## Last verdict (round 2 on agy/fight9r2: KEPT by Claude S373 - this round's code is your BASE)

Argon could not judge round 2's film (the Gemini project hit its monthly spend cap, HTTP 429), so Claude read your probe
instead. Your probe had one parse error of your own (tools/fight9_probe.gd:173 called BeatClips.speed(clip) - it takes
(clip, move); a defence clip passes ""). Claude fixed that line (a6fadb9b) and ran it on your branch: 15 of 18 PASS -
the operator's C218 note is fixed (knees over toes while stepping 4.4 deg, knees never cave 0.351 m), no referee, the
jab lands and snaps the head, the camera keeps its side. Three FAIL, all the same thing:

    FAIL clinch break 1: hands=true through=34 dur=0.86s gap=0.92m
    FAIL clinch break 2: hands=true through=35 dur=0.86s gap=0.92m
    FAIL clinch break 3: hands=true through=34 dur=0.86s gap=0.92m

So this round: the PUSH-OFF out of the clinch (scripts/fight3d/PushOff.gd, Clinch.gd). The bodies pass through each other
for ~34 frames while they part; the hands do push. Make the break a push with no overlap: both bodies stay apart (no
mesh through the other at any frame), they step back to range together, slowly, as the operator asked ("make them
recover their positions pushing slowly each other"). Keep every PASS above green - do not touch KneeTrack's moving-leg
fix. Your tools cannot run Godot: use only GDScript 4 methods that exist on that exact type, and check each call's
argument count against the function you call.

## Contract
OWNS: scripts/fight3d/, scripts/rules/MoveWords.gd, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, tools/fight9_probe.gd
RED_TEST: tools/fight9_probe.gd -> FIGHT9 failures=0
REGRESSION: fight_flow_test, golden_path_test, ring_lens_test, clinch_rest_test, beat_clips_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/judge_film.gd -- secs=90
BASE: agy/fight9r2
LOOP: FIGHT9 9
