# S410 digest (2026-11-09)

Fighters and bout offers built in the look he picked, Q-S294-134: "Build it like the right, painted surfaces".
Fighters > Roster: full-body cards on a painted gym (scripts/ui/RosterCards.gd, scripts/rules/RosterFlag.gd). Weight class and rank, one corner flag (Set camp, Offer, Weight, Mood low), condition / mood / weight tiles, next fight and days to it. Scouted strip with Invite to a trial. Cards / Table switch keeps the sortable table. 38 full-body renders in assets/ui/art/fullbody (each boxer in both kits).
Bout offer: a versus screen (scripts/ui/VersusPanel.gd), the old page is its Full report. Shows only what the game holds: no venue, last five or reach, and no scouting before accepting.
Dark top bar on every page (UI.TOP_BAR, Shell._on_dark). MenuFx.set_wall swaps the picture behind a page; Shell clears it each render.
Critic: one blind sonnet before the fixes: Fighters 7 look / 6 options, versus 7.5 / 6.5, no hard fail (ops/research/S410_LOOK_CRITIC.md: taken, not taken, what stays open). Not re-scored. Not played by him yet.
move_tip was a real fault: over a whole pass of the clip the bodies read 63 to 315 of 300 px and only 45 of 150 frames were clean; the old check read one moment. Now 150 frames, MoveStudio.LOOK_Y 0.71 -> 0.24, 150 of 150 here (15 to 277). Only the one-two is measured.
file_limits: WorldCompare.gd was 501 by the test's count, a blank line removed.
THE STRAY MERGE: the session-start git pull merged PR 106 into local main. A background job's explicit-ref fetch landed in FETCH_HEAD during the pull. Caught from the merge summary, undone with reset --keep before any push (no work lost). Nine tools now fetch with --no-write-fetch-head (b1813039, ops/WORKFLOW.md s7).
Animation: HITREACT2 collected by diff, PR 116 closed. The loss is real on a matched clip (hook_v5: source 0.229 m, game 0.109 m, peaks 2 frames apart). Its "stage" table was source, a body ratio and the clip, so the cause it names is unproved. HITREACT3 (Qwen, running) runs the conversion stage by stage with matching clips as the control.
Fighter model: PR 117 (4D) made one speed change; plan_bots still 2 red, timing tables not in the body. FIGHTERMODEL4E (Cursor, running, base 4D) finds the term that narrowed the plan's lead.
Held menus (MENUHOME2, MENUWEEK2, MENUPLAYBOOK2B, MENUFIGHT1B) stay held: they need a painted concept and his yes first. Concepts made, on the board. MENU_BUILD_RULES items 14-18 carry the look.

Evidence: versus, roster_cards, roster_flag, roster_summary, playtest_s375, kit_icon, plain_words, golden_path, first_hour_walk, offer_gone, grey_reason, guide_ends, move_tip, file_limits tests green; both screens rendered and opened by Claude. boxer_footwork was not touched and is still expected red on main's CI. Main's CI on these commits not read.

HANDOFF
Working commit: 3feaafe6 on main, pushed (the wrap-up commit follows it). Build exported to Builds/.
Remaining: his play of the build, his call on the painted concepts; collect HITREACT3 and FIGHTERMODEL4E; read main's CI and the first full 05:00 test run (11-10).
Exact next action: roadmap now.next_action; details in NEXT_SESSION_PROMPT.md, S410 block.
