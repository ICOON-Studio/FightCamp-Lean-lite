# TASK C207 - CODEX - THE WALKOUT, SHOT IN OUR OWN ENGINE (3D lane)
Model: gpt-6-astra, medium (`CODEX_MODEL=gpt-6-astra`), CODEX_WEB off. Owner: codex. Assigned S80, 2026-09-25.
Starts AFTER C206 (arena fit) is merged - it needs the arena and the ring to line up.

## Why
S80 built the fight-night sequence (`Godot/scripts/FightNightIntro.gd`): walkout -> tale of the tape -> bell. The walkout
beat used a generated still, and the operator recognised it: *"i have seen this picture on another game take it out"*.
It was removed (b05f52ab). The operator then asked for the walkout to be made **in our own 3D engine** instead. That is
also the better shot: it is the player's real fighter, in the owned Marpa arena, and it moves.

## What would a human do?
A broadcast director shoots a walkout from a fixed plan: the fighter appears at the entrance, the camera leads or
follows him down the aisle, cuts or cranes to the ring steps, lights hit him, the crowd rises. It is short (5-8 s on
TV for an undercard), and it is about the man, not the building. A game cinematics artist blocks the camera path
first, times it to a walk cycle, then lights it, and checks the frames for anything that reads as a stock shot.

## Do
1. **Scene.** In the owned Marpa arena (`Godot/assets/venues/mma_arena/mma_arena.tscn`, C205/C206), find the entrance
   (`EntranceField`, `SecondFloorBigEntrance`, `SeatEntrance`, `Stairs` meshes) and lay a path from the entrance to the
   ring/cage steps. Our fighter (the CC/Tripo fighter the fight uses, in his fight kit - no robe needed) walks it.
2. **Walk.** The owned RamsterZ pack only has guarded fight-stance steps (`H2H_WalkForward*`, `H2H_RunForward*` in
   `Godot/assets/anim/audition/ramsterz_h2h/`). Use the most upright forward walk there and slow it; if it reads as a
   fight stance, generate ONE single-body relaxed walk with Higgsfield text-to-motion (kimodo, ~0.1 credit; you may
   spend up to 5 credits here, ledger `python -m Tools.higgsfield.budget`), retarget it the way C198 clips are, and
   say which you used. Feet must not slide: measure foot speed vs root speed like the earlier plant probes.
3. **Camera.** 5 s, 30 fps: start in front of him at the entrance mouth (face lit, three-quarter), dolly back as he
   walks, end on him reaching the steps with the ring lights behind. **Do NOT frame him hooded, from behind, walking
   down a tunnel toward light** - that is the composition the operator recognised from another game.
4. **Hook.** Make it the `walkout` beat in `FightNightIntro.gd`: when `spec.long` is true, mount a SubViewport that
   plays the shot live instead of loading `WALKOUT_STILL`, keep the name/record text and the "On the line tonight"
   plate over it exactly as the still version drew them, keep skip (Space/Enter/Esc/click). When the 3D path is
   unavailable (headless, missing assets), skip the beat as today - never show a grey box.
5. Record it: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/capture_fight_intro.gd --write-movie <ABS>.avi --fixed-fps 30 --resolution 1920x1080 --quit-after 540`
   (extend the tool so the sample spec plays the 3D walkout). Put the MP4 and 3 stills in `previews/c207/`
   and LOOK at them before the digest says anything about them.

## Owned files
`Godot/scripts/FightNightIntro.gd` (read whole, ~330 lines), new `Godot/scripts/WalkoutShot.gd` (+ scene if you need
one), `Godot/tools/capture_fight_intro.gd`, any new clip under `Godot/assets/anim/`, `research/C207_DIGEST.md`.
Read-only: `Godot/scripts/FightNightScreen.gd` (1,400 lines, NEVER whole - `grep -n _intro_spec` and read windows).

## Gate (tier: script edited)
Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-C203`: `git fetch origin && git checkout -B codex/c207-walkout origin/master`.
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. Then
`python Godot/tools/run_tests.py --only fight_night,setpiece,smoke,venue_art --jobs 1`. Commit explicit paths, push,
`python Tools/agent_comms.py send --from codex --to claude --topic C207 --body "<clip source, foot slide number, tests, preview paths>"`.
Do not end on a question. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open:
root RESEARCH_INDEX.md (G102_FIGHT_HYPE_SEQUENCES.md and M34_PITCH_PRESENTATION.md section 4 are the brief for the beat).

## The one trap
A walkout that reads as a stock shot is the failure the operator already caught once. Judge your own frames against
"could this be a screenshot from another fight game?" - if yes, move the camera, not the lights.
