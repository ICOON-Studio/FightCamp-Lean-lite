# TASK RS3D1 - should Ring Switches use our 3D work, and how (S559, assessment only)

Kind: research. Model: claude-opus-5-5. Discipline: boxing (demo path).
Seat: console worker. Estimate: 1-2 hours. Read only: NO code changes, NO Godot windows (a headless parse or a hidden
render through `python ops/Tools/godot_slot.py run --who RS3D1 -- python tools/hidden_desktop.py run ...` only if a claim
needs a picture).

## Why
Owner S559: "do you think that we could/should use our 3D work we have done so far ?". Ring Switches (the fight-game
direction he loves, `proto/twohands/order.html` and `kick.html`, an HTML page) shows each beat as 2D pictures that are
ALREADY rendered from our 3D: MetaHuman bodies, our takes, the fight stage (`tools/pics2d_set.gd`, `pics2d_anim.gd`,
`pics2d_anim_more.gd`, ~2,500 pictures in `proto/twohands/img/anim`). The game itself is Godot 4.7.2 with a 3D fight
(`scripts/fight3d/`, the v2 player, FIGHTPLAYER2) whose design rule is "the 3D fight never decides - it shows the settled
round" (CLAUDE.md, Week 5). A Ring Switches beat is exactly a settled script of moments.

## Answer, with evidence (file:line), each option's cost in sessions and its risk
1. What of the 3D work Ring Switches uses TODAY (the picture pipeline) and what it leaves unused.
2. Option A - keep baked 2D pictures, re-render from a better camera (CAMPICK1 is building the owner's camera tool).
3. Option B - per-limb masks from 3D beside each picture, so the page can light the limb under the mouse (owner S559:
   "you highlight the arm i move my mouse on ... tubes or circles on the fighters are forbidden").
4. Option C - Ring Switches inside Godot: the rules as a GDScript rule module (they are ~250 lines of JS above the page
   mark in order.html, read by proto/twohands/tools/rules.mjs) and each beat's events played LIVE by the 3D fight player
   (which functions take a punch / block / miss / step; what is missing: kicks, the check, the catch, holds on demand).
5. Option D - a Godot web export of a 3D view in the page (size, load time, GPU on low-end PCs).
6. What a player gains in each (camera freedom, smoother motion, damage on faces) and what is lost (the page's speed,
   the balance tool reading the same rules, the owner's habit of playing the page in Chrome within minutes).
Read the fight3d code in windows (files over 500 lines in parts); never read FightRealtime.gd or GameState.gd whole.

## Output
`ops/research/RS3D1_ASSESSMENT.md`: the six answers, a table of the four options (gain, cost in sessions, risk), and ONE
recommendation with the first step. Plain words: the owner has no development background. Commit by pathspec, push.

## Contract
- OWNS: ops/research/RS3D1_ASSESSMENT.md
- RED_TEST: none (assessment)
- REGRESSION: none (no code)
- VISUAL: none

## Prior research
`python ops/Tools/prior_research.py fight3d player v2 settled round`; docs/RINGANIM1_RESULT.md; ops/research/FIGHTPLAYER2*;
the ## METHOD lines in NEXT_SESSION_PROMPT.md.

## What would a human do?
A technical director lists what the 3D already gives, prices each way of using more of it, and picks the one that
helps the player soonest without breaking the loop that works.

## Prefab check
Not applicable (assessment).

## Feedback loops
None: assessment.
