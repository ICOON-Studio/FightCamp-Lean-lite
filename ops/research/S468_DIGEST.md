# S468 digest (2026-11-14, Claude)

Stage: his C394 marks ("still clipping", four boxes on the seed-4242 rear uppercut film) + the result-page test that hung.

## What now works
- tests/result_tabs_test.gd: failures=0, no hang. Cause: a script error before quit() - the seed-44 sample bout stopped
  walking a planned line into the opponent's game after the S466 card fix, so FixLab had no fix and the test read one.
  The sample is now the first of seeds 44-63 with a line FixLab would rewrite; the no-fix page and the fix button are
  both checked. tools/fixlab_scan.gd prints, per seed, what FixLab finds.
- Glove and forearm clipping: tools/clash_meter.gd (bodies as drawn) + CLASH lines in tools/hit_frame_film.gd.
  Seed 4242: rear uppercut 14 clipped frames (worst 0.074 m) -> 3 (one 0.065 m); lead uppercut 14 (0.085 m) -> 1 (0.024 m).
  scripts/fight3d/GloveClear.gd (true shapes, right of way, draw in, open outward off a landing punch, a blocked punch
  left to the block, read one step ahead), scripts/fight3d/ArmClash.gd (the pass after ElbowClear), BoxerBuild.gd.
  Whole story and what is still open: docs/CLASH2_RESULT.md. Pictures: docs/mockups/s468/.

## Evidence
- Film before/after on the same seed (CLASH lines above); strips on the review board (S468) and sent to him.
- Regression, headless: block_meet 4 (the same four CTRL_LANDED rows as main), hit_frame 10 (main 10), hit_carry 38 (the old rule the same day: 38).
- Build exported 13:50 (Builds/FightCamp.exe), docs/WHAT_TO_TRY.txt S468.

## Not done
- Lead glove height (LANDREACH): cause found (the hit point latches onto a half-eased glove; tools/landreach4_probe.gd),
  no code changed. Steps in docs/CLASH2_RESULT.md and NEXT_SESSION_PROMPT.md.
- GUARDKNEE2 (Qwen) still running at the handover; LIVERPROBE1 queued; LIVERRIBS1 step 4 not started.
- fixlab_scan: plan as written 9 of 40, best change 11 on every sample bout - a plan change barely matters there.

## Delegated this session
- Kalli: club week v6 (SQ115). Qwen: GUARDKNEE2 (in flight from S467). A helper redrew the Miro P0 frame.
