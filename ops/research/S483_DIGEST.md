# S483 digest (2026-11-15)

## Shipped
- **MODETELLS1 collected and wired.** Qwen's ModeTells.gd + test (MODE_TELLS PASS fails=0) on main, plus order(), shown(),
  films(). OppFile.tells now puts two of the opponent's modes in the tape order (weapon, top unfree mode, habits, second
  unfree mode, weakness; map PLANFLOW1 v3 4.1). Films = the opponent's bouts, at most 4; a mode with 40%+ of the exchanges
  shows in every film, less in proportion, a half rounding down (so float noise never flips a tie). A mode never on film is
  no tell. The style's main game stays the free tell. Film depth (the corner's read) still counts weapon, habits and
  weakness only, so camp scouting depth is unchanged; FilmEdge's "of" grows 4 -> 6 (answered mode lines count, capped +1.2).
  Chart: + Add an IF shows FOUND: OFTEN/SOME/RARE; the file column shows the band in the value. Golden path step 5 in
  tests/plan_chart_test.gd.
- **Defect fixed:** tests/plan_file_test.gd read the long card for a counter-puncher's weapon; S466 moved counter to
  OUTSIDE (red in the nightly since). Now checks outside, no starter answer, best answer named.
- Tests green: mode_tells opp_file plan_file film_edge bout_read golden_path tell_worth plan_chart tell_wire tape_clips
  tape_room fight_meters week_opp coach_check plan_templates.
- Build exported; WHAT_TO_TRY S483.

## Seats
- Qwen CLASH6 round 2 launched (round 1 commit kept on qwen/clash6-r1; old worktree retired - only .import/.uid noise).
- Goose STYLE2 timed out at 100 min (sleep-waits on a long probe). Partial table: 0.0-0.5 wins in 100 per cell even with
  EFFECTS doubled; Boxer-puncher exactly 0.0 -> a lever that does not fire. STYLE3 (#305) counts each lever where it is
  applied first; a dead lever is reported, not pushed.
- Arena MORNINGS1 (coached mornings + weak spot, club week 3.5) launched on the lite mirror.
- Kalli ladder v2: S482 wrote the brief but never queued it - queued now (SQ169).
- Dola: coaches M1 rendered (left column tightened) and training K built from her layout spec by a helper; both on the
  review board, unscored. K's numbers are still hers; the game's numbers go in before critics.

## Club week v9 (his Q-241 "Yes, build it after the fight week")
CHECKs in ops/research/CLUBWEEK1_V9_CHECKS_S483.md: no shared pad hours in code (each boxer's nights are her own), one
evening class only, the stipend is the sponsorship record (company sponsors are a separate record). Owner questions on the
board: Q-242 pad hours, Q-243 day job, Q-244 leaving, Q-245 loyalty bar or word. Q1 (the tab) waits for the drawn page.

## Lessons
- A brief written is not a brief sent: check seat_queue for the SQ id the handover names.
- The Miro P0 redraw costs ~20k tokens of context each time (the SVG goes out and comes back); it pushed this session to
  the wrap-up mark early. Keep NOW free of hand-made duplicates of seat runs (they are added automatically).
