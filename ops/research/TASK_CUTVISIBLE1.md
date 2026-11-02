# TASK CUTVISIBLE1 - the cut opens on the boxer's face in the live fight, and the cutman works it on the stool (boxing)

Model: Cursor (cloud). Discipline: BOXING (demo). LAUNCH AFTER PREVIEWLOOK1 (#260) IS ON MASTER (both dress MetaHuman bodies).

## Why
Operator board answer Q-S249-6 (S255): "All three". Ludo r119 (research/ludo_rx/LUDO_R119_raw.txt:65): "If a fighter is hit with
clean power hooks, the player must see the swelling or cut open up on the 3D model, followed by cutman intervention on the stool card.
Without this, the medical simulation feels non-functional." The cut is ALREADY simulated: `FightRealtime.gd` writes
`state[side]["trauma"][brow]["cut"]` pips (0..5) and logs `{"type": "cut", "side", "brow", "pips"}` (:3213-3215, :4015-4035
`_doctor_cut_shot`, cleared :4100); CornerPitStop.gd:216 already says "Cut on the ... - blood is running into the eye." Nothing shows it.

## The route the game runs (trace it, do not guess)
The live bout state -> the 3D fight view (`Godot/scripts/FightStagePlayer.gd`, MetaHuman bodies dressed by FighterKit) and the corner
minute (`CornerBreak.gd` / `CornerPitStopPanel.gd`). Find where FightStagePlayer reads per-tick state for each side and hook the cut there.

## Files you own
1. NEW `Godot/scripts/CutMark.gd` - applies a cut to a MetaHuman head: a `Decal` (or an overlay material pass on the head
   surface) at the brow named by the sim (`left_brow` / `right_brow` - read the exact keys from FightRealtime), size and redness scaled by
   pips (1 = a small red nick + light swelling, 3 = an open gash with a thin blood line down toward the eye, 5 = worst), cleared when pips
   return to 0. Anchored to the head bone so it moves with the head. Swelling = a small scale on a brow/cheek bone or a normal-map
   bump - no new sculpt, no new mesh.
2. EDIT `Godot/scripts/FightStagePlayer.gd` - one call per state update: `CutMark.apply(head_node, skeleton, trauma)` for each side.
   Name the line window in the PR.
3. EDIT `Godot/scripts/CornerPitStopPanel.gd` - when the worst cut has pips >= 1, the stool card shows the cutman
   (`res://assets/models/metahuman/mh_staff_cutman_1.glb`, already in the repo) working the brow: a small SubViewport portrait, cutman
   beside the seated boxer's head, plus the existing cut job card. No new animation - pose him with an existing staff/ActionForge idle.
4. EDIT `Godot/scripts/GameSwitches.gd` - key `cut_visible` in `GAME_ON` (operator S221: new features ship ON); `--script` tests = OFF arm.
5. NEW `Godot/tests/cut_visible_test.gd` (OK/FAIL lines; ends `print("CUT_VISIBLE failures=%d" % failures)`): a bout state with
   left_brow cut 3 -> that side's head carries a CutMark node at the left brow (within 4 cm of the brow bone), redness/size grow from pips
   1 -> 3 -> 5, gone at 0; the pit-stop panel with a cut holds the cutman node; switch off -> no CutMark. Red on master first.

## Acceptance
- `tests/cut_visible_test.gd` + the cut tests that play the game path (`grep -l "_doctor_cut_shot\|cut_scar" Godot/tests`, at most 6)
  pass; PR body: RESULT lines + the line windows edited.
- Claude takes the stills on the live fight's own camera (`record_room ... as_game`, still_framing save_if_framed) in guard AND mid-move
  with a 3-pip cut, plus a close crop - you cannot see images; report the decal positions in metres from the brow bone.

## Prior research
LUDO_ROUND17_S193.md s4 (cut + scar), TASK_CUTSCAR1A.md, CutsDoctor.gd (LUDO-DOC1), CornerPitStop.gd (S97 pit stop), LUDO_LOOPS_S188 Q1.5.

## What would a human do?
On TV you see the cut open after the hook, the camera finds it between rounds, and the cutman presses the enswell and swab on it on the
stool while the trainer talks.

## Prefab check
Cutman MetaHuman already in the repo; Godot `Decal` is built in. No blood VFX pack needed for a nick/gash decal (CC0 decal textures on
ambientCG/Poly Haven if one is wanted - name the licence).

## The one trap
Do not change the cut SIMULATION (FightRealtime's pips/odds/stoppage) - only show what it already decides.

## S266 launch note (Claude)
PREVIEWLOOK1 is on master (1a60d6b1) - go. `FightStagePlayer.gd` is under active edit by the Ziva seat (branch ziva/playtest:
guard IK hand-over, foot re-pin, head level). Keep your edit there to ONE call site plus the helper in CutMark.gd, and name its
line window in the PR body - Claude merges that file by hand. Do not touch `_guard_ik_pass`, `_guard_body_pass` or the foot lock.

## Contract
OWNS: Godot/scripts/CutMark.gd, Godot/scripts/FightStagePlayer.gd, Godot/scripts/CornerPitStopPanel.gd, Godot/scripts/GameSwitches.gd, Godot/tests/cut_visible_test.gd
RED_TEST: Godot/tests/cut_visible_test.gd -> CUT_VISIBLE failures=0
REGRESSION: cut_visible_test
VISUAL: yes
