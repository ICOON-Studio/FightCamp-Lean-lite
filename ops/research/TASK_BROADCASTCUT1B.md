# TASK BROADCASTCUT1B - the live fight camera cuts on big hits (wire BroadcastCut behind a switch) (S207)
Model: Cursor (Godot gameplay). Worktree E:\FightCamp\wt\BROADCASTCUT1B, branch cursor/broadcastcut1b.
Approved: operator board Q-S205-2 "keep Godot, take the 4 ideas" - idea 2 of his Game Notes sheet (cut on a significant hit).

## Prior research
TASK_BROADCASTCUT1A.md (the rules), GAME_NOTES_SHEET8_REVIEW_S206.md idea 2, topics/camera_broadcast.md.
## What would a human do?
A TV director holds the wide broadcast angle and cuts to a tighter or reverse angle on a knockdown or a big clean shot, then back.
## Prefab check
The rules exist: `Godot/scripts/rules/BroadcastCut.gd` (merged S207, 42/0, pure). The game already has a hit cam (Q149,
`_feed_hit_cam` in FightWorldLiveScreen.gd ~line 5041) - read it first; the new cut must not fight it (when the hit cam fires, the
cut waits).

## Spec
1. `Godot/scripts/FightCameraRig.gd` (199 lines): add the two shots BroadcastCut may choose, both keeping BOTH men head to feet:
   "broadcast_tight" (the broadcast shot about 20% closer, same height band) and "reverse_broadcast" (broadcast mirrored to the
   other side of the ring, z -> -z).
2. `Godot/scripts/FightWorldLiveScreen.gd` (6,590 lines - grep-found windows only): NEW switch `broadcast_autocut` (default OFF;
   OFF = the exact shot sequence of today). Where beats are fed (`_feed_hit_cam(beat)` ~line 2432) call
   `BroadcastCut.next_shot(_cut_state, beat_for_cut, now_s)` and apply the returned shot when it changed (smooth camera move, never a
   jump). Map our beat to its contract: damage, knockdown, contact (ours are "clean"/"glancing"/"absorbed" - only "clean" counts as
   landed big), round_end. Only while the current shot is "broadcast"/one of its two siblings - never override a shot the player or
   a tool picked.
3. NEW `Godot/tests/broadcast_autocut_test.gd`: a scripted bout feed (two DIFFERENT legal fighters): OFF -> shot never changes from
   today's; ON -> a knockdown beat cuts, cuts are >= 3 s apart except knockdowns, round end returns to broadcast, every chosen shot is
   in FightCameraRig's shot table. Must be RED on master first (no switch).

## Owned files
- `Godot/scripts/FightCameraRig.gd` (only the two new shots)
- `Godot/scripts/FightWorldLiveScreen.gd` (only: the switch, the cut state var, the call beside `_feed_hit_cam`)
- `Godot/tests/broadcast_autocut_test.gd` (NEW)

## Acceptance (tier: script edited)
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/FightCameraRig.gd Godot/scripts/FightWorldLiveScreen.gd Godot/tests/broadcast_autocut_test.gd`
- `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/broadcast_autocut_test.gd`
- `python Godot/tools/run_tests.py --jobs 1 --only broadcast,fight_camera,hit_cam,fight_world_live,ludo_camera` - nothing green goes red.

## The one trap
Headless runs have no camera motion to see - test the decided SHOT NAME sequence, not pixels; and keep the switch OFF in every
existing test (tests are the control arm).
