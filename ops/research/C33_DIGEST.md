# C33 — The bout that was not watched on a card

Settlement now files `BoutRead.capture_pending(pending)` on the new history row in `_apply_fight_result`. It reuses the existing capture shape, retains frozen cards/type/style, prefers playback winner/rounds, and otherwise derives winner from the booking athlete's result. Range is explicitly absent. Existing history is never backfilled; watched-card capture is unchanged.

Validation: parse 3/3; bout read 22 checks, 0 failures; post-fight read 16/16; scorecard read 11/11; playback 39/39; Contender Series and smoke zero failures. Full suite run once: 147 tests, 140 without error diagnostics, six UI tests with zero assertion failures but shutdown resource-leak errors (career_goals, day_feed_screen, icon_kit, skill_tree, ui_kit_shell, ui_kit), and fight_simulation_test with a script error at line 631 referencing missing BOXING_MIN_ROUND_SCORE despite its printed 233 checks/0 failures. The strict runner reported 140 passed / 7 flagged; the full suite is not clean. These out-of-scope files were not changed, and baseline behavior was not independently rerun.

User authorized this GPT-6 session in place of the task's Sonnet setting. Task-specific no-HANDOFF rule takes precedence over the general HANDOFF-block rule; Claude receives the digest by mailbox.
