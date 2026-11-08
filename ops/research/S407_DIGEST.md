# S407 digest (2026-11-08)

## What now works
- The Money page is in the game, built from docs/mockups/s403/money.png (PR #100 plus fixes on main). Price tags show the weekly net before and after, Hire buttons show the price, the in/out bars compare the lines.
- A new build is exported with build notes.

## Evidence
- menu_money, cash_forecast, truth_pass, file_limits, golden_path, plain_words: failures=0 on the Money work.
- ring_feet: the CI failure reproduced with its own signature (0 frames left, step in the air, feet and aim the same distance off) by letting a clip end during the walk; with stage.guard first it arrives in 74 frames.
- Stills of the real page opened by Claude and compared with the mockup: E:/FightCamp/tmp/s407_money/26_money_real.png.
- One sonnet critic: 6/10, before the last fixes, not re-scored (ops/research/S407_MONEY_CRITIC.md).

## Decided (code)
- Theme reads wait for the tree (`ready`); recorded in GDSCRIPT_TRAPS and MENU_BUILD_RULES so later screens get it.
- #101 and #78 are not closed on the S406 numbers: that test could not see the game's guard.
- MMA items stay on Money, against the critic: operator S403, not built = full colour + warning triangle.

## Not done
- The knock-knee is still unmeasured. KNEERAW1 (PR #102) has a flipped raw sign and did not move the read point; KNEERAW2 is running on Qwen.
- MENUWORLD2 is running on Cursor; #99 waits for it.
- Main CI on the latest commit not read at the time of writing. move_tip's failing line will print from now on.
- Open from the critic: warm shell on every screen, small text, overlapping upgrades.

## HANDOFF
Next action: ops/AgentComms/roadmap.json `now.next_action`; full notes at the top of NEXT_SESSION_PROMPT.md.
