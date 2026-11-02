# S367 digest - playtest + critic review, Gemini as the video judge, the Gemini meter (2026-11-02)

Same session as S366 (one repo). Lean commits on s365-bjj-side: 499d6ae..f8dbfc3 (+ this digest).

## Playtest and review (operator: "do a playtest and review", "i want aspect from expert game reviewer")
- layout_snapshot.gd on the hidden desktop: 54 real screens (a steady player's first 7 weeks + a first fight, 35 s);
  s363_stills.gd: 6 BJJ screens; fight3d_film.gd under --write-movie: 4:44 of fight night (hit the 900 s timeout at
  1080p; the unindexed AVI still decoded - next time --resolution 1280x720 really applies only if the script does not
  set its own size). Not hand-played; no audio; the 20-career harness was not run (PC AMBER throughout).
- research/S367_CRITIC_REVIEW.md: 6.5/10 as a preview (7 before the film was judged). Best: Lucy at reception, the
  corner minute, the result's WHAT DECIDED IT. Weak: the week review is a ledger of decimal gains (no reveal), half-empty
  management screens, a sponsor offer that never expires, mail to 22 unread, the 3D fight (3/10 in the review).
- Fixed: the title screen said "Week 3 build" at update 66 - it names no build now (TitleScreen.gd, parse-checked).
- Stills + review on /review S367 ("Playtest: a critic's first hour").

## Gemini as the video judge (operator: "gemini 4 seems to be good", "Free AI Studio", "i can pay", "Use the script route")
- Free AI Studio = Gemini 3.8 Flash; Gemini 4 Argon is paid even in AI Studio. VIDEO FPS DEFAULTS TO 1 - set 24 per clip.
- Pilot (Flash, 3 IN GAME clips): the rear hook drops both hands to the hips (confirmed on frames), the jab clip holds
  two punches, the hurt knockback reads as a duck. research/GEMINI_JUDGE_PILOT_S367.md.
- Browser uploads failed (HTTP 500) after his paid key was linked; the API said why: HTTP 402, prepaid credit -EUR 0.68
  (EUR 5 on 4 Oct, auto-reload off). He bought credits.
- Tools/gemini_judge.py: Files API upload + generateContent at --fps 24; key from env or HKCU\Environment, never printed.
  Argon on 30 s of a live round: 2/10 ($0.1332, 55,830 tokens in) - clinches merge, the referee's break crouches between
  the boxers with an arm through one of them, hits react without contact, feet slide, ~60-70% of real speed, a 180-degree
  orbit mid-exchange. The two worst moments checked on full-resolution frames: true.
- Antigravity (agy 1.3.3) offers Gemini 3.8 Flash / Claude / GPT-OSS on his free quota - NOT Gemini 4 Argon.

## Gemini meter (operator: "can you add the api meter on the board")
- Tools/gemini_meter.py logs every run (exact tokens from the API route), priced at the picker's rates; /api/gemini;
  the main board page (roadmap.html) shows "Gemini <month> spend $x · runs · tokens · last run" under the GitHub line.
  Cap: `python Tools/gemini_meter.py budget <usd>` (none set).

## Queued (board plan.next): REFBREAK, CLINCHMERGE, PHANTOMHIT, CAMORBIT (+ FIGHTSPEED, BJJBIZ)
