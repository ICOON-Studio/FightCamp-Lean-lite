# S542 digest (2026-11-23, Fable)

## The owner's words this session
- Q-S294-320 "Yes, build it": the turning pro v17 rules with numbers (`TURNPRO17_RULES_S542.md`).
- "why we restyling ?" then "restyling isnot important i want to finish with all pending mechanics then focus on the 3d
  and menus": ORDER = pending mechanics first, then 3D and menus. Restyle parked, Q-321 closed "Not now".
- Q-S294-322 "Interview me" (coaches), then "Yes to all five", "Yes to all six", "Yes to all six": 17 answers,
  `COACH_INTERVIEW_S542.md` (a staff game; replaces the S539 grill's Q13 and Q14).

## Collected
- CARDROUND8 (Arena PR 449, the guide): merged by diff 5665bd72c; node --test 47/47, gate=play 6/6. The PR's red check
  was the reviewer tool's HTTP 429. Claude played the first bout by hand in the built-in browser (`.claude/launch.json`
  `cardgame`): dead cards drawn alive -> fixed fb893e2bf; round-9 notes in `CARD_R8_CLAUDE_PLAY_S542.md`.
- HOSTLIGHT1 (club show light night, 4e205b1c3): club_show, gym_spend, golden_path PASS on Claude's rerun; the
  Club > Money still opened and on /review; in the build.
- COACHDEEP5 FAIL 7/10 (bar h, the class-or-pads evening trade, third round) -> trade cut by free hand -> COACHDEEP6
  FAIL 7/9 (the weekly pairing is solved by one rule, SMART best 8 of 10; the hire by club size is the real choice) ->
  the owner's interview -> COACHDEEP7 launched (map + quick probe, seven bars), RUNNING at handover.
- BODYCROSS1 (Fable, 49121faa6): `pro_body_cross` take authored offline (hips sink 0.18 m); the 12 body-cross pictures
  re-made; fight_pictures, player2, clip_db PASS on rerun. Pictures only: no rule throws body_cross in the 3D fight.
  Found, not touched: clip_db's `pro_right_cross` row is stale since ActionForge's legs (S537).
- TURNPRO17 (ca087a732): the worker's run at risky purse x1.5 FAILED 4/6; its 300-career check of x1.75 read bar 2 as
  0/10. Claude's full-size rerun at x1.75 (2,000 careers a cell): PASS 6/6 - reader best 9 of 10, beats every habit in
  7 of 10 by 1.2-3.7 points on ~100, safe 36% / risky 64%. Limits: a small edge; the split swings with the purse multiple.
  LESSON: run the full size before any verdict (now in the COACHDEEP7 brief).
- Turning pro v17 critics: Kalli `SCORE depth=5 play=6 general=6` (the price decides, not the matchup; the name buys
  nothing after fight 6; CONFIDENCE doubles an existing trait; "Not yet" has no reason); Dola `SCORE depth=8 play=9
  general=9` (tie the bars to who the boxer is; show confidence's math; patience by ambition; hunger felt in the ring; a
  graduation moment at fight 6). Under the bar (8 + 8 from two critics) -> v18, one round, both lists. A code-checked
  critic is still owed.
- Dola restyle pages C and D rendered (docs/mockups/s542/), A-D on the map - then parked by the owner.

## Decisions (Claude)
- Evening trade cut from the coach design (free hand, S534) before v6.
- Turning pro numbers tuned by the probe: risky purse x2 -> x1.75; safe-win hunger -8 -> -10.
- v18 keeps his two bars and wires them to existing traits (ambition scales hunger, the confidence trait scales the
  knockout hit) rather than dropping the confidence bar as Kalli asks: the bars are his approved design.
- No new animation work until the mechanics are done (his order); CLAUDE.md's "animation progresses every session" needs
  his word before the next animation launch.

## Not done
- Four finished S541 worker processes (P4PEVID1, PICS2D2, COACHDEEP5, HOSTLIGHT1; ~1.4 GB) still open: Stop-Process was
  refused by the permission mode.
- Knowledge v9 (Kalli 7/8/7, Dola 8/7/7): the interview offer was made, no answer yet.
- Card round 9 waits on his round-8 play.

## Build
Exported 2026-11-23 21:15; WHAT_TO_TRY items 6 (club show light night) and 7 (body cross in the pictures).
