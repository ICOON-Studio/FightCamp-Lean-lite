# RUNESTEP1 - the step mechanic in Rune Coliseum, and does its logic fit Ring Switches (S558)

Kind: research (a reference-game study; nothing is built)
Model: the worker's own. Discipline: boxing (the main line, Ring Switches).

Owner, 2026-11-25 (S558), verbatim: "can you check the step mechanic included/or required in some moves on the game
RuneColossieum(installed on e:) , play it in the background you can use any saved games i have ,i do not care and try
see if its logic fits our switch/card game ."

## What to find out
In Rune Coliseum some moves INCLUDE a step or REQUIRE one. Find, by playing it and by reading its installed files:
1. Which moves carry a step (forward, back, side) as part of the move, and which cannot be used unless the fighter has
   stepped / is at a given distance. Ten or more moves in a table: name, step it includes or needs, range before and
   after, cost, what happens if the step is blocked or the opponent moved first.
2. How distance works there: how many places, who decides when both move, whether a step takes a slot in the queue,
   whether a step can be interrupted, whether stepping costs stamina or time.
3. How the player is TOLD (the words and pictures on the move card, the preview before he commits).
4. Three fights played to the end, with the beats where a step decided the exchange (screenshots saved).

## Then: does it fit OUR game
Ring Switches (`proto/twohands/order.html`, how to play it in words: `node proto/twohands/tools/play_cli.mjs help`;
what five agents said after playing it: `docs/RINGSWITCH_S558.md`). Today: three switches a beat (lead hand, rear
hand, feet) thrown in an order over three moments; feet = step in / hold / back off, a separate switch costing 1
stamina; a step in beats a back off in the same moment; three ranges. S558's playtest found: the players backed off 8
times in 366 beats, Long is a corridor every round opens with, and "walk in" is every round's first beat.
Answer in a table: for each Rune Coliseum step rule - what it would be in Ring Switches (a punch that carries its own
step? a punch that needs the step in the moment before? a lunge that reaches one range further and leaves a hand
out?), what it would fix of the list above, what it would break (the order, the three-switch idea), and a tweak file
sketch for the three best (the format: `ops/research/s558_balance/*.json`; check with
`node proto/twohands/tools/tweak_check.mjs <file>`; do NOT edit order.html and do not run balance.mjs table).
Rank them. Say plainly if none fits. Our earlier verdict on this game ("a queue laid blind is a guess or a lookup":
`ops/research/CARDREF1_REFERENCE_GAMES.md` section 10, written when the game was NOT installed) may be wrong: test it.

## How
- The game: `E:\SteamLibrary\steamapps\common\RuneCollseum\RuneCollseum.exe` (Unity, 15 GB). Play it OUT OF SIGHT with
  `python tools/hidden_play.py` (its docstring is the manual; `start` runs in the background as the keeper; `wins`
  before each stage - exit 1 means something is on a visible monitor: `stop` at once). Unity: add `-screen-fullscreen 0
  -screen-width 1600 -screen-height 900`. Never click Discord / forum / store links. No sound device needed.
- Saves: the owner said any save may be used and he does not care. Still copy the save folder to
  `E:/FightCamp/tmp/runestep1/saves_backup/` before the first launch and say in the report what the play changed.
- Reading its files: the `rea` tools (read-only inspection of the installed files: move tables, text) are allowed for
  documentation. Findings go in our own words and numbers; nothing of theirs (art, code, text beyond a quoted move
  name) is copied into the repo. Screenshots stay under `E:/FightCamp/tmp/runestep1/` (not committed).
- PC: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` before the launch; RED = wait.
  If `ArcheAgeChronicles` is running, do not start the game: write what you have from the files and stop.
- Nothing opens on the owner's screens: images with your file tool only.

## Where the result goes
`ops/research/RUNESTEP1_STUDY.md` (verdict first: fits / fits in part / does not fit, in five lines; then the tables;
then a NOT SURE list) and up to three tweak files `ops/research/s558_balance/rune_*.json`. Commit those files only
(`git commit -- <files>`, by path). Last line of your last message: RUNESTEP1 DONE.

## Prior research
`ops/research/CARDREF1_REFERENCE_GAMES.md` (section 10), `ops/research/C17_FIGHT_SCENE.md` (line 235, the 2026-09-06
audit), `ops/research/DESIGN_CARDGAME_SCOPE.md` (the row that rejects it), `docs/RINGSWITCH_S558.md`.

## What would a human do?
A designer plays three fights with a notebook, pauses on every move card that mentions a step, and tries the move from
the wrong distance to see what the game says.

## Prefab check
None: a study.

## Feedback loops
None: nothing is built or tuned; the tweak files are sketches that are checked to load, not measured.

## Contract
OWNS: ops/research/RUNESTEP1_STUDY.md, ops/research/s558_balance/rune_*.json (research files; no game file)
RED_TEST: none (a study)
REGRESSION: none (no game or page file changes)
VISUAL: none
