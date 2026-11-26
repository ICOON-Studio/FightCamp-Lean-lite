# S560 handover (written 2026-11-26, S559 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S559_DIGEST.md`.

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE (owner S553, S555). The pages: `proto/twohands/order.html` (boxing, the
  source), `kick.html` (kickboxing, S559), `head.html` (head movement, S559), `body.html` (the lit-limb toy). The rules sit
  above each page's `// ---- the page` mark; page look below it and in ring_ui.js / body_ui.js.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555). A change is a tweak file first
  (`"page": "kick.html"` names the page); `node proto/twohands/tools/balance.mjs table` + `play n=84` / `balance_batch.sh`;
  rules_test 36, kick_test 12, head_test 11, page_parse, page_play_test 4. Never edit a page's rules while a run reads it.
- ## METHOD - THE FIGHT MUST BE SEEN: HIS CAMERA (S559 #16, raised 31 deg, from the side; tools/pics2d_camera.json), one
  fixed ring camera (RINGCAM1), the page slides the picture for red's steps (ring_ui.js). Every render takes south=blue.
- ## METHOD - ONE ART AGAINST ITSELF FIRST (owner S549, S559 "Yes, kickboxer first").
- ## METHOD - CONSOLE WORKERS IN PARALLEL (owner S559 "use more console workers in parallel if needed"): up to 3 at once
  through `ops/Tools/claude_cm.ps1` in terminal tabs; the Workflow / Agent tools are refused (his S541 rule). Every brief:
  commit by pathspec, `git diff --cached --stat` first (S559: a worker swept 8,200 files into a commit).
- Appended comments are `/* */`, never `//` (S559: twice a `//` swallowed the rest of a line of code).

## RUNNING AT THE HANDOVER (collect first)
1. HEADMOVE1 measure - DONE after the handover: 8 of 9 bars; the jab lands 65% (order.html 76-81%: the best yet on the one failing bar), the lead uppercut 66%; slip 9% / lean back 6% / slip in 3% / roll 3% of beats; stoppages 11%. Next: a small tweak to pass 9 of 9, then put head movement on the page (his call: it changes every bout). File: `E:/FightCamp/tmp/s559_head/head_base.txt` (balance_batch, page head.html). Read the 9 bars and
   how often slip / roll / lean back / slip in are used; the jab-lands bar (76-81% on order.html) is the one to watch.
2. Kick fixes C and D (start when 1 ends): `E:/FightCamp/tmp/s559_kick/kick_fix_c.txt`, `kick_fix_d.txt` ("standing your
   ground checks the low kick"; D also head kick at Mid only). A, B were 4 and 6 of 9 (S559 digest).
If a background shell is gone, rerun: `N=56 sh proto/twohands/tools/balance_batch.sh <out> ops/research/s558_balance/<f>.json`.

## FIRST (his asks still open)
1. PUNCHER'S CHANCE (owner S559): brief `ops/research/TASK_PUNCHCHANCE1.md` - measure it (comeback count first).
2. Head movement: after its measure, the pictures from OWNED takes (HEADART1_SOURCES.md: Punch PRO dodges / weaves / pull
   are on our MetaHuman already) - a console worker, through the picture tools on his camera.
3. The ghost step / never-still bounce (BML1 catalogue items 1, 3, 10; the IUAB6rrzBLA short): steps glide front foot first,
   a light bounce between beats.
4. Layers: one man per clip + the guard joint (BML1 "perfect clips"), building on MASK1's per-limb layers.
5. Body view: MASK1 lit limbs are on body.html - send him the link; his 4 interview questions (menu place, highlight look,
   his limbs, torso) were never answered: ask on the board.
6. Kicks: pick the kick version that holds 8 of 9; then the boxer v kickboxer measure (noKick on one man), then
   DESIGN_PROGRESSION1's P1-P4.
7. Five pictures failed their gates in the re-render (red_clinch arm through a torso; two missed-kick stills cut at the
   frame edge - RENDERFIT1 replaced them: read RENDERFIT1_RESULT.md "Kicks"); check what the page shows for each.

## Waiting on the owner (board)
- Q-S294-337 the pull counter on the page (8 of 9, jab 68%).
- DESIGN_PROGRESSION1's 3 questions (Sharp upgrade choice; a fight plan picks moves; 4 attributes on the board).
- His play of the pages on his new camera (order.html, kick.html, head.html, body.html at http://127.0.0.1:8797/).

## Seats
Console workers only (claude_cm.ps1). The page server runs in a terminal tab: `python proto/cardgame/serve.py 8797 twohands`.
Ziva's editor plugin lost its backend (his screenshot S559): Ziva idle; update it before its next playtest.

## Model for S560
Opus, medium effort, Fast off - lots of collecting and briefing, console workers do the heavy parts.
