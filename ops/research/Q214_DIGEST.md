# Q214 - G147 clipping remedies in the live boxing room

live failing events before -> after (3 seeds): head 6->4, torso 0->0, arm 41->39, leg 7->5

## Before (3 seeds)
| seed | HEAD fail | HEAD worst cm | TORSO fail | ARM fail | LEG fail |
|------|-----------|---------------|------------|----------|----------|
| 94301 | 2 | 7.49 | 0 | 16 | 3 |
| 94302 | 3 | 7.49 | 0 | 16 | 1 |
| 94303 | 1 | 10.34 | 0 | 9 | 3 |
| **total** | **6** | | **0** | **41** | **7** |

## After Step 1+2 (3 seeds)
| seed | HEAD fail | HEAD worst cm | TORSO fail | ARM fail | LEG fail |
|------|-----------|---------------|------------|----------|----------|
| 94301 | 1 | 2.93 | 0 | 15 | 2 |
| 94302 | 2 | 2.90 | 0 | 15 | 0 |
| 94303 | 1 | 10.34 | 0 | 9 | 3 |
| **total** | **4** | | **0** | **39** | **5** |

## What was built

### Step 1: Trunk repositioning during defensive takes
Defensive takes (slip, pull, slip_counter) lean the trunk past the root. The existing root push moves the whole body back, but the trunk is still leaned forward relative to the root. Added a Spine bone rotation step in `_stop_posed_contact()` that detects defensive takes and rotates the trunk backward when it penetrates the opponent's core. Uses `stop_contact_core()` with up to 4 iterations per player.

**Result:** TORSO worst depth dropped 35.49→6.59 cm on seed 94301. ARM and LEG also improved as the trunk repositioning reduces overall body overlap.

### Step 2: Aggressive head protection
Arm/shoulder-to-head penetrations need aggressive correction. The generic `hand_pushes()` under-corrects when the arm is deep in the head. Added an iterative (6 iterations) head-specific correction that applies a 1.5x strength push away from the head surface. Includes shoulder capsules (not just arm/hand class) to catch shoulder-to-head contacts during strike transitions.

**Result:** HEAD failing events reduced 6→4 across 3 seeds. Worst depth reduced 7.49→2.93 cm on seed 94301, 7.49→2.90 cm on seed 94302.

## Gate status
The ceiling gate requires: head 0, torso 0, arm and leg LOWER than before on all three seeds.

**Current status:**
- HEAD: 4 failing (need 0) - remaining events are shoulder/neck-to-head during strike transitions (idle↔jab_body, idle↔rear_hook)
- TORSO: 0 failing - PASS
- ARM: 39 failing (was 41) - seed 94303 unchanged (9→9), not lower on all seeds
- LEG: 5 failing (was 7) - seed 94303 unchanged (3→3), not lower on all seeds

**Gate not met.** Further work would require Step 3 (hit-stop) or Step 4 (blend times), but these risk affecting fight feel and landed-punch counts. The remaining HEAD events are during strike transitions, not defensive takes or landed strikes, making them harder to address without side effects.

## Trap check
The task warns: "a push that moves the roots apart makes every number better and the fight worse (they stop being in range)". The remedies added are posed-bone corrections (Spine rotation, arm bending), not root pushes. The core/core root push already existed and was not modified. The trunk repositioning rotates the Spine bone, not the root. The head protection bends the arm bones, not the root. These corrections preserve the root gap and fight spacing.

## Owned files
- `Godot/scripts/FightWorldLiveScreen.gd` (61 lines added in `_stop_posed_contact()`)

## Reproduce
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/q213_clip_gate.gd -- as_game mode=live seconds=180 seed=94301
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/q213_clip_gate.gd -- as_game mode=live seconds=180 seed=94302
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/q213_clip_gate.gd -- as_game mode=live seconds=180 seed=94303
```

## MERGED S121 (Claude) as its diff onto master (after the S120 body-aim fix and the S121 low-kick stop)
Re-measured on master, same 3 seeds, with `q213_clip_gate.gd` now printing landed strikes + mean root gap:
| seed | head fail | arm fail | leg fail | torso worst cm | landed | root gap m |
|------|-----------|----------|----------|----------------|--------|------------|
| 94301 | 2 -> 1 | 20 -> 19 | 3 -> 2 | 35.49 -> 6.59 | 16 -> 16 | 1.121 -> 1.121 |
| 94302 | 3 -> 2 | 21 -> 20 | 1 -> 0 | 7.30 -> 0.00 | 24 -> 24 | 1.131 -> 1.132 |
| 94303 | 1 -> 1 | 12 -> 12 | 3 -> 3 | 18.74 -> 18.74 | 17 -> 17 | 1.250 -> 1.250 |
Better or equal on every seed and class; landed strikes and spacing unchanged (the trap). GATE STILL NOT MET: head 4
(target 0), arm 51. Focused tests: fight_contact_stop, fight_strike_whole, fight_world_live, q213_clip_gate_contract 4/0.
Owed: stills of the Spine-backward rotation on a slip frame; the remaining head events (idle<->strike transitions).
