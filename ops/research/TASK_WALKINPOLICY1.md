# TASK WALKINPOLICY1 - the office walk-in policy as a pure rules module + test (S235)

Seat: QWEN (small pure module). Worktree given in the launch prompt. Commit on your branch; Claude merges by diff.
Model: qwen3-coder.

## Why (Ludo r97 "Cut 1 Walk-Ins -> Policy Setting", fun 6, cost 9, KEEP)
"Removes high-friction casual click interruptions while preserving gym revenue economy via a simple passive policy toggle in the office."
Today every walk-in stops the floor with greet / trial_session / come_back_later / send_away (Godot/scripts/FloorActions.gd lines ~60-70,
`_resolve_walk_in_*`). With a policy, the office decides once and walk-ins resolve themselves.

## FILE 1: `Godot/scripts/rules/WalkInPolicy.gd`
`extends RefCounted`, STATIC only, ZERO preloads, NO class_name, NO autoload, NO randomness inside (rolls come in as `pick: float` 0..1).
- `const POLICIES := ["open_door", "trials_only", "members_only", "closed_in_camp"]` with a one-line comment each:
  open_door = greet everyone, trial anyone who asks (most income, most floor noise); trials_only = only trial seekers get in, others told the
  sign-up desk; members_only = no trials, greet and sign-up only; closed_in_camp = during a booked fight's last 14 days only members, others
  sent away politely (quiet floor, lost income).
- `static func resolve(policy: String, visitor: Dictionary, ctx: Dictionary, pick: float) -> Dictionary`
  visitor {"kind": "member_prospect"|"trial_seeker"|"fighter_candidate"|"press"|"curious", "fame_pull": float 0..1};
  ctx {"days_to_fight": int (-1 none), "free_stations": int, "coach_free": bool}.
  Returns {"action": "greet"|"trial_session"|"send_away", "money": int, "member_mood": int, "floor_noise": int (0..3), "toast": String}.
  A fighter_candidate is NEVER auto-sent-away (returns action "greet" with "flag_for_owner": true - the owner sees him in the office).
  closed_in_camp only applies when 0 <= days_to_fight <= 14, else behaves like open_door. trial_session needs a free station, else greet.
  Money: a trial pays a small fee and has a sign-up chance (pick < chance); justify every number in a comment.
- `static func summary(policy: String) -> Dictionary` - {"label", "line", "income": "high"|"medium"|"low", "noise": "high"|"medium"|"low"}
  for the office toggle.

## FILE 2: `Godot/tests/walk_in_policy_test.gd`
`extends SceneTree`, `func _initialize() -> void:`, `load("res://scripts/rules/WalkInPolicy.gd")`, count failures, print
`WALK_IN_POLICY failures=N`, `quit(0 if failures == 0 else 1)`. Assert: every policy has a summary; a fighter_candidate is never sent away
under any policy; closed_in_camp sends a curious visitor away at days_to_fight 5 but greets him at 30 and at -1; no free station -> no trial;
open_door noise >= closed_in_camp noise; resolve is deterministic for the same pick; unknown policy falls back to open_door.

## Gate
Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/WalkInPolicy.gd Godot/tests/walk_in_policy_test.gd`.
Test: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/walk_in_policy_test.gd`
(NEVER the _console.exe). Run tests `--jobs 1` only if you run the runner at all; you should not need it.

## Rules
Touch ONLY these two files. GDScript traps: research/GDSCRIPT_TRAPS.md (typed reads, no `:=` on a Variant, no `%%`). Do not open
GameState.gd. Nothing opens on screen.

## Prior research
GYMFLOOR_MECHANICS_IDEAS_S234.md (Cut 1); Godot/scripts/WalkIns.gd (who walks in, kinds); topics/gym_market.md.

## What would a human do?
A gym owner puts a sign on the door during fight camp - "members only this fortnight" - instead of answering every knock.

## Prefab check
None - pure rules.

## The one trap
A promising fighter walking in must never be turned away by a policy - that is the game's recruit pipeline.
