# TASK PICS2D1 - the 2D picture test: 12 pair stills from our own 3D, one real round played as pictures beside its 3D film (S539)

Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing (demo). A test only: nothing in the shipped game changes.

## Why
Owner S539: "yes, run the 2D picture test" after ops/research/FIGHTBIZ1_COMPARE.md section 2 + section 4 item 1 (READ BOTH):
The Fight Business draws its fallback fight as one paired picture per exchange (both fighters, the strike at contact) popped in
~1.1 s with a zoom, a flash and an impact burst - no animation. Ours could come from our own 3D: same boxers, no new art seat.
Uses if he picks it: a cheap second view of our settled rounds, and the card game's resolution art (CARDGAME_PLAN_S539.md).
FIGHT ANIMATION METHOD (CLAUDE.md item 8, FIGHTPLAYER2): this adds NO correction layer to scripts/fight3d; it only renders stills
from the v2 player as it ships. The stills inherit today's poses - say so if a pose looks wrong; do not fix poses here.

## Do
1. tools/pics2d_render.gd: our two boxers (the game's own bodies, as tools/fight3d_still.gd / fight3d_play.gd load them), a FIXED
   SIDE CAMERA (memory feedback_before_after_films_s537: fixed side camera, both full bodies), each punch frozen at its contact
   frame for both boxers: jab, straight (cross), lead hook x landed / missed x both corners = 12 stills, plus guard (2) = 14.
   A flat toon look (a simple shader or unshaded + outline pass) on a transparent background, 1024 px. Render on the hidden
   desktop only: `python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080
   --audio-driver Dummy --script res://tools/pics2d_render.gd -- <out_dir>`. Open every still with the file tool and check: both
   boxers whole, head to feet; the glove at the target on landed; clearly short on missed.
2. tools/pics2d_round.gd: take ONE real settled round from the game's own bout path (BoutNight / LiveRound as the result page
   reads it; six 30-second exchanges, scripts/rules/Exchanges.gd:10), map each exchange's lead punch and landed/missed to a
   still (mirror for the other corner if needed), and play it as a Control scene: a picture swap with a 0.24 s pop (0.90 ->
   1.035 -> 1.0), a 0.48 s impact ring on landed, a "MISS" streak on missed, ~1.1 s a picture, the exchange line beside it.
   Record it as a short film on the hidden desktop (the repo's film tool for the 3D, e.g. tools/fight3d_play.gd's capture).
3. The same round as the 3D film from tools/fight3d_play.gd (same seed and round), from the game's broadcast camera.
4. ops/previews/s539_pics2d/: the 14 stills, picture_round film, 3d_round film, and a side-by-side contact sheet (1920x1080).
   `python ops/Tools/review_add.py --stage S539 --rating "test, Claude" --title "2D pictures v 3D: one round" <files>` and
   docs/PICS2D1_RESULT.md: what was made, the days it took, which stills look wrong and why (pose, clipping, camera), what a full
   set (about 40-50 pairs + the card game's other arts) would take.
5. Do NOT ask the owner yourself: report; Claude puts the pick on the board.

## Prior research
ops/research/FIGHTBIZ1_COMPARE.md; `python ops/Tools/prior_research.py still side camera toon render`; memory
feedback_before_after_films_s537, feedback_no_feet_only_stills, reference_godot_queue_batch_and_bodies_s535 (which bodies are men).

## What would a human do?
Shoot a few test photos of both boxers at the moment of contact, flip through them like a comic, and compare with the film.

## Prefab check
Godot's built-in unshaded/toon material and an outline pass; no store asset needed.

## Contract
OWNS: tools/pics2d_render.gd, tools/pics2d_round.gd, ops/previews/s539_pics2d/, docs/PICS2D1_RESULT.md
RED_TEST: tools/pics2d_render.gd (a test render)
REGRESSION: none (no game file changes)
VISUAL: the stills and both films, opened and checked by the worker; the owner picks

## Rules
Work in main. Windowed Godot ONLY on the hidden desktop (tools/hidden_desktop.py), never on his monitors; one windowed render at a
time; headless runs via godot_slot. Watchdog before each render (ops/Tools/pc_watchdog.ps1 -Once; RED = wait). No script over 500
lines. Commit only your paths (stills/films are previews), push. When done run `python ops/Tools/idle_guard.py ok PICS2D1-done`,
report in two lines, stop.
