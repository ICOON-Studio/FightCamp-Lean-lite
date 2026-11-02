# TASK OFFBAKE1B (S226) - take the 3 good baked clips; re-author the hook + uppercut in Cascadeur from the new guard

Model: Codex gpt-6-astra, reasoning high. PC seat (Cascadeur + Godot). Worktree E:/FightCamp/wt/ANIMFIX2 (seeded), NEW branch
codex/offbake1b from master; first merge YOUR codex/offbake1 work you need by diff (never whole files). Never master.
Cascadeur access ends 2026-10-27 - this lands before then. Route ANIM_OFFLINE_BAKE (approved, Q-S221-7).

## Claude's ruling on OFFBAKE1 (read OFFBAKE1_DIGEST.md + OFFBAKE1_AB_READBACK.md; Claude opened all 12 stills)
- TAKE natively (switch `native_mh_clips` ON in GAME_ON) for **guard, jab, cross**: wrists 0.19/0.32 deg (from 16-25), tighter higher
  guard, cleaner jab/cross - better than OFF on the game camera.
- DO NOT TAKE **lead hook, inside uppercut**: the native hook turns Miller's head/chest away from Vance; the native uppercut contact reads
  as a crouched guard. These two roles stay on today's retargeted clips (OFF path) until step 2 lands.
- The guard foot roll (~20/23 deg on MH08) is NOT this task (feet = ANIMFIX4 / sole solver); report it, do not touch foot code.

## Do (one change per commit, push every commit)
1. Per-role native selection: the native path resolves only for guard/jab/cross; hook/uppercut resolve to the legacy clips. Prove by the
   RESOLVED clip path per role (test red on codex/offbake1's all-five wiring for hook/uppercut, green after).
2. Cascadeur (hidden desktop): author **lead hook** and **inside uppercut** on the MetaHuman master skeleton, starting AND ending in the
   new straight guard (the baked `mh_guard_pose`), contact frame clear: hook - chest and head stay on the opponent, rear glove at the
   chin, lead elbow ~90 deg at contact, pivot on the lead foot; uppercut - knees dip then drive up, the rising fist under the chin line,
   head stays behind the lead shoulder. Wrist line <= 10 deg at contact. Bake to `assets/anim/metahuman/baked/`.
3. Wire the two new bakes, re-run the A/B on the game camera (`tools/animfix2_pose_room.gd`, seed 930093, MH09/MH08): hook + uppercut
   contact OFF vs ON, plus the guard/jab/cross ON frames as regression. Head facing (nose toward the opponent) is a printed number per
   still, not a description.

## Gate
Parse; `tests/guard_wrist_line_test.gd` (baked) + the per-role resolve test; `run_tests.py --jobs 2 --only
anatomical_pose_layer,fight_clip,stage_player,guard_wrist,native,contact_stop` (`--jobs 1` unless GREEN). Known reds: fight_clip_slice
rear hook, staff_pose; fight_contact_stop is Goose #194's (low kick) - report if it changes.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
Red first (today's hook/uppercut), stills only via the pose room (as_game) + still_framing.save_if_framed; per still gap / noses /
wrists / feet / the defect / bodies; post with `review_add.py --stage S226 --supersedes 2026-10-15_2155_offbake1`. Not "accepted":
Claude opens every still, the operator closes it.

## Rules
godot_hidden.ps1 / cascadeur hidden desktop only, watchdog before every run (RED = wait), explicit git add, no *.import churn, no foot /
mirror code change, never open images or windows on screen. End: OFFBAKE1B_DIGEST.md + AgentComms note.

## The one trap
A hook that "faces the opponent" at contact can still swing the head away a few frames later: measure nose direction at contact AND
at +4 frames.
