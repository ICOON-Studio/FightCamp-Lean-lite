# S449 handover (written 2026-11-13 ~11:30 at the end of S448; S447's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S449`.

## USAGE RULES (kept)
`get_usage` first; hand over at 300k context (S448 handed over at ~390k); at most TWO helpers.

## HIS WORDS IN S448 (verbatim)
- Corner King: "check corner kings contract screen , how it differs from ours can you rate them both, check their coaches ...
  use rea ... when i click the office i want to see an computer screen showing the dashboard with submenus in it (mail,finance,
  Media,Schedule,fighter summary dashboard , coach summary dashboard etc) ... Booking a fight i think is better to be an option
  within a fighters profile tab". Answered: ratings + plan in ops/research/OFFICE_BOOKING_S448.md; order on the board Q-S294-210.
- "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule" -> memory
  feedback_names_only_in_headers_s448, CRITIC_PACK line, sweep helper (see RUNNING).
- Camp: "i want the campsites to be shown graphically with their buffs/stats" / "maybe a location picture for each camp and
  showing icons with toolitips of that drills that camp involves ? and also meters to change sparring weight cut ?" / "interview
  me if you are unsure". His interview answers (section 7 of OFFICE_BOOKING_S448.md): all four locations, "the buffs need to be
  real and reflect in the fight", fight week too, sliders for sparring/weight/load and "add sliders also for technique/power/
  cardio with picture cards", who pays: "affect mood/morale,relationship and not always available for the fighter to pay".
  Mockups docs/mockups/s448/camp_cards/camp_plan(_v2).png, review board 2026-11-13_1115.
- Q-208 marks (his markups 2026-11-13-01..05): organ outline not bubbles, bare numbers; "wtf is that" = the corner's read; bubble
  green when heard, red when ignored -> built (cd7025ef), stills on the review board 2026-11-13_1052. Q-209: "Yes, fight week first".

## RUNNING (collect first)
- NAMES SWEEP: DONE and pushed (eae4f2c6; ops/research/NAMES_IN_HEADERS_S448.md): ~150 body lines rewritten to roles ("your boxer",
  "the opponent", "your coach" - roles, not she/her, because no_pronoun_test forbids pronouns); LANDED box reads YOURS / THEIRS.
  Its open calls for HIM: the first-week guide strip still names the fighter; toasts and news keep names; the "BELL. X'S ROUND"
  banner kept as a header; AskBout/TrainRead lines untouched (not on a screen yet). Ask him in the first message.
- UPPERCUT session (local_06d8cdc0): 10c41edc pushed - lead uppercut 4.7 / 6.9 m/s after the freeze (bar 9.6), hit_frame 13 -> 11,
  punch_speed 49 -> 45; NOT met: three NEW rear-uppercut hit_carry rows and join_return's new RETURN row (2 failures, was 1).
  Finish those (same session has the context) before calling POWER1B done.
- BLOCKLOOK2 round 2 - Grok Dev, PR 245 (grok/blocklook2), brief ops/research/TASK_BLOCKLOOK2_R2.md (arm_block fix approved,
  block_set_test now reads the catch). Collect by RESULT lines; then film blocks in the played fight.
- POWER1B Goose (issue 241) REJECTED (red, abandoned the jump fix) - close the issue if still open.
- SOUND4: collected (69d8682f, 79 takes, voice preset Daniel, 125 credits); PR 244 closed. Ludo 916 credits left.

## WAITING ON HIM (board)
Q-210 build order (fight week + Find a fight, office computer, coach depth, contract ledger); Q-208 regroup default; camp v2
mockup look; Q-208 fixes look; result tabs; Ailive films; voices + PA mix + the S448 sounds by ear.

## NEXT (after collects): AMATEURWEEK1 design map v3 - the camp window shape for the fight week (locations usable, sliders,
who pays, ON FIGHT NIGHT box), Find a fight on the fighter page, the wired-menus table; John checks camp costs (UK cottage/house
rent, mat fees); two fresh critics (CRITIC_PACK + ACCESS) to 7+, then his board.

## TRAPS (S448)
- A seat can claim "no access" without trying (Qwen on Ludo): check the tool yourself before re-briefing.
- The S447 cause note was wrong (quick-back path): the trace showed the reach's own solve losing the glove when the shoulder came
  close. Trace before you brief.
- gbot.py and agent_comms ask --attach take paths relative to ops/ (research/<file>), not the repo root.
- file_limits counts the line after the final newline: wc -l 500 can be 501 for the test.
