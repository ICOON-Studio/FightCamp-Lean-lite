# TASK Q104 — QWEN — DOES THE HIT MAN'S HEAD GO THE WAY THE PUNCH PUSHES IT?

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q104-reaction-direction` - Claude creates it from `master` before launch. Push the BRANCH. Stage: S4a (operator,
2026-09-14: "reactions need syncing").

**Test tier: A NEW TOOL ONLY, NO PRODUCTION SCRIPT EDITED.** Parse gate on the new `.gd`; the tool run; no
`run_tests.py`. `python research/Q104_check.py` must exit 0 before you commit. **IF THE CHECK FAILS, DO NOT COMMIT
AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_reaction_direction.gd` - NEW.
- `research/Q104_reaction_direction.json`, `research/Q104_REACTION_DIRECTION.md` (20 lines at most) - NEW.

## Why this exists

Claude found and fixed the reactions' TIMING today (a punch's contact frame now is where the fist is nearest the target;
the head reacts within a frame of the glove arriving - `tools/probe_reaction_sync.gd`). The other half of a reaction
reading as real is its DIRECTION: a left hook turns the head to the right, a jab snaps it back. Our reaction clips are
bought motion capture chosen by body region, not by where the punch came from.

## What to measure

Copy the driving and the per-frame log of `Godot/tools/probe_reaction_sync.gd` (read it whole - it is short and it is
production: the live room, `_process(1/30)`, `bone_world`). Run the realism seeds 94301, 51227, 77003 (3 rounds each).
For every hand-strike contact that probe finds (same definition: the take crossing `_contact_s[take]`), where the
receiver starts `react_head` or `react_body` within 3 frames of the contact frame:
- `glove_dir`: the striker's NEAR glove's (the one nearer the target at contact) world velocity over the 2 frames before
  contact, flattened to the floor and normalised;
- `head_dir`: the receiver's Head displacement from the contact frame to 4 frames (0.133 s) later, flattened and
  normalised; `head_move_m` its length (unflattened);
- `cos` = glove_dir . head_dir (1 = the head goes exactly where the glove pushes, -1 = toward the glove);
- `lateral_sign_match`: for hooks (`hook_lead`, `hook_rear`) whether the head's sideways component (relative to the line
  from striker to receiver) has the same sign as the glove's.

`Q104_reaction_direction.json`: `{"population": {"seeds": [...], "rounds": 3, "fighters": "f01_m_box_welter v f09_m_bare_welter"},
"contacts": {"94301": n, ...}, "by_pair": {"jab -> react_head": {"n", "cos_p10", "cos_p50", "cos_p90", "head_move_m_p50", "lateral_match_share"}, ...},
"rows": [{"seed", "frame", "side", "role", "react_take", "cos", "head_move_m", "lateral_sign_match"}, ...]}`.

`Q104_REACTION_DIRECTION.md` opens with `## DECISIONS`: per punch -> reaction pair, the median cos and the hooks' lateral
match share, and one line on which reactions go the wrong way.

## Commit and send

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD` (exactly
those 3 files); `git push -u origin qwen/q104-reaction-direction`; `python Tools/agent_comms.py send --from qwen --to
claude --topic Q104-ready --body <hash>`. If the check fails: no commit, no push; send `--topic "Q104 BLOCKED"` with the
FAIL lines. Do not edit HANDOFF.md, AgentComms/roadmap.json or any other file. Never `git stash`, `reset`, `checkout .`,
`clean`, `rebase` or `merge`.

## The trap

If you cannot get a number through the live room and `bone_world`, STOP and send BLOCKED - never write your own pose
sampler (Q101 was rejected for exactly that). And a direction from a head that barely moved is noise: the check requires
`head_move_m` to be real movement for the rows it counts.
