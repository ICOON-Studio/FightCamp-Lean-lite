# S541 digest (2026-11-23, 14:30-18:30, Opus, desktop coordinator; a console coordinator ran 15:15-15:35 then was closed)

## Owner answers acted on
- Q-312 "Sign it" + Q-313..317 all Yes: the card game pre-production plan (CARDGAME_PREPROD_S540.md) is signed.
- Card r7 played by the owner (docs/playtest/CARD_R7_OWNER_LOG_S541.md): KO'd in bout 1 at Club; "i didnt understand the design ,
  maybe a guide would be useful" -> CARDROUND8 = the guide (guided first bout, low-health warning, How to play), on Arena.
  Pictures move to r9, balance to r10. Fixed at once: "You's health", "Dropped to Club" at the bottom rung.
- Q-318 "Yes, light night": the club show's five-route card (never built in the game) CUT; HOSTLIGHT1 builds two halls as a
  one-click read + two default reserves.
- "why it keeps failing interviewme" (turning pro, 16 rounds under 8): diagnosis (layers grew per critic list; choices worth a
  few hundred dollars; the honest card solves the decision; the dilemma never settled with him) + a 15-question interview, all
  yes -> TURNPRO_INTERVIEW_S541.md is the new spec. Q-319 answered by it. Owner: "prepare handoff and we continue with the
  design on the next session" - no v17 brief written yet (he stopped it to do the design with him).
- "how can i forbid you to run agents outside the console" -> "Yes, block them": settings deny Agent + start_session.
- "why this is not picked up during the design and critic phase" (coaches v4's uncapped loop) -> "Yes, add it": claude_cm.ps1
  refuses a design/probe brief without "## Feedback loops" (tested rc 4); CLAUDE.md line.
- Comments C479-C494: C481/C482/C484 dodges + reactions -> in PICS2D2; C480 low fps = the film was captured at 10 fps.
- Fable: his reset is fresh ("reset on fable allowance used" = he used his reset). Pocock skills at my discretion.
- Google One upgrade (AI Studio "build limited reached"): not needed - he has AI Pro 5 TB; we use AI Studio only as the video judge.

## Merged / measured
- CARDFIX6B 9aca66f5f (PR 447): the card page loads and plays; 36 tests. CARDROUND7 (PR 448): PLAY gate 6/6, 40 tests.
- GRAPPLEMAP1 02dbb5dc6 (PR 446): 8 BJJ card pictures from GrappleMap (public domain); .gitattributes keeps them LF.
- PICS2D2 5965a8cfb: 2 x 58 pictures, "Watch it in pictures" after a round; body cross 0.18 m high (needs a take).
- P4PEVID1 706a8e2d5: card-ask evidence 0 -> 12/60, t_turn answers the presser; p4p_visit, plan_templates, golden_path PASS
  (run by Claude). Its item-5 matchmaking fix did not help and was reverted.
- HOSTPROBE5 FAIL 6/9 (3rd in a row) -> cut. COACHDEEP4 FAIL 6/10 -> COACHDEEP5 (catchment cap). KNOWSTAKES9 map + probe;
  critics SQ312 (Kalli) / SQ313 (Dola). TURNPROBE16 FAIL 11/16 (reader depth 0/6).
- CARDPREPROD1, MOTIONRULERS1, HOSTPROBE4 collected from S540. Dola restyle page B rendered (bottom third empty); C/D queued.
- Build exported (Builds/FightCamp.exe, WHAT_TO_TRY S541 section).

## Lessons
- A design that keeps failing at the same bar: interview the owner on the dilemma before another round (16 turning-pro rounds,
  5 club-show probes). Grilling skill worked: three rounds of five, all yes, 15 minutes.
- A "Feedback loops" line in every design brief; the launcher enforces it.
- Workers' tabs belong to the session that opened them: a new session cannot list or close them (ListAgents shows them as lean-*).
