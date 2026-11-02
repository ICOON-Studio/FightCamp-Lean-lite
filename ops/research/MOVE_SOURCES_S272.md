# MOVE SOURCES (S272) - which captured clip plays which fight move, what is missing, how a clip is matched

Operator S272, verbatim: "how do we properly match the animations to our moves , are we missing a lot for the box and how much
forkickbox ?"; "we need sidesteps,dodges how can we find these"; "do we have ovehead punch ?"; "we have enough videos already in
our research to generate everything ?"; on the Rokoko cuts: "the animationslook fine and the fighter does not get distorted like
previously , thisis very good", "i think this is uppercut , i do not see guard" (Shadow 19.50), "this also cuts early" (Shadow 8.27).

## How a clip is matched to a move (the method from S272 on)
1. Each move has a spec: striking hand, path (straight / hook / uppercut / body), target height, and it runs GUARD TO GUARD.
2. Every candidate clip is measured on OUR MetaHuman (mh_boxer_01) through the game's own Mixamo -> MetaHuman build, frame by frame:
   `Godot/tools/rokoko_path_probe.gd` (Rokoko cuts from punch_labels.json; `meshy=<stems>` for Meshy library clips;
   `trace=<Take>:<t0>:<t1>` or `trace=meshy:<stem>:<t0>:<t1>` for every frame). Per clip: forearm angle at contact (straight
   0-25 deg, uppercut 45+ up), fist rise into contact (uppercut 0.15 m+), sideways share (hook), punch direction vs +Z (the yaw
   the fight turns it by), guard at start/end, and whether the OTHER hand stays at the chin (else it is a combo, not a single).
3. A clip binds to a move only when the numbers match the spec AND a red-first gate in the test reads the played clip
   (`tests/rokoko_clips_test.gd`: jab/cross aim, rear uppercut top = forearm >= 45 deg, rise >= 0.20 m, fist >= 0.15 m in
   front, aim <= 25 deg). The operator then watches the studio orbit render (8787/animations) - he closes it.
   The peak-only finder (rokoko_punch_finder.gd) passed a jab-into-uppercut as a "jab"; peak numbers alone are not a match.

## Rokoko cuts, measured (rokoko_path_probe S272)
- CLEAN singles (other hand stays home): Boxing 2.30 jab, Boxing 5.63 jab, Boxing 10.00 cross, Shadow 6.17 jab, Shadow 11.80
  (labelled "rear hook/body" - measured a rear STRAIGHT to the body: forearm 27 deg, fist 0.24 m under the chest).
- COMBOS (other hand 0.59-0.74 m off the head = "no guard"): Shadow 4.00, 8.27, 10.97, 19.50, 23.25. Shadow 19.50 is a jab
  whose rear hand drops to the hip loading a REAR UPPERCUT at ~20.0 s (forearm 73-79 deg) - a captured uppercut to cut next.
- Window ends: the finder ends a cut when the striking hand is back near guard reach - the rest of the body is not; 8.27 and
  23.07 (S271) end before the guard. Cuts must end when BOTH hands are home (probe `_guard_window`; the "home" distance needs
  a per-take guard reference - distance-to-head alone reads an extended jab as home, open item).

## Meshy library on our MetaHuman (probe + renders S272)
- 194 Right Uppercut from Guard - USED: boxing_rear_uppercut (FightClipRokoko, window 0.20-1.07 s, yaw +26.0). Played:
  forearm 66-73 deg, rise 0.42 m, fist 0.51 m in front, aim -0.2 / 6.1 deg.
- 195 Right Upper Hook - usable (a stepping rear uppercut, big lean) - alternative.
- 193 Left Hook - REJECTED: swung from both hands at the hips (0.71 m off the head), a haymaker, not from guard.
- 196 Left Uppercut - REJECTED: good guard but a 0.10 m rise and the fist goes 0.60 m sideways.
- 197 Left Short Hook - measured straight-ish (side share 0.08) - recheck by eye before use.

## Coverage - boxing (39 moves bound in FightClipBinding)
- Captured source in hand (9): jab, cross, guard (Rokoko, live); rear uppercut (Meshy 194, live S272); Rokoko rear uppercut at
  ~20.0 s (to cut); rear straight to the body (Shadow 11.80 / 4.00) for boxing_cross_body; check hook candidate (Meshy 197).
  Lead hook and lead uppercut: NO good captured clip yet (Meshy 193/196 rejected).
