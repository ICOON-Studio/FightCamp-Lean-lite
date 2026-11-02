# TASK U176 - CURSOR - FIGHTER B FIGHTS A BOXING BOUT BARE-HANDED
Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S80, 2026-09-25. QUEUED behind the two-agent
cap (Codex C207 + Qwen Q178 at assignment): start when a shell slot frees.

## Why
Codex's C206 control arm (`research/C206_DIGEST.md` line 9; stills `previews/c206/control_off_8s.jpg`
and `control_on_8s.jpg`) proved it: in a BOXING bout (seed 5150, `tools/record_room.gd -- seed=5150 discipline=boxing
shot=broadcast`) fighter A wears red gloves and **fighter B has bare hands**, with the arena OFF as well as ON. That
breaks the operator's standing rule that a fighter must be legal for the ruleset he is in.

## What would a human do?
A technical artist reproduces it, then asks which fighter build path B takes (skin type, model, discipline read) and
why that path skips the glove. They fix the path, not the one seed, and check every discipline and both corners.

## Do
1. Reproduce with the command above (windowed: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`).
2. `Godot/scripts/CCFighterSkin.gd` (316 lines, read whole) builds gloves for CC fighters (lines 19-60: gloves are built,
   styled per discipline, because the meshes have none). Find which skin/model B uses and why no glove is built for it.
3. Fix it so BOTH corners get the ruleset's gloves (boxing / kickboxing / MMA open-finger / none for grappling and
   bare-knuckle), whatever skin each corner uses.
4. Add a test that builds both corners for each discipline and asserts each hand has the right glove (or none). Prove it
   with a mutant (drop the glove on corner B -> the test fails).

## Owned files
`Godot/scripts/CCFighterSkin.gd`, whichever fighter-build file assigns B's skin (find it with `grep -rn fighter_skin
Godot/scripts`; `FightWorldLiveScreen.gd` is 4,4xx lines - NEVER open whole, `sed -n` windows only), new test
`Godot/tests/fighter_gloves_both_corners_test.gd`, `research/U176_DIGEST.md`.

## Gate (tier: script edited)
Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U171`: `git fetch origin && git checkout -B cursor/u176-gloves origin/master`.
Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. Tests: the new one, then
`python Godot/tools/run_tests.py --only fight_world_live,cc_fighter,glove,smoke --jobs 1`. Stills of both corners in
boxing and MMA into `previews/u176/` - look at them. Commit explicit paths, push the branch,
`python Tools/agent_comms.py send --from cursor --to claude --topic U176 --body "<cause, fix, tests, stills>"`.
Do NOT read HANDOFF.md / CURRENT_STATUS.md / HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Do not "fix" it by gloving everyone: a grappling or bare-knuckle bout must stay bare-handed. Read the ruleset.
