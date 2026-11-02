# PLAYTEST PROTOCOL - the first-hour boxer career (S144, 2026-10-02)

Operator S144: "the walk needs to be done from the start without any boxer, maybe only some basic equipment and you need to
evaluate the whole game experience and loop" ... "first evaluate this process and always check how pros do the playtests then
apply the proper methods".

## Why the old walk was not a playtest
`tools/s64_career_walk.gd` + a fixed plan presses known labels in a known order: it proves a PATH EXISTS (a smoke test). It cannot
show whether a new player FINDS the path, UNDERSTANDS it or ENJOYS it, and it started with three ready-made starters. The walker
(Claude) knows the code - expert blindness hides exactly the problems a new player meets.

## What the pros do (sources)
- Design intent first: talk to designers about what players should understand and do; broad tasks ("complete this level"), not
  click lists; observe silently; record "what happened to the player as a result"; bland non-leading questions
  (Bromley, gamesuserresearch.com/find-usability-issues-in-games-with-playtests).
- Severity, 4 levels: start LOW, +1 for each yes - needed to progress? moderator had to step in? player still could not avoid it
  the next time? (same source). Prioritise by severity.
- Think-aloud + observation + questionnaires + heuristic evaluation are the standard mix (Springer "Analyzing and Prioritizing
  Usability Issues in Games"; PlaytestCloud GUR glossary).
- RITE: a few players, fix, a few more (PlaytestCloud). FTUE is a funnel - instrument each step, find the leak
  (GameAnalytics FTUE tips; recognizingpatterns FTUE). Measure sources and sinks of the core loop's economy (GameAnalytics).
- Expert heuristic evaluation: PLAY / HEP heuristics (Desurvire, Kaplan, Toth 2004; Desurvire & Wiberg 2009) - game play,
  mechanics, usability, approachability for new players.

## Design intent (the player's first hour)
You own an empty boxing gym (basic floor equipment, $25,000, no fighters, no staff). Get a boxer, get him ready, book and watch
his first fight, see what it did to him and your gym, and want to do it again.

## Tasks (broad, as told to a tester)
T1 Start a new career. T2 Get your first boxer. T3 Get someone to train him. T4 Train him and see him improve. T5 Find him a fight
and book it. T6 Get him through fight week and the weigh-in. T7 Watch the fight. T8 Understand what the result did (money, fame,
injury, record). T9 Plan what comes next (the loop closes).

## Measures
- FUNNEL: for each task - reached? clicks and in-game weeks to reach it; dead end (no visible way on)?
- COGNITIVE WALKTHROUGH at every screen, answered from the screen only: (1) would a new player know what to do here? (2) would
  they see the control? (3) would they understand what it does? (4) would they see progress after doing it?
- ISSUE LOG: id, task, screen (still), what the player wanted, what happened, what happened to the player as a result, severity
  (LOW/MEDIUM/HIGH/CRITICAL by the 3 questions; for an AI pass "moderator stepped in" = "needed knowledge not on screen").
- PLAY heuristic score per category (game play, mechanics, usability, approachability) 0-3 with one line of evidence each.
- LOOP / ECONOMY over 10 weeks: cash, fame, record, boxer condition per week - does each fight feed the next decision?

## Method, in order
1. AI cold pass (Claude) in the EXPORTED .exe from an empty gym, driven LIVE one screen at a time (no pre-written plan): read the
   screen, decide like a new player, act, screenshot. Log as above. Never use code knowledge to find a button.
2. Fix CRITICAL and HIGH issues (RITE), re-run the pass on the fixed build.
3. OPERATOR session (the real playtest): he plays the .exe cold with the HOME-key desktop recorder, thinking aloud; Claude watches
   the recording frame by frame, logs issues on the same sheet, rates severity. Repeat after fixes.
4. Each pass ends with: funnel table, issue log ranked by severity, PLAY scores, the loop table, and the top 5 fixes.