- Defence (3: slip, pull, catch): candidates on disk, not measured yet - Mixamo Boxing_Dodge_Advance x3, Boxing_Dodge_Retreat,
  Boxing_Side_Step_Walk, Boxing_Left_Side_Step_Walk (baked on the MetaHuman already), 9 Mixamo blocks; Meshy 156/157/162/164
  Stand Dodge, 093 Dodge and Counter (imported to meshy_lib S272), 9 Meshy blocks (E:/FightCamp_backup_D/sources/meshy);
  Rokoko FightingIdle (70 s of footwork between punches - steps can be cut like the punches).
- Counters (4): Meshy 090 Counterstrike, 093 Dodge and Counter + chaining.
- Combos (7): chained from the singles (6 Meshy combos 198-205 also owned, unmeasured).
- NO captured source (16): up-jab, OVERHAND (the shipped boxing_overhand is a hand-made clip; nothing in Rokoko, Meshy or the
  Mixamo catalogue), body hook, rear hook to the body, jab to the body, shovel hook, and 10 footwork/feint moves (angle_step,
  circle lead/rear, pivot, step in/out, switch stance, drawing, feint, rhythm change, check-hook pivot) - procedural today.
- Roughly 70% of boxing has a captured candidate.

## Coverage - kickboxing (20 own moves; punches come from boxing) - NOT demo work (boxing only, S235)
- Have a source (5): roundhouse (Meshy 207), high kick (215), step-in high kick (218), front kick / teep (206 Spartan, 209
  straight kick), clinch knee (211).
- Missing (15): LOW KICK (the main kickboxing weapon), body kick (re-aim the roundhouse?), axe, side, hook, spinning back,
  spinning hook, switch kick, question mark, catch-kick return, + 5 kick combos (chained once the singles exist). ~25% sourced.

## Videos we already have (answer: not enough to generate everything)
- 15 boxing reference videos, AI-generated (Higgsfield S130, E:/FightCamp_backup_D/sources/higgsfield_video): rear hook head/
  body, shovel hook, inside uppercut, check hook, one-two-hook, jab-body-head, liver combo, six-punch - 9 moves, FL/FR angles.
- 7 grappling videos (MMA), 0 kick videos. research/_captures (63) are recordings of our own game.
- AI video is poor input for video -> mocap (bodies drift); real single-person footage on a fixed camera is what converters need.
  John SQ6 (captured mocap, commercial licence) + SQ7 (motion generators) are in the seat queue; test the top one on ONE hook.

## John SQ6 answer (JOHN_MOCAP_MORE_S271_BRIEF_JOHN.md, collected 06:10) - the new leads
- Fab "Boxing Animation Pack" by Ailive (https://www.fab.com/listings/02943b05-f6cb-44d6-b73c-bad3d94dc585): page says "captured via
  motion capture", 10 clips on UE5 Manny - Left/Right Hook, Left/Right Uppercut, Ducking, Sway, Boxing_Footwork, Shadow_Boxing,
  Punch Left/Right. EXACTLY our gaps (lead hook, lead uppercut, slips, footwork). OPEN: the $0 price and the Standard License were
  not visible on the fetched page - confirm in the operator's Chrome before downloading (Fab EULA allows other engines).
- Rokoko free 263-asset pack (commercial licence VERIFIED), behind an email form; also the 13 fight + 6 martial-arts packs
  (GetUp_WipeBloodfromMouth, WoundedChestFight, FightScene_PersonA/B).
- CMU boxing trials 13_17, 14_01-03, 15_13, 17_10, 79_08, 80_10 (licence the most permissive) - filler punches + footwork.
- Video->mocap: Rokoko Vision free 30 s/month (commercial OK), Move One 30 credits (EULA 7.3 licence to ship, verified).
  Not shippable: DeepMotion free, Plask, Cascadeur free, GVHMR, WHAM/4D-Humans (SMPL weights), LaFAN1, AMASS.

## Where to find the missing moves (in this order)
1. Measure what we own first (dodges/sidesteps/blocks above) with the probe + orbit renders - free, today.
2. Mixamo search in the operator's Chrome: "slip", "bob and weave", "overhand", "haymaker", "pivot", "low kick".
3. Meshy library page (punching / dodging / kicking categories) - the operator linked it (S271).
4. John SQ6 sources (CMU has boxing; licence check per source) and SQ7 generators.
5. Filming recipe for our own boxer (John SQ6 part 3) -> video-to-mocap, for whatever is left.
