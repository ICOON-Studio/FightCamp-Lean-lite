# S520 digest (2026-11-18, Opus)

## What now works
- Ask for a bout opens the day after a boxer's bout (ASKGAP1). The 10-day rest after a bout gates the BOUT, not the
  call: the asked show still falls after the rest (AskFlow.shows drops earlier nights, AskFlow.book refuses them). The
  host's short-notice ask still waits the whole rest. Nothing asked: the sheet's offer comes when the rest ends.
- Why: STREAKPROBE1 found 0 asks in 240 boxer-seasons - the sheet's next offer landed the very day the rest ended, so the
  door was never open on a free day and ducks / OWED never fired.

## Evidence
- docs/ASKGAP1_RESULT.md (streak_probe rerun, 60 runs x 735 days): door open on 671 of 1377 hot Mondays (was 0); 187 asks,
  64 booked; 123 ducks, 48 corners reached OWED, 18 owed bouts booked; points at day 728 within a few of before.
- Tests green: ask_bout (new cases + mutant "ASKGAP1 undone"), ask_dates, ask_wire (1b/1c rewritten), hot_streak,
  ladder_points, ladder_table, late_ask, rival_offer_wire, roster_rows_page, next_offer, golden_path, club_week_walk.
- Build exported (Builds/FightCamp.exe), WHAT_TO_TRY S520 on top.

## Decided (Claude, design; plain words)
- Rest gates the bout, not the phone call - like a real corner ringing the matchmaker the day after a fight. Rejected:
  a 17-day sheet gap (slows every career by a week a bout) and an ask that replaces the waiting sheet offer (the door
  would still be shut on most Mondays: a booked bout and the rest closed 94%).
- Q-S294-273 "what do you think ?": full pads (his Q-260), as built.

## Delegated
- MORNINGSPROBE2 and MONEYFOUR2 briefed (ops/research/TASK_*.md, contracts checked) and queued for Qwen behind TREEVALUE2.
- PRs #373 / #374 closed: already collected (S517b / S518b).

## Open
- The STREAKPROBE1 qwen process (pid 25840) never exited; TREEVALUE2 waits on it. Stopping it was refused by the
  permission check.
- streak_probe's ask policy never picks the corner that owes her (Josh: OWED 10x, booked 0) - a probe policy, next session.
