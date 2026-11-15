# S490 digest (2026-11-15)

## Operator this session
- Board Q-247 (season ladder v3, build after the fight week?): "Show me more first".
- Review comments C403-C406 on the approach card still: "show these instead of telling it" (the Tell-it-straight line),
  "this meters seem confusing to player" (the slanted attribute bars), "not sure about htis wholething" (the whole card),
  "try The Sims meters -like".
- C407 on Training K: "can you show it instead of writing ?" (the "short: one more night" cell).
- C408: coach specialties (head coach, striking, grappling, MMA, S&C) - "have you consider adding specialties on coaches".
- In session: "can you add the training scene here" (the ops board Play row); "do we have a colour pallete ? i see some
  menus lookdifferent than others".

## Built / done
- Ops board Play row: a Training button (launch_targets.json + task "FightCamp Play test training"); jump=training now
  opens the Training tab; the row reads "Straight to:". test_jump_test PASS.
- STEPVALUE1 lines: Why AGAINST YOU "On the ropes N times with no way off." (rounds summed; "once" for one) and the
  corner card HURT row "Put on the ropes ...: a pivot out or a step out gets your boxer off." (CornerCard.card ropes param,
  FightCast + FightNight pass r.ropes). ropes_lines_test PASS; corner_card_test, fight_why_counts_test PASS.
- LIVEROUNDSPLIT1: LiveRound.gd 491 -> 439 (preview, now_offer, combo_words, values, fixes, habit_name -> new
  scripts/state/LivePreview.gd, one-line delegates). file_limits, exchanges, corner_jobs, habit_fix, aim_wire,
  corner_trust, golden_path PASS.
- Test club stills on the hidden desktop: tools/club4_still.gd -> ops/previews/s490/club4 (12 screens), on the review
  board.
- Three brief contract blocks repaired (APPROACH1, PROMISE1, LOYAL3 - its probe moved to tools/). Research index synced,
  Dola's TRAINGAME2 v2 critic committed.

## STYLE5 (Qwen) - collected by hand, NOT as delivered
- Its result doc's counts were model-written ("~1700"); Pressure fighter fired at INSIDE or POCKET and Volume puncher at
  "opponent not hurt" (99% of exchanges = a flat bonus) - both back to the brief (INSIDE; pace == push, the probe's Volume
  cells push in both arms). Its gate-2 code was muddled - rewritten.
- THE REAL DEFECT: the probe's opponents beat the probe fighters 89-99% (control win rate 1-11%) - saturated, no lever
  could show. Calibration mode added (`-- calib=1 scale=<f>`); scale 0.81 -> control 31-62%.
- Calibrated grid (pts as Qwen left them): Out-boxer best +2.5 (in band), Volume +8.5 and Boxer-puncher +5.0 too strong ->
  Volume 2.0 -> 0.8, Boxer-puncher 3.0 -> 2.1, second grid run. (Results: see the commit that merges it.)

## Agents
- Qwen CLASH9 (glove clipping) launched; WHYGRADE1 queued after it.
- Arena ROPESCONTRACT1 (blind contract test of the ropes count + 5 mutants) launched in the browser pane.
- Workflows (Claude's own subagents, ultracode on): the five design tracks (Overview approach card + meters A/B, Training K
  v3 shown not written, COACHSPEC1 map + screens, ladder shown: screen, ask, one season), the colour palette from the gym
  screen, FIGHTWEEK3 piece 1 (the pull-out roll + fall-through card) in a worktree with a fresh review.

## Seat answers
- SQ179 Dola TRAINGAME2 v2: 7 depth / 7 general / 7 play. SQ180 Maria: 6 / 6 / 6 (C and D options already exist as
  plain evening editing; "fires 1 in 2" names a mechanism, not an outcome). Both clear the 6+ bar.

## Late in the session
- STYLE5 final: Volume 0.2 (+3.5 best), Pressure 2.6 (+3.75), Boxer-puncher 2.1 (+3.5), Out-boxer 1.5 (+2.5), Slugger 5.0
  (+2.25, fires 8% of exchanges), Counter 2.0 (+3.5); none best vs all.
- FIGHTWEEK3 piece 1 merged (7db82c87); CLASH9 landed red (third round); WHYGRADE1 launched on Qwen.
- Board: Q-248 approach card A/B/C, Q-249 Training K v3, Q-250 ladder shown, Q-251 palette.
- He played the build: chip over the face, weak tooltips, clipped "Draw the lea", "EYE" label, opponent energy bar,
  coach neck seam, shoulders/walk/see-through bodies -> S491 first.
