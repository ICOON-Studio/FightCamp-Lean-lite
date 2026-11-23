# TASK FIGHTBIZ1 - read The Fight Business demo (installed on E:): its 2D fight and its management loop (S539)

Model: claude-opus-5-5 (Code Mode tab). Research only: no game file changes.

## Why
Owner S539: "The Fight Business Demo is installed on e , it has 2d fight and looks intersting". Installed 2026-11-23 04:26 at
E:\SteamLibrary\steamapps\common\The Fight Business Demo - an Electron app (resources/app.asar), like MMA Empire (MMAEMPIRE1).
Two reasons it matters: (1) the owner wants card resolutions animated in the card game (OWNER_CARDGAME_INTERVIEW_S537.md) and
(2) our 3D fight has cost many sessions (FIGHTPLAYER2 METHOD); a cheap, readable 2D fight is a real alternative view to weigh.
Owner rule (global CLAUDE.md 2026-11-04): read-only inspection of the installed files, findings in our own words and numbers,
nothing of theirs (code, art, text) copied, no runtime hooking of online games.

## Do
1. REA read-only (analyze_javascript_application / inspect_artifact on resources/app.asar; extract to the scratchpad): HOW the 2D
   fight is made - sprites vs skeletal (Spine/DragonBones-style rigs) vs CSS/canvas tweening; how many poses/frames a move has;
   how a punch shows hit/block/miss; camera, timing, speed controls; how the fight is SIMULATED (exchange model, stats used) and how
   the picture follows the sim. Then its management loop: what the player decides between fights, money, roster, contracts.
2. Play a short session out of sight (tools/hidden_play.py on the hidden desktop; nothing on the owner's monitors; memory
   reference_hidden_playtest_reference_games_s426): watch two fights, the screens around them. Stills via the hidden desktop only,
   opened with the file tool, into ops/previews/s539_fightbiz/ (git-ignored).
3. ops/research/FIGHTBIZ1_COMPARE.md: top 5 for the owner first (20 lines max), then: their 2D fight technique and its cost to make
   (could WE make a 2D fight view of our settled rounds, or the card game's resolutions, with our clips rendered to sprites or a 2D
   rig - what it would take, in days and tools), their loop vs ours (file:line), what is worth taking with the probe it needs, what
   we do better. Read MMAEMPIRE1_COMPARE.md first so you do not repeat it.
4. `python ops/Tools/review_add.py --stage S539 --rating "reference, Claude" --title "The Fight Business demo: 2D fight" <stills>`.

## Prior research
`python ops/Tools/prior_research.py 2d fight sprite animation management`; ops/research/topics/competitors.md;
ops/research/MMAEMPIRE1_COMPARE.md; memory feedback_rea_first_for_reference_numbers_s439.

## What would a human do?
Play the demo with a notepad, then open its files to see how the fight is drawn.

## Prefab check
n/a (research).

## Contract
OWNS: ops/research/FIGHTBIZ1_COMPARE.md, ops/previews/s539_fightbiz/
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Rules
No Godot. Never open a window on his monitors. Commit only your paths, push. When done run
`python ops/Tools/idle_guard.py ok FIGHTBIZ1-done`, report in two lines, stop.
