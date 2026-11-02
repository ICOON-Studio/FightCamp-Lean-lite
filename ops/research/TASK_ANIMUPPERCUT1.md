# TASK ANIMUPPERCUT1 - the inside uppercut done right at chest-to-chest range (IK layer + the C224 gate as acceptance)

Model: gpt-6.1-sol (Codex, animation). Keep fixing and re-running until the acceptance is green - there is NO two-run limit. Only if
sol cannot finish the whole task does Claude re-run it on astra (operator S206: "astra for super hard animation tasks that sol fails").
Approved: operator board Q-S204-1 "build it all with your corrections" (Ludo r38 s6; verdict LUDO_ROUND38_VERDICT_S204.md item 3).

## The defect
`boxing_inside_uppercut` (Cascadeur C231, `Godot/scripts/FightClipBinding.gd` ~line 81) is WITHHELD from the demo:
`assets/data/certified_moves.json` line 43 quotes the operator (S138) - "this video is terrible": at 1.07 m between pelvises the arm
swings UP OVER the opponent's head into his face. It passed the numeric C223 gate but is visibly not an uppercut.
The gate that sees it now exists (merged today): `Godot/scripts/animation/UppercutGate.gd` - `evaluate(frames, contact_t)` fails
"over_the_head" (hand above the opponent's crown), "elbow" (elbow at contact outside 82-98 deg), "miss" (hand > 0.12 m from the
chin at contact), "range" (pelvis gap outside 0.9-1.1 m). Frames: {"t","shoulder","elbow","hand","opp_crown","opp_chin",
"opp_pelvis","att_pelvis"} in world space.

## Spec
1. NEW `Godot/tools/c224_uppercut_gate.gd` (SceneTree tool, windowless OK): builds two DIFFERENT legal boxing pairs the C223 gates
   use (find how `Godot/tools/` C223 gate scripts build their pairs - `ls Godot/tools | grep -i c223`; reuse, never identical
   fighters), stands them at the inside-range distance the fight uses for this move, plays boxing_inside_uppercut through the real
   FightStagePlayer, samples the attacker's right shoulder/elbow/hand and the defender's crown (head bone + scalp offset, the rigs
   have no head-top bone) / chin / pelvis every frame (skeleton updated first), and prints `C224 pair=<a>v<b> pass=<bool>
   reasons=[...] peak_above_crown=<m> elbow=<deg>` per pair + `C224 total=N fails=M`. FIRST run it on today's master: it must FAIL
   with "over_the_head" (record the numbers in your summary) - that proves it sees the defect.
2. The fix, behind a NEW switch `anim_inside_uppercut_ik` on FightStagePlayer (default OFF; OFF = byte-identical pose): a pose layer
   applied ONLY while boxing_inside_uppercut plays, in the same post-animation pass the other human/anim layers use (see how
   ANIMFATIGUE1's pass and the HUMAN1 additive layer are applied in FightStagePlayer.gd - `grep -n "anim_fatigue\|human_hit_additive"`
   and read those windows only). Ludo r38 s6.2 (`research/LUDO_ROUND38_S204_reply2.txt` lines 320-416) is the starting spec:
   knee dip, hip drive, elbow held near 90 deg, the glove's path rising INSIDE the opponent's guard to the chin - a two-bone IK on
   the right arm toward a target that rises from the attacker's chest line to the opponent's chin, never above his crown.
   Nothing may move the root or the feet (our rule above Ludo's code).
3. With the switch ON the tool passes for BOTH pairs (no "over_the_head", elbow 82-98 at contact, hand within 0.12 m of the chin).

## Acceptance (tier: tool + edited script)
- `c224_uppercut_gate.gd`: master (switch OFF) -> FAIL over_the_head for both pairs; your branch with the switch ON -> `C224 total=2
  fails=0`. Print both runs in your summary.
- NEW `Godot/tests/inside_uppercut_ik_switch_test.gd`: switch OFF -> every bone pose identical to a run without the feature
  (30 sampled frames, two different fighters); ON -> root and both foot bones identical to OFF on every frame (only arm/spine/legs
  above the ankle may change).
- Then `python Godot/tools/run_tests.py --jobs 1 --only certified,fight_stage_playback,fight_stage_technique,intent_bus,bench1` -
  nothing that was green may go red. Do NOT add boxing_inside_uppercut back to certified_moves.json: it returns to the demo only
  after the operator's OK on Claude's game-camera video.
- Parse every touched .gd first; run with `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe"` (never the _console exe).

## Owned files
- `Godot/tools/c224_uppercut_gate.gd` (NEW)
- `Godot/tests/inside_uppercut_ik_switch_test.gd` (NEW)
- `Godot/scripts/animation/InsideUppercutIK.gd` (NEW, if you split the maths out)
- `Godot/scripts/FightStagePlayer.gd` (only: the switch var + the layer call in the post-animation pass)
- `research/ANIMUPPERCUT1_DIGEST.md` (NEW)
Read-only: UppercutGate.gd, FightClipBinding.gd, the C223 gate tools.

## Prior research
LUDO_ROUND38_S204_reply2.txt s6 (diagnosis + Ludo's IK controller + his C224 test), certified_moves.json line 43 (the operator's
words), C231 notes in FightClipBinding.gd ~79-87, topics/striking.md.

## What would a human do?
An animator fixes a broken uppercut with arm IK toward the chin and a small knee dip, keeping the authored feet and timing.

## Prefab check
Godot's SkeletonIK3D is deprecated in 4.x; a TwoBoneIK3D modifier or a hand-written two-bone solve both work - prefer whatever
FightStagePlayer already uses for arm targets (grep "IK" in it first).

## The one trap
The crown check is a HEIGHT test: sample the defender's head bone AFTER the skeleton updates, add the scalp offset, and compare y.

## ROUND 2 (S207, Claude) - the brief named the wrong arm; corrections that OVERRIDE the sections above
Your round 1 (679003b7) was right to stop: `clip_phases.json` gives `boxing_inside_uppercut` effector **LeftHand** (it is warped from the
LEAD uppercut source), and the gate sampled the right arm - so crown peak 0.000 and chin miss 0.84 m measured the idle hand.
1. `c224_uppercut_gate.gd` reads the striking arm from `clip_phases.json` `effector` (LeftHand -> LeftShoulder/LeftForeArm/LeftHand,
   use the bone names the rig really has - grep how C223 tools map an effector to its arm). Never hard-code a side.
2. Re-run the master witness (switch OFF) with the lead arm. Red-first now means: master FAILS the gate for both pairs, any reason.
   Record the reasons and peak_above_crown / elbow / chin-miss / pelvis-gap per pair. "over_the_head" is expected but NOT required.
3. If the pelvis gap the fight uses for this move is outside UppercutGate's 0.9-1.1 m band, stage them at the gap the fight really
   uses (grep FightWorldLiveScreen / the planner for the inside range) and report it; do not edit UppercutGate.gd.
4. The IK layer drives the SAME arm the clip strikes with (the effector), target rising from chest line to the opponent's chin.
Everything else (switch default OFF + byte-identical, root/feet untouched, switch test, run_tests line, no certified_moves edit) stands.
