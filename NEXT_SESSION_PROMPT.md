# S502 handover (written 2026-11-16 at the end of S501)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.

## S501 in short
- HIS SEVEN PICTURE NOTES C417-C423, all acted on and answered on the review board (two posts, 16:25):
  - C418-C420 "why is the lighting so dimm": the gym photo behind every page (mean 46/255) was shown at 0.68 (~31). Both
    backdrops are lifted in the files (gamma 0.6/0.57, ~85) and shown at `Palette.WALL_EXPOSURE` 1.0; card slate
    #242728 -> #2e3234, tiles #353635 -> #414342; the arena (RingSet) ambient 0.2 -> 0.32, exposure 1.15 -> 1.4. Career
    pages median 48 -> 63 at Largest text (`tools/onelook_stills.gd`, renders `E:/FightCamp/tmp/s501/onelook2`), fight 62 -> 77.
  - C417 "what is this ?": Training's coach row is now PADS / 75 min each (TrainGrid._labels).
  - C421-C423: Training stills re-rendered, circled, plain captions (`E:/FightCamp/tmp/s501/marked`).
- BLIND SCORE on r7 (the current fight: fixed camera, side-on): coach 5/10, animator 4.5/10 (r0: 4 and 4). Both name the
  same top five (roadmap now.next_action lists them with numbers): range + exit, hit reactions sized and on time, defence
  on screen, feet that step, hands home. Files `E:/FightCamp/tmp/fightweek/r8blind` (briefs reusable: new folder name).
  Sheets cut with `tools/film_sheets.py ... --crop 1120:680:400:200` (ffmpeg order w:h:x:y - its help said otherwise, fixed).
- Fixed on the way: the fight's commentary line moved from above the bottom bar (it hid the boots) to under the clock
  (FightHud); body_figure_test (a hit flashes white again, Palette.FULL); palette_guard_test (FightOptions outline);
  cam_line_test (14 red since S500: the drills now run on the fixed lens WITH FixedCam.keep_square and on the TV lens);
  `tools/run_tests.sh` now honours `TESTS="a_test b_test"` (it ran the whole suite before - I stopped it after ~200 tests).

## Seats
- Qwen PRESSFLASH1 (crowd flashes never read as a hit): launched 16:13, `E:/FightCamp/wt/LEAN_PRESSFLASH1`, ETA ~18:00
  (FILMBAR1 took ~1 h 50). Collect by its contract.
- Ziva COACHNECK2 (`ops/research/TASK_COACHNECK2.md`, round 2 of PR 329): sent 16:15 in chat "Fight Film Analysis"
  (http://127.0.0.1:7012/, the built-in browser pane), branch `ziva/coachneck2`. Collect: the two stills on the game camera.
- FILMBAR1 PR 333: NOT merged (film_count_test still red at 13.3 % worst, a real find lost, film_pattern_test red). The PR
  comment is the round-2 spec: compare two rates with an exact conditional test, not a count against a fixed E. Brief
  FILMBAR2 (Arena is free and idle: a good fit, pure module + tests).
- Grok Dev never answered PRESSFLASH1 (run marked retry, moved). Guard damage critics SQ204 (John) / SQ205 (Dola) queued.

## NEXT
Fight motion week day 7: build critic items 1 and 2 first (range + exit, hit reactions sized and on time), measure with the
rulers against r7, film r9, two NEW blind critics. The deal needs 5+ from both.

## PC
The owner was playing ArcheAge (9 GB): memory 87-94 %, RED once (no launch then). One windowed render at a time.
TRAP: every Bash call starts with `cd /e/FightCamp/Lean` (a `cd` elsewhere moves the session folder).
