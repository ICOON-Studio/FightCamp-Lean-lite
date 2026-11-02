# S318 digest (2026-10-30) - Lean update 21: the body map live, the number behind each call, a clean clinch

Working commit: Lean 6b51aa5 (main, pushed). Board question for update 21: Q-S294-32.

## What now works
- BODY MAP LIVE (plan Q-S294-29 "Yes, build it"): `scripts/fight3d/BodyLive.gd` keeps the bout's BodyMap and a
  BodyFigure per boxer in the scorebug; a landed punch takes its points at the glove's contact and the place flashes,
  then holds its band colour (hover: number + last 3 punches). SKIP ROUND builds the unwatched exchanges and lands them
  too (`catch_up`), so the corner card also reads the whole round now (it read only the watched part before).
- CORNER CARD: her big figure + the cutman's one job (enswell a hurt eye / close a cut / nothing), ice eases her worst
  rib side (BodyMap.corner, one round), a SEEN line (the opponent's habit seen most), and the number behind each of the
  eight calls (CallEvidence) on its button. Applied on the pick AND when the minute runs out (CornerMinute.finish).
- CLEAN CLINCH: tools/clinch_probe.gd measured the Cascadeur clinch: it is a cage clinch - the HOLDER's left glove sits
  6 cm above her own head on the other's head all loop (the S317 note had the wrong half). Clinch.gd: the holder's raised
  hand overhooks the other's arm at the elbow; the held boxer grips the holder's FREE elbow (the overhook arm's clip
  elbow is the raised one); both by stance (southpaws play mirrored clips: Maria's raised hand was her right, +0.08 m).
  Shown hand heights after (clinch_still prints them via pose_tap): every glove 7-30 cm under its own head, both ties.
- SMOOTHNESS: a Pro punch's own return to guard plays on 0.3 s (easing to speed 1) before pro_idle; smooth_probe:
  clip changes 173 -> 160/min, pro_idle starts 39 -> 23, ours 462 -> 444/min (at a change 297 -> 256 in 1.8 min).
- COLLECTED: Qwen BODYMAP1 (test 5 rewritten to the brief: real round spread, loser's lowest place, doctor on both;
  Qwen's "contradiction" was the test deriving the winner from landed counts), BODYFIG1 (figure widget), CALLEVIDENCE1.

## Evidence
- Lean tests 36/36 PASS (tools/run_tests.sh, body_map / body_figure / call_evidence added).
- BodyMap calibration (test 5, 300 seeds, 3 rounds x 6 exchanges as the game plays): FACE 1.1 / HEAD 0.55 / RIB 1.5 ->
  loser hurt 74 %, doctor 0 %, winner fine 95 %, head lowest 24 %. The first tuning (5.5/2.75/7.5) was on ONE script a
  round; the live still at round 2 showed Lucy's ribs 32.5 after 1 round - a 6x error caught on the game's own run.
- Stills (game camera): previews/s318/clinch_before_after.jpg, body_map_and_corner.jpg (the scorebug crop is
  from the pre-calibration run - the colours, not the speed).

## Decided (Claude, developer calls)
- Step grace: letting a step start inside a finished step's grace READ WORSE (clip changes 160 -> 212/min, steps came
  sooner) - reverted, noted in Footwork.can_step.
- FightView is at 500 lines (the cap): body map hooks are one line each; the next FightView change moves code out first.
- Agent sweep: Qwen ran 3 tasks this session (BODYMAP1 collected, BODYFIG1, CALLEVIDENCE1); the corner wiring stayed
  with Claude (UI integration across CornerOverlay/FightCast/CallButtons: the brief would be as long as the code).

## Traps
- `check_scripts.py` in the Game repo resolves res:// against the Game project: parse-check Lean files with
  `godot --headless --path <Lean> --check-only --script <file>`.
- hidden_desktop.py writes the game's prints only with `--log=<file>`.
- A pure module tuned on RoundScript alone is 6x off the live game: a 3:00 round is six exchanges, each its own script.

## Next (roadmap now)
1. Q-S294-32 (update 21) on the board; the operator plays it.
2. Smoothness: steps are now the biggest clip-change source (advance/retreat ~100 starts per 1.8 min); kinks inside
   clips (559 of 815 ours) are layers - run smooth_probe control arms (noguard/noreach/...) to find which.
3. FightView over the cap: move the beat-firing switch (_fire) into its own file before the next feature there.
4. SHOVEL1 short hooks/uppercuts up close; Begin-fight stall recheck in the exe.
