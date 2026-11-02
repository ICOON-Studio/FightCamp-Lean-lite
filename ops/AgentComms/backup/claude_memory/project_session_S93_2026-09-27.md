---
name: project-session-S93-2026-09-27
description: S93 - generator pilot shipped (FighterLook, same-man portrait, MPFB Root bone broke retarget ~80 deg), Q194 merged, D39 DESK card, Q195 finds Q183 moved the pins, grokbots out of quota
metadata:
  type: project
---
S93 (2026-09-26/27). Generator pilot: `FighterLook.gd` (id -> seed -> weights + CC0 skin) and `FighterPortrait.gd`
(card = studio render of the same seeded man, test-asserted). Found by LOOKING at the render: `age_young` 0.28 made
15-year-olds; macro keys changed stature (skeleton ignores blend shapes -> normalise to basis height); MPFB's `Root`
bone rests at -90 X and FightClipRetarget assumes Hips is root -> ~80 deg wrong until Root was dropped (then 0.7-0.95
deg vs source, f01 0.6). The instrument that proved it: compare each rig to the SOURCE clip, not rig to rig.
MPFB pilot is true metres, lift 0 (f01 0.925). Makehuman mirror files2 crawls; `files.makehumancommunity.org` is fast.
Q194 merged after re-measuring hashes myself (Qwen's "everything fails on master" was a stale worktree).
Nightly-green tests judge_panel/fight_realtime/grapple_adapter red on master: Q195 bisect -> 4f789137 Q183.
Grokbots out of quota (see [[project-shell-less-agents-unavailable]]). S94 = gym props on Tripo Pro.
